# FAQ and troubleshooting

The questions that come up in the first weeks, with the answer and the place to read more. The
[pitfalls](appendix/pitfalls.md) page lists the design mistakes the course warns about; this page is
about what you see on the screen.

## Running

??? question "`make sim` says `verilator not found`"
    Verilator is not installed, or not the version the flow expects. `bash scripts/setup_sim.sh`
    installs it (Ubuntu, WSL2; ~15 minutes the first time), or open the repository in a
    [GitHub Codespace](https://codespaces.new/tamirgabgab/Qcom-Mentoring?quickstart=1) where it is
    already there. Details: [Simulating with Verilator](appendix/verilator.md).

??? question "The first `make sim` takes minutes"
    The first run compiles the whole testbench and the UVM library to C++ (2–5 minutes). The
    executable is kept in `build/sim/<directory>/`; changing the test (`TEST=`) does not recompile,
    changing a source file recompiles only what depends on it.

??? question "My test runs `base_test` instead of the one I asked for"
    `+UVM_TESTNAME=<class>` must name a class that exists and is included in the test library
    (`tb/router_test_lib.sv` includes `tests/<name>.sv`). A typo in the name, or a class not
    registered with `` `uvm_component_utils ``, falls back to the default test with a `UVM_WARNING`
    at the top of the log — read the first ten lines.

??? question "The run never ends"
    Something keeps the run phase alive: an objection that is never dropped (a sequence that
    raised in `pre_body` and did not reach `post_body`), a `forever` loop in a sequence that
    raised an objection ([pitfall 10](appendix/pitfalls.md)), or a driver that never called
    `item_done()` so `finish_item` blocks forever ([pitfall 11](appendix/pitfalls.md)). With
    Verilator, `scripts/sim.py` stops a run after a timeout and the log says so.

??? question "The last packet is missing from the output"
    The run ended before the router finished sending it. The test keeps the run phase alive for a
    drain time after the last objection drops (`base_test` sets it); a sequence that drops its
    objection as soon as the driver has *accepted* the last packet needs that time. See
    [Phases and objections](uvm/phases.md).

## Compiling

??? question "`Unknown class or package 'yapp_packet'` / a class is not found"
    Include order: a class must be included (in the package file) before any file that uses it.
    Packet → monitor → sequencer → sequences → driver → agent → env, and `router_tb` before the
    tests ([pitfall 1](appendix/pitfalls.md)). A new sequence file must be added to
    `yapp_tx_seqs.sv`, a new test to `router_test_lib.sv`.

??? question "`make lint` fails but the simulator is happy (or the other way round)"
    `make lint` elaborates with slang against the Accellera UVM source, the simulator with its own
    library; slang is stricter on a few things (a missing `virtual`, a wrong argument type). Fix
    the lint error: the code must pass both, CI runs the lint on every push.

??? question "`sv_style: ... R6 ...` — what is the style check complaining about?"
    `make style-check` enforces the conventions of this repository (one class per file, `extern`
    prototypes, `begin … end` around every body, `m_` on class fields, enums ending in `_e`, …);
    each line says `file:line: R<n>` and the rule. `make style` fixes the layout rules itself;
    the naming rules you fix by hand. The rules are listed in
    [Getting started](getting-started.md#running-a-lab).

## Logs and results

??? question "Where is the log?"
    Verilator: `build/sim/<directory>/logs/<test>_s<seed>.log` (the path is printed at the end of
    `make sim`). Xcelium: `xrun.log` in the directory you ran in. [Logs, timelines and
    waves](appendix/sim-report.md) explains how to read one.

??? question "`UVM_WARNING ... configuration never used`"
    A `uvm_config_db::set` that nobody read: the path or the field name is wrong, or the component
    that would read it was not built (a passive agent has no sequencer, so its default sequence
    is never read). `check_config_usage()` in `base_test` prints these on purpose ([Lab 4](labs/lab04.md)).

??? question "`randomize() failed` / `UVM_ERROR ... Randomization failed`"
    The constraints contradict each other, or an inline `with { … }` contradicts a class
    constraint ([Lab 5](labs/lab05.md#the-planned-failure) does this on purpose). The item keeps
    its previous values and is still sent — check the log for the packet that follows.

??? question "The scoreboard reports a mismatch — is it my code or the DUT?"
    Read the `[router_scoreboard] ... MISMATCH` line: it names the channel, and the
    `[PKT_COMPARE]` line before it says which field differs. A parity mismatch with a correct
    payload usually means the packet was *predicted* wrongly (the reference model), a missing
    packet means it was dropped by the router and not predicted. The [test plan](test-plan.md)
    lists what the router drops.

??? question "`make check` says `MISSING` but my test passes"
    `make check` looks for the lines the *finished* lab prints (`scripts/lab_checks.yaml`): the
    name of the sequence in an `Executing …` message, a report line with a count. A test can end
    with 0 errors and still not do what the lab asked. Compare your log with the line the check
    names; the log path is printed under the test.

## Waves

??? question "I cannot see `yapp_pkt_mem` / `yapp_mem` in the waves"
    They are arrays of 64 and 256 bytes; Verilator only records arrays up to 32 elements unless
    told otherwise. `scripts/sim.py` passes `--trace-max-array 256`, so a wave file produced by
    `make sim ... WAVES=1` has them under `hw_top.dut.u_regs`; an older `.fst` does not.

??? question "Which signals should I look at first?"
    `yapp_router.sucl` / `.surf.ron` in `yapp_project/tb` is a ready layout for Surfer with the
    input port, the three channels, the HBUS and the FSM state; the [Logs, timelines and
    waves](appendix/sim-report.md) page shows the pictures the report makes of them.

## The course material

??? question "The course writes `` `uvm_do_with `` and `` `uvm_field_int ``; this code does not — why?"
    On purpose: the macros hide the four steps of sending an item and the field automation hides
    `do_copy` / `do_compare` / `do_print`. This repository writes them out so that you can read
    what happens; [Getting started](getting-started.md#running-a-lab) lists the conventions.
    Both styles are legal UVM; in the exam and at work you will meet both.

??? question "Where is the Cadence lab PDF?"
    Not in this repository (it is not for distribution). Every lab page restates the objective,
    the steps and the expected result, and `start/TASKS.md` lists the steps per lab.
