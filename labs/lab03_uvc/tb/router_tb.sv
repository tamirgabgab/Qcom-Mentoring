//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 3: instantiates the YAPP UVC)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env yapp;

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

function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)
  yapp = new("yapp", this);
endfunction : build_phase

function void router_tb::start_of_simulation_phase(uvm_phase phase);
  `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
endfunction : start_of_simulation_phase
