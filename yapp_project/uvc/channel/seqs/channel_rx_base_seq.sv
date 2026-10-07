//------------------------------------------------------------------------------
// channel_rx_base_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

class channel_rx_base_seq extends uvm_sequence #(channel_packet);

  `uvm_object_utils(channel_rx_base_seq)

  extern function new(string name = "channel_rx_base_seq");

endclass : channel_rx_base_seq

//------------------------------------------------------------------------------
// channel_rx_base_seq -- method implementations
//------------------------------------------------------------------------------

function channel_rx_base_seq::new(string name = "channel_rx_base_seq");
  super.new(name);
endfunction : new
