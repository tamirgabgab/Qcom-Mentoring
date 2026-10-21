# Lab 6 — Connecting to the DUT using virtual interfaces — start point

This directory is where you work on Lab 6. It is the finished state of the lab before it (`labs/lab05_seq`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab06_vif/sv`, `labs/lab06_vif/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab06/

## Steps (from the lab page)

1. The interface — `sv/yapp_if.sv`
2. The typedef — `sv/yapp_pkg.sv`
3. Monitor — `sv/yapp_tx_monitor.sv`
4. Driver — `sv/yapp_tx_driver.sv`
5. Tests — drain time and `yapp_012_test`
6. Hardware top — `tb/hw_top.sv`
7. UVM top — `tb/tb_top.sv`
8. `tb/run.f`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/yapp_tx_driver.sv`
* `sv/yapp_tx_monitor.sv`
* `tb/tests/base_test.sv`
* `tb/tests/yapp_012_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/driver_example.sv`
* `sv/monitor_example.sv`
* `sv/yapp_defines.sv`
* `sv/yapp_if.sv`
* `tb/clkgen.sv`
* `tb/hw_top.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`
* `tb/tb_top.sv`
* `tb/yapp_router_instance.txt`

**Unchanged since the previous lab**: `sv/seqs/six_yapp_seq.sv`, `sv/seqs/yapp_012_seq.sv`, `sv/seqs/yapp_111_seq.sv`, `sv/seqs/yapp_1_seq.sv`, `sv/seqs/yapp_5_packets.sv`, `sv/seqs/yapp_base_seq.sv`, `sv/seqs/yapp_exhaustive_seq.sv`, `sv/seqs/yapp_incr_payload_seq.sv`, `sv/seqs/yapp_repeat_addr_seq.sv`, `sv/seqs/yapp_rnd_seq.sv`, `sv/short_yapp_packet.sv`, `sv/yapp_env.sv`, `sv/yapp_packet.sv`, `sv/yapp_pkg.sv`, `sv/yapp_tx_agent.sv`, `sv/yapp_tx_seqs.sv`, `sv/yapp_tx_sequencer.sv`, `tb/Makefile`, `tb/router_tb.sv`, `tb/tests/exhaustive_seq_test.sv`, `tb/tests/incr_payload_test.sv`, `tb/tests/set_config_test.sv`, `tb/tests/short_packet_test.sv`

## Run and check

```bash
cd labs/lab06_vif/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab06_vif START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=yapp_012_test
make gui TEST=yapp_012_test
```

**Expected:** three `TX pkt` lines from the driver and three `RX pkt … on the
input` lines from the monitor with the same address, length and parity (at
`UVM_HIGH` the full `Packet is` / `Packet collected` tables follow). In the waveform
viewer, `hw_top.in0.in_data` shows `H D D … P` for each packet and the same
bytes appear a few cycles later on `hw_top.dut.data_0`, then `data_1`, then
`data_2`. The transaction streams `Driver_YAPP_Packet` and
`Monitor_YAPP_Packet` show one bar per packet.
