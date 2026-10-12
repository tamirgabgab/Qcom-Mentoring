# counter_wrap_test  seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 43us · log `counter_wrap_test_s3.log`

Waves: `counter_wrap_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fcounter_wrap_test_s3%2Fcounter_wrap_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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
| 42310 | 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 42580 | 3. one more packet: the counter goes on from 0 |
| 42770 | 4. the other counters are untouched and the scoreboard matched all 257 packets |

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

2760 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 70 | **test** | STAGE: 1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255 |
| 70 | yapp driver | TX pkt #1: addr=0 len=1 parity=good delay=10 |
| 75 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 75 | reference | router_en is now 1 |
| 185 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> channel 0 |
| 205 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 205 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=good gap=13 |
| 205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 210 | yapp driver | TX pkt #1 accepted by the DUT |
| 210 | yapp driver | TX pkt #2: addr=0 len=1 parity=good delay=20 |
| 285 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 300 | ch0 driver | ch0: packet consumed (response delay 9) |
| 325 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 5 cycles |
| 325 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 325 | scoreboard | ch0 pkt matched: addr=0 len=1 (1 matched so far) |
| 340 | ch0 driver | ch0: packet consumed (response delay 1) |
| 415 | **DUT** | IN  pkt #2 header: addr=0 len=1 -> channel 0 |
| 435 | **DUT** | IN  pkt #2 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 435 | yapp monitor | RX pkt #2 on the input: addr=0 len=1 parity=good gap=20 |
| 435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 440 | yapp driver | TX pkt #2 accepted by the DUT |
| 440 | yapp driver | TX pkt #3: addr=0 len=1 parity=good delay=19 |
| 485 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 500 | ch0 driver | ch0: packet consumed (response delay 6) |
| 595 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 12 cycles |
| 595 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=good |
| 595 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 635 | **DUT** | IN  pkt #3 header: addr=0 len=1 -> channel 0 |
| 645 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 655 | **DUT** | IN  pkt #3 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 655 | yapp monitor | RX pkt #3 on the input: addr=0 len=1 parity=good gap=19 |
| 655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 660 | yapp driver | TX pkt #3 accepted by the DUT |
| 660 | yapp driver | TX pkt #4: addr=0 len=1 parity=good delay=19 |
| 665 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 665 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 665 | scoreboard | ch0 pkt matched: addr=0 len=1 (3 matched so far) |
| 690 | ch0 driver | ch0: packet consumed (response delay 8) |
| 855 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> channel 0 |
| 875 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 875 | yapp monitor | RX pkt #4 on the input: addr=0 len=1 parity=good gap=19 |
| 875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 880 | yapp driver | TX pkt #4 accepted by the DUT |
| 880 | yapp driver | TX pkt #5: addr=0 len=1 parity=good delay=19 |
| 935 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 950 | ch0 driver | ch0: packet consumed (response delay 7) |
| 1065 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 14 cycles |
| 1065 | ch0 monitor | ch0 RX pkt #4: addr=0 len=1 parity=good |
| 1065 | scoreboard | ch0 pkt matched: addr=0 len=1 (4 matched so far) |
| 1075 | **DUT** | IN  pkt #5 header: addr=0 len=1 -> channel 0 |
| 1085 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1095 | **DUT** | IN  pkt #5 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1095 | yapp monitor | RX pkt #5 on the input: addr=0 len=1 parity=good gap=19 |
| 1095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1100 | yapp driver | TX pkt #5 accepted by the DUT |
| 1100 | yapp driver | TX pkt #6: addr=0 len=1 parity=good delay=16 |
| 1105 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 3 cycles |
| 1105 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 1105 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 1265 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> channel 0 |
| 1275 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1285 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1285 | yapp monitor | RX pkt #6 on the input: addr=0 len=1 parity=good gap=16 |
| 1285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1290 | yapp driver | TX pkt #6 accepted by the DUT |
| 1290 | yapp driver | TX pkt #7: addr=0 len=1 parity=good delay=11 |
| 1295 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 1295 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=good |
| 1295 | scoreboard | ch0 pkt matched: addr=0 len=1 (6 matched so far) |
| 1405 | **DUT** | IN  pkt #7 header: addr=0 len=1 -> channel 0 |
| 1415 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1425 | **DUT** | IN  pkt #7 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1425 | yapp monitor | RX pkt #7 on the input: addr=0 len=1 parity=good gap=11 |
| 1425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1430 | yapp driver | TX pkt #7 accepted by the DUT |
| 1430 | yapp driver | TX pkt #8: addr=0 len=1 parity=good delay=18 |
| 1435 | **DUT** | OUT ch0 pkt #7 done: 3 bytes in 3 cycles |
| 1435 | ch0 monitor | ch0 RX pkt #7: addr=0 len=1 parity=good |
| 1435 | scoreboard | ch0 pkt matched: addr=0 len=1 (7 matched so far) |
| 1520 | ch0 driver | ch0: packet consumed (response delay 10) |
| 1615 | **DUT** | IN  pkt #8 header: addr=0 len=1 -> channel 0 |
| 1635 | **DUT** | IN  pkt #8 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1635 | yapp monitor | RX pkt #8 on the input: addr=0 len=1 parity=good gap=18 |
| 1635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1640 | yapp driver | TX pkt #8 accepted by the DUT |
| 1640 | yapp driver | TX pkt #9: addr=0 len=1 parity=good delay=17 |
| 1645 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 1660 | ch0 driver | ch0: packet consumed (response delay 2) |
| 1745 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 11 cycles |
| 1745 | ch0 monitor | ch0 RX pkt #8: addr=0 len=1 parity=good |
| 1745 | scoreboard | ch0 pkt matched: addr=0 len=1 (8 matched so far) |
| 1815 | **DUT** | IN  pkt #9 header: addr=0 len=1 -> channel 0 |
| 1825 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1835 | **DUT** | IN  pkt #9 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1835 | yapp monitor | RX pkt #9 on the input: addr=0 len=1 parity=good gap=17 |
| 1835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1840 | yapp driver | TX pkt #9 accepted by the DUT |
| 1840 | yapp driver | TX pkt #10: addr=0 len=1 parity=good delay=5 |
| 1845 | **DUT** | OUT ch0 pkt #9 done: 3 bytes in 3 cycles |
| 1845 | ch0 monitor | ch0 RX pkt #9: addr=0 len=1 parity=good |
| 1845 | scoreboard | ch0 pkt matched: addr=0 len=1 (9 matched so far) |
| 1895 | **DUT** | IN  pkt #10 header: addr=0 len=1 -> channel 0 |
| 1905 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1915 | **DUT** | IN  pkt #10 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1915 | yapp monitor | RX pkt #10 on the input: addr=0 len=1 parity=good gap=5 |
| 1915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1920 | yapp driver | TX pkt #10 accepted by the DUT |
| 1920 | yapp driver | TX pkt #11: addr=0 len=1 parity=good delay=3 |
| 1925 | **DUT** | OUT ch0 pkt #10 done: 3 bytes in 3 cycles |
| 1925 | ch0 monitor | ch0 RX pkt #10: addr=0 len=1 parity=good |
| 1925 | scoreboard | ch0 pkt matched: addr=0 len=1 (10 matched so far) |
| 1955 | **DUT** | IN  pkt #11 header: addr=0 len=1 -> channel 0 |
| 1965 | **DUT** | OUT ch0 pkt #11 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1975 | **DUT** | IN  pkt #11 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1975 | yapp monitor | RX pkt #11 on the input: addr=0 len=1 parity=good gap=3 |
| 1975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1980 | yapp driver | TX pkt #11 accepted by the DUT |
| 1980 | yapp driver | TX pkt #12: addr=0 len=1 parity=good delay=6 |
| 1985 | **DUT** | OUT ch0 pkt #11 done: 3 bytes in 3 cycles |
| 1985 | ch0 monitor | ch0 RX pkt #11: addr=0 len=1 parity=good |
| 1985 | scoreboard | ch0 pkt matched: addr=0 len=1 (11 matched so far) |
| 2045 | **DUT** | IN  pkt #12 header: addr=0 len=1 -> channel 0 |
| 2055 | **DUT** | OUT ch0 pkt #12 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2065 | **DUT** | IN  pkt #12 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2065 | yapp monitor | RX pkt #12 on the input: addr=0 len=1 parity=good gap=6 |
| 2065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2070 | yapp driver | TX pkt #12 accepted by the DUT |
| 2070 | yapp driver | TX pkt #13: addr=0 len=1 parity=good delay=20 |
| 2075 | **DUT** | OUT ch0 pkt #12 done: 3 bytes in 3 cycles |
| 2075 | ch0 monitor | ch0 RX pkt #12: addr=0 len=1 parity=good |
| 2075 | scoreboard | ch0 pkt matched: addr=0 len=1 (12 matched so far) |
| 2275 | **DUT** | IN  pkt #13 header: addr=0 len=1 -> channel 0 |
| 2285 | **DUT** | OUT ch0 pkt #13 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2295 | **DUT** | IN  pkt #13 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2295 | yapp monitor | RX pkt #13 on the input: addr=0 len=1 parity=good gap=20 |
| 2295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2300 | yapp driver | TX pkt #13 accepted by the DUT |
| 2300 | yapp driver | TX pkt #14: addr=0 len=1 parity=good delay=19 |
| 2305 | **DUT** | OUT ch0 pkt #13 done: 3 bytes in 3 cycles |
| 2305 | ch0 monitor | ch0 RX pkt #13: addr=0 len=1 parity=good |
| 2305 | scoreboard | ch0 pkt matched: addr=0 len=1 (13 matched so far) |
| 2380 | ch0 driver | ch0: packet consumed (response delay 7) |
| 2495 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> channel 0 |
| 2515 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2515 | yapp monitor | RX pkt #14 on the input: addr=0 len=1 parity=good gap=19 |
| 2515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2520 | yapp driver | TX pkt #14 accepted by the DUT |
| 2520 | yapp driver | TX pkt #15: addr=0 len=1 parity=good delay=20 |
| 2565 | **DUT** | OUT ch0 pkt #14 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 2580 | ch0 driver | ch0: packet consumed (response delay 6) |
| 2695 | **DUT** | OUT ch0 pkt #14 done: 3 bytes in 14 cycles |
| 2695 | ch0 monitor | ch0 RX pkt #14: addr=0 len=1 parity=good |
| 2695 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 2720 | ch0 driver | ch0: packet consumed (response delay 10) |
| 2725 | **DUT** | IN  pkt #15 header: addr=0 len=1 -> channel 0 |
| 2735 | **DUT** | OUT ch0 pkt #15 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2745 | **DUT** | IN  pkt #15 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2745 | yapp monitor | RX pkt #15 on the input: addr=0 len=1 parity=good gap=20 |
| 2745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2750 | ch0 driver | ch0: packet consumed (response delay 0) |
| 2750 | yapp driver | TX pkt #15 accepted by the DUT |
| 2750 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=20 |
| 2825 | **DUT** | OUT ch0 pkt #15 done: 3 bytes in 10 cycles |
| 2825 | ch0 monitor | ch0 RX pkt #15: addr=0 len=1 parity=good |
| 2825 | scoreboard | ch0 pkt matched: addr=0 len=1 (15 matched so far) |
| 2955 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 2965 | **DUT** | OUT ch0 pkt #16 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2975 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2975 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=20 |
| 2975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2980 | yapp driver | TX pkt #16 accepted by the DUT |
| 2980 | yapp driver | TX pkt #17: addr=0 len=1 parity=good delay=17 |
| 2985 | **DUT** | OUT ch0 pkt #16 done: 3 bytes in 3 cycles |
| 2985 | ch0 monitor | ch0 RX pkt #16: addr=0 len=1 parity=good |
| 2985 | scoreboard | ch0 pkt matched: addr=0 len=1 (16 matched so far) |
| 3155 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 3165 | **DUT** | OUT ch0 pkt #17 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3175 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3175 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=good gap=17 |
| 3175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3180 | yapp driver | TX pkt #17 accepted by the DUT |
| 3180 | yapp driver | TX pkt #18: addr=0 len=1 parity=good delay=20 |
| 3185 | **DUT** | OUT ch0 pkt #17 done: 3 bytes in 3 cycles |
| 3185 | ch0 monitor | ch0 RX pkt #17: addr=0 len=1 parity=good |
| 3185 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 3385 | **DUT** | IN  pkt #18 header: addr=0 len=1 -> channel 0 |
| 3395 | **DUT** | OUT ch0 pkt #18 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3405 | **DUT** | IN  pkt #18 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3405 | yapp monitor | RX pkt #18 on the input: addr=0 len=1 parity=good gap=20 |
| 3405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3410 | yapp driver | TX pkt #18 accepted by the DUT |
| 3410 | yapp driver | TX pkt #19: addr=0 len=1 parity=good delay=10 |
| 3415 | **DUT** | OUT ch0 pkt #18 done: 3 bytes in 3 cycles |
| 3415 | ch0 monitor | ch0 RX pkt #18: addr=0 len=1 parity=good |
| 3415 | scoreboard | ch0 pkt matched: addr=0 len=1 (18 matched so far) |
| 3460 | ch0 driver | ch0: packet consumed (response delay 6) |
| 3515 | **DUT** | IN  pkt #19 header: addr=0 len=1 -> channel 0 |
| 3535 | **DUT** | IN  pkt #19 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3535 | yapp monitor | RX pkt #19 on the input: addr=0 len=1 parity=good gap=10 |
| 3535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3540 | yapp driver | TX pkt #19 accepted by the DUT |
| 3540 | yapp driver | TX pkt #20: addr=0 len=1 parity=good delay=18 |
| 3625 | **DUT** | OUT ch0 pkt #19 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 3640 | ch0 driver | ch0: packet consumed (response delay 10) |
| 3725 | **DUT** | IN  pkt #20 header: addr=0 len=1 -> channel 0 |
| 3745 | **DUT** | IN  pkt #20 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3745 | yapp monitor | RX pkt #20 on the input: addr=0 len=1 parity=good gap=18 |
| 3745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3750 | yapp driver | TX pkt #20 accepted by the DUT |
| 3750 | yapp driver | TX pkt #21: addr=0 len=1 parity=good delay=4 |
| 3755 | **DUT** | OUT ch0 pkt #19 done: 3 bytes in 14 cycles |
| 3755 | ch0 monitor | ch0 RX pkt #19: addr=0 len=1 parity=good |
| 3755 | scoreboard | ch0 pkt matched: addr=0 len=1 (19 matched so far) |
| 3765 | **DUT** | OUT ch0 pkt #20 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3785 | **DUT** | OUT ch0 pkt #20 done: 3 bytes in 3 cycles |
| 3785 | ch0 monitor | ch0 RX pkt #20: addr=0 len=1 parity=good |
| 3785 | scoreboard | ch0 pkt matched: addr=0 len=1 (20 matched so far) |
| 3795 | **DUT** | IN  pkt #21 header: addr=0 len=1 -> channel 0 |
| 3805 | **DUT** | OUT ch0 pkt #21 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3815 | **DUT** | IN  pkt #21 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3815 | yapp monitor | RX pkt #21 on the input: addr=0 len=1 parity=good gap=4 |
| 3815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3820 | yapp driver | TX pkt #21 accepted by the DUT |
| 3820 | yapp driver | TX pkt #22: addr=0 len=1 parity=good delay=16 |
| 3825 | **DUT** | OUT ch0 pkt #21 done: 3 bytes in 3 cycles |
| 3825 | ch0 monitor | ch0 RX pkt #21: addr=0 len=1 parity=good |
| 3825 | scoreboard | ch0 pkt matched: addr=0 len=1 (21 matched so far) |
| 3860 | ch0 driver | ch0: packet consumed (response delay 10) |
| 3985 | **DUT** | IN  pkt #22 header: addr=0 len=1 -> channel 0 |
| 4005 | **DUT** | IN  pkt #22 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4005 | yapp monitor | RX pkt #22 on the input: addr=0 len=1 parity=good gap=16 |
| 4005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4010 | yapp driver | TX pkt #22 accepted by the DUT |
| 4010 | yapp driver | TX pkt #23: addr=0 len=1 parity=good delay=10 |
| 4045 | **DUT** | OUT ch0 pkt #22 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 4060 | ch0 driver | ch0: packet consumed (response delay 5) |
| 4115 | **DUT** | IN  pkt #23 header: addr=0 len=1 -> channel 0 |
| 4135 | **DUT** | IN  pkt #23 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4135 | yapp monitor | RX pkt #23 on the input: addr=0 len=1 parity=good gap=10 |
| 4135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4140 | yapp driver | TX pkt #23 accepted by the DUT |
| 4140 | yapp driver | TX pkt #24: addr=0 len=1 parity=good delay=18 |
| 4175 | **DUT** | OUT ch0 pkt #22 done: 3 bytes in 14 cycles |
| 4175 | ch0 monitor | ch0 RX pkt #22: addr=0 len=1 parity=good |
| 4175 | scoreboard | ch0 pkt matched: addr=0 len=1 (22 matched so far) |
| 4185 | **DUT** | OUT ch0 pkt #23 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4205 | **DUT** | OUT ch0 pkt #23 done: 3 bytes in 3 cycles |
| 4205 | ch0 monitor | ch0 RX pkt #23: addr=0 len=1 parity=good |
| 4205 | scoreboard | ch0 pkt matched: addr=0 len=1 (23 matched so far) |
| 4270 | ch0 driver | ch0: packet consumed (response delay 10) |
| 4325 | **DUT** | IN  pkt #24 header: addr=0 len=1 -> channel 0 |
| 4345 | **DUT** | IN  pkt #24 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4345 | yapp monitor | RX pkt #24 on the input: addr=0 len=1 parity=good gap=18 |
| 4345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4350 | yapp driver | TX pkt #24 accepted by the DUT |
| 4350 | yapp driver | TX pkt #25: addr=0 len=1 parity=good delay=20 |
| 4405 | **DUT** | OUT ch0 pkt #24 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 4420 | ch0 driver | ch0: packet consumed (response delay 7) |
| 4435 | **DUT** | OUT ch0 pkt #24 done: 3 bytes in 4 cycles |
| 4435 | ch0 monitor | ch0 RX pkt #24: addr=0 len=1 parity=good |
| 4435 | scoreboard | ch0 pkt matched: addr=0 len=1 (24 matched so far) |
| 4555 | **DUT** | IN  pkt #25 header: addr=0 len=1 -> channel 0 |
| 4565 | **DUT** | OUT ch0 pkt #25 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4575 | **DUT** | IN  pkt #25 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4575 | yapp monitor | RX pkt #25 on the input: addr=0 len=1 parity=good gap=20 |
| 4575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4580 | yapp driver | TX pkt #25 accepted by the DUT |
| 4580 | yapp driver | TX pkt #26: addr=0 len=1 parity=good delay=20 |
| 4585 | **DUT** | OUT ch0 pkt #25 done: 3 bytes in 3 cycles |
| 4585 | ch0 monitor | ch0 RX pkt #25: addr=0 len=1 parity=good |
| 4585 | scoreboard | ch0 pkt matched: addr=0 len=1 (25 matched so far) |
| 4785 | **DUT** | IN  pkt #26 header: addr=0 len=1 -> channel 0 |
| 4795 | **DUT** | OUT ch0 pkt #26 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4805 | **DUT** | IN  pkt #26 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4805 | yapp monitor | RX pkt #26 on the input: addr=0 len=1 parity=good gap=20 |
| 4805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4810 | yapp driver | TX pkt #26 accepted by the DUT |
| 4810 | yapp driver | TX pkt #27: addr=0 len=1 parity=good delay=17 |
| 4815 | **DUT** | OUT ch0 pkt #26 done: 3 bytes in 3 cycles |
| 4815 | ch0 monitor | ch0 RX pkt #26: addr=0 len=1 parity=good |
| 4815 | scoreboard | ch0 pkt matched: addr=0 len=1 (26 matched so far) |
| 4985 | **DUT** | IN  pkt #27 header: addr=0 len=1 -> channel 0 |
| 4995 | **DUT** | OUT ch0 pkt #27 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5005 | **DUT** | IN  pkt #27 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5005 | yapp monitor | RX pkt #27 on the input: addr=0 len=1 parity=good gap=17 |
| 5005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5010 | yapp driver | TX pkt #27 accepted by the DUT |
| 5010 | yapp driver | TX pkt #28: addr=0 len=1 parity=good delay=17 |
| 5015 | **DUT** | OUT ch0 pkt #27 done: 3 bytes in 3 cycles |
| 5015 | ch0 monitor | ch0 RX pkt #27: addr=0 len=1 parity=good |
| 5015 | scoreboard | ch0 pkt matched: addr=0 len=1 (27 matched so far) |
| 5060 | ch0 driver | ch0: packet consumed (response delay 0) |
| 5185 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 5205 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5205 | yapp monitor | RX pkt #28 on the input: addr=0 len=1 parity=good gap=17 |
| 5205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5210 | yapp driver | TX pkt #28 accepted by the DUT |
| 5210 | yapp driver | TX pkt #29: addr=0 len=1 parity=good delay=4 |
| 5255 | **DUT** | IN  pkt #29 header: addr=0 len=1 -> channel 0 |
| 5275 | **DUT** | IN  pkt #29 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5275 | yapp monitor | RX pkt #29 on the input: addr=0 len=1 parity=good gap=4 |
| 5275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5280 | yapp driver | TX pkt #29 accepted by the DUT |
| 5280 | yapp driver | TX pkt #30: addr=0 len=1 parity=good delay=10 |
| 5295 | **DUT** | OUT ch0 pkt #28 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 5310 | ch0 driver | ch0: packet consumed (response delay 10) |
| 5325 | **DUT** | OUT ch0 pkt #28 done: 3 bytes in 4 cycles |
| 5325 | ch0 monitor | ch0 RX pkt #28: addr=0 len=1 parity=good |
| 5325 | scoreboard | ch0 pkt matched: addr=0 len=1 (28 matched so far) |
| 5335 | **DUT** | OUT ch0 pkt #29 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5355 | **DUT** | OUT ch0 pkt #29 done: 3 bytes in 3 cycles |
| 5355 | ch0 monitor | ch0 RX pkt #29: addr=0 len=1 parity=good |
| 5355 | scoreboard | ch0 pkt matched: addr=0 len=1 (29 matched so far) |
| 5385 | **DUT** | IN  pkt #30 header: addr=0 len=1 -> channel 0 |
| 5390 | ch0 driver | ch0: packet consumed (response delay 0) |
| 5405 | **DUT** | IN  pkt #30 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5405 | yapp monitor | RX pkt #30 on the input: addr=0 len=1 parity=good gap=10 |
| 5405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5410 | yapp driver | TX pkt #30 accepted by the DUT |
| 5410 | yapp driver | TX pkt #31: addr=0 len=1 parity=good delay=20 |
| 5505 | **DUT** | OUT ch0 pkt #30 start: addr=0 len=1 (receiver waited 11 cycle(s)) |
| 5520 | ch0 driver | ch0: packet consumed (response delay 10) |
| 5615 | **DUT** | IN  pkt #31 header: addr=0 len=1 -> channel 0 |
| 5625 | **DUT** | OUT ch0 pkt #30 done: 3 bytes in 13 cycles |
| 5625 | ch0 monitor | ch0 RX pkt #30: addr=0 len=1 parity=good |
| 5625 | scoreboard | ch0 pkt matched: addr=0 len=1 (30 matched so far) |
| 5635 | **DUT** | IN  pkt #31 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5635 | **DUT** | OUT ch0 pkt #31 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5635 | yapp monitor | RX pkt #31 on the input: addr=0 len=1 parity=good gap=20 |
| 5635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5640 | yapp driver | TX pkt #31 accepted by the DUT |
| 5640 | yapp driver | TX pkt #32: addr=0 len=1 parity=good delay=15 |
| 5655 | **DUT** | OUT ch0 pkt #31 done: 3 bytes in 3 cycles |
| 5655 | ch0 monitor | ch0 RX pkt #31: addr=0 len=1 parity=good |
| 5655 | scoreboard | ch0 pkt matched: addr=0 len=1 (31 matched so far) |
| 5795 | **DUT** | IN  pkt #32 header: addr=0 len=1 -> channel 0 |
| 5805 | **DUT** | OUT ch0 pkt #32 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5815 | **DUT** | IN  pkt #32 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5815 | yapp monitor | RX pkt #32 on the input: addr=0 len=1 parity=good gap=15 |
| 5815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5820 | yapp driver | TX pkt #32 accepted by the DUT |
| 5820 | yapp driver | TX pkt #33: addr=0 len=1 parity=good delay=2 |
| 5825 | **DUT** | OUT ch0 pkt #32 done: 3 bytes in 3 cycles |
| 5825 | ch0 monitor | ch0 RX pkt #32: addr=0 len=1 parity=good |
| 5825 | scoreboard | ch0 pkt matched: addr=0 len=1 (32 matched so far) |
| 5830 | ch0 driver | ch0: packet consumed (response delay 9) |
| 5845 | **DUT** | IN  pkt #33 header: addr=0 len=1 -> channel 0 |
| 5865 | **DUT** | IN  pkt #33 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5865 | yapp monitor | RX pkt #33 on the input: addr=0 len=1 parity=good gap=2 |
| 5865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5870 | yapp driver | TX pkt #33 accepted by the DUT |
| 5870 | yapp driver | TX pkt #34: addr=0 len=1 parity=good delay=16 |
| 5945 | **DUT** | OUT ch0 pkt #33 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 5960 | ch0 driver | ch0: packet consumed (response delay 9) |
| 6035 | **DUT** | IN  pkt #34 header: addr=0 len=1 -> channel 0 |
| 6055 | **DUT** | IN  pkt #34 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6055 | yapp monitor | RX pkt #34 on the input: addr=0 len=1 parity=good gap=16 |
| 6055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6060 | yapp driver | TX pkt #34 accepted by the DUT |
| 6060 | yapp driver | TX pkt #35: addr=0 len=1 parity=good delay=20 |
| 6075 | **DUT** | OUT ch0 pkt #33 done: 3 bytes in 14 cycles |
| 6075 | ch0 monitor | ch0 RX pkt #33: addr=0 len=1 parity=good |
| 6075 | scoreboard | ch0 pkt matched: addr=0 len=1 (33 matched so far) |
| 6085 | **DUT** | OUT ch0 pkt #34 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6105 | **DUT** | OUT ch0 pkt #34 done: 3 bytes in 3 cycles |
| 6105 | ch0 monitor | ch0 RX pkt #34: addr=0 len=1 parity=good |
| 6105 | scoreboard | ch0 pkt matched: addr=0 len=1 (34 matched so far) |
| 6265 | **DUT** | IN  pkt #35 header: addr=0 len=1 -> channel 0 |
| 6275 | **DUT** | OUT ch0 pkt #35 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6285 | **DUT** | IN  pkt #35 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6285 | yapp monitor | RX pkt #35 on the input: addr=0 len=1 parity=good gap=20 |
| 6285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6290 | yapp driver | TX pkt #35 accepted by the DUT |
| 6290 | yapp driver | TX pkt #36: addr=0 len=1 parity=good delay=2 |
| 6295 | **DUT** | OUT ch0 pkt #35 done: 3 bytes in 3 cycles |
| 6295 | ch0 monitor | ch0 RX pkt #35: addr=0 len=1 parity=good |
| 6295 | scoreboard | ch0 pkt matched: addr=0 len=1 (35 matched so far) |
| 6315 | **DUT** | IN  pkt #36 header: addr=0 len=1 -> channel 0 |
| 6325 | **DUT** | OUT ch0 pkt #36 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6335 | **DUT** | IN  pkt #36 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6335 | yapp monitor | RX pkt #36 on the input: addr=0 len=1 parity=good gap=2 |
| 6335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6340 | yapp driver | TX pkt #36 accepted by the DUT |
| 6340 | yapp driver | TX pkt #37: addr=0 len=1 parity=good delay=20 |
| 6345 | **DUT** | OUT ch0 pkt #36 done: 3 bytes in 3 cycles |
| 6345 | ch0 monitor | ch0 RX pkt #36: addr=0 len=1 parity=good |
| 6345 | scoreboard | ch0 pkt matched: addr=0 len=1 (36 matched so far) |
| 6510 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6545 | **DUT** | IN  pkt #37 header: addr=0 len=1 -> channel 0 |
| 6565 | **DUT** | IN  pkt #37 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6565 | yapp monitor | RX pkt #37 on the input: addr=0 len=1 parity=good gap=20 |
| 6565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6570 | yapp driver | TX pkt #37 accepted by the DUT |
| 6570 | yapp driver | TX pkt #38: addr=0 len=1 parity=good delay=13 |
| 6575 | **DUT** | OUT ch0 pkt #37 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 6590 | ch0 driver | ch0: packet consumed (response delay 2) |
| 6705 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 6705 | **DUT** | OUT ch0 pkt #37 done: 3 bytes in 14 cycles |
| 6705 | ch0 monitor | ch0 RX pkt #37: addr=0 len=1 parity=good |
| 6705 | scoreboard | ch0 pkt matched: addr=0 len=1 (37 matched so far) |
| 6715 | **DUT** | OUT ch0 pkt #38 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6725 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6725 | yapp monitor | RX pkt #38 on the input: addr=0 len=1 parity=good gap=13 |
| 6725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6730 | yapp driver | TX pkt #38 accepted by the DUT |
| 6730 | yapp driver | TX pkt #39: addr=0 len=1 parity=good delay=6 |
| 6735 | **DUT** | OUT ch0 pkt #38 done: 3 bytes in 3 cycles |
| 6735 | ch0 monitor | ch0 RX pkt #38: addr=0 len=1 parity=good |
| 6735 | scoreboard | ch0 pkt matched: addr=0 len=1 (38 matched so far) |
| 6750 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6795 | **DUT** | IN  pkt #39 header: addr=0 len=1 -> channel 0 |
| 6815 | **DUT** | IN  pkt #39 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6815 | yapp monitor | RX pkt #39 on the input: addr=0 len=1 parity=good gap=6 |
| 6815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6820 | yapp driver | TX pkt #39 accepted by the DUT |
| 6820 | yapp driver | TX pkt #40: addr=0 len=1 parity=good delay=20 |
| 6905 | **DUT** | OUT ch0 pkt #39 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 6920 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6945 | **DUT** | OUT ch0 pkt #39 done: 3 bytes in 5 cycles |
| 6945 | ch0 monitor | ch0 RX pkt #39: addr=0 len=1 parity=good |
| 6945 | scoreboard | ch0 pkt matched: addr=0 len=1 (39 matched so far) |
| 7025 | **DUT** | IN  pkt #40 header: addr=0 len=1 -> channel 0 |
| 7035 | **DUT** | OUT ch0 pkt #40 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7045 | **DUT** | IN  pkt #40 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7045 | yapp monitor | RX pkt #40 on the input: addr=0 len=1 parity=good gap=20 |
| 7045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7050 | yapp driver | TX pkt #40 accepted by the DUT |
| 7050 | yapp driver | TX pkt #41: addr=0 len=1 parity=good delay=8 |
| 7055 | **DUT** | OUT ch0 pkt #40 done: 3 bytes in 3 cycles |
| 7055 | ch0 monitor | ch0 RX pkt #40: addr=0 len=1 parity=good |
| 7055 | scoreboard | ch0 pkt matched: addr=0 len=1 (40 matched so far) |
| 7100 | ch0 driver | ch0: packet consumed (response delay 1) |
| 7135 | **DUT** | IN  pkt #41 header: addr=0 len=1 -> channel 0 |
| 7155 | **DUT** | IN  pkt #41 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7155 | yapp monitor | RX pkt #41 on the input: addr=0 len=1 parity=good gap=8 |
| 7155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7160 | yapp driver | TX pkt #41 accepted by the DUT |
| 7160 | yapp driver | TX pkt #42: addr=0 len=1 parity=good delay=20 |
| 7205 | **DUT** | OUT ch0 pkt #41 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 7220 | ch0 driver | ch0: packet consumed (response delay 6) |
| 7275 | **DUT** | OUT ch0 pkt #41 done: 3 bytes in 8 cycles |
| 7275 | ch0 monitor | ch0 RX pkt #41: addr=0 len=1 parity=good |
| 7275 | scoreboard | ch0 pkt matched: addr=0 len=1 (41 matched so far) |
| 7365 | **DUT** | IN  pkt #42 header: addr=0 len=1 -> channel 0 |
| 7375 | **DUT** | OUT ch0 pkt #42 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7385 | **DUT** | IN  pkt #42 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7385 | yapp monitor | RX pkt #42 on the input: addr=0 len=1 parity=good gap=20 |
| 7385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7390 | yapp driver | TX pkt #42 accepted by the DUT |
| 7390 | yapp driver | TX pkt #43: addr=0 len=1 parity=good delay=1 |
| 7395 | **DUT** | OUT ch0 pkt #42 done: 3 bytes in 3 cycles |
| 7395 | ch0 monitor | ch0 RX pkt #42: addr=0 len=1 parity=good |
| 7395 | scoreboard | ch0 pkt matched: addr=0 len=1 (42 matched so far) |
| 7405 | **DUT** | IN  pkt #43 header: addr=0 len=1 -> channel 0 |
| 7415 | **DUT** | OUT ch0 pkt #43 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7425 | **DUT** | IN  pkt #43 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7425 | yapp monitor | RX pkt #43 on the input: addr=0 len=1 parity=good gap=1 |
| 7425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7430 | yapp driver | TX pkt #43 accepted by the DUT |
| 7430 | yapp driver | TX pkt #44: addr=0 len=1 parity=good delay=5 |
| 7435 | **DUT** | OUT ch0 pkt #43 done: 3 bytes in 3 cycles |
| 7435 | ch0 monitor | ch0 RX pkt #43: addr=0 len=1 parity=good |
| 7435 | scoreboard | ch0 pkt matched: addr=0 len=1 (43 matched so far) |
| 7450 | ch0 driver | ch0: packet consumed (response delay 4) |
| 7485 | **DUT** | IN  pkt #44 header: addr=0 len=1 -> channel 0 |
| 7505 | **DUT** | IN  pkt #44 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7505 | yapp monitor | RX pkt #44 on the input: addr=0 len=1 parity=good gap=5 |
| 7505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7510 | yapp driver | TX pkt #44 accepted by the DUT |
| 7510 | yapp driver | TX pkt #45: addr=0 len=1 parity=good delay=5 |
| 7535 | **DUT** | OUT ch0 pkt #44 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 7550 | ch0 driver | ch0: packet consumed (response delay 4) |
| 7565 | **DUT** | IN  pkt #45 header: addr=0 len=1 -> channel 0 |
| 7585 | **DUT** | IN  pkt #45 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7585 | yapp monitor | RX pkt #45 on the input: addr=0 len=1 parity=good gap=5 |
| 7585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7590 | yapp driver | TX pkt #45 accepted by the DUT |
| 7590 | yapp driver | TX pkt #46: addr=0 len=1 parity=good delay=7 |
| 7605 | **DUT** | OUT ch0 pkt #44 done: 3 bytes in 8 cycles |
| 7605 | ch0 monitor | ch0 RX pkt #44: addr=0 len=1 parity=good |
| 7605 | scoreboard | ch0 pkt matched: addr=0 len=1 (44 matched so far) |
| 7615 | **DUT** | OUT ch0 pkt #45 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7635 | **DUT** | OUT ch0 pkt #45 done: 3 bytes in 3 cycles |
| 7635 | ch0 monitor | ch0 RX pkt #45: addr=0 len=1 parity=good |
| 7635 | scoreboard | ch0 pkt matched: addr=0 len=1 (45 matched so far) |
| 7665 | **DUT** | IN  pkt #46 header: addr=0 len=1 -> channel 0 |
| 7675 | **DUT** | OUT ch0 pkt #46 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7685 | **DUT** | IN  pkt #46 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7685 | yapp monitor | RX pkt #46 on the input: addr=0 len=1 parity=good gap=7 |
| 7685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7690 | yapp driver | TX pkt #46 accepted by the DUT |
| 7690 | yapp driver | TX pkt #47: addr=0 len=1 parity=good delay=17 |
| 7695 | **DUT** | OUT ch0 pkt #46 done: 3 bytes in 3 cycles |
| 7695 | ch0 monitor | ch0 RX pkt #46: addr=0 len=1 parity=good |
| 7695 | scoreboard | ch0 pkt matched: addr=0 len=1 (46 matched so far) |
| 7865 | **DUT** | IN  pkt #47 header: addr=0 len=1 -> channel 0 |
| 7875 | **DUT** | OUT ch0 pkt #47 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7885 | **DUT** | IN  pkt #47 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7885 | yapp monitor | RX pkt #47 on the input: addr=0 len=1 parity=good gap=17 |
| 7885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7890 | yapp driver | TX pkt #47 accepted by the DUT |
| 7890 | yapp driver | TX pkt #48: addr=0 len=1 parity=good delay=20 |
| 7895 | **DUT** | OUT ch0 pkt #47 done: 3 bytes in 3 cycles |
| 7895 | ch0 monitor | ch0 RX pkt #47: addr=0 len=1 parity=good |
| 7895 | scoreboard | ch0 pkt matched: addr=0 len=1 (47 matched so far) |
| 7900 | ch0 driver | ch0: packet consumed (response delay 4) |
| 8095 | **DUT** | IN  pkt #48 header: addr=0 len=1 -> channel 0 |
| 8115 | **DUT** | IN  pkt #48 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8115 | yapp monitor | RX pkt #48 on the input: addr=0 len=1 parity=good gap=20 |
| 8115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8120 | yapp driver | TX pkt #48 accepted by the DUT |
| 8120 | yapp driver | TX pkt #49: addr=0 len=1 parity=good delay=20 |
| 8145 | **DUT** | OUT ch0 pkt #48 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 8160 | ch0 driver | ch0: packet consumed (response delay 4) |
| 8265 | **DUT** | OUT ch0 pkt #48 done: 3 bytes in 13 cycles |
| 8265 | ch0 monitor | ch0 RX pkt #48: addr=0 len=1 parity=good |
| 8265 | scoreboard | ch0 pkt matched: addr=0 len=1 (48 matched so far) |
| 8325 | **DUT** | IN  pkt #49 header: addr=0 len=1 -> channel 0 |
| 8335 | **DUT** | OUT ch0 pkt #49 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8345 | **DUT** | IN  pkt #49 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8345 | yapp monitor | RX pkt #49 on the input: addr=0 len=1 parity=good gap=20 |
| 8345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8350 | yapp driver | TX pkt #49 accepted by the DUT |
| 8350 | yapp driver | TX pkt #50: addr=0 len=1 parity=good delay=20 |
| 8355 | **DUT** | OUT ch0 pkt #49 done: 3 bytes in 3 cycles |
| 8355 | ch0 monitor | ch0 RX pkt #49: addr=0 len=1 parity=good |
| 8355 | scoreboard | ch0 pkt matched: addr=0 len=1 (49 matched so far) |
| 8555 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> channel 0 |
| 8565 | **DUT** | OUT ch0 pkt #50 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8575 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8575 | yapp monitor | RX pkt #50 on the input: addr=0 len=1 parity=good gap=20 |
| 8575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8580 | ch0 driver | ch0: packet consumed (response delay 9) |
| 8580 | yapp driver | TX pkt #50 accepted by the DUT |
| 8580 | yapp driver | TX pkt #51: addr=0 len=1 parity=good delay=5 |
| 8635 | **DUT** | IN  pkt #51 header: addr=0 len=1 -> channel 0 |
| 8655 | **DUT** | IN  pkt #51 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8655 | yapp monitor | RX pkt #51 on the input: addr=0 len=1 parity=good gap=5 |
| 8655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8660 | yapp driver | TX pkt #51 accepted by the DUT |
| 8660 | yapp driver | TX pkt #52: addr=0 len=1 parity=good delay=20 |
| 8695 | **DUT** | OUT ch0 pkt #50 done: 3 bytes in 14 cycles |
| 8695 | ch0 monitor | ch0 RX pkt #50: addr=0 len=1 parity=good |
| 8695 | scoreboard | ch0 pkt matched: addr=0 len=1 (50 matched so far) |
| 8705 | **DUT** | OUT ch0 pkt #51 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8725 | **DUT** | OUT ch0 pkt #51 done: 3 bytes in 3 cycles |
| 8725 | ch0 monitor | ch0 RX pkt #51: addr=0 len=1 parity=good |
| 8725 | scoreboard | ch0 pkt matched: addr=0 len=1 (51 matched so far) |
| 8780 | ch0 driver | ch0: packet consumed (response delay 10) |
| 8865 | **DUT** | IN  pkt #52 header: addr=0 len=1 -> channel 0 |
| 8885 | **DUT** | IN  pkt #52 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8885 | yapp monitor | RX pkt #52 on the input: addr=0 len=1 parity=good gap=20 |
| 8885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8890 | yapp driver | TX pkt #52 accepted by the DUT |
| 8890 | yapp driver | TX pkt #53: addr=0 len=1 parity=good delay=19 |
| 8935 | **DUT** | OUT ch0 pkt #52 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 8950 | ch0 driver | ch0: packet consumed (response delay 6) |
| 9055 | **DUT** | OUT ch0 pkt #52 done: 3 bytes in 13 cycles |
| 9055 | ch0 monitor | ch0 RX pkt #52: addr=0 len=1 parity=good |
| 9055 | scoreboard | ch0 pkt matched: addr=0 len=1 (52 matched so far) |
| 9085 | **DUT** | IN  pkt #53 header: addr=0 len=1 -> channel 0 |
| 9095 | **DUT** | OUT ch0 pkt #53 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9105 | **DUT** | IN  pkt #53 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9105 | yapp monitor | RX pkt #53 on the input: addr=0 len=1 parity=good gap=19 |
| 9105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9110 | yapp driver | TX pkt #53 accepted by the DUT |
| 9110 | yapp driver | TX pkt #54: addr=0 len=1 parity=good delay=3 |
| 9115 | **DUT** | OUT ch0 pkt #53 done: 3 bytes in 3 cycles |
| 9115 | ch0 monitor | ch0 RX pkt #53: addr=0 len=1 parity=good |
| 9115 | scoreboard | ch0 pkt matched: addr=0 len=1 (53 matched so far) |
| 9145 | **DUT** | IN  pkt #54 header: addr=0 len=1 -> channel 0 |
| 9155 | **DUT** | OUT ch0 pkt #54 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9165 | **DUT** | IN  pkt #54 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9165 | yapp monitor | RX pkt #54 on the input: addr=0 len=1 parity=good gap=3 |
| 9165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9170 | yapp driver | TX pkt #54 accepted by the DUT |
| 9170 | yapp driver | TX pkt #55: addr=0 len=1 parity=good delay=20 |
| 9175 | **DUT** | OUT ch0 pkt #54 done: 3 bytes in 3 cycles |
| 9175 | ch0 monitor | ch0 RX pkt #54: addr=0 len=1 parity=good |
| 9175 | scoreboard | ch0 pkt matched: addr=0 len=1 (54 matched so far) |
| 9375 | **DUT** | IN  pkt #55 header: addr=0 len=1 -> channel 0 |
| 9385 | **DUT** | OUT ch0 pkt #55 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9395 | **DUT** | IN  pkt #55 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9395 | yapp monitor | RX pkt #55 on the input: addr=0 len=1 parity=good gap=20 |
| 9395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9400 | yapp driver | TX pkt #55 accepted by the DUT |
| 9400 | yapp driver | TX pkt #56: addr=0 len=1 parity=good delay=16 |
| 9405 | **DUT** | OUT ch0 pkt #55 done: 3 bytes in 3 cycles |
| 9405 | ch0 monitor | ch0 RX pkt #55: addr=0 len=1 parity=good |
| 9405 | scoreboard | ch0 pkt matched: addr=0 len=1 (55 matched so far) |
| 9520 | ch0 driver | ch0: packet consumed (response delay 9) |
| 9565 | **DUT** | IN  pkt #56 header: addr=0 len=1 -> channel 0 |
| 9585 | **DUT** | IN  pkt #56 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9585 | **DUT** | OUT ch0 pkt #56 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 9585 | yapp monitor | RX pkt #56 on the input: addr=0 len=1 parity=good gap=16 |
| 9585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9590 | yapp driver | TX pkt #56 accepted by the DUT |
| 9590 | yapp driver | TX pkt #57: addr=0 len=1 parity=good delay=20 |
| 9600 | ch0 driver | ch0: packet consumed (response delay 1) |
| 9705 | **DUT** | OUT ch0 pkt #56 done: 3 bytes in 13 cycles |
| 9705 | ch0 monitor | ch0 RX pkt #56: addr=0 len=1 parity=good |
| 9705 | scoreboard | ch0 pkt matched: addr=0 len=1 (56 matched so far) |
| 9795 | **DUT** | IN  pkt #57 header: addr=0 len=1 -> channel 0 |
| 9805 | **DUT** | OUT ch0 pkt #57 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9815 | **DUT** | IN  pkt #57 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9815 | yapp monitor | RX pkt #57 on the input: addr=0 len=1 parity=good gap=20 |
| 9815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9820 | yapp driver | TX pkt #57 accepted by the DUT |
| 9820 | yapp driver | TX pkt #58: addr=0 len=1 parity=good delay=16 |
| 9825 | **DUT** | OUT ch0 pkt #57 done: 3 bytes in 3 cycles |
| 9825 | ch0 monitor | ch0 RX pkt #57: addr=0 len=1 parity=good |
| 9825 | scoreboard | ch0 pkt matched: addr=0 len=1 (57 matched so far) |
| 9985 | **DUT** | IN  pkt #58 header: addr=0 len=1 -> channel 0 |
| 9995 | **DUT** | OUT ch0 pkt #58 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10005 | **DUT** | IN  pkt #58 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10005 | yapp monitor | RX pkt #58 on the input: addr=0 len=1 parity=good gap=16 |
| 10005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10010 | yapp driver | TX pkt #58 accepted by the DUT |
| 10010 | yapp driver | TX pkt #59: addr=0 len=1 parity=good delay=9 |
| 10015 | **DUT** | OUT ch0 pkt #58 done: 3 bytes in 3 cycles |
| 10015 | ch0 monitor | ch0 RX pkt #58: addr=0 len=1 parity=good |
| 10015 | scoreboard | ch0 pkt matched: addr=0 len=1 (58 matched so far) |
| 10105 | **DUT** | IN  pkt #59 header: addr=0 len=1 -> channel 0 |
| 10115 | **DUT** | OUT ch0 pkt #59 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10125 | **DUT** | IN  pkt #59 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10125 | yapp monitor | RX pkt #59 on the input: addr=0 len=1 parity=good gap=9 |
| 10125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10130 | yapp driver | TX pkt #59 accepted by the DUT |
| 10130 | yapp driver | TX pkt #60: addr=0 len=1 parity=good delay=1 |
| 10135 | **DUT** | OUT ch0 pkt #59 done: 3 bytes in 3 cycles |
| 10135 | ch0 monitor | ch0 RX pkt #59: addr=0 len=1 parity=good |
| 10135 | scoreboard | ch0 pkt matched: addr=0 len=1 (59 matched so far) |
| 10145 | **DUT** | IN  pkt #60 header: addr=0 len=1 -> channel 0 |
| 10155 | **DUT** | OUT ch0 pkt #60 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10165 | **DUT** | IN  pkt #60 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10165 | yapp monitor | RX pkt #60 on the input: addr=0 len=1 parity=good gap=1 |
| 10165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10170 | yapp driver | TX pkt #60 accepted by the DUT |
| 10170 | yapp driver | TX pkt #61: addr=0 len=1 parity=good delay=16 |
| 10175 | **DUT** | OUT ch0 pkt #60 done: 3 bytes in 3 cycles |
| 10175 | ch0 monitor | ch0 RX pkt #60: addr=0 len=1 parity=good |
| 10175 | scoreboard | ch0 pkt matched: addr=0 len=1 (60 matched so far) |
| 10260 | ch0 driver | ch0: packet consumed (response delay 9) |
| 10335 | **DUT** | IN  pkt #61 header: addr=0 len=1 -> channel 0 |
| 10345 | **DUT** | OUT ch0 pkt #61 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10355 | **DUT** | IN  pkt #61 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10355 | yapp monitor | RX pkt #61 on the input: addr=0 len=1 parity=good gap=16 |
| 10355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10360 | ch0 driver | ch0: packet consumed (response delay 0) |
| 10360 | yapp driver | TX pkt #61 accepted by the DUT |
| 10360 | yapp driver | TX pkt #62: addr=0 len=1 parity=good delay=15 |
| 10395 | **DUT** | OUT ch0 pkt #61 done: 3 bytes in 6 cycles |
| 10395 | ch0 monitor | ch0 RX pkt #61: addr=0 len=1 parity=good |
| 10395 | scoreboard | ch0 pkt matched: addr=0 len=1 (61 matched so far) |
| 10515 | **DUT** | IN  pkt #62 header: addr=0 len=1 -> channel 0 |
| 10525 | **DUT** | OUT ch0 pkt #62 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10535 | **DUT** | IN  pkt #62 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10535 | yapp monitor | RX pkt #62 on the input: addr=0 len=1 parity=good gap=15 |
| 10535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10540 | yapp driver | TX pkt #62 accepted by the DUT |
| 10540 | yapp driver | TX pkt #63: addr=0 len=1 parity=good delay=20 |
| 10545 | **DUT** | OUT ch0 pkt #62 done: 3 bytes in 3 cycles |
| 10545 | ch0 monitor | ch0 RX pkt #62: addr=0 len=1 parity=good |
| 10545 | scoreboard | ch0 pkt matched: addr=0 len=1 (62 matched so far) |
| 10630 | ch0 driver | ch0: packet consumed (response delay 2) |
| 10745 | **DUT** | IN  pkt #63 header: addr=0 len=1 -> channel 0 |
| 10765 | **DUT** | IN  pkt #63 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10765 | yapp monitor | RX pkt #63 on the input: addr=0 len=1 parity=good gap=20 |
| 10765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10770 | yapp driver | TX pkt #63 accepted by the DUT |
| 10770 | yapp driver | TX pkt #64: addr=0 len=1 parity=good delay=19 |
| 10845 | **DUT** | OUT ch0 pkt #63 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 10860 | ch0 driver | ch0: packet consumed (response delay 9) |
| 10965 | **DUT** | IN  pkt #64 header: addr=0 len=1 -> channel 0 |
| 10975 | **DUT** | OUT ch0 pkt #63 done: 3 bytes in 14 cycles |
| 10975 | ch0 monitor | ch0 RX pkt #63: addr=0 len=1 parity=good |
| 10975 | scoreboard | ch0 pkt matched: addr=0 len=1 (63 matched so far) |
| 10985 | **DUT** | IN  pkt #64 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10985 | **DUT** | OUT ch0 pkt #64 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10985 | yapp monitor | RX pkt #64 on the input: addr=0 len=1 parity=good gap=19 |
| 10985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10990 | yapp driver | TX pkt #64 accepted by the DUT |
| 10990 | yapp driver | TX pkt #65: addr=0 len=1 parity=good delay=8 |
| 11005 | **DUT** | OUT ch0 pkt #64 done: 3 bytes in 3 cycles |
| 11005 | ch0 monitor | ch0 RX pkt #64: addr=0 len=1 parity=good |
| 11005 | scoreboard | ch0 pkt matched: addr=0 len=1 (64 matched so far) |
| 11075 | **DUT** | IN  pkt #65 header: addr=0 len=1 -> channel 0 |
| 11085 | **DUT** | OUT ch0 pkt #65 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11095 | **DUT** | IN  pkt #65 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11095 | yapp monitor | RX pkt #65 on the input: addr=0 len=1 parity=good gap=8 |
| 11095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11100 | yapp driver | TX pkt #65 accepted by the DUT |
| 11100 | yapp driver | TX pkt #66: addr=0 len=1 parity=good delay=20 |
| 11105 | **DUT** | OUT ch0 pkt #65 done: 3 bytes in 3 cycles |
| 11105 | ch0 monitor | ch0 RX pkt #65: addr=0 len=1 parity=good |
| 11105 | scoreboard | ch0 pkt matched: addr=0 len=1 (65 matched so far) |
| 11305 | **DUT** | IN  pkt #66 header: addr=0 len=1 -> channel 0 |
| 11315 | **DUT** | OUT ch0 pkt #66 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11325 | **DUT** | IN  pkt #66 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11325 | yapp monitor | RX pkt #66 on the input: addr=0 len=1 parity=good gap=20 |
| 11325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11330 | yapp driver | TX pkt #66 accepted by the DUT |
| 11330 | yapp driver | TX pkt #67: addr=0 len=1 parity=good delay=1 |
| 11335 | **DUT** | OUT ch0 pkt #66 done: 3 bytes in 3 cycles |
| 11335 | ch0 monitor | ch0 RX pkt #66: addr=0 len=1 parity=good |
| 11335 | scoreboard | ch0 pkt matched: addr=0 len=1 (66 matched so far) |
| 11345 | **DUT** | IN  pkt #67 header: addr=0 len=1 -> channel 0 |
| 11355 | **DUT** | OUT ch0 pkt #67 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11365 | **DUT** | IN  pkt #67 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11365 | yapp monitor | RX pkt #67 on the input: addr=0 len=1 parity=good gap=1 |
| 11365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11370 | yapp driver | TX pkt #67 accepted by the DUT |
| 11370 | yapp driver | TX pkt #68: addr=0 len=1 parity=good delay=17 |
| 11375 | **DUT** | OUT ch0 pkt #67 done: 3 bytes in 3 cycles |
| 11375 | ch0 monitor | ch0 RX pkt #67: addr=0 len=1 parity=good |
| 11375 | scoreboard | ch0 pkt matched: addr=0 len=1 (67 matched so far) |
| 11490 | ch0 driver | ch0: packet consumed (response delay 10) |
| 11545 | **DUT** | IN  pkt #68 header: addr=0 len=1 -> channel 0 |
| 11565 | **DUT** | IN  pkt #68 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11565 | yapp monitor | RX pkt #68 on the input: addr=0 len=1 parity=good gap=17 |
| 11565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11570 | yapp driver | TX pkt #68 accepted by the DUT |
| 11570 | yapp driver | TX pkt #69: addr=0 len=1 parity=good delay=19 |
| 11655 | **DUT** | OUT ch0 pkt #68 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 11670 | ch0 driver | ch0: packet consumed (response delay 10) |
| 11765 | **DUT** | IN  pkt #69 header: addr=0 len=1 -> channel 0 |
| 11785 | **DUT** | IN  pkt #69 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11785 | **DUT** | OUT ch0 pkt #68 done: 3 bytes in 14 cycles |
| 11785 | ch0 monitor | ch0 RX pkt #68: addr=0 len=1 parity=good |
| 11785 | scoreboard | ch0 pkt matched: addr=0 len=1 (68 matched so far) |
| 11785 | yapp monitor | RX pkt #69 on the input: addr=0 len=1 parity=good gap=19 |
| 11785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11790 | yapp driver | TX pkt #69 accepted by the DUT |
| 11790 | yapp driver | TX pkt #70: addr=0 len=1 parity=good delay=16 |
| 11795 | **DUT** | OUT ch0 pkt #69 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11815 | **DUT** | OUT ch0 pkt #69 done: 3 bytes in 3 cycles |
| 11815 | ch0 monitor | ch0 RX pkt #69: addr=0 len=1 parity=good |
| 11815 | scoreboard | ch0 pkt matched: addr=0 len=1 (69 matched so far) |
| 11955 | **DUT** | IN  pkt #70 header: addr=0 len=1 -> channel 0 |
| 11965 | **DUT** | OUT ch0 pkt #70 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11975 | **DUT** | IN  pkt #70 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11975 | yapp monitor | RX pkt #70 on the input: addr=0 len=1 parity=good gap=16 |
| 11975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11980 | yapp driver | TX pkt #70 accepted by the DUT |
| 11980 | yapp driver | TX pkt #71: addr=0 len=1 parity=good delay=2 |
| 11985 | **DUT** | OUT ch0 pkt #70 done: 3 bytes in 3 cycles |
| 11985 | ch0 monitor | ch0 RX pkt #70: addr=0 len=1 parity=good |
| 11985 | scoreboard | ch0 pkt matched: addr=0 len=1 (70 matched so far) |
| 12005 | **DUT** | IN  pkt #71 header: addr=0 len=1 -> channel 0 |
| 12015 | **DUT** | OUT ch0 pkt #71 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12025 | **DUT** | IN  pkt #71 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12025 | yapp monitor | RX pkt #71 on the input: addr=0 len=1 parity=good gap=2 |
| 12025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12030 | yapp driver | TX pkt #71 accepted by the DUT |
| 12030 | yapp driver | TX pkt #72: addr=0 len=1 parity=good delay=16 |
| 12035 | **DUT** | OUT ch0 pkt #71 done: 3 bytes in 3 cycles |
| 12035 | ch0 monitor | ch0 RX pkt #71: addr=0 len=1 parity=good |
| 12035 | scoreboard | ch0 pkt matched: addr=0 len=1 (71 matched so far) |
| 12190 | ch0 driver | ch0: packet consumed (response delay 10) |
| 12195 | **DUT** | IN  pkt #72 header: addr=0 len=1 -> channel 0 |
| 12215 | **DUT** | IN  pkt #72 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12215 | yapp monitor | RX pkt #72 on the input: addr=0 len=1 parity=good gap=16 |
| 12215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12220 | yapp driver | TX pkt #72 accepted by the DUT |
| 12220 | yapp driver | TX pkt #73: addr=0 len=1 parity=good delay=20 |
| 12295 | **DUT** | OUT ch0 pkt #72 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 12310 | ch0 driver | ch0: packet consumed (response delay 9) |
| 12325 | **DUT** | OUT ch0 pkt #72 done: 3 bytes in 4 cycles |
| 12325 | ch0 monitor | ch0 RX pkt #72: addr=0 len=1 parity=good |
| 12325 | scoreboard | ch0 pkt matched: addr=0 len=1 (72 matched so far) |
| 12425 | **DUT** | IN  pkt #73 header: addr=0 len=1 -> channel 0 |
| 12435 | **DUT** | OUT ch0 pkt #73 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12445 | **DUT** | IN  pkt #73 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12445 | yapp monitor | RX pkt #73 on the input: addr=0 len=1 parity=good gap=20 |
| 12445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12450 | yapp driver | TX pkt #73 accepted by the DUT |
| 12450 | yapp driver | TX pkt #74: addr=0 len=1 parity=good delay=13 |
| 12455 | **DUT** | OUT ch0 pkt #73 done: 3 bytes in 3 cycles |
| 12455 | ch0 monitor | ch0 RX pkt #73: addr=0 len=1 parity=good |
| 12455 | scoreboard | ch0 pkt matched: addr=0 len=1 (73 matched so far) |
| 12480 | ch0 driver | ch0: packet consumed (response delay 0) |
| 12585 | **DUT** | IN  pkt #74 header: addr=0 len=1 -> channel 0 |
| 12605 | **DUT** | IN  pkt #74 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12605 | **DUT** | OUT ch0 pkt #74 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 12605 | yapp monitor | RX pkt #74 on the input: addr=0 len=1 parity=good gap=13 |
| 12605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12610 | yapp driver | TX pkt #74 accepted by the DUT |
| 12610 | yapp driver | TX pkt #75: addr=0 len=1 parity=good delay=15 |
| 12620 | ch0 driver | ch0: packet consumed (response delay 1) |
| 12725 | **DUT** | OUT ch0 pkt #74 done: 3 bytes in 13 cycles |
| 12725 | ch0 monitor | ch0 RX pkt #74: addr=0 len=1 parity=good |
| 12725 | scoreboard | ch0 pkt matched: addr=0 len=1 (74 matched so far) |
| 12765 | **DUT** | IN  pkt #75 header: addr=0 len=1 -> channel 0 |
| 12775 | **DUT** | OUT ch0 pkt #75 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12785 | **DUT** | IN  pkt #75 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12785 | yapp monitor | RX pkt #75 on the input: addr=0 len=1 parity=good gap=15 |
| 12785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12790 | yapp driver | TX pkt #75 accepted by the DUT |
| 12790 | yapp driver | TX pkt #76: addr=0 len=1 parity=good delay=17 |
| 12795 | **DUT** | OUT ch0 pkt #75 done: 3 bytes in 3 cycles |
| 12795 | ch0 monitor | ch0 RX pkt #75: addr=0 len=1 parity=good |
| 12795 | scoreboard | ch0 pkt matched: addr=0 len=1 (75 matched so far) |
| 12965 | **DUT** | IN  pkt #76 header: addr=0 len=1 -> channel 0 |
| 12975 | **DUT** | OUT ch0 pkt #76 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12985 | **DUT** | IN  pkt #76 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12985 | yapp monitor | RX pkt #76 on the input: addr=0 len=1 parity=good gap=17 |
| 12985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12990 | yapp driver | TX pkt #76 accepted by the DUT |
| 12990 | yapp driver | TX pkt #77: addr=0 len=1 parity=good delay=12 |
| 12995 | **DUT** | OUT ch0 pkt #76 done: 3 bytes in 3 cycles |
| 12995 | ch0 monitor | ch0 RX pkt #76: addr=0 len=1 parity=good |
| 12995 | scoreboard | ch0 pkt matched: addr=0 len=1 (76 matched so far) |
| 13070 | ch0 driver | ch0: packet consumed (response delay 9) |
| 13115 | **DUT** | IN  pkt #77 header: addr=0 len=1 -> channel 0 |
| 13125 | **DUT** | OUT ch0 pkt #77 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13135 | **DUT** | IN  pkt #77 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13135 | yapp monitor | RX pkt #77 on the input: addr=0 len=1 parity=good gap=12 |
| 13135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13140 | ch0 driver | ch0: packet consumed (response delay 0) |
| 13140 | yapp driver | TX pkt #77 accepted by the DUT |
| 13140 | yapp driver | TX pkt #78: addr=0 len=1 parity=good delay=16 |
| 13235 | **DUT** | OUT ch0 pkt #77 done: 3 bytes in 12 cycles |
| 13235 | ch0 monitor | ch0 RX pkt #77: addr=0 len=1 parity=good |
| 13235 | scoreboard | ch0 pkt matched: addr=0 len=1 (77 matched so far) |
| 13305 | **DUT** | IN  pkt #78 header: addr=0 len=1 -> channel 0 |
| 13315 | **DUT** | OUT ch0 pkt #78 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13325 | **DUT** | IN  pkt #78 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13325 | yapp monitor | RX pkt #78 on the input: addr=0 len=1 parity=good gap=16 |
| 13325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13330 | yapp driver | TX pkt #78 accepted by the DUT |
| 13330 | yapp driver | TX pkt #79: addr=0 len=1 parity=good delay=14 |
| 13335 | **DUT** | OUT ch0 pkt #78 done: 3 bytes in 3 cycles |
| 13335 | ch0 monitor | ch0 RX pkt #78: addr=0 len=1 parity=good |
| 13335 | scoreboard | ch0 pkt matched: addr=0 len=1 (78 matched so far) |
| 13475 | **DUT** | IN  pkt #79 header: addr=0 len=1 -> channel 0 |
| 13485 | **DUT** | OUT ch0 pkt #79 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13495 | **DUT** | IN  pkt #79 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13495 | yapp monitor | RX pkt #79 on the input: addr=0 len=1 parity=good gap=14 |
| 13495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13500 | yapp driver | TX pkt #79 accepted by the DUT |
| 13500 | yapp driver | TX pkt #80: addr=0 len=1 parity=good delay=14 |
| 13505 | **DUT** | OUT ch0 pkt #79 done: 3 bytes in 3 cycles |
| 13505 | ch0 monitor | ch0 RX pkt #79: addr=0 len=1 parity=good |
| 13505 | scoreboard | ch0 pkt matched: addr=0 len=1 (79 matched so far) |
| 13645 | **DUT** | IN  pkt #80 header: addr=0 len=1 -> channel 0 |
| 13655 | **DUT** | OUT ch0 pkt #80 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13665 | **DUT** | IN  pkt #80 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13665 | yapp monitor | RX pkt #80 on the input: addr=0 len=1 parity=good gap=14 |
| 13665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13670 | yapp driver | TX pkt #80 accepted by the DUT |
| 13670 | yapp driver | TX pkt #81: addr=0 len=1 parity=good delay=18 |
| 13675 | **DUT** | OUT ch0 pkt #80 done: 3 bytes in 3 cycles |
| 13675 | ch0 monitor | ch0 RX pkt #80: addr=0 len=1 parity=good |
| 13675 | scoreboard | ch0 pkt matched: addr=0 len=1 (80 matched so far) |
| 13780 | ch0 driver | ch0: packet consumed (response delay 8) |
| 13855 | **DUT** | IN  pkt #81 header: addr=0 len=1 -> channel 0 |
| 13875 | **DUT** | IN  pkt #81 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13875 | yapp monitor | RX pkt #81 on the input: addr=0 len=1 parity=good gap=18 |
| 13875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13880 | yapp driver | TX pkt #81 accepted by the DUT |
| 13880 | yapp driver | TX pkt #82: addr=0 len=1 parity=good delay=1 |
| 13895 | **DUT** | IN  pkt #82 header: addr=0 len=1 -> channel 0 |
| 13915 | **DUT** | IN  pkt #82 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13915 | yapp monitor | RX pkt #82 on the input: addr=0 len=1 parity=good gap=1 |
| 13915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13920 | yapp driver | TX pkt #82 accepted by the DUT |
| 13920 | yapp driver | TX pkt #83: addr=0 len=1 parity=good delay=17 |
| 13965 | **DUT** | OUT ch0 pkt #81 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 13980 | ch0 driver | ch0: packet consumed (response delay 10) |
| 14035 | **DUT** | OUT ch0 pkt #81 done: 3 bytes in 8 cycles |
| 14035 | ch0 monitor | ch0 RX pkt #81: addr=0 len=1 parity=good |
| 14035 | scoreboard | ch0 pkt matched: addr=0 len=1 (81 matched so far) |
| 14045 | **DUT** | OUT ch0 pkt #82 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14065 | **DUT** | OUT ch0 pkt #82 done: 3 bytes in 3 cycles |
| 14065 | ch0 monitor | ch0 RX pkt #82: addr=0 len=1 parity=good |
| 14065 | scoreboard | ch0 pkt matched: addr=0 len=1 (82 matched so far) |
| 14095 | **DUT** | IN  pkt #83 header: addr=0 len=1 -> channel 0 |
| 14105 | **DUT** | OUT ch0 pkt #83 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14115 | **DUT** | IN  pkt #83 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14115 | yapp monitor | RX pkt #83 on the input: addr=0 len=1 parity=good gap=17 |
| 14115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14120 | yapp driver | TX pkt #83 accepted by the DUT |
| 14120 | yapp driver | TX pkt #84: addr=0 len=1 parity=good delay=10 |
| 14125 | **DUT** | OUT ch0 pkt #83 done: 3 bytes in 3 cycles |
| 14125 | ch0 monitor | ch0 RX pkt #83: addr=0 len=1 parity=good |
| 14125 | scoreboard | ch0 pkt matched: addr=0 len=1 (83 matched so far) |
| 14225 | **DUT** | IN  pkt #84 header: addr=0 len=1 -> channel 0 |
| 14235 | **DUT** | OUT ch0 pkt #84 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14245 | **DUT** | IN  pkt #84 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14245 | yapp monitor | RX pkt #84 on the input: addr=0 len=1 parity=good gap=10 |
| 14245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14250 | yapp driver | TX pkt #84 accepted by the DUT |
| 14250 | yapp driver | TX pkt #85: addr=0 len=1 parity=good delay=19 |
| 14255 | **DUT** | OUT ch0 pkt #84 done: 3 bytes in 3 cycles |
| 14255 | ch0 monitor | ch0 RX pkt #84: addr=0 len=1 parity=good |
| 14255 | scoreboard | ch0 pkt matched: addr=0 len=1 (84 matched so far) |
| 14445 | **DUT** | IN  pkt #85 header: addr=0 len=1 -> channel 0 |
| 14455 | **DUT** | OUT ch0 pkt #85 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14465 | **DUT** | IN  pkt #85 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14465 | yapp monitor | RX pkt #85 on the input: addr=0 len=1 parity=good gap=19 |
| 14465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14470 | yapp driver | TX pkt #85 accepted by the DUT |
| 14470 | yapp driver | TX pkt #86: addr=0 len=1 parity=good delay=1 |
| 14475 | **DUT** | OUT ch0 pkt #85 done: 3 bytes in 3 cycles |
| 14475 | ch0 monitor | ch0 RX pkt #85: addr=0 len=1 parity=good |
| 14475 | scoreboard | ch0 pkt matched: addr=0 len=1 (85 matched so far) |
| 14485 | **DUT** | IN  pkt #86 header: addr=0 len=1 -> channel 0 |
| 14495 | **DUT** | OUT ch0 pkt #86 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14505 | **DUT** | IN  pkt #86 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14505 | yapp monitor | RX pkt #86 on the input: addr=0 len=1 parity=good gap=1 |
| 14505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14510 | yapp driver | TX pkt #86 accepted by the DUT |
| 14510 | yapp driver | TX pkt #87: addr=0 len=1 parity=good delay=12 |
| 14515 | **DUT** | OUT ch0 pkt #86 done: 3 bytes in 3 cycles |
| 14515 | ch0 monitor | ch0 RX pkt #86: addr=0 len=1 parity=good |
| 14515 | scoreboard | ch0 pkt matched: addr=0 len=1 (86 matched so far) |
| 14600 | ch0 driver | ch0: packet consumed (response delay 4) |
| 14635 | **DUT** | IN  pkt #87 header: addr=0 len=1 -> channel 0 |
| 14655 | **DUT** | IN  pkt #87 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14655 | yapp monitor | RX pkt #87 on the input: addr=0 len=1 parity=good gap=12 |
| 14655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14660 | yapp driver | TX pkt #87 accepted by the DUT |
| 14660 | yapp driver | TX pkt #88: addr=0 len=1 parity=good delay=16 |
| 14745 | **DUT** | OUT ch0 pkt #87 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 14760 | ch0 driver | ch0: packet consumed (response delay 10) |
| 14785 | **DUT** | OUT ch0 pkt #87 done: 3 bytes in 5 cycles |
| 14785 | ch0 monitor | ch0 RX pkt #87: addr=0 len=1 parity=good |
| 14785 | scoreboard | ch0 pkt matched: addr=0 len=1 (87 matched so far) |
| 14825 | **DUT** | IN  pkt #88 header: addr=0 len=1 -> channel 0 |
| 14835 | **DUT** | OUT ch0 pkt #88 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14845 | **DUT** | IN  pkt #88 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14845 | yapp monitor | RX pkt #88 on the input: addr=0 len=1 parity=good gap=16 |
| 14845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14850 | yapp driver | TX pkt #88 accepted by the DUT |
| 14850 | yapp driver | TX pkt #89: addr=0 len=1 parity=good delay=4 |
| 14855 | **DUT** | OUT ch0 pkt #88 done: 3 bytes in 3 cycles |
| 14855 | ch0 monitor | ch0 RX pkt #88: addr=0 len=1 parity=good |
| 14855 | scoreboard | ch0 pkt matched: addr=0 len=1 (88 matched so far) |
| 14895 | **DUT** | IN  pkt #89 header: addr=0 len=1 -> channel 0 |
| 14905 | **DUT** | OUT ch0 pkt #89 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14915 | **DUT** | IN  pkt #89 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14915 | yapp monitor | RX pkt #89 on the input: addr=0 len=1 parity=good gap=4 |
| 14915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14920 | yapp driver | TX pkt #89 accepted by the DUT |
| 14920 | yapp driver | TX pkt #90: addr=0 len=1 parity=good delay=19 |
| 14925 | **DUT** | OUT ch0 pkt #89 done: 3 bytes in 3 cycles |
| 14925 | ch0 monitor | ch0 RX pkt #89: addr=0 len=1 parity=good |
| 14925 | scoreboard | ch0 pkt matched: addr=0 len=1 (89 matched so far) |
| 15115 | **DUT** | IN  pkt #90 header: addr=0 len=1 -> channel 0 |
| 15125 | **DUT** | OUT ch0 pkt #90 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15135 | **DUT** | IN  pkt #90 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15135 | yapp monitor | RX pkt #90 on the input: addr=0 len=1 parity=good gap=19 |
| 15135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15140 | yapp driver | TX pkt #90 accepted by the DUT |
| 15140 | yapp driver | TX pkt #91: addr=0 len=1 parity=good delay=7 |
| 15145 | **DUT** | OUT ch0 pkt #90 done: 3 bytes in 3 cycles |
| 15145 | ch0 monitor | ch0 RX pkt #90: addr=0 len=1 parity=good |
| 15145 | scoreboard | ch0 pkt matched: addr=0 len=1 (90 matched so far) |
| 15215 | **DUT** | IN  pkt #91 header: addr=0 len=1 -> channel 0 |
| 15225 | **DUT** | OUT ch0 pkt #91 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15235 | **DUT** | IN  pkt #91 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15235 | yapp monitor | RX pkt #91 on the input: addr=0 len=1 parity=good gap=7 |
| 15235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15240 | yapp driver | TX pkt #91 accepted by the DUT |
| 15240 | yapp driver | TX pkt #92: addr=0 len=1 parity=good delay=20 |
| 15245 | **DUT** | OUT ch0 pkt #91 done: 3 bytes in 3 cycles |
| 15245 | ch0 monitor | ch0 RX pkt #91: addr=0 len=1 parity=good |
| 15245 | scoreboard | ch0 pkt matched: addr=0 len=1 (91 matched so far) |
| 15420 | ch0 driver | ch0: packet consumed (response delay 1) |
| 15445 | **DUT** | IN  pkt #92 header: addr=0 len=1 -> channel 0 |
| 15465 | **DUT** | IN  pkt #92 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15465 | yapp monitor | RX pkt #92 on the input: addr=0 len=1 parity=good gap=20 |
| 15465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15470 | yapp driver | TX pkt #92 accepted by the DUT |
| 15470 | yapp driver | TX pkt #93: addr=0 len=1 parity=good delay=20 |
| 15545 | **DUT** | OUT ch0 pkt #92 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 15560 | ch0 driver | ch0: packet consumed (response delay 9) |
| 15645 | **DUT** | OUT ch0 pkt #92 done: 3 bytes in 11 cycles |
| 15645 | ch0 monitor | ch0 RX pkt #92: addr=0 len=1 parity=good |
| 15645 | scoreboard | ch0 pkt matched: addr=0 len=1 (92 matched so far) |
| 15675 | **DUT** | IN  pkt #93 header: addr=0 len=1 -> channel 0 |
| 15685 | **DUT** | OUT ch0 pkt #93 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15695 | **DUT** | IN  pkt #93 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15695 | yapp monitor | RX pkt #93 on the input: addr=0 len=1 parity=good gap=20 |
| 15695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15700 | yapp driver | TX pkt #93 accepted by the DUT |
| 15700 | yapp driver | TX pkt #94: addr=0 len=1 parity=good delay=1 |
| 15705 | **DUT** | OUT ch0 pkt #93 done: 3 bytes in 3 cycles |
| 15705 | ch0 monitor | ch0 RX pkt #93: addr=0 len=1 parity=good |
| 15705 | scoreboard | ch0 pkt matched: addr=0 len=1 (93 matched so far) |
| 15715 | **DUT** | IN  pkt #94 header: addr=0 len=1 -> channel 0 |
| 15725 | **DUT** | OUT ch0 pkt #94 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15735 | **DUT** | IN  pkt #94 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15735 | yapp monitor | RX pkt #94 on the input: addr=0 len=1 parity=good gap=1 |
| 15735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15740 | yapp driver | TX pkt #94 accepted by the DUT |
| 15740 | yapp driver | TX pkt #95: addr=0 len=1 parity=good delay=14 |
| 15745 | **DUT** | OUT ch0 pkt #94 done: 3 bytes in 3 cycles |
| 15745 | ch0 monitor | ch0 RX pkt #94: addr=0 len=1 parity=good |
| 15745 | scoreboard | ch0 pkt matched: addr=0 len=1 (94 matched so far) |
| 15870 | ch0 driver | ch0: packet consumed (response delay 7) |
| 15885 | **DUT** | IN  pkt #95 header: addr=0 len=1 -> channel 0 |
| 15905 | **DUT** | IN  pkt #95 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15905 | yapp monitor | RX pkt #95 on the input: addr=0 len=1 parity=good gap=14 |
| 15905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15910 | yapp driver | TX pkt #95 accepted by the DUT |
| 15910 | yapp driver | TX pkt #96: addr=0 len=1 parity=good delay=20 |
| 15985 | **DUT** | OUT ch0 pkt #95 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 16000 | ch0 driver | ch0: packet consumed (response delay 9) |
| 16115 | **DUT** | IN  pkt #96 header: addr=0 len=1 -> channel 0 |
| 16115 | **DUT** | OUT ch0 pkt #95 done: 3 bytes in 14 cycles |
| 16115 | ch0 monitor | ch0 RX pkt #95: addr=0 len=1 parity=good |
| 16115 | scoreboard | ch0 pkt matched: addr=0 len=1 (95 matched so far) |
| 16125 | **DUT** | OUT ch0 pkt #96 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16135 | **DUT** | IN  pkt #96 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16135 | yapp monitor | RX pkt #96 on the input: addr=0 len=1 parity=good gap=20 |
| 16135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16140 | yapp driver | TX pkt #96 accepted by the DUT |
| 16140 | yapp driver | TX pkt #97: addr=0 len=1 parity=good delay=8 |
| 16145 | **DUT** | OUT ch0 pkt #96 done: 3 bytes in 3 cycles |
| 16145 | ch0 monitor | ch0 RX pkt #96: addr=0 len=1 parity=good |
| 16145 | scoreboard | ch0 pkt matched: addr=0 len=1 (96 matched so far) |
| 16225 | **DUT** | IN  pkt #97 header: addr=0 len=1 -> channel 0 |
| 16235 | **DUT** | OUT ch0 pkt #97 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16245 | **DUT** | IN  pkt #97 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16245 | yapp monitor | RX pkt #97 on the input: addr=0 len=1 parity=good gap=8 |
| 16245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16250 | yapp driver | TX pkt #97 accepted by the DUT |
| 16250 | yapp driver | TX pkt #98: addr=0 len=1 parity=good delay=20 |
| 16255 | **DUT** | OUT ch0 pkt #97 done: 3 bytes in 3 cycles |
| 16255 | ch0 monitor | ch0 RX pkt #97: addr=0 len=1 parity=good |
| 16255 | scoreboard | ch0 pkt matched: addr=0 len=1 (97 matched so far) |
| 16370 | ch0 driver | ch0: packet consumed (response delay 10) |
| 16455 | **DUT** | IN  pkt #98 header: addr=0 len=1 -> channel 0 |
| 16475 | **DUT** | IN  pkt #98 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16475 | yapp monitor | RX pkt #98 on the input: addr=0 len=1 parity=good gap=20 |
| 16475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16480 | yapp driver | TX pkt #98 accepted by the DUT |
| 16480 | yapp driver | TX pkt #99: addr=0 len=1 parity=good delay=5 |
| 16485 | **DUT** | OUT ch0 pkt #98 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 16500 | ch0 driver | ch0: packet consumed (response delay 2) |
| 16535 | **DUT** | IN  pkt #99 header: addr=0 len=1 -> channel 0 |
| 16555 | **DUT** | IN  pkt #99 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16555 | yapp monitor | RX pkt #99 on the input: addr=0 len=1 parity=good gap=5 |
| 16555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16560 | yapp driver | TX pkt #99 accepted by the DUT |
| 16560 | yapp driver | TX pkt #100: addr=0 len=1 parity=good delay=20 |
| 16615 | **DUT** | OUT ch0 pkt #98 done: 3 bytes in 14 cycles |
| 16615 | ch0 monitor | ch0 RX pkt #98: addr=0 len=1 parity=good |
| 16615 | scoreboard | ch0 pkt matched: addr=0 len=1 (98 matched so far) |
| 16625 | **DUT** | OUT ch0 pkt #99 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16645 | **DUT** | OUT ch0 pkt #99 done: 3 bytes in 3 cycles |
| 16645 | ch0 monitor | ch0 RX pkt #99: addr=0 len=1 parity=good |
| 16645 | scoreboard | ch0 pkt matched: addr=0 len=1 (99 matched so far) |
| 16765 | **DUT** | IN  pkt #100 header: addr=0 len=1 -> channel 0 |
| 16775 | **DUT** | OUT ch0 pkt #100 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16785 | **DUT** | IN  pkt #100 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16785 | yapp monitor | RX pkt #100 on the input: addr=0 len=1 parity=good gap=20 |
| 16785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16790 | yapp driver | TX pkt #100 accepted by the DUT |
| 16790 | yapp driver | TX pkt #101: addr=0 len=1 parity=good delay=20 |
| 16795 | **DUT** | OUT ch0 pkt #100 done: 3 bytes in 3 cycles |
| 16795 | ch0 monitor | ch0 RX pkt #100: addr=0 len=1 parity=good |
| 16795 | scoreboard | ch0 pkt matched: addr=0 len=1 (100 matched so far) |
| 16995 | **DUT** | IN  pkt #101 header: addr=0 len=1 -> channel 0 |
| 17005 | **DUT** | OUT ch0 pkt #101 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17015 | **DUT** | IN  pkt #101 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17015 | yapp monitor | RX pkt #101 on the input: addr=0 len=1 parity=good gap=20 |
| 17015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17020 | yapp driver | TX pkt #101 accepted by the DUT |
| 17020 | yapp driver | TX pkt #102: addr=0 len=1 parity=good delay=8 |
| 17025 | **DUT** | OUT ch0 pkt #101 done: 3 bytes in 3 cycles |
| 17025 | ch0 monitor | ch0 RX pkt #101: addr=0 len=1 parity=good |
| 17025 | scoreboard | ch0 pkt matched: addr=0 len=1 (101 matched so far) |
| 17105 | **DUT** | IN  pkt #102 header: addr=0 len=1 -> channel 0 |
| 17110 | ch0 driver | ch0: packet consumed (response delay 10) |
| 17125 | **DUT** | IN  pkt #102 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17125 | yapp monitor | RX pkt #102 on the input: addr=0 len=1 parity=good gap=8 |
| 17125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17130 | yapp driver | TX pkt #102 accepted by the DUT |
| 17130 | yapp driver | TX pkt #103: addr=0 len=1 parity=good delay=5 |
| 17135 | **DUT** | OUT ch0 pkt #102 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 17150 | ch0 driver | ch0: packet consumed (response delay 1) |
| 17185 | **DUT** | IN  pkt #103 header: addr=0 len=1 -> channel 0 |
| 17205 | **DUT** | IN  pkt #103 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17205 | yapp monitor | RX pkt #103 on the input: addr=0 len=1 parity=good gap=5 |
| 17205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17210 | yapp driver | TX pkt #103 accepted by the DUT |
| 17210 | yapp driver | TX pkt #104: addr=0 len=1 parity=good delay=20 |
| 17265 | **DUT** | OUT ch0 pkt #102 done: 3 bytes in 14 cycles |
| 17265 | ch0 monitor | ch0 RX pkt #102: addr=0 len=1 parity=good |
| 17265 | scoreboard | ch0 pkt matched: addr=0 len=1 (102 matched so far) |
| 17275 | **DUT** | OUT ch0 pkt #103 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17295 | **DUT** | OUT ch0 pkt #103 done: 3 bytes in 3 cycles |
| 17295 | ch0 monitor | ch0 RX pkt #103: addr=0 len=1 parity=good |
| 17295 | scoreboard | ch0 pkt matched: addr=0 len=1 (103 matched so far) |
| 17320 | ch0 driver | ch0: packet consumed (response delay 10) |
| 17415 | **DUT** | IN  pkt #104 header: addr=0 len=1 -> channel 0 |
| 17435 | **DUT** | IN  pkt #104 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17435 | yapp monitor | RX pkt #104 on the input: addr=0 len=1 parity=good gap=20 |
| 17435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17440 | yapp driver | TX pkt #104 accepted by the DUT |
| 17440 | yapp driver | TX pkt #105: addr=0 len=1 parity=good delay=10 |
| 17515 | **DUT** | OUT ch0 pkt #104 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 17530 | ch0 driver | ch0: packet consumed (response delay 9) |
| 17545 | **DUT** | IN  pkt #105 header: addr=0 len=1 -> channel 0 |
| 17565 | **DUT** | IN  pkt #105 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17565 | yapp monitor | RX pkt #105 on the input: addr=0 len=1 parity=good gap=10 |
| 17565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17570 | yapp driver | TX pkt #105 accepted by the DUT |
| 17570 | yapp driver | TX pkt #106: addr=0 len=1 parity=good delay=11 |
| 17645 | **DUT** | OUT ch0 pkt #104 done: 3 bytes in 14 cycles |
| 17645 | ch0 monitor | ch0 RX pkt #104: addr=0 len=1 parity=good |
| 17645 | scoreboard | ch0 pkt matched: addr=0 len=1 (104 matched so far) |
| 17655 | **DUT** | OUT ch0 pkt #105 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17675 | **DUT** | OUT ch0 pkt #105 done: 3 bytes in 3 cycles |
| 17675 | ch0 monitor | ch0 RX pkt #105: addr=0 len=1 parity=good |
| 17675 | scoreboard | ch0 pkt matched: addr=0 len=1 (105 matched so far) |
| 17685 | **DUT** | IN  pkt #106 header: addr=0 len=1 -> channel 0 |
| 17695 | **DUT** | OUT ch0 pkt #106 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17705 | **DUT** | IN  pkt #106 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17705 | yapp monitor | RX pkt #106 on the input: addr=0 len=1 parity=good gap=11 |
| 17705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17710 | yapp driver | TX pkt #106 accepted by the DUT |
| 17710 | yapp driver | TX pkt #107: addr=0 len=1 parity=good delay=4 |
| 17715 | **DUT** | OUT ch0 pkt #106 done: 3 bytes in 3 cycles |
| 17715 | ch0 monitor | ch0 RX pkt #106: addr=0 len=1 parity=good |
| 17715 | scoreboard | ch0 pkt matched: addr=0 len=1 (106 matched so far) |
| 17755 | **DUT** | IN  pkt #107 header: addr=0 len=1 -> channel 0 |
| 17765 | **DUT** | OUT ch0 pkt #107 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17775 | **DUT** | IN  pkt #107 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17775 | yapp monitor | RX pkt #107 on the input: addr=0 len=1 parity=good gap=4 |
| 17775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17780 | yapp driver | TX pkt #107 accepted by the DUT |
| 17780 | yapp driver | TX pkt #108: addr=0 len=1 parity=good delay=16 |
| 17785 | **DUT** | OUT ch0 pkt #107 done: 3 bytes in 3 cycles |
| 17785 | ch0 monitor | ch0 RX pkt #107: addr=0 len=1 parity=good |
| 17785 | scoreboard | ch0 pkt matched: addr=0 len=1 (107 matched so far) |
| 17945 | **DUT** | IN  pkt #108 header: addr=0 len=1 -> channel 0 |
| 17955 | **DUT** | OUT ch0 pkt #108 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17965 | **DUT** | IN  pkt #108 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17965 | yapp monitor | RX pkt #108 on the input: addr=0 len=1 parity=good gap=16 |
| 17965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17970 | yapp driver | TX pkt #108 accepted by the DUT |
| 17970 | yapp driver | TX pkt #109: addr=0 len=1 parity=good delay=20 |
| 17975 | **DUT** | OUT ch0 pkt #108 done: 3 bytes in 3 cycles |
| 17975 | ch0 monitor | ch0 RX pkt #108: addr=0 len=1 parity=good |
| 17975 | scoreboard | ch0 pkt matched: addr=0 len=1 (108 matched so far) |
| 18130 | ch0 driver | ch0: packet consumed (response delay 10) |
| 18175 | **DUT** | IN  pkt #109 header: addr=0 len=1 -> channel 0 |
| 18195 | **DUT** | IN  pkt #109 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18195 | yapp monitor | RX pkt #109 on the input: addr=0 len=1 parity=good gap=20 |
| 18195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18200 | yapp driver | TX pkt #109 accepted by the DUT |
| 18200 | yapp driver | TX pkt #110: addr=0 len=1 parity=good delay=20 |
| 18245 | **DUT** | OUT ch0 pkt #109 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 18260 | ch0 driver | ch0: packet consumed (response delay 6) |
| 18375 | **DUT** | OUT ch0 pkt #109 done: 3 bytes in 14 cycles |
| 18375 | ch0 monitor | ch0 RX pkt #109: addr=0 len=1 parity=good |
| 18375 | scoreboard | ch0 pkt matched: addr=0 len=1 (109 matched so far) |
| 18405 | **DUT** | IN  pkt #110 header: addr=0 len=1 -> channel 0 |
| 18415 | **DUT** | OUT ch0 pkt #110 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18425 | **DUT** | IN  pkt #110 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18425 | yapp monitor | RX pkt #110 on the input: addr=0 len=1 parity=good gap=20 |
| 18425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18430 | yapp driver | TX pkt #110 accepted by the DUT |
| 18430 | yapp driver | TX pkt #111: addr=0 len=1 parity=good delay=3 |
| 18435 | **DUT** | OUT ch0 pkt #110 done: 3 bytes in 3 cycles |
| 18435 | ch0 monitor | ch0 RX pkt #110: addr=0 len=1 parity=good |
| 18435 | scoreboard | ch0 pkt matched: addr=0 len=1 (110 matched so far) |
| 18465 | **DUT** | IN  pkt #111 header: addr=0 len=1 -> channel 0 |
| 18475 | **DUT** | OUT ch0 pkt #111 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18485 | **DUT** | IN  pkt #111 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18485 | yapp monitor | RX pkt #111 on the input: addr=0 len=1 parity=good gap=3 |
| 18485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18490 | yapp driver | TX pkt #111 accepted by the DUT |
| 18490 | yapp driver | TX pkt #112: addr=0 len=1 parity=good delay=9 |
| 18495 | **DUT** | OUT ch0 pkt #111 done: 3 bytes in 3 cycles |
| 18495 | ch0 monitor | ch0 RX pkt #111: addr=0 len=1 parity=good |
| 18495 | scoreboard | ch0 pkt matched: addr=0 len=1 (111 matched so far) |
| 18585 | **DUT** | IN  pkt #112 header: addr=0 len=1 -> channel 0 |
| 18595 | **DUT** | OUT ch0 pkt #112 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18605 | **DUT** | IN  pkt #112 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18605 | yapp monitor | RX pkt #112 on the input: addr=0 len=1 parity=good gap=9 |
| 18605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18610 | yapp driver | TX pkt #112 accepted by the DUT |
| 18610 | yapp driver | TX pkt #113: addr=0 len=1 parity=good delay=1 |
| 18615 | **DUT** | OUT ch0 pkt #112 done: 3 bytes in 3 cycles |
| 18615 | ch0 monitor | ch0 RX pkt #112: addr=0 len=1 parity=good |
| 18615 | scoreboard | ch0 pkt matched: addr=0 len=1 (112 matched so far) |
| 18625 | **DUT** | IN  pkt #113 header: addr=0 len=1 -> channel 0 |
| 18635 | **DUT** | OUT ch0 pkt #113 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18645 | **DUT** | IN  pkt #113 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18645 | yapp monitor | RX pkt #113 on the input: addr=0 len=1 parity=good gap=1 |
| 18645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18650 | yapp driver | TX pkt #113 accepted by the DUT |
| 18650 | yapp driver | TX pkt #114: addr=0 len=1 parity=good delay=1 |
| 18655 | **DUT** | OUT ch0 pkt #113 done: 3 bytes in 3 cycles |
| 18655 | ch0 monitor | ch0 RX pkt #113: addr=0 len=1 parity=good |
| 18655 | scoreboard | ch0 pkt matched: addr=0 len=1 (113 matched so far) |
| 18665 | **DUT** | IN  pkt #114 header: addr=0 len=1 -> channel 0 |
| 18675 | **DUT** | OUT ch0 pkt #114 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18685 | **DUT** | IN  pkt #114 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18685 | yapp monitor | RX pkt #114 on the input: addr=0 len=1 parity=good gap=1 |
| 18685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18690 | yapp driver | TX pkt #114 accepted by the DUT |
| 18690 | yapp driver | TX pkt #115: addr=0 len=1 parity=good delay=11 |
| 18695 | **DUT** | OUT ch0 pkt #114 done: 3 bytes in 3 cycles |
| 18695 | ch0 monitor | ch0 RX pkt #114: addr=0 len=1 parity=good |
| 18695 | scoreboard | ch0 pkt matched: addr=0 len=1 (114 matched so far) |
| 18805 | **DUT** | IN  pkt #115 header: addr=0 len=1 -> channel 0 |
| 18815 | **DUT** | OUT ch0 pkt #115 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18825 | **DUT** | IN  pkt #115 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18825 | yapp monitor | RX pkt #115 on the input: addr=0 len=1 parity=good gap=11 |
| 18825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18830 | yapp driver | TX pkt #115 accepted by the DUT |
| 18830 | yapp driver | TX pkt #116: addr=0 len=1 parity=good delay=4 |
| 18835 | **DUT** | OUT ch0 pkt #115 done: 3 bytes in 3 cycles |
| 18835 | ch0 monitor | ch0 RX pkt #115: addr=0 len=1 parity=good |
| 18835 | scoreboard | ch0 pkt matched: addr=0 len=1 (115 matched so far) |
| 18875 | **DUT** | IN  pkt #116 header: addr=0 len=1 -> channel 0 |
| 18885 | **DUT** | OUT ch0 pkt #116 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18890 | ch0 driver | ch0: packet consumed (response delay 10) |
| 18895 | **DUT** | IN  pkt #116 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18895 | yapp monitor | RX pkt #116 on the input: addr=0 len=1 parity=good gap=4 |
| 18895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18900 | yapp driver | TX pkt #116 accepted by the DUT |
| 18900 | yapp driver | TX pkt #117: addr=0 len=1 parity=good delay=19 |
| 19015 | **DUT** | OUT ch0 pkt #116 done: 3 bytes in 14 cycles |
| 19015 | ch0 monitor | ch0 RX pkt #116: addr=0 len=1 parity=good |
| 19015 | scoreboard | ch0 pkt matched: addr=0 len=1 (116 matched so far) |
| 19095 | **DUT** | IN  pkt #117 header: addr=0 len=1 -> channel 0 |
| 19105 | **DUT** | OUT ch0 pkt #117 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19115 | **DUT** | IN  pkt #117 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19115 | yapp monitor | RX pkt #117 on the input: addr=0 len=1 parity=good gap=19 |
| 19115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19120 | yapp driver | TX pkt #117 accepted by the DUT |
| 19120 | yapp driver | TX pkt #118: addr=0 len=1 parity=good delay=20 |
| 19125 | **DUT** | OUT ch0 pkt #117 done: 3 bytes in 3 cycles |
| 19125 | ch0 monitor | ch0 RX pkt #117: addr=0 len=1 parity=good |
| 19125 | scoreboard | ch0 pkt matched: addr=0 len=1 (117 matched so far) |
| 19325 | **DUT** | IN  pkt #118 header: addr=0 len=1 -> channel 0 |
| 19335 | **DUT** | OUT ch0 pkt #118 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19345 | **DUT** | IN  pkt #118 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19345 | yapp monitor | RX pkt #118 on the input: addr=0 len=1 parity=good gap=20 |
| 19345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19350 | yapp driver | TX pkt #118 accepted by the DUT |
| 19350 | yapp driver | TX pkt #119: addr=0 len=1 parity=good delay=18 |
| 19355 | **DUT** | OUT ch0 pkt #118 done: 3 bytes in 3 cycles |
| 19355 | ch0 monitor | ch0 RX pkt #118: addr=0 len=1 parity=good |
| 19355 | scoreboard | ch0 pkt matched: addr=0 len=1 (118 matched so far) |
| 19510 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19535 | **DUT** | IN  pkt #119 header: addr=0 len=1 -> channel 0 |
| 19555 | **DUT** | IN  pkt #119 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19555 | yapp monitor | RX pkt #119 on the input: addr=0 len=1 parity=good gap=18 |
| 19555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19560 | yapp driver | TX pkt #119 accepted by the DUT |
| 19560 | yapp driver | TX pkt #120: addr=0 len=1 parity=good delay=2 |
| 19585 | **DUT** | IN  pkt #120 header: addr=0 len=1 -> channel 0 |
| 19595 | **DUT** | OUT ch0 pkt #119 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 19605 | **DUT** | IN  pkt #120 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19605 | yapp monitor | RX pkt #120 on the input: addr=0 len=1 parity=good gap=2 |
| 19605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19610 | ch0 driver | ch0: packet consumed (response delay 5) |
| 19610 | yapp driver | TX pkt #120 accepted by the DUT |
| 19610 | yapp driver | TX pkt #121: addr=0 len=1 parity=good delay=1 |
| 19625 | **DUT** | IN  pkt #121 header: addr=0 len=1 -> channel 0 |
| 19645 | **DUT** | IN  pkt #121 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19645 | yapp monitor | RX pkt #121 on the input: addr=0 len=1 parity=good gap=1 |
| 19645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19650 | yapp driver | TX pkt #121 accepted by the DUT |
| 19650 | yapp driver | TX pkt #122: addr=0 len=1 parity=good delay=20 |
| 19655 | **DUT** | OUT ch0 pkt #119 done: 3 bytes in 7 cycles |
| 19655 | ch0 monitor | ch0 RX pkt #119: addr=0 len=1 parity=good |
| 19655 | scoreboard | ch0 pkt matched: addr=0 len=1 (119 matched so far) |
| 19665 | **DUT** | OUT ch0 pkt #120 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19685 | **DUT** | OUT ch0 pkt #120 done: 3 bytes in 3 cycles |
| 19685 | ch0 monitor | ch0 RX pkt #120: addr=0 len=1 parity=good |
| 19685 | scoreboard | ch0 pkt matched: addr=0 len=1 (120 matched so far) |
| 19695 | **DUT** | OUT ch0 pkt #121 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19715 | **DUT** | OUT ch0 pkt #121 done: 3 bytes in 3 cycles |
| 19715 | ch0 monitor | ch0 RX pkt #121: addr=0 len=1 parity=good |
| 19715 | scoreboard | ch0 pkt matched: addr=0 len=1 (121 matched so far) |
| 19855 | **DUT** | IN  pkt #122 header: addr=0 len=1 -> channel 0 |
| 19865 | **DUT** | OUT ch0 pkt #122 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19875 | **DUT** | IN  pkt #122 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19875 | yapp monitor | RX pkt #122 on the input: addr=0 len=1 parity=good gap=20 |
| 19875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19880 | yapp driver | TX pkt #122 accepted by the DUT |
| 19880 | yapp driver | TX pkt #123: addr=0 len=1 parity=good delay=20 |
| 19885 | **DUT** | OUT ch0 pkt #122 done: 3 bytes in 3 cycles |
| 19885 | ch0 monitor | ch0 RX pkt #122: addr=0 len=1 parity=good |
| 19885 | scoreboard | ch0 pkt matched: addr=0 len=1 (122 matched so far) |
| 20085 | **DUT** | IN  pkt #123 header: addr=0 len=1 -> channel 0 |
| 20095 | **DUT** | OUT ch0 pkt #123 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20105 | **DUT** | IN  pkt #123 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20105 | yapp monitor | RX pkt #123 on the input: addr=0 len=1 parity=good gap=20 |
| 20105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20110 | ch0 driver | ch0: packet consumed (response delay 3) |
| 20110 | yapp driver | TX pkt #123 accepted by the DUT |
| 20110 | yapp driver | TX pkt #124: addr=0 len=1 parity=good delay=7 |
| 20185 | **DUT** | IN  pkt #124 header: addr=0 len=1 -> channel 0 |
| 20185 | **DUT** | OUT ch0 pkt #123 done: 3 bytes in 10 cycles |
| 20185 | ch0 monitor | ch0 RX pkt #123: addr=0 len=1 parity=good |
| 20185 | scoreboard | ch0 pkt matched: addr=0 len=1 (123 matched so far) |
| 20195 | **DUT** | OUT ch0 pkt #124 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20205 | **DUT** | IN  pkt #124 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20205 | yapp monitor | RX pkt #124 on the input: addr=0 len=1 parity=good gap=7 |
| 20205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20210 | yapp driver | TX pkt #124 accepted by the DUT |
| 20210 | yapp driver | TX pkt #125: addr=0 len=1 parity=good delay=20 |
| 20215 | **DUT** | OUT ch0 pkt #124 done: 3 bytes in 3 cycles |
| 20215 | ch0 monitor | ch0 RX pkt #124: addr=0 len=1 parity=good |
| 20215 | scoreboard | ch0 pkt matched: addr=0 len=1 (124 matched so far) |
| 20415 | **DUT** | IN  pkt #125 header: addr=0 len=1 -> channel 0 |
| 20425 | **DUT** | OUT ch0 pkt #125 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20435 | **DUT** | IN  pkt #125 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20435 | yapp monitor | RX pkt #125 on the input: addr=0 len=1 parity=good gap=20 |
| 20435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20440 | yapp driver | TX pkt #125 accepted by the DUT |
| 20440 | yapp driver | TX pkt #126: addr=0 len=1 parity=good delay=18 |
| 20445 | **DUT** | OUT ch0 pkt #125 done: 3 bytes in 3 cycles |
| 20445 | ch0 monitor | ch0 RX pkt #125: addr=0 len=1 parity=good |
| 20445 | scoreboard | ch0 pkt matched: addr=0 len=1 (125 matched so far) |
| 20625 | **DUT** | IN  pkt #126 header: addr=0 len=1 -> channel 0 |
| 20635 | **DUT** | OUT ch0 pkt #126 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20640 | ch0 driver | ch0: packet consumed (response delay 6) |
| 20645 | **DUT** | IN  pkt #126 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20645 | yapp monitor | RX pkt #126 on the input: addr=0 len=1 parity=good gap=18 |
| 20645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20650 | yapp driver | TX pkt #126 accepted by the DUT |
| 20650 | yapp driver | TX pkt #127: addr=0 len=1 parity=good delay=14 |
| 20685 | **DUT** | OUT ch0 pkt #126 done: 3 bytes in 6 cycles |
| 20685 | ch0 monitor | ch0 RX pkt #126: addr=0 len=1 parity=good |
| 20685 | scoreboard | ch0 pkt matched: addr=0 len=1 (126 matched so far) |
| 20795 | **DUT** | IN  pkt #127 header: addr=0 len=1 -> channel 0 |
| 20805 | **DUT** | OUT ch0 pkt #127 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20815 | **DUT** | IN  pkt #127 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20815 | yapp monitor | RX pkt #127 on the input: addr=0 len=1 parity=good gap=14 |
| 20815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20820 | yapp driver | TX pkt #127 accepted by the DUT |
| 20820 | yapp driver | TX pkt #128: addr=0 len=1 parity=good delay=20 |
| 20825 | **DUT** | OUT ch0 pkt #127 done: 3 bytes in 3 cycles |
| 20825 | ch0 monitor | ch0 RX pkt #127: addr=0 len=1 parity=good |
| 20825 | scoreboard | ch0 pkt matched: addr=0 len=1 (127 matched so far) |
| 20860 | ch0 driver | ch0: packet consumed (response delay 2) |
| 21025 | **DUT** | IN  pkt #128 header: addr=0 len=1 -> channel 0 |
| 21045 | **DUT** | IN  pkt #128 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21045 | yapp monitor | RX pkt #128 on the input: addr=0 len=1 parity=good gap=20 |
| 21045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21050 | yapp driver | TX pkt #128 accepted by the DUT |
| 21050 | yapp driver | TX pkt #129: addr=0 len=1 parity=good delay=2 |
| 21075 | **DUT** | IN  pkt #129 header: addr=0 len=1 -> channel 0 |
| 21095 | **DUT** | IN  pkt #129 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21095 | yapp monitor | RX pkt #129 on the input: addr=0 len=1 parity=good gap=2 |
| 21095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21100 | yapp driver | TX pkt #129 accepted by the DUT |
| 21100 | yapp driver | TX pkt #130: addr=0 len=1 parity=good delay=14 |
| 21115 | **DUT** | OUT ch0 pkt #128 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 21130 | ch0 driver | ch0: packet consumed (response delay 8) |
| 21225 | **DUT** | OUT ch0 pkt #128 done: 3 bytes in 12 cycles |
| 21225 | ch0 monitor | ch0 RX pkt #128: addr=0 len=1 parity=good |
| 21225 | scoreboard | ch0 pkt matched: addr=0 len=1 (128 matched so far) |
| 21235 | **DUT** | OUT ch0 pkt #129 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21245 | **DUT** | IN  pkt #130 header: addr=0 len=1 -> channel 0 |
| 21255 | **DUT** | OUT ch0 pkt #129 done: 3 bytes in 3 cycles |
| 21255 | ch0 monitor | ch0 RX pkt #129: addr=0 len=1 parity=good |
| 21255 | scoreboard | ch0 pkt matched: addr=0 len=1 (129 matched so far) |
| 21265 | **DUT** | IN  pkt #130 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21265 | **DUT** | OUT ch0 pkt #130 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21265 | yapp monitor | RX pkt #130 on the input: addr=0 len=1 parity=good gap=14 |
| 21265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21270 | yapp driver | TX pkt #130 accepted by the DUT |
| 21270 | yapp driver | TX pkt #131: addr=0 len=1 parity=good delay=6 |
| 21285 | **DUT** | OUT ch0 pkt #130 done: 3 bytes in 3 cycles |
| 21285 | ch0 monitor | ch0 RX pkt #130: addr=0 len=1 parity=good |
| 21285 | scoreboard | ch0 pkt matched: addr=0 len=1 (130 matched so far) |
| 21320 | ch0 driver | ch0: packet consumed (response delay 8) |
| 21335 | **DUT** | IN  pkt #131 header: addr=0 len=1 -> channel 0 |
| 21355 | **DUT** | IN  pkt #131 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21355 | yapp monitor | RX pkt #131 on the input: addr=0 len=1 parity=good gap=6 |
| 21355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21360 | yapp driver | TX pkt #131 accepted by the DUT |
| 21360 | yapp driver | TX pkt #132: addr=0 len=1 parity=good delay=6 |
| 21425 | **DUT** | IN  pkt #132 header: addr=0 len=1 -> channel 0 |
| 21445 | **DUT** | IN  pkt #132 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21445 | **DUT** | OUT ch0 pkt #131 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 21445 | yapp monitor | RX pkt #132 on the input: addr=0 len=1 parity=good gap=6 |
| 21445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21450 | yapp driver | TX pkt #132 accepted by the DUT |
| 21450 | yapp driver | TX pkt #133: addr=0 len=1 parity=good delay=11 |
| 21460 | ch0 driver | ch0: packet consumed (response delay 10) |
| 21565 | **DUT** | IN  pkt #133 header: addr=0 len=1 -> channel 0 |
| 21575 | **DUT** | OUT ch0 pkt #131 done: 3 bytes in 14 cycles |
| 21575 | ch0 monitor | ch0 RX pkt #131: addr=0 len=1 parity=good |
| 21575 | scoreboard | ch0 pkt matched: addr=0 len=1 (131 matched so far) |
| 21585 | **DUT** | IN  pkt #133 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21585 | **DUT** | OUT ch0 pkt #132 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21585 | yapp monitor | RX pkt #133 on the input: addr=0 len=1 parity=good gap=11 |
| 21585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21590 | yapp driver | TX pkt #133 accepted by the DUT |
| 21590 | yapp driver | TX pkt #134: addr=0 len=1 parity=good delay=20 |
| 21605 | **DUT** | OUT ch0 pkt #132 done: 3 bytes in 3 cycles |
| 21605 | ch0 monitor | ch0 RX pkt #132: addr=0 len=1 parity=good |
| 21605 | scoreboard | ch0 pkt matched: addr=0 len=1 (132 matched so far) |
| 21615 | **DUT** | OUT ch0 pkt #133 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21635 | **DUT** | OUT ch0 pkt #133 done: 3 bytes in 3 cycles |
| 21635 | ch0 monitor | ch0 RX pkt #133: addr=0 len=1 parity=good |
| 21635 | scoreboard | ch0 pkt matched: addr=0 len=1 (133 matched so far) |
| 21795 | **DUT** | IN  pkt #134 header: addr=0 len=1 -> channel 0 |
| 21805 | **DUT** | OUT ch0 pkt #134 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21815 | **DUT** | IN  pkt #134 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21815 | yapp monitor | RX pkt #134 on the input: addr=0 len=1 parity=good gap=20 |
| 21815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21820 | yapp driver | TX pkt #134 accepted by the DUT |
| 21820 | yapp driver | TX pkt #135: addr=0 len=1 parity=good delay=20 |
| 21825 | **DUT** | OUT ch0 pkt #134 done: 3 bytes in 3 cycles |
| 21825 | ch0 monitor | ch0 RX pkt #134: addr=0 len=1 parity=good |
| 21825 | scoreboard | ch0 pkt matched: addr=0 len=1 (134 matched so far) |
| 21970 | ch0 driver | ch0: packet consumed (response delay 10) |
| 22025 | **DUT** | IN  pkt #135 header: addr=0 len=1 -> channel 0 |
| 22045 | **DUT** | IN  pkt #135 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22045 | yapp monitor | RX pkt #135 on the input: addr=0 len=1 parity=good gap=20 |
| 22045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22050 | yapp driver | TX pkt #135 accepted by the DUT |
| 22050 | yapp driver | TX pkt #136: addr=0 len=1 parity=good delay=20 |
| 22125 | **DUT** | OUT ch0 pkt #135 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 22140 | ch0 driver | ch0: packet consumed (response delay 9) |
| 22155 | **DUT** | OUT ch0 pkt #135 done: 3 bytes in 4 cycles |
| 22155 | ch0 monitor | ch0 RX pkt #135: addr=0 len=1 parity=good |
| 22155 | scoreboard | ch0 pkt matched: addr=0 len=1 (135 matched so far) |
| 22255 | **DUT** | IN  pkt #136 header: addr=0 len=1 -> channel 0 |
| 22265 | **DUT** | OUT ch0 pkt #136 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22275 | **DUT** | IN  pkt #136 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22275 | yapp monitor | RX pkt #136 on the input: addr=0 len=1 parity=good gap=20 |
| 22275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22280 | yapp driver | TX pkt #136 accepted by the DUT |
| 22280 | yapp driver | TX pkt #137: addr=0 len=1 parity=good delay=20 |
| 22285 | **DUT** | OUT ch0 pkt #136 done: 3 bytes in 3 cycles |
| 22285 | ch0 monitor | ch0 RX pkt #136: addr=0 len=1 parity=good |
| 22285 | scoreboard | ch0 pkt matched: addr=0 len=1 (136 matched so far) |
| 22485 | **DUT** | IN  pkt #137 header: addr=0 len=1 -> channel 0 |
| 22495 | **DUT** | OUT ch0 pkt #137 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22505 | **DUT** | IN  pkt #137 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22505 | yapp monitor | RX pkt #137 on the input: addr=0 len=1 parity=good gap=20 |
| 22505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22510 | yapp driver | TX pkt #137 accepted by the DUT |
| 22510 | yapp driver | TX pkt #138: addr=0 len=1 parity=good delay=15 |
| 22515 | **DUT** | OUT ch0 pkt #137 done: 3 bytes in 3 cycles |
| 22515 | ch0 monitor | ch0 RX pkt #137: addr=0 len=1 parity=good |
| 22515 | scoreboard | ch0 pkt matched: addr=0 len=1 (137 matched so far) |
| 22610 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22665 | **DUT** | IN  pkt #138 header: addr=0 len=1 -> channel 0 |
| 22685 | **DUT** | IN  pkt #138 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22685 | yapp monitor | RX pkt #138 on the input: addr=0 len=1 parity=good gap=15 |
| 22685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22690 | yapp driver | TX pkt #138 accepted by the DUT |
| 22690 | yapp driver | TX pkt #139: addr=0 len=1 parity=good delay=16 |
| 22765 | **DUT** | OUT ch0 pkt #138 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 22780 | ch0 driver | ch0: packet consumed (response delay 9) |
| 22855 | **DUT** | IN  pkt #139 header: addr=0 len=1 -> channel 0 |
| 22865 | **DUT** | OUT ch0 pkt #138 done: 3 bytes in 11 cycles |
| 22865 | ch0 monitor | ch0 RX pkt #138: addr=0 len=1 parity=good |
| 22865 | scoreboard | ch0 pkt matched: addr=0 len=1 (138 matched so far) |
| 22875 | **DUT** | IN  pkt #139 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22875 | **DUT** | OUT ch0 pkt #139 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22875 | yapp monitor | RX pkt #139 on the input: addr=0 len=1 parity=good gap=16 |
| 22875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22880 | yapp driver | TX pkt #139 accepted by the DUT |
| 22880 | yapp driver | TX pkt #140: addr=0 len=1 parity=good delay=11 |
| 22895 | **DUT** | OUT ch0 pkt #139 done: 3 bytes in 3 cycles |
| 22895 | ch0 monitor | ch0 RX pkt #139: addr=0 len=1 parity=good |
| 22895 | scoreboard | ch0 pkt matched: addr=0 len=1 (139 matched so far) |
| 22995 | **DUT** | IN  pkt #140 header: addr=0 len=1 -> channel 0 |
| 23005 | **DUT** | OUT ch0 pkt #140 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23015 | **DUT** | IN  pkt #140 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23015 | yapp monitor | RX pkt #140 on the input: addr=0 len=1 parity=good gap=11 |
| 23015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23020 | yapp driver | TX pkt #140 accepted by the DUT |
| 23020 | yapp driver | TX pkt #141: addr=0 len=1 parity=good delay=15 |
| 23025 | **DUT** | OUT ch0 pkt #140 done: 3 bytes in 3 cycles |
| 23025 | ch0 monitor | ch0 RX pkt #140: addr=0 len=1 parity=good |
| 23025 | scoreboard | ch0 pkt matched: addr=0 len=1 (140 matched so far) |
| 23175 | **DUT** | IN  pkt #141 header: addr=0 len=1 -> channel 0 |
| 23185 | **DUT** | OUT ch0 pkt #141 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23195 | **DUT** | IN  pkt #141 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23195 | yapp monitor | RX pkt #141 on the input: addr=0 len=1 parity=good gap=15 |
| 23195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23200 | yapp driver | TX pkt #141 accepted by the DUT |
| 23200 | yapp driver | TX pkt #142: addr=0 len=1 parity=good delay=20 |
| 23205 | **DUT** | OUT ch0 pkt #141 done: 3 bytes in 3 cycles |
| 23205 | ch0 monitor | ch0 RX pkt #141: addr=0 len=1 parity=good |
| 23205 | scoreboard | ch0 pkt matched: addr=0 len=1 (141 matched so far) |
| 23405 | **DUT** | IN  pkt #142 header: addr=0 len=1 -> channel 0 |
| 23415 | **DUT** | OUT ch0 pkt #142 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23425 | **DUT** | IN  pkt #142 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23425 | yapp monitor | RX pkt #142 on the input: addr=0 len=1 parity=good gap=20 |
| 23425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23430 | ch0 driver | ch0: packet consumed (response delay 7) |
| 23430 | yapp driver | TX pkt #142 accepted by the DUT |
| 23430 | yapp driver | TX pkt #143: addr=0 len=1 parity=good delay=15 |
| 23545 | **DUT** | OUT ch0 pkt #142 done: 3 bytes in 14 cycles |
| 23545 | ch0 monitor | ch0 RX pkt #142: addr=0 len=1 parity=good |
| 23545 | scoreboard | ch0 pkt matched: addr=0 len=1 (142 matched so far) |
| 23585 | **DUT** | IN  pkt #143 header: addr=0 len=1 -> channel 0 |
| 23595 | **DUT** | OUT ch0 pkt #143 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23605 | **DUT** | IN  pkt #143 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23605 | yapp monitor | RX pkt #143 on the input: addr=0 len=1 parity=good gap=15 |
| 23605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23610 | yapp driver | TX pkt #143 accepted by the DUT |
| 23610 | yapp driver | TX pkt #144: addr=0 len=1 parity=good delay=19 |
| 23615 | **DUT** | OUT ch0 pkt #143 done: 3 bytes in 3 cycles |
| 23615 | ch0 monitor | ch0 RX pkt #143: addr=0 len=1 parity=good |
| 23615 | scoreboard | ch0 pkt matched: addr=0 len=1 (143 matched so far) |
| 23805 | **DUT** | IN  pkt #144 header: addr=0 len=1 -> channel 0 |
| 23815 | **DUT** | OUT ch0 pkt #144 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23825 | **DUT** | IN  pkt #144 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23825 | yapp monitor | RX pkt #144 on the input: addr=0 len=1 parity=good gap=19 |
| 23825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23830 | yapp driver | TX pkt #144 accepted by the DUT |
| 23830 | yapp driver | TX pkt #145: addr=0 len=1 parity=good delay=13 |
| 23835 | **DUT** | OUT ch0 pkt #144 done: 3 bytes in 3 cycles |
| 23835 | ch0 monitor | ch0 RX pkt #144: addr=0 len=1 parity=good |
| 23835 | scoreboard | ch0 pkt matched: addr=0 len=1 (144 matched so far) |
| 23965 | **DUT** | IN  pkt #145 header: addr=0 len=1 -> channel 0 |
| 23975 | **DUT** | OUT ch0 pkt #145 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23985 | **DUT** | IN  pkt #145 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23985 | yapp monitor | RX pkt #145 on the input: addr=0 len=1 parity=good gap=13 |
| 23985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23990 | yapp driver | TX pkt #145 accepted by the DUT |
| 23990 | yapp driver | TX pkt #146: addr=0 len=1 parity=good delay=8 |
| 23995 | **DUT** | OUT ch0 pkt #145 done: 3 bytes in 3 cycles |
| 23995 | ch0 monitor | ch0 RX pkt #145: addr=0 len=1 parity=good |
| 23995 | scoreboard | ch0 pkt matched: addr=0 len=1 (145 matched so far) |
| 24030 | ch0 driver | ch0: packet consumed (response delay 10) |
| 24075 | **DUT** | IN  pkt #146 header: addr=0 len=1 -> channel 0 |
| 24095 | **DUT** | IN  pkt #146 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24095 | yapp monitor | RX pkt #146 on the input: addr=0 len=1 parity=good gap=8 |
| 24095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24100 | yapp driver | TX pkt #146 accepted by the DUT |
| 24100 | yapp driver | TX pkt #147: addr=0 len=1 parity=good delay=20 |
| 24115 | **DUT** | OUT ch0 pkt #146 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 24130 | ch0 driver | ch0: packet consumed (response delay 3) |
| 24225 | **DUT** | OUT ch0 pkt #146 done: 3 bytes in 12 cycles |
| 24225 | ch0 monitor | ch0 RX pkt #146: addr=0 len=1 parity=good |
| 24225 | scoreboard | ch0 pkt matched: addr=0 len=1 (146 matched so far) |
| 24305 | **DUT** | IN  pkt #147 header: addr=0 len=1 -> channel 0 |
| 24315 | **DUT** | OUT ch0 pkt #147 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24325 | **DUT** | IN  pkt #147 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24325 | yapp monitor | RX pkt #147 on the input: addr=0 len=1 parity=good gap=20 |
| 24325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24330 | yapp driver | TX pkt #147 accepted by the DUT |
| 24330 | yapp driver | TX pkt #148: addr=0 len=1 parity=good delay=18 |
| 24335 | **DUT** | OUT ch0 pkt #147 done: 3 bytes in 3 cycles |
| 24335 | ch0 monitor | ch0 RX pkt #147: addr=0 len=1 parity=good |
| 24335 | scoreboard | ch0 pkt matched: addr=0 len=1 (147 matched so far) |
| 24515 | **DUT** | IN  pkt #148 header: addr=0 len=1 -> channel 0 |
| 24525 | **DUT** | OUT ch0 pkt #148 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24535 | **DUT** | IN  pkt #148 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24535 | yapp monitor | RX pkt #148 on the input: addr=0 len=1 parity=good gap=18 |
| 24535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24540 | yapp driver | TX pkt #148 accepted by the DUT |
| 24540 | yapp driver | TX pkt #149: addr=0 len=1 parity=good delay=6 |
| 24545 | **DUT** | OUT ch0 pkt #148 done: 3 bytes in 3 cycles |
| 24545 | ch0 monitor | ch0 RX pkt #148: addr=0 len=1 parity=good |
| 24545 | scoreboard | ch0 pkt matched: addr=0 len=1 (148 matched so far) |
| 24605 | **DUT** | IN  pkt #149 header: addr=0 len=1 -> channel 0 |
| 24615 | **DUT** | OUT ch0 pkt #149 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24625 | **DUT** | IN  pkt #149 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24625 | yapp monitor | RX pkt #149 on the input: addr=0 len=1 parity=good gap=6 |
| 24625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24630 | yapp driver | TX pkt #149 accepted by the DUT |
| 24630 | yapp driver | TX pkt #150: addr=0 len=1 parity=good delay=5 |
| 24635 | **DUT** | OUT ch0 pkt #149 done: 3 bytes in 3 cycles |
| 24635 | ch0 monitor | ch0 RX pkt #149: addr=0 len=1 parity=good |
| 24635 | scoreboard | ch0 pkt matched: addr=0 len=1 (149 matched so far) |
| 24640 | ch0 driver | ch0: packet consumed (response delay 8) |
| 24685 | **DUT** | IN  pkt #150 header: addr=0 len=1 -> channel 0 |
| 24705 | **DUT** | IN  pkt #150 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24705 | yapp monitor | RX pkt #150 on the input: addr=0 len=1 parity=good gap=5 |
| 24705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24710 | yapp driver | TX pkt #150 accepted by the DUT |
| 24710 | yapp driver | TX pkt #151: addr=0 len=1 parity=good delay=19 |
| 24785 | **DUT** | OUT ch0 pkt #150 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 24800 | ch0 driver | ch0: packet consumed (response delay 9) |
| 24905 | **DUT** | IN  pkt #151 header: addr=0 len=1 -> channel 0 |
| 24905 | **DUT** | OUT ch0 pkt #150 done: 3 bytes in 13 cycles |
| 24905 | ch0 monitor | ch0 RX pkt #150: addr=0 len=1 parity=good |
| 24905 | scoreboard | ch0 pkt matched: addr=0 len=1 (150 matched so far) |
| 24915 | **DUT** | OUT ch0 pkt #151 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24925 | **DUT** | IN  pkt #151 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24925 | yapp monitor | RX pkt #151 on the input: addr=0 len=1 parity=good gap=19 |
| 24925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24930 | yapp driver | TX pkt #151 accepted by the DUT |
| 24930 | yapp driver | TX pkt #152: addr=0 len=1 parity=good delay=20 |
| 24935 | **DUT** | OUT ch0 pkt #151 done: 3 bytes in 3 cycles |
| 24935 | ch0 monitor | ch0 RX pkt #151: addr=0 len=1 parity=good |
| 24935 | scoreboard | ch0 pkt matched: addr=0 len=1 (151 matched so far) |
| 25135 | **DUT** | IN  pkt #152 header: addr=0 len=1 -> channel 0 |
| 25145 | **DUT** | OUT ch0 pkt #152 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25155 | **DUT** | IN  pkt #152 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25155 | yapp monitor | RX pkt #152 on the input: addr=0 len=1 parity=good gap=20 |
| 25155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25160 | yapp driver | TX pkt #152 accepted by the DUT |
| 25160 | yapp driver | TX pkt #153: addr=0 len=1 parity=good delay=10 |
| 25165 | **DUT** | OUT ch0 pkt #152 done: 3 bytes in 3 cycles |
| 25165 | ch0 monitor | ch0 RX pkt #152: addr=0 len=1 parity=good |
| 25165 | scoreboard | ch0 pkt matched: addr=0 len=1 (152 matched so far) |
| 25230 | ch0 driver | ch0: packet consumed (response delay 9) |
| 25265 | **DUT** | IN  pkt #153 header: addr=0 len=1 -> channel 0 |
| 25285 | **DUT** | IN  pkt #153 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25285 | yapp monitor | RX pkt #153 on the input: addr=0 len=1 parity=good gap=10 |
| 25285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25290 | yapp driver | TX pkt #153 accepted by the DUT |
| 25290 | yapp driver | TX pkt #154: addr=0 len=1 parity=good delay=17 |
| 25355 | **DUT** | OUT ch0 pkt #153 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 25370 | ch0 driver | ch0: packet consumed (response delay 8) |
| 25435 | **DUT** | OUT ch0 pkt #153 done: 3 bytes in 9 cycles |
| 25435 | ch0 monitor | ch0 RX pkt #153: addr=0 len=1 parity=good |
| 25435 | scoreboard | ch0 pkt matched: addr=0 len=1 (153 matched so far) |
| 25465 | **DUT** | IN  pkt #154 header: addr=0 len=1 -> channel 0 |
| 25475 | **DUT** | OUT ch0 pkt #154 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25485 | **DUT** | IN  pkt #154 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25485 | yapp monitor | RX pkt #154 on the input: addr=0 len=1 parity=good gap=17 |
| 25485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25490 | yapp driver | TX pkt #154 accepted by the DUT |
| 25490 | yapp driver | TX pkt #155: addr=0 len=1 parity=good delay=11 |
| 25495 | **DUT** | OUT ch0 pkt #154 done: 3 bytes in 3 cycles |
| 25495 | ch0 monitor | ch0 RX pkt #154: addr=0 len=1 parity=good |
| 25495 | scoreboard | ch0 pkt matched: addr=0 len=1 (154 matched so far) |
| 25605 | **DUT** | IN  pkt #155 header: addr=0 len=1 -> channel 0 |
| 25615 | **DUT** | OUT ch0 pkt #155 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25625 | **DUT** | IN  pkt #155 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25625 | yapp monitor | RX pkt #155 on the input: addr=0 len=1 parity=good gap=11 |
| 25625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25630 | yapp driver | TX pkt #155 accepted by the DUT |
| 25630 | yapp driver | TX pkt #156: addr=0 len=1 parity=good delay=19 |
| 25635 | **DUT** | OUT ch0 pkt #155 done: 3 bytes in 3 cycles |
| 25635 | ch0 monitor | ch0 RX pkt #155: addr=0 len=1 parity=good |
| 25635 | scoreboard | ch0 pkt matched: addr=0 len=1 (155 matched so far) |
| 25640 | ch0 driver | ch0: packet consumed (response delay 5) |
| 25825 | **DUT** | IN  pkt #156 header: addr=0 len=1 -> channel 0 |
| 25845 | **DUT** | IN  pkt #156 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25845 | yapp monitor | RX pkt #156 on the input: addr=0 len=1 parity=good gap=19 |
| 25845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25850 | yapp driver | TX pkt #156 accepted by the DUT |
| 25850 | yapp driver | TX pkt #157: addr=0 len=1 parity=good delay=1 |
| 25865 | **DUT** | IN  pkt #157 header: addr=0 len=1 -> channel 0 |
| 25885 | **DUT** | IN  pkt #157 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25885 | yapp monitor | RX pkt #157 on the input: addr=0 len=1 parity=good gap=1 |
| 25885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25890 | yapp driver | TX pkt #157 accepted by the DUT |
| 25890 | yapp driver | TX pkt #158: addr=0 len=1 parity=good delay=9 |
| 25935 | **DUT** | OUT ch0 pkt #156 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 25950 | ch0 driver | ch0: packet consumed (response delay 10) |
| 25985 | **DUT** | IN  pkt #158 header: addr=0 len=1 -> channel 0 |
| 26005 | **DUT** | IN  pkt #158 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26005 | yapp monitor | RX pkt #158 on the input: addr=0 len=1 parity=good gap=9 |
| 26005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26010 | yapp driver | TX pkt #158 accepted by the DUT |
| 26010 | yapp driver | TX pkt #159: addr=0 len=1 parity=good delay=20 |
| 26045 | **DUT** | OUT ch0 pkt #156 done: 3 bytes in 12 cycles |
| 26045 | ch0 monitor | ch0 RX pkt #156: addr=0 len=1 parity=good |
| 26045 | scoreboard | ch0 pkt matched: addr=0 len=1 (156 matched so far) |
| 26055 | **DUT** | OUT ch0 pkt #157 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26075 | **DUT** | OUT ch0 pkt #157 done: 3 bytes in 3 cycles |
| 26075 | ch0 monitor | ch0 RX pkt #157: addr=0 len=1 parity=good |
| 26075 | scoreboard | ch0 pkt matched: addr=0 len=1 (157 matched so far) |
| 26085 | **DUT** | OUT ch0 pkt #158 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26105 | **DUT** | OUT ch0 pkt #158 done: 3 bytes in 3 cycles |
| 26105 | ch0 monitor | ch0 RX pkt #158: addr=0 len=1 parity=good |
| 26105 | scoreboard | ch0 pkt matched: addr=0 len=1 (158 matched so far) |
| 26170 | ch0 driver | ch0: packet consumed (response delay 8) |
| 26215 | **DUT** | IN  pkt #159 header: addr=0 len=1 -> channel 0 |
| 26235 | **DUT** | IN  pkt #159 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26235 | yapp monitor | RX pkt #159 on the input: addr=0 len=1 parity=good gap=20 |
| 26235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26240 | yapp driver | TX pkt #159 accepted by the DUT |
| 26240 | yapp driver | TX pkt #160: addr=0 len=1 parity=good delay=20 |
| 26305 | **DUT** | OUT ch0 pkt #159 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 26320 | ch0 driver | ch0: packet consumed (response delay 8) |
| 26435 | **DUT** | OUT ch0 pkt #159 done: 3 bytes in 14 cycles |
| 26435 | ch0 monitor | ch0 RX pkt #159: addr=0 len=1 parity=good |
| 26435 | scoreboard | ch0 pkt matched: addr=0 len=1 (159 matched so far) |
| 26445 | **DUT** | IN  pkt #160 header: addr=0 len=1 -> channel 0 |
| 26455 | **DUT** | OUT ch0 pkt #160 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26465 | **DUT** | IN  pkt #160 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26465 | yapp monitor | RX pkt #160 on the input: addr=0 len=1 parity=good gap=20 |
| 26465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26470 | yapp driver | TX pkt #160 accepted by the DUT |
| 26470 | yapp driver | TX pkt #161: addr=0 len=1 parity=good delay=18 |
| 26475 | **DUT** | OUT ch0 pkt #160 done: 3 bytes in 3 cycles |
| 26475 | ch0 monitor | ch0 RX pkt #160: addr=0 len=1 parity=good |
| 26475 | scoreboard | ch0 pkt matched: addr=0 len=1 (160 matched so far) |
| 26655 | **DUT** | IN  pkt #161 header: addr=0 len=1 -> channel 0 |
| 26665 | **DUT** | OUT ch0 pkt #161 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26675 | **DUT** | IN  pkt #161 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26675 | yapp monitor | RX pkt #161 on the input: addr=0 len=1 parity=good gap=18 |
| 26675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26680 | yapp driver | TX pkt #161 accepted by the DUT |
| 26680 | yapp driver | TX pkt #162: addr=0 len=1 parity=good delay=13 |
| 26685 | **DUT** | OUT ch0 pkt #161 done: 3 bytes in 3 cycles |
| 26685 | ch0 monitor | ch0 RX pkt #161: addr=0 len=1 parity=good |
| 26685 | scoreboard | ch0 pkt matched: addr=0 len=1 (161 matched so far) |
| 26810 | ch0 driver | ch0: packet consumed (response delay 10) |
| 26815 | **DUT** | IN  pkt #162 header: addr=0 len=1 -> channel 0 |
| 26835 | **DUT** | IN  pkt #162 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26835 | yapp monitor | RX pkt #162 on the input: addr=0 len=1 parity=good gap=13 |
| 26835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26840 | yapp driver | TX pkt #162 accepted by the DUT |
| 26840 | yapp driver | TX pkt #163: addr=0 len=1 parity=good delay=12 |
| 26865 | **DUT** | OUT ch0 pkt #162 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 26880 | ch0 driver | ch0: packet consumed (response delay 4) |
| 26945 | **DUT** | OUT ch0 pkt #162 done: 3 bytes in 9 cycles |
| 26945 | ch0 monitor | ch0 RX pkt #162: addr=0 len=1 parity=good |
| 26945 | scoreboard | ch0 pkt matched: addr=0 len=1 (162 matched so far) |
| 26965 | **DUT** | IN  pkt #163 header: addr=0 len=1 -> channel 0 |
| 26975 | **DUT** | OUT ch0 pkt #163 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26985 | **DUT** | IN  pkt #163 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26985 | yapp monitor | RX pkt #163 on the input: addr=0 len=1 parity=good gap=12 |
| 26985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26990 | yapp driver | TX pkt #163 accepted by the DUT |
| 26990 | yapp driver | TX pkt #164: addr=0 len=1 parity=good delay=16 |
| 26995 | **DUT** | OUT ch0 pkt #163 done: 3 bytes in 3 cycles |
| 26995 | ch0 monitor | ch0 RX pkt #163: addr=0 len=1 parity=good |
| 26995 | scoreboard | ch0 pkt matched: addr=0 len=1 (163 matched so far) |
| 27155 | **DUT** | IN  pkt #164 header: addr=0 len=1 -> channel 0 |
| 27165 | **DUT** | OUT ch0 pkt #164 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27175 | **DUT** | IN  pkt #164 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27175 | yapp monitor | RX pkt #164 on the input: addr=0 len=1 parity=good gap=16 |
| 27175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27180 | yapp driver | TX pkt #164 accepted by the DUT |
| 27180 | yapp driver | TX pkt #165: addr=0 len=1 parity=good delay=15 |
| 27185 | **DUT** | OUT ch0 pkt #164 done: 3 bytes in 3 cycles |
| 27185 | ch0 monitor | ch0 RX pkt #164: addr=0 len=1 parity=good |
| 27185 | scoreboard | ch0 pkt matched: addr=0 len=1 (164 matched so far) |
| 27335 | **DUT** | IN  pkt #165 header: addr=0 len=1 -> channel 0 |
| 27345 | **DUT** | OUT ch0 pkt #165 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27355 | **DUT** | IN  pkt #165 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27355 | yapp monitor | RX pkt #165 on the input: addr=0 len=1 parity=good gap=15 |
| 27355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27360 | yapp driver | TX pkt #165 accepted by the DUT |
| 27360 | yapp driver | TX pkt #166: addr=0 len=1 parity=good delay=15 |
| 27365 | **DUT** | OUT ch0 pkt #165 done: 3 bytes in 3 cycles |
| 27365 | ch0 monitor | ch0 RX pkt #165: addr=0 len=1 parity=good |
| 27365 | scoreboard | ch0 pkt matched: addr=0 len=1 (165 matched so far) |
| 27400 | ch0 driver | ch0: packet consumed (response delay 5) |
| 27515 | **DUT** | IN  pkt #166 header: addr=0 len=1 -> channel 0 |
| 27535 | **DUT** | IN  pkt #166 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27535 | yapp monitor | RX pkt #166 on the input: addr=0 len=1 parity=good gap=15 |
| 27535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27540 | yapp driver | TX pkt #166 accepted by the DUT |
| 27540 | yapp driver | TX pkt #167: addr=0 len=1 parity=good delay=20 |
| 27625 | **DUT** | OUT ch0 pkt #166 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 27640 | ch0 driver | ch0: packet consumed (response delay 10) |
| 27735 | **DUT** | OUT ch0 pkt #166 done: 3 bytes in 12 cycles |
| 27735 | ch0 monitor | ch0 RX pkt #166: addr=0 len=1 parity=good |
| 27735 | scoreboard | ch0 pkt matched: addr=0 len=1 (166 matched so far) |
| 27745 | **DUT** | IN  pkt #167 header: addr=0 len=1 -> channel 0 |
| 27755 | **DUT** | OUT ch0 pkt #167 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27765 | **DUT** | IN  pkt #167 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27765 | yapp monitor | RX pkt #167 on the input: addr=0 len=1 parity=good gap=20 |
| 27765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27770 | yapp driver | TX pkt #167 accepted by the DUT |
| 27770 | yapp driver | TX pkt #168: addr=0 len=1 parity=good delay=9 |
| 27775 | **DUT** | OUT ch0 pkt #167 done: 3 bytes in 3 cycles |
| 27775 | ch0 monitor | ch0 RX pkt #167: addr=0 len=1 parity=good |
| 27775 | scoreboard | ch0 pkt matched: addr=0 len=1 (167 matched so far) |
| 27865 | **DUT** | IN  pkt #168 header: addr=0 len=1 -> channel 0 |
| 27875 | **DUT** | OUT ch0 pkt #168 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27885 | **DUT** | IN  pkt #168 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27885 | yapp monitor | RX pkt #168 on the input: addr=0 len=1 parity=good gap=9 |
| 27885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27890 | yapp driver | TX pkt #168 accepted by the DUT |
| 27890 | yapp driver | TX pkt #169: addr=0 len=1 parity=good delay=16 |
| 27895 | **DUT** | OUT ch0 pkt #168 done: 3 bytes in 3 cycles |
| 27895 | ch0 monitor | ch0 RX pkt #168: addr=0 len=1 parity=good |
| 27895 | scoreboard | ch0 pkt matched: addr=0 len=1 (168 matched so far) |
| 28055 | **DUT** | IN  pkt #169 header: addr=0 len=1 -> channel 0 |
| 28065 | **DUT** | OUT ch0 pkt #169 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28075 | **DUT** | IN  pkt #169 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28075 | yapp monitor | RX pkt #169 on the input: addr=0 len=1 parity=good gap=16 |
| 28075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28080 | yapp driver | TX pkt #169 accepted by the DUT |
| 28080 | yapp driver | TX pkt #170: addr=0 len=1 parity=good delay=9 |
| 28085 | **DUT** | OUT ch0 pkt #169 done: 3 bytes in 3 cycles |
| 28085 | ch0 monitor | ch0 RX pkt #169: addr=0 len=1 parity=good |
| 28085 | scoreboard | ch0 pkt matched: addr=0 len=1 (169 matched so far) |
| 28100 | ch0 driver | ch0: packet consumed (response delay 8) |
| 28175 | **DUT** | IN  pkt #170 header: addr=0 len=1 -> channel 0 |
| 28195 | **DUT** | IN  pkt #170 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28195 | yapp monitor | RX pkt #170 on the input: addr=0 len=1 parity=good gap=9 |
| 28195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28200 | yapp driver | TX pkt #170 accepted by the DUT |
| 28200 | yapp driver | TX pkt #171: addr=0 len=1 parity=good delay=4 |
| 28205 | **DUT** | OUT ch0 pkt #170 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 28220 | ch0 driver | ch0: packet consumed (response delay 2) |
| 28245 | **DUT** | IN  pkt #171 header: addr=0 len=1 -> channel 0 |
| 28265 | **DUT** | IN  pkt #171 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28265 | yapp monitor | RX pkt #171 on the input: addr=0 len=1 parity=good gap=4 |
| 28265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28270 | yapp driver | TX pkt #171 accepted by the DUT |
| 28270 | yapp driver | TX pkt #172: addr=0 len=1 parity=good delay=20 |
| 28335 | **DUT** | OUT ch0 pkt #170 done: 3 bytes in 14 cycles |
| 28335 | ch0 monitor | ch0 RX pkt #170: addr=0 len=1 parity=good |
| 28335 | scoreboard | ch0 pkt matched: addr=0 len=1 (170 matched so far) |
| 28345 | **DUT** | OUT ch0 pkt #171 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28365 | **DUT** | OUT ch0 pkt #171 done: 3 bytes in 3 cycles |
| 28365 | ch0 monitor | ch0 RX pkt #171: addr=0 len=1 parity=good |
| 28365 | scoreboard | ch0 pkt matched: addr=0 len=1 (171 matched so far) |
| 28475 | **DUT** | IN  pkt #172 header: addr=0 len=1 -> channel 0 |
| 28485 | **DUT** | OUT ch0 pkt #172 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28495 | **DUT** | IN  pkt #172 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28495 | yapp monitor | RX pkt #172 on the input: addr=0 len=1 parity=good gap=20 |
| 28495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28500 | yapp driver | TX pkt #172 accepted by the DUT |
| 28500 | yapp driver | TX pkt #173: addr=0 len=1 parity=good delay=17 |
| 28505 | **DUT** | OUT ch0 pkt #172 done: 3 bytes in 3 cycles |
| 28505 | ch0 monitor | ch0 RX pkt #172: addr=0 len=1 parity=good |
| 28505 | scoreboard | ch0 pkt matched: addr=0 len=1 (172 matched so far) |
| 28675 | **DUT** | IN  pkt #173 header: addr=0 len=1 -> channel 0 |
| 28685 | **DUT** | OUT ch0 pkt #173 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28695 | **DUT** | IN  pkt #173 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28695 | yapp monitor | RX pkt #173 on the input: addr=0 len=1 parity=good gap=17 |
| 28695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28700 | yapp driver | TX pkt #173 accepted by the DUT |
| 28700 | yapp driver | TX pkt #174: addr=0 len=1 parity=good delay=20 |
| 28705 | **DUT** | OUT ch0 pkt #173 done: 3 bytes in 3 cycles |
| 28705 | ch0 monitor | ch0 RX pkt #173: addr=0 len=1 parity=good |
| 28705 | scoreboard | ch0 pkt matched: addr=0 len=1 (173 matched so far) |
| 28905 | **DUT** | IN  pkt #174 header: addr=0 len=1 -> channel 0 |
| 28915 | **DUT** | OUT ch0 pkt #174 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28925 | **DUT** | IN  pkt #174 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28925 | yapp monitor | RX pkt #174 on the input: addr=0 len=1 parity=good gap=20 |
| 28925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28930 | yapp driver | TX pkt #174 accepted by the DUT |
| 28930 | yapp driver | TX pkt #175: addr=0 len=1 parity=good delay=18 |
| 28935 | **DUT** | OUT ch0 pkt #174 done: 3 bytes in 3 cycles |
| 28935 | ch0 monitor | ch0 RX pkt #174: addr=0 len=1 parity=good |
| 28935 | scoreboard | ch0 pkt matched: addr=0 len=1 (174 matched so far) |
| 28940 | ch0 driver | ch0: packet consumed (response delay 10) |
| 29115 | **DUT** | IN  pkt #175 header: addr=0 len=1 -> channel 0 |
| 29135 | **DUT** | IN  pkt #175 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29135 | yapp monitor | RX pkt #175 on the input: addr=0 len=1 parity=good gap=18 |
| 29135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29140 | yapp driver | TX pkt #175 accepted by the DUT |
| 29140 | yapp driver | TX pkt #176: addr=0 len=1 parity=good delay=20 |
| 29155 | **DUT** | OUT ch0 pkt #175 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 29170 | ch0 driver | ch0: packet consumed (response delay 3) |
| 29255 | **DUT** | OUT ch0 pkt #175 done: 3 bytes in 11 cycles |
| 29255 | ch0 monitor | ch0 RX pkt #175: addr=0 len=1 parity=good |
| 29255 | scoreboard | ch0 pkt matched: addr=0 len=1 (175 matched so far) |
| 29345 | **DUT** | IN  pkt #176 header: addr=0 len=1 -> channel 0 |
| 29355 | **DUT** | OUT ch0 pkt #176 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29365 | **DUT** | IN  pkt #176 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29365 | yapp monitor | RX pkt #176 on the input: addr=0 len=1 parity=good gap=20 |
| 29365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29370 | yapp driver | TX pkt #176 accepted by the DUT |
| 29370 | yapp driver | TX pkt #177: addr=0 len=1 parity=good delay=6 |
| 29375 | **DUT** | OUT ch0 pkt #176 done: 3 bytes in 3 cycles |
| 29375 | ch0 monitor | ch0 RX pkt #176: addr=0 len=1 parity=good |
| 29375 | scoreboard | ch0 pkt matched: addr=0 len=1 (176 matched so far) |
| 29435 | **DUT** | IN  pkt #177 header: addr=0 len=1 -> channel 0 |
| 29445 | **DUT** | OUT ch0 pkt #177 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29455 | **DUT** | IN  pkt #177 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29455 | yapp monitor | RX pkt #177 on the input: addr=0 len=1 parity=good gap=6 |
| 29455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29460 | yapp driver | TX pkt #177 accepted by the DUT |
| 29460 | yapp driver | TX pkt #178: addr=0 len=1 parity=good delay=10 |
| 29465 | **DUT** | OUT ch0 pkt #177 done: 3 bytes in 3 cycles |
| 29465 | ch0 monitor | ch0 RX pkt #177: addr=0 len=1 parity=good |
| 29465 | scoreboard | ch0 pkt matched: addr=0 len=1 (177 matched so far) |
| 29565 | **DUT** | IN  pkt #178 header: addr=0 len=1 -> channel 0 |
| 29575 | **DUT** | OUT ch0 pkt #178 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29585 | **DUT** | IN  pkt #178 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29585 | yapp monitor | RX pkt #178 on the input: addr=0 len=1 parity=good gap=10 |
| 29585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29590 | ch0 driver | ch0: packet consumed (response delay 7) |
| 29590 | yapp driver | TX pkt #178 accepted by the DUT |
| 29590 | yapp driver | TX pkt #179: addr=0 len=1 parity=good delay=7 |
| 29665 | **DUT** | IN  pkt #179 header: addr=0 len=1 -> channel 0 |
| 29675 | **DUT** | OUT ch0 pkt #178 done: 3 bytes in 11 cycles |
| 29675 | ch0 monitor | ch0 RX pkt #178: addr=0 len=1 parity=good |
| 29675 | scoreboard | ch0 pkt matched: addr=0 len=1 (178 matched so far) |
| 29685 | **DUT** | IN  pkt #179 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29685 | **DUT** | OUT ch0 pkt #179 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29685 | yapp monitor | RX pkt #179 on the input: addr=0 len=1 parity=good gap=7 |
| 29685 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29690 | yapp driver | TX pkt #179 accepted by the DUT |
| 29690 | yapp driver | TX pkt #180: addr=0 len=1 parity=good delay=20 |
| 29705 | **DUT** | OUT ch0 pkt #179 done: 3 bytes in 3 cycles |
| 29705 | ch0 monitor | ch0 RX pkt #179: addr=0 len=1 parity=good |
| 29705 | scoreboard | ch0 pkt matched: addr=0 len=1 (179 matched so far) |
| 29895 | **DUT** | IN  pkt #180 header: addr=0 len=1 -> channel 0 |
| 29905 | **DUT** | OUT ch0 pkt #180 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29915 | **DUT** | IN  pkt #180 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29915 | yapp monitor | RX pkt #180 on the input: addr=0 len=1 parity=good gap=20 |
| 29915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29920 | yapp driver | TX pkt #180 accepted by the DUT |
| 29920 | yapp driver | TX pkt #181: addr=0 len=1 parity=good delay=20 |
| 29925 | **DUT** | OUT ch0 pkt #180 done: 3 bytes in 3 cycles |
| 29925 | ch0 monitor | ch0 RX pkt #180: addr=0 len=1 parity=good |
| 29925 | scoreboard | ch0 pkt matched: addr=0 len=1 (180 matched so far) |
| 29950 | ch0 driver | ch0: packet consumed (response delay 7) |
| 30125 | **DUT** | IN  pkt #181 header: addr=0 len=1 -> channel 0 |
| 30145 | **DUT** | IN  pkt #181 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30145 | yapp monitor | RX pkt #181 on the input: addr=0 len=1 parity=good gap=20 |
| 30145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30150 | yapp driver | TX pkt #181 accepted by the DUT |
| 30150 | yapp driver | TX pkt #182: addr=0 len=1 parity=good delay=16 |
| 30215 | **DUT** | OUT ch0 pkt #181 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 30230 | ch0 driver | ch0: packet consumed (response delay 8) |
| 30245 | **DUT** | OUT ch0 pkt #181 done: 3 bytes in 4 cycles |
| 30245 | ch0 monitor | ch0 RX pkt #181: addr=0 len=1 parity=good |
| 30245 | scoreboard | ch0 pkt matched: addr=0 len=1 (181 matched so far) |
| 30315 | **DUT** | IN  pkt #182 header: addr=0 len=1 -> channel 0 |
| 30325 | **DUT** | OUT ch0 pkt #182 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30335 | **DUT** | IN  pkt #182 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30335 | yapp monitor | RX pkt #182 on the input: addr=0 len=1 parity=good gap=16 |
| 30335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30340 | yapp driver | TX pkt #182 accepted by the DUT |
| 30340 | yapp driver | TX pkt #183: addr=0 len=1 parity=good delay=19 |
| 30345 | **DUT** | OUT ch0 pkt #182 done: 3 bytes in 3 cycles |
| 30345 | ch0 monitor | ch0 RX pkt #182: addr=0 len=1 parity=good |
| 30345 | scoreboard | ch0 pkt matched: addr=0 len=1 (182 matched so far) |
| 30535 | **DUT** | IN  pkt #183 header: addr=0 len=1 -> channel 0 |
| 30545 | **DUT** | OUT ch0 pkt #183 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30555 | **DUT** | IN  pkt #183 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30555 | yapp monitor | RX pkt #183 on the input: addr=0 len=1 parity=good gap=19 |
| 30555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30560 | yapp driver | TX pkt #183 accepted by the DUT |
| 30560 | yapp driver | TX pkt #184: addr=0 len=1 parity=good delay=7 |
| 30565 | **DUT** | OUT ch0 pkt #183 done: 3 bytes in 3 cycles |
| 30565 | ch0 monitor | ch0 RX pkt #183: addr=0 len=1 parity=good |
| 30565 | scoreboard | ch0 pkt matched: addr=0 len=1 (183 matched so far) |
| 30635 | **DUT** | IN  pkt #184 header: addr=0 len=1 -> channel 0 |
| 30645 | **DUT** | OUT ch0 pkt #184 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30655 | **DUT** | IN  pkt #184 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30655 | yapp monitor | RX pkt #184 on the input: addr=0 len=1 parity=good gap=7 |
| 30655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30660 | yapp driver | TX pkt #184 accepted by the DUT |
| 30660 | yapp driver | TX pkt #185: addr=0 len=1 parity=good delay=6 |
| 30665 | **DUT** | OUT ch0 pkt #184 done: 3 bytes in 3 cycles |
| 30665 | ch0 monitor | ch0 RX pkt #184: addr=0 len=1 parity=good |
| 30665 | scoreboard | ch0 pkt matched: addr=0 len=1 (184 matched so far) |
| 30670 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30725 | **DUT** | IN  pkt #185 header: addr=0 len=1 -> channel 0 |
| 30735 | **DUT** | OUT ch0 pkt #185 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30745 | **DUT** | IN  pkt #185 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30745 | yapp monitor | RX pkt #185 on the input: addr=0 len=1 parity=good gap=6 |
| 30745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30750 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30750 | yapp driver | TX pkt #185 accepted by the DUT |
| 30750 | yapp driver | TX pkt #186: addr=0 len=1 parity=good delay=17 |
| 30855 | **DUT** | OUT ch0 pkt #185 done: 3 bytes in 13 cycles |
| 30855 | ch0 monitor | ch0 RX pkt #185: addr=0 len=1 parity=good |
| 30855 | scoreboard | ch0 pkt matched: addr=0 len=1 (185 matched so far) |
| 30925 | **DUT** | IN  pkt #186 header: addr=0 len=1 -> channel 0 |
| 30935 | **DUT** | OUT ch0 pkt #186 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30945 | **DUT** | IN  pkt #186 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30945 | yapp monitor | RX pkt #186 on the input: addr=0 len=1 parity=good gap=17 |
| 30945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30950 | yapp driver | TX pkt #186 accepted by the DUT |
| 30950 | yapp driver | TX pkt #187: addr=0 len=1 parity=good delay=16 |
| 30955 | **DUT** | OUT ch0 pkt #186 done: 3 bytes in 3 cycles |
| 30955 | ch0 monitor | ch0 RX pkt #186: addr=0 len=1 parity=good |
| 30955 | scoreboard | ch0 pkt matched: addr=0 len=1 (186 matched so far) |
| 31040 | ch0 driver | ch0: packet consumed (response delay 9) |
| 31115 | **DUT** | IN  pkt #187 header: addr=0 len=1 -> channel 0 |
| 31125 | **DUT** | OUT ch0 pkt #187 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31135 | **DUT** | IN  pkt #187 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31135 | yapp monitor | RX pkt #187 on the input: addr=0 len=1 parity=good gap=16 |
| 31135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31140 | ch0 driver | ch0: packet consumed (response delay 0) |
| 31140 | yapp driver | TX pkt #187 accepted by the DUT |
| 31140 | yapp driver | TX pkt #188: addr=0 len=1 parity=good delay=20 |
| 31255 | **DUT** | OUT ch0 pkt #187 done: 3 bytes in 14 cycles |
| 31255 | ch0 monitor | ch0 RX pkt #187: addr=0 len=1 parity=good |
| 31255 | scoreboard | ch0 pkt matched: addr=0 len=1 (187 matched so far) |
| 31345 | **DUT** | IN  pkt #188 header: addr=0 len=1 -> channel 0 |
| 31355 | **DUT** | OUT ch0 pkt #188 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31365 | **DUT** | IN  pkt #188 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31365 | yapp monitor | RX pkt #188 on the input: addr=0 len=1 parity=good gap=20 |
| 31365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31370 | yapp driver | TX pkt #188 accepted by the DUT |
| 31370 | yapp driver | TX pkt #189: addr=0 len=1 parity=good delay=10 |
| 31375 | **DUT** | OUT ch0 pkt #188 done: 3 bytes in 3 cycles |
| 31375 | ch0 monitor | ch0 RX pkt #188: addr=0 len=1 parity=good |
| 31375 | scoreboard | ch0 pkt matched: addr=0 len=1 (188 matched so far) |
| 31475 | **DUT** | IN  pkt #189 header: addr=0 len=1 -> channel 0 |
| 31485 | **DUT** | OUT ch0 pkt #189 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31495 | **DUT** | IN  pkt #189 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31495 | yapp monitor | RX pkt #189 on the input: addr=0 len=1 parity=good gap=10 |
| 31495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31500 | yapp driver | TX pkt #189 accepted by the DUT |
| 31500 | yapp driver | TX pkt #190: addr=0 len=1 parity=good delay=8 |
| 31505 | **DUT** | OUT ch0 pkt #189 done: 3 bytes in 3 cycles |
| 31505 | ch0 monitor | ch0 RX pkt #189: addr=0 len=1 parity=good |
| 31505 | scoreboard | ch0 pkt matched: addr=0 len=1 (189 matched so far) |
| 31570 | ch0 driver | ch0: packet consumed (response delay 10) |
| 31585 | **DUT** | IN  pkt #190 header: addr=0 len=1 -> channel 0 |
| 31605 | **DUT** | IN  pkt #190 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31605 | yapp monitor | RX pkt #190 on the input: addr=0 len=1 parity=good gap=8 |
| 31605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31610 | yapp driver | TX pkt #190 accepted by the DUT |
| 31610 | yapp driver | TX pkt #191: addr=0 len=1 parity=good delay=7 |
| 31665 | **DUT** | OUT ch0 pkt #190 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 31680 | ch0 driver | ch0: packet consumed (response delay 7) |
| 31685 | **DUT** | IN  pkt #191 header: addr=0 len=1 -> channel 0 |
| 31705 | **DUT** | IN  pkt #191 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31705 | yapp monitor | RX pkt #191 on the input: addr=0 len=1 parity=good gap=7 |
| 31705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31710 | yapp driver | TX pkt #191 accepted by the DUT |
| 31710 | yapp driver | TX pkt #192: addr=0 len=1 parity=good delay=8 |
| 31795 | **DUT** | IN  pkt #192 header: addr=0 len=1 -> channel 0 |
| 31795 | **DUT** | OUT ch0 pkt #190 done: 3 bytes in 14 cycles |
| 31795 | ch0 monitor | ch0 RX pkt #190: addr=0 len=1 parity=good |
| 31795 | scoreboard | ch0 pkt matched: addr=0 len=1 (190 matched so far) |
| 31805 | **DUT** | OUT ch0 pkt #191 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31815 | **DUT** | IN  pkt #192 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31815 | yapp monitor | RX pkt #192 on the input: addr=0 len=1 parity=good gap=8 |
| 31815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31820 | yapp driver | TX pkt #192 accepted by the DUT |
| 31820 | yapp driver | TX pkt #193: addr=0 len=1 parity=good delay=20 |
| 31825 | **DUT** | OUT ch0 pkt #191 done: 3 bytes in 3 cycles |
| 31825 | ch0 monitor | ch0 RX pkt #191: addr=0 len=1 parity=good |
| 31825 | scoreboard | ch0 pkt matched: addr=0 len=1 (191 matched so far) |
| 31835 | **DUT** | OUT ch0 pkt #192 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31855 | **DUT** | OUT ch0 pkt #192 done: 3 bytes in 3 cycles |
| 31855 | ch0 monitor | ch0 RX pkt #192: addr=0 len=1 parity=good |
| 31855 | scoreboard | ch0 pkt matched: addr=0 len=1 (192 matched so far) |
| 32025 | **DUT** | IN  pkt #193 header: addr=0 len=1 -> channel 0 |
| 32035 | **DUT** | OUT ch0 pkt #193 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32045 | **DUT** | IN  pkt #193 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32045 | yapp monitor | RX pkt #193 on the input: addr=0 len=1 parity=good gap=20 |
| 32045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32050 | yapp driver | TX pkt #193 accepted by the DUT |
| 32050 | yapp driver | TX pkt #194: addr=0 len=1 parity=good delay=18 |
| 32055 | **DUT** | OUT ch0 pkt #193 done: 3 bytes in 3 cycles |
| 32055 | ch0 monitor | ch0 RX pkt #193: addr=0 len=1 parity=good |
| 32055 | scoreboard | ch0 pkt matched: addr=0 len=1 (193 matched so far) |
| 32060 | ch0 driver | ch0: packet consumed (response delay 10) |
| 32235 | **DUT** | IN  pkt #194 header: addr=0 len=1 -> channel 0 |
| 32255 | **DUT** | IN  pkt #194 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32255 | yapp monitor | RX pkt #194 on the input: addr=0 len=1 parity=good gap=18 |
| 32255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32260 | yapp driver | TX pkt #194 accepted by the DUT |
| 32260 | yapp driver | TX pkt #195: addr=0 len=1 parity=good delay=1 |
| 32275 | **DUT** | IN  pkt #195 header: addr=0 len=1 -> channel 0 |
| 32295 | **DUT** | IN  pkt #195 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32295 | yapp monitor | RX pkt #195 on the input: addr=0 len=1 parity=good gap=1 |
| 32295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32300 | yapp driver | TX pkt #195 accepted by the DUT |
| 32300 | yapp driver | TX pkt #196: addr=0 len=1 parity=good delay=18 |
| 32305 | **DUT** | OUT ch0 pkt #194 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 32320 | ch0 driver | ch0: packet consumed (response delay 6) |
| 32335 | **DUT** | OUT ch0 pkt #194 done: 3 bytes in 4 cycles |
| 32335 | ch0 monitor | ch0 RX pkt #194: addr=0 len=1 parity=good |
| 32335 | scoreboard | ch0 pkt matched: addr=0 len=1 (194 matched so far) |
| 32345 | **DUT** | OUT ch0 pkt #195 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32350 | ch0 driver | ch0: packet consumed (response delay 0) |
| 32395 | **DUT** | OUT ch0 pkt #195 done: 3 bytes in 6 cycles |
| 32395 | ch0 monitor | ch0 RX pkt #195: addr=0 len=1 parity=good |
| 32395 | scoreboard | ch0 pkt matched: addr=0 len=1 (195 matched so far) |
| 32485 | **DUT** | IN  pkt #196 header: addr=0 len=1 -> channel 0 |
| 32495 | **DUT** | OUT ch0 pkt #196 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32505 | **DUT** | IN  pkt #196 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32505 | yapp monitor | RX pkt #196 on the input: addr=0 len=1 parity=good gap=18 |
| 32505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32510 | yapp driver | TX pkt #196 accepted by the DUT |
| 32510 | yapp driver | TX pkt #197: addr=0 len=1 parity=good delay=9 |
| 32515 | **DUT** | OUT ch0 pkt #196 done: 3 bytes in 3 cycles |
| 32515 | ch0 monitor | ch0 RX pkt #196: addr=0 len=1 parity=good |
| 32515 | scoreboard | ch0 pkt matched: addr=0 len=1 (196 matched so far) |
| 32605 | **DUT** | IN  pkt #197 header: addr=0 len=1 -> channel 0 |
| 32615 | **DUT** | OUT ch0 pkt #197 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32625 | **DUT** | IN  pkt #197 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32625 | yapp monitor | RX pkt #197 on the input: addr=0 len=1 parity=good gap=9 |
| 32625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32630 | yapp driver | TX pkt #197 accepted by the DUT |
| 32630 | yapp driver | TX pkt #198: addr=0 len=1 parity=good delay=12 |
| 32635 | **DUT** | OUT ch0 pkt #197 done: 3 bytes in 3 cycles |
| 32635 | ch0 monitor | ch0 RX pkt #197: addr=0 len=1 parity=good |
| 32635 | scoreboard | ch0 pkt matched: addr=0 len=1 (197 matched so far) |
| 32720 | ch0 driver | ch0: packet consumed (response delay 2) |
| 32755 | **DUT** | IN  pkt #198 header: addr=0 len=1 -> channel 0 |
| 32775 | **DUT** | IN  pkt #198 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32775 | yapp monitor | RX pkt #198 on the input: addr=0 len=1 parity=good gap=12 |
| 32775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32780 | yapp driver | TX pkt #198 accepted by the DUT |
| 32780 | yapp driver | TX pkt #199: addr=0 len=1 parity=good delay=19 |
| 32855 | **DUT** | OUT ch0 pkt #198 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 32870 | ch0 driver | ch0: packet consumed (response delay 9) |
| 32885 | **DUT** | OUT ch0 pkt #198 done: 3 bytes in 4 cycles |
| 32885 | ch0 monitor | ch0 RX pkt #198: addr=0 len=1 parity=good |
| 32885 | scoreboard | ch0 pkt matched: addr=0 len=1 (198 matched so far) |
| 32910 | ch0 driver | ch0: packet consumed (response delay 0) |
| 32975 | **DUT** | IN  pkt #199 header: addr=0 len=1 -> channel 0 |
| 32995 | **DUT** | IN  pkt #199 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32995 | yapp monitor | RX pkt #199 on the input: addr=0 len=1 parity=good gap=19 |
| 32995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33000 | yapp driver | TX pkt #199 accepted by the DUT |
| 33000 | yapp driver | TX pkt #200: addr=0 len=1 parity=good delay=12 |
| 33065 | **DUT** | OUT ch0 pkt #199 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 33080 | ch0 driver | ch0: packet consumed (response delay 8) |
| 33125 | **DUT** | IN  pkt #200 header: addr=0 len=1 -> channel 0 |
| 33145 | **DUT** | IN  pkt #200 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33145 | yapp monitor | RX pkt #200 on the input: addr=0 len=1 parity=good gap=12 |
| 33145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33150 | yapp driver | TX pkt #200 accepted by the DUT |
| 33150 | yapp driver | TX pkt #201: addr=0 len=1 parity=good delay=1 |
| 33165 | **DUT** | IN  pkt #201 header: addr=0 len=1 -> channel 0 |
| 33185 | **DUT** | IN  pkt #201 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33185 | yapp monitor | RX pkt #201 on the input: addr=0 len=1 parity=good gap=1 |
| 33185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33190 | yapp driver | TX pkt #201 accepted by the DUT |
| 33190 | yapp driver | TX pkt #202: addr=0 len=1 parity=good delay=15 |
| 33195 | **DUT** | OUT ch0 pkt #199 done: 3 bytes in 14 cycles |
| 33195 | ch0 monitor | ch0 RX pkt #199: addr=0 len=1 parity=good |
| 33195 | scoreboard | ch0 pkt matched: addr=0 len=1 (199 matched so far) |
| 33205 | **DUT** | OUT ch0 pkt #200 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33225 | **DUT** | OUT ch0 pkt #200 done: 3 bytes in 3 cycles |
| 33225 | ch0 monitor | ch0 RX pkt #200: addr=0 len=1 parity=good |
| 33225 | scoreboard | ch0 pkt matched: addr=0 len=1 (200 matched so far) |
| 33235 | **DUT** | OUT ch0 pkt #201 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33255 | **DUT** | OUT ch0 pkt #201 done: 3 bytes in 3 cycles |
| 33255 | ch0 monitor | ch0 RX pkt #201: addr=0 len=1 parity=good |
| 33255 | scoreboard | ch0 pkt matched: addr=0 len=1 (201 matched so far) |
| 33345 | **DUT** | IN  pkt #202 header: addr=0 len=1 -> channel 0 |
| 33355 | **DUT** | OUT ch0 pkt #202 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33365 | **DUT** | IN  pkt #202 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33365 | yapp monitor | RX pkt #202 on the input: addr=0 len=1 parity=good gap=15 |
| 33365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33370 | yapp driver | TX pkt #202 accepted by the DUT |
| 33370 | yapp driver | TX pkt #203: addr=0 len=1 parity=good delay=15 |
| 33375 | **DUT** | OUT ch0 pkt #202 done: 3 bytes in 3 cycles |
| 33375 | ch0 monitor | ch0 RX pkt #202: addr=0 len=1 parity=good |
| 33375 | scoreboard | ch0 pkt matched: addr=0 len=1 (202 matched so far) |
| 33525 | **DUT** | IN  pkt #203 header: addr=0 len=1 -> channel 0 |
| 33535 | **DUT** | OUT ch0 pkt #203 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33545 | **DUT** | IN  pkt #203 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33545 | yapp monitor | RX pkt #203 on the input: addr=0 len=1 parity=good gap=15 |
| 33545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33550 | yapp driver | TX pkt #203 accepted by the DUT |
| 33550 | yapp driver | TX pkt #204: addr=0 len=1 parity=good delay=17 |
| 33555 | **DUT** | OUT ch0 pkt #203 done: 3 bytes in 3 cycles |
| 33555 | ch0 monitor | ch0 RX pkt #203: addr=0 len=1 parity=good |
| 33555 | scoreboard | ch0 pkt matched: addr=0 len=1 (203 matched so far) |
| 33650 | ch0 driver | ch0: packet consumed (response delay 10) |
| 33725 | **DUT** | IN  pkt #204 header: addr=0 len=1 -> channel 0 |
| 33745 | **DUT** | IN  pkt #204 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33745 | **DUT** | OUT ch0 pkt #204 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 33745 | yapp monitor | RX pkt #204 on the input: addr=0 len=1 parity=good gap=17 |
| 33745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33750 | yapp driver | TX pkt #204 accepted by the DUT |
| 33750 | yapp driver | TX pkt #205: addr=0 len=1 parity=good delay=16 |
| 33760 | ch0 driver | ch0: packet consumed (response delay 1) |
| 33875 | **DUT** | OUT ch0 pkt #204 done: 3 bytes in 14 cycles |
| 33875 | ch0 monitor | ch0 RX pkt #204: addr=0 len=1 parity=good |
| 33875 | scoreboard | ch0 pkt matched: addr=0 len=1 (204 matched so far) |
| 33915 | **DUT** | IN  pkt #205 header: addr=0 len=1 -> channel 0 |
| 33925 | **DUT** | OUT ch0 pkt #205 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33935 | **DUT** | IN  pkt #205 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33935 | yapp monitor | RX pkt #205 on the input: addr=0 len=1 parity=good gap=16 |
| 33935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33940 | yapp driver | TX pkt #205 accepted by the DUT |
| 33940 | yapp driver | TX pkt #206: addr=0 len=1 parity=good delay=20 |
| 33945 | **DUT** | OUT ch0 pkt #205 done: 3 bytes in 3 cycles |
| 33945 | ch0 monitor | ch0 RX pkt #205: addr=0 len=1 parity=good |
| 33945 | scoreboard | ch0 pkt matched: addr=0 len=1 (205 matched so far) |
| 34145 | **DUT** | IN  pkt #206 header: addr=0 len=1 -> channel 0 |
| 34155 | **DUT** | OUT ch0 pkt #206 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34165 | **DUT** | IN  pkt #206 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34165 | yapp monitor | RX pkt #206 on the input: addr=0 len=1 parity=good gap=20 |
| 34165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34170 | yapp driver | TX pkt #206 accepted by the DUT |
| 34170 | yapp driver | TX pkt #207: addr=0 len=1 parity=good delay=10 |
| 34175 | **DUT** | OUT ch0 pkt #206 done: 3 bytes in 3 cycles |
| 34175 | ch0 monitor | ch0 RX pkt #206: addr=0 len=1 parity=good |
| 34175 | scoreboard | ch0 pkt matched: addr=0 len=1 (206 matched so far) |
| 34275 | **DUT** | IN  pkt #207 header: addr=0 len=1 -> channel 0 |
| 34285 | **DUT** | OUT ch0 pkt #207 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34295 | **DUT** | IN  pkt #207 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34295 | yapp monitor | RX pkt #207 on the input: addr=0 len=1 parity=good gap=10 |
| 34295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34300 | yapp driver | TX pkt #207 accepted by the DUT |
| 34300 | yapp driver | TX pkt #208: addr=0 len=1 parity=good delay=1 |
| 34305 | **DUT** | OUT ch0 pkt #207 done: 3 bytes in 3 cycles |
| 34305 | ch0 monitor | ch0 RX pkt #207: addr=0 len=1 parity=good |
| 34305 | scoreboard | ch0 pkt matched: addr=0 len=1 (207 matched so far) |
| 34315 | **DUT** | IN  pkt #208 header: addr=0 len=1 -> channel 0 |
| 34325 | **DUT** | OUT ch0 pkt #208 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34335 | **DUT** | IN  pkt #208 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34335 | yapp monitor | RX pkt #208 on the input: addr=0 len=1 parity=good gap=1 |
| 34335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34340 | ch0 driver | ch0: packet consumed (response delay 10) |
| 34340 | yapp driver | TX pkt #208 accepted by the DUT |
| 34340 | yapp driver | TX pkt #209: addr=0 len=1 parity=good delay=16 |
| 34455 | **DUT** | OUT ch0 pkt #208 done: 3 bytes in 14 cycles |
| 34455 | ch0 monitor | ch0 RX pkt #208: addr=0 len=1 parity=good |
| 34455 | scoreboard | ch0 pkt matched: addr=0 len=1 (208 matched so far) |
| 34505 | **DUT** | IN  pkt #209 header: addr=0 len=1 -> channel 0 |
| 34515 | **DUT** | OUT ch0 pkt #209 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34525 | **DUT** | IN  pkt #209 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34525 | yapp monitor | RX pkt #209 on the input: addr=0 len=1 parity=good gap=16 |
| 34525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34530 | yapp driver | TX pkt #209 accepted by the DUT |
| 34530 | yapp driver | TX pkt #210: addr=0 len=1 parity=good delay=16 |
| 34535 | **DUT** | OUT ch0 pkt #209 done: 3 bytes in 3 cycles |
| 34535 | ch0 monitor | ch0 RX pkt #209: addr=0 len=1 parity=good |
| 34535 | scoreboard | ch0 pkt matched: addr=0 len=1 (209 matched so far) |
| 34695 | **DUT** | IN  pkt #210 header: addr=0 len=1 -> channel 0 |
| 34705 | **DUT** | OUT ch0 pkt #210 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34715 | **DUT** | IN  pkt #210 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34715 | yapp monitor | RX pkt #210 on the input: addr=0 len=1 parity=good gap=16 |
| 34715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34720 | yapp driver | TX pkt #210 accepted by the DUT |
| 34720 | yapp driver | TX pkt #211: addr=0 len=1 parity=good delay=13 |
| 34725 | **DUT** | OUT ch0 pkt #210 done: 3 bytes in 3 cycles |
| 34725 | ch0 monitor | ch0 RX pkt #210: addr=0 len=1 parity=good |
| 34725 | scoreboard | ch0 pkt matched: addr=0 len=1 (210 matched so far) |
| 34855 | **DUT** | IN  pkt #211 header: addr=0 len=1 -> channel 0 |
| 34865 | **DUT** | OUT ch0 pkt #211 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34875 | **DUT** | IN  pkt #211 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34875 | yapp monitor | RX pkt #211 on the input: addr=0 len=1 parity=good gap=13 |
| 34875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34880 | yapp driver | TX pkt #211 accepted by the DUT |
| 34880 | yapp driver | TX pkt #212: addr=0 len=1 parity=good delay=20 |
| 34885 | **DUT** | OUT ch0 pkt #211 done: 3 bytes in 3 cycles |
| 34885 | ch0 monitor | ch0 RX pkt #211: addr=0 len=1 parity=good |
| 34885 | scoreboard | ch0 pkt matched: addr=0 len=1 (211 matched so far) |
| 35050 | ch0 driver | ch0: packet consumed (response delay 10) |
| 35085 | **DUT** | IN  pkt #212 header: addr=0 len=1 -> channel 0 |
| 35105 | **DUT** | IN  pkt #212 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35105 | yapp monitor | RX pkt #212 on the input: addr=0 len=1 parity=good gap=20 |
| 35105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35110 | yapp driver | TX pkt #212 accepted by the DUT |
| 35110 | yapp driver | TX pkt #213: addr=0 len=1 parity=good delay=18 |
| 35195 | **DUT** | OUT ch0 pkt #212 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 35210 | ch0 driver | ch0: packet consumed (response delay 10) |
| 35245 | **DUT** | OUT ch0 pkt #212 done: 3 bytes in 6 cycles |
| 35245 | ch0 monitor | ch0 RX pkt #212: addr=0 len=1 parity=good |
| 35245 | scoreboard | ch0 pkt matched: addr=0 len=1 (212 matched so far) |
| 35295 | **DUT** | IN  pkt #213 header: addr=0 len=1 -> channel 0 |
| 35305 | **DUT** | OUT ch0 pkt #213 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35315 | **DUT** | IN  pkt #213 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35315 | yapp monitor | RX pkt #213 on the input: addr=0 len=1 parity=good gap=18 |
| 35315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35320 | yapp driver | TX pkt #213 accepted by the DUT |
| 35320 | yapp driver | TX pkt #214: addr=0 len=1 parity=good delay=17 |
| 35325 | **DUT** | OUT ch0 pkt #213 done: 3 bytes in 3 cycles |
| 35325 | ch0 monitor | ch0 RX pkt #213: addr=0 len=1 parity=good |
| 35325 | scoreboard | ch0 pkt matched: addr=0 len=1 (213 matched so far) |
| 35495 | **DUT** | IN  pkt #214 header: addr=0 len=1 -> channel 0 |
| 35505 | **DUT** | OUT ch0 pkt #214 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35515 | **DUT** | IN  pkt #214 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35515 | yapp monitor | RX pkt #214 on the input: addr=0 len=1 parity=good gap=17 |
| 35515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35520 | yapp driver | TX pkt #214 accepted by the DUT |
| 35520 | yapp driver | TX pkt #215: addr=0 len=1 parity=good delay=20 |
| 35525 | **DUT** | OUT ch0 pkt #214 done: 3 bytes in 3 cycles |
| 35525 | ch0 monitor | ch0 RX pkt #214: addr=0 len=1 parity=good |
| 35525 | scoreboard | ch0 pkt matched: addr=0 len=1 (214 matched so far) |
| 35610 | ch0 driver | ch0: packet consumed (response delay 2) |
| 35725 | **DUT** | IN  pkt #215 header: addr=0 len=1 -> channel 0 |
| 35745 | **DUT** | IN  pkt #215 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35745 | yapp monitor | RX pkt #215 on the input: addr=0 len=1 parity=good gap=20 |
| 35745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35750 | yapp driver | TX pkt #215 accepted by the DUT |
| 35750 | yapp driver | TX pkt #216: addr=0 len=1 parity=good delay=10 |
| 35765 | **DUT** | OUT ch0 pkt #215 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 35780 | ch0 driver | ch0: packet consumed (response delay 3) |
| 35855 | **DUT** | IN  pkt #216 header: addr=0 len=1 -> channel 0 |
| 35865 | **DUT** | OUT ch0 pkt #215 done: 3 bytes in 11 cycles |
| 35865 | ch0 monitor | ch0 RX pkt #215: addr=0 len=1 parity=good |
| 35865 | scoreboard | ch0 pkt matched: addr=0 len=1 (215 matched so far) |
| 35875 | **DUT** | IN  pkt #216 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35875 | **DUT** | OUT ch0 pkt #216 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35875 | yapp monitor | RX pkt #216 on the input: addr=0 len=1 parity=good gap=10 |
| 35875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35880 | yapp driver | TX pkt #216 accepted by the DUT |
| 35880 | yapp driver | TX pkt #217: addr=0 len=1 parity=good delay=13 |
| 35895 | **DUT** | OUT ch0 pkt #216 done: 3 bytes in 3 cycles |
| 35895 | ch0 monitor | ch0 RX pkt #216: addr=0 len=1 parity=good |
| 35895 | scoreboard | ch0 pkt matched: addr=0 len=1 (216 matched so far) |
| 36015 | **DUT** | IN  pkt #217 header: addr=0 len=1 -> channel 0 |
| 36025 | **DUT** | OUT ch0 pkt #217 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36035 | **DUT** | IN  pkt #217 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36035 | yapp monitor | RX pkt #217 on the input: addr=0 len=1 parity=good gap=13 |
| 36035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36040 | yapp driver | TX pkt #217 accepted by the DUT |
| 36040 | yapp driver | TX pkt #218: addr=0 len=1 parity=good delay=16 |
| 36045 | **DUT** | OUT ch0 pkt #217 done: 3 bytes in 3 cycles |
| 36045 | ch0 monitor | ch0 RX pkt #217: addr=0 len=1 parity=good |
| 36045 | scoreboard | ch0 pkt matched: addr=0 len=1 (217 matched so far) |
| 36060 | ch0 driver | ch0: packet consumed (response delay 7) |
| 36205 | **DUT** | IN  pkt #218 header: addr=0 len=1 -> channel 0 |
| 36225 | **DUT** | IN  pkt #218 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36225 | yapp monitor | RX pkt #218 on the input: addr=0 len=1 parity=good gap=16 |
| 36225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36230 | yapp driver | TX pkt #218 accepted by the DUT |
| 36230 | yapp driver | TX pkt #219: addr=0 len=1 parity=good delay=7 |
| 36305 | **DUT** | IN  pkt #219 header: addr=0 len=1 -> channel 0 |
| 36305 | **DUT** | OUT ch0 pkt #218 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 36320 | ch0 driver | ch0: packet consumed (response delay 9) |
| 36325 | **DUT** | IN  pkt #219 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36325 | yapp monitor | RX pkt #219 on the input: addr=0 len=1 parity=good gap=7 |
| 36325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36330 | yapp driver | TX pkt #219 accepted by the DUT |
| 36330 | yapp driver | TX pkt #220: addr=0 len=1 parity=good delay=7 |
| 36405 | **DUT** | IN  pkt #220 header: addr=0 len=1 -> channel 0 |
| 36425 | **DUT** | IN  pkt #220 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36425 | yapp monitor | RX pkt #220 on the input: addr=0 len=1 parity=good gap=7 |
| 36425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36430 | yapp driver | TX pkt #220 accepted by the DUT |
| 36430 | yapp driver | TX pkt #221: addr=0 len=1 parity=good delay=1 |
| 36435 | **DUT** | OUT ch0 pkt #218 done: 3 bytes in 14 cycles |
| 36435 | ch0 monitor | ch0 RX pkt #218: addr=0 len=1 parity=good |
| 36435 | scoreboard | ch0 pkt matched: addr=0 len=1 (218 matched so far) |
| 36445 | **DUT** | IN  pkt #221 header: addr=0 len=1 -> channel 0 |
| 36445 | **DUT** | OUT ch0 pkt #219 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36465 | **DUT** | IN  pkt #221 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36465 | **DUT** | OUT ch0 pkt #219 done: 3 bytes in 3 cycles |
| 36465 | ch0 monitor | ch0 RX pkt #219: addr=0 len=1 parity=good |
| 36465 | scoreboard | ch0 pkt matched: addr=0 len=1 (219 matched so far) |
| 36465 | yapp monitor | RX pkt #221 on the input: addr=0 len=1 parity=good gap=1 |
| 36465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36470 | yapp driver | TX pkt #221 accepted by the DUT |
| 36470 | yapp driver | TX pkt #222: addr=0 len=1 parity=good delay=18 |
| 36475 | **DUT** | OUT ch0 pkt #220 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36490 | ch0 driver | ch0: packet consumed (response delay 10) |
| 36565 | **DUT** | OUT ch0 pkt #220 done: 3 bytes in 10 cycles |
| 36565 | ch0 monitor | ch0 RX pkt #220: addr=0 len=1 parity=good |
| 36565 | scoreboard | ch0 pkt matched: addr=0 len=1 (220 matched so far) |
| 36575 | **DUT** | OUT ch0 pkt #221 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36595 | **DUT** | OUT ch0 pkt #221 done: 3 bytes in 3 cycles |
| 36595 | ch0 monitor | ch0 RX pkt #221: addr=0 len=1 parity=good |
| 36595 | scoreboard | ch0 pkt matched: addr=0 len=1 (221 matched so far) |
| 36640 | ch0 driver | ch0: packet consumed (response delay 6) |
| 36655 | **DUT** | IN  pkt #222 header: addr=0 len=1 -> channel 0 |
| 36675 | **DUT** | IN  pkt #222 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36675 | yapp monitor | RX pkt #222 on the input: addr=0 len=1 parity=good gap=18 |
| 36675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36680 | yapp driver | TX pkt #222 accepted by the DUT |
| 36680 | yapp driver | TX pkt #223: addr=0 len=1 parity=good delay=20 |
| 36755 | **DUT** | OUT ch0 pkt #222 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 36770 | ch0 driver | ch0: packet consumed (response delay 9) |
| 36885 | **DUT** | IN  pkt #223 header: addr=0 len=1 -> channel 0 |
| 36885 | **DUT** | OUT ch0 pkt #222 done: 3 bytes in 14 cycles |
| 36885 | ch0 monitor | ch0 RX pkt #222: addr=0 len=1 parity=good |
| 36885 | scoreboard | ch0 pkt matched: addr=0 len=1 (222 matched so far) |
| 36895 | **DUT** | OUT ch0 pkt #223 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36905 | **DUT** | IN  pkt #223 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36905 | yapp monitor | RX pkt #223 on the input: addr=0 len=1 parity=good gap=20 |
| 36905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36910 | yapp driver | TX pkt #223 accepted by the DUT |
| 36910 | yapp driver | TX pkt #224: addr=0 len=1 parity=good delay=20 |
| 36915 | **DUT** | OUT ch0 pkt #223 done: 3 bytes in 3 cycles |
| 36915 | ch0 monitor | ch0 RX pkt #223: addr=0 len=1 parity=good |
| 36915 | scoreboard | ch0 pkt matched: addr=0 len=1 (223 matched so far) |
| 37060 | ch0 driver | ch0: packet consumed (response delay 10) |
| 37115 | **DUT** | IN  pkt #224 header: addr=0 len=1 -> channel 0 |
| 37135 | **DUT** | IN  pkt #224 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37135 | yapp monitor | RX pkt #224 on the input: addr=0 len=1 parity=good gap=20 |
| 37135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37140 | yapp driver | TX pkt #224 accepted by the DUT |
| 37140 | yapp driver | TX pkt #225: addr=0 len=1 parity=good delay=16 |
| 37195 | **DUT** | OUT ch0 pkt #224 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 37210 | ch0 driver | ch0: packet consumed (response delay 7) |
| 37275 | **DUT** | OUT ch0 pkt #224 done: 3 bytes in 9 cycles |
| 37275 | ch0 monitor | ch0 RX pkt #224: addr=0 len=1 parity=good |
| 37275 | scoreboard | ch0 pkt matched: addr=0 len=1 (224 matched so far) |
| 37305 | **DUT** | IN  pkt #225 header: addr=0 len=1 -> channel 0 |
| 37315 | **DUT** | OUT ch0 pkt #225 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37325 | **DUT** | IN  pkt #225 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37325 | yapp monitor | RX pkt #225 on the input: addr=0 len=1 parity=good gap=16 |
| 37325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37330 | yapp driver | TX pkt #225 accepted by the DUT |
| 37330 | yapp driver | TX pkt #226: addr=0 len=1 parity=good delay=18 |
| 37335 | **DUT** | OUT ch0 pkt #225 done: 3 bytes in 3 cycles |
| 37335 | ch0 monitor | ch0 RX pkt #225: addr=0 len=1 parity=good |
| 37335 | scoreboard | ch0 pkt matched: addr=0 len=1 (225 matched so far) |
| 37515 | **DUT** | IN  pkt #226 header: addr=0 len=1 -> channel 0 |
| 37525 | **DUT** | OUT ch0 pkt #226 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37535 | **DUT** | IN  pkt #226 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37535 | yapp monitor | RX pkt #226 on the input: addr=0 len=1 parity=good gap=18 |
| 37535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37540 | yapp driver | TX pkt #226 accepted by the DUT |
| 37540 | yapp driver | TX pkt #227: addr=0 len=1 parity=good delay=18 |
| 37545 | **DUT** | OUT ch0 pkt #226 done: 3 bytes in 3 cycles |
| 37545 | ch0 monitor | ch0 RX pkt #226: addr=0 len=1 parity=good |
| 37545 | scoreboard | ch0 pkt matched: addr=0 len=1 (226 matched so far) |
| 37725 | **DUT** | IN  pkt #227 header: addr=0 len=1 -> channel 0 |
| 37735 | **DUT** | OUT ch0 pkt #227 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37745 | **DUT** | IN  pkt #227 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37745 | yapp monitor | RX pkt #227 on the input: addr=0 len=1 parity=good gap=18 |
| 37745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37750 | yapp driver | TX pkt #227 accepted by the DUT |
| 37750 | yapp driver | TX pkt #228: addr=0 len=1 parity=good delay=16 |
| 37755 | **DUT** | OUT ch0 pkt #227 done: 3 bytes in 3 cycles |
| 37755 | ch0 monitor | ch0 RX pkt #227: addr=0 len=1 parity=good |
| 37755 | scoreboard | ch0 pkt matched: addr=0 len=1 (227 matched so far) |
| 37880 | ch0 driver | ch0: packet consumed (response delay 5) |
| 37915 | **DUT** | IN  pkt #228 header: addr=0 len=1 -> channel 0 |
| 37935 | **DUT** | IN  pkt #228 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37935 | yapp monitor | RX pkt #228 on the input: addr=0 len=1 parity=good gap=16 |
| 37935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37940 | yapp driver | TX pkt #228 accepted by the DUT |
| 37940 | yapp driver | TX pkt #229: addr=0 len=1 parity=good delay=1 |
| 37955 | **DUT** | IN  pkt #229 header: addr=0 len=1 -> channel 0 |
| 37975 | **DUT** | IN  pkt #229 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37975 | yapp monitor | RX pkt #229 on the input: addr=0 len=1 parity=good gap=1 |
| 37975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37980 | yapp driver | TX pkt #229 accepted by the DUT |
| 37980 | yapp driver | TX pkt #230: addr=0 len=1 parity=good delay=7 |
| 38015 | **DUT** | OUT ch0 pkt #228 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 38030 | ch0 driver | ch0: packet consumed (response delay 9) |
| 38055 | **DUT** | IN  pkt #230 header: addr=0 len=1 -> channel 0 |
| 38075 | **DUT** | IN  pkt #230 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38075 | yapp monitor | RX pkt #230 on the input: addr=0 len=1 parity=good gap=7 |
| 38075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38080 | yapp driver | TX pkt #230 accepted by the DUT |
| 38080 | yapp driver | TX pkt #231: addr=0 len=1 parity=good delay=6 |
| 38145 | **DUT** | IN  pkt #231 header: addr=0 len=1 -> channel 0 |
| 38145 | **DUT** | OUT ch0 pkt #228 done: 3 bytes in 14 cycles |
| 38145 | ch0 monitor | ch0 RX pkt #228: addr=0 len=1 parity=good |
| 38145 | scoreboard | ch0 pkt matched: addr=0 len=1 (228 matched so far) |
| 38155 | **DUT** | OUT ch0 pkt #229 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38165 | **DUT** | IN  pkt #231 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38165 | yapp monitor | RX pkt #231 on the input: addr=0 len=1 parity=good gap=6 |
| 38165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38170 | yapp driver | TX pkt #231 accepted by the DUT |
| 38170 | yapp driver | TX pkt #232: addr=0 len=1 parity=good delay=17 |
| 38175 | **DUT** | OUT ch0 pkt #229 done: 3 bytes in 3 cycles |
| 38175 | ch0 monitor | ch0 RX pkt #229: addr=0 len=1 parity=good |
| 38175 | scoreboard | ch0 pkt matched: addr=0 len=1 (229 matched so far) |
| 38185 | **DUT** | OUT ch0 pkt #230 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38205 | **DUT** | OUT ch0 pkt #230 done: 3 bytes in 3 cycles |
| 38205 | ch0 monitor | ch0 RX pkt #230: addr=0 len=1 parity=good |
| 38205 | scoreboard | ch0 pkt matched: addr=0 len=1 (230 matched so far) |
| 38215 | **DUT** | OUT ch0 pkt #231 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38235 | **DUT** | OUT ch0 pkt #231 done: 3 bytes in 3 cycles |
| 38235 | ch0 monitor | ch0 RX pkt #231: addr=0 len=1 parity=good |
| 38235 | scoreboard | ch0 pkt matched: addr=0 len=1 (231 matched so far) |
| 38345 | **DUT** | IN  pkt #232 header: addr=0 len=1 -> channel 0 |
| 38355 | **DUT** | OUT ch0 pkt #232 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38365 | **DUT** | IN  pkt #232 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38365 | yapp monitor | RX pkt #232 on the input: addr=0 len=1 parity=good gap=17 |
| 38365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38370 | yapp driver | TX pkt #232 accepted by the DUT |
| 38370 | yapp driver | TX pkt #233: addr=0 len=1 parity=good delay=16 |
| 38375 | **DUT** | OUT ch0 pkt #232 done: 3 bytes in 3 cycles |
| 38375 | ch0 monitor | ch0 RX pkt #232: addr=0 len=1 parity=good |
| 38375 | scoreboard | ch0 pkt matched: addr=0 len=1 (232 matched so far) |
| 38535 | **DUT** | IN  pkt #233 header: addr=0 len=1 -> channel 0 |
| 38545 | **DUT** | OUT ch0 pkt #233 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38555 | **DUT** | IN  pkt #233 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38555 | yapp monitor | RX pkt #233 on the input: addr=0 len=1 parity=good gap=16 |
| 38555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38560 | yapp driver | TX pkt #233 accepted by the DUT |
| 38560 | yapp driver | TX pkt #234: addr=0 len=1 parity=good delay=19 |
| 38565 | **DUT** | OUT ch0 pkt #233 done: 3 bytes in 3 cycles |
| 38565 | ch0 monitor | ch0 RX pkt #233: addr=0 len=1 parity=good |
| 38565 | scoreboard | ch0 pkt matched: addr=0 len=1 (233 matched so far) |
| 38630 | ch0 driver | ch0: packet consumed (response delay 10) |
| 38755 | **DUT** | IN  pkt #234 header: addr=0 len=1 -> channel 0 |
| 38775 | **DUT** | IN  pkt #234 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38775 | yapp monitor | RX pkt #234 on the input: addr=0 len=1 parity=good gap=19 |
| 38775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38780 | yapp driver | TX pkt #234 accepted by the DUT |
| 38780 | yapp driver | TX pkt #235: addr=0 len=1 parity=good delay=16 |
| 38835 | **DUT** | OUT ch0 pkt #234 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 38850 | ch0 driver | ch0: packet consumed (response delay 7) |
| 38865 | **DUT** | OUT ch0 pkt #234 done: 3 bytes in 4 cycles |
| 38865 | ch0 monitor | ch0 RX pkt #234: addr=0 len=1 parity=good |
| 38865 | scoreboard | ch0 pkt matched: addr=0 len=1 (234 matched so far) |
| 38945 | **DUT** | IN  pkt #235 header: addr=0 len=1 -> channel 0 |
| 38955 | **DUT** | OUT ch0 pkt #235 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38965 | **DUT** | IN  pkt #235 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38965 | yapp monitor | RX pkt #235 on the input: addr=0 len=1 parity=good gap=16 |
| 38965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38970 | yapp driver | TX pkt #235 accepted by the DUT |
| 38970 | yapp driver | TX pkt #236: addr=0 len=1 parity=good delay=15 |
| 38975 | **DUT** | OUT ch0 pkt #235 done: 3 bytes in 3 cycles |
| 38975 | ch0 monitor | ch0 RX pkt #235: addr=0 len=1 parity=good |
| 38975 | scoreboard | ch0 pkt matched: addr=0 len=1 (235 matched so far) |
| 39125 | **DUT** | IN  pkt #236 header: addr=0 len=1 -> channel 0 |
| 39135 | **DUT** | OUT ch0 pkt #236 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39145 | **DUT** | IN  pkt #236 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39145 | yapp monitor | RX pkt #236 on the input: addr=0 len=1 parity=good gap=15 |
| 39145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39150 | yapp driver | TX pkt #236 accepted by the DUT |
| 39150 | yapp driver | TX pkt #237: addr=0 len=1 parity=good delay=18 |
| 39155 | **DUT** | OUT ch0 pkt #236 done: 3 bytes in 3 cycles |
| 39155 | ch0 monitor | ch0 RX pkt #236: addr=0 len=1 parity=good |
| 39155 | scoreboard | ch0 pkt matched: addr=0 len=1 (236 matched so far) |
| 39335 | **DUT** | IN  pkt #237 header: addr=0 len=1 -> channel 0 |
| 39340 | ch0 driver | ch0: packet consumed (response delay 0) |
| 39355 | **DUT** | IN  pkt #237 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39355 | yapp monitor | RX pkt #237 on the input: addr=0 len=1 parity=good gap=18 |
| 39355 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39360 | yapp driver | TX pkt #237 accepted by the DUT |
| 39360 | yapp driver | TX pkt #238: addr=0 len=1 parity=good delay=11 |
| 39445 | **DUT** | OUT ch0 pkt #237 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 39460 | ch0 driver | ch0: packet consumed (response delay 9) |
| 39475 | **DUT** | IN  pkt #238 header: addr=0 len=1 -> channel 0 |
| 39495 | **DUT** | IN  pkt #238 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39495 | yapp monitor | RX pkt #238 on the input: addr=0 len=1 parity=good gap=11 |
| 39495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39500 | yapp driver | TX pkt #238 accepted by the DUT |
| 39500 | yapp driver | TX pkt #239: addr=0 len=1 parity=good delay=3 |
| 39535 | **DUT** | IN  pkt #239 header: addr=0 len=1 -> channel 0 |
| 39555 | **DUT** | IN  pkt #239 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39555 | yapp monitor | RX pkt #239 on the input: addr=0 len=1 parity=good gap=3 |
| 39555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39560 | yapp driver | TX pkt #239 accepted by the DUT |
| 39560 | yapp driver | TX pkt #240: addr=0 len=1 parity=good delay=14 |
| 39565 | **DUT** | OUT ch0 pkt #237 done: 3 bytes in 13 cycles |
| 39565 | ch0 monitor | ch0 RX pkt #237: addr=0 len=1 parity=good |
| 39565 | scoreboard | ch0 pkt matched: addr=0 len=1 (237 matched so far) |
| 39575 | **DUT** | OUT ch0 pkt #238 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39595 | **DUT** | OUT ch0 pkt #238 done: 3 bytes in 3 cycles |
| 39595 | ch0 monitor | ch0 RX pkt #238: addr=0 len=1 parity=good |
| 39595 | scoreboard | ch0 pkt matched: addr=0 len=1 (238 matched so far) |
| 39605 | **DUT** | OUT ch0 pkt #239 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39625 | **DUT** | OUT ch0 pkt #239 done: 3 bytes in 3 cycles |
| 39625 | ch0 monitor | ch0 RX pkt #239: addr=0 len=1 parity=good |
| 39625 | scoreboard | ch0 pkt matched: addr=0 len=1 (239 matched so far) |
| 39705 | **DUT** | IN  pkt #240 header: addr=0 len=1 -> channel 0 |
| 39710 | ch0 driver | ch0: packet consumed (response delay 9) |
| 39725 | **DUT** | IN  pkt #240 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39725 | yapp monitor | RX pkt #240 on the input: addr=0 len=1 parity=good gap=14 |
| 39725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39730 | yapp driver | TX pkt #240 accepted by the DUT |
| 39730 | yapp driver | TX pkt #241: addr=0 len=1 parity=good delay=10 |
| 39815 | **DUT** | OUT ch0 pkt #240 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 39830 | ch0 driver | ch0: packet consumed (response delay 9) |
| 39835 | **DUT** | IN  pkt #241 header: addr=0 len=1 -> channel 0 |
| 39855 | **DUT** | IN  pkt #241 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39855 | yapp monitor | RX pkt #241 on the input: addr=0 len=1 parity=good gap=10 |
| 39855 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39860 | yapp driver | TX pkt #241 accepted by the DUT |
| 39860 | yapp driver | TX pkt #242: addr=0 len=1 parity=good delay=18 |
| 39925 | **DUT** | OUT ch0 pkt #240 done: 3 bytes in 12 cycles |
| 39925 | ch0 monitor | ch0 RX pkt #240: addr=0 len=1 parity=good |
| 39925 | scoreboard | ch0 pkt matched: addr=0 len=1 (240 matched so far) |
| 39935 | **DUT** | OUT ch0 pkt #241 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39955 | **DUT** | OUT ch0 pkt #241 done: 3 bytes in 3 cycles |
| 39955 | ch0 monitor | ch0 RX pkt #241: addr=0 len=1 parity=good |
| 39955 | scoreboard | ch0 pkt matched: addr=0 len=1 (241 matched so far) |
| 40045 | **DUT** | IN  pkt #242 header: addr=0 len=1 -> channel 0 |
| 40055 | **DUT** | OUT ch0 pkt #242 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40065 | **DUT** | IN  pkt #242 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40065 | yapp monitor | RX pkt #242 on the input: addr=0 len=1 parity=good gap=18 |
| 40065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40070 | yapp driver | TX pkt #242 accepted by the DUT |
| 40070 | yapp driver | TX pkt #243: addr=0 len=1 parity=good delay=16 |
| 40075 | **DUT** | OUT ch0 pkt #242 done: 3 bytes in 3 cycles |
| 40075 | ch0 monitor | ch0 RX pkt #242: addr=0 len=1 parity=good |
| 40075 | scoreboard | ch0 pkt matched: addr=0 len=1 (242 matched so far) |
| 40235 | **DUT** | IN  pkt #243 header: addr=0 len=1 -> channel 0 |
| 40240 | ch0 driver | ch0: packet consumed (response delay 8) |
| 40255 | **DUT** | IN  pkt #243 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40255 | yapp monitor | RX pkt #243 on the input: addr=0 len=1 parity=good gap=16 |
| 40255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40260 | yapp driver | TX pkt #243 accepted by the DUT |
| 40260 | yapp driver | TX pkt #244: addr=0 len=1 parity=good delay=15 |
| 40355 | **DUT** | OUT ch0 pkt #243 start: addr=0 len=1 (receiver waited 11 cycle(s)) |
| 40370 | ch0 driver | ch0: packet consumed (response delay 10) |
| 40415 | **DUT** | IN  pkt #244 header: addr=0 len=1 -> channel 0 |
| 40435 | **DUT** | IN  pkt #244 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40435 | yapp monitor | RX pkt #244 on the input: addr=0 len=1 parity=good gap=15 |
| 40435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40440 | yapp driver | TX pkt #244 accepted by the DUT |
| 40440 | yapp driver | TX pkt #245: addr=0 len=1 parity=good delay=9 |
| 40455 | **DUT** | OUT ch0 pkt #243 done: 3 bytes in 11 cycles |
| 40455 | ch0 monitor | ch0 RX pkt #243: addr=0 len=1 parity=good |
| 40455 | scoreboard | ch0 pkt matched: addr=0 len=1 (243 matched so far) |
| 40465 | **DUT** | OUT ch0 pkt #244 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40485 | **DUT** | OUT ch0 pkt #244 done: 3 bytes in 3 cycles |
| 40485 | ch0 monitor | ch0 RX pkt #244: addr=0 len=1 parity=good |
| 40485 | scoreboard | ch0 pkt matched: addr=0 len=1 (244 matched so far) |
| 40535 | **DUT** | IN  pkt #245 header: addr=0 len=1 -> channel 0 |
| 40545 | **DUT** | OUT ch0 pkt #245 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40555 | **DUT** | IN  pkt #245 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40555 | yapp monitor | RX pkt #245 on the input: addr=0 len=1 parity=good gap=9 |
| 40555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40560 | yapp driver | TX pkt #245 accepted by the DUT |
| 40560 | yapp driver | TX pkt #246: addr=0 len=1 parity=good delay=3 |
| 40565 | **DUT** | OUT ch0 pkt #245 done: 3 bytes in 3 cycles |
| 40565 | ch0 monitor | ch0 RX pkt #245: addr=0 len=1 parity=good |
| 40565 | scoreboard | ch0 pkt matched: addr=0 len=1 (245 matched so far) |
| 40595 | **DUT** | IN  pkt #246 header: addr=0 len=1 -> channel 0 |
| 40605 | **DUT** | OUT ch0 pkt #246 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40615 | **DUT** | IN  pkt #246 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40615 | yapp monitor | RX pkt #246 on the input: addr=0 len=1 parity=good gap=3 |
| 40615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40620 | yapp driver | TX pkt #246 accepted by the DUT |
| 40620 | yapp driver | TX pkt #247: addr=0 len=1 parity=good delay=19 |
| 40625 | **DUT** | OUT ch0 pkt #246 done: 3 bytes in 3 cycles |
| 40625 | ch0 monitor | ch0 RX pkt #246: addr=0 len=1 parity=good |
| 40625 | scoreboard | ch0 pkt matched: addr=0 len=1 (246 matched so far) |
| 40815 | **DUT** | IN  pkt #247 header: addr=0 len=1 -> channel 0 |
| 40825 | **DUT** | OUT ch0 pkt #247 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40830 | ch0 driver | ch0: packet consumed (response delay 7) |
| 40835 | **DUT** | IN  pkt #247 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40835 | yapp monitor | RX pkt #247 on the input: addr=0 len=1 parity=good gap=19 |
| 40835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40840 | yapp driver | TX pkt #247 accepted by the DUT |
| 40840 | yapp driver | TX pkt #248: addr=0 len=1 parity=good delay=17 |
| 40935 | **DUT** | OUT ch0 pkt #247 done: 3 bytes in 12 cycles |
| 40935 | ch0 monitor | ch0 RX pkt #247: addr=0 len=1 parity=good |
| 40935 | scoreboard | ch0 pkt matched: addr=0 len=1 (247 matched so far) |
| 41015 | **DUT** | IN  pkt #248 header: addr=0 len=1 -> channel 0 |
| 41025 | **DUT** | OUT ch0 pkt #248 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41035 | **DUT** | IN  pkt #248 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41035 | yapp monitor | RX pkt #248 on the input: addr=0 len=1 parity=good gap=17 |
| 41035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41040 | yapp driver | TX pkt #248 accepted by the DUT |
| 41040 | yapp driver | TX pkt #249: addr=0 len=1 parity=good delay=13 |
| 41045 | **DUT** | OUT ch0 pkt #248 done: 3 bytes in 3 cycles |
| 41045 | ch0 monitor | ch0 RX pkt #248: addr=0 len=1 parity=good |
| 41045 | scoreboard | ch0 pkt matched: addr=0 len=1 (248 matched so far) |
| 41175 | **DUT** | IN  pkt #249 header: addr=0 len=1 -> channel 0 |
| 41185 | **DUT** | OUT ch0 pkt #249 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41195 | **DUT** | IN  pkt #249 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41195 | yapp monitor | RX pkt #249 on the input: addr=0 len=1 parity=good gap=13 |
| 41195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41200 | yapp driver | TX pkt #249 accepted by the DUT |
| 41200 | yapp driver | TX pkt #250: addr=0 len=1 parity=good delay=18 |
| 41205 | **DUT** | OUT ch0 pkt #249 done: 3 bytes in 3 cycles |
| 41205 | ch0 monitor | ch0 RX pkt #249: addr=0 len=1 parity=good |
| 41205 | scoreboard | ch0 pkt matched: addr=0 len=1 (249 matched so far) |
| 41220 | ch0 driver | ch0: packet consumed (response delay 8) |
| 41385 | **DUT** | IN  pkt #250 header: addr=0 len=1 -> channel 0 |
| 41405 | **DUT** | IN  pkt #250 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41405 | yapp monitor | RX pkt #250 on the input: addr=0 len=1 parity=good gap=18 |
| 41405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41410 | yapp driver | TX pkt #250 accepted by the DUT |
| 41410 | yapp driver | TX pkt #251: addr=0 len=1 parity=good delay=18 |
| 41495 | **DUT** | OUT ch0 pkt #250 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 41510 | ch0 driver | ch0: packet consumed (response delay 10) |
| 41595 | **DUT** | IN  pkt #251 header: addr=0 len=1 -> channel 0 |
| 41615 | **DUT** | IN  pkt #251 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41615 | **DUT** | OUT ch0 pkt #250 done: 3 bytes in 13 cycles |
| 41615 | ch0 monitor | ch0 RX pkt #250: addr=0 len=1 parity=good |
| 41615 | scoreboard | ch0 pkt matched: addr=0 len=1 (250 matched so far) |
| 41615 | yapp monitor | RX pkt #251 on the input: addr=0 len=1 parity=good gap=18 |
| 41615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41620 | yapp driver | TX pkt #251 accepted by the DUT |
| 41620 | yapp driver | TX pkt #252: addr=0 len=1 parity=good delay=17 |
| 41625 | **DUT** | OUT ch0 pkt #251 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41645 | **DUT** | OUT ch0 pkt #251 done: 3 bytes in 3 cycles |
| 41645 | ch0 monitor | ch0 RX pkt #251: addr=0 len=1 parity=good |
| 41645 | scoreboard | ch0 pkt matched: addr=0 len=1 (251 matched so far) |
| 41795 | **DUT** | IN  pkt #252 header: addr=0 len=1 -> channel 0 |
| 41805 | **DUT** | OUT ch0 pkt #252 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 41815 | **DUT** | IN  pkt #252 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 41815 | yapp monitor | RX pkt #252 on the input: addr=0 len=1 parity=good gap=17 |
| 41815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 41820 | yapp driver | TX pkt #252 accepted by the DUT |
| 41820 | yapp driver | TX pkt #253: addr=0 len=1 parity=good delay=16 |
| 41825 | **DUT** | OUT ch0 pkt #252 done: 3 bytes in 3 cycles |
| 41825 | ch0 monitor | ch0 RX pkt #252: addr=0 len=1 parity=good |
| 41825 | scoreboard | ch0 pkt matched: addr=0 len=1 (252 matched so far) |
| 41985 | **DUT** | IN  pkt #253 header: addr=0 len=1 -> channel 0 |
| 41995 | **DUT** | OUT ch0 pkt #253 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 42005 | **DUT** | IN  pkt #253 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 42005 | yapp monitor | RX pkt #253 on the input: addr=0 len=1 parity=good gap=16 |
| 42005 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 42010 | yapp driver | TX pkt #253 accepted by the DUT |
| 42010 | yapp driver | TX pkt #254: addr=0 len=1 parity=good delay=8 |
| 42015 | **DUT** | OUT ch0 pkt #253 done: 3 bytes in 3 cycles |
| 42015 | ch0 monitor | ch0 RX pkt #253: addr=0 len=1 parity=good |
| 42015 | scoreboard | ch0 pkt matched: addr=0 len=1 (253 matched so far) |
| 42095 | **DUT** | IN  pkt #254 header: addr=0 len=1 -> channel 0 |
| 42105 | **DUT** | OUT ch0 pkt #254 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 42115 | **DUT** | IN  pkt #254 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 42115 | yapp monitor | RX pkt #254 on the input: addr=0 len=1 parity=good gap=8 |
| 42115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 42120 | yapp driver | TX pkt #254 accepted by the DUT |
| 42120 | yapp driver | TX pkt #255: addr=0 len=1 parity=good delay=3 |
| 42125 | **DUT** | OUT ch0 pkt #254 done: 3 bytes in 3 cycles |
| 42125 | ch0 monitor | ch0 RX pkt #254: addr=0 len=1 parity=good |
| 42125 | scoreboard | ch0 pkt matched: addr=0 len=1 (254 matched so far) |
| 42130 | ch0 driver | ch0: packet consumed (response delay 9) |
| 42155 | **DUT** | IN  pkt #255 header: addr=0 len=1 -> channel 0 |
| 42175 | **DUT** | IN  pkt #255 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 42175 | yapp monitor | RX pkt #255 on the input: addr=0 len=1 parity=good gap=3 |
| 42175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 42180 | yapp driver | TX pkt #255 accepted by the DUT |
| 42255 | **DUT** | OUT ch0 pkt #255 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 42270 | ch0 driver | ch0: packet consumed (response delay 9) |
| 42285 | **DUT** | OUT ch0 pkt #255 done: 3 bytes in 4 cycles |
| 42285 | ch0 monitor | ch0 RX pkt #255: addr=0 len=1 parity=good |
| 42285 | scoreboard | ch0 pkt matched: addr=0 len=1 (255 matched so far) |
| 42310 | hbus driver | Executed READ  addr=0x1009 data=0xff |
| 42310 | **test** | addr0_cnt_reg reads 255 as expected |
| 42310 | **test** | STAGE: 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 42310 | yapp driver | TX pkt #256: addr=0 len=1 parity=good delay=10 |
| 42315 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 42380 | ch0 driver | ch0: packet consumed (response delay 0) |
| 42425 | **DUT** | IN  pkt #256 header: addr=0 len=1 -> channel 0 |
| 42445 | **DUT** | IN  pkt #256 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 42445 | yapp monitor | RX pkt #256 on the input: addr=0 len=1 parity=good gap=24 |
| 42445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 42450 | yapp driver | TX pkt #256 accepted by the DUT |
| 42485 | **DUT** | OUT ch0 pkt #256 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 42500 | ch0 driver | ch0: packet consumed (response delay 5) |
| 42555 | **DUT** | OUT ch0 pkt #256 done: 3 bytes in 8 cycles |
| 42555 | ch0 monitor | ch0 RX pkt #256: addr=0 len=1 parity=good |
| 42555 | scoreboard | ch0 pkt matched: addr=0 len=1 (256 matched so far) |
| 42580 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 42580 | **test** | addr0_cnt_reg reads 0 as expected |
| 42580 | **test** | STAGE: 3. one more packet: the counter goes on from 0 |
| 42580 | yapp driver | TX pkt #257: addr=0 len=1 parity=good delay=12 |
| 42585 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 42715 | **DUT** | IN  pkt #257 header: addr=0 len=1 -> channel 0 |
| 42725 | **DUT** | OUT ch0 pkt #257 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 42735 | **DUT** | IN  pkt #257 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 42735 | yapp monitor | RX pkt #257 on the input: addr=0 len=1 parity=good gap=26 |
| 42735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 42740 | yapp driver | TX pkt #257 accepted by the DUT |
| 42745 | **DUT** | OUT ch0 pkt #257 done: 3 bytes in 3 cycles |
| 42745 | ch0 monitor | ch0 RX pkt #257: addr=0 len=1 parity=good |
| 42745 | scoreboard | ch0 pkt matched: addr=0 len=1 (257 matched so far) |
| 42770 | hbus driver | Executed READ  addr=0x1009 data=0x01 |
| 42770 | **test** | addr0_cnt_reg reads 1 as expected |
| 42770 | **test** | STAGE: 4. the other counters are untouched and the scoreboard matched all 257 packets |
| 42775 | hbus monitor | Collected READ  addr=0x1009 data=0x01 |
| 42800 | ch0 driver | ch0: packet consumed (response delay 4) |
| 42800 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 42800 | **test** | addr1_cnt_reg reads 0 as expected |
| 42805 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42830 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 42830 | **test** | addr2_cnt_reg reads 0 as expected |
| 42835 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42860 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 42860 | **test** | addr3_cnt_reg reads 0 as expected |
| 42865 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42890 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 42890 | **test** | parity_err_cnt_reg reads 0 as expected |
| 42895 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42920 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 42920 | **test** | oversized_pkt_cnt_reg reads 0 as expected |
| 42925 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43120 | ch0 monitor | Channel 0 report: 257 packets collected |
| 43120 | ch1 monitor | Channel 1 report: 0 packets collected |
| 43120 | ch2 monitor | Channel 2 report: 0 packets collected |
| 43120 | hbus monitor | HBUS report: 1 writes, 8 reads |
| 43120 | reference |  |
| 43120 | scoreboard |  |
| 43120 | yapp driver | YAPP driver report: 257 packets sent |
| 43120 | yapp monitor | YAPP monitor report: 257 packets collected, coverage 13.3% |
| 43120 | yapp monitor | YAPP gaps: 0 back to back, 15 of 1 cycle, 5 of 2, 236 longer (gap coverage 75.0%) |
