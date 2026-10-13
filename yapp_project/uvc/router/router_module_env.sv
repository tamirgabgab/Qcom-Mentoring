//------------------------------------------------------------------------------
// router_module_env.sv -- the router MODULE UVC with exports (Lab 9C)
//
// Every external connection point is now an analysis EXPORT on the env, so
// the testbench never has to know where the imps live inside the module UVC:
//
//   yapp_export ──► reference.yapp_in       chan0_export ──► scoreboard.chan0_in
//   hbus_export ──► reference.hbus_in       chan1_export ──► scoreboard.chan1_in
//                                           chan2_export ──► scoreboard.chan2_in
//   reference.yapp_valid_out ──► scoreboard.yapp_in   (internal, unchanged)
//   reference.decision_out   ──► coverage             (router_coverage)
//   hbus_export              ──► hbus_addr_cov, hbus_bits_cov, hbus_data_cov,
//                                hbus_counter_cov   (the HBUS coverage collectors)
//------------------------------------------------------------------------------
class router_module_env extends uvm_env;

  router_reference  reference;
  router_scoreboard scoreboard;
  router_coverage   coverage;
  // HBUS coverage: one collector per covergroup
  router_hbus_addr_coverage    hbus_addr_cov;
  router_hbus_bits_coverage    hbus_bits_cov;
  router_hbus_data_coverage    hbus_data_cov;
  router_hbus_counter_coverage hbus_counter_cov;

  // Top-level connection points
  uvm_analysis_export #(yapp_packet)      yapp_export;
  uvm_analysis_export #(hbus_transaction) hbus_export;
  uvm_analysis_export #(channel_packet)   chan0_export;
  uvm_analysis_export #(channel_packet)   chan1_export;
  uvm_analysis_export #(channel_packet)   chan2_export;

  `uvm_component_utils(router_module_env)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void connect_phase(uvm_phase phase);

endclass : router_module_env

//------------------------------------------------------------------------------
// router_module_env -- method implementations
//------------------------------------------------------------------------------

function router_module_env::new(string name, uvm_component parent);
  super.new(name, parent);
  yapp_export  = new("yapp_export",  this);
  hbus_export  = new("hbus_export",  this);
  chan0_export = new("chan0_export", this);
  chan1_export = new("chan1_export", this);
  chan2_export = new("chan2_export", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_module_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  reference  = router_reference::type_id::create("reference", this);
  scoreboard = router_scoreboard::type_id::create("scoreboard", this);
  coverage   = router_coverage::type_id::create("coverage", this);
  hbus_addr_cov    = router_hbus_addr_coverage::type_id::create("hbus_addr_cov", this);
  hbus_bits_cov    = router_hbus_bits_coverage::type_id::create("hbus_bits_cov", this);
  hbus_data_cov    = router_hbus_data_coverage::type_id::create("hbus_data_cov", this);
  hbus_counter_cov = router_hbus_counter_coverage::type_id::create("hbus_counter_cov", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_module_env::connect_phase(uvm_phase phase);
  // exports -> internal imps
  yapp_export.connect(reference.yapp_in);
  hbus_export.connect(reference.hbus_in);
  chan0_export.connect(scoreboard.chan0_in);
  chan1_export.connect(scoreboard.chan1_in);
  chan2_export.connect(scoreboard.chan2_in);
  // internal link stays as in Lab 9B
  reference.yapp_valid_out.connect(scoreboard.yapp_in);
  reference.decision_out.connect(coverage.analysis_export);
  // the HBUS coverage collectors
  hbus_export.connect(hbus_addr_cov.analysis_export);
  hbus_export.connect(hbus_bits_cov.analysis_export);
  hbus_export.connect(hbus_data_cov.analysis_export);
  hbus_export.connect(hbus_counter_cov.analysis_export);
endfunction : connect_phase
