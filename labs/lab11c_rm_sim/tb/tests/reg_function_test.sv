//------------------------------------------------------------------------------
// reg_function_test.sv -- reg_function_test (test library (Lab 11C: user-defined register stimulus))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// reg_function_test (Lab 11C): do the enable bits and counters behave?
//   1. en_reg = router_en only; run yapp_012_seq; address counters stay 0
//   2. en_reg = 0xff; run yapp_012_seq twice; addr0/1/2 == 2, addr3 == 0,
//      parity_err_cnt == bad-parity packets seen by the monitor, oversized == 0
//------------------------------------------------------------------------------
class reg_function_test extends reg_access_test;

  yapp_tx_sequencer yapp_seqr;
  yapp_012_seq      seq;

  `uvm_component_utils(reg_function_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = yapp_012_seq::type_id::create("seq");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    yapp_seqr = tb.yapp.agent.sequencer;      // hierarchical path, no config
  endfunction : connect_phase

  virtual task access_checks();
    uvm_status_e   status;
    uvm_reg_data_t val;
    int bad_before, bad_after;

    // 1. router enabled, every counter disabled
    regs.en_reg.write(status, 8'h01);
    regs.en_reg.read(status, val);
    `uvm_info("REG_FUNC", $sformatf("en_reg reads 0x%02h", val), UVM_NONE)
    if (val != 8'h01)
      `uvm_error("REG_FUNC", $sformatf("en_reg reads 0x%02h, expected 0x01", val))

    seq.start(yapp_seqr);                     // 3 packets, counters off
    check_counter(regs.addr0_cnt_reg, 0);
    check_counter(regs.addr1_cnt_reg, 0);
    check_counter(regs.addr2_cnt_reg, 0);
    check_counter(regs.addr3_cnt_reg, 0);

    // 2. every counter enabled
    bad_before = tb.yapp.agent.monitor.num_bad_parity;
    regs.en_reg.write(status, 8'hff);
    seq.start(yapp_seqr);
    seq.start(yapp_seqr);                     // 6 packets, 2 per address
    bad_after = tb.yapp.agent.monitor.num_bad_parity;

    check_counter(regs.addr0_cnt_reg, 2);
    check_counter(regs.addr1_cnt_reg, 2);
    check_counter(regs.addr2_cnt_reg, 2);
    check_counter(regs.addr3_cnt_reg, 0);
    check_counter(regs.parity_err_cnt_reg, bad_after - bad_before);
    check_counter(regs.oversized_pkt_cnt_reg, 0);   // maxpktsize is 63 (reset)
  endtask : access_checks

  // Front-door read and compare
  virtual task check_counter(uvm_reg rg, uvm_reg_data_t expected);
    uvm_status_e   status;
    uvm_reg_data_t val;
    rg.read(status, val);
    if (val != expected)
      `uvm_error("REG_FUNC", $sformatf("%s reads %0d, expected %0d", rg.get_name(), val, expected))
    else
      `uvm_info("REG_FUNC", $sformatf("%s reads %0d as expected", rg.get_name(), val), UVM_NONE)
  endtask : check_counter

endclass : reg_function_test
