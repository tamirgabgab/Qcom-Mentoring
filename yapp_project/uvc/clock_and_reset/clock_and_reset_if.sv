//------------------------------------------------------------------------------
// clock_and_reset_if.sv -- Clock & Reset UVC interface
//
// The interface OWNS the reset waveform and the clock-generator controls.
// hw_top wires `run_clock` / `clock_period` to the clkgen module and the
// resulting `clock` back into this interface, so the UVC can start the clock,
// pick its period and pulse reset from a sequence instead of from hard-coded
// initial blocks.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

interface clock_and_reset_if (
  input  logic clock,        // clock produced by clkgen (fed back for timing)
  output logic reset,        // active-high reset driven by this UVC
  output logic run_clock,    // 1 = clkgen toggles the clock
  output int   clock_period  // clock period in time units
);

  // Safe defaults before the UVC takes over
  initial begin
    reset        = 1'b0;
    run_clock    = 1'b0;
    clock_period = 10;
  end

  // Start the clock with the requested period and hold reset for
  // `reset_cycles` clock cycles. Reset is asserted immediately, so the first
  // clock edges happen while reset is active.
  task automatic start_clock_and_reset(input int period, input int reset_cycles);
    clock_period = period;
    reset        = 1'b1;
    run_clock    = 1'b1;
    repeat (reset_cycles) begin
      @(posedge clock);
    end
    @(negedge clock);          // release on a falling edge, like every DUT input
    reset = 1'b0;
  endtask

  task automatic stop_clock();
    @(negedge clock);
    run_clock = 1'b0;
  endtask

endinterface : clock_and_reset_if
