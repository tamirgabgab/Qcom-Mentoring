//------------------------------------------------------------------------------
// router_module_pkg.sv -- router module UVC package (final: Labs 9A-9D)
//
//   router_scoreboard       imp-based scoreboard (9A)
//   router_reference        register-aware packet filter (9B)
//   router_module_env       env with top-level exports (9B/9C)
//   router_fifo_scoreboard  alternative scoreboard on analysis FIFOs (9D)
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
  `include "router_fifo_scoreboard.sv"

endpackage : router_module_pkg
