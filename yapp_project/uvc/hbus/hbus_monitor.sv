//------------------------------------------------------------------------------
// hbus_monitor.sv -- common bus monitor (one per hbus_env)
//
// Publishes every observed transaction on `item_collected_port`. Lab 9B
// connects it to the router reference model so it can mirror the register
// writes; Lab 11 uses the same traffic for the register model predictor.
//------------------------------------------------------------------------------
class hbus_monitor extends uvm_monitor;

  virtual interface hbus_if vif;

  uvm_analysis_port #(hbus_transaction) item_collected_port;

  int num_writes;
  int num_reads;

  `uvm_component_utils_begin(hbus_monitor)
    `uvm_field_int(num_writes, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(num_reads,  UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!hbus_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    hbus_transaction tr;
    bit is_write;
    @(posedge vif.clock);
    wait (vif.reset === 1'b0);
    forever begin
      tr = hbus_transaction::type_id::create("tr", this);   // new object each time
      vif.collect_transaction(tr.haddr, tr.hdata, is_write);
      tr.hwr_rd = is_write ? HBUS_WRITE : HBUS_READ;
      if (is_write) num_writes++; else num_reads++;
      `uvm_info(get_type_name(), {"Collected ", tr.convert2string()}, UVM_LOW)
      item_collected_port.write(tr);
    end
  endtask : run_phase

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
              $sformatf("HBUS report: %0d writes, %0d reads", num_writes, num_reads), UVM_LOW)
  endfunction : report_phase

endclass : hbus_monitor
