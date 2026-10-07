//------------------------------------------------------------------------------
// yapp_111_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_111_seq: nested sequence -- runs yapp_1_seq three times
class yapp_111_seq extends yapp_base_seq;

  yapp_1_seq seq_1;

  `uvm_object_utils(yapp_111_seq)

  extern function new(string name = "yapp_111_seq");
  extern task body();

endclass : yapp_111_seq

//------------------------------------------------------------------------------
// yapp_111_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_111_seq::new(string name = "yapp_111_seq");
  super.new(name);
endfunction : new

task yapp_111_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
  repeat (3)
    begin
      seq_1 = yapp_1_seq::type_id::create("seq_1");
      if (!seq_1.randomize())
        `uvm_error(get_type_name(), "seq_1.randomize() failed")
      seq_1.start(m_sequencer, this);
    end
endtask : body
