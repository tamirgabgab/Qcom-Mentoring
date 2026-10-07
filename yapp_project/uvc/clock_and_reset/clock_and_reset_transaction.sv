//------------------------------------------------------------------------------
// clock_and_reset_transaction.sv -- one "start the clock and pulse reset" item
//------------------------------------------------------------------------------
class clock_and_reset_transaction extends uvm_sequence_item;

  rand int clock_period;   // time units per clock cycle
  rand int reset_cycles;   // clock cycles reset is held high

  constraint c_period { clock_period inside {[2:100]}; clock_period % 2 == 0; }
  constraint c_reset  { reset_cycles inside {[1:20]}; }

  `uvm_object_utils_begin(clock_and_reset_transaction)
    `uvm_field_int(clock_period, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(reset_cycles, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "clock_and_reset_transaction");
    super.new(name);
  endfunction : new

endclass : clock_and_reset_transaction
