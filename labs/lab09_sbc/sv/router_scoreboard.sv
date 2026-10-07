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
  uvm_analysis_imp_yapp  #(yapp_packet,    router_scoreboard) yapp_in;
  uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;
  uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;
  uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;

  // Expected packets, one queue per output channel
  yapp_packet pkt_q[3][$];

  // Statistics
  int packets_in;         // received from the YAPP monitor
  int packets_matched;    // compared OK
  int packets_mismatched; // compare failed
  int packets_unexpected; // channel packet with an empty queue
  int packets_dropped_addr3;

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
  yapp_in  = new("yapp_in",  this);
  chan0_in = new("chan0_in", this);
  chan1_in = new("chan1_in", this);
  chan2_in = new("chan2_in", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_scoreboard::write_yapp(yapp_packet packet);
  yapp_packet pkt;
  $cast(pkt, packet.clone());
  packets_in++;
  if (pkt.addr == 2'd3) begin
    // Lab 9A assumes legal traffic only; keep the count honest anyway
    packets_dropped_addr3++;
    `uvm_warning(get_type_name(), "Packet to illegal address 3 is not expected on any channel")
    return;
  end
  pkt_q[pkt.addr].push_back(pkt);
  `uvm_info(get_type_name(),
            $sformatf("Queued packet for channel %0d (%0d waiting)", pkt.addr, pkt_q[pkt.addr].size()),
            UVM_MEDIUM)
endfunction : write_yapp

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan0(channel_packet packet);
  check_channel(0, packet);
endfunction : write_chan0

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan1(channel_packet packet);
  check_channel(1, packet);
endfunction : write_chan1

//------------------------------------------------------------------------------
function void router_scoreboard::write_chan2(channel_packet packet);
  check_channel(2, packet);
endfunction : write_chan2

//------------------------------------------------------------------------------
function void router_scoreboard::check_channel(int ch, channel_packet cp);
  yapp_packet expected;
  if (pkt_q[ch].size() == 0) begin
    packets_unexpected++;
    `uvm_error(get_type_name(),
               $sformatf("Channel %0d packet received but nothing was expected:\n%s", ch, cp.sprint()))
    return;
  end
  expected = pkt_q[ch].pop_front();
  if (comp_equal(expected, cp)) begin
    packets_matched++;
    `uvm_info(get_type_name(), $sformatf("Channel %0d packet matched", ch), UVM_MEDIUM)
  end else begin
    packets_mismatched++;
    `uvm_error(get_type_name(),
               $sformatf("Channel %0d packet MISMATCH\nexpected:\n%s\nreceived:\n%s",
                         ch, expected.sprint(), cp.sprint()))
  end
endfunction : check_channel

//------------------------------------------------------------------------------
function void router_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf({"\n--- Scoreboard report ---\n",
    "  packets received  : %0d\n",
    "  packets matched   : %0d\n",
    "  packets mismatched: %0d\n",
    "  packets unexpected: %0d\n",
    "  packets to addr 3 : %0d\n",
    "  left in queue 0/1/2: %0d / %0d / %0d"},
    packets_in, packets_matched, packets_mismatched, packets_unexpected, packets_dropped_addr3,
    pkt_q[0].size(), pkt_q[1].size(), pkt_q[2].size()), UVM_LOW)
endfunction : report_phase
