//------------------------------------------------------------------------------
// monitor_example.sv -- code supplied for Lab 6 (NOT compiled: copy the pieces
// you need into yapp_tx_monitor.sv and make sure you understand each one)
//------------------------------------------------------------------------------

  // 1. The virtual interface handle
  virtual interface yapp_if vif;

  // 2. Fetch it from the configuration database
  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  // 3. Collect packets forever. A NEW packet object is created for every
  //    packet: later labs hand the object to other components that keep it.
  task collect_packets();
    yapp_packet pkt;
    @(posedge vif.clock);
    wait (vif.reset === 1'b0);
    forever begin
      pkt = yapp_packet::type_id::create("pkt", this);
      vif.collect_packets(pkt.addr, pkt.length, pkt.payload, pkt.parity);
      void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_LOW)
      end_tr(pkt);
    end
  endtask : collect_packets
