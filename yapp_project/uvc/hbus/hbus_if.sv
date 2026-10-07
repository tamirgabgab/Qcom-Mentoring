//------------------------------------------------------------------------------
// hbus_if.sv -- HBUS host-interface
//
// The data bus is BIDIRECTIONAL. Inside the interface:
//   * `hdata`    is the logic variable the master driver writes,
//   * `hdata_oe` enables the master onto the bus,
//   * `hdata_w`  is the tri-state WIRE that must be connected to the DUT's
//                `hdata` port (never connect the logic variable!).
//
// Protocol (TB drives on the falling edge, DUT samples on the rising edge):
//   WRITE (1 cycle) : hen=1, hwr_rd=1, haddr/hdata valid. hen back to 0 next.
//   READ  (2 cycles): hen=1, hwr_rd=0. DUT samples haddr on the first rising
//                     edge and drives hdata during the second cycle. When hen
//                     goes low the DUT tri-states hdata again.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

interface hbus_if (input logic clock, input logic reset);

  logic [15:0] haddr;
  logic        hen;
  logic        hwr_rd;
  logic [7:0]  hdata;      // master's output value
  logic        hdata_oe;   // master output enable
  wire  [7:0]  hdata_w;    // the shared bus -- connect THIS to the DUT

  assign hdata_w = hdata_oe ? hdata : 8'bz;

  //--------------------------------------------------------------------------
  // Master driver side
  //--------------------------------------------------------------------------
  task automatic hbus_reset();
    @(negedge clock);
    haddr    <= 16'h0000;
    hen      <= 1'b0;
    hwr_rd   <= 1'b0;
    hdata    <= 8'h00;
    hdata_oe <= 1'b0;
  endtask : hbus_reset

  task automatic hbus_write(input bit [15:0] addr, input bit [7:0] data);
    @(negedge clock);
    haddr    <= addr;
    hdata    <= data;
    hdata_oe <= 1'b1;
    hen      <= 1'b1;
    hwr_rd   <= 1'b1;
    @(negedge clock);          // DUT wrote the register on the rising edge
    hen      <= 1'b0;
    hwr_rd   <= 1'b0;
    hdata_oe <= 1'b0;
  endtask : hbus_write

  task automatic hbus_read(input bit [15:0] addr, output bit [7:0] data);
    @(negedge clock);
    haddr    <= addr;
    hdata_oe <= 1'b0;          // bus belongs to the DUT during a read
    hen      <= 1'b1;
    hwr_rd   <= 1'b0;
    @(negedge clock);          // cycle 1 done: DUT sampled haddr
    @(negedge clock);          // cycle 2: DUT is driving hdata_w
    data = hdata_w;
    hen  <= 1'b0;
  endtask : hbus_read

  //--------------------------------------------------------------------------
  // Monitor side: sample on the rising edge
  //--------------------------------------------------------------------------
  task automatic collect_transaction(output bit [15:0] addr,
                                     output bit [7:0]  data,
                                     output bit        is_write);
    do @(posedge clock); while (!hen);
    addr     = haddr;
    is_write = hwr_rd;
    if (is_write) begin
      data = hdata_w;
    end else begin
      @(posedge clock);        // second read cycle: DUT drives the data
      data = hdata_w;
    end
    // Wait for hen to drop so one transaction is not collected twice
    while (hen) @(posedge clock);
  endtask : collect_transaction

endinterface : hbus_if
