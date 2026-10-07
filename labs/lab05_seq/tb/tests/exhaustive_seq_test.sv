//------------------------------------------------------------------------------
// exhaustive_seq_test.sv -- exhaustive_seq_test (test library (Lab 5: sequence tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// exhaustive_seq_test (Lab 5): runs every sequence of the library with short
// packets. With the original short_yapp_packet (addr != 2) this test produced
// randomization failures -- see the Lab 5 notes.
//------------------------------------------------------------------------------
class exhaustive_seq_test extends base_test;

  `uvm_component_utils(exhaustive_seq_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : exhaustive_seq_test

//------------------------------------------------------------------------------
// exhaustive_seq_test -- method implementations
//------------------------------------------------------------------------------

function exhaustive_seq_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void exhaustive_seq_test::build_phase(uvm_phase phase);
  set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
function void exhaustive_seq_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                          "default_sequence", yapp_exhaustive_seq::get_type());
endfunction : configure_sequences
