//------------------------------------------------------------------------------
// set_config_test.sv -- set_config_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// set_config_test (Lab 4)
//------------------------------------------------------------------------------
class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void configure_sequences();

endclass : set_config_test

//------------------------------------------------------------------------------
// set_config_test -- method implementations
//------------------------------------------------------------------------------

function set_config_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void set_config_test::build_phase(uvm_phase phase);
  uvm_config_int::set(this, "tb.yapp.agent", "is_active", UVM_PASSIVE);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
function void set_config_test::configure_sequences();
  // intentionally empty: there is no sequencer to configure
endfunction : configure_sequences
