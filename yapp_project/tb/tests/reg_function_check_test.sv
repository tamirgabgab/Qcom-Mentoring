//------------------------------------------------------------------------------
// reg_function_check_test.sv -- reg_function_check_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_function_check_test (Lab 11C, optional): automatic checking on read.
// With set_check_on_read(1) every read() compares the DUT value with the
// mirror. RO counters change without bus traffic, so the mirror must be
// loaded with predict() before each read.
//------------------------------------------------------------------------------
class reg_function_check_test extends reg_function_test;

  `uvm_component_utils(reg_function_check_test)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

  // Load the expected value, then let read() do the comparison
  extern virtual task check_counter(uvm_reg rg, uvm_reg_data_t expected);

endclass : reg_function_check_test

//------------------------------------------------------------------------------
// reg_function_check_test -- method implementations
//------------------------------------------------------------------------------

function reg_function_check_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task reg_function_check_test::run_phase(uvm_phase phase);
  tb.yapp_rm.default_map.set_check_on_read(1);
  super.run_phase(phase);
endtask : run_phase

//------------------------------------------------------------------------------
task reg_function_check_test::check_counter(uvm_reg rg, uvm_reg_data_t expected);
  uvm_status_e   status;
  uvm_reg_data_t val;
  void'(rg.predict(expected));
  rg.read(status, val);                     // mismatch -> UVM_ERROR from the map
  `uvm_info("REG_FUNC", $sformatf("%s reads %0d (checked against predicted %0d)",
                                  rg.get_name(), val, expected), UVM_NONE)
endtask : check_counter
