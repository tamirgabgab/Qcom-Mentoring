# Shared per-lab Makefile. Every labs/<lab>/tb/Makefile just does
#     include ../../../common/lab.mk
#
#   make run  [TEST=<test>] [XRUN_OPTS="+SVSEED=random"]   batch simulation
#   make gui  [TEST=<test>]                                  SimVision, stop on constraint failure
#   make lint                                                slang elaboration check (no simulator)
#   make clean
XRUN      ?= xrun
TEST      ?= base_test
XRUN_OPTS ?=
LINT      := python3 ../../../scripts/lint.py

.PHONY: run gui lint clean

run:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

gui:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) -gui -access +rwc $(XRUN_OPTS)

lint:
	$(LINT) run.f

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history *.shm cov_work .simvision *.key *.err
