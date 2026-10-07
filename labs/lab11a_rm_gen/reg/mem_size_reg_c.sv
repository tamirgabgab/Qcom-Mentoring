//------------------------------------------------------------------------------
// mem_size_reg_c.sv -- mem_size_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

// mem_size_reg: length of the last packet. The DUT only implements [5:0];
// the model keeps the full byte like the register map does.
class mem_size_reg_c extends ro_byte_reg_c;
  `uvm_object_utils(mem_size_reg_c)
  extern function new(string name = "mem_size_reg_c");
endclass : mem_size_reg_c

//------------------------------------------------------------------------------
// mem_size_reg_c -- method implementations
//------------------------------------------------------------------------------

function mem_size_reg_c::new(string name = "mem_size_reg_c"); super.new(name);
endfunction : new
