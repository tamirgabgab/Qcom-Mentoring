# random_parity_test seed 8

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 18us · wall 22.8 s · log [`random_parity_test_s8.log`](random_parity_test_s8.log)

Waves: `random_parity_test_s8.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s8%2Frandom_parity_test_s8.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **95** packet(s) (27 with bad parity); the input monitor saw 95.
- Router: **64** forwarded, **31** dropped (11 illegal address 3, 20 oversized).
- Packets out: ch0 **19**, ch1 **20**, ch2 **25**.
- Scoreboard: 64 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 27.
- HBUS: 28 write(s), 86 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 95 packets in 6 bursts |
| 350 | burst 1/6: ctrl=0xed (maxpktsize 45) en=0xff (router on, counter enables 1111111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 990 | burst 1/6 sent: addr0..3 3/2/9/2, bad parity 3, gap 0 15, length 1..3 |
| 1260 | burst 2/6: ctrl=0xc2 (maxpktsize 2) en=0xff (router on, counter enables 1111111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 1940 | burst 2/6 sent: addr0..3 2/5/8/1, bad parity 4, gap 0 12, length 1..3 |
| 2260 | burst 3/6: ctrl=0x25 (maxpktsize 37) en=0x75 (router on, counter enables 0111010), 15 packet(s) |
| 7400 | burst 3/6 sent: addr0..3 5/3/4/3, bad parity 6, gap 0 3, length 1..63 |
| 7570 | burst 4/6: ctrl=0xbe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 17 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 8360 | burst 4/6 sent: addr0..3 6/1/7/3, bad parity 3, gap 0 14, length 1..3 |
| 8610 | burst 5/6: ctrl=0xf8 (maxpktsize 56) en=0x0f (router on, counter enables 0000111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 9260 | burst 5/6 sent: addr0..3 5/5/4/2, bad parity 6, gap 0 14, length 1..3 |
| 9590 | burst 6/6: ctrl=0xac (maxpktsize 44) en=0xff (router on, counter enables 1111111), 15 packet(s) |
| 16050 | burst 6/6 sent: addr0..3 3/8/3/1, bad parity 5, gap 0 6, length 1..63 |
| 16050 | final reads: every register and the stored packet, checked against the reference model |
| 17665 | done: 95 packets (64 forwarded, 31 dropped), 4 storm burst(s), 64 scoreboard matches, 80 HBUS reads checked, 27 error pulses for 27 bad packets |

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

1256 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 95 packets in 6 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0xed |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=45 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0xed |
| 75 | reference | maxpktsize is now 45 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x1019 data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x1019 data=0x00 |
| 180 | hbus driver | Executed READ  addr=0x101a data=0x00 |
| 185 | hbus monitor | Collected READ  addr=0x101a data=0x00 |
| 200 | hbus driver | Executed WRITE addr=0x111a data=0x86 |
| 205 | hbus monitor | Collected WRITE addr=0x111a data=0x86 |
| 230 | hbus driver | Executed READ  addr=0x111a data=0x86 |
| 235 | hbus monitor | Collected READ  addr=0x111a data=0x86 |
| 260 | hbus driver | Executed READ  addr=0x1000 data=0xed |
| 265 | hbus monitor | Collected READ  addr=0x1000 data=0xed |
| 290 | hbus driver | Executed READ  addr=0x10ea data=0x00 |
| 295 | hbus monitor | Collected READ  addr=0x10ea data=0x00 |
| 320 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 325 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 350 | hbus driver | Executed READ  addr=0x1033 data=0x00 |
| 350 | **test** | STAGE: burst 1/6: ctrl=0xed (maxpktsize 45) en=0xff (router on, counter enables 1111111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 350 | yapp driver | TX pkt #1: addr=2 len=1 parity=bad delay=2 |
| 355 | hbus monitor | Collected READ  addr=0x1033 data=0x00 |
| 385 | **DUT** | IN  pkt #1 header: addr=2 len=1 -> channel 2 |
| 395 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 405 | **DUT** | IN  pkt #1 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 405 | yapp monitor | RX pkt #1 on the input: addr=2 len=1 parity=bad gap=33 |
| 405 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 410 | ch2 driver | ch2: packet consumed (response delay 0) |
| 410 | yapp driver | TX pkt #1 accepted by the DUT |
| 410 | yapp driver | TX pkt #2: addr=1 len=3 parity=good delay=0 |
| 415 | **DUT** | IN  pkt #2 header: addr=1 len=3 -> channel 1 |
| 425 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 425 | **DUT** | OUT ch2 pkt #1 done: 3 bytes in 4 cycles |
| 425 | ch2 monitor | ch2 RX pkt #1: addr=2 len=1 parity=bad |
| 425 | scoreboard | ch2 pkt matched: addr=2 len=1 (1 matched so far) |
| 450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 450 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 455 | **DUT** | IN  pkt #2 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 455 | yapp monitor | RX pkt #2 on the input: addr=1 len=3 parity=good gap=0 |
| 455 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 460 | ch1 driver | ch1: packet consumed (response delay 0) |
| 460 | yapp driver | TX pkt #2 accepted by the DUT |
| 460 | yapp driver | TX pkt #3: addr=3 len=2 parity=good delay=0 |
| 465 | **DUT** | IN  pkt #3 header: addr=3 len=2 -> DROP (illegal address 3) |
| 495 | **DUT** | IN  pkt #3 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 495 | yapp monitor | RX pkt #3 on the input: addr=3 len=2 parity=good gap=0 |
| 495 | reference | Packet dropped: illegal address 3 (len=2) |
| 495 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 500 | yapp driver | TX pkt #3 accepted by the DUT |
| 500 | yapp driver | TX pkt #4: addr=2 len=1 parity=good delay=0 |
| 505 | **DUT** | IN  pkt #4 header: addr=2 len=1 -> channel 2 |
| 505 | **DUT** | OUT ch1 pkt #1 done: 5 bytes in 9 cycles |
| 505 | ch1 monitor | ch1 RX pkt #1: addr=1 len=3 parity=good |
| 505 | scoreboard | ch1 pkt matched: addr=1 len=3 (2 matched so far) |
| 515 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 525 | **DUT** | IN  pkt #4 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 525 | yapp monitor | RX pkt #4 on the input: addr=2 len=1 parity=good gap=0 |
| 525 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 530 | yapp driver | TX pkt #4 accepted by the DUT |
| 530 | yapp driver | TX pkt #5: addr=2 len=3 parity=good delay=0 |
| 535 | **DUT** | IN  pkt #5 header: addr=2 len=3 -> channel 2 |
| 535 | **DUT** | OUT ch2 pkt #2 done: 3 bytes in 3 cycles |
| 535 | ch2 monitor | ch2 RX pkt #2: addr=2 len=1 parity=good |
| 535 | scoreboard | ch2 pkt matched: addr=2 len=1 (3 matched so far) |
| 545 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 575 | **DUT** | IN  pkt #5 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 575 | yapp monitor | RX pkt #5 on the input: addr=2 len=3 parity=good gap=0 |
| 575 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 580 | yapp driver | TX pkt #5 accepted by the DUT |
| 580 | yapp driver | TX pkt #6: addr=2 len=1 parity=good delay=0 |
| 585 | **DUT** | IN  pkt #6 header: addr=2 len=1 -> channel 2 |
| 585 | **DUT** | OUT ch2 pkt #3 done: 5 bytes in 5 cycles |
| 585 | ch2 monitor | ch2 RX pkt #3: addr=2 len=3 parity=good |
| 585 | scoreboard | ch2 pkt matched: addr=2 len=3 (4 matched so far) |
| 595 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 605 | **DUT** | IN  pkt #6 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 605 | yapp monitor | RX pkt #6 on the input: addr=2 len=1 parity=good gap=0 |
| 605 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 610 | ch1 driver | ch1: packet consumed (response delay 3) |
| 610 | yapp driver | TX pkt #6 accepted by the DUT |
| 610 | yapp driver | TX pkt #7: addr=2 len=1 parity=good delay=0 |
| 615 | **DUT** | IN  pkt #7 header: addr=2 len=1 -> channel 2 |
| 615 | **DUT** | OUT ch2 pkt #4 done: 3 bytes in 3 cycles |
| 615 | ch2 monitor | ch2 RX pkt #4: addr=2 len=1 parity=good |
| 615 | scoreboard | ch2 pkt matched: addr=2 len=1 (5 matched so far) |
| 625 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 635 | **DUT** | IN  pkt #7 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 635 | yapp monitor | RX pkt #7 on the input: addr=2 len=1 parity=good gap=0 |
| 635 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 640 | yapp driver | TX pkt #7 accepted by the DUT |
| 640 | yapp driver | TX pkt #8: addr=1 len=2 parity=good delay=0 |
| 645 | **DUT** | IN  pkt #8 header: addr=1 len=2 -> channel 1 |
| 645 | **DUT** | OUT ch2 pkt #5 done: 3 bytes in 3 cycles |
| 645 | ch2 monitor | ch2 RX pkt #5: addr=2 len=1 parity=good |
| 645 | scoreboard | ch2 pkt matched: addr=2 len=1 (6 matched so far) |
| 675 | **DUT** | IN  pkt #8 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 675 | yapp monitor | RX pkt #8 on the input: addr=1 len=2 parity=good gap=0 |
| 675 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 680 | yapp driver | TX pkt #8 accepted by the DUT |
| 680 | yapp driver | TX pkt #9: addr=2 len=1 parity=bad delay=0 |
| 685 | **DUT** | IN  pkt #9 header: addr=2 len=1 -> channel 2 |
| 695 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 700 | ch2 driver | ch2: packet consumed (response delay 0) |
| 705 | **DUT** | IN  pkt #9 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 705 | yapp monitor | RX pkt #9 on the input: addr=2 len=1 parity=bad gap=0 |
| 705 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 710 | yapp driver | TX pkt #9 accepted by the DUT |
| 710 | yapp driver | TX pkt #10: addr=2 len=2 parity=good delay=0 |
| 715 | **DUT** | IN  pkt #10 header: addr=2 len=2 -> channel 2 |
| 725 | **DUT** | OUT ch2 pkt #6 done: 3 bytes in 4 cycles |
| 725 | ch2 monitor | ch2 RX pkt #6: addr=2 len=1 parity=bad |
| 725 | scoreboard | ch2 pkt matched: addr=2 len=1 (7 matched so far) |
| 730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 730 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 735 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 745 | **DUT** | IN  pkt #10 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 745 | yapp monitor | RX pkt #10 on the input: addr=2 len=2 parity=good gap=0 |
| 745 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 750 | yapp driver | TX pkt #10 accepted by the DUT |
| 750 | yapp driver | TX pkt #11: addr=2 len=1 parity=bad delay=0 |
| 755 | **DUT** | IN  pkt #11 header: addr=2 len=1 -> channel 2 |
| 755 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=2 (receiver waited 10 cycle(s)) |
| 765 | **DUT** | OUT ch2 pkt #7 done: 4 bytes in 4 cycles |
| 765 | ch2 monitor | ch2 RX pkt #7: addr=2 len=2 parity=good |
| 765 | scoreboard | ch2 pkt matched: addr=2 len=2 (8 matched so far) |
| 775 | **DUT** | IN  pkt #11 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 775 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 775 | yapp monitor | RX pkt #11 on the input: addr=2 len=1 parity=bad gap=0 |
| 775 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 780 | ch1 driver | ch1: packet consumed (response delay 10) |
| 780 | yapp driver | TX pkt #11 accepted by the DUT |
| 780 | yapp driver | TX pkt #12: addr=2 len=3 parity=good delay=0 |
| 785 | **DUT** | IN  pkt #12 header: addr=2 len=3 -> channel 2 |
| 795 | **DUT** | OUT ch2 pkt #8 done: 3 bytes in 3 cycles |
| 795 | ch2 monitor | ch2 RX pkt #8: addr=2 len=1 parity=bad |
| 795 | scoreboard | ch2 pkt matched: addr=2 len=1 (9 matched so far) |
| 805 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 825 | **DUT** | IN  pkt #12 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 825 | yapp monitor | RX pkt #12 on the input: addr=2 len=3 parity=good gap=0 |
| 825 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 830 | yapp driver | TX pkt #12 accepted by the DUT |
| 830 | yapp driver | TX pkt #13: addr=3 len=1 parity=good delay=0 |
| 835 | **DUT** | IN  pkt #13 header: addr=3 len=1 -> DROP (illegal address 3) |
| 845 | **DUT** | OUT ch2 pkt #9 done: 5 bytes in 5 cycles |
| 845 | ch2 monitor | ch2 RX pkt #9: addr=2 len=3 parity=good |
| 845 | scoreboard | ch2 pkt matched: addr=2 len=3 (10 matched so far) |
| 855 | **DUT** | IN  pkt #13 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 855 | yapp monitor | RX pkt #13 on the input: addr=3 len=1 parity=good gap=0 |
| 855 | reference | Packet dropped: illegal address 3 (len=1) |
| 855 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 860 | yapp driver | TX pkt #13 accepted by the DUT |
| 860 | yapp driver | TX pkt #14: addr=0 len=3 parity=good delay=0 |
| 865 | **DUT** | IN  pkt #14 header: addr=0 len=3 -> channel 0 |
| 870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 870 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 875 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 895 | **DUT** | OUT ch1 pkt #2 done: 4 bytes in 15 cycles |
| 895 | ch1 monitor | ch1 RX pkt #2: addr=1 len=2 parity=good |
| 895 | scoreboard | ch1 pkt matched: addr=1 len=2 (11 matched so far) |
| 905 | **DUT** | IN  pkt #14 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 905 | yapp monitor | RX pkt #14 on the input: addr=0 len=3 parity=good gap=0 |
| 905 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 910 | ch0 driver | ch0: packet consumed (response delay 0) |
| 910 | yapp driver | TX pkt #14 accepted by the DUT |
| 910 | yapp driver | TX pkt #15: addr=0 len=3 parity=good delay=0 |
| 915 | **DUT** | IN  pkt #15 header: addr=0 len=3 -> channel 0 |
| 925 | **DUT** | OUT ch0 pkt #1 done: 5 bytes in 6 cycles |
| 925 | ch0 monitor | ch0 RX pkt #1: addr=0 len=3 parity=good |
| 925 | scoreboard | ch0 pkt matched: addr=0 len=3 (12 matched so far) |
| 935 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 955 | **DUT** | IN  pkt #15 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 955 | yapp monitor | RX pkt #15 on the input: addr=0 len=3 parity=good gap=0 |
| 955 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 960 | yapp driver | TX pkt #15 accepted by the DUT |
| 960 | yapp driver | TX pkt #16: addr=0 len=1 parity=good delay=0 |
| 965 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 975 | **DUT** | OUT ch0 pkt #2 done: 5 bytes in 5 cycles |
| 975 | ch0 monitor | ch0 RX pkt #2: addr=0 len=3 parity=good |
| 975 | scoreboard | ch0 pkt matched: addr=0 len=3 (13 matched so far) |
| 985 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 985 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 985 | yapp monitor | RX pkt #16 on the input: addr=0 len=1 parity=good gap=0 |
| 985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 990 | yapp driver | TX pkt #16 accepted by the DUT |
| 990 | **test** | STAGE: burst 1/6 sent: addr0..3 3/2/9/2, bad parity 3, gap 0 15, length 1..3 |
| 1005 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 1005 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 1005 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 1010 | hbus driver | Executed WRITE addr=0x1000 data=0xc2 |
| 1015 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 1015 | hbus monitor | Collected WRITE addr=0x1000 data=0xc2 |
| 1015 | reference | maxpktsize is now 2 |
| 1030 | ch2 driver | ch2: packet consumed (response delay 0) |
| 1030 | ch1 driver | ch1: packet consumed (response delay 10) |
| 1030 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 1035 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 1035 | reference | router_en is now 1 (en_reg 0xff) |
| 1060 | hbus driver | Executed READ  addr=0x1045 data=0x00 |
| 1065 | hbus monitor | Collected READ  addr=0x1045 data=0x00 |
| 1080 | hbus driver | Executed WRITE addr=0x1152 data=0x6e |
| 1085 | hbus monitor | Collected WRITE addr=0x1152 data=0x6e |
| 1110 | hbus driver | Executed READ  addr=0x1152 data=0x6e |
| 1115 | hbus monitor | Collected READ  addr=0x1152 data=0x6e |
| 1130 | hbus driver | Executed WRITE addr=0x117b data=0xcd |
| 1135 | hbus monitor | Collected WRITE addr=0x117b data=0xcd |
| 1160 | hbus driver | Executed READ  addr=0x117b data=0xcd |
| 1165 | hbus monitor | Collected READ  addr=0x117b data=0xcd |
| 1180 | hbus driver | Executed WRITE addr=0x11f1 data=0xd0 |
| 1185 | hbus monitor | Collected WRITE addr=0x11f1 data=0xd0 |
| 1210 | hbus driver | Executed READ  addr=0x11f1 data=0xd0 |
| 1215 | hbus monitor | Collected READ  addr=0x11f1 data=0xd0 |
| 1230 | hbus driver | Executed WRITE addr=0x1155 data=0x35 |
| 1235 | hbus monitor | Collected WRITE addr=0x1155 data=0x35 |
| 1260 | hbus driver | Executed READ  addr=0x1155 data=0x35 |
| 1260 | **test** | STAGE: burst 2/6: ctrl=0xc2 (maxpktsize 2) en=0xff (router on, counter enables 1111111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 1260 | yapp driver | TX pkt #17: addr=1 len=1 parity=good delay=0 |
| 1265 | hbus monitor | Collected READ  addr=0x1155 data=0x35 |
| 1275 | **DUT** | IN  pkt #17 header: addr=1 len=1 -> channel 1 |
| 1295 | **DUT** | IN  pkt #17 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1295 | yapp monitor | RX pkt #17 on the input: addr=1 len=1 parity=good gap=28 |
| 1295 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 1300 | yapp driver | TX pkt #17 accepted by the DUT |
| 1300 | yapp driver | TX pkt #18: addr=2 len=3 parity=good delay=0 |
| 1305 | **DUT** | IN  pkt #18 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1345 | **DUT** | IN  pkt #18 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1345 | yapp monitor | RX pkt #18 on the input: addr=2 len=3 parity=good gap=0 |
| 1345 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1345 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1350 | yapp driver | TX pkt #18 accepted by the DUT |
| 1350 | yapp driver | TX pkt #19: addr=2 len=3 parity=bad delay=1 |
| 1355 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 7 cycle(s)) |
| 1365 | **DUT** | IN  pkt #19 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1370 | ch1 driver | ch1: packet consumed (response delay 7) |
| 1405 | **DUT** | IN  pkt #19 complete: addr=2 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 1405 | yapp monitor | RX pkt #19 on the input: addr=2 len=3 parity=bad gap=1 |
| 1405 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1405 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1410 | yapp driver | TX pkt #19 accepted by the DUT |
| 1410 | yapp driver | TX pkt #20: addr=2 len=3 parity=good delay=0 |
| 1415 | **DUT** | IN  pkt #20 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1455 | **DUT** | IN  pkt #20 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1455 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 11 cycles |
| 1455 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=good |
| 1455 | scoreboard | ch1 pkt matched: addr=1 len=1 (15 matched so far) |
| 1455 | yapp monitor | RX pkt #20 on the input: addr=2 len=3 parity=good gap=0 |
| 1455 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1455 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1460 | yapp driver | TX pkt #20 accepted by the DUT |
| 1460 | yapp driver | TX pkt #21: addr=2 len=2 parity=good delay=0 |
| 1465 | **DUT** | IN  pkt #21 header: addr=2 len=2 -> channel 2 |
| 1475 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 1490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 1490 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 1495 | **DUT** | IN  pkt #21 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 1495 | yapp monitor | RX pkt #21 on the input: addr=2 len=2 parity=good gap=0 |
| 1495 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 1500 | ch2 driver | ch2: packet consumed (response delay 0) |
| 1500 | yapp driver | TX pkt #21 accepted by the DUT |
| 1500 | yapp driver | TX pkt #22: addr=0 len=1 parity=good delay=0 |
| 1505 | **DUT** | IN  pkt #22 header: addr=0 len=1 -> channel 0 |
| 1515 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1515 | **DUT** | OUT ch2 pkt #10 done: 4 bytes in 5 cycles |
| 1515 | ch2 monitor | ch2 RX pkt #10: addr=2 len=2 parity=good |
| 1515 | scoreboard | ch2 pkt matched: addr=2 len=2 (16 matched so far) |
| 1525 | **DUT** | IN  pkt #22 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1525 | yapp monitor | RX pkt #22 on the input: addr=0 len=1 parity=good gap=0 |
| 1525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1530 | yapp driver | TX pkt #22 accepted by the DUT |
| 1530 | yapp driver | TX pkt #23: addr=2 len=3 parity=bad delay=0 |
| 1535 | **DUT** | IN  pkt #23 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1535 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 3 cycles |
| 1535 | ch0 monitor | ch0 RX pkt #4: addr=0 len=1 parity=good |
| 1535 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 1540 | ch0 driver | ch0: packet consumed (response delay 0) |
| 1575 | **DUT** | IN  pkt #23 complete: addr=2 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 1575 | yapp monitor | RX pkt #23 on the input: addr=2 len=3 parity=bad gap=0 |
| 1575 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1575 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1580 | yapp driver | TX pkt #23 accepted by the DUT |
| 1580 | yapp driver | TX pkt #24: addr=1 len=2 parity=good delay=0 |
| 1585 | **DUT** | IN  pkt #24 header: addr=1 len=2 -> channel 1 |
| 1590 | ch1 driver | ch1: packet consumed (response delay 7) |
| 1615 | **DUT** | IN  pkt #24 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 1615 | yapp monitor | RX pkt #24 on the input: addr=1 len=2 parity=good gap=0 |
| 1615 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 1620 | yapp driver | TX pkt #24 accepted by the DUT |
| 1620 | yapp driver | TX pkt #25: addr=1 len=2 parity=good delay=0 |
| 1625 | **DUT** | IN  pkt #25 header: addr=1 len=2 -> channel 1 |
| 1655 | **DUT** | IN  pkt #25 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 1655 | yapp monitor | RX pkt #25 on the input: addr=1 len=2 parity=good gap=0 |
| 1655 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 1660 | yapp driver | TX pkt #25 accepted by the DUT |
| 1660 | yapp driver | TX pkt #26: addr=1 len=1 parity=bad delay=1 |
| 1670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 1670 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 1675 | **DUT** | IN  pkt #26 header: addr=1 len=1 -> channel 1 |
| 1695 | **DUT** | IN  pkt #26 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 1695 | yapp monitor | RX pkt #26 on the input: addr=1 len=1 parity=bad gap=1 |
| 1695 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 1700 | yapp driver | TX pkt #26 accepted by the DUT |
| 1700 | yapp driver | TX pkt #27: addr=2 len=3 parity=good delay=0 |
| 1705 | **DUT** | IN  pkt #27 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1705 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=2 (receiver waited 11 cycle(s)) |
| 1730 | ch1 driver | ch1: packet consumed (response delay 10) |
| 1745 | **DUT** | IN  pkt #27 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1745 | yapp monitor | RX pkt #27 on the input: addr=2 len=3 parity=good gap=0 |
| 1745 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1745 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 1750 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 1750 | yapp driver | TX pkt #27 accepted by the DUT |
| 1750 | yapp driver | TX pkt #28: addr=0 len=1 parity=good delay=0 |
| 1755 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 1755 | **DUT** | OUT ch1 pkt #4 done: 4 bytes in 6 cycles |
| 1755 | ch1 monitor | ch1 RX pkt #4: addr=1 len=2 parity=good |
| 1755 | scoreboard | ch1 pkt matched: addr=1 len=2 (18 matched so far) |
| 1765 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1765 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 1775 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1775 | yapp monitor | RX pkt #28 on the input: addr=0 len=1 parity=good gap=0 |
| 1775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1780 | ch0 driver | ch0: packet consumed (response delay 0) |
| 1780 | yapp driver | TX pkt #28 accepted by the DUT |
| 1780 | yapp driver | TX pkt #29: addr=3 len=1 parity=bad delay=0 |
| 1785 | **DUT** | IN  pkt #29 header: addr=3 len=1 -> DROP (illegal address 3) |
| 1795 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 4 cycles |
| 1795 | **DUT** | OUT ch1 pkt #5 done: 4 bytes in 4 cycles |
| 1795 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 1795 | scoreboard | ch0 pkt matched: addr=0 len=1 (19 matched so far) |
| 1795 | ch1 monitor | ch1 RX pkt #5: addr=1 len=2 parity=good |
| 1795 | scoreboard | ch1 pkt matched: addr=1 len=2 (20 matched so far) |
| 1805 | **DUT** | IN  pkt #29 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 1805 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 1805 | yapp monitor | RX pkt #29 on the input: addr=3 len=1 parity=bad gap=0 |
| 1805 | reference | Packet dropped: illegal address 3 (len=1) |
| 1805 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 1810 | yapp driver | TX pkt #29 accepted by the DUT |
| 1810 | yapp driver | TX pkt #30: addr=1 len=1 parity=good delay=1 |
| 1825 | **DUT** | IN  pkt #30 header: addr=1 len=1 -> channel 1 |
| 1825 | **DUT** | OUT ch1 pkt #6 done: 3 bytes in 3 cycles |
| 1825 | ch1 monitor | ch1 RX pkt #6: addr=1 len=1 parity=bad |
| 1825 | scoreboard | ch1 pkt matched: addr=1 len=1 (21 matched so far) |
| 1835 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 1845 | **DUT** | IN  pkt #30 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1845 | yapp monitor | RX pkt #30 on the input: addr=1 len=1 parity=good gap=1 |
| 1845 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 1850 | yapp driver | TX pkt #30 accepted by the DUT |
| 1850 | yapp driver | TX pkt #31: addr=2 len=1 parity=good delay=1 |
| 1855 | **DUT** | OUT ch1 pkt #7 done: 3 bytes in 3 cycles |
| 1855 | ch1 monitor | ch1 RX pkt #7: addr=1 len=1 parity=good |
| 1855 | scoreboard | ch1 pkt matched: addr=1 len=1 (22 matched so far) |
| 1865 | **DUT** | IN  pkt #31 header: addr=2 len=1 -> channel 2 |
| 1870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 1870 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 1875 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 1885 | **DUT** | IN  pkt #31 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1885 | yapp monitor | RX pkt #31 on the input: addr=2 len=1 parity=good gap=1 |
| 1885 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 1890 | yapp driver | TX pkt #31 accepted by the DUT |
| 1890 | yapp driver | TX pkt #32: addr=2 len=3 parity=good delay=0 |
| 1895 | **DUT** | IN  pkt #32 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 1895 | **DUT** | OUT ch2 pkt #11 done: 3 bytes in 3 cycles |
| 1895 | ch2 monitor | ch2 RX pkt #11: addr=2 len=1 parity=good |
| 1895 | scoreboard | ch2 pkt matched: addr=2 len=1 (23 matched so far) |
| 1935 | **DUT** | IN  pkt #32 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1935 | yapp monitor | RX pkt #32 on the input: addr=2 len=3 parity=good gap=0 |
| 1935 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 1935 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 1940 | yapp driver | TX pkt #32 accepted by the DUT |
| 1940 | **test** | STAGE: burst 2/6 sent: addr0..3 2/5/8/1, bad parity 4, gap 0 12, length 1..3 |
| 1960 | hbus driver | Executed WRITE addr=0x1000 data=0x25 |
| 1965 | **DUT** | CONFIG router_en=1 maxpktsize=37 |
| 1965 | hbus monitor | Collected WRITE addr=0x1000 data=0x25 |
| 1965 | reference | maxpktsize is now 37 |
| 1980 | hbus driver | Executed WRITE addr=0x1001 data=0x75 |
| 1985 | hbus monitor | Collected WRITE addr=0x1001 data=0x75 |
| 1985 | reference | router_en is now 1 (en_reg 0x75) |
| 2010 | hbus driver | Executed READ  addr=0x100b data=0x11 |
| 2015 | hbus monitor | Collected READ  addr=0x100b data=0x11 |
| 2030 | ch2 driver | ch2: packet consumed (response delay 0) |
| 2040 | hbus driver | Executed READ  addr=0x1027 data=0x00 |
| 2045 | hbus monitor | Collected READ  addr=0x1027 data=0x00 |
| 2060 | hbus driver | Executed WRITE addr=0x1154 data=0x52 |
| 2065 | hbus monitor | Collected WRITE addr=0x1154 data=0x52 |
| 2090 | hbus driver | Executed READ  addr=0x1154 data=0x52 |
| 2095 | hbus monitor | Collected READ  addr=0x1154 data=0x52 |
| 2120 | hbus driver | Executed READ  addr=0x100d data=0x03 |
| 2125 | hbus monitor | Collected READ  addr=0x100d data=0x03 |
| 2140 | hbus driver | Executed WRITE addr=0x1183 data=0x16 |
| 2145 | hbus monitor | Collected WRITE addr=0x1183 data=0x16 |
| 2170 | hbus driver | Executed READ  addr=0x1183 data=0x16 |
| 2175 | hbus monitor | Collected READ  addr=0x1183 data=0x16 |
| 2200 | hbus driver | Executed READ  addr=0x1001 data=0x75 |
| 2205 | hbus monitor | Collected READ  addr=0x1001 data=0x75 |
| 2230 | hbus driver | Executed READ  addr=0x100a data=0x07 |
| 2235 | hbus monitor | Collected READ  addr=0x100a data=0x07 |
| 2260 | hbus driver | Executed READ  addr=0x1037 data=0x00 |
| 2260 | **test** | STAGE: burst 3/6: ctrl=0x25 (maxpktsize 37) en=0x75 (router on, counter enables 0111010), 15 packet(s) |
| 2260 | yapp driver | TX pkt #33: addr=2 len=40 parity=good delay=0 |
| 2265 | hbus monitor | Collected READ  addr=0x1037 data=0x00 |
| 2275 | **DUT** | IN  pkt #33 header: addr=2 len=40 -> DROP (oversized: len 40 > maxpktsize 37) |
| 2330 | ch1 driver | ch1: packet consumed (response delay 1) |
| 2360 | ch0 driver | ch0: packet consumed (response delay 0) |
| 2685 | **DUT** | IN  pkt #33 complete: addr=2 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 2685 | yapp monitor | RX pkt #33 on the input: addr=2 len=40 parity=good gap=33 |
| 2685 | reference | Packet dropped: length 40 > maxpktsize 37 (addr=2) |
| 2685 | **DUT** | ROUTER DROPS PACKET addr=2 length=40 (length > maxpktsize) |
| 2690 | yapp driver | TX pkt #33 accepted by the DUT |
| 2690 | yapp driver | TX pkt #34: addr=2 len=55 parity=good delay=2 |
| 2715 | **DUT** | IN  pkt #34 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 37) |
| 3275 | **DUT** | IN  pkt #34 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 3275 | yapp monitor | RX pkt #34 on the input: addr=2 len=55 parity=good gap=2 |
| 3275 | reference | Packet dropped: length 55 > maxpktsize 37 (addr=2) |
| 3275 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 3280 | yapp driver | TX pkt #34 accepted by the DUT |
| 3280 | yapp driver | TX pkt #35: addr=0 len=63 parity=good delay=0 |
| 3285 | **DUT** | IN  pkt #35 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 37) |
| 3925 | **DUT** | IN  pkt #35 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 3925 | yapp monitor | RX pkt #35 on the input: addr=0 len=63 parity=good gap=0 |
| 3925 | reference | Packet dropped: length 63 > maxpktsize 37 (addr=0) |
| 3925 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 3930 | yapp driver | TX pkt #35 accepted by the DUT |
| 3930 | yapp driver | TX pkt #36: addr=3 len=37 parity=bad delay=6 |
| 3995 | **DUT** | IN  pkt #36 header: addr=3 len=37 -> DROP (illegal address 3) |
| 4375 | **DUT** | IN  pkt #36 complete: addr=3 len=37 parity=BAD dropped, 39 bytes in 39 cycles (held 0) |
| 4375 | yapp monitor | RX pkt #36 on the input: addr=3 len=37 parity=bad gap=6 |
| 4375 | reference | Packet dropped: illegal address 3 (len=37) |
| 4375 | **DUT** | ROUTER DROPS PACKET addr=3 length=37 (    illegal address) |
| 4380 | yapp driver | TX pkt #36 accepted by the DUT |
| 4380 | yapp driver | TX pkt #37: addr=1 len=36 parity=good delay=0 |
| 4385 | **DUT** | IN  pkt #37 header: addr=1 len=36 -> channel 1 |
| 4390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 4390 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 4485 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=36 (receiver waited 9 cycle(s)) |
| 4755 | **DUT** | IN  pkt #37 complete: addr=1 len=36 parity=ok forwarded, 38 bytes in 38 cycles (held 0) |
| 4755 | yapp monitor | RX pkt #37 on the input: addr=1 len=36 parity=good gap=0 |
| 4755 | reference | Packet forwarded: addr=1 len=36 -> channel 1 |
| 4760 | yapp driver | TX pkt #37 accepted by the DUT |
| 4760 | yapp driver | TX pkt #38: addr=1 len=8 parity=bad delay=5 |
| 4815 | **DUT** | IN  pkt #38 header: addr=1 len=8 -> channel 1 |
| 4850 | ch1 driver | ch1: packet consumed (response delay 9) |
| 4905 | **DUT** | IN  pkt #38 complete: addr=1 len=8 parity=BAD forwarded, 10 bytes in 10 cycles (held 0) |
| 4905 | yapp monitor | RX pkt #38 on the input: addr=1 len=8 parity=bad gap=5 |
| 4905 | reference | Packet forwarded: addr=1 len=8 -> channel 1 |
| 4910 | yapp driver | TX pkt #38 accepted by the DUT |
| 4910 | yapp driver | TX pkt #39: addr=0 len=44 parity=bad delay=1 |
| 4925 | **DUT** | IN  pkt #39 header: addr=0 len=44 -> DROP (oversized: len 44 > maxpktsize 37) |
| 4925 | **DUT** | OUT ch1 pkt #8 done: 38 bytes in 45 cycles |
| 4925 | ch1 monitor | ch1 RX pkt #8: addr=1 len=36 parity=good |
| 4925 | scoreboard | ch1 pkt matched: addr=1 len=36 (24 matched so far) |
| 4935 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=8 (receiver waited 0 cycle(s)) |
| 4970 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 4970 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 5025 | **DUT** | OUT ch1 pkt #9 done: 10 bytes in 10 cycles |
| 5025 | ch1 monitor | ch1 RX pkt #9: addr=1 len=8 parity=bad |
| 5025 | scoreboard | ch1 pkt matched: addr=1 len=8 (25 matched so far) |
| 5230 | ch1 driver | ch1: packet consumed (response delay 6) |
| 5375 | **DUT** | IN  pkt #39 complete: addr=0 len=44 parity=BAD dropped, 46 bytes in 46 cycles (held 0) |
| 5375 | yapp monitor | RX pkt #39 on the input: addr=0 len=44 parity=bad gap=1 |
| 5375 | reference | Packet dropped: length 44 > maxpktsize 37 (addr=0) |
| 5375 | **DUT** | ROUTER DROPS PACKET addr=0 length=44 (length > maxpktsize) |
| 5380 | yapp driver | TX pkt #39 accepted by the DUT |
| 5380 | yapp driver | TX pkt #40: addr=2 len=1 parity=good delay=1 |
| 5395 | **DUT** | IN  pkt #40 header: addr=2 len=1 -> channel 2 |
| 5405 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 5415 | **DUT** | IN  pkt #40 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5415 | yapp monitor | RX pkt #40 on the input: addr=2 len=1 parity=good gap=1 |
| 5415 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 5420 | ch2 driver | ch2: packet consumed (response delay 0) |
| 5420 | yapp driver | TX pkt #40 accepted by the DUT |
| 5420 | yapp driver | TX pkt #41: addr=3 len=21 parity=bad delay=19 |
| 5430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 5430 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 5435 | **DUT** | OUT ch2 pkt #12 done: 3 bytes in 4 cycles |
| 5435 | ch2 monitor | ch2 RX pkt #12: addr=2 len=1 parity=good |
| 5435 | scoreboard | ch2 pkt matched: addr=2 len=1 (26 matched so far) |
| 5615 | **DUT** | IN  pkt #41 header: addr=3 len=21 -> DROP (illegal address 3) |
| 5835 | **DUT** | IN  pkt #41 complete: addr=3 len=21 parity=BAD dropped, 23 bytes in 23 cycles (held 0) |
| 5835 | yapp monitor | RX pkt #41 on the input: addr=3 len=21 parity=bad gap=19 |
| 5835 | reference | Packet dropped: illegal address 3 (len=21) |
| 5835 | **DUT** | ROUTER DROPS PACKET addr=3 length=21 (    illegal address) |
| 5840 | yapp driver | TX pkt #41 accepted by the DUT |
| 5840 | yapp driver | TX pkt #42: addr=3 len=1 parity=bad delay=1 |
| 5855 | **DUT** | IN  pkt #42 header: addr=3 len=1 -> DROP (illegal address 3) |
| 5870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 5870 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 5875 | **DUT** | IN  pkt #42 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 5875 | yapp monitor | RX pkt #42 on the input: addr=3 len=1 parity=bad gap=1 |
| 5875 | reference | Packet dropped: illegal address 3 (len=1) |
| 5875 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 5880 | yapp driver | TX pkt #42 accepted by the DUT |
| 5880 | yapp driver | TX pkt #43: addr=1 len=33 parity=good delay=1 |
| 5895 | **DUT** | IN  pkt #43 header: addr=1 len=33 -> channel 1 |
| 5915 | **DUT** | OUT ch1 pkt #10 start: addr=1 len=33 (receiver waited 1 cycle(s)) |
| 5950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 5950 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 6030 | ch2 driver | ch2: packet consumed (response delay 0) |
| 6235 | **DUT** | IN  pkt #43 complete: addr=1 len=33 parity=ok forwarded, 35 bytes in 35 cycles (held 0) |
| 6235 | yapp monitor | RX pkt #43 on the input: addr=1 len=33 parity=good gap=1 |
| 6235 | reference | Packet forwarded: addr=1 len=33 -> channel 1 |
| 6240 | yapp driver | TX pkt #43 accepted by the DUT |
| 6240 | yapp driver | TX pkt #44: addr=0 len=39 parity=good delay=12 |
| 6250 | ch1 driver | ch1: packet consumed (response delay 1) |
| 6275 | **DUT** | OUT ch1 pkt #10 done: 35 bytes in 37 cycles |
| 6275 | ch1 monitor | ch1 RX pkt #10: addr=1 len=33 parity=good |
| 6275 | scoreboard | ch1 pkt matched: addr=1 len=33 (27 matched so far) |
| 6360 | ch1 driver | ch1: packet consumed (response delay 1) |
| 6365 | **DUT** | IN  pkt #44 header: addr=0 len=39 -> DROP (oversized: len 39 > maxpktsize 37) |
| 6765 | **DUT** | IN  pkt #44 complete: addr=0 len=39 parity=ok dropped, 41 bytes in 41 cycles (held 0) |
| 6765 | yapp monitor | RX pkt #44 on the input: addr=0 len=39 parity=good gap=12 |
| 6765 | reference | Packet dropped: length 39 > maxpktsize 37 (addr=0) |
| 6765 | **DUT** | ROUTER DROPS PACKET addr=0 length=39 (length > maxpktsize) |
| 6770 | yapp driver | TX pkt #44 accepted by the DUT |
| 6770 | yapp driver | TX pkt #45: addr=0 len=1 parity=good delay=2 |
| 6795 | **DUT** | IN  pkt #45 header: addr=0 len=1 -> channel 0 |
| 6805 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6815 | **DUT** | IN  pkt #45 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6815 | yapp monitor | RX pkt #45 on the input: addr=0 len=1 parity=good gap=2 |
| 6815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6820 | ch0 driver | ch0: packet consumed (response delay 0) |
| 6820 | yapp driver | TX pkt #45 accepted by the DUT |
| 6820 | yapp driver | TX pkt #46: addr=0 len=13 parity=bad delay=1 |
| 6835 | **DUT** | IN  pkt #46 header: addr=0 len=13 -> channel 0 |
| 6835 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 4 cycles |
| 6835 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=good |
| 6835 | scoreboard | ch0 pkt matched: addr=0 len=1 (28 matched so far) |
| 6845 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=13 (receiver waited 0 cycle(s)) |
| 6975 | **DUT** | IN  pkt #46 complete: addr=0 len=13 parity=BAD forwarded, 15 bytes in 15 cycles (held 0) |
| 6975 | yapp monitor | RX pkt #46 on the input: addr=0 len=13 parity=bad gap=1 |
| 6975 | reference | Packet forwarded: addr=0 len=13 -> channel 0 |
| 6980 | yapp driver | TX pkt #46 accepted by the DUT |
| 6980 | yapp driver | TX pkt #47: addr=2 len=39 parity=good delay=1 |
| 6985 | **DUT** | OUT ch0 pkt #7 done: 15 bytes in 15 cycles |
| 6985 | ch0 monitor | ch0 RX pkt #7: addr=0 len=13 parity=bad |
| 6985 | scoreboard | ch0 pkt matched: addr=0 len=13 (29 matched so far) |
| 6995 | **DUT** | IN  pkt #47 header: addr=2 len=39 -> DROP (oversized: len 39 > maxpktsize 37) |
| 7030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 7030 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 7390 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7395 | **DUT** | IN  pkt #47 complete: addr=2 len=39 parity=ok dropped, 41 bytes in 41 cycles (held 0) |
| 7395 | yapp monitor | RX pkt #47 on the input: addr=2 len=39 parity=good gap=1 |
| 7395 | reference | Packet dropped: length 39 > maxpktsize 37 (addr=2) |
| 7395 | **DUT** | ROUTER DROPS PACKET addr=2 length=39 (length > maxpktsize) |
| 7400 | yapp driver | TX pkt #47 accepted by the DUT |
| 7400 | **test** | STAGE: burst 3/6 sent: addr0..3 5/3/4/3, bad parity 6, gap 0 3, length 1..63 |
| 7420 | hbus driver | Executed WRITE addr=0x1000 data=0xbe |
| 7425 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 7425 | hbus monitor | Collected WRITE addr=0x1000 data=0xbe |
| 7425 | reference | maxpktsize is now 62 |
| 7440 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 7445 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 7445 | reference | router_en is now 1 (en_reg 0xff) |
| 7460 | hbus driver | Executed WRITE addr=0x1144 data=0xac |
| 7465 | hbus monitor | Collected WRITE addr=0x1144 data=0xac |
| 7490 | hbus driver | Executed READ  addr=0x1144 data=0xac |
| 7495 | hbus monitor | Collected READ  addr=0x1144 data=0xac |
| 7520 | hbus driver | Executed READ  addr=0x10b1 data=0x00 |
| 7525 | hbus monitor | Collected READ  addr=0x10b1 data=0x00 |
| 7540 | hbus driver | Executed WRITE addr=0x1114 data=0xba |
| 7545 | hbus monitor | Collected WRITE addr=0x1114 data=0xba |
| 7570 | hbus driver | Executed READ  addr=0x1114 data=0xba |
| 7570 | **test** | STAGE: burst 4/6: ctrl=0xbe (maxpktsize 62) en=0xff (router on, counter enables 1111111), 17 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 7570 | yapp driver | TX pkt #48: addr=2 len=1 parity=good delay=0 |
| 7575 | hbus monitor | Collected READ  addr=0x1114 data=0xba |
| 7585 | **DUT** | IN  pkt #48 header: addr=2 len=1 -> channel 2 |
| 7595 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 7605 | **DUT** | IN  pkt #48 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7605 | yapp monitor | RX pkt #48 on the input: addr=2 len=1 parity=good gap=18 |
| 7605 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 7610 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7610 | yapp driver | TX pkt #48 accepted by the DUT |
| 7610 | yapp driver | TX pkt #49: addr=0 len=3 parity=good delay=0 |
| 7615 | **DUT** | IN  pkt #49 header: addr=0 len=3 -> channel 0 |
| 7625 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 7625 | **DUT** | OUT ch2 pkt #13 done: 3 bytes in 4 cycles |
| 7625 | ch2 monitor | ch2 RX pkt #13: addr=2 len=1 parity=good |
| 7625 | scoreboard | ch2 pkt matched: addr=2 len=1 (30 matched so far) |
| 7655 | **DUT** | IN  pkt #49 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 7655 | yapp monitor | RX pkt #49 on the input: addr=0 len=3 parity=good gap=0 |
| 7655 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 7660 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7660 | yapp driver | TX pkt #49 accepted by the DUT |
| 7660 | yapp driver | TX pkt #50: addr=0 len=3 parity=good delay=0 |
| 7665 | **DUT** | IN  pkt #50 header: addr=0 len=3 -> channel 0 |
| 7675 | **DUT** | OUT ch0 pkt #8 done: 5 bytes in 6 cycles |
| 7675 | ch0 monitor | ch0 RX pkt #8: addr=0 len=3 parity=good |
| 7675 | scoreboard | ch0 pkt matched: addr=0 len=3 (31 matched so far) |
| 7685 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 7700 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7705 | **DUT** | IN  pkt #50 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 7705 | yapp monitor | RX pkt #50 on the input: addr=0 len=3 parity=good gap=0 |
| 7705 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 7710 | yapp driver | TX pkt #50 accepted by the DUT |
| 7710 | yapp driver | TX pkt #51: addr=1 len=3 parity=good delay=3 |
| 7735 | **DUT** | OUT ch0 pkt #9 done: 5 bytes in 6 cycles |
| 7735 | ch0 monitor | ch0 RX pkt #9: addr=0 len=3 parity=good |
| 7735 | scoreboard | ch0 pkt matched: addr=0 len=3 (32 matched so far) |
| 7745 | **DUT** | IN  pkt #51 header: addr=1 len=3 -> channel 1 |
| 7780 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7785 | **DUT** | IN  pkt #51 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 7785 | yapp monitor | RX pkt #51 on the input: addr=1 len=3 parity=good gap=3 |
| 7785 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 7790 | yapp driver | TX pkt #51 accepted by the DUT |
| 7790 | yapp driver | TX pkt #52: addr=2 len=1 parity=good delay=0 |
| 7795 | **DUT** | IN  pkt #52 header: addr=2 len=1 -> channel 2 |
| 7805 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 7815 | **DUT** | IN  pkt #52 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7815 | yapp monitor | RX pkt #52 on the input: addr=2 len=1 parity=good gap=0 |
| 7815 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 7820 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7820 | yapp driver | TX pkt #52 accepted by the DUT |
| 7820 | yapp driver | TX pkt #53: addr=0 len=3 parity=bad delay=0 |
| 7825 | **DUT** | IN  pkt #53 header: addr=0 len=3 -> channel 0 |
| 7835 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 7835 | **DUT** | OUT ch2 pkt #14 done: 3 bytes in 4 cycles |
| 7835 | ch2 monitor | ch2 RX pkt #14: addr=2 len=1 parity=good |
| 7835 | scoreboard | ch2 pkt matched: addr=2 len=1 (33 matched so far) |
| 7840 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7845 | **DUT** | OUT ch1 pkt #11 start: addr=1 len=3 (receiver waited 9 cycle(s)) |
| 7865 | **DUT** | IN  pkt #53 complete: addr=0 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 7865 | yapp monitor | RX pkt #53 on the input: addr=0 len=3 parity=bad gap=0 |
| 7865 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 7870 | yapp driver | TX pkt #53 accepted by the DUT |
| 7870 | yapp driver | TX pkt #54: addr=0 len=3 parity=bad delay=0 |
| 7875 | **DUT** | IN  pkt #54 header: addr=0 len=3 -> channel 0 |
| 7880 | ch1 driver | ch1: packet consumed (response delay 9) |
| 7885 | **DUT** | OUT ch0 pkt #10 done: 5 bytes in 6 cycles |
| 7885 | ch0 monitor | ch0 RX pkt #10: addr=0 len=3 parity=bad |
| 7885 | scoreboard | ch0 pkt matched: addr=0 len=3 (34 matched so far) |
| 7895 | **DUT** | OUT ch0 pkt #11 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 7910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 7910 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 7915 | **DUT** | IN  pkt #54 complete: addr=0 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 7915 | yapp monitor | RX pkt #54 on the input: addr=0 len=3 parity=bad gap=0 |
| 7915 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 7920 | yapp driver | TX pkt #54 accepted by the DUT |
| 7920 | yapp driver | TX pkt #55: addr=2 len=3 parity=good delay=0 |
| 7925 | **DUT** | IN  pkt #55 header: addr=2 len=3 -> channel 2 |
| 7935 | **DUT** | OUT ch0 pkt #11 done: 5 bytes in 5 cycles |
| 7935 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 7935 | ch0 monitor | ch0 RX pkt #11: addr=0 len=3 parity=bad |
| 7935 | scoreboard | ch0 pkt matched: addr=0 len=3 (35 matched so far) |
| 7950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 7950 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 7965 | **DUT** | IN  pkt #55 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 7965 | yapp monitor | RX pkt #55 on the input: addr=2 len=3 parity=good gap=0 |
| 7965 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 7970 | yapp driver | TX pkt #55 accepted by the DUT |
| 7970 | yapp driver | TX pkt #56: addr=2 len=3 parity=good delay=0 |
| 7975 | **DUT** | IN  pkt #56 header: addr=2 len=3 -> channel 2 |
| 7975 | **DUT** | OUT ch2 pkt #15 done: 5 bytes in 5 cycles |
| 7975 | ch2 monitor | ch2 RX pkt #15: addr=2 len=3 parity=good |
| 7975 | scoreboard | ch2 pkt matched: addr=2 len=3 (36 matched so far) |
| 7985 | **DUT** | OUT ch1 pkt #11 done: 5 bytes in 15 cycles |
| 7985 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 7985 | ch1 monitor | ch1 RX pkt #11: addr=1 len=3 parity=good |
| 7985 | scoreboard | ch1 pkt matched: addr=1 len=3 (37 matched so far) |
| 8015 | **DUT** | IN  pkt #56 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 8015 | yapp monitor | RX pkt #56 on the input: addr=2 len=3 parity=good gap=0 |
| 8015 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 8020 | yapp driver | TX pkt #56 accepted by the DUT |
| 8020 | yapp driver | TX pkt #57: addr=2 len=1 parity=good delay=0 |
| 8025 | **DUT** | IN  pkt #57 header: addr=2 len=1 -> channel 2 |
| 8025 | **DUT** | OUT ch2 pkt #16 done: 5 bytes in 5 cycles |
| 8025 | ch2 monitor | ch2 RX pkt #16: addr=2 len=3 parity=good |
| 8025 | scoreboard | ch2 pkt matched: addr=2 len=3 (38 matched so far) |
| 8035 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 8045 | **DUT** | IN  pkt #57 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8045 | yapp monitor | RX pkt #57 on the input: addr=2 len=1 parity=good gap=0 |
| 8045 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 8050 | yapp driver | TX pkt #57 accepted by the DUT |
| 8050 | yapp driver | TX pkt #58: addr=2 len=2 parity=good delay=2 |
| 8055 | **DUT** | OUT ch2 pkt #17 done: 3 bytes in 3 cycles |
| 8055 | ch2 monitor | ch2 RX pkt #17: addr=2 len=1 parity=good |
| 8055 | scoreboard | ch2 pkt matched: addr=2 len=1 (39 matched so far) |
| 8075 | **DUT** | IN  pkt #58 header: addr=2 len=2 -> channel 2 |
| 8080 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8085 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 8105 | **DUT** | IN  pkt #58 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 8105 | yapp monitor | RX pkt #58 on the input: addr=2 len=2 parity=good gap=2 |
| 8105 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 8110 | yapp driver | TX pkt #58 accepted by the DUT |
| 8110 | yapp driver | TX pkt #59: addr=0 len=1 parity=good delay=0 |
| 8115 | **DUT** | IN  pkt #59 header: addr=0 len=1 -> channel 0 |
| 8115 | **DUT** | OUT ch2 pkt #18 done: 4 bytes in 4 cycles |
| 8115 | ch2 monitor | ch2 RX pkt #18: addr=2 len=2 parity=good |
| 8115 | scoreboard | ch2 pkt matched: addr=2 len=2 (40 matched so far) |
| 8125 | **DUT** | OUT ch0 pkt #12 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8135 | **DUT** | IN  pkt #59 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8135 | yapp monitor | RX pkt #59 on the input: addr=0 len=1 parity=good gap=0 |
| 8135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8140 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8140 | yapp driver | TX pkt #59 accepted by the DUT |
| 8140 | yapp driver | TX pkt #60: addr=3 len=3 parity=good delay=3 |
| 8155 | **DUT** | OUT ch0 pkt #12 done: 3 bytes in 4 cycles |
| 8155 | ch0 monitor | ch0 RX pkt #12: addr=0 len=1 parity=good |
| 8155 | scoreboard | ch0 pkt matched: addr=0 len=1 (41 matched so far) |
| 8175 | **DUT** | IN  pkt #60 header: addr=3 len=3 -> DROP (illegal address 3) |
| 8190 | ch1 driver | ch1: packet consumed (response delay 9) |
| 8210 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8215 | **DUT** | IN  pkt #60 complete: addr=3 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 8215 | yapp monitor | RX pkt #60 on the input: addr=3 len=3 parity=good gap=3 |
| 8215 | reference | Packet dropped: illegal address 3 (len=3) |
| 8215 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 8220 | yapp driver | TX pkt #60 accepted by the DUT |
| 8220 | yapp driver | TX pkt #61: addr=3 len=1 parity=good delay=0 |
| 8225 | **DUT** | IN  pkt #61 header: addr=3 len=1 -> DROP (illegal address 3) |
| 8245 | **DUT** | IN  pkt #61 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8245 | yapp monitor | RX pkt #61 on the input: addr=3 len=1 parity=good gap=0 |
| 8245 | reference | Packet dropped: illegal address 3 (len=1) |
| 8245 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 8250 | yapp driver | TX pkt #61 accepted by the DUT |
| 8250 | yapp driver | TX pkt #62: addr=3 len=2 parity=good delay=0 |
| 8255 | **DUT** | IN  pkt #62 header: addr=3 len=2 -> DROP (illegal address 3) |
| 8285 | **DUT** | IN  pkt #62 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 8285 | yapp monitor | RX pkt #62 on the input: addr=3 len=2 parity=good gap=0 |
| 8285 | reference | Packet dropped: illegal address 3 (len=2) |
| 8285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 8290 | yapp driver | TX pkt #62 accepted by the DUT |
| 8290 | yapp driver | TX pkt #63: addr=2 len=1 parity=bad delay=0 |
| 8295 | **DUT** | IN  pkt #63 header: addr=2 len=1 -> channel 2 |
| 8305 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 8315 | **DUT** | IN  pkt #63 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 8315 | yapp monitor | RX pkt #63 on the input: addr=2 len=1 parity=bad gap=0 |
| 8315 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 8320 | yapp driver | TX pkt #63 accepted by the DUT |
| 8320 | yapp driver | TX pkt #64: addr=0 len=2 parity=good delay=0 |
| 8325 | **DUT** | IN  pkt #64 header: addr=0 len=2 -> channel 0 |
| 8325 | **DUT** | OUT ch2 pkt #19 done: 3 bytes in 3 cycles |
| 8325 | ch2 monitor | ch2 RX pkt #19: addr=2 len=1 parity=bad |
| 8325 | scoreboard | ch2 pkt matched: addr=2 len=1 (42 matched so far) |
| 8330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 8330 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 8335 | **DUT** | OUT ch0 pkt #13 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 8355 | **DUT** | IN  pkt #64 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 8355 | yapp monitor | RX pkt #64 on the input: addr=0 len=2 parity=good gap=0 |
| 8355 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 8360 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8360 | yapp driver | TX pkt #64 accepted by the DUT |
| 8360 | **test** | STAGE: burst 4/6 sent: addr0..3 6/1/7/3, bad parity 3, gap 0 14, length 1..3 |
| 8375 | **DUT** | OUT ch0 pkt #13 done: 4 bytes in 5 cycles |
| 8375 | ch0 monitor | ch0 RX pkt #13: addr=0 len=2 parity=good |
| 8375 | scoreboard | ch0 pkt matched: addr=0 len=2 (43 matched so far) |
| 8380 | hbus driver | Executed WRITE addr=0x1000 data=0xf8 |
| 8385 | **DUT** | CONFIG router_en=1 maxpktsize=56 |
| 8385 | hbus monitor | Collected WRITE addr=0x1000 data=0xf8 |
| 8385 | reference | maxpktsize is now 56 |
| 8390 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8400 | hbus driver | Executed WRITE addr=0x1001 data=0x0f |
| 8405 | hbus monitor | Collected WRITE addr=0x1001 data=0x0f |
| 8405 | reference | router_en is now 1 (en_reg 0x0f) |
| 8410 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8420 | hbus driver | Executed WRITE addr=0x1136 data=0x5a |
| 8425 | hbus monitor | Collected WRITE addr=0x1136 data=0x5a |
| 8450 | hbus driver | Executed READ  addr=0x1136 data=0x5a |
| 8455 | hbus monitor | Collected READ  addr=0x1136 data=0x5a |
| 8470 | hbus driver | Executed WRITE addr=0x1136 data=0x2d |
| 8475 | hbus monitor | Collected WRITE addr=0x1136 data=0x2d |
| 8500 | hbus driver | Executed READ  addr=0x1136 data=0x2d |
| 8505 | hbus monitor | Collected READ  addr=0x1136 data=0x2d |
| 8530 | hbus driver | Executed READ  addr=0x1048 data=0x7c |
| 8535 | hbus monitor | Collected READ  addr=0x1048 data=0x7c |
| 8550 | hbus driver | Executed WRITE addr=0x114c data=0x10 |
| 8555 | hbus monitor | Collected WRITE addr=0x114c data=0x10 |
| 8580 | hbus driver | Executed READ  addr=0x114c data=0x10 |
| 8585 | hbus monitor | Collected READ  addr=0x114c data=0x10 |
| 8610 | hbus driver | Executed READ  addr=0x10a8 data=0x00 |
| 8610 | **test** | STAGE: burst 5/6: ctrl=0xf8 (maxpktsize 56) en=0x0f (router on, counter enables 0000111), 16 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 8610 | yapp driver | TX pkt #65: addr=1 len=1 parity=good delay=0 |
| 8615 | hbus monitor | Collected READ  addr=0x10a8 data=0x00 |
| 8625 | **DUT** | IN  pkt #65 header: addr=1 len=1 -> channel 1 |
| 8645 | **DUT** | IN  pkt #65 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8645 | yapp monitor | RX pkt #65 on the input: addr=1 len=1 parity=good gap=26 |
| 8645 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 8650 | yapp driver | TX pkt #65 accepted by the DUT |
| 8650 | yapp driver | TX pkt #66: addr=0 len=3 parity=bad delay=0 |
| 8655 | **DUT** | IN  pkt #66 header: addr=0 len=3 -> channel 0 |
| 8665 | **DUT** | OUT ch0 pkt #14 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 8685 | **DUT** | OUT ch1 pkt #12 start: addr=1 len=1 (receiver waited 5 cycle(s)) |
| 8695 | **DUT** | IN  pkt #66 complete: addr=0 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 8695 | yapp monitor | RX pkt #66 on the input: addr=0 len=3 parity=bad gap=0 |
| 8695 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 8700 | ch1 driver | ch1: packet consumed (response delay 5) |
| 8700 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8700 | yapp driver | TX pkt #66 accepted by the DUT |
| 8700 | yapp driver | TX pkt #67: addr=2 len=1 parity=good delay=0 |
| 8705 | **DUT** | IN  pkt #67 header: addr=2 len=1 -> channel 2 |
| 8710 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 8710 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 8715 | **DUT** | OUT ch0 pkt #14 done: 5 bytes in 6 cycles |
| 8715 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 8715 | ch0 monitor | ch0 RX pkt #14: addr=0 len=3 parity=bad |
| 8715 | scoreboard | ch0 pkt matched: addr=0 len=3 (44 matched so far) |
| 8725 | **DUT** | IN  pkt #67 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8725 | yapp monitor | RX pkt #67 on the input: addr=2 len=1 parity=good gap=0 |
| 8725 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 8730 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8730 | yapp driver | TX pkt #67 accepted by the DUT |
| 8730 | yapp driver | TX pkt #68: addr=1 len=3 parity=bad delay=0 |
| 8735 | **DUT** | IN  pkt #68 header: addr=1 len=3 -> channel 1 |
| 8745 | **DUT** | OUT ch2 pkt #20 done: 3 bytes in 4 cycles |
| 8745 | ch2 monitor | ch2 RX pkt #20: addr=2 len=1 parity=good |
| 8745 | scoreboard | ch2 pkt matched: addr=2 len=1 (45 matched so far) |
| 8760 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8775 | **DUT** | IN  pkt #68 complete: addr=1 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 8775 | yapp monitor | RX pkt #68 on the input: addr=1 len=3 parity=bad gap=0 |
| 8775 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 8780 | yapp driver | TX pkt #68 accepted by the DUT |
| 8780 | yapp driver | TX pkt #69: addr=1 len=2 parity=good delay=0 |
| 8785 | **DUT** | IN  pkt #69 header: addr=1 len=2 -> channel 1 |
| 8815 | **DUT** | IN  pkt #69 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 8815 | **DUT** | OUT ch1 pkt #12 done: 3 bytes in 14 cycles |
| 8815 | ch1 monitor | ch1 RX pkt #12: addr=1 len=1 parity=good |
| 8815 | scoreboard | ch1 pkt matched: addr=1 len=1 (46 matched so far) |
| 8815 | yapp monitor | RX pkt #69 on the input: addr=1 len=2 parity=good gap=0 |
| 8815 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 8820 | yapp driver | TX pkt #69 accepted by the DUT |
| 8820 | yapp driver | TX pkt #70: addr=2 len=1 parity=good delay=0 |
| 8825 | **DUT** | IN  pkt #70 header: addr=2 len=1 -> channel 2 |
| 8825 | **DUT** | OUT ch1 pkt #13 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 8835 | **DUT** | OUT ch2 pkt #21 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 8845 | **DUT** | IN  pkt #70 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8845 | yapp monitor | RX pkt #70 on the input: addr=2 len=1 parity=good gap=0 |
| 8845 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 8850 | yapp driver | TX pkt #70 accepted by the DUT |
| 8850 | yapp driver | TX pkt #71: addr=0 len=1 parity=good delay=0 |
| 8855 | **DUT** | IN  pkt #71 header: addr=0 len=1 -> channel 0 |
| 8855 | **DUT** | OUT ch2 pkt #21 done: 3 bytes in 3 cycles |
| 8855 | ch2 monitor | ch2 RX pkt #21: addr=2 len=1 parity=good |
| 8855 | scoreboard | ch2 pkt matched: addr=2 len=1 (47 matched so far) |
| 8865 | **DUT** | OUT ch0 pkt #15 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8865 | **DUT** | OUT ch1 pkt #13 done: 5 bytes in 5 cycles |
| 8865 | ch1 monitor | ch1 RX pkt #13: addr=1 len=3 parity=bad |
| 8865 | scoreboard | ch1 pkt matched: addr=1 len=3 (48 matched so far) |
| 8870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 8870 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 8875 | **DUT** | IN  pkt #71 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8875 | **DUT** | OUT ch1 pkt #14 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 8875 | yapp monitor | RX pkt #71 on the input: addr=0 len=1 parity=good gap=0 |
| 8875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8880 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8880 | yapp driver | TX pkt #71 accepted by the DUT |
| 8880 | yapp driver | TX pkt #72: addr=1 len=2 parity=good delay=0 |
| 8885 | **DUT** | IN  pkt #72 header: addr=1 len=2 -> channel 1 |
| 8895 | **DUT** | OUT ch0 pkt #15 done: 3 bytes in 4 cycles |
| 8895 | ch0 monitor | ch0 RX pkt #15: addr=0 len=1 parity=good |
| 8895 | scoreboard | ch0 pkt matched: addr=0 len=1 (49 matched so far) |
| 8905 | **DUT** | OUT ch1 pkt #14 done: 4 bytes in 4 cycles |
| 8905 | ch1 monitor | ch1 RX pkt #14: addr=1 len=2 parity=good |
| 8905 | scoreboard | ch1 pkt matched: addr=1 len=2 (50 matched so far) |
| 8915 | **DUT** | IN  pkt #72 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 8915 | **DUT** | OUT ch1 pkt #15 start: addr=1 len=2 (receiver waited 0 cycle(s)) |
| 8915 | yapp monitor | RX pkt #72 on the input: addr=1 len=2 parity=good gap=0 |
| 8915 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 8920 | yapp driver | TX pkt #72 accepted by the DUT |
| 8920 | yapp driver | TX pkt #73: addr=3 len=1 parity=good delay=0 |
| 8925 | **DUT** | IN  pkt #73 header: addr=3 len=1 -> DROP (illegal address 3) |
| 8945 | **DUT** | IN  pkt #73 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8945 | **DUT** | OUT ch1 pkt #15 done: 4 bytes in 4 cycles |
| 8945 | ch1 monitor | ch1 RX pkt #15: addr=1 len=2 parity=good |
| 8945 | scoreboard | ch1 pkt matched: addr=1 len=2 (51 matched so far) |
| 8945 | yapp monitor | RX pkt #73 on the input: addr=3 len=1 parity=good gap=0 |
| 8945 | reference | Packet dropped: illegal address 3 (len=1) |
| 8945 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 8950 | yapp driver | TX pkt #73 accepted by the DUT |
| 8950 | yapp driver | TX pkt #74: addr=0 len=3 parity=good delay=0 |
| 8955 | **DUT** | IN  pkt #74 header: addr=0 len=3 -> channel 0 |
| 8965 | **DUT** | OUT ch0 pkt #16 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 8995 | **DUT** | IN  pkt #74 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 8995 | yapp monitor | RX pkt #74 on the input: addr=0 len=3 parity=good gap=0 |
| 8995 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 9000 | yapp driver | TX pkt #74 accepted by the DUT |
| 9000 | yapp driver | TX pkt #75: addr=0 len=2 parity=bad delay=0 |
| 9005 | **DUT** | IN  pkt #75 header: addr=0 len=2 -> channel 0 |
| 9005 | **DUT** | OUT ch0 pkt #16 done: 5 bytes in 5 cycles |
| 9005 | ch0 monitor | ch0 RX pkt #16: addr=0 len=3 parity=good |
| 9005 | scoreboard | ch0 pkt matched: addr=0 len=3 (52 matched so far) |
| 9015 | **DUT** | OUT ch0 pkt #17 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 9035 | **DUT** | IN  pkt #75 complete: addr=0 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 9035 | yapp monitor | RX pkt #75 on the input: addr=0 len=2 parity=bad gap=0 |
| 9035 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 9040 | yapp driver | TX pkt #75 accepted by the DUT |
| 9040 | yapp driver | TX pkt #76: addr=2 len=1 parity=bad delay=1 |
| 9045 | **DUT** | OUT ch0 pkt #17 done: 4 bytes in 4 cycles |
| 9045 | ch0 monitor | ch0 RX pkt #17: addr=0 len=2 parity=bad |
| 9045 | scoreboard | ch0 pkt matched: addr=0 len=2 (53 matched so far) |
| 9055 | **DUT** | IN  pkt #76 header: addr=2 len=1 -> channel 2 |
| 9065 | **DUT** | OUT ch2 pkt #22 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 9070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 9070 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 9075 | **DUT** | IN  pkt #76 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9075 | yapp monitor | RX pkt #76 on the input: addr=2 len=1 parity=bad gap=1 |
| 9075 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 9080 | yapp driver | TX pkt #76 accepted by the DUT |
| 9080 | yapp driver | TX pkt #77: addr=2 len=2 parity=good delay=0 |
| 9085 | **DUT** | IN  pkt #77 header: addr=2 len=2 -> channel 2 |
| 9085 | **DUT** | OUT ch2 pkt #22 done: 3 bytes in 3 cycles |
| 9085 | ch2 monitor | ch2 RX pkt #22: addr=2 len=1 parity=bad |
| 9085 | scoreboard | ch2 pkt matched: addr=2 len=1 (54 matched so far) |
| 9095 | **DUT** | OUT ch2 pkt #23 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 9115 | **DUT** | IN  pkt #77 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 9115 | yapp monitor | RX pkt #77 on the input: addr=2 len=2 parity=good gap=0 |
| 9115 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 9120 | yapp driver | TX pkt #77 accepted by the DUT |
| 9120 | yapp driver | TX pkt #78: addr=0 len=3 parity=bad delay=0 |
| 9125 | **DUT** | IN  pkt #78 header: addr=0 len=3 -> channel 0 |
| 9125 | **DUT** | OUT ch2 pkt #23 done: 4 bytes in 4 cycles |
| 9125 | ch2 monitor | ch2 RX pkt #23: addr=2 len=2 parity=good |
| 9125 | scoreboard | ch2 pkt matched: addr=2 len=2 (55 matched so far) |
| 9135 | **DUT** | OUT ch0 pkt #18 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 9150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 9150 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 9165 | **DUT** | IN  pkt #78 complete: addr=0 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 9165 | yapp monitor | RX pkt #78 on the input: addr=0 len=3 parity=bad gap=0 |
| 9165 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 9170 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9170 | yapp driver | TX pkt #78 accepted by the DUT |
| 9170 | yapp driver | TX pkt #79: addr=3 len=1 parity=good delay=0 |
| 9175 | **DUT** | IN  pkt #79 header: addr=3 len=1 -> DROP (illegal address 3) |
| 9175 | **DUT** | OUT ch0 pkt #18 done: 5 bytes in 5 cycles |
| 9175 | ch0 monitor | ch0 RX pkt #18: addr=0 len=3 parity=bad |
| 9175 | scoreboard | ch0 pkt matched: addr=0 len=3 (56 matched so far) |
| 9195 | **DUT** | IN  pkt #79 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 9195 | yapp monitor | RX pkt #79 on the input: addr=3 len=1 parity=good gap=0 |
| 9195 | reference | Packet dropped: illegal address 3 (len=1) |
| 9195 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 9200 | yapp driver | TX pkt #79 accepted by the DUT |
| 9200 | yapp driver | TX pkt #80: addr=1 len=1 parity=bad delay=3 |
| 9210 | ch1 driver | ch1: packet consumed (response delay 10) |
| 9230 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 9230 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 9235 | **DUT** | IN  pkt #80 header: addr=1 len=1 -> channel 1 |
| 9255 | **DUT** | IN  pkt #80 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9255 | yapp monitor | RX pkt #80 on the input: addr=1 len=1 parity=bad gap=3 |
| 9255 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 9260 | yapp driver | TX pkt #80 accepted by the DUT |
| 9260 | **test** | STAGE: burst 5/6 sent: addr0..3 5/5/4/2, bad parity 6, gap 0 14, length 1..3 |
| 9280 | hbus driver | Executed WRITE addr=0x1000 data=0xac |
| 9285 | **DUT** | CONFIG router_en=1 maxpktsize=44 |
| 9285 | hbus monitor | Collected WRITE addr=0x1000 data=0xac |
| 9285 | reference | maxpktsize is now 44 |
| 9300 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 9305 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 9305 | reference | router_en is now 1 (en_reg 0xff) |
| 9320 | hbus driver | Executed WRITE addr=0x1108 data=0x2a |
| 9325 | hbus monitor | Collected WRITE addr=0x1108 data=0x2a |
| 9335 | **DUT** | OUT ch1 pkt #16 start: addr=1 len=1 (receiver waited 9 cycle(s)) |
| 9350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 9350 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 9350 | ch1 driver | ch1: packet consumed (response delay 9) |
| 9350 | hbus driver | Executed READ  addr=0x1108 data=0x2a |
| 9355 | hbus monitor | Collected READ  addr=0x1108 data=0x2a |
| 9370 | ch0 driver | ch0: packet consumed (response delay 0) |
| 9370 | hbus driver | Executed WRITE addr=0x1155 data=0x9d |
| 9375 | hbus monitor | Collected WRITE addr=0x1155 data=0x9d |
| 9400 | hbus driver | Executed READ  addr=0x1155 data=0x9d |
| 9405 | hbus monitor | Collected READ  addr=0x1155 data=0x9d |
| 9425 | **DUT** | OUT ch1 pkt #16 done: 3 bytes in 10 cycles |
| 9425 | ch1 monitor | ch1 RX pkt #16: addr=1 len=1 parity=bad |
| 9425 | scoreboard | ch1 pkt matched: addr=1 len=1 (57 matched so far) |
| 9430 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 9435 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 9460 | hbus driver | Executed READ  addr=0x1055 data=0x00 |
| 9465 | hbus monitor | Collected READ  addr=0x1055 data=0x00 |
| 9490 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 9495 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 9510 | hbus driver | Executed WRITE addr=0x1130 data=0x02 |
| 9515 | hbus monitor | Collected WRITE addr=0x1130 data=0x02 |
| 9540 | hbus driver | Executed READ  addr=0x1130 data=0x02 |
| 9545 | hbus monitor | Collected READ  addr=0x1130 data=0x02 |
| 9560 | hbus driver | Executed WRITE addr=0x11fd data=0xc9 |
| 9565 | hbus monitor | Collected WRITE addr=0x11fd data=0xc9 |
| 9590 | hbus driver | Executed READ  addr=0x11fd data=0xc9 |
| 9590 | **test** | STAGE: burst 6/6: ctrl=0xac (maxpktsize 44) en=0xff (router on, counter enables 1111111), 15 packet(s) |
| 9590 | yapp driver | TX pkt #81: addr=0 len=63 parity=bad delay=1 |
| 9595 | hbus monitor | Collected READ  addr=0x11fd data=0xc9 |
| 9615 | **DUT** | IN  pkt #81 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 10060 | ch1 driver | ch1: packet consumed (response delay 6) |
| 10255 | **DUT** | IN  pkt #81 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 10255 | yapp monitor | RX pkt #81 on the input: addr=0 len=63 parity=bad gap=35 |
| 10255 | reference | Packet dropped: length 63 > maxpktsize 44 (addr=0) |
| 10255 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 10260 | yapp driver | TX pkt #81 accepted by the DUT |
| 10260 | yapp driver | TX pkt #82: addr=1 len=63 parity=bad delay=3 |
| 10290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 10290 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 10295 | **DUT** | IN  pkt #82 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 10935 | **DUT** | IN  pkt #82 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 10935 | yapp monitor | RX pkt #82 on the input: addr=1 len=63 parity=bad gap=3 |
| 10935 | reference | Packet dropped: length 63 > maxpktsize 44 (addr=1) |
| 10935 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 10940 | yapp driver | TX pkt #82 accepted by the DUT |
| 10940 | yapp driver | TX pkt #83: addr=3 len=63 parity=good delay=4 |
| 10950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 10950 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 10985 | **DUT** | IN  pkt #83 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 11625 | **DUT** | IN  pkt #83 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11625 | yapp monitor | RX pkt #83 on the input: addr=3 len=63 parity=good gap=4 |
| 11625 | reference | Packet dropped: illegal address 3 (len=63) |
| 11625 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 11630 | yapp driver | TX pkt #83 accepted by the DUT |
| 11630 | yapp driver | TX pkt #84: addr=1 len=63 parity=good delay=0 |
| 11635 | **DUT** | IN  pkt #84 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 12275 | **DUT** | IN  pkt #84 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12275 | yapp monitor | RX pkt #84 on the input: addr=1 len=63 parity=good gap=0 |
| 12275 | reference | Packet dropped: length 63 > maxpktsize 44 (addr=1) |
| 12275 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 12280 | yapp driver | TX pkt #84 accepted by the DUT |
| 12280 | yapp driver | TX pkt #85: addr=1 len=45 parity=good delay=5 |
| 12335 | **DUT** | IN  pkt #85 header: addr=1 len=45 -> DROP (oversized: len 45 > maxpktsize 44) |
| 12795 | **DUT** | IN  pkt #85 complete: addr=1 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 12795 | yapp monitor | RX pkt #85 on the input: addr=1 len=45 parity=good gap=5 |
| 12795 | reference | Packet dropped: length 45 > maxpktsize 44 (addr=1) |
| 12795 | **DUT** | ROUTER DROPS PACKET addr=1 length=45 (length > maxpktsize) |
| 12800 | yapp driver | TX pkt #85 accepted by the DUT |
| 12800 | yapp driver | TX pkt #86: addr=1 len=45 parity=good delay=11 |
| 12915 | **DUT** | IN  pkt #86 header: addr=1 len=45 -> DROP (oversized: len 45 > maxpktsize 44) |
| 13375 | **DUT** | IN  pkt #86 complete: addr=1 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 13375 | yapp monitor | RX pkt #86 on the input: addr=1 len=45 parity=good gap=11 |
| 13375 | reference | Packet dropped: length 45 > maxpktsize 44 (addr=1) |
| 13375 | **DUT** | ROUTER DROPS PACKET addr=1 length=45 (length > maxpktsize) |
| 13380 | yapp driver | TX pkt #86 accepted by the DUT |
| 13380 | yapp driver | TX pkt #87: addr=1 len=23 parity=good delay=0 |
| 13385 | **DUT** | IN  pkt #87 header: addr=1 len=23 -> channel 1 |
| 13485 | **DUT** | OUT ch1 pkt #17 start: addr=1 len=23 (receiver waited 9 cycle(s)) |
| 13625 | **DUT** | IN  pkt #87 complete: addr=1 len=23 parity=ok forwarded, 25 bytes in 25 cycles (held 0) |
| 13625 | yapp monitor | RX pkt #87 on the input: addr=1 len=23 parity=good gap=0 |
| 13625 | reference | Packet forwarded: addr=1 len=23 -> channel 1 |
| 13630 | yapp driver | TX pkt #87 accepted by the DUT |
| 13630 | yapp driver | TX pkt #88: addr=2 len=11 parity=bad delay=3 |
| 13665 | **DUT** | IN  pkt #88 header: addr=2 len=11 -> channel 2 |
| 13675 | **DUT** | OUT ch2 pkt #24 start: addr=2 len=11 (receiver waited 0 cycle(s)) |
| 13720 | ch1 driver | ch1: packet consumed (response delay 9) |
| 13785 | **DUT** | IN  pkt #88 complete: addr=2 len=11 parity=BAD forwarded, 13 bytes in 13 cycles (held 0) |
| 13785 | yapp monitor | RX pkt #88 on the input: addr=2 len=11 parity=bad gap=3 |
| 13785 | reference | Packet forwarded: addr=2 len=11 -> channel 2 |
| 13790 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13790 | yapp driver | TX pkt #88 accepted by the DUT |
| 13790 | yapp driver | TX pkt #89: addr=1 len=9 parity=bad delay=2 |
| 13805 | **DUT** | OUT ch2 pkt #24 done: 13 bytes in 14 cycles |
| 13805 | ch2 monitor | ch2 RX pkt #24: addr=2 len=11 parity=bad |
| 13805 | scoreboard | ch2 pkt matched: addr=2 len=11 (58 matched so far) |
| 13815 | **DUT** | IN  pkt #89 header: addr=1 len=9 -> channel 1 |
| 13830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 13830 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 13835 | **DUT** | OUT ch1 pkt #17 done: 25 bytes in 36 cycles |
| 13835 | ch1 monitor | ch1 RX pkt #17: addr=1 len=23 parity=good |
| 13835 | scoreboard | ch1 pkt matched: addr=1 len=23 (59 matched so far) |
| 13845 | **DUT** | OUT ch1 pkt #18 start: addr=1 len=9 (receiver waited 0 cycle(s)) |
| 13915 | **DUT** | IN  pkt #89 complete: addr=1 len=9 parity=BAD forwarded, 11 bytes in 11 cycles (held 0) |
| 13915 | yapp monitor | RX pkt #89 on the input: addr=1 len=9 parity=bad gap=2 |
| 13915 | reference | Packet forwarded: addr=1 len=9 -> channel 1 |
| 13920 | yapp driver | TX pkt #89 accepted by the DUT |
| 13920 | yapp driver | TX pkt #90: addr=2 len=63 parity=good delay=0 |
| 13925 | **DUT** | IN  pkt #90 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 13930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 13930 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 13930 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13945 | **DUT** | OUT ch1 pkt #18 done: 11 bytes in 11 cycles |
| 13945 | ch1 monitor | ch1 RX pkt #18: addr=1 len=9 parity=bad |
| 13945 | scoreboard | ch1 pkt matched: addr=1 len=9 (60 matched so far) |
| 14020 | ch1 driver | ch1: packet consumed (response delay 10) |
| 14565 | **DUT** | IN  pkt #90 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 14565 | yapp monitor | RX pkt #90 on the input: addr=2 len=63 parity=good gap=0 |
| 14565 | reference | Packet dropped: length 63 > maxpktsize 44 (addr=2) |
| 14565 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 14570 | yapp driver | TX pkt #90 accepted by the DUT |
| 14570 | yapp driver | TX pkt #91: addr=1 len=1 parity=good delay=0 |
| 14575 | **DUT** | IN  pkt #91 header: addr=1 len=1 -> channel 1 |
| 14585 | **DUT** | OUT ch1 pkt #19 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 14595 | **DUT** | IN  pkt #91 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14595 | yapp monitor | RX pkt #91 on the input: addr=1 len=1 parity=good gap=0 |
| 14595 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 14600 | ch1 driver | ch1: packet consumed (response delay 0) |
| 14600 | yapp driver | TX pkt #91 accepted by the DUT |
| 14600 | yapp driver | TX pkt #92: addr=2 len=12 parity=good delay=0 |
| 14605 | **DUT** | IN  pkt #92 header: addr=2 len=12 -> channel 2 |
| 14615 | **DUT** | OUT ch2 pkt #25 start: addr=2 len=12 (receiver waited 0 cycle(s)) |
| 14625 | **DUT** | OUT ch1 pkt #19 done: 3 bytes in 5 cycles |
| 14625 | ch1 monitor | ch1 RX pkt #19: addr=1 len=1 parity=good |
| 14625 | scoreboard | ch1 pkt matched: addr=1 len=1 (61 matched so far) |
| 14735 | **DUT** | IN  pkt #92 complete: addr=2 len=12 parity=ok forwarded, 14 bytes in 14 cycles (held 0) |
| 14735 | yapp monitor | RX pkt #92 on the input: addr=2 len=12 parity=good gap=0 |
| 14735 | reference | Packet forwarded: addr=2 len=12 -> channel 2 |
| 14740 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14740 | yapp driver | TX pkt #92 accepted by the DUT |
| 14740 | yapp driver | TX pkt #93: addr=0 len=63 parity=good delay=2 |
| 14755 | **DUT** | OUT ch2 pkt #25 done: 14 bytes in 15 cycles |
| 14755 | ch2 monitor | ch2 RX pkt #25: addr=2 len=12 parity=good |
| 14755 | scoreboard | ch2 pkt matched: addr=2 len=12 (62 matched so far) |
| 14765 | **DUT** | IN  pkt #93 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 44) |
| 14810 | ch1 driver | ch1: packet consumed (response delay 1) |
| 15230 | ch2 driver | ch2: packet consumed (response delay 0) |
| 15405 | **DUT** | IN  pkt #93 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 15405 | yapp monitor | RX pkt #93 on the input: addr=0 len=63 parity=good gap=2 |
| 15405 | reference | Packet dropped: length 63 > maxpktsize 44 (addr=0) |
| 15405 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 15410 | yapp driver | TX pkt #93 accepted by the DUT |
| 15410 | yapp driver | TX pkt #94: addr=0 len=4 parity=bad delay=0 |
| 15415 | **DUT** | IN  pkt #94 header: addr=0 len=4 -> channel 0 |
| 15425 | **DUT** | OUT ch0 pkt #19 start: addr=0 len=4 (receiver waited 0 cycle(s)) |
| 15465 | **DUT** | IN  pkt #94 complete: addr=0 len=4 parity=BAD forwarded, 6 bytes in 6 cycles (held 0) |
| 15465 | yapp monitor | RX pkt #94 on the input: addr=0 len=4 parity=bad gap=0 |
| 15465 | reference | Packet forwarded: addr=0 len=4 -> channel 0 |
| 15470 | ch0 driver | ch0: packet consumed (response delay 0) |
| 15470 | yapp driver | TX pkt #94 accepted by the DUT |
| 15470 | yapp driver | TX pkt #95: addr=1 len=40 parity=good delay=16 |
| 15485 | **DUT** | OUT ch0 pkt #19 done: 6 bytes in 7 cycles |
| 15485 | ch0 monitor | ch0 RX pkt #19: addr=0 len=4 parity=bad |
| 15485 | scoreboard | ch0 pkt matched: addr=0 len=4 (63 matched so far) |
| 15530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 15530 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 15635 | **DUT** | IN  pkt #95 header: addr=1 len=40 -> channel 1 |
| 15665 | **DUT** | OUT ch1 pkt #20 start: addr=1 len=40 (receiver waited 2 cycle(s)) |
| 15980 | ch0 driver | ch0: packet consumed (response delay 0) |
| 16045 | **DUT** | IN  pkt #95 complete: addr=1 len=40 parity=ok forwarded, 42 bytes in 42 cycles (held 0) |
| 16045 | yapp monitor | RX pkt #95 on the input: addr=1 len=40 parity=good gap=16 |
| 16045 | reference | Packet forwarded: addr=1 len=40 -> channel 1 |
| 16050 | yapp driver | TX pkt #95 accepted by the DUT |
| 16050 | **test** | STAGE: burst 6/6 sent: addr0..3 3/8/3/1, bad parity 5, gap 0 6, length 1..63 |
| 16050 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 16070 | ch1 driver | ch1: packet consumed (response delay 2) |
| 16080 | hbus driver | Executed READ  addr=0x1000 data=0xac |
| 16085 | hbus monitor | Collected READ  addr=0x1000 data=0xac |
| 16110 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 16115 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 16135 | **DUT** | OUT ch1 pkt #20 done: 42 bytes in 48 cycles |
| 16135 | ch1 monitor | ch1 RX pkt #20: addr=1 len=40 parity=good |
| 16135 | scoreboard | ch1 pkt matched: addr=1 len=40 (64 matched so far) |
| 16140 | hbus driver | Executed READ  addr=0x1004 data=0x15 |
| 16145 | hbus monitor | Collected READ  addr=0x1004 data=0x15 |
| 16170 | hbus driver | Executed READ  addr=0x1005 data=0x14 |
| 16175 | hbus monitor | Collected READ  addr=0x1005 data=0x14 |
| 16200 | hbus driver | Executed READ  addr=0x1006 data=0x07 |
| 16205 | hbus monitor | Collected READ  addr=0x1006 data=0x07 |
| 16230 | hbus driver | Executed READ  addr=0x1009 data=0x13 |
| 16235 | hbus monitor | Collected READ  addr=0x1009 data=0x13 |
| 16250 | ch1 driver | ch1: packet consumed (response delay 5) |
| 16260 | hbus driver | Executed READ  addr=0x100a data=0x13 |
| 16265 | hbus monitor | Collected READ  addr=0x100a data=0x13 |
| 16290 | hbus driver | Executed READ  addr=0x100b data=0x1f |
| 16295 | hbus monitor | Collected READ  addr=0x100b data=0x1f |
| 16320 | hbus driver | Executed READ  addr=0x100d data=0x28 |
| 16325 | hbus monitor | Collected READ  addr=0x100d data=0x28 |
| 16350 | hbus driver | Executed READ  addr=0x1010 data=0xa1 |
| 16355 | hbus monitor | Collected READ  addr=0x1010 data=0xa1 |
| 16380 | hbus driver | Executed READ  addr=0x1011 data=0x55 |
| 16385 | hbus monitor | Collected READ  addr=0x1011 data=0x55 |
| 16410 | hbus driver | Executed READ  addr=0x1012 data=0x1c |
| 16415 | hbus monitor | Collected READ  addr=0x1012 data=0x1c |
| 16440 | hbus driver | Executed READ  addr=0x1013 data=0x24 |
| 16445 | hbus monitor | Collected READ  addr=0x1013 data=0x24 |
| 16470 | hbus driver | Executed READ  addr=0x1014 data=0x65 |
| 16475 | hbus monitor | Collected READ  addr=0x1014 data=0x65 |
| 16500 | hbus driver | Executed READ  addr=0x1015 data=0xe4 |
| 16505 | hbus monitor | Collected READ  addr=0x1015 data=0xe4 |
| 16530 | hbus driver | Executed READ  addr=0x1016 data=0x27 |
| 16535 | hbus monitor | Collected READ  addr=0x1016 data=0x27 |
| 16560 | hbus driver | Executed READ  addr=0x1017 data=0x33 |
| 16565 | hbus monitor | Collected READ  addr=0x1017 data=0x33 |
| 16590 | hbus driver | Executed READ  addr=0x1018 data=0xae |
| 16595 | hbus monitor | Collected READ  addr=0x1018 data=0xae |
| 16620 | hbus driver | Executed READ  addr=0x1019 data=0xdc |
| 16625 | hbus monitor | Collected READ  addr=0x1019 data=0xdc |
| 16650 | hbus driver | Executed READ  addr=0x101a data=0x70 |
| 16655 | hbus monitor | Collected READ  addr=0x101a data=0x70 |
| 16680 | hbus driver | Executed READ  addr=0x101b data=0xb8 |
| 16685 | hbus monitor | Collected READ  addr=0x101b data=0xb8 |
| 16710 | hbus driver | Executed READ  addr=0x101c data=0x5e |
| 16715 | hbus monitor | Collected READ  addr=0x101c data=0x5e |
| 16740 | hbus driver | Executed READ  addr=0x101d data=0x3d |
| 16745 | hbus monitor | Collected READ  addr=0x101d data=0x3d |
| 16770 | hbus driver | Executed READ  addr=0x101e data=0xa3 |
| 16775 | hbus monitor | Collected READ  addr=0x101e data=0xa3 |
| 16800 | hbus driver | Executed READ  addr=0x101f data=0xc9 |
| 16805 | hbus monitor | Collected READ  addr=0x101f data=0xc9 |
| 16830 | hbus driver | Executed READ  addr=0x1020 data=0xd7 |
| 16835 | hbus monitor | Collected READ  addr=0x1020 data=0xd7 |
| 16860 | hbus driver | Executed READ  addr=0x1021 data=0x7d |
| 16865 | hbus monitor | Collected READ  addr=0x1021 data=0x7d |
| 16890 | hbus driver | Executed READ  addr=0x1022 data=0x26 |
| 16895 | hbus monitor | Collected READ  addr=0x1022 data=0x26 |
| 16920 | hbus driver | Executed READ  addr=0x1023 data=0x87 |
| 16925 | hbus monitor | Collected READ  addr=0x1023 data=0x87 |
| 16950 | hbus driver | Executed READ  addr=0x1024 data=0xae |
| 16955 | hbus monitor | Collected READ  addr=0x1024 data=0xae |
| 16980 | hbus driver | Executed READ  addr=0x1025 data=0xfb |
| 16985 | hbus monitor | Collected READ  addr=0x1025 data=0xfb |
| 17010 | hbus driver | Executed READ  addr=0x1026 data=0xf4 |
| 17015 | hbus monitor | Collected READ  addr=0x1026 data=0xf4 |
| 17040 | hbus driver | Executed READ  addr=0x1027 data=0xa5 |
| 17045 | hbus monitor | Collected READ  addr=0x1027 data=0xa5 |
| 17070 | hbus driver | Executed READ  addr=0x1028 data=0x7a |
| 17075 | hbus monitor | Collected READ  addr=0x1028 data=0x7a |
| 17100 | hbus driver | Executed READ  addr=0x1029 data=0x61 |
| 17105 | hbus monitor | Collected READ  addr=0x1029 data=0x61 |
| 17130 | hbus driver | Executed READ  addr=0x102a data=0xf6 |
| 17135 | hbus monitor | Collected READ  addr=0x102a data=0xf6 |
| 17160 | hbus driver | Executed READ  addr=0x102b data=0xe6 |
| 17165 | hbus monitor | Collected READ  addr=0x102b data=0xe6 |
| 17190 | hbus driver | Executed READ  addr=0x102c data=0x9a |
| 17195 | hbus monitor | Collected READ  addr=0x102c data=0x9a |
| 17220 | hbus driver | Executed READ  addr=0x102d data=0xf6 |
| 17225 | hbus monitor | Collected READ  addr=0x102d data=0xf6 |
| 17250 | hbus driver | Executed READ  addr=0x102e data=0xf7 |
| 17255 | hbus monitor | Collected READ  addr=0x102e data=0xf7 |
| 17280 | hbus driver | Executed READ  addr=0x102f data=0xbc |
| 17285 | hbus monitor | Collected READ  addr=0x102f data=0xbc |
| 17310 | hbus driver | Executed READ  addr=0x1030 data=0x01 |
| 17315 | hbus monitor | Collected READ  addr=0x1030 data=0x01 |
| 17340 | hbus driver | Executed READ  addr=0x1031 data=0x64 |
| 17345 | hbus monitor | Collected READ  addr=0x1031 data=0x64 |
| 17370 | hbus driver | Executed READ  addr=0x1032 data=0x1b |
| 17375 | hbus monitor | Collected READ  addr=0x1032 data=0x1b |
| 17400 | hbus driver | Executed READ  addr=0x1033 data=0xfc |
| 17405 | hbus monitor | Collected READ  addr=0x1033 data=0xfc |
| 17430 | hbus driver | Executed READ  addr=0x1034 data=0x47 |
| 17435 | hbus monitor | Collected READ  addr=0x1034 data=0x47 |
| 17460 | hbus driver | Executed READ  addr=0x1035 data=0xc5 |
| 17465 | hbus monitor | Collected READ  addr=0x1035 data=0xc5 |
| 17490 | hbus driver | Executed READ  addr=0x1036 data=0x36 |
| 17495 | hbus monitor | Collected READ  addr=0x1036 data=0x36 |
| 17520 | hbus driver | Executed READ  addr=0x1037 data=0x15 |
| 17525 | hbus monitor | Collected READ  addr=0x1037 data=0x15 |
| 17550 | hbus driver | Executed READ  addr=0x1038 data=0xc5 |
| 17555 | hbus monitor | Collected READ  addr=0x1038 data=0xc5 |
| 17665 | **test** | STAGE: done: 95 packets (64 forwarded, 31 dropped), 4 storm burst(s), 64 scoreboard matches, 80 HBUS reads checked, 27 error pulses for 27 bad packets |
| 17865 | error checker | error pulse report: 27 bad packets, 27 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 17865 | ch0 monitor | Channel 0 report: 19 packets collected |
| 17865 | ch1 monitor | Channel 1 report: 20 packets collected |
| 17865 | ch2 monitor | Channel 2 report: 25 packets collected |
| 17865 | hbus monitor | HBUS report: 28 writes, 86 reads |
| 17865 | coverage | Coverage of the router configuration: 82.6% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 0 / 78 / 17 / 0 packets · length < max / = max / max+1 / > max+1 : 71 / 4 / 8 / 12 · forwarded good / bad : 46 / 18 · dropped address 3 good / bad : 8 / 4 · dropped oversized good / bad : 14 / 5 · counter enables none / mixed / all : 0 / 31 / 64 |
| 17865 | coverage | HBUS address coverage: 114 accesses sampled, coverage 40.3% |
| 17865 | coverage | HBUS register bits coverage: 12 writes to ctrl_reg/en_reg, coverage 95.5% |
| 17865 | coverage | HBUS counter value coverage: 9 counter reads sampled, coverage 55.6% |
| 17865 | coverage | HBUS yapp_mem data coverage: 32 accesses sampled, coverage 29.4% |
| 17865 | reference | --- Reference model report --- · forwarded to scoreboard : 64 · dropped (router disabled) : 0 · dropped (oversized) : 19 · dropped (address 3) : 12 · counters parity/oversized/addr0..3 : 21 / 20 / 19 19 31 7 |
| 17865 | reference | HBUS reads checked against the model: 80 (0 mismatches, 6 of memory bytes never written) |
| 17865 | scoreboard | --- Scoreboard report --- · packets received : 64 · packets matched : 64 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 17865 | yapp driver | YAPP driver report: 95 packets sent |
| 17865 | coverage | YAPP gap coverage: 94 gaps sampled, coverage 100.0% |
| 17865 | yapp monitor | YAPP monitor report: 95 packets collected, 27 with bad parity |
| 17865 | yapp monitor | YAPP gaps: 60 back to back, 11 of 1 cycle, 5 of 2, 18 longer |
| 17865 | coverage | YAPP packet coverage: 95 packets sampled, coverage 83.3% |
