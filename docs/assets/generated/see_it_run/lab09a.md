=== "base_test"

    ```text
    @0 reporter [RNTST] Running test base_test...
    @0 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @0 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @0 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
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

=== "simple_test"

    ```text
    @0 reporter [RNTST] Running test simple_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @0 uvm_test_top.tb.yapp.agent.sequencer@@yapp_012_seq [yapp_012_seq] Executing yapp_012_seq sequence
    @355 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 0 packet matched
    @675 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 1 packet matched
    @1140 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 1 packets collected
    @1140 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 1 packets collected
    @1140 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
    --- Scoreboard report ---
      packets matched   : 3
      packets mismatched: 0
    @1140 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 3 packets sent
    @1140 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 2 gaps sampled, coverage 25.0%
    @1140 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 3 packets collected, 1 with bad parity
    @1140 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 3 packets sampled, coverage 40.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (3 more lines of the kinds above)
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
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @415 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 0 packet matched
    @455 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 0 packet matched
    @24180 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 20 packets collected
    @24180 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 20 packets collected
    @24180 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 0 reads
    --- Scoreboard report ---
      packets matched   : 60
      packets mismatched: 0
    @24180 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 88 packets sent
    @24180 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 87 gaps sampled, coverage 75.0%
    @24180 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 88 packets collected, 49 with bad parity
    @24180 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 88 packets sampled, coverage 70.0%
    UVM_WARNING :   22
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (60 more lines of the kinds above)
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
    @90 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @120 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 20
    @120 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @125 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x14
    @465 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 0 packet matched
    @765 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 1 packet matched
    @900 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @1700 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_large_seq [hbus_large_packet_seq] Executing hbus_large_packet_seq (maxpktsi…
    @1740 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @1770 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 63
    @1770 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_rnd [yapp_rnd_seq] Executing yapp_rnd_seq sequence (6 packets)
    @1775 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x3f
    @3140 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 2 packets collected
    @3140 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 2 packets collected
    @3140 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 4 writes, 2 reads
    --- Scoreboard report ---
    ... (10 lines left out)
    @3140 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 12 packets sampled, coverage 46.7%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (13 more lines of the kinds above)
    ```

=== "scoreboard_drop_test"

    ```text
    @0 reporter [RNTST] Running test scoreboard_drop_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @0 uvm_test_top.tb.mcseqr@@router_simple_mcseq [router_simple_mcseq] Executing router_simple_mcseq sequence
    @0 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_small_seq [hbus_small_packet_seq] Executing hbus_small_packet_seq (maxpktsize=…
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1000 data=0x14
    @90 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @95 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @120 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 20
    @120 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @125 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x14
    @1125 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 1 packet matched
    @1380 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_012 [yapp_012_seq] Executing yapp_012_seq sequence
    @1555 uvm_test_top.tb.scoreboard [router_scoreboard] Channel 2 packet matched
    @2750 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_large_seq [hbus_large_packet_seq] Executing hbus_large_packet_seq (maxpktsi…
    @2790 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] Executing hbus_read_max_pkt_seq
    @2820 uvm_test_top.tb.hbus.masters[0].sequencer@@router_simple_mcseq.hbus_read_seq [hbus_read_max_pkt_seq] MAXPKTSIZE register reads 63
    @2820 uvm_test_top.tb.yapp.agent.sequencer@@router_simple_mcseq.yapp_rnd [yapp_rnd_seq] Executing yapp_rnd_seq sequence (6 packets)
    @2825 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x3f
    ERROR @4065 uvm_test_top.tb.scoreboard [PKT_COMPARE] Length mismatch: YAPP 26, Channel 12
    ERROR @4065 uvm_test_top.tb.scoreboard [PKT_COMPARE] Payload[0] mismatch: YAPP 0x3a, Channel 0x42
    ERROR @4065 uvm_test_top.tb.scoreboard [PKT_COMPARE] Payload[1] mismatch: YAPP 0x12, Channel 0x0f
    ERROR @4065 uvm_test_top.tb.scoreboard [PKT_COMPARE] Parity mismatch: YAPP 0x28, Channel 0x55
    ... (30 lines left out)
    @5730 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 12 packets sampled, coverage 46.7%
    UVM_WARNING :    0
    UVM_ERROR :   49
    UVM_FATAL :    0
    ... (49 more lines of the kinds above)
    ```
