//------------------------------------------------------------------------------
// random_backpressure_test.sv -- random_backpressure_test (test plan: RND-04, IN-03, OUT-02..05)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// random_backpressure_test: receivers that are slow or stall now and then, on
// a random mix of channels, against long packets sent mostly back to back.
// The channel FIFOs fill (one or several at a time), the router holds its
// input with in_suspend, and the scoreboard checks every byte still arrives
// once, in order. The router stays on with maxpktsize 63 most of the time so
// most packets are forwarded.
//------------------------------------------------------------------------------
class random_backpressure_test extends random_test;

  `uvm_component_utils(random_backpressure_test)

  extern function new(string name, uvm_component parent);
  extern virtual function void configure_scenario(router_random_mcseq s);
  extern virtual function channel_rx_profile_e pick_profile(int ch);

endclass : random_backpressure_test

//------------------------------------------------------------------------------
// random_backpressure_test -- method implementations
//------------------------------------------------------------------------------

function random_backpressure_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void random_backpressure_test::configure_scenario(router_random_mcseq s);
  s.m_extreme_pct    = 10;
  s.m_router_off_pct = 0;
  s.m_addr3_pct      = 2;
  s.m_bad_pct        = 10;
  s.m_long_pct       = 60;
  s.m_boundary_pct   = 10;
  s.m_gap0_pct       = 70;
  s.m_gap_short_pct  = 25;
endfunction : configure_scenario

//------------------------------------------------------------------------------
// Slow or stalling on most channels; one in four stays fast or normal.
function channel_rx_profile_e random_backpressure_test::pick_profile(int ch);
  case (rnd::get_int(0, 7, $sformatf("random_backpressure_test.profile%0d", ch)))
    0:          return CHANNEL_RX_PROFILE_FAST;
    1:          return CHANNEL_RX_PROFILE_NORMAL;
    2, 3, 4:    return CHANNEL_RX_PROFILE_SLOW;
    default:    return CHANNEL_RX_PROFILE_STALLY;
  endcase
endfunction : pick_profile
