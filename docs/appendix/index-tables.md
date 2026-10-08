# Files, classes, tests and sequences

## Files and classes

| File | Class / module | Base | Lab | Location |
|---|---|---|---|---|
| `yapp_packet.sv` | `yapp_packet`, `parity_type_e` | `uvm_sequence_item` | 1 | `yapp_project/uvc/yapp` |
| `short_yapp_packet.sv` | `short_yapp_packet` | `yapp_packet` | 4 | `yapp_project/uvc/yapp` |
| `yapp_pkg.sv` | `yapp_pkg` (+ `yapp_vif_config`) | package | 1, 6 | `yapp_project/uvc/yapp` |
| `yapp_tx_driver.sv` | `yapp_tx_driver` | `uvm_driver #(yapp_packet)` | 3, 6 | `yapp_project/uvc/yapp` |
| `yapp_tx_sequencer.sv` | `yapp_tx_sequencer` | `uvm_sequencer #(yapp_packet)` | 3 | `yapp_project/uvc/yapp` |
| `yapp_tx_monitor.sv` | `yapp_tx_monitor` | `uvm_monitor` | 3, 6, 9A, 10 | `yapp_project/uvc/yapp` |
| `yapp_tx_agent.sv` | `yapp_tx_agent` | `uvm_agent` | 3 | `yapp_project/uvc/yapp` |
| `yapp_env.sv` | `yapp_env` | `uvm_env` | 3 | `yapp_project/uvc/yapp` |
| `yapp_tx_seqs.sv` → `seqs/<class>.sv` | `yapp_base_seq`, `yapp_5_packets`, … (one class per file) | `uvm_sequence #(yapp_packet)` | 3, 5, 7, 10 | `yapp_project/uvc/yapp` |
| `yapp_if.sv` | `yapp_if` | interface | 6 | `yapp_project/uvc/yapp` |
| `top.sv` → `tb_top.sv` | `top` → `tb_top` | module | 1, 6 | `labs/*/tb` |
| `hw_top.sv` | `hw_top` | module | 6, 7 | `labs/*/tb` |
| `clkgen.sv` | `clkgen` | module | 6 | `yapp_project/uvc/clock_and_reset` |
| `router_tb.sv` | `router_tb` | `uvm_env` | 2 → 11B | `labs/*/tb` |
| `router_test_lib.sv` → `tests/<class>.sv` | all tests, one class per file | `uvm_test` | 2 → 11C | `labs/*/tb` |
| `router_mcsequencer.sv` | `router_mcsequencer` | `uvm_sequencer` | 8 | `labs/lab08_mcseq/tb` |
| `router_mcseqs_lib.sv` → `mcseqs/<class>.sv` | `router_mcseq_base`, `router_simple_mcseq` | `uvm_sequence` | 8 | `labs/lab08_mcseq/tb` |
| `router_scoreboard.sv` | `router_scoreboard` | `uvm_scoreboard` | 9A | `yapp_project/uvc/router` |
| `packet_compare.sv` | `comp_equal()`, `comp_equal_uvm()` | — | 9A | `yapp_project/uvc/router` |
| `router_reference.sv` | `router_reference` | `uvm_component` | 9B | `yapp_project/uvc/router` |
| `router_module_env.sv` | `router_module_env` | `uvm_env` | 9B, 9C | `yapp_project/uvc/router` |
| `router_module_pkg.sv` | `router_module_pkg` | package | 9B | `yapp_project/uvc/router` |
| `router_fifo_scoreboard.sv` | `router_fifo_scoreboard` | `uvm_scoreboard` | 9D | `yapp_project/uvc/router` |
| `yapp_router_reg_pkg.sv` → `reg/<class>.sv` | `yapp_router_regs_t`, `yapp_regs_c`, `*_c` | `uvm_reg_block`, `uvm_reg`, `uvm_mem` | 11A | `labs/lab11a_rm_gen` |
| `hbus_*.sv` | `hbus_transaction`, `hbus_master_driver/sequencer/agent`, `hbus_monitor`, `hbus_env`, `hbus_reg_adapter`, `hbus_if` | | provided (7) | `yapp_project/uvc/hbus` |
| `channel_*.sv` | `channel_packet`, `channel_rx_driver/sequencer/monitor/agent`, `channel_env`, `channel_if` | | provided (7) | `yapp_project/uvc/channel` |
| `clock_and_reset_*.sv` | `clock_and_reset_transaction/driver/sequencer/agent/env`, `clock_and_reset_if` | | provided (7) | `yapp_project/uvc/clock_and_reset` |
| `yapp_router.sv` | `yapp_router` (top level, wiring only; instances `u_input_fsm`, `g_ch[0..2].u_ch`, `u_regs`, `u_error_timer`) | module | DUT | `yapp_project/rtl` |
| `yapp_input_fsm.sv` | `yapp_input_fsm` | module | DUT | `yapp_project/rtl` |
| `yapp_output_channel.sv` | `yapp_output_channel` (contains `u_fifo`) | module | DUT | `yapp_project/rtl` |
| `yapp_fifo.sv` | `yapp_fifo` | module | DUT | `yapp_project/rtl` |
| `yapp_hbus_regs.sv` | `yapp_hbus_regs` (every register and memory, the HBUS slave; backdoor root `hw_top.dut.u_regs`) | module | DUT | `yapp_project/rtl` |
| `yapp_error_timer.sv` | `yapp_error_timer` | module | DUT | `yapp_project/rtl` |
| `yapp_router.f` | file list of the six RTL files, `-F ../rtl/yapp_router.f` in every `run.f` | — | DUT | `yapp_project/rtl` |

The table lists the labs' `tb/` directories; the final testbench with every test, the
multichannel sequences and the register model is `yapp_project/tb/` (`tests/`, `mcseqs/`, `reg/`).

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
| `router_disable_test` | test plan | `router_en = 0`: nothing delivered, counted or stored; traffic resumes |
| `router_filter_test` | test plan | `yapp_boundary_seq` around `maxpktsize`, address 3, every counter on and off |
| `pkt_mem_test` | test plan | `yapp_pkt_mem` + `mem_size_reg` hold the last packet, read-only, even when dropped |
| `reg_bit_walk_test` | test plan | walking ones / zeros through the RW registers, RO writes ignored |
| `hbus_protocol_test` | test plan | raw HBUS cycles: write, read, tri-state, unmapped and RO addresses |
| `backpressure_test` | test plan | `channel_rx_slow_seq` + 40..63-byte packets: `in_suspend`, no byte lost |
| `parity_error_test` | test plan | bad parity: counter, `error` pulse timing (`error_pulse_checker`), packet delivered |

## Sequences

| Sequence | Owner | Lab |
|---|---|---|
| `yapp_base_seq`, `yapp_5_packets` | YAPP (provided in the course) | 3 |
| `yapp_1_seq`, `yapp_012_seq`, `yapp_111_seq`, `yapp_repeat_addr_seq`, `yapp_incr_payload_seq`, `yapp_exhaustive_seq` | YAPP | 5 |
| `yapp_rnd_seq`, `six_yapp_seq` | YAPP (optional) | 5 |
| `yapp_88_packets_seq` | YAPP (optional) | 7 |
| `yapp_coverage_seq` | YAPP | 10 |
| `yapp_pkt_seq`, `yapp_boundary_seq` | YAPP (test plan) | — |
| `channel_rx_resp_seq`, `channel_rx_fast_seq` | Channel | 7 |
| `channel_rx_slow_seq` | Channel (test plan) | — |
| `clk10_rst5_seq`, `clk_rst_rand_seq` | Clock & Reset | 7 |
| `hbus_write_seq`, `hbus_read_seq`, `hbus_set_default_regs_seq`, `hbus_small_packet_seq`, `hbus_large_packet_seq`, `hbus_read_max_pkt_seq`, `hbus_router_disable_seq`, `hbus_router_enable_seq` | HBUS | 7–9 |
| `router_simple_mcseq` | testbench | 8 |
| `uvm_reg_hw_reset_seq`, `uvm_mem_walk_seq` | UVM library | 11B |
