# Lab 7 — Integrating multiple UVCs — start point

This directory is where you work on Lab 7. It is the finished state of the lab before it (`labs/lab06_vif`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab07_integ/sv`, `labs/lab07_integ/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab07/

## Steps (from the lab page)

1. `tb/router_tb.sv`
2. `tb/hw_top.sv`
3. `tb/tb_top.sv`
4. `tb/run.f` — one incdir, one package, one interface per UVC
5. Tests

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/router_tb.sv`
* `tb/tests/base_test.sv`
* `tb/tests/simple_test.sv`
* `tb/tests/test_uvc_integration.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/hw_top.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tb_top.sv`

**Unchanged since the previous lab**: `tb/Makefile`

## Run and check

```bash
cd labs/lab07_integ/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab07_integ START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=base_test            # topology only -- save it, later labs need the paths
make run TEST=simple_test
make gui TEST=simple_test          # add YAPP + channel monitor transactions to the waveform
make run TEST=test_uvc_integration # optional
```

**Expected for `simple_test`:** `clk10_rst5_seq` starts the clock and holds
reset 5 cycles; `yapp_012_seq` sends three short packets; each channel
monitor prints exactly one `Channel N collected packet` whose fields equal the
YAPP packet with `m_addr == N`; the channel reports say `1 packets collected`
each.

**Expected for `test_uvc_integration`:** HBUS `WRITE addr=0x1000 data=0x14`
and `0x1001 data=0x01`; 88 packets; `ROUTER DROPS PACKET … length > maxpktsize`
for lengths 21 and 22, `… illegal address` for every address-3 packet; `error`
pulses in the waveform after bad-parity packets; the channel monitors together
collect 3 × 20 = 60 packets.
