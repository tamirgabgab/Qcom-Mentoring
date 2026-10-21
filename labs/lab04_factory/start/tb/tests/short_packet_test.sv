// START POINT of Lab 4: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab04_factory/tb/tests/short_packet_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// short_packet_test.sv -- short_packet_test (test library (Lab 4: factory, overrides, configuration))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// short_packet_test: every yapp_packet the factory creates becomes a
// short_yapp_packet. Nothing in the UVC changes.
//------------------------------------------------------------------------------
class short_packet_test extends base_test;

  `uvm_component_utils(short_packet_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : short_packet_test

//------------------------------------------------------------------------------
// short_packet_test -- method implementations
//------------------------------------------------------------------------------

function short_packet_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void short_packet_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO (Lab 4): write short_packet_test::build_phase
endfunction : build_phase
