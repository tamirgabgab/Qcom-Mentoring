# Getting started

## What you need

Two ways to run the labs; pick one.

| | Verilator (free) | Cadence Xcelium |
|---|---|---|
| **Get it** | nothing to install: open the repository in a [GitHub Codespace](https://codespaces.new/tamirgabgab/Qcom-Mentoring?quickstart=1) — or `bash scripts/setup_sim.sh` on Ubuntu / WSL2 (builds Verilator 5.052, ~15 min once) | a licence; any release that ships a UVM library (17.04 or later), `-uvmhome CDNS-1.1d` in every `run.f` (`CDNS-1.2` works too, see [UVM versions](#uvm-versions)) |
| **Run a test** | `make sim TEST=<test>` in the lab's `tb/` | `make run TEST=<test>` in the lab's `tb/` |
| **Waves** | `make sim ... WAVES=1`, then VaporView in Codespaces / Surfer / GTKWave | SimVision (`make gui`) |
| **Details** | [Simulating with Verilator](appendix/verilator.md): the same labs, the same tests, the few differences | [xrun options](appendix/xrun.md) |

Either way, `pip install pyslang mkdocs-material` adds the lint without a simulator (`make lint`) and
lets you build this site; both are optional.

## Check the installation

```bash
cd test_install
make sim                 # Verilator
make run                 # Xcelium:  xrun -f run.f
```

The log must show the UVM version banner and

```
UVM_INFO ... [INSTALL] UVM TEST INSTALL PASSED!
```

(`make sim` prints `PASS: default seed 1` under it.)

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
│   ├── yapp/            YAPP input UVC (seqs/ holds the sequence classes; pkt / gap coverage collectors)
│   ├── hbus/            HBUS UVC, including hbus_reg_adapter
│   ├── channel/         Channel UVC
│   ├── clock_and_reset/ Clock & Reset UVC and clkgen
│   └── router/          router module UVC: reference model, scoreboards, coverage collectors, packet_compare
├── tb/                  the final testbench
│   ├── tb_top.sv, hw_top.sv, router_tb.sv, router_mcsequencer.sv, yapp_router_tracer.sv (the DUT tracer)
│   ├── tests/           one file per test class, included by router_test_lib.sv
│   ├── mcseqs/          the multichannel sequences, included by router_mcseqs_lib.sv
│   ├── reg/             the register model classes, included by yapp_router_reg_pkg.sv
│   ├── run.f            xrun command file (default test: reg_function_test)
│   └── Makefile         make run / gui / lint / clean (Xcelium), compile / sim / waves (Verilator)
└── regression/          the committed report of the last regression: logs, timelines, waves, coverage
```

```bash
cd yapp_project/tb
make run TEST=reg_function_test       # any test of tests/, see run.f for the list
make run TEST=uvm_mem_walk_test XRUN_OPTS="+UVM_VERBOSITY=UVM_HIGH"
make lint                             # slang elaboration check, no simulator
```

The labs are snapshots along the way to this project. Labs 1–6 carry their own copy of the
YAPP UVC in `labs/<lab>/sv`; from Lab 7 on, every lab's `run.f` compiles the YAPP UVC and the
provided UVCs from `yapp_project/uvc/` and the DUT from `yapp_project/rtl/yapp_router.f`, so
the lab directory holds the testbench of that lab — plus, in Labs 9A–9D, the router module UVC
as it grows (`labs/lab09_*/sv`), whose finished form is `yapp_project/uvc/router`.

## Running a lab

Every lab directory has the same shape:

```
labs/lab05_seq/
├── sv/        the UVC source files of that lab (Labs 1-6: the YAPP UVC; 9A-9D: the router module UVC)
│   └── seqs/      one file per sequence class, included by yapp_tx_seqs.sv
├── tb/        testbench, tests, top modules
│   ├── tests/     one file per test class, included by router_test_lib.sv
│   ├── run.f      xrun command file: what to compile + default plusargs
│   └── Makefile   make run / gui / lint / clean (Xcelium); compile / sim / waves (Verilator)
└── start/     your copy to work in: the same sv/ and tb/, with the bodies of the lab's methods emptied
    └── TASKS.md   the steps of the lab, which files to write, how to run and check
```

## Working on a lab: `start/` and `make check`

`sv/` and `tb/` are the finished lab. **`start/` is where you work**: it holds the finished state of
the lab before this one, plus the files this lab adds or changes with the bodies of their methods and
constraints emptied to a `// TODO (Lab N)` comment. Every class keeps its prototypes (the table of
contents of the class in this repository's style), `new()` and the `super.<phase>()` calls stay so
that everything compiles from the first minute, and the comments of the finished bodies are left in
place as hints. `start/TASKS.md` lists the steps of the lab page, the files to write and the files
that are given. Modules, interfaces, packages and `run.f` are given even when the lab changes them:
the work of a lab is in its classes.

```bash
cd labs/lab05_seq/start/tb
make sim TEST=incr_payload_test      # compiles the start point as it is: the test runs, does little
# ... write the bodies in start/sv and start/tb, following start/TASKS.md and the lab page ...
make sim TEST=incr_payload_test      # again, until the log shows what the lab page promises
```

**`make check`** is the lab page's "Expected" paragraph as a program. From the repository root it runs
every test of the lab in Verilator and looks in each log for the lines the finished lab prints
(`scripts/lab_checks.yaml`): the sequences that must run, the packets that must be collected, the
reports that must say `0 mismatched`, and of course `0 UVM_ERROR`. One line per check, `ok` or
`MISSING`, and the path of the log when something is missing:

```bash
make check LAB=lab05_seq START=1     # your work in labs/lab05_seq/start/
make check LAB=lab05_seq             # the finished lab (every line ok)
make check LAB=lab05_seq START=1 TEST=incr_payload_test
```

```
labs/lab05_seq/start/tb:
  FAIL  incr_payload_test          sim      0s    0.3s
        ok       ends with 0 UVM_ERROR / 0 UVM_FATAL
        MISSING  yapp_incr_payload_seq runs as the default sequence
        MISSING  the payload counts up: payload[1] = 1
        log: build/sim/labs_lab05_seq_start_tb/logs/incr_payload_test_s1.log
```

A fresh `start/` is one command away when you want to begin a lab again: `make start` regenerates
all of them from the finished labs (`git checkout labs/lab05_seq/start` restores just one).

**One class per file, bodies outside the class.** The course's library files (`yapp_tx_seqs.sv`,
`router_test_lib.sv`, `router_mcseqs_lib.sv`, `yapp_router_reg_pkg.sv`) are kept as the files
the packages include, but each of them only `include`s the class files of its sub-directory
(`seqs/`, `tests/`, `mcseqs/`, `reg/`). `short_yapp_packet` has its own file next to
`yapp_packet.sv`. Inside a file the class body is a table of contents: the properties, the
`utils` macro, the `extern constraint` lines and the `extern` method prototypes. After
`endclass` come the constraint bodies under a `// <class> -- constraints` banner
(`constraint yapp_packet::c_length { ... }`), then the method bodies under
`// <class> -- method implementations`, as `function yapp_packet::set_parity();` or
`task yapp_012_seq::body();`. Constraint and method bodies look alike: each is preceded
by a `//-----` delimiter line (the first one after a banner excepted), opens on its own line
and holds one statement per line, with one blank line between bodies. Read the
prototypes to learn what a class does, scroll down to see how.

The names follow fixed rules. Every class property starts with `m_` (`m_addr`, `m_length`,
`m_monitor`, `m_vif`); arguments and locals never do, so inside a method `length` is the
argument and `m_length` the field. The UVM runtime names stay plain: `create("monitor", this)`,
`new("item_collected_port", this)`, the `uvm_config_db` keys, so the hierarchy in the logs reads
`uvm_test_top.tb.yapp.agent.monitor`. Packed widths are written without a space (`bit[7:0]`).
The typedefs and enums of a package live in its `<pkg>_defines.sv` (`yapp_defines.sv`,
`hbus_defines.sv`, …), included first by the package file; an enum type ends with `_e`, its
values are upper case with the type name as prefix and the first one is always
`<NAME>_UNDEFINED`, a value no constraint or assignment ever produces
(`PARITY_TYPE_UNDEFINED, PARITY_TYPE_GOOD, PARITY_TYPE_BAD`). Three more conventions hold
everywhere: a function declares its locals at its top (never in a bare `begin … end` in the middle
of the body), the body of an `if` / `else` / `for` / `foreach` / `while` / `repeat` is always
wrapped in `begin … end`, even a single statement, and random values that are not fields of a
randomized object come from the common library `rnd::` ([Random values](components/random.md)),
not from `$urandom`. `make style-check` (`scripts/sv_style.py`) enforces all of this in CI,
reporting each violation as `file:line`, and `make style` reformats a file you wrote.

The classes also do without the shortcut macros of the course material: no `uvm_do*`
(a sequence writes `create` → `start_item` → `randomize` → `finish_item` itself, and starts a
sub-sequence with `seq.start(m_sequencer, this)`), and no `uvm_field_*` automation (`do_print`,
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

The lines you look for first:

```
UVM_INFO ... Running test base_test...            <- which test runs
[TEST] === base_test  seed 1 ===                  <- the banner of the project's tests (and the seed)
[TEST] STAGE: ...                                 <- what the test is doing now
[TEST] === base_test  seed 1: PASSED (0 UVM_ERROR, 0 UVM_FATAL) ===
--- UVM Report Summary ---                        <- counts of errors / warnings
UVM_ERROR :    0
```

Every component of the environment prints a short report at the end of the
simulation (packets sent, collected, matched...). The lab pages tell you which
numbers to expect.

## Simulating without Xcelium

Every lab directory also has a free flow with Verilator, from the same `run.f`:

```bash
cd labs/lab07_integ/tb
make sim TEST=simple_test            # compile (first time ~2.5 min) and run: PASS / FAIL
make sim TEST=simple_test WAVES=1    # with waves in build/sim/.../waves/simple_test.fst
make regress                         # at the root: every lab and every test
```

Installation, waves, the regression in GitHub Actions and the few differences
from Xcelium: [Simulating with Verilator](appendix/verilator.md).

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
make map            # rewrites model.json, regmap.js, the standalone HTML and every generated page:
                    # test-plan.md, coverage-results.md, dut/register-map.md, regression/, the index tables
make map-check      # what CI runs: fails if the committed map is stale; also runs the
                    # consistency checks (test_model.py) and, when node is installed,
                    # the simulator checks (test_sim.mjs: RouterModel vs. the documented RTL rules)
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
