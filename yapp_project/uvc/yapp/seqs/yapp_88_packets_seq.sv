//------------------------------------------------------------------------------
// yapp_88_packets_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_88_packets_seq (Lab 7 optional integration test):
// every address 0..3 (3 is illegal!) with payload lengths 1..22, 20% bad
// parity -> 4 x 22 = 88 packets. The legal-address constraint of the packet
// has to be switched off to reach address 3.
//------------------------------------------------------------------------------
class yapp_88_packets_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_88_packets_seq)

  extern function new(string name = "yapp_88_packets_seq");
  extern task body();

endclass : yapp_88_packets_seq

//------------------------------------------------------------------------------
// yapp_88_packets_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_88_packets_seq::new(string name = "yapp_88_packets_seq");
  super.new(name);
endfunction : new

task yapp_88_packets_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_88_packets_seq sequence", UVM_LOW)
  for (int a = 0; a < 4; a++) begin
    for (int l = 1; l <= 22; l++) begin
      req = yapp_packet::type_id::create("req");
      req.c_addr_legal.constraint_mode(0);
      if (!req.randomize() with { req.addr == a;
                                  req.length == l;
                                  req.parity_type dist { GOOD_PARITY := 4, BAD_PARITY := 1 }; })
        `uvm_error(get_type_name(), "Randomization failed")
      start_item(req);
      finish_item(req);
    end
  end
endtask : body
