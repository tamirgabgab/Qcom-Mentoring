XRUN ?= xrun

.PHONY: run_test lint clean

run_test:
	$(XRUN) -f run.f

lint:
	python3 ../../scripts/lint.py run.f

clean:
	rm -rf xcelium.d INCA_libs xrun.log xrun.history *.shm
