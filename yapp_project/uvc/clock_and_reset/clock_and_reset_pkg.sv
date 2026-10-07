//------------------------------------------------------------------------------
// clock_and_reset_pkg.sv -- Clock & Reset UVC package
//
// Compile this file plus clock_and_reset_if.sv and clkgen.sv; add
// -incdir <this dir> so the `includes below resolve.
//------------------------------------------------------------------------------
package clock_and_reset_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"

  typedef uvm_config_db #(virtual clock_and_reset_if) clock_and_reset_vif_config;

  `include "clock_and_reset_transaction.sv"
  `include "clock_and_reset_sequencer.sv"
  `include "clock_and_reset_seqs.sv"
  `include "clock_and_reset_driver.sv"
  `include "clock_and_reset_agent.sv"
  `include "clock_and_reset_env.sv"

endpackage : clock_and_reset_pkg
