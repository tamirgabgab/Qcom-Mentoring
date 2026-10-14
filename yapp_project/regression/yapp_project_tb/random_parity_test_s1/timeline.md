# random_parity_test seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 23us · wall 24.1 s · log [`random_parity_test_s1.log`](random_parity_test_s1.log)

Waves: `random_parity_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s1%2Frandom_parity_test_s1.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **94** packet(s) (28 with bad parity); the input monitor saw 94.
- Router: **60** forwarded, **34** dropped (8 illegal address 3, 15 router disabled, 11 oversized).
- Packets out: ch0 **10**, ch1 **21**, ch2 **29**.
- Scoreboard: 60 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **11** time(s), longest hold 86 cycle(s).
- Error pulses: 27.
- HBUS: 30 write(s), 49 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_SLOW, ch1 CHANNEL_RX_PROFILE_STALLY, ch2 CHANNEL_RX_PROFILE_SLOW |
| 0 | random scenario: 94 packets in 6 bursts |
| 360 | burst 1/6: ctrl=0x3f (maxpktsize 63) en=0xcb (router on, counter enables 1100101), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 1360 | burst 1/6 sent: addr0..3 2/4/8/2, bad parity 8, gap 0 14, length 1..3 |
| 1720 | burst 2/6: ctrl=0xbd (maxpktsize 61) en=0xfe (router OFF, counter enables 1111111), 15 packet(s) |
| 9260 | burst 2/6 sent: addr0..3 3/0/8/4, bad parity 1, gap 0 7, length 11..63 |
| 9490 | burst 3/6: ctrl=0xbe (maxpktsize 62) en=0x13 (router on, counter enables 0001001), 16 packet(s) |
| 19540 | burst 3/6 sent: addr0..3 2/5/6/3, bad parity 5, gap 0 5, length 1..63 |
| 19820 | burst 4/6: ctrl=0x55 (maxpktsize 21) en=0x3b (router on, counter enables 0011101), 15 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 20680 | burst 4/6 sent: addr0..3 2/6/6/1, bad parity 5, gap 0 12, length 1..3 |
| 20960 | burst 5/6: ctrl=0xc1 (maxpktsize 1) en=0x9b (router on, counter enables 1001101), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 21610 | burst 5/6 sent: addr0..3 3/3/9/1, bad parity 5, gap 0 13, length 1..3 |
| 21890 | burst 6/6: ctrl=0xea (maxpktsize 42) en=0x99 (router on, counter enables 1001100), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 22650 | burst 6/6 sent: addr0..3 3/5/5/3, bad parity 4, gap 0 16, length 1..3 |
| 22650 | final reads: every register and the stored packet, checked against the reference model |
| 23095 | done: 94 packets (60 forwarded, 34 dropped), 4 storm burst(s), 60 scoreboard matches, 44 HBUS reads checked, 27 error pulses for 27 bad packets |

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

1173 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_SLOW, ch1 CHANNEL_RX_PROFILE_STALLY, ch2 CHANNEL_RX_PROFILE_SLOW |
| 0 | **test** | STAGE: random scenario: 94 packets in 6 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 75 | reference | maxpktsize is now 63 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xcb |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xcb |
| 95 | reference | router_en is now 1 (en_reg 0xcb) |
| 120 | hbus driver | Executed READ  addr=0x1033 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x1033 data=0x00 |
| 140 | hbus driver | Executed WRITE addr=0x118c data=0x26 |
| 145 | hbus monitor | Collected WRITE addr=0x118c data=0x26 |
| 170 | hbus driver | Executed READ  addr=0x118c data=0x26 |
| 175 | hbus monitor | Collected READ  addr=0x118c data=0x26 |
| 190 | hbus driver | Executed WRITE addr=0x1128 data=0xff |
| 195 | hbus monitor | Collected WRITE addr=0x1128 data=0xff |
| 220 | hbus driver | Executed READ  addr=0x1128 data=0xff |
| 225 | hbus monitor | Collected READ  addr=0x1128 data=0xff |
| 250 | hbus driver | Executed READ  addr=0x10a3 data=0x00 |
| 255 | hbus monitor | Collected READ  addr=0x10a3 data=0x00 |
| 280 | hbus driver | Executed READ  addr=0x102e data=0x00 |
| 285 | hbus monitor | Collected READ  addr=0x102e data=0x00 |
| 300 | hbus driver | Executed WRITE addr=0x1193 data=0x7f |
| 305 | hbus monitor | Collected WRITE addr=0x1193 data=0x7f |
| 330 | hbus driver | Executed READ  addr=0x1193 data=0x7f |
| 335 | hbus monitor | Collected READ  addr=0x1193 data=0x7f |
| 360 | hbus driver | Executed READ  addr=0x1001 data=0xcb |
| 360 | **test** | STAGE: burst 1/6: ctrl=0x3f (maxpktsize 63) en=0xcb (router on, counter enables 1100101), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 360 | yapp driver | TX pkt #1: addr=1 len=2 parity=good delay=0 |
| 365 | hbus monitor | Collected READ  addr=0x1001 data=0xcb |
| 375 | **DUT** | IN  pkt #1 header: addr=1 len=2 -> channel 1 |
| 405 | **DUT** | IN  pkt #1 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 405 | yapp monitor | RX pkt #1 on the input: addr=1 len=2 parity=good gap=32 |
| 405 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 410 | yapp driver | TX pkt #1 accepted by the DUT |
| 410 | yapp driver | TX pkt #2: addr=2 len=1 parity=bad delay=3 |
| 445 | **DUT** | IN  pkt #2 header: addr=2 len=1 -> channel 2 |
| 465 | **DUT** | IN  pkt #2 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 465 | yapp monitor | RX pkt #2 on the input: addr=2 len=1 parity=bad gap=3 |
| 465 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 470 | yapp driver | TX pkt #2 accepted by the DUT |
| 470 | yapp driver | TX pkt #3: addr=2 len=1 parity=good delay=0 |
| 475 | **DUT** | IN  pkt #3 header: addr=2 len=1 -> channel 2 |
| 475 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=2 (receiver waited 9 cycle(s)) |
| 495 | **DUT** | IN  pkt #3 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 495 | yapp monitor | RX pkt #3 on the input: addr=2 len=1 parity=good gap=0 |
| 495 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 500 | ch1 driver | ch1: packet consumed (response delay 9) |
| 500 | yapp driver | TX pkt #3 accepted by the DUT |
| 500 | yapp driver | TX pkt #4: addr=2 len=3 parity=good delay=0 |
| 505 | **DUT** | IN  pkt #4 header: addr=2 len=3 -> channel 2 |
| 545 | **DUT** | IN  pkt #4 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 545 | yapp monitor | RX pkt #4 on the input: addr=2 len=3 parity=good gap=0 |
| 545 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 550 | yapp driver | TX pkt #4 accepted by the DUT |
| 550 | yapp driver | TX pkt #5: addr=2 len=1 parity=bad delay=0 |
| 555 | **DUT** | IN  pkt #5 header: addr=2 len=1 -> channel 2 |
| 570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 570 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 575 | **DUT** | IN  pkt #5 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 575 | yapp monitor | RX pkt #5 on the input: addr=2 len=1 parity=bad gap=0 |
| 575 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 580 | yapp driver | TX pkt #5 accepted by the DUT |
| 580 | yapp driver | TX pkt #6: addr=3 len=3 parity=bad delay=0 |
| 585 | **DUT** | IN  pkt #6 header: addr=3 len=3 -> DROP (illegal address 3) |
| 605 | **DUT** | OUT ch1 pkt #1 done: 4 bytes in 14 cycles |
| 605 | ch1 monitor | ch1 RX pkt #1: addr=1 len=2 parity=good |
| 605 | scoreboard | ch1 pkt matched: addr=1 len=2 (1 matched so far) |
| 625 | **DUT** | IN  pkt #6 complete: addr=3 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 625 | yapp monitor | RX pkt #6 on the input: addr=3 len=3 parity=bad gap=0 |
| 625 | reference | Packet dropped: illegal address 3 (len=3) |
| 625 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 630 | error checker | error pulse 5 cycles after the bad packet (1 still owed) |
| 630 | yapp driver | TX pkt #6 accepted by the DUT |
| 630 | yapp driver | TX pkt #7: addr=2 len=1 parity=good delay=0 |
| 635 | **DUT** | IN  pkt #7 header: addr=2 len=1 -> channel 2 |
| 655 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x81 held (pkt #7) |
| 660 | ch1 driver | ch1: packet consumed (response delay 9) |
| 675 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=1 (receiver waited 22 cycle(s)) |
| 685 | **DUT** | IN  pkt #7 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 6 cycles (held 3) |
| 685 | **DUT** | SUSPEND released after 3 cycle(s) |
| 685 | yapp monitor | RX pkt #7 on the input: addr=2 len=1 parity=good gap=0 |
| 685 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 690 | ch2 driver | ch2: packet consumed (response delay 22) |
| 690 | yapp driver | TX pkt #7 accepted by the DUT |
| 690 | yapp driver | TX pkt #8: addr=2 len=1 parity=bad delay=0 |
| 695 | **DUT** | IN  pkt #8 header: addr=2 len=1 -> channel 2 |
| 705 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xe0 held (pkt #8) |
| 730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 730 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 1015 | **DUT** | OUT ch2 pkt #1 done: 3 bytes in 35 cycles |
| 1015 | ch2 monitor | ch2 RX pkt #1: addr=2 len=1 parity=bad |
| 1015 | scoreboard | ch2 pkt matched: addr=2 len=1 (2 matched so far) |
| 1025 | **DUT** | SUSPEND released after 32 cycle(s) |
| 1025 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1035 | **DUT** | IN  pkt #8 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 35 cycles (held 32) |
| 1035 | yapp monitor | RX pkt #8 on the input: addr=2 len=1 parity=bad gap=0 |
| 1035 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 1040 | yapp driver | TX pkt #8 accepted by the DUT |
| 1040 | yapp driver | TX pkt #9: addr=1 len=2 parity=good delay=0 |
| 1045 | **DUT** | IN  pkt #9 header: addr=1 len=2 -> channel 1 |
| 1045 | **DUT** | OUT ch2 pkt #2 done: 3 bytes in 3 cycles |
| 1045 | ch2 monitor | ch2 RX pkt #2: addr=2 len=1 parity=good |
| 1045 | scoreboard | ch2 pkt matched: addr=2 len=1 (3 matched so far) |
| 1055 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 1070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 1070 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 1075 | **DUT** | IN  pkt #9 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 1075 | yapp monitor | RX pkt #9 on the input: addr=1 len=2 parity=good gap=0 |
| 1075 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 1080 | yapp driver | TX pkt #9 accepted by the DUT |
| 1080 | yapp driver | TX pkt #10: addr=3 len=2 parity=good delay=0 |
| 1085 | **DUT** | IN  pkt #10 header: addr=3 len=2 -> DROP (illegal address 3) |
| 1095 | **DUT** | OUT ch2 pkt #3 done: 5 bytes in 5 cycles |
| 1095 | ch2 monitor | ch2 RX pkt #3: addr=2 len=3 parity=good |
| 1095 | scoreboard | ch2 pkt matched: addr=2 len=3 (4 matched so far) |
| 1105 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1115 | **DUT** | IN  pkt #10 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 1115 | yapp monitor | RX pkt #10 on the input: addr=3 len=2 parity=good gap=0 |
| 1115 | reference | Packet dropped: illegal address 3 (len=2) |
| 1115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 1120 | yapp driver | TX pkt #10 accepted by the DUT |
| 1120 | yapp driver | TX pkt #11: addr=1 len=1 parity=bad delay=0 |
| 1125 | **DUT** | IN  pkt #11 header: addr=1 len=1 -> channel 1 |
| 1125 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=2 (receiver waited 7 cycle(s)) |
| 1125 | **DUT** | OUT ch2 pkt #4 done: 3 bytes in 3 cycles |
| 1125 | ch2 monitor | ch2 RX pkt #4: addr=2 len=1 parity=bad |
| 1125 | scoreboard | ch2 pkt matched: addr=2 len=1 (5 matched so far) |
| 1135 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1145 | **DUT** | IN  pkt #11 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 1145 | yapp monitor | RX pkt #11 on the input: addr=1 len=1 parity=bad gap=0 |
| 1145 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 1150 | ch1 driver | ch1: packet consumed (response delay 7) |
| 1150 | yapp driver | TX pkt #11 accepted by the DUT |
| 1150 | yapp driver | TX pkt #12: addr=2 len=1 parity=bad delay=0 |
| 1155 | **DUT** | IN  pkt #12 header: addr=2 len=1 -> channel 2 |
| 1155 | **DUT** | OUT ch2 pkt #5 done: 3 bytes in 3 cycles |
| 1155 | ch2 monitor | ch2 RX pkt #5: addr=2 len=1 parity=good |
| 1155 | scoreboard | ch2 pkt matched: addr=2 len=1 (6 matched so far) |
| 1165 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1175 | **DUT** | IN  pkt #12 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 1175 | yapp monitor | RX pkt #12 on the input: addr=2 len=1 parity=bad gap=0 |
| 1175 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 1180 | yapp driver | TX pkt #12 accepted by the DUT |
| 1180 | yapp driver | TX pkt #13: addr=1 len=3 parity=bad delay=2 |
| 1185 | **DUT** | OUT ch2 pkt #6 done: 3 bytes in 3 cycles |
| 1185 | ch2 monitor | ch2 RX pkt #6: addr=2 len=1 parity=bad |
| 1185 | scoreboard | ch2 pkt matched: addr=2 len=1 (7 matched so far) |
| 1190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet (1 more owed) |
| 1190 | error checker | error pulse 4 cycles after the bad packet (1 still owed) |
| 1195 | **DUT** | OUT ch1 pkt #2 done: 4 bytes in 8 cycles |
| 1195 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1195 | ch1 monitor | ch1 RX pkt #2: addr=1 len=2 parity=good |
| 1195 | scoreboard | ch1 pkt matched: addr=1 len=2 (8 matched so far) |
| 1200 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 1200 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 1205 | **DUT** | IN  pkt #13 header: addr=1 len=3 -> channel 1 |
| 1205 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 1215 | **DUT** | OUT ch2 pkt #7 done: 3 bytes in 3 cycles |
| 1215 | ch2 monitor | ch2 RX pkt #7: addr=2 len=1 parity=bad |
| 1215 | scoreboard | ch2 pkt matched: addr=2 len=1 (9 matched so far) |
| 1225 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 3 cycles |
| 1225 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=bad |
| 1225 | scoreboard | ch1 pkt matched: addr=1 len=1 (10 matched so far) |
| 1235 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 1245 | **DUT** | IN  pkt #13 complete: addr=1 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 1245 | yapp monitor | RX pkt #13 on the input: addr=1 len=3 parity=bad gap=2 |
| 1245 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 1250 | yapp driver | TX pkt #13 accepted by the DUT |
| 1250 | yapp driver | TX pkt #14: addr=0 len=3 parity=bad delay=0 |
| 1255 | **DUT** | IN  pkt #14 header: addr=0 len=3 -> channel 0 |
| 1275 | **DUT** | OUT ch1 pkt #4 done: 5 bytes in 5 cycles |
| 1275 | ch1 monitor | ch1 RX pkt #4: addr=1 len=3 parity=bad |
| 1275 | scoreboard | ch1 pkt matched: addr=1 len=3 (11 matched so far) |
| 1295 | **DUT** | IN  pkt #14 complete: addr=0 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 1295 | yapp monitor | RX pkt #14 on the input: addr=0 len=3 parity=bad gap=0 |
| 1295 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 1300 | yapp driver | TX pkt #14 accepted by the DUT |
| 1300 | yapp driver | TX pkt #15: addr=0 len=1 parity=good delay=0 |
| 1305 | **DUT** | IN  pkt #15 header: addr=0 len=1 -> channel 0 |
| 1325 | **DUT** | IN  pkt #15 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1325 | yapp monitor | RX pkt #15 on the input: addr=0 len=1 parity=good gap=0 |
| 1325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 1330 | error checker | error pulse 8 cycles after the bad packet (1 still owed) |
| 1330 | yapp driver | TX pkt #15 accepted by the DUT |
| 1330 | yapp driver | TX pkt #16: addr=2 len=1 parity=good delay=0 |
| 1335 | **DUT** | IN  pkt #16 header: addr=2 len=1 -> channel 2 |
| 1340 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 1340 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 1345 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1355 | **DUT** | IN  pkt #16 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1355 | yapp monitor | RX pkt #16 on the input: addr=2 len=1 parity=good gap=0 |
| 1355 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 1360 | yapp driver | TX pkt #16 accepted by the DUT |
| 1360 | **test** | STAGE: burst 1/6 sent: addr0..3 2/4/8/2, bad parity 8, gap 0 14, length 1..3 |
| 1365 | **DUT** | OUT ch2 pkt #8 done: 3 bytes in 3 cycles |
| 1365 | ch2 monitor | ch2 RX pkt #8: addr=2 len=1 parity=good |
| 1365 | scoreboard | ch2 pkt matched: addr=2 len=1 (12 matched so far) |
| 1380 | hbus driver | Executed WRITE addr=0x1000 data=0xbd |
| 1385 | **DUT** | CONFIG router_en=1 maxpktsize=61 |
| 1385 | hbus monitor | Collected WRITE addr=0x1000 data=0xbd |
| 1385 | reference | maxpktsize is now 61 |
| 1400 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 1405 | **DUT** | CONFIG router_en=0 maxpktsize=61 |
| 1405 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 1405 | reference | router_en is now 0 (en_reg 0xfe) |
| 1420 | hbus driver | Executed WRITE addr=0x1181 data=0x82 |
| 1425 | hbus monitor | Collected WRITE addr=0x1181 data=0x82 |
| 1450 | hbus driver | Executed READ  addr=0x1181 data=0x82 |
| 1455 | hbus monitor | Collected READ  addr=0x1181 data=0x82 |
| 1475 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=3 (receiver waited 21 cycle(s)) |
| 1480 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 1485 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1500 | hbus driver | Executed WRITE addr=0x11a7 data=0x39 |
| 1505 | hbus monitor | Collected WRITE addr=0x11a7 data=0x39 |
| 1510 | ch0 driver | ch0: packet consumed (response delay 21) |
| 1510 | ch1 driver | ch1: packet consumed (response delay 3) |
| 1530 | hbus driver | Executed READ  addr=0x11a7 data=0x39 |
| 1535 | hbus monitor | Collected READ  addr=0x11a7 data=0x39 |
| 1550 | hbus driver | Executed WRITE addr=0x1100 data=0x77 |
| 1555 | hbus monitor | Collected WRITE addr=0x1100 data=0x77 |
| 1580 | hbus driver | Executed READ  addr=0x1100 data=0x77 |
| 1585 | hbus monitor | Collected READ  addr=0x1100 data=0x77 |
| 1600 | ch2 driver | ch2: packet consumed (response delay 31) |
| 1610 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 1615 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1630 | hbus driver | Executed WRITE addr=0x1180 data=0x5a |
| 1635 | hbus monitor | Collected WRITE addr=0x1180 data=0x5a |
| 1660 | hbus driver | Executed READ  addr=0x1180 data=0x5a |
| 1665 | hbus monitor | Collected READ  addr=0x1180 data=0x5a |
| 1690 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 1695 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 1720 | hbus driver | Executed READ  addr=0x1023 data=0x00 |
| 1720 | **test** | STAGE: burst 2/6: ctrl=0xbd (maxpktsize 61) en=0xfe (router OFF, counter enables 1111111), 15 packet(s) |
| 1720 | yapp driver | TX pkt #17: addr=2 len=63 parity=good delay=0 |
| 1725 | hbus monitor | Collected READ  addr=0x1023 data=0x00 |
| 1735 | **DUT** | IN  pkt #17 header: addr=2 len=63 -> DROP (router disabled) |
| 1765 | **DUT** | OUT ch0 pkt #1 done: 5 bytes in 30 cycles |
| 1765 | ch0 monitor | ch0 RX pkt #1: addr=0 len=3 parity=bad |
| 1765 | scoreboard | ch0 pkt matched: addr=0 len=3 (13 matched so far) |
| 1775 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1795 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 3 cycles |
| 1795 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=good |
| 1795 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 2290 | ch0 driver | ch0: packet consumed (response delay 24) |
| 2375 | **DUT** | IN  pkt #17 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2375 | yapp monitor | RX pkt #17 on the input: addr=2 len=63 parity=good gap=37 |
| 2375 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 2375 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 2380 | yapp driver | TX pkt #17 accepted by the DUT |
| 2380 | yapp driver | TX pkt #18: addr=3 len=60 parity=good delay=3 |
| 2415 | **DUT** | IN  pkt #18 header: addr=3 len=60 -> DROP (router disabled) |
| 3025 | **DUT** | IN  pkt #18 complete: addr=3 len=60 parity=ok dropped, 62 bytes in 62 cycles (held 0) |
| 3025 | yapp monitor | RX pkt #18 on the input: addr=3 len=60 parity=good gap=3 |
| 3025 | reference | Packet dropped: router disabled (addr=3 len=60) |
| 3025 | **DUT** | ROUTER DROPS PACKET addr=3 length=60 (router disabled) |
| 3030 | yapp driver | TX pkt #18 accepted by the DUT |
| 3030 | yapp driver | TX pkt #19: addr=2 len=31 parity=good delay=0 |
| 3035 | **DUT** | IN  pkt #19 header: addr=2 len=31 -> DROP (router disabled) |
| 3355 | **DUT** | IN  pkt #19 complete: addr=2 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 3355 | yapp monitor | RX pkt #19 on the input: addr=2 len=31 parity=good gap=0 |
| 3355 | reference | Packet dropped: router disabled (addr=2 len=31) |
| 3355 | **DUT** | ROUTER DROPS PACKET addr=2 length=31 (router disabled) |
| 3360 | yapp driver | TX pkt #19 accepted by the DUT |
| 3360 | yapp driver | TX pkt #20: addr=2 len=25 parity=good delay=0 |
| 3365 | **DUT** | IN  pkt #20 header: addr=2 len=25 -> DROP (router disabled) |
| 3625 | **DUT** | IN  pkt #20 complete: addr=2 len=25 parity=ok dropped, 27 bytes in 27 cycles (held 0) |
| 3625 | yapp monitor | RX pkt #20 on the input: addr=2 len=25 parity=good gap=0 |
| 3625 | reference | Packet dropped: router disabled (addr=2 len=25) |
| 3625 | **DUT** | ROUTER DROPS PACKET addr=2 length=25 (router disabled) |
| 3630 | yapp driver | TX pkt #20 accepted by the DUT |
| 3630 | yapp driver | TX pkt #21: addr=0 len=18 parity=good delay=3 |
| 3665 | **DUT** | IN  pkt #21 header: addr=0 len=18 -> DROP (router disabled) |
| 3855 | **DUT** | IN  pkt #21 complete: addr=0 len=18 parity=ok dropped, 20 bytes in 20 cycles (held 0) |
| 3855 | yapp monitor | RX pkt #21 on the input: addr=0 len=18 parity=good gap=3 |
| 3855 | reference | Packet dropped: router disabled (addr=0 len=18) |
| 3855 | **DUT** | ROUTER DROPS PACKET addr=0 length=18 (router disabled) |
| 3860 | yapp driver | TX pkt #21 accepted by the DUT |
| 3860 | yapp driver | TX pkt #22: addr=3 len=38 parity=good delay=1 |
| 3875 | **DUT** | IN  pkt #22 header: addr=3 len=38 -> DROP (router disabled) |
| 4265 | **DUT** | IN  pkt #22 complete: addr=3 len=38 parity=ok dropped, 40 bytes in 40 cycles (held 0) |
| 4265 | yapp monitor | RX pkt #22 on the input: addr=3 len=38 parity=good gap=1 |
| 4265 | reference | Packet dropped: router disabled (addr=3 len=38) |
| 4265 | **DUT** | ROUTER DROPS PACKET addr=3 length=38 (router disabled) |
| 4270 | yapp driver | TX pkt #22 accepted by the DUT |
| 4270 | yapp driver | TX pkt #23: addr=3 len=63 parity=good delay=3 |
| 4305 | **DUT** | IN  pkt #23 header: addr=3 len=63 -> DROP (router disabled) |
| 4945 | **DUT** | IN  pkt #23 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4945 | yapp monitor | RX pkt #23 on the input: addr=3 len=63 parity=good gap=3 |
| 4945 | reference | Packet dropped: router disabled (addr=3 len=63) |
| 4945 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (router disabled) |
| 4950 | yapp driver | TX pkt #23 accepted by the DUT |
| 4950 | yapp driver | TX pkt #24: addr=2 len=26 parity=good delay=7 |
| 5025 | **DUT** | IN  pkt #24 header: addr=2 len=26 -> DROP (router disabled) |
| 5295 | **DUT** | IN  pkt #24 complete: addr=2 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 5295 | yapp monitor | RX pkt #24 on the input: addr=2 len=26 parity=good gap=7 |
| 5295 | reference | Packet dropped: router disabled (addr=2 len=26) |
| 5295 | **DUT** | ROUTER DROPS PACKET addr=2 length=26 (router disabled) |
| 5300 | yapp driver | TX pkt #24 accepted by the DUT |
| 5300 | yapp driver | TX pkt #25: addr=0 len=60 parity=bad delay=0 |
| 5305 | **DUT** | IN  pkt #25 header: addr=0 len=60 -> DROP (router disabled) |
| 5915 | **DUT** | IN  pkt #25 complete: addr=0 len=60 parity=BAD dropped, 62 bytes in 62 cycles (held 0) |
| 5915 | yapp monitor | RX pkt #25 on the input: addr=0 len=60 parity=bad gap=0 |
| 5915 | reference | Packet dropped: router disabled (addr=0 len=60) |
| 5915 | **DUT** | ROUTER DROPS PACKET addr=0 length=60 (router disabled) |
| 5920 | yapp driver | TX pkt #25 accepted by the DUT |
| 5920 | yapp driver | TX pkt #26: addr=0 len=49 parity=good delay=2 |
| 5945 | **DUT** | IN  pkt #26 header: addr=0 len=49 -> DROP (router disabled) |
| 6445 | **DUT** | IN  pkt #26 complete: addr=0 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 6445 | yapp monitor | RX pkt #26 on the input: addr=0 len=49 parity=good gap=2 |
| 6445 | reference | Packet dropped: router disabled (addr=0 len=49) |
| 6445 | **DUT** | ROUTER DROPS PACKET addr=0 length=49 (router disabled) |
| 6450 | yapp driver | TX pkt #26 accepted by the DUT |
| 6450 | yapp driver | TX pkt #27: addr=2 len=61 parity=good delay=0 |
| 6455 | **DUT** | IN  pkt #27 header: addr=2 len=61 -> DROP (router disabled) |
| 7075 | **DUT** | IN  pkt #27 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 7075 | yapp monitor | RX pkt #27 on the input: addr=2 len=61 parity=good gap=0 |
| 7075 | reference | Packet dropped: router disabled (addr=2 len=61) |
| 7075 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (router disabled) |
| 7080 | yapp driver | TX pkt #27 accepted by the DUT |
| 7080 | yapp driver | TX pkt #28: addr=2 len=61 parity=good delay=1 |
| 7095 | **DUT** | IN  pkt #28 header: addr=2 len=61 -> DROP (router disabled) |
| 7715 | **DUT** | IN  pkt #28 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 7715 | yapp monitor | RX pkt #28 on the input: addr=2 len=61 parity=good gap=1 |
| 7715 | reference | Packet dropped: router disabled (addr=2 len=61) |
| 7715 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (router disabled) |
| 7720 | yapp driver | TX pkt #28 accepted by the DUT |
| 7720 | yapp driver | TX pkt #29: addr=2 len=61 parity=good delay=0 |
| 7725 | **DUT** | IN  pkt #29 header: addr=2 len=61 -> DROP (router disabled) |
| 8345 | **DUT** | IN  pkt #29 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 8345 | yapp monitor | RX pkt #29 on the input: addr=2 len=61 parity=good gap=0 |
| 8345 | reference | Packet dropped: router disabled (addr=2 len=61) |
| 8345 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (router disabled) |
| 8350 | yapp driver | TX pkt #29 accepted by the DUT |
| 8350 | yapp driver | TX pkt #30: addr=2 len=63 parity=good delay=13 |
| 8485 | **DUT** | IN  pkt #30 header: addr=2 len=63 -> DROP (router disabled) |
| 9125 | **DUT** | IN  pkt #30 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 9125 | yapp monitor | RX pkt #30 on the input: addr=2 len=63 parity=good gap=13 |
| 9125 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 9125 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 9130 | yapp driver | TX pkt #30 accepted by the DUT |
| 9130 | yapp driver | TX pkt #31: addr=3 len=11 parity=good delay=0 |
| 9135 | **DUT** | IN  pkt #31 header: addr=3 len=11 -> DROP (router disabled) |
| 9255 | **DUT** | IN  pkt #31 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 9255 | yapp monitor | RX pkt #31 on the input: addr=3 len=11 parity=good gap=0 |
| 9255 | reference | Packet dropped: router disabled (addr=3 len=11) |
| 9255 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (router disabled) |
| 9260 | yapp driver | TX pkt #31 accepted by the DUT |
| 9260 | **test** | STAGE: burst 2/6 sent: addr0..3 3/0/8/4, bad parity 1, gap 0 7, length 11..63 |
| 9280 | hbus driver | Executed WRITE addr=0x1000 data=0xbe |
| 9285 | **DUT** | CONFIG router_en=0 maxpktsize=62 |
| 9285 | hbus monitor | Collected WRITE addr=0x1000 data=0xbe |
| 9285 | reference | maxpktsize is now 62 |
| 9300 | hbus driver | Executed WRITE addr=0x1001 data=0x13 |
| 9305 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 9305 | hbus monitor | Collected WRITE addr=0x1001 data=0x13 |
| 9305 | reference | router_en is now 1 (en_reg 0x13) |
| 9330 | hbus driver | Executed READ  addr=0x1031 data=0x00 |
| 9335 | hbus monitor | Collected READ  addr=0x1031 data=0x00 |
| 9350 | hbus driver | Executed WRITE addr=0x11e1 data=0x41 |
| 9355 | hbus monitor | Collected WRITE addr=0x11e1 data=0x41 |
| 9380 | hbus driver | Executed READ  addr=0x11e1 data=0x41 |
| 9385 | hbus monitor | Collected READ  addr=0x11e1 data=0x41 |
| 9400 | hbus driver | Executed WRITE addr=0x1199 data=0x35 |
| 9405 | hbus monitor | Collected WRITE addr=0x1199 data=0x35 |
| 9430 | hbus driver | Executed READ  addr=0x1199 data=0x35 |
| 9435 | hbus monitor | Collected READ  addr=0x1199 data=0x35 |
| 9460 | hbus driver | Executed READ  addr=0x1003 data=0x00 |
| 9465 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9490 | hbus driver | Executed READ  addr=0x103b data=0x00 |
| 9490 | **test** | STAGE: burst 3/6: ctrl=0xbe (maxpktsize 62) en=0x13 (router on, counter enables 0001001), 16 packet(s) |
| 9490 | yapp driver | TX pkt #32: addr=1 len=51 parity=good delay=1 |
| 9495 | hbus monitor | Collected READ  addr=0x103b data=0x00 |
| 9515 | **DUT** | IN  pkt #32 header: addr=1 len=51 -> channel 1 |
| 9525 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=51 (receiver waited 0 cycle(s)) |
| 10035 | **DUT** | IN  pkt #32 complete: addr=1 len=51 parity=ok forwarded, 53 bytes in 53 cycles (held 0) |
| 10035 | yapp monitor | RX pkt #32 on the input: addr=1 len=51 parity=good gap=25 |
| 10035 | reference | Packet forwarded: addr=1 len=51 -> channel 1 |
| 10040 | ch1 driver | ch1: packet consumed (response delay 0) |
| 10040 | yapp driver | TX pkt #32 accepted by the DUT |
| 10040 | yapp driver | TX pkt #33: addr=1 len=54 parity=good delay=20 |
| 10155 | **DUT** | OUT ch1 pkt #5 done: 53 bytes in 64 cycles |
| 10155 | ch1 monitor | ch1 RX pkt #5: addr=1 len=51 parity=good |
| 10155 | scoreboard | ch1 pkt matched: addr=1 len=51 (15 matched so far) |
| 10245 | **DUT** | IN  pkt #33 header: addr=1 len=54 -> channel 1 |
| 10255 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=54 (receiver waited 0 cycle(s)) |
| 10550 | ch1 driver | ch1: packet consumed (response delay 10) |
| 10795 | **DUT** | IN  pkt #33 complete: addr=1 len=54 parity=ok forwarded, 56 bytes in 56 cycles (held 0) |
| 10795 | yapp monitor | RX pkt #33 on the input: addr=1 len=54 parity=good gap=20 |
| 10795 | reference | Packet forwarded: addr=1 len=54 -> channel 1 |
| 10800 | yapp driver | TX pkt #33 accepted by the DUT |
| 10800 | yapp driver | TX pkt #34: addr=2 len=62 parity=bad delay=0 |
| 10805 | **DUT** | IN  pkt #34 header: addr=2 len=62 -> channel 2 |
| 10915 | **DUT** | OUT ch1 pkt #6 done: 56 bytes in 67 cycles |
| 10915 | ch1 monitor | ch1 RX pkt #6: addr=1 len=54 parity=good |
| 10915 | scoreboard | ch1 pkt matched: addr=1 len=54 (16 matched so far) |
| 10965 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x0d held (pkt #34) |
| 11115 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=62 (receiver waited 30 cycle(s)) |
| 11125 | **DUT** | SUSPEND released after 16 cycle(s) |
| 11130 | ch1 driver | ch1: packet consumed (response delay 10) |
| 11595 | **DUT** | IN  pkt #34 complete: addr=2 len=62 parity=BAD forwarded, 64 bytes in 80 cycles (held 16) |
| 11595 | yapp monitor | RX pkt #34 on the input: addr=2 len=62 parity=bad gap=0 |
| 11595 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 11600 | yapp driver | TX pkt #34 accepted by the DUT |
| 11600 | yapp driver | TX pkt #35: addr=1 len=32 parity=good delay=20 |
| 11630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 11630 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 11740 | ch2 driver | ch2: packet consumed (response delay 30) |
| 11805 | **DUT** | IN  pkt #35 header: addr=1 len=32 -> channel 1 |
| 11965 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0xb7 held (pkt #35) |
| 11985 | **DUT** | OUT ch2 pkt #9 done: 64 bytes in 88 cycles |
| 11985 | ch2 monitor | ch2 RX pkt #9: addr=2 len=62 parity=bad |
| 11985 | scoreboard | ch2 pkt matched: addr=2 len=62 (17 matched so far) |
| 12300 | ch2 driver | ch2: packet consumed (response delay 23) |
| 12815 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=32 (receiver waited 100 cycle(s)) |
| 12825 | **DUT** | SUSPEND released after 86 cycle(s) |
| 12995 | **DUT** | IN  pkt #35 complete: addr=1 len=32 parity=ok forwarded, 34 bytes in 120 cycles (held 86) |
| 12995 | yapp monitor | RX pkt #35 on the input: addr=1 len=32 parity=good gap=20 |
| 12995 | reference | Packet forwarded: addr=1 len=32 -> channel 1 |
| 13000 | yapp driver | TX pkt #35 accepted by the DUT |
| 13000 | yapp driver | TX pkt #36: addr=3 len=63 parity=good delay=0 |
| 13005 | **DUT** | IN  pkt #36 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 13140 | ch1 driver | ch1: packet consumed (response delay 100) |
| 13155 | **DUT** | OUT ch1 pkt #7 done: 34 bytes in 35 cycles |
| 13155 | ch1 monitor | ch1 RX pkt #7: addr=1 len=32 parity=good |
| 13155 | scoreboard | ch1 pkt matched: addr=1 len=32 (18 matched so far) |
| 13645 | **DUT** | IN  pkt #36 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 13645 | yapp monitor | RX pkt #36 on the input: addr=3 len=63 parity=good gap=0 |
| 13645 | reference | Packet dropped: illegal address 3 (len=63) |
| 13645 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 13650 | ch1 driver | ch1: packet consumed (response delay 0) |
| 13650 | yapp driver | TX pkt #36 accepted by the DUT |
| 13650 | yapp driver | TX pkt #37: addr=1 len=37 parity=good delay=0 |
| 13655 | **DUT** | IN  pkt #37 header: addr=1 len=37 -> channel 1 |
| 13765 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=37 (receiver waited 10 cycle(s)) |
| 14035 | **DUT** | IN  pkt #37 complete: addr=1 len=37 parity=ok forwarded, 39 bytes in 39 cycles (held 0) |
| 14035 | yapp monitor | RX pkt #37 on the input: addr=1 len=37 parity=good gap=0 |
| 14035 | reference | Packet forwarded: addr=1 len=37 -> channel 1 |
| 14040 | yapp driver | TX pkt #37 accepted by the DUT |
| 14040 | yapp driver | TX pkt #38: addr=2 len=48 parity=good delay=3 |
| 14075 | **DUT** | IN  pkt #38 header: addr=2 len=48 -> channel 2 |
| 14140 | ch1 driver | ch1: packet consumed (response delay 10) |
| 14195 | **DUT** | OUT ch1 pkt #8 done: 39 bytes in 44 cycles |
| 14195 | ch1 monitor | ch1 RX pkt #8: addr=1 len=37 parity=good |
| 14195 | scoreboard | ch1 pkt matched: addr=1 len=37 (19 matched so far) |
| 14235 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x27 held (pkt #38) |
| 14280 | ch1 driver | ch1: packet consumed (response delay 4) |
| 14475 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=48 (receiver waited 39 cycle(s)) |
| 14485 | **DUT** | SUSPEND released after 25 cycle(s) |
| 14815 | **DUT** | IN  pkt #38 complete: addr=2 len=48 parity=ok forwarded, 50 bytes in 75 cycles (held 25) |
| 14815 | yapp monitor | RX pkt #38 on the input: addr=2 len=48 parity=good gap=3 |
| 14815 | reference | Packet forwarded: addr=2 len=48 -> channel 2 |
| 14820 | yapp driver | TX pkt #38 accepted by the DUT |
| 14820 | yapp driver | TX pkt #39: addr=2 len=1 parity=good delay=8 |
| 14905 | **DUT** | IN  pkt #39 header: addr=2 len=1 -> channel 2 |
| 14925 | **DUT** | IN  pkt #39 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14925 | yapp monitor | RX pkt #39 on the input: addr=2 len=1 parity=good gap=8 |
| 14925 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 14930 | yapp driver | TX pkt #39 accepted by the DUT |
| 14930 | yapp driver | TX pkt #40: addr=0 len=53 parity=good delay=1 |
| 14945 | **DUT** | IN  pkt #40 header: addr=0 len=53 -> channel 0 |
| 14960 | ch2 driver | ch2: packet consumed (response delay 39) |
| 15105 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0xc0 held (pkt #40) |
| 15355 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=53 (receiver waited 40 cycle(s)) |
| 15365 | **DUT** | SUSPEND released after 26 cycle(s) |
| 15375 | **DUT** | OUT ch2 pkt #10 done: 50 bytes in 91 cycles |
| 15375 | ch2 monitor | ch2 RX pkt #10: addr=2 len=48 parity=good |
| 15375 | scoreboard | ch2 pkt matched: addr=2 len=48 (20 matched so far) |
| 15385 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 15405 | **DUT** | OUT ch2 pkt #11 done: 3 bytes in 3 cycles |
| 15405 | ch2 monitor | ch2 RX pkt #11: addr=2 len=1 parity=good |
| 15405 | scoreboard | ch2 pkt matched: addr=2 len=1 (21 matched so far) |
| 15580 | ch2 driver | ch2: packet consumed (response delay 40) |
| 15745 | **DUT** | IN  pkt #40 complete: addr=0 len=53 parity=ok forwarded, 55 bytes in 81 cycles (held 26) |
| 15745 | yapp monitor | RX pkt #40 on the input: addr=0 len=53 parity=good gap=1 |
| 15745 | reference | Packet forwarded: addr=0 len=53 -> channel 0 |
| 15750 | yapp driver | TX pkt #40 accepted by the DUT |
| 15750 | yapp driver | TX pkt #41: addr=2 len=63 parity=bad delay=1 |
| 15765 | **DUT** | IN  pkt #41 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 15890 | ch0 driver | ch0: packet consumed (response delay 40) |
| 16215 | **DUT** | OUT ch0 pkt #3 done: 55 bytes in 87 cycles |
| 16215 | ch0 monitor | ch0 RX pkt #3: addr=0 len=53 parity=good |
| 16215 | scoreboard | ch0 pkt matched: addr=0 len=53 (22 matched so far) |
| 16350 | ch0 driver | ch0: packet consumed (response delay 31) |
| 16405 | **DUT** | IN  pkt #41 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 16405 | yapp monitor | RX pkt #41 on the input: addr=2 len=63 parity=bad gap=1 |
| 16405 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 16405 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 16410 | yapp driver | TX pkt #41 accepted by the DUT |
| 16410 | yapp driver | TX pkt #42: addr=2 len=50 parity=good delay=2 |
| 16435 | **DUT** | IN  pkt #42 header: addr=2 len=50 -> channel 2 |
| 16450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 16450 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 16595 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x2d held (pkt #42) |
| 16735 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=50 (receiver waited 29 cycle(s)) |
| 16745 | **DUT** | SUSPEND released after 15 cycle(s) |
| 17095 | **DUT** | IN  pkt #42 complete: addr=2 len=50 parity=ok forwarded, 52 bytes in 67 cycles (held 15) |
| 17095 | yapp monitor | RX pkt #42 on the input: addr=2 len=50 parity=good gap=2 |
| 17095 | reference | Packet forwarded: addr=2 len=50 -> channel 2 |
| 17100 | yapp driver | TX pkt #42 accepted by the DUT |
| 17100 | yapp driver | TX pkt #43: addr=1 len=1 parity=bad delay=15 |
| 17240 | ch2 driver | ch2: packet consumed (response delay 29) |
| 17255 | **DUT** | IN  pkt #43 header: addr=1 len=1 -> channel 1 |
| 17275 | **DUT** | IN  pkt #43 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 17275 | yapp monitor | RX pkt #43 on the input: addr=1 len=1 parity=bad gap=15 |
| 17275 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 17280 | yapp driver | TX pkt #43 accepted by the DUT |
| 17280 | yapp driver | TX pkt #44: addr=0 len=62 parity=good delay=1 |
| 17290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 17290 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 17295 | **DUT** | IN  pkt #44 header: addr=0 len=62 -> channel 0 |
| 17455 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x9a held (pkt #44) |
| 17625 | **DUT** | OUT ch2 pkt #12 done: 52 bytes in 90 cycles |
| 17625 | ch2 monitor | ch2 RX pkt #12: addr=2 len=50 parity=good |
| 17625 | scoreboard | ch2 pkt matched: addr=2 len=50 (23 matched so far) |
| 17675 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=62 (receiver waited 37 cycle(s)) |
| 17685 | **DUT** | SUSPEND released after 23 cycle(s) |
| 17920 | ch2 driver | ch2: packet consumed (response delay 37) |
| 18155 | **DUT** | IN  pkt #44 complete: addr=0 len=62 parity=ok forwarded, 64 bytes in 87 cycles (held 23) |
| 18155 | yapp monitor | RX pkt #44 on the input: addr=0 len=62 parity=good gap=1 |
| 18155 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 18160 | yapp driver | TX pkt #44 accepted by the DUT |
| 18160 | yapp driver | TX pkt #45: addr=3 len=1 parity=good delay=0 |
| 18165 | **DUT** | IN  pkt #45 header: addr=3 len=1 -> DROP (illegal address 3) |
| 18185 | **DUT** | IN  pkt #45 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 18185 | yapp monitor | RX pkt #45 on the input: addr=3 len=1 parity=good gap=0 |
| 18185 | reference | Packet dropped: illegal address 3 (len=1) |
| 18185 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 18190 | yapp driver | TX pkt #45 accepted by the DUT |
| 18190 | yapp driver | TX pkt #46: addr=2 len=63 parity=bad delay=5 |
| 18245 | **DUT** | IN  pkt #46 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 18300 | ch0 driver | ch0: packet consumed (response delay 37) |
| 18555 | **DUT** | OUT ch0 pkt #4 done: 64 bytes in 89 cycles |
| 18555 | ch0 monitor | ch0 RX pkt #4: addr=0 len=62 parity=good |
| 18555 | scoreboard | ch0 pkt matched: addr=0 len=62 (24 matched so far) |
| 18575 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=1 (receiver waited 131 cycle(s)) |
| 18580 | ch0 driver | ch0: packet consumed (response delay 24) |
| 18590 | ch1 driver | ch1: packet consumed (response delay 131) |
| 18675 | **DUT** | OUT ch1 pkt #9 done: 3 bytes in 11 cycles |
| 18675 | ch1 monitor | ch1 RX pkt #9: addr=1 len=1 parity=bad |
| 18675 | scoreboard | ch1 pkt matched: addr=1 len=1 (25 matched so far) |
| 18860 | ch1 driver | ch1: packet consumed (response delay 7) |
| 18885 | **DUT** | IN  pkt #46 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 18885 | yapp monitor | RX pkt #46 on the input: addr=2 len=63 parity=bad gap=5 |
| 18885 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 18885 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 18890 | yapp driver | TX pkt #46 accepted by the DUT |
| 18890 | yapp driver | TX pkt #47: addr=3 len=63 parity=bad delay=0 |
| 18895 | **DUT** | IN  pkt #47 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 18910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 18910 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 19535 | **DUT** | IN  pkt #47 complete: addr=3 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 19535 | yapp monitor | RX pkt #47 on the input: addr=3 len=63 parity=bad gap=0 |
| 19535 | reference | Packet dropped: illegal address 3 (len=63) |
| 19535 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 19540 | yapp driver | TX pkt #47 accepted by the DUT |
| 19540 | **test** | STAGE: burst 3/6 sent: addr0..3 2/5/6/3, bad parity 5, gap 0 5, length 1..63 |
| 19560 | hbus driver | Executed WRITE addr=0x1000 data=0x55 |
| 19565 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 19565 | hbus monitor | Collected WRITE addr=0x1000 data=0x55 |
| 19565 | reference | maxpktsize is now 21 |
| 19570 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 19570 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 19580 | hbus driver | Executed WRITE addr=0x1001 data=0x3b |
| 19585 | hbus monitor | Collected WRITE addr=0x1001 data=0x3b |
| 19585 | reference | router_en is now 1 (en_reg 0x3b) |
| 19610 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 19615 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 19640 | hbus driver | Executed READ  addr=0x103d data=0x58 |
| 19645 | hbus monitor | Collected READ  addr=0x103d data=0x58 |
| 19660 | hbus driver | Executed WRITE addr=0x11d4 data=0xf1 |
| 19665 | hbus monitor | Collected WRITE addr=0x11d4 data=0xf1 |
| 19690 | hbus driver | Executed READ  addr=0x11d4 data=0xf1 |
| 19695 | hbus monitor | Collected READ  addr=0x11d4 data=0xf1 |
| 19710 | hbus driver | Executed WRITE addr=0x11b6 data=0x3f |
| 19715 | hbus monitor | Collected WRITE addr=0x11b6 data=0x3f |
| 19740 | hbus driver | Executed READ  addr=0x11b6 data=0x3f |
| 19745 | hbus monitor | Collected READ  addr=0x11b6 data=0x3f |
| 19770 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 19775 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19790 | hbus driver | Executed WRITE addr=0x1178 data=0xdc |
| 19795 | hbus monitor | Collected WRITE addr=0x1178 data=0xdc |
| 19820 | hbus driver | Executed READ  addr=0x1178 data=0xdc |
| 19820 | **test** | STAGE: burst 4/6: ctrl=0x55 (maxpktsize 21) en=0x3b (router on, counter enables 0011101), 15 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 19820 | yapp driver | TX pkt #48: addr=0 len=3 parity=good delay=0 |
| 19825 | hbus monitor | Collected READ  addr=0x1178 data=0xdc |
| 19835 | **DUT** | IN  pkt #48 header: addr=0 len=3 -> channel 0 |
| 19875 | **DUT** | IN  pkt #48 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 19875 | yapp monitor | RX pkt #48 on the input: addr=0 len=3 parity=good gap=29 |
| 19875 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 19880 | yapp driver | TX pkt #48 accepted by the DUT |
| 19880 | yapp driver | TX pkt #49: addr=1 len=1 parity=bad delay=0 |
| 19885 | **DUT** | IN  pkt #49 header: addr=1 len=1 -> channel 1 |
| 19905 | **DUT** | IN  pkt #49 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 19905 | yapp monitor | RX pkt #49 on the input: addr=1 len=1 parity=bad gap=0 |
| 19905 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 19910 | yapp driver | TX pkt #49 accepted by the DUT |
| 19910 | yapp driver | TX pkt #50: addr=1 len=2 parity=good delay=0 |
| 19915 | **DUT** | IN  pkt #50 header: addr=1 len=2 -> channel 1 |
| 19930 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 19930 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 19945 | **DUT** | IN  pkt #50 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 19945 | yapp monitor | RX pkt #50 on the input: addr=1 len=2 parity=good gap=0 |
| 19945 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 19950 | yapp driver | TX pkt #50 accepted by the DUT |
| 19950 | yapp driver | TX pkt #51: addr=3 len=1 parity=good delay=0 |
| 19955 | **DUT** | IN  pkt #51 header: addr=3 len=1 -> DROP (illegal address 3) |
| 19975 | **DUT** | IN  pkt #51 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 19975 | yapp monitor | RX pkt #51 on the input: addr=3 len=1 parity=good gap=0 |
| 19975 | reference | Packet dropped: illegal address 3 (len=1) |
| 19975 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 19980 | yapp driver | TX pkt #51 accepted by the DUT |
| 19980 | yapp driver | TX pkt #52: addr=2 len=2 parity=bad delay=0 |
| 19985 | **DUT** | IN  pkt #52 header: addr=2 len=2 -> channel 2 |
| 19995 | **DUT** | OUT ch1 pkt #10 start: addr=1 len=1 (receiver waited 10 cycle(s)) |
| 20010 | ch1 driver | ch1: packet consumed (response delay 10) |
| 20015 | **DUT** | IN  pkt #52 complete: addr=2 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 20015 | yapp monitor | RX pkt #52 on the input: addr=2 len=2 parity=bad gap=0 |
| 20015 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 20020 | yapp driver | TX pkt #52 accepted by the DUT |
| 20020 | yapp driver | TX pkt #53: addr=1 len=3 parity=good delay=0 |
| 20025 | **DUT** | IN  pkt #53 header: addr=1 len=3 -> channel 1 |
| 20050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 20050 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 20065 | **DUT** | IN  pkt #53 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 20065 | yapp monitor | RX pkt #53 on the input: addr=1 len=3 parity=good gap=0 |
| 20065 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 20070 | yapp driver | TX pkt #53 accepted by the DUT |
| 20070 | yapp driver | TX pkt #54: addr=2 len=2 parity=good delay=0 |
| 20075 | **DUT** | IN  pkt #54 header: addr=2 len=2 -> channel 2 |
| 20105 | **DUT** | IN  pkt #54 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 20105 | yapp monitor | RX pkt #54 on the input: addr=2 len=2 parity=good gap=0 |
| 20105 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 20110 | yapp driver | TX pkt #54 accepted by the DUT |
| 20110 | yapp driver | TX pkt #55: addr=1 len=2 parity=bad delay=0 |
| 20115 | **DUT** | IN  pkt #55 header: addr=1 len=2 -> channel 1 |
| 20115 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=3 (receiver waited 27 cycle(s)) |
| 20125 | **DUT** | OUT ch1 pkt #10 done: 3 bytes in 14 cycles |
| 20125 | ch1 monitor | ch1 RX pkt #10: addr=1 len=1 parity=bad |
| 20125 | scoreboard | ch1 pkt matched: addr=1 len=1 (26 matched so far) |
| 20135 | **DUT** | OUT ch1 pkt #11 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 20145 | **DUT** | IN  pkt #55 complete: addr=1 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 20145 | yapp monitor | RX pkt #55 on the input: addr=1 len=2 parity=bad gap=0 |
| 20145 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 20150 | ch0 driver | ch0: packet consumed (response delay 27) |
| 20150 | yapp driver | TX pkt #55 accepted by the DUT |
| 20150 | yapp driver | TX pkt #56: addr=2 len=2 parity=bad delay=0 |
| 20155 | **DUT** | IN  pkt #56 header: addr=2 len=2 -> channel 2 |
| 20165 | **DUT** | OUT ch1 pkt #11 done: 4 bytes in 4 cycles |
| 20165 | ch1 monitor | ch1 RX pkt #11: addr=1 len=2 parity=good |
| 20165 | scoreboard | ch1 pkt matched: addr=1 len=2 (27 matched so far) |
| 20175 | **DUT** | OUT ch1 pkt #12 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 20185 | **DUT** | IN  pkt #56 complete: addr=2 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 20185 | yapp monitor | RX pkt #56 on the input: addr=2 len=2 parity=bad gap=0 |
| 20185 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 20190 | yapp driver | TX pkt #56 accepted by the DUT |
| 20190 | yapp driver | TX pkt #57: addr=2 len=2 parity=good delay=1 |
| 20205 | **DUT** | IN  pkt #57 header: addr=2 len=2 -> channel 2 |
| 20215 | **DUT** | OUT ch1 pkt #12 done: 5 bytes in 5 cycles |
| 20215 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=2 (receiver waited 22 cycle(s)) |
| 20215 | ch1 monitor | ch1 RX pkt #12: addr=1 len=3 parity=good |
| 20215 | scoreboard | ch1 pkt matched: addr=1 len=3 (28 matched so far) |
| 20225 | **DUT** | OUT ch1 pkt #13 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 20230 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 20230 | error checker | error pulse 8 cycles after the bad packet (1 still owed) |
| 20235 | **DUT** | IN  pkt #57 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 20235 | yapp monitor | RX pkt #57 on the input: addr=2 len=2 parity=good gap=1 |
| 20235 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 20240 | ch2 driver | ch2: packet consumed (response delay 22) |
| 20240 | yapp driver | TX pkt #57 accepted by the DUT |
| 20240 | yapp driver | TX pkt #58: addr=0 len=1 parity=good delay=0 |
| 20245 | **DUT** | IN  pkt #58 header: addr=0 len=1 -> channel 0 |
| 20250 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 20250 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 20255 | **DUT** | OUT ch1 pkt #13 done: 4 bytes in 4 cycles |
| 20255 | ch1 monitor | ch1 RX pkt #13: addr=1 len=2 parity=bad |
| 20255 | scoreboard | ch1 pkt matched: addr=1 len=2 (29 matched so far) |
| 20265 | **DUT** | IN  pkt #58 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20265 | yapp monitor | RX pkt #58 on the input: addr=0 len=1 parity=good gap=0 |
| 20265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20270 | yapp driver | TX pkt #58 accepted by the DUT |
| 20270 | yapp driver | TX pkt #59: addr=2 len=1 parity=good delay=0 |
| 20275 | **DUT** | IN  pkt #59 header: addr=2 len=1 -> channel 2 |
| 20295 | **DUT** | IN  pkt #59 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20295 | yapp monitor | RX pkt #59 on the input: addr=2 len=1 parity=good gap=0 |
| 20295 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 20300 | yapp driver | TX pkt #59 accepted by the DUT |
| 20300 | yapp driver | TX pkt #60: addr=2 len=2 parity=good delay=1 |
| 20315 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x0a held (pkt #60) |
| 20380 | ch1 driver | ch1: packet consumed (response delay 10) |
| 20555 | **DUT** | OUT ch2 pkt #13 done: 4 bytes in 35 cycles |
| 20555 | ch2 monitor | ch2 RX pkt #13: addr=2 len=2 parity=bad |
| 20555 | scoreboard | ch2 pkt matched: addr=2 len=2 (30 matched so far) |
| 20565 | **DUT** | IN  pkt #60 header: addr=2 len=2 -> channel 2 |
| 20565 | **DUT** | SUSPEND released after 25 cycle(s) |
| 20565 | **DUT** | OUT ch0 pkt #5 done: 5 bytes in 46 cycles |
| 20565 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 20565 | ch0 monitor | ch0 RX pkt #5: addr=0 len=3 parity=good |
| 20565 | scoreboard | ch0 pkt matched: addr=0 len=3 (31 matched so far) |
| 20575 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20590 | ch2 driver | ch2: packet consumed (response delay 30) |
| 20595 | **DUT** | IN  pkt #60 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 20595 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 20595 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=good |
| 20595 | scoreboard | ch0 pkt matched: addr=0 len=1 (32 matched so far) |
| 20595 | yapp monitor | RX pkt #60 on the input: addr=2 len=2 parity=good gap=1 |
| 20595 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 20600 | yapp driver | TX pkt #60 accepted by the DUT |
| 20600 | yapp driver | TX pkt #61: addr=1 len=1 parity=bad delay=1 |
| 20615 | **DUT** | IN  pkt #61 header: addr=1 len=1 -> channel 1 |
| 20635 | **DUT** | IN  pkt #61 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 20635 | yapp monitor | RX pkt #61 on the input: addr=1 len=1 parity=bad gap=1 |
| 20635 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 20640 | yapp driver | TX pkt #61 accepted by the DUT |
| 20640 | yapp driver | TX pkt #62: addr=1 len=2 parity=good delay=0 |
| 20645 | **DUT** | IN  pkt #62 header: addr=1 len=2 -> channel 1 |
| 20650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 20650 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 20675 | **DUT** | IN  pkt #62 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 20675 | yapp monitor | RX pkt #62 on the input: addr=1 len=2 parity=good gap=0 |
| 20675 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 20680 | yapp driver | TX pkt #62 accepted by the DUT |
| 20680 | **test** | STAGE: burst 4/6 sent: addr0..3 2/6/6/1, bad parity 5, gap 0 12, length 1..3 |
| 20700 | hbus driver | Executed WRITE addr=0x1000 data=0xc1 |
| 20705 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 20705 | hbus monitor | Collected WRITE addr=0x1000 data=0xc1 |
| 20705 | reference | maxpktsize is now 1 |
| 20720 | hbus driver | Executed WRITE addr=0x1001 data=0x9b |
| 20725 | **DUT** | OUT ch1 pkt #14 start: addr=1 len=1 (receiver waited 10 cycle(s)) |
| 20725 | hbus monitor | Collected WRITE addr=0x1001 data=0x9b |
| 20725 | reference | router_en is now 1 (en_reg 0x9b) |
| 20740 | ch1 driver | ch1: packet consumed (response delay 10) |
| 20750 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 20755 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 20770 | hbus driver | Executed WRITE addr=0x114a data=0xdd |
| 20775 | hbus monitor | Collected WRITE addr=0x114a data=0xdd |
| 20800 | hbus driver | Executed READ  addr=0x114a data=0xdd |
| 20805 | hbus monitor | Collected READ  addr=0x114a data=0xdd |
| 20825 | **DUT** | OUT ch1 pkt #14 done: 3 bytes in 11 cycles |
| 20825 | ch1 monitor | ch1 RX pkt #14: addr=1 len=1 parity=bad |
| 20825 | scoreboard | ch1 pkt matched: addr=1 len=1 (33 matched so far) |
| 20830 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 20835 | **DUT** | OUT ch1 pkt #15 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 20835 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 20860 | ch1 driver | ch1: packet consumed (response delay 7) |
| 20860 | hbus driver | Executed READ  addr=0x10de data=0x00 |
| 20865 | hbus monitor | Collected READ  addr=0x10de data=0x00 |
| 20880 | hbus driver | Executed WRITE addr=0x113c data=0x00 |
| 20885 | hbus monitor | Collected WRITE addr=0x113c data=0x00 |
| 20890 | ch0 driver | ch0: packet consumed (response delay 40) |
| 20910 | hbus driver | Executed READ  addr=0x113c data=0x00 |
| 20915 | hbus monitor | Collected READ  addr=0x113c data=0x00 |
| 20930 | hbus driver | Executed WRITE addr=0x1150 data=0xdd |
| 20935 | hbus monitor | Collected WRITE addr=0x1150 data=0xdd |
| 20960 | hbus driver | Executed READ  addr=0x1150 data=0xdd |
| 20960 | **test** | STAGE: burst 5/6: ctrl=0xc1 (maxpktsize 1) en=0x9b (router on, counter enables 1001101), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 20960 | yapp driver | TX pkt #63: addr=2 len=1 parity=good delay=0 |
| 20965 | hbus monitor | Collected READ  addr=0x1150 data=0xdd |
| 20975 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x06 held (pkt #63) |
| 20975 | **DUT** | OUT ch1 pkt #15 done: 4 bytes in 15 cycles |
| 20975 | **DUT** | OUT ch2 pkt #14 done: 4 bytes in 42 cycles |
| 20975 | ch1 monitor | ch1 RX pkt #15: addr=1 len=2 parity=good |
| 20975 | scoreboard | ch1 pkt matched: addr=1 len=2 (34 matched so far) |
| 20975 | ch2 monitor | ch2 RX pkt #14: addr=2 len=2 parity=good |
| 20975 | scoreboard | ch2 pkt matched: addr=2 len=2 (35 matched so far) |
| 20985 | **DUT** | IN  pkt #63 header: addr=2 len=1 -> channel 2 |
| 20985 | **DUT** | SUSPEND released after 1 cycle(s) |
| 20985 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 21005 | **DUT** | IN  pkt #63 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21005 | yapp monitor | RX pkt #63 on the input: addr=2 len=1 parity=good gap=29 |
| 21005 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21010 | yapp driver | TX pkt #63 accepted by the DUT |
| 21010 | yapp driver | TX pkt #64: addr=2 len=2 parity=good delay=3 |
| 21015 | **DUT** | OUT ch2 pkt #15 done: 4 bytes in 4 cycles |
| 21015 | ch2 monitor | ch2 RX pkt #15: addr=2 len=2 parity=bad |
| 21015 | scoreboard | ch2 pkt matched: addr=2 len=2 (36 matched so far) |
| 21025 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 21045 | **DUT** | IN  pkt #64 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21055 | **DUT** | OUT ch2 pkt #16 done: 4 bytes in 4 cycles |
| 21055 | ch2 monitor | ch2 RX pkt #16: addr=2 len=2 parity=good |
| 21055 | scoreboard | ch2 pkt matched: addr=2 len=2 (37 matched so far) |
| 21065 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 21075 | **DUT** | IN  pkt #64 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 21075 | yapp monitor | RX pkt #64 on the input: addr=2 len=2 parity=good gap=3 |
| 21075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 21075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 21080 | yapp driver | TX pkt #64 accepted by the DUT |
| 21080 | yapp driver | TX pkt #65: addr=1 len=2 parity=bad delay=0 |
| 21085 | **DUT** | IN  pkt #65 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21085 | **DUT** | OUT ch2 pkt #17 done: 3 bytes in 3 cycles |
| 21085 | ch2 monitor | ch2 RX pkt #17: addr=2 len=1 parity=good |
| 21085 | scoreboard | ch2 pkt matched: addr=2 len=1 (38 matched so far) |
| 21095 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 21115 | **DUT** | IN  pkt #65 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 21115 | yapp monitor | RX pkt #65 on the input: addr=1 len=2 parity=bad gap=0 |
| 21115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 21115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 21120 | yapp driver | TX pkt #65 accepted by the DUT |
| 21120 | yapp driver | TX pkt #66: addr=2 len=1 parity=good delay=0 |
| 21125 | **DUT** | IN  pkt #66 header: addr=2 len=1 -> channel 2 |
| 21125 | **DUT** | OUT ch2 pkt #18 done: 4 bytes in 4 cycles |
| 21125 | ch2 monitor | ch2 RX pkt #18: addr=2 len=2 parity=good |
| 21125 | scoreboard | ch2 pkt matched: addr=2 len=2 (39 matched so far) |
| 21130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 21130 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 21135 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 21145 | **DUT** | IN  pkt #66 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21145 | yapp monitor | RX pkt #66 on the input: addr=2 len=1 parity=good gap=0 |
| 21145 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21150 | yapp driver | TX pkt #66 accepted by the DUT |
| 21150 | yapp driver | TX pkt #67: addr=1 len=1 parity=bad delay=3 |
| 21155 | **DUT** | OUT ch2 pkt #19 done: 3 bytes in 3 cycles |
| 21155 | ch2 monitor | ch2 RX pkt #19: addr=2 len=1 parity=good |
| 21155 | scoreboard | ch2 pkt matched: addr=2 len=1 (40 matched so far) |
| 21165 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 21185 | **DUT** | IN  pkt #67 header: addr=1 len=1 -> channel 1 |
| 21185 | **DUT** | OUT ch2 pkt #20 done: 3 bytes in 3 cycles |
| 21185 | ch2 monitor | ch2 RX pkt #20: addr=2 len=1 parity=good |
| 21185 | scoreboard | ch2 pkt matched: addr=2 len=1 (41 matched so far) |
| 21195 | **DUT** | OUT ch1 pkt #16 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 21205 | **DUT** | IN  pkt #67 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 21205 | yapp monitor | RX pkt #67 on the input: addr=1 len=1 parity=bad gap=3 |
| 21205 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 21210 | yapp driver | TX pkt #67 accepted by the DUT |
| 21210 | yapp driver | TX pkt #68: addr=2 len=2 parity=bad delay=0 |
| 21215 | **DUT** | IN  pkt #68 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21215 | **DUT** | OUT ch1 pkt #16 done: 3 bytes in 3 cycles |
| 21215 | ch1 monitor | ch1 RX pkt #16: addr=1 len=1 parity=bad |
| 21215 | scoreboard | ch1 pkt matched: addr=1 len=1 (42 matched so far) |
| 21230 | ch2 driver | ch2: packet consumed (response delay 37) |
| 21245 | **DUT** | IN  pkt #68 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 21245 | yapp monitor | RX pkt #68 on the input: addr=2 len=2 parity=bad gap=0 |
| 21245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 21245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 21250 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet (1 more owed) |
| 21250 | error checker | error pulse 4 cycles after the bad packet (1 still owed) |
| 21250 | yapp driver | TX pkt #68 accepted by the DUT |
| 21250 | yapp driver | TX pkt #69: addr=1 len=2 parity=good delay=0 |
| 21255 | **DUT** | IN  pkt #69 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21285 | **DUT** | IN  pkt #69 complete: addr=1 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 21285 | yapp monitor | RX pkt #69 on the input: addr=1 len=2 parity=good gap=0 |
| 21285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 21285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 21290 | yapp driver | TX pkt #69 accepted by the DUT |
| 21290 | yapp driver | TX pkt #70: addr=3 len=1 parity=good delay=0 |
| 21295 | **DUT** | IN  pkt #70 header: addr=3 len=1 -> DROP (illegal address 3) |
| 21315 | **DUT** | IN  pkt #70 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 21315 | yapp monitor | RX pkt #70 on the input: addr=3 len=1 parity=good gap=0 |
| 21315 | reference | Packet dropped: illegal address 3 (len=1) |
| 21315 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 21320 | yapp driver | TX pkt #70 accepted by the DUT |
| 21320 | yapp driver | TX pkt #71: addr=2 len=1 parity=good delay=0 |
| 21325 | **DUT** | IN  pkt #71 header: addr=2 len=1 -> channel 2 |
| 21330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 21330 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 21345 | **DUT** | IN  pkt #71 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21345 | yapp monitor | RX pkt #71 on the input: addr=2 len=1 parity=good gap=0 |
| 21345 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21350 | yapp driver | TX pkt #71 accepted by the DUT |
| 21350 | yapp driver | TX pkt #72: addr=0 len=2 parity=good delay=1 |
| 21365 | **DUT** | IN  pkt #72 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21370 | ch1 driver | ch1: packet consumed (response delay 10) |
| 21395 | **DUT** | IN  pkt #72 complete: addr=0 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 21395 | yapp monitor | RX pkt #72 on the input: addr=0 len=2 parity=good gap=1 |
| 21395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 21395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 21400 | yapp driver | TX pkt #72 accepted by the DUT |
| 21400 | yapp driver | TX pkt #73: addr=2 len=1 parity=bad delay=0 |
| 21405 | **DUT** | IN  pkt #73 header: addr=2 len=1 -> channel 2 |
| 21425 | **DUT** | IN  pkt #73 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 21425 | yapp monitor | RX pkt #73 on the input: addr=2 len=1 parity=bad gap=0 |
| 21425 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21430 | yapp driver | TX pkt #73 accepted by the DUT |
| 21430 | yapp driver | TX pkt #74: addr=2 len=1 parity=good delay=0 |
| 21435 | **DUT** | IN  pkt #74 header: addr=2 len=1 -> channel 2 |
| 21455 | **DUT** | IN  pkt #74 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21455 | yapp monitor | RX pkt #74 on the input: addr=2 len=1 parity=good gap=0 |
| 21455 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21460 | yapp driver | TX pkt #74 accepted by the DUT |
| 21460 | yapp driver | TX pkt #75: addr=0 len=2 parity=good delay=0 |
| 21465 | **DUT** | IN  pkt #75 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 21495 | **DUT** | IN  pkt #75 complete: addr=0 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 21495 | yapp monitor | RX pkt #75 on the input: addr=0 len=2 parity=good gap=0 |
| 21495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 21495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 21500 | yapp driver | TX pkt #75 accepted by the DUT |
| 21500 | yapp driver | TX pkt #76: addr=2 len=1 parity=bad delay=0 |
| 21505 | **DUT** | IN  pkt #76 header: addr=2 len=1 -> channel 2 |
| 21525 | **DUT** | IN  pkt #76 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 21525 | yapp monitor | RX pkt #76 on the input: addr=2 len=1 parity=bad gap=0 |
| 21525 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 21530 | error checker | error pulse 10 cycles after the bad packet (1 still owed) |
| 21530 | yapp driver | TX pkt #76 accepted by the DUT |
| 21530 | yapp driver | TX pkt #77: addr=2 len=3 parity=good delay=0 |
| 21535 | **DUT** | IN  pkt #77 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 1) |
| 21570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 21570 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 21575 | **DUT** | IN  pkt #77 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 21575 | yapp monitor | RX pkt #77 on the input: addr=2 len=3 parity=good gap=0 |
| 21575 | reference | Packet dropped: length 3 > maxpktsize 1 (addr=2) |
| 21575 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 21580 | yapp driver | TX pkt #77 accepted by the DUT |
| 21580 | yapp driver | TX pkt #78: addr=0 len=1 parity=good delay=0 |
| 21585 | **DUT** | IN  pkt #78 header: addr=0 len=1 -> channel 0 |
| 21605 | **DUT** | IN  pkt #78 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21605 | yapp monitor | RX pkt #78 on the input: addr=0 len=1 parity=good gap=0 |
| 21605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21610 | yapp driver | TX pkt #78 accepted by the DUT |
| 21610 | **test** | STAGE: burst 5/6 sent: addr0..3 3/3/9/1, bad parity 5, gap 0 13, length 1..3 |
| 21615 | **DUT** | OUT ch2 pkt #21 start: addr=2 len=1 (receiver waited 28 cycle(s)) |
| 21630 | ch2 driver | ch2: packet consumed (response delay 28) |
| 21630 | hbus driver | Executed WRITE addr=0x1000 data=0xea |
| 21635 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 21635 | hbus monitor | Collected WRITE addr=0x1000 data=0xea |
| 21635 | reference | maxpktsize is now 42 |
| 21650 | hbus driver | Executed WRITE addr=0x1001 data=0x99 |
| 21655 | hbus monitor | Collected WRITE addr=0x1001 data=0x99 |
| 21655 | reference | router_en is now 1 (en_reg 0x99) |
| 21680 | hbus driver | Executed READ  addr=0x1007 data=0x00 |
| 21685 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21710 | hbus driver | Executed READ  addr=0x10cc data=0x00 |
| 21715 | hbus monitor | Collected READ  addr=0x10cc data=0x00 |
| 21730 | hbus driver | Executed WRITE addr=0x1117 data=0x9a |
| 21735 | hbus monitor | Collected WRITE addr=0x1117 data=0x9a |
| 21760 | hbus driver | Executed READ  addr=0x1117 data=0x9a |
| 21765 | hbus monitor | Collected READ  addr=0x1117 data=0x9a |
| 21790 | hbus driver | Executed READ  addr=0x1054 data=0x00 |
| 21795 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=1 (receiver waited 20 cycle(s)) |
| 21795 | hbus monitor | Collected READ  addr=0x1054 data=0x00 |
| 21810 | ch0 driver | ch0: packet consumed (response delay 20) |
| 21810 | hbus driver | Executed WRITE addr=0x11f6 data=0xd7 |
| 21815 | hbus monitor | Collected WRITE addr=0x11f6 data=0xd7 |
| 21840 | hbus driver | Executed READ  addr=0x11f6 data=0xd7 |
| 21845 | hbus monitor | Collected READ  addr=0x11f6 data=0xd7 |
| 21860 | hbus driver | Executed WRITE addr=0x11cd data=0x86 |
| 21865 | hbus monitor | Collected WRITE addr=0x11cd data=0x86 |
| 21885 | **DUT** | OUT ch2 pkt #21 done: 3 bytes in 28 cycles |
| 21885 | ch2 monitor | ch2 RX pkt #21: addr=2 len=1 parity=good |
| 21885 | scoreboard | ch2 pkt matched: addr=2 len=1 (43 matched so far) |
| 21890 | hbus driver | Executed READ  addr=0x11cd data=0x86 |
| 21890 | **test** | STAGE: burst 6/6: ctrl=0xea (maxpktsize 42) en=0x99 (router on, counter enables 1001100), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 21890 | yapp driver | TX pkt #79: addr=3 len=1 parity=bad delay=0 |
| 21895 | **DUT** | OUT ch2 pkt #22 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 21895 | hbus monitor | Collected READ  addr=0x11cd data=0x86 |
| 21905 | **DUT** | IN  pkt #79 header: addr=3 len=1 -> DROP (illegal address 3) |
| 21910 | ch2 driver | ch2: packet consumed (response delay 24) |
| 21925 | **DUT** | IN  pkt #79 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 21925 | yapp monitor | RX pkt #79 on the input: addr=3 len=1 parity=bad gap=29 |
| 21925 | reference | Packet dropped: illegal address 3 (len=1) |
| 21925 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 21930 | yapp driver | TX pkt #79 accepted by the DUT |
| 21930 | yapp driver | TX pkt #80: addr=1 len=1 parity=good delay=0 |
| 21935 | **DUT** | IN  pkt #80 header: addr=1 len=1 -> channel 1 |
| 21950 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 21950 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 21955 | **DUT** | IN  pkt #80 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21955 | yapp monitor | RX pkt #80 on the input: addr=1 len=1 parity=good gap=0 |
| 21955 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 21960 | yapp driver | TX pkt #80 accepted by the DUT |
| 21960 | yapp driver | TX pkt #81: addr=1 len=1 parity=good delay=0 |
| 21965 | **DUT** | IN  pkt #81 header: addr=1 len=1 -> channel 1 |
| 21965 | **DUT** | OUT ch1 pkt #17 start: addr=1 len=1 (receiver waited 2 cycle(s)) |
| 21980 | ch1 driver | ch1: packet consumed (response delay 2) |
| 21985 | **DUT** | IN  pkt #81 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21985 | yapp monitor | RX pkt #81 on the input: addr=1 len=1 parity=good gap=0 |
| 21985 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 21990 | yapp driver | TX pkt #81 accepted by the DUT |
| 21990 | yapp driver | TX pkt #82: addr=1 len=1 parity=bad delay=0 |
| 21995 | **DUT** | IN  pkt #82 header: addr=1 len=1 -> channel 1 |
| 22015 | **DUT** | IN  pkt #82 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 22015 | yapp monitor | RX pkt #82 on the input: addr=1 len=1 parity=bad gap=0 |
| 22015 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 22020 | yapp driver | TX pkt #82 accepted by the DUT |
| 22020 | yapp driver | TX pkt #83: addr=2 len=2 parity=good delay=0 |
| 22025 | **DUT** | IN  pkt #83 header: addr=2 len=2 -> channel 2 |
| 22025 | **DUT** | OUT ch0 pkt #7 done: 3 bytes in 24 cycles |
| 22025 | ch0 monitor | ch0 RX pkt #7: addr=0 len=1 parity=good |
| 22025 | scoreboard | ch0 pkt matched: addr=0 len=1 (44 matched so far) |
| 22055 | **DUT** | IN  pkt #83 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 22055 | yapp monitor | RX pkt #83 on the input: addr=2 len=2 parity=good gap=0 |
| 22055 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 22060 | yapp driver | TX pkt #83 accepted by the DUT |
| 22060 | yapp driver | TX pkt #84: addr=0 len=1 parity=good delay=0 |
| 22065 | **DUT** | IN  pkt #84 header: addr=0 len=1 -> channel 0 |
| 22070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 22070 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 22075 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22085 | **DUT** | IN  pkt #84 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22085 | yapp monitor | RX pkt #84 on the input: addr=0 len=1 parity=good gap=0 |
| 22085 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22090 | yapp driver | TX pkt #84 accepted by the DUT |
| 22090 | yapp driver | TX pkt #85: addr=2 len=3 parity=good delay=0 |
| 22095 | **DUT** | IN  pkt #85 header: addr=2 len=3 -> channel 2 |
| 22095 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 3 cycles |
| 22095 | **DUT** | OUT ch1 pkt #17 done: 3 bytes in 14 cycles |
| 22095 | ch0 monitor | ch0 RX pkt #8: addr=0 len=1 parity=good |
| 22095 | scoreboard | ch0 pkt matched: addr=0 len=1 (45 matched so far) |
| 22095 | ch1 monitor | ch1 RX pkt #17: addr=1 len=1 parity=good |
| 22095 | scoreboard | ch1 pkt matched: addr=1 len=1 (46 matched so far) |
| 22105 | **DUT** | OUT ch1 pkt #18 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 22125 | **DUT** | OUT ch1 pkt #18 done: 3 bytes in 3 cycles |
| 22125 | ch1 monitor | ch1 RX pkt #18: addr=1 len=1 parity=good |
| 22125 | scoreboard | ch1 pkt matched: addr=1 len=1 (47 matched so far) |
| 22135 | **DUT** | IN  pkt #85 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 22135 | **DUT** | OUT ch1 pkt #19 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 22135 | yapp monitor | RX pkt #85 on the input: addr=2 len=3 parity=good gap=0 |
| 22135 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 22140 | yapp driver | TX pkt #85 accepted by the DUT |
| 22140 | yapp driver | TX pkt #86: addr=2 len=3 parity=good delay=0 |
| 22145 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x0e held (pkt #86) |
| 22155 | **DUT** | OUT ch1 pkt #19 done: 3 bytes in 3 cycles |
| 22155 | ch1 monitor | ch1 RX pkt #19: addr=1 len=1 parity=bad |
| 22155 | scoreboard | ch1 pkt matched: addr=1 len=1 (48 matched so far) |
| 22275 | **DUT** | OUT ch2 pkt #22 done: 3 bytes in 39 cycles |
| 22275 | ch2 monitor | ch2 RX pkt #22: addr=2 len=1 parity=bad |
| 22275 | scoreboard | ch2 pkt matched: addr=2 len=1 (49 matched so far) |
| 22285 | **DUT** | IN  pkt #86 header: addr=2 len=3 -> channel 2 |
| 22285 | **DUT** | SUSPEND released after 14 cycle(s) |
| 22285 | **DUT** | OUT ch2 pkt #23 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 22305 | **DUT** | OUT ch2 pkt #23 done: 3 bytes in 3 cycles |
| 22305 | ch2 monitor | ch2 RX pkt #23: addr=2 len=1 parity=good |
| 22305 | scoreboard | ch2 pkt matched: addr=2 len=1 (50 matched so far) |
| 22315 | **DUT** | OUT ch2 pkt #24 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 22325 | **DUT** | IN  pkt #86 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 22325 | yapp monitor | RX pkt #86 on the input: addr=2 len=3 parity=good gap=0 |
| 22325 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 22330 | yapp driver | TX pkt #86 accepted by the DUT |
| 22330 | yapp driver | TX pkt #87: addr=0 len=2 parity=bad delay=0 |
| 22335 | **DUT** | IN  pkt #87 header: addr=0 len=2 -> channel 0 |
| 22335 | **DUT** | OUT ch2 pkt #24 done: 3 bytes in 3 cycles |
| 22335 | ch2 monitor | ch2 RX pkt #24: addr=2 len=1 parity=bad |
| 22335 | scoreboard | ch2 pkt matched: addr=2 len=1 (51 matched so far) |
| 22345 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 22345 | **DUT** | OUT ch2 pkt #25 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 22365 | **DUT** | IN  pkt #87 complete: addr=0 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 22365 | yapp monitor | RX pkt #87 on the input: addr=0 len=2 parity=bad gap=0 |
| 22365 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 22370 | yapp driver | TX pkt #87 accepted by the DUT |
| 22370 | yapp driver | TX pkt #88: addr=2 len=3 parity=good delay=0 |
| 22375 | **DUT** | IN  pkt #88 header: addr=2 len=3 -> channel 2 |
| 22375 | **DUT** | OUT ch0 pkt #9 done: 4 bytes in 4 cycles |
| 22375 | **DUT** | OUT ch2 pkt #25 done: 4 bytes in 4 cycles |
| 22375 | ch0 monitor | ch0 RX pkt #9: addr=0 len=2 parity=bad |
| 22375 | scoreboard | ch0 pkt matched: addr=0 len=2 (52 matched so far) |
| 22375 | ch2 monitor | ch2 RX pkt #25: addr=2 len=2 parity=good |
| 22375 | scoreboard | ch2 pkt matched: addr=2 len=2 (53 matched so far) |
| 22385 | **DUT** | OUT ch2 pkt #26 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 22415 | **DUT** | IN  pkt #88 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 22415 | yapp monitor | RX pkt #88 on the input: addr=2 len=3 parity=good gap=0 |
| 22415 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 22420 | yapp driver | TX pkt #88 accepted by the DUT |
| 22420 | yapp driver | TX pkt #89: addr=1 len=1 parity=good delay=0 |
| 22425 | **DUT** | IN  pkt #89 header: addr=1 len=1 -> channel 1 |
| 22425 | **DUT** | OUT ch2 pkt #26 done: 5 bytes in 5 cycles |
| 22425 | ch2 monitor | ch2 RX pkt #26: addr=2 len=3 parity=good |
| 22425 | scoreboard | ch2 pkt matched: addr=2 len=3 (54 matched so far) |
| 22435 | **DUT** | OUT ch1 pkt #20 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 22435 | **DUT** | OUT ch2 pkt #27 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 22445 | **DUT** | IN  pkt #89 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22445 | yapp monitor | RX pkt #89 on the input: addr=1 len=1 parity=good gap=0 |
| 22445 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 22450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 22450 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 22450 | yapp driver | TX pkt #89 accepted by the DUT |
| 22450 | yapp driver | TX pkt #90: addr=2 len=3 parity=good delay=0 |
| 22455 | **DUT** | IN  pkt #90 header: addr=2 len=3 -> channel 2 |
| 22455 | **DUT** | OUT ch1 pkt #20 done: 3 bytes in 3 cycles |
| 22455 | ch1 monitor | ch1 RX pkt #20: addr=1 len=1 parity=good |
| 22455 | scoreboard | ch1 pkt matched: addr=1 len=1 (55 matched so far) |
| 22475 | **DUT** | OUT ch2 pkt #27 done: 5 bytes in 5 cycles |
| 22475 | ch2 monitor | ch2 RX pkt #27: addr=2 len=3 parity=good |
| 22475 | scoreboard | ch2 pkt matched: addr=2 len=3 (56 matched so far) |
| 22485 | **DUT** | OUT ch2 pkt #28 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 22495 | **DUT** | IN  pkt #90 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 22495 | yapp monitor | RX pkt #90 on the input: addr=2 len=3 parity=good gap=0 |
| 22495 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 22500 | yapp driver | TX pkt #90 accepted by the DUT |
| 22500 | yapp driver | TX pkt #91: addr=0 len=2 parity=good delay=0 |
| 22505 | **DUT** | IN  pkt #91 header: addr=0 len=2 -> channel 0 |
| 22515 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 22525 | **DUT** | OUT ch2 pkt #28 done: 5 bytes in 5 cycles |
| 22525 | ch2 monitor | ch2 RX pkt #28: addr=2 len=3 parity=good |
| 22525 | scoreboard | ch2 pkt matched: addr=2 len=3 (57 matched so far) |
| 22535 | **DUT** | IN  pkt #91 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 22535 | **DUT** | OUT ch2 pkt #29 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 22535 | yapp monitor | RX pkt #91 on the input: addr=0 len=2 parity=good gap=0 |
| 22535 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 22540 | yapp driver | TX pkt #91 accepted by the DUT |
| 22540 | yapp driver | TX pkt #92: addr=1 len=3 parity=good delay=0 |
| 22545 | **DUT** | IN  pkt #92 header: addr=1 len=3 -> channel 1 |
| 22545 | **DUT** | OUT ch0 pkt #10 done: 4 bytes in 4 cycles |
| 22545 | ch0 monitor | ch0 RX pkt #10: addr=0 len=2 parity=good |
| 22545 | scoreboard | ch0 pkt matched: addr=0 len=2 (58 matched so far) |
| 22555 | **DUT** | OUT ch1 pkt #21 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 22575 | **DUT** | OUT ch2 pkt #29 done: 5 bytes in 5 cycles |
| 22575 | ch2 monitor | ch2 RX pkt #29: addr=2 len=3 parity=good |
| 22575 | scoreboard | ch2 pkt matched: addr=2 len=3 (59 matched so far) |
| 22580 | ch0 driver | ch0: packet consumed (response delay 20) |
| 22585 | **DUT** | IN  pkt #92 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 22585 | yapp monitor | RX pkt #92 on the input: addr=1 len=3 parity=good gap=0 |
| 22585 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 22590 | yapp driver | TX pkt #92 accepted by the DUT |
| 22590 | yapp driver | TX pkt #93: addr=3 len=1 parity=bad delay=0 |
| 22595 | **DUT** | IN  pkt #93 header: addr=3 len=1 -> DROP (illegal address 3) |
| 22595 | **DUT** | OUT ch1 pkt #21 done: 5 bytes in 5 cycles |
| 22595 | ch1 monitor | ch1 RX pkt #21: addr=1 len=3 parity=good |
| 22595 | scoreboard | ch1 pkt matched: addr=1 len=3 (60 matched so far) |
| 22600 | ch2 driver | ch2: packet consumed (response delay 35) |
| 22615 | **DUT** | IN  pkt #93 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 22615 | yapp monitor | RX pkt #93 on the input: addr=3 len=1 parity=bad gap=0 |
| 22615 | reference | Packet dropped: illegal address 3 (len=1) |
| 22615 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 22620 | yapp driver | TX pkt #93 accepted by the DUT |
| 22620 | yapp driver | TX pkt #94: addr=3 len=1 parity=good delay=0 |
| 22625 | **DUT** | IN  pkt #94 header: addr=3 len=1 -> DROP (illegal address 3) |
| 22630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 22630 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 22645 | **DUT** | IN  pkt #94 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 22645 | yapp monitor | RX pkt #94 on the input: addr=3 len=1 parity=good gap=0 |
| 22645 | reference | Packet dropped: illegal address 3 (len=1) |
| 22645 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 22650 | yapp driver | TX pkt #94 accepted by the DUT |
| 22650 | **test** | STAGE: burst 6/6 sent: addr0..3 3/5/5/3, bad parity 4, gap 0 16, length 1..3 |
| 22650 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 22680 | ch1 driver | ch1: packet consumed (response delay 10) |
| 22680 | hbus driver | Executed READ  addr=0x1000 data=0xea |
| 22685 | hbus monitor | Collected READ  addr=0x1000 data=0xea |
| 22710 | hbus driver | Executed READ  addr=0x1001 data=0x99 |
| 22715 | hbus monitor | Collected READ  addr=0x1001 data=0x99 |
| 22740 | hbus driver | Executed READ  addr=0x1004 data=0x17 |
| 22745 | hbus monitor | Collected READ  addr=0x1004 data=0x17 |
| 22770 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 22775 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22800 | hbus driver | Executed READ  addr=0x1006 data=0x06 |
| 22805 | hbus monitor | Collected READ  addr=0x1006 data=0x06 |
| 22830 | hbus driver | Executed READ  addr=0x1009 data=0x0a |
| 22835 | hbus monitor | Collected READ  addr=0x1009 data=0x0a |
| 22860 | hbus driver | Executed READ  addr=0x100a data=0x06 |
| 22865 | hbus monitor | Collected READ  addr=0x100a data=0x06 |
| 22890 | hbus driver | Executed READ  addr=0x100b data=0x08 |
| 22895 | hbus monitor | Collected READ  addr=0x100b data=0x08 |
| 22920 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 22925 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 22950 | hbus driver | Executed READ  addr=0x1010 data=0x07 |
| 22955 | hbus monitor | Collected READ  addr=0x1010 data=0x07 |
| 22980 | hbus driver | Executed READ  addr=0x1011 data=0x15 |
| 22985 | hbus monitor | Collected READ  addr=0x1011 data=0x15 |
| 23095 | **test** | STAGE: done: 94 packets (60 forwarded, 34 dropped), 4 storm burst(s), 60 scoreboard matches, 44 HBUS reads checked, 27 error pulses for 27 bad packets |
| 23295 | error checker | error pulse report: 27 bad packets, 27 pulses, 0 outside 1..10 cycles, at most 2 owed at once |
| 23295 | ch0 monitor | Channel 0 report: 10 packets collected |
| 23295 | ch1 monitor | Channel 1 report: 21 packets collected |
| 23295 | ch2 monitor | Channel 2 report: 29 packets collected |
| 23295 | hbus monitor | HBUS report: 30 writes, 49 reads |
| 23295 | coverage | Coverage of the router configuration: 87.0% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 16 / 31 / 16 / 16 packets · length < max / = max / max+1 / > max+1 : 57 / 11 / 10 / 1 · forwarded good / bad : 41 / 19 · dropped address 3 good / bad : 6 / 4 · dropped oversized good / bad : 5 / 4 · counter enables none / mixed / all : 0 / 79 / 0 |
| 23295 | coverage | HBUS address coverage: 79 accesses sampled, coverage 54.5% |
| 23295 | coverage | HBUS register bits coverage: 12 writes to ctrl_reg/en_reg, coverage 100.0% |
| 23295 | coverage | HBUS counter value coverage: 10 counter reads sampled, coverage 51.9% |
| 23295 | coverage | HBUS yapp_mem data coverage: 36 accesses sampled, coverage 64.7% |
| 23295 | reference | --- Reference model report --- · forwarded to scoreboard : 60 · dropped (router disabled) : 15 · dropped (oversized) : 9 · dropped (address 3) : 10 · counters parity/oversized/addr0..3 : 23 / 0 / 10 6 8 6 |
| 23295 | reference | HBUS reads checked against the model: 44 (0 mismatches, 5 of memory bytes never written) |
| 23295 | scoreboard | --- Scoreboard report --- · packets received : 60 · packets matched : 60 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 23295 | yapp driver | YAPP driver report: 94 packets sent |
| 23295 | coverage | YAPP gap coverage: 93 gaps sampled, coverage 100.0% |
| 23295 | yapp monitor | YAPP monitor report: 94 packets collected, 28 with bad parity |
| 23295 | yapp monitor | YAPP gaps: 62 back to back, 9 of 1 cycle, 3 of 2, 19 longer |
| 23295 | coverage | YAPP packet coverage: 94 packets sampled, coverage 76.7% |
