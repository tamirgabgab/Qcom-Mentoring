//------------------------------------------------------------------------------
// router_fifo_scoreboard.sv -- scoreboard + reference model built on TLM
// analysis FIFOs and blocking get() calls (Lab 9D)
//
// Instead of reacting inside write() callbacks, the checking runs as a
// PROCESS in run_phase:
//
//   yapp_export ──► yapp_fifo ──get──► [drop?] ──► chan_fifo[addr] ──get──► compare
//   hbus_export ──► hbus_fifo ──get──► mirror maxpktsize / router_en   (parallel thread)
//
// Analysis FIFOs do NOT clone: every monitor must create a new object per
// transaction (ours do), otherwise the FIFO contents get overwritten.
//------------------------------------------------------------------------------
class router_fifo_scoreboard extends uvm_scoreboard;

  // External connection points
  uvm_analysis_export #(yapp_packet)      yapp_export;
  uvm_analysis_export #(hbus_transaction) hbus_export;
  uvm_analysis_export #(channel_packet)   chan_export[3];

  // Storage
  uvm_tlm_analysis_fifo #(yapp_packet)      yapp_fifo;
  uvm_tlm_analysis_fifo #(hbus_transaction) hbus_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)   chan_fifo[3];

  // Blocking readers
  uvm_get_port #(yapp_packet)      yapp_get;
  uvm_get_port #(hbus_transaction) hbus_get;
  uvm_get_port #(channel_packet)   chan_get[3];

  // Register mirror (DUT reset values)
  bit [5:0] maxpktsize = 6'h3f;
  bit       router_en  = 1'b1;

  // Statistics
  int packets_in, packets_matched, packets_mismatched;
  int dropped_disabled, dropped_size, dropped_addr;

  `uvm_component_utils(router_fifo_scoreboard)

  extern function new(string name, uvm_component parent);

  `include "packet_compare.sv"

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // Parallel thread: keep the register mirror current
  extern task mirror_registers();

  // Main thread: one YAPP packet at a time, in order
  extern task check_packets();

  // Every FIFO must be empty when the test ends
  extern function void check_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass : router_fifo_scoreboard

//------------------------------------------------------------------------------
// router_fifo_scoreboard -- method implementations
//------------------------------------------------------------------------------

function router_fifo_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  yapp_export = new("yapp_export", this);
  hbus_export = new("hbus_export", this);
  yapp_fifo   = new("yapp_fifo", this);
  hbus_fifo   = new("hbus_fifo", this);
  yapp_get    = new("yapp_get", this);
  hbus_get    = new("hbus_get", this);
  foreach (chan_fifo[i]) begin
    chan_export[i] = new($sformatf("chan%0d_export", i), this);
    chan_fifo[i]   = new($sformatf("chan%0d_fifo", i), this);
    chan_get[i]    = new($sformatf("chan%0d_get", i), this);
  end
endfunction : new

function void router_fifo_scoreboard::connect_phase(uvm_phase phase);
  // exports -> FIFO analysis exports (monitors write into the FIFOs)
  yapp_export.connect(yapp_fifo.analysis_export);
  hbus_export.connect(hbus_fifo.analysis_export);
  // get ports -> FIFO get/peek exports (we read out of the FIFOs)
  yapp_get.connect(yapp_fifo.get_peek_export);
  hbus_get.connect(hbus_fifo.get_peek_export);
  foreach (chan_fifo[i]) begin
    chan_export[i].connect(chan_fifo[i].analysis_export);
    chan_get[i].connect(chan_fifo[i].get_peek_export);
  end
endfunction : connect_phase

task router_fifo_scoreboard::run_phase(uvm_phase phase);
  fork
    mirror_registers();
    check_packets();
  join
endtask : run_phase

task router_fifo_scoreboard::mirror_registers();
  hbus_transaction tr;
  forever begin
    hbus_get.get(tr);
    if (tr.hwr_rd == HBUS_WRITE) begin
      case (tr.haddr)
        16'h1000: maxpktsize = tr.hdata[5:0];
        16'h1001: router_en  = tr.hdata[0];
        default: ;
      endcase
    end
  end
endtask : mirror_registers

task router_fifo_scoreboard::check_packets();
  yapp_packet    yp;
  channel_packet cp;
  forever begin
    yapp_get.get(yp);                    // blocks until the monitor delivers one
    packets_in++;
    if (!router_en) begin
      dropped_disabled++;
      `uvm_info(get_type_name(), "Packet dropped: router disabled", UVM_LOW)
    end else if (yp.addr == 2'd3) begin
      dropped_addr++;
      `uvm_info(get_type_name(), "Packet dropped: illegal address 3", UVM_LOW)
    end else if (yp.length > maxpktsize) begin
      dropped_size++;
      `uvm_info(get_type_name(), $sformatf("Packet dropped: length %0d > maxpktsize %0d",
                                           yp.length, maxpktsize), UVM_LOW)
    end else begin
      chan_get[yp.addr].get(cp);         // blocks until the channel delivers it
      if (comp_equal(yp, cp)) begin
        packets_matched++;
        `uvm_info(get_type_name(), $sformatf("Channel %0d packet matched", yp.addr), UVM_MEDIUM)
      end else begin
        packets_mismatched++;
        `uvm_error(get_type_name(), $sformatf("Channel %0d packet MISMATCH\nexpected:\n%s\nreceived:\n%s",
                                              yp.addr, yp.sprint(), cp.sprint()))
      end
    end
  end
endtask : check_packets

function void router_fifo_scoreboard::check_phase(uvm_phase phase);
  if (yapp_fifo.used() != 0)
    `uvm_error(get_type_name(), $sformatf("%0d YAPP packets still unchecked", yapp_fifo.used()))
  foreach (chan_fifo[i])
    if (chan_fifo[i].used() != 0)
      `uvm_error(get_type_name(), $sformatf("%0d packets left in channel %0d FIFO", chan_fifo[i].used(), i))
endfunction : check_phase

function void router_fifo_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf({"\n--- FIFO scoreboard report ---\n",
    "  packets received  : %0d\n",
    "  packets matched   : %0d\n",
    "  packets mismatched: %0d\n",
    "  dropped (disabled/oversized/addr3): %0d / %0d / %0d"},
    packets_in, packets_matched, packets_mismatched,
    dropped_disabled, dropped_size, dropped_addr), UVM_LOW)
endfunction : report_phase
