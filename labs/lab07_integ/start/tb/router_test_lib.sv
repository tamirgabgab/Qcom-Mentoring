//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 7: multi-UVC tests)
//
// Sequencer paths (from the base_test topology report):
//   tb.yapp.agent.sequencer
//   tb.chan0.rx_agent.sequencer   (chan1, chan2 likewise -> "tb.chan*.rx_agent.sequencer")
//   tb.hbus.masters[0].sequencer
//   tb.clk_rst.agent.sequencer
//
// One class per file: the classes live in tests/<class>.sv and are included below.
//------------------------------------------------------------------------------

`include "tests/base_test.sv"
`include "tests/simple_test.sv"
`include "tests/test_uvc_integration.sv"
