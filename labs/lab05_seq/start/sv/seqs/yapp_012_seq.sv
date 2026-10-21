// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_012_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_012_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_012_seq: three packets, to address 0, then 1, then 2
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  extern function new(string name = "yapp_012_seq");
  extern task body();

endclass : yapp_012_seq

//------------------------------------------------------------------------------
// yapp_012_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_012_seq::new(string name = "yapp_012_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_012_seq::body();
  // TODO (Lab 5): write yapp_012_seq::body
endtask : body
