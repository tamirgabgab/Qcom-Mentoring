# Lab 9B — Router module UVC — start point

This directory is where you work on Lab 9B. It is the finished state of the lab before it (`labs/lab09_sba`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab09_sbb/sv`, `labs/lab09_sbb/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab09b/

## Steps (from the lab page)

1. The reference model — `sv/router_reference.sv`
2. The env — `sv/router_module_env.sv`
3. The package — `sv/router_module_pkg.sv`
4. `router_tb`: connect through the layer

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/router_module_env.sv`
* `sv/router_reference.sv`
* `tb/router_tb.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/router_module_pkg.sv`
* `tb/run.f`
* `tb/tb_top.sv`

**Unchanged since the previous lab**: `sv/packet_compare.sv`, `sv/router_scoreboard.sv`, `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/router_test_lib.sv`, `tb/tests/base_test.sv`, `tb/tests/router_simple_mcseq_test.sv`, `tb/tests/scoreboard_drop_test.sv`, `tb/tests/simple_test.sv`, `tb/tests/test_uvc_integration.sv`

## Run and check

```bash
cd labs/lab09_sbb/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab09_sbb START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=router_simple_mcseq_test
make run TEST=scoreboard_drop_test
```

**Expected:** `router_simple_mcseq_test` as in 9A (12/12). The interesting
one is **`scoreboard_drop_test`**: the same oversized packets are dropped by
the router, but now the reference model drops them too —

```
[router_reference] Packet dropped: length 47 > maxpktsize 20
...
--- Reference model report ---
  forwarded to scoreboard   : N
  dropped (oversized)       : 12 - N
--- Scoreboard report ---
  packets received  : N
  packets matched   : N
  packets mismatched: 0
  left in queue 0/1/2: 0 / 0 / 0
```

`UVM_ERROR : 0`. The test is self-checking even with illegal traffic.
