//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 10: connect to the module
// UVC's exports instead of reaching into it)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env            m_yapp;
  channel_env         m_chan0;
  channel_env         m_chan1;
  channel_env         m_chan2;
  hbus_env            m_hbus;
  clock_and_reset_env m_clk_rst;
  router_mcsequencer  m_mcseqr;
  router_module_env   m_router_module;

  `uvm_component_utils(router_tb)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  extern function void connect_phase(uvm_phase phase);

endclass : router_tb

//------------------------------------------------------------------------------
// router_tb -- method implementations
//------------------------------------------------------------------------------

function router_tb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)

  uvm_config_int::set(this, "chan0", "channel_id", 0);
  uvm_config_int::set(this, "chan1", "channel_id", 1);
  uvm_config_int::set(this, "chan2", "channel_id", 2);
  uvm_config_int::set(this, "hbus",  "num_masters", 1);

  m_yapp          = yapp_env::type_id::create("yapp", this);
  m_chan0         = channel_env::type_id::create("chan0", this);
  m_chan1         = channel_env::type_id::create("chan1", this);
  m_chan2         = channel_env::type_id::create("chan2", this);
  m_hbus          = hbus_env::type_id::create("hbus", this);
  m_clk_rst       = clock_and_reset_env::type_id::create("clk_rst", this);
  m_mcseqr        = router_mcsequencer::type_id::create("mcseqr", this);
  m_router_module = router_module_env::type_id::create("router_module", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::connect_phase(uvm_phase phase);
  m_mcseqr.m_hbus_seqr = m_hbus.m_masters[0].m_sequencer;
  m_mcseqr.m_yapp_seqr = m_yapp.m_agent.m_sequencer;

  // TLM: monitor ports -> module UVC exports (its internals are private)
  m_yapp.m_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_yapp_export);
  m_hbus.m_monitor.m_item_collected_port.connect(m_router_module.m_hbus_export);
  m_chan0.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan0_export);
  m_chan1.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan1_export);
  m_chan2.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan2_export);
endfunction : connect_phase
