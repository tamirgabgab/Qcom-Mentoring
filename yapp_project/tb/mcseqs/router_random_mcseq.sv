//------------------------------------------------------------------------------
// router_random_mcseq.sv -- router_random_mcseq (multichannel sequence library)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_random_mcseq: the random tests' scenario, on the HBUS and YAPP
// sequencers of router_mcsequencer.
//   * a total of min_packets..max_packets packets, split into
//     min_bursts..max_bursts bursts (every burst has at least one packet)
//   * before each burst, a random configuration written over the HBUS:
//       ctrl_reg  maxpktsize 0 / 1 / 62 / 63 with extreme_pct, else 2..61;
//                 bits [7:6] random (stored, no function)
//       en_reg    router_en = 0 with router_off_pct; the six counter enables
//                 all on (30%), all off (10%) or a random mask (60%)
//     then a few random HBUS reads (registers, packet memory, unmapped
//     addresses) and scratch-memory writes and reads
//   * the burst: yapp_random_burst_seq with the knobs below; with storm_pct a
//     burst is a "storm" of 1..3-byte packets, mostly back to back, half of
//     them with bad parity (overlapping error pulses)
//   * at the end every register and the stored packet are read
// The configuration only changes between bursts, when every packet of the
// previous burst has been accepted by the router, so the reference model
// (which decides at the end of a packet) agrees with the DUT (which decides at
// the header). The reads are checked by router_reference (check_reads = 1).
// Each burst is announced with a [TEST] STAGE line.
//------------------------------------------------------------------------------
class router_random_mcseq extends router_mcseq_base;

  // Scenario knobs (set by the test before start)
  int min_packets  = 10;
  int max_packets  = 100;
  int min_bursts   = 2;
  int max_bursts   = 6;
  int extreme_pct  = 40;                    // maxpktsize from {0, 1, 62, 63}
  int router_off_pct = 15;                  // bursts with router_en = 0
  int storm_pct    = 0;                     // bursts that are bad-parity storms
  int reads_min    = 3;                     // random HBUS reads after each configuration
  int reads_max    = 8;

  // Knobs handed to every (non-storm) burst, see yapp_random_burst_seq
  int addr3_pct     = 5;
  int bad_pct       = 15;
  int short_pct     = 0;
  int long_pct      = 0;
  int boundary_pct  = 40;
  int gap0_pct      = 25;
  int gap_short_pct = 35;

  // What happened, for the test's checks and report
  int total_packets;
  int num_bursts;
  int num_storms;
  int num_reads;

  `uvm_object_utils(router_random_mcseq)

  extern function new(string name = "router_random_mcseq");
  extern task body();

  // Draw a configuration and write it; returns the maxpktsize written
  extern task configure_router(int burst, output bit [5:0] max, output string text);

  // A few random reads (and scratch-memory writes) over the HBUS
  extern task random_reads(int n);

  // Every register, then yapp_pkt_mem[0..mem_size]
  extern task final_reads();

  extern task hbus_write(bit [15:0] addr, bit [7:0] data);
  extern task hbus_read(bit [15:0] addr, output bit [7:0] data);

  // A [TEST] STAGE line, as base_test::stage() prints it
  extern function void stage(string what);

endclass : router_random_mcseq

//------------------------------------------------------------------------------
// router_random_mcseq -- method implementations
//------------------------------------------------------------------------------

function router_random_mcseq::new(string name = "router_random_mcseq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task router_random_mcseq::body();
  int                   counts[];
  bit [5:0]             max;
  bit                   storm;
  string                cfg_text;
  yapp_random_burst_seq burst;

  total_packets = rnd::get_int(min_packets, max_packets, "router_random_mcseq.packets");
  num_bursts    = rnd::get_int(min_bursts, max_bursts, "router_random_mcseq.bursts");
  if (num_bursts > total_packets) begin
    num_bursts = total_packets;
  end
  // every burst gets one packet, the rest are spread at random
  counts = new[num_bursts];
  foreach (counts[i]) begin
    counts[i] = 1;
  end
  for (int i = num_bursts; i < total_packets; i++) begin
    counts[rnd::get_index(num_bursts, "router_random_mcseq.burst_of_packet")]++;
  end
  stage($sformatf("random scenario: %0d packets in %0d bursts", total_packets, num_bursts));

  for (int b = 0; b < num_bursts; b++) begin
    configure_router(b, max, cfg_text);
    random_reads(rnd::get_int(reads_min, reads_max, "router_random_mcseq.reads"));
    storm = (rnd::get_int(0, 99, "router_random_mcseq.storm") < storm_pct);
    burst = yapp_random_burst_seq::type_id::create($sformatf("burst%0d", b));
    if (!burst.randomize() with { count == counts[b]; }) begin
      `uvm_error(get_type_name(), "burst.randomize() failed")
    end
    burst.maxpktsize = max;
    if (storm) begin
      num_storms++;
      burst.addr3_pct     = addr3_pct;
      burst.bad_pct       = 50;
      burst.short_pct     = 100;
      burst.long_pct      = 0;
      burst.boundary_pct  = 0;
      burst.gap0_pct      = 90;
      burst.gap_short_pct = 10;
    end else begin
      burst.addr3_pct     = addr3_pct;
      burst.bad_pct       = bad_pct;
      burst.short_pct     = short_pct;
      burst.long_pct      = long_pct;
      burst.boundary_pct  = boundary_pct;
      burst.gap0_pct      = gap0_pct;
      burst.gap_short_pct = gap_short_pct;
    end
    // (if/else, not ?: -- Verilator pads string literals of a ?: to the same width)
    if (storm) begin
      stage($sformatf("burst %0d/%0d: %s, %0d packet(s) -- storm: 1..3-byte packets back to back, half with bad parity",
                      b + 1, num_bursts, cfg_text, counts[b]));
    end else begin
      stage($sformatf("burst %0d/%0d: %s, %0d packet(s)", b + 1, num_bursts, cfg_text, counts[b]));
    end
    burst.start(p_sequencer.yapp_seqr, this);
    stage($sformatf("burst %0d/%0d sent: %s", b + 1, num_bursts, burst.summary()));
  end

  stage("final reads: every register and the stored packet, checked against the reference model");
  final_reads();
endtask : body

//------------------------------------------------------------------------------
task router_random_mcseq::configure_router(int burst, output bit [5:0] max, output string text);
  bit [7:0] ctrl;
  bit [7:0] en;
  int       r;
  string    on_off;
  if (rnd::get_int(0, 99, "router_random_mcseq.extreme") < extreme_pct) begin
    case (rnd::get_int(0, 3, "router_random_mcseq.extreme_max"))
      0:       max = 6'd0;
      1:       max = 6'd1;
      2:       max = 6'd62;
      default: max = 6'd63;
    endcase
  end else begin
    max = 6'(rnd::get_int(2, 61, "router_random_mcseq.max"));
  end
  ctrl = {2'(rnd::get_int(0, 3, "router_random_mcseq.ctrl_unused")), max};
  r = rnd::get_int(0, 99, "router_random_mcseq.cnt_en");
  if (r < 30) begin
    en[7:1] = 7'h7f;
  end else if (r < 40) begin
    en[7:1] = 7'h00;
  end else begin
    en[7:1] = 7'(rnd::get_int(0, 127, "router_random_mcseq.cnt_en_mask"));
  end
  en[0] = (rnd::get_int(0, 99, "router_random_mcseq.router_off") >= router_off_pct);
  hbus_write(16'h1000, ctrl);
  hbus_write(16'h1001, en);
  if (en[0]) begin
    on_off = "on";
  end else begin
    on_off = "OFF";
  end
  text = $sformatf("ctrl=0x%02h (maxpktsize %0d) en=0x%02h (router %s, counter enables %07b)",
                   ctrl, max, en, on_off, en[7:1]);
endtask : configure_router

//------------------------------------------------------------------------------
task router_random_mcseq::random_reads(int n);
  bit [15:0] addr;
  bit [7:0]  data;
  bit [15:0] regs[$] = '{16'h1000, 16'h1001, 16'h1004, 16'h1005, 16'h1006, 16'h1009, 16'h100a, 16'h100b,
                         16'h100d};
  bit [15:0] unmapped[$] = '{16'h1002, 16'h1003, 16'h1007, 16'h1008, 16'h100c, 16'h100e, 16'h100f};
  for (int i = 0; i < n; i++) begin
    case (rnd::get_int(0, 4, "router_random_mcseq.read_kind"))
      0, 1: begin
        addr = regs[rnd::get_index(regs.size(), "router_random_mcseq.reg")];
      end
      2: begin
        addr = 16'h1010 + 16'(rnd::get_int(0, 63, "router_random_mcseq.pkt_mem"));
      end
      3: begin
        if (rnd::get_bit("router_random_mcseq.unmapped_range")) begin
          addr = unmapped[rnd::get_index(unmapped.size(), "router_random_mcseq.unmapped")];
        end else begin
          addr = 16'h1050 + 16'(rnd::get_int(0, 16'h00af, "router_random_mcseq.unmapped_hole"));
        end
      end
      default: begin
        // scratch memory: write a byte, read it back
        addr = 16'h1100 + 16'(rnd::get_int(0, 255, "router_random_mcseq.yapp_mem"));
        hbus_write(addr, rnd::get_byte("router_random_mcseq.yapp_mem_data"));
      end
    endcase
    hbus_read(addr, data);
  end
endtask : random_reads

//------------------------------------------------------------------------------
task router_random_mcseq::final_reads();
  bit [7:0]  data;
  bit [7:0]  mem_size;
  bit [15:0] regs[$] = '{16'h1000, 16'h1001, 16'h1004, 16'h1005, 16'h1006, 16'h1009, 16'h100a, 16'h100b};
  foreach (regs[i]) begin
    hbus_read(regs[i], data);
  end
  hbus_read(16'h100d, mem_size);
  for (int i = 0; i <= int'(mem_size[5:0]); i++) begin
    hbus_read(16'h1010 + 16'(i), data);
  end
endtask : final_reads

//------------------------------------------------------------------------------
task router_random_mcseq::hbus_write(bit [15:0] addr, bit [7:0] data);
  hbus_write_seq wr;
  wr = hbus_write_seq::type_id::create("wr");
  if (!wr.randomize() with { addr == local::addr; data == local::data; }) begin
    `uvm_error(get_type_name(), "hbus_write_seq.randomize() failed")
  end
  wr.start(p_sequencer.hbus_seqr, this);
endtask : hbus_write

//------------------------------------------------------------------------------
task router_random_mcseq::hbus_read(bit [15:0] addr, output bit [7:0] data);
  hbus_read_seq rd;
  rd = hbus_read_seq::type_id::create("rd");
  if (!rd.randomize() with { addr == local::addr; }) begin
    `uvm_error(get_type_name(), "hbus_read_seq.randomize() failed")
  end
  rd.start(p_sequencer.hbus_seqr, this);
  data = rd.data;
  num_reads++;
endtask : hbus_read

//------------------------------------------------------------------------------
function void router_random_mcseq::stage(string what);
  `uvm_info("TEST", {"STAGE: ", what}, UVM_LOW)
endfunction : stage
