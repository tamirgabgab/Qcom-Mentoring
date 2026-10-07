//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 7: multi-UVC tests)
//
// Sequencer paths (from the base_test topology report):
//   tb.yapp.agent.sequencer
//   tb.chan0.rx_agent.sequencer   (chan1, chan2 likewise -> "tb.chan*.rx_agent.sequencer")
//   tb.hbus.masters[0].sequencer
//   tb.clk_rst.agent.sequencer
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test: builds the testbench, prints the topology, no default sequences.
// Without a clock sequence nothing runs, which is exactly what you want when
// checking the topology report.
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

  // Helpers shared by the tests below
  function void set_clock_and_channel_sequences();
    uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                            "default_sequence", clk10_rst5_seq::get_type());
    // one wildcard statement for all three channels
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
// simple_test: short packets to channels 0, 1, 2; channels respond; clock and
// reset from the UVC; the HBUS stays idle (router uses its reset values).
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
    // no default sequence for the HBUS UVC
  endfunction : configure_sequences

endclass : simple_test


//------------------------------------------------------------------------------
// test_uvc_integration (optional): 88 packets to all four addresses with
// lengths 1..22 and 20% bad parity, while the HBUS sets maxpktsize = 20 and
// enables the router. Check: routing, `error` on bad parity, drops for
// length > 20 and for address 3 ("ROUTER DROPS PACKET" in the log).
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
