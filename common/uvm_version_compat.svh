//------------------------------------------------------------------------------
// uvm_version_compat.svh -- tiny shim so the course code compiles unchanged on
// UVM 1.1d (recommended by the training), UVM 1.2 and IEEE 1800.2 libraries.
//
// Only ONE difference actually matters for this project:
//   * UVM 1.1d  : a sequence sees its phase through the public member
//                 `starting_phase`.
//   * UVM 1.2+  : the member is deprecated; use `get_starting_phase()`.
//
// Use `YAPP_STARTING_PHASE wherever a sequence needs its starting phase:
//     uvm_phase phase = `YAPP_STARTING_PHASE;
//     if (phase != null) phase.raise_objection(this);
//------------------------------------------------------------------------------
`ifndef UVM_VERSION_COMPAT_SVH
`define UVM_VERSION_COMPAT_SVH

`ifdef UVM_VERSION_1_1
  `define YAPP_STARTING_PHASE starting_phase
`else
  `define YAPP_STARTING_PHASE get_starting_phase()
`endif

`endif // UVM_VERSION_COMPAT_SVH
