// START POINT of Lab 8: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab08_mcseq/tb/router_tb.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 8: + multichannel sequencer)
//------------------------------------------------------------------------------
class router_tb extends uvm_env;

  yapp_env            m_yapp;
  channel_env         m_chan0;
  channel_env         m_chan1;
  channel_env         m_chan2;
  hbus_env            m_hbus;
  clock_and_reset_env m_clk_rst;
  router_mcsequencer  m_mcseqr;

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
  // TODO (Lab 8): write router_tb::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::connect_phase(uvm_phase phase);
  // Hierarchical references, NOT configuration strings: no wildcards here
  // TODO (Lab 8): write router_tb::connect_phase
endfunction : connect_phase
