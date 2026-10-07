//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 5: sequence tests)
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
    uvm_config_int::set(this, "*", "recording_detail", 1);   // transaction recording
    configure_sequences();                                   // before the tb is built!
    tb = router_tb::type_id::create("tb", this);
  endfunction : build_phase

  // Default sequences for the sequencers in the testbench
  virtual function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_5_packets::get_type());
  endfunction : configure_sequences

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  function void check_phase(uvm_phase phase);
    check_config_usage();      // lists configuration settings that were never read
  endfunction : check_phase

endclass : base_test


//------------------------------------------------------------------------------
// short_packet_test (Lab 4)
//------------------------------------------------------------------------------
class short_packet_test extends base_test;

  `uvm_component_utils(short_packet_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : short_packet_test


//------------------------------------------------------------------------------
// set_config_test (Lab 4)
//------------------------------------------------------------------------------
class set_config_test extends base_test;

  `uvm_component_utils(set_config_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yapp.agent", "is_active", UVM_PASSIVE);
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    // intentionally empty: there is no sequencer to configure
  endfunction : configure_sequences

endclass : set_config_test


//------------------------------------------------------------------------------
// incr_payload_test (Lab 5): one short packet with an incrementing payload.
// Run with +UVM_VERBOSITY=UVM_FULL to see the default sequence being started.
//------------------------------------------------------------------------------
class incr_payload_test extends base_test;

  `uvm_component_utils(incr_payload_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_incr_payload_seq::get_type());
  endfunction : configure_sequences

endclass : incr_payload_test


//------------------------------------------------------------------------------
// exhaustive_seq_test (Lab 5): runs every sequence of the library with short
// packets. With the original short_yapp_packet (addr != 2) this test produced
// randomization failures -- see the Lab 5 notes.
//------------------------------------------------------------------------------
class exhaustive_seq_test extends base_test;

  `uvm_component_utils(exhaustive_seq_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    super.build_phase(phase);
  endfunction : build_phase

  function void configure_sequences();
    uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
                            "default_sequence", yapp_exhaustive_seq::get_type());
  endfunction : configure_sequences

endclass : exhaustive_seq_test
