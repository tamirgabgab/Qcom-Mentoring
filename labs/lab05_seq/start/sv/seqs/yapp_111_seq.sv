// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_111_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_111_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_111_seq: nested sequence -- runs yapp_1_seq three times
class yapp_111_seq extends yapp_base_seq;

  yapp_1_seq m_seq_1;

  `uvm_object_utils(yapp_111_seq)

  extern function new(string name = "yapp_111_seq");
  extern task body();

endclass : yapp_111_seq

//------------------------------------------------------------------------------
// yapp_111_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_111_seq::new(string name = "yapp_111_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_111_seq::body();
  // TODO (Lab 5): write yapp_111_seq::body
endtask : body
