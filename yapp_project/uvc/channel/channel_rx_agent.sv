//------------------------------------------------------------------------------
// channel_rx_agent.sv -- receiver agent: monitor always, driver+sequencer if active
//------------------------------------------------------------------------------
class channel_rx_agent extends uvm_agent;

  channel_rx_monitor   monitor;
  channel_rx_driver    driver;
  channel_rx_sequencer sequencer;
  int channel_id;

  `uvm_component_utils(channel_rx_agent)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : channel_rx_agent

//------------------------------------------------------------------------------
// channel_rx_agent -- method implementations
//------------------------------------------------------------------------------

function channel_rx_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void channel_rx_agent::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_is_active;
  uvm_bitstream_t cfg_channel_id;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) begin
    is_active = uvm_active_passive_enum'(cfg_is_active);
  end
  if (uvm_config_int::get(this, "", "channel_id", cfg_channel_id)) begin
    channel_id = cfg_channel_id;
  end
  // Pass the channel id down to the children
  uvm_config_int::set(this, "*", "channel_id", channel_id);
  monitor = channel_rx_monitor::type_id::create("monitor", this);
  if (is_active == UVM_ACTIVE) begin
    driver    = channel_rx_driver::type_id::create("driver", this);
    sequencer = channel_rx_sequencer::type_id::create("sequencer", this);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
function void channel_rx_agent::connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
function void channel_rx_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
  printer.print_field("channel_id", channel_id, $bits(channel_id), UVM_DEC);
endfunction : do_print
