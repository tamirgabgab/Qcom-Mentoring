//------------------------------------------------------------------------------
// hbus_router_enable_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

class hbus_router_enable_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_router_enable_seq)

  extern function new(string name = "hbus_router_enable_seq");
  extern task body();

endclass : hbus_router_enable_seq

//------------------------------------------------------------------------------
// hbus_router_enable_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_router_enable_seq::new(string name = "hbus_router_enable_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_router_enable_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_router_enable_seq (router_en=1)", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == EN_REG_ADDR; req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
