//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 10: connect to the module
// UVC's exports instead of reaching into it)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env            yapp;
  channel_env         chan0;
  channel_env         chan1;
  channel_env         chan2;
  hbus_env            hbus;
  clock_and_reset_env clk_rst;
  router_mcsequencer  mcseqr;
  router_module_env   router_module;

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
  uvm_config_int::set(this, "hbus",  "num_slaves",  0);

  yapp          = yapp_env::type_id::create("yapp", this);
  chan0         = channel_env::type_id::create("chan0", this);
  chan1         = channel_env::type_id::create("chan1", this);
  chan2         = channel_env::type_id::create("chan2", this);
  hbus          = hbus_env::type_id::create("hbus", this);
  clk_rst       = clock_and_reset_env::type_id::create("clk_rst", this);
  mcseqr        = router_mcsequencer::type_id::create("mcseqr", this);
  router_module = router_module_env::type_id::create("router_module", this);
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::connect_phase(uvm_phase phase);
  mcseqr.hbus_seqr = hbus.masters[0].sequencer;
  mcseqr.yapp_seqr = yapp.agent.sequencer;

  // TLM: monitor ports -> module UVC exports (its internals are private)
  yapp.agent.monitor.item_collected_port.connect(router_module.yapp_export);
  hbus.monitor.item_collected_port.connect(router_module.hbus_export);
  chan0.rx_agent.monitor.item_collected_port.connect(router_module.chan0_export);
  chan1.rx_agent.monitor.item_collected_port.connect(router_module.chan1_export);
  chan2.rx_agent.monitor.item_collected_port.connect(router_module.chan2_export);
endfunction : connect_phase
