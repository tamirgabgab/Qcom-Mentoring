# random_test seed 8

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 35us · wall 21.4 s · log [`random_test_s8.log`](random_test_s8.log)

Waves: `random_test_s8.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s8%2Frandom_test_s8.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **80** packet(s) (10 with bad parity); the input monitor saw 80.
- Router: **28** forwarded, **52** dropped (38 oversized, 14 router disabled).
- Packets out: ch0 **7**, ch1 **9**, ch2 **12**.
- Scoreboard: 28 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 7.
- HBUS: 31 write(s), 52 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 80 packets in 6 bursts |
| 360 | burst 1/6: ctrl=0x00 (maxpktsize 0) en=0x3d (router on, counter enables 0011110), 13 packet(s) |
| 4950 | burst 1/6 sent: addr0..3 1/5/7/0, bad parity 1, gap 0 2, length 1..63 |
| 5340 | burst 2/6: ctrl=0x1a (maxpktsize 26) en=0xfe (router OFF, counter enables 1111111), 14 packet(s) |
| 11720 | burst 2/6 sent: addr0..3 4/3/6/1, bad parity 3, gap 0 3, length 4..63 |
| 12040 | burst 3/6: ctrl=0x3a (maxpktsize 58) en=0x67 (router on, counter enables 0110011), 13 packet(s) |
| 18690 | burst 3/6 sent: addr0..3 5/1/6/1, bad parity 0, gap 0 6, length 9..63 |
| 18890 | burst 4/6: ctrl=0x19 (maxpktsize 25) en=0x5f (router on, counter enables 0101111), 13 packet(s) |
| 23860 | burst 4/6 sent: addr0..3 1/3/9/0, bad parity 2, gap 0 4, length 12..63 |
| 24030 | burst 5/6: ctrl=0x02 (maxpktsize 2) en=0x49 (router on, counter enables 0100100), 13 packet(s) |
| 28930 | burst 5/6 sent: addr0..3 2/6/5/0, bad parity 2, gap 0 2, length 1..63 |
| 29240 | burst 6/6: ctrl=0x5b (maxpktsize 27) en=0xb5 (router on, counter enables 1011010), 14 packet(s) |
| 34070 | burst 6/6 sent: addr0..3 5/5/4/0, bad parity 2, gap 0 4, length 5..63 |
| 34070 | final reads: every register and the stored packet, checked against the reference model |
| 34665 | done: 80 packets (28 forwarded, 52 dropped), 0 storm burst(s), 28 scoreboard matches, 50 HBUS reads checked, 7 error pulses for 7 bad packets |

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

931 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 80 packets in 6 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 75 | reference | maxpktsize is now 0 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0x3d |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0x3d |
| 95 | reference | router_en is now 1 (en_reg 0x3d) |
| 110 | hbus driver | Executed WRITE addr=0x1179 data=0xd7 |
| 115 | hbus monitor | Collected WRITE addr=0x1179 data=0xd7 |
| 140 | hbus driver | Executed READ  addr=0x1179 data=0xd7 |
| 145 | hbus monitor | Collected READ  addr=0x1179 data=0xd7 |
| 170 | hbus driver | Executed READ  addr=0x1050 data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x1050 data=0x00 |
| 200 | hbus driver | Executed READ  addr=0x1056 data=0x00 |
| 205 | hbus monitor | Collected READ  addr=0x1056 data=0x00 |
| 230 | hbus driver | Executed READ  addr=0x1026 data=0x00 |
| 235 | hbus monitor | Collected READ  addr=0x1026 data=0x00 |
| 260 | hbus driver | Executed READ  addr=0x104f data=0x00 |
| 265 | hbus monitor | Collected READ  addr=0x104f data=0x00 |
| 280 | hbus driver | Executed WRITE addr=0x1184 data=0x4a |
| 285 | hbus monitor | Collected WRITE addr=0x1184 data=0x4a |
| 310 | hbus driver | Executed READ  addr=0x1184 data=0x4a |
| 315 | hbus monitor | Collected READ  addr=0x1184 data=0x4a |
| 330 | hbus driver | Executed WRITE addr=0x11ea data=0x3c |
| 335 | hbus monitor | Collected WRITE addr=0x11ea data=0x3c |
| 360 | hbus driver | Executed READ  addr=0x11ea data=0x3c |
| 360 | **test** | STAGE: burst 1/6: ctrl=0x00 (maxpktsize 0) en=0x3d (router on, counter enables 0011110), 13 packet(s) |
| 360 | yapp driver | TX pkt #1: addr=1 len=1 parity=good delay=18 |
| 365 | hbus monitor | Collected READ  addr=0x11ea data=0x3c |
| 555 | **DUT** | IN  pkt #1 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 575 | **DUT** | IN  pkt #1 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 575 | yapp monitor | RX pkt #1 on the input: addr=1 len=1 parity=good gap=50 |
| 575 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 575 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 580 | yapp driver | TX pkt #1 accepted by the DUT |
| 580 | yapp driver | TX pkt #2: addr=1 len=5 parity=good delay=0 |
| 585 | **DUT** | IN  pkt #2 header: addr=1 len=5 -> DROP (oversized: len 5 > maxpktsize 0) |
| 645 | **DUT** | IN  pkt #2 complete: addr=1 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 645 | yapp monitor | RX pkt #2 on the input: addr=1 len=5 parity=good gap=0 |
| 645 | reference | Packet dropped: length 5 > maxpktsize 0 (addr=1) |
| 645 | **DUT** | ROUTER DROPS PACKET addr=1 length=5 (length > maxpktsize) |
| 650 | yapp driver | TX pkt #2 accepted by the DUT |
| 650 | yapp driver | TX pkt #3: addr=2 len=46 parity=good delay=6 |
| 715 | **DUT** | IN  pkt #3 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 0) |
| 1185 | **DUT** | IN  pkt #3 complete: addr=2 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 1185 | yapp monitor | RX pkt #3 on the input: addr=2 len=46 parity=good gap=6 |
| 1185 | reference | Packet dropped: length 46 > maxpktsize 0 (addr=2) |
| 1185 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 1190 | yapp driver | TX pkt #3 accepted by the DUT |
| 1190 | yapp driver | TX pkt #4: addr=0 len=1 parity=good delay=9 |
| 1285 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 1305 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 1305 | yapp monitor | RX pkt #4 on the input: addr=0 len=1 parity=good gap=9 |
| 1305 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 1305 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 1310 | yapp driver | TX pkt #4 accepted by the DUT |
| 1310 | yapp driver | TX pkt #5: addr=2 len=18 parity=good delay=3 |
| 1345 | **DUT** | IN  pkt #5 header: addr=2 len=18 -> DROP (oversized: len 18 > maxpktsize 0) |
| 1535 | **DUT** | IN  pkt #5 complete: addr=2 len=18 parity=ok dropped, 20 bytes in 20 cycles (held 0) |
| 1535 | yapp monitor | RX pkt #5 on the input: addr=2 len=18 parity=good gap=3 |
| 1535 | reference | Packet dropped: length 18 > maxpktsize 0 (addr=2) |
| 1535 | **DUT** | ROUTER DROPS PACKET addr=2 length=18 (length > maxpktsize) |
| 1540 | yapp driver | TX pkt #5 accepted by the DUT |
| 1540 | yapp driver | TX pkt #6: addr=2 len=33 parity=good delay=5 |
| 1595 | **DUT** | IN  pkt #6 header: addr=2 len=33 -> DROP (oversized: len 33 > maxpktsize 0) |
| 1935 | **DUT** | IN  pkt #6 complete: addr=2 len=33 parity=ok dropped, 35 bytes in 35 cycles (held 0) |
| 1935 | yapp monitor | RX pkt #6 on the input: addr=2 len=33 parity=good gap=5 |
| 1935 | reference | Packet dropped: length 33 > maxpktsize 0 (addr=2) |
| 1935 | **DUT** | ROUTER DROPS PACKET addr=2 length=33 (length > maxpktsize) |
| 1940 | yapp driver | TX pkt #6 accepted by the DUT |
| 1940 | yapp driver | TX pkt #7: addr=1 len=63 parity=good delay=3 |
| 1975 | **DUT** | IN  pkt #7 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 2615 | **DUT** | IN  pkt #7 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2615 | yapp monitor | RX pkt #7 on the input: addr=1 len=63 parity=good gap=3 |
| 2615 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 2615 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 2620 | yapp driver | TX pkt #7 accepted by the DUT |
| 2620 | yapp driver | TX pkt #8: addr=1 len=1 parity=good delay=3 |
| 2655 | **DUT** | IN  pkt #8 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 2675 | **DUT** | IN  pkt #8 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 2675 | yapp monitor | RX pkt #8 on the input: addr=1 len=1 parity=good gap=3 |
| 2675 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 2675 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 2680 | yapp driver | TX pkt #8 accepted by the DUT |
| 2680 | yapp driver | TX pkt #9: addr=2 len=8 parity=good delay=10 |
| 2785 | **DUT** | IN  pkt #9 header: addr=2 len=8 -> DROP (oversized: len 8 > maxpktsize 0) |
| 2875 | **DUT** | IN  pkt #9 complete: addr=2 len=8 parity=ok dropped, 10 bytes in 10 cycles (held 0) |
| 2875 | yapp monitor | RX pkt #9 on the input: addr=2 len=8 parity=good gap=10 |
| 2875 | reference | Packet dropped: length 8 > maxpktsize 0 (addr=2) |
| 2875 | **DUT** | ROUTER DROPS PACKET addr=2 length=8 (length > maxpktsize) |
| 2880 | yapp driver | TX pkt #9 accepted by the DUT |
| 2880 | yapp driver | TX pkt #10: addr=2 len=27 parity=good delay=20 |
| 3085 | **DUT** | IN  pkt #10 header: addr=2 len=27 -> DROP (oversized: len 27 > maxpktsize 0) |
| 3365 | **DUT** | IN  pkt #10 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 3365 | yapp monitor | RX pkt #10 on the input: addr=2 len=27 parity=good gap=20 |
| 3365 | reference | Packet dropped: length 27 > maxpktsize 0 (addr=2) |
| 3365 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (length > maxpktsize) |
| 3370 | yapp driver | TX pkt #10 accepted by the DUT |
| 3370 | yapp driver | TX pkt #11: addr=2 len=60 parity=good delay=17 |
| 3545 | **DUT** | IN  pkt #11 header: addr=2 len=60 -> DROP (oversized: len 60 > maxpktsize 0) |
| 4155 | **DUT** | IN  pkt #11 complete: addr=2 len=60 parity=ok dropped, 62 bytes in 62 cycles (held 0) |
| 4155 | yapp monitor | RX pkt #11 on the input: addr=2 len=60 parity=good gap=17 |
| 4155 | reference | Packet dropped: length 60 > maxpktsize 0 (addr=2) |
| 4155 | **DUT** | ROUTER DROPS PACKET addr=2 length=60 (length > maxpktsize) |
| 4160 | yapp driver | TX pkt #11 accepted by the DUT |
| 4160 | yapp driver | TX pkt #12: addr=2 len=29 parity=bad delay=1 |
| 4175 | **DUT** | IN  pkt #12 header: addr=2 len=29 -> DROP (oversized: len 29 > maxpktsize 0) |
| 4475 | **DUT** | IN  pkt #12 complete: addr=2 len=29 parity=BAD dropped, 31 bytes in 31 cycles (held 0) |
| 4475 | yapp monitor | RX pkt #12 on the input: addr=2 len=29 parity=bad gap=1 |
| 4475 | reference | Packet dropped: length 29 > maxpktsize 0 (addr=2) |
| 4475 | **DUT** | ROUTER DROPS PACKET addr=2 length=29 (length > maxpktsize) |
| 4480 | yapp driver | TX pkt #12 accepted by the DUT |
| 4480 | yapp driver | TX pkt #13: addr=1 len=45 parity=good delay=0 |
| 4485 | **DUT** | IN  pkt #13 header: addr=1 len=45 -> DROP (oversized: len 45 > maxpktsize 0) |
| 4490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 4490 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 4945 | **DUT** | IN  pkt #13 complete: addr=1 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 4945 | yapp monitor | RX pkt #13 on the input: addr=1 len=45 parity=good gap=0 |
| 4945 | reference | Packet dropped: length 45 > maxpktsize 0 (addr=1) |
| 4945 | **DUT** | ROUTER DROPS PACKET addr=1 length=45 (length > maxpktsize) |
| 4950 | yapp driver | TX pkt #13 accepted by the DUT |
| 4950 | **test** | STAGE: burst 1/6 sent: addr0..3 1/5/7/0, bad parity 1, gap 0 2, length 1..63 |
| 4970 | hbus driver | Executed WRITE addr=0x1000 data=0x1a |
| 4975 | **DUT** | CONFIG router_en=1 maxpktsize=26 |
| 4975 | hbus monitor | Collected WRITE addr=0x1000 data=0x1a |
| 4975 | reference | maxpktsize is now 26 |
| 4990 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 4995 | **DUT** | CONFIG router_en=0 maxpktsize=26 |
| 4995 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 4995 | reference | router_en is now 0 (en_reg 0xfe) |
| 5010 | hbus driver | Executed WRITE addr=0x11f1 data=0x18 |
| 5015 | hbus monitor | Collected WRITE addr=0x11f1 data=0x18 |
| 5040 | hbus driver | Executed READ  addr=0x11f1 data=0x18 |
| 5045 | hbus monitor | Collected READ  addr=0x11f1 data=0x18 |
| 5060 | hbus driver | Executed WRITE addr=0x11ff data=0x81 |
| 5065 | hbus monitor | Collected WRITE addr=0x11ff data=0x81 |
| 5090 | hbus driver | Executed READ  addr=0x11ff data=0x81 |
| 5095 | hbus monitor | Collected READ  addr=0x11ff data=0x81 |
| 5110 | hbus driver | Executed WRITE addr=0x119a data=0x18 |
| 5115 | hbus monitor | Collected WRITE addr=0x119a data=0x18 |
| 5140 | hbus driver | Executed READ  addr=0x119a data=0x18 |
| 5145 | hbus monitor | Collected READ  addr=0x119a data=0x18 |
| 5160 | hbus driver | Executed WRITE addr=0x11f8 data=0xeb |
| 5165 | hbus monitor | Collected WRITE addr=0x11f8 data=0xeb |
| 5190 | hbus driver | Executed READ  addr=0x11f8 data=0xeb |
| 5195 | hbus monitor | Collected READ  addr=0x11f8 data=0xeb |
| 5210 | hbus driver | Executed WRITE addr=0x1154 data=0x96 |
| 5215 | hbus monitor | Collected WRITE addr=0x1154 data=0x96 |
| 5240 | hbus driver | Executed READ  addr=0x1154 data=0x96 |
| 5245 | hbus monitor | Collected READ  addr=0x1154 data=0x96 |
| 5260 | hbus driver | Executed WRITE addr=0x1152 data=0x44 |
| 5265 | hbus monitor | Collected WRITE addr=0x1152 data=0x44 |
| 5290 | hbus driver | Executed READ  addr=0x1152 data=0x44 |
| 5295 | hbus monitor | Collected READ  addr=0x1152 data=0x44 |
| 5310 | hbus driver | Executed WRITE addr=0x119c data=0x55 |
| 5315 | hbus monitor | Collected WRITE addr=0x119c data=0x55 |
| 5340 | hbus driver | Executed READ  addr=0x119c data=0x55 |
| 5340 | **test** | STAGE: burst 2/6: ctrl=0x1a (maxpktsize 26) en=0xfe (router OFF, counter enables 1111111), 14 packet(s) |
| 5340 | yapp driver | TX pkt #14: addr=2 len=11 parity=good delay=18 |
| 5345 | hbus monitor | Collected READ  addr=0x119c data=0x55 |
| 5535 | **DUT** | IN  pkt #14 header: addr=2 len=11 -> DROP (router disabled) |
| 5655 | **DUT** | IN  pkt #14 complete: addr=2 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 5655 | yapp monitor | RX pkt #14 on the input: addr=2 len=11 parity=good gap=58 |
| 5655 | reference | Packet dropped: router disabled (addr=2 len=11) |
| 5655 | **DUT** | ROUTER DROPS PACKET addr=2 length=11 (router disabled) |
| 5660 | yapp driver | TX pkt #14 accepted by the DUT |
| 5660 | yapp driver | TX pkt #15: addr=2 len=27 parity=good delay=3 |
| 5695 | **DUT** | IN  pkt #15 header: addr=2 len=27 -> DROP (router disabled) |
| 5975 | **DUT** | IN  pkt #15 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 5975 | yapp monitor | RX pkt #15 on the input: addr=2 len=27 parity=good gap=3 |
| 5975 | reference | Packet dropped: router disabled (addr=2 len=27) |
| 5975 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (router disabled) |
| 5980 | yapp driver | TX pkt #15 accepted by the DUT |
| 5980 | yapp driver | TX pkt #16: addr=0 len=63 parity=good delay=2 |
| 6005 | **DUT** | IN  pkt #16 header: addr=0 len=63 -> DROP (router disabled) |
| 6645 | **DUT** | IN  pkt #16 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 6645 | yapp monitor | RX pkt #16 on the input: addr=0 len=63 parity=good gap=2 |
| 6645 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 6645 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 6650 | yapp driver | TX pkt #16 accepted by the DUT |
| 6650 | yapp driver | TX pkt #17: addr=0 len=4 parity=good delay=17 |
| 6825 | **DUT** | IN  pkt #17 header: addr=0 len=4 -> DROP (router disabled) |
| 6875 | **DUT** | IN  pkt #17 complete: addr=0 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 6875 | yapp monitor | RX pkt #17 on the input: addr=0 len=4 parity=good gap=17 |
| 6875 | reference | Packet dropped: router disabled (addr=0 len=4) |
| 6875 | **DUT** | ROUTER DROPS PACKET addr=0 length=4 (router disabled) |
| 6880 | yapp driver | TX pkt #17 accepted by the DUT |
| 6880 | yapp driver | TX pkt #18: addr=2 len=9 parity=good delay=8 |
| 6965 | **DUT** | IN  pkt #18 header: addr=2 len=9 -> DROP (router disabled) |
| 7065 | **DUT** | IN  pkt #18 complete: addr=2 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 7065 | yapp monitor | RX pkt #18 on the input: addr=2 len=9 parity=good gap=8 |
| 7065 | reference | Packet dropped: router disabled (addr=2 len=9) |
| 7065 | **DUT** | ROUTER DROPS PACKET addr=2 length=9 (router disabled) |
| 7070 | yapp driver | TX pkt #18 accepted by the DUT |
| 7070 | yapp driver | TX pkt #19: addr=2 len=4 parity=good delay=20 |
| 7275 | **DUT** | IN  pkt #19 header: addr=2 len=4 -> DROP (router disabled) |
| 7325 | **DUT** | IN  pkt #19 complete: addr=2 len=4 parity=ok dropped, 6 bytes in 6 cycles (held 0) |
| 7325 | yapp monitor | RX pkt #19 on the input: addr=2 len=4 parity=good gap=20 |
| 7325 | reference | Packet dropped: router disabled (addr=2 len=4) |
| 7325 | **DUT** | ROUTER DROPS PACKET addr=2 length=4 (router disabled) |
| 7330 | yapp driver | TX pkt #19 accepted by the DUT |
| 7330 | yapp driver | TX pkt #20: addr=1 len=63 parity=good delay=2 |
| 7355 | **DUT** | IN  pkt #20 header: addr=1 len=63 -> DROP (router disabled) |
| 7995 | **DUT** | IN  pkt #20 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 7995 | yapp monitor | RX pkt #20 on the input: addr=1 len=63 parity=good gap=2 |
| 7995 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 7995 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 8000 | yapp driver | TX pkt #20 accepted by the DUT |
| 8000 | yapp driver | TX pkt #21: addr=1 len=43 parity=good delay=20 |
| 8205 | **DUT** | IN  pkt #21 header: addr=1 len=43 -> DROP (router disabled) |
| 8645 | **DUT** | IN  pkt #21 complete: addr=1 len=43 parity=ok dropped, 45 bytes in 45 cycles (held 0) |
| 8645 | yapp monitor | RX pkt #21 on the input: addr=1 len=43 parity=good gap=20 |
| 8645 | reference | Packet dropped: router disabled (addr=1 len=43) |
| 8645 | **DUT** | ROUTER DROPS PACKET addr=1 length=43 (router disabled) |
| 8650 | yapp driver | TX pkt #21 accepted by the DUT |
| 8650 | yapp driver | TX pkt #22: addr=2 len=25 parity=bad delay=1 |
| 8665 | **DUT** | IN  pkt #22 header: addr=2 len=25 -> DROP (router disabled) |
| 8925 | **DUT** | IN  pkt #22 complete: addr=2 len=25 parity=BAD dropped, 27 bytes in 27 cycles (held 0) |
| 8925 | yapp monitor | RX pkt #22 on the input: addr=2 len=25 parity=bad gap=1 |
| 8925 | reference | Packet dropped: router disabled (addr=2 len=25) |
| 8925 | **DUT** | ROUTER DROPS PACKET addr=2 length=25 (router disabled) |
| 8930 | yapp driver | TX pkt #22 accepted by the DUT |
| 8930 | yapp driver | TX pkt #23: addr=1 len=63 parity=bad delay=12 |
| 9055 | **DUT** | IN  pkt #23 header: addr=1 len=63 -> DROP (router disabled) |
| 9695 | **DUT** | IN  pkt #23 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 9695 | yapp monitor | RX pkt #23 on the input: addr=1 len=63 parity=bad gap=12 |
| 9695 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 9695 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 9700 | yapp driver | TX pkt #23 accepted by the DUT |
| 9700 | yapp driver | TX pkt #24: addr=3 len=41 parity=good delay=0 |
| 9705 | **DUT** | IN  pkt #24 header: addr=3 len=41 -> DROP (router disabled) |
| 10125 | **DUT** | IN  pkt #24 complete: addr=3 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 10125 | yapp monitor | RX pkt #24 on the input: addr=3 len=41 parity=good gap=0 |
| 10125 | reference | Packet dropped: router disabled (addr=3 len=41) |
| 10125 | **DUT** | ROUTER DROPS PACKET addr=3 length=41 (router disabled) |
| 10130 | yapp driver | TX pkt #24 accepted by the DUT |
| 10130 | yapp driver | TX pkt #25: addr=0 len=26 parity=good delay=1 |
| 10145 | **DUT** | IN  pkt #25 header: addr=0 len=26 -> DROP (router disabled) |
| 10415 | **DUT** | IN  pkt #25 complete: addr=0 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 10415 | yapp monitor | RX pkt #25 on the input: addr=0 len=26 parity=good gap=1 |
| 10415 | reference | Packet dropped: router disabled (addr=0 len=26) |
| 10415 | **DUT** | ROUTER DROPS PACKET addr=0 length=26 (router disabled) |
| 10420 | yapp driver | TX pkt #25 accepted by the DUT |
| 10420 | yapp driver | TX pkt #26: addr=2 len=63 parity=good delay=0 |
| 10425 | **DUT** | IN  pkt #26 header: addr=2 len=63 -> DROP (router disabled) |
| 11065 | **DUT** | IN  pkt #26 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11065 | yapp monitor | RX pkt #26 on the input: addr=2 len=63 parity=good gap=0 |
| 11065 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 11065 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 11070 | yapp driver | TX pkt #26 accepted by the DUT |
| 11070 | yapp driver | TX pkt #27: addr=0 len=63 parity=bad delay=0 |
| 11075 | **DUT** | IN  pkt #27 header: addr=0 len=63 -> DROP (router disabled) |
| 11715 | **DUT** | IN  pkt #27 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 11715 | yapp monitor | RX pkt #27 on the input: addr=0 len=63 parity=bad gap=0 |
| 11715 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 11715 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 11720 | yapp driver | TX pkt #27 accepted by the DUT |
| 11720 | **test** | STAGE: burst 2/6 sent: addr0..3 4/3/6/1, bad parity 3, gap 0 3, length 4..63 |
| 11740 | hbus driver | Executed WRITE addr=0x1000 data=0x3a |
| 11745 | **DUT** | CONFIG router_en=0 maxpktsize=58 |
| 11745 | hbus monitor | Collected WRITE addr=0x1000 data=0x3a |
| 11745 | reference | maxpktsize is now 58 |
| 11760 | hbus driver | Executed WRITE addr=0x1001 data=0x67 |
| 11765 | **DUT** | CONFIG router_en=1 maxpktsize=58 |
| 11765 | hbus monitor | Collected WRITE addr=0x1001 data=0x67 |
| 11765 | reference | router_en is now 1 (en_reg 0x67) |
| 11780 | hbus driver | Executed WRITE addr=0x11c4 data=0x1b |
| 11785 | hbus monitor | Collected WRITE addr=0x11c4 data=0x1b |
| 11810 | hbus driver | Executed READ  addr=0x11c4 data=0x1b |
| 11815 | hbus monitor | Collected READ  addr=0x11c4 data=0x1b |
| 11840 | hbus driver | Executed READ  addr=0x100d data=0x2d |
| 11845 | hbus monitor | Collected READ  addr=0x100d data=0x2d |
| 11860 | hbus driver | Executed WRITE addr=0x11ed data=0xa3 |
| 11865 | hbus monitor | Collected WRITE addr=0x11ed data=0xa3 |
| 11890 | hbus driver | Executed READ  addr=0x11ed data=0xa3 |
| 11895 | hbus monitor | Collected READ  addr=0x11ed data=0xa3 |
| 11920 | hbus driver | Executed READ  addr=0x102b data=0x73 |
| 11925 | hbus monitor | Collected READ  addr=0x102b data=0x73 |
| 11950 | hbus driver | Executed READ  addr=0x100d data=0x2d |
| 11955 | hbus monitor | Collected READ  addr=0x100d data=0x2d |
| 11980 | hbus driver | Executed READ  addr=0x100e data=0x00 |
| 11985 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12010 | hbus driver | Executed READ  addr=0x100d data=0x2d |
| 12015 | hbus monitor | Collected READ  addr=0x100d data=0x2d |
| 12040 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 12040 | **test** | STAGE: burst 3/6: ctrl=0x3a (maxpktsize 58) en=0x67 (router on, counter enables 0110011), 13 packet(s) |
| 12040 | yapp driver | TX pkt #28: addr=2 len=63 parity=good delay=0 |
| 12045 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12055 | **DUT** | IN  pkt #28 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 58) |
| 12695 | **DUT** | IN  pkt #28 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12695 | yapp monitor | RX pkt #28 on the input: addr=2 len=63 parity=good gap=33 |
| 12695 | reference | Packet dropped: length 63 > maxpktsize 58 (addr=2) |
| 12695 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 12700 | yapp driver | TX pkt #28 accepted by the DUT |
| 12700 | yapp driver | TX pkt #29: addr=2 len=57 parity=good delay=19 |
| 12895 | **DUT** | IN  pkt #29 header: addr=2 len=57 -> channel 2 |
| 12905 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=57 (receiver waited 0 cycle(s)) |
| 13475 | **DUT** | IN  pkt #29 complete: addr=2 len=57 parity=ok forwarded, 59 bytes in 59 cycles (held 0) |
| 13475 | yapp monitor | RX pkt #29 on the input: addr=2 len=57 parity=good gap=19 |
| 13475 | reference | Packet forwarded: addr=2 len=57 -> channel 2 |
| 13480 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13480 | yapp driver | TX pkt #29 accepted by the DUT |
| 13480 | yapp driver | TX pkt #30: addr=0 len=56 parity=good delay=0 |
| 13485 | **DUT** | IN  pkt #30 header: addr=0 len=56 -> channel 0 |
| 13495 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=56 (receiver waited 0 cycle(s)) |
| 13495 | **DUT** | OUT ch2 pkt #1 done: 59 bytes in 60 cycles |
| 13495 | ch2 monitor | ch2 RX pkt #1: addr=2 len=57 parity=good |
| 13495 | scoreboard | ch2 pkt matched: addr=2 len=57 (1 matched so far) |
| 13670 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14055 | **DUT** | IN  pkt #30 complete: addr=0 len=56 parity=ok forwarded, 58 bytes in 58 cycles (held 0) |
| 14055 | yapp monitor | RX pkt #30 on the input: addr=0 len=56 parity=good gap=0 |
| 14055 | reference | Packet forwarded: addr=0 len=56 -> channel 0 |
| 14060 | ch0 driver | ch0: packet consumed (response delay 0) |
| 14060 | yapp driver | TX pkt #30 accepted by the DUT |
| 14060 | yapp driver | TX pkt #31: addr=1 len=26 parity=good delay=0 |
| 14065 | **DUT** | IN  pkt #31 header: addr=1 len=26 -> channel 1 |
| 14075 | **DUT** | OUT ch0 pkt #1 done: 58 bytes in 59 cycles |
| 14075 | ch0 monitor | ch0 RX pkt #1: addr=0 len=56 parity=good |
| 14075 | scoreboard | ch0 pkt matched: addr=0 len=56 (2 matched so far) |
| 14165 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=26 (receiver waited 9 cycle(s)) |
| 14335 | **DUT** | IN  pkt #31 complete: addr=1 len=26 parity=ok forwarded, 28 bytes in 28 cycles (held 0) |
| 14335 | yapp monitor | RX pkt #31 on the input: addr=1 len=26 parity=good gap=0 |
| 14335 | reference | Packet forwarded: addr=1 len=26 -> channel 1 |
| 14340 | yapp driver | TX pkt #31 accepted by the DUT |
| 14340 | yapp driver | TX pkt #32: addr=2 len=52 parity=good delay=2 |
| 14365 | **DUT** | IN  pkt #32 header: addr=2 len=52 -> channel 2 |
| 14375 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=52 (receiver waited 0 cycle(s)) |
| 14430 | ch1 driver | ch1: packet consumed (response delay 9) |
| 14500 | ch0 driver | ch0: packet consumed (response delay 0) |
| 14545 | **DUT** | OUT ch1 pkt #1 done: 28 bytes in 39 cycles |
| 14545 | ch1 monitor | ch1 RX pkt #1: addr=1 len=26 parity=good |
| 14545 | scoreboard | ch1 pkt matched: addr=1 len=26 (3 matched so far) |
| 14895 | **DUT** | IN  pkt #32 complete: addr=2 len=52 parity=ok forwarded, 54 bytes in 54 cycles (held 0) |
| 14895 | yapp monitor | RX pkt #32 on the input: addr=2 len=52 parity=good gap=2 |
| 14895 | reference | Packet forwarded: addr=2 len=52 -> channel 2 |
| 14900 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14900 | yapp driver | TX pkt #32 accepted by the DUT |
| 14900 | yapp driver | TX pkt #33: addr=2 len=14 parity=good delay=2 |
| 14915 | **DUT** | OUT ch2 pkt #2 done: 54 bytes in 55 cycles |
| 14915 | ch2 monitor | ch2 RX pkt #2: addr=2 len=52 parity=good |
| 14915 | scoreboard | ch2 pkt matched: addr=2 len=52 (4 matched so far) |
| 14925 | **DUT** | IN  pkt #33 header: addr=2 len=14 -> channel 2 |
| 14935 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=14 (receiver waited 0 cycle(s)) |
| 14990 | ch2 driver | ch2: packet consumed (response delay 0) |
| 15030 | ch1 driver | ch1: packet consumed (response delay 10) |
| 15075 | **DUT** | IN  pkt #33 complete: addr=2 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 15075 | yapp monitor | RX pkt #33 on the input: addr=2 len=14 parity=good gap=2 |
| 15075 | reference | Packet forwarded: addr=2 len=14 -> channel 2 |
| 15080 | yapp driver | TX pkt #33 accepted by the DUT |
| 15080 | yapp driver | TX pkt #34: addr=0 len=9 parity=good delay=3 |
| 15095 | **DUT** | OUT ch2 pkt #3 done: 16 bytes in 17 cycles |
| 15095 | ch2 monitor | ch2 RX pkt #3: addr=2 len=14 parity=good |
| 15095 | scoreboard | ch2 pkt matched: addr=2 len=14 (5 matched so far) |
| 15110 | ch2 driver | ch2: packet consumed (response delay 0) |
| 15115 | **DUT** | IN  pkt #34 header: addr=0 len=9 -> channel 0 |
| 15125 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=9 (receiver waited 0 cycle(s)) |
| 15215 | **DUT** | IN  pkt #34 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 15215 | yapp monitor | RX pkt #34 on the input: addr=0 len=9 parity=good gap=3 |
| 15215 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 15220 | ch0 driver | ch0: packet consumed (response delay 0) |
| 15220 | yapp driver | TX pkt #34 accepted by the DUT |
| 15220 | yapp driver | TX pkt #35: addr=2 len=48 parity=good delay=20 |
| 15235 | **DUT** | OUT ch0 pkt #2 done: 11 bytes in 12 cycles |
| 15235 | ch0 monitor | ch0 RX pkt #2: addr=0 len=9 parity=good |
| 15235 | scoreboard | ch0 pkt matched: addr=0 len=9 (6 matched so far) |
| 15370 | ch0 driver | ch0: packet consumed (response delay 0) |
| 15425 | **DUT** | IN  pkt #35 header: addr=2 len=48 -> channel 2 |
| 15435 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=48 (receiver waited 0 cycle(s)) |
| 15915 | **DUT** | IN  pkt #35 complete: addr=2 len=48 parity=ok forwarded, 50 bytes in 50 cycles (held 0) |
| 15915 | yapp monitor | RX pkt #35 on the input: addr=2 len=48 parity=good gap=20 |
| 15915 | reference | Packet forwarded: addr=2 len=48 -> channel 2 |
| 15920 | ch2 driver | ch2: packet consumed (response delay 0) |
| 15920 | yapp driver | TX pkt #35 accepted by the DUT |
| 15920 | yapp driver | TX pkt #36: addr=2 len=61 parity=good delay=0 |
| 15925 | **DUT** | IN  pkt #36 header: addr=2 len=61 -> DROP (oversized: len 61 > maxpktsize 58) |
| 15935 | **DUT** | OUT ch2 pkt #4 done: 50 bytes in 51 cycles |
| 15935 | ch2 monitor | ch2 RX pkt #4: addr=2 len=48 parity=good |
| 15935 | scoreboard | ch2 pkt matched: addr=2 len=48 (7 matched so far) |
| 16220 | ch2 driver | ch2: packet consumed (response delay 0) |
| 16545 | **DUT** | IN  pkt #36 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 16545 | yapp monitor | RX pkt #36 on the input: addr=2 len=61 parity=good gap=0 |
| 16545 | reference | Packet dropped: length 61 > maxpktsize 58 (addr=2) |
| 16545 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (length > maxpktsize) |
| 16550 | yapp driver | TX pkt #36 accepted by the DUT |
| 16550 | yapp driver | TX pkt #37: addr=0 len=9 parity=good delay=0 |
| 16555 | **DUT** | IN  pkt #37 header: addr=0 len=9 -> channel 0 |
| 16565 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=9 (receiver waited 0 cycle(s)) |
| 16655 | **DUT** | IN  pkt #37 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 16655 | yapp monitor | RX pkt #37 on the input: addr=0 len=9 parity=good gap=0 |
| 16655 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 16660 | ch0 driver | ch0: packet consumed (response delay 0) |
| 16660 | yapp driver | TX pkt #37 accepted by the DUT |
| 16660 | yapp driver | TX pkt #38: addr=3 len=63 parity=good delay=18 |
| 16675 | **DUT** | OUT ch0 pkt #3 done: 11 bytes in 12 cycles |
| 16675 | ch0 monitor | ch0 RX pkt #3: addr=0 len=9 parity=good |
| 16675 | scoreboard | ch0 pkt matched: addr=0 len=9 (8 matched so far) |
| 16845 | **DUT** | IN  pkt #38 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 58) |
| 17170 | ch0 driver | ch0: packet consumed (response delay 0) |
| 17485 | **DUT** | IN  pkt #38 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 17485 | yapp monitor | RX pkt #38 on the input: addr=3 len=63 parity=good gap=18 |
| 17485 | reference | Packet dropped: illegal address 3 (len=63) |
| 17485 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 17490 | yapp driver | TX pkt #38 accepted by the DUT |
| 17490 | yapp driver | TX pkt #39: addr=0 len=51 parity=good delay=3 |
| 17525 | **DUT** | IN  pkt #39 header: addr=0 len=51 -> channel 0 |
| 17535 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=51 (receiver waited 0 cycle(s)) |
| 18045 | **DUT** | IN  pkt #39 complete: addr=0 len=51 parity=ok forwarded, 53 bytes in 53 cycles (held 0) |
| 18045 | yapp monitor | RX pkt #39 on the input: addr=0 len=51 parity=good gap=3 |
| 18045 | reference | Packet forwarded: addr=0 len=51 -> channel 0 |
| 18050 | ch0 driver | ch0: packet consumed (response delay 0) |
| 18050 | yapp driver | TX pkt #39 accepted by the DUT |
| 18050 | yapp driver | TX pkt #40: addr=0 len=62 parity=good delay=0 |
| 18055 | **DUT** | IN  pkt #40 header: addr=0 len=62 -> DROP (oversized: len 62 > maxpktsize 58) |
| 18065 | **DUT** | OUT ch0 pkt #4 done: 53 bytes in 54 cycles |
| 18065 | ch0 monitor | ch0 RX pkt #4: addr=0 len=51 parity=good |
| 18065 | scoreboard | ch0 pkt matched: addr=0 len=51 (9 matched so far) |
| 18290 | ch0 driver | ch0: packet consumed (response delay 0) |
| 18685 | **DUT** | IN  pkt #40 complete: addr=0 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 18685 | yapp monitor | RX pkt #40 on the input: addr=0 len=62 parity=good gap=0 |
| 18685 | reference | Packet dropped: length 62 > maxpktsize 58 (addr=0) |
| 18685 | **DUT** | ROUTER DROPS PACKET addr=0 length=62 (length > maxpktsize) |
| 18690 | yapp driver | TX pkt #40 accepted by the DUT |
| 18690 | **test** | STAGE: burst 3/6 sent: addr0..3 5/1/6/1, bad parity 0, gap 0 6, length 9..63 |
| 18710 | hbus driver | Executed WRITE addr=0x1000 data=0x19 |
| 18715 | **DUT** | CONFIG router_en=1 maxpktsize=25 |
| 18715 | hbus monitor | Collected WRITE addr=0x1000 data=0x19 |
| 18715 | reference | maxpktsize is now 25 |
| 18730 | hbus driver | Executed WRITE addr=0x1001 data=0x5f |
| 18735 | hbus monitor | Collected WRITE addr=0x1001 data=0x5f |
| 18735 | reference | router_en is now 1 (en_reg 0x5f) |
| 18760 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 18765 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 18790 | hbus driver | Executed READ  addr=0x1005 data=0x11 |
| 18795 | hbus monitor | Collected READ  addr=0x1005 data=0x11 |
| 18810 | hbus driver | Executed WRITE addr=0x115b data=0xae |
| 18815 | hbus monitor | Collected WRITE addr=0x115b data=0xae |
| 18840 | hbus driver | Executed READ  addr=0x115b data=0xae |
| 18845 | hbus monitor | Collected READ  addr=0x115b data=0xae |
| 18860 | hbus driver | Executed WRITE addr=0x11d5 data=0x31 |
| 18865 | hbus monitor | Collected WRITE addr=0x11d5 data=0x31 |
| 18890 | hbus driver | Executed READ  addr=0x11d5 data=0x31 |
| 18890 | **test** | STAGE: burst 4/6: ctrl=0x19 (maxpktsize 25) en=0x5f (router on, counter enables 0101111), 13 packet(s) |
| 18890 | yapp driver | TX pkt #41: addr=2 len=24 parity=good delay=0 |
| 18895 | hbus monitor | Collected READ  addr=0x11d5 data=0x31 |
| 18905 | **DUT** | IN  pkt #41 header: addr=2 len=24 -> channel 2 |
| 18915 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=24 (receiver waited 0 cycle(s)) |
| 19155 | **DUT** | IN  pkt #41 complete: addr=2 len=24 parity=ok forwarded, 26 bytes in 26 cycles (held 0) |
| 19155 | yapp monitor | RX pkt #41 on the input: addr=2 len=24 parity=good gap=21 |
| 19155 | reference | Packet forwarded: addr=2 len=24 -> channel 2 |
| 19160 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19160 | yapp driver | TX pkt #41 accepted by the DUT |
| 19160 | yapp driver | TX pkt #42: addr=0 len=12 parity=good delay=1 |
| 19175 | **DUT** | IN  pkt #42 header: addr=0 len=12 -> channel 0 |
| 19175 | **DUT** | OUT ch2 pkt #5 done: 26 bytes in 27 cycles |
| 19175 | ch2 monitor | ch2 RX pkt #5: addr=2 len=24 parity=good |
| 19175 | scoreboard | ch2 pkt matched: addr=2 len=24 (10 matched so far) |
| 19185 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=12 (receiver waited 0 cycle(s)) |
| 19305 | **DUT** | IN  pkt #42 complete: addr=0 len=12 parity=ok forwarded, 14 bytes in 14 cycles (held 0) |
| 19305 | yapp monitor | RX pkt #42 on the input: addr=0 len=12 parity=good gap=1 |
| 19305 | reference | Packet forwarded: addr=0 len=12 -> channel 0 |
| 19310 | ch0 driver | ch0: packet consumed (response delay 0) |
| 19310 | yapp driver | TX pkt #42 accepted by the DUT |
| 19310 | yapp driver | TX pkt #43: addr=1 len=48 parity=good delay=5 |
| 19325 | **DUT** | OUT ch0 pkt #5 done: 14 bytes in 15 cycles |
| 19325 | ch0 monitor | ch0 RX pkt #5: addr=0 len=12 parity=good |
| 19325 | scoreboard | ch0 pkt matched: addr=0 len=12 (11 matched so far) |
| 19365 | **DUT** | IN  pkt #43 header: addr=1 len=48 -> DROP (oversized: len 48 > maxpktsize 25) |
| 19430 | ch0 driver | ch0: packet consumed (response delay 0) |
| 19800 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19855 | **DUT** | IN  pkt #43 complete: addr=1 len=48 parity=ok dropped, 50 bytes in 50 cycles (held 0) |
| 19855 | yapp monitor | RX pkt #43 on the input: addr=1 len=48 parity=good gap=5 |
| 19855 | reference | Packet dropped: length 48 > maxpktsize 25 (addr=1) |
| 19855 | **DUT** | ROUTER DROPS PACKET addr=1 length=48 (length > maxpktsize) |
| 19860 | yapp driver | TX pkt #43 accepted by the DUT |
| 19860 | yapp driver | TX pkt #44: addr=1 len=14 parity=good delay=1 |
| 19875 | **DUT** | IN  pkt #44 header: addr=1 len=14 -> channel 1 |
| 19965 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=14 (receiver waited 8 cycle(s)) |
| 20025 | **DUT** | IN  pkt #44 complete: addr=1 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 20025 | yapp monitor | RX pkt #44 on the input: addr=1 len=14 parity=good gap=1 |
| 20025 | reference | Packet forwarded: addr=1 len=14 -> channel 1 |
| 20030 | yapp driver | TX pkt #44 accepted by the DUT |
| 20030 | yapp driver | TX pkt #45: addr=2 len=58 parity=good delay=1 |
| 20045 | **DUT** | IN  pkt #45 header: addr=2 len=58 -> DROP (oversized: len 58 > maxpktsize 25) |
| 20110 | ch1 driver | ch1: packet consumed (response delay 8) |
| 20225 | **DUT** | OUT ch1 pkt #2 done: 16 bytes in 27 cycles |
| 20225 | ch1 monitor | ch1 RX pkt #2: addr=1 len=14 parity=good |
| 20225 | scoreboard | ch1 pkt matched: addr=1 len=14 (12 matched so far) |
| 20380 | ch1 driver | ch1: packet consumed (response delay 10) |
| 20635 | **DUT** | IN  pkt #45 complete: addr=2 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 20635 | yapp monitor | RX pkt #45 on the input: addr=2 len=58 parity=good gap=1 |
| 20635 | reference | Packet dropped: length 58 > maxpktsize 25 (addr=2) |
| 20635 | **DUT** | ROUTER DROPS PACKET addr=2 length=58 (length > maxpktsize) |
| 20640 | yapp driver | TX pkt #45 accepted by the DUT |
| 20640 | yapp driver | TX pkt #46: addr=2 len=25 parity=good delay=7 |
| 20715 | **DUT** | IN  pkt #46 header: addr=2 len=25 -> channel 2 |
| 20725 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=25 (receiver waited 0 cycle(s)) |
| 20975 | **DUT** | IN  pkt #46 complete: addr=2 len=25 parity=ok forwarded, 27 bytes in 27 cycles (held 0) |
| 20975 | yapp monitor | RX pkt #46 on the input: addr=2 len=25 parity=good gap=7 |
| 20975 | reference | Packet forwarded: addr=2 len=25 -> channel 2 |
| 20980 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20980 | yapp driver | TX pkt #46 accepted by the DUT |
| 20980 | yapp driver | TX pkt #47: addr=2 len=25 parity=bad delay=1 |
| 20995 | **DUT** | IN  pkt #47 header: addr=2 len=25 -> channel 2 |
| 20995 | **DUT** | OUT ch2 pkt #6 done: 27 bytes in 28 cycles |
| 20995 | ch2 monitor | ch2 RX pkt #6: addr=2 len=25 parity=good |
| 20995 | scoreboard | ch2 pkt matched: addr=2 len=25 (13 matched so far) |
| 21005 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=25 (receiver waited 0 cycle(s)) |
| 21255 | **DUT** | IN  pkt #47 complete: addr=2 len=25 parity=BAD forwarded, 27 bytes in 27 cycles (held 0) |
| 21255 | yapp monitor | RX pkt #47 on the input: addr=2 len=25 parity=bad gap=1 |
| 21255 | reference | Packet forwarded: addr=2 len=25 -> channel 2 |
| 21260 | yapp driver | TX pkt #47 accepted by the DUT |
| 21260 | yapp driver | TX pkt #48: addr=2 len=41 parity=good delay=1 |
| 21265 | **DUT** | OUT ch2 pkt #7 done: 27 bytes in 27 cycles |
| 21265 | ch2 monitor | ch2 RX pkt #7: addr=2 len=25 parity=bad |
| 21265 | scoreboard | ch2 pkt matched: addr=2 len=25 (14 matched so far) |
| 21275 | **DUT** | IN  pkt #48 header: addr=2 len=41 -> DROP (oversized: len 41 > maxpktsize 25) |
| 21350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 21350 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 21470 | ch2 driver | ch2: packet consumed (response delay 0) |
| 21695 | **DUT** | IN  pkt #48 complete: addr=2 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 21695 | yapp monitor | RX pkt #48 on the input: addr=2 len=41 parity=good gap=1 |
| 21695 | reference | Packet dropped: length 41 > maxpktsize 25 (addr=2) |
| 21695 | **DUT** | ROUTER DROPS PACKET addr=2 length=41 (length > maxpktsize) |
| 21700 | yapp driver | TX pkt #48 accepted by the DUT |
| 21700 | yapp driver | TX pkt #49: addr=2 len=63 parity=good delay=0 |
| 21705 | **DUT** | IN  pkt #49 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 25) |
| 22345 | **DUT** | IN  pkt #49 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 22345 | yapp monitor | RX pkt #49 on the input: addr=2 len=63 parity=good gap=0 |
| 22345 | reference | Packet dropped: length 63 > maxpktsize 25 (addr=2) |
| 22345 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 22350 | yapp driver | TX pkt #49 accepted by the DUT |
| 22350 | yapp driver | TX pkt #50: addr=1 len=23 parity=good delay=0 |
| 22355 | **DUT** | IN  pkt #50 header: addr=1 len=23 -> channel 1 |
| 22465 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=23 (receiver waited 10 cycle(s)) |
| 22595 | **DUT** | IN  pkt #50 complete: addr=1 len=23 parity=ok forwarded, 25 bytes in 25 cycles (held 0) |
| 22595 | yapp monitor | RX pkt #50 on the input: addr=1 len=23 parity=good gap=0 |
| 22595 | reference | Packet forwarded: addr=1 len=23 -> channel 1 |
| 22600 | yapp driver | TX pkt #50 accepted by the DUT |
| 22600 | yapp driver | TX pkt #51: addr=2 len=63 parity=good delay=1 |
| 22615 | **DUT** | IN  pkt #51 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 25) |
| 22700 | ch1 driver | ch1: packet consumed (response delay 10) |
| 22755 | **DUT** | OUT ch1 pkt #3 done: 25 bytes in 30 cycles |
| 22755 | ch1 monitor | ch1 RX pkt #3: addr=1 len=23 parity=good |
| 22755 | scoreboard | ch1 pkt matched: addr=1 len=23 (15 matched so far) |
| 22810 | ch1 driver | ch1: packet consumed (response delay 4) |
| 23255 | **DUT** | IN  pkt #51 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 23255 | yapp monitor | RX pkt #51 on the input: addr=2 len=63 parity=good gap=1 |
| 23255 | reference | Packet dropped: length 63 > maxpktsize 25 (addr=2) |
| 23255 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 23260 | yapp driver | TX pkt #51 accepted by the DUT |
| 23260 | yapp driver | TX pkt #52: addr=2 len=32 parity=good delay=0 |
| 23265 | **DUT** | IN  pkt #52 header: addr=2 len=32 -> DROP (oversized: len 32 > maxpktsize 25) |
| 23595 | **DUT** | IN  pkt #52 complete: addr=2 len=32 parity=ok dropped, 34 bytes in 34 cycles (held 0) |
| 23595 | yapp monitor | RX pkt #52 on the input: addr=2 len=32 parity=good gap=0 |
| 23595 | reference | Packet dropped: length 32 > maxpktsize 25 (addr=2) |
| 23595 | **DUT** | ROUTER DROPS PACKET addr=2 length=32 (length > maxpktsize) |
| 23600 | yapp driver | TX pkt #52 accepted by the DUT |
| 23600 | yapp driver | TX pkt #53: addr=2 len=21 parity=bad delay=3 |
| 23635 | **DUT** | IN  pkt #53 header: addr=2 len=21 -> channel 2 |
| 23645 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=21 (receiver waited 0 cycle(s)) |
| 23855 | **DUT** | IN  pkt #53 complete: addr=2 len=21 parity=BAD forwarded, 23 bytes in 23 cycles (held 0) |
| 23855 | yapp monitor | RX pkt #53 on the input: addr=2 len=21 parity=bad gap=3 |
| 23855 | reference | Packet forwarded: addr=2 len=21 -> channel 2 |
| 23860 | ch2 driver | ch2: packet consumed (response delay 0) |
| 23860 | yapp driver | TX pkt #53 accepted by the DUT |
| 23860 | **test** | STAGE: burst 4/6 sent: addr0..3 1/3/9/0, bad parity 2, gap 0 4, length 12..63 |
| 23875 | **DUT** | OUT ch2 pkt #8 done: 23 bytes in 24 cycles |
| 23875 | ch2 monitor | ch2 RX pkt #8: addr=2 len=21 parity=bad |
| 23875 | scoreboard | ch2 pkt matched: addr=2 len=21 (16 matched so far) |
| 23880 | hbus driver | Executed WRITE addr=0x1000 data=0x02 |
| 23885 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 23885 | hbus monitor | Collected WRITE addr=0x1000 data=0x02 |
| 23885 | reference | maxpktsize is now 2 |
| 23890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 23890 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 23900 | hbus driver | Executed WRITE addr=0x1001 data=0x49 |
| 23905 | hbus monitor | Collected WRITE addr=0x1001 data=0x49 |
| 23905 | reference | router_en is now 1 (en_reg 0x49) |
| 23920 | hbus driver | Executed WRITE addr=0x113e data=0x2d |
| 23925 | hbus monitor | Collected WRITE addr=0x113e data=0x2d |
| 23950 | hbus driver | Executed READ  addr=0x113e data=0x2d |
| 23955 | hbus monitor | Collected READ  addr=0x113e data=0x2d |
| 23970 | hbus driver | Executed WRITE addr=0x11bc data=0xa1 |
| 23975 | hbus monitor | Collected WRITE addr=0x11bc data=0xa1 |
| 24000 | hbus driver | Executed READ  addr=0x11bc data=0xa1 |
| 24005 | hbus monitor | Collected READ  addr=0x11bc data=0xa1 |
| 24030 | hbus driver | Executed READ  addr=0x1004 data=0x02 |
| 24030 | **test** | STAGE: burst 5/6: ctrl=0x02 (maxpktsize 2) en=0x49 (router on, counter enables 0100100), 13 packet(s) |
| 24030 | yapp driver | TX pkt #54: addr=1 len=44 parity=good delay=20 |
| 24035 | hbus monitor | Collected READ  addr=0x1004 data=0x02 |
| 24245 | **DUT** | IN  pkt #54 header: addr=1 len=44 -> DROP (oversized: len 44 > maxpktsize 2) |
| 24430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24695 | **DUT** | IN  pkt #54 complete: addr=1 len=44 parity=ok dropped, 46 bytes in 46 cycles (held 0) |
| 24695 | yapp monitor | RX pkt #54 on the input: addr=1 len=44 parity=good gap=38 |
| 24695 | reference | Packet dropped: length 44 > maxpktsize 2 (addr=1) |
| 24695 | **DUT** | ROUTER DROPS PACKET addr=1 length=44 (length > maxpktsize) |
| 24700 | yapp driver | TX pkt #54 accepted by the DUT |
| 24700 | yapp driver | TX pkt #55: addr=0 len=17 parity=good delay=1 |
| 24715 | **DUT** | IN  pkt #55 header: addr=0 len=17 -> DROP (oversized: len 17 > maxpktsize 2) |
| 24895 | **DUT** | IN  pkt #55 complete: addr=0 len=17 parity=ok dropped, 19 bytes in 19 cycles (held 0) |
| 24895 | yapp monitor | RX pkt #55 on the input: addr=0 len=17 parity=good gap=1 |
| 24895 | reference | Packet dropped: length 17 > maxpktsize 2 (addr=0) |
| 24895 | **DUT** | ROUTER DROPS PACKET addr=0 length=17 (length > maxpktsize) |
| 24900 | yapp driver | TX pkt #55 accepted by the DUT |
| 24900 | yapp driver | TX pkt #56: addr=2 len=6 parity=good delay=0 |
| 24905 | **DUT** | IN  pkt #56 header: addr=2 len=6 -> DROP (oversized: len 6 > maxpktsize 2) |
| 24975 | **DUT** | IN  pkt #56 complete: addr=2 len=6 parity=ok dropped, 8 bytes in 8 cycles (held 0) |
| 24975 | yapp monitor | RX pkt #56 on the input: addr=2 len=6 parity=good gap=0 |
| 24975 | reference | Packet dropped: length 6 > maxpktsize 2 (addr=2) |
| 24975 | **DUT** | ROUTER DROPS PACKET addr=2 length=6 (length > maxpktsize) |
| 24980 | yapp driver | TX pkt #56 accepted by the DUT |
| 24980 | yapp driver | TX pkt #57: addr=2 len=3 parity=good delay=20 |
| 25185 | **DUT** | IN  pkt #57 header: addr=2 len=3 -> DROP (oversized: len 3 > maxpktsize 2) |
| 25225 | **DUT** | IN  pkt #57 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 25225 | yapp monitor | RX pkt #57 on the input: addr=2 len=3 parity=good gap=20 |
| 25225 | reference | Packet dropped: length 3 > maxpktsize 2 (addr=2) |
| 25225 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (length > maxpktsize) |
| 25230 | yapp driver | TX pkt #57 accepted by the DUT |
| 25230 | yapp driver | TX pkt #58: addr=1 len=63 parity=good delay=3 |
| 25265 | **DUT** | IN  pkt #58 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 2) |
| 25905 | **DUT** | IN  pkt #58 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 25905 | yapp monitor | RX pkt #58 on the input: addr=1 len=63 parity=good gap=3 |
| 25905 | reference | Packet dropped: length 63 > maxpktsize 2 (addr=1) |
| 25905 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 25910 | yapp driver | TX pkt #58 accepted by the DUT |
| 25910 | yapp driver | TX pkt #59: addr=2 len=20 parity=good delay=3 |
| 25945 | **DUT** | IN  pkt #59 header: addr=2 len=20 -> DROP (oversized: len 20 > maxpktsize 2) |
| 26155 | **DUT** | IN  pkt #59 complete: addr=2 len=20 parity=ok dropped, 22 bytes in 22 cycles (held 0) |
| 26155 | yapp monitor | RX pkt #59 on the input: addr=2 len=20 parity=good gap=3 |
| 26155 | reference | Packet dropped: length 20 > maxpktsize 2 (addr=2) |
| 26155 | **DUT** | ROUTER DROPS PACKET addr=2 length=20 (length > maxpktsize) |
| 26160 | yapp driver | TX pkt #59 accepted by the DUT |
| 26160 | yapp driver | TX pkt #60: addr=1 len=16 parity=bad delay=20 |
| 26365 | **DUT** | IN  pkt #60 header: addr=1 len=16 -> DROP (oversized: len 16 > maxpktsize 2) |
| 26535 | **DUT** | IN  pkt #60 complete: addr=1 len=16 parity=BAD dropped, 18 bytes in 18 cycles (held 0) |
| 26535 | yapp monitor | RX pkt #60 on the input: addr=1 len=16 parity=bad gap=20 |
| 26535 | reference | Packet dropped: length 16 > maxpktsize 2 (addr=1) |
| 26535 | **DUT** | ROUTER DROPS PACKET addr=1 length=16 (length > maxpktsize) |
| 26540 | yapp driver | TX pkt #60 accepted by the DUT |
| 26540 | yapp driver | TX pkt #61: addr=1 len=51 parity=good delay=1 |
| 26555 | **DUT** | IN  pkt #61 header: addr=1 len=51 -> DROP (oversized: len 51 > maxpktsize 2) |
| 26630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 26630 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 27075 | **DUT** | IN  pkt #61 complete: addr=1 len=51 parity=ok dropped, 53 bytes in 53 cycles (held 0) |
| 27075 | yapp monitor | RX pkt #61 on the input: addr=1 len=51 parity=good gap=1 |
| 27075 | reference | Packet dropped: length 51 > maxpktsize 2 (addr=1) |
| 27075 | **DUT** | ROUTER DROPS PACKET addr=1 length=51 (length > maxpktsize) |
| 27080 | yapp driver | TX pkt #61 accepted by the DUT |
| 27080 | yapp driver | TX pkt #62: addr=2 len=1 parity=good delay=15 |
| 27235 | **DUT** | IN  pkt #62 header: addr=2 len=1 -> channel 2 |
| 27245 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 27255 | **DUT** | IN  pkt #62 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27255 | yapp monitor | RX pkt #62 on the input: addr=2 len=1 parity=good gap=15 |
| 27255 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 27260 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27260 | yapp driver | TX pkt #62 accepted by the DUT |
| 27260 | yapp driver | TX pkt #63: addr=1 len=2 parity=good delay=4 |
| 27275 | **DUT** | OUT ch2 pkt #9 done: 3 bytes in 4 cycles |
| 27275 | ch2 monitor | ch2 RX pkt #9: addr=2 len=1 parity=good |
| 27275 | scoreboard | ch2 pkt matched: addr=2 len=1 (17 matched so far) |
| 27305 | **DUT** | IN  pkt #63 header: addr=1 len=2 -> channel 1 |
| 27335 | **DUT** | IN  pkt #63 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 27335 | yapp monitor | RX pkt #63 on the input: addr=1 len=2 parity=good gap=4 |
| 27335 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 27340 | yapp driver | TX pkt #63 accepted by the DUT |
| 27340 | yapp driver | TX pkt #64: addr=0 len=5 parity=bad delay=3 |
| 27345 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=2 (receiver waited 3 cycle(s)) |
| 27370 | ch1 driver | ch1: packet consumed (response delay 3) |
| 27375 | **DUT** | IN  pkt #64 header: addr=0 len=5 -> DROP (oversized: len 5 > maxpktsize 2) |
| 27405 | **DUT** | OUT ch1 pkt #4 done: 4 bytes in 7 cycles |
| 27405 | ch1 monitor | ch1 RX pkt #4: addr=1 len=2 parity=good |
| 27405 | scoreboard | ch1 pkt matched: addr=1 len=2 (18 matched so far) |
| 27435 | **DUT** | IN  pkt #64 complete: addr=0 len=5 parity=BAD dropped, 7 bytes in 7 cycles (held 0) |
| 27435 | yapp monitor | RX pkt #64 on the input: addr=0 len=5 parity=bad gap=3 |
| 27435 | reference | Packet dropped: length 5 > maxpktsize 2 (addr=0) |
| 27435 | **DUT** | ROUTER DROPS PACKET addr=0 length=5 (length > maxpktsize) |
| 27440 | yapp driver | TX pkt #64 accepted by the DUT |
| 27440 | yapp driver | TX pkt #65: addr=1 len=63 parity=good delay=0 |
| 27445 | **DUT** | IN  pkt #65 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 2) |
| 27470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 27470 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 27540 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27650 | ch1 driver | ch1: packet consumed (response delay 2) |
| 28085 | **DUT** | IN  pkt #65 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 28085 | yapp monitor | RX pkt #65 on the input: addr=1 len=63 parity=good gap=0 |
| 28085 | reference | Packet dropped: length 63 > maxpktsize 2 (addr=1) |
| 28085 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 28090 | yapp driver | TX pkt #65 accepted by the DUT |
| 28090 | yapp driver | TX pkt #66: addr=2 len=62 parity=good delay=20 |
| 28295 | **DUT** | IN  pkt #66 header: addr=2 len=62 -> DROP (oversized: len 62 > maxpktsize 2) |
| 28925 | **DUT** | IN  pkt #66 complete: addr=2 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 28925 | yapp monitor | RX pkt #66 on the input: addr=2 len=62 parity=good gap=20 |
| 28925 | reference | Packet dropped: length 62 > maxpktsize 2 (addr=2) |
| 28925 | **DUT** | ROUTER DROPS PACKET addr=2 length=62 (length > maxpktsize) |
| 28930 | yapp driver | TX pkt #66 accepted by the DUT |
| 28930 | **test** | STAGE: burst 5/6 sent: addr0..3 2/6/5/0, bad parity 2, gap 0 2, length 1..63 |
| 28950 | hbus driver | Executed WRITE addr=0x1000 data=0x5b |
| 28955 | **DUT** | CONFIG router_en=1 maxpktsize=27 |
| 28955 | hbus monitor | Collected WRITE addr=0x1000 data=0x5b |
| 28955 | reference | maxpktsize is now 27 |
| 28970 | hbus driver | Executed WRITE addr=0x1001 data=0xb5 |
| 28975 | hbus monitor | Collected WRITE addr=0x1001 data=0xb5 |
| 28975 | reference | router_en is now 1 (en_reg 0xb5) |
| 28990 | hbus driver | Executed WRITE addr=0x11ed data=0xdf |
| 28995 | hbus monitor | Collected WRITE addr=0x11ed data=0xdf |
| 29020 | hbus driver | Executed READ  addr=0x11ed data=0xdf |
| 29025 | hbus monitor | Collected READ  addr=0x11ed data=0xdf |
| 29040 | hbus driver | Executed WRITE addr=0x1142 data=0x78 |
| 29045 | hbus monitor | Collected WRITE addr=0x1142 data=0x78 |
| 29070 | hbus driver | Executed READ  addr=0x1142 data=0x78 |
| 29075 | hbus monitor | Collected READ  addr=0x1142 data=0x78 |
| 29100 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 29105 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 29130 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 29135 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29150 | hbus driver | Executed WRITE addr=0x114c data=0x4c |
| 29155 | hbus monitor | Collected WRITE addr=0x114c data=0x4c |
| 29180 | hbus driver | Executed READ  addr=0x114c data=0x4c |
| 29185 | hbus monitor | Collected READ  addr=0x114c data=0x4c |
| 29210 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 29215 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 29240 | hbus driver | Executed READ  addr=0x1001 data=0xb5 |
| 29240 | **test** | STAGE: burst 6/6: ctrl=0x5b (maxpktsize 27) en=0xb5 (router on, counter enables 1011010), 14 packet(s) |
| 29240 | yapp driver | TX pkt #67: addr=0 len=41 parity=bad delay=0 |
| 29245 | hbus monitor | Collected READ  addr=0x1001 data=0xb5 |
| 29255 | **DUT** | IN  pkt #67 header: addr=0 len=41 -> DROP (oversized: len 41 > maxpktsize 27) |
| 29675 | **DUT** | IN  pkt #67 complete: addr=0 len=41 parity=BAD dropped, 43 bytes in 43 cycles (held 0) |
| 29675 | yapp monitor | RX pkt #67 on the input: addr=0 len=41 parity=bad gap=32 |
| 29675 | reference | Packet dropped: length 41 > maxpktsize 27 (addr=0) |
| 29675 | **DUT** | ROUTER DROPS PACKET addr=0 length=41 (length > maxpktsize) |
| 29680 | yapp driver | TX pkt #67 accepted by the DUT |
| 29680 | yapp driver | TX pkt #68: addr=2 len=19 parity=good delay=0 |
| 29685 | **DUT** | IN  pkt #68 header: addr=2 len=19 -> channel 2 |
| 29695 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=19 (receiver waited 0 cycle(s)) |
| 29710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 29710 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 29885 | **DUT** | IN  pkt #68 complete: addr=2 len=19 parity=ok forwarded, 21 bytes in 21 cycles (held 0) |
| 29885 | yapp monitor | RX pkt #68 on the input: addr=2 len=19 parity=good gap=0 |
| 29885 | reference | Packet forwarded: addr=2 len=19 -> channel 2 |
| 29890 | ch2 driver | ch2: packet consumed (response delay 0) |
| 29890 | yapp driver | TX pkt #68 accepted by the DUT |
| 29890 | yapp driver | TX pkt #69: addr=0 len=27 parity=good delay=1 |
| 29905 | **DUT** | IN  pkt #69 header: addr=0 len=27 -> channel 0 |
| 29905 | **DUT** | OUT ch2 pkt #10 done: 21 bytes in 22 cycles |
| 29905 | ch2 monitor | ch2 RX pkt #10: addr=2 len=19 parity=good |
| 29905 | scoreboard | ch2 pkt matched: addr=2 len=19 (19 matched so far) |
| 29915 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=27 (receiver waited 0 cycle(s)) |
| 30185 | **DUT** | IN  pkt #69 complete: addr=0 len=27 parity=ok forwarded, 29 bytes in 29 cycles (held 0) |
| 30185 | yapp monitor | RX pkt #69 on the input: addr=0 len=27 parity=good gap=1 |
| 30185 | reference | Packet forwarded: addr=0 len=27 -> channel 0 |
| 30190 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30190 | yapp driver | TX pkt #69 accepted by the DUT |
| 30190 | yapp driver | TX pkt #70: addr=1 len=24 parity=good delay=20 |
| 30205 | **DUT** | OUT ch0 pkt #6 done: 29 bytes in 30 cycles |
| 30205 | ch0 monitor | ch0 RX pkt #6: addr=0 len=27 parity=good |
| 30205 | scoreboard | ch0 pkt matched: addr=0 len=27 (20 matched so far) |
| 30395 | **DUT** | IN  pkt #70 header: addr=1 len=24 -> channel 1 |
| 30405 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=24 (receiver waited 0 cycle(s)) |
| 30490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 30580 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30645 | **DUT** | IN  pkt #70 complete: addr=1 len=24 parity=ok forwarded, 26 bytes in 26 cycles (held 0) |
| 30645 | yapp monitor | RX pkt #70 on the input: addr=1 len=24 parity=good gap=20 |
| 30645 | reference | Packet forwarded: addr=1 len=24 -> channel 1 |
| 30650 | ch1 driver | ch1: packet consumed (response delay 0) |
| 30650 | yapp driver | TX pkt #70 accepted by the DUT |
| 30650 | yapp driver | TX pkt #71: addr=0 len=10 parity=good delay=20 |
| 30685 | **DUT** | OUT ch1 pkt #5 done: 26 bytes in 29 cycles |
| 30685 | ch1 monitor | ch1 RX pkt #5: addr=1 len=24 parity=good |
| 30685 | scoreboard | ch1 pkt matched: addr=1 len=24 (21 matched so far) |
| 30850 | ch1 driver | ch1: packet consumed (response delay 2) |
| 30855 | **DUT** | IN  pkt #71 header: addr=0 len=10 -> channel 0 |
| 30865 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=10 (receiver waited 0 cycle(s)) |
| 30965 | **DUT** | IN  pkt #71 complete: addr=0 len=10 parity=ok forwarded, 12 bytes in 12 cycles (held 0) |
| 30965 | yapp monitor | RX pkt #71 on the input: addr=0 len=10 parity=good gap=20 |
| 30965 | reference | Packet forwarded: addr=0 len=10 -> channel 0 |
| 30970 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30970 | yapp driver | TX pkt #71 accepted by the DUT |
| 30970 | yapp driver | TX pkt #72: addr=1 len=19 parity=good delay=0 |
| 30975 | **DUT** | IN  pkt #72 header: addr=1 len=19 -> channel 1 |
| 30985 | **DUT** | OUT ch0 pkt #7 done: 12 bytes in 13 cycles |
| 30985 | ch0 monitor | ch0 RX pkt #7: addr=0 len=10 parity=good |
| 30985 | scoreboard | ch0 pkt matched: addr=0 len=10 (22 matched so far) |
| 31055 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=19 (receiver waited 7 cycle(s)) |
| 31175 | **DUT** | IN  pkt #72 complete: addr=1 len=19 parity=ok forwarded, 21 bytes in 21 cycles (held 0) |
| 31175 | yapp monitor | RX pkt #72 on the input: addr=1 len=19 parity=good gap=0 |
| 31175 | reference | Packet forwarded: addr=1 len=19 -> channel 1 |
| 31180 | yapp driver | TX pkt #72 accepted by the DUT |
| 31180 | yapp driver | TX pkt #73: addr=1 len=23 parity=good delay=15 |
| 31250 | ch1 driver | ch1: packet consumed (response delay 7) |
| 31315 | **DUT** | OUT ch1 pkt #6 done: 21 bytes in 27 cycles |
| 31315 | ch1 monitor | ch1 RX pkt #6: addr=1 len=19 parity=good |
| 31315 | scoreboard | ch1 pkt matched: addr=1 len=19 (23 matched so far) |
| 31335 | **DUT** | IN  pkt #73 header: addr=1 len=23 -> channel 1 |
| 31345 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=23 (receiver waited 0 cycle(s)) |
| 31575 | **DUT** | IN  pkt #73 complete: addr=1 len=23 parity=ok forwarded, 25 bytes in 25 cycles (held 0) |
| 31575 | yapp monitor | RX pkt #73 on the input: addr=1 len=23 parity=good gap=15 |
| 31575 | reference | Packet forwarded: addr=1 len=23 -> channel 1 |
| 31580 | ch0 driver | ch0: packet consumed (response delay 0) |
| 31580 | yapp driver | TX pkt #73 accepted by the DUT |
| 31580 | yapp driver | TX pkt #74: addr=0 len=53 parity=good delay=12 |
| 31585 | **DUT** | OUT ch1 pkt #7 done: 25 bytes in 25 cycles |
| 31585 | ch1 monitor | ch1 RX pkt #7: addr=1 len=23 parity=good |
| 31585 | scoreboard | ch1 pkt matched: addr=1 len=23 (24 matched so far) |
| 31705 | **DUT** | IN  pkt #74 header: addr=0 len=53 -> DROP (oversized: len 53 > maxpktsize 27) |
| 31850 | ch1 driver | ch1: packet consumed (response delay 5) |
| 32245 | **DUT** | IN  pkt #74 complete: addr=0 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 32245 | yapp monitor | RX pkt #74 on the input: addr=0 len=53 parity=good gap=12 |
| 32245 | reference | Packet dropped: length 53 > maxpktsize 27 (addr=0) |
| 32245 | **DUT** | ROUTER DROPS PACKET addr=0 length=53 (length > maxpktsize) |
| 32250 | yapp driver | TX pkt #74 accepted by the DUT |
| 32250 | yapp driver | TX pkt #75: addr=1 len=5 parity=good delay=3 |
| 32285 | **DUT** | IN  pkt #75 header: addr=1 len=5 -> channel 1 |
| 32335 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=5 (receiver waited 4 cycle(s)) |
| 32345 | **DUT** | IN  pkt #75 complete: addr=1 len=5 parity=ok forwarded, 7 bytes in 7 cycles (held 0) |
| 32345 | yapp monitor | RX pkt #75 on the input: addr=1 len=5 parity=good gap=3 |
| 32345 | reference | Packet forwarded: addr=1 len=5 -> channel 1 |
| 32350 | yapp driver | TX pkt #75 accepted by the DUT |
| 32350 | yapp driver | TX pkt #76: addr=2 len=51 parity=good delay=0 |
| 32355 | **DUT** | IN  pkt #76 header: addr=2 len=51 -> DROP (oversized: len 51 > maxpktsize 27) |
| 32390 | ch1 driver | ch1: packet consumed (response delay 4) |
| 32475 | **DUT** | OUT ch1 pkt #8 done: 7 bytes in 15 cycles |
| 32475 | ch1 monitor | ch1 RX pkt #8: addr=1 len=5 parity=good |
| 32475 | scoreboard | ch1 pkt matched: addr=1 len=5 (25 matched so far) |
| 32860 | ch1 driver | ch1: packet consumed (response delay 7) |
| 32875 | **DUT** | IN  pkt #76 complete: addr=2 len=51 parity=ok dropped, 53 bytes in 53 cycles (held 0) |
| 32875 | yapp monitor | RX pkt #76 on the input: addr=2 len=51 parity=good gap=0 |
| 32875 | reference | Packet dropped: length 51 > maxpktsize 27 (addr=2) |
| 32875 | **DUT** | ROUTER DROPS PACKET addr=2 length=51 (length > maxpktsize) |
| 32880 | yapp driver | TX pkt #76 accepted by the DUT |
| 32880 | yapp driver | TX pkt #77: addr=1 len=15 parity=bad delay=6 |
| 32945 | **DUT** | IN  pkt #77 header: addr=1 len=15 -> channel 1 |
| 32995 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=15 (receiver waited 4 cycle(s)) |
| 33105 | **DUT** | IN  pkt #77 complete: addr=1 len=15 parity=BAD forwarded, 17 bytes in 17 cycles (held 0) |
| 33105 | yapp monitor | RX pkt #77 on the input: addr=1 len=15 parity=bad gap=6 |
| 33105 | reference | Packet forwarded: addr=1 len=15 -> channel 1 |
| 33110 | yapp driver | TX pkt #77 accepted by the DUT |
| 33110 | yapp driver | TX pkt #78: addr=0 len=63 parity=good delay=1 |
| 33125 | **DUT** | IN  pkt #78 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 27) |
| 33150 | ch1 driver | ch1: packet consumed (response delay 4) |
| 33210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 33210 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 33235 | **DUT** | OUT ch1 pkt #9 done: 17 bytes in 25 cycles |
| 33235 | ch1 monitor | ch1 RX pkt #9: addr=1 len=15 parity=bad |
| 33235 | scoreboard | ch1 pkt matched: addr=1 len=15 (26 matched so far) |
| 33390 | ch1 driver | ch1: packet consumed (response delay 7) |
| 33765 | **DUT** | IN  pkt #78 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 33765 | yapp monitor | RX pkt #78 on the input: addr=0 len=63 parity=good gap=1 |
| 33765 | reference | Packet dropped: length 63 > maxpktsize 27 (addr=0) |
| 33765 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 33770 | yapp driver | TX pkt #78 accepted by the DUT |
| 33770 | yapp driver | TX pkt #79: addr=2 len=18 parity=good delay=1 |
| 33785 | **DUT** | IN  pkt #79 header: addr=2 len=18 -> channel 2 |
| 33795 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=18 (receiver waited 0 cycle(s)) |
| 33975 | **DUT** | IN  pkt #79 complete: addr=2 len=18 parity=ok forwarded, 20 bytes in 20 cycles (held 0) |
| 33975 | yapp monitor | RX pkt #79 on the input: addr=2 len=18 parity=good gap=1 |
| 33975 | reference | Packet forwarded: addr=2 len=18 -> channel 2 |
| 33980 | ch2 driver | ch2: packet consumed (response delay 0) |
| 33980 | yapp driver | TX pkt #79 accepted by the DUT |
| 33980 | yapp driver | TX pkt #80: addr=2 len=6 parity=good delay=1 |
| 33995 | **DUT** | IN  pkt #80 header: addr=2 len=6 -> channel 2 |
| 33995 | **DUT** | OUT ch2 pkt #11 done: 20 bytes in 21 cycles |
| 33995 | ch2 monitor | ch2 RX pkt #11: addr=2 len=18 parity=good |
| 33995 | scoreboard | ch2 pkt matched: addr=2 len=18 (27 matched so far) |
| 34005 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=6 (receiver waited 0 cycle(s)) |
| 34065 | **DUT** | IN  pkt #80 complete: addr=2 len=6 parity=ok forwarded, 8 bytes in 8 cycles (held 0) |
| 34065 | yapp monitor | RX pkt #80 on the input: addr=2 len=6 parity=good gap=1 |
| 34065 | reference | Packet forwarded: addr=2 len=6 -> channel 2 |
| 34070 | yapp driver | TX pkt #80 accepted by the DUT |
| 34070 | **test** | STAGE: burst 6/6 sent: addr0..3 5/5/4/0, bad parity 2, gap 0 4, length 5..63 |
| 34070 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 34075 | **DUT** | OUT ch2 pkt #12 done: 8 bytes in 8 cycles |
| 34075 | ch2 monitor | ch2 RX pkt #12: addr=2 len=6 parity=good |
| 34075 | scoreboard | ch2 pkt matched: addr=2 len=6 (28 matched so far) |
| 34100 | hbus driver | Executed READ  addr=0x1000 data=0x5b |
| 34105 | hbus monitor | Collected READ  addr=0x1000 data=0x5b |
| 34130 | hbus driver | Executed READ  addr=0x1001 data=0xb5 |
| 34135 | hbus monitor | Collected READ  addr=0x1001 data=0xb5 |
| 34160 | hbus driver | Executed READ  addr=0x1004 data=0x02 |
| 34165 | hbus monitor | Collected READ  addr=0x1004 data=0x02 |
| 34190 | hbus driver | Executed READ  addr=0x1005 data=0x1b |
| 34195 | hbus monitor | Collected READ  addr=0x1005 data=0x1b |
| 34220 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 34225 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34250 | hbus driver | Executed READ  addr=0x1009 data=0x07 |
| 34255 | hbus monitor | Collected READ  addr=0x1009 data=0x07 |
| 34280 | hbus driver | Executed READ  addr=0x100a data=0x0b |
| 34285 | hbus monitor | Collected READ  addr=0x100a data=0x0b |
| 34310 | hbus driver | Executed READ  addr=0x100b data=0x14 |
| 34315 | hbus monitor | Collected READ  addr=0x100b data=0x14 |
| 34340 | hbus driver | Executed READ  addr=0x100d data=0x06 |
| 34345 | hbus monitor | Collected READ  addr=0x100d data=0x06 |
| 34370 | hbus driver | Executed READ  addr=0x1010 data=0x1a |
| 34375 | hbus monitor | Collected READ  addr=0x1010 data=0x1a |
| 34400 | hbus driver | Executed READ  addr=0x1011 data=0x16 |
| 34405 | hbus monitor | Collected READ  addr=0x1011 data=0x16 |
| 34430 | hbus driver | Executed READ  addr=0x1012 data=0x8a |
| 34435 | hbus monitor | Collected READ  addr=0x1012 data=0x8a |
| 34460 | hbus driver | Executed READ  addr=0x1013 data=0x00 |
| 34465 | hbus monitor | Collected READ  addr=0x1013 data=0x00 |
| 34480 | ch2 driver | ch2: packet consumed (response delay 0) |
| 34490 | hbus driver | Executed READ  addr=0x1014 data=0x06 |
| 34495 | hbus monitor | Collected READ  addr=0x1014 data=0x06 |
| 34520 | hbus driver | Executed READ  addr=0x1015 data=0x90 |
| 34525 | hbus monitor | Collected READ  addr=0x1015 data=0x90 |
| 34550 | hbus driver | Executed READ  addr=0x1016 data=0x92 |
| 34555 | hbus monitor | Collected READ  addr=0x1016 data=0x92 |
| 34665 | **test** | STAGE: done: 80 packets (28 forwarded, 52 dropped), 0 storm burst(s), 28 scoreboard matches, 50 HBUS reads checked, 7 error pulses for 7 bad packets |
| 34865 | error checker | error pulse report: 7 bad packets, 7 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 34865 | ch0 monitor | Channel 0 report: 7 packets collected |
| 34865 | ch1 monitor | Channel 1 report: 9 packets collected |
| 34865 | ch2 monitor | Channel 2 report: 12 packets collected |
| 34865 | hbus monitor | HBUS report: 31 writes, 52 reads |
| 34865 | coverage | Coverage of the router configuration: 73.9% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 13 / 0 / 53 / 0 / 0 packets · length < max / = max / max+1 / > max+1 : 24 / 4 / 4 / 34 · forwarded good / bad : 25 / 3 · dropped address 3 good / bad : 1 / 0 · dropped oversized good / bad : 33 / 4 · counter enables none / mixed / all : 0 / 66 / 0 |
| 34865 | coverage | HBUS address coverage: 83 accesses sampled, coverage 54.5% |
| 34865 | coverage | HBUS register bits coverage: 12 writes to ctrl_reg/en_reg, coverage 95.5% |
| 34865 | coverage | HBUS counter value coverage: 9 counter reads sampled, coverage 51.9% |
| 34865 | coverage | HBUS yapp_mem data coverage: 38 accesses sampled, coverage 47.1% |
| 34865 | reference | --- Reference model report --- · forwarded to scoreboard : 28 · dropped (router disabled) : 14 · dropped (oversized) : 37 · dropped (address 3) : 1 · counters parity/oversized/addr0..3 : 2 / 27 / 7 11 20 0 |
| 34865 | reference | HBUS reads checked against the model: 50 (0 mismatches, 2 of memory bytes never written) |
| 34865 | scoreboard | --- Scoreboard report --- · packets received : 28 · packets matched : 28 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 34865 | yapp driver | YAPP driver report: 80 packets sent |
| 34865 | coverage | YAPP gap coverage: 79 gaps sampled, coverage 100.0% |
| 34865 | yapp monitor | YAPP monitor report: 80 packets collected, 10 with bad parity |
| 34865 | yapp monitor | YAPP gaps: 18 back to back, 15 of 1 cycle, 4 of 2, 42 longer |
| 34865 | coverage | YAPP packet coverage: 80 packets sampled, coverage 70.0% |
