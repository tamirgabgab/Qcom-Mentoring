# Lab 2 — Creating test and testbench components — start point

This directory is where you work on Lab 2. It is the finished state of the lab before it (`labs/lab01_data`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab02_test/sv`, `labs/lab02_test/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab02/

## Steps (from the lab page)

1. `tb/router_tb.sv`
2. `tb/router_test_lib.sv`
3. `tb/top.sv`
4. `tb/run.f`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/router_tb.sv`
* `tb/tests/base_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tests/test2.sv`
* `tb/top.sv`

**Unchanged since the previous lab**: `sv/yapp_defines.sv`, `sv/yapp_packet.sv`, `sv/yapp_pkg.sv`, `tb/Makefile`

## Run and check

```bash
cd labs/lab02_test/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab02_test START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run                                   # +UVM_TESTNAME=base_test +UVM_VERBOSITY=UVM_HIGH from run.f
make run TEST=test2
make run XRUN_OPTS=+UVM_VERBOSITY=UVM_LOW   # overrides the run.f setting, no recompile
```

**Expected (UVM_HIGH):**

```
UVM_INFO ... [RNTST] Running test base_test...
UVM_INFO ... [base_test] Executing the build phase of the test
UVM_INFO ... [router_tb] Executing the build phase of the testbench
UVM_INFO ... [UVMTOP] UVM testbench topology:
--------------------------------
Name           Type        Size  Value
--------------------------------
uvm_test_top   base_test   -     @...
  tb           router_tb   -     @...
--------------------------------
```

With `UVM_LOW` the two "Executing the build phase" lines disappear; the
topology stays (it is printed at `UVM_NONE`).
