# Shared Makefile for every simulation directory. labs/<lab>/tb/Makefile does
#     include ../../../common/lab.mk
# and yapp_project/tb/Makefile does
#     include ../../common/lab.mk
#
#   make run  [TEST=<test>] [XRUN_OPTS="+SVSEED=random"]   batch simulation
#   make gui  [TEST=<test>]                                  SimVision, stop on constraint failure
#   make lint                                                slang elaboration check (no simulator)
#   make clean
#
# Free flow with Verilator (scripts/sim.py, install with scripts/setup_sim.sh):
#   make compile                                             build the simulation (build/sim/<dir>/)
#   make sim  [TEST=<test>] [WAVES=1] [SEED=<n>|random]       run one test, PASS/FAIL at the end
#   make waves [TEST=<test>]                                 open the waves of the last WAVES=1 run
XRUN      ?= xrun
TEST      ?= base_test
XRUN_OPTS ?=
ROOT      := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
LINT      := python3 $(ROOT)/scripts/lint.py
SIM       := python3 $(ROOT)/scripts/sim.py
WAVES     ?=
SEED      ?= 1
SIM_OPTS  ?=

.PHONY: run gui lint clean compile sim waves

run:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) $(XRUN_OPTS)

gui:
	$(XRUN) -f run.f +UVM_TESTNAME=$(TEST) -gui -access +rwc $(XRUN_OPTS)

lint:
	$(LINT) run.f

compile:
	$(SIM) compile .

sim:
	$(SIM) run . -t $(TEST) --seed $(SEED) $(if $(WAVES),--waves) $(SIM_OPTS)

waves:
	$(SIM) waves . -t $(TEST)

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history *.shm cov_work .simvision *.key *.err
