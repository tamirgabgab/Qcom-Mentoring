//------------------------------------------------------------------------------
// hbus_monitor.sv -- common bus monitor (one per hbus_env)
//
// Publishes every observed transaction on `item_collected_port`. Lab 9B
// connects it to the router reference model so it can mirror the register
// writes; Lab 11 uses the same traffic for the register model predictor.
//------------------------------------------------------------------------------
class hbus_monitor extends uvm_monitor;

  virtual interface hbus_if m_vif;

  uvm_analysis_port #(hbus_transaction) m_item_collected_port;

  int m_num_writes;
  int m_num_reads;

  `uvm_component_utils(hbus_monitor)

  // The fields are printed by do_print() below:
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function void report_phase(uvm_phase phase);

endclass : hbus_monitor

//------------------------------------------------------------------------------
// hbus_monitor -- method implementations
//------------------------------------------------------------------------------

function hbus_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  m_item_collected_port = new("item_collected_port", this);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_monitor::connect_phase(uvm_phase phase);
  if (!hbus_vif_config::get(this, "", "vif", m_vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task hbus_monitor::run_phase(uvm_phase phase);
  hbus_transaction tr;
  bit is_write;
  @(posedge m_vif.clock);
  wait (m_vif.reset === 1'b0);
  forever begin
    tr = hbus_transaction::type_id::create("tr", this);   // new object each time
    m_vif.collect_transaction(tr.m_haddr, tr.m_hdata, is_write);
    tr.m_hwr_rd = is_write ? HBUS_OP_WRITE : HBUS_OP_READ;
    if (is_write) begin
      m_num_writes++;
    end else begin
      m_num_reads++;
    end
    `uvm_info(get_type_name(), {"Collected ", tr.convert2string()}, UVM_MEDIUM)
    m_item_collected_port.write(tr);
  end
endtask : run_phase

//------------------------------------------------------------------------------
function void hbus_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),
            $sformatf("HBUS report: %0d writes, %0d reads", m_num_writes, m_num_reads), UVM_LOW)
endfunction : report_phase

//------------------------------------------------------------------------------
function void hbus_monitor::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_writes", m_num_writes, $bits(m_num_writes), UVM_DEC);
  printer.print_field("num_reads", m_num_reads, $bits(m_num_reads), UVM_DEC);
endfunction : do_print
