// START POINT of Lab 8: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab08_mcseq/tb/mcseqs/router_simple_mcseq.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_simple_mcseq.sv -- router_simple_mcseq (multichannel sequence library (Lab 8))
// Split out of router_mcseqs_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_simple_mcseq: program the router over HBUS, then send YAPP traffic
//   1. maxpktsize = 20, router enabled        (hbus_small_packet_seq)
//   2. read MAXPKTSIZE back                    (hbus_read_max_pkt_seq)
//   3. 6 packets to addresses 0,1,2            (yapp_012_seq twice)
//   4. maxpktsize = 63                         (hbus_large_packet_seq)
//   5. read MAXPKTSIZE back                    (hbus_read_max_pkt_seq)
//   6. 6 random packets                        (yapp_rnd_seq, count == 6)
//------------------------------------------------------------------------------
class router_simple_mcseq extends router_mcseq_base;

  hbus_small_packet_seq m_hbus_small_seq;
  hbus_large_packet_seq m_hbus_large_seq;
  hbus_read_max_pkt_seq m_hbus_read_seq;
  yapp_012_seq          m_yapp_012;
  yapp_rnd_seq          m_yapp_rnd;

  `uvm_object_utils(router_simple_mcseq)

  extern function new(string name = "router_simple_mcseq");
  extern task body();

endclass : router_simple_mcseq

//------------------------------------------------------------------------------
// router_simple_mcseq -- method implementations
//------------------------------------------------------------------------------

function router_simple_mcseq::new(string name = "router_simple_mcseq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task router_simple_mcseq::body();
  // Small packets allowed, router enabled -- and check the register
  // Six packets to channels 0, 1, 2
  // Large packets allowed -- and check the register
  // Six random packets
  // TODO (Lab 8): write router_simple_mcseq::body
endtask : body
