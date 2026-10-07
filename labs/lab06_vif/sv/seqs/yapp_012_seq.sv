//------------------------------------------------------------------------------
// yapp_012_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_012_seq: three packets, to address 0, then 1, then 2
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, { req.addr == 2'd0; })
    `uvm_do_with(req, { req.addr == 2'd1; })
    `uvm_do_with(req, { req.addr == 2'd2; })
  endtask : body

endclass : yapp_012_seq
