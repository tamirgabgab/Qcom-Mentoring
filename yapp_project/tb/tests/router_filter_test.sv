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

  yapp_boundary_seq m_bnd_seq;

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

  m_bnd_seq = yapp_boundary_seq::type_id::create("bnd_seq");
  if (!m_bnd_seq.randomize() with { m_maxpktsize == 6'd10; }) begin
    `uvm_error("FILTER", "bnd_seq.randomize() failed")
  end
  stage("ctrl_reg=10: maxpktsize is 10 for the boundary sequence");
  m_regs.ctrl_reg.write(status, 8'd10);       // maxpktsize = 10

  // 1. every counter enabled
  stage("1. en_reg=0xff: lengths 9/10/11/63 to every address, drops counted");
  m_regs.en_reg.write(status, 8'hff);
  matched_before = m_tb.m_router_module.m_scoreboard.m_packets_matched;
  run_boundary();
  if (m_tb.m_router_module.m_scoreboard.m_packets_matched != matched_before + m_bnd_seq.m_sent_forwarded) begin
    `uvm_error("FILTER", $sformatf("scoreboard matched %0d packets, expected %0d",
                                   m_tb.m_router_module.m_scoreboard.m_packets_matched - matched_before, m_bnd_seq.m_sent_forwarded))
  end
  if (m_tb.m_router_module.m_scoreboard.m_packets_unexpected != 0) begin
    `uvm_error("FILTER", "a dropped packet reached a channel")
  end
  check_counter(m_regs.oversized_pkt_cnt_reg, m_bnd_seq.m_sent_oversized);
  check_counter(m_regs.addr3_cnt_reg, m_bnd_seq.m_sent_per_addr[3]);
  check_counter(m_regs.addr0_cnt_reg, m_bnd_seq.m_sent_per_addr[0]);
  check_counter(m_regs.addr1_cnt_reg, m_bnd_seq.m_sent_per_addr[1]);
  check_counter(m_regs.addr2_cnt_reg, m_bnd_seq.m_sent_per_addr[2]);
  check_counter(m_regs.parity_err_cnt_reg, 0);

  // 2. counters disabled: same traffic, same drops, frozen counters
  stage("2. en_reg=0x01: the same traffic, the same drops, the counters do not move");
  m_regs.en_reg.write(status, 8'h01);
  matched_before = m_tb.m_router_module.m_scoreboard.m_packets_matched;
  run_boundary();
  if (m_tb.m_router_module.m_scoreboard.m_packets_matched != matched_before + m_bnd_seq.m_sent_forwarded) begin
    `uvm_error("FILTER", "the drop rules changed when the counters were disabled")
  end
  check_counter(m_regs.oversized_pkt_cnt_reg, m_bnd_seq.m_sent_oversized);
  check_counter(m_regs.addr3_cnt_reg, m_bnd_seq.m_sent_per_addr[3]);
  check_counter(m_regs.addr0_cnt_reg, m_bnd_seq.m_sent_per_addr[0]);
  check_counter(m_regs.addr1_cnt_reg, m_bnd_seq.m_sent_per_addr[1]);
  check_counter(m_regs.addr2_cnt_reg, m_bnd_seq.m_sent_per_addr[2]);

  stage("ctrl_reg back to 0x3f");
  m_regs.ctrl_reg.write(status, 8'h3f);       // back to the reset value
endtask : access_checks

//------------------------------------------------------------------------------
task router_filter_test::run_boundary();
  int judged_before;
  judged_before = m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched;
  m_bnd_seq.start(m_yapp_seqr);
  repeat (600) begin
    if (m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched
        >= judged_before + m_bnd_seq.m_sent_forwarded) begin
      break;
    end
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);
  end
  repeat (4) begin
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);
  end
endtask : run_boundary
