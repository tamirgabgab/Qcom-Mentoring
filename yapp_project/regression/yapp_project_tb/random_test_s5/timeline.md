# random_test seed 5

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 33us · wall 18.2 s · log [`random_test_s5.log`](random_test_s5.log)

Waves: `random_test_s5.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s5%2Frandom_test_s5.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **73** packet(s) (9 with bad parity); the input monitor saw 73.
- Router: **23** forwarded, **50** dropped (50 oversized).
- Packets out: ch0 **6**, ch1 **5**, ch2 **12**.
- Scoreboard: 23 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 9.
- HBUS: 17 write(s), 89 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 73 packets in 4 bursts |
| 340 | burst 1/4: ctrl=0x00 (maxpktsize 0) en=0xd9 (router on, counter enables 1101100), 19 packet(s) |
| 7760 | burst 1/4 sent: addr0..3 1/5/11/2, bad parity 3, gap 0 7, length 1..63 |
| 8020 | burst 2/4: ctrl=0x44 (maxpktsize 4) en=0xcb (router on, counter enables 1100101), 18 packet(s) |
| 15020 | burst 2/4 sent: addr0..3 5/4/8/1, bad parity 2, gap 0 6, length 1..63 |
| 15380 | burst 3/4: ctrl=0x60 (maxpktsize 32) en=0x7f (router on, counter enables 0111111), 18 packet(s) |
| 22990 | burst 3/4 sent: addr0..3 4/3/11/0, bad parity 1, gap 0 8, length 9..63 |
| 23140 | burst 4/4: ctrl=0xb8 (maxpktsize 56) en=0xe3 (router on, counter enables 1110001), 18 packet(s) |
| 31170 | burst 4/4 sent: addr0..3 4/5/9/0, bad parity 3, gap 0 8, length 8..63 |
| 31170 | final reads: every register and the stored packet, checked against the reference model |
| 33235 | done: 73 packets (23 forwarded, 50 dropped), 0 storm burst(s), 23 scoreboard matches, 88 HBUS reads checked, 9 error pulses for 9 bad packets |

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

896 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 73 packets in 4 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 75 | reference | maxpktsize is now 0 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xd9 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xd9 |
| 95 | reference | router_en is now 1 (en_reg 0xd9) |
| 120 | hbus driver | Executed READ  addr=0x1000 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x1035 data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x1035 data=0x00 |
| 170 | hbus driver | Executed WRITE addr=0x1173 data=0x99 |
| 175 | hbus monitor | Collected WRITE addr=0x1173 data=0x99 |
| 200 | hbus driver | Executed READ  addr=0x1173 data=0x99 |
| 205 | hbus monitor | Collected READ  addr=0x1173 data=0x99 |
| 230 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 235 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 250 | hbus driver | Executed WRITE addr=0x116d data=0xca |
| 255 | hbus monitor | Collected WRITE addr=0x116d data=0xca |
| 280 | hbus driver | Executed READ  addr=0x116d data=0xca |
| 285 | hbus monitor | Collected READ  addr=0x116d data=0xca |
| 310 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 315 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 340 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 340 | **test** | STAGE: burst 1/4: ctrl=0x00 (maxpktsize 0) en=0xd9 (router on, counter enables 1101100), 19 packet(s) |
| 340 | yapp driver | TX pkt #1: addr=0 len=1 parity=bad delay=9 |
| 345 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 445 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 465 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 465 | yapp monitor | RX pkt #1 on the input: addr=0 len=1 parity=bad gap=39 |
| 465 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 465 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 470 | yapp driver | TX pkt #1 accepted by the DUT |
| 470 | yapp driver | TX pkt #2: addr=3 len=1 parity=good delay=7 |
| 545 | **DUT** | IN  pkt #2 header: addr=3 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 565 | **DUT** | IN  pkt #2 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 565 | yapp monitor | RX pkt #2 on the input: addr=3 len=1 parity=good gap=7 |
| 565 | reference | Packet dropped: illegal address 3 (len=1) |
| 565 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 570 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 570 | yapp driver | TX pkt #2 accepted by the DUT |
| 570 | yapp driver | TX pkt #3: addr=2 len=1 parity=good delay=1 |
| 585 | **DUT** | IN  pkt #3 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 605 | **DUT** | IN  pkt #3 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 605 | yapp monitor | RX pkt #3 on the input: addr=2 len=1 parity=good gap=1 |
| 605 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 605 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 610 | yapp driver | TX pkt #3 accepted by the DUT |
| 610 | yapp driver | TX pkt #4: addr=3 len=41 parity=good delay=3 |
| 645 | **DUT** | IN  pkt #4 header: addr=3 len=41 -> DROP (oversized: len 41 > maxpktsize 0) |
| 1065 | **DUT** | IN  pkt #4 complete: addr=3 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 1065 | yapp monitor | RX pkt #4 on the input: addr=3 len=41 parity=good gap=3 |
| 1065 | reference | Packet dropped: illegal address 3 (len=41) |
| 1065 | **DUT** | ROUTER DROPS PACKET addr=3 length=41 (    illegal address) |
| 1070 | yapp driver | TX pkt #4 accepted by the DUT |
| 1070 | yapp driver | TX pkt #5: addr=2 len=12 parity=good delay=12 |
| 1195 | **DUT** | IN  pkt #5 header: addr=2 len=12 -> DROP (oversized: len 12 > maxpktsize 0) |
| 1325 | **DUT** | IN  pkt #5 complete: addr=2 len=12 parity=ok dropped, 14 bytes in 14 cycles (held 0) |
| 1325 | yapp monitor | RX pkt #5 on the input: addr=2 len=12 parity=good gap=12 |
| 1325 | reference | Packet dropped: length 12 > maxpktsize 0 (addr=2) |
| 1325 | **DUT** | ROUTER DROPS PACKET addr=2 length=12 (length > maxpktsize) |
| 1330 | yapp driver | TX pkt #5 accepted by the DUT |
| 1330 | yapp driver | TX pkt #6: addr=1 len=17 parity=good delay=1 |
| 1345 | **DUT** | IN  pkt #6 header: addr=1 len=17 -> DROP (oversized: len 17 > maxpktsize 0) |
| 1525 | **DUT** | IN  pkt #6 complete: addr=1 len=17 parity=ok dropped, 19 bytes in 19 cycles (held 0) |
| 1525 | yapp monitor | RX pkt #6 on the input: addr=1 len=17 parity=good gap=1 |
| 1525 | reference | Packet dropped: length 17 > maxpktsize 0 (addr=1) |
| 1525 | **DUT** | ROUTER DROPS PACKET addr=1 length=17 (length > maxpktsize) |
| 1530 | yapp driver | TX pkt #6 accepted by the DUT |
| 1530 | yapp driver | TX pkt #7: addr=1 len=32 parity=good delay=7 |
| 1605 | **DUT** | IN  pkt #7 header: addr=1 len=32 -> DROP (oversized: len 32 > maxpktsize 0) |
| 1935 | **DUT** | IN  pkt #7 complete: addr=1 len=32 parity=ok dropped, 34 bytes in 34 cycles (held 0) |
| 1935 | yapp monitor | RX pkt #7 on the input: addr=1 len=32 parity=good gap=7 |
| 1935 | reference | Packet dropped: length 32 > maxpktsize 0 (addr=1) |
| 1935 | **DUT** | ROUTER DROPS PACKET addr=1 length=32 (length > maxpktsize) |
| 1940 | yapp driver | TX pkt #7 accepted by the DUT |
| 1940 | yapp driver | TX pkt #8: addr=1 len=37 parity=bad delay=17 |
| 2115 | **DUT** | IN  pkt #8 header: addr=1 len=37 -> DROP (oversized: len 37 > maxpktsize 0) |
| 2495 | **DUT** | IN  pkt #8 complete: addr=1 len=37 parity=BAD dropped, 39 bytes in 39 cycles (held 0) |
| 2495 | yapp monitor | RX pkt #8 on the input: addr=1 len=37 parity=bad gap=17 |
| 2495 | reference | Packet dropped: length 37 > maxpktsize 0 (addr=1) |
| 2495 | **DUT** | ROUTER DROPS PACKET addr=1 length=37 (length > maxpktsize) |
| 2500 | yapp driver | TX pkt #8 accepted by the DUT |
| 2500 | yapp driver | TX pkt #9: addr=2 len=57 parity=good delay=1 |
| 2515 | **DUT** | IN  pkt #9 header: addr=2 len=57 -> DROP (oversized: len 57 > maxpktsize 0) |
| 2550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 2550 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 3095 | **DUT** | IN  pkt #9 complete: addr=2 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 3095 | yapp monitor | RX pkt #9 on the input: addr=2 len=57 parity=good gap=1 |
| 3095 | reference | Packet dropped: length 57 > maxpktsize 0 (addr=2) |
| 3095 | **DUT** | ROUTER DROPS PACKET addr=2 length=57 (length > maxpktsize) |
| 3100 | yapp driver | TX pkt #9 accepted by the DUT |
| 3100 | yapp driver | TX pkt #10: addr=2 len=41 parity=good delay=0 |
| 3105 | **DUT** | IN  pkt #10 header: addr=2 len=41 -> DROP (oversized: len 41 > maxpktsize 0) |
| 3525 | **DUT** | IN  pkt #10 complete: addr=2 len=41 parity=ok dropped, 43 bytes in 43 cycles (held 0) |
| 3525 | yapp monitor | RX pkt #10 on the input: addr=2 len=41 parity=good gap=0 |
| 3525 | reference | Packet dropped: length 41 > maxpktsize 0 (addr=2) |
| 3525 | **DUT** | ROUTER DROPS PACKET addr=2 length=41 (length > maxpktsize) |
| 3530 | yapp driver | TX pkt #10 accepted by the DUT |
| 3530 | yapp driver | TX pkt #11: addr=2 len=45 parity=good delay=0 |
| 3535 | **DUT** | IN  pkt #11 header: addr=2 len=45 -> DROP (oversized: len 45 > maxpktsize 0) |
| 3995 | **DUT** | IN  pkt #11 complete: addr=2 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 3995 | yapp monitor | RX pkt #11 on the input: addr=2 len=45 parity=good gap=0 |
| 3995 | reference | Packet dropped: length 45 > maxpktsize 0 (addr=2) |
| 3995 | **DUT** | ROUTER DROPS PACKET addr=2 length=45 (length > maxpktsize) |
| 4000 | yapp driver | TX pkt #11 accepted by the DUT |
| 4000 | yapp driver | TX pkt #12: addr=1 len=63 parity=bad delay=20 |
| 4205 | **DUT** | IN  pkt #12 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 4845 | **DUT** | IN  pkt #12 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 4845 | yapp monitor | RX pkt #12 on the input: addr=1 len=63 parity=bad gap=20 |
| 4845 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 4845 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 4850 | yapp driver | TX pkt #12 accepted by the DUT |
| 4850 | yapp driver | TX pkt #13: addr=2 len=63 parity=good delay=0 |
| 4855 | **DUT** | IN  pkt #13 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 4910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 4910 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 5495 | **DUT** | IN  pkt #13 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5495 | yapp monitor | RX pkt #13 on the input: addr=2 len=63 parity=good gap=0 |
| 5495 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 5495 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 5500 | yapp driver | TX pkt #13 accepted by the DUT |
| 5500 | yapp driver | TX pkt #14: addr=2 len=28 parity=good delay=0 |
| 5505 | **DUT** | IN  pkt #14 header: addr=2 len=28 -> DROP (oversized: len 28 > maxpktsize 0) |
| 5795 | **DUT** | IN  pkt #14 complete: addr=2 len=28 parity=ok dropped, 30 bytes in 30 cycles (held 0) |
| 5795 | yapp monitor | RX pkt #14 on the input: addr=2 len=28 parity=good gap=0 |
| 5795 | reference | Packet dropped: length 28 > maxpktsize 0 (addr=2) |
| 5795 | **DUT** | ROUTER DROPS PACKET addr=2 length=28 (length > maxpktsize) |
| 5800 | yapp driver | TX pkt #14 accepted by the DUT |
| 5800 | yapp driver | TX pkt #15: addr=1 len=19 parity=good delay=1 |
| 5815 | **DUT** | IN  pkt #15 header: addr=1 len=19 -> DROP (oversized: len 19 > maxpktsize 0) |
| 6015 | **DUT** | IN  pkt #15 complete: addr=1 len=19 parity=ok dropped, 21 bytes in 21 cycles (held 0) |
| 6015 | yapp monitor | RX pkt #15 on the input: addr=1 len=19 parity=good gap=1 |
| 6015 | reference | Packet dropped: length 19 > maxpktsize 0 (addr=1) |
| 6015 | **DUT** | ROUTER DROPS PACKET addr=1 length=19 (length > maxpktsize) |
| 6020 | yapp driver | TX pkt #15 accepted by the DUT |
| 6020 | yapp driver | TX pkt #16: addr=2 len=62 parity=good delay=0 |
| 6025 | **DUT** | IN  pkt #16 header: addr=2 len=62 -> DROP (oversized: len 62 > maxpktsize 0) |
| 6655 | **DUT** | IN  pkt #16 complete: addr=2 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 6655 | yapp monitor | RX pkt #16 on the input: addr=2 len=62 parity=good gap=0 |
| 6655 | reference | Packet dropped: length 62 > maxpktsize 0 (addr=2) |
| 6655 | **DUT** | ROUTER DROPS PACKET addr=2 length=62 (length > maxpktsize) |
| 6660 | yapp driver | TX pkt #16 accepted by the DUT |
| 6660 | yapp driver | TX pkt #17: addr=2 len=39 parity=good delay=3 |
| 6695 | **DUT** | IN  pkt #17 header: addr=2 len=39 -> DROP (oversized: len 39 > maxpktsize 0) |
| 7095 | **DUT** | IN  pkt #17 complete: addr=2 len=39 parity=ok dropped, 41 bytes in 41 cycles (held 0) |
| 7095 | yapp monitor | RX pkt #17 on the input: addr=2 len=39 parity=good gap=3 |
| 7095 | reference | Packet dropped: length 39 > maxpktsize 0 (addr=2) |
| 7095 | **DUT** | ROUTER DROPS PACKET addr=2 length=39 (length > maxpktsize) |
| 7100 | yapp driver | TX pkt #17 accepted by the DUT |
| 7100 | yapp driver | TX pkt #18: addr=2 len=16 parity=good delay=0 |
| 7105 | **DUT** | IN  pkt #18 header: addr=2 len=16 -> DROP (oversized: len 16 > maxpktsize 0) |
| 7275 | **DUT** | IN  pkt #18 complete: addr=2 len=16 parity=ok dropped, 18 bytes in 18 cycles (held 0) |
| 7275 | yapp monitor | RX pkt #18 on the input: addr=2 len=16 parity=good gap=0 |
| 7275 | reference | Packet dropped: length 16 > maxpktsize 0 (addr=2) |
| 7275 | **DUT** | ROUTER DROPS PACKET addr=2 length=16 (length > maxpktsize) |
| 7280 | yapp driver | TX pkt #18 accepted by the DUT |
| 7280 | yapp driver | TX pkt #19: addr=2 len=46 parity=good delay=0 |
| 7285 | **DUT** | IN  pkt #19 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 0) |
| 7755 | **DUT** | IN  pkt #19 complete: addr=2 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 7755 | yapp monitor | RX pkt #19 on the input: addr=2 len=46 parity=good gap=0 |
| 7755 | reference | Packet dropped: length 46 > maxpktsize 0 (addr=2) |
| 7755 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 7760 | yapp driver | TX pkt #19 accepted by the DUT |
| 7760 | **test** | STAGE: burst 1/4 sent: addr0..3 1/5/11/2, bad parity 3, gap 0 7, length 1..63 |
| 7780 | hbus driver | Executed WRITE addr=0x1000 data=0x44 |
| 7785 | **DUT** | CONFIG router_en=1 maxpktsize=4 |
| 7785 | hbus monitor | Collected WRITE addr=0x1000 data=0x44 |
| 7785 | reference | maxpktsize is now 4 |
| 7800 | hbus driver | Executed WRITE addr=0x1001 data=0xcb |
| 7805 | hbus monitor | Collected WRITE addr=0x1001 data=0xcb |
| 7805 | reference | router_en is now 1 (en_reg 0xcb) |
| 7820 | hbus driver | Executed WRITE addr=0x1193 data=0x7c |
| 7825 | hbus monitor | Collected WRITE addr=0x1193 data=0x7c |
| 7850 | hbus driver | Executed READ  addr=0x1193 data=0x7c |
| 7855 | hbus monitor | Collected READ  addr=0x1193 data=0x7c |
| 7880 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 7885 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7910 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 7915 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7940 | hbus driver | Executed READ  addr=0x100d data=0x2e |
| 7945 | hbus monitor | Collected READ  addr=0x100d data=0x2e |
| 7960 | hbus driver | Executed WRITE addr=0x1124 data=0x3d |
| 7965 | hbus monitor | Collected WRITE addr=0x1124 data=0x3d |
| 7990 | hbus driver | Executed READ  addr=0x1124 data=0x3d |
| 7995 | hbus monitor | Collected READ  addr=0x1124 data=0x3d |
| 8020 | hbus driver | Executed READ  addr=0x1038 data=0x97 |
| 8020 | **test** | STAGE: burst 2/4: ctrl=0x44 (maxpktsize 4) en=0xcb (router on, counter enables 1100101), 18 packet(s) |
| 8020 | yapp driver | TX pkt #20: addr=0 len=48 parity=good delay=1 |
| 8025 | hbus monitor | Collected READ  addr=0x1038 data=0x97 |
| 8045 | **DUT** | IN  pkt #20 header: addr=0 len=48 -> DROP (oversized: len 48 > maxpktsize 4) |
| 8535 | **DUT** | IN  pkt #20 complete: addr=0 len=48 parity=ok dropped, 50 bytes in 50 cycles (held 0) |
| 8535 | yapp monitor | RX pkt #20 on the input: addr=0 len=48 parity=good gap=28 |
| 8535 | reference | Packet dropped: length 48 > maxpktsize 4 (addr=0) |
| 8535 | **DUT** | ROUTER DROPS PACKET addr=0 length=48 (length > maxpktsize) |
| 8540 | yapp driver | TX pkt #20 accepted by the DUT |
| 8540 | yapp driver | TX pkt #21: addr=2 len=53 parity=good delay=0 |
| 8545 | **DUT** | IN  pkt #21 header: addr=2 len=53 -> DROP (oversized: len 53 > maxpktsize 4) |
| 9085 | **DUT** | IN  pkt #21 complete: addr=2 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 9085 | yapp monitor | RX pkt #21 on the input: addr=2 len=53 parity=good gap=0 |
| 9085 | reference | Packet dropped: length 53 > maxpktsize 4 (addr=2) |
| 9085 | **DUT** | ROUTER DROPS PACKET addr=2 length=53 (length > maxpktsize) |
| 9090 | yapp driver | TX pkt #21 accepted by the DUT |
| 9090 | yapp driver | TX pkt #22: addr=2 len=63 parity=good delay=0 |
| 9095 | **DUT** | IN  pkt #22 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 4) |
| 9735 | **DUT** | IN  pkt #22 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 9735 | yapp monitor | RX pkt #22 on the input: addr=2 len=63 parity=good gap=0 |
| 9735 | reference | Packet dropped: length 63 > maxpktsize 4 (addr=2) |
| 9735 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 9740 | yapp driver | TX pkt #22 accepted by the DUT |
| 9740 | yapp driver | TX pkt #23: addr=0 len=46 parity=good delay=3 |
| 9775 | **DUT** | IN  pkt #23 header: addr=0 len=46 -> DROP (oversized: len 46 > maxpktsize 4) |
| 10245 | **DUT** | IN  pkt #23 complete: addr=0 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 10245 | yapp monitor | RX pkt #23 on the input: addr=0 len=46 parity=good gap=3 |
| 10245 | reference | Packet dropped: length 46 > maxpktsize 4 (addr=0) |
| 10245 | **DUT** | ROUTER DROPS PACKET addr=0 length=46 (length > maxpktsize) |
| 10250 | yapp driver | TX pkt #23 accepted by the DUT |
| 10250 | yapp driver | TX pkt #24: addr=1 len=46 parity=good delay=10 |
| 10355 | **DUT** | IN  pkt #24 header: addr=1 len=46 -> DROP (oversized: len 46 > maxpktsize 4) |
| 10825 | **DUT** | IN  pkt #24 complete: addr=1 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 10825 | yapp monitor | RX pkt #24 on the input: addr=1 len=46 parity=good gap=10 |
| 10825 | reference | Packet dropped: length 46 > maxpktsize 4 (addr=1) |
| 10825 | **DUT** | ROUTER DROPS PACKET addr=1 length=46 (length > maxpktsize) |
| 10830 | yapp driver | TX pkt #24 accepted by the DUT |
| 10830 | yapp driver | TX pkt #25: addr=1 len=40 parity=good delay=0 |
| 10835 | **DUT** | IN  pkt #25 header: addr=1 len=40 -> DROP (oversized: len 40 > maxpktsize 4) |
| 11245 | **DUT** | IN  pkt #25 complete: addr=1 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 11245 | yapp monitor | RX pkt #25 on the input: addr=1 len=40 parity=good gap=0 |
| 11245 | reference | Packet dropped: length 40 > maxpktsize 4 (addr=1) |
| 11245 | **DUT** | ROUTER DROPS PACKET addr=1 length=40 (length > maxpktsize) |
| 11250 | yapp driver | TX pkt #25 accepted by the DUT |
| 11250 | yapp driver | TX pkt #26: addr=0 len=46 parity=good delay=1 |
| 11265 | **DUT** | IN  pkt #26 header: addr=0 len=46 -> DROP (oversized: len 46 > maxpktsize 4) |
| 11735 | **DUT** | IN  pkt #26 complete: addr=0 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 11735 | yapp monitor | RX pkt #26 on the input: addr=0 len=46 parity=good gap=1 |
| 11735 | reference | Packet dropped: length 46 > maxpktsize 4 (addr=0) |
| 11735 | **DUT** | ROUTER DROPS PACKET addr=0 length=46 (length > maxpktsize) |
| 11740 | yapp driver | TX pkt #26 accepted by the DUT |
| 11740 | yapp driver | TX pkt #27: addr=0 len=13 parity=good delay=2 |
| 11765 | **DUT** | IN  pkt #27 header: addr=0 len=13 -> DROP (oversized: len 13 > maxpktsize 4) |
| 11905 | **DUT** | IN  pkt #27 complete: addr=0 len=13 parity=ok dropped, 15 bytes in 15 cycles (held 0) |
| 11905 | yapp monitor | RX pkt #27 on the input: addr=0 len=13 parity=good gap=2 |
| 11905 | reference | Packet dropped: length 13 > maxpktsize 4 (addr=0) |
| 11905 | **DUT** | ROUTER DROPS PACKET addr=0 length=13 (length > maxpktsize) |
| 11910 | yapp driver | TX pkt #27 accepted by the DUT |
| 11910 | yapp driver | TX pkt #28: addr=2 len=63 parity=good delay=9 |
| 12005 | **DUT** | IN  pkt #28 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 4) |
| 12645 | **DUT** | IN  pkt #28 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12645 | yapp monitor | RX pkt #28 on the input: addr=2 len=63 parity=good gap=9 |
| 12645 | reference | Packet dropped: length 63 > maxpktsize 4 (addr=2) |
| 12645 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 12650 | yapp driver | TX pkt #28 accepted by the DUT |
| 12650 | yapp driver | TX pkt #29: addr=2 len=27 parity=good delay=9 |
| 12745 | **DUT** | IN  pkt #29 header: addr=2 len=27 -> DROP (oversized: len 27 > maxpktsize 4) |
| 13025 | **DUT** | IN  pkt #29 complete: addr=2 len=27 parity=ok dropped, 29 bytes in 29 cycles (held 0) |
| 13025 | yapp monitor | RX pkt #29 on the input: addr=2 len=27 parity=good gap=9 |
| 13025 | reference | Packet dropped: length 27 > maxpktsize 4 (addr=2) |
| 13025 | **DUT** | ROUTER DROPS PACKET addr=2 length=27 (length > maxpktsize) |
| 13030 | yapp driver | TX pkt #29 accepted by the DUT |
| 13030 | yapp driver | TX pkt #30: addr=2 len=5 parity=good delay=20 |
| 13235 | **DUT** | IN  pkt #30 header: addr=2 len=5 -> DROP (oversized: len 5 > maxpktsize 4) |
| 13295 | **DUT** | IN  pkt #30 complete: addr=2 len=5 parity=ok dropped, 7 bytes in 7 cycles (held 0) |
| 13295 | yapp monitor | RX pkt #30 on the input: addr=2 len=5 parity=good gap=20 |
| 13295 | reference | Packet dropped: length 5 > maxpktsize 4 (addr=2) |
| 13295 | **DUT** | ROUTER DROPS PACKET addr=2 length=5 (length > maxpktsize) |
| 13300 | yapp driver | TX pkt #30 accepted by the DUT |
| 13300 | yapp driver | TX pkt #31: addr=1 len=8 parity=good delay=1 |
| 13315 | **DUT** | IN  pkt #31 header: addr=1 len=8 -> DROP (oversized: len 8 > maxpktsize 4) |
| 13405 | **DUT** | IN  pkt #31 complete: addr=1 len=8 parity=ok dropped, 10 bytes in 10 cycles (held 0) |
| 13405 | yapp monitor | RX pkt #31 on the input: addr=1 len=8 parity=good gap=1 |
| 13405 | reference | Packet dropped: length 8 > maxpktsize 4 (addr=1) |
| 13405 | **DUT** | ROUTER DROPS PACKET addr=1 length=8 (length > maxpktsize) |
| 13410 | yapp driver | TX pkt #31 accepted by the DUT |
| 13410 | yapp driver | TX pkt #32: addr=2 len=4 parity=good delay=0 |
| 13415 | **DUT** | IN  pkt #32 header: addr=2 len=4 -> channel 2 |
| 13425 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=4 (receiver waited 0 cycle(s)) |
| 13465 | **DUT** | IN  pkt #32 complete: addr=2 len=4 parity=ok forwarded, 6 bytes in 6 cycles (held 0) |
| 13465 | yapp monitor | RX pkt #32 on the input: addr=2 len=4 parity=good gap=0 |
| 13465 | reference | Packet forwarded: addr=2 len=4 -> channel 2 |
| 13470 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13470 | yapp driver | TX pkt #32 accepted by the DUT |
| 13470 | yapp driver | TX pkt #33: addr=0 len=44 parity=bad delay=6 |
| 13485 | **DUT** | OUT ch2 pkt #1 done: 6 bytes in 7 cycles |
| 13485 | ch2 monitor | ch2 RX pkt #1: addr=2 len=4 parity=good |
| 13485 | scoreboard | ch2 pkt matched: addr=2 len=4 (1 matched so far) |
| 13535 | **DUT** | IN  pkt #33 header: addr=0 len=44 -> DROP (oversized: len 44 > maxpktsize 4) |
| 13600 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13985 | **DUT** | IN  pkt #33 complete: addr=0 len=44 parity=BAD dropped, 46 bytes in 46 cycles (held 0) |
| 13985 | yapp monitor | RX pkt #33 on the input: addr=0 len=44 parity=bad gap=6 |
| 13985 | reference | Packet dropped: length 44 > maxpktsize 4 (addr=0) |
| 13985 | **DUT** | ROUTER DROPS PACKET addr=0 length=44 (length > maxpktsize) |
| 13990 | yapp driver | TX pkt #33 accepted by the DUT |
| 13990 | yapp driver | TX pkt #34: addr=2 len=45 parity=good delay=3 |
| 14010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 14010 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 14025 | **DUT** | IN  pkt #34 header: addr=2 len=45 -> DROP (oversized: len 45 > maxpktsize 4) |
| 14485 | **DUT** | IN  pkt #34 complete: addr=2 len=45 parity=ok dropped, 47 bytes in 47 cycles (held 0) |
| 14485 | yapp monitor | RX pkt #34 on the input: addr=2 len=45 parity=good gap=3 |
| 14485 | reference | Packet dropped: length 45 > maxpktsize 4 (addr=2) |
| 14485 | **DUT** | ROUTER DROPS PACKET addr=2 length=45 (length > maxpktsize) |
| 14490 | yapp driver | TX pkt #34 accepted by the DUT |
| 14490 | yapp driver | TX pkt #35: addr=1 len=1 parity=bad delay=14 |
| 14635 | **DUT** | IN  pkt #35 header: addr=1 len=1 -> channel 1 |
| 14655 | **DUT** | IN  pkt #35 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 14655 | yapp monitor | RX pkt #35 on the input: addr=1 len=1 parity=bad gap=14 |
| 14655 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 14660 | yapp driver | TX pkt #35 accepted by the DUT |
| 14660 | yapp driver | TX pkt #36: addr=3 len=23 parity=good delay=0 |
| 14665 | **DUT** | IN  pkt #36 header: addr=3 len=23 -> DROP (oversized: len 23 > maxpktsize 4) |
| 14710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 14710 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 14745 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=1 (receiver waited 10 cycle(s)) |
| 14760 | ch1 driver | ch1: packet consumed (response delay 10) |
| 14865 | **DUT** | OUT ch1 pkt #1 done: 3 bytes in 13 cycles |
| 14865 | ch1 monitor | ch1 RX pkt #1: addr=1 len=1 parity=bad |
| 14865 | scoreboard | ch1 pkt matched: addr=1 len=1 (2 matched so far) |
| 14905 | **DUT** | IN  pkt #36 complete: addr=3 len=23 parity=ok dropped, 25 bytes in 25 cycles (held 0) |
| 14905 | yapp monitor | RX pkt #36 on the input: addr=3 len=23 parity=good gap=0 |
| 14905 | reference | Packet dropped: illegal address 3 (len=23) |
| 14905 | **DUT** | ROUTER DROPS PACKET addr=3 length=23 (    illegal address) |
| 14910 | yapp driver | TX pkt #36 accepted by the DUT |
| 14910 | yapp driver | TX pkt #37: addr=2 len=9 parity=good delay=0 |
| 14915 | **DUT** | IN  pkt #37 header: addr=2 len=9 -> DROP (oversized: len 9 > maxpktsize 4) |
| 15015 | **DUT** | IN  pkt #37 complete: addr=2 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 15015 | yapp monitor | RX pkt #37 on the input: addr=2 len=9 parity=good gap=0 |
| 15015 | reference | Packet dropped: length 9 > maxpktsize 4 (addr=2) |
| 15015 | **DUT** | ROUTER DROPS PACKET addr=2 length=9 (length > maxpktsize) |
| 15020 | yapp driver | TX pkt #37 accepted by the DUT |
| 15020 | **test** | STAGE: burst 2/4 sent: addr0..3 5/4/8/1, bad parity 2, gap 0 6, length 1..63 |
| 15040 | hbus driver | Executed WRITE addr=0x1000 data=0x60 |
| 15045 | **DUT** | CONFIG router_en=1 maxpktsize=32 |
| 15045 | hbus monitor | Collected WRITE addr=0x1000 data=0x60 |
| 15045 | reference | maxpktsize is now 32 |
| 15060 | hbus driver | Executed WRITE addr=0x1001 data=0x7f |
| 15065 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 15065 | reference | router_en is now 1 (en_reg 0x7f) |
| 15080 | hbus driver | Executed WRITE addr=0x1123 data=0xab |
| 15085 | hbus monitor | Collected WRITE addr=0x1123 data=0xab |
| 15110 | hbus driver | Executed READ  addr=0x1123 data=0xab |
| 15115 | hbus monitor | Collected READ  addr=0x1123 data=0xab |
| 15140 | hbus driver | Executed READ  addr=0x100d data=0x09 |
| 15145 | hbus monitor | Collected READ  addr=0x100d data=0x09 |
| 15170 | hbus driver | Executed READ  addr=0x1006 data=0x03 |
| 15175 | hbus monitor | Collected READ  addr=0x1006 data=0x03 |
| 15200 | hbus driver | Executed READ  addr=0x104a data=0xa0 |
| 15205 | hbus monitor | Collected READ  addr=0x104a data=0xa0 |
| 15230 | ch1 driver | ch1: packet consumed (response delay 9) |
| 15230 | hbus driver | Executed READ  addr=0x1052 data=0x00 |
| 15235 | hbus monitor | Collected READ  addr=0x1052 data=0x00 |
| 15250 | hbus driver | Executed WRITE addr=0x115f data=0xbb |
| 15255 | hbus monitor | Collected WRITE addr=0x115f data=0xbb |
| 15280 | hbus driver | Executed READ  addr=0x115f data=0xbb |
| 15285 | hbus monitor | Collected READ  addr=0x115f data=0xbb |
| 15300 | hbus driver | Executed WRITE addr=0x1189 data=0xa5 |
| 15305 | hbus monitor | Collected WRITE addr=0x1189 data=0xa5 |
| 15330 | hbus driver | Executed READ  addr=0x1189 data=0xa5 |
| 15335 | hbus monitor | Collected READ  addr=0x1189 data=0xa5 |
| 15350 | hbus driver | Executed WRITE addr=0x1100 data=0x42 |
| 15355 | hbus monitor | Collected WRITE addr=0x1100 data=0x42 |
| 15380 | hbus driver | Executed READ  addr=0x1100 data=0x42 |
| 15380 | **test** | STAGE: burst 3/4: ctrl=0x60 (maxpktsize 32) en=0x7f (router on, counter enables 0111111), 18 packet(s) |
| 15380 | yapp driver | TX pkt #38: addr=0 len=32 parity=good delay=1 |
| 15385 | hbus monitor | Collected READ  addr=0x1100 data=0x42 |
| 15405 | **DUT** | IN  pkt #38 header: addr=0 len=32 -> channel 0 |
| 15415 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=32 (receiver waited 0 cycle(s)) |
| 15735 | **DUT** | IN  pkt #38 complete: addr=0 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 15735 | yapp monitor | RX pkt #38 on the input: addr=0 len=32 parity=good gap=38 |
| 15735 | reference | Packet forwarded: addr=0 len=32 -> channel 0 |
| 15740 | ch0 driver | ch0: packet consumed (response delay 0) |
| 15740 | yapp driver | TX pkt #38 accepted by the DUT |
| 15740 | yapp driver | TX pkt #39: addr=1 len=11 parity=good delay=0 |
| 15745 | **DUT** | IN  pkt #39 header: addr=1 len=11 -> channel 1 |
| 15755 | **DUT** | OUT ch0 pkt #1 done: 34 bytes in 35 cycles |
| 15755 | ch0 monitor | ch0 RX pkt #1: addr=0 len=32 parity=good |
| 15755 | scoreboard | ch0 pkt matched: addr=0 len=32 (3 matched so far) |
| 15815 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=11 (receiver waited 6 cycle(s)) |
| 15865 | **DUT** | IN  pkt #39 complete: addr=1 len=11 parity=ok forwarded, 13 bytes in 13 cycles (held 0) |
| 15865 | yapp monitor | RX pkt #39 on the input: addr=1 len=11 parity=good gap=0 |
| 15865 | reference | Packet forwarded: addr=1 len=11 -> channel 1 |
| 15870 | yapp driver | TX pkt #39 accepted by the DUT |
| 15870 | yapp driver | TX pkt #40: addr=1 len=63 parity=good delay=0 |
| 15875 | **DUT** | IN  pkt #40 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 32) |
| 15930 | ch1 driver | ch1: packet consumed (response delay 6) |
| 15955 | **DUT** | OUT ch1 pkt #2 done: 13 bytes in 15 cycles |
| 15955 | ch1 monitor | ch1 RX pkt #2: addr=1 len=11 parity=good |
| 15955 | scoreboard | ch1 pkt matched: addr=1 len=11 (4 matched so far) |
| 16030 | ch0 driver | ch0: packet consumed (response delay 0) |
| 16060 | ch1 driver | ch1: packet consumed (response delay 1) |
| 16515 | **DUT** | IN  pkt #40 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 16515 | yapp monitor | RX pkt #40 on the input: addr=1 len=63 parity=good gap=0 |
| 16515 | reference | Packet dropped: length 63 > maxpktsize 32 (addr=1) |
| 16515 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 16520 | yapp driver | TX pkt #40 accepted by the DUT |
| 16520 | yapp driver | TX pkt #41: addr=2 len=44 parity=good delay=13 |
| 16655 | **DUT** | IN  pkt #41 header: addr=2 len=44 -> DROP (oversized: len 44 > maxpktsize 32) |
| 17105 | **DUT** | IN  pkt #41 complete: addr=2 len=44 parity=ok dropped, 46 bytes in 46 cycles (held 0) |
| 17105 | yapp monitor | RX pkt #41 on the input: addr=2 len=44 parity=good gap=13 |
| 17105 | reference | Packet dropped: length 44 > maxpktsize 32 (addr=2) |
| 17105 | **DUT** | ROUTER DROPS PACKET addr=2 length=44 (length > maxpktsize) |
| 17110 | yapp driver | TX pkt #41 accepted by the DUT |
| 17110 | yapp driver | TX pkt #42: addr=2 len=63 parity=good delay=1 |
| 17125 | **DUT** | IN  pkt #42 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 32) |
| 17765 | **DUT** | IN  pkt #42 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 17765 | yapp monitor | RX pkt #42 on the input: addr=2 len=63 parity=good gap=1 |
| 17765 | reference | Packet dropped: length 63 > maxpktsize 32 (addr=2) |
| 17765 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 17770 | yapp driver | TX pkt #42 accepted by the DUT |
| 17770 | yapp driver | TX pkt #43: addr=2 len=50 parity=good delay=3 |
| 17805 | **DUT** | IN  pkt #43 header: addr=2 len=50 -> DROP (oversized: len 50 > maxpktsize 32) |
| 18315 | **DUT** | IN  pkt #43 complete: addr=2 len=50 parity=ok dropped, 52 bytes in 52 cycles (held 0) |
| 18315 | yapp monitor | RX pkt #43 on the input: addr=2 len=50 parity=good gap=3 |
| 18315 | reference | Packet dropped: length 50 > maxpktsize 32 (addr=2) |
| 18315 | **DUT** | ROUTER DROPS PACKET addr=2 length=50 (length > maxpktsize) |
| 18320 | yapp driver | TX pkt #43 accepted by the DUT |
| 18320 | yapp driver | TX pkt #44: addr=1 len=32 parity=good delay=20 |
| 18525 | **DUT** | IN  pkt #44 header: addr=1 len=32 -> channel 1 |
| 18545 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=32 (receiver waited 1 cycle(s)) |
| 18855 | **DUT** | IN  pkt #44 complete: addr=1 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 18855 | yapp monitor | RX pkt #44 on the input: addr=1 len=32 parity=good gap=20 |
| 18855 | reference | Packet forwarded: addr=1 len=32 -> channel 1 |
| 18860 | yapp driver | TX pkt #44 accepted by the DUT |
| 18860 | yapp driver | TX pkt #45: addr=2 len=15 parity=good delay=20 |
| 18870 | ch1 driver | ch1: packet consumed (response delay 1) |
| 18955 | **DUT** | OUT ch1 pkt #3 done: 34 bytes in 42 cycles |
| 18955 | ch1 monitor | ch1 RX pkt #3: addr=1 len=32 parity=good |
| 18955 | scoreboard | ch1 pkt matched: addr=1 len=32 (5 matched so far) |
| 19065 | **DUT** | IN  pkt #45 header: addr=2 len=15 -> channel 2 |
| 19075 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=15 (receiver waited 0 cycle(s)) |
| 19225 | **DUT** | IN  pkt #45 complete: addr=2 len=15 parity=ok forwarded, 17 bytes in 17 cycles (held 0) |
| 19225 | yapp monitor | RX pkt #45 on the input: addr=2 len=15 parity=good gap=20 |
| 19225 | reference | Packet forwarded: addr=2 len=15 -> channel 2 |
| 19230 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19230 | yapp driver | TX pkt #45 accepted by the DUT |
| 19230 | yapp driver | TX pkt #46: addr=2 len=42 parity=good delay=0 |
| 19235 | **DUT** | IN  pkt #46 header: addr=2 len=42 -> DROP (oversized: len 42 > maxpktsize 32) |
| 19245 | **DUT** | OUT ch2 pkt #2 done: 17 bytes in 18 cycles |
| 19245 | ch2 monitor | ch2 RX pkt #2: addr=2 len=15 parity=good |
| 19245 | scoreboard | ch2 pkt matched: addr=2 len=15 (6 matched so far) |
| 19490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19550 | ch1 driver | ch1: packet consumed (response delay 7) |
| 19665 | **DUT** | IN  pkt #46 complete: addr=2 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 19665 | yapp monitor | RX pkt #46 on the input: addr=2 len=42 parity=good gap=0 |
| 19665 | reference | Packet dropped: length 42 > maxpktsize 32 (addr=2) |
| 19665 | **DUT** | ROUTER DROPS PACKET addr=2 length=42 (length > maxpktsize) |
| 19670 | yapp driver | TX pkt #46 accepted by the DUT |
| 19670 | yapp driver | TX pkt #47: addr=0 len=32 parity=good delay=0 |
| 19675 | **DUT** | IN  pkt #47 header: addr=0 len=32 -> channel 0 |
| 19685 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=32 (receiver waited 0 cycle(s)) |
| 20005 | **DUT** | IN  pkt #47 complete: addr=0 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 20005 | yapp monitor | RX pkt #47 on the input: addr=0 len=32 parity=good gap=0 |
| 20005 | reference | Packet forwarded: addr=0 len=32 -> channel 0 |
| 20010 | ch0 driver | ch0: packet consumed (response delay 0) |
| 20010 | yapp driver | TX pkt #47 accepted by the DUT |
| 20010 | yapp driver | TX pkt #48: addr=2 len=32 parity=bad delay=0 |
| 20015 | **DUT** | IN  pkt #48 header: addr=2 len=32 -> channel 2 |
| 20025 | **DUT** | OUT ch0 pkt #2 done: 34 bytes in 35 cycles |
| 20025 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=32 (receiver waited 0 cycle(s)) |
| 20025 | ch0 monitor | ch0 RX pkt #2: addr=0 len=32 parity=good |
| 20025 | scoreboard | ch0 pkt matched: addr=0 len=32 (7 matched so far) |
| 20345 | **DUT** | IN  pkt #48 complete: addr=2 len=32 parity=BAD forwarded, 34 bytes in 34 cycles (held 0) |
| 20345 | yapp monitor | RX pkt #48 on the input: addr=2 len=32 parity=bad gap=0 |
| 20345 | reference | Packet forwarded: addr=2 len=32 -> channel 2 |
| 20350 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20350 | yapp driver | TX pkt #48 accepted by the DUT |
| 20350 | yapp driver | TX pkt #49: addr=0 len=9 parity=good delay=0 |
| 20355 | **DUT** | IN  pkt #49 header: addr=0 len=9 -> channel 0 |
| 20365 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=9 (receiver waited 0 cycle(s)) |
| 20365 | **DUT** | OUT ch2 pkt #3 done: 34 bytes in 35 cycles |
| 20365 | ch2 monitor | ch2 RX pkt #3: addr=2 len=32 parity=bad |
| 20365 | scoreboard | ch2 pkt matched: addr=2 len=32 (8 matched so far) |
| 20390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 20390 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 20455 | **DUT** | IN  pkt #49 complete: addr=0 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 20455 | yapp monitor | RX pkt #49 on the input: addr=0 len=9 parity=good gap=0 |
| 20455 | reference | Packet forwarded: addr=0 len=9 -> channel 0 |
| 20460 | yapp driver | TX pkt #49 accepted by the DUT |
| 20460 | yapp driver | TX pkt #50: addr=2 len=32 parity=good delay=0 |
| 20465 | **DUT** | IN  pkt #50 header: addr=2 len=32 -> channel 2 |
| 20465 | **DUT** | OUT ch0 pkt #3 done: 11 bytes in 11 cycles |
| 20465 | ch0 monitor | ch0 RX pkt #3: addr=0 len=9 parity=good |
| 20465 | scoreboard | ch0 pkt matched: addr=0 len=9 (9 matched so far) |
| 20475 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=32 (receiver waited 0 cycle(s)) |
| 20630 | ch0 driver | ch0: packet consumed (response delay 0) |
| 20660 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20760 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20795 | **DUT** | IN  pkt #50 complete: addr=2 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 20795 | yapp monitor | RX pkt #50 on the input: addr=2 len=32 parity=good gap=0 |
| 20795 | reference | Packet forwarded: addr=2 len=32 -> channel 2 |
| 20800 | yapp driver | TX pkt #50 accepted by the DUT |
| 20800 | yapp driver | TX pkt #51: addr=2 len=36 parity=good delay=1 |
| 20815 | **DUT** | IN  pkt #51 header: addr=2 len=36 -> DROP (oversized: len 36 > maxpktsize 32) |
| 20825 | **DUT** | OUT ch2 pkt #4 done: 34 bytes in 36 cycles |
| 20825 | ch2 monitor | ch2 RX pkt #4: addr=2 len=32 parity=good |
| 20825 | scoreboard | ch2 pkt matched: addr=2 len=32 (10 matched so far) |
| 21110 | ch2 driver | ch2: packet consumed (response delay 0) |
| 21185 | **DUT** | IN  pkt #51 complete: addr=2 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 21185 | yapp monitor | RX pkt #51 on the input: addr=2 len=36 parity=good gap=1 |
| 21185 | reference | Packet dropped: length 36 > maxpktsize 32 (addr=2) |
| 21185 | **DUT** | ROUTER DROPS PACKET addr=2 length=36 (length > maxpktsize) |
| 21190 | yapp driver | TX pkt #51 accepted by the DUT |
| 21190 | yapp driver | TX pkt #52: addr=2 len=16 parity=good delay=1 |
| 21205 | **DUT** | IN  pkt #52 header: addr=2 len=16 -> channel 2 |
| 21215 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=16 (receiver waited 0 cycle(s)) |
| 21375 | **DUT** | IN  pkt #52 complete: addr=2 len=16 parity=ok forwarded, 18 bytes in 18 cycles (held 0) |
| 21375 | yapp monitor | RX pkt #52 on the input: addr=2 len=16 parity=good gap=1 |
| 21375 | reference | Packet forwarded: addr=2 len=16 -> channel 2 |
| 21380 | ch2 driver | ch2: packet consumed (response delay 0) |
| 21380 | yapp driver | TX pkt #52 accepted by the DUT |
| 21380 | yapp driver | TX pkt #53: addr=2 len=36 parity=good delay=0 |
| 21385 | **DUT** | IN  pkt #53 header: addr=2 len=36 -> DROP (oversized: len 36 > maxpktsize 32) |
| 21395 | **DUT** | OUT ch2 pkt #5 done: 18 bytes in 19 cycles |
| 21395 | ch2 monitor | ch2 RX pkt #5: addr=2 len=16 parity=good |
| 21395 | scoreboard | ch2 pkt matched: addr=2 len=16 (11 matched so far) |
| 21755 | **DUT** | IN  pkt #53 complete: addr=2 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 21755 | yapp monitor | RX pkt #53 on the input: addr=2 len=36 parity=good gap=0 |
| 21755 | reference | Packet dropped: length 36 > maxpktsize 32 (addr=2) |
| 21755 | **DUT** | ROUTER DROPS PACKET addr=2 length=36 (length > maxpktsize) |
| 21760 | yapp driver | TX pkt #53 accepted by the DUT |
| 21760 | yapp driver | TX pkt #54: addr=2 len=42 parity=good delay=13 |
| 21895 | **DUT** | IN  pkt #54 header: addr=2 len=42 -> DROP (oversized: len 42 > maxpktsize 32) |
| 22030 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22325 | **DUT** | IN  pkt #54 complete: addr=2 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 22325 | yapp monitor | RX pkt #54 on the input: addr=2 len=42 parity=good gap=13 |
| 22325 | reference | Packet dropped: length 42 > maxpktsize 32 (addr=2) |
| 22325 | **DUT** | ROUTER DROPS PACKET addr=2 length=42 (length > maxpktsize) |
| 22330 | yapp driver | TX pkt #54 accepted by the DUT |
| 22330 | yapp driver | TX pkt #55: addr=0 len=63 parity=good delay=1 |
| 22345 | **DUT** | IN  pkt #55 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 32) |
| 22985 | **DUT** | IN  pkt #55 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 22985 | yapp monitor | RX pkt #55 on the input: addr=0 len=63 parity=good gap=1 |
| 22985 | reference | Packet dropped: length 63 > maxpktsize 32 (addr=0) |
| 22985 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 22990 | yapp driver | TX pkt #55 accepted by the DUT |
| 22990 | **test** | STAGE: burst 3/4 sent: addr0..3 4/3/11/0, bad parity 1, gap 0 8, length 9..63 |
| 23010 | hbus driver | Executed WRITE addr=0x1000 data=0xb8 |
| 23015 | **DUT** | CONFIG router_en=1 maxpktsize=56 |
| 23015 | hbus monitor | Collected WRITE addr=0x1000 data=0xb8 |
| 23015 | reference | maxpktsize is now 56 |
| 23030 | hbus driver | Executed WRITE addr=0x1001 data=0xe3 |
| 23035 | hbus monitor | Collected WRITE addr=0x1001 data=0xe3 |
| 23035 | reference | router_en is now 1 (en_reg 0xe3) |
| 23060 | hbus driver | Executed READ  addr=0x1025 data=0x74 |
| 23065 | hbus monitor | Collected READ  addr=0x1025 data=0x74 |
| 23080 | hbus driver | Executed WRITE addr=0x110c data=0x9c |
| 23085 | hbus monitor | Collected WRITE addr=0x110c data=0x9c |
| 23110 | hbus driver | Executed READ  addr=0x110c data=0x9c |
| 23115 | hbus monitor | Collected READ  addr=0x110c data=0x9c |
| 23140 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 23140 | **test** | STAGE: burst 4/4: ctrl=0xb8 (maxpktsize 56) en=0xe3 (router on, counter enables 1110001), 18 packet(s) |
| 23140 | yapp driver | TX pkt #56: addr=1 len=57 parity=good delay=2 |
| 23145 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 23175 | **DUT** | IN  pkt #56 header: addr=1 len=57 -> DROP (oversized: len 57 > maxpktsize 56) |
| 23755 | **DUT** | IN  pkt #56 complete: addr=1 len=57 parity=ok dropped, 59 bytes in 59 cycles (held 0) |
| 23755 | yapp monitor | RX pkt #56 on the input: addr=1 len=57 parity=good gap=18 |
| 23755 | reference | Packet dropped: length 57 > maxpktsize 56 (addr=1) |
| 23755 | **DUT** | ROUTER DROPS PACKET addr=1 length=57 (length > maxpktsize) |
| 23760 | yapp driver | TX pkt #56 accepted by the DUT |
| 23760 | yapp driver | TX pkt #57: addr=2 len=51 parity=good delay=2 |
| 23785 | **DUT** | IN  pkt #57 header: addr=2 len=51 -> channel 2 |
| 23795 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=51 (receiver waited 0 cycle(s)) |
| 24305 | **DUT** | IN  pkt #57 complete: addr=2 len=51 parity=ok forwarded, 53 bytes in 53 cycles (held 0) |
| 24305 | yapp monitor | RX pkt #57 on the input: addr=2 len=51 parity=good gap=2 |
| 24305 | reference | Packet forwarded: addr=2 len=51 -> channel 2 |
| 24310 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24310 | yapp driver | TX pkt #57 accepted by the DUT |
| 24310 | yapp driver | TX pkt #58: addr=2 len=56 parity=good delay=1 |
| 24325 | **DUT** | IN  pkt #58 header: addr=2 len=56 -> channel 2 |
| 24325 | **DUT** | OUT ch2 pkt #6 done: 53 bytes in 54 cycles |
| 24325 | ch2 monitor | ch2 RX pkt #6: addr=2 len=51 parity=good |
| 24325 | scoreboard | ch2 pkt matched: addr=2 len=51 (12 matched so far) |
| 24335 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=56 (receiver waited 0 cycle(s)) |
| 24490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24670 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24895 | **DUT** | IN  pkt #58 complete: addr=2 len=56 parity=ok forwarded, 58 bytes in 58 cycles (held 0) |
| 24895 | yapp monitor | RX pkt #58 on the input: addr=2 len=56 parity=good gap=1 |
| 24895 | reference | Packet forwarded: addr=2 len=56 -> channel 2 |
| 24900 | yapp driver | TX pkt #58 accepted by the DUT |
| 24900 | yapp driver | TX pkt #59: addr=1 len=14 parity=bad delay=0 |
| 24905 | **DUT** | IN  pkt #59 header: addr=1 len=14 -> channel 1 |
| 24925 | **DUT** | OUT ch2 pkt #7 done: 58 bytes in 60 cycles |
| 24925 | ch2 monitor | ch2 RX pkt #7: addr=2 len=56 parity=good |
| 24925 | scoreboard | ch2 pkt matched: addr=2 len=56 (13 matched so far) |
| 24975 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=14 (receiver waited 6 cycle(s)) |
| 25055 | **DUT** | IN  pkt #59 complete: addr=1 len=14 parity=BAD forwarded, 16 bytes in 16 cycles (held 0) |
| 25055 | yapp monitor | RX pkt #59 on the input: addr=1 len=14 parity=bad gap=0 |
| 25055 | reference | Packet forwarded: addr=1 len=14 -> channel 1 |
| 25060 | yapp driver | TX pkt #59 accepted by the DUT |
| 25060 | yapp driver | TX pkt #60: addr=0 len=63 parity=good delay=0 |
| 25065 | **DUT** | IN  pkt #60 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 56) |
| 25110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 25110 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 25120 | ch1 driver | ch1: packet consumed (response delay 6) |
| 25195 | **DUT** | OUT ch1 pkt #4 done: 16 bytes in 23 cycles |
| 25195 | ch1 monitor | ch1 RX pkt #4: addr=1 len=14 parity=bad |
| 25195 | scoreboard | ch1 pkt matched: addr=1 len=14 (14 matched so far) |
| 25220 | ch2 driver | ch2: packet consumed (response delay 0) |
| 25705 | **DUT** | IN  pkt #60 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 25705 | yapp monitor | RX pkt #60 on the input: addr=0 len=63 parity=good gap=0 |
| 25705 | reference | Packet dropped: length 63 > maxpktsize 56 (addr=0) |
| 25705 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 25710 | yapp driver | TX pkt #60 accepted by the DUT |
| 25710 | yapp driver | TX pkt #61: addr=2 len=63 parity=bad delay=1 |
| 25725 | **DUT** | IN  pkt #61 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 56) |
| 25820 | ch1 driver | ch1: packet consumed (response delay 6) |
| 26365 | **DUT** | IN  pkt #61 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 26365 | yapp monitor | RX pkt #61 on the input: addr=2 len=63 parity=bad gap=1 |
| 26365 | reference | Packet dropped: length 63 > maxpktsize 56 (addr=2) |
| 26365 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 26370 | yapp driver | TX pkt #61 accepted by the DUT |
| 26370 | yapp driver | TX pkt #62: addr=0 len=14 parity=good delay=1 |
| 26385 | **DUT** | IN  pkt #62 header: addr=0 len=14 -> channel 0 |
| 26395 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=14 (receiver waited 0 cycle(s)) |
| 26450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 26450 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 26535 | **DUT** | IN  pkt #62 complete: addr=0 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 26535 | yapp monitor | RX pkt #62 on the input: addr=0 len=14 parity=good gap=1 |
| 26535 | reference | Packet forwarded: addr=0 len=14 -> channel 0 |
| 26540 | ch0 driver | ch0: packet consumed (response delay 0) |
| 26540 | yapp driver | TX pkt #62 accepted by the DUT |
| 26540 | yapp driver | TX pkt #63: addr=1 len=36 parity=good delay=20 |
| 26555 | **DUT** | OUT ch0 pkt #4 done: 16 bytes in 17 cycles |
| 26555 | ch0 monitor | ch0 RX pkt #4: addr=0 len=14 parity=good |
| 26555 | scoreboard | ch0 pkt matched: addr=0 len=14 (15 matched so far) |
| 26745 | **DUT** | IN  pkt #63 header: addr=1 len=36 -> channel 1 |
| 26835 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=36 (receiver waited 8 cycle(s)) |
| 27115 | **DUT** | IN  pkt #63 complete: addr=1 len=36 parity=ok forwarded, 38 bytes in 38 cycles (held 0) |
| 27115 | yapp monitor | RX pkt #63 on the input: addr=1 len=36 parity=good gap=20 |
| 27115 | reference | Packet forwarded: addr=1 len=36 -> channel 1 |
| 27120 | yapp driver | TX pkt #63 accepted by the DUT |
| 27120 | yapp driver | TX pkt #64: addr=1 len=63 parity=bad delay=1 |
| 27135 | **DUT** | IN  pkt #64 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 56) |
| 27140 | ch0 driver | ch0: packet consumed (response delay 0) |
| 27200 | ch1 driver | ch1: packet consumed (response delay 8) |
| 27315 | **DUT** | OUT ch1 pkt #5 done: 38 bytes in 49 cycles |
| 27315 | ch1 monitor | ch1 RX pkt #5: addr=1 len=36 parity=good |
| 27315 | scoreboard | ch1 pkt matched: addr=1 len=36 (16 matched so far) |
| 27420 | ch1 driver | ch1: packet consumed (response delay 10) |
| 27775 | **DUT** | IN  pkt #64 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 27775 | yapp monitor | RX pkt #64 on the input: addr=1 len=63 parity=bad gap=1 |
| 27775 | reference | Packet dropped: length 63 > maxpktsize 56 (addr=1) |
| 27775 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 27780 | yapp driver | TX pkt #64 accepted by the DUT |
| 27780 | yapp driver | TX pkt #65: addr=1 len=58 parity=good delay=0 |
| 27785 | **DUT** | IN  pkt #65 header: addr=1 len=58 -> DROP (oversized: len 58 > maxpktsize 56) |
| 27830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 27830 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 28375 | **DUT** | IN  pkt #65 complete: addr=1 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 28375 | yapp monitor | RX pkt #65 on the input: addr=1 len=58 parity=good gap=0 |
| 28375 | reference | Packet dropped: length 58 > maxpktsize 56 (addr=1) |
| 28375 | **DUT** | ROUTER DROPS PACKET addr=1 length=58 (length > maxpktsize) |
| 28380 | yapp driver | TX pkt #65 accepted by the DUT |
| 28380 | yapp driver | TX pkt #66: addr=2 len=21 parity=good delay=0 |
| 28385 | **DUT** | IN  pkt #66 header: addr=2 len=21 -> channel 2 |
| 28395 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=21 (receiver waited 0 cycle(s)) |
| 28605 | **DUT** | IN  pkt #66 complete: addr=2 len=21 parity=ok forwarded, 23 bytes in 23 cycles (held 0) |
| 28605 | yapp monitor | RX pkt #66 on the input: addr=2 len=21 parity=good gap=0 |
| 28605 | reference | Packet forwarded: addr=2 len=21 -> channel 2 |
| 28610 | ch2 driver | ch2: packet consumed (response delay 0) |
| 28610 | yapp driver | TX pkt #66 accepted by the DUT |
| 28610 | yapp driver | TX pkt #67: addr=2 len=8 parity=good delay=0 |
| 28615 | **DUT** | IN  pkt #67 header: addr=2 len=8 -> channel 2 |
| 28625 | **DUT** | OUT ch2 pkt #8 done: 23 bytes in 24 cycles |
| 28625 | ch2 monitor | ch2 RX pkt #8: addr=2 len=21 parity=good |
| 28625 | scoreboard | ch2 pkt matched: addr=2 len=21 (17 matched so far) |
| 28635 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=8 (receiver waited 0 cycle(s)) |
| 28670 | ch2 driver | ch2: packet consumed (response delay 0) |
| 28705 | **DUT** | IN  pkt #67 complete: addr=2 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 28705 | yapp monitor | RX pkt #67 on the input: addr=2 len=8 parity=good gap=0 |
| 28705 | reference | Packet forwarded: addr=2 len=8 -> channel 2 |
| 28710 | yapp driver | TX pkt #67 accepted by the DUT |
| 28710 | yapp driver | TX pkt #68: addr=2 len=13 parity=good delay=6 |
| 28735 | **DUT** | OUT ch2 pkt #9 done: 10 bytes in 11 cycles |
| 28735 | ch2 monitor | ch2 RX pkt #9: addr=2 len=8 parity=good |
| 28735 | scoreboard | ch2 pkt matched: addr=2 len=8 (18 matched so far) |
| 28775 | **DUT** | IN  pkt #68 header: addr=2 len=13 -> channel 2 |
| 28785 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=13 (receiver waited 0 cycle(s)) |
| 28915 | **DUT** | IN  pkt #68 complete: addr=2 len=13 parity=ok forwarded, 15 bytes in 15 cycles (held 0) |
| 28915 | yapp monitor | RX pkt #68 on the input: addr=2 len=13 parity=good gap=6 |
| 28915 | reference | Packet forwarded: addr=2 len=13 -> channel 2 |
| 28920 | yapp driver | TX pkt #68 accepted by the DUT |
| 28920 | yapp driver | TX pkt #69: addr=2 len=58 parity=good delay=1 |
| 28925 | **DUT** | OUT ch2 pkt #10 done: 15 bytes in 15 cycles |
| 28925 | ch2 monitor | ch2 RX pkt #10: addr=2 len=13 parity=good |
| 28925 | scoreboard | ch2 pkt matched: addr=2 len=13 (19 matched so far) |
| 28935 | **DUT** | IN  pkt #69 header: addr=2 len=58 -> DROP (oversized: len 58 > maxpktsize 56) |
| 29250 | ch2 driver | ch2: packet consumed (response delay 0) |
| 29525 | **DUT** | IN  pkt #69 complete: addr=2 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 29525 | yapp monitor | RX pkt #69 on the input: addr=2 len=58 parity=good gap=1 |
| 29525 | reference | Packet dropped: length 58 > maxpktsize 56 (addr=2) |
| 29525 | **DUT** | ROUTER DROPS PACKET addr=2 length=58 (length > maxpktsize) |
| 29530 | yapp driver | TX pkt #69 accepted by the DUT |
| 29530 | yapp driver | TX pkt #70: addr=0 len=55 parity=good delay=2 |
| 29555 | **DUT** | IN  pkt #70 header: addr=0 len=55 -> channel 0 |
| 29565 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=55 (receiver waited 0 cycle(s)) |
| 30115 | **DUT** | IN  pkt #70 complete: addr=0 len=55 parity=ok forwarded, 57 bytes in 57 cycles (held 0) |
| 30115 | yapp monitor | RX pkt #70 on the input: addr=0 len=55 parity=good gap=2 |
| 30115 | reference | Packet forwarded: addr=0 len=55 -> channel 0 |
| 30120 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30120 | yapp driver | TX pkt #70 accepted by the DUT |
| 30120 | yapp driver | TX pkt #71: addr=2 len=25 parity=good delay=0 |
| 30125 | **DUT** | IN  pkt #71 header: addr=2 len=25 -> channel 2 |
| 30135 | **DUT** | OUT ch0 pkt #5 done: 57 bytes in 58 cycles |
| 30135 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=25 (receiver waited 0 cycle(s)) |
| 30135 | ch0 monitor | ch0 RX pkt #5: addr=0 len=55 parity=good |
| 30135 | scoreboard | ch0 pkt matched: addr=0 len=55 (20 matched so far) |
| 30385 | **DUT** | IN  pkt #71 complete: addr=2 len=25 parity=ok forwarded, 27 bytes in 27 cycles (held 0) |
| 30385 | yapp monitor | RX pkt #71 on the input: addr=2 len=25 parity=good gap=0 |
| 30385 | reference | Packet forwarded: addr=2 len=25 -> channel 2 |
| 30390 | ch2 driver | ch2: packet consumed (response delay 0) |
| 30390 | yapp driver | TX pkt #71 accepted by the DUT |
| 30390 | yapp driver | TX pkt #72: addr=2 len=19 parity=good delay=0 |
| 30395 | **DUT** | IN  pkt #72 header: addr=2 len=19 -> channel 2 |
| 30405 | **DUT** | OUT ch2 pkt #11 done: 27 bytes in 28 cycles |
| 30405 | ch2 monitor | ch2 RX pkt #11: addr=2 len=25 parity=good |
| 30405 | scoreboard | ch2 pkt matched: addr=2 len=25 (21 matched so far) |
| 30415 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=19 (receiver waited 0 cycle(s)) |
| 30595 | **DUT** | IN  pkt #72 complete: addr=2 len=19 parity=ok forwarded, 21 bytes in 21 cycles (held 0) |
| 30595 | yapp monitor | RX pkt #72 on the input: addr=2 len=19 parity=good gap=0 |
| 30595 | reference | Packet forwarded: addr=2 len=19 -> channel 2 |
| 30600 | yapp driver | TX pkt #72 accepted by the DUT |
| 30600 | yapp driver | TX pkt #73: addr=0 len=55 parity=good delay=0 |
| 30605 | **DUT** | IN  pkt #73 header: addr=0 len=55 -> channel 0 |
| 30615 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=55 (receiver waited 0 cycle(s)) |
| 30615 | **DUT** | OUT ch2 pkt #12 done: 21 bytes in 21 cycles |
| 30615 | ch2 monitor | ch2 RX pkt #12: addr=2 len=19 parity=good |
| 30615 | scoreboard | ch2 pkt matched: addr=2 len=19 (22 matched so far) |
| 30630 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30730 | ch0 driver | ch0: packet consumed (response delay 0) |
| 30810 | ch2 driver | ch2: packet consumed (response delay 0) |
| 30870 | ch0 driver | ch0: packet consumed (response delay 0) |
| 31165 | **DUT** | IN  pkt #73 complete: addr=0 len=55 parity=ok forwarded, 57 bytes in 57 cycles (held 0) |
| 31165 | yapp monitor | RX pkt #73 on the input: addr=0 len=55 parity=good gap=0 |
| 31165 | reference | Packet forwarded: addr=0 len=55 -> channel 0 |
| 31170 | yapp driver | TX pkt #73 accepted by the DUT |
| 31170 | **test** | STAGE: burst 4/4 sent: addr0..3 4/5/9/0, bad parity 3, gap 0 8, length 8..63 |
| 31170 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 31200 | hbus driver | Executed READ  addr=0x1000 data=0xb8 |
| 31205 | **DUT** | OUT ch0 pkt #6 done: 57 bytes in 60 cycles |
| 31205 | ch0 monitor | ch0 RX pkt #6: addr=0 len=55 parity=good |
| 31205 | scoreboard | ch0 pkt matched: addr=0 len=55 (23 matched so far) |
| 31205 | hbus monitor | Collected READ  addr=0x1000 data=0xb8 |
| 31230 | hbus driver | Executed READ  addr=0x1001 data=0xe3 |
| 31235 | hbus monitor | Collected READ  addr=0x1001 data=0xe3 |
| 31260 | hbus driver | Executed READ  addr=0x1004 data=0x06 |
| 31265 | hbus monitor | Collected READ  addr=0x1004 data=0x06 |
| 31280 | ch0 driver | ch0: packet consumed (response delay 0) |
| 31290 | hbus driver | Executed READ  addr=0x1005 data=0x09 |
| 31295 | hbus monitor | Collected READ  addr=0x1005 data=0x09 |
| 31320 | hbus driver | Executed READ  addr=0x1006 data=0x03 |
| 31325 | hbus monitor | Collected READ  addr=0x1006 data=0x03 |
| 31350 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 31355 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 31380 | hbus driver | Executed READ  addr=0x100a data=0x08 |
| 31385 | hbus monitor | Collected READ  addr=0x100a data=0x08 |
| 31410 | hbus driver | Executed READ  addr=0x100b data=0x27 |
| 31415 | hbus monitor | Collected READ  addr=0x100b data=0x27 |
| 31440 | hbus driver | Executed READ  addr=0x100d data=0x37 |
| 31445 | hbus monitor | Collected READ  addr=0x100d data=0x37 |
| 31470 | hbus driver | Executed READ  addr=0x1010 data=0xdc |
| 31475 | hbus monitor | Collected READ  addr=0x1010 data=0xdc |
| 31500 | hbus driver | Executed READ  addr=0x1011 data=0xb6 |
| 31505 | hbus monitor | Collected READ  addr=0x1011 data=0xb6 |
| 31530 | hbus driver | Executed READ  addr=0x1012 data=0x23 |
| 31535 | hbus monitor | Collected READ  addr=0x1012 data=0x23 |
| 31560 | hbus driver | Executed READ  addr=0x1013 data=0x1f |
| 31565 | hbus monitor | Collected READ  addr=0x1013 data=0x1f |
| 31590 | hbus driver | Executed READ  addr=0x1014 data=0x16 |
| 31595 | hbus monitor | Collected READ  addr=0x1014 data=0x16 |
| 31620 | hbus driver | Executed READ  addr=0x1015 data=0xfc |
| 31625 | hbus monitor | Collected READ  addr=0x1015 data=0xfc |
| 31650 | hbus driver | Executed READ  addr=0x1016 data=0x1f |
| 31655 | hbus monitor | Collected READ  addr=0x1016 data=0x1f |
| 31680 | hbus driver | Executed READ  addr=0x1017 data=0x80 |
| 31685 | hbus monitor | Collected READ  addr=0x1017 data=0x80 |
| 31710 | hbus driver | Executed READ  addr=0x1018 data=0x4b |
| 31715 | hbus monitor | Collected READ  addr=0x1018 data=0x4b |
| 31740 | hbus driver | Executed READ  addr=0x1019 data=0xbc |
| 31745 | hbus monitor | Collected READ  addr=0x1019 data=0xbc |
| 31770 | hbus driver | Executed READ  addr=0x101a data=0xc0 |
| 31775 | hbus monitor | Collected READ  addr=0x101a data=0xc0 |
| 31800 | hbus driver | Executed READ  addr=0x101b data=0x30 |
| 31805 | hbus monitor | Collected READ  addr=0x101b data=0x30 |
| 31830 | hbus driver | Executed READ  addr=0x101c data=0x43 |
| 31835 | hbus monitor | Collected READ  addr=0x101c data=0x43 |
| 31860 | hbus driver | Executed READ  addr=0x101d data=0xb5 |
| 31865 | hbus monitor | Collected READ  addr=0x101d data=0xb5 |
| 31890 | hbus driver | Executed READ  addr=0x101e data=0xaa |
| 31895 | hbus monitor | Collected READ  addr=0x101e data=0xaa |
| 31920 | hbus driver | Executed READ  addr=0x101f data=0x83 |
| 31925 | hbus monitor | Collected READ  addr=0x101f data=0x83 |
| 31950 | hbus driver | Executed READ  addr=0x1020 data=0x21 |
| 31955 | hbus monitor | Collected READ  addr=0x1020 data=0x21 |
| 31980 | hbus driver | Executed READ  addr=0x1021 data=0xf9 |
| 31985 | hbus monitor | Collected READ  addr=0x1021 data=0xf9 |
| 32010 | hbus driver | Executed READ  addr=0x1022 data=0xf8 |
| 32015 | hbus monitor | Collected READ  addr=0x1022 data=0xf8 |
| 32040 | hbus driver | Executed READ  addr=0x1023 data=0x26 |
| 32045 | hbus monitor | Collected READ  addr=0x1023 data=0x26 |
| 32070 | hbus driver | Executed READ  addr=0x1024 data=0xc4 |
| 32075 | hbus monitor | Collected READ  addr=0x1024 data=0xc4 |
| 32100 | hbus driver | Executed READ  addr=0x1025 data=0xa8 |
| 32105 | hbus monitor | Collected READ  addr=0x1025 data=0xa8 |
| 32130 | hbus driver | Executed READ  addr=0x1026 data=0xbc |
| 32135 | hbus monitor | Collected READ  addr=0x1026 data=0xbc |
| 32160 | hbus driver | Executed READ  addr=0x1027 data=0x13 |
| 32165 | hbus monitor | Collected READ  addr=0x1027 data=0x13 |
| 32190 | hbus driver | Executed READ  addr=0x1028 data=0x9c |
| 32195 | hbus monitor | Collected READ  addr=0x1028 data=0x9c |
| 32220 | hbus driver | Executed READ  addr=0x1029 data=0x19 |
| 32225 | hbus monitor | Collected READ  addr=0x1029 data=0x19 |
| 32250 | hbus driver | Executed READ  addr=0x102a data=0xf1 |
| 32255 | hbus monitor | Collected READ  addr=0x102a data=0xf1 |
| 32280 | hbus driver | Executed READ  addr=0x102b data=0x0d |
| 32285 | hbus monitor | Collected READ  addr=0x102b data=0x0d |
| 32310 | hbus driver | Executed READ  addr=0x102c data=0x9d |
| 32315 | hbus monitor | Collected READ  addr=0x102c data=0x9d |
| 32340 | hbus driver | Executed READ  addr=0x102d data=0x9e |
| 32345 | hbus monitor | Collected READ  addr=0x102d data=0x9e |
| 32370 | hbus driver | Executed READ  addr=0x102e data=0x66 |
| 32375 | hbus monitor | Collected READ  addr=0x102e data=0x66 |
| 32400 | hbus driver | Executed READ  addr=0x102f data=0x43 |
| 32405 | hbus monitor | Collected READ  addr=0x102f data=0x43 |
| 32430 | hbus driver | Executed READ  addr=0x1030 data=0x35 |
| 32435 | hbus monitor | Collected READ  addr=0x1030 data=0x35 |
| 32460 | hbus driver | Executed READ  addr=0x1031 data=0x25 |
| 32465 | hbus monitor | Collected READ  addr=0x1031 data=0x25 |
| 32490 | hbus driver | Executed READ  addr=0x1032 data=0xbc |
| 32495 | hbus monitor | Collected READ  addr=0x1032 data=0xbc |
| 32520 | hbus driver | Executed READ  addr=0x1033 data=0xa6 |
| 32525 | hbus monitor | Collected READ  addr=0x1033 data=0xa6 |
| 32550 | hbus driver | Executed READ  addr=0x1034 data=0x24 |
| 32555 | hbus monitor | Collected READ  addr=0x1034 data=0x24 |
| 32580 | hbus driver | Executed READ  addr=0x1035 data=0x17 |
| 32585 | hbus monitor | Collected READ  addr=0x1035 data=0x17 |
| 32610 | hbus driver | Executed READ  addr=0x1036 data=0x0b |
| 32615 | hbus monitor | Collected READ  addr=0x1036 data=0x0b |
| 32640 | hbus driver | Executed READ  addr=0x1037 data=0x0a |
| 32645 | hbus monitor | Collected READ  addr=0x1037 data=0x0a |
| 32670 | hbus driver | Executed READ  addr=0x1038 data=0x9c |
| 32675 | hbus monitor | Collected READ  addr=0x1038 data=0x9c |
| 32700 | hbus driver | Executed READ  addr=0x1039 data=0x36 |
| 32705 | hbus monitor | Collected READ  addr=0x1039 data=0x36 |
| 32730 | hbus driver | Executed READ  addr=0x103a data=0x8a |
| 32735 | hbus monitor | Collected READ  addr=0x103a data=0x8a |
| 32760 | hbus driver | Executed READ  addr=0x103b data=0x28 |
| 32765 | hbus monitor | Collected READ  addr=0x103b data=0x28 |
| 32790 | hbus driver | Executed READ  addr=0x103c data=0xae |
| 32795 | hbus monitor | Collected READ  addr=0x103c data=0xae |
| 32820 | hbus driver | Executed READ  addr=0x103d data=0x42 |
| 32825 | hbus monitor | Collected READ  addr=0x103d data=0x42 |
| 32850 | hbus driver | Executed READ  addr=0x103e data=0x23 |
| 32855 | hbus monitor | Collected READ  addr=0x103e data=0x23 |
| 32880 | hbus driver | Executed READ  addr=0x103f data=0x90 |
| 32885 | hbus monitor | Collected READ  addr=0x103f data=0x90 |
| 32910 | hbus driver | Executed READ  addr=0x1040 data=0x82 |
| 32915 | hbus monitor | Collected READ  addr=0x1040 data=0x82 |
| 32940 | hbus driver | Executed READ  addr=0x1041 data=0xe1 |
| 32945 | hbus monitor | Collected READ  addr=0x1041 data=0xe1 |
| 32970 | hbus driver | Executed READ  addr=0x1042 data=0x06 |
| 32975 | hbus monitor | Collected READ  addr=0x1042 data=0x06 |
| 33000 | hbus driver | Executed READ  addr=0x1043 data=0xe3 |
| 33005 | hbus monitor | Collected READ  addr=0x1043 data=0xe3 |
| 33030 | hbus driver | Executed READ  addr=0x1044 data=0xaf |
| 33035 | hbus monitor | Collected READ  addr=0x1044 data=0xaf |
| 33060 | hbus driver | Executed READ  addr=0x1045 data=0x82 |
| 33065 | hbus monitor | Collected READ  addr=0x1045 data=0x82 |
| 33090 | hbus driver | Executed READ  addr=0x1046 data=0xdb |
| 33095 | hbus monitor | Collected READ  addr=0x1046 data=0xdb |
| 33120 | hbus driver | Executed READ  addr=0x1047 data=0x92 |
| 33125 | hbus monitor | Collected READ  addr=0x1047 data=0x92 |
| 33235 | **test** | STAGE: done: 73 packets (23 forwarded, 50 dropped), 0 storm burst(s), 23 scoreboard matches, 88 HBUS reads checked, 9 error pulses for 9 bad packets |
| 33435 | error checker | error pulse report: 9 bad packets, 9 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 33435 | ch0 monitor | Channel 0 report: 6 packets collected |
| 33435 | ch1 monitor | Channel 1 report: 5 packets collected |
| 33435 | ch2 monitor | Channel 2 report: 12 packets collected |
| 33435 | hbus monitor | HBUS report: 17 writes, 89 reads |
| 33435 | coverage | Coverage of the router configuration: 73.9% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 19 / 0 / 54 / 0 / 0 packets · length < max / = max / max+1 / > max+1 : 16 / 7 / 5 / 45 · forwarded good / bad : 20 / 3 · dropped address 3 good / bad : 3 / 0 · dropped oversized good / bad : 41 / 6 · counter enables none / mixed / all : 0 / 73 / 0 |
| 33435 | coverage | HBUS address coverage: 106 accesses sampled, coverage 46.8% |
| 33435 | coverage | HBUS register bits coverage: 8 writes to ctrl_reg/en_reg, coverage 90.9% |
| 33435 | coverage | HBUS counter value coverage: 11 counter reads sampled, coverage 59.3% |
| 33435 | coverage | HBUS yapp_mem data coverage: 18 accesses sampled, coverage 29.4% |
| 33435 | reference | --- Reference model report --- · forwarded to scoreboard : 23 · dropped (router disabled) : 0 · dropped (oversized) : 47 · dropped (address 3) : 3 · counters parity/oversized/addr0..3 : 6 / 9 / 5 8 39 3 |
| 33435 | reference | HBUS reads checked against the model: 88 (0 mismatches, 1 of memory bytes never written) |
| 33435 | scoreboard | --- Scoreboard report --- · packets received : 23 · packets matched : 23 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 33435 | yapp driver | YAPP driver report: 73 packets sent |
| 33435 | coverage | YAPP gap coverage: 72 gaps sampled, coverage 100.0% |
| 33435 | yapp monitor | YAPP monitor report: 73 packets collected, 9 with bad parity |
| 33435 | yapp monitor | YAPP gaps: 29 back to back, 15 of 1 cycle, 3 of 2, 25 longer |
| 33435 | coverage | YAPP packet coverage: 73 packets sampled, coverage 73.3% |
