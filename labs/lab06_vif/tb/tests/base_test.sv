//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 6: first tests against the DUT))
// Split out of router_test_lib.sv: one class per file.
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

  // Drain time: once the last objection is dropped, keep simulating for
  // 200 ns so packets still inside the router can come out.
  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask : run_phase

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction : check_phase

endclass : base_test
