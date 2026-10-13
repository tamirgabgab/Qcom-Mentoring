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
| `yapp_pkt_coverage.sv`, `yapp_gap_coverage.sv` | `yapp_pkt_coverage` (`yapp_pkt_cg`), `yapp_gap_coverage` (`yapp_gap_cg`) | `uvm_subscriber #(yapp_packet)` | 10, test plan | `yapp_project/uvc/yapp` |
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
| `router_mcseqs_lib.sv` → `mcseqs/<class>.sv` | `router_mcseq_base`, `router_simple_mcseq`; `router_random_mcseq`, `router_hbus_sweep_mcseq` (test plan) | `uvm_sequence` | 8, test plan | `labs/lab08_mcseq/tb`, `yapp_project/tb` |
| `tests/error_pulse_checker.sv` | `error_pulse_checker` (one `error` pulse per bad packet, 1..10 cycles) | `uvm_subscriber #(yapp_packet)` | test plan | `yapp_project/tb` |
| `yapp_router_tracer.sv` | `yapp_router_tracer` (+ `yapp_router_tracer_bind`): `[DUT]` log lines and the per-cycle signal trace, bound into the router | module | test plan | `yapp_project/tb` |
| `router_scoreboard.sv` | `router_scoreboard` | `uvm_scoreboard` | 9A | `yapp_project/uvc/router` |
| `packet_compare.sv` | `comp_equal()`, `comp_equal_uvm()` | — | 9A | `yapp_project/uvc/router` |
| `router_reference.sv` | `router_reference` (full model of the registers, counters and memories; checks every HBUS read) | `uvm_component` | 9B, test plan | `yapp_project/uvc/router` |
| `router_decision.sv` | `router_decision`, `router_reason_e` (what the reference decided about a packet, published on `decision_out`) | `uvm_object` | test plan | `yapp_project/uvc/router` |
| `router_coverage.sv` | `router_coverage` (`router_cfg_cg`: the configuration each packet met) | `uvm_subscriber #(router_decision)` | test plan | `yapp_project/uvc/router` |
| `router_hbus_addr_coverage.sv`, `router_hbus_bits_coverage.sv`, `router_hbus_data_coverage.sv`, `router_hbus_counter_coverage.sv` | `router_hbus_*_coverage` (`hbus_addr_cg`, `hbus_bits_cg`, `hbus_data_cg`, `hbus_counter_cg`) | `uvm_subscriber #(hbus_transaction)` | test plan | `yapp_project/uvc/router` |
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

Every test class of the project and the labs, in course order (the test-plan tests last), with
the purpose of its plan. The table is generated from the model by `make map`; the full plan of
each test (stages, expected result, the items it verifies) is on the [test plan](../test-plan.md)
page and in the **Test plan** view of the [project map](../project-map.md); its runs are in the
[regression results](../regression/index.md).

--8<-- "docs/assets/generated/index_tests.md"

## Sequences

Every sequence class, by package, with the sequencer it runs on. Generated from the model by
`make map`.

--8<-- "docs/assets/generated/index_sequences.md"
