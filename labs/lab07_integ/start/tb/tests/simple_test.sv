// START POINT of Lab 7: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab07_integ/tb/tests/simple_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// simple_test.sv -- simple_test (test library (Lab 7: multi-UVC tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// simple_test: short packets to channels 0, 1, 2; channels respond; clock and
// reset from the UVC; the HBUS stays idle (router uses its reset values).
//------------------------------------------------------------------------------
class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : simple_test

//------------------------------------------------------------------------------
// simple_test -- method implementations
//------------------------------------------------------------------------------

function simple_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void simple_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO (Lab 7): write simple_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void simple_test::configure_sequences();
  // no default sequence for the HBUS UVC
  // TODO (Lab 7): write simple_test::configure_sequences
endfunction : configure_sequences
