//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 7: all four UVCs)
//
//   yapp     : YAPP input UVC (built in Labs 1-6, now in yapp_project/uvc/yapp)
//   chan0..2 : one Channel UVC per router output, configured with channel_id
//   hbus     : HBUS UVC, one master agent, no slave (the DUT is the slave)
//   clk_rst  : Clock & Reset UVC, needs no configuration
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env            yapp;
  channel_env         chan0;
  channel_env         chan1;
  channel_env         chan2;
  hbus_env            hbus;
  clock_and_reset_env clk_rst;

  `uvm_component_utils(router_tb)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : router_tb

//------------------------------------------------------------------------------
// router_tb -- method implementations
//------------------------------------------------------------------------------

function router_tb::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)

  // Configuration BEFORE construction
  uvm_config_int::set(this, "chan0", "channel_id", 0);
  uvm_config_int::set(this, "chan1", "channel_id", 1);
  uvm_config_int::set(this, "chan2", "channel_id", 2);
  uvm_config_int::set(this, "hbus",  "num_masters", 1);
  uvm_config_int::set(this, "hbus",  "num_slaves",  0);

  yapp    = yapp_env::type_id::create("yapp", this);
  chan0   = channel_env::type_id::create("chan0", this);
  chan1   = channel_env::type_id::create("chan1", this);
  chan2   = channel_env::type_id::create("chan2", this);
  hbus    = hbus_env::type_id::create("hbus", this);
  clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);
endfunction : build_phase
