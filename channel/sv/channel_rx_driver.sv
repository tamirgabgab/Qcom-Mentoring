//------------------------------------------------------------------------------
// channel_rx_driver.sv -- plays the receiver on one output channel
//------------------------------------------------------------------------------
class channel_rx_driver extends uvm_driver #(channel_packet);

  virtual interface channel_if vif;
  int channel_id;

  `uvm_component_utils_begin(channel_rx_driver)
    `uvm_field_int(channel_id, UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void connect_phase(uvm_phase phase);
    if (!channel_vif_config::get(this, "", "vif", vif))
      `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    // Keep the channel suspended until reset is released
    vif.channel_reset();
    wait (vif.reset === 1'b0);
    forever begin
      seq_item_port.get_next_item(req);
      vif.receive_packet(req.delay);
      seq_item_port.item_done();
    end
  endtask : run_phase

endclass : channel_rx_driver
