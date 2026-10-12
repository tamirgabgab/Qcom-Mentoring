# hbus_protocol_test  seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 790ns · log `hbus_protocol_test_s1.log`

Waves: `hbus_protocol_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 0.
- Router: **0** forwarded, **0** dropped.
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 11 write(s), 10 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | 1. raw HBUS write 0x2a to ctrl_reg, read it back, the monitor counts one of each |
| 115 | 2. after the read the DUT releases hdata (tri-state) |
| 125 | 3. 8 unmapped addresses: a write is ignored, a read returns 0x00 |
| 520 | 4. a raw write to the read-only parity_err_cnt_reg is ignored |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

65 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. raw HBUS write 0x2a to ctrl_reg, read it back, the monitor counts one of each |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x2a |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x2a |
| 75 | reference | maxpktsize is now 42 |
| 100 | hbus driver | Executed READ  addr=0x1000 data=0x2a |
| 105 | hbus monitor | Collected READ  addr=0x1000 data=0x2a |
| 115 | **test** | STAGE: 2. after the read the DUT releases hdata (tri-state) |
| 125 | **test** | hdata tri-stated after the read |
| 125 | **test** | STAGE: 3. 8 unmapped addresses: a write is ignored, a read returns 0x00 |
| 140 | hbus driver | Executed WRITE addr=0x1002 data=0xa5 |
| 145 | hbus monitor | Collected WRITE addr=0x1002 data=0xa5 |
| 170 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 190 | hbus driver | Executed WRITE addr=0x1003 data=0xa5 |
| 195 | hbus monitor | Collected WRITE addr=0x1003 data=0xa5 |
| 220 | hbus driver | Executed READ  addr=0x1003 data=0x00 |
| 225 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 240 | hbus driver | Executed WRITE addr=0x1007 data=0xa5 |
| 245 | hbus monitor | Collected WRITE addr=0x1007 data=0xa5 |
| 270 | hbus driver | Executed READ  addr=0x1007 data=0x00 |
| 275 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 290 | hbus driver | Executed WRITE addr=0x1008 data=0xa5 |
| 295 | hbus monitor | Collected WRITE addr=0x1008 data=0xa5 |
| 320 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 325 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 340 | hbus driver | Executed WRITE addr=0x100c data=0xa5 |
| 345 | hbus monitor | Collected WRITE addr=0x100c data=0xa5 |
| 370 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 375 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 390 | hbus driver | Executed WRITE addr=0x100e data=0xa5 |
| 395 | hbus monitor | Collected WRITE addr=0x100e data=0xa5 |
| 420 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 425 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 440 | hbus driver | Executed WRITE addr=0x100f data=0xa5 |
| 445 | hbus monitor | Collected WRITE addr=0x100f data=0xa5 |
| 470 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 490 | hbus driver | Executed WRITE addr=0x1050 data=0xa5 |
| 495 | hbus monitor | Collected WRITE addr=0x1050 data=0xa5 |
| 520 | hbus driver | Executed READ  addr=0x1050 data=0x00 |
| 520 | **test** | 8 unmapped addresses read 0x00 |
| 520 | **test** | STAGE: 4. a raw write to the read-only parity_err_cnt_reg is ignored |
| 525 | hbus monitor | Collected READ  addr=0x1050 data=0x00 |
| 540 | hbus driver | Executed WRITE addr=0x1004 data=0x77 |
| 545 | hbus monitor | Collected WRITE addr=0x1004 data=0x77 |
| 570 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 575 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 590 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 595 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 595 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 595 | reference | maxpktsize is now 63 |
| 790 | ch0 monitor | Channel 0 report: 0 packets collected |
| 790 | ch1 monitor | Channel 1 report: 0 packets collected |
| 790 | ch2 monitor | Channel 2 report: 0 packets collected |
| 790 | hbus monitor | HBUS report: 11 writes, 10 reads |
| 790 | reference |  |
| 790 | scoreboard |  |
| 790 | yapp driver | YAPP driver report: 0 packets sent |
| 790 | yapp monitor | YAPP monitor report: 0 packets collected, coverage 0.0% |
| 790 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 0 longer (gap coverage 0.0%) |
