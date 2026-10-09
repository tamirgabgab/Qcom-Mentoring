//------------------------------------------------------------------------------
// yapp_hbus_regs.sv -- register block and HBUS host interface of the router.
//
// Owns every register and memory visible on HBUS. The names are used by the
// register model's backdoor paths (hw_top.dut.u_regs.<name>), do not rename:
//
//   0x1000 ctrl_reg              RW  reset 0x3f  [5:0] maxpktsize
//   0x1001 en_reg                RW  reset 0x01  [0] router_en, [1] parity_err_cnt_en,
//                                                [2] oversized_pkt_cnt_en, [4..7] addr0..3_cnt_en
//   0x1004 parity_err_cnt_reg    RO
//   0x1005 oversized_pkt_cnt_reg RO
//   0x1006 addr3_cnt_reg         RO
//   0x1009 addr0_cnt_reg         RO
//   0x100a addr1_cnt_reg         RO
//   0x100b addr2_cnt_reg         RO
//   0x100d mem_size_reg          RO  length of the last packet
//   0x1010..0x104f yapp_pkt_mem  RO  bytes of the last packet (64 B)
//   0x1100..0x11ff yapp_mem      RW  scratch memory (256 B)
//
// HBUS write : hen=1, hwr_rd=1 for one cycle, hdata written on that edge.
// HBUS read  : hen=1, hwr_rd=0 for two cycles; rd_mux is captured on the first
//              rising edge, hdata is driven during the second cycle and
//              tri-stated again after hen goes low.
//
// The counters and mem_size_reg are updated from the end-of-packet report of
// yapp_input_fsm (pkt_*), yapp_pkt_mem from its write port (pkt_mem_*).
//
// `define INJECT_ERROR corrupts bit 3 of reads from yapp_mem[0x2a] so the
// uvm_mem_walk_seq test (Lab 11B) can demonstrate a detected failure.
//------------------------------------------------------------------------------

`timescale 1ns/1ns

module yapp_hbus_regs (
  input  logic        clock,
  input  logic        reset,
  // HBUS host port
  inout  wire  [7:0]  hdata,
  input  logic [15:0] haddr,
  input  logic        hen,
  input  logic        hwr_rd,
  // End-of-packet report from yapp_input_fsm
  input  logic        pkt_done,
  input  logic [1:0]  pkt_addr,
  input  logic [5:0]  pkt_len,
  input  logic        pkt_parity_err,
  input  logic        pkt_oversized,
  // Packet memory write port from yapp_input_fsm
  input  logic        pkt_mem_we,
  input  logic [5:0]  pkt_mem_addr,
  input  logic [7:0]  pkt_mem_wdata,
  // Decoded register fields for yapp_input_fsm
  output logic [5:0]  maxpktsize,
  output logic        router_en
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
  assign maxpktsize = ctrl_reg[5:0];
  assign router_en  = en_reg[0];
  wire parity_err_cnt_en    = en_reg[1];
  wire oversized_pkt_cnt_en = en_reg[2];
  wire addr0_cnt_en         = en_reg[4];
  wire addr1_cnt_en         = en_reg[5];
  wire addr2_cnt_en         = en_reg[6];
  wire addr3_cnt_en         = en_reg[7];

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
  // Packet statistics: counters, mem_size_reg and the packet memory.
  // Everything here is driven by the input FSM and only for packets that were
  // received with router_en set (pkt_done / pkt_mem_we already include that).
  //----------------------------------------------------------------------------
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      parity_err_cnt_reg    <= 8'd0;
      oversized_pkt_cnt_reg <= 8'd0;
      addr3_cnt_reg         <= 8'd0;
      addr0_cnt_reg         <= 8'd0;
      addr1_cnt_reg         <= 8'd0;
      addr2_cnt_reg         <= 8'd0;
      mem_size_reg          <= 8'd0;
    end else begin
      // bytes of the packet being received (header -> 0, payload -> 1..63)
      if (pkt_mem_we) begin
        yapp_pkt_mem[pkt_mem_addr] <= pkt_mem_wdata;
      end

      // end of packet: parity byte accepted
      if (pkt_done) begin
        mem_size_reg <= {2'b00, pkt_len};
        // counters
        if (pkt_parity_err && parity_err_cnt_en) begin
          parity_err_cnt_reg <= parity_err_cnt_reg + 8'd1;
        end
        if (pkt_oversized && oversized_pkt_cnt_en) begin
          oversized_pkt_cnt_reg <= oversized_pkt_cnt_reg + 8'd1;
        end
        case (pkt_addr)
          2'd0: if (addr0_cnt_en) addr0_cnt_reg <= addr0_cnt_reg + 8'd1;
          2'd1: if (addr1_cnt_en) addr1_cnt_reg <= addr1_cnt_reg + 8'd1;
          2'd2: if (addr2_cnt_en) addr2_cnt_reg <= addr2_cnt_reg + 8'd1;
          2'd3: if (addr3_cnt_en) addr3_cnt_reg <= addr3_cnt_reg + 8'd1;
        endcase
      end
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
      if (haddr[7:0] == 8'h2a) begin
        rd_mux[3] = ~rd_mux[3];
      end
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
      if (hen && !hwr_rd) begin
        hdata_out <= rd_mux;
      end

      // Write: single cycle, RW locations only
      if (hen && hwr_rd) begin
        if (haddr >= ADDR_MEM_BASE && haddr <= ADDR_MEM_BASE + 16'h00ff) begin
          yapp_mem[haddr[7:0]] <= hdata;
        end else begin
          case (haddr)
            ADDR_CTRL_REG: ctrl_reg <= hdata;
            ADDR_EN_REG:   en_reg   <= hdata;
            default: ;   // read-only registers and memories ignore writes
          endcase
        end
      end
    end
  end

endmodule : yapp_hbus_regs
