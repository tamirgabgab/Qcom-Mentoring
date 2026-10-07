//------------------------------------------------------------------------------
// router_simple_mcseq_test.sv -- router_simple_mcseq_test (test library (Lab 10: functional coverage))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_simple_mcseq_test (Lab 8): short packets only -> look at the holes
// in the coverage report (no MEDIUM/LARGE/MAX lengths, no address 3).
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

function void router_simple_mcseq_test::build_phase(uvm_phase phase);
  set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  super.build_phase(phase);
endfunction : build_phase

function void router_simple_mcseq_test::configure_sequences();
  set_clock_and_channel_sequences();
  uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                          "default_sequence", router_simple_mcseq::get_type());
endfunction : configure_sequences
