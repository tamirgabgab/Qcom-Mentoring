//------------------------------------------------------------------------------
// parity_error_test.sv -- parity_error_test (test plan: PKT-05, IN-04, CNT-01)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// parity_error_test: what a wrong parity byte does.
//   1. en_reg = 0x03 (router + parity counter); 8 packets with bad parity
//      -> parity_err_cnt_reg == 8, one error pulse per packet, 1..10 cycles
//         after the parity byte (error_pulse_checker), and the packets are
//         still delivered (the router forwards them; scoreboard 8 matched)
//   2. en_reg = 0x01 (counter off); 4 more bad packets
//      -> the counter stays at 8, the pulses still come
//------------------------------------------------------------------------------
class parity_error_test extends reg_function_test;

  yapp_pkt_seq        pkt_seq;
  error_pulse_checker err_chk;

  `uvm_component_utils(parity_error_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern virtual task access_checks();

  // Send `n` packets with bad parity, then wait until the channels delivered them
  extern task send_bad(int n);

endclass : parity_error_test

//------------------------------------------------------------------------------
// parity_error_test -- method implementations
//------------------------------------------------------------------------------

function parity_error_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void parity_error_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  err_chk = error_pulse_checker::type_id::create("err_chk", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void parity_error_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  tb.yapp.agent.monitor.item_collected_port.connect(err_chk.analysis_export);
endfunction : connect_phase

//------------------------------------------------------------------------------
task parity_error_test::access_checks();
  uvm_status_e status;
  int matched_before;
  matched_before = tb.router_module.scoreboard.packets_matched;

  // 1. counter enabled
  regs.en_reg.write(status, 8'h03);
  send_bad(8);
  check_counter(regs.parity_err_cnt_reg, 8);
  if (err_chk.num_pulses != 8) begin
    `uvm_error("PARITY", $sformatf("%0d error pulses for 8 bad packets", err_chk.num_pulses))
  end
  if (tb.router_module.scoreboard.packets_matched != matched_before + 8) begin
    `uvm_error("PARITY", "a packet with bad parity was not delivered unchanged")
  end

  // 2. counter disabled: the pulse still comes, the count does not move
  regs.en_reg.write(status, 8'h01);
  send_bad(4);
  check_counter(regs.parity_err_cnt_reg, 8);
  if (err_chk.num_pulses != 12) begin
    `uvm_error("PARITY", $sformatf("%0d error pulses for 12 bad packets", err_chk.num_pulses))
  end
  if (err_chk.num_late != 0) begin
    `uvm_error("PARITY", $sformatf("%0d pulse(s) outside the 1..10 cycle window", err_chk.num_late))
  end
endtask : access_checks

//------------------------------------------------------------------------------
task parity_error_test::send_bad(int n);
  int judged_before;
  judged_before = tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched;
  pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  repeat (n) begin
    if (!pkt_seq.randomize() with { pkt_parity == BAD_PARITY; }) begin
      `uvm_error("PARITY", "pkt_seq.randomize() failed")
    end
    pkt_seq.start(yapp_seqr);
  end
  // let the channels deliver the packets (and the last pulse come) before checking
  repeat (400) begin
    if (tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched >= judged_before + n) begin
      break;
    end
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
  repeat (12) begin
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
endtask : send_bad
