#!/usr/bin/env python3
"""Generate the starting point of every lab for a student: labs/<lab>/start/.

    python3 scripts/make_start.py              (make start; `make start-check` compares)
    python3 scripts/make_start.py --check      exit 1 when a committed start/ differs

A start/ is the lab directory (sv/, tb/, run.f, Makefile) with the files the lab
adds or changes replaced by a *stub*: the class with its prototypes stays (the
table of contents the course style gives every class), the bodies of the methods
and constraints are emptied to a `// TODO (Lab N)` comment, `new()` and the
`super.<phase>()` calls stay so that everything still compiles, and the comments
of the body stay as hints. Files the lab inherits unchanged from the previous
lab are copied as they are; modules, interfaces, packages and command files are
copied too (they are not where the lab's work is) and listed in TASKS.md as
"compare with the finished one". TASKS.md, written next to the stubs, lists the
steps of the lab page on the site and how to run and check the result.

Which files a lab changes is decided by diffing it against the lab it builds on
(PREV below), not from the docs, so the stubs never drift from the code.
"""

import argparse
import difflib
import filecmp
import os
import re
import shutil
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LABS = os.path.join(ROOT, "labs")
DOCS = os.path.join(ROOT, "docs", "labs")

# lab -> (the lab it builds on, the page on the site, the lab number as printed)
PREV = {
    "lab01_data":      (None,              "lab01",  "1"),
    "lab02_test":      ("lab01_data",      "lab02",  "2"),
    "lab03_uvc":       ("lab02_test",      "lab03",  "3"),
    "lab04_factory":   ("lab03_uvc",       "lab04",  "4"),
    "lab05_seq":       ("lab04_factory",   "lab05",  "5"),
    "lab06_vif":       ("lab05_seq",       "lab06",  "6"),
    "lab07_integ":     ("lab06_vif",       "lab07",  "7"),
    "lab08_mcseq":     ("lab07_integ",     "lab08",  "8"),
    "lab09_sba":       ("lab08_mcseq",     "lab09a", "9A"),
    "lab09_sbb":       ("lab09_sba",       "lab09b", "9B"),
    "lab09_sbc":       ("lab09_sbb",       "lab09c", "9C"),
    "lab09_sbd":       ("lab09_sbb",       "lab09d", "9D"),
    "lab10_cov":       ("lab09_sbc",       "lab10",  "10"),
    "lab11b_rm_integ": ("lab10_cov",       "lab11b", "11B"),
    "lab11c_rm_sim":   ("lab11b_rm_integ", "lab11c", "11C"),
}
# Lab 11A generates the register model from XML with a tool: no start point.

# Work of a lab that lives in the shared UVC (yapp_project/uvc/yapp): the stub goes to
# start/sv/ and `-incdir ../sv` is put first in run.f, so the stub shadows the finished file.
EXTRA = {
    "lab10_cov": [("yapp_project/uvc/yapp/yapp_pkt_coverage.sv", "sv/yapp_pkt_coverage.sv"),
                  ("yapp_project/uvc/yapp/seqs/yapp_coverage_seq.sv", "sv/seqs/yapp_coverage_seq.sv")],
}
# Files kept as they are even when they changed: generated or copied, not written in the lab.
KEEP = {
    "lab11b_rm_integ": ["tb/yapp_router_reg_pkg.sv", "tb/reg/"],
    "lab11c_rm_sim":   ["tb/yapp_router_reg_pkg.sv", "tb/reg/"],
}
SKIP_NAMES = {"tr_db.log", "xrun.log", "xrun.history", "xcelium.d", "INCA_libs", "cov_work", ".simvision", "start"}

IMPL_RE = re.compile(r"^(function|task)\b.*?\b(\w+)::(\w+)\s*\(")
CONSTRAINT_RE = re.compile(r"^constraint\s+(\w+)::(\w+)\s*\{")


def bodies_of(text):
    """{(class, name): body lines} of every method and constraint implementation in a file."""
    out = {}
    if text is None:
        return out
    lines = text.split("\n")
    i, n = 0, len(lines)
    while i < n:
        m = IMPL_RE.match(lines[i])
        if m:
            kind, cls, name = m.groups()
            j = i
            while j < n and not lines[j].rstrip().endswith(");"):
                j += 1
            k = j + 1
            while k < n and not re.match(rf"^end{kind}\b", lines[k]):
                k += 1
            out[(cls, name)] = lines[j + 1:k]
            i = k + 1
            continue
        m = CONSTRAINT_RE.match(lines[i])
        if m:
            k = i + 1
            while k < n and not re.match(r"^\}", lines[k]):
                k += 1
            out[m.groups()] = lines[i + 1:k]
            i = k + 1
            continue
        i += 1
    return out


def code_only(text):
    """The file without comments and blank lines: two files that differ only there are the same lab work."""
    return re.sub(r"\s+", " ", re.sub(r"//.*", "", text)).strip()


def stub_sv(text, lab_no, prev_text=None):
    """The file with the method / constraint bodies that are new or changed since the previous lab
    emptied (all of them when there is no previous lab); None when the file holds no class or
    nothing in it changed."""
    if not re.search(r"^\s*class\s+\w+", text, re.M):
        return None
    if prev_text is not None and code_only(prev_text) == code_only(text):
        return None
    prev = bodies_of(prev_text)
    n_stubbed = 0
    lines = text.split("\n")
    out, i, n = [], 0, len(lines)
    while i < n:
        line = lines[i]
        m = IMPL_RE.match(line)
        if m:
            kind, cls, name = m.groups()
            # the header may span several lines: it ends with `);`
            j = i
            while j < n and not lines[j].rstrip().endswith(");"):
                j += 1
            header = lines[i:j + 1]
            k = j + 1
            while k < n and not re.match(rf"^end{kind}\b", lines[k]):
                k += 1
            body = lines[j + 1:k]
            footer = lines[k] if k < n else f"end{kind}"
            out += header
            if name == "new" or prev.get((cls, name)) == body:
                out += body
            else:
                n_stubbed += 1
                hints = [b for b in body if re.match(r"^\s*//", b)]
                supers = [b for b in body if re.match(r"^\s*super\.\w+\s*\(", b)]
                out += supers
                out += hints
                out.append(f"  // TODO (Lab {lab_no}): write {cls}::{name}")
            out.append(footer)
            i = k + 1
            continue
        m = CONSTRAINT_RE.match(line)
        if m:
            cls, name = m.groups()
            k = i + 1
            while k < n and not re.match(r"^\}", lines[k]):
                k += 1
            out.append(line)
            if prev.get((cls, name)) == lines[i + 1:k]:
                out += lines[i + 1:k]
            else:
                n_stubbed += 1
                out.append(f"  // TODO (Lab {lab_no}): the constraint {cls}::{name}")
            out.append(lines[k] if k < n else "}")
            i = k + 1
            continue
        out.append(line)
        i += 1
    return "\n".join(out) if n_stubbed else None


def rel_files(d):
    """Every file under d, relative, without simulator leftovers."""
    out = []
    for base, dirs, files in os.walk(d):
        dirs[:] = [x for x in dirs if x not in SKIP_NAMES]
        for f in files:
            if f in SKIP_NAMES or f.endswith(".log"):
                continue
            out.append(os.path.relpath(os.path.join(base, f), d))
    return sorted(out)


def fix_paths(text, add_sv_incdir=False):
    """run.f / Makefile of start/tb: one directory deeper than tb/."""
    text = re.sub(r"(?<![\w./])\.\./\.\./\.\./(?!\.\./)", "../../../../", text)
    if add_sv_incdir:
        text = text.replace("-incdir ../../../../common\n", "-incdir ../sv                    // the stubs of this lab shadow the finished files\n-incdir ../../../../common\n", 1)
    return text


def lab_page_steps(page):
    """The `### N. ...` headings of the Solution section and the Run section of docs/labs/<page>.md."""
    md = open(os.path.join(DOCS, page + ".md"), encoding="utf-8").read()
    title = re.search(r"^# (.*)$", md, re.M).group(1)
    sol = re.search(r"^## Solution\n(.*?)^## ", md, re.M | re.S)
    steps = [re.sub(r"^\d+\.\s*", "", s) for s in re.findall(r"^### (.*)$", sol.group(1), re.M)] if sol else []
    run = re.search(r"^## Run\n(.*?)^## ", md, re.M | re.S)
    run_txt = run.group(1).strip() if run else ""
    run_txt = re.sub(r"^\*\*Expected:\*\*", "**Expected:**", run_txt, flags=re.M)
    return title, steps, run_txt


def tasks_md(lab, lab_no, page, stubbed, kept_changed, unchanged, extra):
    title, steps, run_txt = lab_page_steps(page)
    url = f"https://tamirgabgab.github.io/Qcom-Mentoring/labs/{page}/"
    L = [f"# {title} — start point", "",
         f"This directory is where you work on Lab {lab_no}. It is the finished state of the lab before it "
         f"(`labs/{PREV[lab][0]}`) plus the files this lab adds or changes with their method bodies emptied: "
         "every class keeps its prototypes, you write the bodies. The finished solution is one directory up "
         f"(`labs/{lab}/sv`, `labs/{lab}/tb`); the lab page explains every step: {url}" if PREV[lab][0] else
         f"This directory is where you work on Lab {lab_no}: the classes keep their prototypes, you write the bodies. "
         f"The finished solution is one directory up (`labs/{lab}/sv`, `labs/{lab}/tb`); the lab page explains every step: {url}",
         ""]
    if steps:
        L += ["## Steps (from the lab page)", ""] + [f"{i + 1}. {s}" for i, s in enumerate(steps)] + [""]
    L += ["## Files", ""]
    if stubbed:
        L += ["**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; "
              "the comments of the finished bodies are left as hints, the rest of the file is given):", ""]
        L += [f"* `{f}`" + (f" — shadows `{src}` through `-incdir ../sv`" if f in extra else "") for f, src in stubbed] + [""]
    if kept_changed:
        L += ["**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are "
              "not where the lab's work is; compare them with the previous lab to see what changed):", ""]
        L += [f"* `{f}`" for f in kept_changed] + [""]
    if unchanged:
        L += [f"**Unchanged since the previous lab**: {', '.join('`' + f + '`' for f in unchanged)}", ""]
    L += ["## Run and check", "", "```bash",
          f"cd labs/{lab}/start/tb",
          "make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end",
          "make run TEST=<test>            # Xcelium",
          f"make check LAB={lab} START=1    # from the repository root: every test of the lab against what the log must show",
          "```", ""]
    if run_txt:
        L += ["What the lab page says about running it:", "", run_txt, ""]
    return "\n".join(L)


def build_start(lab, verbose=True):
    prev, page, lab_no = PREV[lab]
    src = os.path.join(LABS, lab)
    dst = os.path.join(src, "start")
    tmp = dst + ".new"
    if os.path.isdir(tmp):
        shutil.rmtree(tmp)
    files = rel_files(src)
    prev_dir = os.path.join(LABS, prev) if prev else None
    keep = KEEP.get(lab, [])
    stubbed, kept_changed, unchanged = [], [], []
    extra_targets = {t for _, t in EXTRA.get(lab, [])}
    for f in files:
        s = os.path.join(src, f)
        same = prev_dir and os.path.isfile(os.path.join(prev_dir, f)) and filecmp.cmp(s, os.path.join(prev_dir, f), shallow=False)
        d = os.path.join(tmp, f)
        os.makedirs(os.path.dirname(d), exist_ok=True)
        text = open(s, encoding="utf-8").read()
        if os.path.basename(f) == "run.f":
            open(d, "w", encoding="utf-8").write(fix_paths(text, add_sv_incdir=bool(extra_targets)))
            (unchanged if same else kept_changed).append(f)
            continue
        if os.path.basename(f) == "Makefile":
            open(d, "w", encoding="utf-8").write(fix_paths(text))
            unchanged.append(f)
            continue
        if same or any(f.startswith(k) for k in keep):
            shutil.copy2(s, d)
            (unchanged if same else kept_changed).append(f)
            continue
        prev_text = None
        if prev_dir and os.path.isfile(os.path.join(prev_dir, f)):
            prev_text = open(os.path.join(prev_dir, f), encoding="utf-8").read()
        stub = stub_sv(text, lab_no, prev_text) if f.endswith(".sv") else None
        if stub is None:
            shutil.copy2(s, d)
            # a class file whose code did not change (comments only) counts as unchanged
            (unchanged if f.endswith(".sv") and prev_text is not None and code_only(prev_text) == code_only(text)
             else kept_changed).append(f)
        else:
            head = (f"// START POINT of Lab {lab_no}: the bodies of the methods and constraints below are yours to write.\n"
                    f"// The finished file is labs/{lab}/{f}; the lab page explains every step.\n")
            open(d, "w", encoding="utf-8").write(head + stub)
            stubbed.append((f, None))
    for src_rel, tgt in EXTRA.get(lab, []):
        text = open(os.path.join(ROOT, src_rel), encoding="utf-8").read()
        d = os.path.join(tmp, tgt)
        os.makedirs(os.path.dirname(d), exist_ok=True)
        head = (f"// START POINT of Lab {lab_no}: the bodies below are yours to write. This file shadows\n"
                f"// {src_rel} (run.f puts -incdir ../sv first); the finished one is there.\n")
        open(d, "w", encoding="utf-8").write(head + stub_sv(text, lab_no))
        stubbed.append((tgt, src_rel))
    open(os.path.join(tmp, "TASKS.md"), "w", encoding="utf-8").write(
        tasks_md(lab, lab_no, page, stubbed, kept_changed, unchanged, extra_targets))
    changed = not os.path.isdir(dst) or any(
        not os.path.isfile(os.path.join(dst, f)) or not filecmp.cmp(os.path.join(tmp, f), os.path.join(dst, f), shallow=False)
        for f in rel_files(tmp)) or rel_files(dst) != rel_files(tmp)
    if verbose:
        print(f"{lab}: {len(stubbed)} stubbed, {len(kept_changed)} changed but given, {len(unchanged)} unchanged"
              + ("" if changed else " (up to date)"))
    return tmp, dst, changed


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--check", action="store_true", help="compare with the committed start/ directories, change nothing")
    ap.add_argument("labs", nargs="*", help="labs to generate (default: all)")
    ns = ap.parse_args()
    stale = []
    for lab in ns.labs or PREV:
        tmp, dst, changed = build_start(lab)
        if ns.check:
            if changed:
                stale.append(lab)
            shutil.rmtree(tmp)
        else:
            if os.path.isdir(dst):
                shutil.rmtree(dst)
            os.rename(tmp, dst)
    if ns.check:
        if stale:
            print("STALE start/: " + ", ".join(stale) + " -- run `make start` and commit labs/*/start")
            return 1
        print("start/ directories: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
