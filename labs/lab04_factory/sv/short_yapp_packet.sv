//------------------------------------------------------------------------------
// short_yapp_packet.sv -- short_yapp_packet (Lab 4)
// Split out of yapp_packet.sv: one class per file.
//------------------------------------------------------------------------------

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
