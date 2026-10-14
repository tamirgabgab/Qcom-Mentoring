//------------------------------------------------------------------------------
// hbus_read_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_read_seq: read `addr`; the value is left in `data`
class hbus_read_seq extends hbus_base_seq;

  rand bit[15:0] m_addr;
  bit[7:0]       m_data;

  `uvm_object_utils(hbus_read_seq)

  extern function new(string name = "hbus_read_seq");
  extern task body();

endclass : hbus_read_seq

//------------------------------------------------------------------------------
// hbus_read_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_read_seq::new(string name = "hbus_read_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_read_seq::body();
  `uvm_info(get_type_name(), $sformatf("Executing hbus_read_seq addr=0x%04h", m_addr), UVM_LOW)
  req = hbus_transaction::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.m_haddr == m_addr; req.m_hwr_rd == HBUS_OP_READ; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
  m_data = req.m_hdata;
  `uvm_info(get_type_name(), $sformatf("Read addr=0x%04h data=0x%02h", m_addr, m_data), UVM_LOW)
endtask : body
