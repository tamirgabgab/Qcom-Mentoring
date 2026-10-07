//------------------------------------------------------------------------------
// yapp_tx_sequencer.sv -- arbitrates yapp_packet items towards the driver (Lab 3)
//
// Nothing to add: uvm_sequencer #(T) already contains the whole machinery.
//------------------------------------------------------------------------------
class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);

  `uvm_component_utils(yapp_tx_sequencer)

  extern function new(string name, uvm_component parent);

endclass : yapp_tx_sequencer

//------------------------------------------------------------------------------
// yapp_tx_sequencer -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
