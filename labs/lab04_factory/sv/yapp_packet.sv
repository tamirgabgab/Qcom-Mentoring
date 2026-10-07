//------------------------------------------------------------------------------
// yapp_packet.sv -- the YAPP packet as a UVM sequence item (Lab 1)
//
//   byte 0     header  {length[5:0], addr[1:0]}
//   byte 1..N  payload (N == length, 1..63 bytes)
//   byte N+1   parity  even bitwise parity (XOR) of header and payload
//
// Control knobs (not part of the packet on the wire):
//   parity_type  -- GOOD_PARITY / BAD_PARITY, decides what set_parity() writes
//   packet_delay -- idle clock cycles the driver inserts before the packet
//------------------------------------------------------------------------------

// Declared OUTSIDE the class so sequences and tests can use the literals
typedef enum { GOOD_PARITY, BAD_PARITY } parity_type_e;

class yapp_packet extends uvm_sequence_item;

  // Packet fields
  rand bit [1:0] addr;
  rand bit [5:0] length;
  rand bit [7:0] payload[];
       bit [7:0] parity;          // computed, never randomized directly

  // Control knobs
  rand parity_type_e parity_type;
  rand int           packet_delay;

  // Field automation: print / copy / compare / pack for free
  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int(addr,          UVM_ALL_ON)
    `uvm_field_int(length,        UVM_ALL_ON | UVM_DEC)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int(parity,        UVM_ALL_ON)
    `uvm_field_enum(parity_type_e, parity_type, UVM_ALL_ON)
    `uvm_field_int(packet_delay,  UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
  `uvm_object_utils_end

  // Constraints (named so sequences can switch them off)
  constraint c_addr_legal  { addr != 2'd3; }
  constraint c_length      { length inside {[1:63]}; payload.size() == length; }
  constraint c_parity_dist { parity_type dist { GOOD_PARITY := 5, BAD_PARITY := 1 }; }
  constraint c_delay       { packet_delay inside {[1:20]}; }

  function new(string name = "yapp_packet");
    super.new(name);
  endfunction : new

  // Correct parity: XOR of header and every payload byte
  function bit [7:0] calc_parity();
    calc_parity = {length, addr};
    foreach (payload[i]) calc_parity ^= payload[i];
  endfunction : calc_parity

  // Write the parity byte according to the parity_type knob.
  // A bad parity flips one random bit of the correct value.
  function void set_parity();
    parity = calc_parity();
    if (parity_type == BAD_PARITY)
      parity[$urandom_range(7, 0)] = ~parity[$urandom_range(7, 0)];
  endfunction : set_parity

  // Called automatically after every successful randomize()
  function void post_randomize();
    set_parity();
  endfunction : post_randomize

endclass : yapp_packet


//------------------------------------------------------------------------------
// short_yapp_packet (Lab 4): same packet, payload shorter than 15 bytes and
// never addressed to channel 2. Because it is a subclass, the factory can
// substitute it for every yapp_packet without touching the sequences.
//------------------------------------------------------------------------------
class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  constraint c_short_length { length < 15; }
  constraint c_no_addr2     { addr != 2'd2; }

  function new(string name = "short_yapp_packet");
    super.new(name);
  endfunction : new

endclass : short_yapp_packet
