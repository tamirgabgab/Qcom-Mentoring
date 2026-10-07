//------------------------------------------------------------------------------
// yapp_incr_payload_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_incr_payload_seq: one packet whose payload is 0, 1, 2, ... length-1
class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  extern function new(string name = "yapp_incr_payload_seq");
  extern task body();

endclass : yapp_incr_payload_seq

//------------------------------------------------------------------------------
// yapp_incr_payload_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_incr_payload_seq::new(string name = "yapp_incr_payload_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_incr_payload_seq::body();
  `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
  req = yapp_packet::type_id::create("req");   // build through the factory
  if (!req.randomize()) begin
    `uvm_error(get_type_name(), "Randomization failed")
  end
  foreach (req.payload[i]) begin
    req.payload[i] = i;
  end
  req.set_parity();                        // payload changed -> recompute parity
  start_item(req);   // hand it to the driver
  finish_item(req);
endtask : body
