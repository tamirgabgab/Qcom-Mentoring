//------------------------------------------------------------------------------
// test_uvc_integration.sv -- test_uvc_integration (test library (Lab 10: functional coverage))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// test_uvc_integration (Lab 7): 88 packets, lengths 1..22, all addresses,
// 20% bad parity -- covers addresses but not the long length bins.
//------------------------------------------------------------------------------
class test_uvc_integration extends base_test;

  `uvm_component_utils(test_uvc_integration)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_88_packets_seq::get_type());
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                            "default_sequence", hbus_small_packet_seq::get_type());
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

endclass : test_uvc_integration
