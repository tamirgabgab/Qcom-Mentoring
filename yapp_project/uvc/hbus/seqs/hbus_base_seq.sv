//------------------------------------------------------------------------------
// hbus_base_seq.sv -- sequence library of the HBUS master
// Split out of hbus_master_seqs.sv: one class per file.
//------------------------------------------------------------------------------

// Base sequence: objection handling + register address constants
class hbus_base_seq extends uvm_sequence #(hbus_transaction);

  localparam bit [15:0] CTRL_REG_ADDR = 16'h1000;
  localparam bit [15:0] EN_REG_ADDR   = 16'h1001;

  `uvm_object_utils(hbus_base_seq)

  extern function new(string name = "hbus_base_seq");
  extern task pre_body();

  extern task post_body();

endclass : hbus_base_seq

//------------------------------------------------------------------------------
// hbus_base_seq -- method implementations
//------------------------------------------------------------------------------

function hbus_base_seq::new(string name = "hbus_base_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task hbus_base_seq::pre_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.raise_objection(this, get_type_name());
  end
endtask : pre_body

//------------------------------------------------------------------------------
task hbus_base_seq::post_body();
  uvm_phase phase = `YAPP_STARTING_PHASE;
  if (phase != null) begin
    phase.drop_objection(this, get_type_name());
  end
endtask : post_body
