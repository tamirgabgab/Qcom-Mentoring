//------------------------------------------------------------------------------
// yapp_exhaustive_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_exhaustive_seq: runs every sequence above once
class yapp_exhaustive_seq extends yapp_base_seq;

  yapp_1_seq            seq_1;
  yapp_012_seq          seq_012;
  yapp_111_seq          seq_111;
  yapp_repeat_addr_seq  seq_repeat_addr;
  yapp_incr_payload_seq seq_incr_payload;
  yapp_rnd_seq          seq_rnd;
  six_yapp_seq          seq_six;

  `uvm_object_utils(yapp_exhaustive_seq)

  extern function new(string name = "yapp_exhaustive_seq");
  extern task body();

endclass : yapp_exhaustive_seq

//------------------------------------------------------------------------------
// yapp_exhaustive_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_exhaustive_seq::new(string name = "yapp_exhaustive_seq");
  super.new(name);
endfunction : new

task yapp_exhaustive_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
  seq_1 = yapp_1_seq::type_id::create("seq_1");
  if (!seq_1.randomize())
    `uvm_error(get_type_name(), "seq_1.randomize() failed")
  seq_1.start(m_sequencer, this);

  seq_012 = yapp_012_seq::type_id::create("seq_012");
  if (!seq_012.randomize())
    `uvm_error(get_type_name(), "seq_012.randomize() failed")
  seq_012.start(m_sequencer, this);

  seq_111 = yapp_111_seq::type_id::create("seq_111");
  if (!seq_111.randomize())
    `uvm_error(get_type_name(), "seq_111.randomize() failed")
  seq_111.start(m_sequencer, this);

  seq_repeat_addr = yapp_repeat_addr_seq::type_id::create("seq_repeat_addr");
  if (!seq_repeat_addr.randomize())
    `uvm_error(get_type_name(), "seq_repeat_addr.randomize() failed")
  seq_repeat_addr.start(m_sequencer, this);

  seq_incr_payload = yapp_incr_payload_seq::type_id::create("seq_incr_payload");
  if (!seq_incr_payload.randomize())
    `uvm_error(get_type_name(), "seq_incr_payload.randomize() failed")
  seq_incr_payload.start(m_sequencer, this);

  seq_rnd = yapp_rnd_seq::type_id::create("seq_rnd");
  if (!seq_rnd.randomize())
    `uvm_error(get_type_name(), "seq_rnd.randomize() failed")
  seq_rnd.start(m_sequencer, this);

  seq_six = six_yapp_seq::type_id::create("seq_six");
  if (!seq_six.randomize())
    `uvm_error(get_type_name(), "seq_six.randomize() failed")
  seq_six.start(m_sequencer, this);
endtask : body
