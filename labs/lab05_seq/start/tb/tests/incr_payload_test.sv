// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/tb/tests/incr_payload_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// incr_payload_test.sv -- incr_payload_test (test library (Lab 5: sequence tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// incr_payload_test (Lab 5): one short packet with an incrementing payload.
// Run with +UVM_VERBOSITY=UVM_FULL to see the default sequence being started.
//------------------------------------------------------------------------------
class incr_payload_test extends base_test;

  `uvm_component_utils(incr_payload_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : incr_payload_test

//------------------------------------------------------------------------------
// incr_payload_test -- method implementations
//------------------------------------------------------------------------------

function incr_payload_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void incr_payload_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO (Lab 5): write incr_payload_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void incr_payload_test::configure_sequences();
  // TODO (Lab 5): write incr_payload_test::configure_sequences
endfunction : configure_sequences
