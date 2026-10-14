# random_config_test seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 43us · wall 20.8 s · log [`random_config_test_s2.log`](random_config_test_s2.log)

Waves: `random_config_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s2%2Frandom_config_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **74** packet(s) (14 with bad parity); the input monitor saw 74.
- Router: **15** forwarded, **59** dropped (41 oversized, 3 illegal address 3, 15 router disabled).
- Packets out: ch0 **3**, ch1 **5**, ch2 **7**.
- Scoreboard: 15 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 11.
- HBUS: 31 write(s), 113 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_NORMAL |
| 0 | random scenario: 74 packets in 5 bursts |
| 330 | burst 1/5: ctrl=0x3e (maxpktsize 62) en=0x29 (router on, counter enables 0010100), 15 packet(s) |
| 8740 | burst 1/5 sent: addr0..3 3/3/9/0, bad parity 4, gap 0 3, length 1..63 |
| 9130 | burst 2/5: ctrl=0x00 (maxpktsize 0) en=0x01 (router on, counter enables 0000000), 16 packet(s) |
| 16440 | burst 2/5 sent: addr0..3 1/2/10/3, bad parity 2, gap 0 4, length 1..63 |
| 16650 | burst 3/5: ctrl=0x9e (maxpktsize 30) en=0xdf (router on, counter enables 1101111), 14 packet(s) |
| 24130 | burst 3/5 sent: addr0..3 3/3/6/2, bad parity 4, gap 0 1, length 1..63 |
| 24640 | burst 4/5: ctrl=0xb0 (maxpktsize 48) en=0x79 (router on, counter enables 0111100), 14 packet(s) |
| 32080 | burst 4/5 sent: addr0..3 3/6/2/3, bad parity 1, gap 0 6, length 1..63 |
| 32510 | burst 5/5: ctrl=0x3f (maxpktsize 63) en=0xfe (router OFF, counter enables 1111111), 15 packet(s) |
| 40260 | burst 5/5 sent: addr0..3 4/4/7/0, bad parity 3, gap 0 4, length 1..63 |
| 40260 | final reads: every register and the stored packet, checked against the reference model |
| 42565 | done: 74 packets (15 forwarded, 59 dropped), 0 storm burst(s), 15 scoreboard matches, 111 HBUS reads checked, 11 error pulses for 11 bad packets |

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

953 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_NORMAL, ch1 CHANNEL_RX_PROFILE_FAST, ch2 CHANNEL_RX_PROFILE_NORMAL |
| 0 | **test** | STAGE: random scenario: 74 packets in 5 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 75 | reference | maxpktsize is now 62 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0x29 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0x29 |
| 95 | reference | router_en is now 1 (en_reg 0x29) |
| 110 | hbus driver | Executed WRITE addr=0x11f3 data=0x86 |
| 115 | hbus monitor | Collected WRITE addr=0x11f3 data=0x86 |
| 140 | hbus driver | Executed READ  addr=0x11f3 data=0x86 |
| 145 | hbus monitor | Collected READ  addr=0x11f3 data=0x86 |
| 170 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 175 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 200 | hbus driver | Executed READ  addr=0x101e data=0x00 |
| 205 | hbus monitor | Collected READ  addr=0x101e data=0x00 |
| 220 | hbus driver | Executed WRITE addr=0x110f data=0xf7 |
| 225 | hbus monitor | Collected WRITE addr=0x110f data=0xf7 |
| 250 | hbus driver | Executed READ  addr=0x110f data=0xf7 |
| 255 | hbus monitor | Collected READ  addr=0x110f data=0xf7 |
| 280 | hbus driver | Executed READ  addr=0x1014 data=0x00 |
| 285 | hbus monitor | Collected READ  addr=0x1014 data=0x00 |
| 300 | hbus driver | Executed WRITE addr=0x113b data=0xaf |
| 305 | hbus monitor | Collected WRITE addr=0x113b data=0xaf |
| 330 | hbus driver | Executed READ  addr=0x113b data=0xaf |
| 330 | **test** | STAGE: burst 1/5: ctrl=0x3e (maxpktsize 62) en=0x29 (router on, counter enables 0010100), 15 packet(s) |
| 330 | yapp driver | TX pkt #1: addr=2 len=63 parity=good delay=2 |
| 335 | hbus monitor | Collected READ  addr=0x113b data=0xaf |
| 365 | **DUT** | IN  pkt #1 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 1005 | **DUT** | IN  pkt #1 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1005 | yapp monitor | RX pkt #1 on the input: addr=2 len=63 parity=good gap=31 |
| 1005 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 1005 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 1010 | yapp driver | TX pkt #1 accepted by the DUT |
| 1010 | yapp driver | TX pkt #2: addr=2 len=47 parity=bad delay=3 |
| 1045 | **DUT** | IN  pkt #2 header: addr=2 len=47 -> channel 2 |
| 1065 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=47 (receiver waited 1 cycle(s)) |
| 1525 | **DUT** | IN  pkt #2 complete: addr=2 len=47 parity=BAD forwarded, 49 bytes in 49 cycles (held 0) |
| 1525 | yapp monitor | RX pkt #2 on the input: addr=2 len=47 parity=bad gap=3 |
| 1525 | reference | Packet forwarded: addr=2 len=47 -> channel 2 |
| 1530 | yapp driver | TX pkt #2 accepted by the DUT |
| 1530 | yapp driver | TX pkt #3: addr=0 len=15 parity=good delay=12 |
| 1540 | ch2 driver | ch2: packet consumed (response delay 1) |
| 1565 | **DUT** | OUT ch2 pkt #1 done: 49 bytes in 51 cycles |
| 1565 | ch2 monitor | ch2 RX pkt #1: addr=2 len=47 parity=bad |
| 1565 | scoreboard | ch2 pkt matched: addr=2 len=47 (1 matched so far) |
| 1570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 1570 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 1655 | **DUT** | IN  pkt #3 header: addr=0 len=15 -> channel 0 |
| 1690 | ch2 driver | ch2: packet consumed (response delay 1) |
| 1755 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=15 (receiver waited 9 cycle(s)) |
| 1815 | **DUT** | IN  pkt #3 complete: addr=0 len=15 parity=ok forwarded, 17 bytes in 17 cycles (held 0) |
| 1815 | yapp monitor | RX pkt #3 on the input: addr=0 len=15 parity=good gap=12 |
| 1815 | reference | Packet forwarded: addr=0 len=15 -> channel 0 |
| 1820 | yapp driver | TX pkt #3 accepted by the DUT |
| 1820 | yapp driver | TX pkt #4: addr=1 len=63 parity=good delay=0 |
| 1825 | **DUT** | IN  pkt #4 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 1910 | ch0 driver | ch0: packet consumed (response delay 9) |
| 2025 | **DUT** | OUT ch0 pkt #1 done: 17 bytes in 28 cycles |
| 2025 | ch0 monitor | ch0 RX pkt #1: addr=0 len=15 parity=good |
| 2025 | scoreboard | ch0 pkt matched: addr=0 len=15 (2 matched so far) |
| 2300 | ch0 driver | ch0: packet consumed (response delay 10) |
| 2465 | **DUT** | IN  pkt #4 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 2465 | yapp monitor | RX pkt #4 on the input: addr=1 len=63 parity=good gap=0 |
| 2465 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 2465 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 2470 | yapp driver | TX pkt #4 accepted by the DUT |
| 2470 | yapp driver | TX pkt #5: addr=2 len=62 parity=good delay=0 |
| 2475 | **DUT** | IN  pkt #5 header: addr=2 len=62 -> channel 2 |
| 2585 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=62 (receiver waited 10 cycle(s)) |
| 3105 | **DUT** | IN  pkt #5 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 3105 | yapp monitor | RX pkt #5 on the input: addr=2 len=62 parity=good gap=0 |
| 3105 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 3110 | yapp driver | TX pkt #5 accepted by the DUT |
| 3110 | yapp driver | TX pkt #6: addr=0 len=17 parity=bad delay=1 |
| 3125 | **DUT** | IN  pkt #6 header: addr=0 len=17 -> channel 0 |
| 3185 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=17 (receiver waited 5 cycle(s)) |
| 3210 | ch2 driver | ch2: packet consumed (response delay 10) |
| 3305 | **DUT** | IN  pkt #6 complete: addr=0 len=17 parity=BAD forwarded, 19 bytes in 19 cycles (held 0) |
| 3305 | yapp monitor | RX pkt #6 on the input: addr=0 len=17 parity=bad gap=1 |
| 3305 | reference | Packet forwarded: addr=0 len=17 -> channel 0 |
| 3310 | yapp driver | TX pkt #6 accepted by the DUT |
| 3310 | yapp driver | TX pkt #7: addr=1 len=62 parity=good delay=3 |
| 3325 | **DUT** | OUT ch2 pkt #2 done: 64 bytes in 75 cycles |
| 3325 | ch2 monitor | ch2 RX pkt #2: addr=2 len=62 parity=good |
| 3325 | scoreboard | ch2 pkt matched: addr=2 len=62 (3 matched so far) |
| 3345 | **DUT** | IN  pkt #7 header: addr=1 len=62 -> channel 1 |
| 3355 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=62 (receiver waited 0 cycle(s)) |
| 3360 | ch0 driver | ch0: packet consumed (response delay 5) |
| 3370 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 3370 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 3475 | **DUT** | OUT ch0 pkt #2 done: 19 bytes in 30 cycles |
| 3475 | ch0 monitor | ch0 RX pkt #2: addr=0 len=17 parity=bad |
| 3475 | scoreboard | ch0 pkt matched: addr=0 len=17 (4 matched so far) |
| 3840 | ch2 driver | ch2: packet consumed (response delay 10) |
| 3975 | **DUT** | IN  pkt #7 complete: addr=1 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 3975 | yapp monitor | RX pkt #7 on the input: addr=1 len=62 parity=good gap=3 |
| 3975 | reference | Packet forwarded: addr=1 len=62 -> channel 1 |
| 3980 | ch1 driver | ch1: packet consumed (response delay 0) |
| 3980 | ch0 driver | ch0: packet consumed (response delay 10) |
| 3980 | yapp driver | TX pkt #7 accepted by the DUT |
| 3980 | yapp driver | TX pkt #8: addr=1 len=1 parity=good delay=12 |
| 3995 | **DUT** | OUT ch1 pkt #1 done: 64 bytes in 65 cycles |
| 3995 | ch1 monitor | ch1 RX pkt #1: addr=1 len=62 parity=good |
| 3995 | scoreboard | ch1 pkt matched: addr=1 len=62 (5 matched so far) |
| 4105 | **DUT** | IN  pkt #8 header: addr=1 len=1 -> channel 1 |
| 4115 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 4125 | **DUT** | IN  pkt #8 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4125 | yapp monitor | RX pkt #8 on the input: addr=1 len=1 parity=good gap=12 |
| 4125 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 4130 | yapp driver | TX pkt #8 accepted by the DUT |
| 4130 | yapp driver | TX pkt #9: addr=2 len=63 parity=good delay=1 |
| 4135 | **DUT** | OUT ch1 pkt #2 done: 3 bytes in 3 cycles |
| 4135 | ch1 monitor | ch1 RX pkt #2: addr=1 len=1 parity=good |
| 4135 | scoreboard | ch1 pkt matched: addr=1 len=1 (6 matched so far) |
| 4145 | **DUT** | IN  pkt #9 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 4220 | ch1 driver | ch1: packet consumed (response delay 0) |
| 4785 | **DUT** | IN  pkt #9 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4785 | yapp monitor | RX pkt #9 on the input: addr=2 len=63 parity=good gap=1 |
| 4785 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 4785 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 4790 | yapp driver | TX pkt #9 accepted by the DUT |
| 4790 | yapp driver | TX pkt #10: addr=2 len=20 parity=good delay=17 |
| 4965 | **DUT** | IN  pkt #10 header: addr=2 len=20 -> channel 2 |
| 5065 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=20 (receiver waited 9 cycle(s)) |
| 5175 | **DUT** | IN  pkt #10 complete: addr=2 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 5175 | yapp monitor | RX pkt #10 on the input: addr=2 len=20 parity=good gap=17 |
| 5175 | reference | Packet forwarded: addr=2 len=20 -> channel 2 |
| 5180 | yapp driver | TX pkt #10 accepted by the DUT |
| 5180 | yapp driver | TX pkt #11: addr=2 len=63 parity=good delay=19 |
| 5270 | ch2 driver | ch2: packet consumed (response delay 9) |
| 5355 | **DUT** | OUT ch2 pkt #3 done: 22 bytes in 30 cycles |
| 5355 | ch2 monitor | ch2 RX pkt #3: addr=2 len=20 parity=good |
| 5355 | scoreboard | ch2 pkt matched: addr=2 len=20 (7 matched so far) |
| 5375 | **DUT** | IN  pkt #11 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 5670 | ch2 driver | ch2: packet consumed (response delay 7) |
| 6015 | **DUT** | IN  pkt #11 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 6015 | yapp monitor | RX pkt #11 on the input: addr=2 len=63 parity=good gap=19 |
| 6015 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 6015 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 6020 | yapp driver | TX pkt #11 accepted by the DUT |
| 6020 | yapp driver | TX pkt #12: addr=0 len=63 parity=bad delay=16 |
| 6185 | **DUT** | IN  pkt #12 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 6825 | **DUT** | IN  pkt #12 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 6825 | yapp monitor | RX pkt #12 on the input: addr=0 len=63 parity=bad gap=16 |
| 6825 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 6825 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 6830 | yapp driver | TX pkt #12 accepted by the DUT |
| 6830 | yapp driver | TX pkt #13: addr=2 len=63 parity=bad delay=4 |
| 6875 | **DUT** | IN  pkt #13 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 6890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 6890 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 7515 | **DUT** | IN  pkt #13 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 7515 | yapp monitor | RX pkt #13 on the input: addr=2 len=63 parity=bad gap=4 |
| 7515 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 7515 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 7520 | yapp driver | TX pkt #13 accepted by the DUT |
| 7520 | yapp driver | TX pkt #14: addr=2 len=54 parity=good delay=0 |
| 7525 | **DUT** | IN  pkt #14 header: addr=2 len=54 -> channel 2 |
| 7530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 7530 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 7605 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=54 (receiver waited 7 cycle(s)) |
| 8075 | **DUT** | IN  pkt #14 complete: addr=2 len=54 parity=ok forwarded, 56 bytes in 56 cycles (held 0) |
| 8075 | yapp monitor | RX pkt #14 on the input: addr=2 len=54 parity=good gap=0 |
| 8075 | reference | Packet forwarded: addr=2 len=54 -> channel 2 |
| 8080 | yapp driver | TX pkt #14 accepted by the DUT |
| 8080 | yapp driver | TX pkt #15: addr=2 len=63 parity=good delay=1 |
| 8095 | **DUT** | IN  pkt #15 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 8150 | ch2 driver | ch2: packet consumed (response delay 7) |
| 8265 | **DUT** | OUT ch2 pkt #4 done: 56 bytes in 67 cycles |
| 8265 | ch2 monitor | ch2 RX pkt #4: addr=2 len=54 parity=good |
| 8265 | scoreboard | ch2 pkt matched: addr=2 len=54 (8 matched so far) |
| 8735 | **DUT** | IN  pkt #15 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8735 | yapp monitor | RX pkt #15 on the input: addr=2 len=63 parity=good gap=1 |
| 8735 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 8735 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 8740 | yapp driver | TX pkt #15 accepted by the DUT |
| 8740 | **test** | STAGE: burst 1/5 sent: addr0..3 3/3/9/0, bad parity 4, gap 0 3, length 1..63 |
| 8760 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 8765 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 8765 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 8765 | reference | maxpktsize is now 0 |
| 8770 | ch2 driver | ch2: packet consumed (response delay 10) |
| 8780 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 8785 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 8785 | reference | router_en is now 1 (en_reg 0x01) |
| 8800 | hbus driver | Executed WRITE addr=0x119b data=0xcf |
| 8805 | hbus monitor | Collected WRITE addr=0x119b data=0xcf |
| 8830 | hbus driver | Executed READ  addr=0x119b data=0xcf |
| 8835 | hbus monitor | Collected READ  addr=0x119b data=0xcf |
| 8850 | hbus driver | Executed WRITE addr=0x1192 data=0xb7 |
| 8855 | hbus monitor | Collected WRITE addr=0x1192 data=0xb7 |
| 8880 | hbus driver | Executed READ  addr=0x1192 data=0xb7 |
| 8885 | hbus monitor | Collected READ  addr=0x1192 data=0xb7 |
| 8910 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 8915 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 8940 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 8945 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 8960 | hbus driver | Executed WRITE addr=0x11f2 data=0x6d |
| 8965 | hbus monitor | Collected WRITE addr=0x11f2 data=0x6d |
| 8990 | hbus driver | Executed READ  addr=0x11f2 data=0x6d |
| 8995 | hbus monitor | Collected READ  addr=0x11f2 data=0x6d |
| 9020 | hbus driver | Executed READ  addr=0x10df data=0x00 |
| 9025 | hbus monitor | Collected READ  addr=0x10df data=0x00 |
| 9050 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 9055 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9070 | hbus driver | Executed WRITE addr=0x11ff data=0x36 |
| 9075 | hbus monitor | Collected WRITE addr=0x11ff data=0x36 |
| 9100 | hbus driver | Executed READ  addr=0x11ff data=0x36 |
| 9105 | hbus monitor | Collected READ  addr=0x11ff data=0x36 |
| 9130 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 9130 | **test** | STAGE: burst 2/5: ctrl=0x00 (maxpktsize 0) en=0x01 (router on, counter enables 0000000), 16 packet(s) |
| 9130 | yapp driver | TX pkt #16: addr=2 len=63 parity=good delay=0 |
| 9135 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 9145 | **DUT** | IN  pkt #16 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 9785 | **DUT** | IN  pkt #16 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 9785 | yapp monitor | RX pkt #16 on the input: addr=2 len=63 parity=good gap=40 |
| 9785 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 9785 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 9790 | yapp driver | TX pkt #16 accepted by the DUT |
| 9790 | yapp driver | TX pkt #17: addr=2 len=36 parity=good delay=18 |
| 9975 | **DUT** | IN  pkt #17 header: addr=2 len=36 -> DROP (oversized: len 36 > maxpktsize 0) |
| 10345 | **DUT** | IN  pkt #17 complete: addr=2 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 10345 | yapp monitor | RX pkt #17 on the input: addr=2 len=36 parity=good gap=18 |
| 10345 | reference | Packet dropped: length 36 > maxpktsize 0 (addr=2) |
| 10345 | **DUT** | ROUTER DROPS PACKET addr=2 length=36 (length > maxpktsize) |
| 10350 | yapp driver | TX pkt #17 accepted by the DUT |
| 10350 | yapp driver | TX pkt #18: addr=2 len=9 parity=good delay=2 |
| 10375 | **DUT** | IN  pkt #18 header: addr=2 len=9 -> DROP (oversized: len 9 > maxpktsize 0) |
| 10475 | **DUT** | IN  pkt #18 complete: addr=2 len=9 parity=ok dropped, 11 bytes in 11 cycles (held 0) |
| 10475 | yapp monitor | RX pkt #18 on the input: addr=2 len=9 parity=good gap=2 |
| 10475 | reference | Packet dropped: length 9 > maxpktsize 0 (addr=2) |
| 10475 | **DUT** | ROUTER DROPS PACKET addr=2 length=9 (length > maxpktsize) |
| 10480 | yapp driver | TX pkt #18 accepted by the DUT |
| 10480 | yapp driver | TX pkt #19: addr=1 len=1 parity=good delay=0 |
| 10485 | **DUT** | IN  pkt #19 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 10505 | **DUT** | IN  pkt #19 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 10505 | yapp monitor | RX pkt #19 on the input: addr=1 len=1 parity=good gap=0 |
| 10505 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 10505 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 10510 | yapp driver | TX pkt #19 accepted by the DUT |
| 10510 | yapp driver | TX pkt #20: addr=0 len=63 parity=good delay=3 |
| 10545 | **DUT** | IN  pkt #20 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 11185 | **DUT** | IN  pkt #20 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11185 | yapp monitor | RX pkt #20 on the input: addr=0 len=63 parity=good gap=3 |
| 11185 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=0) |
| 11185 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 11190 | yapp driver | TX pkt #20 accepted by the DUT |
| 11190 | yapp driver | TX pkt #21: addr=2 len=63 parity=good delay=18 |
| 11375 | **DUT** | IN  pkt #21 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 12015 | **DUT** | IN  pkt #21 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12015 | yapp monitor | RX pkt #21 on the input: addr=2 len=63 parity=good gap=18 |
| 12015 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 12015 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 12020 | yapp driver | TX pkt #21 accepted by the DUT |
| 12020 | yapp driver | TX pkt #22: addr=2 len=63 parity=bad delay=0 |
| 12025 | **DUT** | IN  pkt #22 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 12665 | **DUT** | IN  pkt #22 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 12665 | yapp monitor | RX pkt #22 on the input: addr=2 len=63 parity=bad gap=0 |
| 12665 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 12665 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 12670 | yapp driver | TX pkt #22 accepted by the DUT |
| 12670 | yapp driver | TX pkt #23: addr=2 len=1 parity=good delay=6 |
| 12710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 12710 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 12735 | **DUT** | IN  pkt #23 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 12755 | **DUT** | IN  pkt #23 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 12755 | yapp monitor | RX pkt #23 on the input: addr=2 len=1 parity=good gap=6 |
| 12755 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 12755 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 12760 | yapp driver | TX pkt #23 accepted by the DUT |
| 12760 | yapp driver | TX pkt #24: addr=1 len=3 parity=good delay=20 |
| 12965 | **DUT** | IN  pkt #24 header: addr=1 len=3 -> DROP (oversized: len 3 > maxpktsize 0) |
| 13005 | **DUT** | IN  pkt #24 complete: addr=1 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 13005 | yapp monitor | RX pkt #24 on the input: addr=1 len=3 parity=good gap=20 |
| 13005 | reference | Packet dropped: length 3 > maxpktsize 0 (addr=1) |
| 13005 | **DUT** | ROUTER DROPS PACKET addr=1 length=3 (length > maxpktsize) |
| 13010 | yapp driver | TX pkt #24 accepted by the DUT |
| 13010 | yapp driver | TX pkt #25: addr=3 len=63 parity=good delay=3 |
| 13045 | **DUT** | IN  pkt #25 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 13685 | **DUT** | IN  pkt #25 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 13685 | yapp monitor | RX pkt #25 on the input: addr=3 len=63 parity=good gap=3 |
| 13685 | reference | Packet dropped: illegal address 3 (len=63) |
| 13685 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 13690 | yapp driver | TX pkt #25 accepted by the DUT |
| 13690 | yapp driver | TX pkt #26: addr=2 len=63 parity=bad delay=0 |
| 13695 | **DUT** | IN  pkt #26 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 14335 | **DUT** | IN  pkt #26 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 14335 | yapp monitor | RX pkt #26 on the input: addr=2 len=63 parity=bad gap=0 |
| 14335 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 14335 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 14340 | yapp driver | TX pkt #26 accepted by the DUT |
| 14340 | yapp driver | TX pkt #27: addr=2 len=1 parity=good delay=3 |
| 14375 | **DUT** | IN  pkt #27 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 14390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 14390 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 14395 | **DUT** | IN  pkt #27 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 14395 | yapp monitor | RX pkt #27 on the input: addr=2 len=1 parity=good gap=3 |
| 14395 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 14395 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 14400 | yapp driver | TX pkt #27 accepted by the DUT |
| 14400 | yapp driver | TX pkt #28: addr=2 len=1 parity=good delay=1 |
| 14415 | **DUT** | IN  pkt #28 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 14435 | **DUT** | IN  pkt #28 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 14435 | yapp monitor | RX pkt #28 on the input: addr=2 len=1 parity=good gap=1 |
| 14435 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 14435 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 14440 | yapp driver | TX pkt #28 accepted by the DUT |
| 14440 | yapp driver | TX pkt #29: addr=3 len=63 parity=good delay=3 |
| 14475 | **DUT** | IN  pkt #29 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 15115 | **DUT** | IN  pkt #29 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 15115 | yapp monitor | RX pkt #29 on the input: addr=3 len=63 parity=good gap=3 |
| 15115 | reference | Packet dropped: illegal address 3 (len=63) |
| 15115 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 15120 | yapp driver | TX pkt #29 accepted by the DUT |
| 15120 | yapp driver | TX pkt #30: addr=2 len=63 parity=good delay=1 |
| 15135 | **DUT** | IN  pkt #30 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 15775 | **DUT** | IN  pkt #30 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 15775 | yapp monitor | RX pkt #30 on the input: addr=2 len=63 parity=good gap=1 |
| 15775 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 15775 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 15780 | yapp driver | TX pkt #30 accepted by the DUT |
| 15780 | yapp driver | TX pkt #31: addr=3 len=63 parity=good delay=1 |
| 15795 | **DUT** | IN  pkt #31 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 16435 | **DUT** | IN  pkt #31 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 16435 | yapp monitor | RX pkt #31 on the input: addr=3 len=63 parity=good gap=1 |
| 16435 | reference | Packet dropped: illegal address 3 (len=63) |
| 16435 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 16440 | yapp driver | TX pkt #31 accepted by the DUT |
| 16440 | **test** | STAGE: burst 2/5 sent: addr0..3 1/2/10/3, bad parity 2, gap 0 4, length 1..63 |
| 16460 | hbus driver | Executed WRITE addr=0x1000 data=0x9e |
| 16465 | **DUT** | CONFIG router_en=1 maxpktsize=30 |
| 16465 | hbus monitor | Collected WRITE addr=0x1000 data=0x9e |
| 16465 | reference | maxpktsize is now 30 |
| 16480 | hbus driver | Executed WRITE addr=0x1001 data=0xdf |
| 16485 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 16485 | reference | router_en is now 1 (en_reg 0xdf) |
| 16500 | hbus driver | Executed WRITE addr=0x1177 data=0x0d |
| 16505 | hbus monitor | Collected WRITE addr=0x1177 data=0x0d |
| 16530 | hbus driver | Executed READ  addr=0x1177 data=0x0d |
| 16535 | hbus monitor | Collected READ  addr=0x1177 data=0x0d |
| 16560 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 16565 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16590 | hbus driver | Executed READ  addr=0x103b data=0x1f |
| 16595 | hbus monitor | Collected READ  addr=0x103b data=0x1f |
| 16620 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 16625 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16650 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 16650 | **test** | STAGE: burst 3/5: ctrl=0x9e (maxpktsize 30) en=0xdf (router on, counter enables 1101111), 14 packet(s) |
| 16650 | yapp driver | TX pkt #32: addr=2 len=46 parity=good delay=1 |
| 16655 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16675 | **DUT** | IN  pkt #32 header: addr=2 len=46 -> DROP (oversized: len 46 > maxpktsize 30) |
| 17145 | **DUT** | IN  pkt #32 complete: addr=2 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 17145 | yapp monitor | RX pkt #32 on the input: addr=2 len=46 parity=good gap=23 |
| 17145 | reference | Packet dropped: length 46 > maxpktsize 30 (addr=2) |
| 17145 | **DUT** | ROUTER DROPS PACKET addr=2 length=46 (length > maxpktsize) |
| 17150 | yapp driver | TX pkt #32 accepted by the DUT |
| 17150 | yapp driver | TX pkt #33: addr=0 len=31 parity=good delay=15 |
| 17305 | **DUT** | IN  pkt #33 header: addr=0 len=31 -> DROP (oversized: len 31 > maxpktsize 30) |
| 17625 | **DUT** | IN  pkt #33 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 17625 | yapp monitor | RX pkt #33 on the input: addr=0 len=31 parity=good gap=15 |
| 17625 | reference | Packet dropped: length 31 > maxpktsize 30 (addr=0) |
| 17625 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (length > maxpktsize) |
| 17630 | yapp driver | TX pkt #33 accepted by the DUT |
| 17630 | yapp driver | TX pkt #34: addr=0 len=63 parity=bad delay=13 |
| 17765 | **DUT** | IN  pkt #34 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 18405 | **DUT** | IN  pkt #34 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 18405 | yapp monitor | RX pkt #34 on the input: addr=0 len=63 parity=bad gap=13 |
| 18405 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=0) |
| 18405 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 18410 | yapp driver | TX pkt #34 accepted by the DUT |
| 18410 | yapp driver | TX pkt #35: addr=1 len=63 parity=good delay=17 |
| 18430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 18430 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 18585 | **DUT** | IN  pkt #35 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 19225 | **DUT** | IN  pkt #35 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 19225 | yapp monitor | RX pkt #35 on the input: addr=1 len=63 parity=good gap=17 |
| 19225 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=1) |
| 19225 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 19230 | yapp driver | TX pkt #35 accepted by the DUT |
| 19230 | yapp driver | TX pkt #36: addr=3 len=63 parity=good delay=17 |
| 19405 | **DUT** | IN  pkt #36 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 20045 | **DUT** | IN  pkt #36 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 20045 | yapp monitor | RX pkt #36 on the input: addr=3 len=63 parity=good gap=17 |
| 20045 | reference | Packet dropped: illegal address 3 (len=63) |
| 20045 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 20050 | yapp driver | TX pkt #36 accepted by the DUT |
| 20050 | yapp driver | TX pkt #37: addr=2 len=63 parity=bad delay=1 |
| 20065 | **DUT** | IN  pkt #37 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 20705 | **DUT** | IN  pkt #37 complete: addr=2 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 20705 | yapp monitor | RX pkt #37 on the input: addr=2 len=63 parity=bad gap=1 |
| 20705 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=2) |
| 20705 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 20710 | yapp driver | TX pkt #37 accepted by the DUT |
| 20710 | yapp driver | TX pkt #38: addr=2 len=1 parity=good delay=1 |
| 20725 | **DUT** | IN  pkt #38 header: addr=2 len=1 -> channel 2 |
| 20730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 20730 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 20745 | **DUT** | IN  pkt #38 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20745 | yapp monitor | RX pkt #38 on the input: addr=2 len=1 parity=good gap=1 |
| 20745 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 20750 | yapp driver | TX pkt #38 accepted by the DUT |
| 20750 | yapp driver | TX pkt #39: addr=0 len=31 parity=bad delay=3 |
| 20785 | **DUT** | IN  pkt #39 header: addr=0 len=31 -> DROP (oversized: len 31 > maxpktsize 30) |
| 20835 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=1 (receiver waited 10 cycle(s)) |
| 20850 | ch2 driver | ch2: packet consumed (response delay 10) |
| 20955 | **DUT** | OUT ch2 pkt #5 done: 3 bytes in 13 cycles |
| 20955 | ch2 monitor | ch2 RX pkt #5: addr=2 len=1 parity=good |
| 20955 | scoreboard | ch2 pkt matched: addr=2 len=1 (9 matched so far) |
| 21105 | **DUT** | IN  pkt #39 complete: addr=0 len=31 parity=BAD dropped, 33 bytes in 33 cycles (held 0) |
| 21105 | yapp monitor | RX pkt #39 on the input: addr=0 len=31 parity=bad gap=3 |
| 21105 | reference | Packet dropped: length 31 > maxpktsize 30 (addr=0) |
| 21105 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (length > maxpktsize) |
| 21110 | yapp driver | TX pkt #39 accepted by the DUT |
| 21110 | yapp driver | TX pkt #40: addr=1 len=38 parity=bad delay=17 |
| 21150 | ch2 driver | ch2: packet consumed (response delay 9) |
| 21210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 21210 | error checker | error pulse 10 cycles after the bad packet (0 still owed) |
| 21285 | **DUT** | IN  pkt #40 header: addr=1 len=38 -> DROP (oversized: len 38 > maxpktsize 30) |
| 21675 | **DUT** | IN  pkt #40 complete: addr=1 len=38 parity=BAD dropped, 40 bytes in 40 cycles (held 0) |
| 21675 | yapp monitor | RX pkt #40 on the input: addr=1 len=38 parity=bad gap=17 |
| 21675 | reference | Packet dropped: length 38 > maxpktsize 30 (addr=1) |
| 21675 | **DUT** | ROUTER DROPS PACKET addr=1 length=38 (length > maxpktsize) |
| 21680 | yapp driver | TX pkt #40 accepted by the DUT |
| 21680 | yapp driver | TX pkt #41: addr=2 len=20 parity=good delay=8 |
| 21710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 21710 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 21765 | **DUT** | IN  pkt #41 header: addr=2 len=20 -> channel 2 |
| 21845 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=20 (receiver waited 7 cycle(s)) |
| 21975 | **DUT** | IN  pkt #41 complete: addr=2 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 21975 | yapp monitor | RX pkt #41 on the input: addr=2 len=20 parity=good gap=8 |
| 21975 | reference | Packet forwarded: addr=2 len=20 -> channel 2 |
| 21980 | yapp driver | TX pkt #41 accepted by the DUT |
| 21980 | yapp driver | TX pkt #42: addr=3 len=52 parity=good delay=0 |
| 21985 | **DUT** | IN  pkt #42 header: addr=3 len=52 -> DROP (oversized: len 52 > maxpktsize 30) |
| 22050 | ch2 driver | ch2: packet consumed (response delay 7) |
| 22065 | **DUT** | OUT ch2 pkt #6 done: 22 bytes in 23 cycles |
| 22065 | ch2 monitor | ch2 RX pkt #6: addr=2 len=20 parity=good |
| 22065 | scoreboard | ch2 pkt matched: addr=2 len=20 (10 matched so far) |
| 22290 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22515 | **DUT** | IN  pkt #42 complete: addr=3 len=52 parity=ok dropped, 54 bytes in 54 cycles (held 0) |
| 22515 | yapp monitor | RX pkt #42 on the input: addr=3 len=52 parity=good gap=0 |
| 22515 | reference | Packet dropped: illegal address 3 (len=52) |
| 22515 | **DUT** | ROUTER DROPS PACKET addr=3 length=52 (    illegal address) |
| 22520 | yapp driver | TX pkt #42 accepted by the DUT |
| 22520 | yapp driver | TX pkt #43: addr=1 len=30 parity=good delay=18 |
| 22705 | **DUT** | IN  pkt #43 header: addr=1 len=30 -> channel 1 |
| 22715 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=30 (receiver waited 0 cycle(s)) |
| 23015 | **DUT** | IN  pkt #43 complete: addr=1 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 23015 | yapp monitor | RX pkt #43 on the input: addr=1 len=30 parity=good gap=18 |
| 23015 | reference | Packet forwarded: addr=1 len=30 -> channel 1 |
| 23020 | ch1 driver | ch1: packet consumed (response delay 0) |
| 23020 | yapp driver | TX pkt #43 accepted by the DUT |
| 23020 | yapp driver | TX pkt #44: addr=2 len=63 parity=good delay=13 |
| 23035 | **DUT** | OUT ch1 pkt #3 done: 32 bytes in 33 cycles |
| 23035 | ch1 monitor | ch1 RX pkt #3: addr=1 len=30 parity=good |
| 23035 | scoreboard | ch1 pkt matched: addr=1 len=30 (11 matched so far) |
| 23155 | **DUT** | IN  pkt #44 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 30) |
| 23610 | ch1 driver | ch1: packet consumed (response delay 0) |
| 23795 | **DUT** | IN  pkt #44 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 23795 | yapp monitor | RX pkt #44 on the input: addr=2 len=63 parity=good gap=13 |
| 23795 | reference | Packet dropped: length 63 > maxpktsize 30 (addr=2) |
| 23795 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 23800 | yapp driver | TX pkt #44 accepted by the DUT |
| 23800 | yapp driver | TX pkt #45: addr=2 len=15 parity=good delay=16 |
| 23965 | **DUT** | IN  pkt #45 header: addr=2 len=15 -> channel 2 |
| 23995 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=15 (receiver waited 2 cycle(s)) |
| 24125 | **DUT** | IN  pkt #45 complete: addr=2 len=15 parity=ok forwarded, 17 bytes in 17 cycles (held 0) |
| 24125 | yapp monitor | RX pkt #45 on the input: addr=2 len=15 parity=good gap=16 |
| 24125 | reference | Packet forwarded: addr=2 len=15 -> channel 2 |
| 24130 | yapp driver | TX pkt #45 accepted by the DUT |
| 24130 | **test** | STAGE: burst 3/5 sent: addr0..3 3/3/6/2, bad parity 4, gap 0 1, length 1..63 |
| 24150 | ch2 driver | ch2: packet consumed (response delay 2) |
| 24150 | hbus driver | Executed WRITE addr=0x1000 data=0xb0 |
| 24155 | **DUT** | CONFIG router_en=1 maxpktsize=48 |
| 24155 | hbus monitor | Collected WRITE addr=0x1000 data=0xb0 |
| 24155 | reference | maxpktsize is now 48 |
| 24170 | hbus driver | Executed WRITE addr=0x1001 data=0x79 |
| 24175 | hbus monitor | Collected WRITE addr=0x1001 data=0x79 |
| 24175 | reference | router_en is now 1 (en_reg 0x79) |
| 24190 | hbus driver | Executed WRITE addr=0x1179 data=0xb1 |
| 24195 | hbus monitor | Collected WRITE addr=0x1179 data=0xb1 |
| 24220 | hbus driver | Executed READ  addr=0x1179 data=0xb1 |
| 24225 | hbus monitor | Collected READ  addr=0x1179 data=0xb1 |
| 24240 | hbus driver | Executed WRITE addr=0x1196 data=0x49 |
| 24245 | **DUT** | OUT ch2 pkt #7 done: 17 bytes in 26 cycles |
| 24245 | ch2 monitor | ch2 RX pkt #7: addr=2 len=15 parity=good |
| 24245 | scoreboard | ch2 pkt matched: addr=2 len=15 (12 matched so far) |
| 24245 | hbus monitor | Collected WRITE addr=0x1196 data=0x49 |
| 24270 | hbus driver | Executed READ  addr=0x1196 data=0x49 |
| 24275 | hbus monitor | Collected READ  addr=0x1196 data=0x49 |
| 24300 | hbus driver | Executed READ  addr=0x1091 data=0x00 |
| 24305 | hbus monitor | Collected READ  addr=0x1091 data=0x00 |
| 24320 | hbus driver | Executed WRITE addr=0x11b2 data=0x7b |
| 24325 | hbus monitor | Collected WRITE addr=0x11b2 data=0x7b |
| 24350 | hbus driver | Executed READ  addr=0x11b2 data=0x7b |
| 24355 | hbus monitor | Collected READ  addr=0x11b2 data=0x7b |
| 24380 | ch2 driver | ch2: packet consumed (response delay 8) |
| 24380 | hbus driver | Executed READ  addr=0x1033 data=0x2e |
| 24385 | hbus monitor | Collected READ  addr=0x1033 data=0x2e |
| 24400 | hbus driver | Executed WRITE addr=0x11cd data=0x52 |
| 24405 | hbus monitor | Collected WRITE addr=0x11cd data=0x52 |
| 24430 | hbus driver | Executed READ  addr=0x11cd data=0x52 |
| 24435 | hbus monitor | Collected READ  addr=0x11cd data=0x52 |
| 24460 | hbus driver | Executed READ  addr=0x1005 data=0x0a |
| 24465 | hbus monitor | Collected READ  addr=0x1005 data=0x0a |
| 24490 | hbus driver | Executed READ  addr=0x100b data=0x06 |
| 24495 | hbus monitor | Collected READ  addr=0x100b data=0x06 |
| 24510 | hbus driver | Executed WRITE addr=0x11e6 data=0xf5 |
| 24515 | hbus monitor | Collected WRITE addr=0x11e6 data=0xf5 |
| 24540 | hbus driver | Executed READ  addr=0x11e6 data=0xf5 |
| 24545 | hbus monitor | Collected READ  addr=0x11e6 data=0xf5 |
| 24560 | hbus driver | Executed WRITE addr=0x111f data=0x17 |
| 24565 | hbus monitor | Collected WRITE addr=0x111f data=0x17 |
| 24590 | hbus driver | Executed READ  addr=0x111f data=0x17 |
| 24595 | hbus monitor | Collected READ  addr=0x111f data=0x17 |
| 24610 | hbus driver | Executed WRITE addr=0x11cf data=0x2e |
| 24615 | hbus monitor | Collected WRITE addr=0x11cf data=0x2e |
| 24640 | hbus driver | Executed READ  addr=0x11cf data=0x2e |
| 24640 | **test** | STAGE: burst 4/5: ctrl=0xb0 (maxpktsize 48) en=0x79 (router on, counter enables 0111100), 14 packet(s) |
| 24640 | yapp driver | TX pkt #46: addr=1 len=63 parity=good delay=20 |
| 24645 | hbus monitor | Collected READ  addr=0x11cf data=0x2e |
| 24855 | **DUT** | IN  pkt #46 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 48) |
| 25495 | **DUT** | IN  pkt #46 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 25495 | yapp monitor | RX pkt #46 on the input: addr=1 len=63 parity=good gap=72 |
| 25495 | reference | Packet dropped: length 63 > maxpktsize 48 (addr=1) |
| 25495 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 25500 | yapp driver | TX pkt #46 accepted by the DUT |
| 25500 | yapp driver | TX pkt #47: addr=1 len=21 parity=good delay=0 |
| 25505 | **DUT** | IN  pkt #47 header: addr=1 len=21 -> channel 1 |
| 25515 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=21 (receiver waited 0 cycle(s)) |
| 25725 | **DUT** | IN  pkt #47 complete: addr=1 len=21 parity=ok forwarded, 23 bytes in 23 cycles (held 0) |
| 25725 | yapp monitor | RX pkt #47 on the input: addr=1 len=21 parity=good gap=0 |
| 25725 | reference | Packet forwarded: addr=1 len=21 -> channel 1 |
| 25730 | ch1 driver | ch1: packet consumed (response delay 0) |
| 25730 | yapp driver | TX pkt #47 accepted by the DUT |
| 25730 | yapp driver | TX pkt #48: addr=3 len=42 parity=good delay=0 |
| 25735 | **DUT** | IN  pkt #48 header: addr=3 len=42 -> DROP (illegal address 3) |
| 25745 | **DUT** | OUT ch1 pkt #4 done: 23 bytes in 24 cycles |
| 25745 | ch1 monitor | ch1 RX pkt #4: addr=1 len=21 parity=good |
| 25745 | scoreboard | ch1 pkt matched: addr=1 len=21 (13 matched so far) |
| 25880 | ch1 driver | ch1: packet consumed (response delay 0) |
| 26165 | **DUT** | IN  pkt #48 complete: addr=3 len=42 parity=ok dropped, 44 bytes in 44 cycles (held 0) |
| 26165 | yapp monitor | RX pkt #48 on the input: addr=3 len=42 parity=good gap=0 |
| 26165 | reference | Packet dropped: illegal address 3 (len=42) |
| 26165 | **DUT** | ROUTER DROPS PACKET addr=3 length=42 (    illegal address) |
| 26170 | yapp driver | TX pkt #48 accepted by the DUT |
| 26170 | yapp driver | TX pkt #49: addr=2 len=61 parity=good delay=7 |
| 26245 | **DUT** | IN  pkt #49 header: addr=2 len=61 -> DROP (oversized: len 61 > maxpktsize 48) |
| 26865 | **DUT** | IN  pkt #49 complete: addr=2 len=61 parity=ok dropped, 63 bytes in 63 cycles (held 0) |
| 26865 | yapp monitor | RX pkt #49 on the input: addr=2 len=61 parity=good gap=7 |
| 26865 | reference | Packet dropped: length 61 > maxpktsize 48 (addr=2) |
| 26865 | **DUT** | ROUTER DROPS PACKET addr=2 length=61 (length > maxpktsize) |
| 26870 | yapp driver | TX pkt #49 accepted by the DUT |
| 26870 | yapp driver | TX pkt #50: addr=0 len=13 parity=good delay=3 |
| 26905 | **DUT** | IN  pkt #50 header: addr=0 len=13 -> channel 0 |
| 27005 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=13 (receiver waited 9 cycle(s)) |
| 27045 | **DUT** | IN  pkt #50 complete: addr=0 len=13 parity=ok forwarded, 15 bytes in 15 cycles (held 0) |
| 27045 | yapp monitor | RX pkt #50 on the input: addr=0 len=13 parity=good gap=3 |
| 27045 | reference | Packet forwarded: addr=0 len=13 -> channel 0 |
| 27050 | yapp driver | TX pkt #50 accepted by the DUT |
| 27050 | yapp driver | TX pkt #51: addr=1 len=29 parity=good delay=0 |
| 27055 | **DUT** | IN  pkt #51 header: addr=1 len=29 -> channel 1 |
| 27065 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=29 (receiver waited 0 cycle(s)) |
| 27140 | ch0 driver | ch0: packet consumed (response delay 9) |
| 27255 | **DUT** | OUT ch0 pkt #3 done: 15 bytes in 26 cycles |
| 27255 | ch0 monitor | ch0 RX pkt #3: addr=0 len=13 parity=good |
| 27255 | scoreboard | ch0 pkt matched: addr=0 len=13 (14 matched so far) |
| 27355 | **DUT** | IN  pkt #51 complete: addr=1 len=29 parity=ok forwarded, 31 bytes in 31 cycles (held 0) |
| 27355 | yapp monitor | RX pkt #51 on the input: addr=1 len=29 parity=good gap=0 |
| 27355 | reference | Packet forwarded: addr=1 len=29 -> channel 1 |
| 27360 | ch1 driver | ch1: packet consumed (response delay 0) |
| 27360 | yapp driver | TX pkt #51 accepted by the DUT |
| 27360 | yapp driver | TX pkt #52: addr=1 len=49 parity=good delay=7 |
| 27375 | **DUT** | OUT ch1 pkt #5 done: 31 bytes in 32 cycles |
| 27375 | ch1 monitor | ch1 RX pkt #5: addr=1 len=29 parity=good |
| 27375 | scoreboard | ch1 pkt matched: addr=1 len=29 (15 matched so far) |
| 27435 | **DUT** | IN  pkt #52 header: addr=1 len=49 -> DROP (oversized: len 49 > maxpktsize 48) |
| 27540 | ch0 driver | ch0: packet consumed (response delay 10) |
| 27935 | **DUT** | IN  pkt #52 complete: addr=1 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 27935 | yapp monitor | RX pkt #52 on the input: addr=1 len=49 parity=good gap=7 |
| 27935 | reference | Packet dropped: length 49 > maxpktsize 48 (addr=1) |
| 27935 | **DUT** | ROUTER DROPS PACKET addr=1 length=49 (length > maxpktsize) |
| 27940 | yapp driver | TX pkt #52 accepted by the DUT |
| 27940 | yapp driver | TX pkt #53: addr=0 len=49 parity=good delay=0 |
| 27945 | **DUT** | IN  pkt #53 header: addr=0 len=49 -> DROP (oversized: len 49 > maxpktsize 48) |
| 28010 | ch1 driver | ch1: packet consumed (response delay 0) |
| 28445 | **DUT** | IN  pkt #53 complete: addr=0 len=49 parity=ok dropped, 51 bytes in 51 cycles (held 0) |
| 28445 | yapp monitor | RX pkt #53 on the input: addr=0 len=49 parity=good gap=0 |
| 28445 | reference | Packet dropped: length 49 > maxpktsize 48 (addr=0) |
| 28445 | **DUT** | ROUTER DROPS PACKET addr=0 length=49 (length > maxpktsize) |
| 28450 | yapp driver | TX pkt #53 accepted by the DUT |
| 28450 | yapp driver | TX pkt #54: addr=2 len=63 parity=good delay=15 |
| 28605 | **DUT** | IN  pkt #54 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 48) |
| 29245 | **DUT** | IN  pkt #54 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 29245 | yapp monitor | RX pkt #54 on the input: addr=2 len=63 parity=good gap=15 |
| 29245 | reference | Packet dropped: length 63 > maxpktsize 48 (addr=2) |
| 29245 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 29250 | yapp driver | TX pkt #54 accepted by the DUT |
| 29250 | yapp driver | TX pkt #55: addr=3 len=47 parity=good delay=16 |
| 29415 | **DUT** | IN  pkt #55 header: addr=3 len=47 -> DROP (illegal address 3) |
| 29895 | **DUT** | IN  pkt #55 complete: addr=3 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 29895 | yapp monitor | RX pkt #55 on the input: addr=3 len=47 parity=good gap=16 |
| 29895 | reference | Packet dropped: illegal address 3 (len=47) |
| 29895 | **DUT** | ROUTER DROPS PACKET addr=3 length=47 (    illegal address) |
| 29900 | yapp driver | TX pkt #55 accepted by the DUT |
| 29900 | yapp driver | TX pkt #56: addr=1 len=63 parity=good delay=0 |
| 29905 | **DUT** | IN  pkt #56 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 48) |
| 30545 | **DUT** | IN  pkt #56 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 30545 | yapp monitor | RX pkt #56 on the input: addr=1 len=63 parity=good gap=0 |
| 30545 | reference | Packet dropped: length 63 > maxpktsize 48 (addr=1) |
| 30545 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 30550 | yapp driver | TX pkt #56 accepted by the DUT |
| 30550 | yapp driver | TX pkt #57: addr=1 len=63 parity=bad delay=18 |
| 30735 | **DUT** | IN  pkt #57 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 48) |
| 31375 | **DUT** | IN  pkt #57 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 31375 | yapp monitor | RX pkt #57 on the input: addr=1 len=63 parity=bad gap=18 |
| 31375 | reference | Packet dropped: length 63 > maxpktsize 48 (addr=1) |
| 31375 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 31380 | yapp driver | TX pkt #57 accepted by the DUT |
| 31380 | yapp driver | TX pkt #58: addr=3 len=1 parity=good delay=2 |
| 31405 | **DUT** | IN  pkt #58 header: addr=3 len=1 -> DROP (illegal address 3) |
| 31410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 31410 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 31425 | **DUT** | IN  pkt #58 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 31425 | yapp monitor | RX pkt #58 on the input: addr=3 len=1 parity=good gap=2 |
| 31425 | reference | Packet dropped: illegal address 3 (len=1) |
| 31425 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 31430 | yapp driver | TX pkt #58 accepted by the DUT |
| 31430 | yapp driver | TX pkt #59: addr=0 len=63 parity=good delay=0 |
| 31435 | **DUT** | IN  pkt #59 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 48) |
| 32075 | **DUT** | IN  pkt #59 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 32075 | yapp monitor | RX pkt #59 on the input: addr=0 len=63 parity=good gap=0 |
| 32075 | reference | Packet dropped: length 63 > maxpktsize 48 (addr=0) |
| 32075 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 32080 | yapp driver | TX pkt #59 accepted by the DUT |
| 32080 | **test** | STAGE: burst 4/5 sent: addr0..3 3/6/2/3, bad parity 1, gap 0 6, length 1..63 |
| 32100 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 32105 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 32105 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 32105 | reference | maxpktsize is now 63 |
| 32120 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 32125 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 32125 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 32125 | reference | router_en is now 0 (en_reg 0xfe) |
| 32150 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 32155 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 32180 | hbus driver | Executed READ  addr=0x1005 data=0x0a |
| 32185 | hbus monitor | Collected READ  addr=0x1005 data=0x0a |
| 32200 | hbus driver | Executed WRITE addr=0x11be data=0x31 |
| 32205 | hbus monitor | Collected WRITE addr=0x11be data=0x31 |
| 32230 | hbus driver | Executed READ  addr=0x11be data=0x31 |
| 32235 | hbus monitor | Collected READ  addr=0x11be data=0x31 |
| 32250 | hbus driver | Executed WRITE addr=0x1194 data=0xd7 |
| 32255 | hbus monitor | Collected WRITE addr=0x1194 data=0xd7 |
| 32280 | hbus driver | Executed READ  addr=0x1194 data=0xd7 |
| 32285 | hbus monitor | Collected READ  addr=0x1194 data=0xd7 |
| 32300 | hbus driver | Executed WRITE addr=0x116b data=0xfe |
| 32305 | hbus monitor | Collected WRITE addr=0x116b data=0xfe |
| 32330 | hbus driver | Executed READ  addr=0x116b data=0xfe |
| 32335 | hbus monitor | Collected READ  addr=0x116b data=0xfe |
| 32350 | hbus driver | Executed WRITE addr=0x119f data=0xb2 |
| 32355 | hbus monitor | Collected WRITE addr=0x119f data=0xb2 |
| 32380 | hbus driver | Executed READ  addr=0x119f data=0xb2 |
| 32385 | hbus monitor | Collected READ  addr=0x119f data=0xb2 |
| 32400 | hbus driver | Executed WRITE addr=0x11bf data=0xb2 |
| 32405 | hbus monitor | Collected WRITE addr=0x11bf data=0xb2 |
| 32430 | hbus driver | Executed READ  addr=0x11bf data=0xb2 |
| 32435 | hbus monitor | Collected READ  addr=0x11bf data=0xb2 |
| 32460 | hbus driver | Executed READ  addr=0x1015 data=0x75 |
| 32465 | hbus monitor | Collected READ  addr=0x1015 data=0x75 |
| 32480 | hbus driver | Executed WRITE addr=0x1145 data=0xc7 |
| 32485 | hbus monitor | Collected WRITE addr=0x1145 data=0xc7 |
| 32510 | hbus driver | Executed READ  addr=0x1145 data=0xc7 |
| 32510 | **test** | STAGE: burst 5/5: ctrl=0x3f (maxpktsize 63) en=0xfe (router OFF, counter enables 1111111), 15 packet(s) |
| 32510 | yapp driver | TX pkt #60: addr=2 len=1 parity=good delay=3 |
| 32515 | hbus monitor | Collected READ  addr=0x1145 data=0xc7 |
| 32555 | **DUT** | IN  pkt #60 header: addr=2 len=1 -> DROP (router disabled) |
| 32575 | **DUT** | IN  pkt #60 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 32575 | yapp monitor | RX pkt #60 on the input: addr=2 len=1 parity=good gap=47 |
| 32575 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 32575 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 32580 | yapp driver | TX pkt #60 accepted by the DUT |
| 32580 | yapp driver | TX pkt #61: addr=2 len=63 parity=good delay=6 |
| 32645 | **DUT** | IN  pkt #61 header: addr=2 len=63 -> DROP (router disabled) |
| 33285 | **DUT** | IN  pkt #61 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 33285 | yapp monitor | RX pkt #61 on the input: addr=2 len=63 parity=good gap=6 |
| 33285 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 33285 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 33290 | yapp driver | TX pkt #61 accepted by the DUT |
| 33290 | yapp driver | TX pkt #62: addr=1 len=63 parity=bad delay=0 |
| 33295 | **DUT** | IN  pkt #62 header: addr=1 len=63 -> DROP (router disabled) |
| 33935 | **DUT** | IN  pkt #62 complete: addr=1 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 33935 | yapp monitor | RX pkt #62 on the input: addr=1 len=63 parity=bad gap=0 |
| 33935 | reference | Packet dropped: router disabled (addr=1 len=63) |
| 33935 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (router disabled) |
| 33940 | yapp driver | TX pkt #62 accepted by the DUT |
| 33940 | yapp driver | TX pkt #63: addr=2 len=21 parity=bad delay=20 |
| 34145 | **DUT** | IN  pkt #63 header: addr=2 len=21 -> DROP (router disabled) |
| 34365 | **DUT** | IN  pkt #63 complete: addr=2 len=21 parity=BAD dropped, 23 bytes in 23 cycles (held 0) |
| 34365 | yapp monitor | RX pkt #63 on the input: addr=2 len=21 parity=bad gap=20 |
| 34365 | reference | Packet dropped: router disabled (addr=2 len=21) |
| 34365 | **DUT** | ROUTER DROPS PACKET addr=2 length=21 (router disabled) |
| 34370 | yapp driver | TX pkt #63 accepted by the DUT |
| 34370 | yapp driver | TX pkt #64: addr=2 len=62 parity=good delay=10 |
| 34475 | **DUT** | IN  pkt #64 header: addr=2 len=62 -> DROP (router disabled) |
| 35105 | **DUT** | IN  pkt #64 complete: addr=2 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 35105 | yapp monitor | RX pkt #64 on the input: addr=2 len=62 parity=good gap=10 |
| 35105 | reference | Packet dropped: router disabled (addr=2 len=62) |
| 35105 | **DUT** | ROUTER DROPS PACKET addr=2 length=62 (router disabled) |
| 35110 | yapp driver | TX pkt #64 accepted by the DUT |
| 35110 | yapp driver | TX pkt #65: addr=1 len=60 parity=good delay=0 |
| 35115 | **DUT** | IN  pkt #65 header: addr=1 len=60 -> DROP (router disabled) |
| 35725 | **DUT** | IN  pkt #65 complete: addr=1 len=60 parity=ok dropped, 62 bytes in 62 cycles (held 0) |
| 35725 | yapp monitor | RX pkt #65 on the input: addr=1 len=60 parity=good gap=0 |
| 35725 | reference | Packet dropped: router disabled (addr=1 len=60) |
| 35725 | **DUT** | ROUTER DROPS PACKET addr=1 length=60 (router disabled) |
| 35730 | yapp driver | TX pkt #65 accepted by the DUT |
| 35730 | yapp driver | TX pkt #66: addr=2 len=63 parity=good delay=9 |
| 35825 | **DUT** | IN  pkt #66 header: addr=2 len=63 -> DROP (router disabled) |
| 36465 | **DUT** | IN  pkt #66 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 36465 | yapp monitor | RX pkt #66 on the input: addr=2 len=63 parity=good gap=9 |
| 36465 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 36465 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 36470 | yapp driver | TX pkt #66 accepted by the DUT |
| 36470 | yapp driver | TX pkt #67: addr=1 len=47 parity=good delay=6 |
| 36535 | **DUT** | IN  pkt #67 header: addr=1 len=47 -> DROP (router disabled) |
| 37015 | **DUT** | IN  pkt #67 complete: addr=1 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 37015 | yapp monitor | RX pkt #67 on the input: addr=1 len=47 parity=good gap=6 |
| 37015 | reference | Packet dropped: router disabled (addr=1 len=47) |
| 37015 | **DUT** | ROUTER DROPS PACKET addr=1 length=47 (router disabled) |
| 37020 | yapp driver | TX pkt #67 accepted by the DUT |
| 37020 | yapp driver | TX pkt #68: addr=0 len=1 parity=bad delay=1 |
| 37035 | **DUT** | IN  pkt #68 header: addr=0 len=1 -> DROP (router disabled) |
| 37055 | **DUT** | IN  pkt #68 complete: addr=0 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 37055 | yapp monitor | RX pkt #68 on the input: addr=0 len=1 parity=bad gap=1 |
| 37055 | reference | Packet dropped: router disabled (addr=0 len=1) |
| 37055 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (router disabled) |
| 37060 | yapp driver | TX pkt #68 accepted by the DUT |
| 37060 | yapp driver | TX pkt #69: addr=1 len=32 parity=good delay=0 |
| 37065 | **DUT** | IN  pkt #69 header: addr=1 len=32 -> DROP (router disabled) |
| 37395 | **DUT** | IN  pkt #69 complete: addr=1 len=32 parity=ok dropped, 34 bytes in 34 cycles (held 0) |
| 37395 | yapp monitor | RX pkt #69 on the input: addr=1 len=32 parity=good gap=0 |
| 37395 | reference | Packet dropped: router disabled (addr=1 len=32) |
| 37395 | **DUT** | ROUTER DROPS PACKET addr=1 length=32 (router disabled) |
| 37400 | yapp driver | TX pkt #69 accepted by the DUT |
| 37400 | yapp driver | TX pkt #70: addr=2 len=63 parity=good delay=0 |
| 37405 | **DUT** | IN  pkt #70 header: addr=2 len=63 -> DROP (router disabled) |
| 38045 | **DUT** | IN  pkt #70 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 38045 | yapp monitor | RX pkt #70 on the input: addr=2 len=63 parity=good gap=0 |
| 38045 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 38045 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 38050 | yapp driver | TX pkt #70 accepted by the DUT |
| 38050 | yapp driver | TX pkt #71: addr=0 len=16 parity=good delay=17 |
| 38225 | **DUT** | IN  pkt #71 header: addr=0 len=16 -> DROP (router disabled) |
| 38395 | **DUT** | IN  pkt #71 complete: addr=0 len=16 parity=ok dropped, 18 bytes in 18 cycles (held 0) |
| 38395 | yapp monitor | RX pkt #71 on the input: addr=0 len=16 parity=good gap=17 |
| 38395 | reference | Packet dropped: router disabled (addr=0 len=16) |
| 38395 | **DUT** | ROUTER DROPS PACKET addr=0 length=16 (router disabled) |
| 38400 | yapp driver | TX pkt #71 accepted by the DUT |
| 38400 | yapp driver | TX pkt #72: addr=0 len=63 parity=good delay=1 |
| 38415 | **DUT** | IN  pkt #72 header: addr=0 len=63 -> DROP (router disabled) |
| 39055 | **DUT** | IN  pkt #72 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 39055 | yapp monitor | RX pkt #72 on the input: addr=0 len=63 parity=good gap=1 |
| 39055 | reference | Packet dropped: router disabled (addr=0 len=63) |
| 39055 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (router disabled) |
| 39060 | yapp driver | TX pkt #72 accepted by the DUT |
| 39060 | yapp driver | TX pkt #73: addr=2 len=63 parity=good delay=20 |
| 39265 | **DUT** | IN  pkt #73 header: addr=2 len=63 -> DROP (router disabled) |
| 39905 | **DUT** | IN  pkt #73 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 39905 | yapp monitor | RX pkt #73 on the input: addr=2 len=63 parity=good gap=20 |
| 39905 | reference | Packet dropped: router disabled (addr=2 len=63) |
| 39905 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (router disabled) |
| 39910 | yapp driver | TX pkt #73 accepted by the DUT |
| 39910 | yapp driver | TX pkt #74: addr=0 len=31 parity=good delay=2 |
| 39935 | **DUT** | IN  pkt #74 header: addr=0 len=31 -> DROP (router disabled) |
| 40255 | **DUT** | IN  pkt #74 complete: addr=0 len=31 parity=ok dropped, 33 bytes in 33 cycles (held 0) |
| 40255 | yapp monitor | RX pkt #74 on the input: addr=0 len=31 parity=good gap=2 |
| 40255 | reference | Packet dropped: router disabled (addr=0 len=31) |
| 40255 | **DUT** | ROUTER DROPS PACKET addr=0 length=31 (router disabled) |
| 40260 | yapp driver | TX pkt #74 accepted by the DUT |
| 40260 | **test** | STAGE: burst 5/5 sent: addr0..3 4/4/7/0, bad parity 3, gap 0 4, length 1..63 |
| 40260 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 40290 | hbus driver | Executed READ  addr=0x1000 data=0x3f |
| 40295 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40320 | hbus driver | Executed READ  addr=0x1001 data=0xfe |
| 40325 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 40350 | hbus driver | Executed READ  addr=0x1004 data=0x04 |
| 40355 | hbus monitor | Collected READ  addr=0x1004 data=0x04 |
| 40380 | hbus driver | Executed READ  addr=0x1005 data=0x0a |
| 40385 | hbus monitor | Collected READ  addr=0x1005 data=0x0a |
| 40410 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 40415 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 40440 | hbus driver | Executed READ  addr=0x1009 data=0x06 |
| 40445 | hbus monitor | Collected READ  addr=0x1009 data=0x06 |
| 40470 | hbus driver | Executed READ  addr=0x100a data=0x09 |
| 40475 | hbus monitor | Collected READ  addr=0x100a data=0x09 |
| 40500 | hbus driver | Executed READ  addr=0x100b data=0x08 |
| 40505 | hbus monitor | Collected READ  addr=0x100b data=0x08 |
| 40530 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 40535 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 40560 | hbus driver | Executed READ  addr=0x1010 data=0xfc |
| 40565 | hbus monitor | Collected READ  addr=0x1010 data=0xfc |
| 40590 | hbus driver | Executed READ  addr=0x1011 data=0xd9 |
| 40595 | hbus monitor | Collected READ  addr=0x1011 data=0xd9 |
| 40620 | hbus driver | Executed READ  addr=0x1012 data=0x31 |
| 40625 | hbus monitor | Collected READ  addr=0x1012 data=0x31 |
| 40650 | hbus driver | Executed READ  addr=0x1013 data=0x3e |
| 40655 | hbus monitor | Collected READ  addr=0x1013 data=0x3e |
| 40680 | hbus driver | Executed READ  addr=0x1014 data=0xe6 |
| 40685 | hbus monitor | Collected READ  addr=0x1014 data=0xe6 |
| 40710 | hbus driver | Executed READ  addr=0x1015 data=0x75 |
| 40715 | hbus monitor | Collected READ  addr=0x1015 data=0x75 |
| 40740 | hbus driver | Executed READ  addr=0x1016 data=0xac |
| 40745 | hbus monitor | Collected READ  addr=0x1016 data=0xac |
| 40770 | hbus driver | Executed READ  addr=0x1017 data=0x4c |
| 40775 | hbus monitor | Collected READ  addr=0x1017 data=0x4c |
| 40800 | hbus driver | Executed READ  addr=0x1018 data=0x52 |
| 40805 | hbus monitor | Collected READ  addr=0x1018 data=0x52 |
| 40830 | hbus driver | Executed READ  addr=0x1019 data=0xa9 |
| 40835 | hbus monitor | Collected READ  addr=0x1019 data=0xa9 |
| 40860 | hbus driver | Executed READ  addr=0x101a data=0x75 |
| 40865 | hbus monitor | Collected READ  addr=0x101a data=0x75 |
| 40890 | hbus driver | Executed READ  addr=0x101b data=0x5d |
| 40895 | hbus monitor | Collected READ  addr=0x101b data=0x5d |
| 40920 | hbus driver | Executed READ  addr=0x101c data=0xce |
| 40925 | hbus monitor | Collected READ  addr=0x101c data=0xce |
| 40950 | hbus driver | Executed READ  addr=0x101d data=0x29 |
| 40955 | hbus monitor | Collected READ  addr=0x101d data=0x29 |
| 40980 | hbus driver | Executed READ  addr=0x101e data=0x39 |
| 40985 | hbus monitor | Collected READ  addr=0x101e data=0x39 |
| 41010 | hbus driver | Executed READ  addr=0x101f data=0x29 |
| 41015 | hbus monitor | Collected READ  addr=0x101f data=0x29 |
| 41040 | hbus driver | Executed READ  addr=0x1020 data=0x80 |
| 41045 | hbus monitor | Collected READ  addr=0x1020 data=0x80 |
| 41070 | hbus driver | Executed READ  addr=0x1021 data=0x5a |
| 41075 | hbus monitor | Collected READ  addr=0x1021 data=0x5a |
| 41100 | hbus driver | Executed READ  addr=0x1022 data=0x8b |
| 41105 | hbus monitor | Collected READ  addr=0x1022 data=0x8b |
| 41130 | hbus driver | Executed READ  addr=0x1023 data=0x68 |
| 41135 | hbus monitor | Collected READ  addr=0x1023 data=0x68 |
| 41160 | hbus driver | Executed READ  addr=0x1024 data=0x7c |
| 41165 | hbus monitor | Collected READ  addr=0x1024 data=0x7c |
| 41190 | hbus driver | Executed READ  addr=0x1025 data=0x45 |
| 41195 | hbus monitor | Collected READ  addr=0x1025 data=0x45 |
| 41220 | hbus driver | Executed READ  addr=0x1026 data=0x43 |
| 41225 | hbus monitor | Collected READ  addr=0x1026 data=0x43 |
| 41250 | hbus driver | Executed READ  addr=0x1027 data=0xdd |
| 41255 | hbus monitor | Collected READ  addr=0x1027 data=0xdd |
| 41280 | hbus driver | Executed READ  addr=0x1028 data=0xe1 |
| 41285 | hbus monitor | Collected READ  addr=0x1028 data=0xe1 |
| 41310 | hbus driver | Executed READ  addr=0x1029 data=0x59 |
| 41315 | hbus monitor | Collected READ  addr=0x1029 data=0x59 |
| 41340 | hbus driver | Executed READ  addr=0x102a data=0x3c |
| 41345 | hbus monitor | Collected READ  addr=0x102a data=0x3c |
| 41370 | hbus driver | Executed READ  addr=0x102b data=0xcc |
| 41375 | hbus monitor | Collected READ  addr=0x102b data=0xcc |
| 41400 | hbus driver | Executed READ  addr=0x102c data=0xf9 |
| 41405 | hbus monitor | Collected READ  addr=0x102c data=0xf9 |
| 41430 | hbus driver | Executed READ  addr=0x102d data=0xe5 |
| 41435 | hbus monitor | Collected READ  addr=0x102d data=0xe5 |
| 41460 | hbus driver | Executed READ  addr=0x102e data=0x3a |
| 41465 | hbus monitor | Collected READ  addr=0x102e data=0x3a |
| 41490 | hbus driver | Executed READ  addr=0x102f data=0x25 |
| 41495 | hbus monitor | Collected READ  addr=0x102f data=0x25 |
| 41520 | hbus driver | Executed READ  addr=0x1030 data=0x1d |
| 41525 | hbus monitor | Collected READ  addr=0x1030 data=0x1d |
| 41550 | hbus driver | Executed READ  addr=0x1031 data=0x6d |
| 41555 | hbus monitor | Collected READ  addr=0x1031 data=0x6d |
| 41580 | hbus driver | Executed READ  addr=0x1032 data=0x67 |
| 41585 | hbus monitor | Collected READ  addr=0x1032 data=0x67 |
| 41610 | hbus driver | Executed READ  addr=0x1033 data=0x36 |
| 41615 | hbus monitor | Collected READ  addr=0x1033 data=0x36 |
| 41640 | hbus driver | Executed READ  addr=0x1034 data=0xf2 |
| 41645 | hbus monitor | Collected READ  addr=0x1034 data=0xf2 |
| 41670 | hbus driver | Executed READ  addr=0x1035 data=0xea |
| 41675 | hbus monitor | Collected READ  addr=0x1035 data=0xea |
| 41700 | hbus driver | Executed READ  addr=0x1036 data=0x4d |
| 41705 | hbus monitor | Collected READ  addr=0x1036 data=0x4d |
| 41730 | hbus driver | Executed READ  addr=0x1037 data=0xa7 |
| 41735 | hbus monitor | Collected READ  addr=0x1037 data=0xa7 |
| 41760 | hbus driver | Executed READ  addr=0x1038 data=0x49 |
| 41765 | hbus monitor | Collected READ  addr=0x1038 data=0x49 |
| 41790 | hbus driver | Executed READ  addr=0x1039 data=0x70 |
| 41795 | hbus monitor | Collected READ  addr=0x1039 data=0x70 |
| 41820 | hbus driver | Executed READ  addr=0x103a data=0x4b |
| 41825 | hbus monitor | Collected READ  addr=0x103a data=0x4b |
| 41850 | hbus driver | Executed READ  addr=0x103b data=0x74 |
| 41855 | hbus monitor | Collected READ  addr=0x103b data=0x74 |
| 41880 | hbus driver | Executed READ  addr=0x103c data=0x74 |
| 41885 | hbus monitor | Collected READ  addr=0x103c data=0x74 |
| 41910 | hbus driver | Executed READ  addr=0x103d data=0xf7 |
| 41915 | hbus monitor | Collected READ  addr=0x103d data=0xf7 |
| 41940 | hbus driver | Executed READ  addr=0x103e data=0x31 |
| 41945 | hbus monitor | Collected READ  addr=0x103e data=0x31 |
| 41970 | hbus driver | Executed READ  addr=0x103f data=0x39 |
| 41975 | hbus monitor | Collected READ  addr=0x103f data=0x39 |
| 42000 | hbus driver | Executed READ  addr=0x1040 data=0xd4 |
| 42005 | hbus monitor | Collected READ  addr=0x1040 data=0xd4 |
| 42030 | hbus driver | Executed READ  addr=0x1041 data=0xd8 |
| 42035 | hbus monitor | Collected READ  addr=0x1041 data=0xd8 |
| 42060 | hbus driver | Executed READ  addr=0x1042 data=0x6a |
| 42065 | hbus monitor | Collected READ  addr=0x1042 data=0x6a |
| 42090 | hbus driver | Executed READ  addr=0x1043 data=0x42 |
| 42095 | hbus monitor | Collected READ  addr=0x1043 data=0x42 |
| 42120 | hbus driver | Executed READ  addr=0x1044 data=0x1b |
| 42125 | hbus monitor | Collected READ  addr=0x1044 data=0x1b |
| 42150 | hbus driver | Executed READ  addr=0x1045 data=0xca |
| 42155 | hbus monitor | Collected READ  addr=0x1045 data=0xca |
| 42180 | hbus driver | Executed READ  addr=0x1046 data=0x94 |
| 42185 | hbus monitor | Collected READ  addr=0x1046 data=0x94 |
| 42210 | hbus driver | Executed READ  addr=0x1047 data=0x15 |
| 42215 | hbus monitor | Collected READ  addr=0x1047 data=0x15 |
| 42240 | hbus driver | Executed READ  addr=0x1048 data=0xef |
| 42245 | hbus monitor | Collected READ  addr=0x1048 data=0xef |
| 42270 | hbus driver | Executed READ  addr=0x1049 data=0xb0 |
| 42275 | hbus monitor | Collected READ  addr=0x1049 data=0xb0 |
| 42300 | hbus driver | Executed READ  addr=0x104a data=0x80 |
| 42305 | hbus monitor | Collected READ  addr=0x104a data=0x80 |
| 42330 | hbus driver | Executed READ  addr=0x104b data=0x99 |
| 42335 | hbus monitor | Collected READ  addr=0x104b data=0x99 |
| 42360 | hbus driver | Executed READ  addr=0x104c data=0xe9 |
| 42365 | hbus monitor | Collected READ  addr=0x104c data=0xe9 |
| 42390 | hbus driver | Executed READ  addr=0x104d data=0x4e |
| 42395 | hbus monitor | Collected READ  addr=0x104d data=0x4e |
| 42420 | hbus driver | Executed READ  addr=0x104e data=0x89 |
| 42425 | hbus monitor | Collected READ  addr=0x104e data=0x89 |
| 42450 | hbus driver | Executed READ  addr=0x104f data=0xe1 |
| 42455 | hbus monitor | Collected READ  addr=0x104f data=0xe1 |
| 42565 | **test** | STAGE: done: 74 packets (15 forwarded, 59 dropped), 0 storm burst(s), 15 scoreboard matches, 111 HBUS reads checked, 11 error pulses for 11 bad packets |
| 42765 | error checker | error pulse report: 11 bad packets, 11 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 42765 | ch0 monitor | Channel 0 report: 3 packets collected |
| 42765 | ch1 monitor | Channel 1 report: 5 packets collected |
| 42765 | ch2 monitor | Channel 2 report: 7 packets collected |
| 42765 | hbus monitor | HBUS report: 31 writes, 113 reads |
| 42765 | coverage | Coverage of the router configuration: 82.6% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 16 / 0 / 28 / 15 / 0 packets · length < max / = max / max+1 / > max+1 : 15 / 3 / 15 / 26 · forwarded good / bad : 13 / 2 · dropped address 3 good / bad : 8 / 0 · dropped oversized good / bad : 27 / 9 · counter enables none / mixed / all : 16 / 43 / 0 |
| 42765 | coverage | HBUS address coverage: 144 accesses sampled, coverage 51.9% |
| 42765 | coverage | HBUS register bits coverage: 10 writes to ctrl_reg/en_reg, coverage 97.7% |
| 42765 | coverage | HBUS counter value coverage: 12 counter reads sampled, coverage 59.3% |
| 42765 | coverage | HBUS yapp_mem data coverage: 42 accesses sampled, coverage 29.4% |
| 42765 | reference | --- Reference model report --- · forwarded to scoreboard : 15 · dropped (router disabled) : 15 · dropped (oversized) : 36 · dropped (address 3) : 8 · counters parity/oversized/addr0..3 : 4 / 10 / 6 9 8 2 |
| 42765 | reference | HBUS reads checked against the model: 111 (0 mismatches, 2 of memory bytes never written) |
| 42765 | scoreboard | --- Scoreboard report --- · packets received : 15 · packets matched : 15 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 42765 | yapp driver | YAPP driver report: 74 packets sent |
| 42765 | coverage | YAPP gap coverage: 73 gaps sampled, coverage 100.0% |
| 42765 | yapp monitor | YAPP monitor report: 74 packets collected, 14 with bad parity |
| 42765 | yapp monitor | YAPP gaps: 17 back to back, 10 of 1 cycle, 3 of 2, 43 longer |
| 42765 | coverage | YAPP packet coverage: 74 packets sampled, coverage 76.7% |
