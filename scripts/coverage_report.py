#!/usr/bin/env python3
"""
coverage_report.py -- the functional coverage of a regression, merged over every
run: which bins were hit, how often, by which tests, and which never were.

Every Verilator run writes the bins of its covergroups to
build/sim/<bench>/coverage/<test>_s<seed>.dat (sim.py compiles with
--coverage-user and passes +verilator+coverage+file+...). This module reads
those files; sim_report.py calls it and writes

    <report>/coverage.md      per covergroup: covered / total, the holes, every
                              bin with its hits, runs and tests; what each test adds
    <report>/coverage.json    the same data (scripts/project_map/build.py reads
                              the committed one for the site page and the map)
    <report>/merged.dat       verilator_coverage --write of all the runs
    <report>/merged.info      the same in lcov format
    <html dir>/index.html     genhtml of merged.info: the covergroup sources with
                              a count on every bin line (needs lcov)

A percentage is covered bins / bins of the covergroup, as Verilator's
get_inst_coverage() computes it, so it matches the log of a single run.

    python3 scripts/coverage_report.py [--only PATTERN]     # print the summary
"""
import argparse
import glob
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD = os.path.join(ROOT, "build", "sim")

# C '<\x01key\x02value...>' <count>
REC_RE = re.compile(r"^C '(.*)' (\d+)\s*$")


def repo_path(path):
    """A source path of a .dat, relative to the repository (they are absolute, with tb/../)."""
    p = os.path.normpath(path)
    return os.path.relpath(p, ROOT) if p.startswith(ROOT + os.sep) else p


def parse_dat(path):
    """The covergroup bins of one coverage file: [{cg, point, bin, cross, file, line, count}]."""
    bins = []
    for line in open(path, errors="replace"):
        m = REC_RE.match(line)
        if not m:
            continue
        fields = dict(kv.split("\x02", 1) for kv in m.group(1).split("\x01") if "\x02" in kv)
        if fields.get("t") != "covergroup":
            continue
        # h = __vlAnonCG_<covergroup>.<coverpoint or cross>.<bin>
        cg, point, name = fields["h"].split(".", 2)
        bins.append({"cg": cg.replace("__vlAnonCG_", "", 1), "point": point, "bin": name,
                     "cross": fields.get("cross") == "1", "file": repo_path(fields.get("f", "")),
                     "line": int(fields.get("l", 0)), "count": int(m.group(2))})
    return bins


def collect(bench_dir, runs=None):
    """Merge the .dat files of one bench. runs: [(test, seed)] to keep (default: every file).
    Returns the data written to coverage.json, or None when there is no coverage file."""
    cov_dir = os.path.join(bench_dir, "coverage")
    files = []
    for f in sorted(glob.glob(os.path.join(cov_dir, "*_s*.dat"))):
        m = re.match(r"(.*)_s(\d+)\.dat$", os.path.basename(f))
        if m and (runs is None or (m.group(1), int(m.group(2))) in runs):
            files.append((m.group(1), int(m.group(2)), f))
    if not files:
        return None
    merged = {}                                   # (cg, point, bin) -> bin record
    order = []
    for test, seed, f in files:
        for b in parse_dat(f):
            key = (b["cg"], b["point"], b["bin"])
            if key not in merged:
                merged[key] = {"name": b["bin"], "line": b["line"], "file": b["file"], "cross": b["cross"],
                               "hits": 0, "runs": 0, "tests": {}}
                order.append(key)
            rec = merged[key]
            rec["hits"] += b["count"]
            if b["count"]:
                rec["runs"] += 1
                rec["tests"][test] = rec["tests"].get(test, 0) + b["count"]
    groups = {}
    for key in order:
        cg, point, _ = key
        rec = merged[key]
        g = groups.setdefault(cg, {"name": cg, "file": rec["file"], "points": {}})
        p = g["points"].setdefault(point, {"name": point, "cross": rec["cross"], "line": rec["line"], "bins": []})
        p["line"] = min(p["line"], rec["line"])
        p["bins"].append({"name": rec["name"], "line": rec["line"], "hits": rec["hits"], "runs": rec["runs"],
                          "tests": sorted(rec["tests"], key=lambda t: -rec["tests"][t])})
    out_groups = []
    for g in groups.values():
        points = sorted(g["points"].values(), key=lambda p: p["line"])
        for p in points:
            p["total"] = len(p["bins"])
            p["covered"] = sum(1 for b in p["bins"] if b["hits"])
        total = sum(p["total"] for p in points)
        covered = sum(p["covered"] for p in points)
        out_groups.append({"name": g["name"], "file": g["file"], "points": points, "total": total,
                           "covered": covered, "pct": round(100.0 * covered / total, 1) if total else 0.0})
    out_groups.sort(key=lambda g: (g["file"], g["name"]))
    # what each test adds: bins it hits, and bins no other test hits
    hit_by = {}
    for key in order:
        hit_by[key] = set(merged[key]["tests"])
    tests = {}
    for test, seed, _f in files:
        tests.setdefault(test, {"test": test, "runs": 0})["runs"] += 1
    for t in tests.values():
        t["bins_hit"] = sum(1 for k in order if t["test"] in hit_by[k])
        t["only_this"] = sorted(f"{k[0]}.{k[1]}.{k[2]}" for k in order if hit_by[k] == {t["test"]})
    return {"bench": os.path.relpath(bench_dir, BUILD), "runs": len(files), "covergroups": out_groups,
            "tests": sorted(tests.values(), key=lambda t: t["test"]),
            "total": sum(g["total"] for g in out_groups), "covered": sum(g["covered"] for g in out_groups)}


def holes(data):
    """[(covergroup, point, bin, line, file)] of every bin no run hit."""
    return [(g["name"], p["name"], b["name"], b["line"], g["file"])
            for g in data["covergroups"] for p in g["points"] for b in p["bins"] if not b["hits"]]


def tests_text(names, limit=4):
    return ", ".join(names[:limit]) + (f" +{len(names) - limit}" if len(names) > limit else "")


def markdown(data, html_link=None, title=True, depth=2, src_prefix=""):
    """coverage.md (or a section of it). src_prefix makes the source links work from where it lands."""
    h = "#" * depth
    lines = []
    if title:
        lines += [f"{h} Functional coverage: {data['bench']}", ""]
    lines += [f"Merged over **{data['runs']} runs**: {data['covered']} of {data['total']} bins hit. "
              "A percentage is covered bins / bins of the covergroup, as `get_inst_coverage()` gives it "
              "in the log of one run.", ""]
    if html_link:
        lines += [f"Annotated sources (genhtml): [{html_link}]({html_link})", ""]
    lines += ["| Covergroup | Where | Bins hit | Coverage |", "|---|---|---|---|"]
    for g in data["covergroups"]:
        lines.append(f"| `{g['name']}` | [{os.path.basename(g['file'])}]({src_prefix}{g['file']}) "
                     f"| {g['covered']} / {g['total']} | **{g['pct']:.1f}%** |")
    hs = holes(data)
    lines += ["", f"{h}# Holes", ""]
    if hs:
        lines += ["Bins no run hit: the candidates for a new test, a new sequence knob or an exclusion.", "",
                  "| Covergroup | Coverpoint / cross | Bin | Line |", "|---|---|---|---|"]
        for cg, point, b, line, f in hs:
            lines.append(f"| `{cg}` | `{point}` | **{b}** | [{line}]({src_prefix}{f}#L{line}) |")
    else:
        lines += ["None: every bin was hit at least once."]
    for g in data["covergroups"]:
        lines += ["", f"{h}# `{g['name']}`: {g['pct']:.1f}% ({g['covered']} / {g['total']} bins)", "",
                  f"Source: [{g['file']}]({src_prefix}{g['file']})", "",
                  "| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |",
                  "|---|---|---|---|---|"]
        for p in g["points"]:
            kind = "cross " if p["cross"] else ""
            for i, b in enumerate(p["bins"]):
                label = f"{kind}`{p['name']}` ({p['covered']}/{p['total']})" if i == 0 else ""
                name = f"**{b['name']}**" if not b["hits"] else b["name"]
                lines.append(f"| {label} | {name} | {b['hits'] if b['hits'] else '**HOLE**'} | {b['runs']} "
                             f"| {tests_text(b['tests'])} |")
    lines += ["", f"{h}# What each test adds", "",
              "Bins hit over all the seeds of a test, and the bins no other test hits (a test with none "
              "adds nothing to the coverage; it may still check something no other test checks).", "",
              "| Test | Runs | Bins hit | Only this test |", "|---|---|---|---|"]
    for t in data["tests"]:
        only = ", ".join(f"`{x}`" for x in t["only_this"]) or "-"
        lines.append(f"| {t['test']} | {t['runs']} | {t['bins_hit']} / {data['total']} | {only} |")
    return "\n".join(lines) + "\n"


def verilator_coverage():
    exe = shutil.which("verilator_coverage")
    if exe:
        return exe
    vl = os.environ.get("VERILATOR") or shutil.which("verilator")
    cand = os.path.join(os.path.dirname(vl), "verilator_coverage") if vl else ""
    return cand if os.path.isfile(cand) else None


def portable(text):
    """The absolute source paths of a .dat / .info, made relative to the repository."""
    def fix(m):
        return m.group(1) + repo_path(m.group(2))
    text = re.sub(r"^(SF:)(.*)$", fix, text, flags=re.M)
    return re.sub(r"(\x01f\x02)([^\x01']*)", fix, text)


def write_merged(bench_dir, runs, out_dir):
    """merged.dat / merged.info of the given runs into out_dir (portable paths); returns the .info."""
    vc = verilator_coverage()
    files = [os.path.join(bench_dir, "coverage", f"{t}_s{s}.dat") for t, s in sorted(runs)]
    files = [f for f in files if os.path.isfile(f)]
    if not vc or not files:
        return None
    with tempfile.TemporaryDirectory() as tmp:
        dat, info = os.path.join(tmp, "merged.dat"), os.path.join(tmp, "merged.info")
        rc = subprocess.call([vc, "--write", dat, "--write-info", info] + files,
                             stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        if rc != 0:
            print(f"    (coverage merge failed: {vc} exit {rc})")
            return None
        for src in (dat, info):
            with open(os.path.join(out_dir, os.path.basename(src)), "w") as fh:
                fh.write(portable(open(src, errors="replace").read()))
    return os.path.join(out_dir, "merged.info")


def write_html(info, html_dir, title):
    """genhtml of a (portable) merged.info; False when lcov is not installed."""
    genhtml = shutil.which("genhtml")
    if not genhtml:
        print("    (no coverage HTML: genhtml not found -- install lcov, see scripts/setup_sim.sh)")
        return False
    if os.path.isdir(html_dir):
        shutil.rmtree(html_dir)
    # genhtml reads the sources: give it absolute paths and strip the repository root again
    text = re.sub(r"^SF:(?!/)(.*)$", lambda m: "SF:" + os.path.join(ROOT, m.group(1)), open(info).read(), flags=re.M)
    with tempfile.NamedTemporaryFile("w", suffix=".info", delete=False) as tmp:
        tmp.write(text)
    rc = subprocess.call([genhtml, "-q", "--branch-coverage", "--no-function-coverage", "--title", title,
                          "--header-title", "YAPP functional coverage (covergroup bins)",
                          "--prefix", ROOT, "-o", html_dir, tmp.name],
                         cwd=ROOT, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
    os.remove(tmp.name)
    if rc != 0:
        print(f"    (genhtml failed with exit {rc})")
        return False
    # the HTML says when and where it was made; keep the committed copy stable
    for f in glob.glob(os.path.join(html_dir, "**", "*.html"), recursive=True):
        text = open(f).read()
        text = re.sub(r'(<td class="headerItem">Test Date:</td>\s*<td class="headerValue">)[^<]*', r"\1-", text)
        with open(f, "w") as fh:
            fh.write(text)
    cmd_line = os.path.join(html_dir, "cmd_line")
    if os.path.isfile(cmd_line):
        os.remove(cmd_line)
    return True


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--only", action="append", help="benches whose build directory contains this")
    ap.add_argument("--md", action="store_true", help="Markdown tables instead of plain text (the CI step summary)")
    ns = ap.parse_args()
    found = False
    for bench_dir in sorted(glob.glob(os.path.join(BUILD, "*"))):
        if ns.only and not any(o in os.path.basename(bench_dir) for o in ns.only):
            continue
        data = collect(bench_dir)
        if not data:
            continue
        found = True
        hole_list = holes(data)
        if ns.md:
            print(f"### Functional coverage: {data['bench']} -- {data['covered']} / {data['total']} bins over {data['runs']} runs\n")
            print("| Covergroup | Bins hit | Coverage | File |\n|---|---|---|---|")
            for g in data["covergroups"]:
                print(f"| `{g['name']}` | {g['covered']} / {g['total']} | {g['pct']:.1f}% | `{g['file']}` |")
            print()
            if hole_list:
                print("| Hole | Where |\n|---|---|")
                for cg, point, b, line, f in hole_list:
                    print(f"| `{cg}.{point}.{b}` | `{f}:{line}` |")
                print()
            continue
        print(f"{data['bench']}: {data['runs']} runs, {data['covered']} / {data['total']} bins")
        for g in data["covergroups"]:
            print(f"  {g['name']:<16} {g['covered']:>3} / {g['total']:<3} {g['pct']:5.1f}%  {g['file']}")
        for cg, point, b, line, f in hole_list:
            print(f"    hole: {cg}.{point}.{b}  ({f}:{line})")
    if not found:
        sys.exit("coverage_report.py: no coverage files under build/sim/*/coverage -- run `make regress` first")


if __name__ == "__main__":
    main()
