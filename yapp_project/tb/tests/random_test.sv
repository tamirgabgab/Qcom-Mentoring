//------------------------------------------------------------------------------
// random_test.sv -- random_test (test plan: RND-01..04 and the items the random
// tests strengthen, see docs/test-plan.md)
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// random_test: a random scenario checked automatically. The seed decides the
// shape of the test, not only the values in it:
//   * router_random_mcseq: 10..100 packets in 2..6 bursts, a random
//     configuration (maxpktsize, router_en, counter enables) before each burst,
//     random HBUS reads in between, every register and the stored packet read
//     at the end
//   * every channel gets its own receiver profile (channel_rx_random_seq):
//     fast, normal, slow or one that stalls now and then
// Nothing is checked by hand: the scoreboard checks every forwarded packet
// (and that none is left at the end), the reference model checks every HBUS
// read against its model of the counters, mem_size_reg, yapp_pkt_mem and
// yapp_mem (check_reads = 1), and error_pulse_checker checks one error pulse,
// 1..10 cycles later, per bad-parity packet received while the router was on.
// The other random tests extend this one and change the knobs
// (configure_scenario, pick_profile).
//------------------------------------------------------------------------------
class random_test extends base_test;

  router_random_mcseq   scenario;
  error_pulse_checker   err_chk;
  channel_rx_random_seq rx_seq[3];

  `uvm_component_utils(random_test)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void configure_sequences();
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  // Knobs of the scenario; the default is the balanced mix
  extern virtual function void configure_scenario(router_random_mcseq s);

  // The receiver profile of one channel; the default draws any of the four
  extern virtual function channel_rx_profile_e pick_profile(int ch);

  // Wait (bounded) until every forwarded packet came out of its channel
  extern task wait_drained();

endclass : random_test

//------------------------------------------------------------------------------
// random_test -- method implementations
//------------------------------------------------------------------------------

function random_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------
function void random_test::build_phase(uvm_phase phase);
  uvm_config_db #(bit)::set(this, "tb.router_module.reference", "check_reads", 1'b1);
  super.build_phase(phase);
  err_chk = error_pulse_checker::type_id::create("err_chk", this);
endfunction : build_phase

//------------------------------------------------------------------------------
// The clock as usual; one receiver sequence object per channel, each with its
// own profile, set as that channel's default_sequence.
function void random_test::configure_sequences();
  uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase",
                          "default_sequence", clk10_rst5_seq::get_type());
  for (int ch = 0; ch < 3; ch++) begin
    rx_seq[ch] = channel_rx_random_seq::type_id::create($sformatf("rx_seq%0d", ch));
    rx_seq[ch].profile = pick_profile(ch);
    uvm_config_db #(uvm_sequence_base)::set(this, $sformatf("tb.chan%0d.rx_agent.sequencer.run_phase", ch),
                                            "default_sequence", rx_seq[ch]);
  end
endfunction : configure_sequences

//------------------------------------------------------------------------------
function void random_test::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  tb.yapp.agent.monitor.item_collected_port.connect(err_chk.analysis_export);
  err_chk.reference = tb.router_module.reference;
endfunction : connect_phase

//------------------------------------------------------------------------------
task random_test::run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  stage($sformatf("receivers: ch0 %s, ch1 %s, ch2 %s", rx_seq[0].profile.name(), rx_seq[1].profile.name(),
                  rx_seq[2].profile.name()));
  scenario = router_random_mcseq::type_id::create("scenario");
  configure_scenario(scenario);
  scenario.start(tb.mcseqr);
  wait_drained();
  stage($sformatf({"done: %0d packets (%0d forwarded, %0d dropped), %0d storm burst(s), ",
                   "%0d scoreboard matches, %0d HBUS reads checked, %0d error pulses for %0d bad packets"},
                  scenario.total_packets, tb.router_module.reference.packets_forwarded,
                  tb.router_module.reference.dropped_disabled + tb.router_module.reference.dropped_size
                  + tb.router_module.reference.dropped_addr,
                  scenario.num_storms, tb.router_module.scoreboard.packets_matched,
                  tb.router_module.reference.reads_checked, err_chk.num_pulses, err_chk.num_bad));
  phase.drop_objection(this);
endtask : run_phase

//------------------------------------------------------------------------------
function void random_test::configure_scenario(router_random_mcseq s);
  // the defaults of router_random_mcseq: 10..100 packets, 2..6 bursts, a mix of everything
endfunction : configure_scenario

//------------------------------------------------------------------------------
function channel_rx_profile_e random_test::pick_profile(int ch);
  return channel_rx_profile_e'(rnd::get_int(0, 3, $sformatf("random_test.profile%0d", ch)));
endfunction : pick_profile

//------------------------------------------------------------------------------
task random_test::wait_drained();
  int judged;
  // a stalling receiver can hold a packet for up to 150 cycles; give every packet room
  repeat (200 * (scenario.total_packets + 10)) begin
    judged = tb.router_module.scoreboard.packets_matched + tb.router_module.scoreboard.packets_mismatched;
    if (judged >= tb.router_module.reference.packets_forwarded) begin
      break;
    end
    @(posedge tb.yapp.agent.monitor.vif.clock);
  end
  repeat (12) begin
    @(posedge tb.yapp.agent.monitor.vif.clock);   // the last error pulse
  end
endtask : wait_drained
