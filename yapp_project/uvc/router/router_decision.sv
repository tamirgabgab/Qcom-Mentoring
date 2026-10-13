//------------------------------------------------------------------------------
// router_decision.sv -- what router_reference decided for one packet
//
// Published on router_reference.decision_out for every packet received while
// the router is enabled (forwarded or dropped), together with the
// configuration it was judged with. router_coverage samples it.
//------------------------------------------------------------------------------
typedef enum { DECIDE_FORWARDED, DECIDE_ADDR3, DECIDE_OVERSIZED } router_reason_e;

class router_decision extends uvm_object;

  yapp_packet     pkt;                      // the packet, as the monitor collected it
  bit [5:0]       maxpktsize;               // ctrl_reg[5:0] when it was received
  bit [7:0]       en_reg;                   // en_reg when it was received
  router_reason_e reason;

  `uvm_object_utils(router_decision)

  extern function new(string name = "router_decision");

endclass : router_decision

//------------------------------------------------------------------------------
// router_decision -- method implementations
//------------------------------------------------------------------------------

function router_decision::new(string name = "router_decision");
  super.new(name);
endfunction : new
