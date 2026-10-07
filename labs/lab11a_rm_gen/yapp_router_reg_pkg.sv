//------------------------------------------------------------------------------
// yapp_router_reg_pkg.sv -- UVM register model (RAL) of the YAPP router
//
// In the Cadence flow this file is GENERATED from yapp_router_regs.xml by
// reg_verifier (as yapp_router_regs_rdb.sv). It is written by hand here so the
// course does not depend on that tool; the class names match what the lab
// manual expects:
//
//   yapp_router_regs_t              top block, owns default_map (HBUS, base 0x1000)
//   └── router_yapp_regs            yapp_regs_c
//       ├── ctrl_reg                ctrl_reg_c      0x1000  field plen[5:0] (a.k.a. maxpktsize)
//       ├── en_reg                  en_reg_c        0x1001  8 enable bits
//       ├── parity_err_cnt_reg      ..._c           0x1004  RO
//       ├── oversized_pkt_cnt_reg   ..._c           0x1005  RO
//       ├── addr3_cnt_reg           ..._c           0x1006  RO
//       ├── addr0_cnt_reg           ..._c           0x1009  RO
//       ├── addr1_cnt_reg           ..._c           0x100a  RO
//       ├── addr2_cnt_reg           ..._c           0x100b  RO
//       ├── mem_size_reg            ..._c           0x100d  RO (DUT uses bits [5:0])
//       ├── yapp_pkt_mem            yapp_pkt_mem_c  0x1010  64 x 8  RO
//       └── yapp_mem                yapp_mem_c      0x1100  256 x 8 RW
//
// Backdoor: every register / memory is configured with the HDL name of the
// matching RTL variable, so after
//     yapp_rm.set_hdl_path_root("hw_top.dut");
// peek()/poke() resolve to hw_top.dut.ctrl_reg, hw_top.dut.yapp_mem[i], ...
//------------------------------------------------------------------------------
package yapp_router_reg_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //--------------------------------------------------------------------------
  // ctrl_reg : maximum packet length
  //--------------------------------------------------------------------------
  class ctrl_reg_c extends uvm_reg;

    rand uvm_reg_field plen;     // [5:0]  maximum payload length ("maxpktsize")
    rand uvm_reg_field unused;   // [7:6]

    `uvm_object_utils(ctrl_reg_c)

    function new(string name = "ctrl_reg_c");
      super.new(name, 8, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
      plen   = uvm_reg_field::type_id::create("plen");
      unused = uvm_reg_field::type_id::create("unused");
      //               parent size lsb access volatile reset  has_reset is_rand individually_accessible
      plen.configure  (this,  6,   0,  "RW",  0,       6'h3f, 1,        1,      0);
      unused.configure(this,  2,   6,  "RW",  0,       2'h0,  1,        1,      0);
    endfunction : build

  endclass : ctrl_reg_c

  //--------------------------------------------------------------------------
  // en_reg : router enable and counter enables
  //--------------------------------------------------------------------------
  class en_reg_c extends uvm_reg;

    rand uvm_reg_field router_en;             // [0]
    rand uvm_reg_field parity_err_cnt_en;     // [1]
    rand uvm_reg_field oversized_pkt_cnt_en;  // [2]
    rand uvm_reg_field reserved;              // [3]
    rand uvm_reg_field addr0_cnt_en;          // [4]
    rand uvm_reg_field addr1_cnt_en;          // [5]
    rand uvm_reg_field addr2_cnt_en;          // [6]
    rand uvm_reg_field addr3_cnt_en;          // [7]

    `uvm_object_utils(en_reg_c)

    function new(string name = "en_reg_c");
      super.new(name, 8, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
      router_en            = uvm_reg_field::type_id::create("router_en");
      parity_err_cnt_en    = uvm_reg_field::type_id::create("parity_err_cnt_en");
      oversized_pkt_cnt_en = uvm_reg_field::type_id::create("oversized_pkt_cnt_en");
      reserved             = uvm_reg_field::type_id::create("reserved");
      addr0_cnt_en         = uvm_reg_field::type_id::create("addr0_cnt_en");
      addr1_cnt_en         = uvm_reg_field::type_id::create("addr1_cnt_en");
      addr2_cnt_en         = uvm_reg_field::type_id::create("addr2_cnt_en");
      addr3_cnt_en         = uvm_reg_field::type_id::create("addr3_cnt_en");
      router_en.configure           (this, 1, 0, "RW", 0, 1'b1, 1, 1, 0);
      parity_err_cnt_en.configure   (this, 1, 1, "RW", 0, 1'b0, 1, 1, 0);
      oversized_pkt_cnt_en.configure(this, 1, 2, "RW", 0, 1'b0, 1, 1, 0);
      reserved.configure            (this, 1, 3, "RW", 0, 1'b0, 1, 1, 0);
      addr0_cnt_en.configure        (this, 1, 4, "RW", 0, 1'b0, 1, 1, 0);
      addr1_cnt_en.configure        (this, 1, 5, "RW", 0, 1'b0, 1, 1, 0);
      addr2_cnt_en.configure        (this, 1, 6, "RW", 0, 1'b0, 1, 1, 0);
      addr3_cnt_en.configure        (this, 1, 7, "RW", 0, 1'b0, 1, 1, 0);
    endfunction : build

  endclass : en_reg_c

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

  class parity_err_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(parity_err_cnt_reg_c)
    function new(string name = "parity_err_cnt_reg_c"); super.new(name); endfunction
  endclass : parity_err_cnt_reg_c

  class oversized_pkt_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(oversized_pkt_cnt_reg_c)
    function new(string name = "oversized_pkt_cnt_reg_c"); super.new(name); endfunction
  endclass : oversized_pkt_cnt_reg_c

  class addr3_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(addr3_cnt_reg_c)
    function new(string name = "addr3_cnt_reg_c"); super.new(name); endfunction
  endclass : addr3_cnt_reg_c

  class addr0_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(addr0_cnt_reg_c)
    function new(string name = "addr0_cnt_reg_c"); super.new(name); endfunction
  endclass : addr0_cnt_reg_c

  class addr1_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(addr1_cnt_reg_c)
    function new(string name = "addr1_cnt_reg_c"); super.new(name); endfunction
  endclass : addr1_cnt_reg_c

  class addr2_cnt_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(addr2_cnt_reg_c)
    function new(string name = "addr2_cnt_reg_c"); super.new(name); endfunction
  endclass : addr2_cnt_reg_c

  // mem_size_reg: length of the last packet. The DUT only implements [5:0];
  // the model keeps the full byte like the register map does.
  class mem_size_reg_c extends ro_byte_reg_c;
    `uvm_object_utils(mem_size_reg_c)
    function new(string name = "mem_size_reg_c"); super.new(name); endfunction
  endclass : mem_size_reg_c

  //--------------------------------------------------------------------------
  // Memories
  //--------------------------------------------------------------------------
  class yapp_pkt_mem_c extends uvm_mem;
    `uvm_object_utils(yapp_pkt_mem_c)
    function new(string name = "yapp_pkt_mem_c");
      super.new(name, 64, 8, "RO", UVM_NO_COVERAGE);   // bytes of the last packet
    endfunction : new
  endclass : yapp_pkt_mem_c

  class yapp_mem_c extends uvm_mem;
    `uvm_object_utils(yapp_mem_c)
    function new(string name = "yapp_mem_c");
      super.new(name, 256, 8, "RW", UVM_NO_COVERAGE);  // scratch memory
    endfunction : new
  endclass : yapp_mem_c

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

    function new(string name = "yapp_regs_c");
      super.new(name, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
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

  endclass : yapp_regs_c

  //--------------------------------------------------------------------------
  // yapp_router_regs_t : top-level block, places the register block at 0x1000
  //--------------------------------------------------------------------------
  class yapp_router_regs_t extends uvm_reg_block;

    rand yapp_regs_c router_yapp_regs;

    `uvm_object_utils(yapp_router_regs_t)

    function new(string name = "yapp_router_regs_t");
      super.new(name, UVM_NO_COVERAGE);
    endfunction : new

    virtual function void build();
      default_map = create_map("default_map", 'h0, 1, UVM_LITTLE_ENDIAN, 0);
      router_yapp_regs = yapp_regs_c::type_id::create("router_yapp_regs");
      router_yapp_regs.configure(this, "");      // no extra HDL hierarchy level
      router_yapp_regs.build();
      default_map.add_submap(router_yapp_regs.default_map, 'h1000);
    endfunction : build

  endclass : yapp_router_regs_t

endpackage : yapp_router_reg_pkg
