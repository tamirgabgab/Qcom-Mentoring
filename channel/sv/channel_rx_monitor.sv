//------------------------------------------------------------------------------
// channel_rx_monitor.sv -- observes packets leaving the router on one channel
//
// Every collected packet is published on `item_collected_port` (Lab 9A
// connects this to the scoreboard).
//------------------------------------------------------------------------------
class channel_rx_monitor extends uvm_monitor;

  virtual interface channel_if vif;
  int channel_id;

  // Published to whoever is interested (scoreboard, coverage, ...)
  uvm_analysis_port #(channel_packet) item_collected_port;

  // Statistics
  int num_pkt_col;

  `uvm_component_utils_begin(channel_rx_monitor)
    `uvm_field_int(channel_id, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!channel_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    channel_packet pkt;
    @(posedge vif.clock);
    wait (vif.reset === 1'b0);
    forever begin
      // A NEW object for every packet: analysis FIFOs (Lab 9D) do not clone
      pkt = channel_packet::type_id::create("pkt", this);
      vif.collect_packet(pkt.addr, pkt.length, pkt.payload, pkt.parity);
      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? CHANNEL_GOOD_PARITY
                                                          : CHANNEL_BAD_PARITY;
      num_pkt_col++;
      `uvm_info(get_type_name(),
                $sformatf("Channel %0d collected packet:\n%s", channel_id, pkt.sprint()),
                UVM_LOW)
      if (pkt.addr != channel_id)
        `uvm_error(get_type_name(),
                   $sformatf("Packet with address %0d received on channel %0d",
                             pkt.addr, channel_id))
      item_collected_port.write(pkt);
    end
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
              $sformatf("Channel %0d report: %0d packets collected", channel_id, num_pkt_col),
              UVM_LOW)
  endfunction : report_phase

endclass : channel_rx_monitor
