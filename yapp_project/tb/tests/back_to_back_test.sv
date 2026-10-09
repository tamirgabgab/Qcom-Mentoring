//------------------------------------------------------------------------------
// back_to_back_test.sv -- back_to_back_test (test plan: ROUTE-04)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// back_to_back_test: packets with no idle cycle between them (the header in the
// cycle right after the parity byte) and with gaps of 1, 2 and 3 cycles.
//   1. router enabled (reset value of en_reg); yapp_gap_seq: 24 packets,
//      gaps 0, 1, 2, 3 in turn, to random legal addresses
//   2. the YAPP monitor measured the same gaps the sequence asked for
//      (num_gap == planned_gap), and yapp_gap_cg is at 100 %
//   3. the scoreboard matched every packet, nothing unexpected
//------------------------------------------------------------------------------
class back_to_back_test extends reg_function_test;

  yapp_gap_seq gap_seq;

  `uvm_component_utils(back_to_back_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

endclass : back_to_back_test

//------------------------------------------------------------------------------
// back_to_back_test -- method implementations
//------------------------------------------------------------------------------

function back_to_back_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task back_to_back_test::access_checks();
  int gaps_before[4];
  int measured;
  gap_seq = yapp_gap_seq::type_id::create("gap_seq");
  if (!gap_seq.randomize() with { count == 24; }) begin
    `uvm_error("GAP", "gap_seq.randomize() failed")
  end
  gaps_before = tb.yapp.agent.monitor.num_gap;
  gap_seq.start(yapp_seqr);

  // let the channels deliver the last packets
  repeat (400) begin
    if (tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched >= 24) begin
      break;
    end
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end

  foreach (gaps_before[i]) begin
    // the monitor skips the first packet after reset, the sequence its first packet
    measured = tb.yapp.agent.monitor.num_gap[i] - gaps_before[i];
    if (measured != gap_seq.planned_gap[i]) begin
      `uvm_error("GAP", $sformatf("gap class %0d: the monitor measured %0d packets, the sequence asked for %0d",
                                  i, measured, gap_seq.planned_gap[i]))
    end else begin
      `uvm_info("GAP", $sformatf("gap class %0d: %0d packets, as planned", i, measured), UVM_NONE)
    end
  end
  if (tb.yapp.agent.monitor.yapp_gap_cg.get_inst_coverage() < 100.0) begin
    `uvm_error("GAP", $sformatf("gap coverage %.1f%%, expected 100%%", tb.yapp.agent.monitor.yapp_gap_cg.get_inst_coverage()))
  end
  if (tb.router_module.scoreboard.packets_matched != 24 || tb.router_module.scoreboard.packets_unexpected != 0) begin
    `uvm_error("GAP", $sformatf("scoreboard: %0d matched (expected 24), %0d unexpected",
                                tb.router_module.scoreboard.packets_matched, tb.router_module.scoreboard.packets_unexpected))
  end
endtask : access_checks
