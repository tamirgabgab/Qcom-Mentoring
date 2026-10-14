//------------------------------------------------------------------------------
// router_coverage.sv -- coverage of the router configuration the packets met
// (test plan RND-01..04)
//
//   router_reference.decision_out ──► analysis_export (write)
//
// One sample per packet received while the router is enabled: the maxpktsize
// in force, the length against it, why it was dropped (or forwarded) and its
// parity, and the counter enables. Informative: report_phase prints what the
// run reached, no test fails on it.
//------------------------------------------------------------------------------
class router_coverage extends uvm_subscriber #(router_decision);

  int m_num_sampled;

  covergroup router_cfg_cg with function sample(bit[5:0] max, int len_vs_max, router_reason_e reason, bit bad,
                                                bit[6:0] cnt_en);
    option.per_instance = 1;
    max_cp : coverpoint max {
      bins zero  = {0};
      bins one   = {1};
      bins mid   = {[2:61]};
      bins max62 = {62};
      bins max63 = {63};
    }
    len_cp : coverpoint len_vs_max {
      bins below    = {0};
      bins equal    = {1};
      bins plus_one = {2};
      bins above    = {3};
    }
    // one bin per enum value, written out (Verilator 5.052 bins an enum by range)
    reason_cp : coverpoint reason {
      bins forwarded = {ROUTER_REASON_FORWARDED};
      bins addr3     = {ROUTER_REASON_ADDR3};
      bins oversized = {ROUTER_REASON_OVERSIZED};
    }
    parity_cp : coverpoint bad {
      bins good = {0};
      bins bad  = {1};
    }
    cnt_en_cp : coverpoint cnt_en {
      bins none  = {7'h00};
      bins mixed = {[7'h01:7'h7e]};
      bins all   = {7'h7f};
    }
    reason_x_parity : cross reason_cp, parity_cp;
  endgroup : router_cfg_cg

  // The same bins, counted by hand for the breakdown in the report (Verilator
  // does not support get_inst_coverage() on a single coverpoint)
  int m_hits_max[5];                          // maxpktsize 0, 1, 2..61, 62, 63
  int m_hits_len[4];                          // length below / equal / max+1 / above max
  int m_hits_reason_parity[4][2];             // [reason][bad]: index 0 (UNDEFINED) stays empty
  int m_hits_cnt_en[3];                       // counter enables none / mixed / all

  `uvm_component_utils(router_coverage)

  extern function new(string name, uvm_component parent);

  // One decision of the reference model
  extern function void write(router_decision t);

  extern function void report_phase(uvm_phase phase);

endclass : router_coverage

//------------------------------------------------------------------------------
// router_coverage -- method implementations
//------------------------------------------------------------------------------

function router_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  router_cfg_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void router_coverage::write(router_decision t);
  int len_vs_max;
  bit bad;
  bad = (t.m_pkt.m_parity_type == PARITY_TYPE_BAD);
  if (t.m_pkt.m_length < t.m_maxpktsize) begin
    len_vs_max = 0;
  end else if (t.m_pkt.m_length == t.m_maxpktsize) begin
    len_vs_max = 1;
  end else if (t.m_pkt.m_length == t.m_maxpktsize + 1) begin
    len_vs_max = 2;
  end else begin
    len_vs_max = 3;
  end
  m_num_sampled++;
  router_cfg_cg.sample(t.m_maxpktsize, len_vs_max, t.m_reason, bad, t.m_en_reg[7:1]);
  m_hits_max[(t.m_maxpktsize == 0) ? 0 : (t.m_maxpktsize == 1) ? 1 : (t.m_maxpktsize == 62) ? 3 : (t.m_maxpktsize == 63) ? 4 : 2]++;
  m_hits_len[len_vs_max]++;
  m_hits_reason_parity[t.m_reason][bad]++;
  m_hits_cnt_en[(t.m_en_reg[7:1] == 7'h00) ? 0 : (t.m_en_reg[7:1] == 7'h7f) ? 2 : 1]++;
endfunction : write

//------------------------------------------------------------------------------
function void router_coverage::report_phase(uvm_phase phase);
  if (m_num_sampled == 0) begin
    return;
  end
  `uvm_info(get_type_name(), $sformatf({"Coverage of the router configuration: %0.1f%%\n",
    "  maxpktsize 0 / 1 / 2..61 / 62 / 63       : %0d / %0d / %0d / %0d / %0d packets\n",
    "  length < max / = max / max+1 / > max+1   : %0d / %0d / %0d / %0d\n",
    "  forwarded good / bad                     : %0d / %0d\n",
    "  dropped address 3 good / bad             : %0d / %0d\n",
    "  dropped oversized good / bad             : %0d / %0d\n",
    "  counter enables none / mixed / all       : %0d / %0d / %0d"},
    router_cfg_cg.get_inst_coverage(),
    m_hits_max[0], m_hits_max[1], m_hits_max[2], m_hits_max[3], m_hits_max[4],
    m_hits_len[0], m_hits_len[1], m_hits_len[2], m_hits_len[3],
    m_hits_reason_parity[ROUTER_REASON_FORWARDED][0], m_hits_reason_parity[ROUTER_REASON_FORWARDED][1],
    m_hits_reason_parity[ROUTER_REASON_ADDR3][0], m_hits_reason_parity[ROUTER_REASON_ADDR3][1],
    m_hits_reason_parity[ROUTER_REASON_OVERSIZED][0], m_hits_reason_parity[ROUTER_REASON_OVERSIZED][1],
    m_hits_cnt_en[0], m_hits_cnt_en[1], m_hits_cnt_en[2]), UVM_LOW)
endfunction : report_phase
