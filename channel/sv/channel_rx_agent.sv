//------------------------------------------------------------------------------
// channel_rx_agent.sv -- receiver agent: monitor always, driver+sequencer if active
//------------------------------------------------------------------------------
class channel_rx_agent extends uvm_agent;

  channel_rx_monitor   monitor;
  channel_rx_driver    driver;
  channel_rx_sequencer sequencer;
  int channel_id;

  `uvm_component_utils_begin(channel_rx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(channel_id, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Pass the channel id down to the children
    uvm_config_int::set(this, "*", "channel_id", channel_id);
    monitor = channel_rx_monitor::type_id::create("monitor", this);
    if (is_active == UVM_ACTIVE) begin
      driver    = channel_rx_driver::type_id::create("driver", this);
      sequencer = channel_rx_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : channel_rx_agent
