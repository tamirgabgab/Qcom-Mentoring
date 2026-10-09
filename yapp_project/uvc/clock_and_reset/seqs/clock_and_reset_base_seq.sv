//------------------------------------------------------------------------------
// clock_and_reset_base_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// Base sequence: raises an objection while it runs so the clock/reset item is
// always delivered, even if no other sequence is active yet.
class clock_and_reset_base_seq extends uvm_sequence #(clock_and_reset_transaction);

  `uvm_object_utils(clock_and_reset_base_seq)

  extern function new(string name = "clock_and_reset_base_seq");
  extern task pre_body();

  extern task post_body();

endclass : clock_and_reset_base_seq

//------------------------------------------------------------------------------
// clock_and_reset_base_seq -- method implementations
//------------------------------------------------------------------------------

function clock_and_reset_base_seq::new(string name = "clock_and_reset_base_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task clock_and_reset_base_seq::pre_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.raise_objection(this, get_type_name());
  end
endtask : pre_body

//------------------------------------------------------------------------------
task clock_and_reset_base_seq::post_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.drop_objection(this, get_type_name());
  end
endtask : post_body
