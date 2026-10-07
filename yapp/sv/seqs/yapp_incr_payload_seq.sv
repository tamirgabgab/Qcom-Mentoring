//------------------------------------------------------------------------------
// yapp_incr_payload_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_incr_payload_seq: one packet whose payload is 0, 1, 2, ... length-1
class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req)                         // build through the factory
    if (!req.randomize())
      `uvm_error(get_type_name(), "Randomization failed")
    foreach (req.payload[i])
      req.payload[i] = i;
    req.set_parity();                        // payload changed -> recompute parity
    `uvm_send(req)                           // hand it to the driver
  endtask : body

endclass : yapp_incr_payload_seq
