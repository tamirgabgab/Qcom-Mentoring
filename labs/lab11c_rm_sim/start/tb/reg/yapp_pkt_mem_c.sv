//------------------------------------------------------------------------------
// yapp_pkt_mem_c.sv -- yapp_pkt_mem_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Memories
//--------------------------------------------------------------------------
class yapp_pkt_mem_c extends uvm_mem;
  `uvm_object_utils(yapp_pkt_mem_c)
  extern function new(string name = "yapp_pkt_mem_c");
endclass : yapp_pkt_mem_c

//------------------------------------------------------------------------------
// yapp_pkt_mem_c -- method implementations
//------------------------------------------------------------------------------

function yapp_pkt_mem_c::new(string name = "yapp_pkt_mem_c");
  super.new(name, 64, 8, "RO", UVM_NO_COVERAGE);   // bytes of the last packet
endfunction : new
