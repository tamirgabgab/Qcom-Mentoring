//------------------------------------------------------------------------------
// channel_rx_base_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

class channel_rx_base_seq extends uvm_sequence #(channel_packet);

  `uvm_object_utils(channel_rx_base_seq)

  function new(string name = "channel_rx_base_seq");
    super.new(name);
  endfunction : new

endclass : channel_rx_base_seq
