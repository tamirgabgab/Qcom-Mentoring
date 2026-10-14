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
//   parity_type  -- PARITY_TYPE_GOOD / PARITY_TYPE_BAD, decides what set_parity() writes
//   packet_delay -- idle clock cycles the driver inserts before the packet
//------------------------------------------------------------------------------

class yapp_packet extends uvm_sequence_item;

  // Packet fields
  rand bit[1:0] m_addr;
  rand bit[5:0] m_length;
  rand bit[7:0] m_payload[];
       bit[7:0] m_parity;          // computed, never randomized directly

  // Control knobs
  rand parity_type_e m_parity_type;
  rand int           m_packet_delay;

  `uvm_object_utils(yapp_packet)

  // Constraints (named so sequences can switch them off)
  extern constraint c_addr_legal;
  extern constraint c_length;
  extern constraint c_parity_defined;
  extern constraint c_parity_dist;
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

  extern function new(string name = "yapp_packet");

  // Correct parity: XOR of header and every payload byte
  extern function bit[7:0] calc_parity();

  // Write the parity byte according to the parity_type knob.
  // A bad parity flips one random bit of the correct value.
  extern function void set_parity();

  // Called automatically after every successful randomize(): sizes the
  // payload to `length` if the solver did not, then sets the parity
  extern function void post_randomize();

endclass : yapp_packet

//------------------------------------------------------------------------------
// yapp_packet -- constraints
//------------------------------------------------------------------------------

constraint yapp_packet::c_addr_legal     { m_addr != 2'd3; }
constraint yapp_packet::c_length         { m_length inside {[1:63]}; m_payload.size() == m_length; }
constraint yapp_packet::c_parity_defined { m_parity_type != PARITY_TYPE_UNDEFINED; }
constraint yapp_packet::c_parity_dist    { m_parity_type dist { PARITY_TYPE_GOOD := 5, PARITY_TYPE_BAD := 1 }; }
constraint yapp_packet::c_delay          { m_packet_delay inside {[1:20]}; }

//------------------------------------------------------------------------------
// yapp_packet -- method implementations
//------------------------------------------------------------------------------

function yapp_packet::new(string name = "yapp_packet");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function bit[7:0] yapp_packet::calc_parity();
  calc_parity = {m_length, m_addr};
  foreach (m_payload[i]) begin
    calc_parity ^= m_payload[i];
  end
endfunction : calc_parity

//------------------------------------------------------------------------------
function void yapp_packet::set_parity();
  int unsigned bad_bit;
  m_parity = calc_parity();
  if (m_parity_type == PARITY_TYPE_BAD) begin
    // draw the bit once and flip it: two draws would pick two different bits
    // and leave the parity correct about half of the time
    bad_bit = rnd::get_index(8, {get_full_name(), ".bad_parity_bit"});
    m_parity[bad_bit] = ~m_parity[bad_bit];
  end
endfunction : set_parity

//------------------------------------------------------------------------------
function void yapp_packet::post_randomize();
  // Some solvers (Verilator 5.052) do not resize payload when randomize() is
  // called with an inline `with {...}`. Size it here: no sequence constrains
  // the payload bytes, so nothing is lost.
  if (m_payload.size() != m_length) begin
    m_payload = rnd::get_bytes(m_length, {get_full_name(), ".payload"});
  end
  set_parity();
endfunction : post_randomize

//------------------------------------------------------------------------------
function void yapp_packet::do_copy(uvm_object rhs);
  yapp_packet rhs_;
  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal(get_type_name(), "do_copy: rhs is not a yapp_packet")
  end
  super.do_copy(rhs);
  m_addr         = rhs_.m_addr;
  m_length       = rhs_.m_length;
  m_payload      = rhs_.m_payload;
  m_parity       = rhs_.m_parity;
  m_parity_type  = rhs_.m_parity_type;
  m_packet_delay = rhs_.m_packet_delay;
endfunction : do_copy

//------------------------------------------------------------------------------
function bit yapp_packet::do_compare(uvm_object rhs, uvm_comparer comparer);
  yapp_packet rhs_;
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
endfunction : do_compare

//------------------------------------------------------------------------------
function void yapp_packet::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("addr", m_addr, $bits(m_addr), UVM_HEX);
  printer.print_field("length", m_length, $bits(m_length), UVM_DEC);
  printer.print_array_header("payload", m_payload.size());
  foreach (m_payload[i]) begin
    printer.print_field($sformatf("[%0d]", i), m_payload[i], $bits(m_payload[i]), UVM_HEX, "[");
  end
  printer.print_array_footer(m_payload.size());
  printer.print_field("parity", m_parity, $bits(m_parity), UVM_HEX);
  printer.print_generic("parity_type", "parity_type_e", $bits(m_parity_type), m_parity_type.name());
  printer.print_field("packet_delay", m_packet_delay, $bits(m_packet_delay), UVM_DEC);
endfunction : do_print

//------------------------------------------------------------------------------
function void yapp_packet::do_pack(uvm_packer packer);
  super.do_pack(packer);
  packer.pack_field_int(m_addr, $bits(m_addr));
  packer.pack_field_int(m_length, $bits(m_length));
  packer.pack_field_int(m_payload.size(), 32);
  foreach (m_payload[i]) begin
    packer.pack_field_int(m_payload[i], $bits(m_payload[i]));
  end
  packer.pack_field_int(m_parity, $bits(m_parity));
  packer.pack_field_int(m_parity_type, $bits(m_parity_type));
  packer.pack_field_int(m_packet_delay, $bits(m_packet_delay));
endfunction : do_pack

//------------------------------------------------------------------------------
function void yapp_packet::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  m_addr = packer.unpack_field_int($bits(m_addr));
  m_length = packer.unpack_field_int($bits(m_length));
  m_payload = new[packer.unpack_field_int(32)];
  foreach (m_payload[i]) begin
    m_payload[i] = packer.unpack_field_int($bits(m_payload[i]));
  end
  m_parity = packer.unpack_field_int($bits(m_parity));
  m_parity_type = parity_type_e'(packer.unpack_field_int($bits(m_parity_type)));
  m_packet_delay = packer.unpack_field_int($bits(m_packet_delay));
endfunction : do_unpack

//------------------------------------------------------------------------------
function void yapp_packet::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  recorder.record_field("addr", m_addr, $bits(m_addr), UVM_HEX);
  recorder.record_field("length", m_length, $bits(m_length), UVM_DEC);
  foreach (m_payload[i]) begin
    recorder.record_field($sformatf("payload[%0d]", i), m_payload[i], $bits(m_payload[i]), UVM_HEX);
  end
  recorder.record_field("parity", m_parity, $bits(m_parity), UVM_HEX);
  recorder.record_string("parity_type", m_parity_type.name());
  recorder.record_field("packet_delay", m_packet_delay, $bits(m_packet_delay), UVM_DEC);
endfunction : do_record
