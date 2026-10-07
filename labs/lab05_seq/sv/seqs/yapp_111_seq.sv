//------------------------------------------------------------------------------
// yapp_111_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_111_seq: nested sequence -- runs yapp_1_seq three times
class yapp_111_seq extends yapp_base_seq;

  yapp_1_seq seq_1;

  `uvm_object_utils(yapp_111_seq)

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat (3)
      `uvm_do(seq_1)
  endtask : body

endclass : yapp_111_seq
