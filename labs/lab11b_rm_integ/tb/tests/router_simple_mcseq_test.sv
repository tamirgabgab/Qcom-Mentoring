//------------------------------------------------------------------------------
// router_simple_mcseq_test.sv -- router_simple_mcseq_test (test library (Lab 11B: built-in register sequences))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_simple_mcseq_test (Lab 8): still works with the model in place
//------------------------------------------------------------------------------
class router_simple_mcseq_test extends base_test;

  `uvm_component_utils(router_simple_mcseq_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    set_clock_and_channel_sequences();
    uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                            "default_sequence", router_simple_mcseq::get_type());
  endfunction : configure_sequences

endclass : router_simple_mcseq_test
