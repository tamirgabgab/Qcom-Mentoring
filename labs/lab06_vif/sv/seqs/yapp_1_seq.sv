//------------------------------------------------------------------------------
// yapp_1_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_1_seq: one packet to address 1
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, { req.addr == 2'd1; })
  endtask : body

endclass : yapp_1_seq
