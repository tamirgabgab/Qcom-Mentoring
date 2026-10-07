//------------------------------------------------------------------------------
// hbus_write_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_write_seq: write `data` to `addr` (both randomizable or set by the user)
class hbus_write_seq extends hbus_base_seq;

  rand bit [15:0] addr;
  rand bit [7:0]  data;

  `uvm_object_utils(hbus_write_seq)

  extern function new(string name = "hbus_write_seq");
  extern task body();

endclass : hbus_write_seq

//------------------------------------------------------------------------------
// hbus_write_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_write_seq::new(string name = "hbus_write_seq");
  super.new(name);
endfunction : new

task hbus_write_seq::body();
  `uvm_info(get_type_name(), $sformatf("Executing hbus_write_seq addr=0x%04h data=0x%02h",
                                       addr, data), UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == addr; req.hdata == data; req.hwr_rd == HBUS_WRITE; })
    `uvm_error(get_type_name(), "req.randomize() failed")
  finish_item(req);
endtask : body
