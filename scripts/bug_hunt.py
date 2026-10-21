#!/usr/bin/env python3
"""The bug hunt: does the regression catch every deliberate bug in the RTL?

    python3 scripts/bug_hunt.py                       (make bug-hunt) every mutant, writes the committed result
    python3 scripts/bug_hunt.py --mutant BUG_X --check    one mutant, exit 1 when no test catches it (CI)

Every mutant of scripts/mutants.yaml is a `define in yapp_project/rtl. The design is compiled
once per mutant (build/sim/yapp_project_tb__<name>/), every test of yapp_project/tb in
scripts/regress.yaml runs on it once (seed 1), and the result says which tests failed -- the
tests that *catch* the bug -- with the first error line of each. The full run writes
docs/assets/generated/bug_hunt.json, from which `make map` builds docs/bug-hunt.md; a partial
run (--mutant) writes build/sim/bug_hunt_<name>.json instead.
"""

import argparse
import json
import os
import shutil
import re
import subprocess
import sys
import time

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
import sim  # noqa: E402  the Verilator flow: compile_dir / run_one / load_regress

MUTANTS = os.path.join(ROOT, "scripts", "mutants.yaml")
RESULT = os.path.join(ROOT, "docs", "assets", "generated", "bug_hunt.json")
BENCH = "yapp_project/tb"


def project_tests():
    cfg = sim.load_regress()["benches"][BENCH]
    tests = cfg["tests"] if isinstance(cfg, dict) else cfg
    return [t["test"] if isinstance(t, dict) else t for t in tests]


def first_error(log):
    for line in open(log, errors="replace"):
        if line.startswith(("UVM_ERROR", "UVM_FATAL")) and not line.startswith(("UVM_ERROR :", "UVM_FATAL :")):
            # drop the file(line) @ time: prefix
            return re.sub(r"^(UVM_\w+) \S+ @ \d+: ", r"\1 ", line.strip())[:220]
    return None


def hunt(name, tests, quiet=False):
    d = os.path.join(ROOT, BENCH)
    t0 = time.time()
    if not sim.compile_dir(d, quiet=quiet, defines=[name]):
        return {"compiled": False, "caught_by": [], "missed_by": tests, "first_error": {}, "wall": time.time() - t0}
    res = {"compiled": True, "caught_by": [], "missed_by": [], "first_error": {}, "wall": 0}
    for t in tests:
        r = sim.run_one(d, t, 1, echo=False, defines=[name])
        if r["ok"]:
            res["missed_by"].append(t)
        else:
            res["caught_by"].append(t)
            res["first_error"][t] = first_error(os.path.join(ROOT, r["log"])) or r["reason"]
        if not quiet:
            print(f"    {'CAUGHT' if not r['ok'] else 'missed'}  {t:<26} {r['wall']:5.1f}s  {res['first_error'].get(t, '')[:90]}")
    res["wall"] = time.time() - t0
    # the compiled model of a mutant is ~0.5 GB and never reused: keep the logs, drop the objects
    shutil.rmtree(os.path.join(sim.build_dir(d, defines=[name]), "obj"), ignore_errors=True)
    return res


def git_commit():
    try:
        return subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], cwd=ROOT, text=True).strip()
    except Exception:
        return None


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--mutant", action="append", help="only this mutant (repeatable)")
    ap.add_argument("--check", action="store_true", help="exit 1 when a mutant survives every test")
    ns = ap.parse_args()
    mutants = yaml.safe_load(open(MUTANTS))["mutants"]
    names = ns.mutant or list(mutants)
    unknown = [n for n in names if n not in mutants]
    if unknown:
        sim.die("not in scripts/mutants.yaml: " + ", ".join(unknown))
    tests = project_tests()
    out = {"date": time.strftime("%Y-%m-%d"), "commit": git_commit(), "tests": tests, "mutants": {}}
    survivors = []
    for n in names:
        print(f"==> {n}: {mutants[n]['bug']}")
        res = hunt(n, tests)
        out["mutants"][n] = res
        n_c = len(res["caught_by"])
        print(f"    {n}: caught by {n_c} of {len(tests)} tests ({res['wall'] / 60:.1f} min)" + ("" if res["compiled"] else "  COMPILE FAILED"))
        if not n_c:
            survivors.append(n)
    partial = bool(ns.mutant)
    path = os.path.join(sim.BUILD, f"bug_hunt_{'_'.join(names)}.json") if partial else RESULT
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as fh:
        json.dump(out, fh, indent=1)
        fh.write("\n")
    print(f"\nbug hunt: {len(names) - len(survivors)} of {len(names)} mutant(s) caught -> {os.path.relpath(path, ROOT)}")
    if survivors:
        print("SURVIVED (no test fails on them): " + ", ".join(survivors))
    if not partial:
        print("now `make map` (docs/bug-hunt.md) and commit docs/assets/generated/bug_hunt.json")
    return 1 if (ns.check and survivors) else 0


if __name__ == "__main__":
    sys.exit(main())
