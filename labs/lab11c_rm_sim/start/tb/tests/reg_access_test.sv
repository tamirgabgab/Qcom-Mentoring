// START POINT of Lab 11C: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11c_rm_sim/tb/tests/reg_access_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// reg_access_test.sv -- reg_access_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_access_test (Lab 11C): front-door / backdoor access checks on one RW
// register (ctrl_reg) and one RO register (addr0_cnt_reg).
//
// Writing an RO register through the front door produces a real HBUS write
// cycle, which the DUT ignores; the model's mirror is not updated either
// because the field policy is RO.
//------------------------------------------------------------------------------
class reg_access_test extends base_test;

  // Convenience handle to the register block (path from the topology report)
  yapp_regs_c m_regs;

  `uvm_component_utils(reg_access_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // The stimulus of this test; derived tests replace it
  extern virtual task access_checks();

  // RW: front-door write -> peek, poke -> front-door read
  extern task check_rw_register(uvm_reg rg, uvm_reg_data_t wr_val, uvm_reg_data_t poke_val);

  // RO: poke -> front-door read, front-door write (ignored) -> peek unchanged
  extern task check_ro_register(uvm_reg rg, uvm_reg_data_t poke_val, uvm_reg_data_t wr_val);

endclass : reg_access_test

//------------------------------------------------------------------------------
// reg_access_test -- method implementations
//------------------------------------------------------------------------------

function reg_access_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void reg_access_test::configure_sequences();
  // TODO (Lab 11C): write reg_access_test::configure_sequences
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void reg_access_test::connect_phase(uvm_phase phase);
  // TODO (Lab 11C): write reg_access_test::connect_phase
endfunction : connect_phase

//------------------------------------------------------------------------------
task reg_access_test::run_phase(uvm_phase phase);
  super.run_phase(phase);                   // drain time
  // TODO (Lab 11C): write reg_access_test::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
task reg_access_test::access_checks();
  // TODO (Lab 11C): write reg_access_test::access_checks
endtask : access_checks

//------------------------------------------------------------------------------
task reg_access_test::check_rw_register(uvm_reg rg, uvm_reg_data_t wr_val, uvm_reg_data_t poke_val);
  // TODO (Lab 11C): write reg_access_test::check_rw_register
endtask : check_rw_register

//------------------------------------------------------------------------------
task reg_access_test::check_ro_register(uvm_reg rg, uvm_reg_data_t poke_val, uvm_reg_data_t wr_val);
  // TODO (Lab 11C): write reg_access_test::check_ro_register
endtask : check_ro_register
