//------------------------------------------------------------------------------
// router_mcseqs_lib.sv -- multichannel sequence library (Lab 8)
//
// `uvm_declare_p_sequencer gives every sequence a typed `p_sequencer` handle,
// so `p_sequencer.hbus_seqr` / `p_sequencer.yapp_seqr` are available.
// `uvm_do_on(seq, seqr) runs a sub-sequence on another sequencer.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_mcseq_base: objection on the starting phase + p_sequencer
//------------------------------------------------------------------------------
class router_mcseq_base extends uvm_sequence;

  `uvm_object_utils(router_mcseq_base)
  `uvm_declare_p_sequencer(router_mcsequencer)

  function new(string name = "router_mcseq_base");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : router_mcseq_base


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

  hbus_small_packet_seq hbus_small_seq;
  hbus_large_packet_seq hbus_large_seq;
  hbus_read_max_pkt_seq hbus_read_seq;
  yapp_012_seq          yapp_012;
  yapp_rnd_seq          yapp_rnd;

  `uvm_object_utils(router_simple_mcseq)

  function new(string name = "router_simple_mcseq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing router_simple_mcseq sequence", UVM_LOW)

    // Small packets allowed, router enabled -- and check the register
    `uvm_do_on(hbus_small_seq, p_sequencer.hbus_seqr)
    `uvm_do_on(hbus_read_seq,  p_sequencer.hbus_seqr)

    // Six packets to channels 0, 1, 2
    repeat (2)
      `uvm_do_on(yapp_012, p_sequencer.yapp_seqr)

    // Large packets allowed -- and check the register
    `uvm_do_on(hbus_large_seq, p_sequencer.hbus_seqr)
    `uvm_do_on(hbus_read_seq,  p_sequencer.hbus_seqr)

    // Six random packets
    `uvm_do_on_with(yapp_rnd, p_sequencer.yapp_seqr, { yapp_rnd.count == 6; })
  endtask : body

endclass : router_simple_mcseq
