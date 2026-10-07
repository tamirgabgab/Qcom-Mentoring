//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 10: functional coverage)
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
// router_simple_mcseq_test (Lab 8): short packets only -> look at the holes
// in the coverage report (no MEDIUM/LARGE/MAX lengths, no address 3).
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
// test_uvc_integration (Lab 7): 88 packets, lengths 1..22, all addresses,
// 20% bad parity -- covers addresses but not the long length bins.
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
// coverage_test (Lab 10 step 10): stimulus written to close the model --
// every length bin to every address, with and without parity errors.
// Full-size packets (no override); maxpktsize keeps its reset value 63.
//------------------------------------------------------------------------------
class coverage_test extends base_test;

  `uvm_component_utils(coverage_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_coverage_seq::get_type());
    set_clock_and_channel_sequences();
  endfunction : configure_sequences

endclass : coverage_test
