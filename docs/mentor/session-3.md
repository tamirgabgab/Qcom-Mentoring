# Session 3 — Sequences

**Labs:** [Lab 5](../labs/lab05.md)

## Goal

The YAPP sequence library: sequences that create items, nest other sequences and raise objections -- and the planned constraint conflict that teaches how to read a randomization failure.

## Before the session

* Warm build of `labs/lab05_seq/tb`. The Lab 4 version of `short_yapp_packet` (with `m_addr != 2`) at hand for the planned failure.
* Map: Classes → YAPP UVC with **Members** on, to show `body()` of every sequence and the `start()` arrows of the tests.
* [Phases and objections](../uvm/phases.md): the objection section.

## Plan

1. Concept (40 min): `uvm_sequence`, `body()`, `start_item` / `finish_item` written out (the four steps the `` `uvm_do `` macro hides), `randomize() with`, nested sequences through `start(sequencer, this)`, objections in `pre_body` / `post_body` and the `starting_phase == null` check.
2. Lab 5 (80 min) in `start/`: the nine sequences and the two tests. `make check LAB=lab05_seq START=1`; the `exhaustive_seq_test` check asks for every sequence by name.
3. The planned failure (20 min): put back `m_addr != 2` in `short_yapp_packet`, run `exhaustive_seq_test`, read the `UVM_ERROR ... randomize() failed` line, fix it, run again.
4. Review (30 min): `yapp_exhaustive_seq` on the map, the `Executing …` lines in order, the checkpoint questions.

## Show live

* `exhaustive_seq_test`: one `Executing` line per sequence, in the order of the code -- count them with the class.
* `incr_payload_test` with `+UVM_VERBOSITY=UVM_FULL`: `Starting default sequence yapp_incr_payload_seq`, printed by the sequencer.
* The planned failure, then the GUI version if Xcelium is there (`make gui`, the constraint manager).

## Where students get stuck

* `randomize()` before `start_item()` in a sequence whose item the test overrides: the item is created and randomized before the driver is ready; works here, teaches the wrong habit. The repository randomizes between `start_item` and `finish_item`.
* An objection raised in a sub-sequence: `starting_phase` is `null` there ([pitfall 9](../appendix/pitfalls.md)).
* `req` declared but never created: `start_item(null)`. The `create` line is the first of the four steps.
* Forgetting `finish_item`: the driver's `get_next_item` returns, `item_done` is never called, the next sequence hangs ([FAQ](../faq.md)).

## Ask

* What does `finish_item` wait for? (The driver's `item_done`.) What would `start_item` wait for with two sequences on one sequencer?
* Why does `yapp_111_seq` start `yapp_1_seq` three times instead of sending three packets itself?
* Where is the objection raised for a nested sequence, and why only once?

## For next time

Read [Lab 6](../labs/lab06.md)'s concept section before the session: interfaces are the step where the packets become waves.
