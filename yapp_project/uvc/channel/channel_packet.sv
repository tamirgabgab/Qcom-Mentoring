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

  `uvm_object_utils(channel_packet)

  // Printing, copying, comparing, packing and recording are written by hand
  // (do_print / do_copy / do_compare / do_pack / do_unpack / do_record below):
  // no uvm_field_* automation.
  extern virtual function void do_copy(uvm_object rhs);
  extern virtual function bit  do_compare(uvm_object rhs, uvm_comparer comparer);
  extern virtual function void do_print(uvm_printer printer);
  extern virtual function void do_pack(uvm_packer packer);
  extern virtual function void do_unpack(uvm_packer packer);
  extern virtual function void do_record(uvm_recorder recorder);
  extern function new(string name = "channel_packet");

  // Even parity over header and payload
  extern function bit [7:0] calc_parity();

endclass : channel_packet

//------------------------------------------------------------------------------
// channel_packet -- method implementations
//------------------------------------------------------------------------------

function channel_packet::new(string name = "channel_packet");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function bit [7:0] channel_packet::calc_parity();
  calc_parity = {length, addr};
  foreach (payload[i]) begin
    calc_parity ^= payload[i];
  end
endfunction : calc_parity

//------------------------------------------------------------------------------
function void channel_packet::do_copy(uvm_object rhs);
  channel_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a channel_packet")
  end
  super.do_copy(rhs);
  addr        = rhs_.addr;
  length      = rhs_.length;
  payload     = rhs_.payload;
  parity      = rhs_.parity;
  parity_type = rhs_.parity_type;
  delay       = rhs_.delay;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit channel_packet::do_compare(uvm_object rhs, uvm_comparer comparer);
  channel_packet rhs_;
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
  do_compare &= comparer.compare_field_int("delay", delay, rhs_.delay, $bits(delay), UVM_DEC);
endfunction : do_compare

//------------------------------------------------------------------------------
function void channel_packet::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("addr", addr, $bits(addr), UVM_HEX);
  printer.print_field("length", length, $bits(length), UVM_DEC);
  printer.print_array_header("payload", payload.size());
  foreach (payload[i]) begin
    printer.print_field($sformatf("[%0d]", i), payload[i], $bits(payload[i]), UVM_HEX, "[");
  end
  printer.print_array_footer(payload.size());
  printer.print_field("parity", parity, $bits(parity), UVM_HEX);
  printer.print_generic("parity_type", "channel_parity_type_e", $bits(parity_type), parity_type.name());
  printer.print_field("delay", delay, $bits(delay), UVM_DEC);
endfunction : do_print

//------------------------------------------------------------------------------
function void channel_packet::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(addr, $bits(addr));
  packer.pack_field_int(length, $bits(length));
  packer.pack_field_int(payload.size(), 32);
  foreach (payload[i]) begin
    packer.pack_field_int(payload[i], $bits(payload[i]));
  end
  packer.pack_field_int(parity, $bits(parity));
  packer.pack_field_int(parity_type, $bits(parity_type));
  packer.pack_field_int(delay, $bits(delay));
endfunction : do_pack

//------------------------------------------------------------------------------
function void channel_packet::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  addr = packer.unpack_field_int($bits(addr));
  length = packer.unpack_field_int($bits(length));
  payload = new[packer.unpack_field_int(32)];
  foreach (payload[i]) begin
    payload[i] = packer.unpack_field_int($bits(payload[i]));
  end
  parity = packer.unpack_field_int($bits(parity));
  parity_type = channel_parity_type_e'(packer.unpack_field_int($bits(parity_type)));
  delay = packer.unpack_field_int($bits(delay));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void channel_packet::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("addr", addr, $bits(addr), UVM_HEX);
  recorder.record_field("length", length, $bits(length), UVM_DEC);
  foreach (payload[i]) begin
    recorder.record_field($sformatf("payload[%0d]", i), payload[i], $bits(payload[i]), UVM_HEX);
  end
  recorder.record_field("parity", parity, $bits(parity), UVM_HEX);
  recorder.record_string("parity_type", parity_type.name());
  recorder.record_field("delay", delay, $bits(delay), UVM_DEC);
endfunction : do_record
