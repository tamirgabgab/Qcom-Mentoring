//------------------------------------------------------------------------------
// router_test_lib.sv -- test library (Lab 11B: built-in register sequences)
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
// router_simple_mcseq_test (Lab 8): still works with the model in place
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
// uvm_reset_test: the built-in uvm_reg_hw_reset_seq resets the model, reads
// every register through the HBUS and compares with the reset values.
// Register sequences are started with a null sequencer: the model's map
// knows which sequencer to use (set_sequencer in router_tb).
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
    super.run_phase(phase);                       // drain time
    phase.raise_objection(this);
    reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
    reset_seq.model = tb.yapp_rm;                 // the block to test
    reset_seq.start(null);
    phase.drop_objection(this);
  endtask : run_phase

endclass : uvm_reset_test


//------------------------------------------------------------------------------
// uvm_mem_walk_test (optional): walking-ones memory test on every RW memory
// (only yapp_mem, 0x1100..0x11ff). Expect 511 HBUS writes and 255 reads.
// Re-run with  xrun -f run.f -define INJECT_ERROR  to see the error caught.
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
