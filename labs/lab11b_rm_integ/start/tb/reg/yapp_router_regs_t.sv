//------------------------------------------------------------------------------
// yapp_router_regs_t.sv -- yapp_router_regs_t (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// yapp_router_regs_t : top-level block, places the register block at 0x1000
//--------------------------------------------------------------------------
class yapp_router_regs_t extends uvm_reg_block;

  rand yapp_regs_c router_yapp_regs;

  `uvm_object_utils(yapp_router_regs_t)

  extern function new(string name = "yapp_router_regs_t");
  extern virtual function void build();

endclass : yapp_router_regs_t

//------------------------------------------------------------------------------
// yapp_router_regs_t -- method implementations
//------------------------------------------------------------------------------

function yapp_router_regs_t::new(string name = "yapp_router_regs_t");
  super.new(name, UVM_NO_COVERAGE);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_router_regs_t::build();
  default_map = create_map("default_map", 'h0, 1, UVM_LITTLE_ENDIAN, 0);
  router_yapp_regs = yapp_regs_c::type_id::create("router_yapp_regs");
  router_yapp_regs.configure(this, "");      // no extra HDL hierarchy level
  router_yapp_regs.build();
  default_map.add_submap(router_yapp_regs.default_map, 'h1000);
endfunction : build
