# Lab 11B — Register model: integration — start point

This directory is where you work on Lab 11B. It is the finished state of the lab before it (`labs/lab10_cov`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab11b_rm_integ/sv`, `labs/lab11b_rm_integ/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab11b/

## Steps (from the lab page)

1. `router_tb`
2. The adapter (already in the HBUS UVC)
3. `tb_top`: import the package before `router_tb`
4. The tests
5. `run.f`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/router_tb.sv`
* `tb/tests/uvm_mem_walk_test.sv`
* `tb/tests/uvm_reset_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/reg/addr0_cnt_reg_c.sv`
* `tb/reg/addr1_cnt_reg_c.sv`
* `tb/reg/addr2_cnt_reg_c.sv`
* `tb/reg/addr3_cnt_reg_c.sv`
* `tb/reg/ctrl_reg_c.sv`
* `tb/reg/en_reg_c.sv`
* `tb/reg/mem_size_reg_c.sv`
* `tb/reg/oversized_pkt_cnt_reg_c.sv`
* `tb/reg/parity_err_cnt_reg_c.sv`
* `tb/reg/ro_byte_reg_c.sv`
* `tb/reg/yapp_mem_c.sv`
* `tb/reg/yapp_pkt_mem_c.sv`
* `tb/reg/yapp_regs_c.sv`
* `tb/reg/yapp_router_regs_t.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tb_top.sv`
* `tb/yapp_router_reg_pkg.sv`

**Unchanged since the previous lab**: `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/tests/base_test.sv`, `tb/tests/router_simple_mcseq_test.sv`

## Run and check

```bash
cd labs/lab11b_rm_integ/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab11b_rm_integ START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=uvm_reset_test
make run TEST=uvm_mem_walk_test
make run TEST=uvm_mem_walk_test XRUN_OPTS="-define INJECT_ERROR"
```

With Verilator: `make sim TEST=uvm_mem_walk_test DEFINES=INJECT_ERROR` (a separate
build in `build/sim/<dir>__INJECT_ERROR/`). `make regress` runs that build too and
counts it as passed only when the walk reports the error.

**Expected:**

* `uvm_reset_test`: the topology shows `yapp_rm` under `tb` (`router_tb::do_print`
  calls `printer.print_object("yapp_rm", yapp_rm)`); the HBUS monitor logs one `READ` per register
  (`0x1000`, `0x1001`, `0x1004` … `0x100d`); `UVM_ERROR : 0`.
* `uvm_mem_walk_test`: HBUS traffic over `0x1100..0x11ff` only (`yapp_pkt_mem`
  is RO and skipped); the HBUS report says **511 writes, 255 reads**.
* with `INJECT_ERROR`: `UVM_ERROR … [uvm_mem_walk_seq] Memory … read back as
  … instead of …` at address `0x112a`.
