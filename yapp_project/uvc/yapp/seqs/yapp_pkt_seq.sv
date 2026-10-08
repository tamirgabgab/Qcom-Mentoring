//------------------------------------------------------------------------------
// yapp_pkt_seq.sv -- YAPP sequence library (test-plan sequences)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_pkt_seq: one packet whose address, length and parity the test chooses by
// randomizing the sequence with an inline constraint, for example
//   seq.randomize() with { pkt_addr == 3; pkt_len == 20; }
// The soft constraints give a legal, good packet when the test says nothing.
// The packet that went out stays in `req`, so the test can compare the DUT's
// memories and counters against exactly what was sent.
//------------------------------------------------------------------------------
class yapp_pkt_seq extends yapp_base_seq;

  rand bit [1:0]     pkt_addr;
  rand bit [5:0]     pkt_len;
  rand parity_type_e pkt_parity;

  constraint c_len    { pkt_len inside {[1:63]}; }
  constraint c_legal  { soft pkt_addr != 2'd3; }
  constraint c_parity { soft pkt_parity == GOOD_PARITY; }

  `uvm_object_utils(yapp_pkt_seq)

  extern function new(string name = "yapp_pkt_seq");
  extern task body();

endclass : yapp_pkt_seq

//------------------------------------------------------------------------------
// yapp_pkt_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_pkt_seq::new(string name = "yapp_pkt_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_pkt_seq::body();
  `uvm_info(get_type_name(), $sformatf("Executing yapp_pkt_seq (addr %0d, length %0d, %s)",
                                       pkt_addr, pkt_len, pkt_parity.name()), UVM_LOW)
  req = yapp_packet::type_id::create("req");
  req.c_addr_legal.constraint_mode(0);      // the test may ask for address 3
  start_item(req);
  if (!req.randomize() with { req.addr        == pkt_addr;
                              req.length      == pkt_len;
                              req.parity_type == pkt_parity; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
