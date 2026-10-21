//------------------------------------------------------------------------------
// tb_top.sv -- UVM side of the testbench (Lab 6, formerly top.sv)
//
// Two jobs: publish the virtual interface(s) in the configuration database
// and start UVM phasing.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module tb_top;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  import yapp_pkg::*;

  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial begin
    // context = null (top), wildcard instance path so that BOTH the driver and
    // the monitor get the same handle, absolute path to the interface instance
    yapp_vif_config::set(null, "*.tb.yapp.*", "vif", hw_top.in0);
    run_test();
  end

endmodule : tb_top
