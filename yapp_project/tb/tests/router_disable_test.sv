//------------------------------------------------------------------------------
// router_disable_test.sv -- router_disable_test (test plan: DROP-02, CNT-02)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_disable_test: router_en = 0 makes the router deaf.
//   1. en_reg = 0xfe (router off, every counter on); yapp_012_seq
//      -> no packet reaches a channel, the reference model reports 3 packets
//         dropped (router disabled), no counter moves, mem_size_reg stays 0
//   2. en_reg = 0xff; yapp_012_seq
//      -> one packet per channel again, the address counters read 1
//------------------------------------------------------------------------------
class router_disable_test extends reg_function_test;

  `uvm_component_utils(router_disable_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

  // Packets collected by the three channel monitors so far
  extern function int channel_packets();

  // Wait (bounded) until the channel monitors have collected `expected` packets
  extern task wait_channels(int expected);

endclass : router_disable_test

//------------------------------------------------------------------------------
// router_disable_test -- method implementations
//------------------------------------------------------------------------------

function router_disable_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task router_disable_test::access_checks();
  uvm_status_e status;
  int chan_before;
  int dropped_before;

  // 1. router disabled, every counter enabled
  regs.en_reg.write(status, 8'hfe);
  chan_before    = channel_packets();
  dropped_before = tb.router_module.reference.dropped_disabled;
  seq.start(yapp_seqr);                     // 3 packets into a deaf router
  wait_channels(chan_before + 3);           // give a wrong router time to deliver them
  if (channel_packets() != chan_before) begin
    `uvm_error("ROUTER_DIS", $sformatf("%0d packet(s) reached a channel while router_en = 0",
                                       channel_packets() - chan_before))
  end else begin
    `uvm_info("ROUTER_DIS", "router_en = 0: no packet reached a channel", UVM_NONE)
  end
  if (tb.router_module.reference.dropped_disabled != dropped_before + 3) begin
    `uvm_error("ROUTER_DIS", "the reference model did not report 3 packets dropped (router disabled)")
  end
  check_counter(regs.addr0_cnt_reg, 0);     // a disabled router counts nothing ...
  check_counter(regs.addr1_cnt_reg, 0);
  check_counter(regs.addr2_cnt_reg, 0);
  check_counter(regs.addr3_cnt_reg, 0);
  check_counter(regs.parity_err_cnt_reg, 0);
  check_counter(regs.oversized_pkt_cnt_reg, 0);
  check_counter(regs.mem_size_reg, 0);      // ... and stores nothing

  // 2. router enabled again: traffic and counters resume
  regs.en_reg.write(status, 8'hff);
  chan_before = channel_packets();
  seq.start(yapp_seqr);
  wait_channels(chan_before + 3);
  if (channel_packets() != chan_before + 3) begin
    `uvm_error("ROUTER_DIS", $sformatf("expected 3 packets on the channels after re-enabling, got %0d",
                                       channel_packets() - chan_before))
  end
  check_counter(regs.addr0_cnt_reg, 1);
  check_counter(regs.addr1_cnt_reg, 1);
  check_counter(regs.addr2_cnt_reg, 1);
  check_counter(regs.addr3_cnt_reg, 0);
endtask : access_checks

//------------------------------------------------------------------------------
function int router_disable_test::channel_packets();
  return tb.chan0.rx_agent.monitor.num_pkt_col
       + tb.chan1.rx_agent.monitor.num_pkt_col
       + tb.chan2.rx_agent.monitor.num_pkt_col;
endfunction : channel_packets

//------------------------------------------------------------------------------
task router_disable_test::wait_channels(int expected);
  // a packet needs at most 65 cycles plus the receiver's response delay
  repeat (400) begin
    if (channel_packets() >= expected) begin
      return;
    end
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
endtask : wait_channels
