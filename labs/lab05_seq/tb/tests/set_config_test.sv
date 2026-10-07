//------------------------------------------------------------------------------
// set_config_test.sv -- set_config_test (test library (Lab 5: sequence tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// set_config_test (Lab 4)
//------------------------------------------------------------------------------
class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yapp.agent", "is_active", UVM_PASSIVE);
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    // intentionally empty: there is no sequencer to configure
  endfunction : configure_sequences

endclass : set_config_test
