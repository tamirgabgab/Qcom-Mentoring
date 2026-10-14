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

  yapp_pkt_seq        m_pkt_seq;
  error_pulse_checker m_err_chk;

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
  m_err_chk = error_pulse_checker::type_id::create("err_chk", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void parity_error_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  m_tb.m_yapp.m_agent.m_monitor.m_item_collected_port.connect(m_err_chk.analysis_export);
  m_err_chk.m_reference = m_tb.m_router_module.m_reference;   // router_en mirror
endfunction : connect_phase

//------------------------------------------------------------------------------
task parity_error_test::access_checks();
  uvm_status_e status;
  int matched_before;
  matched_before = m_tb.m_router_module.m_scoreboard.m_packets_matched;

  // 1. counter enabled
  stage("1. en_reg=0x03 (parity counter on): 8 bad-parity packets, 8 pulses, counter 8, all delivered");
  m_regs.en_reg.write(status, 8'h03);
  send_bad(8);
  check_counter(m_regs.parity_err_cnt_reg, 8);
  if (m_err_chk.m_num_pulses != 8) begin
    `uvm_error("PARITY", $sformatf("%0d error pulses for 8 bad packets", m_err_chk.m_num_pulses))
  end
  if (m_tb.m_router_module.m_scoreboard.m_packets_matched != matched_before + 8) begin
    `uvm_error("PARITY", "a packet with bad parity was not delivered unchanged")
  end

  // 2. counter disabled: the pulse still comes, the count does not move
  stage("2. en_reg=0x01 (counter off): 4 more bad packets, pulses still come, counter stays 8");
  m_regs.en_reg.write(status, 8'h01);
  send_bad(4);
  check_counter(m_regs.parity_err_cnt_reg, 8);
  if (m_err_chk.m_num_pulses != 12) begin
    `uvm_error("PARITY", $sformatf("%0d error pulses for 12 bad packets", m_err_chk.m_num_pulses))
  end
  if (m_err_chk.m_num_late != 0) begin
    `uvm_error("PARITY", $sformatf("%0d pulse(s) outside the 1..10 cycle window", m_err_chk.m_num_late))
  end
endtask : access_checks

//------------------------------------------------------------------------------
task parity_error_test::send_bad(int n);
  int judged_before;
  judged_before = m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched;
  m_pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  repeat (n) begin
    if (!m_pkt_seq.randomize() with { m_pkt_parity == PARITY_TYPE_BAD; }) begin
      `uvm_error("PARITY", "pkt_seq.randomize() failed")
    end
    m_pkt_seq.start(m_yapp_seqr);
  end
  // let the channels deliver the packets (and the last pulse come) before checking
  repeat (400) begin
    if (m_tb.m_router_module.m_scoreboard.m_packets_matched + m_tb.m_router_module.m_scoreboard.m_packets_mismatched >= judged_before + n) begin
      break;
    end
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);
  end
  repeat (12) begin
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);
  end
endtask : send_bad
