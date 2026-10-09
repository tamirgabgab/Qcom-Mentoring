# Verification status

Everything in this repository is **elaborated** with slang against the
Accellera UVM source (`make lint`: 0 errors in every lab) and, since October
2026, **simulated** with Verilator 5.052 (`make regress`, and the **sim**
workflow on every push): every lab and every test of `scripts/regress.yaml`
passes -- see [Simulating with Verilator](verilator.md). The course's own
simulator, Cadence Xcelium, has still not run the code; the items below say
what the Verilator runs proved and what only Xcelium can.

## Confirmed by simulation (Verilator)

| # | Item | What the runs show |
|---|---|---|
| 1 | **YAPP handshake under back-pressure** (`in_suspend`): driver holds, DUT accepts exactly once, monitor counts exactly the accepted bytes | `backpressure_test`: `in_suspend` rose 7 times, scoreboard 6 matched, 0 mismatched, nothing unexpected |
| 2 | **Channel handshake**: the receiver's `suspend` vs the FIFO pop | every scoreboard test matches all its packets (Labs 7-11, the project) |
| 3 | **HBUS read timing**: data in the second cycle | every register test reads back what it wrote (`reg_function_test`, `reg_bit_walk_test`, `hbus_protocol_test`) |
| 5 | **`error` pulse** 1..10 cycles after a bad-parity packet | `parity_error_test`: 12 bad packets, 12 pulses, 2..10 cycles after the packet |
| 6 | **Register model backdoor paths** (`hw_top.dut.u_regs.*`) | `reg_access_test` peek/poke through `uvm_hdl_*` (VPI) |
| 7 | **`uvm_reg_hw_reset_seq` on counters** | `uvm_reset_test`: 0 errors |
| 8 | **`uvm_mem_walk_seq`** | `uvm_mem_walk_test`: 0 errors; with `INJECT_ERROR` exactly one, at `yapp_mem[42]` (both builds in the regression) |
| 10 | **Coverage closure** with `coverage_test` | `yapp_pkt_cg` at 100% (Verilator's coverage, see the differences below) |

The first runs also found what slang could not: `set_parity()` left about half
of the "bad parity" packets correct, and an explicit `base_test::build_phase()`
call that Verilator turns into endless recursion -- both fixed.

## Still needs Xcelium

| # | Item | Why Verilator cannot settle it |
|---|---|---|
| 3' | **HBUS tri-state release**: `hdata_w` is `z` between transfers | two-state simulator: `hbus_protocol_test` checks the output enables instead (`` `ifdef VERILATOR ``) |
| 4 | **Reset at time 0**: drivers wait for `reset === 0` | two-state: `reset` starts at 0, not `x`; the tests pass, but the `x` window is not exercised |
| 9 | **UVM 1.1d compatibility** of library calls (`set_drain_time`, `uvm_config_wrapper`, `compare_field_int`, `find() with` on `uvm_reg` queues) | Verilator runs UVM 2020.3.1; compile with `-uvmhome CDNS-1.1d` |
| 10' | **Coverage numbers in IMC** | Verilator's covergroups differ (see [the differences](verilator.md#what-differs-from-xcelium)); the cross is written another way under `` `ifdef VERILATOR `` |
| 11 | **Monitor race margins**: monitors sample on the rising edge while the DUT updates with non-blocking assignments | Verilator's scheduling is not Xcelium's; if values look one cycle off, add `#1step` or clocking blocks |

## Deliberately out of scope

* Cadence `reg_verifier` generation (Lab 11A) — replaced by a hand-written model.
* Verisium Debug steps (Lab 5) — tool specific.
* `hbus_slave_agent` — a placeholder; the router is the only slave.

## How to report

Paste the `UVM Report Summary`, the component reports (scoreboard, monitors,
HBUS) and the seed into an issue, or simply tell the mentor. With Verilator,
`build/sim/<dir>/logs/<test>_s<seed>.log` holds the whole log and
`make sim TEST=<test> SEED=<n> WAVES=1` replays the run with waves.
