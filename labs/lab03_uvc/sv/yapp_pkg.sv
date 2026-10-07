//------------------------------------------------------------------------------
// yapp_pkg.sv -- YAPP UVC package (Lab 3)
//
// Include order matters: a class must be included before any file that
// uses it (packet -> monitor -> sequencer -> sequences -> driver -> agent -> env).
//------------------------------------------------------------------------------
package yapp_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"
  `include "yapp_packet.sv"
  `include "yapp_tx_monitor.sv"
  `include "yapp_tx_sequencer.sv"
  `include "yapp_tx_seqs.sv"
  `include "yapp_tx_driver.sv"
  `include "yapp_tx_agent.sv"
  `include "yapp_env.sv"

endpackage : yapp_pkg
