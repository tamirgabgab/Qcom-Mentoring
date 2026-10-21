// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_rnd_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_rnd_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_rnd_seq (optional): a random number (1..10) of random packets
class yapp_rnd_seq extends yapp_base_seq;

  rand int m_count;

  `uvm_object_utils(yapp_rnd_seq)

  extern constraint c_count;

  extern function new(string name = "yapp_rnd_seq");
  extern task body();

endclass : yapp_rnd_seq

//------------------------------------------------------------------------------
// yapp_rnd_seq -- constraints
//------------------------------------------------------------------------------

constraint yapp_rnd_seq::c_count {
  // TODO (Lab 5): the constraint yapp_rnd_seq::c_count
}

//------------------------------------------------------------------------------
// yapp_rnd_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_rnd_seq::new(string name = "yapp_rnd_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_rnd_seq::body();
  // TODO (Lab 5): write yapp_rnd_seq::body
endtask : body
