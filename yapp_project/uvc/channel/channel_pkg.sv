//------------------------------------------------------------------------------
// channel_pkg.sv -- Channel UVC package
//
// Compile this file plus channel_if.sv; add -incdir <this dir>.
//------------------------------------------------------------------------------
package channel_pkg;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"

  `include "channel_defines.sv"   // typedefs and enums of the package

  `include "channel_packet.sv"
  `include "channel_rx_monitor.sv"
  `include "channel_rx_sequencer.sv"
  `include "channel_rx_seqs.sv"
  `include "channel_rx_driver.sv"
  `include "channel_rx_agent.sv"
  `include "channel_env.sv"

endpackage : channel_pkg
