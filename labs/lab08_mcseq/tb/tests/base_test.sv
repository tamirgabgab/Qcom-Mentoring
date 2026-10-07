//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 8: system-level test))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// base_test
//------------------------------------------------------------------------------
class base_test extends uvm_test;

  router_tb tb;

  `uvm_component_utils(base_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern virtual function void configure_sequences();
  extern function void set_clock_and_channel_sequences();

  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern function void check_phase(uvm_phase phase);

endclass : base_test

//------------------------------------------------------------------------------
// base_test -- method implementations
//------------------------------------------------------------------------------

function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the test", UVM_HIGH)
  uvm_config_int::set(this, "*", "recording_detail", 1);
  configure_sequences();
  tb = router_tb::type_id::create("tb", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void base_test::configure_sequences();
  // nothing: derived tests decide what runs
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void base_test::set_clock_and_channel_sequences();
  uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                          "default_sequence", clk10_rst5_seq::get_type());
  uvm_config_wrapper::set(this, "tb.chan*.rx_agent.sequencer.run_phase",
                          "default_sequence", channel_rx_resp_seq::get_type());
endfunction : set_clock_and_channel_sequences

//------------------------------------------------------------------------------
function void base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
task base_test::run_phase(uvm_phase phase);
  uvm_objection obj = phase.get_objection();
  obj.set_drain_time(this, 200ns);
endtask : run_phase

//------------------------------------------------------------------------------
function void base_test::check_phase(uvm_phase phase);
  check_config_usage();
endfunction : check_phase
