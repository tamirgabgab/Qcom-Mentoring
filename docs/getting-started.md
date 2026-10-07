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

## The complete project: `yapp_project/`

`yapp_project/` is the source of truth: the finished verification environment, the state the
course reaches at the end of Lab 11C. Everything else in the repository is derived from it.

```
yapp_project/
├── rtl/                 the DUT, one module per file
│   ├── yapp_router.sv       top level: wiring only
│   ├── yapp_input_fsm.sv    receives a packet, checks it, routes it
│   ├── yapp_output_channel.sv   FIFO + output handshake, one instance per channel
│   ├── yapp_fifo.sv
│   ├── yapp_hbus_regs.sv    every register and memory, the HBUS slave
│   ├── yapp_error_timer.sv
│   └── yapp_router.f        file list, used from run.f as -F ../rtl/yapp_router.f
├── uvc/
│   ├── yapp/            YAPP input UVC (seqs/ holds the sequence classes)
│   ├── hbus/            HBUS UVC, including hbus_reg_adapter
│   ├── channel/         Channel UVC
│   ├── clock_and_reset/ Clock & Reset UVC and clkgen
│   └── router/          router module UVC: reference model, scoreboards, packet_compare
└── tb/                  the final testbench
    ├── tb_top.sv, hw_top.sv, router_tb.sv, router_mcsequencer.sv
    ├── tests/           one file per test class, included by router_test_lib.sv
    ├── mcseqs/          the multichannel sequences, included by router_mcseqs_lib.sv
    ├── reg/             the register model classes, included by yapp_router_reg_pkg.sv
    ├── run.f            xrun command file (default test: reg_function_test)
    └── Makefile         make run / gui / lint / clean
```

```bash
cd yapp_project/tb
make run TEST=reg_function_test       # any test of tests/, see run.f for the list
make run TEST=uvm_mem_walk_test XRUN_OPTS="+UVM_VERBOSITY=UVM_HIGH"
make lint                             # slang elaboration check, no simulator
```

The labs are snapshots along the way to this project. Labs 1–6 carry their own copy of the
YAPP UVC in `labs/<lab>/sv`; from Lab 7 on, every lab's `run.f` compiles the UVCs from
`yapp_project/uvc/` and the DUT from `yapp_project/rtl/yapp_router.f`, and the lab directory
only contains the testbench of that lab.

## Running a lab

Every lab directory has the same shape:

```
labs/lab05_seq/
├── sv/        the UVC source files of that lab (Labs 1-6 only; later labs compile yapp_project/uvc/*)
│   └── seqs/      one file per sequence class, included by yapp_tx_seqs.sv
└── tb/        testbench, tests, top modules
    ├── tests/     one file per test class, included by router_test_lib.sv
    ├── run.f      xrun command file: what to compile + default plusargs
    └── Makefile   make run / gui / lint / clean
```

**One class per file, bodies outside the class.** The course's library files (`yapp_tx_seqs.sv`,
`router_test_lib.sv`, `router_mcseqs_lib.sv`, `yapp_router_reg_pkg.sv`) are kept as the files
the packages include, but each of them only `include`s the class files of its sub-directory
(`seqs/`, `tests/`, `mcseqs/`, `reg/`). `short_yapp_packet` has its own file next to
`yapp_packet.sv`. Inside a file the class body is a table of contents: fields, the `utils`
macro, constraints and `extern` prototypes. The method bodies follow `endclass` under a
`// <class> -- method implementations` banner, as `function yapp_packet::set_parity();` or
`task yapp_012_seq::body();`, each body preceded by a `//-----` delimiter line. Read the
prototypes to learn what a class does, scroll down to see how. Two more conventions hold
everywhere: a function declares its locals at its top (never in a bare `begin … end` in the middle
of the body), and the body of an `if` / `else` / `for` / `foreach` / `while` / `repeat` that sits
on its own line is always wrapped in `begin … end`. `make style-check` (`scripts/sv_style.py`)
enforces all of this in CI, and `make style` reformats a file you wrote.

The classes also do without the shortcut macros of the course material: no `uvm_do*`
(a sequence writes `create` → `start_item` → `randomize` → `finish_item` itself, and starts a
sub-sequence with `seq.start(sequencer, this)`), and no `uvm_field_*` automation (`do_print`,
`do_copy`, `do_compare`, `do_pack`, `do_unpack` and `do_record` are written by hand, and a
component reads its configuration with `uvm_config_int::get` in `build_phase`). What the
macros would hide is on the page, where you can read it.

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

## Regenerating the project map

The [project map](project-map.md) is generated from the code. After changing a class, a port or
a `connect()` call:

```bash
pip install pyslang pyyaml jinja2
make map            # rewrites docs/assets/project_map/model.json and docs/downloads/yapp_project_map.html
make map-check      # what CI runs: fails if the committed map is stale
make map-export     # optional: SVG/PNG/PDF of every view (needs node + playwright)
```

Descriptions, lab numbers and layout hints live in `scripts/project_map/annotations.yaml`.

## UVM versions

The code targets **UVM 1.1d and 1.2** (Cadence libraries). The only API that
differs between the two and matters here is how a sequence reaches its
starting phase (`starting_phase` member vs `get_starting_phase()`). The shim
`common/uvm_version_compat.svh` hides it behind one macro:

--8<-- "common/uvm_version_compat.svh"

Every `run.f` adds `-incdir ../../../common` so the packages can include it.
