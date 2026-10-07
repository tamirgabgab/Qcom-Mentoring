//------------------------------------------------------------------------------
// hbus_slave_agent.sv -- placeholder slave agent
//
// The router is the only slave on the bus and it is the DUT, so the router
// testbench configures num_slaves = 0. The class exists so hbus_env has the
// same shape as a generic bus UVC (masters[] and slaves[] arrays).
//------------------------------------------------------------------------------
class hbus_slave_agent extends uvm_agent;

  `uvm_component_utils(hbus_slave_agent)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : hbus_slave_agent

//------------------------------------------------------------------------------
// hbus_slave_agent -- method implementations
//------------------------------------------------------------------------------

function hbus_slave_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_slave_agent::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_is_active;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "is_active", cfg_is_active)) is_active = uvm_active_passive_enum'(cfg_is_active);
  `uvm_warning(get_type_name(),
               "hbus_slave_agent has no behaviour in this course; set num_slaves = 0")
endfunction : build_phase

//------------------------------------------------------------------------------
function void hbus_slave_agent::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_generic("is_active", "uvm_active_passive_enum", $bits(is_active), is_active.name());
endfunction : do_print
