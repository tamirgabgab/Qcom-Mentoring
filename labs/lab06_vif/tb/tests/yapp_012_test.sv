//------------------------------------------------------------------------------
// yapp_012_test.sv -- yapp_012_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_012_test (Lab 6): one packet to each channel -- the easiest way to see
// that the DUT connection works (watch in0.in_data vs dut.data_0/1/2).
//------------------------------------------------------------------------------
class yapp_012_test extends base_test;

  `uvm_component_utils(yapp_012_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_012_seq::get_type());
  endfunction : configure_sequences

endclass : yapp_012_test
