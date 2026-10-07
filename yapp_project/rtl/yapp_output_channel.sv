//------------------------------------------------------------------------------
// yapp_output_channel.sv -- one router output channel: a 16-byte FIFO plus the
// channel handshake towards the receiver.
//
//   data_vld : FIFO has data, the head byte is on `data`
//   pop      : receiver released `suspend` while a byte was presented
//
// Nothing is registered on the output side: the FIFO head is on the bus as long
// as the FIFO is not empty, and the receiver's `suspend` directly gates the pop,
// so a new byte appears on every rising edge while `suspend` is low.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_output_channel (
  input  logic       clock,
  input  logic       reset,
  // From the input FSM
  input  logic       push,
  input  logic [7:0] din,
  // Channel port
  input  logic       suspend,
  output logic [7:0] data,
  output logic       data_vld,
  // Back-pressure to the input FSM
  output logic       full
);

  logic empty;
  logic pop;

  yapp_fifo #(.DEPTH(16), .WIDTH(8)) u_fifo (
    .clock (clock),
    .reset (reset),
    .push  (push),
    .din   (din),
    .pop   (pop),
    .dout  (data),
    .empty (empty),
    .full  (full)
  );

  assign data_vld = !empty;
  assign pop      = !empty && !suspend;

endmodule : yapp_output_channel
