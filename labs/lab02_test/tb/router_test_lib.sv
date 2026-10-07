//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 2)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench and prints the topology
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb tb;

  `uvm_component_utils(base_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
    tb = new("tb", this);          // the test OWNS the testbench
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();      // the whole component tree, once it is built
  endfunction : end_of_elaboration_phase

endclass : base_test


//------------------------------------------------------------------------------
// test2 (optional): the smallest possible test -- everything is inherited.
// Select it with +UVM_TESTNAME=test2, no recompilation needed.
//------------------------------------------------------------------------------
class test2 extends base_test;

  `uvm_component_utils(test2)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : test2
