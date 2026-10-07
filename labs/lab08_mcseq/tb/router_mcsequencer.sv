//------------------------------------------------------------------------------
// router_mcsequencer.sv -- multichannel (virtual) sequencer (Lab 8)
//
// It drives no interface itself: it only holds handles to the sequencers it
// coordinates. A multichannel sequence runs on it and starts sub-sequences on
// those handles. The Channel UVCs run a fixed response sequence and the
// Clock & Reset UVC is left out to keep things simple.
//------------------------------------------------------------------------------
class router_mcsequencer extends uvm_sequencer;

  hbus_master_sequencer hbus_seqr;   // assigned by router_tb in connect_phase
  yapp_tx_sequencer     yapp_seqr;

  `uvm_component_utils(router_mcsequencer)

  extern function new(string name, uvm_component parent);

endclass : router_mcsequencer

//------------------------------------------------------------------------------
// router_mcsequencer -- method implementations
//------------------------------------------------------------------------------

function router_mcsequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new
