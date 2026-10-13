//------------------------------------------------------------------------------
// router_hbus_sweep_mcseq.sv -- router_hbus_sweep_mcseq (multichannel sequence library)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_hbus_sweep_mcseq: the HBUS test of the test plan's coverage items
// COV-04..07, on the HBUS and YAPP sequencers of router_mcsequencer. Every
// read is checked by router_reference (check_reads = 1): a write to a
// read-only or unmapped address must change nothing.
//   1. one packet, so yapp_pkt_mem holds known bytes
//   2. every address 0x1000..0x100f (registers and holes): write 0x00, 0xff,
//      0x55, 0xaa, and after each write read the whole window back, so a write
//      that lands on another register is caught; ctrl_reg / en_reg restored
//   3. ctrl_reg and en_reg: walking one and walking zero
//   4. yapp_pkt_mem (read-only): write every byte, read it back and the
//      register window
//   5. the unmapped range 0x1050..0x10ff: its edges and a few addresses in
//      between, written, read back with the register window
//   6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa
//      and a random value
//   7. the counters at 0, in between and at 255: maxpktsize = 1 and 2-byte
//      packets with bad parity (oversized, dropped: nothing reaches a channel);
//      en_reg = 0x17 and 255 packets to address 0 (parity, oversized, addr0),
//      then 0x21 / 0x41 / 0x81 and 255 packets to address 1 / 2 / 3; the six
//      counters are read before, after 100 packets and after 255
//   8. ctrl_reg / en_reg back to their reset values
// Each step is announced with a [TEST] STAGE line.
//------------------------------------------------------------------------------
class router_hbus_sweep_mcseq extends router_mcseq_base;

  int pkts_sent;

  `uvm_object_utils(router_hbus_sweep_mcseq)

  extern function new(string name = "router_hbus_sweep_mcseq");
  extern task body();

  // Write `data` to `addr`, then read it back (the reference checks the read)
  extern task write_read(bit [15:0] addr, bit [7:0] data);

  // `n` packets to `addr`: 2 bytes, bad parity
  extern task send(bit [1:0] addr, int n);

  // Read the six counters
  extern task read_counters();

  // Read every address 0x1000..0x100f, registers and holes
  extern task read_window();

endclass : router_hbus_sweep_mcseq

//------------------------------------------------------------------------------
// router_hbus_sweep_mcseq -- method implementations
//------------------------------------------------------------------------------

function router_hbus_sweep_mcseq::new(string name = "router_hbus_sweep_mcseq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task router_hbus_sweep_mcseq::body();
  bit [7:0]  patterns[4] = '{8'h00, 8'hff, 8'h55, 8'haa};
  bit [15:0] addr;
  bit [7:0]  en_masks[4] = '{8'h17, 8'h21, 8'h41, 8'h81};
  yapp_pkt_seq pkt;

  stage("1. one 20-byte packet to address 0, so yapp_pkt_mem holds known bytes");
  pkt = yapp_pkt_seq::type_id::create("pkt");
  if (!pkt.randomize() with { pkt_addr == 0; pkt_len == 20; pkt_parity == GOOD_PARITY; }) begin
    `uvm_error(get_type_name(), "yapp_pkt_seq.randomize() failed")
  end
  pkt.start(p_sequencer.yapp_seqr, this);
  pkts_sent++;

  stage("2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back");
  for (int a = 16'h1000; a <= 16'h100f; a++) begin
    foreach (patterns[i]) begin
      hbus_write(16'(a), patterns[i]);
      read_window();
    end
  end
  hbus_write(16'h1000, 8'h3f);
  hbus_write(16'h1001, 8'h01);

  stage("3. ctrl_reg and en_reg: walking one and walking zero");
  for (int r = 16'h1000; r <= 16'h1001; r++) begin
    for (int b = 0; b < 8; b++) begin
      write_read(16'(r), 8'(1 << b));
      write_read(16'(r), ~8'(1 << b));
    end
  end
  hbus_write(16'h1000, 8'h3f);
  hbus_write(16'h1001, 8'h01);

  stage("4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet");
  for (int a = 16'h1010; a <= 16'h104f; a++) begin
    write_read(16'(a), rnd::get_byte("router_hbus_sweep_mcseq.pkt_mem_data"));
    read_window();
  end

  stage("5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0");
  write_read(16'h1050, 8'hff);
  read_window();
  write_read(16'h10ff, 8'hff);
  read_window();
  for (int i = 0; i < 6; i++) begin
    addr = 16'h1051 + 16'(rnd::get_int(0, 16'h00ad, "router_hbus_sweep_mcseq.gap_addr"));
    write_read(addr, rnd::get_byte("router_hbus_sweep_mcseq.gap_data"));
    read_window();
  end

  stage("6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value");
  foreach (patterns[i]) begin
    for (int a = 16'h1100; a <= 16'h11ff; a++) begin
      write_read(16'(a), patterns[i]);
    end
  end
  for (int a = 16'h1100; a <= 16'h11ff; a++) begin
    write_read(16'(a), rnd::get_byte("router_hbus_sweep_mcseq.yapp_mem_data"));
  end

  stage("7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity");
  hbus_write(16'h1000, 8'h01);
  read_counters();
  foreach (en_masks[i]) begin
    stage($sformatf("7.%0d en_reg = 0x%02h: 255 packets to address %0d, counters read after 100 and after 255",
                    i + 1, en_masks[i], i));
    hbus_write(16'h1001, en_masks[i]);
    send(2'(i), 100);
    read_counters();
    send(2'(i), 155);
    read_counters();
  end

  stage("8. ctrl_reg and en_reg back to their reset values, every register read");
  hbus_write(16'h1000, 8'h3f);
  hbus_write(16'h1001, 8'h01);
  for (int a = 16'h1000; a <= 16'h100d; a++) begin
    hbus_read(16'(a), patterns[0]);
  end
  stage($sformatf("sweep done: %0d packets, %0d HBUS reads", pkts_sent, num_reads));
endtask : body

//------------------------------------------------------------------------------
task router_hbus_sweep_mcseq::write_read(bit [15:0] addr, bit [7:0] data);
  bit [7:0] rd;
  hbus_write(addr, data);
  hbus_read(addr, rd);
endtask : write_read

//------------------------------------------------------------------------------
task router_hbus_sweep_mcseq::send(bit [1:0] addr, int n);
  yapp_pkt_seq pkt;
  for (int i = 0; i < n; i++) begin
    pkt = yapp_pkt_seq::type_id::create("pkt");
    if (!pkt.randomize() with { pkt_addr == addr; pkt_len == 2; pkt_parity == BAD_PARITY; }) begin
      `uvm_error(get_type_name(), "yapp_pkt_seq.randomize() failed")
    end
    pkt.start(p_sequencer.yapp_seqr, this);
    pkts_sent++;
  end
endtask : send

//------------------------------------------------------------------------------
task router_hbus_sweep_mcseq::read_counters();
  bit [7:0]  data;
  bit [15:0] counters[6] = '{16'h1004, 16'h1005, 16'h1006, 16'h1009, 16'h100a, 16'h100b};
  foreach (counters[i]) begin
    hbus_read(counters[i], data);
  end
endtask : read_counters

//------------------------------------------------------------------------------
task router_hbus_sweep_mcseq::read_window();
  bit [7:0] data;
  for (int a = 16'h1000; a <= 16'h100f; a++) begin
    hbus_read(16'(a), data);
  end
endtask : read_window
