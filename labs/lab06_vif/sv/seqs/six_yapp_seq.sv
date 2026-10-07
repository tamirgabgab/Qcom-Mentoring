//------------------------------------------------------------------------------
// six_yapp_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// six_yapp_seq (optional): yapp_rnd_seq constrained to exactly six packets
class six_yapp_seq extends yapp_base_seq;

  yapp_rnd_seq rnd_seq;

  `uvm_object_utils(six_yapp_seq)

  function new(string name = "six_yapp_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing six_yapp_seq sequence", UVM_LOW)
    `uvm_do_with(rnd_seq, { rnd_seq.count == 6; })
  endtask : body

endclass : six_yapp_seq
