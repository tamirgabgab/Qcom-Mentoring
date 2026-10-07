//------------------------------------------------------------------------------
// hbus_slave_agent.sv -- placeholder slave agent
//
// The router is the only slave on the bus and it is the DUT, so the router
// testbench configures num_slaves = 0. The class exists so hbus_env has the
// same shape as a generic bus UVC (masters[] and slaves[] arrays).
//------------------------------------------------------------------------------
class hbus_slave_agent extends uvm_agent;

  `uvm_component_utils_begin(hbus_slave_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_warning(get_type_name(),
                 "hbus_slave_agent has no behaviour in this course; set num_slaves = 0")
  endfunction : build_phase

endclass : hbus_slave_agent
