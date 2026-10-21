// START POINT of Lab 11C: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11c_rm_sim/tb/tests/reg_introspection_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// reg_introspection_test.sv -- reg_introspection_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_introspection_test (Lab 11C, optional): let the model tell us which
// registers are RW and which are RO, then run the access checks on all of them.
//------------------------------------------------------------------------------
class reg_introspection_test extends reg_access_test;

  `uvm_component_utils(reg_introspection_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

endclass : reg_introspection_test

//------------------------------------------------------------------------------
// reg_introspection_test -- method implementations
//------------------------------------------------------------------------------

function reg_introspection_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task reg_introspection_test::access_checks();
  // TODO (Lab 11C): write reg_introspection_test::access_checks
endtask : access_checks
