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

  `uvm_component_utils(channel_env)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : channel_env

//------------------------------------------------------------------------------
// channel_env -- method implementations
//------------------------------------------------------------------------------

function channel_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void channel_env::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_channel_id;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "channel_id", cfg_channel_id)) begin
    channel_id = cfg_channel_id;
  end
  uvm_config_int::set(this, "rx_agent", "channel_id", channel_id);
  rx_agent = channel_rx_agent::type_id::create("rx_agent", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void channel_env::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("channel_id", channel_id, $bits(channel_id), UVM_DEC);
endfunction : do_print
