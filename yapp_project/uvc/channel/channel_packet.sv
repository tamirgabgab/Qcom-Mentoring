//------------------------------------------------------------------------------
// channel_packet.sv -- packet as seen on a router output channel
//
// Same fields as a YAPP packet (so the scoreboard can compare them) plus a
// `delay` knob that the receiver uses as its response delay. The data fields
// are filled in by the monitor; sequences only randomize `delay`.
//------------------------------------------------------------------------------
typedef enum { CHANNEL_GOOD_PARITY, CHANNEL_BAD_PARITY } channel_parity_type_e;

class channel_packet extends uvm_sequence_item;

  // Packet contents (observed)
  bit [1:0]  addr;
  bit [5:0]  length;
  bit [7:0]  payload[];
  bit [7:0]  parity;
  channel_parity_type_e parity_type;

  // Receiver response delay (randomized by channel_rx_resp_seq)
  rand int   delay;

  constraint c_delay { delay inside {[0:10]}; }

  `uvm_object_utils_begin(channel_packet)
    `uvm_field_int(addr,         UVM_ALL_ON)
    `uvm_field_int(length,       UVM_ALL_ON | UVM_DEC)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity,       UVM_ALL_ON)
    `uvm_field_enum(channel_parity_type_e, parity_type, UVM_ALL_ON)
    `uvm_field_int(delay,        UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "channel_packet");
    super.new(name);
  endfunction : new

  // Even parity over header and payload
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    foreach (payload[i]) calc_parity ^= payload[i];
  endfunction : calc_parity

endclass : channel_packet
