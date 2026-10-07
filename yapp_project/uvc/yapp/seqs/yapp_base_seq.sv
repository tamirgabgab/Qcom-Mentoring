//------------------------------------------------------------------------------
// yapp_base_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
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
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) phase.raise_objection(this, get_type_name());
endtask : pre_body

//------------------------------------------------------------------------------
task yapp_base_seq::post_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) phase.drop_objection(this, get_type_name());
endtask : post_body
