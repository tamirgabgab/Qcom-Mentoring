//------------------------------------------------------------------------------
// hbus_master_agent.sv -- driver + sequencer. The monitor is shared by all
// agents and lives in hbus_env (there is one bus, so one monitor is enough).
//------------------------------------------------------------------------------
class hbus_master_agent extends uvm_agent;

  hbus_master_driver    driver;
  hbus_master_sequencer sequencer;

  `uvm_component_utils_begin(hbus_master_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver    = hbus_master_driver::type_id::create("driver", this);
      sequencer = hbus_master_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : hbus_master_agent
