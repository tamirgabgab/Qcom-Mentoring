# ---------------------------------------------------------------------------
# YAPP router UVM course -- top-level helper Makefile
#
#   make lint                 lint every lab with slang (no simulator needed)
#   make lint LAB=lab05_seq   lint one lab
#   make run LAB=lab05_seq TEST=exhaustive_seq_test   run one test with xrun
#   make docs                 build the teaching site into site/
#   make serve                serve the teaching site locally
#   make clean                remove simulator output in every lab
# ---------------------------------------------------------------------------
PYTHON    ?= python3
XRUN      ?= xrun
XRUN_OPTS ?=
LAB       ?=
TEST      ?= base_test

.PHONY: help lint uvm-src run docs serve clean

help:
	@sed -n '2,11p' $(MAKEFILE_LIST)

uvm-src:
	@bash scripts/get_uvm.sh

lint: uvm-src
ifeq ($(LAB),)
	$(PYTHON) scripts/lint.py --all
else
	$(PYTHON) scripts/lint.py labs/$(LAB)/tb/run.f
endif

run:
ifeq ($(LAB),)
	$(error usage: make run LAB=lab05_seq TEST=exhaustive_seq_test)
endif
	cd labs/$(LAB)/tb && $(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

docs:
	mkdocs build --strict

serve:
	mkdocs serve

clean:
	find . -type d \( -name xcelium.d -o -name INCA_libs -o -name '*.shm' -o -name cov_work \) -prune -exec rm -rf {} +
	find . -type f \( -name xrun.log -o -name xrun.history -o -name '*.key' \) -delete
	rm -rf site
