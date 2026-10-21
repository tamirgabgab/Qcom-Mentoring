// START POINT of Lab 11B: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11b_rm_integ/tb/tests/uvm_mem_walk_test.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// uvm_mem_walk_test.sv -- uvm_mem_walk_test (test library (Lab 11B: built-in register sequences))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// uvm_mem_walk_test (optional): walking-ones memory test on every RW memory
// (only yapp_mem, 0x1100..0x11ff). Expect 511 HBUS writes and 255 reads.
// Re-run with  xrun -f run.f -define INJECT_ERROR  to see the error caught.
//------------------------------------------------------------------------------
class uvm_mem_walk_test extends base_test;

  `uvm_component_utils(uvm_mem_walk_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

  extern task run_phase(uvm_phase phase);

endclass : uvm_mem_walk_test

//------------------------------------------------------------------------------
// uvm_mem_walk_test -- method implementations
//------------------------------------------------------------------------------

function uvm_mem_walk_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void uvm_mem_walk_test::configure_sequences();
  // TODO (Lab 11B): write uvm_mem_walk_test::configure_sequences
endfunction : configure_sequences

//------------------------------------------------------------------------------
task uvm_mem_walk_test::run_phase(uvm_phase phase);
  super.run_phase(phase);
  // TODO (Lab 11B): write uvm_mem_walk_test::run_phase
endtask : run_phase
