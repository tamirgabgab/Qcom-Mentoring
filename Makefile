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
#   make regress              every lab and test with Verilator (scripts/regress.yaml, its seeds) [SEEDS=3 for all] [ONLY=lab09] [WAVES=1]
#   make sim-report           bundle the logs of the last regression: one folder per run with the log,
#                             a timeline, the waves and wave pictures (scripts/sim_report.py) [ONLY=yapp_project]
#                             [OUT=yapp_project/regression] writes the committed report of the project;
#                             also coverage.md, the functional coverage merged over every run (+ HTML)
#   make coverage             print the merged functional coverage of the last regression and its holes
#                             (scripts/coverage_report.py) [ONLY=yapp_project]
#   make docs                 build the teaching site into site/
#   make docs-pdf             the site as one PDF (offline/QcomCourse.pdf)
#   make student-kit          build/StudentKit.zip: labs/*/start, the offline site, the map, the PDF
#   make docs-offline         build the teaching site as a folder that opens from disk (no server, no internet):
#                             offline/site/index.html (committed) and build/QcomCourseSite.zip (needs npm once)
#   make serve                serve the teaching site locally
#   make map                  regenerate the interactive project map (pyslang + pyyaml + jinja2)
#   make map-check            verify the committed project map is up to date (CI)
#   make map-export           export every map view to SVG/PNG/PDF (node + playwright)
#   make readme-shots         retake the README screenshots (site build + node + playwright)
#   make start                regenerate labs/<lab>/start/ (the student's start point of every lab); make start-check compares
#   make check LAB=lab05_seq [START=1] [TEST=t]   run the tests of a lab in Verilator and check what the logs show
#   make bug-hunt [MUTANT=BUG_X]   compile the design with each deliberate bug and see which tests catch it
#   make see-it-run           regenerate the log excerpts of the lab pages from the last regression
#   make check-fresh          the committed regression report (and bug hunt) match regress.yaml / mutants.yaml
#   make hooks                install the pre-commit hook (.githooks: style check of staged .sv + reminders)
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

.PHONY: help lint style style-check uvm-src run run-project setup-sim sim sim-project regress sim-report coverage docs docs-offline serve map map-check map-export readme-shots check-fresh hooks start start-check check see-it-run bug-hunt docs-pdf student-kit clean

help:
	@awk 'NR > 1 && /^# ---/ { exit } NR > 1' $(MAKEFILE_LIST)

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
	$(SIM) regress $(if $(SEEDS),--seeds $(SEEDS)) $(foreach o,$(ONLY),--only $(o)) $(if $(WAVES),--waves)

sim-report:
	$(PYTHON) scripts/sim_report.py $(foreach o,$(ONLY),--only $(o)) $(if $(OUT),--out $(OUT)) --zip

coverage:
	$(PYTHON) scripts/coverage_report.py $(foreach o,$(ONLY),--only $(o))

docs:
	mkdocs build --strict

# the course site as a folder that opens from disk: build/offline/site/index.html + build/QcomCourseSite.zip
docs-offline:
	$(PYTHON) scripts/build_offline_site.py

# the whole site as one printable PDF: offline/QcomCourse.pdf (mkdocs-print-site-plugin + Playwright)
docs-pdf:
	$(PYTHON) scripts/build_pdf.py

# what a student gets on day one: build/StudentKit.zip (the start/ of every lab, the offline site, the map, the PDF)
student-kit:
	$(PYTHON) scripts/student_kit.py

map: uvm-src
	$(PYTHON) -m scripts.project_map.build

map-check: uvm-src
	$(PYTHON) -m scripts.project_map.build --check

map-export:
	node scripts/project_map/export.mjs

readme-shots: docs
	node scripts/readme_shots.mjs

# the start point of every lab for a student: labs/<lab>/start/ (committed; `lint` elaborates them too)
start:
	$(PYTHON) scripts/make_start.py

start-check:
	$(PYTHON) scripts/make_start.py --check

# every test of a lab (or of the project) in Verilator, each checked against what its log must show
check: uvm-src
ifeq ($(LAB),)
	$(error usage: make check LAB=lab05_seq [START=1]   or   make check LAB=yapp_project)
endif
	$(SIM) check $(LAB) $(if $(START),--start) $(if $(TEST),-t $(TEST))

# the bug hunt: every mutant of scripts/mutants.yaml against every project test (~1 h; writes docs/assets/generated/bug_hunt.json)
bug-hunt: uvm-src
	$(PYTHON) scripts/bug_hunt.py $(foreach m,$(MUTANT),--mutant $(m))

# the "See it run" excerpts of the lab pages, from the logs of the last `make regress` (committed)
see-it-run:
	$(PYTHON) scripts/see_it_run.py

# the committed artifacts (regression report, bug hunt) still match their sources; the `fresh` workflow also rebuilds offline/site
check-fresh:
	$(PYTHON) scripts/check_fresh.py

# git runs .githooks/pre-commit on every commit: style check of the staged .sv files + reminders
hooks:
	git config core.hooksPath .githooks
	@echo "pre-commit hook installed (.githooks/pre-commit)"

serve:
	mkdocs serve

clean:
	find . -type d \( -name xcelium.d -o -name INCA_libs -o -name '*.shm' -o -name cov_work \) -prune -exec rm -rf {} +
	find . -type f \( -name xrun.log -o -name xrun.history -o -name '*.key' \) -delete
	rm -rf site build
