//------------------------------------------------------------------------------
// yapp_router.sv -- YAPP packet router (Design Under Test), top level
//
// Written from the course specification ("Project Overview" of the Cadence
// SystemVerilog Accelerated Verification Using UVM training). This is a clean
// re-implementation for teaching: readable, no vendor-specific constructs.
// The top level only wires the four kinds of sub-modules (one module per file):
//
//   yapp_input_fsm      u_input_fsm   input port FSM, drop decision, FIFO push
//   yapp_output_channel g_ch[x].u_ch  16-byte FIFO + channel handshake (x = 0..2)
//   yapp_hbus_regs      u_regs        all registers/memories + HBUS host port
//   yapp_error_timer    u_error_timer `error` pulse 1..10 cycles after bad parity
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
//   the registers and memories (map in yapp_hbus_regs.sv).
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
//   and presents the next byte.
// * HBUS write : hen=1, hwr_rd=1 for one cycle. HBUS read: hen=1, hwr_rd=0 for
//   two cycles, haddr sampled on the first edge, hdata driven in the second.
// * error pulses high for one cycle 1..10 cycles after a bad-parity packet.
//
// Register / memory map (byte wide, HBUS addresses)
// ------------------------------------------------
//   0x1000 ctrl_reg              RW  reset 0x3f  [5:0] maxpktsize
//   0x1001 en_reg                RW  reset 0x01  [0] router_en, [1] parity_err_cnt_en,
//                                                [2] oversized_pkt_cnt_en, [4..7] addr0..3_cnt_en
//   0x1004 parity_err_cnt_reg    RO    0x1005 oversized_pkt_cnt_reg RO
//   0x1006 addr3_cnt_reg         RO    0x1009 addr0_cnt_reg         RO
//   0x100a addr1_cnt_reg         RO    0x100b addr2_cnt_reg         RO
//   0x100d mem_size_reg          RO  length of the last packet
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
  // Inter-module signals
  //----------------------------------------------------------------------------
  // register block -> input FSM
  logic [5:0] maxpktsize;
  logic       router_en;

  // input FSM -> output channels
  logic [2:0] fifo_push;
  logic [7:0] fifo_din;
  logic [2:0] fifo_full;

  // input FSM -> register block (end-of-packet report, packet memory write)
  logic       pkt_done;
  logic [1:0] pkt_addr;
  logic [5:0] pkt_len;
  logic       pkt_parity_err;
  logic       pkt_oversized;
  logic       pkt_mem_we;
  logic [5:0] pkt_mem_addr;
  logic [7:0] pkt_mem_wdata;

  // channel ports as vectors
  logic [2:0] suspend;
  logic [7:0] ch_data [0:2];
  logic [2:0] ch_data_vld;

  assign suspend    = {suspend_2, suspend_1, suspend_0};
  assign data_0     = ch_data[0];
  assign data_1     = ch_data[1];
  assign data_2     = ch_data[2];
  assign data_vld_0 = ch_data_vld[0];
  assign data_vld_1 = ch_data_vld[1];
  assign data_vld_2 = ch_data_vld[2];

  //----------------------------------------------------------------------------
  // Input port FSM
  //----------------------------------------------------------------------------
  yapp_input_fsm u_input_fsm (
    .clock          (clock),
    .reset          (reset),
    .in_data        (in_data),
    .in_data_vld    (in_data_vld),
    .in_suspend     (in_suspend),
    .maxpktsize     (maxpktsize),
    .router_en      (router_en),
    .fifo_full      (fifo_full),
    .fifo_push      (fifo_push),
    .fifo_din       (fifo_din),
    .pkt_done       (pkt_done),
    .pkt_addr       (pkt_addr),
    .pkt_len        (pkt_len),
    .pkt_parity_err (pkt_parity_err),
    .pkt_oversized  (pkt_oversized),
    .pkt_mem_we     (pkt_mem_we),
    .pkt_mem_addr   (pkt_mem_addr),
    .pkt_mem_wdata  (pkt_mem_wdata)
  );

  //----------------------------------------------------------------------------
  // Output channels (FIFO + handshake), one per address 0..2
  //----------------------------------------------------------------------------
  genvar ch;
  generate
    for (ch = 0; ch < 3; ch++) begin : g_ch
      yapp_output_channel u_ch (
        .clock    (clock),
        .reset    (reset),
        .push     (fifo_push[ch]),
        .din      (fifo_din),
        .suspend  (suspend[ch]),
        .data     (ch_data[ch]),
        .data_vld (ch_data_vld[ch]),
        .full     (fifo_full[ch])
      );
    end
  endgenerate

  //----------------------------------------------------------------------------
  // Registers, memories and HBUS host interface
  //----------------------------------------------------------------------------
  yapp_hbus_regs u_regs (
    .clock          (clock),
    .reset          (reset),
    .hdata          (hdata),
    .haddr          (haddr),
    .hen            (hen),
    .hwr_rd         (hwr_rd),
    .pkt_done       (pkt_done),
    .pkt_addr       (pkt_addr),
    .pkt_len        (pkt_len),
    .pkt_parity_err (pkt_parity_err),
    .pkt_oversized  (pkt_oversized),
    .pkt_mem_we     (pkt_mem_we),
    .pkt_mem_addr   (pkt_mem_addr),
    .pkt_mem_wdata  (pkt_mem_wdata),
    .maxpktsize     (maxpktsize),
    .router_en      (router_en)
  );

  //----------------------------------------------------------------------------
  // error pulse generator
  //----------------------------------------------------------------------------
  yapp_error_timer u_error_timer (
    .clock (clock),
    .reset (reset),
    .start (pkt_done && pkt_parity_err),
    .error (error)
  );

endmodule : yapp_router
