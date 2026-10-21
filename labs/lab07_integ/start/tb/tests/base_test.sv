// START POINT of Lab 7: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab07_integ/tb/tests/base_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 7: multi-UVC tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench, prints the topology, no default sequences.
// Without a clock sequence nothing runs, which is exactly what you want when
// checking the topology report.
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb m_tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern virtual function void configure_sequences();

  // Helpers shared by the tests below
  extern function void set_clock_and_channel_sequences();
  extern function void end_of_elaboration_phase(uvm_phase phase);

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
  // TODO (Lab 7): write base_test::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void base_test::configure_sequences();
  // nothing: derived tests decide what runs
  // TODO (Lab 7): write base_test::configure_sequences
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void base_test::set_clock_and_channel_sequences();
  // one wildcard statement for all three channels
  // TODO (Lab 7): write base_test::set_clock_and_channel_sequences
endfunction : set_clock_and_channel_sequences

//------------------------------------------------------------------------------
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
task base_test::run_phase(uvm_phase phase);
  uvm_objection obj = phase.get_objection();
  obj.set_drain_time(this, 200ns);
endtask : run_phase

//------------------------------------------------------------------------------
function void base_test::check_phase(uvm_phase phase);
  check_config_usage();
endfunction : check_phase
