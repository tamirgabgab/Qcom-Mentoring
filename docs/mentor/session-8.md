# Session 8 — The register model

**Labs:** [Lab 11A](../labs/lab11a.md), [Lab 11B](../labs/lab11b.md), [Lab 11C](../labs/lab11c.md)

## Goal

The register model: generated from the register description (11A), integrated with the adapter, the sequencer and the backdoor paths (11B), and used by tests that read, write, mirror and introspect (11C) -- the built-in sequences included.

## Before the session

* Warm builds of `labs/lab11b_rm_integ/tb` and `labs/lab11c_rm_sim/tb`; for 11A the XML and the generated package side by side (no simulation).
* Map: Classes → **Register model** tab (the block, the registers, the memories), [Hierarchy → tb.yapp_rm](../project-map.md#view=hierarchy&node=tb.yapp_rm) with the backdoor arrow to `u_regs`, and the [register simulator](../dut/spec.md#try-it-the-register-file) on the specification page.
* [Register model](../components/register-model.md) and the three lab pages.

## Plan

1. Concept (30 min): `uvm_reg_field` / `uvm_reg` / `uvm_reg_block` / `uvm_reg_map`, front door through an adapter and a sequencer, backdoor through HDL paths, the mirror and prediction, the built-in sequences (`uvm_reg_hw_reset_seq`, `uvm_mem_walk_seq`).
2. Lab 11A (30 min): the XML and what the generator makes of it; `quicktest.sv` lints the package.
3. Lab 11B (50 min) in `start/`: `router_tb` builds the model, sets the adapter, sequencer and HDL root; the tests run the built-in sequences. `make check LAB=lab11b_rm_integ START=1` counts the HBUS accesses of the walk (511 writes, 256 reads).
4. Lab 11C (50 min): `reg_access_test`, `reg_function_test` and friends -- `write`, `read`, `peek`, `poke`, `mirror`, `predict`, and the introspection test.
5. Review (20 min): the `INJECT_ERROR` build of 11B (`make sim TEST=uvm_mem_walk_test DEFINES=INJECT_ERROR`): the walk finds the corrupted byte; the checkpoint questions; where the course goes from here (the project's test plan, the random tests, the bug hunt).

## Show live

* `uvm_reset_test`: nine front-door reads, one per register, all equal to the reset values in the map.
* `uvm_mem_walk_test` with and without `INJECT_ERROR`: the one `UVM_ERROR` that names the address.
* `reg_function_test`: the counters read back through the model after six packets, and the `[TEST] STAGE` lines that tell the story.

## Where students get stuck

* `set_hdl_path_root` with the wrong prefix: every backdoor access fails with `UVM_ERROR ... hdl path`; the path is `hw_top.dut.u_regs`.
* The register package imported after `router_tb` in `tb_top`: `yapp_router_regs_t` unknown ([Lab 11B](../labs/lab11b.md)).
* `mirror()` on a counter the model cannot predict: the test must `predict()` first, or compare with `UVM_NO_CHECK`.
* The adapter's `bus2reg` not setting `status`: every access reports `UVM_NOT_OK`.

## Ask

* When would you use the backdoor in a real test, and what can it never check? (The bus protocol.)
* What does `mirror()` compare, and where does the expected value come from after a front-door `write()`?
* The walk writes 511 times and reads 256 times: why not 256 and 256?

## For next time

The course ends here; the project's [test plan](../test-plan.md), its [random tests](../components/random-tests.md) and the [bug hunt](../bug-hunt.md) are where a student goes next -- the testbench as it is used, not as it is built.
