//------------------------------------------------------------------------------
// yapp_gap_coverage.sv -- coverage of the gap between input packets (test plan
// ROUTE-04)
//
//   yapp_tx_monitor.item_collected_port ──► analysis_export (write)
//
// On a collected packet, packet_delay is the gap the monitor measured: idle
// cycles since the previous packet's parity byte, -1 for the first packet
// after reset (not sampled). Separate from yapp_pkt_cg, so the Lab 10
// percentage does not change.
//------------------------------------------------------------------------------
class yapp_gap_coverage extends uvm_subscriber #(yapp_packet);

  int m_num_sampled;

  // ROUTE-04: packets back to back (gap 0) and with short gaps
  covergroup yapp_gap_cg with function sample(int gap);
    option.per_instance = 1;
    gap_cp : coverpoint gap {
      bins back_to_back = {0};
      bins one          = {1};
      bins two          = {2};
      bins longer       = {[3:$]};
    }
  endgroup : yapp_gap_cg

  `uvm_component_utils(yapp_gap_coverage)

  extern function new(string name, uvm_component parent);

  // One packet from the monitor
  extern function void write(yapp_packet t);

  extern function void report_phase(uvm_phase phase);

endclass : yapp_gap_coverage

//------------------------------------------------------------------------------
// yapp_gap_coverage -- method implementations
//------------------------------------------------------------------------------

function yapp_gap_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  yapp_gap_cg = new();
endfunction : new

//------------------------------------------------------------------------------
function void yapp_gap_coverage::write(yapp_packet t);
  if (t.m_packet_delay < 0) begin
    return;                                 // the first packet after reset has no gap
  end
  m_num_sampled++;
  yapp_gap_cg.sample(t.m_packet_delay);
endfunction : write

//------------------------------------------------------------------------------
function void yapp_gap_coverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("YAPP gap coverage: %0d gaps sampled, coverage %.1f%%",
                                       m_num_sampled, yapp_gap_cg.get_inst_coverage()), UVM_LOW)
endfunction : report_phase
