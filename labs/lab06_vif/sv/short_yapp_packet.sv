//------------------------------------------------------------------------------
// short_yapp_packet.sv -- short_yapp_packet (Lab 4)
// Split out of yapp_packet.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// short_yapp_packet (Lab 4): same packet, payload shorter than 15 bytes.
//
// The original Lab 4 version also had `constraint c_no_addr2 { addr != 2'd2; }`.
// It was removed in Lab 5: yapp_012_seq asks for addr == 2, which cannot be
// satisfied together with that constraint and makes randomize() fail.
//------------------------------------------------------------------------------
class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

  constraint c_short_length { length < 15; }

  function new(string name = "short_yapp_packet");
    super.new(name);
  endfunction : new

endclass : short_yapp_packet
