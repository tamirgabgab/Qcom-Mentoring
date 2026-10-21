// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/sv/yapp_tx_monitor.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- Lab 3: the monitor shell (no interface yet)
//
// Monitors do NOT take a type parameter: uvm_monitor is a plain component.
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  `uvm_component_utils(yapp_tx_monitor)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

  // Optional: which component reports first / last and why?
  extern function void start_of_simulation_phase(uvm_phase phase);

endclass : yapp_tx_monitor

//------------------------------------------------------------------------------
// yapp_tx_monitor -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task yapp_tx_monitor::run_phase(uvm_phase phase);
  // TODO (Lab 3): write yapp_tx_monitor::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
function void yapp_tx_monitor::start_of_simulation_phase(uvm_phase phase);
  // TODO (Lab 3): write yapp_tx_monitor::start_of_simulation_phase
endfunction : start_of_simulation_phase
