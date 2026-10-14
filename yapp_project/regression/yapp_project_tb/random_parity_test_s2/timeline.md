# random_parity_test seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 15us · wall 13.8 s · log [`random_parity_test_s2.log`](random_parity_test_s2.log)

Waves: `random_parity_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s2%2Frandom_parity_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **49** packet(s) (15 with bad parity); the input monitor saw 49.
- Router: **41** forwarded, **8** dropped (4 oversized, 4 illegal address 3).
- Packets out: ch0 **6**, ch1 **15**, ch2 **20**.
- Scoreboard: 41 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **1** time(s), longest hold 7 cycle(s).
- Error pulses: 15.
- HBUS: 21 write(s), 37 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_NORMAL |
| 0 | random scenario: 49 packets in 5 bursts |
| 220 | burst 1/5: ctrl=0x3c (maxpktsize 60) en=0xff (router on, counter enables 1111111), 9 packet(s) |
| 3900 | burst 1/5 sent: addr0..3 0/3/6/0, bad parity 3, gap 0 3, length 8..63 |
| 4240 | burst 2/5: ctrl=0x3f (maxpktsize 63) en=0xc3 (router on, counter enables 1100001), 10 packet(s) |
| 9260 | burst 2/5 sent: addr0..3 0/4/5/1, bad parity 3, gap 0 1, length 1..63 |
| 9620 | burst 3/5: ctrl=0xfe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 10 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 10010 | burst 3/5 sent: addr0..3 3/4/2/1, bad parity 3, gap 0 9, length 1..3 |
| 10160 | burst 4/5: ctrl=0xee (maxpktsize 46) en=0x0b (router on, counter enables 0000101), 9 packet(s) |
| 14040 | burst 4/5 sent: addr0..3 3/2/3/1, bad parity 2, gap 0 6, length 13..63 |
| 14190 | burst 5/5: ctrl=0x4c (maxpktsize 12) en=0x31 (router on, counter enables 0011000), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 14660 | burst 5/5 sent: addr0..3 1/3/6/1, bad parity 4, gap 0 9, length 1..3 |
| 14660 | final reads: every register and the stored packet, checked against the reference model |
| 15135 | done: 49 packets (41 forwarded, 8 dropped), 2 storm burst(s), 41 scoreboard matches, 36 HBUS reads checked, 15 error pulses for 15 bad packets |

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

714 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_NORMAL |
| 0 | **test** | STAGE: random scenario: 49 packets in 5 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x3c |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=60 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x3c |
| 75 | reference | maxpktsize is now 60 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 110 | hbus driver | Executed WRITE addr=0x1176 data=0xe5 |
| 115 | hbus monitor | Collected WRITE addr=0x1176 data=0xe5 |
| 140 | hbus driver | Executed READ  addr=0x1176 data=0xe5 |
| 145 | hbus monitor | Collected READ  addr=0x1176 data=0xe5 |
| 170 | hbus driver | Executed READ  addr=0x104b data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x104b data=0x00 |
| 190 | hbus driver | Executed WRITE addr=0x1115 data=0x1b |
| 195 | hbus monitor | Collected WRITE addr=0x1115 data=0x1b |
| 220 | hbus driver | Executed READ  addr=0x1115 data=0x1b |
| 220 | **test** | STAGE: burst 1/5: ctrl=0x3c (maxpktsize 60) en=0xff (router on, counter enables 1111111), 9 packet(s) |
| 220 | yapp driver | TX pkt #1: addr=1 len=47 parity=good delay=0 |
| 225 | hbus monitor | Collected READ  addr=0x1115 data=0x1b |
| 235 | **DUT** | IN  pkt #1 header: addr=1 len=47 -> channel 1 |
| 245 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=47 (receiver waited 0 cycle(s)) |
| 715 | **DUT** | IN  pkt #1 complete: addr=1 len=47 parity=ok forwarded, 49 bytes in 49 cycles (held 0) |
| 715 | yapp monitor | RX pkt #1 on the input: addr=1 len=47 parity=good gap=18 |
| 715 | reference | Packet forwarded: addr=1 len=47 -> channel 1 |
| 720 | ch1 driver | ch1: packet consumed (response delay 0) |
| 720 | yapp driver | TX pkt #1 accepted by the DUT |
| 720 | yapp driver | TX pkt #2: addr=2 len=13 parity=good delay=2 |
| 735 | **DUT** | OUT ch1 pkt #1 done: 49 bytes in 50 cycles |
| 735 | ch1 monitor | ch1 RX pkt #1: addr=1 len=47 parity=good |
| 735 | scoreboard | ch1 pkt matched: addr=1 len=47 (1 matched so far) |
| 745 | **DUT** | IN  pkt #2 header: addr=2 len=13 -> channel 2 |
| 760 | ch1 driver | ch1: packet consumed (response delay 0) |
| 845 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=13 (receiver waited 9 cycle(s)) |
| 885 | **DUT** | IN  pkt #2 complete: addr=2 len=13 parity=ok forwarded, 15 bytes in 15 cycles (held 0) |
| 885 | yapp monitor | RX pkt #2 on the input: addr=2 len=13 parity=good gap=2 |
| 885 | reference | Packet forwarded: addr=2 len=13 -> channel 2 |
| 890 | yapp driver | TX pkt #2 accepted by the DUT |
| 890 | yapp driver | TX pkt #3: addr=1 len=18 parity=bad delay=3 |
| 925 | **DUT** | IN  pkt #3 header: addr=1 len=18 -> channel 1 |
| 935 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=18 (receiver waited 0 cycle(s)) |
| 980 | ch2 driver | ch2: packet consumed (response delay 9) |
| 1055 | **DUT** | OUT ch2 pkt #1 done: 15 bytes in 22 cycles |
| 1055 | ch2 monitor | ch2 RX pkt #1: addr=2 len=13 parity=good |
| 1055 | scoreboard | ch2 pkt matched: addr=2 len=13 (2 matched so far) |
| 1115 | **DUT** | IN  pkt #3 complete: addr=1 len=18 parity=BAD forwarded, 20 bytes in 20 cycles (held 0) |
| 1115 | yapp monitor | RX pkt #3 on the input: addr=1 len=18 parity=bad gap=3 |
| 1115 | reference | Packet forwarded: addr=1 len=18 -> channel 1 |
| 1120 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1120 | yapp driver | TX pkt #3 accepted by the DUT |
| 1120 | yapp driver | TX pkt #4: addr=2 len=63 parity=good delay=2 |
| 1130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 1130 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 1135 | **DUT** | OUT ch1 pkt #2 done: 20 bytes in 21 cycles |
| 1135 | ch1 monitor | ch1 RX pkt #2: addr=1 len=18 parity=bad |
| 1135 | scoreboard | ch1 pkt matched: addr=1 len=18 (3 matched so far) |
| 1145 | **DUT** | IN  pkt #4 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 60) |
| 1310 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1440 | ch2 driver | ch2: packet consumed (response delay 6) |
| 1785 | **DUT** | IN  pkt #4 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1785 | yapp monitor | RX pkt #4 on the input: addr=2 len=63 parity=good gap=2 |
| 1785 | reference | Packet dropped: length 63 > maxpktsize 60 (addr=2) |
| 1785 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 1790 | yapp driver | TX pkt #4 accepted by the DUT |
| 1790 | yapp driver | TX pkt #5: addr=1 len=43 parity=good delay=1 |
| 1805 | **DUT** | IN  pkt #5 header: addr=1 len=43 -> channel 1 |
| 1815 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=43 (receiver waited 0 cycle(s)) |
| 2245 | **DUT** | IN  pkt #5 complete: addr=1 len=43 parity=ok forwarded, 45 bytes in 45 cycles (held 0) |
| 2245 | yapp monitor | RX pkt #5 on the input: addr=1 len=43 parity=good gap=1 |
| 2245 | reference | Packet forwarded: addr=1 len=43 -> channel 1 |
| 2250 | ch1 driver | ch1: packet consumed (response delay 0) |
| 2250 | yapp driver | TX pkt #5 accepted by the DUT |
| 2250 | yapp driver | TX pkt #6: addr=2 len=26 parity=bad delay=0 |
| 2255 | **DUT** | IN  pkt #6 header: addr=2 len=26 -> channel 2 |
| 2265 | **DUT** | OUT ch1 pkt #3 done: 45 bytes in 46 cycles |
| 2265 | ch1 monitor | ch1 RX pkt #3: addr=1 len=43 parity=good |
| 2265 | scoreboard | ch1 pkt matched: addr=1 len=43 (4 matched so far) |
| 2345 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=26 (receiver waited 8 cycle(s)) |
| 2525 | **DUT** | IN  pkt #6 complete: addr=2 len=26 parity=BAD forwarded, 28 bytes in 28 cycles (held 0) |
| 2525 | yapp monitor | RX pkt #6 on the input: addr=2 len=26 parity=bad gap=0 |
| 2525 | reference | Packet forwarded: addr=2 len=26 -> channel 2 |
| 2530 | yapp driver | TX pkt #6 accepted by the DUT |
| 2530 | yapp driver | TX pkt #7: addr=2 len=26 parity=good delay=20 |
| 2610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 2610 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 2610 | ch2 driver | ch2: packet consumed (response delay 8) |
| 2660 | ch1 driver | ch1: packet consumed (response delay 0) |
| 2705 | **DUT** | OUT ch2 pkt #2 done: 28 bytes in 37 cycles |
| 2705 | ch2 monitor | ch2 RX pkt #2: addr=2 len=26 parity=bad |
| 2705 | scoreboard | ch2 pkt matched: addr=2 len=26 (5 matched so far) |
| 2735 | **DUT** | IN  pkt #7 header: addr=2 len=26 -> channel 2 |
| 2745 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=26 (receiver waited 0 cycle(s)) |
| 3005 | **DUT** | IN  pkt #7 complete: addr=2 len=26 parity=ok forwarded, 28 bytes in 28 cycles (held 0) |
| 3005 | yapp monitor | RX pkt #7 on the input: addr=2 len=26 parity=good gap=20 |
| 3005 | reference | Packet forwarded: addr=2 len=26 -> channel 2 |
| 3010 | yapp driver | TX pkt #7 accepted by the DUT |
| 3010 | yapp driver | TX pkt #8: addr=2 len=59 parity=bad delay=0 |
| 3015 | **DUT** | IN  pkt #8 header: addr=2 len=59 -> channel 2 |
| 3015 | **DUT** | OUT ch2 pkt #3 done: 28 bytes in 28 cycles |
| 3015 | ch2 monitor | ch2 RX pkt #3: addr=2 len=26 parity=good |
| 3015 | scoreboard | ch2 pkt matched: addr=2 len=26 (6 matched so far) |
| 3025 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=59 (receiver waited 0 cycle(s)) |
| 3200 | ch2 driver | ch2: packet consumed (response delay 8) |
| 3470 | ch2 driver | ch2: packet consumed (response delay 3) |
| 3615 | **DUT** | IN  pkt #8 complete: addr=2 len=59 parity=BAD forwarded, 61 bytes in 61 cycles (held 0) |
| 3615 | yapp monitor | RX pkt #8 on the input: addr=2 len=59 parity=bad gap=0 |
| 3615 | reference | Packet forwarded: addr=2 len=59 -> channel 2 |
| 3620 | yapp driver | TX pkt #8 accepted by the DUT |
| 3620 | yapp driver | TX pkt #9: addr=2 len=8 parity=good delay=18 |
| 3670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 3670 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 3745 | **DUT** | OUT ch2 pkt #4 done: 61 bytes in 73 cycles |
| 3745 | ch2 monitor | ch2 RX pkt #4: addr=2 len=59 parity=bad |
| 3745 | scoreboard | ch2 pkt matched: addr=2 len=59 (7 matched so far) |
| 3805 | **DUT** | IN  pkt #9 header: addr=2 len=8 -> channel 2 |
| 3815 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 3860 | ch2 driver | ch2: packet consumed (response delay 7) |
| 3895 | **DUT** | IN  pkt #9 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 3895 | yapp monitor | RX pkt #9 on the input: addr=2 len=8 parity=good gap=18 |
| 3895 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 3900 | yapp driver | TX pkt #9 accepted by the DUT |
| 3900 | **test** | STAGE: burst 1/5 sent: addr0..3 0/3/6/0, bad parity 3, gap 0 3, length 8..63 |
| 3920 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 3925 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 3925 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 3925 | reference | maxpktsize is now 63 |
| 3940 | hbus driver | Executed WRITE addr=0x1001 data=0xc3 |
| 3945 | hbus monitor | Collected WRITE addr=0x1001 data=0xc3 |
| 3945 | reference | router_en is now 1 (en_reg 0xc3) |
| 3960 | hbus driver | Executed WRITE addr=0x11ab data=0xf0 |
| 3965 | hbus monitor | Collected WRITE addr=0x11ab data=0xf0 |
| 3990 | hbus driver | Executed READ  addr=0x11ab data=0xf0 |
| 3995 | hbus monitor | Collected READ  addr=0x11ab data=0xf0 |
| 4010 | hbus driver | Executed WRITE addr=0x1142 data=0x7c |
| 4015 | **DUT** | OUT ch2 pkt #5 done: 10 bytes in 21 cycles |
| 4015 | ch2 monitor | ch2 RX pkt #5: addr=2 len=8 parity=good |
| 4015 | scoreboard | ch2 pkt matched: addr=2 len=8 (8 matched so far) |
| 4015 | hbus monitor | Collected WRITE addr=0x1142 data=0x7c |
| 4040 | hbus driver | Executed READ  addr=0x1142 data=0x7c |
| 4045 | hbus monitor | Collected READ  addr=0x1142 data=0x7c |
| 4070 | hbus driver | Executed READ  addr=0x1021 data=0x75 |
| 4075 | hbus monitor | Collected READ  addr=0x1021 data=0x75 |
| 4100 | hbus driver | Executed READ  addr=0x103b data=0xfb |
| 4105 | hbus monitor | Collected READ  addr=0x103b data=0xfb |
| 4130 | hbus driver | Executed READ  addr=0x100d data=0x08 |
| 4135 | hbus monitor | Collected READ  addr=0x100d data=0x08 |
| 4160 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 4165 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4180 | hbus driver | Executed WRITE addr=0x11c0 data=0xd6 |
| 4185 | hbus monitor | Collected WRITE addr=0x11c0 data=0xd6 |
| 4210 | hbus driver | Executed READ  addr=0x11c0 data=0xd6 |
| 4215 | hbus monitor | Collected READ  addr=0x11c0 data=0xd6 |
| 4240 | hbus driver | Executed READ  addr=0x1001 data=0xc3 |
| 4240 | **test** | STAGE: burst 2/5: ctrl=0x3f (maxpktsize 63) en=0xc3 (router on, counter enables 1100001), 10 packet(s) |
| 4240 | yapp driver | TX pkt #10: addr=2 len=63 parity=good delay=1 |
| 4245 | hbus monitor | Collected READ  addr=0x1001 data=0xc3 |
| 4265 | **DUT** | IN  pkt #10 header: addr=2 len=63 -> channel 2 |
| 4275 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 4310 | ch2 driver | ch2: packet consumed (response delay 10) |
| 4905 | **DUT** | IN  pkt #10 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 4905 | yapp monitor | RX pkt #10 on the input: addr=2 len=63 parity=good gap=36 |
| 4905 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 4910 | yapp driver | TX pkt #10 accepted by the DUT |
| 4910 | yapp driver | TX pkt #11: addr=1 len=59 parity=good delay=15 |
| 4990 | ch2 driver | ch2: packet consumed (response delay 9) |
| 5045 | **DUT** | OUT ch2 pkt #6 done: 65 bytes in 78 cycles |
| 5045 | ch2 monitor | ch2 RX pkt #6: addr=2 len=63 parity=good |
| 5045 | scoreboard | ch2 pkt matched: addr=2 len=63 (9 matched so far) |
| 5065 | **DUT** | IN  pkt #11 header: addr=1 len=59 -> channel 1 |
| 5075 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=59 (receiver waited 0 cycle(s)) |
| 5470 | ch2 driver | ch2: packet consumed (response delay 2) |
| 5665 | **DUT** | IN  pkt #11 complete: addr=1 len=59 parity=ok forwarded, 61 bytes in 61 cycles (held 0) |
| 5665 | yapp monitor | RX pkt #11 on the input: addr=1 len=59 parity=good gap=15 |
| 5665 | reference | Packet forwarded: addr=1 len=59 -> channel 1 |
| 5670 | ch1 driver | ch1: packet consumed (response delay 0) |
| 5670 | yapp driver | TX pkt #11 accepted by the DUT |
| 5670 | yapp driver | TX pkt #12: addr=1 len=63 parity=bad delay=20 |
| 5685 | **DUT** | OUT ch1 pkt #4 done: 61 bytes in 62 cycles |
| 5685 | ch1 monitor | ch1 RX pkt #4: addr=1 len=59 parity=good |
| 5685 | scoreboard | ch1 pkt matched: addr=1 len=59 (10 matched so far) |
| 5790 | ch1 driver | ch1: packet consumed (response delay 0) |
| 5875 | **DUT** | IN  pkt #12 header: addr=1 len=63 -> channel 1 |
| 5885 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=63 (receiver waited 0 cycle(s)) |
| 6515 | **DUT** | IN  pkt #12 complete: addr=1 len=63 parity=BAD forwarded, 65 bytes in 65 cycles (held 0) |
| 6515 | yapp monitor | RX pkt #12 on the input: addr=1 len=63 parity=bad gap=20 |
| 6515 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 6520 | ch1 driver | ch1: packet consumed (response delay 0) |
| 6520 | yapp driver | TX pkt #12 accepted by the DUT |
| 6520 | yapp driver | TX pkt #13: addr=3 len=38 parity=good delay=3 |
| 6535 | **DUT** | OUT ch1 pkt #5 done: 65 bytes in 66 cycles |
| 6535 | ch1 monitor | ch1 RX pkt #5: addr=1 len=63 parity=bad |
| 6535 | scoreboard | ch1 pkt matched: addr=1 len=63 (11 matched so far) |
| 6555 | **DUT** | IN  pkt #13 header: addr=3 len=38 -> DROP (illegal address 3) |
| 6570 | ch1 driver | ch1: packet consumed (response delay 0) |
| 6590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 6590 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 6945 | **DUT** | IN  pkt #13 complete: addr=3 len=38 parity=ok dropped, 40 bytes in 40 cycles (held 0) |
| 6945 | yapp monitor | RX pkt #13 on the input: addr=3 len=38 parity=good gap=3 |
| 6945 | reference | Packet dropped: illegal address 3 (len=38) |
| 6945 | **DUT** | ROUTER DROPS PACKET addr=3 length=38 (    illegal address) |
| 6950 | yapp driver | TX pkt #13 accepted by the DUT |
| 6950 | yapp driver | TX pkt #14: addr=1 len=1 parity=bad delay=8 |
| 7035 | **DUT** | IN  pkt #14 header: addr=1 len=1 -> channel 1 |
| 7045 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 7055 | **DUT** | IN  pkt #14 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 7055 | yapp monitor | RX pkt #14 on the input: addr=1 len=1 parity=bad gap=8 |
| 7055 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 7060 | ch1 driver | ch1: packet consumed (response delay 0) |
| 7060 | yapp driver | TX pkt #14 accepted by the DUT |
| 7060 | yapp driver | TX pkt #15: addr=2 len=49 parity=good delay=11 |
| 7075 | **DUT** | OUT ch1 pkt #6 done: 3 bytes in 4 cycles |
| 7075 | ch1 monitor | ch1 RX pkt #6: addr=1 len=1 parity=bad |
| 7075 | scoreboard | ch1 pkt matched: addr=1 len=1 (12 matched so far) |
| 7090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 7090 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 7175 | **DUT** | IN  pkt #15 header: addr=2 len=49 -> channel 2 |
| 7195 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=49 (receiver waited 1 cycle(s)) |
| 7210 | ch1 driver | ch1: packet consumed (response delay 0) |
| 7675 | **DUT** | IN  pkt #15 complete: addr=2 len=49 parity=ok forwarded, 51 bytes in 51 cycles (held 0) |
| 7675 | yapp monitor | RX pkt #15 on the input: addr=2 len=49 parity=good gap=11 |
| 7675 | reference | Packet forwarded: addr=2 len=49 -> channel 2 |
| 7680 | yapp driver | TX pkt #15 accepted by the DUT |
| 7680 | yapp driver | TX pkt #16: addr=2 len=45 parity=good delay=3 |
| 7690 | ch2 driver | ch2: packet consumed (response delay 1) |
| 7715 | **DUT** | IN  pkt #16 header: addr=2 len=45 -> channel 2 |
| 7795 | **DUT** | OUT ch2 pkt #7 done: 51 bytes in 61 cycles |
| 7795 | ch2 monitor | ch2 RX pkt #7: addr=2 len=49 parity=good |
| 7795 | scoreboard | ch2 pkt matched: addr=2 len=49 (13 matched so far) |
| 7805 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=45 (receiver waited 0 cycle(s)) |
| 8000 | ch2 driver | ch2: packet consumed (response delay 9) |
| 8175 | **DUT** | IN  pkt #16 complete: addr=2 len=45 parity=ok forwarded, 47 bytes in 47 cycles (held 0) |
| 8175 | yapp monitor | RX pkt #16 on the input: addr=2 len=45 parity=good gap=3 |
| 8175 | reference | Packet forwarded: addr=2 len=45 -> channel 2 |
| 8180 | yapp driver | TX pkt #16 accepted by the DUT |
| 8180 | yapp driver | TX pkt #17: addr=1 len=43 parity=good delay=0 |
| 8185 | **DUT** | IN  pkt #17 header: addr=1 len=43 -> channel 1 |
| 8195 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=43 (receiver waited 0 cycle(s)) |
| 8305 | **DUT** | OUT ch2 pkt #8 done: 47 bytes in 51 cycles |
| 8305 | ch2 monitor | ch2 RX pkt #8: addr=2 len=45 parity=good |
| 8305 | scoreboard | ch2 pkt matched: addr=2 len=45 (14 matched so far) |
| 8580 | ch2 driver | ch2: packet consumed (response delay 3) |
| 8625 | **DUT** | IN  pkt #17 complete: addr=1 len=43 parity=ok forwarded, 45 bytes in 45 cycles (held 0) |
| 8625 | yapp monitor | RX pkt #17 on the input: addr=1 len=43 parity=good gap=0 |
| 8625 | reference | Packet forwarded: addr=1 len=43 -> channel 1 |
| 8630 | ch1 driver | ch1: packet consumed (response delay 0) |
| 8630 | yapp driver | TX pkt #17 accepted by the DUT |
| 8630 | yapp driver | TX pkt #18: addr=2 len=26 parity=bad delay=1 |
| 8645 | **DUT** | IN  pkt #18 header: addr=2 len=26 -> channel 2 |
| 8645 | **DUT** | OUT ch1 pkt #7 done: 45 bytes in 46 cycles |
| 8645 | ch1 monitor | ch1 RX pkt #7: addr=1 len=43 parity=good |
| 8645 | scoreboard | ch1 pkt matched: addr=1 len=43 (15 matched so far) |
| 8755 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=26 (receiver waited 10 cycle(s)) |
| 8915 | **DUT** | IN  pkt #18 complete: addr=2 len=26 parity=BAD forwarded, 28 bytes in 28 cycles (held 0) |
| 8915 | yapp monitor | RX pkt #18 on the input: addr=2 len=26 parity=bad gap=1 |
| 8915 | reference | Packet forwarded: addr=2 len=26 -> channel 2 |
| 8920 | yapp driver | TX pkt #18 accepted by the DUT |
| 8920 | yapp driver | TX pkt #19: addr=2 len=30 parity=good delay=2 |
| 8945 | **DUT** | IN  pkt #19 header: addr=2 len=30 -> channel 2 |
| 8990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 8990 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 9020 | ch2 driver | ch2: packet consumed (response delay 10) |
| 9055 | **DUT** | OUT ch2 pkt #9 done: 28 bytes in 31 cycles |
| 9055 | ch2 monitor | ch2 RX pkt #9: addr=2 len=26 parity=bad |
| 9055 | scoreboard | ch2 pkt matched: addr=2 len=26 (16 matched so far) |
| 9065 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=30 (receiver waited 0 cycle(s)) |
| 9255 | **DUT** | IN  pkt #19 complete: addr=2 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 9255 | yapp monitor | RX pkt #19 on the input: addr=2 len=30 parity=good gap=2 |
| 9255 | reference | Packet forwarded: addr=2 len=30 -> channel 2 |
| 9260 | ch1 driver | ch1: packet consumed (response delay 0) |
| 9260 | yapp driver | TX pkt #19 accepted by the DUT |
| 9260 | **test** | STAGE: burst 2/5 sent: addr0..3 0/4/5/1, bad parity 3, gap 0 1, length 1..63 |
| 9280 | hbus driver | Executed WRITE addr=0x1000 data=0xfe |
| 9285 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 9285 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 9285 | reference | maxpktsize is now 62 |
| 9300 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 9305 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 9305 | reference | router_en is now 1 (en_reg 0xff) |
| 9330 | hbus driver | Executed READ  addr=0x1010 data=0x7a |
| 9335 | hbus monitor | Collected READ  addr=0x1010 data=0x7a |
| 9350 | hbus driver | Executed WRITE addr=0x1120 data=0x91 |
| 9355 | hbus monitor | Collected WRITE addr=0x1120 data=0x91 |
| 9375 | **DUT** | OUT ch2 pkt #10 done: 32 bytes in 32 cycles |
| 9375 | ch2 monitor | ch2 RX pkt #10: addr=2 len=30 parity=good |
| 9375 | scoreboard | ch2 pkt matched: addr=2 len=30 (17 matched so far) |
| 9380 | hbus driver | Executed READ  addr=0x1120 data=0x91 |
| 9385 | hbus monitor | Collected READ  addr=0x1120 data=0x91 |
| 9400 | hbus driver | Executed WRITE addr=0x112e data=0x11 |
| 9405 | hbus monitor | Collected WRITE addr=0x112e data=0x11 |
| 9430 | ch2 driver | ch2: packet consumed (response delay 2) |
| 9430 | hbus driver | Executed READ  addr=0x112e data=0x11 |
| 9435 | hbus monitor | Collected READ  addr=0x112e data=0x11 |
| 9460 | hbus driver | Executed READ  addr=0x101b data=0xa3 |
| 9465 | hbus monitor | Collected READ  addr=0x101b data=0xa3 |
| 9480 | hbus driver | Executed WRITE addr=0x1139 data=0x42 |
| 9485 | hbus monitor | Collected WRITE addr=0x1139 data=0x42 |
| 9510 | hbus driver | Executed READ  addr=0x1139 data=0x42 |
| 9515 | hbus monitor | Collected READ  addr=0x1139 data=0x42 |
| 9530 | hbus driver | Executed WRITE addr=0x1123 data=0x28 |
| 9535 | hbus monitor | Collected WRITE addr=0x1123 data=0x28 |
| 9560 | hbus driver | Executed READ  addr=0x1123 data=0x28 |
| 9565 | hbus monitor | Collected READ  addr=0x1123 data=0x28 |
| 9590 | hbus driver | Executed READ  addr=0x100d data=0x1e |
| 9595 | hbus monitor | Collected READ  addr=0x100d data=0x1e |
| 9620 | hbus driver | Executed READ  addr=0x109e data=0x00 |
| 9620 | **test** | STAGE: burst 3/5: ctrl=0xfe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 10 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 9620 | yapp driver | TX pkt #20: addr=1 len=2 parity=good delay=0 |
| 9625 | hbus monitor | Collected READ  addr=0x109e data=0x00 |
| 9635 | **DUT** | IN  pkt #20 header: addr=1 len=2 -> channel 1 |
| 9645 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 9665 | **DUT** | IN  pkt #20 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 9665 | yapp monitor | RX pkt #20 on the input: addr=1 len=2 parity=good gap=37 |
| 9665 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 9670 | ch1 driver | ch1: packet consumed (response delay 0) |
| 9670 | yapp driver | TX pkt #20 accepted by the DUT |
| 9670 | yapp driver | TX pkt #21: addr=1 len=3 parity=bad delay=0 |
| 9675 | **DUT** | IN  pkt #21 header: addr=1 len=3 -> channel 1 |
| 9685 | **DUT** | OUT ch1 pkt #8 done: 4 bytes in 5 cycles |
| 9685 | ch1 monitor | ch1 RX pkt #8: addr=1 len=2 parity=good |
| 9685 | scoreboard | ch1 pkt matched: addr=1 len=2 (18 matched so far) |
| 9695 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 9715 | **DUT** | IN  pkt #21 complete: addr=1 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 9715 | yapp monitor | RX pkt #21 on the input: addr=1 len=3 parity=bad gap=0 |
| 9715 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 9720 | yapp driver | TX pkt #21 accepted by the DUT |
| 9720 | yapp driver | TX pkt #22: addr=3 len=2 parity=bad delay=0 |
| 9725 | **DUT** | IN  pkt #22 header: addr=3 len=2 -> DROP (illegal address 3) |
| 9735 | **DUT** | OUT ch1 pkt #9 done: 5 bytes in 5 cycles |
| 9735 | ch1 monitor | ch1 RX pkt #9: addr=1 len=3 parity=bad |
| 9735 | scoreboard | ch1 pkt matched: addr=1 len=3 (19 matched so far) |
| 9755 | **DUT** | IN  pkt #22 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 9755 | yapp monitor | RX pkt #22 on the input: addr=3 len=2 parity=bad gap=0 |
| 9755 | reference | Packet dropped: illegal address 3 (len=2) |
| 9755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 9760 | yapp driver | TX pkt #22 accepted by the DUT |
| 9760 | yapp driver | TX pkt #23: addr=1 len=2 parity=good delay=0 |
| 9765 | **DUT** | IN  pkt #23 header: addr=1 len=2 -> channel 1 |
| 9770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 9770 | error checker | error pulse 5 cycles after the bad packet (1 still owed) |
| 9775 | **DUT** | OUT ch1 pkt #10 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 9790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 9790 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 9795 | **DUT** | IN  pkt #23 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 9795 | yapp monitor | RX pkt #23 on the input: addr=1 len=2 parity=good gap=0 |
| 9795 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 9800 | yapp driver | TX pkt #23 accepted by the DUT |
| 9800 | yapp driver | TX pkt #24: addr=0 len=1 parity=good delay=0 |
| 9805 | **DUT** | IN  pkt #24 header: addr=0 len=1 -> channel 0 |
| 9805 | **DUT** | OUT ch1 pkt #10 done: 4 bytes in 4 cycles |
| 9805 | ch1 monitor | ch1 RX pkt #10: addr=1 len=2 parity=good |
| 9805 | scoreboard | ch1 pkt matched: addr=1 len=2 (20 matched so far) |
| 9825 | **DUT** | IN  pkt #24 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9825 | yapp monitor | RX pkt #24 on the input: addr=0 len=1 parity=good gap=0 |
| 9825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9830 | yapp driver | TX pkt #24 accepted by the DUT |
| 9830 | yapp driver | TX pkt #25: addr=1 len=1 parity=good delay=0 |
| 9835 | **DUT** | IN  pkt #25 header: addr=1 len=1 -> channel 1 |
| 9845 | **DUT** | OUT ch1 pkt #11 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 9855 | **DUT** | IN  pkt #25 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9855 | yapp monitor | RX pkt #25 on the input: addr=1 len=1 parity=good gap=0 |
| 9855 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 9860 | yapp driver | TX pkt #25 accepted by the DUT |
| 9860 | yapp driver | TX pkt #26: addr=2 len=2 parity=good delay=0 |
| 9865 | **DUT** | IN  pkt #26 header: addr=2 len=2 -> channel 2 |
| 9865 | **DUT** | OUT ch1 pkt #11 done: 3 bytes in 3 cycles |
| 9865 | ch1 monitor | ch1 RX pkt #11: addr=1 len=1 parity=good |
| 9865 | scoreboard | ch1 pkt matched: addr=1 len=1 (21 matched so far) |
| 9895 | **DUT** | IN  pkt #26 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 9895 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 9895 | yapp monitor | RX pkt #26 on the input: addr=2 len=2 parity=good gap=0 |
| 9895 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 9900 | yapp driver | TX pkt #26 accepted by the DUT |
| 9900 | yapp driver | TX pkt #27: addr=0 len=1 parity=bad delay=0 |
| 9905 | **DUT** | IN  pkt #27 header: addr=0 len=1 -> channel 0 |
| 9910 | ch0 driver | ch0: packet consumed (response delay 8) |
| 9925 | **DUT** | IN  pkt #27 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9925 | yapp monitor | RX pkt #27 on the input: addr=0 len=1 parity=bad gap=0 |
| 9925 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9930 | ch1 driver | ch1: packet consumed (response delay 0) |
| 9930 | yapp driver | TX pkt #27 accepted by the DUT |
| 9930 | yapp driver | TX pkt #28: addr=0 len=1 parity=good delay=1 |
| 9945 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 9950 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 9950 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 9965 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9965 | yapp monitor | RX pkt #28 on the input: addr=0 len=1 parity=good gap=1 |
| 9965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9970 | yapp driver | TX pkt #28 accepted by the DUT |
| 9970 | yapp driver | TX pkt #29: addr=2 len=2 parity=good delay=0 |
| 9975 | **DUT** | IN  pkt #29 header: addr=2 len=2 -> channel 2 |
| 9975 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=2 (receiver waited 10 cycle(s)) |
| 10000 | ch2 driver | ch2: packet consumed (response delay 10) |
| 10005 | **DUT** | IN  pkt #29 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 10005 | yapp monitor | RX pkt #29 on the input: addr=2 len=2 parity=good gap=0 |
| 10005 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 10010 | yapp driver | TX pkt #29 accepted by the DUT |
| 10010 | **test** | STAGE: burst 3/5 sent: addr0..3 3/4/2/1, bad parity 3, gap 0 9, length 1..3 |
| 10025 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 14 cycles |
| 10025 | **DUT** | OUT ch2 pkt #11 done: 4 bytes in 6 cycles |
| 10025 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 10025 | scoreboard | ch0 pkt matched: addr=0 len=1 (22 matched so far) |
| 10025 | ch2 monitor | ch2 RX pkt #11: addr=2 len=2 parity=good |
| 10025 | scoreboard | ch2 pkt matched: addr=2 len=2 (23 matched so far) |
| 10030 | hbus driver | Executed WRITE addr=0x1000 data=0xee |
| 10035 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10035 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 10035 | **DUT** | CONFIG router_en=1 maxpktsize=46 |
| 10035 | hbus monitor | Collected WRITE addr=0x1000 data=0xee |
| 10035 | reference | maxpktsize is now 46 |
| 10050 | hbus driver | Executed WRITE addr=0x1001 data=0x0b |
| 10055 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 3 cycles |
| 10055 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=bad |
| 10055 | scoreboard | ch0 pkt matched: addr=0 len=1 (24 matched so far) |
| 10055 | hbus monitor | Collected WRITE addr=0x1001 data=0x0b |
| 10055 | reference | router_en is now 1 (en_reg 0x0b) |
| 10065 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10065 | **DUT** | OUT ch2 pkt #12 done: 4 bytes in 4 cycles |
| 10065 | ch2 monitor | ch2 RX pkt #12: addr=2 len=2 parity=good |
| 10065 | scoreboard | ch2 pkt matched: addr=2 len=2 (25 matched so far) |
| 10080 | hbus driver | Executed READ  addr=0x10d3 data=0x00 |
| 10085 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 10085 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 10085 | scoreboard | ch0 pkt matched: addr=0 len=1 (26 matched so far) |
| 10085 | hbus monitor | Collected READ  addr=0x10d3 data=0x00 |
| 10100 | hbus driver | Executed WRITE addr=0x1105 data=0xc1 |
| 10105 | hbus monitor | Collected WRITE addr=0x1105 data=0xc1 |
| 10130 | hbus driver | Executed READ  addr=0x1105 data=0xc1 |
| 10135 | hbus monitor | Collected READ  addr=0x1105 data=0xc1 |
| 10160 | hbus driver | Executed READ  addr=0x1004 data=0x09 |
| 10160 | **test** | STAGE: burst 4/5: ctrl=0xee (maxpktsize 46) en=0x0b (router on, counter enables 0000101), 9 packet(s) |
| 10160 | yapp driver | TX pkt #30: addr=2 len=45 parity=good delay=0 |
| 10165 | hbus monitor | Collected READ  addr=0x1004 data=0x09 |
| 10175 | **DUT** | IN  pkt #30 header: addr=2 len=45 -> channel 2 |
| 10185 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=45 (receiver waited 0 cycle(s)) |
| 10310 | ch2 driver | ch2: packet consumed (response delay 1) |
| 10520 | ch0 driver | ch0: packet consumed (response delay 10) |
| 10540 | ch2 driver | ch2: packet consumed (response delay 10) |
| 10585 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xd4 held (pkt #30) |
| 10655 | **DUT** | SUSPEND released after 7 cycle(s) |
| 10705 | **DUT** | IN  pkt #30 complete: addr=2 len=45 parity=ok forwarded, 47 bytes in 54 cycles (held 7) |
| 10705 | yapp monitor | RX pkt #30 on the input: addr=2 len=45 parity=good gap=16 |
| 10705 | reference | Packet forwarded: addr=2 len=45 -> channel 2 |
| 10710 | yapp driver | TX pkt #30 accepted by the DUT |
| 10710 | yapp driver | TX pkt #31: addr=2 len=13 parity=good delay=14 |
| 10855 | **DUT** | IN  pkt #31 header: addr=2 len=13 -> channel 2 |
| 10855 | **DUT** | OUT ch2 pkt #13 done: 47 bytes in 68 cycles |
| 10855 | ch2 monitor | ch2 RX pkt #13: addr=2 len=45 parity=good |
| 10855 | scoreboard | ch2 pkt matched: addr=2 len=45 (27 matched so far) |
| 10865 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=13 (receiver waited 0 cycle(s)) |
| 10995 | **DUT** | IN  pkt #31 complete: addr=2 len=13 parity=ok forwarded, 15 bytes in 15 cycles (held 0) |
| 10995 | yapp monitor | RX pkt #31 on the input: addr=2 len=13 parity=good gap=14 |
| 10995 | reference | Packet forwarded: addr=2 len=13 -> channel 2 |
| 11000 | yapp driver | TX pkt #31 accepted by the DUT |
| 11000 | yapp driver | TX pkt #32: addr=0 len=17 parity=good delay=0 |
| 11005 | **DUT** | IN  pkt #32 header: addr=0 len=17 -> channel 0 |
| 11005 | **DUT** | OUT ch2 pkt #14 done: 15 bytes in 15 cycles |
| 11005 | ch2 monitor | ch2 RX pkt #14: addr=2 len=13 parity=good |
| 11005 | scoreboard | ch2 pkt matched: addr=2 len=13 (28 matched so far) |
| 11035 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=17 (receiver waited 2 cycle(s)) |
| 11185 | **DUT** | IN  pkt #32 complete: addr=0 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 11185 | yapp monitor | RX pkt #32 on the input: addr=0 len=17 parity=good gap=0 |
| 11185 | reference | Packet forwarded: addr=0 len=17 -> channel 0 |
| 11190 | yapp driver | TX pkt #32 accepted by the DUT |
| 11190 | yapp driver | TX pkt #33: addr=3 len=22 parity=good delay=0 |
| 11195 | **DUT** | IN  pkt #33 header: addr=3 len=22 -> DROP (illegal address 3) |
| 11210 | ch0 driver | ch0: packet consumed (response delay 2) |
| 11225 | **DUT** | OUT ch0 pkt #4 done: 19 bytes in 20 cycles |
| 11225 | ch0 monitor | ch0 RX pkt #4: addr=0 len=17 parity=good |
| 11225 | scoreboard | ch0 pkt matched: addr=0 len=17 (29 matched so far) |
| 11280 | ch2 driver | ch2: packet consumed (response delay 9) |
| 11425 | **DUT** | IN  pkt #33 complete: addr=3 len=22 parity=ok dropped, 24 bytes in 24 cycles (held 0) |
| 11425 | yapp monitor | RX pkt #33 on the input: addr=3 len=22 parity=good gap=0 |
| 11425 | reference | Packet dropped: illegal address 3 (len=22) |
| 11425 | **DUT** | ROUTER DROPS PACKET addr=3 length=22 (    illegal address) |
| 11430 | yapp driver | TX pkt #33 accepted by the DUT |
| 11430 | yapp driver | TX pkt #34: addr=1 len=51 parity=good delay=14 |
| 11575 | **DUT** | IN  pkt #34 header: addr=1 len=51 -> DROP (oversized: len 51 > maxpktsize 46) |
| 11810 | ch0 driver | ch0: packet consumed (response delay 0) |
| 12095 | **DUT** | IN  pkt #34 complete: addr=1 len=51 parity=ok dropped, 53 bytes in 53 cycles (held 0) |
| 12095 | yapp monitor | RX pkt #34 on the input: addr=1 len=51 parity=good gap=14 |
| 12095 | reference | Packet dropped: length 51 > maxpktsize 46 (addr=1) |
| 12095 | **DUT** | ROUTER DROPS PACKET addr=1 length=51 (length > maxpktsize) |
| 12100 | yapp driver | TX pkt #34 accepted by the DUT |
| 12100 | yapp driver | TX pkt #35: addr=0 len=60 parity=bad delay=0 |
| 12105 | **DUT** | IN  pkt #35 header: addr=0 len=60 -> DROP (oversized: len 60 > maxpktsize 46) |
| 12715 | **DUT** | IN  pkt #35 complete: addr=0 len=60 parity=BAD dropped, 62 bytes in 62 cycles (held 0) |
| 12715 | yapp monitor | RX pkt #35 on the input: addr=0 len=60 parity=bad gap=0 |
| 12715 | reference | Packet dropped: length 60 > maxpktsize 46 (addr=0) |
| 12715 | **DUT** | ROUTER DROPS PACKET addr=0 length=60 (length > maxpktsize) |
| 12720 | yapp driver | TX pkt #35 accepted by the DUT |
| 12720 | yapp driver | TX pkt #36: addr=1 len=15 parity=good delay=20 |
| 12750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 12750 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 12925 | **DUT** | IN  pkt #36 header: addr=1 len=15 -> channel 1 |
| 12935 | **DUT** | OUT ch1 pkt #12 start: addr=1 len=15 (receiver waited 0 cycle(s)) |
| 13085 | **DUT** | IN  pkt #36 complete: addr=1 len=15 parity=ok forwarded, 17 bytes in 17 cycles (held 0) |
| 13085 | yapp monitor | RX pkt #36 on the input: addr=1 len=15 parity=good gap=20 |
| 13085 | reference | Packet forwarded: addr=1 len=15 -> channel 1 |
| 13090 | ch1 driver | ch1: packet consumed (response delay 0) |
| 13090 | yapp driver | TX pkt #36 accepted by the DUT |
| 13090 | yapp driver | TX pkt #37: addr=0 len=28 parity=good delay=0 |
| 13095 | **DUT** | IN  pkt #37 header: addr=0 len=28 -> channel 0 |
| 13105 | **DUT** | OUT ch1 pkt #12 done: 17 bytes in 18 cycles |
| 13105 | ch1 monitor | ch1 RX pkt #12: addr=1 len=15 parity=good |
| 13105 | scoreboard | ch1 pkt matched: addr=1 len=15 (30 matched so far) |
| 13145 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=28 (receiver waited 4 cycle(s)) |
| 13380 | ch1 driver | ch1: packet consumed (response delay 0) |
| 13385 | **DUT** | IN  pkt #37 complete: addr=0 len=28 parity=ok forwarded, 30 bytes in 30 cycles (held 0) |
| 13385 | yapp monitor | RX pkt #37 on the input: addr=0 len=28 parity=good gap=0 |
| 13385 | reference | Packet forwarded: addr=0 len=28 -> channel 0 |
| 13390 | yapp driver | TX pkt #37 accepted by the DUT |
| 13390 | yapp driver | TX pkt #38: addr=2 len=63 parity=bad delay=0 |
| 13395 | **DUT** | IN  pkt #38 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 46) |
| 13430 | ch0 driver | ch0: packet consumed (response delay 4) |
| 13545 | **DUT** | OUT ch0 pkt #5 done: 30 bytes in 41 cycles |
| 13545 | ch0 monitor | ch0 RX pkt #5: addr=0 len=28 parity=good |
| 13545 | scoreboard | ch0 pkt matched: addr=0 len=28 (31 matched so far) |
| 13810 | ch0 driver | ch0: packet consumed (response delay 10) |
| 14035 | **DUT** | IN  pkt #38 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 14035 | yapp monitor | RX pkt #38 on the input: addr=2 len=63 parity=bad gap=0 |
| 14035 | reference | Packet dropped: length 63 > maxpktsize 46 (addr=2) |
| 14035 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 14040 | yapp driver | TX pkt #38 accepted by the DUT |
| 14040 | **test** | STAGE: burst 4/5 sent: addr0..3 3/2/3/1, bad parity 2, gap 0 6, length 13..63 |
| 14060 | hbus driver | Executed WRITE addr=0x1000 data=0x4c |
| 14065 | **DUT** | CONFIG router_en=1 maxpktsize=12 |
| 14065 | hbus monitor | Collected WRITE addr=0x1000 data=0x4c |
| 14065 | reference | maxpktsize is now 12 |
| 14080 | hbus driver | Executed WRITE addr=0x1001 data=0x31 |
| 14085 | hbus monitor | Collected WRITE addr=0x1001 data=0x31 |
| 14085 | reference | router_en is now 1 (en_reg 0x31) |
| 14110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 14110 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 14110 | hbus driver | Executed READ  addr=0x103c data=0xf2 |
| 14115 | hbus monitor | Collected READ  addr=0x103c data=0xf2 |
| 14140 | hbus driver | Executed READ  addr=0x104f data=0x3e |
| 14145 | hbus monitor | Collected READ  addr=0x104f data=0x3e |
| 14160 | hbus driver | Executed WRITE addr=0x1178 data=0x7a |
| 14165 | hbus monitor | Collected WRITE addr=0x1178 data=0x7a |
| 14190 | hbus driver | Executed READ  addr=0x1178 data=0x7a |
| 14190 | **test** | STAGE: burst 5/5: ctrl=0x4c (maxpktsize 12) en=0x31 (router on, counter enables 0011000), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 14190 | yapp driver | TX pkt #39: addr=0 len=2 parity=bad delay=3 |
| 14195 | hbus monitor | Collected READ  addr=0x1178 data=0x7a |
| 14235 | **DUT** | IN  pkt #39 header: addr=0 len=2 -> channel 0 |
| 14265 | **DUT** | IN  pkt #39 complete: addr=0 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 14265 | yapp monitor | RX pkt #39 on the input: addr=0 len=2 parity=bad gap=19 |
| 14265 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 14270 | yapp driver | TX pkt #39 accepted by the DUT |
| 14270 | yapp driver | TX pkt #40: addr=2 len=3 parity=bad delay=0 |
| 14275 | **DUT** | IN  pkt #40 header: addr=2 len=3 -> channel 2 |
| 14305 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=2 (receiver waited 6 cycle(s)) |
| 14310 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 14310 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 14315 | **DUT** | IN  pkt #40 complete: addr=2 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 14315 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=3 (receiver waited 3 cycle(s)) |
| 14315 | yapp monitor | RX pkt #40 on the input: addr=2 len=3 parity=bad gap=0 |
| 14315 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 14320 | yapp driver | TX pkt #40 accepted by the DUT |
| 14320 | yapp driver | TX pkt #41: addr=1 len=2 parity=bad delay=0 |
| 14325 | **DUT** | IN  pkt #41 header: addr=1 len=2 -> channel 1 |
| 14330 | ch0 driver | ch0: packet consumed (response delay 6) |
| 14335 | **DUT** | OUT ch1 pkt #13 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 14350 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 14350 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 14350 | ch2 driver | ch2: packet consumed (response delay 3) |
| 14355 | **DUT** | IN  pkt #41 complete: addr=1 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 14355 | yapp monitor | RX pkt #41 on the input: addr=1 len=2 parity=bad gap=0 |
| 14355 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 14360 | ch1 driver | ch1: packet consumed (response delay 0) |
| 14360 | yapp driver | TX pkt #41 accepted by the DUT |
| 14360 | yapp driver | TX pkt #42: addr=1 len=1 parity=good delay=0 |
| 14365 | **DUT** | IN  pkt #42 header: addr=1 len=1 -> channel 1 |
| 14375 | **DUT** | OUT ch1 pkt #13 done: 4 bytes in 5 cycles |
| 14375 | ch1 monitor | ch1 RX pkt #13: addr=1 len=2 parity=bad |
| 14375 | scoreboard | ch1 pkt matched: addr=1 len=2 (32 matched so far) |
| 14385 | **DUT** | IN  pkt #42 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14385 | **DUT** | OUT ch1 pkt #14 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 14385 | yapp monitor | RX pkt #42 on the input: addr=1 len=1 parity=good gap=0 |
| 14385 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 14390 | yapp driver | TX pkt #42 accepted by the DUT |
| 14390 | yapp driver | TX pkt #43: addr=2 len=2 parity=good delay=2 |
| 14405 | **DUT** | OUT ch1 pkt #14 done: 3 bytes in 3 cycles |
| 14405 | **DUT** | OUT ch2 pkt #15 done: 5 bytes in 10 cycles |
| 14405 | ch1 monitor | ch1 RX pkt #14: addr=1 len=1 parity=good |
| 14405 | scoreboard | ch1 pkt matched: addr=1 len=1 (33 matched so far) |
| 14405 | ch2 monitor | ch2 RX pkt #15: addr=2 len=3 parity=bad |
| 14405 | scoreboard | ch2 pkt matched: addr=2 len=3 (34 matched so far) |
| 14415 | **DUT** | IN  pkt #43 header: addr=2 len=2 -> channel 2 |
| 14425 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 14430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 14430 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 14445 | **DUT** | IN  pkt #43 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 14445 | **DUT** | OUT ch0 pkt #6 done: 4 bytes in 15 cycles |
| 14445 | ch0 monitor | ch0 RX pkt #6: addr=0 len=2 parity=bad |
| 14445 | scoreboard | ch0 pkt matched: addr=0 len=2 (35 matched so far) |
| 14445 | yapp monitor | RX pkt #43 on the input: addr=2 len=2 parity=good gap=2 |
| 14445 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 14450 | yapp driver | TX pkt #43 accepted by the DUT |
| 14450 | yapp driver | TX pkt #44: addr=2 len=2 parity=good delay=0 |
| 14455 | **DUT** | IN  pkt #44 header: addr=2 len=2 -> channel 2 |
| 14455 | **DUT** | OUT ch2 pkt #16 done: 4 bytes in 4 cycles |
| 14455 | ch2 monitor | ch2 RX pkt #16: addr=2 len=2 parity=good |
| 14455 | scoreboard | ch2 pkt matched: addr=2 len=2 (36 matched so far) |
| 14465 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 14480 | ch2 driver | ch2: packet consumed (response delay 4) |
| 14485 | **DUT** | IN  pkt #44 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 14485 | yapp monitor | RX pkt #44 on the input: addr=2 len=2 parity=good gap=0 |
| 14485 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 14490 | yapp driver | TX pkt #44 accepted by the DUT |
| 14490 | yapp driver | TX pkt #45: addr=1 len=1 parity=good delay=0 |
| 14495 | **DUT** | IN  pkt #45 header: addr=1 len=1 -> channel 1 |
| 14505 | **DUT** | OUT ch1 pkt #15 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 14515 | **DUT** | IN  pkt #45 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14515 | yapp monitor | RX pkt #45 on the input: addr=1 len=1 parity=good gap=0 |
| 14515 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 14520 | yapp driver | TX pkt #45 accepted by the DUT |
| 14520 | yapp driver | TX pkt #46: addr=2 len=1 parity=good delay=0 |
| 14525 | **DUT** | IN  pkt #46 header: addr=2 len=1 -> channel 2 |
| 14525 | **DUT** | OUT ch1 pkt #15 done: 3 bytes in 3 cycles |
| 14525 | ch1 monitor | ch1 RX pkt #15: addr=1 len=1 parity=good |
| 14525 | scoreboard | ch1 pkt matched: addr=1 len=1 (37 matched so far) |
| 14545 | **DUT** | IN  pkt #46 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14545 | yapp monitor | RX pkt #46 on the input: addr=2 len=1 parity=good gap=0 |
| 14545 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 14550 | yapp driver | TX pkt #46 accepted by the DUT |
| 14550 | yapp driver | TX pkt #47: addr=2 len=2 parity=good delay=0 |
| 14555 | **DUT** | IN  pkt #47 header: addr=2 len=2 -> channel 2 |
| 14585 | **DUT** | IN  pkt #47 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 14585 | yapp monitor | RX pkt #47 on the input: addr=2 len=2 parity=good gap=0 |
| 14585 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 14590 | yapp driver | TX pkt #47 accepted by the DUT |
| 14590 | yapp driver | TX pkt #48: addr=3 len=1 parity=bad delay=0 |
| 14595 | **DUT** | IN  pkt #48 header: addr=3 len=1 -> DROP (illegal address 3) |
| 14605 | **DUT** | OUT ch2 pkt #17 done: 4 bytes in 15 cycles |
| 14605 | ch2 monitor | ch2 RX pkt #17: addr=2 len=2 parity=good |
| 14605 | scoreboard | ch2 pkt matched: addr=2 len=2 (38 matched so far) |
| 14615 | **DUT** | IN  pkt #48 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 14615 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 14615 | yapp monitor | RX pkt #48 on the input: addr=3 len=1 parity=bad gap=0 |
| 14615 | reference | Packet dropped: illegal address 3 (len=1) |
| 14615 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 14620 | yapp driver | TX pkt #48 accepted by the DUT |
| 14620 | yapp driver | TX pkt #49: addr=2 len=2 parity=good delay=0 |
| 14625 | **DUT** | IN  pkt #49 header: addr=2 len=2 -> channel 2 |
| 14630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 14630 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 14635 | **DUT** | OUT ch2 pkt #18 done: 3 bytes in 3 cycles |
| 14635 | ch2 monitor | ch2 RX pkt #18: addr=2 len=1 parity=good |
| 14635 | scoreboard | ch2 pkt matched: addr=2 len=1 (39 matched so far) |
| 14645 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 14655 | **DUT** | IN  pkt #49 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 14655 | yapp monitor | RX pkt #49 on the input: addr=2 len=2 parity=good gap=0 |
| 14655 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 14660 | yapp driver | TX pkt #49 accepted by the DUT |
| 14660 | **test** | STAGE: burst 5/5 sent: addr0..3 1/3/6/1, bad parity 4, gap 0 9, length 1..3 |
| 14660 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 14675 | **DUT** | OUT ch2 pkt #19 done: 4 bytes in 4 cycles |
| 14675 | ch2 monitor | ch2 RX pkt #19: addr=2 len=2 parity=good |
| 14675 | scoreboard | ch2 pkt matched: addr=2 len=2 (40 matched so far) |
| 14685 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 14690 | hbus driver | Executed READ  addr=0x1000 data=0x4c |
| 14695 | hbus monitor | Collected READ  addr=0x1000 data=0x4c |
| 14715 | **DUT** | OUT ch2 pkt #20 done: 4 bytes in 4 cycles |
| 14715 | ch2 monitor | ch2 RX pkt #20: addr=2 len=2 parity=good |
| 14715 | scoreboard | ch2 pkt matched: addr=2 len=2 (41 matched so far) |
| 14720 | hbus driver | Executed READ  addr=0x1001 data=0x31 |
| 14725 | hbus monitor | Collected READ  addr=0x1001 data=0x31 |
| 14750 | hbus driver | Executed READ  addr=0x1004 data=0x0b |
| 14755 | hbus monitor | Collected READ  addr=0x1004 data=0x0b |
| 14780 | hbus driver | Executed READ  addr=0x1005 data=0x01 |
| 14785 | hbus monitor | Collected READ  addr=0x1005 data=0x01 |
| 14810 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 14815 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 14840 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 14845 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 14870 | ch1 driver | ch1: packet consumed (response delay 0) |
| 14870 | hbus driver | Executed READ  addr=0x100a data=0x0a |
| 14875 | hbus monitor | Collected READ  addr=0x100a data=0x0a |
| 14900 | hbus driver | Executed READ  addr=0x100b data=0x0d |
| 14905 | hbus monitor | Collected READ  addr=0x100b data=0x0d |
| 14930 | hbus driver | Executed READ  addr=0x100d data=0x02 |
| 14935 | hbus monitor | Collected READ  addr=0x100d data=0x02 |
| 14960 | hbus driver | Executed READ  addr=0x1010 data=0x0a |
| 14965 | hbus monitor | Collected READ  addr=0x1010 data=0x0a |
| 14990 | hbus driver | Executed READ  addr=0x1011 data=0xf1 |
| 14995 | hbus monitor | Collected READ  addr=0x1011 data=0xf1 |
| 15020 | ch0 driver | ch0: packet consumed (response delay 10) |
| 15020 | hbus driver | Executed READ  addr=0x1012 data=0xb0 |
| 15025 | hbus monitor | Collected READ  addr=0x1012 data=0xb0 |
| 15135 | **test** | STAGE: done: 49 packets (41 forwarded, 8 dropped), 2 storm burst(s), 41 scoreboard matches, 36 HBUS reads checked, 15 error pulses for 15 bad packets |
| 15140 | ch2 driver | ch2: packet consumed (response delay 10) |
| 15335 | error checker | error pulse report: 15 bad packets, 15 pulses, 0 outside 1..10 cycles, at most 2 owed at once |
| 15335 | ch0 monitor | Channel 0 report: 6 packets collected |
| 15335 | ch1 monitor | Channel 1 report: 15 packets collected |
| 15335 | ch2 monitor | Channel 2 report: 20 packets collected |
| 15335 | hbus monitor | HBUS report: 21 writes, 37 reads |
| 15335 | coverage | Coverage of the router configuration: 82.6% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 0 / 29 / 10 / 10 packets · length < max / = max / max+1 / > max+1 : 43 / 2 / 0 / 4 · forwarded good / bad : 30 / 11 · dropped address 3 good / bad : 2 / 2 · dropped oversized good / bad : 2 / 2 · counter enables none / mixed / all : 0 / 30 / 19 |
| 15335 | coverage | HBUS address coverage: 58 accesses sampled, coverage 42.9% |
| 15335 | coverage | HBUS register bits coverage: 10 writes to ctrl_reg/en_reg, coverage 93.2% |
| 15335 | coverage | HBUS counter value coverage: 8 counter reads sampled, coverage 55.6% |
| 15335 | coverage | HBUS yapp_mem data coverage: 22 accesses sampled, coverage 29.4% |
| 15335 | reference | --- Reference model report --- · forwarded to scoreboard : 41 · dropped (router disabled) : 0 · dropped (oversized) : 4 · dropped (address 3) : 4 · counters parity/oversized/addr0..3 : 11 / 1 / 4 10 13 2 |
| 15335 | reference | HBUS reads checked against the model: 36 (0 mismatches, 1 of memory bytes never written) |
| 15335 | scoreboard | --- Scoreboard report --- · packets received : 41 · packets matched : 41 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 15335 | yapp driver | YAPP driver report: 49 packets sent |
| 15335 | coverage | YAPP gap coverage: 48 gaps sampled, coverage 100.0% |
| 15335 | yapp monitor | YAPP monitor report: 49 packets collected, 15 with bad parity |
| 15335 | yapp monitor | YAPP gaps: 25 back to back, 3 of 1 cycle, 4 of 2, 16 longer |
| 15335 | coverage | YAPP packet coverage: 49 packets sampled, coverage 86.7% |
