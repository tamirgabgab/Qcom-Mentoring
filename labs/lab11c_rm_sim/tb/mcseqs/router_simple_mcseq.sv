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

  hbus_small_packet_seq hbus_small_seq;
  hbus_large_packet_seq hbus_large_seq;
  hbus_read_max_pkt_seq hbus_read_seq;
  yapp_012_seq          yapp_012;
  yapp_rnd_seq          yapp_rnd;

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
  `uvm_info(get_type_name(), "Executing router_simple_mcseq sequence", UVM_LOW)

  // Small packets allowed, router enabled -- and check the register
  hbus_small_seq = hbus_small_packet_seq::type_id::create("hbus_small_seq");
  if (!hbus_small_seq.randomize()) begin
    `uvm_error(get_type_name(), "hbus_small_seq.randomize() failed")
  end
  hbus_small_seq.start(p_sequencer.hbus_seqr, this);

  hbus_read_seq = hbus_read_max_pkt_seq::type_id::create("hbus_read_seq");
  if (!hbus_read_seq.randomize()) begin
    `uvm_error(get_type_name(), "hbus_read_seq.randomize() failed")
  end
  hbus_read_seq.start(p_sequencer.hbus_seqr, this);

  // Six packets to channels 0, 1, 2
  repeat (2) begin
    yapp_012 = yapp_012_seq::type_id::create("yapp_012");
    if (!yapp_012.randomize()) begin
      `uvm_error(get_type_name(), "yapp_012.randomize() failed")
    end
    yapp_012.start(p_sequencer.yapp_seqr, this);
  end

  // Large packets allowed -- and check the register
  hbus_large_seq = hbus_large_packet_seq::type_id::create("hbus_large_seq");
  if (!hbus_large_seq.randomize()) begin
    `uvm_error(get_type_name(), "hbus_large_seq.randomize() failed")
  end
  hbus_large_seq.start(p_sequencer.hbus_seqr, this);

  hbus_read_seq = hbus_read_max_pkt_seq::type_id::create("hbus_read_seq");
  if (!hbus_read_seq.randomize()) begin
    `uvm_error(get_type_name(), "hbus_read_seq.randomize() failed")
  end
  hbus_read_seq.start(p_sequencer.hbus_seqr, this);

  // Six random packets
  yapp_rnd = yapp_rnd_seq::type_id::create("yapp_rnd");
  if (!yapp_rnd.randomize() with { yapp_rnd.count == 6; }) begin
    `uvm_error(get_type_name(), "yapp_rnd.randomize() failed")
  end
  yapp_rnd.start(p_sequencer.yapp_seqr, this);
endtask : body
