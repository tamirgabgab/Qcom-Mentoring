//------------------------------------------------------------------------------
// yapp_pkg.sv -- YAPP UVC package (Lab 1: only the packet)
//------------------------------------------------------------------------------
package yapp_pkg;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  `include "yapp_packet.sv"

endpackage : yapp_pkg
