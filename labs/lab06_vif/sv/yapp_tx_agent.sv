//------------------------------------------------------------------------------
// yapp_tx_agent.sv -- the YAPP transmit agent (Lab 3, factory in Lab 4)
//
//   is_active == UVM_ACTIVE  : monitor + driver + sequencer (generates traffic)
//   is_active == UVM_PASSIVE : monitor only (just watches the bus)
//------------------------------------------------------------------------------
class yapp_tx_agent extends uvm_agent;

  yapp_tx_monitor   monitor;
  yapp_tx_driver    driver;
  yapp_tx_sequencer sequencer;

  // is_active is inherited from uvm_agent (default UVM_ACTIVE); the field
  // macro makes it configurable with uvm_config_int::set(...,"is_active",...)
  `uvm_component_utils_begin(yapp_tx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = yapp_tx_monitor::type_id::create("monitor", this);
    if (is_active == UVM_ACTIVE) begin
      driver    = yapp_tx_driver::type_id::create("driver", this);
      sequencer = yapp_tx_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : yapp_tx_agent
