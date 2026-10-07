//------------------------------------------------------------------------------
// yapp_1_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_1_seq: one packet to address 1
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  extern function new(string name = "yapp_1_seq");
  extern task body();

endclass : yapp_1_seq

//------------------------------------------------------------------------------
// yapp_1_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_1_seq::new(string name = "yapp_1_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_1_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == 2'd1; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
