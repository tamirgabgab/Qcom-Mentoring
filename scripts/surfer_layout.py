#!/usr/bin/env python3
"""
surfer_layout.py -- the signal layout of the YAPP router waves for Surfer.

Writes yapp_project/tb/yapp_router.sucl, a Surfer command file that adds the
signals of the project in named groups, one per part of the design, with hex
on the data buses, the clock drawn as a clock and one color per group:

  Clock, reset       hw_top.clock, hw_top.reset
  Input port         hw_top.in0: what the YAPP driver drives; plus u_tracer.in_phase
  Input FSM          hw_top.dut.u_input_fsm: state, address, length, drop, FIFO push
  FIFO fill          hw_top.dut.g_ch[c].u_ch.u_fifo.count: bytes waiting per channel
  Channel 0 / 1 / 2  hw_top.ch0..2: data, data_vld, the receiver's suspend
  Error              hw_top.dut: the error pulse, pkt_done, u_error_timer.sched (pulses owed)
  HBUS               hw_top.hbus0: hen, hwr_rd, haddr, hdata
  Config, counters   hw_top.dut: router_en, maxpktsize; u_regs: the statistics registers
  Packet memory      hw_top.dut.u_regs.yapp_pkt_mem[0..63], folded
  Scratch memory     hw_top.dut.u_regs.yapp_mem[0..255], folded
                     (both need a .fst recorded with --trace-max-array 256, see scripts/sim.py)

Open a .fst, then File -> Run command file... and pick the .sucl. The same
file works for every test: the hierarchy is the same in all of them.

Four settings have no command: yapp_router.surf.ron, the state Surfer saves
after running the .sucl with STATE_SETTINGS put in (--state, below), carries
them -- File -> Load state... after opening a .fst.

surfer_url(fst) is the one-click link of a committed .fst: Surfer's web app
loads the waves and this command file straight from GitHub. sim_report.py puts
it in the report.
"""
import os
import sys
from urllib.parse import quote

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SUCL = os.path.join(ROOT, "yapp_project", "tb", "yapp_router.sucl")
RAW = "https://raw.githubusercontent.com/tamirgabgab/Qcom-Mentoring/main/"
APP = "https://app.surfer-project.org/"

D = "hw_top.dut."
# (group, color, [(signal, format or None[, label]), ...]). Format None keeps Surfer's
# choice (a 1-bit signal as a line, an enum by its names, a bus in hex); a label
# replaces the signal's name in the list. Group names stay short: Surfer's name
# column is narrow. The scope of each group is in the module docstring.
LAYOUT = [
    ("Clock, reset", "Gray", [
        ("hw_top.clock", "Clock"),
        ("hw_top.reset", None),
    ]),
    ("Input port", "Green", [
        ("hw_top.in0.in_data", "Hexadecimal"),
        ("hw_top.in0.in_data_vld", None),
        ("hw_top.in0.in_suspend", None),
        (D + "u_tracer.in_phase", None),
    ]),
    ("Input FSM", "Yellow", [
        (D + "u_input_fsm.state", None),
        (D + "u_input_fsm.cur_addr", "Unsigned"),
        (D + "u_input_fsm.cur_len", "Unsigned"),
        (D + "u_input_fsm.byte_cnt", "Unsigned"),
        (D + "u_input_fsm.cur_drop", None),
        (D + "u_input_fsm.fifo_push", "Binary"),
        (D + "u_input_fsm.fifo_full", "Binary"),
    ]),
    ("FIFO fill", "Orange", [
        (D + f"g_ch[{c}].u_ch.u_fifo.count", "Unsigned", f"ch{c} count") for c in range(3)
    ]),
] + [
    (f"Channel {c}", "Blue", [
        (f"hw_top.ch{c}.data", "Hexadecimal"),
        (f"hw_top.ch{c}.data_vld", None),
        (f"hw_top.ch{c}.suspend", None),
    ]) for c in range(3)
] + [
    ("Error", "Red", [
        (D + "error", None),
        (D + "pkt_done", None),
        (D + "u_error_timer.sched", "Binary", "pulses owed"),   # bit k: a pulse k cycles from now
    ]),
    ("HBUS", "Pink", [
        ("hw_top.hbus0.hen", None),
        ("hw_top.hbus0.hwr_rd", None),
        ("hw_top.hbus0.haddr", "Hexadecimal"),
        ("hw_top.hbus0.hdata", "Hexadecimal"),
    ]),
    ("Config, counters", "Violet", [
        (D + "router_en", None),
        (D + "maxpktsize", "Unsigned"),
    ] + [
        (D + f"u_regs.{r}", "Unsigned") for r in (
            "addr0_cnt_reg", "addr1_cnt_reg", "addr2_cnt_reg", "addr3_cnt_reg",
            "parity_err_cnt_reg", "oversized_pkt_cnt_reg")
    ]),
]

# (scope, group name): the two memories of the spec, at the end of the list, folded.
MEMORIES = [
    (D + "u_regs.yapp_pkt_mem", "Packet memory"),     # 0x1010, 64 B, RO: the last packet
    (D + "u_regs.yapp_mem", "Scratch memory"),        # 0x1100, 256 B, RW
]


def alpha(idx):
    """Surfer's item reference: the visible index in hex, written with the letters a..p."""
    return "".join("abcdefghijklmnop"[int(d, 16)] for d in f"{idx:x}")


def commands():
    """The command file. How Surfer builds the list (libsurfer, checked with Surfer 0.7):
      * variable_add inserts after the focused item, at its level, and moves the focus to
        the new item -- only when something is focused; with no focus it appends at the end;
      * group_marked wraps the focused item in a new group and focuses the group;
      * with an open group focused, variable_add inserts as the group's first child.
    So each group starts from its LAST signal, added at the end and focused by its row,
    wrapped and renamed; its other signals are then added in order in front of it."""
    out = ["# Surfer command file: the YAPP router signals in groups.",
           "# Generated by scripts/surfer_layout.py -- edit LAYOUT there, not this file.",
           "# Open a .fst first, then File -> Run command file... and pick this file.",
           ""]
    row = 0                                   # rows in the list so far (every group stays open)
    for name, color, signals in LAYOUT:
        def style(fmt, label=None):
            if fmt:
                out.append(f"item_set_format {fmt}")
            out.append(f"item_set_color {color}")
            if label:
                out.append(f"item_rename {label}")
        out.append(f"# {name}")
        out.append("item_unfocus")            # the next variable goes to the end, at the top level
        last = signals[-1]
        out.append(f"variable_add {last[0]}")
        out.append(f"item_focus {alpha(row)}")
        style(*last[1:])
        out.append("group_marked")            # the group takes this row, the variable moves under it
        out.append(f"item_rename {name}")
        out.append(f"item_set_color {color}")
        for sig, *rest in signals[:-1]:
            out.append(f"variable_add {sig}")
            style(*rest)
        row += len(signals) + 1
        out.append("")
    # The memories: each a scope of [0]..[n-1] in the waves, added whole as one
    # group and folded so it does not push the rest down; click it open. A folded
    # group is one visible row, which is what item_focus counts.
    for scope, name in MEMORIES:
        out += [f"# {name} ({scope}), folded",
                "item_unfocus",
                f"scope_add_as_group {scope}",
                f"item_focus {alpha(row)}",
                f"item_rename {name}",
                "item_set_color Violet",
                "group_fold_recursive",
                ""]
        row += 1
    out += ["# The view",
            "item_unfocus",
            # = Settings -> Variable names -> Global: full paths (hw_top.ch0.data), and the
            # default for variables added later. Labels set with item_rename stay.
            "variable_force_name_type Global",
            "preference_set_clock_highlight Line",
            "preference_set_hierarchy_style Tree",   # = Settings -> Hierarchy -> Tree
            "zoom_fit"]
    return "\n".join(out) + "\n"


# Settings that no Surfer command sets but a state file keeps (Settings menu):
# Focus highlight -> Background, Hierarchy -> Tree, Show hierarchy icons on,
# Fill high values off.
STATE_SETTINGS = {
    "focus_highlight": "Some(Background)",
    "hierarchy_style": "Some(Tree)",
    "show_hierarchy_icons": "Some(true)",
    "fill_high_values": "Some(false)",
}
STATE = os.path.join(ROOT, "yapp_project", "tb", "yapp_router.surf.ron")


def settle_state(text):
    """A state saved by Surfer after running the .sucl, with STATE_SETTINGS put in
    and the wave source forgotten (Load state keeps the waves that are open)."""
    import re
    for key, value in STATE_SETTINGS.items():
        text, n = re.subn(rf"^(    {key}: ).*,$", rf"\g<1>{value},", text, count=1, flags=re.M)
        if n != 1:
            sys.exit(f"surfer_layout.py: no top-level '{key}' in the state file")
    text, n = re.subn(r"^(        source: ).*,$", r"\g<1>DragAndDrop(None),", text, count=1, flags=re.M)
    if n != 1:
        sys.exit("surfer_layout.py: no wave source in the state file")
    return text


def missing_signals(fst):
    """The LAYOUT signals a .fst does not have (needs the pywellen reader; None without it).
    A missing signal is not just absent in Surfer: the rows after it shift and the groups
    fall apart, so a renamed RTL signal must be renamed here too."""
    try:
        import pywellen
    except ImportError:
        return None
    names = {v.full_name for v in pywellen.Waveform(fst).all_vars()}
    wanted = [sig for _name, _color, signals in LAYOUT for sig, *_rest in signals]
    wanted += [scope + ".[0]" for scope, _name in MEMORIES]
    return [sig for sig in wanted if sig not in names]


def surfer_url(fst_rel):
    """The Surfer web app with a committed .fst (path relative to the repo) and this layout."""
    waves = RAW + fst_rel.replace(os.sep, "/")
    cmds = "run_command_file_from_url " + RAW + os.path.relpath(SUCL, ROOT).replace(os.sep, "/")
    return f"{APP}?load_url={quote(waves, safe='')}&startup_commands={quote(cmds, safe='')}"


def main():
    """No argument: write the .sucl. `--state <saved.surf.ron>`: write the .surf.ron
    from a state Surfer saved after running the .sucl (File -> Save state as...).
    `--check <file.fst>`: every signal of the layout must be in the waves."""
    if len(sys.argv) == 3 and sys.argv[1] == "--check":
        missing = missing_signals(sys.argv[2])
        if missing is None:
            sys.exit("surfer_layout.py --check needs pywellen (pip install pywellen)")
        print("every layout signal is in the .fst" if not missing else "missing: " + ", ".join(missing))
        sys.exit(1 if missing else 0)
    if len(sys.argv) == 3 and sys.argv[1] == "--state":
        with open(sys.argv[2]) as fh:
            text = settle_state(fh.read())
        with open(STATE, "w") as fh:
            fh.write(text)
        print(f"wrote {os.path.relpath(STATE, ROOT)}")
        return
    with open(SUCL, "w") as fh:
        fh.write(commands())
    print(f"wrote {os.path.relpath(SUCL, ROOT)}")
    if len(sys.argv) > 1:
        print(surfer_url(sys.argv[1]))


if __name__ == "__main__":
    main()
