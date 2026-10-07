//------------------------------------------------------------------------------
// yapp_tx_driver.sv -- Lab 3: pulls packets from the sequencer and (for now)
// only prints them. The real pin wiggling arrives in Lab 6.
//------------------------------------------------------------------------------
class yapp_tx_driver extends uvm_driver #(yapp_packet);

  `uvm_component_utils(yapp_tx_driver)

  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_phase phase);

  extern task send_to_dut(yapp_packet pkt);

endclass : yapp_tx_driver

//------------------------------------------------------------------------------
// yapp_tx_driver -- method implementations
//------------------------------------------------------------------------------

function yapp_tx_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task yapp_tx_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);     // blocks until a sequence sends one
    send_to_dut(req);
    seq_item_port.item_done();            // unblocks the sequence
  end
endtask : run_phase

task yapp_tx_driver::send_to_dut(yapp_packet pkt);
  `uvm_info(get_type_name(), $sformatf("Packet is \n%s", pkt.sprint()), UVM_LOW)
  #10ns;                                  // makes the log easier to follow
endtask : send_to_dut
