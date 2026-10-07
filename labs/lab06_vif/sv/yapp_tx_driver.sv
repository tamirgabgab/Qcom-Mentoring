//------------------------------------------------------------------------------
// yapp_tx_driver.sv -- pulls packets from the sequencer and drives the
// YAPP input port through the virtual interface (Lab 3 skeleton, Lab 6 protocol)
//------------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet);

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if vif;

  // Statistics
  int num_sent;

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

function void yapp_tx_driver::connect_phase(uvm_phase phase);
  if (!yapp_vif_config::get(this, "", "vif", vif))
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : connect_phase

task yapp_tx_driver::run_phase(uvm_phase phase);
  reset_signals();
  get_and_drive();
endtask : run_phase

task yapp_tx_driver::reset_signals();
  vif.yapp_reset();
  wait (vif.reset === 1'b0);
endtask : reset_signals

task yapp_tx_driver::get_and_drive();
  forever begin
    seq_item_port.get_next_item(req);     // blocks until a sequence sends one
    send_to_dut(req);
    seq_item_port.item_done();            // unblocks the sequence
  end
endtask : get_and_drive

task yapp_tx_driver::send_to_dut(yapp_packet pkt);
  void'(begin_tr(pkt, "Driver_YAPP_Packet"));   // transaction recording
  `uvm_info(get_type_name(), $sformatf("Packet is \n%s", pkt.sprint()), UVM_LOW)
  vif.send_to_dut(pkt.addr, pkt.length, pkt.payload, pkt.parity, pkt.packet_delay);
  num_sent++;
  end_tr(pkt);
endtask : send_to_dut

function void yapp_tx_driver::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("YAPP driver report: %0d packets sent", num_sent), UVM_LOW)
endfunction : report_phase

function void yapp_tx_driver::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_sent", num_sent, $bits(num_sent), UVM_DEC);
endfunction : do_print
