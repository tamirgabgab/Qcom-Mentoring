//------------------------------------------------------------------------------
// clock_and_reset_sequencer.sv
//------------------------------------------------------------------------------
class clock_and_reset_sequencer extends uvm_sequencer #(clock_and_reset_transaction);

  `uvm_component_utils(clock_and_reset_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : clock_and_reset_sequencer
