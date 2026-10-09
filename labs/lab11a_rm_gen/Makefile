XRUN ?= xrun

.PHONY: run_test lint clean compile sim

# Verilator flow (scripts/sim.py): build, then run the quick test
compile:
	python3 ../../scripts/sim.py compile .

sim:
	python3 ../../scripts/sim.py run .

run_test:
	$(XRUN) -f run.f

lint:
	python3 ../../scripts/lint.py run.f

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history *.shm
