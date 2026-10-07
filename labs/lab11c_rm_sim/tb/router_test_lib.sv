//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 11C: user-defined register stimulus)
//
// Register access API used here (all on uvm_reg):
//   write(status, value)  front door through the HBUS   (bus traffic)
//   read (status, value)  front door through the HBUS
//   poke (status, value)  backdoor: deposit into the RTL variable (no bus cycle)
//   peek (status, value)  backdoor: read the RTL variable
//   predict(value)        set the mirrored value without touching the DUT
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb tb;

  `uvm_component_utils(base_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
    uvm_config_int::set(this, "*", "recording_detail", 1);
    configure_sequences();
    tb = router_tb::type_id::create("tb", this);
  endfunction : build_phase

  virtual function void configure_sequences();
    // nothing: derived tests decide what runs
  endfunction : configure_sequences

  function void set_clock_and_channel_sequences();
    uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                            "default_sequence", clk10_rst5_seq::get_type());
    uvm_config_wrapper::set(this, "tb.chan*.rx_agent.sequencer.run_phase",
                            "default_sequence", channel_rx_resp_seq::get_type());
  endfunction : set_clock_and_channel_sequences

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask : run_phase

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction : check_phase

endclass : base_test


//------------------------------------------------------------------------------
// uvm_reset_test (Lab 11B)
//------------------------------------------------------------------------------
class uvm_reset_test extends base_test;

  `uvm_component_utils(uvm_reset_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

  task run_phase(uvm_phase phase);
    uvm_reg_hw_reset_seq reset_seq;
    super.run_phase(phase);
    phase.raise_objection(this);
    reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);
    phase.drop_objection(this);
  endtask : run_phase

endclass : uvm_reset_test


//------------------------------------------------------------------------------
// uvm_mem_walk_test (Lab 11B, optional)
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

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

  function void connect_phase(uvm_phase phase);
    regs = tb.yapp_rm.router_yapp_regs;
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);                   // drain time
    phase.raise_objection(this);
    access_checks();
    phase.drop_objection(this);
  endtask : run_phase

  // The stimulus of this test; derived tests replace it
  virtual task access_checks();
    check_rw_register(regs.ctrl_reg,      8'h25, 8'h1a);
    check_ro_register(regs.addr0_cnt_reg, 8'h5a, 8'h33);
  endtask : access_checks

  // RW: front-door write -> peek, poke -> front-door read
  task check_rw_register(uvm_reg rg, uvm_reg_data_t wr_val, uvm_reg_data_t poke_val);
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

  // RO: poke -> front-door read, front-door write (ignored) -> peek unchanged
  task check_ro_register(uvm_reg rg, uvm_reg_data_t poke_val, uvm_reg_data_t wr_val);
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

endclass : reg_access_test


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


//------------------------------------------------------------------------------
// reg_function_check_test (Lab 11C, optional): automatic checking on read.
// With set_check_on_read(1) every read() compares the DUT value with the
// mirror. RO counters change without bus traffic, so the mirror must be
// loaded with predict() before each read.
//------------------------------------------------------------------------------
class reg_function_check_test extends reg_function_test;

  `uvm_component_utils(reg_function_check_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    tb.yapp_rm.default_map.set_check_on_read(1);
    super.run_phase(phase);
  endtask : run_phase

  // Load the expected value, then let read() do the comparison
  virtual task check_counter(uvm_reg rg, uvm_reg_data_t expected);
    uvm_status_e   status;
    uvm_reg_data_t val;
    void'(rg.predict(expected));
    rg.read(status, val);                     // mismatch -> UVM_ERROR from the map
    `uvm_info("REG_FUNC", $sformatf("%s reads %0d (checked against predicted %0d)",
                                    rg.get_name(), val, expected), UVM_NONE)
  endtask : check_counter

endclass : reg_function_check_test


//------------------------------------------------------------------------------
// reg_introspection_test (Lab 11C, optional): let the model tell us which
// registers are RW and which are RO, then run the access checks on all of them.
//------------------------------------------------------------------------------
class reg_introspection_test extends reg_access_test;

  `uvm_component_utils(reg_introspection_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual task access_checks();
    uvm_reg all_q[$];
    uvm_reg rw_q[$];
    uvm_reg ro_q[$];

    tb.yapp_rm.get_registers(all_q);          // every register in the model
    rw_q = all_q.find(r) with (r.get_rights() == "RW");
    ro_q = all_q.find(r) with (r.get_rights() == "RO");

    foreach (rw_q[i])
      `uvm_info("REG_INTRO", $sformatf("RW register: %s @ 0x%04h", rw_q[i].get_name(), rw_q[i].get_address()), UVM_NONE)
    foreach (ro_q[i])
      `uvm_info("REG_INTRO", $sformatf("RO register: %s @ 0x%04h", ro_q[i].get_name(), ro_q[i].get_address()), UVM_NONE)

    foreach (rw_q[i]) check_rw_register(rw_q[i], 8'h25, 8'h1a);
    foreach (ro_q[i]) check_ro_register(ro_q[i], 8'h5a, 8'h33);
  endtask : access_checks

endclass : reg_introspection_test
