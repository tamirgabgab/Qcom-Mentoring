//------------------------------------------------------------------------------
// hw_top.sv -- hardware side of the testbench (Lab 9A)
//
// The Clock & Reset UVC now owns reset, the clock period and run_clock, so the
// hand-written reset block from Lab 6 is gone.
//
// WARNING: the HBUS data bus is bidirectional. Connect the DUT to the WIRE
// `hdata_w` of the interface, never to the logic variable `hdata`.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module hw_top;

  logic clock;
  logic reset;
  logic run_clock;
  int   clock_period;

  // Clock & Reset UVC interface drives reset, run_clock and clock_period
  clock_and_reset_if clk_rst_if (
    .clock        (clock),
    .reset        (reset),
    .run_clock    (run_clock),
    .clock_period (clock_period)
  );

  // Clock generator controlled by the Clock & Reset UVC
  clkgen clkgen (.run_clock(run_clock), .clock_period(clock_period), .clock(clock));

  // Interface instances, all on the same clock and reset
  yapp_if    in0   (clock, reset);
  hbus_if    hbus0 (clock, reset);
  channel_if ch0   (clock, reset);
  channel_if ch1   (clock, reset);
  channel_if ch2   (clock, reset);

  // Status output of the router
  logic error;

  yapp_router dut (
    .clock       (clock),
    .reset       (reset),
    // YAPP input port
    .in_data     (in0.in_data),
    .in_data_vld (in0.in_data_vld),
    .in_suspend  (in0.in_suspend),
    // Output channels
    .data_0      (ch0.data),
    .data_vld_0  (ch0.data_vld),
    .suspend_0   (ch0.suspend),
    .data_1      (ch1.data),
    .data_vld_1  (ch1.data_vld),
    .suspend_1   (ch1.suspend),
    .data_2      (ch2.data),
    .data_vld_2  (ch2.data_vld),
    .suspend_2   (ch2.suspend),
    // HBUS host port
    .hdata       (hbus0.hdata_w),        // the WIRE, not hbus0.hdata
    .haddr       (hbus0.haddr),
    .hen         (hbus0.hen),
    .hwr_rd      (hbus0.hwr_rd),
    // Status
    .error       (error)
  );

endmodule : hw_top
