// START POINT of Lab 7: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab07_integ/tb/tests/test_uvc_integration.sv; the lab page explains every step.
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
  // TODO (Lab 7): write test_uvc_integration::configure_sequences
endfunction : configure_sequences
