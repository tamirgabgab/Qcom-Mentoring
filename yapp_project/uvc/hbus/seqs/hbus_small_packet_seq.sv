//------------------------------------------------------------------------------
// hbus_small_packet_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_small_packet_seq: accept payloads up to 20 bytes and enable the router
class hbus_small_packet_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_small_packet_seq)

  extern function new(string name = "hbus_small_packet_seq");
  extern task body();

endclass : hbus_small_packet_seq

//------------------------------------------------------------------------------
// hbus_small_packet_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_small_packet_seq::new(string name = "hbus_small_packet_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_small_packet_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_small_packet_seq (maxpktsize=20, router_en=1)", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == CTRL_REG_ADDR; req.hdata == 8'd20; req.hwr_rd == HBUS_WRITE; }) begin
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
