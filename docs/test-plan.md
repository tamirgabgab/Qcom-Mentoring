# Test plan

A verification plan links every **feature** of the DUT to the **stimulus** that
exercises it, the **checker** that judges it and the **coverage** that proves it
happened. This is the plan the labs implement, plus the dedicated DUT tests
that go beyond the course.

## Stimulus / check / cover matrix

| # | Feature | Stimulus (test → sequence) | Checker | Coverage |
|---|---|---|---|---|
| F1 | packet routed to channel `addr` | `simple_test` → `yapp_012_seq`; `router_simple_mcseq_test` | channel monitor address check; scoreboard compare | `addr_cp.legal` |
| F2 | payload and parity delivered unchanged | every scoreboard test | `comp_equal()` per byte | `length_cp` |
| F3 | all payload lengths 1..63 | `coverage_test` → `yapp_coverage_seq`; `scoreboard_drop_test` (random lengths) | scoreboard | `length_cp` bins MIN..MAX |
| F4 | back-pressure: `in_suspend` when a FIFO is full | long packets with slow receivers (`channel_rx_resp_seq` random delay, lengths > 16) | driver holds data; monitor counts only accepted bytes; scoreboard | — (see [unverified](appendix/unverified.md)) |
| F5 | receiver flow control (`suspend_x`) | `channel_rx_resp_seq` random response delay | scoreboard (bytes in order) | — |
| F6 | drop when `length > maxpktsize` | `scoreboard_drop_test` (random lengths, maxpktsize 20); `test_uvc_integration` | reference model drops; `ROUTER DROPS PACKET` in log; scoreboard sees no mismatch (9B) | — |
| F7 | drop when `router_en = 0` | `hbus_router_disable_seq` + any YAPP sequence (write your own test) | reference model | — |
| F8 | drop for address 3 | `test_uvc_integration`, `coverage_test` | reference model; `addr3_cnt_reg` | `addr_cp.illegal_addr` |
| F9 | parity error detection: `error` pulse 1..10 cycles later | 20% bad parity in `yapp_88_packets_seq`; `yapp_coverage_seq` | `parity_err_cnt_reg` (`reg_function_test`); waveform | `parity_cp`, REQ3 cross |
| F10 | counters and enable bits | `reg_function_test` | RAL reads vs expected | — |
| F11 | register access policies (RW / RO) | `reg_access_test`, `reg_introspection_test` | front/backdoor cross-checks | — |
| F12 | reset values | `uvm_reset_test` | `uvm_reg_hw_reset_seq` | — |
| F13 | scratch memory | `uvm_mem_walk_test` (+ `INJECT_ERROR`) | `uvm_mem_walk_seq` | — |
| F14 | HBUS protocol (1-cycle write, 2-cycle read, tri-state) | every HBUS sequence | `hbus_monitor` decodes and the read-back values match | — |
| F15 | `yapp_pkt_mem` / `mem_size_reg` hold the last packet | *(not covered by the course tests)* — suggested: send one packet, read `mem_size_reg` and `yapp_pkt_mem[0..len+1]` through the model | — | — |

## Tests by lab

| Test | Lab | Sequences | What proves it passed |
|---|---|---|---|
| `base_test` | 2+ | none | topology print; `UVM_ERROR : 0` |
| `test2` | 2 | none | `Running test test2` |
| `short_packet_test` | 4 | `yapp_5_packets` as `short_yapp_packet` | five printed packets, `length < 15` |
| `set_config_test` | 4 | none | no driver / sequencer in the topology; no config-usage report |
| `incr_payload_test` | 5 | `yapp_incr_payload_seq` | payload `0 1 2 …` |
| `exhaustive_seq_test` | 5 | `yapp_exhaustive_seq` | one message per sequence, no randomization failures |
| `yapp_012_test` | 6 | `yapp_012_seq` | packets on `dut.data_0/1/2` in that order |
| `simple_test` | 7 | `yapp_012_seq`, channel resp, clk10_rst5 | 3 YAPP packets, 1 per channel monitor |
| `test_uvc_integration` | 7 opt. | `yapp_88_packets_seq`, `hbus_small_packet_seq` | `error` pulses; `ROUTER DROPS PACKET` for len > 20 and addr 3 |
| `router_simple_mcseq_test` | 8 | `router_simple_mcseq` | HBUS writes/reads + 12 packets in the log; scoreboard 12/12 (9A+) |
| `scoreboard_drop_test` | 9A | same, no override | mismatches + packets left (9A); 0 mismatches with reference model (9B) |
| `coverage_test` | 10 | `yapp_coverage_seq` | 100% on `yapp_pkt_cg` |
| `uvm_reset_test` | 11B | `uvm_reg_hw_reset_seq` | reads of all registers, 0 errors |
| `uvm_mem_walk_test` | 11B | `uvm_mem_walk_seq` | 511 writes, 255 reads; error with `INJECT_ERROR` |
| `reg_access_test` | 11C | — | logged accesses at `UVM_NONE`, 0 errors |
| `reg_function_test` | 11C | `yapp_012_seq` ×3 | counters 0 then 2/2/2/0, parity count matches |
| `reg_function_check_test` | 11C opt. | same, check-on-read + `predict` | 0 errors |
| `reg_introspection_test` | 11C opt. | — | RW/RO lists; 0 errors |

## Writing a new test — checklist

1. Extend `base_test`; add `` `uvm_component_utils `` and the constructor.
2. Decide the packet type: factory override in `build_phase` *before*
   `super.build_phase(phase)`.
3. `configure_sequences()`: which sequencer runs what. Always
   `set_clock_and_channel_sequences()` in Labs 7+.
4. For register tests: get handles in `connect_phase`, raise an objection in
   `run_phase`, use the model API.
5. Decide what *passes*: `UVM_ERROR : 0` plus the counts in the reports.
