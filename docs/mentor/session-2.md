# Session 2 — A UVC, the factory, configuration

**Labs:** [Lab 3](../labs/lab03.md), [Lab 4](../labs/lab04.md)

## Goal

The YAPP agent (driver, sequencer, monitor) printing packets, then the same agent reconfigured from the test: a factory override that swaps the packet class and a passive agent through the configuration database.

## Before the session

* Warm builds of `labs/lab03_uvc/tb` and `labs/lab04_factory/tb`.
* Map: [Hierarchy → tb.yapp.agent](../project-map.md#view=hierarchy&node=tb.yapp.agent) for the agent, Classes view for `short_yapp_packet` under `yapp_packet`.
* [Factory and configuration](../uvm/factory-config.md) and [Agent and env](../components/agent-env.md) are the two pages the session leans on.

## Plan

1. Concept (30 min): the agent as the unit of reuse; driver loop (`get_next_item` / `item_done`), sequencer, monitor; `is_active`; the default sequence set from the test.
2. Lab 3 (50 min) in `start/`: the five classes. `make check LAB=lab03_uvc START=1`.
3. Concept (20 min): `type_id::create` versus `new`, type overrides, `uvm_config_int::set/get`, `check_config_usage`.
4. Lab 4 (40 min): `short_yapp_packet`, `short_packet_test`, `set_config_test`.
5. Review (30 min): the topology of `set_config_test` (no driver, no sequencer) next to the Hierarchy view; the `UVM_PASSIVE` line; why `configure_sequences()` is a virtual function.
6. Checkpoint questions of both labs.

## Show live

* Lab 3 `base_test`: five `Packet is` tables from the driver -- the monitor only says it is running (it has no interface yet).
* Lab 4 `short_packet_test` without the override line, then with it: the class name in the first line of every packet table changes and nothing else does.
* Lab 4 `set_config_test` with the default sequence left in `base_test::build_phase` (not in `configure_sequences`): the `configuration never used` warning at the end.

## Where students get stuck

* `super.build_phase(phase)` after the override instead of before: the override does nothing because `router_tb` was already built.
* Include order in `yapp_pkg.sv`: a driver included before the sequencer it names ([pitfall 1](../appendix/pitfalls.md)).
* `uvm_config_int::set` with the wrong instance path (`tb.yapp.agent` versus `tb.yapp_agent`): the warning at the end says which setting nobody read.
* `m_` on fields, never on arguments: the style check (`make style-check`) says `R5` and the line.

## Ask

* What does the factory need from a class so that an override can replace it? (`uvm_object_utils` and creation through `type_id::create`.)
* Why is the configuration read in `build_phase` and not in `new()`? (The database is filled by the parent's `build_phase`, which runs after the child's `new()`.)
* Which of the two configuration mechanisms would you use for a knob a sequence needs at run time?

## For next time

Read [Sequencer and sequences](../components/sequences.md); Lab 5 is only sequences, and the planned randomization failure is its best moment.
