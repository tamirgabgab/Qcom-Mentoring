//------------------------------------------------------------------------------
// yapp_repeat_addr_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_repeat_addr_seq: two packets to the same random (legal) address
class yapp_repeat_addr_seq extends yapp_base_seq;

  // A random SEQUENCE property, randomized when the sequence is randomized
  rand bit [1:0] seq_addr;
  constraint c_seq_addr { seq_addr != 2'd3; }

  `uvm_object_utils(yapp_repeat_addr_seq)

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(),
              $sformatf("Executing yapp_repeat_addr_seq sequence (addr %0d)", seq_addr), UVM_LOW)
    `uvm_do_with(req, { req.addr == seq_addr; })
    `uvm_do_with(req, { req.addr == seq_addr; })
  endtask : body

endclass : yapp_repeat_addr_seq
