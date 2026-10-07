//------------------------------------------------------------------------------
// yapp_fifo.sv -- simple synchronous FIFO, one instance per router output channel
//
// `count` tells empty/full, `dout` always shows the head byte (mem[rd_ptr]),
// push/pop move the pointers. Unchanged from the original single-file DUT.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_fifo #(
  parameter int DEPTH = 16,
  parameter int WIDTH = 8
) (
  input  logic             clock,
  input  logic             reset,
  input  logic             push,
  input  logic [WIDTH-1:0] din,
  input  logic             pop,
  output logic [WIDTH-1:0] dout,
  output logic             empty,
  output logic             full
);
  localparam int AW = $clog2(DEPTH);

  logic [WIDTH-1:0] mem [0:DEPTH-1];
  logic [AW-1:0]    wr_ptr, rd_ptr;
  logic [AW:0]      count;

  assign empty = (count == 0);
  assign full  = (count == DEPTH);
  assign dout  = mem[rd_ptr];

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
      count  <= '0;
    end else begin
      if (push && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr      <= wr_ptr + 1'b1;
      end
      if (pop && !empty)
        rd_ptr <= rd_ptr + 1'b1;
      case ({push && !full, pop && !empty})
        2'b10:   count <= count + 1'b1;
        2'b01:   count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end
endmodule : yapp_fifo
