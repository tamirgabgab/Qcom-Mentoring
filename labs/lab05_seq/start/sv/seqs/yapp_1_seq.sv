// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_1_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_1_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_1_seq: one packet to address 1
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  extern function new(string name = "yapp_1_seq");
  extern task body();

endclass : yapp_1_seq

//------------------------------------------------------------------------------
// yapp_1_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_1_seq::new(string name = "yapp_1_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_1_seq::body();
  // TODO (Lab 5): write yapp_1_seq::body
endtask : body
