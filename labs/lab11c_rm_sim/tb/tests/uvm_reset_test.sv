//------------------------------------------------------------------------------
// uvm_reset_test.sv -- uvm_reset_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// uvm_reset_test (Lab 11B)
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
  set_clock_and_channel_sequences();
endfunction : configure_sequences

//------------------------------------------------------------------------------
task uvm_reset_test::run_phase(uvm_phase phase);
  uvm_reg_hw_reset_seq reset_seq;
  super.run_phase(phase);
  phase.raise_objection(this);
  reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
  reset_seq.model = tb.yapp_rm;
  reset_seq.start(null);
  phase.drop_objection(this);
endtask : run_phase
