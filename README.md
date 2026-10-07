# YAPP Router — SystemVerilog & UVM course

A complete, from-scratch reference implementation of the **YAPP packet-router
verification project** (the exercise behind the *SystemVerilog Accelerated
Verification Using UVM* training), written for mentoring:

* the **DUT** (`router_rtl/yapp_router.sv`), written from the specification;
* four **UVCs** — YAPP input, HBUS, Channel, Clock & Reset — plus the router
  **module UVC** (scoreboard, reference model, analysis-FIFO scoreboard);
* **every lab, 1 → 11C**, as a self-contained snapshot in `labs/` with `run.f`
  and `Makefile`, including the optional labs and a hand-written UVM
  **register model**;
* a **teaching site** (`docs/`, MkDocs Material) with architecture diagrams,
  protocol waveforms, one guide per component, a test plan and one page per
  lab with the solution, expected results and checkpoint questions;
* a **lint harness** (`scripts/lint.py`, slang + Accellera UVM) that
  elaborates every lab without a simulator, run in CI.

## Quick start

```bash
# install check (Cadence Xcelium)
cd test_install && xrun -f run.f

# run a lab
cd labs/lab07_integ/tb && make run TEST=simple_test

# lint everything without a simulator
pip install pyslang && make lint

# read / build the docs
pip install mkdocs-material && make serve
```

## Layout

```
router_rtl/           DUT
yapp/ hbus/ channel/ clock_and_reset/ router/   UVCs (sv/ in each)
labs/lab01_data … lab11c_rm_sim                 one snapshot per lab
test_install/         UVM installation check
common/               uvm_version_compat.svh (1.1d / 1.2 shim), lab.mk
scripts/              lint.py, get_uvm.sh, gen_waves.py
docs/ mkdocs.yml      the site
```

Simulator target: Cadence Xcelium with `-uvmhome CDNS-1.1d` (or `CDNS-1.2`).
The code has been elaborated with slang against the UVM source but not yet
simulated — see `docs/appendix/unverified.md` for what to confirm on a real run.

No Cadence material is included: the DUT, the "provided" UVCs, the interfaces
and the register model were all written for this repository.
