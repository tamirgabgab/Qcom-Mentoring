# Lab 10 — A simple functional coverage model *(optional)* — start point

This directory is where you work on Lab 10. It is the finished state of the lab before it (`labs/lab09_sbc`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab10_cov/sv`, `labs/lab10_cov/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab10/

## Steps (from the lab page)

1. The covergroup in `yapp_pkt_coverage`
2. Stimulus that closes the model — `yapp_coverage_seq`
3. `coverage_test`
4. `run.f`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/tests/coverage_test.sv`
* `tb/tests/router_simple_mcseq_test.sv`
* `sv/yapp_pkt_coverage.sv` — shadows `yapp_project/uvc/yapp/yapp_pkt_coverage.sv` through `-incdir ../sv`
* `sv/seqs/yapp_coverage_seq.sv` — shadows `yapp_project/uvc/yapp/seqs/yapp_coverage_seq.sv` through `-incdir ../sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/router_test_lib.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/router_tb.sv`, `tb/tb_top.sv`, `tb/tests/base_test.sv`, `tb/tests/test_uvc_integration.sv`

## Run and check

```bash
cd labs/lab10_cov/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab10_cov START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=router_simple_mcseq_test   # see the holes
make run TEST=coverage_test              # close them
make gui TEST=coverage_test              # Windows -> Tools -> Coverage
imc -load cov_work/scope/coverage_test   # or IMC standalone
```

With Verilator every run writes its bins to a coverage database;
`make regress` then `make sim-report` merges them into `coverage.md` and an
HTML page (see [Functional coverage](../components/coverage.md#seeing-the-results-verilator)).

In IMC: *Verification Hierarchy → uvm_pkg → … yapp_pkt_coverage* → right-click →
*Cover Group Analysis* → *Items* of `yapp_pkt_cg`.

**Expected:** with `router_simple_mcseq_test` (short packets) `LARGE`, `MAX`
and `illegal_addr` are empty and most of the cross is uncovered; the
collector's report line (`YAPP packet coverage: ... coverage N%`) shows the
percentage. With `coverage_test` all 5 length bins, all
4 address bins, both parity values and all 15 cross bins are hit: 100%.
