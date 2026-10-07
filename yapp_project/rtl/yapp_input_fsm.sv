//------------------------------------------------------------------------------
// yapp_input_fsm.sv -- YAPP input port state machine.
//
// Receives one packet at a time on in_data / in_data_vld / in_suspend:
//   IDLE    : header {length[5:0], addr[1:0]} -> latch addr/len, decide drop
//   PAYLOAD : `length` payload bytes
//   PARITY  : parity byte, report the packet to the register block
//
// Owns the drop decision, the in_suspend back-pressure, the FIFO push control,
// the running parity and the "ROUTER DROPS PACKET" messages. It does not own
// any register visible on HBUS: counters, mem_size_reg and yapp_pkt_mem live in
// yapp_hbus_regs and are updated through the pkt_* / pkt_mem_* ports, which are
// combinational so the register block updates at the same clock edge as the
// FSM itself.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_input_fsm (
  input  logic       clock,
  input  logic       reset,
  // YAPP input port
  input  logic [7:0] in_data,
  input  logic       in_data_vld,
  output logic       in_suspend,
  // Live register fields (yapp_hbus_regs)
  input  logic [5:0] maxpktsize,
  input  logic       router_en,
  // Output channel FIFOs
  input  logic [2:0] fifo_full,
  output logic [2:0] fifo_push,
  output logic [7:0] fifo_din,
  // End-of-packet report (valid in the cycle the parity byte is accepted and
  // the packet was received with router_en set)
  output logic       pkt_done,
  output logic [1:0] pkt_addr,
  output logic [5:0] pkt_len,
  output logic       pkt_parity_err,
  output logic       pkt_oversized,
  // Packet memory write port (header -> 0, payload byte -> byte_cnt+1)
  output logic       pkt_mem_we,
  output logic [5:0] pkt_mem_addr,
  output logic [7:0] pkt_mem_wdata
);

  typedef enum logic [1:0] {IDLE, PAYLOAD, PARITY} state_e;

  state_e     state;
  logic [1:0] cur_addr;      // address of the packet being received
  logic [5:0] cur_len;       // payload length of the packet being received
  logic [5:0] byte_cnt;      // payload bytes accepted so far
  logic [7:0] parity_acc;    // running XOR of header + payload
  logic       cur_drop;      // packet will not be forwarded
  logic       cur_oversized;
  logic       cur_enabled;   // router_en was set when the header arrived

  // Header decode (valid while state == IDLE and in_data_vld == 1)
  wire [1:0] hdr_addr   = in_data[1:0];
  wire [5:0] hdr_len    = in_data[7:2];
  wire       hdr_ovs    = (hdr_len > maxpktsize);
  wire       hdr_drop   = !router_en || hdr_ovs || (hdr_addr == 2'd3);

  // Target FIFO is full -> ask the driver to hold the current byte.
  // Dropped packets are consumed without FIFO space, so never suspended.
  always_comb begin
    case (state)
      IDLE:    in_suspend = in_data_vld && !hdr_drop && fifo_full[hdr_addr];
      default: in_suspend = !cur_drop && fifo_full[cur_addr];
    endcase
  end

  // A byte is accepted whenever the DUT is not suspending the input
  wire accept = !in_suspend;

  // FIFO push control
  always_comb begin
    fifo_push = 3'b000;
    fifo_din  = in_data;
    case (state)
      IDLE:    if (in_data_vld && accept && !hdr_drop) fifo_push[hdr_addr] = 1'b1;
      PAYLOAD: if (in_data_vld && accept && !cur_drop) fifo_push[cur_addr] = 1'b1;
      PARITY:  if (accept && !cur_drop)                fifo_push[cur_addr] = 1'b1;
      default: ;
    endcase
  end

  // Packet memory write port
  //   header       -> yapp_pkt_mem[0]          if router_en   (live register value)
  //   payload byte -> yapp_pkt_mem[byte_cnt+1] if cur_enabled (value latched at header)
  always_comb begin
    pkt_mem_we    = 1'b0;
    pkt_mem_addr  = 6'd0;
    pkt_mem_wdata = in_data;
    case (state)
      IDLE:    if (in_data_vld && accept && router_en) begin
                 pkt_mem_we   = 1'b1;
                 pkt_mem_addr = 6'd0;
               end
      PAYLOAD: if (in_data_vld && accept && cur_enabled) begin
                 pkt_mem_we   = 1'b1;
                 pkt_mem_addr = byte_cnt + 6'd1;
               end
      default: ;
    endcase
  end

  // End-of-packet report to the register block (counters, mem_size_reg) and
  // to the error timer. Only packets received with router_en set are reported.
  assign pkt_done       = (state == PARITY) && accept && cur_enabled;
  assign pkt_addr       = cur_addr;
  assign pkt_len        = cur_len;
  assign pkt_parity_err = (in_data != parity_acc);
  assign pkt_oversized  = cur_oversized;

  // Main FSM
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      state         <= IDLE;
      cur_addr      <= 2'd0;
      cur_len       <= 6'd0;
      byte_cnt      <= 6'd0;
      parity_acc    <= 8'd0;
      cur_drop      <= 1'b0;
      cur_oversized <= 1'b0;
      cur_enabled   <= 1'b0;
    end else begin
      case (state)
        //------------------------------------------------------------------
        IDLE: begin
          if (in_data_vld && accept) begin
            cur_addr      <= hdr_addr;
            cur_len       <= hdr_len;
            byte_cnt      <= 6'd0;
            parity_acc    <= in_data;
            cur_drop      <= hdr_drop;
            cur_oversized <= hdr_ovs;
            cur_enabled   <= router_en;
            state <= PAYLOAD;
          end
        end
        //------------------------------------------------------------------
        PAYLOAD: begin
          if (in_data_vld && accept) begin
            parity_acc <= parity_acc ^ in_data;
            byte_cnt <= byte_cnt + 6'd1;
            if (byte_cnt + 6'd1 == cur_len) begin
              state <= PARITY;
            end
          end
        end
        //------------------------------------------------------------------
        PARITY: begin
          if (accept) begin
            state <= IDLE;
            if (cur_enabled) begin
              if (cur_drop) begin
                $display("%0t ROUTER DROPS PACKET addr=%0d length=%0d (%s)", $time,
                         cur_addr, cur_len,
                         (cur_addr == 2'd3) ? "illegal address" : "length > maxpktsize");
              end
            end else begin
              $display("%0t ROUTER DROPS PACKET addr=%0d length=%0d (router disabled)",
                       $time, cur_addr, cur_len);
            end
          end
        end
        //------------------------------------------------------------------
        default: state <= IDLE;
      endcase
    end
  end

endmodule : yapp_input_fsm
