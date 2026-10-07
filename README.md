# YAPP Router — SystemVerilog & UVM course

A complete, from-scratch reference implementation of the **YAPP packet-router
verification project** (the exercise behind the *SystemVerilog Accelerated
Verification Using UVM* training), written for mentoring:

* the **complete project** (`yapp_project/`): the DUT, every UVC and the final
  testbench with all tests — the state the course reaches at the end of Lab 11C;
* the **DUT** (`yapp_project/rtl/`, one module per file: `yapp_router.sv`,
  `yapp_input_fsm.sv`, `yapp_output_channel.sv`, `yapp_fifo.sv`,
  `yapp_hbus_regs.sv`, `yapp_error_timer.sv`), written from the specification;
* four **UVCs** — YAPP input, HBUS, Channel, Clock & Reset — plus the router
  **module UVC** (scoreboard, reference model, analysis-FIFO scoreboard), in
  `yapp_project/uvc/`;
* **every lab, 1 → 11C**, as a snapshot in `labs/` with `run.f` and `Makefile`
  (Labs 7+ compile the UVCs and the DUT from `yapp_project/`), including the
  optional labs and a hand-written UVM **register model**;
* a **teaching site** (`docs/`, MkDocs Material) with architecture diagrams,
  protocol waveforms, one guide per component, a test plan and one page per
  lab with the solution, expected results and checkpoint questions;
* an **interactive project map** (`docs/project-map.md`, also a single offline
  file `docs/downloads/yapp_project_map.html`): hierarchy with drill-down, TLM
  data flow and UML class views, generated from the SystemVerilog with pyslang
  (`scripts/project_map/`), with the role, source and lab of every block;
* a **lint harness** (`scripts/lint.py`, slang + Accellera UVM) that
  elaborates every lab without a simulator, run in CI.

## Quick start

```bash
# install check (Cadence Xcelium)
cd test_install && xrun -f run.f

# run the complete project (any test of yapp_project/tb/tests)
cd yapp_project/tb && make run TEST=reg_function_test

# run a lab
cd labs/lab07_integ/tb && make run TEST=simple_test

# lint everything without a simulator
pip install pyslang && make lint

# read / build the docs
pip install mkdocs-material && make serve

# regenerate the interactive project map after changing the code
pip install pyslang pyyaml jinja2 && make map
```

## Layout

```
yapp_project/         the complete project (source of truth)
  rtl/                  DUT, one module per file + yapp_router.f file list
  uvc/                  yapp/ hbus/ channel/ clock_and_reset/ router/ (one class per file, seqs/ for the sequences)
  tb/                   final testbench: tests/, mcseqs/, reg/, run.f, Makefile
labs/lab01_data … lab11c_rm_sim                 one snapshot per lab (Labs 7+ reuse yapp_project/uvc and rtl)
test_install/         UVM installation check
common/               uvm_version_compat.svh (1.1d / 1.2 shim), lab.mk
scripts/              lint.py, get_uvm.sh, gen_waves.py, project_map/ (extract, model, layout, build)
docs/ mkdocs.yml      the site
```

Simulator target: Cadence Xcelium with `-uvmhome CDNS-1.1d` (or `CDNS-1.2`).
The code has been elaborated with slang against the UVM source but not yet
simulated — see `docs/appendix/unverified.md` for what to confirm on a real run.

Coding style: one class per file, `extern` prototypes in the class and the
method bodies after `endclass`; no `uvm_do*` macros (sequences write
`start_item` / `randomize` / `finish_item` and `seq.start(...)` themselves)
and no `uvm_field_*` automation (`do_print`, `do_copy`, `do_compare`, … are
written by hand; components read their configuration with
`uvm_config_int::get`).

No Cadence material is included: the DUT, the "provided" UVCs, the interfaces
and the register model were all written for this repository.
