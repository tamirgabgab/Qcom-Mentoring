# UVM concept → lab map

| Concept | Lab | Where in the code |
|---|---|---|
| Data items, `do_print` / `do_copy` / `do_compare` / `do_pack`, constraints, `post_randomize` | 1 | `yapp_packet.sv` |
| Components, phases, `run_test`, `+UVM_TESTNAME`, verbosity, topology | 2 | `router_tb.sv`, `router_test_lib.sv`, `top.sv` |
| Driver / sequencer / monitor / agent / env, active vs passive | 3 | `yapp_tx_*.sv`, `yapp_env.sv` |
| Phase ordering (`start_of_simulation`, bottom-up) | 3 opt. | every component of `labs/lab03_uvc/sv` |
| Factory `create`, type overrides | 4 | `short_packet_test` |
| Configuration (`uvm_config_int`, `uvm_config_wrapper`), `check_config_usage` | 3, 4, 7 | `base_test`, `set_config_test`, `router_tb` |
| Sequences, `start_item` / `randomize() with` / `finish_item`, nesting with `seq.start(m_sequencer, this)` | 5 | `yapp_tx_seqs.sv`, `seqs/` |
| Objections, drain time | 5, 6, 8 | `yapp_base_seq`, `base_test::run_phase`, `router_mcseq_base` |
| Randomization debug (SimVision / Verisium) | 5 | `exhaustive_seq_test` with the Lab 4 `short_yapp_packet` |
| Interfaces, virtual interfaces, `uvm_config_db` | 6, 7 | `yapp_if.sv`, `tb_top.sv`, driver/monitor `connect_phase` |
| Transaction recording (`begin_tr`, `recording_detail`) | 4, 6 | `base_test`, `yapp_tx_driver`, `yapp_tx_monitor` |
| Reusing UVCs, connecting several | 7 | `router_tb.sv`, `hw_top.sv`, `tb_top.sv` |
| Virtual / multichannel sequencer, `p_sequencer` | 8 | `router_mcsequencer.sv`, `router_mcseqs_lib.sv` |
| TLM analysis port / imp, `` `uvm_analysis_imp_decl `` | 9A, 9B | `router_scoreboard.sv`, `router_reference.sv` |
| Scoreboard, custom compare, `uvm_comparer` | 9A | `router_scoreboard.sv`, `packet_compare.sv` |
| Reference model, module UVC | 9B | `router_reference.sv`, `router_module_env.sv` |
| TLM exports | 9C | `router_module_env.sv` |
| TLM analysis FIFOs, `get_peek_export` | 9D | `router_fifo_scoreboard.sv` |
| Functional coverage (covergroup, bins, cross) | 10 | `yapp_tx_monitor.sv`, `yapp_coverage_seq` |
| RAL model structure (`uvm_reg`, `uvm_reg_block`, `uvm_mem`, maps) | 11A | `yapp_router_reg_pkg.sv` |
| RAL integration: adapter, `set_sequencer`, auto-predict, built-in sequences | 11B | `hbus_reg_adapter.sv`, `router_tb.sv`, `uvm_reset_test` |
| RAL access: `write` / `read` / `peek` / `poke`, `predict`, check-on-read, introspection | 11C | `reg_*_test` |
