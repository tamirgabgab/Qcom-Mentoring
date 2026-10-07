//------------------------------------------------------------------------------
// hbus_master_driver.sv -- executes HBUS transactions on the interface
//
// For a READ the value returned by the DUT is written back into req.hdata,
// so the sequence (and the register adapter) can look at it after
// `uvm_do / finish_item returns.
//------------------------------------------------------------------------------
class hbus_master_driver extends uvm_driver #(hbus_transaction);

  virtual interface hbus_if vif;

  `uvm_component_utils(hbus_master_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!hbus_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    vif.hbus_reset();
    wait (vif.reset === 1'b0);
    forever begin
      seq_item_port.get_next_item(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask : run_phase

  task drive_transaction(hbus_transaction tr);
    void'(begin_tr(tr, "Driver_HBUS_Transaction"));
    if (tr.hwr_rd == HBUS_WRITE)
      vif.hbus_write(tr.haddr, tr.hdata);
    else
      vif.hbus_read(tr.haddr, tr.hdata);
    `uvm_info(get_type_name(), {"Executed ", tr.convert2string()}, UVM_MEDIUM)
    end_tr(tr);
  endtask : drive_transaction

endclass : hbus_master_driver
