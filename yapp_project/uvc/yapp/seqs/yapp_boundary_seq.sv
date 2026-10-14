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

  rand bit[5:0] m_maxpktsize;                // the value programmed into ctrl_reg

  // Bookkeeping for the test
  int m_sent_total;
  int m_sent_oversized;                       // length > maxpktsize
  int m_sent_per_addr[4];                     // per address, dropped or not
  int m_sent_forwarded;                       // legal address and not oversized

  `uvm_object_utils(yapp_boundary_seq)

  extern constraint c_max;

  extern function new(string name = "yapp_boundary_seq");
  extern task body();

endclass : yapp_boundary_seq

//------------------------------------------------------------------------------
// yapp_boundary_seq -- constraints
//------------------------------------------------------------------------------

constraint yapp_boundary_seq::c_max {
  m_maxpktsize inside {[2:62]};
}

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
  cand = '{m_maxpktsize - 1, m_maxpktsize, m_maxpktsize + 1, 63};
  foreach (cand[i]) begin
    if (cand[i] >= 1 && cand[i] <= 63 && !(cand[i] inside {lens})) begin
      lens.push_back(cand[i]);
    end
  end
  `uvm_info(get_type_name(), $sformatf("Executing yapp_boundary_seq (maxpktsize %0d, lengths %p)",
                                       m_maxpktsize, lens), UVM_LOW)
  m_sent_total = 0;
  m_sent_oversized = 0;
  m_sent_forwarded = 0;
  foreach (m_sent_per_addr[i]) begin
    m_sent_per_addr[i] = 0;
  end
  for (int a = 0; a < 4; a++) begin
    foreach (lens[i]) begin
      req = yapp_packet::type_id::create("req");
      req.c_addr_legal.constraint_mode(0);
      req.c_parity_dist.constraint_mode(0);   // the sequence chooses the parity
      start_item(req);
      if (!req.randomize() with { req.m_addr        == a;
                                  req.m_length      == lens[i];
                                  req.m_parity_type == PARITY_TYPE_GOOD; }) begin
        `uvm_error(get_type_name(), "req.randomize() failed")
      end
      finish_item(req);
      m_sent_total++;
      m_sent_per_addr[a]++;
      if (lens[i] > m_maxpktsize) begin
        m_sent_oversized++;
      end
      if (a != 3 && lens[i] <= m_maxpktsize) begin
        m_sent_forwarded++;
      end
    end
  end
endtask : body
