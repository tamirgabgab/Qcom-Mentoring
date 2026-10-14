//------------------------------------------------------------------------------
// yapp_tx_monitor.sv -- observes packets on the YAPP input port (Lab 3/6/9A/10)
//
//   * watches the interface through a virtual interface (Lab 6)
//   * publishes every packet on item_collected_port (Lab 9A)
// The functional coverage of the input traffic (Lab 10) is not here: it lives
// in yapp_pkt_coverage and yapp_gap_coverage, subscribers of
// item_collected_port (see yapp_tx_agent).
//------------------------------------------------------------------------------
class yapp_tx_monitor extends uvm_monitor;

  // Virtual interface, set by tb_top through yapp_vif_config
  virtual interface yapp_if m_vif;

  // Analysis port: the scoreboard / reference model subscribe here
  uvm_analysis_port #(yapp_packet) m_item_collected_port;

  // Statistics
  int m_num_pkt_col;
  int m_num_bad_parity;   // packets seen with a wrong parity byte (Lab 11C uses it)

  // Gap before each packet: idle cycles since the previous packet's parity
  // byte (test plan ROUTE-04), also written into the collected packet's
  // packet_delay (-1 for the first packet after reset). num_gap[0..2] count
  // gaps of 0, 1 and 2 cycles, num_gap[3] the longer ones; the first packet
  // after reset is not counted.
  int m_last_gap = -1;
  int m_num_gap[4];

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
  m_item_collected_port = new("item_collected_port", this);
endfunction : new

//------------------------------------------------------------------------------
function void yapp_tx_monitor::connect_phase(uvm_phase phase);
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
  int idle_cycles;
  bit first = 1'b1;
  // Nothing to observe while reset is active
  @(posedge m_vif.clock);
  wait (m_vif.reset === 1'b0);
  forever begin
    // A NEW object per packet: subscribers keep the handle (analysis FIFOs
    // do not clone), so re-using one object would corrupt earlier packets.
    pkt = yapp_packet::type_id::create("pkt", this);
    m_vif.collect_packets(pkt.m_addr, pkt.m_length, pkt.m_payload, pkt.m_parity, idle_cycles);
    if (first) begin
      pkt.m_packet_delay = -1;                // no previous packet: no gap
    end else begin
      pkt.m_packet_delay = idle_cycles;
      m_last_gap = idle_cycles;
      m_num_gap[(idle_cycles > 3) ? 3 : idle_cycles]++;
    end
    first = 1'b0;
    void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
    pkt.m_parity_type = (pkt.m_parity == pkt.calc_parity()) ? PARITY_TYPE_GOOD : PARITY_TYPE_BAD;
    m_num_pkt_col++;
    if (pkt.m_parity_type == PARITY_TYPE_BAD) begin
      m_num_bad_parity++;
    end
    `uvm_info(get_type_name(),
              $sformatf("RX pkt #%0d on the input: addr=%0d len=%0d parity=%s gap=%0d", m_num_pkt_col, pkt.m_addr,
                        pkt.m_length, pkt.parity_text(), idle_cycles), UVM_MEDIUM)
    `uvm_info(get_type_name(), $sformatf("Packet collected:\n%s", pkt.sprint()), UVM_HIGH)
    m_item_collected_port.write(pkt);
    end_tr(pkt);
  end
endtask : collect_packets

//------------------------------------------------------------------------------
function void yapp_tx_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
            $sformatf("YAPP monitor report: %0d packets collected, %0d with bad parity",
                      m_num_pkt_col, m_num_bad_parity), UVM_LOW)
  `uvm_info(get_type_name(),
            $sformatf("YAPP gaps: %0d back to back, %0d of 1 cycle, %0d of 2, %0d longer",
                      m_num_gap[0], m_num_gap[1], m_num_gap[2], m_num_gap[3]), UVM_LOW)
endfunction : report_phase

//------------------------------------------------------------------------------
function void yapp_tx_monitor::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_pkt_col", m_num_pkt_col, $bits(m_num_pkt_col), UVM_DEC);
endfunction : do_print
