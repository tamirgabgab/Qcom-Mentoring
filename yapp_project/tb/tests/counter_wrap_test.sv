//------------------------------------------------------------------------------
// counter_wrap_test.sv -- counter_wrap_test (test plan: CNT-06)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// counter_wrap_test: an 8-bit counter wraps from 255 to 0 (the specification
// is silent; docs/dut/spec.md "Decisions" fixes the choice).
//   1. en_reg = 0xff; 255 short packets to address 0 -> addr0_cnt_reg == 255
//   2. one more packet -> addr0_cnt_reg == 0 (wrapped, not saturated)
//   3. one more packet -> addr0_cnt_reg == 1 (counting goes on after the wrap)
// The other counters stay 0 and the scoreboard matches all 257 packets.
//------------------------------------------------------------------------------
class counter_wrap_test extends reg_function_test;

  yapp_pkt_seq m_pkt_seq;

  `uvm_component_utils(counter_wrap_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

  // Send `n` one-byte packets to address 0 and wait until the channel delivered them
  extern task send_to_addr0(int n);

endclass : counter_wrap_test

//------------------------------------------------------------------------------
// counter_wrap_test -- method implementations
//------------------------------------------------------------------------------

function counter_wrap_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task counter_wrap_test::access_checks();
  uvm_status_e status;
  int matched_before;
  matched_before = m_tb.m_router_module.m_scoreboard.m_packets_matched;
  m_regs.en_reg.write(status, 8'hff);         // router and every counter on

  // 1. up to the last value an 8-bit counter can hold
  stage("1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255");
  send_to_addr0(255);
  check_counter(m_regs.addr0_cnt_reg, 255);

  // 2. the 256th packet wraps the counter
  stage("2. the 256th packet wraps addr0_cnt_reg to 0");
  send_to_addr0(1);
  check_counter(m_regs.addr0_cnt_reg, 0);

  // 3. and it keeps counting from there
  stage("3. one more packet: the counter goes on from 0");
  send_to_addr0(1);
  check_counter(m_regs.addr0_cnt_reg, 1);

  stage("4. the other counters are untouched and the scoreboard matched all 257 packets");
  check_counter(m_regs.addr1_cnt_reg, 0);
  check_counter(m_regs.addr2_cnt_reg, 0);
  check_counter(m_regs.addr3_cnt_reg, 0);
  check_counter(m_regs.parity_err_cnt_reg, 0);
  check_counter(m_regs.oversized_pkt_cnt_reg, 0);
  if (m_tb.m_router_module.m_scoreboard.m_packets_matched != matched_before + 257) begin
    `uvm_error("CNT_WRAP", $sformatf("scoreboard matched %0d packets, expected 257",
                                     m_tb.m_router_module.m_scoreboard.m_packets_matched - matched_before))
  end
endtask : access_checks

//------------------------------------------------------------------------------
task counter_wrap_test::send_to_addr0(int n);
  int judged_before;
  judged_before = m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched;
  m_pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  repeat (n) begin
    if (!m_pkt_seq.randomize() with { m_pkt_addr == 2'd0; m_pkt_len == 6'd1; }) begin
      `uvm_error("CNT_WRAP", "pkt_seq.randomize() failed")
    end
    m_pkt_seq.start(m_yapp_seqr);
  end
  // let the channel deliver the last packets before reading the counter
  repeat (400) begin
    if (m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched >= judged_before + n) begin
      break;
    end
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);
  end
endtask : send_to_addr0
