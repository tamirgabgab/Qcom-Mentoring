//------------------------------------------------------------------------------
// hbus_router_enable_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

class hbus_router_enable_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_router_enable_seq)

  function new(string name = "hbus_router_enable_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_router_enable_seq (router_en=1)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR; req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_router_enable_seq
