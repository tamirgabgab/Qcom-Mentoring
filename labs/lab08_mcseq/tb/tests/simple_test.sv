//------------------------------------------------------------------------------
// simple_test.sv -- simple_test (test library (Lab 8: system-level test))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// simple_test (Lab 7)
//------------------------------------------------------------------------------
class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_012_seq::get_type());
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

endclass : simple_test
