// START POINT of Lab 2: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab02_test/tb/router_tb.sv; the lab page explains every step.
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
  // TODO (Lab 2): write router_tb::build_phase
endfunction : build_phase
