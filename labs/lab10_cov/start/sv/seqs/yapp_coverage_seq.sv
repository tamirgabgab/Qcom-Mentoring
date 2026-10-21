// START POINT of Lab 10: the bodies below are yours to write. This file shadows
// yapp_project/uvc/yapp/seqs/yapp_coverage_seq.sv (run.f puts -incdir ../sv first); the finished one is there.
//------------------------------------------------------------------------------
// yapp_coverage_seq.sv -- YAPP sequence library (Lab 3 base, Lab 5 library, Lab 7 opt.)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_coverage_seq (Lab 10): close the coverage model in one run.
// Every length bucket (MIN/SMALL/MEDIUM/LARGE/MAX) to every address 0..3,
// once with good and once with bad parity -> 5 x 4 x 2 = 40 packets.
//------------------------------------------------------------------------------
class yapp_coverage_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_coverage_seq)

  extern function new(string name = "yapp_coverage_seq");
  extern task body();

endclass : yapp_coverage_seq

//------------------------------------------------------------------------------
// yapp_coverage_seq -- method implementations
//------------------------------------------------------------------------------

function yapp_coverage_seq::new(string name = "yapp_coverage_seq");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_coverage_seq::body();
  // TODO (Lab 10): write yapp_coverage_seq::body
endtask : body
