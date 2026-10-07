//------------------------------------------------------------------------------
// hw_top.sv -- hardware side of the testbench (Lab 6)
//
//   * clkgen produces the clock
//   * a simple initial block produces the reset (the Clock & Reset UVC takes
//     over in Lab 7)
//   * in0 is the YAPP interface instance; the UVM side reaches it through
//     the virtual interface set in tb_top
//   * the router DUT (step 11 of the lab). Before the DUT was added, the
//     initial block also drove `in0.in_suspend <= 0`; the DUT drives it now.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module hw_top;

  logic clock;
  logic reset;

  // Clock
  clkgen clkgen (.run_clock(1'b1), .clock_period(10), .clock(clock));

  // Reset: active for the first 5 clock cycles
  initial begin
    reset = 1'b1;
    repeat (5) @(negedge clock);
    reset = 1'b0;
  end

  // YAPP interface instance
  yapp_if in0 (clock, reset);

  // The DUT -- port list from yapp_router_instance.txt
  yapp_router dut (
    .clock       (clock),
    .reset       (reset),
    // YAPP input port
    .in_data     (in0.in_data),
    .in_data_vld (in0.in_data_vld),
    .in_suspend  (in0.in_suspend),
    // Output channels (not monitored yet)
    .data_0      (),
    .data_vld_0  (),
    .suspend_0   (1'b0),
    .data_1      (),
    .data_vld_1  (),
    .suspend_1   (1'b0),
    .data_2      (),
    .data_vld_2  (),
    .suspend_2   (1'b0),
    // HBUS host port (not used yet)
    .hdata       (),
    .haddr       (16'h0000),
    .hen         (1'b0),
    .hwr_rd      (1'b0),
    // Status
    .error       ()
  );

endmodule : hw_top
