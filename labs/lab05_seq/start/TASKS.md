# Lab 5 — Generating UVM sequences — start point

This directory is where you work on Lab 5. It is the finished state of the lab before it (`labs/lab04_factory`) plus the files this lab adds or changes with their method bodies emptied: every class keeps its prototypes, you write the bodies. The finished solution is one directory up (`labs/lab05_seq/sv`, `labs/lab05_seq/tb`); the lab page explains every step: https://tamirgabgab.github.io/Qcom-Mentoring/labs/lab05/

## Steps (from the lab page)

1. The library — `sv/yapp_tx_seqs.sv`
2. The tests

## Files

**To write** (the methods and constraints that are new or changed in this lab have a `// TODO` body; the comments of the finished bodies are left as hints, the rest of the file is given):

* `sv/seqs/six_yapp_seq.sv`
* `sv/seqs/yapp_012_seq.sv`
* `sv/seqs/yapp_111_seq.sv`
* `sv/seqs/yapp_1_seq.sv`
* `sv/seqs/yapp_exhaustive_seq.sv`
* `sv/seqs/yapp_incr_payload_seq.sv`
* `sv/seqs/yapp_repeat_addr_seq.sv`
* `sv/seqs/yapp_rnd_seq.sv`
* `tb/tests/exhaustive_seq_test.sv`
* `tb/tests/incr_payload_test.sv`

**Changed in this lab but given** (modules, interfaces, packages, command files and copied models are not where the lab's work is; compare them with the previous lab to see what changed):

* `sv/short_yapp_packet.sv`
* `sv/yapp_tx_seqs.sv`
* `tb/router_test_lib.sv`
* `tb/run.f`

**Unchanged since the previous lab**: `sv/seqs/yapp_5_packets.sv`, `sv/seqs/yapp_base_seq.sv`, `sv/yapp_defines.sv`, `sv/yapp_env.sv`, `sv/yapp_packet.sv`, `sv/yapp_pkg.sv`, `sv/yapp_tx_agent.sv`, `sv/yapp_tx_driver.sv`, `sv/yapp_tx_monitor.sv`, `sv/yapp_tx_sequencer.sv`, `tb/Makefile`, `tb/router_tb.sv`, `tb/tests/base_test.sv`, `tb/tests/set_config_test.sv`, `tb/tests/short_packet_test.sv`, `tb/top.sv`

## Run and check

```bash
cd labs/lab05_seq/start/tb
make sim TEST=<test>            # Verilator (free): PASS / FAIL at the end
make run TEST=<test>            # Xcelium
make check LAB=lab05_seq START=1    # from the repository root: every test of the lab against what the log must show
```

What the lab page says about running it:

```bash
make run TEST=incr_payload_test XRUN_OPTS=+UVM_VERBOSITY=UVM_FULL
make run TEST=exhaustive_seq_test
make gui TEST=exhaustive_seq_test        # SimVision: -gui -access rwc
```

**Expected:** `incr_payload_test` prints one short packet whose payload reads
`0 1 2 3 …`; at `UVM_FULL` you can see `Starting default sequence
yapp_incr_payload_seq`. `exhaustive_seq_test` prints one `Executing …` line
per sequence and 1 + 3 + 3 + 2 + 1 + *count* + 6 packets, no warnings.
