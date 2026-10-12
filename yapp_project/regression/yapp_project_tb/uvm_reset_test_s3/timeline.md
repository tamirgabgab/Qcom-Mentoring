# uvm_reset_test  seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 520ns · log `uvm_reset_test_s3.log`

Waves: `uvm_reset_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 0.
- Router: **0** forwarded, **0** dropped.
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 0 write(s), 9 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | uvm_reg_hw_reset_seq: read every register through the front door and compare with its reset value |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

32 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: uvm_reg_hw_reset_seq: read every register through the front door and compare with its reset value |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 80 | hbus driver | Executed READ  addr=0x1000 data=0x3f |
| 85 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 110 | hbus driver | Executed READ  addr=0x1001 data=0x01 |
| 115 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 140 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 170 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 200 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 230 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 235 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 260 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 265 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 290 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 295 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 320 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 325 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 520 | ch0 monitor | Channel 0 report: 0 packets collected |
| 520 | ch1 monitor | Channel 1 report: 0 packets collected |
| 520 | ch2 monitor | Channel 2 report: 0 packets collected |
| 520 | hbus monitor | HBUS report: 0 writes, 9 reads |
| 520 | reference |  |
| 520 | scoreboard |  |
| 520 | yapp driver | YAPP driver report: 0 packets sent |
| 520 | yapp monitor | YAPP monitor report: 0 packets collected, coverage 0.0% |
| 520 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 0 longer (gap coverage 0.0%) |
