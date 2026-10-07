//------------------------------------------------------------------------------
// tb_top.sv -- UVM side of the testbench (Lab 7)
//
// Every UVC package has a `<uvc>_vif_config` typedef. One set() per interface,
// each with a wildcard so every component of that UVC gets the handle.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_pkg::*;
  import channel_pkg::*;
  import hbus_pkg::*;
  import clock_and_reset_pkg::*;

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
