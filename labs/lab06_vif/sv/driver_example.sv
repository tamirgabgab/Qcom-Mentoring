//------------------------------------------------------------------------------
// driver_example.sv -- code supplied for Lab 6 (NOT compiled: copy the pieces
// you need into yapp_tx_driver.sv and make sure you understand each one)
//------------------------------------------------------------------------------

  // 1. A handle to the interface. "virtual" = it is a pointer to an instance
  //    that lives in hw_top, not an interface of its own.
  virtual interface yapp_if vif;

  // 2. Fetch the handle from the configuration database. tb_top does the
  //    matching set() with a wildcard path so driver and monitor share it.
  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  // 3. run_phase: drive idle values during reset, then the classic loop
  task run_phase(uvm_phase phase);
    reset_signals();
    get_and_drive();
  endtask : run_phase

  task reset_signals();
    vif.yapp_reset();              // interface task: in_data = 0, in_data_vld = 0
    wait (vif.reset === 1'b0);     // stay quiet while reset is active
  endtask : reset_signals

  task get_and_drive();
    forever begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // 4. The protocol lives in the interface; the driver only hands over fields.
  //    begin_tr/end_tr give the packet a named transaction stream in the
  //    waveform viewer ("Driver_YAPP_Packet").
  task send_to_dut(yapp_packet pkt);
    void'(begin_tr(pkt, "Driver_YAPP_Packet"));
    `uvm_info(get_type_name(), $sformatf("Packet is \n%s", pkt.sprint()), UVM_LOW)
    vif.send_to_dut(pkt.addr, pkt.length, pkt.payload, pkt.parity, pkt.packet_delay);
    end_tr(pkt);
  endtask : send_to_dut
