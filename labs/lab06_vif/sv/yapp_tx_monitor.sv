//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- observes packets on the YAPP input port (Lab 6)
//
// The monitor reaches the DUT pins through a VIRTUAL INTERFACE handle that
// tb_top stores in the configuration database and connect_phase() fetches.
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if vif;

  // Statistics
  int num_pkt_col;

  `uvm_component_utils_begin(yapp_tx_monitor)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    // get() returns 1 on success: always check it, a missing vif is fatal later
    if (!yapp_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "YAPP monitor running", UVM_LOW)
    collect_packets();
  endtask : run_phase

  task collect_packets();
    yapp_packet pkt;
    // Nothing to observe while reset is active
    @(posedge vif.clock);
    wait (vif.reset === 1'b0);
    forever begin
      pkt = yapp_packet::type_id::create("pkt", this);
      vif.collect_packets(pkt.addr, pkt.length, pkt.payload, pkt.parity);
      void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      num_pkt_col++;
      `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_LOW)
      end_tr(pkt);
    end
  endtask : collect_packets

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
              $sformatf("YAPP monitor report: %0d packets collected", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass : yapp_tx_monitor
