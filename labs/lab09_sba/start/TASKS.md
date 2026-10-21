# Lab 9A — Creating a scoreboard using TLM — start point

This directory is where you work on Lab 9A. It is the finished state of the lab before it (`labs/lab08_mcseq`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab09_sba/sv`, `labs/lab09_sba/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab09a/

## Steps (from the lab page)

1. Analysis port in the YAPP monitor (`yapp_project/uvc/yapp/yapp_tx_monitor.sv`)
2. The scoreboard — `sv/router_scoreboard.sv`
3. The comparison — `sv/packet_compare.sv` (included in the class)
4. `router_tb`: build and connect

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/router_scoreboard.sv`
* `tb/router_tb.sv`
* `tb/tests/router_simple_mcseq_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/packet_compare.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tb_top.sv`
* `tb/tests/scoreboard_drop_test.sv`

**Unchanged since the previous lab**: `tb/Makefile`, `tb/hw_top.sv`, `tb/mcseqs/router_mcseq_base.sv`, `tb/mcseqs/router_simple_mcseq.sv`, `tb/router_mcseqs_lib.sv`, `tb/router_mcsequencer.sv`, `tb/tests/base_test.sv`, `tb/tests/simple_test.sv`, `tb/tests/test_uvc_integration.sv`

## Run and check

```bash
cd labs/lab09_sba/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab09_sba START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=router_simple_mcseq_test    # legal traffic
make run TEST=scoreboard_drop_test        # negative check (step 7)
```

**Expected, `router_simple_mcseq_test`:**

```
--- Scoreboard report ---
  packets received  : 12
  packets matched   : 12
  packets mismatched: 0
  packets unexpected: 0
  left in queue 0/1/2: 0 / 0 / 0
```

**Expected, `scoreboard_drop_test`** (no short-packet override, `maxpktsize`
= 20 during the first six packets): `yapp_packet` tables with random
lengths; `ROUTER DROPS PACKET … length > maxpktsize` for every packet longer
than 20; `UVM_ERROR … [PKT_COMPARE] Length mismatch` / `… MISMATCH` when the
next packet on that channel is compared against the dropped one; at the end
`packets received == matched + mismatched + left in queues`.
