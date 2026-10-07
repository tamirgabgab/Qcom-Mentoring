//------------------------------------------------------------------------------
// addr1_cnt_reg_c.sv -- addr1_cnt_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class addr1_cnt_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(addr1_cnt_reg_c)
  function new(string name = "addr1_cnt_reg_c"); super.new(name); endfunction
endclass : addr1_cnt_reg_c
