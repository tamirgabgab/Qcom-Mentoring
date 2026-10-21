#!/usr/bin/env python3
"""The "See it run" section of every lab page: the lines that matter from the real logs.

    python3 scripts/see_it_run.py          (make see-it-run; after `make regress`)

Reads build/sim/labs_<lab>_tb/logs/<test>_s1.log for every test of the lab in
scripts/regress.yaml and writes docs/assets/generated/see_it_run/<page>.md, one tab per
test, which the lab page includes with a snippet. Kept are the lines a reader looks for
(sequences starting, packets collected, HBUS accesses, the reports, the verdict); long runs
of the same kind of line are folded into "... (N more)". The files are committed, so the
site never shows a log that was not produced by the code it documents.
"""

import os
import re
import sys

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
from make_start import PREV  # noqa: E402  lab -> (prev, page, number)

OUT = os.path.join(ROOT, "docs", "assets", "generated", "see_it_run")
KEEP = re.compile(r"\[TEST\]|Executing |report:|report ---|matched|mismatched|collected packet:|Packet collected:"
                  r"|Collected (WRITE|READ)|MAXPKTSIZE|MISMATCH|Miscompare|compare ->|UVM_(ERROR|WARNING|FATAL) :"
                  r"|PASSED|FAILED|INSTALL|is now |Running test|UVM_ERROR |UVM_FATAL |coverage \d"
                  r"|Packet is|^\s+(addr|length|parity_type)\s+\S+\s+\d+\s+")
MAX_LINES = 30
MAX_WIDTH = 150


def shape(line):
    """What kind of line this is, for folding repeats (digits and hex removed)."""
    return re.sub(r"0x[0-9a-f]+|\d+", "#", line.split("] ", 1)[-1])[:60]


def excerpt(path):
    lines = []
    for raw in open(path, errors="replace"):
        raw = raw.rstrip("\n")
        if not KEEP.search(raw):
            continue
        # "UVM_INFO /long/path/file.sv(12) @ 340: uvm_test_top.tb..." -> "@340 uvm_test_top.tb..."
        m = re.match(r"^UVM_(INFO|WARNING|ERROR|FATAL) (?:\S+ )?@ (\d+): (.*)$", raw)
        if m:
            sev, t, rest = m.groups()
            raw = f"@{t} {rest}" if sev == "INFO" else f"{sev} @{t} {rest}"
        raw = raw.replace(ROOT + "/", "")
        if len(raw) > MAX_WIDTH:
            raw = raw[:MAX_WIDTH - 1] + "…"
        lines.append(raw)
    # keep the first two lines of every kind; say how many were left out
    out, seen, dropped = [], {}, 0
    for ln in lines:
        s = shape(ln)
        seen[s] = seen.get(s, 0) + 1
        if seen[s] <= 2:
            out.append(ln)
        else:
            dropped += 1
    if dropped:
        out.append(f"... ({dropped} more lines of the kinds above)")
    if len(out) > MAX_LINES:
        out = out[:MAX_LINES - 6] + [f"... ({len(out) - MAX_LINES + 6} lines left out)"] + out[-5:]
    return out


def main():
    cfg = yaml.safe_load(open(os.path.join(ROOT, "scripts", "regress.yaml")))
    os.makedirs(OUT, exist_ok=True)
    written = 0
    for lab, (_, page, _) in PREV.items():
        bench = f"labs/{lab}/tb"
        entries = cfg["benches"].get(bench, [])
        entries = entries["tests"] if isinstance(entries, dict) else entries
        tabs = []
        for e in entries:
            test = e["test"] if isinstance(e, dict) else e
            log = os.path.join(ROOT, "build", "sim", f"labs_{lab}_tb", "logs", f"{test}_s1.log")
            if not os.path.isfile(log):
                continue
            body = excerpt(log)
            if not body:
                continue
            tabs.append(f'=== "{test}"\n\n    ```text\n' + "".join(f"    {ln}\n" for ln in body) + "    ```\n")
        if not tabs:
            continue
        with open(os.path.join(OUT, page + ".md"), "w", encoding="utf-8") as fh:
            fh.write("\n".join(tabs))
        written += 1
    print(f"see_it_run: {written} lab(s) written to {os.path.relpath(OUT, ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
