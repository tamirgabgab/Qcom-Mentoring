//------------------------------------------------------------------------------
// router_reference.sv -- reference model of the router (Lab 9B, grown into a
// full model of the registers for the random tests)
//
//   HBUS monitor ──port──► hbus_in (imp) : writes update the register mirror
//                                          and the scratch memory; reads are
//                                          checked against the model
//                                          (`check_reads`, off by default)
//   YAPP monitor ──port──► yapp_in (imp) : forward the packet on
//                                          yapp_valid_out only if the router
//                                          will route it; update the counters,
//                                          mem_size_reg and yapp_pkt_mem;
//                                          publish the decision on
//                                          decision_out (router_coverage)
//
// The model follows docs/dut/spec.md ("Behaviour rules" and "Decisions"):
//   * only packets received while router_en = 1 count, set mem_size_reg and
//     are stored in yapp_pkt_mem (dropped ones too); router_en = 0 is "deaf"
//   * each counter uses its enable bit in en_reg at the end of the packet and
//     wraps at 255
//   * yapp_pkt_mem[0] = header {length, addr}, [1..length] = payload; a shorter
//     packet leaves the old tail; the memories are not reset, so a byte is
//     only checked after it has been written
//   * unmapped addresses read 0; writes to read-only locations are ignored
// The decision is taken when the monitor publishes the packet (after its
// parity byte); the DUT takes it at the header. They agree as long as the
// configuration does not change in the middle of a packet, which the spec
// leaves undefined and the tests never do.
// A backdoor poke() is not seen here, so tests that poke keep check_reads off.
//
// `_yapp` was declared by router_scoreboard.sv (same package); only `_hbus`
// is new here.
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_hbus)

class router_reference extends uvm_component;

  // Inputs
  uvm_analysis_imp_yapp #(yapp_packet,      router_reference) m_yapp_in;
  uvm_analysis_imp_hbus #(hbus_transaction, router_reference) m_hbus_in;
  // Output: packets the router is expected to deliver
  uvm_analysis_port #(yapp_packet) m_yapp_valid_out;
  // Output: every packet received while enabled, with the decision and the
  // configuration it met (router_coverage subscribes)
  uvm_analysis_port #(router_decision) m_decision_out;

  // Register mirror (reset values of the DUT)
  bit[7:0] m_ctrl_reg = 8'h3f;
  bit[7:0] m_en_reg   = 8'h01;
  bit[5:0] m_maxpktsize = 6'h3f;             // = ctrl_reg[5:0]
  bit       m_router_en  = 1'b1;              // = en_reg[0]
  bit[7:0] m_parity_err_cnt;
  bit[7:0] m_oversized_cnt;
  bit[7:0] m_addr_cnt[4];                    // addr0..addr3 counters
  bit[7:0] m_mem_size;
  bit[7:0] m_pkt_mem[64];
  bit       m_pkt_mem_known[64];              // written since time 0
  bit[7:0] m_scratch_mem[256];               // yapp_mem
  bit       m_scratch_known[256];

  // Knob (uvm_config_db #(bit) "check_reads"): compare every HBUS read with the model
  bit m_check_reads;

  // Statistics
  int m_packets_forwarded;
  int m_dropped_disabled;
  int m_dropped_size;
  int m_dropped_addr;
  int m_reads_checked;
  int m_reads_unknown;                        // memory bytes never written: not checked
  int m_read_mismatches;

  `uvm_component_utils(router_reference)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Keep the model up to date from the bus traffic; check the reads
  extern function void write_hbus(hbus_transaction tr);

  // Same decision the RTL makes when the header arrives, then the statistics
  extern function void write_yapp(yapp_packet pkt);

  // What a read of `addr` must return; known = 0 for a memory byte never written
  extern function bit[7:0] expected_read(bit[15:0] addr, output bit known);

  extern function void report_phase(uvm_phase phase);

endclass : router_reference

//------------------------------------------------------------------------------
// router_reference -- method implementations
//------------------------------------------------------------------------------

function router_reference::new(string name, uvm_component parent);
  super.new(name, parent);
  m_yapp_in        = new("yapp_in", this);
  m_hbus_in        = new("hbus_in", this);
  m_yapp_valid_out = new("yapp_valid_out", this);
  m_decision_out   = new("decision_out", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_reference::build_phase(uvm_phase phase);
  super.build_phase(phase);
  void'(uvm_config_db #(bit)::get(this, "", "check_reads", m_check_reads));
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_reference::write_hbus(hbus_transaction tr);
  bit[7:0] exp;
  bit       known;
  if (tr.m_hwr_rd == HBUS_OP_READ) begin
    if (!m_check_reads) begin
      return;
    end
    exp = expected_read(tr.m_haddr, known);
    if (!known) begin
      m_reads_unknown++;
    end else begin
      m_reads_checked++;
      if (tr.m_hdata !== exp) begin
        m_read_mismatches++;
        `uvm_error("REF_READ", $sformatf("HBUS read 0x%04h returned 0x%02h, the model expects 0x%02h",
                                         tr.m_haddr, tr.m_hdata, exp))
      end else begin
        `uvm_info(get_type_name(), $sformatf("HBUS read 0x%04h = 0x%02h as expected", tr.m_haddr, tr.m_hdata), UVM_HIGH)
      end
    end
    return;
  end
  if (tr.m_haddr >= 16'h1100 && tr.m_haddr <= 16'h11ff) begin
    m_scratch_mem[tr.m_haddr[7:0]]   = tr.m_hdata;
    m_scratch_known[tr.m_haddr[7:0]] = 1'b1;
    return;
  end
  case (tr.m_haddr)
    16'h1000: begin
      m_ctrl_reg   = tr.m_hdata;
      m_maxpktsize = tr.m_hdata[5:0];
      `uvm_info(get_type_name(), $sformatf("maxpktsize is now %0d", m_maxpktsize), UVM_LOW)
    end
    16'h1001: begin
      m_en_reg    = tr.m_hdata;
      m_router_en = tr.m_hdata[0];
      `uvm_info(get_type_name(), $sformatf("router_en is now %0d (en_reg 0x%02h)", m_router_en, m_en_reg), UVM_LOW)
    end
    default: ;   // read-only or unmapped: the write is ignored
  endcase
endfunction : write_hbus

//------------------------------------------------------------------------------
function void router_reference::write_yapp(yapp_packet pkt);
  bit             bad;
  router_reason_e reason;
  router_decision decision;
  bad = (pkt.m_parity_type == PARITY_TYPE_BAD);
  if (!m_router_en) begin
    m_dropped_disabled++;
    `uvm_info(get_type_name(),
              $sformatf("Packet dropped: router disabled (addr=%0d len=%0d)", pkt.m_addr, pkt.m_length), UVM_LOW)
    return;                                 // deaf: no count, no memory, no pulse
  end
  if (pkt.m_addr == 2'd3) begin
    reason = ROUTER_REASON_ADDR3;
    m_dropped_addr++;
    `uvm_info(get_type_name(), $sformatf("Packet dropped: illegal address 3 (len=%0d)", pkt.m_length), UVM_LOW)
  end else if (pkt.m_length > m_maxpktsize) begin
    reason = ROUTER_REASON_OVERSIZED;
    m_dropped_size++;
    `uvm_info(get_type_name(),
              $sformatf("Packet dropped: length %0d > maxpktsize %0d (addr=%0d)", pkt.m_length, m_maxpktsize, pkt.m_addr),
              UVM_LOW)
  end else begin
    reason = ROUTER_REASON_FORWARDED;
    m_packets_forwarded++;
    `uvm_info(get_type_name(),
              $sformatf("Packet forwarded: addr=%0d len=%0d -> channel %0d", pkt.m_addr, pkt.m_length, pkt.m_addr),
              UVM_MEDIUM)
    m_yapp_valid_out.write(pkt);
  end

  // Statistics of a packet received while enabled (forwarded or dropped)
  if (bad && m_en_reg[1]) begin
    m_parity_err_cnt++;
  end
  if (pkt.m_length > m_maxpktsize && m_en_reg[2]) begin
    m_oversized_cnt++;
  end
  if (m_en_reg[4 + pkt.m_addr]) begin
    m_addr_cnt[pkt.m_addr]++;
  end
  m_mem_size = {2'b00, pkt.m_length};
  m_pkt_mem[0]       = {pkt.m_length, pkt.m_addr};
  m_pkt_mem_known[0] = 1'b1;
  for (int i = 0; i < pkt.m_length; i++) begin
    m_pkt_mem[i + 1]       = pkt.m_payload[i];
    m_pkt_mem_known[i + 1] = 1'b1;
  end

  decision            = router_decision::type_id::create("decision");
  decision.m_pkt        = pkt;
  decision.m_maxpktsize = m_maxpktsize;
  decision.m_en_reg     = m_en_reg;
  decision.m_reason     = reason;
  m_decision_out.write(decision);
endfunction : write_yapp

//------------------------------------------------------------------------------
function bit[7:0] router_reference::expected_read(bit[15:0] addr, output bit known);
  known = 1'b1;
  if (addr >= 16'h1100 && addr <= 16'h11ff) begin
    known = m_scratch_known[addr[7:0]];
    return m_scratch_mem[addr[7:0]];
  end
  if (addr >= 16'h1010 && addr <= 16'h104f) begin
    known = m_pkt_mem_known[addr - 16'h1010];
    return m_pkt_mem[addr - 16'h1010];
  end
  case (addr)
    16'h1000: return m_ctrl_reg;
    16'h1001: return m_en_reg;
    16'h1004: return m_parity_err_cnt;
    16'h1005: return m_oversized_cnt;
    16'h1006: return m_addr_cnt[3];
    16'h1009: return m_addr_cnt[0];
    16'h100a: return m_addr_cnt[1];
    16'h100b: return m_addr_cnt[2];
    16'h100d: return m_mem_size;
    default:  return 8'h00;                 // not mapped
  endcase
endfunction : expected_read

//------------------------------------------------------------------------------
function void router_reference::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf({"\n--- Reference model report ---\n",
    "  forwarded to scoreboard   : %0d\n",
    "  dropped (router disabled) : %0d\n",
    "  dropped (oversized)       : %0d\n",
    "  dropped (address 3)       : %0d\n",
    "  counters parity/oversized/addr0..3 : %0d / %0d / %0d %0d %0d %0d"},
    m_packets_forwarded, m_dropped_disabled, m_dropped_size, m_dropped_addr,
    m_parity_err_cnt, m_oversized_cnt, m_addr_cnt[0], m_addr_cnt[1], m_addr_cnt[2], m_addr_cnt[3]), UVM_LOW)
  if (m_check_reads) begin
    `uvm_info(get_type_name(), $sformatf("HBUS reads checked against the model: %0d (%0d mismatches, %0d of memory bytes never written)",
                                         m_reads_checked, m_read_mismatches, m_reads_unknown), UVM_LOW)
  end
endfunction : report_phase
