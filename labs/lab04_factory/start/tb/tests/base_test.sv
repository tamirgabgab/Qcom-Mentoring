// START POINT of Lab 4: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab04_factory/tb/tests/base_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 4: factory, overrides, configuration))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test
//   * builds the testbench through the factory
//   * turns transaction recording on for every component
//   * the default sequence is set in configure_sequences(), a virtual method,
//     so a derived test can replace or skip it (see set_config_test)
//   * check_config_usage() reports settings nobody consumed
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb m_tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Default sequences for the sequencers in the testbench
  extern virtual function void configure_sequences();

  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);

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
  // TODO (Lab 4): write base_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void base_test::configure_sequences();
  // TODO (Lab 4): write base_test::configure_sequences
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
function void base_test::check_phase(uvm_phase phase);
  // TODO (Lab 4): write base_test::check_phase
endfunction : check_phase
