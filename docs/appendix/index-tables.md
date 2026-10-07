# Files, classes, tests and sequences

## Files and classes

| File | Class / module | Base | Lab | Location |
|---|---|---|---|---|
| `yapp_packet.sv` | `yapp_packet`, `parity_type_e` | `uvm_sequence_item` | 1 | `yapp/sv` |
| `short_yapp_packet.sv` | `short_yapp_packet` | `yapp_packet` | 4 | `yapp/sv` |
| `yapp_pkg.sv` | `yapp_pkg` (+ `yapp_vif_config`) | package | 1, 6 | `yapp/sv` |
| `yapp_tx_driver.sv` | `yapp_tx_driver` | `uvm_driver #(yapp_packet)` | 3, 6 | `yapp/sv` |
| `yapp_tx_sequencer.sv` | `yapp_tx_sequencer` | `uvm_sequencer #(yapp_packet)` | 3 | `yapp/sv` |
| `yapp_tx_monitor.sv` | `yapp_tx_monitor` | `uvm_monitor` | 3, 6, 9A, 10 | `yapp/sv` |
| `yapp_tx_agent.sv` | `yapp_tx_agent` | `uvm_agent` | 3 | `yapp/sv` |
| `yapp_env.sv` | `yapp_env` | `uvm_env` | 3 | `yapp/sv` |
| `yapp_tx_seqs.sv` → `seqs/<class>.sv` | `yapp_base_seq`, `yapp_5_packets`, … (one class per file) | `uvm_sequence #(yapp_packet)` | 3, 5, 7, 10 | `yapp/sv` |
| `yapp_if.sv` | `yapp_if` | interface | 6 | `yapp/sv` |
| `top.sv` → `tb_top.sv` | `top` → `tb_top` | module | 1, 6 | `labs/*/tb` |
| `hw_top.sv` | `hw_top` | module | 6, 7 | `labs/*/tb` |
| `clkgen.sv` | `clkgen` | module | 6 | `clock_and_reset/sv` |
| `router_tb.sv` | `router_tb` | `uvm_env` | 2 → 11B | `labs/*/tb` |
| `router_test_lib.sv` → `tests/<class>.sv` | all tests, one class per file | `uvm_test` | 2 → 11C | `labs/*/tb` |
| `router_mcsequencer.sv` | `router_mcsequencer` | `uvm_sequencer` | 8 | `labs/lab08_mcseq/tb` |
| `router_mcseqs_lib.sv` → `mcseqs/<class>.sv` | `router_mcseq_base`, `router_simple_mcseq` | `uvm_sequence` | 8 | `labs/lab08_mcseq/tb` |
| `router_scoreboard.sv` | `router_scoreboard` | `uvm_scoreboard` | 9A | `router/sv` |
| `packet_compare.sv` | `comp_equal()`, `comp_equal_uvm()` | — | 9A | `router/sv` |
| `router_reference.sv` | `router_reference` | `uvm_component` | 9B | `router/sv` |
| `router_module_env.sv` | `router_module_env` | `uvm_env` | 9B, 9C | `router/sv` |
| `router_module_pkg.sv` | `router_module_pkg` | package | 9B | `router/sv` |
| `router_fifo_scoreboard.sv` | `router_fifo_scoreboard` | `uvm_scoreboard` | 9D | `router/sv` |
| `yapp_router_reg_pkg.sv` → `reg/<class>.sv` | `yapp_router_regs_t`, `yapp_regs_c`, `*_c` | `uvm_reg_block`, `uvm_reg`, `uvm_mem` | 11A | `labs/lab11a_rm_gen` |
| `hbus_*.sv` | `hbus_transaction`, `hbus_master_driver/sequencer/agent`, `hbus_monitor`, `hbus_env`, `hbus_reg_adapter`, `hbus_if` | | provided (7) | `hbus/sv` |
| `channel_*.sv` | `channel_packet`, `channel_rx_driver/sequencer/monitor/agent`, `channel_env`, `channel_if` | | provided (7) | `channel/sv` |
| `clock_and_reset_*.sv` | `clock_and_reset_transaction/driver/sequencer/agent/env`, `clock_and_reset_if` | | provided (7) | `clock_and_reset/sv` |
| `yapp_router.sv` | `yapp_router`, `yapp_fifo` | module | DUT | `router_rtl` |

## Tests

| Test | Lab | Configuration |
|---|---|---|
| `base_test` | 2 | builds `router_tb`, prints the topology; later: `recording_detail` + `configure_sequences()` + `check_config_usage` (4), drain time (6), `set_clock_and_channel_sequences()` (7) |
| `test2` | 2 | extends `base_test`, nothing else |
| `short_packet_test` | 4 | override `yapp_packet` → `short_yapp_packet` |
| `set_config_test` | 4 | YAPP agent `is_active = UVM_PASSIVE`, no default sequence |
| `incr_payload_test` | 5 | `yapp_incr_payload_seq` + short override |
| `exhaustive_seq_test` | 5 | `yapp_exhaustive_seq` + short override |
| `yapp_012_test` | 6 | `yapp_012_seq` |
| `simple_test` | 7 | short override; `yapp_012_seq`; channels `channel_rx_resp_seq`; clock `clk10_rst5_seq` |
| `test_uvc_integration` | 7 opt. | `yapp_88_packets_seq` + HBUS `hbus_small_packet_seq` |
| `router_simple_mcseq_test` | 8 | short override; `router_simple_mcseq` on `tb.mcseqr` |
| `scoreboard_drop_test` | 9A | as above without the override |
| `coverage_test` | 10 | `yapp_coverage_seq` |
| `uvm_reset_test` | 11B | `uvm_reg_hw_reset_seq` on `tb.yapp_rm` |
| `uvm_mem_walk_test` | 11B opt. | `uvm_mem_walk_seq` |
| `reg_access_test` | 11C | RW / RO access checks |
| `reg_function_test` | 11C | enable bits + `yapp_012_seq` + counter checks |
| `reg_function_check_test` | 11C opt. | check-on-read with `predict` |
| `reg_introspection_test` | 11C opt. | RW / RO queues from the model |

## Sequences

| Sequence | Owner | Lab |
|---|---|---|
| `yapp_base_seq`, `yapp_5_packets` | YAPP (provided in the course) | 3 |
| `yapp_1_seq`, `yapp_012_seq`, `yapp_111_seq`, `yapp_repeat_addr_seq`, `yapp_incr_payload_seq`, `yapp_exhaustive_seq` | YAPP | 5 |
| `yapp_rnd_seq`, `six_yapp_seq` | YAPP (optional) | 5 |
| `yapp_88_packets_seq` | YAPP (optional) | 7 |
| `yapp_coverage_seq` | YAPP | 10 |
| `channel_rx_resp_seq`, `channel_rx_fast_seq` | Channel | 7 |
| `clk10_rst5_seq`, `clk_rst_rand_seq` | Clock & Reset | 7 |
| `hbus_write_seq`, `hbus_read_seq`, `hbus_set_default_regs_seq`, `hbus_small_packet_seq`, `hbus_large_packet_seq`, `hbus_read_max_pkt_seq`, `hbus_router_disable_seq`, `hbus_router_enable_seq` | HBUS | 7–9 |
| `router_simple_mcseq` | testbench | 8 |
| `uvm_reg_hw_reset_seq`, `uvm_mem_walk_seq` | UVM library | 11B |
