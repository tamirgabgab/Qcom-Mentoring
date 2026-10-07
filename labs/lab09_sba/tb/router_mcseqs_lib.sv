//------------------------------------------------------------------------------
// router_mcseqs_lib.sv -- multichannel sequence library (Lab 8)
//
// `uvm_declare_p_sequencer gives every sequence a typed `p_sequencer` handle,
// so `p_sequencer.hbus_seqr` / `p_sequencer.yapp_seqr` are available.
// seq.start(p_sequencer.<seqr>, this) runs a sub-sequence on another sequencer.
//
// One class per file: the classes live in mcseqs/<class>.sv and are included below.
//------------------------------------------------------------------------------

`include "mcseqs/router_mcseq_base.sv"
`include "mcseqs/router_simple_mcseq.sv"
