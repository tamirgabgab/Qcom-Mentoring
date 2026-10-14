//------------------------------------------------------------------------------
// clock_and_reset_driver.sv -- drives the clock controls and the reset line
//------------------------------------------------------------------------------
class clock_and_reset_driver extends uvm_driver #(clock_and_reset_transaction);

  virtual interface clock_and_reset_if m_vif;

  `uvm_component_utils(clock_and_reset_driver)

  extern function new(string name, uvm_component parent);
  extern function void connect_phase(uvm_phase phase);

  extern task run_phase(uvm_phase phase);

endclass : clock_and_reset_driver

//------------------------------------------------------------------------------
// clock_and_reset_driver -- method implementations
//------------------------------------------------------------------------------

function clock_and_reset_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void clock_and_reset_driver::connect_phase(uvm_phase phase);
  if (!clock_and_reset_vif_config::get(this, "", "vif", m_vif)) begin
    `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
task clock_and_reset_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    `uvm_info(get_type_name(),
              $sformatf("Starting clock (period %0d) and holding reset for %0d cycles",
                        req.m_clock_period, req.m_reset_cycles), UVM_MEDIUM)
    m_vif.start_clock_and_reset(req.m_clock_period, req.m_reset_cycles);
    seq_item_port.item_done();
  end
endtask : run_phase
