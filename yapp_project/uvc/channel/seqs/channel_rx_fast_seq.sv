//------------------------------------------------------------------------------
// channel_rx_fast_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// channel_rx_fast_seq: respond immediately (delay == 0) -- handy for debugging
class channel_rx_fast_seq extends channel_rx_base_seq;

  `uvm_object_utils(channel_rx_fast_seq)

  function new(string name = "channel_rx_fast_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing channel_rx_fast_seq (forever)", UVM_LOW)
    forever begin
      `uvm_do_with(req, { req.delay == 0; })
    end
  endtask : body

endclass : channel_rx_fast_seq
