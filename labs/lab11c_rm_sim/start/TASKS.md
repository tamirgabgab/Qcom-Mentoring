# Lab 11C — Register model: simulation — start point

This directory is where you work on Lab 11C. It is the finished state of the lab before it (`labs/lab11b_rm_integ`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab11c_rm_sim/sv`, `labs/lab11c_rm_sim/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab11c/

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/tests/reg_access_test.sv`
* `tb/tests/reg_function_check_test.sv`
* `tb/tests/reg_function_test.sv`
* `tb/tests/reg_introspection_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/router_test_lib.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/reg/addr0_cnt_reg_c.sv`, `tb/reg/addr1_cnt_reg_c.sv`, `tb/reg/addr2_cnt_reg_c.sv`, `tb/reg/addr3_cnt_reg_c.sv`, `tb/reg/ctrl_reg_c.sv`, `tb/reg/en_reg_c.sv`, `tb/reg/mem_size_reg_c.sv`, `tb/reg/oversized_pkt_cnt_reg_c.sv`, `tb/reg/parity_err_cnt_reg_c.sv`, `tb/reg/ro_byte_reg_c.sv`, `tb/reg/yapp_mem_c.sv`, `tb/reg/yapp_pkt_mem_c.sv`, `tb/reg/yapp_regs_c.sv`, `tb/reg/yapp_router_regs_t.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/router_tb.sv`, `tb/tb_top.sv`, `tb/tests/base_test.sv`, `tb/tests/uvm_mem_walk_test.sv`, `tb/tests/uvm_reset_test.sv`, `tb/yapp_router_reg_pkg.sv`

## Run and check

```bash
cd labs/lab11c_rm_sim/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab11c_rm_sim START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=reg_access_test
make run TEST=reg_function_test
make run TEST=reg_function_check_test
make run TEST=reg_introspection_test
```

**Expected:**

* `reg_access_test`: eight `[REG_ACCESS]` lines; the RO write produces an HBUS
  `WRITE addr=0x1009` in the monitor log but the following `peek` still
  returns `0x5a`; `UVM_ERROR : 0`.
* `reg_function_test`: `addr*_cnt_reg reads 0 as expected` ×4, then
  `addr0_cnt_reg reads 2`, `addr1_cnt_reg reads 2`, `addr2_cnt_reg reads 2`,
  `addr3_cnt_reg reads 0`, `parity_err_cnt_reg reads N` (N = bad-parity
  packets among the last six), `oversized_pkt_cnt_reg reads 0`.
* `reg_function_check_test`: same values, 0 errors. Comment out the
  `predict()` call to see the check-on-read errors the lab talks about.
* `reg_introspection_test`: `RW register: ctrl_reg @ 0x1000`, `RW register:
  en_reg @ 0x1001`, seven `RO register:` lines, then the access checks for all
  nine registers, 0 errors.
