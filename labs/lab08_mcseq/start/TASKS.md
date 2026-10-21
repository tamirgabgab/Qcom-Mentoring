# Lab 8 — Multichannel sequences and system-level tests — start point

This directory is where you work on Lab 8. It is the finished state of the lab before it (`labs/lab07_integ`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab08_mcseq/sv`, `labs/lab08_mcseq/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab08/

## Steps (from the lab page)

1. `tb/router_mcsequencer.sv`
2. `tb/router_mcseqs_lib.sv`
3. `router_tb`: build and connect
4. The test
5. Include order in `tb_top.sv`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `tb/mcseqs/router_mcseq_base.sv`
* `tb/mcseqs/router_simple_mcseq.sv`
* `tb/router_tb.sv`
* `tb/tests/router_simple_mcseq_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `tb/router_mcseqs_lib.sv`
* `tb/router_mcsequencer.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tb_top.sv`

**Unchanged since the previous lab**: `tb/Makefile`, `tb/hw_top.sv`, `tb/tests/base_test.sv`, `tb/tests/simple_test.sv`, `tb/tests/test_uvc_integration.sv`

## Run and check

```bash
cd labs/lab08_mcseq/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab08_mcseq START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=router_simple_mcseq_test
```

**Expected:** in this order in the log —

```
[hbus_small_packet_seq] Executing ...
[hbus_monitor] Collected WRITE addr=0x1000 data=0x14
[hbus_monitor] Collected WRITE addr=0x1001 data=0x01
[hbus_read_max_pkt_seq] MAXPKTSIZE register reads 20
[yapp_012_seq] Executing ...  (×2, six packets, channel monitors echo them)
[hbus_monitor] Collected WRITE addr=0x1000 data=0x3f
[hbus_read_max_pkt_seq] MAXPKTSIZE register reads 63
[yapp_rnd_seq] Executing yapp_rnd_seq sequence (6 packets)
```

12 YAPP packets in total, 12 channel packets, `UVM_ERROR : 0`.
