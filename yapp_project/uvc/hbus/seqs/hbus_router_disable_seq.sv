//------------------------------------------------------------------------------
// hbus_router_disable_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_router_disable_seq / hbus_router_enable_seq: toggle router_en only
class hbus_router_disable_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_router_disable_seq)

  extern function new(string name = "hbus_router_disable_seq");
  extern task body();

endclass : hbus_router_disable_seq

//------------------------------------------------------------------------------
// hbus_router_disable_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_router_disable_seq::new(string name = "hbus_router_disable_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_router_disable_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_router_disable_seq (router_en=0)", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == EN_REG_ADDR; req.hdata == 8'h00; req.hwr_rd == HBUS_WRITE; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
