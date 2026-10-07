//------------------------------------------------------------------------------
// yapp_mem_c.sv -- yapp_mem_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class yapp_mem_c extends uvm_mem;
  `uvm_object_utils(yapp_mem_c)
  extern function new(string name = "yapp_mem_c");
endclass : yapp_mem_c

//------------------------------------------------------------------------------
// yapp_mem_c -- method implementations
//------------------------------------------------------------------------------

function yapp_mem_c::new(string name = "yapp_mem_c");
  super.new(name, 256, 8, "RW", UVM_NO_COVERAGE);  // scratch memory
endfunction : new
