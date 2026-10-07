//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- Lab 3: the monitor shell (no interface yet)
//
// Monitors do NOT take a type parameter: uvm_monitor is a plain component.
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

endclass : yapp_tx_monitor

//------------------------------------------------------------------------------
// yapp_tx_monitor -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task yapp_tx_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "Inside the monitor run_phase", UVM_LOW)
endtask : run_phase
