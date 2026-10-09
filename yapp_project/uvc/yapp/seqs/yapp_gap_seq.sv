//------------------------------------------------------------------------------
// yapp_gap_seq.sv -- YAPP sequence library (test-plan sequences)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_gap_seq: `count` short good packets to the legal addresses with chosen
// gaps (packet_delay = idle cycles before the packet). The first packet waits
// 3 cycles; after it the gaps cycle 1, 2, 3, 0, 1, 2, 3, 0, ... so every gap
// from back to back (0) to "longer" (3) appears. The sequence counts the gaps
// it asked for between its packets, in the same four classes as the monitor
// (0, 1, 2, 3 or more), so the test can compare planned and measured gaps. The
// first packet is not counted: its gap depends on what the bus did before.
//------------------------------------------------------------------------------
class yapp_gap_seq extends yapp_base_seq;

  rand int unsigned count;

  constraint c_count { count inside {[8:40]}; }

  // Bookkeeping for the test: gaps asked for after the first packet, per class 0, 1, 2, 3+
  int planned_gap[4];

  `uvm_object_utils(yapp_gap_seq)

  extern function new(string name = "yapp_gap_seq");
  extern task body();

endclass : yapp_gap_seq

//------------------------------------------------------------------------------
// yapp_gap_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_gap_seq::new(string name = "yapp_gap_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_gap_seq::body();
  int gap;
  `uvm_info(get_type_name(), $sformatf("Executing yapp_gap_seq (%0d packets)", count), UVM_LOW)
  foreach (planned_gap[i]) begin
    planned_gap[i] = 0;
  end
  for (int i = 0; i < count; i++) begin
    gap = (i == 0) ? 3 : i % 4;
    req = yapp_packet::type_id::create("req");
    req.c_parity_dist.constraint_mode(0);   // the sequence chooses the parity
    req.c_delay.constraint_mode(0);         // the sequence chooses the gap (0 included)
    start_item(req);
    if (!req.randomize() with { req.length       inside {[1:8]};
                                req.parity_type  == GOOD_PARITY;
                                req.packet_delay == gap; }) begin
      `uvm_error(get_type_name(), "req.randomize() failed")
    end
    finish_item(req);
    if (i > 0) begin
      planned_gap[gap]++;
    end
  end
endtask : body
