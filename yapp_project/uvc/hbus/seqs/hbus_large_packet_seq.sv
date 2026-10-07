//------------------------------------------------------------------------------
// hbus_large_packet_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_large_packet_seq: accept payloads up to 63 bytes and enable the router
class hbus_large_packet_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_large_packet_seq)

  extern function new(string name = "hbus_large_packet_seq");
  extern task body();

endclass : hbus_large_packet_seq

//------------------------------------------------------------------------------
// hbus_large_packet_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_large_packet_seq::new(string name = "hbus_large_packet_seq");
  super.new(name);
endfunction : new

task hbus_large_packet_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_large_packet_seq (maxpktsize=63, router_en=1)", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == CTRL_REG_ADDR; req.hdata == 8'd63; req.hwr_rd == HBUS_WRITE; })
    `uvm_error(get_type_name(), "req.randomize() failed")
  finish_item(req);

  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
    `uvm_error(get_type_name(), "req.randomize() failed")
  finish_item(req);
endtask : body
