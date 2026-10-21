//------------------------------------------------------------------------------
// hbus_env.sv -- HBUS UVC top level
//
// Configure from the testbench BEFORE building:
//   uvm_config_int::set(this, "hbus", "num_masters", 1);
//
// The router is the only slave on the bus, so the UVC has master agents and
// one shared monitor; there is no slave agent.
//------------------------------------------------------------------------------
class hbus_env extends uvm_env;

  int m_num_masters = 1;

  hbus_master_agent m_masters[];
  hbus_monitor      m_monitor;

  `uvm_component_utils(hbus_env)

  // The fields are printed by do_print() below and read from uvm_config_db in build_phase():
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);

endclass : hbus_env

//------------------------------------------------------------------------------
// hbus_env -- method implementations
//------------------------------------------------------------------------------

function hbus_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_env::build_phase(uvm_phase phase);
  uvm_bitstream_t cfg_num_masters;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "num_masters", cfg_num_masters)) begin
    m_num_masters = cfg_num_masters;
  end
  m_monitor = hbus_monitor::type_id::create("monitor", this);
  m_masters = new[m_num_masters];
  foreach (m_masters[i]) begin
    m_masters[i] = hbus_master_agent::type_id::create($sformatf("masters[%0d]", i), this);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
function void hbus_env::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_masters", m_num_masters, $bits(m_num_masters), UVM_DEC);
endfunction : do_print
