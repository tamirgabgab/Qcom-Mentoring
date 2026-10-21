// START POINT of Lab 6: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab06_vif/tb/tests/yapp_012_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_012_test.sv -- yapp_012_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_012_test (Lab 6): one packet to each channel -- the easiest way to see
// that the DUT connection works (watch in0.in_data vs dut.data_0/1/2).
//------------------------------------------------------------------------------
class yapp_012_test extends base_test;

  `uvm_component_utils(yapp_012_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

endclass : yapp_012_test

//------------------------------------------------------------------------------
// yapp_012_test -- method implementations
//------------------------------------------------------------------------------

function yapp_012_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_012_test::configure_sequences();
  // TODO (Lab 6): write yapp_012_test::configure_sequences
endfunction : configure_sequences
