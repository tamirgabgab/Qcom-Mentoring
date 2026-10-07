//------------------------------------------------------------------------------
// channel_rx_sequencer.sv
//------------------------------------------------------------------------------
class channel_rx_sequencer extends uvm_sequencer #(channel_packet);

  `uvm_component_utils(channel_rx_sequencer)

  extern function new(string name, uvm_component parent);

endclass : channel_rx_sequencer

//------------------------------------------------------------------------------
// channel_rx_sequencer -- method implementations
//------------------------------------------------------------------------------

function channel_rx_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
