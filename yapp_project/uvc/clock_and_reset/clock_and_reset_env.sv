//------------------------------------------------------------------------------
// clock_and_reset_env.sv -- UVC top level
//------------------------------------------------------------------------------
class clock_and_reset_env extends uvm_env;

  clock_and_reset_agent agent;

  `uvm_component_utils(clock_and_reset_env)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : clock_and_reset_env

//------------------------------------------------------------------------------
// clock_and_reset_env -- method implementations
//------------------------------------------------------------------------------

function clock_and_reset_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void clock_and_reset_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  agent = clock_and_reset_agent::type_id::create("agent", this);
endfunction : build_phase
