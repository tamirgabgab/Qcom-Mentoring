# Mentor's guide

One page per session of the course, for whoever teaches it: what the session is for, what to have open
before it starts, how to spend the time, what to show live, the mistakes students make at that point
and the questions to ask. The [labs overview](../labs/index.md) has the session plan and the dependency
chain; every lab page has the objective, the steps, the expected result and the checkpoint questions
with their answers; this guide is the layer above them.

| Session | Labs | Page |
|---|---|---|
| 1 | 1, 2 | [Data items, components, phases](session-1.md) |
| 2 | 3, 4 | [A UVC, the factory, configuration](session-2.md) |
| 3 | 5 | [Sequences](session-3.md) |
| 4 | 6 | [Interfaces and the DUT](session-4.md) |
| 5 | 7, 8 | [Integrating UVCs, the virtual sequencer](session-5.md) |
| 6 | 9A–9D | [TLM, scoreboard, reference model](session-6.md) |
| 7 | 10 | [Functional coverage](session-7.md) |
| 8 | 11A–11C | [The register model](session-8.md) |

## Before the first session

* Every student opens the repository in a [Codespace](https://codespaces.new/tamirgabgab/Qcom-Mentoring?quickstart=1)
  (or runs `bash scripts/setup_sim.sh` on her own Ubuntu / WSL2) and runs `make sim` in `test_install`.
  Verilator is the simulator of the course; Xcelium is the alternative for those who have it.
* The student kit (`make student-kit` → `build/StudentKit.zip`) holds the `start/` directory of every
  lab, the offline site and the project map, for a machine without internet.
* Students work in `labs/<lab>/start/` ([Getting started](../getting-started.md#working-on-a-lab-start-and-make-check)),
  check with `make check LAB=<lab> START=1`, and compare with the finished lab next to it only after
  the check is green -- or when stuck for more than the time you set.

## What to have open in every session

* The [project map](../project-map.md) on a second screen: the Environment view for "where are we",
  the Hierarchy view for a component, the Classes view for inheritance, the Test plan for "why this
  test". Every lab page starts with a deep link into the map at the right place.
* A terminal in the lab's `tb/` (the finished lab) for the live run, and the log of the previous
  regression ([Regression results](../regression/index.md)) when the simulation is slow.
* The [glossary](../glossary.md) and the [FAQ](../faq.md) for the questions that are not about the lab.

## Shape of a session

Three hours work well as *concept (30 min) → lab (90 min, in `start/`) → review (30 min) →
checkpoint questions and the next lab's objective (30 min)*. The lab pages carry the concept
diagrams; the review is the moment to open the finished lab and the map side by side and walk the
code top-down. Every session page below says what to put in each slot.
