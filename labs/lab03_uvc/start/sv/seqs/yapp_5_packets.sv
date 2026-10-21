// START POINT of Lab 3: the bodies of the methods and constraints below are yours to write.
// The finished file is labs/lab03_uvc/sv/seqs/yapp_5_packets.sv; the lab page explains every step.
//------------------------------------------------------------------------------
// yapp_5_packets.sv -- YAPP sequence library (Lab 3: provided base + 5 packets)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_5_packets: five random packets (provided in Lab 3)
//   Test class configuration template:
//     uvm_config_wrapper::set(this, "<path>.run_phase",
//                             "default_sequence", yapp_5_packets::get_type());
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_5_packets)

  extern function new(string name = "yapp_5_packets");
  extern task body();

endclass : yapp_5_packets

//------------------------------------------------------------------------------
// yapp_5_packets -- method implementations
//------------------------------------------------------------------------------

function yapp_5_packets::new(string name = "yapp_5_packets");
  super.new(name);
endfunction : new

//------------------------------------------------------------------------------
task yapp_5_packets::body();
  // TODO (Lab 3): write yapp_5_packets::body
endtask : body
