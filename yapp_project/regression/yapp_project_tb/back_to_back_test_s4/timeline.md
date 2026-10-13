# back_to_back_test seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 3us · wall 1.2 s · log [`back_to_back_test_s4.log`](back_to_back_test_s4.log)

Waves: `back_to_back_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fback_to_back_test_s4%2Fback_to_back_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **24** packet(s) (0 with bad parity); the input monitor saw 24.
- Router: **24** forwarded, **0** dropped.
- Packets out: ch0 **5**, ch1 **8**, ch2 **11**.
- Scoreboard: 24 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **1** time(s), longest hold 1 cycle(s).
- Error pulses: 0.
- HBUS: 0 write(s), 0 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | 1. yapp_gap_seq: 24 packets with gaps of 0, 1, 2 and more cycles between them |
| 2535 | 2. the gap classes the monitor measured match the plan of the sequence, gap coverage 100% |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 2**

![first packet out on channel 2](wave_first_packet_out.svg)

**first back-pressure on the input port**

![first back-pressure on the input port](wave_first_suspend.svg)

## Timeline

290 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. yapp_gap_seq: 24 packets with gaps of 0, 1, 2 and more cycles between them |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 50 | yapp driver | TX pkt #1: addr=0 len=1 parity=good delay=3 |
| 95 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> channel 0 |
| 115 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 115 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=good gap=4 |
| 115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 120 | yapp driver | TX pkt #1 accepted by the DUT |
| 120 | yapp driver | TX pkt #2: addr=2 len=8 parity=good delay=1 |
| 135 | **DUT** | IN  pkt #2 header: addr=2 len=8 -> channel 2 |
| 165 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=8 (receiver waited 2 cycle(s)) |
| 185 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 200 | ch0 driver | ch0: packet consumed (response delay 8) |
| 225 | **DUT** | IN  pkt #2 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 225 | yapp monitor | RX pkt #2 on the input: addr=2 len=8 parity=good gap=1 |
| 225 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 230 | yapp driver | TX pkt #2 accepted by the DUT |
| 230 | yapp driver | TX pkt #3: addr=1 len=7 parity=good delay=2 |
| 250 | ch2 driver | ch2: packet consumed (response delay 2) |
| 255 | **DUT** | IN  pkt #3 header: addr=1 len=7 -> channel 1 |
| 315 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 14 cycles |
| 315 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 315 | scoreboard | ch0 pkt matched: addr=0 len=1 (1 matched so far) |
| 335 | **DUT** | IN  pkt #3 complete: addr=1 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 335 | yapp monitor | RX pkt #3 on the input: addr=1 len=7 parity=good gap=2 |
| 335 | reference | Packet forwarded: addr=1 len=7 -> channel 1 |
| 340 | ch0 driver | ch0: packet consumed (response delay 10) |
| 340 | yapp driver | TX pkt #3 accepted by the DUT |
| 340 | yapp driver | TX pkt #4: addr=2 len=8 parity=good delay=3 |
| 365 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=7 (receiver waited 10 cycle(s)) |
| 365 | **DUT** | OUT ch2 pkt #1 done: 10 bytes in 21 cycles |
| 365 | ch2 monitor | ch2 RX pkt #1: addr=2 len=8 parity=good |
| 365 | scoreboard | ch2 pkt matched: addr=2 len=8 (2 matched so far) |
| 375 | **DUT** | IN  pkt #4 header: addr=2 len=8 -> channel 2 |
| 385 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 440 | ch1 driver | ch1: packet consumed (response delay 10) |
| 465 | **DUT** | IN  pkt #4 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 465 | yapp monitor | RX pkt #4 on the input: addr=2 len=8 parity=good gap=3 |
| 465 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 470 | yapp driver | TX pkt #4 accepted by the DUT |
| 470 | yapp driver | TX pkt #5: addr=2 len=8 parity=good delay=0 |
| 475 | **DUT** | IN  pkt #5 header: addr=2 len=8 -> channel 2 |
| 475 | **DUT** | OUT ch2 pkt #2 done: 10 bytes in 10 cycles |
| 475 | ch2 monitor | ch2 RX pkt #2: addr=2 len=8 parity=good |
| 475 | scoreboard | ch2 pkt matched: addr=2 len=8 (3 matched so far) |
| 485 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 495 | **DUT** | OUT ch1 pkt #1 done: 9 bytes in 14 cycles |
| 495 | ch1 monitor | ch1 RX pkt #1: addr=1 len=7 parity=good |
| 495 | scoreboard | ch1 pkt matched: addr=1 len=7 (4 matched so far) |
| 565 | **DUT** | IN  pkt #5 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 565 | yapp monitor | RX pkt #5 on the input: addr=2 len=8 parity=good gap=0 |
| 565 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 570 | yapp driver | TX pkt #5 accepted by the DUT |
| 570 | yapp driver | TX pkt #6: addr=0 len=3 parity=good delay=1 |
| 575 | **DUT** | OUT ch2 pkt #3 done: 10 bytes in 10 cycles |
| 575 | ch2 monitor | ch2 RX pkt #3: addr=2 len=8 parity=good |
| 575 | scoreboard | ch2 pkt matched: addr=2 len=8 (5 matched so far) |
| 585 | **DUT** | IN  pkt #6 header: addr=0 len=3 -> channel 0 |
| 620 | ch2 driver | ch2: packet consumed (response delay 10) |
| 625 | **DUT** | IN  pkt #6 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 625 | yapp monitor | RX pkt #6 on the input: addr=0 len=3 parity=good gap=1 |
| 625 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 630 | yapp driver | TX pkt #6 accepted by the DUT |
| 630 | yapp driver | TX pkt #7: addr=2 len=1 parity=good delay=2 |
| 645 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=3 (receiver waited 5 cycle(s)) |
| 655 | **DUT** | IN  pkt #7 header: addr=2 len=1 -> channel 2 |
| 665 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 670 | ch1 driver | ch1: packet consumed (response delay 4) |
| 675 | **DUT** | IN  pkt #7 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 675 | yapp monitor | RX pkt #7 on the input: addr=2 len=1 parity=good gap=2 |
| 675 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 680 | ch0 driver | ch0: packet consumed (response delay 5) |
| 680 | ch2 driver | ch2: packet consumed (response delay 0) |
| 680 | yapp driver | TX pkt #7 accepted by the DUT |
| 680 | yapp driver | TX pkt #8: addr=1 len=8 parity=good delay=3 |
| 715 | **DUT** | IN  pkt #8 header: addr=1 len=8 -> channel 1 |
| 765 | **DUT** | OUT ch2 pkt #4 done: 3 bytes in 11 cycles |
| 765 | ch2 monitor | ch2 RX pkt #4: addr=2 len=1 parity=good |
| 765 | scoreboard | ch2 pkt matched: addr=2 len=1 (6 matched so far) |
| 795 | **DUT** | OUT ch0 pkt #2 done: 5 bytes in 16 cycles |
| 795 | ch0 monitor | ch0 RX pkt #2: addr=0 len=3 parity=good |
| 795 | scoreboard | ch0 pkt matched: addr=0 len=3 (7 matched so far) |
| 805 | **DUT** | IN  pkt #8 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 805 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=8 (receiver waited 8 cycle(s)) |
| 805 | yapp monitor | RX pkt #8 on the input: addr=1 len=8 parity=good gap=3 |
| 805 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 810 | yapp driver | TX pkt #8 accepted by the DUT |
| 810 | yapp driver | TX pkt #9: addr=1 len=8 parity=good delay=0 |
| 815 | **DUT** | IN  pkt #9 header: addr=1 len=8 -> channel 1 |
| 890 | ch1 driver | ch1: packet consumed (response delay 8) |
| 905 | **DUT** | IN  pkt #9 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 905 | yapp monitor | RX pkt #9 on the input: addr=1 len=8 parity=good gap=0 |
| 905 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 910 | yapp driver | TX pkt #9 accepted by the DUT |
| 910 | yapp driver | TX pkt #10: addr=1 len=8 parity=good delay=1 |
| 925 | **DUT** | IN  pkt #10 header: addr=1 len=8 -> channel 1 |
| 975 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0x59 held (pkt #10) |
| 975 | **DUT** | OUT ch1 pkt #2 done: 10 bytes in 18 cycles |
| 975 | ch1 monitor | ch1 RX pkt #2: addr=1 len=8 parity=good |
| 975 | scoreboard | ch1 pkt matched: addr=1 len=8 (8 matched so far) |
| 985 | **DUT** | SUSPEND released after 1 cycle(s) |
| 985 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=8 (receiver waited 0 cycle(s)) |
| 990 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1025 | **DUT** | IN  pkt #10 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 11 cycles (held 1) |
| 1025 | yapp monitor | RX pkt #10 on the input: addr=1 len=8 parity=good gap=1 |
| 1025 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 1030 | yapp driver | TX pkt #10 accepted by the DUT |
| 1030 | yapp driver | TX pkt #11: addr=1 len=3 parity=good delay=2 |
| 1055 | **DUT** | IN  pkt #11 header: addr=1 len=3 -> channel 1 |
| 1075 | **DUT** | OUT ch1 pkt #3 done: 10 bytes in 10 cycles |
| 1075 | ch1 monitor | ch1 RX pkt #3: addr=1 len=8 parity=good |
| 1075 | scoreboard | ch1 pkt matched: addr=1 len=8 (9 matched so far) |
| 1085 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=8 (receiver waited 0 cycle(s)) |
| 1095 | **DUT** | IN  pkt #11 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 1095 | yapp monitor | RX pkt #11 on the input: addr=1 len=3 parity=good gap=2 |
| 1095 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 1100 | yapp driver | TX pkt #11 accepted by the DUT |
| 1100 | yapp driver | TX pkt #12: addr=2 len=8 parity=good delay=3 |
| 1120 | ch2 driver | ch2: packet consumed (response delay 7) |
| 1135 | **DUT** | IN  pkt #12 header: addr=2 len=8 -> channel 2 |
| 1175 | **DUT** | OUT ch1 pkt #4 done: 10 bytes in 10 cycles |
| 1175 | ch1 monitor | ch1 RX pkt #4: addr=1 len=8 parity=good |
| 1175 | scoreboard | ch1 pkt matched: addr=1 len=8 (10 matched so far) |
| 1185 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 1225 | **DUT** | IN  pkt #12 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1225 | **DUT** | OUT ch1 pkt #5 done: 5 bytes in 5 cycles |
| 1225 | ch1 monitor | ch1 RX pkt #5: addr=1 len=3 parity=good |
| 1225 | scoreboard | ch1 pkt matched: addr=1 len=3 (11 matched so far) |
| 1225 | yapp monitor | RX pkt #12 on the input: addr=2 len=8 parity=good gap=3 |
| 1225 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 1230 | yapp driver | TX pkt #12 accepted by the DUT |
| 1230 | yapp driver | TX pkt #13: addr=2 len=7 parity=good delay=0 |
| 1235 | **DUT** | IN  pkt #13 header: addr=2 len=7 -> channel 2 |
| 1245 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=8 (receiver waited 10 cycle(s)) |
| 1315 | **DUT** | IN  pkt #13 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 1315 | yapp monitor | RX pkt #13 on the input: addr=2 len=7 parity=good gap=0 |
| 1315 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 1320 | yapp driver | TX pkt #13 accepted by the DUT |
| 1320 | yapp driver | TX pkt #14: addr=0 len=8 parity=good delay=1 |
| 1330 | ch2 driver | ch2: packet consumed (response delay 10) |
| 1335 | **DUT** | IN  pkt #14 header: addr=0 len=8 -> channel 0 |
| 1425 | **DUT** | IN  pkt #14 complete: addr=0 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1425 | yapp monitor | RX pkt #14 on the input: addr=0 len=8 parity=good gap=1 |
| 1425 | reference | Packet forwarded: addr=0 len=8 -> channel 0 |
| 1430 | yapp driver | TX pkt #14 accepted by the DUT |
| 1430 | yapp driver | TX pkt #15: addr=1 len=8 parity=good delay=2 |
| 1445 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=8 (receiver waited 10 cycle(s)) |
| 1445 | **DUT** | OUT ch2 pkt #5 done: 10 bytes in 21 cycles |
| 1445 | ch2 monitor | ch2 RX pkt #5: addr=2 len=8 parity=good |
| 1445 | scoreboard | ch2 pkt matched: addr=2 len=8 (12 matched so far) |
| 1455 | **DUT** | IN  pkt #15 header: addr=1 len=8 -> channel 1 |
| 1455 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=7 (receiver waited 0 cycle(s)) |
| 1465 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=8 (receiver waited 0 cycle(s)) |
| 1490 | ch1 driver | ch1: packet consumed (response delay 7) |
| 1530 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1535 | **DUT** | OUT ch2 pkt #6 done: 9 bytes in 9 cycles |
| 1535 | ch2 monitor | ch2 RX pkt #6: addr=2 len=7 parity=good |
| 1535 | scoreboard | ch2 pkt matched: addr=2 len=7 (13 matched so far) |
| 1545 | **DUT** | IN  pkt #15 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1545 | yapp monitor | RX pkt #15 on the input: addr=1 len=8 parity=good gap=2 |
| 1545 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 1550 | yapp driver | TX pkt #15 accepted by the DUT |
| 1550 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=3 |
| 1585 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 1595 | **DUT** | OUT ch1 pkt #6 done: 10 bytes in 14 cycles |
| 1595 | ch1 monitor | ch1 RX pkt #6: addr=1 len=8 parity=good |
| 1595 | scoreboard | ch1 pkt matched: addr=1 len=8 (14 matched so far) |
| 1605 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1605 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=3 |
| 1605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1610 | yapp driver | TX pkt #16 accepted by the DUT |
| 1610 | yapp driver | TX pkt #17: addr=2 len=8 parity=good delay=0 |
| 1615 | **DUT** | IN  pkt #17 header: addr=2 len=8 -> channel 2 |
| 1625 | **DUT** | OUT ch0 pkt #3 done: 10 bytes in 19 cycles |
| 1625 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 1625 | ch0 monitor | ch0 RX pkt #3: addr=0 len=8 parity=good |
| 1625 | scoreboard | ch0 pkt matched: addr=0 len=8 (15 matched so far) |
| 1630 | ch2 driver | ch2: packet consumed (response delay 10) |
| 1635 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1655 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 3 cycles |
| 1655 | ch0 monitor | ch0 RX pkt #4: addr=0 len=1 parity=good |
| 1655 | scoreboard | ch0 pkt matched: addr=0 len=1 (16 matched so far) |
| 1705 | **DUT** | IN  pkt #17 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1705 | yapp monitor | RX pkt #17 on the input: addr=2 len=8 parity=good gap=0 |
| 1705 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 1710 | yapp driver | TX pkt #17 accepted by the DUT |
| 1710 | yapp driver | TX pkt #18: addr=0 len=8 parity=good delay=1 |
| 1725 | **DUT** | IN  pkt #18 header: addr=0 len=8 -> channel 0 |
| 1735 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=8 (receiver waited 0 cycle(s)) |
| 1815 | **DUT** | IN  pkt #18 complete: addr=0 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1815 | yapp monitor | RX pkt #18 on the input: addr=0 len=8 parity=good gap=1 |
| 1815 | reference | Packet forwarded: addr=0 len=8 -> channel 0 |
| 1820 | yapp driver | TX pkt #18 accepted by the DUT |
| 1820 | yapp driver | TX pkt #19: addr=1 len=8 parity=good delay=2 |
| 1825 | **DUT** | OUT ch0 pkt #5 done: 10 bytes in 10 cycles |
| 1825 | **DUT** | OUT ch2 pkt #7 done: 10 bytes in 21 cycles |
| 1825 | ch0 monitor | ch0 RX pkt #5: addr=0 len=8 parity=good |
| 1825 | scoreboard | ch0 pkt matched: addr=0 len=8 (17 matched so far) |
| 1825 | ch2 monitor | ch2 RX pkt #7: addr=2 len=8 parity=good |
| 1825 | scoreboard | ch2 pkt matched: addr=2 len=8 (18 matched so far) |
| 1845 | **DUT** | IN  pkt #19 header: addr=1 len=8 -> channel 1 |
| 1855 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=8 (receiver waited 0 cycle(s)) |
| 1910 | ch0 driver | ch0: packet consumed (response delay 8) |
| 1935 | **DUT** | IN  pkt #19 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 1935 | yapp monitor | RX pkt #19 on the input: addr=1 len=8 parity=good gap=2 |
| 1935 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 1940 | yapp driver | TX pkt #19 accepted by the DUT |
| 1940 | yapp driver | TX pkt #20: addr=2 len=8 parity=good delay=3 |
| 1945 | **DUT** | OUT ch1 pkt #7 done: 10 bytes in 10 cycles |
| 1945 | ch1 monitor | ch1 RX pkt #7: addr=1 len=8 parity=good |
| 1945 | scoreboard | ch1 pkt matched: addr=1 len=8 (19 matched so far) |
| 1975 | **DUT** | IN  pkt #20 header: addr=2 len=8 -> channel 2 |
| 1985 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 2065 | **DUT** | IN  pkt #20 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 2065 | yapp monitor | RX pkt #20 on the input: addr=2 len=8 parity=good gap=3 |
| 2065 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 2070 | ch2 driver | ch2: packet consumed (response delay 10) |
| 2070 | yapp driver | TX pkt #20 accepted by the DUT |
| 2070 | yapp driver | TX pkt #21: addr=2 len=8 parity=good delay=0 |
| 2075 | **DUT** | IN  pkt #21 header: addr=2 len=8 -> channel 2 |
| 2120 | ch1 driver | ch1: packet consumed (response delay 3) |
| 2155 | **DUT** | OUT ch2 pkt #8 done: 10 bytes in 18 cycles |
| 2155 | ch2 monitor | ch2 RX pkt #8: addr=2 len=8 parity=good |
| 2155 | scoreboard | ch2 pkt matched: addr=2 len=8 (20 matched so far) |
| 2165 | **DUT** | IN  pkt #21 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 2165 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 2165 | yapp monitor | RX pkt #21 on the input: addr=2 len=8 parity=good gap=0 |
| 2165 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 2170 | yapp driver | TX pkt #21 accepted by the DUT |
| 2170 | yapp driver | TX pkt #22: addr=2 len=8 parity=good delay=1 |
| 2185 | **DUT** | IN  pkt #22 header: addr=2 len=8 -> channel 2 |
| 2255 | **DUT** | OUT ch2 pkt #9 done: 10 bytes in 10 cycles |
| 2255 | ch2 monitor | ch2 RX pkt #9: addr=2 len=8 parity=good |
| 2255 | scoreboard | ch2 pkt matched: addr=2 len=8 (21 matched so far) |
| 2265 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 2275 | **DUT** | IN  pkt #22 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 2275 | yapp monitor | RX pkt #22 on the input: addr=2 len=8 parity=good gap=1 |
| 2275 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 2280 | yapp driver | TX pkt #22 accepted by the DUT |
| 2280 | yapp driver | TX pkt #23: addr=1 len=8 parity=good delay=2 |
| 2305 | **DUT** | IN  pkt #23 header: addr=1 len=8 -> channel 1 |
| 2350 | ch2 driver | ch2: packet consumed (response delay 7) |
| 2385 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=8 (receiver waited 7 cycle(s)) |
| 2395 | **DUT** | IN  pkt #23 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 2395 | yapp monitor | RX pkt #23 on the input: addr=1 len=8 parity=good gap=2 |
| 2395 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 2400 | yapp driver | TX pkt #23 accepted by the DUT |
| 2400 | yapp driver | TX pkt #24: addr=2 len=1 parity=good delay=3 |
| 2435 | **DUT** | IN  pkt #24 header: addr=2 len=1 -> channel 2 |
| 2455 | **DUT** | IN  pkt #24 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2455 | **DUT** | OUT ch2 pkt #10 done: 10 bytes in 20 cycles |
| 2455 | ch2 monitor | ch2 RX pkt #10: addr=2 len=8 parity=good |
| 2455 | scoreboard | ch2 pkt matched: addr=2 len=8 (22 matched so far) |
| 2455 | yapp monitor | RX pkt #24 on the input: addr=2 len=1 parity=good gap=3 |
| 2455 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 2460 | yapp driver | TX pkt #24 accepted by the DUT |
| 2465 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 2470 | ch1 driver | ch1: packet consumed (response delay 7) |
| 2485 | **DUT** | OUT ch2 pkt #11 done: 3 bytes in 3 cycles |
| 2485 | ch2 monitor | ch2 RX pkt #11: addr=2 len=1 parity=good |
| 2485 | scoreboard | ch2 pkt matched: addr=2 len=1 (23 matched so far) |
| 2535 | **DUT** | OUT ch1 pkt #8 done: 10 bytes in 16 cycles |
| 2535 | ch1 monitor | ch1 RX pkt #8: addr=1 len=8 parity=good |
| 2535 | scoreboard | ch1 pkt matched: addr=1 len=8 (24 matched so far) |
| 2535 | **test** | STAGE: 2. the gap classes the monitor measured match the plan of the sequence, gap coverage 100% |
| 2535 | **test** | gap class 0: 5 packets, as planned |
| 2535 | **test** | gap class 1: 6 packets, as planned |
| 2535 | **test** | gap class 2: 6 packets, as planned |
| 2535 | **test** | gap class 3: 6 packets, as planned |
| 2550 | ch2 driver | ch2: packet consumed (response delay 9) |
| 2600 | ch1 driver | ch1: packet consumed (response delay 5) |
| 2735 | ch0 monitor | Channel 0 report: 5 packets collected |
| 2735 | ch1 monitor | Channel 1 report: 8 packets collected |
| 2735 | ch2 monitor | Channel 2 report: 11 packets collected |
| 2735 | hbus monitor | HBUS report: 0 writes, 0 reads |
| 2735 | coverage | Coverage of the router configuration: 26.1% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 0 / 0 / 0 / 24 packets · length < max / = max / max+1 / > max+1 : 24 / 0 / 0 / 0 · forwarded good / bad : 24 / 0 · dropped address 3 good / bad : 0 / 0 · dropped oversized good / bad : 0 / 0 · counter enables none / mixed / all : 24 / 0 / 0 |
| 2735 | coverage | HBUS address coverage: 0 accesses sampled, coverage 0.0% |
| 2735 | coverage | HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0% |
| 2735 | coverage | HBUS counter value coverage: 0 counter reads sampled, coverage 0.0% |
| 2735 | coverage | HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0% |
| 2735 | reference | --- Reference model report --- · forwarded to scoreboard : 24 · dropped (router disabled) : 0 · dropped (oversized) : 0 · dropped (address 3) : 0 · counters parity/oversized/addr0..3 : 0 / 0 / 0 0 0 0 |
| 2735 | scoreboard | --- Scoreboard report --- · packets received : 24 · packets matched : 24 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 2735 | yapp driver | YAPP driver report: 24 packets sent |
| 2735 | coverage | YAPP gap coverage: 23 gaps sampled, coverage 100.0% |
| 2735 | yapp monitor | YAPP monitor report: 24 packets collected, 0 with bad parity |
| 2735 | yapp monitor | YAPP gaps: 5 back to back, 6 of 1 cycle, 6 of 2, 6 longer |
| 2735 | coverage | YAPP packet coverage: 24 packets sampled, coverage 30.0% |
