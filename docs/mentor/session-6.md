# Session 6 — TLM, scoreboard, reference model

**Labs:** [Lab 9A](../labs/lab09a.md), [Lab 9B](../labs/lab09b.md), [Lab 9C](../labs/lab09c.md) and [Lab 9D](../labs/lab09d.md) (optional)

## Goal

Self-checking tests: analysis ports from the monitors into a scoreboard (9A), a reference model that predicts the drops so the scoreboard stops lying (9B), exports on the module UVC's env (9C) and an analysis-FIFO scoreboard as the alternative (9D).

## Before the session

* Warm builds of the four `labs/lab09_*/tb`.
* Map: [TLM / data flow](../project-map.md#view=tlm) with **Arrows** on -- the whole session is this picture; the **Lab 9D** button swaps the FIFO scoreboard in.
* [TLM connections](../uvm/tlm.md), and the [test plan](../test-plan.md) group *Drop rules* for what the reference model must predict.

## Plan

1. Concept (30 min): `uvm_analysis_port` → `uvm_analysis_imp`, `write()`, `` `uvm_analysis_imp_decl `` for several imps in one component, `clone()` before storing a transaction; what a scoreboard compares and what it cannot know.
2. Lab 9A (40 min) in `start/`: the scoreboard. `make check LAB=lab09_sba START=1` expects the *planned* mismatch of `scoreboard_drop_test` (the test is listed with `expect: errors`).
3. Concept (15 min): the reference model as the DUT's rules at transaction level; the module UVC as the home of model + scoreboard.
4. Lab 9B (50 min): `router_reference`, `router_module_env`, the package, the connections in `router_tb`. The same `scoreboard_drop_test` now passes.
5. 9C / 9D (30 min, optional): exports on the env; the analysis FIFO and the blocking `get()`.
6. Review (15 min): the arrows on the map in the order a packet travels; the reports `packets matched / mismatched`; the checkpoint questions.

## Show live

* 9A `scoreboard_drop_test`: the `MISMATCH` line and the report with mismatches -- the scoreboard is right that something differs and wrong about what.
* 9B the same test: `maxpktsize is now 20`, `router_en is now 1` from the reference model, then `0 mismatched`.
* The 9D variant on the map: the FIFO scoreboard replaces model + scoreboard; same arrows, different consumer.

## Where students get stuck

* Storing the handle the monitor passed to `write()` instead of a `clone()`: the monitor reuses the object, the stored packet changes under the scoreboard.
* Two `uvm_analysis_imp` fields of the same type in one class: the `` `uvm_analysis_imp_decl(_suffix) `` macro and the `write_suffix` method.
* `connect_phase` connecting a port to an export of a component that is created later: order the envs, or connect one level up ([Lab 9C](../labs/lab09c.md)).
* The reference model that predicts a drop for address 3 but not for `router_en == 0`: the test plan's drop rules, all four.

## Ask

* What is the difference between a port and an export, and which end calls `write()`?
* Why is the scoreboard's expected queue per channel, not one for all?
* With the FIFO scoreboard (9D), what keeps the test alive while `get()` blocks, and what happens to a packet that was predicted and never arrives?

## For next time

Read [Functional coverage](../components/coverage.md). Session 7 is one lab and a lot of looking at numbers; have the [Coverage results](../coverage-results.md) page open.
