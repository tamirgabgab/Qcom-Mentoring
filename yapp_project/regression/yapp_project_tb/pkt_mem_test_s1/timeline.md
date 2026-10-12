# pkt_mem_test  seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 2us · log `pkt_mem_test_s1.log`

Waves: `pkt_mem_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.

## Summary

- YAPP driver sent **2** packet(s) (0 with bad parity); the input monitor saw 2.
- Router: **1** forwarded, **1** dropped (1 oversized).
- Packets out: ch0 **0**, ch1 **1**, ch2 **0**.
- Scoreboard: 1 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 3 write(s), 34 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | 1. one packet (addr 1, 20 bytes): mem_size_reg and yapp_pkt_mem hold it byte by byte |
| 1140 | 2. a raw HBUS write to yapp_pkt_mem[0] is ignored (read-only memory) |
| 1190 | 3. ctrl_reg=5, then a 9-byte packet: dropped as oversized but still stored |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 1**

![first packet out on channel 1](wave_first_packet_out.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

116 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. one packet (addr 1, 20 bytes): mem_size_reg and yapp_pkt_mem hold it byte by byte |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 50 | yapp driver | TX pkt #1: addr=1 len=20 parity=good delay=20 |
| 265 | **DUT** | IN  pkt #1 header: addr=1 len=20 -> channel 1 |
| 355 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=20 (receiver waited 8 cycle(s)) |
| 475 | **DUT** | IN  pkt #1 complete: addr=1 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 475 | yapp monitor | RX pkt #1 on the input: addr=1 len=20 parity=good gap=21 |
| 475 | reference | Packet forwarded: addr=1 len=20 -> channel 1 |
| 480 | yapp driver | TX pkt #1 accepted by the DUT |
| 510 | hbus driver | Executed READ  addr=0x100d data=0x14 |
| 515 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 540 | hbus driver | Executed READ  addr=0x1010 data=0x51 |
| 545 | hbus monitor | Collected READ  addr=0x1010 data=0x51 |
| 560 | ch1 driver | ch1: packet consumed (response delay 8) |
| 570 | hbus driver | Executed READ  addr=0x1011 data=0x18 |
| 575 | **DUT** | OUT ch1 pkt #1 done: 22 bytes in 23 cycles |
| 575 | ch1 monitor | ch1 RX pkt #1: addr=1 len=20 parity=good |
| 575 | scoreboard | ch1 pkt matched: addr=1 len=20 (1 matched so far) |
| 575 | hbus monitor | Collected READ  addr=0x1011 data=0x18 |
| 600 | hbus driver | Executed READ  addr=0x1012 data=0xc3 |
| 605 | hbus monitor | Collected READ  addr=0x1012 data=0xc3 |
| 630 | hbus driver | Executed READ  addr=0x1013 data=0xf3 |
| 635 | hbus monitor | Collected READ  addr=0x1013 data=0xf3 |
| 660 | hbus driver | Executed READ  addr=0x1014 data=0x96 |
| 665 | hbus monitor | Collected READ  addr=0x1014 data=0x96 |
| 690 | hbus driver | Executed READ  addr=0x1015 data=0x59 |
| 695 | hbus monitor | Collected READ  addr=0x1015 data=0x59 |
| 720 | hbus driver | Executed READ  addr=0x1016 data=0x23 |
| 725 | hbus monitor | Collected READ  addr=0x1016 data=0x23 |
| 750 | hbus driver | Executed READ  addr=0x1017 data=0x5c |
| 755 | hbus monitor | Collected READ  addr=0x1017 data=0x5c |
| 780 | hbus driver | Executed READ  addr=0x1018 data=0xf6 |
| 785 | hbus monitor | Collected READ  addr=0x1018 data=0xf6 |
| 810 | hbus driver | Executed READ  addr=0x1019 data=0xca |
| 815 | hbus monitor | Collected READ  addr=0x1019 data=0xca |
| 840 | hbus driver | Executed READ  addr=0x101a data=0x4f |
| 845 | hbus monitor | Collected READ  addr=0x101a data=0x4f |
| 870 | hbus driver | Executed READ  addr=0x101b data=0xaf |
| 875 | hbus monitor | Collected READ  addr=0x101b data=0xaf |
| 900 | hbus driver | Executed READ  addr=0x101c data=0x52 |
| 905 | hbus monitor | Collected READ  addr=0x101c data=0x52 |
| 930 | hbus driver | Executed READ  addr=0x101d data=0xec |
| 935 | hbus monitor | Collected READ  addr=0x101d data=0xec |
| 960 | hbus driver | Executed READ  addr=0x101e data=0xdc |
| 965 | hbus monitor | Collected READ  addr=0x101e data=0xdc |
| 990 | hbus driver | Executed READ  addr=0x101f data=0xd3 |
| 995 | hbus monitor | Collected READ  addr=0x101f data=0xd3 |
| 1020 | hbus driver | Executed READ  addr=0x1020 data=0x49 |
| 1025 | hbus monitor | Collected READ  addr=0x1020 data=0x49 |
| 1050 | hbus driver | Executed READ  addr=0x1021 data=0xa9 |
| 1055 | hbus monitor | Collected READ  addr=0x1021 data=0xa9 |
| 1070 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1080 | hbus driver | Executed READ  addr=0x1022 data=0x02 |
| 1085 | hbus monitor | Collected READ  addr=0x1022 data=0x02 |
| 1110 | hbus driver | Executed READ  addr=0x1023 data=0xbf |
| 1115 | hbus monitor | Collected READ  addr=0x1023 data=0xbf |
| 1140 | hbus driver | Executed READ  addr=0x1024 data=0x3c |
| 1140 | **test** | packet (addr 1, length 20) stored byte by byte |
| 1140 | **test** | STAGE: 2. a raw HBUS write to yapp_pkt_mem[0] is ignored (read-only memory) |
| 1145 | hbus monitor | Collected READ  addr=0x1024 data=0x3c |
| 1160 | hbus driver | Executed WRITE addr=0x1010 data=0xae |
| 1165 | hbus monitor | Collected WRITE addr=0x1010 data=0xae |
| 1190 | hbus driver | Executed READ  addr=0x1010 data=0x51 |
| 1190 | **test** | write to yapp_pkt_mem ignored, as it should be |
| 1190 | **test** | STAGE: 3. ctrl_reg=5, then a 9-byte packet: dropped as oversized but still stored |
| 1195 | hbus monitor | Collected READ  addr=0x1010 data=0x51 |
| 1210 | hbus driver | Executed WRITE addr=0x1000 data=0x05 |
| 1210 | yapp driver | TX pkt #2: addr=2 len=9 parity=good delay=19 |
| 1215 | **DUT** | CONFIG router_en=1 maxpktsize=5 |
| 1215 | hbus monitor | Collected WRITE addr=0x1000 data=0x05 |
| 1215 | reference | maxpktsize is now 5 |
| 1415 | **DUT** | IN  pkt #2 header: addr=2 len=9 -> DROP (oversized: len 9 > maxpktsize 5) |
| 1515 | **DUT** | IN  pkt #2 complete: addr=2 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 1515 | yapp monitor | RX pkt #2 on the input: addr=2 len=9 parity=good gap=93 |
| 1515 | reference | Packet dropped: length 9 > maxpktsize 5 (addr=2) |
| 1515 | **DUT** | ROUTER DROPS PACKET addr=2 length=9 (length > maxpktsize) |
| 1520 | yapp driver | TX pkt #2 accepted by the DUT |
| 1550 | hbus driver | Executed READ  addr=0x100d data=0x09 |
| 1555 | hbus monitor | Collected READ  addr=0x100d data=0x09 |
| 1580 | hbus driver | Executed READ  addr=0x1010 data=0x26 |
| 1585 | hbus monitor | Collected READ  addr=0x1010 data=0x26 |
| 1610 | hbus driver | Executed READ  addr=0x1011 data=0xd3 |
| 1615 | hbus monitor | Collected READ  addr=0x1011 data=0xd3 |
| 1640 | hbus driver | Executed READ  addr=0x1012 data=0x4b |
| 1645 | hbus monitor | Collected READ  addr=0x1012 data=0x4b |
| 1670 | hbus driver | Executed READ  addr=0x1013 data=0xa6 |
| 1675 | hbus monitor | Collected READ  addr=0x1013 data=0xa6 |
| 1700 | hbus driver | Executed READ  addr=0x1014 data=0xbe |
| 1705 | hbus monitor | Collected READ  addr=0x1014 data=0xbe |
| 1730 | hbus driver | Executed READ  addr=0x1015 data=0xf8 |
| 1735 | hbus monitor | Collected READ  addr=0x1015 data=0xf8 |
| 1760 | hbus driver | Executed READ  addr=0x1016 data=0x5b |
| 1765 | hbus monitor | Collected READ  addr=0x1016 data=0x5b |
| 1790 | hbus driver | Executed READ  addr=0x1017 data=0x32 |
| 1795 | hbus monitor | Collected READ  addr=0x1017 data=0x32 |
| 1820 | hbus driver | Executed READ  addr=0x1018 data=0x7a |
| 1825 | hbus monitor | Collected READ  addr=0x1018 data=0x7a |
| 1850 | hbus driver | Executed READ  addr=0x1019 data=0xc5 |
| 1850 | **test** | packet (addr 2, length 9) stored byte by byte |
| 1855 | hbus monitor | Collected READ  addr=0x1019 data=0xc5 |
| 1870 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 1875 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 1875 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 1875 | reference | maxpktsize is now 63 |
| 2070 | ch0 monitor | Channel 0 report: 0 packets collected |
| 2070 | ch1 monitor | Channel 1 report: 1 packets collected |
| 2070 | ch2 monitor | Channel 2 report: 0 packets collected |
| 2070 | hbus monitor | HBUS report: 3 writes, 34 reads |
| 2070 | reference |  |
| 2070 | scoreboard |  |
| 2070 | yapp driver | YAPP driver report: 2 packets sent |
| 2070 | yapp monitor | YAPP monitor report: 2 packets collected, coverage 23.3% |
| 2070 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 1 longer (gap coverage 25.0%) |
