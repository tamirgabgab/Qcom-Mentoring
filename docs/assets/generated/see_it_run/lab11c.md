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

=== "reg_access_test"

    ```text
    @0 reporter [RNTST] Running test reg_access_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1000 data=0x25
    @75 uvm_test_top.tb.router_module.reference [router_reference] maxpktsize is now 37
    @105 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x1a
    @135 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1009 data=0x5a
    @155 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1009 data=0x33
    @350 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @350 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @350 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 2 reads
    @350 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 4 accesses sampled, coverage 10.4%
    @350 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 1 writes to ctrl_reg/en_reg, coverage 43.2%
    @350 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 1 counter reads sampled, coverage 11.…
    @350 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 0
      packets mismatched: 0
    @350 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 0 packets sent
    @350 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 0 gaps sampled, coverage 0.0%
    @350 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 0 packets collected, 0 with bad parity
    @350 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 0 packets sampled, coverage 0.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (2 more lines of the kinds above)
    ```

=== "reg_function_test"

    ```text
    @0 reporter [RNTST] Running test reg_function_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @75 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x01)
    @100 uvm_test_top.tb.yapp.agent.sequencer@@seq [yapp_012_seq] Executing yapp_012_seq sequence
    @105 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1001 data=0x01
    @875 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=42 (1 matched so far)
    @1475 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch1 pkt matched: addr=1 len=59 (2 matched so far)
    @1715 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1009 data=0x00
    @1820 uvm_test_top.tb.yapp.agent.sequencer@@seq [yapp_012_seq] Executing yapp_012_seq sequence
    @1825 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0xff
    @1825 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0xff)
    @5400 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 3 packets collected
    @5400 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 3 packets collected
    @5400 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 11 reads
    @5400 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 13 accesses sampled, coverage 22.1%
    @5400 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 2 writes to ctrl_reg/en_reg, coverage 59.1%
    @5400 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 10 counter reads sampled, coverage 6…
    @5400 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 9
    ... (9 lines left out)
    @5400 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 9 packets sampled, coverage 43.3%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (19 more lines of the kinds above)
    ```

=== "reg_function_check_test"

    ```text
    @0 reporter [RNTST] Running test reg_function_check_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x01
    @75 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x01)
    @100 uvm_test_top.tb.yapp.agent.sequencer@@seq [yapp_012_seq] Executing yapp_012_seq sequence
    @105 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1001 data=0x01
    @875 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch0 pkt matched: addr=0 len=42 (1 matched so far)
    @1475 uvm_test_top.tb.router_module.scoreboard [router_scoreboard] ch1 pkt matched: addr=1 len=59 (2 matched so far)
    @1715 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1009 data=0x00
    @1820 uvm_test_top.tb.yapp.agent.sequencer@@seq [yapp_012_seq] Executing yapp_012_seq sequence
    @1825 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0xff
    @1825 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0xff)
    @5400 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 3 packets collected
    @5400 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 3 packets collected
    @5400 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 2 writes, 11 reads
    @5400 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 13 accesses sampled, coverage 22.1%
    @5400 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 2 writes to ctrl_reg/en_reg, coverage 59.1%
    @5400 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 10 counter reads sampled, coverage 6…
    @5400 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 9
    ... (9 lines left out)
    @5400 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 9 packets sampled, coverage 46.7%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (19 more lines of the kinds above)
    ```

=== "reg_introspection_test"

    ```text
    @0 reporter [RNTST] Running test reg_introspection_test...
    @0 uvm_test_top.tb.chan0.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.chan1.rx_agent.sequencer@@channel_rx_resp_seq [channel_rx_resp_seq] Executing channel_rx_resp_seq (forever)
    @0 uvm_test_top.tb.clk_rst.agent.sequencer@@clk10_rst5_seq [clk10_rst5_seq] Executing clk10_rst5_seq
    @75 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1000 data=0x25
    @75 uvm_test_top.tb.router_module.reference [router_reference] maxpktsize is now 37
    @105 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1000 data=0x1a
    @125 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected WRITE addr=0x1001 data=0x25
    @125 uvm_test_top.tb.router_module.reference [router_reference] router_en is now 1 (en_reg 0x25)
    @155 uvm_test_top.tb.hbus.monitor [hbus_monitor] Collected READ  addr=0x1001 data=0x1a
    @700 uvm_test_top.tb.chan0.rx_agent.monitor [channel_rx_monitor] Channel 0 report: 0 packets collected
    @700 uvm_test_top.tb.chan1.rx_agent.monitor [channel_rx_monitor] Channel 1 report: 0 packets collected
    @700 uvm_test_top.tb.hbus.monitor [hbus_monitor] HBUS report: 9 writes, 9 reads
    @700 uvm_test_top.tb.router_module.hbus_addr_cov [router_hbus_addr_coverage] HBUS address coverage: 18 accesses sampled, coverage 37.7%
    @700 uvm_test_top.tb.router_module.hbus_bits_cov [router_hbus_bits_coverage] HBUS register bits coverage: 2 writes to ctrl_reg/en_reg, coverage 63.6%
    @700 uvm_test_top.tb.router_module.hbus_counter_cov [router_hbus_counter_coverage] HBUS counter value coverage: 6 counter reads sampled, coverage 48.…
    @700 uvm_test_top.tb.router_module.hbus_data_cov [router_hbus_data_coverage] HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0%
    --- Reference model report ---
    --- Scoreboard report ---
      packets matched   : 0
      packets mismatched: 0
    @700 uvm_test_top.tb.yapp.agent.driver [yapp_tx_driver] YAPP driver report: 0 packets sent
    @700 uvm_test_top.tb.yapp.agent.gap_cov [yapp_gap_coverage] YAPP gap coverage: 0 gaps sampled, coverage 0.0%
    @700 uvm_test_top.tb.yapp.agent.monitor [yapp_tx_monitor] YAPP monitor report: 0 packets collected, 0 with bad parity
    @700 uvm_test_top.tb.yapp.agent.pkt_cov [yapp_pkt_coverage] YAPP packet coverage: 0 packets sampled, coverage 0.0%
    UVM_WARNING :    0
    UVM_ERROR :    0
    UVM_FATAL :    0
    ... (16 more lines of the kinds above)
    ```
