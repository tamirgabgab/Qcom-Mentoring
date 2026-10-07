//------------------------------------------------------------------------------
// hbus_base_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// Base sequence: objection handling + register address constants
class hbus_base_seq extends uvm_sequence #(hbus_transaction);

  localparam bit [15:0] CTRL_REG_ADDR = 16'h1000;
  localparam bit [15:0] EN_REG_ADDR   = 16'h1001;

  `uvm_object_utils(hbus_base_seq)

  function new(string name = "hbus_base_seq");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.raise_objection(this, get_type_name());
  endtask : pre_body

  task post_body();
    uvm_phase phase = `YAPP_STARTING_PHASE;
    if (phase != null) phase.drop_objection(this, get_type_name());
  endtask : post_body

endclass : hbus_base_seq
