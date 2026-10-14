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
  uvm_analysis_export #(yapp_packet)      m_yapp_export;
  uvm_analysis_export #(hbus_transaction) m_hbus_export;
  uvm_analysis_export #(channel_packet)   m_chan_export[3];

  // Storage
  uvm_tlm_analysis_fifo #(yapp_packet)      m_yapp_fifo;
  uvm_tlm_analysis_fifo #(hbus_transaction) m_hbus_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)   m_chan_fifo[3];

  // Blocking readers
  uvm_get_port #(yapp_packet)      m_yapp_get;
  uvm_get_port #(hbus_transaction) m_hbus_get;
  uvm_get_port #(channel_packet)   m_chan_get[3];

  // Register mirror (DUT reset values)
  bit[5:0] m_maxpktsize = 6'h3f;
  bit       m_router_en  = 1'b1;

  // Statistics
  int m_packets_in, m_packets_matched, m_packets_mismatched;
  int m_dropped_disabled, m_dropped_size, m_dropped_addr;

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
  m_yapp_export = new("yapp_export", this);
  m_hbus_export = new("hbus_export", this);
  m_yapp_fifo   = new("yapp_fifo", this);
  m_hbus_fifo   = new("hbus_fifo", this);
  m_yapp_get    = new("yapp_get", this);
  m_hbus_get    = new("hbus_get", this);
  foreach (m_chan_fifo[i]) begin
    m_chan_export[i] = new($sformatf("chan%0d_export", i), this);
    m_chan_fifo[i]   = new($sformatf("chan%0d_fifo", i), this);
    m_chan_get[i]    = new($sformatf("chan%0d_get", i), this);
  end
endfunction : new

//------------------------------------------------------------------------------
function void router_fifo_scoreboard::connect_phase(uvm_phase phase);
  // exports -> FIFO analysis exports (monitors write into the FIFOs)
  m_yapp_export.connect(m_yapp_fifo.analysis_export);
  m_hbus_export.connect(m_hbus_fifo.analysis_export);
  // get ports -> FIFO get/peek exports (we read out of the FIFOs)
  m_yapp_get.connect(m_yapp_fifo.get_peek_export);
  m_hbus_get.connect(m_hbus_fifo.get_peek_export);
  foreach (m_chan_fifo[i]) begin
    m_chan_export[i].connect(m_chan_fifo[i].analysis_export);
    m_chan_get[i].connect(m_chan_fifo[i].get_peek_export);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task router_fifo_scoreboard::run_phase(uvm_phase phase);
  fork
    mirror_registers();
    check_packets();
  join
endtask : run_phase

//------------------------------------------------------------------------------
task router_fifo_scoreboard::mirror_registers();
  hbus_transaction tr;
  forever begin
    m_hbus_get.get(tr);
    if (tr.m_hwr_rd == HBUS_OP_WRITE) begin
      case (tr.m_haddr)
        16'h1000: m_maxpktsize = tr.m_hdata[5:0];
        16'h1001: m_router_en  = tr.m_hdata[0];
        default: ;
      endcase
    end
  end
endtask : mirror_registers

//------------------------------------------------------------------------------
task router_fifo_scoreboard::check_packets();
  yapp_packet    yp;
  channel_packet cp;
  forever begin
    m_yapp_get.get(yp);                    // blocks until the monitor delivers one
    m_packets_in++;
    if (!m_router_en) begin
      m_dropped_disabled++;
      `uvm_info(get_type_name(), "Packet dropped: router disabled", UVM_LOW)
    end else if (yp.m_addr == 2'd3) begin
      m_dropped_addr++;
      `uvm_info(get_type_name(), "Packet dropped: illegal address 3", UVM_LOW)
    end else if (yp.m_length > m_maxpktsize) begin
      m_dropped_size++;
      `uvm_info(get_type_name(), $sformatf("Packet dropped: length %0d > maxpktsize %0d",
                                           yp.m_length, m_maxpktsize), UVM_LOW)
    end else begin
      m_chan_get[yp.m_addr].get(cp);         // blocks until the channel delivers it
      if (comp_equal(yp, cp)) begin
        m_packets_matched++;
        `uvm_info(get_type_name(), $sformatf("Channel %0d packet matched", yp.m_addr), UVM_MEDIUM)
      end else begin
        m_packets_mismatched++;
        `uvm_error(get_type_name(), $sformatf("Channel %0d packet MISMATCH\nexpected:\n%s\nreceived:\n%s",
                                              yp.m_addr, yp.sprint(), cp.sprint()))
      end
    end
  end
endtask : check_packets

//------------------------------------------------------------------------------
function void router_fifo_scoreboard::check_phase(uvm_phase phase);
  if (m_yapp_fifo.used() != 0) begin
    `uvm_error(get_type_name(), $sformatf("%0d YAPP packets still unchecked", m_yapp_fifo.used()))
  end
  foreach (m_chan_fifo[i]) begin
    if (m_chan_fifo[i].used() != 0) begin
      `uvm_error(get_type_name(), $sformatf("%0d packets left in channel %0d FIFO", m_chan_fifo[i].used(), i))
    end
  end
endfunction : check_phase

//------------------------------------------------------------------------------
function void router_fifo_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf({"\n--- FIFO scoreboard report ---\n",
    "  packets received  : %0d\n",
    "  packets matched   : %0d\n",
    "  packets mismatched: %0d\n",
    "  dropped (disabled/oversized/addr3): %0d / %0d / %0d"},
    m_packets_in, m_packets_matched, m_packets_mismatched,
    m_dropped_disabled, m_dropped_size, m_dropped_addr), UVM_LOW)
endfunction : report_phase
