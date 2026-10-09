//------------------------------------------------------------------------------
// hbus_master_agent.sv -- driver + sequencer. The monitor is shared by all
// agents and lives in hbus_env (there is one bus, so one monitor is enough).
//------------------------------------------------------------------------------
class hbus_master_agent extends uvm_agent;

  hbus_master_driver    driver;
  hbus_master_sequencer sequencer;

  `uvm_component_utils(hbus_master_agent)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : hbus_master_agent

//------------------------------------------------------------------------------
// hbus_master_agent -- method implementations
//------------------------------------------------------------------------------

function hbus_master_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_master_agent::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_is_active;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) begin
    is_active = uvm_active_passive_enum'(cfg_is_active);
  end
  if (is_active == UVM_ACTIVE) begin
    driver    = hbus_master_driver::type_id::create("driver", this);
    sequencer = hbus_master_sequencer::type_id::create("sequencer", this);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
function void hbus_master_agent::connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end
endfunction : connect_phase

//------------------------------------------------------------------------------
function void hbus_master_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
endfunction : do_print
