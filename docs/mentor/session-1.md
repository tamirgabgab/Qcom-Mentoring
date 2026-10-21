# Session 1 — Data items, components, phases

**Labs:** [Lab 1](../labs/lab01.md), [Lab 2](../labs/lab02.md)

## Goal

A packet class with constraints and the `do_*` methods, then an empty test / testbench pair that runs through the phases. By the end a student can explain what `run_test()` does and why a class in a package needs `uvm_object_utils`.

## Before the session

* Run `make sim` in `labs/lab01_data/tb` and `labs/lab02_test/tb` once, so the compiled build is warm on your machine.
* Open the map at [Classes → YAPP UVC](../project-map.md#view=classes) (for `yapp_packet` and its subclass) and the [Packet playground](../components/packet.md#try-it-build-or-check-a-packet).
* Read the [UVM big picture](../uvm/big-picture.md) again: it is the picture you draw first.

## Plan

1. Concept (30 min): the packet format on the [DUT specification](../dut/spec.md), then `uvm_sequence_item`, `rand` fields, constraints, `post_randomize` and the four `do_*` methods -- and why this repository writes them by hand instead of `` `uvm_field_* `` ([Getting started](../getting-started.md#running-a-lab)).
2. Lab 1 (45 min) in `labs/lab01_data/start/`: the packet. `make check LAB=lab01_data START=1` until green.
3. Concept (20 min): components, the phases ([Phases and objections](../uvm/phases.md)), `run_test()` and `+UVM_TESTNAME`.
4. Lab 2 (40 min) in `labs/lab02_test/start/`: `router_tb` and `base_test`.
5. Review (30 min): the finished `yapp_packet.sv` on the map (Source column), the topology print of Lab 2, the checkpoint questions of both labs.
6. Next lab's objective (15 min): what a UVC is, the components of Lab 3 on the [Environment view](../project-map.md#view=env).

## Show live

* `make sim` in Lab 1 with two seeds (`SEED=1`, `SEED=7`): the packets differ, the parity is always right -- `post_randomize` in action.
* The packet playground: build a packet by hand, flip a payload bit, watch the parity check fail.
* Lab 2 with `+UVM_VERBOSITY=UVM_HIGH` and then `UVM_LOW`: which lines are `uvm_info` and which are UVM's own.

## Where students get stuck

* A `rand` field without a constraint on the array size: `m_payload` stays empty. The constraint `m_payload.size() == m_length` is the lesson.
* Parity computed before the payload is final (in `pre_randomize` or in the constraint): `post_randomize` is the right hook.
* In Lab 2: creating `router_tb` with `new()` works today and breaks in Lab 4 -- say it now, fix it in Lab 4.
* `+UVM_TESTNAME` misspelled runs the default test with a warning at the top of the log that nobody reads ([FAQ](../faq.md)).

## Ask

* Why does the course keep the parity byte a plain field and compute it, rather than `rand` with a constraint? (A constraint cannot see the payload's final values in one pass.)
* What would happen with two `uvm_test` classes and no `+UVM_TESTNAME`?
* Where does the time go in a Lab 2 run that prints `$finish at 0`? (Nowhere: no component consumes time, the run phase ends at once.)

## For next time

Read the [Driver](../components/driver.md) and [Monitor](../components/monitor.md) guides; Lab 3 builds both.
