//------------------------------------------------------------------------------
// hbus_env.sv -- HBUS UVC top level
//
// Configure from the testbench BEFORE building:
//   uvm_config_int::set(this, "hbus", "num_masters", 1);
//   uvm_config_int::set(this, "hbus", "num_slaves",  0);
//------------------------------------------------------------------------------
class hbus_env extends uvm_env;

  int m_num_masters = 1;
  int m_num_slaves  = 1;

  hbus_master_agent m_masters[];
  hbus_slave_agent  m_slaves[];
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
  uvm_bitstream_t cfg_num_slaves;
  super.build_phase(phase);
  // overrides set with uvm_config_int::set(...)
  if (uvm_config_int::get(this, "", "num_masters", cfg_num_masters)) begin
    m_num_masters = cfg_num_masters;
  end
  if (uvm_config_int::get(this, "", "num_slaves", cfg_num_slaves)) begin
    m_num_slaves = cfg_num_slaves;
  end
  m_monitor = hbus_monitor::type_id::create("monitor", this);
  m_masters = new[m_num_masters];
  foreach (m_masters[i]) begin
    m_masters[i] = hbus_master_agent::type_id::create($sformatf("masters[%0d]", i), this);
  end
  m_slaves = new[m_num_slaves];
  foreach (m_slaves[i]) begin
    m_slaves[i] = hbus_slave_agent::type_id::create($sformatf("slaves[%0d]", i), this);
  end
endfunction : build_phase

//------------------------------------------------------------------------------
function void hbus_env::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("num_masters", m_num_masters, $bits(m_num_masters), UVM_DEC);
  printer.print_field("num_slaves", m_num_slaves, $bits(m_num_slaves), UVM_DEC);
endfunction : do_print
