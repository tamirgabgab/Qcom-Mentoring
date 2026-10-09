//------------------------------------------------------------------------------
// reg_introspection_test.sv -- reg_introspection_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_introspection_test (Lab 11C, optional): let the model tell us which
// registers are RW and which are RO, then run the access checks on all of them.
//------------------------------------------------------------------------------
class reg_introspection_test extends reg_access_test;

  `uvm_component_utils(reg_introspection_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

endclass : reg_introspection_test

//------------------------------------------------------------------------------
// reg_introspection_test -- method implementations
//------------------------------------------------------------------------------

function reg_introspection_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task reg_introspection_test::access_checks();
  uvm_reg all_q[$];
  uvm_reg rw_q[$];
  uvm_reg ro_q[$];

  tb.yapp_rm.get_registers(all_q);          // every register in the model
  rw_q = all_q.find(r) with (r.get_rights() == "RW");
  ro_q = all_q.find(r) with (r.get_rights() == "RO");

  foreach (rw_q[i]) begin
    `uvm_info("REG_INTRO", $sformatf("RW register: %s @ 0x%04h", rw_q[i].get_name(), rw_q[i].get_address()), UVM_NONE)
  end
  foreach (ro_q[i]) begin
    `uvm_info("REG_INTRO", $sformatf("RO register: %s @ 0x%04h", ro_q[i].get_name(), ro_q[i].get_address()), UVM_NONE)
  end

  foreach (rw_q[i]) begin
    check_rw_register(rw_q[i], 8'h25, 8'h1a);
  end
  foreach (ro_q[i]) begin
    check_ro_register(ro_q[i], 8'h5a, 8'h33);
  end
endtask : access_checks
