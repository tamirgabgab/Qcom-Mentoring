# router_filter_test  seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 12us · log `router_filter_test_s1.log`

Waves: `router_filter_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frouter_filter_test_s1%2Frouter_filter_test_s1.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **32** packet(s) (0 with bad parity); the input monitor saw 32.
- Router: **12** forwarded, **20** dropped (16 oversized, 4 illegal address 3).
- Packets out: ch0 **4**, ch1 **4**, ch2 **4**.
- Scoreboard: 12 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 4 write(s), 11 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | ctrl_reg=10: maxpktsize is 10 for the boundary sequence |
| 70 | 1. en_reg=0xff: lengths 9/10/11/63 to every address, drops counted |
| 6150 | 2. en_reg=0x01: the same traffic, the same drops, the counters do not move |
| 11910 | ctrl_reg back to 0x3f |

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

340 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: ctrl_reg=10: maxpktsize is 10 for the boundary sequence |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x0a |
| 70 | **test** | STAGE: 1. en_reg=0xff: lengths 9/10/11/63 to every address, drops counted |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=10 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x0a |
| 75 | reference | maxpktsize is now 10 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 90 | yapp driver | TX pkt #1: addr=0 len=9 parity=good delay=11 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 215 | **DUT** | IN  pkt #1 header: addr=0 len=9 -> channel 0 |
| 255 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=9 (receiver waited 3 cycle(s)) |
| 315 | **DUT** | IN  pkt #1 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 315 | yapp monitor | RX pkt #1 on the input: addr=0 len=9 parity=good gap=16 |
| 315 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 320 | yapp driver | TX pkt #1 accepted by the DUT |
| 320 | yapp driver | TX pkt #2: addr=0 len=10 parity=good delay=9 |
| 350 | ch0 driver | ch0: packet consumed (response delay 3) |
| 415 | **DUT** | IN  pkt #2 header: addr=0 len=10 -> channel 0 |
| 445 | **DUT** | OUT ch0 pkt #1 done: 11 bytes in 20 cycles |
| 445 | ch0 monitor | ch0 RX pkt #1: addr=0 len=9 parity=good |
| 445 | scoreboard | ch0 pkt matched: addr=0 len=9 (1 matched so far) |
| 455 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=10 (receiver waited 0 cycle(s)) |
| 525 | **DUT** | IN  pkt #2 complete: addr=0 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 525 | yapp monitor | RX pkt #2 on the input: addr=0 len=10 parity=good gap=9 |
| 525 | reference | Packet forwarded: addr=0 len=10 -> channel 0 |
| 530 | yapp driver | TX pkt #2 accepted by the DUT |
| 530 | yapp driver | TX pkt #3: addr=0 len=11 parity=good delay=19 |
| 565 | **DUT** | OUT ch0 pkt #2 done: 12 bytes in 12 cycles |
| 565 | ch0 monitor | ch0 RX pkt #2: addr=0 len=10 parity=good |
| 565 | scoreboard | ch0 pkt matched: addr=0 len=10 (2 matched so far) |
| 725 | **DUT** | IN  pkt #3 header: addr=0 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 770 | ch0 driver | ch0: packet consumed (response delay 8) |
| 845 | **DUT** | IN  pkt #3 complete: addr=0 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 845 | yapp monitor | RX pkt #3 on the input: addr=0 len=11 parity=good gap=19 |
| 845 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=0) |
| 845 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (length > maxpktsize) |
| 850 | yapp driver | TX pkt #3 accepted by the DUT |
| 850 | yapp driver | TX pkt #4: addr=0 len=63 parity=good delay=19 |
| 1045 | **DUT** | IN  pkt #4 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 1685 | **DUT** | IN  pkt #4 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1685 | yapp monitor | RX pkt #4 on the input: addr=0 len=63 parity=good gap=19 |
| 1685 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=0) |
| 1685 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 1690 | yapp driver | TX pkt #4 accepted by the DUT |
| 1690 | yapp driver | TX pkt #5: addr=1 len=9 parity=good delay=20 |
| 1895 | **DUT** | IN  pkt #5 header: addr=1 len=9 -> channel 1 |
| 1985 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=9 (receiver waited 8 cycle(s)) |
| 1995 | **DUT** | IN  pkt #5 complete: addr=1 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 1995 | yapp monitor | RX pkt #5 on the input: addr=1 len=9 parity=good gap=20 |
| 1995 | reference | Packet forwarded: addr=1 len=9 -> channel 1 |
| 2000 | yapp driver | TX pkt #5 accepted by the DUT |
| 2000 | yapp driver | TX pkt #6: addr=1 len=10 parity=good delay=1 |
| 2015 | **DUT** | IN  pkt #6 header: addr=1 len=10 -> channel 1 |
| 2080 | ch1 driver | ch1: packet consumed (response delay 8) |
| 2095 | **DUT** | OUT ch1 pkt #1 done: 11 bytes in 12 cycles |
| 2095 | ch1 monitor | ch1 RX pkt #1: addr=1 len=9 parity=good |
| 2095 | scoreboard | ch1 pkt matched: addr=1 len=9 (3 matched so far) |
| 2105 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=10 (receiver waited 0 cycle(s)) |
| 2125 | **DUT** | IN  pkt #6 complete: addr=1 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 2125 | yapp monitor | RX pkt #6 on the input: addr=1 len=10 parity=good gap=1 |
| 2125 | reference | Packet forwarded: addr=1 len=10 -> channel 1 |
| 2130 | yapp driver | TX pkt #6 accepted by the DUT |
| 2130 | yapp driver | TX pkt #7: addr=1 len=11 parity=good delay=3 |
| 2165 | **DUT** | IN  pkt #7 header: addr=1 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 2215 | **DUT** | OUT ch1 pkt #2 done: 12 bytes in 12 cycles |
| 2215 | ch1 monitor | ch1 RX pkt #2: addr=1 len=10 parity=good |
| 2215 | scoreboard | ch1 pkt matched: addr=1 len=10 (4 matched so far) |
| 2285 | **DUT** | IN  pkt #7 complete: addr=1 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 2285 | yapp monitor | RX pkt #7 on the input: addr=1 len=11 parity=good gap=3 |
| 2285 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=1) |
| 2285 | **DUT** | ROUTER DROPS PACKET addr=1 length=11 (length > maxpktsize) |
| 2290 | yapp driver | TX pkt #7 accepted by the DUT |
| 2290 | yapp driver | TX pkt #8: addr=1 len=63 parity=good delay=5 |
| 2345 | **DUT** | IN  pkt #8 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 2690 | ch1 driver | ch1: packet consumed (response delay 0) |
| 2985 | **DUT** | IN  pkt #8 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2985 | yapp monitor | RX pkt #8 on the input: addr=1 len=63 parity=good gap=5 |
| 2985 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=1) |
| 2985 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 2990 | yapp driver | TX pkt #8 accepted by the DUT |
| 2990 | yapp driver | TX pkt #9: addr=2 len=9 parity=good delay=18 |
| 3175 | **DUT** | IN  pkt #9 header: addr=2 len=9 -> channel 2 |
| 3265 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=9 (receiver waited 8 cycle(s)) |
| 3275 | **DUT** | IN  pkt #9 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 3275 | yapp monitor | RX pkt #9 on the input: addr=2 len=9 parity=good gap=18 |
| 3275 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 3280 | yapp driver | TX pkt #9 accepted by the DUT |
| 3280 | yapp driver | TX pkt #10: addr=2 len=10 parity=good delay=5 |
| 3335 | **DUT** | IN  pkt #10 header: addr=2 len=10 -> channel 2 |
| 3360 | ch2 driver | ch2: packet consumed (response delay 8) |
| 3445 | **DUT** | IN  pkt #10 complete: addr=2 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 3445 | yapp monitor | RX pkt #10 on the input: addr=2 len=10 parity=good gap=5 |
| 3445 | reference | Packet forwarded: addr=2 len=10 -> channel 2 |
| 3450 | yapp driver | TX pkt #10 accepted by the DUT |
| 3450 | yapp driver | TX pkt #11: addr=2 len=11 parity=good delay=18 |
| 3455 | **DUT** | OUT ch2 pkt #1 done: 11 bytes in 20 cycles |
| 3455 | ch2 monitor | ch2 RX pkt #1: addr=2 len=9 parity=good |
| 3455 | scoreboard | ch2 pkt matched: addr=2 len=9 (5 matched so far) |
| 3465 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=10 (receiver waited 0 cycle(s)) |
| 3575 | **DUT** | OUT ch2 pkt #2 done: 12 bytes in 12 cycles |
| 3575 | ch2 monitor | ch2 RX pkt #2: addr=2 len=10 parity=good |
| 3575 | scoreboard | ch2 pkt matched: addr=2 len=10 (6 matched so far) |
| 3635 | **DUT** | IN  pkt #11 header: addr=2 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 3755 | **DUT** | IN  pkt #11 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 3755 | yapp monitor | RX pkt #11 on the input: addr=2 len=11 parity=good gap=18 |
| 3755 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=2) |
| 3755 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (length > maxpktsize) |
| 3760 | yapp driver | TX pkt #11 accepted by the DUT |
| 3760 | yapp driver | TX pkt #12: addr=2 len=63 parity=good delay=14 |
| 3905 | **DUT** | IN  pkt #12 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 3920 | ch2 driver | ch2: packet consumed (response delay 8) |
| 4545 | **DUT** | IN  pkt #12 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4545 | yapp monitor | RX pkt #12 on the input: addr=2 len=63 parity=good gap=14 |
| 4545 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=2) |
| 4545 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4550 | yapp driver | TX pkt #12 accepted by the DUT |
| 4550 | yapp driver | TX pkt #13: addr=3 len=9 parity=good delay=3 |
| 4585 | **DUT** | IN  pkt #13 header: addr=3 len=9 -> DROP (illegal address 3) |
| 4685 | **DUT** | IN  pkt #13 complete: addr=3 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 4685 | yapp monitor | RX pkt #13 on the input: addr=3 len=9 parity=good gap=3 |
| 4685 | reference | Packet dropped: illegal address 3 (len=9) |
| 4685 | **DUT** | ROUTER DROPS PACKET addr=3 length=9 (    illegal address) |
| 4690 | yapp driver | TX pkt #13 accepted by the DUT |
| 4690 | yapp driver | TX pkt #14: addr=3 len=10 parity=good delay=1 |
| 4705 | **DUT** | IN  pkt #14 header: addr=3 len=10 -> DROP (illegal address 3) |
| 4815 | **DUT** | IN  pkt #14 complete: addr=3 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 4815 | yapp monitor | RX pkt #14 on the input: addr=3 len=10 parity=good gap=1 |
| 4815 | reference | Packet dropped: illegal address 3 (len=10) |
| 4815 | **DUT** | ROUTER DROPS PACKET addr=3 length=10 (    illegal address) |
| 4820 | yapp driver | TX pkt #14 accepted by the DUT |
| 4820 | yapp driver | TX pkt #15: addr=3 len=11 parity=good delay=19 |
| 5015 | **DUT** | IN  pkt #15 header: addr=3 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 5135 | **DUT** | IN  pkt #15 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 5135 | yapp monitor | RX pkt #15 on the input: addr=3 len=11 parity=good gap=19 |
| 5135 | reference | Packet dropped: illegal address 3 (len=11) |
| 5135 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (    illegal address) |
| 5140 | yapp driver | TX pkt #15 accepted by the DUT |
| 5140 | yapp driver | TX pkt #16: addr=3 len=63 parity=good delay=15 |
| 5295 | **DUT** | IN  pkt #16 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 5935 | **DUT** | IN  pkt #16 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5935 | yapp monitor | RX pkt #16 on the input: addr=3 len=63 parity=good gap=15 |
| 5935 | reference | Packet dropped: illegal address 3 (len=63) |
| 5935 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 5940 | yapp driver | TX pkt #16 accepted by the DUT |
| 6000 | hbus driver | Executed READ  addr=0x1005 data=0x08 |
| 6000 | **test** | oversized_pkt_cnt_reg reads 8 as expected |
| 6005 | hbus monitor | Collected READ  addr=0x1005 data=0x08 |
| 6030 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 6030 | **test** | addr3_cnt_reg reads 4 as expected |
| 6035 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 6060 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 6060 | **test** | addr0_cnt_reg reads 4 as expected |
| 6065 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 6090 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 6090 | **test** | addr1_cnt_reg reads 4 as expected |
| 6095 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 6120 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 6120 | **test** | addr2_cnt_reg reads 4 as expected |
| 6125 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 6150 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 6150 | **test** | parity_err_cnt_reg reads 0 as expected |
| 6150 | **test** | STAGE: 2. en_reg=0x01: the same traffic, the same drops, the counters do not move |
| 6155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6170 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 6170 | yapp driver | TX pkt #17: addr=0 len=9 parity=good delay=1 |
| 6175 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 6175 | reference | router_en is now 1 (en_reg 0x01) |
| 6195 | **DUT** | IN  pkt #17 header: addr=0 len=9 -> channel 0 |
| 6255 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=9 (receiver waited 5 cycle(s)) |
| 6295 | **DUT** | IN  pkt #17 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 6295 | yapp monitor | RX pkt #17 on the input: addr=0 len=9 parity=good gap=25 |
| 6295 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 6300 | yapp driver | TX pkt #17 accepted by the DUT |
| 6300 | yapp driver | TX pkt #18: addr=0 len=10 parity=good delay=1 |
| 6315 | **DUT** | IN  pkt #18 header: addr=0 len=10 -> channel 0 |
| 6350 | ch0 driver | ch0: packet consumed (response delay 5) |
| 6385 | **DUT** | OUT ch0 pkt #3 done: 11 bytes in 14 cycles |
| 6385 | ch0 monitor | ch0 RX pkt #3: addr=0 len=9 parity=good |
| 6385 | scoreboard | ch0 pkt matched: addr=0 len=9 (7 matched so far) |
| 6395 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=10 (receiver waited 0 cycle(s)) |
| 6425 | **DUT** | IN  pkt #18 complete: addr=0 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 6425 | yapp monitor | RX pkt #18 on the input: addr=0 len=10 parity=good gap=1 |
| 6425 | reference | Packet forwarded: addr=0 len=10 -> channel 0 |
| 6430 | yapp driver | TX pkt #18 accepted by the DUT |
| 6430 | yapp driver | TX pkt #19: addr=0 len=11 parity=good delay=1 |
| 6445 | **DUT** | IN  pkt #19 header: addr=0 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 6470 | ch0 driver | ch0: packet consumed (response delay 2) |
| 6565 | **DUT** | IN  pkt #19 complete: addr=0 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 6565 | yapp monitor | RX pkt #19 on the input: addr=0 len=11 parity=good gap=1 |
| 6565 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=0) |
| 6565 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (length > maxpktsize) |
| 6570 | yapp driver | TX pkt #19 accepted by the DUT |
| 6570 | yapp driver | TX pkt #20: addr=0 len=63 parity=good delay=2 |
| 6595 | **DUT** | IN  pkt #20 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 6605 | **DUT** | OUT ch0 pkt #4 done: 12 bytes in 22 cycles |
| 6605 | ch0 monitor | ch0 RX pkt #4: addr=0 len=10 parity=good |
| 6605 | scoreboard | ch0 pkt matched: addr=0 len=10 (8 matched so far) |
| 7210 | ch0 driver | ch0: packet consumed (response delay 9) |
| 7235 | **DUT** | IN  pkt #20 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 7235 | yapp monitor | RX pkt #20 on the input: addr=0 len=63 parity=good gap=2 |
| 7235 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=0) |
| 7235 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 7240 | yapp driver | TX pkt #20 accepted by the DUT |
| 7240 | yapp driver | TX pkt #21: addr=1 len=9 parity=good delay=16 |
| 7405 | **DUT** | IN  pkt #21 header: addr=1 len=9 -> channel 1 |
| 7475 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=9 (receiver waited 6 cycle(s)) |
| 7505 | **DUT** | IN  pkt #21 complete: addr=1 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 7505 | yapp monitor | RX pkt #21 on the input: addr=1 len=9 parity=good gap=16 |
| 7505 | reference | Packet forwarded: addr=1 len=9 -> channel 1 |
| 7510 | yapp driver | TX pkt #21 accepted by the DUT |
| 7510 | yapp driver | TX pkt #22: addr=1 len=10 parity=good delay=17 |
| 7570 | ch1 driver | ch1: packet consumed (response delay 6) |
| 7685 | **DUT** | IN  pkt #22 header: addr=1 len=10 -> channel 1 |
| 7685 | **DUT** | OUT ch1 pkt #3 done: 11 bytes in 22 cycles |
| 7685 | ch1 monitor | ch1 RX pkt #3: addr=1 len=9 parity=good |
| 7685 | scoreboard | ch1 pkt matched: addr=1 len=9 (9 matched so far) |
| 7695 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=10 (receiver waited 0 cycle(s)) |
| 7795 | **DUT** | IN  pkt #22 complete: addr=1 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 7795 | yapp monitor | RX pkt #22 on the input: addr=1 len=10 parity=good gap=17 |
| 7795 | reference | Packet forwarded: addr=1 len=10 -> channel 1 |
| 7800 | yapp driver | TX pkt #22 accepted by the DUT |
| 7800 | yapp driver | TX pkt #23: addr=1 len=11 parity=good delay=19 |
| 7805 | **DUT** | OUT ch1 pkt #4 done: 12 bytes in 12 cycles |
| 7805 | ch1 monitor | ch1 RX pkt #4: addr=1 len=10 parity=good |
| 7805 | scoreboard | ch1 pkt matched: addr=1 len=10 (10 matched so far) |
| 7995 | **DUT** | IN  pkt #23 header: addr=1 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 8115 | **DUT** | IN  pkt #23 complete: addr=1 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 8115 | yapp monitor | RX pkt #23 on the input: addr=1 len=11 parity=good gap=19 |
| 8115 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=1) |
| 8115 | **DUT** | ROUTER DROPS PACKET addr=1 length=11 (length > maxpktsize) |
| 8120 | yapp driver | TX pkt #23 accepted by the DUT |
| 8120 | yapp driver | TX pkt #24: addr=1 len=63 parity=good delay=9 |
| 8210 | ch1 driver | ch1: packet consumed (response delay 10) |
| 8215 | **DUT** | IN  pkt #24 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 8855 | **DUT** | IN  pkt #24 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8855 | yapp monitor | RX pkt #24 on the input: addr=1 len=63 parity=good gap=9 |
| 8855 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=1) |
| 8855 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 8860 | yapp driver | TX pkt #24 accepted by the DUT |
| 8860 | yapp driver | TX pkt #25: addr=2 len=9 parity=good delay=4 |
| 8905 | **DUT** | IN  pkt #25 header: addr=2 len=9 -> channel 2 |
| 9005 | **DUT** | IN  pkt #25 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 9005 | yapp monitor | RX pkt #25 on the input: addr=2 len=9 parity=good gap=4 |
| 9005 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 9010 | yapp driver | TX pkt #25 accepted by the DUT |
| 9010 | yapp driver | TX pkt #26: addr=2 len=10 parity=good delay=19 |
| 9015 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=9 (receiver waited 10 cycle(s)) |
| 9110 | ch2 driver | ch2: packet consumed (response delay 10) |
| 9185 | **DUT** | OUT ch2 pkt #3 done: 11 bytes in 18 cycles |
| 9185 | ch2 monitor | ch2 RX pkt #3: addr=2 len=9 parity=good |
| 9185 | scoreboard | ch2 pkt matched: addr=2 len=9 (11 matched so far) |
| 9205 | **DUT** | IN  pkt #26 header: addr=2 len=10 -> channel 2 |
| 9215 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=10 (receiver waited 0 cycle(s)) |
| 9315 | **DUT** | IN  pkt #26 complete: addr=2 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 9315 | yapp monitor | RX pkt #26 on the input: addr=2 len=10 parity=good gap=19 |
| 9315 | reference | Packet forwarded: addr=2 len=10 -> channel 2 |
| 9320 | yapp driver | TX pkt #26 accepted by the DUT |
| 9320 | yapp driver | TX pkt #27: addr=2 len=11 parity=good delay=7 |
| 9325 | **DUT** | OUT ch2 pkt #4 done: 12 bytes in 12 cycles |
| 9325 | ch2 monitor | ch2 RX pkt #4: addr=2 len=10 parity=good |
| 9325 | scoreboard | ch2 pkt matched: addr=2 len=10 (12 matched so far) |
| 9395 | **DUT** | IN  pkt #27 header: addr=2 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 9450 | ch2 driver | ch2: packet consumed (response delay 6) |
| 9515 | **DUT** | IN  pkt #27 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 9515 | yapp monitor | RX pkt #27 on the input: addr=2 len=11 parity=good gap=7 |
| 9515 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=2) |
| 9515 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (length > maxpktsize) |
| 9520 | yapp driver | TX pkt #27 accepted by the DUT |
| 9520 | yapp driver | TX pkt #28: addr=2 len=63 parity=good delay=3 |
| 9555 | **DUT** | IN  pkt #28 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 10195 | **DUT** | IN  pkt #28 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10195 | yapp monitor | RX pkt #28 on the input: addr=2 len=63 parity=good gap=3 |
| 10195 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=2) |
| 10195 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10200 | yapp driver | TX pkt #28 accepted by the DUT |
| 10200 | yapp driver | TX pkt #29: addr=3 len=9 parity=good delay=1 |
| 10215 | **DUT** | IN  pkt #29 header: addr=3 len=9 -> DROP (illegal address 3) |
| 10315 | **DUT** | IN  pkt #29 complete: addr=3 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 10315 | yapp monitor | RX pkt #29 on the input: addr=3 len=9 parity=good gap=1 |
| 10315 | reference | Packet dropped: illegal address 3 (len=9) |
| 10315 | **DUT** | ROUTER DROPS PACKET addr=3 length=9 (    illegal address) |
| 10320 | yapp driver | TX pkt #29 accepted by the DUT |
| 10320 | yapp driver | TX pkt #30: addr=3 len=10 parity=good delay=19 |
| 10515 | **DUT** | IN  pkt #30 header: addr=3 len=10 -> DROP (illegal address 3) |
| 10625 | **DUT** | IN  pkt #30 complete: addr=3 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 10625 | yapp monitor | RX pkt #30 on the input: addr=3 len=10 parity=good gap=19 |
| 10625 | reference | Packet dropped: illegal address 3 (len=10) |
| 10625 | **DUT** | ROUTER DROPS PACKET addr=3 length=10 (    illegal address) |
| 10630 | yapp driver | TX pkt #30 accepted by the DUT |
| 10630 | yapp driver | TX pkt #31: addr=3 len=11 parity=good delay=20 |
| 10835 | **DUT** | IN  pkt #31 header: addr=3 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 10955 | **DUT** | IN  pkt #31 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 10955 | yapp monitor | RX pkt #31 on the input: addr=3 len=11 parity=good gap=20 |
| 10955 | reference | Packet dropped: illegal address 3 (len=11) |
| 10955 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (    illegal address) |
| 10960 | yapp driver | TX pkt #31 accepted by the DUT |
| 10960 | yapp driver | TX pkt #32: addr=3 len=63 parity=good delay=12 |
| 11085 | **DUT** | IN  pkt #32 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 11725 | **DUT** | IN  pkt #32 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11725 | yapp monitor | RX pkt #32 on the input: addr=3 len=63 parity=good gap=12 |
| 11725 | reference | Packet dropped: illegal address 3 (len=63) |
| 11725 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 11730 | yapp driver | TX pkt #32 accepted by the DUT |
| 11790 | hbus driver | Executed READ  addr=0x1005 data=0x08 |
| 11790 | **test** | oversized_pkt_cnt_reg reads 8 as expected |
| 11795 | hbus monitor | Collected READ  addr=0x1005 data=0x08 |
| 11820 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 11820 | **test** | addr3_cnt_reg reads 4 as expected |
| 11825 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 11850 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 11850 | **test** | addr0_cnt_reg reads 4 as expected |
| 11855 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 11880 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 11880 | **test** | addr1_cnt_reg reads 4 as expected |
| 11885 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 11910 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 11910 | **test** | addr2_cnt_reg reads 4 as expected |
| 11910 | **test** | STAGE: ctrl_reg back to 0x3f |
| 11915 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 11930 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 11935 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 11935 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 11935 | reference | maxpktsize is now 63 |
| 12130 | ch0 monitor | Channel 0 report: 4 packets collected |
| 12130 | ch1 monitor | Channel 1 report: 4 packets collected |
| 12130 | ch2 monitor | Channel 2 report: 4 packets collected |
| 12130 | hbus monitor | HBUS report: 4 writes, 11 reads |
| 12130 | coverage | Coverage of the router configuration: 60.9% |
| 12130 | reference |  |
| 12130 | scoreboard |  |
| 12130 | yapp driver | YAPP driver report: 32 packets sent |
| 12130 | coverage | YAPP gap coverage: 31 gaps sampled, coverage 75.0% |
| 12130 | yapp monitor | YAPP monitor report: 32 packets collected, 0 with bad parity |
| 12130 | yapp monitor | YAPP gaps: 0 back to back, 5 of 1 cycle, 1 of 2, 25 longer |
| 12130 | coverage | YAPP packet coverage: 32 packets sampled, coverage 36.7% |
