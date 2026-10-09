//------------------------------------------------------------------------------
// top.sv -- Lab 3: start UVM phasing with run_test()
//
// Include order matters: the test library refers to router_tb, so the
// testbench must be included first.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module top;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  import yapp_pkg::*;

  `include "router_tb.sv"
  `include "router_test_lib.sv"

  initial begin
    run_test();      // the test is chosen with +UVM_TESTNAME=<test>
  end

endmodule : top
