//------------------------------------------------------------------------------
// oversized_pkt_cnt_reg_c.sv -- oversized_pkt_cnt_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

class oversized_pkt_cnt_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(oversized_pkt_cnt_reg_c)
  extern function new(string name = "oversized_pkt_cnt_reg_c");
endclass : oversized_pkt_cnt_reg_c

//------------------------------------------------------------------------------
// oversized_pkt_cnt_reg_c -- method implementations
//------------------------------------------------------------------------------

function oversized_pkt_cnt_reg_c::new(string name = "oversized_pkt_cnt_reg_c"); super.new(name);
endfunction : new
