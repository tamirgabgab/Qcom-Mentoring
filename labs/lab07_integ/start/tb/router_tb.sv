// START POINT of Lab 7: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab07_integ/tb/router_tb.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 7: all four UVCs)
//
//   yapp     : YAPP input UVC (built in Labs 1-6, now in yapp_project/uvc/yapp)
//   chan0..2 : one Channel UVC per router output, configured with channel_id
//   hbus     : HBUS UVC, one master agent, no slave (the DUT is the slave)
//   clk_rst  : Clock & Reset UVC, needs no configuration
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env            m_yapp;
  channel_env         m_chan0;
  channel_env         m_chan1;
  channel_env         m_chan2;
  hbus_env            m_hbus;
  clock_and_reset_env m_clk_rst;

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

//------------------------------------------------------------------------------
function void router_tb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Configuration BEFORE construction
  // TODO (Lab 7): write router_tb::build_phase
endfunction : build_phase
