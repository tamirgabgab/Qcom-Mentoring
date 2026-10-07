#!/usr/bin/env python3
"""
model.py -- turn the raw structure (extract.py) + annotations.yaml into the
project-map model: nodes, edges and class information, ready for layout.py.

Node ids
    hierarchy / TLM : instance paths            tb.yapp.agent.monitor, tb.router_module.yapp_export
    hardware        : hw_top, hw_top.dut, hw_top.in0, hw_top.dut.g_fifo[0].u_fifo, hw_top.dut#input_fsm
    classes         : cls:<name>                cls:yapp_tx_monitor
"""
import fnmatch
import glob
import os
import re
import sys

import yaml
from . import extract

ROOT = extract.ROOT
HERE = os.path.dirname(os.path.abspath(__file__))

UVM_COMPONENT_KINDS = [
    ("uvm_test", "test"), ("uvm_env", "env"), ("uvm_agent", "agent"), ("uvm_driver", "driver"),
    ("uvm_monitor", "monitor"), ("uvm_scoreboard", "scoreboard"), ("uvm_sequencer", "sequencer"),
    ("uvm_subscriber", "component"), ("uvm_component", "component"),
]
UVM_OBJECT_KINDS = [
    ("uvm_sequence", "sequence"), ("uvm_sequence_item", "sequence_item"), ("uvm_reg_block", "reg_block"),
    ("uvm_reg_adapter", "reg_adapter"), ("uvm_reg_field", "object"), ("uvm_reg", "reg"), ("uvm_mem", "mem"),
    ("uvm_object", "object"),
]
PORT_KINDS = [
    ("uvm_analysis_port", "tlm_port"), ("uvm_analysis_export", "tlm_export"), ("uvm_analysis_imp", "tlm_imp"),
    ("uvm_tlm_analysis_fifo", "tlm_fifo"), ("uvm_tlm_fifo", "tlm_fifo"), ("uvm_get_port", "get_port"),
    ("uvm_blocking_get_port", "get_port"), ("uvm_seq_item_pull_port", "seq_item_port"),
    ("uvm_seq_item_pull_export", "seq_item_port"),
]


def load_annotations(path=os.path.join(HERE, "annotations.yaml")):
    with open(path) as fh:
        return yaml.safe_load(fh)


# ----------------------------------------------------------------------------- helpers
def class_kind(cls):
    """Kind of a class from its base chain + name heuristics."""
    chain = cls["chain_names"]
    name = cls["name"]
    if "uvm_sequencer_base" in chain or "uvm_sequencer" in chain:
        # a sequencer whose only properties are other sequencers is a virtual sequencer
        subs = [p for p in cls["properties"] if p["is_class"] and "uvm_sequencer_base" in p["chain"]
                or (p["is_class"] and any(x.startswith("uvm_sequencer") for x in p["chain"]))]
        if subs and not any(not p["is_class"] for p in cls["properties"]):
            return "vsequencer"
        return "sequencer"
    if "uvm_test" in chain:
        return "test"
    if "reference" in name and "uvm_component" in chain and "uvm_env" not in chain:
        return "reference"
    if "scoreboard" in name and "uvm_component" in chain and "uvm_env" not in chain:
        return "scoreboard"
    for base, kind in UVM_COMPONENT_KINDS:
        if base in chain:
            return kind
    for base, kind in UVM_OBJECT_KINDS:
        if base in chain:
            return kind
    return "object"


def port_kind(type_name):
    for prefix, kind in PORT_KINDS:
        if type_name.startswith(prefix):
            return kind
    return None


def item_type_of(base_str):
    """uvm_sequence#(yapp_packet,uvm_pkg::...) -> yapp_packet"""
    if not base_str:
        return None
    m = re.search(r"#\(\s*([\w:]+)", base_str)
    return m.group(1).split("::")[-1] if m else None


FILE_CACHE = {}


def read_file(path):
    """The whole source file as plain text (highlighted in the browser). Every class lives in its
    own file, so the map shows the file and marks the item's line range inside it."""
    if path not in FILE_CACHE:
        full = os.path.join(ROOT, path)
        try:
            with open(full, encoding="utf-8") as fh:
                FILE_CACHE[path] = fh.read().rstrip("\n")
        except OSError:
            FILE_CACHE[path] = ""
    return FILE_CACHE[path]


# ----------------------------------------------------------------------------- lab scan
LAB_RE_CACHE = {}


def _scan_files(files, label, found):
    for f in files:
        try:
            txt = open(f, encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        for m in re.finditer(r"^\s*(?:virtual\s+)?(class|module|interface)\s+(\w+)", txt, re.M):
            found.setdefault(m.group(2), label)
        for m in re.finditer(r"typedef\s+enum[^;]*?\}\s*(\w+)\s*;", txt, re.S):
            found.setdefault(m.group(1), label)


def scan_labs(ann):
    """class/module/interface name -> first lab label in which it appears.

    Pass 1 scans the files inside each lab directory (course order); pass 2 scans the
    shared files each lab's run.f references (the provided UVCs appear with Lab 7)."""
    found = {}
    for lab_dir, meta in ann["labs"].items():
        files = sorted(glob.glob(os.path.join(ROOT, "labs", lab_dir, "**", "*.sv"), recursive=True))
        _scan_files(files, meta["label"], found)
    for lab_dir, meta in ann["labs"].items():
        for run_f in glob.glob(os.path.join(ROOT, "labs", lab_dir, "**", "run.f"), recursive=True):
            base = os.path.dirname(run_f)
            refs = []
            for line in open(run_f, encoding="utf-8", errors="replace"):
                line = line.split("//")[0].strip()
                if line.endswith(".sv") and not line.startswith(("-", "+")):
                    refs.append(os.path.normpath(os.path.join(base, line)))
            # a package `include`s its files: scan the whole directory of each referenced file
            dirs = sorted({os.path.dirname(r) for r in refs})
            files = []
            for d in dirs:
                files += sorted(glob.glob(os.path.join(d, "**", "*.sv"), recursive=True))
            _scan_files(files, meta["label"], found)
    return found


# ----------------------------------------------------------------------------- the builder
class ModelBuilder:
    def __init__(self, raws, ann):
        self.ann = ann
        self.primary = raws[0]
        self.raws = raws
        self.classes = {}          # name -> class info (primary wins)
        self.class_variant = {}    # name -> lab label of the variant (secondary sources only)
        for i, raw in enumerate(raws):
            for name, c in raw["classes"].items():
                if name not in self.classes:
                    self.classes[name] = c
                    if i > 0:
                        self.class_variant[name] = raw["source"]
        self.enums = {}
        for raw in raws:
            for k, v in raw["enums"].items():
                self.enums.setdefault(k, v)
        self.nodes = {}
        self.edges = []
        self.edge_ids = set()
        self.lab_of_name = scan_labs(ann)
        self.lab_pages = {m["label"]: m for m in ann["labs"].values()}
        self.unresolved = []

    # -------------------------------------------------------------- node helpers
    def add_node(self, nid, **kw):
        n = {"id": nid, "children": []}
        n.update(kw)
        self.nodes[nid] = n
        parent = kw.get("parent")
        if parent and parent in self.nodes:
            self.nodes[parent]["children"].append(nid)
        return n

    def add_edge(self, kind, frm, to, **kw):
        key = (kind, frm, to, kw.get("label"), kw.get("via"))
        if key in self.edge_ids:
            return None
        self.edge_ids.add(key)
        e = {"id": f"e{len(self.edges) + 1}", "kind": kind, "from": frm, "to": to}
        e.update(kw)
        self.edges.append(e)
        return e

    def lab_for(self, name, nid=None):
        ov = self.ann.get("lab_overrides", {})
        if nid and nid in ov:
            return str(ov[nid])
        if name in ov:
            return str(ov[name])
        return self.lab_of_name.get(name)

    def lab_link(self, label):
        meta = self.lab_pages.get(label)
        if not meta:
            return None
        return {"title": f"Lab {label} — {meta['title']}", "url": meta["page"]}

    def describe(self, name):
        c = self.ann.get("classes", {}).get(name) or {}
        return c.get("summary", ""), c.get("description", "")

    # ------------------------------------------------------------ instance tree
    def build_instances(self):
        root_test = self.ann["root_test"]
        self.add_node("tb_top", kind="module", name="tb_top", type="tb_top", parent=None, scope="hw",
                      lab=self.lab_for("tb_top", "tb_top"), **self.module_info("tb_top"))
        test_cls = self.classes[root_test]
        self.add_node("uvm_test_top", kind="test", name="uvm_test_top", type=root_test, parent="tb_top",
                      cls=f"cls:{root_test}", scope="tb", lab=self.lab_for(root_test),
                      alternatives=sorted(n for n, c in self.classes.items()
                                          if class_kind(c) == "test" and n != root_test))
        self.expand_component("", test_cls, "uvm_test_top")
        # variant: lab09d fifo_sb (classes only in a secondary source whose router_tb differs)
        self.add_variants()

    def array_size(self, path, prop, owner_cls):
        sizes = self.ann.get("array_sizes", {})
        if path in sizes:
            return int(sizes[path])
        if prop["dims"] and prop["dims"] != "[]":
            return int(prop["dims"].strip("[]"))
        # dynamic array: look for a num_<x> property default or config set
        return 1

    @staticmethod
    def join(path, name):
        return name if not path else f"{path}.{name}"

    def expand_component(self, path, cls, parent_id):
        """Create child nodes (components, ports, objects) of the instance `path` (node id) of class
        `cls`; `parent_id` is the node that owns them (differs from `path` only for the test)."""
        parent_id = parent_id or path
        created = set()
        for cr in cls.get("creates", []):
            nm = cr["name"].strip()
            m = re.search(r'"(\w+)', nm)
            if m:
                created.add(m.group(1))
        for prop in cls["properties"]:
            if not prop["is_class"]:
                continue
            tn = prop["type_name"]
            chain = prop["chain"]
            pk = port_kind(tn)
            if pk:
                count = 1
                names = [prop["name"]]
                if prop["dims"]:
                    count = self.array_size(f"{path}.{prop['name']}", prop, cls)
                    names = [f"{prop['name']}[{i}]" for i in range(count)]
                for nm in names:
                    nid = self.join(path, nm)
                    self.add_node(nid, kind=pk, name=nm, type=prop["type"], parent=parent_id, scope="tb",
                                  port=True, lab=self.lab_for(f"{cls['name']}.{prop['name']}", nid)
                                  or self.lab_for(cls["name"]))
                continue
            if "uvm_component" in chain:
                if created and prop["name"] not in created:
                    continue        # a handle to a component owned elsewhere (virtual sequencer, tests)
                if class_kind(cls) in ("vsequencer", "sequencer", "driver", "monitor"):
                    continue        # sequencers/drivers/monitors never own components: these are handles
                count = 1
                names = [prop["name"]]
                if prop["dims"]:
                    count = self.array_size(f"{path}.{prop['name']}", prop, cls)
                    names = [f"{prop['name']}[{i}]" for i in range(count)]
                sub = self.classes.get(tn)
                if sub is None:
                    continue
                for nm in names:
                    nid = self.join(path, nm)
                    self.add_component_node(nid, nm, sub, parent=parent_id)
                    self.expand_component(nid, sub, nid)
                continue
            if any(k in chain for k in ("uvm_reg_block", "uvm_reg_adapter", "uvm_reg", "uvm_mem")) \
                    and "uvm_reg_field" not in chain:
                sub = self.classes.get(tn)
                nid = self.join(path, prop["name"])
                kind = class_kind(sub) if sub else "object"
                self.add_component_node(nid, prop["name"], sub or {"name": tn, "chain_names": chain,
                                                                   "properties": [], "methods": [],
                                                                   "constraints": [], "file": None, "line": 0,
                                                                   "end_line": 0}, parent=parent_id, kind=kind)
                if sub:
                    self.expand_component(nid, sub, nid)
                continue
            # sequencer handles (virtual sequencer), sequences, items: not instances

        # implicit ports of drivers and sequencers (inherited, so not in the property list)
        kind = class_kind(cls)
        if kind == "driver" and f"{path}.seq_item_port" not in self.nodes:
            self.add_node(f"{path}.seq_item_port", kind="seq_item_port", name="seq_item_port",
                          type="uvm_seq_item_pull_port #(REQ, RSP)", parent=parent_id, scope="tb", port=True,
                          implicit=True, lab=self.lab_for(cls["name"]))
        if kind == "sequencer" and f"{path}.seq_item_export" not in self.nodes:
            self.add_node(f"{path}.seq_item_export", kind="seq_item_port", name="seq_item_export",
                          type="uvm_seq_item_pull_imp #(REQ, RSP, this)", parent=parent_id, scope="tb", port=True,
                          implicit=True, lab=self.lab_for(cls["name"]))

    def add_component_node(self, nid, name, cls, parent, kind=None):
        kind = kind or class_kind(cls)
        n = self.add_node(nid, kind=kind, name=name, type=cls["name"], parent=parent, scope="tb",
                          cls=f"cls:{cls['name']}", lab=self.lab_for(cls["name"], nid))
        return n

    def add_variants(self):
        """Classes of router_tb that exist only in a secondary source (lab09d: fifo_sb)."""
        prim_tb = self.primary["classes"].get("router_tb")
        prim_props = {p["name"] for p in prim_tb["properties"]} if prim_tb else set()
        for raw in self.raws[1:]:
            tb = raw["classes"].get("router_tb")
            if not tb:
                continue
            extra = [p for p in tb["properties"] if p["name"] not in prim_props and p["is_class"]
                     and "uvm_component" in p["chain"]]
            for p in extra:
                sub = self.classes.get(p["type_name"])
                if not sub:
                    continue
                nid = f"tb.{p['name']}"
                n = self.add_component_node(nid, p["name"], sub, parent="tb")
                n["variant"] = raw["source"]
                self.expand_component(nid, sub, nid)
                for c in tb["connects"]:
                    if p["name"] in c["this"] or p["name"] in c["arg"]:
                        self.resolve_connect("tb", c, tb, variant=raw["source"])

    # ------------------------------------------------------------- modules side
    def module_info(self, name):
        for raw in self.raws:
            m = raw["modules"].get(name)
            if m:
                return {"file": m["file"], "line": m["line"], "end_line": m["end_line"]}
        return {}

    def build_hardware(self):
        hw = self.primary["modules"].get("hw_top")
        if not hw:
            return
        self.add_node("hw_top", kind="module", name="hw_top", type="hw_top", parent=None, scope="hw",
                      file=hw["file"], line=hw["line"], end_line=hw["end_line"],
                      signals=hw["signals"], lab=self.lab_for("hw_top", "hw_top"))
        net_users = {}   # net -> [(instance id, port, dir)]
        for inst in hw["instances"]:
            nid = f"hw_top.{inst['name']}"
            kind = "interface" if inst["kind"] == "interface" else "module"
            self.add_node(nid, kind=kind, name=inst["name"], type=inst["definition"], parent="hw_top",
                          scope="hw", file=inst["file"], line=inst["line"], end_line=inst["end_line"],
                          ports=inst["ports"], signals=inst["signals"], tasks=inst["tasks"],
                          params=inst["params"], lab=self.lab_for(inst["definition"], nid))
            dirs = {p["name"]: p["dir"] for p in inst["ports"]}
            for pc in inst.get("port_connections", []):
                if pc["expr"]:
                    net_users.setdefault(pc["expr"], []).append((nid, pc["port"], dirs.get(pc["port"], "?")))
            if inst["name"] == "dut":
                self.build_dut(nid, inst)
        # edges between instances that share a net / an interface signal
        pair_labels = {}
        for net, users in net_users.items():
            if "." in net:   # interface signal: in0.in_data -> the interface instance is the other side
                ifname = net.split(".")[0]
                for (nid, port, d) in users:
                    other = f"hw_top.{ifname}"
                    if other not in self.nodes:
                        continue
                    src, dst = (other, nid) if d == "in" else (nid, other) if d == "out" else (other, nid)
                    pair_labels.setdefault((src, dst, d == "inout"), []).append(net.split(".")[1])
            elif len(users) > 1:
                outs = [u for u in users if u[2] == "out"]
                ins = [u for u in users if u[2] != "out"]
                if outs:
                    for o in outs:
                        for i in ins:
                            pair_labels.setdefault((o[0], i[0], False), []).append(net)
                else:
                    a, b = users[0], users[1]
                    pair_labels.setdefault((a[0], b[0], True), []).append(net)
        merged = {}
        for (src, dst, bidir), nets in pair_labels.items():
            key = tuple(sorted((src, dst)))
            m = merged.setdefault(key, {"src": src, "dst": dst, "nets": [], "dirs": set()})
            m["nets"] += nets
            m["dirs"].add("both" if bidir else ("fwd" if (src, dst) == key else "rev"))
        for key, m in merged.items():
            bidir = len(m["dirs"]) > 1 or "both" in m["dirs"]
            nets = sorted(set(m["nets"]))
            kind = "port"
            # the clock / reset fan-out to every interface is noise in the picture: keep it for the
            # panel only (kind "clock"); the DUT and the clock generator keep their edges
            ifs = {x for x in (m["src"], m["dst"]) if self.nodes[x]["kind"] == "interface" and x != "hw_top.clk_rst_if"}
            if set(nets) <= {"clock", "reset"} and ifs:
                kind = "clock"
            self.add_edge(kind, m["src"], m["dst"], label=", ".join(nets), bidir=bidir)

    def build_dut(self, dut_id, inst):
        for g in inst.get("generate", []):
            for sub in g["instances"]:
                nid = f"{dut_id}.{sub['name']}"
                self.add_node(nid, kind="module", name=sub["name"], type=sub["definition"], parent=dut_id,
                              scope="hw", file=sub["file"], line=sub["line"], end_line=sub["end_line"],
                              ports=sub["ports"], signals=sub["signals"], params=sub["params"],
                              lab=self.lab_for("yapp_fifo", nid) or "6",
                              summary="Synchronous 16 x 8 FIFO: one per output channel.")
        sym_index = {}
        for s in inst["signals"] + inst["ports"]:
            sym_index[s["name"]] = s
        for t in inst["typedefs"]:
            sym_index[t["name"]] = {"name": t["name"], "type": t["type"], "line": t["line"]}
        for p in inst["params"]:
            sym_index[p["name"]] = {"name": p["name"], "type": "localparam", "line": p["line"], "value": p["value"]}
        block_ids = {}
        for b in self.ann.get("dut_blocks", []):
            nid = f"{dut_id}#{b['id']}"
            block_ids[b["id"]] = nid
            syms = [sym_index[s] for s in b.get("symbols", []) if s in sym_index]
            self.add_node(nid, kind="rtl_block", name=b["name"], type="yapp_router", parent=dut_id, scope="hw",
                          file=inst["file"], line=b["lines"][0], end_line=b["lines"][1], signals=syms,
                          summary=b.get("summary", ""), description=b.get("description", ""), lab="6")
        for frm, to, label in self.ann.get("dut_flows", []):
            f = block_ids.get(frm, frm)
            t = block_ids.get(to, to)
            if f in self.nodes and t in self.nodes:
                self.add_edge("flow", f, t, label=label)
        # the generate instances belong to the FIFO block
        for g in inst.get("generate", []):
            for sub in g["instances"]:
                if "fifos" in block_ids:
                    self.add_edge("flow", block_ids["fifos"], f"{dut_id}.{sub['name']}", label="instance",
                                  dashed=True)

    # ----------------------------------------------------------------- edges
    def resolve_path(self, base, text, cls_props=None):
        """Resolve a hierarchical text like `yapp.agent.monitor.item_collected_port` relative to node `base`."""
        text = text.strip()
        if text.startswith("this."):
            text = text[5:]
        segs = text.split(".")
        cur = base
        for i, seg in enumerate(segs):
            cand = self.join(cur, seg) if cur != "uvm_test_top" else seg
            if cand in self.nodes:
                cur = cand
                continue
            # FIFO sub-exports: yapp_fifo.analysis_export / get_peek_export -> the fifo node
            if self.nodes.get(cur, {}).get("kind") == "tlm_fifo" and seg in ("analysis_export", "get_peek_export",
                                                                             "get_export", "put_export"):
                return cur, seg
            # default_map on a reg block -> the block itself
            if self.nodes.get(cur, {}).get("kind") == "reg_block" and seg in ("default_map",):
                return cur, seg
            return None, None
        return cur, None

    def expand_index(self, text, cls):
        """`chan_export[i]` -> ['chan_export[0]', 'chan_export[1]', 'chan_export[2]'] using the array size."""
        m = re.search(r"(\w+)\[([A-Za-z_]\w*)\]", text)
        if not m:
            return [text]
        prop = next((p for p in cls["properties"] if p["name"] == m.group(1)), None)
        n = int(prop["dims"].strip("[]")) if prop and prop["dims"] and prop["dims"] != "[]" else 3
        return [text.replace(m.group(0), f"{m.group(1)}[{i}]") for i in range(n)]

    def resolve_connect(self, base, c, cls, variant=None):
        this_list = self.expand_index(c["this"], cls)
        arg_list = self.expand_index(c["arg"], cls)
        if len(this_list) != len(arg_list):
            arg_list = arg_list * len(this_list)
        for t, a in zip(this_list, arg_list):
            frm, fsub = self.resolve_path(base, t)
            to, tsub = self.resolve_path(base, a)
            if not frm or not to:
                self.unresolved.append(f"{cls['name']}: {t}.connect({a}) relative to {base}")
                continue
            kind = "connect"
            if self.nodes[frm]["kind"] == "seq_item_port":
                kind = "seq_item"
            elif self.nodes[frm]["kind"] == "get_port":
                kind = "get"
            label = None
            if fsub or tsub:
                label = ".".join(x for x in (fsub, tsub) if x)
            e = self.add_edge(kind, frm, to, label=label, file=cls["file"], line=c["line"], in_class=cls["name"])
            if e is not None and variant:
                e["variant"] = variant

    def build_edges(self):
        # connect()/set_sequencer/handles for every instance of every class
        for nid, n in list(self.nodes.items()):
            cname = n.get("type")
            cls = self.classes.get(cname)
            if not cls or n.get("scope") != "tb" or n.get("port"):
                continue
            for c in cls["connects"]:
                self.resolve_connect(nid, c, cls)
            for s in cls["set_sequencer"]:
                blk, _ = self.resolve_path(nid, s["map"].replace(".default_map", ""))
                seqr, _ = self.resolve_path(nid, s["seqr"] or "")
                via, _ = self.resolve_path(nid, s["adapter"] or "")
                if blk and seqr:
                    self.add_edge("reg_adapter", blk, seqr, via=via, label="default_map.set_sequencer()",
                                  file=cls["file"], line=s["line"], in_class=cls["name"])
                else:
                    self.unresolved.append(f"{cls['name']}: set_sequencer {s}")
            for h in cls["handle_assign"]:
                if "." not in h["lhs"] or "create" in h["rhs"] or not h["rhs"]:
                    continue
                owner_txt, handle = h["lhs"].rsplit(".", 1)
                owner, _ = self.resolve_path(nid, owner_txt)
                target, _ = self.resolve_path(nid, h["rhs"])
                if owner and target:
                    self.add_edge("handle", owner, target, label=handle, file=cls["file"], line=h["line"],
                                  in_class=cls["name"])
                else:
                    self.unresolved.append(f"{cls['name']}: handle {h}")
            if cls.get("hdl_root"):
                blk, _ = self.resolve_path(nid, cls["hdl_root"]["block"] or "")
                tgt = cls["hdl_root"]["path"]
                if blk and tgt in self.nodes:
                    self.add_edge("backdoor", blk, tgt, label=f'set_hdl_path_root("{tgt}")', file=cls["file"],
                                  line=cls["hdl_root"]["line"], in_class=cls["name"])
        # vif edges: components with a virtual interface field -> hw instance (tb_top bindings)
        bindings = self.primary.get("vif_bindings", [])
        for nid, n in list(self.nodes.items()):
            cls = self.classes.get(n.get("type"))
            if not cls or n.get("scope") != "tb" or n.get("port"):
                continue
            vifs = [p for p in cls["properties"] if p["is_vif"]]
            if not vifs:
                continue
            full = nid if nid == "uvm_test_top" else f"uvm_test_top.{nid}"
            for b in bindings:
                if fnmatch.fnmatchcase(full, b["glob"]) or fnmatch.fnmatchcase(full + ".x", b["glob"]):
                    tgt = b["target"]
                    if tgt in self.nodes:
                        self.add_edge("vif", nid, tgt, label=f"{b['field']} = {tgt}", file=None,
                                      line=b["line"], in_class="tb_top")
                    break

    # ---------------------------------------------------------------- classes
    def build_classes(self):
        groups = self.ann["groups"]
        uvm_bases = set()
        for name, cls in sorted(self.classes.items()):
            kind = class_kind(cls)
            summary, description = self.describe(name)
            item = item_type_of(cls["base"])
            n = self.add_node(
                f"cls:{name}", kind=kind, name=name, type=name, parent=None, scope="cls",
                group=cls["scope"], group_label=groups.get(cls["scope"], {}).get("label", cls["scope"]),
                base=cls["base_name"], base_full=cls["base"], chain=cls["chain_names"],
                file=cls["file"], line=cls["line"], end_line=cls["end_line"],
                fields=[self.field_info(p) for p in cls["properties"]],
                methods=cls["methods"], constraints=cls["constraints"],
                summary=summary, description=description,
                lab=self.lab_for(name), item_type=item,
                overrides=cls.get("overrides", []), config_sets=cls.get("config_sets", []),
                notable_calls=cls.get("notable_calls", []),
                source=self.class_variant.get(name),
            )
            # inheritance
            if cls["base_name"]:
                if cls["base_name"] in self.classes:
                    self.add_edge("inherits", f"cls:{name}", f"cls:{cls['base_name']}")
                else:
                    uvm_bases.add(cls["base_name"])
                    self.add_edge("inherits", f"cls:{name}", f"uvm:{cls['base_name']}")
            # sequences: which sequencer they run on, which sequences they use
            if kind == "sequence":
                psq = next((p for p in cls["properties"] if p["name"] == "p_sequencer"), None)
                if psq:
                    self.add_edge("runs_on", f"cls:{name}", f"cls:{psq['type_name']}", label="p_sequencer")
                elif item:
                    for sn, sc in self.classes.items():
                        if class_kind(sc) == "sequencer" and item_type_of(sc["base"]) == item \
                                and sc["scope"] == cls["scope"]:
                            self.add_edge("runs_on", f"cls:{name}", f"cls:{sn}", label=f"#({item})")
                for used in cls["uses_sequences"]:
                    if used in self.classes:
                        self.add_edge("uses", f"cls:{name}", f"cls:{used}")
            # drivers / sequencers: item type
            # tests: default sequences and overrides
            for s in cls.get("config_sets", []):
                if s["field"] == "default_sequence":
                    seq = s["value"].replace("::get_type()", "").strip()
                    if seq in self.classes:
                        self.add_edge("starts", f"cls:{name}", f"cls:{seq}", label=s["inst"])
            for o in cls.get("overrides", []):
                if len(o["args"]) >= 2 and o["args"][0] in self.classes and o["args"][1] in self.classes:
                    self.add_edge("overrides", f"cls:{name}", f"cls:{o['args'][1]}",
                                  label=f"replaces {o['args'][0]}")
        for b in sorted(uvm_bases):
            self.add_node(f"uvm:{b}", kind="uvm_base", name=b, type=b, parent=None, scope="cls", group="uvm",
                          group_label="UVM library", summary=f"UVM library class {b}.", external=True)
        for name, e in self.enums.items():
            self.add_node(f"cls:{name}", kind="enum", name=name, type=name, parent=None, scope="cls",
                          group=e["scope"], group_label=groups.get(e["scope"], {}).get("label", e["scope"]),
                          file=e["file"], line=e["line"], end_line=e["line"], values=e["values"],
                          summary="enum: " + ", ".join(e["values"]), lab=self.lab_for(name))

    def field_info(self, p):
        role = "data"
        if p["is_vif"]:
            role = "vif"
        elif p["is_class"] and port_kind(p["type_name"]):
            role = "port"
        elif p["is_class"] and "uvm_component" in p["chain"]:
            role = "child"
        elif p["is_class"] and any(x.startswith("uvm_sequencer") for x in p["chain"]):
            role = "handle"
        elif p["is_class"] and "uvm_reg_field" in p["chain"]:
            role = "reg_field"
        elif p["is_class"] and "uvm_sequence" in p["chain"]:
            role = "sequence"
        elif p["is_class"]:
            role = "object"
        if p["type_name"] == "covergroup":
            role = "covergroup"
        return {"name": p["name"], "type": p["type"].replace("$", ""), "rand": p["rand"], "randc": p["randc"],
                "role": role, "line": p["line"], "dims": p["dims"]}

    # --------------------------------------------------------------- finishing
    def finish(self):
        kinds = self.ann["kinds"]
        node_ann = self.ann.get("nodes", {})
        notes = self.ann.get("notes", {})
        for nid, n in self.nodes.items():
            k = n["kind"]
            kinfo = kinds.get(k, {})
            n["kind_label"] = kinfo.get("label", k)
            cls = self.classes.get(n.get("type")) if n.get("scope") == "tb" else None
            if cls and "summary" not in n:
                s, d = self.describe(cls["name"])
                n["summary"], n["description"] = s, d
                n["file"], n["line"], n["end_line"] = cls["file"], cls["line"], cls["end_line"]
                n["chain"] = cls["chain_names"]
                n["base"] = cls["base_name"]
                n["fields"] = [self.field_info(p) for p in cls["properties"]]
                n["methods"] = cls["methods"]
                n["constraints"] = cls["constraints"]
            if n.get("port") and "summary" not in n:
                n["summary"] = kinfo.get("role", "")
            if nid in node_ann:
                for key, val in node_ann[nid].items():
                    n[key] = val
            if nid in notes:
                n["note"] = notes[nid]
            n.setdefault("summary", kinfo.get("role", ""))
            n.setdefault("description", "")
            # docs links
            docs = list(n.get("docs", []))
            if kinfo.get("doc") and not any(d["url"] == kinfo["doc"] for d in docs):
                docs.append({"title": f"{kinfo['label']} guide", "url": kinfo["doc"]})
            lab = n.get("lab")
            if lab:
                ll = self.lab_link(lab)
                if ll:
                    docs.append(ll)
            n["docs"] = docs
            n.setdefault("lab", None)
        # port connection lists on each node (for the panel)
        for e in self.edges:
            for end, other in (("from", "to"), ("to", "from")):
                n = self.nodes.get(e[end])
                if n is not None:
                    n.setdefault("edges", []).append(e["id"])
        # TLM paths: producer port -> ... -> terminal imp/fifo through connect edges
        adj = {}
        for e in self.edges:
            if e["kind"] in ("connect", "seq_item", "get"):
                adj.setdefault(e["from"], []).append(e)
        self.paths = []
        for e in self.edges:
            if e["kind"] == "connect" and self.nodes[e["from"]]["kind"] == "tlm_port":
                stack = [(e["from"], [e["id"]], e["to"])]
                while stack:
                    start, eids, cur = stack.pop()
                    nxt = adj.get(cur, [])
                    if not nxt or self.nodes[cur]["kind"] in ("tlm_imp", "tlm_fifo"):
                        self.paths.append({"from": start, "to": cur, "edges": eids})
                    for ne in nxt:
                        if ne["id"] not in eids:
                            stack.append((start, eids + [ne["id"]], ne["to"]))

    def build(self):
        self.build_instances()
        self.build_hardware()
        self.build_edges()
        self.build_classes()
        self.finish()
        return {
            "meta": {"sources": [r["source"] for r in self.raws], "pyslang": __import__("pyslang").__version__},
            "kinds": self.ann["kinds"],
            "groups": self.ann["groups"],
            "labs": self.ann["labs"],
            "nodes": self.nodes,
            "files": {f: read_file(f) for f in sorted({n["file"] for n in self.nodes.values() if n.get("file")}) if read_file(f)},
            "edges": self.edges,
            "paths": self.paths,
            "unresolved": self.unresolved,
        }


def build_model(ann=None, raws=None):
    ann = ann or load_annotations()
    if raws is None:
        raws = [extract.extract(os.path.join(ROOT, s)) for s in ann["sources"]]
    return ModelBuilder(raws, ann).build()


if __name__ == "__main__":
    import json
    m = build_model()
    print(f"nodes: {len(m['nodes'])}  edges: {len(m['edges'])}  paths: {len(m['paths'])}")
    from collections import Counter
    print("edge kinds:", Counter(e["kind"] for e in m["edges"]))
    print("node kinds:", Counter(n["kind"] for n in m["nodes"].values()))
    if m["unresolved"]:
        print("UNRESOLVED:")
        for u in m["unresolved"]:
            print("  ", u)
    if len(sys.argv) > 1:
        json.dump(m, open(sys.argv[1], "w"), indent=0)
