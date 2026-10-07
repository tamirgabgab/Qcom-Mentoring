//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 2)
//
// For now it is empty: the point of this lab is the component hierarchy
// (test -> testbench) and the phases that build it.
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  `uvm_component_utils(router_tb)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : router_tb

//------------------------------------------------------------------------------
// router_tb -- method implementations
//------------------------------------------------------------------------------

function router_tb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)
endfunction : build_phase
