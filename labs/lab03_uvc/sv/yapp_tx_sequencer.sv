//------------------------------------------------------------------------------
// yapp_tx_sequencer.sv -- arbitrates yapp_packet items towards the driver (Lab 3)
//
// Nothing to add: uvm_sequencer #(T) already contains the whole machinery.
//------------------------------------------------------------------------------
class yapp_tx_sequencer extends uvm_sequencer #(yapp_packet);

  `uvm_component_utils(yapp_tx_sequencer)

  extern function new(string name, uvm_component parent);

  // Optional: which component reports first / last and why?
  extern function void start_of_simulation_phase(uvm_phase phase);

endclass : yapp_tx_sequencer

//------------------------------------------------------------------------------
// yapp_tx_sequencer -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void yapp_tx_sequencer::start_of_simulation_phase(uvm_phase phase);
  `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
endfunction : start_of_simulation_phase
