//------------------------------------------------------------------------------
// hbus_set_default_regs_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_set_default_regs_seq: reset values (maxpktsize = 63, router enabled)
class hbus_set_default_regs_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_set_default_regs_seq)

  function new(string name = "hbus_set_default_regs_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_set_default_regs_seq", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hdata == 8'h3f; req.hwr_rd == HBUS_WRITE; })
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_set_default_regs_seq
