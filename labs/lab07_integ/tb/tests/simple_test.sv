//------------------------------------------------------------------------------
// simple_test.sv -- simple_test (test library (Lab 7: multi-UVC tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// simple_test: short packets to channels 0, 1, 2; channels respond; clock and
// reset from the UVC; the HBUS stays idle (router uses its reset values).
//------------------------------------------------------------------------------
class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : simple_test

//------------------------------------------------------------------------------
// simple_test -- method implementations
//------------------------------------------------------------------------------

function simple_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void simple_test::build_phase(uvm_phase phase);
  set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
function void simple_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                          "default_sequence", yapp_012_seq::get_type());
  set_clock_and_channel_sequences();
  // no default sequence for the HBUS UVC
endfunction : configure_sequences
