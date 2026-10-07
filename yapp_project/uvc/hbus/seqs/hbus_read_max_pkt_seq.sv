//------------------------------------------------------------------------------
// hbus_read_max_pkt_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_read_max_pkt_seq: read ctrl_reg back and report maxpktsize
class hbus_read_max_pkt_seq extends hbus_base_seq;

  bit [7:0] maxpktsize;

  `uvm_object_utils(hbus_read_max_pkt_seq)

  extern function new(string name = "hbus_read_max_pkt_seq");
  extern task body();

endclass : hbus_read_max_pkt_seq

//------------------------------------------------------------------------------
// hbus_read_max_pkt_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_read_max_pkt_seq::new(string name = "hbus_read_max_pkt_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_read_max_pkt_seq::body();
  `uvm_info(get_type_name(), "Executing hbus_read_max_pkt_seq", UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.haddr == CTRL_REG_ADDR; req.hwr_rd == HBUS_READ; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
  maxpktsize = req.hdata[5:0];
  `uvm_info(get_type_name(), $sformatf("MAXPKTSIZE register reads %0d", maxpktsize), UVM_LOW)
endtask : body
