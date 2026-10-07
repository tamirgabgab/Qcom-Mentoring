//------------------------------------------------------------------------------
// yapp_tx_seqs.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
//
// Every sequence:
//   * extends yapp_base_seq (objection handling),
//   * has an object utils macro and a constructor,
//   * prints its name with `uvm_info at UVM_LOW at the start of body().
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_base_seq: raises an objection while the sequence runs, so run_phase
// does not end before the last packet was delivered.
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);

  `uvm_object_utils(yapp_base_seq)

  function new(string name = "yapp_base_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : yapp_base_seq


//------------------------------------------------------------------------------
// yapp_5_packets: five random packets (provided in Lab 3)
//   Test class configuration template:
//     uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
//                             "default_sequence", yapp_5_packets::get_type());
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_5_packets)

  function new(string name = "yapp_5_packets");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
    repeat (5)
      `uvm_do(req)
  endtask : body

endclass : yapp_5_packets


//------------------------------------------------------------------------------
// Lab 5 sequences
//------------------------------------------------------------------------------

// yapp_1_seq: one packet to address 1
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, { req.addr == 2'd1; })
  endtask : body

endclass : yapp_1_seq


// yapp_012_seq: three packets, to address 0, then 1, then 2
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name = "yapp_012_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, { req.addr == 2'd0; })
    `uvm_do_with(req, { req.addr == 2'd1; })
    `uvm_do_with(req, { req.addr == 2'd2; })
  endtask : body

endclass : yapp_012_seq


// yapp_111_seq: nested sequence -- runs yapp_1_seq three times
class yapp_111_seq extends yapp_base_seq;

  yapp_1_seq seq_1;

  `uvm_object_utils(yapp_111_seq)

  function new(string name = "yapp_111_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat (3)
      `uvm_do(seq_1)
  endtask : body

endclass : yapp_111_seq


// yapp_repeat_addr_seq: two packets to the same random (legal) address
class yapp_repeat_addr_seq extends yapp_base_seq;

  // A random SEQUENCE property, randomized when the sequence is randomized
  rand bit [1:0] seq_addr;
  constraint c_seq_addr { seq_addr != 2'd3; }

  `uvm_object_utils(yapp_repeat_addr_seq)

  function new(string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(),
              $sformatf("Executing yapp_repeat_addr_seq sequence (addr %0d)", seq_addr), UVM_LOW)
    `uvm_do_with(req, { req.addr == seq_addr; })
    `uvm_do_with(req, { req.addr == seq_addr; })
  endtask : body

endclass : yapp_repeat_addr_seq


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


// six_yapp_seq (optional): yapp_rnd_seq constrained to exactly six packets
class six_yapp_seq extends yapp_base_seq;

  yapp_rnd_seq rnd_seq;

  `uvm_object_utils(six_yapp_seq)

  function new(string name = "six_yapp_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing six_yapp_seq sequence", UVM_LOW)
    `uvm_do_with(rnd_seq, { rnd_seq.count == 6; })
  endtask : body

endclass : six_yapp_seq


// yapp_exhaustive_seq: runs every sequence above once
class yapp_exhaustive_seq extends yapp_base_seq;

  yapp_1_seq            seq_1;
  yapp_012_seq          seq_012;
  yapp_111_seq          seq_111;
  yapp_repeat_addr_seq  seq_repeat_addr;
  yapp_incr_payload_seq seq_incr_payload;
  yapp_rnd_seq          seq_rnd;
  six_yapp_seq          seq_six;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    `uvm_do(seq_1)
    `uvm_do(seq_012)
    `uvm_do(seq_111)
    `uvm_do(seq_repeat_addr)
    `uvm_do(seq_incr_payload)
    `uvm_do(seq_rnd)
    `uvm_do(seq_six)
  endtask : body

endclass : yapp_exhaustive_seq


//------------------------------------------------------------------------------
// yapp_coverage_seq (Lab 10): close the coverage model in one run.
// Every length bucket (MIN/SMALL/MEDIUM/LARGE/MAX) to every address 0..3,
// once with good and once with bad parity -> 5 x 4 x 2 = 40 packets.
//------------------------------------------------------------------------------
class yapp_coverage_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_coverage_seq)

  function new(string name = "yapp_coverage_seq");
    super.new(name);
  endfunction : new

  task body();
    int lengths[5] = '{1, 5, 20, 50, 63};   // one value inside each bin
    `uvm_info(get_type_name(), "Executing yapp_coverage_seq sequence", UVM_LOW)
    for (int a = 0; a < 4; a++) begin
      foreach (lengths[i]) begin
        for (int bad = 0; bad < 2; bad++) begin
          `uvm_create(req)
          req.c_addr_legal.constraint_mode(0);
          if (!req.randomize() with { req.addr == a;
                                      req.length == lengths[i];
                                      req.parity_type == (bad ? BAD_PARITY : GOOD_PARITY); })
            `uvm_error(get_type_name(), "Randomization failed")
          `uvm_send(req)
        end
      end
    end
  endtask : body

endclass : yapp_coverage_seq


//------------------------------------------------------------------------------
// yapp_88_packets_seq (Lab 7 optional integration test):
// every address 0..3 (3 is illegal!) with payload lengths 1..22, 20% bad
// parity -> 4 x 22 = 88 packets. The legal-address constraint of the packet
// has to be switched off to reach address 3.
//------------------------------------------------------------------------------
class yapp_88_packets_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_88_packets_seq)

  function new(string name = "yapp_88_packets_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_88_packets_seq sequence", UVM_LOW)
    for (int a = 0; a < 4; a++) begin
      for (int l = 1; l <= 22; l++) begin
        `uvm_create(req)
        req.c_addr_legal.constraint_mode(0);
        if (!req.randomize() with { req.addr == a;
                                    req.length == l;
                                    req.parity_type dist { GOOD_PARITY := 4, BAD_PARITY := 1 }; })
          `uvm_error(get_type_name(), "Randomization failed")
        `uvm_send(req)
      end
    end
  endtask : body

endclass : yapp_88_packets_seq
