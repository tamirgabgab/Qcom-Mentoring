// START POINT of Lab 6: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab06_vif/sv/yapp_tx_driver.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_tx_driver.sv -- pulls packets from the sequencer and drives the
// YAPP input port through the virtual interface (Lab 3 skeleton, Lab 6 protocol)
//------------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet);

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if m_vif;

  // Statistics
  int m_num_sent;

  `uvm_component_utils(yapp_tx_driver)

  // The fields are printed by do_print() below:
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // Drive idle values and stay quiet while reset is active
  extern task reset_signals();

  // The classic driver loop
  extern task get_and_drive();
  extern task send_to_dut(yapp_packet pkt);

  extern function void report_phase(uvm_phase phase);

endclass : yapp_tx_driver

//------------------------------------------------------------------------------
// yapp_tx_driver -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_tx_driver::connect_phase(uvm_phase phase);
  // TODO (Lab 6): write yapp_tx_driver::connect_phase
endfunction : connect_phase

//------------------------------------------------------------------------------
task yapp_tx_driver::run_phase(uvm_phase phase);
  // TODO (Lab 6): write yapp_tx_driver::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
task yapp_tx_driver::reset_signals();
  // TODO (Lab 6): write yapp_tx_driver::reset_signals
endtask : reset_signals

//------------------------------------------------------------------------------
task yapp_tx_driver::get_and_drive();
  // TODO (Lab 6): write yapp_tx_driver::get_and_drive
endtask : get_and_drive

//------------------------------------------------------------------------------
task yapp_tx_driver::send_to_dut(yapp_packet pkt);
  // TODO (Lab 6): write yapp_tx_driver::send_to_dut
endtask : send_to_dut

//------------------------------------------------------------------------------
function void yapp_tx_driver::report_phase(uvm_phase phase);
  // TODO (Lab 6): write yapp_tx_driver::report_phase
endfunction : report_phase

//------------------------------------------------------------------------------
function void yapp_tx_driver::do_print(uvm_printer printer);
  super.do_print(printer);
  // TODO (Lab 6): write yapp_tx_driver::do_print
endfunction : do_print
