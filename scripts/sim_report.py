#!/usr/bin/env python3
"""
sim_report.py -- bundle the logs of the last Verilator regression into a report
that reads like a story: one folder per run (test + seed) with its log, a
timeline of what happened (extracted from the [TEST] and [DUT] lines and the
UVC messages of the log), the waves, and wave pictures of the interesting
moments (first packet in, first packet out, back-pressure, error pulse, HBUS).

    python3 scripts/sim_report.py [--only PATTERN] [--out DIR] [--zip]
    make sim-report [ONLY=yapp_project]

Reads build/sim/<bench>/logs/<test>_s<seed>.log and, when the regression ran
with --waves (make regress WAVES=1), waves/<test>_s<seed>.fst and
trace/<test>_s<seed>.csv (the per-cycle signal trace of yapp_router_tracer).
Writes

    build/sim/report/
      index.md                        every run: result, counts, links; the failures first
      runs.json                       the same per run, as data (the site pages and the map read it)
      all_logs.log                    every log in one file, with banners (local reports only)
      <bench>/<test>_s<seed>/
        <test>_s<seed>.log            the log of the run
        timeline.md                   summary, stages and the timeline (the longest runs keep
                                      only the test, DUT, HBUS and report events)
        timeline.csv                  the same events, one per row (local reports only)
        <test>_s<seed>.fst            the waves (GTKWave, Surfer, VS Code)
        signals.csv                   the per-cycle signal trace (local reports only)
        wave_*.svg                    the pictures
      coverage.md                     the functional coverage merged over every run
      coverage.json                   the same data (the site page and the map read it)
      <bench>/merged.dat, merged.info the merged coverage database (verilator_coverage, lcov)
      coverage_html/<bench>/          genhtml of merged.info (docs/coverage/<bench>/ for the
                                      committed report, so the site serves it)
    build/sim/regression_report.zip   with --zip

The committed report of the project lives in yapp_project/regression/
(make sim-report ONLY=yapp_project OUT=yapp_project/regression). It leaves out the
files that only repeat the log or the waves (all_logs.log, timeline.csv, signals.csv)
and copies the pictures of seed 1 of every test to docs/assets/regression/<test>/,
where the site's regression pages (scripts/project_map/build.py) show them.

The log lines it understands are documented in docs/appendix/sim-report.md.
"""
import argparse
import bisect
import csv
import glob
import json
import os
import re
import shutil
import subprocess
import sys
import time
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
import coverage_report  # noqa: E402  (the merged functional coverage: coverage.md, json, HTML)
import gen_waves  # noqa: E402  (render(): the SVG timing-diagram drawer of the docs)
import surfer_layout  # noqa: E402  (surfer_url(): one-click link to the waves in Surfer's web app)

BUILD = os.path.join(ROOT, "build", "sim")
SITE_PICS = os.path.join(ROOT, "docs", "assets", "regression")   # seed-1 pictures for the site pages
TIMELINE_MAX = 1500      # a run with more events keeps only the important ones in timeline.md
KEEP_WHO = ("test", "DUT", "hbus monitor", "reference", "scoreboard", "coverage", "error checker")

# UVM_INFO file(line) @ time: path [id] message     (Accellera UVM report format)
UVM_RE = re.compile(r"^UVM_(INFO|WARNING|ERROR|FATAL) (\S+?)\((\d+)\) @ +(\d+)(?:\s*[a-z]+)?: (\S+) \[(\S+)\] ?(.*)$")
DROP_RE = re.compile(r"^(\d+) ROUTER DROPS PACKET (.*)$")
BANNER_RE = re.compile(r"=== (\S+)  seed (\S+?)(?:: (PASSED|FAILED) \((\d+) UVM_ERROR, (\d+) UVM_FATAL\))? ===")

# who -> (label in the timeline, keep INFO lines?)
WHO = [
    (re.compile(r"\.yapp\.agent\.driver$"),        "yapp driver"),
    (re.compile(r"\.yapp\.agent\.monitor$"),       "yapp monitor"),
    (re.compile(r"\.chan(\d)\.rx_agent\.driver$"), "ch{0} driver"),
    (re.compile(r"\.chan(\d)\.rx_agent\.monitor$"), "ch{0} monitor"),
    (re.compile(r"\.hbus\.masters\[\d+\]\.driver$"), "hbus driver"),
    (re.compile(r"\.hbus\.monitor$"),              "hbus monitor"),
    (re.compile(r"\.router_module\.scoreboard$"),  "scoreboard"),
    (re.compile(r"\.router_module\.reference$"),   "reference"),
    (re.compile(r"\.clk_rst\.agent\.driver$"),     "clk/rst driver"),
    (re.compile(r"\.err_chk$"),                    "error checker"),
    (re.compile(r"\.yapp\.agent\.(pkt|gap)_cov$"),  "coverage"),
    (re.compile(r"\.router_module\.coverage$"),   "coverage"),
    (re.compile(r"\.router_module\.hbus_\w+_cov$"), "coverage"),
]


# ------------------------------------------------------------------ log parsing
def who_of(path, msg_id):
    if msg_id == "TEST":
        return "test"
    if msg_id == "DUT":
        return "DUT"
    for rx, label in WHO:
        m = rx.search(path)
        if m:
            return label.format(*m.groups())
    if path == "uvm_test_top" or path.startswith("uvm_test_top.") and path.count(".") == 1 and "tb" not in path:
        return "test"
    if msg_id in ("RegModel",):
        return "ral"
    if path == "uvm_test_top":
        return "test"
    return "other"


def parse_log(text):
    """Events of one log: dicts with time, sev, who, id, msg, plus the banner info."""
    events, info = [], {"test": "?", "seed": "?", "verdict": None, "errors": 0, "fatals": 0,
                        "wall": None, "verilator": None}
    cont = None          # the last event: a line that is not a UVM line continues its message
    for line in text.splitlines():
        m = UVM_RE.match(line)
        if m:
            sev, _f, _l, t, path, mid, msg = m.groups()
            who = who_of(path, mid)
            cont = None
            if mid == "TEST":
                b = BANNER_RE.search(msg)
                if b:
                    info["test"], info["seed"] = b.group(1), b.group(2)
                    if b.group(3):
                        info["verdict"], info["errors"], info["fatals"] = b.group(3), int(b.group(4)), int(b.group(5))
                    continue                       # banners are not timeline events
            if sev == "INFO" and who in ("other", "ral"):
                continue
            cont = {"time": int(t), "sev": sev, "who": who, "id": mid, "msg": msg}
            events.append(cont)
            continue
        m = DROP_RE.match(line)
        if m:
            cont = None
            events.append({"time": int(m.group(1)), "sev": "INFO", "who": "DUT", "id": "RTL",
                           "msg": "ROUTER DROPS PACKET " + m.group(2)})
            continue
        if line.startswith("--- UVM Report Summary"):
            cont = None
        m = re.search(r"walltime ([\d.]+) s", line)
        if m and line.startswith("- Verilator:"):
            info["wall"] = float(m.group(1))
        m = re.search(r"R e p o r t: Verilator (\d+\.\d+)", line)
        if m:
            info["verilator"] = m.group(1)
        if cont is not None and line.strip():
            # a multi-line message (the report_phase blocks of the reference model and the scoreboard)
            part = " ".join(line.split())
            cont["msg"] = (cont["msg"] + " · " + part) if cont["msg"].strip() else part
    return events, info


def summarize(events):
    """Counts for the summary block, taken from the message formats of the UVCs and the tracer."""
    s = {"tx": 0, "tx_bad": 0, "rx_in": 0, "in_fwd": 0, "in_drop": 0, "drop_reasons": {}, "out": [0, 0, 0],
         "matched": 0, "mismatched": 0, "unexpected": 0, "suspends": 0, "suspend_max": 0, "err_pulses": 0,
         "hbus_wr": 0, "hbus_rd": 0, "stages": [], "uvm_errors": 0, "uvm_warnings": 0, "uvm_fatals": 0,
         "first": {}}
    for e in events:
        msg, who = e["msg"], e["who"]
        if e["sev"] == "ERROR":
            s["uvm_errors"] += 1
        elif e["sev"] == "FATAL":
            s["uvm_fatals"] += 1
        elif e["sev"] == "WARNING":
            s["uvm_warnings"] += 1
        if who == "test" and msg.startswith("STAGE: "):
            s["stages"].append((e["time"], msg[7:]))
        elif who == "yapp driver" and msg.startswith("TX pkt") and "accepted" not in msg:
            s["tx"] += 1
            if "parity=bad" in msg:
                s["tx_bad"] += 1
        elif who == "yapp monitor" and msg.startswith("RX pkt"):
            s["rx_in"] += 1
        elif who == "DUT":
            if " header: " in msg:
                s["first"].setdefault("in_header", e)
                if "DROP (" in msg:
                    s["in_drop"] += 1
                    reason = msg.split("DROP (", 1)[1].rstrip(")")
                    reason = reason.split(":")[0]
                    s["drop_reasons"][reason] = s["drop_reasons"].get(reason, 0) + 1
                else:
                    s["in_fwd"] += 1
            elif " complete: " in msg:
                s["first"].setdefault("in_complete", e)
                if "parity=BAD" in msg:
                    s["first"].setdefault("bad_complete", e)
                    s["last_bad"] = e
            elif msg.startswith("OUT ch") and " start: " in msg:
                ch = int(msg[6])
                s["out"][ch] += 1
                s["first"].setdefault("out_start", e)
            elif msg.startswith("OUT ch") and " done: " in msg:
                if "out_start" in s["first"] and "out_done" not in s["first"] \
                        and msg[6] == s["first"]["out_start"]["msg"][6]:
                    s["first"]["out_done"] = e
            elif msg.startswith("SUSPEND asserted"):
                s["suspends"] += 1
                s["first"].setdefault("suspend", e)
            elif msg.startswith("SUSPEND released"):
                m = re.search(r"after (\d+)", msg)
                if m:
                    s["suspend_max"] = max(s["suspend_max"], int(m.group(1)))
            elif msg.startswith("ERROR pulse"):
                s["err_pulses"] += 1
                if "err_pulse" not in s["first"]:
                    s["first"]["err_pulse"] = e
                    s["first"]["err_bad"] = s.get("last_bad")
        elif who == "scoreboard":
            if "pkt matched" in msg:
                s["matched"] += 1
            elif "MISMATCH" in msg:
                s["mismatched"] += 1
            elif "nothing was expected" in msg:
                s["unexpected"] += 1
        elif who == "hbus monitor" and msg.startswith("Collected"):
            if "WRITE" in msg:
                s["hbus_wr"] += 1
                s["first"].setdefault("hbus_write", e)
            else:
                s["hbus_rd"] += 1
                s["first"].setdefault("hbus_read", e)
    return s


# ------------------------------------------------------------------ timeline files
def summary_lines(summ):
    """The bullets of the summary block (timeline.md and the site pages)."""
    if summ["tx"] == 0 and summ["rx_in"]:
        sent = (f"- YAPP driver quiet in this test (verbosity UVM_NONE); the input monitor saw "
                f"**{summ['rx_in']}** packet(s).")
    else:
        sent = (f"- YAPP driver sent **{summ['tx']}** packet(s) ({summ['tx_bad']} with bad parity); "
                f"the input monitor saw {summ['rx_in']}.")
    return [sent,
            f"- Router: **{summ['in_fwd']}** forwarded, **{summ['in_drop']}** dropped"
            + (" (" + ", ".join(f"{n} {r}" for r, n in summ["drop_reasons"].items()) + ")" if summ["drop_reasons"] else "")
            + ".",
            f"- Packets out: ch0 **{summ['out'][0]}**, ch1 **{summ['out'][1]}**, ch2 **{summ['out'][2]}**.",
            f"- Scoreboard: {summ['matched']} matched, {summ['mismatched']} mismatched, {summ['unexpected']} unexpected.",
            f"- Back-pressure: in_suspend asserted **{summ['suspends']}** time(s)"
            + (f", longest hold {summ['suspend_max']} cycle(s)" if summ["suspends"] else "") + ".",
            f"- Error pulses: {summ['err_pulses']}.",
            f"- HBUS: {summ['hbus_wr']} write(s), {summ['hbus_rd']} read(s)."]


def important(e):
    """The events a capped timeline keeps: the test's stages, the DUT, the host bus, the
    reports of the checkers, and every warning or error."""
    return e["sev"] != "INFO" or e["who"] in KEEP_WHO


def write_timeline(run, events, info, summ, out_dir, has_pics, committed):
    if not committed:
        with open(os.path.join(out_dir, "timeline.csv"), "w", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["time_ns", "severity", "who", "id", "event"])
            for e in events:
                w.writerow([e["time"], e["sev"], e["who"], e["id"], e["msg"]])

    verdict = info["verdict"] or ("PASSED" if run["ok"] else "FAILED")
    wall = f" · wall {run['wall']:.1f} s" if run.get("wall") is not None else ""
    lines = [f"# {run['test']} seed {run['seed']}", "",
             f"**Result:** {verdict} ({summ['uvm_errors']} UVM_ERROR, {summ['uvm_warnings']} UVM_WARNING, "
             f"{summ['uvm_fatals']} UVM_FATAL) · bench `{run['bench']}` · sim time {run['sim_time']}{wall} · "
             f"log [`{run['log_name']}`]({run['log_name']})", ""]
    if run.get("fst"):
        lines.append(f"Waves: `{os.path.basename(run['fst'])}` (GTKWave, Surfer or the VS Code wave viewer)"
                     + ("" if committed else "; signal trace: `signals.csv`") + ".")
        if run.get("surfer"):
            lines.append(f"[Open the waves in Surfer]({run['surfer']}) (web app, the signals already in groups: "
                         f"`{os.path.relpath(surfer_layout.SUCL, ROOT)}`).")
        lines.append("")
    lines += ["## Summary", ""] + summary_lines(summ) + [""]
    if summ["stages"]:
        lines += ["## Stages", "", "| time (ns) | stage |", "|---|---|"]
        lines += [f"| {t} | {md_text(s)} |" for t, s in summ["stages"]]
        lines.append("")
    if has_pics:
        lines += ["## Pictures", ""]
        for name, title in has_pics:
            lines += [f"**{title}**", "", f"![{title}]({name})", ""]
    shown = events
    if len(events) > TIMELINE_MAX:
        shown = [e for e in events if important(e)]
        note = (f"{len(events)} events; this table keeps the {len(shown)} of the test, the DUT, the host bus, "
                f"the checkers' reports and every warning or error")
        if len(shown) > TIMELINE_MAX:
            note += f", and only the first {TIMELINE_MAX} of those"
            shown = shown[:TIMELINE_MAX]
        lines += ["## Timeline", "", note + ". The full list is in the log" + ("." if committed else " and in `timeline.csv`."), ""]
    else:
        lines += ["## Timeline", "", f"{len(events)} events" + ("." if committed else " (the same list is in `timeline.csv`)."), ""]
    lines += ["| time (ns) | who | event |", "|---|---|---|"]
    for e in shown:
        mark = {"ERROR": "❌ ", "FATAL": "💥 ", "WARNING": "⚠️ "}.get(e["sev"], "")
        who = f"**{e['who']}**" if e["who"] in ("test", "DUT") else e["who"]
        lines.append(f"| {e['time']} | {who} | {mark}{md_text(e['msg'])} |")
    with open(os.path.join(out_dir, "timeline.md"), "w") as fh:
        fh.write("\n".join(lines) + "\n")


def md_text(s):
    return s.replace("|", "\\|").replace("\n", " ")


# ------------------------------------------------------------------ wave pictures
STATE_SHORT = {"IDLE": "IDLE", "PAYLOAD": "PAYL", "PARITY": "PAR"}
PHASE_SHORT = {"HEADER": "HDR", "PAYLOAD": "PAY", "PARITY": "PAR"}


class Trace:
    """The per-cycle CSV of yapp_router_tracer, sampled on the falling edge."""

    def __init__(self, path):
        with open(path, newline="") as fh:
            rows = list(csv.DictReader(fh))
        self.rows = rows
        self.times = [int(r["time"]) for r in rows]

    def row_after(self, t):
        """Index of the first sample after the rising edge at time t."""
        return bisect.bisect_right(self.times, t)

    def bit(self, col, a, b):
        return [int(r[col]) if r[col] in ("0", "1") else "z" for r in self.rows[a:b]]

    def bus(self, col, a, b, valid=None, fmt=None):
        """Bus values, '' when not valid, '-' while unchanged (one wide box)."""
        out, prev = [], None
        for i, r in enumerate(self.rows[a:b]):
            v = r[col]
            ok = valid(r) if valid else True
            if not ok:
                out.append("")
                prev = None
                continue
            v = fmt(v) if fmt else v.upper()
            out.append("-" if v == prev else v)
            prev = v
        return out


def phase_row(tr, a, b):
    """in_phase of the tracer (HDR / PAY / PAR, blank when idle); older traces have no phase column."""
    if "phase" not in tr.rows[0]:
        return [""] * (b - a)
    return tr.bus("phase", a, b, lambda r: r["phase"] in PHASE_SHORT, fmt=lambda v: PHASE_SHORT.get(v, v))


def window(tr, t_from, t_to, before, after, cap):
    a = max(0, tr.row_after(t_from) - 1 - before)
    b = min(len(tr.rows), tr.row_after(t_to) + after)
    truncated = b - a > cap
    if truncated:
        b = a + cap
    return a, b, truncated


def pictures(run, summ, tr, out_dir):
    """Draw the pictures that apply to this run; return [(file, title), ...]."""
    pics = []
    f = summ["first"]
    hdr = f"{run['test']} s{run['seed']}: "

    def draw(name, title, signals, a, b, notes):
        notes = [(f"cycle 0 = rising edge at t = {tr.times[a] - (tr.times[a+1] - tr.times[a]) // 2 if a + 1 < len(tr.times) else tr.times[a]} ns; "
                  "TB-driven signals change on the falling edge, DUT outputs on the rising edge", 0)] + notes
        gen_waves.render(name, [("clock", "clk", None, "pos")] + signals, b - a, notes=notes,
                         out_dir=out_dir, title=hdr + title, quiet=True)
        pics.append((f"wave_{name}.svg", title))

    def in_vld(r):
        # a byte is on in_data for the header and payload (in_data_vld high) and for the
        # parity byte (in_data_vld low): in_phase of the tracer says which, older traces
        # fall back to the FSM state
        if "phase" in r:
            return r["phase"] in PHASE_SHORT
        return r["in_data_vld"] == "1" or r["state"] == "PARITY"

    # reset: the first cycles of the run
    if len(tr.rows) > 4:
        a, b = 0, min(len(tr.rows), 14)
        draw("reset", "reset and the first cycles", [
            ("reset",       "bit", tr.bit("reset", a, b), "neg"),
            ("in_data_vld", "bit", tr.bit("in_data_vld", a, b), "neg"),
            ("in_data",     "bus", tr.bus("in_data", a, b, in_vld), "neg"),
            ("in_suspend",  "bit", tr.bit("in_suspend", a, b), "pos"),
            ("router_en",   "bit", tr.bit("router_en", a, b), "pos"),
            ("maxpktsize",  "bus", tr.bus("maxpktsize", a, b), "pos"),
        ], a, b, [])

    if "in_header" in f:
        e0, e1 = f["in_header"], f.get("in_complete", f["in_header"])
        a, b, trunc = window(tr, e0["time"], e1["time"], 2, 2, 30)
        ch = int(re.search(r"addr=(\d)", e0["msg"]).group(1))
        ch = min(ch, 2)
        draw("first_packet_in", "first packet into the router", [
            ("in_data_vld",     "bit", tr.bit("in_data_vld", a, b), "neg"),
            ("in_data",         "bus", tr.bus("in_data", a, b, in_vld), "neg"),
            ("in_phase",        "bus", phase_row(tr, a, b), "neg"),
            ("in_suspend",      "bit", tr.bit("in_suspend", a, b), "pos"),
            ("fsm state",       "bus", tr.bus("state", a, b, fmt=lambda v: STATE_SHORT.get(v, v)), "pos"),
            (f"fifo_full[{ch}]", "bit", [int(r["fifo_full"][2 - ch]) for r in tr.rows[a:b]], "pos"),
            (f"data_vld_{ch}",  "bit", tr.bit(f"data_vld_{ch}", a, b), "pos"),
        ], a, b, [(e0["msg"] + ("   (… the packet goes on past the picture)" if trunc else ""), 0)])

    if "out_start" in f:
        e0, e1 = f["out_start"], f.get("out_done", f["out_start"])
        ch = int(e0["msg"][6])
        a, b, trunc = window(tr, e0["time"], e1["time"], 3, 2, 30)
        draw("first_packet_out", f"first packet out on channel {ch}", [
            (f"data_vld_{ch}", "bit", tr.bit(f"data_vld_{ch}", a, b), "pos"),
            (f"data_{ch}",     "bus", tr.bus(f"data_{ch}", a, b, lambda r: r[f"data_vld_{ch}"] == "1"), "pos"),
            (f"suspend_{ch}",  "bit", tr.bit(f"suspend_{ch}", a, b), "neg"),
            ("in_data_vld",    "bit", tr.bit("in_data_vld", a, b), "neg"),
        ], a, b, [(e0["msg"] + ("   (… the packet goes on past the picture)" if trunc else ""), 0),
                  ("a byte leaves on every rising edge where data_vld is high and suspend is low", 0)])

    if "suspend" in f:
        e = f["suspend"]
        ch = int(re.search(r"FIFO (\d)", e["msg"]).group(1))
        a, b, _ = window(tr, e["time"], e["time"], 3, 14, 22)
        draw("first_suspend", "first back-pressure on the input port", [
            ("in_data_vld",      "bit", tr.bit("in_data_vld", a, b), "neg"),
            ("in_data",          "bus", tr.bus("in_data", a, b, in_vld), "neg"),
            ("in_phase",        "bus", phase_row(tr, a, b), "neg"),
            ("in_suspend",       "bit", tr.bit("in_suspend", a, b), "pos"),
            (f"fifo_full[{ch}]", "bit", [int(r["fifo_full"][2 - ch]) for r in tr.rows[a:b]], "pos"),
            (f"data_vld_{ch}",   "bit", tr.bit(f"data_vld_{ch}", a, b), "pos"),
            (f"data_{ch}",       "bus", tr.bus(f"data_{ch}", a, b, lambda r: r[f"data_vld_{ch}"] == "1"), "pos"),
            (f"suspend_{ch}",    "bit", tr.bit(f"suspend_{ch}", a, b), "neg"),
        ], a, b, [(e["msg"], 0), ("the driver holds in_data unchanged while in_suspend is high", 0)])

    if "err_pulse" in f:
        e, eb = f["err_pulse"], f.get("err_bad")
        t0 = eb["time"] if eb else e["time"]
        a, b, _ = window(tr, t0, e["time"], 2, 3, 24)
        draw("first_error_pulse", "first error pulse after a bad-parity packet", [
            ("in_data_vld", "bit", tr.bit("in_data_vld", a, b), "neg"),
            ("in_data",     "bus", tr.bus("in_data", a, b, in_vld), "neg"),
            ("in_phase",        "bus", phase_row(tr, a, b), "neg"),
            ("fsm state",   "bus", tr.bus("state", a, b, fmt=lambda v: STATE_SHORT.get(v, v)), "pos"),
            ("error",       "bit", tr.bit("error", a, b), "pos"),
        ], a, b, [(e["msg"], 0)])

    for key, name, title in (("hbus_write", "first_hbus_write", "first HBUS write"),
                             ("hbus_read", "first_hbus_read", "first HBUS read")):
        if key in f:
            e = f[key]
            a, b, _ = window(tr, e["time"], e["time"], 3, 4, 12)
            draw(name, title, [
                ("hen",    "bit", tr.bit("hen", a, b), "neg"),
                ("hwr_rd", "bit", tr.bit("hwr_rd", a, b), "neg"),
                ("haddr",  "bus", tr.bus("haddr", a, b, lambda r: r["hen"] == "1"), "neg"),
                ("hdata",  "bus", tr.bus("hdata", a, b, lambda r: r["hen"] == "1"), "neg" if key == "hbus_write" else "pos"),
            ], a, b, [(e["msg"], 0),
                      ("write: one hen cycle, stored on its rising edge; read: haddr in cycle 1, data from the DUT in cycle 2", 0)])
    return pics


# ------------------------------------------------------------------ the runs
def regress_results():
    """(bench, test, seed) -> (ok, sim_time, note) from build/sim/regress.md, when it exists."""
    out = {}
    path = os.path.join(BUILD, "regress.md")
    if not os.path.isfile(path):
        return out
    for line in open(path):
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) == 6 and cells[2].isdigit():
            out[(cells[0], cells[1], int(cells[2]))] = (cells[3] == "pass", cells[4], cells[5])
    return out


def find_runs(only):
    import sim  # noqa: E402  (summarize(): the pass/fail rule of a log)
    results = regress_results()
    runs = []
    for log in sorted(glob.glob(os.path.join(BUILD, "*", "logs", "*_s*.log"))):
        bench_dir = os.path.dirname(os.path.dirname(log))
        bench = os.path.basename(bench_dir)
        if only and not any(o in bench or o.replace("/", "_").replace(" +define+", "__") in bench for o in only):
            continue
        m = re.match(r"(.*)_s(\d+)\.log$", os.path.basename(log))
        if not m:
            continue
        test, seed = m.group(1), int(m.group(2))
        text = open(log, errors="replace").read()
        ok, n_err, n_fat, sim_time, reason = sim.summarize(text, 0)
        # the regression's own verdict wins (it knows about `expect: errors`)
        bench_rel = bench.replace("_", "/", 1) if bench.startswith("labs_") else bench.replace("yapp_project_tb", "yapp_project/tb")
        for key, (rok, rtime, note) in results.items():
            if key[1] == test and key[2] == seed and key[0].replace("/", "_").replace(" +define+", "__") == bench:
                ok, sim_time, reason = rok, rtime, note
        fst = os.path.join(bench_dir, "waves", f"{test}_s{seed}.fst")
        trace = os.path.join(bench_dir, "trace", f"{test}_s{seed}.csv")
        runs.append({"bench": bench, "bench_rel": bench_rel, "test": test, "seed": seed, "log": log,
                     "log_name": f"{test}_s{seed}.log", "text": text, "ok": ok, "errors": n_err, "fatals": n_fat,
                     "sim_time": sim_time, "reason": reason,
                     "fst": fst if os.path.isfile(fst) else None,
                     "trace": trace if os.path.isfile(trace) else None})
    return runs


def git_commit():
    try:
        return subprocess.run(["git", "rev-parse", "--short", "HEAD"], cwd=ROOT, capture_output=True,
                              text=True, check=True).stdout.strip()
    except (OSError, subprocess.CalledProcessError):
        return ""


def build_report(only=None, out=None, make_zip=False):
    out = out or os.path.join(BUILD, "report")
    runs = find_runs(only)
    if not runs:
        sys.exit("sim_report.py: no logs under build/sim/*/logs -- run `make regress` first")
    if os.path.isdir(out):
        shutil.rmtree(out)
    os.makedirs(out)
    # A report written into the repository is committed: its .fst files are on GitHub, so each run gets
    # a link that opens them in Surfer's web app with the signal layout of scripts/surfer_layout.py;
    # the files that only repeat the log or the waves are left out, and the site gets the pictures.
    committed = not os.path.abspath(out).startswith(os.path.join(ROOT, "build") + os.sep)
    docs_rel = os.path.relpath(os.path.join(ROOT, "docs"), out)
    layout_checked = False
    all_logs, rows, records, failures = [], [], [], []
    one_bench = len({r["bench"] for r in runs}) == 1
    if committed and os.path.isdir(SITE_PICS):
        shutil.rmtree(SITE_PICS)
    for r in runs:
        run_dir = os.path.join(out, r["bench"], f"{r['test']}_s{r['seed']}")
        os.makedirs(run_dir)
        shutil.copy(r["log"], os.path.join(run_dir, r["log_name"]))
        events, info = parse_log(r["text"])
        summ = summarize(events)
        r["wall"], r["verilator"] = info["wall"], info["verilator"]
        pics = []
        if r["fst"]:
            fst_copy = os.path.join(run_dir, os.path.basename(r["fst"]))
            shutil.copy(r["fst"], fst_copy)
            if committed:
                r["surfer"] = surfer_layout.surfer_url(os.path.relpath(fst_copy, ROOT))
                if not layout_checked:
                    layout_checked = True
                    missing = surfer_layout.missing_signals(fst_copy)
                    if missing:
                        sys.exit(f"sim_report.py: the Surfer layout names signals the waves do not have: "
                                 f"{', '.join(missing)} -- fix LAYOUT in scripts/surfer_layout.py")
        if r["trace"]:
            if not committed:
                shutil.copy(r["trace"], os.path.join(run_dir, "signals.csv"))
            try:
                pics = pictures(r, summ, Trace(r["trace"]), run_dir)
            except Exception as exc:  # a picture must never break the report
                print(f"    (no pictures for {r['test']} s{r['seed']}: {exc})")
        write_timeline(r, events, info, summ, run_dir, pics, committed)
        rel = os.path.relpath(run_dir, out)
        if committed and pics and r["seed"] == min(x["seed"] for x in runs if x["test"] == r["test"] and x["bench"] == r["bench"]):
            site_dir = os.path.join(SITE_PICS, r["test"])
            os.makedirs(site_dir, exist_ok=True)
            for name, _title in pics:
                shutil.copy(os.path.join(run_dir, name), os.path.join(site_dir, name))
        first_error = next((e for e in events if e["sev"] in ("ERROR", "FATAL")), None)
        if not r["ok"]:
            failures.append((r, first_error["msg"] if first_error else (r["reason"] or "see the log")))
        counts = {k: summ[k] for k in ("tx", "tx_bad", "rx_in", "in_fwd", "in_drop", "drop_reasons", "out", "matched",
                                       "mismatched", "unexpected", "suspends", "suspend_max", "err_pulses", "hbus_wr",
                                       "hbus_rd", "uvm_errors", "uvm_warnings", "uvm_fatals")}
        records.append({"bench": r["bench"], "bench_rel": r["bench_rel"], "test": r["test"], "seed": r["seed"],
                        "ok": r["ok"], "verdict": info["verdict"] or ("PASSED" if r["ok"] else "FAILED"),
                        "reason": r["reason"], "sim_time": r["sim_time"], "wall": r["wall"], "events": len(events),
                        "counts": counts, "summary": summary_lines(summ), "stages": summ["stages"],
                        "pictures": pics, "first_error": first_error["msg"] if first_error else None,
                        "dir": rel, "log": f"{rel}/{r['log_name']}", "fst": f"{rel}/{os.path.basename(r['fst'])}" if r["fst"] else None,
                        "surfer": r.get("surfer")})
        wall_txt = f"{r['wall']:.1f} s" if r["wall"] is not None else "-"
        rows.append(("" if one_bench else f"| {r['bench_rel']} ")
                    + f"| {r['test']} | {r['seed']} | {'pass' if r['ok'] else '**FAIL**'} "
                    f"| {r['sim_time']} | {wall_txt} "
                    f"| {summ['rx_in']} / {summ['in_fwd']} / {summ['in_drop']} "
                    f"| {summ['out'][0]}/{summ['out'][1]}/{summ['out'][2]} | {summ['suspends']} "
                    f"| {summ['uvm_errors']} | {md_text(r['reason']) if r['reason'] else ''} | [{rel}]({rel}/timeline.md) "
                    f"| {'[Surfer](' + r['surfer'] + ')' if r.get('surfer') else '-'} |")
        if not committed:
            all_logs.append("#" * 78 + f"\n# {r['bench_rel']}  {r['test']}  seed {r['seed']}  "
                            f"({'PASS' if r['ok'] else 'FAIL'}{', ' + r['reason'] if r['reason'] else ''})\n"
                            + "#" * 78 + "\n" + r["text"] + "\n")
        print(f"    {'PASS' if r['ok'] else 'FAIL'}  {r['test']:<26} seed {r['seed']}  {len(events):>5} events"
              f"  {len(pics)} picture(s)")
    cov = write_coverage(runs, out, committed)
    meta = {"date": time.strftime("%Y-%m-%d"), "commit": git_commit(),
            "verilator": next((r["verilator"] for r in runs if r.get("verilator")), None),
            "total": len(runs), "passed": sum(1 for r in runs if r["ok"]),
            "wall": sum(r["wall"] for r in runs if r.get("wall") is not None)}
    passed = f"**{meta['passed']} of {meta['total']} runs passed**"
    index = ["# Regression report", "",
             f"{passed} · {meta['date']}" + (f" · commit `{meta['commit']}`" if meta["commit"] else "")
             + (f" · Verilator {meta['verilator']}" if meta["verilator"] else "")
             + f" · {meta['wall'] / 60:.1f} min of simulation wall time.", ""]
    if cov:
        index += ["Functional coverage merged over every run: [coverage.md](coverage.md) ("
                  + "; ".join(f"{d['bench']} {d['covered']} / {d['total']} bins" for d in cov) + ").", ""]
    if failures:
        index += ["## Failures", "", "| Test | Seed | First error |", "|---|---|---|"]
        index += [f"| {r['test']} | {r['seed']} | {md_text(msg)} |" for r, msg in failures] + [""]
    index += ["## Runs", "",
              "One folder per run: the log, `timeline.md` (summary, stages, the timeline), the waves and the "
              "wave pictures" + ("" if committed else "; `timeline.csv` and `signals.csv` hold the events and the "
                                 "per-cycle signals as data, `all_logs.log` every log in one file") + ". "
              "`runs.json` holds the table below as data.", "",
              "Generated by `scripts/sim_report.py` from `build/sim/*/logs` (Verilator): regenerate with "
              "`make regress ONLY=yapp_project WAVES=1 && make sim-report ONLY=yapp_project "
              f"OUT={os.path.relpath(out, ROOT)}`. How to read it: [{docs_rel}/appendix/sim-report.md]"
              f"({docs_rel}/appendix/sim-report.md).", "",
              ("" if one_bench else "| Bench ") + "| Test | Seed | Result | Sim time | Wall | In / fwd / drop | Out ch0/1/2 "
              "| Suspends | Errors | Note | Folder | Waves |",
              ("" if one_bench else "|---") + "|---|---|---|---|---|---|---|---|---|---|---|---|"] + rows
    with open(os.path.join(out, "index.md"), "w") as fh:
        fh.write("\n".join(index) + "\n")
    with open(os.path.join(out, "runs.json"), "w") as fh:
        json.dump({**meta, "committed": committed, "runs": records}, fh, indent=1)
        fh.write("\n")
    if not committed:
        with open(os.path.join(out, "all_logs.log"), "w") as fh:
            fh.write("\n".join(all_logs))
    print(f"report: {os.path.relpath(out, ROOT)}/index.md  ({len(runs)} runs, {meta['passed']} passed)")
    if make_zip:
        os.makedirs(BUILD, exist_ok=True)
        zpath = os.path.join(BUILD, "regression_report.zip")
        with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED) as z:
            for d, _dirs, files in os.walk(out):
                for f in files:
                    p = os.path.join(d, f)
                    z.write(p, os.path.join("regression_report", os.path.relpath(p, out)))
        print(f"zip: {os.path.relpath(zpath, ROOT)}  ({os.path.getsize(zpath) / 1e6:.1f} MB)")
    return all(r["ok"] for r in runs)


def write_coverage(runs, out, committed):
    """coverage.md / coverage.json / <bench>/merged.* / the HTML, for the benches of the report."""
    benches = {}
    for r in runs:
        benches.setdefault(r["bench"], set()).add((r["test"], r["seed"]))
    html_root = os.path.join(ROOT, "docs", "coverage") if committed else os.path.join(out, "coverage_html")
    src_prefix = os.path.relpath(ROOT, out) + "/"
    all_data, sections = [], []
    for bench, keep in sorted(benches.items()):
        data = coverage_report.collect(os.path.join(BUILD, bench), keep)
        if not data:
            continue
        all_data.append(data)
        info = coverage_report.write_merged(os.path.join(BUILD, bench), keep, os.path.join(out, bench))
        html = None
        if info and coverage_report.write_html(info, os.path.join(html_root, bench),
                                               f"YAPP functional coverage ({bench}, {data['runs']} runs)"):
            html = os.path.relpath(os.path.join(html_root, bench, "index.html"), out)
        sections.append(coverage_report.markdown(data, html, src_prefix=src_prefix))
        print(f"    coverage {bench}: {data['covered']} / {data['total']} bins over {data['runs']} runs"
              + (f", HTML in {os.path.relpath(os.path.join(html_root, bench), ROOT)}" if html else ""))
    if not all_data:
        return []
    with open(os.path.join(out, "coverage.md"), "w") as fh:
        docs_rel = os.path.relpath(os.path.join(ROOT, "docs"), out)
        fh.write("# Functional coverage\n\nThe covergroups of every run, merged (`scripts/coverage_report.py`). "
                 f"How to read it: [{docs_rel}/components/coverage.md]({docs_rel}/components/coverage.md).\n\n"
                 + "\n".join(sections))
    with open(os.path.join(out, "coverage.json"), "w") as fh:
        json.dump(all_data, fh, indent=1)
        fh.write("\n")
    return all_data


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--only", action="append", help="benches whose build directory contains this (repeatable)")
    ap.add_argument("--out", help="report directory (default build/sim/report)")
    ap.add_argument("--zip", action="store_true", help="also write build/sim/regression_report.zip")
    ns = ap.parse_args()
    sys.exit(0 if build_report(ns.only, ns.out, ns.zip) else 1)


if __name__ == "__main__":
    main()
