=== "base_test"

    ```text
    @0 reporter [RNTST] Running test base_test...
    @0 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @0 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @0 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
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
    @1140 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 1 packets collected
    @1140 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 1 packets collected
    @1140 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 0 writes, 0 reads
    @1140 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 3 packets sent
    @1140 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 2 gaps sampled, coverage 25.0%
    @1140 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 3 packets collected, 1 with bad parity
    @1140 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 3 packets sampled, coverage 40.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (2 more lines of the kinds above)
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
    @24180 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 20 packets collected
    @24180 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 20 packets collected
    @24180 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 0 reads
    @24180 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 88 packets sent
    @24180 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 87 gaps sampled, coverage 75.0%
    @24180 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 88 packets collected, 49 with bad parity
    @24180 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 88 packets sampled, coverage 70.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (2 more lines of the kinds above)
    ```
