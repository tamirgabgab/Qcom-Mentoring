# random_config_test seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 34us · wall 20.2 s · log [`random_config_test_s4.log`](random_config_test_s4.log)

Waves: `random_config_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s4%2Frandom_config_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **61** packet(s) (9 with bad parity); the input monitor saw 61.
- Router: **22** forwarded, **39** dropped (9 router disabled, 29 oversized, 1 illegal address 3).
- Packets out: ch0 **9**, ch1 **4**, ch2 **9**.
- Scoreboard: 22 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **4** time(s), longest hold 19 cycle(s).
- Error pulses: 7.
- HBUS: 46 write(s), 133 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_SLOW, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 61 packets in 7 bursts |
| 570 | burst 1/7: ctrl=0xc1 (maxpktsize 1) en=0xfe (router OFF, counter enables 1111111), 9 packet(s) |
| 4600 | burst 1/7 sent: addr0..3 2/3/3/1, bad parity 2, gap 0 4, length 1..63 |
| 4960 | burst 2/7: ctrl=0x7f (maxpktsize 63) en=0x8b (router on, counter enables 1000101), 9 packet(s) |
| 8680 | burst 2/7 sent: addr0..3 4/1/4/0, bad parity 0, gap 0 3, length 1..63 |
| 8960 | burst 3/7: ctrl=0x7e (maxpktsize 62) en=0x1b (router on, counter enables 0001101), 9 packet(s) |
| 13810 | burst 3/7 sent: addr0..3 2/1/6/0, bad parity 1, gap 0 6, length 23..63 |
| 14170 | burst 4/7: ctrl=0xc3 (maxpktsize 3) en=0xdf (router on, counter enables 1101111), 8 packet(s) |
| 18020 | burst 4/7 sent: addr0..3 4/0/2/2, bad parity 1, gap 0 0, length 2..63 |
| 18280 | burst 5/7: ctrl=0x3e (maxpktsize 62) en=0x01 (router on, counter enables 0000000), 8 packet(s) |
| 23320 | burst 5/7 sent: addr0..3 4/2/1/1, bad parity 1, gap 0 1, length 1..63 |
| 23800 | burst 6/7: ctrl=0x03 (maxpktsize 3) en=0xd9 (router on, counter enables 1101100), 10 packet(s) |
| 27750 | burst 6/7 sent: addr0..3 2/3/4/1, bad parity 3, gap 0 2, length 1..63 |
| 28210 | burst 7/7: ctrl=0x00 (maxpktsize 0) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 31430 | burst 7/7 sent: addr0..3 0/4/4/0, bad parity 1, gap 0 1, length 1..63 |
| 31430 | final reads: every register and the stored packet, checked against the reference model |
| 33735 | done: 61 packets (22 forwarded, 39 dropped), 0 storm burst(s), 22 scoreboard matches, 129 HBUS reads checked, 7 error pulses for 7 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 2**

![first packet out on channel 2](wave_first_packet_out.svg)

**first back-pressure on the input port**

![first back-pressure on the input port](wave_first_suspend.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

974 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_SLOW, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 61 packets in 7 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0xc1 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0xc1 |
| 75 | reference | maxpktsize is now 1 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 95 | **DUT** | CONFIG router_en=0 maxpktsize=1 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 95 | reference | router_en is now 0 (en_reg 0xfe) |
| 110 | hbus driver | Executed WRITE addr=0x1120 data=0x0f |
| 115 | hbus monitor | Collected WRITE addr=0x1120 data=0x0f |
| 140 | hbus driver | Executed READ  addr=0x1120 data=0x0f |
| 145 | hbus monitor | Collected READ  addr=0x1120 data=0x0f |
| 170 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 200 | hbus driver | Executed READ  addr=0x1041 data=0x00 |
| 205 | hbus monitor | Collected READ  addr=0x1041 data=0x00 |
| 220 | hbus driver | Executed WRITE addr=0x111b data=0x28 |
| 225 | hbus monitor | Collected WRITE addr=0x111b data=0x28 |
| 250 | hbus driver | Executed READ  addr=0x111b data=0x28 |
| 255 | hbus monitor | Collected READ  addr=0x111b data=0x28 |
| 280 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 285 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 300 | hbus driver | Executed WRITE addr=0x116c data=0x44 |
| 305 | hbus monitor | Collected WRITE addr=0x116c data=0x44 |
| 330 | hbus driver | Executed READ  addr=0x116c data=0x44 |
| 335 | hbus monitor | Collected READ  addr=0x116c data=0x44 |
| 360 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 365 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 380 | hbus driver | Executed WRITE addr=0x1100 data=0xc4 |
| 385 | hbus monitor | Collected WRITE addr=0x1100 data=0xc4 |
| 410 | hbus driver | Executed READ  addr=0x1100 data=0xc4 |
| 415 | hbus monitor | Collected READ  addr=0x1100 data=0xc4 |
| 430 | hbus driver | Executed WRITE addr=0x11e5 data=0x8c |
| 435 | hbus monitor | Collected WRITE addr=0x11e5 data=0x8c |
| 460 | hbus driver | Executed READ  addr=0x11e5 data=0x8c |
| 465 | hbus monitor | Collected READ  addr=0x11e5 data=0x8c |
| 480 | hbus driver | Executed WRITE addr=0x11f1 data=0x5a |
| 485 | hbus monitor | Collected WRITE addr=0x11f1 data=0x5a |
| 510 | hbus driver | Executed READ  addr=0x11f1 data=0x5a |
| 515 | hbus monitor | Collected READ  addr=0x11f1 data=0x5a |
| 540 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 545 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 570 | hbus driver | Executed READ  addr=0x1034 data=0x00 |
| 570 | **test** | STAGE: burst 1/7: ctrl=0xc1 (maxpktsize 1) en=0xfe (router OFF, counter enables 1111111), 9 packet(s) |
| 570 | yapp driver | TX pkt #1: addr=1 len=44 parity=good delay=0 |
| 575 | hbus monitor | Collected READ  addr=0x1034 data=0x00 |
| 585 | **DUT** | IN  pkt #1 header: addr=1 len=44 -> DROP (router disabled) |
| 1035 | **DUT** | IN  pkt #1 complete: addr=1 len=44 parity=ok dropped, 46 bytes in 46 cycles (held 0) |
| 1035 | yapp monitor | RX pkt #1 on the input: addr=1 len=44 parity=good gap=53 |
| 1035 | reference | Packet dropped: router disabled (addr=1 len=44) |
| 1035 | **DUT** | ROUTER DROPS PACKET addr=1 length=44 (router disabled) |
| 1040 | yapp driver | TX pkt #1 accepted by the DUT |
| 1040 | yapp driver | TX pkt #2: addr=1 len=63 parity=good delay=20 |
| 1245 | **DUT** | IN  pkt #2 header: addr=1 len=63 -> DROP (router disabled) |
| 1885 | **DUT** | IN  pkt #2 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1885 | yapp monitor | RX pkt #2 on the input: addr=1 len=63 parity=good gap=20 |
| 1885 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 1885 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 1890 | yapp driver | TX pkt #2 accepted by the DUT |
| 1890 | yapp driver | TX pkt #3: addr=2 len=63 parity=bad delay=0 |
| 1895 | **DUT** | IN  pkt #3 header: addr=2 len=63 -> DROP (router disabled) |
| 2535 | **DUT** | IN  pkt #3 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 2535 | yapp monitor | RX pkt #3 on the input: addr=2 len=63 parity=bad gap=0 |
| 2535 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 2535 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 2540 | yapp driver | TX pkt #3 accepted by the DUT |
| 2540 | yapp driver | TX pkt #4: addr=3 len=2 parity=good delay=17 |
| 2715 | **DUT** | IN  pkt #4 header: addr=3 len=2 -> DROP (router disabled) |
| 2745 | **DUT** | IN  pkt #4 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 2745 | yapp monitor | RX pkt #4 on the input: addr=3 len=2 parity=good gap=17 |
| 2745 | reference | Packet dropped: router disabled (addr=3 len=2) |
| 2745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (router disabled) |
| 2750 | yapp driver | TX pkt #4 accepted by the DUT |
| 2750 | yapp driver | TX pkt #5: addr=1 len=1 parity=bad delay=0 |
| 2755 | **DUT** | IN  pkt #5 header: addr=1 len=1 -> DROP (router disabled) |
| 2775 | **DUT** | IN  pkt #5 complete: addr=1 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 2775 | yapp monitor | RX pkt #5 on the input: addr=1 len=1 parity=bad gap=0 |
| 2775 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 2775 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 2780 | yapp driver | TX pkt #5 accepted by the DUT |
| 2780 | yapp driver | TX pkt #6: addr=0 len=1 parity=good delay=6 |
| 2845 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> DROP (router disabled) |
| 2865 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 2865 | yapp monitor | RX pkt #6 on the input: addr=0 len=1 parity=good gap=6 |
| 2865 | reference | Packet dropped: router disabled (addr=0 len=1) |
| 2865 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (router disabled) |
| 2870 | yapp driver | TX pkt #6 accepted by the DUT |
| 2870 | yapp driver | TX pkt #7: addr=2 len=27 parity=good delay=0 |
| 2875 | **DUT** | IN  pkt #7 header: addr=2 len=27 -> DROP (router disabled) |
| 3155 | **DUT** | IN  pkt #7 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 3155 | yapp monitor | RX pkt #7 on the input: addr=2 len=27 parity=good gap=0 |
| 3155 | reference | Packet dropped: router disabled (addr=2 len=27) |
| 3155 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (router disabled) |
| 3160 | yapp driver | TX pkt #7 accepted by the DUT |
| 3160 | yapp driver | TX pkt #8: addr=2 len=44 parity=good delay=13 |
| 3295 | **DUT** | IN  pkt #8 header: addr=2 len=44 -> DROP (router disabled) |
| 3745 | **DUT** | IN  pkt #8 complete: addr=2 len=44 parity=ok dropped, 46 bytes in 46 cycles (held 0) |
| 3745 | yapp monitor | RX pkt #8 on the input: addr=2 len=44 parity=good gap=13 |
| 3745 | reference | Packet dropped: router disabled (addr=2 len=44) |
| 3745 | **DUT** | ROUTER DROPS PACKET addr=2 length=44 (router disabled) |
| 3750 | yapp driver | TX pkt #8 accepted by the DUT |
| 3750 | yapp driver | TX pkt #9: addr=0 len=63 parity=good delay=20 |
| 3955 | **DUT** | IN  pkt #9 header: addr=0 len=63 -> DROP (router disabled) |
| 4595 | **DUT** | IN  pkt #9 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4595 | yapp monitor | RX pkt #9 on the input: addr=0 len=63 parity=good gap=20 |
| 4595 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 4595 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 4600 | yapp driver | TX pkt #9 accepted by the DUT |
| 4600 | **test** | STAGE: burst 1/7 sent: addr0..3 2/3/3/1, bad parity 2, gap 0 4, length 1..63 |
| 4620 | hbus driver | Executed WRITE addr=0x1000 data=0x7f |
| 4625 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 4625 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 4625 | reference | maxpktsize is now 63 |
| 4640 | hbus driver | Executed WRITE addr=0x1001 data=0x8b |
| 4645 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 4645 | hbus monitor | Collected WRITE addr=0x1001 data=0x8b |
| 4645 | reference | router_en is now 1 (en_reg 0x8b) |
| 4670 | hbus driver | Executed READ  addr=0x104d data=0x00 |
| 4675 | hbus monitor | Collected READ  addr=0x104d data=0x00 |
| 4700 | hbus driver | Executed READ  addr=0x1000 data=0x7f |
| 4705 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 4730 | hbus driver | Executed READ  addr=0x1016 data=0x00 |
| 4735 | hbus monitor | Collected READ  addr=0x1016 data=0x00 |
| 4750 | hbus driver | Executed WRITE addr=0x11d9 data=0x62 |
| 4755 | hbus monitor | Collected WRITE addr=0x11d9 data=0x62 |
| 4780 | hbus driver | Executed READ  addr=0x11d9 data=0x62 |
| 4785 | hbus monitor | Collected READ  addr=0x11d9 data=0x62 |
| 4800 | hbus driver | Executed WRITE addr=0x11e3 data=0xe7 |
| 4805 | hbus monitor | Collected WRITE addr=0x11e3 data=0xe7 |
| 4830 | hbus driver | Executed READ  addr=0x11e3 data=0xe7 |
| 4835 | hbus monitor | Collected READ  addr=0x11e3 data=0xe7 |
| 4860 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 4865 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4880 | hbus driver | Executed WRITE addr=0x11df data=0x06 |
| 4885 | hbus monitor | Collected WRITE addr=0x11df data=0x06 |
| 4910 | hbus driver | Executed READ  addr=0x11df data=0x06 |
| 4915 | hbus monitor | Collected READ  addr=0x11df data=0x06 |
| 4930 | hbus driver | Executed WRITE addr=0x11d5 data=0x58 |
| 4935 | hbus monitor | Collected WRITE addr=0x11d5 data=0x58 |
| 4960 | hbus driver | Executed READ  addr=0x11d5 data=0x58 |
| 4960 | **test** | STAGE: burst 2/7: ctrl=0x7f (maxpktsize 63) en=0x8b (router on, counter enables 1000101), 9 packet(s) |
| 4960 | yapp driver | TX pkt #10: addr=2 len=63 parity=good delay=0 |
| 4965 | hbus monitor | Collected READ  addr=0x11d5 data=0x58 |
| 4975 | **DUT** | IN  pkt #10 header: addr=2 len=63 -> channel 2 |
| 4985 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 5615 | **DUT** | IN  pkt #10 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 5615 | yapp monitor | RX pkt #10 on the input: addr=2 len=63 parity=good gap=37 |
| 5615 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 5620 | ch2 driver | ch2: packet consumed (response delay 0) |
| 5620 | yapp driver | TX pkt #10 accepted by the DUT |
| 5620 | yapp driver | TX pkt #11: addr=0 len=63 parity=good delay=0 |
| 5625 | **DUT** | IN  pkt #11 header: addr=0 len=63 -> channel 0 |
| 5635 | **DUT** | OUT ch2 pkt #1 done: 65 bytes in 66 cycles |
| 5635 | ch2 monitor | ch2 RX pkt #1: addr=2 len=63 parity=good |
| 5635 | scoreboard | ch2 pkt matched: addr=2 len=63 (1 matched so far) |
| 5735 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=63 (receiver waited 10 cycle(s)) |
| 6265 | **DUT** | IN  pkt #11 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 6265 | yapp monitor | RX pkt #11 on the input: addr=0 len=63 parity=good gap=0 |
| 6265 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 6270 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6270 | yapp driver | TX pkt #11 accepted by the DUT |
| 6270 | yapp driver | TX pkt #12: addr=2 len=1 parity=good delay=5 |
| 6325 | **DUT** | IN  pkt #12 header: addr=2 len=1 -> channel 2 |
| 6335 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 6345 | **DUT** | IN  pkt #12 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6345 | yapp monitor | RX pkt #12 on the input: addr=2 len=1 parity=good gap=5 |
| 6345 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 6350 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6350 | yapp driver | TX pkt #12 accepted by the DUT |
| 6350 | yapp driver | TX pkt #13: addr=1 len=63 parity=good delay=13 |
| 6365 | **DUT** | OUT ch2 pkt #2 done: 3 bytes in 4 cycles |
| 6365 | ch2 monitor | ch2 RX pkt #2: addr=2 len=1 parity=good |
| 6365 | scoreboard | ch2 pkt matched: addr=2 len=1 (2 matched so far) |
| 6370 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6485 | **DUT** | IN  pkt #13 header: addr=1 len=63 -> channel 1 |
| 6485 | **DUT** | OUT ch0 pkt #1 done: 65 bytes in 76 cycles |
| 6485 | ch0 monitor | ch0 RX pkt #1: addr=0 len=63 parity=good |
| 6485 | scoreboard | ch0 pkt matched: addr=0 len=63 (3 matched so far) |
| 6580 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6645 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0xe7 held (pkt #13) |
| 6720 | ch0 driver | ch0: packet consumed (response delay 10) |
| 6725 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=63 (receiver waited 23 cycle(s)) |
| 6735 | **DUT** | SUSPEND released after 9 cycle(s) |
| 7215 | **DUT** | IN  pkt #13 complete: addr=1 len=63 parity=ok forwarded, 65 bytes in 74 cycles (held 9) |
| 7215 | yapp monitor | RX pkt #13 on the input: addr=1 len=63 parity=good gap=13 |
| 7215 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 7220 | yapp driver | TX pkt #13 accepted by the DUT |
| 7220 | yapp driver | TX pkt #14: addr=0 len=35 parity=good delay=2 |
| 7245 | **DUT** | IN  pkt #14 header: addr=0 len=35 -> channel 0 |
| 7335 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=35 (receiver waited 8 cycle(s)) |
| 7360 | ch1 driver | ch1: packet consumed (response delay 23) |
| 7605 | **DUT** | IN  pkt #14 complete: addr=0 len=35 parity=ok forwarded, 37 bytes in 37 cycles (held 0) |
| 7605 | yapp monitor | RX pkt #14 on the input: addr=0 len=35 parity=good gap=2 |
| 7605 | reference | Packet forwarded: addr=0 len=35 -> channel 0 |
| 7610 | yapp driver | TX pkt #14 accepted by the DUT |
| 7610 | yapp driver | TX pkt #15: addr=0 len=54 parity=good delay=3 |
| 7645 | **DUT** | IN  pkt #15 header: addr=0 len=54 -> channel 0 |
| 7690 | ch0 driver | ch0: packet consumed (response delay 8) |
| 7775 | **DUT** | OUT ch1 pkt #1 done: 65 bytes in 106 cycles |
| 7775 | ch1 monitor | ch1 RX pkt #1: addr=1 len=63 parity=good |
| 7775 | scoreboard | ch1 pkt matched: addr=1 len=63 (4 matched so far) |
| 7795 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x0c held (pkt #15) |
| 7805 | **DUT** | OUT ch0 pkt #2 done: 37 bytes in 48 cycles |
| 7805 | ch0 monitor | ch0 RX pkt #2: addr=0 len=35 parity=good |
| 7805 | scoreboard | ch0 pkt matched: addr=0 len=35 (5 matched so far) |
| 7815 | **DUT** | SUSPEND released after 2 cycle(s) |
| 7815 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=54 (receiver waited 0 cycle(s)) |
| 8000 | ch1 driver | ch1: packet consumed (response delay 40) |
| 8130 | ch0 driver | ch0: packet consumed (response delay 10) |
| 8145 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x8b held (pkt #15) |
| 8165 | **DUT** | SUSPEND released after 2 cycle(s) |
| 8235 | **DUT** | IN  pkt #15 complete: addr=0 len=54 parity=ok forwarded, 56 bytes in 60 cycles (held 4) |
| 8235 | yapp monitor | RX pkt #15 on the input: addr=0 len=54 parity=good gap=3 |
| 8235 | reference | Packet forwarded: addr=0 len=54 -> channel 0 |
| 8240 | yapp driver | TX pkt #15 accepted by the DUT |
| 8240 | yapp driver | TX pkt #16: addr=2 len=1 parity=good delay=7 |
| 8315 | **DUT** | IN  pkt #16 header: addr=2 len=1 -> channel 2 |
| 8325 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 8335 | **DUT** | IN  pkt #16 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8335 | yapp monitor | RX pkt #16 on the input: addr=2 len=1 parity=good gap=7 |
| 8335 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 8340 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8340 | yapp driver | TX pkt #16 accepted by the DUT |
| 8340 | yapp driver | TX pkt #17: addr=0 len=13 parity=good delay=2 |
| 8355 | **DUT** | OUT ch2 pkt #3 done: 3 bytes in 4 cycles |
| 8355 | ch2 monitor | ch2 RX pkt #3: addr=2 len=1 parity=good |
| 8355 | scoreboard | ch2 pkt matched: addr=2 len=1 (6 matched so far) |
| 8365 | **DUT** | IN  pkt #17 header: addr=0 len=13 -> channel 0 |
| 8385 | **DUT** | OUT ch0 pkt #3 done: 56 bytes in 58 cycles |
| 8385 | ch0 monitor | ch0 RX pkt #3: addr=0 len=54 parity=good |
| 8385 | scoreboard | ch0 pkt matched: addr=0 len=54 (7 matched so far) |
| 8395 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=13 (receiver waited 0 cycle(s)) |
| 8460 | ch0 driver | ch0: packet consumed (response delay 1) |
| 8505 | **DUT** | IN  pkt #17 complete: addr=0 len=13 parity=ok forwarded, 15 bytes in 15 cycles (held 0) |
| 8505 | yapp monitor | RX pkt #17 on the input: addr=0 len=13 parity=good gap=2 |
| 8505 | reference | Packet forwarded: addr=0 len=13 -> channel 0 |
| 8510 | yapp driver | TX pkt #17 accepted by the DUT |
| 8510 | yapp driver | TX pkt #18: addr=2 len=15 parity=good delay=0 |
| 8515 | **DUT** | IN  pkt #18 header: addr=2 len=15 -> channel 2 |
| 8525 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=15 (receiver waited 0 cycle(s)) |
| 8555 | **DUT** | OUT ch0 pkt #4 done: 15 bytes in 17 cycles |
| 8555 | ch0 monitor | ch0 RX pkt #4: addr=0 len=13 parity=good |
| 8555 | scoreboard | ch0 pkt matched: addr=0 len=13 (8 matched so far) |
| 8640 | ch0 driver | ch0: packet consumed (response delay 1) |
| 8675 | **DUT** | IN  pkt #18 complete: addr=2 len=15 parity=ok forwarded, 17 bytes in 17 cycles (held 0) |
| 8675 | yapp monitor | RX pkt #18 on the input: addr=2 len=15 parity=good gap=0 |
| 8675 | reference | Packet forwarded: addr=2 len=15 -> channel 2 |
| 8680 | yapp driver | TX pkt #18 accepted by the DUT |
| 8680 | **test** | STAGE: burst 2/7 sent: addr0..3 4/1/4/0, bad parity 0, gap 0 3, length 1..63 |
| 8685 | **DUT** | OUT ch2 pkt #4 done: 17 bytes in 17 cycles |
| 8685 | ch2 monitor | ch2 RX pkt #4: addr=2 len=15 parity=good |
| 8685 | scoreboard | ch2 pkt matched: addr=2 len=15 (9 matched so far) |
| 8700 | hbus driver | Executed WRITE addr=0x1000 data=0x7e |
| 8705 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 8705 | hbus monitor | Collected WRITE addr=0x1000 data=0x7e |
| 8705 | reference | maxpktsize is now 62 |
| 8720 | hbus driver | Executed WRITE addr=0x1001 data=0x1b |
| 8725 | hbus monitor | Collected WRITE addr=0x1001 data=0x1b |
| 8725 | reference | router_en is now 1 (en_reg 0x1b) |
| 8750 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 8755 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8770 | hbus driver | Executed WRITE addr=0x112f data=0xaa |
| 8775 | hbus monitor | Collected WRITE addr=0x112f data=0xaa |
| 8800 | hbus driver | Executed READ  addr=0x112f data=0xaa |
| 8805 | hbus monitor | Collected READ  addr=0x112f data=0xaa |
| 8820 | hbus driver | Executed WRITE addr=0x1184 data=0x11 |
| 8825 | hbus monitor | Collected WRITE addr=0x1184 data=0x11 |
| 8850 | hbus driver | Executed READ  addr=0x1184 data=0x11 |
| 8855 | hbus monitor | Collected READ  addr=0x1184 data=0x11 |
| 8880 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 8885 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8900 | hbus driver | Executed WRITE addr=0x1117 data=0x82 |
| 8905 | hbus monitor | Collected WRITE addr=0x1117 data=0x82 |
| 8930 | hbus driver | Executed READ  addr=0x1117 data=0x82 |
| 8935 | hbus monitor | Collected READ  addr=0x1117 data=0x82 |
| 8960 | hbus driver | Executed READ  addr=0x10f8 data=0x00 |
| 8960 | **test** | STAGE: burst 3/7: ctrl=0x7e (maxpktsize 62) en=0x1b (router on, counter enables 0001101), 9 packet(s) |
| 8960 | yapp driver | TX pkt #19: addr=2 len=53 parity=bad delay=2 |
| 8965 | hbus monitor | Collected READ  addr=0x10f8 data=0x00 |
| 8970 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8995 | **DUT** | IN  pkt #19 header: addr=2 len=53 -> channel 2 |
| 9005 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=53 (receiver waited 0 cycle(s)) |
| 9535 | **DUT** | IN  pkt #19 complete: addr=2 len=53 parity=BAD forwarded, 55 bytes in 55 cycles (held 0) |
| 9535 | yapp monitor | RX pkt #19 on the input: addr=2 len=53 parity=bad gap=31 |
| 9535 | reference | Packet forwarded: addr=2 len=53 -> channel 2 |
| 9540 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9540 | yapp driver | TX pkt #19 accepted by the DUT |
| 9540 | yapp driver | TX pkt #20: addr=0 len=54 parity=good delay=2 |
| 9555 | **DUT** | OUT ch2 pkt #5 done: 55 bytes in 56 cycles |
| 9555 | ch2 monitor | ch2 RX pkt #5: addr=2 len=53 parity=bad |
| 9555 | scoreboard | ch2 pkt matched: addr=2 len=53 (10 matched so far) |
| 9565 | **DUT** | IN  pkt #20 header: addr=0 len=54 -> channel 0 |
| 9575 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=54 (receiver waited 0 cycle(s)) |
| 9590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 9590 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 9590 | ch2 driver | ch2: packet consumed (response delay 0) |
| 10115 | **DUT** | IN  pkt #20 complete: addr=0 len=54 parity=ok forwarded, 56 bytes in 56 cycles (held 0) |
| 10115 | yapp monitor | RX pkt #20 on the input: addr=0 len=54 parity=good gap=2 |
| 10115 | reference | Packet forwarded: addr=0 len=54 -> channel 0 |
| 10120 | ch0 driver | ch0: packet consumed (response delay 0) |
| 10120 | yapp driver | TX pkt #20 accepted by the DUT |
| 10120 | yapp driver | TX pkt #21: addr=2 len=63 parity=good delay=0 |
| 10125 | **DUT** | IN  pkt #21 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 10175 | **DUT** | OUT ch0 pkt #5 done: 56 bytes in 61 cycles |
| 10175 | ch0 monitor | ch0 RX pkt #5: addr=0 len=54 parity=good |
| 10175 | scoreboard | ch0 pkt matched: addr=0 len=54 (11 matched so far) |
| 10610 | ch0 driver | ch0: packet consumed (response delay 4) |
| 10765 | **DUT** | IN  pkt #21 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10765 | yapp monitor | RX pkt #21 on the input: addr=2 len=63 parity=good gap=0 |
| 10765 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 10765 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10770 | yapp driver | TX pkt #21 accepted by the DUT |
| 10770 | yapp driver | TX pkt #22: addr=2 len=23 parity=good delay=0 |
| 10775 | **DUT** | IN  pkt #22 header: addr=2 len=23 -> channel 2 |
| 10785 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=23 (receiver waited 0 cycle(s)) |
| 11015 | **DUT** | IN  pkt #22 complete: addr=2 len=23 parity=ok forwarded, 25 bytes in 25 cycles (held 0) |
| 11015 | yapp monitor | RX pkt #22 on the input: addr=2 len=23 parity=good gap=0 |
| 11015 | reference | Packet forwarded: addr=2 len=23 -> channel 2 |
| 11020 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11020 | yapp driver | TX pkt #22 accepted by the DUT |
| 11020 | yapp driver | TX pkt #23: addr=0 len=62 parity=good delay=1 |
| 11035 | **DUT** | IN  pkt #23 header: addr=0 len=62 -> channel 0 |
| 11035 | **DUT** | OUT ch2 pkt #6 done: 25 bytes in 26 cycles |
| 11035 | ch2 monitor | ch2 RX pkt #6: addr=2 len=23 parity=good |
| 11035 | scoreboard | ch2 pkt matched: addr=2 len=23 (12 matched so far) |
| 11055 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=62 (receiver waited 1 cycle(s)) |
| 11360 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11665 | **DUT** | IN  pkt #23 complete: addr=0 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 11665 | yapp monitor | RX pkt #23 on the input: addr=0 len=62 parity=good gap=1 |
| 11665 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 11670 | yapp driver | TX pkt #23 accepted by the DUT |
| 11670 | yapp driver | TX pkt #24: addr=2 len=32 parity=good delay=0 |
| 11675 | **DUT** | IN  pkt #24 header: addr=2 len=32 -> channel 2 |
| 11680 | ch0 driver | ch0: packet consumed (response delay 1) |
| 11685 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=32 (receiver waited 0 cycle(s)) |
| 11795 | **DUT** | OUT ch0 pkt #6 done: 64 bytes in 75 cycles |
| 11795 | ch0 monitor | ch0 RX pkt #6: addr=0 len=62 parity=good |
| 11795 | scoreboard | ch0 pkt matched: addr=0 len=62 (13 matched so far) |
| 12005 | **DUT** | IN  pkt #24 complete: addr=2 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 12005 | yapp monitor | RX pkt #24 on the input: addr=2 len=32 parity=good gap=0 |
| 12005 | reference | Packet forwarded: addr=2 len=32 -> channel 2 |
| 12010 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12010 | yapp driver | TX pkt #24 accepted by the DUT |
| 12010 | yapp driver | TX pkt #25: addr=2 len=63 parity=good delay=0 |
| 12015 | **DUT** | IN  pkt #25 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 12025 | **DUT** | OUT ch2 pkt #7 done: 34 bytes in 35 cycles |
| 12025 | ch2 monitor | ch2 RX pkt #7: addr=2 len=32 parity=good |
| 12025 | scoreboard | ch2 pkt matched: addr=2 len=32 (14 matched so far) |
| 12190 | ch0 driver | ch0: packet consumed (response delay 10) |
| 12440 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12655 | **DUT** | IN  pkt #25 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12655 | yapp monitor | RX pkt #25 on the input: addr=2 len=63 parity=good gap=0 |
| 12655 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 12655 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 12660 | yapp driver | TX pkt #25 accepted by the DUT |
| 12660 | yapp driver | TX pkt #26: addr=2 len=63 parity=good delay=0 |
| 12665 | **DUT** | IN  pkt #26 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 13305 | **DUT** | IN  pkt #26 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 13305 | yapp monitor | RX pkt #26 on the input: addr=2 len=63 parity=good gap=0 |
| 13305 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 13305 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 13310 | yapp driver | TX pkt #26 accepted by the DUT |
| 13310 | yapp driver | TX pkt #27: addr=1 len=29 parity=good delay=0 |
| 13315 | **DUT** | IN  pkt #27 header: addr=1 len=29 -> channel 1 |
| 13475 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0x65 held (pkt #27) |
| 13655 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=29 (receiver waited 33 cycle(s)) |
| 13665 | **DUT** | SUSPEND released after 19 cycle(s) |
| 13805 | **DUT** | IN  pkt #27 complete: addr=1 len=29 parity=ok forwarded, 31 bytes in 50 cycles (held 19) |
| 13805 | yapp monitor | RX pkt #27 on the input: addr=1 len=29 parity=good gap=0 |
| 13805 | reference | Packet forwarded: addr=1 len=29 -> channel 1 |
| 13810 | yapp driver | TX pkt #27 accepted by the DUT |
| 13810 | **test** | STAGE: burst 3/7 sent: addr0..3 2/1/6/0, bad parity 1, gap 0 6, length 23..63 |
| 13830 | hbus driver | Executed WRITE addr=0x1000 data=0xc3 |
| 13835 | **DUT** | CONFIG router_en=1 maxpktsize=3 |
| 13835 | hbus monitor | Collected WRITE addr=0x1000 data=0xc3 |
| 13835 | reference | maxpktsize is now 3 |
| 13850 | hbus driver | Executed WRITE addr=0x1001 data=0xdf |
| 13855 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 13855 | reference | router_en is now 1 (en_reg 0xdf) |
| 13880 | hbus driver | Executed READ  addr=0x1060 data=0x00 |
| 13885 | hbus monitor | Collected READ  addr=0x1060 data=0x00 |
| 13910 | hbus driver | Executed READ  addr=0x100d data=0x1d |
| 13915 | hbus monitor | Collected READ  addr=0x100d data=0x1d |
| 13930 | hbus driver | Executed WRITE addr=0x1150 data=0x03 |
| 13935 | hbus monitor | Collected WRITE addr=0x1150 data=0x03 |
| 13950 | ch1 driver | ch1: packet consumed (response delay 33) |
| 13960 | hbus driver | Executed READ  addr=0x1150 data=0x03 |
| 13965 | hbus monitor | Collected READ  addr=0x1150 data=0x03 |
| 13980 | hbus driver | Executed WRITE addr=0x112f data=0x8b |
| 13985 | hbus monitor | Collected WRITE addr=0x112f data=0x8b |
| 14010 | hbus driver | Executed READ  addr=0x112f data=0x8b |
| 14015 | hbus monitor | Collected READ  addr=0x112f data=0x8b |
| 14040 | hbus driver | Executed READ  addr=0x100d data=0x1d |
| 14045 | hbus monitor | Collected READ  addr=0x100d data=0x1d |
| 14060 | hbus driver | Executed WRITE addr=0x1171 data=0x9a |
| 14065 | hbus monitor | Collected WRITE addr=0x1171 data=0x9a |
| 14090 | hbus driver | Executed READ  addr=0x1171 data=0x9a |
| 14095 | hbus monitor | Collected READ  addr=0x1171 data=0x9a |
| 14110 | hbus driver | Executed WRITE addr=0x1130 data=0x44 |
| 14115 | hbus monitor | Collected WRITE addr=0x1130 data=0x44 |
| 14140 | hbus driver | Executed READ  addr=0x1130 data=0x44 |
| 14145 | hbus monitor | Collected READ  addr=0x1130 data=0x44 |
| 14170 | hbus driver | Executed READ  addr=0x102e data=0x1a |
| 14170 | **test** | STAGE: burst 4/7: ctrl=0xc3 (maxpktsize 3) en=0xdf (router on, counter enables 1101111), 8 packet(s) |
| 14170 | yapp driver | TX pkt #28: addr=0 len=38 parity=bad delay=18 |
| 14175 | hbus monitor | Collected READ  addr=0x102e data=0x1a |
| 14365 | **DUT** | IN  pkt #28 header: addr=0 len=38 -> DROP (oversized: len 38 > maxpktsize 3) |
| 14365 | **DUT** | OUT ch1 pkt #2 done: 31 bytes in 72 cycles |
| 14365 | ch1 monitor | ch1 RX pkt #2: addr=1 len=29 parity=good |
| 14365 | scoreboard | ch1 pkt matched: addr=1 len=29 (15 matched so far) |
| 14400 | ch1 driver | ch1: packet consumed (response delay 40) |
| 14755 | **DUT** | IN  pkt #28 complete: addr=0 len=38 parity=BAD dropped, 40 bytes in 40 cycles (held 0) |
| 14755 | yapp monitor | RX pkt #28 on the input: addr=0 len=38 parity=bad gap=55 |
| 14755 | reference | Packet dropped: length 38 > maxpktsize 3 (addr=0) |
| 14755 | **DUT** | ROUTER DROPS PACKET addr=0 length=38 (length > maxpktsize) |
| 14760 | yapp driver | TX pkt #28 accepted by the DUT |
| 14760 | yapp driver | TX pkt #29: addr=2 len=63 parity=good delay=20 |
| 14810 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 14810 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 14965 | **DUT** | IN  pkt #29 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 15605 | **DUT** | IN  pkt #29 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 15605 | yapp monitor | RX pkt #29 on the input: addr=2 len=63 parity=good gap=20 |
| 15605 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=2) |
| 15605 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 15610 | yapp driver | TX pkt #29 accepted by the DUT |
| 15610 | yapp driver | TX pkt #30: addr=0 len=57 parity=good delay=3 |
| 15645 | **DUT** | IN  pkt #30 header: addr=0 len=57 -> DROP (oversized: len 57 > maxpktsize 3) |
| 16225 | **DUT** | IN  pkt #30 complete: addr=0 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 16225 | yapp monitor | RX pkt #30 on the input: addr=0 len=57 parity=good gap=3 |
| 16225 | reference | Packet dropped: length 57 > maxpktsize 3 (addr=0) |
| 16225 | **DUT** | ROUTER DROPS PACKET addr=0 length=57 (length > maxpktsize) |
| 16230 | yapp driver | TX pkt #30 accepted by the DUT |
| 16230 | yapp driver | TX pkt #31: addr=2 len=4 parity=good delay=1 |
| 16245 | **DUT** | IN  pkt #31 header: addr=2 len=4 -> DROP (oversized: len 4 > maxpktsize 3) |
| 16295 | **DUT** | IN  pkt #31 complete: addr=2 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 16295 | yapp monitor | RX pkt #31 on the input: addr=2 len=4 parity=good gap=1 |
| 16295 | reference | Packet dropped: length 4 > maxpktsize 3 (addr=2) |
| 16295 | **DUT** | ROUTER DROPS PACKET addr=2 length=4 (length > maxpktsize) |
| 16300 | yapp driver | TX pkt #31 accepted by the DUT |
| 16300 | yapp driver | TX pkt #32: addr=0 len=2 parity=good delay=6 |
| 16365 | **DUT** | IN  pkt #32 header: addr=0 len=2 -> channel 0 |
| 16375 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 16395 | **DUT** | IN  pkt #32 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 16395 | yapp monitor | RX pkt #32 on the input: addr=0 len=2 parity=good gap=6 |
| 16395 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 16400 | ch0 driver | ch0: packet consumed (response delay 0) |
| 16400 | yapp driver | TX pkt #32 accepted by the DUT |
| 16400 | yapp driver | TX pkt #33: addr=0 len=63 parity=good delay=1 |
| 16415 | **DUT** | IN  pkt #33 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 16455 | **DUT** | OUT ch0 pkt #7 done: 4 bytes in 9 cycles |
| 16455 | ch0 monitor | ch0 RX pkt #7: addr=0 len=2 parity=good |
| 16455 | scoreboard | ch0 pkt matched: addr=0 len=2 (16 matched so far) |
| 16900 | ch0 driver | ch0: packet consumed (response delay 4) |
| 17055 | **DUT** | IN  pkt #33 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 17055 | yapp monitor | RX pkt #33 on the input: addr=0 len=63 parity=good gap=1 |
| 17055 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=0) |
| 17055 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 17060 | yapp driver | TX pkt #33 accepted by the DUT |
| 17060 | yapp driver | TX pkt #34: addr=3 len=8 parity=good delay=19 |
| 17255 | **DUT** | IN  pkt #34 header: addr=3 len=8 -> DROP (oversized: len 8 > maxpktsize 3) |
| 17345 | **DUT** | IN  pkt #34 complete: addr=3 len=8 parity=ok dropped, 10 bytes in 10 cycles (held 0) |
| 17345 | yapp monitor | RX pkt #34 on the input: addr=3 len=8 parity=good gap=19 |
| 17345 | reference | Packet dropped: illegal address 3 (len=8) |
| 17345 | **DUT** | ROUTER DROPS PACKET addr=3 length=8 (    illegal address) |
| 17350 | yapp driver | TX pkt #34 accepted by the DUT |
| 17350 | yapp driver | TX pkt #35: addr=3 len=60 parity=good delay=5 |
| 17405 | **DUT** | IN  pkt #35 header: addr=3 len=60 -> DROP (oversized: len 60 > maxpktsize 3) |
| 18015 | **DUT** | IN  pkt #35 complete: addr=3 len=60 parity=ok dropped, 62 bytes in 62 cycles (held 0) |
| 18015 | yapp monitor | RX pkt #35 on the input: addr=3 len=60 parity=good gap=5 |
| 18015 | reference | Packet dropped: illegal address 3 (len=60) |
| 18015 | **DUT** | ROUTER DROPS PACKET addr=3 length=60 (    illegal address) |
| 18020 | yapp driver | TX pkt #35 accepted by the DUT |
| 18020 | **test** | STAGE: burst 4/7 sent: addr0..3 4/0/2/2, bad parity 1, gap 0 0, length 2..63 |
| 18040 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 18045 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 18045 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 18045 | reference | maxpktsize is now 62 |
| 18060 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 18065 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 18065 | reference | router_en is now 1 (en_reg 0x01) |
| 18080 | hbus driver | Executed WRITE addr=0x115b data=0x44 |
| 18085 | hbus monitor | Collected WRITE addr=0x115b data=0x44 |
| 18110 | hbus driver | Executed READ  addr=0x115b data=0x44 |
| 18115 | hbus monitor | Collected READ  addr=0x115b data=0x44 |
| 18140 | hbus driver | Executed READ  addr=0x1013 data=0x09 |
| 18145 | hbus monitor | Collected READ  addr=0x1013 data=0x09 |
| 18170 | hbus driver | Executed READ  addr=0x108b data=0x00 |
| 18175 | hbus monitor | Collected READ  addr=0x108b data=0x00 |
| 18190 | hbus driver | Executed WRITE addr=0x11c9 data=0x40 |
| 18195 | hbus monitor | Collected WRITE addr=0x11c9 data=0x40 |
| 18220 | hbus driver | Executed READ  addr=0x11c9 data=0x40 |
| 18225 | hbus monitor | Collected READ  addr=0x11c9 data=0x40 |
| 18250 | hbus driver | Executed READ  addr=0x1005 data=0x07 |
| 18255 | hbus monitor | Collected READ  addr=0x1005 data=0x07 |
| 18280 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 18280 | **test** | STAGE: burst 5/7: ctrl=0x3e (maxpktsize 62) en=0x01 (router on, counter enables 0000000), 8 packet(s) |
| 18280 | yapp driver | TX pkt #36: addr=3 len=1 parity=good delay=1 |
| 18285 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 18305 | **DUT** | IN  pkt #36 header: addr=3 len=1 -> DROP (illegal address 3) |
| 18325 | **DUT** | IN  pkt #36 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 18325 | yapp monitor | RX pkt #36 on the input: addr=3 len=1 parity=good gap=28 |
| 18325 | reference | Packet dropped: illegal address 3 (len=1) |
| 18325 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 18330 | yapp driver | TX pkt #36 accepted by the DUT |
| 18330 | yapp driver | TX pkt #37: addr=0 len=63 parity=good delay=16 |
| 18495 | **DUT** | IN  pkt #37 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 19135 | **DUT** | IN  pkt #37 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 19135 | yapp monitor | RX pkt #37 on the input: addr=0 len=63 parity=good gap=16 |
| 19135 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 19135 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 19140 | yapp driver | TX pkt #37 accepted by the DUT |
| 19140 | yapp driver | TX pkt #38: addr=2 len=40 parity=good delay=19 |
| 19335 | **DUT** | IN  pkt #38 header: addr=2 len=40 -> channel 2 |
| 19345 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=40 (receiver waited 0 cycle(s)) |
| 19745 | **DUT** | IN  pkt #38 complete: addr=2 len=40 parity=ok forwarded, 42 bytes in 42 cycles (held 0) |
| 19745 | yapp monitor | RX pkt #38 on the input: addr=2 len=40 parity=good gap=19 |
| 19745 | reference | Packet forwarded: addr=2 len=40 -> channel 2 |
| 19750 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19750 | yapp driver | TX pkt #38 accepted by the DUT |
| 19750 | yapp driver | TX pkt #39: addr=0 len=51 parity=good delay=3 |
| 19765 | **DUT** | OUT ch2 pkt #8 done: 42 bytes in 43 cycles |
| 19765 | ch2 monitor | ch2 RX pkt #8: addr=2 len=40 parity=good |
| 19765 | scoreboard | ch2 pkt matched: addr=2 len=40 (17 matched so far) |
| 19785 | **DUT** | IN  pkt #39 header: addr=0 len=51 -> channel 0 |
| 19895 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=51 (receiver waited 10 cycle(s)) |
| 20070 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20305 | **DUT** | IN  pkt #39 complete: addr=0 len=51 parity=ok forwarded, 53 bytes in 53 cycles (held 0) |
| 20305 | yapp monitor | RX pkt #39 on the input: addr=0 len=51 parity=good gap=3 |
| 20305 | reference | Packet forwarded: addr=0 len=51 -> channel 0 |
| 20310 | yapp driver | TX pkt #39 accepted by the DUT |
| 20310 | yapp driver | TX pkt #40: addr=1 len=63 parity=good delay=3 |
| 20345 | **DUT** | IN  pkt #40 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 20410 | ch0 driver | ch0: packet consumed (response delay 10) |
| 20435 | **DUT** | OUT ch0 pkt #8 done: 53 bytes in 55 cycles |
| 20435 | ch0 monitor | ch0 RX pkt #8: addr=0 len=51 parity=good |
| 20435 | scoreboard | ch0 pkt matched: addr=0 len=51 (18 matched so far) |
| 20680 | ch0 driver | ch0: packet consumed (response delay 1) |
| 20985 | **DUT** | IN  pkt #40 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 20985 | yapp monitor | RX pkt #40 on the input: addr=1 len=63 parity=good gap=3 |
| 20985 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 20985 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 20990 | yapp driver | TX pkt #40 accepted by the DUT |
| 20990 | yapp driver | TX pkt #41: addr=0 len=61 parity=good delay=0 |
| 20995 | **DUT** | IN  pkt #41 header: addr=0 len=61 -> channel 0 |
| 21065 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=61 (receiver waited 6 cycle(s)) |
| 21615 | **DUT** | IN  pkt #41 complete: addr=0 len=61 parity=ok forwarded, 63 bytes in 63 cycles (held 0) |
| 21615 | yapp monitor | RX pkt #41 on the input: addr=0 len=61 parity=good gap=0 |
| 21615 | reference | Packet forwarded: addr=0 len=61 -> channel 0 |
| 21620 | yapp driver | TX pkt #41 accepted by the DUT |
| 21620 | yapp driver | TX pkt #42: addr=1 len=63 parity=good delay=20 |
| 21680 | ch0 driver | ch0: packet consumed (response delay 6) |
| 21795 | **DUT** | OUT ch0 pkt #9 done: 63 bytes in 74 cycles |
| 21795 | ch0 monitor | ch0 RX pkt #9: addr=0 len=61 parity=good |
| 21795 | scoreboard | ch0 pkt matched: addr=0 len=61 (19 matched so far) |
| 21825 | **DUT** | IN  pkt #42 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 22290 | ch0 driver | ch0: packet consumed (response delay 10) |
| 22465 | **DUT** | IN  pkt #42 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 22465 | yapp monitor | RX pkt #42 on the input: addr=1 len=63 parity=good gap=20 |
| 22465 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 22465 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 22470 | yapp driver | TX pkt #42 accepted by the DUT |
| 22470 | yapp driver | TX pkt #43: addr=0 len=63 parity=bad delay=20 |
| 22675 | **DUT** | IN  pkt #43 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 23315 | **DUT** | IN  pkt #43 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 23315 | yapp monitor | RX pkt #43 on the input: addr=0 len=63 parity=bad gap=20 |
| 23315 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 23315 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 23320 | yapp driver | TX pkt #43 accepted by the DUT |
| 23320 | **test** | STAGE: burst 5/7 sent: addr0..3 4/2/1/1, bad parity 1, gap 0 1, length 1..63 |
| 23340 | hbus driver | Executed WRITE addr=0x1000 data=0x03 |
| 23345 | **DUT** | CONFIG router_en=1 maxpktsize=3 |
| 23345 | hbus monitor | Collected WRITE addr=0x1000 data=0x03 |
| 23345 | reference | maxpktsize is now 3 |
| 23360 | hbus driver | Executed WRITE addr=0x1001 data=0xd9 |
| 23365 | hbus monitor | Collected WRITE addr=0x1001 data=0xd9 |
| 23365 | reference | router_en is now 1 (en_reg 0xd9) |
| 23380 | hbus driver | Executed WRITE addr=0x11d9 data=0x38 |
| 23385 | hbus monitor | Collected WRITE addr=0x11d9 data=0x38 |
| 23390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 23390 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 23410 | hbus driver | Executed READ  addr=0x11d9 data=0x38 |
| 23415 | hbus monitor | Collected READ  addr=0x11d9 data=0x38 |
| 23440 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 23445 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23460 | hbus driver | Executed WRITE addr=0x1166 data=0x50 |
| 23465 | hbus monitor | Collected WRITE addr=0x1166 data=0x50 |
| 23490 | hbus driver | Executed READ  addr=0x1166 data=0x50 |
| 23495 | hbus monitor | Collected READ  addr=0x1166 data=0x50 |
| 23520 | hbus driver | Executed READ  addr=0x1009 data=0x06 |
| 23525 | hbus monitor | Collected READ  addr=0x1009 data=0x06 |
| 23540 | hbus driver | Executed WRITE addr=0x1182 data=0xf6 |
| 23545 | hbus monitor | Collected WRITE addr=0x1182 data=0xf6 |
| 23570 | hbus driver | Executed READ  addr=0x1182 data=0xf6 |
| 23575 | hbus monitor | Collected READ  addr=0x1182 data=0xf6 |
| 23590 | hbus driver | Executed WRITE addr=0x113d data=0x28 |
| 23595 | hbus monitor | Collected WRITE addr=0x113d data=0x28 |
| 23620 | hbus driver | Executed READ  addr=0x113d data=0x28 |
| 23625 | hbus monitor | Collected READ  addr=0x113d data=0x28 |
| 23650 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 23655 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23670 | hbus driver | Executed WRITE addr=0x115f data=0xcc |
| 23675 | hbus monitor | Collected WRITE addr=0x115f data=0xcc |
| 23700 | hbus driver | Executed READ  addr=0x115f data=0xcc |
| 23705 | hbus monitor | Collected READ  addr=0x115f data=0xcc |
| 23720 | hbus driver | Executed WRITE addr=0x1159 data=0xb3 |
| 23725 | hbus monitor | Collected WRITE addr=0x1159 data=0xb3 |
| 23750 | hbus driver | Executed READ  addr=0x1159 data=0xb3 |
| 23755 | hbus monitor | Collected READ  addr=0x1159 data=0xb3 |
| 23770 | hbus driver | Executed WRITE addr=0x110f data=0x42 |
| 23775 | hbus monitor | Collected WRITE addr=0x110f data=0x42 |
| 23800 | hbus driver | Executed READ  addr=0x110f data=0x42 |
| 23800 | **test** | STAGE: burst 6/7: ctrl=0x03 (maxpktsize 3) en=0xd9 (router on, counter enables 1101100), 10 packet(s) |
| 23800 | yapp driver | TX pkt #44: addr=0 len=63 parity=bad delay=6 |
| 23805 | hbus monitor | Collected READ  addr=0x110f data=0x42 |
| 23875 | **DUT** | IN  pkt #44 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 24515 | **DUT** | IN  pkt #44 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 24515 | yapp monitor | RX pkt #44 on the input: addr=0 len=63 parity=bad gap=55 |
| 24515 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=0) |
| 24515 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 24520 | yapp driver | TX pkt #44 accepted by the DUT |
| 24520 | yapp driver | TX pkt #45: addr=3 len=34 parity=good delay=6 |
| 24570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 24570 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 24585 | **DUT** | IN  pkt #45 header: addr=3 len=34 -> DROP (oversized: len 34 > maxpktsize 3) |
| 24935 | **DUT** | IN  pkt #45 complete: addr=3 len=34 parity=ok dropped, 36 bytes in 36 cycles (held 0) |
| 24935 | yapp monitor | RX pkt #45 on the input: addr=3 len=34 parity=good gap=6 |
| 24935 | reference | Packet dropped: illegal address 3 (len=34) |
| 24935 | **DUT** | ROUTER DROPS PACKET addr=3 length=34 (    illegal address) |
| 24940 | yapp driver | TX pkt #45 accepted by the DUT |
| 24940 | yapp driver | TX pkt #46: addr=1 len=1 parity=bad delay=0 |
| 24945 | **DUT** | IN  pkt #46 header: addr=1 len=1 -> channel 1 |
| 24965 | **DUT** | IN  pkt #46 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 24965 | yapp monitor | RX pkt #46 on the input: addr=1 len=1 parity=bad gap=0 |
| 24965 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 24970 | yapp driver | TX pkt #46 accepted by the DUT |
| 24970 | yapp driver | TX pkt #47: addr=1 len=38 parity=good delay=1 |
| 24985 | **DUT** | IN  pkt #47 header: addr=1 len=38 -> DROP (oversized: len 38 > maxpktsize 3) |
| 24990 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 24990 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 25165 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 21 cycle(s)) |
| 25180 | ch1 driver | ch1: packet consumed (response delay 21) |
| 25375 | **DUT** | IN  pkt #47 complete: addr=1 len=38 parity=ok dropped, 40 bytes in 40 cycles (held 0) |
| 25375 | yapp monitor | RX pkt #47 on the input: addr=1 len=38 parity=good gap=1 |
| 25375 | reference | Packet dropped: length 38 > maxpktsize 3 (addr=1) |
| 25375 | **DUT** | ROUTER DROPS PACKET addr=1 length=38 (length > maxpktsize) |
| 25380 | yapp driver | TX pkt #47 accepted by the DUT |
| 25380 | yapp driver | TX pkt #48: addr=1 len=3 parity=good delay=3 |
| 25415 | **DUT** | IN  pkt #48 header: addr=1 len=3 -> channel 1 |
| 25455 | **DUT** | IN  pkt #48 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 25455 | yapp monitor | RX pkt #48 on the input: addr=1 len=3 parity=good gap=3 |
| 25455 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 25460 | yapp driver | TX pkt #48 accepted by the DUT |
| 25460 | yapp driver | TX pkt #49: addr=2 len=63 parity=good delay=1 |
| 25475 | **DUT** | IN  pkt #49 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 25545 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 39 cycles |
| 25545 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=bad |
| 25545 | scoreboard | ch1 pkt matched: addr=1 len=1 (20 matched so far) |
| 25555 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 25595 | **DUT** | OUT ch1 pkt #4 done: 5 bytes in 5 cycles |
| 25595 | ch1 monitor | ch1 RX pkt #4: addr=1 len=3 parity=good |
| 25595 | scoreboard | ch1 pkt matched: addr=1 len=3 (21 matched so far) |
| 25760 | ch1 driver | ch1: packet consumed (response delay 35) |
| 26115 | **DUT** | IN  pkt #49 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 26115 | yapp monitor | RX pkt #49 on the input: addr=2 len=63 parity=good gap=1 |
| 26115 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=2) |
| 26115 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 26120 | yapp driver | TX pkt #49 accepted by the DUT |
| 26120 | yapp driver | TX pkt #50: addr=2 len=4 parity=good delay=19 |
| 26315 | **DUT** | IN  pkt #50 header: addr=2 len=4 -> DROP (oversized: len 4 > maxpktsize 3) |
| 26365 | **DUT** | IN  pkt #50 complete: addr=2 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 26365 | yapp monitor | RX pkt #50 on the input: addr=2 len=4 parity=good gap=19 |
| 26365 | reference | Packet dropped: length 4 > maxpktsize 3 (addr=2) |
| 26365 | **DUT** | ROUTER DROPS PACKET addr=2 length=4 (length > maxpktsize) |
| 26370 | yapp driver | TX pkt #50 accepted by the DUT |
| 26370 | yapp driver | TX pkt #51: addr=2 len=63 parity=bad delay=0 |
| 26375 | **DUT** | IN  pkt #51 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 27015 | **DUT** | IN  pkt #51 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 27015 | yapp monitor | RX pkt #51 on the input: addr=2 len=63 parity=bad gap=0 |
| 27015 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=2) |
| 27015 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 27020 | yapp driver | TX pkt #51 accepted by the DUT |
| 27020 | yapp driver | TX pkt #52: addr=2 len=2 parity=good delay=3 |
| 27055 | **DUT** | IN  pkt #52 header: addr=2 len=2 -> channel 2 |
| 27065 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 27085 | **DUT** | IN  pkt #52 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 27085 | yapp monitor | RX pkt #52 on the input: addr=2 len=2 parity=good gap=3 |
| 27085 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 27090 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27090 | yapp driver | TX pkt #52 accepted by the DUT |
| 27090 | yapp driver | TX pkt #53: addr=0 len=63 parity=good delay=1 |
| 27105 | **DUT** | IN  pkt #53 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 27105 | **DUT** | OUT ch2 pkt #9 done: 4 bytes in 5 cycles |
| 27105 | ch2 monitor | ch2 RX pkt #9: addr=2 len=2 parity=good |
| 27105 | scoreboard | ch2 pkt matched: addr=2 len=2 (22 matched so far) |
| 27110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 27110 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 27340 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27745 | **DUT** | IN  pkt #53 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 27745 | yapp monitor | RX pkt #53 on the input: addr=0 len=63 parity=good gap=1 |
| 27745 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=0) |
| 27745 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 27750 | yapp driver | TX pkt #53 accepted by the DUT |
| 27750 | **test** | STAGE: burst 6/7 sent: addr0..3 2/3/4/1, bad parity 3, gap 0 2, length 1..63 |
| 27770 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 27775 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 27775 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 27775 | reference | maxpktsize is now 0 |
| 27790 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 27795 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 27795 | reference | router_en is now 1 (en_reg 0xff) |
| 27810 | hbus driver | Executed WRITE addr=0x1123 data=0x9f |
| 27815 | hbus monitor | Collected WRITE addr=0x1123 data=0x9f |
| 27840 | hbus driver | Executed READ  addr=0x1123 data=0x9f |
| 27845 | hbus monitor | Collected READ  addr=0x1123 data=0x9f |
| 27870 | hbus driver | Executed READ  addr=0x1035 data=0xa4 |
| 27875 | hbus monitor | Collected READ  addr=0x1035 data=0xa4 |
| 27890 | hbus driver | Executed WRITE addr=0x1123 data=0x62 |
| 27895 | hbus monitor | Collected WRITE addr=0x1123 data=0x62 |
| 27920 | hbus driver | Executed READ  addr=0x1123 data=0x62 |
| 27925 | hbus monitor | Collected READ  addr=0x1123 data=0x62 |
| 27950 | hbus driver | Executed READ  addr=0x1013 data=0x66 |
| 27955 | hbus monitor | Collected READ  addr=0x1013 data=0x66 |
| 27970 | hbus driver | Executed WRITE addr=0x1169 data=0x55 |
| 27975 | hbus monitor | Collected WRITE addr=0x1169 data=0x55 |
| 28000 | hbus driver | Executed READ  addr=0x1169 data=0x55 |
| 28005 | hbus monitor | Collected READ  addr=0x1169 data=0x55 |
| 28030 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 28035 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 28060 | hbus driver | Executed READ  addr=0x1047 data=0x05 |
| 28065 | hbus monitor | Collected READ  addr=0x1047 data=0x05 |
| 28080 | hbus driver | Executed WRITE addr=0x111e data=0x83 |
| 28085 | hbus monitor | Collected WRITE addr=0x111e data=0x83 |
| 28110 | hbus driver | Executed READ  addr=0x111e data=0x83 |
| 28115 | hbus monitor | Collected READ  addr=0x111e data=0x83 |
| 28130 | hbus driver | Executed WRITE addr=0x11b9 data=0xb9 |
| 28135 | hbus monitor | Collected WRITE addr=0x11b9 data=0xb9 |
| 28160 | hbus driver | Executed READ  addr=0x11b9 data=0xb9 |
| 28165 | hbus monitor | Collected READ  addr=0x11b9 data=0xb9 |
| 28180 | hbus driver | Executed WRITE addr=0x11f7 data=0xf8 |
| 28185 | hbus monitor | Collected WRITE addr=0x11f7 data=0xf8 |
| 28210 | hbus driver | Executed READ  addr=0x11f7 data=0xf8 |
| 28210 | **test** | STAGE: burst 7/7: ctrl=0x00 (maxpktsize 0) en=0xff (router on, counter enables 1111111), 8 packet(s) |
| 28210 | yapp driver | TX pkt #54: addr=2 len=15 parity=bad delay=2 |
| 28215 | hbus monitor | Collected READ  addr=0x11f7 data=0xf8 |
| 28245 | **DUT** | IN  pkt #54 header: addr=2 len=15 -> DROP (oversized: len 15 > maxpktsize 0) |
| 28405 | **DUT** | IN  pkt #54 complete: addr=2 len=15 parity=BAD dropped, 17 bytes in 17 cycles (held 0) |
| 28405 | yapp monitor | RX pkt #54 on the input: addr=2 len=15 parity=bad gap=49 |
| 28405 | reference | Packet dropped: length 15 > maxpktsize 0 (addr=2) |
| 28405 | **DUT** | ROUTER DROPS PACKET addr=2 length=15 (length > maxpktsize) |
| 28410 | yapp driver | TX pkt #54 accepted by the DUT |
| 28410 | yapp driver | TX pkt #55: addr=2 len=1 parity=good delay=1 |
| 28425 | **DUT** | IN  pkt #55 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 28445 | **DUT** | IN  pkt #55 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 28445 | yapp monitor | RX pkt #55 on the input: addr=2 len=1 parity=good gap=1 |
| 28445 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 28445 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 28450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 28450 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 28450 | yapp driver | TX pkt #55 accepted by the DUT |
| 28450 | yapp driver | TX pkt #56: addr=1 len=36 parity=good delay=1 |
| 28465 | **DUT** | IN  pkt #56 header: addr=1 len=36 -> DROP (oversized: len 36 > maxpktsize 0) |
| 28835 | **DUT** | IN  pkt #56 complete: addr=1 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 28835 | yapp monitor | RX pkt #56 on the input: addr=1 len=36 parity=good gap=1 |
| 28835 | reference | Packet dropped: length 36 > maxpktsize 0 (addr=1) |
| 28835 | **DUT** | ROUTER DROPS PACKET addr=1 length=36 (length > maxpktsize) |
| 28840 | yapp driver | TX pkt #56 accepted by the DUT |
| 28840 | yapp driver | TX pkt #57: addr=1 len=63 parity=good delay=1 |
| 28855 | **DUT** | IN  pkt #57 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 29495 | **DUT** | IN  pkt #57 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 29495 | yapp monitor | RX pkt #57 on the input: addr=1 len=63 parity=good gap=1 |
| 29495 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 29495 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 29500 | yapp driver | TX pkt #57 accepted by the DUT |
| 29500 | yapp driver | TX pkt #58: addr=1 len=1 parity=good delay=0 |
| 29505 | **DUT** | IN  pkt #58 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 29525 | **DUT** | IN  pkt #58 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 29525 | yapp monitor | RX pkt #58 on the input: addr=1 len=1 parity=good gap=0 |
| 29525 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 29525 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 29530 | yapp driver | TX pkt #58 accepted by the DUT |
| 29530 | yapp driver | TX pkt #59: addr=1 len=38 parity=good delay=2 |
| 29555 | **DUT** | IN  pkt #59 header: addr=1 len=38 -> DROP (oversized: len 38 > maxpktsize 0) |
| 29945 | **DUT** | IN  pkt #59 complete: addr=1 len=38 parity=ok dropped, 40 bytes in 40 cycles (held 0) |
| 29945 | yapp monitor | RX pkt #59 on the input: addr=1 len=38 parity=good gap=2 |
| 29945 | reference | Packet dropped: length 38 > maxpktsize 0 (addr=1) |
| 29945 | **DUT** | ROUTER DROPS PACKET addr=1 length=38 (length > maxpktsize) |
| 29950 | yapp driver | TX pkt #59 accepted by the DUT |
| 29950 | yapp driver | TX pkt #60: addr=2 len=63 parity=good delay=17 |
| 30125 | **DUT** | IN  pkt #60 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 30765 | **DUT** | IN  pkt #60 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 30765 | yapp monitor | RX pkt #60 on the input: addr=2 len=63 parity=good gap=17 |
| 30765 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 30765 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 30770 | yapp driver | TX pkt #60 accepted by the DUT |
| 30770 | yapp driver | TX pkt #61: addr=2 len=63 parity=good delay=1 |
| 30785 | **DUT** | IN  pkt #61 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 31425 | **DUT** | IN  pkt #61 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 31425 | yapp monitor | RX pkt #61 on the input: addr=2 len=63 parity=good gap=1 |
| 31425 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 31425 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 31430 | yapp driver | TX pkt #61 accepted by the DUT |
| 31430 | **test** | STAGE: burst 7/7 sent: addr0..3 0/4/4/0, bad parity 1, gap 0 1, length 1..63 |
| 31430 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 31460 | hbus driver | Executed READ  addr=0x1000 data=0x00 |
| 31465 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 31490 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 31495 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 31520 | hbus driver | Executed READ  addr=0x1004 data=0x03 |
| 31525 | hbus monitor | Collected READ  addr=0x1004 data=0x03 |
| 31550 | hbus driver | Executed READ  addr=0x1005 data=0x0f |
| 31555 | hbus monitor | Collected READ  addr=0x1005 data=0x0f |
| 31580 | hbus driver | Executed READ  addr=0x1006 data=0x03 |
| 31585 | hbus monitor | Collected READ  addr=0x1006 data=0x03 |
| 31610 | hbus driver | Executed READ  addr=0x1009 data=0x08 |
| 31615 | hbus monitor | Collected READ  addr=0x1009 data=0x08 |
| 31640 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 31645 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 31670 | hbus driver | Executed READ  addr=0x100b data=0x0a |
| 31675 | hbus monitor | Collected READ  addr=0x100b data=0x0a |
| 31700 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 31705 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 31730 | hbus driver | Executed READ  addr=0x1010 data=0xfe |
| 31735 | hbus monitor | Collected READ  addr=0x1010 data=0xfe |
| 31760 | hbus driver | Executed READ  addr=0x1011 data=0xee |
| 31765 | hbus monitor | Collected READ  addr=0x1011 data=0xee |
| 31790 | hbus driver | Executed READ  addr=0x1012 data=0x3d |
| 31795 | hbus monitor | Collected READ  addr=0x1012 data=0x3d |
| 31820 | hbus driver | Executed READ  addr=0x1013 data=0x38 |
| 31825 | hbus monitor | Collected READ  addr=0x1013 data=0x38 |
| 31850 | hbus driver | Executed READ  addr=0x1014 data=0x9f |
| 31855 | hbus monitor | Collected READ  addr=0x1014 data=0x9f |
| 31880 | hbus driver | Executed READ  addr=0x1015 data=0xde |
| 31885 | hbus monitor | Collected READ  addr=0x1015 data=0xde |
| 31910 | hbus driver | Executed READ  addr=0x1016 data=0xb2 |
| 31915 | hbus monitor | Collected READ  addr=0x1016 data=0xb2 |
| 31940 | hbus driver | Executed READ  addr=0x1017 data=0x23 |
| 31945 | hbus monitor | Collected READ  addr=0x1017 data=0x23 |
| 31970 | hbus driver | Executed READ  addr=0x1018 data=0xff |
| 31975 | hbus monitor | Collected READ  addr=0x1018 data=0xff |
| 32000 | hbus driver | Executed READ  addr=0x1019 data=0x90 |
| 32005 | hbus monitor | Collected READ  addr=0x1019 data=0x90 |
| 32030 | hbus driver | Executed READ  addr=0x101a data=0xed |
| 32035 | hbus monitor | Collected READ  addr=0x101a data=0xed |
| 32060 | hbus driver | Executed READ  addr=0x101b data=0xdb |
| 32065 | hbus monitor | Collected READ  addr=0x101b data=0xdb |
| 32090 | hbus driver | Executed READ  addr=0x101c data=0xc6 |
| 32095 | hbus monitor | Collected READ  addr=0x101c data=0xc6 |
| 32120 | hbus driver | Executed READ  addr=0x101d data=0x33 |
| 32125 | hbus monitor | Collected READ  addr=0x101d data=0x33 |
| 32150 | hbus driver | Executed READ  addr=0x101e data=0xa0 |
| 32155 | hbus monitor | Collected READ  addr=0x101e data=0xa0 |
| 32180 | hbus driver | Executed READ  addr=0x101f data=0x53 |
| 32185 | hbus monitor | Collected READ  addr=0x101f data=0x53 |
| 32210 | hbus driver | Executed READ  addr=0x1020 data=0x4a |
| 32215 | hbus monitor | Collected READ  addr=0x1020 data=0x4a |
| 32240 | hbus driver | Executed READ  addr=0x1021 data=0x62 |
| 32245 | hbus monitor | Collected READ  addr=0x1021 data=0x62 |
| 32270 | hbus driver | Executed READ  addr=0x1022 data=0x72 |
| 32275 | hbus monitor | Collected READ  addr=0x1022 data=0x72 |
| 32300 | hbus driver | Executed READ  addr=0x1023 data=0xaa |
| 32305 | hbus monitor | Collected READ  addr=0x1023 data=0xaa |
| 32330 | hbus driver | Executed READ  addr=0x1024 data=0xfd |
| 32335 | hbus monitor | Collected READ  addr=0x1024 data=0xfd |
| 32360 | hbus driver | Executed READ  addr=0x1025 data=0x74 |
| 32365 | hbus monitor | Collected READ  addr=0x1025 data=0x74 |
| 32390 | hbus driver | Executed READ  addr=0x1026 data=0xc5 |
| 32395 | hbus monitor | Collected READ  addr=0x1026 data=0xc5 |
| 32420 | hbus driver | Executed READ  addr=0x1027 data=0xf3 |
| 32425 | hbus monitor | Collected READ  addr=0x1027 data=0xf3 |
| 32450 | hbus driver | Executed READ  addr=0x1028 data=0xc6 |
| 32455 | hbus monitor | Collected READ  addr=0x1028 data=0xc6 |
| 32480 | hbus driver | Executed READ  addr=0x1029 data=0x45 |
| 32485 | hbus monitor | Collected READ  addr=0x1029 data=0x45 |
| 32510 | hbus driver | Executed READ  addr=0x102a data=0x90 |
| 32515 | hbus monitor | Collected READ  addr=0x102a data=0x90 |
| 32540 | hbus driver | Executed READ  addr=0x102b data=0x19 |
| 32545 | hbus monitor | Collected READ  addr=0x102b data=0x19 |
| 32570 | hbus driver | Executed READ  addr=0x102c data=0xb3 |
| 32575 | hbus monitor | Collected READ  addr=0x102c data=0xb3 |
| 32600 | hbus driver | Executed READ  addr=0x102d data=0x7d |
| 32605 | hbus monitor | Collected READ  addr=0x102d data=0x7d |
| 32630 | hbus driver | Executed READ  addr=0x102e data=0x3f |
| 32635 | hbus monitor | Collected READ  addr=0x102e data=0x3f |
| 32660 | hbus driver | Executed READ  addr=0x102f data=0x6f |
| 32665 | hbus monitor | Collected READ  addr=0x102f data=0x6f |
| 32690 | hbus driver | Executed READ  addr=0x1030 data=0x10 |
| 32695 | hbus monitor | Collected READ  addr=0x1030 data=0x10 |
| 32720 | hbus driver | Executed READ  addr=0x1031 data=0x0c |
| 32725 | hbus monitor | Collected READ  addr=0x1031 data=0x0c |
| 32750 | hbus driver | Executed READ  addr=0x1032 data=0xb3 |
| 32755 | hbus monitor | Collected READ  addr=0x1032 data=0xb3 |
| 32780 | hbus driver | Executed READ  addr=0x1033 data=0xcf |
| 32785 | hbus monitor | Collected READ  addr=0x1033 data=0xcf |
| 32810 | hbus driver | Executed READ  addr=0x1034 data=0x13 |
| 32815 | hbus monitor | Collected READ  addr=0x1034 data=0x13 |
| 32840 | hbus driver | Executed READ  addr=0x1035 data=0x44 |
| 32845 | hbus monitor | Collected READ  addr=0x1035 data=0x44 |
| 32870 | hbus driver | Executed READ  addr=0x1036 data=0xe2 |
| 32875 | hbus monitor | Collected READ  addr=0x1036 data=0xe2 |
| 32900 | hbus driver | Executed READ  addr=0x1037 data=0x19 |
| 32905 | hbus monitor | Collected READ  addr=0x1037 data=0x19 |
| 32930 | hbus driver | Executed READ  addr=0x1038 data=0x5b |
| 32935 | hbus monitor | Collected READ  addr=0x1038 data=0x5b |
| 32960 | hbus driver | Executed READ  addr=0x1039 data=0x7c |
| 32965 | hbus monitor | Collected READ  addr=0x1039 data=0x7c |
| 32990 | hbus driver | Executed READ  addr=0x103a data=0xe0 |
| 32995 | hbus monitor | Collected READ  addr=0x103a data=0xe0 |
| 33020 | hbus driver | Executed READ  addr=0x103b data=0xa8 |
| 33025 | hbus monitor | Collected READ  addr=0x103b data=0xa8 |
| 33050 | hbus driver | Executed READ  addr=0x103c data=0x0f |
| 33055 | hbus monitor | Collected READ  addr=0x103c data=0x0f |
| 33080 | hbus driver | Executed READ  addr=0x103d data=0xc7 |
| 33085 | hbus monitor | Collected READ  addr=0x103d data=0xc7 |
| 33110 | hbus driver | Executed READ  addr=0x103e data=0x59 |
| 33115 | hbus monitor | Collected READ  addr=0x103e data=0x59 |
| 33140 | hbus driver | Executed READ  addr=0x103f data=0x83 |
| 33145 | hbus monitor | Collected READ  addr=0x103f data=0x83 |
| 33170 | hbus driver | Executed READ  addr=0x1040 data=0xc2 |
| 33175 | hbus monitor | Collected READ  addr=0x1040 data=0xc2 |
| 33200 | hbus driver | Executed READ  addr=0x1041 data=0xed |
| 33205 | hbus monitor | Collected READ  addr=0x1041 data=0xed |
| 33230 | hbus driver | Executed READ  addr=0x1042 data=0x18 |
| 33235 | hbus monitor | Collected READ  addr=0x1042 data=0x18 |
| 33260 | hbus driver | Executed READ  addr=0x1043 data=0x40 |
| 33265 | hbus monitor | Collected READ  addr=0x1043 data=0x40 |
| 33290 | hbus driver | Executed READ  addr=0x1044 data=0xe5 |
| 33295 | hbus monitor | Collected READ  addr=0x1044 data=0xe5 |
| 33320 | hbus driver | Executed READ  addr=0x1045 data=0x71 |
| 33325 | hbus monitor | Collected READ  addr=0x1045 data=0x71 |
| 33350 | hbus driver | Executed READ  addr=0x1046 data=0x3b |
| 33355 | hbus monitor | Collected READ  addr=0x1046 data=0x3b |
| 33380 | hbus driver | Executed READ  addr=0x1047 data=0x3d |
| 33385 | hbus monitor | Collected READ  addr=0x1047 data=0x3d |
| 33410 | hbus driver | Executed READ  addr=0x1048 data=0xaf |
| 33415 | hbus monitor | Collected READ  addr=0x1048 data=0xaf |
| 33440 | hbus driver | Executed READ  addr=0x1049 data=0x50 |
| 33445 | hbus monitor | Collected READ  addr=0x1049 data=0x50 |
| 33470 | hbus driver | Executed READ  addr=0x104a data=0x63 |
| 33475 | hbus monitor | Collected READ  addr=0x104a data=0x63 |
| 33500 | hbus driver | Executed READ  addr=0x104b data=0x30 |
| 33505 | hbus monitor | Collected READ  addr=0x104b data=0x30 |
| 33530 | hbus driver | Executed READ  addr=0x104c data=0xe4 |
| 33535 | hbus monitor | Collected READ  addr=0x104c data=0xe4 |
| 33560 | hbus driver | Executed READ  addr=0x104d data=0xd5 |
| 33565 | hbus monitor | Collected READ  addr=0x104d data=0xd5 |
| 33590 | hbus driver | Executed READ  addr=0x104e data=0x10 |
| 33595 | hbus monitor | Collected READ  addr=0x104e data=0x10 |
| 33620 | hbus driver | Executed READ  addr=0x104f data=0x4a |
| 33625 | hbus monitor | Collected READ  addr=0x104f data=0x4a |
| 33735 | **test** | STAGE: done: 61 packets (22 forwarded, 39 dropped), 0 storm burst(s), 22 scoreboard matches, 129 HBUS reads checked, 7 error pulses for 7 bad packets |
| 33935 | error checker | error pulse report: 7 bad packets, 7 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 33935 | ch0 monitor | Channel 0 report: 9 packets collected |
| 33935 | ch1 monitor | Channel 1 report: 4 packets collected |
| 33935 | ch2 monitor | Channel 2 report: 9 packets collected |
| 33935 | hbus monitor | HBUS report: 46 writes, 133 reads |
| 33935 | coverage | Coverage of the router configuration: 91.3% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 8 / 0 / 18 / 17 / 9 packets · length < max / = max / max+1 / > max+1 : 18 / 5 / 11 / 18 · forwarded good / bad : 20 / 2 · dropped address 3 good / bad : 4 / 0 · dropped oversized good / bad : 21 / 5 · counter enables none / mixed / all : 8 / 36 / 8 |
| 33935 | coverage | HBUS address coverage: 179 accesses sampled, coverage 49.4% |
| 33935 | coverage | HBUS register bits coverage: 14 writes to ctrl_reg/en_reg, coverage 100.0% |
| 33935 | coverage | HBUS counter value coverage: 15 counter reads sampled, coverage 66.7% |
| 33935 | coverage | HBUS yapp_mem data coverage: 64 accesses sampled, coverage 64.7% |
| 33935 | reference | --- Reference model report --- · forwarded to scoreboard : 22 · dropped (router disabled) : 9 · dropped (oversized) : 26 · dropped (address 3) : 4 · counters parity/oversized/addr0..3 : 3 / 15 / 8 4 10 3 |
| 33935 | reference | HBUS reads checked against the model: 129 (0 mismatches, 4 of memory bytes never written) |
| 33935 | scoreboard | --- Scoreboard report --- · packets received : 22 · packets matched : 22 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 33935 | yapp driver | YAPP driver report: 61 packets sent |
| 33935 | coverage | YAPP gap coverage: 60 gaps sampled, coverage 100.0% |
| 33935 | yapp monitor | YAPP monitor report: 61 packets collected, 9 with bad parity |
| 33935 | yapp monitor | YAPP gaps: 15 back to back, 10 of 1 cycle, 4 of 2, 31 longer |
| 33935 | coverage | YAPP packet coverage: 61 packets sampled, coverage 70.0% |
