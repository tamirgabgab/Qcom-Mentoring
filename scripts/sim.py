#!/usr/bin/env python3
"""
sim.py -- compile and run the labs and the project with Verilator (free, open
source), from the same xrun-style `run.f` command files that `make run` uses.

    python3 scripts/sim.py compile  [DIR]                  verilate DIR/run.f
    python3 scripts/sim.py run      [DIR] [-t TEST] [--seed N] [--waves]
    python3 scripts/sim.py waves    [DIR] [-t TEST]        open the last waves
    python3 scripts/sim.py regress  [--only PATTERN] [--seeds N]

DIR is a simulation directory (the one holding run.f); default: the current
directory. Everything is written under build/sim/<dir>/: the executable,
logs/<test>_s<seed>.log and waves/<test>.fst. `make compile | sim | waves` in
a lab directory and `make regress` at the root call this script.

The executable is built once per directory; the test is chosen at run time
(+UVM_TESTNAME), so changing the test does not recompile. Verilator skips the
work when no source changed.

Verilator needs a few things xrun does not (see common/verilator/ and
docs/appendix/verilator.md): the Accellera UVM source (scripts/get_uvm.sh),
UVM's DPI code in the Verilator flavour (installed by scripts/setup_sim.sh),
--timing for the testbench delays, and public access to the register block
for the RAL backdoor (common/verilator/public.vlt).
"""
import argparse
import glob
import os
import random
import re
import shlex
import shutil
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
import lint  # noqa: E402  (parse_run_f: the run.f -> file/incdir/define translation)

UVM_SRC = os.path.join(ROOT, "scripts", "uvm_src", "src")
VL_DIR = os.path.join(ROOT, "common", "verilator")
BUILD = os.path.join(ROOT, "build", "sim")
REGRESS = os.path.join(ROOT, "scripts", "regress.yaml")
UVM_DPI_SUBDIR = os.path.join("uvm-dpi", "v2020_3_1", "dpi")   # under VERILATOR_ROOT (setup_sim.sh)
TIMEOUT = 900   # seconds of wall time per run


# ------------------------------------------------------------------ helpers
def die(msg):
    sys.exit(f"sim.py: {msg}")


def verilator():
    exe = os.environ.get("VERILATOR") or shutil.which("verilator")
    if not exe:
        die("verilator not found: run scripts/setup_sim.sh (or set VERILATOR=/path/to/verilator)")
    return exe


def uvm_dpi_dir():
    """UVM's DPI sources with the Verilator HDL backend (uvm_hdl_verilator.c)."""
    cand = [os.environ.get("UVM_DPI_DIR", "")]
    try:
        vroot = subprocess.run([verilator(), "--getenv", "VERILATOR_ROOT"], capture_output=True,
                               text=True, check=True).stdout.strip()
        cand.append(os.path.join(vroot, UVM_DPI_SUBDIR))
    except (OSError, subprocess.CalledProcessError):
        pass
    for d in cand:
        if d and os.path.isfile(os.path.join(d, "uvm_dpi.cc")):
            return d
    die("UVM DPI sources for Verilator not found: run scripts/setup_sim.sh (or set UVM_DPI_DIR)")


def sim_dir(path):
    d = os.path.abspath(path or os.getcwd())
    if os.path.isfile(d):
        d = os.path.dirname(d)
    if not os.path.isfile(os.path.join(d, "run.f")):
        die(f"no run.f in {d}")
    return d


def build_dir(d):
    return os.path.join(BUILD, os.path.relpath(d, ROOT).replace(os.sep, "_"))


def run_f_tokens(run_f, seen=None):
    """Every token of a run.f, following -f/-F, comments removed (for plusargs)."""
    seen = seen if seen is not None else set()
    run_f = os.path.abspath(run_f)
    if run_f in seen:
        return []
    seen.add(run_f)
    out = []
    with open(run_f) as fh:
        toks = []
        for line in fh:
            for marker in ("//", "#"):
                line = line.split(marker, 1)[0]
            toks += shlex.split(line)
    it = iter(toks)
    for t in it:
        if t in ("-f", "-F"):
            out += run_f_tokens(os.path.join(os.path.dirname(run_f), next(it)), seen)
        else:
            out.append(t)
    return out


def runtime_plusargs(d):
    """The +plusargs of run.f, without the compile-time ones and the xrun seed."""
    keep = []
    for t in run_f_tokens(os.path.join(d, "run.f")):
        if t.startswith("+") and not t.startswith(("+incdir+", "+define+", "+SVSEED", "+svseed")):
            keep.append(t)
    return keep


def exe_path(d):
    return os.path.join(build_dir(d), "obj", "Vsim")


# ------------------------------------------------------------------ compile
def compile_dir(d, quiet=False):
    if not os.path.isdir(UVM_SRC):
        die(f"UVM source not found in {UVM_SRC}: run scripts/get_uvm.sh (or `make uvm-src`)")
    args = []
    lint.parse_run_f(os.path.join(d, "run.f"), args, set())
    vl_args = []
    it = iter(args)
    for a in it:
        if a == "-I":
            vl_args.append("+incdir+" + next(it))
        elif a == "-D":
            vl_args.append("+define+" + next(it))
        elif a == "--timescale":
            vl_args += ["--timescale", next(it)]
        elif a == "--top":
            vl_args += ["--top-module", next(it)]
        else:
            vl_args.append(a)
    dpi = uvm_dpi_dir()
    obj = os.path.join(build_dir(d), "obj")
    os.makedirs(obj, exist_ok=True)
    cmd = [verilator(), "--binary", "--timing", "--trace-fst", "--vpi",
           "-j", str(os.cpu_count() or 2), "--Mdir", obj, "--prefix", "Vsim",
           "-Wno-fatal", "-Wno-lint", "-Wno-style", "-Wno-MULTITOP",
           "--timescale", "1ns/1ns",
           "+define+UVM_ENABLE_DEPRECATED_API",          # 1.1d / 1.2 style code, as for lint
           "+incdir+" + UVM_SRC, os.path.join(UVM_SRC, "uvm_pkg.sv"),
           "+incdir+" + os.path.join(ROOT, "common"),
           os.path.join(VL_DIR, "public.vlt"), os.path.join(VL_DIR, "vl_waves.sv"),
           "-CFLAGS", "-I" + dpi, os.path.join(dpi, "uvm_dpi.cc")] + vl_args
    log = os.path.join(build_dir(d), "compile.log")
    rel = os.path.relpath(d, ROOT)
    if not quiet:
        print(f"==> compile {rel}  (log: {os.path.relpath(log, ROOT)})", flush=True)
    t0 = time.time()
    with open(log, "w") as fh:
        fh.write(" ".join(shlex.quote(c) for c in cmd) + "\n\n")
        fh.flush()
        rc = subprocess.call(cmd, cwd=d, stdout=fh, stderr=subprocess.STDOUT)
    text = open(log, errors="replace").read()
    errors = [ln for ln in text.splitlines() if ln.startswith("%Error")]
    if rc != 0 or not os.path.isfile(exe_path(d)):
        print(f"    COMPILE FAILED ({time.time() - t0:.0f}s):")
        for ln in (errors or text.splitlines()[-15:])[:15]:
            print("    " + ln)
        return False
    if not quiet:
        print(f"    ok ({time.time() - t0:.0f}s)")
    return True


# ------------------------------------------------------------------ run
def summarize(text, rc):
    """(passed, n_error, n_fatal, sim_time, reason) for one simulation log."""
    n_err = len(re.findall(r"^UVM_ERROR (?!:)", text, re.M))
    n_fat = len(re.findall(r"^UVM_FATAL (?!:)", text, re.M))
    # "$finish at <t>" after run_test(); "end at <t>" when the last initial block ends (Lab 1)
    m = re.search(r"Verilator: (?:\$finish|end) at (\S+?);", text)
    sim_time = m.group(1) if m else "?"
    reason = ""
    if rc != 0:
        reason = f"exit code {rc}"
    elif re.search(r"^%Error", text, re.M):
        reason = "simulator error"
    elif n_err or n_fat:
        reason = f"{n_err} UVM_ERROR, {n_fat} UVM_FATAL"
    elif not m:
        reason = "did not finish"
    return not reason, n_err, n_fat, sim_time, reason


def run_one(d, test=None, seed=1, waves=False, extra=(), echo=True):
    exe = exe_path(d)
    if not os.path.isfile(exe):
        die(f"{os.path.relpath(d, ROOT)} is not compiled: run `make compile` there first")
    bd = build_dir(d)
    name = test or "default"
    os.makedirs(os.path.join(bd, "logs"), exist_ok=True)
    log = os.path.join(bd, "logs", f"{name}_s{seed}.log")
    plus = runtime_plusargs(d)
    if test:
        plus = [p for p in plus if not p.startswith("+UVM_TESTNAME=")] + [f"+UVM_TESTNAME={test}"]
    plus += [f"+verilator+seed+{seed}", "+UVM_NO_RELNOTES"]
    if waves:
        os.makedirs(os.path.join(bd, "waves"), exist_ok=True)
        plus.append("+waves=" + os.path.join(bd, "waves", f"{name}.fst"))
    plus += list(extra)
    t0 = time.time()
    with open(log, "w") as fh:
        try:
            if echo:
                p = subprocess.Popen([exe] + plus, cwd=d, stdout=subprocess.PIPE,
                                     stderr=subprocess.STDOUT, text=True, errors="replace")
                for line in p.stdout:
                    sys.stdout.write(line)
                    fh.write(line)
                rc = p.wait(timeout=TIMEOUT)
            else:
                rc = subprocess.call([exe] + plus, cwd=d, stdout=fh, stderr=subprocess.STDOUT,
                                     timeout=TIMEOUT)
        except subprocess.TimeoutExpired:
            rc = -1
            fh.write(f"\n*** sim.py: killed after {TIMEOUT}s of wall time\n")
    text = open(log, errors="replace").read()
    ok, n_err, n_fat, sim_time, reason = summarize(text, rc)
    if rc == -1:
        reason = f"timeout ({TIMEOUT}s)"
        ok = False
    return {"dir": os.path.relpath(d, ROOT), "test": name, "seed": seed, "ok": ok, "errors": n_err,
            "fatals": n_fat, "sim_time": sim_time, "wall": time.time() - t0, "reason": reason,
            "log": os.path.relpath(log, ROOT)}


# ------------------------------------------------------------------ regress
def load_regress():
    try:
        import yaml
    except ImportError:
        die("PyYAML is not installed: pip install pyyaml")
    with open(REGRESS) as fh:
        return yaml.safe_load(fh)


def regress(only=None, seeds=None, report=None):
    cfg = load_regress()
    seeds = seeds or int(cfg.get("seeds", 1))
    results, broken = [], []
    t0 = time.time()
    for rel, tests in cfg["benches"].items():
        if only and not any(o in rel for o in only):
            continue
        d = os.path.join(ROOT, rel)
        if not compile_dir(d):
            broken.append(rel)
            continue
        for test in tests:
            for seed in range(1, seeds + 1):
                r = run_one(d, None if test == "default" else test, seed, echo=False)
                results.append(r)
                mark = "PASS" if r["ok"] else "FAIL"
                print(f"    {mark}  {r['test']:<26} seed {seed}  sim {r['sim_time']:>8}  "
                      f"{r['wall']:5.1f}s  {r['reason']}", flush=True)
    failed = [r for r in results if not r["ok"]]
    lines = ["# Verilator regression", "",
             f"{len(results) - len(failed)} of {len(results)} runs passed"
             + (f"; {len(broken)} bench(es) did not compile" if broken else "")
             + f" ({(time.time() - t0) / 60:.1f} min).", "",
             "| Bench | Test | Seed | Result | Sim time | Note |", "|---|---|---|---|---|---|"]
    for rel in broken:
        lines.append(f"| {rel} | -- | -- | **COMPILE FAILED** | -- | build/sim/.../compile.log |")
    for r in results:
        lines.append(f"| {r['dir']} | {r['test']} | {r['seed']} | {'pass' if r['ok'] else '**FAIL**'} "
                     f"| {r['sim_time']} | {r['reason'] or ''} |")
    text = "\n".join(lines) + "\n"
    out = report or os.path.join(BUILD, "regress.md")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w") as fh:
        fh.write(text)
    print()
    print(lines[2])
    for rel in broken:
        print(f"  COMPILE FAILED  {rel}")
    for r in failed:
        print(f"  FAIL  {r['dir']}  {r['test']} (seed {r['seed']}): {r['reason']}  -> {r['log']}")
    print(f"report: {os.path.relpath(out, ROOT)}")
    return not failed and not broken


# ------------------------------------------------------------------ waves
def open_waves(d, test):
    wdir = os.path.join(build_dir(d), "waves")
    files = sorted(glob.glob(os.path.join(wdir, f"{test or '*'}.fst")), key=os.path.getmtime)
    if not files:
        die(f"no waves in {os.path.relpath(wdir, ROOT)}: run `make sim TEST=<test> WAVES=1` first")
    f = files[-1]
    for viewer in ("surfer", "gtkwave"):
        if shutil.which(viewer) and os.environ.get("DISPLAY"):
            print(f"opening {os.path.relpath(f, ROOT)} in {viewer}")
            subprocess.Popen([viewer, f])
            return
    print(f"waves: {os.path.relpath(f, ROOT)}")
    print("  open it in VS Code (Codespaces: the Surfer extension), or with gtkwave / surfer")


# ------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("compile", help="verilate DIR/run.f")
    c.add_argument("dir", nargs="?")
    r = sub.add_parser("run", help="compile if needed, then run one test")
    r.add_argument("dir", nargs="?")
    r.add_argument("-t", "--test", help="UVM test (default: +UVM_TESTNAME of run.f)")
    r.add_argument("--seed", default="1", help="seed number or 'random' (default 1)")
    r.add_argument("--waves", action="store_true", help="record waves/<test>.fst")
    r.add_argument("plusargs", nargs="*", help="extra +plusargs, e.g. +UVM_VERBOSITY=UVM_HIGH")
    w = sub.add_parser("waves", help="open the waves of the last run")
    w.add_argument("dir", nargs="?")
    w.add_argument("-t", "--test")
    g = sub.add_parser("regress", help="every bench and test of scripts/regress.yaml")
    g.add_argument("--only", action="append", help="benches whose path contains this (repeatable)")
    g.add_argument("--seeds", type=int, help="runs per test (default: seeds: in regress.yaml)")
    g.add_argument("--report", help="markdown report (default build/sim/regress.md)")
    ns = ap.parse_args()

    if ns.cmd == "compile":
        sys.exit(0 if compile_dir(sim_dir(ns.dir)) else 1)
    if ns.cmd == "run":
        d = sim_dir(ns.dir)
        if not compile_dir(d):
            sys.exit(1)
        seed = random.randint(1, 2**31 - 1) if ns.seed == "random" else int(ns.seed)
        res = run_one(d, ns.test, seed, ns.waves, ns.plusargs)
        print(f"\n{'PASS' if res['ok'] else 'FAIL'}: {res['test']} seed {seed}, sim time {res['sim_time']}"
              + (f" -- {res['reason']}" if res["reason"] else "") + f"\nlog: {res['log']}")
        if ns.waves:
            print(f"waves: {os.path.relpath(os.path.join(build_dir(d), 'waves', res['test'] + '.fst'), ROOT)}")
        sys.exit(0 if res["ok"] else 1)
    if ns.cmd == "waves":
        open_waves(sim_dir(ns.dir), ns.test)
        return
    if ns.cmd == "regress":
        sys.exit(0 if regress(ns.only, ns.seeds, ns.report) else 1)


if __name__ == "__main__":
    main()
