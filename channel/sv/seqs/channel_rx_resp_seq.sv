//------------------------------------------------------------------------------
// channel_rx_resp_seq.sv -- sequence library of the Channel UVC
// Split out of channel_rx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

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
