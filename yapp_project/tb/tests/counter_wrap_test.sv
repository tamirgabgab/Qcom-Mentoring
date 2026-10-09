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

  yapp_pkt_seq pkt_seq;

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
  matched_before = tb.router_module.scoreboard.packets_matched;
  regs.en_reg.write(status, 8'hff);         // router and every counter on

  // 1. up to the last value an 8-bit counter can hold
  send_to_addr0(255);
  check_counter(regs.addr0_cnt_reg, 255);

  // 2. the 256th packet wraps the counter
  send_to_addr0(1);
  check_counter(regs.addr0_cnt_reg, 0);

  // 3. and it keeps counting from there
  send_to_addr0(1);
  check_counter(regs.addr0_cnt_reg, 1);

  check_counter(regs.addr1_cnt_reg, 0);
  check_counter(regs.addr2_cnt_reg, 0);
  check_counter(regs.addr3_cnt_reg, 0);
  check_counter(regs.parity_err_cnt_reg, 0);
  check_counter(regs.oversized_pkt_cnt_reg, 0);
  if (tb.router_module.scoreboard.packets_matched != matched_before + 257) begin
    `uvm_error("CNT_WRAP", $sformatf("scoreboard matched %0d packets, expected 257",
                                     tb.router_module.scoreboard.packets_matched - matched_before))
  end
endtask : access_checks

//------------------------------------------------------------------------------
task counter_wrap_test::send_to_addr0(int n);
  int judged_before;
  judged_before = tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched;
  pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  repeat (n) begin
    if (!pkt_seq.randomize() with { pkt_addr == 2'd0; pkt_len == 6'd1; }) begin
      `uvm_error("CNT_WRAP", "pkt_seq.randomize() failed")
    end
    pkt_seq.start(yapp_seqr);
  end
  // let the channel deliver the last packets before reading the counter
  repeat (400) begin
    if (tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched >= judged_before + n) begin
      break;
    end
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
endtask : send_to_addr0
