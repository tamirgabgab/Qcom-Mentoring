//------------------------------------------------------------------------------
// yapp_exhaustive_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_exhaustive_seq: runs every sequence above once
class yapp_exhaustive_seq extends yapp_base_seq;

  yapp_1_seq            m_seq_1;
  yapp_012_seq          m_seq_012;
  yapp_111_seq          m_seq_111;
  yapp_repeat_addr_seq  m_seq_repeat_addr;
  yapp_incr_payload_seq m_seq_incr_payload;
  yapp_rnd_seq          m_seq_rnd;
  six_yapp_seq          m_seq_six;

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

//------------------------------------------------------------------------------
task yapp_exhaustive_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
  m_seq_1 = yapp_1_seq::type_id::create("seq_1");
  if (!m_seq_1.randomize()) begin
    `uvm_error(get_type_name(), "seq_1.randomize() failed")
  end
  m_seq_1.start(m_sequencer, this);

  m_seq_012 = yapp_012_seq::type_id::create("seq_012");
  if (!m_seq_012.randomize()) begin
    `uvm_error(get_type_name(), "seq_012.randomize() failed")
  end
  m_seq_012.start(m_sequencer, this);

  m_seq_111 = yapp_111_seq::type_id::create("seq_111");
  if (!m_seq_111.randomize()) begin
    `uvm_error(get_type_name(), "seq_111.randomize() failed")
  end
  m_seq_111.start(m_sequencer, this);

  m_seq_repeat_addr = yapp_repeat_addr_seq::type_id::create("seq_repeat_addr");
  if (!m_seq_repeat_addr.randomize()) begin
    `uvm_error(get_type_name(), "seq_repeat_addr.randomize() failed")
  end
  m_seq_repeat_addr.start(m_sequencer, this);

  m_seq_incr_payload = yapp_incr_payload_seq::type_id::create("seq_incr_payload");
  if (!m_seq_incr_payload.randomize()) begin
    `uvm_error(get_type_name(), "seq_incr_payload.randomize() failed")
  end
  m_seq_incr_payload.start(m_sequencer, this);

  m_seq_rnd = yapp_rnd_seq::type_id::create("seq_rnd");
  if (!m_seq_rnd.randomize()) begin
    `uvm_error(get_type_name(), "seq_rnd.randomize() failed")
  end
  m_seq_rnd.start(m_sequencer, this);

  m_seq_six = six_yapp_seq::type_id::create("seq_six");
  if (!m_seq_six.randomize()) begin
    `uvm_error(get_type_name(), "seq_six.randomize() failed")
  end
  m_seq_six.start(m_sequencer, this);
endtask : body
