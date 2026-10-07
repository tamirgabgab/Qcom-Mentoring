# Known-unverified items

Everything in this repository was **elaborated** with slang against the
Accellera UVM source (`make lint`: 0 errors in every lab) but has **not been
simulated** — no simulator was available where it was written. The code was
written carefully against the specification, but the items below can only be
proven by a run on Xcelium. Please report what you see.

## Needs a simulation to confirm

| # | Item | What to look at |
|---|---|---|
| 1 | **YAPP handshake under back-pressure** (`in_suspend`): driver holds, DUT accepts exactly once, monitor counts exactly the accepted bytes | `scoreboard_drop_test` or `coverage_test` with long packets and slow channels (`channel_rx_resp_seq` delays): scoreboard 0 mismatches, no `unexpected` packets |
| 2 | **Channel handshake**: the receiver's `suspend` timing vs the FIFO pop | channel monitor collects exactly `length + 2` bytes; address check never fires |
| 3 | **HBUS read timing**: data sampled in the second cycle, tri-state release | `hbus_read_max_pkt_seq` reports 20 then 63; no `x`/`z` on `hdata_w` during reads |
| 4 | **Reset sequencing at time 0**: `clk10_rst5_seq` asserts reset before any driver starts | first HBUS/YAPP activity after reset release; no packets lost at the start |
| 5 | **`error` pulse** 1..10 cycles after a bad-parity packet | waveform in `test_uvc_integration` |
| 6 | **Register model backdoor paths** (`hw_top.dut.<reg>`, `hw_top.dut.yapp_mem[i]`) | `reg_access_test` peek/poke values; requires `-access +rwc` |
| 7 | **`uvm_reg_hw_reset_seq` on counters**: counters are not `volatile` in the model, so they are compared with 0 right after reset | `uvm_reset_test`: 0 errors |
| 8 | **`uvm_mem_walk_seq` counts**: 511 writes / 255 reads; `INJECT_ERROR` detected | `uvm_mem_walk_test` HBUS report |
| 9 | **UVM 1.1d compatibility** of library calls (`get_objection().set_drain_time`, `uvm_config_wrapper`, `uvm_comparer::compare_field_int`, `find() with` on queues of `uvm_reg`) | compile with `-uvmhome CDNS-1.1d` |
| 10 | **Coverage closure** with `coverage_test` | IMC: 100% on `yapp_pkt_cg` |
| 11 | Monitor race margins: monitors sample on the rising edge while the DUT updates with non-blocking assignments on the same edge | if values look one cycle off, add `#1step` or use clocking blocks in the interfaces |

## Deliberately out of scope

* Cadence `reg_verifier` generation (Lab 11A) — replaced by a hand-written model.
* Verisium Debug steps (Lab 5) — tool specific.
* `hbus_slave_agent` — a placeholder; the router is the only slave.

## How to report

Paste the `UVM Report Summary`, the component reports (scoreboard, monitors,
HBUS) and the seed into an issue, or simply tell the mentor. Fixes should be
small: the architecture is in place.
