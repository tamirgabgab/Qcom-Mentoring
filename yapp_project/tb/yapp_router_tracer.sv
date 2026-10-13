//------------------------------------------------------------------------------
// yapp_router_tracer.sv -- testbench-side observer of the router. Not part of
// the DUT: it is bound into every yapp_router instance by yapp_router_tracer_bind
// (listed in run.f after the DUT) and only watches signals.
//
// Three jobs:
//   1. One `uvm_info line per event inside the router, with the id "DUT":
//        IN  pkt #n header / complete     a packet entering, and why it is dropped
//        SUSPEND asserted / released      back-pressure on the input port
//        OUT chX pkt #n start / done      a packet leaving on a channel
//        ERROR pulse                      the error output, cycles after the bad packet
//        CONFIG                           router_en / maxpktsize changed
//        HBUS write / read (UVM_HIGH)     the host port, with the register name
//        FIFO x full / has room (UVM_HIGH)
//      scripts/sim_report.py turns these lines into the timeline of a run.
//   2. With +trace_csv=<file>: one CSV row per clock cycle with the port signals
//      and the state of the input FSM, sampled on the FALLING edge: the inputs
//      the last rising edge saw and the outputs it produced. sim_report.py
//      draws the wave pictures of the report from this file. xrun and Verilator
//      both run it (no simulator-specific code).
//   3. `in_phase`, a signal for the waveform viewer (hw_top.dut.u_tracer.in_phase):
//      what the byte now on in_data is -- IDLE, HEADER, PAYLOAD or PARITY. It
//      changes on the falling edge together with in_data, so HEADER lasts exactly
//      the cycle the header is on the bus. The FSM itself has no HEADER state: it
//      takes the header while in IDLE and is in PAYLOAD from the rising edge that
//      accepted it, half a cycle before the next byte is driven.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module yapp_router_tracer (
  input  logic        clock,
  input  logic        reset,
  // YAPP input port
  input  logic [7:0]  in_data,
  input  logic        in_data_vld,
  input  logic        in_suspend,
  // Output channels
  input  logic [7:0]  data_0,
  input  logic        data_vld_0,
  input  logic        suspend_0,
  input  logic [7:0]  data_1,
  input  logic        data_vld_1,
  input  logic        suspend_1,
  input  logic [7:0]  data_2,
  input  logic        data_vld_2,
  input  logic        suspend_2,
  // HBUS host port
  input  logic [7:0]  hdata,
  input  logic [15:0] haddr,
  input  logic        hen,
  input  logic        hwr_rd,
  // Status
  input  logic        error,
  // Inside the router
  input  logic [5:0]  maxpktsize,
  input  logic        router_en,
  input  logic [2:0]  fifo_full,
  input  logic [1:0]  fsm_state       // yapp_input_fsm: 0 IDLE, 1 PAYLOAD, 2 PARITY
);

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  localparam logic [1:0] S_IDLE    = 2'd0;
  localparam logic [1:0] S_PAYLOAD = 2'd1;
  localparam logic [1:0] S_PARITY  = 2'd2;

  // Channel ports as arrays, so one loop handles the three channels
  logic [7:0] ch_data [3];
  logic       ch_vld  [3];
  logic       ch_susp [3];
  assign ch_data[0] = data_0;  assign ch_vld[0] = data_vld_0;  assign ch_susp[0] = suspend_0;
  assign ch_data[1] = data_1;  assign ch_vld[1] = data_vld_1;  assign ch_susp[1] = suspend_1;
  assign ch_data[2] = data_2;  assign ch_vld[2] = data_vld_2;  assign ch_susp[2] = suspend_2;

  // Input-port bookkeeping
  int         in_count;        // packets whose header was accepted
  logic [1:0] cur_addr;
  logic [5:0] cur_len;
  logic [7:0] parity_acc;      // XOR of header + payload, to judge the parity byte
  int         cur_cycles;      // cycles since the header was accepted
  int         cur_held;        // of which with in_suspend high
  bit         cur_dropped;
  bit         cur_enabled;
  string      cur_reason;
  bit         susp_prev;
  int         susp_cycles;
  int         bad_age[$];         // cycles since each bad-parity packet still owed a pulse

  // Output-channel bookkeeping
  int         out_count   [3];
  int         out_remain  [3];   // bytes still to come in the current packet (0 = idle)
  int         out_cycles  [3];
  int         out_waited  [3];   // cycles the header waited for the receiver
  logic [5:0] out_len     [3];

  // Other state
  bit         rd_pending;
  logic [15:0] rd_addr;
  bit         cfg_known;
  logic       cfg_en_prev;
  logic [5:0] cfg_max_prev;
  logic [2:0] full_prev;

  // CSV trace
  string      csv_name;
  int         csv_fd;

  // The kind of byte on in_data, for the waveform viewer (job 3 above)
  typedef enum logic [1:0] {IDLE, HEADER, PAYLOAD, PARITY} in_phase_e;
  in_phase_e  in_phase;
  logic [1:0] bus_state;       // FSM state when the byte now on in_data was driven

  //--------------------------------------------------------------------------
  // Register name for an HBUS address (map of yapp_hbus_regs.sv)
  //--------------------------------------------------------------------------
  function automatic string reg_name(logic [15:0] addr);
    case (addr)
      16'h1000: return "ctrl_reg";
      16'h1001: return "en_reg";
      16'h1004: return "parity_err_cnt_reg";
      16'h1005: return "oversized_pkt_cnt_reg";
      16'h1006: return "addr3_cnt_reg";
      16'h1009: return "addr0_cnt_reg";
      16'h100a: return "addr1_cnt_reg";
      16'h100b: return "addr2_cnt_reg";
      16'h100d: return "mem_size_reg";
      default: begin
        if (addr >= 16'h1010 && addr <= 16'h104f) begin
          return $sformatf("yapp_pkt_mem[%0d]", addr - 16'h1010);
        end
        if (addr >= 16'h1100 && addr <= 16'h11ff) begin
          return $sformatf("yapp_mem[%0d]", addr - 16'h1100);
        end
        return "unmapped";
      end
    endcase
  endfunction : reg_name

  function automatic string state_name(logic [1:0] s);
    case (s)
      S_IDLE:    return "IDLE";
      S_PAYLOAD: return "PAYLOAD";
      S_PARITY:  return "PARITY";
      default:   return "?";
    endcase
  endfunction : state_name

  //--------------------------------------------------------------------------
  // in_phase: the testbench drives a new byte on the falling edge, after the
  // rising edge that took the previous one, so the FSM state at the falling
  // edge says what the new byte is: IDLE -> a header if in_data_vld is high,
  // PAYLOAD -> a payload byte, PARITY -> the parity byte. A held byte
  // (in_suspend) keeps its phase because the FSM does not move.
  //--------------------------------------------------------------------------
  always @(negedge clock or posedge reset) begin
    if (reset) begin
      bus_state <= S_IDLE;
    end else begin
      bus_state <= fsm_state;
    end
  end

  always_comb begin
    case (bus_state)
      S_PAYLOAD: in_phase = PAYLOAD;
      S_PARITY:  in_phase = PARITY;
      default:   in_phase = in_data_vld ? HEADER : IDLE;
    endcase
  end

  function automatic string phase_name(in_phase_e ph);
    case (ph)
      HEADER:  return "HEADER";
      PAYLOAD: return "PAYLOAD";
      PARITY:  return "PARITY";
      default: return "IDLE";
    endcase
  endfunction : phase_name

  //--------------------------------------------------------------------------
  // Reset
  //--------------------------------------------------------------------------
  always @(posedge reset) begin
    `uvm_info("DUT", "RESET asserted", UVM_MEDIUM)
  end

  always @(negedge reset) begin
    `uvm_info("DUT", $sformatf("RESET released: router_en=%0d maxpktsize=%0d", router_en, maxpktsize), UVM_MEDIUM)
  end

  //--------------------------------------------------------------------------
  // Events, judged on the RISING edge with the values the router samples there
  //--------------------------------------------------------------------------
  always @(posedge clock) begin
    if (reset) begin
      in_count         = 0;
      cur_cycles       = 0;
      susp_prev        = 1'b0;
      bad_age.delete();
      rd_pending       = 1'b0;
      cfg_known        = 1'b0;
      full_prev        = 3'b000;
      for (int ch = 0; ch < 3; ch++) begin
        out_count[ch]  = 0;
        out_remain[ch] = 0;
      end
    end else begin
      trace_input();
      trace_suspend();
      trace_channels();
      trace_hbus();
      trace_config();
    end
  end

  //--------------------------------------------------------------------------
  // Input port: header accepted, bytes counted, packet complete
  //--------------------------------------------------------------------------
  task automatic trace_input();
    bit    accepted;
    bit    bad;
    string target;
    string verdict;
    accepted = !in_suspend;
    foreach (bad_age[i]) begin
      bad_age[i]++;
    end
    if (cur_cycles > 0) begin
      cur_cycles++;
      if (in_suspend) begin
        cur_held++;
      end
    end
    case (fsm_state)
      S_IDLE: begin
        if (in_data_vld && accepted) begin
          in_count++;
          cur_addr    = in_data[1:0];
          cur_len     = in_data[7:2];
          parity_acc  = in_data;
          cur_cycles  = 1;
          cur_held    = 0;
          cur_enabled = router_en;
          cur_dropped = 1'b1;
          if (!router_en) begin
            cur_reason = "router disabled";
          end else if (cur_len > maxpktsize) begin
            cur_reason = $sformatf("oversized: len %0d > maxpktsize %0d", cur_len, maxpktsize);
          end else if (cur_addr == 2'd3) begin
            cur_reason = "illegal address 3";
          end else begin
            cur_dropped = 1'b0;
            cur_reason  = $sformatf("channel %0d", cur_addr);
          end
          if (cur_dropped) begin
            target = {"DROP (", cur_reason, ")"};
          end else begin
            target = cur_reason;
          end
          `uvm_info("DUT", $sformatf("IN  pkt #%0d header: addr=%0d len=%0d -> %s", in_count, cur_addr, cur_len, target),
                    UVM_MEDIUM)
        end
      end
      S_PAYLOAD: begin
        if (in_data_vld && accepted) begin
          parity_acc = parity_acc ^ in_data;
        end
      end
      S_PARITY: begin
        if (accepted) begin
          bad = (in_data != parity_acc);
          if (bad) begin
            verdict = "parity=BAD";
          end else begin
            verdict = "parity=ok";
          end
          if (cur_dropped) begin
            verdict = {verdict, " dropped"};
          end else begin
            verdict = {verdict, " forwarded"};
          end
          `uvm_info("DUT", $sformatf("IN  pkt #%0d complete: addr=%0d len=%0d %s, %0d bytes in %0d cycles (held %0d)",
                                     in_count, cur_addr, cur_len, verdict, cur_len + 2, cur_cycles, cur_held), UVM_MEDIUM)
          if (bad && cur_enabled) begin
            bad_age.push_back(0);
          end
          cur_cycles = 0;
        end
      end
      default: ;
    endcase
  endtask : trace_input

  //--------------------------------------------------------------------------
  // Back-pressure on the input port
  //--------------------------------------------------------------------------
  task automatic trace_suspend();
    if (in_suspend && !susp_prev) begin
      susp_cycles = 0;
      `uvm_info("DUT", $sformatf("SUSPEND asserted: FIFO %0d full, byte 0x%02h held (pkt #%0d)",
                                 (fsm_state == S_IDLE) ? in_data[1:0] : cur_addr, in_data,
                                 (fsm_state == S_IDLE) ? in_count + 1 : in_count), UVM_MEDIUM)
    end
    if (in_suspend) begin
      susp_cycles++;
    end
    if (!in_suspend && susp_prev) begin
      `uvm_info("DUT", $sformatf("SUSPEND released after %0d cycle(s)", susp_cycles), UVM_MEDIUM)
    end
    susp_prev = in_suspend;
    for (int ch = 0; ch < 3; ch++) begin
      if (fifo_full[ch] && !full_prev[ch]) begin
        `uvm_info("DUT", $sformatf("FIFO %0d full", ch), UVM_HIGH)
      end
      if (!fifo_full[ch] && full_prev[ch]) begin
        `uvm_info("DUT", $sformatf("FIFO %0d has room again", ch), UVM_HIGH)
      end
    end
    full_prev = fifo_full;
  endtask : trace_suspend

  //--------------------------------------------------------------------------
  // Output channels: a byte leaves when data_vld is high and suspend is low
  //--------------------------------------------------------------------------
  task automatic trace_channels();
    for (int ch = 0; ch < 3; ch++) begin
      if (out_remain[ch] > 0) begin
        out_cycles[ch]++;
      end
      if (ch_vld[ch] && ch_susp[ch] && out_remain[ch] == 0) begin
        out_waited[ch]++;                       // header offered, receiver not ready
      end
      if (ch_vld[ch] && !ch_susp[ch]) begin
        if (out_remain[ch] == 0) begin
          out_count[ch]++;
          out_len[ch]    = ch_data[ch][7:2];
          out_remain[ch] = out_len[ch] + 2;     // header + payload + parity
          out_cycles[ch] = 1;
          `uvm_info("DUT", $sformatf("OUT ch%0d pkt #%0d start: addr=%0d len=%0d (receiver waited %0d cycle(s))",
                                     ch, out_count[ch], ch_data[ch][1:0], out_len[ch], out_waited[ch]), UVM_MEDIUM)
          out_waited[ch] = 0;
        end
        out_remain[ch]--;
        if (out_remain[ch] == 0) begin
          `uvm_info("DUT", $sformatf("OUT ch%0d pkt #%0d done: %0d bytes in %0d cycles",
                                     ch, out_count[ch], out_len[ch] + 2, out_cycles[ch]), UVM_MEDIUM)
        end
      end
    end
  endtask : trace_channels

  //--------------------------------------------------------------------------
  // Error pulse: `error` rises on the clock edge where a pulse is due, after
  // the block above counted that edge; sampled on the falling edge, each cycle
  // with `error` high is one pulse and pays the oldest bad packet, so its age is
  // the distance from the edge that accepted that bad parity byte (what
  // error_pulse_checker measures too). Bad packets may overlap: each one keeps
  // its own pulse.
  //--------------------------------------------------------------------------
  always @(negedge clock) begin
    if (!reset && error === 1'b1) begin
      if (bad_age.size() > 1) begin
        `uvm_info("DUT", $sformatf("ERROR pulse, %0d cycle(s) after the bad-parity packet (%0d more owed)",
                                   bad_age[0], bad_age.size() - 1), UVM_MEDIUM)
        void'(bad_age.pop_front());
      end else if (bad_age.size() == 1) begin
        `uvm_info("DUT", $sformatf("ERROR pulse, %0d cycle(s) after the bad-parity packet", bad_age[0]), UVM_MEDIUM)
        void'(bad_age.pop_front());
      end else begin
        `uvm_info("DUT", "ERROR pulse with no bad-parity packet before it", UVM_MEDIUM)
      end
    end
  end

  //--------------------------------------------------------------------------
  // HBUS host port: write in one cycle, read data in the second cycle
  //--------------------------------------------------------------------------
  task automatic trace_hbus();
    if (rd_pending) begin
      `uvm_info("DUT", $sformatf("HBUS read  0x%04h (%s) => 0x%02h", rd_addr, reg_name(rd_addr), hdata), UVM_HIGH)
      rd_pending = 1'b0;
    end else if (hen) begin
      if (hwr_rd) begin
        `uvm_info("DUT", $sformatf("HBUS write 0x%04h (%s) <= 0x%02h", haddr, reg_name(haddr), hdata), UVM_HIGH)
      end else begin
        rd_pending = 1'b1;
        rd_addr    = haddr;
      end
    end
  endtask : trace_hbus

  //--------------------------------------------------------------------------
  // Live configuration of the router
  //--------------------------------------------------------------------------
  task automatic trace_config();
    if (cfg_known && (router_en != cfg_en_prev || maxpktsize != cfg_max_prev)) begin
      `uvm_info("DUT", $sformatf("CONFIG router_en=%0d maxpktsize=%0d", router_en, maxpktsize), UVM_MEDIUM)
    end
    cfg_known    = 1'b1;
    cfg_en_prev  = router_en;
    cfg_max_prev = maxpktsize;
  endtask : trace_config

  //--------------------------------------------------------------------------
  // CSV trace: one row per cycle, sampled on the falling edge
  //--------------------------------------------------------------------------
  initial begin
    csv_fd = 0;
    if ($value$plusargs("trace_csv=%s", csv_name)) begin
      csv_fd = $fopen(csv_name, "w");
      if (csv_fd == 0) begin
        `uvm_warning("DUT", {"cannot open +trace_csv file ", csv_name})
      end else begin
        // one literal: a concatenation of literals would be printed as a number
        $fdisplay(csv_fd, "time,reset,in_data,in_data_vld,in_suspend,phase,state,fifo_full,data_0,data_vld_0,suspend_0,data_1,data_vld_1,suspend_1,data_2,data_vld_2,suspend_2,error,hen,hwr_rd,haddr,hdata,router_en,maxpktsize");
      end
    end
  end

  always @(negedge clock) begin
    if (csv_fd != 0) begin
      $fdisplay(csv_fd, "%0t,%0d,%02h,%0d,%0d,%s,%s,%03b,%02h,%0d,%0d,%02h,%0d,%0d,%02h,%0d,%0d,%0d,%0d,%0d,%04h,%02h,%0d,%0d",
                $time, reset, in_data, in_data_vld, in_suspend, phase_name(in_phase), state_name(fsm_state), fifo_full,
                data_0, data_vld_0, suspend_0, data_1, data_vld_1, suspend_1, data_2, data_vld_2, suspend_2,
                error, hen, hwr_rd, haddr, hdata, router_en, maxpktsize);
    end
  end

  final begin
    if (csv_fd != 0) begin
      $fclose(csv_fd);
    end
  end

endmodule : yapp_router_tracer

//------------------------------------------------------------------------------
// yapp_router_tracer_bind -- attaches the tracer to every yapp_router instance.
// An uninstantiated module is a top level for xrun and Verilator alike, so the
// bind takes effect just by listing this file in run.f.
//------------------------------------------------------------------------------
module yapp_router_tracer_bind;
  bind yapp_router yapp_router_tracer u_tracer (
    .clock       (clock),
    .reset       (reset),
    .in_data     (in_data),
    .in_data_vld (in_data_vld),
    .in_suspend  (in_suspend),
    .data_0      (data_0),
    .data_vld_0  (data_vld_0),
    .suspend_0   (suspend_0),
    .data_1      (data_1),
    .data_vld_1  (data_vld_1),
    .suspend_1   (suspend_1),
    .data_2      (data_2),
    .data_vld_2  (data_vld_2),
    .suspend_2   (suspend_2),
    .hdata       (hdata),
    .haddr       (haddr),
    .hen         (hen),
    .hwr_rd      (hwr_rd),
    .error       (error),
    .maxpktsize  (maxpktsize),
    .router_en   (router_en),
    .fifo_full   (fifo_full),
    .fsm_state   (u_input_fsm.state)
  );
endmodule : yapp_router_tracer_bind
