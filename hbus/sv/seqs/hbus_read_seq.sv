//------------------------------------------------------------------------------
// hbus_read_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_read_seq: read `addr`; the value is left in `data`
class hbus_read_seq extends hbus_base_seq;

  rand bit [15:0] addr;
  bit [7:0]       data;

  `uvm_object_utils(hbus_read_seq)

  function new(string name = "hbus_read_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), $sformatf("Executing hbus_read_seq addr=0x%04h", addr), UVM_LOW)
    `uvm_do_with(req, { req.haddr == addr; req.hwr_rd == HBUS_READ; })
    data = req.hdata;
    `uvm_info(get_type_name(), $sformatf("Read addr=0x%04h data=0x%02h", addr, data), UVM_LOW)
  endtask : body

endclass : hbus_read_seq
