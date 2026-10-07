//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 4: built through the factory)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env yapp;

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

function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)
  // type_id::create() instead of new(): a test can now override the type
  yapp = yapp_env::type_id::create("yapp", this);
endfunction : build_phase
