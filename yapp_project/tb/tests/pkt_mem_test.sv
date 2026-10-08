//------------------------------------------------------------------------------
// pkt_mem_test.sv -- pkt_mem_test (test plan: MEM-01, MEM-03, REG-06)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// pkt_mem_test: the packet memory and mem_size_reg hold the last packet.
//   1. one packet (addr 1, 20 bytes): mem_size_reg == 20, yapp_pkt_mem[0] is
//      the header, yapp_pkt_mem[1..20] the payload, byte by byte
//   2. a raw HBUS write to 0x1010 is ignored (the memory is read-only)
//   3. maxpktsize = 5, then a 9-byte packet: dropped, but still stored
//      (the packet was received -- see the "Decisions" in dut/spec.md)
//------------------------------------------------------------------------------
class pkt_mem_test extends reg_function_test;

  yapp_pkt_seq pkt_seq;

  `uvm_component_utils(pkt_mem_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

  // Compare mem_size_reg and yapp_pkt_mem with the packet the sequence sent
  extern task check_stored_packet(yapp_packet pkt);

endclass : pkt_mem_test

//------------------------------------------------------------------------------
// pkt_mem_test -- method implementations
//------------------------------------------------------------------------------

function pkt_mem_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task pkt_mem_test::access_checks();
  uvm_status_e   status;
  uvm_reg_data_t val;
  hbus_write_seq wr;
  bit [7:0]      header;

  // 1. a packet with a known address and length
  pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  if (!pkt_seq.randomize() with { pkt_addr == 2'd1; pkt_len == 6'd20; }) begin
    `uvm_error("PKT_MEM", "pkt_seq.randomize() failed")
  end
  pkt_seq.start(yapp_seqr);
  check_stored_packet(pkt_seq.req);

  // 2. the packet memory is read-only: a bus write must not change it
  header = {pkt_seq.req.length, pkt_seq.req.addr};
  wr = hbus_write_seq::type_id::create("wr");
  if (!wr.randomize() with { addr == 16'h1010; data == ~header; }) begin
    `uvm_error("PKT_MEM", "wr.randomize() failed")
  end
  wr.start(tb.hbus.masters[0].sequencer);
  regs.yapp_pkt_mem.read(status, 0, val);
  if (val != header) begin
    `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[0] changed to 0x%02h after a write (read-only memory)", val))
  end else begin
    `uvm_info("PKT_MEM", "write to yapp_pkt_mem ignored, as it should be", UVM_NONE)
  end

  // 3. a dropped (oversized) packet is still stored
  regs.ctrl_reg.write(status, 8'h05);       // maxpktsize = 5
  if (!pkt_seq.randomize() with { pkt_addr == 2'd2; pkt_len == 6'd9; }) begin
    `uvm_error("PKT_MEM", "pkt_seq.randomize() failed")
  end
  pkt_seq.start(yapp_seqr);
  check_stored_packet(pkt_seq.req);
  regs.ctrl_reg.write(status, 8'h3f);       // back to the reset value
endtask : access_checks

//------------------------------------------------------------------------------
task pkt_mem_test::check_stored_packet(yapp_packet pkt);
  uvm_status_e   status;
  uvm_reg_data_t val;
  bit [7:0]      header;
  int            errors;
  header = {pkt.length, pkt.addr};
  regs.mem_size_reg.read(status, val);
  if (val != pkt.length) begin
    `uvm_error("PKT_MEM", $sformatf("mem_size_reg reads %0d, expected %0d", val, pkt.length))
  end
  regs.yapp_pkt_mem.read(status, 0, val);
  if (val != header) begin
    `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[0] reads 0x%02h, expected header 0x%02h", val, header))
  end
  foreach (pkt.payload[i]) begin
    regs.yapp_pkt_mem.read(status, i + 1, val);
    if (val != pkt.payload[i]) begin
      errors++;
      `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[%0d] reads 0x%02h, expected payload[%0d] 0x%02h",
                                      i + 1, val, i, pkt.payload[i]))
    end
  end
  if (errors == 0) begin
    `uvm_info("PKT_MEM", $sformatf("packet (addr %0d, length %0d) stored byte by byte", pkt.addr, pkt.length), UVM_NONE)
  end
endtask : check_stored_packet
