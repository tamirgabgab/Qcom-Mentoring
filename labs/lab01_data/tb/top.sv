//------------------------------------------------------------------------------
// top.sv -- Lab 1: randomize and print five YAPP packets
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_pkg::*;

  yapp_packet pkt;

  initial begin
    pkt = new("pkt");
    repeat (5) begin
      if (!pkt.randomize())
        `uvm_error("TOP", "Packet randomization failed")
      pkt.print();
    end

    //--------------------------------------------------------------------
    // Optional: explore copy / compare / print (do_copy, do_compare, do_print in yapp_packet)
    //--------------------------------------------------------------------
    begin
      yapp_packet copy_pkt, clone_pkt;

      // copy(): field-by-field copy into an EXISTING object
      copy_pkt = new("copy_pkt");
      copy_pkt.copy(pkt);

      // clone(): allocate a NEW object and copy into it (returns uvm_object)
      $cast(clone_pkt, pkt.clone());
      clone_pkt.set_name("clone_pkt");

      // compare(): returns 1 when every field flagged for compare matches
      `uvm_info("TOP", $sformatf("copy  compare -> %0d", pkt.compare(copy_pkt)),  UVM_NONE)
      `uvm_info("TOP", $sformatf("clone compare -> %0d", pkt.compare(clone_pkt)), UVM_NONE)
      clone_pkt.payload[0] = ~clone_pkt.payload[0];
      `uvm_info("TOP", $sformatf("modified clone compare -> %0d (miscompare is reported above)",
                                 pkt.compare(clone_pkt)), UVM_NONE)

      // The same packet with the table and the tree printer
      pkt.print(uvm_default_table_printer);
      pkt.print(uvm_default_tree_printer);
    end
  end

endmodule : top
