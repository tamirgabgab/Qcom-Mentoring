# random_test seed 7

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 37us · wall 18.8 s · log [`random_test_s7.log`](random_test_s7.log)

Waves: `random_test_s7.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s7%2Frandom_test_s7.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **85** packet(s) (10 with bad parity); the input monitor saw 85.
- Router: **0** forwarded, **85** dropped (42 router disabled, 43 oversized).
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 7.
- HBUS: 5 write(s), 18 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_STALLY, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_STALLY |
| 0 | random scenario: 85 packets in 2 bursts |
| 230 | burst 1/2: ctrl=0x14 (maxpktsize 20) en=0x98 (router OFF, counter enables 1001100), 42 packet(s) |
| 17810 | burst 1/2 sent: addr0..3 10/13/17/2, bad parity 3, gap 0 5, length 1..63 |
| 17940 | burst 2/2: ctrl=0xc0 (maxpktsize 0) en=0xc9 (router on, counter enables 1100100), 43 packet(s) |
| 36060 | burst 2/2 sent: addr0..3 10/11/19/3, bad parity 7, gap 0 11, length 1..63 |
| 36060 | final reads: every register and the stored packet, checked against the reference model |
| 36505 | done: 85 packets (0 forwarded, 85 dropped), 0 storm burst(s), 0 scoreboard matches, 16 HBUS reads checked, 7 error pulses for 7 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

693 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_STALLY, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_STALLY |
| 0 | **test** | STAGE: random scenario: 85 packets in 2 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x14 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=20 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x14 |
| 75 | reference | maxpktsize is now 20 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0x98 |
| 95 | **DUT** | CONFIG router_en=0 maxpktsize=20 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0x98 |
| 95 | reference | router_en is now 0 (en_reg 0x98) |
| 110 | hbus driver | Executed WRITE addr=0x1137 data=0xdf |
| 115 | hbus monitor | Collected WRITE addr=0x1137 data=0xdf |
| 140 | hbus driver | Executed READ  addr=0x1137 data=0xdf |
| 145 | hbus monitor | Collected READ  addr=0x1137 data=0xdf |
| 170 | hbus driver | Executed READ  addr=0x1040 data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x1040 data=0x00 |
| 200 | hbus driver | Executed READ  addr=0x1000 data=0x14 |
| 205 | hbus monitor | Collected READ  addr=0x1000 data=0x14 |
| 230 | hbus driver | Executed READ  addr=0x1001 data=0x98 |
| 230 | **test** | STAGE: burst 1/2: ctrl=0x14 (maxpktsize 20) en=0x98 (router OFF, counter enables 1001100), 42 packet(s) |
| 230 | yapp driver | TX pkt #1: addr=2 len=63 parity=good delay=4 |
| 235 | hbus monitor | Collected READ  addr=0x1001 data=0x98 |
| 285 | **DUT** | IN  pkt #1 header: addr=2 len=63 -> DROP (router disabled) |
| 925 | **DUT** | IN  pkt #1 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 925 | yapp monitor | RX pkt #1 on the input: addr=2 len=63 parity=good gap=23 |
| 925 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 925 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 930 | yapp driver | TX pkt #1 accepted by the DUT |
| 930 | yapp driver | TX pkt #2: addr=1 len=41 parity=good delay=1 |
| 945 | **DUT** | IN  pkt #2 header: addr=1 len=41 -> DROP (router disabled) |
| 1365 | **DUT** | IN  pkt #2 complete: addr=1 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 1365 | yapp monitor | RX pkt #2 on the input: addr=1 len=41 parity=good gap=1 |
| 1365 | reference | Packet dropped: router disabled (addr=1 len=41) |
| 1365 | **DUT** | ROUTER DROPS PACKET addr=1 length=41 (router disabled) |
| 1370 | yapp driver | TX pkt #2 accepted by the DUT |
| 1370 | yapp driver | TX pkt #3: addr=1 len=43 parity=good delay=4 |
| 1415 | **DUT** | IN  pkt #3 header: addr=1 len=43 -> DROP (router disabled) |
| 1855 | **DUT** | IN  pkt #3 complete: addr=1 len=43 parity=ok dropped, 45 bytes in 45 cycles (held 0) |
| 1855 | yapp monitor | RX pkt #3 on the input: addr=1 len=43 parity=good gap=4 |
| 1855 | reference | Packet dropped: router disabled (addr=1 len=43) |
| 1855 | **DUT** | ROUTER DROPS PACKET addr=1 length=43 (router disabled) |
| 1860 | yapp driver | TX pkt #3 accepted by the DUT |
| 1860 | yapp driver | TX pkt #4: addr=3 len=1 parity=bad delay=1 |
| 1875 | **DUT** | IN  pkt #4 header: addr=3 len=1 -> DROP (router disabled) |
| 1895 | **DUT** | IN  pkt #4 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 1895 | yapp monitor | RX pkt #4 on the input: addr=3 len=1 parity=bad gap=1 |
| 1895 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 1895 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 1900 | yapp driver | TX pkt #4 accepted by the DUT |
| 1900 | yapp driver | TX pkt #5: addr=0 len=57 parity=good delay=18 |
| 2085 | **DUT** | IN  pkt #5 header: addr=0 len=57 -> DROP (router disabled) |
| 2665 | **DUT** | IN  pkt #5 complete: addr=0 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 2665 | yapp monitor | RX pkt #5 on the input: addr=0 len=57 parity=good gap=18 |
| 2665 | reference | Packet dropped: router disabled (addr=0 len=57) |
| 2665 | **DUT** | ROUTER DROPS PACKET addr=0 length=57 (router disabled) |
| 2670 | yapp driver | TX pkt #5 accepted by the DUT |
| 2670 | yapp driver | TX pkt #6: addr=2 len=58 parity=good delay=2 |
| 2695 | **DUT** | IN  pkt #6 header: addr=2 len=58 -> DROP (router disabled) |
| 3285 | **DUT** | IN  pkt #6 complete: addr=2 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 3285 | yapp monitor | RX pkt #6 on the input: addr=2 len=58 parity=good gap=2 |
| 3285 | reference | Packet dropped: router disabled (addr=2 len=58) |
| 3285 | **DUT** | ROUTER DROPS PACKET addr=2 length=58 (router disabled) |
| 3290 | yapp driver | TX pkt #6 accepted by the DUT |
| 3290 | yapp driver | TX pkt #7: addr=1 len=29 parity=good delay=13 |
| 3425 | **DUT** | IN  pkt #7 header: addr=1 len=29 -> DROP (router disabled) |
| 3725 | **DUT** | IN  pkt #7 complete: addr=1 len=29 parity=ok dropped, 31 bytes in 31 cycles (held 0) |
| 3725 | yapp monitor | RX pkt #7 on the input: addr=1 len=29 parity=good gap=13 |
| 3725 | reference | Packet dropped: router disabled (addr=1 len=29) |
| 3725 | **DUT** | ROUTER DROPS PACKET addr=1 length=29 (router disabled) |
| 3730 | yapp driver | TX pkt #7 accepted by the DUT |
| 3730 | yapp driver | TX pkt #8: addr=2 len=19 parity=good delay=1 |
| 3745 | **DUT** | IN  pkt #8 header: addr=2 len=19 -> DROP (router disabled) |
| 3945 | **DUT** | IN  pkt #8 complete: addr=2 len=19 parity=ok dropped, 21 bytes in 21 cycles (held 0) |
| 3945 | yapp monitor | RX pkt #8 on the input: addr=2 len=19 parity=good gap=1 |
| 3945 | reference | Packet dropped: router disabled (addr=2 len=19) |
| 3945 | **DUT** | ROUTER DROPS PACKET addr=2 length=19 (router disabled) |
| 3950 | yapp driver | TX pkt #8 accepted by the DUT |
| 3950 | yapp driver | TX pkt #9: addr=1 len=24 parity=good delay=2 |
| 3975 | **DUT** | IN  pkt #9 header: addr=1 len=24 -> DROP (router disabled) |
| 4225 | **DUT** | IN  pkt #9 complete: addr=1 len=24 parity=ok dropped, 26 bytes in 26 cycles (held 0) |
| 4225 | yapp monitor | RX pkt #9 on the input: addr=1 len=24 parity=good gap=2 |
| 4225 | reference | Packet dropped: router disabled (addr=1 len=24) |
| 4225 | **DUT** | ROUTER DROPS PACKET addr=1 length=24 (router disabled) |
| 4230 | yapp driver | TX pkt #9 accepted by the DUT |
| 4230 | yapp driver | TX pkt #10: addr=1 len=2 parity=good delay=2 |
| 4255 | **DUT** | IN  pkt #10 header: addr=1 len=2 -> DROP (router disabled) |
| 4285 | **DUT** | IN  pkt #10 complete: addr=1 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 4285 | yapp monitor | RX pkt #10 on the input: addr=1 len=2 parity=good gap=2 |
| 4285 | reference | Packet dropped: router disabled (addr=1 len=2) |
| 4285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (router disabled) |
| 4290 | yapp driver | TX pkt #10 accepted by the DUT |
| 4290 | yapp driver | TX pkt #11: addr=1 len=40 parity=good delay=5 |
| 4345 | **DUT** | IN  pkt #11 header: addr=1 len=40 -> DROP (router disabled) |
| 4755 | **DUT** | IN  pkt #11 complete: addr=1 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 4755 | yapp monitor | RX pkt #11 on the input: addr=1 len=40 parity=good gap=5 |
| 4755 | reference | Packet dropped: router disabled (addr=1 len=40) |
| 4755 | **DUT** | ROUTER DROPS PACKET addr=1 length=40 (router disabled) |
| 4760 | yapp driver | TX pkt #11 accepted by the DUT |
| 4760 | yapp driver | TX pkt #12: addr=1 len=63 parity=good delay=14 |
| 4905 | **DUT** | IN  pkt #12 header: addr=1 len=63 -> DROP (router disabled) |
| 5545 | **DUT** | IN  pkt #12 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5545 | yapp monitor | RX pkt #12 on the input: addr=1 len=63 parity=good gap=14 |
| 5545 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 5545 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 5550 | yapp driver | TX pkt #12 accepted by the DUT |
| 5550 | yapp driver | TX pkt #13: addr=2 len=63 parity=good delay=2 |
| 5575 | **DUT** | IN  pkt #13 header: addr=2 len=63 -> DROP (router disabled) |
| 6215 | **DUT** | IN  pkt #13 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 6215 | yapp monitor | RX pkt #13 on the input: addr=2 len=63 parity=good gap=2 |
| 6215 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 6215 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 6220 | yapp driver | TX pkt #13 accepted by the DUT |
| 6220 | yapp driver | TX pkt #14: addr=0 len=33 parity=good delay=7 |
| 6295 | **DUT** | IN  pkt #14 header: addr=0 len=33 -> DROP (router disabled) |
| 6635 | **DUT** | IN  pkt #14 complete: addr=0 len=33 parity=ok dropped, 35 bytes in 35 cycles (held 0) |
| 6635 | yapp monitor | RX pkt #14 on the input: addr=0 len=33 parity=good gap=7 |
| 6635 | reference | Packet dropped: router disabled (addr=0 len=33) |
| 6635 | **DUT** | ROUTER DROPS PACKET addr=0 length=33 (router disabled) |
| 6640 | yapp driver | TX pkt #14 accepted by the DUT |
| 6640 | yapp driver | TX pkt #15: addr=3 len=49 parity=good delay=0 |
| 6645 | **DUT** | IN  pkt #15 header: addr=3 len=49 -> DROP (router disabled) |
| 7145 | **DUT** | IN  pkt #15 complete: addr=3 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 7145 | yapp monitor | RX pkt #15 on the input: addr=3 len=49 parity=good gap=0 |
| 7145 | reference | Packet dropped: router disabled (addr=3 len=49) |
| 7145 | **DUT** | ROUTER DROPS PACKET addr=3 length=49 (router disabled) |
| 7150 | yapp driver | TX pkt #15 accepted by the DUT |
| 7150 | yapp driver | TX pkt #16: addr=2 len=41 parity=good delay=0 |
| 7155 | **DUT** | IN  pkt #16 header: addr=2 len=41 -> DROP (router disabled) |
| 7575 | **DUT** | IN  pkt #16 complete: addr=2 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 7575 | yapp monitor | RX pkt #16 on the input: addr=2 len=41 parity=good gap=0 |
| 7575 | reference | Packet dropped: router disabled (addr=2 len=41) |
| 7575 | **DUT** | ROUTER DROPS PACKET addr=2 length=41 (router disabled) |
| 7580 | yapp driver | TX pkt #16 accepted by the DUT |
| 7580 | yapp driver | TX pkt #17: addr=0 len=36 parity=good delay=20 |
| 7785 | **DUT** | IN  pkt #17 header: addr=0 len=36 -> DROP (router disabled) |
| 8155 | **DUT** | IN  pkt #17 complete: addr=0 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 8155 | yapp monitor | RX pkt #17 on the input: addr=0 len=36 parity=good gap=20 |
| 8155 | reference | Packet dropped: router disabled (addr=0 len=36) |
| 8155 | **DUT** | ROUTER DROPS PACKET addr=0 length=36 (router disabled) |
| 8160 | yapp driver | TX pkt #17 accepted by the DUT |
| 8160 | yapp driver | TX pkt #18: addr=2 len=63 parity=good delay=16 |
| 8325 | **DUT** | IN  pkt #18 header: addr=2 len=63 -> DROP (router disabled) |
| 8965 | **DUT** | IN  pkt #18 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8965 | yapp monitor | RX pkt #18 on the input: addr=2 len=63 parity=good gap=16 |
| 8965 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 8965 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 8970 | yapp driver | TX pkt #18 accepted by the DUT |
| 8970 | yapp driver | TX pkt #19: addr=0 len=11 parity=good delay=14 |
| 9115 | **DUT** | IN  pkt #19 header: addr=0 len=11 -> DROP (router disabled) |
| 9235 | **DUT** | IN  pkt #19 complete: addr=0 len=11 parity=ok dropped, 13 bytes in 13 cycles (held 0) |
| 9235 | yapp monitor | RX pkt #19 on the input: addr=0 len=11 parity=good gap=14 |
| 9235 | reference | Packet dropped: router disabled (addr=0 len=11) |
| 9235 | **DUT** | ROUTER DROPS PACKET addr=0 length=11 (router disabled) |
| 9240 | yapp driver | TX pkt #19 accepted by the DUT |
| 9240 | yapp driver | TX pkt #20: addr=0 len=24 parity=good delay=2 |
| 9265 | **DUT** | IN  pkt #20 header: addr=0 len=24 -> DROP (router disabled) |
| 9515 | **DUT** | IN  pkt #20 complete: addr=0 len=24 parity=ok dropped, 26 bytes in 26 cycles (held 0) |
| 9515 | yapp monitor | RX pkt #20 on the input: addr=0 len=24 parity=good gap=2 |
| 9515 | reference | Packet dropped: router disabled (addr=0 len=24) |
| 9515 | **DUT** | ROUTER DROPS PACKET addr=0 length=24 (router disabled) |
| 9520 | yapp driver | TX pkt #20 accepted by the DUT |
| 9520 | yapp driver | TX pkt #21: addr=1 len=1 parity=good delay=6 |
| 9585 | **DUT** | IN  pkt #21 header: addr=1 len=1 -> DROP (router disabled) |
| 9605 | **DUT** | IN  pkt #21 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 9605 | yapp monitor | RX pkt #21 on the input: addr=1 len=1 parity=good gap=6 |
| 9605 | reference | Packet dropped: router disabled (addr=1 len=1) |
| 9605 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (router disabled) |
| 9610 | yapp driver | TX pkt #21 accepted by the DUT |
| 9610 | yapp driver | TX pkt #22: addr=2 len=55 parity=good delay=8 |
| 9695 | **DUT** | IN  pkt #22 header: addr=2 len=55 -> DROP (router disabled) |
| 10255 | **DUT** | IN  pkt #22 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 10255 | yapp monitor | RX pkt #22 on the input: addr=2 len=55 parity=good gap=8 |
| 10255 | reference | Packet dropped: router disabled (addr=2 len=55) |
| 10255 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (router disabled) |
| 10260 | yapp driver | TX pkt #22 accepted by the DUT |
| 10260 | yapp driver | TX pkt #23: addr=1 len=49 parity=good delay=17 |
| 10435 | **DUT** | IN  pkt #23 header: addr=1 len=49 -> DROP (router disabled) |
| 10935 | **DUT** | IN  pkt #23 complete: addr=1 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 10935 | yapp monitor | RX pkt #23 on the input: addr=1 len=49 parity=good gap=17 |
| 10935 | reference | Packet dropped: router disabled (addr=1 len=49) |
| 10935 | **DUT** | ROUTER DROPS PACKET addr=1 length=49 (router disabled) |
| 10940 | yapp driver | TX pkt #23 accepted by the DUT |
| 10940 | yapp driver | TX pkt #24: addr=1 len=21 parity=good delay=11 |
| 11055 | **DUT** | IN  pkt #24 header: addr=1 len=21 -> DROP (router disabled) |
| 11275 | **DUT** | IN  pkt #24 complete: addr=1 len=21 parity=ok dropped, 23 bytes in 23 cycles (held 0) |
| 11275 | yapp monitor | RX pkt #24 on the input: addr=1 len=21 parity=good gap=11 |
| 11275 | reference | Packet dropped: router disabled (addr=1 len=21) |
| 11275 | **DUT** | ROUTER DROPS PACKET addr=1 length=21 (router disabled) |
| 11280 | yapp driver | TX pkt #24 accepted by the DUT |
| 11280 | yapp driver | TX pkt #25: addr=1 len=13 parity=good delay=1 |
| 11295 | **DUT** | IN  pkt #25 header: addr=1 len=13 -> DROP (router disabled) |
| 11435 | **DUT** | IN  pkt #25 complete: addr=1 len=13 parity=ok dropped, 15 bytes in 15 cycles (held 0) |
| 11435 | yapp monitor | RX pkt #25 on the input: addr=1 len=13 parity=good gap=1 |
| 11435 | reference | Packet dropped: router disabled (addr=1 len=13) |
| 11435 | **DUT** | ROUTER DROPS PACKET addr=1 length=13 (router disabled) |
| 11440 | yapp driver | TX pkt #25 accepted by the DUT |
| 11440 | yapp driver | TX pkt #26: addr=2 len=42 parity=good delay=0 |
| 11445 | **DUT** | IN  pkt #26 header: addr=2 len=42 -> DROP (router disabled) |
| 11875 | **DUT** | IN  pkt #26 complete: addr=2 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 11875 | yapp monitor | RX pkt #26 on the input: addr=2 len=42 parity=good gap=0 |
| 11875 | reference | Packet dropped: router disabled (addr=2 len=42) |
| 11875 | **DUT** | ROUTER DROPS PACKET addr=2 length=42 (router disabled) |
| 11880 | yapp driver | TX pkt #26 accepted by the DUT |
| 11880 | yapp driver | TX pkt #27: addr=1 len=20 parity=good delay=8 |
| 11965 | **DUT** | IN  pkt #27 header: addr=1 len=20 -> DROP (router disabled) |
| 12175 | **DUT** | IN  pkt #27 complete: addr=1 len=20 parity=ok dropped, 22 bytes in 22 cycles (held 0) |
| 12175 | yapp monitor | RX pkt #27 on the input: addr=1 len=20 parity=good gap=8 |
| 12175 | reference | Packet dropped: router disabled (addr=1 len=20) |
| 12175 | **DUT** | ROUTER DROPS PACKET addr=1 length=20 (router disabled) |
| 12180 | yapp driver | TX pkt #27 accepted by the DUT |
| 12180 | yapp driver | TX pkt #28: addr=2 len=29 parity=good delay=20 |
| 12385 | **DUT** | IN  pkt #28 header: addr=2 len=29 -> DROP (router disabled) |
| 12685 | **DUT** | IN  pkt #28 complete: addr=2 len=29 parity=ok dropped, 31 bytes in 31 cycles (held 0) |
| 12685 | yapp monitor | RX pkt #28 on the input: addr=2 len=29 parity=good gap=20 |
| 12685 | reference | Packet dropped: router disabled (addr=2 len=29) |
| 12685 | **DUT** | ROUTER DROPS PACKET addr=2 length=29 (router disabled) |
| 12690 | yapp driver | TX pkt #28 accepted by the DUT |
| 12690 | yapp driver | TX pkt #29: addr=2 len=25 parity=good delay=7 |
| 12765 | **DUT** | IN  pkt #29 header: addr=2 len=25 -> DROP (router disabled) |
| 13025 | **DUT** | IN  pkt #29 complete: addr=2 len=25 parity=ok dropped, 27 bytes in 27 cycles (held 0) |
| 13025 | yapp monitor | RX pkt #29 on the input: addr=2 len=25 parity=good gap=7 |
| 13025 | reference | Packet dropped: router disabled (addr=2 len=25) |
| 13025 | **DUT** | ROUTER DROPS PACKET addr=2 length=25 (router disabled) |
| 13030 | yapp driver | TX pkt #29 accepted by the DUT |
| 13030 | yapp driver | TX pkt #30: addr=0 len=36 parity=good delay=1 |
| 13045 | **DUT** | IN  pkt #30 header: addr=0 len=36 -> DROP (router disabled) |
| 13415 | **DUT** | IN  pkt #30 complete: addr=0 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 13415 | yapp monitor | RX pkt #30 on the input: addr=0 len=36 parity=good gap=1 |
| 13415 | reference | Packet dropped: router disabled (addr=0 len=36) |
| 13415 | **DUT** | ROUTER DROPS PACKET addr=0 length=36 (router disabled) |
| 13420 | yapp driver | TX pkt #30 accepted by the DUT |
| 13420 | yapp driver | TX pkt #31: addr=1 len=41 parity=bad delay=10 |
| 13525 | **DUT** | IN  pkt #31 header: addr=1 len=41 -> DROP (router disabled) |
| 13945 | **DUT** | IN  pkt #31 complete: addr=1 len=41 parity=BAD dropped, 43 bytes in 43 cycles (held 0) |
| 13945 | yapp monitor | RX pkt #31 on the input: addr=1 len=41 parity=bad gap=10 |
| 13945 | reference | Packet dropped: router disabled (addr=1 len=41) |
| 13945 | **DUT** | ROUTER DROPS PACKET addr=1 length=41 (router disabled) |
| 13950 | yapp driver | TX pkt #31 accepted by the DUT |
| 13950 | yapp driver | TX pkt #32: addr=2 len=28 parity=good delay=2 |
| 13975 | **DUT** | IN  pkt #32 header: addr=2 len=28 -> DROP (router disabled) |
| 14265 | **DUT** | IN  pkt #32 complete: addr=2 len=28 parity=ok dropped, 30 bytes in 30 cycles (held 0) |
| 14265 | yapp monitor | RX pkt #32 on the input: addr=2 len=28 parity=good gap=2 |
| 14265 | reference | Packet dropped: router disabled (addr=2 len=28) |
| 14265 | **DUT** | ROUTER DROPS PACKET addr=2 length=28 (router disabled) |
| 14270 | yapp driver | TX pkt #32 accepted by the DUT |
| 14270 | yapp driver | TX pkt #33: addr=2 len=3 parity=good delay=1 |
| 14285 | **DUT** | IN  pkt #33 header: addr=2 len=3 -> DROP (router disabled) |
| 14325 | **DUT** | IN  pkt #33 complete: addr=2 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 14325 | yapp monitor | RX pkt #33 on the input: addr=2 len=3 parity=good gap=1 |
| 14325 | reference | Packet dropped: router disabled (addr=2 len=3) |
| 14325 | **DUT** | ROUTER DROPS PACKET addr=2 length=3 (router disabled) |
| 14330 | yapp driver | TX pkt #33 accepted by the DUT |
| 14330 | yapp driver | TX pkt #34: addr=0 len=58 parity=good delay=19 |
| 14525 | **DUT** | IN  pkt #34 header: addr=0 len=58 -> DROP (router disabled) |
| 15115 | **DUT** | IN  pkt #34 complete: addr=0 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 15115 | yapp monitor | RX pkt #34 on the input: addr=0 len=58 parity=good gap=19 |
| 15115 | reference | Packet dropped: router disabled (addr=0 len=58) |
| 15115 | **DUT** | ROUTER DROPS PACKET addr=0 length=58 (router disabled) |
| 15120 | yapp driver | TX pkt #34 accepted by the DUT |
| 15120 | yapp driver | TX pkt #35: addr=0 len=31 parity=good delay=1 |
| 15135 | **DUT** | IN  pkt #35 header: addr=0 len=31 -> DROP (router disabled) |
| 15455 | **DUT** | IN  pkt #35 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 15455 | yapp monitor | RX pkt #35 on the input: addr=0 len=31 parity=good gap=1 |
| 15455 | reference | Packet dropped: router disabled (addr=0 len=31) |
| 15455 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (router disabled) |
| 15460 | yapp driver | TX pkt #35 accepted by the DUT |
| 15460 | yapp driver | TX pkt #36: addr=0 len=49 parity=good delay=1 |
| 15475 | **DUT** | IN  pkt #36 header: addr=0 len=49 -> DROP (router disabled) |
| 15975 | **DUT** | IN  pkt #36 complete: addr=0 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 15975 | yapp monitor | RX pkt #36 on the input: addr=0 len=49 parity=good gap=1 |
| 15975 | reference | Packet dropped: router disabled (addr=0 len=49) |
| 15975 | **DUT** | ROUTER DROPS PACKET addr=0 length=49 (router disabled) |
| 15980 | yapp driver | TX pkt #36 accepted by the DUT |
| 15980 | yapp driver | TX pkt #37: addr=2 len=46 parity=bad delay=1 |
| 15995 | **DUT** | IN  pkt #37 header: addr=2 len=46 -> DROP (router disabled) |
| 16465 | **DUT** | IN  pkt #37 complete: addr=2 len=46 parity=BAD dropped, 48 bytes in 48 cycles (held 0) |
| 16465 | yapp monitor | RX pkt #37 on the input: addr=2 len=46 parity=bad gap=1 |
| 16465 | reference | Packet dropped: router disabled (addr=2 len=46) |
| 16465 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (router disabled) |
| 16470 | yapp driver | TX pkt #37 accepted by the DUT |
| 16470 | yapp driver | TX pkt #38: addr=2 len=1 parity=good delay=0 |
| 16475 | **DUT** | IN  pkt #38 header: addr=2 len=1 -> DROP (router disabled) |
| 16495 | **DUT** | IN  pkt #38 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 16495 | yapp monitor | RX pkt #38 on the input: addr=2 len=1 parity=good gap=0 |
| 16495 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 16495 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 16500 | yapp driver | TX pkt #38 accepted by the DUT |
| 16500 | yapp driver | TX pkt #39: addr=2 len=14 parity=good delay=0 |
| 16505 | **DUT** | IN  pkt #39 header: addr=2 len=14 -> DROP (router disabled) |
| 16655 | **DUT** | IN  pkt #39 complete: addr=2 len=14 parity=ok dropped, 16 bytes in 16 cycles (held 0) |
| 16655 | yapp monitor | RX pkt #39 on the input: addr=2 len=14 parity=good gap=0 |
| 16655 | reference | Packet dropped: router disabled (addr=2 len=14) |
| 16655 | **DUT** | ROUTER DROPS PACKET addr=2 length=14 (router disabled) |
| 16660 | yapp driver | TX pkt #39 accepted by the DUT |
| 16660 | yapp driver | TX pkt #40: addr=2 len=52 parity=good delay=15 |
| 16815 | **DUT** | IN  pkt #40 header: addr=2 len=52 -> DROP (router disabled) |
| 17345 | **DUT** | IN  pkt #40 complete: addr=2 len=52 parity=ok dropped, 54 bytes in 54 cycles (held 0) |
| 17345 | yapp monitor | RX pkt #40 on the input: addr=2 len=52 parity=good gap=15 |
| 17345 | reference | Packet dropped: router disabled (addr=2 len=52) |
| 17345 | **DUT** | ROUTER DROPS PACKET addr=2 length=52 (router disabled) |
| 17350 | yapp driver | TX pkt #40 accepted by the DUT |
| 17350 | yapp driver | TX pkt #41: addr=2 len=14 parity=good delay=1 |
| 17365 | **DUT** | IN  pkt #41 header: addr=2 len=14 -> DROP (router disabled) |
| 17515 | **DUT** | IN  pkt #41 complete: addr=2 len=14 parity=ok dropped, 16 bytes in 16 cycles (held 0) |
| 17515 | yapp monitor | RX pkt #41 on the input: addr=2 len=14 parity=good gap=1 |
| 17515 | reference | Packet dropped: router disabled (addr=2 len=14) |
| 17515 | **DUT** | ROUTER DROPS PACKET addr=2 length=14 (router disabled) |
| 17520 | yapp driver | TX pkt #41 accepted by the DUT |
| 17520 | yapp driver | TX pkt #42: addr=0 len=26 parity=good delay=1 |
| 17535 | **DUT** | IN  pkt #42 header: addr=0 len=26 -> DROP (router disabled) |
| 17805 | **DUT** | IN  pkt #42 complete: addr=0 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 17805 | yapp monitor | RX pkt #42 on the input: addr=0 len=26 parity=good gap=1 |
| 17805 | reference | Packet dropped: router disabled (addr=0 len=26) |
| 17805 | **DUT** | ROUTER DROPS PACKET addr=0 length=26 (router disabled) |
| 17810 | yapp driver | TX pkt #42 accepted by the DUT |
| 17810 | **test** | STAGE: burst 1/2 sent: addr0..3 10/13/17/2, bad parity 3, gap 0 5, length 1..63 |
| 17830 | hbus driver | Executed WRITE addr=0x1000 data=0xc0 |
| 17835 | **DUT** | CONFIG router_en=0 maxpktsize=0 |
| 17835 | hbus monitor | Collected WRITE addr=0x1000 data=0xc0 |
| 17835 | reference | maxpktsize is now 0 |
| 17850 | hbus driver | Executed WRITE addr=0x1001 data=0xc9 |
| 17855 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 17855 | hbus monitor | Collected WRITE addr=0x1001 data=0xc9 |
| 17855 | reference | router_en is now 1 (en_reg 0xc9) |
| 17880 | hbus driver | Executed READ  addr=0x10a3 data=0x00 |
| 17885 | hbus monitor | Collected READ  addr=0x10a3 data=0x00 |
| 17910 | hbus driver | Executed READ  addr=0x1025 data=0x00 |
| 17915 | hbus monitor | Collected READ  addr=0x1025 data=0x00 |
| 17940 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 17940 | **test** | STAGE: burst 2/2: ctrl=0xc0 (maxpktsize 0) en=0xc9 (router on, counter enables 1100100), 43 packet(s) |
| 17940 | yapp driver | TX pkt #43: addr=1 len=62 parity=good delay=1 |
| 17945 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 17965 | **DUT** | IN  pkt #43 header: addr=1 len=62 -> DROP (oversized: len 62 > maxpktsize 0) |
| 18595 | **DUT** | IN  pkt #43 complete: addr=1 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 18595 | yapp monitor | RX pkt #43 on the input: addr=1 len=62 parity=good gap=15 |
| 18595 | reference | Packet dropped: length 62 > maxpktsize 0 (addr=1) |
| 18595 | **DUT** | ROUTER DROPS PACKET addr=1 length=62 (length > maxpktsize) |
| 18600 | yapp driver | TX pkt #43 accepted by the DUT |
| 18600 | yapp driver | TX pkt #44: addr=2 len=1 parity=good delay=20 |
| 18805 | **DUT** | IN  pkt #44 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 18825 | **DUT** | IN  pkt #44 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 18825 | yapp monitor | RX pkt #44 on the input: addr=2 len=1 parity=good gap=20 |
| 18825 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 18825 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 18830 | yapp driver | TX pkt #44 accepted by the DUT |
| 18830 | yapp driver | TX pkt #45: addr=1 len=1 parity=good delay=20 |
| 19035 | **DUT** | IN  pkt #45 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 19055 | **DUT** | IN  pkt #45 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 19055 | yapp monitor | RX pkt #45 on the input: addr=1 len=1 parity=good gap=20 |
| 19055 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 19055 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 19060 | yapp driver | TX pkt #45 accepted by the DUT |
| 19060 | yapp driver | TX pkt #46: addr=2 len=37 parity=good delay=19 |
| 19255 | **DUT** | IN  pkt #46 header: addr=2 len=37 -> DROP (oversized: len 37 > maxpktsize 0) |
| 19635 | **DUT** | IN  pkt #46 complete: addr=2 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 19635 | yapp monitor | RX pkt #46 on the input: addr=2 len=37 parity=good gap=19 |
| 19635 | reference | Packet dropped: length 37 > maxpktsize 0 (addr=2) |
| 19635 | **DUT** | ROUTER DROPS PACKET addr=2 length=37 (length > maxpktsize) |
| 19640 | yapp driver | TX pkt #46 accepted by the DUT |
| 19640 | yapp driver | TX pkt #47: addr=0 len=1 parity=good delay=2 |
| 19665 | **DUT** | IN  pkt #47 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 19685 | **DUT** | IN  pkt #47 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 19685 | yapp monitor | RX pkt #47 on the input: addr=0 len=1 parity=good gap=2 |
| 19685 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 19685 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 19690 | yapp driver | TX pkt #47 accepted by the DUT |
| 19690 | yapp driver | TX pkt #48: addr=2 len=1 parity=good delay=16 |
| 19855 | **DUT** | IN  pkt #48 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 19875 | **DUT** | IN  pkt #48 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 19875 | yapp monitor | RX pkt #48 on the input: addr=2 len=1 parity=good gap=16 |
| 19875 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 19875 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 19880 | yapp driver | TX pkt #48 accepted by the DUT |
| 19880 | yapp driver | TX pkt #49: addr=3 len=63 parity=good delay=1 |
| 19895 | **DUT** | IN  pkt #49 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 20535 | **DUT** | IN  pkt #49 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 20535 | yapp monitor | RX pkt #49 on the input: addr=3 len=63 parity=good gap=1 |
| 20535 | reference | Packet dropped: illegal address 3 (len=63) |
| 20535 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 20540 | yapp driver | TX pkt #49 accepted by the DUT |
| 20540 | yapp driver | TX pkt #50: addr=1 len=43 parity=bad delay=0 |
| 20545 | **DUT** | IN  pkt #50 header: addr=1 len=43 -> DROP (oversized: len 43 > maxpktsize 0) |
| 20985 | **DUT** | IN  pkt #50 complete: addr=1 len=43 parity=BAD dropped, 45 bytes in 45 cycles (held 0) |
| 20985 | yapp monitor | RX pkt #50 on the input: addr=1 len=43 parity=bad gap=0 |
| 20985 | reference | Packet dropped: length 43 > maxpktsize 0 (addr=1) |
| 20985 | **DUT** | ROUTER DROPS PACKET addr=1 length=43 (length > maxpktsize) |
| 20990 | yapp driver | TX pkt #50 accepted by the DUT |
| 20990 | yapp driver | TX pkt #51: addr=2 len=42 parity=good delay=0 |
| 20995 | **DUT** | IN  pkt #51 header: addr=2 len=42 -> DROP (oversized: len 42 > maxpktsize 0) |
| 21030 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 21030 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 21425 | **DUT** | IN  pkt #51 complete: addr=2 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 21425 | yapp monitor | RX pkt #51 on the input: addr=2 len=42 parity=good gap=0 |
| 21425 | reference | Packet dropped: length 42 > maxpktsize 0 (addr=2) |
| 21425 | **DUT** | ROUTER DROPS PACKET addr=2 length=42 (length > maxpktsize) |
| 21430 | yapp driver | TX pkt #51 accepted by the DUT |
| 21430 | yapp driver | TX pkt #52: addr=2 len=1 parity=good delay=8 |
| 21515 | **DUT** | IN  pkt #52 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 21535 | **DUT** | IN  pkt #52 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 21535 | yapp monitor | RX pkt #52 on the input: addr=2 len=1 parity=good gap=8 |
| 21535 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 21535 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 21540 | yapp driver | TX pkt #52 accepted by the DUT |
| 21540 | yapp driver | TX pkt #53: addr=3 len=59 parity=good delay=0 |
| 21545 | **DUT** | IN  pkt #53 header: addr=3 len=59 -> DROP (oversized: len 59 > maxpktsize 0) |
| 22145 | **DUT** | IN  pkt #53 complete: addr=3 len=59 parity=ok dropped, 61 bytes in 61 cycles (held 0) |
| 22145 | yapp monitor | RX pkt #53 on the input: addr=3 len=59 parity=good gap=0 |
| 22145 | reference | Packet dropped: illegal address 3 (len=59) |
| 22145 | **DUT** | ROUTER DROPS PACKET addr=3 length=59 (    illegal address) |
| 22150 | yapp driver | TX pkt #53 accepted by the DUT |
| 22150 | yapp driver | TX pkt #54: addr=1 len=40 parity=good delay=16 |
| 22315 | **DUT** | IN  pkt #54 header: addr=1 len=40 -> DROP (oversized: len 40 > maxpktsize 0) |
| 22725 | **DUT** | IN  pkt #54 complete: addr=1 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 22725 | yapp monitor | RX pkt #54 on the input: addr=1 len=40 parity=good gap=16 |
| 22725 | reference | Packet dropped: length 40 > maxpktsize 0 (addr=1) |
| 22725 | **DUT** | ROUTER DROPS PACKET addr=1 length=40 (length > maxpktsize) |
| 22730 | yapp driver | TX pkt #54 accepted by the DUT |
| 22730 | yapp driver | TX pkt #55: addr=1 len=28 parity=good delay=6 |
| 22795 | **DUT** | IN  pkt #55 header: addr=1 len=28 -> DROP (oversized: len 28 > maxpktsize 0) |
| 23085 | **DUT** | IN  pkt #55 complete: addr=1 len=28 parity=ok dropped, 30 bytes in 30 cycles (held 0) |
| 23085 | yapp monitor | RX pkt #55 on the input: addr=1 len=28 parity=good gap=6 |
| 23085 | reference | Packet dropped: length 28 > maxpktsize 0 (addr=1) |
| 23085 | **DUT** | ROUTER DROPS PACKET addr=1 length=28 (length > maxpktsize) |
| 23090 | yapp driver | TX pkt #55 accepted by the DUT |
| 23090 | yapp driver | TX pkt #56: addr=0 len=40 parity=good delay=17 |
| 23265 | **DUT** | IN  pkt #56 header: addr=0 len=40 -> DROP (oversized: len 40 > maxpktsize 0) |
| 23675 | **DUT** | IN  pkt #56 complete: addr=0 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 23675 | yapp monitor | RX pkt #56 on the input: addr=0 len=40 parity=good gap=17 |
| 23675 | reference | Packet dropped: length 40 > maxpktsize 0 (addr=0) |
| 23675 | **DUT** | ROUTER DROPS PACKET addr=0 length=40 (length > maxpktsize) |
| 23680 | yapp driver | TX pkt #56 accepted by the DUT |
| 23680 | yapp driver | TX pkt #57: addr=2 len=63 parity=good delay=0 |
| 23685 | **DUT** | IN  pkt #57 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 24325 | **DUT** | IN  pkt #57 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 24325 | yapp monitor | RX pkt #57 on the input: addr=2 len=63 parity=good gap=0 |
| 24325 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 24325 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 24330 | yapp driver | TX pkt #57 accepted by the DUT |
| 24330 | yapp driver | TX pkt #58: addr=0 len=63 parity=bad delay=0 |
| 24335 | **DUT** | IN  pkt #58 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 24975 | **DUT** | IN  pkt #58 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 24975 | yapp monitor | RX pkt #58 on the input: addr=0 len=63 parity=bad gap=0 |
| 24975 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=0) |
| 24975 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 24980 | yapp driver | TX pkt #58 accepted by the DUT |
| 24980 | yapp driver | TX pkt #59: addr=2 len=57 parity=bad delay=20 |
| 25010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 25010 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 25185 | **DUT** | IN  pkt #59 header: addr=2 len=57 -> DROP (oversized: len 57 > maxpktsize 0) |
| 25765 | **DUT** | IN  pkt #59 complete: addr=2 len=57 parity=BAD dropped, 59 bytes in 59 cycles (held 0) |
| 25765 | yapp monitor | RX pkt #59 on the input: addr=2 len=57 parity=bad gap=20 |
| 25765 | reference | Packet dropped: length 57 > maxpktsize 0 (addr=2) |
| 25765 | **DUT** | ROUTER DROPS PACKET addr=2 length=57 (length > maxpktsize) |
| 25770 | yapp driver | TX pkt #59 accepted by the DUT |
| 25770 | yapp driver | TX pkt #60: addr=2 len=1 parity=good delay=1 |
| 25785 | **DUT** | IN  pkt #60 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 25790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 25790 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 25805 | **DUT** | IN  pkt #60 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 25805 | yapp monitor | RX pkt #60 on the input: addr=2 len=1 parity=good gap=1 |
| 25805 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 25805 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 25810 | yapp driver | TX pkt #60 accepted by the DUT |
| 25810 | yapp driver | TX pkt #61: addr=2 len=22 parity=bad delay=20 |
| 26015 | **DUT** | IN  pkt #61 header: addr=2 len=22 -> DROP (oversized: len 22 > maxpktsize 0) |
| 26245 | **DUT** | IN  pkt #61 complete: addr=2 len=22 parity=BAD dropped, 24 bytes in 24 cycles (held 0) |
| 26245 | yapp monitor | RX pkt #61 on the input: addr=2 len=22 parity=bad gap=20 |
| 26245 | reference | Packet dropped: length 22 > maxpktsize 0 (addr=2) |
| 26245 | **DUT** | ROUTER DROPS PACKET addr=2 length=22 (length > maxpktsize) |
| 26250 | yapp driver | TX pkt #61 accepted by the DUT |
| 26250 | yapp driver | TX pkt #62: addr=0 len=19 parity=good delay=1 |
| 26265 | **DUT** | IN  pkt #62 header: addr=0 len=19 -> DROP (oversized: len 19 > maxpktsize 0) |
| 26270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 26270 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 26465 | **DUT** | IN  pkt #62 complete: addr=0 len=19 parity=ok dropped, 21 bytes in 21 cycles (held 0) |
| 26465 | yapp monitor | RX pkt #62 on the input: addr=0 len=19 parity=good gap=1 |
| 26465 | reference | Packet dropped: length 19 > maxpktsize 0 (addr=0) |
| 26465 | **DUT** | ROUTER DROPS PACKET addr=0 length=19 (length > maxpktsize) |
| 26470 | yapp driver | TX pkt #62 accepted by the DUT |
| 26470 | yapp driver | TX pkt #63: addr=2 len=61 parity=good delay=1 |
| 26485 | **DUT** | IN  pkt #63 header: addr=2 len=61 -> DROP (oversized: len 61 > maxpktsize 0) |
| 27105 | **DUT** | IN  pkt #63 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 27105 | yapp monitor | RX pkt #63 on the input: addr=2 len=61 parity=good gap=1 |
| 27105 | reference | Packet dropped: length 61 > maxpktsize 0 (addr=2) |
| 27105 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (length > maxpktsize) |
| 27110 | yapp driver | TX pkt #63 accepted by the DUT |
| 27110 | yapp driver | TX pkt #64: addr=2 len=24 parity=good delay=3 |
| 27145 | **DUT** | IN  pkt #64 header: addr=2 len=24 -> DROP (oversized: len 24 > maxpktsize 0) |
| 27395 | **DUT** | IN  pkt #64 complete: addr=2 len=24 parity=ok dropped, 26 bytes in 26 cycles (held 0) |
| 27395 | yapp monitor | RX pkt #64 on the input: addr=2 len=24 parity=good gap=3 |
| 27395 | reference | Packet dropped: length 24 > maxpktsize 0 (addr=2) |
| 27395 | **DUT** | ROUTER DROPS PACKET addr=2 length=24 (length > maxpktsize) |
| 27400 | yapp driver | TX pkt #64 accepted by the DUT |
| 27400 | yapp driver | TX pkt #65: addr=2 len=53 parity=good delay=4 |
| 27445 | **DUT** | IN  pkt #65 header: addr=2 len=53 -> DROP (oversized: len 53 > maxpktsize 0) |
| 27985 | **DUT** | IN  pkt #65 complete: addr=2 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 27985 | yapp monitor | RX pkt #65 on the input: addr=2 len=53 parity=good gap=4 |
| 27985 | reference | Packet dropped: length 53 > maxpktsize 0 (addr=2) |
| 27985 | **DUT** | ROUTER DROPS PACKET addr=2 length=53 (length > maxpktsize) |
| 27990 | yapp driver | TX pkt #65 accepted by the DUT |
| 27990 | yapp driver | TX pkt #66: addr=0 len=9 parity=good delay=4 |
| 28035 | **DUT** | IN  pkt #66 header: addr=0 len=9 -> DROP (oversized: len 9 > maxpktsize 0) |
| 28135 | **DUT** | IN  pkt #66 complete: addr=0 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 28135 | yapp monitor | RX pkt #66 on the input: addr=0 len=9 parity=good gap=4 |
| 28135 | reference | Packet dropped: length 9 > maxpktsize 0 (addr=0) |
| 28135 | **DUT** | ROUTER DROPS PACKET addr=0 length=9 (length > maxpktsize) |
| 28140 | yapp driver | TX pkt #66 accepted by the DUT |
| 28140 | yapp driver | TX pkt #67: addr=1 len=2 parity=bad delay=2 |
| 28165 | **DUT** | IN  pkt #67 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 0) |
| 28195 | **DUT** | IN  pkt #67 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 28195 | yapp monitor | RX pkt #67 on the input: addr=1 len=2 parity=bad gap=2 |
| 28195 | reference | Packet dropped: length 2 > maxpktsize 0 (addr=1) |
| 28195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 28200 | yapp driver | TX pkt #67 accepted by the DUT |
| 28200 | yapp driver | TX pkt #68: addr=1 len=47 parity=good delay=0 |
| 28205 | **DUT** | IN  pkt #68 header: addr=1 len=47 -> DROP (oversized: len 47 > maxpktsize 0) |
| 28250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 28250 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 28685 | **DUT** | IN  pkt #68 complete: addr=1 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 28685 | yapp monitor | RX pkt #68 on the input: addr=1 len=47 parity=good gap=0 |
| 28685 | reference | Packet dropped: length 47 > maxpktsize 0 (addr=1) |
| 28685 | **DUT** | ROUTER DROPS PACKET addr=1 length=47 (length > maxpktsize) |
| 28690 | yapp driver | TX pkt #68 accepted by the DUT |
| 28690 | yapp driver | TX pkt #69: addr=0 len=63 parity=good delay=5 |
| 28745 | **DUT** | IN  pkt #69 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 29385 | **DUT** | IN  pkt #69 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 29385 | yapp monitor | RX pkt #69 on the input: addr=0 len=63 parity=good gap=5 |
| 29385 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=0) |
| 29385 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 29390 | yapp driver | TX pkt #69 accepted by the DUT |
| 29390 | yapp driver | TX pkt #70: addr=2 len=1 parity=good delay=2 |
| 29415 | **DUT** | IN  pkt #70 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 29435 | **DUT** | IN  pkt #70 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 29435 | yapp monitor | RX pkt #70 on the input: addr=2 len=1 parity=good gap=2 |
| 29435 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 29435 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 29440 | yapp driver | TX pkt #70 accepted by the DUT |
| 29440 | yapp driver | TX pkt #71: addr=1 len=41 parity=good delay=1 |
| 29455 | **DUT** | IN  pkt #71 header: addr=1 len=41 -> DROP (oversized: len 41 > maxpktsize 0) |
| 29875 | **DUT** | IN  pkt #71 complete: addr=1 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 29875 | yapp monitor | RX pkt #71 on the input: addr=1 len=41 parity=good gap=1 |
| 29875 | reference | Packet dropped: length 41 > maxpktsize 0 (addr=1) |
| 29875 | **DUT** | ROUTER DROPS PACKET addr=1 length=41 (length > maxpktsize) |
| 29880 | yapp driver | TX pkt #71 accepted by the DUT |
| 29880 | yapp driver | TX pkt #72: addr=0 len=52 parity=good delay=20 |
| 30085 | **DUT** | IN  pkt #72 header: addr=0 len=52 -> DROP (oversized: len 52 > maxpktsize 0) |
| 30615 | **DUT** | IN  pkt #72 complete: addr=0 len=52 parity=ok dropped, 54 bytes in 54 cycles (held 0) |
| 30615 | yapp monitor | RX pkt #72 on the input: addr=0 len=52 parity=good gap=20 |
| 30615 | reference | Packet dropped: length 52 > maxpktsize 0 (addr=0) |
| 30615 | **DUT** | ROUTER DROPS PACKET addr=0 length=52 (length > maxpktsize) |
| 30620 | yapp driver | TX pkt #72 accepted by the DUT |
| 30620 | yapp driver | TX pkt #73: addr=2 len=27 parity=good delay=0 |
| 30625 | **DUT** | IN  pkt #73 header: addr=2 len=27 -> DROP (oversized: len 27 > maxpktsize 0) |
| 30905 | **DUT** | IN  pkt #73 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 30905 | yapp monitor | RX pkt #73 on the input: addr=2 len=27 parity=good gap=0 |
| 30905 | reference | Packet dropped: length 27 > maxpktsize 0 (addr=2) |
| 30905 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (length > maxpktsize) |
| 30910 | yapp driver | TX pkt #73 accepted by the DUT |
| 30910 | yapp driver | TX pkt #74: addr=2 len=5 parity=good delay=1 |
| 30925 | **DUT** | IN  pkt #74 header: addr=2 len=5 -> DROP (oversized: len 5 > maxpktsize 0) |
| 30985 | **DUT** | IN  pkt #74 complete: addr=2 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 30985 | yapp monitor | RX pkt #74 on the input: addr=2 len=5 parity=good gap=1 |
| 30985 | reference | Packet dropped: length 5 > maxpktsize 0 (addr=2) |
| 30985 | **DUT** | ROUTER DROPS PACKET addr=2 length=5 (length > maxpktsize) |
| 30990 | yapp driver | TX pkt #74 accepted by the DUT |
| 30990 | yapp driver | TX pkt #75: addr=2 len=63 parity=good delay=2 |
| 31015 | **DUT** | IN  pkt #75 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 31655 | **DUT** | IN  pkt #75 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 31655 | yapp monitor | RX pkt #75 on the input: addr=2 len=63 parity=good gap=2 |
| 31655 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 31655 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 31660 | yapp driver | TX pkt #75 accepted by the DUT |
| 31660 | yapp driver | TX pkt #76: addr=2 len=63 parity=good delay=0 |
| 31665 | **DUT** | IN  pkt #76 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 32305 | **DUT** | IN  pkt #76 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 32305 | yapp monitor | RX pkt #76 on the input: addr=2 len=63 parity=good gap=0 |
| 32305 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 32305 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 32310 | yapp driver | TX pkt #76 accepted by the DUT |
| 32310 | yapp driver | TX pkt #77: addr=2 len=29 parity=good delay=18 |
| 32495 | **DUT** | IN  pkt #77 header: addr=2 len=29 -> DROP (oversized: len 29 > maxpktsize 0) |
| 32795 | **DUT** | IN  pkt #77 complete: addr=2 len=29 parity=ok dropped, 31 bytes in 31 cycles (held 0) |
| 32795 | yapp monitor | RX pkt #77 on the input: addr=2 len=29 parity=good gap=18 |
| 32795 | reference | Packet dropped: length 29 > maxpktsize 0 (addr=2) |
| 32795 | **DUT** | ROUTER DROPS PACKET addr=2 length=29 (length > maxpktsize) |
| 32800 | yapp driver | TX pkt #77 accepted by the DUT |
| 32800 | yapp driver | TX pkt #78: addr=0 len=23 parity=good delay=0 |
| 32805 | **DUT** | IN  pkt #78 header: addr=0 len=23 -> DROP (oversized: len 23 > maxpktsize 0) |
| 33045 | **DUT** | IN  pkt #78 complete: addr=0 len=23 parity=ok dropped, 25 bytes in 25 cycles (held 0) |
| 33045 | yapp monitor | RX pkt #78 on the input: addr=0 len=23 parity=good gap=0 |
| 33045 | reference | Packet dropped: length 23 > maxpktsize 0 (addr=0) |
| 33045 | **DUT** | ROUTER DROPS PACKET addr=0 length=23 (length > maxpktsize) |
| 33050 | yapp driver | TX pkt #78 accepted by the DUT |
| 33050 | yapp driver | TX pkt #79: addr=3 len=26 parity=good delay=20 |
| 33255 | **DUT** | IN  pkt #79 header: addr=3 len=26 -> DROP (oversized: len 26 > maxpktsize 0) |
| 33525 | **DUT** | IN  pkt #79 complete: addr=3 len=26 parity=ok dropped, 28 bytes in 28 cycles (held 0) |
| 33525 | yapp monitor | RX pkt #79 on the input: addr=3 len=26 parity=good gap=20 |
| 33525 | reference | Packet dropped: illegal address 3 (len=26) |
| 33525 | **DUT** | ROUTER DROPS PACKET addr=3 length=26 (    illegal address) |
| 33530 | yapp driver | TX pkt #79 accepted by the DUT |
| 33530 | yapp driver | TX pkt #80: addr=1 len=63 parity=good delay=0 |
| 33535 | **DUT** | IN  pkt #80 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 34175 | **DUT** | IN  pkt #80 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 34175 | yapp monitor | RX pkt #80 on the input: addr=1 len=63 parity=good gap=0 |
| 34175 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 34175 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 34180 | yapp driver | TX pkt #80 accepted by the DUT |
| 34180 | yapp driver | TX pkt #81: addr=1 len=5 parity=bad delay=2 |
| 34205 | **DUT** | IN  pkt #81 header: addr=1 len=5 -> DROP (oversized: len 5 > maxpktsize 0) |
| 34265 | **DUT** | IN  pkt #81 complete: addr=1 len=5 parity=BAD dropped, 7 bytes in 7 cycles (held 0) |
| 34265 | yapp monitor | RX pkt #81 on the input: addr=1 len=5 parity=bad gap=2 |
| 34265 | reference | Packet dropped: length 5 > maxpktsize 0 (addr=1) |
| 34265 | **DUT** | ROUTER DROPS PACKET addr=1 length=5 (length > maxpktsize) |
| 34270 | yapp driver | TX pkt #81 accepted by the DUT |
| 34270 | yapp driver | TX pkt #82: addr=2 len=54 parity=good delay=2 |
| 34295 | **DUT** | IN  pkt #82 header: addr=2 len=54 -> DROP (oversized: len 54 > maxpktsize 0) |
| 34310 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 34310 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 34845 | **DUT** | IN  pkt #82 complete: addr=2 len=54 parity=ok dropped, 56 bytes in 56 cycles (held 0) |
| 34845 | yapp monitor | RX pkt #82 on the input: addr=2 len=54 parity=good gap=2 |
| 34845 | reference | Packet dropped: length 54 > maxpktsize 0 (addr=2) |
| 34845 | **DUT** | ROUTER DROPS PACKET addr=2 length=54 (length > maxpktsize) |
| 34850 | yapp driver | TX pkt #82 accepted by the DUT |
| 34850 | yapp driver | TX pkt #83: addr=0 len=63 parity=bad delay=0 |
| 34855 | **DUT** | IN  pkt #83 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 35495 | **DUT** | IN  pkt #83 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 35495 | yapp monitor | RX pkt #83 on the input: addr=0 len=63 parity=bad gap=0 |
| 35495 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=0) |
| 35495 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 35500 | yapp driver | TX pkt #83 accepted by the DUT |
| 35500 | yapp driver | TX pkt #84: addr=0 len=15 parity=good delay=20 |
| 35590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 35590 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 35705 | **DUT** | IN  pkt #84 header: addr=0 len=15 -> DROP (oversized: len 15 > maxpktsize 0) |
| 35865 | **DUT** | IN  pkt #84 complete: addr=0 len=15 parity=ok dropped, 17 bytes in 17 cycles (held 0) |
| 35865 | yapp monitor | RX pkt #84 on the input: addr=0 len=15 parity=good gap=20 |
| 35865 | reference | Packet dropped: length 15 > maxpktsize 0 (addr=0) |
| 35865 | **DUT** | ROUTER DROPS PACKET addr=0 length=15 (length > maxpktsize) |
| 35870 | yapp driver | TX pkt #84 accepted by the DUT |
| 35870 | yapp driver | TX pkt #85: addr=1 len=1 parity=good delay=16 |
| 36035 | **DUT** | IN  pkt #85 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 36055 | **DUT** | IN  pkt #85 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 36055 | yapp monitor | RX pkt #85 on the input: addr=1 len=1 parity=good gap=16 |
| 36055 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 36055 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 36060 | yapp driver | TX pkt #85 accepted by the DUT |
| 36060 | **test** | STAGE: burst 2/2 sent: addr0..3 10/11/19/3, bad parity 7, gap 0 11, length 1..63 |
| 36060 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 36090 | hbus driver | Executed READ  addr=0x1000 data=0xc0 |
| 36095 | hbus monitor | Collected READ  addr=0x1000 data=0xc0 |
| 36120 | hbus driver | Executed READ  addr=0x1001 data=0xc9 |
| 36125 | hbus monitor | Collected READ  addr=0x1001 data=0xc9 |
| 36150 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 36155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 36180 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 36185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36210 | hbus driver | Executed READ  addr=0x1006 data=0x03 |
| 36215 | hbus monitor | Collected READ  addr=0x1006 data=0x03 |
| 36240 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 36245 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36270 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 36275 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36300 | hbus driver | Executed READ  addr=0x100b data=0x13 |
| 36305 | hbus monitor | Collected READ  addr=0x100b data=0x13 |
| 36330 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 36335 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 36360 | hbus driver | Executed READ  addr=0x1010 data=0x05 |
| 36365 | hbus monitor | Collected READ  addr=0x1010 data=0x05 |
| 36390 | hbus driver | Executed READ  addr=0x1011 data=0x30 |
| 36395 | hbus monitor | Collected READ  addr=0x1011 data=0x30 |
| 36505 | **test** | STAGE: done: 85 packets (0 forwarded, 85 dropped), 0 storm burst(s), 0 scoreboard matches, 16 HBUS reads checked, 7 error pulses for 7 bad packets |
| 36705 | error checker | error pulse report: 7 bad packets, 7 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 36705 | ch0 monitor | Channel 0 report: 0 packets collected |
| 36705 | ch1 monitor | Channel 1 report: 0 packets collected |
| 36705 | ch2 monitor | Channel 2 report: 0 packets collected |
| 36705 | hbus monitor | HBUS report: 5 writes, 18 reads |
| 36705 | coverage | Coverage of the router configuration: 47.8% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 43 / 0 / 0 / 0 / 0 packets · length < max / = max / max+1 / > max+1 : 0 / 0 / 8 / 35 · forwarded good / bad : 0 / 0 · dropped address 3 good / bad : 3 / 0 · dropped oversized good / bad : 33 / 7 · counter enables none / mixed / all : 0 / 43 / 0 |
| 36705 | coverage | HBUS address coverage: 23 accesses sampled, coverage 40.3% |
| 36705 | coverage | HBUS register bits coverage: 4 writes to ctrl_reg/en_reg, coverage 79.5% |
| 36705 | coverage | HBUS counter value coverage: 6 counter reads sampled, coverage 51.9% |
| 36705 | coverage | HBUS yapp_mem data coverage: 2 accesses sampled, coverage 29.4% |
| 36705 | reference | --- Reference model report --- · forwarded to scoreboard : 0 · dropped (router disabled) : 42 · dropped (oversized) : 40 · dropped (address 3) : 3 · counters parity/oversized/addr0..3 : 0 / 0 / 0 0 19 3 |
| 36705 | reference | HBUS reads checked against the model: 16 (0 mismatches, 2 of memory bytes never written) |
| 36705 | scoreboard | --- Scoreboard report --- · packets received : 0 · packets matched : 0 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 36705 | yapp driver | YAPP driver report: 85 packets sent |
| 36705 | coverage | YAPP gap coverage: 84 gaps sampled, coverage 100.0% |
| 36705 | yapp monitor | YAPP monitor report: 85 packets collected, 10 with bad parity |
| 36705 | yapp monitor | YAPP gaps: 16 back to back, 17 of 1 cycle, 12 of 2, 39 longer |
| 36705 | coverage | YAPP packet coverage: 85 packets sampled, coverage 66.7% |
