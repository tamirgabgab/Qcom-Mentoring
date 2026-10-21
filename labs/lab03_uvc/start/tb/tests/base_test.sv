// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/tb/tests/base_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 3))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench, selects the default sequence of the YAPP
// sequencer and prints the topology
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb m_tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void end_of_elaboration_phase(uvm_phase phase);

  // Optional: which component reports first / last and why?
  extern function void start_of_simulation_phase(uvm_phase phase);

endclass : base_test

//------------------------------------------------------------------------------
// base_test -- method implementations
//------------------------------------------------------------------------------

function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configuration must be set BEFORE the component that reads it is built.
  // The path is the sequencer's hierarchical name from the topology print.
  // TODO (Lab 3): write base_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  // TODO (Lab 3): write base_test::end_of_elaboration_phase
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
function void base_test::start_of_simulation_phase(uvm_phase phase);
  // TODO (Lab 3): write base_test::start_of_simulation_phase
endfunction : start_of_simulation_phase
