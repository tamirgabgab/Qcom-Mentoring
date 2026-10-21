// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/yapp_exhaustive_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_exhaustive_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_exhaustive_seq: runs every sequence above once
class yapp_exhaustive_seq extends yapp_base_seq;

  yapp_1_seq            m_seq_1;
  yapp_012_seq          m_seq_012;
  yapp_111_seq          m_seq_111;
  yapp_repeat_addr_seq  m_seq_repeat_addr;
  yapp_incr_payload_seq m_seq_incr_payload;
  yapp_rnd_seq          m_seq_rnd;
  six_yapp_seq          m_seq_six;

  `uvm_object_utils(yapp_exhaustive_seq)

  extern function new(string name = "yapp_exhaustive_seq");
  extern task body();

endclass : yapp_exhaustive_seq

//------------------------------------------------------------------------------
// yapp_exhaustive_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_exhaustive_seq::new(string name = "yapp_exhaustive_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_exhaustive_seq::body();
  // TODO (Lab 5): write yapp_exhaustive_seq::body
endtask : body
