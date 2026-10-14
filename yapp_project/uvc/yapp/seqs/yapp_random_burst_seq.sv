//------------------------------------------------------------------------------
// yapp_random_burst_seq.sv -- YAPP sequence library (random tests)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_random_burst_seq: `count` packets whose address, length, parity and gap
// are drawn per packet from weights the caller sets (the knobs below), so one
// burst can mix legal and illegal addresses, lengths around the maxpktsize in
// force, bad parity and back-to-back packets.
//
// Length of each packet, in this order of the percent knobs:
//   short_pct     1..3 bytes (the shortest packets: bad-parity storms)
//   long_pct      40..63 bytes (longer than a channel FIFO: back-pressure)
//   boundary_pct  one of 1, maxpktsize-1, maxpktsize, maxpktsize+1, 63
//                 (clipped to 1..63)
//   otherwise     1..63
// Gap before each packet (idle cycles): gap0_pct back to back, gap_short_pct
// 1..3, otherwise 4..20.
//
// Every choice comes from rnd:: and is pinned with `==` in randomize() with
// the packet's own address / parity / delay constraints switched off (dist and
// == on the same field do not mix in Verilator); the payload stays random.
//------------------------------------------------------------------------------
class yapp_random_burst_seq extends yapp_base_seq;

  rand int unsigned count;

  constraint c_count { count inside {[1:100]}; }

  // Knobs (percent unless said otherwise)
  bit [5:0] maxpktsize   = 6'd63;           // the value in force, for the boundary lengths
  int       addr3_pct    = 5;               // packets to the illegal address 3
  int       bad_pct      = 15;              // packets with bad parity
  int       short_pct    = 0;
  int       long_pct     = 0;
  int       boundary_pct = 40;
  int       gap0_pct     = 25;
  int       gap_short_pct = 35;

  // What was sent, for the [TEST] stage lines
  int sent_per_addr[4];
  int sent_bad;
  int sent_gap0;
  int sent_len_min;
  int sent_len_max;

  `uvm_object_utils(yapp_random_burst_seq)

  extern function new(string name = "yapp_random_burst_seq");
  extern task body();

  // One draw of each field, from the knobs
  extern function bit [1:0] pick_addr();
  extern function bit [5:0] pick_length();
  extern function int       pick_gap();

  // "addr0..3 a/b/c/d, bad n, gap0 n, len lo..hi"
  extern function string summary();

endclass : yapp_random_burst_seq

//------------------------------------------------------------------------------
// yapp_random_burst_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_random_burst_seq::new(string name = "yapp_random_burst_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_random_burst_seq::body();
  bit [1:0]     a;
  bit [5:0]     len;
  parity_type_e par;
  int           gap;
  `uvm_info(get_type_name(), $sformatf("Executing yapp_random_burst_seq (%0d packets, maxpktsize %0d)",
                                       count, maxpktsize), UVM_LOW)
  foreach (sent_per_addr[i]) begin
    sent_per_addr[i] = 0;
  end
  sent_bad     = 0;
  sent_gap0    = 0;
  sent_len_min = 64;
  sent_len_max = 0;
  for (int i = 0; i < count; i++) begin
    a   = pick_addr();
    len = pick_length();
    par = (rnd::get_int(0, 99, "yapp_random_burst_seq.parity") < bad_pct) ? PARITY_TYPE_BAD : PARITY_TYPE_GOOD;
    gap = pick_gap();
    req = yapp_packet::type_id::create("req");
    req.c_addr_legal.constraint_mode(0);    // the sequence chooses the address (3 included)
    req.c_parity_dist.constraint_mode(0);   // ... the parity
    req.c_delay.constraint_mode(0);         // ... and the gap (0 included)
    start_item(req);
    if (!req.randomize() with { req.addr         == a;
                                req.length       == len;
                                req.parity_type  == par;
                                req.packet_delay == gap; }) begin
      `uvm_error(get_type_name(), "req.randomize() failed")
    end
    finish_item(req);
    sent_per_addr[a]++;
    if (par == PARITY_TYPE_BAD) begin
      sent_bad++;
    end
    if (gap == 0) begin
      sent_gap0++;
    end
    if (len < sent_len_min) begin
      sent_len_min = len;
    end
    if (len > sent_len_max) begin
      sent_len_max = len;
    end
  end
endtask : body

//------------------------------------------------------------------------------
function bit [1:0] yapp_random_burst_seq::pick_addr();
  if (rnd::get_int(0, 99, "yapp_random_burst_seq.addr3") < addr3_pct) begin
    return 2'd3;
  end
  return 2'(rnd::get_int(0, 2, "yapp_random_burst_seq.addr"));
endfunction : pick_addr

//------------------------------------------------------------------------------
function bit [5:0] yapp_random_burst_seq::pick_length();
  int r;
  int len;
  r = rnd::get_int(0, 99, "yapp_random_burst_seq.length_class");
  if (r < short_pct) begin
    len = rnd::get_int(1, 3, "yapp_random_burst_seq.short_length");
  end else if (r < short_pct + long_pct) begin
    len = rnd::get_int(40, 63, "yapp_random_burst_seq.long_length");
  end else if (r < short_pct + long_pct + boundary_pct) begin
    case (rnd::get_int(0, 4, "yapp_random_burst_seq.boundary"))
      0:       len = 1;
      1:       len = int'(maxpktsize) - 1;
      2:       len = int'(maxpktsize);
      3:       len = int'(maxpktsize) + 1;
      default: len = 63;
    endcase
  end else begin
    len = rnd::get_int(1, 63, "yapp_random_burst_seq.length");
  end
  if (len < 1) begin
    len = 1;
  end
  if (len > 63) begin
    len = 63;
  end
  return 6'(len);
endfunction : pick_length

//------------------------------------------------------------------------------
function int yapp_random_burst_seq::pick_gap();
  int r;
  r = rnd::get_int(0, 99, "yapp_random_burst_seq.gap_class");
  if (r < gap0_pct) begin
    return 0;
  end
  if (r < gap0_pct + gap_short_pct) begin
    return rnd::get_int(1, 3, "yapp_random_burst_seq.short_gap");
  end
  return rnd::get_int(4, 20, "yapp_random_burst_seq.gap");
endfunction : pick_gap

//------------------------------------------------------------------------------
function string yapp_random_burst_seq::summary();
  return $sformatf("addr0..3 %0d/%0d/%0d/%0d, bad parity %0d, gap 0 %0d, length %0d..%0d",
                   sent_per_addr[0], sent_per_addr[1], sent_per_addr[2], sent_per_addr[3],
                   sent_bad, sent_gap0, sent_len_min, sent_len_max);
endfunction : summary
