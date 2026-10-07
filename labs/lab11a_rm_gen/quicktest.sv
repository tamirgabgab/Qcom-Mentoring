//------------------------------------------------------------------------------
// quicktest.sv -- Lab 11A: build the register model standalone, reset it and
// print the model and its address map. No DUT, no bus: pure introspection.
//
//   % xrun -f run.f
//
// Use the printout to answer the lab questions: model type, reset value of
// ctrl_reg.plen, size of yapp_pkt_mem, access policy of addr3_cnt_reg,
// address of mem_size_reg, start address of the packet memory.
//------------------------------------------------------------------------------
`timescale 1ns/1ns

module quicktest;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import yapp_router_reg_pkg::*;

  class qt_test extends uvm_test;

    yapp_router_regs_t model;

    `uvm_component_utils(qt_test)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      model = yapp_router_regs_t::type_id::create("model");
      model.build();          // creates registers, fields, memories, maps
      model.lock_model();     // no more changes; computes the address map
    endfunction : build_phase

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      model.reset();          // mirrored values <- reset values
      model.print();          // hierarchy: block -> registers -> fields
      model.default_map.print();   // addresses as seen from the HBUS
      phase.drop_objection(this);
    endtask : run_phase

  endclass : qt_test

  initial run_test("qt_test");

endmodule : quicktest
