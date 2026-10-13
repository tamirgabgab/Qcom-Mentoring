# random_test  seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 12us · log `random_test_s1.log`

Waves: `random_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s1%2Frandom_test_s1.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **22** packet(s) (3 with bad parity); the input monitor saw 22.
- Router: **7** forwarded, **15** dropped (7 oversized, 8 router disabled).
- Packets out: ch0 **2**, ch1 **1**, ch2 **4**.
- Scoreboard: 7 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 2.
- HBUS: 30 write(s), 78 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_STALLY, ch1 RX_FAST, ch2 RX_STALLY |
| 0 | random scenario: 22 packets in 6 bursts |
| 250 | burst 1/6: ctrl=0x3e (maxpktsize 62) en=0xb3 (router on, counter enables 1011001), 4 packet(s) |
| 2330 | burst 1/6 sent: addr0..3 2/0/2/0, bad parity 1, gap 0 1, length 1..63 |
| 2620 | burst 2/6: ctrl=0x12 (maxpktsize 18) en=0xfe (router OFF, counter enables 1111111), 3 packet(s) |
| 4340 | burst 2/6 sent: addr0..3 0/0/3/0, bad parity 0, gap 0 1, length 40..63 |
| 4540 | burst 3/6: ctrl=0xf4 (maxpktsize 52) en=0x73 (router on, counter enables 0111001), 3 packet(s) |
| 5770 | burst 3/6 sent: addr0..3 0/1/2/0, bad parity 1, gap 0 2, length 16..52 |
| 6100 | burst 4/6: ctrl=0xc1 (maxpktsize 1) en=0x33 (router on, counter enables 0011001), 3 packet(s) |
| 6810 | burst 4/6 sent: addr0..3 1/1/1/0, bad parity 0, gap 0 0, length 2..50 |
| 7150 | burst 5/6: ctrl=0xe4 (maxpktsize 36) en=0xc3 (router on, counter enables 1100001), 4 packet(s) |
| 8790 | burst 5/6 sent: addr0..3 1/1/2/0, bad parity 0, gap 0 1, length 1..57 |
| 8960 | burst 6/6: ctrl=0x1f (maxpktsize 31) en=0x22 (router OFF, counter enables 0010001), 5 packet(s) |
| 10290 | burst 6/6 sent: addr0..3 1/1/2/1, bad parity 1, gap 0 2, length 1..37 |
| 10290 | final reads: every register and the stored packet, checked against the reference model |
| 11815 | done: 22 packets (7 forwarded, 15 dropped), 0 storm burst(s), 7 scoreboard matches, 78 HBUS reads checked, 2 error pulses for 2 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 2**

![first packet out on channel 2](wave_first_packet_out.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

458 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_STALLY, ch1 RX_FAST, ch2 RX_STALLY |
| 0 | **test** | STAGE: random scenario: 22 packets in 6 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 75 | reference | maxpktsize is now 62 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xb3 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xb3 |
| 95 | reference | router_en is now 1 (en_reg 0xb3) |
| 110 | hbus driver | Executed WRITE addr=0x11c6 data=0x80 |
| 115 | hbus monitor | Collected WRITE addr=0x11c6 data=0x80 |
| 140 | hbus driver | Executed READ  addr=0x11c6 data=0x80 |
| 145 | hbus monitor | Collected READ  addr=0x11c6 data=0x80 |
| 160 | hbus driver | Executed WRITE addr=0x119b data=0x2d |
| 165 | hbus monitor | Collected WRITE addr=0x119b data=0x2d |
| 190 | hbus driver | Executed READ  addr=0x119b data=0x2d |
| 195 | hbus monitor | Collected READ  addr=0x119b data=0x2d |
| 220 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 225 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 250 | hbus driver | Executed READ  addr=0x1001 data=0xb3 |
| 250 | **test** | STAGE: burst 1/6: ctrl=0x3e (maxpktsize 62) en=0xb3 (router on, counter enables 1011001), 4 packet(s) |
| 250 | yapp driver | TX pkt #1: addr=2 len=63 parity=good delay=0 |
| 255 | hbus monitor | Collected READ  addr=0x1001 data=0xb3 |
| 265 | **DUT** | IN  pkt #1 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 905 | **DUT** | IN  pkt #1 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 905 | yapp monitor | RX pkt #1 on the input: addr=2 len=63 parity=good gap=21 |
| 905 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 905 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 910 | yapp driver | TX pkt #1 accepted by the DUT |
| 910 | yapp driver | TX pkt #2: addr=2 len=62 parity=good delay=15 |
| 1065 | **DUT** | IN  pkt #2 header: addr=2 len=62 -> channel 2 |
| 1165 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=62 (receiver waited 9 cycle(s)) |
| 1695 | **DUT** | IN  pkt #2 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 1695 | yapp monitor | RX pkt #2 on the input: addr=2 len=62 parity=good gap=15 |
| 1695 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 1700 | yapp driver | TX pkt #2 accepted by the DUT |
| 1700 | yapp driver | TX pkt #3: addr=0 len=35 parity=good delay=3 |
| 1735 | **DUT** | IN  pkt #3 header: addr=0 len=35 -> channel 0 |
| 1790 | ch2 driver | ch2: packet consumed (response delay 9) |
| 1795 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=35 (receiver waited 5 cycle(s)) |
| 1905 | **DUT** | OUT ch2 pkt #1 done: 64 bytes in 75 cycles |
| 1905 | ch2 monitor | ch2 RX pkt #1: addr=2 len=62 parity=good |
| 1905 | scoreboard | ch2 pkt matched: addr=2 len=62 (1 matched so far) |
| 2095 | **DUT** | IN  pkt #3 complete: addr=0 len=35 parity=ok forwarded, 37 bytes in 37 cycles (held 0) |
| 2095 | yapp monitor | RX pkt #3 on the input: addr=0 len=35 parity=good gap=3 |
| 2095 | reference | Packet forwarded: addr=0 len=35 -> channel 0 |
| 2100 | yapp driver | TX pkt #3 accepted by the DUT |
| 2100 | yapp driver | TX pkt #4: addr=0 len=1 parity=bad delay=20 |
| 2140 | ch2 driver | ch2: packet consumed (response delay 10) |
| 2150 | ch0 driver | ch0: packet consumed (response delay 5) |
| 2305 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> channel 0 |
| 2325 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 2325 | yapp monitor | RX pkt #4 on the input: addr=0 len=1 parity=bad gap=20 |
| 2325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2330 | yapp driver | TX pkt #4 accepted by the DUT |
| 2330 | **test** | STAGE: burst 1/6 sent: addr0..3 2/0/2/0, bad parity 1, gap 0 1, length 1..63 |
| 2350 | hbus driver | Executed WRITE addr=0x1000 data=0x12 |
| 2355 | **DUT** | CONFIG router_en=1 maxpktsize=18 |
| 2355 | hbus monitor | Collected WRITE addr=0x1000 data=0x12 |
| 2355 | reference | maxpktsize is now 18 |
| 2370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 2370 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 2370 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 2375 | **DUT** | CONFIG router_en=0 maxpktsize=18 |
| 2375 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 2375 | reference | router_en is now 0 (en_reg 0xfe) |
| 2390 | hbus driver | Executed WRITE addr=0x11bf data=0xd1 |
| 2395 | hbus monitor | Collected WRITE addr=0x11bf data=0xd1 |
| 2420 | hbus driver | Executed READ  addr=0x11bf data=0xd1 |
| 2425 | hbus monitor | Collected READ  addr=0x11bf data=0xd1 |
| 2450 | hbus driver | Executed READ  addr=0x10f2 data=0x00 |
| 2455 | hbus monitor | Collected READ  addr=0x10f2 data=0x00 |
| 2480 | hbus driver | Executed READ  addr=0x1042 data=0xbe |
| 2485 | hbus monitor | Collected READ  addr=0x1042 data=0xbe |
| 2510 | hbus driver | Executed READ  addr=0x102f data=0x0e |
| 2515 | hbus monitor | Collected READ  addr=0x102f data=0x0e |
| 2540 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 2545 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 2560 | hbus driver | Executed WRITE addr=0x1146 data=0x78 |
| 2565 | hbus monitor | Collected WRITE addr=0x1146 data=0x78 |
| 2590 | hbus driver | Executed READ  addr=0x1146 data=0x78 |
| 2595 | hbus monitor | Collected READ  addr=0x1146 data=0x78 |
| 2620 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 2620 | **test** | STAGE: burst 2/6: ctrl=0x12 (maxpktsize 18) en=0xfe (router OFF, counter enables 1111111), 3 packet(s) |
| 2620 | yapp driver | TX pkt #5: addr=2 len=40 parity=good delay=2 |
| 2625 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 2655 | **DUT** | IN  pkt #5 header: addr=2 len=40 -> DROP (router disabled) |
| 3065 | **DUT** | IN  pkt #5 complete: addr=2 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 3065 | yapp monitor | RX pkt #5 on the input: addr=2 len=40 parity=good gap=32 |
| 3065 | reference | Packet dropped: router disabled (addr=2 len=40) |
| 3065 | **DUT** | ROUTER DROPS PACKET addr=2 length=40 (router disabled) |
| 3070 | yapp driver | TX pkt #5 accepted by the DUT |
| 3070 | yapp driver | TX pkt #6: addr=2 len=40 parity=good delay=20 |
| 3275 | **DUT** | IN  pkt #6 header: addr=2 len=40 -> DROP (router disabled) |
| 3465 | **DUT** | OUT ch0 pkt #1 done: 37 bytes in 168 cycles |
| 3465 | ch0 monitor | ch0 RX pkt #1: addr=0 len=35 parity=good |
| 3465 | scoreboard | ch0 pkt matched: addr=0 len=35 (2 matched so far) |
| 3475 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3495 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 3 cycles |
| 3495 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=bad |
| 3495 | scoreboard | ch0 pkt matched: addr=0 len=1 (3 matched so far) |
| 3685 | **DUT** | IN  pkt #6 complete: addr=2 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 3685 | yapp monitor | RX pkt #6 on the input: addr=2 len=40 parity=good gap=20 |
| 3685 | reference | Packet dropped: router disabled (addr=2 len=40) |
| 3685 | **DUT** | ROUTER DROPS PACKET addr=2 length=40 (router disabled) |
| 3690 | yapp driver | TX pkt #6 accepted by the DUT |
| 3690 | yapp driver | TX pkt #7: addr=2 len=63 parity=good delay=0 |
| 3695 | **DUT** | IN  pkt #7 header: addr=2 len=63 -> DROP (router disabled) |
| 3770 | ch0 driver | ch0: packet consumed (response delay 130) |
| 4335 | **DUT** | IN  pkt #7 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4335 | yapp monitor | RX pkt #7 on the input: addr=2 len=63 parity=good gap=0 |
| 4335 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 4335 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 4340 | yapp driver | TX pkt #7 accepted by the DUT |
| 4340 | **test** | STAGE: burst 2/6 sent: addr0..3 0/0/3/0, bad parity 0, gap 0 1, length 40..63 |
| 4360 | hbus driver | Executed WRITE addr=0x1000 data=0xf4 |
| 4365 | **DUT** | CONFIG router_en=0 maxpktsize=52 |
| 4365 | hbus monitor | Collected WRITE addr=0x1000 data=0xf4 |
| 4365 | reference | maxpktsize is now 52 |
| 4380 | hbus driver | Executed WRITE addr=0x1001 data=0x73 |
| 4385 | **DUT** | CONFIG router_en=1 maxpktsize=52 |
| 4385 | hbus monitor | Collected WRITE addr=0x1001 data=0x73 |
| 4385 | reference | router_en is now 1 (en_reg 0x73) |
| 4410 | hbus driver | Executed READ  addr=0x102a data=0x6d |
| 4415 | hbus monitor | Collected READ  addr=0x102a data=0x6d |
| 4430 | hbus driver | Executed WRITE addr=0x11dd data=0x4d |
| 4435 | hbus monitor | Collected WRITE addr=0x11dd data=0x4d |
| 4460 | hbus driver | Executed READ  addr=0x11dd data=0x4d |
| 4465 | hbus monitor | Collected READ  addr=0x11dd data=0x4d |
| 4480 | hbus driver | Executed WRITE addr=0x1119 data=0x6c |
| 4485 | hbus monitor | Collected WRITE addr=0x1119 data=0x6c |
| 4510 | hbus driver | Executed READ  addr=0x1119 data=0x6c |
| 4515 | hbus monitor | Collected READ  addr=0x1119 data=0x6c |
| 4540 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 4540 | **test** | STAGE: burst 3/6: ctrl=0xf4 (maxpktsize 52) en=0x73 (router on, counter enables 0111001), 3 packet(s) |
| 4540 | yapp driver | TX pkt #8: addr=1 len=36 parity=good delay=12 |
| 4545 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4675 | **DUT** | IN  pkt #8 header: addr=1 len=36 -> channel 1 |
| 4685 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=36 (receiver waited 0 cycle(s)) |
| 5045 | **DUT** | IN  pkt #8 complete: addr=1 len=36 parity=ok forwarded, 38 bytes in 38 cycles (held 0) |
| 5045 | yapp monitor | RX pkt #8 on the input: addr=1 len=36 parity=good gap=33 |
| 5045 | reference | Packet forwarded: addr=1 len=36 -> channel 1 |
| 5050 | ch1 driver | ch1: packet consumed (response delay 0) |
| 5050 | yapp driver | TX pkt #8 accepted by the DUT |
| 5050 | yapp driver | TX pkt #9: addr=2 len=16 parity=good delay=0 |
| 5055 | **DUT** | IN  pkt #9 header: addr=2 len=16 -> channel 2 |
| 5065 | **DUT** | OUT ch1 pkt #1 done: 38 bytes in 39 cycles |
| 5065 | ch1 monitor | ch1 RX pkt #1: addr=1 len=36 parity=good |
| 5065 | scoreboard | ch1 pkt matched: addr=1 len=36 (4 matched so far) |
| 5115 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=16 (receiver waited 5 cycle(s)) |
| 5225 | **DUT** | IN  pkt #9 complete: addr=2 len=16 parity=ok forwarded, 18 bytes in 18 cycles (held 0) |
| 5225 | yapp monitor | RX pkt #9 on the input: addr=2 len=16 parity=good gap=0 |
| 5225 | reference | Packet forwarded: addr=2 len=16 -> channel 2 |
| 5230 | yapp driver | TX pkt #9 accepted by the DUT |
| 5230 | yapp driver | TX pkt #10: addr=2 len=52 parity=bad delay=0 |
| 5235 | **DUT** | IN  pkt #10 header: addr=2 len=52 -> channel 2 |
| 5280 | ch2 driver | ch2: packet consumed (response delay 5) |
| 5335 | **DUT** | OUT ch2 pkt #2 done: 18 bytes in 23 cycles |
| 5335 | ch2 monitor | ch2 RX pkt #2: addr=2 len=16 parity=good |
| 5335 | scoreboard | ch2 pkt matched: addr=2 len=16 (5 matched so far) |
| 5345 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=52 (receiver waited 0 cycle(s)) |
| 5460 | ch1 driver | ch1: packet consumed (response delay 0) |
| 5765 | **DUT** | IN  pkt #10 complete: addr=2 len=52 parity=BAD forwarded, 54 bytes in 54 cycles (held 0) |
| 5765 | yapp monitor | RX pkt #10 on the input: addr=2 len=52 parity=bad gap=0 |
| 5765 | reference | Packet forwarded: addr=2 len=52 -> channel 2 |
| 5770 | yapp driver | TX pkt #10 accepted by the DUT |
| 5770 | **test** | STAGE: burst 3/6 sent: addr0..3 0/1/2/0, bad parity 1, gap 0 2, length 16..52 |
| 5790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 5790 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 5790 | hbus driver | Executed WRITE addr=0x1000 data=0xc1 |
| 5795 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 5795 | hbus monitor | Collected WRITE addr=0x1000 data=0xc1 |
| 5795 | reference | maxpktsize is now 1 |
| 5810 | hbus driver | Executed WRITE addr=0x1001 data=0x33 |
| 5815 | hbus monitor | Collected WRITE addr=0x1001 data=0x33 |
| 5815 | reference | router_en is now 1 (en_reg 0x33) |
| 5840 | hbus driver | Executed READ  addr=0x100d data=0x34 |
| 5845 | hbus monitor | Collected READ  addr=0x100d data=0x34 |
| 5860 | hbus driver | Executed WRITE addr=0x1101 data=0xae |
| 5865 | hbus monitor | Collected WRITE addr=0x1101 data=0xae |
| 5875 | **DUT** | OUT ch2 pkt #3 done: 54 bytes in 54 cycles |
| 5875 | ch2 monitor | ch2 RX pkt #3: addr=2 len=52 parity=bad |
| 5875 | scoreboard | ch2 pkt matched: addr=2 len=52 (6 matched so far) |
| 5890 | hbus driver | Executed READ  addr=0x1101 data=0xae |
| 5895 | hbus monitor | Collected READ  addr=0x1101 data=0xae |
| 5900 | ch2 driver | ch2: packet consumed (response delay 4) |
| 5910 | hbus driver | Executed WRITE addr=0x111e data=0x36 |
| 5915 | hbus monitor | Collected WRITE addr=0x111e data=0x36 |
| 5940 | hbus driver | Executed READ  addr=0x111e data=0x36 |
| 5945 | hbus monitor | Collected READ  addr=0x111e data=0x36 |
| 5960 | hbus driver | Executed WRITE addr=0x1176 data=0xe6 |
| 5965 | hbus monitor | Collected WRITE addr=0x1176 data=0xe6 |
| 5990 | hbus driver | Executed READ  addr=0x1176 data=0xe6 |
| 5995 | hbus monitor | Collected READ  addr=0x1176 data=0xe6 |
| 6020 | hbus driver | Executed READ  addr=0x100d data=0x34 |
| 6025 | hbus monitor | Collected READ  addr=0x100d data=0x34 |
| 6040 | hbus driver | Executed WRITE addr=0x1112 data=0x96 |
| 6045 | hbus monitor | Collected WRITE addr=0x1112 data=0x96 |
| 6070 | hbus driver | Executed READ  addr=0x1112 data=0x96 |
| 6075 | hbus monitor | Collected READ  addr=0x1112 data=0x96 |
| 6100 | hbus driver | Executed READ  addr=0x1044 data=0x50 |
| 6100 | **test** | STAGE: burst 4/6: ctrl=0xc1 (maxpktsize 1) en=0x33 (router on, counter enables 0011001), 3 packet(s) |
| 6100 | yapp driver | TX pkt #11: addr=1 len=50 parity=good delay=1 |
| 6105 | hbus monitor | Collected READ  addr=0x1044 data=0x50 |
| 6125 | **DUT** | IN  pkt #11 header: addr=1 len=50 -> DROP (oversized: len 50 > maxpktsize 1) |
| 6635 | **DUT** | IN  pkt #11 complete: addr=1 len=50 parity=ok dropped, 52 bytes in 52 cycles (held 0) |
| 6635 | yapp monitor | RX pkt #11 on the input: addr=1 len=50 parity=good gap=35 |
| 6635 | reference | Packet dropped: length 50 > maxpktsize 1 (addr=1) |
| 6635 | **DUT** | ROUTER DROPS PACKET addr=1 length=50 (length > maxpktsize) |
| 6640 | yapp driver | TX pkt #11 accepted by the DUT |
| 6640 | yapp driver | TX pkt #12: addr=0 len=9 parity=good delay=1 |
| 6655 | **DUT** | IN  pkt #12 header: addr=0 len=9 -> DROP (oversized: len 9 > maxpktsize 1) |
| 6755 | **DUT** | IN  pkt #12 complete: addr=0 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 6755 | yapp monitor | RX pkt #12 on the input: addr=0 len=9 parity=good gap=1 |
| 6755 | reference | Packet dropped: length 9 > maxpktsize 1 (addr=0) |
| 6755 | **DUT** | ROUTER DROPS PACKET addr=0 length=9 (length > maxpktsize) |
| 6760 | yapp driver | TX pkt #12 accepted by the DUT |
| 6760 | yapp driver | TX pkt #13: addr=2 len=2 parity=good delay=1 |
| 6775 | **DUT** | IN  pkt #13 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 6805 | **DUT** | IN  pkt #13 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 6805 | yapp monitor | RX pkt #13 on the input: addr=2 len=2 parity=good gap=1 |
| 6805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 6805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 6810 | yapp driver | TX pkt #13 accepted by the DUT |
| 6810 | **test** | STAGE: burst 4/6 sent: addr0..3 1/1/1/0, bad parity 0, gap 0 0, length 2..50 |
| 6830 | hbus driver | Executed WRITE addr=0x1000 data=0xe4 |
| 6835 | **DUT** | CONFIG router_en=1 maxpktsize=36 |
| 6835 | hbus monitor | Collected WRITE addr=0x1000 data=0xe4 |
| 6835 | reference | maxpktsize is now 36 |
| 6850 | hbus driver | Executed WRITE addr=0x1001 data=0xc3 |
| 6855 | hbus monitor | Collected WRITE addr=0x1001 data=0xc3 |
| 6855 | reference | router_en is now 1 (en_reg 0xc3) |
| 6870 | hbus driver | Executed WRITE addr=0x11c0 data=0x1d |
| 6875 | hbus monitor | Collected WRITE addr=0x11c0 data=0x1d |
| 6900 | hbus driver | Executed READ  addr=0x11c0 data=0x1d |
| 6905 | hbus monitor | Collected READ  addr=0x11c0 data=0x1d |
| 6920 | hbus driver | Executed WRITE addr=0x113c data=0xc0 |
| 6925 | hbus monitor | Collected WRITE addr=0x113c data=0xc0 |
| 6950 | hbus driver | Executed READ  addr=0x113c data=0xc0 |
| 6955 | hbus monitor | Collected READ  addr=0x113c data=0xc0 |
| 6970 | hbus driver | Executed WRITE addr=0x1197 data=0xf9 |
| 6975 | hbus monitor | Collected WRITE addr=0x1197 data=0xf9 |
| 7000 | hbus driver | Executed READ  addr=0x1197 data=0xf9 |
| 7005 | hbus monitor | Collected READ  addr=0x1197 data=0xf9 |
| 7020 | hbus driver | Executed WRITE addr=0x11ba data=0x12 |
| 7025 | hbus monitor | Collected WRITE addr=0x11ba data=0x12 |
| 7050 | hbus driver | Executed READ  addr=0x11ba data=0x12 |
| 7055 | hbus monitor | Collected READ  addr=0x11ba data=0x12 |
| 7070 | hbus driver | Executed WRITE addr=0x11e6 data=0x58 |
| 7075 | hbus monitor | Collected WRITE addr=0x11e6 data=0x58 |
| 7100 | hbus driver | Executed READ  addr=0x11e6 data=0x58 |
| 7105 | hbus monitor | Collected READ  addr=0x11e6 data=0x58 |
| 7120 | hbus driver | Executed WRITE addr=0x11e0 data=0x63 |
| 7125 | hbus monitor | Collected WRITE addr=0x11e0 data=0x63 |
| 7150 | hbus driver | Executed READ  addr=0x11e0 data=0x63 |
| 7150 | **test** | STAGE: burst 5/6: ctrl=0xe4 (maxpktsize 36) en=0xc3 (router on, counter enables 1100001), 4 packet(s) |
| 7150 | yapp driver | TX pkt #14: addr=2 len=1 parity=good delay=0 |
| 7155 | hbus monitor | Collected READ  addr=0x11e0 data=0x63 |
| 7165 | **DUT** | IN  pkt #14 header: addr=2 len=1 -> channel 2 |
| 7185 | **DUT** | IN  pkt #14 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7185 | yapp monitor | RX pkt #14 on the input: addr=2 len=1 parity=good gap=35 |
| 7185 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 7190 | yapp driver | TX pkt #14 accepted by the DUT |
| 7190 | yapp driver | TX pkt #15: addr=0 len=37 parity=good delay=19 |
| 7275 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=1 (receiver waited 10 cycle(s)) |
| 7290 | ch2 driver | ch2: packet consumed (response delay 10) |
| 7385 | **DUT** | IN  pkt #15 header: addr=0 len=37 -> DROP (oversized: len 37 > maxpktsize 36) |
| 7405 | **DUT** | OUT ch2 pkt #4 done: 3 bytes in 14 cycles |
| 7405 | ch2 monitor | ch2 RX pkt #4: addr=2 len=1 parity=good |
| 7405 | scoreboard | ch2 pkt matched: addr=2 len=1 (7 matched so far) |
| 7620 | ch2 driver | ch2: packet consumed (response delay 10) |
| 7765 | **DUT** | IN  pkt #15 complete: addr=0 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 7765 | yapp monitor | RX pkt #15 on the input: addr=0 len=37 parity=good gap=19 |
| 7765 | reference | Packet dropped: length 37 > maxpktsize 36 (addr=0) |
| 7765 | **DUT** | ROUTER DROPS PACKET addr=0 length=37 (length > maxpktsize) |
| 7770 | yapp driver | TX pkt #15 accepted by the DUT |
| 7770 | yapp driver | TX pkt #16: addr=1 len=57 parity=good delay=2 |
| 7795 | **DUT** | IN  pkt #16 header: addr=1 len=57 -> DROP (oversized: len 57 > maxpktsize 36) |
| 8375 | **DUT** | IN  pkt #16 complete: addr=1 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 8375 | yapp monitor | RX pkt #16 on the input: addr=1 len=57 parity=good gap=2 |
| 8375 | reference | Packet dropped: length 57 > maxpktsize 36 (addr=1) |
| 8375 | **DUT** | ROUTER DROPS PACKET addr=1 length=57 (length > maxpktsize) |
| 8380 | yapp driver | TX pkt #16 accepted by the DUT |
| 8380 | yapp driver | TX pkt #17: addr=2 len=37 parity=good delay=2 |
| 8405 | **DUT** | IN  pkt #17 header: addr=2 len=37 -> DROP (oversized: len 37 > maxpktsize 36) |
| 8785 | **DUT** | IN  pkt #17 complete: addr=2 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 8785 | yapp monitor | RX pkt #17 on the input: addr=2 len=37 parity=good gap=2 |
| 8785 | reference | Packet dropped: length 37 > maxpktsize 36 (addr=2) |
| 8785 | **DUT** | ROUTER DROPS PACKET addr=2 length=37 (length > maxpktsize) |
| 8790 | yapp driver | TX pkt #17 accepted by the DUT |
| 8790 | **test** | STAGE: burst 5/6 sent: addr0..3 1/1/2/0, bad parity 0, gap 0 1, length 1..57 |
| 8810 | hbus driver | Executed WRITE addr=0x1000 data=0x1f |
| 8815 | **DUT** | CONFIG router_en=1 maxpktsize=31 |
| 8815 | hbus monitor | Collected WRITE addr=0x1000 data=0x1f |
| 8815 | reference | maxpktsize is now 31 |
| 8830 | hbus driver | Executed WRITE addr=0x1001 data=0x22 |
| 8835 | **DUT** | CONFIG router_en=0 maxpktsize=31 |
| 8835 | hbus monitor | Collected WRITE addr=0x1001 data=0x22 |
| 8835 | reference | router_en is now 0 (en_reg 0x22) |
| 8860 | hbus driver | Executed READ  addr=0x10ec data=0x00 |
| 8865 | hbus monitor | Collected READ  addr=0x10ec data=0x00 |
| 8880 | hbus driver | Executed WRITE addr=0x1151 data=0x82 |
| 8885 | hbus monitor | Collected WRITE addr=0x1151 data=0x82 |
| 8910 | hbus driver | Executed READ  addr=0x1151 data=0x82 |
| 8915 | hbus monitor | Collected READ  addr=0x1151 data=0x82 |
| 8930 | hbus driver | Executed WRITE addr=0x114b data=0xbb |
| 8935 | hbus monitor | Collected WRITE addr=0x114b data=0xbb |
| 8960 | hbus driver | Executed READ  addr=0x114b data=0xbb |
| 8960 | **test** | STAGE: burst 6/6: ctrl=0x1f (maxpktsize 31) en=0x22 (router OFF, counter enables 0010001), 5 packet(s) |
| 8960 | yapp driver | TX pkt #18: addr=0 len=10 parity=good delay=0 |
| 8965 | hbus monitor | Collected READ  addr=0x114b data=0xbb |
| 8975 | **DUT** | IN  pkt #18 header: addr=0 len=10 -> DROP (router disabled) |
| 9085 | **DUT** | IN  pkt #18 complete: addr=0 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 9085 | yapp monitor | RX pkt #18 on the input: addr=0 len=10 parity=good gap=18 |
| 9085 | reference | Packet dropped: router disabled (addr=0 len=10) |
| 9085 | **DUT** | ROUTER DROPS PACKET addr=0 length=10 (router disabled) |
| 9090 | yapp driver | TX pkt #18 accepted by the DUT |
| 9090 | yapp driver | TX pkt #19: addr=2 len=22 parity=bad delay=1 |
| 9105 | **DUT** | IN  pkt #19 header: addr=2 len=22 -> DROP (router disabled) |
| 9335 | **DUT** | IN  pkt #19 complete: addr=2 len=22 parity=BAD dropped, 24 bytes in 24 cycles (held 0) |
| 9335 | yapp monitor | RX pkt #19 on the input: addr=2 len=22 parity=bad gap=1 |
| 9335 | reference | Packet dropped: router disabled (addr=2 len=22) |
| 9335 | **DUT** | ROUTER DROPS PACKET addr=2 length=22 (router disabled) |
| 9340 | yapp driver | TX pkt #19 accepted by the DUT |
| 9340 | yapp driver | TX pkt #20: addr=3 len=11 parity=good delay=0 |
| 9345 | **DUT** | IN  pkt #20 header: addr=3 len=11 -> DROP (router disabled) |
| 9465 | **DUT** | IN  pkt #20 complete: addr=3 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 9465 | yapp monitor | RX pkt #20 on the input: addr=3 len=11 parity=good gap=0 |
| 9465 | reference | Packet dropped: router disabled (addr=3 len=11) |
| 9465 | **DUT** | ROUTER DROPS PACKET addr=3 length=11 (router disabled) |
| 9470 | yapp driver | TX pkt #20 accepted by the DUT |
| 9470 | yapp driver | TX pkt #21: addr=2 len=1 parity=good delay=20 |
| 9675 | **DUT** | IN  pkt #21 header: addr=2 len=1 -> DROP (router disabled) |
| 9695 | **DUT** | IN  pkt #21 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 9695 | yapp monitor | RX pkt #21 on the input: addr=2 len=1 parity=good gap=20 |
| 9695 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 9695 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 9700 | yapp driver | TX pkt #21 accepted by the DUT |
| 9700 | yapp driver | TX pkt #22: addr=1 len=37 parity=good delay=20 |
| 9905 | **DUT** | IN  pkt #22 header: addr=1 len=37 -> DROP (router disabled) |
| 10285 | **DUT** | IN  pkt #22 complete: addr=1 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 10285 | yapp monitor | RX pkt #22 on the input: addr=1 len=37 parity=good gap=20 |
| 10285 | reference | Packet dropped: router disabled (addr=1 len=37) |
| 10285 | **DUT** | ROUTER DROPS PACKET addr=1 length=37 (router disabled) |
| 10290 | yapp driver | TX pkt #22 accepted by the DUT |
| 10290 | **test** | STAGE: burst 6/6 sent: addr0..3 1/1/2/1, bad parity 1, gap 0 2, length 1..37 |
| 10290 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 10320 | hbus driver | Executed READ  addr=0x1000 data=0x1f |
| 10325 | hbus monitor | Collected READ  addr=0x1000 data=0x1f |
| 10350 | hbus driver | Executed READ  addr=0x1001 data=0x22 |
| 10355 | hbus monitor | Collected READ  addr=0x1001 data=0x22 |
| 10380 | hbus driver | Executed READ  addr=0x1004 data=0x02 |
| 10385 | hbus monitor | Collected READ  addr=0x1004 data=0x02 |
| 10410 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 10415 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10440 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 10445 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10470 | hbus driver | Executed READ  addr=0x1009 data=0x03 |
| 10475 | hbus monitor | Collected READ  addr=0x1009 data=0x03 |
| 10500 | hbus driver | Executed READ  addr=0x100a data=0x02 |
| 10505 | hbus monitor | Collected READ  addr=0x100a data=0x02 |
| 10530 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 10535 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 10560 | hbus driver | Executed READ  addr=0x100d data=0x25 |
| 10565 | hbus monitor | Collected READ  addr=0x100d data=0x25 |
| 10590 | hbus driver | Executed READ  addr=0x1010 data=0x96 |
| 10595 | hbus monitor | Collected READ  addr=0x1010 data=0x96 |
| 10620 | hbus driver | Executed READ  addr=0x1011 data=0x97 |
| 10625 | hbus monitor | Collected READ  addr=0x1011 data=0x97 |
| 10650 | hbus driver | Executed READ  addr=0x1012 data=0x78 |
| 10655 | hbus monitor | Collected READ  addr=0x1012 data=0x78 |
| 10680 | hbus driver | Executed READ  addr=0x1013 data=0x5c |
| 10685 | hbus monitor | Collected READ  addr=0x1013 data=0x5c |
| 10710 | hbus driver | Executed READ  addr=0x1014 data=0x2f |
| 10715 | hbus monitor | Collected READ  addr=0x1014 data=0x2f |
| 10740 | hbus driver | Executed READ  addr=0x1015 data=0xa3 |
| 10745 | hbus monitor | Collected READ  addr=0x1015 data=0xa3 |
| 10770 | hbus driver | Executed READ  addr=0x1016 data=0x97 |
| 10775 | hbus monitor | Collected READ  addr=0x1016 data=0x97 |
| 10800 | hbus driver | Executed READ  addr=0x1017 data=0x77 |
| 10805 | hbus monitor | Collected READ  addr=0x1017 data=0x77 |
| 10830 | hbus driver | Executed READ  addr=0x1018 data=0x75 |
| 10835 | hbus monitor | Collected READ  addr=0x1018 data=0x75 |
| 10860 | hbus driver | Executed READ  addr=0x1019 data=0x03 |
| 10865 | hbus monitor | Collected READ  addr=0x1019 data=0x03 |
| 10890 | hbus driver | Executed READ  addr=0x101a data=0x40 |
| 10895 | hbus monitor | Collected READ  addr=0x101a data=0x40 |
| 10920 | hbus driver | Executed READ  addr=0x101b data=0xf5 |
| 10925 | hbus monitor | Collected READ  addr=0x101b data=0xf5 |
| 10950 | hbus driver | Executed READ  addr=0x101c data=0x14 |
| 10955 | hbus monitor | Collected READ  addr=0x101c data=0x14 |
| 10980 | hbus driver | Executed READ  addr=0x101d data=0xf5 |
| 10985 | hbus monitor | Collected READ  addr=0x101d data=0xf5 |
| 11010 | hbus driver | Executed READ  addr=0x101e data=0x2b |
| 11015 | hbus monitor | Collected READ  addr=0x101e data=0x2b |
| 11040 | hbus driver | Executed READ  addr=0x101f data=0x96 |
| 11045 | hbus monitor | Collected READ  addr=0x101f data=0x96 |
| 11070 | hbus driver | Executed READ  addr=0x1020 data=0x7a |
| 11075 | hbus monitor | Collected READ  addr=0x1020 data=0x7a |
| 11100 | hbus driver | Executed READ  addr=0x1021 data=0xd3 |
| 11105 | hbus monitor | Collected READ  addr=0x1021 data=0xd3 |
| 11130 | hbus driver | Executed READ  addr=0x1022 data=0xba |
| 11135 | hbus monitor | Collected READ  addr=0x1022 data=0xba |
| 11160 | hbus driver | Executed READ  addr=0x1023 data=0x9f |
| 11165 | hbus monitor | Collected READ  addr=0x1023 data=0x9f |
| 11190 | hbus driver | Executed READ  addr=0x1024 data=0xae |
| 11195 | hbus monitor | Collected READ  addr=0x1024 data=0xae |
| 11220 | hbus driver | Executed READ  addr=0x1025 data=0x49 |
| 11225 | hbus monitor | Collected READ  addr=0x1025 data=0x49 |
| 11250 | hbus driver | Executed READ  addr=0x1026 data=0xce |
| 11255 | hbus monitor | Collected READ  addr=0x1026 data=0xce |
| 11280 | hbus driver | Executed READ  addr=0x1027 data=0x36 |
| 11285 | hbus monitor | Collected READ  addr=0x1027 data=0x36 |
| 11310 | hbus driver | Executed READ  addr=0x1028 data=0xce |
| 11315 | hbus monitor | Collected READ  addr=0x1028 data=0xce |
| 11340 | hbus driver | Executed READ  addr=0x1029 data=0x39 |
| 11345 | hbus monitor | Collected READ  addr=0x1029 data=0x39 |
| 11370 | hbus driver | Executed READ  addr=0x102a data=0xe0 |
| 11375 | hbus monitor | Collected READ  addr=0x102a data=0xe0 |
| 11400 | hbus driver | Executed READ  addr=0x102b data=0x23 |
| 11405 | hbus monitor | Collected READ  addr=0x102b data=0x23 |
| 11430 | hbus driver | Executed READ  addr=0x102c data=0x25 |
| 11435 | hbus monitor | Collected READ  addr=0x102c data=0x25 |
| 11460 | hbus driver | Executed READ  addr=0x102d data=0x47 |
| 11465 | hbus monitor | Collected READ  addr=0x102d data=0x47 |
| 11490 | hbus driver | Executed READ  addr=0x102e data=0x8a |
| 11495 | hbus monitor | Collected READ  addr=0x102e data=0x8a |
| 11520 | hbus driver | Executed READ  addr=0x102f data=0xb0 |
| 11525 | hbus monitor | Collected READ  addr=0x102f data=0xb0 |
| 11550 | hbus driver | Executed READ  addr=0x1030 data=0xef |
| 11555 | hbus monitor | Collected READ  addr=0x1030 data=0xef |
| 11580 | hbus driver | Executed READ  addr=0x1031 data=0xdf |
| 11585 | hbus monitor | Collected READ  addr=0x1031 data=0xdf |
| 11610 | hbus driver | Executed READ  addr=0x1032 data=0x67 |
| 11615 | hbus monitor | Collected READ  addr=0x1032 data=0x67 |
| 11640 | hbus driver | Executed READ  addr=0x1033 data=0xa0 |
| 11645 | hbus monitor | Collected READ  addr=0x1033 data=0xa0 |
| 11670 | hbus driver | Executed READ  addr=0x1034 data=0xd2 |
| 11675 | hbus monitor | Collected READ  addr=0x1034 data=0xd2 |
| 11700 | hbus driver | Executed READ  addr=0x1035 data=0x34 |
| 11705 | hbus monitor | Collected READ  addr=0x1035 data=0x34 |
| 11815 | **test** | STAGE: done: 22 packets (7 forwarded, 15 dropped), 0 storm burst(s), 7 scoreboard matches, 78 HBUS reads checked, 2 error pulses for 2 bad packets |
| 12015 | error checker | error pulse report: 2 bad packets, 2 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 12015 | ch0 monitor | Channel 0 report: 2 packets collected |
| 12015 | ch1 monitor | Channel 1 report: 1 packets collected |
| 12015 | ch2 monitor | Channel 2 report: 4 packets collected |
| 12015 | hbus monitor | HBUS report: 30 writes, 78 reads |
| 12015 | reference |  |
| 12015 | reference | HBUS reads checked against the model: 78 (0 mismatches, 0 of memory bytes never written) |
| 12015 | reference | Coverage of the router configuration: 65.2% |
| 12015 | scoreboard |  |
| 12015 | yapp driver | YAPP driver report: 22 packets sent |
| 12015 | yapp monitor | YAPP monitor report: 22 packets collected, coverage 60.0% |
| 12015 | yapp monitor | YAPP gaps: 4 back to back, 3 of 1 cycle, 2 of 2, 12 longer (gap coverage 100.0%) |
