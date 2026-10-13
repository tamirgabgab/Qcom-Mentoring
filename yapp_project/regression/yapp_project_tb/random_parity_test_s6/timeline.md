# random_parity_test  seed 6

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 27us · log `random_parity_test_s6.log`

Waves: `random_parity_test_s6.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s6%2Frandom_parity_test_s6.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **83** packet(s) (22 with bad parity); the input monitor saw 83.
- Router: **40** forwarded, **43** dropped (22 router disabled, 15 oversized, 6 illegal address 3).
- Packets out: ch0 **6**, ch1 **10**, ch2 **24**.
- Scoreboard: 40 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **5** time(s), longest hold 99 cycle(s).
- Error pulses: 17.
- HBUS: 15 write(s), 85 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_FAST, ch1 RX_NORMAL, ch2 RX_STALLY |
| 0 | random scenario: 83 packets in 4 bursts |
| 330 | burst 1/4: ctrl=0xc2 (maxpktsize 2) en=0xfe (router OFF, counter enables 1111111), 22 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 1180 | burst 1/4 sent: addr0..3 3/7/7/5, bad parity 5, gap 0 22, length 1..3 |
| 1350 | burst 2/4: ctrl=0x12 (maxpktsize 18) en=0xff (router on, counter enables 1111111), 21 packet(s) |
| 12100 | burst 2/4 sent: addr0..3 5/4/11/1, bad parity 6, gap 0 4, length 1..63 |
| 12280 | burst 3/4: ctrl=0x2f (maxpktsize 47) en=0x05 (router on, counter enables 0000010), 20 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 13110 | burst 3/4 sent: addr0..3 2/2/12/4, bad parity 4, gap 0 18, length 1..3 |
| 13290 | burst 4/4: ctrl=0x7f (maxpktsize 63) en=0x7f (router on, counter enables 0111111), 20 packet(s) |
| 24300 | burst 4/4 sent: addr0..3 2/6/10/2, bad parity 7, gap 0 9, length 1..63 |
| 24300 | final reads: every register and the stored packet, checked against the reference model |
| 26455 | done: 83 packets (40 forwarded, 43 dropped), 2 storm burst(s), 40 scoreboard matches, 84 HBUS reads checked, 17 error pulses for 17 bad packets |

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

1034 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_FAST, ch1 RX_NORMAL, ch2 RX_STALLY |
| 0 | **test** | STAGE: random scenario: 83 packets in 4 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0xc2 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0xc2 |
| 75 | reference | maxpktsize is now 2 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 95 | **DUT** | CONFIG router_en=0 maxpktsize=2 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 95 | reference | router_en is now 0 (en_reg 0xfe) |
| 120 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 170 | hbus driver | Executed WRITE addr=0x1124 data=0xdf |
| 175 | hbus monitor | Collected WRITE addr=0x1124 data=0xdf |
| 200 | hbus driver | Executed READ  addr=0x1124 data=0xdf |
| 205 | hbus monitor | Collected READ  addr=0x1124 data=0xdf |
| 220 | hbus driver | Executed WRITE addr=0x1171 data=0xa1 |
| 225 | hbus monitor | Collected WRITE addr=0x1171 data=0xa1 |
| 250 | hbus driver | Executed READ  addr=0x1171 data=0xa1 |
| 255 | hbus monitor | Collected READ  addr=0x1171 data=0xa1 |
| 270 | hbus driver | Executed WRITE addr=0x1167 data=0x2a |
| 275 | hbus monitor | Collected WRITE addr=0x1167 data=0x2a |
| 300 | hbus driver | Executed READ  addr=0x1167 data=0x2a |
| 305 | hbus monitor | Collected READ  addr=0x1167 data=0x2a |
| 330 | hbus driver | Executed READ  addr=0x1048 data=0x00 |
| 330 | **test** | STAGE: burst 1/4: ctrl=0xc2 (maxpktsize 2) en=0xfe (router OFF, counter enables 1111111), 22 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 330 | yapp driver | TX pkt #1: addr=0 len=1 parity=good delay=0 |
| 335 | hbus monitor | Collected READ  addr=0x1048 data=0x00 |
| 345 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> DROP (router disabled) |
| 365 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 365 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=good gap=29 |
| 365 | reference | Packet dropped: router disabled (addr=0 len=1) |
| 365 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (router disabled) |
| 370 | yapp driver | TX pkt #1 accepted by the DUT |
| 370 | yapp driver | TX pkt #2: addr=3 len=1 parity=good delay=0 |
| 375 | **DUT** | IN  pkt #2 header: addr=3 len=1 -> DROP (router disabled) |
| 395 | **DUT** | IN  pkt #2 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 395 | yapp monitor | RX pkt #2 on the input: addr=3 len=1 parity=good gap=0 |
| 395 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 395 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 400 | yapp driver | TX pkt #2 accepted by the DUT |
| 400 | yapp driver | TX pkt #3: addr=0 len=2 parity=good delay=0 |
| 405 | **DUT** | IN  pkt #3 header: addr=0 len=2 -> DROP (router disabled) |
| 435 | **DUT** | IN  pkt #3 complete: addr=0 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 435 | yapp monitor | RX pkt #3 on the input: addr=0 len=2 parity=good gap=0 |
| 435 | reference | Packet dropped: router disabled (addr=0 len=2) |
| 435 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (router disabled) |
| 440 | yapp driver | TX pkt #3 accepted by the DUT |
| 440 | yapp driver | TX pkt #4: addr=2 len=2 parity=good delay=0 |
| 445 | **DUT** | IN  pkt #4 header: addr=2 len=2 -> DROP (router disabled) |
| 475 | **DUT** | IN  pkt #4 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 475 | yapp monitor | RX pkt #4 on the input: addr=2 len=2 parity=good gap=0 |
| 475 | reference | Packet dropped: router disabled (addr=2 len=2) |
| 475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (router disabled) |
| 480 | yapp driver | TX pkt #4 accepted by the DUT |
| 480 | yapp driver | TX pkt #5: addr=1 len=1 parity=good delay=0 |
| 485 | **DUT** | IN  pkt #5 header: addr=1 len=1 -> DROP (router disabled) |
| 505 | **DUT** | IN  pkt #5 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 505 | yapp monitor | RX pkt #5 on the input: addr=1 len=1 parity=good gap=0 |
| 505 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 505 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 510 | yapp driver | TX pkt #5 accepted by the DUT |
| 510 | yapp driver | TX pkt #6: addr=1 len=3 parity=bad delay=0 |
| 515 | **DUT** | IN  pkt #6 header: addr=1 len=3 -> DROP (router disabled) |
| 555 | **DUT** | IN  pkt #6 complete: addr=1 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 555 | yapp monitor | RX pkt #6 on the input: addr=1 len=3 parity=bad gap=0 |
| 555 | reference | Packet dropped: router disabled (addr=1 len=3) |
| 555 | **DUT** | ROUTER DROPS PACKET addr=1 length=3 (router disabled) |
| 560 | yapp driver | TX pkt #6 accepted by the DUT |
| 560 | yapp driver | TX pkt #7: addr=2 len=2 parity=good delay=0 |
| 565 | **DUT** | IN  pkt #7 header: addr=2 len=2 -> DROP (router disabled) |
| 595 | **DUT** | IN  pkt #7 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 595 | yapp monitor | RX pkt #7 on the input: addr=2 len=2 parity=good gap=0 |
| 595 | reference | Packet dropped: router disabled (addr=2 len=2) |
| 595 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (router disabled) |
| 600 | yapp driver | TX pkt #7 accepted by the DUT |
| 600 | yapp driver | TX pkt #8: addr=3 len=1 parity=good delay=0 |
| 605 | **DUT** | IN  pkt #8 header: addr=3 len=1 -> DROP (router disabled) |
| 625 | **DUT** | IN  pkt #8 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 625 | yapp monitor | RX pkt #8 on the input: addr=3 len=1 parity=good gap=0 |
| 625 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 625 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 630 | yapp driver | TX pkt #8 accepted by the DUT |
| 630 | yapp driver | TX pkt #9: addr=2 len=3 parity=good delay=0 |
| 635 | **DUT** | IN  pkt #9 header: addr=2 len=3 -> DROP (router disabled) |
| 675 | **DUT** | IN  pkt #9 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 675 | yapp monitor | RX pkt #9 on the input: addr=2 len=3 parity=good gap=0 |
| 675 | reference | Packet dropped: router disabled (addr=2 len=3) |
| 675 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (router disabled) |
| 680 | yapp driver | TX pkt #9 accepted by the DUT |
| 680 | yapp driver | TX pkt #10: addr=3 len=1 parity=good delay=0 |
| 685 | **DUT** | IN  pkt #10 header: addr=3 len=1 -> DROP (router disabled) |
| 705 | **DUT** | IN  pkt #10 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 705 | yapp monitor | RX pkt #10 on the input: addr=3 len=1 parity=good gap=0 |
| 705 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 705 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 710 | yapp driver | TX pkt #10 accepted by the DUT |
| 710 | yapp driver | TX pkt #11: addr=1 len=1 parity=good delay=0 |
| 715 | **DUT** | IN  pkt #11 header: addr=1 len=1 -> DROP (router disabled) |
| 735 | **DUT** | IN  pkt #11 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 735 | yapp monitor | RX pkt #11 on the input: addr=1 len=1 parity=good gap=0 |
| 735 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 735 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 740 | yapp driver | TX pkt #11 accepted by the DUT |
| 740 | yapp driver | TX pkt #12: addr=3 len=1 parity=good delay=0 |
| 745 | **DUT** | IN  pkt #12 header: addr=3 len=1 -> DROP (router disabled) |
| 765 | **DUT** | IN  pkt #12 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 765 | yapp monitor | RX pkt #12 on the input: addr=3 len=1 parity=good gap=0 |
| 765 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 765 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 770 | yapp driver | TX pkt #12 accepted by the DUT |
| 770 | yapp driver | TX pkt #13: addr=3 len=1 parity=bad delay=0 |
| 775 | **DUT** | IN  pkt #13 header: addr=3 len=1 -> DROP (router disabled) |
| 795 | **DUT** | IN  pkt #13 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 795 | yapp monitor | RX pkt #13 on the input: addr=3 len=1 parity=bad gap=0 |
| 795 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 795 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 800 | yapp driver | TX pkt #13 accepted by the DUT |
| 800 | yapp driver | TX pkt #14: addr=1 len=1 parity=good delay=0 |
| 805 | **DUT** | IN  pkt #14 header: addr=1 len=1 -> DROP (router disabled) |
| 825 | **DUT** | IN  pkt #14 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 825 | yapp monitor | RX pkt #14 on the input: addr=1 len=1 parity=good gap=0 |
| 825 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 825 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 830 | yapp driver | TX pkt #14 accepted by the DUT |
| 830 | yapp driver | TX pkt #15: addr=2 len=3 parity=bad delay=0 |
| 835 | **DUT** | IN  pkt #15 header: addr=2 len=3 -> DROP (router disabled) |
| 875 | **DUT** | IN  pkt #15 complete: addr=2 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 875 | yapp monitor | RX pkt #15 on the input: addr=2 len=3 parity=bad gap=0 |
| 875 | reference | Packet dropped: router disabled (addr=2 len=3) |
| 875 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (router disabled) |
| 880 | yapp driver | TX pkt #15 accepted by the DUT |
| 880 | yapp driver | TX pkt #16: addr=1 len=3 parity=good delay=0 |
| 885 | **DUT** | IN  pkt #16 header: addr=1 len=3 -> DROP (router disabled) |
| 925 | **DUT** | IN  pkt #16 complete: addr=1 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 925 | yapp monitor | RX pkt #16 on the input: addr=1 len=3 parity=good gap=0 |
| 925 | reference | Packet dropped: router disabled (addr=1 len=3) |
| 925 | **DUT** | ROUTER DROPS PACKET addr=1 length=3 (router disabled) |
| 930 | yapp driver | TX pkt #16 accepted by the DUT |
| 930 | yapp driver | TX pkt #17: addr=2 len=3 parity=bad delay=0 |
| 935 | **DUT** | IN  pkt #17 header: addr=2 len=3 -> DROP (router disabled) |
| 975 | **DUT** | IN  pkt #17 complete: addr=2 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 975 | yapp monitor | RX pkt #17 on the input: addr=2 len=3 parity=bad gap=0 |
| 975 | reference | Packet dropped: router disabled (addr=2 len=3) |
| 975 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (router disabled) |
| 980 | yapp driver | TX pkt #17 accepted by the DUT |
| 980 | yapp driver | TX pkt #18: addr=1 len=3 parity=good delay=0 |
| 985 | **DUT** | IN  pkt #18 header: addr=1 len=3 -> DROP (router disabled) |
| 1025 | **DUT** | IN  pkt #18 complete: addr=1 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1025 | yapp monitor | RX pkt #18 on the input: addr=1 len=3 parity=good gap=0 |
| 1025 | reference | Packet dropped: router disabled (addr=1 len=3) |
| 1025 | **DUT** | ROUTER DROPS PACKET addr=1 length=3 (router disabled) |
| 1030 | yapp driver | TX pkt #18 accepted by the DUT |
| 1030 | yapp driver | TX pkt #19: addr=0 len=2 parity=good delay=0 |
| 1035 | **DUT** | IN  pkt #19 header: addr=0 len=2 -> DROP (router disabled) |
| 1065 | **DUT** | IN  pkt #19 complete: addr=0 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 1065 | yapp monitor | RX pkt #19 on the input: addr=0 len=2 parity=good gap=0 |
| 1065 | reference | Packet dropped: router disabled (addr=0 len=2) |
| 1065 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (router disabled) |
| 1070 | yapp driver | TX pkt #19 accepted by the DUT |
| 1070 | yapp driver | TX pkt #20: addr=2 len=1 parity=bad delay=0 |
| 1075 | **DUT** | IN  pkt #20 header: addr=2 len=1 -> DROP (router disabled) |
| 1095 | **DUT** | IN  pkt #20 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 1095 | yapp monitor | RX pkt #20 on the input: addr=2 len=1 parity=bad gap=0 |
| 1095 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 1095 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 1100 | yapp driver | TX pkt #20 accepted by the DUT |
| 1100 | yapp driver | TX pkt #21: addr=2 len=3 parity=good delay=0 |
| 1105 | **DUT** | IN  pkt #21 header: addr=2 len=3 -> DROP (router disabled) |
| 1145 | **DUT** | IN  pkt #21 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 1145 | yapp monitor | RX pkt #21 on the input: addr=2 len=3 parity=good gap=0 |
| 1145 | reference | Packet dropped: router disabled (addr=2 len=3) |
| 1145 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (router disabled) |
| 1150 | yapp driver | TX pkt #21 accepted by the DUT |
| 1150 | yapp driver | TX pkt #22: addr=1 len=1 parity=good delay=0 |
| 1155 | **DUT** | IN  pkt #22 header: addr=1 len=1 -> DROP (router disabled) |
| 1175 | **DUT** | IN  pkt #22 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 1175 | yapp monitor | RX pkt #22 on the input: addr=1 len=1 parity=good gap=0 |
| 1175 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 1175 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 1180 | yapp driver | TX pkt #22 accepted by the DUT |
| 1180 | **test** | STAGE: burst 1/4 sent: addr0..3 3/7/7/5, bad parity 5, gap 0 22, length 1..3 |
| 1200 | hbus driver | Executed WRITE addr=0x1000 data=0x12 |
| 1205 | **DUT** | CONFIG router_en=0 maxpktsize=18 |
| 1205 | hbus monitor | Collected WRITE addr=0x1000 data=0x12 |
| 1205 | reference | maxpktsize is now 18 |
| 1220 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 1225 | **DUT** | CONFIG router_en=1 maxpktsize=18 |
| 1225 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 1225 | reference | router_en is now 1 (en_reg 0xff) |
| 1250 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 1255 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 1270 | hbus driver | Executed WRITE addr=0x1163 data=0xa2 |
| 1275 | hbus monitor | Collected WRITE addr=0x1163 data=0xa2 |
| 1300 | hbus driver | Executed READ  addr=0x1163 data=0xa2 |
| 1305 | hbus monitor | Collected READ  addr=0x1163 data=0xa2 |
| 1320 | hbus driver | Executed WRITE addr=0x114a data=0x3f |
| 1325 | hbus monitor | Collected WRITE addr=0x114a data=0x3f |
| 1350 | hbus driver | Executed READ  addr=0x114a data=0x3f |
| 1350 | **test** | STAGE: burst 2/4: ctrl=0x12 (maxpktsize 18) en=0xff (router on, counter enables 1111111), 21 packet(s) |
| 1350 | yapp driver | TX pkt #23: addr=0 len=63 parity=good delay=20 |
| 1355 | hbus monitor | Collected READ  addr=0x114a data=0x3f |
| 1565 | **DUT** | IN  pkt #23 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 2205 | **DUT** | IN  pkt #23 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2205 | yapp monitor | RX pkt #23 on the input: addr=0 len=63 parity=good gap=38 |
| 2205 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=0) |
| 2205 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 2210 | yapp driver | TX pkt #23 accepted by the DUT |
| 2210 | yapp driver | TX pkt #24: addr=2 len=63 parity=good delay=1 |
| 2225 | **DUT** | IN  pkt #24 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 2865 | **DUT** | IN  pkt #24 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2865 | yapp monitor | RX pkt #24 on the input: addr=2 len=63 parity=good gap=1 |
| 2865 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=2) |
| 2865 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 2870 | yapp driver | TX pkt #24 accepted by the DUT |
| 2870 | yapp driver | TX pkt #25: addr=0 len=32 parity=good delay=2 |
| 2895 | **DUT** | IN  pkt #25 header: addr=0 len=32 -> DROP (oversized: len 32 > maxpktsize 18) |
| 3225 | **DUT** | IN  pkt #25 complete: addr=0 len=32 parity=ok dropped, 34 bytes in 34 cycles (held 0) |
| 3225 | yapp monitor | RX pkt #25 on the input: addr=0 len=32 parity=good gap=2 |
| 3225 | reference | Packet dropped: length 32 > maxpktsize 18 (addr=0) |
| 3225 | **DUT** | ROUTER DROPS PACKET addr=0 length=32 (length > maxpktsize) |
| 3230 | yapp driver | TX pkt #25 accepted by the DUT |
| 3230 | yapp driver | TX pkt #26: addr=2 len=46 parity=bad delay=1 |
| 3245 | **DUT** | IN  pkt #26 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 18) |
| 3715 | **DUT** | IN  pkt #26 complete: addr=2 len=46 parity=BAD dropped, 48 bytes in 48 cycles (held 0) |
| 3715 | yapp monitor | RX pkt #26 on the input: addr=2 len=46 parity=bad gap=1 |
| 3715 | reference | Packet dropped: length 46 > maxpktsize 18 (addr=2) |
| 3715 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 3720 | yapp driver | TX pkt #26 accepted by the DUT |
| 3720 | yapp driver | TX pkt #27: addr=3 len=25 parity=bad delay=0 |
| 3725 | **DUT** | IN  pkt #27 header: addr=3 len=25 -> DROP (oversized: len 25 > maxpktsize 18) |
| 3770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 3770 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 3985 | **DUT** | IN  pkt #27 complete: addr=3 len=25 parity=BAD dropped, 27 bytes in 27 cycles (held 0) |
| 3985 | yapp monitor | RX pkt #27 on the input: addr=3 len=25 parity=bad gap=0 |
| 3985 | reference | Packet dropped: illegal address 3 (len=25) |
| 3985 | **DUT** | ROUTER DROPS PACKET addr=3 length=25 (    illegal address) |
| 3990 | yapp driver | TX pkt #27 accepted by the DUT |
| 3990 | yapp driver | TX pkt #28: addr=2 len=17 parity=good delay=6 |
| 4055 | **DUT** | IN  pkt #28 header: addr=2 len=17 -> channel 2 |
| 4090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 4090 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 4145 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=17 (receiver waited 8 cycle(s)) |
| 4235 | **DUT** | IN  pkt #28 complete: addr=2 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 4235 | yapp monitor | RX pkt #28 on the input: addr=2 len=17 parity=good gap=6 |
| 4235 | reference | Packet forwarded: addr=2 len=17 -> channel 2 |
| 4240 | yapp driver | TX pkt #28 accepted by the DUT |
| 4240 | yapp driver | TX pkt #29: addr=2 len=63 parity=good delay=6 |
| 4305 | **DUT** | IN  pkt #29 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 4320 | ch2 driver | ch2: packet consumed (response delay 8) |
| 4405 | **DUT** | OUT ch2 pkt #1 done: 19 bytes in 27 cycles |
| 4405 | ch2 monitor | ch2 RX pkt #1: addr=2 len=17 parity=good |
| 4405 | scoreboard | ch2 pkt matched: addr=2 len=17 (1 matched so far) |
| 4550 | ch2 driver | ch2: packet consumed (response delay 7) |
| 4945 | **DUT** | IN  pkt #29 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4945 | yapp monitor | RX pkt #29 on the input: addr=2 len=63 parity=good gap=6 |
| 4945 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=2) |
| 4945 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4950 | yapp driver | TX pkt #29 accepted by the DUT |
| 4950 | yapp driver | TX pkt #30: addr=0 len=46 parity=good delay=17 |
| 5125 | **DUT** | IN  pkt #30 header: addr=0 len=46 -> DROP (oversized: len 46 > maxpktsize 18) |
| 5595 | **DUT** | IN  pkt #30 complete: addr=0 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 5595 | yapp monitor | RX pkt #30 on the input: addr=0 len=46 parity=good gap=17 |
| 5595 | reference | Packet dropped: length 46 > maxpktsize 18 (addr=0) |
| 5595 | **DUT** | ROUTER DROPS PACKET addr=0 length=46 (length > maxpktsize) |
| 5600 | yapp driver | TX pkt #30 accepted by the DUT |
| 5600 | yapp driver | TX pkt #31: addr=1 len=63 parity=bad delay=18 |
| 5785 | **DUT** | IN  pkt #31 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 6425 | **DUT** | IN  pkt #31 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 6425 | yapp monitor | RX pkt #31 on the input: addr=1 len=63 parity=bad gap=18 |
| 6425 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=1) |
| 6425 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 6430 | yapp driver | TX pkt #31 accepted by the DUT |
| 6430 | yapp driver | TX pkt #32: addr=0 len=18 parity=good delay=3 |
| 6465 | **DUT** | IN  pkt #32 header: addr=0 len=18 -> channel 0 |
| 6470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 6470 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 6475 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=18 (receiver waited 0 cycle(s)) |
| 6655 | **DUT** | IN  pkt #32 complete: addr=0 len=18 parity=ok forwarded, 20 bytes in 20 cycles (held 0) |
| 6655 | yapp monitor | RX pkt #32 on the input: addr=0 len=18 parity=good gap=3 |
| 6655 | reference | Packet forwarded: addr=0 len=18 -> channel 0 |
| 6660 | ch0 driver | ch0: packet consumed (response delay 0) |
| 6660 | yapp driver | TX pkt #32 accepted by the DUT |
| 6660 | yapp driver | TX pkt #33: addr=2 len=46 parity=good delay=2 |
| 6675 | **DUT** | OUT ch0 pkt #1 done: 20 bytes in 21 cycles |
| 6675 | ch0 monitor | ch0 RX pkt #1: addr=0 len=18 parity=good |
| 6675 | scoreboard | ch0 pkt matched: addr=0 len=18 (2 matched so far) |
| 6685 | **DUT** | IN  pkt #33 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 18) |
| 6990 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7155 | **DUT** | IN  pkt #33 complete: addr=2 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 7155 | yapp monitor | RX pkt #33 on the input: addr=2 len=46 parity=good gap=2 |
| 7155 | reference | Packet dropped: length 46 > maxpktsize 18 (addr=2) |
| 7155 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 7160 | yapp driver | TX pkt #33 accepted by the DUT |
| 7160 | yapp driver | TX pkt #34: addr=1 len=1 parity=good delay=0 |
| 7165 | **DUT** | IN  pkt #34 header: addr=1 len=1 -> channel 1 |
| 7185 | **DUT** | IN  pkt #34 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7185 | yapp monitor | RX pkt #34 on the input: addr=1 len=1 parity=good gap=0 |
| 7185 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 7190 | yapp driver | TX pkt #34 accepted by the DUT |
| 7190 | yapp driver | TX pkt #35: addr=2 len=63 parity=bad delay=7 |
| 7195 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=1 (receiver waited 2 cycle(s)) |
| 7210 | ch1 driver | ch1: packet consumed (response delay 2) |
| 7265 | **DUT** | IN  pkt #35 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 7305 | **DUT** | OUT ch1 pkt #1 done: 3 bytes in 12 cycles |
| 7305 | ch1 monitor | ch1 RX pkt #1: addr=1 len=1 parity=good |
| 7305 | scoreboard | ch1 pkt matched: addr=1 len=1 (3 matched so far) |
| 7450 | ch1 driver | ch1: packet consumed (response delay 8) |
| 7905 | **DUT** | IN  pkt #35 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 7905 | yapp monitor | RX pkt #35 on the input: addr=2 len=63 parity=bad gap=7 |
| 7905 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=2) |
| 7905 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 7910 | yapp driver | TX pkt #35 accepted by the DUT |
| 7910 | yapp driver | TX pkt #36: addr=2 len=31 parity=good delay=15 |
| 7930 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 7930 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 8065 | **DUT** | IN  pkt #36 header: addr=2 len=31 -> DROP (oversized: len 31 > maxpktsize 18) |
| 8385 | **DUT** | IN  pkt #36 complete: addr=2 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 8385 | yapp monitor | RX pkt #36 on the input: addr=2 len=31 parity=good gap=15 |
| 8385 | reference | Packet dropped: length 31 > maxpktsize 18 (addr=2) |
| 8385 | **DUT** | ROUTER DROPS PACKET addr=2 length=31 (length > maxpktsize) |
| 8390 | yapp driver | TX pkt #36 accepted by the DUT |
| 8390 | yapp driver | TX pkt #37: addr=2 len=15 parity=good delay=1 |
| 8405 | **DUT** | IN  pkt #37 header: addr=2 len=15 -> channel 2 |
| 8565 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x3e held (pkt #37) |
| 9545 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=15 (receiver waited 113 cycle(s)) |
| 9555 | **DUT** | IN  pkt #37 complete: addr=2 len=15 parity=ok forwarded, 17 bytes in 116 cycles (held 99) |
| 9555 | **DUT** | SUSPEND released after 99 cycle(s) |
| 9555 | yapp monitor | RX pkt #37 on the input: addr=2 len=15 parity=good gap=1 |
| 9555 | reference | Packet forwarded: addr=2 len=15 -> channel 2 |
| 9560 | yapp driver | TX pkt #37 accepted by the DUT |
| 9560 | yapp driver | TX pkt #38: addr=2 len=31 parity=bad delay=0 |
| 9565 | **DUT** | IN  pkt #38 header: addr=2 len=31 -> DROP (oversized: len 31 > maxpktsize 18) |
| 9700 | ch2 driver | ch2: packet consumed (response delay 113) |
| 9795 | **DUT** | OUT ch2 pkt #2 done: 17 bytes in 26 cycles |
| 9795 | ch2 monitor | ch2 RX pkt #2: addr=2 len=15 parity=good |
| 9795 | scoreboard | ch2 pkt matched: addr=2 len=15 (4 matched so far) |
| 9885 | **DUT** | IN  pkt #38 complete: addr=2 len=31 parity=BAD dropped, 33 bytes in 33 cycles (held 0) |
| 9885 | yapp monitor | RX pkt #38 on the input: addr=2 len=31 parity=bad gap=0 |
| 9885 | reference | Packet dropped: length 31 > maxpktsize 18 (addr=2) |
| 9885 | **DUT** | ROUTER DROPS PACKET addr=2 length=31 (length > maxpktsize) |
| 9890 | yapp driver | TX pkt #38 accepted by the DUT |
| 9890 | yapp driver | TX pkt #39: addr=0 len=1 parity=good delay=5 |
| 9945 | **DUT** | IN  pkt #39 header: addr=0 len=1 -> channel 0 |
| 9950 | ch2 driver | ch2: packet consumed (response delay 8) |
| 9955 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9965 | **DUT** | IN  pkt #39 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9965 | yapp monitor | RX pkt #39 on the input: addr=0 len=1 parity=good gap=5 |
| 9965 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 9970 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 9970 | ch0 driver | ch0: packet consumed (response delay 0) |
| 9970 | yapp driver | TX pkt #39 accepted by the DUT |
| 9970 | yapp driver | TX pkt #40: addr=2 len=63 parity=good delay=5 |
| 9985 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 4 cycles |
| 9985 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=good |
| 9985 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 10025 | **DUT** | IN  pkt #40 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 18) |
| 10270 | ch0 driver | ch0: packet consumed (response delay 0) |
| 10665 | **DUT** | IN  pkt #40 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10665 | yapp monitor | RX pkt #40 on the input: addr=2 len=63 parity=good gap=5 |
| 10665 | reference | Packet dropped: length 63 > maxpktsize 18 (addr=2) |
| 10665 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10670 | yapp driver | TX pkt #40 accepted by the DUT |
| 10670 | yapp driver | TX pkt #41: addr=1 len=18 parity=good delay=18 |
| 10855 | **DUT** | IN  pkt #41 header: addr=1 len=18 -> channel 1 |
| 10865 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=18 (receiver waited 0 cycle(s)) |
| 11045 | **DUT** | IN  pkt #41 complete: addr=1 len=18 parity=ok forwarded, 20 bytes in 20 cycles (held 0) |
| 11045 | yapp monitor | RX pkt #41 on the input: addr=1 len=18 parity=good gap=18 |
| 11045 | reference | Packet forwarded: addr=1 len=18 -> channel 1 |
| 11050 | ch1 driver | ch1: packet consumed (response delay 0) |
| 11050 | yapp driver | TX pkt #41 accepted by the DUT |
| 11050 | yapp driver | TX pkt #42: addr=1 len=53 parity=bad delay=0 |
| 11055 | **DUT** | IN  pkt #42 header: addr=1 len=53 -> DROP (oversized: len 53 > maxpktsize 18) |
| 11155 | **DUT** | OUT ch1 pkt #2 done: 20 bytes in 30 cycles |
| 11155 | ch1 monitor | ch1 RX pkt #2: addr=1 len=18 parity=good |
| 11155 | scoreboard | ch1 pkt matched: addr=1 len=18 (6 matched so far) |
| 11595 | **DUT** | IN  pkt #42 complete: addr=1 len=53 parity=BAD dropped, 55 bytes in 55 cycles (held 0) |
| 11595 | yapp monitor | RX pkt #42 on the input: addr=1 len=53 parity=bad gap=0 |
| 11595 | reference | Packet dropped: length 53 > maxpktsize 18 (addr=1) |
| 11595 | **DUT** | ROUTER DROPS PACKET addr=1 length=53 (length > maxpktsize) |
| 11600 | yapp driver | TX pkt #42 accepted by the DUT |
| 11600 | yapp driver | TX pkt #43: addr=2 len=45 parity=good delay=3 |
| 11630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 11630 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 11635 | **DUT** | IN  pkt #43 header: addr=2 len=45 -> DROP (oversized: len 45 > maxpktsize 18) |
| 11670 | ch1 driver | ch1: packet consumed (response delay 9) |
| 12095 | **DUT** | IN  pkt #43 complete: addr=2 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 12095 | yapp monitor | RX pkt #43 on the input: addr=2 len=45 parity=good gap=3 |
| 12095 | reference | Packet dropped: length 45 > maxpktsize 18 (addr=2) |
| 12095 | **DUT** | ROUTER DROPS PACKET addr=2 length=45 (length > maxpktsize) |
| 12100 | yapp driver | TX pkt #43 accepted by the DUT |
| 12100 | **test** | STAGE: burst 2/4 sent: addr0..3 5/4/11/1, bad parity 6, gap 0 4, length 1..63 |
| 12120 | hbus driver | Executed WRITE addr=0x1000 data=0x2f |
| 12125 | **DUT** | CONFIG router_en=1 maxpktsize=47 |
| 12125 | hbus monitor | Collected WRITE addr=0x1000 data=0x2f |
| 12125 | reference | maxpktsize is now 47 |
| 12140 | hbus driver | Executed WRITE addr=0x1001 data=0x05 |
| 12145 | hbus monitor | Collected WRITE addr=0x1001 data=0x05 |
| 12145 | reference | router_en is now 1 (en_reg 0x05) |
| 12170 | hbus driver | Executed READ  addr=0x1011 data=0x29 |
| 12175 | hbus monitor | Collected READ  addr=0x1011 data=0x29 |
| 12200 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 12205 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12220 | hbus driver | Executed WRITE addr=0x11f2 data=0x0f |
| 12225 | hbus monitor | Collected WRITE addr=0x11f2 data=0x0f |
| 12250 | hbus driver | Executed READ  addr=0x11f2 data=0x0f |
| 12255 | hbus monitor | Collected READ  addr=0x11f2 data=0x0f |
| 12280 | hbus driver | Executed READ  addr=0x103f data=0xbd |
| 12280 | **test** | STAGE: burst 3/4: ctrl=0x2f (maxpktsize 47) en=0x05 (router on, counter enables 0000010), 20 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 12280 | yapp driver | TX pkt #44: addr=2 len=2 parity=good delay=0 |
| 12285 | hbus monitor | Collected READ  addr=0x103f data=0xbd |
| 12295 | **DUT** | IN  pkt #44 header: addr=2 len=2 -> channel 2 |
| 12325 | **DUT** | IN  pkt #44 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 12325 | yapp monitor | RX pkt #44 on the input: addr=2 len=2 parity=good gap=19 |
| 12325 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 12330 | yapp driver | TX pkt #44 accepted by the DUT |
| 12330 | yapp driver | TX pkt #45: addr=3 len=3 parity=good delay=0 |
| 12335 | **DUT** | IN  pkt #45 header: addr=3 len=3 -> DROP (illegal address 3) |
| 12375 | **DUT** | IN  pkt #45 complete: addr=3 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 12375 | yapp monitor | RX pkt #45 on the input: addr=3 len=3 parity=good gap=0 |
| 12375 | reference | Packet dropped: illegal address 3 (len=3) |
| 12375 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 12380 | yapp driver | TX pkt #45 accepted by the DUT |
| 12380 | yapp driver | TX pkt #46: addr=2 len=1 parity=good delay=0 |
| 12385 | **DUT** | IN  pkt #46 header: addr=2 len=1 -> channel 2 |
| 12405 | **DUT** | IN  pkt #46 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12405 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=2 (receiver waited 10 cycle(s)) |
| 12405 | yapp monitor | RX pkt #46 on the input: addr=2 len=1 parity=good gap=0 |
| 12405 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 12410 | yapp driver | TX pkt #46 accepted by the DUT |
| 12410 | yapp driver | TX pkt #47: addr=2 len=3 parity=good delay=0 |
| 12415 | **DUT** | IN  pkt #47 header: addr=2 len=3 -> channel 2 |
| 12430 | ch2 driver | ch2: packet consumed (response delay 10) |
| 12455 | **DUT** | IN  pkt #47 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 12455 | yapp monitor | RX pkt #47 on the input: addr=2 len=3 parity=good gap=0 |
| 12455 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 12460 | yapp driver | TX pkt #47 accepted by the DUT |
| 12460 | yapp driver | TX pkt #48: addr=3 len=2 parity=good delay=0 |
| 12465 | **DUT** | IN  pkt #48 header: addr=3 len=2 -> DROP (illegal address 3) |
| 12495 | **DUT** | IN  pkt #48 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 12495 | yapp monitor | RX pkt #48 on the input: addr=3 len=2 parity=good gap=0 |
| 12495 | reference | Packet dropped: illegal address 3 (len=2) |
| 12495 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 12500 | yapp driver | TX pkt #48 accepted by the DUT |
| 12500 | yapp driver | TX pkt #49: addr=2 len=1 parity=good delay=0 |
| 12505 | **DUT** | IN  pkt #49 header: addr=2 len=1 -> channel 2 |
| 12515 | **DUT** | OUT ch2 pkt #3 done: 4 bytes in 12 cycles |
| 12515 | ch2 monitor | ch2 RX pkt #3: addr=2 len=2 parity=good |
| 12515 | scoreboard | ch2 pkt matched: addr=2 len=2 (7 matched so far) |
| 12525 | **DUT** | IN  pkt #49 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12525 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 12525 | yapp monitor | RX pkt #49 on the input: addr=2 len=1 parity=good gap=0 |
| 12525 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 12530 | yapp driver | TX pkt #49 accepted by the DUT |
| 12530 | yapp driver | TX pkt #50: addr=0 len=1 parity=good delay=1 |
| 12545 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> channel 0 |
| 12545 | **DUT** | OUT ch2 pkt #4 done: 3 bytes in 3 cycles |
| 12545 | ch2 monitor | ch2 RX pkt #4: addr=2 len=1 parity=good |
| 12545 | scoreboard | ch2 pkt matched: addr=2 len=1 (8 matched so far) |
| 12555 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12555 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 12565 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12565 | yapp monitor | RX pkt #50 on the input: addr=0 len=1 parity=good gap=1 |
| 12565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12570 | ch0 driver | ch0: packet consumed (response delay 0) |
| 12570 | yapp driver | TX pkt #50 accepted by the DUT |
| 12570 | yapp driver | TX pkt #51: addr=3 len=1 parity=good delay=0 |
| 12575 | **DUT** | IN  pkt #51 header: addr=3 len=1 -> DROP (illegal address 3) |
| 12585 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 4 cycles |
| 12585 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=good |
| 12585 | scoreboard | ch0 pkt matched: addr=0 len=1 (9 matched so far) |
| 12595 | **DUT** | IN  pkt #51 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 12595 | **DUT** | OUT ch2 pkt #5 done: 5 bytes in 5 cycles |
| 12595 | ch2 monitor | ch2 RX pkt #5: addr=2 len=3 parity=good |
| 12595 | scoreboard | ch2 pkt matched: addr=2 len=3 (10 matched so far) |
| 12595 | yapp monitor | RX pkt #51 on the input: addr=3 len=1 parity=good gap=0 |
| 12595 | reference | Packet dropped: illegal address 3 (len=1) |
| 12595 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 12600 | yapp driver | TX pkt #51 accepted by the DUT |
| 12600 | yapp driver | TX pkt #52: addr=2 len=1 parity=bad delay=0 |
| 12605 | **DUT** | IN  pkt #52 header: addr=2 len=1 -> channel 2 |
| 12605 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 12625 | **DUT** | IN  pkt #52 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 12625 | **DUT** | OUT ch2 pkt #6 done: 3 bytes in 3 cycles |
| 12625 | ch2 monitor | ch2 RX pkt #6: addr=2 len=1 parity=good |
| 12625 | scoreboard | ch2 pkt matched: addr=2 len=1 (11 matched so far) |
| 12625 | yapp monitor | RX pkt #52 on the input: addr=2 len=1 parity=bad gap=0 |
| 12625 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 12630 | yapp driver | TX pkt #52 accepted by the DUT |
| 12630 | yapp driver | TX pkt #53: addr=2 len=3 parity=good delay=0 |
| 12635 | **DUT** | IN  pkt #53 header: addr=2 len=3 -> channel 2 |
| 12635 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 12655 | **DUT** | OUT ch2 pkt #7 done: 3 bytes in 3 cycles |
| 12655 | ch2 monitor | ch2 RX pkt #7: addr=2 len=1 parity=bad |
| 12655 | scoreboard | ch2 pkt matched: addr=2 len=1 (12 matched so far) |
| 12665 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 12675 | **DUT** | IN  pkt #53 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 12675 | yapp monitor | RX pkt #53 on the input: addr=2 len=3 parity=good gap=0 |
| 12675 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 12680 | yapp driver | TX pkt #53 accepted by the DUT |
| 12680 | yapp driver | TX pkt #54: addr=2 len=1 parity=good delay=0 |
| 12685 | **DUT** | IN  pkt #54 header: addr=2 len=1 -> channel 2 |
| 12705 | **DUT** | IN  pkt #54 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12705 | **DUT** | OUT ch2 pkt #8 done: 5 bytes in 5 cycles |
| 12705 | ch2 monitor | ch2 RX pkt #8: addr=2 len=3 parity=good |
| 12705 | scoreboard | ch2 pkt matched: addr=2 len=3 (13 matched so far) |
| 12705 | yapp monitor | RX pkt #54 on the input: addr=2 len=1 parity=good gap=0 |
| 12705 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 12710 | yapp driver | TX pkt #54 accepted by the DUT |
| 12710 | yapp driver | TX pkt #55: addr=2 len=3 parity=bad delay=0 |
| 12715 | **DUT** | IN  pkt #55 header: addr=2 len=3 -> channel 2 |
| 12715 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 12730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 12730 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 12735 | **DUT** | OUT ch2 pkt #9 done: 3 bytes in 3 cycles |
| 12735 | ch2 monitor | ch2 RX pkt #9: addr=2 len=1 parity=good |
| 12735 | scoreboard | ch2 pkt matched: addr=2 len=1 (14 matched so far) |
| 12745 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 12755 | **DUT** | IN  pkt #55 complete: addr=2 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 12755 | yapp monitor | RX pkt #55 on the input: addr=2 len=3 parity=bad gap=0 |
| 12755 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 12760 | yapp driver | TX pkt #55 accepted by the DUT |
| 12760 | yapp driver | TX pkt #56: addr=2 len=2 parity=good delay=0 |
| 12765 | **DUT** | IN  pkt #56 header: addr=2 len=2 -> channel 2 |
| 12785 | **DUT** | OUT ch2 pkt #10 done: 5 bytes in 5 cycles |
| 12785 | ch2 monitor | ch2 RX pkt #10: addr=2 len=3 parity=bad |
| 12785 | scoreboard | ch2 pkt matched: addr=2 len=3 (15 matched so far) |
| 12795 | **DUT** | IN  pkt #56 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 12795 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 12795 | yapp monitor | RX pkt #56 on the input: addr=2 len=2 parity=good gap=0 |
| 12795 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 12800 | yapp driver | TX pkt #56 accepted by the DUT |
| 12800 | yapp driver | TX pkt #57: addr=2 len=2 parity=good delay=0 |
| 12805 | **DUT** | IN  pkt #57 header: addr=2 len=2 -> channel 2 |
| 12825 | **DUT** | OUT ch2 pkt #11 done: 4 bytes in 4 cycles |
| 12825 | ch2 monitor | ch2 RX pkt #11: addr=2 len=2 parity=good |
| 12825 | scoreboard | ch2 pkt matched: addr=2 len=2 (16 matched so far) |
| 12830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 12830 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 12835 | **DUT** | IN  pkt #57 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 12835 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 12835 | yapp monitor | RX pkt #57 on the input: addr=2 len=2 parity=good gap=0 |
| 12835 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 12840 | yapp driver | TX pkt #57 accepted by the DUT |
| 12840 | yapp driver | TX pkt #58: addr=3 len=3 parity=good delay=0 |
| 12845 | **DUT** | IN  pkt #58 header: addr=3 len=3 -> DROP (illegal address 3) |
| 12865 | **DUT** | OUT ch2 pkt #12 done: 4 bytes in 4 cycles |
| 12865 | ch2 monitor | ch2 RX pkt #12: addr=2 len=2 parity=good |
| 12865 | scoreboard | ch2 pkt matched: addr=2 len=2 (17 matched so far) |
| 12885 | **DUT** | IN  pkt #58 complete: addr=3 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 12885 | yapp monitor | RX pkt #58 on the input: addr=3 len=3 parity=good gap=0 |
| 12885 | reference | Packet dropped: illegal address 3 (len=3) |
| 12885 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 12890 | yapp driver | TX pkt #58 accepted by the DUT |
| 12890 | yapp driver | TX pkt #59: addr=0 len=2 parity=good delay=0 |
| 12895 | **DUT** | IN  pkt #59 header: addr=0 len=2 -> channel 0 |
| 12905 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 12925 | **DUT** | IN  pkt #59 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 12925 | yapp monitor | RX pkt #59 on the input: addr=0 len=2 parity=good gap=0 |
| 12925 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 12930 | yapp driver | TX pkt #59 accepted by the DUT |
| 12930 | yapp driver | TX pkt #60: addr=1 len=1 parity=good delay=3 |
| 12935 | **DUT** | OUT ch0 pkt #4 done: 4 bytes in 4 cycles |
| 12935 | ch0 monitor | ch0 RX pkt #4: addr=0 len=2 parity=good |
| 12935 | scoreboard | ch0 pkt matched: addr=0 len=2 (18 matched so far) |
| 12965 | **DUT** | IN  pkt #60 header: addr=1 len=1 -> channel 1 |
| 12985 | **DUT** | IN  pkt #60 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12985 | yapp monitor | RX pkt #60 on the input: addr=1 len=1 parity=good gap=3 |
| 12985 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 12990 | yapp driver | TX pkt #60 accepted by the DUT |
| 12990 | yapp driver | TX pkt #61: addr=1 len=1 parity=bad delay=0 |
| 12995 | **DUT** | IN  pkt #61 header: addr=1 len=1 -> channel 1 |
| 13005 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 3 cycle(s)) |
| 13010 | ch2 driver | ch2: packet consumed (response delay 7) |
| 13015 | **DUT** | IN  pkt #61 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 13015 | yapp monitor | RX pkt #61 on the input: addr=1 len=1 parity=bad gap=0 |
| 13015 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 13020 | ch1 driver | ch1: packet consumed (response delay 3) |
| 13020 | yapp driver | TX pkt #61 accepted by the DUT |
| 13020 | yapp driver | TX pkt #62: addr=2 len=3 parity=bad delay=0 |
| 13025 | **DUT** | IN  pkt #62 header: addr=2 len=3 -> channel 2 |
| 13030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 13030 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 13065 | **DUT** | IN  pkt #62 complete: addr=2 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 13065 | yapp monitor | RX pkt #62 on the input: addr=2 len=3 parity=bad gap=0 |
| 13065 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 13070 | yapp driver | TX pkt #62 accepted by the DUT |
| 13070 | yapp driver | TX pkt #63: addr=2 len=2 parity=good delay=0 |
| 13075 | **DUT** | IN  pkt #63 header: addr=2 len=2 -> channel 2 |
| 13105 | **DUT** | IN  pkt #63 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 13105 | yapp monitor | RX pkt #63 on the input: addr=2 len=2 parity=good gap=0 |
| 13105 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 13110 | yapp driver | TX pkt #63 accepted by the DUT |
| 13110 | **test** | STAGE: burst 3/4 sent: addr0..3 2/2/12/4, bad parity 4, gap 0 18, length 1..3 |
| 13125 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 13 cycles |
| 13125 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=3 (receiver waited 9 cycle(s)) |
| 13125 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=good |
| 13125 | scoreboard | ch1 pkt matched: addr=1 len=1 (19 matched so far) |
| 13130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 13130 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 13130 | hbus driver | Executed WRITE addr=0x1000 data=0x7f |
| 13135 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 13135 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 13135 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 13135 | reference | maxpktsize is now 63 |
| 13140 | ch0 driver | ch0: packet consumed (response delay 0) |
| 13150 | hbus driver | Executed WRITE addr=0x1001 data=0x7f |
| 13155 | **DUT** | OUT ch1 pkt #4 done: 3 bytes in 3 cycles |
| 13155 | ch1 monitor | ch1 RX pkt #4: addr=1 len=1 parity=bad |
| 13155 | scoreboard | ch1 pkt matched: addr=1 len=1 (20 matched so far) |
| 13155 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 13155 | reference | router_en is now 1 (en_reg 0x7f) |
| 13160 | ch2 driver | ch2: packet consumed (response delay 9) |
| 13180 | hbus driver | Executed READ  addr=0x1002 data=0x00 |
| 13185 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13210 | hbus driver | Executed READ  addr=0x1007 data=0x00 |
| 13215 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13230 | hbus driver | Executed WRITE addr=0x118b data=0x2a |
| 13235 | hbus monitor | Collected WRITE addr=0x118b data=0x2a |
| 13260 | hbus driver | Executed READ  addr=0x118b data=0x2a |
| 13265 | **DUT** | OUT ch2 pkt #13 done: 5 bytes in 15 cycles |
| 13265 | ch2 monitor | ch2 RX pkt #13: addr=2 len=3 parity=bad |
| 13265 | scoreboard | ch2 pkt matched: addr=2 len=3 (21 matched so far) |
| 13265 | hbus monitor | Collected READ  addr=0x118b data=0x2a |
| 13275 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 13290 | hbus driver | Executed READ  addr=0x100a data=0x04 |
| 13290 | **test** | STAGE: burst 4/4: ctrl=0x7f (maxpktsize 63) en=0x7f (router on, counter enables 0111111), 20 packet(s) |
| 13290 | yapp driver | TX pkt #64: addr=2 len=2 parity=bad delay=0 |
| 13295 | hbus monitor | Collected READ  addr=0x100a data=0x04 |
| 13305 | **DUT** | IN  pkt #64 header: addr=2 len=2 -> channel 2 |
| 13305 | **DUT** | OUT ch2 pkt #14 done: 4 bytes in 4 cycles |
| 13305 | ch2 monitor | ch2 RX pkt #14: addr=2 len=2 parity=good |
| 13305 | scoreboard | ch2 pkt matched: addr=2 len=2 (22 matched so far) |
| 13315 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 13335 | **DUT** | IN  pkt #64 complete: addr=2 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 13335 | yapp monitor | RX pkt #64 on the input: addr=2 len=2 parity=bad gap=19 |
| 13335 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 13340 | ch2 driver | ch2: packet consumed (response delay 9) |
| 13340 | yapp driver | TX pkt #64 accepted by the DUT |
| 13340 | yapp driver | TX pkt #65: addr=1 len=1 parity=good delay=20 |
| 13350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 13350 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 13455 | **DUT** | OUT ch2 pkt #15 done: 4 bytes in 15 cycles |
| 13455 | ch2 monitor | ch2 RX pkt #15: addr=2 len=2 parity=bad |
| 13455 | scoreboard | ch2 pkt matched: addr=2 len=2 (23 matched so far) |
| 13480 | ch1 driver | ch1: packet consumed (response delay 9) |
| 13545 | **DUT** | IN  pkt #65 header: addr=1 len=1 -> channel 1 |
| 13565 | **DUT** | IN  pkt #65 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13565 | yapp monitor | RX pkt #65 on the input: addr=1 len=1 parity=good gap=20 |
| 13565 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 13570 | yapp driver | TX pkt #65 accepted by the DUT |
| 13570 | yapp driver | TX pkt #66: addr=2 len=63 parity=good delay=0 |
| 13575 | **DUT** | IN  pkt #66 header: addr=2 len=63 -> channel 2 |
| 13585 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 13655 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=1 (receiver waited 10 cycle(s)) |
| 13670 | ch1 driver | ch1: packet consumed (response delay 10) |
| 13785 | **DUT** | OUT ch1 pkt #5 done: 3 bytes in 14 cycles |
| 13785 | ch1 monitor | ch1 RX pkt #5: addr=1 len=1 parity=good |
| 13785 | scoreboard | ch1 pkt matched: addr=1 len=1 (24 matched so far) |
| 13990 | ch2 driver | ch2: packet consumed (response delay 10) |
| 14150 | ch1 driver | ch1: packet consumed (response delay 10) |
| 14215 | **DUT** | IN  pkt #66 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 14215 | yapp monitor | RX pkt #66 on the input: addr=2 len=63 parity=good gap=0 |
| 14215 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 14220 | yapp driver | TX pkt #66 accepted by the DUT |
| 14220 | yapp driver | TX pkt #67: addr=1 len=63 parity=good delay=2 |
| 14245 | **DUT** | IN  pkt #67 header: addr=1 len=63 -> channel 1 |
| 14265 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=63 (receiver waited 1 cycle(s)) |
| 14320 | ch2 driver | ch2: packet consumed (response delay 9) |
| 14885 | **DUT** | IN  pkt #67 complete: addr=1 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 14885 | yapp monitor | RX pkt #67 on the input: addr=1 len=63 parity=good gap=2 |
| 14885 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 14890 | yapp driver | TX pkt #67 accepted by the DUT |
| 14890 | yapp driver | TX pkt #68: addr=2 len=50 parity=good delay=0 |
| 14895 | **DUT** | IN  pkt #68 header: addr=2 len=50 -> channel 2 |
| 14900 | ch1 driver | ch1: packet consumed (response delay 1) |
| 14995 | **DUT** | OUT ch1 pkt #6 done: 65 bytes in 74 cycles |
| 14995 | ch1 monitor | ch1 RX pkt #6: addr=1 len=63 parity=good |
| 14995 | scoreboard | ch1 pkt matched: addr=1 len=63 (25 matched so far) |
| 15045 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xf8 held (pkt #68) |
| 15420 | ch1 driver | ch1: packet consumed (response delay 8) |
| 15815 | **DUT** | OUT ch2 pkt #16 done: 65 bytes in 224 cycles |
| 15815 | ch2 monitor | ch2 RX pkt #16: addr=2 len=63 parity=good |
| 15815 | scoreboard | ch2 pkt matched: addr=2 len=63 (26 matched so far) |
| 15825 | **DUT** | SUSPEND released after 78 cycle(s) |
| 15825 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=50 (receiver waited 0 cycle(s)) |
| 16185 | **DUT** | IN  pkt #68 complete: addr=2 len=50 parity=ok forwarded, 52 bytes in 130 cycles (held 78) |
| 16185 | yapp monitor | RX pkt #68 on the input: addr=2 len=50 parity=good gap=0 |
| 16185 | reference | Packet forwarded: addr=2 len=50 -> channel 2 |
| 16190 | yapp driver | TX pkt #68 accepted by the DUT |
| 16190 | yapp driver | TX pkt #69: addr=2 len=14 parity=good delay=0 |
| 16195 | **DUT** | IN  pkt #69 header: addr=2 len=14 -> channel 2 |
| 16335 | **DUT** | OUT ch2 pkt #17 done: 52 bytes in 52 cycles |
| 16335 | ch2 monitor | ch2 RX pkt #17: addr=2 len=50 parity=good |
| 16335 | scoreboard | ch2 pkt matched: addr=2 len=50 (27 matched so far) |
| 16340 | ch2 driver | ch2: packet consumed (response delay 148) |
| 16345 | **DUT** | IN  pkt #69 complete: addr=2 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 16345 | yapp monitor | RX pkt #69 on the input: addr=2 len=14 parity=good gap=0 |
| 16345 | reference | Packet forwarded: addr=2 len=14 -> channel 2 |
| 16350 | yapp driver | TX pkt #69 accepted by the DUT |
| 16350 | yapp driver | TX pkt #70: addr=1 len=63 parity=good delay=5 |
| 16405 | **DUT** | IN  pkt #70 header: addr=1 len=63 -> channel 1 |
| 16425 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=63 (receiver waited 1 cycle(s)) |
| 17045 | **DUT** | IN  pkt #70 complete: addr=1 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 17045 | yapp monitor | RX pkt #70 on the input: addr=1 len=63 parity=good gap=5 |
| 17045 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 17050 | yapp driver | TX pkt #70 accepted by the DUT |
| 17050 | yapp driver | TX pkt #71: addr=2 len=5 parity=good delay=0 |
| 17055 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x16 held (pkt #71) |
| 17060 | ch1 driver | ch1: packet consumed (response delay 1) |
| 17115 | **DUT** | OUT ch1 pkt #7 done: 65 bytes in 70 cycles |
| 17115 | ch1 monitor | ch1 RX pkt #7: addr=1 len=63 parity=good |
| 17115 | scoreboard | ch1 pkt matched: addr=1 len=63 (28 matched so far) |
| 17240 | ch1 driver | ch1: packet consumed (response delay 4) |
| 17775 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=14 (receiver waited 143 cycle(s)) |
| 17785 | **DUT** | IN  pkt #71 header: addr=2 len=5 -> channel 2 |
| 17785 | **DUT** | SUSPEND released after 73 cycle(s) |
| 17845 | **DUT** | IN  pkt #71 complete: addr=2 len=5 parity=ok forwarded, 7 bytes in 7 cycles (held 0) |
| 17845 | yapp monitor | RX pkt #71 on the input: addr=2 len=5 parity=good gap=0 |
| 17845 | reference | Packet forwarded: addr=2 len=5 -> channel 2 |
| 17850 | yapp driver | TX pkt #71 accepted by the DUT |
| 17850 | yapp driver | TX pkt #72: addr=0 len=63 parity=good delay=0 |
| 17855 | **DUT** | IN  pkt #72 header: addr=0 len=63 -> channel 0 |
| 17865 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=63 (receiver waited 0 cycle(s)) |
| 17920 | ch2 driver | ch2: packet consumed (response delay 142) |
| 18495 | **DUT** | IN  pkt #72 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 18495 | yapp monitor | RX pkt #72 on the input: addr=0 len=63 parity=good gap=0 |
| 18495 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 18500 | ch0 driver | ch0: packet consumed (response delay 0) |
| 18500 | yapp driver | TX pkt #72 accepted by the DUT |
| 18500 | yapp driver | TX pkt #73: addr=1 len=42 parity=bad delay=1 |
| 18515 | **DUT** | IN  pkt #73 header: addr=1 len=42 -> channel 1 |
| 18515 | **DUT** | OUT ch0 pkt #5 done: 65 bytes in 66 cycles |
| 18515 | ch0 monitor | ch0 RX pkt #5: addr=0 len=63 parity=good |
| 18515 | scoreboard | ch0 pkt matched: addr=0 len=63 (29 matched so far) |
| 18545 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=42 (receiver waited 2 cycle(s)) |
| 18945 | **DUT** | IN  pkt #73 complete: addr=1 len=42 parity=BAD forwarded, 44 bytes in 44 cycles (held 0) |
| 18945 | yapp monitor | RX pkt #73 on the input: addr=1 len=42 parity=bad gap=1 |
| 18945 | reference | Packet forwarded: addr=1 len=42 -> channel 1 |
| 18950 | yapp driver | TX pkt #73 accepted by the DUT |
| 18950 | yapp driver | TX pkt #74: addr=1 len=41 parity=good delay=1 |
| 18965 | **DUT** | IN  pkt #74 header: addr=1 len=41 -> channel 1 |
| 18970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 18970 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 18970 | ch1 driver | ch1: packet consumed (response delay 2) |
| 19050 | ch0 driver | ch0: packet consumed (response delay 0) |
| 19055 | **DUT** | OUT ch1 pkt #8 done: 44 bytes in 52 cycles |
| 19055 | ch1 monitor | ch1 RX pkt #8: addr=1 len=42 parity=bad |
| 19055 | scoreboard | ch1 pkt matched: addr=1 len=42 (30 matched so far) |
| 19065 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=41 (receiver waited 0 cycle(s)) |
| 19225 | **DUT** | OUT ch2 pkt #18 done: 16 bytes in 146 cycles |
| 19225 | ch2 monitor | ch2 RX pkt #18: addr=2 len=14 parity=good |
| 19225 | scoreboard | ch2 pkt matched: addr=2 len=14 (31 matched so far) |
| 19235 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=5 (receiver waited 0 cycle(s)) |
| 19295 | **DUT** | OUT ch2 pkt #19 done: 7 bytes in 7 cycles |
| 19295 | ch2 monitor | ch2 RX pkt #19: addr=2 len=5 parity=good |
| 19295 | scoreboard | ch2 pkt matched: addr=2 len=5 (32 matched so far) |
| 19385 | **DUT** | IN  pkt #74 complete: addr=1 len=41 parity=ok forwarded, 43 bytes in 43 cycles (held 0) |
| 19385 | yapp monitor | RX pkt #74 on the input: addr=1 len=41 parity=good gap=1 |
| 19385 | reference | Packet forwarded: addr=1 len=41 -> channel 1 |
| 19390 | yapp driver | TX pkt #74 accepted by the DUT |
| 19390 | yapp driver | TX pkt #75: addr=3 len=63 parity=bad delay=3 |
| 19425 | **DUT** | IN  pkt #75 header: addr=3 len=63 -> DROP (illegal address 3) |
| 19485 | **DUT** | OUT ch1 pkt #9 done: 43 bytes in 43 cycles |
| 19485 | ch1 monitor | ch1 RX pkt #9: addr=1 len=41 parity=good |
| 19485 | scoreboard | ch1 pkt matched: addr=1 len=41 (33 matched so far) |
| 19580 | ch1 driver | ch1: packet consumed (response delay 7) |
| 19780 | ch2 driver | ch2: packet consumed (response delay 129) |
| 20065 | **DUT** | IN  pkt #75 complete: addr=3 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 20065 | yapp monitor | RX pkt #75 on the input: addr=3 len=63 parity=bad gap=3 |
| 20065 | reference | Packet dropped: illegal address 3 (len=63) |
| 20065 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 20070 | yapp driver | TX pkt #75 accepted by the DUT |
| 20070 | yapp driver | TX pkt #76: addr=1 len=40 parity=bad delay=7 |
| 20090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 20090 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 20145 | **DUT** | IN  pkt #76 header: addr=1 len=40 -> channel 1 |
| 20255 | **DUT** | OUT ch1 pkt #10 start: addr=1 len=40 (receiver waited 10 cycle(s)) |
| 20555 | **DUT** | IN  pkt #76 complete: addr=1 len=40 parity=BAD forwarded, 42 bytes in 42 cycles (held 0) |
| 20555 | yapp monitor | RX pkt #76 on the input: addr=1 len=40 parity=bad gap=7 |
| 20555 | reference | Packet forwarded: addr=1 len=40 -> channel 1 |
| 20560 | yapp driver | TX pkt #76 accepted by the DUT |
| 20560 | yapp driver | TX pkt #77: addr=3 len=46 parity=bad delay=3 |
| 20590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 20590 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 20595 | **DUT** | IN  pkt #77 header: addr=3 len=46 -> DROP (illegal address 3) |
| 20660 | ch1 driver | ch1: packet consumed (response delay 10) |
| 20715 | **DUT** | OUT ch1 pkt #10 done: 42 bytes in 47 cycles |
| 20715 | ch1 monitor | ch1 RX pkt #10: addr=1 len=40 parity=bad |
| 20715 | scoreboard | ch1 pkt matched: addr=1 len=40 (34 matched so far) |
| 21065 | **DUT** | IN  pkt #77 complete: addr=3 len=46 parity=BAD dropped, 48 bytes in 48 cycles (held 0) |
| 21065 | yapp monitor | RX pkt #77 on the input: addr=3 len=46 parity=bad gap=3 |
| 21065 | reference | Packet dropped: illegal address 3 (len=46) |
| 21065 | **DUT** | ROUTER DROPS PACKET addr=3 length=46 (    illegal address) |
| 21070 | yapp driver | TX pkt #77 accepted by the DUT |
| 21070 | yapp driver | TX pkt #78: addr=0 len=62 parity=bad delay=17 |
| 21090 | ch1 driver | ch1: packet consumed (response delay 4) |
| 21130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 21130 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 21245 | **DUT** | IN  pkt #78 header: addr=0 len=62 -> channel 0 |
| 21255 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=62 (receiver waited 0 cycle(s)) |
| 21875 | **DUT** | IN  pkt #78 complete: addr=0 len=62 parity=BAD forwarded, 64 bytes in 64 cycles (held 0) |
| 21875 | yapp monitor | RX pkt #78 on the input: addr=0 len=62 parity=bad gap=17 |
| 21875 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 21880 | ch0 driver | ch0: packet consumed (response delay 0) |
| 21880 | yapp driver | TX pkt #78 accepted by the DUT |
| 21880 | yapp driver | TX pkt #79: addr=2 len=33 parity=good delay=0 |
| 21885 | **DUT** | IN  pkt #79 header: addr=2 len=33 -> channel 2 |
| 21895 | **DUT** | OUT ch0 pkt #6 done: 64 bytes in 65 cycles |
| 21895 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=33 (receiver waited 0 cycle(s)) |
| 21895 | ch0 monitor | ch0 RX pkt #6: addr=0 len=62 parity=bad |
| 21895 | scoreboard | ch0 pkt matched: addr=0 len=62 (35 matched so far) |
| 21950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 21950 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 22070 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22225 | **DUT** | IN  pkt #79 complete: addr=2 len=33 parity=ok forwarded, 35 bytes in 35 cycles (held 0) |
| 22225 | yapp monitor | RX pkt #79 on the input: addr=2 len=33 parity=good gap=0 |
| 22225 | reference | Packet forwarded: addr=2 len=33 -> channel 2 |
| 22230 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22230 | yapp driver | TX pkt #79 accepted by the DUT |
| 22230 | yapp driver | TX pkt #80: addr=2 len=1 parity=bad delay=3 |
| 22265 | **DUT** | IN  pkt #80 header: addr=2 len=1 -> channel 2 |
| 22285 | **DUT** | IN  pkt #80 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 22285 | yapp monitor | RX pkt #80 on the input: addr=2 len=1 parity=bad gap=3 |
| 22285 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 22290 | yapp driver | TX pkt #80 accepted by the DUT |
| 22290 | yapp driver | TX pkt #81: addr=2 len=62 parity=good delay=0 |
| 22295 | **DUT** | IN  pkt #81 header: addr=2 len=62 -> channel 2 |
| 22325 | **DUT** | OUT ch2 pkt #20 done: 35 bytes in 44 cycles |
| 22325 | ch2 monitor | ch2 RX pkt #20: addr=2 len=33 parity=good |
| 22325 | scoreboard | ch2 pkt matched: addr=2 len=33 (36 matched so far) |
| 22335 | **DUT** | OUT ch2 pkt #21 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 22350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 22350 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 22355 | **DUT** | OUT ch2 pkt #21 done: 3 bytes in 3 cycles |
| 22355 | ch2 monitor | ch2 RX pkt #21: addr=2 len=1 parity=bad |
| 22355 | scoreboard | ch2 pkt matched: addr=2 len=1 (37 matched so far) |
| 22365 | **DUT** | OUT ch2 pkt #22 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 22800 | ch2 driver | ch2: packet consumed (response delay 8) |
| 22895 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0x7c held (pkt #81) |
| 22925 | **DUT** | SUSPEND released after 3 cycle(s) |
| 22955 | **DUT** | IN  pkt #81 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 67 cycles (held 3) |
| 22955 | yapp monitor | RX pkt #81 on the input: addr=2 len=62 parity=good gap=0 |
| 22955 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 22960 | yapp driver | TX pkt #81 accepted by the DUT |
| 22960 | yapp driver | TX pkt #82: addr=2 len=62 parity=good delay=0 |
| 22965 | **DUT** | IN  pkt #82 header: addr=2 len=62 -> channel 2 |
| 23105 | **DUT** | OUT ch2 pkt #22 done: 64 bytes in 75 cycles |
| 23105 | ch2 monitor | ch2 RX pkt #22: addr=2 len=62 parity=good |
| 23105 | scoreboard | ch2 pkt matched: addr=2 len=62 (38 matched so far) |
| 23115 | **DUT** | OUT ch2 pkt #23 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 23120 | ch2 driver | ch2: packet consumed (response delay 10) |
| 23135 | **DUT** | SUSPEND asserted: FIFO 2 full, byte 0xf5 held (pkt #82) |
| 23205 | **DUT** | SUSPEND released after 7 cycle(s) |
| 23665 | **DUT** | IN  pkt #82 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 71 cycles (held 7) |
| 23665 | yapp monitor | RX pkt #82 on the input: addr=2 len=62 parity=good gap=0 |
| 23665 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 23670 | yapp driver | TX pkt #82 accepted by the DUT |
| 23670 | yapp driver | TX pkt #83: addr=2 len=58 parity=good delay=3 |
| 23700 | ch2 driver | ch2: packet consumed (response delay 6) |
| 23705 | **DUT** | IN  pkt #83 header: addr=2 len=58 -> channel 2 |
| 23845 | **DUT** | OUT ch2 pkt #23 done: 64 bytes in 74 cycles |
| 23845 | ch2 monitor | ch2 RX pkt #23: addr=2 len=62 parity=good |
| 23845 | scoreboard | ch2 pkt matched: addr=2 len=62 (39 matched so far) |
| 23855 | **DUT** | OUT ch2 pkt #24 start: addr=2 len=58 (receiver waited 0 cycle(s)) |
| 24295 | **DUT** | IN  pkt #83 complete: addr=2 len=58 parity=ok forwarded, 60 bytes in 60 cycles (held 0) |
| 24295 | yapp monitor | RX pkt #83 on the input: addr=2 len=58 parity=good gap=3 |
| 24295 | reference | Packet forwarded: addr=2 len=58 -> channel 2 |
| 24300 | yapp driver | TX pkt #83 accepted by the DUT |
| 24300 | **test** | STAGE: burst 4/4 sent: addr0..3 2/6/10/2, bad parity 7, gap 0 9, length 1..63 |
| 24300 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 24320 | ch2 driver | ch2: packet consumed (response delay 2) |
| 24330 | hbus driver | Executed READ  addr=0x1000 data=0x7f |
| 24335 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 24360 | hbus driver | Executed READ  addr=0x1001 data=0x7f |
| 24365 | hbus monitor | Collected READ  addr=0x1001 data=0x7f |
| 24390 | hbus driver | Executed READ  addr=0x1004 data=0x0d |
| 24395 | hbus monitor | Collected READ  addr=0x1004 data=0x0d |
| 24420 | hbus driver | Executed READ  addr=0x1005 data=0x0f |
| 24425 | hbus monitor | Collected READ  addr=0x1005 data=0x0f |
| 24450 | hbus driver | Executed READ  addr=0x1006 data=0x01 |
| 24455 | hbus monitor | Collected READ  addr=0x1006 data=0x01 |
| 24480 | hbus driver | Executed READ  addr=0x1009 data=0x07 |
| 24485 | hbus monitor | Collected READ  addr=0x1009 data=0x07 |
| 24510 | hbus driver | Executed READ  addr=0x100a data=0x0a |
| 24515 | hbus monitor | Collected READ  addr=0x100a data=0x0a |
| 24540 | hbus driver | Executed READ  addr=0x100b data=0x15 |
| 24545 | hbus monitor | Collected READ  addr=0x100b data=0x15 |
| 24555 | **DUT** | OUT ch2 pkt #24 done: 60 bytes in 71 cycles |
| 24555 | ch2 monitor | ch2 RX pkt #24: addr=2 len=58 parity=good |
| 24555 | scoreboard | ch2 pkt matched: addr=2 len=58 (40 matched so far) |
| 24570 | hbus driver | Executed READ  addr=0x100d data=0x3a |
| 24575 | hbus monitor | Collected READ  addr=0x100d data=0x3a |
| 24600 | hbus driver | Executed READ  addr=0x1010 data=0xea |
| 24605 | hbus monitor | Collected READ  addr=0x1010 data=0xea |
| 24630 | hbus driver | Executed READ  addr=0x1011 data=0x3a |
| 24635 | hbus monitor | Collected READ  addr=0x1011 data=0x3a |
| 24660 | hbus driver | Executed READ  addr=0x1012 data=0x3b |
| 24665 | hbus monitor | Collected READ  addr=0x1012 data=0x3b |
| 24690 | hbus driver | Executed READ  addr=0x1013 data=0x79 |
| 24695 | hbus monitor | Collected READ  addr=0x1013 data=0x79 |
| 24720 | hbus driver | Executed READ  addr=0x1014 data=0xe7 |
| 24725 | hbus monitor | Collected READ  addr=0x1014 data=0xe7 |
| 24740 | ch2 driver | ch2: packet consumed (response delay 10) |
| 24750 | hbus driver | Executed READ  addr=0x1015 data=0xf1 |
| 24755 | hbus monitor | Collected READ  addr=0x1015 data=0xf1 |
| 24780 | hbus driver | Executed READ  addr=0x1016 data=0xab |
| 24785 | hbus monitor | Collected READ  addr=0x1016 data=0xab |
| 24810 | hbus driver | Executed READ  addr=0x1017 data=0xc0 |
| 24815 | hbus monitor | Collected READ  addr=0x1017 data=0xc0 |
| 24840 | hbus driver | Executed READ  addr=0x1018 data=0x32 |
| 24845 | hbus monitor | Collected READ  addr=0x1018 data=0x32 |
| 24870 | hbus driver | Executed READ  addr=0x1019 data=0x81 |
| 24875 | hbus monitor | Collected READ  addr=0x1019 data=0x81 |
| 24900 | hbus driver | Executed READ  addr=0x101a data=0xbb |
| 24905 | hbus monitor | Collected READ  addr=0x101a data=0xbb |
| 24930 | hbus driver | Executed READ  addr=0x101b data=0xd2 |
| 24935 | hbus monitor | Collected READ  addr=0x101b data=0xd2 |
| 24960 | hbus driver | Executed READ  addr=0x101c data=0x0c |
| 24965 | hbus monitor | Collected READ  addr=0x101c data=0x0c |
| 24990 | hbus driver | Executed READ  addr=0x101d data=0x35 |
| 24995 | hbus monitor | Collected READ  addr=0x101d data=0x35 |
| 25020 | hbus driver | Executed READ  addr=0x101e data=0x8c |
| 25025 | hbus monitor | Collected READ  addr=0x101e data=0x8c |
| 25050 | hbus driver | Executed READ  addr=0x101f data=0x9a |
| 25055 | hbus monitor | Collected READ  addr=0x101f data=0x9a |
| 25080 | hbus driver | Executed READ  addr=0x1020 data=0xd8 |
| 25085 | hbus monitor | Collected READ  addr=0x1020 data=0xd8 |
| 25110 | hbus driver | Executed READ  addr=0x1021 data=0xeb |
| 25115 | hbus monitor | Collected READ  addr=0x1021 data=0xeb |
| 25140 | hbus driver | Executed READ  addr=0x1022 data=0x7a |
| 25145 | hbus monitor | Collected READ  addr=0x1022 data=0x7a |
| 25170 | hbus driver | Executed READ  addr=0x1023 data=0x6a |
| 25175 | hbus monitor | Collected READ  addr=0x1023 data=0x6a |
| 25200 | hbus driver | Executed READ  addr=0x1024 data=0x5f |
| 25205 | hbus monitor | Collected READ  addr=0x1024 data=0x5f |
| 25230 | hbus driver | Executed READ  addr=0x1025 data=0x70 |
| 25235 | hbus monitor | Collected READ  addr=0x1025 data=0x70 |
| 25260 | hbus driver | Executed READ  addr=0x1026 data=0xa5 |
| 25265 | hbus monitor | Collected READ  addr=0x1026 data=0xa5 |
| 25290 | hbus driver | Executed READ  addr=0x1027 data=0xeb |
| 25295 | hbus monitor | Collected READ  addr=0x1027 data=0xeb |
| 25320 | hbus driver | Executed READ  addr=0x1028 data=0xc1 |
| 25325 | hbus monitor | Collected READ  addr=0x1028 data=0xc1 |
| 25350 | hbus driver | Executed READ  addr=0x1029 data=0x0e |
| 25355 | hbus monitor | Collected READ  addr=0x1029 data=0x0e |
| 25380 | hbus driver | Executed READ  addr=0x102a data=0xce |
| 25385 | hbus monitor | Collected READ  addr=0x102a data=0xce |
| 25410 | hbus driver | Executed READ  addr=0x102b data=0xb2 |
| 25415 | hbus monitor | Collected READ  addr=0x102b data=0xb2 |
| 25440 | hbus driver | Executed READ  addr=0x102c data=0x6b |
| 25445 | hbus monitor | Collected READ  addr=0x102c data=0x6b |
| 25470 | hbus driver | Executed READ  addr=0x102d data=0x19 |
| 25475 | hbus monitor | Collected READ  addr=0x102d data=0x19 |
| 25500 | hbus driver | Executed READ  addr=0x102e data=0x0f |
| 25505 | hbus monitor | Collected READ  addr=0x102e data=0x0f |
| 25530 | hbus driver | Executed READ  addr=0x102f data=0x2a |
| 25535 | hbus monitor | Collected READ  addr=0x102f data=0x2a |
| 25560 | hbus driver | Executed READ  addr=0x1030 data=0x48 |
| 25565 | hbus monitor | Collected READ  addr=0x1030 data=0x48 |
| 25590 | hbus driver | Executed READ  addr=0x1031 data=0x92 |
| 25595 | hbus monitor | Collected READ  addr=0x1031 data=0x92 |
| 25620 | hbus driver | Executed READ  addr=0x1032 data=0xf5 |
| 25625 | hbus monitor | Collected READ  addr=0x1032 data=0xf5 |
| 25650 | hbus driver | Executed READ  addr=0x1033 data=0x85 |
| 25655 | hbus monitor | Collected READ  addr=0x1033 data=0x85 |
| 25680 | hbus driver | Executed READ  addr=0x1034 data=0xcc |
| 25685 | hbus monitor | Collected READ  addr=0x1034 data=0xcc |
| 25710 | hbus driver | Executed READ  addr=0x1035 data=0x52 |
| 25715 | hbus monitor | Collected READ  addr=0x1035 data=0x52 |
| 25740 | hbus driver | Executed READ  addr=0x1036 data=0x60 |
| 25745 | hbus monitor | Collected READ  addr=0x1036 data=0x60 |
| 25770 | hbus driver | Executed READ  addr=0x1037 data=0xcf |
| 25775 | hbus monitor | Collected READ  addr=0x1037 data=0xcf |
| 25800 | hbus driver | Executed READ  addr=0x1038 data=0x2d |
| 25805 | hbus monitor | Collected READ  addr=0x1038 data=0x2d |
| 25830 | hbus driver | Executed READ  addr=0x1039 data=0x33 |
| 25835 | hbus monitor | Collected READ  addr=0x1039 data=0x33 |
| 25860 | hbus driver | Executed READ  addr=0x103a data=0x40 |
| 25865 | hbus monitor | Collected READ  addr=0x103a data=0x40 |
| 25890 | hbus driver | Executed READ  addr=0x103b data=0xba |
| 25895 | hbus monitor | Collected READ  addr=0x103b data=0xba |
| 25920 | hbus driver | Executed READ  addr=0x103c data=0xc5 |
| 25925 | hbus monitor | Collected READ  addr=0x103c data=0xc5 |
| 25950 | hbus driver | Executed READ  addr=0x103d data=0xe1 |
| 25955 | hbus monitor | Collected READ  addr=0x103d data=0xe1 |
| 25980 | hbus driver | Executed READ  addr=0x103e data=0x99 |
| 25985 | hbus monitor | Collected READ  addr=0x103e data=0x99 |
| 26010 | hbus driver | Executed READ  addr=0x103f data=0x7a |
| 26015 | hbus monitor | Collected READ  addr=0x103f data=0x7a |
| 26040 | hbus driver | Executed READ  addr=0x1040 data=0x00 |
| 26045 | hbus monitor | Collected READ  addr=0x1040 data=0x00 |
| 26070 | hbus driver | Executed READ  addr=0x1041 data=0x1a |
| 26075 | hbus monitor | Collected READ  addr=0x1041 data=0x1a |
| 26100 | hbus driver | Executed READ  addr=0x1042 data=0x09 |
| 26105 | hbus monitor | Collected READ  addr=0x1042 data=0x09 |
| 26130 | hbus driver | Executed READ  addr=0x1043 data=0xde |
| 26135 | hbus monitor | Collected READ  addr=0x1043 data=0xde |
| 26160 | hbus driver | Executed READ  addr=0x1044 data=0xa4 |
| 26165 | hbus monitor | Collected READ  addr=0x1044 data=0xa4 |
| 26190 | hbus driver | Executed READ  addr=0x1045 data=0xf0 |
| 26195 | hbus monitor | Collected READ  addr=0x1045 data=0xf0 |
| 26220 | hbus driver | Executed READ  addr=0x1046 data=0xf0 |
| 26225 | hbus monitor | Collected READ  addr=0x1046 data=0xf0 |
| 26250 | hbus driver | Executed READ  addr=0x1047 data=0x23 |
| 26255 | hbus monitor | Collected READ  addr=0x1047 data=0x23 |
| 26280 | hbus driver | Executed READ  addr=0x1048 data=0xe0 |
| 26285 | hbus monitor | Collected READ  addr=0x1048 data=0xe0 |
| 26310 | hbus driver | Executed READ  addr=0x1049 data=0xc3 |
| 26315 | hbus monitor | Collected READ  addr=0x1049 data=0xc3 |
| 26340 | hbus driver | Executed READ  addr=0x104a data=0x06 |
| 26345 | hbus monitor | Collected READ  addr=0x104a data=0x06 |
| 26455 | **test** | STAGE: done: 83 packets (40 forwarded, 43 dropped), 2 storm burst(s), 40 scoreboard matches, 84 HBUS reads checked, 17 error pulses for 17 bad packets |
| 26655 | error checker | error pulse report: 17 bad packets, 17 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 26655 | ch0 monitor | Channel 0 report: 6 packets collected |
| 26655 | ch1 monitor | Channel 1 report: 10 packets collected |
| 26655 | ch2 monitor | Channel 2 report: 24 packets collected |
| 26655 | hbus monitor | HBUS report: 15 writes, 85 reads |
| 26655 | coverage | Coverage of the router configuration: 78.3% |
| 26655 | reference |  |
| 26655 | reference | HBUS reads checked against the model: 84 (0 mismatches, 1 of memory bytes never written) |
| 26655 | scoreboard |  |
| 26655 | yapp driver | YAPP driver report: 83 packets sent |
| 26655 | coverage | YAPP gap coverage: 82 gaps sampled, coverage 100.0% |
| 26655 | yapp monitor | YAPP monitor report: 83 packets collected, 22 with bad parity |
| 26655 | yapp monitor | YAPP gaps: 50 back to back, 6 of 1 cycle, 3 of 2, 23 longer |
| 26655 | coverage | YAPP packet coverage: 83 packets sampled, coverage 86.7% |
