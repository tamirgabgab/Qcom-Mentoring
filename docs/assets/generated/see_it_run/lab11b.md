=== "base_test"

    ```text
    @0 reporter [RNTST] Running test base_test...
    @0 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @0 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @0 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
    @0 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 0 accesses sampled, coverage 0.0%
    @0 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0%
    @0 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 0 counter reads sampled, coverage 0.0%
    @0 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 0
      packets mismatched: 0
    @0 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 0 packets sent
    @0 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 0 gaps sampled, coverage 0.0%
    @0 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 0 packets collected, 0 with bad parity
    @0 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 0 packets sampled, coverage 0.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (1 more lines of the kinds above)
    ```

=== "router_simple_mcseq_test"

    ```text
    @0 reporter [RNTST] Running test router_simple_mcseq_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @0 uvm_test_top.tb.mcseqr@@router_simple_mcseq [router_simple_mcseq] Executing router_simple_mcseq sequence
    @0 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_small_seq [hbus_small_packet_seq] Executing hbus_small_packet_seq (maxpktsize=…
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1000 data=0x14
    @75 uvm_test_top.tb.router_module.reference [router_reference] maxpktsize is now 20
    @90 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @95 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x01)
    @120 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 20
    @120 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @125 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x14
    @465 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=1 (1 matched so far)
    @765 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch1 pkt matched: addr=1 len=14 (2 matched so far)
    @900 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @1700 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_large_seq [hbus_large_packet_seq] Executing hbus_large_packet_seq (maxpktsi…
    @1725 uvm_test_top.tb.router_module.reference [router_reference] maxpktsize is now 63
    @1740 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @1745 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x01)
    @1770 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 63
    @1770 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_rnd [yapp_rnd_seq] Executing yapp_rnd_seq sequence (6 packets)
    @1775 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x3f
    ... (19 lines left out)
    @3140 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 12 packets sampled, coverage 46.7%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (13 more lines of the kinds above)
    ```

=== "uvm_reset_test"

    ```text
    @0 reporter [RNTST] Running test uvm_reset_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @85 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x3f
    @115 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1001 data=0x01
    @520 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @520 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @520 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 9 reads
    @520 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 9 accesses sampled, coverage 24.7%
    @520 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0%
    @520 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 6 counter reads sampled, coverage 48.…
    @520 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 0
      packets mismatched: 0
    @520 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 0 packets sent
    @520 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 0 gaps sampled, coverage 0.0%
    @520 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 0 packets collected, 0 with bad parity
    @520 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 0 packets sampled, coverage 0.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (9 more lines of the kinds above)
    ```

=== "uvm_mem_walk_test"

    ```text
    @0 reporter [RNTST] Running test uvm_mem_walk_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1100 data=0xff
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1101 data=0xfe
    @125 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1100 data=0xff
    @195 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1101 data=0xfe
    @18150 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @18150 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @18150 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 511 writes, 256 reads
    @18150 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 767 accesses sampled, coverage 14.3%
    @18150 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0%
    @18150 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 0 counter reads sampled, coverage 0…
    @18150 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 767 accesses sampled, coverage 100.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 0
      packets mismatched: 0
    @18150 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 0 packets sent
    @18150 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 0 gaps sampled, coverage 0.0%
    @18150 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 0 packets collected, 0 with bad parity
    @18150 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 0 packets sampled, coverage 0.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (765 more lines of the kinds above)
    ```
