//------------------------------------------------------------------------------
// clock_and_reset_agent.sv -- active agent (no monitor needed for clock/reset)
//------------------------------------------------------------------------------
class clock_and_reset_agent extends uvm_agent;

  clock_and_reset_driver    driver;
  clock_and_reset_sequencer sequencer;

  `uvm_component_utils_begin(clock_and_reset_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      driver    = clock_and_reset_driver::type_id::create("driver", this);
      sequencer = clock_and_reset_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE)
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : clock_and_reset_agent
