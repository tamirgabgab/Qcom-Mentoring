# random_test  seed 6

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 15us · log `random_test_s6.log`

Waves: `random_test_s6.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s6%2Frandom_test_s6.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **24** packet(s) (4 with bad parity); the input monitor saw 24.
- Router: **8** forwarded, **16** dropped (9 router disabled, 7 oversized).
- Packets out: ch0 **0**, ch1 **2**, ch2 **6**.
- Scoreboard: 8 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **4** time(s), longest hold 125 cycle(s).
- Error pulses: 4.
- HBUS: 10 write(s), 81 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_FAST, ch1 RX_NORMAL, ch2 RX_STALLY |
| 0 | random scenario: 24 packets in 3 bursts |
| 310 | burst 1/3: ctrl=0x05 (maxpktsize 5) en=0xfe (router OFF, counter enables 1111111), 9 packet(s) |
| 3750 | burst 1/3 sent: addr0..3 2/3/4/0, bad parity 0, gap 0 4, length 3..63 |
| 3880 | burst 2/3: ctrl=0x3c (maxpktsize 60) en=0x01 (router on, counter enables 0000000), 7 packet(s) |
| 8820 | burst 2/3 sent: addr0..3 0/2/5/0, bad parity 2, gap 0 2, length 1..63 |
| 8990 | burst 3/3: ctrl=0x14 (maxpktsize 20) en=0x1d (router on, counter enables 0001110), 8 packet(s) |
| 12280 | burst 3/3 sent: addr0..3 2/2/4/0, bad parity 2, gap 0 4, length 7..59 |
| 12280 | final reads: every register and the stored packet, checked against the reference model |
| 14465 | done: 24 packets (8 forwarded, 16 dropped), 0 storm burst(s), 8 scoreboard matches, 80 HBUS reads checked, 4 error pulses for 4 bad packets |

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

441 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_FAST, ch1 RX_NORMAL, ch2 RX_STALLY |
| 0 | **test** | STAGE: random scenario: 24 packets in 3 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x05 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=5 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x05 |
| 75 | reference | maxpktsize is now 5 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 95 | **DUT** | CONFIG router_en=0 maxpktsize=5 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 95 | reference | router_en is now 0 (en_reg 0xfe) |
| 120 | hbus driver | Executed READ  addr=0x10a4 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x10a4 data=0x00 |
| 140 | hbus driver | Executed WRITE addr=0x1189 data=0xc3 |
| 145 | hbus monitor | Collected WRITE addr=0x1189 data=0xc3 |
| 170 | hbus driver | Executed READ  addr=0x1189 data=0xc3 |
| 175 | hbus monitor | Collected READ  addr=0x1189 data=0xc3 |
| 190 | hbus driver | Executed WRITE addr=0x11e2 data=0x6b |
| 195 | hbus monitor | Collected WRITE addr=0x11e2 data=0x6b |
| 220 | hbus driver | Executed READ  addr=0x11e2 data=0x6b |
| 225 | hbus monitor | Collected READ  addr=0x11e2 data=0x6b |
| 250 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 255 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 280 | hbus driver | Executed READ  addr=0x103b data=0x00 |
| 285 | hbus monitor | Collected READ  addr=0x103b data=0x00 |
| 310 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 310 | **test** | STAGE: burst 1/3: ctrl=0x05 (maxpktsize 5) en=0xfe (router OFF, counter enables 1111111), 9 packet(s) |
| 310 | yapp driver | TX pkt #1: addr=1 len=41 parity=good delay=0 |
| 315 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 325 | **DUT** | IN  pkt #1 header: addr=1 len=41 -> DROP (router disabled) |
| 745 | **DUT** | IN  pkt #1 complete: addr=1 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 745 | yapp monitor | RX pkt #1 on the input: addr=1 len=41 parity=good gap=27 |
| 745 | reference | Packet dropped: router disabled (addr=1 len=41) |
| 745 | **DUT** | ROUTER DROPS PACKET addr=1 length=41 (router disabled) |
| 750 | yapp driver | TX pkt #1 accepted by the DUT |
| 750 | yapp driver | TX pkt #2: addr=2 len=9 parity=good delay=0 |
| 755 | **DUT** | IN  pkt #2 header: addr=2 len=9 -> DROP (router disabled) |
| 855 | **DUT** | IN  pkt #2 complete: addr=2 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 855 | yapp monitor | RX pkt #2 on the input: addr=2 len=9 parity=good gap=0 |
| 855 | reference | Packet dropped: router disabled (addr=2 len=9) |
| 855 | **DUT** | ROUTER DROPS PACKET addr=2 length=9 (router disabled) |
| 860 | yapp driver | TX pkt #2 accepted by the DUT |
| 860 | yapp driver | TX pkt #3: addr=1 len=63 parity=good delay=0 |
| 865 | **DUT** | IN  pkt #3 header: addr=1 len=63 -> DROP (router disabled) |
| 1505 | **DUT** | IN  pkt #3 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1505 | yapp monitor | RX pkt #3 on the input: addr=1 len=63 parity=good gap=0 |
| 1505 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 1505 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 1510 | yapp driver | TX pkt #3 accepted by the DUT |
| 1510 | yapp driver | TX pkt #4: addr=2 len=10 parity=good delay=3 |
| 1545 | **DUT** | IN  pkt #4 header: addr=2 len=10 -> DROP (router disabled) |
| 1655 | **DUT** | IN  pkt #4 complete: addr=2 len=10 parity=ok dropped, 12 bytes in 12 cycles (held 0) |
| 1655 | yapp monitor | RX pkt #4 on the input: addr=2 len=10 parity=good gap=3 |
| 1655 | reference | Packet dropped: router disabled (addr=2 len=10) |
| 1655 | **DUT** | ROUTER DROPS PACKET addr=2 length=10 (router disabled) |
| 1660 | yapp driver | TX pkt #4 accepted by the DUT |
| 1660 | yapp driver | TX pkt #5: addr=2 len=17 parity=good delay=0 |
| 1665 | **DUT** | IN  pkt #5 header: addr=2 len=17 -> DROP (router disabled) |
| 1845 | **DUT** | IN  pkt #5 complete: addr=2 len=17 parity=ok dropped, 19 bytes in 19 cycles (held 0) |
| 1845 | yapp monitor | RX pkt #5 on the input: addr=2 len=17 parity=good gap=0 |
| 1845 | reference | Packet dropped: router disabled (addr=2 len=17) |
| 1845 | **DUT** | ROUTER DROPS PACKET addr=2 length=17 (router disabled) |
| 1850 | yapp driver | TX pkt #5 accepted by the DUT |
| 1850 | yapp driver | TX pkt #6: addr=2 len=61 parity=good delay=16 |
| 2015 | **DUT** | IN  pkt #6 header: addr=2 len=61 -> DROP (router disabled) |
| 2635 | **DUT** | IN  pkt #6 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 2635 | yapp monitor | RX pkt #6 on the input: addr=2 len=61 parity=good gap=16 |
| 2635 | reference | Packet dropped: router disabled (addr=2 len=61) |
| 2635 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (router disabled) |
| 2640 | yapp driver | TX pkt #6 accepted by the DUT |
| 2640 | yapp driver | TX pkt #7: addr=1 len=5 parity=good delay=20 |
| 2845 | **DUT** | IN  pkt #7 header: addr=1 len=5 -> DROP (router disabled) |
| 2905 | **DUT** | IN  pkt #7 complete: addr=1 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 2905 | yapp monitor | RX pkt #7 on the input: addr=1 len=5 parity=good gap=20 |
| 2905 | reference | Packet dropped: router disabled (addr=1 len=5) |
| 2905 | **DUT** | ROUTER DROPS PACKET addr=1 length=5 (router disabled) |
| 2910 | yapp driver | TX pkt #7 accepted by the DUT |
| 2910 | yapp driver | TX pkt #8: addr=0 len=3 parity=good delay=13 |
| 3045 | **DUT** | IN  pkt #8 header: addr=0 len=3 -> DROP (router disabled) |
| 3085 | **DUT** | IN  pkt #8 complete: addr=0 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 3085 | yapp monitor | RX pkt #8 on the input: addr=0 len=3 parity=good gap=13 |
| 3085 | reference | Packet dropped: router disabled (addr=0 len=3) |
| 3085 | **DUT** | ROUTER DROPS PACKET addr=0 length=3 (router disabled) |
| 3090 | yapp driver | TX pkt #8 accepted by the DUT |
| 3090 | yapp driver | TX pkt #9: addr=0 len=53 parity=good delay=11 |
| 3205 | **DUT** | IN  pkt #9 header: addr=0 len=53 -> DROP (router disabled) |
| 3745 | **DUT** | IN  pkt #9 complete: addr=0 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 3745 | yapp monitor | RX pkt #9 on the input: addr=0 len=53 parity=good gap=11 |
| 3745 | reference | Packet dropped: router disabled (addr=0 len=53) |
| 3745 | **DUT** | ROUTER DROPS PACKET addr=0 length=53 (router disabled) |
| 3750 | yapp driver | TX pkt #9 accepted by the DUT |
| 3750 | **test** | STAGE: burst 1/3 sent: addr0..3 2/3/4/0, bad parity 0, gap 0 4, length 3..63 |
| 3770 | hbus driver | Executed WRITE addr=0x1000 data=0x3c |
| 3775 | **DUT** | CONFIG router_en=0 maxpktsize=60 |
| 3775 | hbus monitor | Collected WRITE addr=0x1000 data=0x3c |
| 3775 | reference | maxpktsize is now 60 |
| 3790 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 3795 | **DUT** | CONFIG router_en=1 maxpktsize=60 |
| 3795 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 3795 | reference | router_en is now 1 (en_reg 0x01) |
| 3820 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 3825 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3850 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 3855 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3880 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 3880 | **test** | STAGE: burst 2/3: ctrl=0x3c (maxpktsize 60) en=0x01 (router on, counter enables 0000000), 7 packet(s) |
| 3880 | yapp driver | TX pkt #10: addr=2 len=19 parity=good delay=2 |
| 3885 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3915 | **DUT** | IN  pkt #10 header: addr=2 len=19 -> channel 2 |
| 4075 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x43 held (pkt #10) |
| 4605 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=19 (receiver waited 68 cycle(s)) |
| 4615 | **DUT** | SUSPEND released after 54 cycle(s) |
| 4655 | **DUT** | IN  pkt #10 complete: addr=2 len=19 parity=ok forwarded, 21 bytes in 75 cycles (held 54) |
| 4655 | yapp monitor | RX pkt #10 on the input: addr=2 len=19 parity=good gap=16 |
| 4655 | reference | Packet forwarded: addr=2 len=19 -> channel 2 |
| 4660 | yapp driver | TX pkt #10 accepted by the DUT |
| 4660 | yapp driver | TX pkt #11: addr=1 len=1 parity=bad delay=11 |
| 4775 | **DUT** | IN  pkt #11 header: addr=1 len=1 -> channel 1 |
| 4795 | **DUT** | IN  pkt #11 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 4795 | yapp monitor | RX pkt #11 on the input: addr=1 len=1 parity=bad gap=11 |
| 4795 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 4800 | ch2 driver | ch2: packet consumed (response delay 68) |
| 4800 | yapp driver | TX pkt #11 accepted by the DUT |
| 4800 | yapp driver | TX pkt #12: addr=2 len=58 parity=good delay=0 |
| 4805 | **DUT** | IN  pkt #12 header: addr=2 len=58 -> channel 2 |
| 4810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 4810 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 4865 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=1 (receiver waited 8 cycle(s)) |
| 4880 | ch1 driver | ch1: packet consumed (response delay 8) |
| 4955 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xec held (pkt #12) |
| 4995 | **DUT** | OUT ch1 pkt #1 done: 3 bytes in 14 cycles |
| 4995 | ch1 monitor | ch1 RX pkt #1: addr=1 len=1 parity=bad |
| 4995 | scoreboard | ch1 pkt matched: addr=1 len=1 (1 matched so far) |
| 5360 | ch1 driver | ch1: packet consumed (response delay 10) |
| 6195 | **DUT** | OUT ch2 pkt #1 done: 21 bytes in 160 cycles |
| 6195 | ch2 monitor | ch2 RX pkt #1: addr=2 len=19 parity=good |
| 6195 | scoreboard | ch2 pkt matched: addr=2 len=19 (2 matched so far) |
| 6205 | **DUT** | SUSPEND released after 125 cycle(s) |
| 6205 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=58 (receiver waited 0 cycle(s)) |
| 6450 | ch2 driver | ch2: packet consumed (response delay 138) |
| 6465 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x80 held (pkt #12) |
| 6535 | **DUT** | SUSPEND released after 7 cycle(s) |
| 6715 | **DUT** | IN  pkt #12 complete: addr=2 len=58 parity=ok forwarded, 60 bytes in 192 cycles (held 132) |
| 6715 | yapp monitor | RX pkt #12 on the input: addr=2 len=58 parity=good gap=0 |
| 6715 | reference | Packet forwarded: addr=2 len=58 -> channel 2 |
| 6720 | yapp driver | TX pkt #12 accepted by the DUT |
| 6720 | yapp driver | TX pkt #13: addr=2 len=46 parity=bad delay=1 |
| 6735 | **DUT** | IN  pkt #13 header: addr=2 len=46 -> channel 2 |
| 6865 | **DUT** | OUT ch2 pkt #2 done: 60 bytes in 67 cycles |
| 6865 | ch2 monitor | ch2 RX pkt #2: addr=2 len=58 parity=good |
| 6865 | scoreboard | ch2 pkt matched: addr=2 len=58 (3 matched so far) |
| 6875 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=46 (receiver waited 0 cycle(s)) |
| 7030 | ch2 driver | ch2: packet consumed (response delay 6) |
| 7055 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xdf held (pkt #13) |
| 7145 | **DUT** | SUSPEND released after 9 cycle(s) |
| 7295 | **DUT** | IN  pkt #13 complete: addr=2 len=46 parity=BAD forwarded, 48 bytes in 57 cycles (held 9) |
| 7295 | yapp monitor | RX pkt #13 on the input: addr=2 len=46 parity=bad gap=1 |
| 7295 | reference | Packet forwarded: addr=2 len=46 -> channel 2 |
| 7300 | yapp driver | TX pkt #13 accepted by the DUT |
| 7300 | yapp driver | TX pkt #14: addr=1 len=23 parity=good delay=18 |
| 7350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 7350 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 7445 | **DUT** | OUT ch2 pkt #3 done: 48 bytes in 58 cycles |
| 7445 | ch2 monitor | ch2 RX pkt #3: addr=2 len=46 parity=bad |
| 7445 | scoreboard | ch2 pkt matched: addr=2 len=46 (4 matched so far) |
| 7450 | ch2 driver | ch2: packet consumed (response delay 9) |
| 7485 | **DUT** | IN  pkt #14 header: addr=1 len=23 -> channel 1 |
| 7595 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=23 (receiver waited 10 cycle(s)) |
| 7725 | **DUT** | IN  pkt #14 complete: addr=1 len=23 parity=ok forwarded, 25 bytes in 25 cycles (held 0) |
| 7725 | yapp monitor | RX pkt #14 on the input: addr=1 len=23 parity=good gap=18 |
| 7725 | reference | Packet forwarded: addr=1 len=23 -> channel 1 |
| 7730 | yapp driver | TX pkt #14 accepted by the DUT |
| 7730 | yapp driver | TX pkt #15: addr=2 len=38 parity=good delay=0 |
| 7735 | **DUT** | IN  pkt #15 header: addr=2 len=38 -> channel 2 |
| 7785 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=38 (receiver waited 4 cycle(s)) |
| 7830 | ch1 driver | ch1: packet consumed (response delay 10) |
| 7905 | **DUT** | OUT ch1 pkt #2 done: 25 bytes in 32 cycles |
| 7905 | ch1 monitor | ch1 RX pkt #2: addr=1 len=23 parity=good |
| 7905 | scoreboard | ch1 pkt matched: addr=1 len=23 (5 matched so far) |
| 8125 | **DUT** | IN  pkt #15 complete: addr=2 len=38 parity=ok forwarded, 40 bytes in 40 cycles (held 0) |
| 8125 | yapp monitor | RX pkt #15 on the input: addr=2 len=38 parity=good gap=0 |
| 8125 | reference | Packet forwarded: addr=2 len=38 -> channel 2 |
| 8130 | yapp driver | TX pkt #15 accepted by the DUT |
| 8130 | yapp driver | TX pkt #16: addr=2 len=63 parity=good delay=4 |
| 8170 | ch2 driver | ch2: packet consumed (response delay 4) |
| 8175 | **DUT** | IN  pkt #16 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 60) |
| 8265 | **DUT** | OUT ch2 pkt #4 done: 40 bytes in 49 cycles |
| 8265 | ch2 monitor | ch2 RX pkt #4: addr=2 len=38 parity=good |
| 8265 | scoreboard | ch2 pkt matched: addr=2 len=38 (6 matched so far) |
| 8340 | ch2 driver | ch2: packet consumed (response delay 8) |
| 8410 | ch1 driver | ch1: packet consumed (response delay 6) |
| 8815 | **DUT** | IN  pkt #16 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8815 | yapp monitor | RX pkt #16 on the input: addr=2 len=63 parity=good gap=4 |
| 8815 | reference | Packet dropped: length 63 > maxpktsize 60 (addr=2) |
| 8815 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 8820 | yapp driver | TX pkt #16 accepted by the DUT |
| 8820 | **test** | STAGE: burst 2/3 sent: addr0..3 0/2/5/0, bad parity 2, gap 0 2, length 1..63 |
| 8840 | hbus driver | Executed WRITE addr=0x1000 data=0x14 |
| 8845 | **DUT** | CONFIG router_en=1 maxpktsize=20 |
| 8845 | hbus monitor | Collected WRITE addr=0x1000 data=0x14 |
| 8845 | reference | maxpktsize is now 20 |
| 8860 | hbus driver | Executed WRITE addr=0x1001 data=0x1d |
| 8865 | hbus monitor | Collected WRITE addr=0x1001 data=0x1d |
| 8865 | reference | router_en is now 1 (en_reg 0x1d) |
| 8880 | hbus driver | Executed WRITE addr=0x1142 data=0x29 |
| 8885 | hbus monitor | Collected WRITE addr=0x1142 data=0x29 |
| 8910 | hbus driver | Executed READ  addr=0x1142 data=0x29 |
| 8915 | hbus monitor | Collected READ  addr=0x1142 data=0x29 |
| 8940 | hbus driver | Executed READ  addr=0x1049 data=0x85 |
| 8945 | hbus monitor | Collected READ  addr=0x1049 data=0x85 |
| 8960 | hbus driver | Executed WRITE addr=0x1127 data=0x98 |
| 8965 | hbus monitor | Collected WRITE addr=0x1127 data=0x98 |
| 8990 | hbus driver | Executed READ  addr=0x1127 data=0x98 |
| 8990 | **test** | STAGE: burst 3/3: ctrl=0x14 (maxpktsize 20) en=0x1d (router on, counter enables 0001110), 8 packet(s) |
| 8990 | yapp driver | TX pkt #17: addr=1 len=51 parity=bad delay=0 |
| 8995 | hbus monitor | Collected READ  addr=0x1127 data=0x98 |
| 9005 | **DUT** | IN  pkt #17 header: addr=1 len=51 -> DROP (oversized: len 51 > maxpktsize 20) |
| 9525 | **DUT** | IN  pkt #17 complete: addr=1 len=51 parity=BAD dropped, 53 bytes in 53 cycles (held 0) |
| 9525 | yapp monitor | RX pkt #17 on the input: addr=1 len=51 parity=bad gap=18 |
| 9525 | reference | Packet dropped: length 51 > maxpktsize 20 (addr=1) |
| 9525 | **DUT** | ROUTER DROPS PACKET addr=1 length=51 (length > maxpktsize) |
| 9530 | yapp driver | TX pkt #17 accepted by the DUT |
| 9530 | yapp driver | TX pkt #18: addr=2 len=9 parity=good delay=1 |
| 9545 | **DUT** | IN  pkt #18 header: addr=2 len=9 -> channel 2 |
| 9570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 9570 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 9615 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=9 (receiver waited 6 cycle(s)) |
| 9645 | **DUT** | IN  pkt #18 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 9645 | yapp monitor | RX pkt #18 on the input: addr=2 len=9 parity=good gap=1 |
| 9645 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 9650 | yapp driver | TX pkt #18 accepted by the DUT |
| 9650 | yapp driver | TX pkt #19: addr=2 len=27 parity=good delay=4 |
| 9695 | **DUT** | IN  pkt #19 header: addr=2 len=27 -> DROP (oversized: len 27 > maxpktsize 20) |
| 9710 | ch2 driver | ch2: packet consumed (response delay 6) |
| 9775 | **DUT** | OUT ch2 pkt #5 done: 11 bytes in 17 cycles |
| 9775 | ch2 monitor | ch2 RX pkt #5: addr=2 len=9 parity=good |
| 9775 | scoreboard | ch2 pkt matched: addr=2 len=9 (7 matched so far) |
| 9975 | **DUT** | IN  pkt #19 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 9975 | yapp monitor | RX pkt #19 on the input: addr=2 len=27 parity=good gap=4 |
| 9975 | reference | Packet dropped: length 27 > maxpktsize 20 (addr=2) |
| 9975 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (length > maxpktsize) |
| 9980 | yapp driver | TX pkt #19 accepted by the DUT |
| 9980 | yapp driver | TX pkt #20: addr=2 len=55 parity=bad delay=0 |
| 9985 | **DUT** | IN  pkt #20 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 20) |
| 10290 | ch2 driver | ch2: packet consumed (response delay 5) |
| 10545 | **DUT** | IN  pkt #20 complete: addr=2 len=55 parity=BAD dropped, 57 bytes in 57 cycles (held 0) |
| 10545 | yapp monitor | RX pkt #20 on the input: addr=2 len=55 parity=bad gap=0 |
| 10545 | reference | Packet dropped: length 55 > maxpktsize 20 (addr=2) |
| 10545 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 10550 | yapp driver | TX pkt #20 accepted by the DUT |
| 10550 | yapp driver | TX pkt #21: addr=1 len=53 parity=good delay=0 |
| 10555 | **DUT** | IN  pkt #21 header: addr=1 len=53 -> DROP (oversized: len 53 > maxpktsize 20) |
| 10650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 10650 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 11095 | **DUT** | IN  pkt #21 complete: addr=1 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 11095 | yapp monitor | RX pkt #21 on the input: addr=1 len=53 parity=good gap=0 |
| 11095 | reference | Packet dropped: length 53 > maxpktsize 20 (addr=1) |
| 11095 | **DUT** | ROUTER DROPS PACKET addr=1 length=53 (length > maxpktsize) |
| 11100 | yapp driver | TX pkt #21 accepted by the DUT |
| 11100 | yapp driver | TX pkt #22: addr=0 len=22 parity=good delay=5 |
| 11155 | **DUT** | IN  pkt #22 header: addr=0 len=22 -> DROP (oversized: len 22 > maxpktsize 20) |
| 11385 | **DUT** | IN  pkt #22 complete: addr=0 len=22 parity=ok dropped, 24 bytes in 24 cycles (held 0) |
| 11385 | yapp monitor | RX pkt #22 on the input: addr=0 len=22 parity=good gap=5 |
| 11385 | reference | Packet dropped: length 22 > maxpktsize 20 (addr=0) |
| 11385 | **DUT** | ROUTER DROPS PACKET addr=0 length=22 (length > maxpktsize) |
| 11390 | yapp driver | TX pkt #22 accepted by the DUT |
| 11390 | yapp driver | TX pkt #23: addr=2 len=7 parity=good delay=0 |
| 11395 | **DUT** | IN  pkt #23 header: addr=2 len=7 -> channel 2 |
| 11475 | **DUT** | IN  pkt #23 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 11475 | yapp monitor | RX pkt #23 on the input: addr=2 len=7 parity=good gap=0 |
| 11475 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 11480 | yapp driver | TX pkt #23 accepted by the DUT |
| 11480 | yapp driver | TX pkt #24: addr=0 len=59 parity=good delay=19 |
| 11495 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=7 (receiver waited 9 cycle(s)) |
| 11570 | ch2 driver | ch2: packet consumed (response delay 9) |
| 11675 | **DUT** | IN  pkt #24 header: addr=0 len=59 -> DROP (oversized: len 59 > maxpktsize 20) |
| 11685 | **DUT** | OUT ch2 pkt #6 done: 9 bytes in 20 cycles |
| 11685 | ch2 monitor | ch2 RX pkt #6: addr=2 len=7 parity=good |
| 11685 | scoreboard | ch2 pkt matched: addr=2 len=7 (8 matched so far) |
| 11980 | ch2 driver | ch2: packet consumed (response delay 10) |
| 12275 | **DUT** | IN  pkt #24 complete: addr=0 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 12275 | yapp monitor | RX pkt #24 on the input: addr=0 len=59 parity=good gap=19 |
| 12275 | reference | Packet dropped: length 59 > maxpktsize 20 (addr=0) |
| 12275 | **DUT** | ROUTER DROPS PACKET addr=0 length=59 (length > maxpktsize) |
| 12280 | yapp driver | TX pkt #24 accepted by the DUT |
| 12280 | **test** | STAGE: burst 3/3 sent: addr0..3 2/2/4/0, bad parity 2, gap 0 4, length 7..59 |
| 12280 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 12310 | hbus driver | Executed READ  addr=0x1000 data=0x14 |
| 12315 | hbus monitor | Collected READ  addr=0x1000 data=0x14 |
| 12340 | hbus driver | Executed READ  addr=0x1001 data=0x1d |
| 12345 | hbus monitor | Collected READ  addr=0x1001 data=0x1d |
| 12370 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 12375 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12400 | hbus driver | Executed READ  addr=0x1005 data=0x06 |
| 12405 | hbus monitor | Collected READ  addr=0x1005 data=0x06 |
| 12430 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 12435 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12460 | hbus driver | Executed READ  addr=0x1009 data=0x02 |
| 12465 | hbus monitor | Collected READ  addr=0x1009 data=0x02 |
| 12490 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 12495 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12520 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 12525 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12550 | hbus driver | Executed READ  addr=0x100d data=0x3b |
| 12555 | hbus monitor | Collected READ  addr=0x100d data=0x3b |
| 12580 | hbus driver | Executed READ  addr=0x1010 data=0xec |
| 12585 | hbus monitor | Collected READ  addr=0x1010 data=0xec |
| 12610 | hbus driver | Executed READ  addr=0x1011 data=0x69 |
| 12615 | hbus monitor | Collected READ  addr=0x1011 data=0x69 |
| 12640 | hbus driver | Executed READ  addr=0x1012 data=0xb8 |
| 12645 | hbus monitor | Collected READ  addr=0x1012 data=0xb8 |
| 12670 | hbus driver | Executed READ  addr=0x1013 data=0xd9 |
| 12675 | hbus monitor | Collected READ  addr=0x1013 data=0xd9 |
| 12700 | hbus driver | Executed READ  addr=0x1014 data=0x64 |
| 12705 | hbus monitor | Collected READ  addr=0x1014 data=0x64 |
| 12730 | hbus driver | Executed READ  addr=0x1015 data=0xa1 |
| 12735 | hbus monitor | Collected READ  addr=0x1015 data=0xa1 |
| 12760 | hbus driver | Executed READ  addr=0x1016 data=0xa5 |
| 12765 | hbus monitor | Collected READ  addr=0x1016 data=0xa5 |
| 12790 | hbus driver | Executed READ  addr=0x1017 data=0xa7 |
| 12795 | hbus monitor | Collected READ  addr=0x1017 data=0xa7 |
| 12820 | hbus driver | Executed READ  addr=0x1018 data=0x60 |
| 12825 | hbus monitor | Collected READ  addr=0x1018 data=0x60 |
| 12850 | hbus driver | Executed READ  addr=0x1019 data=0xb6 |
| 12855 | hbus monitor | Collected READ  addr=0x1019 data=0xb6 |
| 12880 | hbus driver | Executed READ  addr=0x101a data=0xda |
| 12885 | hbus monitor | Collected READ  addr=0x101a data=0xda |
| 12910 | hbus driver | Executed READ  addr=0x101b data=0xfc |
| 12915 | hbus monitor | Collected READ  addr=0x101b data=0xfc |
| 12940 | hbus driver | Executed READ  addr=0x101c data=0xaa |
| 12945 | hbus monitor | Collected READ  addr=0x101c data=0xaa |
| 12970 | hbus driver | Executed READ  addr=0x101d data=0x3a |
| 12975 | hbus monitor | Collected READ  addr=0x101d data=0x3a |
| 13000 | hbus driver | Executed READ  addr=0x101e data=0x34 |
| 13005 | hbus monitor | Collected READ  addr=0x101e data=0x34 |
| 13030 | hbus driver | Executed READ  addr=0x101f data=0x59 |
| 13035 | hbus monitor | Collected READ  addr=0x101f data=0x59 |
| 13060 | hbus driver | Executed READ  addr=0x1020 data=0xe5 |
| 13065 | hbus monitor | Collected READ  addr=0x1020 data=0xe5 |
| 13090 | hbus driver | Executed READ  addr=0x1021 data=0xf0 |
| 13095 | hbus monitor | Collected READ  addr=0x1021 data=0xf0 |
| 13120 | hbus driver | Executed READ  addr=0x1022 data=0x95 |
| 13125 | hbus monitor | Collected READ  addr=0x1022 data=0x95 |
| 13150 | hbus driver | Executed READ  addr=0x1023 data=0xae |
| 13155 | hbus monitor | Collected READ  addr=0x1023 data=0xae |
| 13180 | hbus driver | Executed READ  addr=0x1024 data=0xb0 |
| 13185 | hbus monitor | Collected READ  addr=0x1024 data=0xb0 |
| 13210 | hbus driver | Executed READ  addr=0x1025 data=0xb7 |
| 13215 | hbus monitor | Collected READ  addr=0x1025 data=0xb7 |
| 13240 | hbus driver | Executed READ  addr=0x1026 data=0xde |
| 13245 | hbus monitor | Collected READ  addr=0x1026 data=0xde |
| 13270 | hbus driver | Executed READ  addr=0x1027 data=0x79 |
| 13275 | hbus monitor | Collected READ  addr=0x1027 data=0x79 |
| 13300 | hbus driver | Executed READ  addr=0x1028 data=0xfb |
| 13305 | hbus monitor | Collected READ  addr=0x1028 data=0xfb |
| 13330 | hbus driver | Executed READ  addr=0x1029 data=0x9b |
| 13335 | hbus monitor | Collected READ  addr=0x1029 data=0x9b |
| 13360 | hbus driver | Executed READ  addr=0x102a data=0xd8 |
| 13365 | hbus monitor | Collected READ  addr=0x102a data=0xd8 |
| 13390 | hbus driver | Executed READ  addr=0x102b data=0x2b |
| 13395 | hbus monitor | Collected READ  addr=0x102b data=0x2b |
| 13420 | hbus driver | Executed READ  addr=0x102c data=0x4c |
| 13425 | hbus monitor | Collected READ  addr=0x102c data=0x4c |
| 13450 | hbus driver | Executed READ  addr=0x102d data=0x6f |
| 13455 | hbus monitor | Collected READ  addr=0x102d data=0x6f |
| 13480 | hbus driver | Executed READ  addr=0x102e data=0xac |
| 13485 | hbus monitor | Collected READ  addr=0x102e data=0xac |
| 13510 | hbus driver | Executed READ  addr=0x102f data=0xf8 |
| 13515 | hbus monitor | Collected READ  addr=0x102f data=0xf8 |
| 13540 | hbus driver | Executed READ  addr=0x1030 data=0xed |
| 13545 | hbus monitor | Collected READ  addr=0x1030 data=0xed |
| 13570 | hbus driver | Executed READ  addr=0x1031 data=0xdc |
| 13575 | hbus monitor | Collected READ  addr=0x1031 data=0xdc |
| 13600 | hbus driver | Executed READ  addr=0x1032 data=0xc2 |
| 13605 | hbus monitor | Collected READ  addr=0x1032 data=0xc2 |
| 13630 | hbus driver | Executed READ  addr=0x1033 data=0xa5 |
| 13635 | hbus monitor | Collected READ  addr=0x1033 data=0xa5 |
| 13660 | hbus driver | Executed READ  addr=0x1034 data=0x98 |
| 13665 | hbus monitor | Collected READ  addr=0x1034 data=0x98 |
| 13690 | hbus driver | Executed READ  addr=0x1035 data=0x4d |
| 13695 | hbus monitor | Collected READ  addr=0x1035 data=0x4d |
| 13720 | hbus driver | Executed READ  addr=0x1036 data=0x74 |
| 13725 | hbus monitor | Collected READ  addr=0x1036 data=0x74 |
| 13750 | hbus driver | Executed READ  addr=0x1037 data=0x56 |
| 13755 | hbus monitor | Collected READ  addr=0x1037 data=0x56 |
| 13780 | hbus driver | Executed READ  addr=0x1038 data=0x11 |
| 13785 | hbus monitor | Collected READ  addr=0x1038 data=0x11 |
| 13810 | hbus driver | Executed READ  addr=0x1039 data=0x1f |
| 13815 | hbus monitor | Collected READ  addr=0x1039 data=0x1f |
| 13840 | hbus driver | Executed READ  addr=0x103a data=0x86 |
| 13845 | hbus monitor | Collected READ  addr=0x103a data=0x86 |
| 13870 | hbus driver | Executed READ  addr=0x103b data=0xff |
| 13875 | hbus monitor | Collected READ  addr=0x103b data=0xff |
| 13900 | hbus driver | Executed READ  addr=0x103c data=0x0c |
| 13905 | hbus monitor | Collected READ  addr=0x103c data=0x0c |
| 13930 | hbus driver | Executed READ  addr=0x103d data=0x39 |
| 13935 | hbus monitor | Collected READ  addr=0x103d data=0x39 |
| 13960 | hbus driver | Executed READ  addr=0x103e data=0x55 |
| 13965 | hbus monitor | Collected READ  addr=0x103e data=0x55 |
| 13990 | hbus driver | Executed READ  addr=0x103f data=0x06 |
| 13995 | hbus monitor | Collected READ  addr=0x103f data=0x06 |
| 14020 | hbus driver | Executed READ  addr=0x1040 data=0x28 |
| 14025 | hbus monitor | Collected READ  addr=0x1040 data=0x28 |
| 14050 | hbus driver | Executed READ  addr=0x1041 data=0xa5 |
| 14055 | hbus monitor | Collected READ  addr=0x1041 data=0xa5 |
| 14080 | hbus driver | Executed READ  addr=0x1042 data=0xa9 |
| 14085 | hbus monitor | Collected READ  addr=0x1042 data=0xa9 |
| 14110 | hbus driver | Executed READ  addr=0x1043 data=0x7b |
| 14115 | hbus monitor | Collected READ  addr=0x1043 data=0x7b |
| 14140 | hbus driver | Executed READ  addr=0x1044 data=0x7e |
| 14145 | hbus monitor | Collected READ  addr=0x1044 data=0x7e |
| 14170 | hbus driver | Executed READ  addr=0x1045 data=0x4c |
| 14175 | hbus monitor | Collected READ  addr=0x1045 data=0x4c |
| 14200 | hbus driver | Executed READ  addr=0x1046 data=0x40 |
| 14205 | hbus monitor | Collected READ  addr=0x1046 data=0x40 |
| 14230 | hbus driver | Executed READ  addr=0x1047 data=0x97 |
| 14235 | hbus monitor | Collected READ  addr=0x1047 data=0x97 |
| 14260 | hbus driver | Executed READ  addr=0x1048 data=0x3f |
| 14265 | hbus monitor | Collected READ  addr=0x1048 data=0x3f |
| 14290 | hbus driver | Executed READ  addr=0x1049 data=0xe8 |
| 14295 | hbus monitor | Collected READ  addr=0x1049 data=0xe8 |
| 14320 | hbus driver | Executed READ  addr=0x104a data=0x79 |
| 14325 | hbus monitor | Collected READ  addr=0x104a data=0x79 |
| 14350 | hbus driver | Executed READ  addr=0x104b data=0x00 |
| 14355 | hbus monitor | Collected READ  addr=0x104b data=0x00 |
| 14465 | **test** | STAGE: done: 24 packets (8 forwarded, 16 dropped), 0 storm burst(s), 8 scoreboard matches, 80 HBUS reads checked, 4 error pulses for 4 bad packets |
| 14665 | error checker | error pulse report: 4 bad packets, 4 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 14665 | ch0 monitor | Channel 0 report: 0 packets collected |
| 14665 | ch1 monitor | Channel 1 report: 2 packets collected |
| 14665 | ch2 monitor | Channel 2 report: 6 packets collected |
| 14665 | hbus monitor | HBUS report: 10 writes, 81 reads |
| 14665 | reference |  |
| 14665 | reference | HBUS reads checked against the model: 80 (0 mismatches, 1 of memory bytes never written) |
| 14665 | reference | Coverage of the router configuration: 56.5% |
| 14665 | scoreboard |  |
| 14665 | yapp driver | YAPP driver report: 24 packets sent |
| 14665 | yapp monitor | YAPP monitor report: 24 packets collected, coverage 56.7% |
| 14665 | yapp monitor | YAPP gaps: 8 back to back, 2 of 1 cycle, 0 of 2, 13 longer (gap coverage 75.0%) |
