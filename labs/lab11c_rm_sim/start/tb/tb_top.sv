//------------------------------------------------------------------------------
// tb_top.sv -- UVM side of the testbench (Lab 11C)
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_top;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"
  import yapp_pkg::*;
  import channel_pkg::*;
  import hbus_pkg::*;
  import clock_and_reset_pkg::*;
  import router_module_pkg::*;
  import yapp_router_reg_pkg::*;     // before router_tb, which uses yapp_router_regs_t

  `include "router_mcsequencer.sv"
  `include "router_mcseqs_lib.sv"
  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial begin
    yapp_vif_config::set(null,            "*.tb.yapp.*",    "vif", hw_top.in0);
    hbus_vif_config::set(null,            "*.tb.hbus.*",    "vif", hw_top.hbus0);
    channel_vif_config::set(null,         "*.tb.chan0.*",   "vif", hw_top.ch0);
    channel_vif_config::set(null,         "*.tb.chan1.*",   "vif", hw_top.ch1);
    channel_vif_config::set(null,         "*.tb.chan2.*",   "vif", hw_top.ch2);
    clock_and_reset_vif_config::set(null, "*.tb.clk_rst.*", "vif", hw_top.clk_rst_if);
    run_test();
  end

endmodule : tb_top
