//------------------------------------------------------------------------------
// router_filter_test.sv -- router_filter_test (test plan: DROP-01, DROP-03,
//                          PKT-03, CNT-01, CNT-03)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_filter_test: the drop rules and the counters around the maxpktsize
// limit.
//   1. ctrl_reg = 10, en_reg = 0xff; yapp_boundary_seq (lengths 9, 10, 11, 63
//      to addresses 0..3) -> only legal, non-oversized packets reach a
//      channel (scoreboard), oversized_pkt_cnt_reg == packets longer than 10,
//      addr3_cnt_reg == packets to address 3, addrN_cnt_reg == packets sent
//      to N (dropped ones included), parity counter 0
//   2. en_reg = 0x01 (counters off); the same sequence again -> the counters
//      do not move, the drop rules still apply
//------------------------------------------------------------------------------
class router_filter_test extends reg_function_test;

  yapp_boundary_seq bnd_seq;

  `uvm_component_utils(router_filter_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

  // Run the boundary sequence and wait until the scoreboard judged the forwarded packets
  extern task run_boundary();

endclass : router_filter_test

//------------------------------------------------------------------------------
// router_filter_test -- method implementations
//------------------------------------------------------------------------------

function router_filter_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task router_filter_test::access_checks();
  uvm_status_e status;
  int matched_before;

  bnd_seq = yapp_boundary_seq::type_id::create("bnd_seq");
  if (!bnd_seq.randomize() with { maxpktsize == 6'd10; }) begin
    `uvm_error("FILTER", "bnd_seq.randomize() failed")
  end
  regs.ctrl_reg.write(status, 8'd10);       // maxpktsize = 10

  // 1. every counter enabled
  regs.en_reg.write(status, 8'hff);
  matched_before = tb.router_module.scoreboard.packets_matched;
  run_boundary();
  if (tb.router_module.scoreboard.packets_matched != matched_before + bnd_seq.sent_forwarded) begin
    `uvm_error("FILTER", $sformatf("scoreboard matched %0d packets, expected %0d",
                                   tb.router_module.scoreboard.packets_matched - matched_before, bnd_seq.sent_forwarded))
  end
  if (tb.router_module.scoreboard.packets_unexpected != 0) begin
    `uvm_error("FILTER", "a dropped packet reached a channel")
  end
  check_counter(regs.oversized_pkt_cnt_reg, bnd_seq.sent_oversized);
  check_counter(regs.addr3_cnt_reg, bnd_seq.sent_per_addr[3]);
  check_counter(regs.addr0_cnt_reg, bnd_seq.sent_per_addr[0]);
  check_counter(regs.addr1_cnt_reg, bnd_seq.sent_per_addr[1]);
  check_counter(regs.addr2_cnt_reg, bnd_seq.sent_per_addr[2]);
  check_counter(regs.parity_err_cnt_reg, 0);

  // 2. counters disabled: same traffic, same drops, frozen counters
  regs.en_reg.write(status, 8'h01);
  matched_before = tb.router_module.scoreboard.packets_matched;
  run_boundary();
  if (tb.router_module.scoreboard.packets_matched != matched_before + bnd_seq.sent_forwarded) begin
    `uvm_error("FILTER", "the drop rules changed when the counters were disabled")
  end
  check_counter(regs.oversized_pkt_cnt_reg, bnd_seq.sent_oversized);
  check_counter(regs.addr3_cnt_reg, bnd_seq.sent_per_addr[3]);
  check_counter(regs.addr0_cnt_reg, bnd_seq.sent_per_addr[0]);
  check_counter(regs.addr1_cnt_reg, bnd_seq.sent_per_addr[1]);
  check_counter(regs.addr2_cnt_reg, bnd_seq.sent_per_addr[2]);

  regs.ctrl_reg.write(status, 8'h3f);       // back to the reset value
endtask : access_checks

//------------------------------------------------------------------------------
task router_filter_test::run_boundary();
  int judged_before;
  judged_before = tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched;
  bnd_seq.start(yapp_seqr);
  repeat (600) begin
    if (tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched
        >= judged_before + bnd_seq.sent_forwarded) break;
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
  repeat (4) @(posedge tb.yapp.agent.monitor.vif.clock);
endtask : run_boundary
