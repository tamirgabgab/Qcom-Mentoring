//------------------------------------------------------------------------------
// yapp_tx_agent.sv -- the YAPP transmit agent (Lab 3, factory in Lab 4)
//
//   is_active == UVM_ACTIVE  : monitor + driver + sequencer (generates traffic)
//   is_active == UVM_PASSIVE : monitor only (just watches the bus)
// Both modes: the coverage subscribers pkt_cov (yapp_pkt_cg, Lab 10) and
// gap_cov (yapp_gap_cg) on the monitor's item_collected_port.
//------------------------------------------------------------------------------
class yapp_tx_agent extends uvm_agent;

  yapp_tx_monitor   m_monitor;
  yapp_pkt_coverage m_pkt_cov;
  yapp_gap_coverage m_gap_cov;
  yapp_tx_driver    m_driver;
  yapp_tx_sequencer m_sequencer;

  // is_active is inherited from uvm_agent (default UVM_ACTIVE); build_phase
  // picks up an override set with uvm_config_int::set(..., "is_active", ...)
  `uvm_component_utils(yapp_tx_agent)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : yapp_tx_agent

//------------------------------------------------------------------------------
// yapp_tx_agent -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_tx_agent::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_is_active;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) begin
    is_active = uvm_active_passive_enum'(cfg_is_active);
  end
  m_monitor = yapp_tx_monitor::type_id::create("monitor", this);
  m_pkt_cov = yapp_pkt_coverage::type_id::create("pkt_cov", this);
  m_gap_cov = yapp_gap_coverage::type_id::create("gap_cov", this);
  if (is_active == UVM_ACTIVE) begin
    m_driver    = yapp_tx_driver::type_id::create("driver", this);
    m_sequencer = yapp_tx_sequencer::type_id::create("sequencer", this);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
function void yapp_tx_agent::connect_phase(uvm_phase phase);
  m_monitor.m_item_collected_port.connect(m_pkt_cov.analysis_export);
  m_monitor.m_item_collected_port.connect(m_gap_cov.analysis_export);
  if (is_active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
function void yapp_tx_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
endfunction : do_print
