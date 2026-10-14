# Functional coverage

Functional coverage answers one question the simulator cannot answer by itself: **did the tests
exercise everything the plan asked for?** A scoreboard tells you the DUT was *right* for the
traffic it saw; coverage tells you *which* traffic it saw. Code coverage (lines, branches,
toggles, collected by the simulator) says which RTL ran; functional coverage is written by the
verification engineer and says which *scenarios* happened: every packet length, every address,
a bad parity to every legal channel, a register written while traffic was flowing. This page is
the general picture; [Functional coverage in the project](../components/coverage.md) shows the
seven collectors of the router and [Lab 10](../labs/lab10.md) builds the first one.

## The vocabulary

| Term | What it is | In the router |
|---|---|---|
| **covergroup** | a named set of things to count, with a `sample()` function that takes the values | `yapp_pkt_cg`, `hbus_addr_cg`, … |
| **coverpoint** | one value to watch, sorted into bins | `length_cp : coverpoint length` |
| **bin** | a bucket of values; a bin is *hit* when a sampled value falls into it | `bins SMALL = {[2:10]};` |
| **cross** | every combination of the bins of two or more coverpoints | length × address × parity |
| **ignore_bins** | combinations that are not part of the requirement (dropped from the denominator) | good parity in the cross |
| **illegal_bins** | combinations that must never happen (an error when hit) | not used here: address 3 *is* exercised on purpose |
| **hole** | a bin no run hit | what the regression report lists first |
| **merge** | adding up the hits of every run and seed into one database | `make sim-report` |

The percentage of a covergroup is *bins hit / bins*, so the bins decide what 100 % means:
five length bins say "we sent short, medium and long packets", not "we sent all 63 lengths".
Choose them from the plan, not from the value range.

## Where it samples: a subscriber on the monitor

Coverage lives where the truth is. The **monitor** reports what really crossed the interface,
whatever the sequence intended and whatever the driver did; a `uvm_subscriber` hangs on the
monitor's analysis port and samples in its `write()`:

```systemverilog
class yapp_pkt_coverage extends uvm_subscriber #(yapp_packet);

  int m_num_sampled;

  `uvm_component_utils(yapp_pkt_coverage)

  covergroup yapp_pkt_cg with function sample(bit[5:0] length, bit[1:0] addr, parity_type_e parity_type);
    option.per_instance = 1;
    length_cp : coverpoint length { bins MIN = {1}; bins SMALL = {[2:10]}; bins MEDIUM = {[11:40]};
                                    bins LARGE = {[41:62]}; bins MAX = {63}; }
    addr_cp   : coverpoint addr   { bins legal[] = {[0:2]}; bins illegal_addr = {3}; }
    parity_cp : coverpoint parity_type { bins good = {PARITY_TYPE_GOOD}; bins bad = {PARITY_TYPE_BAD}; }
    len_x_addr_x_parity : cross length_cp, addr_cp, parity_cp {
      ignore_bins good_parity  = binsof(parity_cp) intersect {PARITY_TYPE_GOOD};
      ignore_bins illegal_addr = binsof(addr_cp.illegal_addr);
    }
  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(yapp_packet t);

endclass : yapp_pkt_coverage

//------------------------------------------------------------------------------
function void yapp_pkt_coverage::write(yapp_packet t);
  yapp_pkt_cg.sample(t.m_length, t.m_addr, t.m_parity_type);
  m_num_sampled++;
endfunction : write
```

The agent connects it like any other analysis consumer:
`m_monitor.m_item_collected_port.connect(m_pkt_cov.analysis_export)`. Nothing in the monitor
knows the collector exists, so the coverage model can be swapped, extended or left out of a
passive agent without touching the UVC. The course puts the covergroup *inside* the monitor;
the bins and the numbers are the same, only the file differs
(see [where the covergroups live](../components/coverage.md#where-the-covergroups-live)).

!!! note "Why not the sequence or the driver?"
    A sequence only knows what it *asked* for; a driver may drop or corrupt what it was given.
    The monitor sees the packet the DUT received, including traffic from other sources, and it
    exists in a passive agent that drives nothing. Sampling there means the percentage
    describes the DUT's day, not the testbench's intentions.

## The coverage-driven loop

1. **Plan.** Every requirement of the [test plan](../test-plan.md) names its coverage: which
   covergroup, which bins, prove it happened.
2. **Run.** Each run writes its own coverage database next to its log.
3. **Merge.** The regression merges every run and seed into one picture
   (`make regress`, then `make sim-report`): one hit anywhere is enough for a bin.
4. **Read the holes.** The report lists the bins no run hit, first.
5. **Close them with stimulus.** A hole is a scenario the tests never produced: write a
   sequence that reaches it (`yapp_coverage_seq` sends every length bucket to every address with
   both parities), or a constraint that makes random traffic reach it more often, then run again.
6. **Review the bins** when 100 % arrives: a model that is easy to fill was asking too little.

Coverage is additive across tests, so a directed test for one bin and a random test that hits
the rest together make 100 %; the [coverage results](../coverage-results.md) page shows which
tests contributed to each bin, and the Coverage view of the [project map](../project-map.md)
draws the same collectors as cards.

## Reading the numbers

* `option.per_instance = 1` reports every collector instance on its own; with one agent it
  changes nothing, with three channel monitors it tells the channels apart.
* A cross with `ignore_bins` counts only the combinations that matter: 5 lengths × 3 legal
  addresses × bad parity = 15 bins, not 5 × 4 × 2 = 40.
* A bin hit once by one seed is as covered as a bin hit a thousand times. Hit counts are for
  judging the stimulus mix, not the percentage.
* Verilator, xrun and the other simulators keep their own database formats; the report
  generator reads Verilator's (`.dat`) and merges with `verilator_coverage`, xrun uses IMC
  ([Seeing the results](../components/coverage.md#seeing-the-results-verilator)).

## Where to look next

* [Functional coverage in the project](../components/coverage.md): the seven collectors, their
  requirements and how they are fed.
* [Lab 10](../labs/lab10.md): write the first covergroup, find the holes, close them.
* [Coverage results](../coverage-results.md): every covergroup of the last regression, merged,
  with the tests behind each bin, and the annotated source.
* [Regression results](../regression/index.md): the runs that produced those numbers.
