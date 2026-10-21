// START POINT of Lab 1: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab01_data/sv/yapp_packet.sv; the lab page explains every step.
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

  // Write the parity byte according to the m_parity_type knob.
  // A bad parity flips one random bit of the correct value.
  extern function void set_parity();

  // Called automatically after every successful randomize(): sizes the
  // payload to `m_length` if the solver did not, then sets the parity
  extern function void post_randomize();

endclass : yapp_packet

//------------------------------------------------------------------------------
// yapp_packet -- constraints
//------------------------------------------------------------------------------

constraint yapp_packet::c_addr_legal {
  // TODO (Lab 1): the constraint yapp_packet::c_addr_legal
}

//------------------------------------------------------------------------------
constraint yapp_packet::c_length {
  // TODO (Lab 1): the constraint yapp_packet::c_length
}

//------------------------------------------------------------------------------
constraint yapp_packet::c_parity_defined {
  // TODO (Lab 1): the constraint yapp_packet::c_parity_defined
}

//------------------------------------------------------------------------------
constraint yapp_packet::c_parity_dist {
  // TODO (Lab 1): the constraint yapp_packet::c_parity_dist
}

//------------------------------------------------------------------------------
constraint yapp_packet::c_delay {
  // TODO (Lab 1): the constraint yapp_packet::c_delay
}

//------------------------------------------------------------------------------
// yapp_packet -- method implementations
//------------------------------------------------------------------------------

function yapp_packet::new(string name = "yapp_packet");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
function bit[7:0] yapp_packet::calc_parity();
  // TODO (Lab 1): write yapp_packet::calc_parity
endfunction : calc_parity

//------------------------------------------------------------------------------
function void yapp_packet::set_parity();
    // draw the bit once and flip it: two draws would pick two different bits
    // and leave the parity correct about half of the time
  // TODO (Lab 1): write yapp_packet::set_parity
endfunction : set_parity

//------------------------------------------------------------------------------
function void yapp_packet::post_randomize();
  // Some solvers (Verilator 5.052) do not resize payload when randomize() is
  // called with an inline `with {...}`. Size it here: no sequence constrains
  // the payload bytes, so nothing is lost.
  // TODO (Lab 1): write yapp_packet::post_randomize
endfunction : post_randomize

//------------------------------------------------------------------------------
function void yapp_packet::do_copy(uvm_object rhs);
  super.do_copy(rhs);
  // TODO (Lab 1): write yapp_packet::do_copy
endfunction : do_copy

//------------------------------------------------------------------------------
function bit yapp_packet::do_compare(uvm_object rhs, uvm_comparer comparer);
  // TODO (Lab 1): write yapp_packet::do_compare
endfunction : do_compare

//------------------------------------------------------------------------------
function void yapp_packet::do_print(uvm_printer printer);
  super.do_print(printer);
  // TODO (Lab 1): write yapp_packet::do_print
endfunction : do_print

//------------------------------------------------------------------------------
function void yapp_packet::do_pack(uvm_packer packer);
  super.do_pack(packer);
  // TODO (Lab 1): write yapp_packet::do_pack
endfunction : do_pack

//------------------------------------------------------------------------------
function void yapp_packet::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
  // TODO (Lab 1): write yapp_packet::do_unpack
endfunction : do_unpack

//------------------------------------------------------------------------------
function void yapp_packet::do_record(uvm_recorder recorder);
  super.do_record(recorder);
  // TODO (Lab 1): write yapp_packet::do_record
endfunction : do_record
