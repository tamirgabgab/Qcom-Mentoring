// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_incr_payload_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_incr_payload_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_incr_payload_seq: one packet whose payload is 0, 1, 2, ... length-1
class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  extern function new(string name = "yapp_incr_payload_seq");
  extern task body();

endclass : yapp_incr_payload_seq

//------------------------------------------------------------------------------
// yapp_incr_payload_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_incr_payload_seq::new(string name = "yapp_incr_payload_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_incr_payload_seq::body();
  // TODO (Lab 5): write yapp_incr_payload_seq::body
endtask : body
