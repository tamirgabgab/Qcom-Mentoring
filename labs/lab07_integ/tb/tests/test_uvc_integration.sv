//------------------------------------------------------------------------------
// test_uvc_integration.sv -- test_uvc_integration (test library (Lab 7: multi-UVC tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// test_uvc_integration (optional): 88 packets to all four addresses with
// lengths 1..22 and 20% bad parity, while the HBUS sets maxpktsize = 20 and
// enables the router. Check: routing, `error` on bad parity, drops for
// length > 20 and for address 3 ("ROUTER DROPS PACKET" in the log).
//------------------------------------------------------------------------------
class test_uvc_integration extends base_test;

  `uvm_component_utils(test_uvc_integration)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

endclass : test_uvc_integration

//------------------------------------------------------------------------------
// test_uvc_integration -- method implementations
//------------------------------------------------------------------------------

function test_uvc_integration::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void test_uvc_integration::configure_sequences();
  uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                          "default_sequence", yapp_88_packets_seq::get_type());
  uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                          "default_sequence", hbus_small_packet_seq::get_type());
  set_clock_and_channel_sequences();
endfunction : configure_sequences
