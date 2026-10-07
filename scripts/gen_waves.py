#!/usr/bin/env python3
"""
gen_waves.py -- render the protocol timing diagrams of the docs as SVG.

Each diagram is a list of signals. A signal is (name, kind, values, edge):
  kind   'clk'  : square wave, one period per cycle
         'bit'  : 0 / 1 / 'z'
         'bus'  : a label per slot ('' = idle, '-' = continue previous value)
  edge   'neg'  : the signal changes on the FALLING edge (testbench-driven)
         'pos'  : the signal changes on the RISING edge (DUT-driven)
Output: docs/assets/wave_<name>.svg and docs/assets/packet_structure.svg
"""
import os

W = 44            # pixels per clock cycle
H = 26            # signal height
ROW = 44          # row pitch
LEFT = 118        # label column
TOP = 14

OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs", "assets")


def svg_header(width, height):
    return [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
            f'viewBox="0 0 {width} {height}" font-family="monospace" font-size="12">',
            '<style>'
            '.lbl{fill:#444}.sig{fill:none;stroke:#1a5fb4;stroke-width:1.6}'
            '.clk{fill:none;stroke:#555;stroke-width:1.4}'
            '.bus{fill:#e8f0fe;stroke:#1a5fb4;stroke-width:1.2}'
            '.idle{stroke:#999;stroke-width:1.2;stroke-dasharray:0}'
            '.z{stroke:#999;stroke-dasharray:3 3}'
            '.txt{fill:#1a1a1a;text-anchor:middle}'
            '.grid{stroke:#ddd;stroke-width:0.8;stroke-dasharray:2 3}'
            '.note{fill:#c01c28;font-size:11px}'
            '@media (prefers-color-scheme: dark){.lbl{fill:#ccc}.clk{stroke:#aaa}.txt{fill:#eee}'
            '.bus{fill:#1e2a44}.grid{stroke:#444}}'
            '</style>']


def render(name, signals, cycles, notes=()):
    width = LEFT + cycles * W + 20
    height = TOP + ROW * len(signals) + 12 + (26 if notes else 0)
    out = svg_header(width, height)
    # cycle grid at rising edges
    for c in range(cycles + 1):
        x = LEFT + c * W
        out.append(f'<line class="grid" x1="{x}" y1="{TOP}" x2="{x}" y2="{TOP + ROW*len(signals) - 10}"/>')
    for r, (label, kind, values, edge) in enumerate(signals):
        y0 = TOP + r * ROW            # top of the row
        y1 = y0 + H                   # logic-0 line
        out.append(f'<text class="lbl" x="{LEFT - 8}" y="{y0 + H*0.7}" text-anchor="end">{label}</text>')
        off = W / 2 if edge == "neg" else 0
        if kind == "clk":
            pts = []
            for c in range(cycles):
                x = LEFT + c * W
                pts += [(x, y1), (x, y0), (x + W/2, y0), (x + W/2, y1), (x + W, y1)]
            d = "M" + " L".join(f"{px},{py}" for px, py in pts)
            out.append(f'<path class="clk" d="{d}"/>')
        elif kind == "bit":
            # expand continuation
            vals = []
            for v in values:
                vals.append(vals[-1] if v == "-" and vals else v)
            pts = []
            prev = None
            for c, v in enumerate(vals):
                x = LEFT + c * W + off
                if v == "z":
                    ym = (y0 + y1) / 2
                    out.append(f'<line class="sig z" x1="{x}" y1="{ym}" x2="{x + W}" y2="{ym}"/>')
                    prev = None
                    continue
                y = y1 if v == 0 or v == "0" else y0
                if prev is not None and prev != y:
                    pts.append((x, prev))
                pts.append((x, y))
                pts.append((x + W, y))
                prev = y
            if pts:
                d = "M" + " L".join(f"{px},{py}" for px, py in pts)
                out.append(f'<path class="sig" d="{d}"/>')
        elif kind == "bus":
            c = 0
            while c < len(values):
                v = values[c]
                if v == "-":
                    c += 1
                    continue
                n = 1
                while c + n < len(values) and values[c + n] == "-":
                    n += 1
                x = LEFT + c * W + off
                wdt = n * W
                ym = (y0 + y1) / 2
                if v == "" or v == "z":
                    cls = "sig z" if v == "z" else "idle"
                    out.append(f'<line class="{cls}" x1="{x}" y1="{ym}" x2="{x + wdt}" y2="{ym}"/>')
                else:
                    s = 5
                    d = (f"M{x},{ym} L{x+s},{y0} L{x+wdt-s},{y0} L{x+wdt},{ym} "
                         f"L{x+wdt-s},{y1} L{x+s},{y1} Z")
                    out.append(f'<path class="bus" d="{d}"/>')
                    out.append(f'<text class="txt" x="{x + wdt/2}" y="{ym + 4}">{v}</text>')
                c += n
    for i, (text, cycle) in enumerate(notes):
        x = LEFT + cycle * W
        y = TOP + ROW * len(signals) + 14
        out.append(f'<text class="note" x="{x}" y="{y}">{text}</text>')
    out.append("</svg>")
    os.makedirs(OUT, exist_ok=True)
    path = os.path.join(OUT, f"wave_{name}.svg")
    with open(path, "w") as fh:
        fh.write("\n".join(out))
    print("wrote", os.path.relpath(path))


def packet_structure(name="packet_structure"):
    """The YAPP packet byte layout: header {length[5:0], addr[1:0]}, payload[0..N-1], parity."""
    BW, BH, X0, Y0 = 250, 30, 90, 46            # byte box width / height, left edge, top
    rows = [("header", [("length", 6), ("addr", 2)]), ("payload[0]", None), ("payload[1]", None),
            ("…", None), ("payload[N-1]", None), ("parity", None)]
    width, height = X0 + 640, Y0 + BH * len(rows) + 70
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
           f'viewBox="0 0 {width} {height}" font-family="sans-serif" font-size="13">',
           '<style>'
           '.box{fill:#dbe8ff;stroke:#1a5fb4;stroke-width:1.3}.hdr{fill:#c5d8ff}.par{fill:#e9ddf5}.dots{fill:#f3f6fb}'
           '.txt{fill:#1a1a1a;text-anchor:middle;font-family:monospace}.lbl{fill:#444}.bit{fill:#444;text-anchor:middle;font-family:monospace;font-size:12px}'
           '.ttl{fill:#1a1a1a;font-weight:bold;font-size:15px}.side{fill:#1a1a1a;font-size:14px}.brace{fill:none;stroke:#444;stroke-width:1.2}'
           '.note{fill:#555;font-size:12px}'
           '@media (prefers-color-scheme: dark){.box{fill:#1e3a66;stroke:#8ab4f8}.hdr{fill:#243f70}.par{fill:#3b2a52}.dots{fill:#2a2f3a}'
           '.txt,.ttl,.side{fill:#eee}.lbl,.bit{fill:#ccc}.brace{stroke:#ccc}.note{fill:#bbb}}'
           '</style>',
           f'<text class="ttl" x="{X0}" y="22">Packet structure</text>']
    # bit ruler 7 .. 0 over the header
    for i in range(8):
        out.append(f'<text class="bit" x="{X0 + BW/8*(i+0.5):.1f}" y="{Y0-6}">{7-i}</text>')
    for r, (label, fields) in enumerate(rows):
        y = Y0 + r * BH
        cls = "box hdr" if r == 0 else "box par" if label == "parity" else "box dots" if label == "…" else "box"
        if fields:
            x = X0
            for fname, bits in fields:
                w = BW * bits / 8
                out.append(f'<rect class="{cls}" x="{x:.1f}" y="{y}" width="{w:.1f}" height="{BH}"/>')
                out.append(f'<text class="txt" x="{x + w/2:.1f}" y="{y + BH*0.65:.1f}">{fname}</text>')
                x += w
        else:
            out.append(f'<rect class="{cls}" x="{X0}" y="{y}" width="{BW}" height="{BH}"/>')
            out.append(f'<text class="txt" x="{X0 + BW/2}" y="{y + BH*0.65:.1f}">{label}</text>')
        byte = {0: "byte 0", 1: "byte 1", 4: "byte N", 5: "byte N+1"}.get(r)
        if byte:
            out.append(f'<text class="lbl" x="{X0 + BW + 10}" y="{y + BH*0.65:.1f}">{byte}</text>')
    # side labels
    out.append(f'<text class="side" x="{X0 + BW + 95}" y="{Y0 + BH*0.65:.1f}">Header</text>')
    out.append(f'<text class="side" x="{X0 + BW + 95}" y="{Y0 + BH*5 + BH*0.65:.1f}">Parity</text>')
    y1, y2 = Y0 + BH + 3, Y0 + BH * 5 - 3
    bx = X0 + BW + 72
    out.append(f'<path class="brace" d="M{bx},{y1} h8 v{(y2-y1)/2 - 6:.1f} l6,6 l-6,6 v{(y2-y1)/2 - 6:.1f} h-8"/>')
    out.append(f'<text class="side" x="{bx + 24}" y="{(y1 + y2)/2 + 5:.1f}">Payload</text>')
    out.append(f'<text class="note" x="{X0}" y="{Y0 + BH*6 + 26}">1 ≤ N ≤ 63 payload bytes · header = {{length[5:0], addr[1:0]}} · addr 3 is illegal</text>')
    out.append(f'<text class="note" x="{X0}" y="{Y0 + BH*6 + 44}">parity = even bitwise parity (XOR) over the header and all payload bytes · packet = N + 2 bytes</text>')
    out.append("</svg>")
    path = os.path.join(OUT, f"{name}.svg")
    with open(path, "w") as fh:
        fh.write("\n".join(out))
    print("wrote", path)


def main():
    packet_structure()
    # ---- YAPP input port: two packets, the second one suspended for a cycle
    render("yapp_input", [
        ("clock",       "clk", None, "pos"),
        ("in_data_vld", "bit", [0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0], "neg"),
        ("in_data",     "bus", ["", "H", "D0", "D1", "D2", "P", "", "", "H", "D0", "D0", "D1", "D2", "P", ""], "neg"),
        ("in_suspend",  "bit", [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], "pos"),
        ("packet",      "bus", ["", "packet 1 (len 3)", "-", "-", "-", "-", "", "", "packet 2 (D0 held one cycle)", "-", "-", "-", "-", "-", ""], "neg"),
    ], 15, notes=[("inputs change on the falling edge; the DUT samples on the rising edge", 0)])

    # ---- Channel output
    render("channel_output", [
        ("clock",      "clk", None, "pos"),
        ("data_vld_0", "bit", [0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0], "pos"),
        ("data_0",     "bus", ["", "", "H", "-", "-", "D0", "D1", "D2", "P", "", ""], "pos"),
        ("suspend_0",  "bit", [1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1], "neg"),
        ("received",   "bus", ["", "", "", "", "H", "D0", "D1", "D2", "P", "", ""], "neg"),
    ], 11, notes=[("receiver drops suspend on the falling edge where it reads the header; one new byte per rising edge while suspend is low", 0)])

    # ---- HBUS write (1 cycle) and read (2 cycles)
    render("hbus", [
        ("clock",       "clk", None, "pos"),
        ("hen",         "bit", [0, 1, 0, 0, 1, 1, 0, 0], "neg"),
        ("hwr_rd",      "bit", [0, 1, 0, 0, 0, 0, 0, 0], "neg"),
        ("haddr",       "bus", ["", "A", "", "", "A", "-", "", ""], "neg"),
        ("hdata (TB)",  "bus", ["z", "D", "z", "z", "z", "z", "z", "z"], "neg"),
        ("hdata (DUT)", "bus", ["z", "z", "z", "z", "z", "D", "z", "z"], "pos"),
        ("transaction", "bus", ["", "write", "", "", "read", "-", "", ""], "neg"),
    ], 8, notes=[("write: data stored on the rising edge inside the hen cycle; read: address sampled in cycle 1, data driven by the DUT in cycle 2", 0)])

    # ---- Reset / clock start
    render("clock_reset", [
        ("run_clock",    "bit", [0, 1, 1, 1, 1, 1, 1, 1, 1], "neg"),
        ("clock",        "clk", None, "pos"),
        ("reset",        "bit", [0, 1, 1, 1, 1, 1, 0, 0, 0], "neg"),
        ("clock_period", "bus", ["10", "-", "-", "-", "-", "-", "-", "-", "-"], "neg"),
    ], 9, notes=[("clk10_rst5_seq: period 10, reset held for 5 clock cycles, released on a falling edge", 0)])


if __name__ == "__main__":
    main()
