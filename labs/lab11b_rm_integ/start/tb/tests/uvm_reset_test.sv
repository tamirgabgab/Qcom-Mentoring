// START POINT of Lab 11B: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11b_rm_integ/tb/tests/uvm_reset_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// uvm_reset_test.sv -- uvm_reset_test (test library (Lab 11B: built-in register sequences))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// uvm_reset_test: the built-in uvm_reg_hw_reset_seq resets the model, reads
// every register through the HBUS and compares with the reset values.
// Register sequences are started with a null sequencer: the model's map
// knows which sequencer to use (set_sequencer in router_tb).
//------------------------------------------------------------------------------
class uvm_reset_test extends base_test;

  `uvm_component_utils(uvm_reset_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

  extern task run_phase(uvm_phase phase);

endclass : uvm_reset_test

//------------------------------------------------------------------------------
// uvm_reset_test -- method implementations
//------------------------------------------------------------------------------

function uvm_reset_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void uvm_reset_test::configure_sequences();
  // TODO (Lab 11B): write uvm_reset_test::configure_sequences
endfunction : configure_sequences

//------------------------------------------------------------------------------
task uvm_reset_test::run_phase(uvm_phase phase);
  super.run_phase(phase);                       // drain time
  // TODO (Lab 11B): write uvm_reset_test::run_phase
endtask : run_phase
