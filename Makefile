# ---------------------------------------------------------------------------
# YAPP router UVM course -- top-level helper Makefile
#
#   make lint                 lint every lab with slang (no simulator needed)
#   make lint LAB=lab05_seq   lint one lab
#   make style                reformat every .sv to the course style (scripts/sv_style.py)
#   make style-check          verify the code style (CI)
#   make run LAB=lab05_seq TEST=exhaustive_seq_test   run one lab test with xrun
#   make run-project TEST=reg_function_test      run a test of the complete project (yapp_project/tb)
#   make setup-sim            install Verilator + UVM for the free flow (scripts/setup_sim.sh)
#   make sim LAB=lab07_integ TEST=simple_test [WAVES=1]   run one lab test with Verilator
#   make sim-project TEST=reg_function_test [WAVES=1]     run a project test with Verilator
#   make regress              every lab and test with Verilator (scripts/regress.yaml) [SEEDS=3] [ONLY=lab09]
#   make docs                 build the teaching site into site/
#   make serve                serve the teaching site locally
#   make map                  regenerate the interactive project map (pyslang + pyyaml + jinja2)
#   make map-check            verify the committed project map is up to date (CI)
#   make map-export           export every map view to SVG/PNG/PDF (node + playwright)
#   make readme-shots         retake the README screenshots (site build + node + playwright)
#   make clean                remove simulator output in every lab
# ---------------------------------------------------------------------------
PYTHON    ?= python3
XRUN      ?= xrun
XRUN_OPTS ?=
LAB       ?=
TEST      ?= base_test
WAVES     ?=
SEEDS     ?=
ONLY      ?=
SIM       := $(PYTHON) scripts/sim.py

.PHONY: help lint style style-check uvm-src run run-project setup-sim sim sim-project regress docs serve map map-check map-export readme-shots clean

help:
	@sed -n '2,21p' $(MAKEFILE_LIST)

uvm-src:
	@bash scripts/get_uvm.sh

lint: uvm-src
ifeq ($(LAB),)
	$(PYTHON) scripts/lint.py --all
else
	$(PYTHON) scripts/lint.py labs/$(LAB)/tb/run.f
endif

style:
	$(PYTHON) scripts/sv_style.py --fix

style-check:
	$(PYTHON) scripts/sv_style.py --check

run:
ifeq ($(LAB),)
	$(error usage: make run LAB=lab05_seq TEST=exhaustive_seq_test)
endif
	cd labs/$(LAB)/tb && $(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

run-project:
	cd yapp_project/tb && $(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

setup-sim:
	bash scripts/setup_sim.sh

sim:
ifeq ($(LAB),)
	$(error usage: make sim LAB=lab07_integ TEST=simple_test [WAVES=1])
endif
	$(SIM) run labs/$(LAB)/tb -t $(TEST) $(if $(WAVES),--waves)

sim-project:
	$(SIM) run yapp_project/tb -t $(TEST) $(if $(WAVES),--waves)

regress: uvm-src
	$(SIM) regress $(if $(SEEDS),--seeds $(SEEDS)) $(foreach o,$(ONLY),--only $(o))

docs:
	mkdocs build --strict

map: uvm-src
	$(PYTHON) -m scripts.project_map.build

map-check: uvm-src
	$(PYTHON) -m scripts.project_map.build --check

map-export:
	node scripts/project_map/export.mjs

readme-shots: docs
	node scripts/readme_shots.mjs

serve:
	mkdocs serve

clean:
	find . -type d \( -name xcelium.d -o -name INCA_libs -o -name '*.shm' -o -name cov_work \) -prune -exec rm -rf {} +
	find . -type f \( -name xrun.log -o -name xrun.history -o -name '*.key' \) -delete
	rm -rf site build
