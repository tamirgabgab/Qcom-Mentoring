// START POINT of Lab 8: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab08_mcseq/tb/mcseqs/router_mcseq_base.sv; the lab page explains every step.
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

  extern function new(string name = "router_mcseq_base");
  extern task pre_body();

  extern task post_body();

endclass : router_mcseq_base

//------------------------------------------------------------------------------
// router_mcseq_base -- method implementations
//------------------------------------------------------------------------------

function router_mcseq_base::new(string name = "router_mcseq_base");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task router_mcseq_base::pre_body();
  // TODO (Lab 8): write router_mcseq_base::pre_body
endtask : pre_body

//------------------------------------------------------------------------------
task router_mcseq_base::post_body();
  // TODO (Lab 8): write router_mcseq_base::post_body
endtask : post_body
