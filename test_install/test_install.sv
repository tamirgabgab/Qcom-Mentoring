//------------------------------------------------------------------------------
// test_install.sv -- smallest possible UVM test: proves the simulator finds
// the UVM library and can run a test.
//
//   % cd test_install
//   % xrun -f run.f
//   ... UVM_INFO ... UVM TEST INSTALL PASSED!
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module test_install;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class install_test extends uvm_test;

    `uvm_component_utils(install_test)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("INSTALL", $sformatf("UVM library version: %s", uvm_revision_string()), UVM_NONE)
      #10;
      `uvm_info("INSTALL", "UVM TEST INSTALL PASSED!", UVM_NONE)
      phase.drop_objection(this);
    endtask : run_phase

  endclass : install_test

  initial run_test("install_test");

endmodule : test_install
