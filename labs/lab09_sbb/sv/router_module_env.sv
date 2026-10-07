//------------------------------------------------------------------------------
// router_module_env.sv -- the router MODULE UVC (Lab 9B)
//
// A module UVC has no interface: it is a bundle of analysis components
// (reference model, scoreboard, later coverage) that work on the transactions
// the interface UVCs collect.
//
//   yapp ──►(yapp_in) reference ──yapp_valid_out──►(yapp_in) scoreboard ◄──(chanN_in) chanN
//   hbus ──►(hbus_in)
//------------------------------------------------------------------------------
class router_module_env extends uvm_env;

  router_reference  reference;
  router_scoreboard scoreboard;

  `uvm_component_utils(router_module_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    reference  = router_reference::type_id::create("reference", this);
    scoreboard = router_scoreboard::type_id::create("scoreboard", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    // Only packets the router will route reach the scoreboard
    reference.yapp_valid_out.connect(scoreboard.yapp_in);
  endfunction : connect_phase

endclass : router_module_env
