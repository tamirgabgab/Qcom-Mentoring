//------------------------------------------------------------------------------
// yapp_packet.sv -- the YAPP packet as a UVM sequence item (Lab 1)
//
//          7   6   5   4   3   2   1   0
//        +-----------------------+-------+
// byte 0 |      length[5:0]      | addr  |  header
//        +-----------------------+-------+
// byte 1 |          payload[0]           |  \
//        |             ...               |   > N == length, 1..63 bytes
// byte N |         payload[N-1]          |  /
//        +-------------------------------+
// byte N+1 |          parity             |  even bitwise parity (XOR) of header and payload
//        +-------------------------------+
//   figure: docs/assets/packet_structure.svg (see README.md in this directory)
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

  `uvm_object_utils(yapp_packet)

  // Printing, copying, comparing, packing and recording are written by hand
  // (do_print / do_copy / do_compare / do_pack / do_unpack / do_record below):
  // no uvm_field_* automation.
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_pack(uvm_packer packer);
  extern virtual function void do_unpack(uvm_packer packer);
  extern virtual function void do_record(uvm_recorder recorder);

  // Constraints (named so sequences can switch them off)
  constraint c_addr_legal  { addr != 2'd3; }
  constraint c_length      { length inside {[1:63]}; payload.size() == length; }
  constraint c_parity_dist { parity_type dist { GOOD_PARITY := 5, BAD_PARITY := 1 }; }
  constraint c_delay       { packet_delay inside {[1:20]}; }

  extern function new(string name = "yapp_packet");

  // Correct parity: XOR of header and every payload byte
  extern function bit [7:0] calc_parity();

  // Write the parity byte according to the parity_type knob.
  // A bad parity flips one random bit of the correct value.
  extern function void set_parity();

  // Called automatically after every successful randomize()
  extern function void post_randomize();

endclass : yapp_packet

//------------------------------------------------------------------------------
// yapp_packet -- method implementations
//------------------------------------------------------------------------------

function yapp_packet::new(string name = "yapp_packet");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function bit [7:0] yapp_packet::calc_parity();
  calc_parity = {length, addr};
  foreach (payload[i]) calc_parity ^= payload[i];
endfunction : calc_parity

//------------------------------------------------------------------------------
function void yapp_packet::set_parity();
  parity = calc_parity();
  if (parity_type == BAD_PARITY) begin
    parity[$urandom_range(7, 0)] = ~parity[$urandom_range(7, 0)];
  end
endfunction : set_parity

//------------------------------------------------------------------------------
function void yapp_packet::post_randomize();
  set_parity();
endfunction : post_randomize

//------------------------------------------------------------------------------
function void yapp_packet::do_copy(uvm_object rhs);
  yapp_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a yapp_packet")
  end
  super.do_copy(rhs);
  addr         = rhs_.addr;
  length       = rhs_.length;
  payload      = rhs_.payload;
  parity       = rhs_.parity;
  parity_type  = rhs_.parity_type;
  packet_delay = rhs_.packet_delay;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit yapp_packet::do_compare(uvm_object rhs, uvm_comparer comparer);
  yapp_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    return 0;
  end
  do_compare = super.do_compare(rhs, comparer);
  do_compare &= comparer.compare_field_int("addr", addr, rhs_.addr, $bits(addr), UVM_HEX);
  do_compare &= comparer.compare_field_int("length", length, rhs_.length, $bits(length), UVM_DEC);
  do_compare &= comparer.compare_field_int("payload.size()", payload.size(), rhs_.payload.size(), 32, UVM_DEC);
  foreach (payload[i]) begin
    if (i < rhs_.payload.size()) begin
      do_compare &= comparer.compare_field_int($sformatf("payload[%0d]", i), payload[i], rhs_.payload[i], $bits(payload[i]), UVM_HEX);
    end
  end
  do_compare &= comparer.compare_field_int("parity", parity, rhs_.parity, $bits(parity), UVM_HEX);
  do_compare &= comparer.compare_field_int("parity_type", parity_type, rhs_.parity_type, $bits(parity_type));
endfunction : do_compare

//------------------------------------------------------------------------------
function void yapp_packet::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("addr", addr, $bits(addr), UVM_HEX);
  printer.print_field("length", length, $bits(length), UVM_DEC);
  printer.print_array_header("payload", payload.size());
  foreach (payload[i]) begin
    printer.print_field($sformatf("[%0d]", i), payload[i], $bits(payload[i]), UVM_HEX, "[");
  end
  printer.print_array_footer(payload.size());
  printer.print_field("parity", parity, $bits(parity), UVM_HEX);
  printer.print_generic("parity_type", "parity_type_e", $bits(parity_type), parity_type.name());
  printer.print_field("packet_delay", packet_delay, $bits(packet_delay), UVM_DEC);
endfunction : do_print

//------------------------------------------------------------------------------
function void yapp_packet::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(addr, $bits(addr));
  packer.pack_field_int(length, $bits(length));
  packer.pack_field_int(payload.size(), 32);
  foreach (payload[i]) begin
    packer.pack_field_int(payload[i], $bits(payload[i]));
  end
  packer.pack_field_int(parity, $bits(parity));
  packer.pack_field_int(parity_type, $bits(parity_type));
  packer.pack_field_int(packet_delay, $bits(packet_delay));
endfunction : do_pack

//------------------------------------------------------------------------------
function void yapp_packet::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  addr = packer.unpack_field_int($bits(addr));
  length = packer.unpack_field_int($bits(length));
  payload = new[packer.unpack_field_int(32)];
  foreach (payload[i]) begin
    payload[i] = packer.unpack_field_int($bits(payload[i]));
  end
  parity = packer.unpack_field_int($bits(parity));
  parity_type = parity_type_e'(packer.unpack_field_int($bits(parity_type)));
  packet_delay = packer.unpack_field_int($bits(packet_delay));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void yapp_packet::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("addr", addr, $bits(addr), UVM_HEX);
  recorder.record_field("length", length, $bits(length), UVM_DEC);
  foreach (payload[i]) begin
    recorder.record_field($sformatf("payload[%0d]", i), payload[i], $bits(payload[i]), UVM_HEX);
  end
  recorder.record_field("parity", parity, $bits(parity), UVM_HEX);
  recorder.record_string("parity_type", parity_type.name());
  recorder.record_field("packet_delay", packet_delay, $bits(packet_delay), UVM_DEC);
endfunction : do_record
