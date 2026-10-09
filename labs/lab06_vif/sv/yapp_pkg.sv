//------------------------------------------------------------------------------
// yapp_pkg.sv -- YAPP UVC package
//
// Include order matters: a class must be included before any file that
// uses it (packet -> monitor -> sequencer -> sequences -> driver -> agent -> env).
// yapp_if.sv is NOT included here: interfaces are compiled, listed in run.f.
//------------------------------------------------------------------------------
package yapp_pkg;

  import uvm_pkg::*;
  import rand_util_pkg::*;   // rnd:: random values (common/rand_util_pkg.sv)
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"

  // Shorthand for the configuration database entry holding the virtual interface
  typedef uvm_config_db #(virtual yapp_if) yapp_vif_config;

  `include "yapp_packet.sv"
  `include "short_yapp_packet.sv"
  `include "yapp_tx_monitor.sv"
  `include "yapp_tx_sequencer.sv"
  `include "yapp_tx_seqs.sv"
  `include "yapp_tx_driver.sv"
  `include "yapp_tx_agent.sv"
  `include "yapp_env.sv"

endpackage : yapp_pkg
