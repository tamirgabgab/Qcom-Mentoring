#!/usr/bin/env python3
"""
lint.py -- elaborate one or more xrun-style `run.f` command files with slang
(via pyslang) and report every error.

This is the only automated check that runs without a simulator. It compiles
the real UVM library source (scripts/uvm_src, fetched by scripts/get_uvm.sh)
together with the lab files, so missing classes, wrong types, bad macro usage,
port/interface mismatches and most elaboration problems are caught.

Usage:
    python3 scripts/lint.py labs/lab03_uvc/tb/run.f [more run.f ...]
    python3 scripts/lint.py --all          # every labs/*/tb/run.f + test_install

xrun options that have no meaning for a linter (+UVM_TESTNAME, -gui, -access,
-coverage, -uvmhome, ...) are ignored. `-incdir`, `-define`, `-timescale`,
`-f` and plain file names are translated to slang arguments.
"""
import argparse
import glob
import os
import shlex
import sys

try:
    import pyslang
except ImportError:  # pragma: no cover
    sys.exit("pyslang is not installed: pip install pyslang")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
UVM_SRC = os.path.join(ROOT, "scripts", "uvm_src", "src")
COMMON = os.path.join(ROOT, "common")

# xrun options that take one argument and are dropped
_DROP_WITH_ARG = {
    "-uvmhome", "-access", "-coverage", "-debug_opts", "-l", "-log", "-input",
    "-covworkdir", "-covtest", "-seed", "-svseed", "-xmlibdirname", "-licqueue",
    "-nclibdirname", "-linedebug", "-covfile", "-covdut",
}
# xrun options without argument that are dropped
_DROP = {"-uvm", "-gui", "-64bit", "-sv", "-q", "-clean", "-R", "-exit", "-linedebug",
         "-plusperf", "-nowarn", "-covoverwrite", "-vlogext", "-sysv", "-licqueue", "-ALLOWREDEFINITION"}


def parse_run_f(path, args, seen):
    """Translate an xrun command file into slang arguments (recursive)."""
    path = os.path.abspath(path)
    if path in seen:
        return
    seen.add(path)
    base = os.path.dirname(path)
    with open(path) as fh:
        text = fh.read()
    tokens = []
    for line in text.splitlines():
        for marker in ("//", "#"):
            if marker in line:
                line = line.split(marker, 1)[0]
        tokens.extend(shlex.split(line))

    it = iter(tokens)
    for tok in it:
        tok = os.path.expandvars(tok)
        if tok in ("-f", "-F"):
            parse_run_f(os.path.join(base, next(it)), args, seen)
        elif tok == "-incdir":
            args += ["-I", os.path.join(base, next(it))]
        elif tok.startswith("+incdir+"):
            for inc in tok[len("+incdir+"):].split("+"):
                args += ["-I", os.path.join(base, inc)]
        elif tok == "-define":
            args += ["-D", next(it)]
        elif tok.startswith("+define+"):
            for d in tok[len("+define+"):].split("+"):
                args += ["-D", d]
        elif tok == "-timescale":
            args += ["--timescale", next(it)]
        elif tok == "-top":
            args += ["--top", next(it)]
        elif tok in _DROP_WITH_ARG:
            next(it)
        elif tok in _DROP or tok.startswith("+"):
            continue   # plusargs such as +UVM_TESTNAME=... are runtime only
        elif tok.startswith("-"):
            print(f"  [lint] ignoring unknown xrun option {tok}")
        else:
            args.append(os.path.join(base, tok))


def lint_one(run_f, quiet=False):
    args = [
        "-I", UVM_SRC, os.path.join(UVM_SRC, "uvm_pkg.sv"),
        "-I", COMMON,
        "-D", "UVM_ENABLE_DEPRECATED_API",   # starting_phase, uvm_top, ... (1.1d/1.2 style)
        "-D", "UVM_NO_DPI",
        "--suppress-warnings", os.path.dirname(UVM_SRC),
        "--suppress-macro-warnings", os.path.dirname(UVM_SRC),
        "--allow-use-before-declare",
        "--error-limit", "40",
        "-Wno-unused",
        "-Wno-implicit-conv",
        "-Wno-width-trunc",
        "-Wno-width-expand",
        "-Wno-sign-conversion",
        "-Wno-unknown-escape-code",   # one regex string inside the UVM library
    ]
    parse_run_f(run_f, args, set())

    drv = pyslang.driver.Driver()
    drv.addStandardArgs()
    cmd = "slang " + " ".join(shlex.quote(a) for a in args)
    if not drv.parseCommandLine(cmd):
        return False
    if not drv.processOptions():
        return False
    # Step by step (runFullCompilation() from Python does not see the sources)
    ok = drv.parseAllSources()
    ok = drv.reportParseDiags() and ok
    comp = drv.createCompilation()
    drv.reportCompilation(comp, quiet)
    return drv.reportDiagnostics(quiet) and ok


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("run_f", nargs="*", help="xrun command files to lint")
    ap.add_argument("--all", action="store_true", help="lint every lab and test_install")
    ap.add_argument("-q", "--quiet", action="store_true", help="only print errors")
    ns = ap.parse_args()

    if not os.path.isdir(UVM_SRC):
        sys.exit(f"UVM source not found in {UVM_SRC}: run scripts/get_uvm.sh (or `make uvm-src`)")

    targets = list(ns.run_f)
    if ns.all:
        targets += sorted(glob.glob(os.path.join(ROOT, "test_install", "run.f")))
        targets += sorted(glob.glob(os.path.join(ROOT, "labs", "*", "tb", "run.f")))
        targets += sorted(glob.glob(os.path.join(ROOT, "labs", "*", "run.f")))   # lab11a (no tb/)
    if not targets:
        ap.error("no run.f given (use --all)")

    failed = []
    for run_f in targets:
        rel = os.path.relpath(run_f, ROOT)
        print(f"==> {rel}")
        if lint_one(run_f, ns.quiet):
            print(f"    OK")
        else:
            print(f"    FAILED")
            failed.append(rel)

    print()
    if failed:
        print(f"{len(failed)}/{len(targets)} command file(s) FAILED:")
        for f in failed:
            print(f"  - {f}")
        sys.exit(1)
    print(f"All {len(targets)} command file(s) passed lint.")


if __name__ == "__main__":
    main()
