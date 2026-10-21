// START POINT of Lab 9D: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab09_sbd/sv/router_fifo_scoreboard.sv; the lab page explains every step.
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
  // get ports -> FIFO get/peek exports (we read out of the FIFOs)
  // TODO (Lab 9D): write router_fifo_scoreboard::connect_phase
endfunction : connect_phase

//------------------------------------------------------------------------------
task router_fifo_scoreboard::run_phase(uvm_phase phase);
  // TODO (Lab 9D): write router_fifo_scoreboard::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
task router_fifo_scoreboard::mirror_registers();
  // TODO (Lab 9D): write router_fifo_scoreboard::mirror_registers
endtask : mirror_registers

//------------------------------------------------------------------------------
task router_fifo_scoreboard::check_packets();
  // TODO (Lab 9D): write router_fifo_scoreboard::check_packets
endtask : check_packets

//------------------------------------------------------------------------------
function void router_fifo_scoreboard::check_phase(uvm_phase phase);
  // TODO (Lab 9D): write router_fifo_scoreboard::check_phase
endfunction : check_phase

//------------------------------------------------------------------------------
function void router_fifo_scoreboard::report_phase(uvm_phase phase);
  // TODO (Lab 9D): write router_fifo_scoreboard::report_phase
endfunction : report_phase
