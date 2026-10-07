//------------------------------------------------------------------------------
// yapp_error_timer.sv -- `error` pulse generator.
//
// A free-running 4-bit counter picks a 1..10 cycle delay. When `start` is
// asserted (a packet with bad parity was accepted while the router was
// enabled) the delay is loaded into `err_timer`; `error` is high for exactly
// one cycle when the timer reaches zero.
//
// Priority (same as the original single always_ff block): the decrement and
// the load are both non-blocking assignments and the load comes last, so a
// `start` in the same cycle as a decrement wins. `error` for an expiring timer
// is still raised in that cycle.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_error_timer (
  input  logic clock,
  input  logic reset,
  input  logic start,     // bad-parity packet accepted (router enabled)
  output logic error
);

  logic [3:0] rnd_cnt;
  logic [3:0] err_timer;
  wire  [3:0] err_delay = (rnd_cnt % 4'd10) + 4'd1;

  always_ff @(posedge clock or posedge reset) begin
    if (reset)
      rnd_cnt <= 4'd0;
    else
      rnd_cnt <= rnd_cnt + 4'd1;
  end

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      err_timer <= 4'd0;
      error     <= 1'b0;
    end else begin
      error <= 1'b0;
      if (err_timer != 4'd0) begin
        err_timer <= err_timer - 4'd1;
        if (err_timer == 4'd1)
          error <= 1'b1;
      end
      // A new bad-parity packet (re)loads the timer; this overrides the decrement
      if (start)
        err_timer <= err_delay;
    end
  end

endmodule : yapp_error_timer
