// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/sv/yapp_tx_driver.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_tx_driver.sv -- Lab 3: pulls packets from the sequencer and (for now)
// only prints them. The real pin wiggling arrives in Lab 6.
//------------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet);

  `uvm_component_utils(yapp_tx_driver)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

  extern task send_to_dut(yapp_packet pkt);

  // Optional: which component reports first / last and why?
  extern function void start_of_simulation_phase(uvm_phase phase);

endclass : yapp_tx_driver

//------------------------------------------------------------------------------
// yapp_tx_driver -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task yapp_tx_driver::run_phase(uvm_phase phase);
  // TODO (Lab 3): write yapp_tx_driver::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
task yapp_tx_driver::send_to_dut(yapp_packet pkt);
  // TODO (Lab 3): write yapp_tx_driver::send_to_dut
endtask : send_to_dut

//------------------------------------------------------------------------------
function void yapp_tx_driver::start_of_simulation_phase(uvm_phase phase);
  // TODO (Lab 3): write yapp_tx_driver::start_of_simulation_phase
endfunction : start_of_simulation_phase
