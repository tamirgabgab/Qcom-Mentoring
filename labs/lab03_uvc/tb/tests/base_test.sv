//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 3))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench, selects the default sequence of the YAPP
// sequencer and prints the topology
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb tb;

  `uvm_component_utils(base_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
    // Configuration must be set BEFORE the component that reads it is built.
    // The path is the sequencer's hierarchical name from the topology print.
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_5_packets::get_type());
    tb = new("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  // Optional: which component reports first / last and why?
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

endclass : base_test
