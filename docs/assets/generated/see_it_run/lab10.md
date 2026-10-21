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

=== "test_uvc_integration"

    ```text
    @0 reporter [RNTST] Running test test_uvc_integration...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @0 uvm_test_top.tb.hbus.masters[0].sequencer@@hbus_small_packet_seq [hbus_small_packet_seq] Executing hbus_small_packet_seq (maxpktsize=20, router_en…
    @0 uvm_test_top.tb.yapp.agent.sequencer@@yapp_88_packets_seq [yapp_88_packets_seq] Executing yapp_88_packets_seq sequence
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1000 data=0x14
    @75 uvm_test_top.tb.router_module.reference [router_reference] maxpktsize is now 20
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @95 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x01)
    @415 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=1 (1 matched so far)
    @455 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=2 (2 matched so far)
    @24180 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 20 packets collected
    @24180 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 20 packets collected
    @24180 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 0 reads
    @24180 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 2 accesses sampled, coverage 6.5%
    @24180 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 2 writes to ctrl_reg/en_reg, coverage 63.…
    @24180 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 0 counter reads sampled, coverage 0…
    @24180 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 60
      packets mismatched: 0
    @24180 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 88 packets sent
    ... (7 lines left out)
    @24180 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 88 packets sampled, coverage 70.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (60 more lines of the kinds above)
    ```

=== "coverage_test"

    ```text
    @0 reporter [RNTST] Running test coverage_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @0 uvm_test_top.tb.yapp.agent.sequencer@@yapp_coverage_seq [yapp_coverage_seq] Executing yapp_coverage_seq sequence
    @405 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=1 (1 matched so far)
    @465 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=1 (2 matched so far)
    @17710 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 10 packets collected
    @17710 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 10 packets collected
    @17710 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
    @17710 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 0 accesses sampled, coverage 0.0%
    @17710 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0%
    @17710 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 0 counter reads sampled, coverage 0…
    @17710 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 30
      packets mismatched: 0
    @17710 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 40 packets sent
    @17710 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 39 gaps sampled, coverage 50.0%
    @17710 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 40 packets collected, 20 with bad parity
    @17710 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 40 packets sampled, coverage 100.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (30 more lines of the kinds above)
    ```
