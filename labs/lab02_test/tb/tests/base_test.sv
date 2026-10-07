//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 2))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench and prints the topology
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : base_test

//------------------------------------------------------------------------------
// base_test -- method implementations
//------------------------------------------------------------------------------

function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
  tb = new("tb", this);          // the test OWNS the testbench
endfunction : build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();      // the whole component tree, once it is built
endfunction : end_of_elaboration_phase
