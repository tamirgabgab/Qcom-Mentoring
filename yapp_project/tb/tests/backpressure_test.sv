//------------------------------------------------------------------------------
// backpressure_test.sv -- backpressure_test (test plan: IN-03, OUT-03, OUT-04)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// backpressure_test: the YAPP handshake under back-pressure.
// The channels run channel_rx_slow_seq (response delay 20..40 cycles), so a
// long packet fills the 16-byte channel FIFO before the receiver starts to
// read and the router must stall the input with in_suspend. Six packets of
// 40..63 bytes are sent; in_suspend must rise at least once, every byte must
// still reach its channel exactly once (scoreboard: 6 matched, 0 mismatched,
// 0 unexpected) and the receivers must see no bad parity.
//------------------------------------------------------------------------------
class backpressure_test extends reg_function_test;

  yapp_pkt_seq pkt_seq;
  int          num_suspend;                 // rising edges of in_suspend

  `uvm_component_utils(backpressure_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();
  extern virtual task access_checks();

  // Count the rising edges of in_suspend on the YAPP interface
  extern task count_suspends();

  // Wait (bounded) until the scoreboard has judged `expected` packets
  extern task wait_scoreboard(int expected);

endclass : backpressure_test

//------------------------------------------------------------------------------
// backpressure_test -- method implementations
//------------------------------------------------------------------------------

function backpressure_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void backpressure_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                          "default_sequence", clk10_rst5_seq::get_type());
  uvm_config_wrapper::set(this, "tb.chan*.rx_agent.sequencer.run_phase",
                          "default_sequence", channel_rx_slow_seq::get_type());
endfunction : configure_sequences

//------------------------------------------------------------------------------
task backpressure_test::access_checks();
  int matched_before;
  int judged_before;
  matched_before = tb.router_module.scoreboard.packets_matched;
  judged_before  = tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched;
  fork
    count_suspends();
  join_none

  pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  repeat (6) begin
    if (!pkt_seq.randomize() with { pkt_len inside {[40:63]}; }) begin
      `uvm_error("BACKPRESSURE", "pkt_seq.randomize() failed")
    end
    pkt_seq.start(yapp_seqr);
  end
  wait_scoreboard(judged_before + 6);

  if (num_suspend == 0) begin
    `uvm_error("BACKPRESSURE", "in_suspend never rose: the FIFO was never full, nothing was tested")
  end else begin
    `uvm_info("BACKPRESSURE", $sformatf("in_suspend rose %0d times", num_suspend), UVM_NONE)
  end
  if (tb.router_module.scoreboard.packets_matched != matched_before + 6) begin
    `uvm_error("BACKPRESSURE", $sformatf("scoreboard matched %0d of 6 packets",
                                         tb.router_module.scoreboard.packets_matched - matched_before))
  end
  if (tb.router_module.scoreboard.packets_unexpected != 0) begin
    `uvm_error("BACKPRESSURE", "a channel delivered a packet nobody sent (a byte was lost or duplicated)")
  end
  if (tb.yapp.agent.monitor.num_bad_parity != 0) begin
    `uvm_error("BACKPRESSURE", "the YAPP monitor saw bad parity: a held byte was not held")
  end
endtask : access_checks

//------------------------------------------------------------------------------
task backpressure_test::count_suspends();
  virtual interface yapp_if vif;
  vif = tb.yapp.agent.monitor.vif;
  forever begin
    @(posedge vif.in_suspend);
    num_suspend++;
  end
endtask : count_suspends

//------------------------------------------------------------------------------
task backpressure_test::wait_scoreboard(int expected);
  // 65 bytes plus a 40-cycle response delay per packet, with a margin
  repeat (1000) begin
    if (tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched >= expected) return;
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
endtask : wait_scoreboard
