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

function void uvm_reset_test::configure_sequences();
  set_clock_and_channel_sequences();
endfunction : configure_sequences

task uvm_reset_test::run_phase(uvm_phase phase);
  uvm_reg_hw_reset_seq reset_seq;
  super.run_phase(phase);                       // drain time
  phase.raise_objection(this);
  reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
  reset_seq.model = tb.yapp_rm;                 // the block to test
  reset_seq.start(null);
  phase.drop_objection(this);
endtask : run_phase
