//------------------------------------------------------------------------------
// hbus_sweep_test.sv -- hbus_sweep_test (test plan: COV-04..07, and the HBUS
// items it checks again: REG-05/06, MEM-01/02, CNT-06)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// hbus_sweep_test: every address of the router read and written over the
// HBUS, every bit of ctrl_reg / en_reg written 0 and 1, data patterns in
// yapp_mem, every counter read at 0, in between and at 255
// (router_hbus_sweep_mcseq). Every read is checked by router_reference
// (check_reads = 1), so a write to a read-only or unmapped address that
// changed something fails the test. At the end the four HBUS coverage
// collectors must be at 100 %.
// About 6000 HBUS accesses and 1000 packets: the log keeps one line per access
// (HBUS monitor) and per packet (YAPP monitor); the sequencers and drivers,
// which would repeat them, are quiet (UVM_NONE).
//------------------------------------------------------------------------------
class hbus_sweep_test extends base_test;

  router_hbus_sweep_mcseq m_sweep;

  `uvm_component_utils(hbus_sweep_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void configure_sequences();
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // A coverage collector's percentage must be 100
  extern function void check_full(string what, real pct);

endclass : hbus_sweep_test

//------------------------------------------------------------------------------
// hbus_sweep_test -- method implementations
//------------------------------------------------------------------------------

function hbus_sweep_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void hbus_sweep_test::build_phase(uvm_phase phase);
  uvm_config_db #(bit)::set(this, "tb.router_module.reference", "check_reads", 1'b1);
  super.build_phase(phase);
endfunction : build_phase

//------------------------------------------------------------------------------
function void hbus_sweep_test::configure_sequences();
  set_clock_and_channel_sequences();
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void hbus_sweep_test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  m_tb.m_hbus.m_masters[0].m_sequencer.set_report_verbosity_level(UVM_NONE);
  m_tb.m_hbus.m_masters[0].m_driver.set_report_verbosity_level(UVM_NONE);
  m_tb.m_yapp.m_agent.m_sequencer.set_report_verbosity_level(UVM_NONE);
  m_tb.m_yapp.m_agent.m_driver.set_report_verbosity_level(UVM_NONE);
endfunction : end_of_elaboration_phase

//------------------------------------------------------------------------------
task hbus_sweep_test::run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  m_sweep = router_hbus_sweep_mcseq::type_id::create("sweep");
  m_sweep.start(m_tb.m_mcseqr);
  repeat (50) begin
    @(posedge m_tb.m_yapp.m_agent.m_monitor.m_vif.clock);   // the first packet leaves its channel
  end
  stage("9. the four HBUS coverage collectors are at 100 % and every read matched the model");
  check_full("HBUS address map", m_tb.m_router_module.m_hbus_addr_cov.hbus_addr_cg.get_inst_coverage());
  check_full("ctrl_reg / en_reg bits", m_tb.m_router_module.m_hbus_bits_cov.hbus_bits_cg.get_inst_coverage());
  check_full("yapp_mem data patterns", m_tb.m_router_module.m_hbus_data_cov.hbus_data_cg.get_inst_coverage());
  check_full("counter values", m_tb.m_router_module.m_hbus_counter_cov.hbus_counter_cg.get_inst_coverage());
  stage($sformatf("done: %0d HBUS reads checked against the model, %0d mismatches, %0d memory bytes never written",
                  m_tb.m_router_module.m_reference.m_reads_checked, m_tb.m_router_module.m_reference.m_read_mismatches,
                  m_tb.m_router_module.m_reference.m_reads_unknown));
  phase.drop_objection(this);
endtask : run_phase

//------------------------------------------------------------------------------
function void hbus_sweep_test::check_full(string what, real pct);
  if (pct < 100.0) begin
    `uvm_error("HBUS_COV", $sformatf("%s coverage %.1f%%, expected 100%%", what, pct))
  end else begin
    `uvm_info("HBUS_COV", $sformatf("%s coverage 100%%", what), UVM_NONE)
  end
endfunction : check_full
