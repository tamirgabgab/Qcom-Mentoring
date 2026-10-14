//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- observes packets on the YAPP input port (Lab 6)
//
// The monitor reaches the DUT pins through a VIRTUAL INTERFACE handle that
// tb_top stores in the configuration database and connect_phase() fetches.
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if m_vif;

  // Statistics
  int m_num_pkt_col;

  `uvm_component_utils(yapp_tx_monitor)

  // The fields are printed by do_print() below:
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task collect_packets();
  extern function void report_phase(uvm_phase phase);

endclass : yapp_tx_monitor

//------------------------------------------------------------------------------
// yapp_tx_monitor -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_tx_monitor::connect_phase(uvm_phase phase);
  // get() returns 1 on success: always check it, a missing vif is fatal later
  if (!yapp_vif_config::get(this, "", "vif", m_vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task yapp_tx_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "YAPP monitor running", UVM_LOW)
  collect_packets();
endtask : run_phase

//------------------------------------------------------------------------------
task yapp_tx_monitor::collect_packets();
  yapp_packet pkt;
  // Nothing to observe while reset is active
  @(posedge m_vif.clock);
  wait (m_vif.reset === 1'b0);
  forever begin
    pkt = yapp_packet::type_id::create("pkt", this);
    m_vif.collect_packets(pkt.m_addr, pkt.m_length, pkt.m_payload, pkt.m_parity);
    void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
    pkt.m_parity_type = (pkt.m_parity == pkt.calc_parity()) ? PARITY_TYPE_GOOD : PARITY_TYPE_BAD;
    m_num_pkt_col++;
    `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_LOW)
    end_tr(pkt);
  end
endtask : collect_packets

//------------------------------------------------------------------------------
function void yapp_tx_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
            $sformatf("YAPP monitor report: %0d packets collected", m_num_pkt_col), UVM_LOW)
endfunction : report_phase

//------------------------------------------------------------------------------
function void yapp_tx_monitor::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_pkt_col", m_num_pkt_col, $bits(m_num_pkt_col), UVM_DEC);
endfunction : do_print
