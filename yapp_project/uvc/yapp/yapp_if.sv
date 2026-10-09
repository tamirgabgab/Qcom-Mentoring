//------------------------------------------------------------------------------
// yapp_if.sv -- YAPP input-port interface
//
// Holds the three DUT input-port signals and the protocol knowledge:
//   * send_to_dut()    -- used by the driver to transmit one packet
//   * collect_packets()-- used by the monitor to observe one packet
//   * yapp_reset()     -- used by the driver while reset is active
//
// Protocol recap (see yapp_router.sv for the DUT view):
//   * The driver changes in_data / in_data_vld on the FALLING edge.
//   * The DUT accepts the byte on the next RISING edge unless it is asserting
//     in_suspend (target FIFO full). While in_suspend is high the byte must be
//     held unchanged.
//   * in_data_vld is high for the header and payload bytes and low for the
//     parity byte, which is driven on the falling edge right after the last
//     payload byte.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

interface yapp_if (input logic clock, input logic reset);

  logic [7:0] in_data;
  logic       in_data_vld;
  logic       in_suspend;

  // When the last packet ended (its parity byte accepted): a packet that the
  // driver gets in that same time step may follow with no idle cycle at all
  time last_end;
  bit  last_end_valid;

  //--------------------------------------------------------------------------
  // Driver side
  //--------------------------------------------------------------------------
  task automatic yapp_reset();
    @(negedge clock);
    in_data     <= 8'h00;
    in_data_vld <= 1'b0;
  endtask : yapp_reset

  // Hold the current byte until the DUT has accepted it: a byte is taken at a
  // rising edge where in_suspend is low, so the decision is sampled on the
  // rising edge (exactly as the DUT and the monitor do). The next byte is then
  // driven on the following falling edge. Sampling in_suspend on the falling
  // edge instead would lose a header whose target FIFO was full at the rising
  // edge and freed up right after it (in_suspend falls before the falling edge).
  task automatic wait_accept();
    do @(posedge clock); while (in_suspend);
    @(negedge clock);
  endtask : wait_accept

  task automatic send_to_dut(input bit [1:0] addr,
                             input bit [5:0] length,
                             input bit [7:0] payload[],
                             input bit [7:0] parity,
                             input int       packet_delay);
    // Inter-packet gap: packet_delay idle cycles (rising edges without
    // in_data_vld). Right after a packet the driver already stands on the
    // falling edge where the next byte may go out, so packet_delay == 0 sends
    // the header in the very next cycle (the DUT accepts it there).
    if (!(last_end_valid && $time == last_end)) begin
      @(negedge clock);
    end
    repeat (packet_delay) begin
      @(negedge clock);
    end

    // Header: {length, addr} together with in_data_vld
    in_data_vld <= 1'b1;
    in_data     <= {length, addr};

    // Payload, one byte per accepted cycle
    foreach (payload[i]) begin
      wait_accept();
      in_data <= payload[i];
    end

    // Parity with in_data_vld low
    wait_accept();
    in_data_vld <= 1'b0;
    in_data     <= parity;

    // Make sure the parity byte was accepted before returning to idle
    wait_accept();
    in_data <= 8'h00;
    last_end       = $time;
    last_end_valid = 1'b1;
  endtask : send_to_dut

  //--------------------------------------------------------------------------
  // Monitor side: sample on the RISING edge. A byte is accepted by the DUT
  // when it is not suspending the input at that edge.
  //--------------------------------------------------------------------------
  task automatic collect_packets(output bit [1:0] addr,
                                 output bit [5:0] length,
                                 output bit [7:0] payload[],
                                 output bit [7:0] parity,
                                 output int       idle_cycles);
    // Wait for an accepted header, counting the idle cycles (rising edges
    // without in_data_vld) since the call: right after a packet this is the
    // gap between the two packets
    idle_cycles = 0;
    do begin
      @(posedge clock);
      if (!in_data_vld) begin
        idle_cycles++;
      end
    end while (!(in_data_vld && !in_suspend));
    length = in_data[7:2];
    addr   = in_data[1:0];
    payload = new[length];

    // Payload bytes
    for (int i = 0; i < length; i++) begin
      do @(posedge clock); while (!(in_data_vld && !in_suspend));
      payload[i] = in_data;
    end

    // Parity byte: first accepted cycle after the payload
    do @(posedge clock); while (in_suspend);
    parity = in_data;
  endtask : collect_packets

endinterface : yapp_if
