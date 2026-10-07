//------------------------------------------------------------------------------
// six_yapp_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// six_yapp_seq (optional): yapp_rnd_seq constrained to exactly six packets
class six_yapp_seq extends yapp_base_seq;

  yapp_rnd_seq rnd_seq;

  `uvm_object_utils(six_yapp_seq)

  extern function new(string name = "six_yapp_seq");
  extern task body();

endclass : six_yapp_seq

//------------------------------------------------------------------------------
// six_yapp_seq -- method implementations
//------------------------------------------------------------------------------

function six_yapp_seq::new(string name = "six_yapp_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task six_yapp_seq::body();
  `uvm_info(get_type_name(), "Executing six_yapp_seq sequence", UVM_LOW)
  rnd_seq = yapp_rnd_seq::type_id::create("rnd_seq");
  if (!rnd_seq.randomize() with { rnd_seq.count == 6; }) begin
    `uvm_error(get_type_name(), "rnd_seq.randomize() failed")
  end
  rnd_seq.start(m_sequencer, this);
endtask : body
