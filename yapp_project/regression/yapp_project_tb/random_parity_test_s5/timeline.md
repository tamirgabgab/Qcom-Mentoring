# random_parity_test seed 5

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 16us · wall 11.9 s · log [`random_parity_test_s5.log`](random_parity_test_s5.log)

Waves: `random_parity_test_s5.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s5%2Frandom_parity_test_s5.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **36** packet(s) (17 with bad parity); the input monitor saw 36.
- Router: **6** forwarded, **30** dropped (20 oversized, 1 illegal address 3, 9 router disabled).
- Packets out: ch0 **2**, ch1 **3**, ch2 **1**.
- Scoreboard: 6 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 14.
- HBUS: 23 write(s), 102 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 36 packets in 4 bursts |
| 340 | burst 1/4: ctrl=0xe8 (maxpktsize 40) en=0xff (router on, counter enables 1111111), 9 packet(s) |
| 4760 | burst 1/4 sent: addr0..3 3/3/1/2, bad parity 3, gap 0 3, length 1..63 |
| 5120 | burst 2/4: ctrl=0x01 (maxpktsize 1) en=0x63 (router on, counter enables 0110001), 9 packet(s) |
| 7600 | burst 2/4 sent: addr0..3 1/1/5/2, bad parity 6, gap 0 4, length 1..60 |
| 7940 | burst 3/4: ctrl=0xda (maxpktsize 26) en=0xc8 (router OFF, counter enables 1100100), 9 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 8270 | burst 3/4 sent: addr0..3 0/1/5/3, bad parity 3, gap 0 8, length 1..3 |
| 8610 | burst 4/4: ctrl=0x40 (maxpktsize 0) en=0x27 (router on, counter enables 0010011), 9 packet(s) |
| 13280 | burst 4/4 sent: addr0..3 1/1/4/3, bad parity 5, gap 0 4, length 1..63 |
| 13280 | final reads: every register and the stored packet, checked against the reference model |
| 15585 | done: 36 packets (6 forwarded, 30 dropped), 1 storm burst(s), 6 scoreboard matches, 101 HBUS reads checked, 14 error pulses for 14 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 1**

![first packet out on channel 1](wave_first_packet_out.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

608 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 36 packets in 4 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0xe8 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=40 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0xe8 |
| 75 | reference | maxpktsize is now 40 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x1000 data=0xe8 |
| 125 | hbus monitor | Collected READ  addr=0x1000 data=0xe8 |
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
| 340 | **test** | STAGE: burst 1/4: ctrl=0xe8 (maxpktsize 40) en=0xff (router on, counter enables 1111111), 9 packet(s) |
| 340 | yapp driver | TX pkt #1: addr=3 len=63 parity=good delay=1 |
| 345 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 365 | **DUT** | IN  pkt #1 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 40) |
| 1005 | **DUT** | IN  pkt #1 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1005 | yapp monitor | RX pkt #1 on the input: addr=3 len=63 parity=good gap=31 |
| 1005 | reference | Packet dropped: illegal address 3 (len=63) |
| 1005 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1010 | yapp driver | TX pkt #1 accepted by the DUT |
| 1010 | yapp driver | TX pkt #2: addr=3 len=63 parity=good delay=12 |
| 1135 | **DUT** | IN  pkt #2 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 40) |
| 1775 | **DUT** | IN  pkt #2 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1775 | yapp monitor | RX pkt #2 on the input: addr=3 len=63 parity=good gap=12 |
| 1775 | reference | Packet dropped: illegal address 3 (len=63) |
| 1775 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1780 | yapp driver | TX pkt #2 accepted by the DUT |
| 1780 | yapp driver | TX pkt #3: addr=0 len=41 parity=bad delay=1 |
| 1795 | **DUT** | IN  pkt #3 header: addr=0 len=41 -> DROP (oversized: len 41 > maxpktsize 40) |
| 2215 | **DUT** | IN  pkt #3 complete: addr=0 len=41 parity=BAD dropped, 43 bytes in 43 cycles (held 0) |
| 2215 | yapp monitor | RX pkt #3 on the input: addr=0 len=41 parity=bad gap=1 |
| 2215 | reference | Packet dropped: length 41 > maxpktsize 40 (addr=0) |
| 2215 | **DUT** | ROUTER DROPS PACKET addr=0 length=41 (length > maxpktsize) |
| 2220 | yapp driver | TX pkt #3 accepted by the DUT |
| 2220 | yapp driver | TX pkt #4: addr=1 len=22 parity=bad delay=12 |
| 2310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 2310 | error checker | error pulse 9 cycles after the bad packet (0 still owed) |
| 2345 | **DUT** | IN  pkt #4 header: addr=1 len=22 -> channel 1 |
| 2445 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=22 (receiver waited 9 cycle(s)) |
| 2575 | **DUT** | IN  pkt #4 complete: addr=1 len=22 parity=BAD forwarded, 24 bytes in 24 cycles (held 0) |
| 2575 | yapp monitor | RX pkt #4 on the input: addr=1 len=22 parity=bad gap=12 |
| 2575 | reference | Packet forwarded: addr=1 len=22 -> channel 1 |
| 2580 | yapp driver | TX pkt #4 accepted by the DUT |
| 2580 | yapp driver | TX pkt #5: addr=2 len=58 parity=good delay=0 |
| 2585 | **DUT** | IN  pkt #5 header: addr=2 len=58 -> DROP (oversized: len 58 > maxpktsize 40) |
| 2610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 2610 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 2670 | ch1 driver | ch1: packet consumed (response delay 9) |
| 2715 | **DUT** | OUT ch1 pkt #1 done: 24 bytes in 28 cycles |
| 2715 | ch1 monitor | ch1 RX pkt #1: addr=1 len=22 parity=bad |
| 2715 | scoreboard | ch1 pkt matched: addr=1 len=22 (1 matched so far) |
| 2900 | ch1 driver | ch1: packet consumed (response delay 3) |
| 3175 | **DUT** | IN  pkt #5 complete: addr=2 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 3175 | yapp monitor | RX pkt #5 on the input: addr=2 len=58 parity=good gap=0 |
| 3175 | reference | Packet dropped: length 58 > maxpktsize 40 (addr=2) |
| 3175 | **DUT** | ROUTER DROPS PACKET addr=2 length=58 (length > maxpktsize) |
| 3180 | yapp driver | TX pkt #5 accepted by the DUT |
| 3180 | yapp driver | TX pkt #6: addr=0 len=46 parity=good delay=0 |
| 3185 | **DUT** | IN  pkt #6 header: addr=0 len=46 -> DROP (oversized: len 46 > maxpktsize 40) |
| 3655 | **DUT** | IN  pkt #6 complete: addr=0 len=46 parity=ok dropped, 48 bytes in 48 cycles (held 0) |
| 3655 | yapp monitor | RX pkt #6 on the input: addr=0 len=46 parity=good gap=0 |
| 3655 | reference | Packet dropped: length 46 > maxpktsize 40 (addr=0) |
| 3655 | **DUT** | ROUTER DROPS PACKET addr=0 length=46 (length > maxpktsize) |
| 3660 | yapp driver | TX pkt #6 accepted by the DUT |
| 3660 | yapp driver | TX pkt #7: addr=1 len=54 parity=good delay=0 |
| 3665 | **DUT** | IN  pkt #7 header: addr=1 len=54 -> DROP (oversized: len 54 > maxpktsize 40) |
| 4215 | **DUT** | IN  pkt #7 complete: addr=1 len=54 parity=ok dropped, 56 bytes in 56 cycles (held 0) |
| 4215 | yapp monitor | RX pkt #7 on the input: addr=1 len=54 parity=good gap=0 |
| 4215 | reference | Packet dropped: length 54 > maxpktsize 40 (addr=1) |
| 4215 | **DUT** | ROUTER DROPS PACKET addr=1 length=54 (length > maxpktsize) |
| 4220 | yapp driver | TX pkt #7 accepted by the DUT |
| 4220 | yapp driver | TX pkt #8: addr=1 len=1 parity=bad delay=1 |
| 4235 | **DUT** | IN  pkt #8 header: addr=1 len=1 -> channel 1 |
| 4255 | **DUT** | IN  pkt #8 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 4255 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=1 (receiver waited 1 cycle(s)) |
| 4255 | yapp monitor | RX pkt #8 on the input: addr=1 len=1 parity=bad gap=1 |
| 4255 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 4260 | yapp driver | TX pkt #8 accepted by the DUT |
| 4260 | yapp driver | TX pkt #9: addr=0 len=40 parity=good delay=8 |
| 4270 | ch1 driver | ch1: packet consumed (response delay 1) |
| 4285 | **DUT** | OUT ch1 pkt #2 done: 3 bytes in 4 cycles |
| 4285 | ch1 monitor | ch1 RX pkt #2: addr=1 len=1 parity=bad |
| 4285 | scoreboard | ch1 pkt matched: addr=1 len=1 (2 matched so far) |
| 4310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 4310 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 4345 | **DUT** | IN  pkt #9 header: addr=0 len=40 -> channel 0 |
| 4350 | ch1 driver | ch1: packet consumed (response delay 0) |
| 4355 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=40 (receiver waited 0 cycle(s)) |
| 4755 | **DUT** | IN  pkt #9 complete: addr=0 len=40 parity=ok forwarded, 42 bytes in 42 cycles (held 0) |
| 4755 | yapp monitor | RX pkt #9 on the input: addr=0 len=40 parity=good gap=8 |
| 4755 | reference | Packet forwarded: addr=0 len=40 -> channel 0 |
| 4760 | ch0 driver | ch0: packet consumed (response delay 0) |
| 4760 | yapp driver | TX pkt #9 accepted by the DUT |
| 4760 | **test** | STAGE: burst 1/4 sent: addr0..3 3/3/1/2, bad parity 3, gap 0 3, length 1..63 |
| 4775 | **DUT** | OUT ch0 pkt #1 done: 42 bytes in 43 cycles |
| 4775 | ch0 monitor | ch0 RX pkt #1: addr=0 len=40 parity=good |
| 4775 | scoreboard | ch0 pkt matched: addr=0 len=40 (3 matched so far) |
| 4780 | hbus driver | Executed WRITE addr=0x1000 data=0x01 |
| 4785 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 4785 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 4785 | reference | maxpktsize is now 1 |
| 4800 | hbus driver | Executed WRITE addr=0x1001 data=0x63 |
| 4805 | hbus monitor | Collected WRITE addr=0x1001 data=0x63 |
| 4805 | reference | router_en is now 1 (en_reg 0x63) |
| 4830 | hbus driver | Executed READ  addr=0x1008 data=0x00 |
| 4835 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4860 | hbus driver | Executed READ  addr=0x1023 data=0x0f |
| 4865 | hbus monitor | Collected READ  addr=0x1023 data=0x0f |
| 4880 | hbus driver | Executed WRITE addr=0x117b data=0xbe |
| 4885 | hbus monitor | Collected WRITE addr=0x117b data=0xbe |
| 4910 | hbus driver | Executed READ  addr=0x117b data=0xbe |
| 4915 | hbus monitor | Collected READ  addr=0x117b data=0xbe |
| 4930 | hbus driver | Executed WRITE addr=0x11e9 data=0x45 |
| 4935 | hbus monitor | Collected WRITE addr=0x11e9 data=0x45 |
| 4960 | hbus driver | Executed READ  addr=0x11e9 data=0x45 |
| 4965 | hbus monitor | Collected READ  addr=0x11e9 data=0x45 |
| 4980 | hbus driver | Executed WRITE addr=0x1105 data=0xdc |
| 4985 | hbus monitor | Collected WRITE addr=0x1105 data=0xdc |
| 5010 | hbus driver | Executed READ  addr=0x1105 data=0xdc |
| 5015 | hbus monitor | Collected READ  addr=0x1105 data=0xdc |
| 5030 | hbus driver | Executed WRITE addr=0x1100 data=0x75 |
| 5035 | hbus monitor | Collected WRITE addr=0x1100 data=0x75 |
| 5060 | hbus driver | Executed READ  addr=0x1100 data=0x75 |
| 5065 | hbus monitor | Collected READ  addr=0x1100 data=0x75 |
| 5090 | hbus driver | Executed READ  addr=0x10f0 data=0x00 |
| 5095 | hbus monitor | Collected READ  addr=0x10f0 data=0x00 |
| 5120 | hbus driver | Executed READ  addr=0x100c data=0x00 |
| 5120 | **test** | STAGE: burst 2/4: ctrl=0x01 (maxpktsize 1) en=0x63 (router on, counter enables 0110001), 9 packet(s) |
| 5120 | yapp driver | TX pkt #10: addr=2 len=60 parity=bad delay=0 |
| 5125 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5135 | **DUT** | IN  pkt #10 header: addr=2 len=60 -> DROP (oversized: len 60 > maxpktsize 1) |
| 5240 | ch0 driver | ch0: packet consumed (response delay 0) |
| 5745 | **DUT** | IN  pkt #10 complete: addr=2 len=60 parity=BAD dropped, 62 bytes in 62 cycles (held 0) |
| 5745 | yapp monitor | RX pkt #10 on the input: addr=2 len=60 parity=bad gap=37 |
| 5745 | reference | Packet dropped: length 60 > maxpktsize 1 (addr=2) |
| 5745 | **DUT** | ROUTER DROPS PACKET addr=2 length=60 (length > maxpktsize) |
| 5750 | yapp driver | TX pkt #10 accepted by the DUT |
| 5750 | yapp driver | TX pkt #11: addr=1 len=1 parity=bad delay=0 |
| 5755 | **DUT** | IN  pkt #11 header: addr=1 len=1 -> channel 1 |
| 5775 | **DUT** | IN  pkt #11 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 5775 | yapp monitor | RX pkt #11 on the input: addr=1 len=1 parity=bad gap=0 |
| 5775 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 5780 | yapp driver | TX pkt #11 accepted by the DUT |
| 5780 | yapp driver | TX pkt #12: addr=3 len=52 parity=good delay=0 |
| 5785 | **DUT** | IN  pkt #12 header: addr=3 len=52 -> DROP (oversized: len 52 > maxpktsize 1) |
| 5810 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 5810 | error checker | error pulse 6 cycles after the bad packet (1 still owed) |
| 5815 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 5 cycle(s)) |
| 5830 | ch1 driver | ch1: packet consumed (response delay 5) |
| 5850 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 5850 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 5945 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 14 cycles |
| 5945 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=bad |
| 5945 | scoreboard | ch1 pkt matched: addr=1 len=1 (4 matched so far) |
| 6120 | ch1 driver | ch1: packet consumed (response delay 10) |
| 6315 | **DUT** | IN  pkt #12 complete: addr=3 len=52 parity=ok dropped, 54 bytes in 54 cycles (held 0) |
| 6315 | yapp monitor | RX pkt #12 on the input: addr=3 len=52 parity=good gap=0 |
| 6315 | reference | Packet dropped: illegal address 3 (len=52) |
| 6315 | **DUT** | ROUTER DROPS PACKET addr=3 length=52 (    illegal address) |
| 6320 | yapp driver | TX pkt #12 accepted by the DUT |
| 6320 | yapp driver | TX pkt #13: addr=2 len=14 parity=bad delay=3 |
| 6355 | **DUT** | IN  pkt #13 header: addr=2 len=14 -> DROP (oversized: len 14 > maxpktsize 1) |
| 6505 | **DUT** | IN  pkt #13 complete: addr=2 len=14 parity=BAD dropped, 16 bytes in 16 cycles (held 0) |
| 6505 | yapp monitor | RX pkt #13 on the input: addr=2 len=14 parity=bad gap=3 |
| 6505 | reference | Packet dropped: length 14 > maxpktsize 1 (addr=2) |
| 6505 | **DUT** | ROUTER DROPS PACKET addr=2 length=14 (length > maxpktsize) |
| 6510 | yapp driver | TX pkt #13 accepted by the DUT |
| 6510 | yapp driver | TX pkt #14: addr=2 len=55 parity=bad delay=18 |
| 6570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 6570 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 6695 | **DUT** | IN  pkt #14 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 1) |
| 7255 | **DUT** | IN  pkt #14 complete: addr=2 len=55 parity=BAD dropped, 57 bytes in 57 cycles (held 0) |
| 7255 | yapp monitor | RX pkt #14 on the input: addr=2 len=55 parity=bad gap=18 |
| 7255 | reference | Packet dropped: length 55 > maxpktsize 1 (addr=2) |
| 7255 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 7260 | yapp driver | TX pkt #14 accepted by the DUT |
| 7260 | yapp driver | TX pkt #15: addr=2 len=4 parity=bad delay=7 |
| 7270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 7270 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 7335 | **DUT** | IN  pkt #15 header: addr=2 len=4 -> DROP (oversized: len 4 > maxpktsize 1) |
| 7385 | **DUT** | IN  pkt #15 complete: addr=2 len=4 parity=BAD dropped, 6 bytes in 6 cycles (held 0) |
| 7385 | yapp monitor | RX pkt #15 on the input: addr=2 len=4 parity=bad gap=7 |
| 7385 | reference | Packet dropped: length 4 > maxpktsize 1 (addr=2) |
| 7385 | **DUT** | ROUTER DROPS PACKET addr=2 length=4 (length > maxpktsize) |
| 7390 | yapp driver | TX pkt #15 accepted by the DUT |
| 7390 | yapp driver | TX pkt #16: addr=3 len=1 parity=good delay=1 |
| 7405 | **DUT** | IN  pkt #16 header: addr=3 len=1 -> DROP (illegal address 3) |
| 7425 | **DUT** | IN  pkt #16 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 7425 | yapp monitor | RX pkt #16 on the input: addr=3 len=1 parity=good gap=1 |
| 7425 | reference | Packet dropped: illegal address 3 (len=1) |
| 7425 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 7430 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 7430 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 7430 | yapp driver | TX pkt #16 accepted by the DUT |
| 7430 | yapp driver | TX pkt #17: addr=0 len=1 parity=bad delay=11 |
| 7545 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 7555 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7565 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 7565 | yapp monitor | RX pkt #17 on the input: addr=0 len=1 parity=bad gap=11 |
| 7565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7570 | ch0 driver | ch0: packet consumed (response delay 0) |
| 7570 | yapp driver | TX pkt #17 accepted by the DUT |
| 7570 | yapp driver | TX pkt #18: addr=2 len=1 parity=good delay=0 |
| 7575 | **DUT** | IN  pkt #18 header: addr=2 len=1 -> channel 2 |
| 7585 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 4 cycles |
| 7585 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 7585 | ch0 monitor | ch0 RX pkt #2: addr=0 len=1 parity=bad |
| 7585 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 7595 | **DUT** | IN  pkt #18 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7595 | yapp monitor | RX pkt #18 on the input: addr=2 len=1 parity=good gap=0 |
| 7595 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 7600 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7600 | yapp driver | TX pkt #18 accepted by the DUT |
| 7600 | **test** | STAGE: burst 2/4 sent: addr0..3 1/1/5/2, bad parity 6, gap 0 4, length 1..60 |
| 7615 | **DUT** | OUT ch2 pkt #1 done: 3 bytes in 4 cycles |
| 7615 | ch2 monitor | ch2 RX pkt #1: addr=2 len=1 parity=good |
| 7615 | scoreboard | ch2 pkt matched: addr=2 len=1 (6 matched so far) |
| 7620 | hbus driver | Executed WRITE addr=0x1000 data=0xda |
| 7625 | **DUT** | CONFIG router_en=1 maxpktsize=26 |
| 7625 | hbus monitor | Collected WRITE addr=0x1000 data=0xda |
| 7625 | reference | maxpktsize is now 26 |
| 7630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 7630 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 7640 | hbus driver | Executed WRITE addr=0x1001 data=0xc8 |
| 7645 | **DUT** | CONFIG router_en=0 maxpktsize=26 |
| 7645 | hbus monitor | Collected WRITE addr=0x1001 data=0xc8 |
| 7645 | reference | router_en is now 0 (en_reg 0xc8) |
| 7660 | hbus driver | Executed WRITE addr=0x11e5 data=0x89 |
| 7665 | hbus monitor | Collected WRITE addr=0x11e5 data=0x89 |
| 7690 | hbus driver | Executed READ  addr=0x11e5 data=0x89 |
| 7695 | hbus monitor | Collected READ  addr=0x11e5 data=0x89 |
| 7710 | hbus driver | Executed WRITE addr=0x11b6 data=0x9a |
| 7715 | hbus monitor | Collected WRITE addr=0x11b6 data=0x9a |
| 7740 | hbus driver | Executed READ  addr=0x11b6 data=0x9a |
| 7745 | hbus monitor | Collected READ  addr=0x11b6 data=0x9a |
| 7760 | hbus driver | Executed WRITE addr=0x113a data=0x6e |
| 7765 | hbus monitor | Collected WRITE addr=0x113a data=0x6e |
| 7790 | hbus driver | Executed READ  addr=0x113a data=0x6e |
| 7795 | hbus monitor | Collected READ  addr=0x113a data=0x6e |
| 7810 | hbus driver | Executed WRITE addr=0x11b9 data=0x6f |
| 7815 | hbus monitor | Collected WRITE addr=0x11b9 data=0x6f |
| 7830 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7840 | hbus driver | Executed READ  addr=0x11b9 data=0x6f |
| 7845 | hbus monitor | Collected READ  addr=0x11b9 data=0x6f |
| 7860 | hbus driver | Executed WRITE addr=0x1119 data=0x7c |
| 7865 | hbus monitor | Collected WRITE addr=0x1119 data=0x7c |
| 7890 | hbus driver | Executed READ  addr=0x1119 data=0x7c |
| 7895 | hbus monitor | Collected READ  addr=0x1119 data=0x7c |
| 7910 | hbus driver | Executed WRITE addr=0x1102 data=0xba |
| 7915 | hbus monitor | Collected WRITE addr=0x1102 data=0xba |
| 7940 | hbus driver | Executed READ  addr=0x1102 data=0xba |
| 7940 | **test** | STAGE: burst 3/4: ctrl=0xda (maxpktsize 26) en=0xc8 (router OFF, counter enables 1100100), 9 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 7940 | yapp driver | TX pkt #19: addr=2 len=1 parity=bad delay=0 |
| 7945 | hbus monitor | Collected READ  addr=0x1102 data=0xba |
| 7955 | **DUT** | IN  pkt #19 header: addr=2 len=1 -> DROP (router disabled) |
| 7975 | **DUT** | IN  pkt #19 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 7975 | yapp monitor | RX pkt #19 on the input: addr=2 len=1 parity=bad gap=35 |
| 7975 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 7975 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 7980 | yapp driver | TX pkt #19 accepted by the DUT |
| 7980 | yapp driver | TX pkt #20: addr=3 len=1 parity=good delay=0 |
| 7985 | **DUT** | IN  pkt #20 header: addr=3 len=1 -> DROP (router disabled) |
| 8005 | **DUT** | IN  pkt #20 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8005 | yapp monitor | RX pkt #20 on the input: addr=3 len=1 parity=good gap=0 |
| 8005 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 8005 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 8010 | yapp driver | TX pkt #20 accepted by the DUT |
| 8010 | yapp driver | TX pkt #21: addr=3 len=1 parity=good delay=0 |
| 8015 | **DUT** | IN  pkt #21 header: addr=3 len=1 -> DROP (router disabled) |
| 8035 | **DUT** | IN  pkt #21 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8035 | yapp monitor | RX pkt #21 on the input: addr=3 len=1 parity=good gap=0 |
| 8035 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 8035 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 8040 | yapp driver | TX pkt #21 accepted by the DUT |
| 8040 | yapp driver | TX pkt #22: addr=2 len=1 parity=bad delay=0 |
| 8045 | **DUT** | IN  pkt #22 header: addr=2 len=1 -> DROP (router disabled) |
| 8065 | **DUT** | IN  pkt #22 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 8065 | yapp monitor | RX pkt #22 on the input: addr=2 len=1 parity=bad gap=0 |
| 8065 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 8065 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 8070 | yapp driver | TX pkt #22 accepted by the DUT |
| 8070 | yapp driver | TX pkt #23: addr=2 len=2 parity=good delay=0 |
| 8075 | **DUT** | IN  pkt #23 header: addr=2 len=2 -> DROP (router disabled) |
| 8105 | **DUT** | IN  pkt #23 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 8105 | yapp monitor | RX pkt #23 on the input: addr=2 len=2 parity=good gap=0 |
| 8105 | reference | Packet dropped: router disabled (addr=2 len=2) |
| 8105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (router disabled) |
| 8110 | yapp driver | TX pkt #23 accepted by the DUT |
| 8110 | yapp driver | TX pkt #24: addr=3 len=1 parity=good delay=2 |
| 8120 | ch0 driver | ch0: packet consumed (response delay 0) |
| 8135 | **DUT** | IN  pkt #24 header: addr=3 len=1 -> DROP (router disabled) |
| 8155 | **DUT** | IN  pkt #24 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8155 | yapp monitor | RX pkt #24 on the input: addr=3 len=1 parity=good gap=2 |
| 8155 | reference | Packet dropped: router disabled (addr=3 len=1) |
| 8155 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (router disabled) |
| 8160 | yapp driver | TX pkt #24 accepted by the DUT |
| 8160 | yapp driver | TX pkt #25: addr=2 len=1 parity=good delay=0 |
| 8165 | **DUT** | IN  pkt #25 header: addr=2 len=1 -> DROP (router disabled) |
| 8185 | **DUT** | IN  pkt #25 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 8185 | yapp monitor | RX pkt #25 on the input: addr=2 len=1 parity=good gap=0 |
| 8185 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 8185 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 8190 | yapp driver | TX pkt #25 accepted by the DUT |
| 8190 | yapp driver | TX pkt #26: addr=2 len=1 parity=bad delay=0 |
| 8195 | **DUT** | IN  pkt #26 header: addr=2 len=1 -> DROP (router disabled) |
| 8215 | **DUT** | IN  pkt #26 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 8215 | yapp monitor | RX pkt #26 on the input: addr=2 len=1 parity=bad gap=0 |
| 8215 | reference | Packet dropped: router disabled (addr=2 len=1) |
| 8215 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (router disabled) |
| 8220 | yapp driver | TX pkt #26 accepted by the DUT |
| 8220 | yapp driver | TX pkt #27: addr=1 len=3 parity=good delay=0 |
| 8225 | **DUT** | IN  pkt #27 header: addr=1 len=3 -> DROP (router disabled) |
| 8265 | **DUT** | IN  pkt #27 complete: addr=1 len=3 parity=ok dropped, 5 bytes in 5 cycles (held 0) |
| 8265 | yapp monitor | RX pkt #27 on the input: addr=1 len=3 parity=good gap=0 |
| 8265 | reference | Packet dropped: router disabled (addr=1 len=3) |
| 8265 | **DUT** | ROUTER DROPS PACKET addr=1 length=3 (router disabled) |
| 8270 | yapp driver | TX pkt #27 accepted by the DUT |
| 8270 | **test** | STAGE: burst 3/4 sent: addr0..3 0/1/5/3, bad parity 3, gap 0 8, length 1..3 |
| 8290 | hbus driver | Executed WRITE addr=0x1000 data=0x40 |
| 8295 | **DUT** | CONFIG router_en=0 maxpktsize=0 |
| 8295 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 8295 | reference | maxpktsize is now 0 |
| 8310 | hbus driver | Executed WRITE addr=0x1001 data=0x27 |
| 8315 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 8315 | hbus monitor | Collected WRITE addr=0x1001 data=0x27 |
| 8315 | reference | router_en is now 1 (en_reg 0x27) |
| 8330 | hbus driver | Executed WRITE addr=0x1105 data=0x49 |
| 8335 | hbus monitor | Collected WRITE addr=0x1105 data=0x49 |
| 8360 | hbus driver | Executed READ  addr=0x1105 data=0x49 |
| 8365 | hbus monitor | Collected READ  addr=0x1105 data=0x49 |
| 8380 | hbus driver | Executed WRITE addr=0x11aa data=0xeb |
| 8385 | hbus monitor | Collected WRITE addr=0x11aa data=0xeb |
| 8410 | hbus driver | Executed READ  addr=0x11aa data=0xeb |
| 8415 | hbus monitor | Collected READ  addr=0x11aa data=0xeb |
| 8430 | hbus driver | Executed WRITE addr=0x119a data=0x1a |
| 8435 | hbus monitor | Collected WRITE addr=0x119a data=0x1a |
| 8460 | hbus driver | Executed READ  addr=0x119a data=0x1a |
| 8465 | hbus monitor | Collected READ  addr=0x119a data=0x1a |
| 8490 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 8495 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8520 | hbus driver | Executed READ  addr=0x10db data=0x00 |
| 8525 | hbus monitor | Collected READ  addr=0x10db data=0x00 |
| 8550 | hbus driver | Executed READ  addr=0x1020 data=0xad |
| 8555 | hbus monitor | Collected READ  addr=0x1020 data=0xad |
| 8580 | hbus driver | Executed READ  addr=0x1005 data=0x06 |
| 8585 | hbus monitor | Collected READ  addr=0x1005 data=0x06 |
| 8610 | hbus driver | Executed READ  addr=0x100f data=0x00 |
| 8610 | **test** | STAGE: burst 4/4: ctrl=0x40 (maxpktsize 0) en=0x27 (router on, counter enables 0010011), 9 packet(s) |
| 8610 | yapp driver | TX pkt #28: addr=3 len=34 parity=bad delay=5 |
| 8615 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8675 | **DUT** | IN  pkt #28 header: addr=3 len=34 -> DROP (oversized: len 34 > maxpktsize 0) |
| 9025 | **DUT** | IN  pkt #28 complete: addr=3 len=34 parity=BAD dropped, 36 bytes in 36 cycles (held 0) |
| 9025 | yapp monitor | RX pkt #28 on the input: addr=3 len=34 parity=bad gap=40 |
| 9025 | reference | Packet dropped: illegal address 3 (len=34) |
| 9025 | **DUT** | ROUTER DROPS PACKET addr=3 length=34 (    illegal address) |
| 9030 | yapp driver | TX pkt #28 accepted by the DUT |
| 9030 | yapp driver | TX pkt #29: addr=2 len=1 parity=bad delay=0 |
| 9035 | **DUT** | IN  pkt #29 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 9050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 9050 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 9055 | **DUT** | IN  pkt #29 complete: addr=2 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 9055 | yapp monitor | RX pkt #29 on the input: addr=2 len=1 parity=bad gap=0 |
| 9055 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 9055 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 9060 | yapp driver | TX pkt #29 accepted by the DUT |
| 9060 | yapp driver | TX pkt #30: addr=2 len=63 parity=good delay=6 |
| 9110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 9110 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 9125 | **DUT** | IN  pkt #30 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 9765 | **DUT** | IN  pkt #30 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 9765 | yapp monitor | RX pkt #30 on the input: addr=2 len=63 parity=good gap=6 |
| 9765 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 9765 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 9770 | yapp driver | TX pkt #30 accepted by the DUT |
| 9770 | yapp driver | TX pkt #31: addr=2 len=63 parity=good delay=0 |
| 9775 | **DUT** | IN  pkt #31 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 10415 | **DUT** | IN  pkt #31 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10415 | yapp monitor | RX pkt #31 on the input: addr=2 len=63 parity=good gap=0 |
| 10415 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=2) |
| 10415 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10420 | yapp driver | TX pkt #31 accepted by the DUT |
| 10420 | yapp driver | TX pkt #32: addr=0 len=58 parity=good delay=1 |
| 10435 | **DUT** | IN  pkt #32 header: addr=0 len=58 -> DROP (oversized: len 58 > maxpktsize 0) |
| 11025 | **DUT** | IN  pkt #32 complete: addr=0 len=58 parity=ok dropped, 60 bytes in 60 cycles (held 0) |
| 11025 | yapp monitor | RX pkt #32 on the input: addr=0 len=58 parity=good gap=1 |
| 11025 | reference | Packet dropped: length 58 > maxpktsize 0 (addr=0) |
| 11025 | **DUT** | ROUTER DROPS PACKET addr=0 length=58 (length > maxpktsize) |
| 11030 | yapp driver | TX pkt #32 accepted by the DUT |
| 11030 | yapp driver | TX pkt #33: addr=2 len=56 parity=bad delay=0 |
| 11035 | **DUT** | IN  pkt #33 header: addr=2 len=56 -> DROP (oversized: len 56 > maxpktsize 0) |
| 11605 | **DUT** | IN  pkt #33 complete: addr=2 len=56 parity=BAD dropped, 58 bytes in 58 cycles (held 0) |
| 11605 | yapp monitor | RX pkt #33 on the input: addr=2 len=56 parity=bad gap=0 |
| 11605 | reference | Packet dropped: length 56 > maxpktsize 0 (addr=2) |
| 11605 | **DUT** | ROUTER DROPS PACKET addr=2 length=56 (length > maxpktsize) |
| 11610 | yapp driver | TX pkt #33 accepted by the DUT |
| 11610 | yapp driver | TX pkt #34: addr=1 len=63 parity=good delay=0 |
| 11615 | **DUT** | IN  pkt #34 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 11650 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 11650 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 12255 | **DUT** | IN  pkt #34 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 12255 | yapp monitor | RX pkt #34 on the input: addr=1 len=63 parity=good gap=0 |
| 12255 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 12255 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 12260 | yapp driver | TX pkt #34 accepted by the DUT |
| 12260 | yapp driver | TX pkt #35: addr=3 len=27 parity=bad delay=5 |
| 12315 | **DUT** | IN  pkt #35 header: addr=3 len=27 -> DROP (oversized: len 27 > maxpktsize 0) |
| 12595 | **DUT** | IN  pkt #35 complete: addr=3 len=27 parity=BAD dropped, 29 bytes in 29 cycles (held 0) |
| 12595 | yapp monitor | RX pkt #35 on the input: addr=3 len=27 parity=bad gap=5 |
| 12595 | reference | Packet dropped: illegal address 3 (len=27) |
| 12595 | **DUT** | ROUTER DROPS PACKET addr=3 length=27 (    illegal address) |
| 12600 | yapp driver | TX pkt #35 accepted by the DUT |
| 12600 | yapp driver | TX pkt #36: addr=3 len=63 parity=bad delay=3 |
| 12635 | **DUT** | IN  pkt #36 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 12670 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 12670 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 13275 | **DUT** | IN  pkt #36 complete: addr=3 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 13275 | yapp monitor | RX pkt #36 on the input: addr=3 len=63 parity=bad gap=3 |
| 13275 | reference | Packet dropped: illegal address 3 (len=63) |
| 13275 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 13280 | yapp driver | TX pkt #36 accepted by the DUT |
| 13280 | **test** | STAGE: burst 4/4 sent: addr0..3 1/1/4/3, bad parity 5, gap 0 4, length 1..63 |
| 13280 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 13290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 13290 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 13310 | hbus driver | Executed READ  addr=0x1000 data=0x40 |
| 13315 | hbus monitor | Collected READ  addr=0x1000 data=0x40 |
| 13340 | hbus driver | Executed READ  addr=0x1001 data=0x27 |
| 13345 | hbus monitor | Collected READ  addr=0x1001 data=0x27 |
| 13370 | hbus driver | Executed READ  addr=0x1004 data=0x0e |
| 13375 | hbus monitor | Collected READ  addr=0x1004 data=0x0e |
| 13400 | hbus driver | Executed READ  addr=0x1005 data=0x0f |
| 13405 | hbus monitor | Collected READ  addr=0x1005 data=0x0f |
| 13430 | hbus driver | Executed READ  addr=0x1006 data=0x02 |
| 13435 | hbus monitor | Collected READ  addr=0x1006 data=0x02 |
| 13460 | hbus driver | Executed READ  addr=0x1009 data=0x03 |
| 13465 | hbus monitor | Collected READ  addr=0x1009 data=0x03 |
| 13490 | hbus driver | Executed READ  addr=0x100a data=0x05 |
| 13495 | hbus monitor | Collected READ  addr=0x100a data=0x05 |
| 13520 | hbus driver | Executed READ  addr=0x100b data=0x06 |
| 13525 | hbus monitor | Collected READ  addr=0x100b data=0x06 |
| 13550 | hbus driver | Executed READ  addr=0x100d data=0x3f |
| 13555 | hbus monitor | Collected READ  addr=0x100d data=0x3f |
| 13580 | hbus driver | Executed READ  addr=0x1010 data=0xff |
| 13585 | hbus monitor | Collected READ  addr=0x1010 data=0xff |
| 13610 | hbus driver | Executed READ  addr=0x1011 data=0x6c |
| 13615 | hbus monitor | Collected READ  addr=0x1011 data=0x6c |
| 13640 | hbus driver | Executed READ  addr=0x1012 data=0xd8 |
| 13645 | hbus monitor | Collected READ  addr=0x1012 data=0xd8 |
| 13670 | hbus driver | Executed READ  addr=0x1013 data=0x9d |
| 13675 | hbus monitor | Collected READ  addr=0x1013 data=0x9d |
| 13700 | hbus driver | Executed READ  addr=0x1014 data=0xf8 |
| 13705 | hbus monitor | Collected READ  addr=0x1014 data=0xf8 |
| 13730 | hbus driver | Executed READ  addr=0x1015 data=0xeb |
| 13735 | hbus monitor | Collected READ  addr=0x1015 data=0xeb |
| 13760 | hbus driver | Executed READ  addr=0x1016 data=0x1d |
| 13765 | hbus monitor | Collected READ  addr=0x1016 data=0x1d |
| 13790 | hbus driver | Executed READ  addr=0x1017 data=0x6d |
| 13795 | hbus monitor | Collected READ  addr=0x1017 data=0x6d |
| 13820 | hbus driver | Executed READ  addr=0x1018 data=0x6e |
| 13825 | hbus monitor | Collected READ  addr=0x1018 data=0x6e |
| 13850 | hbus driver | Executed READ  addr=0x1019 data=0xd9 |
| 13855 | hbus monitor | Collected READ  addr=0x1019 data=0xd9 |
| 13880 | hbus driver | Executed READ  addr=0x101a data=0xc3 |
| 13885 | hbus monitor | Collected READ  addr=0x101a data=0xc3 |
| 13910 | hbus driver | Executed READ  addr=0x101b data=0x2c |
| 13915 | hbus monitor | Collected READ  addr=0x101b data=0x2c |
| 13940 | hbus driver | Executed READ  addr=0x101c data=0xa2 |
| 13945 | hbus monitor | Collected READ  addr=0x101c data=0xa2 |
| 13970 | hbus driver | Executed READ  addr=0x101d data=0xe3 |
| 13975 | hbus monitor | Collected READ  addr=0x101d data=0xe3 |
| 14000 | hbus driver | Executed READ  addr=0x101e data=0x3d |
| 14005 | hbus monitor | Collected READ  addr=0x101e data=0x3d |
| 14030 | hbus driver | Executed READ  addr=0x101f data=0xb4 |
| 14035 | hbus monitor | Collected READ  addr=0x101f data=0xb4 |
| 14060 | hbus driver | Executed READ  addr=0x1020 data=0xdd |
| 14065 | hbus monitor | Collected READ  addr=0x1020 data=0xdd |
| 14090 | hbus driver | Executed READ  addr=0x1021 data=0x5b |
| 14095 | hbus monitor | Collected READ  addr=0x1021 data=0x5b |
| 14120 | hbus driver | Executed READ  addr=0x1022 data=0xc3 |
| 14125 | hbus monitor | Collected READ  addr=0x1022 data=0xc3 |
| 14150 | hbus driver | Executed READ  addr=0x1023 data=0xc9 |
| 14155 | hbus monitor | Collected READ  addr=0x1023 data=0xc9 |
| 14180 | hbus driver | Executed READ  addr=0x1024 data=0x3b |
| 14185 | hbus monitor | Collected READ  addr=0x1024 data=0x3b |
| 14210 | hbus driver | Executed READ  addr=0x1025 data=0x0c |
| 14215 | hbus monitor | Collected READ  addr=0x1025 data=0x0c |
| 14240 | hbus driver | Executed READ  addr=0x1026 data=0x4a |
| 14245 | hbus monitor | Collected READ  addr=0x1026 data=0x4a |
| 14270 | hbus driver | Executed READ  addr=0x1027 data=0xaa |
| 14275 | hbus monitor | Collected READ  addr=0x1027 data=0xaa |
| 14300 | hbus driver | Executed READ  addr=0x1028 data=0xc6 |
| 14305 | hbus monitor | Collected READ  addr=0x1028 data=0xc6 |
| 14330 | hbus driver | Executed READ  addr=0x1029 data=0x12 |
| 14335 | hbus monitor | Collected READ  addr=0x1029 data=0x12 |
| 14360 | hbus driver | Executed READ  addr=0x102a data=0x26 |
| 14365 | hbus monitor | Collected READ  addr=0x102a data=0x26 |
| 14390 | hbus driver | Executed READ  addr=0x102b data=0x60 |
| 14395 | hbus monitor | Collected READ  addr=0x102b data=0x60 |
| 14420 | hbus driver | Executed READ  addr=0x102c data=0x4a |
| 14425 | hbus monitor | Collected READ  addr=0x102c data=0x4a |
| 14450 | hbus driver | Executed READ  addr=0x102d data=0x5f |
| 14455 | hbus monitor | Collected READ  addr=0x102d data=0x5f |
| 14480 | hbus driver | Executed READ  addr=0x102e data=0x41 |
| 14485 | hbus monitor | Collected READ  addr=0x102e data=0x41 |
| 14510 | hbus driver | Executed READ  addr=0x102f data=0x15 |
| 14515 | hbus monitor | Collected READ  addr=0x102f data=0x15 |
| 14540 | hbus driver | Executed READ  addr=0x1030 data=0xea |
| 14545 | hbus monitor | Collected READ  addr=0x1030 data=0xea |
| 14570 | hbus driver | Executed READ  addr=0x1031 data=0xd7 |
| 14575 | hbus monitor | Collected READ  addr=0x1031 data=0xd7 |
| 14600 | hbus driver | Executed READ  addr=0x1032 data=0xba |
| 14605 | hbus monitor | Collected READ  addr=0x1032 data=0xba |
| 14630 | hbus driver | Executed READ  addr=0x1033 data=0xdd |
| 14635 | hbus monitor | Collected READ  addr=0x1033 data=0xdd |
| 14660 | hbus driver | Executed READ  addr=0x1034 data=0x8b |
| 14665 | hbus monitor | Collected READ  addr=0x1034 data=0x8b |
| 14690 | hbus driver | Executed READ  addr=0x1035 data=0xde |
| 14695 | hbus monitor | Collected READ  addr=0x1035 data=0xde |
| 14720 | hbus driver | Executed READ  addr=0x1036 data=0x2d |
| 14725 | hbus monitor | Collected READ  addr=0x1036 data=0x2d |
| 14750 | hbus driver | Executed READ  addr=0x1037 data=0xa2 |
| 14755 | hbus monitor | Collected READ  addr=0x1037 data=0xa2 |
| 14780 | hbus driver | Executed READ  addr=0x1038 data=0xfa |
| 14785 | hbus monitor | Collected READ  addr=0x1038 data=0xfa |
| 14810 | hbus driver | Executed READ  addr=0x1039 data=0x4c |
| 14815 | hbus monitor | Collected READ  addr=0x1039 data=0x4c |
| 14840 | hbus driver | Executed READ  addr=0x103a data=0xf0 |
| 14845 | hbus monitor | Collected READ  addr=0x103a data=0xf0 |
| 14870 | hbus driver | Executed READ  addr=0x103b data=0x76 |
| 14875 | hbus monitor | Collected READ  addr=0x103b data=0x76 |
| 14900 | hbus driver | Executed READ  addr=0x103c data=0xd4 |
| 14905 | hbus monitor | Collected READ  addr=0x103c data=0xd4 |
| 14930 | hbus driver | Executed READ  addr=0x103d data=0x20 |
| 14935 | hbus monitor | Collected READ  addr=0x103d data=0x20 |
| 14960 | hbus driver | Executed READ  addr=0x103e data=0x65 |
| 14965 | hbus monitor | Collected READ  addr=0x103e data=0x65 |
| 14990 | hbus driver | Executed READ  addr=0x103f data=0xe6 |
| 14995 | hbus monitor | Collected READ  addr=0x103f data=0xe6 |
| 15020 | hbus driver | Executed READ  addr=0x1040 data=0x72 |
| 15025 | hbus monitor | Collected READ  addr=0x1040 data=0x72 |
| 15050 | hbus driver | Executed READ  addr=0x1041 data=0x2e |
| 15055 | hbus monitor | Collected READ  addr=0x1041 data=0x2e |
| 15080 | hbus driver | Executed READ  addr=0x1042 data=0x21 |
| 15085 | hbus monitor | Collected READ  addr=0x1042 data=0x21 |
| 15110 | hbus driver | Executed READ  addr=0x1043 data=0x01 |
| 15115 | hbus monitor | Collected READ  addr=0x1043 data=0x01 |
| 15140 | hbus driver | Executed READ  addr=0x1044 data=0x1c |
| 15145 | hbus monitor | Collected READ  addr=0x1044 data=0x1c |
| 15170 | hbus driver | Executed READ  addr=0x1045 data=0x49 |
| 15175 | hbus monitor | Collected READ  addr=0x1045 data=0x49 |
| 15200 | hbus driver | Executed READ  addr=0x1046 data=0x00 |
| 15205 | hbus monitor | Collected READ  addr=0x1046 data=0x00 |
| 15230 | hbus driver | Executed READ  addr=0x1047 data=0x74 |
| 15235 | hbus monitor | Collected READ  addr=0x1047 data=0x74 |
| 15260 | hbus driver | Executed READ  addr=0x1048 data=0x65 |
| 15265 | hbus monitor | Collected READ  addr=0x1048 data=0x65 |
| 15290 | hbus driver | Executed READ  addr=0x1049 data=0xd0 |
| 15295 | hbus monitor | Collected READ  addr=0x1049 data=0xd0 |
| 15320 | hbus driver | Executed READ  addr=0x104a data=0xdd |
| 15325 | hbus monitor | Collected READ  addr=0x104a data=0xdd |
| 15350 | hbus driver | Executed READ  addr=0x104b data=0x98 |
| 15355 | hbus monitor | Collected READ  addr=0x104b data=0x98 |
| 15380 | hbus driver | Executed READ  addr=0x104c data=0x20 |
| 15385 | hbus monitor | Collected READ  addr=0x104c data=0x20 |
| 15410 | hbus driver | Executed READ  addr=0x104d data=0xdd |
| 15415 | hbus monitor | Collected READ  addr=0x104d data=0xdd |
| 15440 | hbus driver | Executed READ  addr=0x104e data=0x7b |
| 15445 | hbus monitor | Collected READ  addr=0x104e data=0x7b |
| 15470 | hbus driver | Executed READ  addr=0x104f data=0x25 |
| 15475 | hbus monitor | Collected READ  addr=0x104f data=0x25 |
| 15585 | **test** | STAGE: done: 36 packets (6 forwarded, 30 dropped), 1 storm burst(s), 6 scoreboard matches, 101 HBUS reads checked, 14 error pulses for 14 bad packets |
| 15785 | error checker | error pulse report: 14 bad packets, 14 pulses, 0 outside 1..10 cycles, at most 2 owed at once |
| 15785 | ch0 monitor | Channel 0 report: 2 packets collected |
| 15785 | ch1 monitor | Channel 1 report: 3 packets collected |
| 15785 | ch2 monitor | Channel 2 report: 1 packets collected |
| 15785 | hbus monitor | HBUS report: 23 writes, 102 reads |
| 15785 | coverage | Coverage of the router configuration: 87.0% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 9 / 9 / 9 / 0 / 0 packets · length < max / = max / max+1 / > max+1 : 2 / 5 / 2 / 18 · forwarded good / bad : 2 / 4 · dropped address 3 good / bad : 4 / 3 · dropped oversized good / bad : 7 / 7 · counter enables none / mixed / all : 0 / 18 / 9 |
| 15785 | coverage | HBUS address coverage: 125 accesses sampled, coverage 54.5% |
| 15785 | coverage | HBUS register bits coverage: 8 writes to ctrl_reg/en_reg, coverage 97.7% |
| 15785 | coverage | HBUS counter value coverage: 8 counter reads sampled, coverage 55.6% |
| 15785 | coverage | HBUS yapp_mem data coverage: 30 accesses sampled, coverage 29.4% |
| 15785 | reference | --- Reference model report --- · forwarded to scoreboard : 6 · dropped (router disabled) : 9 · dropped (oversized) : 14 · dropped (address 3) : 7 · counters parity/oversized/addr0..3 : 14 / 15 / 3 5 6 2 |
| 15785 | reference | HBUS reads checked against the model: 101 (0 mismatches, 1 of memory bytes never written) |
| 15785 | scoreboard | --- Scoreboard report --- · packets received : 6 · packets matched : 6 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 15785 | yapp driver | YAPP driver report: 36 packets sent |
| 15785 | coverage | YAPP gap coverage: 35 gaps sampled, coverage 100.0% |
| 15785 | yapp monitor | YAPP monitor report: 36 packets collected, 17 with bad parity |
| 15785 | yapp monitor | YAPP gaps: 17 back to back, 4 of 1 cycle, 1 of 2, 13 longer |
| 15785 | coverage | YAPP packet coverage: 36 packets sampled, coverage 76.7% |
