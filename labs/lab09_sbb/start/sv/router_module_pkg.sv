//------------------------------------------------------------------------------
// router_module_pkg.sv -- router module UVC package (Lab 9B)
//
// Needs the packet types of the interface UVCs, hence the imports.
// Include order: scoreboard first (declares the _yapp/_chanN imps), then the
// reference model (declares _hbus), then the env that holds both.
//------------------------------------------------------------------------------
package router_module_pkg;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  import yapp_pkg::*;
  import channel_pkg::*;
  import hbus_pkg::*;

  `include "router_scoreboard.sv"
  `include "router_reference.sv"
  `include "router_module_env.sv"

endpackage : router_module_pkg
