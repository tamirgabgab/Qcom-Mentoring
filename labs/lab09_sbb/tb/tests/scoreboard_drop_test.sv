//------------------------------------------------------------------------------
// scoreboard_drop_test.sv -- scoreboard_drop_test (test library (Lab 9B: module UVC tests))
// Split out of router_test_lib.sv: one class per file.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// scoreboard_drop_test (Lab 9A step 7): same multichannel sequence WITHOUT the
// short-packet override. The first six packets may be longer than the
// maxpktsize of 20 set by hbus_small_packet_seq, so the router drops them:
//   * "ROUTER DROPS PACKET" in the log,
//   * the next packet on that channel mismatches (uvm_error from the compare),
//   * packets are left in the scoreboard queues at the end.
// Check that received == matched + mismatched + left in queues.
//------------------------------------------------------------------------------
class scoreboard_drop_test extends router_simple_mcseq_test;

  `uvm_component_utils(scoreboard_drop_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    // Skip router_simple_mcseq_test::build_phase -> no type override
    base_test::build_phase(phase);
  endfunction : build_phase

endclass : scoreboard_drop_test
