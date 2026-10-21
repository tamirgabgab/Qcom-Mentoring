// START POINT of Lab 9A: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab09_sba/sv/router_scoreboard.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_scoreboard.sv -- compares what went into the router with what came
// out of each channel (Lab 9A)
//
//   YAPP monitor ──port──► yapp_in  (imp)  : clone and queue per address
//   ChanN monitor──port──► chanN_in (imp)  : pop queue N and compare
//
// An analysis imp needs a write_<suffix>() method per suffix; the suffixes are
// created by the `uvm_analysis_imp_decl macros below (outside the class).
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_yapp)
`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)

class router_scoreboard extends uvm_scoreboard;

  // TLM connection points
  uvm_analysis_imp_yapp  #(yapp_packet,    router_scoreboard) m_yapp_in;
  uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) m_chan0_in;
  uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) m_chan1_in;
  uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) m_chan2_in;

  // Expected packets, one queue per output channel
  yapp_packet m_pkt_q[3][$];

  // Statistics
  int m_packets_in;         // received from the YAPP monitor
  int m_packets_matched;    // compared OK
  int m_packets_mismatched; // compare failed
  int m_packets_unexpected; // channel packet with an empty queue
  int m_packets_dropped_addr3;

  `uvm_component_utils(router_scoreboard)

  extern function new(string name, uvm_component parent);

  // The comparison function supplied with the lab
  `include "packet_compare.sv"

  //--------------------------------------------------------------------------
  // YAPP side: the monitor passes a HANDLE, so clone before storing it
  //--------------------------------------------------------------------------
  extern function void write_yapp(yapp_packet packet);

  //--------------------------------------------------------------------------
  // Channel side
  //--------------------------------------------------------------------------
  extern function void write_chan0(channel_packet packet);
  extern function void write_chan1(channel_packet packet);

  extern function void write_chan2(channel_packet packet);
  extern function void check_channel(int ch, channel_packet cp);

  //--------------------------------------------------------------------------
  // End of test: the numbers must add up
  //   packets_in == matched + mismatched + left in queues (+ addr 3)
  //--------------------------------------------------------------------------
  extern function void report_phase(uvm_phase phase);

endclass : router_scoreboard

//------------------------------------------------------------------------------
// router_scoreboard -- method implementations
//------------------------------------------------------------------------------

function router_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  m_yapp_in  = new("yapp_in",  this);
  m_chan0_in = new("chan0_in", this);
  m_chan1_in = new("chan1_in", this);
  m_chan2_in = new("chan2_in", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_scoreboard::write_yapp(yapp_packet packet);
    // Lab 9A assumes legal traffic only; keep the count honest anyway
  // TODO (Lab 9A): write router_scoreboard::write_yapp
endfunction : write_yapp

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan0(channel_packet packet);
  // TODO (Lab 9A): write router_scoreboard::write_chan0
endfunction : write_chan0

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan1(channel_packet packet);
  // TODO (Lab 9A): write router_scoreboard::write_chan1
endfunction : write_chan1

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan2(channel_packet packet);
  // TODO (Lab 9A): write router_scoreboard::write_chan2
endfunction : write_chan2

//------------------------------------------------------------------------------
function void router_scoreboard::check_channel(int ch, channel_packet cp);
  // TODO (Lab 9A): write router_scoreboard::check_channel
endfunction : check_channel

//------------------------------------------------------------------------------
function void router_scoreboard::report_phase(uvm_phase phase);
  // TODO (Lab 9A): write router_scoreboard::report_phase
endfunction : report_phase
