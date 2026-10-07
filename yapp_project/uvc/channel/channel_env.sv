//------------------------------------------------------------------------------
// channel_env.sv -- Channel UVC top level
//
// Configure with:  uvm_config_int::set(this, "chan0", "channel_id", 0);
// The id is only used for messages and for checking that packets arrive on
// the channel they were addressed to.
//------------------------------------------------------------------------------
class channel_env extends uvm_env;

  channel_rx_agent rx_agent;
  int channel_id;

  `uvm_component_utils_begin(channel_env)
    `uvm_field_int(channel_id, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set(this, "rx_agent", "channel_id", channel_id);
    rx_agent = channel_rx_agent::type_id::create("rx_agent", this);
  endfunction : build_phase

endclass : channel_env
