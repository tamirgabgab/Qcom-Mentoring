//------------------------------------------------------------------------------
// parity_err_cnt_reg_c.sv -- parity_err_cnt_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class parity_err_cnt_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(parity_err_cnt_reg_c)
  extern function new(string name = "parity_err_cnt_reg_c");
endclass : parity_err_cnt_reg_c

//------------------------------------------------------------------------------
// parity_err_cnt_reg_c -- method implementations
//------------------------------------------------------------------------------

function parity_err_cnt_reg_c::new(string name = "parity_err_cnt_reg_c"); super.new(name);
endfunction : new
