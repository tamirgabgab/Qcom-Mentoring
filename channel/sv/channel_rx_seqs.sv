//------------------------------------------------------------------------------
// channel_rx_seqs.sv -- sequence library of the Channel UVC
//------------------------------------------------------------------------------

class channel_rx_base_seq extends uvm_sequence #(channel_packet);

  `uvm_object_utils(channel_rx_base_seq)

  function new(string name = "channel_rx_base_seq");
    super.new(name);
  endfunction : new

endclass : channel_rx_base_seq


// channel_rx_resp_seq: respond forever with a random delay per packet.
// It deliberately does NOT raise an objection: a receiver must never keep the
// simulation alive on its own.
class channel_rx_resp_seq extends channel_rx_base_seq;

  `uvm_object_utils(channel_rx_resp_seq)

  function new(string name = "channel_rx_resp_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing channel_rx_resp_seq (forever)", UVM_LOW)
    forever begin
      `uvm_do(req)
    end
  endtask : body

endclass : channel_rx_resp_seq


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
