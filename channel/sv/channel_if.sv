//------------------------------------------------------------------------------
// channel_if.sv -- router output-channel interface
//
// One instance per output channel. The UVC plays the RECEIVER: it de-asserts
// suspend to pull bytes out of the router's channel FIFO.
//
// Protocol:
//   * The router presents a byte on `data` with data_vld high.
//   * The receiver reads the byte on a FALLING edge and de-asserts suspend on
//     that same falling edge. On every following RISING edge the router pops
//     the FIFO and presents the next byte, as long as suspend stays low.
//   * Bytes per packet = length + 2 (header, payload, parity); the receiver
//     learns `length` from the header.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

interface channel_if (input logic clock, input logic reset);

  logic [7:0] data;
  logic       data_vld;
  logic       suspend;

  //--------------------------------------------------------------------------
  // Driver side (receiver)
  //--------------------------------------------------------------------------
  task automatic channel_reset();
    @(negedge clock);
    suspend <= 1'b1;
  endtask : channel_reset

  // Receive one packet after waiting `response_delay` cycles from the moment
  // the router offers the header.
  task automatic receive_packet(input int response_delay);
    bit [5:0] length;

    // Wait for the router to present a byte
    do @(negedge clock); while (!data_vld);

    // Optional response delay while the header is held on the bus
    repeat (response_delay) @(negedge clock);

    // Read the header and release suspend on the same falling edge
    length  = data[7:2];
    suspend <= 1'b0;

    // payload bytes + parity byte arrive one per falling edge
    repeat (length + 1) @(negedge clock);

    // The parity byte is being read on this edge: stop the router here
    suspend <= 1'b1;
  endtask : receive_packet

  //--------------------------------------------------------------------------
  // Monitor side: sample on the RISING edge. A byte was consumed by the
  // receiver when data_vld is high and suspend is low at that edge.
  //--------------------------------------------------------------------------
  task automatic collect_packet(output bit [1:0] addr,
                                output bit [5:0] length,
                                output bit [7:0] payload[],
                                output bit [7:0] parity);
    do @(posedge clock); while (!(data_vld && !suspend));
    length  = data[7:2];
    addr    = data[1:0];
    payload = new[length];

    for (int i = 0; i < length; i++) begin
      do @(posedge clock); while (!(data_vld && !suspend));
      payload[i] = data;
    end

    do @(posedge clock); while (!(data_vld && !suspend));
    parity = data;
  endtask : collect_packet

endinterface : channel_if
