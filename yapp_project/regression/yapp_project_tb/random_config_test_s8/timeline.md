# random_config_test seed 8

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 45us · wall 23.4 s · log [`random_config_test_s8.log`](random_config_test_s8.log)

Waves: `random_config_test_s8.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s8%2Frandom_config_test_s8.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **80** packet(s) (7 with bad parity); the input monitor saw 80.
- Router: **29** forwarded, **51** dropped (29 oversized, 2 illegal address 3, 20 router disabled).
- Packets out: ch0 **5**, ch1 **9**, ch2 **15**.
- Scoreboard: 29 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **2** time(s), longest hold 2 cycle(s).
- Error pulses: 5.
- HBUS: 39 write(s), 72 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 80 packets in 8 bursts |
| 340 | burst 1/8: ctrl=0x40 (maxpktsize 0) en=0x8b (router on, counter enables 1000101), 10 packet(s) |
| 5730 | burst 1/8 sent: addr0..3 1/3/5/1, bad parity 2, gap 0 0, length 1..63 |
| 5980 | burst 2/8: ctrl=0x3f (maxpktsize 63) en=0x1d (router on, counter enables 0001110), 9 packet(s) |
| 11200 | burst 2/8 sent: addr0..3 3/2/4/0, bad parity 0, gap 0 0, length 6..63 |
| 11410 | burst 3/8: ctrl=0xa6 (maxpktsize 38) en=0xff (router on, counter enables 1111111), 10 packet(s) |
| 16580 | burst 3/8 sent: addr0..3 2/3/4/1, bad parity 1, gap 0 1, length 11..63 |
| 17050 | burst 4/8: ctrl=0x83 (maxpktsize 3) en=0x8d (router on, counter enables 1000110), 10 packet(s) |
| 21200 | burst 4/8 sent: addr0..3 1/4/3/2, bad parity 1, gap 0 2, length 1..63 |
| 21440 | burst 5/8: ctrl=0x3e (maxpktsize 62) en=0x01 (router on, counter enables 0000000), 10 packet(s) |
| 26490 | burst 5/8 sent: addr0..3 0/4/6/0, bad parity 1, gap 0 0, length 1..63 |
| 26890 | burst 6/8: ctrl=0xbe (maxpktsize 62) en=0x68 (router OFF, counter enables 0110100), 10 packet(s) |
| 32420 | burst 6/8 sent: addr0..3 3/1/5/1, bad parity 2, gap 0 4, length 2..63 |
| 32630 | burst 7/8: ctrl=0x2e (maxpktsize 46) en=0x8a (router OFF, counter enables 1000101), 10 packet(s) |
| 36640 | burst 7/8 sent: addr0..3 2/2/5/1, bad parity 0, gap 0 0, length 5..63 |
| 37180 | burst 8/8: ctrl=0xfe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 43860 | burst 8/8 sent: addr0..3 4/2/5/0, bad parity 0, gap 0 2, length 1..63 |
| 43860 | final reads: every register and the stored packet, checked against the reference model |
| 44305 | done: 80 packets (29 forwarded, 51 dropped), 0 storm burst(s), 29 scoreboard matches, 70 HBUS reads checked, 5 error pulses for 5 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 0**

![first packet out on channel 0](wave_first_packet_out.svg)

**first back-pressure on the input port**

![first back-pressure on the input port](wave_first_suspend.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

1006 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 80 packets in 8 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x40 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 75 | reference | maxpktsize is now 0 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0x8b |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0x8b |
| 95 | reference | router_en is now 1 (en_reg 0x8b) |
| 110 | hbus driver | Executed WRITE addr=0x113d data=0x99 |
| 115 | hbus monitor | Collected WRITE addr=0x113d data=0x99 |
| 140 | hbus driver | Executed READ  addr=0x113d data=0x99 |
| 145 | hbus monitor | Collected READ  addr=0x113d data=0x99 |
| 160 | hbus driver | Executed WRITE addr=0x116c data=0xf0 |
| 165 | hbus monitor | Collected WRITE addr=0x116c data=0xf0 |
| 190 | hbus driver | Executed READ  addr=0x116c data=0xf0 |
| 195 | hbus monitor | Collected READ  addr=0x116c data=0xf0 |
| 220 | hbus driver | Executed READ  addr=0x102c data=0x00 |
| 225 | hbus monitor | Collected READ  addr=0x102c data=0x00 |
| 250 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 255 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 280 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 285 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 310 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 315 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 340 | hbus driver | Executed READ  addr=0x1045 data=0x00 |
| 340 | **test** | STAGE: burst 1/8: ctrl=0x40 (maxpktsize 0) en=0x8b (router on, counter enables 1000101), 10 packet(s) |
| 340 | yapp driver | TX pkt #1: addr=1 len=63 parity=good delay=1 |
| 345 | hbus monitor | Collected READ  addr=0x1045 data=0x00 |
| 365 | **DUT** | IN  pkt #1 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 1005 | **DUT** | IN  pkt #1 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1005 | yapp monitor | RX pkt #1 on the input: addr=1 len=63 parity=good gap=31 |
| 1005 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 1005 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 1010 | yapp driver | TX pkt #1 accepted by the DUT |
| 1010 | yapp driver | TX pkt #2: addr=2 len=1 parity=good delay=1 |
| 1025 | **DUT** | IN  pkt #2 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 1045 | **DUT** | IN  pkt #2 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 1045 | yapp monitor | RX pkt #2 on the input: addr=2 len=1 parity=good gap=1 |
| 1045 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 1045 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 1050 | yapp driver | TX pkt #2 accepted by the DUT |
| 1050 | yapp driver | TX pkt #3: addr=1 len=63 parity=good delay=3 |
| 1085 | **DUT** | IN  pkt #3 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 1725 | **DUT** | IN  pkt #3 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1725 | yapp monitor | RX pkt #3 on the input: addr=1 len=63 parity=good gap=3 |
| 1725 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 1725 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 1730 | yapp driver | TX pkt #3 accepted by the DUT |
| 1730 | yapp driver | TX pkt #4: addr=1 len=63 parity=good delay=3 |
| 1765 | **DUT** | IN  pkt #4 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 2405 | **DUT** | IN  pkt #4 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2405 | yapp monitor | RX pkt #4 on the input: addr=1 len=63 parity=good gap=3 |
| 2405 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 2405 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 2410 | yapp driver | TX pkt #4 accepted by the DUT |
| 2410 | yapp driver | TX pkt #5: addr=2 len=1 parity=good delay=19 |
| 2605 | **DUT** | IN  pkt #5 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 2625 | **DUT** | IN  pkt #5 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 2625 | yapp monitor | RX pkt #5 on the input: addr=2 len=1 parity=good gap=19 |
| 2625 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 2625 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 2630 | yapp driver | TX pkt #5 accepted by the DUT |
| 2630 | yapp driver | TX pkt #6: addr=0 len=1 parity=good delay=20 |
| 2835 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 2855 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 2855 | yapp monitor | RX pkt #6 on the input: addr=0 len=1 parity=good gap=20 |
| 2855 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 2855 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 2860 | yapp driver | TX pkt #6 accepted by the DUT |
| 2860 | yapp driver | TX pkt #7: addr=3 len=63 parity=good delay=14 |
| 3005 | **DUT** | IN  pkt #7 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 3645 | **DUT** | IN  pkt #7 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 3645 | yapp monitor | RX pkt #7 on the input: addr=3 len=63 parity=good gap=14 |
| 3645 | reference | Packet dropped: illegal address 3 (len=63) |
| 3645 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 3650 | yapp driver | TX pkt #7 accepted by the DUT |
| 3650 | yapp driver | TX pkt #8: addr=2 len=63 parity=good delay=1 |
| 3665 | **DUT** | IN  pkt #8 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 4305 | **DUT** | IN  pkt #8 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4305 | yapp monitor | RX pkt #8 on the input: addr=2 len=63 parity=good gap=1 |
| 4305 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 4305 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4310 | yapp driver | TX pkt #8 accepted by the DUT |
| 4310 | yapp driver | TX pkt #9: addr=2 len=50 parity=bad delay=10 |
| 4415 | **DUT** | IN  pkt #9 header: addr=2 len=50 -> DROP (oversized: len 50 > maxpktsize 0) |
| 4925 | **DUT** | IN  pkt #9 complete: addr=2 len=50 parity=BAD dropped, 52 bytes in 52 cycles (held 0) |
| 4925 | yapp monitor | RX pkt #9 on the input: addr=2 len=50 parity=bad gap=10 |
| 4925 | reference | Packet dropped: length 50 > maxpktsize 0 (addr=2) |
| 4925 | **DUT** | ROUTER DROPS PACKET addr=2 length=50 (length > maxpktsize) |
| 4930 | yapp driver | TX pkt #9 accepted by the DUT |
| 4930 | yapp driver | TX pkt #10: addr=2 len=63 parity=bad delay=15 |
| 5010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 5010 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 5085 | **DUT** | IN  pkt #10 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 5725 | **DUT** | IN  pkt #10 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 5725 | yapp monitor | RX pkt #10 on the input: addr=2 len=63 parity=bad gap=15 |
| 5725 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 5725 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 5730 | yapp driver | TX pkt #10 accepted by the DUT |
| 5730 | **test** | STAGE: burst 1/8 sent: addr0..3 1/3/5/1, bad parity 2, gap 0 0, length 1..63 |
| 5750 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 5755 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 5755 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 5755 | reference | maxpktsize is now 63 |
| 5770 | hbus driver | Executed WRITE addr=0x1001 data=0x1d |
| 5775 | hbus monitor | Collected WRITE addr=0x1001 data=0x1d |
| 5775 | reference | router_en is now 1 (en_reg 0x1d) |
| 5790 | hbus driver | Executed WRITE addr=0x1124 data=0x2b |
| 5795 | hbus monitor | Collected WRITE addr=0x1124 data=0x2b |
| 5810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 5810 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 5820 | hbus driver | Executed READ  addr=0x1124 data=0x2b |
| 5825 | hbus monitor | Collected READ  addr=0x1124 data=0x2b |
| 5840 | hbus driver | Executed WRITE addr=0x119e data=0x92 |
| 5845 | hbus monitor | Collected WRITE addr=0x119e data=0x92 |
| 5870 | hbus driver | Executed READ  addr=0x119e data=0x92 |
| 5875 | hbus monitor | Collected READ  addr=0x119e data=0x92 |
| 5900 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 5905 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5930 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 5935 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 5950 | hbus driver | Executed WRITE addr=0x11fa data=0x90 |
| 5955 | hbus monitor | Collected WRITE addr=0x11fa data=0x90 |
| 5980 | hbus driver | Executed READ  addr=0x11fa data=0x90 |
| 5980 | **test** | STAGE: burst 2/8: ctrl=0x3f (maxpktsize 63) en=0x1d (router on, counter enables 0001110), 9 packet(s) |
| 5980 | yapp driver | TX pkt #11: addr=0 len=63 parity=good delay=11 |
| 5985 | hbus monitor | Collected READ  addr=0x11fa data=0x90 |
| 6105 | **DUT** | IN  pkt #11 header: addr=0 len=63 -> channel 0 |
| 6115 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=63 (receiver waited 0 cycle(s)) |
| 6745 | **DUT** | IN  pkt #11 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 6745 | yapp monitor | RX pkt #11 on the input: addr=0 len=63 parity=good gap=37 |
| 6745 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 6750 | ch0 driver | ch0: packet consumed (response delay 0) |
| 6750 | yapp driver | TX pkt #11 accepted by the DUT |
| 6750 | yapp driver | TX pkt #12: addr=2 len=48 parity=good delay=20 |
| 6765 | **DUT** | OUT ch0 pkt #1 done: 65 bytes in 66 cycles |
| 6765 | ch0 monitor | ch0 RX pkt #1: addr=0 len=63 parity=good |
| 6765 | scoreboard | ch0 pkt matched: addr=0 len=63 (1 matched so far) |
| 6770 | ch0 driver | ch0: packet consumed (response delay 0) |
| 6955 | **DUT** | IN  pkt #12 header: addr=2 len=48 -> channel 2 |
| 6965 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=48 (receiver waited 0 cycle(s)) |
| 7445 | **DUT** | IN  pkt #12 complete: addr=2 len=48 parity=ok forwarded, 50 bytes in 50 cycles (held 0) |
| 7445 | yapp monitor | RX pkt #12 on the input: addr=2 len=48 parity=good gap=20 |
| 7445 | reference | Packet forwarded: addr=2 len=48 -> channel 2 |
| 7450 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7450 | yapp driver | TX pkt #12 accepted by the DUT |
| 7450 | yapp driver | TX pkt #13: addr=0 len=62 parity=good delay=3 |
| 7465 | **DUT** | OUT ch2 pkt #1 done: 50 bytes in 51 cycles |
| 7465 | ch2 monitor | ch2 RX pkt #1: addr=2 len=48 parity=good |
| 7465 | scoreboard | ch2 pkt matched: addr=2 len=48 (2 matched so far) |
| 7485 | **DUT** | IN  pkt #13 header: addr=0 len=62 -> channel 0 |
| 7495 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=62 (receiver waited 0 cycle(s)) |
| 8010 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8115 | **DUT** | IN  pkt #13 complete: addr=0 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 8115 | yapp monitor | RX pkt #13 on the input: addr=0 len=62 parity=good gap=3 |
| 8115 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 8120 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8120 | yapp driver | TX pkt #13 accepted by the DUT |
| 8120 | yapp driver | TX pkt #14: addr=2 len=34 parity=good delay=2 |
| 8135 | **DUT** | OUT ch0 pkt #2 done: 64 bytes in 65 cycles |
| 8135 | ch0 monitor | ch0 RX pkt #2: addr=0 len=62 parity=good |
| 8135 | scoreboard | ch0 pkt matched: addr=0 len=62 (3 matched so far) |
| 8145 | **DUT** | IN  pkt #14 header: addr=2 len=34 -> channel 2 |
| 8155 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=34 (receiver waited 0 cycle(s)) |
| 8495 | **DUT** | IN  pkt #14 complete: addr=2 len=34 parity=ok forwarded, 36 bytes in 36 cycles (held 0) |
| 8495 | yapp monitor | RX pkt #14 on the input: addr=2 len=34 parity=good gap=2 |
| 8495 | reference | Packet forwarded: addr=2 len=34 -> channel 2 |
| 8500 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8500 | yapp driver | TX pkt #14 accepted by the DUT |
| 8500 | yapp driver | TX pkt #15: addr=2 len=52 parity=good delay=5 |
| 8515 | **DUT** | OUT ch2 pkt #2 done: 36 bytes in 37 cycles |
| 8515 | ch2 monitor | ch2 RX pkt #2: addr=2 len=34 parity=good |
| 8515 | scoreboard | ch2 pkt matched: addr=2 len=34 (4 matched so far) |
| 8530 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8555 | **DUT** | IN  pkt #15 header: addr=2 len=52 -> channel 2 |
| 8565 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=52 (receiver waited 0 cycle(s)) |
| 9060 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9085 | **DUT** | IN  pkt #15 complete: addr=2 len=52 parity=ok forwarded, 54 bytes in 54 cycles (held 0) |
| 9085 | yapp monitor | RX pkt #15 on the input: addr=2 len=52 parity=good gap=5 |
| 9085 | reference | Packet forwarded: addr=2 len=52 -> channel 2 |
| 9090 | yapp driver | TX pkt #15 accepted by the DUT |
| 9090 | yapp driver | TX pkt #16: addr=1 len=6 parity=good delay=14 |
| 9105 | **DUT** | OUT ch2 pkt #3 done: 54 bytes in 55 cycles |
| 9105 | ch2 monitor | ch2 RX pkt #3: addr=2 len=52 parity=good |
| 9105 | scoreboard | ch2 pkt matched: addr=2 len=52 (5 matched so far) |
| 9235 | **DUT** | IN  pkt #16 header: addr=1 len=6 -> channel 1 |
| 9305 | **DUT** | IN  pkt #16 complete: addr=1 len=6 parity=ok forwarded, 8 bytes in 8 cycles (held 0) |
| 9305 | yapp monitor | RX pkt #16 on the input: addr=1 len=6 parity=good gap=14 |
| 9305 | reference | Packet forwarded: addr=1 len=6 -> channel 1 |
| 9310 | yapp driver | TX pkt #16 accepted by the DUT |
| 9310 | yapp driver | TX pkt #17: addr=1 len=63 parity=good delay=3 |
| 9335 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=6 (receiver waited 9 cycle(s)) |
| 9345 | **DUT** | IN  pkt #17 header: addr=1 len=63 -> channel 1 |
| 9400 | ch1 driver | ch1: packet consumed (response delay 9) |
| 9495 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0xfd held (pkt #17) |
| 9495 | **DUT** | OUT ch1 pkt #1 done: 8 bytes in 17 cycles |
| 9495 | ch1 monitor | ch1 RX pkt #1: addr=1 len=6 parity=good |
| 9495 | scoreboard | ch1 pkt matched: addr=1 len=6 (6 matched so far) |
| 9505 | **DUT** | SUSPEND released after 1 cycle(s) |
| 9505 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=63 (receiver waited 0 cycle(s)) |
| 9540 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9610 | ch1 driver | ch1: packet consumed (response delay 8) |
| 9625 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0xa3 held (pkt #17) |
| 9645 | **DUT** | SUSPEND released after 2 cycle(s) |
| 10015 | **DUT** | IN  pkt #17 complete: addr=1 len=63 parity=ok forwarded, 65 bytes in 68 cycles (held 3) |
| 10015 | yapp monitor | RX pkt #17 on the input: addr=1 len=63 parity=good gap=3 |
| 10015 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 10020 | ch1 driver | ch1: packet consumed (response delay 1) |
| 10020 | yapp driver | TX pkt #17 accepted by the DUT |
| 10020 | yapp driver | TX pkt #18: addr=2 len=62 parity=good delay=5 |
| 10075 | **DUT** | IN  pkt #18 header: addr=2 len=62 -> channel 2 |
| 10085 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 10130 | ch1 driver | ch1: packet consumed (response delay 8) |
| 10305 | **DUT** | OUT ch1 pkt #2 done: 65 bytes in 81 cycles |
| 10305 | ch1 monitor | ch1 RX pkt #2: addr=1 len=63 parity=good |
| 10305 | scoreboard | ch1 pkt matched: addr=1 len=63 (7 matched so far) |
| 10320 | ch1 driver | ch1: packet consumed (response delay 4) |
| 10705 | **DUT** | IN  pkt #18 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 10705 | yapp monitor | RX pkt #18 on the input: addr=2 len=62 parity=good gap=5 |
| 10705 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 10710 | ch2 driver | ch2: packet consumed (response delay 0) |
| 10710 | yapp driver | TX pkt #18 accepted by the DUT |
| 10710 | yapp driver | TX pkt #19: addr=0 len=44 parity=good delay=3 |
| 10725 | **DUT** | OUT ch2 pkt #4 done: 64 bytes in 65 cycles |
| 10725 | ch2 monitor | ch2 RX pkt #4: addr=2 len=62 parity=good |
| 10725 | scoreboard | ch2 pkt matched: addr=2 len=62 (8 matched so far) |
| 10745 | **DUT** | IN  pkt #19 header: addr=0 len=44 -> channel 0 |
| 10755 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=44 (receiver waited 0 cycle(s)) |
| 11130 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11195 | **DUT** | IN  pkt #19 complete: addr=0 len=44 parity=ok forwarded, 46 bytes in 46 cycles (held 0) |
| 11195 | yapp monitor | RX pkt #19 on the input: addr=0 len=44 parity=good gap=3 |
| 11195 | reference | Packet forwarded: addr=0 len=44 -> channel 0 |
| 11200 | ch0 driver | ch0: packet consumed (response delay 0) |
| 11200 | yapp driver | TX pkt #19 accepted by the DUT |
| 11200 | **test** | STAGE: burst 2/8 sent: addr0..3 3/2/4/0, bad parity 0, gap 0 0, length 6..63 |
| 11215 | **DUT** | OUT ch0 pkt #3 done: 46 bytes in 47 cycles |
| 11215 | ch0 monitor | ch0 RX pkt #3: addr=0 len=44 parity=good |
| 11215 | scoreboard | ch0 pkt matched: addr=0 len=44 (9 matched so far) |
| 11220 | hbus driver | Executed WRITE addr=0x1000 data=0xa6 |
| 11225 | **DUT** | CONFIG router_en=1 maxpktsize=38 |
| 11225 | hbus monitor | Collected WRITE addr=0x1000 data=0xa6 |
| 11225 | reference | maxpktsize is now 38 |
| 11240 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 11245 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 11245 | reference | router_en is now 1 (en_reg 0xff) |
| 11260 | hbus driver | Executed WRITE addr=0x1117 data=0xe9 |
| 11265 | hbus monitor | Collected WRITE addr=0x1117 data=0xe9 |
| 11290 | hbus driver | Executed READ  addr=0x1117 data=0xe9 |
| 11295 | hbus monitor | Collected READ  addr=0x1117 data=0xe9 |
| 11320 | hbus driver | Executed READ  addr=0x1006 data=0x01 |
| 11325 | hbus monitor | Collected READ  addr=0x1006 data=0x01 |
| 11350 | hbus driver | Executed READ  addr=0x100d data=0x2c |
| 11355 | hbus monitor | Collected READ  addr=0x100d data=0x2c |
| 11380 | hbus driver | Executed READ  addr=0x100d data=0x2c |
| 11385 | hbus monitor | Collected READ  addr=0x100d data=0x2c |
| 11410 | ch0 driver | ch0: packet consumed (response delay 0) |
| 11410 | hbus driver | Executed READ  addr=0x101a data=0x64 |
| 11410 | **test** | STAGE: burst 3/8: ctrl=0xa6 (maxpktsize 38) en=0xff (router on, counter enables 1111111), 10 packet(s) |
| 11410 | yapp driver | TX pkt #20: addr=2 len=26 parity=good delay=0 |
| 11415 | hbus monitor | Collected READ  addr=0x101a data=0x64 |
| 11425 | **DUT** | IN  pkt #20 header: addr=2 len=26 -> channel 2 |
| 11435 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=26 (receiver waited 0 cycle(s)) |
| 11695 | **DUT** | IN  pkt #20 complete: addr=2 len=26 parity=ok forwarded, 28 bytes in 28 cycles (held 0) |
| 11695 | yapp monitor | RX pkt #20 on the input: addr=2 len=26 parity=good gap=22 |
| 11695 | reference | Packet forwarded: addr=2 len=26 -> channel 2 |
| 11700 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11700 | yapp driver | TX pkt #20 accepted by the DUT |
| 11700 | yapp driver | TX pkt #21: addr=2 len=30 parity=bad delay=10 |
| 11715 | **DUT** | OUT ch2 pkt #5 done: 28 bytes in 29 cycles |
| 11715 | ch2 monitor | ch2 RX pkt #5: addr=2 len=26 parity=good |
| 11715 | scoreboard | ch2 pkt matched: addr=2 len=26 (10 matched so far) |
| 11805 | **DUT** | IN  pkt #21 header: addr=2 len=30 -> channel 2 |
| 11815 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=30 (receiver waited 0 cycle(s)) |
| 11830 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12010 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12115 | **DUT** | IN  pkt #21 complete: addr=2 len=30 parity=BAD forwarded, 32 bytes in 32 cycles (held 0) |
| 12115 | yapp monitor | RX pkt #21 on the input: addr=2 len=30 parity=bad gap=10 |
| 12115 | reference | Packet forwarded: addr=2 len=30 -> channel 2 |
| 12120 | yapp driver | TX pkt #21 accepted by the DUT |
| 12120 | yapp driver | TX pkt #22: addr=1 len=63 parity=good delay=20 |
| 12145 | **DUT** | OUT ch2 pkt #6 done: 32 bytes in 34 cycles |
| 12145 | ch2 monitor | ch2 RX pkt #6: addr=2 len=30 parity=bad |
| 12145 | scoreboard | ch2 pkt matched: addr=2 len=30 (11 matched so far) |
| 12190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 12190 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 12325 | **DUT** | IN  pkt #22 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 38) |
| 12400 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12965 | **DUT** | IN  pkt #22 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12965 | yapp monitor | RX pkt #22 on the input: addr=1 len=63 parity=good gap=20 |
| 12965 | reference | Packet dropped: length 63 > maxpktsize 38 (addr=1) |
| 12965 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 12970 | yapp driver | TX pkt #22 accepted by the DUT |
| 12970 | yapp driver | TX pkt #23: addr=1 len=37 parity=good delay=2 |
| 12995 | **DUT** | IN  pkt #23 header: addr=1 len=37 -> channel 1 |
| 13105 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=37 (receiver waited 10 cycle(s)) |
| 13375 | **DUT** | IN  pkt #23 complete: addr=1 len=37 parity=ok forwarded, 39 bytes in 39 cycles (held 0) |
| 13375 | yapp monitor | RX pkt #23 on the input: addr=1 len=37 parity=good gap=2 |
| 13375 | reference | Packet forwarded: addr=1 len=37 -> channel 1 |
| 13380 | yapp driver | TX pkt #23 accepted by the DUT |
| 13380 | yapp driver | TX pkt #24: addr=2 len=37 parity=good delay=4 |
| 13425 | **DUT** | IN  pkt #24 header: addr=2 len=37 -> channel 2 |
| 13435 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=37 (receiver waited 0 cycle(s)) |
| 13480 | ch1 driver | ch1: packet consumed (response delay 10) |
| 13575 | **DUT** | OUT ch1 pkt #3 done: 39 bytes in 48 cycles |
| 13575 | ch1 monitor | ch1 RX pkt #3: addr=1 len=37 parity=good |
| 13575 | scoreboard | ch1 pkt matched: addr=1 len=37 (12 matched so far) |
| 13805 | **DUT** | IN  pkt #24 complete: addr=2 len=37 parity=ok forwarded, 39 bytes in 39 cycles (held 0) |
| 13805 | yapp monitor | RX pkt #24 on the input: addr=2 len=37 parity=good gap=4 |
| 13805 | reference | Packet forwarded: addr=2 len=37 -> channel 2 |
| 13810 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13810 | yapp driver | TX pkt #24 accepted by the DUT |
| 13810 | yapp driver | TX pkt #25: addr=0 len=62 parity=good delay=17 |
| 13825 | **DUT** | OUT ch2 pkt #7 done: 39 bytes in 40 cycles |
| 13825 | ch2 monitor | ch2 RX pkt #7: addr=2 len=37 parity=good |
| 13825 | scoreboard | ch2 pkt matched: addr=2 len=37 (13 matched so far) |
| 13985 | **DUT** | IN  pkt #25 header: addr=0 len=62 -> DROP (oversized: len 62 > maxpktsize 38) |
| 14040 | ch1 driver | ch1: packet consumed (response delay 8) |
| 14450 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14615 | **DUT** | IN  pkt #25 complete: addr=0 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 14615 | yapp monitor | RX pkt #25 on the input: addr=0 len=62 parity=good gap=17 |
| 14615 | reference | Packet dropped: length 62 > maxpktsize 38 (addr=0) |
| 14615 | **DUT** | ROUTER DROPS PACKET addr=0 length=62 (length > maxpktsize) |
| 14620 | yapp driver | TX pkt #25 accepted by the DUT |
| 14620 | yapp driver | TX pkt #26: addr=1 len=11 parity=good delay=14 |
| 14765 | **DUT** | IN  pkt #26 header: addr=1 len=11 -> channel 1 |
| 14775 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=11 (receiver waited 0 cycle(s)) |
| 14885 | **DUT** | IN  pkt #26 complete: addr=1 len=11 parity=ok forwarded, 13 bytes in 13 cycles (held 0) |
| 14885 | yapp monitor | RX pkt #26 on the input: addr=1 len=11 parity=good gap=14 |
| 14885 | reference | Packet forwarded: addr=1 len=11 -> channel 1 |
| 14890 | ch1 driver | ch1: packet consumed (response delay 0) |
| 14890 | yapp driver | TX pkt #26 accepted by the DUT |
| 14890 | yapp driver | TX pkt #27: addr=3 len=37 parity=good delay=9 |
| 14985 | **DUT** | IN  pkt #27 header: addr=3 len=37 -> DROP (illegal address 3) |
| 14985 | **DUT** | OUT ch1 pkt #4 done: 13 bytes in 22 cycles |
| 14985 | ch1 monitor | ch1 RX pkt #4: addr=1 len=11 parity=good |
| 14985 | scoreboard | ch1 pkt matched: addr=1 len=11 (14 matched so far) |
| 15365 | **DUT** | IN  pkt #27 complete: addr=3 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 15365 | yapp monitor | RX pkt #27 on the input: addr=3 len=37 parity=good gap=9 |
| 15365 | reference | Packet dropped: illegal address 3 (len=37) |
| 15365 | **DUT** | ROUTER DROPS PACKET addr=3 length=37 (    illegal address) |
| 15370 | yapp driver | TX pkt #27 accepted by the DUT |
| 15370 | yapp driver | TX pkt #28: addr=2 len=29 parity=good delay=12 |
| 15450 | ch1 driver | ch1: packet consumed (response delay 8) |
| 15495 | **DUT** | IN  pkt #28 header: addr=2 len=29 -> channel 2 |
| 15505 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=29 (receiver waited 0 cycle(s)) |
| 15795 | **DUT** | IN  pkt #28 complete: addr=2 len=29 parity=ok forwarded, 31 bytes in 31 cycles (held 0) |
| 15795 | yapp monitor | RX pkt #28 on the input: addr=2 len=29 parity=good gap=12 |
| 15795 | reference | Packet forwarded: addr=2 len=29 -> channel 2 |
| 15800 | ch2 driver | ch2: packet consumed (response delay 0) |
| 15800 | yapp driver | TX pkt #28 accepted by the DUT |
| 15800 | yapp driver | TX pkt #29: addr=0 len=63 parity=good delay=13 |
| 15815 | **DUT** | OUT ch2 pkt #8 done: 31 bytes in 32 cycles |
| 15815 | ch2 monitor | ch2 RX pkt #8: addr=2 len=29 parity=good |
| 15815 | scoreboard | ch2 pkt matched: addr=2 len=29 (15 matched so far) |
| 15935 | **DUT** | IN  pkt #29 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 38) |
| 16410 | ch2 driver | ch2: packet consumed (response delay 0) |
| 16575 | **DUT** | IN  pkt #29 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 16575 | yapp monitor | RX pkt #29 on the input: addr=0 len=63 parity=good gap=13 |
| 16575 | reference | Packet dropped: length 63 > maxpktsize 38 (addr=0) |
| 16575 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 16580 | yapp driver | TX pkt #29 accepted by the DUT |
| 16580 | **test** | STAGE: burst 3/8 sent: addr0..3 2/3/4/1, bad parity 1, gap 0 1, length 11..63 |
| 16600 | hbus driver | Executed WRITE addr=0x1000 data=0x83 |
| 16605 | **DUT** | CONFIG router_en=1 maxpktsize=3 |
| 16605 | hbus monitor | Collected WRITE addr=0x1000 data=0x83 |
| 16605 | reference | maxpktsize is now 3 |
| 16620 | hbus driver | Executed WRITE addr=0x1001 data=0x8d |
| 16625 | hbus monitor | Collected WRITE addr=0x1001 data=0x8d |
| 16625 | reference | router_en is now 1 (en_reg 0x8d) |
| 16650 | hbus driver | Executed READ  addr=0x1001 data=0x8d |
| 16655 | hbus monitor | Collected READ  addr=0x1001 data=0x8d |
| 16670 | hbus driver | Executed WRITE addr=0x119c data=0x3d |
| 16675 | hbus monitor | Collected WRITE addr=0x119c data=0x3d |
| 16700 | hbus driver | Executed READ  addr=0x119c data=0x3d |
| 16705 | hbus monitor | Collected READ  addr=0x119c data=0x3d |
| 16730 | hbus driver | Executed READ  addr=0x1021 data=0x57 |
| 16735 | hbus monitor | Collected READ  addr=0x1021 data=0x57 |
| 16750 | hbus driver | Executed WRITE addr=0x11ad data=0x3f |
| 16755 | hbus monitor | Collected WRITE addr=0x11ad data=0x3f |
| 16780 | hbus driver | Executed READ  addr=0x11ad data=0x3f |
| 16785 | hbus monitor | Collected READ  addr=0x11ad data=0x3f |
| 16800 | hbus driver | Executed WRITE addr=0x116b data=0x0e |
| 16805 | hbus monitor | Collected WRITE addr=0x116b data=0x0e |
| 16830 | hbus driver | Executed READ  addr=0x116b data=0x0e |
| 16835 | hbus monitor | Collected READ  addr=0x116b data=0x0e |
| 16860 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 16865 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 16880 | hbus driver | Executed WRITE addr=0x11a9 data=0x24 |
| 16885 | hbus monitor | Collected WRITE addr=0x11a9 data=0x24 |
| 16910 | hbus driver | Executed READ  addr=0x11a9 data=0x24 |
| 16915 | hbus monitor | Collected READ  addr=0x11a9 data=0x24 |
| 16940 | hbus driver | Executed READ  addr=0x1001 data=0x8d |
| 16945 | hbus monitor | Collected READ  addr=0x1001 data=0x8d |
| 16970 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 16975 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 17000 | hbus driver | Executed READ  addr=0x1035 data=0xd6 |
| 17005 | hbus monitor | Collected READ  addr=0x1035 data=0xd6 |
| 17020 | hbus driver | Executed WRITE addr=0x112a data=0xf4 |
| 17025 | hbus monitor | Collected WRITE addr=0x112a data=0xf4 |
| 17050 | hbus driver | Executed READ  addr=0x112a data=0xf4 |
| 17050 | **test** | STAGE: burst 4/8: ctrl=0x83 (maxpktsize 3) en=0x8d (router on, counter enables 1000110), 10 packet(s) |
| 17050 | yapp driver | TX pkt #30: addr=3 len=3 parity=good delay=0 |
| 17055 | hbus monitor | Collected READ  addr=0x112a data=0xf4 |
| 17065 | **DUT** | IN  pkt #30 header: addr=3 len=3 -> DROP (illegal address 3) |
| 17105 | **DUT** | IN  pkt #30 complete: addr=3 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 17105 | yapp monitor | RX pkt #30 on the input: addr=3 len=3 parity=good gap=48 |
| 17105 | reference | Packet dropped: illegal address 3 (len=3) |
| 17105 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 17110 | yapp driver | TX pkt #30 accepted by the DUT |
| 17110 | yapp driver | TX pkt #31: addr=1 len=63 parity=bad delay=10 |
| 17215 | **DUT** | IN  pkt #31 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 17855 | **DUT** | IN  pkt #31 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 17855 | yapp monitor | RX pkt #31 on the input: addr=1 len=63 parity=bad gap=10 |
| 17855 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=1) |
| 17855 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 17860 | yapp driver | TX pkt #31 accepted by the DUT |
| 17860 | yapp driver | TX pkt #32: addr=1 len=1 parity=good delay=0 |
| 17865 | **DUT** | IN  pkt #32 header: addr=1 len=1 -> channel 1 |
| 17875 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 17885 | **DUT** | IN  pkt #32 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17885 | yapp monitor | RX pkt #32 on the input: addr=1 len=1 parity=good gap=0 |
| 17885 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 17890 | ch1 driver | ch1: packet consumed (response delay 0) |
| 17890 | yapp driver | TX pkt #32 accepted by the DUT |
| 17890 | yapp driver | TX pkt #33: addr=1 len=63 parity=good delay=2 |
| 17910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 17910 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 17915 | **DUT** | IN  pkt #33 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 17975 | **DUT** | OUT ch1 pkt #5 done: 3 bytes in 11 cycles |
| 17975 | ch1 monitor | ch1 RX pkt #5: addr=1 len=1 parity=good |
| 17975 | scoreboard | ch1 pkt matched: addr=1 len=1 (16 matched so far) |
| 18460 | ch1 driver | ch1: packet consumed (response delay 7) |
| 18555 | **DUT** | IN  pkt #33 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 18555 | yapp monitor | RX pkt #33 on the input: addr=1 len=63 parity=good gap=2 |
| 18555 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=1) |
| 18555 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 18560 | yapp driver | TX pkt #33 accepted by the DUT |
| 18560 | yapp driver | TX pkt #34: addr=2 len=63 parity=good delay=1 |
| 18575 | **DUT** | IN  pkt #34 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 19215 | **DUT** | IN  pkt #34 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 19215 | yapp monitor | RX pkt #34 on the input: addr=2 len=63 parity=good gap=1 |
| 19215 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=2) |
| 19215 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 19220 | yapp driver | TX pkt #34 accepted by the DUT |
| 19220 | yapp driver | TX pkt #35: addr=1 len=63 parity=good delay=20 |
| 19425 | **DUT** | IN  pkt #35 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 20065 | **DUT** | IN  pkt #35 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 20065 | yapp monitor | RX pkt #35 on the input: addr=1 len=63 parity=good gap=20 |
| 20065 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=1) |
| 20065 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 20070 | yapp driver | TX pkt #35 accepted by the DUT |
| 20070 | yapp driver | TX pkt #36: addr=3 len=16 parity=good delay=5 |
| 20125 | **DUT** | IN  pkt #36 header: addr=3 len=16 -> DROP (oversized: len 16 > maxpktsize 3) |
| 20295 | **DUT** | IN  pkt #36 complete: addr=3 len=16 parity=ok dropped, 18 bytes in 18 cycles (held 0) |
| 20295 | yapp monitor | RX pkt #36 on the input: addr=3 len=16 parity=good gap=5 |
| 20295 | reference | Packet dropped: illegal address 3 (len=16) |
| 20295 | **DUT** | ROUTER DROPS PACKET addr=3 length=16 (    illegal address) |
| 20300 | yapp driver | TX pkt #36 accepted by the DUT |
| 20300 | yapp driver | TX pkt #37: addr=0 len=2 parity=good delay=1 |
| 20315 | **DUT** | IN  pkt #37 header: addr=0 len=2 -> channel 0 |
| 20325 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 20345 | **DUT** | IN  pkt #37 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 20345 | yapp monitor | RX pkt #37 on the input: addr=0 len=2 parity=good gap=1 |
| 20345 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 20350 | ch0 driver | ch0: packet consumed (response delay 0) |
| 20350 | yapp driver | TX pkt #37 accepted by the DUT |
| 20350 | yapp driver | TX pkt #38: addr=2 len=14 parity=good delay=2 |
| 20365 | **DUT** | OUT ch0 pkt #4 done: 4 bytes in 5 cycles |
| 20365 | ch0 monitor | ch0 RX pkt #4: addr=0 len=2 parity=good |
| 20365 | scoreboard | ch0 pkt matched: addr=0 len=2 (17 matched so far) |
| 20375 | **DUT** | IN  pkt #38 header: addr=2 len=14 -> DROP (oversized: len 14 > maxpktsize 3) |
| 20525 | **DUT** | IN  pkt #38 complete: addr=2 len=14 parity=ok dropped, 16 bytes in 16 cycles (held 0) |
| 20525 | yapp monitor | RX pkt #38 on the input: addr=2 len=14 parity=good gap=2 |
| 20525 | reference | Packet dropped: length 14 > maxpktsize 3 (addr=2) |
| 20525 | **DUT** | ROUTER DROPS PACKET addr=2 length=14 (length > maxpktsize) |
| 20530 | yapp driver | TX pkt #38 accepted by the DUT |
| 20530 | yapp driver | TX pkt #39: addr=2 len=63 parity=good delay=2 |
| 20555 | **DUT** | IN  pkt #39 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 3) |
| 20670 | ch0 driver | ch0: packet consumed (response delay 0) |
| 21195 | **DUT** | IN  pkt #39 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 21195 | yapp monitor | RX pkt #39 on the input: addr=2 len=63 parity=good gap=2 |
| 21195 | reference | Packet dropped: length 63 > maxpktsize 3 (addr=2) |
| 21195 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 21200 | yapp driver | TX pkt #39 accepted by the DUT |
| 21200 | **test** | STAGE: burst 4/8 sent: addr0..3 1/4/3/2, bad parity 1, gap 0 2, length 1..63 |
| 21220 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 21225 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 21225 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 21225 | reference | maxpktsize is now 62 |
| 21240 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 21245 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 21245 | reference | router_en is now 1 (en_reg 0x01) |
| 21270 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 21275 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 21300 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 21305 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 21330 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 21335 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 21360 | hbus driver | Executed READ  addr=0x100a data=0x03 |
| 21365 | hbus monitor | Collected READ  addr=0x100a data=0x03 |
| 21390 | hbus driver | Executed READ  addr=0x104c data=0xec |
| 21395 | hbus monitor | Collected READ  addr=0x104c data=0xec |
| 21410 | hbus driver | Executed WRITE addr=0x11e7 data=0x07 |
| 21415 | hbus monitor | Collected WRITE addr=0x11e7 data=0x07 |
| 21440 | hbus driver | Executed READ  addr=0x11e7 data=0x07 |
| 21440 | **test** | STAGE: burst 5/8: ctrl=0x3e (maxpktsize 62) en=0x01 (router on, counter enables 0000000), 10 packet(s) |
| 21440 | yapp driver | TX pkt #40: addr=2 len=63 parity=good delay=1 |
| 21445 | hbus monitor | Collected READ  addr=0x11e7 data=0x07 |
| 21465 | **DUT** | IN  pkt #40 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 22105 | **DUT** | IN  pkt #40 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 22105 | yapp monitor | RX pkt #40 on the input: addr=2 len=63 parity=good gap=26 |
| 22105 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 22105 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 22110 | yapp driver | TX pkt #40 accepted by the DUT |
| 22110 | yapp driver | TX pkt #41: addr=2 len=20 parity=good delay=10 |
| 22215 | **DUT** | IN  pkt #41 header: addr=2 len=20 -> channel 2 |
| 22225 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=20 (receiver waited 0 cycle(s)) |
| 22425 | **DUT** | IN  pkt #41 complete: addr=2 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 22425 | yapp monitor | RX pkt #41 on the input: addr=2 len=20 parity=good gap=10 |
| 22425 | reference | Packet forwarded: addr=2 len=20 -> channel 2 |
| 22430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22430 | yapp driver | TX pkt #41 accepted by the DUT |
| 22430 | yapp driver | TX pkt #42: addr=1 len=16 parity=good delay=19 |
| 22445 | **DUT** | OUT ch2 pkt #9 done: 22 bytes in 23 cycles |
| 22445 | ch2 monitor | ch2 RX pkt #9: addr=2 len=20 parity=good |
| 22445 | scoreboard | ch2 pkt matched: addr=2 len=20 (18 matched so far) |
| 22550 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22625 | **DUT** | IN  pkt #42 header: addr=1 len=16 -> channel 1 |
| 22635 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=16 (receiver waited 0 cycle(s)) |
| 22795 | **DUT** | IN  pkt #42 complete: addr=1 len=16 parity=ok forwarded, 18 bytes in 18 cycles (held 0) |
| 22795 | yapp monitor | RX pkt #42 on the input: addr=1 len=16 parity=good gap=19 |
| 22795 | reference | Packet forwarded: addr=1 len=16 -> channel 1 |
| 22800 | ch1 driver | ch1: packet consumed (response delay 0) |
| 22800 | yapp driver | TX pkt #42 accepted by the DUT |
| 22800 | yapp driver | TX pkt #43: addr=2 len=29 parity=good delay=3 |
| 22835 | **DUT** | IN  pkt #43 header: addr=2 len=29 -> channel 2 |
| 22845 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=29 (receiver waited 0 cycle(s)) |
| 22915 | **DUT** | OUT ch1 pkt #6 done: 18 bytes in 29 cycles |
| 22915 | ch1 monitor | ch1 RX pkt #6: addr=1 len=16 parity=good |
| 22915 | scoreboard | ch1 pkt matched: addr=1 len=16 (19 matched so far) |
| 23135 | **DUT** | IN  pkt #43 complete: addr=2 len=29 parity=ok forwarded, 31 bytes in 31 cycles (held 0) |
| 23135 | yapp monitor | RX pkt #43 on the input: addr=2 len=29 parity=good gap=3 |
| 23135 | reference | Packet forwarded: addr=2 len=29 -> channel 2 |
| 23140 | ch2 driver | ch2: packet consumed (response delay 0) |
| 23140 | yapp driver | TX pkt #43 accepted by the DUT |
| 23140 | yapp driver | TX pkt #44: addr=1 len=63 parity=good delay=20 |
| 23155 | **DUT** | OUT ch2 pkt #10 done: 31 bytes in 32 cycles |
| 23155 | ch2 monitor | ch2 RX pkt #10: addr=2 len=29 parity=good |
| 23155 | scoreboard | ch2 pkt matched: addr=2 len=29 (20 matched so far) |
| 23345 | **DUT** | IN  pkt #44 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 23430 | ch1 driver | ch1: packet consumed (response delay 10) |
| 23580 | ch2 driver | ch2: packet consumed (response delay 0) |
| 23985 | **DUT** | IN  pkt #44 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 23985 | yapp monitor | RX pkt #44 on the input: addr=1 len=63 parity=good gap=20 |
| 23985 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 23985 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 23990 | yapp driver | TX pkt #44 accepted by the DUT |
| 23990 | yapp driver | TX pkt #45: addr=2 len=63 parity=bad delay=19 |
| 24185 | **DUT** | IN  pkt #45 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 24825 | **DUT** | IN  pkt #45 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 24825 | yapp monitor | RX pkt #45 on the input: addr=2 len=63 parity=bad gap=19 |
| 24825 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 24825 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 24830 | yapp driver | TX pkt #45 accepted by the DUT |
| 24830 | yapp driver | TX pkt #46: addr=1 len=1 parity=good delay=20 |
| 24870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 24870 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 25035 | **DUT** | IN  pkt #46 header: addr=1 len=1 -> channel 1 |
| 25055 | **DUT** | IN  pkt #46 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25055 | yapp monitor | RX pkt #46 on the input: addr=1 len=1 parity=good gap=20 |
| 25055 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 25060 | yapp driver | TX pkt #46 accepted by the DUT |
| 25060 | yapp driver | TX pkt #47: addr=2 len=63 parity=good delay=2 |
| 25085 | **DUT** | IN  pkt #47 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 25145 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=1 (receiver waited 10 cycle(s)) |
| 25160 | ch1 driver | ch1: packet consumed (response delay 10) |
| 25255 | **DUT** | OUT ch1 pkt #7 done: 3 bytes in 12 cycles |
| 25255 | ch1 monitor | ch1 RX pkt #7: addr=1 len=1 parity=good |
| 25255 | scoreboard | ch1 pkt matched: addr=1 len=1 (21 matched so far) |
| 25420 | ch1 driver | ch1: packet consumed (response delay 8) |
| 25725 | **DUT** | IN  pkt #47 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 25725 | yapp monitor | RX pkt #47 on the input: addr=2 len=63 parity=good gap=2 |
| 25725 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 25725 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 25730 | yapp driver | TX pkt #47 accepted by the DUT |
| 25730 | yapp driver | TX pkt #48: addr=1 len=1 parity=good delay=7 |
| 25805 | **DUT** | IN  pkt #48 header: addr=1 len=1 -> channel 1 |
| 25825 | **DUT** | IN  pkt #48 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25825 | yapp monitor | RX pkt #48 on the input: addr=1 len=1 parity=good gap=7 |
| 25825 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 25830 | yapp driver | TX pkt #48 accepted by the DUT |
| 25830 | yapp driver | TX pkt #49: addr=2 len=44 parity=good delay=20 |
| 25905 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=1 (receiver waited 9 cycle(s)) |
| 25920 | ch1 driver | ch1: packet consumed (response delay 9) |
| 25965 | **DUT** | OUT ch1 pkt #8 done: 3 bytes in 7 cycles |
| 25965 | ch1 monitor | ch1 RX pkt #8: addr=1 len=1 parity=good |
| 25965 | scoreboard | ch1 pkt matched: addr=1 len=1 (22 matched so far) |
| 26035 | **DUT** | IN  pkt #49 header: addr=2 len=44 -> channel 2 |
| 26045 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=44 (receiver waited 0 cycle(s)) |
| 26420 | ch1 driver | ch1: packet consumed (response delay 3) |
| 26485 | **DUT** | IN  pkt #49 complete: addr=2 len=44 parity=ok forwarded, 46 bytes in 46 cycles (held 0) |
| 26485 | yapp monitor | RX pkt #49 on the input: addr=2 len=44 parity=good gap=20 |
| 26485 | reference | Packet forwarded: addr=2 len=44 -> channel 2 |
| 26490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 26490 | yapp driver | TX pkt #49 accepted by the DUT |
| 26490 | **test** | STAGE: burst 5/8 sent: addr0..3 0/4/6/0, bad parity 1, gap 0 0, length 1..63 |
| 26505 | **DUT** | OUT ch2 pkt #11 done: 46 bytes in 47 cycles |
| 26505 | ch2 monitor | ch2 RX pkt #11: addr=2 len=44 parity=good |
| 26505 | scoreboard | ch2 pkt matched: addr=2 len=44 (23 matched so far) |
| 26510 | hbus driver | Executed WRITE addr=0x1000 data=0xbe |
| 26515 | hbus monitor | Collected WRITE addr=0x1000 data=0xbe |
| 26515 | reference | maxpktsize is now 62 |
| 26530 | hbus driver | Executed WRITE addr=0x1001 data=0x68 |
| 26535 | **DUT** | CONFIG router_en=0 maxpktsize=62 |
| 26535 | hbus monitor | Collected WRITE addr=0x1001 data=0x68 |
| 26535 | reference | router_en is now 0 (en_reg 0x68) |
| 26560 | hbus driver | Executed READ  addr=0x100d data=0x2c |
| 26565 | hbus monitor | Collected READ  addr=0x100d data=0x2c |
| 26590 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 26595 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 26610 | hbus driver | Executed WRITE addr=0x117e data=0x7f |
| 26615 | hbus monitor | Collected WRITE addr=0x117e data=0x7f |
| 26640 | hbus driver | Executed READ  addr=0x117e data=0x7f |
| 26645 | hbus monitor | Collected READ  addr=0x117e data=0x7f |
| 26670 | hbus driver | Executed READ  addr=0x1017 data=0xa3 |
| 26675 | hbus monitor | Collected READ  addr=0x1017 data=0xa3 |
| 26700 | hbus driver | Executed READ  addr=0x1003 data=0x00 |
| 26705 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26720 | hbus driver | Executed WRITE addr=0x1132 data=0x4f |
| 26725 | hbus monitor | Collected WRITE addr=0x1132 data=0x4f |
| 26750 | hbus driver | Executed READ  addr=0x1132 data=0x4f |
| 26755 | hbus monitor | Collected READ  addr=0x1132 data=0x4f |
| 26780 | hbus driver | Executed READ  addr=0x10f9 data=0x00 |
| 26785 | hbus monitor | Collected READ  addr=0x10f9 data=0x00 |
| 26810 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 26815 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 26830 | hbus driver | Executed WRITE addr=0x115b data=0xf3 |
| 26835 | hbus monitor | Collected WRITE addr=0x115b data=0xf3 |
| 26860 | hbus driver | Executed READ  addr=0x115b data=0xf3 |
| 26865 | hbus monitor | Collected READ  addr=0x115b data=0xf3 |
| 26890 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 26890 | **test** | STAGE: burst 6/8: ctrl=0xbe (maxpktsize 62) en=0x68 (router OFF, counter enables 0110100), 10 packet(s) |
| 26890 | yapp driver | TX pkt #50: addr=2 len=26 parity=bad delay=0 |
| 26895 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26905 | **DUT** | IN  pkt #50 header: addr=2 len=26 -> DROP (router disabled) |
| 27060 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27175 | **DUT** | IN  pkt #50 complete: addr=2 len=26 parity=BAD dropped, 28 bytes in 28 cycles (held 0) |
| 27175 | yapp monitor | RX pkt #50 on the input: addr=2 len=26 parity=bad gap=41 |
| 27175 | reference | Packet dropped: router disabled (addr=2 len=26) |
| 27175 | **DUT** | ROUTER DROPS PACKET addr=2 length=26 (router disabled) |
| 27180 | yapp driver | TX pkt #50 accepted by the DUT |
| 27180 | yapp driver | TX pkt #51: addr=0 len=31 parity=bad delay=3 |
| 27215 | **DUT** | IN  pkt #51 header: addr=0 len=31 -> DROP (router disabled) |
| 27535 | **DUT** | IN  pkt #51 complete: addr=0 len=31 parity=BAD dropped, 33 bytes in 33 cycles (held 0) |
| 27535 | yapp monitor | RX pkt #51 on the input: addr=0 len=31 parity=bad gap=3 |
| 27535 | reference | Packet dropped: router disabled (addr=0 len=31) |
| 27535 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (router disabled) |
| 27540 | yapp driver | TX pkt #51 accepted by the DUT |
| 27540 | yapp driver | TX pkt #52: addr=1 len=2 parity=good delay=20 |
| 27745 | **DUT** | IN  pkt #52 header: addr=1 len=2 -> DROP (router disabled) |
| 27775 | **DUT** | IN  pkt #52 complete: addr=1 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 27775 | yapp monitor | RX pkt #52 on the input: addr=1 len=2 parity=good gap=20 |
| 27775 | reference | Packet dropped: router disabled (addr=1 len=2) |
| 27775 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (router disabled) |
| 27780 | yapp driver | TX pkt #52 accepted by the DUT |
| 27780 | yapp driver | TX pkt #53: addr=2 len=59 parity=good delay=0 |
| 27785 | **DUT** | IN  pkt #53 header: addr=2 len=59 -> DROP (router disabled) |
| 28385 | **DUT** | IN  pkt #53 complete: addr=2 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 28385 | yapp monitor | RX pkt #53 on the input: addr=2 len=59 parity=good gap=0 |
| 28385 | reference | Packet dropped: router disabled (addr=2 len=59) |
| 28385 | **DUT** | ROUTER DROPS PACKET addr=2 length=59 (router disabled) |
| 28390 | yapp driver | TX pkt #53 accepted by the DUT |
| 28390 | yapp driver | TX pkt #54: addr=2 len=61 parity=good delay=6 |
| 28455 | **DUT** | IN  pkt #54 header: addr=2 len=61 -> DROP (router disabled) |
| 29075 | **DUT** | IN  pkt #54 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 29075 | yapp monitor | RX pkt #54 on the input: addr=2 len=61 parity=good gap=6 |
| 29075 | reference | Packet dropped: router disabled (addr=2 len=61) |
| 29075 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (router disabled) |
| 29080 | yapp driver | TX pkt #54 accepted by the DUT |
| 29080 | yapp driver | TX pkt #55: addr=3 len=63 parity=good delay=0 |
| 29085 | **DUT** | IN  pkt #55 header: addr=3 len=63 -> DROP (router disabled) |
| 29725 | **DUT** | IN  pkt #55 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 29725 | yapp monitor | RX pkt #55 on the input: addr=3 len=63 parity=good gap=0 |
| 29725 | reference | Packet dropped: router disabled (addr=3 len=63) |
| 29725 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (router disabled) |
| 29730 | yapp driver | TX pkt #55 accepted by the DUT |
| 29730 | yapp driver | TX pkt #56: addr=2 len=63 parity=good delay=11 |
| 29845 | **DUT** | IN  pkt #56 header: addr=2 len=63 -> DROP (router disabled) |
| 30485 | **DUT** | IN  pkt #56 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 30485 | yapp monitor | RX pkt #56 on the input: addr=2 len=63 parity=good gap=11 |
| 30485 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 30485 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 30490 | yapp driver | TX pkt #56 accepted by the DUT |
| 30490 | yapp driver | TX pkt #57: addr=0 len=63 parity=good delay=0 |
| 30495 | **DUT** | IN  pkt #57 header: addr=0 len=63 -> DROP (router disabled) |
| 31135 | **DUT** | IN  pkt #57 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 31135 | yapp monitor | RX pkt #57 on the input: addr=0 len=63 parity=good gap=0 |
| 31135 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 31135 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 31140 | yapp driver | TX pkt #57 accepted by the DUT |
| 31140 | yapp driver | TX pkt #58: addr=0 len=57 parity=good delay=2 |
| 31165 | **DUT** | IN  pkt #58 header: addr=0 len=57 -> DROP (router disabled) |
| 31745 | **DUT** | IN  pkt #58 complete: addr=0 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 31745 | yapp monitor | RX pkt #58 on the input: addr=0 len=57 parity=good gap=2 |
| 31745 | reference | Packet dropped: router disabled (addr=0 len=57) |
| 31745 | **DUT** | ROUTER DROPS PACKET addr=0 length=57 (router disabled) |
| 31750 | yapp driver | TX pkt #58 accepted by the DUT |
| 31750 | yapp driver | TX pkt #59: addr=2 len=63 parity=good delay=2 |
| 31775 | **DUT** | IN  pkt #59 header: addr=2 len=63 -> DROP (router disabled) |
| 32415 | **DUT** | IN  pkt #59 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 32415 | yapp monitor | RX pkt #59 on the input: addr=2 len=63 parity=good gap=2 |
| 32415 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 32415 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 32420 | yapp driver | TX pkt #59 accepted by the DUT |
| 32420 | **test** | STAGE: burst 6/8 sent: addr0..3 3/1/5/1, bad parity 2, gap 0 4, length 2..63 |
| 32440 | hbus driver | Executed WRITE addr=0x1000 data=0x2e |
| 32445 | **DUT** | CONFIG router_en=0 maxpktsize=46 |
| 32445 | hbus monitor | Collected WRITE addr=0x1000 data=0x2e |
| 32445 | reference | maxpktsize is now 46 |
| 32460 | hbus driver | Executed WRITE addr=0x1001 data=0x8a |
| 32465 | hbus monitor | Collected WRITE addr=0x1001 data=0x8a |
| 32465 | reference | router_en is now 0 (en_reg 0x8a) |
| 32490 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 32495 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 32510 | hbus driver | Executed WRITE addr=0x11c2 data=0x5f |
| 32515 | hbus monitor | Collected WRITE addr=0x11c2 data=0x5f |
| 32540 | hbus driver | Executed READ  addr=0x11c2 data=0x5f |
| 32545 | hbus monitor | Collected READ  addr=0x11c2 data=0x5f |
| 32570 | hbus driver | Executed READ  addr=0x10fd data=0x00 |
| 32575 | hbus monitor | Collected READ  addr=0x10fd data=0x00 |
| 32600 | hbus driver | Executed READ  addr=0x1004 data=0x03 |
| 32605 | hbus monitor | Collected READ  addr=0x1004 data=0x03 |
| 32630 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 32630 | **test** | STAGE: burst 7/8: ctrl=0x2e (maxpktsize 46) en=0x8a (router OFF, counter enables 1000101), 10 packet(s) |
| 32630 | yapp driver | TX pkt #60: addr=1 len=20 parity=good delay=18 |
| 32635 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 32825 | **DUT** | IN  pkt #60 header: addr=1 len=20 -> DROP (router disabled) |
| 33035 | **DUT** | IN  pkt #60 complete: addr=1 len=20 parity=ok dropped, 22 bytes in 22 cycles (held 0) |
| 33035 | yapp monitor | RX pkt #60 on the input: addr=1 len=20 parity=good gap=40 |
| 33035 | reference | Packet dropped: router disabled (addr=1 len=20) |
| 33035 | **DUT** | ROUTER DROPS PACKET addr=1 length=20 (router disabled) |
| 33040 | yapp driver | TX pkt #60 accepted by the DUT |
| 33040 | yapp driver | TX pkt #61: addr=2 len=5 parity=good delay=2 |
| 33065 | **DUT** | IN  pkt #61 header: addr=2 len=5 -> DROP (router disabled) |
| 33125 | **DUT** | IN  pkt #61 complete: addr=2 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 33125 | yapp monitor | RX pkt #61 on the input: addr=2 len=5 parity=good gap=2 |
| 33125 | reference | Packet dropped: router disabled (addr=2 len=5) |
| 33125 | **DUT** | ROUTER DROPS PACKET addr=2 length=5 (router disabled) |
| 33130 | yapp driver | TX pkt #61 accepted by the DUT |
| 33130 | yapp driver | TX pkt #62: addr=0 len=17 parity=good delay=18 |
| 33315 | **DUT** | IN  pkt #62 header: addr=0 len=17 -> DROP (router disabled) |
| 33495 | **DUT** | IN  pkt #62 complete: addr=0 len=17 parity=ok dropped, 19 bytes in 19 cycles (held 0) |
| 33495 | yapp monitor | RX pkt #62 on the input: addr=0 len=17 parity=good gap=18 |
| 33495 | reference | Packet dropped: router disabled (addr=0 len=17) |
| 33495 | **DUT** | ROUTER DROPS PACKET addr=0 length=17 (router disabled) |
| 33500 | yapp driver | TX pkt #62 accepted by the DUT |
| 33500 | yapp driver | TX pkt #63: addr=2 len=5 parity=good delay=2 |
| 33525 | **DUT** | IN  pkt #63 header: addr=2 len=5 -> DROP (router disabled) |
| 33585 | **DUT** | IN  pkt #63 complete: addr=2 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 33585 | yapp monitor | RX pkt #63 on the input: addr=2 len=5 parity=good gap=2 |
| 33585 | reference | Packet dropped: router disabled (addr=2 len=5) |
| 33585 | **DUT** | ROUTER DROPS PACKET addr=2 length=5 (router disabled) |
| 33590 | yapp driver | TX pkt #63 accepted by the DUT |
| 33590 | yapp driver | TX pkt #64: addr=3 len=63 parity=good delay=1 |
| 33605 | **DUT** | IN  pkt #64 header: addr=3 len=63 -> DROP (router disabled) |
| 34245 | **DUT** | IN  pkt #64 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 34245 | yapp monitor | RX pkt #64 on the input: addr=3 len=63 parity=good gap=1 |
| 34245 | reference | Packet dropped: router disabled (addr=3 len=63) |
| 34245 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (router disabled) |
| 34250 | yapp driver | TX pkt #64 accepted by the DUT |
| 34250 | yapp driver | TX pkt #65: addr=2 len=55 parity=good delay=3 |
| 34285 | **DUT** | IN  pkt #65 header: addr=2 len=55 -> DROP (router disabled) |
| 34845 | **DUT** | IN  pkt #65 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 34845 | yapp monitor | RX pkt #65 on the input: addr=2 len=55 parity=good gap=3 |
| 34845 | reference | Packet dropped: router disabled (addr=2 len=55) |
| 34845 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (router disabled) |
| 34850 | yapp driver | TX pkt #65 accepted by the DUT |
| 34850 | yapp driver | TX pkt #66: addr=2 len=5 parity=good delay=2 |
| 34875 | **DUT** | IN  pkt #66 header: addr=2 len=5 -> DROP (router disabled) |
| 34935 | **DUT** | IN  pkt #66 complete: addr=2 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 34935 | yapp monitor | RX pkt #66 on the input: addr=2 len=5 parity=good gap=2 |
| 34935 | reference | Packet dropped: router disabled (addr=2 len=5) |
| 34935 | **DUT** | ROUTER DROPS PACKET addr=2 length=5 (router disabled) |
| 34940 | yapp driver | TX pkt #66 accepted by the DUT |
| 34940 | yapp driver | TX pkt #67: addr=1 len=47 parity=good delay=20 |
| 35145 | **DUT** | IN  pkt #67 header: addr=1 len=47 -> DROP (router disabled) |
| 35625 | **DUT** | IN  pkt #67 complete: addr=1 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 35625 | yapp monitor | RX pkt #67 on the input: addr=1 len=47 parity=good gap=20 |
| 35625 | reference | Packet dropped: router disabled (addr=1 len=47) |
| 35625 | **DUT** | ROUTER DROPS PACKET addr=1 length=47 (router disabled) |
| 35630 | yapp driver | TX pkt #67 accepted by the DUT |
| 35630 | yapp driver | TX pkt #68: addr=0 len=33 parity=good delay=1 |
| 35645 | **DUT** | IN  pkt #68 header: addr=0 len=33 -> DROP (router disabled) |
| 35985 | **DUT** | IN  pkt #68 complete: addr=0 len=33 parity=ok dropped, 35 bytes in 35 cycles (held 0) |
| 35985 | yapp monitor | RX pkt #68 on the input: addr=0 len=33 parity=good gap=1 |
| 35985 | reference | Packet dropped: router disabled (addr=0 len=33) |
| 35985 | **DUT** | ROUTER DROPS PACKET addr=0 length=33 (router disabled) |
| 35990 | yapp driver | TX pkt #68 accepted by the DUT |
| 35990 | yapp driver | TX pkt #69: addr=2 len=47 parity=good delay=16 |
| 36155 | **DUT** | IN  pkt #69 header: addr=2 len=47 -> DROP (router disabled) |
| 36635 | **DUT** | IN  pkt #69 complete: addr=2 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 36635 | yapp monitor | RX pkt #69 on the input: addr=2 len=47 parity=good gap=16 |
| 36635 | reference | Packet dropped: router disabled (addr=2 len=47) |
| 36635 | **DUT** | ROUTER DROPS PACKET addr=2 length=47 (router disabled) |
| 36640 | yapp driver | TX pkt #69 accepted by the DUT |
| 36640 | **test** | STAGE: burst 7/8 sent: addr0..3 2/2/5/1, bad parity 0, gap 0 0, length 5..63 |
| 36660 | hbus driver | Executed WRITE addr=0x1000 data=0xfe |
| 36665 | **DUT** | CONFIG router_en=0 maxpktsize=62 |
| 36665 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 36665 | reference | maxpktsize is now 62 |
| 36680 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 36685 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 36685 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 36685 | reference | router_en is now 1 (en_reg 0xff) |
| 36710 | hbus driver | Executed READ  addr=0x100d data=0x2c |
| 36715 | hbus monitor | Collected READ  addr=0x100d data=0x2c |
| 36740 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 36745 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36760 | hbus driver | Executed WRITE addr=0x11ce data=0xe3 |
| 36765 | hbus monitor | Collected WRITE addr=0x11ce data=0xe3 |
| 36790 | hbus driver | Executed READ  addr=0x11ce data=0xe3 |
| 36795 | hbus monitor | Collected READ  addr=0x11ce data=0xe3 |
| 36810 | hbus driver | Executed WRITE addr=0x11e6 data=0xe9 |
| 36815 | hbus monitor | Collected WRITE addr=0x11e6 data=0xe9 |
| 36840 | hbus driver | Executed READ  addr=0x11e6 data=0xe9 |
| 36845 | hbus monitor | Collected READ  addr=0x11e6 data=0xe9 |
| 36860 | hbus driver | Executed WRITE addr=0x117b data=0x60 |
| 36865 | hbus monitor | Collected WRITE addr=0x117b data=0x60 |
| 36890 | hbus driver | Executed READ  addr=0x117b data=0x60 |
| 36895 | hbus monitor | Collected READ  addr=0x117b data=0x60 |
| 36920 | hbus driver | Executed READ  addr=0x1064 data=0x00 |
| 36925 | hbus monitor | Collected READ  addr=0x1064 data=0x00 |
| 36950 | hbus driver | Executed READ  addr=0x1007 data=0x00 |
| 36955 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36970 | hbus driver | Executed WRITE addr=0x11b1 data=0xf1 |
| 36975 | hbus monitor | Collected WRITE addr=0x11b1 data=0xf1 |
| 37000 | hbus driver | Executed READ  addr=0x11b1 data=0xf1 |
| 37005 | hbus monitor | Collected READ  addr=0x11b1 data=0xf1 |
| 37020 | hbus driver | Executed WRITE addr=0x11e4 data=0xec |
| 37025 | hbus monitor | Collected WRITE addr=0x11e4 data=0xec |
| 37050 | hbus driver | Executed READ  addr=0x11e4 data=0xec |
| 37055 | hbus monitor | Collected READ  addr=0x11e4 data=0xec |
| 37070 | hbus driver | Executed WRITE addr=0x1197 data=0xd4 |
| 37075 | hbus monitor | Collected WRITE addr=0x1197 data=0xd4 |
| 37100 | hbus driver | Executed READ  addr=0x1197 data=0xd4 |
| 37105 | hbus monitor | Collected READ  addr=0x1197 data=0xd4 |
| 37120 | hbus driver | Executed WRITE addr=0x115d data=0x60 |
| 37125 | hbus monitor | Collected WRITE addr=0x115d data=0x60 |
| 37150 | hbus driver | Executed READ  addr=0x115d data=0x60 |
| 37155 | hbus monitor | Collected READ  addr=0x115d data=0x60 |
| 37180 | hbus driver | Executed READ  addr=0x100d data=0x2c |
| 37180 | **test** | STAGE: burst 8/8: ctrl=0xfe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 37180 | yapp driver | TX pkt #70: addr=0 len=62 parity=good delay=20 |
| 37185 | hbus monitor | Collected READ  addr=0x100d data=0x2c |
| 37395 | **DUT** | IN  pkt #70 header: addr=0 len=62 -> channel 0 |
| 37405 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=62 (receiver waited 0 cycle(s)) |
| 38025 | **DUT** | IN  pkt #70 complete: addr=0 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 38025 | yapp monitor | RX pkt #70 on the input: addr=0 len=62 parity=good gap=75 |
| 38025 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 38030 | ch0 driver | ch0: packet consumed (response delay 0) |
| 38030 | yapp driver | TX pkt #70 accepted by the DUT |
| 38030 | yapp driver | TX pkt #71: addr=2 len=61 parity=good delay=2 |
| 38045 | **DUT** | OUT ch0 pkt #5 done: 64 bytes in 65 cycles |
| 38045 | ch0 monitor | ch0 RX pkt #5: addr=0 len=62 parity=good |
| 38045 | scoreboard | ch0 pkt matched: addr=0 len=62 (24 matched so far) |
| 38055 | **DUT** | IN  pkt #71 header: addr=2 len=61 -> channel 2 |
| 38065 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=61 (receiver waited 0 cycle(s)) |
| 38510 | ch0 driver | ch0: packet consumed (response delay 0) |
| 38675 | **DUT** | IN  pkt #71 complete: addr=2 len=61 parity=ok forwarded, 63 bytes in 63 cycles (held 0) |
| 38675 | yapp monitor | RX pkt #71 on the input: addr=2 len=61 parity=good gap=2 |
| 38675 | reference | Packet forwarded: addr=2 len=61 -> channel 2 |
| 38680 | ch2 driver | ch2: packet consumed (response delay 0) |
| 38680 | yapp driver | TX pkt #71 accepted by the DUT |
| 38680 | yapp driver | TX pkt #72: addr=2 len=62 parity=good delay=0 |
| 38685 | **DUT** | IN  pkt #72 header: addr=2 len=62 -> channel 2 |
| 38695 | **DUT** | OUT ch2 pkt #12 done: 63 bytes in 64 cycles |
| 38695 | ch2 monitor | ch2 RX pkt #12: addr=2 len=61 parity=good |
| 38695 | scoreboard | ch2 pkt matched: addr=2 len=61 (25 matched so far) |
| 38705 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 39110 | ch2 driver | ch2: packet consumed (response delay 0) |
| 39315 | **DUT** | IN  pkt #72 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 39315 | yapp monitor | RX pkt #72 on the input: addr=2 len=62 parity=good gap=0 |
| 39315 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 39320 | yapp driver | TX pkt #72 accepted by the DUT |
| 39320 | yapp driver | TX pkt #73: addr=0 len=63 parity=good delay=2 |
| 39345 | **DUT** | IN  pkt #73 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 39345 | **DUT** | OUT ch2 pkt #13 done: 64 bytes in 65 cycles |
| 39345 | ch2 monitor | ch2 RX pkt #13: addr=2 len=62 parity=good |
| 39345 | scoreboard | ch2 pkt matched: addr=2 len=62 (26 matched so far) |
| 39740 | ch2 driver | ch2: packet consumed (response delay 0) |
| 39985 | **DUT** | IN  pkt #73 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 39985 | yapp monitor | RX pkt #73 on the input: addr=0 len=63 parity=good gap=2 |
| 39985 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 39985 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 39990 | yapp driver | TX pkt #73 accepted by the DUT |
| 39990 | yapp driver | TX pkt #74: addr=2 len=41 parity=good delay=1 |
| 40005 | **DUT** | IN  pkt #74 header: addr=2 len=41 -> channel 2 |
| 40015 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=41 (receiver waited 0 cycle(s)) |
| 40425 | **DUT** | IN  pkt #74 complete: addr=2 len=41 parity=ok forwarded, 43 bytes in 43 cycles (held 0) |
| 40425 | yapp monitor | RX pkt #74 on the input: addr=2 len=41 parity=good gap=1 |
| 40425 | reference | Packet forwarded: addr=2 len=41 -> channel 2 |
| 40430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 40430 | yapp driver | TX pkt #74 accepted by the DUT |
| 40430 | yapp driver | TX pkt #75: addr=2 len=61 parity=good delay=1 |
| 40445 | **DUT** | IN  pkt #75 header: addr=2 len=61 -> channel 2 |
| 40445 | **DUT** | OUT ch2 pkt #14 done: 43 bytes in 44 cycles |
| 40445 | ch2 monitor | ch2 RX pkt #14: addr=2 len=41 parity=good |
| 40445 | scoreboard | ch2 pkt matched: addr=2 len=41 (27 matched so far) |
| 40455 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=61 (receiver waited 0 cycle(s)) |
| 40460 | ch2 driver | ch2: packet consumed (response delay 0) |
| 40980 | ch2 driver | ch2: packet consumed (response delay 0) |
| 41065 | **DUT** | IN  pkt #75 complete: addr=2 len=61 parity=ok forwarded, 63 bytes in 63 cycles (held 0) |
| 41065 | yapp monitor | RX pkt #75 on the input: addr=2 len=61 parity=good gap=1 |
| 41065 | reference | Packet forwarded: addr=2 len=61 -> channel 2 |
| 41070 | yapp driver | TX pkt #75 accepted by the DUT |
| 41070 | yapp driver | TX pkt #76: addr=1 len=63 parity=good delay=7 |
| 41095 | **DUT** | OUT ch2 pkt #15 done: 63 bytes in 65 cycles |
| 41095 | ch2 monitor | ch2 RX pkt #15: addr=2 len=61 parity=good |
| 41095 | scoreboard | ch2 pkt matched: addr=2 len=61 (28 matched so far) |
| 41145 | **DUT** | IN  pkt #76 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 41270 | ch2 driver | ch2: packet consumed (response delay 0) |
| 41785 | **DUT** | IN  pkt #76 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 41785 | yapp monitor | RX pkt #76 on the input: addr=1 len=63 parity=good gap=7 |
| 41785 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 41785 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 41790 | yapp driver | TX pkt #76 accepted by the DUT |
| 41790 | yapp driver | TX pkt #77: addr=0 len=63 parity=good delay=1 |
| 41805 | **DUT** | IN  pkt #77 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 42445 | **DUT** | IN  pkt #77 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 42445 | yapp monitor | RX pkt #77 on the input: addr=0 len=63 parity=good gap=1 |
| 42445 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 42445 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 42450 | yapp driver | TX pkt #77 accepted by the DUT |
| 42450 | yapp driver | TX pkt #78: addr=2 len=63 parity=good delay=0 |
| 42455 | **DUT** | IN  pkt #78 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 43095 | **DUT** | IN  pkt #78 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 43095 | yapp monitor | RX pkt #78 on the input: addr=2 len=63 parity=good gap=0 |
| 43095 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 43095 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 43100 | yapp driver | TX pkt #78 accepted by the DUT |
| 43100 | yapp driver | TX pkt #79: addr=0 len=63 parity=good delay=3 |
| 43135 | **DUT** | IN  pkt #79 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 43775 | **DUT** | IN  pkt #79 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 43775 | yapp monitor | RX pkt #79 on the input: addr=0 len=63 parity=good gap=3 |
| 43775 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 43775 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 43780 | yapp driver | TX pkt #79 accepted by the DUT |
| 43780 | yapp driver | TX pkt #80: addr=1 len=1 parity=good delay=5 |
| 43835 | **DUT** | IN  pkt #80 header: addr=1 len=1 -> channel 1 |
| 43855 | **DUT** | IN  pkt #80 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 43855 | yapp monitor | RX pkt #80 on the input: addr=1 len=1 parity=good gap=5 |
| 43855 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 43860 | yapp driver | TX pkt #80 accepted by the DUT |
| 43860 | **test** | STAGE: burst 8/8 sent: addr0..3 4/2/5/0, bad parity 0, gap 0 2, length 1..63 |
| 43860 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 43890 | hbus driver | Executed READ  addr=0x1000 data=0xfe |
| 43895 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 43905 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=1 (receiver waited 6 cycle(s)) |
| 43920 | ch1 driver | ch1: packet consumed (response delay 6) |
| 43920 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 43925 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 43950 | hbus driver | Executed READ  addr=0x1004 data=0x03 |
| 43955 | hbus monitor | Collected READ  addr=0x1004 data=0x03 |
| 43965 | **DUT** | OUT ch1 pkt #9 done: 3 bytes in 7 cycles |
| 43965 | ch1 monitor | ch1 RX pkt #9: addr=1 len=1 parity=good |
| 43965 | scoreboard | ch1 pkt matched: addr=1 len=1 (29 matched so far) |
| 43980 | hbus driver | Executed READ  addr=0x1005 data=0x0f |
| 43985 | hbus monitor | Collected READ  addr=0x1005 data=0x0f |
| 44010 | hbus driver | Executed READ  addr=0x1006 data=0x04 |
| 44015 | hbus monitor | Collected READ  addr=0x1006 data=0x04 |
| 44040 | hbus driver | Executed READ  addr=0x1009 data=0x09 |
| 44045 | hbus monitor | Collected READ  addr=0x1009 data=0x09 |
| 44070 | hbus driver | Executed READ  addr=0x100a data=0x05 |
| 44075 | hbus monitor | Collected READ  addr=0x100a data=0x05 |
| 44100 | hbus driver | Executed READ  addr=0x100b data=0x09 |
| 44105 | hbus monitor | Collected READ  addr=0x100b data=0x09 |
| 44130 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 44135 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 44160 | hbus driver | Executed READ  addr=0x1010 data=0x05 |
| 44165 | hbus monitor | Collected READ  addr=0x1010 data=0x05 |
| 44190 | hbus driver | Executed READ  addr=0x1011 data=0xed |
| 44195 | hbus monitor | Collected READ  addr=0x1011 data=0xed |
| 44305 | **test** | STAGE: done: 80 packets (29 forwarded, 51 dropped), 0 storm burst(s), 29 scoreboard matches, 70 HBUS reads checked, 5 error pulses for 5 bad packets |
| 44505 | error checker | error pulse report: 5 bad packets, 5 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 44505 | ch0 monitor | Channel 0 report: 5 packets collected |
| 44505 | ch1 monitor | Channel 1 report: 9 packets collected |
| 44505 | ch2 monitor | Channel 2 report: 15 packets collected |
| 44505 | hbus monitor | HBUS report: 39 writes, 72 reads |
| 44505 | coverage | Coverage of the router configuration: 91.3% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 10 / 0 / 20 / 21 / 9 packets · length < max / = max / max+1 / > max+1 : 26 / 5 / 12 / 17 · forwarded good / bad : 28 / 1 · dropped address 3 good / bad : 4 / 0 · dropped oversized good / bad : 23 / 4 · counter enables none / mixed / all : 10 / 29 / 21 |
| 44505 | coverage | HBUS address coverage: 111 accesses sampled, coverage 53.2% |
| 44505 | coverage | HBUS register bits coverage: 16 writes to ctrl_reg/en_reg, coverage 100.0% |
| 44505 | coverage | HBUS counter value coverage: 16 counter reads sampled, coverage 55.6% |
| 44505 | coverage | HBUS yapp_mem data coverage: 46 accesses sampled, coverage 29.4% |
| 44505 | reference | --- Reference model report --- · forwarded to scoreboard : 29 · dropped (router disabled) : 20 · dropped (oversized) : 27 · dropped (address 3) : 4 · counters parity/oversized/addr0..3 : 3 / 15 / 9 5 9 4 |
| 44505 | reference | HBUS reads checked against the model: 70 (0 mismatches, 2 of memory bytes never written) |
| 44505 | scoreboard | --- Scoreboard report --- · packets received : 29 · packets matched : 29 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 44505 | yapp driver | YAPP driver report: 80 packets sent |
| 44505 | coverage | YAPP gap coverage: 79 gaps sampled, coverage 100.0% |
| 44505 | yapp monitor | YAPP monitor report: 80 packets collected, 7 with bad parity |
| 44505 | yapp monitor | YAPP gaps: 6 back to back, 9 of 1 cycle, 13 of 2, 51 longer |
| 44505 | coverage | YAPP packet coverage: 80 packets sampled, coverage 66.7% |
