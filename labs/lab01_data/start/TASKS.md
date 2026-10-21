# Lab 1 — Creating a stimulus model — start point

This directory is where you work on Lab 1: the classes keep their prototypes, you write the bodies. The finished solution is one directory up (`labs/lab01_data/sv`, `labs/lab01_data/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab01/

## Steps (from the lab page)

1. `sv/yapp_packet.sv`
2. `sv/yapp_pkg.sv`
3. `tb/top.sv`
4. `tb/run.f`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/yapp_packet.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/yapp_defines.sv`
* `sv/yapp_pkg.sv`
* `tb/run.f`
* `tb/top.sv`

**Unchanged since the previous lab**: `tb/Makefile`

## Run and check

```bash
cd labs/lab01_data/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab01_data START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
cd labs/lab01_data/tb && make run
```

**Expected:** five packet tables. Every `m_addr` is 0, 1 or 2; `m_payload` has
exactly `m_length` entries; about one packet in six shows `PARITY_TYPE_BAD` with a
parity byte that differs from the XOR of the other bytes. Then the optional
section prints `copy compare -> 1`, `clone compare -> 1`, a miscompare
message for the modified clone, and the same packet in table and tree layout.
