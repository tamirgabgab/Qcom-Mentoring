// START POINT of Lab 5: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab05_seq/sv/seqs/six_yapp_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// six_yapp_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// six_yapp_seq (optional): yapp_rnd_seq constrained to exactly six packets
class six_yapp_seq extends yapp_base_seq;

  yapp_rnd_seq m_rnd_seq;

  `uvm_object_utils(six_yapp_seq)

  extern function new(string name = "six_yapp_seq");
  extern task body();

endclass : six_yapp_seq

//------------------------------------------------------------------------------
// six_yapp_seq -- method implementations
//------------------------------------------------------------------------------

function six_yapp_seq::new(string name = "six_yapp_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task six_yapp_seq::body();
  // TODO (Lab 5): write six_yapp_seq::body
endtask : body
