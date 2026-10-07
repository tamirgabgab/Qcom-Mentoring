//------------------------------------------------------------------------------
// clock_and_reset_agent.sv -- active agent (no monitor needed for clock/reset)
//------------------------------------------------------------------------------
class clock_and_reset_agent extends uvm_agent;

  clock_and_reset_driver    driver;
  clock_and_reset_sequencer sequencer;

  `uvm_component_utils(clock_and_reset_agent)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : clock_and_reset_agent

//------------------------------------------------------------------------------
// clock_and_reset_agent -- method implementations
//------------------------------------------------------------------------------

function clock_and_reset_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void clock_and_reset_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // configuration formerly applied by the field automation
  begin
    uvm_bitstream_t cfg_is_active;
    if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) is_active = uvm_active_passive_enum'(cfg_is_active);
  end
  if (is_active == UVM_ACTIVE) begin
    driver    = clock_and_reset_driver::type_id::create("driver", this);
    sequencer = clock_and_reset_sequencer::type_id::create("sequencer", this);
  end
endfunction : build_phase

function void clock_and_reset_agent::connect_phase(uvm_phase phase);
  if (is_active == UVM_ACTIVE)
    driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction : connect_phase

function void clock_and_reset_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
endfunction : do_print
