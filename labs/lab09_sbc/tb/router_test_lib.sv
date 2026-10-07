//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 9C: export connections)
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
// simple_test (Lab 7)
//------------------------------------------------------------------------------
class simple_test extends base_test;

  `uvm_component_utils(simple_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_012_seq::get_type());
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

endclass : simple_test


//------------------------------------------------------------------------------
// test_uvc_integration (Lab 7, optional)
//------------------------------------------------------------------------------
class test_uvc_integration extends base_test;

  `uvm_component_utils(test_uvc_integration)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_88_packets_seq::get_type());
    uvm_config_wrapper::set(this, "tb.hbus.masters[0].sequencer.run_phase",
                            "default_sequence", hbus_small_packet_seq::get_type());
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

endclass : test_uvc_integration


//------------------------------------------------------------------------------
// router_simple_mcseq_test (Lab 8): short packets only -> every packet comes
// out of the router -> the scoreboard must report 12 matched, 0 mismatched.
//------------------------------------------------------------------------------
class router_simple_mcseq_test extends base_test;

  `uvm_component_utils(router_simple_mcseq_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    set_clock_and_channel_sequences();
    uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                            "default_sequence", router_simple_mcseq::get_type());
  endfunction : configure_sequences

endclass : router_simple_mcseq_test


//------------------------------------------------------------------------------
// scoreboard_drop_test (Lab 9A step 7): same multichannel sequence WITHOUT the
// short-packet override. The first six packets may be longer than the
// maxpktsize of 20 set by hbus_small_packet_seq, so the router drops them:
//   * "ROUTER DROPS PACKET" in the log,
//   * the next packet on that channel mismatches (uvm_error from the compare),
//   * packets are left in the scoreboard queues at the end.
// Check that received == matched + mismatched + left in queues.
//------------------------------------------------------------------------------
class scoreboard_drop_test extends router_simple_mcseq_test;

  `uvm_component_utils(scoreboard_drop_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    // Skip router_simple_mcseq_test::build_phase -> no type override
    base_test::build_phase(phase);
  endfunction : build_phase

endclass : scoreboard_drop_test
