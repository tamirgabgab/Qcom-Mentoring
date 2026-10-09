//------------------------------------------------------------------------------
// yapp_coverage_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_coverage_seq (Lab 10): close the coverage model in one run.
// Every length bucket (MIN/SMALL/MEDIUM/LARGE/MAX) to every address 0..3,
// once with good and once with bad parity -> 5 x 4 x 2 = 40 packets.
//------------------------------------------------------------------------------
class yapp_coverage_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_coverage_seq)

  extern function new(string name = "yapp_coverage_seq");
  extern task body();

endclass : yapp_coverage_seq

//------------------------------------------------------------------------------
// yapp_coverage_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_coverage_seq::new(string name = "yapp_coverage_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_coverage_seq::body();
  int lengths[5] = '{1, 5, 20, 50, 63};   // one value inside each bin
  `uvm_info(get_type_name(), "Executing yapp_coverage_seq sequence", UVM_LOW)
  for (int a = 0; a < 4; a++) begin
    foreach (lengths[i]) begin
      for (int bad = 0; bad < 2; bad++) begin
        req = yapp_packet::type_id::create("req");
        req.c_addr_legal.constraint_mode(0);
        req.c_parity_dist.constraint_mode(0);   // the sequence chooses the parity
        if (!req.randomize() with { req.addr == a;
                                    req.length == lengths[i];
                                    req.parity_type == (bad ? BAD_PARITY : GOOD_PARITY); }) begin
          `uvm_error(get_type_name(), "Randomization failed")
        end
        start_item(req);
        finish_item(req);
      end
    end
  end
endtask : body
