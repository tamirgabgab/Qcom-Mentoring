#!/usr/bin/env python3
"""
layout.py -- compute the geometry of every scene of the project map.

Scenes are plain dictionaries the browser draws as SVG:

    { "id": "h:tb.yapp.agent", "view": "hierarchy", "title": "...", "parent": "h:tb.yapp",
      "w": 900, "h": 420,
      "items": [ {"id": node id, "x","y","w","h", "label", "sub", "kind", "container": bool,
                   "children": n, "ports": [{"id","x","y","side","label"}], "depth": int} ],
      "edges": [ {"id": edge id, "kind", "from", "to", "points": [[x,y],...], "label", "lx","ly",
                  "bidir": bool, "dashed": bool} ],
      "stubs": [ ... items standing for nodes outside the scene ... ] }

Three families: hierarchy (one scene per container node + the root overview), TLM /
data-flow (two scenes: main and the Lab 9D variant) and UML classes (one scene per
group, compact and full, plus an "all" scene).

Everything is deterministic: same model -> same geometry -> clean diffs.
"""
import math
import re

# ----------------------------------------------------------------------------- metrics
CHAR_W = {11: 6.8, 12: 7.0, 13: 7.4, 14: 8.0, 15: 8.5}
PAD = 20            # inner padding of containers
TITLE_H = 30        # container title bar
GAP_X = 36          # gap between sibling boxes
GAP_Y = 34
PORT_R = 5
PORT_STEP = 20
PIN_STEP = 18       # pins written inside a block diagram (the DUT)
PIN_GAP = 10        # between pin groups
PIN_OUT = 24        # the pin arrows of a block diagram, drawn outside the box
FRAME_GAP = 18      # extra air between two dashed group frames (TLM view)
PORT_SIDE = {       # which side of a box a port sits on: producers on the right, consumers on
    "tlm_port": "right", "get_port": "right",     # the left; the driver's seq_item_port pulls
    "seq_item_port": "left",                      # from the sequencer drawn on its left
    "tlm_imp": "left", "tlm_export": "left", "tlm_fifo": "left",
}
LEFT_KINDS = {"tlm_imp", "tlm_export", "tlm_fifo"}


def port_on_left(node):
    """Consumers sit on the left side of their box, producers on the right. The driver's
    seq_item_port (a pull port) faces the sequencer drawn on its left; the sequencer's
    seq_item_export (the pull imp, same kind) faces the driver on its right."""
    if node["kind"] == "seq_item_port":
        return "pull_imp" not in (node.get("type") or "")
    return node["kind"] in LEFT_KINDS
EDGE_KINDS_IN_SCENES = {"connect", "seq_item", "get", "handle", "reg_adapter", "backdoor", "vif", "port", "flow"}


def tw(text, size=13):
    return len(text or "") * CHAR_W.get(size, 7.3)


def short_type(t):
    """uvm_analysis_port#(yapp_packet) -> uvm_analysis_port #(yapp_packet)"""
    t = re.sub(r",\s*uvm_pkg::\w+::\w+", "", t or "")
    return t.replace("#(", " #(").replace("$", "")


class Box:
    __slots__ = ("id", "x", "y", "w", "h", "label", "sub", "kind", "container", "children", "ports",
                 "depth", "node", "extra")

    def __init__(self, nid, node, label, sub, kind, depth):
        self.id, self.node, self.label, self.sub, self.kind, self.depth = nid, node, label, sub, kind, depth
        self.x = self.y = 0.0
        self.w = self.h = 0.0
        self.container = False
        self.children = []
        self.ports = []
        self.extra = {}

    def move(self, dx, dy):
        self.x += dx
        self.y += dy
        for p in self.ports:
            p["x"] += dx
            p["y"] += dy
        for c in self.children:
            c.move(dx, dy)

    def flat(self):
        yield self
        for c in self.children:
            yield from c.flat()

    def to_dict(self):
        d = {"id": self.id, "x": round(self.x, 1), "y": round(self.y, 1), "w": round(self.w, 1),
             "h": round(self.h, 1), "label": self.label, "sub": self.sub, "kind": self.kind,
             "container": self.container, "depth": self.depth,
             "children": len(self.node.get("children", [])) if self.node else 0,
             "ports": [{k: (round(v, 1) if isinstance(v, float) else v) for k, v in p.items()} for p in self.ports]}
        d.update(self.extra)
        d["sub"] = self.extra.get("sub", self.sub)
        return d


# ----------------------------------------------------------------------------- base
class Layout:
    def __init__(self, model, ann):
        self.m = model
        self.N = model["nodes"]
        self.E = model["edges"]
        self.ann = ann
        self.hints = (ann.get("layout") or {}).get("hierarchy", {})
        self.edges_by_node = {}
        for e in self.E:
            self.edges_by_node.setdefault(e["from"], []).append(e)
            self.edges_by_node.setdefault(e["to"], []).append(e)

    # ----------------------------------------------------------- node helpers
    def is_port(self, nid):
        return bool(self.N[nid].get("port"))

    def component_children(self, nid):
        return [c for c in self.N[nid]["children"] if not self.is_port(c)]

    def port_children(self, nid):
        return [c for c in self.N[nid]["children"] if self.is_port(c)]

    def owner(self, nid):
        """Component that owns a port (or the node itself)."""
        n = self.N[nid]
        return n["parent"] if n.get("port") else nid

    def role_of(self, nid):
        """One short line on what a component does (the Environment view)."""
        n = self.N[nid]
        text = (n.get("summary") or "").strip()
        if not text and n.get("cls") and n["cls"] in self.N:
            text = (self.N[n["cls"]].get("summary") or "").strip()
        text = text.split(" -- ")[0].split(". ")[0].rstrip(".")
        if len(text) > 46:
            cut = text[:46].rsplit(" ", 1)[0]
            text = cut + "…"
        return text

    def label_of(self, nid):
        n = self.N[nid]
        if n["kind"] in ("module", "interface"):
            return n["name"], n["type"] if n["type"] != n["name"] else ""
        if n["kind"] == "rtl_block":
            return n["name"], ""
        return n["name"], n.get("type", "")

    # ----------------------------------------------------------- box building
    def make_box(self, nid, depth, expand, show_ports=True):
        n = self.N[nid]
        label, sub = self.label_of(nid)
        b = Box(nid, n, label, sub, n["kind"], depth)
        kids = self.component_children(nid)
        if expand > 0 and kids:
            b.container = True
            b.children = [self.make_box(k, depth + 1, expand - 1, show_ports) for k in kids]
            ports = self.port_children(nid) if show_ports else []
            left = [p for p in ports if port_on_left(self.N[p])]
            right = [p for p in ports if not port_on_left(self.N[p])]
            # room for the port labels on both sides: a port faces the box it talks to, so it
            # may end up on either side (face_partners)
            lm = rm = max([tw(self.N[p]["name"], 11) for p in ports] + [0]) + 24 if ports else 0
            self.arrange(b, left_margin=lm, right_margin=rm)
            y0 = TITLE_H + 14 + PORT_R
            for i, p in enumerate(left):
                b.ports.append({"id": p, "x": 0.0, "y": y0 + i * PORT_STEP, "side": "left",
                                "label": self.N[p]["name"], "kind": self.N[p]["kind"]})
            for i, p in enumerate(right):
                b.ports.append({"id": p, "x": b.w, "y": y0 + i * PORT_STEP, "side": "right",
                                "label": self.N[p]["name"], "kind": self.N[p]["kind"]})
            b.h = max(b.h, y0 + max(len(left), len(right)) * PORT_STEP + PAD)
        else:
            self.size_leaf(b, show_ports)
        return b

    def size_leaf(self, b, show_ports):
        n = b.node
        ports = self.port_children(b.id) if show_ports else []
        left = [p for p in ports if port_on_left(self.N[p])]
        right = [p for p in ports if not port_on_left(self.N[p])]
        text_w = max(tw(b.label, 14), tw(b.sub, 12) if b.sub else 0)
        port_w = 0
        if left or right:
            port_w = max([tw(self.N[p]["name"], 11) for p in ports] + [0]) + 2 * PORT_R + 10
            if left and right:
                port_w = port_w * 2 + 10
        w = max(text_w + 28, port_w + 24, 120)
        header = 30 if b.sub else 24
        h = header + 10 + max(len(left), len(right)) * PORT_STEP
        if n["kind"] in ("module", "interface", "rtl_block") and n.get("signals") and not ports:
            h = max(h, 54)
        role = self.role_of(nid=b.id) if getattr(self, "roles", False) else ""
        if role:
            b.extra["role"] = role
            w = max(w, tw(role, 11) + 28)
            h = max(h, header + 14 + 8 + max(len(left), len(right)) * PORT_STEP)
        b.w, b.h = w, max(h, 44)
        if (self.hints.get(b.id) or {}).get("style") == "dut_spec":
            self.size_dut_spec(b)
        # ports
        y0 = header + 8 + PORT_R
        for i, p in enumerate(left):
            b.ports.append({"id": p, "x": 0.0, "y": y0 + i * PORT_STEP, "side": "left",
                            "label": self.N[p]["name"], "kind": self.N[p]["kind"]})
        for i, p in enumerate(right):
            b.ports.append({"id": p, "x": b.w, "y": y0 + i * PORT_STEP, "side": "right",
                            "label": self.N[p]["name"], "kind": self.N[p]["kind"]})

    def size_dut_spec(self, b):
        """The DUT drawn like the course figure: pins (with bus widths) written inside the box,
        a registers block with the address map (regmap.yaml) and an anchor per hw_top instance
        so the arrows of the scene land on the matching pin group."""
        hint = self.hints.get(b.id) or {}
        ports = {p["name"]: p for p in b.node.get("ports", [])}

        def width_of(t):
            m = re.search(r"\[(\d+):(\d+)\]", t or "")
            return abs(int(m.group(1)) - int(m.group(2))) + 1 if m else 1

        groups = [g for g in hint.get("pin_groups", []) if any(p in ports for p in g["pins"])]
        named = {p for g in groups for p in g["pins"]}
        rest = [p for p in ports if p not in named]
        if rest:
            groups.append({"side": "left", "pins": rest})
        title_h = 40
        cols = {"left": [], "right": []}
        for g in groups:
            cols[g["side"]].append(g)
        pin_h = {side: sum(len(g["pins"]) for g in gs) * PIN_STEP + max(0, len(gs) - 1) * PIN_GAP
                 for side, gs in cols.items()}
        label_w = {side: max([tw(p, 11) for g in gs for p in g["pins"]] + [0]) + 20 for side, gs in cols.items()}
        regmap = (self.m.get("meta") or {}).get("regmap") or {}
        rows = regmap.get("figure_rows", [])
        col_w = [max([tw(r[i], 11) for r in rows] + [0]) for i in range(3)] if rows else [0, 0, 0]
        reg_w = 12 + col_w[0] + 10 + col_w[1] + 10 + col_w[2] + 12 if rows else 0
        reg_h = 22 + len(rows) * 17 + 8 if rows else 0
        b.w = max(label_w["left"] + reg_w + label_w["right"] + 2 * 12, tw(b.label, 14) + 80, 420)
        b.h = max(title_h + max(pin_h.values()) + PAD, title_h + 40 + reg_h + PAD, 160)
        pins, anchors = [], {}
        for side, gs in cols.items():
            y = title_h + (b.h - title_h - PAD - pin_h[side]) / 2 + PIN_STEP / 2
            for g in gs:
                y_first = y
                for name in g["pins"]:
                    p = ports[name]
                    pins.append({"name": name, "dir": p["dir"], "width": width_of(p.get("type")), "side": side, "y": round(y, 1)})
                    y += PIN_STEP
                if g.get("from"):
                    anchors[g["from"]] = {"side": side, "y": round((y_first + y - PIN_STEP) / 2, 1)}
                y += PIN_GAP
        reg = None
        if rows:
            reg = {"x": round((b.w - reg_w) / 2, 1), "y": round(b.h - PAD - reg_h, 1), "w": round(reg_w, 1), "h": reg_h,
                   "title": "registers (HBUS)", "rows": rows, "cols": [round(c, 1) for c in col_w], "node": "hw_top.dut.u_regs"}
        b.extra.update({"style": "dut_spec", "pins": pins, "anchors": anchors, "regmap": reg, "margin": PIN_OUT + 4,
                        "title": "DUT", "title_y": round((title_h + (reg["y"] if reg else b.h)) / 2, 1)})

    @staticmethod
    def margin_of(c):
        """Clearance a box needs around itself beyond the usual gap (a block diagram draws
        its pin arrows outside its frame)."""
        return float(c.extra.get("margin", 0))

    def arrange_columns(self, b, columns, left_margin=0.0, right_margin=0.0):
        """Children stacked in the given columns (left to right), each column vertically centred."""
        by_name = {c.label: c for c in b.children}
        cols = []
        used = set()
        for col in columns:
            cs = [by_name[x] for x in col if x in by_name]
            used.update(c.id for c in cs)
            if cs:
                cols.append(cs)
        rest = [c for c in b.children if c.id not in used]
        if rest:
            cols.append(rest)
        gap_y = GAP_Y * 0.7
        heights = [sum(c.h for c in cs) + gap_y * (len(cs) - 1) for cs in cols]
        total_h = max(heights)
        x = PAD + left_margin
        for cs, h in zip(cols, heights):
            w = max(c.w for c in cs)
            mx = max(self.margin_of(c) for c in cs)
            x += mx
            y = TITLE_H + PAD + (total_h - h) / 2
            for c in cs:
                c.move(x + (w - c.w) / 2 - c.x, y - c.y)
                y += c.h + gap_y
            x += w + mx + GAP_X
        title_w = tw(b.label, 14) + tw(b.sub, 12) + 40
        b.w = max(x - GAP_X + PAD + right_margin, title_w, 160)
        b.h = TITLE_H + PAD + total_h + PAD

    def rows_for(self, b):
        """Children arranged in rows: from the YAML hint or a square-ish grid."""
        hint = self.hints.get(b.id) or {}
        by_name = {c.label: c for c in b.children}
        rows = []
        used = set()
        for row in hint.get("rows", []):
            r = [by_name[x] for x in row if x in by_name]
            for c in r:
                used.add(c.id)
            if r:
                rows.append(r)
        rest = [c for c in b.children if c.id not in used]
        if rest:
            cols = max(1, min(hint.get("cols", 4), math.ceil(math.sqrt(len(rest))) + (1 if len(rest) > 4 else 0)))
            for i in range(0, len(rest), cols):
                rows.append(rest[i:i + cols])
        return rows

    def arrange(self, b, left_margin=0.0, right_margin=0.0):
        hint = self.hints.get(b.id) or {}
        if hint.get("columns"):
            return self.arrange_columns(b, hint["columns"], left_margin, right_margin)
        rows = self.rows_for(b)
        y = TITLE_H + PAD
        total_w = 0
        row_geo = []
        for r in rows:
            x = PAD + left_margin
            row_h = max(c.h for c in r)
            for c in r:
                x += self.margin_of(c)
                c.move(x - c.x, y - c.y)
                x += c.w + self.margin_of(c) + GAP_X
            row_w = x - GAP_X + PAD + right_margin
            total_w = max(total_w, row_w)
            row_geo.append((r, row_h))
            y += row_h + GAP_Y
        # centre each row inside the usable width
        usable = total_w - 2 * PAD - left_margin - right_margin
        for r, row_h in row_geo:
            row_w = sum(c.w + 2 * self.margin_of(c) for c in r) + GAP_X * (len(r) - 1)
            dx = (usable - row_w) / 2
            for c in r:
                c.move(dx, 0)
        title_w = tw(b.label, 14) + tw(b.sub, 12) + 40
        b.w = max(total_w, title_w, 160)
        b.h = y - GAP_Y + PAD

    def visible_owner(self, nid, boxes):
        cur = nid
        while cur is not None and cur not in boxes:
            cur = self.N[cur].get("parent") if cur in self.N else None
        return cur

    def face_partners(self, boxes, ports):
        """A port sits on the side of its box that faces the box it talks to, so an arrow
        between two neighbours runs straight instead of looping around them: the output of a
        box on the left leaves from its right edge, the input of the box on its right enters
        on its left edge. The generator's guess (producers right, consumers left) stays when
        the partner is above / below, not in the scene, or a frame around the box."""
        for b in boxes.values():
            if not b.ports:
                continue
            wish = {}
            for p in b.ports:
                xs = []
                for e in self.edges_by_node.get(p["id"], []):
                    if e["kind"] not in EDGE_KINDS_IN_SCENES or e.get("variant"):
                        continue
                    other = e["to"] if e["from"] == p["id"] else e["from"]
                    ob = self.visible_owner(other, boxes)
                    if ob is None or ob == b.id:
                        continue
                    o = boxes[ob]
                    if (o.x <= b.x and o.x + o.w >= b.x + b.w) or (b.x <= o.x and b.x + b.w >= o.x + o.w):
                        continue
                    op = ports.get(other)
                    xs.append(op["x"] if op else o.x + o.w / 2)
                if xs and all(x > b.x + b.w for x in xs):
                    wish[p["id"]] = "right"
                elif xs and all(x < b.x for x in xs):
                    wish[p["id"]] = "left"
            if not any(wish.get(p["id"], p["side"]) != p["side"] for p in b.ports):
                continue
            # labels on both sides must fit next to each other
            lw = {side: max([tw(p["label"], 11) for p in b.ports if wish.get(p["id"], p["side"]) == side] + [0])
                  for side in ("left", "right")}
            if lw["left"] and lw["right"] and lw["left"] + lw["right"] + 4 * PORT_R + 24 > b.w and not b.container:
                continue
            y_top = min(p["y"] for p in b.ports)
            count = {"left": 0, "right": 0}
            for p in b.ports:
                p["side"] = wish.get(p["id"], p["side"])
                p["x"] = b.x if p["side"] == "left" else b.x + b.w
                p["y"] = y_top + count[p["side"]] * PORT_STEP
                count[p["side"]] += 1
            b.h = max(b.h, y_top - b.y + max(count.values()) * PORT_STEP + PAD)

    # ------------------------------------------------------------- edge routing
    @staticmethod
    def clip_to_box(cx, cy, tx, ty, box):
        """Point where the segment centre->(tx,ty) leaves the box."""
        dx, dy = tx - cx, ty - cy
        if dx == 0 and dy == 0:
            return cx, cy
        hw, hh = box.w / 2, box.h / 2
        sx = hw / abs(dx) if dx else math.inf
        sy = hh / abs(dy) if dy else math.inf
        s = min(sx, sy)
        return cx + dx * s, cy + dy * s

    def route(self, a_pt, b_pt, a_side=None, b_side=None):
        """Bezier control points for a port-to-port or box-to-box edge."""
        (x1, y1), (x2, y2) = a_pt, b_pt
        dx = max(40, abs(x2 - x1) * 0.45)
        if a_side in ("right", "left") or b_side in ("right", "left"):
            c1 = (x1 + (dx if a_side != "left" else -dx), y1)
            c2 = (x2 - (dx if b_side != "right" else -dx), y2)
            return [[x1, y1], list(c1), list(c2), [x2, y2]]
        return [[x1, y1], [x2, y2]]

    def anchor(self, box, other_pt):
        cx, cy = box.x + box.w / 2, box.y + box.h / 2
        return self.clip_to_box(cx, cy, other_pt[0], other_pt[1], box)

    def edge_geometry(self, e, boxes, ports):
        """boxes: node id -> Box (visible, leaf or container); ports: port id -> port dict."""
        def endpoint(nid):
            if nid in ports:
                p = ports[nid]
                return (p["x"], p["y"]), p["side"], None
            # a port whose owner is visible as a box without ports (collapsed) -> the owner box
            cur = nid
            while cur is not None and cur not in boxes:
                cur = self.N[cur].get("parent")
            if cur is None:
                return None, None, None
            return None, None, boxes[cur]

        a_pt, a_side, a_box = endpoint(e["from"])
        b_pt, b_side, b_box = endpoint(e["to"])
        if a_pt is None and a_box is None or b_pt is None and b_box is None:
            return None
        if a_box is not None and b_box is not None and a_box is b_box:
            return None
        if a_pt is None:
            target = b_pt or (b_box.x + b_box.w / 2, b_box.y + b_box.h / 2)
            a_pt = self.anchor(a_box, target)
        if b_pt is None:
            b_pt = self.anchor(b_box, a_pt)
            if a_box is not None:   # re-anchor the start towards the real end point
                a_pt = self.anchor(a_box, b_pt)
        pts = self.route(a_pt, b_pt, a_side, b_side)
        mid = self.bezier_mid(pts)
        return {"id": e["id"], "kind": e["kind"], "from": e["from"], "to": e["to"],
                "points": [[round(x, 1), round(y, 1)] for x, y in pts],
                "label": e.get("label"), "lx": round(mid[0], 1), "ly": round(mid[1], 1),
                "bidir": bool(e.get("bidir")), "dashed": bool(e.get("dashed")) or e["kind"] in ("vif", "handle", "backdoor")}

    @staticmethod
    def bezier_mid(pts, t=0.5):
        if len(pts) == 2:
            return pts[0][0] + (pts[1][0] - pts[0][0]) * t, pts[0][1] + (pts[1][1] - pts[0][1]) * t
        (x0, y0), (x1, y1), (x2, y2), (x3, y3) = pts
        mt = 1 - t
        return (mt ** 3 * x0 + 3 * mt * mt * t * x1 + 3 * mt * t * t * x2 + t ** 3 * x3,
                mt ** 3 * y0 + 3 * mt * mt * t * y1 + 3 * mt * t * t * y2 + t ** 3 * y3)


# ----------------------------------------------------------------------------- hierarchy
class HierarchyLayout(Layout):
    ROOT_ID = "h:root"

    def scenes(self):
        out = [self.root_scene()]
        for nid, n in self.N.items():
            if n.get("scope") == "cls" or not self.component_children(nid):
                continue
            if nid in ("tb_top", "uvm_test_top"):
                continue          # covered by the root overview
            out.append(self.container_scene(nid))
        return out

    def root_scene(self, expand_tb=3, sid=None, view="hierarchy", title="YAPP router testbench — overview"):
        tb = self.make_box("tb_top", 0, expand=expand_tb, show_ports=False)   # tb_top > uvm_test_top > tb > UVCs
        hw = self.make_box("hw_top", 0, expand=1, show_ports=False)
        # stack: UVM side above the hardware
        tb.move(PAD - tb.x, PAD - tb.y)
        hw.move(PAD - hw.x, tb.y + tb.h + GAP_Y * 2 - hw.y)
        width = max(tb.w, hw.w) + 2 * PAD
        tb.move((width - tb.w) / 2 - tb.x, 0)
        hw.move((width - hw.w) / 2 - hw.x, 0)
        boxes = {}
        for b in list(tb.flat()) + list(hw.flat()):
            boxes[b.id] = b
        edges = self.scene_edges(boxes, {}, kinds={"vif", "port", "handle", "reg_adapter", "backdoor"},
                                 collapse_vif=True)
        return {"id": sid or self.ROOT_ID, "view": view, "node": None, "title": title,
                "parent": None, "w": round(width, 1), "h": round(hw.y + hw.h + PAD, 1),
                "items": [b.to_dict() for b in boxes.values()], "edges": edges, "stubs": []}

    def container_scene(self, nid):
        n = self.N[nid]
        hint = self.hints.get(nid) or {}
        expand = int(hint.get("depth", 1))
        if nid == "tb":
            expand = 2
        box = self.make_box(nid, 0, expand=expand, show_ports=True)
        box.move(PAD - box.x, PAD - box.y)
        boxes = {b.id: b for b in box.flat()}
        ports = {}
        for b in boxes.values():
            for p in b.ports:
                ports[p["id"]] = p
        self.face_partners(boxes, ports)
        edges = []
        stubs = self.add_stubs(box, boxes, ports, edges, nid)       # may shift the boxes right
        edges = self.scene_edges(boxes, ports, kinds=EDGE_KINDS_IN_SCENES, scene_root=nid) + edges
        w = box.x + box.w + PAD
        h = box.y + box.h + PAD
        if stubs:
            w = max(w, max(s["x"] + s["w"] for s in stubs) + PAD)
            h = max(h, max(s["y"] + s["h"] for s in stubs) + PAD)
        parent = self.parent_scene(nid)
        label, sub = self.label_of(nid)
        return {"id": f"h:{nid}", "view": "hierarchy", "node": nid,
                "title": f"{label} : {sub}" if sub else label, "parent": parent,
                "w": round(w, 1), "h": round(h, 1),
                "items": [b.to_dict() for b in boxes.values()], "edges": edges, "stubs": stubs}

    def parent_scene(self, nid):
        p = self.N[nid].get("parent")
        while p is not None:
            if p in ("tb_top", "uvm_test_top") or self.N[p].get("parent") is None:
                return self.ROOT_ID
            if self.component_children(p):
                return f"h:{p}"
            p = self.N[p].get("parent")
        return self.ROOT_ID

    # ------------------------------------------------------------- edge planning
    def _endpoint(self, nid, boxes, ports):
        if nid in ports:
            p = ports[nid]
            return {"kind": "port", "pt": (p["x"], p["y"]), "side": p["side"], "id": nid}
        cur = nid
        while cur is not None and cur not in boxes:
            cur = self.N[cur].get("parent") if cur in self.N else None
        if cur is None:
            return None
        return {"kind": "box", "box": boxes[cur], "id": cur}

    @staticmethod
    def _center(end):
        if end["kind"] == "port":
            return end["pt"]
        b = end["box"]
        return (b.x + b.w / 2, b.y + b.h / 2)

    @staticmethod
    def _pick_side(box, other_pt, fixed=None):
        if fixed:
            return fixed
        cx, cy = box.x + box.w / 2, box.y + box.h / 2
        dx, dy = other_pt[0] - cx, other_pt[1] - cy
        # normalised by the box size: wide boxes prefer their top / bottom edge
        if abs(dy) / max(box.h, 1.0) >= abs(dx) / max(box.w, 1.0):
            return "bottom" if dy > 0 else "top"
        return "right" if dx > 0 else "left"

    DIR = {"top": (0, -1), "bottom": (0, 1), "left": (-1, 0), "right": (1, 0)}

    def plan_edges(self, specs, boxes, ports):
        """Two passes over the edges of a scene: pick the side of every box endpoint, then
        spread the endpoints that share a side along it, then draw smooth S-curves that leave
        and enter perpendicular to the sides. specs: {edge, from, to, fixed, label, label_t,
        reverse, stub}."""
        ends = []
        for sp in specs:
            a = self._endpoint(sp["from"], boxes, ports)
            b = self._endpoint(sp["to"], boxes, ports)
            if a is None or b is None:
                continue
            if a["kind"] == "box" and b["kind"] == "box" and a["box"] is b["box"]:
                continue
            if a["kind"] == "port" and b["kind"] == "box" and b["box"].id == self.N[a["id"]].get("parent"):
                continue
            if b["kind"] == "port" and a["kind"] == "box" and a["box"].id == self.N[b["id"]].get("parent"):
                continue
            fixed = sp.get("fixed", {})
            # an edge to a stub leaves the scene horizontally: the near box uses its facing side
            near_side = sp.get("stub_side")
            if a["kind"] == "box":
                a["side"] = self._pick_side(a["box"], self._center(b), fixed.get(a["id"]) or
                                            (near_side if near_side and not a["box"].extra.get("stub") else None))
            if b["kind"] == "box":
                b["side"] = self._pick_side(b["box"], self._center(a), fixed.get(b["id"]) or
                                            (near_side if near_side and not b["box"].extra.get("stub") else None))
            # a block diagram with pins: the arrow lands on the pin group of the far instance
            for me, other in ((a, b), (b, a)):
                anchors = me["box"].extra.get("anchors") if me["kind"] == "box" else None
                if anchors and other["id"] in anchors:
                    an = anchors[other["id"]]
                    bx = me["box"]
                    me["side"] = an["side"]
                    me["pt"] = (bx.x + (-PIN_OUT if an["side"] == "left" else bx.w + PIN_OUT), bx.y + an["y"])
                    me["pinned"] = True
                    sp["label"] = None          # the pins carry the signal names
            ends.append((sp, a, b))
        groups = {}
        for sp, a, b in ends:
            for me, other in ((a, b), (b, a)):
                if me["kind"] == "box" and not me.get("pinned"):
                    groups.setdefault((me["id"], me["side"]), []).append((me, self._center(other)))
        for (bid, side), lst in groups.items():
            horiz = side in ("top", "bottom")
            lst.sort(key=lambda t: t[1][0] if horiz else t[1][1])
            n = len(lst)
            for k, (me, _) in enumerate(lst):
                b = me["box"]
                frac = (k + 1) / (n + 1)
                if horiz:
                    x = b.x + b.w * (0.12 + 0.76 * frac) if n > 1 else b.x + b.w / 2
                    y = b.y if side == "top" else b.y + b.h
                else:
                    y = b.y + b.h * (0.15 + 0.7 * frac) if n > 1 else b.y + b.h / 2
                    x = b.x if side == "left" else b.x + b.w
                me["pt"] = (x, y)
        out = []
        for sp, a, b in ends:
            p0, p3 = a["pt"], b["pt"]
            d0, d1 = self.DIR[a["side"]], self.DIR[b["side"]]
            if a["kind"] == "port":
                d0 = (1, 0) if p3[0] >= p0[0] else (-1, 0)
            if b["kind"] == "port":
                d1 = (1, 0) if p0[0] >= p3[0] else (-1, 0)
            dist = math.hypot(p3[0] - p0[0], p3[1] - p0[1])
            d = max(36.0, min(150.0, dist * 0.45))
            pts = [list(p0), [p0[0] + d0[0] * d, p0[1] + d0[1] * d], [p3[0] + d1[0] * d, p3[1] + d1[1] * d], list(p3)]
            if sp.get("reverse"):
                pts = list(reversed(pts))
            e = sp["edge"]
            mid = self.bezier_mid(pts, sp.get("label_t", 0.5))
            g = {"id": e["id"], "kind": e["kind"], "from": e["from"], "to": e["to"],
                 "points": [[round(x, 1), round(y, 1)] for x, y in pts],
                 "label": sp.get("label", e.get("label")), "lx": round(mid[0], 1), "ly": round(mid[1], 1),
                 "bidir": bool(e.get("bidir")),
                 "dashed": bool(e.get("dashed")) or e["kind"] in ("vif", "handle", "backdoor")}
            if sp.get("stub"):
                g["stub"] = True
            out.append(g)
        return out

    def scene_edges(self, boxes, ports, kinds, scene_root=None, collapse_vif=False):
        """Edges with both ends inside the scene."""
        specs = []
        seen = set()
        for e in self.E:
            if e["kind"] not in kinds:
                continue
            if e.get("variant") and scene_root and not any(self.N[x].get("variant") for x in (e["from"], e["to"])
                                                         if x in self.N):
                continue
            a_in = self.visible_owner(e["from"], boxes)
            b_in = self.visible_owner(e["to"], boxes)
            if a_in is None or b_in is None or a_in == b_in:
                continue
            sp = {"edge": e, "from": e["from"], "to": e["to"], "_pair": frozenset((a_in, b_in))}
            if collapse_vif:
                key = (e["kind"], a_in, b_in)
                if key in seen:
                    continue
                seen.add(key)
                if e["kind"] == "vif":
                    sp["label"] = "vif"
            specs.append(sp)
        if collapse_vif:
            # module port bundles: one arrow per pair of boxes, the bidirectional one if there is one
            best = {}
            for sp in specs:
                if sp["edge"]["kind"] != "port":
                    continue
                cur = best.get(sp["_pair"])
                if cur is None or (sp["edge"].get("bidir") and not cur["edge"].get("bidir")):
                    best[sp["_pair"]] = sp
            specs = [sp for sp in specs if sp["edge"]["kind"] != "port" or best[sp["_pair"]] is sp]
        return self.plan_edges(specs, boxes, ports)

    def add_stubs(self, root_box, boxes, ports, edges, scene_root):
        """Edges leaving the scene: a small stub box outside the container stands for the far end.
        A stub sits on the side of the container nearer to the box it talks to, at its height
        when possible, so the arrow between them is short and straight; a stub talking to the
        container itself follows the data: producers feeding the scene on the left, everything
        the scene talks to on the right."""
        specs = []
        stubs = {}
        partners = {}                      # stub id -> in-scene boxes it talks to
        # a far end that also reaches a child of the container: the arrow to the frame itself is
        # the coarse version of that connection, so it is left out (module scenes)
        detailed = set()
        for e in self.E:
            if e["kind"] in ("port",) and not e.get("variant"):
                for far, near in ((e["from"], e["to"]), (e["to"], e["from"])):
                    if near != scene_root and near.startswith(scene_root + ".") and self.visible_owner(near, boxes):
                        detailed.add(far)
        for e in self.E:
            if e["kind"] not in EDGE_KINDS_IN_SCENES or e.get("variant"):
                continue
            ends = (e["from"], e["to"])
            inside = [self.visible_owner(x, boxes) for x in ends]
            if (inside[0] is None) == (inside[1] is None):
                continue
            far = ends[0] if inside[0] is None else ends[1]
            near = ends[1] if inside[0] is None else ends[0]
            if near == scene_root and e["kind"] == "port" and far in detailed:
                continue
            incoming = e["from"] == far
            near_box = boxes[self.visible_owner(near, boxes)]
            if near_box is not root_box:
                partners.setdefault(far, []).append((near_box.x, near_box.x + near_box.w, near_box.y + near_box.h / 2))
            elif near in ports:
                pp = ports[near]
                partners.setdefault(far, []).append((pp["x"], pp["x"], pp["y"]))
            if far not in stubs:
                owner_far = far if not self.is_port(far) else self.N[far]["parent"]
                label = self.N[far]["name"] if not self.is_port(far) else f"{self.N[owner_far]['name']}.{self.N[far]['name']}"
                side = "left" if (incoming and self.N[far].get("scope") != "hw") else "right"
                n = self.N[far]
                sb = Box(far, n, label, far, n["kind"], 0)
                sb.w, sb.h = max(tw(label, 12) + 24, tw(far, 11) + 24, 120), 40
                sb.extra = {"stub": True, "side": side, "scene": self.scene_for(far), "sub": far}
                stubs[far] = sb
            specs.append({"edge": e, "from": e["from"], "to": e["to"], "stub": True, "_far": far,
                          "label_t": 0.62 if incoming else 0.38})
        # the side nearer to the partner boxes wins over the data-direction guess; a partner
        # spanning the middle of the container (the DUT) decides nothing
        root_cx = root_box.x + root_box.w / 2
        for far, pts in partners.items():
            if all(x1 < root_cx for x0, x1, _ in pts):
                stubs[far].extra["side"] = "left"
            elif all(x0 > root_cx for x0, x1, _ in pts):
                stubs[far].extra["side"] = "right"
        for sp in specs:
            far = sp["_far"]
            sp["fixed"] = {far: "right" if stubs[far].extra["side"] == "left" else "left"}
            sp["stub_side"] = stubs[far].extra["side"]
            del sp["_far"]
        if not stubs:
            return []
        # place the stub columns
        left = [b for b in stubs.values() if b.extra["side"] == "left"]
        right = [b for b in stubs.values() if b.extra["side"] == "right"]
        left_w = max([b.w for b in left] + [0])
        # room between a stub and the container for the label of the arrow between them
        gap = max(GAP_X * 1.5, min(110.0, max([tw(sp["edge"].get("label") or "", 11) for sp in specs] + [0]) + 24))
        shift = left_w + gap if left else 0
        if shift:
            for b in list(boxes.values()):
                if b.depth == 0:
                    b.move(shift, 0)
        # top to bottom in the order of their partners, each at the height of its partner when
        # the one above leaves room
        def wanted_y(b):
            pts = partners.get(b.id)
            if not pts:
                return None
            return sum(cy for _, _, cy in pts) / len(pts) - b.h / 2

        def stack(col, x):
            col.sort(key=lambda b: (wanted_y(b) if wanted_y(b) is not None else 1e9, b.id))
            y = root_box.y + TITLE_H
            for b in col:
                w = wanted_y(b)
                if w is not None:
                    y = max(y, w)
                b.move(x - b.x, y - b.y)
                y += b.h + 12
        stack(left, PAD)
        stack(right, root_box.x + root_box.w + gap)
        all_boxes = dict(boxes)
        all_boxes.update(stubs)
        # the in-scene edges were planned before the shift: recompute everything together
        edges.extend(self.plan_edges(specs, all_boxes, ports))
        out = []
        for b in stubs.values():
            d = b.to_dict()
            d["stub"] = True
            d["side"] = b.extra["side"]
            d["scene"] = b.extra["scene"]
            d["sub"] = far_sub = b.id
            out.append(d)
        return out

    def scene_for(self, nid):
        """The hierarchy scene in which node `nid` is drawn as an item."""
        p = self.N[nid].get("parent")
        if self.is_port(nid):
            p = self.N[p].get("parent") if p else None
        while p is not None:
            if p in ("tb_top", "uvm_test_top") or self.N[p].get("parent") is None:
                return self.ROOT_ID
            if self.component_children(p):
                return f"h:{p}"
            p = self.N[p].get("parent")
        return self.ROOT_ID


# ----------------------------------------------------------------------------- TLM
class TlmLayout(Layout):
    LANES = ["control", "adapter", "sequencer", "driver", "dut", "monitor"]
    LANE_TITLES = {0: "control", 1: "register adapter", 2: "sequencers", 3: "drivers", 4: "DUT",
                   5: "monitors"}
    GROUP_ORDER = ["tb.yapp", "tb.hbus", "tb.chan0", "tb.chan1", "tb.chan2", "tb.clk_rst"]

    def scenes(self):
        return [self.scene("tlm:main", variant=False), self.scene("tlm:lab09d", variant=True)]

    def participants(self, variant):
        """Component nodes that take part in the TLM picture."""
        ids = set()
        for e in self.E:
            if e["kind"] not in ("connect", "seq_item", "get", "handle", "reg_adapter", "backdoor"):
                continue
            ev = bool(e.get("variant"))
            for end in (e["from"], e["to"]):
                nv = bool(self.N[end].get("variant")) or any(
                    self.N[x].get("variant") for x in self.ancestors(end))
                if ev or nv:
                    if variant:
                        ids.add(self.owner(end))
                else:
                    ids.add(self.owner(end))
                if e["kind"] == "reg_adapter" and e.get("via"):
                    ids.add(e["via"])
        if variant:
            # drop the module UVC (reference + scoreboard), keep fifo_sb
            ids = {i for i in ids if not i.startswith("tb.router_module")}
        else:
            ids = {i for i in ids if not i.startswith("tb.fifo_sb")}
        ids.discard("hw_top.dut")
        return ids

    def ancestors(self, nid):
        out = []
        p = self.N[nid].get("parent")
        while p:
            out.append(p)
            p = self.N[p].get("parent")
        return out

    def lane_of(self, nid):
        k = self.N[nid]["kind"]
        if k in ("vsequencer", "test"):
            return 0
        if k == "reg_block":
            return 0
        if k == "reg_adapter":
            return 1
        if k == "sequencer":
            return 2
        if k == "driver":
            return 3
        if k == "monitor":
            return 5
        return None   # analysis side: computed by longest path from the monitors

    def group_of(self, nid):
        for g in self.GROUP_ORDER:
            if nid == g or nid.startswith(g + "."):
                return g
        return nid.split(".")[0] + "." + nid.split(".")[1] if nid.count(".") >= 1 else nid

    def scene(self, sid, variant):
        parts = self.participants(variant)
        edges = [e for e in self.E if e["kind"] in ("connect", "seq_item", "get", "handle", "reg_adapter", "backdoor")
                 and self.owner(e["from"]) in parts and self.owner(e["to"]) in parts]
        if not variant:
            edges = [e for e in edges if not e.get("variant")]
        # lanes
        lane = {}
        for p in parts:
            lane[p] = self.lane_of(p)
        # analysis side: longest path from monitors over connect/get edges (owner level)
        succ = {}
        for e in edges:
            if e["kind"] in ("connect", "get"):
                a, b = self.owner(e["from"]), self.owner(e["to"])
                if a != b:
                    succ.setdefault(a, set()).add(b)
        changed = True
        guard = 0
        while changed and guard < 50:
            changed = False
            guard += 1
            for a, bs in succ.items():
                if lane.get(a) is None:
                    continue
                for b in bs:
                    if lane.get(b) is None or lane[b] < lane[a] + 1:
                        if lane_of_kind_fixed(self.N[b]["kind"]):
                            continue
                        lane[b] = lane[a] + 1
                        changed = True
        for p in parts:
            if lane.get(p) is None:
                lane[p] = 6
        # the DUT box sits in lane 4 between drivers and monitors
        dut_id = "hw_top.dut"
        lane[dut_id] = 4
        # boxes
        boxes = {}
        for p in sorted(parts) + [dut_id]:
            b = self.make_box(p, 0, expand=0, show_ports=(p != dut_id))
            if p == dut_id:
                # the DUT drawn compact: one pin per interface instead of the 19 signals
                # (those are in the hierarchy view), stimulus side on the left, observation on
                # the right -- see `dut_pins` below once the lanes are placed
                b.w, b.h = 190, 120
                b.label, b.sub = "dut", "yapp_router"
                b.extra["style"] = "dut_tlm"
                b.extra["title"] = "DUT"
            boxes[p] = b
        # order within lanes: stimulus lanes by UVC group order; analysis lanes by barycentre
        lanes = {}
        for p, l in lane.items():
            lanes.setdefault(l, []).append(p)
        order_key = {g: i for i, g in enumerate(self.GROUP_ORDER)}
        pos_y = {}
        lane_x = {}
        x = PAD
        col_w = {}
        for l in sorted(lanes):
            col_w[l] = max(boxes[p].w for p in lanes[l])
            lane_x[l] = x
            x += col_w[l] + 64
        total_w = x - 64 + PAD
        pred = {}
        for e in edges:
            a, b = self.owner(e["from"]), self.owner(e["to"])
            pred.setdefault(b, []).append(a)
        max_h = 0
        for l in sorted(lanes):
            items = lanes[l]
            if l <= 5:
                items.sort(key=lambda p: (order_key.get(self.group_of(p), 99), p))
                if l == 5:
                    # monitors: same vertical order as the drivers/sequencers of their UVC
                    items.sort(key=lambda p: (order_key.get(self.group_of(p), 99), p))
            else:
                def bary(p):
                    ps = [pos_y[q] for q in pred.get(p, []) if q in pos_y]
                    return sum(ps) / len(ps) if ps else 1e9
                items.sort(key=lambda p: (bary(p), p))
            y = PAD + 40
            prev_group = None
            for p in items:
                b = boxes[p]
                g = self.group_of(p)
                if prev_group is not None and g != prev_group:
                    y += FRAME_GAP            # air between two dashed frames
                prev_group = g
                b.move(lane_x[l] + (col_w[l] - b.w) / 2 - b.x, y - b.y)
                pos_y[p] = y + b.h / 2
                y += b.h + GAP_Y
            max_h = max(max_h, y)
        # the DUT spans vertically the drivers/monitors range
        dut = boxes[dut_id]
        ys = [boxes[p].y for p in lanes.get(3, []) + lanes.get(5, [])]
        ye = [boxes[p].y + boxes[p].h for p in lanes.get(3, []) + lanes.get(5, [])]
        if ys:
            dut.move(0, min(ys) - dut.y)
            dut.h = max(120, max(ye) - min(ys))
        # interface pins of the DUT: a driver reaches its interface on the left side, a monitor
        # observes it on the right side, each pin at the height of its driver / monitor so the
        # virtual-interface arrows run straight. Pin ids are the interface instances (hw_top.in0 ...)
        # suffixed with the side, so both sides of one interface stay distinct.
        dut.extra["pins"] = []
        pin_ids = {}
        for e in self.E:
            if e["kind"] != "vif" or e["from"] not in boxes:
                continue
            b = boxes[e["from"]]
            k = self.N[e["from"]]["kind"]
            side = "left" if k == "driver" else "right"
            if_id = e["to"]
            pid = f"{if_id}@{side}"
            if pid in pin_ids:
                continue
            pin_ids[pid] = True
            dut.extra["pins"].append({"id": pid, "node": if_id, "name": self.N[if_id]["name"], "type": self.N[if_id].get("type", ""),
                                      "side": side, "dir": "in" if side == "left" else "out",
                                      "y": round(b.y + b.h / 2 - dut.y, 1)})
        dut.extra["pins"].sort(key=lambda pn: (pn["side"], pn["y"]))
        # pins never overlap: a driver and a monitor of the same lane sit at distinct heights,
        # but two pins on one side closer than a text line are pushed apart
        for side in ("left", "right"):
            prev = None
            for pn in [x for x in dut.extra["pins"] if x["side"] == side]:
                if prev is not None and pn["y"] - prev < PIN_STEP:
                    pn["y"] = round(prev + PIN_STEP, 1)
                prev = pn["y"]
        pin_bottom = max([pn["y"] for pn in dut.extra["pins"]] + [0]) + PIN_STEP
        dut.h = max(dut.h, pin_bottom)
        ports = {}
        for b in boxes.values():
            for p in b.ports:
                ports[p["id"]] = p
        self.face_partners(boxes, ports)
        geo = []
        for e in edges:
            g = self.edge_geometry(e, boxes, ports)
            if g:
                if e["kind"] == "reg_adapter" and e.get("via") in boxes:
                    via = boxes[e["via"]]
                    # two segments: block -> adapter -> sequencer
                    a = boxes[self.owner(e["from"])]
                    s1 = self.anchor(a, (via.x, via.y + via.h / 2))
                    g["points"] = [[round(s1[0], 1), round(s1[1], 1)], [round(via.x, 1), round(via.y + via.h / 2, 1)]]
                    g["lx"], g["ly"] = round((s1[0] + via.x) / 2, 1), round(s1[1] - 8, 1)
                    geo.append(g)
                    tgt = boxes[self.owner(e["to"])]
                    seqr_pt = ports.get(e["to"])
                    b_pt = (seqr_pt["x"], seqr_pt["y"]) if seqr_pt else self.anchor(tgt, (via.x + via.w, via.y + via.h / 2))
                    pts = self.route((via.x + via.w, via.y + via.h / 2), b_pt, "right", "left" if seqr_pt else None)
                    mid = self.bezier_mid(pts)
                    geo.append({"id": e["id"] + "b", "kind": "reg_adapter", "from": e["via"], "to": e["to"],
                                "points": [[round(x, 1), round(y, 1)] for x, y in pts], "label": "reg2bus() → hbus_transaction",
                                "lx": round(mid[0], 1), "ly": round(mid[1], 1), "bidir": False, "dashed": False})
                    continue
                geo.append(g)
        # vif edges: driver -> its pin on the left of the DUT, pin on the right -> monitor
        pins_by_id = {pn["id"]: pn for pn in dut.extra["pins"]}
        for e in self.E:
            if e["kind"] != "vif":
                continue
            o = e["from"]
            if o not in boxes:
                continue
            b = boxes[o]
            k = self.N[o]["kind"]
            side = "left" if k == "driver" else "right"
            pn = pins_by_id.get(f"{e['to']}@{side}")
            if pn is None:
                continue
            pin_pt = (dut.x + (0 if side == "left" else dut.w), dut.y + pn["y"])
            if k == "driver":
                a_pt = (b.x + b.w, b.y + b.h / 2)
                pts = self.route(a_pt, pin_pt, "right", "left")
            else:
                b_pt = (b.x, b.y + b.h / 2)
                pts = self.route(pin_pt, b_pt, "right", "left")
            mid = self.bezier_mid(pts)
            geo.append({"id": e["id"], "kind": "vif", "from": o if k == "driver" else pn["id"],
                        "to": pn["id"] if k == "driver" else o,
                        "points": [[round(x, 1), round(y, 1)] for x, y in pts],
                        "label": e["label"].split("=")[-1].strip().replace("hw_top.", ""),
                        "lx": round(mid[0], 1), "ly": round(mid[1], 1), "bidir": False, "dashed": True})
        # group frames
        frames = []
        groups = {}
        for p in sorted(parts):
            g = self.group_of(p)
            if g in self.GROUP_ORDER or g in ("tb.router_module", "tb.fifo_sb"):
                groups.setdefault(g, []).append(p)
        for g, members in groups.items():
            if len(members) < 2:
                continue
            xs = [boxes[m].x for m in members]
            ys_ = [boxes[m].y for m in members]
            xe = [boxes[m].x + boxes[m].w for m in members]
            ye_ = [boxes[m].y + boxes[m].h for m in members]
            frames.append({"id": g, "x": round(min(xs) - 10, 1), "y": round(min(ys_) - 26, 1),
                           "w": round(max(xe) - min(xs) + 20, 1), "h": round(max(ye_) - min(ys_) + 36, 1),
                           "label": f"{self.N[g]['name']} : {self.N[g]['type']}", "kind": self.N[g]["kind"]})
        lanes_out = [{"x": round(lane_x[l], 1), "w": round(col_w[l], 1),
                      "label": self.LANE_TITLES.get(l, "analysis")}
                     for l in sorted(lanes)]
        return {"id": sid, "view": "tlm", "node": None,
                "title": "TLM connections and data flow" + (" — Lab 9D variant (analysis FIFOs)" if variant else ""),
                "parent": None, "w": round(total_w, 1), "h": round(max_h + PAD, 1),
                "items": [b.to_dict() for b in boxes.values()], "edges": geo, "stubs": [], "frames": frames,
                "lanes": lanes_out}


def lane_of_kind_fixed(kind):
    return kind in ("vsequencer", "test", "reg_block", "reg_adapter", "sequencer", "driver", "monitor")


# ----------------------------------------------------------------------------- UML classes
class UmlLayout(Layout):
    LEVEL_GAP = 70
    SIB_GAP = 28
    MAX_MEMBERS = 9

    def scenes(self):
        out = []
        groups = list(self.m["groups"].keys())
        for g in groups:
            for full in (False, True):
                out.append(self.scene(g, full))
        out.append(self.scene(None, False))
        return out

    def class_nodes(self, group):
        return [nid for nid, n in self.N.items()
                if n.get("scope") == "cls" and n["kind"] not in ("uvm_base",)
                and (group is None or n.get("group") == group)]

    def members_text(self, n):
        fields = []
        for f in n.get("fields", []):
            pre = "rand " if f.get("rand") else ""
            fields.append(f"+ {pre}{f['type']} {f['name']}")
        methods = []
        for mth in n.get("methods", []):
            if mth["name"] == "new":
                continue
            methods.append(f"+ {mth['name']}()  {'[task]' if mth['kind'] == 'task' else ''}".rstrip())
        for c in n.get("constraints", []):
            methods.append(f"constraint {c['name']}")
        return fields, methods

    def make_class_box(self, nid, full):
        n = self.N[nid]
        label = n["name"]
        stereo = f"«{n.get('kind_label', n['kind'])}»"
        b = Box(nid, n, label, stereo, n["kind"], 0)
        fields, methods = ([], [])
        if full:
            fields, methods = self.members_text(n)
            more_f = max(0, len(fields) - self.MAX_MEMBERS)
            more_m = max(0, len(methods) - self.MAX_MEMBERS)
            fields = fields[:self.MAX_MEMBERS] + ([f"… {more_f} more"] if more_f else [])
            methods = methods[:self.MAX_MEMBERS] + ([f"… {more_m} more"] if more_m else [])
        texts = [label, stereo] + fields + methods
        w = max([tw(label, 14), tw(stereo, 11)] + [tw(t, 11) for t in fields + methods]) + 24
        if n["kind"] == "uvm_base":
            w = tw(label, 13) + 24
        h = 44
        if full:
            h += (len(fields) + len(methods)) * 16 + (8 if fields else 0) + (8 if methods else 0) + 6
        b.w, b.h = max(w, 110), h
        b.extra = {"fields": fields, "methods": methods, "full": full,
                   "item_type": n.get("item_type"), "group": n.get("group")}
        return b

    def scene(self, group, full):
        ids = self.class_nodes(group)
        idset = set(ids)
        inherits = {e["from"]: e["to"] for e in self.E if e["kind"] == "inherits" and e["from"] in idset}
        # roots: external bases (uvm:* or classes outside the group)
        children = {}
        roots = []
        externals = set()
        for c in ids:
            p = inherits.get(c)
            if p is None:
                roots.append(c)
            elif p in idset:
                children.setdefault(p, []).append(c)
            else:
                externals.add(p)
                children.setdefault(p, []).append(c)
        all_ids = ids + sorted(externals)
        boxes = {}
        for nid in all_ids:
            if nid in self.N:
                boxes[nid] = self.make_class_box(nid, full and nid in idset)
            else:
                n = {"name": nid.split(":")[-1], "kind": "uvm_base", "kind_label": "UVM", "scope": "cls"}
                b = Box(nid, n, n["name"], "«UVM»", "uvm_base", 0)
                b.w, b.h = tw(n["name"], 13) + 24, 40
                boxes[nid] = b
        # order roots: UVM bases first (components, then objects), then free classes
        BASE_ORDER = ["uvm_test", "uvm_env", "uvm_agent", "uvm_sequencer", "uvm_driver", "uvm_monitor",
                      "uvm_scoreboard", "uvm_component", "uvm_sequence_item", "uvm_sequence", "uvm_reg_block",
                      "uvm_reg", "uvm_mem", "uvm_reg_adapter", "uvm_object"]

        def root_key(r):
            name = r.split(":")[-1]
            n = self.N.get(r, {})
            if n.get("kind", "uvm_base") == "uvm_base" or r.startswith("uvm:"):
                return (0, BASE_ORDER.index(name) if name in BASE_ORDER else 50, name)
            return (1, 0, name)
        tops = sorted(externals, key=root_key) + sorted(roots, key=root_key)
        for p in children:
            children[p].sort(key=lambda c: (self.N[c]["kind"], c))
        # block layout: each subtree is a block; children sit in a grid (<= 4 per row) under the parent
        COLS = 4
        block = {}

        def measure(nid):
            b = boxes[nid]
            kids = children.get(nid, [])
            if not kids:
                block[nid] = (b.w, b.h, [])
                return block[nid]
            for k in kids:
                measure(k)
            rows = [kids[i:i + COLS] for i in range(0, len(kids), COLS)]
            rw = [sum(block[k][0] for k in r) + self.SIB_GAP * (len(r) - 1) for r in rows]
            rh = [max(block[k][1] for k in r) for r in rows]
            w = max([b.w] + rw)
            h = b.h + sum(self.LEVEL_GAP + x for x in rh)
            block[nid] = (w, h, list(zip(rows, rw, rh)))
            return block[nid]

        def place(nid, x, y):
            b = boxes[nid]
            w, h, rows = block[nid]
            b.move(x + (w - b.w) / 2 - b.x, y - b.y)
            cy = y + b.h + self.LEVEL_GAP
            for r, rw_, rh_ in rows:
                cx = x + (w - rw_) / 2
                for k in r:
                    place(k, cx, cy)
                    cx += block[k][0] + self.SIB_GAP
                cy += rh_ + self.LEVEL_GAP

        for t in tops:
            measure(t)
        # roots left to right, wrapped into rows of at most ~1800 px
        x, y = PAD, PAD + 30
        row_h = 0
        total_w = 0
        for t in tops:
            w, h, _ = block[t]
            if x > PAD and x + w > 1800:
                x = PAD
                y += row_h + self.LEVEL_GAP * 1.5
                row_h = 0
            place(t, x, y)
            x += w + self.SIB_GAP * 2
            row_h = max(row_h, h)
            total_w = max(total_w, x)
        x = total_w
        y = y + row_h + self.LEVEL_GAP
        total_w = x - self.SIB_GAP * 2 + PAD
        total_h = y - self.LEVEL_GAP + PAD
        # edges
        geo = []
        for c, p in inherits.items():
            if p not in boxes:
                continue
            a, b = boxes[c], boxes[p]
            x1, y1 = a.x + a.w / 2, a.y
            x2, y2 = b.x + b.w / 2, b.y + b.h
            dy = max(30, (y1 - y2) * 0.5)
            pts = [[round(x1, 1), round(y1, 1)], [round(x1, 1), round(y1 - dy, 1)],
                   [round(x2, 1), round(y2 + dy, 1)], [round(x2, 1), round(y2, 1)]]
            geo.append({"id": f"inh:{c}", "kind": "inherits", "from": c, "to": p, "points": pts, "label": None,
                        "lx": round((x1 + x2) / 2, 1), "ly": round((y1 + y2) / 2, 1), "bidir": False, "dashed": False})
        for e in self.E:
            if e["kind"] in ("runs_on", "uses", "starts", "overrides") and e["from"] in boxes and e["to"] in boxes:
                a, b = boxes[e["from"]], boxes[e["to"]]
                a_pt = self.anchor(a, (b.x + b.w / 2, b.y + b.h / 2))
                b_pt = self.anchor(b, (a.x + a.w / 2, a.y + a.h / 2))
                pts = [[round(a_pt[0], 1), round(a_pt[1], 1)], [round(b_pt[0], 1), round(b_pt[1], 1)]]
                mid = self.bezier_mid(pts)
                geo.append({"id": e["id"], "kind": e["kind"], "from": e["from"], "to": e["to"], "points": pts,
                            "label": e.get("label"), "lx": round(mid[0], 1), "ly": round(mid[1], 1),
                            "bidir": False, "dashed": True})
        glabel = self.m["groups"].get(group, {}).get("label", "All classes") if group else "All classes"
        sid = f"uml:{group or 'all'}" + (":full" if full else "")
        return {"id": sid, "view": "classes", "node": None, "group": group,
                "title": f"Classes — {glabel}" + (" (members)" if full else ""), "parent": None,
                "w": round(total_w, 1), "h": round(total_h, 1),
                "items": [b.to_dict() for b in boxes.values()], "edges": geo, "stubs": [], "full": full}


# ----------------------------------------------------------------------------- entry
# ----------------------------------------------------------------------------- Environment
class EnvLayout(HierarchyLayout):
    """The course figure of the verification environment: the test, the testbench with every
    UVC opened down to sequencer / driver / monitor, the interfaces and the DUT, one role
    line per box. Same machinery as the overview, deeper, with its own row hints."""
    def __init__(self, model, ann):
        super().__init__(model, ann)
        env_hints = (ann.get("layout") or {}).get("env", {})
        merged = dict(self.hints)
        merged.update(env_hints)
        self.hints = merged
        self.roles = True
        self.leaf_ids = {"tb.yapp_rm"}           # the register model stays one box (its registers are in the Hierarchy)

    def make_box(self, nid, depth, expand, show_ports=True):
        if nid in self.leaf_ids:
            expand = 0
        return super().make_box(nid, depth, expand, show_ports)

    def scenes(self):
        return [self.root_scene(expand_tb=6, sid="env:main", view="env", title="Verification environment")]


# ----------------------------------------------------------------------------- Tests
class PlanLayout(Layout):
    """The Test plan view. Top: one card per feature group of the verification plan, with its
    items as status-coloured chips. Below: one card per test (name, lab, base class, purpose,
    the stages of its plan as a strip of chips) in course order, the test-plan tests last.
    Edges: "covers" from a feature group to every test its items name, "inherits" between
    the tests."""
    CARD_W = 380
    COLS = 4
    CHIPS_PER_ROW = 3
    ITEMS_PER_ROW = 2
    KINDS = ("build", "config", "reset", "program", "stimulus", "check", "report")

    def feature_boxes(self):
        boxes = {}
        for g in self.m.get("plan", []):
            n = self.N[g["node"]]
            b = Box(n["id"], n, f"{g['id']} · {g['title']}", "", "feature", 0)
            lines = wrap(g.get("summary", ""), 62)[:3]
            items = [{"id": it["id"], "t": it["title"], "s": it.get("status", "covered"), "n": len(it.get("tests", []))}
                     for it in g["items"]]
            rows = math.ceil(len(items) / self.ITEMS_PER_ROW) if items else 0
            counts = {}
            for it in g["items"]:
                counts[it.get("status", "covered")] = counts.get(it.get("status", "covered"), 0) + 1
            b.w = self.CARD_W
            b.h = 44 + 15 * len(lines) + (8 + 24 * rows if rows else 0) + 10
            b.sub = g.get("spec", "")
            b.extra = {"style": "feature_card", "lines": lines, "plan_items": items, "counts": counts}
            boxes[n["id"]] = b
        return boxes

    def scenes(self):
        tests = [n for n in self.N.values() if n.get("scope") == "cls" and n.get("kind") == "test"]
        lab_order = {m["label"]: i for i, m in enumerate(self.ann["labs"].values())}
        plans = self.ann.get("tests") or {}

        def key(n):
            return (0 if n["name"] == self.ann["root_test"] else 1, lab_order.get(str(n.get("lab")), 99), n["name"])
        tests.sort(key=key)
        features = self.feature_boxes()
        boxes = {}
        for n in tests:
            plan = plans.get(n["name"]) or {}
            b = Box(n["id"], n, n["name"], "", n["kind"], 0)
            purpose = plan.get("purpose") or n.get("summary") or ""
            lines = wrap(purpose, 62)[:3]
            stages = [{"k": st.get("k", "stimulus"), "t": st.get("t", "")} for st in plan.get("stages", [])]
            rows = max(1, math.ceil(len(stages) / self.CHIPS_PER_ROW)) if stages else 0
            b.w = self.CARD_W
            b.h = 44 + 15 * len(lines) + (8 + 24 * rows if rows else 0) + 10
            sub = "test plan" if n.get("lab") == "TP" else (f"Lab {n['lab']}" if n.get("lab") else "")
            if n.get("base"):
                sub += ("  ·  " if sub else "") + f"extends {n['base']}"
            b.sub = sub
            b.extra = {"style": "test_card", "lab": n.get("lab"), "lines": lines, "stages": stages,
                       "base": n.get("base"), "nstages": len(plan.get("stages", []))}
            boxes[n["id"]] = b

        def grid(order, y):
            """Row-major grid of COLS cards starting at y; returns the y below the last row."""
            for i, b in enumerate(order):
                c = i % self.COLS
                if c == 0 and i:
                    y += max(ob.h for ob in order[i - self.COLS:i]) + GAP_Y
                b.move(PAD + c * (self.CARD_W + GAP_X) - b.x, y - b.y)
            return (max(b.y + b.h for b in order) if order else y) + GAP_Y

        x0, y0 = PAD, PAD + 10
        total_w = x0 + self.CARD_W * self.COLS + GAP_X * (self.COLS - 1) + PAD
        # 1. the feature groups
        feats = list(features.values())
        y = grid(feats, y0)
        # 2. the tests: the root test alone on its own row, then the rest row-major
        order = list(boxes.values())
        root = order[0]
        y += 30                                                   # air between the two halves
        root.move(x0 + (total_w - 2 * PAD - root.w) / 2 - root.x, y - root.y)
        y = y + root.h + GAP_Y + 10
        grid(order[1:], y)
        items = feats + order
        total_h = max(b.y + b.h for b in items) + PAD
        edges = []
        for e in self.E:
            if e["kind"] == "inherits" and e["from"] in boxes and e["to"] in boxes:
                a, b = boxes[e["from"]], boxes[e["to"]]
                pts = self.route((a.x + a.w / 2, a.y), (b.x + b.w / 2, b.y + b.h), "top", "bottom")
                mid = self.bezier_mid(pts)
                edges.append({"id": e["id"], "kind": "inherits", "from": e["from"], "to": e["to"],
                              "points": [[round(x, 1), round(y_, 1)] for x, y_ in pts], "label": "",
                              "lx": round(mid[0], 1), "ly": round(mid[1], 1), "bidir": False, "dashed": False})
            elif e["kind"] == "covers" and e["from"] in features and e["to"] in boxes:
                a, b = features[e["from"]], boxes[e["to"]]
                pts = self.route((a.x + a.w / 2, a.y + a.h), (b.x + b.w / 2, b.y), "bottom", "top")
                mid = self.bezier_mid(pts)
                edges.append({"id": e["id"], "kind": "covers", "from": e["from"], "to": e["to"],
                              "points": [[round(x, 1), round(y_, 1)] for x, y_ in pts], "label": "",
                              "lx": round(mid[0], 1), "ly": round(mid[1], 1), "bidir": False, "dashed": True})
        return [{"id": "plan:main", "view": "plan", "node": None, "title": "Test plan",
                 "parent": None, "w": round(total_w, 1), "h": round(total_h, 1),
                 "items": [b.to_dict() for b in items], "edges": edges, "stubs": [],
                 "split": round(feats[-1].y + feats[-1].h + 15, 1) if feats else 0}]


def wrap(text, width):
    """Greedy word wrap for the card texts."""
    words, lines, cur = text.split(), [], ""
    for w in words:
        if cur and len(cur) + 1 + len(w) > width:
            lines.append(cur)
            cur = w
        else:
            cur = (cur + " " + w).strip()
    if cur:
        lines.append(cur)
    return lines


def build_scenes(model, ann):
    scenes = []
    scenes += HierarchyLayout(model, ann).scenes()
    scenes += TlmLayout(model, ann).scenes()
    scenes += UmlLayout(model, ann).scenes()
    scenes += EnvLayout(model, ann).scenes()
    scenes += PlanLayout(model, ann).scenes()
    # which hierarchy scene draws each node (for search / deep links)
    where = {}
    for s in scenes:
        for it in s["items"]:
            where.setdefault(it["id"], []).append(s["id"])
            for p in it.get("ports", []):
                where.setdefault(p["id"], []).append(s["id"])
    return scenes, where
