//------------------------------------------------------------------------------
// incr_payload_test.sv -- incr_payload_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// incr_payload_test (Lab 5)
//------------------------------------------------------------------------------
class incr_payload_test extends base_test;

  `uvm_component_utils(incr_payload_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_incr_payload_seq::get_type());
  endfunction : configure_sequences

endclass : incr_payload_test
