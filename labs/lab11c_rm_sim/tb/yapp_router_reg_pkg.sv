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
//     yapp_rm.set_hdl_path_root("hw_top.dut.u_regs");
// peek()/poke() resolve to hw_top.dut.u_regs.ctrl_reg, hw_top.dut.u_regs.yapp_mem[i], ...
//------------------------------------------------------------------------------
package yapp_router_reg_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "reg/ctrl_reg_c.sv"
  `include "reg/en_reg_c.sv"
  `include "reg/ro_byte_reg_c.sv"
  `include "reg/parity_err_cnt_reg_c.sv"
  `include "reg/oversized_pkt_cnt_reg_c.sv"
  `include "reg/addr3_cnt_reg_c.sv"
  `include "reg/addr0_cnt_reg_c.sv"
  `include "reg/addr1_cnt_reg_c.sv"
  `include "reg/addr2_cnt_reg_c.sv"
  `include "reg/mem_size_reg_c.sv"
  `include "reg/yapp_pkt_mem_c.sv"
  `include "reg/yapp_mem_c.sv"
  `include "reg/yapp_regs_c.sv"
  `include "reg/yapp_router_regs_t.sv"

endpackage : yapp_router_reg_pkg
