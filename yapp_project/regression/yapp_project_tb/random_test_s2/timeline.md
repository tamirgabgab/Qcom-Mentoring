# random_test  seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 25us · log `random_test_s2.log`

Waves: `random_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s2%2Frandom_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **50** packet(s) (7 with bad parity); the input monitor saw 50.
- Router: **12** forwarded, **38** dropped (20 oversized, 18 router disabled).
- Packets out: ch0 **4**, ch1 **2**, ch2 **6**.
- Scoreboard: 12 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **10** time(s), longest hold 40 cycle(s).
- Error pulses: 5.
- HBUS: 23 write(s), 67 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_SLOW, ch1 RX_NORMAL, ch2 RX_SLOW |
| 0 | random scenario: 50 packets in 6 bursts |
| 290 | burst 1/6: ctrl=0x8e (maxpktsize 14) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 3070 | burst 1/6 sent: addr0..3 1/1/6/0, bad parity 1, gap 0 1, length 7..59 |
| 3400 | burst 2/6: ctrl=0xbf (maxpktsize 63) en=0xd9 (router on, counter enables 1101100), 8 packet(s) |
| 9850 | burst 2/6 sent: addr0..3 4/0/4/0, bad parity 0, gap 0 0, length 7..63 |
| 10130 | burst 3/6: ctrl=0xca (maxpktsize 10) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 13700 | burst 3/6 sent: addr0..3 2/2/4/0, bad parity 2, gap 0 1, length 8..63 |
| 13980 | burst 4/6: ctrl=0x40 (maxpktsize 0) en=0x3f (router on, counter enables 0011111), 8 packet(s) |
| 16570 | burst 4/6 sent: addr0..3 2/1/5/0, bad parity 2, gap 0 1, length 1..53 |
| 16790 | burst 5/6: ctrl=0xf4 (maxpktsize 52) en=0x00 (router OFF, counter enables 0000000), 10 packet(s) |
| 20970 | burst 5/6 sent: addr0..3 3/4/3/0, bad parity 2, gap 0 2, length 1..63 |
| 21100 | burst 6/6: ctrl=0xc0 (maxpktsize 0) en=0x7c (router OFF, counter enables 0111110), 8 packet(s) |
| 23430 | burst 6/6 sent: addr0..3 3/4/1/0, bad parity 0, gap 0 2, length 1..58 |
| 23430 | final reads: every register and the stored packet, checked against the reference model |
| 24535 | done: 50 packets (12 forwarded, 38 dropped), 0 storm burst(s), 12 scoreboard matches, 67 HBUS reads checked, 5 error pulses for 5 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 1**

![first packet out on channel 1](wave_first_packet_out.svg)

**first back-pressure on the input port**

![first back-pressure on the input port](wave_first_suspend.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

670 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_SLOW, ch1 RX_NORMAL, ch2 RX_SLOW |
| 0 | **test** | STAGE: random scenario: 50 packets in 6 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x8e |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=14 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x8e |
| 75 | reference | maxpktsize is now 14 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 125 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 150 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 180 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 185 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 210 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 215 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 230 | hbus driver | Executed WRITE addr=0x1124 data=0xc1 |
| 235 | hbus monitor | Collected WRITE addr=0x1124 data=0xc1 |
| 260 | hbus driver | Executed READ  addr=0x1124 data=0xc1 |
| 265 | hbus monitor | Collected READ  addr=0x1124 data=0xc1 |
| 290 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 290 | **test** | STAGE: burst 1/6: ctrl=0x8e (maxpktsize 14) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 290 | yapp driver | TX pkt #1: addr=2 len=59 parity=good delay=12 |
| 295 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 425 | **DUT** | IN  pkt #1 header: addr=2 len=59 -> DROP (oversized: len 59 > maxpktsize 14) |
| 1025 | **DUT** | IN  pkt #1 complete: addr=2 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 1025 | yapp monitor | RX pkt #1 on the input: addr=2 len=59 parity=good gap=37 |
| 1025 | reference | Packet dropped: length 59 > maxpktsize 14 (addr=2) |
| 1025 | **DUT** | ROUTER DROPS PACKET addr=2 length=59 (length > maxpktsize) |
| 1030 | yapp driver | TX pkt #1 accepted by the DUT |
| 1030 | yapp driver | TX pkt #2: addr=2 len=27 parity=bad delay=2 |
| 1055 | **DUT** | IN  pkt #2 header: addr=2 len=27 -> DROP (oversized: len 27 > maxpktsize 14) |
| 1335 | **DUT** | IN  pkt #2 complete: addr=2 len=27 parity=BAD dropped, 29 bytes in 29 cycles (held 0) |
| 1335 | yapp monitor | RX pkt #2 on the input: addr=2 len=27 parity=bad gap=2 |
| 1335 | reference | Packet dropped: length 27 > maxpktsize 14 (addr=2) |
| 1335 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (length > maxpktsize) |
| 1340 | yapp driver | TX pkt #2 accepted by the DUT |
| 1340 | yapp driver | TX pkt #3: addr=2 len=7 parity=good delay=2 |
| 1350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 1350 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 1365 | **DUT** | IN  pkt #3 header: addr=2 len=7 -> channel 2 |
| 1445 | **DUT** | IN  pkt #3 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 1445 | yapp monitor | RX pkt #3 on the input: addr=2 len=7 parity=good gap=2 |
| 1445 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 1450 | yapp driver | TX pkt #3 accepted by the DUT |
| 1450 | yapp driver | TX pkt #4: addr=1 len=14 parity=good delay=4 |
| 1495 | **DUT** | IN  pkt #4 header: addr=1 len=14 -> channel 1 |
| 1585 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=14 (receiver waited 8 cycle(s)) |
| 1595 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=7 (receiver waited 22 cycle(s)) |
| 1645 | **DUT** | IN  pkt #4 complete: addr=1 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 1645 | yapp monitor | RX pkt #4 on the input: addr=1 len=14 parity=good gap=4 |
| 1645 | reference | Packet forwarded: addr=1 len=14 -> channel 1 |
| 1650 | yapp driver | TX pkt #4 accepted by the DUT |
| 1650 | yapp driver | TX pkt #5: addr=2 len=59 parity=good delay=17 |
| 1670 | ch2 driver | ch2: packet consumed (response delay 22) |
| 1730 | ch1 driver | ch1: packet consumed (response delay 8) |
| 1805 | **DUT** | OUT ch1 pkt #1 done: 16 bytes in 23 cycles |
| 1805 | ch1 monitor | ch1 RX pkt #1: addr=1 len=14 parity=good |
| 1805 | scoreboard | ch1 pkt matched: addr=1 len=14 (1 matched so far) |
| 1825 | **DUT** | IN  pkt #5 header: addr=2 len=59 -> DROP (oversized: len 59 > maxpktsize 14) |
| 2085 | **DUT** | OUT ch2 pkt #1 done: 9 bytes in 50 cycles |
| 2085 | ch2 monitor | ch2 RX pkt #1: addr=2 len=7 parity=good |
| 2085 | scoreboard | ch2 pkt matched: addr=2 len=7 (2 matched so far) |
| 2340 | ch1 driver | ch1: packet consumed (response delay 6) |
| 2425 | **DUT** | IN  pkt #5 complete: addr=2 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 2425 | yapp monitor | RX pkt #5 on the input: addr=2 len=59 parity=good gap=17 |
| 2425 | reference | Packet dropped: length 59 > maxpktsize 14 (addr=2) |
| 2425 | **DUT** | ROUTER DROPS PACKET addr=2 length=59 (length > maxpktsize) |
| 2430 | yapp driver | TX pkt #5 accepted by the DUT |
| 2430 | yapp driver | TX pkt #6: addr=2 len=7 parity=good delay=0 |
| 2435 | **DUT** | IN  pkt #6 header: addr=2 len=7 -> channel 2 |
| 2440 | ch2 driver | ch2: packet consumed (response delay 40) |
| 2515 | **DUT** | IN  pkt #6 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 2515 | yapp monitor | RX pkt #6 on the input: addr=2 len=7 parity=good gap=0 |
| 2515 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 2520 | yapp driver | TX pkt #6 accepted by the DUT |
| 2520 | yapp driver | TX pkt #7: addr=2 len=15 parity=good delay=2 |
| 2545 | **DUT** | IN  pkt #7 header: addr=2 len=15 -> DROP (oversized: len 15 > maxpktsize 14) |
| 2695 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=7 (receiver waited 25 cycle(s)) |
| 2705 | **DUT** | IN  pkt #7 complete: addr=2 len=15 parity=ok dropped, 17 bytes in 17 cycles (held 0) |
| 2705 | yapp monitor | RX pkt #7 on the input: addr=2 len=15 parity=good gap=2 |
| 2705 | reference | Packet dropped: length 15 > maxpktsize 14 (addr=2) |
| 2705 | **DUT** | ROUTER DROPS PACKET addr=2 length=15 (length > maxpktsize) |
| 2710 | yapp driver | TX pkt #7 accepted by the DUT |
| 2710 | yapp driver | TX pkt #8: addr=0 len=17 parity=good delay=17 |
| 2770 | ch2 driver | ch2: packet consumed (response delay 24) |
| 2885 | **DUT** | IN  pkt #8 header: addr=0 len=17 -> DROP (oversized: len 17 > maxpktsize 14) |
| 3065 | **DUT** | IN  pkt #8 complete: addr=0 len=17 parity=ok dropped, 19 bytes in 19 cycles (held 0) |
| 3065 | yapp monitor | RX pkt #8 on the input: addr=0 len=17 parity=good gap=17 |
| 3065 | reference | Packet dropped: length 17 > maxpktsize 14 (addr=0) |
| 3065 | **DUT** | ROUTER DROPS PACKET addr=0 length=17 (length > maxpktsize) |
| 3070 | yapp driver | TX pkt #8 accepted by the DUT |
| 3070 | **test** | STAGE: burst 1/6 sent: addr0..3 1/1/6/0, bad parity 1, gap 0 1, length 7..59 |
| 3090 | hbus driver | Executed WRITE addr=0x1000 data=0xbf |
| 3095 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 3095 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 3095 | reference | maxpktsize is now 63 |
| 3110 | hbus driver | Executed WRITE addr=0x1001 data=0xd9 |
| 3115 | hbus monitor | Collected WRITE addr=0x1001 data=0xd9 |
| 3115 | reference | router_en is now 1 (en_reg 0xd9) |
| 3130 | hbus driver | Executed WRITE addr=0x1116 data=0x5c |
| 3135 | hbus monitor | Collected WRITE addr=0x1116 data=0x5c |
| 3155 | **DUT** | OUT ch2 pkt #2 done: 9 bytes in 47 cycles |
| 3155 | ch2 monitor | ch2 RX pkt #2: addr=2 len=7 parity=good |
| 3155 | scoreboard | ch2 pkt matched: addr=2 len=7 (3 matched so far) |
| 3160 | hbus driver | Executed READ  addr=0x1116 data=0x5c |
| 3165 | hbus monitor | Collected READ  addr=0x1116 data=0x5c |
| 3190 | hbus driver | Executed READ  addr=0x10f6 data=0x00 |
| 3195 | hbus monitor | Collected READ  addr=0x10f6 data=0x00 |
| 3210 | hbus driver | Executed WRITE addr=0x11fb data=0x4c |
| 3215 | hbus monitor | Collected WRITE addr=0x11fb data=0x4c |
| 3240 | hbus driver | Executed READ  addr=0x11fb data=0x4c |
| 3245 | hbus monitor | Collected READ  addr=0x11fb data=0x4c |
| 3270 | hbus driver | Executed READ  addr=0x100d data=0x11 |
| 3275 | hbus monitor | Collected READ  addr=0x100d data=0x11 |
| 3290 | hbus driver | Executed WRITE addr=0x115a data=0xe7 |
| 3295 | hbus monitor | Collected WRITE addr=0x115a data=0xe7 |
| 3320 | hbus driver | Executed READ  addr=0x115a data=0xe7 |
| 3325 | hbus monitor | Collected READ  addr=0x115a data=0xe7 |
| 3340 | hbus driver | Executed WRITE addr=0x114e data=0x32 |
| 3345 | hbus monitor | Collected WRITE addr=0x114e data=0x32 |
| 3370 | hbus driver | Executed READ  addr=0x114e data=0x32 |
| 3375 | hbus monitor | Collected READ  addr=0x114e data=0x32 |
| 3400 | hbus driver | Executed READ  addr=0x1004 data=0x01 |
| 3400 | **test** | STAGE: burst 2/6: ctrl=0xbf (maxpktsize 63) en=0xd9 (router on, counter enables 1101100), 8 packet(s) |
| 3400 | yapp driver | TX pkt #9: addr=0 len=42 parity=good delay=10 |
| 3405 | hbus monitor | Collected READ  addr=0x1004 data=0x01 |
| 3515 | **DUT** | IN  pkt #9 header: addr=0 len=42 -> channel 0 |
| 3675 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x86 held (pkt #9) |
| 3770 | ch2 driver | ch2: packet consumed (response delay 37) |
| 3775 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=42 (receiver waited 25 cycle(s)) |
| 3785 | **DUT** | SUSPEND released after 11 cycle(s) |
| 4055 | **DUT** | IN  pkt #9 complete: addr=0 len=42 parity=ok forwarded, 44 bytes in 55 cycles (held 11) |
| 4055 | yapp monitor | RX pkt #9 on the input: addr=0 len=42 parity=good gap=44 |
| 4055 | reference | Packet forwarded: addr=0 len=42 -> channel 0 |
| 4060 | yapp driver | TX pkt #9 accepted by the DUT |
| 4060 | yapp driver | TX pkt #10: addr=0 len=59 parity=good delay=20 |
| 4200 | ch0 driver | ch0: packet consumed (response delay 25) |
| 4265 | **DUT** | IN  pkt #10 header: addr=0 len=59 -> channel 0 |
| 4415 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x84 held (pkt #10) |
| 4525 | **DUT** | OUT ch0 pkt #1 done: 44 bytes in 76 cycles |
| 4525 | ch0 monitor | ch0 RX pkt #1: addr=0 len=42 parity=good |
| 4525 | scoreboard | ch0 pkt matched: addr=0 len=42 (4 matched so far) |
| 4535 | **DUT** | SUSPEND released after 12 cycle(s) |
| 4535 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=59 (receiver waited 0 cycle(s)) |
| 4790 | ch0 driver | ch0: packet consumed (response delay 31) |
| 4805 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0xa2 held (pkt #10) |
| 5045 | **DUT** | SUSPEND released after 24 cycle(s) |
| 5225 | **DUT** | IN  pkt #10 complete: addr=0 len=59 parity=ok forwarded, 61 bytes in 97 cycles (held 36) |
| 5225 | yapp monitor | RX pkt #10 on the input: addr=0 len=59 parity=good gap=20 |
| 5225 | reference | Packet forwarded: addr=0 len=59 -> channel 0 |
| 5230 | yapp driver | TX pkt #10 accepted by the DUT |
| 5230 | yapp driver | TX pkt #11: addr=2 len=7 parity=good delay=12 |
| 5340 | ch0 driver | ch0: packet consumed (response delay 23) |
| 5355 | **DUT** | IN  pkt #11 header: addr=2 len=7 -> channel 2 |
| 5435 | **DUT** | IN  pkt #11 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 5435 | yapp monitor | RX pkt #11 on the input: addr=2 len=7 parity=good gap=12 |
| 5435 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 5440 | yapp driver | TX pkt #11 accepted by the DUT |
| 5440 | yapp driver | TX pkt #12: addr=2 len=63 parity=good delay=19 |
| 5635 | **DUT** | IN  pkt #12 header: addr=2 len=63 -> channel 2 |
| 5705 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xd3 held (pkt #12) |
| 5765 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=7 (receiver waited 40 cycle(s)) |
| 5775 | **DUT** | SUSPEND released after 7 cycle(s) |
| 5785 | **DUT** | OUT ch0 pkt #2 done: 61 bytes in 126 cycles |
| 5785 | ch0 monitor | ch0 RX pkt #2: addr=0 len=59 parity=good |
| 5785 | scoreboard | ch0 pkt matched: addr=0 len=59 (5 matched so far) |
| 5840 | ch2 driver | ch2: packet consumed (response delay 40) |
| 5855 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xfe held (pkt #12) |
| 6075 | **DUT** | OUT ch2 pkt #3 done: 9 bytes in 32 cycles |
| 6075 | ch2 monitor | ch2 RX pkt #3: addr=2 len=7 parity=good |
| 6075 | scoreboard | ch2 pkt matched: addr=2 len=7 (6 matched so far) |
| 6085 | **DUT** | SUSPEND released after 23 cycle(s) |
| 6085 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 6320 | ch2 driver | ch2: packet consumed (response delay 22) |
| 6335 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x3f held (pkt #12) |
| 6370 | ch0 driver | ch0: packet consumed (response delay 40) |
| 6575 | **DUT** | SUSPEND released after 24 cycle(s) |
| 6815 | **DUT** | IN  pkt #12 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 119 cycles (held 54) |
| 6815 | yapp monitor | RX pkt #12 on the input: addr=2 len=63 parity=good gap=19 |
| 6815 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 6820 | yapp driver | TX pkt #12 accepted by the DUT |
| 6820 | yapp driver | TX pkt #13: addr=2 len=27 parity=good delay=1 |
| 6835 | **DUT** | IN  pkt #13 header: addr=2 len=27 -> channel 2 |
| 6965 | **DUT** | OUT ch2 pkt #4 done: 65 bytes in 89 cycles |
| 6965 | ch2 monitor | ch2 RX pkt #4: addr=2 len=63 parity=good |
| 6965 | scoreboard | ch2 pkt matched: addr=2 len=63 (7 matched so far) |
| 6975 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=27 (receiver waited 0 cycle(s)) |
| 7050 | ch2 driver | ch2: packet consumed (response delay 23) |
| 7075 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x6a held (pkt #13) |
| 7475 | **DUT** | SUSPEND released after 40 cycle(s) |
| 7515 | **DUT** | IN  pkt #13 complete: addr=2 len=27 parity=ok forwarded, 29 bytes in 69 cycles (held 40) |
| 7515 | yapp monitor | RX pkt #13 on the input: addr=2 len=27 parity=good gap=1 |
| 7515 | reference | Packet forwarded: addr=2 len=27 -> channel 2 |
| 7520 | yapp driver | TX pkt #13 accepted by the DUT |
| 7520 | yapp driver | TX pkt #14: addr=0 len=63 parity=good delay=1 |
| 7535 | **DUT** | IN  pkt #14 header: addr=0 len=63 -> channel 0 |
| 7665 | **DUT** | OUT ch2 pkt #5 done: 29 bytes in 70 cycles |
| 7665 | ch2 monitor | ch2 RX pkt #5: addr=2 len=27 parity=good |
| 7665 | scoreboard | ch2 pkt matched: addr=2 len=27 (8 matched so far) |
| 7695 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x0a held (pkt #14) |
| 7785 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=63 (receiver waited 24 cycle(s)) |
| 7795 | **DUT** | SUSPEND released after 10 cycle(s) |
| 7920 | ch2 driver | ch2: packet consumed (response delay 40) |
| 8275 | **DUT** | IN  pkt #14 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 75 cycles (held 10) |
| 8275 | yapp monitor | RX pkt #14 on the input: addr=0 len=63 parity=good gap=1 |
| 8275 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 8280 | yapp driver | TX pkt #14 accepted by the DUT |
| 8280 | yapp driver | TX pkt #15: addr=0 len=50 parity=good delay=13 |
| 8415 | **DUT** | IN  pkt #15 header: addr=0 len=50 -> channel 0 |
| 8420 | ch0 driver | ch0: packet consumed (response delay 24) |
| 8565 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x05 held (pkt #15) |
| 8785 | **DUT** | OUT ch0 pkt #3 done: 65 bytes in 101 cycles |
| 8785 | ch0 monitor | ch0 RX pkt #3: addr=0 len=63 parity=good |
| 8785 | scoreboard | ch0 pkt matched: addr=0 len=63 (9 matched so far) |
| 8795 | **DUT** | SUSPEND released after 23 cycle(s) |
| 8795 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=50 (receiver waited 0 cycle(s)) |
| 9155 | **DUT** | IN  pkt #15 complete: addr=0 len=50 parity=ok forwarded, 52 bytes in 75 cycles (held 23) |
| 9155 | yapp monitor | RX pkt #15 on the input: addr=0 len=50 parity=good gap=13 |
| 9155 | reference | Packet forwarded: addr=0 len=50 -> channel 0 |
| 9160 | yapp driver | TX pkt #15 accepted by the DUT |
| 9160 | yapp driver | TX pkt #16: addr=2 len=57 parity=good delay=1 |
| 9175 | **DUT** | IN  pkt #16 header: addr=2 len=57 -> channel 2 |
| 9210 | ch0 driver | ch0: packet consumed (response delay 35) |
| 9335 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x41 held (pkt #16) |
| 9415 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=57 (receiver waited 23 cycle(s)) |
| 9425 | **DUT** | SUSPEND released after 9 cycle(s) |
| 9525 | **DUT** | OUT ch0 pkt #4 done: 52 bytes in 74 cycles |
| 9525 | ch0 monitor | ch0 RX pkt #4: addr=0 len=50 parity=good |
| 9525 | scoreboard | ch0 pkt matched: addr=0 len=50 (10 matched so far) |
| 9720 | ch0 driver | ch0: packet consumed (response delay 21) |
| 9845 | **DUT** | IN  pkt #16 complete: addr=2 len=57 parity=ok forwarded, 59 bytes in 68 cycles (held 9) |
| 9845 | yapp monitor | RX pkt #16 on the input: addr=2 len=57 parity=good gap=1 |
| 9845 | reference | Packet forwarded: addr=2 len=57 -> channel 2 |
| 9850 | yapp driver | TX pkt #16 accepted by the DUT |
| 9850 | **test** | STAGE: burst 2/6 sent: addr0..3 4/0/4/0, bad parity 0, gap 0 0, length 7..63 |
| 9870 | hbus driver | Executed WRITE addr=0x1000 data=0xca |
| 9875 | **DUT** | CONFIG router_en=1 maxpktsize=10 |
| 9875 | hbus monitor | Collected WRITE addr=0x1000 data=0xca |
| 9875 | reference | maxpktsize is now 10 |
| 9890 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 9895 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 9895 | reference | router_en is now 1 (en_reg 0xff) |
| 9910 | hbus driver | Executed WRITE addr=0x116a data=0x62 |
| 9915 | hbus monitor | Collected WRITE addr=0x116a data=0x62 |
| 9940 | hbus driver | Executed READ  addr=0x116a data=0x62 |
| 9945 | hbus monitor | Collected READ  addr=0x116a data=0x62 |
| 9960 | hbus driver | Executed WRITE addr=0x11ee data=0x86 |
| 9965 | hbus monitor | Collected WRITE addr=0x11ee data=0x86 |
| 9990 | ch2 driver | ch2: packet consumed (response delay 23) |
| 9990 | hbus driver | Executed READ  addr=0x11ee data=0x86 |
| 9995 | hbus monitor | Collected READ  addr=0x11ee data=0x86 |
| 10020 | hbus driver | Executed READ  addr=0x10da data=0x00 |
| 10025 | hbus monitor | Collected READ  addr=0x10da data=0x00 |
| 10040 | hbus driver | Executed WRITE addr=0x1102 data=0xab |
| 10045 | hbus monitor | Collected WRITE addr=0x1102 data=0xab |
| 10070 | hbus driver | Executed READ  addr=0x1102 data=0xab |
| 10075 | hbus monitor | Collected READ  addr=0x1102 data=0xab |
| 10100 | hbus driver | Executed READ  addr=0x1005 data=0x05 |
| 10105 | hbus monitor | Collected READ  addr=0x1005 data=0x05 |
| 10130 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 10130 | **test** | STAGE: burst 3/6: ctrl=0xca (maxpktsize 10) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 10130 | yapp driver | TX pkt #17: addr=2 len=55 parity=bad delay=3 |
| 10135 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10175 | **DUT** | IN  pkt #17 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 10) |
| 10405 | **DUT** | OUT ch2 pkt #6 done: 59 bytes in 100 cycles |
| 10405 | ch2 monitor | ch2 RX pkt #6: addr=2 len=57 parity=good |
| 10405 | scoreboard | ch2 pkt matched: addr=2 len=57 (11 matched so far) |
| 10460 | ch2 driver | ch2: packet consumed (response delay 40) |
| 10735 | **DUT** | IN  pkt #17 complete: addr=2 len=55 parity=BAD dropped, 57 bytes in 57 cycles (held 0) |
| 10735 | yapp monitor | RX pkt #17 on the input: addr=2 len=55 parity=bad gap=32 |
| 10735 | reference | Packet dropped: length 55 > maxpktsize 10 (addr=2) |
| 10735 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 10740 | yapp driver | TX pkt #17 accepted by the DUT |
| 10740 | yapp driver | TX pkt #18: addr=2 len=11 parity=good delay=0 |
| 10745 | **DUT** | IN  pkt #18 header: addr=2 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 10770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 10770 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 10865 | **DUT** | IN  pkt #18 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 10865 | yapp monitor | RX pkt #18 on the input: addr=2 len=11 parity=good gap=0 |
| 10865 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=2) |
| 10865 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (length > maxpktsize) |
| 10870 | yapp driver | TX pkt #18 accepted by the DUT |
| 10870 | yapp driver | TX pkt #19: addr=1 len=50 parity=good delay=7 |
| 10945 | **DUT** | IN  pkt #19 header: addr=1 len=50 -> DROP (oversized: len 50 > maxpktsize 10) |
| 11455 | **DUT** | IN  pkt #19 complete: addr=1 len=50 parity=ok dropped, 52 bytes in 52 cycles (held 0) |
| 11455 | yapp monitor | RX pkt #19 on the input: addr=1 len=50 parity=good gap=7 |
| 11455 | reference | Packet dropped: length 50 > maxpktsize 10 (addr=1) |
| 11455 | **DUT** | ROUTER DROPS PACKET addr=1 length=50 (length > maxpktsize) |
| 11460 | yapp driver | TX pkt #19 accepted by the DUT |
| 11460 | yapp driver | TX pkt #20: addr=0 len=11 parity=bad delay=1 |
| 11475 | **DUT** | IN  pkt #20 header: addr=0 len=11 -> DROP (oversized: len 11 > maxpktsize 10) |
| 11595 | **DUT** | IN  pkt #20 complete: addr=0 len=11 parity=BAD dropped, 13 bytes in 13 cycles (held 0) |
| 11595 | yapp monitor | RX pkt #20 on the input: addr=0 len=11 parity=bad gap=1 |
| 11595 | reference | Packet dropped: length 11 > maxpktsize 10 (addr=0) |
| 11595 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (length > maxpktsize) |
| 11600 | yapp driver | TX pkt #20 accepted by the DUT |
| 11600 | yapp driver | TX pkt #21: addr=1 len=8 parity=good delay=7 |
| 11630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 11630 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 11675 | **DUT** | IN  pkt #21 header: addr=1 len=8 -> channel 1 |
| 11745 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=8 (receiver waited 6 cycle(s)) |
| 11765 | **DUT** | IN  pkt #21 complete: addr=1 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 11765 | yapp monitor | RX pkt #21 on the input: addr=1 len=8 parity=good gap=7 |
| 11765 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 11770 | yapp driver | TX pkt #21 accepted by the DUT |
| 11770 | yapp driver | TX pkt #22: addr=2 len=37 parity=good delay=20 |
| 11830 | ch1 driver | ch1: packet consumed (response delay 6) |
| 11925 | **DUT** | OUT ch1 pkt #2 done: 10 bytes in 19 cycles |
| 11925 | ch1 monitor | ch1 RX pkt #2: addr=1 len=8 parity=good |
| 11925 | scoreboard | ch1 pkt matched: addr=1 len=8 (12 matched so far) |
| 11975 | **DUT** | IN  pkt #22 header: addr=2 len=37 -> DROP (oversized: len 37 > maxpktsize 10) |
| 11990 | ch1 driver | ch1: packet consumed (response delay 8) |
| 12355 | **DUT** | IN  pkt #22 complete: addr=2 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 12355 | yapp monitor | RX pkt #22 on the input: addr=2 len=37 parity=good gap=20 |
| 12355 | reference | Packet dropped: length 37 > maxpktsize 10 (addr=2) |
| 12355 | **DUT** | ROUTER DROPS PACKET addr=2 length=37 (length > maxpktsize) |
| 12360 | yapp driver | TX pkt #22 accepted by the DUT |
| 12360 | yapp driver | TX pkt #23: addr=0 len=63 parity=good delay=1 |
| 12375 | **DUT** | IN  pkt #23 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 10) |
| 13015 | **DUT** | IN  pkt #23 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 13015 | yapp monitor | RX pkt #23 on the input: addr=0 len=63 parity=good gap=1 |
| 13015 | reference | Packet dropped: length 63 > maxpktsize 10 (addr=0) |
| 13015 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 13020 | yapp driver | TX pkt #23 accepted by the DUT |
| 13020 | yapp driver | TX pkt #24: addr=2 len=58 parity=good delay=8 |
| 13105 | **DUT** | IN  pkt #24 header: addr=2 len=58 -> DROP (oversized: len 58 > maxpktsize 10) |
| 13695 | **DUT** | IN  pkt #24 complete: addr=2 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 13695 | yapp monitor | RX pkt #24 on the input: addr=2 len=58 parity=good gap=8 |
| 13695 | reference | Packet dropped: length 58 > maxpktsize 10 (addr=2) |
| 13695 | **DUT** | ROUTER DROPS PACKET addr=2 length=58 (length > maxpktsize) |
| 13700 | yapp driver | TX pkt #24 accepted by the DUT |
| 13700 | **test** | STAGE: burst 3/6 sent: addr0..3 2/2/4/0, bad parity 2, gap 0 1, length 8..63 |
| 13720 | hbus driver | Executed WRITE addr=0x1000 data=0x40 |
| 13725 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 13725 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 13725 | reference | maxpktsize is now 0 |
| 13740 | hbus driver | Executed WRITE addr=0x1001 data=0x3f |
| 13745 | hbus monitor | Collected WRITE addr=0x1001 data=0x3f |
| 13745 | reference | router_en is now 1 (en_reg 0x3f) |
| 13770 | hbus driver | Executed READ  addr=0x1005 data=0x0c |
| 13775 | hbus monitor | Collected READ  addr=0x1005 data=0x0c |
| 13790 | hbus driver | Executed WRITE addr=0x1184 data=0x7f |
| 13795 | hbus monitor | Collected WRITE addr=0x1184 data=0x7f |
| 13820 | hbus driver | Executed READ  addr=0x1184 data=0x7f |
| 13825 | hbus monitor | Collected READ  addr=0x1184 data=0x7f |
| 13840 | hbus driver | Executed WRITE addr=0x119d data=0xf9 |
| 13845 | hbus monitor | Collected WRITE addr=0x119d data=0xf9 |
| 13870 | hbus driver | Executed READ  addr=0x119d data=0xf9 |
| 13875 | hbus monitor | Collected READ  addr=0x119d data=0xf9 |
| 13890 | hbus driver | Executed WRITE addr=0x1191 data=0x62 |
| 13895 | hbus monitor | Collected WRITE addr=0x1191 data=0x62 |
| 13920 | hbus driver | Executed READ  addr=0x1191 data=0x62 |
| 13925 | hbus monitor | Collected READ  addr=0x1191 data=0x62 |
| 13950 | hbus driver | Executed READ  addr=0x10fd data=0x00 |
| 13955 | hbus monitor | Collected READ  addr=0x10fd data=0x00 |
| 13980 | hbus driver | Executed READ  addr=0x100d data=0x3a |
| 13980 | **test** | STAGE: burst 4/6: ctrl=0x40 (maxpktsize 0) en=0x3f (router on, counter enables 0011111), 8 packet(s) |
| 13980 | yapp driver | TX pkt #25: addr=0 len=31 parity=good delay=3 |
| 13985 | hbus monitor | Collected READ  addr=0x100d data=0x3a |
| 14025 | **DUT** | IN  pkt #25 header: addr=0 len=31 -> DROP (oversized: len 31 > maxpktsize 0) |
| 14345 | **DUT** | IN  pkt #25 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 14345 | yapp monitor | RX pkt #25 on the input: addr=0 len=31 parity=good gap=32 |
| 14345 | reference | Packet dropped: length 31 > maxpktsize 0 (addr=0) |
| 14345 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (length > maxpktsize) |
| 14350 | yapp driver | TX pkt #25 accepted by the DUT |
| 14350 | yapp driver | TX pkt #26: addr=2 len=26 parity=good delay=20 |
| 14555 | **DUT** | IN  pkt #26 header: addr=2 len=26 -> DROP (oversized: len 26 > maxpktsize 0) |
| 14825 | **DUT** | IN  pkt #26 complete: addr=2 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 14825 | yapp monitor | RX pkt #26 on the input: addr=2 len=26 parity=good gap=20 |
| 14825 | reference | Packet dropped: length 26 > maxpktsize 0 (addr=2) |
| 14825 | **DUT** | ROUTER DROPS PACKET addr=2 length=26 (length > maxpktsize) |
| 14830 | yapp driver | TX pkt #26 accepted by the DUT |
| 14830 | yapp driver | TX pkt #27: addr=2 len=53 parity=good delay=0 |
| 14835 | **DUT** | IN  pkt #27 header: addr=2 len=53 -> DROP (oversized: len 53 > maxpktsize 0) |
| 15375 | **DUT** | IN  pkt #27 complete: addr=2 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 15375 | yapp monitor | RX pkt #27 on the input: addr=2 len=53 parity=good gap=0 |
| 15375 | reference | Packet dropped: length 53 > maxpktsize 0 (addr=2) |
| 15375 | **DUT** | ROUTER DROPS PACKET addr=2 length=53 (length > maxpktsize) |
| 15380 | yapp driver | TX pkt #27 accepted by the DUT |
| 15380 | yapp driver | TX pkt #28: addr=1 len=4 parity=good delay=1 |
| 15395 | **DUT** | IN  pkt #28 header: addr=1 len=4 -> DROP (oversized: len 4 > maxpktsize 0) |
| 15445 | **DUT** | IN  pkt #28 complete: addr=1 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 15445 | yapp monitor | RX pkt #28 on the input: addr=1 len=4 parity=good gap=1 |
| 15445 | reference | Packet dropped: length 4 > maxpktsize 0 (addr=1) |
| 15445 | **DUT** | ROUTER DROPS PACKET addr=1 length=4 (length > maxpktsize) |
| 15450 | yapp driver | TX pkt #28 accepted by the DUT |
| 15450 | yapp driver | TX pkt #29: addr=0 len=31 parity=good delay=13 |
| 15585 | **DUT** | IN  pkt #29 header: addr=0 len=31 -> DROP (oversized: len 31 > maxpktsize 0) |
| 15905 | **DUT** | IN  pkt #29 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 15905 | yapp monitor | RX pkt #29 on the input: addr=0 len=31 parity=good gap=13 |
| 15905 | reference | Packet dropped: length 31 > maxpktsize 0 (addr=0) |
| 15905 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (length > maxpktsize) |
| 15910 | yapp driver | TX pkt #29 accepted by the DUT |
| 15910 | yapp driver | TX pkt #30: addr=2 len=1 parity=bad delay=1 |
| 15925 | **DUT** | IN  pkt #30 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 15945 | **DUT** | IN  pkt #30 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 15945 | yapp monitor | RX pkt #30 on the input: addr=2 len=1 parity=bad gap=1 |
| 15945 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 15945 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 15950 | yapp driver | TX pkt #30 accepted by the DUT |
| 15950 | yapp driver | TX pkt #31: addr=2 len=14 parity=good delay=1 |
| 15965 | **DUT** | IN  pkt #31 header: addr=2 len=14 -> DROP (oversized: len 14 > maxpktsize 0) |
| 16010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 16010 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 16115 | **DUT** | IN  pkt #31 complete: addr=2 len=14 parity=ok dropped, 16 bytes in 16 cycles (held 0) |
| 16115 | yapp monitor | RX pkt #31 on the input: addr=2 len=14 parity=good gap=1 |
| 16115 | reference | Packet dropped: length 14 > maxpktsize 0 (addr=2) |
| 16115 | **DUT** | ROUTER DROPS PACKET addr=2 length=14 (length > maxpktsize) |
| 16120 | yapp driver | TX pkt #31 accepted by the DUT |
| 16120 | yapp driver | TX pkt #32: addr=2 len=23 parity=bad delay=20 |
| 16325 | **DUT** | IN  pkt #32 header: addr=2 len=23 -> DROP (oversized: len 23 > maxpktsize 0) |
| 16565 | **DUT** | IN  pkt #32 complete: addr=2 len=23 parity=BAD dropped, 25 bytes in 25 cycles (held 0) |
| 16565 | yapp monitor | RX pkt #32 on the input: addr=2 len=23 parity=bad gap=20 |
| 16565 | reference | Packet dropped: length 23 > maxpktsize 0 (addr=2) |
| 16565 | **DUT** | ROUTER DROPS PACKET addr=2 length=23 (length > maxpktsize) |
| 16570 | yapp driver | TX pkt #32 accepted by the DUT |
| 16570 | **test** | STAGE: burst 4/6 sent: addr0..3 2/1/5/0, bad parity 2, gap 0 1, length 1..53 |
| 16590 | hbus driver | Executed WRITE addr=0x1000 data=0xf4 |
| 16595 | **DUT** | CONFIG router_en=1 maxpktsize=52 |
| 16595 | hbus monitor | Collected WRITE addr=0x1000 data=0xf4 |
| 16595 | reference | maxpktsize is now 52 |
| 16610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 16610 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 16610 | hbus driver | Executed WRITE addr=0x1001 data=0x00 |
| 16615 | **DUT** | CONFIG router_en=0 maxpktsize=52 |
| 16615 | hbus monitor | Collected WRITE addr=0x1001 data=0x00 |
| 16615 | reference | router_en is now 0 (en_reg 0x00) |
| 16640 | hbus driver | Executed READ  addr=0x1001 data=0x00 |
| 16645 | hbus monitor | Collected READ  addr=0x1001 data=0x00 |
| 16670 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 16675 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16700 | hbus driver | Executed READ  addr=0x1031 data=0xa7 |
| 16705 | hbus monitor | Collected READ  addr=0x1031 data=0xa7 |
| 16730 | hbus driver | Executed READ  addr=0x1088 data=0x00 |
| 16735 | hbus monitor | Collected READ  addr=0x1088 data=0x00 |
| 16760 | hbus driver | Executed READ  addr=0x100d data=0x17 |
| 16765 | hbus monitor | Collected READ  addr=0x100d data=0x17 |
| 16790 | hbus driver | Executed READ  addr=0x100d data=0x17 |
| 16790 | **test** | STAGE: burst 5/6: ctrl=0xf4 (maxpktsize 52) en=0x00 (router OFF, counter enables 0000000), 10 packet(s) |
| 16790 | yapp driver | TX pkt #33: addr=1 len=4 parity=good delay=0 |
| 16795 | hbus monitor | Collected READ  addr=0x100d data=0x17 |
| 16805 | **DUT** | IN  pkt #33 header: addr=1 len=4 -> DROP (router disabled) |
| 16855 | **DUT** | IN  pkt #33 complete: addr=1 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 16855 | yapp monitor | RX pkt #33 on the input: addr=1 len=4 parity=good gap=23 |
| 16855 | reference | Packet dropped: router disabled (addr=1 len=4) |
| 16855 | **DUT** | ROUTER DROPS PACKET addr=1 length=4 (router disabled) |
| 16860 | yapp driver | TX pkt #33 accepted by the DUT |
| 16860 | yapp driver | TX pkt #34: addr=2 len=4 parity=good delay=11 |
| 16975 | **DUT** | IN  pkt #34 header: addr=2 len=4 -> DROP (router disabled) |
| 17025 | **DUT** | IN  pkt #34 complete: addr=2 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 17025 | yapp monitor | RX pkt #34 on the input: addr=2 len=4 parity=good gap=11 |
| 17025 | reference | Packet dropped: router disabled (addr=2 len=4) |
| 17025 | **DUT** | ROUTER DROPS PACKET addr=2 length=4 (router disabled) |
| 17030 | yapp driver | TX pkt #34 accepted by the DUT |
| 17030 | yapp driver | TX pkt #35: addr=1 len=44 parity=good delay=12 |
| 17155 | **DUT** | IN  pkt #35 header: addr=1 len=44 -> DROP (router disabled) |
| 17605 | **DUT** | IN  pkt #35 complete: addr=1 len=44 parity=ok dropped, 46 bytes in 46 cycles (held 0) |
| 17605 | yapp monitor | RX pkt #35 on the input: addr=1 len=44 parity=good gap=12 |
| 17605 | reference | Packet dropped: router disabled (addr=1 len=44) |
| 17605 | **DUT** | ROUTER DROPS PACKET addr=1 length=44 (router disabled) |
| 17610 | yapp driver | TX pkt #35 accepted by the DUT |
| 17610 | yapp driver | TX pkt #36: addr=2 len=53 parity=good delay=0 |
| 17615 | **DUT** | IN  pkt #36 header: addr=2 len=53 -> DROP (router disabled) |
| 18155 | **DUT** | IN  pkt #36 complete: addr=2 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 18155 | yapp monitor | RX pkt #36 on the input: addr=2 len=53 parity=good gap=0 |
| 18155 | reference | Packet dropped: router disabled (addr=2 len=53) |
| 18155 | **DUT** | ROUTER DROPS PACKET addr=2 length=53 (router disabled) |
| 18160 | yapp driver | TX pkt #36 accepted by the DUT |
| 18160 | yapp driver | TX pkt #37: addr=0 len=1 parity=good delay=4 |
| 18205 | **DUT** | IN  pkt #37 header: addr=0 len=1 -> DROP (router disabled) |
| 18225 | **DUT** | IN  pkt #37 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 18225 | yapp monitor | RX pkt #37 on the input: addr=0 len=1 parity=good gap=4 |
| 18225 | reference | Packet dropped: router disabled (addr=0 len=1) |
| 18225 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (router disabled) |
| 18230 | yapp driver | TX pkt #37 accepted by the DUT |
| 18230 | yapp driver | TX pkt #38: addr=1 len=63 parity=good delay=20 |
| 18435 | **DUT** | IN  pkt #38 header: addr=1 len=63 -> DROP (router disabled) |
| 19075 | **DUT** | IN  pkt #38 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 19075 | yapp monitor | RX pkt #38 on the input: addr=1 len=63 parity=good gap=20 |
| 19075 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 19075 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 19080 | yapp driver | TX pkt #38 accepted by the DUT |
| 19080 | yapp driver | TX pkt #39: addr=2 len=56 parity=good delay=1 |
| 19095 | **DUT** | IN  pkt #39 header: addr=2 len=56 -> DROP (router disabled) |
| 19665 | **DUT** | IN  pkt #39 complete: addr=2 len=56 parity=ok dropped, 58 bytes in 58 cycles (held 0) |
| 19665 | yapp monitor | RX pkt #39 on the input: addr=2 len=56 parity=good gap=1 |
| 19665 | reference | Packet dropped: router disabled (addr=2 len=56) |
| 19665 | **DUT** | ROUTER DROPS PACKET addr=2 length=56 (router disabled) |
| 19670 | yapp driver | TX pkt #39 accepted by the DUT |
| 19670 | yapp driver | TX pkt #40: addr=1 len=15 parity=good delay=1 |
| 19685 | **DUT** | IN  pkt #40 header: addr=1 len=15 -> DROP (router disabled) |
| 19845 | **DUT** | IN  pkt #40 complete: addr=1 len=15 parity=ok dropped, 17 bytes in 17 cycles (held 0) |
| 19845 | yapp monitor | RX pkt #40 on the input: addr=1 len=15 parity=good gap=1 |
| 19845 | reference | Packet dropped: router disabled (addr=1 len=15) |
| 19845 | **DUT** | ROUTER DROPS PACKET addr=1 length=15 (router disabled) |
| 19850 | yapp driver | TX pkt #40 accepted by the DUT |
| 19850 | yapp driver | TX pkt #41: addr=0 len=63 parity=bad delay=10 |
| 19955 | **DUT** | IN  pkt #41 header: addr=0 len=63 -> DROP (router disabled) |
| 20595 | **DUT** | IN  pkt #41 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 20595 | yapp monitor | RX pkt #41 on the input: addr=0 len=63 parity=bad gap=10 |
| 20595 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 20595 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 20600 | yapp driver | TX pkt #41 accepted by the DUT |
| 20600 | yapp driver | TX pkt #42: addr=0 len=20 parity=bad delay=15 |
| 20755 | **DUT** | IN  pkt #42 header: addr=0 len=20 -> DROP (router disabled) |
| 20965 | **DUT** | IN  pkt #42 complete: addr=0 len=20 parity=BAD dropped, 22 bytes in 22 cycles (held 0) |
| 20965 | yapp monitor | RX pkt #42 on the input: addr=0 len=20 parity=bad gap=15 |
| 20965 | reference | Packet dropped: router disabled (addr=0 len=20) |
| 20965 | **DUT** | ROUTER DROPS PACKET addr=0 length=20 (router disabled) |
| 20970 | yapp driver | TX pkt #42 accepted by the DUT |
| 20970 | **test** | STAGE: burst 5/6 sent: addr0..3 3/4/3/0, bad parity 2, gap 0 2, length 1..63 |
| 20990 | hbus driver | Executed WRITE addr=0x1000 data=0xc0 |
| 20995 | **DUT** | CONFIG router_en=0 maxpktsize=0 |
| 20995 | hbus monitor | Collected WRITE addr=0x1000 data=0xc0 |
| 20995 | reference | maxpktsize is now 0 |
| 21010 | hbus driver | Executed WRITE addr=0x1001 data=0x7c |
| 21015 | hbus monitor | Collected WRITE addr=0x1001 data=0x7c |
| 21015 | reference | router_en is now 0 (en_reg 0x7c) |
| 21040 | hbus driver | Executed READ  addr=0x101c data=0x46 |
| 21045 | hbus monitor | Collected READ  addr=0x101c data=0x46 |
| 21070 | hbus driver | Executed READ  addr=0x100d data=0x17 |
| 21075 | hbus monitor | Collected READ  addr=0x100d data=0x17 |
| 21100 | hbus driver | Executed READ  addr=0x100d data=0x17 |
| 21100 | **test** | STAGE: burst 6/6: ctrl=0xc0 (maxpktsize 0) en=0x7c (router OFF, counter enables 0111110), 8 packet(s) |
| 21100 | yapp driver | TX pkt #43: addr=1 len=29 parity=good delay=16 |
| 21105 | hbus monitor | Collected READ  addr=0x100d data=0x17 |
| 21275 | **DUT** | IN  pkt #43 header: addr=1 len=29 -> DROP (router disabled) |
| 21575 | **DUT** | IN  pkt #43 complete: addr=1 len=29 parity=ok dropped, 31 bytes in 31 cycles (held 0) |
| 21575 | yapp monitor | RX pkt #43 on the input: addr=1 len=29 parity=good gap=30 |
| 21575 | reference | Packet dropped: router disabled (addr=1 len=29) |
| 21575 | **DUT** | ROUTER DROPS PACKET addr=1 length=29 (router disabled) |
| 21580 | yapp driver | TX pkt #43 accepted by the DUT |
| 21580 | yapp driver | TX pkt #44: addr=1 len=58 parity=good delay=6 |
| 21645 | **DUT** | IN  pkt #44 header: addr=1 len=58 -> DROP (router disabled) |
| 22235 | **DUT** | IN  pkt #44 complete: addr=1 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 22235 | yapp monitor | RX pkt #44 on the input: addr=1 len=58 parity=good gap=6 |
| 22235 | reference | Packet dropped: router disabled (addr=1 len=58) |
| 22235 | **DUT** | ROUTER DROPS PACKET addr=1 length=58 (router disabled) |
| 22240 | yapp driver | TX pkt #44 accepted by the DUT |
| 22240 | yapp driver | TX pkt #45: addr=0 len=39 parity=good delay=3 |
| 22275 | **DUT** | IN  pkt #45 header: addr=0 len=39 -> DROP (router disabled) |
| 22675 | **DUT** | IN  pkt #45 complete: addr=0 len=39 parity=ok dropped, 41 bytes in 41 cycles (held 0) |
| 22675 | yapp monitor | RX pkt #45 on the input: addr=0 len=39 parity=good gap=3 |
| 22675 | reference | Packet dropped: router disabled (addr=0 len=39) |
| 22675 | **DUT** | ROUTER DROPS PACKET addr=0 length=39 (router disabled) |
| 22680 | yapp driver | TX pkt #45 accepted by the DUT |
| 22680 | yapp driver | TX pkt #46: addr=1 len=9 parity=good delay=0 |
| 22685 | **DUT** | IN  pkt #46 header: addr=1 len=9 -> DROP (router disabled) |
| 22785 | **DUT** | IN  pkt #46 complete: addr=1 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 22785 | yapp monitor | RX pkt #46 on the input: addr=1 len=9 parity=good gap=0 |
| 22785 | reference | Packet dropped: router disabled (addr=1 len=9) |
| 22785 | **DUT** | ROUTER DROPS PACKET addr=1 length=9 (router disabled) |
| 22790 | yapp driver | TX pkt #46 accepted by the DUT |
| 22790 | yapp driver | TX pkt #47: addr=2 len=1 parity=good delay=1 |
| 22805 | **DUT** | IN  pkt #47 header: addr=2 len=1 -> DROP (router disabled) |
| 22825 | **DUT** | IN  pkt #47 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 22825 | yapp monitor | RX pkt #47 on the input: addr=2 len=1 parity=good gap=1 |
| 22825 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 22825 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 22830 | yapp driver | TX pkt #47 accepted by the DUT |
| 22830 | yapp driver | TX pkt #48: addr=1 len=9 parity=good delay=3 |
| 22865 | **DUT** | IN  pkt #48 header: addr=1 len=9 -> DROP (router disabled) |
| 22965 | **DUT** | IN  pkt #48 complete: addr=1 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 22965 | yapp monitor | RX pkt #48 on the input: addr=1 len=9 parity=good gap=3 |
| 22965 | reference | Packet dropped: router disabled (addr=1 len=9) |
| 22965 | **DUT** | ROUTER DROPS PACKET addr=1 length=9 (router disabled) |
| 22970 | yapp driver | TX pkt #48 accepted by the DUT |
| 22970 | yapp driver | TX pkt #49: addr=0 len=39 parity=good delay=0 |
| 22975 | **DUT** | IN  pkt #49 header: addr=0 len=39 -> DROP (router disabled) |
| 23375 | **DUT** | IN  pkt #49 complete: addr=0 len=39 parity=ok dropped, 41 bytes in 41 cycles (held 0) |
| 23375 | yapp monitor | RX pkt #49 on the input: addr=0 len=39 parity=good gap=0 |
| 23375 | reference | Packet dropped: router disabled (addr=0 len=39) |
| 23375 | **DUT** | ROUTER DROPS PACKET addr=0 length=39 (router disabled) |
| 23380 | yapp driver | TX pkt #49 accepted by the DUT |
| 23380 | yapp driver | TX pkt #50: addr=0 len=1 parity=good delay=2 |
| 23405 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> DROP (router disabled) |
| 23425 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 23425 | yapp monitor | RX pkt #50 on the input: addr=0 len=1 parity=good gap=2 |
| 23425 | reference | Packet dropped: router disabled (addr=0 len=1) |
| 23425 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (router disabled) |
| 23430 | yapp driver | TX pkt #50 accepted by the DUT |
| 23430 | **test** | STAGE: burst 6/6 sent: addr0..3 3/4/1/0, bad parity 0, gap 0 2, length 1..58 |
| 23430 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 23460 | hbus driver | Executed READ  addr=0x1000 data=0xc0 |
| 23465 | hbus monitor | Collected READ  addr=0x1000 data=0xc0 |
| 23490 | hbus driver | Executed READ  addr=0x1001 data=0x7c |
| 23495 | hbus monitor | Collected READ  addr=0x1001 data=0x7c |
| 23520 | hbus driver | Executed READ  addr=0x1004 data=0x05 |
| 23525 | hbus monitor | Collected READ  addr=0x1004 data=0x05 |
| 23550 | hbus driver | Executed READ  addr=0x1005 data=0x14 |
| 23555 | hbus monitor | Collected READ  addr=0x1005 data=0x14 |
| 23580 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 23585 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23610 | hbus driver | Executed READ  addr=0x1009 data=0x09 |
| 23615 | hbus monitor | Collected READ  addr=0x1009 data=0x09 |
| 23640 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 23645 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 23670 | hbus driver | Executed READ  addr=0x100b data=0x0e |
| 23675 | hbus monitor | Collected READ  addr=0x100b data=0x0e |
| 23700 | hbus driver | Executed READ  addr=0x100d data=0x17 |
| 23705 | hbus monitor | Collected READ  addr=0x100d data=0x17 |
| 23730 | hbus driver | Executed READ  addr=0x1010 data=0x5e |
| 23735 | hbus monitor | Collected READ  addr=0x1010 data=0x5e |
| 23760 | hbus driver | Executed READ  addr=0x1011 data=0xf5 |
| 23765 | hbus monitor | Collected READ  addr=0x1011 data=0xf5 |
| 23790 | hbus driver | Executed READ  addr=0x1012 data=0xf6 |
| 23795 | hbus monitor | Collected READ  addr=0x1012 data=0xf6 |
| 23820 | hbus driver | Executed READ  addr=0x1013 data=0x16 |
| 23825 | hbus monitor | Collected READ  addr=0x1013 data=0x16 |
| 23850 | hbus driver | Executed READ  addr=0x1014 data=0xd4 |
| 23855 | hbus monitor | Collected READ  addr=0x1014 data=0xd4 |
| 23880 | hbus driver | Executed READ  addr=0x1015 data=0xda |
| 23885 | hbus monitor | Collected READ  addr=0x1015 data=0xda |
| 23910 | hbus driver | Executed READ  addr=0x1016 data=0x2c |
| 23915 | hbus monitor | Collected READ  addr=0x1016 data=0x2c |
| 23940 | hbus driver | Executed READ  addr=0x1017 data=0xe7 |
| 23945 | hbus monitor | Collected READ  addr=0x1017 data=0xe7 |
| 23970 | hbus driver | Executed READ  addr=0x1018 data=0xec |
| 23975 | hbus monitor | Collected READ  addr=0x1018 data=0xec |
| 24000 | hbus driver | Executed READ  addr=0x1019 data=0xa8 |
| 24005 | hbus monitor | Collected READ  addr=0x1019 data=0xa8 |
| 24030 | hbus driver | Executed READ  addr=0x101a data=0x5f |
| 24035 | hbus monitor | Collected READ  addr=0x101a data=0x5f |
| 24060 | hbus driver | Executed READ  addr=0x101b data=0xab |
| 24065 | hbus monitor | Collected READ  addr=0x101b data=0xab |
| 24090 | hbus driver | Executed READ  addr=0x101c data=0x46 |
| 24095 | hbus monitor | Collected READ  addr=0x101c data=0x46 |
| 24120 | hbus driver | Executed READ  addr=0x101d data=0xf9 |
| 24125 | hbus monitor | Collected READ  addr=0x101d data=0xf9 |
| 24150 | hbus driver | Executed READ  addr=0x101e data=0x1d |
| 24155 | hbus monitor | Collected READ  addr=0x101e data=0x1d |
| 24180 | hbus driver | Executed READ  addr=0x101f data=0xcb |
| 24185 | hbus monitor | Collected READ  addr=0x101f data=0xcb |
| 24210 | hbus driver | Executed READ  addr=0x1020 data=0x2d |
| 24215 | hbus monitor | Collected READ  addr=0x1020 data=0x2d |
| 24240 | hbus driver | Executed READ  addr=0x1021 data=0x27 |
| 24245 | hbus monitor | Collected READ  addr=0x1021 data=0x27 |
| 24270 | hbus driver | Executed READ  addr=0x1022 data=0x22 |
| 24275 | hbus monitor | Collected READ  addr=0x1022 data=0x22 |
| 24300 | hbus driver | Executed READ  addr=0x1023 data=0xd8 |
| 24305 | hbus monitor | Collected READ  addr=0x1023 data=0xd8 |
| 24330 | hbus driver | Executed READ  addr=0x1024 data=0x3d |
| 24335 | hbus monitor | Collected READ  addr=0x1024 data=0x3d |
| 24360 | hbus driver | Executed READ  addr=0x1025 data=0xa0 |
| 24365 | hbus monitor | Collected READ  addr=0x1025 data=0xa0 |
| 24390 | hbus driver | Executed READ  addr=0x1026 data=0x0f |
| 24395 | hbus monitor | Collected READ  addr=0x1026 data=0x0f |
| 24420 | hbus driver | Executed READ  addr=0x1027 data=0x0c |
| 24425 | hbus monitor | Collected READ  addr=0x1027 data=0x0c |
| 24535 | **test** | STAGE: done: 50 packets (12 forwarded, 38 dropped), 0 storm burst(s), 12 scoreboard matches, 67 HBUS reads checked, 5 error pulses for 5 bad packets |
| 24735 | error checker | error pulse report: 5 bad packets, 5 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 24735 | ch0 monitor | Channel 0 report: 4 packets collected |
| 24735 | ch1 monitor | Channel 1 report: 2 packets collected |
| 24735 | ch2 monitor | Channel 2 report: 6 packets collected |
| 24735 | hbus monitor | HBUS report: 23 writes, 67 reads |
| 24735 | coverage | Coverage of the router configuration: 69.6% |
| 24735 | reference |  |
| 24735 | reference | HBUS reads checked against the model: 67 (0 mismatches, 0 of memory bytes never written) |
| 24735 | scoreboard |  |
| 24735 | yapp driver | YAPP driver report: 50 packets sent |
| 24735 | coverage | YAPP gap coverage: 49 gaps sampled, coverage 100.0% |
| 24735 | yapp monitor | YAPP monitor report: 50 packets collected, 7 with bad parity |
| 24735 | yapp monitor | YAPP gaps: 6 back to back, 11 of 1 cycle, 4 of 2, 28 longer |
| 24735 | coverage | YAPP packet coverage: 50 packets sampled, coverage 63.3% |
