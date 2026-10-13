# counter_wrap_test  seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 42us · log `counter_wrap_test_s4.log`

Waves: `counter_wrap_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fcounter_wrap_test_s4%2Fcounter_wrap_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **257** packet(s) (0 with bad parity); the input monitor saw 257.
- Router: **257** forwarded, **0** dropped.
- Packets out: ch0 **257**, ch1 **0**, ch2 **0**.
- Scoreboard: 257 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 1 write(s), 8 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 70 | 1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255 |
| 41670 | 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 41750 | 3. one more packet: the counter goes on from 0 |
| 41990 | 4. the other counters are untouched and the scoreboard matched all 257 packets |

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

2766 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 70 | **test** | STAGE: 1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255 |
| 70 | yapp driver | TX pkt #1: addr=0 len=1 parity=good delay=4 |
| 75 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 75 | reference | router_en is now 1 (en_reg 0xff) |
| 125 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> channel 0 |
| 145 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 145 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=good gap=7 |
| 145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 150 | yapp driver | TX pkt #1 accepted by the DUT |
| 150 | yapp driver | TX pkt #2: addr=0 len=1 parity=good delay=19 |
| 215 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 230 | ch0 driver | ch0: packet consumed (response delay 8) |
| 345 | **DUT** | IN  pkt #2 header: addr=0 len=1 -> channel 0 |
| 345 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 14 cycles |
| 345 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 345 | scoreboard | ch0 pkt matched: addr=0 len=1 (1 matched so far) |
| 355 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 365 | **DUT** | IN  pkt #2 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 365 | yapp monitor | RX pkt #2 on the input: addr=0 len=1 parity=good gap=19 |
| 365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 370 | ch0 driver | ch0: packet consumed (response delay 10) |
| 370 | yapp driver | TX pkt #2 accepted by the DUT |
| 370 | yapp driver | TX pkt #3: addr=0 len=1 parity=good delay=20 |
| 435 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 9 cycles |
| 435 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=good |
| 435 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 575 | **DUT** | IN  pkt #3 header: addr=0 len=1 -> channel 0 |
| 585 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 595 | **DUT** | IN  pkt #3 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 595 | yapp monitor | RX pkt #3 on the input: addr=0 len=1 parity=good gap=20 |
| 595 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 600 | yapp driver | TX pkt #3 accepted by the DUT |
| 600 | yapp driver | TX pkt #4: addr=0 len=1 parity=good delay=12 |
| 605 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 605 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 605 | scoreboard | ch0 pkt matched: addr=0 len=1 (3 matched so far) |
| 725 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> channel 0 |
| 735 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 745 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 745 | yapp monitor | RX pkt #4 on the input: addr=0 len=1 parity=good gap=12 |
| 745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 750 | yapp driver | TX pkt #4 accepted by the DUT |
| 750 | yapp driver | TX pkt #5: addr=0 len=1 parity=good delay=20 |
| 755 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 3 cycles |
| 755 | ch0 monitor | ch0 RX pkt #4: addr=0 len=1 parity=good |
| 755 | scoreboard | ch0 pkt matched: addr=0 len=1 (4 matched so far) |
| 800 | ch0 driver | ch0: packet consumed (response delay 5) |
| 955 | **DUT** | IN  pkt #5 header: addr=0 len=1 -> channel 0 |
| 975 | **DUT** | IN  pkt #5 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 975 | yapp monitor | RX pkt #5 on the input: addr=0 len=1 parity=good gap=20 |
| 975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 980 | yapp driver | TX pkt #5 accepted by the DUT |
| 980 | yapp driver | TX pkt #6: addr=0 len=1 parity=good delay=4 |
| 1025 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> channel 0 |
| 1045 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1045 | yapp monitor | RX pkt #6 on the input: addr=0 len=1 parity=good gap=4 |
| 1045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1050 | yapp driver | TX pkt #6 accepted by the DUT |
| 1050 | yapp driver | TX pkt #7: addr=0 len=1 parity=good delay=20 |
| 1065 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 1080 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1195 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 14 cycles |
| 1195 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 1195 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 1205 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1225 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 1225 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=good |
| 1225 | scoreboard | ch0 pkt matched: addr=0 len=1 (6 matched so far) |
| 1255 | **DUT** | IN  pkt #7 header: addr=0 len=1 -> channel 0 |
| 1265 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1275 | **DUT** | IN  pkt #7 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1275 | yapp monitor | RX pkt #7 on the input: addr=0 len=1 parity=good gap=20 |
| 1275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1280 | yapp driver | TX pkt #7 accepted by the DUT |
| 1280 | yapp driver | TX pkt #8: addr=0 len=1 parity=good delay=20 |
| 1285 | **DUT** | OUT ch0 pkt #7 done: 3 bytes in 3 cycles |
| 1285 | ch0 monitor | ch0 RX pkt #7: addr=0 len=1 parity=good |
| 1285 | scoreboard | ch0 pkt matched: addr=0 len=1 (7 matched so far) |
| 1320 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1485 | **DUT** | IN  pkt #8 header: addr=0 len=1 -> channel 0 |
| 1505 | **DUT** | IN  pkt #8 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1505 | yapp monitor | RX pkt #8 on the input: addr=0 len=1 parity=good gap=20 |
| 1505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1510 | yapp driver | TX pkt #8 accepted by the DUT |
| 1510 | yapp driver | TX pkt #9: addr=0 len=1 parity=good delay=4 |
| 1555 | **DUT** | IN  pkt #9 header: addr=0 len=1 -> channel 0 |
| 1575 | **DUT** | IN  pkt #9 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1575 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 1575 | yapp monitor | RX pkt #9 on the input: addr=0 len=1 parity=good gap=4 |
| 1575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1580 | yapp driver | TX pkt #9 accepted by the DUT |
| 1580 | yapp driver | TX pkt #10: addr=0 len=1 parity=good delay=1 |
| 1590 | ch0 driver | ch0: packet consumed (response delay 8) |
| 1595 | **DUT** | IN  pkt #10 header: addr=0 len=1 -> channel 0 |
| 1615 | **DUT** | IN  pkt #10 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1615 | yapp monitor | RX pkt #10 on the input: addr=0 len=1 parity=good gap=1 |
| 1615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1620 | yapp driver | TX pkt #10 accepted by the DUT |
| 1620 | yapp driver | TX pkt #11: addr=0 len=1 parity=good delay=10 |
| 1705 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 14 cycles |
| 1705 | ch0 monitor | ch0 RX pkt #8: addr=0 len=1 parity=good |
| 1705 | scoreboard | ch0 pkt matched: addr=0 len=1 (8 matched so far) |
| 1715 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1725 | **DUT** | IN  pkt #11 header: addr=0 len=1 -> channel 0 |
| 1735 | **DUT** | OUT ch0 pkt #9 done: 3 bytes in 3 cycles |
| 1735 | ch0 monitor | ch0 RX pkt #9: addr=0 len=1 parity=good |
| 1735 | scoreboard | ch0 pkt matched: addr=0 len=1 (9 matched so far) |
| 1745 | **DUT** | IN  pkt #11 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1745 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1745 | yapp monitor | RX pkt #11 on the input: addr=0 len=1 parity=good gap=10 |
| 1745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1750 | yapp driver | TX pkt #11 accepted by the DUT |
| 1750 | yapp driver | TX pkt #12: addr=0 len=1 parity=good delay=16 |
| 1765 | **DUT** | OUT ch0 pkt #10 done: 3 bytes in 3 cycles |
| 1765 | ch0 monitor | ch0 RX pkt #10: addr=0 len=1 parity=good |
| 1765 | scoreboard | ch0 pkt matched: addr=0 len=1 (10 matched so far) |
| 1775 | **DUT** | OUT ch0 pkt #11 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1795 | **DUT** | OUT ch0 pkt #11 done: 3 bytes in 3 cycles |
| 1795 | ch0 monitor | ch0 RX pkt #11: addr=0 len=1 parity=good |
| 1795 | scoreboard | ch0 pkt matched: addr=0 len=1 (11 matched so far) |
| 1915 | **DUT** | IN  pkt #12 header: addr=0 len=1 -> channel 0 |
| 1925 | **DUT** | OUT ch0 pkt #12 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1935 | **DUT** | IN  pkt #12 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1935 | yapp monitor | RX pkt #12 on the input: addr=0 len=1 parity=good gap=16 |
| 1935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1940 | yapp driver | TX pkt #12 accepted by the DUT |
| 1940 | yapp driver | TX pkt #13: addr=0 len=1 parity=good delay=20 |
| 1945 | **DUT** | OUT ch0 pkt #12 done: 3 bytes in 3 cycles |
| 1945 | ch0 monitor | ch0 RX pkt #12: addr=0 len=1 parity=good |
| 1945 | scoreboard | ch0 pkt matched: addr=0 len=1 (12 matched so far) |
| 2030 | ch0 driver | ch0: packet consumed (response delay 10) |
| 2145 | **DUT** | IN  pkt #13 header: addr=0 len=1 -> channel 0 |
| 2165 | **DUT** | IN  pkt #13 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2165 | yapp monitor | RX pkt #13 on the input: addr=0 len=1 parity=good gap=20 |
| 2165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2170 | yapp driver | TX pkt #13 accepted by the DUT |
| 2170 | yapp driver | TX pkt #14: addr=0 len=1 parity=good delay=10 |
| 2205 | **DUT** | OUT ch0 pkt #13 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 2220 | ch0 driver | ch0: packet consumed (response delay 5) |
| 2275 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> channel 0 |
| 2295 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2295 | yapp monitor | RX pkt #14 on the input: addr=0 len=1 parity=good gap=10 |
| 2295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2300 | yapp driver | TX pkt #14 accepted by the DUT |
| 2300 | yapp driver | TX pkt #15: addr=0 len=1 parity=good delay=14 |
| 2325 | **DUT** | OUT ch0 pkt #13 done: 3 bytes in 13 cycles |
| 2325 | ch0 monitor | ch0 RX pkt #13: addr=0 len=1 parity=good |
| 2325 | scoreboard | ch0 pkt matched: addr=0 len=1 (13 matched so far) |
| 2335 | **DUT** | OUT ch0 pkt #14 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2355 | **DUT** | OUT ch0 pkt #14 done: 3 bytes in 3 cycles |
| 2355 | ch0 monitor | ch0 RX pkt #14: addr=0 len=1 parity=good |
| 2355 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 2410 | ch0 driver | ch0: packet consumed (response delay 9) |
| 2445 | **DUT** | IN  pkt #15 header: addr=0 len=1 -> channel 0 |
| 2465 | **DUT** | IN  pkt #15 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2465 | yapp monitor | RX pkt #15 on the input: addr=0 len=1 parity=good gap=14 |
| 2465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2470 | yapp driver | TX pkt #15 accepted by the DUT |
| 2470 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=9 |
| 2495 | **DUT** | OUT ch0 pkt #15 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 2510 | ch0 driver | ch0: packet consumed (response delay 4) |
| 2555 | **DUT** | OUT ch0 pkt #15 done: 3 bytes in 7 cycles |
| 2555 | ch0 monitor | ch0 RX pkt #15: addr=0 len=1 parity=good |
| 2555 | scoreboard | ch0 pkt matched: addr=0 len=1 (15 matched so far) |
| 2565 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 2575 | **DUT** | OUT ch0 pkt #16 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2585 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2585 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=9 |
| 2585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2590 | yapp driver | TX pkt #16 accepted by the DUT |
| 2590 | yapp driver | TX pkt #17: addr=0 len=1 parity=good delay=17 |
| 2595 | **DUT** | OUT ch0 pkt #16 done: 3 bytes in 3 cycles |
| 2595 | ch0 monitor | ch0 RX pkt #16: addr=0 len=1 parity=good |
| 2595 | scoreboard | ch0 pkt matched: addr=0 len=1 (16 matched so far) |
| 2640 | ch0 driver | ch0: packet consumed (response delay 3) |
| 2765 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 2785 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2785 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=good gap=17 |
| 2785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2790 | yapp driver | TX pkt #17 accepted by the DUT |
| 2790 | yapp driver | TX pkt #18: addr=0 len=1 parity=good delay=17 |
| 2805 | **DUT** | OUT ch0 pkt #17 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 2820 | ch0 driver | ch0: packet consumed (response delay 3) |
| 2835 | **DUT** | OUT ch0 pkt #17 done: 3 bytes in 4 cycles |
| 2835 | ch0 monitor | ch0 RX pkt #17: addr=0 len=1 parity=good |
| 2835 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 2965 | **DUT** | IN  pkt #18 header: addr=0 len=1 -> channel 0 |
| 2975 | **DUT** | OUT ch0 pkt #18 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2985 | **DUT** | IN  pkt #18 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2985 | yapp monitor | RX pkt #18 on the input: addr=0 len=1 parity=good gap=17 |
| 2985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2990 | yapp driver | TX pkt #18 accepted by the DUT |
| 2990 | yapp driver | TX pkt #19: addr=0 len=1 parity=good delay=17 |
| 2995 | **DUT** | OUT ch0 pkt #18 done: 3 bytes in 3 cycles |
| 2995 | ch0 monitor | ch0 RX pkt #18: addr=0 len=1 parity=good |
| 2995 | scoreboard | ch0 pkt matched: addr=0 len=1 (18 matched so far) |
| 3165 | **DUT** | IN  pkt #19 header: addr=0 len=1 -> channel 0 |
| 3175 | **DUT** | OUT ch0 pkt #19 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3185 | **DUT** | IN  pkt #19 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3185 | yapp monitor | RX pkt #19 on the input: addr=0 len=1 parity=good gap=17 |
| 3185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3190 | yapp driver | TX pkt #19 accepted by the DUT |
| 3190 | yapp driver | TX pkt #20: addr=0 len=1 parity=good delay=20 |
| 3195 | **DUT** | OUT ch0 pkt #19 done: 3 bytes in 3 cycles |
| 3195 | ch0 monitor | ch0 RX pkt #19: addr=0 len=1 parity=good |
| 3195 | scoreboard | ch0 pkt matched: addr=0 len=1 (19 matched so far) |
| 3270 | ch0 driver | ch0: packet consumed (response delay 0) |
| 3395 | **DUT** | IN  pkt #20 header: addr=0 len=1 -> channel 0 |
| 3415 | **DUT** | IN  pkt #20 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3415 | yapp monitor | RX pkt #20 on the input: addr=0 len=1 parity=good gap=20 |
| 3415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3420 | yapp driver | TX pkt #20 accepted by the DUT |
| 3420 | yapp driver | TX pkt #21: addr=0 len=1 parity=good delay=6 |
| 3485 | **DUT** | IN  pkt #21 header: addr=0 len=1 -> channel 0 |
| 3495 | **DUT** | OUT ch0 pkt #20 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 3505 | **DUT** | IN  pkt #21 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3505 | yapp monitor | RX pkt #21 on the input: addr=0 len=1 parity=good gap=6 |
| 3505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3510 | ch0 driver | ch0: packet consumed (response delay 9) |
| 3510 | yapp driver | TX pkt #21 accepted by the DUT |
| 3510 | yapp driver | TX pkt #22: addr=0 len=1 parity=good delay=4 |
| 3555 | **DUT** | IN  pkt #22 header: addr=0 len=1 -> channel 0 |
| 3575 | **DUT** | IN  pkt #22 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3575 | yapp monitor | RX pkt #22 on the input: addr=0 len=1 parity=good gap=4 |
| 3575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3580 | yapp driver | TX pkt #22 accepted by the DUT |
| 3580 | yapp driver | TX pkt #23: addr=0 len=1 parity=good delay=11 |
| 3625 | **DUT** | OUT ch0 pkt #20 done: 3 bytes in 14 cycles |
| 3625 | ch0 monitor | ch0 RX pkt #20: addr=0 len=1 parity=good |
| 3625 | scoreboard | ch0 pkt matched: addr=0 len=1 (20 matched so far) |
| 3635 | **DUT** | OUT ch0 pkt #21 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3655 | **DUT** | OUT ch0 pkt #21 done: 3 bytes in 3 cycles |
| 3655 | ch0 monitor | ch0 RX pkt #21: addr=0 len=1 parity=good |
| 3655 | scoreboard | ch0 pkt matched: addr=0 len=1 (21 matched so far) |
| 3665 | **DUT** | OUT ch0 pkt #22 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3685 | **DUT** | OUT ch0 pkt #22 done: 3 bytes in 3 cycles |
| 3685 | ch0 monitor | ch0 RX pkt #22: addr=0 len=1 parity=good |
| 3685 | scoreboard | ch0 pkt matched: addr=0 len=1 (22 matched so far) |
| 3695 | **DUT** | IN  pkt #23 header: addr=0 len=1 -> channel 0 |
| 3700 | ch0 driver | ch0: packet consumed (response delay 10) |
| 3715 | **DUT** | IN  pkt #23 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3715 | yapp monitor | RX pkt #23 on the input: addr=0 len=1 parity=good gap=11 |
| 3715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3720 | yapp driver | TX pkt #23 accepted by the DUT |
| 3720 | yapp driver | TX pkt #24: addr=0 len=1 parity=good delay=17 |
| 3785 | **DUT** | OUT ch0 pkt #23 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 3800 | ch0 driver | ch0: packet consumed (response delay 7) |
| 3875 | **DUT** | OUT ch0 pkt #23 done: 3 bytes in 10 cycles |
| 3875 | ch0 monitor | ch0 RX pkt #23: addr=0 len=1 parity=good |
| 3875 | scoreboard | ch0 pkt matched: addr=0 len=1 (23 matched so far) |
| 3895 | **DUT** | IN  pkt #24 header: addr=0 len=1 -> channel 0 |
| 3905 | **DUT** | OUT ch0 pkt #24 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3915 | **DUT** | IN  pkt #24 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3915 | yapp monitor | RX pkt #24 on the input: addr=0 len=1 parity=good gap=17 |
| 3915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3920 | yapp driver | TX pkt #24 accepted by the DUT |
| 3920 | yapp driver | TX pkt #25: addr=0 len=1 parity=good delay=20 |
| 3925 | **DUT** | OUT ch0 pkt #24 done: 3 bytes in 3 cycles |
| 3925 | ch0 monitor | ch0 RX pkt #24: addr=0 len=1 parity=good |
| 3925 | scoreboard | ch0 pkt matched: addr=0 len=1 (24 matched so far) |
| 4125 | **DUT** | IN  pkt #25 header: addr=0 len=1 -> channel 0 |
| 4135 | **DUT** | OUT ch0 pkt #25 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4145 | **DUT** | IN  pkt #25 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4145 | yapp monitor | RX pkt #25 on the input: addr=0 len=1 parity=good gap=20 |
| 4145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4150 | yapp driver | TX pkt #25 accepted by the DUT |
| 4150 | yapp driver | TX pkt #26: addr=0 len=1 parity=good delay=15 |
| 4155 | **DUT** | OUT ch0 pkt #25 done: 3 bytes in 3 cycles |
| 4155 | ch0 monitor | ch0 RX pkt #25: addr=0 len=1 parity=good |
| 4155 | scoreboard | ch0 pkt matched: addr=0 len=1 (25 matched so far) |
| 4305 | **DUT** | IN  pkt #26 header: addr=0 len=1 -> channel 0 |
| 4315 | **DUT** | OUT ch0 pkt #26 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4325 | **DUT** | IN  pkt #26 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4325 | yapp monitor | RX pkt #26 on the input: addr=0 len=1 parity=good gap=15 |
| 4325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4330 | yapp driver | TX pkt #26 accepted by the DUT |
| 4330 | yapp driver | TX pkt #27: addr=0 len=1 parity=good delay=9 |
| 4335 | **DUT** | OUT ch0 pkt #26 done: 3 bytes in 3 cycles |
| 4335 | ch0 monitor | ch0 RX pkt #26: addr=0 len=1 parity=good |
| 4335 | scoreboard | ch0 pkt matched: addr=0 len=1 (26 matched so far) |
| 4340 | ch0 driver | ch0: packet consumed (response delay 6) |
| 4425 | **DUT** | IN  pkt #27 header: addr=0 len=1 -> channel 0 |
| 4445 | **DUT** | IN  pkt #27 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4445 | yapp monitor | RX pkt #27 on the input: addr=0 len=1 parity=good gap=9 |
| 4445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4450 | yapp driver | TX pkt #27 accepted by the DUT |
| 4450 | yapp driver | TX pkt #28: addr=0 len=1 parity=good delay=1 |
| 4465 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 4475 | **DUT** | OUT ch0 pkt #27 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 4485 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4485 | yapp monitor | RX pkt #28 on the input: addr=0 len=1 parity=good gap=1 |
| 4485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4490 | ch0 driver | ch0: packet consumed (response delay 4) |
| 4490 | yapp driver | TX pkt #28 accepted by the DUT |
| 4490 | yapp driver | TX pkt #29: addr=0 len=1 parity=good delay=11 |
| 4605 | **DUT** | IN  pkt #29 header: addr=0 len=1 -> channel 0 |
| 4605 | **DUT** | OUT ch0 pkt #27 done: 3 bytes in 14 cycles |
| 4605 | ch0 monitor | ch0 RX pkt #27: addr=0 len=1 parity=good |
| 4605 | scoreboard | ch0 pkt matched: addr=0 len=1 (27 matched so far) |
| 4615 | **DUT** | OUT ch0 pkt #28 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4625 | **DUT** | IN  pkt #29 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4625 | yapp monitor | RX pkt #29 on the input: addr=0 len=1 parity=good gap=11 |
| 4625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4630 | yapp driver | TX pkt #29 accepted by the DUT |
| 4630 | yapp driver | TX pkt #30: addr=0 len=1 parity=good delay=14 |
| 4635 | **DUT** | OUT ch0 pkt #28 done: 3 bytes in 3 cycles |
| 4635 | ch0 monitor | ch0 RX pkt #28: addr=0 len=1 parity=good |
| 4635 | scoreboard | ch0 pkt matched: addr=0 len=1 (28 matched so far) |
| 4645 | **DUT** | OUT ch0 pkt #29 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4665 | **DUT** | OUT ch0 pkt #29 done: 3 bytes in 3 cycles |
| 4665 | ch0 monitor | ch0 RX pkt #29: addr=0 len=1 parity=good |
| 4665 | scoreboard | ch0 pkt matched: addr=0 len=1 (29 matched so far) |
| 4775 | **DUT** | IN  pkt #30 header: addr=0 len=1 -> channel 0 |
| 4785 | **DUT** | OUT ch0 pkt #30 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4795 | **DUT** | IN  pkt #30 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4795 | yapp monitor | RX pkt #30 on the input: addr=0 len=1 parity=good gap=14 |
| 4795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4800 | yapp driver | TX pkt #30 accepted by the DUT |
| 4800 | yapp driver | TX pkt #31: addr=0 len=1 parity=good delay=20 |
| 4805 | **DUT** | OUT ch0 pkt #30 done: 3 bytes in 3 cycles |
| 4805 | ch0 monitor | ch0 RX pkt #30: addr=0 len=1 parity=good |
| 4805 | scoreboard | ch0 pkt matched: addr=0 len=1 (30 matched so far) |
| 4820 | ch0 driver | ch0: packet consumed (response delay 10) |
| 5005 | **DUT** | IN  pkt #31 header: addr=0 len=1 -> channel 0 |
| 5025 | **DUT** | IN  pkt #31 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5025 | yapp monitor | RX pkt #31 on the input: addr=0 len=1 parity=good gap=20 |
| 5025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5030 | yapp driver | TX pkt #31 accepted by the DUT |
| 5030 | yapp driver | TX pkt #32: addr=0 len=1 parity=good delay=20 |
| 5065 | **DUT** | OUT ch0 pkt #31 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 5080 | ch0 driver | ch0: packet consumed (response delay 5) |
| 5185 | **DUT** | OUT ch0 pkt #31 done: 3 bytes in 13 cycles |
| 5185 | ch0 monitor | ch0 RX pkt #31: addr=0 len=1 parity=good |
| 5185 | scoreboard | ch0 pkt matched: addr=0 len=1 (31 matched so far) |
| 5235 | **DUT** | IN  pkt #32 header: addr=0 len=1 -> channel 0 |
| 5245 | **DUT** | OUT ch0 pkt #32 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5255 | **DUT** | IN  pkt #32 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5255 | yapp monitor | RX pkt #32 on the input: addr=0 len=1 parity=good gap=20 |
| 5255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5260 | yapp driver | TX pkt #32 accepted by the DUT |
| 5260 | yapp driver | TX pkt #33: addr=0 len=1 parity=good delay=16 |
| 5265 | **DUT** | OUT ch0 pkt #32 done: 3 bytes in 3 cycles |
| 5265 | ch0 monitor | ch0 RX pkt #32: addr=0 len=1 parity=good |
| 5265 | scoreboard | ch0 pkt matched: addr=0 len=1 (32 matched so far) |
| 5425 | **DUT** | IN  pkt #33 header: addr=0 len=1 -> channel 0 |
| 5435 | **DUT** | OUT ch0 pkt #33 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5445 | **DUT** | IN  pkt #33 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5445 | yapp monitor | RX pkt #33 on the input: addr=0 len=1 parity=good gap=16 |
| 5445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5450 | yapp driver | TX pkt #33 accepted by the DUT |
| 5450 | yapp driver | TX pkt #34: addr=0 len=1 parity=good delay=10 |
| 5455 | **DUT** | OUT ch0 pkt #33 done: 3 bytes in 3 cycles |
| 5455 | ch0 monitor | ch0 RX pkt #33: addr=0 len=1 parity=good |
| 5455 | scoreboard | ch0 pkt matched: addr=0 len=1 (33 matched so far) |
| 5520 | ch0 driver | ch0: packet consumed (response delay 9) |
| 5555 | **DUT** | IN  pkt #34 header: addr=0 len=1 -> channel 0 |
| 5575 | **DUT** | IN  pkt #34 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5575 | yapp monitor | RX pkt #34 on the input: addr=0 len=1 parity=good gap=10 |
| 5575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5580 | yapp driver | TX pkt #34 accepted by the DUT |
| 5580 | yapp driver | TX pkt #35: addr=0 len=1 parity=good delay=12 |
| 5645 | **DUT** | OUT ch0 pkt #34 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 5660 | ch0 driver | ch0: packet consumed (response delay 8) |
| 5705 | **DUT** | IN  pkt #35 header: addr=0 len=1 -> channel 0 |
| 5725 | **DUT** | IN  pkt #35 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5725 | yapp monitor | RX pkt #35 on the input: addr=0 len=1 parity=good gap=12 |
| 5725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5730 | yapp driver | TX pkt #35 accepted by the DUT |
| 5730 | yapp driver | TX pkt #36: addr=0 len=1 parity=good delay=20 |
| 5775 | **DUT** | OUT ch0 pkt #34 done: 3 bytes in 14 cycles |
| 5775 | ch0 monitor | ch0 RX pkt #34: addr=0 len=1 parity=good |
| 5775 | scoreboard | ch0 pkt matched: addr=0 len=1 (34 matched so far) |
| 5785 | **DUT** | OUT ch0 pkt #35 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5805 | **DUT** | OUT ch0 pkt #35 done: 3 bytes in 3 cycles |
| 5805 | ch0 monitor | ch0 RX pkt #35: addr=0 len=1 parity=good |
| 5805 | scoreboard | ch0 pkt matched: addr=0 len=1 (35 matched so far) |
| 5935 | **DUT** | IN  pkt #36 header: addr=0 len=1 -> channel 0 |
| 5945 | **DUT** | OUT ch0 pkt #36 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5955 | **DUT** | IN  pkt #36 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5955 | yapp monitor | RX pkt #36 on the input: addr=0 len=1 parity=good gap=20 |
| 5955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5960 | yapp driver | TX pkt #36 accepted by the DUT |
| 5960 | yapp driver | TX pkt #37: addr=0 len=1 parity=good delay=20 |
| 5965 | **DUT** | OUT ch0 pkt #36 done: 3 bytes in 3 cycles |
| 5965 | ch0 monitor | ch0 RX pkt #36: addr=0 len=1 parity=good |
| 5965 | scoreboard | ch0 pkt matched: addr=0 len=1 (36 matched so far) |
| 6110 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6165 | **DUT** | IN  pkt #37 header: addr=0 len=1 -> channel 0 |
| 6185 | **DUT** | IN  pkt #37 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6185 | yapp monitor | RX pkt #37 on the input: addr=0 len=1 parity=good gap=20 |
| 6185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6190 | yapp driver | TX pkt #37 accepted by the DUT |
| 6190 | yapp driver | TX pkt #38: addr=0 len=1 parity=good delay=20 |
| 6255 | **DUT** | OUT ch0 pkt #37 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 6270 | ch0 driver | ch0: packet consumed (response delay 8) |
| 6285 | **DUT** | OUT ch0 pkt #37 done: 3 bytes in 4 cycles |
| 6285 | ch0 monitor | ch0 RX pkt #37: addr=0 len=1 parity=good |
| 6285 | scoreboard | ch0 pkt matched: addr=0 len=1 (37 matched so far) |
| 6395 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 6405 | **DUT** | OUT ch0 pkt #38 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6415 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6415 | yapp monitor | RX pkt #38 on the input: addr=0 len=1 parity=good gap=20 |
| 6415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6420 | yapp driver | TX pkt #38 accepted by the DUT |
| 6420 | yapp driver | TX pkt #39: addr=0 len=1 parity=good delay=20 |
| 6425 | **DUT** | OUT ch0 pkt #38 done: 3 bytes in 3 cycles |
| 6425 | ch0 monitor | ch0 RX pkt #38: addr=0 len=1 parity=good |
| 6425 | scoreboard | ch0 pkt matched: addr=0 len=1 (38 matched so far) |
| 6440 | ch0 driver | ch0: packet consumed (response delay 0) |
| 6625 | **DUT** | IN  pkt #39 header: addr=0 len=1 -> channel 0 |
| 6645 | **DUT** | IN  pkt #39 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6645 | yapp monitor | RX pkt #39 on the input: addr=0 len=1 parity=good gap=20 |
| 6645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6650 | yapp driver | TX pkt #39 accepted by the DUT |
| 6650 | yapp driver | TX pkt #40: addr=0 len=1 parity=good delay=20 |
| 6735 | **DUT** | OUT ch0 pkt #39 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 6750 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6825 | **DUT** | OUT ch0 pkt #39 done: 3 bytes in 10 cycles |
| 6825 | ch0 monitor | ch0 RX pkt #39: addr=0 len=1 parity=good |
| 6825 | scoreboard | ch0 pkt matched: addr=0 len=1 (39 matched so far) |
| 6855 | **DUT** | IN  pkt #40 header: addr=0 len=1 -> channel 0 |
| 6865 | **DUT** | OUT ch0 pkt #40 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6875 | **DUT** | IN  pkt #40 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6875 | yapp monitor | RX pkt #40 on the input: addr=0 len=1 parity=good gap=20 |
| 6875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6880 | yapp driver | TX pkt #40 accepted by the DUT |
| 6880 | yapp driver | TX pkt #41: addr=0 len=1 parity=good delay=1 |
| 6885 | **DUT** | OUT ch0 pkt #40 done: 3 bytes in 3 cycles |
| 6885 | ch0 monitor | ch0 RX pkt #40: addr=0 len=1 parity=good |
| 6885 | scoreboard | ch0 pkt matched: addr=0 len=1 (40 matched so far) |
| 6895 | **DUT** | IN  pkt #41 header: addr=0 len=1 -> channel 0 |
| 6905 | **DUT** | OUT ch0 pkt #41 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6915 | **DUT** | IN  pkt #41 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6915 | yapp monitor | RX pkt #41 on the input: addr=0 len=1 parity=good gap=1 |
| 6915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6920 | yapp driver | TX pkt #41 accepted by the DUT |
| 6920 | yapp driver | TX pkt #42: addr=0 len=1 parity=good delay=17 |
| 6925 | **DUT** | OUT ch0 pkt #41 done: 3 bytes in 3 cycles |
| 6925 | ch0 monitor | ch0 RX pkt #41: addr=0 len=1 parity=good |
| 6925 | scoreboard | ch0 pkt matched: addr=0 len=1 (41 matched so far) |
| 7000 | ch0 driver | ch0: packet consumed (response delay 6) |
| 7095 | **DUT** | IN  pkt #42 header: addr=0 len=1 -> channel 0 |
| 7115 | **DUT** | IN  pkt #42 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7115 | yapp monitor | RX pkt #42 on the input: addr=0 len=1 parity=good gap=17 |
| 7115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7120 | yapp driver | TX pkt #42 accepted by the DUT |
| 7120 | yapp driver | TX pkt #43: addr=0 len=1 parity=good delay=10 |
| 7185 | **DUT** | OUT ch0 pkt #42 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 7200 | ch0 driver | ch0: packet consumed (response delay 8) |
| 7225 | **DUT** | IN  pkt #43 header: addr=0 len=1 -> channel 0 |
| 7245 | **DUT** | IN  pkt #43 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7245 | yapp monitor | RX pkt #43 on the input: addr=0 len=1 parity=good gap=10 |
| 7245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7250 | yapp driver | TX pkt #43 accepted by the DUT |
| 7250 | yapp driver | TX pkt #44: addr=0 len=1 parity=good delay=20 |
| 7315 | **DUT** | OUT ch0 pkt #42 done: 3 bytes in 14 cycles |
| 7315 | ch0 monitor | ch0 RX pkt #42: addr=0 len=1 parity=good |
| 7315 | scoreboard | ch0 pkt matched: addr=0 len=1 (42 matched so far) |
| 7325 | **DUT** | OUT ch0 pkt #43 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7345 | **DUT** | OUT ch0 pkt #43 done: 3 bytes in 3 cycles |
| 7345 | ch0 monitor | ch0 RX pkt #43: addr=0 len=1 parity=good |
| 7345 | scoreboard | ch0 pkt matched: addr=0 len=1 (43 matched so far) |
| 7455 | **DUT** | IN  pkt #44 header: addr=0 len=1 -> channel 0 |
| 7465 | **DUT** | OUT ch0 pkt #44 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7475 | **DUT** | IN  pkt #44 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7475 | yapp monitor | RX pkt #44 on the input: addr=0 len=1 parity=good gap=20 |
| 7475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7480 | yapp driver | TX pkt #44 accepted by the DUT |
| 7480 | yapp driver | TX pkt #45: addr=0 len=1 parity=good delay=16 |
| 7485 | **DUT** | OUT ch0 pkt #44 done: 3 bytes in 3 cycles |
| 7485 | ch0 monitor | ch0 RX pkt #44: addr=0 len=1 parity=good |
| 7485 | scoreboard | ch0 pkt matched: addr=0 len=1 (44 matched so far) |
| 7645 | **DUT** | IN  pkt #45 header: addr=0 len=1 -> channel 0 |
| 7650 | ch0 driver | ch0: packet consumed (response delay 10) |
| 7665 | **DUT** | IN  pkt #45 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7665 | yapp monitor | RX pkt #45 on the input: addr=0 len=1 parity=good gap=16 |
| 7665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7670 | yapp driver | TX pkt #45 accepted by the DUT |
| 7670 | yapp driver | TX pkt #46: addr=0 len=1 parity=good delay=20 |
| 7765 | **DUT** | OUT ch0 pkt #45 start: addr=0 len=1 (receiver waited 11 cycle(s)) |
| 7780 | ch0 driver | ch0: packet consumed (response delay 10) |
| 7875 | **DUT** | IN  pkt #46 header: addr=0 len=1 -> channel 0 |
| 7885 | **DUT** | OUT ch0 pkt #45 done: 3 bytes in 13 cycles |
| 7885 | ch0 monitor | ch0 RX pkt #45: addr=0 len=1 parity=good |
| 7885 | scoreboard | ch0 pkt matched: addr=0 len=1 (45 matched so far) |
| 7895 | **DUT** | IN  pkt #46 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7895 | **DUT** | OUT ch0 pkt #46 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7895 | yapp monitor | RX pkt #46 on the input: addr=0 len=1 parity=good gap=20 |
| 7895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7900 | yapp driver | TX pkt #46 accepted by the DUT |
| 7900 | yapp driver | TX pkt #47: addr=0 len=1 parity=good delay=3 |
| 7915 | **DUT** | OUT ch0 pkt #46 done: 3 bytes in 3 cycles |
| 7915 | ch0 monitor | ch0 RX pkt #46: addr=0 len=1 parity=good |
| 7915 | scoreboard | ch0 pkt matched: addr=0 len=1 (46 matched so far) |
| 7935 | **DUT** | IN  pkt #47 header: addr=0 len=1 -> channel 0 |
| 7945 | **DUT** | OUT ch0 pkt #47 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7955 | **DUT** | IN  pkt #47 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7955 | yapp monitor | RX pkt #47 on the input: addr=0 len=1 parity=good gap=3 |
| 7955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7960 | yapp driver | TX pkt #47 accepted by the DUT |
| 7960 | yapp driver | TX pkt #48: addr=0 len=1 parity=good delay=20 |
| 7965 | **DUT** | OUT ch0 pkt #47 done: 3 bytes in 3 cycles |
| 7965 | ch0 monitor | ch0 RX pkt #47: addr=0 len=1 parity=good |
| 7965 | scoreboard | ch0 pkt matched: addr=0 len=1 (47 matched so far) |
| 8070 | ch0 driver | ch0: packet consumed (response delay 9) |
| 8165 | **DUT** | IN  pkt #48 header: addr=0 len=1 -> channel 0 |
| 8185 | **DUT** | IN  pkt #48 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8185 | yapp monitor | RX pkt #48 on the input: addr=0 len=1 parity=good gap=20 |
| 8185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8190 | yapp driver | TX pkt #48 accepted by the DUT |
| 8190 | yapp driver | TX pkt #49: addr=0 len=1 parity=good delay=17 |
| 8255 | **DUT** | OUT ch0 pkt #48 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 8270 | ch0 driver | ch0: packet consumed (response delay 8) |
| 8365 | **DUT** | IN  pkt #49 header: addr=0 len=1 -> channel 0 |
| 8375 | **DUT** | OUT ch0 pkt #48 done: 3 bytes in 13 cycles |
| 8375 | ch0 monitor | ch0 RX pkt #48: addr=0 len=1 parity=good |
| 8375 | scoreboard | ch0 pkt matched: addr=0 len=1 (48 matched so far) |
| 8385 | **DUT** | IN  pkt #49 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8385 | **DUT** | OUT ch0 pkt #49 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8385 | yapp monitor | RX pkt #49 on the input: addr=0 len=1 parity=good gap=17 |
| 8385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8390 | yapp driver | TX pkt #49 accepted by the DUT |
| 8390 | yapp driver | TX pkt #50: addr=0 len=1 parity=good delay=18 |
| 8405 | **DUT** | OUT ch0 pkt #49 done: 3 bytes in 3 cycles |
| 8405 | ch0 monitor | ch0 RX pkt #49: addr=0 len=1 parity=good |
| 8405 | scoreboard | ch0 pkt matched: addr=0 len=1 (49 matched so far) |
| 8575 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> channel 0 |
| 8585 | **DUT** | OUT ch0 pkt #50 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8595 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8595 | yapp monitor | RX pkt #50 on the input: addr=0 len=1 parity=good gap=18 |
| 8595 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8600 | ch0 driver | ch0: packet consumed (response delay 9) |
| 8600 | yapp driver | TX pkt #50 accepted by the DUT |
| 8600 | yapp driver | TX pkt #51: addr=0 len=1 parity=good delay=1 |
| 8615 | **DUT** | IN  pkt #51 header: addr=0 len=1 -> channel 0 |
| 8635 | **DUT** | IN  pkt #51 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8635 | yapp monitor | RX pkt #51 on the input: addr=0 len=1 parity=good gap=1 |
| 8635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8640 | yapp driver | TX pkt #51 accepted by the DUT |
| 8640 | yapp driver | TX pkt #52: addr=0 len=1 parity=good delay=20 |
| 8675 | **DUT** | OUT ch0 pkt #50 done: 3 bytes in 10 cycles |
| 8675 | ch0 monitor | ch0 RX pkt #50: addr=0 len=1 parity=good |
| 8675 | scoreboard | ch0 pkt matched: addr=0 len=1 (50 matched so far) |
| 8685 | **DUT** | OUT ch0 pkt #51 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8705 | **DUT** | OUT ch0 pkt #51 done: 3 bytes in 3 cycles |
| 8705 | ch0 monitor | ch0 RX pkt #51: addr=0 len=1 parity=good |
| 8705 | scoreboard | ch0 pkt matched: addr=0 len=1 (51 matched so far) |
| 8845 | **DUT** | IN  pkt #52 header: addr=0 len=1 -> channel 0 |
| 8855 | **DUT** | OUT ch0 pkt #52 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8865 | **DUT** | IN  pkt #52 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8865 | yapp monitor | RX pkt #52 on the input: addr=0 len=1 parity=good gap=20 |
| 8865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8870 | yapp driver | TX pkt #52 accepted by the DUT |
| 8870 | yapp driver | TX pkt #53: addr=0 len=1 parity=good delay=15 |
| 8875 | **DUT** | OUT ch0 pkt #52 done: 3 bytes in 3 cycles |
| 8875 | ch0 monitor | ch0 RX pkt #52: addr=0 len=1 parity=good |
| 8875 | scoreboard | ch0 pkt matched: addr=0 len=1 (52 matched so far) |
| 9025 | **DUT** | IN  pkt #53 header: addr=0 len=1 -> channel 0 |
| 9035 | **DUT** | OUT ch0 pkt #53 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9045 | **DUT** | IN  pkt #53 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9045 | yapp monitor | RX pkt #53 on the input: addr=0 len=1 parity=good gap=15 |
| 9045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9050 | yapp driver | TX pkt #53 accepted by the DUT |
| 9050 | yapp driver | TX pkt #54: addr=0 len=1 parity=good delay=17 |
| 9055 | **DUT** | OUT ch0 pkt #53 done: 3 bytes in 3 cycles |
| 9055 | ch0 monitor | ch0 RX pkt #53: addr=0 len=1 parity=good |
| 9055 | scoreboard | ch0 pkt matched: addr=0 len=1 (53 matched so far) |
| 9210 | ch0 driver | ch0: packet consumed (response delay 6) |
| 9225 | **DUT** | IN  pkt #54 header: addr=0 len=1 -> channel 0 |
| 9245 | **DUT** | IN  pkt #54 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9245 | **DUT** | OUT ch0 pkt #54 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 9245 | yapp monitor | RX pkt #54 on the input: addr=0 len=1 parity=good gap=17 |
| 9245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9250 | yapp driver | TX pkt #54 accepted by the DUT |
| 9250 | yapp driver | TX pkt #55: addr=0 len=1 parity=good delay=17 |
| 9260 | ch0 driver | ch0: packet consumed (response delay 1) |
| 9315 | **DUT** | OUT ch0 pkt #54 done: 3 bytes in 8 cycles |
| 9315 | ch0 monitor | ch0 RX pkt #54: addr=0 len=1 parity=good |
| 9315 | scoreboard | ch0 pkt matched: addr=0 len=1 (54 matched so far) |
| 9370 | ch0 driver | ch0: packet consumed (response delay 4) |
| 9425 | **DUT** | IN  pkt #55 header: addr=0 len=1 -> channel 0 |
| 9445 | **DUT** | IN  pkt #55 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9445 | yapp monitor | RX pkt #55 on the input: addr=0 len=1 parity=good gap=17 |
| 9445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9450 | yapp driver | TX pkt #55 accepted by the DUT |
| 9450 | yapp driver | TX pkt #56: addr=0 len=1 parity=good delay=20 |
| 9525 | **DUT** | OUT ch0 pkt #55 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 9540 | ch0 driver | ch0: packet consumed (response delay 9) |
| 9645 | **DUT** | OUT ch0 pkt #55 done: 3 bytes in 13 cycles |
| 9645 | ch0 monitor | ch0 RX pkt #55: addr=0 len=1 parity=good |
| 9645 | scoreboard | ch0 pkt matched: addr=0 len=1 (55 matched so far) |
| 9655 | **DUT** | IN  pkt #56 header: addr=0 len=1 -> channel 0 |
| 9665 | **DUT** | OUT ch0 pkt #56 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9675 | **DUT** | IN  pkt #56 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9675 | yapp monitor | RX pkt #56 on the input: addr=0 len=1 parity=good gap=20 |
| 9675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9680 | yapp driver | TX pkt #56 accepted by the DUT |
| 9680 | yapp driver | TX pkt #57: addr=0 len=1 parity=good delay=20 |
| 9685 | **DUT** | OUT ch0 pkt #56 done: 3 bytes in 3 cycles |
| 9685 | ch0 monitor | ch0 RX pkt #56: addr=0 len=1 parity=good |
| 9685 | scoreboard | ch0 pkt matched: addr=0 len=1 (56 matched so far) |
| 9885 | **DUT** | IN  pkt #57 header: addr=0 len=1 -> channel 0 |
| 9895 | **DUT** | OUT ch0 pkt #57 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9905 | **DUT** | IN  pkt #57 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9905 | yapp monitor | RX pkt #57 on the input: addr=0 len=1 parity=good gap=20 |
| 9905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9910 | yapp driver | TX pkt #57 accepted by the DUT |
| 9910 | yapp driver | TX pkt #58: addr=0 len=1 parity=good delay=2 |
| 9915 | **DUT** | OUT ch0 pkt #57 done: 3 bytes in 3 cycles |
| 9915 | ch0 monitor | ch0 RX pkt #57: addr=0 len=1 parity=good |
| 9915 | scoreboard | ch0 pkt matched: addr=0 len=1 (57 matched so far) |
| 9935 | **DUT** | IN  pkt #58 header: addr=0 len=1 -> channel 0 |
| 9945 | **DUT** | OUT ch0 pkt #58 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9955 | **DUT** | IN  pkt #58 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9955 | yapp monitor | RX pkt #58 on the input: addr=0 len=1 parity=good gap=2 |
| 9955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9960 | yapp driver | TX pkt #58 accepted by the DUT |
| 9960 | yapp driver | TX pkt #59: addr=0 len=1 parity=good delay=5 |
| 9965 | **DUT** | OUT ch0 pkt #58 done: 3 bytes in 3 cycles |
| 9965 | ch0 monitor | ch0 RX pkt #58: addr=0 len=1 parity=good |
| 9965 | scoreboard | ch0 pkt matched: addr=0 len=1 (58 matched so far) |
| 10015 | **DUT** | IN  pkt #59 header: addr=0 len=1 -> channel 0 |
| 10025 | **DUT** | OUT ch0 pkt #59 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10035 | **DUT** | IN  pkt #59 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10035 | yapp monitor | RX pkt #59 on the input: addr=0 len=1 parity=good gap=5 |
| 10035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10040 | yapp driver | TX pkt #59 accepted by the DUT |
| 10040 | yapp driver | TX pkt #60: addr=0 len=1 parity=good delay=13 |
| 10045 | **DUT** | OUT ch0 pkt #59 done: 3 bytes in 3 cycles |
| 10045 | ch0 monitor | ch0 RX pkt #59: addr=0 len=1 parity=good |
| 10045 | scoreboard | ch0 pkt matched: addr=0 len=1 (59 matched so far) |
| 10050 | ch0 driver | ch0: packet consumed (response delay 9) |
| 10175 | **DUT** | IN  pkt #60 header: addr=0 len=1 -> channel 0 |
| 10195 | **DUT** | IN  pkt #60 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10195 | yapp monitor | RX pkt #60 on the input: addr=0 len=1 parity=good gap=13 |
| 10195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10200 | yapp driver | TX pkt #60 accepted by the DUT |
| 10200 | yapp driver | TX pkt #61: addr=0 len=1 parity=good delay=17 |
| 10245 | **DUT** | OUT ch0 pkt #60 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 10260 | ch0 driver | ch0: packet consumed (response delay 6) |
| 10325 | **DUT** | OUT ch0 pkt #60 done: 3 bytes in 9 cycles |
| 10325 | ch0 monitor | ch0 RX pkt #60: addr=0 len=1 parity=good |
| 10325 | scoreboard | ch0 pkt matched: addr=0 len=1 (60 matched so far) |
| 10375 | **DUT** | IN  pkt #61 header: addr=0 len=1 -> channel 0 |
| 10385 | **DUT** | OUT ch0 pkt #61 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10395 | **DUT** | IN  pkt #61 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10395 | yapp monitor | RX pkt #61 on the input: addr=0 len=1 parity=good gap=17 |
| 10395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10400 | yapp driver | TX pkt #61 accepted by the DUT |
| 10400 | yapp driver | TX pkt #62: addr=0 len=1 parity=good delay=3 |
| 10405 | **DUT** | OUT ch0 pkt #61 done: 3 bytes in 3 cycles |
| 10405 | ch0 monitor | ch0 RX pkt #61: addr=0 len=1 parity=good |
| 10405 | scoreboard | ch0 pkt matched: addr=0 len=1 (61 matched so far) |
| 10435 | **DUT** | IN  pkt #62 header: addr=0 len=1 -> channel 0 |
| 10445 | **DUT** | OUT ch0 pkt #62 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10455 | **DUT** | IN  pkt #62 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10455 | yapp monitor | RX pkt #62 on the input: addr=0 len=1 parity=good gap=3 |
| 10455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10460 | yapp driver | TX pkt #62 accepted by the DUT |
| 10460 | yapp driver | TX pkt #63: addr=0 len=1 parity=good delay=17 |
| 10465 | **DUT** | OUT ch0 pkt #62 done: 3 bytes in 3 cycles |
| 10465 | ch0 monitor | ch0 RX pkt #62: addr=0 len=1 parity=good |
| 10465 | scoreboard | ch0 pkt matched: addr=0 len=1 (62 matched so far) |
| 10635 | **DUT** | IN  pkt #63 header: addr=0 len=1 -> channel 0 |
| 10645 | **DUT** | OUT ch0 pkt #63 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10655 | **DUT** | IN  pkt #63 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10655 | yapp monitor | RX pkt #63 on the input: addr=0 len=1 parity=good gap=17 |
| 10655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10660 | yapp driver | TX pkt #63 accepted by the DUT |
| 10660 | yapp driver | TX pkt #64: addr=0 len=1 parity=good delay=7 |
| 10665 | **DUT** | OUT ch0 pkt #63 done: 3 bytes in 3 cycles |
| 10665 | ch0 monitor | ch0 RX pkt #63: addr=0 len=1 parity=good |
| 10665 | scoreboard | ch0 pkt matched: addr=0 len=1 (63 matched so far) |
| 10735 | **DUT** | IN  pkt #64 header: addr=0 len=1 -> channel 0 |
| 10745 | **DUT** | OUT ch0 pkt #64 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10755 | **DUT** | IN  pkt #64 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10755 | yapp monitor | RX pkt #64 on the input: addr=0 len=1 parity=good gap=7 |
| 10755 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10760 | yapp driver | TX pkt #64 accepted by the DUT |
| 10760 | yapp driver | TX pkt #65: addr=0 len=1 parity=good delay=17 |
| 10765 | **DUT** | OUT ch0 pkt #64 done: 3 bytes in 3 cycles |
| 10765 | ch0 monitor | ch0 RX pkt #64: addr=0 len=1 parity=good |
| 10765 | scoreboard | ch0 pkt matched: addr=0 len=1 (64 matched so far) |
| 10790 | ch0 driver | ch0: packet consumed (response delay 5) |
| 10935 | **DUT** | IN  pkt #65 header: addr=0 len=1 -> channel 0 |
| 10955 | **DUT** | IN  pkt #65 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10955 | yapp monitor | RX pkt #65 on the input: addr=0 len=1 parity=good gap=17 |
| 10955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10960 | yapp driver | TX pkt #65 accepted by the DUT |
| 10960 | yapp driver | TX pkt #66: addr=0 len=1 parity=good delay=1 |
| 10975 | **DUT** | IN  pkt #66 header: addr=0 len=1 -> channel 0 |
| 10995 | **DUT** | IN  pkt #66 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10995 | yapp monitor | RX pkt #66 on the input: addr=0 len=1 parity=good gap=1 |
| 10995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11000 | yapp driver | TX pkt #66 accepted by the DUT |
| 11000 | yapp driver | TX pkt #67: addr=0 len=1 parity=good delay=19 |
| 11045 | **DUT** | OUT ch0 pkt #65 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 11060 | ch0 driver | ch0: packet consumed (response delay 10) |
| 11145 | **DUT** | OUT ch0 pkt #65 done: 3 bytes in 11 cycles |
| 11145 | ch0 monitor | ch0 RX pkt #65: addr=0 len=1 parity=good |
| 11145 | scoreboard | ch0 pkt matched: addr=0 len=1 (65 matched so far) |
| 11155 | **DUT** | OUT ch0 pkt #66 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11175 | **DUT** | OUT ch0 pkt #66 done: 3 bytes in 3 cycles |
| 11175 | ch0 monitor | ch0 RX pkt #66: addr=0 len=1 parity=good |
| 11175 | scoreboard | ch0 pkt matched: addr=0 len=1 (66 matched so far) |
| 11195 | **DUT** | IN  pkt #67 header: addr=0 len=1 -> channel 0 |
| 11205 | **DUT** | OUT ch0 pkt #67 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11215 | **DUT** | IN  pkt #67 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11215 | yapp monitor | RX pkt #67 on the input: addr=0 len=1 parity=good gap=19 |
| 11215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11220 | yapp driver | TX pkt #67 accepted by the DUT |
| 11220 | yapp driver | TX pkt #68: addr=0 len=1 parity=good delay=1 |
| 11225 | **DUT** | OUT ch0 pkt #67 done: 3 bytes in 3 cycles |
| 11225 | ch0 monitor | ch0 RX pkt #67: addr=0 len=1 parity=good |
| 11225 | scoreboard | ch0 pkt matched: addr=0 len=1 (67 matched so far) |
| 11235 | **DUT** | IN  pkt #68 header: addr=0 len=1 -> channel 0 |
| 11245 | **DUT** | OUT ch0 pkt #68 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11255 | **DUT** | IN  pkt #68 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11255 | yapp monitor | RX pkt #68 on the input: addr=0 len=1 parity=good gap=1 |
| 11255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11260 | yapp driver | TX pkt #68 accepted by the DUT |
| 11260 | yapp driver | TX pkt #69: addr=0 len=1 parity=good delay=11 |
| 11265 | **DUT** | OUT ch0 pkt #68 done: 3 bytes in 3 cycles |
| 11265 | ch0 monitor | ch0 RX pkt #68: addr=0 len=1 parity=good |
| 11265 | scoreboard | ch0 pkt matched: addr=0 len=1 (68 matched so far) |
| 11375 | **DUT** | IN  pkt #69 header: addr=0 len=1 -> channel 0 |
| 11385 | **DUT** | OUT ch0 pkt #69 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11395 | **DUT** | IN  pkt #69 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11395 | yapp monitor | RX pkt #69 on the input: addr=0 len=1 parity=good gap=11 |
| 11395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11400 | yapp driver | TX pkt #69 accepted by the DUT |
| 11400 | yapp driver | TX pkt #70: addr=0 len=1 parity=good delay=16 |
| 11405 | **DUT** | OUT ch0 pkt #69 done: 3 bytes in 3 cycles |
| 11405 | ch0 monitor | ch0 RX pkt #69: addr=0 len=1 parity=good |
| 11405 | scoreboard | ch0 pkt matched: addr=0 len=1 (69 matched so far) |
| 11565 | **DUT** | IN  pkt #70 header: addr=0 len=1 -> channel 0 |
| 11575 | **DUT** | OUT ch0 pkt #70 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11585 | **DUT** | IN  pkt #70 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11585 | yapp monitor | RX pkt #70 on the input: addr=0 len=1 parity=good gap=16 |
| 11585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11590 | yapp driver | TX pkt #70 accepted by the DUT |
| 11590 | yapp driver | TX pkt #71: addr=0 len=1 parity=good delay=13 |
| 11595 | **DUT** | OUT ch0 pkt #70 done: 3 bytes in 3 cycles |
| 11595 | ch0 monitor | ch0 RX pkt #70: addr=0 len=1 parity=good |
| 11595 | scoreboard | ch0 pkt matched: addr=0 len=1 (70 matched so far) |
| 11650 | ch0 driver | ch0: packet consumed (response delay 7) |
| 11725 | **DUT** | IN  pkt #71 header: addr=0 len=1 -> channel 0 |
| 11735 | **DUT** | OUT ch0 pkt #71 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11745 | **DUT** | IN  pkt #71 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11745 | yapp monitor | RX pkt #71 on the input: addr=0 len=1 parity=good gap=13 |
| 11745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11750 | ch0 driver | ch0: packet consumed (response delay 0) |
| 11750 | yapp driver | TX pkt #71 accepted by the DUT |
| 11750 | yapp driver | TX pkt #72: addr=0 len=1 parity=good delay=4 |
| 11795 | **DUT** | IN  pkt #72 header: addr=0 len=1 -> channel 0 |
| 11815 | **DUT** | IN  pkt #72 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11815 | **DUT** | OUT ch0 pkt #71 done: 3 bytes in 9 cycles |
| 11815 | ch0 monitor | ch0 RX pkt #71: addr=0 len=1 parity=good |
| 11815 | scoreboard | ch0 pkt matched: addr=0 len=1 (71 matched so far) |
| 11815 | yapp monitor | RX pkt #72 on the input: addr=0 len=1 parity=good gap=4 |
| 11815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11820 | yapp driver | TX pkt #72 accepted by the DUT |
| 11820 | yapp driver | TX pkt #73: addr=0 len=1 parity=good delay=18 |
| 11825 | **DUT** | OUT ch0 pkt #72 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11845 | **DUT** | OUT ch0 pkt #72 done: 3 bytes in 3 cycles |
| 11845 | ch0 monitor | ch0 RX pkt #72: addr=0 len=1 parity=good |
| 11845 | scoreboard | ch0 pkt matched: addr=0 len=1 (72 matched so far) |
| 11980 | ch0 driver | ch0: packet consumed (response delay 5) |
| 12005 | **DUT** | IN  pkt #73 header: addr=0 len=1 -> channel 0 |
| 12025 | **DUT** | IN  pkt #73 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12025 | yapp monitor | RX pkt #73 on the input: addr=0 len=1 parity=good gap=18 |
| 12025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12030 | yapp driver | TX pkt #73 accepted by the DUT |
| 12030 | yapp driver | TX pkt #74: addr=0 len=1 parity=good delay=6 |
| 12045 | **DUT** | OUT ch0 pkt #73 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 12060 | ch0 driver | ch0: packet consumed (response delay 3) |
| 12095 | **DUT** | IN  pkt #74 header: addr=0 len=1 -> channel 0 |
| 12115 | **DUT** | IN  pkt #74 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12115 | yapp monitor | RX pkt #74 on the input: addr=0 len=1 parity=good gap=6 |
| 12115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12120 | yapp driver | TX pkt #74 accepted by the DUT |
| 12120 | yapp driver | TX pkt #75: addr=0 len=1 parity=good delay=11 |
| 12145 | **DUT** | OUT ch0 pkt #73 done: 3 bytes in 11 cycles |
| 12145 | ch0 monitor | ch0 RX pkt #73: addr=0 len=1 parity=good |
| 12145 | scoreboard | ch0 pkt matched: addr=0 len=1 (73 matched so far) |
| 12155 | **DUT** | OUT ch0 pkt #74 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12175 | **DUT** | OUT ch0 pkt #74 done: 3 bytes in 3 cycles |
| 12175 | ch0 monitor | ch0 RX pkt #74: addr=0 len=1 parity=good |
| 12175 | scoreboard | ch0 pkt matched: addr=0 len=1 (74 matched so far) |
| 12235 | **DUT** | IN  pkt #75 header: addr=0 len=1 -> channel 0 |
| 12245 | **DUT** | OUT ch0 pkt #75 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12255 | **DUT** | IN  pkt #75 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12255 | yapp monitor | RX pkt #75 on the input: addr=0 len=1 parity=good gap=11 |
| 12255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12260 | yapp driver | TX pkt #75 accepted by the DUT |
| 12260 | yapp driver | TX pkt #76: addr=0 len=1 parity=good delay=17 |
| 12265 | **DUT** | OUT ch0 pkt #75 done: 3 bytes in 3 cycles |
| 12265 | ch0 monitor | ch0 RX pkt #75: addr=0 len=1 parity=good |
| 12265 | scoreboard | ch0 pkt matched: addr=0 len=1 (75 matched so far) |
| 12435 | **DUT** | IN  pkt #76 header: addr=0 len=1 -> channel 0 |
| 12445 | **DUT** | OUT ch0 pkt #76 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12455 | **DUT** | IN  pkt #76 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12455 | yapp monitor | RX pkt #76 on the input: addr=0 len=1 parity=good gap=17 |
| 12455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12460 | yapp driver | TX pkt #76 accepted by the DUT |
| 12460 | yapp driver | TX pkt #77: addr=0 len=1 parity=good delay=4 |
| 12465 | **DUT** | OUT ch0 pkt #76 done: 3 bytes in 3 cycles |
| 12465 | ch0 monitor | ch0 RX pkt #76: addr=0 len=1 parity=good |
| 12465 | scoreboard | ch0 pkt matched: addr=0 len=1 (76 matched so far) |
| 12505 | **DUT** | IN  pkt #77 header: addr=0 len=1 -> channel 0 |
| 12515 | **DUT** | OUT ch0 pkt #77 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12525 | **DUT** | IN  pkt #77 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12525 | yapp monitor | RX pkt #77 on the input: addr=0 len=1 parity=good gap=4 |
| 12525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12530 | yapp driver | TX pkt #77 accepted by the DUT |
| 12530 | yapp driver | TX pkt #78: addr=0 len=1 parity=good delay=9 |
| 12535 | **DUT** | OUT ch0 pkt #77 done: 3 bytes in 3 cycles |
| 12535 | ch0 monitor | ch0 RX pkt #77: addr=0 len=1 parity=good |
| 12535 | scoreboard | ch0 pkt matched: addr=0 len=1 (77 matched so far) |
| 12550 | ch0 driver | ch0: packet consumed (response delay 7) |
| 12625 | **DUT** | IN  pkt #78 header: addr=0 len=1 -> channel 0 |
| 12645 | **DUT** | IN  pkt #78 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12645 | yapp monitor | RX pkt #78 on the input: addr=0 len=1 parity=good gap=9 |
| 12645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12650 | yapp driver | TX pkt #78 accepted by the DUT |
| 12650 | yapp driver | TX pkt #79: addr=0 len=1 parity=good delay=17 |
| 12735 | **DUT** | OUT ch0 pkt #78 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 12750 | ch0 driver | ch0: packet consumed (response delay 10) |
| 12765 | **DUT** | OUT ch0 pkt #78 done: 3 bytes in 4 cycles |
| 12765 | ch0 monitor | ch0 RX pkt #78: addr=0 len=1 parity=good |
| 12765 | scoreboard | ch0 pkt matched: addr=0 len=1 (78 matched so far) |
| 12825 | **DUT** | IN  pkt #79 header: addr=0 len=1 -> channel 0 |
| 12835 | **DUT** | OUT ch0 pkt #79 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12845 | **DUT** | IN  pkt #79 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12845 | yapp monitor | RX pkt #79 on the input: addr=0 len=1 parity=good gap=17 |
| 12845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12850 | yapp driver | TX pkt #79 accepted by the DUT |
| 12850 | yapp driver | TX pkt #80: addr=0 len=1 parity=good delay=16 |
| 12855 | **DUT** | OUT ch0 pkt #79 done: 3 bytes in 3 cycles |
| 12855 | ch0 monitor | ch0 RX pkt #79: addr=0 len=1 parity=good |
| 12855 | scoreboard | ch0 pkt matched: addr=0 len=1 (79 matched so far) |
| 13015 | **DUT** | IN  pkt #80 header: addr=0 len=1 -> channel 0 |
| 13025 | **DUT** | OUT ch0 pkt #80 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13035 | **DUT** | IN  pkt #80 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13035 | yapp monitor | RX pkt #80 on the input: addr=0 len=1 parity=good gap=16 |
| 13035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13040 | yapp driver | TX pkt #80 accepted by the DUT |
| 13040 | yapp driver | TX pkt #81: addr=0 len=1 parity=good delay=20 |
| 13045 | **DUT** | OUT ch0 pkt #80 done: 3 bytes in 3 cycles |
| 13045 | ch0 monitor | ch0 RX pkt #80: addr=0 len=1 parity=good |
| 13045 | scoreboard | ch0 pkt matched: addr=0 len=1 (80 matched so far) |
| 13245 | **DUT** | IN  pkt #81 header: addr=0 len=1 -> channel 0 |
| 13255 | **DUT** | OUT ch0 pkt #81 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13260 | ch0 driver | ch0: packet consumed (response delay 0) |
| 13265 | **DUT** | IN  pkt #81 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13265 | yapp monitor | RX pkt #81 on the input: addr=0 len=1 parity=good gap=20 |
| 13265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13270 | yapp driver | TX pkt #81 accepted by the DUT |
| 13270 | yapp driver | TX pkt #82: addr=0 len=1 parity=good delay=3 |
| 13305 | **DUT** | IN  pkt #82 header: addr=0 len=1 -> channel 0 |
| 13325 | **DUT** | IN  pkt #82 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13325 | yapp monitor | RX pkt #82 on the input: addr=0 len=1 parity=good gap=3 |
| 13325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13330 | yapp driver | TX pkt #82 accepted by the DUT |
| 13330 | yapp driver | TX pkt #83: addr=0 len=1 parity=good delay=4 |
| 13375 | **DUT** | IN  pkt #83 header: addr=0 len=1 -> channel 0 |
| 13385 | **DUT** | OUT ch0 pkt #81 done: 3 bytes in 14 cycles |
| 13385 | ch0 monitor | ch0 RX pkt #81: addr=0 len=1 parity=good |
| 13385 | scoreboard | ch0 pkt matched: addr=0 len=1 (81 matched so far) |
| 13395 | **DUT** | IN  pkt #83 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13395 | **DUT** | OUT ch0 pkt #82 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13395 | yapp monitor | RX pkt #83 on the input: addr=0 len=1 parity=good gap=4 |
| 13395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13400 | yapp driver | TX pkt #83 accepted by the DUT |
| 13400 | yapp driver | TX pkt #84: addr=0 len=1 parity=good delay=18 |
| 13415 | **DUT** | OUT ch0 pkt #82 done: 3 bytes in 3 cycles |
| 13415 | ch0 monitor | ch0 RX pkt #82: addr=0 len=1 parity=good |
| 13415 | scoreboard | ch0 pkt matched: addr=0 len=1 (82 matched so far) |
| 13425 | **DUT** | OUT ch0 pkt #83 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13445 | **DUT** | OUT ch0 pkt #83 done: 3 bytes in 3 cycles |
| 13445 | ch0 monitor | ch0 RX pkt #83: addr=0 len=1 parity=good |
| 13445 | scoreboard | ch0 pkt matched: addr=0 len=1 (83 matched so far) |
| 13585 | **DUT** | IN  pkt #84 header: addr=0 len=1 -> channel 0 |
| 13595 | **DUT** | OUT ch0 pkt #84 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13605 | **DUT** | IN  pkt #84 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13605 | yapp monitor | RX pkt #84 on the input: addr=0 len=1 parity=good gap=18 |
| 13605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13610 | yapp driver | TX pkt #84 accepted by the DUT |
| 13610 | yapp driver | TX pkt #85: addr=0 len=1 parity=good delay=20 |
| 13615 | **DUT** | OUT ch0 pkt #84 done: 3 bytes in 3 cycles |
| 13615 | ch0 monitor | ch0 RX pkt #84: addr=0 len=1 parity=good |
| 13615 | scoreboard | ch0 pkt matched: addr=0 len=1 (84 matched so far) |
| 13700 | ch0 driver | ch0: packet consumed (response delay 10) |
| 13815 | **DUT** | IN  pkt #85 header: addr=0 len=1 -> channel 0 |
| 13835 | **DUT** | IN  pkt #85 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13835 | yapp monitor | RX pkt #85 on the input: addr=0 len=1 parity=good gap=20 |
| 13835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13840 | yapp driver | TX pkt #85 accepted by the DUT |
| 13840 | yapp driver | TX pkt #86: addr=0 len=1 parity=good delay=13 |
| 13885 | **DUT** | OUT ch0 pkt #85 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 13900 | ch0 driver | ch0: packet consumed (response delay 6) |
| 13925 | **DUT** | OUT ch0 pkt #85 done: 3 bytes in 5 cycles |
| 13925 | ch0 monitor | ch0 RX pkt #85: addr=0 len=1 parity=good |
| 13925 | scoreboard | ch0 pkt matched: addr=0 len=1 (85 matched so far) |
| 13975 | **DUT** | IN  pkt #86 header: addr=0 len=1 -> channel 0 |
| 13985 | **DUT** | OUT ch0 pkt #86 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13995 | **DUT** | IN  pkt #86 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13995 | yapp monitor | RX pkt #86 on the input: addr=0 len=1 parity=good gap=13 |
| 13995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14000 | yapp driver | TX pkt #86 accepted by the DUT |
| 14000 | yapp driver | TX pkt #87: addr=0 len=1 parity=good delay=3 |
| 14005 | **DUT** | OUT ch0 pkt #86 done: 3 bytes in 3 cycles |
| 14005 | ch0 monitor | ch0 RX pkt #86: addr=0 len=1 parity=good |
| 14005 | scoreboard | ch0 pkt matched: addr=0 len=1 (86 matched so far) |
| 14035 | **DUT** | IN  pkt #87 header: addr=0 len=1 -> channel 0 |
| 14045 | **DUT** | OUT ch0 pkt #87 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14055 | **DUT** | IN  pkt #87 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14055 | yapp monitor | RX pkt #87 on the input: addr=0 len=1 parity=good gap=3 |
| 14055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14060 | yapp driver | TX pkt #87 accepted by the DUT |
| 14060 | yapp driver | TX pkt #88: addr=0 len=1 parity=good delay=4 |
| 14065 | **DUT** | OUT ch0 pkt #87 done: 3 bytes in 3 cycles |
| 14065 | ch0 monitor | ch0 RX pkt #87: addr=0 len=1 parity=good |
| 14065 | scoreboard | ch0 pkt matched: addr=0 len=1 (87 matched so far) |
| 14105 | **DUT** | IN  pkt #88 header: addr=0 len=1 -> channel 0 |
| 14115 | **DUT** | OUT ch0 pkt #88 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14125 | **DUT** | IN  pkt #88 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14125 | yapp monitor | RX pkt #88 on the input: addr=0 len=1 parity=good gap=4 |
| 14125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14130 | yapp driver | TX pkt #88 accepted by the DUT |
| 14130 | yapp driver | TX pkt #89: addr=0 len=1 parity=good delay=5 |
| 14135 | **DUT** | OUT ch0 pkt #88 done: 3 bytes in 3 cycles |
| 14135 | ch0 monitor | ch0 RX pkt #88: addr=0 len=1 parity=good |
| 14135 | scoreboard | ch0 pkt matched: addr=0 len=1 (88 matched so far) |
| 14185 | **DUT** | IN  pkt #89 header: addr=0 len=1 -> channel 0 |
| 14195 | **DUT** | OUT ch0 pkt #89 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14205 | **DUT** | IN  pkt #89 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14205 | yapp monitor | RX pkt #89 on the input: addr=0 len=1 parity=good gap=5 |
| 14205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14210 | yapp driver | TX pkt #89 accepted by the DUT |
| 14210 | yapp driver | TX pkt #90: addr=0 len=1 parity=good delay=20 |
| 14215 | **DUT** | OUT ch0 pkt #89 done: 3 bytes in 3 cycles |
| 14215 | ch0 monitor | ch0 RX pkt #89: addr=0 len=1 parity=good |
| 14215 | scoreboard | ch0 pkt matched: addr=0 len=1 (89 matched so far) |
| 14415 | **DUT** | IN  pkt #90 header: addr=0 len=1 -> channel 0 |
| 14420 | ch0 driver | ch0: packet consumed (response delay 1) |
| 14435 | **DUT** | IN  pkt #90 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14435 | yapp monitor | RX pkt #90 on the input: addr=0 len=1 parity=good gap=20 |
| 14435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14440 | yapp driver | TX pkt #90 accepted by the DUT |
| 14440 | yapp driver | TX pkt #91: addr=0 len=1 parity=good delay=10 |
| 14485 | **DUT** | OUT ch0 pkt #90 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 14500 | ch0 driver | ch0: packet consumed (response delay 5) |
| 14545 | **DUT** | IN  pkt #91 header: addr=0 len=1 -> channel 0 |
| 14565 | **DUT** | IN  pkt #91 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14565 | yapp monitor | RX pkt #91 on the input: addr=0 len=1 parity=good gap=10 |
| 14565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14570 | yapp driver | TX pkt #91 accepted by the DUT |
| 14570 | yapp driver | TX pkt #92: addr=0 len=1 parity=good delay=20 |
| 14615 | **DUT** | OUT ch0 pkt #90 done: 3 bytes in 14 cycles |
| 14615 | ch0 monitor | ch0 RX pkt #90: addr=0 len=1 parity=good |
| 14615 | scoreboard | ch0 pkt matched: addr=0 len=1 (90 matched so far) |
| 14625 | **DUT** | OUT ch0 pkt #91 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14645 | **DUT** | OUT ch0 pkt #91 done: 3 bytes in 3 cycles |
| 14645 | ch0 monitor | ch0 RX pkt #91: addr=0 len=1 parity=good |
| 14645 | scoreboard | ch0 pkt matched: addr=0 len=1 (91 matched so far) |
| 14775 | **DUT** | IN  pkt #92 header: addr=0 len=1 -> channel 0 |
| 14785 | **DUT** | OUT ch0 pkt #92 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14795 | **DUT** | IN  pkt #92 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14795 | yapp monitor | RX pkt #92 on the input: addr=0 len=1 parity=good gap=20 |
| 14795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14800 | yapp driver | TX pkt #92 accepted by the DUT |
| 14800 | yapp driver | TX pkt #93: addr=0 len=1 parity=good delay=2 |
| 14805 | **DUT** | OUT ch0 pkt #92 done: 3 bytes in 3 cycles |
| 14805 | ch0 monitor | ch0 RX pkt #92: addr=0 len=1 parity=good |
| 14805 | scoreboard | ch0 pkt matched: addr=0 len=1 (92 matched so far) |
| 14825 | **DUT** | IN  pkt #93 header: addr=0 len=1 -> channel 0 |
| 14835 | **DUT** | OUT ch0 pkt #93 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14845 | **DUT** | IN  pkt #93 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14845 | yapp monitor | RX pkt #93 on the input: addr=0 len=1 parity=good gap=2 |
| 14845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14850 | ch0 driver | ch0: packet consumed (response delay 10) |
| 14850 | yapp driver | TX pkt #93 accepted by the DUT |
| 14850 | yapp driver | TX pkt #94: addr=0 len=1 parity=good delay=6 |
| 14915 | **DUT** | IN  pkt #94 header: addr=0 len=1 -> channel 0 |
| 14935 | **DUT** | IN  pkt #94 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14935 | **DUT** | OUT ch0 pkt #93 done: 3 bytes in 11 cycles |
| 14935 | ch0 monitor | ch0 RX pkt #93: addr=0 len=1 parity=good |
| 14935 | scoreboard | ch0 pkt matched: addr=0 len=1 (93 matched so far) |
| 14935 | yapp monitor | RX pkt #94 on the input: addr=0 len=1 parity=good gap=6 |
| 14935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14940 | yapp driver | TX pkt #94 accepted by the DUT |
| 14940 | yapp driver | TX pkt #95: addr=0 len=1 parity=good delay=5 |
| 14945 | **DUT** | OUT ch0 pkt #94 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14965 | **DUT** | OUT ch0 pkt #94 done: 3 bytes in 3 cycles |
| 14965 | ch0 monitor | ch0 RX pkt #94: addr=0 len=1 parity=good |
| 14965 | scoreboard | ch0 pkt matched: addr=0 len=1 (94 matched so far) |
| 14995 | **DUT** | IN  pkt #95 header: addr=0 len=1 -> channel 0 |
| 15005 | **DUT** | OUT ch0 pkt #95 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15015 | **DUT** | IN  pkt #95 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15015 | yapp monitor | RX pkt #95 on the input: addr=0 len=1 parity=good gap=5 |
| 15015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15020 | yapp driver | TX pkt #95 accepted by the DUT |
| 15020 | yapp driver | TX pkt #96: addr=0 len=1 parity=good delay=20 |
| 15025 | **DUT** | OUT ch0 pkt #95 done: 3 bytes in 3 cycles |
| 15025 | ch0 monitor | ch0 RX pkt #95: addr=0 len=1 parity=good |
| 15025 | scoreboard | ch0 pkt matched: addr=0 len=1 (95 matched so far) |
| 15225 | **DUT** | IN  pkt #96 header: addr=0 len=1 -> channel 0 |
| 15235 | **DUT** | OUT ch0 pkt #96 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15245 | **DUT** | IN  pkt #96 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15245 | yapp monitor | RX pkt #96 on the input: addr=0 len=1 parity=good gap=20 |
| 15245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15250 | yapp driver | TX pkt #96 accepted by the DUT |
| 15250 | yapp driver | TX pkt #97: addr=0 len=1 parity=good delay=17 |
| 15255 | **DUT** | OUT ch0 pkt #96 done: 3 bytes in 3 cycles |
| 15255 | ch0 monitor | ch0 RX pkt #96: addr=0 len=1 parity=good |
| 15255 | scoreboard | ch0 pkt matched: addr=0 len=1 (96 matched so far) |
| 15370 | ch0 driver | ch0: packet consumed (response delay 7) |
| 15425 | **DUT** | IN  pkt #97 header: addr=0 len=1 -> channel 0 |
| 15445 | **DUT** | IN  pkt #97 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15445 | yapp monitor | RX pkt #97 on the input: addr=0 len=1 parity=good gap=17 |
| 15445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15450 | yapp driver | TX pkt #97 accepted by the DUT |
| 15450 | yapp driver | TX pkt #98: addr=0 len=1 parity=good delay=8 |
| 15515 | **DUT** | OUT ch0 pkt #97 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 15530 | ch0 driver | ch0: packet consumed (response delay 8) |
| 15535 | **DUT** | IN  pkt #98 header: addr=0 len=1 -> channel 0 |
| 15555 | **DUT** | IN  pkt #98 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15555 | yapp monitor | RX pkt #98 on the input: addr=0 len=1 parity=good gap=8 |
| 15555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15560 | yapp driver | TX pkt #98 accepted by the DUT |
| 15560 | yapp driver | TX pkt #99: addr=0 len=1 parity=good delay=4 |
| 15605 | **DUT** | IN  pkt #99 header: addr=0 len=1 -> channel 0 |
| 15625 | **DUT** | IN  pkt #99 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15625 | yapp monitor | RX pkt #99 on the input: addr=0 len=1 parity=good gap=4 |
| 15625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15630 | yapp driver | TX pkt #99 accepted by the DUT |
| 15630 | yapp driver | TX pkt #100: addr=0 len=1 parity=good delay=17 |
| 15635 | **DUT** | OUT ch0 pkt #97 done: 3 bytes in 13 cycles |
| 15635 | ch0 monitor | ch0 RX pkt #97: addr=0 len=1 parity=good |
| 15635 | scoreboard | ch0 pkt matched: addr=0 len=1 (97 matched so far) |
| 15645 | **DUT** | OUT ch0 pkt #98 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15665 | **DUT** | OUT ch0 pkt #98 done: 3 bytes in 3 cycles |
| 15665 | ch0 monitor | ch0 RX pkt #98: addr=0 len=1 parity=good |
| 15665 | scoreboard | ch0 pkt matched: addr=0 len=1 (98 matched so far) |
| 15675 | **DUT** | OUT ch0 pkt #99 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15695 | **DUT** | OUT ch0 pkt #99 done: 3 bytes in 3 cycles |
| 15695 | ch0 monitor | ch0 RX pkt #99: addr=0 len=1 parity=good |
| 15695 | scoreboard | ch0 pkt matched: addr=0 len=1 (99 matched so far) |
| 15805 | **DUT** | IN  pkt #100 header: addr=0 len=1 -> channel 0 |
| 15815 | **DUT** | OUT ch0 pkt #100 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15825 | **DUT** | IN  pkt #100 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15825 | yapp monitor | RX pkt #100 on the input: addr=0 len=1 parity=good gap=17 |
| 15825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15830 | yapp driver | TX pkt #100 accepted by the DUT |
| 15830 | yapp driver | TX pkt #101: addr=0 len=1 parity=good delay=16 |
| 15835 | **DUT** | OUT ch0 pkt #100 done: 3 bytes in 3 cycles |
| 15835 | ch0 monitor | ch0 RX pkt #100: addr=0 len=1 parity=good |
| 15835 | scoreboard | ch0 pkt matched: addr=0 len=1 (100 matched so far) |
| 15995 | **DUT** | IN  pkt #101 header: addr=0 len=1 -> channel 0 |
| 16005 | **DUT** | OUT ch0 pkt #101 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16015 | **DUT** | IN  pkt #101 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16015 | yapp monitor | RX pkt #101 on the input: addr=0 len=1 parity=good gap=16 |
| 16015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16020 | yapp driver | TX pkt #101 accepted by the DUT |
| 16020 | yapp driver | TX pkt #102: addr=0 len=1 parity=good delay=16 |
| 16025 | **DUT** | OUT ch0 pkt #101 done: 3 bytes in 3 cycles |
| 16025 | ch0 monitor | ch0 RX pkt #101: addr=0 len=1 parity=good |
| 16025 | scoreboard | ch0 pkt matched: addr=0 len=1 (101 matched so far) |
| 16170 | ch0 driver | ch0: packet consumed (response delay 9) |
| 16185 | **DUT** | IN  pkt #102 header: addr=0 len=1 -> channel 0 |
| 16205 | **DUT** | IN  pkt #102 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16205 | yapp monitor | RX pkt #102 on the input: addr=0 len=1 parity=good gap=16 |
| 16205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16210 | yapp driver | TX pkt #102 accepted by the DUT |
| 16210 | yapp driver | TX pkt #103: addr=0 len=1 parity=good delay=9 |
| 16245 | **DUT** | OUT ch0 pkt #102 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 16260 | ch0 driver | ch0: packet consumed (response delay 5) |
| 16305 | **DUT** | IN  pkt #103 header: addr=0 len=1 -> channel 0 |
| 16305 | **DUT** | OUT ch0 pkt #102 done: 3 bytes in 7 cycles |
| 16305 | ch0 monitor | ch0 RX pkt #102: addr=0 len=1 parity=good |
| 16305 | scoreboard | ch0 pkt matched: addr=0 len=1 (102 matched so far) |
| 16315 | **DUT** | OUT ch0 pkt #103 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16325 | **DUT** | IN  pkt #103 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16325 | yapp monitor | RX pkt #103 on the input: addr=0 len=1 parity=good gap=9 |
| 16325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16330 | yapp driver | TX pkt #103 accepted by the DUT |
| 16330 | yapp driver | TX pkt #104: addr=0 len=1 parity=good delay=9 |
| 16335 | **DUT** | OUT ch0 pkt #103 done: 3 bytes in 3 cycles |
| 16335 | ch0 monitor | ch0 RX pkt #103: addr=0 len=1 parity=good |
| 16335 | scoreboard | ch0 pkt matched: addr=0 len=1 (103 matched so far) |
| 16425 | **DUT** | IN  pkt #104 header: addr=0 len=1 -> channel 0 |
| 16435 | **DUT** | OUT ch0 pkt #104 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16445 | **DUT** | IN  pkt #104 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16445 | yapp monitor | RX pkt #104 on the input: addr=0 len=1 parity=good gap=9 |
| 16445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16450 | yapp driver | TX pkt #104 accepted by the DUT |
| 16450 | yapp driver | TX pkt #105: addr=0 len=1 parity=good delay=17 |
| 16455 | **DUT** | OUT ch0 pkt #104 done: 3 bytes in 3 cycles |
| 16455 | ch0 monitor | ch0 RX pkt #104: addr=0 len=1 parity=good |
| 16455 | scoreboard | ch0 pkt matched: addr=0 len=1 (104 matched so far) |
| 16520 | ch0 driver | ch0: packet consumed (response delay 3) |
| 16625 | **DUT** | IN  pkt #105 header: addr=0 len=1 -> channel 0 |
| 16645 | **DUT** | IN  pkt #105 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16645 | yapp monitor | RX pkt #105 on the input: addr=0 len=1 parity=good gap=17 |
| 16645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16650 | yapp driver | TX pkt #105 accepted by the DUT |
| 16650 | yapp driver | TX pkt #106: addr=0 len=1 parity=good delay=5 |
| 16705 | **DUT** | IN  pkt #106 header: addr=0 len=1 -> channel 0 |
| 16725 | **DUT** | IN  pkt #106 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16725 | yapp monitor | RX pkt #106 on the input: addr=0 len=1 parity=good gap=5 |
| 16725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16730 | yapp driver | TX pkt #106 accepted by the DUT |
| 16730 | yapp driver | TX pkt #107: addr=0 len=1 parity=good delay=19 |
| 16735 | **DUT** | OUT ch0 pkt #105 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 16750 | ch0 driver | ch0: packet consumed (response delay 10) |
| 16855 | **DUT** | OUT ch0 pkt #105 done: 3 bytes in 13 cycles |
| 16855 | ch0 monitor | ch0 RX pkt #105: addr=0 len=1 parity=good |
| 16855 | scoreboard | ch0 pkt matched: addr=0 len=1 (105 matched so far) |
| 16865 | **DUT** | OUT ch0 pkt #106 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16885 | **DUT** | OUT ch0 pkt #106 done: 3 bytes in 3 cycles |
| 16885 | ch0 monitor | ch0 RX pkt #106: addr=0 len=1 parity=good |
| 16885 | scoreboard | ch0 pkt matched: addr=0 len=1 (106 matched so far) |
| 16925 | **DUT** | IN  pkt #107 header: addr=0 len=1 -> channel 0 |
| 16935 | **DUT** | OUT ch0 pkt #107 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16945 | **DUT** | IN  pkt #107 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16945 | yapp monitor | RX pkt #107 on the input: addr=0 len=1 parity=good gap=19 |
| 16945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16950 | yapp driver | TX pkt #107 accepted by the DUT |
| 16950 | yapp driver | TX pkt #108: addr=0 len=1 parity=good delay=15 |
| 16955 | **DUT** | OUT ch0 pkt #107 done: 3 bytes in 3 cycles |
| 16955 | ch0 monitor | ch0 RX pkt #107: addr=0 len=1 parity=good |
| 16955 | scoreboard | ch0 pkt matched: addr=0 len=1 (107 matched so far) |
| 17105 | **DUT** | IN  pkt #108 header: addr=0 len=1 -> channel 0 |
| 17115 | **DUT** | OUT ch0 pkt #108 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17125 | **DUT** | IN  pkt #108 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17125 | yapp monitor | RX pkt #108 on the input: addr=0 len=1 parity=good gap=15 |
| 17125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17130 | yapp driver | TX pkt #108 accepted by the DUT |
| 17130 | yapp driver | TX pkt #109: addr=0 len=1 parity=good delay=3 |
| 17135 | **DUT** | OUT ch0 pkt #108 done: 3 bytes in 3 cycles |
| 17135 | ch0 monitor | ch0 RX pkt #108: addr=0 len=1 parity=good |
| 17135 | scoreboard | ch0 pkt matched: addr=0 len=1 (108 matched so far) |
| 17165 | **DUT** | IN  pkt #109 header: addr=0 len=1 -> channel 0 |
| 17175 | **DUT** | OUT ch0 pkt #109 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17185 | **DUT** | IN  pkt #109 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17185 | yapp monitor | RX pkt #109 on the input: addr=0 len=1 parity=good gap=3 |
| 17185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17190 | yapp driver | TX pkt #109 accepted by the DUT |
| 17190 | yapp driver | TX pkt #110: addr=0 len=1 parity=good delay=18 |
| 17195 | **DUT** | OUT ch0 pkt #109 done: 3 bytes in 3 cycles |
| 17195 | ch0 monitor | ch0 RX pkt #109: addr=0 len=1 parity=good |
| 17195 | scoreboard | ch0 pkt matched: addr=0 len=1 (109 matched so far) |
| 17360 | ch0 driver | ch0: packet consumed (response delay 9) |
| 17375 | **DUT** | IN  pkt #110 header: addr=0 len=1 -> channel 0 |
| 17395 | **DUT** | IN  pkt #110 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17395 | yapp monitor | RX pkt #110 on the input: addr=0 len=1 parity=good gap=18 |
| 17395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17400 | yapp driver | TX pkt #110 accepted by the DUT |
| 17400 | yapp driver | TX pkt #111: addr=0 len=1 parity=good delay=11 |
| 17455 | **DUT** | OUT ch0 pkt #110 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 17470 | ch0 driver | ch0: packet consumed (response delay 7) |
| 17515 | **DUT** | IN  pkt #111 header: addr=0 len=1 -> channel 0 |
| 17515 | **DUT** | OUT ch0 pkt #110 done: 3 bytes in 7 cycles |
| 17515 | ch0 monitor | ch0 RX pkt #110: addr=0 len=1 parity=good |
| 17515 | scoreboard | ch0 pkt matched: addr=0 len=1 (110 matched so far) |
| 17525 | **DUT** | OUT ch0 pkt #111 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17535 | **DUT** | IN  pkt #111 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17535 | yapp monitor | RX pkt #111 on the input: addr=0 len=1 parity=good gap=11 |
| 17535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17540 | yapp driver | TX pkt #111 accepted by the DUT |
| 17540 | yapp driver | TX pkt #112: addr=0 len=1 parity=good delay=7 |
| 17545 | **DUT** | OUT ch0 pkt #111 done: 3 bytes in 3 cycles |
| 17545 | ch0 monitor | ch0 RX pkt #111: addr=0 len=1 parity=good |
| 17545 | scoreboard | ch0 pkt matched: addr=0 len=1 (111 matched so far) |
| 17615 | **DUT** | IN  pkt #112 header: addr=0 len=1 -> channel 0 |
| 17625 | **DUT** | OUT ch0 pkt #112 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17635 | **DUT** | IN  pkt #112 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17635 | yapp monitor | RX pkt #112 on the input: addr=0 len=1 parity=good gap=7 |
| 17635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17640 | yapp driver | TX pkt #112 accepted by the DUT |
| 17640 | yapp driver | TX pkt #113: addr=0 len=1 parity=good delay=17 |
| 17645 | **DUT** | OUT ch0 pkt #112 done: 3 bytes in 3 cycles |
| 17645 | ch0 monitor | ch0 RX pkt #112: addr=0 len=1 parity=good |
| 17645 | scoreboard | ch0 pkt matched: addr=0 len=1 (112 matched so far) |
| 17770 | ch0 driver | ch0: packet consumed (response delay 3) |
| 17815 | **DUT** | IN  pkt #113 header: addr=0 len=1 -> channel 0 |
| 17835 | **DUT** | IN  pkt #113 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17835 | yapp monitor | RX pkt #113 on the input: addr=0 len=1 parity=good gap=17 |
| 17835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17840 | yapp driver | TX pkt #113 accepted by the DUT |
| 17840 | yapp driver | TX pkt #114: addr=0 len=1 parity=good delay=17 |
| 17915 | **DUT** | OUT ch0 pkt #113 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 17930 | ch0 driver | ch0: packet consumed (response delay 9) |
| 17975 | **DUT** | OUT ch0 pkt #113 done: 3 bytes in 7 cycles |
| 17975 | ch0 monitor | ch0 RX pkt #113: addr=0 len=1 parity=good |
| 17975 | scoreboard | ch0 pkt matched: addr=0 len=1 (113 matched so far) |
| 18015 | **DUT** | IN  pkt #114 header: addr=0 len=1 -> channel 0 |
| 18025 | **DUT** | OUT ch0 pkt #114 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18035 | **DUT** | IN  pkt #114 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18035 | yapp monitor | RX pkt #114 on the input: addr=0 len=1 parity=good gap=17 |
| 18035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18040 | yapp driver | TX pkt #114 accepted by the DUT |
| 18040 | yapp driver | TX pkt #115: addr=0 len=1 parity=good delay=6 |
| 18045 | **DUT** | OUT ch0 pkt #114 done: 3 bytes in 3 cycles |
| 18045 | ch0 monitor | ch0 RX pkt #114: addr=0 len=1 parity=good |
| 18045 | scoreboard | ch0 pkt matched: addr=0 len=1 (114 matched so far) |
| 18105 | **DUT** | IN  pkt #115 header: addr=0 len=1 -> channel 0 |
| 18115 | **DUT** | OUT ch0 pkt #115 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18125 | **DUT** | IN  pkt #115 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18125 | yapp monitor | RX pkt #115 on the input: addr=0 len=1 parity=good gap=6 |
| 18125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18130 | yapp driver | TX pkt #115 accepted by the DUT |
| 18130 | yapp driver | TX pkt #116: addr=0 len=1 parity=good delay=8 |
| 18135 | **DUT** | OUT ch0 pkt #115 done: 3 bytes in 3 cycles |
| 18135 | ch0 monitor | ch0 RX pkt #115: addr=0 len=1 parity=good |
| 18135 | scoreboard | ch0 pkt matched: addr=0 len=1 (115 matched so far) |
| 18215 | **DUT** | IN  pkt #116 header: addr=0 len=1 -> channel 0 |
| 18220 | ch0 driver | ch0: packet consumed (response delay 3) |
| 18235 | **DUT** | IN  pkt #116 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18235 | yapp monitor | RX pkt #116 on the input: addr=0 len=1 parity=good gap=8 |
| 18235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18240 | yapp driver | TX pkt #116 accepted by the DUT |
| 18240 | yapp driver | TX pkt #117: addr=0 len=1 parity=good delay=20 |
| 18315 | **DUT** | OUT ch0 pkt #116 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 18330 | ch0 driver | ch0: packet consumed (response delay 8) |
| 18425 | **DUT** | OUT ch0 pkt #116 done: 3 bytes in 12 cycles |
| 18425 | ch0 monitor | ch0 RX pkt #116: addr=0 len=1 parity=good |
| 18425 | scoreboard | ch0 pkt matched: addr=0 len=1 (116 matched so far) |
| 18445 | **DUT** | IN  pkt #117 header: addr=0 len=1 -> channel 0 |
| 18455 | **DUT** | OUT ch0 pkt #117 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18465 | **DUT** | IN  pkt #117 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18465 | yapp monitor | RX pkt #117 on the input: addr=0 len=1 parity=good gap=20 |
| 18465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18470 | yapp driver | TX pkt #117 accepted by the DUT |
| 18470 | yapp driver | TX pkt #118: addr=0 len=1 parity=good delay=20 |
| 18475 | **DUT** | OUT ch0 pkt #117 done: 3 bytes in 3 cycles |
| 18475 | ch0 monitor | ch0 RX pkt #117: addr=0 len=1 parity=good |
| 18475 | scoreboard | ch0 pkt matched: addr=0 len=1 (117 matched so far) |
| 18675 | **DUT** | IN  pkt #118 header: addr=0 len=1 -> channel 0 |
| 18685 | **DUT** | OUT ch0 pkt #118 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18695 | **DUT** | IN  pkt #118 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18695 | yapp monitor | RX pkt #118 on the input: addr=0 len=1 parity=good gap=20 |
| 18695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18700 | yapp driver | TX pkt #118 accepted by the DUT |
| 18700 | yapp driver | TX pkt #119: addr=0 len=1 parity=good delay=14 |
| 18705 | **DUT** | OUT ch0 pkt #118 done: 3 bytes in 3 cycles |
| 18705 | ch0 monitor | ch0 RX pkt #118: addr=0 len=1 parity=good |
| 18705 | scoreboard | ch0 pkt matched: addr=0 len=1 (118 matched so far) |
| 18720 | ch0 driver | ch0: packet consumed (response delay 8) |
| 18845 | **DUT** | IN  pkt #119 header: addr=0 len=1 -> channel 0 |
| 18865 | **DUT** | IN  pkt #119 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18865 | yapp monitor | RX pkt #119 on the input: addr=0 len=1 parity=good gap=14 |
| 18865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18870 | yapp driver | TX pkt #119 accepted by the DUT |
| 18870 | yapp driver | TX pkt #120: addr=0 len=1 parity=good delay=20 |
| 18955 | **DUT** | OUT ch0 pkt #119 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 18970 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19035 | **DUT** | OUT ch0 pkt #119 done: 3 bytes in 9 cycles |
| 19035 | ch0 monitor | ch0 RX pkt #119: addr=0 len=1 parity=good |
| 19035 | scoreboard | ch0 pkt matched: addr=0 len=1 (119 matched so far) |
| 19075 | **DUT** | IN  pkt #120 header: addr=0 len=1 -> channel 0 |
| 19085 | **DUT** | OUT ch0 pkt #120 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19095 | **DUT** | IN  pkt #120 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19095 | yapp monitor | RX pkt #120 on the input: addr=0 len=1 parity=good gap=20 |
| 19095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19100 | yapp driver | TX pkt #120 accepted by the DUT |
| 19100 | yapp driver | TX pkt #121: addr=0 len=1 parity=good delay=9 |
| 19105 | **DUT** | OUT ch0 pkt #120 done: 3 bytes in 3 cycles |
| 19105 | ch0 monitor | ch0 RX pkt #120: addr=0 len=1 parity=good |
| 19105 | scoreboard | ch0 pkt matched: addr=0 len=1 (120 matched so far) |
| 19195 | **DUT** | IN  pkt #121 header: addr=0 len=1 -> channel 0 |
| 19205 | **DUT** | OUT ch0 pkt #121 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19215 | **DUT** | IN  pkt #121 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19215 | yapp monitor | RX pkt #121 on the input: addr=0 len=1 parity=good gap=9 |
| 19215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19220 | yapp driver | TX pkt #121 accepted by the DUT |
| 19220 | yapp driver | TX pkt #122: addr=0 len=1 parity=good delay=18 |
| 19225 | **DUT** | OUT ch0 pkt #121 done: 3 bytes in 3 cycles |
| 19225 | ch0 monitor | ch0 RX pkt #121: addr=0 len=1 parity=good |
| 19225 | scoreboard | ch0 pkt matched: addr=0 len=1 (121 matched so far) |
| 19260 | ch0 driver | ch0: packet consumed (response delay 5) |
| 19405 | **DUT** | IN  pkt #122 header: addr=0 len=1 -> channel 0 |
| 19425 | **DUT** | IN  pkt #122 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19425 | yapp monitor | RX pkt #122 on the input: addr=0 len=1 parity=good gap=18 |
| 19425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19430 | yapp driver | TX pkt #122 accepted by the DUT |
| 19430 | yapp driver | TX pkt #123: addr=0 len=1 parity=good delay=5 |
| 19455 | **DUT** | OUT ch0 pkt #122 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 19470 | ch0 driver | ch0: packet consumed (response delay 4) |
| 19485 | **DUT** | IN  pkt #123 header: addr=0 len=1 -> channel 0 |
| 19505 | **DUT** | IN  pkt #123 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19505 | yapp monitor | RX pkt #123 on the input: addr=0 len=1 parity=good gap=5 |
| 19505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19510 | yapp driver | TX pkt #123 accepted by the DUT |
| 19510 | yapp driver | TX pkt #124: addr=0 len=1 parity=good delay=12 |
| 19585 | **DUT** | OUT ch0 pkt #122 done: 3 bytes in 14 cycles |
| 19585 | ch0 monitor | ch0 RX pkt #122: addr=0 len=1 parity=good |
| 19585 | scoreboard | ch0 pkt matched: addr=0 len=1 (122 matched so far) |
| 19595 | **DUT** | OUT ch0 pkt #123 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19615 | **DUT** | OUT ch0 pkt #123 done: 3 bytes in 3 cycles |
| 19615 | ch0 monitor | ch0 RX pkt #123: addr=0 len=1 parity=good |
| 19615 | scoreboard | ch0 pkt matched: addr=0 len=1 (123 matched so far) |
| 19635 | **DUT** | IN  pkt #124 header: addr=0 len=1 -> channel 0 |
| 19645 | **DUT** | OUT ch0 pkt #124 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19655 | **DUT** | IN  pkt #124 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19655 | yapp monitor | RX pkt #124 on the input: addr=0 len=1 parity=good gap=12 |
| 19655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19660 | yapp driver | TX pkt #124 accepted by the DUT |
| 19660 | yapp driver | TX pkt #125: addr=0 len=1 parity=good delay=4 |
| 19665 | **DUT** | OUT ch0 pkt #124 done: 3 bytes in 3 cycles |
| 19665 | ch0 monitor | ch0 RX pkt #124: addr=0 len=1 parity=good |
| 19665 | scoreboard | ch0 pkt matched: addr=0 len=1 (124 matched so far) |
| 19705 | **DUT** | IN  pkt #125 header: addr=0 len=1 -> channel 0 |
| 19715 | **DUT** | OUT ch0 pkt #125 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19725 | **DUT** | IN  pkt #125 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19725 | yapp monitor | RX pkt #125 on the input: addr=0 len=1 parity=good gap=4 |
| 19725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19730 | yapp driver | TX pkt #125 accepted by the DUT |
| 19730 | yapp driver | TX pkt #126: addr=0 len=1 parity=good delay=2 |
| 19735 | **DUT** | OUT ch0 pkt #125 done: 3 bytes in 3 cycles |
| 19735 | ch0 monitor | ch0 RX pkt #125: addr=0 len=1 parity=good |
| 19735 | scoreboard | ch0 pkt matched: addr=0 len=1 (125 matched so far) |
| 19755 | **DUT** | IN  pkt #126 header: addr=0 len=1 -> channel 0 |
| 19765 | **DUT** | OUT ch0 pkt #126 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19775 | **DUT** | IN  pkt #126 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19775 | yapp monitor | RX pkt #126 on the input: addr=0 len=1 parity=good gap=2 |
| 19775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19780 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19780 | yapp driver | TX pkt #126 accepted by the DUT |
| 19780 | yapp driver | TX pkt #127: addr=0 len=1 parity=good delay=19 |
| 19885 | **DUT** | OUT ch0 pkt #126 done: 3 bytes in 13 cycles |
| 19885 | ch0 monitor | ch0 RX pkt #126: addr=0 len=1 parity=good |
| 19885 | scoreboard | ch0 pkt matched: addr=0 len=1 (126 matched so far) |
| 19975 | **DUT** | IN  pkt #127 header: addr=0 len=1 -> channel 0 |
| 19985 | **DUT** | OUT ch0 pkt #127 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19995 | **DUT** | IN  pkt #127 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19995 | yapp monitor | RX pkt #127 on the input: addr=0 len=1 parity=good gap=19 |
| 19995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20000 | yapp driver | TX pkt #127 accepted by the DUT |
| 20000 | yapp driver | TX pkt #128: addr=0 len=1 parity=good delay=3 |
| 20005 | **DUT** | OUT ch0 pkt #127 done: 3 bytes in 3 cycles |
| 20005 | ch0 monitor | ch0 RX pkt #127: addr=0 len=1 parity=good |
| 20005 | scoreboard | ch0 pkt matched: addr=0 len=1 (127 matched so far) |
| 20035 | **DUT** | IN  pkt #128 header: addr=0 len=1 -> channel 0 |
| 20045 | **DUT** | OUT ch0 pkt #128 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20055 | **DUT** | IN  pkt #128 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20055 | yapp monitor | RX pkt #128 on the input: addr=0 len=1 parity=good gap=3 |
| 20055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20060 | yapp driver | TX pkt #128 accepted by the DUT |
| 20060 | yapp driver | TX pkt #129: addr=0 len=1 parity=good delay=1 |
| 20065 | **DUT** | OUT ch0 pkt #128 done: 3 bytes in 3 cycles |
| 20065 | ch0 monitor | ch0 RX pkt #128: addr=0 len=1 parity=good |
| 20065 | scoreboard | ch0 pkt matched: addr=0 len=1 (128 matched so far) |
| 20075 | **DUT** | IN  pkt #129 header: addr=0 len=1 -> channel 0 |
| 20085 | **DUT** | OUT ch0 pkt #129 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20095 | **DUT** | IN  pkt #129 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20095 | yapp monitor | RX pkt #129 on the input: addr=0 len=1 parity=good gap=1 |
| 20095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20100 | yapp driver | TX pkt #129 accepted by the DUT |
| 20100 | yapp driver | TX pkt #130: addr=0 len=1 parity=good delay=5 |
| 20105 | **DUT** | OUT ch0 pkt #129 done: 3 bytes in 3 cycles |
| 20105 | ch0 monitor | ch0 RX pkt #129: addr=0 len=1 parity=good |
| 20105 | scoreboard | ch0 pkt matched: addr=0 len=1 (129 matched so far) |
| 20155 | **DUT** | IN  pkt #130 header: addr=0 len=1 -> channel 0 |
| 20160 | ch0 driver | ch0: packet consumed (response delay 9) |
| 20175 | **DUT** | IN  pkt #130 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20175 | yapp monitor | RX pkt #130 on the input: addr=0 len=1 parity=good gap=5 |
| 20175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20180 | yapp driver | TX pkt #130 accepted by the DUT |
| 20180 | yapp driver | TX pkt #131: addr=0 len=1 parity=good delay=17 |
| 20265 | **DUT** | OUT ch0 pkt #130 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 20280 | ch0 driver | ch0: packet consumed (response delay 9) |
| 20355 | **DUT** | IN  pkt #131 header: addr=0 len=1 -> channel 0 |
| 20375 | **DUT** | IN  pkt #131 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20375 | yapp monitor | RX pkt #131 on the input: addr=0 len=1 parity=good gap=17 |
| 20375 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20380 | yapp driver | TX pkt #131 accepted by the DUT |
| 20380 | yapp driver | TX pkt #132: addr=0 len=1 parity=good delay=20 |
| 20395 | **DUT** | OUT ch0 pkt #130 done: 3 bytes in 14 cycles |
| 20395 | ch0 monitor | ch0 RX pkt #130: addr=0 len=1 parity=good |
| 20395 | scoreboard | ch0 pkt matched: addr=0 len=1 (130 matched so far) |
| 20405 | **DUT** | OUT ch0 pkt #131 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20425 | **DUT** | OUT ch0 pkt #131 done: 3 bytes in 3 cycles |
| 20425 | ch0 monitor | ch0 RX pkt #131: addr=0 len=1 parity=good |
| 20425 | scoreboard | ch0 pkt matched: addr=0 len=1 (131 matched so far) |
| 20570 | ch0 driver | ch0: packet consumed (response delay 10) |
| 20585 | **DUT** | IN  pkt #132 header: addr=0 len=1 -> channel 0 |
| 20605 | **DUT** | IN  pkt #132 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20605 | yapp monitor | RX pkt #132 on the input: addr=0 len=1 parity=good gap=20 |
| 20605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20610 | yapp driver | TX pkt #132 accepted by the DUT |
| 20610 | yapp driver | TX pkt #133: addr=0 len=1 parity=good delay=10 |
| 20625 | **DUT** | OUT ch0 pkt #132 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 20640 | ch0 driver | ch0: packet consumed (response delay 3) |
| 20715 | **DUT** | IN  pkt #133 header: addr=0 len=1 -> channel 0 |
| 20735 | **DUT** | IN  pkt #133 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20735 | **DUT** | OUT ch0 pkt #132 done: 3 bytes in 12 cycles |
| 20735 | ch0 monitor | ch0 RX pkt #132: addr=0 len=1 parity=good |
| 20735 | scoreboard | ch0 pkt matched: addr=0 len=1 (132 matched so far) |
| 20735 | yapp monitor | RX pkt #133 on the input: addr=0 len=1 parity=good gap=10 |
| 20735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20740 | yapp driver | TX pkt #133 accepted by the DUT |
| 20740 | yapp driver | TX pkt #134: addr=0 len=1 parity=good delay=18 |
| 20745 | **DUT** | OUT ch0 pkt #133 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20765 | **DUT** | OUT ch0 pkt #133 done: 3 bytes in 3 cycles |
| 20765 | ch0 monitor | ch0 RX pkt #133: addr=0 len=1 parity=good |
| 20765 | scoreboard | ch0 pkt matched: addr=0 len=1 (133 matched so far) |
| 20925 | **DUT** | IN  pkt #134 header: addr=0 len=1 -> channel 0 |
| 20935 | **DUT** | OUT ch0 pkt #134 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20945 | **DUT** | IN  pkt #134 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20945 | yapp monitor | RX pkt #134 on the input: addr=0 len=1 parity=good gap=18 |
| 20945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20950 | yapp driver | TX pkt #134 accepted by the DUT |
| 20950 | yapp driver | TX pkt #135: addr=0 len=1 parity=good delay=1 |
| 20955 | **DUT** | OUT ch0 pkt #134 done: 3 bytes in 3 cycles |
| 20955 | ch0 monitor | ch0 RX pkt #134: addr=0 len=1 parity=good |
| 20955 | scoreboard | ch0 pkt matched: addr=0 len=1 (134 matched so far) |
| 20965 | **DUT** | IN  pkt #135 header: addr=0 len=1 -> channel 0 |
| 20975 | **DUT** | OUT ch0 pkt #135 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20985 | **DUT** | IN  pkt #135 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20985 | yapp monitor | RX pkt #135 on the input: addr=0 len=1 parity=good gap=1 |
| 20985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20990 | yapp driver | TX pkt #135 accepted by the DUT |
| 20990 | yapp driver | TX pkt #136: addr=0 len=1 parity=good delay=20 |
| 20995 | **DUT** | OUT ch0 pkt #135 done: 3 bytes in 3 cycles |
| 20995 | ch0 monitor | ch0 RX pkt #135: addr=0 len=1 parity=good |
| 20995 | scoreboard | ch0 pkt matched: addr=0 len=1 (135 matched so far) |
| 21195 | **DUT** | IN  pkt #136 header: addr=0 len=1 -> channel 0 |
| 21205 | **DUT** | OUT ch0 pkt #136 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21215 | **DUT** | IN  pkt #136 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21215 | yapp monitor | RX pkt #136 on the input: addr=0 len=1 parity=good gap=20 |
| 21215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21220 | yapp driver | TX pkt #136 accepted by the DUT |
| 21220 | yapp driver | TX pkt #137: addr=0 len=1 parity=good delay=19 |
| 21225 | **DUT** | OUT ch0 pkt #136 done: 3 bytes in 3 cycles |
| 21225 | ch0 monitor | ch0 RX pkt #136: addr=0 len=1 parity=good |
| 21225 | scoreboard | ch0 pkt matched: addr=0 len=1 (136 matched so far) |
| 21270 | ch0 driver | ch0: packet consumed (response delay 8) |
| 21415 | **DUT** | IN  pkt #137 header: addr=0 len=1 -> channel 0 |
| 21435 | **DUT** | IN  pkt #137 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21435 | yapp monitor | RX pkt #137 on the input: addr=0 len=1 parity=good gap=19 |
| 21435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21440 | yapp driver | TX pkt #137 accepted by the DUT |
| 21440 | yapp driver | TX pkt #138: addr=0 len=1 parity=good delay=20 |
| 21505 | **DUT** | OUT ch0 pkt #137 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 21520 | ch0 driver | ch0: packet consumed (response delay 8) |
| 21605 | **DUT** | OUT ch0 pkt #137 done: 3 bytes in 11 cycles |
| 21605 | ch0 monitor | ch0 RX pkt #137: addr=0 len=1 parity=good |
| 21605 | scoreboard | ch0 pkt matched: addr=0 len=1 (137 matched so far) |
| 21645 | **DUT** | IN  pkt #138 header: addr=0 len=1 -> channel 0 |
| 21655 | **DUT** | OUT ch0 pkt #138 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21665 | **DUT** | IN  pkt #138 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21665 | yapp monitor | RX pkt #138 on the input: addr=0 len=1 parity=good gap=20 |
| 21665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21670 | yapp driver | TX pkt #138 accepted by the DUT |
| 21670 | yapp driver | TX pkt #139: addr=0 len=1 parity=good delay=2 |
| 21675 | **DUT** | OUT ch0 pkt #138 done: 3 bytes in 3 cycles |
| 21675 | ch0 monitor | ch0 RX pkt #138: addr=0 len=1 parity=good |
| 21675 | scoreboard | ch0 pkt matched: addr=0 len=1 (138 matched so far) |
| 21695 | **DUT** | IN  pkt #139 header: addr=0 len=1 -> channel 0 |
| 21705 | **DUT** | OUT ch0 pkt #139 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21715 | **DUT** | IN  pkt #139 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21715 | yapp monitor | RX pkt #139 on the input: addr=0 len=1 parity=good gap=2 |
| 21715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21720 | yapp driver | TX pkt #139 accepted by the DUT |
| 21720 | yapp driver | TX pkt #140: addr=0 len=1 parity=good delay=20 |
| 21725 | **DUT** | OUT ch0 pkt #139 done: 3 bytes in 3 cycles |
| 21725 | ch0 monitor | ch0 RX pkt #139: addr=0 len=1 parity=good |
| 21725 | scoreboard | ch0 pkt matched: addr=0 len=1 (139 matched so far) |
| 21925 | **DUT** | IN  pkt #140 header: addr=0 len=1 -> channel 0 |
| 21935 | **DUT** | OUT ch0 pkt #140 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21945 | **DUT** | IN  pkt #140 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21945 | yapp monitor | RX pkt #140 on the input: addr=0 len=1 parity=good gap=20 |
| 21945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21950 | yapp driver | TX pkt #140 accepted by the DUT |
| 21950 | yapp driver | TX pkt #141: addr=0 len=1 parity=good delay=8 |
| 21955 | **DUT** | OUT ch0 pkt #140 done: 3 bytes in 3 cycles |
| 21955 | ch0 monitor | ch0 RX pkt #140: addr=0 len=1 parity=good |
| 21955 | scoreboard | ch0 pkt matched: addr=0 len=1 (140 matched so far) |
| 22035 | **DUT** | IN  pkt #141 header: addr=0 len=1 -> channel 0 |
| 22045 | **DUT** | OUT ch0 pkt #141 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22055 | **DUT** | IN  pkt #141 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22055 | yapp monitor | RX pkt #141 on the input: addr=0 len=1 parity=good gap=8 |
| 22055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22060 | yapp driver | TX pkt #141 accepted by the DUT |
| 22060 | yapp driver | TX pkt #142: addr=0 len=1 parity=good delay=13 |
| 22065 | **DUT** | OUT ch0 pkt #141 done: 3 bytes in 3 cycles |
| 22065 | ch0 monitor | ch0 RX pkt #141: addr=0 len=1 parity=good |
| 22065 | scoreboard | ch0 pkt matched: addr=0 len=1 (141 matched so far) |
| 22190 | ch0 driver | ch0: packet consumed (response delay 7) |
| 22195 | **DUT** | IN  pkt #142 header: addr=0 len=1 -> channel 0 |
| 22215 | **DUT** | IN  pkt #142 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22215 | yapp monitor | RX pkt #142 on the input: addr=0 len=1 parity=good gap=13 |
| 22215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22220 | yapp driver | TX pkt #142 accepted by the DUT |
| 22220 | yapp driver | TX pkt #143: addr=0 len=1 parity=good delay=20 |
| 22305 | **DUT** | OUT ch0 pkt #142 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 22320 | ch0 driver | ch0: packet consumed (response delay 10) |
| 22405 | **DUT** | OUT ch0 pkt #142 done: 3 bytes in 11 cycles |
| 22405 | ch0 monitor | ch0 RX pkt #142: addr=0 len=1 parity=good |
| 22405 | scoreboard | ch0 pkt matched: addr=0 len=1 (142 matched so far) |
| 22425 | **DUT** | IN  pkt #143 header: addr=0 len=1 -> channel 0 |
| 22435 | **DUT** | OUT ch0 pkt #143 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22445 | **DUT** | IN  pkt #143 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22445 | yapp monitor | RX pkt #143 on the input: addr=0 len=1 parity=good gap=20 |
| 22445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22450 | yapp driver | TX pkt #143 accepted by the DUT |
| 22450 | yapp driver | TX pkt #144: addr=0 len=1 parity=good delay=18 |
| 22455 | **DUT** | OUT ch0 pkt #143 done: 3 bytes in 3 cycles |
| 22455 | ch0 monitor | ch0 RX pkt #143: addr=0 len=1 parity=good |
| 22455 | scoreboard | ch0 pkt matched: addr=0 len=1 (143 matched so far) |
| 22635 | **DUT** | IN  pkt #144 header: addr=0 len=1 -> channel 0 |
| 22645 | **DUT** | OUT ch0 pkt #144 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22655 | **DUT** | IN  pkt #144 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22655 | yapp monitor | RX pkt #144 on the input: addr=0 len=1 parity=good gap=18 |
| 22655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22660 | yapp driver | TX pkt #144 accepted by the DUT |
| 22660 | yapp driver | TX pkt #145: addr=0 len=1 parity=good delay=6 |
| 22665 | **DUT** | OUT ch0 pkt #144 done: 3 bytes in 3 cycles |
| 22665 | ch0 monitor | ch0 RX pkt #144: addr=0 len=1 parity=good |
| 22665 | scoreboard | ch0 pkt matched: addr=0 len=1 (144 matched so far) |
| 22725 | **DUT** | IN  pkt #145 header: addr=0 len=1 -> channel 0 |
| 22735 | **DUT** | OUT ch0 pkt #145 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22745 | **DUT** | IN  pkt #145 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22745 | yapp monitor | RX pkt #145 on the input: addr=0 len=1 parity=good gap=6 |
| 22745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22750 | yapp driver | TX pkt #145 accepted by the DUT |
| 22750 | yapp driver | TX pkt #146: addr=0 len=1 parity=good delay=17 |
| 22755 | **DUT** | OUT ch0 pkt #145 done: 3 bytes in 3 cycles |
| 22755 | ch0 monitor | ch0 RX pkt #145: addr=0 len=1 parity=good |
| 22755 | scoreboard | ch0 pkt matched: addr=0 len=1 (145 matched so far) |
| 22925 | **DUT** | IN  pkt #146 header: addr=0 len=1 -> channel 0 |
| 22935 | **DUT** | OUT ch0 pkt #146 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22945 | **DUT** | IN  pkt #146 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22945 | yapp monitor | RX pkt #146 on the input: addr=0 len=1 parity=good gap=17 |
| 22945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22950 | yapp driver | TX pkt #146 accepted by the DUT |
| 22950 | yapp driver | TX pkt #147: addr=0 len=1 parity=good delay=20 |
| 22955 | **DUT** | OUT ch0 pkt #146 done: 3 bytes in 3 cycles |
| 22955 | ch0 monitor | ch0 RX pkt #146: addr=0 len=1 parity=good |
| 22955 | scoreboard | ch0 pkt matched: addr=0 len=1 (146 matched so far) |
| 22960 | ch0 driver | ch0: packet consumed (response delay 7) |
| 23155 | **DUT** | IN  pkt #147 header: addr=0 len=1 -> channel 0 |
| 23165 | **DUT** | OUT ch0 pkt #147 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23175 | **DUT** | IN  pkt #147 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23175 | yapp monitor | RX pkt #147 on the input: addr=0 len=1 parity=good gap=20 |
| 23175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23180 | ch0 driver | ch0: packet consumed (response delay 0) |
| 23180 | yapp driver | TX pkt #147 accepted by the DUT |
| 23180 | yapp driver | TX pkt #148: addr=0 len=1 parity=good delay=13 |
| 23195 | **DUT** | OUT ch0 pkt #147 done: 3 bytes in 4 cycles |
| 23195 | ch0 monitor | ch0 RX pkt #147: addr=0 len=1 parity=good |
| 23195 | scoreboard | ch0 pkt matched: addr=0 len=1 (147 matched so far) |
| 23315 | **DUT** | IN  pkt #148 header: addr=0 len=1 -> channel 0 |
| 23325 | **DUT** | OUT ch0 pkt #148 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23335 | **DUT** | IN  pkt #148 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23335 | yapp monitor | RX pkt #148 on the input: addr=0 len=1 parity=good gap=13 |
| 23335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23340 | yapp driver | TX pkt #148 accepted by the DUT |
| 23340 | yapp driver | TX pkt #149: addr=0 len=1 parity=good delay=19 |
| 23345 | **DUT** | OUT ch0 pkt #148 done: 3 bytes in 3 cycles |
| 23345 | ch0 monitor | ch0 RX pkt #148: addr=0 len=1 parity=good |
| 23345 | scoreboard | ch0 pkt matched: addr=0 len=1 (148 matched so far) |
| 23535 | **DUT** | IN  pkt #149 header: addr=0 len=1 -> channel 0 |
| 23545 | **DUT** | OUT ch0 pkt #149 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23555 | **DUT** | IN  pkt #149 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23555 | yapp monitor | RX pkt #149 on the input: addr=0 len=1 parity=good gap=19 |
| 23555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23560 | yapp driver | TX pkt #149 accepted by the DUT |
| 23560 | yapp driver | TX pkt #150: addr=0 len=1 parity=good delay=6 |
| 23565 | **DUT** | OUT ch0 pkt #149 done: 3 bytes in 3 cycles |
| 23565 | ch0 monitor | ch0 RX pkt #149: addr=0 len=1 parity=good |
| 23565 | scoreboard | ch0 pkt matched: addr=0 len=1 (149 matched so far) |
| 23625 | **DUT** | IN  pkt #150 header: addr=0 len=1 -> channel 0 |
| 23635 | **DUT** | OUT ch0 pkt #150 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23645 | **DUT** | IN  pkt #150 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23645 | yapp monitor | RX pkt #150 on the input: addr=0 len=1 parity=good gap=6 |
| 23645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23650 | yapp driver | TX pkt #150 accepted by the DUT |
| 23650 | yapp driver | TX pkt #151: addr=0 len=1 parity=good delay=13 |
| 23655 | **DUT** | OUT ch0 pkt #150 done: 3 bytes in 3 cycles |
| 23655 | ch0 monitor | ch0 RX pkt #150: addr=0 len=1 parity=good |
| 23655 | scoreboard | ch0 pkt matched: addr=0 len=1 (150 matched so far) |
| 23680 | ch0 driver | ch0: packet consumed (response delay 0) |
| 23785 | **DUT** | IN  pkt #151 header: addr=0 len=1 -> channel 0 |
| 23805 | **DUT** | IN  pkt #151 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23805 | yapp monitor | RX pkt #151 on the input: addr=0 len=1 parity=good gap=13 |
| 23805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23810 | yapp driver | TX pkt #151 accepted by the DUT |
| 23810 | yapp driver | TX pkt #152: addr=0 len=1 parity=good delay=20 |
| 23895 | **DUT** | OUT ch0 pkt #151 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 23910 | ch0 driver | ch0: packet consumed (response delay 10) |
| 23965 | **DUT** | OUT ch0 pkt #151 done: 3 bytes in 8 cycles |
| 23965 | ch0 monitor | ch0 RX pkt #151: addr=0 len=1 parity=good |
| 23965 | scoreboard | ch0 pkt matched: addr=0 len=1 (151 matched so far) |
| 24015 | **DUT** | IN  pkt #152 header: addr=0 len=1 -> channel 0 |
| 24020 | ch0 driver | ch0: packet consumed (response delay 4) |
| 24035 | **DUT** | IN  pkt #152 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24035 | yapp monitor | RX pkt #152 on the input: addr=0 len=1 parity=good gap=20 |
| 24035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24040 | yapp driver | TX pkt #152 accepted by the DUT |
| 24040 | yapp driver | TX pkt #153: addr=0 len=1 parity=good delay=20 |
| 24095 | **DUT** | OUT ch0 pkt #152 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 24110 | ch0 driver | ch0: packet consumed (response delay 6) |
| 24225 | **DUT** | OUT ch0 pkt #152 done: 3 bytes in 14 cycles |
| 24225 | ch0 monitor | ch0 RX pkt #152: addr=0 len=1 parity=good |
| 24225 | scoreboard | ch0 pkt matched: addr=0 len=1 (152 matched so far) |
| 24245 | **DUT** | IN  pkt #153 header: addr=0 len=1 -> channel 0 |
| 24255 | **DUT** | OUT ch0 pkt #153 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24265 | **DUT** | IN  pkt #153 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24265 | yapp monitor | RX pkt #153 on the input: addr=0 len=1 parity=good gap=20 |
| 24265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24270 | yapp driver | TX pkt #153 accepted by the DUT |
| 24270 | yapp driver | TX pkt #154: addr=0 len=1 parity=good delay=20 |
| 24275 | **DUT** | OUT ch0 pkt #153 done: 3 bytes in 3 cycles |
| 24275 | ch0 monitor | ch0 RX pkt #153: addr=0 len=1 parity=good |
| 24275 | scoreboard | ch0 pkt matched: addr=0 len=1 (153 matched so far) |
| 24310 | ch0 driver | ch0: packet consumed (response delay 10) |
| 24475 | **DUT** | IN  pkt #154 header: addr=0 len=1 -> channel 0 |
| 24495 | **DUT** | IN  pkt #154 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24495 | yapp monitor | RX pkt #154 on the input: addr=0 len=1 parity=good gap=20 |
| 24495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24500 | yapp driver | TX pkt #154 accepted by the DUT |
| 24500 | yapp driver | TX pkt #155: addr=0 len=1 parity=good delay=19 |
| 24565 | **DUT** | OUT ch0 pkt #154 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 24580 | ch0 driver | ch0: packet consumed (response delay 8) |
| 24655 | **DUT** | OUT ch0 pkt #154 done: 3 bytes in 10 cycles |
| 24655 | ch0 monitor | ch0 RX pkt #154: addr=0 len=1 parity=good |
| 24655 | scoreboard | ch0 pkt matched: addr=0 len=1 (154 matched so far) |
| 24695 | **DUT** | IN  pkt #155 header: addr=0 len=1 -> channel 0 |
| 24705 | **DUT** | OUT ch0 pkt #155 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24715 | **DUT** | IN  pkt #155 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24715 | yapp monitor | RX pkt #155 on the input: addr=0 len=1 parity=good gap=19 |
| 24715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24720 | yapp driver | TX pkt #155 accepted by the DUT |
| 24720 | yapp driver | TX pkt #156: addr=0 len=1 parity=good delay=4 |
| 24725 | **DUT** | OUT ch0 pkt #155 done: 3 bytes in 3 cycles |
| 24725 | ch0 monitor | ch0 RX pkt #155: addr=0 len=1 parity=good |
| 24725 | scoreboard | ch0 pkt matched: addr=0 len=1 (155 matched so far) |
| 24765 | **DUT** | IN  pkt #156 header: addr=0 len=1 -> channel 0 |
| 24775 | **DUT** | OUT ch0 pkt #156 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24785 | **DUT** | IN  pkt #156 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24785 | yapp monitor | RX pkt #156 on the input: addr=0 len=1 parity=good gap=4 |
| 24785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24790 | yapp driver | TX pkt #156 accepted by the DUT |
| 24790 | yapp driver | TX pkt #157: addr=0 len=1 parity=good delay=13 |
| 24795 | **DUT** | OUT ch0 pkt #156 done: 3 bytes in 3 cycles |
| 24795 | ch0 monitor | ch0 RX pkt #156: addr=0 len=1 parity=good |
| 24795 | scoreboard | ch0 pkt matched: addr=0 len=1 (156 matched so far) |
| 24925 | **DUT** | IN  pkt #157 header: addr=0 len=1 -> channel 0 |
| 24935 | **DUT** | OUT ch0 pkt #157 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24945 | **DUT** | IN  pkt #157 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24945 | yapp monitor | RX pkt #157 on the input: addr=0 len=1 parity=good gap=13 |
| 24945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24950 | yapp driver | TX pkt #157 accepted by the DUT |
| 24950 | yapp driver | TX pkt #158: addr=0 len=1 parity=good delay=16 |
| 24955 | **DUT** | OUT ch0 pkt #157 done: 3 bytes in 3 cycles |
| 24955 | ch0 monitor | ch0 RX pkt #157: addr=0 len=1 parity=good |
| 24955 | scoreboard | ch0 pkt matched: addr=0 len=1 (157 matched so far) |
| 25115 | **DUT** | IN  pkt #158 header: addr=0 len=1 -> channel 0 |
| 25125 | **DUT** | OUT ch0 pkt #158 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25135 | **DUT** | IN  pkt #158 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25135 | yapp monitor | RX pkt #158 on the input: addr=0 len=1 parity=good gap=16 |
| 25135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25140 | yapp driver | TX pkt #158 accepted by the DUT |
| 25140 | yapp driver | TX pkt #159: addr=0 len=1 parity=good delay=11 |
| 25145 | **DUT** | OUT ch0 pkt #158 done: 3 bytes in 3 cycles |
| 25145 | ch0 monitor | ch0 RX pkt #158: addr=0 len=1 parity=good |
| 25145 | scoreboard | ch0 pkt matched: addr=0 len=1 (158 matched so far) |
| 25255 | **DUT** | IN  pkt #159 header: addr=0 len=1 -> channel 0 |
| 25265 | **DUT** | OUT ch0 pkt #159 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25275 | **DUT** | IN  pkt #159 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25275 | yapp monitor | RX pkt #159 on the input: addr=0 len=1 parity=good gap=11 |
| 25275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25280 | yapp driver | TX pkt #159 accepted by the DUT |
| 25280 | yapp driver | TX pkt #160: addr=0 len=1 parity=good delay=20 |
| 25285 | **DUT** | OUT ch0 pkt #159 done: 3 bytes in 3 cycles |
| 25285 | ch0 monitor | ch0 RX pkt #159: addr=0 len=1 parity=good |
| 25285 | scoreboard | ch0 pkt matched: addr=0 len=1 (159 matched so far) |
| 25290 | ch0 driver | ch0: packet consumed (response delay 6) |
| 25485 | **DUT** | IN  pkt #160 header: addr=0 len=1 -> channel 0 |
| 25505 | **DUT** | IN  pkt #160 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25505 | yapp monitor | RX pkt #160 on the input: addr=0 len=1 parity=good gap=20 |
| 25505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25510 | yapp driver | TX pkt #160 accepted by the DUT |
| 25510 | yapp driver | TX pkt #161: addr=0 len=1 parity=good delay=18 |
| 25545 | **DUT** | OUT ch0 pkt #160 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 25560 | ch0 driver | ch0: packet consumed (response delay 5) |
| 25655 | **DUT** | OUT ch0 pkt #160 done: 3 bytes in 12 cycles |
| 25655 | ch0 monitor | ch0 RX pkt #160: addr=0 len=1 parity=good |
| 25655 | scoreboard | ch0 pkt matched: addr=0 len=1 (160 matched so far) |
| 25695 | **DUT** | IN  pkt #161 header: addr=0 len=1 -> channel 0 |
| 25705 | **DUT** | OUT ch0 pkt #161 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25715 | **DUT** | IN  pkt #161 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25715 | yapp monitor | RX pkt #161 on the input: addr=0 len=1 parity=good gap=18 |
| 25715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25720 | yapp driver | TX pkt #161 accepted by the DUT |
| 25720 | yapp driver | TX pkt #162: addr=0 len=1 parity=good delay=15 |
| 25725 | **DUT** | OUT ch0 pkt #161 done: 3 bytes in 3 cycles |
| 25725 | ch0 monitor | ch0 RX pkt #161: addr=0 len=1 parity=good |
| 25725 | scoreboard | ch0 pkt matched: addr=0 len=1 (161 matched so far) |
| 25875 | **DUT** | IN  pkt #162 header: addr=0 len=1 -> channel 0 |
| 25885 | **DUT** | OUT ch0 pkt #162 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25895 | **DUT** | IN  pkt #162 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25895 | yapp monitor | RX pkt #162 on the input: addr=0 len=1 parity=good gap=15 |
| 25895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25900 | yapp driver | TX pkt #162 accepted by the DUT |
| 25900 | yapp driver | TX pkt #163: addr=0 len=1 parity=good delay=6 |
| 25905 | **DUT** | OUT ch0 pkt #162 done: 3 bytes in 3 cycles |
| 25905 | ch0 monitor | ch0 RX pkt #162: addr=0 len=1 parity=good |
| 25905 | scoreboard | ch0 pkt matched: addr=0 len=1 (162 matched so far) |
| 25965 | **DUT** | IN  pkt #163 header: addr=0 len=1 -> channel 0 |
| 25975 | **DUT** | OUT ch0 pkt #163 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25985 | **DUT** | IN  pkt #163 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25985 | yapp monitor | RX pkt #163 on the input: addr=0 len=1 parity=good gap=6 |
| 25985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25990 | yapp driver | TX pkt #163 accepted by the DUT |
| 25990 | yapp driver | TX pkt #164: addr=0 len=1 parity=good delay=4 |
| 25995 | **DUT** | OUT ch0 pkt #163 done: 3 bytes in 3 cycles |
| 25995 | ch0 monitor | ch0 RX pkt #163: addr=0 len=1 parity=good |
| 25995 | scoreboard | ch0 pkt matched: addr=0 len=1 (163 matched so far) |
| 26035 | **DUT** | IN  pkt #164 header: addr=0 len=1 -> channel 0 |
| 26045 | **DUT** | OUT ch0 pkt #164 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26055 | **DUT** | IN  pkt #164 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26055 | yapp monitor | RX pkt #164 on the input: addr=0 len=1 parity=good gap=4 |
| 26055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26060 | yapp driver | TX pkt #164 accepted by the DUT |
| 26060 | yapp driver | TX pkt #165: addr=0 len=1 parity=good delay=20 |
| 26065 | **DUT** | OUT ch0 pkt #164 done: 3 bytes in 3 cycles |
| 26065 | ch0 monitor | ch0 RX pkt #164: addr=0 len=1 parity=good |
| 26065 | scoreboard | ch0 pkt matched: addr=0 len=1 (164 matched so far) |
| 26080 | ch0 driver | ch0: packet consumed (response delay 8) |
| 26265 | **DUT** | IN  pkt #165 header: addr=0 len=1 -> channel 0 |
| 26285 | **DUT** | IN  pkt #165 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26285 | yapp monitor | RX pkt #165 on the input: addr=0 len=1 parity=good gap=20 |
| 26285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26290 | yapp driver | TX pkt #165 accepted by the DUT |
| 26290 | yapp driver | TX pkt #166: addr=0 len=1 parity=good delay=20 |
| 26375 | **DUT** | OUT ch0 pkt #165 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 26390 | ch0 driver | ch0: packet consumed (response delay 10) |
| 26415 | **DUT** | OUT ch0 pkt #165 done: 3 bytes in 5 cycles |
| 26415 | ch0 monitor | ch0 RX pkt #165: addr=0 len=1 parity=good |
| 26415 | scoreboard | ch0 pkt matched: addr=0 len=1 (165 matched so far) |
| 26495 | **DUT** | IN  pkt #166 header: addr=0 len=1 -> channel 0 |
| 26505 | **DUT** | OUT ch0 pkt #166 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26510 | ch0 driver | ch0: packet consumed (response delay 1) |
| 26515 | **DUT** | IN  pkt #166 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26515 | yapp monitor | RX pkt #166 on the input: addr=0 len=1 parity=good gap=20 |
| 26515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26520 | yapp driver | TX pkt #166 accepted by the DUT |
| 26520 | yapp driver | TX pkt #167: addr=0 len=1 parity=good delay=19 |
| 26635 | **DUT** | OUT ch0 pkt #166 done: 3 bytes in 14 cycles |
| 26635 | ch0 monitor | ch0 RX pkt #166: addr=0 len=1 parity=good |
| 26635 | scoreboard | ch0 pkt matched: addr=0 len=1 (166 matched so far) |
| 26715 | **DUT** | IN  pkt #167 header: addr=0 len=1 -> channel 0 |
| 26720 | ch0 driver | ch0: packet consumed (response delay 10) |
| 26735 | **DUT** | IN  pkt #167 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26735 | yapp monitor | RX pkt #167 on the input: addr=0 len=1 parity=good gap=19 |
| 26735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26740 | yapp driver | TX pkt #167 accepted by the DUT |
| 26740 | yapp driver | TX pkt #168: addr=0 len=1 parity=good delay=4 |
| 26785 | **DUT** | IN  pkt #168 header: addr=0 len=1 -> channel 0 |
| 26805 | **DUT** | IN  pkt #168 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26805 | yapp monitor | RX pkt #168 on the input: addr=0 len=1 parity=good gap=4 |
| 26805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26810 | yapp driver | TX pkt #168 accepted by the DUT |
| 26810 | yapp driver | TX pkt #169: addr=0 len=1 parity=good delay=19 |
| 26815 | **DUT** | OUT ch0 pkt #167 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 26830 | ch0 driver | ch0: packet consumed (response delay 8) |
| 26945 | **DUT** | OUT ch0 pkt #167 done: 3 bytes in 14 cycles |
| 26945 | ch0 monitor | ch0 RX pkt #167: addr=0 len=1 parity=good |
| 26945 | scoreboard | ch0 pkt matched: addr=0 len=1 (167 matched so far) |
| 26955 | **DUT** | OUT ch0 pkt #168 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26975 | **DUT** | OUT ch0 pkt #168 done: 3 bytes in 3 cycles |
| 26975 | ch0 monitor | ch0 RX pkt #168: addr=0 len=1 parity=good |
| 26975 | scoreboard | ch0 pkt matched: addr=0 len=1 (168 matched so far) |
| 27005 | **DUT** | IN  pkt #169 header: addr=0 len=1 -> channel 0 |
| 27015 | **DUT** | OUT ch0 pkt #169 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27025 | **DUT** | IN  pkt #169 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27025 | yapp monitor | RX pkt #169 on the input: addr=0 len=1 parity=good gap=19 |
| 27025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27030 | ch0 driver | ch0: packet consumed (response delay 10) |
| 27030 | yapp driver | TX pkt #169 accepted by the DUT |
| 27030 | yapp driver | TX pkt #170: addr=0 len=1 parity=good delay=1 |
| 27045 | **DUT** | IN  pkt #170 header: addr=0 len=1 -> channel 0 |
| 27065 | **DUT** | IN  pkt #170 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27065 | yapp monitor | RX pkt #170 on the input: addr=0 len=1 parity=good gap=1 |
| 27065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27070 | yapp driver | TX pkt #170 accepted by the DUT |
| 27070 | yapp driver | TX pkt #171: addr=0 len=1 parity=good delay=19 |
| 27125 | **DUT** | OUT ch0 pkt #169 done: 3 bytes in 12 cycles |
| 27125 | ch0 monitor | ch0 RX pkt #169: addr=0 len=1 parity=good |
| 27125 | scoreboard | ch0 pkt matched: addr=0 len=1 (169 matched so far) |
| 27135 | **DUT** | OUT ch0 pkt #170 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27155 | **DUT** | OUT ch0 pkt #170 done: 3 bytes in 3 cycles |
| 27155 | ch0 monitor | ch0 RX pkt #170: addr=0 len=1 parity=good |
| 27155 | scoreboard | ch0 pkt matched: addr=0 len=1 (170 matched so far) |
| 27265 | **DUT** | IN  pkt #171 header: addr=0 len=1 -> channel 0 |
| 27275 | **DUT** | OUT ch0 pkt #171 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27285 | **DUT** | IN  pkt #171 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27285 | yapp monitor | RX pkt #171 on the input: addr=0 len=1 parity=good gap=19 |
| 27285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27290 | yapp driver | TX pkt #171 accepted by the DUT |
| 27290 | yapp driver | TX pkt #172: addr=0 len=1 parity=good delay=20 |
| 27295 | **DUT** | OUT ch0 pkt #171 done: 3 bytes in 3 cycles |
| 27295 | ch0 monitor | ch0 RX pkt #171: addr=0 len=1 parity=good |
| 27295 | scoreboard | ch0 pkt matched: addr=0 len=1 (171 matched so far) |
| 27470 | ch0 driver | ch0: packet consumed (response delay 8) |
| 27495 | **DUT** | IN  pkt #172 header: addr=0 len=1 -> channel 0 |
| 27515 | **DUT** | IN  pkt #172 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27515 | yapp monitor | RX pkt #172 on the input: addr=0 len=1 parity=good gap=20 |
| 27515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27520 | yapp driver | TX pkt #172 accepted by the DUT |
| 27520 | yapp driver | TX pkt #173: addr=0 len=1 parity=good delay=20 |
| 27565 | **DUT** | OUT ch0 pkt #172 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 27580 | ch0 driver | ch0: packet consumed (response delay 6) |
| 27605 | **DUT** | OUT ch0 pkt #172 done: 3 bytes in 5 cycles |
| 27605 | ch0 monitor | ch0 RX pkt #172: addr=0 len=1 parity=good |
| 27605 | scoreboard | ch0 pkt matched: addr=0 len=1 (172 matched so far) |
| 27725 | **DUT** | IN  pkt #173 header: addr=0 len=1 -> channel 0 |
| 27735 | **DUT** | OUT ch0 pkt #173 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27745 | **DUT** | IN  pkt #173 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27745 | yapp monitor | RX pkt #173 on the input: addr=0 len=1 parity=good gap=20 |
| 27745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27750 | yapp driver | TX pkt #173 accepted by the DUT |
| 27750 | yapp driver | TX pkt #174: addr=0 len=1 parity=good delay=17 |
| 27755 | **DUT** | OUT ch0 pkt #173 done: 3 bytes in 3 cycles |
| 27755 | ch0 monitor | ch0 RX pkt #173: addr=0 len=1 parity=good |
| 27755 | scoreboard | ch0 pkt matched: addr=0 len=1 (173 matched so far) |
| 27925 | **DUT** | IN  pkt #174 header: addr=0 len=1 -> channel 0 |
| 27935 | **DUT** | OUT ch0 pkt #174 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27945 | **DUT** | IN  pkt #174 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27945 | yapp monitor | RX pkt #174 on the input: addr=0 len=1 parity=good gap=17 |
| 27945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27950 | yapp driver | TX pkt #174 accepted by the DUT |
| 27950 | yapp driver | TX pkt #175: addr=0 len=1 parity=good delay=20 |
| 27955 | **DUT** | OUT ch0 pkt #174 done: 3 bytes in 3 cycles |
| 27955 | ch0 monitor | ch0 RX pkt #174: addr=0 len=1 parity=good |
| 27955 | scoreboard | ch0 pkt matched: addr=0 len=1 (174 matched so far) |
| 27990 | ch0 driver | ch0: packet consumed (response delay 1) |
| 28155 | **DUT** | IN  pkt #175 header: addr=0 len=1 -> channel 0 |
| 28175 | **DUT** | IN  pkt #175 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28175 | **DUT** | OUT ch0 pkt #175 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 28175 | yapp monitor | RX pkt #175 on the input: addr=0 len=1 parity=good gap=20 |
| 28175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28180 | yapp driver | TX pkt #175 accepted by the DUT |
| 28180 | yapp driver | TX pkt #176: addr=0 len=1 parity=good delay=11 |
| 28190 | ch0 driver | ch0: packet consumed (response delay 1) |
| 28295 | **DUT** | IN  pkt #176 header: addr=0 len=1 -> channel 0 |
| 28305 | **DUT** | OUT ch0 pkt #175 done: 3 bytes in 14 cycles |
| 28305 | ch0 monitor | ch0 RX pkt #175: addr=0 len=1 parity=good |
| 28305 | scoreboard | ch0 pkt matched: addr=0 len=1 (175 matched so far) |
| 28315 | **DUT** | IN  pkt #176 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28315 | **DUT** | OUT ch0 pkt #176 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28315 | yapp monitor | RX pkt #176 on the input: addr=0 len=1 parity=good gap=11 |
| 28315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28320 | yapp driver | TX pkt #176 accepted by the DUT |
| 28320 | yapp driver | TX pkt #177: addr=0 len=1 parity=good delay=6 |
| 28335 | **DUT** | OUT ch0 pkt #176 done: 3 bytes in 3 cycles |
| 28335 | ch0 monitor | ch0 RX pkt #176: addr=0 len=1 parity=good |
| 28335 | scoreboard | ch0 pkt matched: addr=0 len=1 (176 matched so far) |
| 28385 | **DUT** | IN  pkt #177 header: addr=0 len=1 -> channel 0 |
| 28395 | **DUT** | OUT ch0 pkt #177 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28405 | **DUT** | IN  pkt #177 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28405 | yapp monitor | RX pkt #177 on the input: addr=0 len=1 parity=good gap=6 |
| 28405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28410 | yapp driver | TX pkt #177 accepted by the DUT |
| 28410 | yapp driver | TX pkt #178: addr=0 len=1 parity=good delay=3 |
| 28415 | **DUT** | OUT ch0 pkt #177 done: 3 bytes in 3 cycles |
| 28415 | ch0 monitor | ch0 RX pkt #177: addr=0 len=1 parity=good |
| 28415 | scoreboard | ch0 pkt matched: addr=0 len=1 (177 matched so far) |
| 28445 | **DUT** | IN  pkt #178 header: addr=0 len=1 -> channel 0 |
| 28455 | **DUT** | OUT ch0 pkt #178 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28465 | **DUT** | IN  pkt #178 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28465 | yapp monitor | RX pkt #178 on the input: addr=0 len=1 parity=good gap=3 |
| 28465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28470 | yapp driver | TX pkt #178 accepted by the DUT |
| 28470 | yapp driver | TX pkt #179: addr=0 len=1 parity=good delay=14 |
| 28475 | **DUT** | OUT ch0 pkt #178 done: 3 bytes in 3 cycles |
| 28475 | ch0 monitor | ch0 RX pkt #178: addr=0 len=1 parity=good |
| 28475 | scoreboard | ch0 pkt matched: addr=0 len=1 (178 matched so far) |
| 28550 | ch0 driver | ch0: packet consumed (response delay 10) |
| 28615 | **DUT** | IN  pkt #179 header: addr=0 len=1 -> channel 0 |
| 28635 | **DUT** | IN  pkt #179 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28635 | yapp monitor | RX pkt #179 on the input: addr=0 len=1 parity=good gap=14 |
| 28635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28640 | yapp driver | TX pkt #179 accepted by the DUT |
| 28640 | yapp driver | TX pkt #180: addr=0 len=1 parity=good delay=6 |
| 28705 | **DUT** | IN  pkt #180 header: addr=0 len=1 -> channel 0 |
| 28725 | **DUT** | IN  pkt #180 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28725 | **DUT** | OUT ch0 pkt #179 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 28725 | yapp monitor | RX pkt #180 on the input: addr=0 len=1 parity=good gap=6 |
| 28725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28730 | yapp driver | TX pkt #180 accepted by the DUT |
| 28730 | yapp driver | TX pkt #181: addr=0 len=1 parity=good delay=1 |
| 28740 | ch0 driver | ch0: packet consumed (response delay 10) |
| 28745 | **DUT** | IN  pkt #181 header: addr=0 len=1 -> channel 0 |
| 28765 | **DUT** | IN  pkt #181 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28765 | **DUT** | OUT ch0 pkt #179 done: 3 bytes in 5 cycles |
| 28765 | ch0 monitor | ch0 RX pkt #179: addr=0 len=1 parity=good |
| 28765 | scoreboard | ch0 pkt matched: addr=0 len=1 (179 matched so far) |
| 28765 | yapp monitor | RX pkt #181 on the input: addr=0 len=1 parity=good gap=1 |
| 28765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28770 | yapp driver | TX pkt #181 accepted by the DUT |
| 28770 | yapp driver | TX pkt #182: addr=0 len=1 parity=good delay=8 |
| 28775 | **DUT** | OUT ch0 pkt #180 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28795 | **DUT** | OUT ch0 pkt #180 done: 3 bytes in 3 cycles |
| 28795 | ch0 monitor | ch0 RX pkt #180: addr=0 len=1 parity=good |
| 28795 | scoreboard | ch0 pkt matched: addr=0 len=1 (180 matched so far) |
| 28805 | **DUT** | OUT ch0 pkt #181 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28825 | **DUT** | OUT ch0 pkt #181 done: 3 bytes in 3 cycles |
| 28825 | ch0 monitor | ch0 RX pkt #181: addr=0 len=1 parity=good |
| 28825 | scoreboard | ch0 pkt matched: addr=0 len=1 (181 matched so far) |
| 28850 | ch0 driver | ch0: packet consumed (response delay 1) |
| 28855 | **DUT** | IN  pkt #182 header: addr=0 len=1 -> channel 0 |
| 28875 | **DUT** | IN  pkt #182 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28875 | yapp monitor | RX pkt #182 on the input: addr=0 len=1 parity=good gap=8 |
| 28875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28880 | yapp driver | TX pkt #182 accepted by the DUT |
| 28880 | yapp driver | TX pkt #183: addr=0 len=1 parity=good delay=16 |
| 28925 | **DUT** | OUT ch0 pkt #182 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 28940 | ch0 driver | ch0: packet consumed (response delay 6) |
| 29015 | **DUT** | OUT ch0 pkt #182 done: 3 bytes in 10 cycles |
| 29015 | ch0 monitor | ch0 RX pkt #182: addr=0 len=1 parity=good |
| 29015 | scoreboard | ch0 pkt matched: addr=0 len=1 (182 matched so far) |
| 29045 | **DUT** | IN  pkt #183 header: addr=0 len=1 -> channel 0 |
| 29055 | **DUT** | OUT ch0 pkt #183 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29065 | **DUT** | IN  pkt #183 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29065 | yapp monitor | RX pkt #183 on the input: addr=0 len=1 parity=good gap=16 |
| 29065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29070 | yapp driver | TX pkt #183 accepted by the DUT |
| 29070 | yapp driver | TX pkt #184: addr=0 len=1 parity=good delay=11 |
| 29075 | **DUT** | OUT ch0 pkt #183 done: 3 bytes in 3 cycles |
| 29075 | ch0 monitor | ch0 RX pkt #183: addr=0 len=1 parity=good |
| 29075 | scoreboard | ch0 pkt matched: addr=0 len=1 (183 matched so far) |
| 29185 | **DUT** | IN  pkt #184 header: addr=0 len=1 -> channel 0 |
| 29195 | **DUT** | OUT ch0 pkt #184 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29205 | **DUT** | IN  pkt #184 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29205 | yapp monitor | RX pkt #184 on the input: addr=0 len=1 parity=good gap=11 |
| 29205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29210 | yapp driver | TX pkt #184 accepted by the DUT |
| 29210 | yapp driver | TX pkt #185: addr=0 len=1 parity=good delay=20 |
| 29215 | **DUT** | OUT ch0 pkt #184 done: 3 bytes in 3 cycles |
| 29215 | ch0 monitor | ch0 RX pkt #184: addr=0 len=1 parity=good |
| 29215 | scoreboard | ch0 pkt matched: addr=0 len=1 (184 matched so far) |
| 29415 | **DUT** | IN  pkt #185 header: addr=0 len=1 -> channel 0 |
| 29425 | **DUT** | OUT ch0 pkt #185 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29435 | **DUT** | IN  pkt #185 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29435 | yapp monitor | RX pkt #185 on the input: addr=0 len=1 parity=good gap=20 |
| 29435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29440 | yapp driver | TX pkt #185 accepted by the DUT |
| 29440 | yapp driver | TX pkt #186: addr=0 len=1 parity=good delay=19 |
| 29445 | **DUT** | OUT ch0 pkt #185 done: 3 bytes in 3 cycles |
| 29445 | ch0 monitor | ch0 RX pkt #185: addr=0 len=1 parity=good |
| 29445 | scoreboard | ch0 pkt matched: addr=0 len=1 (185 matched so far) |
| 29530 | ch0 driver | ch0: packet consumed (response delay 6) |
| 29635 | **DUT** | IN  pkt #186 header: addr=0 len=1 -> channel 0 |
| 29655 | **DUT** | IN  pkt #186 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29655 | yapp monitor | RX pkt #186 on the input: addr=0 len=1 parity=good gap=19 |
| 29655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29660 | yapp driver | TX pkt #186 accepted by the DUT |
| 29660 | yapp driver | TX pkt #187: addr=0 len=1 parity=good delay=4 |
| 29705 | **DUT** | IN  pkt #187 header: addr=0 len=1 -> channel 0 |
| 29725 | **DUT** | IN  pkt #187 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29725 | **DUT** | OUT ch0 pkt #186 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 29725 | yapp monitor | RX pkt #187 on the input: addr=0 len=1 parity=good gap=4 |
| 29725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29730 | yapp driver | TX pkt #187 accepted by the DUT |
| 29730 | yapp driver | TX pkt #188: addr=0 len=1 parity=good delay=14 |
| 29740 | ch0 driver | ch0: packet consumed (response delay 8) |
| 29825 | **DUT** | OUT ch0 pkt #186 done: 3 bytes in 11 cycles |
| 29825 | ch0 monitor | ch0 RX pkt #186: addr=0 len=1 parity=good |
| 29825 | scoreboard | ch0 pkt matched: addr=0 len=1 (186 matched so far) |
| 29835 | **DUT** | OUT ch0 pkt #187 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29855 | **DUT** | OUT ch0 pkt #187 done: 3 bytes in 3 cycles |
| 29855 | ch0 monitor | ch0 RX pkt #187: addr=0 len=1 parity=good |
| 29855 | scoreboard | ch0 pkt matched: addr=0 len=1 (187 matched so far) |
| 29875 | **DUT** | IN  pkt #188 header: addr=0 len=1 -> channel 0 |
| 29885 | **DUT** | OUT ch0 pkt #188 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29895 | **DUT** | IN  pkt #188 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29895 | yapp monitor | RX pkt #188 on the input: addr=0 len=1 parity=good gap=14 |
| 29895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29900 | yapp driver | TX pkt #188 accepted by the DUT |
| 29900 | yapp driver | TX pkt #189: addr=0 len=1 parity=good delay=18 |
| 29905 | **DUT** | OUT ch0 pkt #188 done: 3 bytes in 3 cycles |
| 29905 | ch0 monitor | ch0 RX pkt #188: addr=0 len=1 parity=good |
| 29905 | scoreboard | ch0 pkt matched: addr=0 len=1 (188 matched so far) |
| 29970 | ch0 driver | ch0: packet consumed (response delay 7) |
| 30085 | **DUT** | IN  pkt #189 header: addr=0 len=1 -> channel 0 |
| 30105 | **DUT** | IN  pkt #189 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30105 | yapp monitor | RX pkt #189 on the input: addr=0 len=1 parity=good gap=18 |
| 30105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30110 | yapp driver | TX pkt #189 accepted by the DUT |
| 30110 | yapp driver | TX pkt #190: addr=0 len=1 parity=good delay=17 |
| 30195 | **DUT** | OUT ch0 pkt #189 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 30210 | ch0 driver | ch0: packet consumed (response delay 10) |
| 30235 | **DUT** | OUT ch0 pkt #189 done: 3 bytes in 5 cycles |
| 30235 | ch0 monitor | ch0 RX pkt #189: addr=0 len=1 parity=good |
| 30235 | scoreboard | ch0 pkt matched: addr=0 len=1 (189 matched so far) |
| 30285 | **DUT** | IN  pkt #190 header: addr=0 len=1 -> channel 0 |
| 30295 | **DUT** | OUT ch0 pkt #190 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30305 | **DUT** | IN  pkt #190 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30305 | yapp monitor | RX pkt #190 on the input: addr=0 len=1 parity=good gap=17 |
| 30305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30310 | yapp driver | TX pkt #190 accepted by the DUT |
| 30310 | yapp driver | TX pkt #191: addr=0 len=1 parity=good delay=16 |
| 30315 | **DUT** | OUT ch0 pkt #190 done: 3 bytes in 3 cycles |
| 30315 | ch0 monitor | ch0 RX pkt #190: addr=0 len=1 parity=good |
| 30315 | scoreboard | ch0 pkt matched: addr=0 len=1 (190 matched so far) |
| 30400 | ch0 driver | ch0: packet consumed (response delay 1) |
| 30475 | **DUT** | IN  pkt #191 header: addr=0 len=1 -> channel 0 |
| 30495 | **DUT** | IN  pkt #191 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30495 | yapp monitor | RX pkt #191 on the input: addr=0 len=1 parity=good gap=16 |
| 30495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30500 | yapp driver | TX pkt #191 accepted by the DUT |
| 30500 | yapp driver | TX pkt #192: addr=0 len=1 parity=good delay=20 |
| 30585 | **DUT** | OUT ch0 pkt #191 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 30600 | ch0 driver | ch0: packet consumed (response delay 10) |
| 30695 | **DUT** | OUT ch0 pkt #191 done: 3 bytes in 12 cycles |
| 30695 | ch0 monitor | ch0 RX pkt #191: addr=0 len=1 parity=good |
| 30695 | scoreboard | ch0 pkt matched: addr=0 len=1 (191 matched so far) |
| 30705 | **DUT** | IN  pkt #192 header: addr=0 len=1 -> channel 0 |
| 30715 | **DUT** | OUT ch0 pkt #192 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30725 | **DUT** | IN  pkt #192 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30725 | yapp monitor | RX pkt #192 on the input: addr=0 len=1 parity=good gap=20 |
| 30725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30730 | yapp driver | TX pkt #192 accepted by the DUT |
| 30730 | yapp driver | TX pkt #193: addr=0 len=1 parity=good delay=20 |
| 30735 | **DUT** | OUT ch0 pkt #192 done: 3 bytes in 3 cycles |
| 30735 | ch0 monitor | ch0 RX pkt #192: addr=0 len=1 parity=good |
| 30735 | scoreboard | ch0 pkt matched: addr=0 len=1 (192 matched so far) |
| 30935 | **DUT** | IN  pkt #193 header: addr=0 len=1 -> channel 0 |
| 30945 | **DUT** | OUT ch0 pkt #193 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30955 | **DUT** | IN  pkt #193 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30955 | yapp monitor | RX pkt #193 on the input: addr=0 len=1 parity=good gap=20 |
| 30955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30960 | yapp driver | TX pkt #193 accepted by the DUT |
| 30960 | yapp driver | TX pkt #194: addr=0 len=1 parity=good delay=5 |
| 30965 | **DUT** | OUT ch0 pkt #193 done: 3 bytes in 3 cycles |
| 30965 | ch0 monitor | ch0 RX pkt #193: addr=0 len=1 parity=good |
| 30965 | scoreboard | ch0 pkt matched: addr=0 len=1 (193 matched so far) |
| 30990 | ch0 driver | ch0: packet consumed (response delay 8) |
| 31015 | **DUT** | IN  pkt #194 header: addr=0 len=1 -> channel 0 |
| 31035 | **DUT** | IN  pkt #194 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31035 | yapp monitor | RX pkt #194 on the input: addr=0 len=1 parity=good gap=5 |
| 31035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31040 | yapp driver | TX pkt #194 accepted by the DUT |
| 31040 | yapp driver | TX pkt #195: addr=0 len=1 parity=good delay=5 |
| 31095 | **DUT** | IN  pkt #195 header: addr=0 len=1 -> channel 0 |
| 31115 | **DUT** | IN  pkt #195 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31115 | **DUT** | OUT ch0 pkt #194 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 31115 | yapp monitor | RX pkt #195 on the input: addr=0 len=1 parity=good gap=5 |
| 31115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31120 | yapp driver | TX pkt #195 accepted by the DUT |
| 31120 | yapp driver | TX pkt #196: addr=0 len=1 parity=good delay=20 |
| 31130 | ch0 driver | ch0: packet consumed (response delay 9) |
| 31175 | **DUT** | OUT ch0 pkt #194 done: 3 bytes in 7 cycles |
| 31175 | ch0 monitor | ch0 RX pkt #194: addr=0 len=1 parity=good |
| 31175 | scoreboard | ch0 pkt matched: addr=0 len=1 (194 matched so far) |
| 31185 | **DUT** | OUT ch0 pkt #195 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31205 | **DUT** | OUT ch0 pkt #195 done: 3 bytes in 3 cycles |
| 31205 | ch0 monitor | ch0 RX pkt #195: addr=0 len=1 parity=good |
| 31205 | scoreboard | ch0 pkt matched: addr=0 len=1 (195 matched so far) |
| 31325 | **DUT** | IN  pkt #196 header: addr=0 len=1 -> channel 0 |
| 31335 | **DUT** | OUT ch0 pkt #196 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31345 | **DUT** | IN  pkt #196 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31345 | yapp monitor | RX pkt #196 on the input: addr=0 len=1 parity=good gap=20 |
| 31345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31350 | yapp driver | TX pkt #196 accepted by the DUT |
| 31350 | yapp driver | TX pkt #197: addr=0 len=1 parity=good delay=17 |
| 31355 | **DUT** | OUT ch0 pkt #196 done: 3 bytes in 3 cycles |
| 31355 | ch0 monitor | ch0 RX pkt #196: addr=0 len=1 parity=good |
| 31355 | scoreboard | ch0 pkt matched: addr=0 len=1 (196 matched so far) |
| 31370 | ch0 driver | ch0: packet consumed (response delay 3) |
| 31525 | **DUT** | IN  pkt #197 header: addr=0 len=1 -> channel 0 |
| 31545 | **DUT** | IN  pkt #197 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31545 | yapp monitor | RX pkt #197 on the input: addr=0 len=1 parity=good gap=17 |
| 31545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31550 | yapp driver | TX pkt #197 accepted by the DUT |
| 31550 | yapp driver | TX pkt #198: addr=0 len=1 parity=good delay=19 |
| 31575 | **DUT** | OUT ch0 pkt #197 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 31590 | ch0 driver | ch0: packet consumed (response delay 4) |
| 31635 | **DUT** | OUT ch0 pkt #197 done: 3 bytes in 7 cycles |
| 31635 | ch0 monitor | ch0 RX pkt #197: addr=0 len=1 parity=good |
| 31635 | scoreboard | ch0 pkt matched: addr=0 len=1 (197 matched so far) |
| 31745 | **DUT** | IN  pkt #198 header: addr=0 len=1 -> channel 0 |
| 31755 | **DUT** | OUT ch0 pkt #198 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31765 | **DUT** | IN  pkt #198 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31765 | yapp monitor | RX pkt #198 on the input: addr=0 len=1 parity=good gap=19 |
| 31765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31770 | yapp driver | TX pkt #198 accepted by the DUT |
| 31770 | yapp driver | TX pkt #199: addr=0 len=1 parity=good delay=20 |
| 31775 | **DUT** | OUT ch0 pkt #198 done: 3 bytes in 3 cycles |
| 31775 | ch0 monitor | ch0 RX pkt #198: addr=0 len=1 parity=good |
| 31775 | scoreboard | ch0 pkt matched: addr=0 len=1 (198 matched so far) |
| 31920 | ch0 driver | ch0: packet consumed (response delay 3) |
| 31975 | **DUT** | IN  pkt #199 header: addr=0 len=1 -> channel 0 |
| 31995 | **DUT** | IN  pkt #199 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31995 | yapp monitor | RX pkt #199 on the input: addr=0 len=1 parity=good gap=20 |
| 31995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32000 | yapp driver | TX pkt #199 accepted by the DUT |
| 32000 | yapp driver | TX pkt #200: addr=0 len=1 parity=good delay=7 |
| 32015 | **DUT** | OUT ch0 pkt #199 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 32030 | ch0 driver | ch0: packet consumed (response delay 3) |
| 32075 | **DUT** | IN  pkt #200 header: addr=0 len=1 -> channel 0 |
| 32095 | **DUT** | IN  pkt #200 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32095 | yapp monitor | RX pkt #200 on the input: addr=0 len=1 parity=good gap=7 |
| 32095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32100 | yapp driver | TX pkt #200 accepted by the DUT |
| 32100 | yapp driver | TX pkt #201: addr=0 len=1 parity=good delay=20 |
| 32135 | **DUT** | OUT ch0 pkt #199 done: 3 bytes in 13 cycles |
| 32135 | ch0 monitor | ch0 RX pkt #199: addr=0 len=1 parity=good |
| 32135 | scoreboard | ch0 pkt matched: addr=0 len=1 (199 matched so far) |
| 32145 | **DUT** | OUT ch0 pkt #200 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32165 | **DUT** | OUT ch0 pkt #200 done: 3 bytes in 3 cycles |
| 32165 | ch0 monitor | ch0 RX pkt #200: addr=0 len=1 parity=good |
| 32165 | scoreboard | ch0 pkt matched: addr=0 len=1 (200 matched so far) |
| 32305 | **DUT** | IN  pkt #201 header: addr=0 len=1 -> channel 0 |
| 32315 | **DUT** | OUT ch0 pkt #201 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32325 | **DUT** | IN  pkt #201 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32325 | yapp monitor | RX pkt #201 on the input: addr=0 len=1 parity=good gap=20 |
| 32325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32330 | yapp driver | TX pkt #201 accepted by the DUT |
| 32330 | yapp driver | TX pkt #202: addr=0 len=1 parity=good delay=18 |
| 32335 | **DUT** | OUT ch0 pkt #201 done: 3 bytes in 3 cycles |
| 32335 | ch0 monitor | ch0 RX pkt #201: addr=0 len=1 parity=good |
| 32335 | scoreboard | ch0 pkt matched: addr=0 len=1 (201 matched so far) |
| 32515 | **DUT** | IN  pkt #202 header: addr=0 len=1 -> channel 0 |
| 32525 | **DUT** | OUT ch0 pkt #202 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32535 | **DUT** | IN  pkt #202 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32535 | yapp monitor | RX pkt #202 on the input: addr=0 len=1 parity=good gap=18 |
| 32535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32540 | yapp driver | TX pkt #202 accepted by the DUT |
| 32540 | yapp driver | TX pkt #203: addr=0 len=1 parity=good delay=20 |
| 32545 | **DUT** | OUT ch0 pkt #202 done: 3 bytes in 3 cycles |
| 32545 | ch0 monitor | ch0 RX pkt #202: addr=0 len=1 parity=good |
| 32545 | scoreboard | ch0 pkt matched: addr=0 len=1 (202 matched so far) |
| 32600 | ch0 driver | ch0: packet consumed (response delay 9) |
| 32745 | **DUT** | IN  pkt #203 header: addr=0 len=1 -> channel 0 |
| 32765 | **DUT** | IN  pkt #203 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32765 | yapp monitor | RX pkt #203 on the input: addr=0 len=1 parity=good gap=20 |
| 32765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32770 | yapp driver | TX pkt #203 accepted by the DUT |
| 32770 | yapp driver | TX pkt #204: addr=0 len=1 parity=good delay=19 |
| 32775 | **DUT** | OUT ch0 pkt #203 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 32790 | ch0 driver | ch0: packet consumed (response delay 2) |
| 32825 | **DUT** | OUT ch0 pkt #203 done: 3 bytes in 6 cycles |
| 32825 | ch0 monitor | ch0 RX pkt #203: addr=0 len=1 parity=good |
| 32825 | scoreboard | ch0 pkt matched: addr=0 len=1 (203 matched so far) |
| 32965 | **DUT** | IN  pkt #204 header: addr=0 len=1 -> channel 0 |
| 32975 | **DUT** | OUT ch0 pkt #204 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32985 | **DUT** | IN  pkt #204 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32985 | yapp monitor | RX pkt #204 on the input: addr=0 len=1 parity=good gap=19 |
| 32985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32990 | yapp driver | TX pkt #204 accepted by the DUT |
| 32990 | yapp driver | TX pkt #205: addr=0 len=1 parity=good delay=20 |
| 32995 | **DUT** | OUT ch0 pkt #204 done: 3 bytes in 3 cycles |
| 32995 | ch0 monitor | ch0 RX pkt #204: addr=0 len=1 parity=good |
| 32995 | scoreboard | ch0 pkt matched: addr=0 len=1 (204 matched so far) |
| 33195 | **DUT** | IN  pkt #205 header: addr=0 len=1 -> channel 0 |
| 33205 | **DUT** | OUT ch0 pkt #205 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33210 | ch0 driver | ch0: packet consumed (response delay 2) |
| 33215 | **DUT** | IN  pkt #205 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33215 | yapp monitor | RX pkt #205 on the input: addr=0 len=1 parity=good gap=20 |
| 33215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33220 | yapp driver | TX pkt #205 accepted by the DUT |
| 33220 | yapp driver | TX pkt #206: addr=0 len=1 parity=good delay=16 |
| 33315 | **DUT** | OUT ch0 pkt #205 done: 3 bytes in 12 cycles |
| 33315 | ch0 monitor | ch0 RX pkt #205: addr=0 len=1 parity=good |
| 33315 | scoreboard | ch0 pkt matched: addr=0 len=1 (205 matched so far) |
| 33330 | ch0 driver | ch0: packet consumed (response delay 8) |
| 33385 | **DUT** | IN  pkt #206 header: addr=0 len=1 -> channel 0 |
| 33405 | **DUT** | IN  pkt #206 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33405 | yapp monitor | RX pkt #206 on the input: addr=0 len=1 parity=good gap=16 |
| 33405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33410 | yapp driver | TX pkt #206 accepted by the DUT |
| 33410 | yapp driver | TX pkt #207: addr=0 len=1 parity=good delay=17 |
| 33495 | **DUT** | OUT ch0 pkt #206 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 33510 | ch0 driver | ch0: packet consumed (response delay 10) |
| 33585 | **DUT** | IN  pkt #207 header: addr=0 len=1 -> channel 0 |
| 33595 | **DUT** | OUT ch0 pkt #206 done: 3 bytes in 11 cycles |
| 33595 | ch0 monitor | ch0 RX pkt #206: addr=0 len=1 parity=good |
| 33595 | scoreboard | ch0 pkt matched: addr=0 len=1 (206 matched so far) |
| 33605 | **DUT** | IN  pkt #207 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33605 | **DUT** | OUT ch0 pkt #207 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33605 | yapp monitor | RX pkt #207 on the input: addr=0 len=1 parity=good gap=17 |
| 33605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33610 | yapp driver | TX pkt #207 accepted by the DUT |
| 33610 | yapp driver | TX pkt #208: addr=0 len=1 parity=good delay=12 |
| 33625 | **DUT** | OUT ch0 pkt #207 done: 3 bytes in 3 cycles |
| 33625 | ch0 monitor | ch0 RX pkt #207: addr=0 len=1 parity=good |
| 33625 | scoreboard | ch0 pkt matched: addr=0 len=1 (207 matched so far) |
| 33735 | **DUT** | IN  pkt #208 header: addr=0 len=1 -> channel 0 |
| 33745 | **DUT** | OUT ch0 pkt #208 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33755 | **DUT** | IN  pkt #208 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33755 | yapp monitor | RX pkt #208 on the input: addr=0 len=1 parity=good gap=12 |
| 33755 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33760 | yapp driver | TX pkt #208 accepted by the DUT |
| 33760 | yapp driver | TX pkt #209: addr=0 len=1 parity=good delay=15 |
| 33765 | **DUT** | OUT ch0 pkt #208 done: 3 bytes in 3 cycles |
| 33765 | ch0 monitor | ch0 RX pkt #208: addr=0 len=1 parity=good |
| 33765 | scoreboard | ch0 pkt matched: addr=0 len=1 (208 matched so far) |
| 33770 | ch0 driver | ch0: packet consumed (response delay 7) |
| 33915 | **DUT** | IN  pkt #209 header: addr=0 len=1 -> channel 0 |
| 33935 | **DUT** | IN  pkt #209 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33935 | yapp monitor | RX pkt #209 on the input: addr=0 len=1 parity=good gap=15 |
| 33935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33940 | yapp driver | TX pkt #209 accepted by the DUT |
| 33940 | yapp driver | TX pkt #210: addr=0 len=1 parity=good delay=16 |
| 34025 | **DUT** | OUT ch0 pkt #209 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 34040 | ch0 driver | ch0: packet consumed (response delay 10) |
| 34105 | **DUT** | IN  pkt #210 header: addr=0 len=1 -> channel 0 |
| 34125 | **DUT** | IN  pkt #210 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34125 | yapp monitor | RX pkt #210 on the input: addr=0 len=1 parity=good gap=16 |
| 34125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34130 | yapp driver | TX pkt #210 accepted by the DUT |
| 34130 | yapp driver | TX pkt #211: addr=0 len=1 parity=good delay=18 |
| 34155 | **DUT** | OUT ch0 pkt #209 done: 3 bytes in 14 cycles |
| 34155 | ch0 monitor | ch0 RX pkt #209: addr=0 len=1 parity=good |
| 34155 | scoreboard | ch0 pkt matched: addr=0 len=1 (209 matched so far) |
| 34165 | **DUT** | OUT ch0 pkt #210 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34185 | **DUT** | OUT ch0 pkt #210 done: 3 bytes in 3 cycles |
| 34185 | ch0 monitor | ch0 RX pkt #210: addr=0 len=1 parity=good |
| 34185 | scoreboard | ch0 pkt matched: addr=0 len=1 (210 matched so far) |
| 34220 | ch0 driver | ch0: packet consumed (response delay 10) |
| 34315 | **DUT** | IN  pkt #211 header: addr=0 len=1 -> channel 0 |
| 34335 | **DUT** | IN  pkt #211 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34335 | yapp monitor | RX pkt #211 on the input: addr=0 len=1 parity=good gap=18 |
| 34335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34340 | yapp driver | TX pkt #211 accepted by the DUT |
| 34340 | yapp driver | TX pkt #212: addr=0 len=1 parity=good delay=3 |
| 34375 | **DUT** | IN  pkt #212 header: addr=0 len=1 -> channel 0 |
| 34395 | **DUT** | IN  pkt #212 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34395 | yapp monitor | RX pkt #212 on the input: addr=0 len=1 parity=good gap=3 |
| 34395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34400 | yapp driver | TX pkt #212 accepted by the DUT |
| 34400 | yapp driver | TX pkt #213: addr=0 len=1 parity=good delay=9 |
| 34425 | **DUT** | OUT ch0 pkt #211 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 34440 | ch0 driver | ch0: packet consumed (response delay 10) |
| 34495 | **DUT** | IN  pkt #213 header: addr=0 len=1 -> channel 0 |
| 34505 | **DUT** | OUT ch0 pkt #211 done: 3 bytes in 9 cycles |
| 34505 | ch0 monitor | ch0 RX pkt #211: addr=0 len=1 parity=good |
| 34505 | scoreboard | ch0 pkt matched: addr=0 len=1 (211 matched so far) |
| 34515 | **DUT** | IN  pkt #213 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34515 | **DUT** | OUT ch0 pkt #212 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34515 | yapp monitor | RX pkt #213 on the input: addr=0 len=1 parity=good gap=9 |
| 34515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34520 | yapp driver | TX pkt #213 accepted by the DUT |
| 34520 | yapp driver | TX pkt #214: addr=0 len=1 parity=good delay=11 |
| 34535 | **DUT** | OUT ch0 pkt #212 done: 3 bytes in 3 cycles |
| 34535 | ch0 monitor | ch0 RX pkt #212: addr=0 len=1 parity=good |
| 34535 | scoreboard | ch0 pkt matched: addr=0 len=1 (212 matched so far) |
| 34545 | **DUT** | OUT ch0 pkt #213 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34565 | **DUT** | OUT ch0 pkt #213 done: 3 bytes in 3 cycles |
| 34565 | ch0 monitor | ch0 RX pkt #213: addr=0 len=1 parity=good |
| 34565 | scoreboard | ch0 pkt matched: addr=0 len=1 (213 matched so far) |
| 34635 | **DUT** | IN  pkt #214 header: addr=0 len=1 -> channel 0 |
| 34645 | **DUT** | OUT ch0 pkt #214 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34655 | **DUT** | IN  pkt #214 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34655 | yapp monitor | RX pkt #214 on the input: addr=0 len=1 parity=good gap=11 |
| 34655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34660 | yapp driver | TX pkt #214 accepted by the DUT |
| 34660 | yapp driver | TX pkt #215: addr=0 len=1 parity=good delay=20 |
| 34665 | **DUT** | OUT ch0 pkt #214 done: 3 bytes in 3 cycles |
| 34665 | ch0 monitor | ch0 RX pkt #214: addr=0 len=1 parity=good |
| 34665 | scoreboard | ch0 pkt matched: addr=0 len=1 (214 matched so far) |
| 34720 | ch0 driver | ch0: packet consumed (response delay 5) |
| 34865 | **DUT** | IN  pkt #215 header: addr=0 len=1 -> channel 0 |
| 34885 | **DUT** | IN  pkt #215 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34885 | **DUT** | OUT ch0 pkt #215 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 34885 | yapp monitor | RX pkt #215 on the input: addr=0 len=1 parity=good gap=20 |
| 34885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34890 | yapp driver | TX pkt #215 accepted by the DUT |
| 34890 | yapp driver | TX pkt #216: addr=0 len=1 parity=good delay=18 |
| 34900 | ch0 driver | ch0: packet consumed (response delay 1) |
| 34995 | **DUT** | OUT ch0 pkt #215 done: 3 bytes in 12 cycles |
| 34995 | ch0 monitor | ch0 RX pkt #215: addr=0 len=1 parity=good |
| 34995 | scoreboard | ch0 pkt matched: addr=0 len=1 (215 matched so far) |
| 35075 | **DUT** | IN  pkt #216 header: addr=0 len=1 -> channel 0 |
| 35085 | **DUT** | OUT ch0 pkt #216 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35095 | **DUT** | IN  pkt #216 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35095 | yapp monitor | RX pkt #216 on the input: addr=0 len=1 parity=good gap=18 |
| 35095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35100 | yapp driver | TX pkt #216 accepted by the DUT |
| 35100 | yapp driver | TX pkt #217: addr=0 len=1 parity=good delay=3 |
| 35105 | **DUT** | OUT ch0 pkt #216 done: 3 bytes in 3 cycles |
| 35105 | ch0 monitor | ch0 RX pkt #216: addr=0 len=1 parity=good |
| 35105 | scoreboard | ch0 pkt matched: addr=0 len=1 (216 matched so far) |
| 35135 | **DUT** | IN  pkt #217 header: addr=0 len=1 -> channel 0 |
| 35145 | **DUT** | OUT ch0 pkt #217 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35155 | **DUT** | IN  pkt #217 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35155 | yapp monitor | RX pkt #217 on the input: addr=0 len=1 parity=good gap=3 |
| 35155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35160 | yapp driver | TX pkt #217 accepted by the DUT |
| 35160 | yapp driver | TX pkt #218: addr=0 len=1 parity=good delay=5 |
| 35165 | **DUT** | OUT ch0 pkt #217 done: 3 bytes in 3 cycles |
| 35165 | ch0 monitor | ch0 RX pkt #217: addr=0 len=1 parity=good |
| 35165 | scoreboard | ch0 pkt matched: addr=0 len=1 (217 matched so far) |
| 35215 | **DUT** | IN  pkt #218 header: addr=0 len=1 -> channel 0 |
| 35225 | **DUT** | OUT ch0 pkt #218 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35235 | **DUT** | IN  pkt #218 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35235 | yapp monitor | RX pkt #218 on the input: addr=0 len=1 parity=good gap=5 |
| 35235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35240 | yapp driver | TX pkt #218 accepted by the DUT |
| 35240 | yapp driver | TX pkt #219: addr=0 len=1 parity=good delay=18 |
| 35245 | **DUT** | OUT ch0 pkt #218 done: 3 bytes in 3 cycles |
| 35245 | ch0 monitor | ch0 RX pkt #218: addr=0 len=1 parity=good |
| 35245 | scoreboard | ch0 pkt matched: addr=0 len=1 (218 matched so far) |
| 35425 | **DUT** | IN  pkt #219 header: addr=0 len=1 -> channel 0 |
| 35435 | **DUT** | OUT ch0 pkt #219 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35445 | **DUT** | IN  pkt #219 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35445 | yapp monitor | RX pkt #219 on the input: addr=0 len=1 parity=good gap=18 |
| 35445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35450 | yapp driver | TX pkt #219 accepted by the DUT |
| 35450 | yapp driver | TX pkt #220: addr=0 len=1 parity=good delay=5 |
| 35455 | **DUT** | OUT ch0 pkt #219 done: 3 bytes in 3 cycles |
| 35455 | ch0 monitor | ch0 RX pkt #219: addr=0 len=1 parity=good |
| 35455 | scoreboard | ch0 pkt matched: addr=0 len=1 (219 matched so far) |
| 35505 | **DUT** | IN  pkt #220 header: addr=0 len=1 -> channel 0 |
| 35515 | **DUT** | OUT ch0 pkt #220 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35525 | **DUT** | IN  pkt #220 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35525 | yapp monitor | RX pkt #220 on the input: addr=0 len=1 parity=good gap=5 |
| 35525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35530 | yapp driver | TX pkt #220 accepted by the DUT |
| 35530 | yapp driver | TX pkt #221: addr=0 len=1 parity=good delay=19 |
| 35535 | **DUT** | OUT ch0 pkt #220 done: 3 bytes in 3 cycles |
| 35535 | ch0 monitor | ch0 RX pkt #220: addr=0 len=1 parity=good |
| 35535 | scoreboard | ch0 pkt matched: addr=0 len=1 (220 matched so far) |
| 35600 | ch0 driver | ch0: packet consumed (response delay 8) |
| 35725 | **DUT** | IN  pkt #221 header: addr=0 len=1 -> channel 0 |
| 35745 | **DUT** | IN  pkt #221 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35745 | yapp monitor | RX pkt #221 on the input: addr=0 len=1 parity=good gap=19 |
| 35745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35750 | yapp driver | TX pkt #221 accepted by the DUT |
| 35750 | yapp driver | TX pkt #222: addr=0 len=1 parity=good delay=20 |
| 35815 | **DUT** | OUT ch0 pkt #221 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 35830 | ch0 driver | ch0: packet consumed (response delay 8) |
| 35945 | **DUT** | OUT ch0 pkt #221 done: 3 bytes in 14 cycles |
| 35945 | ch0 monitor | ch0 RX pkt #221: addr=0 len=1 parity=good |
| 35945 | scoreboard | ch0 pkt matched: addr=0 len=1 (221 matched so far) |
| 35955 | **DUT** | IN  pkt #222 header: addr=0 len=1 -> channel 0 |
| 35965 | **DUT** | OUT ch0 pkt #222 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35975 | **DUT** | IN  pkt #222 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35975 | yapp monitor | RX pkt #222 on the input: addr=0 len=1 parity=good gap=20 |
| 35975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35980 | yapp driver | TX pkt #222 accepted by the DUT |
| 35980 | yapp driver | TX pkt #223: addr=0 len=1 parity=good delay=17 |
| 35985 | **DUT** | OUT ch0 pkt #222 done: 3 bytes in 3 cycles |
| 35985 | ch0 monitor | ch0 RX pkt #222: addr=0 len=1 parity=good |
| 35985 | scoreboard | ch0 pkt matched: addr=0 len=1 (222 matched so far) |
| 36110 | ch0 driver | ch0: packet consumed (response delay 10) |
| 36155 | **DUT** | IN  pkt #223 header: addr=0 len=1 -> channel 0 |
| 36175 | **DUT** | IN  pkt #223 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36175 | yapp monitor | RX pkt #223 on the input: addr=0 len=1 parity=good gap=17 |
| 36175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36180 | yapp driver | TX pkt #223 accepted by the DUT |
| 36180 | yapp driver | TX pkt #224: addr=0 len=1 parity=good delay=14 |
| 36215 | **DUT** | OUT ch0 pkt #223 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 36230 | ch0 driver | ch0: packet consumed (response delay 5) |
| 36325 | **DUT** | IN  pkt #224 header: addr=0 len=1 -> channel 0 |
| 36345 | **DUT** | IN  pkt #224 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36345 | **DUT** | OUT ch0 pkt #223 done: 3 bytes in 14 cycles |
| 36345 | ch0 monitor | ch0 RX pkt #223: addr=0 len=1 parity=good |
| 36345 | scoreboard | ch0 pkt matched: addr=0 len=1 (223 matched so far) |
| 36345 | yapp monitor | RX pkt #224 on the input: addr=0 len=1 parity=good gap=14 |
| 36345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36350 | yapp driver | TX pkt #224 accepted by the DUT |
| 36350 | yapp driver | TX pkt #225: addr=0 len=1 parity=good delay=20 |
| 36355 | **DUT** | OUT ch0 pkt #224 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36375 | **DUT** | OUT ch0 pkt #224 done: 3 bytes in 3 cycles |
| 36375 | ch0 monitor | ch0 RX pkt #224: addr=0 len=1 parity=good |
| 36375 | scoreboard | ch0 pkt matched: addr=0 len=1 (224 matched so far) |
| 36555 | **DUT** | IN  pkt #225 header: addr=0 len=1 -> channel 0 |
| 36565 | **DUT** | OUT ch0 pkt #225 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36575 | **DUT** | IN  pkt #225 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36575 | yapp monitor | RX pkt #225 on the input: addr=0 len=1 parity=good gap=20 |
| 36575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36580 | yapp driver | TX pkt #225 accepted by the DUT |
| 36580 | yapp driver | TX pkt #226: addr=0 len=1 parity=good delay=20 |
| 36585 | **DUT** | OUT ch0 pkt #225 done: 3 bytes in 3 cycles |
| 36585 | ch0 monitor | ch0 RX pkt #225: addr=0 len=1 parity=good |
| 36585 | scoreboard | ch0 pkt matched: addr=0 len=1 (225 matched so far) |
| 36710 | ch0 driver | ch0: packet consumed (response delay 10) |
| 36785 | **DUT** | IN  pkt #226 header: addr=0 len=1 -> channel 0 |
| 36805 | **DUT** | IN  pkt #226 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36805 | yapp monitor | RX pkt #226 on the input: addr=0 len=1 parity=good gap=20 |
| 36805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36810 | yapp driver | TX pkt #226 accepted by the DUT |
| 36810 | yapp driver | TX pkt #227: addr=0 len=1 parity=good delay=20 |
| 36865 | **DUT** | OUT ch0 pkt #226 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 36880 | ch0 driver | ch0: packet consumed (response delay 7) |
| 36905 | **DUT** | OUT ch0 pkt #226 done: 3 bytes in 5 cycles |
| 36905 | ch0 monitor | ch0 RX pkt #226: addr=0 len=1 parity=good |
| 36905 | scoreboard | ch0 pkt matched: addr=0 len=1 (226 matched so far) |
| 37015 | **DUT** | IN  pkt #227 header: addr=0 len=1 -> channel 0 |
| 37025 | **DUT** | OUT ch0 pkt #227 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37035 | **DUT** | IN  pkt #227 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37035 | yapp monitor | RX pkt #227 on the input: addr=0 len=1 parity=good gap=20 |
| 37035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37040 | yapp driver | TX pkt #227 accepted by the DUT |
| 37040 | yapp driver | TX pkt #228: addr=0 len=1 parity=good delay=14 |
| 37045 | **DUT** | OUT ch0 pkt #227 done: 3 bytes in 3 cycles |
| 37045 | ch0 monitor | ch0 RX pkt #227: addr=0 len=1 parity=good |
| 37045 | scoreboard | ch0 pkt matched: addr=0 len=1 (227 matched so far) |
| 37185 | **DUT** | IN  pkt #228 header: addr=0 len=1 -> channel 0 |
| 37195 | **DUT** | OUT ch0 pkt #228 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37205 | **DUT** | IN  pkt #228 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37205 | yapp monitor | RX pkt #228 on the input: addr=0 len=1 parity=good gap=14 |
| 37205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37210 | yapp driver | TX pkt #228 accepted by the DUT |
| 37210 | yapp driver | TX pkt #229: addr=0 len=1 parity=good delay=3 |
| 37215 | **DUT** | OUT ch0 pkt #228 done: 3 bytes in 3 cycles |
| 37215 | ch0 monitor | ch0 RX pkt #228: addr=0 len=1 parity=good |
| 37215 | scoreboard | ch0 pkt matched: addr=0 len=1 (228 matched so far) |
| 37245 | **DUT** | IN  pkt #229 header: addr=0 len=1 -> channel 0 |
| 37255 | **DUT** | OUT ch0 pkt #229 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37265 | **DUT** | IN  pkt #229 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37265 | yapp monitor | RX pkt #229 on the input: addr=0 len=1 parity=good gap=3 |
| 37265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37270 | yapp driver | TX pkt #229 accepted by the DUT |
| 37270 | yapp driver | TX pkt #230: addr=0 len=1 parity=good delay=3 |
| 37275 | **DUT** | OUT ch0 pkt #229 done: 3 bytes in 3 cycles |
| 37275 | ch0 monitor | ch0 RX pkt #229: addr=0 len=1 parity=good |
| 37275 | scoreboard | ch0 pkt matched: addr=0 len=1 (229 matched so far) |
| 37305 | **DUT** | IN  pkt #230 header: addr=0 len=1 -> channel 0 |
| 37310 | ch0 driver | ch0: packet consumed (response delay 1) |
| 37325 | **DUT** | IN  pkt #230 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37325 | yapp monitor | RX pkt #230 on the input: addr=0 len=1 parity=good gap=3 |
| 37325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37330 | yapp driver | TX pkt #230 accepted by the DUT |
| 37330 | yapp driver | TX pkt #231: addr=0 len=1 parity=good delay=12 |
| 37385 | **DUT** | OUT ch0 pkt #230 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 37400 | ch0 driver | ch0: packet consumed (response delay 6) |
| 37455 | **DUT** | IN  pkt #231 header: addr=0 len=1 -> channel 0 |
| 37475 | **DUT** | IN  pkt #231 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37475 | yapp monitor | RX pkt #231 on the input: addr=0 len=1 parity=good gap=12 |
| 37475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37480 | yapp driver | TX pkt #231 accepted by the DUT |
| 37480 | yapp driver | TX pkt #232: addr=0 len=1 parity=good delay=20 |
| 37505 | **DUT** | OUT ch0 pkt #230 done: 3 bytes in 13 cycles |
| 37505 | ch0 monitor | ch0 RX pkt #230: addr=0 len=1 parity=good |
| 37505 | scoreboard | ch0 pkt matched: addr=0 len=1 (230 matched so far) |
| 37515 | **DUT** | OUT ch0 pkt #231 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37535 | **DUT** | OUT ch0 pkt #231 done: 3 bytes in 3 cycles |
| 37535 | ch0 monitor | ch0 RX pkt #231: addr=0 len=1 parity=good |
| 37535 | scoreboard | ch0 pkt matched: addr=0 len=1 (231 matched so far) |
| 37685 | **DUT** | IN  pkt #232 header: addr=0 len=1 -> channel 0 |
| 37695 | **DUT** | OUT ch0 pkt #232 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37705 | **DUT** | IN  pkt #232 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37705 | yapp monitor | RX pkt #232 on the input: addr=0 len=1 parity=good gap=20 |
| 37705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37710 | yapp driver | TX pkt #232 accepted by the DUT |
| 37710 | yapp driver | TX pkt #233: addr=0 len=1 parity=good delay=7 |
| 37715 | **DUT** | OUT ch0 pkt #232 done: 3 bytes in 3 cycles |
| 37715 | ch0 monitor | ch0 RX pkt #232: addr=0 len=1 parity=good |
| 37715 | scoreboard | ch0 pkt matched: addr=0 len=1 (232 matched so far) |
| 37720 | ch0 driver | ch0: packet consumed (response delay 9) |
| 37785 | **DUT** | IN  pkt #233 header: addr=0 len=1 -> channel 0 |
| 37805 | **DUT** | IN  pkt #233 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37805 | yapp monitor | RX pkt #233 on the input: addr=0 len=1 parity=good gap=7 |
| 37805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37810 | yapp driver | TX pkt #233 accepted by the DUT |
| 37810 | yapp driver | TX pkt #234: addr=0 len=1 parity=good delay=20 |
| 37875 | **DUT** | OUT ch0 pkt #233 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 37890 | ch0 driver | ch0: packet consumed (response delay 8) |
| 37965 | **DUT** | OUT ch0 pkt #233 done: 3 bytes in 10 cycles |
| 37965 | ch0 monitor | ch0 RX pkt #233: addr=0 len=1 parity=good |
| 37965 | scoreboard | ch0 pkt matched: addr=0 len=1 (233 matched so far) |
| 38015 | **DUT** | IN  pkt #234 header: addr=0 len=1 -> channel 0 |
| 38025 | **DUT** | OUT ch0 pkt #234 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38035 | **DUT** | IN  pkt #234 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38035 | yapp monitor | RX pkt #234 on the input: addr=0 len=1 parity=good gap=20 |
| 38035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38040 | yapp driver | TX pkt #234 accepted by the DUT |
| 38040 | yapp driver | TX pkt #235: addr=0 len=1 parity=good delay=6 |
| 38045 | **DUT** | OUT ch0 pkt #234 done: 3 bytes in 3 cycles |
| 38045 | ch0 monitor | ch0 RX pkt #234: addr=0 len=1 parity=good |
| 38045 | scoreboard | ch0 pkt matched: addr=0 len=1 (234 matched so far) |
| 38105 | **DUT** | IN  pkt #235 header: addr=0 len=1 -> channel 0 |
| 38115 | **DUT** | OUT ch0 pkt #235 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38125 | **DUT** | IN  pkt #235 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38125 | yapp monitor | RX pkt #235 on the input: addr=0 len=1 parity=good gap=6 |
| 38125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38130 | ch0 driver | ch0: packet consumed (response delay 6) |
| 38130 | yapp driver | TX pkt #235 accepted by the DUT |
| 38130 | yapp driver | TX pkt #236: addr=0 len=1 parity=good delay=16 |
| 38215 | **DUT** | OUT ch0 pkt #235 done: 3 bytes in 11 cycles |
| 38215 | ch0 monitor | ch0 RX pkt #235: addr=0 len=1 parity=good |
| 38215 | scoreboard | ch0 pkt matched: addr=0 len=1 (235 matched so far) |
| 38295 | **DUT** | IN  pkt #236 header: addr=0 len=1 -> channel 0 |
| 38305 | **DUT** | OUT ch0 pkt #236 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38315 | **DUT** | IN  pkt #236 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38315 | yapp monitor | RX pkt #236 on the input: addr=0 len=1 parity=good gap=16 |
| 38315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38320 | yapp driver | TX pkt #236 accepted by the DUT |
| 38320 | yapp driver | TX pkt #237: addr=0 len=1 parity=good delay=20 |
| 38325 | **DUT** | OUT ch0 pkt #236 done: 3 bytes in 3 cycles |
| 38325 | ch0 monitor | ch0 RX pkt #236: addr=0 len=1 parity=good |
| 38325 | scoreboard | ch0 pkt matched: addr=0 len=1 (236 matched so far) |
| 38450 | ch0 driver | ch0: packet consumed (response delay 7) |
| 38525 | **DUT** | IN  pkt #237 header: addr=0 len=1 -> channel 0 |
| 38545 | **DUT** | IN  pkt #237 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38545 | yapp monitor | RX pkt #237 on the input: addr=0 len=1 parity=good gap=20 |
| 38545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38550 | yapp driver | TX pkt #237 accepted by the DUT |
| 38550 | yapp driver | TX pkt #238: addr=0 len=1 parity=good delay=17 |
| 38635 | **DUT** | OUT ch0 pkt #237 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 38650 | ch0 driver | ch0: packet consumed (response delay 10) |
| 38675 | **DUT** | OUT ch0 pkt #237 done: 3 bytes in 5 cycles |
| 38675 | ch0 monitor | ch0 RX pkt #237: addr=0 len=1 parity=good |
| 38675 | scoreboard | ch0 pkt matched: addr=0 len=1 (237 matched so far) |
| 38725 | **DUT** | IN  pkt #238 header: addr=0 len=1 -> channel 0 |
| 38735 | **DUT** | OUT ch0 pkt #238 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38745 | **DUT** | IN  pkt #238 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38745 | yapp monitor | RX pkt #238 on the input: addr=0 len=1 parity=good gap=17 |
| 38745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38750 | yapp driver | TX pkt #238 accepted by the DUT |
| 38750 | yapp driver | TX pkt #239: addr=0 len=1 parity=good delay=5 |
| 38755 | **DUT** | OUT ch0 pkt #238 done: 3 bytes in 3 cycles |
| 38755 | ch0 monitor | ch0 RX pkt #238: addr=0 len=1 parity=good |
| 38755 | scoreboard | ch0 pkt matched: addr=0 len=1 (238 matched so far) |
| 38805 | **DUT** | IN  pkt #239 header: addr=0 len=1 -> channel 0 |
| 38815 | **DUT** | OUT ch0 pkt #239 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38825 | **DUT** | IN  pkt #239 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38825 | yapp monitor | RX pkt #239 on the input: addr=0 len=1 parity=good gap=5 |
| 38825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38830 | yapp driver | TX pkt #239 accepted by the DUT |
| 38830 | yapp driver | TX pkt #240: addr=0 len=1 parity=good delay=5 |
| 38835 | **DUT** | OUT ch0 pkt #239 done: 3 bytes in 3 cycles |
| 38835 | ch0 monitor | ch0 RX pkt #239: addr=0 len=1 parity=good |
| 38835 | scoreboard | ch0 pkt matched: addr=0 len=1 (239 matched so far) |
| 38885 | **DUT** | IN  pkt #240 header: addr=0 len=1 -> channel 0 |
| 38895 | **DUT** | OUT ch0 pkt #240 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38905 | **DUT** | IN  pkt #240 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38905 | yapp monitor | RX pkt #240 on the input: addr=0 len=1 parity=good gap=5 |
| 38905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38910 | yapp driver | TX pkt #240 accepted by the DUT |
| 38910 | yapp driver | TX pkt #241: addr=0 len=1 parity=good delay=12 |
| 38915 | **DUT** | OUT ch0 pkt #240 done: 3 bytes in 3 cycles |
| 38915 | ch0 monitor | ch0 RX pkt #240: addr=0 len=1 parity=good |
| 38915 | scoreboard | ch0 pkt matched: addr=0 len=1 (240 matched so far) |
| 39035 | **DUT** | IN  pkt #241 header: addr=0 len=1 -> channel 0 |
| 39045 | **DUT** | OUT ch0 pkt #241 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39055 | **DUT** | IN  pkt #241 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39055 | yapp monitor | RX pkt #241 on the input: addr=0 len=1 parity=good gap=12 |
| 39055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39060 | yapp driver | TX pkt #241 accepted by the DUT |
| 39060 | yapp driver | TX pkt #242: addr=0 len=1 parity=good delay=17 |
| 39065 | **DUT** | OUT ch0 pkt #241 done: 3 bytes in 3 cycles |
| 39065 | ch0 monitor | ch0 RX pkt #241: addr=0 len=1 parity=good |
| 39065 | scoreboard | ch0 pkt matched: addr=0 len=1 (241 matched so far) |
| 39070 | ch0 driver | ch0: packet consumed (response delay 1) |
| 39235 | **DUT** | IN  pkt #242 header: addr=0 len=1 -> channel 0 |
| 39245 | **DUT** | OUT ch0 pkt #242 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39255 | **DUT** | IN  pkt #242 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39255 | yapp monitor | RX pkt #242 on the input: addr=0 len=1 parity=good gap=17 |
| 39255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39260 | ch0 driver | ch0: packet consumed (response delay 0) |
| 39260 | yapp driver | TX pkt #242 accepted by the DUT |
| 39260 | yapp driver | TX pkt #243: addr=0 len=1 parity=good delay=20 |
| 39315 | **DUT** | OUT ch0 pkt #242 done: 3 bytes in 8 cycles |
| 39315 | ch0 monitor | ch0 RX pkt #242: addr=0 len=1 parity=good |
| 39315 | scoreboard | ch0 pkt matched: addr=0 len=1 (242 matched so far) |
| 39465 | **DUT** | IN  pkt #243 header: addr=0 len=1 -> channel 0 |
| 39475 | **DUT** | OUT ch0 pkt #243 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39485 | **DUT** | IN  pkt #243 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39485 | yapp monitor | RX pkt #243 on the input: addr=0 len=1 parity=good gap=20 |
| 39485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39490 | yapp driver | TX pkt #243 accepted by the DUT |
| 39490 | yapp driver | TX pkt #244: addr=0 len=1 parity=good delay=19 |
| 39495 | **DUT** | OUT ch0 pkt #243 done: 3 bytes in 3 cycles |
| 39495 | ch0 monitor | ch0 RX pkt #243: addr=0 len=1 parity=good |
| 39495 | scoreboard | ch0 pkt matched: addr=0 len=1 (243 matched so far) |
| 39685 | **DUT** | IN  pkt #244 header: addr=0 len=1 -> channel 0 |
| 39695 | **DUT** | OUT ch0 pkt #244 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39705 | **DUT** | IN  pkt #244 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39705 | yapp monitor | RX pkt #244 on the input: addr=0 len=1 parity=good gap=19 |
| 39705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39710 | yapp driver | TX pkt #244 accepted by the DUT |
| 39710 | yapp driver | TX pkt #245: addr=0 len=1 parity=good delay=20 |
| 39715 | **DUT** | OUT ch0 pkt #244 done: 3 bytes in 3 cycles |
| 39715 | ch0 monitor | ch0 RX pkt #244: addr=0 len=1 parity=good |
| 39715 | scoreboard | ch0 pkt matched: addr=0 len=1 (244 matched so far) |
| 39870 | ch0 driver | ch0: packet consumed (response delay 4) |
| 39915 | **DUT** | IN  pkt #245 header: addr=0 len=1 -> channel 0 |
| 39935 | **DUT** | IN  pkt #245 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39935 | yapp monitor | RX pkt #245 on the input: addr=0 len=1 parity=good gap=20 |
| 39935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39940 | yapp driver | TX pkt #245 accepted by the DUT |
| 39940 | yapp driver | TX pkt #246: addr=0 len=1 parity=good delay=20 |
| 39955 | **DUT** | OUT ch0 pkt #245 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 39970 | ch0 driver | ch0: packet consumed (response delay 3) |
| 40065 | **DUT** | OUT ch0 pkt #245 done: 3 bytes in 12 cycles |
| 40065 | ch0 monitor | ch0 RX pkt #245: addr=0 len=1 parity=good |
| 40065 | scoreboard | ch0 pkt matched: addr=0 len=1 (245 matched so far) |
| 40145 | **DUT** | IN  pkt #246 header: addr=0 len=1 -> channel 0 |
| 40155 | **DUT** | OUT ch0 pkt #246 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40165 | **DUT** | IN  pkt #246 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40165 | yapp monitor | RX pkt #246 on the input: addr=0 len=1 parity=good gap=20 |
| 40165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40170 | yapp driver | TX pkt #246 accepted by the DUT |
| 40170 | yapp driver | TX pkt #247: addr=0 len=1 parity=good delay=3 |
| 40175 | **DUT** | OUT ch0 pkt #246 done: 3 bytes in 3 cycles |
| 40175 | ch0 monitor | ch0 RX pkt #246: addr=0 len=1 parity=good |
| 40175 | scoreboard | ch0 pkt matched: addr=0 len=1 (246 matched so far) |
| 40205 | **DUT** | IN  pkt #247 header: addr=0 len=1 -> channel 0 |
| 40215 | **DUT** | OUT ch0 pkt #247 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40225 | **DUT** | IN  pkt #247 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40225 | yapp monitor | RX pkt #247 on the input: addr=0 len=1 parity=good gap=3 |
| 40225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40230 | yapp driver | TX pkt #247 accepted by the DUT |
| 40230 | yapp driver | TX pkt #248: addr=0 len=1 parity=good delay=7 |
| 40235 | **DUT** | OUT ch0 pkt #247 done: 3 bytes in 3 cycles |
| 40235 | ch0 monitor | ch0 RX pkt #247: addr=0 len=1 parity=good |
| 40235 | scoreboard | ch0 pkt matched: addr=0 len=1 (247 matched so far) |
| 40240 | ch0 driver | ch0: packet consumed (response delay 8) |
| 40305 | **DUT** | IN  pkt #248 header: addr=0 len=1 -> channel 0 |
| 40315 | **DUT** | OUT ch0 pkt #248 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40325 | **DUT** | IN  pkt #248 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40325 | yapp monitor | RX pkt #248 on the input: addr=0 len=1 parity=good gap=7 |
| 40325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40330 | ch0 driver | ch0: packet consumed (response delay 0) |
| 40330 | yapp driver | TX pkt #248 accepted by the DUT |
| 40330 | yapp driver | TX pkt #249: addr=0 len=1 parity=good delay=10 |
| 40425 | **DUT** | OUT ch0 pkt #248 done: 3 bytes in 12 cycles |
| 40425 | ch0 monitor | ch0 RX pkt #248: addr=0 len=1 parity=good |
| 40425 | scoreboard | ch0 pkt matched: addr=0 len=1 (248 matched so far) |
| 40435 | **DUT** | IN  pkt #249 header: addr=0 len=1 -> channel 0 |
| 40445 | **DUT** | OUT ch0 pkt #249 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40455 | **DUT** | IN  pkt #249 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40455 | yapp monitor | RX pkt #249 on the input: addr=0 len=1 parity=good gap=10 |
| 40455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40460 | yapp driver | TX pkt #249 accepted by the DUT |
| 40460 | yapp driver | TX pkt #250: addr=0 len=1 parity=good delay=5 |
| 40465 | **DUT** | OUT ch0 pkt #249 done: 3 bytes in 3 cycles |
| 40465 | ch0 monitor | ch0 RX pkt #249: addr=0 len=1 parity=good |
| 40465 | scoreboard | ch0 pkt matched: addr=0 len=1 (249 matched so far) |
| 40515 | **DUT** | IN  pkt #250 header: addr=0 len=1 -> channel 0 |
| 40525 | **DUT** | OUT ch0 pkt #250 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40535 | **DUT** | IN  pkt #250 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40535 | yapp monitor | RX pkt #250 on the input: addr=0 len=1 parity=good gap=5 |
| 40535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40540 | yapp driver | TX pkt #250 accepted by the DUT |
| 40540 | yapp driver | TX pkt #251: addr=0 len=1 parity=good delay=19 |
| 40545 | **DUT** | OUT ch0 pkt #250 done: 3 bytes in 3 cycles |
| 40545 | ch0 monitor | ch0 RX pkt #250: addr=0 len=1 parity=good |
| 40545 | scoreboard | ch0 pkt matched: addr=0 len=1 (250 matched so far) |
| 40620 | ch0 driver | ch0: packet consumed (response delay 8) |
| 40735 | **DUT** | IN  pkt #251 header: addr=0 len=1 -> channel 0 |
| 40755 | **DUT** | IN  pkt #251 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40755 | yapp monitor | RX pkt #251 on the input: addr=0 len=1 parity=good gap=19 |
| 40755 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40760 | yapp driver | TX pkt #251 accepted by the DUT |
| 40760 | yapp driver | TX pkt #252: addr=0 len=1 parity=good delay=20 |
| 40825 | **DUT** | OUT ch0 pkt #251 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 40840 | ch0 driver | ch0: packet consumed (response delay 8) |
| 40955 | **DUT** | OUT ch0 pkt #251 done: 3 bytes in 14 cycles |
| 40955 | ch0 monitor | ch0 RX pkt #251: addr=0 len=1 parity=good |
| 40955 | scoreboard | ch0 pkt matched: addr=0 len=1 (251 matched so far) |
| 40965 | **DUT** | IN  pkt #252 header: addr=0 len=1 -> channel 0 |
| 40975 | **DUT** | OUT ch0 pkt #252 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40985 | **DUT** | IN  pkt #252 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40985 | yapp monitor | RX pkt #252 on the input: addr=0 len=1 parity=good gap=20 |
| 40985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40990 | yapp driver | TX pkt #252 accepted by the DUT |
| 40990 | yapp driver | TX pkt #253: addr=0 len=1 parity=good delay=11 |
| 40995 | **DUT** | OUT ch0 pkt #252 done: 3 bytes in 3 cycles |
| 40995 | ch0 monitor | ch0 RX pkt #252: addr=0 len=1 parity=good |
| 40995 | scoreboard | ch0 pkt matched: addr=0 len=1 (252 matched so far) |
| 41105 | **DUT** | IN  pkt #253 header: addr=0 len=1 -> channel 0 |
| 41115 | **DUT** | OUT ch0 pkt #253 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41125 | **DUT** | IN  pkt #253 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41125 | yapp monitor | RX pkt #253 on the input: addr=0 len=1 parity=good gap=11 |
| 41125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41130 | yapp driver | TX pkt #253 accepted by the DUT |
| 41130 | yapp driver | TX pkt #254: addr=0 len=1 parity=good delay=16 |
| 41135 | **DUT** | OUT ch0 pkt #253 done: 3 bytes in 3 cycles |
| 41135 | ch0 monitor | ch0 RX pkt #253: addr=0 len=1 parity=good |
| 41135 | scoreboard | ch0 pkt matched: addr=0 len=1 (253 matched so far) |
| 41295 | **DUT** | IN  pkt #254 header: addr=0 len=1 -> channel 0 |
| 41305 | **DUT** | OUT ch0 pkt #254 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41315 | **DUT** | IN  pkt #254 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41315 | yapp monitor | RX pkt #254 on the input: addr=0 len=1 parity=good gap=16 |
| 41315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41320 | yapp driver | TX pkt #254 accepted by the DUT |
| 41320 | yapp driver | TX pkt #255: addr=0 len=1 parity=good delay=10 |
| 41325 | **DUT** | OUT ch0 pkt #254 done: 3 bytes in 3 cycles |
| 41325 | ch0 monitor | ch0 RX pkt #254: addr=0 len=1 parity=good |
| 41325 | scoreboard | ch0 pkt matched: addr=0 len=1 (254 matched so far) |
| 41390 | ch0 driver | ch0: packet consumed (response delay 10) |
| 41425 | **DUT** | IN  pkt #255 header: addr=0 len=1 -> channel 0 |
| 41445 | **DUT** | IN  pkt #255 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41445 | yapp monitor | RX pkt #255 on the input: addr=0 len=1 parity=good gap=10 |
| 41445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41450 | yapp driver | TX pkt #255 accepted by the DUT |
| 41515 | **DUT** | OUT ch0 pkt #255 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 41530 | ch0 driver | ch0: packet consumed (response delay 8) |
| 41645 | **DUT** | OUT ch0 pkt #255 done: 3 bytes in 14 cycles |
| 41645 | ch0 monitor | ch0 RX pkt #255: addr=0 len=1 parity=good |
| 41645 | scoreboard | ch0 pkt matched: addr=0 len=1 (255 matched so far) |
| 41670 | hbus driver | Executed READ  addr=0x1009 data=0xff |
| 41670 | **test** | addr0_cnt_reg reads 255 as expected |
| 41670 | **test** | STAGE: 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 41670 | yapp driver | TX pkt #256: addr=0 len=1 parity=good delay=1 |
| 41675 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 41695 | **DUT** | IN  pkt #256 header: addr=0 len=1 -> channel 0 |
| 41705 | **DUT** | OUT ch0 pkt #256 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41715 | **DUT** | IN  pkt #256 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41715 | yapp monitor | RX pkt #256 on the input: addr=0 len=1 parity=good gap=24 |
| 41715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41720 | yapp driver | TX pkt #256 accepted by the DUT |
| 41725 | **DUT** | OUT ch0 pkt #256 done: 3 bytes in 3 cycles |
| 41725 | ch0 monitor | ch0 RX pkt #256: addr=0 len=1 parity=good |
| 41725 | scoreboard | ch0 pkt matched: addr=0 len=1 (256 matched so far) |
| 41750 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 41750 | **test** | addr0_cnt_reg reads 0 as expected |
| 41750 | **test** | STAGE: 3. one more packet: the counter goes on from 0 |
| 41750 | yapp driver | TX pkt #257: addr=0 len=1 parity=good delay=17 |
| 41755 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41935 | **DUT** | IN  pkt #257 header: addr=0 len=1 -> channel 0 |
| 41945 | **DUT** | OUT ch0 pkt #257 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41955 | **DUT** | IN  pkt #257 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41955 | yapp monitor | RX pkt #257 on the input: addr=0 len=1 parity=good gap=21 |
| 41955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41960 | yapp driver | TX pkt #257 accepted by the DUT |
| 41965 | **DUT** | OUT ch0 pkt #257 done: 3 bytes in 3 cycles |
| 41965 | ch0 monitor | ch0 RX pkt #257: addr=0 len=1 parity=good |
| 41965 | scoreboard | ch0 pkt matched: addr=0 len=1 (257 matched so far) |
| 41990 | hbus driver | Executed READ  addr=0x1009 data=0x01 |
| 41990 | **test** | addr0_cnt_reg reads 1 as expected |
| 41990 | **test** | STAGE: 4. the other counters are untouched and the scoreboard matched all 257 packets |
| 41995 | hbus monitor | Collected READ  addr=0x1009 data=0x01 |
| 42020 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 42020 | **test** | addr1_cnt_reg reads 0 as expected |
| 42025 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42050 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 42050 | **test** | addr2_cnt_reg reads 0 as expected |
| 42055 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42080 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 42080 | **test** | addr3_cnt_reg reads 0 as expected |
| 42085 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42110 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 42110 | **test** | parity_err_cnt_reg reads 0 as expected |
| 42115 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42140 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 42140 | **test** | oversized_pkt_cnt_reg reads 0 as expected |
| 42145 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42170 | ch0 driver | ch0: packet consumed (response delay 10) |
| 42340 | ch0 monitor | Channel 0 report: 257 packets collected |
| 42340 | ch1 monitor | Channel 1 report: 0 packets collected |
| 42340 | ch2 monitor | Channel 2 report: 0 packets collected |
| 42340 | hbus monitor | HBUS report: 1 writes, 8 reads |
| 42340 | coverage | Coverage of the router configuration: 26.1% |
| 42340 | reference |  |
| 42340 | scoreboard |  |
| 42340 | yapp driver | YAPP driver report: 257 packets sent |
| 42340 | coverage | YAPP gap coverage: 256 gaps sampled, coverage 75.0% |
| 42340 | yapp monitor | YAPP monitor report: 257 packets collected, 0 with bad parity |
| 42340 | yapp monitor | YAPP gaps: 0 back to back, 10 of 1 cycle, 4 of 2, 242 longer |
| 42340 | coverage | YAPP packet coverage: 257 packets sampled, coverage 13.3% |
