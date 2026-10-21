// START POINT of Lab 11B: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab11b_rm_integ/tb/router_tb.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 11B: + register model)
//
//   yapp_rm  : the register model (yapp_router_regs_t)
//   reg2hbus : adapter translating register operations to HBUS transactions
//
// Front-door accesses go  model -> default_map -> reg2hbus -> HBUS sequencer.
// Backdoor accesses use the HDL paths rooted at "hw_top.dut.u_regs" (the register block of the router).
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

  yapp_router_regs_t  m_yapp_rm;
  hbus_reg_adapter    m_reg2hbus;

  `uvm_component_utils(router_tb)

  // The fields are printed by do_print() below:
  // no uvm_field_* automation.
  extern virtual function void do_print(uvm_printer printer);
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
  // Register model: build, lock, backdoor root, implicit prediction
  // TODO (Lab 11B): write router_tb::build_phase
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::connect_phase(uvm_phase phase);
  // Front door: the model's map drives the HBUS master sequencer via the adapter
  // TODO (Lab 11B): write router_tb::connect_phase
endfunction : connect_phase

//------------------------------------------------------------------------------
function void router_tb::do_print(uvm_printer printer);
  super.do_print(printer);
  // TODO (Lab 11B): write router_tb::do_print
endfunction : do_print
