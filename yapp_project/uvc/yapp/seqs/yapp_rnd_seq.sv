//------------------------------------------------------------------------------
// yapp_rnd_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// yapp_rnd_seq (optional): a random number (1..10) of random packets
class yapp_rnd_seq extends yapp_base_seq;

  rand int count;
  constraint c_count { count inside {[1:10]}; }

  `uvm_object_utils(yapp_rnd_seq)

  function new(string name = "yapp_rnd_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(),
              $sformatf("Executing yapp_rnd_seq sequence (%0d packets)", count), UVM_LOW)
    repeat (count)
      `uvm_do(req)
  endtask : body

endclass : yapp_rnd_seq
