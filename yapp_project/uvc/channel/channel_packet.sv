//------------------------------------------------------------------------------
// channel_packet.sv -- packet as seen on a router output channel
//
// Same fields as a YAPP packet (so the scoreboard can compare them) plus a
// `delay` knob that the receiver uses as its response delay. The data fields
// are filled in by the monitor; sequences only randomize `delay`.
//------------------------------------------------------------------------------
class channel_packet extends uvm_sequence_item;

  // Packet contents (observed)
  bit[1:0]  m_addr;
  bit[5:0]  m_length;
  bit[7:0]  m_payload[];
  bit[7:0]  m_parity;
  channel_parity_type_e m_parity_type;

  // Receiver response delay (randomized by channel_rx_resp_seq)
  rand int   m_delay;

  `uvm_object_utils(channel_packet)

  extern constraint c_delay;

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
  extern function bit[7:0] calc_parity();

  // "good" / "bad" for the one-line log messages
  extern function string parity_text();

endclass : channel_packet

//------------------------------------------------------------------------------
// channel_packet -- constraints
//------------------------------------------------------------------------------

constraint channel_packet::c_delay {
  m_delay inside {[0:10]};
}

//------------------------------------------------------------------------------
// channel_packet -- method implementations
//------------------------------------------------------------------------------

function channel_packet::new(string name = "channel_packet");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function bit[7:0] channel_packet::calc_parity();
  calc_parity = {m_length, m_addr};
  foreach (m_payload[i]) begin
    calc_parity ^= m_payload[i];
  end
endfunction : calc_parity

//------------------------------------------------------------------------------
function string channel_packet::parity_text();
  if (m_parity_type == CHANNEL_PARITY_TYPE_GOOD) begin
    return "good";
  end
  return "bad";
endfunction : parity_text

//------------------------------------------------------------------------------
function void channel_packet::do_copy(uvm_object rhs);
  channel_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a channel_packet")
  end
  super.do_copy(rhs);
  m_addr        = rhs_.m_addr;
  m_length      = rhs_.m_length;
  m_payload     = rhs_.m_payload;
  m_parity      = rhs_.m_parity;
  m_parity_type = rhs_.m_parity_type;
  m_delay       = rhs_.m_delay;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit channel_packet::do_compare(uvm_object rhs, uvm_comparer comparer);
  channel_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    return 0;
  end
  do_compare = super.do_compare(rhs, comparer);
  do_compare &= comparer.compare_field_int("addr", m_addr, rhs_.m_addr, $bits(m_addr), UVM_HEX);
  do_compare &= comparer.compare_field_int("length", m_length, rhs_.m_length, $bits(m_length), UVM_DEC);
  do_compare &= comparer.compare_field_int("payload.size()", m_payload.size(), rhs_.m_payload.size(), 32, UVM_DEC);
  foreach (m_payload[i]) begin
    if (i < rhs_.m_payload.size()) begin
      do_compare &= comparer.compare_field_int($sformatf("payload[%0d]", i), m_payload[i], rhs_.m_payload[i], $bits(m_payload[i]), UVM_HEX);
    end
  end
  do_compare &= comparer.compare_field_int("parity", m_parity, rhs_.m_parity, $bits(m_parity), UVM_HEX);
  do_compare &= comparer.compare_field_int("parity_type", m_parity_type, rhs_.m_parity_type, $bits(m_parity_type));
  do_compare &= comparer.compare_field_int("delay", m_delay, rhs_.m_delay, $bits(m_delay), UVM_DEC);
endfunction : do_compare

//------------------------------------------------------------------------------
function void channel_packet::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("addr", m_addr, $bits(m_addr), UVM_HEX);
  printer.print_field("length", m_length, $bits(m_length), UVM_DEC);
  printer.print_array_header("payload", m_payload.size());
  foreach (m_payload[i]) begin
    printer.print_field($sformatf("[%0d]", i), m_payload[i], $bits(m_payload[i]), UVM_HEX, "[");
  end
  printer.print_array_footer(m_payload.size());
  printer.print_field("parity", m_parity, $bits(m_parity), UVM_HEX);
  printer.print_generic("parity_type", "channel_parity_type_e", $bits(m_parity_type), m_parity_type.name());
  printer.print_field("delay", m_delay, $bits(m_delay), UVM_DEC);
endfunction : do_print

//------------------------------------------------------------------------------
function void channel_packet::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(m_addr, $bits(m_addr));
  packer.pack_field_int(m_length, $bits(m_length));
  packer.pack_field_int(m_payload.size(), 32);
  foreach (m_payload[i]) begin
    packer.pack_field_int(m_payload[i], $bits(m_payload[i]));
  end
  packer.pack_field_int(m_parity, $bits(m_parity));
  packer.pack_field_int(m_parity_type, $bits(m_parity_type));
  packer.pack_field_int(m_delay, $bits(m_delay));
endfunction : do_pack

//------------------------------------------------------------------------------
function void channel_packet::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  m_addr = packer.unpack_field_int($bits(m_addr));
  m_length = packer.unpack_field_int($bits(m_length));
  m_payload = new[packer.unpack_field_int(32)];
  foreach (m_payload[i]) begin
    m_payload[i] = packer.unpack_field_int($bits(m_payload[i]));
  end
  m_parity = packer.unpack_field_int($bits(m_parity));
  m_parity_type = channel_parity_type_e'(packer.unpack_field_int($bits(m_parity_type)));
  m_delay = packer.unpack_field_int($bits(m_delay));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void channel_packet::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("addr", m_addr, $bits(m_addr), UVM_HEX);
  recorder.record_field("length", m_length, $bits(m_length), UVM_DEC);
  foreach (m_payload[i]) begin
    recorder.record_field($sformatf("payload[%0d]", i), m_payload[i], $bits(m_payload[i]), UVM_HEX);
  end
  recorder.record_field("parity", m_parity, $bits(m_parity), UVM_HEX);
  recorder.record_string("parity_type", m_parity_type.name());
  recorder.record_field("delay", m_delay, $bits(m_delay), UVM_DEC);
endfunction : do_record
