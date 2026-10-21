// START POINT of Lab 4: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab04_factory/sv/yapp_env.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_env.sv -- YAPP UVC top level (Lab 3)
//------------------------------------------------------------------------------
class yapp_env extends uvm_env;

  yapp_tx_agent m_agent;

  `uvm_component_utils(yapp_env)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : yapp_env

//------------------------------------------------------------------------------
// yapp_env -- method implementations
//------------------------------------------------------------------------------

function yapp_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // TODO (Lab 4): write yapp_env::build_phase
endfunction : build_phase
