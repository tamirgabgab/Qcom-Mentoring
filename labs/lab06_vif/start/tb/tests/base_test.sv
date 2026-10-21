// START POINT of Lab 6: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab06_vif/tb/tests/base_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb m_tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Default sequences for the sequencers in the testbench
  extern virtual function void configure_sequences();

  extern function void end_of_elaboration_phase(uvm_phase phase);

  // Drain time: once the last objection is dropped, keep simulating for
  // 200 ns so packets still inside the router can come out.
  extern task run_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);

endclass : base_test

//------------------------------------------------------------------------------
// base_test -- method implementations
//------------------------------------------------------------------------------

function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
  uvm_config_int::set(this, "*", "recording_detail", 1);   // transaction recording
  configure_sequences();                                   // before the tb is built!
  m_tb = router_tb::type_id::create("tb", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void base_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                          "default_sequence", yapp_5_packets::get_type());
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
task base_test::run_phase(uvm_phase phase);
  // TODO (Lab 6): write base_test::run_phase
endtask : run_phase

//------------------------------------------------------------------------------
function void base_test::check_phase(uvm_phase phase);
  // TODO (Lab 6): write base_test::check_phase
endfunction : check_phase
