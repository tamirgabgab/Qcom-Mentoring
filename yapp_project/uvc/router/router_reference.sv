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
  uvm_analysis_imp_yapp #(yapp_packet,      router_reference) yapp_in;
  uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
  // Output: packets the router is expected to deliver
  uvm_analysis_port #(yapp_packet) yapp_valid_out;
  // Output: every packet received while enabled, with the decision and the
  // configuration it met (router_coverage subscribes)
  uvm_analysis_port #(router_decision) decision_out;

  // Register mirror (reset values of the DUT)
  bit[7:0] ctrl_reg = 8'h3f;
  bit[7:0] en_reg   = 8'h01;
  bit[5:0] maxpktsize = 6'h3f;             // = ctrl_reg[5:0]
  bit       router_en  = 1'b1;              // = en_reg[0]
  bit[7:0] parity_err_cnt;
  bit[7:0] oversized_cnt;
  bit[7:0] addr_cnt[4];                    // addr0..addr3 counters
  bit[7:0] mem_size;
  bit[7:0] pkt_mem[64];
  bit       pkt_mem_known[64];              // written since time 0
  bit[7:0] scratch_mem[256];               // yapp_mem
  bit       scratch_known[256];

  // Knob (uvm_config_db #(bit) "check_reads"): compare every HBUS read with the model
  bit check_reads;

  // Statistics
  int packets_forwarded;
  int dropped_disabled;
  int dropped_size;
  int dropped_addr;
  int reads_checked;
  int reads_unknown;                        // memory bytes never written: not checked
  int read_mismatches;

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
  yapp_in        = new("yapp_in", this);
  hbus_in        = new("hbus_in", this);
  yapp_valid_out = new("yapp_valid_out", this);
  decision_out   = new("decision_out", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_reference::build_phase(uvm_phase phase);
  super.build_phase(phase);
  void'(uvm_config_db #(bit)::get(this, "", "check_reads", check_reads));
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_reference::write_hbus(hbus_transaction tr);
  bit[7:0] exp;
  bit       known;
  if (tr.hwr_rd == HBUS_OP_READ) begin
    if (!check_reads) begin
      return;
    end
    exp = expected_read(tr.haddr, known);
    if (!known) begin
      reads_unknown++;
    end else begin
      reads_checked++;
      if (tr.hdata !== exp) begin
        read_mismatches++;
        `uvm_error("REF_READ", $sformatf("HBUS read 0x%04h returned 0x%02h, the model expects 0x%02h",
                                         tr.haddr, tr.hdata, exp))
      end else begin
        `uvm_info(get_type_name(), $sformatf("HBUS read 0x%04h = 0x%02h as expected", tr.haddr, tr.hdata), UVM_HIGH)
      end
    end
    return;
  end
  if (tr.haddr >= 16'h1100 && tr.haddr <= 16'h11ff) begin
    scratch_mem[tr.haddr[7:0]]   = tr.hdata;
    scratch_known[tr.haddr[7:0]] = 1'b1;
    return;
  end
  case (tr.haddr)
    16'h1000: begin
      ctrl_reg   = tr.hdata;
      maxpktsize = tr.hdata[5:0];
      `uvm_info(get_type_name(), $sformatf("maxpktsize is now %0d", maxpktsize), UVM_LOW)
    end
    16'h1001: begin
      en_reg    = tr.hdata;
      router_en = tr.hdata[0];
      `uvm_info(get_type_name(), $sformatf("router_en is now %0d (en_reg 0x%02h)", router_en, en_reg), UVM_LOW)
    end
    default: ;   // read-only or unmapped: the write is ignored
  endcase
endfunction : write_hbus

//------------------------------------------------------------------------------
function void router_reference::write_yapp(yapp_packet pkt);
  bit             bad;
  router_reason_e reason;
  router_decision decision;
  bad = (pkt.parity_type == PARITY_TYPE_BAD);
  if (!router_en) begin
    dropped_disabled++;
    `uvm_info(get_type_name(),
              $sformatf("Packet dropped: router disabled (addr=%0d len=%0d)", pkt.addr, pkt.length), UVM_LOW)
    return;                                 // deaf: no count, no memory, no pulse
  end
  if (pkt.addr == 2'd3) begin
    reason = ROUTER_REASON_ADDR3;
    dropped_addr++;
    `uvm_info(get_type_name(), $sformatf("Packet dropped: illegal address 3 (len=%0d)", pkt.length), UVM_LOW)
  end else if (pkt.length > maxpktsize) begin
    reason = ROUTER_REASON_OVERSIZED;
    dropped_size++;
    `uvm_info(get_type_name(),
              $sformatf("Packet dropped: length %0d > maxpktsize %0d (addr=%0d)", pkt.length, maxpktsize, pkt.addr),
              UVM_LOW)
  end else begin
    reason = ROUTER_REASON_FORWARDED;
    packets_forwarded++;
    `uvm_info(get_type_name(),
              $sformatf("Packet forwarded: addr=%0d len=%0d -> channel %0d", pkt.addr, pkt.length, pkt.addr),
              UVM_MEDIUM)
    yapp_valid_out.write(pkt);
  end

  // Statistics of a packet received while enabled (forwarded or dropped)
  if (bad && en_reg[1]) begin
    parity_err_cnt++;
  end
  if (pkt.length > maxpktsize && en_reg[2]) begin
    oversized_cnt++;
  end
  if (en_reg[4 + pkt.addr]) begin
    addr_cnt[pkt.addr]++;
  end
  mem_size = {2'b00, pkt.length};
  pkt_mem[0]       = {pkt.length, pkt.addr};
  pkt_mem_known[0] = 1'b1;
  for (int i = 0; i < pkt.length; i++) begin
    pkt_mem[i + 1]       = pkt.payload[i];
    pkt_mem_known[i + 1] = 1'b1;
  end

  decision            = router_decision::type_id::create("decision");
  decision.pkt        = pkt;
  decision.maxpktsize = maxpktsize;
  decision.en_reg     = en_reg;
  decision.reason     = reason;
  decision_out.write(decision);
endfunction : write_yapp

//------------------------------------------------------------------------------
function bit[7:0] router_reference::expected_read(bit[15:0] addr, output bit known);
  known = 1'b1;
  if (addr >= 16'h1100 && addr <= 16'h11ff) begin
    known = scratch_known[addr[7:0]];
    return scratch_mem[addr[7:0]];
  end
  if (addr >= 16'h1010 && addr <= 16'h104f) begin
    known = pkt_mem_known[addr - 16'h1010];
    return pkt_mem[addr - 16'h1010];
  end
  case (addr)
    16'h1000: return ctrl_reg;
    16'h1001: return en_reg;
    16'h1004: return parity_err_cnt;
    16'h1005: return oversized_cnt;
    16'h1006: return addr_cnt[3];
    16'h1009: return addr_cnt[0];
    16'h100a: return addr_cnt[1];
    16'h100b: return addr_cnt[2];
    16'h100d: return mem_size;
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
    packets_forwarded, dropped_disabled, dropped_size, dropped_addr,
    parity_err_cnt, oversized_cnt, addr_cnt[0], addr_cnt[1], addr_cnt[2], addr_cnt[3]), UVM_LOW)
  if (check_reads) begin
    `uvm_info(get_type_name(), $sformatf("HBUS reads checked against the model: %0d (%0d mismatches, %0d of memory bytes never written)",
                                         reads_checked, read_mismatches, reads_unknown), UVM_LOW)
  end
endfunction : report_phase
