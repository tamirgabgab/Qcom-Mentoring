# Pitfalls

The mistakes the course warns about, plus the ones that came up while building
this reference environment.

## Compile and include order

1. **Include order matters.** In a package and in `tb_top`, a class must be
   included before any file that uses it: packet → monitor → sequencer →
   sequences → driver → agent → env; `router_tb` before the tests; the
   multichannel sequencer before `router_tb`; the register package before
   `router_tb`.
2. **Interfaces are compiled, not included.** List `*_if.sv` in `run.f`.
3. **`-timescale 1ns/1ns`** in `run.f` avoids timescale mismatches between the
   RTL, the interfaces and the UVM library.

## Configuration and factory

4. **Set configuration before building.** `is_active`, `channel_id`,
   `num_masters`, default sequences — all before the component that reads them
   is created (that is, before `super.build_phase()` in a test).
5. **Unused configuration warnings.** A passive agent makes a sequencer
   `default_sequence` unused (Lab 4). Only set what will be read.
6. **`new()` bypasses the factory.** Anything a test may want to override must
   be created with `type_id::create()`.
7. **Overrides after creation do nothing.** `set_type_override_by_type` goes
   before `super.build_phase(phase)`.

## Sequences and objections

8. **Planned constraint conflict in Lab 5** (`short_yapp_packet` `addr != 2`
   vs `yapp_012_seq`). Fix it before Lab 6.
9. **Objections in sub-sequences.** `starting_phase` is `null` for a child
   sequence; always test for `null` before raising.
10. **`forever` + objection = a test that never ends.** The channel response
    sequence runs forever and must not object.
11. **Missing `item_done()`** hangs the sequence; **missing drain time** loses
    the last packet (Lab 6).

## Interfaces and timing

12. **Check `uvm_config_db::get`'s return value** and raise `` `uvm_error ``:
    a `null` virtual interface crashes later, far from the cause.
13. **Drive on the falling edge, sample on the rising edge.** Driving and
    sampling on the same edge races with non-blocking assignments.
14. **HBUS `hdata`.** Connect the DUT to the `hdata_w` wire, not to the
    `hdata` logic variable (multiple drivers otherwise).
15. **The parity byte has `in_data_vld` low.** Monitors must not wait for
    `in_data_vld` to collect it.
16. **Hold data while `in_suspend` is high**; a byte counts only at a rising
    edge where `in_suspend` is low.

## TLM

17. **Hierarchical handles are not config strings.** `mcseqr.yapp_seqr =
    yapp.agent.sequencer` — no wildcards.
18. **Clone in the scoreboard.** Analysis imps pass handles; `clone()` before
    queueing. Analysis FIFOs never clone, so monitors must create a new object
    per transaction.
19. **`` `uvm_analysis_imp_decl `` goes outside the class**, once per suffix
    per package.
20. **Connect in `connect_phase`**, from the port to the imp/export.

## Register model

21. **Backdoor access needs `-access +rwc`.**
22. **Model names must match RTL names** for HDL paths.
23. **Check-on-read with RO counters** needs `predict()` first.

## UVM versions

24. **UVM 1.1d vs 1.2.** Use `` `YAPP_STARTING_PHASE `` from
    `common/uvm_version_compat.svh` instead of `starting_phase` /
    `get_starting_phase()` directly. The course recommends 1.1d for the
    training because of transaction-recording issues in 1.2.
