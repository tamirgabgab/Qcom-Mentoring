//------------------------------------------------------------------------------
// router_tb.sv -- the testbench environment (Lab 11C)
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
  `uvm_info(get_type_name(), "Executing the build phase of the testbench", UVM_HIGH)

  uvm_config_int::set(this, "chan0", "channel_id", 0);
  uvm_config_int::set(this, "chan1", "channel_id", 1);
  uvm_config_int::set(this, "chan2", "channel_id", 2);
  uvm_config_int::set(this, "hbus",  "num_masters", 1);
  uvm_config_int::set(this, "hbus",  "num_slaves",  0);

  m_yapp          = yapp_env::type_id::create("yapp", this);
  m_chan0         = channel_env::type_id::create("chan0", this);
  m_chan1         = channel_env::type_id::create("chan1", this);
  m_chan2         = channel_env::type_id::create("chan2", this);
  m_hbus          = hbus_env::type_id::create("hbus", this);
  m_clk_rst       = clock_and_reset_env::type_id::create("clk_rst", this);
  m_mcseqr        = router_mcsequencer::type_id::create("mcseqr", this);
  m_router_module = router_module_env::type_id::create("router_module", this);

  // Register model: build, lock, backdoor root, implicit prediction
  m_yapp_rm = yapp_router_regs_t::type_id::create("yapp_rm");
  m_yapp_rm.build();
  m_yapp_rm.lock_model();
  m_yapp_rm.set_hdl_path_root("hw_top.dut.u_regs");
  m_yapp_rm.default_map.set_auto_predict(1);

  m_reg2hbus = hbus_reg_adapter::type_id::create("reg2hbus");
endfunction : build_phase

//------------------------------------------------------------------------------
function void router_tb::connect_phase(uvm_phase phase);
  m_mcseqr.m_hbus_seqr = m_hbus.m_masters[0].m_sequencer;
  m_mcseqr.m_yapp_seqr = m_yapp.m_agent.m_sequencer;

  m_yapp.m_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_yapp_export);
  m_hbus.m_monitor.m_item_collected_port.connect(m_router_module.m_hbus_export);
  m_chan0.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan0_export);
  m_chan1.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan1_export);
  m_chan2.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan2_export);

  // Front door: the model's map drives the HBUS master sequencer via the adapter
  m_yapp_rm.default_map.set_sequencer(m_hbus.m_masters[0].m_sequencer, m_reg2hbus);
endfunction : connect_phase

//------------------------------------------------------------------------------
function void router_tb::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_object("yapp_rm", m_yapp_rm);
endfunction : do_print
