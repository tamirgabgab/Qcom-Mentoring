# random_config_test seed 6

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 16us · wall 11.9 s · log [`random_config_test_s6.log`](random_config_test_s6.log)

Waves: `random_config_test_s6.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s6%2Frandom_config_test_s6.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **24** packet(s) (3 with bad parity); the input monitor saw 24.
- Router: **9** forwarded, **15** dropped (12 oversized, 3 router disabled).
- Packets out: ch0 **1**, ch1 **3**, ch2 **5**.
- Scoreboard: 9 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **4** time(s), longest hold 21 cycle(s).
- Error pulses: 3.
- HBUS: 41 write(s), 126 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_STALLY, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_SLOW |
| 0 | random scenario: 24 packets in 7 bursts |
| 560 | burst 1/7: ctrl=0x3f (maxpktsize 63) en=0xff (router on, counter enables 1111111), 4 packet(s) |
| 1930 | burst 1/7 sent: addr0..3 0/2/2/0, bad parity 0, gap 0 1, length 19..25 |
| 2330 | burst 2/7: ctrl=0x3e (maxpktsize 62) en=0xff (router on, counter enables 1111111), 4 packet(s) |
| 4680 | burst 2/7 sent: addr0..3 0/0/4/0, bad parity 0, gap 0 2, length 1..63 |
| 4950 | burst 3/7: ctrl=0xbf (maxpktsize 63) en=0xff (router on, counter enables 1111111), 3 packet(s) |
| 6730 | burst 3/7 sent: addr0..3 1/1/1/0, bad parity 0, gap 0 0, length 38..63 |
| 6980 | burst 4/7: ctrl=0x80 (maxpktsize 0) en=0xff (router on, counter enables 1111111), 3 packet(s) |
| 7810 | burst 4/7 sent: addr0..3 1/1/1/0, bad parity 1, gap 0 2, length 1..63 |
| 8080 | burst 5/7: ctrl=0x80 (maxpktsize 0) en=0x57 (router on, counter enables 0101011), 3 packet(s) |
| 8900 | burst 5/7 sent: addr0..3 2/0/1/0, bad parity 2, gap 0 1, length 1..54 |
| 9360 | burst 6/7: ctrl=0x47 (maxpktsize 7) en=0x7d (router on, counter enables 0111110), 4 packet(s) |
| 11980 | burst 6/7 sent: addr0..3 1/0/2/1, bad parity 0, gap 0 1, length 31..63 |
| 12260 | burst 7/7: ctrl=0xfe (maxpktsize 62) en=0xfe (router OFF, counter enables 1111111), 3 packet(s) |
| 13230 | burst 7/7 sent: addr0..3 0/1/1/1, bad parity 0, gap 0 1, length 2..63 |
| 13230 | final reads: every register and the stored packet, checked against the reference model |
| 15505 | done: 24 packets (9 forwarded, 15 dropped), 0 storm burst(s), 9 scoreboard matches, 125 HBUS reads checked, 3 error pulses for 3 bad packets |

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

619 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_STALLY, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_SLOW |
| 0 | **test** | STAGE: random scenario: 24 packets in 7 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 75 | reference | maxpktsize is now 63 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x101b data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x101b data=0x00 |
| 170 | hbus driver | Executed WRITE addr=0x115c data=0xc3 |
| 175 | hbus monitor | Collected WRITE addr=0x115c data=0xc3 |
| 200 | hbus driver | Executed READ  addr=0x115c data=0xc3 |
| 205 | hbus monitor | Collected READ  addr=0x115c data=0xc3 |
| 230 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 235 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 250 | hbus driver | Executed WRITE addr=0x11ea data=0xef |
| 255 | hbus monitor | Collected WRITE addr=0x11ea data=0xef |
| 280 | hbus driver | Executed READ  addr=0x11ea data=0xef |
| 285 | hbus monitor | Collected READ  addr=0x11ea data=0xef |
| 300 | hbus driver | Executed WRITE addr=0x117c data=0xd4 |
| 305 | hbus monitor | Collected WRITE addr=0x117c data=0xd4 |
| 330 | hbus driver | Executed READ  addr=0x117c data=0xd4 |
| 335 | hbus monitor | Collected READ  addr=0x117c data=0xd4 |
| 350 | hbus driver | Executed WRITE addr=0x114d data=0x33 |
| 355 | hbus monitor | Collected WRITE addr=0x114d data=0x33 |
| 380 | hbus driver | Executed READ  addr=0x114d data=0x33 |
| 385 | hbus monitor | Collected READ  addr=0x114d data=0x33 |
| 400 | hbus driver | Executed WRITE addr=0x111d data=0x8d |
| 405 | hbus monitor | Collected WRITE addr=0x111d data=0x8d |
| 430 | hbus driver | Executed READ  addr=0x111d data=0x8d |
| 435 | hbus monitor | Collected READ  addr=0x111d data=0x8d |
| 450 | hbus driver | Executed WRITE addr=0x11ce data=0x42 |
| 455 | hbus monitor | Collected WRITE addr=0x11ce data=0x42 |
| 480 | hbus driver | Executed READ  addr=0x11ce data=0x42 |
| 485 | hbus monitor | Collected READ  addr=0x11ce data=0x42 |
| 510 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 515 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 530 | hbus driver | Executed WRITE addr=0x11c6 data=0x03 |
| 535 | hbus monitor | Collected WRITE addr=0x11c6 data=0x03 |
| 560 | hbus driver | Executed READ  addr=0x11c6 data=0x03 |
| 560 | **test** | STAGE: burst 1/7: ctrl=0x3f (maxpktsize 63) en=0xff (router on, counter enables 1111111), 4 packet(s) |
| 560 | yapp driver | TX pkt #1: addr=1 len=20 parity=good delay=3 |
| 565 | hbus monitor | Collected READ  addr=0x11c6 data=0x03 |
| 605 | **DUT** | IN  pkt #1 header: addr=1 len=20 -> channel 1 |
| 615 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=20 (receiver waited 0 cycle(s)) |
| 815 | **DUT** | IN  pkt #1 complete: addr=1 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 815 | yapp monitor | RX pkt #1 on the input: addr=1 len=20 parity=good gap=55 |
| 815 | reference | Packet forwarded: addr=1 len=20 -> channel 1 |
| 820 | ch1 driver | ch1: packet consumed (response delay 0) |
| 820 | yapp driver | TX pkt #1 accepted by the DUT |
| 820 | yapp driver | TX pkt #2: addr=2 len=25 parity=good delay=16 |
| 835 | **DUT** | OUT ch1 pkt #1 done: 22 bytes in 23 cycles |
| 835 | ch1 monitor | ch1 RX pkt #1: addr=1 len=20 parity=good |
| 835 | scoreboard | ch1 pkt matched: addr=1 len=20 (1 matched so far) |
| 985 | **DUT** | IN  pkt #2 header: addr=2 len=25 -> channel 2 |
| 1130 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1145 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xc9 held (pkt #2) |
| 1195 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=25 (receiver waited 20 cycle(s)) |
| 1205 | **DUT** | SUSPEND released after 6 cycle(s) |
| 1305 | **DUT** | IN  pkt #2 complete: addr=2 len=25 parity=ok forwarded, 27 bytes in 33 cycles (held 6) |
| 1305 | yapp monitor | RX pkt #2 on the input: addr=2 len=25 parity=good gap=16 |
| 1305 | reference | Packet forwarded: addr=2 len=25 -> channel 2 |
| 1310 | yapp driver | TX pkt #2 accepted by the DUT |
| 1310 | yapp driver | TX pkt #3: addr=1 len=19 parity=good delay=0 |
| 1315 | **DUT** | IN  pkt #3 header: addr=1 len=19 -> channel 1 |
| 1325 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=19 (receiver waited 0 cycle(s)) |
| 1450 | ch2 driver | ch2: packet consumed (response delay 20) |
| 1515 | **DUT** | IN  pkt #3 complete: addr=1 len=19 parity=ok forwarded, 21 bytes in 21 cycles (held 0) |
| 1515 | yapp monitor | RX pkt #3 on the input: addr=1 len=19 parity=good gap=0 |
| 1515 | reference | Packet forwarded: addr=1 len=19 -> channel 1 |
| 1520 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1520 | yapp driver | TX pkt #3 accepted by the DUT |
| 1520 | yapp driver | TX pkt #4: addr=2 len=19 parity=good delay=20 |
| 1535 | **DUT** | OUT ch1 pkt #2 done: 21 bytes in 22 cycles |
| 1535 | ch1 monitor | ch1 RX pkt #2: addr=1 len=19 parity=good |
| 1535 | scoreboard | ch1 pkt matched: addr=1 len=19 (2 matched so far) |
| 1540 | ch1 driver | ch1: packet consumed (response delay 0) |
| 1725 | **DUT** | IN  pkt #4 header: addr=2 len=19 -> channel 2 |
| 1745 | **DUT** | OUT ch2 pkt #1 done: 27 bytes in 56 cycles |
| 1745 | ch2 monitor | ch2 RX pkt #1: addr=2 len=25 parity=good |
| 1745 | scoreboard | ch2 pkt matched: addr=2 len=25 (3 matched so far) |
| 1755 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=19 (receiver waited 0 cycle(s)) |
| 1830 | ch2 driver | ch2: packet consumed (response delay 28) |
| 1925 | **DUT** | IN  pkt #4 complete: addr=2 len=19 parity=ok forwarded, 21 bytes in 21 cycles (held 0) |
| 1925 | yapp monitor | RX pkt #4 on the input: addr=2 len=19 parity=good gap=20 |
| 1925 | reference | Packet forwarded: addr=2 len=19 -> channel 2 |
| 1930 | yapp driver | TX pkt #4 accepted by the DUT |
| 1930 | **test** | STAGE: burst 1/7 sent: addr0..3 0/2/2/0, bad parity 0, gap 0 1, length 19..25 |
| 1950 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 1955 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 1955 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 1955 | reference | maxpktsize is now 62 |
| 1970 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 1975 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 1975 | reference | router_en is now 1 (en_reg 0xff) |
| 2000 | hbus driver | Executed READ  addr=0x100b data=0x02 |
| 2005 | hbus monitor | Collected READ  addr=0x100b data=0x02 |
| 2030 | hbus driver | Executed READ  addr=0x1014 data=0xd8 |
| 2035 | hbus monitor | Collected READ  addr=0x1014 data=0xd8 |
| 2060 | hbus driver | Executed READ  addr=0x1013 data=0x0d |
| 2065 | hbus monitor | Collected READ  addr=0x1013 data=0x0d |
| 2090 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 2095 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2110 | hbus driver | Executed WRITE addr=0x110c data=0x41 |
| 2115 | hbus monitor | Collected WRITE addr=0x110c data=0x41 |
| 2140 | hbus driver | Executed READ  addr=0x110c data=0x41 |
| 2145 | hbus monitor | Collected READ  addr=0x110c data=0x41 |
| 2170 | hbus driver | Executed READ  addr=0x107f data=0x00 |
| 2175 | hbus monitor | Collected READ  addr=0x107f data=0x00 |
| 2200 | hbus driver | Executed READ  addr=0x10f1 data=0x00 |
| 2205 | hbus monitor | Collected READ  addr=0x10f1 data=0x00 |
| 2220 | hbus driver | Executed WRITE addr=0x1135 data=0x4e |
| 2225 | hbus monitor | Collected WRITE addr=0x1135 data=0x4e |
| 2250 | hbus driver | Executed READ  addr=0x1135 data=0x4e |
| 2255 | **DUT** | OUT ch2 pkt #2 done: 21 bytes in 51 cycles |
| 2255 | ch2 monitor | ch2 RX pkt #2: addr=2 len=19 parity=good |
| 2255 | scoreboard | ch2 pkt matched: addr=2 len=19 (4 matched so far) |
| 2255 | hbus monitor | Collected READ  addr=0x1135 data=0x4e |
| 2270 | hbus driver | Executed WRITE addr=0x11fe data=0x21 |
| 2275 | hbus monitor | Collected WRITE addr=0x11fe data=0x21 |
| 2280 | ch2 driver | ch2: packet consumed (response delay 29) |
| 2300 | hbus driver | Executed READ  addr=0x11fe data=0x21 |
| 2305 | hbus monitor | Collected READ  addr=0x11fe data=0x21 |
| 2330 | hbus driver | Executed READ  addr=0x1094 data=0x00 |
| 2330 | **test** | STAGE: burst 2/7: ctrl=0x3e (maxpktsize 62) en=0xff (router on, counter enables 1111111), 4 packet(s) |
| 2330 | yapp driver | TX pkt #5: addr=2 len=1 parity=good delay=5 |
| 2335 | hbus monitor | Collected READ  addr=0x1094 data=0x00 |
| 2395 | **DUT** | IN  pkt #5 header: addr=2 len=1 -> channel 2 |
| 2415 | **DUT** | IN  pkt #5 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2415 | yapp monitor | RX pkt #5 on the input: addr=2 len=1 parity=good gap=46 |
| 2415 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 2420 | yapp driver | TX pkt #5 accepted by the DUT |
| 2420 | yapp driver | TX pkt #6: addr=2 len=61 parity=good delay=0 |
| 2425 | **DUT** | IN  pkt #6 header: addr=2 len=61 -> channel 2 |
| 2555 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x2d held (pkt #6) |
| 2635 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=1 (receiver waited 23 cycle(s)) |
| 2645 | **DUT** | SUSPEND released after 9 cycle(s) |
| 2650 | ch2 driver | ch2: packet consumed (response delay 23) |
| 2665 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x87 held (pkt #6) |
| 2865 | **DUT** | OUT ch2 pkt #3 done: 3 bytes in 24 cycles |
| 2865 | ch2 monitor | ch2 RX pkt #3: addr=2 len=1 parity=good |
| 2865 | scoreboard | ch2 pkt matched: addr=2 len=1 (5 matched so far) |
| 2875 | **DUT** | SUSPEND released after 21 cycle(s) |
| 2875 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=61 (receiver waited 0 cycle(s)) |
| 3345 | **DUT** | IN  pkt #6 complete: addr=2 len=61 parity=ok forwarded, 63 bytes in 93 cycles (held 30) |
| 3345 | yapp monitor | RX pkt #6 on the input: addr=2 len=61 parity=good gap=0 |
| 3345 | reference | Packet forwarded: addr=2 len=61 -> channel 2 |
| 3350 | yapp driver | TX pkt #6 accepted by the DUT |
| 3350 | yapp driver | TX pkt #7: addr=2 len=63 parity=good delay=3 |
| 3385 | **DUT** | IN  pkt #7 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 3420 | ch2 driver | ch2: packet consumed (response delay 20) |
| 3735 | **DUT** | OUT ch2 pkt #4 done: 63 bytes in 87 cycles |
| 3735 | ch2 monitor | ch2 RX pkt #4: addr=2 len=61 parity=good |
| 3735 | scoreboard | ch2 pkt matched: addr=2 len=61 (6 matched so far) |
| 3870 | ch2 driver | ch2: packet consumed (response delay 23) |
| 4025 | **DUT** | IN  pkt #7 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4025 | yapp monitor | RX pkt #7 on the input: addr=2 len=63 parity=good gap=3 |
| 4025 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 4025 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4030 | yapp driver | TX pkt #7 accepted by the DUT |
| 4030 | yapp driver | TX pkt #8: addr=2 len=63 parity=good delay=0 |
| 4035 | **DUT** | IN  pkt #8 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 4675 | **DUT** | IN  pkt #8 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4675 | yapp monitor | RX pkt #8 on the input: addr=2 len=63 parity=good gap=0 |
| 4675 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 4675 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4680 | yapp driver | TX pkt #8 accepted by the DUT |
| 4680 | **test** | STAGE: burst 2/7 sent: addr0..3 0/0/4/0, bad parity 0, gap 0 2, length 1..63 |
| 4700 | hbus driver | Executed WRITE addr=0x1000 data=0xbf |
| 4705 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 4705 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 4705 | reference | maxpktsize is now 63 |
| 4720 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 4725 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 4725 | reference | router_en is now 1 (en_reg 0xff) |
| 4750 | hbus driver | Executed READ  addr=0x101a data=0x93 |
| 4755 | hbus monitor | Collected READ  addr=0x101a data=0x93 |
| 4770 | hbus driver | Executed WRITE addr=0x11ec data=0xc2 |
| 4775 | hbus monitor | Collected WRITE addr=0x11ec data=0xc2 |
| 4800 | hbus driver | Executed READ  addr=0x11ec data=0xc2 |
| 4805 | hbus monitor | Collected READ  addr=0x11ec data=0xc2 |
| 4820 | hbus driver | Executed WRITE addr=0x1101 data=0x94 |
| 4825 | hbus monitor | Collected WRITE addr=0x1101 data=0x94 |
| 4850 | hbus driver | Executed READ  addr=0x1101 data=0x94 |
| 4855 | hbus monitor | Collected READ  addr=0x1101 data=0x94 |
| 4870 | hbus driver | Executed WRITE addr=0x11ab data=0x6d |
| 4875 | hbus monitor | Collected WRITE addr=0x11ab data=0x6d |
| 4900 | hbus driver | Executed READ  addr=0x11ab data=0x6d |
| 4905 | hbus monitor | Collected READ  addr=0x11ab data=0x6d |
| 4920 | hbus driver | Executed WRITE addr=0x118c data=0xea |
| 4925 | hbus monitor | Collected WRITE addr=0x118c data=0xea |
| 4950 | hbus driver | Executed READ  addr=0x118c data=0xea |
| 4950 | **test** | STAGE: burst 3/7: ctrl=0xbf (maxpktsize 63) en=0xff (router on, counter enables 1111111), 3 packet(s) |
| 4950 | yapp driver | TX pkt #9: addr=0 len=63 parity=good delay=1 |
| 4955 | hbus monitor | Collected READ  addr=0x118c data=0xea |
| 4975 | **DUT** | IN  pkt #9 header: addr=0 len=63 -> channel 0 |
| 5005 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=63 (receiver waited 2 cycle(s)) |
| 5615 | **DUT** | IN  pkt #9 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 5615 | yapp monitor | RX pkt #9 on the input: addr=0 len=63 parity=good gap=29 |
| 5615 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 5620 | yapp driver | TX pkt #9 accepted by the DUT |
| 5620 | yapp driver | TX pkt #10: addr=1 len=38 parity=good delay=3 |
| 5640 | ch0 driver | ch0: packet consumed (response delay 2) |
| 5655 | **DUT** | IN  pkt #10 header: addr=1 len=38 -> channel 1 |
| 5665 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=38 (receiver waited 0 cycle(s)) |
| 5675 | **DUT** | OUT ch0 pkt #1 done: 65 bytes in 68 cycles |
| 5675 | ch0 monitor | ch0 RX pkt #1: addr=0 len=63 parity=good |
| 5675 | scoreboard | ch0 pkt matched: addr=0 len=63 (7 matched so far) |
| 5950 | ch0 driver | ch0: packet consumed (response delay 2) |
| 6045 | **DUT** | IN  pkt #10 complete: addr=1 len=38 parity=ok forwarded, 40 bytes in 40 cycles (held 0) |
| 6045 | yapp monitor | RX pkt #10 on the input: addr=1 len=38 parity=good gap=3 |
| 6045 | reference | Packet forwarded: addr=1 len=38 -> channel 1 |
| 6050 | ch1 driver | ch1: packet consumed (response delay 0) |
| 6050 | yapp driver | TX pkt #10 accepted by the DUT |
| 6050 | yapp driver | TX pkt #11: addr=2 len=54 parity=good delay=1 |
| 6065 | **DUT** | IN  pkt #11 header: addr=2 len=54 -> channel 2 |
| 6065 | **DUT** | OUT ch1 pkt #3 done: 40 bytes in 41 cycles |
| 6065 | ch1 monitor | ch1 RX pkt #3: addr=1 len=38 parity=good |
| 6065 | scoreboard | ch1 pkt matched: addr=1 len=38 (8 matched so far) |
| 6225 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x2a held (pkt #11) |
| 6325 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=54 (receiver waited 25 cycle(s)) |
| 6335 | **DUT** | SUSPEND released after 11 cycle(s) |
| 6410 | ch1 driver | ch1: packet consumed (response delay 0) |
| 6725 | **DUT** | IN  pkt #11 complete: addr=2 len=54 parity=ok forwarded, 56 bytes in 67 cycles (held 11) |
| 6725 | yapp monitor | RX pkt #11 on the input: addr=2 len=54 parity=good gap=1 |
| 6725 | reference | Packet forwarded: addr=2 len=54 -> channel 2 |
| 6730 | yapp driver | TX pkt #11 accepted by the DUT |
| 6730 | **test** | STAGE: burst 3/7 sent: addr0..3 1/1/1/0, bad parity 0, gap 0 0, length 38..63 |
| 6750 | hbus driver | Executed WRITE addr=0x1000 data=0x80 |
| 6755 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 6755 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 6755 | reference | maxpktsize is now 0 |
| 6770 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 6775 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 6775 | reference | router_en is now 1 (en_reg 0xff) |
| 6790 | hbus driver | Executed WRITE addr=0x1163 data=0x3f |
| 6795 | hbus monitor | Collected WRITE addr=0x1163 data=0x3f |
| 6820 | hbus driver | Executed READ  addr=0x1163 data=0x3f |
| 6825 | hbus monitor | Collected READ  addr=0x1163 data=0x3f |
| 6840 | hbus driver | Executed WRITE addr=0x110d data=0xe9 |
| 6845 | hbus monitor | Collected WRITE addr=0x110d data=0xe9 |
| 6870 | ch2 driver | ch2: packet consumed (response delay 25) |
| 6870 | hbus driver | Executed READ  addr=0x110d data=0xe9 |
| 6875 | hbus monitor | Collected READ  addr=0x110d data=0xe9 |
| 6900 | hbus driver | Executed READ  addr=0x1060 data=0x00 |
| 6905 | hbus monitor | Collected READ  addr=0x1060 data=0x00 |
| 6930 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 6935 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6950 | hbus driver | Executed WRITE addr=0x111c data=0x66 |
| 6955 | hbus monitor | Collected WRITE addr=0x111c data=0x66 |
| 6980 | hbus driver | Executed READ  addr=0x111c data=0x66 |
| 6980 | **test** | STAGE: burst 4/7: ctrl=0x80 (maxpktsize 0) en=0xff (router on, counter enables 1111111), 3 packet(s) |
| 6980 | yapp driver | TX pkt #12: addr=2 len=63 parity=bad delay=0 |
| 6985 | hbus monitor | Collected READ  addr=0x111c data=0x66 |
| 6995 | **DUT** | IN  pkt #12 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 7105 | **DUT** | OUT ch2 pkt #5 done: 56 bytes in 79 cycles |
| 7105 | ch2 monitor | ch2 RX pkt #5: addr=2 len=54 parity=good |
| 7105 | scoreboard | ch2 pkt matched: addr=2 len=54 (9 matched so far) |
| 7635 | **DUT** | IN  pkt #12 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 7635 | yapp monitor | RX pkt #12 on the input: addr=2 len=63 parity=bad gap=26 |
| 7635 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 7635 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 7640 | yapp driver | TX pkt #12 accepted by the DUT |
| 7640 | yapp driver | TX pkt #13: addr=0 len=1 parity=good delay=0 |
| 7645 | **DUT** | IN  pkt #13 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 7665 | **DUT** | IN  pkt #13 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 7665 | yapp monitor | RX pkt #13 on the input: addr=0 len=1 parity=good gap=0 |
| 7665 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 7665 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 7670 | yapp driver | TX pkt #13 accepted by the DUT |
| 7670 | yapp driver | TX pkt #14: addr=1 len=10 parity=good delay=2 |
| 7695 | **DUT** | IN  pkt #14 header: addr=1 len=10 -> DROP (oversized: len 10 > maxpktsize 0) |
| 7710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 7710 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 7710 | ch2 driver | ch2: packet consumed (response delay 22) |
| 7805 | **DUT** | IN  pkt #14 complete: addr=1 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 7805 | yapp monitor | RX pkt #14 on the input: addr=1 len=10 parity=good gap=2 |
| 7805 | reference | Packet dropped: length 10 > maxpktsize 0 (addr=1) |
| 7805 | **DUT** | ROUTER DROPS PACKET addr=1 length=10 (length > maxpktsize) |
| 7810 | yapp driver | TX pkt #14 accepted by the DUT |
| 7810 | **test** | STAGE: burst 4/7 sent: addr0..3 1/1/1/0, bad parity 1, gap 0 2, length 1..63 |
| 7830 | hbus driver | Executed WRITE addr=0x1000 data=0x80 |
| 7835 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 7835 | reference | maxpktsize is now 0 |
| 7850 | hbus driver | Executed WRITE addr=0x1001 data=0x57 |
| 7855 | hbus monitor | Collected WRITE addr=0x1001 data=0x57 |
| 7855 | reference | router_en is now 1 (en_reg 0x57) |
| 7870 | hbus driver | Executed WRITE addr=0x11e9 data=0xca |
| 7875 | hbus monitor | Collected WRITE addr=0x11e9 data=0xca |
| 7900 | hbus driver | Executed READ  addr=0x11e9 data=0xca |
| 7905 | hbus monitor | Collected READ  addr=0x11e9 data=0xca |
| 7920 | hbus driver | Executed WRITE addr=0x1174 data=0x05 |
| 7925 | hbus monitor | Collected WRITE addr=0x1174 data=0x05 |
| 7950 | hbus driver | Executed READ  addr=0x1174 data=0x05 |
| 7955 | hbus monitor | Collected READ  addr=0x1174 data=0x05 |
| 7970 | hbus driver | Executed WRITE addr=0x119f data=0x31 |
| 7975 | hbus monitor | Collected WRITE addr=0x119f data=0x31 |
| 8000 | hbus driver | Executed READ  addr=0x119f data=0x31 |
| 8005 | hbus monitor | Collected READ  addr=0x119f data=0x31 |
| 8030 | hbus driver | Executed READ  addr=0x1032 data=0xe5 |
| 8035 | hbus monitor | Collected READ  addr=0x1032 data=0xe5 |
| 8050 | hbus driver | Executed WRITE addr=0x1176 data=0x66 |
| 8055 | hbus monitor | Collected WRITE addr=0x1176 data=0x66 |
| 8080 | hbus driver | Executed READ  addr=0x1176 data=0x66 |
| 8080 | **test** | STAGE: burst 5/7: ctrl=0x80 (maxpktsize 0) en=0x57 (router on, counter enables 0101011), 3 packet(s) |
| 8080 | yapp driver | TX pkt #15: addr=2 len=54 parity=bad delay=0 |
| 8085 | hbus monitor | Collected READ  addr=0x1176 data=0x66 |
| 8095 | **DUT** | IN  pkt #15 header: addr=2 len=54 -> DROP (oversized: len 54 > maxpktsize 0) |
| 8645 | **DUT** | IN  pkt #15 complete: addr=2 len=54 parity=BAD dropped, 56 bytes in 56 cycles (held 0) |
| 8645 | yapp monitor | RX pkt #15 on the input: addr=2 len=54 parity=bad gap=28 |
| 8645 | reference | Packet dropped: length 54 > maxpktsize 0 (addr=2) |
| 8645 | **DUT** | ROUTER DROPS PACKET addr=2 length=54 (length > maxpktsize) |
| 8650 | yapp driver | TX pkt #15 accepted by the DUT |
| 8650 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=1 |
| 8665 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 8670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 8670 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 8685 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8685 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=1 |
| 8685 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 8685 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 8690 | yapp driver | TX pkt #16 accepted by the DUT |
| 8690 | yapp driver | TX pkt #17: addr=0 len=1 parity=bad delay=18 |
| 8875 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 8895 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 8895 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=bad gap=18 |
| 8895 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 8895 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 8900 | yapp driver | TX pkt #17 accepted by the DUT |
| 8900 | **test** | STAGE: burst 5/7 sent: addr0..3 2/0/1/0, bad parity 2, gap 0 1, length 1..54 |
| 8920 | hbus driver | Executed WRITE addr=0x1000 data=0x47 |
| 8925 | **DUT** | CONFIG router_en=1 maxpktsize=7 |
| 8925 | hbus monitor | Collected WRITE addr=0x1000 data=0x47 |
| 8925 | reference | maxpktsize is now 7 |
| 8940 | hbus driver | Executed WRITE addr=0x1001 data=0x7d |
| 8945 | hbus monitor | Collected WRITE addr=0x1001 data=0x7d |
| 8945 | reference | router_en is now 1 (en_reg 0x7d) |
| 8950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 8950 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 8970 | hbus driver | Executed READ  addr=0x103f data=0xca |
| 8975 | hbus monitor | Collected READ  addr=0x103f data=0xca |
| 9000 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 9005 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 9020 | hbus driver | Executed WRITE addr=0x1108 data=0x0c |
| 9025 | hbus monitor | Collected WRITE addr=0x1108 data=0x0c |
| 9050 | hbus driver | Executed READ  addr=0x1108 data=0x0c |
| 9055 | hbus monitor | Collected READ  addr=0x1108 data=0x0c |
| 9080 | hbus driver | Executed READ  addr=0x1077 data=0x00 |
| 9085 | hbus monitor | Collected READ  addr=0x1077 data=0x00 |
| 9110 | hbus driver | Executed READ  addr=0x1033 data=0xff |
| 9115 | hbus monitor | Collected READ  addr=0x1033 data=0xff |
| 9140 | hbus driver | Executed READ  addr=0x104f data=0xc4 |
| 9145 | hbus monitor | Collected READ  addr=0x104f data=0xc4 |
| 9170 | hbus driver | Executed READ  addr=0x1009 data=0x04 |
| 9175 | hbus monitor | Collected READ  addr=0x1009 data=0x04 |
| 9200 | hbus driver | Executed READ  addr=0x1038 data=0xc6 |
| 9205 | hbus monitor | Collected READ  addr=0x1038 data=0xc6 |
| 9230 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 9235 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 9250 | hbus driver | Executed WRITE addr=0x11f2 data=0x7c |
| 9255 | hbus monitor | Collected WRITE addr=0x11f2 data=0x7c |
| 9280 | hbus driver | Executed READ  addr=0x11f2 data=0x7c |
| 9285 | hbus monitor | Collected READ  addr=0x11f2 data=0x7c |
| 9310 | hbus driver | Executed READ  addr=0x104a data=0x42 |
| 9315 | hbus monitor | Collected READ  addr=0x104a data=0x42 |
| 9330 | hbus driver | Executed WRITE addr=0x1158 data=0xf7 |
| 9335 | hbus monitor | Collected WRITE addr=0x1158 data=0xf7 |
| 9360 | hbus driver | Executed READ  addr=0x1158 data=0xf7 |
| 9360 | **test** | STAGE: burst 6/7: ctrl=0x47 (maxpktsize 7) en=0x7d (router on, counter enables 0111110), 4 packet(s) |
| 9360 | yapp driver | TX pkt #18: addr=3 len=63 parity=good delay=20 |
| 9365 | hbus monitor | Collected READ  addr=0x1158 data=0xf7 |
| 9575 | **DUT** | IN  pkt #18 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 7) |
| 10215 | **DUT** | IN  pkt #18 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10215 | yapp monitor | RX pkt #18 on the input: addr=3 len=63 parity=good gap=67 |
| 10215 | reference | Packet dropped: illegal address 3 (len=63) |
| 10215 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 10220 | yapp driver | TX pkt #18 accepted by the DUT |
| 10220 | yapp driver | TX pkt #19: addr=0 len=63 parity=good delay=4 |
| 10265 | **DUT** | IN  pkt #19 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 7) |
| 10905 | **DUT** | IN  pkt #19 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10905 | yapp monitor | RX pkt #19 on the input: addr=0 len=63 parity=good gap=4 |
| 10905 | reference | Packet dropped: length 63 > maxpktsize 7 (addr=0) |
| 10905 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 10910 | yapp driver | TX pkt #19 accepted by the DUT |
| 10910 | yapp driver | TX pkt #20: addr=2 len=31 parity=good delay=0 |
| 10915 | **DUT** | IN  pkt #20 header: addr=2 len=31 -> DROP (oversized: len 31 > maxpktsize 7) |
| 11235 | **DUT** | IN  pkt #20 complete: addr=2 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 11235 | yapp monitor | RX pkt #20 on the input: addr=2 len=31 parity=good gap=0 |
| 11235 | reference | Packet dropped: length 31 > maxpktsize 7 (addr=2) |
| 11235 | **DUT** | ROUTER DROPS PACKET addr=2 length=31 (length > maxpktsize) |
| 11240 | yapp driver | TX pkt #20 accepted by the DUT |
| 11240 | yapp driver | TX pkt #21: addr=2 len=62 parity=good delay=10 |
| 11345 | **DUT** | IN  pkt #21 header: addr=2 len=62 -> DROP (oversized: len 62 > maxpktsize 7) |
| 11975 | **DUT** | IN  pkt #21 complete: addr=2 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 11975 | yapp monitor | RX pkt #21 on the input: addr=2 len=62 parity=good gap=10 |
| 11975 | reference | Packet dropped: length 62 > maxpktsize 7 (addr=2) |
| 11975 | **DUT** | ROUTER DROPS PACKET addr=2 length=62 (length > maxpktsize) |
| 11980 | yapp driver | TX pkt #21 accepted by the DUT |
| 11980 | **test** | STAGE: burst 6/7 sent: addr0..3 1/0/2/1, bad parity 0, gap 0 1, length 31..63 |
| 12000 | hbus driver | Executed WRITE addr=0x1000 data=0xfe |
| 12005 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 12005 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 12005 | reference | maxpktsize is now 62 |
| 12020 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 12025 | **DUT** | CONFIG router_en=0 maxpktsize=62 |
| 12025 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 12025 | reference | router_en is now 0 (en_reg 0xfe) |
| 12050 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 12055 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 12080 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 12085 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12100 | hbus driver | Executed WRITE addr=0x117c data=0x23 |
| 12105 | hbus monitor | Collected WRITE addr=0x117c data=0x23 |
| 12130 | hbus driver | Executed READ  addr=0x117c data=0x23 |
| 12135 | hbus monitor | Collected READ  addr=0x117c data=0x23 |
| 12150 | hbus driver | Executed WRITE addr=0x1153 data=0xa5 |
| 12155 | hbus monitor | Collected WRITE addr=0x1153 data=0xa5 |
| 12180 | hbus driver | Executed READ  addr=0x1153 data=0xa5 |
| 12185 | hbus monitor | Collected READ  addr=0x1153 data=0xa5 |
| 12210 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 12215 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 12230 | hbus driver | Executed WRITE addr=0x11ee data=0x95 |
| 12235 | hbus monitor | Collected WRITE addr=0x11ee data=0x95 |
| 12260 | hbus driver | Executed READ  addr=0x11ee data=0x95 |
| 12260 | **test** | STAGE: burst 7/7: ctrl=0xfe (maxpktsize 62) en=0xfe (router OFF, counter enables 1111111), 3 packet(s) |
| 12260 | yapp driver | TX pkt #22: addr=2 len=6 parity=good delay=1 |
| 12265 | hbus monitor | Collected READ  addr=0x11ee data=0x95 |
| 12285 | **DUT** | IN  pkt #22 header: addr=2 len=6 -> DROP (router disabled) |
| 12355 | **DUT** | IN  pkt #22 complete: addr=2 len=6 parity=ok dropped, 8 bytes in 8 cycles (held 0) |
| 12355 | yapp monitor | RX pkt #22 on the input: addr=2 len=6 parity=good gap=30 |
| 12355 | reference | Packet dropped: router disabled (addr=2 len=6) |
| 12355 | **DUT** | ROUTER DROPS PACKET addr=2 length=6 (router disabled) |
| 12360 | yapp driver | TX pkt #22 accepted by the DUT |
| 12360 | yapp driver | TX pkt #23: addr=1 len=2 parity=good delay=18 |
| 12545 | **DUT** | IN  pkt #23 header: addr=1 len=2 -> DROP (router disabled) |
| 12575 | **DUT** | IN  pkt #23 complete: addr=1 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 12575 | yapp monitor | RX pkt #23 on the input: addr=1 len=2 parity=good gap=18 |
| 12575 | reference | Packet dropped: router disabled (addr=1 len=2) |
| 12575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (router disabled) |
| 12580 | yapp driver | TX pkt #23 accepted by the DUT |
| 12580 | yapp driver | TX pkt #24: addr=3 len=63 parity=good delay=0 |
| 12585 | **DUT** | IN  pkt #24 header: addr=3 len=63 -> DROP (router disabled) |
| 13225 | **DUT** | IN  pkt #24 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 13225 | yapp monitor | RX pkt #24 on the input: addr=3 len=63 parity=good gap=0 |
| 13225 | reference | Packet dropped: router disabled (addr=3 len=63) |
| 13225 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (router disabled) |
| 13230 | yapp driver | TX pkt #24 accepted by the DUT |
| 13230 | **test** | STAGE: burst 7/7 sent: addr0..3 0/1/1/1, bad parity 0, gap 0 1, length 2..63 |
| 13230 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 13260 | hbus driver | Executed READ  addr=0x1000 data=0xfe |
| 13265 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 13290 | hbus driver | Executed READ  addr=0x1001 data=0xfe |
| 13295 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 13320 | hbus driver | Executed READ  addr=0x1004 data=0x03 |
| 13325 | hbus monitor | Collected READ  addr=0x1004 data=0x03 |
| 13350 | hbus driver | Executed READ  addr=0x1005 data=0x0c |
| 13355 | hbus monitor | Collected READ  addr=0x1005 data=0x0c |
| 13380 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 13385 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13410 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 13415 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 13440 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 13445 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 13470 | hbus driver | Executed READ  addr=0x100b data=0x0b |
| 13475 | hbus monitor | Collected READ  addr=0x100b data=0x0b |
| 13500 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 13505 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 13530 | hbus driver | Executed READ  addr=0x1010 data=0xfa |
| 13535 | hbus monitor | Collected READ  addr=0x1010 data=0xfa |
| 13560 | hbus driver | Executed READ  addr=0x1011 data=0xe6 |
| 13565 | hbus monitor | Collected READ  addr=0x1011 data=0xe6 |
| 13590 | hbus driver | Executed READ  addr=0x1012 data=0x57 |
| 13595 | hbus monitor | Collected READ  addr=0x1012 data=0x57 |
| 13620 | hbus driver | Executed READ  addr=0x1013 data=0xde |
| 13625 | hbus monitor | Collected READ  addr=0x1013 data=0xde |
| 13650 | hbus driver | Executed READ  addr=0x1014 data=0x7c |
| 13655 | hbus monitor | Collected READ  addr=0x1014 data=0x7c |
| 13680 | hbus driver | Executed READ  addr=0x1015 data=0x90 |
| 13685 | hbus monitor | Collected READ  addr=0x1015 data=0x90 |
| 13710 | hbus driver | Executed READ  addr=0x1016 data=0xa6 |
| 13715 | hbus monitor | Collected READ  addr=0x1016 data=0xa6 |
| 13740 | hbus driver | Executed READ  addr=0x1017 data=0xee |
| 13745 | hbus monitor | Collected READ  addr=0x1017 data=0xee |
| 13770 | hbus driver | Executed READ  addr=0x1018 data=0xfe |
| 13775 | hbus monitor | Collected READ  addr=0x1018 data=0xfe |
| 13800 | hbus driver | Executed READ  addr=0x1019 data=0x39 |
| 13805 | hbus monitor | Collected READ  addr=0x1019 data=0x39 |
| 13830 | hbus driver | Executed READ  addr=0x101a data=0x05 |
| 13835 | hbus monitor | Collected READ  addr=0x101a data=0x05 |
| 13860 | hbus driver | Executed READ  addr=0x101b data=0xd2 |
| 13865 | hbus monitor | Collected READ  addr=0x101b data=0xd2 |
| 13890 | hbus driver | Executed READ  addr=0x101c data=0x59 |
| 13895 | hbus monitor | Collected READ  addr=0x101c data=0x59 |
| 13920 | hbus driver | Executed READ  addr=0x101d data=0x79 |
| 13925 | hbus monitor | Collected READ  addr=0x101d data=0x79 |
| 13950 | hbus driver | Executed READ  addr=0x101e data=0x14 |
| 13955 | hbus monitor | Collected READ  addr=0x101e data=0x14 |
| 13980 | hbus driver | Executed READ  addr=0x101f data=0x84 |
| 13985 | hbus monitor | Collected READ  addr=0x101f data=0x84 |
| 14010 | hbus driver | Executed READ  addr=0x1020 data=0x51 |
| 14015 | hbus monitor | Collected READ  addr=0x1020 data=0x51 |
| 14040 | hbus driver | Executed READ  addr=0x1021 data=0xd2 |
| 14045 | hbus monitor | Collected READ  addr=0x1021 data=0xd2 |
| 14070 | hbus driver | Executed READ  addr=0x1022 data=0xeb |
| 14075 | hbus monitor | Collected READ  addr=0x1022 data=0xeb |
| 14100 | hbus driver | Executed READ  addr=0x1023 data=0x57 |
| 14105 | hbus monitor | Collected READ  addr=0x1023 data=0x57 |
| 14130 | hbus driver | Executed READ  addr=0x1024 data=0x92 |
| 14135 | hbus monitor | Collected READ  addr=0x1024 data=0x92 |
| 14160 | hbus driver | Executed READ  addr=0x1025 data=0xa9 |
| 14165 | hbus monitor | Collected READ  addr=0x1025 data=0xa9 |
| 14190 | hbus driver | Executed READ  addr=0x1026 data=0x35 |
| 14195 | hbus monitor | Collected READ  addr=0x1026 data=0x35 |
| 14220 | hbus driver | Executed READ  addr=0x1027 data=0xa5 |
| 14225 | hbus monitor | Collected READ  addr=0x1027 data=0xa5 |
| 14250 | hbus driver | Executed READ  addr=0x1028 data=0xaf |
| 14255 | hbus monitor | Collected READ  addr=0x1028 data=0xaf |
| 14280 | hbus driver | Executed READ  addr=0x1029 data=0xd1 |
| 14285 | hbus monitor | Collected READ  addr=0x1029 data=0xd1 |
| 14310 | hbus driver | Executed READ  addr=0x102a data=0x18 |
| 14315 | hbus monitor | Collected READ  addr=0x102a data=0x18 |
| 14340 | hbus driver | Executed READ  addr=0x102b data=0x06 |
| 14345 | hbus monitor | Collected READ  addr=0x102b data=0x06 |
| 14370 | hbus driver | Executed READ  addr=0x102c data=0x27 |
| 14375 | hbus monitor | Collected READ  addr=0x102c data=0x27 |
| 14400 | hbus driver | Executed READ  addr=0x102d data=0xe6 |
| 14405 | hbus monitor | Collected READ  addr=0x102d data=0xe6 |
| 14430 | hbus driver | Executed READ  addr=0x102e data=0x80 |
| 14435 | hbus monitor | Collected READ  addr=0x102e data=0x80 |
| 14460 | hbus driver | Executed READ  addr=0x102f data=0x32 |
| 14465 | hbus monitor | Collected READ  addr=0x102f data=0x32 |
| 14490 | hbus driver | Executed READ  addr=0x1030 data=0xfd |
| 14495 | hbus monitor | Collected READ  addr=0x1030 data=0xfd |
| 14520 | hbus driver | Executed READ  addr=0x1031 data=0xfd |
| 14525 | hbus monitor | Collected READ  addr=0x1031 data=0xfd |
| 14550 | hbus driver | Executed READ  addr=0x1032 data=0x1f |
| 14555 | hbus monitor | Collected READ  addr=0x1032 data=0x1f |
| 14580 | hbus driver | Executed READ  addr=0x1033 data=0xac |
| 14585 | hbus monitor | Collected READ  addr=0x1033 data=0xac |
| 14610 | hbus driver | Executed READ  addr=0x1034 data=0x71 |
| 14615 | hbus monitor | Collected READ  addr=0x1034 data=0x71 |
| 14640 | hbus driver | Executed READ  addr=0x1035 data=0x7e |
| 14645 | hbus monitor | Collected READ  addr=0x1035 data=0x7e |
| 14670 | hbus driver | Executed READ  addr=0x1036 data=0xcc |
| 14675 | hbus monitor | Collected READ  addr=0x1036 data=0xcc |
| 14700 | hbus driver | Executed READ  addr=0x1037 data=0xdb |
| 14705 | hbus monitor | Collected READ  addr=0x1037 data=0xdb |
| 14730 | hbus driver | Executed READ  addr=0x1038 data=0x0c |
| 14735 | hbus monitor | Collected READ  addr=0x1038 data=0x0c |
| 14760 | hbus driver | Executed READ  addr=0x1039 data=0x0c |
| 14765 | hbus monitor | Collected READ  addr=0x1039 data=0x0c |
| 14790 | hbus driver | Executed READ  addr=0x103a data=0x1e |
| 14795 | hbus monitor | Collected READ  addr=0x103a data=0x1e |
| 14820 | hbus driver | Executed READ  addr=0x103b data=0x4f |
| 14825 | hbus monitor | Collected READ  addr=0x103b data=0x4f |
| 14850 | hbus driver | Executed READ  addr=0x103c data=0x22 |
| 14855 | hbus monitor | Collected READ  addr=0x103c data=0x22 |
| 14880 | hbus driver | Executed READ  addr=0x103d data=0xde |
| 14885 | hbus monitor | Collected READ  addr=0x103d data=0xde |
| 14910 | hbus driver | Executed READ  addr=0x103e data=0x73 |
| 14915 | hbus monitor | Collected READ  addr=0x103e data=0x73 |
| 14940 | hbus driver | Executed READ  addr=0x103f data=0xae |
| 14945 | hbus monitor | Collected READ  addr=0x103f data=0xae |
| 14970 | hbus driver | Executed READ  addr=0x1040 data=0x12 |
| 14975 | hbus monitor | Collected READ  addr=0x1040 data=0x12 |
| 15000 | hbus driver | Executed READ  addr=0x1041 data=0x25 |
| 15005 | hbus monitor | Collected READ  addr=0x1041 data=0x25 |
| 15030 | hbus driver | Executed READ  addr=0x1042 data=0xb9 |
| 15035 | hbus monitor | Collected READ  addr=0x1042 data=0xb9 |
| 15060 | hbus driver | Executed READ  addr=0x1043 data=0x07 |
| 15065 | hbus monitor | Collected READ  addr=0x1043 data=0x07 |
| 15090 | hbus driver | Executed READ  addr=0x1044 data=0x30 |
| 15095 | hbus monitor | Collected READ  addr=0x1044 data=0x30 |
| 15120 | hbus driver | Executed READ  addr=0x1045 data=0xb3 |
| 15125 | hbus monitor | Collected READ  addr=0x1045 data=0xb3 |
| 15150 | hbus driver | Executed READ  addr=0x1046 data=0x41 |
| 15155 | hbus monitor | Collected READ  addr=0x1046 data=0x41 |
| 15180 | hbus driver | Executed READ  addr=0x1047 data=0x2f |
| 15185 | hbus monitor | Collected READ  addr=0x1047 data=0x2f |
| 15210 | hbus driver | Executed READ  addr=0x1048 data=0xe4 |
| 15215 | hbus monitor | Collected READ  addr=0x1048 data=0xe4 |
| 15240 | hbus driver | Executed READ  addr=0x1049 data=0x8d |
| 15245 | hbus monitor | Collected READ  addr=0x1049 data=0x8d |
| 15270 | hbus driver | Executed READ  addr=0x104a data=0x03 |
| 15275 | hbus monitor | Collected READ  addr=0x104a data=0x03 |
| 15300 | hbus driver | Executed READ  addr=0x104b data=0x66 |
| 15305 | hbus monitor | Collected READ  addr=0x104b data=0x66 |
| 15330 | hbus driver | Executed READ  addr=0x104c data=0xff |
| 15335 | hbus monitor | Collected READ  addr=0x104c data=0xff |
| 15360 | hbus driver | Executed READ  addr=0x104d data=0xa5 |
| 15365 | hbus monitor | Collected READ  addr=0x104d data=0xa5 |
| 15390 | hbus driver | Executed READ  addr=0x104e data=0x4f |
| 15395 | hbus monitor | Collected READ  addr=0x104e data=0x4f |
| 15505 | **test** | STAGE: done: 24 packets (9 forwarded, 15 dropped), 0 storm burst(s), 9 scoreboard matches, 125 HBUS reads checked, 3 error pulses for 3 bad packets |
| 15705 | error checker | error pulse report: 3 bad packets, 3 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 15705 | ch0 monitor | Channel 0 report: 1 packets collected |
| 15705 | ch1 monitor | Channel 1 report: 3 packets collected |
| 15705 | ch2 monitor | Channel 2 report: 5 packets collected |
| 15705 | hbus monitor | HBUS report: 41 writes, 126 reads |
| 15705 | coverage | Coverage of the router configuration: 82.6% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 6 / 0 / 4 / 4 / 7 packets · length < max / = max / max+1 / > max+1 : 8 / 1 / 5 / 7 · forwarded good / bad : 9 / 0 · dropped address 3 good / bad : 1 / 0 · dropped oversized good / bad : 8 / 3 · counter enables none / mixed / all : 0 / 7 / 14 |
| 15705 | coverage | HBUS address coverage: 167 accesses sampled, coverage 53.2% |
| 15705 | coverage | HBUS register bits coverage: 14 writes to ctrl_reg/en_reg, coverage 93.2% |
| 15705 | coverage | HBUS counter value coverage: 11 counter reads sampled, coverage 51.9% |
| 15705 | coverage | HBUS yapp_mem data coverage: 54 accesses sampled, coverage 29.4% |
| 15705 | reference | --- Reference model report --- · forwarded to scoreboard : 9 · dropped (router disabled) : 3 · dropped (oversized) : 11 · dropped (address 3) : 1 · counters parity/oversized/addr0..3 : 3 / 12 / 5 4 11 0 |
| 15705 | reference | HBUS reads checked against the model: 125 (0 mismatches, 1 of memory bytes never written) |
| 15705 | scoreboard | --- Scoreboard report --- · packets received : 9 · packets matched : 9 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 15705 | yapp driver | YAPP driver report: 24 packets sent |
| 15705 | coverage | YAPP gap coverage: 23 gaps sampled, coverage 100.0% |
| 15705 | yapp monitor | YAPP monitor report: 24 packets collected, 3 with bad parity |
| 15705 | yapp monitor | YAPP gaps: 6 back to back, 2 of 1 cycle, 1 of 2, 14 longer |
| 15705 | coverage | YAPP packet coverage: 24 packets sampled, coverage 60.0% |
