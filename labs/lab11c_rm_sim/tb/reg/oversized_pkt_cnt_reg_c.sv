//------------------------------------------------------------------------------
// oversized_pkt_cnt_reg_c.sv -- oversized_pkt_cnt_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class oversized_pkt_cnt_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(oversized_pkt_cnt_reg_c)
  function new(string name = "oversized_pkt_cnt_reg_c"); super.new(name); endfunction
endclass : oversized_pkt_cnt_reg_c
