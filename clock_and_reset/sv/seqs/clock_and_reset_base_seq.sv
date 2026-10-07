//------------------------------------------------------------------------------
// clock_and_reset_base_seq.sv -- sequence library of the Clock & Reset UVC
// Split out of clock_and_reset_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// Base sequence: raises an objection while it runs so the clock/reset item is
// always delivered, even if no other sequence is active yet.
class clock_and_reset_base_seq extends uvm_sequence #(clock_and_reset_transaction);

  `uvm_object_utils(clock_and_reset_base_seq)

  function new(string name = "clock_and_reset_base_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : clock_and_reset_base_seq
