# Session 5 — Integrating UVCs, the virtual sequencer

**Labs:** [Lab 7](../labs/lab07.md), [Lab 8](../labs/lab08.md)

## Goal

The full environment: the HBUS, Channel and Clock & Reset UVCs configured and wired in `router_tb` and `hw_top`, then a multichannel sequence on a virtual sequencer that programs the router over HBUS and sends packets in one `body()`.

## Before the session

* Warm builds of `labs/lab07_integ/tb` and `labs/lab08_mcseq/tb` (the first compile of the full environment takes a few minutes).
* Map: the [Environment view](../project-map.md#view=env) (every UVC open), [TLM / data flow](../project-map.md#view=tlm) for the arrows, and [Hierarchy → tb.mcseqr](../project-map.md#view=hierarchy&node=tb.mcseqr).
* [Virtual sequencer](../components/virtual-sequencer.md) and the HBUS [register map](../dut/register-map.md) (the write of `maxpktsize` and `en_reg` is the first thing a multichannel sequence does).

## Plan

1. Concept (30 min): reusing a UVC you did not write -- its interface, its configuration knobs (`num_masters`, `channel_id`), its default sequences; several interfaces in `hw_top`; the bidirectional `hdata` and why the DUT connects to `hdata_w`.
2. Lab 7 (60 min) in `start/`: `router_tb` with the four envs, `hw_top`, `tb_top`, `run.f`. `make check LAB=lab07_integ START=1`: the three channels must each collect a packet in `simple_test`.
3. Concept (20 min): the virtual sequencer, `` `uvm_declare_p_sequencer ``, a sequence that starts sub-sequences on `p_sequencer.hbus_seqr` and `p_sequencer.yapp_seqr`.
4. Lab 8 (40 min): `router_mcsequencer`, `router_simple_mcseq`, the test.
5. Review (30 min): `router_simple_mcseq` on the map with its `uses` arrows; the HBUS monitor lines `Collected WRITE addr=0x1000 data=0x14` and the read that returns 20; the checkpoint questions.

## Show live

* Lab 7 `test_uvc_integration`: 88 packets, the HBUS programming at the start, the channel reports at the end.
* Lab 8 `router_simple_mcseq_test`: the order of the `Executing` lines -- HBUS small-packet sequence, then the read, then the YAPP sequence -- and `MAXPKTSIZE register reads 20`.
* The `hdata_w` wire in the waves during a read: `z` when nobody drives, the DUT's value in the second cycle.

## Where students get stuck

* The DUT connected to `hbus0.hdata` (the logic variable) instead of `hbus0.hdata_w`: writes work, reads return `x` ([Lab 7](../labs/lab07.md), the trap of the day).
* `num_masters` set after `super.build_phase`: two masters or none.
* `channel_id` not set per channel env: every monitor checks for address 0 and reports the other packets as errors.
* In Lab 8, the virtual sequence started on a real sequencer, or `p_sequencer` used without the macro: a `null` handle at run time.

## Ask

* Why does the channel UVC's response sequence run `forever` and raise no objection? What ends the test, then?
* What does the virtual sequencer own? (Handles, no driver.) What would a test lose if the multichannel sequence wrote to the HBUS sequencer directly, by its hierarchical name?
* `num_slaves` does not exist: who is the slave on HBUS, and why does the UVC not need an agent for it?

## For next time

Read [Scoreboard](../components/scoreboard.md) and [Reference model](../components/reference-model.md); session 6 turns the environment self-checking, in four labs.
