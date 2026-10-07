//------------------------------------------------------------------------------
// yapp_exhaustive_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_exhaustive_seq: runs every sequence above once
class yapp_exhaustive_seq extends yapp_base_seq;

  yapp_1_seq            seq_1;
  yapp_012_seq          seq_012;
  yapp_111_seq          seq_111;
  yapp_repeat_addr_seq  seq_repeat_addr;
  yapp_incr_payload_seq seq_incr_payload;
  yapp_rnd_seq          seq_rnd;
  six_yapp_seq          seq_six;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    `uvm_do(seq_1)
    `uvm_do(seq_012)
    `uvm_do(seq_111)
    `uvm_do(seq_repeat_addr)
    `uvm_do(seq_incr_payload)
    `uvm_do(seq_rnd)
    `uvm_do(seq_six)
  endtask : body

endclass : yapp_exhaustive_seq
