// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/sv/seqs/yapp_base_seq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_base_seq.sv -- YAPP sequence library (Lab 3: provided base + 5 packets)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_base_seq: raises an objection while the sequence runs, so run_phase
// does not end before the last packet was delivered.
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_base_seq)

  extern function new(string name = "yapp_base_seq");
  extern task pre_body();

  extern task post_body();

endclass : yapp_base_seq

//------------------------------------------------------------------------------
// yapp_base_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_base_seq::new(string name = "yapp_base_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_base_seq::pre_body();
  // TODO (Lab 3): write yapp_base_seq::pre_body
endtask : pre_body

//------------------------------------------------------------------------------
task yapp_base_seq::post_body();
  // TODO (Lab 3): write yapp_base_seq::post_body
endtask : post_body
