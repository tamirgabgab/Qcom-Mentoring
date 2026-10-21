//------------------------------------------------------------------------------
// short_packet_test.sv -- short_packet_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// short_packet_test (Lab 4)
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
  set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
  super.build_phase(phase);
endfunction : build_phase
