//------------------------------------------------------------------------------
// hbus_pkg.sv -- HBUS UVC package
//
// Compile this file plus hbus_if.sv; add -incdir <this dir>.
//------------------------------------------------------------------------------
package hbus_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "uvm_version_compat.svh"

  typedef uvm_config_db #(virtual hbus_if) hbus_vif_config;

  `include "hbus_transaction.sv"
  `include "hbus_monitor.sv"
  `include "hbus_master_sequencer.sv"
  `include "hbus_master_seqs.sv"
  `include "hbus_master_driver.sv"
  `include "hbus_master_agent.sv"
  `include "hbus_slave_agent.sv"
  `include "hbus_env.sv"
  `include "hbus_reg_adapter.sv"

endpackage : hbus_pkg
