//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 11C: user-defined register stimulus)
//
// Register access API used here (all on uvm_reg):
//   write(status, value)  front door through the HBUS   (bus traffic)
//   read (status, value)  front door through the HBUS
//   poke (status, value)  backdoor: deposit into the RTL variable (no bus cycle)
//   peek (status, value)  backdoor: read the RTL variable
//   predict(value)        set the mirrored value without touching the DUT
//
// One class per file: the classes live in tests/<class>.sv and are included below.
//------------------------------------------------------------------------------

`include "tests/base_test.sv"
`include "tests/uvm_reset_test.sv"
`include "tests/uvm_mem_walk_test.sv"
`include "tests/reg_access_test.sv"
`include "tests/reg_function_test.sv"
`include "tests/reg_function_check_test.sv"
`include "tests/reg_introspection_test.sv"
