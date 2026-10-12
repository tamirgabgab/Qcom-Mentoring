# router_disable_test  seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 8us · log `router_disable_test_s1.log`

Waves: `router_disable_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.

## Summary

- YAPP driver sent **6** packet(s) (0 with bad parity); the input monitor saw 6.
- Router: **3** forwarded, **3** dropped (3 router disabled).
- Packets out: ch0 **1**, ch1 **1**, ch2 **1**.
- Scoreboard: 3 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 2 write(s), 11 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | 1. en_reg=0xfe (router_en=0, counters on): 3 packets into a deaf router |
| 5850 | 2. en_reg=0xff (router_en=1): 3 packets, traffic and counters resume |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 0**

![first packet out on channel 0](wave_first_packet_out.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

113 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. en_reg=0xfe (router_en=0, counters on): 3 packets into a deaf router |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 70 | yapp driver | TX pkt #1: addr=0 len=42 parity=good delay=20 |
| 75 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 75 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 75 | reference | router_en is now 0 |
| 285 | **DUT** | IN  pkt #1 header: addr=0 len=42 -> DROP (router disabled) |
| 715 | **DUT** | IN  pkt #1 complete: addr=0 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 715 | yapp monitor | RX pkt #1 on the input: addr=0 len=42 parity=good gap=23 |
| 715 | reference | Packet dropped: router disabled (addr=0 len=42) |
| 715 | **DUT** | ROUTER DROPS PACKET addr=0 length=42 (router disabled) |
| 720 | yapp driver | TX pkt #1 accepted by the DUT |
| 720 | yapp driver | TX pkt #2: addr=1 len=59 parity=good delay=2 |
| 745 | **DUT** | IN  pkt #2 header: addr=1 len=59 -> DROP (router disabled) |
| 1345 | **DUT** | IN  pkt #2 complete: addr=1 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 1345 | yapp monitor | RX pkt #2 on the input: addr=1 len=59 parity=good gap=2 |
| 1345 | reference | Packet dropped: router disabled (addr=1 len=59) |
| 1345 | **DUT** | ROUTER DROPS PACKET addr=1 length=59 (router disabled) |
| 1350 | yapp driver | TX pkt #2 accepted by the DUT |
| 1350 | yapp driver | TX pkt #3: addr=2 len=27 parity=good delay=1 |
| 1365 | **DUT** | IN  pkt #3 header: addr=2 len=27 -> DROP (router disabled) |
| 1645 | **DUT** | IN  pkt #3 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 1645 | yapp monitor | RX pkt #3 on the input: addr=2 len=27 parity=good gap=1 |
| 1645 | reference | Packet dropped: router disabled (addr=2 len=27) |
| 1645 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (router disabled) |
| 1650 | yapp driver | TX pkt #3 accepted by the DUT |
| 5645 | **test** | router_en = 0: no packet reached a channel |
| 5670 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 5670 | **test** | addr0_cnt_reg reads 0 as expected |
| 5675 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5700 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 5700 | **test** | addr1_cnt_reg reads 0 as expected |
| 5705 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5730 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 5730 | **test** | addr2_cnt_reg reads 0 as expected |
| 5735 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5760 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 5760 | **test** | addr3_cnt_reg reads 0 as expected |
| 5765 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5790 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 5790 | **test** | parity_err_cnt_reg reads 0 as expected |
| 5795 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5820 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 5820 | **test** | oversized_pkt_cnt_reg reads 0 as expected |
| 5825 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5850 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 5850 | **test** | mem_size_reg reads 0 as expected |
| 5850 | **test** | STAGE: 2. en_reg=0xff (router_en=1): 3 packets, traffic and counters resume |
| 5855 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 5870 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 5870 | yapp driver | TX pkt #4: addr=0 len=8 parity=good delay=1 |
| 5875 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 5875 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 5875 | reference | router_en is now 1 |
| 5895 | **DUT** | IN  pkt #4 header: addr=0 len=8 -> channel 0 |
| 5935 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=8 (receiver waited 3 cycle(s)) |
| 5985 | **DUT** | IN  pkt #4 complete: addr=0 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 5985 | yapp monitor | RX pkt #4 on the input: addr=0 len=8 parity=good gap=424 |
| 5985 | reference | Packet forwarded: addr=0 len=8 -> channel 0 |
| 5990 | yapp driver | TX pkt #4 accepted by the DUT |
| 5990 | yapp driver | TX pkt #5: addr=1 len=21 parity=good delay=19 |
| 6020 | ch0 driver | ch0: packet consumed (response delay 3) |
| 6115 | **DUT** | OUT ch0 pkt #1 done: 10 bytes in 19 cycles |
| 6115 | ch0 monitor | ch0 RX pkt #1: addr=0 len=8 parity=good |
| 6115 | scoreboard | ch0 pkt matched: addr=0 len=8 (1 matched so far) |
| 6185 | **DUT** | IN  pkt #5 header: addr=1 len=21 -> channel 1 |
| 6260 | ch0 driver | ch0: packet consumed (response delay 8) |
| 6275 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=21 (receiver waited 8 cycle(s)) |
| 6405 | **DUT** | IN  pkt #5 complete: addr=1 len=21 parity=ok forwarded, 23 bytes in 23 cycles (held 0) |
| 6405 | yapp monitor | RX pkt #5 on the input: addr=1 len=21 parity=good gap=19 |
| 6405 | reference | Packet forwarded: addr=1 len=21 -> channel 1 |
| 6410 | yapp driver | TX pkt #5 accepted by the DUT |
| 6410 | yapp driver | TX pkt #6: addr=2 len=56 parity=good delay=16 |
| 6490 | ch1 driver | ch1: packet consumed (response delay 8) |
| 6505 | **DUT** | OUT ch1 pkt #1 done: 23 bytes in 24 cycles |
| 6505 | ch1 monitor | ch1 RX pkt #1: addr=1 len=21 parity=good |
| 6505 | scoreboard | ch1 pkt matched: addr=1 len=21 (2 matched so far) |
| 6575 | **DUT** | IN  pkt #6 header: addr=2 len=56 -> channel 2 |
| 6665 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=56 (receiver waited 8 cycle(s)) |
| 7050 | ch1 driver | ch1: packet consumed (response delay 0) |
| 7145 | **DUT** | IN  pkt #6 complete: addr=2 len=56 parity=ok forwarded, 58 bytes in 58 cycles (held 0) |
| 7145 | yapp monitor | RX pkt #6 on the input: addr=2 len=56 parity=good gap=16 |
| 7145 | reference | Packet forwarded: addr=2 len=56 -> channel 2 |
| 7150 | yapp driver | TX pkt #6 accepted by the DUT |
| 7230 | ch2 driver | ch2: packet consumed (response delay 8) |
| 7325 | **DUT** | OUT ch2 pkt #1 done: 58 bytes in 67 cycles |
| 7325 | ch2 monitor | ch2 RX pkt #1: addr=2 len=56 parity=good |
| 7325 | scoreboard | ch2 pkt matched: addr=2 len=56 (3 matched so far) |
| 7350 | hbus driver | Executed READ  addr=0x1009 data=0x01 |
| 7350 | **test** | addr0_cnt_reg reads 1 as expected |
| 7355 | hbus monitor | Collected READ  addr=0x1009 data=0x01 |
| 7380 | hbus driver | Executed READ  addr=0x100a data=0x01 |
| 7380 | **test** | addr1_cnt_reg reads 1 as expected |
| 7385 | hbus monitor | Collected READ  addr=0x100a data=0x01 |
| 7410 | hbus driver | Executed READ  addr=0x100b data=0x01 |
| 7410 | **test** | addr2_cnt_reg reads 1 as expected |
| 7415 | hbus monitor | Collected READ  addr=0x100b data=0x01 |
| 7440 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 7440 | **test** | addr3_cnt_reg reads 0 as expected |
| 7445 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7640 | ch0 monitor | Channel 0 report: 1 packets collected |
| 7640 | ch1 monitor | Channel 1 report: 1 packets collected |
| 7640 | ch2 monitor | Channel 2 report: 1 packets collected |
| 7640 | hbus monitor | HBUS report: 2 writes, 11 reads |
| 7640 | reference |  |
| 7640 | scoreboard |  |
| 7640 | yapp driver | YAPP driver report: 6 packets sent |
| 7640 | yapp monitor | YAPP monitor report: 6 packets collected, coverage 33.3% |
| 7640 | yapp monitor | YAPP gaps: 0 back to back, 1 of 1 cycle, 1 of 2, 3 longer (gap coverage 75.0%) |
