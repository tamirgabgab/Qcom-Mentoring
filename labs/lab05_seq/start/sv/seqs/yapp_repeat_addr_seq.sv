// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_repeat_addr_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_repeat_addr_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_repeat_addr_seq: two packets to the same random (legal) address
class yapp_repeat_addr_seq extends yapp_base_seq;

  // A random SEQUENCE property, randomized when the sequence is randomized
  rand bit[1:0] m_seq_addr;

  `uvm_object_utils(yapp_repeat_addr_seq)

  extern constraint c_seq_addr;

  extern function new(string name = "yapp_repeat_addr_seq");
  extern task body();

endclass : yapp_repeat_addr_seq

//------------------------------------------------------------------------------
// yapp_repeat_addr_seq -- constraints
//------------------------------------------------------------------------------

constraint yapp_repeat_addr_seq::c_seq_addr {
  // TODO (Lab 5): the constraint yapp_repeat_addr_seq::c_seq_addr
}

//------------------------------------------------------------------------------
// yapp_repeat_addr_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_repeat_addr_seq::new(string name = "yapp_repeat_addr_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_repeat_addr_seq::body();
  // TODO (Lab 5): write yapp_repeat_addr_seq::body
endtask : body
