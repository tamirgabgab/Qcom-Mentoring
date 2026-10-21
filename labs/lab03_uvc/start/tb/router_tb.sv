// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/tb/router_tb.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 3: instantiates the YAPP UVC)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env m_yapp;

  `uvm_component_utils(router_tb)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Optional: which component reports first / last and why?
  extern function void start_of_simulation_phase(uvm_phase phase);

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
  // TODO (Lab 3): write router_tb::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::start_of_simulation_phase(uvm_phase phase);
  // TODO (Lab 3): write router_tb::start_of_simulation_phase
endfunction : start_of_simulation_phase
