//------------------------------------------------------------------------------
// yapp_pkt_coverage.sv -- functional coverage of the input packets (Lab 10)
//
//   yapp_tx_monitor.item_collected_port ──► analysis_export (write)
//
// The covergroup lives in its own subscriber, not in the monitor: the monitor
// only observes and publishes, and a coverage model can be added, replaced or
// left out without touching it. The Cadence lab writes the same covergroup
// inside the monitor; the bins, and so the percentage, are the same.
//------------------------------------------------------------------------------
class yapp_pkt_coverage extends uvm_subscriber #(yapp_packet);

  int m_num_sampled;

  //--------------------------------------------------------------------------
  // Functional coverage (Lab 10)
  //   REQ1 all packet lengths, bucketed
  //   REQ2 all addresses, including the illegal one
  //   REQ3 every length bucket to every legal address with a parity error
  //--------------------------------------------------------------------------
  covergroup yapp_pkt_cg with function sample(bit[5:0] length,
                                              bit[1:0] addr,
                                              parity_type_e parity_type);
    option.per_instance = 1;
    length_cp : coverpoint length {
      bins MIN    = {1};
      bins SMALL  = {[2:10]};
      bins MEDIUM = {[11:40]};
      bins LARGE  = {[41:62]};
      bins MAX    = {63};
    }
    addr_cp : coverpoint addr {
      bins legal[]      = {[0:2]};
      bins illegal_addr = {3};
    }
    // one bin per enum value, written out (Verilator 5.052 bins an enum by range)
    parity_cp : coverpoint parity_type {
      bins good = {PARITY_TYPE_GOOD};
      bins bad  = {PARITY_TYPE_BAD};
    }
    // REQ3: only legal addresses and only PARITY_TYPE_BAD are interesting
`ifdef VERILATOR
    // (Verilator 5.052 drops ignore_bins with binsof/intersect, so the cross is
    // built from coverpoints that hold only the interesting bins: same 15 bins)
    legal_addr_cp : coverpoint addr { bins legal[] = {[0:2]}; }
    bad_parity_cp : coverpoint parity_type { bins bad = {PARITY_TYPE_BAD}; }
    len_x_addr_x_parity : cross length_cp, legal_addr_cp, bad_parity_cp;
`else
    len_x_addr_x_parity : cross length_cp, addr_cp, parity_cp {
      ignore_bins good_parity  = binsof(parity_cp) intersect {PARITY_TYPE_GOOD};
      ignore_bins illegal_addr = binsof(addr_cp.illegal_addr);
    }
`endif
  endgroup : yapp_pkt_cg

  `uvm_component_utils(yapp_pkt_coverage)

  extern function new(string name, uvm_component parent);

  // One packet from the monitor
  extern function void write(yapp_packet t);

  extern function void report_phase(uvm_phase phase);

endclass : yapp_pkt_coverage

//------------------------------------------------------------------------------
// yapp_pkt_coverage -- method implementations
//------------------------------------------------------------------------------

function yapp_pkt_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  yapp_pkt_cg = new();   // a covergroup inside a class is created with new()
endfunction : new

//------------------------------------------------------------------------------
function void yapp_pkt_coverage::write(yapp_packet t);
  m_num_sampled++;
  yapp_pkt_cg.sample(t.m_length, t.m_addr, t.m_parity_type);
endfunction : write

//------------------------------------------------------------------------------
function void yapp_pkt_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("YAPP packet coverage: %0d packets sampled, coverage %.1f%%",
                                       m_num_sampled, yapp_pkt_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
