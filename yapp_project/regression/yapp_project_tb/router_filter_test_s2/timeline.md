# router_filter_test seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 13us · wall 1.2 s · log [`router_filter_test_s2.log`](router_filter_test_s2.log)

Waves: `router_filter_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frouter_filter_test_s2%2Frouter_filter_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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
| 6560 | 2. en_reg=0x01: the same traffic, the same drops, the counters do not move |
| 12680 | ctrl_reg back to 0x3f |

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

344 events.

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
| 90 | yapp driver | TX pkt #1: addr=0 len=9 parity=good delay=1 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 115 | **DUT** | IN  pkt #1 header: addr=0 len=9 -> channel 0 |
| 125 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=9 (receiver waited 0 cycle(s)) |
| 215 | **DUT** | IN  pkt #1 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 215 | yapp monitor | RX pkt #1 on the input: addr=0 len=9 parity=good gap=6 |
| 215 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 220 | ch0 driver | ch0: packet consumed (response delay 0) |
| 220 | yapp driver | TX pkt #1 accepted by the DUT |
| 220 | yapp driver | TX pkt #2: addr=0 len=10 parity=good delay=17 |
| 305 | **DUT** | OUT ch0 pkt #1 done: 11 bytes in 19 cycles |
| 305 | ch0 monitor | ch0 RX pkt #1: addr=0 len=9 parity=good |
| 305 | scoreboard | ch0 pkt matched: addr=0 len=9 (1 matched so far) |
| 395 | **DUT** | IN  pkt #2 header: addr=0 len=10 -> channel 0 |
| 405 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=10 (receiver waited 0 cycle(s)) |
| 505 | **DUT** | IN  pkt #2 complete: addr=0 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 505 | yapp monitor | RX pkt #2 on the input: addr=0 len=10 parity=good gap=17 |
| 505 | reference | Packet forwarded: addr=0 len=10 -> channel 0 |
| 510 | yapp driver | TX pkt #2 accepted by the DUT |
| 510 | yapp driver | TX pkt #3: addr=0 len=11 parity=good delay=19 |
| 515 | **DUT** | OUT ch0 pkt #2 done: 12 bytes in 12 cycles |
| 515 | ch0 monitor | ch0 RX pkt #2: addr=0 len=10 parity=good |
| 515 | scoreboard | ch0 pkt matched: addr=0 len=10 (2 matched so far) |
| 630 | ch0 driver | ch0: packet consumed (response delay 7) |
| 705 | **DUT** | IN  pkt #3 header: addr=0 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 825 | **DUT** | IN  pkt #3 complete: addr=0 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 825 | yapp monitor | RX pkt #3 on the input: addr=0 len=11 parity=good gap=19 |
| 825 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=0) |
| 825 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (length > maxpktsize) |
| 830 | yapp driver | TX pkt #3 accepted by the DUT |
| 830 | yapp driver | TX pkt #4: addr=0 len=63 parity=good delay=17 |
| 1005 | **DUT** | IN  pkt #4 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 1645 | **DUT** | IN  pkt #4 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1645 | yapp monitor | RX pkt #4 on the input: addr=0 len=63 parity=good gap=17 |
| 1645 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=0) |
| 1645 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 1650 | yapp driver | TX pkt #4 accepted by the DUT |
| 1650 | yapp driver | TX pkt #5: addr=1 len=9 parity=good delay=10 |
| 1755 | **DUT** | IN  pkt #5 header: addr=1 len=9 -> channel 1 |
| 1785 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=9 (receiver waited 2 cycle(s)) |
| 1855 | **DUT** | IN  pkt #5 complete: addr=1 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 1855 | yapp monitor | RX pkt #5 on the input: addr=1 len=9 parity=good gap=10 |
| 1855 | reference | Packet forwarded: addr=1 len=9 -> channel 1 |
| 1860 | yapp driver | TX pkt #5 accepted by the DUT |
| 1860 | yapp driver | TX pkt #6: addr=1 len=10 parity=good delay=17 |
| 1880 | ch1 driver | ch1: packet consumed (response delay 2) |
| 1965 | **DUT** | OUT ch1 pkt #1 done: 11 bytes in 19 cycles |
| 1965 | ch1 monitor | ch1 RX pkt #1: addr=1 len=9 parity=good |
| 1965 | scoreboard | ch1 pkt matched: addr=1 len=9 (3 matched so far) |
| 2035 | **DUT** | IN  pkt #6 header: addr=1 len=10 -> channel 1 |
| 2045 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=10 (receiver waited 0 cycle(s)) |
| 2145 | **DUT** | IN  pkt #6 complete: addr=1 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 2145 | yapp monitor | RX pkt #6 on the input: addr=1 len=10 parity=good gap=17 |
| 2145 | reference | Packet forwarded: addr=1 len=10 -> channel 1 |
| 2150 | ch1 driver | ch1: packet consumed (response delay 7) |
| 2150 | yapp driver | TX pkt #6 accepted by the DUT |
| 2150 | yapp driver | TX pkt #7: addr=1 len=11 parity=good delay=20 |
| 2255 | **DUT** | OUT ch1 pkt #2 done: 12 bytes in 22 cycles |
| 2255 | ch1 monitor | ch1 RX pkt #2: addr=1 len=10 parity=good |
| 2255 | scoreboard | ch1 pkt matched: addr=1 len=10 (4 matched so far) |
| 2355 | **DUT** | IN  pkt #7 header: addr=1 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 2370 | ch1 driver | ch1: packet consumed (response delay 9) |
| 2475 | **DUT** | IN  pkt #7 complete: addr=1 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 2475 | yapp monitor | RX pkt #7 on the input: addr=1 len=11 parity=good gap=20 |
| 2475 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=1) |
| 2475 | **DUT** | ROUTER DROPS PACKET addr=1 length=11 (length > maxpktsize) |
| 2480 | yapp driver | TX pkt #7 accepted by the DUT |
| 2480 | yapp driver | TX pkt #8: addr=1 len=63 parity=good delay=5 |
| 2535 | **DUT** | IN  pkt #8 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 3175 | **DUT** | IN  pkt #8 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 3175 | yapp monitor | RX pkt #8 on the input: addr=1 len=63 parity=good gap=5 |
| 3175 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=1) |
| 3175 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 3180 | yapp driver | TX pkt #8 accepted by the DUT |
| 3180 | yapp driver | TX pkt #9: addr=2 len=9 parity=good delay=16 |
| 3345 | **DUT** | IN  pkt #9 header: addr=2 len=9 -> channel 2 |
| 3445 | **DUT** | IN  pkt #9 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 3445 | yapp monitor | RX pkt #9 on the input: addr=2 len=9 parity=good gap=16 |
| 3445 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 3450 | yapp driver | TX pkt #9 accepted by the DUT |
| 3450 | yapp driver | TX pkt #10: addr=2 len=10 parity=good delay=16 |
| 3455 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=9 (receiver waited 10 cycle(s)) |
| 3550 | ch2 driver | ch2: packet consumed (response delay 10) |
| 3615 | **DUT** | IN  pkt #10 header: addr=2 len=10 -> channel 2 |
| 3665 | **DUT** | OUT ch2 pkt #1 done: 11 bytes in 22 cycles |
| 3665 | ch2 monitor | ch2 RX pkt #1: addr=2 len=9 parity=good |
| 3665 | scoreboard | ch2 pkt matched: addr=2 len=9 (5 matched so far) |
| 3675 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=10 (receiver waited 0 cycle(s)) |
| 3725 | **DUT** | IN  pkt #10 complete: addr=2 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 3725 | yapp monitor | RX pkt #10 on the input: addr=2 len=10 parity=good gap=16 |
| 3725 | reference | Packet forwarded: addr=2 len=10 -> channel 2 |
| 3730 | yapp driver | TX pkt #10 accepted by the DUT |
| 3730 | yapp driver | TX pkt #11: addr=2 len=11 parity=good delay=17 |
| 3785 | **DUT** | OUT ch2 pkt #2 done: 12 bytes in 12 cycles |
| 3785 | ch2 monitor | ch2 RX pkt #2: addr=2 len=10 parity=good |
| 3785 | scoreboard | ch2 pkt matched: addr=2 len=10 (6 matched so far) |
| 3905 | **DUT** | IN  pkt #11 header: addr=2 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 4025 | **DUT** | IN  pkt #11 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 4025 | yapp monitor | RX pkt #11 on the input: addr=2 len=11 parity=good gap=17 |
| 4025 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=2) |
| 4025 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (length > maxpktsize) |
| 4030 | yapp driver | TX pkt #11 accepted by the DUT |
| 4030 | yapp driver | TX pkt #12: addr=2 len=63 parity=good delay=20 |
| 4050 | ch2 driver | ch2: packet consumed (response delay 10) |
| 4235 | **DUT** | IN  pkt #12 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 4875 | **DUT** | IN  pkt #12 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4875 | yapp monitor | RX pkt #12 on the input: addr=2 len=63 parity=good gap=20 |
| 4875 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=2) |
| 4875 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4880 | yapp driver | TX pkt #12 accepted by the DUT |
| 4880 | yapp driver | TX pkt #13: addr=3 len=9 parity=good delay=19 |
| 5075 | **DUT** | IN  pkt #13 header: addr=3 len=9 -> DROP (illegal address 3) |
| 5175 | **DUT** | IN  pkt #13 complete: addr=3 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 5175 | yapp monitor | RX pkt #13 on the input: addr=3 len=9 parity=good gap=19 |
| 5175 | reference | Packet dropped: illegal address 3 (len=9) |
| 5175 | **DUT** | ROUTER DROPS PACKET addr=3 length=9 (    illegal address) |
| 5180 | yapp driver | TX pkt #13 accepted by the DUT |
| 5180 | yapp driver | TX pkt #14: addr=3 len=10 parity=good delay=2 |
| 5205 | **DUT** | IN  pkt #14 header: addr=3 len=10 -> DROP (illegal address 3) |
| 5315 | **DUT** | IN  pkt #14 complete: addr=3 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 5315 | yapp monitor | RX pkt #14 on the input: addr=3 len=10 parity=good gap=2 |
| 5315 | reference | Packet dropped: illegal address 3 (len=10) |
| 5315 | **DUT** | ROUTER DROPS PACKET addr=3 length=10 (    illegal address) |
| 5320 | yapp driver | TX pkt #14 accepted by the DUT |
| 5320 | yapp driver | TX pkt #15: addr=3 len=11 parity=good delay=17 |
| 5495 | **DUT** | IN  pkt #15 header: addr=3 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 5615 | **DUT** | IN  pkt #15 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 5615 | yapp monitor | RX pkt #15 on the input: addr=3 len=11 parity=good gap=17 |
| 5615 | reference | Packet dropped: illegal address 3 (len=11) |
| 5615 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (    illegal address) |
| 5620 | yapp driver | TX pkt #15 accepted by the DUT |
| 5620 | yapp driver | TX pkt #16: addr=3 len=63 parity=good delay=8 |
| 5705 | **DUT** | IN  pkt #16 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 6345 | **DUT** | IN  pkt #16 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 6345 | yapp monitor | RX pkt #16 on the input: addr=3 len=63 parity=good gap=8 |
| 6345 | reference | Packet dropped: illegal address 3 (len=63) |
| 6345 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 6350 | yapp driver | TX pkt #16 accepted by the DUT |
| 6410 | hbus driver | Executed READ  addr=0x1005 data=0x08 |
| 6410 | **test** | oversized_pkt_cnt_reg reads 8 as expected |
| 6415 | hbus monitor | Collected READ  addr=0x1005 data=0x08 |
| 6440 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 6440 | **test** | addr3_cnt_reg reads 4 as expected |
| 6445 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 6470 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 6470 | **test** | addr0_cnt_reg reads 4 as expected |
| 6475 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 6500 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 6500 | **test** | addr1_cnt_reg reads 4 as expected |
| 6505 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 6530 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 6530 | **test** | addr2_cnt_reg reads 4 as expected |
| 6535 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 6560 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 6560 | **test** | parity_err_cnt_reg reads 0 as expected |
| 6560 | **test** | STAGE: 2. en_reg=0x01: the same traffic, the same drops, the counters do not move |
| 6565 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6580 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 6580 | yapp driver | TX pkt #17: addr=0 len=9 parity=good delay=20 |
| 6585 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 6585 | reference | router_en is now 1 (en_reg 0x01) |
| 6795 | **DUT** | IN  pkt #17 header: addr=0 len=9 -> channel 0 |
| 6855 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=9 (receiver waited 5 cycle(s)) |
| 6895 | **DUT** | IN  pkt #17 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 6895 | yapp monitor | RX pkt #17 on the input: addr=0 len=9 parity=good gap=44 |
| 6895 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 6900 | yapp driver | TX pkt #17 accepted by the DUT |
| 6900 | yapp driver | TX pkt #18: addr=0 len=10 parity=good delay=4 |
| 6945 | **DUT** | IN  pkt #18 header: addr=0 len=10 -> channel 0 |
| 6950 | ch0 driver | ch0: packet consumed (response delay 5) |
| 7055 | **DUT** | IN  pkt #18 complete: addr=0 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 7055 | yapp monitor | RX pkt #18 on the input: addr=0 len=10 parity=good gap=4 |
| 7055 | reference | Packet forwarded: addr=0 len=10 -> channel 0 |
| 7060 | yapp driver | TX pkt #18 accepted by the DUT |
| 7060 | yapp driver | TX pkt #19: addr=0 len=11 parity=good delay=17 |
| 7065 | **DUT** | OUT ch0 pkt #3 done: 11 bytes in 22 cycles |
| 7065 | ch0 monitor | ch0 RX pkt #3: addr=0 len=9 parity=good |
| 7065 | scoreboard | ch0 pkt matched: addr=0 len=9 (7 matched so far) |
| 7075 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=10 (receiver waited 0 cycle(s)) |
| 7185 | **DUT** | OUT ch0 pkt #4 done: 12 bytes in 12 cycles |
| 7185 | ch0 monitor | ch0 RX pkt #4: addr=0 len=10 parity=good |
| 7185 | scoreboard | ch0 pkt matched: addr=0 len=10 (8 matched so far) |
| 7235 | **DUT** | IN  pkt #19 header: addr=0 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 7355 | **DUT** | IN  pkt #19 complete: addr=0 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 7355 | yapp monitor | RX pkt #19 on the input: addr=0 len=11 parity=good gap=17 |
| 7355 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=0) |
| 7355 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (length > maxpktsize) |
| 7360 | yapp driver | TX pkt #19 accepted by the DUT |
| 7360 | yapp driver | TX pkt #20: addr=0 len=63 parity=good delay=1 |
| 7375 | **DUT** | IN  pkt #20 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 7480 | ch0 driver | ch0: packet consumed (response delay 10) |
| 8015 | **DUT** | IN  pkt #20 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8015 | yapp monitor | RX pkt #20 on the input: addr=0 len=63 parity=good gap=1 |
| 8015 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=0) |
| 8015 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 8020 | yapp driver | TX pkt #20 accepted by the DUT |
| 8020 | yapp driver | TX pkt #21: addr=1 len=9 parity=good delay=3 |
| 8055 | **DUT** | IN  pkt #21 header: addr=1 len=9 -> channel 1 |
| 8145 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=9 (receiver waited 8 cycle(s)) |
| 8155 | **DUT** | IN  pkt #21 complete: addr=1 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 8155 | yapp monitor | RX pkt #21 on the input: addr=1 len=9 parity=good gap=3 |
| 8155 | reference | Packet forwarded: addr=1 len=9 -> channel 1 |
| 8160 | yapp driver | TX pkt #21 accepted by the DUT |
| 8160 | yapp driver | TX pkt #22: addr=1 len=10 parity=good delay=20 |
| 8240 | ch1 driver | ch1: packet consumed (response delay 8) |
| 8265 | **DUT** | OUT ch1 pkt #3 done: 11 bytes in 13 cycles |
| 8265 | ch1 monitor | ch1 RX pkt #3: addr=1 len=9 parity=good |
| 8265 | scoreboard | ch1 pkt matched: addr=1 len=9 (9 matched so far) |
| 8365 | **DUT** | IN  pkt #22 header: addr=1 len=10 -> channel 1 |
| 8375 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=10 (receiver waited 0 cycle(s)) |
| 8475 | **DUT** | IN  pkt #22 complete: addr=1 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 8475 | yapp monitor | RX pkt #22 on the input: addr=1 len=10 parity=good gap=20 |
| 8475 | reference | Packet forwarded: addr=1 len=10 -> channel 1 |
| 8480 | yapp driver | TX pkt #22 accepted by the DUT |
| 8480 | yapp driver | TX pkt #23: addr=1 len=11 parity=good delay=11 |
| 8485 | **DUT** | OUT ch1 pkt #4 done: 12 bytes in 12 cycles |
| 8485 | ch1 monitor | ch1 RX pkt #4: addr=1 len=10 parity=good |
| 8485 | scoreboard | ch1 pkt matched: addr=1 len=10 (10 matched so far) |
| 8595 | **DUT** | IN  pkt #23 header: addr=1 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 8715 | **DUT** | IN  pkt #23 complete: addr=1 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 8715 | yapp monitor | RX pkt #23 on the input: addr=1 len=11 parity=good gap=11 |
| 8715 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=1) |
| 8715 | **DUT** | ROUTER DROPS PACKET addr=1 length=11 (length > maxpktsize) |
| 8720 | yapp driver | TX pkt #23 accepted by the DUT |
| 8720 | yapp driver | TX pkt #24: addr=1 len=63 parity=good delay=1 |
| 8735 | **DUT** | IN  pkt #24 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 8780 | ch1 driver | ch1: packet consumed (response delay 1) |
| 9375 | **DUT** | IN  pkt #24 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 9375 | yapp monitor | RX pkt #24 on the input: addr=1 len=63 parity=good gap=1 |
| 9375 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=1) |
| 9375 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 9380 | yapp driver | TX pkt #24 accepted by the DUT |
| 9380 | yapp driver | TX pkt #25: addr=2 len=9 parity=good delay=17 |
| 9555 | **DUT** | IN  pkt #25 header: addr=2 len=9 -> channel 2 |
| 9605 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=9 (receiver waited 4 cycle(s)) |
| 9655 | **DUT** | IN  pkt #25 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 9655 | yapp monitor | RX pkt #25 on the input: addr=2 len=9 parity=good gap=17 |
| 9655 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 9660 | yapp driver | TX pkt #25 accepted by the DUT |
| 9660 | yapp driver | TX pkt #26: addr=2 len=10 parity=good delay=9 |
| 9700 | ch2 driver | ch2: packet consumed (response delay 4) |
| 9755 | **DUT** | IN  pkt #26 header: addr=2 len=10 -> channel 2 |
| 9795 | **DUT** | OUT ch2 pkt #3 done: 11 bytes in 20 cycles |
| 9795 | ch2 monitor | ch2 RX pkt #3: addr=2 len=9 parity=good |
| 9795 | scoreboard | ch2 pkt matched: addr=2 len=9 (11 matched so far) |
| 9805 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=10 (receiver waited 0 cycle(s)) |
| 9865 | **DUT** | IN  pkt #26 complete: addr=2 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 9865 | yapp monitor | RX pkt #26 on the input: addr=2 len=10 parity=good gap=9 |
| 9865 | reference | Packet forwarded: addr=2 len=10 -> channel 2 |
| 9870 | yapp driver | TX pkt #26 accepted by the DUT |
| 9870 | yapp driver | TX pkt #27: addr=2 len=11 parity=good delay=4 |
| 9915 | **DUT** | IN  pkt #27 header: addr=2 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 9915 | **DUT** | OUT ch2 pkt #4 done: 12 bytes in 12 cycles |
| 9915 | ch2 monitor | ch2 RX pkt #4: addr=2 len=10 parity=good |
| 9915 | scoreboard | ch2 pkt matched: addr=2 len=10 (12 matched so far) |
| 10035 | **DUT** | IN  pkt #27 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 10035 | yapp monitor | RX pkt #27 on the input: addr=2 len=11 parity=good gap=4 |
| 10035 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=2) |
| 10035 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (length > maxpktsize) |
| 10040 | yapp driver | TX pkt #27 accepted by the DUT |
| 10040 | yapp driver | TX pkt #28: addr=2 len=63 parity=good delay=20 |
| 10245 | **DUT** | IN  pkt #28 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 10250 | ch2 driver | ch2: packet consumed (response delay 8) |
| 10885 | **DUT** | IN  pkt #28 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10885 | yapp monitor | RX pkt #28 on the input: addr=2 len=63 parity=good gap=20 |
| 10885 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=2) |
| 10885 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10890 | yapp driver | TX pkt #28 accepted by the DUT |
| 10890 | yapp driver | TX pkt #29: addr=3 len=9 parity=good delay=20 |
| 11095 | **DUT** | IN  pkt #29 header: addr=3 len=9 -> DROP (illegal address 3) |
| 11195 | **DUT** | IN  pkt #29 complete: addr=3 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 11195 | yapp monitor | RX pkt #29 on the input: addr=3 len=9 parity=good gap=20 |
| 11195 | reference | Packet dropped: illegal address 3 (len=9) |
| 11195 | **DUT** | ROUTER DROPS PACKET addr=3 length=9 (    illegal address) |
| 11200 | yapp driver | TX pkt #29 accepted by the DUT |
| 11200 | yapp driver | TX pkt #30: addr=3 len=10 parity=good delay=12 |
| 11325 | **DUT** | IN  pkt #30 header: addr=3 len=10 -> DROP (illegal address 3) |
| 11435 | **DUT** | IN  pkt #30 complete: addr=3 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 11435 | yapp monitor | RX pkt #30 on the input: addr=3 len=10 parity=good gap=12 |
| 11435 | reference | Packet dropped: illegal address 3 (len=10) |
| 11435 | **DUT** | ROUTER DROPS PACKET addr=3 length=10 (    illegal address) |
| 11440 | yapp driver | TX pkt #30 accepted by the DUT |
| 11440 | yapp driver | TX pkt #31: addr=3 len=11 parity=good delay=8 |
| 11525 | **DUT** | IN  pkt #31 header: addr=3 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 11645 | **DUT** | IN  pkt #31 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 11645 | yapp monitor | RX pkt #31 on the input: addr=3 len=11 parity=good gap=8 |
| 11645 | reference | Packet dropped: illegal address 3 (len=11) |
| 11645 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (    illegal address) |
| 11650 | yapp driver | TX pkt #31 accepted by the DUT |
| 11650 | yapp driver | TX pkt #32: addr=3 len=63 parity=good delay=20 |
| 11855 | **DUT** | IN  pkt #32 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 12495 | **DUT** | IN  pkt #32 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12495 | yapp monitor | RX pkt #32 on the input: addr=3 len=63 parity=good gap=20 |
| 12495 | reference | Packet dropped: illegal address 3 (len=63) |
| 12495 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 12500 | yapp driver | TX pkt #32 accepted by the DUT |
| 12560 | hbus driver | Executed READ  addr=0x1005 data=0x08 |
| 12560 | **test** | oversized_pkt_cnt_reg reads 8 as expected |
| 12565 | hbus monitor | Collected READ  addr=0x1005 data=0x08 |
| 12590 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 12590 | **test** | addr3_cnt_reg reads 4 as expected |
| 12595 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 12620 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 12620 | **test** | addr0_cnt_reg reads 4 as expected |
| 12625 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 12650 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 12650 | **test** | addr1_cnt_reg reads 4 as expected |
| 12655 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 12680 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 12680 | **test** | addr2_cnt_reg reads 4 as expected |
| 12680 | **test** | STAGE: ctrl_reg back to 0x3f |
| 12685 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 12700 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 12705 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 12705 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 12705 | reference | maxpktsize is now 63 |
| 12900 | ch0 monitor | Channel 0 report: 4 packets collected |
| 12900 | ch1 monitor | Channel 1 report: 4 packets collected |
| 12900 | ch2 monitor | Channel 2 report: 4 packets collected |
| 12900 | hbus monitor | HBUS report: 4 writes, 11 reads |
| 12900 | coverage | Coverage of the router configuration: 60.9% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 0 / 32 / 0 / 0 packets · length < max / = max / max+1 / > max+1 : 8 / 8 / 8 / 8 · forwarded good / bad : 12 / 0 · dropped address 3 good / bad : 8 / 0 · dropped oversized good / bad : 12 / 0 · counter enables none / mixed / all : 16 / 0 / 16 |
| 12900 | coverage | HBUS address coverage: 15 accesses sampled, coverage 23.4% |
| 12900 | coverage | HBUS register bits coverage: 4 writes to ctrl_reg/en_reg, coverage 88.6% |
| 12900 | coverage | HBUS counter value coverage: 11 counter reads sampled, coverage 51.9% |
| 12900 | coverage | HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0% |
| 12900 | reference | --- Reference model report --- · forwarded to scoreboard : 12 · dropped (router disabled) : 0 · dropped (oversized) : 12 · dropped (address 3) : 8 · counters parity/oversized/addr0..3 : 0 / 8 / 4 4 4 4 |
| 12900 | scoreboard | --- Scoreboard report --- · packets received : 12 · packets matched : 12 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 12900 | yapp driver | YAPP driver report: 32 packets sent |
| 12900 | coverage | YAPP gap coverage: 31 gaps sampled, coverage 75.0% |
| 12900 | yapp monitor | YAPP monitor report: 32 packets collected, 0 with bad parity |
| 12900 | yapp monitor | YAPP gaps: 0 back to back, 2 of 1 cycle, 1 of 2, 28 longer |
| 12900 | coverage | YAPP packet coverage: 32 packets sampled, coverage 36.7% |
