// START POINT of Lab 11C: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11c_rm_sim/tb/tests/reg_function_test.sv; the lab page explains every step.
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
  // TODO (Lab 11C): write reg_function_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void reg_function_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  // TODO (Lab 11C): write reg_function_test::connect_phase
endfunction : connect_phase

//------------------------------------------------------------------------------
task reg_function_test::access_checks();
  // 1. router enabled, every counter disabled
  // 2. every counter enabled
  // TODO (Lab 11C): write reg_function_test::access_checks
endtask : access_checks

//------------------------------------------------------------------------------
task reg_function_test::check_counter(uvm_reg rg, uvm_reg_data_t expected);
  // TODO (Lab 11C): write reg_function_test::check_counter
endtask : check_counter
