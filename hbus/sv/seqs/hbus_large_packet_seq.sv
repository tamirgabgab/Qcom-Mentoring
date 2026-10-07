//------------------------------------------------------------------------------
// hbus_large_packet_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// hbus_large_packet_seq: accept payloads up to 63 bytes and enable the router
class hbus_large_packet_seq extends hbus_base_seq;

  `uvm_object_utils(hbus_large_packet_seq)

  function new(string name = "hbus_large_packet_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing hbus_large_packet_seq (maxpktsize=63, router_en=1)", UVM_LOW)
    `uvm_do_with(req, { req.haddr == CTRL_REG_ADDR; req.hdata == 8'd63; req.hwr_rd == HBUS_WRITE; })
    `uvm_do_with(req, { req.haddr == EN_REG_ADDR;   req.hdata == 8'h01; req.hwr_rd == HBUS_WRITE; })
  endtask : body

endclass : hbus_large_packet_seq
