//------------------------------------------------------------------------------
// coverage_test.sv -- coverage_test (test library (Lab 10: functional coverage))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// coverage_test (Lab 10 step 10): stimulus written to close the model --
// every length bin to every address, with and without parity errors.
// Full-size packets (no override); maxpktsize keeps its reset value 63.
//------------------------------------------------------------------------------
class coverage_test extends base_test;

  `uvm_component_utils(coverage_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

endclass : coverage_test

//------------------------------------------------------------------------------
// coverage_test -- method implementations
//------------------------------------------------------------------------------

function coverage_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void coverage_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                          "default_sequence", yapp_coverage_seq::get_type());
  set_clock_and_channel_sequences();
endfunction : configure_sequences
