//------------------------------------------------------------------------------
// random_parity_test.sv -- random_parity_test (test plan: RND-02, RND-03, PKT-05, IN-04, CNT-03)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// random_parity_test: bad parity everywhere it can happen.
//   * 30..60% of the packets have bad parity, on legal and illegal addresses,
//     short and oversized packets, so bad packets are also dropped ones (they
//     must still count and pulse) and, with the router off, ignored ones
//   * half of the bursts are storms: 1..3-byte packets mostly back to back,
//     so a new bad packet ends before the pulse of the previous one -- every
//     one of them must still get its own pulse 1..10 cycles later
// error_pulse_checker matches pulses to bad packets; the reference model
// checks parity_err_cnt_reg with its enable bit.
//------------------------------------------------------------------------------
class random_parity_test extends random_test;

  `uvm_component_utils(random_parity_test)

  extern function new(string name, uvm_component parent);
  extern virtual function void configure_scenario(router_random_mcseq s);

endclass : random_parity_test

//------------------------------------------------------------------------------
// random_parity_test -- method implementations
//------------------------------------------------------------------------------

function random_parity_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void random_parity_test::configure_scenario(router_random_mcseq s);
  s.m_min_bursts     = 3;
  s.m_max_bursts     = 6;
  s.m_storm_pct      = 50;
  s.m_router_off_pct = 15;
  s.m_addr3_pct      = 15;
  s.m_bad_pct        = rnd::get_int(30, 60, "random_parity_test.bad_pct");
  s.m_boundary_pct   = 50;
  s.m_gap0_pct       = 40;
endfunction : configure_scenario
