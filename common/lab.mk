# Shared Makefile for every simulation directory. labs/<lab>/tb/Makefile does
#     include ../../../common/lab.mk
# and yapp_project/tb/Makefile does
#     include ../../common/lab.mk
#
#   make run  [TEST=<test>] [XRUN_OPTS="+SVSEED=random"]   batch simulation
#   make gui  [TEST=<test>]                                  SimVision, stop on constraint failure
#   make lint                                                slang elaboration check (no simulator)
#   make clean
XRUN      ?= xrun
TEST      ?= base_test
XRUN_OPTS ?=
ROOT      := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
LINT      := python3 $(ROOT)/scripts/lint.py

.PHONY: run gui lint clean

run:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

gui:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) -gui -access +rwc $(XRUN_OPTS)

lint:
	$(LINT) run.f

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history *.shm cov_work .simvision *.key *.err
