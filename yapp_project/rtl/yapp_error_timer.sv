//------------------------------------------------------------------------------
// yapp_error_timer.sv -- `error` pulse generator.
//
// Every packet with bad parity (accepted while the router is enabled, `start`)
// gets its own one-cycle `error` pulse, 1..10 cycles after its parity byte.
//
// A free-running 4-bit counter picks the wanted delay (rnd_cnt % 10) + 1. The
// pulses still owed are kept in a schedule: sched[k] = 1 means "a pulse k
// cycles from now". Every cycle the schedule moves one step closer and
// `error` follows sched[1]. A new bad packet takes the first free slot at or
// after its wanted delay, wrapping around inside 1..10, so a second bad packet
// that ends before the first pulse never takes that pulse away: each one keeps
// its own cycle. Two pulses may be on adjacent cycles; every cycle with `error`
// high is one pulse.
//
// A free slot always exists: a packet is at least 3 cycles long (header,
// payload, parity), so at most 3 earlier pulses are still owed when a new
// packet ends. For an isolated packet the timing is the same as a single
// down-counter loaded with the delay: the pulse comes `delay` cycles later.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_error_timer (
  input  logic clock,
  input  logic reset,
  input  logic start,     // bad-parity packet accepted (router enabled)
  output logic error
);

  logic [3:0]  rnd_cnt;
  logic [10:1] sched;                       // sched[k]: a pulse k cycles from now
  wire  [3:0]  err_delay = (rnd_cnt % 4'd10) + 4'd1;
  wire  [10:1] sched_next = sched >> 1;     // the schedule after this edge

  // The first free slot of `pending` at or after `want`, wrapping inside 1..10.
  // Returns `want` itself if every slot is taken (cannot happen, see above).
  function automatic logic [3:0] free_slot(input logic [10:1] pending, input logic [3:0] want);
    logic [3:0] slot;
    free_slot = want;
    for (int i = 9; i >= 0; i--) begin
      slot = 4'(((int'(want) - 1 + i) % 10) + 1);
      if (!pending[slot]) begin
        free_slot = slot;
      end
    end
  endfunction : free_slot

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      rnd_cnt <= 4'd0;
    end else begin
      rnd_cnt <= rnd_cnt + 4'd1;
    end
  end

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      sched <= '0;
      error <= 1'b0;
    end else begin
      error <= sched[1];
      if (start) begin
        sched <= sched_next | (10'b1 << (free_slot(sched_next, err_delay) - 4'd1));
      end else begin
        sched <= sched_next;
      end
    end
  end

endmodule : yapp_error_timer
