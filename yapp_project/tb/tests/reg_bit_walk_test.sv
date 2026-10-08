//------------------------------------------------------------------------------
// reg_bit_walk_test.sv -- reg_bit_walk_test (test plan: REG-02, REG-03, REG-04)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_bit_walk_test: every bit of every register does what its policy says.
//   * RW registers (from the model, by introspection): walking one, walking
//     zero, 0x00, 0xff, 0xaa, 0x55 -- front-door write, front-door read and
//     backdoor peek must all agree, bit by bit
//   * RO registers: poke, read back, write (ignored), peek unchanged -- for
//     the values 0x00 and 0xff
// Reserved bits (ctrl_reg[7:6], en_reg[3]) are declared RW in the router and
// are therefore expected to hold what was written.
//------------------------------------------------------------------------------
class reg_bit_walk_test extends reg_access_test;

  `uvm_component_utils(reg_bit_walk_test)

  extern function new(string name, uvm_component parent);
  extern virtual task access_checks();

  // Write `pattern` through the front door; read and peek must return it
  extern task check_pattern(uvm_reg rg, uvm_reg_data_t pattern);

endclass : reg_bit_walk_test

//------------------------------------------------------------------------------
// reg_bit_walk_test -- method implementations
//------------------------------------------------------------------------------

function reg_bit_walk_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
task reg_bit_walk_test::access_checks();
  uvm_status_e status;
  bit [7:0]    pattern;
  uvm_reg      all_q[$];
  uvm_reg      rw_q[$];
  uvm_reg      ro_q[$];
  tb.yapp_rm.get_registers(all_q);
  rw_q = all_q.find(r) with (r.get_rights() == "RW");
  ro_q = all_q.find(r) with (r.get_rights() == "RO");

  foreach (rw_q[i]) begin
    `uvm_info("REG_WALK", $sformatf("--- RW register %s: walking ones and zeros ---", rw_q[i].get_name()), UVM_NONE)
    for (int b = 0; b < 8; b++) begin
      pattern = 8'h01 << b;
      check_pattern(rw_q[i], pattern);
    end
    for (int b = 0; b < 8; b++) begin
      pattern = ~(8'h01 << b);
      check_pattern(rw_q[i], pattern);
    end
    check_pattern(rw_q[i], 8'h00);
    check_pattern(rw_q[i], 8'hff);
    check_pattern(rw_q[i], 8'haa);
    check_pattern(rw_q[i], 8'h55);
  end
  foreach (ro_q[i]) begin
    check_ro_register(ro_q[i], 8'h00, 8'hff);
    check_ro_register(ro_q[i], 8'hff, 8'h00);
  end

  // leave the router as reset left it
  regs.ctrl_reg.write(status, 8'h3f);
  regs.en_reg.write(status, 8'h01);
endtask : access_checks

//------------------------------------------------------------------------------
task reg_bit_walk_test::check_pattern(uvm_reg rg, uvm_reg_data_t pattern);
  uvm_status_e   status;
  uvm_reg_data_t rd_val;
  uvm_reg_data_t peek_val;
  rg.write(status, pattern);
  rg.read(status, rd_val);
  rg.peek(status, peek_val);
  if (rd_val != pattern || peek_val != pattern) begin
    `uvm_error("REG_WALK", $sformatf("%s: wrote 0x%02h, read 0x%02h, peek 0x%02h",
                                     rg.get_name(), pattern, rd_val, peek_val))
  end else begin
    `uvm_info("REG_WALK", $sformatf("%s: 0x%02h written, read and peeked", rg.get_name(), pattern), UVM_HIGH)
  end
endtask : check_pattern
