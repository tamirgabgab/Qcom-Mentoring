// START POINT of Lab 10: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab10_cov/tb/tests/coverage_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// coverage_test.sv -- coverage_test (test library (Lab 10: functional coverage))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// coverage_test (Lab 10 step 10): stimulus written to close the model --
// every length bin to every address, with and without parity errors.
// Full-size packets (no override); maxpktsize keeps its reset value 63.
//------------------------------------------------------------------------------
class coverage_test extends base_test;

  `uvm_component_utils(coverage_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

endclass : coverage_test

//------------------------------------------------------------------------------
// coverage_test -- method implementations
//------------------------------------------------------------------------------

function coverage_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void coverage_test::configure_sequences();
  // TODO (Lab 10): write coverage_test::configure_sequences
endfunction : configure_sequences
