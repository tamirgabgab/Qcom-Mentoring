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

  yapp_pkt_seq m_pkt_seq;

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
  bit[7:0]      header;

  // 1. a packet with a known address and length
  stage("1. one packet (addr 1, 20 bytes): mem_size_reg and yapp_pkt_mem hold it byte by byte");
  m_pkt_seq = yapp_pkt_seq::type_id::create("pkt_seq");
  if (!m_pkt_seq.randomize() with { m_pkt_addr == 2'd1; m_pkt_len == 6'd20; }) begin
    `uvm_error("PKT_MEM", "pkt_seq.randomize() failed")
  end
  m_pkt_seq.start(m_yapp_seqr);
  check_stored_packet(m_pkt_seq.req);

  // 2. the packet memory is read-only: a bus write must not change it
  stage("2. a raw HBUS write to yapp_pkt_mem[0] is ignored (read-only memory)");
  header = {m_pkt_seq.req.m_length, m_pkt_seq.req.m_addr};
  wr = hbus_write_seq::type_id::create("wr");
  if (!wr.randomize() with { m_addr == 16'h1010; m_data == ~header; }) begin
    `uvm_error("PKT_MEM", "wr.randomize() failed")
  end
  wr.start(m_tb.m_hbus.m_masters[0].m_sequencer);
  m_regs.yapp_pkt_mem.read(status, 0, val);
  if (val != header) begin
    `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[0] changed to 0x%02h after a write (read-only memory)", val))
  end else begin
    `uvm_info("PKT_MEM", "write to yapp_pkt_mem ignored, as it should be", UVM_NONE)
  end

  // 3. a dropped (oversized) packet is still stored
  stage("3. ctrl_reg=5, then a 9-byte packet: dropped as oversized but still stored");
  m_regs.ctrl_reg.write(status, 8'h05);       // maxpktsize = 5
  if (!m_pkt_seq.randomize() with { m_pkt_addr == 2'd2; m_pkt_len == 6'd9; }) begin
    `uvm_error("PKT_MEM", "pkt_seq.randomize() failed")
  end
  m_pkt_seq.start(m_yapp_seqr);
  check_stored_packet(m_pkt_seq.req);
  m_regs.ctrl_reg.write(status, 8'h3f);       // back to the reset value
endtask : access_checks

//------------------------------------------------------------------------------
task pkt_mem_test::check_stored_packet(yapp_packet pkt);
  uvm_status_e   status;
  uvm_reg_data_t val;
  bit[7:0]      header;
  int            errors;
  header = {pkt.m_length, pkt.m_addr};
  m_regs.mem_size_reg.read(status, val);
  if (val != pkt.m_length) begin
    `uvm_error("PKT_MEM", $sformatf("mem_size_reg reads %0d, expected %0d", val, pkt.m_length))
  end
  m_regs.yapp_pkt_mem.read(status, 0, val);
  if (val != header) begin
    `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[0] reads 0x%02h, expected header 0x%02h", val, header))
  end
  foreach (pkt.m_payload[i]) begin
    m_regs.yapp_pkt_mem.read(status, i + 1, val);
    if (val != pkt.m_payload[i]) begin
      errors++;
      `uvm_error("PKT_MEM", $sformatf("yapp_pkt_mem[%0d] reads 0x%02h, expected payload[%0d] 0x%02h",
                                      i + 1, val, i, pkt.m_payload[i]))
    end
  end
  if (errors == 0) begin
    `uvm_info("PKT_MEM", $sformatf("packet (addr %0d, length %0d) stored byte by byte", pkt.m_addr, pkt.m_length), UVM_NONE)
  end
endtask : check_stored_packet
