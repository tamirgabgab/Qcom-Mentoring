// START POINT of Lab 8: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab08_mcseq/tb/tests/router_simple_mcseq_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_simple_mcseq_test.sv -- router_simple_mcseq_test (test library (Lab 8: system-level test))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_simple_mcseq_test (Lab 8): the multichannel sequencer controls HBUS
// and YAPP; neither of those gets a default sequence of its own.
//------------------------------------------------------------------------------
class router_simple_mcseq_test extends base_test;

  `uvm_component_utils(router_simple_mcseq_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : router_simple_mcseq_test

//------------------------------------------------------------------------------
// router_simple_mcseq_test -- method implementations
//------------------------------------------------------------------------------

function router_simple_mcseq_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void router_simple_mcseq_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO (Lab 8): write router_simple_mcseq_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_simple_mcseq_test::configure_sequences();
  // TODO (Lab 8): write router_simple_mcseq_test::configure_sequences
endfunction : configure_sequences
