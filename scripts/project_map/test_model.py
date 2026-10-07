"""
test_model.py -- consistency checks of the generated project map.

Run through `python3 -m scripts.project_map.build --check` (also in CI) or with
pytest: `pytest scripts/project_map/test_model.py`.
"""
import os
from collections import Counter

from . import extract

ROOT = extract.ROOT


def run_all(m, model_json, html):
    N, E = m["nodes"], m["edges"]
    kinds = Counter(e["kind"] for e in E)
    cls = [n for n in N.values() if n.get("scope") == "cls" and n["kind"] not in ("uvm_base", "enum")]
    problems = []

    def expect(cond, msg):
        if not cond:
            problems.append(msg)

    expect(len(cls) >= 80, f"expected >= 80 classes, got {len(cls)}")
    expect(not m["unresolved"], f"unresolved connections: {m['unresolved']}")
    # connect() calls: router_tb 5 + router_module_env 6 + fifo_sb variant (5 in router_tb + 5 internal)
    by_class = Counter(e.get("in_class") for e in E if e["kind"] == "connect")
    expect(by_class["router_tb"] == 10, f"router_tb connects: {by_class['router_tb']} (5 primary + 5 lab09d)")
    expect(by_class["router_module_env"] == 6, f"router_module_env connects: {by_class['router_module_env']}")
    expect(by_class["router_fifo_scoreboard"] == 5, f"router_fifo_scoreboard connects: {by_class['router_fifo_scoreboard']}")
    expect(kinds["get"] == 5, f"get edges: {kinds['get']}")
    expect(kinds["seq_item"] == 6, f"seq_item edges: {kinds['seq_item']} (yapp, hbus, chan x3, clk_rst)")
    expect(kinds["vif"] == 11, f"vif edges: {kinds['vif']}")
    expect(kinds["handle"] == 2, f"virtual sequencer handles: {kinds['handle']}")
    expect(kinds["reg_adapter"] == 1 and kinds["backdoor"] == 1, "register model wiring (set_sequencer / hdl root)")
    expect(len([n for n in N.values() if n.get("parent") == "hw_top"]) == 8, "hw_top must have 8 instances")
    expect(len([n for n in N.values() if n.get("type") == "yapp_output_channel"]) == 3, "3 output channels")
    expect(len([n for n in N.values() if n.get("type") == "yapp_fifo"]) == 3, "3 yapp_fifo instances (inside the channels)")
    expect(sorted(N["hw_top.dut"]["children"]) == sorted(["hw_top.dut.u_input_fsm", "hw_top.dut.u_regs", "hw_top.dut.u_error_timer",
           "hw_top.dut.g_ch[0].u_ch", "hw_top.dut.g_ch[1].u_ch", "hw_top.dut.g_ch[2].u_ch"]), "DUT sub-modules")
    dut_edges = [e for e in m["edges"] if e["kind"] == "port" and e["from"].startswith("hw_top.dut.") and e["to"].startswith("hw_top.dut.")]
    expect(len(dut_edges) >= 6, f"edges between the DUT sub-modules: {len(dut_edges)}")
    expect("tb.fifo_sb" in N and N["tb.fifo_sb"].get("variant"), "lab09d variant fifo_sb present and tagged")
    expect("tb.mcseqr" in N and not [k for k in N if k.startswith("tb.mcseqr.")], "virtual sequencer has no children")
    # every node has a lab, a summary and a scene
    for nid, n in N.items():
        if n["kind"] in ("uvm_base",):
            continue
        expect(n.get("lab"), f"{nid}: no lab")
        expect(n.get("summary") is not None, f"{nid}: no summary")
        expect(nid in m["where"] or nid.startswith("cls:") or nid.startswith("uvm:"), f"{nid}: drawn in no scene")
        for d in n.get("docs", []):
            expect(os.path.exists(os.path.join(ROOT, "docs", d["url"])), f"{nid}: missing doc page {d['url']}")
        if n.get("file"):
            expect(os.path.exists(os.path.join(ROOT, n["file"])), f"{nid}: missing file {n['file']}")
    # scenes
    ids = [s["id"] for s in m["scenes"]]
    expect(len(ids) == len(set(ids)), "duplicate scene ids")
    for s in m["scenes"]:
        expect(s["w"] > 0 and s["h"] > 0, f"{s['id']}: empty scene")
        item_ids = {it["id"] for it in s["items"]} | {p["id"] for it in s["items"] for p in it.get("ports", [])} \
            | {st["id"] for st in s.get("stubs", [])}
        def anchored(nid):
            while nid is not None:
                if nid in item_ids:
                    return True
                nid = N[nid]["parent"] if nid in N else None
            return False
        for e in s["edges"]:
            expect(anchored(e["from"]) and anchored(e["to"]), f"{s['id']}: edge {e['id']} floats")
    # the DUT block diagram in the root scene (pins + registers block) and the register map
    root = next(s for s in m["scenes"] if s["id"] == "h:root")
    dut = next((it for it in root["items"] if it["id"] == "hw_top.dut"), None)
    expect(dut is not None and dut.get("style") == "dut_spec", "root scene: DUT drawn as a block diagram")
    if dut:
        expect(len(dut.get("pins", [])) == len(N["hw_top.dut"]["ports"]) == 19, f"DUT pins: {len(dut.get('pins', []))}")
        expect(dut["w"] >= 500 and dut.get("regmap") and len(dut["regmap"]["rows"]) == 5, "DUT box: wide, with the 5-row register block")
        expect(len(dut.get("anchors", {})) == 7, f"pin anchors for the 7 hw_top instances: {len(dut.get('anchors', {}))}")
        pinned = [e for e in root["edges"] if e["kind"] == "port" and "hw_top.dut" in (e["from"], e["to"])]
        expect(len(pinned) == 7 and all(not e.get("label") for e in pinned), f"7 unlabeled arrows land on the DUT pins ({len(pinned)})")
    regmap = (m.get("meta") or {}).get("regmap") or {}
    expect(regmap.get("registers") and regmap.get("memories"), "regmap.yaml loaded into meta.regmap")
    if regmap:
        # regmap.yaml <-> RTL localparams (yapp_hbus_regs.sv) <-> RAL offsets (yapp_regs_c.sv)
        params = {p["name"]: int(p["value"].split("'d")[1]) for p in N["hw_top.dut.u_regs"].get("params", []) if "'d" in p["value"]}
        rtl = {"ctrl_reg": "ADDR_CTRL_REG", "en_reg": "ADDR_EN_REG", "parity_err_cnt_reg": "ADDR_PARITY_ERR", "oversized_pkt_cnt_reg": "ADDR_OVERSIZED",
               "addr3_cnt_reg": "ADDR_ADDR3_CNT", "addr0_cnt_reg": "ADDR_ADDR0_CNT", "addr1_cnt_reg": "ADDR_ADDR1_CNT", "addr2_cnt_reg": "ADDR_ADDR2_CNT",
               "mem_size_reg": "ADDR_MEM_SIZE", "yapp_pkt_mem": "ADDR_PKT_MEM_BASE", "yapp_mem": "ADDR_MEM_BASE"}
        for r in regmap["registers"] + regmap["memories"]:
            addr = r.get("addr", r.get("base"))
            expect(params.get(rtl.get(r["name"])) == addr, f"regmap {r['name']} {addr:#x} != RTL {rtl.get(r['name'])} {params.get(rtl.get(r['name']))}")
        ral = open(os.path.join(ROOT, "yapp_project", "tb", "reg", "yapp_regs_c.sv"), encoding="utf-8").read()
        import re as _re
        offs = {mm.group(1): int(mm.group(2), 16) for mm in _re.finditer(r"default_map\.add_(?:reg|mem)\(\s*(\w+)\s*,\s*'h([0-9a-fA-F]+)", ral)}
        ral_names = {r["name"]: r["name"] for r in regmap["registers"] + regmap["memories"]}   # the RAL uses the register names
        expect(len(offs) >= 11, f"RAL offsets parsed from yapp_regs_c.sv: {len(offs)}")
        for r in regmap["registers"] + regmap["memories"]:
            addr = r.get("addr", r.get("base"))
            got = offs.get(ral_names.get(r["name"]))
            expect(got is not None and got + 0x1000 == addr, f"regmap {r['name']} {addr:#x} != RAL offset {got}")
        expect(all(r["policy"] in ("RW", "RO") for r in regmap["registers"] + regmap["memories"]), "regmap policies are RW / RO")
    expect("window.YAPP_REGMAP" in html and "YappSim" in html, "standalone inlines regmap.js and sim.js")
    # standalone
    expect(len(html) < 2 * 1024 * 1024, f"standalone too big: {len(html)} bytes")
    expect("fetch(" not in html.split('<script id="pm-model"')[0], "standalone must not fetch")
    expect(len(m.get("files", {})) > 50, "source files missing from the model")
    for nid, n in N.items():
        if n.get("file"):
            expect(n["file"] in m["files"], f"{nid}: source file {n['file']} not in the model")
            expect(0 < n["line"] <= n.get("end_line", n["line"]) <= m["files"][n["file"]].count("\n") + 1, f"{nid}: line range outside {n['file']}")
    if problems:
        print(f"{len(problems)} problem(s):")
        for p in problems:
            print("  -", p)
        raise SystemExit(1)
    print("project map checks: OK")


def test_build():
    from . import build
    m, mj, html = build.build(write=False)
    run_all(m, mj, html)
