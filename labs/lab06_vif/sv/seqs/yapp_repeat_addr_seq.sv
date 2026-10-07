//------------------------------------------------------------------------------
// yapp_repeat_addr_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_repeat_addr_seq: two packets to the same random (legal) address
class yapp_repeat_addr_seq extends yapp_base_seq;

  // A random SEQUENCE property, randomized when the sequence is randomized
  rand bit [1:0] seq_addr;
  constraint c_seq_addr { seq_addr != 2'd3; }

  `uvm_object_utils(yapp_repeat_addr_seq)

  extern function new(string name = "yapp_repeat_addr_seq");
  extern task body();

endclass : yapp_repeat_addr_seq

//------------------------------------------------------------------------------
// yapp_repeat_addr_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_repeat_addr_seq::new(string name = "yapp_repeat_addr_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_repeat_addr_seq::body();
  `uvm_info(get_type_name(),
            $sformatf("Executing yapp_repeat_addr_seq sequence (addr %0d)", seq_addr), UVM_LOW)
  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == seq_addr; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);

  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == seq_addr; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
