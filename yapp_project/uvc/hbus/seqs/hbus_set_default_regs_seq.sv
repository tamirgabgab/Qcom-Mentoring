//------------------------------------------------------------------------------
// hbus_set_default_regs_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_set_default_regs_seq: reset values (maxpktsize = 63, router enabled)
class hbus_set_default_regs_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_set_default_regs_seq)

  extern function new(string name = "hbus_set_default_regs_seq");
  extern task body();

endclass : hbus_set_default_regs_seq

//------------------------------------------------------------------------------
// hbus_set_default_regs_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_set_default_regs_seq::new(string name = "hbus_set_default_regs_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_set_default_regs_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_set_default_regs_seq", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == CTRL_REG_ADDR; req.hdata == 8'h3f; req.hwr_rd == HBUS_WRITE; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);

  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
