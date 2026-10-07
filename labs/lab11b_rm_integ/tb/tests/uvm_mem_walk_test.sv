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

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

  task run_phase(uvm_phase phase);
    uvm_mem_walk_seq walk_seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    walk_seq = uvm_mem_walk_seq::type_id::create("walk_seq");
    walk_seq.model = tb.yapp_rm;
    walk_seq.start(null);
    phase.drop_objection(this);
  endtask : run_phase

endclass : uvm_mem_walk_test
