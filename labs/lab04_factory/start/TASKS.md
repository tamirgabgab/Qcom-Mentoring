# Lab 4 — Using factories — start point

This directory is where you work on Lab 4. It is the finished state of the lab before it (`labs/lab03_uvc`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab04_factory/sv`, `labs/lab04_factory/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab04/

## Steps (from the lab page)

1. `new()` → `type_id::create()`
2. `short_yapp_packet` — `sv/short_yapp_packet.sv`
3. The tests — `tb/router_test_lib.sv`
4. The testbench — `tb/router_tb.sv`

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/short_yapp_packet.sv`
* `sv/yapp_env.sv`
* `sv/yapp_tx_agent.sv`
* `tb/router_tb.sv`
* `tb/tests/base_test.sv`
* `tb/tests/set_config_test.sv`
* `tb/tests/short_packet_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/yapp_pkg.sv`
* `sv/yapp_tx_driver.sv`
* `sv/yapp_tx_monitor.sv`
* `sv/yapp_tx_sequencer.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `sv/seqs/yapp_5_packets.sv`, `sv/seqs/yapp_base_seq.sv`, `sv/yapp_defines.sv`, `sv/yapp_packet.sv`, `sv/yapp_tx_seqs.sv`, `tb/Makefile`, `tb/top.sv`

## Run and check

```bash
cd labs/lab04_factory/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab04_factory START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run                            # base_test: 5 packets, same as Lab 3
make run TEST=short_packet_test     # 5 packets of type short_yapp_packet
make run TEST=set_config_test       # passive agent, nothing runs
```

**Expected:**

* `short_packet_test`: every `TX pkt` line has `len` < 15 and never
  `addr=2`; at `UVM_HIGH` each `Packet is` table starts with `short_yapp_packet`.
* `set_config_test`: topology shows `tb.yapp.agent` with `is_active
  UVM_PASSIVE` and only a `monitor` below it. **No** configuration-usage
  report at the end.
