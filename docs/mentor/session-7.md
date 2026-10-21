# Session 7 — Functional coverage

**Labs:** [Lab 10](../labs/lab10.md)

## Goal

A covergroup on the monitor's packets, a subscriber that samples it, a sequence written to close it -- and reading a coverage report: bins, holes, crosses, and which tests the coverage needs.

## Before the session

* Warm build of `labs/lab10_cov/tb`; `make coverage ONLY=lab10` after a run gives the merged bins on the terminal.
* Map: the [Coverage view](../project-map.md#view=cov) (one card per collector, a chip per coverpoint, the bins in the panel).
* [Coverage results](../coverage-results.md) of the project, with the *Which tests the coverage needs* table, and the [Bug hunt](../bug-hunt.md) page: coverage says what was exercised, the bug hunt says what was *checked*.

## Plan

1. Concept (40 min): coverpoints and bins, `illegal_bins`, crosses, `sample()` from a `uvm_subscriber`'s `write()`, coverage as a question to the stimulus; why `yapp_pkt_coverage` is a component of its own and not a covergroup inside the monitor.
2. Lab 10 (70 min) in `start/`: the collector and `yapp_coverage_seq`. The stub of the collector shadows the finished one through `-incdir ../sv` (see `TASKS.md`). `make check LAB=lab10_cov START=1` asks for `coverage 100.0%` in the monitor's report.
3. Reading the report (30 min): the coverage results page of the project -- a hole, a bin hit by one test only, the minimal set of tests -- then the bug hunt matrix next to it.
4. Review (30 min): the Coverage view on the map, the checkpoint questions.

## Show live

* `coverage_test` before and after `yapp_coverage_seq` is complete: the percentage in the monitor's report.
* A bin added live (`bins max = {63}`), run again, the hole; which sequence closes it.
* The bug hunt page: pick one bug, show the test that catches it and the first error line; then `make sim TEST=... DEFINES=BUG_...` in `yapp_project/tb` with the waves.

## Where students get stuck

* Sampling in the monitor's `run_phase` instead of in the subscriber's `write()`: the covergroup samples before the packet is complete.
* A covergroup constructed without `new()` in the component's constructor: nothing samples, 0% with no error.
* A cross that includes an illegal combination: 100% is impossible; `ignore_bins` or the right bins.
* Reading coverage as a verdict: 100% bins with no scoreboard proves nothing -- the session's last word, with the bug hunt as the evidence.

## Ask

* What does a coverage hole tell you, and what does it not?
* Which test would you drop from the regression first, and why? (The *only this test* column.)
* A bug that survives every test: is it a coverage problem or a checking problem? (Look at the bug hunt page's survivors, if any.)

## For next time

Read [Register model](../components/register-model.md) and the [register map](../dut/register-map.md). Session 8 is three short labs around one generated package.
