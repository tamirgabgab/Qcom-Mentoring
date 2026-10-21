// START POINT of Lab 4: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab04_factory/tb/router_tb.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 4: built through the factory)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env m_yapp;

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
  // type_id::create() instead of new(): a test can now override the type
  // TODO (Lab 4): write router_tb::build_phase
endfunction : build_phase
