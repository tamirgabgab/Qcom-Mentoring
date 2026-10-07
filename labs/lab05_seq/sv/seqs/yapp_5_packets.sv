//------------------------------------------------------------------------------
// yapp_5_packets.sv -- YAPP sequence library (Lab 3 base, Lab 5 library)
// Split out of yapp_tx_seqs.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// yapp_5_packets: five random packets (provided in Lab 3)
//   Test class configuration template:
//     uvm_config_wrapper::set(this, "tb.yapp.agent.sequencer.run_phase",
//                             "default_sequence", yapp_5_packets::get_type());
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;

  `uvm_object_utils(yapp_5_packets)

  function new(string name = "yapp_5_packets");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
    repeat (5)
      `uvm_do(req)
  endtask : body

endclass : yapp_5_packets
