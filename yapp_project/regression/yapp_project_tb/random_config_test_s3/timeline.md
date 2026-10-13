# random_config_test  seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 44us · log `random_config_test_s3.log`

Waves: `random_config_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s3%2Frandom_config_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **89** packet(s) (17 with bad parity); the input monitor saw 89.
- Router: **28** forwarded, **61** dropped (55 oversized, 6 illegal address 3).
- Packets out: ch0 **9**, ch1 **6**, ch2 **13**.
- Scoreboard: 28 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **1** time(s), longest hold 47 cycle(s).
- Error pulses: 17.
- HBUS: 45 write(s), 72 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_STALLY, ch1 RX_STALLY, ch2 RX_FAST |
| 0 | random scenario: 89 packets in 8 bursts |
| 240 | burst 1/8: ctrl=0xbe (maxpktsize 62) en=0xdb (router on, counter enables 1101101), 11 packet(s) |
| 6740 | burst 1/8 sent: addr0..3 1/3/4/3, bad parity 1, gap 0 1, length 1..63 |
| 7260 | burst 2/8: ctrl=0xff (maxpktsize 63) en=0x01 (router on, counter enables 0000000), 11 packet(s) |
| 12380 | burst 2/8 sent: addr0..3 2/0/7/2, bad parity 2, gap 0 2, length 1..63 |
| 12660 | burst 3/8: ctrl=0x11 (maxpktsize 17) en=0x3f (router on, counter enables 0011111), 11 packet(s) |
| 16620 | burst 3/8 sent: addr0..3 5/2/3/1, bad parity 3, gap 0 4, length 1..63 |
| 17050 | burst 4/8: ctrl=0x01 (maxpktsize 1) en=0x5b (router on, counter enables 0101101), 12 packet(s) |
| 21560 | burst 4/8 sent: addr0..3 2/2/5/3, bad parity 1, gap 0 5, length 1..63 |
| 21890 | burst 5/8: ctrl=0x91 (maxpktsize 17) en=0x4f (router on, counter enables 0100111), 11 packet(s) |
| 26250 | burst 5/8 sent: addr0..3 1/6/3/1, bad parity 4, gap 0 2, length 1..63 |
| 26480 | burst 6/8: ctrl=0x98 (maxpktsize 24) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 32500 | burst 6/8 sent: addr0..3 2/0/5/4, bad parity 2, gap 0 3, length 1..63 |
| 32740 | burst 7/8: ctrl=0xde (maxpktsize 30) en=0x41 (router on, counter enables 0100000), 11 packet(s) |
| 39340 | burst 7/8 sent: addr0..3 4/2/5/0, bad parity 3, gap 0 3, length 17..63 |
| 39850 | burst 8/8: ctrl=0x80 (maxpktsize 0) en=0x01 (router on, counter enables 0000000), 11 packet(s) |
| 43270 | burst 8/8 sent: addr0..3 2/2/6/1, bad parity 1, gap 0 2, length 1..63 |
| 43270 | final reads: every register and the stored packet, checked against the reference model |
| 43715 | done: 89 packets (28 forwarded, 61 dropped), 0 storm burst(s), 28 scoreboard matches, 72 HBUS reads checked, 17 error pulses for 17 bad packets |

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

1097 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_STALLY, ch1 RX_STALLY, ch2 RX_FAST |
| 0 | **test** | STAGE: random scenario: 89 packets in 8 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0xbe |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0xbe |
| 75 | reference | maxpktsize is now 62 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xdb |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xdb |
| 95 | reference | router_en is now 1 (en_reg 0xdb) |
| 120 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 180 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 185 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 210 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 215 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 240 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 240 | **test** | STAGE: burst 1/8: ctrl=0xbe (maxpktsize 62) en=0xdb (router on, counter enables 1101101), 11 packet(s) |
| 240 | yapp driver | TX pkt #1: addr=2 len=63 parity=good delay=20 |
| 245 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 455 | **DUT** | IN  pkt #1 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 1095 | **DUT** | IN  pkt #1 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1095 | yapp monitor | RX pkt #1 on the input: addr=2 len=63 parity=good gap=40 |
| 1095 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 1095 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 1100 | yapp driver | TX pkt #1 accepted by the DUT |
| 1100 | yapp driver | TX pkt #2: addr=2 len=63 parity=bad delay=12 |
| 1225 | **DUT** | IN  pkt #2 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 1865 | **DUT** | IN  pkt #2 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 1865 | yapp monitor | RX pkt #2 on the input: addr=2 len=63 parity=bad gap=12 |
| 1865 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 1865 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 1870 | yapp driver | TX pkt #2 accepted by the DUT |
| 1870 | yapp driver | TX pkt #3: addr=2 len=63 parity=good delay=18 |
| 1930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 1930 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 2055 | **DUT** | IN  pkt #3 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 2695 | **DUT** | IN  pkt #3 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2695 | yapp monitor | RX pkt #3 on the input: addr=2 len=63 parity=good gap=18 |
| 2695 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 2695 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 2700 | yapp driver | TX pkt #3 accepted by the DUT |
| 2700 | yapp driver | TX pkt #4: addr=3 len=36 parity=good delay=20 |
| 2905 | **DUT** | IN  pkt #4 header: addr=3 len=36 -> DROP (illegal address 3) |
| 3275 | **DUT** | IN  pkt #4 complete: addr=3 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 3275 | yapp monitor | RX pkt #4 on the input: addr=3 len=36 parity=good gap=20 |
| 3275 | reference | Packet dropped: illegal address 3 (len=36) |
| 3275 | **DUT** | ROUTER DROPS PACKET addr=3 length=36 (    illegal address) |
| 3280 | yapp driver | TX pkt #4 accepted by the DUT |
| 3280 | yapp driver | TX pkt #5: addr=1 len=1 parity=good delay=2 |
| 3305 | **DUT** | IN  pkt #5 header: addr=1 len=1 -> channel 1 |
| 3325 | **DUT** | IN  pkt #5 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3325 | yapp monitor | RX pkt #5 on the input: addr=1 len=1 parity=good gap=2 |
| 3325 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 3330 | yapp driver | TX pkt #5 accepted by the DUT |
| 3330 | yapp driver | TX pkt #6: addr=3 len=63 parity=good delay=1 |
| 3345 | **DUT** | IN  pkt #6 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 3385 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=1 (receiver waited 7 cycle(s)) |
| 3400 | ch1 driver | ch1: packet consumed (response delay 7) |
| 3515 | **DUT** | OUT ch1 pkt #1 done: 3 bytes in 14 cycles |
| 3515 | ch1 monitor | ch1 RX pkt #1: addr=1 len=1 parity=good |
| 3515 | scoreboard | ch1 pkt matched: addr=1 len=1 (1 matched so far) |
| 3985 | **DUT** | IN  pkt #6 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 3985 | yapp monitor | RX pkt #6 on the input: addr=3 len=63 parity=good gap=1 |
| 3985 | reference | Packet dropped: illegal address 3 (len=63) |
| 3985 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 3990 | yapp driver | TX pkt #6 accepted by the DUT |
| 3990 | yapp driver | TX pkt #7: addr=1 len=63 parity=good delay=6 |
| 4055 | **DUT** | IN  pkt #7 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 4140 | ch1 driver | ch1: packet consumed (response delay 10) |
| 4695 | **DUT** | IN  pkt #7 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4695 | yapp monitor | RX pkt #7 on the input: addr=1 len=63 parity=good gap=6 |
| 4695 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 4695 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 4700 | yapp driver | TX pkt #7 accepted by the DUT |
| 4700 | yapp driver | TX pkt #8: addr=0 len=14 parity=good delay=6 |
| 4765 | **DUT** | IN  pkt #8 header: addr=0 len=14 -> channel 0 |
| 4795 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=14 (receiver waited 2 cycle(s)) |
| 4915 | **DUT** | IN  pkt #8 complete: addr=0 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 4915 | yapp monitor | RX pkt #8 on the input: addr=0 len=14 parity=good gap=6 |
| 4915 | reference | Packet forwarded: addr=0 len=14 -> channel 0 |
| 4920 | yapp driver | TX pkt #8 accepted by the DUT |
| 4920 | yapp driver | TX pkt #9: addr=1 len=63 parity=good delay=7 |
| 4940 | ch0 driver | ch0: packet consumed (response delay 2) |
| 4985 | **DUT** | OUT ch0 pkt #1 done: 16 bytes in 20 cycles |
| 4985 | ch0 monitor | ch0 RX pkt #1: addr=0 len=14 parity=good |
| 4985 | scoreboard | ch0 pkt matched: addr=0 len=14 (2 matched so far) |
| 4995 | **DUT** | IN  pkt #9 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 5160 | ch0 driver | ch0: packet consumed (response delay 3) |
| 5635 | **DUT** | IN  pkt #9 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5635 | yapp monitor | RX pkt #9 on the input: addr=1 len=63 parity=good gap=7 |
| 5635 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 5635 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 5640 | yapp driver | TX pkt #9 accepted by the DUT |
| 5640 | yapp driver | TX pkt #10: addr=2 len=26 parity=good delay=19 |
| 5835 | **DUT** | IN  pkt #10 header: addr=2 len=26 -> channel 2 |
| 5845 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=26 (receiver waited 0 cycle(s)) |
| 6105 | **DUT** | IN  pkt #10 complete: addr=2 len=26 parity=ok forwarded, 28 bytes in 28 cycles (held 0) |
| 6105 | yapp monitor | RX pkt #10 on the input: addr=2 len=26 parity=good gap=19 |
| 6105 | reference | Packet forwarded: addr=2 len=26 -> channel 2 |
| 6110 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6110 | yapp driver | TX pkt #10 accepted by the DUT |
| 6110 | yapp driver | TX pkt #11: addr=3 len=61 parity=good delay=0 |
| 6115 | **DUT** | IN  pkt #11 header: addr=3 len=61 -> DROP (illegal address 3) |
| 6125 | **DUT** | OUT ch2 pkt #1 done: 28 bytes in 29 cycles |
| 6125 | ch2 monitor | ch2 RX pkt #1: addr=2 len=26 parity=good |
| 6125 | scoreboard | ch2 pkt matched: addr=2 len=26 (3 matched so far) |
| 6320 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6735 | **DUT** | IN  pkt #11 complete: addr=3 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 6735 | yapp monitor | RX pkt #11 on the input: addr=3 len=61 parity=good gap=0 |
| 6735 | reference | Packet dropped: illegal address 3 (len=61) |
| 6735 | **DUT** | ROUTER DROPS PACKET addr=3 length=61 (    illegal address) |
| 6740 | yapp driver | TX pkt #11 accepted by the DUT |
| 6740 | **test** | STAGE: burst 1/8 sent: addr0..3 1/3/4/3, bad parity 1, gap 0 1, length 1..63 |
| 6760 | hbus driver | Executed WRITE addr=0x1000 data=0xff |
| 6765 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 6765 | hbus monitor | Collected WRITE addr=0x1000 data=0xff |
| 6765 | reference | maxpktsize is now 63 |
| 6780 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 6785 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 6785 | reference | router_en is now 1 (en_reg 0x01) |
| 6810 | hbus driver | Executed READ  addr=0x1001 data=0x01 |
| 6815 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 6830 | hbus driver | Executed WRITE addr=0x1119 data=0xfc |
| 6835 | hbus monitor | Collected WRITE addr=0x1119 data=0xfc |
| 6860 | hbus driver | Executed READ  addr=0x1119 data=0xfc |
| 6865 | hbus monitor | Collected READ  addr=0x1119 data=0xfc |
| 6880 | hbus driver | Executed WRITE addr=0x116b data=0x38 |
| 6885 | hbus monitor | Collected WRITE addr=0x116b data=0x38 |
| 6910 | hbus driver | Executed READ  addr=0x116b data=0x38 |
| 6915 | hbus monitor | Collected READ  addr=0x116b data=0x38 |
| 6930 | hbus driver | Executed WRITE addr=0x11b5 data=0x82 |
| 6935 | hbus monitor | Collected WRITE addr=0x11b5 data=0x82 |
| 6960 | hbus driver | Executed READ  addr=0x11b5 data=0x82 |
| 6965 | hbus monitor | Collected READ  addr=0x11b5 data=0x82 |
| 6980 | hbus driver | Executed WRITE addr=0x11d8 data=0x22 |
| 6985 | hbus monitor | Collected WRITE addr=0x11d8 data=0x22 |
| 7010 | hbus driver | Executed READ  addr=0x11d8 data=0x22 |
| 7015 | hbus monitor | Collected READ  addr=0x11d8 data=0x22 |
| 7030 | hbus driver | Executed WRITE addr=0x11fc data=0x39 |
| 7035 | hbus monitor | Collected WRITE addr=0x11fc data=0x39 |
| 7060 | hbus driver | Executed READ  addr=0x11fc data=0x39 |
| 7065 | hbus monitor | Collected READ  addr=0x11fc data=0x39 |
| 7090 | hbus driver | Executed READ  addr=0x103b data=0x3f |
| 7095 | hbus monitor | Collected READ  addr=0x103b data=0x3f |
| 7120 | hbus driver | Executed READ  addr=0x1085 data=0x00 |
| 7125 | hbus monitor | Collected READ  addr=0x1085 data=0x00 |
| 7150 | hbus driver | Executed READ  addr=0x1006 data=0x03 |
| 7155 | hbus monitor | Collected READ  addr=0x1006 data=0x03 |
| 7180 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 7185 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7210 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 7215 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7230 | hbus driver | Executed WRITE addr=0x117a data=0xfb |
| 7235 | hbus monitor | Collected WRITE addr=0x117a data=0xfb |
| 7260 | hbus driver | Executed READ  addr=0x117a data=0xfb |
| 7260 | **test** | STAGE: burst 2/8: ctrl=0xff (maxpktsize 63) en=0x01 (router on, counter enables 0000000), 11 packet(s) |
| 7260 | yapp driver | TX pkt #12: addr=2 len=63 parity=good delay=0 |
| 7265 | hbus monitor | Collected READ  addr=0x117a data=0xfb |
| 7275 | **DUT** | IN  pkt #12 header: addr=2 len=63 -> channel 2 |
| 7285 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 7915 | **DUT** | IN  pkt #12 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 7915 | yapp monitor | RX pkt #12 on the input: addr=2 len=63 parity=good gap=53 |
| 7915 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 7920 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7920 | yapp driver | TX pkt #12 accepted by the DUT |
| 7920 | yapp driver | TX pkt #13: addr=2 len=63 parity=good delay=1 |
| 7935 | **DUT** | IN  pkt #13 header: addr=2 len=63 -> channel 2 |
| 7935 | **DUT** | OUT ch2 pkt #2 done: 65 bytes in 66 cycles |
| 7935 | ch2 monitor | ch2 RX pkt #2: addr=2 len=63 parity=good |
| 7935 | scoreboard | ch2 pkt matched: addr=2 len=63 (4 matched so far) |
| 7945 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 8270 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8400 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8575 | **DUT** | IN  pkt #13 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 8575 | yapp monitor | RX pkt #13 on the input: addr=2 len=63 parity=good gap=1 |
| 8575 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 8580 | yapp driver | TX pkt #13 accepted by the DUT |
| 8580 | yapp driver | TX pkt #14: addr=2 len=59 parity=good delay=5 |
| 8605 | **DUT** | OUT ch2 pkt #3 done: 65 bytes in 67 cycles |
| 8605 | ch2 monitor | ch2 RX pkt #3: addr=2 len=63 parity=good |
| 8605 | scoreboard | ch2 pkt matched: addr=2 len=63 (5 matched so far) |
| 8635 | **DUT** | IN  pkt #14 header: addr=2 len=59 -> channel 2 |
| 8645 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=59 (receiver waited 0 cycle(s)) |
| 8770 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9020 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9160 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9235 | **DUT** | IN  pkt #14 complete: addr=2 len=59 parity=ok forwarded, 61 bytes in 61 cycles (held 0) |
| 9235 | yapp monitor | RX pkt #14 on the input: addr=2 len=59 parity=good gap=5 |
| 9235 | reference | Packet forwarded: addr=2 len=59 -> channel 2 |
| 9240 | yapp driver | TX pkt #14 accepted by the DUT |
| 9240 | yapp driver | TX pkt #15: addr=2 len=63 parity=good delay=1 |
| 9255 | **DUT** | IN  pkt #15 header: addr=2 len=63 -> channel 2 |
| 9275 | **DUT** | OUT ch2 pkt #4 done: 61 bytes in 64 cycles |
| 9275 | ch2 monitor | ch2 RX pkt #4: addr=2 len=59 parity=good |
| 9275 | scoreboard | ch2 pkt matched: addr=2 len=59 (6 matched so far) |
| 9285 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 9470 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9895 | **DUT** | IN  pkt #15 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 9895 | yapp monitor | RX pkt #15 on the input: addr=2 len=63 parity=good gap=1 |
| 9895 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 9900 | yapp driver | TX pkt #15 accepted by the DUT |
| 9900 | yapp driver | TX pkt #16: addr=3 len=26 parity=good delay=17 |
| 9935 | **DUT** | OUT ch2 pkt #5 done: 65 bytes in 66 cycles |
| 9935 | ch2 monitor | ch2 RX pkt #5: addr=2 len=63 parity=good |
| 9935 | scoreboard | ch2 pkt matched: addr=2 len=63 (7 matched so far) |
| 10075 | **DUT** | IN  pkt #16 header: addr=3 len=26 -> DROP (illegal address 3) |
| 10080 | ch2 driver | ch2: packet consumed (response delay 0) |
| 10345 | **DUT** | IN  pkt #16 complete: addr=3 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 10345 | yapp monitor | RX pkt #16 on the input: addr=3 len=26 parity=good gap=17 |
| 10345 | reference | Packet dropped: illegal address 3 (len=26) |
| 10345 | **DUT** | ROUTER DROPS PACKET addr=3 length=26 (    illegal address) |
| 10350 | yapp driver | TX pkt #16 accepted by the DUT |
| 10350 | yapp driver | TX pkt #17: addr=0 len=1 parity=bad delay=1 |
| 10365 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 10385 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 10385 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=bad gap=1 |
| 10385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10390 | yapp driver | TX pkt #17 accepted by the DUT |
| 10390 | yapp driver | TX pkt #18: addr=3 len=21 parity=good delay=1 |
| 10405 | **DUT** | IN  pkt #18 header: addr=3 len=21 -> DROP (illegal address 3) |
| 10475 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 10490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 10490 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 10490 | ch0 driver | ch0: packet consumed (response delay 10) |
| 10535 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 7 cycles |
| 10535 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=bad |
| 10535 | scoreboard | ch0 pkt matched: addr=0 len=1 (8 matched so far) |
| 10625 | **DUT** | IN  pkt #18 complete: addr=3 len=21 parity=ok dropped, 23 bytes in 23 cycles (held 0) |
| 10625 | yapp monitor | RX pkt #18 on the input: addr=3 len=21 parity=good gap=1 |
| 10625 | reference | Packet dropped: illegal address 3 (len=21) |
| 10625 | **DUT** | ROUTER DROPS PACKET addr=3 length=21 (    illegal address) |
| 10630 | yapp driver | TX pkt #18 accepted by the DUT |
| 10630 | yapp driver | TX pkt #19: addr=2 len=45 parity=good delay=4 |
| 10675 | **DUT** | IN  pkt #19 header: addr=2 len=45 -> channel 2 |
| 10685 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=45 (receiver waited 0 cycle(s)) |
| 11040 | ch0 driver | ch0: packet consumed (response delay 3) |
| 11135 | **DUT** | IN  pkt #19 complete: addr=2 len=45 parity=ok forwarded, 47 bytes in 47 cycles (held 0) |
| 11135 | yapp monitor | RX pkt #19 on the input: addr=2 len=45 parity=good gap=4 |
| 11135 | reference | Packet forwarded: addr=2 len=45 -> channel 2 |
| 11140 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11140 | yapp driver | TX pkt #19 accepted by the DUT |
| 11140 | yapp driver | TX pkt #20: addr=2 len=63 parity=good delay=20 |
| 11155 | **DUT** | OUT ch2 pkt #6 done: 47 bytes in 48 cycles |
| 11155 | ch2 monitor | ch2 RX pkt #6: addr=2 len=45 parity=good |
| 11155 | scoreboard | ch2 pkt matched: addr=2 len=45 (9 matched so far) |
| 11345 | **DUT** | IN  pkt #20 header: addr=2 len=63 -> channel 2 |
| 11355 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 11430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11630 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11780 | ch2 driver | ch2: packet consumed (response delay 0) |
| 11985 | **DUT** | IN  pkt #20 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 11985 | yapp monitor | RX pkt #20 on the input: addr=2 len=63 parity=good gap=20 |
| 11985 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 11990 | yapp driver | TX pkt #20 accepted by the DUT |
| 11990 | yapp driver | TX pkt #21: addr=0 len=1 parity=good delay=6 |
| 12025 | **DUT** | OUT ch2 pkt #7 done: 65 bytes in 68 cycles |
| 12025 | ch2 monitor | ch2 RX pkt #7: addr=2 len=63 parity=good |
| 12025 | scoreboard | ch2 pkt matched: addr=2 len=63 (10 matched so far) |
| 12055 | **DUT** | IN  pkt #21 header: addr=0 len=1 -> channel 0 |
| 12075 | **DUT** | IN  pkt #21 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12075 | yapp monitor | RX pkt #21 on the input: addr=0 len=1 parity=good gap=6 |
| 12075 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12080 | yapp driver | TX pkt #21 accepted by the DUT |
| 12080 | yapp driver | TX pkt #22: addr=2 len=28 parity=bad delay=0 |
| 12085 | **DUT** | IN  pkt #22 header: addr=2 len=28 -> channel 2 |
| 12095 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=28 (receiver waited 0 cycle(s)) |
| 12165 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 12180 | ch0 driver | ch0: packet consumed (response delay 10) |
| 12190 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12245 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 9 cycles |
| 12245 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 12245 | scoreboard | ch0 pkt matched: addr=0 len=1 (11 matched so far) |
| 12375 | **DUT** | IN  pkt #22 complete: addr=2 len=28 parity=BAD forwarded, 30 bytes in 30 cycles (held 0) |
| 12375 | yapp monitor | RX pkt #22 on the input: addr=2 len=28 parity=bad gap=0 |
| 12375 | reference | Packet forwarded: addr=2 len=28 -> channel 2 |
| 12380 | yapp driver | TX pkt #22 accepted by the DUT |
| 12380 | **test** | STAGE: burst 2/8 sent: addr0..3 2/0/7/2, bad parity 2, gap 0 2, length 1..63 |
| 12390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 12390 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 12395 | **DUT** | OUT ch2 pkt #8 done: 30 bytes in 31 cycles |
| 12395 | ch2 monitor | ch2 RX pkt #8: addr=2 len=28 parity=bad |
| 12395 | scoreboard | ch2 pkt matched: addr=2 len=28 (12 matched so far) |
| 12400 | hbus driver | Executed WRITE addr=0x1000 data=0x11 |
| 12405 | **DUT** | CONFIG router_en=1 maxpktsize=17 |
| 12405 | hbus monitor | Collected WRITE addr=0x1000 data=0x11 |
| 12405 | reference | maxpktsize is now 17 |
| 12420 | hbus driver | Executed WRITE addr=0x1001 data=0x3f |
| 12425 | hbus monitor | Collected WRITE addr=0x1001 data=0x3f |
| 12425 | reference | router_en is now 1 (en_reg 0x3f) |
| 12440 | hbus driver | Executed WRITE addr=0x118f data=0xfb |
| 12445 | hbus monitor | Collected WRITE addr=0x118f data=0xfb |
| 12470 | hbus driver | Executed READ  addr=0x118f data=0xfb |
| 12475 | hbus monitor | Collected READ  addr=0x118f data=0xfb |
| 12490 | hbus driver | Executed WRITE addr=0x11d9 data=0x75 |
| 12495 | hbus monitor | Collected WRITE addr=0x11d9 data=0x75 |
| 12500 | ch0 driver | ch0: packet consumed (response delay 5) |
| 12520 | hbus driver | Executed READ  addr=0x11d9 data=0x75 |
| 12525 | hbus monitor | Collected READ  addr=0x11d9 data=0x75 |
| 12540 | hbus driver | Executed WRITE addr=0x1172 data=0x88 |
| 12545 | hbus monitor | Collected WRITE addr=0x1172 data=0x88 |
| 12570 | ch2 driver | ch2: packet consumed (response delay 0) |
| 12570 | hbus driver | Executed READ  addr=0x1172 data=0x88 |
| 12575 | hbus monitor | Collected READ  addr=0x1172 data=0x88 |
| 12600 | hbus driver | Executed READ  addr=0x10f1 data=0x00 |
| 12605 | hbus monitor | Collected READ  addr=0x10f1 data=0x00 |
| 12630 | hbus driver | Executed READ  addr=0x1013 data=0x2f |
| 12635 | hbus monitor | Collected READ  addr=0x1013 data=0x2f |
| 12660 | hbus driver | Executed READ  addr=0x104f data=0x5b |
| 12660 | **test** | STAGE: burst 3/8: ctrl=0x11 (maxpktsize 17) en=0x3f (router on, counter enables 0011111), 11 packet(s) |
| 12660 | yapp driver | TX pkt #23: addr=2 len=52 parity=bad delay=4 |
| 12665 | hbus monitor | Collected READ  addr=0x104f data=0x5b |
| 12715 | **DUT** | IN  pkt #23 header: addr=2 len=52 -> DROP (oversized: len 52 > maxpktsize 17) |
| 13245 | **DUT** | IN  pkt #23 complete: addr=2 len=52 parity=BAD dropped, 54 bytes in 54 cycles (held 0) |
| 13245 | yapp monitor | RX pkt #23 on the input: addr=2 len=52 parity=bad gap=33 |
| 13245 | reference | Packet dropped: length 52 > maxpktsize 17 (addr=2) |
| 13245 | **DUT** | ROUTER DROPS PACKET addr=2 length=52 (length > maxpktsize) |
| 13250 | yapp driver | TX pkt #23 accepted by the DUT |
| 13250 | yapp driver | TX pkt #24: addr=2 len=1 parity=good delay=6 |
| 13315 | **DUT** | IN  pkt #24 header: addr=2 len=1 -> channel 2 |
| 13325 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 13330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 13330 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 13335 | **DUT** | IN  pkt #24 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13335 | yapp monitor | RX pkt #24 on the input: addr=2 len=1 parity=good gap=6 |
| 13335 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 13340 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13340 | yapp driver | TX pkt #24 accepted by the DUT |
| 13340 | yapp driver | TX pkt #25: addr=0 len=31 parity=good delay=0 |
| 13345 | **DUT** | IN  pkt #25 header: addr=0 len=31 -> DROP (oversized: len 31 > maxpktsize 17) |
| 13355 | **DUT** | OUT ch2 pkt #9 done: 3 bytes in 4 cycles |
| 13355 | ch2 monitor | ch2 RX pkt #9: addr=2 len=1 parity=good |
| 13355 | scoreboard | ch2 pkt matched: addr=2 len=1 (13 matched so far) |
| 13665 | **DUT** | IN  pkt #25 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 13665 | yapp monitor | RX pkt #25 on the input: addr=0 len=31 parity=good gap=0 |
| 13665 | reference | Packet dropped: length 31 > maxpktsize 17 (addr=0) |
| 13665 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (length > maxpktsize) |
| 13670 | yapp driver | TX pkt #25 accepted by the DUT |
| 13670 | yapp driver | TX pkt #26: addr=2 len=50 parity=good delay=0 |
| 13675 | **DUT** | IN  pkt #26 header: addr=2 len=50 -> DROP (oversized: len 50 > maxpktsize 17) |
| 13910 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14185 | **DUT** | IN  pkt #26 complete: addr=2 len=50 parity=ok dropped, 52 bytes in 52 cycles (held 0) |
| 14185 | yapp monitor | RX pkt #26 on the input: addr=2 len=50 parity=good gap=0 |
| 14185 | reference | Packet dropped: length 50 > maxpktsize 17 (addr=2) |
| 14185 | **DUT** | ROUTER DROPS PACKET addr=2 length=50 (length > maxpktsize) |
| 14190 | yapp driver | TX pkt #26 accepted by the DUT |
| 14190 | yapp driver | TX pkt #27: addr=0 len=50 parity=bad delay=10 |
| 14295 | **DUT** | IN  pkt #27 header: addr=0 len=50 -> DROP (oversized: len 50 > maxpktsize 17) |
| 14805 | **DUT** | IN  pkt #27 complete: addr=0 len=50 parity=BAD dropped, 52 bytes in 52 cycles (held 0) |
| 14805 | yapp monitor | RX pkt #27 on the input: addr=0 len=50 parity=bad gap=10 |
| 14805 | reference | Packet dropped: length 50 > maxpktsize 17 (addr=0) |
| 14805 | **DUT** | ROUTER DROPS PACKET addr=0 length=50 (length > maxpktsize) |
| 14810 | yapp driver | TX pkt #27 accepted by the DUT |
| 14810 | yapp driver | TX pkt #28: addr=1 len=6 parity=good delay=12 |
| 14850 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 14850 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 14935 | **DUT** | IN  pkt #28 header: addr=1 len=6 -> channel 1 |
| 14995 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=6 (receiver waited 5 cycle(s)) |
| 15005 | **DUT** | IN  pkt #28 complete: addr=1 len=6 parity=ok forwarded, 8 bytes in 8 cycles (held 0) |
| 15005 | yapp monitor | RX pkt #28 on the input: addr=1 len=6 parity=good gap=12 |
| 15005 | reference | Packet forwarded: addr=1 len=6 -> channel 1 |
| 15010 | yapp driver | TX pkt #28 accepted by the DUT |
| 15010 | yapp driver | TX pkt #29: addr=0 len=18 parity=good delay=0 |
| 15015 | **DUT** | IN  pkt #29 header: addr=0 len=18 -> DROP (oversized: len 18 > maxpktsize 17) |
| 15060 | ch1 driver | ch1: packet consumed (response delay 5) |
| 15205 | **DUT** | IN  pkt #29 complete: addr=0 len=18 parity=ok dropped, 20 bytes in 20 cycles (held 0) |
| 15205 | yapp monitor | RX pkt #29 on the input: addr=0 len=18 parity=good gap=0 |
| 15205 | reference | Packet dropped: length 18 > maxpktsize 17 (addr=0) |
| 15205 | **DUT** | ROUTER DROPS PACKET addr=0 length=18 (length > maxpktsize) |
| 15210 | yapp driver | TX pkt #29 accepted by the DUT |
| 15210 | yapp driver | TX pkt #30: addr=0 len=14 parity=bad delay=4 |
| 15255 | **DUT** | IN  pkt #30 header: addr=0 len=14 -> channel 0 |
| 15365 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=14 (receiver waited 10 cycle(s)) |
| 15405 | **DUT** | IN  pkt #30 complete: addr=0 len=14 parity=BAD forwarded, 16 bytes in 16 cycles (held 0) |
| 15405 | yapp monitor | RX pkt #30 on the input: addr=0 len=14 parity=bad gap=4 |
| 15405 | reference | Packet forwarded: addr=0 len=14 -> channel 0 |
| 15410 | yapp driver | TX pkt #30 accepted by the DUT |
| 15410 | yapp driver | TX pkt #31: addr=0 len=63 parity=good delay=0 |
| 15415 | **DUT** | IN  pkt #31 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 17) |
| 15470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 15470 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 15510 | ch0 driver | ch0: packet consumed (response delay 10) |
| 15525 | **DUT** | OUT ch0 pkt #4 done: 16 bytes in 17 cycles |
| 15525 | ch0 monitor | ch0 RX pkt #4: addr=0 len=14 parity=bad |
| 15525 | scoreboard | ch0 pkt matched: addr=0 len=14 (14 matched so far) |
| 16040 | ch0 driver | ch0: packet consumed (response delay 0) |
| 16055 | **DUT** | IN  pkt #31 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 16055 | yapp monitor | RX pkt #31 on the input: addr=0 len=63 parity=good gap=0 |
| 16055 | reference | Packet dropped: length 63 > maxpktsize 17 (addr=0) |
| 16055 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 16060 | yapp driver | TX pkt #31 accepted by the DUT |
| 16060 | yapp driver | TX pkt #32: addr=1 len=16 parity=good delay=4 |
| 16105 | **DUT** | IN  pkt #32 header: addr=1 len=16 -> channel 1 |
| 16225 | **DUT** | OUT ch1 pkt #2 done: 8 bytes in 124 cycles |
| 16225 | ch1 monitor | ch1 RX pkt #2: addr=1 len=6 parity=good |
| 16225 | scoreboard | ch1 pkt matched: addr=1 len=6 (15 matched so far) |
| 16235 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=16 (receiver waited 0 cycle(s)) |
| 16275 | **DUT** | IN  pkt #32 complete: addr=1 len=16 parity=ok forwarded, 18 bytes in 18 cycles (held 0) |
| 16275 | yapp monitor | RX pkt #32 on the input: addr=1 len=16 parity=good gap=4 |
| 16275 | reference | Packet forwarded: addr=1 len=16 -> channel 1 |
| 16280 | yapp driver | TX pkt #32 accepted by the DUT |
| 16280 | yapp driver | TX pkt #33: addr=3 len=29 parity=good delay=3 |
| 16315 | **DUT** | IN  pkt #33 header: addr=3 len=29 -> DROP (oversized: len 29 > maxpktsize 17) |
| 16405 | **DUT** | OUT ch1 pkt #3 done: 18 bytes in 18 cycles |
| 16405 | ch1 monitor | ch1 RX pkt #3: addr=1 len=16 parity=good |
| 16405 | scoreboard | ch1 pkt matched: addr=1 len=16 (16 matched so far) |
| 16550 | ch1 driver | ch1: packet consumed (response delay 115) |
| 16615 | **DUT** | IN  pkt #33 complete: addr=3 len=29 parity=ok dropped, 31 bytes in 31 cycles (held 0) |
| 16615 | yapp monitor | RX pkt #33 on the input: addr=3 len=29 parity=good gap=3 |
| 16615 | reference | Packet dropped: illegal address 3 (len=29) |
| 16615 | **DUT** | ROUTER DROPS PACKET addr=3 length=29 (    illegal address) |
| 16620 | yapp driver | TX pkt #33 accepted by the DUT |
| 16620 | **test** | STAGE: burst 3/8 sent: addr0..3 5/2/3/1, bad parity 3, gap 0 4, length 1..63 |
| 16640 | hbus driver | Executed WRITE addr=0x1000 data=0x01 |
| 16645 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 16645 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 16645 | reference | maxpktsize is now 1 |
| 16660 | hbus driver | Executed WRITE addr=0x1001 data=0x5b |
| 16665 | hbus monitor | Collected WRITE addr=0x1001 data=0x5b |
| 16665 | reference | router_en is now 1 (en_reg 0x5b) |
| 16690 | hbus driver | Executed READ  addr=0x100d data=0x1d |
| 16695 | hbus monitor | Collected READ  addr=0x100d data=0x1d |
| 16710 | hbus driver | Executed WRITE addr=0x114b data=0x48 |
| 16715 | hbus monitor | Collected WRITE addr=0x114b data=0x48 |
| 16740 | hbus driver | Executed READ  addr=0x114b data=0x48 |
| 16745 | hbus monitor | Collected READ  addr=0x114b data=0x48 |
| 16760 | hbus driver | Executed WRITE addr=0x11bf data=0x05 |
| 16765 | hbus monitor | Collected WRITE addr=0x11bf data=0x05 |
| 16790 | hbus driver | Executed READ  addr=0x11bf data=0x05 |
| 16795 | hbus monitor | Collected READ  addr=0x11bf data=0x05 |
| 16810 | hbus driver | Executed WRITE addr=0x1182 data=0x74 |
| 16815 | hbus monitor | Collected WRITE addr=0x1182 data=0x74 |
| 16840 | hbus driver | Executed READ  addr=0x1182 data=0x74 |
| 16845 | hbus monitor | Collected READ  addr=0x1182 data=0x74 |
| 16870 | hbus driver | Executed READ  addr=0x10d6 data=0x00 |
| 16875 | hbus monitor | Collected READ  addr=0x10d6 data=0x00 |
| 16890 | hbus driver | Executed WRITE addr=0x1187 data=0x15 |
| 16895 | hbus monitor | Collected WRITE addr=0x1187 data=0x15 |
| 16920 | hbus driver | Executed READ  addr=0x1187 data=0x15 |
| 16925 | hbus monitor | Collected READ  addr=0x1187 data=0x15 |
| 16950 | hbus driver | Executed READ  addr=0x1042 data=0x2d |
| 16955 | hbus monitor | Collected READ  addr=0x1042 data=0x2d |
| 16970 | hbus driver | Executed WRITE addr=0x11dd data=0x28 |
| 16975 | hbus monitor | Collected WRITE addr=0x11dd data=0x28 |
| 17000 | hbus driver | Executed READ  addr=0x11dd data=0x28 |
| 17005 | hbus monitor | Collected READ  addr=0x11dd data=0x28 |
| 17020 | hbus driver | Executed WRITE addr=0x11d0 data=0xef |
| 17025 | hbus monitor | Collected WRITE addr=0x11d0 data=0xef |
| 17050 | hbus driver | Executed READ  addr=0x11d0 data=0xef |
| 17050 | **test** | STAGE: burst 4/8: ctrl=0x01 (maxpktsize 1) en=0x5b (router on, counter enables 0101101), 12 packet(s) |
| 17050 | yapp driver | TX pkt #34: addr=3 len=63 parity=good delay=20 |
| 17055 | hbus monitor | Collected READ  addr=0x11d0 data=0xef |
| 17265 | **DUT** | IN  pkt #34 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 1) |
| 17905 | **DUT** | IN  pkt #34 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 17905 | yapp monitor | RX pkt #34 on the input: addr=3 len=63 parity=good gap=64 |
| 17905 | reference | Packet dropped: illegal address 3 (len=63) |
| 17905 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 17910 | yapp driver | TX pkt #34 accepted by the DUT |
| 17910 | yapp driver | TX pkt #35: addr=2 len=63 parity=good delay=9 |
| 18005 | **DUT** | IN  pkt #35 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 1) |
| 18645 | **DUT** | IN  pkt #35 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 18645 | yapp monitor | RX pkt #35 on the input: addr=2 len=63 parity=good gap=9 |
| 18645 | reference | Packet dropped: length 63 > maxpktsize 1 (addr=2) |
| 18645 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 18650 | yapp driver | TX pkt #35 accepted by the DUT |
| 18650 | yapp driver | TX pkt #36: addr=2 len=51 parity=good delay=0 |
| 18655 | **DUT** | IN  pkt #36 header: addr=2 len=51 -> DROP (oversized: len 51 > maxpktsize 1) |
| 19175 | **DUT** | IN  pkt #36 complete: addr=2 len=51 parity=ok dropped, 53 bytes in 53 cycles (held 0) |
| 19175 | yapp monitor | RX pkt #36 on the input: addr=2 len=51 parity=good gap=0 |
| 19175 | reference | Packet dropped: length 51 > maxpktsize 1 (addr=2) |
| 19175 | **DUT** | ROUTER DROPS PACKET addr=2 length=51 (length > maxpktsize) |
| 19180 | yapp driver | TX pkt #36 accepted by the DUT |
| 19180 | yapp driver | TX pkt #37: addr=3 len=1 parity=good delay=4 |
| 19225 | **DUT** | IN  pkt #37 header: addr=3 len=1 -> DROP (illegal address 3) |
| 19245 | **DUT** | IN  pkt #37 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 19245 | yapp monitor | RX pkt #37 on the input: addr=3 len=1 parity=good gap=4 |
| 19245 | reference | Packet dropped: illegal address 3 (len=1) |
| 19245 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 19250 | yapp driver | TX pkt #37 accepted by the DUT |
| 19250 | yapp driver | TX pkt #38: addr=0 len=1 parity=good delay=0 |
| 19255 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 19275 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19275 | yapp monitor | RX pkt #38 on the input: addr=0 len=1 parity=good gap=0 |
| 19275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19280 | yapp driver | TX pkt #38 accepted by the DUT |
| 19280 | yapp driver | TX pkt #39: addr=3 len=2 parity=good delay=10 |
| 19345 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 19360 | ch0 driver | ch0: packet consumed (response delay 8) |
| 19385 | **DUT** | IN  pkt #39 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 19415 | **DUT** | IN  pkt #39 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 19415 | yapp monitor | RX pkt #39 on the input: addr=3 len=2 parity=good gap=10 |
| 19415 | reference | Packet dropped: illegal address 3 (len=2) |
| 19415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 19420 | yapp driver | TX pkt #39 accepted by the DUT |
| 19420 | yapp driver | TX pkt #40: addr=1 len=15 parity=good delay=0 |
| 19425 | **DUT** | IN  pkt #40 header: addr=1 len=15 -> DROP (oversized: len 15 > maxpktsize 1) |
| 19475 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 14 cycles |
| 19475 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 19475 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 19530 | ch0 driver | ch0: packet consumed (response delay 10) |
| 19585 | **DUT** | IN  pkt #40 complete: addr=1 len=15 parity=ok dropped, 17 bytes in 17 cycles (held 0) |
| 19585 | yapp monitor | RX pkt #40 on the input: addr=1 len=15 parity=good gap=0 |
| 19585 | reference | Packet dropped: length 15 > maxpktsize 1 (addr=1) |
| 19585 | **DUT** | ROUTER DROPS PACKET addr=1 length=15 (length > maxpktsize) |
| 19590 | yapp driver | TX pkt #40 accepted by the DUT |
| 19590 | yapp driver | TX pkt #41: addr=2 len=63 parity=good delay=9 |
| 19685 | **DUT** | IN  pkt #41 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 1) |
| 20325 | **DUT** | IN  pkt #41 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 20325 | yapp monitor | RX pkt #41 on the input: addr=2 len=63 parity=good gap=9 |
| 20325 | reference | Packet dropped: length 63 > maxpktsize 1 (addr=2) |
| 20325 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 20330 | yapp driver | TX pkt #41 accepted by the DUT |
| 20330 | yapp driver | TX pkt #42: addr=2 len=20 parity=good delay=7 |
| 20405 | **DUT** | IN  pkt #42 header: addr=2 len=20 -> DROP (oversized: len 20 > maxpktsize 1) |
| 20615 | **DUT** | IN  pkt #42 complete: addr=2 len=20 parity=ok dropped, 22 bytes in 22 cycles (held 0) |
| 20615 | yapp monitor | RX pkt #42 on the input: addr=2 len=20 parity=good gap=7 |
| 20615 | reference | Packet dropped: length 20 > maxpktsize 1 (addr=2) |
| 20615 | **DUT** | ROUTER DROPS PACKET addr=2 length=20 (length > maxpktsize) |
| 20620 | yapp driver | TX pkt #42 accepted by the DUT |
| 20620 | yapp driver | TX pkt #43: addr=2 len=2 parity=good delay=3 |
| 20655 | **DUT** | IN  pkt #43 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 20685 | **DUT** | IN  pkt #43 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 20685 | yapp monitor | RX pkt #43 on the input: addr=2 len=2 parity=good gap=3 |
| 20685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 20685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 20690 | yapp driver | TX pkt #43 accepted by the DUT |
| 20690 | yapp driver | TX pkt #44: addr=1 len=33 parity=bad delay=0 |
| 20695 | **DUT** | IN  pkt #44 header: addr=1 len=33 -> DROP (oversized: len 33 > maxpktsize 1) |
| 21035 | **DUT** | IN  pkt #44 complete: addr=1 len=33 parity=BAD dropped, 35 bytes in 35 cycles (held 0) |
| 21035 | yapp monitor | RX pkt #44 on the input: addr=1 len=33 parity=bad gap=0 |
| 21035 | reference | Packet dropped: length 33 > maxpktsize 1 (addr=1) |
| 21035 | **DUT** | ROUTER DROPS PACKET addr=1 length=33 (length > maxpktsize) |
| 21040 | yapp driver | TX pkt #44 accepted by the DUT |
| 21040 | yapp driver | TX pkt #45: addr=0 len=50 parity=good delay=0 |
| 21045 | **DUT** | IN  pkt #45 header: addr=0 len=50 -> DROP (oversized: len 50 > maxpktsize 1) |
| 21070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 21070 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 21555 | **DUT** | IN  pkt #45 complete: addr=0 len=50 parity=ok dropped, 52 bytes in 52 cycles (held 0) |
| 21555 | yapp monitor | RX pkt #45 on the input: addr=0 len=50 parity=good gap=0 |
| 21555 | reference | Packet dropped: length 50 > maxpktsize 1 (addr=0) |
| 21555 | **DUT** | ROUTER DROPS PACKET addr=0 length=50 (length > maxpktsize) |
| 21560 | yapp driver | TX pkt #45 accepted by the DUT |
| 21560 | **test** | STAGE: burst 4/8 sent: addr0..3 2/2/5/3, bad parity 1, gap 0 5, length 1..63 |
| 21580 | hbus driver | Executed WRITE addr=0x1000 data=0x91 |
| 21585 | **DUT** | CONFIG router_en=1 maxpktsize=17 |
| 21585 | hbus monitor | Collected WRITE addr=0x1000 data=0x91 |
| 21585 | reference | maxpktsize is now 17 |
| 21600 | hbus driver | Executed WRITE addr=0x1001 data=0x4f |
| 21605 | hbus monitor | Collected WRITE addr=0x1001 data=0x4f |
| 21605 | reference | router_en is now 1 (en_reg 0x4f) |
| 21620 | hbus driver | Executed WRITE addr=0x1169 data=0x6b |
| 21625 | hbus monitor | Collected WRITE addr=0x1169 data=0x6b |
| 21650 | hbus driver | Executed READ  addr=0x1169 data=0x6b |
| 21655 | hbus monitor | Collected READ  addr=0x1169 data=0x6b |
| 21670 | hbus driver | Executed WRITE addr=0x1156 data=0x9a |
| 21675 | hbus monitor | Collected WRITE addr=0x1156 data=0x9a |
| 21700 | hbus driver | Executed READ  addr=0x1156 data=0x9a |
| 21705 | hbus monitor | Collected READ  addr=0x1156 data=0x9a |
| 21730 | hbus driver | Executed READ  addr=0x1028 data=0x4b |
| 21735 | hbus monitor | Collected READ  addr=0x1028 data=0x4b |
| 21750 | hbus driver | Executed WRITE addr=0x11b4 data=0x2d |
| 21755 | hbus monitor | Collected WRITE addr=0x11b4 data=0x2d |
| 21780 | hbus driver | Executed READ  addr=0x11b4 data=0x2d |
| 21785 | hbus monitor | Collected READ  addr=0x11b4 data=0x2d |
| 21810 | hbus driver | Executed READ  addr=0x100d data=0x32 |
| 21815 | hbus monitor | Collected READ  addr=0x100d data=0x32 |
| 21830 | hbus driver | Executed WRITE addr=0x1124 data=0xb5 |
| 21835 | hbus monitor | Collected WRITE addr=0x1124 data=0xb5 |
| 21860 | hbus driver | Executed READ  addr=0x1124 data=0xb5 |
| 21865 | hbus monitor | Collected READ  addr=0x1124 data=0xb5 |
| 21890 | hbus driver | Executed READ  addr=0x108c data=0x00 |
| 21890 | **test** | STAGE: burst 5/8: ctrl=0x91 (maxpktsize 17) en=0x4f (router on, counter enables 0100111), 11 packet(s) |
| 21890 | yapp driver | TX pkt #46: addr=0 len=17 parity=good delay=3 |
| 21895 | hbus monitor | Collected READ  addr=0x108c data=0x00 |
| 21935 | **DUT** | IN  pkt #46 header: addr=0 len=17 -> channel 0 |
| 22045 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=17 (receiver waited 10 cycle(s)) |
| 22115 | **DUT** | IN  pkt #46 complete: addr=0 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 22115 | yapp monitor | RX pkt #46 on the input: addr=0 len=17 parity=good gap=37 |
| 22115 | reference | Packet forwarded: addr=0 len=17 -> channel 0 |
| 22120 | yapp driver | TX pkt #46 accepted by the DUT |
| 22120 | yapp driver | TX pkt #47: addr=2 len=1 parity=good delay=4 |
| 22165 | **DUT** | IN  pkt #47 header: addr=2 len=1 -> channel 2 |
| 22175 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 22185 | **DUT** | IN  pkt #47 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22185 | yapp monitor | RX pkt #47 on the input: addr=2 len=1 parity=good gap=4 |
| 22185 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 22190 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22190 | yapp driver | TX pkt #47 accepted by the DUT |
| 22190 | yapp driver | TX pkt #48: addr=1 len=16 parity=bad delay=1 |
| 22205 | **DUT** | IN  pkt #48 header: addr=1 len=16 -> channel 1 |
| 22205 | **DUT** | OUT ch2 pkt #10 done: 3 bytes in 4 cycles |
| 22205 | ch2 monitor | ch2 RX pkt #10: addr=2 len=1 parity=good |
| 22205 | scoreboard | ch2 pkt matched: addr=2 len=1 (18 matched so far) |
| 22220 | ch0 driver | ch0: packet consumed (response delay 10) |
| 22245 | **DUT** | OUT ch0 pkt #6 done: 19 bytes in 21 cycles |
| 22245 | ch0 monitor | ch0 RX pkt #6: addr=0 len=17 parity=good |
| 22245 | scoreboard | ch0 pkt matched: addr=0 len=17 (19 matched so far) |
| 22275 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=16 (receiver waited 6 cycle(s)) |
| 22370 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22375 | **DUT** | IN  pkt #48 complete: addr=1 len=16 parity=BAD forwarded, 18 bytes in 18 cycles (held 0) |
| 22375 | yapp monitor | RX pkt #48 on the input: addr=1 len=16 parity=bad gap=1 |
| 22375 | reference | Packet forwarded: addr=1 len=16 -> channel 1 |
| 22380 | yapp driver | TX pkt #48 accepted by the DUT |
| 22380 | yapp driver | TX pkt #49: addr=3 len=16 parity=bad delay=4 |
| 22425 | **DUT** | IN  pkt #49 header: addr=3 len=16 -> DROP (illegal address 3) |
| 22440 | ch1 driver | ch1: packet consumed (response delay 6) |
| 22455 | **DUT** | OUT ch1 pkt #4 done: 18 bytes in 19 cycles |
| 22455 | ch1 monitor | ch1 RX pkt #4: addr=1 len=16 parity=bad |
| 22455 | scoreboard | ch1 pkt matched: addr=1 len=16 (20 matched so far) |
| 22470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 22470 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 22570 | ch0 driver | ch0: packet consumed (response delay 1) |
| 22595 | **DUT** | IN  pkt #49 complete: addr=3 len=16 parity=BAD dropped, 18 bytes in 18 cycles (held 0) |
| 22595 | yapp monitor | RX pkt #49 on the input: addr=3 len=16 parity=bad gap=4 |
| 22595 | reference | Packet dropped: illegal address 3 (len=16) |
| 22595 | **DUT** | ROUTER DROPS PACKET addr=3 length=16 (    illegal address) |
| 22600 | yapp driver | TX pkt #49 accepted by the DUT |
| 22600 | yapp driver | TX pkt #50: addr=2 len=49 parity=good delay=4 |
| 22645 | **DUT** | IN  pkt #50 header: addr=2 len=49 -> DROP (oversized: len 49 > maxpktsize 17) |
| 22650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 22650 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 22750 | ch1 driver | ch1: packet consumed (response delay 0) |
| 23145 | **DUT** | IN  pkt #50 complete: addr=2 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 23145 | yapp monitor | RX pkt #50 on the input: addr=2 len=49 parity=good gap=4 |
| 23145 | reference | Packet dropped: length 49 > maxpktsize 17 (addr=2) |
| 23145 | **DUT** | ROUTER DROPS PACKET addr=2 length=49 (length > maxpktsize) |
| 23150 | yapp driver | TX pkt #50 accepted by the DUT |
| 23150 | yapp driver | TX pkt #51: addr=1 len=63 parity=bad delay=19 |
| 23345 | **DUT** | IN  pkt #51 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 17) |
| 23985 | **DUT** | IN  pkt #51 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 23985 | yapp monitor | RX pkt #51 on the input: addr=1 len=63 parity=bad gap=19 |
| 23985 | reference | Packet dropped: length 63 > maxpktsize 17 (addr=1) |
| 23985 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 23990 | yapp driver | TX pkt #51 accepted by the DUT |
| 23990 | yapp driver | TX pkt #52: addr=1 len=17 parity=good delay=2 |
| 24015 | **DUT** | IN  pkt #52 header: addr=1 len=17 -> channel 1 |
| 24025 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=17 (receiver waited 0 cycle(s)) |
| 24090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 24090 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 24195 | **DUT** | IN  pkt #52 complete: addr=1 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 24195 | yapp monitor | RX pkt #52 on the input: addr=1 len=17 parity=good gap=2 |
| 24195 | reference | Packet forwarded: addr=1 len=17 -> channel 1 |
| 24200 | ch1 driver | ch1: packet consumed (response delay 0) |
| 24200 | yapp driver | TX pkt #52 accepted by the DUT |
| 24200 | yapp driver | TX pkt #53: addr=1 len=63 parity=good delay=2 |
| 24225 | **DUT** | IN  pkt #53 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 17) |
| 24865 | **DUT** | IN  pkt #53 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 24865 | yapp monitor | RX pkt #53 on the input: addr=1 len=63 parity=good gap=2 |
| 24865 | reference | Packet dropped: length 63 > maxpktsize 17 (addr=1) |
| 24865 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 24870 | yapp driver | TX pkt #53 accepted by the DUT |
| 24870 | yapp driver | TX pkt #54: addr=1 len=63 parity=good delay=5 |
| 24925 | **DUT** | IN  pkt #54 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 17) |
| 24955 | **DUT** | OUT ch1 pkt #5 done: 19 bytes in 94 cycles |
| 24955 | ch1 monitor | ch1 RX pkt #5: addr=1 len=17 parity=good |
| 24955 | scoreboard | ch1 pkt matched: addr=1 len=17 (21 matched so far) |
| 25400 | ch1 driver | ch1: packet consumed (response delay 74) |
| 25565 | **DUT** | IN  pkt #54 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 25565 | yapp monitor | RX pkt #54 on the input: addr=1 len=63 parity=good gap=5 |
| 25565 | reference | Packet dropped: length 63 > maxpktsize 17 (addr=1) |
| 25565 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 25570 | yapp driver | TX pkt #54 accepted by the DUT |
| 25570 | yapp driver | TX pkt #55: addr=1 len=46 parity=good delay=0 |
| 25575 | **DUT** | IN  pkt #55 header: addr=1 len=46 -> DROP (oversized: len 46 > maxpktsize 17) |
| 26045 | **DUT** | IN  pkt #55 complete: addr=1 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 26045 | yapp monitor | RX pkt #55 on the input: addr=1 len=46 parity=good gap=0 |
| 26045 | reference | Packet dropped: length 46 > maxpktsize 17 (addr=1) |
| 26045 | **DUT** | ROUTER DROPS PACKET addr=1 length=46 (length > maxpktsize) |
| 26050 | yapp driver | TX pkt #55 accepted by the DUT |
| 26050 | yapp driver | TX pkt #56: addr=2 len=18 parity=bad delay=0 |
| 26055 | **DUT** | IN  pkt #56 header: addr=2 len=18 -> DROP (oversized: len 18 > maxpktsize 17) |
| 26245 | **DUT** | IN  pkt #56 complete: addr=2 len=18 parity=BAD dropped, 20 bytes in 20 cycles (held 0) |
| 26245 | yapp monitor | RX pkt #56 on the input: addr=2 len=18 parity=bad gap=0 |
| 26245 | reference | Packet dropped: length 18 > maxpktsize 17 (addr=2) |
| 26245 | **DUT** | ROUTER DROPS PACKET addr=2 length=18 (length > maxpktsize) |
| 26250 | yapp driver | TX pkt #56 accepted by the DUT |
| 26250 | **test** | STAGE: burst 5/8 sent: addr0..3 1/6/3/1, bad parity 4, gap 0 2, length 1..63 |
| 26270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 26270 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 26270 | hbus driver | Executed WRITE addr=0x1000 data=0x98 |
| 26275 | **DUT** | CONFIG router_en=1 maxpktsize=24 |
| 26275 | hbus monitor | Collected WRITE addr=0x1000 data=0x98 |
| 26275 | reference | maxpktsize is now 24 |
| 26290 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 26295 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 26295 | reference | router_en is now 1 (en_reg 0xff) |
| 26320 | hbus driver | Executed READ  addr=0x105f data=0x00 |
| 26325 | hbus monitor | Collected READ  addr=0x105f data=0x00 |
| 26350 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 26355 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26380 | hbus driver | Executed READ  addr=0x1005 data=0x0d |
| 26385 | hbus monitor | Collected READ  addr=0x1005 data=0x0d |
| 26400 | hbus driver | Executed WRITE addr=0x11e8 data=0x00 |
| 26405 | hbus monitor | Collected WRITE addr=0x11e8 data=0x00 |
| 26430 | hbus driver | Executed READ  addr=0x11e8 data=0x00 |
| 26435 | hbus monitor | Collected READ  addr=0x11e8 data=0x00 |
| 26450 | hbus driver | Executed WRITE addr=0x119b data=0x34 |
| 26455 | hbus monitor | Collected WRITE addr=0x119b data=0x34 |
| 26480 | hbus driver | Executed READ  addr=0x119b data=0x34 |
| 26480 | **test** | STAGE: burst 6/8: ctrl=0x98 (maxpktsize 24) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 26480 | yapp driver | TX pkt #57: addr=2 len=63 parity=good delay=2 |
| 26485 | hbus monitor | Collected READ  addr=0x119b data=0x34 |
| 26515 | **DUT** | IN  pkt #57 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 24) |
| 27155 | **DUT** | IN  pkt #57 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 27155 | yapp monitor | RX pkt #57 on the input: addr=2 len=63 parity=good gap=26 |
| 27155 | reference | Packet dropped: length 63 > maxpktsize 24 (addr=2) |
| 27155 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 27160 | yapp driver | TX pkt #57 accepted by the DUT |
| 27160 | yapp driver | TX pkt #58: addr=3 len=56 parity=good delay=0 |
| 27165 | **DUT** | IN  pkt #58 header: addr=3 len=56 -> DROP (oversized: len 56 > maxpktsize 24) |
| 27735 | **DUT** | IN  pkt #58 complete: addr=3 len=56 parity=ok dropped, 58 bytes in 58 cycles (held 0) |
| 27735 | yapp monitor | RX pkt #58 on the input: addr=3 len=56 parity=good gap=0 |
| 27735 | reference | Packet dropped: illegal address 3 (len=56) |
| 27735 | **DUT** | ROUTER DROPS PACKET addr=3 length=56 (    illegal address) |
| 27740 | yapp driver | TX pkt #58 accepted by the DUT |
| 27740 | yapp driver | TX pkt #59: addr=0 len=25 parity=bad delay=9 |
| 27835 | **DUT** | IN  pkt #59 header: addr=0 len=25 -> DROP (oversized: len 25 > maxpktsize 24) |
| 28095 | **DUT** | IN  pkt #59 complete: addr=0 len=25 parity=BAD dropped, 27 bytes in 27 cycles (held 0) |
| 28095 | yapp monitor | RX pkt #59 on the input: addr=0 len=25 parity=bad gap=9 |
| 28095 | reference | Packet dropped: length 25 > maxpktsize 24 (addr=0) |
| 28095 | **DUT** | ROUTER DROPS PACKET addr=0 length=25 (length > maxpktsize) |
| 28100 | yapp driver | TX pkt #59 accepted by the DUT |
| 28100 | yapp driver | TX pkt #60: addr=2 len=1 parity=good delay=2 |
| 28125 | **DUT** | IN  pkt #60 header: addr=2 len=1 -> channel 2 |
| 28135 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 28145 | **DUT** | IN  pkt #60 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28145 | yapp monitor | RX pkt #60 on the input: addr=2 len=1 parity=good gap=2 |
| 28145 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 28150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 28150 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 28150 | ch2 driver | ch2: packet consumed (response delay 0) |
| 28150 | yapp driver | TX pkt #60 accepted by the DUT |
| 28150 | yapp driver | TX pkt #61: addr=3 len=56 parity=good delay=16 |
| 28165 | **DUT** | OUT ch2 pkt #11 done: 3 bytes in 4 cycles |
| 28165 | ch2 monitor | ch2 RX pkt #11: addr=2 len=1 parity=good |
| 28165 | scoreboard | ch2 pkt matched: addr=2 len=1 (22 matched so far) |
| 28315 | **DUT** | IN  pkt #61 header: addr=3 len=56 -> DROP (oversized: len 56 > maxpktsize 24) |
| 28740 | ch2 driver | ch2: packet consumed (response delay 0) |
| 28885 | **DUT** | IN  pkt #61 complete: addr=3 len=56 parity=ok dropped, 58 bytes in 58 cycles (held 0) |
| 28885 | yapp monitor | RX pkt #61 on the input: addr=3 len=56 parity=good gap=16 |
| 28885 | reference | Packet dropped: illegal address 3 (len=56) |
| 28885 | **DUT** | ROUTER DROPS PACKET addr=3 length=56 (    illegal address) |
| 28890 | yapp driver | TX pkt #61 accepted by the DUT |
| 28890 | yapp driver | TX pkt #62: addr=2 len=63 parity=good delay=11 |
| 29005 | **DUT** | IN  pkt #62 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 24) |
| 29645 | **DUT** | IN  pkt #62 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 29645 | yapp monitor | RX pkt #62 on the input: addr=2 len=63 parity=good gap=11 |
| 29645 | reference | Packet dropped: length 63 > maxpktsize 24 (addr=2) |
| 29645 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 29650 | yapp driver | TX pkt #62 accepted by the DUT |
| 29650 | yapp driver | TX pkt #63: addr=3 len=63 parity=good delay=2 |
| 29675 | **DUT** | IN  pkt #63 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 24) |
| 30315 | **DUT** | IN  pkt #63 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 30315 | yapp monitor | RX pkt #63 on the input: addr=3 len=63 parity=good gap=2 |
| 30315 | reference | Packet dropped: illegal address 3 (len=63) |
| 30315 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 30320 | yapp driver | TX pkt #63 accepted by the DUT |
| 30320 | yapp driver | TX pkt #64: addr=2 len=63 parity=good delay=3 |
| 30355 | **DUT** | IN  pkt #64 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 24) |
| 30995 | **DUT** | IN  pkt #64 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 30995 | yapp monitor | RX pkt #64 on the input: addr=2 len=63 parity=good gap=3 |
| 30995 | reference | Packet dropped: length 63 > maxpktsize 24 (addr=2) |
| 30995 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 31000 | yapp driver | TX pkt #64 accepted by the DUT |
| 31000 | yapp driver | TX pkt #65: addr=3 len=63 parity=good delay=3 |
| 31035 | **DUT** | IN  pkt #65 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 24) |
| 31675 | **DUT** | IN  pkt #65 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 31675 | yapp monitor | RX pkt #65 on the input: addr=3 len=63 parity=good gap=3 |
| 31675 | reference | Packet dropped: illegal address 3 (len=63) |
| 31675 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 31680 | yapp driver | TX pkt #65 accepted by the DUT |
| 31680 | yapp driver | TX pkt #66: addr=0 len=24 parity=good delay=0 |
| 31685 | **DUT** | IN  pkt #66 header: addr=0 len=24 -> channel 0 |
| 31695 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=24 (receiver waited 0 cycle(s)) |
| 31935 | **DUT** | IN  pkt #66 complete: addr=0 len=24 parity=ok forwarded, 26 bytes in 26 cycles (held 0) |
| 31935 | yapp monitor | RX pkt #66 on the input: addr=0 len=24 parity=good gap=0 |
| 31935 | reference | Packet forwarded: addr=0 len=24 -> channel 0 |
| 31940 | ch0 driver | ch0: packet consumed (response delay 0) |
| 31940 | yapp driver | TX pkt #66 accepted by the DUT |
| 31940 | yapp driver | TX pkt #67: addr=2 len=54 parity=bad delay=0 |
| 31945 | **DUT** | IN  pkt #67 header: addr=2 len=54 -> DROP (oversized: len 54 > maxpktsize 24) |
| 31965 | **DUT** | OUT ch0 pkt #7 done: 26 bytes in 28 cycles |
| 31965 | ch0 monitor | ch0 RX pkt #7: addr=0 len=24 parity=good |
| 31965 | scoreboard | ch0 pkt matched: addr=0 len=24 (23 matched so far) |
| 32490 | ch0 driver | ch0: packet consumed (response delay 1) |
| 32495 | **DUT** | IN  pkt #67 complete: addr=2 len=54 parity=BAD dropped, 56 bytes in 56 cycles (held 0) |
| 32495 | yapp monitor | RX pkt #67 on the input: addr=2 len=54 parity=bad gap=0 |
| 32495 | reference | Packet dropped: length 54 > maxpktsize 24 (addr=2) |
| 32495 | **DUT** | ROUTER DROPS PACKET addr=2 length=54 (length > maxpktsize) |
| 32500 | yapp driver | TX pkt #67 accepted by the DUT |
| 32500 | **test** | STAGE: burst 6/8 sent: addr0..3 2/0/5/4, bad parity 2, gap 0 3, length 1..63 |
| 32520 | hbus driver | Executed WRITE addr=0x1000 data=0xde |
| 32525 | **DUT** | CONFIG router_en=1 maxpktsize=30 |
| 32525 | hbus monitor | Collected WRITE addr=0x1000 data=0xde |
| 32525 | reference | maxpktsize is now 30 |
| 32530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 32530 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 32540 | hbus driver | Executed WRITE addr=0x1001 data=0x41 |
| 32545 | hbus monitor | Collected WRITE addr=0x1001 data=0x41 |
| 32545 | reference | router_en is now 1 (en_reg 0x41) |
| 32570 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 32575 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 32600 | hbus driver | Executed READ  addr=0x1034 data=0xaf |
| 32605 | hbus monitor | Collected READ  addr=0x1034 data=0xaf |
| 32620 | hbus driver | Executed WRITE addr=0x1108 data=0x22 |
| 32625 | hbus monitor | Collected WRITE addr=0x1108 data=0x22 |
| 32650 | hbus driver | Executed READ  addr=0x1108 data=0x22 |
| 32655 | hbus monitor | Collected READ  addr=0x1108 data=0x22 |
| 32680 | hbus driver | Executed READ  addr=0x1001 data=0x41 |
| 32685 | hbus monitor | Collected READ  addr=0x1001 data=0x41 |
| 32710 | hbus driver | Executed READ  addr=0x100d data=0x36 |
| 32715 | hbus monitor | Collected READ  addr=0x100d data=0x36 |
| 32740 | hbus driver | Executed READ  addr=0x1000 data=0xde |
| 32740 | **test** | STAGE: burst 7/8: ctrl=0xde (maxpktsize 30) en=0x41 (router on, counter enables 0100000), 11 packet(s) |
| 32740 | yapp driver | TX pkt #68: addr=0 len=29 parity=bad delay=2 |
| 32745 | hbus monitor | Collected READ  addr=0x1000 data=0xde |
| 32775 | **DUT** | IN  pkt #68 header: addr=0 len=29 -> channel 0 |
| 32885 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=29 (receiver waited 10 cycle(s)) |
| 33075 | **DUT** | IN  pkt #68 complete: addr=0 len=29 parity=BAD forwarded, 31 bytes in 31 cycles (held 0) |
| 33075 | yapp monitor | RX pkt #68 on the input: addr=0 len=29 parity=bad gap=27 |
| 33075 | reference | Packet forwarded: addr=0 len=29 -> channel 0 |
| 33080 | yapp driver | TX pkt #68 accepted by the DUT |
| 33080 | yapp driver | TX pkt #69: addr=2 len=55 parity=good delay=20 |
| 33150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 33150 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 33180 | ch0 driver | ch0: packet consumed (response delay 10) |
| 33285 | **DUT** | IN  pkt #69 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 30) |
| 33295 | **DUT** | OUT ch0 pkt #8 done: 31 bytes in 42 cycles |
| 33295 | ch0 monitor | ch0 RX pkt #8: addr=0 len=29 parity=bad |
| 33295 | scoreboard | ch0 pkt matched: addr=0 len=29 (24 matched so far) |
| 33480 | ch0 driver | ch0: packet consumed (response delay 10) |
| 33845 | **DUT** | IN  pkt #69 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 33845 | yapp monitor | RX pkt #69 on the input: addr=2 len=55 parity=good gap=20 |
| 33845 | reference | Packet dropped: length 55 > maxpktsize 30 (addr=2) |
| 33845 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 33850 | yapp driver | TX pkt #69 accepted by the DUT |
| 33850 | yapp driver | TX pkt #70: addr=0 len=63 parity=good delay=18 |
| 34035 | **DUT** | IN  pkt #70 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 34675 | **DUT** | IN  pkt #70 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 34675 | yapp monitor | RX pkt #70 on the input: addr=0 len=63 parity=good gap=18 |
| 34675 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=0) |
| 34675 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 34680 | yapp driver | TX pkt #70 accepted by the DUT |
| 34680 | yapp driver | TX pkt #71: addr=1 len=63 parity=bad delay=3 |
| 34715 | **DUT** | IN  pkt #71 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 35355 | **DUT** | IN  pkt #71 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 35355 | yapp monitor | RX pkt #71 on the input: addr=1 len=63 parity=bad gap=3 |
| 35355 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=1) |
| 35355 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 35360 | yapp driver | TX pkt #71 accepted by the DUT |
| 35360 | yapp driver | TX pkt #72: addr=2 len=30 parity=good delay=2 |
| 35370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 35370 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 35385 | **DUT** | IN  pkt #72 header: addr=2 len=30 -> channel 2 |
| 35395 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=30 (receiver waited 0 cycle(s)) |
| 35695 | **DUT** | IN  pkt #72 complete: addr=2 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 35695 | yapp monitor | RX pkt #72 on the input: addr=2 len=30 parity=good gap=2 |
| 35695 | reference | Packet forwarded: addr=2 len=30 -> channel 2 |
| 35700 | ch2 driver | ch2: packet consumed (response delay 0) |
| 35700 | yapp driver | TX pkt #72 accepted by the DUT |
| 35700 | yapp driver | TX pkt #73: addr=0 len=63 parity=bad delay=0 |
| 35705 | **DUT** | IN  pkt #73 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 35715 | **DUT** | OUT ch2 pkt #12 done: 32 bytes in 33 cycles |
| 35715 | ch2 monitor | ch2 RX pkt #12: addr=2 len=30 parity=good |
| 35715 | scoreboard | ch2 pkt matched: addr=2 len=30 (25 matched so far) |
| 36070 | ch2 driver | ch2: packet consumed (response delay 0) |
| 36345 | **DUT** | IN  pkt #73 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 36345 | yapp monitor | RX pkt #73 on the input: addr=0 len=63 parity=bad gap=0 |
| 36345 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=0) |
| 36345 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 36350 | yapp driver | TX pkt #73 accepted by the DUT |
| 36350 | yapp driver | TX pkt #74: addr=2 len=30 parity=good delay=20 |
| 36390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 36390 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 36555 | **DUT** | IN  pkt #74 header: addr=2 len=30 -> channel 2 |
| 36565 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=30 (receiver waited 0 cycle(s)) |
| 36865 | **DUT** | IN  pkt #74 complete: addr=2 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 36865 | yapp monitor | RX pkt #74 on the input: addr=2 len=30 parity=good gap=20 |
| 36865 | reference | Packet forwarded: addr=2 len=30 -> channel 2 |
| 36870 | ch2 driver | ch2: packet consumed (response delay 0) |
| 36870 | yapp driver | TX pkt #74 accepted by the DUT |
| 36870 | yapp driver | TX pkt #75: addr=2 len=63 parity=good delay=20 |
| 36885 | **DUT** | OUT ch2 pkt #13 done: 32 bytes in 33 cycles |
| 36885 | ch2 monitor | ch2 RX pkt #13: addr=2 len=30 parity=good |
| 36885 | scoreboard | ch2 pkt matched: addr=2 len=30 (26 matched so far) |
| 37075 | **DUT** | IN  pkt #75 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 37520 | ch2 driver | ch2: packet consumed (response delay 0) |
| 37715 | **DUT** | IN  pkt #75 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 37715 | yapp monitor | RX pkt #75 on the input: addr=2 len=63 parity=good gap=20 |
| 37715 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=2) |
| 37715 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 37720 | yapp driver | TX pkt #75 accepted by the DUT |
| 37720 | yapp driver | TX pkt #76: addr=0 len=30 parity=good delay=0 |
| 37725 | **DUT** | IN  pkt #76 header: addr=0 len=30 -> channel 0 |
| 37835 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=30 (receiver waited 10 cycle(s)) |
| 38035 | **DUT** | IN  pkt #76 complete: addr=0 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 38035 | yapp monitor | RX pkt #76 on the input: addr=0 len=30 parity=good gap=0 |
| 38035 | reference | Packet forwarded: addr=0 len=30 -> channel 0 |
| 38040 | yapp driver | TX pkt #76 accepted by the DUT |
| 38040 | yapp driver | TX pkt #77: addr=1 len=17 parity=good delay=0 |
| 38045 | **DUT** | IN  pkt #77 header: addr=1 len=17 -> channel 1 |
| 38140 | ch0 driver | ch0: packet consumed (response delay 10) |
| 38205 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0x84 held (pkt #77) |
| 38235 | **DUT** | OUT ch0 pkt #9 done: 32 bytes in 41 cycles |
| 38235 | ch0 monitor | ch0 RX pkt #9: addr=0 len=30 parity=good |
| 38235 | scoreboard | ch0 pkt matched: addr=0 len=30 (27 matched so far) |
| 38650 | ch0 driver | ch0: packet consumed (response delay 8) |
| 38665 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=17 (receiver waited 61 cycle(s)) |
| 38675 | **DUT** | SUSPEND released after 47 cycle(s) |
| 38695 | **DUT** | IN  pkt #77 complete: addr=1 len=17 parity=ok forwarded, 19 bytes in 66 cycles (held 47) |
| 38695 | yapp monitor | RX pkt #77 on the input: addr=1 len=17 parity=good gap=0 |
| 38695 | reference | Packet forwarded: addr=1 len=17 -> channel 1 |
| 38700 | yapp driver | TX pkt #77 accepted by the DUT |
| 38700 | yapp driver | TX pkt #78: addr=2 len=46 parity=good delay=16 |
| 38840 | ch1 driver | ch1: packet consumed (response delay 61) |
| 38865 | **DUT** | IN  pkt #78 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 30) |
| 38895 | **DUT** | OUT ch1 pkt #6 done: 19 bytes in 24 cycles |
| 38895 | ch1 monitor | ch1 RX pkt #6: addr=1 len=17 parity=good |
| 38895 | scoreboard | ch1 pkt matched: addr=1 len=17 (28 matched so far) |
| 39020 | ch1 driver | ch1: packet consumed (response delay 4) |
| 39335 | **DUT** | IN  pkt #78 complete: addr=2 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 39335 | yapp monitor | RX pkt #78 on the input: addr=2 len=46 parity=good gap=16 |
| 39335 | reference | Packet dropped: length 46 > maxpktsize 30 (addr=2) |
| 39335 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 39340 | yapp driver | TX pkt #78 accepted by the DUT |
| 39340 | **test** | STAGE: burst 7/8 sent: addr0..3 4/2/5/0, bad parity 3, gap 0 3, length 17..63 |
| 39360 | hbus driver | Executed WRITE addr=0x1000 data=0x80 |
| 39365 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 39365 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 39365 | reference | maxpktsize is now 0 |
| 39380 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 39385 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 39385 | reference | router_en is now 1 (en_reg 0x01) |
| 39410 | hbus driver | Executed READ  addr=0x1004 data=0x0b |
| 39415 | hbus monitor | Collected READ  addr=0x1004 data=0x0b |
| 39430 | hbus driver | Executed WRITE addr=0x11dc data=0xa4 |
| 39435 | hbus monitor | Collected WRITE addr=0x11dc data=0xa4 |
| 39460 | hbus driver | Executed READ  addr=0x11dc data=0xa4 |
| 39465 | hbus monitor | Collected READ  addr=0x11dc data=0xa4 |
| 39490 | hbus driver | Executed READ  addr=0x101d data=0x95 |
| 39495 | hbus monitor | Collected READ  addr=0x101d data=0x95 |
| 39510 | hbus driver | Executed WRITE addr=0x11ea data=0xb0 |
| 39515 | hbus monitor | Collected WRITE addr=0x11ea data=0xb0 |
| 39540 | hbus driver | Executed READ  addr=0x11ea data=0xb0 |
| 39545 | hbus monitor | Collected READ  addr=0x11ea data=0xb0 |
| 39560 | hbus driver | Executed WRITE addr=0x116b data=0x72 |
| 39565 | hbus monitor | Collected WRITE addr=0x116b data=0x72 |
| 39590 | hbus driver | Executed READ  addr=0x116b data=0x72 |
| 39595 | hbus monitor | Collected READ  addr=0x116b data=0x72 |
| 39620 | hbus driver | Executed READ  addr=0x1009 data=0x0a |
| 39625 | hbus monitor | Collected READ  addr=0x1009 data=0x0a |
| 39640 | hbus driver | Executed WRITE addr=0x1102 data=0xbe |
| 39645 | hbus monitor | Collected WRITE addr=0x1102 data=0xbe |
| 39670 | hbus driver | Executed READ  addr=0x1102 data=0xbe |
| 39675 | hbus monitor | Collected READ  addr=0x1102 data=0xbe |
| 39690 | hbus driver | Executed WRITE addr=0x117b data=0xb4 |
| 39695 | hbus monitor | Collected WRITE addr=0x117b data=0xb4 |
| 39720 | hbus driver | Executed READ  addr=0x117b data=0xb4 |
| 39725 | hbus monitor | Collected READ  addr=0x117b data=0xb4 |
| 39740 | hbus driver | Executed WRITE addr=0x1169 data=0xbd |
| 39745 | hbus monitor | Collected WRITE addr=0x1169 data=0xbd |
| 39770 | hbus driver | Executed READ  addr=0x1169 data=0xbd |
| 39775 | hbus monitor | Collected READ  addr=0x1169 data=0xbd |
| 39800 | hbus driver | Executed READ  addr=0x100d data=0x2e |
| 39805 | hbus monitor | Collected READ  addr=0x100d data=0x2e |
| 39820 | hbus driver | Executed WRITE addr=0x11e3 data=0x7e |
| 39825 | hbus monitor | Collected WRITE addr=0x11e3 data=0x7e |
| 39850 | hbus driver | Executed READ  addr=0x11e3 data=0x7e |
| 39850 | **test** | STAGE: burst 8/8: ctrl=0x80 (maxpktsize 0) en=0x01 (router on, counter enables 0000000), 11 packet(s) |
| 39850 | yapp driver | TX pkt #79: addr=1 len=1 parity=good delay=2 |
| 39855 | hbus monitor | Collected READ  addr=0x11e3 data=0x7e |
| 39885 | **DUT** | IN  pkt #79 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 39905 | **DUT** | IN  pkt #79 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 39905 | yapp monitor | RX pkt #79 on the input: addr=1 len=1 parity=good gap=54 |
| 39905 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 39905 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 39910 | yapp driver | TX pkt #79 accepted by the DUT |
| 39910 | yapp driver | TX pkt #80: addr=2 len=63 parity=good delay=8 |
| 39995 | **DUT** | IN  pkt #80 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 40635 | **DUT** | IN  pkt #80 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 40635 | yapp monitor | RX pkt #80 on the input: addr=2 len=63 parity=good gap=8 |
| 40635 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 40635 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 40640 | yapp driver | TX pkt #80 accepted by the DUT |
| 40640 | yapp driver | TX pkt #81: addr=0 len=1 parity=good delay=0 |
| 40645 | **DUT** | IN  pkt #81 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 40665 | **DUT** | IN  pkt #81 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 40665 | yapp monitor | RX pkt #81 on the input: addr=0 len=1 parity=good gap=0 |
| 40665 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 40665 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 40670 | yapp driver | TX pkt #81 accepted by the DUT |
| 40670 | yapp driver | TX pkt #82: addr=0 len=63 parity=good delay=3 |
| 40705 | **DUT** | IN  pkt #82 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 41345 | **DUT** | IN  pkt #82 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 41345 | yapp monitor | RX pkt #82 on the input: addr=0 len=63 parity=good gap=3 |
| 41345 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=0) |
| 41345 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 41350 | yapp driver | TX pkt #82 accepted by the DUT |
| 41350 | yapp driver | TX pkt #83: addr=2 len=63 parity=good delay=0 |
| 41355 | **DUT** | IN  pkt #83 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 41995 | **DUT** | IN  pkt #83 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 41995 | yapp monitor | RX pkt #83 on the input: addr=2 len=63 parity=good gap=0 |
| 41995 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 41995 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 42000 | yapp driver | TX pkt #83 accepted by the DUT |
| 42000 | yapp driver | TX pkt #84: addr=2 len=1 parity=good delay=2 |
| 42025 | **DUT** | IN  pkt #84 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 42045 | **DUT** | IN  pkt #84 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 42045 | yapp monitor | RX pkt #84 on the input: addr=2 len=1 parity=good gap=2 |
| 42045 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 42045 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 42050 | yapp driver | TX pkt #84 accepted by the DUT |
| 42050 | yapp driver | TX pkt #85: addr=3 len=1 parity=good delay=20 |
| 42255 | **DUT** | IN  pkt #85 header: addr=3 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 42275 | **DUT** | IN  pkt #85 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 42275 | yapp monitor | RX pkt #85 on the input: addr=3 len=1 parity=good gap=20 |
| 42275 | reference | Packet dropped: illegal address 3 (len=1) |
| 42275 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 42280 | yapp driver | TX pkt #85 accepted by the DUT |
| 42280 | yapp driver | TX pkt #86: addr=2 len=1 parity=good delay=1 |
| 42295 | **DUT** | IN  pkt #86 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 42315 | **DUT** | IN  pkt #86 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 42315 | yapp monitor | RX pkt #86 on the input: addr=2 len=1 parity=good gap=1 |
| 42315 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 42315 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 42320 | yapp driver | TX pkt #86 accepted by the DUT |
| 42320 | yapp driver | TX pkt #87: addr=1 len=57 parity=good delay=10 |
| 42425 | **DUT** | IN  pkt #87 header: addr=1 len=57 -> DROP (oversized: len 57 > maxpktsize 0) |
| 43005 | **DUT** | IN  pkt #87 complete: addr=1 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 43005 | yapp monitor | RX pkt #87 on the input: addr=1 len=57 parity=good gap=10 |
| 43005 | reference | Packet dropped: length 57 > maxpktsize 0 (addr=1) |
| 43005 | **DUT** | ROUTER DROPS PACKET addr=1 length=57 (length > maxpktsize) |
| 43010 | yapp driver | TX pkt #87 accepted by the DUT |
| 43010 | yapp driver | TX pkt #88: addr=2 len=1 parity=good delay=18 |
| 43195 | **DUT** | IN  pkt #88 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 43215 | **DUT** | IN  pkt #88 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 43215 | yapp monitor | RX pkt #88 on the input: addr=2 len=1 parity=good gap=18 |
| 43215 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 43215 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 43220 | yapp driver | TX pkt #88 accepted by the DUT |
| 43220 | yapp driver | TX pkt #89: addr=2 len=1 parity=bad delay=2 |
| 43245 | **DUT** | IN  pkt #89 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 43265 | **DUT** | IN  pkt #89 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 43265 | yapp monitor | RX pkt #89 on the input: addr=2 len=1 parity=bad gap=2 |
| 43265 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 43265 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 43270 | yapp driver | TX pkt #89 accepted by the DUT |
| 43270 | **test** | STAGE: burst 8/8 sent: addr0..3 2/2/6/1, bad parity 1, gap 0 2, length 1..63 |
| 43270 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 43290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 43290 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 43300 | hbus driver | Executed READ  addr=0x1000 data=0x80 |
| 43305 | hbus monitor | Collected READ  addr=0x1000 data=0x80 |
| 43330 | hbus driver | Executed READ  addr=0x1001 data=0x01 |
| 43335 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43360 | hbus driver | Executed READ  addr=0x1004 data=0x0b |
| 43365 | hbus monitor | Collected READ  addr=0x1004 data=0x0b |
| 43390 | hbus driver | Executed READ  addr=0x1005 data=0x16 |
| 43395 | hbus monitor | Collected READ  addr=0x1005 data=0x16 |
| 43420 | hbus driver | Executed READ  addr=0x1006 data=0x07 |
| 43425 | hbus monitor | Collected READ  addr=0x1006 data=0x07 |
| 43450 | hbus driver | Executed READ  addr=0x1009 data=0x0a |
| 43455 | hbus monitor | Collected READ  addr=0x1009 data=0x0a |
| 43480 | hbus driver | Executed READ  addr=0x100a data=0x02 |
| 43485 | hbus monitor | Collected READ  addr=0x100a data=0x02 |
| 43510 | hbus driver | Executed READ  addr=0x100b data=0x16 |
| 43515 | hbus monitor | Collected READ  addr=0x100b data=0x16 |
| 43540 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 43545 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 43570 | hbus driver | Executed READ  addr=0x1010 data=0x06 |
| 43575 | hbus monitor | Collected READ  addr=0x1010 data=0x06 |
| 43600 | hbus driver | Executed READ  addr=0x1011 data=0x06 |
| 43605 | hbus monitor | Collected READ  addr=0x1011 data=0x06 |
| 43715 | **test** | STAGE: done: 89 packets (28 forwarded, 61 dropped), 0 storm burst(s), 28 scoreboard matches, 72 HBUS reads checked, 17 error pulses for 17 bad packets |
| 43915 | error checker | error pulse report: 17 bad packets, 17 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 43915 | ch0 monitor | Channel 0 report: 9 packets collected |
| 43915 | ch1 monitor | Channel 1 report: 6 packets collected |
| 43915 | ch2 monitor | Channel 2 report: 13 packets collected |
| 43915 | hbus monitor | HBUS report: 45 writes, 72 reads |
| 43915 | coverage | Coverage of the router configuration: 100.0% |
| 43915 | coverage | HBUS address coverage: 117 accesses sampled, coverage 50.6% |
| 43915 | coverage | HBUS register bits coverage: 16 writes to ctrl_reg/en_reg, coverage 97.7% |
| 43915 | coverage | HBUS counter value coverage: 14 counter reads sampled, coverage 63.0% |
| 43915 | coverage | HBUS yapp_mem data coverage: 58 accesses sampled, coverage 47.1% |
| 43915 | reference |  |
| 43915 | reference | HBUS reads checked against the model: 72 (0 mismatches, 0 of memory bytes never written) |
| 43915 | scoreboard |  |
| 43915 | yapp driver | YAPP driver report: 89 packets sent |
| 43915 | coverage | YAPP gap coverage: 88 gaps sampled, coverage 100.0% |
| 43915 | yapp monitor | YAPP monitor report: 89 packets collected, 17 with bad parity |
| 43915 | yapp monitor | YAPP gaps: 21 back to back, 7 of 1 cycle, 8 of 2, 52 longer |
| 43915 | coverage | YAPP packet coverage: 89 packets sampled, coverage 83.3% |
