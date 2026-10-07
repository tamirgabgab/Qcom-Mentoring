//------------------------------------------------------------------------------
// reg_access_test.sv -- reg_access_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_access_test (Lab 11C): front-door / backdoor access checks on one RW
// register (ctrl_reg) and one RO register (addr0_cnt_reg).
//
// Writing an RO register through the front door produces a real HBUS write
// cycle, which the DUT ignores; the model's mirror is not updated either
// because the field policy is RO.
//------------------------------------------------------------------------------
class reg_access_test extends base_test;

  // Convenience handle to the register block (path from the topology report)
  yapp_regs_c regs;

  `uvm_component_utils(reg_access_test)

  extern function new(string name, uvm_component parent);
  extern function void configure_sequences();

  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // The stimulus of this test; derived tests replace it
  extern // The stimulus of this test; derived tests replace it
  virtual task access_checks();

  // RW: front-door write -> peek, poke -> front-door read
  extern task check_rw_register(uvm_reg rg, uvm_reg_data_t wr_val, uvm_reg_data_t poke_val);

  // RO: poke -> front-door read, front-door write (ignored) -> peek unchanged
  extern task check_ro_register(uvm_reg rg, uvm_reg_data_t poke_val, uvm_reg_data_t wr_val);

endclass : reg_access_test

//------------------------------------------------------------------------------
// reg_access_test -- method implementations
//------------------------------------------------------------------------------

function reg_access_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void reg_access_test::configure_sequences();
  set_clock_and_channel_sequences();
endfunction : configure_sequences

function void reg_access_test::connect_phase(uvm_phase phase);
  regs = tb.yapp_rm.router_yapp_regs;
endfunction : connect_phase

task reg_access_test::run_phase(uvm_phase phase);
  super.run_phase(phase);                   // drain time
  phase.raise_objection(this);
  access_checks();
  phase.drop_objection(this);
endtask : run_phase

task reg_access_test::access_checks();
  check_rw_register(regs.ctrl_reg,      8'h25, 8'h1a);
  check_ro_register(regs.addr0_cnt_reg, 8'h5a, 8'h33);
endtask : access_checks

task reg_access_test::check_rw_register(uvm_reg rg, uvm_reg_data_t wr_val, uvm_reg_data_t poke_val);
  uvm_status_e   status;
  uvm_reg_data_t val;
  `uvm_info("REG_ACCESS", $sformatf("--- RW register %s ---", rg.get_name()), UVM_NONE)

  rg.write(status, wr_val);
  `uvm_info("REG_ACCESS", $sformatf("front-door write 0x%02h", wr_val), UVM_NONE)
  rg.peek(status, val);
  `uvm_info("REG_ACCESS", $sformatf("peek            0x%02h", val), UVM_NONE)
  if (val != wr_val)
    `uvm_error("REG_ACCESS", $sformatf("%s: peek returned 0x%02h, expected 0x%02h", rg.get_name(), val, wr_val))

  rg.poke(status, poke_val);
  `uvm_info("REG_ACCESS", $sformatf("poke            0x%02h", poke_val), UVM_NONE)
  rg.read(status, val);
  `uvm_info("REG_ACCESS", $sformatf("front-door read 0x%02h", val), UVM_NONE)
  if (val != poke_val)
    `uvm_error("REG_ACCESS", $sformatf("%s: read returned 0x%02h, expected 0x%02h", rg.get_name(), val, poke_val))
endtask : check_rw_register

task reg_access_test::check_ro_register(uvm_reg rg, uvm_reg_data_t poke_val, uvm_reg_data_t wr_val);
  uvm_status_e   status;
  uvm_reg_data_t val;
  `uvm_info("REG_ACCESS", $sformatf("--- RO register %s ---", rg.get_name()), UVM_NONE)

  rg.poke(status, poke_val);
  `uvm_info("REG_ACCESS", $sformatf("poke            0x%02h", poke_val), UVM_NONE)
  rg.read(status, val);
  `uvm_info("REG_ACCESS", $sformatf("front-door read 0x%02h", val), UVM_NONE)
  if (val != poke_val)
    `uvm_error("REG_ACCESS", $sformatf("%s: read returned 0x%02h, expected 0x%02h", rg.get_name(), val, poke_val))

  rg.write(status, wr_val);
  `uvm_info("REG_ACCESS", $sformatf("front-door write 0x%02h (RO: must be ignored)", wr_val), UVM_NONE)
  rg.peek(status, val);
  `uvm_info("REG_ACCESS", $sformatf("peek            0x%02h", val), UVM_NONE)
  if (val != poke_val)
    `uvm_error("REG_ACCESS", $sformatf("%s: RO register changed to 0x%02h after a write", rg.get_name(), val))
endtask : check_ro_register
