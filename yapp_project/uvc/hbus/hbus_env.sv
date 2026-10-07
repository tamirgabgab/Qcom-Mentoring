//------------------------------------------------------------------------------
// hbus_env.sv -- HBUS UVC top level
//
// Configure from the testbench BEFORE building:
//   uvm_config_int::set(this, "hbus", "num_masters", 1);
//   uvm_config_int::set(this, "hbus", "num_slaves",  0);
//------------------------------------------------------------------------------
class hbus_env extends uvm_env;

  int num_masters = 1;
  int num_slaves  = 1;

  hbus_master_agent masters[];
  hbus_slave_agent  slaves[];
  hbus_monitor      monitor;

  `uvm_component_utils_begin(hbus_env)
    `uvm_field_int(num_masters, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(num_slaves,  UVM_ALL_ON | UVM_DEC)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = hbus_monitor::type_id::create("monitor", this);
    masters = new[num_masters];
    foreach (masters[i])
      masters[i] = hbus_master_agent::type_id::create($sformatf("masters[%0d]", i), this);
    slaves = new[num_slaves];
    foreach (slaves[i])
      slaves[i] = hbus_slave_agent::type_id::create($sformatf("slaves[%0d]", i), this);
  endfunction : build_phase

endclass : hbus_env
