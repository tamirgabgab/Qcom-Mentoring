//------------------------------------------------------------------------------
// yapp_012_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_012_seq: three packets, to address 0, then 1, then 2
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  extern function new(string name = "yapp_012_seq");
  extern task body();

endclass : yapp_012_seq

//------------------------------------------------------------------------------
// yapp_012_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_012_seq::new(string name = "yapp_012_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_012_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == 2'd0; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);

  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == 2'd1; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);

  req = yapp_packet::type_id::create("req");
  start_item(req);
  if (!req.randomize() with { req.addr == 2'd2; }) begin
    `uvm_error(get_type_name(), "req.randomize() failed")
  end
  finish_item(req);
endtask : body
