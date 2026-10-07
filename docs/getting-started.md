# Getting started

## What you need

| Tool | Why | Notes |
|---|---|---|
| **Cadence Xcelium** (`xrun`) | runs the labs | any release that ships a UVM library (17.04 or later) |
| UVM library | `-uvmhome CDNS-1.1d` in every `run.f` | the course recommends 1.1d because of transaction-recording quirks in 1.2; `CDNS-1.2` works too — the code compiles on both (see [compat shim](#uvm-versions)) |
| SimVision / Verisium | GUI debug (Labs 5, 6, 10) | optional |
| Python 3 + `pip install pyslang mkdocs-material` | lint without a simulator, build this site | optional |

## Check the installation

```bash
cd test_install
xrun -f run.f
```

The log must show the UVM version banner and

```
UVM_INFO ... [INSTALL] UVM TEST INSTALL PASSED!
```

## Running a lab

Every lab directory has the same shape:

```
labs/lab05_seq/
├── sv/        the UVC source files of that lab (Labs 1-6 only; later labs use yapp/sv)
└── tb/        testbench, tests, top modules
    ├── run.f      xrun command file: what to compile + default plusargs
    └── Makefile   make run / gui / lint / clean
```

```bash
cd labs/lab05_seq/tb
make run                                   # +UVM_TESTNAME from run.f
make run TEST=incr_payload_test            # pick another test, no recompilation needed
make run TEST=exhaustive_seq_test XRUN_OPTS="+UVM_VERBOSITY=UVM_FULL +SVSEED=random"
make gui TEST=exhaustive_seq_test          # SimVision, -access +rwc
```

Or from the repository root: `make run LAB=lab05_seq TEST=exhaustive_seq_test`.

### The plusargs you will use all the time

| Plusarg | Effect |
|---|---|
| `+UVM_TESTNAME=<class>` | which `uvm_test` subclass `run_test()` creates |
| `+UVM_VERBOSITY=UVM_LOW\|UVM_MEDIUM\|UVM_HIGH\|UVM_FULL` | filters `` `uvm_info `` messages |
| `+SVSEED=random` | new random seed every run (the seed is printed in the log) |
| `+SVSEED=1234` | reproduce a run |

The full list of `xrun` options used in the course is in the
[xrun appendix](appendix/xrun.md).

## Reading the log

The three lines you look for first:

```
UVM_INFO ... Running test base_test...            <- which test runs
--- UVM Report Summary ---                        <- counts of errors / warnings
UVM_ERROR :    0
```

Every component of the environment prints a short report at the end of the
simulation (packets sent, collected, matched...). The lab pages tell you which
numbers to expect.

## Linting without a simulator

`scripts/lint.py` elaborates a `run.f` with [slang](https://github.com/MikePopoloski/slang)
together with the real Accellera UVM source. It catches syntax errors, unknown
classes and methods, type mismatches and port/interface problems — everything
except run-time behaviour.

```bash
pip install pyslang
make lint                   # every lab + test_install
make lint LAB=lab08_mcseq   # one lab
```

The same check runs in GitHub Actions on every push (`.github/workflows/lint.yml`).

## Building this site

```bash
pip install mkdocs-material
make serve      # http://127.0.0.1:8000, live reload
make docs       # static site in site/
```

!!! note "Diagrams need network access"
    The block diagrams are Mermaid sources rendered in the browser; Material
    for MkDocs fetches the Mermaid library from `unpkg.com` on page load. On a
    network that blocks CDNs the diagrams show as text. The protocol waveforms
    are plain SVG files and always render.

## UVM versions

The code targets **UVM 1.1d and 1.2** (Cadence libraries). The only API that
differs between the two and matters here is how a sequence reaches its
starting phase (`starting_phase` member vs `get_starting_phase()`). The shim
`common/uvm_version_compat.svh` hides it behind one macro:

--8<-- "common/uvm_version_compat.svh"

Every `run.f` adds `-incdir ../../../common` so the packages can include it.
