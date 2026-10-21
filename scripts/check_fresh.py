#!/usr/bin/env python3
"""Check that the committed, generated artifacts still match their sources.

    python3 scripts/check_fresh.py            (make check-fresh; the `fresh` workflow runs it)

Checks:
  * yapp_project/regression/runs.json names every test and seed of yapp_project/tb in
    scripts/regress.yaml, and nothing else -- the committed report is from the current
    regression list. (A changed test body is not detected here: re-run `make regress ONLY=yapp_project
    WAVES=1 && make sim-report ONLY=yapp_project OUT=yapp_project/regression` after changing a test.)
  * the mutants of scripts/mutants.yaml, when the file exists, all have a result in
    docs/assets/generated/bug_hunt.json.
The offline site (offline/site/) is checked by the workflow itself: it rebuilds the site and
fails on a git diff. Exit code 1 and one line per problem when something is stale.
"""

import json
import os
import sys

import yaml

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def expected_runs(regress, bench="yapp_project/tb"):
    """{(test, seed)} that `make regress` runs for one bench, from regress.yaml."""
    cfg = regress["benches"][bench]
    top_seeds = int(regress.get("seeds", 1))
    bench_seeds = top_seeds
    tests = cfg
    if isinstance(cfg, dict):
        bench_seeds = int(cfg.get("seeds", top_seeds))
        tests = cfg["tests"]
    out = set()
    for t in tests:
        name, seeds = (t, bench_seeds) if isinstance(t, str) else (t["test"], int(t.get("seeds", bench_seeds)))
        for s in range(1, seeds + 1):
            out.add((name, str(s)))
    return out


def main():
    problems = []
    regress = yaml.safe_load(open(os.path.join(ROOT, "scripts", "regress.yaml")))
    runs_json = os.path.join(ROOT, "yapp_project", "regression", "runs.json")
    if os.path.isfile(runs_json):
        rep = json.load(open(runs_json))
        have = {(r["test"], str(r["seed"])) for r in rep["runs"] if r.get("bench_rel") == "yapp_project/tb"}
        want = expected_runs(regress)
        for t, s in sorted(want - have):
            problems.append(f"regression report: no run of {t} seed {s} (regress.yaml has it)")
        for t, s in sorted(have - want):
            problems.append(f"regression report: run of {t} seed {s} is not in regress.yaml any more")
    else:
        problems.append("yapp_project/regression/runs.json missing")
    mutants = os.path.join(ROOT, "scripts", "mutants.yaml")
    hunt = os.path.join(ROOT, "docs", "assets", "generated", "bug_hunt.json")
    if os.path.isfile(mutants):
        names = set(yaml.safe_load(open(mutants))["mutants"])
        done = set(json.load(open(hunt))["mutants"]) if os.path.isfile(hunt) else set()
        for n in sorted(names - done):
            problems.append(f"bug hunt: no result for mutant {n} (run scripts/bug_hunt.py)")
        for n in sorted(done - names):
            problems.append(f"bug hunt: result for {n}, which is not in mutants.yaml any more")
    for p in problems:
        print("STALE:", p)
    print("check_fresh: OK" if not problems else f"check_fresh: {len(problems)} problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
