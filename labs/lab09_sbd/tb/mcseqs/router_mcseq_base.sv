//------------------------------------------------------------------------------
// router_mcseq_base.sv -- router_mcseq_base (multichannel sequence library (Lab 8))
// Split out of router_mcseqs_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// router_mcseq_base: objection on the starting phase + p_sequencer
//------------------------------------------------------------------------------
class router_mcseq_base extends uvm_sequence;

  `uvm_object_utils(router_mcseq_base)
  `uvm_declare_p_sequencer(router_mcsequencer)

  function new(string name = "router_mcseq_base");
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

endclass : router_mcseq_base
