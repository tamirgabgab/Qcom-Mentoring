//------------------------------------------------------------------------------
// channel_rx_sequencer.sv
//------------------------------------------------------------------------------
class channel_rx_sequencer extends uvm_sequencer #(channel_packet);

  `uvm_component_utils(channel_rx_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : channel_rx_sequencer
