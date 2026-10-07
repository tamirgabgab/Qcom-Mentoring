//------------------------------------------------------------------------------
// addr2_cnt_reg_c.sv -- addr2_cnt_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class addr2_cnt_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(addr2_cnt_reg_c)
  extern function new(string name = "addr2_cnt_reg_c");
endclass : addr2_cnt_reg_c

//------------------------------------------------------------------------------
// addr2_cnt_reg_c -- method implementations
//------------------------------------------------------------------------------

function addr2_cnt_reg_c::new(string name = "addr2_cnt_reg_c"); super.new(name);
endfunction : new
