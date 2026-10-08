//------------------------------------------------------------------------------
// channel_rx_slow_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// channel_rx_slow_seq: a receiver that answers late (20..40 cycles after the
// header appears). A packet longer than the 16-byte channel FIFO then fills it
// before the receiver starts to read, and the router has to stall its input
// with in_suspend: the back-pressure path of the YAPP handshake.
// Like channel_rx_resp_seq it never raises an objection.
//------------------------------------------------------------------------------
class channel_rx_slow_seq extends channel_rx_base_seq;

  `uvm_object_utils(channel_rx_slow_seq)

  extern function new(string name = "channel_rx_slow_seq");
  extern task body();

endclass : channel_rx_slow_seq

//------------------------------------------------------------------------------
// channel_rx_slow_seq -- method implementations
//------------------------------------------------------------------------------

function channel_rx_slow_seq::new(string name = "channel_rx_slow_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task channel_rx_slow_seq::body();
  `uvm_info(get_type_name(), "Executing channel_rx_slow_seq (forever, delay 20..40)", UVM_LOW)
  forever begin
    req = channel_packet::type_id::create("req");
    req.c_delay.constraint_mode(0);         // the packet's own 0..10 limit is too fast here
    start_item(req);
    if (!req.randomize() with { req.delay inside {[20:40]}; }) begin
      `uvm_error(get_type_name(), "req.randomize() failed")
    end
    finish_item(req);
  end
endtask : body
