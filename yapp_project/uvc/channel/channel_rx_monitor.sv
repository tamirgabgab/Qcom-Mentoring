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

  `uvm_component_utils(channel_rx_monitor)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function void report_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
endclass : channel_rx_monitor

//------------------------------------------------------------------------------
// channel_rx_monitor -- method implementations
//------------------------------------------------------------------------------

function void channel_rx_monitor::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_channel_id;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "channel_id", cfg_channel_id)) channel_id = cfg_channel_id;
endfunction : build_phase

//------------------------------------------------------------------------------
function channel_rx_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  item_collected_port = new("item_collected_port", this);
endfunction : new

//------------------------------------------------------------------------------
function void channel_rx_monitor::connect_phase(uvm_phase phase);
  if (!channel_vif_config::get(this, "", "vif", vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task channel_rx_monitor::run_phase(uvm_phase phase);
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
    if (pkt.addr != channel_id) begin
      `uvm_error(get_type_name(),
                 $sformatf("Packet with address %0d received on channel %0d",
                           pkt.addr, channel_id))
    end
    item_collected_port.write(pkt);
  end
endtask : run_phase

//------------------------------------------------------------------------------
function void channel_rx_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
            $sformatf("Channel %0d report: %0d packets collected", channel_id, num_pkt_col),
            UVM_LOW)
endfunction : report_phase

//------------------------------------------------------------------------------
function void channel_rx_monitor::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("channel_id", channel_id, $bits(channel_id), UVM_DEC);
  printer.print_field("num_pkt_col", num_pkt_col, $bits(num_pkt_col), UVM_DEC);
endfunction : do_print
