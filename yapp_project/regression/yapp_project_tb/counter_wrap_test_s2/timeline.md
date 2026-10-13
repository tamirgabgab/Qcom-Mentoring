# counter_wrap_test  seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 42us · log `counter_wrap_test_s2.log`

Waves: `counter_wrap_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fcounter_wrap_test_s2%2Fcounter_wrap_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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
| 41140 | 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 41460 | 3. one more packet: the counter goes on from 0 |
| 41710 | 4. the other counters are untouched and the scoreboard matched all 257 packets |

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
| 70 | yapp driver | TX pkt #1: addr=0 len=1 parity=good delay=20 |
| 75 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 75 | reference | router_en is now 1 (en_reg 0xff) |
| 285 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> channel 0 |
| 295 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 305 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 305 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=good gap=23 |
| 305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 310 | ch0 driver | ch0: packet consumed (response delay 0) |
| 310 | yapp driver | TX pkt #1 accepted by the DUT |
| 310 | yapp driver | TX pkt #2: addr=0 len=1 parity=good delay=11 |
| 395 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 11 cycles |
| 395 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 395 | scoreboard | ch0 pkt matched: addr=0 len=1 (1 matched so far) |
| 425 | **DUT** | IN  pkt #2 header: addr=0 len=1 -> channel 0 |
| 435 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 445 | **DUT** | IN  pkt #2 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 445 | yapp monitor | RX pkt #2 on the input: addr=0 len=1 parity=good gap=11 |
| 445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 450 | yapp driver | TX pkt #2 accepted by the DUT |
| 450 | yapp driver | TX pkt #3: addr=0 len=1 parity=good delay=8 |
| 455 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 3 cycles |
| 455 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=good |
| 455 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 535 | **DUT** | IN  pkt #3 header: addr=0 len=1 -> channel 0 |
| 545 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 555 | **DUT** | IN  pkt #3 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 555 | yapp monitor | RX pkt #3 on the input: addr=0 len=1 parity=good gap=8 |
| 555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 560 | yapp driver | TX pkt #3 accepted by the DUT |
| 560 | yapp driver | TX pkt #4: addr=0 len=1 parity=good delay=20 |
| 565 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 565 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 565 | scoreboard | ch0 pkt matched: addr=0 len=1 (3 matched so far) |
| 660 | ch0 driver | ch0: packet consumed (response delay 7) |
| 765 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> channel 0 |
| 785 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 785 | yapp monitor | RX pkt #4 on the input: addr=0 len=1 parity=good gap=20 |
| 785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 790 | yapp driver | TX pkt #4 accepted by the DUT |
| 790 | yapp driver | TX pkt #5: addr=0 len=1 parity=good delay=16 |
| 825 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 840 | ch0 driver | ch0: packet consumed (response delay 5) |
| 955 | **DUT** | IN  pkt #5 header: addr=0 len=1 -> channel 0 |
| 955 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 14 cycles |
| 955 | ch0 monitor | ch0 RX pkt #4: addr=0 len=1 parity=good |
| 955 | scoreboard | ch0 pkt matched: addr=0 len=1 (4 matched so far) |
| 965 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 975 | **DUT** | IN  pkt #5 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 975 | yapp monitor | RX pkt #5 on the input: addr=0 len=1 parity=good gap=16 |
| 975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 980 | yapp driver | TX pkt #5 accepted by the DUT |
| 980 | yapp driver | TX pkt #6: addr=0 len=1 parity=good delay=14 |
| 985 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 3 cycles |
| 985 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 985 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 1125 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> channel 0 |
| 1135 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1145 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1145 | yapp monitor | RX pkt #6 on the input: addr=0 len=1 parity=good gap=14 |
| 1145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1150 | yapp driver | TX pkt #6 accepted by the DUT |
| 1150 | yapp driver | TX pkt #7: addr=0 len=1 parity=good delay=16 |
| 1155 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 1155 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=good |
| 1155 | scoreboard | ch0 pkt matched: addr=0 len=1 (6 matched so far) |
| 1315 | **DUT** | IN  pkt #7 header: addr=0 len=1 -> channel 0 |
| 1325 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1335 | **DUT** | IN  pkt #7 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1335 | yapp monitor | RX pkt #7 on the input: addr=0 len=1 parity=good gap=16 |
| 1335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1340 | yapp driver | TX pkt #7 accepted by the DUT |
| 1340 | yapp driver | TX pkt #8: addr=0 len=1 parity=good delay=20 |
| 1345 | **DUT** | OUT ch0 pkt #7 done: 3 bytes in 3 cycles |
| 1345 | ch0 monitor | ch0 RX pkt #7: addr=0 len=1 parity=good |
| 1345 | scoreboard | ch0 pkt matched: addr=0 len=1 (7 matched so far) |
| 1460 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1545 | **DUT** | IN  pkt #8 header: addr=0 len=1 -> channel 0 |
| 1565 | **DUT** | IN  pkt #8 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1565 | yapp monitor | RX pkt #8 on the input: addr=0 len=1 parity=good gap=20 |
| 1565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1570 | yapp driver | TX pkt #8 accepted by the DUT |
| 1570 | yapp driver | TX pkt #9: addr=0 len=1 parity=good delay=15 |
| 1575 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 1590 | ch0 driver | ch0: packet consumed (response delay 2) |
| 1705 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 14 cycles |
| 1705 | ch0 monitor | ch0 RX pkt #8: addr=0 len=1 parity=good |
| 1705 | scoreboard | ch0 pkt matched: addr=0 len=1 (8 matched so far) |
| 1725 | **DUT** | IN  pkt #9 header: addr=0 len=1 -> channel 0 |
| 1735 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1745 | **DUT** | IN  pkt #9 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1745 | yapp monitor | RX pkt #9 on the input: addr=0 len=1 parity=good gap=15 |
| 1745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1750 | yapp driver | TX pkt #9 accepted by the DUT |
| 1750 | yapp driver | TX pkt #10: addr=0 len=1 parity=good delay=18 |
| 1755 | **DUT** | OUT ch0 pkt #9 done: 3 bytes in 3 cycles |
| 1755 | ch0 monitor | ch0 RX pkt #9: addr=0 len=1 parity=good |
| 1755 | scoreboard | ch0 pkt matched: addr=0 len=1 (9 matched so far) |
| 1935 | **DUT** | IN  pkt #10 header: addr=0 len=1 -> channel 0 |
| 1945 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1955 | **DUT** | IN  pkt #10 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1955 | yapp monitor | RX pkt #10 on the input: addr=0 len=1 parity=good gap=18 |
| 1955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1960 | yapp driver | TX pkt #10 accepted by the DUT |
| 1960 | yapp driver | TX pkt #11: addr=0 len=1 parity=good delay=20 |
| 1965 | **DUT** | OUT ch0 pkt #10 done: 3 bytes in 3 cycles |
| 1965 | ch0 monitor | ch0 RX pkt #10: addr=0 len=1 parity=good |
| 1965 | scoreboard | ch0 pkt matched: addr=0 len=1 (10 matched so far) |
| 2120 | ch0 driver | ch0: packet consumed (response delay 10) |
| 2165 | **DUT** | IN  pkt #11 header: addr=0 len=1 -> channel 0 |
| 2185 | **DUT** | IN  pkt #11 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2185 | yapp monitor | RX pkt #11 on the input: addr=0 len=1 parity=good gap=20 |
| 2185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2190 | yapp driver | TX pkt #11 accepted by the DUT |
| 2190 | yapp driver | TX pkt #12: addr=0 len=1 parity=good delay=16 |
| 2275 | **DUT** | OUT ch0 pkt #11 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 2290 | ch0 driver | ch0: packet consumed (response delay 10) |
| 2355 | **DUT** | IN  pkt #12 header: addr=0 len=1 -> channel 0 |
| 2375 | **DUT** | IN  pkt #12 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2375 | yapp monitor | RX pkt #12 on the input: addr=0 len=1 parity=good gap=16 |
| 2375 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2380 | yapp driver | TX pkt #12 accepted by the DUT |
| 2380 | yapp driver | TX pkt #13: addr=0 len=1 parity=good delay=20 |
| 2395 | **DUT** | OUT ch0 pkt #11 done: 3 bytes in 13 cycles |
| 2395 | ch0 monitor | ch0 RX pkt #11: addr=0 len=1 parity=good |
| 2395 | scoreboard | ch0 pkt matched: addr=0 len=1 (11 matched so far) |
| 2405 | **DUT** | OUT ch0 pkt #12 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2425 | **DUT** | OUT ch0 pkt #12 done: 3 bytes in 3 cycles |
| 2425 | ch0 monitor | ch0 RX pkt #12: addr=0 len=1 parity=good |
| 2425 | scoreboard | ch0 pkt matched: addr=0 len=1 (12 matched so far) |
| 2585 | **DUT** | IN  pkt #13 header: addr=0 len=1 -> channel 0 |
| 2595 | **DUT** | OUT ch0 pkt #13 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2605 | **DUT** | IN  pkt #13 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2605 | yapp monitor | RX pkt #13 on the input: addr=0 len=1 parity=good gap=20 |
| 2605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2610 | yapp driver | TX pkt #13 accepted by the DUT |
| 2610 | yapp driver | TX pkt #14: addr=0 len=1 parity=good delay=20 |
| 2615 | **DUT** | OUT ch0 pkt #13 done: 3 bytes in 3 cycles |
| 2615 | ch0 monitor | ch0 RX pkt #13: addr=0 len=1 parity=good |
| 2615 | scoreboard | ch0 pkt matched: addr=0 len=1 (13 matched so far) |
| 2815 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> channel 0 |
| 2825 | **DUT** | OUT ch0 pkt #14 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2835 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2835 | yapp monitor | RX pkt #14 on the input: addr=0 len=1 parity=good gap=20 |
| 2835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2840 | yapp driver | TX pkt #14 accepted by the DUT |
| 2840 | yapp driver | TX pkt #15: addr=0 len=1 parity=good delay=20 |
| 2845 | **DUT** | OUT ch0 pkt #14 done: 3 bytes in 3 cycles |
| 2845 | ch0 monitor | ch0 RX pkt #14: addr=0 len=1 parity=good |
| 2845 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 2920 | ch0 driver | ch0: packet consumed (response delay 9) |
| 3045 | **DUT** | IN  pkt #15 header: addr=0 len=1 -> channel 0 |
| 3065 | **DUT** | IN  pkt #15 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3065 | yapp monitor | RX pkt #15 on the input: addr=0 len=1 parity=good gap=20 |
| 3065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3070 | yapp driver | TX pkt #15 accepted by the DUT |
| 3070 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=20 |
| 3145 | **DUT** | OUT ch0 pkt #15 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 3160 | ch0 driver | ch0: packet consumed (response delay 9) |
| 3265 | **DUT** | OUT ch0 pkt #15 done: 3 bytes in 13 cycles |
| 3265 | ch0 monitor | ch0 RX pkt #15: addr=0 len=1 parity=good |
| 3265 | scoreboard | ch0 pkt matched: addr=0 len=1 (15 matched so far) |
| 3275 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 3285 | **DUT** | OUT ch0 pkt #16 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3295 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3295 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=20 |
| 3295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3300 | yapp driver | TX pkt #16 accepted by the DUT |
| 3300 | yapp driver | TX pkt #17: addr=0 len=1 parity=good delay=20 |
| 3305 | **DUT** | OUT ch0 pkt #16 done: 3 bytes in 3 cycles |
| 3305 | ch0 monitor | ch0 RX pkt #16: addr=0 len=1 parity=good |
| 3305 | scoreboard | ch0 pkt matched: addr=0 len=1 (16 matched so far) |
| 3400 | ch0 driver | ch0: packet consumed (response delay 9) |
| 3505 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 3525 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3525 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=good gap=20 |
| 3525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3530 | yapp driver | TX pkt #17 accepted by the DUT |
| 3530 | yapp driver | TX pkt #18: addr=0 len=1 parity=good delay=18 |
| 3615 | **DUT** | OUT ch0 pkt #17 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 3630 | ch0 driver | ch0: packet consumed (response delay 10) |
| 3685 | **DUT** | OUT ch0 pkt #17 done: 3 bytes in 8 cycles |
| 3685 | ch0 monitor | ch0 RX pkt #17: addr=0 len=1 parity=good |
| 3685 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 3715 | **DUT** | IN  pkt #18 header: addr=0 len=1 -> channel 0 |
| 3725 | **DUT** | OUT ch0 pkt #18 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3735 | **DUT** | IN  pkt #18 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3735 | yapp monitor | RX pkt #18 on the input: addr=0 len=1 parity=good gap=18 |
| 3735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3740 | yapp driver | TX pkt #18 accepted by the DUT |
| 3740 | yapp driver | TX pkt #19: addr=0 len=1 parity=good delay=3 |
| 3745 | **DUT** | OUT ch0 pkt #18 done: 3 bytes in 3 cycles |
| 3745 | ch0 monitor | ch0 RX pkt #18: addr=0 len=1 parity=good |
| 3745 | scoreboard | ch0 pkt matched: addr=0 len=1 (18 matched so far) |
| 3775 | **DUT** | IN  pkt #19 header: addr=0 len=1 -> channel 0 |
| 3785 | **DUT** | OUT ch0 pkt #19 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3795 | **DUT** | IN  pkt #19 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3795 | yapp monitor | RX pkt #19 on the input: addr=0 len=1 parity=good gap=3 |
| 3795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3800 | yapp driver | TX pkt #19 accepted by the DUT |
| 3800 | yapp driver | TX pkt #20: addr=0 len=1 parity=good delay=3 |
| 3805 | **DUT** | OUT ch0 pkt #19 done: 3 bytes in 3 cycles |
| 3805 | ch0 monitor | ch0 RX pkt #19: addr=0 len=1 parity=good |
| 3805 | scoreboard | ch0 pkt matched: addr=0 len=1 (19 matched so far) |
| 3835 | **DUT** | IN  pkt #20 header: addr=0 len=1 -> channel 0 |
| 3845 | **DUT** | OUT ch0 pkt #20 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3855 | **DUT** | IN  pkt #20 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3855 | yapp monitor | RX pkt #20 on the input: addr=0 len=1 parity=good gap=3 |
| 3855 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3860 | yapp driver | TX pkt #20 accepted by the DUT |
| 3860 | yapp driver | TX pkt #21: addr=0 len=1 parity=good delay=12 |
| 3865 | **DUT** | OUT ch0 pkt #20 done: 3 bytes in 3 cycles |
| 3865 | ch0 monitor | ch0 RX pkt #20: addr=0 len=1 parity=good |
| 3865 | scoreboard | ch0 pkt matched: addr=0 len=1 (20 matched so far) |
| 3985 | **DUT** | IN  pkt #21 header: addr=0 len=1 -> channel 0 |
| 3995 | **DUT** | OUT ch0 pkt #21 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4005 | **DUT** | IN  pkt #21 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4005 | yapp monitor | RX pkt #21 on the input: addr=0 len=1 parity=good gap=12 |
| 4005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4010 | yapp driver | TX pkt #21 accepted by the DUT |
| 4010 | yapp driver | TX pkt #22: addr=0 len=1 parity=good delay=12 |
| 4015 | **DUT** | OUT ch0 pkt #21 done: 3 bytes in 3 cycles |
| 4015 | ch0 monitor | ch0 RX pkt #21: addr=0 len=1 parity=good |
| 4015 | scoreboard | ch0 pkt matched: addr=0 len=1 (21 matched so far) |
| 4070 | ch0 driver | ch0: packet consumed (response delay 4) |
| 4135 | **DUT** | IN  pkt #22 header: addr=0 len=1 -> channel 0 |
| 4145 | **DUT** | OUT ch0 pkt #22 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4155 | **DUT** | IN  pkt #22 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4155 | yapp monitor | RX pkt #22 on the input: addr=0 len=1 parity=good gap=12 |
| 4155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4160 | ch0 driver | ch0: packet consumed (response delay 0) |
| 4160 | yapp driver | TX pkt #22 accepted by the DUT |
| 4160 | yapp driver | TX pkt #23: addr=0 len=1 parity=good delay=20 |
| 4255 | **DUT** | OUT ch0 pkt #22 done: 3 bytes in 12 cycles |
| 4255 | ch0 monitor | ch0 RX pkt #22: addr=0 len=1 parity=good |
| 4255 | scoreboard | ch0 pkt matched: addr=0 len=1 (22 matched so far) |
| 4365 | **DUT** | IN  pkt #23 header: addr=0 len=1 -> channel 0 |
| 4375 | **DUT** | OUT ch0 pkt #23 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4385 | **DUT** | IN  pkt #23 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4385 | yapp monitor | RX pkt #23 on the input: addr=0 len=1 parity=good gap=20 |
| 4385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4390 | yapp driver | TX pkt #23 accepted by the DUT |
| 4390 | yapp driver | TX pkt #24: addr=0 len=1 parity=good delay=3 |
| 4395 | **DUT** | OUT ch0 pkt #23 done: 3 bytes in 3 cycles |
| 4395 | ch0 monitor | ch0 RX pkt #23: addr=0 len=1 parity=good |
| 4395 | scoreboard | ch0 pkt matched: addr=0 len=1 (23 matched so far) |
| 4425 | **DUT** | IN  pkt #24 header: addr=0 len=1 -> channel 0 |
| 4435 | **DUT** | OUT ch0 pkt #24 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4445 | **DUT** | IN  pkt #24 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4445 | yapp monitor | RX pkt #24 on the input: addr=0 len=1 parity=good gap=3 |
| 4445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4450 | yapp driver | TX pkt #24 accepted by the DUT |
| 4450 | yapp driver | TX pkt #25: addr=0 len=1 parity=good delay=5 |
| 4455 | **DUT** | OUT ch0 pkt #24 done: 3 bytes in 3 cycles |
| 4455 | ch0 monitor | ch0 RX pkt #24: addr=0 len=1 parity=good |
| 4455 | scoreboard | ch0 pkt matched: addr=0 len=1 (24 matched so far) |
| 4505 | **DUT** | IN  pkt #25 header: addr=0 len=1 -> channel 0 |
| 4515 | **DUT** | OUT ch0 pkt #25 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4525 | **DUT** | IN  pkt #25 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4525 | yapp monitor | RX pkt #25 on the input: addr=0 len=1 parity=good gap=5 |
| 4525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4530 | yapp driver | TX pkt #25 accepted by the DUT |
| 4530 | yapp driver | TX pkt #26: addr=0 len=1 parity=good delay=3 |
| 4535 | **DUT** | OUT ch0 pkt #25 done: 3 bytes in 3 cycles |
| 4535 | ch0 monitor | ch0 RX pkt #25: addr=0 len=1 parity=good |
| 4535 | scoreboard | ch0 pkt matched: addr=0 len=1 (25 matched so far) |
| 4565 | **DUT** | IN  pkt #26 header: addr=0 len=1 -> channel 0 |
| 4575 | **DUT** | OUT ch0 pkt #26 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4585 | **DUT** | IN  pkt #26 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4585 | yapp monitor | RX pkt #26 on the input: addr=0 len=1 parity=good gap=3 |
| 4585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4590 | yapp driver | TX pkt #26 accepted by the DUT |
| 4590 | yapp driver | TX pkt #27: addr=0 len=1 parity=good delay=1 |
| 4595 | **DUT** | OUT ch0 pkt #26 done: 3 bytes in 3 cycles |
| 4595 | ch0 monitor | ch0 RX pkt #26: addr=0 len=1 parity=good |
| 4595 | scoreboard | ch0 pkt matched: addr=0 len=1 (26 matched so far) |
| 4605 | **DUT** | IN  pkt #27 header: addr=0 len=1 -> channel 0 |
| 4615 | **DUT** | OUT ch0 pkt #27 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4625 | **DUT** | IN  pkt #27 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4625 | yapp monitor | RX pkt #27 on the input: addr=0 len=1 parity=good gap=1 |
| 4625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4630 | yapp driver | TX pkt #27 accepted by the DUT |
| 4630 | yapp driver | TX pkt #28: addr=0 len=1 parity=good delay=8 |
| 4635 | **DUT** | OUT ch0 pkt #27 done: 3 bytes in 3 cycles |
| 4635 | ch0 monitor | ch0 RX pkt #27: addr=0 len=1 parity=good |
| 4635 | scoreboard | ch0 pkt matched: addr=0 len=1 (27 matched so far) |
| 4715 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 4725 | **DUT** | OUT ch0 pkt #28 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4735 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4735 | yapp monitor | RX pkt #28 on the input: addr=0 len=1 parity=good gap=8 |
| 4735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4740 | yapp driver | TX pkt #28 accepted by the DUT |
| 4740 | yapp driver | TX pkt #29: addr=0 len=1 parity=good delay=1 |
| 4745 | **DUT** | OUT ch0 pkt #28 done: 3 bytes in 3 cycles |
| 4745 | ch0 monitor | ch0 RX pkt #28: addr=0 len=1 parity=good |
| 4745 | scoreboard | ch0 pkt matched: addr=0 len=1 (28 matched so far) |
| 4755 | **DUT** | IN  pkt #29 header: addr=0 len=1 -> channel 0 |
| 4765 | **DUT** | OUT ch0 pkt #29 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4775 | **DUT** | IN  pkt #29 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4775 | yapp monitor | RX pkt #29 on the input: addr=0 len=1 parity=good gap=1 |
| 4775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4780 | yapp driver | TX pkt #29 accepted by the DUT |
| 4780 | yapp driver | TX pkt #30: addr=0 len=1 parity=good delay=12 |
| 4785 | **DUT** | OUT ch0 pkt #29 done: 3 bytes in 3 cycles |
| 4785 | ch0 monitor | ch0 RX pkt #29: addr=0 len=1 parity=good |
| 4785 | scoreboard | ch0 pkt matched: addr=0 len=1 (29 matched so far) |
| 4840 | ch0 driver | ch0: packet consumed (response delay 8) |
| 4905 | **DUT** | IN  pkt #30 header: addr=0 len=1 -> channel 0 |
| 4925 | **DUT** | IN  pkt #30 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4925 | **DUT** | OUT ch0 pkt #30 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 4925 | yapp monitor | RX pkt #30 on the input: addr=0 len=1 parity=good gap=12 |
| 4925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4930 | yapp driver | TX pkt #30 accepted by the DUT |
| 4930 | yapp driver | TX pkt #31: addr=0 len=1 parity=good delay=17 |
| 4940 | ch0 driver | ch0: packet consumed (response delay 1) |
| 4955 | **DUT** | OUT ch0 pkt #30 done: 3 bytes in 4 cycles |
| 4955 | ch0 monitor | ch0 RX pkt #30: addr=0 len=1 parity=good |
| 4955 | scoreboard | ch0 pkt matched: addr=0 len=1 (30 matched so far) |
| 5105 | **DUT** | IN  pkt #31 header: addr=0 len=1 -> channel 0 |
| 5115 | **DUT** | OUT ch0 pkt #31 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5125 | **DUT** | IN  pkt #31 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5125 | yapp monitor | RX pkt #31 on the input: addr=0 len=1 parity=good gap=17 |
| 5125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5130 | yapp driver | TX pkt #31 accepted by the DUT |
| 5130 | yapp driver | TX pkt #32: addr=0 len=1 parity=good delay=19 |
| 5135 | **DUT** | OUT ch0 pkt #31 done: 3 bytes in 3 cycles |
| 5135 | ch0 monitor | ch0 RX pkt #31: addr=0 len=1 parity=good |
| 5135 | scoreboard | ch0 pkt matched: addr=0 len=1 (31 matched so far) |
| 5325 | **DUT** | IN  pkt #32 header: addr=0 len=1 -> channel 0 |
| 5335 | **DUT** | OUT ch0 pkt #32 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5340 | ch0 driver | ch0: packet consumed (response delay 0) |
| 5345 | **DUT** | IN  pkt #32 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5345 | yapp monitor | RX pkt #32 on the input: addr=0 len=1 parity=good gap=19 |
| 5345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5350 | yapp driver | TX pkt #32 accepted by the DUT |
| 5350 | yapp driver | TX pkt #33: addr=0 len=1 parity=good delay=1 |
| 5365 | **DUT** | IN  pkt #33 header: addr=0 len=1 -> channel 0 |
| 5385 | **DUT** | IN  pkt #33 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5385 | yapp monitor | RX pkt #33 on the input: addr=0 len=1 parity=good gap=1 |
| 5385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5390 | yapp driver | TX pkt #33 accepted by the DUT |
| 5390 | yapp driver | TX pkt #34: addr=0 len=1 parity=good delay=4 |
| 5435 | **DUT** | IN  pkt #34 header: addr=0 len=1 -> channel 0 |
| 5455 | **DUT** | IN  pkt #34 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5455 | yapp monitor | RX pkt #34 on the input: addr=0 len=1 parity=good gap=4 |
| 5455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5460 | yapp driver | TX pkt #34 accepted by the DUT |
| 5460 | yapp driver | TX pkt #35: addr=0 len=1 parity=good delay=13 |
| 5465 | **DUT** | OUT ch0 pkt #32 done: 3 bytes in 14 cycles |
| 5465 | ch0 monitor | ch0 RX pkt #32: addr=0 len=1 parity=good |
| 5465 | scoreboard | ch0 pkt matched: addr=0 len=1 (32 matched so far) |
| 5475 | **DUT** | OUT ch0 pkt #33 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5495 | **DUT** | OUT ch0 pkt #33 done: 3 bytes in 3 cycles |
| 5495 | ch0 monitor | ch0 RX pkt #33: addr=0 len=1 parity=good |
| 5495 | scoreboard | ch0 pkt matched: addr=0 len=1 (33 matched so far) |
| 5505 | **DUT** | OUT ch0 pkt #34 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5525 | **DUT** | OUT ch0 pkt #34 done: 3 bytes in 3 cycles |
| 5525 | ch0 monitor | ch0 RX pkt #34: addr=0 len=1 parity=good |
| 5525 | scoreboard | ch0 pkt matched: addr=0 len=1 (34 matched so far) |
| 5540 | ch0 driver | ch0: packet consumed (response delay 10) |
| 5595 | **DUT** | IN  pkt #35 header: addr=0 len=1 -> channel 0 |
| 5615 | **DUT** | IN  pkt #35 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5615 | yapp monitor | RX pkt #35 on the input: addr=0 len=1 parity=good gap=13 |
| 5615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5620 | yapp driver | TX pkt #35 accepted by the DUT |
| 5620 | yapp driver | TX pkt #36: addr=0 len=1 parity=good delay=15 |
| 5685 | **DUT** | OUT ch0 pkt #35 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 5700 | ch0 driver | ch0: packet consumed (response delay 8) |
| 5775 | **DUT** | IN  pkt #36 header: addr=0 len=1 -> channel 0 |
| 5795 | **DUT** | IN  pkt #36 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5795 | yapp monitor | RX pkt #36 on the input: addr=0 len=1 parity=good gap=15 |
| 5795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5800 | yapp driver | TX pkt #36 accepted by the DUT |
| 5800 | yapp driver | TX pkt #37: addr=0 len=1 parity=good delay=20 |
| 5815 | **DUT** | OUT ch0 pkt #35 done: 3 bytes in 14 cycles |
| 5815 | ch0 monitor | ch0 RX pkt #35: addr=0 len=1 parity=good |
| 5815 | scoreboard | ch0 pkt matched: addr=0 len=1 (35 matched so far) |
| 5825 | **DUT** | OUT ch0 pkt #36 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5845 | **DUT** | OUT ch0 pkt #36 done: 3 bytes in 3 cycles |
| 5845 | ch0 monitor | ch0 RX pkt #36: addr=0 len=1 parity=good |
| 5845 | scoreboard | ch0 pkt matched: addr=0 len=1 (36 matched so far) |
| 5900 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6005 | **DUT** | IN  pkt #37 header: addr=0 len=1 -> channel 0 |
| 6025 | **DUT** | IN  pkt #37 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6025 | yapp monitor | RX pkt #37 on the input: addr=0 len=1 parity=good gap=20 |
| 6025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6030 | yapp driver | TX pkt #37 accepted by the DUT |
| 6030 | yapp driver | TX pkt #38: addr=0 len=1 parity=good delay=3 |
| 6065 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 6085 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6085 | yapp monitor | RX pkt #38 on the input: addr=0 len=1 parity=good gap=3 |
| 6085 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6090 | yapp driver | TX pkt #38 accepted by the DUT |
| 6090 | yapp driver | TX pkt #39: addr=0 len=1 parity=good delay=18 |
| 6105 | **DUT** | OUT ch0 pkt #37 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 6120 | ch0 driver | ch0: packet consumed (response delay 9) |
| 6205 | **DUT** | OUT ch0 pkt #37 done: 3 bytes in 11 cycles |
| 6205 | ch0 monitor | ch0 RX pkt #37: addr=0 len=1 parity=good |
| 6205 | scoreboard | ch0 pkt matched: addr=0 len=1 (37 matched so far) |
| 6215 | **DUT** | OUT ch0 pkt #38 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6235 | **DUT** | OUT ch0 pkt #38 done: 3 bytes in 3 cycles |
| 6235 | ch0 monitor | ch0 RX pkt #38: addr=0 len=1 parity=good |
| 6235 | scoreboard | ch0 pkt matched: addr=0 len=1 (38 matched so far) |
| 6275 | **DUT** | IN  pkt #39 header: addr=0 len=1 -> channel 0 |
| 6285 | **DUT** | OUT ch0 pkt #39 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6295 | **DUT** | IN  pkt #39 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6295 | yapp monitor | RX pkt #39 on the input: addr=0 len=1 parity=good gap=18 |
| 6295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6300 | yapp driver | TX pkt #39 accepted by the DUT |
| 6300 | yapp driver | TX pkt #40: addr=0 len=1 parity=good delay=17 |
| 6305 | **DUT** | OUT ch0 pkt #39 done: 3 bytes in 3 cycles |
| 6305 | ch0 monitor | ch0 RX pkt #39: addr=0 len=1 parity=good |
| 6305 | scoreboard | ch0 pkt matched: addr=0 len=1 (39 matched so far) |
| 6475 | **DUT** | IN  pkt #40 header: addr=0 len=1 -> channel 0 |
| 6485 | **DUT** | OUT ch0 pkt #40 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6495 | **DUT** | IN  pkt #40 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6495 | yapp monitor | RX pkt #40 on the input: addr=0 len=1 parity=good gap=17 |
| 6495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6500 | yapp driver | TX pkt #40 accepted by the DUT |
| 6500 | yapp driver | TX pkt #41: addr=0 len=1 parity=good delay=20 |
| 6505 | **DUT** | OUT ch0 pkt #40 done: 3 bytes in 3 cycles |
| 6505 | ch0 monitor | ch0 RX pkt #40: addr=0 len=1 parity=good |
| 6505 | scoreboard | ch0 pkt matched: addr=0 len=1 (40 matched so far) |
| 6570 | ch0 driver | ch0: packet consumed (response delay 7) |
| 6705 | **DUT** | IN  pkt #41 header: addr=0 len=1 -> channel 0 |
| 6725 | **DUT** | IN  pkt #41 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6725 | yapp monitor | RX pkt #41 on the input: addr=0 len=1 parity=good gap=20 |
| 6725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6730 | yapp driver | TX pkt #41 accepted by the DUT |
| 6730 | yapp driver | TX pkt #42: addr=0 len=1 parity=good delay=18 |
| 6775 | **DUT** | OUT ch0 pkt #41 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 6790 | ch0 driver | ch0: packet consumed (response delay 6) |
| 6815 | **DUT** | OUT ch0 pkt #41 done: 3 bytes in 5 cycles |
| 6815 | ch0 monitor | ch0 RX pkt #41: addr=0 len=1 parity=good |
| 6815 | scoreboard | ch0 pkt matched: addr=0 len=1 (41 matched so far) |
| 6915 | **DUT** | IN  pkt #42 header: addr=0 len=1 -> channel 0 |
| 6925 | **DUT** | OUT ch0 pkt #42 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6935 | **DUT** | IN  pkt #42 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6935 | yapp monitor | RX pkt #42 on the input: addr=0 len=1 parity=good gap=18 |
| 6935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6940 | yapp driver | TX pkt #42 accepted by the DUT |
| 6940 | yapp driver | TX pkt #43: addr=0 len=1 parity=good delay=8 |
| 6945 | **DUT** | OUT ch0 pkt #42 done: 3 bytes in 3 cycles |
| 6945 | ch0 monitor | ch0 RX pkt #42: addr=0 len=1 parity=good |
| 6945 | scoreboard | ch0 pkt matched: addr=0 len=1 (42 matched so far) |
| 7010 | ch0 driver | ch0: packet consumed (response delay 1) |
| 7025 | **DUT** | IN  pkt #43 header: addr=0 len=1 -> channel 0 |
| 7045 | **DUT** | IN  pkt #43 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7045 | yapp monitor | RX pkt #43 on the input: addr=0 len=1 parity=good gap=8 |
| 7045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7050 | yapp driver | TX pkt #43 accepted by the DUT |
| 7050 | yapp driver | TX pkt #44: addr=0 len=1 parity=good delay=7 |
| 7125 | **DUT** | IN  pkt #44 header: addr=0 len=1 -> channel 0 |
| 7125 | **DUT** | OUT ch0 pkt #43 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 7140 | ch0 driver | ch0: packet consumed (response delay 9) |
| 7145 | **DUT** | IN  pkt #44 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7145 | yapp monitor | RX pkt #44 on the input: addr=0 len=1 parity=good gap=7 |
| 7145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7150 | yapp driver | TX pkt #44 accepted by the DUT |
| 7150 | yapp driver | TX pkt #45: addr=0 len=1 parity=good delay=17 |
| 7235 | **DUT** | OUT ch0 pkt #43 done: 3 bytes in 12 cycles |
| 7235 | ch0 monitor | ch0 RX pkt #43: addr=0 len=1 parity=good |
| 7235 | scoreboard | ch0 pkt matched: addr=0 len=1 (43 matched so far) |
| 7245 | **DUT** | OUT ch0 pkt #44 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7265 | **DUT** | OUT ch0 pkt #44 done: 3 bytes in 3 cycles |
| 7265 | ch0 monitor | ch0 RX pkt #44: addr=0 len=1 parity=good |
| 7265 | scoreboard | ch0 pkt matched: addr=0 len=1 (44 matched so far) |
| 7325 | **DUT** | IN  pkt #45 header: addr=0 len=1 -> channel 0 |
| 7335 | **DUT** | OUT ch0 pkt #45 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7345 | **DUT** | IN  pkt #45 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7345 | yapp monitor | RX pkt #45 on the input: addr=0 len=1 parity=good gap=17 |
| 7345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7350 | yapp driver | TX pkt #45 accepted by the DUT |
| 7350 | yapp driver | TX pkt #46: addr=0 len=1 parity=good delay=16 |
| 7355 | **DUT** | OUT ch0 pkt #45 done: 3 bytes in 3 cycles |
| 7355 | ch0 monitor | ch0 RX pkt #45: addr=0 len=1 parity=good |
| 7355 | scoreboard | ch0 pkt matched: addr=0 len=1 (45 matched so far) |
| 7515 | **DUT** | IN  pkt #46 header: addr=0 len=1 -> channel 0 |
| 7520 | ch0 driver | ch0: packet consumed (response delay 8) |
| 7535 | **DUT** | IN  pkt #46 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7535 | yapp monitor | RX pkt #46 on the input: addr=0 len=1 parity=good gap=16 |
| 7535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7540 | yapp driver | TX pkt #46 accepted by the DUT |
| 7540 | yapp driver | TX pkt #47: addr=0 len=1 parity=good delay=20 |
| 7625 | **DUT** | OUT ch0 pkt #46 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 7640 | ch0 driver | ch0: packet consumed (response delay 9) |
| 7745 | **DUT** | IN  pkt #47 header: addr=0 len=1 -> channel 0 |
| 7755 | **DUT** | OUT ch0 pkt #46 done: 3 bytes in 14 cycles |
| 7755 | ch0 monitor | ch0 RX pkt #46: addr=0 len=1 parity=good |
| 7755 | scoreboard | ch0 pkt matched: addr=0 len=1 (46 matched so far) |
| 7765 | **DUT** | IN  pkt #47 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7765 | **DUT** | OUT ch0 pkt #47 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7765 | yapp monitor | RX pkt #47 on the input: addr=0 len=1 parity=good gap=20 |
| 7765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7770 | yapp driver | TX pkt #47 accepted by the DUT |
| 7770 | yapp driver | TX pkt #48: addr=0 len=1 parity=good delay=2 |
| 7785 | **DUT** | OUT ch0 pkt #47 done: 3 bytes in 3 cycles |
| 7785 | ch0 monitor | ch0 RX pkt #47: addr=0 len=1 parity=good |
| 7785 | scoreboard | ch0 pkt matched: addr=0 len=1 (47 matched so far) |
| 7795 | **DUT** | IN  pkt #48 header: addr=0 len=1 -> channel 0 |
| 7805 | **DUT** | OUT ch0 pkt #48 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7815 | **DUT** | IN  pkt #48 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7815 | yapp monitor | RX pkt #48 on the input: addr=0 len=1 parity=good gap=2 |
| 7815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7820 | yapp driver | TX pkt #48 accepted by the DUT |
| 7820 | yapp driver | TX pkt #49: addr=0 len=1 parity=good delay=20 |
| 7825 | **DUT** | OUT ch0 pkt #48 done: 3 bytes in 3 cycles |
| 7825 | ch0 monitor | ch0 RX pkt #48: addr=0 len=1 parity=good |
| 7825 | scoreboard | ch0 pkt matched: addr=0 len=1 (48 matched so far) |
| 8025 | **DUT** | IN  pkt #49 header: addr=0 len=1 -> channel 0 |
| 8035 | **DUT** | OUT ch0 pkt #49 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8045 | **DUT** | IN  pkt #49 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8045 | yapp monitor | RX pkt #49 on the input: addr=0 len=1 parity=good gap=20 |
| 8045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8050 | yapp driver | TX pkt #49 accepted by the DUT |
| 8050 | yapp driver | TX pkt #50: addr=0 len=1 parity=good delay=19 |
| 8055 | **DUT** | OUT ch0 pkt #49 done: 3 bytes in 3 cycles |
| 8055 | ch0 monitor | ch0 RX pkt #49: addr=0 len=1 parity=good |
| 8055 | scoreboard | ch0 pkt matched: addr=0 len=1 (49 matched so far) |
| 8245 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> channel 0 |
| 8255 | **DUT** | OUT ch0 pkt #50 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8265 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8265 | yapp monitor | RX pkt #50 on the input: addr=0 len=1 parity=good gap=19 |
| 8265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8270 | yapp driver | TX pkt #50 accepted by the DUT |
| 8270 | yapp driver | TX pkt #51: addr=0 len=1 parity=good delay=15 |
| 8275 | **DUT** | OUT ch0 pkt #50 done: 3 bytes in 3 cycles |
| 8275 | ch0 monitor | ch0 RX pkt #50: addr=0 len=1 parity=good |
| 8275 | scoreboard | ch0 pkt matched: addr=0 len=1 (50 matched so far) |
| 8280 | ch0 driver | ch0: packet consumed (response delay 10) |
| 8425 | **DUT** | IN  pkt #51 header: addr=0 len=1 -> channel 0 |
| 8445 | **DUT** | IN  pkt #51 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8445 | yapp monitor | RX pkt #51 on the input: addr=0 len=1 parity=good gap=15 |
| 8445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8450 | yapp driver | TX pkt #51 accepted by the DUT |
| 8450 | yapp driver | TX pkt #52: addr=0 len=1 parity=good delay=19 |
| 8465 | **DUT** | OUT ch0 pkt #51 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 8480 | ch0 driver | ch0: packet consumed (response delay 3) |
| 8575 | **DUT** | OUT ch0 pkt #51 done: 3 bytes in 12 cycles |
| 8575 | ch0 monitor | ch0 RX pkt #51: addr=0 len=1 parity=good |
| 8575 | scoreboard | ch0 pkt matched: addr=0 len=1 (51 matched so far) |
| 8645 | **DUT** | IN  pkt #52 header: addr=0 len=1 -> channel 0 |
| 8655 | **DUT** | OUT ch0 pkt #52 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8665 | **DUT** | IN  pkt #52 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8665 | yapp monitor | RX pkt #52 on the input: addr=0 len=1 parity=good gap=19 |
| 8665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8670 | yapp driver | TX pkt #52 accepted by the DUT |
| 8670 | yapp driver | TX pkt #53: addr=0 len=1 parity=good delay=18 |
| 8675 | **DUT** | OUT ch0 pkt #52 done: 3 bytes in 3 cycles |
| 8675 | ch0 monitor | ch0 RX pkt #52: addr=0 len=1 parity=good |
| 8675 | scoreboard | ch0 pkt matched: addr=0 len=1 (52 matched so far) |
| 8840 | ch0 driver | ch0: packet consumed (response delay 8) |
| 8855 | **DUT** | IN  pkt #53 header: addr=0 len=1 -> channel 0 |
| 8875 | **DUT** | IN  pkt #53 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8875 | yapp monitor | RX pkt #53 on the input: addr=0 len=1 parity=good gap=18 |
| 8875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8880 | yapp driver | TX pkt #53 accepted by the DUT |
| 8880 | yapp driver | TX pkt #54: addr=0 len=1 parity=good delay=6 |
| 8935 | **DUT** | OUT ch0 pkt #53 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 8945 | **DUT** | IN  pkt #54 header: addr=0 len=1 -> channel 0 |
| 8950 | ch0 driver | ch0: packet consumed (response delay 7) |
| 8965 | **DUT** | IN  pkt #54 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8965 | yapp monitor | RX pkt #54 on the input: addr=0 len=1 parity=good gap=6 |
| 8965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8970 | yapp driver | TX pkt #54 accepted by the DUT |
| 8970 | yapp driver | TX pkt #55: addr=0 len=1 parity=good delay=4 |
| 9015 | **DUT** | IN  pkt #55 header: addr=0 len=1 -> channel 0 |
| 9035 | **DUT** | IN  pkt #55 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9035 | **DUT** | OUT ch0 pkt #53 done: 3 bytes in 11 cycles |
| 9035 | ch0 monitor | ch0 RX pkt #53: addr=0 len=1 parity=good |
| 9035 | scoreboard | ch0 pkt matched: addr=0 len=1 (53 matched so far) |
| 9035 | yapp monitor | RX pkt #55 on the input: addr=0 len=1 parity=good gap=4 |
| 9035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9040 | ch0 driver | ch0: packet consumed (response delay 7) |
| 9040 | yapp driver | TX pkt #55 accepted by the DUT |
| 9040 | yapp driver | TX pkt #56: addr=0 len=1 parity=good delay=5 |
| 9095 | **DUT** | IN  pkt #56 header: addr=0 len=1 -> channel 0 |
| 9105 | **DUT** | OUT ch0 pkt #54 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 9115 | **DUT** | IN  pkt #56 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9115 | yapp monitor | RX pkt #56 on the input: addr=0 len=1 parity=good gap=5 |
| 9115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9120 | ch0 driver | ch0: packet consumed (response delay 5) |
| 9120 | yapp driver | TX pkt #56 accepted by the DUT |
| 9120 | yapp driver | TX pkt #57: addr=0 len=1 parity=good delay=20 |
| 9225 | **DUT** | OUT ch0 pkt #54 done: 3 bytes in 13 cycles |
| 9225 | ch0 monitor | ch0 RX pkt #54: addr=0 len=1 parity=good |
| 9225 | scoreboard | ch0 pkt matched: addr=0 len=1 (54 matched so far) |
| 9235 | **DUT** | OUT ch0 pkt #55 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9255 | **DUT** | OUT ch0 pkt #55 done: 3 bytes in 3 cycles |
| 9255 | ch0 monitor | ch0 RX pkt #55: addr=0 len=1 parity=good |
| 9255 | scoreboard | ch0 pkt matched: addr=0 len=1 (55 matched so far) |
| 9265 | **DUT** | OUT ch0 pkt #56 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9285 | **DUT** | OUT ch0 pkt #56 done: 3 bytes in 3 cycles |
| 9285 | ch0 monitor | ch0 RX pkt #56: addr=0 len=1 parity=good |
| 9285 | scoreboard | ch0 pkt matched: addr=0 len=1 (56 matched so far) |
| 9325 | **DUT** | IN  pkt #57 header: addr=0 len=1 -> channel 0 |
| 9335 | **DUT** | OUT ch0 pkt #57 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9345 | **DUT** | IN  pkt #57 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9345 | yapp monitor | RX pkt #57 on the input: addr=0 len=1 parity=good gap=20 |
| 9345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9350 | ch0 driver | ch0: packet consumed (response delay 9) |
| 9350 | yapp driver | TX pkt #57 accepted by the DUT |
| 9350 | yapp driver | TX pkt #58: addr=0 len=1 parity=good delay=1 |
| 9365 | **DUT** | IN  pkt #58 header: addr=0 len=1 -> channel 0 |
| 9385 | **DUT** | IN  pkt #58 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9385 | yapp monitor | RX pkt #58 on the input: addr=0 len=1 parity=good gap=1 |
| 9385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9390 | yapp driver | TX pkt #58 accepted by the DUT |
| 9390 | yapp driver | TX pkt #59: addr=0 len=1 parity=good delay=17 |
| 9465 | **DUT** | OUT ch0 pkt #57 done: 3 bytes in 14 cycles |
| 9465 | ch0 monitor | ch0 RX pkt #57: addr=0 len=1 parity=good |
| 9465 | scoreboard | ch0 pkt matched: addr=0 len=1 (57 matched so far) |
| 9475 | **DUT** | OUT ch0 pkt #58 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9495 | **DUT** | OUT ch0 pkt #58 done: 3 bytes in 3 cycles |
| 9495 | ch0 monitor | ch0 RX pkt #58: addr=0 len=1 parity=good |
| 9495 | scoreboard | ch0 pkt matched: addr=0 len=1 (58 matched so far) |
| 9565 | **DUT** | IN  pkt #59 header: addr=0 len=1 -> channel 0 |
| 9575 | **DUT** | OUT ch0 pkt #59 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9585 | **DUT** | IN  pkt #59 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9585 | yapp monitor | RX pkt #59 on the input: addr=0 len=1 parity=good gap=17 |
| 9585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9590 | yapp driver | TX pkt #59 accepted by the DUT |
| 9590 | yapp driver | TX pkt #60: addr=0 len=1 parity=good delay=16 |
| 9595 | **DUT** | OUT ch0 pkt #59 done: 3 bytes in 3 cycles |
| 9595 | ch0 monitor | ch0 RX pkt #59: addr=0 len=1 parity=good |
| 9595 | scoreboard | ch0 pkt matched: addr=0 len=1 (59 matched so far) |
| 9755 | **DUT** | IN  pkt #60 header: addr=0 len=1 -> channel 0 |
| 9765 | **DUT** | OUT ch0 pkt #60 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9775 | **DUT** | IN  pkt #60 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9775 | yapp monitor | RX pkt #60 on the input: addr=0 len=1 parity=good gap=16 |
| 9775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9780 | yapp driver | TX pkt #60 accepted by the DUT |
| 9780 | yapp driver | TX pkt #61: addr=0 len=1 parity=good delay=7 |
| 9785 | **DUT** | OUT ch0 pkt #60 done: 3 bytes in 3 cycles |
| 9785 | ch0 monitor | ch0 RX pkt #60: addr=0 len=1 parity=good |
| 9785 | scoreboard | ch0 pkt matched: addr=0 len=1 (60 matched so far) |
| 9855 | **DUT** | IN  pkt #61 header: addr=0 len=1 -> channel 0 |
| 9865 | **DUT** | OUT ch0 pkt #61 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9875 | **DUT** | IN  pkt #61 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9875 | yapp monitor | RX pkt #61 on the input: addr=0 len=1 parity=good gap=7 |
| 9875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9880 | yapp driver | TX pkt #61 accepted by the DUT |
| 9880 | yapp driver | TX pkt #62: addr=0 len=1 parity=good delay=20 |
| 9885 | **DUT** | OUT ch0 pkt #61 done: 3 bytes in 3 cycles |
| 9885 | ch0 monitor | ch0 RX pkt #61: addr=0 len=1 parity=good |
| 9885 | scoreboard | ch0 pkt matched: addr=0 len=1 (61 matched so far) |
| 9980 | ch0 driver | ch0: packet consumed (response delay 10) |
| 10085 | **DUT** | IN  pkt #62 header: addr=0 len=1 -> channel 0 |
| 10105 | **DUT** | IN  pkt #62 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10105 | yapp monitor | RX pkt #62 on the input: addr=0 len=1 parity=good gap=20 |
| 10105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10110 | yapp driver | TX pkt #62 accepted by the DUT |
| 10110 | yapp driver | TX pkt #63: addr=0 len=1 parity=good delay=15 |
| 10175 | **DUT** | OUT ch0 pkt #62 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 10190 | ch0 driver | ch0: packet consumed (response delay 8) |
| 10265 | **DUT** | IN  pkt #63 header: addr=0 len=1 -> channel 0 |
| 10285 | **DUT** | IN  pkt #63 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10285 | yapp monitor | RX pkt #63 on the input: addr=0 len=1 parity=good gap=15 |
| 10285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10290 | yapp driver | TX pkt #63 accepted by the DUT |
| 10290 | yapp driver | TX pkt #64: addr=0 len=1 parity=good delay=20 |
| 10305 | **DUT** | OUT ch0 pkt #62 done: 3 bytes in 14 cycles |
| 10305 | ch0 monitor | ch0 RX pkt #62: addr=0 len=1 parity=good |
| 10305 | scoreboard | ch0 pkt matched: addr=0 len=1 (62 matched so far) |
| 10315 | **DUT** | OUT ch0 pkt #63 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10335 | **DUT** | OUT ch0 pkt #63 done: 3 bytes in 3 cycles |
| 10335 | ch0 monitor | ch0 RX pkt #63: addr=0 len=1 parity=good |
| 10335 | scoreboard | ch0 pkt matched: addr=0 len=1 (63 matched so far) |
| 10495 | **DUT** | IN  pkt #64 header: addr=0 len=1 -> channel 0 |
| 10505 | **DUT** | OUT ch0 pkt #64 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10515 | **DUT** | IN  pkt #64 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10515 | yapp monitor | RX pkt #64 on the input: addr=0 len=1 parity=good gap=20 |
| 10515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10520 | yapp driver | TX pkt #64 accepted by the DUT |
| 10520 | yapp driver | TX pkt #65: addr=0 len=1 parity=good delay=1 |
| 10525 | **DUT** | OUT ch0 pkt #64 done: 3 bytes in 3 cycles |
| 10525 | ch0 monitor | ch0 RX pkt #64: addr=0 len=1 parity=good |
| 10525 | scoreboard | ch0 pkt matched: addr=0 len=1 (64 matched so far) |
| 10535 | **DUT** | IN  pkt #65 header: addr=0 len=1 -> channel 0 |
| 10545 | **DUT** | OUT ch0 pkt #65 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10555 | **DUT** | IN  pkt #65 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10555 | yapp monitor | RX pkt #65 on the input: addr=0 len=1 parity=good gap=1 |
| 10555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10560 | yapp driver | TX pkt #65 accepted by the DUT |
| 10560 | yapp driver | TX pkt #66: addr=0 len=1 parity=good delay=11 |
| 10565 | **DUT** | OUT ch0 pkt #65 done: 3 bytes in 3 cycles |
| 10565 | ch0 monitor | ch0 RX pkt #65: addr=0 len=1 parity=good |
| 10565 | scoreboard | ch0 pkt matched: addr=0 len=1 (65 matched so far) |
| 10675 | **DUT** | IN  pkt #66 header: addr=0 len=1 -> channel 0 |
| 10685 | **DUT** | OUT ch0 pkt #66 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10695 | **DUT** | IN  pkt #66 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10695 | yapp monitor | RX pkt #66 on the input: addr=0 len=1 parity=good gap=11 |
| 10695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10700 | yapp driver | TX pkt #66 accepted by the DUT |
| 10700 | yapp driver | TX pkt #67: addr=0 len=1 parity=good delay=12 |
| 10705 | **DUT** | OUT ch0 pkt #66 done: 3 bytes in 3 cycles |
| 10705 | ch0 monitor | ch0 RX pkt #66: addr=0 len=1 parity=good |
| 10705 | scoreboard | ch0 pkt matched: addr=0 len=1 (66 matched so far) |
| 10790 | ch0 driver | ch0: packet consumed (response delay 10) |
| 10825 | **DUT** | IN  pkt #67 header: addr=0 len=1 -> channel 0 |
| 10845 | **DUT** | IN  pkt #67 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10845 | yapp monitor | RX pkt #67 on the input: addr=0 len=1 parity=good gap=12 |
| 10845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10850 | yapp driver | TX pkt #67 accepted by the DUT |
| 10850 | yapp driver | TX pkt #68: addr=0 len=1 parity=good delay=20 |
| 10935 | **DUT** | OUT ch0 pkt #67 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 10950 | ch0 driver | ch0: packet consumed (response delay 10) |
| 11055 | **DUT** | IN  pkt #68 header: addr=0 len=1 -> channel 0 |
| 11055 | **DUT** | OUT ch0 pkt #67 done: 3 bytes in 13 cycles |
| 11055 | ch0 monitor | ch0 RX pkt #67: addr=0 len=1 parity=good |
| 11055 | scoreboard | ch0 pkt matched: addr=0 len=1 (67 matched so far) |
| 11065 | **DUT** | OUT ch0 pkt #68 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11075 | **DUT** | IN  pkt #68 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11075 | yapp monitor | RX pkt #68 on the input: addr=0 len=1 parity=good gap=20 |
| 11075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11080 | yapp driver | TX pkt #68 accepted by the DUT |
| 11080 | yapp driver | TX pkt #69: addr=0 len=1 parity=good delay=18 |
| 11085 | **DUT** | OUT ch0 pkt #68 done: 3 bytes in 3 cycles |
| 11085 | ch0 monitor | ch0 RX pkt #68: addr=0 len=1 parity=good |
| 11085 | scoreboard | ch0 pkt matched: addr=0 len=1 (68 matched so far) |
| 11265 | **DUT** | IN  pkt #69 header: addr=0 len=1 -> channel 0 |
| 11275 | **DUT** | OUT ch0 pkt #69 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11285 | **DUT** | IN  pkt #69 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11285 | yapp monitor | RX pkt #69 on the input: addr=0 len=1 parity=good gap=18 |
| 11285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11290 | yapp driver | TX pkt #69 accepted by the DUT |
| 11290 | yapp driver | TX pkt #70: addr=0 len=1 parity=good delay=13 |
| 11295 | **DUT** | OUT ch0 pkt #69 done: 3 bytes in 3 cycles |
| 11295 | ch0 monitor | ch0 RX pkt #69: addr=0 len=1 parity=good |
| 11295 | scoreboard | ch0 pkt matched: addr=0 len=1 (69 matched so far) |
| 11425 | **DUT** | IN  pkt #70 header: addr=0 len=1 -> channel 0 |
| 11435 | **DUT** | OUT ch0 pkt #70 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11445 | **DUT** | IN  pkt #70 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11445 | yapp monitor | RX pkt #70 on the input: addr=0 len=1 parity=good gap=13 |
| 11445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11450 | yapp driver | TX pkt #70 accepted by the DUT |
| 11450 | yapp driver | TX pkt #71: addr=0 len=1 parity=good delay=16 |
| 11455 | **DUT** | OUT ch0 pkt #70 done: 3 bytes in 3 cycles |
| 11455 | ch0 monitor | ch0 RX pkt #70: addr=0 len=1 parity=good |
| 11455 | scoreboard | ch0 pkt matched: addr=0 len=1 (70 matched so far) |
| 11615 | **DUT** | IN  pkt #71 header: addr=0 len=1 -> channel 0 |
| 11625 | **DUT** | OUT ch0 pkt #71 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11635 | **DUT** | IN  pkt #71 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11635 | yapp monitor | RX pkt #71 on the input: addr=0 len=1 parity=good gap=16 |
| 11635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11640 | yapp driver | TX pkt #71 accepted by the DUT |
| 11640 | yapp driver | TX pkt #72: addr=0 len=1 parity=good delay=12 |
| 11645 | **DUT** | OUT ch0 pkt #71 done: 3 bytes in 3 cycles |
| 11645 | ch0 monitor | ch0 RX pkt #71: addr=0 len=1 parity=good |
| 11645 | scoreboard | ch0 pkt matched: addr=0 len=1 (71 matched so far) |
| 11680 | ch0 driver | ch0: packet consumed (response delay 9) |
| 11765 | **DUT** | IN  pkt #72 header: addr=0 len=1 -> channel 0 |
| 11785 | **DUT** | IN  pkt #72 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11785 | yapp monitor | RX pkt #72 on the input: addr=0 len=1 parity=good gap=12 |
| 11785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11790 | yapp driver | TX pkt #72 accepted by the DUT |
| 11790 | yapp driver | TX pkt #73: addr=0 len=1 parity=good delay=18 |
| 11865 | **DUT** | OUT ch0 pkt #72 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 11880 | ch0 driver | ch0: packet consumed (response delay 9) |
| 11975 | **DUT** | IN  pkt #73 header: addr=0 len=1 -> channel 0 |
| 11995 | **DUT** | IN  pkt #73 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11995 | **DUT** | OUT ch0 pkt #72 done: 3 bytes in 14 cycles |
| 11995 | ch0 monitor | ch0 RX pkt #72: addr=0 len=1 parity=good |
| 11995 | scoreboard | ch0 pkt matched: addr=0 len=1 (72 matched so far) |
| 11995 | yapp monitor | RX pkt #73 on the input: addr=0 len=1 parity=good gap=18 |
| 11995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12000 | yapp driver | TX pkt #73 accepted by the DUT |
| 12000 | yapp driver | TX pkt #74: addr=0 len=1 parity=good delay=13 |
| 12005 | **DUT** | OUT ch0 pkt #73 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12025 | **DUT** | OUT ch0 pkt #73 done: 3 bytes in 3 cycles |
| 12025 | ch0 monitor | ch0 RX pkt #73: addr=0 len=1 parity=good |
| 12025 | scoreboard | ch0 pkt matched: addr=0 len=1 (73 matched so far) |
| 12135 | **DUT** | IN  pkt #74 header: addr=0 len=1 -> channel 0 |
| 12140 | ch0 driver | ch0: packet consumed (response delay 10) |
| 12155 | **DUT** | IN  pkt #74 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12155 | yapp monitor | RX pkt #74 on the input: addr=0 len=1 parity=good gap=13 |
| 12155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12160 | yapp driver | TX pkt #74 accepted by the DUT |
| 12160 | yapp driver | TX pkt #75: addr=0 len=1 parity=good delay=14 |
| 12235 | **DUT** | OUT ch0 pkt #74 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 12250 | ch0 driver | ch0: packet consumed (response delay 8) |
| 12305 | **DUT** | IN  pkt #75 header: addr=0 len=1 -> channel 0 |
| 12325 | **DUT** | IN  pkt #75 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12325 | yapp monitor | RX pkt #75 on the input: addr=0 len=1 parity=good gap=14 |
| 12325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12330 | yapp driver | TX pkt #75 accepted by the DUT |
| 12330 | yapp driver | TX pkt #76: addr=0 len=1 parity=good delay=8 |
| 12345 | **DUT** | OUT ch0 pkt #74 done: 3 bytes in 12 cycles |
| 12345 | ch0 monitor | ch0 RX pkt #74: addr=0 len=1 parity=good |
| 12345 | scoreboard | ch0 pkt matched: addr=0 len=1 (74 matched so far) |
| 12355 | **DUT** | OUT ch0 pkt #75 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12375 | **DUT** | OUT ch0 pkt #75 done: 3 bytes in 3 cycles |
| 12375 | ch0 monitor | ch0 RX pkt #75: addr=0 len=1 parity=good |
| 12375 | scoreboard | ch0 pkt matched: addr=0 len=1 (75 matched so far) |
| 12415 | **DUT** | IN  pkt #76 header: addr=0 len=1 -> channel 0 |
| 12425 | **DUT** | OUT ch0 pkt #76 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12435 | **DUT** | IN  pkt #76 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12435 | yapp monitor | RX pkt #76 on the input: addr=0 len=1 parity=good gap=8 |
| 12435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12440 | yapp driver | TX pkt #76 accepted by the DUT |
| 12440 | yapp driver | TX pkt #77: addr=0 len=1 parity=good delay=12 |
| 12445 | **DUT** | OUT ch0 pkt #76 done: 3 bytes in 3 cycles |
| 12445 | ch0 monitor | ch0 RX pkt #76: addr=0 len=1 parity=good |
| 12445 | scoreboard | ch0 pkt matched: addr=0 len=1 (76 matched so far) |
| 12565 | **DUT** | IN  pkt #77 header: addr=0 len=1 -> channel 0 |
| 12575 | **DUT** | OUT ch0 pkt #77 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12585 | **DUT** | IN  pkt #77 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12585 | yapp monitor | RX pkt #77 on the input: addr=0 len=1 parity=good gap=12 |
| 12585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12590 | yapp driver | TX pkt #77 accepted by the DUT |
| 12590 | yapp driver | TX pkt #78: addr=0 len=1 parity=good delay=12 |
| 12595 | **DUT** | OUT ch0 pkt #77 done: 3 bytes in 3 cycles |
| 12595 | ch0 monitor | ch0 RX pkt #77: addr=0 len=1 parity=good |
| 12595 | scoreboard | ch0 pkt matched: addr=0 len=1 (77 matched so far) |
| 12715 | **DUT** | IN  pkt #78 header: addr=0 len=1 -> channel 0 |
| 12725 | **DUT** | OUT ch0 pkt #78 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12735 | **DUT** | IN  pkt #78 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12735 | yapp monitor | RX pkt #78 on the input: addr=0 len=1 parity=good gap=12 |
| 12735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12740 | yapp driver | TX pkt #78 accepted by the DUT |
| 12740 | yapp driver | TX pkt #79: addr=0 len=1 parity=good delay=19 |
| 12745 | **DUT** | OUT ch0 pkt #78 done: 3 bytes in 3 cycles |
| 12745 | ch0 monitor | ch0 RX pkt #78: addr=0 len=1 parity=good |
| 12745 | scoreboard | ch0 pkt matched: addr=0 len=1 (78 matched so far) |
| 12880 | ch0 driver | ch0: packet consumed (response delay 8) |
| 12935 | **DUT** | IN  pkt #79 header: addr=0 len=1 -> channel 0 |
| 12955 | **DUT** | IN  pkt #79 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12955 | yapp monitor | RX pkt #79 on the input: addr=0 len=1 parity=good gap=19 |
| 12955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12960 | yapp driver | TX pkt #79 accepted by the DUT |
| 12960 | yapp driver | TX pkt #80: addr=0 len=1 parity=good delay=20 |
| 13015 | **DUT** | OUT ch0 pkt #79 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 13030 | ch0 driver | ch0: packet consumed (response delay 7) |
| 13065 | **DUT** | OUT ch0 pkt #79 done: 3 bytes in 6 cycles |
| 13065 | ch0 monitor | ch0 RX pkt #79: addr=0 len=1 parity=good |
| 13065 | scoreboard | ch0 pkt matched: addr=0 len=1 (79 matched so far) |
| 13165 | **DUT** | IN  pkt #80 header: addr=0 len=1 -> channel 0 |
| 13175 | **DUT** | OUT ch0 pkt #80 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13185 | **DUT** | IN  pkt #80 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13185 | yapp monitor | RX pkt #80 on the input: addr=0 len=1 parity=good gap=20 |
| 13185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13190 | yapp driver | TX pkt #80 accepted by the DUT |
| 13190 | yapp driver | TX pkt #81: addr=0 len=1 parity=good delay=5 |
| 13195 | **DUT** | OUT ch0 pkt #80 done: 3 bytes in 3 cycles |
| 13195 | ch0 monitor | ch0 RX pkt #80: addr=0 len=1 parity=good |
| 13195 | scoreboard | ch0 pkt matched: addr=0 len=1 (80 matched so far) |
| 13245 | **DUT** | IN  pkt #81 header: addr=0 len=1 -> channel 0 |
| 13255 | **DUT** | OUT ch0 pkt #81 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13265 | **DUT** | IN  pkt #81 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13265 | yapp monitor | RX pkt #81 on the input: addr=0 len=1 parity=good gap=5 |
| 13265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13270 | yapp driver | TX pkt #81 accepted by the DUT |
| 13270 | yapp driver | TX pkt #82: addr=0 len=1 parity=good delay=16 |
| 13275 | **DUT** | OUT ch0 pkt #81 done: 3 bytes in 3 cycles |
| 13275 | ch0 monitor | ch0 RX pkt #81: addr=0 len=1 parity=good |
| 13275 | scoreboard | ch0 pkt matched: addr=0 len=1 (81 matched so far) |
| 13435 | **DUT** | IN  pkt #82 header: addr=0 len=1 -> channel 0 |
| 13445 | **DUT** | OUT ch0 pkt #82 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13455 | **DUT** | IN  pkt #82 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13455 | yapp monitor | RX pkt #82 on the input: addr=0 len=1 parity=good gap=16 |
| 13455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13460 | yapp driver | TX pkt #82 accepted by the DUT |
| 13460 | yapp driver | TX pkt #83: addr=0 len=1 parity=good delay=11 |
| 13465 | **DUT** | OUT ch0 pkt #82 done: 3 bytes in 3 cycles |
| 13465 | ch0 monitor | ch0 RX pkt #82: addr=0 len=1 parity=good |
| 13465 | scoreboard | ch0 pkt matched: addr=0 len=1 (82 matched so far) |
| 13575 | **DUT** | IN  pkt #83 header: addr=0 len=1 -> channel 0 |
| 13585 | **DUT** | OUT ch0 pkt #83 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13595 | **DUT** | IN  pkt #83 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13595 | yapp monitor | RX pkt #83 on the input: addr=0 len=1 parity=good gap=11 |
| 13595 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13600 | yapp driver | TX pkt #83 accepted by the DUT |
| 13600 | yapp driver | TX pkt #84: addr=0 len=1 parity=good delay=20 |
| 13605 | **DUT** | OUT ch0 pkt #83 done: 3 bytes in 3 cycles |
| 13605 | ch0 monitor | ch0 RX pkt #83: addr=0 len=1 parity=good |
| 13605 | scoreboard | ch0 pkt matched: addr=0 len=1 (83 matched so far) |
| 13620 | ch0 driver | ch0: packet consumed (response delay 2) |
| 13805 | **DUT** | IN  pkt #84 header: addr=0 len=1 -> channel 0 |
| 13825 | **DUT** | IN  pkt #84 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13825 | yapp monitor | RX pkt #84 on the input: addr=0 len=1 parity=good gap=20 |
| 13825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13830 | yapp driver | TX pkt #84 accepted by the DUT |
| 13830 | yapp driver | TX pkt #85: addr=0 len=1 parity=good delay=3 |
| 13865 | **DUT** | IN  pkt #85 header: addr=0 len=1 -> channel 0 |
| 13885 | **DUT** | IN  pkt #85 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13885 | yapp monitor | RX pkt #85 on the input: addr=0 len=1 parity=good gap=3 |
| 13885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13890 | yapp driver | TX pkt #85 accepted by the DUT |
| 13890 | yapp driver | TX pkt #86: addr=0 len=1 parity=good delay=19 |
| 13895 | **DUT** | OUT ch0 pkt #84 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 13910 | ch0 driver | ch0: packet consumed (response delay 8) |
| 13965 | **DUT** | OUT ch0 pkt #84 done: 3 bytes in 8 cycles |
| 13965 | ch0 monitor | ch0 RX pkt #84: addr=0 len=1 parity=good |
| 13965 | scoreboard | ch0 pkt matched: addr=0 len=1 (84 matched so far) |
| 13975 | **DUT** | OUT ch0 pkt #85 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13995 | **DUT** | OUT ch0 pkt #85 done: 3 bytes in 3 cycles |
| 13995 | ch0 monitor | ch0 RX pkt #85: addr=0 len=1 parity=good |
| 13995 | scoreboard | ch0 pkt matched: addr=0 len=1 (85 matched so far) |
| 14085 | **DUT** | IN  pkt #86 header: addr=0 len=1 -> channel 0 |
| 14095 | **DUT** | OUT ch0 pkt #86 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14105 | **DUT** | IN  pkt #86 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14105 | yapp monitor | RX pkt #86 on the input: addr=0 len=1 parity=good gap=19 |
| 14105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14110 | yapp driver | TX pkt #86 accepted by the DUT |
| 14110 | yapp driver | TX pkt #87: addr=0 len=1 parity=good delay=20 |
| 14115 | **DUT** | OUT ch0 pkt #86 done: 3 bytes in 3 cycles |
| 14115 | ch0 monitor | ch0 RX pkt #86: addr=0 len=1 parity=good |
| 14115 | scoreboard | ch0 pkt matched: addr=0 len=1 (86 matched so far) |
| 14315 | **DUT** | IN  pkt #87 header: addr=0 len=1 -> channel 0 |
| 14325 | **DUT** | OUT ch0 pkt #87 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14335 | **DUT** | IN  pkt #87 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14335 | yapp monitor | RX pkt #87 on the input: addr=0 len=1 parity=good gap=20 |
| 14335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14340 | yapp driver | TX pkt #87 accepted by the DUT |
| 14340 | yapp driver | TX pkt #88: addr=0 len=1 parity=good delay=7 |
| 14345 | **DUT** | OUT ch0 pkt #87 done: 3 bytes in 3 cycles |
| 14345 | ch0 monitor | ch0 RX pkt #87: addr=0 len=1 parity=good |
| 14345 | scoreboard | ch0 pkt matched: addr=0 len=1 (87 matched so far) |
| 14415 | **DUT** | IN  pkt #88 header: addr=0 len=1 -> channel 0 |
| 14425 | **DUT** | OUT ch0 pkt #88 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14435 | **DUT** | IN  pkt #88 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14435 | yapp monitor | RX pkt #88 on the input: addr=0 len=1 parity=good gap=7 |
| 14435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14440 | yapp driver | TX pkt #88 accepted by the DUT |
| 14440 | yapp driver | TX pkt #89: addr=0 len=1 parity=good delay=17 |
| 14445 | **DUT** | OUT ch0 pkt #88 done: 3 bytes in 3 cycles |
| 14445 | ch0 monitor | ch0 RX pkt #88: addr=0 len=1 parity=good |
| 14445 | scoreboard | ch0 pkt matched: addr=0 len=1 (88 matched so far) |
| 14470 | ch0 driver | ch0: packet consumed (response delay 4) |
| 14615 | **DUT** | IN  pkt #89 header: addr=0 len=1 -> channel 0 |
| 14635 | **DUT** | IN  pkt #89 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14635 | yapp monitor | RX pkt #89 on the input: addr=0 len=1 parity=good gap=17 |
| 14635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14640 | yapp driver | TX pkt #89 accepted by the DUT |
| 14640 | yapp driver | TX pkt #90: addr=0 len=1 parity=good delay=17 |
| 14725 | **DUT** | OUT ch0 pkt #89 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 14740 | ch0 driver | ch0: packet consumed (response delay 10) |
| 14815 | **DUT** | IN  pkt #90 header: addr=0 len=1 -> channel 0 |
| 14835 | **DUT** | IN  pkt #90 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14835 | yapp monitor | RX pkt #90 on the input: addr=0 len=1 parity=good gap=17 |
| 14835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14840 | yapp driver | TX pkt #90 accepted by the DUT |
| 14840 | yapp driver | TX pkt #91: addr=0 len=1 parity=good delay=20 |
| 14855 | **DUT** | OUT ch0 pkt #89 done: 3 bytes in 14 cycles |
| 14855 | ch0 monitor | ch0 RX pkt #89: addr=0 len=1 parity=good |
| 14855 | scoreboard | ch0 pkt matched: addr=0 len=1 (89 matched so far) |
| 14865 | **DUT** | OUT ch0 pkt #90 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14885 | **DUT** | OUT ch0 pkt #90 done: 3 bytes in 3 cycles |
| 14885 | ch0 monitor | ch0 RX pkt #90: addr=0 len=1 parity=good |
| 14885 | scoreboard | ch0 pkt matched: addr=0 len=1 (90 matched so far) |
| 14890 | ch0 driver | ch0: packet consumed (response delay 10) |
| 15045 | **DUT** | IN  pkt #91 header: addr=0 len=1 -> channel 0 |
| 15065 | **DUT** | IN  pkt #91 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15065 | yapp monitor | RX pkt #91 on the input: addr=0 len=1 parity=good gap=20 |
| 15065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15070 | yapp driver | TX pkt #91 accepted by the DUT |
| 15070 | yapp driver | TX pkt #92: addr=0 len=1 parity=good delay=9 |
| 15105 | **DUT** | OUT ch0 pkt #91 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 15120 | ch0 driver | ch0: packet consumed (response delay 5) |
| 15165 | **DUT** | IN  pkt #92 header: addr=0 len=1 -> channel 0 |
| 15185 | **DUT** | IN  pkt #92 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15185 | yapp monitor | RX pkt #92 on the input: addr=0 len=1 parity=good gap=9 |
| 15185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15190 | yapp driver | TX pkt #92 accepted by the DUT |
| 15190 | yapp driver | TX pkt #93: addr=0 len=1 parity=good delay=1 |
| 15205 | **DUT** | IN  pkt #93 header: addr=0 len=1 -> channel 0 |
| 15225 | **DUT** | IN  pkt #93 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15225 | yapp monitor | RX pkt #93 on the input: addr=0 len=1 parity=good gap=1 |
| 15225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15230 | yapp driver | TX pkt #93 accepted by the DUT |
| 15230 | yapp driver | TX pkt #94: addr=0 len=1 parity=good delay=16 |
| 15235 | **DUT** | OUT ch0 pkt #91 done: 3 bytes in 14 cycles |
| 15235 | ch0 monitor | ch0 RX pkt #91: addr=0 len=1 parity=good |
| 15235 | scoreboard | ch0 pkt matched: addr=0 len=1 (91 matched so far) |
| 15245 | **DUT** | OUT ch0 pkt #92 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15265 | **DUT** | OUT ch0 pkt #92 done: 3 bytes in 3 cycles |
| 15265 | ch0 monitor | ch0 RX pkt #92: addr=0 len=1 parity=good |
| 15265 | scoreboard | ch0 pkt matched: addr=0 len=1 (92 matched so far) |
| 15275 | **DUT** | OUT ch0 pkt #93 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15295 | **DUT** | OUT ch0 pkt #93 done: 3 bytes in 3 cycles |
| 15295 | ch0 monitor | ch0 RX pkt #93: addr=0 len=1 parity=good |
| 15295 | scoreboard | ch0 pkt matched: addr=0 len=1 (93 matched so far) |
| 15320 | ch0 driver | ch0: packet consumed (response delay 10) |
| 15395 | **DUT** | IN  pkt #94 header: addr=0 len=1 -> channel 0 |
| 15415 | **DUT** | IN  pkt #94 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15415 | yapp monitor | RX pkt #94 on the input: addr=0 len=1 parity=good gap=16 |
| 15415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15420 | yapp driver | TX pkt #94 accepted by the DUT |
| 15420 | yapp driver | TX pkt #95: addr=0 len=1 parity=good delay=20 |
| 15445 | **DUT** | OUT ch0 pkt #94 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 15460 | ch0 driver | ch0: packet consumed (response delay 4) |
| 15505 | **DUT** | OUT ch0 pkt #94 done: 3 bytes in 7 cycles |
| 15505 | ch0 monitor | ch0 RX pkt #94: addr=0 len=1 parity=good |
| 15505 | scoreboard | ch0 pkt matched: addr=0 len=1 (94 matched so far) |
| 15625 | **DUT** | IN  pkt #95 header: addr=0 len=1 -> channel 0 |
| 15635 | **DUT** | OUT ch0 pkt #95 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15645 | **DUT** | IN  pkt #95 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15645 | yapp monitor | RX pkt #95 on the input: addr=0 len=1 parity=good gap=20 |
| 15645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15650 | yapp driver | TX pkt #95 accepted by the DUT |
| 15650 | yapp driver | TX pkt #96: addr=0 len=1 parity=good delay=20 |
| 15655 | **DUT** | OUT ch0 pkt #95 done: 3 bytes in 3 cycles |
| 15655 | ch0 monitor | ch0 RX pkt #95: addr=0 len=1 parity=good |
| 15655 | scoreboard | ch0 pkt matched: addr=0 len=1 (95 matched so far) |
| 15840 | ch0 driver | ch0: packet consumed (response delay 3) |
| 15855 | **DUT** | IN  pkt #96 header: addr=0 len=1 -> channel 0 |
| 15875 | **DUT** | IN  pkt #96 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15875 | yapp monitor | RX pkt #96 on the input: addr=0 len=1 parity=good gap=20 |
| 15875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15880 | yapp driver | TX pkt #96 accepted by the DUT |
| 15880 | yapp driver | TX pkt #97: addr=0 len=1 parity=good delay=14 |
| 15895 | **DUT** | OUT ch0 pkt #96 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 15910 | ch0 driver | ch0: packet consumed (response delay 3) |
| 15935 | **DUT** | OUT ch0 pkt #96 done: 3 bytes in 5 cycles |
| 15935 | ch0 monitor | ch0 RX pkt #96: addr=0 len=1 parity=good |
| 15935 | scoreboard | ch0 pkt matched: addr=0 len=1 (96 matched so far) |
| 15950 | ch0 driver | ch0: packet consumed (response delay 1) |
| 16025 | **DUT** | IN  pkt #97 header: addr=0 len=1 -> channel 0 |
| 16045 | **DUT** | IN  pkt #97 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16045 | yapp monitor | RX pkt #97 on the input: addr=0 len=1 parity=good gap=14 |
| 16045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16050 | yapp driver | TX pkt #97 accepted by the DUT |
| 16050 | yapp driver | TX pkt #98: addr=0 len=1 parity=good delay=5 |
| 16085 | **DUT** | OUT ch0 pkt #97 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 16100 | ch0 driver | ch0: packet consumed (response delay 5) |
| 16105 | **DUT** | IN  pkt #98 header: addr=0 len=1 -> channel 0 |
| 16125 | **DUT** | IN  pkt #98 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16125 | yapp monitor | RX pkt #98 on the input: addr=0 len=1 parity=good gap=5 |
| 16125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16130 | yapp driver | TX pkt #98 accepted by the DUT |
| 16130 | yapp driver | TX pkt #99: addr=0 len=1 parity=good delay=14 |
| 16175 | **DUT** | OUT ch0 pkt #97 done: 3 bytes in 10 cycles |
| 16175 | ch0 monitor | ch0 RX pkt #97: addr=0 len=1 parity=good |
| 16175 | scoreboard | ch0 pkt matched: addr=0 len=1 (97 matched so far) |
| 16185 | **DUT** | OUT ch0 pkt #98 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16205 | **DUT** | OUT ch0 pkt #98 done: 3 bytes in 3 cycles |
| 16205 | ch0 monitor | ch0 RX pkt #98: addr=0 len=1 parity=good |
| 16205 | scoreboard | ch0 pkt matched: addr=0 len=1 (98 matched so far) |
| 16275 | **DUT** | IN  pkt #99 header: addr=0 len=1 -> channel 0 |
| 16285 | **DUT** | OUT ch0 pkt #99 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16290 | ch0 driver | ch0: packet consumed (response delay 6) |
| 16295 | **DUT** | IN  pkt #99 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16295 | yapp monitor | RX pkt #99 on the input: addr=0 len=1 parity=good gap=14 |
| 16295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16300 | yapp driver | TX pkt #99 accepted by the DUT |
| 16300 | yapp driver | TX pkt #100: addr=0 len=1 parity=good delay=4 |
| 16345 | **DUT** | IN  pkt #100 header: addr=0 len=1 -> channel 0 |
| 16365 | **DUT** | IN  pkt #100 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16365 | **DUT** | OUT ch0 pkt #99 done: 3 bytes in 9 cycles |
| 16365 | ch0 monitor | ch0 RX pkt #99: addr=0 len=1 parity=good |
| 16365 | scoreboard | ch0 pkt matched: addr=0 len=1 (99 matched so far) |
| 16365 | yapp monitor | RX pkt #100 on the input: addr=0 len=1 parity=good gap=4 |
| 16365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16370 | yapp driver | TX pkt #100 accepted by the DUT |
| 16370 | yapp driver | TX pkt #101: addr=0 len=1 parity=good delay=17 |
| 16375 | **DUT** | OUT ch0 pkt #100 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16395 | **DUT** | OUT ch0 pkt #100 done: 3 bytes in 3 cycles |
| 16395 | ch0 monitor | ch0 RX pkt #100: addr=0 len=1 parity=good |
| 16395 | scoreboard | ch0 pkt matched: addr=0 len=1 (100 matched so far) |
| 16545 | **DUT** | IN  pkt #101 header: addr=0 len=1 -> channel 0 |
| 16555 | **DUT** | OUT ch0 pkt #101 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16565 | **DUT** | IN  pkt #101 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16565 | yapp monitor | RX pkt #101 on the input: addr=0 len=1 parity=good gap=17 |
| 16565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16570 | yapp driver | TX pkt #101 accepted by the DUT |
| 16570 | yapp driver | TX pkt #102: addr=0 len=1 parity=good delay=17 |
| 16575 | **DUT** | OUT ch0 pkt #101 done: 3 bytes in 3 cycles |
| 16575 | ch0 monitor | ch0 RX pkt #101: addr=0 len=1 parity=good |
| 16575 | scoreboard | ch0 pkt matched: addr=0 len=1 (101 matched so far) |
| 16745 | **DUT** | IN  pkt #102 header: addr=0 len=1 -> channel 0 |
| 16755 | **DUT** | OUT ch0 pkt #102 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16765 | **DUT** | IN  pkt #102 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16765 | yapp monitor | RX pkt #102 on the input: addr=0 len=1 parity=good gap=17 |
| 16765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16770 | yapp driver | TX pkt #102 accepted by the DUT |
| 16770 | yapp driver | TX pkt #103: addr=0 len=1 parity=good delay=17 |
| 16775 | **DUT** | OUT ch0 pkt #102 done: 3 bytes in 3 cycles |
| 16775 | ch0 monitor | ch0 RX pkt #102: addr=0 len=1 parity=good |
| 16775 | scoreboard | ch0 pkt matched: addr=0 len=1 (102 matched so far) |
| 16790 | ch0 driver | ch0: packet consumed (response delay 5) |
| 16945 | **DUT** | IN  pkt #103 header: addr=0 len=1 -> channel 0 |
| 16965 | **DUT** | IN  pkt #103 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16965 | yapp monitor | RX pkt #103 on the input: addr=0 len=1 parity=good gap=17 |
| 16965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16970 | yapp driver | TX pkt #103 accepted by the DUT |
| 16970 | yapp driver | TX pkt #104: addr=0 len=1 parity=good delay=2 |
| 16995 | **DUT** | IN  pkt #104 header: addr=0 len=1 -> channel 0 |
| 17015 | **DUT** | IN  pkt #104 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17015 | **DUT** | OUT ch0 pkt #103 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 17015 | yapp monitor | RX pkt #104 on the input: addr=0 len=1 parity=good gap=2 |
| 17015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17020 | yapp driver | TX pkt #104 accepted by the DUT |
| 17020 | yapp driver | TX pkt #105: addr=0 len=1 parity=good delay=17 |
| 17030 | ch0 driver | ch0: packet consumed (response delay 6) |
| 17085 | **DUT** | OUT ch0 pkt #103 done: 3 bytes in 8 cycles |
| 17085 | ch0 monitor | ch0 RX pkt #103: addr=0 len=1 parity=good |
| 17085 | scoreboard | ch0 pkt matched: addr=0 len=1 (103 matched so far) |
| 17095 | **DUT** | OUT ch0 pkt #104 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17115 | **DUT** | OUT ch0 pkt #104 done: 3 bytes in 3 cycles |
| 17115 | ch0 monitor | ch0 RX pkt #104: addr=0 len=1 parity=good |
| 17115 | scoreboard | ch0 pkt matched: addr=0 len=1 (104 matched so far) |
| 17140 | ch0 driver | ch0: packet consumed (response delay 4) |
| 17195 | **DUT** | IN  pkt #105 header: addr=0 len=1 -> channel 0 |
| 17215 | **DUT** | IN  pkt #105 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17215 | yapp monitor | RX pkt #105 on the input: addr=0 len=1 parity=good gap=17 |
| 17215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17220 | yapp driver | TX pkt #105 accepted by the DUT |
| 17220 | yapp driver | TX pkt #106: addr=0 len=1 parity=good delay=8 |
| 17255 | **DUT** | OUT ch0 pkt #105 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 17270 | ch0 driver | ch0: packet consumed (response delay 5) |
| 17305 | **DUT** | IN  pkt #106 header: addr=0 len=1 -> channel 0 |
| 17325 | **DUT** | IN  pkt #106 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17325 | yapp monitor | RX pkt #106 on the input: addr=0 len=1 parity=good gap=8 |
| 17325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17330 | yapp driver | TX pkt #106 accepted by the DUT |
| 17330 | yapp driver | TX pkt #107: addr=0 len=1 parity=good delay=13 |
| 17335 | **DUT** | OUT ch0 pkt #105 done: 3 bytes in 9 cycles |
| 17335 | ch0 monitor | ch0 RX pkt #105: addr=0 len=1 parity=good |
| 17335 | scoreboard | ch0 pkt matched: addr=0 len=1 (105 matched so far) |
| 17345 | **DUT** | OUT ch0 pkt #106 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17365 | **DUT** | OUT ch0 pkt #106 done: 3 bytes in 3 cycles |
| 17365 | ch0 monitor | ch0 RX pkt #106: addr=0 len=1 parity=good |
| 17365 | scoreboard | ch0 pkt matched: addr=0 len=1 (106 matched so far) |
| 17465 | **DUT** | IN  pkt #107 header: addr=0 len=1 -> channel 0 |
| 17475 | **DUT** | OUT ch0 pkt #107 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17485 | **DUT** | IN  pkt #107 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17485 | yapp monitor | RX pkt #107 on the input: addr=0 len=1 parity=good gap=13 |
| 17485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17490 | yapp driver | TX pkt #107 accepted by the DUT |
| 17490 | yapp driver | TX pkt #108: addr=0 len=1 parity=good delay=11 |
| 17495 | **DUT** | OUT ch0 pkt #107 done: 3 bytes in 3 cycles |
| 17495 | ch0 monitor | ch0 RX pkt #107: addr=0 len=1 parity=good |
| 17495 | scoreboard | ch0 pkt matched: addr=0 len=1 (107 matched so far) |
| 17605 | **DUT** | IN  pkt #108 header: addr=0 len=1 -> channel 0 |
| 17615 | **DUT** | OUT ch0 pkt #108 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17625 | **DUT** | IN  pkt #108 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17625 | yapp monitor | RX pkt #108 on the input: addr=0 len=1 parity=good gap=11 |
| 17625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17630 | ch0 driver | ch0: packet consumed (response delay 5) |
| 17630 | yapp driver | TX pkt #108 accepted by the DUT |
| 17630 | yapp driver | TX pkt #109: addr=0 len=1 parity=good delay=7 |
| 17705 | **DUT** | IN  pkt #109 header: addr=0 len=1 -> channel 0 |
| 17725 | **DUT** | IN  pkt #109 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17725 | **DUT** | OUT ch0 pkt #108 done: 3 bytes in 12 cycles |
| 17725 | ch0 monitor | ch0 RX pkt #108: addr=0 len=1 parity=good |
| 17725 | scoreboard | ch0 pkt matched: addr=0 len=1 (108 matched so far) |
| 17725 | yapp monitor | RX pkt #109 on the input: addr=0 len=1 parity=good gap=7 |
| 17725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17730 | yapp driver | TX pkt #109 accepted by the DUT |
| 17730 | yapp driver | TX pkt #110: addr=0 len=1 parity=good delay=16 |
| 17735 | **DUT** | OUT ch0 pkt #109 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17755 | **DUT** | OUT ch0 pkt #109 done: 3 bytes in 3 cycles |
| 17755 | ch0 monitor | ch0 RX pkt #109: addr=0 len=1 parity=good |
| 17755 | scoreboard | ch0 pkt matched: addr=0 len=1 (109 matched so far) |
| 17895 | **DUT** | IN  pkt #110 header: addr=0 len=1 -> channel 0 |
| 17905 | **DUT** | OUT ch0 pkt #110 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17915 | **DUT** | IN  pkt #110 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17915 | yapp monitor | RX pkt #110 on the input: addr=0 len=1 parity=good gap=16 |
| 17915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17920 | yapp driver | TX pkt #110 accepted by the DUT |
| 17920 | yapp driver | TX pkt #111: addr=0 len=1 parity=good delay=5 |
| 17925 | **DUT** | OUT ch0 pkt #110 done: 3 bytes in 3 cycles |
| 17925 | ch0 monitor | ch0 RX pkt #110: addr=0 len=1 parity=good |
| 17925 | scoreboard | ch0 pkt matched: addr=0 len=1 (110 matched so far) |
| 17975 | **DUT** | IN  pkt #111 header: addr=0 len=1 -> channel 0 |
| 17985 | **DUT** | OUT ch0 pkt #111 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17995 | **DUT** | IN  pkt #111 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17995 | yapp monitor | RX pkt #111 on the input: addr=0 len=1 parity=good gap=5 |
| 17995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18000 | yapp driver | TX pkt #111 accepted by the DUT |
| 18000 | yapp driver | TX pkt #112: addr=0 len=1 parity=good delay=2 |
| 18005 | **DUT** | OUT ch0 pkt #111 done: 3 bytes in 3 cycles |
| 18005 | ch0 monitor | ch0 RX pkt #111: addr=0 len=1 parity=good |
| 18005 | scoreboard | ch0 pkt matched: addr=0 len=1 (111 matched so far) |
| 18025 | **DUT** | IN  pkt #112 header: addr=0 len=1 -> channel 0 |
| 18035 | **DUT** | OUT ch0 pkt #112 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18045 | **DUT** | IN  pkt #112 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18045 | yapp monitor | RX pkt #112 on the input: addr=0 len=1 parity=good gap=2 |
| 18045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18050 | yapp driver | TX pkt #112 accepted by the DUT |
| 18050 | yapp driver | TX pkt #113: addr=0 len=1 parity=good delay=17 |
| 18055 | **DUT** | OUT ch0 pkt #112 done: 3 bytes in 3 cycles |
| 18055 | ch0 monitor | ch0 RX pkt #112: addr=0 len=1 parity=good |
| 18055 | scoreboard | ch0 pkt matched: addr=0 len=1 (112 matched so far) |
| 18180 | ch0 driver | ch0: packet consumed (response delay 8) |
| 18225 | **DUT** | IN  pkt #113 header: addr=0 len=1 -> channel 0 |
| 18245 | **DUT** | IN  pkt #113 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18245 | yapp monitor | RX pkt #113 on the input: addr=0 len=1 parity=good gap=17 |
| 18245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18250 | yapp driver | TX pkt #113 accepted by the DUT |
| 18250 | yapp driver | TX pkt #114: addr=0 len=1 parity=good delay=20 |
| 18315 | **DUT** | OUT ch0 pkt #113 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 18330 | ch0 driver | ch0: packet consumed (response delay 8) |
| 18445 | **DUT** | OUT ch0 pkt #113 done: 3 bytes in 14 cycles |
| 18445 | ch0 monitor | ch0 RX pkt #113: addr=0 len=1 parity=good |
| 18445 | scoreboard | ch0 pkt matched: addr=0 len=1 (113 matched so far) |
| 18455 | **DUT** | IN  pkt #114 header: addr=0 len=1 -> channel 0 |
| 18465 | **DUT** | OUT ch0 pkt #114 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18475 | **DUT** | IN  pkt #114 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18475 | yapp monitor | RX pkt #114 on the input: addr=0 len=1 parity=good gap=20 |
| 18475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18480 | yapp driver | TX pkt #114 accepted by the DUT |
| 18480 | yapp driver | TX pkt #115: addr=0 len=1 parity=good delay=18 |
| 18485 | **DUT** | OUT ch0 pkt #114 done: 3 bytes in 3 cycles |
| 18485 | ch0 monitor | ch0 RX pkt #114: addr=0 len=1 parity=good |
| 18485 | scoreboard | ch0 pkt matched: addr=0 len=1 (114 matched so far) |
| 18665 | **DUT** | IN  pkt #115 header: addr=0 len=1 -> channel 0 |
| 18675 | **DUT** | OUT ch0 pkt #115 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18685 | **DUT** | IN  pkt #115 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18685 | yapp monitor | RX pkt #115 on the input: addr=0 len=1 parity=good gap=18 |
| 18685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18690 | yapp driver | TX pkt #115 accepted by the DUT |
| 18690 | yapp driver | TX pkt #116: addr=0 len=1 parity=good delay=2 |
| 18695 | **DUT** | OUT ch0 pkt #115 done: 3 bytes in 3 cycles |
| 18695 | ch0 monitor | ch0 RX pkt #115: addr=0 len=1 parity=good |
| 18695 | scoreboard | ch0 pkt matched: addr=0 len=1 (115 matched so far) |
| 18715 | **DUT** | IN  pkt #116 header: addr=0 len=1 -> channel 0 |
| 18725 | **DUT** | OUT ch0 pkt #116 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18735 | **DUT** | IN  pkt #116 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18735 | yapp monitor | RX pkt #116 on the input: addr=0 len=1 parity=good gap=2 |
| 18735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18740 | yapp driver | TX pkt #116 accepted by the DUT |
| 18740 | yapp driver | TX pkt #117: addr=0 len=1 parity=good delay=20 |
| 18745 | **DUT** | OUT ch0 pkt #116 done: 3 bytes in 3 cycles |
| 18745 | ch0 monitor | ch0 RX pkt #116: addr=0 len=1 parity=good |
| 18745 | scoreboard | ch0 pkt matched: addr=0 len=1 (116 matched so far) |
| 18920 | ch0 driver | ch0: packet consumed (response delay 10) |
| 18945 | **DUT** | IN  pkt #117 header: addr=0 len=1 -> channel 0 |
| 18965 | **DUT** | IN  pkt #117 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18965 | yapp monitor | RX pkt #117 on the input: addr=0 len=1 parity=good gap=20 |
| 18965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18970 | yapp driver | TX pkt #117 accepted by the DUT |
| 18970 | yapp driver | TX pkt #118: addr=0 len=1 parity=good delay=19 |
| 19055 | **DUT** | OUT ch0 pkt #117 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 19070 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19165 | **DUT** | IN  pkt #118 header: addr=0 len=1 -> channel 0 |
| 19185 | **DUT** | IN  pkt #118 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19185 | **DUT** | OUT ch0 pkt #117 done: 3 bytes in 14 cycles |
| 19185 | ch0 monitor | ch0 RX pkt #117: addr=0 len=1 parity=good |
| 19185 | scoreboard | ch0 pkt matched: addr=0 len=1 (117 matched so far) |
| 19185 | yapp monitor | RX pkt #118 on the input: addr=0 len=1 parity=good gap=19 |
| 19185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19190 | yapp driver | TX pkt #118 accepted by the DUT |
| 19190 | yapp driver | TX pkt #119: addr=0 len=1 parity=good delay=14 |
| 19195 | **DUT** | OUT ch0 pkt #118 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19215 | **DUT** | OUT ch0 pkt #118 done: 3 bytes in 3 cycles |
| 19215 | ch0 monitor | ch0 RX pkt #118: addr=0 len=1 parity=good |
| 19215 | scoreboard | ch0 pkt matched: addr=0 len=1 (118 matched so far) |
| 19335 | **DUT** | IN  pkt #119 header: addr=0 len=1 -> channel 0 |
| 19340 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19355 | **DUT** | IN  pkt #119 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19355 | yapp monitor | RX pkt #119 on the input: addr=0 len=1 parity=good gap=14 |
| 19355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19360 | yapp driver | TX pkt #119 accepted by the DUT |
| 19360 | yapp driver | TX pkt #120: addr=0 len=1 parity=good delay=16 |
| 19375 | **DUT** | OUT ch0 pkt #119 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 19390 | ch0 driver | ch0: packet consumed (response delay 2) |
| 19505 | **DUT** | OUT ch0 pkt #119 done: 3 bytes in 14 cycles |
| 19505 | ch0 monitor | ch0 RX pkt #119: addr=0 len=1 parity=good |
| 19505 | scoreboard | ch0 pkt matched: addr=0 len=1 (119 matched so far) |
| 19525 | **DUT** | IN  pkt #120 header: addr=0 len=1 -> channel 0 |
| 19535 | **DUT** | OUT ch0 pkt #120 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19545 | **DUT** | IN  pkt #120 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19545 | yapp monitor | RX pkt #120 on the input: addr=0 len=1 parity=good gap=16 |
| 19545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19550 | yapp driver | TX pkt #120 accepted by the DUT |
| 19550 | yapp driver | TX pkt #121: addr=0 len=1 parity=good delay=20 |
| 19555 | **DUT** | OUT ch0 pkt #120 done: 3 bytes in 3 cycles |
| 19555 | ch0 monitor | ch0 RX pkt #120: addr=0 len=1 parity=good |
| 19555 | scoreboard | ch0 pkt matched: addr=0 len=1 (120 matched so far) |
| 19755 | **DUT** | IN  pkt #121 header: addr=0 len=1 -> channel 0 |
| 19765 | **DUT** | OUT ch0 pkt #121 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19775 | **DUT** | IN  pkt #121 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19775 | yapp monitor | RX pkt #121 on the input: addr=0 len=1 parity=good gap=20 |
| 19775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19780 | yapp driver | TX pkt #121 accepted by the DUT |
| 19780 | yapp driver | TX pkt #122: addr=0 len=1 parity=good delay=13 |
| 19785 | **DUT** | OUT ch0 pkt #121 done: 3 bytes in 3 cycles |
| 19785 | ch0 monitor | ch0 RX pkt #121: addr=0 len=1 parity=good |
| 19785 | scoreboard | ch0 pkt matched: addr=0 len=1 (121 matched so far) |
| 19910 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19915 | **DUT** | IN  pkt #122 header: addr=0 len=1 -> channel 0 |
| 19935 | **DUT** | IN  pkt #122 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19935 | yapp monitor | RX pkt #122 on the input: addr=0 len=1 parity=good gap=13 |
| 19935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19940 | yapp driver | TX pkt #122 accepted by the DUT |
| 19940 | yapp driver | TX pkt #123: addr=0 len=1 parity=good delay=1 |
| 19955 | **DUT** | IN  pkt #123 header: addr=0 len=1 -> channel 0 |
| 19975 | **DUT** | IN  pkt #123 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19975 | yapp monitor | RX pkt #123 on the input: addr=0 len=1 parity=good gap=1 |
| 19975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19980 | yapp driver | TX pkt #123 accepted by the DUT |
| 19980 | yapp driver | TX pkt #124: addr=0 len=1 parity=good delay=15 |
| 20025 | **DUT** | OUT ch0 pkt #122 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 20040 | ch0 driver | ch0: packet consumed (response delay 10) |
| 20085 | **DUT** | OUT ch0 pkt #122 done: 3 bytes in 7 cycles |
| 20085 | ch0 monitor | ch0 RX pkt #122: addr=0 len=1 parity=good |
| 20085 | scoreboard | ch0 pkt matched: addr=0 len=1 (122 matched so far) |
| 20095 | **DUT** | OUT ch0 pkt #123 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20115 | **DUT** | OUT ch0 pkt #123 done: 3 bytes in 3 cycles |
| 20115 | ch0 monitor | ch0 RX pkt #123: addr=0 len=1 parity=good |
| 20115 | scoreboard | ch0 pkt matched: addr=0 len=1 (123 matched so far) |
| 20135 | **DUT** | IN  pkt #124 header: addr=0 len=1 -> channel 0 |
| 20145 | **DUT** | OUT ch0 pkt #124 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20155 | **DUT** | IN  pkt #124 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20155 | yapp monitor | RX pkt #124 on the input: addr=0 len=1 parity=good gap=15 |
| 20155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20160 | yapp driver | TX pkt #124 accepted by the DUT |
| 20160 | yapp driver | TX pkt #125: addr=0 len=1 parity=good delay=3 |
| 20165 | **DUT** | OUT ch0 pkt #124 done: 3 bytes in 3 cycles |
| 20165 | ch0 monitor | ch0 RX pkt #124: addr=0 len=1 parity=good |
| 20165 | scoreboard | ch0 pkt matched: addr=0 len=1 (124 matched so far) |
| 20195 | **DUT** | IN  pkt #125 header: addr=0 len=1 -> channel 0 |
| 20205 | **DUT** | OUT ch0 pkt #125 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20215 | **DUT** | IN  pkt #125 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20215 | yapp monitor | RX pkt #125 on the input: addr=0 len=1 parity=good gap=3 |
| 20215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20220 | yapp driver | TX pkt #125 accepted by the DUT |
| 20220 | yapp driver | TX pkt #126: addr=0 len=1 parity=good delay=10 |
| 20225 | **DUT** | OUT ch0 pkt #125 done: 3 bytes in 3 cycles |
| 20225 | ch0 monitor | ch0 RX pkt #125: addr=0 len=1 parity=good |
| 20225 | scoreboard | ch0 pkt matched: addr=0 len=1 (125 matched so far) |
| 20325 | **DUT** | IN  pkt #126 header: addr=0 len=1 -> channel 0 |
| 20335 | **DUT** | OUT ch0 pkt #126 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20345 | **DUT** | IN  pkt #126 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20345 | yapp monitor | RX pkt #126 on the input: addr=0 len=1 parity=good gap=10 |
| 20345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20350 | yapp driver | TX pkt #126 accepted by the DUT |
| 20350 | yapp driver | TX pkt #127: addr=0 len=1 parity=good delay=3 |
| 20355 | **DUT** | OUT ch0 pkt #126 done: 3 bytes in 3 cycles |
| 20355 | ch0 monitor | ch0 RX pkt #126: addr=0 len=1 parity=good |
| 20355 | scoreboard | ch0 pkt matched: addr=0 len=1 (126 matched so far) |
| 20385 | **DUT** | IN  pkt #127 header: addr=0 len=1 -> channel 0 |
| 20395 | **DUT** | OUT ch0 pkt #127 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20405 | **DUT** | IN  pkt #127 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20405 | yapp monitor | RX pkt #127 on the input: addr=0 len=1 parity=good gap=3 |
| 20405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20410 | yapp driver | TX pkt #127 accepted by the DUT |
| 20410 | yapp driver | TX pkt #128: addr=0 len=1 parity=good delay=20 |
| 20415 | **DUT** | OUT ch0 pkt #127 done: 3 bytes in 3 cycles |
| 20415 | ch0 monitor | ch0 RX pkt #127: addr=0 len=1 parity=good |
| 20415 | scoreboard | ch0 pkt matched: addr=0 len=1 (127 matched so far) |
| 20460 | ch0 driver | ch0: packet consumed (response delay 3) |
| 20615 | **DUT** | IN  pkt #128 header: addr=0 len=1 -> channel 0 |
| 20635 | **DUT** | IN  pkt #128 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20635 | yapp monitor | RX pkt #128 on the input: addr=0 len=1 parity=good gap=20 |
| 20635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20640 | yapp driver | TX pkt #128 accepted by the DUT |
| 20640 | yapp driver | TX pkt #129: addr=0 len=1 parity=good delay=8 |
| 20715 | **DUT** | OUT ch0 pkt #128 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 20725 | **DUT** | IN  pkt #129 header: addr=0 len=1 -> channel 0 |
| 20730 | ch0 driver | ch0: packet consumed (response delay 9) |
| 20745 | **DUT** | IN  pkt #129 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20745 | yapp monitor | RX pkt #129 on the input: addr=0 len=1 parity=good gap=8 |
| 20745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20750 | yapp driver | TX pkt #129 accepted by the DUT |
| 20750 | yapp driver | TX pkt #130: addr=0 len=1 parity=good delay=19 |
| 20815 | **DUT** | OUT ch0 pkt #128 done: 3 bytes in 11 cycles |
| 20815 | ch0 monitor | ch0 RX pkt #128: addr=0 len=1 parity=good |
| 20815 | scoreboard | ch0 pkt matched: addr=0 len=1 (128 matched so far) |
| 20825 | **DUT** | OUT ch0 pkt #129 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20845 | **DUT** | OUT ch0 pkt #129 done: 3 bytes in 3 cycles |
| 20845 | ch0 monitor | ch0 RX pkt #129: addr=0 len=1 parity=good |
| 20845 | scoreboard | ch0 pkt matched: addr=0 len=1 (129 matched so far) |
| 20945 | **DUT** | IN  pkt #130 header: addr=0 len=1 -> channel 0 |
| 20955 | **DUT** | OUT ch0 pkt #130 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20965 | **DUT** | IN  pkt #130 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20965 | yapp monitor | RX pkt #130 on the input: addr=0 len=1 parity=good gap=19 |
| 20965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20970 | yapp driver | TX pkt #130 accepted by the DUT |
| 20970 | yapp driver | TX pkt #131: addr=0 len=1 parity=good delay=12 |
| 20975 | **DUT** | OUT ch0 pkt #130 done: 3 bytes in 3 cycles |
| 20975 | ch0 monitor | ch0 RX pkt #130: addr=0 len=1 parity=good |
| 20975 | scoreboard | ch0 pkt matched: addr=0 len=1 (130 matched so far) |
| 21095 | **DUT** | IN  pkt #131 header: addr=0 len=1 -> channel 0 |
| 21105 | **DUT** | OUT ch0 pkt #131 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21115 | **DUT** | IN  pkt #131 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21115 | yapp monitor | RX pkt #131 on the input: addr=0 len=1 parity=good gap=12 |
| 21115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21120 | yapp driver | TX pkt #131 accepted by the DUT |
| 21120 | yapp driver | TX pkt #132: addr=0 len=1 parity=good delay=5 |
| 21125 | **DUT** | OUT ch0 pkt #131 done: 3 bytes in 3 cycles |
| 21125 | ch0 monitor | ch0 RX pkt #131: addr=0 len=1 parity=good |
| 21125 | scoreboard | ch0 pkt matched: addr=0 len=1 (131 matched so far) |
| 21175 | **DUT** | IN  pkt #132 header: addr=0 len=1 -> channel 0 |
| 21180 | ch0 driver | ch0: packet consumed (response delay 7) |
| 21195 | **DUT** | IN  pkt #132 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21195 | yapp monitor | RX pkt #132 on the input: addr=0 len=1 parity=good gap=5 |
| 21195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21200 | yapp driver | TX pkt #132 accepted by the DUT |
| 21200 | yapp driver | TX pkt #133: addr=0 len=1 parity=good delay=4 |
| 21245 | **DUT** | IN  pkt #133 header: addr=0 len=1 -> channel 0 |
| 21265 | **DUT** | IN  pkt #133 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21265 | **DUT** | OUT ch0 pkt #132 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 21265 | yapp monitor | RX pkt #133 on the input: addr=0 len=1 parity=good gap=4 |
| 21265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21270 | yapp driver | TX pkt #133 accepted by the DUT |
| 21270 | yapp driver | TX pkt #134: addr=0 len=1 parity=good delay=7 |
| 21280 | ch0 driver | ch0: packet consumed (response delay 7) |
| 21345 | **DUT** | IN  pkt #134 header: addr=0 len=1 -> channel 0 |
| 21365 | **DUT** | IN  pkt #134 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21365 | yapp monitor | RX pkt #134 on the input: addr=0 len=1 parity=good gap=7 |
| 21365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21370 | yapp driver | TX pkt #134 accepted by the DUT |
| 21370 | yapp driver | TX pkt #135: addr=0 len=1 parity=good delay=18 |
| 21375 | **DUT** | OUT ch0 pkt #132 done: 3 bytes in 12 cycles |
| 21375 | ch0 monitor | ch0 RX pkt #132: addr=0 len=1 parity=good |
| 21375 | scoreboard | ch0 pkt matched: addr=0 len=1 (132 matched so far) |
| 21385 | **DUT** | OUT ch0 pkt #133 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21405 | **DUT** | OUT ch0 pkt #133 done: 3 bytes in 3 cycles |
| 21405 | ch0 monitor | ch0 RX pkt #133: addr=0 len=1 parity=good |
| 21405 | scoreboard | ch0 pkt matched: addr=0 len=1 (133 matched so far) |
| 21415 | **DUT** | OUT ch0 pkt #134 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21435 | **DUT** | OUT ch0 pkt #134 done: 3 bytes in 3 cycles |
| 21435 | ch0 monitor | ch0 RX pkt #134: addr=0 len=1 parity=good |
| 21435 | scoreboard | ch0 pkt matched: addr=0 len=1 (134 matched so far) |
| 21490 | ch0 driver | ch0: packet consumed (response delay 8) |
| 21555 | **DUT** | IN  pkt #135 header: addr=0 len=1 -> channel 0 |
| 21575 | **DUT** | IN  pkt #135 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21575 | **DUT** | OUT ch0 pkt #135 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 21575 | yapp monitor | RX pkt #135 on the input: addr=0 len=1 parity=good gap=18 |
| 21575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21580 | yapp driver | TX pkt #135 accepted by the DUT |
| 21580 | yapp driver | TX pkt #136: addr=0 len=1 parity=good delay=14 |
| 21590 | ch0 driver | ch0: packet consumed (response delay 1) |
| 21665 | **DUT** | OUT ch0 pkt #135 done: 3 bytes in 10 cycles |
| 21665 | ch0 monitor | ch0 RX pkt #135: addr=0 len=1 parity=good |
| 21665 | scoreboard | ch0 pkt matched: addr=0 len=1 (135 matched so far) |
| 21725 | **DUT** | IN  pkt #136 header: addr=0 len=1 -> channel 0 |
| 21735 | **DUT** | OUT ch0 pkt #136 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21745 | **DUT** | IN  pkt #136 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21745 | yapp monitor | RX pkt #136 on the input: addr=0 len=1 parity=good gap=14 |
| 21745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21750 | yapp driver | TX pkt #136 accepted by the DUT |
| 21750 | yapp driver | TX pkt #137: addr=0 len=1 parity=good delay=17 |
| 21755 | **DUT** | OUT ch0 pkt #136 done: 3 bytes in 3 cycles |
| 21755 | ch0 monitor | ch0 RX pkt #136: addr=0 len=1 parity=good |
| 21755 | scoreboard | ch0 pkt matched: addr=0 len=1 (136 matched so far) |
| 21925 | **DUT** | IN  pkt #137 header: addr=0 len=1 -> channel 0 |
| 21935 | **DUT** | OUT ch0 pkt #137 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21945 | **DUT** | IN  pkt #137 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21945 | yapp monitor | RX pkt #137 on the input: addr=0 len=1 parity=good gap=17 |
| 21945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21950 | yapp driver | TX pkt #137 accepted by the DUT |
| 21950 | yapp driver | TX pkt #138: addr=0 len=1 parity=good delay=9 |
| 21955 | **DUT** | OUT ch0 pkt #137 done: 3 bytes in 3 cycles |
| 21955 | ch0 monitor | ch0 RX pkt #137: addr=0 len=1 parity=good |
| 21955 | scoreboard | ch0 pkt matched: addr=0 len=1 (137 matched so far) |
| 22040 | ch0 driver | ch0: packet consumed (response delay 6) |
| 22045 | **DUT** | IN  pkt #138 header: addr=0 len=1 -> channel 0 |
| 22065 | **DUT** | IN  pkt #138 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22065 | yapp monitor | RX pkt #138 on the input: addr=0 len=1 parity=good gap=9 |
| 22065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22070 | yapp driver | TX pkt #138 accepted by the DUT |
| 22070 | yapp driver | TX pkt #139: addr=0 len=1 parity=good delay=17 |
| 22135 | **DUT** | OUT ch0 pkt #138 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 22150 | ch0 driver | ch0: packet consumed (response delay 8) |
| 22165 | **DUT** | OUT ch0 pkt #138 done: 3 bytes in 4 cycles |
| 22165 | ch0 monitor | ch0 RX pkt #138: addr=0 len=1 parity=good |
| 22165 | scoreboard | ch0 pkt matched: addr=0 len=1 (138 matched so far) |
| 22245 | **DUT** | IN  pkt #139 header: addr=0 len=1 -> channel 0 |
| 22255 | **DUT** | OUT ch0 pkt #139 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22265 | **DUT** | IN  pkt #139 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22265 | yapp monitor | RX pkt #139 on the input: addr=0 len=1 parity=good gap=17 |
| 22265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22270 | yapp driver | TX pkt #139 accepted by the DUT |
| 22270 | yapp driver | TX pkt #140: addr=0 len=1 parity=good delay=1 |
| 22275 | **DUT** | OUT ch0 pkt #139 done: 3 bytes in 3 cycles |
| 22275 | ch0 monitor | ch0 RX pkt #139: addr=0 len=1 parity=good |
| 22275 | scoreboard | ch0 pkt matched: addr=0 len=1 (139 matched so far) |
| 22285 | **DUT** | IN  pkt #140 header: addr=0 len=1 -> channel 0 |
| 22295 | **DUT** | OUT ch0 pkt #140 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22305 | **DUT** | IN  pkt #140 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22305 | yapp monitor | RX pkt #140 on the input: addr=0 len=1 parity=good gap=1 |
| 22305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22310 | yapp driver | TX pkt #140 accepted by the DUT |
| 22310 | yapp driver | TX pkt #141: addr=0 len=1 parity=good delay=20 |
| 22315 | **DUT** | OUT ch0 pkt #140 done: 3 bytes in 3 cycles |
| 22315 | ch0 monitor | ch0 RX pkt #140: addr=0 len=1 parity=good |
| 22315 | scoreboard | ch0 pkt matched: addr=0 len=1 (140 matched so far) |
| 22460 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22515 | **DUT** | IN  pkt #141 header: addr=0 len=1 -> channel 0 |
| 22535 | **DUT** | IN  pkt #141 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22535 | yapp monitor | RX pkt #141 on the input: addr=0 len=1 parity=good gap=20 |
| 22535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22540 | yapp driver | TX pkt #141 accepted by the DUT |
| 22540 | yapp driver | TX pkt #142: addr=0 len=1 parity=good delay=6 |
| 22605 | **DUT** | IN  pkt #142 header: addr=0 len=1 -> channel 0 |
| 22625 | **DUT** | IN  pkt #142 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22625 | **DUT** | OUT ch0 pkt #141 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 22625 | yapp monitor | RX pkt #142 on the input: addr=0 len=1 parity=good gap=6 |
| 22625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22630 | yapp driver | TX pkt #142 accepted by the DUT |
| 22630 | yapp driver | TX pkt #143: addr=0 len=1 parity=good delay=6 |
| 22640 | ch0 driver | ch0: packet consumed (response delay 10) |
| 22695 | **DUT** | IN  pkt #143 header: addr=0 len=1 -> channel 0 |
| 22715 | **DUT** | IN  pkt #143 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22715 | yapp monitor | RX pkt #143 on the input: addr=0 len=1 parity=good gap=6 |
| 22715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22720 | yapp driver | TX pkt #143 accepted by the DUT |
| 22720 | yapp driver | TX pkt #144: addr=0 len=1 parity=good delay=17 |
| 22725 | **DUT** | OUT ch0 pkt #141 done: 3 bytes in 11 cycles |
| 22725 | ch0 monitor | ch0 RX pkt #141: addr=0 len=1 parity=good |
| 22725 | scoreboard | ch0 pkt matched: addr=0 len=1 (141 matched so far) |
| 22735 | **DUT** | OUT ch0 pkt #142 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22755 | **DUT** | OUT ch0 pkt #142 done: 3 bytes in 3 cycles |
| 22755 | ch0 monitor | ch0 RX pkt #142: addr=0 len=1 parity=good |
| 22755 | scoreboard | ch0 pkt matched: addr=0 len=1 (142 matched so far) |
| 22765 | **DUT** | OUT ch0 pkt #143 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22785 | **DUT** | OUT ch0 pkt #143 done: 3 bytes in 3 cycles |
| 22785 | ch0 monitor | ch0 RX pkt #143: addr=0 len=1 parity=good |
| 22785 | scoreboard | ch0 pkt matched: addr=0 len=1 (143 matched so far) |
| 22895 | **DUT** | IN  pkt #144 header: addr=0 len=1 -> channel 0 |
| 22905 | **DUT** | OUT ch0 pkt #144 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22915 | **DUT** | IN  pkt #144 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22915 | yapp monitor | RX pkt #144 on the input: addr=0 len=1 parity=good gap=17 |
| 22915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22920 | yapp driver | TX pkt #144 accepted by the DUT |
| 22920 | yapp driver | TX pkt #145: addr=0 len=1 parity=good delay=18 |
| 22925 | **DUT** | OUT ch0 pkt #144 done: 3 bytes in 3 cycles |
| 22925 | ch0 monitor | ch0 RX pkt #144: addr=0 len=1 parity=good |
| 22925 | scoreboard | ch0 pkt matched: addr=0 len=1 (144 matched so far) |
| 23105 | **DUT** | IN  pkt #145 header: addr=0 len=1 -> channel 0 |
| 23115 | **DUT** | OUT ch0 pkt #145 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23125 | **DUT** | IN  pkt #145 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23125 | yapp monitor | RX pkt #145 on the input: addr=0 len=1 parity=good gap=18 |
| 23125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23130 | yapp driver | TX pkt #145 accepted by the DUT |
| 23130 | yapp driver | TX pkt #146: addr=0 len=1 parity=good delay=18 |
| 23135 | **DUT** | OUT ch0 pkt #145 done: 3 bytes in 3 cycles |
| 23135 | ch0 monitor | ch0 RX pkt #145: addr=0 len=1 parity=good |
| 23135 | scoreboard | ch0 pkt matched: addr=0 len=1 (145 matched so far) |
| 23315 | **DUT** | IN  pkt #146 header: addr=0 len=1 -> channel 0 |
| 23320 | ch0 driver | ch0: packet consumed (response delay 7) |
| 23335 | **DUT** | IN  pkt #146 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23335 | yapp monitor | RX pkt #146 on the input: addr=0 len=1 parity=good gap=18 |
| 23335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23340 | yapp driver | TX pkt #146 accepted by the DUT |
| 23340 | yapp driver | TX pkt #147: addr=0 len=1 parity=good delay=17 |
| 23435 | **DUT** | OUT ch0 pkt #146 start: addr=0 len=1 (receiver waited 11 cycle(s)) |
| 23450 | ch0 driver | ch0: packet consumed (response delay 10) |
| 23465 | **DUT** | OUT ch0 pkt #146 done: 3 bytes in 4 cycles |
| 23465 | ch0 monitor | ch0 RX pkt #146: addr=0 len=1 parity=good |
| 23465 | scoreboard | ch0 pkt matched: addr=0 len=1 (146 matched so far) |
| 23515 | **DUT** | IN  pkt #147 header: addr=0 len=1 -> channel 0 |
| 23525 | **DUT** | OUT ch0 pkt #147 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23535 | **DUT** | IN  pkt #147 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23535 | yapp monitor | RX pkt #147 on the input: addr=0 len=1 parity=good gap=17 |
| 23535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23540 | yapp driver | TX pkt #147 accepted by the DUT |
| 23540 | yapp driver | TX pkt #148: addr=0 len=1 parity=good delay=7 |
| 23545 | **DUT** | OUT ch0 pkt #147 done: 3 bytes in 3 cycles |
| 23545 | ch0 monitor | ch0 RX pkt #147: addr=0 len=1 parity=good |
| 23545 | scoreboard | ch0 pkt matched: addr=0 len=1 (147 matched so far) |
| 23615 | **DUT** | IN  pkt #148 header: addr=0 len=1 -> channel 0 |
| 23625 | **DUT** | OUT ch0 pkt #148 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23635 | **DUT** | IN  pkt #148 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23635 | yapp monitor | RX pkt #148 on the input: addr=0 len=1 parity=good gap=7 |
| 23635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23640 | yapp driver | TX pkt #148 accepted by the DUT |
| 23640 | yapp driver | TX pkt #149: addr=0 len=1 parity=good delay=17 |
| 23645 | **DUT** | OUT ch0 pkt #148 done: 3 bytes in 3 cycles |
| 23645 | ch0 monitor | ch0 RX pkt #148: addr=0 len=1 parity=good |
| 23645 | scoreboard | ch0 pkt matched: addr=0 len=1 (148 matched so far) |
| 23815 | **DUT** | IN  pkt #149 header: addr=0 len=1 -> channel 0 |
| 23825 | **DUT** | OUT ch0 pkt #149 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23835 | **DUT** | IN  pkt #149 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23835 | yapp monitor | RX pkt #149 on the input: addr=0 len=1 parity=good gap=17 |
| 23835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23840 | yapp driver | TX pkt #149 accepted by the DUT |
| 23840 | yapp driver | TX pkt #150: addr=0 len=1 parity=good delay=19 |
| 23845 | **DUT** | OUT ch0 pkt #149 done: 3 bytes in 3 cycles |
| 23845 | ch0 monitor | ch0 RX pkt #149: addr=0 len=1 parity=good |
| 23845 | scoreboard | ch0 pkt matched: addr=0 len=1 (149 matched so far) |
| 23870 | ch0 driver | ch0: packet consumed (response delay 0) |
| 24035 | **DUT** | IN  pkt #150 header: addr=0 len=1 -> channel 0 |
| 24055 | **DUT** | IN  pkt #150 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24055 | yapp monitor | RX pkt #150 on the input: addr=0 len=1 parity=good gap=19 |
| 24055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24060 | yapp driver | TX pkt #150 accepted by the DUT |
| 24060 | yapp driver | TX pkt #151: addr=0 len=1 parity=good delay=17 |
| 24145 | **DUT** | OUT ch0 pkt #150 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 24160 | ch0 driver | ch0: packet consumed (response delay 10) |
| 24235 | **DUT** | IN  pkt #151 header: addr=0 len=1 -> channel 0 |
| 24255 | **DUT** | IN  pkt #151 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24255 | yapp monitor | RX pkt #151 on the input: addr=0 len=1 parity=good gap=17 |
| 24255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24260 | yapp driver | TX pkt #151 accepted by the DUT |
| 24260 | yapp driver | TX pkt #152: addr=0 len=1 parity=good delay=7 |
| 24275 | **DUT** | OUT ch0 pkt #150 done: 3 bytes in 14 cycles |
| 24275 | ch0 monitor | ch0 RX pkt #150: addr=0 len=1 parity=good |
| 24275 | scoreboard | ch0 pkt matched: addr=0 len=1 (150 matched so far) |
| 24285 | **DUT** | OUT ch0 pkt #151 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24305 | **DUT** | OUT ch0 pkt #151 done: 3 bytes in 3 cycles |
| 24305 | ch0 monitor | ch0 RX pkt #151: addr=0 len=1 parity=good |
| 24305 | scoreboard | ch0 pkt matched: addr=0 len=1 (151 matched so far) |
| 24335 | **DUT** | IN  pkt #152 header: addr=0 len=1 -> channel 0 |
| 24345 | **DUT** | OUT ch0 pkt #152 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24355 | **DUT** | IN  pkt #152 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24355 | yapp monitor | RX pkt #152 on the input: addr=0 len=1 parity=good gap=7 |
| 24355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24360 | yapp driver | TX pkt #152 accepted by the DUT |
| 24360 | yapp driver | TX pkt #153: addr=0 len=1 parity=good delay=20 |
| 24365 | **DUT** | OUT ch0 pkt #152 done: 3 bytes in 3 cycles |
| 24365 | ch0 monitor | ch0 RX pkt #152: addr=0 len=1 parity=good |
| 24365 | scoreboard | ch0 pkt matched: addr=0 len=1 (152 matched so far) |
| 24530 | ch0 driver | ch0: packet consumed (response delay 10) |
| 24565 | **DUT** | IN  pkt #153 header: addr=0 len=1 -> channel 0 |
| 24585 | **DUT** | IN  pkt #153 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24585 | yapp monitor | RX pkt #153 on the input: addr=0 len=1 parity=good gap=20 |
| 24585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24590 | yapp driver | TX pkt #153 accepted by the DUT |
| 24590 | yapp driver | TX pkt #154: addr=0 len=1 parity=good delay=16 |
| 24675 | **DUT** | OUT ch0 pkt #153 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 24690 | ch0 driver | ch0: packet consumed (response delay 10) |
| 24705 | **DUT** | OUT ch0 pkt #153 done: 3 bytes in 4 cycles |
| 24705 | ch0 monitor | ch0 RX pkt #153: addr=0 len=1 parity=good |
| 24705 | scoreboard | ch0 pkt matched: addr=0 len=1 (153 matched so far) |
| 24755 | **DUT** | IN  pkt #154 header: addr=0 len=1 -> channel 0 |
| 24765 | **DUT** | OUT ch0 pkt #154 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24775 | **DUT** | IN  pkt #154 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24775 | yapp monitor | RX pkt #154 on the input: addr=0 len=1 parity=good gap=16 |
| 24775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24780 | yapp driver | TX pkt #154 accepted by the DUT |
| 24780 | yapp driver | TX pkt #155: addr=0 len=1 parity=good delay=11 |
| 24785 | **DUT** | OUT ch0 pkt #154 done: 3 bytes in 3 cycles |
| 24785 | ch0 monitor | ch0 RX pkt #154: addr=0 len=1 parity=good |
| 24785 | scoreboard | ch0 pkt matched: addr=0 len=1 (154 matched so far) |
| 24850 | ch0 driver | ch0: packet consumed (response delay 0) |
| 24895 | **DUT** | IN  pkt #155 header: addr=0 len=1 -> channel 0 |
| 24915 | **DUT** | IN  pkt #155 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24915 | yapp monitor | RX pkt #155 on the input: addr=0 len=1 parity=good gap=11 |
| 24915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24920 | yapp driver | TX pkt #155 accepted by the DUT |
| 24920 | yapp driver | TX pkt #156: addr=0 len=1 parity=good delay=5 |
| 24965 | **DUT** | OUT ch0 pkt #155 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 24975 | **DUT** | IN  pkt #156 header: addr=0 len=1 -> channel 0 |
| 24980 | ch0 driver | ch0: packet consumed (response delay 6) |
| 24995 | **DUT** | IN  pkt #156 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24995 | yapp monitor | RX pkt #156 on the input: addr=0 len=1 parity=good gap=5 |
| 24995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25000 | yapp driver | TX pkt #156 accepted by the DUT |
| 25000 | yapp driver | TX pkt #157: addr=0 len=1 parity=good delay=20 |
| 25025 | **DUT** | OUT ch0 pkt #155 done: 3 bytes in 7 cycles |
| 25025 | ch0 monitor | ch0 RX pkt #155: addr=0 len=1 parity=good |
| 25025 | scoreboard | ch0 pkt matched: addr=0 len=1 (155 matched so far) |
| 25035 | **DUT** | OUT ch0 pkt #156 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25055 | **DUT** | OUT ch0 pkt #156 done: 3 bytes in 3 cycles |
| 25055 | ch0 monitor | ch0 RX pkt #156: addr=0 len=1 parity=good |
| 25055 | scoreboard | ch0 pkt matched: addr=0 len=1 (156 matched so far) |
| 25205 | **DUT** | IN  pkt #157 header: addr=0 len=1 -> channel 0 |
| 25215 | **DUT** | OUT ch0 pkt #157 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25225 | **DUT** | IN  pkt #157 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25225 | yapp monitor | RX pkt #157 on the input: addr=0 len=1 parity=good gap=20 |
| 25225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25230 | yapp driver | TX pkt #157 accepted by the DUT |
| 25230 | yapp driver | TX pkt #158: addr=0 len=1 parity=good delay=14 |
| 25235 | **DUT** | OUT ch0 pkt #157 done: 3 bytes in 3 cycles |
| 25235 | ch0 monitor | ch0 RX pkt #157: addr=0 len=1 parity=good |
| 25235 | scoreboard | ch0 pkt matched: addr=0 len=1 (157 matched so far) |
| 25375 | **DUT** | IN  pkt #158 header: addr=0 len=1 -> channel 0 |
| 25385 | **DUT** | OUT ch0 pkt #158 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25395 | **DUT** | IN  pkt #158 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25395 | yapp monitor | RX pkt #158 on the input: addr=0 len=1 parity=good gap=14 |
| 25395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25400 | yapp driver | TX pkt #158 accepted by the DUT |
| 25400 | yapp driver | TX pkt #159: addr=0 len=1 parity=good delay=6 |
| 25405 | **DUT** | OUT ch0 pkt #158 done: 3 bytes in 3 cycles |
| 25405 | ch0 monitor | ch0 RX pkt #158: addr=0 len=1 parity=good |
| 25405 | scoreboard | ch0 pkt matched: addr=0 len=1 (158 matched so far) |
| 25465 | **DUT** | IN  pkt #159 header: addr=0 len=1 -> channel 0 |
| 25475 | **DUT** | OUT ch0 pkt #159 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25485 | **DUT** | IN  pkt #159 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25485 | yapp monitor | RX pkt #159 on the input: addr=0 len=1 parity=good gap=6 |
| 25485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25490 | yapp driver | TX pkt #159 accepted by the DUT |
| 25490 | yapp driver | TX pkt #160: addr=0 len=1 parity=good delay=17 |
| 25495 | **DUT** | OUT ch0 pkt #159 done: 3 bytes in 3 cycles |
| 25495 | ch0 monitor | ch0 RX pkt #159: addr=0 len=1 parity=good |
| 25495 | scoreboard | ch0 pkt matched: addr=0 len=1 (159 matched so far) |
| 25590 | ch0 driver | ch0: packet consumed (response delay 3) |
| 25665 | **DUT** | IN  pkt #160 header: addr=0 len=1 -> channel 0 |
| 25685 | **DUT** | IN  pkt #160 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25685 | yapp monitor | RX pkt #160 on the input: addr=0 len=1 parity=good gap=17 |
| 25685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25690 | yapp driver | TX pkt #160 accepted by the DUT |
| 25690 | yapp driver | TX pkt #161: addr=0 len=1 parity=good delay=2 |
| 25715 | **DUT** | IN  pkt #161 header: addr=0 len=1 -> channel 0 |
| 25735 | **DUT** | IN  pkt #161 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25735 | yapp monitor | RX pkt #161 on the input: addr=0 len=1 parity=good gap=2 |
| 25735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25740 | yapp driver | TX pkt #161 accepted by the DUT |
| 25740 | yapp driver | TX pkt #162: addr=0 len=1 parity=good delay=11 |
| 25775 | **DUT** | OUT ch0 pkt #160 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 25790 | ch0 driver | ch0: packet consumed (response delay 10) |
| 25855 | **DUT** | IN  pkt #162 header: addr=0 len=1 -> channel 0 |
| 25875 | **DUT** | IN  pkt #162 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25875 | yapp monitor | RX pkt #162 on the input: addr=0 len=1 parity=good gap=11 |
| 25875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25880 | yapp driver | TX pkt #162 accepted by the DUT |
| 25880 | yapp driver | TX pkt #163: addr=0 len=1 parity=good delay=20 |
| 25895 | **DUT** | OUT ch0 pkt #160 done: 3 bytes in 13 cycles |
| 25895 | ch0 monitor | ch0 RX pkt #160: addr=0 len=1 parity=good |
| 25895 | scoreboard | ch0 pkt matched: addr=0 len=1 (160 matched so far) |
| 25905 | **DUT** | OUT ch0 pkt #161 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25925 | **DUT** | OUT ch0 pkt #161 done: 3 bytes in 3 cycles |
| 25925 | ch0 monitor | ch0 RX pkt #161: addr=0 len=1 parity=good |
| 25925 | scoreboard | ch0 pkt matched: addr=0 len=1 (161 matched so far) |
| 25935 | **DUT** | OUT ch0 pkt #162 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25955 | **DUT** | OUT ch0 pkt #162 done: 3 bytes in 3 cycles |
| 25955 | ch0 monitor | ch0 RX pkt #162: addr=0 len=1 parity=good |
| 25955 | scoreboard | ch0 pkt matched: addr=0 len=1 (162 matched so far) |
| 26070 | ch0 driver | ch0: packet consumed (response delay 9) |
| 26085 | **DUT** | IN  pkt #163 header: addr=0 len=1 -> channel 0 |
| 26095 | **DUT** | OUT ch0 pkt #163 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26105 | **DUT** | IN  pkt #163 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26105 | yapp monitor | RX pkt #163 on the input: addr=0 len=1 parity=good gap=20 |
| 26105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26110 | ch0 driver | ch0: packet consumed (response delay 0) |
| 26110 | yapp driver | TX pkt #163 accepted by the DUT |
| 26110 | yapp driver | TX pkt #164: addr=0 len=1 parity=good delay=18 |
| 26225 | **DUT** | OUT ch0 pkt #163 done: 3 bytes in 14 cycles |
| 26225 | ch0 monitor | ch0 RX pkt #163: addr=0 len=1 parity=good |
| 26225 | scoreboard | ch0 pkt matched: addr=0 len=1 (163 matched so far) |
| 26260 | ch0 driver | ch0: packet consumed (response delay 10) |
| 26295 | **DUT** | IN  pkt #164 header: addr=0 len=1 -> channel 0 |
| 26315 | **DUT** | IN  pkt #164 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26315 | yapp monitor | RX pkt #164 on the input: addr=0 len=1 parity=good gap=18 |
| 26315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26320 | yapp driver | TX pkt #164 accepted by the DUT |
| 26320 | yapp driver | TX pkt #165: addr=0 len=1 parity=good delay=20 |
| 26375 | **DUT** | OUT ch0 pkt #164 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 26390 | ch0 driver | ch0: packet consumed (response delay 7) |
| 26505 | **DUT** | OUT ch0 pkt #164 done: 3 bytes in 14 cycles |
| 26505 | ch0 monitor | ch0 RX pkt #164: addr=0 len=1 parity=good |
| 26505 | scoreboard | ch0 pkt matched: addr=0 len=1 (164 matched so far) |
| 26525 | **DUT** | IN  pkt #165 header: addr=0 len=1 -> channel 0 |
| 26535 | **DUT** | OUT ch0 pkt #165 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26545 | **DUT** | IN  pkt #165 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26545 | yapp monitor | RX pkt #165 on the input: addr=0 len=1 parity=good gap=20 |
| 26545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26550 | yapp driver | TX pkt #165 accepted by the DUT |
| 26550 | yapp driver | TX pkt #166: addr=0 len=1 parity=good delay=7 |
| 26555 | **DUT** | OUT ch0 pkt #165 done: 3 bytes in 3 cycles |
| 26555 | ch0 monitor | ch0 RX pkt #165: addr=0 len=1 parity=good |
| 26555 | scoreboard | ch0 pkt matched: addr=0 len=1 (165 matched so far) |
| 26625 | **DUT** | IN  pkt #166 header: addr=0 len=1 -> channel 0 |
| 26635 | **DUT** | OUT ch0 pkt #166 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26645 | **DUT** | IN  pkt #166 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26645 | yapp monitor | RX pkt #166 on the input: addr=0 len=1 parity=good gap=7 |
| 26645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26650 | yapp driver | TX pkt #166 accepted by the DUT |
| 26650 | yapp driver | TX pkt #167: addr=0 len=1 parity=good delay=7 |
| 26655 | **DUT** | OUT ch0 pkt #166 done: 3 bytes in 3 cycles |
| 26655 | ch0 monitor | ch0 RX pkt #166: addr=0 len=1 parity=good |
| 26655 | scoreboard | ch0 pkt matched: addr=0 len=1 (166 matched so far) |
| 26725 | **DUT** | IN  pkt #167 header: addr=0 len=1 -> channel 0 |
| 26735 | **DUT** | OUT ch0 pkt #167 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26745 | **DUT** | IN  pkt #167 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26745 | yapp monitor | RX pkt #167 on the input: addr=0 len=1 parity=good gap=7 |
| 26745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26750 | yapp driver | TX pkt #167 accepted by the DUT |
| 26750 | yapp driver | TX pkt #168: addr=0 len=1 parity=good delay=20 |
| 26755 | **DUT** | OUT ch0 pkt #167 done: 3 bytes in 3 cycles |
| 26755 | ch0 monitor | ch0 RX pkt #167: addr=0 len=1 parity=good |
| 26755 | scoreboard | ch0 pkt matched: addr=0 len=1 (167 matched so far) |
| 26820 | ch0 driver | ch0: packet consumed (response delay 10) |
| 26955 | **DUT** | IN  pkt #168 header: addr=0 len=1 -> channel 0 |
| 26975 | **DUT** | IN  pkt #168 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26975 | yapp monitor | RX pkt #168 on the input: addr=0 len=1 parity=good gap=20 |
| 26975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26980 | yapp driver | TX pkt #168 accepted by the DUT |
| 26980 | yapp driver | TX pkt #169: addr=0 len=1 parity=good delay=13 |
| 26985 | **DUT** | OUT ch0 pkt #168 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 27000 | ch0 driver | ch0: packet consumed (response delay 2) |
| 27055 | **DUT** | OUT ch0 pkt #168 done: 3 bytes in 8 cycles |
| 27055 | ch0 monitor | ch0 RX pkt #168: addr=0 len=1 parity=good |
| 27055 | scoreboard | ch0 pkt matched: addr=0 len=1 (168 matched so far) |
| 27115 | **DUT** | IN  pkt #169 header: addr=0 len=1 -> channel 0 |
| 27125 | **DUT** | OUT ch0 pkt #169 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27135 | **DUT** | IN  pkt #169 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27135 | yapp monitor | RX pkt #169 on the input: addr=0 len=1 parity=good gap=13 |
| 27135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27140 | yapp driver | TX pkt #169 accepted by the DUT |
| 27140 | yapp driver | TX pkt #170: addr=0 len=1 parity=good delay=20 |
| 27145 | **DUT** | OUT ch0 pkt #169 done: 3 bytes in 3 cycles |
| 27145 | ch0 monitor | ch0 RX pkt #169: addr=0 len=1 parity=good |
| 27145 | scoreboard | ch0 pkt matched: addr=0 len=1 (169 matched so far) |
| 27300 | ch0 driver | ch0: packet consumed (response delay 4) |
| 27345 | **DUT** | IN  pkt #170 header: addr=0 len=1 -> channel 0 |
| 27365 | **DUT** | IN  pkt #170 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27365 | yapp monitor | RX pkt #170 on the input: addr=0 len=1 parity=good gap=20 |
| 27365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27370 | yapp driver | TX pkt #170 accepted by the DUT |
| 27370 | yapp driver | TX pkt #171: addr=0 len=1 parity=good delay=7 |
| 27435 | **DUT** | OUT ch0 pkt #170 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 27445 | **DUT** | IN  pkt #171 header: addr=0 len=1 -> channel 0 |
| 27450 | ch0 driver | ch0: packet consumed (response delay 8) |
| 27465 | **DUT** | IN  pkt #171 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27465 | yapp monitor | RX pkt #171 on the input: addr=0 len=1 parity=good gap=7 |
| 27465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27470 | yapp driver | TX pkt #171 accepted by the DUT |
| 27470 | yapp driver | TX pkt #172: addr=0 len=1 parity=good delay=14 |
| 27565 | **DUT** | OUT ch0 pkt #170 done: 3 bytes in 14 cycles |
| 27565 | ch0 monitor | ch0 RX pkt #170: addr=0 len=1 parity=good |
| 27565 | scoreboard | ch0 pkt matched: addr=0 len=1 (170 matched so far) |
| 27575 | **DUT** | OUT ch0 pkt #171 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27595 | **DUT** | OUT ch0 pkt #171 done: 3 bytes in 3 cycles |
| 27595 | ch0 monitor | ch0 RX pkt #171: addr=0 len=1 parity=good |
| 27595 | scoreboard | ch0 pkt matched: addr=0 len=1 (171 matched so far) |
| 27615 | **DUT** | IN  pkt #172 header: addr=0 len=1 -> channel 0 |
| 27625 | **DUT** | OUT ch0 pkt #172 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27635 | **DUT** | IN  pkt #172 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27635 | yapp monitor | RX pkt #172 on the input: addr=0 len=1 parity=good gap=14 |
| 27635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27640 | yapp driver | TX pkt #172 accepted by the DUT |
| 27640 | yapp driver | TX pkt #173: addr=0 len=1 parity=good delay=1 |
| 27645 | **DUT** | OUT ch0 pkt #172 done: 3 bytes in 3 cycles |
| 27645 | ch0 monitor | ch0 RX pkt #172: addr=0 len=1 parity=good |
| 27645 | scoreboard | ch0 pkt matched: addr=0 len=1 (172 matched so far) |
| 27655 | **DUT** | IN  pkt #173 header: addr=0 len=1 -> channel 0 |
| 27665 | **DUT** | OUT ch0 pkt #173 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27675 | **DUT** | IN  pkt #173 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27675 | yapp monitor | RX pkt #173 on the input: addr=0 len=1 parity=good gap=1 |
| 27675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27680 | yapp driver | TX pkt #173 accepted by the DUT |
| 27680 | yapp driver | TX pkt #174: addr=0 len=1 parity=good delay=20 |
| 27685 | **DUT** | OUT ch0 pkt #173 done: 3 bytes in 3 cycles |
| 27685 | ch0 monitor | ch0 RX pkt #173: addr=0 len=1 parity=good |
| 27685 | scoreboard | ch0 pkt matched: addr=0 len=1 (173 matched so far) |
| 27885 | **DUT** | IN  pkt #174 header: addr=0 len=1 -> channel 0 |
| 27895 | **DUT** | OUT ch0 pkt #174 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27905 | **DUT** | IN  pkt #174 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27905 | yapp monitor | RX pkt #174 on the input: addr=0 len=1 parity=good gap=20 |
| 27905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27910 | yapp driver | TX pkt #174 accepted by the DUT |
| 27910 | yapp driver | TX pkt #175: addr=0 len=1 parity=good delay=16 |
| 27915 | **DUT** | OUT ch0 pkt #174 done: 3 bytes in 3 cycles |
| 27915 | ch0 monitor | ch0 RX pkt #174: addr=0 len=1 parity=good |
| 27915 | scoreboard | ch0 pkt matched: addr=0 len=1 (174 matched so far) |
| 28050 | ch0 driver | ch0: packet consumed (response delay 10) |
| 28075 | **DUT** | IN  pkt #175 header: addr=0 len=1 -> channel 0 |
| 28095 | **DUT** | IN  pkt #175 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28095 | yapp monitor | RX pkt #175 on the input: addr=0 len=1 parity=good gap=16 |
| 28095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28100 | yapp driver | TX pkt #175 accepted by the DUT |
| 28100 | yapp driver | TX pkt #176: addr=0 len=1 parity=good delay=11 |
| 28105 | **DUT** | OUT ch0 pkt #175 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 28120 | ch0 driver | ch0: packet consumed (response delay 2) |
| 28185 | **DUT** | OUT ch0 pkt #175 done: 3 bytes in 9 cycles |
| 28185 | ch0 monitor | ch0 RX pkt #175: addr=0 len=1 parity=good |
| 28185 | scoreboard | ch0 pkt matched: addr=0 len=1 (175 matched so far) |
| 28215 | **DUT** | IN  pkt #176 header: addr=0 len=1 -> channel 0 |
| 28225 | **DUT** | OUT ch0 pkt #176 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28235 | **DUT** | IN  pkt #176 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28235 | yapp monitor | RX pkt #176 on the input: addr=0 len=1 parity=good gap=11 |
| 28235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28240 | yapp driver | TX pkt #176 accepted by the DUT |
| 28240 | yapp driver | TX pkt #177: addr=0 len=1 parity=good delay=16 |
| 28245 | **DUT** | OUT ch0 pkt #176 done: 3 bytes in 3 cycles |
| 28245 | ch0 monitor | ch0 RX pkt #176: addr=0 len=1 parity=good |
| 28245 | scoreboard | ch0 pkt matched: addr=0 len=1 (176 matched so far) |
| 28405 | **DUT** | IN  pkt #177 header: addr=0 len=1 -> channel 0 |
| 28415 | **DUT** | OUT ch0 pkt #177 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28425 | **DUT** | IN  pkt #177 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28425 | yapp monitor | RX pkt #177 on the input: addr=0 len=1 parity=good gap=16 |
| 28425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28430 | yapp driver | TX pkt #177 accepted by the DUT |
| 28430 | yapp driver | TX pkt #178: addr=0 len=1 parity=good delay=17 |
| 28435 | **DUT** | OUT ch0 pkt #177 done: 3 bytes in 3 cycles |
| 28435 | ch0 monitor | ch0 RX pkt #177: addr=0 len=1 parity=good |
| 28435 | scoreboard | ch0 pkt matched: addr=0 len=1 (177 matched so far) |
| 28460 | ch0 driver | ch0: packet consumed (response delay 5) |
| 28605 | **DUT** | IN  pkt #178 header: addr=0 len=1 -> channel 0 |
| 28625 | **DUT** | IN  pkt #178 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28625 | yapp monitor | RX pkt #178 on the input: addr=0 len=1 parity=good gap=17 |
| 28625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28630 | yapp driver | TX pkt #178 accepted by the DUT |
| 28630 | yapp driver | TX pkt #179: addr=0 len=1 parity=good delay=1 |
| 28645 | **DUT** | IN  pkt #179 header: addr=0 len=1 -> channel 0 |
| 28645 | **DUT** | OUT ch0 pkt #178 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 28660 | ch0 driver | ch0: packet consumed (response delay 3) |
| 28665 | **DUT** | IN  pkt #179 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28665 | yapp monitor | RX pkt #179 on the input: addr=0 len=1 parity=good gap=1 |
| 28665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28670 | yapp driver | TX pkt #179 accepted by the DUT |
| 28670 | yapp driver | TX pkt #180: addr=0 len=1 parity=good delay=7 |
| 28685 | **DUT** | OUT ch0 pkt #178 done: 3 bytes in 5 cycles |
| 28685 | ch0 monitor | ch0 RX pkt #178: addr=0 len=1 parity=good |
| 28685 | scoreboard | ch0 pkt matched: addr=0 len=1 (178 matched so far) |
| 28695 | **DUT** | OUT ch0 pkt #179 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28715 | **DUT** | OUT ch0 pkt #179 done: 3 bytes in 3 cycles |
| 28715 | ch0 monitor | ch0 RX pkt #179: addr=0 len=1 parity=good |
| 28715 | scoreboard | ch0 pkt matched: addr=0 len=1 (179 matched so far) |
| 28745 | **DUT** | IN  pkt #180 header: addr=0 len=1 -> channel 0 |
| 28755 | **DUT** | OUT ch0 pkt #180 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28765 | **DUT** | IN  pkt #180 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28765 | yapp monitor | RX pkt #180 on the input: addr=0 len=1 parity=good gap=7 |
| 28765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28770 | yapp driver | TX pkt #180 accepted by the DUT |
| 28770 | yapp driver | TX pkt #181: addr=0 len=1 parity=good delay=16 |
| 28775 | **DUT** | OUT ch0 pkt #180 done: 3 bytes in 3 cycles |
| 28775 | ch0 monitor | ch0 RX pkt #180: addr=0 len=1 parity=good |
| 28775 | scoreboard | ch0 pkt matched: addr=0 len=1 (180 matched so far) |
| 28935 | **DUT** | IN  pkt #181 header: addr=0 len=1 -> channel 0 |
| 28940 | ch0 driver | ch0: packet consumed (response delay 1) |
| 28955 | **DUT** | IN  pkt #181 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28955 | yapp monitor | RX pkt #181 on the input: addr=0 len=1 parity=good gap=16 |
| 28955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28960 | yapp driver | TX pkt #181 accepted by the DUT |
| 28960 | yapp driver | TX pkt #182: addr=0 len=1 parity=good delay=1 |
| 28975 | **DUT** | IN  pkt #182 header: addr=0 len=1 -> channel 0 |
| 28995 | **DUT** | IN  pkt #182 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28995 | yapp monitor | RX pkt #182 on the input: addr=0 len=1 parity=good gap=1 |
| 28995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29000 | yapp driver | TX pkt #182 accepted by the DUT |
| 29000 | yapp driver | TX pkt #183: addr=0 len=1 parity=good delay=18 |
| 29045 | **DUT** | OUT ch0 pkt #181 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 29060 | ch0 driver | ch0: packet consumed (response delay 9) |
| 29095 | **DUT** | OUT ch0 pkt #181 done: 3 bytes in 6 cycles |
| 29095 | ch0 monitor | ch0 RX pkt #181: addr=0 len=1 parity=good |
| 29095 | scoreboard | ch0 pkt matched: addr=0 len=1 (181 matched so far) |
| 29105 | **DUT** | OUT ch0 pkt #182 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29125 | **DUT** | OUT ch0 pkt #182 done: 3 bytes in 3 cycles |
| 29125 | ch0 monitor | ch0 RX pkt #182: addr=0 len=1 parity=good |
| 29125 | scoreboard | ch0 pkt matched: addr=0 len=1 (182 matched so far) |
| 29185 | **DUT** | IN  pkt #183 header: addr=0 len=1 -> channel 0 |
| 29195 | **DUT** | OUT ch0 pkt #183 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29205 | **DUT** | IN  pkt #183 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29205 | yapp monitor | RX pkt #183 on the input: addr=0 len=1 parity=good gap=18 |
| 29205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29210 | yapp driver | TX pkt #183 accepted by the DUT |
| 29210 | yapp driver | TX pkt #184: addr=0 len=1 parity=good delay=8 |
| 29215 | **DUT** | OUT ch0 pkt #183 done: 3 bytes in 3 cycles |
| 29215 | ch0 monitor | ch0 RX pkt #183: addr=0 len=1 parity=good |
| 29215 | scoreboard | ch0 pkt matched: addr=0 len=1 (183 matched so far) |
| 29295 | **DUT** | IN  pkt #184 header: addr=0 len=1 -> channel 0 |
| 29305 | **DUT** | OUT ch0 pkt #184 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29315 | **DUT** | IN  pkt #184 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29315 | yapp monitor | RX pkt #184 on the input: addr=0 len=1 parity=good gap=8 |
| 29315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29320 | yapp driver | TX pkt #184 accepted by the DUT |
| 29320 | yapp driver | TX pkt #185: addr=0 len=1 parity=good delay=20 |
| 29325 | **DUT** | OUT ch0 pkt #184 done: 3 bytes in 3 cycles |
| 29325 | ch0 monitor | ch0 RX pkt #184: addr=0 len=1 parity=good |
| 29325 | scoreboard | ch0 pkt matched: addr=0 len=1 (184 matched so far) |
| 29420 | ch0 driver | ch0: packet consumed (response delay 2) |
| 29525 | **DUT** | IN  pkt #185 header: addr=0 len=1 -> channel 0 |
| 29545 | **DUT** | IN  pkt #185 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29545 | yapp monitor | RX pkt #185 on the input: addr=0 len=1 parity=good gap=20 |
| 29545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29550 | yapp driver | TX pkt #185 accepted by the DUT |
| 29550 | yapp driver | TX pkt #186: addr=0 len=1 parity=good delay=20 |
| 29575 | **DUT** | OUT ch0 pkt #185 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 29590 | ch0 driver | ch0: packet consumed (response delay 4) |
| 29645 | **DUT** | OUT ch0 pkt #185 done: 3 bytes in 8 cycles |
| 29645 | ch0 monitor | ch0 RX pkt #185: addr=0 len=1 parity=good |
| 29645 | scoreboard | ch0 pkt matched: addr=0 len=1 (185 matched so far) |
| 29710 | ch0 driver | ch0: packet consumed (response delay 4) |
| 29755 | **DUT** | IN  pkt #186 header: addr=0 len=1 -> channel 0 |
| 29775 | **DUT** | IN  pkt #186 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29775 | yapp monitor | RX pkt #186 on the input: addr=0 len=1 parity=good gap=20 |
| 29775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29780 | yapp driver | TX pkt #186 accepted by the DUT |
| 29780 | yapp driver | TX pkt #187: addr=0 len=1 parity=good delay=12 |
| 29835 | **DUT** | OUT ch0 pkt #186 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 29850 | ch0 driver | ch0: packet consumed (response delay 7) |
| 29905 | **DUT** | IN  pkt #187 header: addr=0 len=1 -> channel 0 |
| 29925 | **DUT** | IN  pkt #187 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29925 | yapp monitor | RX pkt #187 on the input: addr=0 len=1 parity=good gap=12 |
| 29925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29930 | yapp driver | TX pkt #187 accepted by the DUT |
| 29930 | yapp driver | TX pkt #188: addr=0 len=1 parity=good delay=3 |
| 29965 | **DUT** | IN  pkt #188 header: addr=0 len=1 -> channel 0 |
| 29965 | **DUT** | OUT ch0 pkt #186 done: 3 bytes in 14 cycles |
| 29965 | ch0 monitor | ch0 RX pkt #186: addr=0 len=1 parity=good |
| 29965 | scoreboard | ch0 pkt matched: addr=0 len=1 (186 matched so far) |
| 29975 | **DUT** | OUT ch0 pkt #187 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29985 | **DUT** | IN  pkt #188 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29985 | yapp monitor | RX pkt #188 on the input: addr=0 len=1 parity=good gap=3 |
| 29985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29990 | yapp driver | TX pkt #188 accepted by the DUT |
| 29990 | yapp driver | TX pkt #189: addr=0 len=1 parity=good delay=18 |
| 29995 | **DUT** | OUT ch0 pkt #187 done: 3 bytes in 3 cycles |
| 29995 | ch0 monitor | ch0 RX pkt #187: addr=0 len=1 parity=good |
| 29995 | scoreboard | ch0 pkt matched: addr=0 len=1 (187 matched so far) |
| 30005 | **DUT** | OUT ch0 pkt #188 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30025 | **DUT** | OUT ch0 pkt #188 done: 3 bytes in 3 cycles |
| 30025 | ch0 monitor | ch0 RX pkt #188: addr=0 len=1 parity=good |
| 30025 | scoreboard | ch0 pkt matched: addr=0 len=1 (188 matched so far) |
| 30175 | **DUT** | IN  pkt #189 header: addr=0 len=1 -> channel 0 |
| 30180 | ch0 driver | ch0: packet consumed (response delay 10) |
| 30195 | **DUT** | IN  pkt #189 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30195 | yapp monitor | RX pkt #189 on the input: addr=0 len=1 parity=good gap=18 |
| 30195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30200 | yapp driver | TX pkt #189 accepted by the DUT |
| 30200 | yapp driver | TX pkt #190: addr=0 len=1 parity=good delay=20 |
| 30285 | **DUT** | OUT ch0 pkt #189 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 30300 | ch0 driver | ch0: packet consumed (response delay 9) |
| 30355 | **DUT** | OUT ch0 pkt #189 done: 3 bytes in 8 cycles |
| 30355 | ch0 monitor | ch0 RX pkt #189: addr=0 len=1 parity=good |
| 30355 | scoreboard | ch0 pkt matched: addr=0 len=1 (189 matched so far) |
| 30405 | **DUT** | IN  pkt #190 header: addr=0 len=1 -> channel 0 |
| 30415 | **DUT** | OUT ch0 pkt #190 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30425 | **DUT** | IN  pkt #190 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30425 | yapp monitor | RX pkt #190 on the input: addr=0 len=1 parity=good gap=20 |
| 30425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30430 | yapp driver | TX pkt #190 accepted by the DUT |
| 30430 | yapp driver | TX pkt #191: addr=0 len=1 parity=good delay=16 |
| 30435 | **DUT** | OUT ch0 pkt #190 done: 3 bytes in 3 cycles |
| 30435 | ch0 monitor | ch0 RX pkt #190: addr=0 len=1 parity=good |
| 30435 | scoreboard | ch0 pkt matched: addr=0 len=1 (190 matched so far) |
| 30595 | **DUT** | IN  pkt #191 header: addr=0 len=1 -> channel 0 |
| 30605 | **DUT** | OUT ch0 pkt #191 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30615 | **DUT** | IN  pkt #191 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30615 | yapp monitor | RX pkt #191 on the input: addr=0 len=1 parity=good gap=16 |
| 30615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30620 | yapp driver | TX pkt #191 accepted by the DUT |
| 30620 | yapp driver | TX pkt #192: addr=0 len=1 parity=good delay=14 |
| 30625 | **DUT** | OUT ch0 pkt #191 done: 3 bytes in 3 cycles |
| 30625 | ch0 monitor | ch0 RX pkt #191: addr=0 len=1 parity=good |
| 30625 | scoreboard | ch0 pkt matched: addr=0 len=1 (191 matched so far) |
| 30710 | ch0 driver | ch0: packet consumed (response delay 4) |
| 30765 | **DUT** | IN  pkt #192 header: addr=0 len=1 -> channel 0 |
| 30785 | **DUT** | IN  pkt #192 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30785 | yapp monitor | RX pkt #192 on the input: addr=0 len=1 parity=good gap=14 |
| 30785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30790 | yapp driver | TX pkt #192 accepted by the DUT |
| 30790 | yapp driver | TX pkt #193: addr=0 len=1 parity=good delay=20 |
| 30795 | **DUT** | OUT ch0 pkt #192 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 30810 | ch0 driver | ch0: packet consumed (response delay 2) |
| 30845 | **DUT** | OUT ch0 pkt #192 done: 3 bytes in 6 cycles |
| 30845 | ch0 monitor | ch0 RX pkt #192: addr=0 len=1 parity=good |
| 30845 | scoreboard | ch0 pkt matched: addr=0 len=1 (192 matched so far) |
| 30995 | **DUT** | IN  pkt #193 header: addr=0 len=1 -> channel 0 |
| 31005 | **DUT** | OUT ch0 pkt #193 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31015 | **DUT** | IN  pkt #193 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31015 | yapp monitor | RX pkt #193 on the input: addr=0 len=1 parity=good gap=20 |
| 31015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31020 | yapp driver | TX pkt #193 accepted by the DUT |
| 31020 | yapp driver | TX pkt #194: addr=0 len=1 parity=good delay=15 |
| 31025 | **DUT** | OUT ch0 pkt #193 done: 3 bytes in 3 cycles |
| 31025 | ch0 monitor | ch0 RX pkt #193: addr=0 len=1 parity=good |
| 31025 | scoreboard | ch0 pkt matched: addr=0 len=1 (193 matched so far) |
| 31080 | ch0 driver | ch0: packet consumed (response delay 2) |
| 31175 | **DUT** | IN  pkt #194 header: addr=0 len=1 -> channel 0 |
| 31195 | **DUT** | IN  pkt #194 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31195 | yapp monitor | RX pkt #194 on the input: addr=0 len=1 parity=good gap=15 |
| 31195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31200 | yapp driver | TX pkt #194 accepted by the DUT |
| 31200 | yapp driver | TX pkt #195: addr=0 len=1 parity=good delay=18 |
| 31285 | **DUT** | OUT ch0 pkt #194 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 31300 | ch0 driver | ch0: packet consumed (response delay 10) |
| 31345 | **DUT** | OUT ch0 pkt #194 done: 3 bytes in 7 cycles |
| 31345 | ch0 monitor | ch0 RX pkt #194: addr=0 len=1 parity=good |
| 31345 | scoreboard | ch0 pkt matched: addr=0 len=1 (194 matched so far) |
| 31385 | **DUT** | IN  pkt #195 header: addr=0 len=1 -> channel 0 |
| 31395 | **DUT** | OUT ch0 pkt #195 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31405 | **DUT** | IN  pkt #195 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31405 | yapp monitor | RX pkt #195 on the input: addr=0 len=1 parity=good gap=18 |
| 31405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31410 | yapp driver | TX pkt #195 accepted by the DUT |
| 31410 | yapp driver | TX pkt #196: addr=0 len=1 parity=good delay=11 |
| 31415 | **DUT** | OUT ch0 pkt #195 done: 3 bytes in 3 cycles |
| 31415 | ch0 monitor | ch0 RX pkt #195: addr=0 len=1 parity=good |
| 31415 | scoreboard | ch0 pkt matched: addr=0 len=1 (195 matched so far) |
| 31480 | ch0 driver | ch0: packet consumed (response delay 3) |
| 31525 | **DUT** | IN  pkt #196 header: addr=0 len=1 -> channel 0 |
| 31545 | **DUT** | IN  pkt #196 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31545 | yapp monitor | RX pkt #196 on the input: addr=0 len=1 parity=good gap=11 |
| 31545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31550 | yapp driver | TX pkt #196 accepted by the DUT |
| 31550 | yapp driver | TX pkt #197: addr=0 len=1 parity=good delay=3 |
| 31585 | **DUT** | IN  pkt #197 header: addr=0 len=1 -> channel 0 |
| 31605 | **DUT** | IN  pkt #197 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31605 | yapp monitor | RX pkt #197 on the input: addr=0 len=1 parity=good gap=3 |
| 31605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31610 | yapp driver | TX pkt #197 accepted by the DUT |
| 31610 | yapp driver | TX pkt #198: addr=0 len=1 parity=good delay=19 |
| 31635 | **DUT** | OUT ch0 pkt #196 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 31650 | ch0 driver | ch0: packet consumed (response delay 10) |
| 31725 | **DUT** | OUT ch0 pkt #196 done: 3 bytes in 10 cycles |
| 31725 | ch0 monitor | ch0 RX pkt #196: addr=0 len=1 parity=good |
| 31725 | scoreboard | ch0 pkt matched: addr=0 len=1 (196 matched so far) |
| 31735 | **DUT** | OUT ch0 pkt #197 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31755 | **DUT** | OUT ch0 pkt #197 done: 3 bytes in 3 cycles |
| 31755 | ch0 monitor | ch0 RX pkt #197: addr=0 len=1 parity=good |
| 31755 | scoreboard | ch0 pkt matched: addr=0 len=1 (197 matched so far) |
| 31780 | ch0 driver | ch0: packet consumed (response delay 6) |
| 31805 | **DUT** | IN  pkt #198 header: addr=0 len=1 -> channel 0 |
| 31825 | **DUT** | IN  pkt #198 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31825 | yapp monitor | RX pkt #198 on the input: addr=0 len=1 parity=good gap=19 |
| 31825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31830 | yapp driver | TX pkt #198 accepted by the DUT |
| 31830 | yapp driver | TX pkt #199: addr=0 len=1 parity=good delay=20 |
| 31905 | **DUT** | OUT ch0 pkt #198 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 31920 | ch0 driver | ch0: packet consumed (response delay 9) |
| 31975 | **DUT** | OUT ch0 pkt #198 done: 3 bytes in 8 cycles |
| 31975 | ch0 monitor | ch0 RX pkt #198: addr=0 len=1 parity=good |
| 31975 | scoreboard | ch0 pkt matched: addr=0 len=1 (198 matched so far) |
| 32035 | **DUT** | IN  pkt #199 header: addr=0 len=1 -> channel 0 |
| 32045 | **DUT** | OUT ch0 pkt #199 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32055 | **DUT** | IN  pkt #199 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32055 | yapp monitor | RX pkt #199 on the input: addr=0 len=1 parity=good gap=20 |
| 32055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32060 | yapp driver | TX pkt #199 accepted by the DUT |
| 32060 | yapp driver | TX pkt #200: addr=0 len=1 parity=good delay=20 |
| 32065 | **DUT** | OUT ch0 pkt #199 done: 3 bytes in 3 cycles |
| 32065 | ch0 monitor | ch0 RX pkt #199: addr=0 len=1 parity=good |
| 32065 | scoreboard | ch0 pkt matched: addr=0 len=1 (199 matched so far) |
| 32265 | **DUT** | IN  pkt #200 header: addr=0 len=1 -> channel 0 |
| 32275 | **DUT** | OUT ch0 pkt #200 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32285 | **DUT** | IN  pkt #200 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32285 | yapp monitor | RX pkt #200 on the input: addr=0 len=1 parity=good gap=20 |
| 32285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32290 | yapp driver | TX pkt #200 accepted by the DUT |
| 32290 | yapp driver | TX pkt #201: addr=0 len=1 parity=good delay=1 |
| 32295 | **DUT** | OUT ch0 pkt #200 done: 3 bytes in 3 cycles |
| 32295 | ch0 monitor | ch0 RX pkt #200: addr=0 len=1 parity=good |
| 32295 | scoreboard | ch0 pkt matched: addr=0 len=1 (200 matched so far) |
| 32305 | **DUT** | IN  pkt #201 header: addr=0 len=1 -> channel 0 |
| 32315 | **DUT** | OUT ch0 pkt #201 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32325 | **DUT** | IN  pkt #201 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32325 | yapp monitor | RX pkt #201 on the input: addr=0 len=1 parity=good gap=1 |
| 32325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32330 | yapp driver | TX pkt #201 accepted by the DUT |
| 32330 | yapp driver | TX pkt #202: addr=0 len=1 parity=good delay=19 |
| 32335 | **DUT** | OUT ch0 pkt #201 done: 3 bytes in 3 cycles |
| 32335 | ch0 monitor | ch0 RX pkt #201: addr=0 len=1 parity=good |
| 32335 | scoreboard | ch0 pkt matched: addr=0 len=1 (201 matched so far) |
| 32430 | ch0 driver | ch0: packet consumed (response delay 4) |
| 32525 | **DUT** | IN  pkt #202 header: addr=0 len=1 -> channel 0 |
| 32545 | **DUT** | IN  pkt #202 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32545 | yapp monitor | RX pkt #202 on the input: addr=0 len=1 parity=good gap=19 |
| 32545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32550 | yapp driver | TX pkt #202 accepted by the DUT |
| 32550 | yapp driver | TX pkt #203: addr=0 len=1 parity=good delay=7 |
| 32585 | **DUT** | OUT ch0 pkt #202 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 32600 | ch0 driver | ch0: packet consumed (response delay 5) |
| 32625 | **DUT** | IN  pkt #203 header: addr=0 len=1 -> channel 0 |
| 32645 | **DUT** | IN  pkt #203 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32645 | yapp monitor | RX pkt #203 on the input: addr=0 len=1 parity=good gap=7 |
| 32645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32650 | yapp driver | TX pkt #203 accepted by the DUT |
| 32650 | yapp driver | TX pkt #204: addr=0 len=1 parity=good delay=11 |
| 32715 | **DUT** | OUT ch0 pkt #202 done: 3 bytes in 14 cycles |
| 32715 | ch0 monitor | ch0 RX pkt #202: addr=0 len=1 parity=good |
| 32715 | scoreboard | ch0 pkt matched: addr=0 len=1 (202 matched so far) |
| 32725 | **DUT** | OUT ch0 pkt #203 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32745 | **DUT** | OUT ch0 pkt #203 done: 3 bytes in 3 cycles |
| 32745 | ch0 monitor | ch0 RX pkt #203: addr=0 len=1 parity=good |
| 32745 | scoreboard | ch0 pkt matched: addr=0 len=1 (203 matched so far) |
| 32765 | **DUT** | IN  pkt #204 header: addr=0 len=1 -> channel 0 |
| 32775 | **DUT** | OUT ch0 pkt #204 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32785 | **DUT** | IN  pkt #204 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32785 | yapp monitor | RX pkt #204 on the input: addr=0 len=1 parity=good gap=11 |
| 32785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32790 | yapp driver | TX pkt #204 accepted by the DUT |
| 32790 | yapp driver | TX pkt #205: addr=0 len=1 parity=good delay=2 |
| 32795 | **DUT** | OUT ch0 pkt #204 done: 3 bytes in 3 cycles |
| 32795 | ch0 monitor | ch0 RX pkt #204: addr=0 len=1 parity=good |
| 32795 | scoreboard | ch0 pkt matched: addr=0 len=1 (204 matched so far) |
| 32815 | **DUT** | IN  pkt #205 header: addr=0 len=1 -> channel 0 |
| 32825 | **DUT** | OUT ch0 pkt #205 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32835 | **DUT** | IN  pkt #205 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32835 | yapp monitor | RX pkt #205 on the input: addr=0 len=1 parity=good gap=2 |
| 32835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32840 | yapp driver | TX pkt #205 accepted by the DUT |
| 32840 | yapp driver | TX pkt #206: addr=0 len=1 parity=good delay=9 |
| 32845 | **DUT** | OUT ch0 pkt #205 done: 3 bytes in 3 cycles |
| 32845 | ch0 monitor | ch0 RX pkt #205: addr=0 len=1 parity=good |
| 32845 | scoreboard | ch0 pkt matched: addr=0 len=1 (205 matched so far) |
| 32935 | **DUT** | IN  pkt #206 header: addr=0 len=1 -> channel 0 |
| 32945 | **DUT** | OUT ch0 pkt #206 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32955 | **DUT** | IN  pkt #206 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32955 | yapp monitor | RX pkt #206 on the input: addr=0 len=1 parity=good gap=9 |
| 32955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32960 | ch0 driver | ch0: packet consumed (response delay 10) |
| 32960 | yapp driver | TX pkt #206 accepted by the DUT |
| 32960 | yapp driver | TX pkt #207: addr=0 len=1 parity=good delay=18 |
| 33005 | **DUT** | OUT ch0 pkt #206 done: 3 bytes in 7 cycles |
| 33005 | ch0 monitor | ch0 RX pkt #206: addr=0 len=1 parity=good |
| 33005 | scoreboard | ch0 pkt matched: addr=0 len=1 (206 matched so far) |
| 33145 | **DUT** | IN  pkt #207 header: addr=0 len=1 -> channel 0 |
| 33155 | **DUT** | OUT ch0 pkt #207 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33165 | **DUT** | IN  pkt #207 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33165 | yapp monitor | RX pkt #207 on the input: addr=0 len=1 parity=good gap=18 |
| 33165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33170 | yapp driver | TX pkt #207 accepted by the DUT |
| 33170 | yapp driver | TX pkt #208: addr=0 len=1 parity=good delay=17 |
| 33175 | **DUT** | OUT ch0 pkt #207 done: 3 bytes in 3 cycles |
| 33175 | ch0 monitor | ch0 RX pkt #207: addr=0 len=1 parity=good |
| 33175 | scoreboard | ch0 pkt matched: addr=0 len=1 (207 matched so far) |
| 33300 | ch0 driver | ch0: packet consumed (response delay 3) |
| 33345 | **DUT** | IN  pkt #208 header: addr=0 len=1 -> channel 0 |
| 33365 | **DUT** | IN  pkt #208 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33365 | yapp monitor | RX pkt #208 on the input: addr=0 len=1 parity=good gap=17 |
| 33365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33370 | yapp driver | TX pkt #208 accepted by the DUT |
| 33370 | yapp driver | TX pkt #209: addr=0 len=1 parity=good delay=13 |
| 33455 | **DUT** | OUT ch0 pkt #208 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 33470 | ch0 driver | ch0: packet consumed (response delay 10) |
| 33505 | **DUT** | IN  pkt #209 header: addr=0 len=1 -> channel 0 |
| 33525 | **DUT** | IN  pkt #209 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33525 | yapp monitor | RX pkt #209 on the input: addr=0 len=1 parity=good gap=13 |
| 33525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33530 | yapp driver | TX pkt #209 accepted by the DUT |
| 33530 | yapp driver | TX pkt #210: addr=0 len=1 parity=good delay=11 |
| 33575 | **DUT** | OUT ch0 pkt #208 done: 3 bytes in 13 cycles |
| 33575 | ch0 monitor | ch0 RX pkt #208: addr=0 len=1 parity=good |
| 33575 | scoreboard | ch0 pkt matched: addr=0 len=1 (208 matched so far) |
| 33585 | **DUT** | OUT ch0 pkt #209 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33605 | **DUT** | OUT ch0 pkt #209 done: 3 bytes in 3 cycles |
| 33605 | ch0 monitor | ch0 RX pkt #209: addr=0 len=1 parity=good |
| 33605 | scoreboard | ch0 pkt matched: addr=0 len=1 (209 matched so far) |
| 33645 | **DUT** | IN  pkt #210 header: addr=0 len=1 -> channel 0 |
| 33655 | **DUT** | OUT ch0 pkt #210 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33665 | **DUT** | IN  pkt #210 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33665 | yapp monitor | RX pkt #210 on the input: addr=0 len=1 parity=good gap=11 |
| 33665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33670 | yapp driver | TX pkt #210 accepted by the DUT |
| 33670 | yapp driver | TX pkt #211: addr=0 len=1 parity=good delay=17 |
| 33675 | **DUT** | OUT ch0 pkt #210 done: 3 bytes in 3 cycles |
| 33675 | ch0 monitor | ch0 RX pkt #210: addr=0 len=1 parity=good |
| 33675 | scoreboard | ch0 pkt matched: addr=0 len=1 (210 matched so far) |
| 33845 | **DUT** | IN  pkt #211 header: addr=0 len=1 -> channel 0 |
| 33855 | **DUT** | OUT ch0 pkt #211 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33865 | **DUT** | IN  pkt #211 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33865 | yapp monitor | RX pkt #211 on the input: addr=0 len=1 parity=good gap=17 |
| 33865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33870 | yapp driver | TX pkt #211 accepted by the DUT |
| 33870 | yapp driver | TX pkt #212: addr=0 len=1 parity=good delay=18 |
| 33875 | **DUT** | OUT ch0 pkt #211 done: 3 bytes in 3 cycles |
| 33875 | ch0 monitor | ch0 RX pkt #211: addr=0 len=1 parity=good |
| 33875 | scoreboard | ch0 pkt matched: addr=0 len=1 (211 matched so far) |
| 33910 | ch0 driver | ch0: packet consumed (response delay 9) |
| 34055 | **DUT** | IN  pkt #212 header: addr=0 len=1 -> channel 0 |
| 34075 | **DUT** | IN  pkt #212 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34075 | yapp monitor | RX pkt #212 on the input: addr=0 len=1 parity=good gap=18 |
| 34075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34080 | yapp driver | TX pkt #212 accepted by the DUT |
| 34080 | yapp driver | TX pkt #213: addr=0 len=1 parity=good delay=11 |
| 34165 | **DUT** | OUT ch0 pkt #212 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 34180 | ch0 driver | ch0: packet consumed (response delay 10) |
| 34195 | **DUT** | IN  pkt #213 header: addr=0 len=1 -> channel 0 |
| 34205 | **DUT** | OUT ch0 pkt #212 done: 3 bytes in 5 cycles |
| 34205 | ch0 monitor | ch0 RX pkt #212: addr=0 len=1 parity=good |
| 34205 | scoreboard | ch0 pkt matched: addr=0 len=1 (212 matched so far) |
| 34215 | **DUT** | IN  pkt #213 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34215 | **DUT** | OUT ch0 pkt #213 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34215 | yapp monitor | RX pkt #213 on the input: addr=0 len=1 parity=good gap=11 |
| 34215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34220 | yapp driver | TX pkt #213 accepted by the DUT |
| 34220 | yapp driver | TX pkt #214: addr=0 len=1 parity=good delay=17 |
| 34235 | **DUT** | OUT ch0 pkt #213 done: 3 bytes in 3 cycles |
| 34235 | ch0 monitor | ch0 RX pkt #213: addr=0 len=1 parity=good |
| 34235 | scoreboard | ch0 pkt matched: addr=0 len=1 (213 matched so far) |
| 34395 | **DUT** | IN  pkt #214 header: addr=0 len=1 -> channel 0 |
| 34405 | **DUT** | OUT ch0 pkt #214 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34415 | **DUT** | IN  pkt #214 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34415 | yapp monitor | RX pkt #214 on the input: addr=0 len=1 parity=good gap=17 |
| 34415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34420 | yapp driver | TX pkt #214 accepted by the DUT |
| 34420 | yapp driver | TX pkt #215: addr=0 len=1 parity=good delay=20 |
| 34425 | **DUT** | OUT ch0 pkt #214 done: 3 bytes in 3 cycles |
| 34425 | ch0 monitor | ch0 RX pkt #214: addr=0 len=1 parity=good |
| 34425 | scoreboard | ch0 pkt matched: addr=0 len=1 (214 matched so far) |
| 34625 | **DUT** | IN  pkt #215 header: addr=0 len=1 -> channel 0 |
| 34635 | **DUT** | OUT ch0 pkt #215 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34645 | **DUT** | IN  pkt #215 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34645 | yapp monitor | RX pkt #215 on the input: addr=0 len=1 parity=good gap=20 |
| 34645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34650 | ch0 driver | ch0: packet consumed (response delay 1) |
| 34650 | yapp driver | TX pkt #215 accepted by the DUT |
| 34650 | yapp driver | TX pkt #216: addr=0 len=1 parity=good delay=20 |
| 34765 | **DUT** | OUT ch0 pkt #215 done: 3 bytes in 14 cycles |
| 34765 | ch0 monitor | ch0 RX pkt #215: addr=0 len=1 parity=good |
| 34765 | scoreboard | ch0 pkt matched: addr=0 len=1 (215 matched so far) |
| 34855 | **DUT** | IN  pkt #216 header: addr=0 len=1 -> channel 0 |
| 34865 | **DUT** | OUT ch0 pkt #216 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34875 | **DUT** | IN  pkt #216 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34875 | yapp monitor | RX pkt #216 on the input: addr=0 len=1 parity=good gap=20 |
| 34875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34880 | yapp driver | TX pkt #216 accepted by the DUT |
| 34880 | yapp driver | TX pkt #217: addr=0 len=1 parity=good delay=16 |
| 34885 | **DUT** | OUT ch0 pkt #216 done: 3 bytes in 3 cycles |
| 34885 | ch0 monitor | ch0 RX pkt #216: addr=0 len=1 parity=good |
| 34885 | scoreboard | ch0 pkt matched: addr=0 len=1 (216 matched so far) |
| 35045 | **DUT** | IN  pkt #217 header: addr=0 len=1 -> channel 0 |
| 35055 | **DUT** | OUT ch0 pkt #217 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35065 | **DUT** | IN  pkt #217 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35065 | yapp monitor | RX pkt #217 on the input: addr=0 len=1 parity=good gap=16 |
| 35065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35070 | yapp driver | TX pkt #217 accepted by the DUT |
| 35070 | yapp driver | TX pkt #218: addr=0 len=1 parity=good delay=16 |
| 35075 | **DUT** | OUT ch0 pkt #217 done: 3 bytes in 3 cycles |
| 35075 | ch0 monitor | ch0 RX pkt #217: addr=0 len=1 parity=good |
| 35075 | scoreboard | ch0 pkt matched: addr=0 len=1 (217 matched so far) |
| 35235 | **DUT** | IN  pkt #218 header: addr=0 len=1 -> channel 0 |
| 35245 | **DUT** | OUT ch0 pkt #218 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35255 | **DUT** | IN  pkt #218 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35255 | yapp monitor | RX pkt #218 on the input: addr=0 len=1 parity=good gap=16 |
| 35255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35260 | yapp driver | TX pkt #218 accepted by the DUT |
| 35260 | yapp driver | TX pkt #219: addr=0 len=1 parity=good delay=20 |
| 35265 | **DUT** | OUT ch0 pkt #218 done: 3 bytes in 3 cycles |
| 35265 | ch0 monitor | ch0 RX pkt #218: addr=0 len=1 parity=good |
| 35265 | scoreboard | ch0 pkt matched: addr=0 len=1 (218 matched so far) |
| 35400 | ch0 driver | ch0: packet consumed (response delay 10) |
| 35465 | **DUT** | IN  pkt #219 header: addr=0 len=1 -> channel 0 |
| 35485 | **DUT** | IN  pkt #219 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35485 | yapp monitor | RX pkt #219 on the input: addr=0 len=1 parity=good gap=20 |
| 35485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35490 | yapp driver | TX pkt #219 accepted by the DUT |
| 35490 | yapp driver | TX pkt #220: addr=0 len=1 parity=good delay=20 |
| 35505 | **DUT** | OUT ch0 pkt #219 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 35520 | ch0 driver | ch0: packet consumed (response delay 3) |
| 35595 | **DUT** | OUT ch0 pkt #219 done: 3 bytes in 10 cycles |
| 35595 | ch0 monitor | ch0 RX pkt #219: addr=0 len=1 parity=good |
| 35595 | scoreboard | ch0 pkt matched: addr=0 len=1 (219 matched so far) |
| 35695 | **DUT** | IN  pkt #220 header: addr=0 len=1 -> channel 0 |
| 35705 | **DUT** | OUT ch0 pkt #220 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35715 | **DUT** | IN  pkt #220 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35715 | yapp monitor | RX pkt #220 on the input: addr=0 len=1 parity=good gap=20 |
| 35715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35720 | yapp driver | TX pkt #220 accepted by the DUT |
| 35720 | yapp driver | TX pkt #221: addr=0 len=1 parity=good delay=5 |
| 35725 | **DUT** | OUT ch0 pkt #220 done: 3 bytes in 3 cycles |
| 35725 | ch0 monitor | ch0 RX pkt #220: addr=0 len=1 parity=good |
| 35725 | scoreboard | ch0 pkt matched: addr=0 len=1 (220 matched so far) |
| 35775 | **DUT** | IN  pkt #221 header: addr=0 len=1 -> channel 0 |
| 35785 | **DUT** | OUT ch0 pkt #221 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35795 | **DUT** | IN  pkt #221 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35795 | yapp monitor | RX pkt #221 on the input: addr=0 len=1 parity=good gap=5 |
| 35795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35800 | yapp driver | TX pkt #221 accepted by the DUT |
| 35800 | yapp driver | TX pkt #222: addr=0 len=1 parity=good delay=1 |
| 35805 | **DUT** | OUT ch0 pkt #221 done: 3 bytes in 3 cycles |
| 35805 | ch0 monitor | ch0 RX pkt #221: addr=0 len=1 parity=good |
| 35805 | scoreboard | ch0 pkt matched: addr=0 len=1 (221 matched so far) |
| 35815 | **DUT** | IN  pkt #222 header: addr=0 len=1 -> channel 0 |
| 35825 | **DUT** | OUT ch0 pkt #222 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35835 | **DUT** | IN  pkt #222 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35835 | yapp monitor | RX pkt #222 on the input: addr=0 len=1 parity=good gap=1 |
| 35835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35840 | yapp driver | TX pkt #222 accepted by the DUT |
| 35840 | yapp driver | TX pkt #223: addr=0 len=1 parity=good delay=1 |
| 35845 | **DUT** | OUT ch0 pkt #222 done: 3 bytes in 3 cycles |
| 35845 | ch0 monitor | ch0 RX pkt #222: addr=0 len=1 parity=good |
| 35845 | scoreboard | ch0 pkt matched: addr=0 len=1 (222 matched so far) |
| 35855 | **DUT** | IN  pkt #223 header: addr=0 len=1 -> channel 0 |
| 35865 | **DUT** | OUT ch0 pkt #223 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35875 | **DUT** | IN  pkt #223 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35875 | yapp monitor | RX pkt #223 on the input: addr=0 len=1 parity=good gap=1 |
| 35875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35880 | yapp driver | TX pkt #223 accepted by the DUT |
| 35880 | yapp driver | TX pkt #224: addr=0 len=1 parity=good delay=17 |
| 35885 | **DUT** | OUT ch0 pkt #223 done: 3 bytes in 3 cycles |
| 35885 | ch0 monitor | ch0 RX pkt #223: addr=0 len=1 parity=good |
| 35885 | scoreboard | ch0 pkt matched: addr=0 len=1 (223 matched so far) |
| 35940 | ch0 driver | ch0: packet consumed (response delay 6) |
| 36055 | **DUT** | IN  pkt #224 header: addr=0 len=1 -> channel 0 |
| 36075 | **DUT** | IN  pkt #224 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36075 | yapp monitor | RX pkt #224 on the input: addr=0 len=1 parity=good gap=17 |
| 36075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36080 | yapp driver | TX pkt #224 accepted by the DUT |
| 36080 | yapp driver | TX pkt #225: addr=0 len=1 parity=good delay=20 |
| 36145 | **DUT** | OUT ch0 pkt #224 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 36160 | ch0 driver | ch0: packet consumed (response delay 8) |
| 36275 | **DUT** | OUT ch0 pkt #224 done: 3 bytes in 14 cycles |
| 36275 | ch0 monitor | ch0 RX pkt #224: addr=0 len=1 parity=good |
| 36275 | scoreboard | ch0 pkt matched: addr=0 len=1 (224 matched so far) |
| 36285 | **DUT** | IN  pkt #225 header: addr=0 len=1 -> channel 0 |
| 36295 | **DUT** | OUT ch0 pkt #225 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36305 | **DUT** | IN  pkt #225 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36305 | yapp monitor | RX pkt #225 on the input: addr=0 len=1 parity=good gap=20 |
| 36305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36310 | yapp driver | TX pkt #225 accepted by the DUT |
| 36310 | yapp driver | TX pkt #226: addr=0 len=1 parity=good delay=2 |
| 36315 | **DUT** | OUT ch0 pkt #225 done: 3 bytes in 3 cycles |
| 36315 | ch0 monitor | ch0 RX pkt #225: addr=0 len=1 parity=good |
| 36315 | scoreboard | ch0 pkt matched: addr=0 len=1 (225 matched so far) |
| 36335 | **DUT** | IN  pkt #226 header: addr=0 len=1 -> channel 0 |
| 36345 | **DUT** | OUT ch0 pkt #226 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36355 | **DUT** | IN  pkt #226 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36355 | yapp monitor | RX pkt #226 on the input: addr=0 len=1 parity=good gap=2 |
| 36355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36360 | yapp driver | TX pkt #226 accepted by the DUT |
| 36360 | yapp driver | TX pkt #227: addr=0 len=1 parity=good delay=19 |
| 36365 | **DUT** | OUT ch0 pkt #226 done: 3 bytes in 3 cycles |
| 36365 | ch0 monitor | ch0 RX pkt #226: addr=0 len=1 parity=good |
| 36365 | scoreboard | ch0 pkt matched: addr=0 len=1 (226 matched so far) |
| 36555 | **DUT** | IN  pkt #227 header: addr=0 len=1 -> channel 0 |
| 36565 | **DUT** | OUT ch0 pkt #227 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36575 | **DUT** | IN  pkt #227 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36575 | yapp monitor | RX pkt #227 on the input: addr=0 len=1 parity=good gap=19 |
| 36575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36580 | yapp driver | TX pkt #227 accepted by the DUT |
| 36580 | yapp driver | TX pkt #228: addr=0 len=1 parity=good delay=12 |
| 36585 | **DUT** | OUT ch0 pkt #227 done: 3 bytes in 3 cycles |
| 36585 | ch0 monitor | ch0 RX pkt #227: addr=0 len=1 parity=good |
| 36585 | scoreboard | ch0 pkt matched: addr=0 len=1 (227 matched so far) |
| 36680 | ch0 driver | ch0: packet consumed (response delay 10) |
| 36705 | **DUT** | IN  pkt #228 header: addr=0 len=1 -> channel 0 |
| 36715 | **DUT** | OUT ch0 pkt #228 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36725 | **DUT** | IN  pkt #228 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36725 | yapp monitor | RX pkt #228 on the input: addr=0 len=1 parity=good gap=12 |
| 36725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36730 | ch0 driver | ch0: packet consumed (response delay 0) |
| 36730 | yapp driver | TX pkt #228 accepted by the DUT |
| 36730 | yapp driver | TX pkt #229: addr=0 len=1 parity=good delay=10 |
| 36755 | **DUT** | OUT ch0 pkt #228 done: 3 bytes in 5 cycles |
| 36755 | ch0 monitor | ch0 RX pkt #228: addr=0 len=1 parity=good |
| 36755 | scoreboard | ch0 pkt matched: addr=0 len=1 (228 matched so far) |
| 36835 | **DUT** | IN  pkt #229 header: addr=0 len=1 -> channel 0 |
| 36845 | **DUT** | OUT ch0 pkt #229 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36855 | **DUT** | IN  pkt #229 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36855 | yapp monitor | RX pkt #229 on the input: addr=0 len=1 parity=good gap=10 |
| 36855 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36860 | yapp driver | TX pkt #229 accepted by the DUT |
| 36860 | yapp driver | TX pkt #230: addr=0 len=1 parity=good delay=7 |
| 36865 | **DUT** | OUT ch0 pkt #229 done: 3 bytes in 3 cycles |
| 36865 | ch0 monitor | ch0 RX pkt #229: addr=0 len=1 parity=good |
| 36865 | scoreboard | ch0 pkt matched: addr=0 len=1 (229 matched so far) |
| 36935 | **DUT** | IN  pkt #230 header: addr=0 len=1 -> channel 0 |
| 36945 | **DUT** | OUT ch0 pkt #230 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36955 | **DUT** | IN  pkt #230 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36955 | yapp monitor | RX pkt #230 on the input: addr=0 len=1 parity=good gap=7 |
| 36955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36960 | yapp driver | TX pkt #230 accepted by the DUT |
| 36960 | yapp driver | TX pkt #231: addr=0 len=1 parity=good delay=14 |
| 36965 | **DUT** | OUT ch0 pkt #230 done: 3 bytes in 3 cycles |
| 36965 | ch0 monitor | ch0 RX pkt #230: addr=0 len=1 parity=good |
| 36965 | scoreboard | ch0 pkt matched: addr=0 len=1 (230 matched so far) |
| 37105 | **DUT** | IN  pkt #231 header: addr=0 len=1 -> channel 0 |
| 37115 | **DUT** | OUT ch0 pkt #231 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37125 | **DUT** | IN  pkt #231 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37125 | yapp monitor | RX pkt #231 on the input: addr=0 len=1 parity=good gap=14 |
| 37125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37130 | yapp driver | TX pkt #231 accepted by the DUT |
| 37130 | yapp driver | TX pkt #232: addr=0 len=1 parity=good delay=20 |
| 37135 | **DUT** | OUT ch0 pkt #231 done: 3 bytes in 3 cycles |
| 37135 | ch0 monitor | ch0 RX pkt #231: addr=0 len=1 parity=good |
| 37135 | scoreboard | ch0 pkt matched: addr=0 len=1 (231 matched so far) |
| 37335 | **DUT** | IN  pkt #232 header: addr=0 len=1 -> channel 0 |
| 37345 | **DUT** | OUT ch0 pkt #232 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37350 | ch0 driver | ch0: packet consumed (response delay 1) |
| 37355 | **DUT** | IN  pkt #232 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37355 | yapp monitor | RX pkt #232 on the input: addr=0 len=1 parity=good gap=20 |
| 37355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37360 | yapp driver | TX pkt #232 accepted by the DUT |
| 37360 | yapp driver | TX pkt #233: addr=0 len=1 parity=good delay=20 |
| 37455 | **DUT** | OUT ch0 pkt #232 done: 3 bytes in 12 cycles |
| 37455 | ch0 monitor | ch0 RX pkt #232: addr=0 len=1 parity=good |
| 37455 | scoreboard | ch0 pkt matched: addr=0 len=1 (232 matched so far) |
| 37565 | **DUT** | IN  pkt #233 header: addr=0 len=1 -> channel 0 |
| 37575 | **DUT** | OUT ch0 pkt #233 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37585 | **DUT** | IN  pkt #233 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37585 | yapp monitor | RX pkt #233 on the input: addr=0 len=1 parity=good gap=20 |
| 37585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37590 | yapp driver | TX pkt #233 accepted by the DUT |
| 37590 | yapp driver | TX pkt #234: addr=0 len=1 parity=good delay=1 |
| 37595 | **DUT** | OUT ch0 pkt #233 done: 3 bytes in 3 cycles |
| 37595 | ch0 monitor | ch0 RX pkt #233: addr=0 len=1 parity=good |
| 37595 | scoreboard | ch0 pkt matched: addr=0 len=1 (233 matched so far) |
| 37605 | **DUT** | IN  pkt #234 header: addr=0 len=1 -> channel 0 |
| 37615 | **DUT** | OUT ch0 pkt #234 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37625 | **DUT** | IN  pkt #234 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37625 | yapp monitor | RX pkt #234 on the input: addr=0 len=1 parity=good gap=1 |
| 37625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37630 | yapp driver | TX pkt #234 accepted by the DUT |
| 37630 | yapp driver | TX pkt #235: addr=0 len=1 parity=good delay=2 |
| 37635 | **DUT** | OUT ch0 pkt #234 done: 3 bytes in 3 cycles |
| 37635 | ch0 monitor | ch0 RX pkt #234: addr=0 len=1 parity=good |
| 37635 | scoreboard | ch0 pkt matched: addr=0 len=1 (234 matched so far) |
| 37655 | **DUT** | IN  pkt #235 header: addr=0 len=1 -> channel 0 |
| 37665 | **DUT** | OUT ch0 pkt #235 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37675 | **DUT** | IN  pkt #235 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37675 | yapp monitor | RX pkt #235 on the input: addr=0 len=1 parity=good gap=2 |
| 37675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37680 | yapp driver | TX pkt #235 accepted by the DUT |
| 37680 | yapp driver | TX pkt #236: addr=0 len=1 parity=good delay=10 |
| 37685 | **DUT** | OUT ch0 pkt #235 done: 3 bytes in 3 cycles |
| 37685 | ch0 monitor | ch0 RX pkt #235: addr=0 len=1 parity=good |
| 37685 | scoreboard | ch0 pkt matched: addr=0 len=1 (235 matched so far) |
| 37740 | ch0 driver | ch0: packet consumed (response delay 8) |
| 37785 | **DUT** | IN  pkt #236 header: addr=0 len=1 -> channel 0 |
| 37805 | **DUT** | IN  pkt #236 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37805 | yapp monitor | RX pkt #236 on the input: addr=0 len=1 parity=good gap=10 |
| 37805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37810 | yapp driver | TX pkt #236 accepted by the DUT |
| 37810 | yapp driver | TX pkt #237: addr=0 len=1 parity=good delay=1 |
| 37825 | **DUT** | IN  pkt #237 header: addr=0 len=1 -> channel 0 |
| 37845 | **DUT** | IN  pkt #237 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37845 | yapp monitor | RX pkt #237 on the input: addr=0 len=1 parity=good gap=1 |
| 37845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37850 | yapp driver | TX pkt #237 accepted by the DUT |
| 37850 | yapp driver | TX pkt #238: addr=0 len=1 parity=good delay=16 |
| 37875 | **DUT** | OUT ch0 pkt #236 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 37890 | ch0 driver | ch0: packet consumed (response delay 8) |
| 37905 | **DUT** | OUT ch0 pkt #236 done: 3 bytes in 4 cycles |
| 37905 | ch0 monitor | ch0 RX pkt #236: addr=0 len=1 parity=good |
| 37905 | scoreboard | ch0 pkt matched: addr=0 len=1 (236 matched so far) |
| 37915 | **DUT** | OUT ch0 pkt #237 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37935 | **DUT** | OUT ch0 pkt #237 done: 3 bytes in 3 cycles |
| 37935 | ch0 monitor | ch0 RX pkt #237: addr=0 len=1 parity=good |
| 37935 | scoreboard | ch0 pkt matched: addr=0 len=1 (237 matched so far) |
| 38015 | **DUT** | IN  pkt #238 header: addr=0 len=1 -> channel 0 |
| 38025 | **DUT** | OUT ch0 pkt #238 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38035 | **DUT** | IN  pkt #238 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38035 | yapp monitor | RX pkt #238 on the input: addr=0 len=1 parity=good gap=16 |
| 38035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38040 | yapp driver | TX pkt #238 accepted by the DUT |
| 38040 | yapp driver | TX pkt #239: addr=0 len=1 parity=good delay=16 |
| 38045 | **DUT** | OUT ch0 pkt #238 done: 3 bytes in 3 cycles |
| 38045 | ch0 monitor | ch0 RX pkt #238: addr=0 len=1 parity=good |
| 38045 | scoreboard | ch0 pkt matched: addr=0 len=1 (238 matched so far) |
| 38170 | ch0 driver | ch0: packet consumed (response delay 0) |
| 38205 | **DUT** | IN  pkt #239 header: addr=0 len=1 -> channel 0 |
| 38225 | **DUT** | IN  pkt #239 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38225 | yapp monitor | RX pkt #239 on the input: addr=0 len=1 parity=good gap=16 |
| 38225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38230 | yapp driver | TX pkt #239 accepted by the DUT |
| 38230 | yapp driver | TX pkt #240: addr=0 len=1 parity=good delay=7 |
| 38305 | **DUT** | IN  pkt #240 header: addr=0 len=1 -> channel 0 |
| 38315 | **DUT** | OUT ch0 pkt #239 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 38325 | **DUT** | IN  pkt #240 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38325 | yapp monitor | RX pkt #240 on the input: addr=0 len=1 parity=good gap=7 |
| 38325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38330 | ch0 driver | ch0: packet consumed (response delay 10) |
| 38330 | yapp driver | TX pkt #240 accepted by the DUT |
| 38330 | yapp driver | TX pkt #241: addr=0 len=1 parity=good delay=9 |
| 38425 | **DUT** | IN  pkt #241 header: addr=0 len=1 -> channel 0 |
| 38445 | **DUT** | IN  pkt #241 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38445 | **DUT** | OUT ch0 pkt #239 done: 3 bytes in 14 cycles |
| 38445 | ch0 monitor | ch0 RX pkt #239: addr=0 len=1 parity=good |
| 38445 | scoreboard | ch0 pkt matched: addr=0 len=1 (239 matched so far) |
| 38445 | yapp monitor | RX pkt #241 on the input: addr=0 len=1 parity=good gap=9 |
| 38445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38450 | yapp driver | TX pkt #241 accepted by the DUT |
| 38450 | yapp driver | TX pkt #242: addr=0 len=1 parity=good delay=18 |
| 38455 | **DUT** | OUT ch0 pkt #240 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38475 | **DUT** | OUT ch0 pkt #240 done: 3 bytes in 3 cycles |
| 38475 | ch0 monitor | ch0 RX pkt #240: addr=0 len=1 parity=good |
| 38475 | scoreboard | ch0 pkt matched: addr=0 len=1 (240 matched so far) |
| 38485 | **DUT** | OUT ch0 pkt #241 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38505 | **DUT** | OUT ch0 pkt #241 done: 3 bytes in 3 cycles |
| 38505 | ch0 monitor | ch0 RX pkt #241: addr=0 len=1 parity=good |
| 38505 | scoreboard | ch0 pkt matched: addr=0 len=1 (241 matched so far) |
| 38635 | **DUT** | IN  pkt #242 header: addr=0 len=1 -> channel 0 |
| 38645 | **DUT** | OUT ch0 pkt #242 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38655 | **DUT** | IN  pkt #242 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38655 | yapp monitor | RX pkt #242 on the input: addr=0 len=1 parity=good gap=18 |
| 38655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38660 | yapp driver | TX pkt #242 accepted by the DUT |
| 38660 | yapp driver | TX pkt #243: addr=0 len=1 parity=good delay=1 |
| 38665 | **DUT** | OUT ch0 pkt #242 done: 3 bytes in 3 cycles |
| 38665 | ch0 monitor | ch0 RX pkt #242: addr=0 len=1 parity=good |
| 38665 | scoreboard | ch0 pkt matched: addr=0 len=1 (242 matched so far) |
| 38675 | **DUT** | IN  pkt #243 header: addr=0 len=1 -> channel 0 |
| 38685 | **DUT** | OUT ch0 pkt #243 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38695 | **DUT** | IN  pkt #243 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38695 | yapp monitor | RX pkt #243 on the input: addr=0 len=1 parity=good gap=1 |
| 38695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38700 | yapp driver | TX pkt #243 accepted by the DUT |
| 38700 | yapp driver | TX pkt #244: addr=0 len=1 parity=good delay=20 |
| 38705 | **DUT** | OUT ch0 pkt #243 done: 3 bytes in 3 cycles |
| 38705 | ch0 monitor | ch0 RX pkt #243: addr=0 len=1 parity=good |
| 38705 | scoreboard | ch0 pkt matched: addr=0 len=1 (243 matched so far) |
| 38730 | ch0 driver | ch0: packet consumed (response delay 10) |
| 38905 | **DUT** | IN  pkt #244 header: addr=0 len=1 -> channel 0 |
| 38925 | **DUT** | IN  pkt #244 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38925 | yapp monitor | RX pkt #244 on the input: addr=0 len=1 parity=good gap=20 |
| 38925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38930 | yapp driver | TX pkt #244 accepted by the DUT |
| 38930 | yapp driver | TX pkt #245: addr=0 len=1 parity=good delay=20 |
| 38975 | **DUT** | OUT ch0 pkt #244 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 38990 | ch0 driver | ch0: packet consumed (response delay 6) |
| 39065 | **DUT** | OUT ch0 pkt #244 done: 3 bytes in 10 cycles |
| 39065 | ch0 monitor | ch0 RX pkt #244: addr=0 len=1 parity=good |
| 39065 | scoreboard | ch0 pkt matched: addr=0 len=1 (244 matched so far) |
| 39135 | **DUT** | IN  pkt #245 header: addr=0 len=1 -> channel 0 |
| 39145 | **DUT** | OUT ch0 pkt #245 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39155 | **DUT** | IN  pkt #245 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39155 | yapp monitor | RX pkt #245 on the input: addr=0 len=1 parity=good gap=20 |
| 39155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39160 | yapp driver | TX pkt #245 accepted by the DUT |
| 39160 | yapp driver | TX pkt #246: addr=0 len=1 parity=good delay=12 |
| 39165 | **DUT** | OUT ch0 pkt #245 done: 3 bytes in 3 cycles |
| 39165 | ch0 monitor | ch0 RX pkt #245: addr=0 len=1 parity=good |
| 39165 | scoreboard | ch0 pkt matched: addr=0 len=1 (245 matched so far) |
| 39285 | **DUT** | IN  pkt #246 header: addr=0 len=1 -> channel 0 |
| 39295 | **DUT** | OUT ch0 pkt #246 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39305 | **DUT** | IN  pkt #246 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39305 | yapp monitor | RX pkt #246 on the input: addr=0 len=1 parity=good gap=12 |
| 39305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39310 | yapp driver | TX pkt #246 accepted by the DUT |
| 39310 | yapp driver | TX pkt #247: addr=0 len=1 parity=good delay=16 |
| 39315 | **DUT** | OUT ch0 pkt #246 done: 3 bytes in 3 cycles |
| 39315 | ch0 monitor | ch0 RX pkt #246: addr=0 len=1 parity=good |
| 39315 | scoreboard | ch0 pkt matched: addr=0 len=1 (246 matched so far) |
| 39400 | ch0 driver | ch0: packet consumed (response delay 6) |
| 39475 | **DUT** | IN  pkt #247 header: addr=0 len=1 -> channel 0 |
| 39495 | **DUT** | IN  pkt #247 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39495 | yapp monitor | RX pkt #247 on the input: addr=0 len=1 parity=good gap=16 |
| 39495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39500 | yapp driver | TX pkt #247 accepted by the DUT |
| 39500 | yapp driver | TX pkt #248: addr=0 len=1 parity=good delay=20 |
| 39525 | **DUT** | OUT ch0 pkt #247 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 39540 | ch0 driver | ch0: packet consumed (response delay 4) |
| 39565 | **DUT** | OUT ch0 pkt #247 done: 3 bytes in 5 cycles |
| 39565 | ch0 monitor | ch0 RX pkt #247: addr=0 len=1 parity=good |
| 39565 | scoreboard | ch0 pkt matched: addr=0 len=1 (247 matched so far) |
| 39705 | **DUT** | IN  pkt #248 header: addr=0 len=1 -> channel 0 |
| 39715 | **DUT** | OUT ch0 pkt #248 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39725 | **DUT** | IN  pkt #248 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39725 | yapp monitor | RX pkt #248 on the input: addr=0 len=1 parity=good gap=20 |
| 39725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39730 | yapp driver | TX pkt #248 accepted by the DUT |
| 39730 | yapp driver | TX pkt #249: addr=0 len=1 parity=good delay=15 |
| 39735 | **DUT** | OUT ch0 pkt #248 done: 3 bytes in 3 cycles |
| 39735 | ch0 monitor | ch0 RX pkt #248: addr=0 len=1 parity=good |
| 39735 | scoreboard | ch0 pkt matched: addr=0 len=1 (248 matched so far) |
| 39790 | ch0 driver | ch0: packet consumed (response delay 1) |
| 39885 | **DUT** | IN  pkt #249 header: addr=0 len=1 -> channel 0 |
| 39905 | **DUT** | IN  pkt #249 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39905 | yapp monitor | RX pkt #249 on the input: addr=0 len=1 parity=good gap=15 |
| 39905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39910 | yapp driver | TX pkt #249 accepted by the DUT |
| 39910 | yapp driver | TX pkt #250: addr=0 len=1 parity=good delay=4 |
| 39955 | **DUT** | IN  pkt #250 header: addr=0 len=1 -> channel 0 |
| 39975 | **DUT** | IN  pkt #250 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39975 | **DUT** | OUT ch0 pkt #249 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 39975 | yapp monitor | RX pkt #250 on the input: addr=0 len=1 parity=good gap=4 |
| 39975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39980 | yapp driver | TX pkt #250 accepted by the DUT |
| 39980 | yapp driver | TX pkt #251: addr=0 len=1 parity=good delay=18 |
| 39990 | ch0 driver | ch0: packet consumed (response delay 8) |
| 40065 | **DUT** | OUT ch0 pkt #249 done: 3 bytes in 10 cycles |
| 40065 | ch0 monitor | ch0 RX pkt #249: addr=0 len=1 parity=good |
| 40065 | scoreboard | ch0 pkt matched: addr=0 len=1 (249 matched so far) |
| 40075 | **DUT** | OUT ch0 pkt #250 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40095 | **DUT** | OUT ch0 pkt #250 done: 3 bytes in 3 cycles |
| 40095 | ch0 monitor | ch0 RX pkt #250: addr=0 len=1 parity=good |
| 40095 | scoreboard | ch0 pkt matched: addr=0 len=1 (250 matched so far) |
| 40165 | **DUT** | IN  pkt #251 header: addr=0 len=1 -> channel 0 |
| 40175 | **DUT** | OUT ch0 pkt #251 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40185 | **DUT** | IN  pkt #251 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40185 | yapp monitor | RX pkt #251 on the input: addr=0 len=1 parity=good gap=18 |
| 40185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40190 | yapp driver | TX pkt #251 accepted by the DUT |
| 40190 | yapp driver | TX pkt #252: addr=0 len=1 parity=good delay=1 |
| 40195 | **DUT** | OUT ch0 pkt #251 done: 3 bytes in 3 cycles |
| 40195 | ch0 monitor | ch0 RX pkt #251: addr=0 len=1 parity=good |
| 40195 | scoreboard | ch0 pkt matched: addr=0 len=1 (251 matched so far) |
| 40205 | **DUT** | IN  pkt #252 header: addr=0 len=1 -> channel 0 |
| 40215 | **DUT** | OUT ch0 pkt #252 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40225 | **DUT** | IN  pkt #252 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40225 | yapp monitor | RX pkt #252 on the input: addr=0 len=1 parity=good gap=1 |
| 40225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40230 | yapp driver | TX pkt #252 accepted by the DUT |
| 40230 | yapp driver | TX pkt #253: addr=0 len=1 parity=good delay=18 |
| 40235 | **DUT** | OUT ch0 pkt #252 done: 3 bytes in 3 cycles |
| 40235 | ch0 monitor | ch0 RX pkt #252: addr=0 len=1 parity=good |
| 40235 | scoreboard | ch0 pkt matched: addr=0 len=1 (252 matched so far) |
| 40260 | ch0 driver | ch0: packet consumed (response delay 6) |
| 40415 | **DUT** | IN  pkt #253 header: addr=0 len=1 -> channel 0 |
| 40435 | **DUT** | IN  pkt #253 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40435 | yapp monitor | RX pkt #253 on the input: addr=0 len=1 parity=good gap=18 |
| 40435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40440 | yapp driver | TX pkt #253 accepted by the DUT |
| 40440 | yapp driver | TX pkt #254: addr=0 len=1 parity=good delay=20 |
| 40525 | **DUT** | OUT ch0 pkt #253 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 40540 | ch0 driver | ch0: packet consumed (response delay 10) |
| 40575 | **DUT** | OUT ch0 pkt #253 done: 3 bytes in 6 cycles |
| 40575 | ch0 monitor | ch0 RX pkt #253: addr=0 len=1 parity=good |
| 40575 | scoreboard | ch0 pkt matched: addr=0 len=1 (253 matched so far) |
| 40645 | **DUT** | IN  pkt #254 header: addr=0 len=1 -> channel 0 |
| 40655 | **DUT** | OUT ch0 pkt #254 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40665 | **DUT** | IN  pkt #254 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40665 | yapp monitor | RX pkt #254 on the input: addr=0 len=1 parity=good gap=20 |
| 40665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40670 | yapp driver | TX pkt #254 accepted by the DUT |
| 40670 | yapp driver | TX pkt #255: addr=0 len=1 parity=good delay=20 |
| 40675 | **DUT** | OUT ch0 pkt #254 done: 3 bytes in 3 cycles |
| 40675 | ch0 monitor | ch0 RX pkt #254: addr=0 len=1 parity=good |
| 40675 | scoreboard | ch0 pkt matched: addr=0 len=1 (254 matched so far) |
| 40780 | ch0 driver | ch0: packet consumed (response delay 2) |
| 40875 | **DUT** | IN  pkt #255 header: addr=0 len=1 -> channel 0 |
| 40895 | **DUT** | IN  pkt #255 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40895 | yapp monitor | RX pkt #255 on the input: addr=0 len=1 parity=good gap=20 |
| 40895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40900 | yapp driver | TX pkt #255 accepted by the DUT |
| 40985 | **DUT** | OUT ch0 pkt #255 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 41000 | ch0 driver | ch0: packet consumed (response delay 10) |
| 41115 | **DUT** | OUT ch0 pkt #255 done: 3 bytes in 14 cycles |
| 41115 | ch0 monitor | ch0 RX pkt #255: addr=0 len=1 parity=good |
| 41115 | scoreboard | ch0 pkt matched: addr=0 len=1 (255 matched so far) |
| 41140 | hbus driver | Executed READ  addr=0x1009 data=0xff |
| 41140 | **test** | addr0_cnt_reg reads 255 as expected |
| 41140 | **test** | STAGE: 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 41140 | yapp driver | TX pkt #256: addr=0 len=1 parity=good delay=20 |
| 41145 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 41340 | ch0 driver | ch0: packet consumed (response delay 10) |
| 41355 | **DUT** | IN  pkt #256 header: addr=0 len=1 -> channel 0 |
| 41375 | **DUT** | IN  pkt #256 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41375 | yapp monitor | RX pkt #256 on the input: addr=0 len=1 parity=good gap=45 |
| 41375 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41380 | yapp driver | TX pkt #256 accepted by the DUT |
| 41405 | **DUT** | OUT ch0 pkt #256 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 41420 | ch0 driver | ch0: packet consumed (response delay 4) |
| 41435 | **DUT** | OUT ch0 pkt #256 done: 3 bytes in 4 cycles |
| 41435 | ch0 monitor | ch0 RX pkt #256: addr=0 len=1 parity=good |
| 41435 | scoreboard | ch0 pkt matched: addr=0 len=1 (256 matched so far) |
| 41460 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 41460 | **test** | addr0_cnt_reg reads 0 as expected |
| 41460 | **test** | STAGE: 3. one more packet: the counter goes on from 0 |
| 41460 | yapp driver | TX pkt #257: addr=0 len=1 parity=good delay=18 |
| 41465 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41655 | **DUT** | IN  pkt #257 header: addr=0 len=1 -> channel 0 |
| 41665 | **DUT** | OUT ch0 pkt #257 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41675 | **DUT** | IN  pkt #257 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41675 | yapp monitor | RX pkt #257 on the input: addr=0 len=1 parity=good gap=27 |
| 41675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41680 | yapp driver | TX pkt #257 accepted by the DUT |
| 41685 | **DUT** | OUT ch0 pkt #257 done: 3 bytes in 3 cycles |
| 41685 | ch0 monitor | ch0 RX pkt #257: addr=0 len=1 parity=good |
| 41685 | scoreboard | ch0 pkt matched: addr=0 len=1 (257 matched so far) |
| 41710 | hbus driver | Executed READ  addr=0x1009 data=0x01 |
| 41710 | **test** | addr0_cnt_reg reads 1 as expected |
| 41710 | **test** | STAGE: 4. the other counters are untouched and the scoreboard matched all 257 packets |
| 41715 | hbus monitor | Collected READ  addr=0x1009 data=0x01 |
| 41740 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 41740 | **test** | addr1_cnt_reg reads 0 as expected |
| 41745 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41770 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 41770 | **test** | addr2_cnt_reg reads 0 as expected |
| 41775 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 41800 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 41800 | **test** | addr3_cnt_reg reads 0 as expected |
| 41805 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41830 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 41830 | **test** | parity_err_cnt_reg reads 0 as expected |
| 41835 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41860 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 41860 | **test** | oversized_pkt_cnt_reg reads 0 as expected |
| 41865 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41900 | ch0 driver | ch0: packet consumed (response delay 0) |
| 42060 | ch0 monitor | Channel 0 report: 257 packets collected |
| 42060 | ch1 monitor | Channel 1 report: 0 packets collected |
| 42060 | ch2 monitor | Channel 2 report: 0 packets collected |
| 42060 | hbus monitor | HBUS report: 1 writes, 8 reads |
| 42060 | coverage | Coverage of the router configuration: 26.1% |
| 42060 | reference |  |
| 42060 | scoreboard |  |
| 42060 | yapp driver | YAPP driver report: 257 packets sent |
| 42060 | coverage | YAPP gap coverage: 256 gaps sampled, coverage 75.0% |
| 42060 | yapp monitor | YAPP monitor report: 257 packets collected, 0 with bad parity |
| 42060 | yapp monitor | YAPP gaps: 0 back to back, 18 of 1 cycle, 8 of 2, 230 longer |
| 42060 | coverage | YAPP packet coverage: 257 packets sampled, coverage 13.3% |
