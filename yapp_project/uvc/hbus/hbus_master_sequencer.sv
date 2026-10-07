//------------------------------------------------------------------------------
// hbus_master_sequencer.sv
//------------------------------------------------------------------------------
class hbus_master_sequencer extends uvm_sequencer #(hbus_transaction);

  `uvm_component_utils(hbus_master_sequencer)

  extern function new(string name, uvm_component parent);

endclass : hbus_master_sequencer

//------------------------------------------------------------------------------
// hbus_master_sequencer -- method implementations
//------------------------------------------------------------------------------

function hbus_master_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
