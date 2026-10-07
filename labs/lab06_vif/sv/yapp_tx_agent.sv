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

function void yapp_tx_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // configuration formerly applied by the field automation
  begin
    uvm_bitstream_t cfg_is_active;
    if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) is_active = uvm_active_passive_enum'(cfg_is_active);
  end
  monitor = yapp_tx_monitor::type_id::create("monitor", this);
  if (is_active == UVM_ACTIVE) begin
    driver    = yapp_tx_driver::type_id::create("driver", this);
    sequencer = yapp_tx_sequencer::type_id::create("sequencer", this);
  end
endfunction : build_phase

function void yapp_tx_agent::connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE)
    driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction : connect_phase

function void yapp_tx_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
endfunction : do_print
