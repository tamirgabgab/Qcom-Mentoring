// START POINT of Lab 4: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab04_factory/tb/tests/set_config_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// set_config_test.sv -- set_config_test (test library (Lab 4: factory, overrides, configuration))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// set_config_test: the YAPP agent becomes passive -> no driver, no sequencer.
// A passive agent has no sequencer, so no default sequence is configured;
// otherwise check_config_usage() would (rightly) complain about an unused
// "default_sequence" setting.
//------------------------------------------------------------------------------
class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : set_config_test

//------------------------------------------------------------------------------
// set_config_test -- method implementations
//------------------------------------------------------------------------------

function set_config_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void set_config_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Must be set BEFORE the agent is built (i.e. before super.build_phase)
  // TODO (Lab 4): write set_config_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void set_config_test::configure_sequences();
  // intentionally empty: there is no sequencer to configure
  // TODO (Lab 4): write set_config_test::configure_sequences
endfunction : configure_sequences
