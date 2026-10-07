//------------------------------------------------------------------------------
// yapp_tx_driver.sv -- pulls packets from the sequencer and drives the
// YAPP input port through the virtual interface (Lab 3 skeleton, Lab 6 protocol)
//------------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet);

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if vif;

  // Statistics
  int num_sent;

  `uvm_component_utils_begin(yapp_tx_driver)
    `uvm_field_int(num_sent, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    reset_signals();
    get_and_drive();
  endtask : run_phase

  // Drive idle values and stay quiet while reset is active
  task reset_signals();
    vif.yapp_reset();
    wait (vif.reset === 1'b0);
  endtask : reset_signals

  // The classic driver loop
  task get_and_drive();
    forever begin
      seq_item_port.get_next_item(req);     // blocks until a sequence sends one
      send_to_dut(req);
      seq_item_port.item_done();            // unblocks the sequence
    end
  endtask : get_and_drive

  task send_to_dut(yapp_packet pkt);
    void'(begin_tr(pkt, "Driver_YAPP_Packet"));   // transaction recording
    `uvm_info(get_type_name(), $sformatf("Packet is \n%s", pkt.sprint()), UVM_LOW)
    vif.send_to_dut(pkt.addr, pkt.length, pkt.payload, pkt.parity, pkt.packet_delay);
    num_sent++;
    end_tr(pkt);
  endtask : send_to_dut

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("YAPP driver report: %0d packets sent", num_sent), UVM_LOW)
  endfunction : report_phase

endclass : yapp_tx_driver
