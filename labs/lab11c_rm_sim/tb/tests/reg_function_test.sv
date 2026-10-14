//------------------------------------------------------------------------------
// reg_function_test.sv -- reg_function_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_function_test (Lab 11C): do the enable bits and counters behave?
//   1. en_reg = router_en only; run yapp_012_seq; address counters stay 0
//   2. en_reg = 0xff; run yapp_012_seq twice; addr0/1/2 == 2, addr3 == 0,
//      parity_err_cnt == bad-parity packets seen by the monitor, oversized == 0
//------------------------------------------------------------------------------
class reg_function_test extends reg_access_test;

  yapp_tx_sequencer m_yapp_seqr;
  yapp_012_seq      m_seq;

  `uvm_component_utils(reg_function_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void connect_phase(uvm_phase phase);
  extern virtual task access_checks();

  // Front-door read and compare
  extern virtual task check_counter(uvm_reg rg, uvm_reg_data_t expected);

endclass : reg_function_test

//------------------------------------------------------------------------------
// reg_function_test -- method implementations
//------------------------------------------------------------------------------

function reg_function_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void reg_function_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_seq = yapp_012_seq::type_id::create("seq");
endfunction : build_phase

//------------------------------------------------------------------------------
function void reg_function_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  m_yapp_seqr = m_tb.m_yapp.m_agent.m_sequencer;      // hierarchical path, no config
endfunction : connect_phase

//------------------------------------------------------------------------------
task reg_function_test::access_checks();
  uvm_status_e   status;
  uvm_reg_data_t val;
  int bad_before, bad_after;

  // 1. router enabled, every counter disabled
  m_regs.en_reg.write(status, 8'h01);
  m_regs.en_reg.read(status, val);
  `uvm_info("REG_FUNC", $sformatf("en_reg reads 0x%02h", val), UVM_NONE)
  if (val != 8'h01) begin
    `uvm_error("REG_FUNC", $sformatf("en_reg reads 0x%02h, expected 0x01", val))
  end

  m_seq.start(m_yapp_seqr);                     // 3 packets, counters off
  check_counter(m_regs.addr0_cnt_reg, 0);
  check_counter(m_regs.addr1_cnt_reg, 0);
  check_counter(m_regs.addr2_cnt_reg, 0);
  check_counter(m_regs.addr3_cnt_reg, 0);

  // 2. every counter enabled
  bad_before = m_tb.m_yapp.m_agent.m_monitor.m_num_bad_parity;
  m_regs.en_reg.write(status, 8'hff);
  m_seq.start(m_yapp_seqr);
  m_seq.start(m_yapp_seqr);                     // 6 packets, 2 per address
  bad_after = m_tb.m_yapp.m_agent.m_monitor.m_num_bad_parity;

  check_counter(m_regs.addr0_cnt_reg, 2);
  check_counter(m_regs.addr1_cnt_reg, 2);
  check_counter(m_regs.addr2_cnt_reg, 2);
  check_counter(m_regs.addr3_cnt_reg, 0);
  check_counter(m_regs.parity_err_cnt_reg, bad_after - bad_before);
  check_counter(m_regs.oversized_pkt_cnt_reg, 0);   // maxpktsize is 63 (reset)
endtask : access_checks

//------------------------------------------------------------------------------
task reg_function_test::check_counter(uvm_reg rg, uvm_reg_data_t expected);
  uvm_status_e   status;
  uvm_reg_data_t val;
  rg.read(status, val);
  if (val != expected) begin
    `uvm_error("REG_FUNC", $sformatf("%s reads %0d, expected %0d", rg.get_name(), val, expected))
  end else begin
    `uvm_info("REG_FUNC", $sformatf("%s reads %0d as expected", rg.get_name(), val), UVM_NONE)
  end
endtask : check_counter
