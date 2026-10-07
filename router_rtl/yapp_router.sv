//------------------------------------------------------------------------------
// yapp_router.sv -- YAPP packet router (Design Under Test)
//
// Written from the course specification ("Project Overview" of the Cadence
// SystemVerilog Accelerated Verification Using UVM training). This is a clean
// re-implementation for teaching: readable, no vendor-specific constructs.
//
// Function
// --------
// * One YAPP input port (in_data / in_data_vld / in_suspend). A packet is
//     byte 0        : header  = {length[5:0], addr[1:0]}
//     byte 1..N     : payload (N == length, 1..63)
//     byte N+1      : parity  = even bitwise parity (XOR) of header + payload
// * Three output channels (data_x / data_vld_x / suspend_x), each fed by a
//   16-byte FIFO. The packet is routed to channel `addr` (0, 1 or 2).
// * HBUS host port (hdata / haddr / hen / hwr_rd) gives synchronous access to
//   the registers and memories (see map below).
//
// Timing (all edges are clock edges)
// ----------------------------------
// * All DUT inputs are driven by the testbench on the FALLING edge and sampled
//   by the DUT on the RISING edge.
// * YAPP input: a byte on in_data is accepted at a rising edge when the target
//   FIFO is not full. When it IS full the DUT asserts in_suspend and the driver
//   must hold the byte unchanged until in_suspend drops.
// * Channel output: data_vld_x is high while a byte is presented on data_x.
//   The receiver reads the byte on a falling edge and de-asserts suspend_x on
//   that same falling edge; at the next rising edge the router pops the FIFO
//   and presents the next byte. While suspend_x stays low a new byte appears
//   on every rising edge.
// * HBUS write : hen=1, hwr_rd=1 for one cycle, hdata written on that edge.
//   HBUS read  : hen=1, hwr_rd=0 for two cycles; haddr is sampled on the first
//   rising edge, hdata is driven by the DUT during the second cycle and
//   tri-stated again after hen goes low.
// * error pulses high for one cycle 1..10 cycles after a bad-parity packet.
//
// Register / memory map (byte wide, HBUS addresses)
// ------------------------------------------------
//   0x1000 ctrl_reg              RW  reset 0x3f  [5:0] maxpktsize, [7:6] unused
//   0x1001 en_reg                RW  reset 0x01  [0] router_en
//                                                [1] parity_err_cnt_en
//                                                [2] oversized_pkt_cnt_en
//                                                [3] reserved
//                                                [4] addr0_cnt_en
//                                                [5] addr1_cnt_en
//                                                [6] addr2_cnt_en
//                                                [7] addr3_cnt_en
//   0x1004 parity_err_cnt_reg    RO  packets received with bad parity
//   0x1005 oversized_pkt_cnt_reg RO  packets with length > maxpktsize
//   0x1006 addr3_cnt_reg         RO  packets addressed to illegal address 3
//   0x1009 addr0_cnt_reg         RO  packets addressed to 0
//   0x100a addr1_cnt_reg         RO  packets addressed to 1
//   0x100b addr2_cnt_reg         RO  packets addressed to 2
//   0x100d mem_size_reg          RO  length of the last packet (6 bits used)
//   0x1010..0x104f yapp_pkt_mem  RO  bytes of the last packet received (64 B)
//   0x1100..0x11ff yapp_mem      RW  scratch memory (256 B)
//
// Behaviour decisions where the spec is silent (keep the reference model and
// the register tests in sync with these!)
// ----------------------------------------------------------------------------
// * router_en == 0 : the input port is "deaf". The packet is tracked so the
//   FSM stays in sync, but nothing is forwarded, counted or stored.
// * A packet is DROPPED (not forwarded) when length > maxpktsize or addr == 3.
//   Dropped packets are still fully received: every enabled counter that
//   applies is incremented, parity is checked, `error` is generated, and
//   yapp_pkt_mem / mem_size_reg are updated. Thus an oversized packet to
//   address 3 increments BOTH oversized_pkt_cnt_reg and addr3_cnt_reg.
// * Changing en_reg / ctrl_reg in the middle of a packet is undefined; the
//   DUT simply uses the values present when the header is accepted.
// * `define INJECT_ERROR corrupts bit 3 of reads from yapp_mem[0x2a] so the
//   uvm_mem_walk_seq test (Lab 11B) can demonstrate a detected failure.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

//------------------------------------------------------------------------------
// Simple synchronous FIFO used for each output channel
//------------------------------------------------------------------------------
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
endmodule


//------------------------------------------------------------------------------
// The router
//------------------------------------------------------------------------------
module yapp_router (
  input  logic        clock,
  input  logic        reset,
  // YAPP input port
  input  logic [7:0]  in_data,
  input  logic        in_data_vld,
  output logic        in_suspend,
  // Output channels
  output logic [7:0]  data_0,
  output logic        data_vld_0,
  input  logic        suspend_0,
  output logic [7:0]  data_1,
  output logic        data_vld_1,
  input  logic        suspend_1,
  output logic [7:0]  data_2,
  output logic        data_vld_2,
  input  logic        suspend_2,
  // HBUS host port
  inout  wire  [7:0]  hdata,
  input  logic [15:0] haddr,
  input  logic        hen,
  input  logic        hwr_rd,
  // Status
  output logic        error
);

  //----------------------------------------------------------------------------
  // Registers and memories (names are used by the RAL backdoor paths)
  //----------------------------------------------------------------------------
  logic [7:0] ctrl_reg;
  logic [7:0] en_reg;
  logic [7:0] parity_err_cnt_reg;
  logic [7:0] oversized_pkt_cnt_reg;
  logic [7:0] addr3_cnt_reg;
  logic [7:0] addr0_cnt_reg;
  logic [7:0] addr1_cnt_reg;
  logic [7:0] addr2_cnt_reg;
  logic [7:0] mem_size_reg;
  logic [7:0] yapp_pkt_mem [0:63];
  logic [7:0] yapp_mem     [0:255];

  // Decoded register fields
  wire [5:0] maxpktsize           = ctrl_reg[5:0];
  wire       router_en            = en_reg[0];
  wire       parity_err_cnt_en    = en_reg[1];
  wire       oversized_pkt_cnt_en = en_reg[2];
  wire       addr0_cnt_en         = en_reg[4];
  wire       addr1_cnt_en         = en_reg[5];
  wire       addr2_cnt_en         = en_reg[6];
  wire       addr3_cnt_en         = en_reg[7];

  localparam logic [15:0] ADDR_CTRL_REG      = 16'h1000;
  localparam logic [15:0] ADDR_EN_REG        = 16'h1001;
  localparam logic [15:0] ADDR_PARITY_ERR    = 16'h1004;
  localparam logic [15:0] ADDR_OVERSIZED     = 16'h1005;
  localparam logic [15:0] ADDR_ADDR3_CNT     = 16'h1006;
  localparam logic [15:0] ADDR_ADDR0_CNT     = 16'h1009;
  localparam logic [15:0] ADDR_ADDR1_CNT     = 16'h100a;
  localparam logic [15:0] ADDR_ADDR2_CNT     = 16'h100b;
  localparam logic [15:0] ADDR_MEM_SIZE      = 16'h100d;
  localparam logic [15:0] ADDR_PKT_MEM_BASE  = 16'h1010;   // .. 0x104f
  localparam logic [15:0] ADDR_MEM_BASE      = 16'h1100;   // .. 0x11ff

  //----------------------------------------------------------------------------
  // Output FIFOs
  //----------------------------------------------------------------------------
  logic [2:0]      fifo_push;
  logic [2:0]      fifo_pop;
  logic [2:0]      fifo_empty;
  logic [2:0]      fifo_full;
  logic [7:0]      fifo_dout [0:2];
  logic [7:0]      fifo_din;

  genvar ch;
  generate
    for (ch = 0; ch < 3; ch++) begin : g_fifo
      yapp_fifo #(.DEPTH(16), .WIDTH(8)) u_fifo (
        .clock (clock),
        .reset (reset),
        .push  (fifo_push[ch]),
        .din   (fifo_din),
        .pop   (fifo_pop[ch]),
        .dout  (fifo_dout[ch]),
        .empty (fifo_empty[ch]),
        .full  (fifo_full[ch])
      );
    end
  endgenerate

  //----------------------------------------------------------------------------
  // Channel output handshake
  //   data_vld_x : FIFO has data, the head byte is on data_x
  //   pop        : receiver released suspend_x while a byte was presented
  //----------------------------------------------------------------------------
  logic [2:0] suspend;
  assign suspend = {suspend_2, suspend_1, suspend_0};

  assign data_0     = fifo_dout[0];
  assign data_1     = fifo_dout[1];
  assign data_2     = fifo_dout[2];
  assign data_vld_0 = !fifo_empty[0];
  assign data_vld_1 = !fifo_empty[1];
  assign data_vld_2 = !fifo_empty[2];

  always_comb begin
    for (int i = 0; i < 3; i++)
      fifo_pop[i] = !fifo_empty[i] && !suspend[i];
  end

  //----------------------------------------------------------------------------
  // Input port FSM
  //----------------------------------------------------------------------------
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

  // Error pulse scheduling: free-running counter picks a 1..10 cycle delay
  logic [3:0] rnd_cnt;
  logic [3:0] err_timer;
  wire  [3:0] err_delay = (rnd_cnt % 4'd10) + 4'd1;

  always_ff @(posedge clock or posedge reset) begin
    if (reset)
      rnd_cnt <= 4'd0;
    else
      rnd_cnt <= rnd_cnt + 4'd1;
  end

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
      err_timer     <= 4'd0;
      error         <= 1'b0;
      parity_err_cnt_reg    <= 8'd0;
      oversized_pkt_cnt_reg <= 8'd0;
      addr3_cnt_reg         <= 8'd0;
      addr0_cnt_reg         <= 8'd0;
      addr1_cnt_reg         <= 8'd0;
      addr2_cnt_reg         <= 8'd0;
      mem_size_reg          <= 8'd0;
    end else begin
      // ---- error pulse generator ----
      error <= 1'b0;
      if (err_timer != 4'd0) begin
        err_timer <= err_timer - 4'd1;
        if (err_timer == 4'd1)
          error <= 1'b1;
      end

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
            if (router_en)
              yapp_pkt_mem[0] <= in_data;
            state <= PAYLOAD;
          end
        end
        //------------------------------------------------------------------
        PAYLOAD: begin
          if (in_data_vld && accept) begin
            parity_acc <= parity_acc ^ in_data;
            if (cur_enabled)
              yapp_pkt_mem[byte_cnt + 6'd1] <= in_data;
            byte_cnt <= byte_cnt + 6'd1;
            if (byte_cnt + 6'd1 == cur_len)
              state <= PARITY;
          end
        end
        //------------------------------------------------------------------
        PARITY: begin
          if (accept) begin
            state <= IDLE;
            if (cur_enabled) begin
              mem_size_reg <= {2'b00, cur_len};
              // counters
              if (in_data != parity_acc) begin
                if (parity_err_cnt_en) parity_err_cnt_reg <= parity_err_cnt_reg + 8'd1;
                err_timer <= err_delay;
              end
              if (cur_oversized && oversized_pkt_cnt_en)
                oversized_pkt_cnt_reg <= oversized_pkt_cnt_reg + 8'd1;
              case (cur_addr)
                2'd0: if (addr0_cnt_en) addr0_cnt_reg <= addr0_cnt_reg + 8'd1;
                2'd1: if (addr1_cnt_en) addr1_cnt_reg <= addr1_cnt_reg + 8'd1;
                2'd2: if (addr2_cnt_en) addr2_cnt_reg <= addr2_cnt_reg + 8'd1;
                2'd3: if (addr3_cnt_en) addr3_cnt_reg <= addr3_cnt_reg + 8'd1;
              endcase
              if (cur_drop)
                $display("%0t ROUTER DROPS PACKET addr=%0d length=%0d (%s)", $time,
                         cur_addr, cur_len,
                         (cur_addr == 2'd3) ? "illegal address" : "length > maxpktsize");
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

  //----------------------------------------------------------------------------
  // HBUS host interface
  //----------------------------------------------------------------------------
  logic [7:0] hdata_out;
  logic       hdata_oe;

  assign hdata = hdata_oe ? hdata_out : 8'bz;

  // Read mux (combinational, registered into hdata_out on the first read edge)
  logic [7:0] rd_mux;
  always_comb begin
    rd_mux = 8'h00;
    if (haddr >= ADDR_MEM_BASE && haddr <= ADDR_MEM_BASE + 16'h00ff) begin
      rd_mux = yapp_mem[haddr[7:0]];
`ifdef INJECT_ERROR
      if (haddr[7:0] == 8'h2a) rd_mux[3] = ~rd_mux[3];
`endif
    end else if (haddr >= ADDR_PKT_MEM_BASE && haddr <= ADDR_PKT_MEM_BASE + 16'h003f) begin
      rd_mux = yapp_pkt_mem[haddr[6:0] - 7'h10];   // 0x1010..0x104f -> 0..63
    end else begin
      case (haddr)
        ADDR_CTRL_REG:   rd_mux = ctrl_reg;
        ADDR_EN_REG:     rd_mux = en_reg;
        ADDR_PARITY_ERR: rd_mux = parity_err_cnt_reg;
        ADDR_OVERSIZED:  rd_mux = oversized_pkt_cnt_reg;
        ADDR_ADDR3_CNT:  rd_mux = addr3_cnt_reg;
        ADDR_ADDR0_CNT:  rd_mux = addr0_cnt_reg;
        ADDR_ADDR1_CNT:  rd_mux = addr1_cnt_reg;
        ADDR_ADDR2_CNT:  rd_mux = addr2_cnt_reg;
        ADDR_MEM_SIZE:   rd_mux = mem_size_reg;
        default:         rd_mux = 8'h00;
      endcase
    end
  end

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      ctrl_reg  <= 8'h3f;
      en_reg    <= 8'h01;
      hdata_out <= 8'h00;
      hdata_oe  <= 1'b0;
    end else begin
      // Read: capture on the first cycle, drive during the second
      hdata_oe <= hen && !hwr_rd;
      if (hen && !hwr_rd)
        hdata_out <= rd_mux;

      // Write: single cycle, RW locations only
      if (hen && hwr_rd) begin
        if (haddr >= ADDR_MEM_BASE && haddr <= ADDR_MEM_BASE + 16'h00ff)
          yapp_mem[haddr[7:0]] <= hdata;
        else case (haddr)
          ADDR_CTRL_REG: ctrl_reg <= hdata;
          ADDR_EN_REG:   en_reg   <= hdata;
          default: ;   // read-only registers and memories ignore writes
        endcase
      end
    end
  end

endmodule
