//------------------------------------------------------------------------------
// channel_rx_driver.sv -- plays the receiver on one output channel
//------------------------------------------------------------------------------
class channel_rx_driver extends uvm_driver #(channel_packet);

  virtual interface channel_if vif;
  int channel_id;

  `uvm_component_utils(channel_rx_driver)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern virtual function void build_phase(uvm_phase phase);
endclass : channel_rx_driver

//------------------------------------------------------------------------------
// channel_rx_driver -- method implementations
//------------------------------------------------------------------------------

function void channel_rx_driver::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_channel_id;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "channel_id", cfg_channel_id)) channel_id = cfg_channel_id;
endfunction : build_phase

//------------------------------------------------------------------------------
function channel_rx_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void channel_rx_driver::connect_phase(uvm_phase phase);
  if (!channel_vif_config::get(this, "", "vif", vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task channel_rx_driver::run_phase(uvm_phase phase);
  // Keep the channel suspended until reset is released
  vif.channel_reset();
  wait (vif.reset === 1'b0);
  forever begin
    seq_item_port.get_next_item(req);
    vif.receive_packet(req.delay);
    seq_item_port.item_done();
  end
endtask : run_phase

//------------------------------------------------------------------------------
function void channel_rx_driver::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("channel_id", channel_id, $bits(channel_id), UVM_DEC);
endfunction : do_print
