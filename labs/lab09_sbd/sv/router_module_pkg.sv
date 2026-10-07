//------------------------------------------------------------------------------
// router_module_pkg.sv -- router module UVC package (Lab 9D: + FIFO scoreboard)
//------------------------------------------------------------------------------
package router_module_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_pkg::*;
  import channel_pkg::*;
  import hbus_pkg::*;

  `include "router_scoreboard.sv"
  `include "router_reference.sv"
  `include "router_module_env.sv"
  `include "router_fifo_scoreboard.sv"

endpackage : router_module_pkg
