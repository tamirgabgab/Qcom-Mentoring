//------------------------------------------------------------------------------
// yapp_boundary_seq.sv -- YAPP sequence library (test-plan sequences)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_boundary_seq: packets around the maxpktsize limit, to every address
// including the illegal 3. For each address the lengths maxpktsize - 1,
// maxpktsize, maxpktsize + 1 and 63 are sent (those that exist in 1..63), all
// with good parity. The sequence counts what it sent, so the test can predict
// the counters and the scoreboard without re-deriving the drop rules.
//------------------------------------------------------------------------------
class yapp_boundary_seq extends yapp_base_seq;

  rand bit [5:0] maxpktsize;                // the value programmed into ctrl_reg

  constraint c_max { maxpktsize inside {[2:62]}; }

  // Bookkeeping for the test
  int sent_total;
  int sent_oversized;                       // length > maxpktsize
  int sent_per_addr[4];                     // per address, dropped or not
  int sent_forwarded;                       // legal address and not oversized

  `uvm_object_utils(yapp_boundary_seq)

  extern function new(string name = "yapp_boundary_seq");
  extern task body();

endclass : yapp_boundary_seq

//------------------------------------------------------------------------------
// yapp_boundary_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_boundary_seq::new(string name = "yapp_boundary_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_boundary_seq::body();
  int lens[$];
  int cand[4];
  cand = '{maxpktsize - 1, maxpktsize, maxpktsize + 1, 63};
  foreach (cand[i]) begin
    if (cand[i] >= 1 && cand[i] <= 63 && !(cand[i] inside {lens})) lens.push_back(cand[i]);
  end
  `uvm_info(get_type_name(), $sformatf("Executing yapp_boundary_seq (maxpktsize %0d, lengths %p)",
                                       maxpktsize, lens), UVM_LOW)
  sent_total = 0;
  sent_oversized = 0;
  sent_forwarded = 0;
  foreach (sent_per_addr[i]) sent_per_addr[i] = 0;
  for (int a = 0; a < 4; a++) begin
    foreach (lens[i]) begin
      req = yapp_packet::type_id::create("req");
      req.c_addr_legal.constraint_mode(0);
      start_item(req);
      if (!req.randomize() with { req.addr        == a;
                                  req.length      == lens[i];
                                  req.parity_type == GOOD_PARITY; }) begin
        `uvm_error(get_type_name(), "req.randomize() failed")
      end
      finish_item(req);
      sent_total++;
      sent_per_addr[a]++;
      if (lens[i] > maxpktsize) sent_oversized++;
      if (a != 3 && lens[i] <= maxpktsize) sent_forwarded++;
    end
  end
endtask : body
