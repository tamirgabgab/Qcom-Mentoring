//------------------------------------------------------------------------------
// yapp_regs_c.sv -- yapp_regs_c (register model)
// Split out of yapp_router_reg_pkg.sv: one class per file.
//------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// yapp_regs_c : the register block (offsets relative to its base)
//--------------------------------------------------------------------------
class yapp_regs_c extends uvm_reg_block;

  rand ctrl_reg_c              ctrl_reg;
  rand en_reg_c                en_reg;
  rand parity_err_cnt_reg_c    parity_err_cnt_reg;
  rand oversized_pkt_cnt_reg_c oversized_pkt_cnt_reg;
  rand addr3_cnt_reg_c         addr3_cnt_reg;
  rand addr0_cnt_reg_c         addr0_cnt_reg;
  rand addr1_cnt_reg_c         addr1_cnt_reg;
  rand addr2_cnt_reg_c         addr2_cnt_reg;
  rand mem_size_reg_c          mem_size_reg;
       yapp_pkt_mem_c          yapp_pkt_mem;
       yapp_mem_c              yapp_mem;

  `uvm_object_utils(yapp_regs_c)

  extern function new(string name = "yapp_regs_c");
  extern virtual function void build();

endclass : yapp_regs_c

//------------------------------------------------------------------------------
// yapp_regs_c -- method implementations
//------------------------------------------------------------------------------

function yapp_regs_c::new(string name = "yapp_regs_c");
  super.new(name, UVM_NO_COVERAGE);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_regs_c::build();
  // one byte per address, little endian
  default_map = create_map("default_map", 'h0, 1, UVM_LITTLE_ENDIAN, 0);

  ctrl_reg              = ctrl_reg_c::type_id::create("ctrl_reg");
  en_reg                = en_reg_c::type_id::create("en_reg");
  parity_err_cnt_reg    = parity_err_cnt_reg_c::type_id::create("parity_err_cnt_reg");
  oversized_pkt_cnt_reg = oversized_pkt_cnt_reg_c::type_id::create("oversized_pkt_cnt_reg");
  addr3_cnt_reg         = addr3_cnt_reg_c::type_id::create("addr3_cnt_reg");
  addr0_cnt_reg         = addr0_cnt_reg_c::type_id::create("addr0_cnt_reg");
  addr1_cnt_reg         = addr1_cnt_reg_c::type_id::create("addr1_cnt_reg");
  addr2_cnt_reg         = addr2_cnt_reg_c::type_id::create("addr2_cnt_reg");
  mem_size_reg          = mem_size_reg_c::type_id::create("mem_size_reg");
  yapp_pkt_mem          = yapp_pkt_mem_c::type_id::create("yapp_pkt_mem");
  yapp_mem              = yapp_mem_c::type_id::create("yapp_mem");

  // configure(parent block, register file, HDL path of the RTL variable)
  ctrl_reg.configure             (this, null, "ctrl_reg");
  en_reg.configure               (this, null, "en_reg");
  parity_err_cnt_reg.configure   (this, null, "parity_err_cnt_reg");
  oversized_pkt_cnt_reg.configure(this, null, "oversized_pkt_cnt_reg");
  addr3_cnt_reg.configure        (this, null, "addr3_cnt_reg");
  addr0_cnt_reg.configure        (this, null, "addr0_cnt_reg");
  addr1_cnt_reg.configure        (this, null, "addr1_cnt_reg");
  addr2_cnt_reg.configure        (this, null, "addr2_cnt_reg");
  mem_size_reg.configure         (this, null, "mem_size_reg");
  yapp_pkt_mem.configure         (this, "yapp_pkt_mem");
  yapp_mem.configure             (this, "yapp_mem");

  ctrl_reg.build();
  en_reg.build();
  parity_err_cnt_reg.build();
  oversized_pkt_cnt_reg.build();
  addr3_cnt_reg.build();
  addr0_cnt_reg.build();
  addr1_cnt_reg.build();
  addr2_cnt_reg.build();
  mem_size_reg.build();

  default_map.add_reg(ctrl_reg,              'h00, "RW");
  default_map.add_reg(en_reg,                'h01, "RW");
  default_map.add_reg(parity_err_cnt_reg,    'h04, "RO");
  default_map.add_reg(oversized_pkt_cnt_reg, 'h05, "RO");
  default_map.add_reg(addr3_cnt_reg,         'h06, "RO");
  default_map.add_reg(addr0_cnt_reg,         'h09, "RO");
  default_map.add_reg(addr1_cnt_reg,         'h0a, "RO");
  default_map.add_reg(addr2_cnt_reg,         'h0b, "RO");
  default_map.add_reg(mem_size_reg,          'h0d, "RO");
  default_map.add_mem(yapp_pkt_mem,          'h10,  "RO");
  default_map.add_mem(yapp_mem,              'h100, "RW");
endfunction : build
