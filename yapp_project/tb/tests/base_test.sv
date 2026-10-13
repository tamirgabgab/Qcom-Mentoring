//------------------------------------------------------------------------------
// base_test.sv -- base_test (test library (Lab 11C: user-defined register stimulus))
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

  // Log structure (scripts/sim_report.py reads these [TEST] lines):
  // a banner with the test name and the seed, one line per stage of the
  // test, and a closing line with the verdict.
  extern function void start_of_simulation_phase(uvm_phase phase);
  extern function void stage(string what);
  extern function void final_phase(uvm_phase phase);
  extern function string seed_text();

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
  // every packet the reference model forwarded must have come out by the end
  uvm_config_db #(bit)::set(this, "tb.router_module.scoreboard", "check_empty", 1'b1);
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

//------------------------------------------------------------------------------
function string base_test::seed_text();
  int seed;
  // scripts/sim.py passes +SEED=<n>; with xrun the seed is +SVSEED=<n>
  if ($value$plusargs("SEED=%d", seed) || $value$plusargs("SVSEED=%d", seed)) begin
    return $sformatf("%0d", seed);
  end
  return "?";
endfunction : seed_text

//------------------------------------------------------------------------------
function void base_test::start_of_simulation_phase(uvm_phase phase);
  `uvm_info("TEST", $sformatf("=== %s  seed %s ===", get_type_name(), seed_text()), UVM_NONE)
endfunction : start_of_simulation_phase

//------------------------------------------------------------------------------
function void base_test::stage(string what);
  `uvm_info("TEST", {"STAGE: ", what}, UVM_LOW)
endfunction : stage

//------------------------------------------------------------------------------
function void base_test::final_phase(uvm_phase phase);
  uvm_report_server svr;
  int errors;
  int fatals;
  svr    = uvm_report_server::get_server();
  errors = svr.get_severity_count(UVM_ERROR);
  fatals = svr.get_severity_count(UVM_FATAL);
  `uvm_info("TEST", $sformatf("=== %s  seed %s: %s (%0d UVM_ERROR, %0d UVM_FATAL) ===", get_type_name(),
                              seed_text(), (errors == 0 && fatals == 0) ? "PASSED" : "FAILED", errors, fatals),
            UVM_NONE)
endfunction : final_phase
