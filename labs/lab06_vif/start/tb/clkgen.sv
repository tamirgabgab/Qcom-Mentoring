//------------------------------------------------------------------------------
// clkgen.sv -- programmable clock generator
//
// Toggles `clock` every clock_period/2 while run_clock is high. With
// run_clock low the clock sits at 0. The module waits (without spinning)
// whenever the period is 0 or the clock is stopped.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module clkgen (
  input  logic run_clock,
  input  int   clock_period,
  output logic clock
);

  initial clock = 1'b0;

  always begin
    if (run_clock && clock_period > 0) begin
      #(clock_period / 2);
      clock = ~clock;
    end else begin
      clock = 1'b0;
      @(run_clock or clock_period);   // sleep until something changes
    end
  end

endmodule : clkgen
