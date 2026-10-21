# Lab 3 — Creating a simple UVC — start point

This directory is where you work on Lab 3. It is the finished state of the lab before it (`labs/lab02_test`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab03_uvc/sv`, `labs/lab03_uvc/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab03/

## Steps (from the lab page)

1. Driver — `sv/yapp_tx_driver.sv`
2. Sequencer — `sv/yapp_tx_sequencer.sv`
3. Monitor — `sv/yapp_tx_monitor.sv`
4. Agent — `sv/yapp_tx_agent.sv`
5. Env — `sv/yapp_env.sv`
6. The provided sequences — `sv/yapp_tx_seqs.sv`
7. Package include order — `sv/yapp_pkg.sv`
8. Testbench and test

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/seqs/yapp_5_packets.sv`
* `sv/seqs/yapp_base_seq.sv`
* `sv/yapp_env.sv`
* `sv/yapp_tx_agent.sv`
* `sv/yapp_tx_driver.sv`
* `sv/yapp_tx_monitor.sv`
* `sv/yapp_tx_sequencer.sv`
* `tb/router_tb.sv`
* `tb/tests/base_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/yapp_pkg.sv`
* `sv/yapp_tx_seqs.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `sv/yapp_defines.sv`, `sv/yapp_packet.sv`, `tb/Makefile`, `tb/router_test_lib.sv`, `tb/tests/test2.sv`, `tb/top.sv`

## Run and check

```bash
cd labs/lab03_uvc/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab03_uvc START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run                                        # base_test, 5 packets
make run XRUN_OPTS="+SVSEED=random"             # different packets
make run XRUM_OPTS="+UVM_VERBOSITY=UVM_HIGH"    # see the start_of_simulation messages
```

**Expected:** the topology now shows `tb.yapp.agent.{driver,monitor,sequencer}`
with `is_active UVM_ACTIVE`; then `Executing yapp_5_packets sequence`, the
monitor's "Inside the monitor run_phase", and five `TX pkt #n: addr=… len=…`
lines from the driver, 10 ns apart (at `+UVM_VERBOSITY=UVM_HIGH` each one is
followed by the full `Packet is` table).
