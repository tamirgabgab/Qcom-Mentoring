# Lab 9D — Using TLM analysis FIFOs *(optional)* — start point

This directory is where you work on Lab 9D. It is the finished state of the lab before it (`labs/lab09_sbb`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab09_sbd/sv`, `labs/lab09_sbd/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab09d/

## Steps (from the lab page)

1. `sv/router_fifo_scoreboard.sv`
2. `router_tb`: FIFO scoreboard instead of the module env

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/router_fifo_scoreboard.sv`
* `sv/router_module_env.sv`
* `tb/router_tb.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/router_module_pkg.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `sv/packet_compare.sv`, `sv/router_reference.sv`, `sv/router_scoreboard.sv`, `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/router_test_lib.sv`, `tb/tb_top.sv`, `tb/tests/base_test.sv`, `tb/tests/router_simple_mcseq_test.sv`, `tb/tests/scoreboard_drop_test.sv`, `tb/tests/simple_test.sv`, `tb/tests/test_uvc_integration.sv`

## Run and check

```bash
cd labs/lab09_sbd/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab09_sbd START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=router_simple_mcseq_test
make run TEST=scoreboard_drop_test
```

**Expected:** `--- FIFO scoreboard report ---` with 12 received / 12 matched
(first test) or N matched + the dropped counts (second), every FIFO empty in
`check_phase`, `UVM_ERROR : 0`.
