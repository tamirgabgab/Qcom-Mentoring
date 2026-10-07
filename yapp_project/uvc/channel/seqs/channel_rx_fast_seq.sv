//------------------------------------------------------------------------------
// channel_rx_fast_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// channel_rx_fast_seq: respond immediately (delay == 0) -- handy for debugging
class channel_rx_fast_seq extends channel_rx_base_seq;

  `uvm_object_utils(channel_rx_fast_seq)

  extern function new(string name = "channel_rx_fast_seq");
  extern task body();

endclass : channel_rx_fast_seq

//------------------------------------------------------------------------------
// channel_rx_fast_seq -- method implementations
//------------------------------------------------------------------------------

function channel_rx_fast_seq::new(string name = "channel_rx_fast_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task channel_rx_fast_seq::body();
  `uvm_info(get_type_name(), "Executing channel_rx_fast_seq (forever)", UVM_LOW)
  forever begin
    req = channel_packet::type_id::create("req");
    start_item(req);
    if (!req.randomize() with { req.delay == 0; }) begin
      `uvm_error(get_type_name(), "req.randomize() failed")
    end
    finish_item(req);
  end
endtask : body
