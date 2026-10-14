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
//------------------------------------------------------------------------------
class router_module_env extends uvm_env;

  router_reference  m_reference;
  router_scoreboard m_scoreboard;

  // Top-level connection points
  uvm_analysis_export #(yapp_packet)      m_yapp_export;
  uvm_analysis_export #(hbus_transaction) m_hbus_export;
  uvm_analysis_export #(channel_packet)   m_chan0_export;
  uvm_analysis_export #(channel_packet)   m_chan1_export;
  uvm_analysis_export #(channel_packet)   m_chan2_export;

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
  m_yapp_export  = new("yapp_export",  this);
  m_hbus_export  = new("hbus_export",  this);
  m_chan0_export = new("chan0_export", this);
  m_chan1_export = new("chan1_export", this);
  m_chan2_export = new("chan2_export", this);
endfunction : new

//------------------------------------------------------------------------------
function void router_module_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  m_reference  = router_reference::type_id::create("reference", this);
  m_scoreboard = router_scoreboard::type_id::create("scoreboard", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_module_env::connect_phase(uvm_phase phase);
  // exports -> internal imps
  m_yapp_export.connect(m_reference.m_yapp_in);
  m_hbus_export.connect(m_reference.m_hbus_in);
  m_chan0_export.connect(m_scoreboard.m_chan0_in);
  m_chan1_export.connect(m_scoreboard.m_chan1_in);
  m_chan2_export.connect(m_scoreboard.m_chan2_in);
  // internal link stays as in Lab 9B
  m_reference.m_yapp_valid_out.connect(m_scoreboard.m_yapp_in);
endfunction : connect_phase
