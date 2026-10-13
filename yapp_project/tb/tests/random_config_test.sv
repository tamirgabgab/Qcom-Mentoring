//------------------------------------------------------------------------------
// random_config_test.sv -- random_config_test (test plan: RND-01, DROP-01..04, CNT-01..06)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// random_config_test: many short bursts, each under a new random configuration
// pushed to the edges: maxpktsize 0, 1, 62 or 63 most of the time, the router
// off now and then, mixed counter-enable masks; lengths mostly at the
// boundaries of the maxpktsize in force and more packets to address 3. The
// reference model checks every counter, mem_size_reg and the stored packet.
//------------------------------------------------------------------------------
class random_config_test extends random_test;

  `uvm_component_utils(random_config_test)

  extern function new(string name, uvm_component parent);
  extern virtual function void configure_scenario(router_random_mcseq s);

endclass : random_config_test

//------------------------------------------------------------------------------
// random_config_test -- method implementations
//------------------------------------------------------------------------------

function random_config_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void random_config_test::configure_scenario(router_random_mcseq s);
  s.min_bursts     = 4;
  s.max_bursts     = 8;
  s.extreme_pct    = 70;
  s.router_off_pct = 20;
  s.reads_min      = 5;
  s.reads_max      = 12;
  s.addr3_pct      = 15;
  s.boundary_pct   = 70;
endfunction : configure_scenario
