//------------------------------------------------------------------------------
// ctrl_reg_c.sv -- ctrl_reg_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// ctrl_reg : maximum packet length
//--------------------------------------------------------------------------
class ctrl_reg_c extends uvm_reg;

  rand uvm_reg_field plen;     // [5:0]  maximum payload length ("maxpktsize")
  rand uvm_reg_field unused;   // [7:6]

  `uvm_object_utils(ctrl_reg_c)

  extern function new(string name = "ctrl_reg_c");
  extern virtual function void build();

endclass : ctrl_reg_c

//------------------------------------------------------------------------------
// ctrl_reg_c -- method implementations
//------------------------------------------------------------------------------

function ctrl_reg_c::new(string name = "ctrl_reg_c");
  super.new(name, 8, UVM_NO_COVERAGE);
endfunction : new

function void ctrl_reg_c::build();
  plen   = uvm_reg_field::type_id::create("plen");
  unused = uvm_reg_field::type_id::create("unused");
  //               parent size lsb access volatile reset  has_reset is_rand individually_accessible
  plen.configure  (this,  6,   0,  "RW",  0,       6'h3f, 1,        1,      0);
  unused.configure(this,  2,   6,  "RW",  0,       2'h0,  1,        1,      0);
endfunction : build
