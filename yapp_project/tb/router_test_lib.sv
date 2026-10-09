//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 11C register tests + the test-plan tests)
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

// Test-plan tests (yapp_project only): one DUT feature group each, see docs/test-plan.md
`include "tests/router_disable_test.sv"
`include "tests/router_filter_test.sv"
`include "tests/pkt_mem_test.sv"
`include "tests/reg_bit_walk_test.sv"
`include "tests/hbus_protocol_test.sv"
`include "tests/backpressure_test.sv"
`include "tests/error_pulse_checker.sv"
`include "tests/parity_error_test.sv"
`include "tests/counter_wrap_test.sv"
`include "tests/back_to_back_test.sv"
