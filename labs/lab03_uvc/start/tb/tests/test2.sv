//------------------------------------------------------------------------------
// test2.sv -- test2 (test library (Lab 3))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// test2 (optional): everything inherited from base_test
//------------------------------------------------------------------------------
class test2 extends base_test;

  `uvm_component_utils(test2)

  extern function new(string name, uvm_component parent);

endclass : test2

//------------------------------------------------------------------------------
// test2 -- method implementations
//------------------------------------------------------------------------------

function test2::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
