//------------------------------------------------------------------------------
// ro_byte_reg_c.sv -- ro_byte_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Read-only 8-bit counter registers: one small class each, sharing a base
//--------------------------------------------------------------------------
virtual class ro_byte_reg_c extends uvm_reg;

  rand uvm_reg_field value;   // [7:0]

  function new(string name);
    super.new(name, 8, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build();
    value = uvm_reg_field::type_id::create("value");
    value.configure(this, 8, 0, "RO", 0, 8'h00, 1, 0, 0);
  endfunction : build

endclass : ro_byte_reg_c
