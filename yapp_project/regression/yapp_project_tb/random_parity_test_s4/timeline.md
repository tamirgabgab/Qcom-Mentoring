# random_parity_test  seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 11us · log `random_parity_test_s4.log`

Waves: `random_parity_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_parity_test_s4%2Frandom_parity_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **56** packet(s) (18 with bad parity); the input monitor saw 56.
- Router: **38** forwarded, **18** dropped (7 illegal address 3, 11 oversized).
- Packets out: ch0 **9**, ch1 **8**, ch2 **21**.
- Scoreboard: 38 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **3** time(s), longest hold 22 cycle(s).
- Error pulses: 18.
- HBUS: 20 write(s), 37 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 RX_SLOW, ch1 RX_STALLY, ch2 RX_NORMAL |
| 0 | random scenario: 56 packets in 5 bursts |
| 310 | burst 1/5: ctrl=0x4f (maxpktsize 15) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 4240 | burst 1/5 sent: addr0..3 4/0/2/5, bad parity 2, gap 0 9, length 1..63 |
| 4450 | burst 2/5: ctrl=0x1e (maxpktsize 30) en=0xff (router on, counter enables 1111111), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 4880 | burst 2/5 sent: addr0..3 1/1/8/1, bad parity 4, gap 0 11, length 1..3 |
| 5150 | burst 3/5: ctrl=0x1a (maxpktsize 26) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 9090 | burst 3/5 sent: addr0..3 3/3/5/0, bad parity 3, gap 0 5, length 1..63 |
| 9270 | burst 4/5: ctrl=0xb7 (maxpktsize 55) en=0x73 (router on, counter enables 0111001), 12 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 9700 | burst 4/5 sent: addr0..3 3/3/4/2, bad parity 7, gap 0 11, length 1..3 |
| 9930 | burst 5/5: ctrl=0x7b (maxpktsize 59) en=0xff (router on, counter enables 1111111), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 10360 | burst 5/5 sent: addr0..3 2/3/4/2, bad parity 2, gap 0 11, length 1..3 |
| 10360 | final reads: every register and the stored packet, checked against the reference model |
| 10865 | done: 56 packets (38 forwarded, 18 dropped), 3 storm burst(s), 38 scoreboard matches, 36 HBUS reads checked, 18 error pulses for 18 bad packets |

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

744 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 RX_SLOW, ch1 RX_STALLY, ch2 RX_NORMAL |
| 0 | **test** | STAGE: random scenario: 56 packets in 5 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x4f |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=15 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x4f |
| 75 | reference | maxpktsize is now 15 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x1015 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x1015 data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x10f1 data=0x00 |
| 155 | hbus monitor | Collected READ  addr=0x10f1 data=0x00 |
| 170 | hbus driver | Executed WRITE addr=0x1111 data=0x77 |
| 175 | hbus monitor | Collected WRITE addr=0x1111 data=0x77 |
| 200 | hbus driver | Executed READ  addr=0x1111 data=0x77 |
| 205 | hbus monitor | Collected READ  addr=0x1111 data=0x77 |
| 230 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 235 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 250 | hbus driver | Executed WRITE addr=0x11de data=0xd5 |
| 255 | hbus monitor | Collected WRITE addr=0x11de data=0xd5 |
| 280 | hbus driver | Executed READ  addr=0x11de data=0xd5 |
| 285 | hbus monitor | Collected READ  addr=0x11de data=0xd5 |
| 310 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 310 | **test** | STAGE: burst 1/5: ctrl=0x4f (maxpktsize 15) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 310 | yapp driver | TX pkt #1: addr=3 len=1 parity=good delay=6 |
| 315 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 385 | **DUT** | IN  pkt #1 header: addr=3 len=1 -> DROP (illegal address 3) |
| 405 | **DUT** | IN  pkt #1 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 405 | yapp monitor | RX pkt #1 on the input: addr=3 len=1 parity=good gap=33 |
| 405 | reference | Packet dropped: illegal address 3 (len=1) |
| 405 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 410 | yapp driver | TX pkt #1 accepted by the DUT |
| 410 | yapp driver | TX pkt #2: addr=3 len=63 parity=good delay=0 |
| 415 | **DUT** | IN  pkt #2 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 15) |
| 1055 | **DUT** | IN  pkt #2 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1055 | yapp monitor | RX pkt #2 on the input: addr=3 len=63 parity=good gap=0 |
| 1055 | reference | Packet dropped: illegal address 3 (len=63) |
| 1055 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1060 | yapp driver | TX pkt #2 accepted by the DUT |
| 1060 | yapp driver | TX pkt #3: addr=3 len=63 parity=bad delay=0 |
| 1065 | **DUT** | IN  pkt #3 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 15) |
| 1705 | **DUT** | IN  pkt #3 complete: addr=3 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 1705 | yapp monitor | RX pkt #3 on the input: addr=3 len=63 parity=bad gap=0 |
| 1705 | reference | Packet dropped: illegal address 3 (len=63) |
| 1705 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1710 | yapp driver | TX pkt #3 accepted by the DUT |
| 1710 | yapp driver | TX pkt #4: addr=0 len=16 parity=bad delay=0 |
| 1715 | **DUT** | IN  pkt #4 header: addr=0 len=16 -> DROP (oversized: len 16 > maxpktsize 15) |
| 1770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 1770 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 1885 | **DUT** | IN  pkt #4 complete: addr=0 len=16 parity=BAD dropped, 18 bytes in 18 cycles (held 0) |
| 1885 | yapp monitor | RX pkt #4 on the input: addr=0 len=16 parity=bad gap=0 |
| 1885 | reference | Packet dropped: length 16 > maxpktsize 15 (addr=0) |
| 1885 | **DUT** | ROUTER DROPS PACKET addr=0 length=16 (length > maxpktsize) |
| 1890 | yapp driver | TX pkt #4 accepted by the DUT |
| 1890 | yapp driver | TX pkt #5: addr=2 len=14 parity=good delay=20 |
| 1970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 1970 | error checker | error pulse 8 cycles after the bad packet (0 still owed) |
| 2095 | **DUT** | IN  pkt #5 header: addr=2 len=14 -> channel 2 |
| 2155 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=14 (receiver waited 5 cycle(s)) |
| 2245 | **DUT** | IN  pkt #5 complete: addr=2 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 2245 | yapp monitor | RX pkt #5 on the input: addr=2 len=14 parity=good gap=20 |
| 2245 | reference | Packet forwarded: addr=2 len=14 -> channel 2 |
| 2250 | yapp driver | TX pkt #5 accepted by the DUT |
| 2250 | yapp driver | TX pkt #6: addr=3 len=47 parity=good delay=0 |
| 2255 | **DUT** | IN  pkt #6 header: addr=3 len=47 -> DROP (oversized: len 47 > maxpktsize 15) |
| 2300 | ch2 driver | ch2: packet consumed (response delay 5) |
| 2415 | **DUT** | OUT ch2 pkt #1 done: 16 bytes in 27 cycles |
| 2415 | ch2 monitor | ch2 RX pkt #1: addr=2 len=14 parity=good |
| 2415 | scoreboard | ch2 pkt matched: addr=2 len=14 (1 matched so far) |
| 2735 | **DUT** | IN  pkt #6 complete: addr=3 len=47 parity=ok dropped, 49 bytes in 49 cycles (held 0) |
| 2735 | yapp monitor | RX pkt #6 on the input: addr=3 len=47 parity=good gap=0 |
| 2735 | reference | Packet dropped: illegal address 3 (len=47) |
| 2735 | **DUT** | ROUTER DROPS PACKET addr=3 length=47 (    illegal address) |
| 2740 | yapp driver | TX pkt #6 accepted by the DUT |
| 2740 | yapp driver | TX pkt #7: addr=0 len=53 parity=good delay=0 |
| 2745 | **DUT** | IN  pkt #7 header: addr=0 len=53 -> DROP (oversized: len 53 > maxpktsize 15) |
| 3040 | ch2 driver | ch2: packet consumed (response delay 10) |
| 3285 | **DUT** | IN  pkt #7 complete: addr=0 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 3285 | yapp monitor | RX pkt #7 on the input: addr=0 len=53 parity=good gap=0 |
| 3285 | reference | Packet dropped: length 53 > maxpktsize 15 (addr=0) |
| 3285 | **DUT** | ROUTER DROPS PACKET addr=0 length=53 (length > maxpktsize) |
| 3290 | yapp driver | TX pkt #7 accepted by the DUT |
| 3290 | yapp driver | TX pkt #8: addr=0 len=1 parity=good delay=0 |
| 3295 | **DUT** | IN  pkt #8 header: addr=0 len=1 -> channel 0 |
| 3315 | **DUT** | IN  pkt #8 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3315 | yapp monitor | RX pkt #8 on the input: addr=0 len=1 parity=good gap=0 |
| 3315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3320 | yapp driver | TX pkt #8 accepted by the DUT |
| 3320 | yapp driver | TX pkt #9: addr=0 len=15 parity=good delay=0 |
| 3325 | **DUT** | IN  pkt #9 header: addr=0 len=15 -> channel 0 |
| 3455 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x2b held (pkt #9) |
| 3535 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 23 cycle(s)) |
| 3545 | **DUT** | SUSPEND released after 9 cycle(s) |
| 3550 | ch0 driver | ch0: packet consumed (response delay 23) |
| 3565 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x3d held (pkt #9) |
| 3765 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 24 cycles |
| 3765 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 3765 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 3775 | **DUT** | SUSPEND released after 21 cycle(s) |
| 3775 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=15 (receiver waited 0 cycle(s)) |
| 3785 | **DUT** | IN  pkt #9 complete: addr=0 len=15 parity=ok forwarded, 17 bytes in 47 cycles (held 30) |
| 3785 | yapp monitor | RX pkt #9 on the input: addr=0 len=15 parity=good gap=0 |
| 3785 | reference | Packet forwarded: addr=0 len=15 -> channel 0 |
| 3790 | yapp driver | TX pkt #9 accepted by the DUT |
| 3790 | yapp driver | TX pkt #10: addr=3 len=1 parity=good delay=0 |
| 3795 | **DUT** | IN  pkt #10 header: addr=3 len=1 -> DROP (illegal address 3) |
| 3815 | **DUT** | IN  pkt #10 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 3815 | yapp monitor | RX pkt #10 on the input: addr=3 len=1 parity=good gap=0 |
| 3815 | reference | Packet dropped: illegal address 3 (len=1) |
| 3815 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 3820 | yapp driver | TX pkt #10 accepted by the DUT |
| 3820 | yapp driver | TX pkt #11: addr=2 len=40 parity=good delay=0 |
| 3825 | **DUT** | IN  pkt #11 header: addr=2 len=40 -> DROP (oversized: len 40 > maxpktsize 15) |
| 3935 | **DUT** | OUT ch0 pkt #2 done: 17 bytes in 17 cycles |
| 3935 | ch0 monitor | ch0 RX pkt #2: addr=0 len=15 parity=good |
| 3935 | scoreboard | ch0 pkt matched: addr=0 len=15 (3 matched so far) |
| 4090 | ch0 driver | ch0: packet consumed (response delay 20) |
| 4235 | **DUT** | IN  pkt #11 complete: addr=2 len=40 parity=ok dropped, 42 bytes in 42 cycles (held 0) |
| 4235 | yapp monitor | RX pkt #11 on the input: addr=2 len=40 parity=good gap=0 |
| 4235 | reference | Packet dropped: length 40 > maxpktsize 15 (addr=2) |
| 4235 | **DUT** | ROUTER DROPS PACKET addr=2 length=40 (length > maxpktsize) |
| 4240 | yapp driver | TX pkt #11 accepted by the DUT |
| 4240 | **test** | STAGE: burst 1/5 sent: addr0..3 4/0/2/5, bad parity 2, gap 0 9, length 1..63 |
| 4260 | hbus driver | Executed WRITE addr=0x1000 data=0x1e |
| 4265 | **DUT** | CONFIG router_en=1 maxpktsize=30 |
| 4265 | hbus monitor | Collected WRITE addr=0x1000 data=0x1e |
| 4265 | reference | maxpktsize is now 30 |
| 4280 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 4285 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 4285 | reference | router_en is now 1 (en_reg 0xff) |
| 4300 | hbus driver | Executed WRITE addr=0x113c data=0xe3 |
| 4305 | hbus monitor | Collected WRITE addr=0x113c data=0xe3 |
| 4330 | hbus driver | Executed READ  addr=0x113c data=0xe3 |
| 4335 | hbus monitor | Collected READ  addr=0x113c data=0xe3 |
| 4360 | hbus driver | Executed READ  addr=0x1000 data=0x1e |
| 4365 | hbus monitor | Collected READ  addr=0x1000 data=0x1e |
| 4390 | hbus driver | Executed READ  addr=0x106e data=0x00 |
| 4395 | hbus monitor | Collected READ  addr=0x106e data=0x00 |
| 4420 | hbus driver | Executed READ  addr=0x103d data=0x60 |
| 4425 | hbus monitor | Collected READ  addr=0x103d data=0x60 |
| 4450 | hbus driver | Executed READ  addr=0x1074 data=0x00 |
| 4450 | **test** | STAGE: burst 2/5: ctrl=0x1e (maxpktsize 30) en=0xff (router on, counter enables 1111111), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 4450 | yapp driver | TX pkt #12: addr=3 len=1 parity=bad delay=0 |
| 4455 | hbus monitor | Collected READ  addr=0x1074 data=0x00 |
| 4465 | **DUT** | IN  pkt #12 header: addr=3 len=1 -> DROP (illegal address 3) |
| 4485 | **DUT** | IN  pkt #12 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 4485 | yapp monitor | RX pkt #12 on the input: addr=3 len=1 parity=bad gap=22 |
| 4485 | reference | Packet dropped: illegal address 3 (len=1) |
| 4485 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 4490 | yapp driver | TX pkt #12 accepted by the DUT |
| 4490 | yapp driver | TX pkt #13: addr=2 len=1 parity=good delay=0 |
| 4495 | **DUT** | IN  pkt #13 header: addr=2 len=1 -> channel 2 |
| 4510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 4510 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 4515 | **DUT** | IN  pkt #13 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4515 | yapp monitor | RX pkt #13 on the input: addr=2 len=1 parity=good gap=0 |
| 4515 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 4520 | yapp driver | TX pkt #13 accepted by the DUT |
| 4520 | yapp driver | TX pkt #14: addr=0 len=1 parity=bad delay=0 |
| 4525 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> channel 0 |
| 4545 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 4545 | yapp monitor | RX pkt #14 on the input: addr=0 len=1 parity=bad gap=0 |
| 4545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4550 | yapp driver | TX pkt #14 accepted by the DUT |
| 4550 | yapp driver | TX pkt #15: addr=2 len=1 parity=bad delay=0 |
| 4555 | **DUT** | IN  pkt #15 header: addr=2 len=1 -> channel 2 |
| 4570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 4570 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 4575 | **DUT** | IN  pkt #15 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 4575 | yapp monitor | RX pkt #15 on the input: addr=2 len=1 parity=bad gap=0 |
| 4575 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 4580 | yapp driver | TX pkt #15 accepted by the DUT |
| 4580 | yapp driver | TX pkt #16: addr=1 len=2 parity=good delay=0 |
| 4585 | **DUT** | IN  pkt #16 header: addr=1 len=2 -> channel 1 |
| 4605 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=1 (receiver waited 10 cycle(s)) |
| 4615 | **DUT** | IN  pkt #16 complete: addr=1 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 4615 | yapp monitor | RX pkt #16 on the input: addr=1 len=2 parity=good gap=0 |
| 4615 | reference | Packet forwarded: addr=1 len=2 -> channel 1 |
| 4620 | ch2 driver | ch2: packet consumed (response delay 10) |
| 4620 | yapp driver | TX pkt #16 accepted by the DUT |
| 4620 | yapp driver | TX pkt #17: addr=2 len=3 parity=good delay=0 |
| 4625 | **DUT** | IN  pkt #17 header: addr=2 len=3 -> channel 2 |
| 4630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 4630 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 4665 | **DUT** | IN  pkt #17 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 4665 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=2 (receiver waited 7 cycle(s)) |
| 4665 | **DUT** | OUT ch2 pkt #2 done: 3 bytes in 7 cycles |
| 4665 | ch2 monitor | ch2 RX pkt #2: addr=2 len=1 parity=good |
| 4665 | scoreboard | ch2 pkt matched: addr=2 len=1 (4 matched so far) |
| 4665 | yapp monitor | RX pkt #17 on the input: addr=2 len=3 parity=good gap=0 |
| 4665 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 4670 | yapp driver | TX pkt #17 accepted by the DUT |
| 4670 | yapp driver | TX pkt #18: addr=2 len=2 parity=good delay=0 |
| 4675 | **DUT** | IN  pkt #18 header: addr=2 len=2 -> channel 2 |
| 4675 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 4690 | ch1 driver | ch1: packet consumed (response delay 7) |
| 4695 | **DUT** | OUT ch2 pkt #3 done: 3 bytes in 3 cycles |
| 4695 | ch2 monitor | ch2 RX pkt #3: addr=2 len=1 parity=bad |
| 4695 | scoreboard | ch2 pkt matched: addr=2 len=1 (5 matched so far) |
| 4705 | **DUT** | IN  pkt #18 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 4705 | **DUT** | OUT ch1 pkt #1 done: 4 bytes in 5 cycles |
| 4705 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 4705 | ch1 monitor | ch1 RX pkt #1: addr=1 len=2 parity=good |
| 4705 | scoreboard | ch1 pkt matched: addr=1 len=2 (6 matched so far) |
| 4705 | yapp monitor | RX pkt #18 on the input: addr=2 len=2 parity=good gap=0 |
| 4705 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 4710 | yapp driver | TX pkt #18 accepted by the DUT |
| 4710 | yapp driver | TX pkt #19: addr=2 len=3 parity=bad delay=0 |
| 4715 | **DUT** | IN  pkt #19 header: addr=2 len=3 -> channel 2 |
| 4745 | **DUT** | OUT ch2 pkt #4 done: 5 bytes in 5 cycles |
| 4745 | ch2 monitor | ch2 RX pkt #4: addr=2 len=3 parity=good |
| 4745 | scoreboard | ch2 pkt matched: addr=2 len=3 (7 matched so far) |
| 4755 | **DUT** | IN  pkt #19 complete: addr=2 len=3 parity=BAD forwarded, 5 bytes in 5 cycles (held 0) |
| 4755 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 4755 | yapp monitor | RX pkt #19 on the input: addr=2 len=3 parity=bad gap=0 |
| 4755 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 4760 | yapp driver | TX pkt #19 accepted by the DUT |
| 4760 | yapp driver | TX pkt #20: addr=2 len=2 parity=good delay=0 |
| 4765 | **DUT** | IN  pkt #20 header: addr=2 len=2 -> channel 2 |
| 4785 | **DUT** | OUT ch2 pkt #5 done: 4 bytes in 4 cycles |
| 4785 | ch2 monitor | ch2 RX pkt #5: addr=2 len=2 parity=good |
| 4785 | scoreboard | ch2 pkt matched: addr=2 len=2 (8 matched so far) |
| 4795 | **DUT** | IN  pkt #20 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 4795 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 4795 | yapp monitor | RX pkt #20 on the input: addr=2 len=2 parity=good gap=0 |
| 4795 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 4800 | yapp driver | TX pkt #20 accepted by the DUT |
| 4800 | yapp driver | TX pkt #21: addr=2 len=3 parity=good delay=0 |
| 4805 | **DUT** | IN  pkt #21 header: addr=2 len=3 -> channel 2 |
| 4830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 4830 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 4830 | ch2 driver | ch2: packet consumed (response delay 3) |
| 4830 | ch1 driver | ch1: packet consumed (response delay 0) |
| 4845 | **DUT** | IN  pkt #21 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 4845 | yapp monitor | RX pkt #21 on the input: addr=2 len=3 parity=good gap=0 |
| 4845 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 4850 | yapp driver | TX pkt #21 accepted by the DUT |
| 4850 | yapp driver | TX pkt #22: addr=2 len=1 parity=good delay=0 |
| 4855 | **DUT** | IN  pkt #22 header: addr=2 len=1 -> channel 2 |
| 4875 | **DUT** | IN  pkt #22 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4875 | yapp monitor | RX pkt #22 on the input: addr=2 len=1 parity=good gap=0 |
| 4875 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 4880 | yapp driver | TX pkt #22 accepted by the DUT |
| 4880 | **test** | STAGE: burst 2/5 sent: addr0..3 1/1/8/1, bad parity 4, gap 0 11, length 1..3 |
| 4900 | hbus driver | Executed WRITE addr=0x1000 data=0x1a |
| 4905 | **DUT** | CONFIG router_en=1 maxpktsize=26 |
| 4905 | hbus monitor | Collected WRITE addr=0x1000 data=0x1a |
| 4905 | reference | maxpktsize is now 26 |
| 4920 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 4925 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 4925 | reference | router_en is now 1 (en_reg 0xff) |
| 4935 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 40 cycle(s)) |
| 4945 | **DUT** | OUT ch2 pkt #6 done: 5 bytes in 16 cycles |
| 4945 | ch2 monitor | ch2 RX pkt #6: addr=2 len=3 parity=bad |
| 4945 | scoreboard | ch2 pkt matched: addr=2 len=3 (9 matched so far) |
| 4950 | ch0 driver | ch0: packet consumed (response delay 40) |
| 4950 | ch2 driver | ch2: packet consumed (response delay 10) |
| 4950 | hbus driver | Executed READ  addr=0x1009 data=0x05 |
| 4955 | hbus monitor | Collected READ  addr=0x1009 data=0x05 |
| 4970 | hbus driver | Executed WRITE addr=0x1197 data=0x89 |
| 4975 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=2 (receiver waited 2 cycle(s)) |
| 4975 | hbus monitor | Collected WRITE addr=0x1197 data=0x89 |
| 5000 | ch2 driver | ch2: packet consumed (response delay 1) |
| 5000 | hbus driver | Executed READ  addr=0x1197 data=0x89 |
| 5005 | hbus monitor | Collected READ  addr=0x1197 data=0x89 |
| 5020 | hbus driver | Executed WRITE addr=0x11b3 data=0xf7 |
| 5025 | hbus monitor | Collected WRITE addr=0x11b3 data=0xf7 |
| 5050 | hbus driver | Executed READ  addr=0x11b3 data=0xf7 |
| 5055 | hbus monitor | Collected READ  addr=0x11b3 data=0xf7 |
| 5065 | **DUT** | OUT ch2 pkt #7 done: 4 bytes in 10 cycles |
| 5065 | ch2 monitor | ch2 RX pkt #7: addr=2 len=2 parity=good |
| 5065 | scoreboard | ch2 pkt matched: addr=2 len=2 (10 matched so far) |
| 5070 | hbus driver | Executed WRITE addr=0x1124 data=0x7a |
| 5075 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 5075 | hbus monitor | Collected WRITE addr=0x1124 data=0x7a |
| 5100 | hbus driver | Executed READ  addr=0x1124 data=0x7a |
| 5105 | hbus monitor | Collected READ  addr=0x1124 data=0x7a |
| 5115 | **DUT** | OUT ch2 pkt #8 done: 5 bytes in 5 cycles |
| 5115 | ch2 monitor | ch2 RX pkt #8: addr=2 len=3 parity=good |
| 5115 | scoreboard | ch2 pkt matched: addr=2 len=3 (11 matched so far) |
| 5120 | hbus driver | Executed WRITE addr=0x1189 data=0xf1 |
| 5125 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 5125 | hbus monitor | Collected WRITE addr=0x1189 data=0xf1 |
| 5145 | **DUT** | OUT ch2 pkt #9 done: 3 bytes in 3 cycles |
| 5145 | ch2 monitor | ch2 RX pkt #9: addr=2 len=1 parity=good |
| 5145 | scoreboard | ch2 pkt matched: addr=2 len=1 (12 matched so far) |
| 5150 | hbus driver | Executed READ  addr=0x1189 data=0xf1 |
| 5150 | **test** | STAGE: burst 3/5: ctrl=0x1a (maxpktsize 26) en=0xff (router on, counter enables 1111111), 11 packet(s) |
| 5150 | yapp driver | TX pkt #23: addr=1 len=63 parity=good delay=5 |
| 5155 | hbus monitor | Collected READ  addr=0x1189 data=0xf1 |
| 5215 | **DUT** | IN  pkt #23 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 26) |
| 5275 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 35 cycles |
| 5275 | ch0 monitor | ch0 RX pkt #3: addr=0 len=1 parity=bad |
| 5275 | scoreboard | ch0 pkt matched: addr=0 len=1 (13 matched so far) |
| 5680 | ch2 driver | ch2: packet consumed (response delay 5) |
| 5850 | ch0 driver | ch0: packet consumed (response delay 31) |
| 5855 | **DUT** | IN  pkt #23 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5855 | yapp monitor | RX pkt #23 on the input: addr=1 len=63 parity=good gap=33 |
| 5855 | reference | Packet dropped: length 63 > maxpktsize 26 (addr=1) |
| 5855 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 5860 | yapp driver | TX pkt #23 accepted by the DUT |
| 5860 | yapp driver | TX pkt #24: addr=2 len=41 parity=bad delay=1 |
| 5875 | **DUT** | IN  pkt #24 header: addr=2 len=41 -> DROP (oversized: len 41 > maxpktsize 26) |
| 6295 | **DUT** | IN  pkt #24 complete: addr=2 len=41 parity=BAD dropped, 43 bytes in 43 cycles (held 0) |
| 6295 | yapp monitor | RX pkt #24 on the input: addr=2 len=41 parity=bad gap=1 |
| 6295 | reference | Packet dropped: length 41 > maxpktsize 26 (addr=2) |
| 6295 | **DUT** | ROUTER DROPS PACKET addr=2 length=41 (length > maxpktsize) |
| 6300 | yapp driver | TX pkt #24 accepted by the DUT |
| 6300 | yapp driver | TX pkt #25: addr=0 len=58 parity=bad delay=16 |
| 6310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 6310 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 6465 | **DUT** | IN  pkt #25 header: addr=0 len=58 -> DROP (oversized: len 58 > maxpktsize 26) |
| 7055 | **DUT** | IN  pkt #25 complete: addr=0 len=58 parity=BAD dropped, 60 bytes in 60 cycles (held 0) |
| 7055 | yapp monitor | RX pkt #25 on the input: addr=0 len=58 parity=bad gap=16 |
| 7055 | reference | Packet dropped: length 58 > maxpktsize 26 (addr=0) |
| 7055 | **DUT** | ROUTER DROPS PACKET addr=0 length=58 (length > maxpktsize) |
| 7060 | yapp driver | TX pkt #25 accepted by the DUT |
| 7060 | yapp driver | TX pkt #26: addr=2 len=4 parity=good delay=18 |
| 7090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 7090 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 7245 | **DUT** | IN  pkt #26 header: addr=2 len=4 -> channel 2 |
| 7295 | **DUT** | IN  pkt #26 complete: addr=2 len=4 parity=ok forwarded, 6 bytes in 6 cycles (held 0) |
| 7295 | yapp monitor | RX pkt #26 on the input: addr=2 len=4 parity=good gap=18 |
| 7295 | reference | Packet forwarded: addr=2 len=4 -> channel 2 |
| 7300 | yapp driver | TX pkt #26 accepted by the DUT |
| 7300 | yapp driver | TX pkt #27: addr=1 len=36 parity=good delay=1 |
| 7315 | **DUT** | IN  pkt #27 header: addr=1 len=36 -> DROP (oversized: len 36 > maxpktsize 26) |
| 7325 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=4 (receiver waited 7 cycle(s)) |
| 7370 | ch2 driver | ch2: packet consumed (response delay 7) |
| 7475 | **DUT** | OUT ch2 pkt #10 done: 6 bytes in 16 cycles |
| 7475 | ch2 monitor | ch2 RX pkt #10: addr=2 len=4 parity=good |
| 7475 | scoreboard | ch2 pkt matched: addr=2 len=4 (14 matched so far) |
| 7685 | **DUT** | IN  pkt #27 complete: addr=1 len=36 parity=ok dropped, 38 bytes in 38 cycles (held 0) |
| 7685 | yapp monitor | RX pkt #27 on the input: addr=1 len=36 parity=good gap=1 |
| 7685 | reference | Packet dropped: length 36 > maxpktsize 26 (addr=1) |
| 7685 | **DUT** | ROUTER DROPS PACKET addr=1 length=36 (length > maxpktsize) |
| 7690 | yapp driver | TX pkt #27 accepted by the DUT |
| 7690 | yapp driver | TX pkt #28: addr=0 len=47 parity=bad delay=0 |
| 7695 | **DUT** | IN  pkt #28 header: addr=0 len=47 -> DROP (oversized: len 47 > maxpktsize 26) |
| 7950 | ch2 driver | ch2: packet consumed (response delay 9) |
| 8175 | **DUT** | IN  pkt #28 complete: addr=0 len=47 parity=BAD dropped, 49 bytes in 49 cycles (held 0) |
| 8175 | yapp monitor | RX pkt #28 on the input: addr=0 len=47 parity=bad gap=0 |
| 8175 | reference | Packet dropped: length 47 > maxpktsize 26 (addr=0) |
| 8175 | **DUT** | ROUTER DROPS PACKET addr=0 length=47 (length > maxpktsize) |
| 8180 | yapp driver | TX pkt #28 accepted by the DUT |
| 8180 | yapp driver | TX pkt #29: addr=1 len=1 parity=good delay=1 |
| 8195 | **DUT** | IN  pkt #29 header: addr=1 len=1 -> channel 1 |
| 8210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 8210 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 8215 | **DUT** | IN  pkt #29 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8215 | yapp monitor | RX pkt #29 on the input: addr=1 len=1 parity=good gap=1 |
| 8215 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 8220 | yapp driver | TX pkt #29 accepted by the DUT |
| 8220 | yapp driver | TX pkt #30: addr=0 len=24 parity=good delay=0 |
| 8225 | **DUT** | IN  pkt #30 header: addr=0 len=24 -> channel 0 |
| 8225 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=1 (receiver waited 2 cycle(s)) |
| 8240 | ch1 driver | ch1: packet consumed (response delay 2) |
| 8385 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0x54 held (pkt #30) |
| 8595 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=24 (receiver waited 36 cycle(s)) |
| 8605 | **DUT** | SUSPEND released after 22 cycle(s) |
| 8695 | **DUT** | IN  pkt #30 complete: addr=0 len=24 parity=ok forwarded, 26 bytes in 48 cycles (held 22) |
| 8695 | yapp monitor | RX pkt #30 on the input: addr=0 len=24 parity=good gap=0 |
| 8695 | reference | Packet forwarded: addr=0 len=24 -> channel 0 |
| 8700 | yapp driver | TX pkt #30 accepted by the DUT |
| 8700 | yapp driver | TX pkt #31: addr=2 len=17 parity=good delay=0 |
| 8705 | **DUT** | IN  pkt #31 header: addr=2 len=17 -> channel 2 |
| 8725 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=17 (receiver waited 1 cycle(s)) |
| 8840 | ch0 driver | ch0: packet consumed (response delay 36) |
| 8865 | **DUT** | OUT ch1 pkt #2 done: 3 bytes in 65 cycles |
| 8865 | ch1 monitor | ch1 RX pkt #2: addr=1 len=1 parity=good |
| 8865 | scoreboard | ch1 pkt matched: addr=1 len=1 (15 matched so far) |
| 8885 | **DUT** | IN  pkt #31 complete: addr=2 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 8885 | yapp monitor | RX pkt #31 on the input: addr=2 len=17 parity=good gap=0 |
| 8885 | reference | Packet forwarded: addr=2 len=17 -> channel 2 |
| 8890 | yapp driver | TX pkt #31 accepted by the DUT |
| 8890 | yapp driver | TX pkt #32: addr=2 len=9 parity=good delay=0 |
| 8895 | **DUT** | IN  pkt #32 header: addr=2 len=9 -> channel 2 |
| 8900 | ch2 driver | ch2: packet consumed (response delay 1) |
| 8935 | **DUT** | OUT ch2 pkt #11 done: 19 bytes in 22 cycles |
| 8935 | ch2 monitor | ch2 RX pkt #11: addr=2 len=17 parity=good |
| 8935 | scoreboard | ch2 pkt matched: addr=2 len=17 (16 matched so far) |
| 8945 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=9 (receiver waited 0 cycle(s)) |
| 8995 | **DUT** | IN  pkt #32 complete: addr=2 len=9 parity=ok forwarded, 11 bytes in 11 cycles (held 0) |
| 8995 | yapp monitor | RX pkt #32 on the input: addr=2 len=9 parity=good gap=0 |
| 8995 | reference | Packet forwarded: addr=2 len=9 -> channel 2 |
| 9000 | yapp driver | TX pkt #32 accepted by the DUT |
| 9000 | yapp driver | TX pkt #33: addr=2 len=7 parity=good delay=0 |
| 9005 | **DUT** | IN  pkt #33 header: addr=2 len=7 -> channel 2 |
| 9045 | **DUT** | OUT ch2 pkt #12 done: 11 bytes in 11 cycles |
| 9045 | ch2 monitor | ch2 RX pkt #12: addr=2 len=9 parity=good |
| 9045 | scoreboard | ch2 pkt matched: addr=2 len=9 (17 matched so far) |
| 9055 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=7 (receiver waited 0 cycle(s)) |
| 9075 | **DUT** | OUT ch0 pkt #4 done: 26 bytes in 49 cycles |
| 9075 | ch0 monitor | ch0 RX pkt #4: addr=0 len=24 parity=good |
| 9075 | scoreboard | ch0 pkt matched: addr=0 len=24 (18 matched so far) |
| 9085 | **DUT** | IN  pkt #33 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 9085 | yapp monitor | RX pkt #33 on the input: addr=2 len=7 parity=good gap=0 |
| 9085 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 9090 | yapp driver | TX pkt #33 accepted by the DUT |
| 9090 | **test** | STAGE: burst 3/5 sent: addr0..3 3/3/5/0, bad parity 3, gap 0 5, length 1..63 |
| 9110 | hbus driver | Executed WRITE addr=0x1000 data=0xb7 |
| 9115 | **DUT** | CONFIG router_en=1 maxpktsize=55 |
| 9115 | hbus monitor | Collected WRITE addr=0x1000 data=0xb7 |
| 9115 | reference | maxpktsize is now 55 |
| 9130 | hbus driver | Executed WRITE addr=0x1001 data=0x73 |
| 9135 | **DUT** | OUT ch2 pkt #13 done: 9 bytes in 9 cycles |
| 9135 | ch2 monitor | ch2 RX pkt #13: addr=2 len=7 parity=good |
| 9135 | scoreboard | ch2 pkt matched: addr=2 len=7 (19 matched so far) |
| 9135 | hbus monitor | Collected WRITE addr=0x1001 data=0x73 |
| 9135 | reference | router_en is now 1 (en_reg 0x73) |
| 9160 | hbus driver | Executed READ  addr=0x10f9 data=0x00 |
| 9165 | hbus monitor | Collected READ  addr=0x10f9 data=0x00 |
| 9190 | hbus driver | Executed READ  addr=0x100d data=0x07 |
| 9195 | hbus monitor | Collected READ  addr=0x100d data=0x07 |
| 9210 | hbus driver | Executed WRITE addr=0x11ef data=0xba |
| 9215 | hbus monitor | Collected WRITE addr=0x11ef data=0xba |
| 9230 | ch1 driver | ch1: packet consumed (response delay 61) |
| 9240 | hbus driver | Executed READ  addr=0x11ef data=0xba |
| 9245 | hbus monitor | Collected READ  addr=0x11ef data=0xba |
| 9270 | hbus driver | Executed READ  addr=0x1035 data=0x82 |
| 9270 | **test** | STAGE: burst 4/5: ctrl=0xb7 (maxpktsize 55) en=0x73 (router on, counter enables 0111001), 12 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 9270 | yapp driver | TX pkt #34: addr=2 len=2 parity=good delay=0 |
| 9275 | hbus monitor | Collected READ  addr=0x1035 data=0x82 |
| 9285 | **DUT** | IN  pkt #34 header: addr=2 len=2 -> channel 2 |
| 9290 | ch2 driver | ch2: packet consumed (response delay 2) |
| 9315 | **DUT** | IN  pkt #34 complete: addr=2 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 9315 | yapp monitor | RX pkt #34 on the input: addr=2 len=2 parity=good gap=19 |
| 9315 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 9320 | yapp driver | TX pkt #34 accepted by the DUT |
| 9320 | yapp driver | TX pkt #35: addr=1 len=1 parity=bad delay=0 |
| 9325 | **DUT** | IN  pkt #35 header: addr=1 len=1 -> channel 1 |
| 9345 | **DUT** | IN  pkt #35 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9345 | yapp monitor | RX pkt #35 on the input: addr=1 len=1 parity=bad gap=0 |
| 9345 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 9350 | yapp driver | TX pkt #35 accepted by the DUT |
| 9350 | yapp driver | TX pkt #36: addr=0 len=1 parity=good delay=0 |
| 9355 | **DUT** | IN  pkt #36 header: addr=0 len=1 -> channel 0 |
| 9365 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 9370 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 9375 | **DUT** | IN  pkt #36 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9375 | yapp monitor | RX pkt #36 on the input: addr=0 len=1 parity=good gap=0 |
| 9375 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9380 | yapp driver | TX pkt #36 accepted by the DUT |
| 9380 | yapp driver | TX pkt #37: addr=2 len=1 parity=good delay=0 |
| 9385 | **DUT** | IN  pkt #37 header: addr=2 len=1 -> channel 2 |
| 9385 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 3 cycles |
| 9385 | ch0 monitor | ch0 RX pkt #5: addr=0 len=1 parity=good |
| 9385 | scoreboard | ch0 pkt matched: addr=0 len=1 (20 matched so far) |
| 9405 | **DUT** | IN  pkt #37 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9405 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=2 (receiver waited 11 cycle(s)) |
| 9405 | yapp monitor | RX pkt #37 on the input: addr=2 len=1 parity=good gap=0 |
| 9405 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 9410 | yapp driver | TX pkt #37 accepted by the DUT |
| 9410 | yapp driver | TX pkt #38: addr=0 len=1 parity=bad delay=0 |
| 9415 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 9425 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9425 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 9 cycle(s)) |
| 9430 | ch2 driver | ch2: packet consumed (response delay 10) |
| 9435 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9435 | yapp monitor | RX pkt #38 on the input: addr=0 len=1 parity=bad gap=0 |
| 9435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9440 | ch1 driver | ch1: packet consumed (response delay 9) |
| 9440 | yapp driver | TX pkt #38 accepted by the DUT |
| 9440 | yapp driver | TX pkt #39: addr=1 len=3 parity=good delay=0 |
| 9445 | **DUT** | IN  pkt #39 header: addr=1 len=3 -> channel 1 |
| 9445 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 9445 | ch0 monitor | ch0 RX pkt #6: addr=0 len=1 parity=bad |
| 9445 | scoreboard | ch0 pkt matched: addr=0 len=1 (21 matched so far) |
| 9450 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 9450 | error checker | error pulse 1 cycles after the bad packet (0 still owed) |
| 9485 | **DUT** | IN  pkt #39 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 9485 | yapp monitor | RX pkt #39 on the input: addr=1 len=3 parity=good gap=0 |
| 9485 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 9490 | yapp driver | TX pkt #39 accepted by the DUT |
| 9490 | yapp driver | TX pkt #40: addr=0 len=3 parity=good delay=0 |
| 9495 | **DUT** | IN  pkt #40 header: addr=0 len=3 -> channel 0 |
| 9505 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=3 (receiver waited 0 cycle(s)) |
| 9525 | **DUT** | OUT ch2 pkt #14 done: 4 bytes in 13 cycles |
| 9525 | ch2 monitor | ch2 RX pkt #14: addr=2 len=2 parity=good |
| 9525 | scoreboard | ch2 pkt matched: addr=2 len=2 (22 matched so far) |
| 9535 | **DUT** | IN  pkt #40 complete: addr=0 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 9535 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 12 cycles |
| 9535 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 9535 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=bad |
| 9535 | scoreboard | ch1 pkt matched: addr=1 len=1 (23 matched so far) |
| 9535 | yapp monitor | RX pkt #40 on the input: addr=0 len=3 parity=good gap=0 |
| 9535 | reference | Packet forwarded: addr=0 len=3 -> channel 0 |
| 9540 | yapp driver | TX pkt #40 accepted by the DUT |
| 9540 | yapp driver | TX pkt #41: addr=1 len=1 parity=bad delay=0 |
| 9545 | **DUT** | IN  pkt #41 header: addr=1 len=1 -> channel 1 |
| 9545 | **DUT** | OUT ch0 pkt #7 done: 5 bytes in 5 cycles |
| 9545 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=3 (receiver waited 0 cycle(s)) |
| 9545 | ch0 monitor | ch0 RX pkt #7: addr=0 len=3 parity=good |
| 9545 | scoreboard | ch0 pkt matched: addr=0 len=3 (24 matched so far) |
| 9555 | **DUT** | OUT ch2 pkt #15 done: 3 bytes in 3 cycles |
| 9555 | ch2 monitor | ch2 RX pkt #15: addr=2 len=1 parity=good |
| 9555 | scoreboard | ch2 pkt matched: addr=2 len=1 (25 matched so far) |
| 9565 | **DUT** | IN  pkt #41 complete: addr=1 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9565 | yapp monitor | RX pkt #41 on the input: addr=1 len=1 parity=bad gap=0 |
| 9565 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 9570 | yapp driver | TX pkt #41 accepted by the DUT |
| 9570 | yapp driver | TX pkt #42: addr=2 len=1 parity=bad delay=0 |
| 9575 | **DUT** | IN  pkt #42 header: addr=2 len=1 -> channel 2 |
| 9585 | **DUT** | OUT ch1 pkt #4 done: 5 bytes in 5 cycles |
| 9585 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 9585 | ch1 monitor | ch1 RX pkt #4: addr=1 len=3 parity=good |
| 9585 | scoreboard | ch1 pkt matched: addr=1 len=3 (26 matched so far) |
| 9595 | **DUT** | IN  pkt #42 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9595 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 9595 | yapp monitor | RX pkt #42 on the input: addr=2 len=1 parity=bad gap=0 |
| 9595 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 9600 | yapp driver | TX pkt #42 accepted by the DUT |
| 9600 | yapp driver | TX pkt #43: addr=3 len=1 parity=bad delay=0 |
| 9605 | **DUT** | IN  pkt #43 header: addr=3 len=1 -> DROP (illegal address 3) |
| 9605 | **DUT** | OUT ch2 pkt #16 done: 3 bytes in 3 cycles |
| 9605 | ch2 monitor | ch2 RX pkt #16: addr=2 len=1 parity=bad |
| 9605 | scoreboard | ch2 pkt matched: addr=2 len=1 (27 matched so far) |
| 9610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet (1 more owed) |
| 9610 | error checker | error pulse 4 cycles after the bad packet (1 still owed) |
| 9615 | **DUT** | OUT ch1 pkt #5 done: 3 bytes in 3 cycles |
| 9615 | ch1 monitor | ch1 RX pkt #5: addr=1 len=1 parity=bad |
| 9615 | scoreboard | ch1 pkt matched: addr=1 len=1 (28 matched so far) |
| 9625 | **DUT** | IN  pkt #43 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 9625 | yapp monitor | RX pkt #43 on the input: addr=3 len=1 parity=bad gap=0 |
| 9625 | reference | Packet dropped: illegal address 3 (len=1) |
| 9625 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 9630 | yapp driver | TX pkt #43 accepted by the DUT |
| 9630 | yapp driver | TX pkt #44: addr=2 len=1 parity=bad delay=0 |
| 9635 | **DUT** | IN  pkt #44 header: addr=2 len=1 -> channel 2 |
| 9645 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 9650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 9650 | error checker | error pulse 5 cycles after the bad packet (1 still owed) |
| 9655 | **DUT** | IN  pkt #44 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 9655 | yapp monitor | RX pkt #44 on the input: addr=2 len=1 parity=bad gap=0 |
| 9655 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 9660 | yapp driver | TX pkt #44 accepted by the DUT |
| 9660 | yapp driver | TX pkt #45: addr=3 len=1 parity=bad delay=1 |
| 9665 | **DUT** | OUT ch2 pkt #17 done: 3 bytes in 3 cycles |
| 9665 | ch2 monitor | ch2 RX pkt #17: addr=2 len=1 parity=bad |
| 9665 | scoreboard | ch2 pkt matched: addr=2 len=1 (29 matched so far) |
| 9670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet (1 more owed) |
| 9670 | error checker | error pulse 4 cycles after the bad packet (1 still owed) |
| 9675 | **DUT** | IN  pkt #45 header: addr=3 len=1 -> DROP (illegal address 3) |
| 9680 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 9680 | error checker | error pulse 2 cycles after the bad packet (0 still owed) |
| 9695 | **DUT** | IN  pkt #45 complete: addr=3 len=1 parity=BAD dropped, 3 bytes in 3 cycles (held 0) |
| 9695 | yapp monitor | RX pkt #45 on the input: addr=3 len=1 parity=bad gap=1 |
| 9695 | reference | Packet dropped: illegal address 3 (len=1) |
| 9695 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 9700 | ch0 driver | ch0: packet consumed (response delay 22) |
| 9700 | yapp driver | TX pkt #45 accepted by the DUT |
| 9700 | **test** | STAGE: burst 4/5 sent: addr0..3 3/3/4/2, bad parity 7, gap 0 11, length 1..3 |
| 9720 | hbus driver | Executed WRITE addr=0x1000 data=0x7b |
| 9725 | **DUT** | CONFIG router_en=1 maxpktsize=59 |
| 9725 | hbus monitor | Collected WRITE addr=0x1000 data=0x7b |
| 9725 | reference | maxpktsize is now 59 |
| 9740 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 9745 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 9745 | reference | router_en is now 1 (en_reg 0xff) |
| 9750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 9750 | error checker | error pulse 5 cycles after the bad packet (0 still owed) |
| 9770 | hbus driver | Executed READ  addr=0x1021 data=0x8b |
| 9775 | hbus monitor | Collected READ  addr=0x1021 data=0x8b |
| 9790 | hbus driver | Executed WRITE addr=0x1168 data=0x26 |
| 9795 | hbus monitor | Collected WRITE addr=0x1168 data=0x26 |
| 9820 | hbus driver | Executed READ  addr=0x1168 data=0x26 |
| 9825 | hbus monitor | Collected READ  addr=0x1168 data=0x26 |
| 9850 | hbus driver | Executed READ  addr=0x10f7 data=0x00 |
| 9855 | hbus monitor | Collected READ  addr=0x10f7 data=0x00 |
| 9860 | ch2 driver | ch2: packet consumed (response delay 8) |
| 9860 | ch1 driver | ch1: packet consumed (response delay 8) |
| 9880 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 9885 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 9900 | hbus driver | Executed WRITE addr=0x11d6 data=0x69 |
| 9905 | hbus monitor | Collected WRITE addr=0x11d6 data=0x69 |
| 9930 | hbus driver | Executed READ  addr=0x11d6 data=0x69 |
| 9930 | **test** | STAGE: burst 5/5: ctrl=0x7b (maxpktsize 59) en=0xff (router on, counter enables 1111111), 11 packet(s) -- storm: 1..3-byte packets back to back, half with bad parity |
| 9930 | yapp driver | TX pkt #46: addr=1 len=3 parity=good delay=0 |
| 9935 | hbus monitor | Collected READ  addr=0x11d6 data=0x69 |
| 9945 | **DUT** | IN  pkt #46 header: addr=1 len=3 -> channel 1 |
| 9985 | **DUT** | IN  pkt #46 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 9985 | yapp monitor | RX pkt #46 on the input: addr=1 len=3 parity=good gap=24 |
| 9985 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 9990 | yapp driver | TX pkt #46 accepted by the DUT |
| 9990 | yapp driver | TX pkt #47: addr=2 len=3 parity=good delay=0 |
| 9995 | **DUT** | IN  pkt #47 header: addr=2 len=3 -> channel 2 |
| 10035 | **DUT** | IN  pkt #47 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 10035 | yapp monitor | RX pkt #47 on the input: addr=2 len=3 parity=good gap=0 |
| 10035 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 10040 | yapp driver | TX pkt #47 accepted by the DUT |
| 10040 | yapp driver | TX pkt #48: addr=1 len=1 parity=good delay=0 |
| 10045 | **DUT** | IN  pkt #48 header: addr=1 len=1 -> channel 1 |
| 10055 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=3 (receiver waited 10 cycle(s)) |
| 10065 | **DUT** | IN  pkt #48 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10065 | yapp monitor | RX pkt #48 on the input: addr=1 len=1 parity=good gap=0 |
| 10065 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 10070 | yapp driver | TX pkt #48 accepted by the DUT |
| 10070 | yapp driver | TX pkt #49: addr=2 len=2 parity=bad delay=0 |
| 10075 | **DUT** | IN  pkt #49 header: addr=2 len=2 -> channel 2 |
| 10090 | ch1 driver | ch1: packet consumed (response delay 10) |
| 10095 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=3 (receiver waited 9 cycle(s)) |
| 10105 | **DUT** | IN  pkt #49 complete: addr=2 len=2 parity=BAD forwarded, 4 bytes in 4 cycles (held 0) |
| 10105 | yapp monitor | RX pkt #49 on the input: addr=2 len=2 parity=bad gap=0 |
| 10105 | reference | Packet forwarded: addr=2 len=2 -> channel 2 |
| 10110 | yapp driver | TX pkt #49 accepted by the DUT |
| 10110 | yapp driver | TX pkt #50: addr=2 len=1 parity=good delay=0 |
| 10115 | **DUT** | IN  pkt #50 header: addr=2 len=1 -> channel 2 |
| 10130 | ch2 driver | ch2: packet consumed (response delay 9) |
| 10135 | **DUT** | IN  pkt #50 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10135 | yapp monitor | RX pkt #50 on the input: addr=2 len=1 parity=good gap=0 |
| 10135 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 10140 | yapp driver | TX pkt #50 accepted by the DUT |
| 10140 | yapp driver | TX pkt #51: addr=0 len=1 parity=good delay=0 |
| 10145 | **DUT** | IN  pkt #51 header: addr=0 len=1 -> channel 0 |
| 10145 | **DUT** | OUT ch1 pkt #6 done: 5 bytes in 10 cycles |
| 10145 | ch1 monitor | ch1 RX pkt #6: addr=1 len=3 parity=good |
| 10145 | scoreboard | ch1 pkt matched: addr=1 len=3 (30 matched so far) |
| 10150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 10150 | error checker | error pulse 4 cycles after the bad packet (0 still owed) |
| 10155 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 10155 | **DUT** | OUT ch2 pkt #18 done: 5 bytes in 7 cycles |
| 10155 | ch2 monitor | ch2 RX pkt #18: addr=2 len=3 parity=good |
| 10155 | scoreboard | ch2 pkt matched: addr=2 len=3 (31 matched so far) |
| 10165 | **DUT** | IN  pkt #51 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10165 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=2 (receiver waited 0 cycle(s)) |
| 10165 | yapp monitor | RX pkt #51 on the input: addr=0 len=1 parity=good gap=0 |
| 10165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10170 | yapp driver | TX pkt #51 accepted by the DUT |
| 10170 | yapp driver | TX pkt #52: addr=2 len=1 parity=good delay=0 |
| 10175 | **DUT** | IN  pkt #52 header: addr=2 len=1 -> channel 2 |
| 10175 | **DUT** | OUT ch1 pkt #7 done: 3 bytes in 3 cycles |
| 10175 | ch1 monitor | ch1 RX pkt #7: addr=1 len=1 parity=good |
| 10175 | scoreboard | ch1 pkt matched: addr=1 len=1 (32 matched so far) |
| 10195 | **DUT** | IN  pkt #52 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10195 | **DUT** | OUT ch2 pkt #19 done: 4 bytes in 4 cycles |
| 10195 | ch2 monitor | ch2 RX pkt #19: addr=2 len=2 parity=bad |
| 10195 | scoreboard | ch2 pkt matched: addr=2 len=2 (33 matched so far) |
| 10195 | yapp monitor | RX pkt #52 on the input: addr=2 len=1 parity=good gap=0 |
| 10195 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 10200 | yapp driver | TX pkt #52 accepted by the DUT |
| 10200 | yapp driver | TX pkt #53: addr=3 len=2 parity=good delay=0 |
| 10205 | **DUT** | IN  pkt #53 header: addr=3 len=2 -> DROP (illegal address 3) |
| 10205 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 10225 | **DUT** | OUT ch2 pkt #20 done: 3 bytes in 3 cycles |
| 10225 | ch2 monitor | ch2 RX pkt #20: addr=2 len=1 parity=good |
| 10225 | scoreboard | ch2 pkt matched: addr=2 len=1 (34 matched so far) |
| 10235 | **DUT** | IN  pkt #53 complete: addr=3 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 10235 | **DUT** | OUT ch2 pkt #21 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 10235 | yapp monitor | RX pkt #53 on the input: addr=3 len=2 parity=good gap=0 |
| 10235 | reference | Packet dropped: illegal address 3 (len=2) |
| 10235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 10240 | yapp driver | TX pkt #53 accepted by the DUT |
| 10240 | yapp driver | TX pkt #54: addr=3 len=3 parity=bad delay=0 |
| 10245 | **DUT** | IN  pkt #54 header: addr=3 len=3 -> DROP (illegal address 3) |
| 10255 | **DUT** | OUT ch2 pkt #21 done: 3 bytes in 3 cycles |
| 10255 | ch2 monitor | ch2 RX pkt #21: addr=2 len=1 parity=good |
| 10255 | scoreboard | ch2 pkt matched: addr=2 len=1 (35 matched so far) |
| 10260 | ch2 driver | ch2: packet consumed (response delay 1) |
| 10285 | **DUT** | IN  pkt #54 complete: addr=3 len=3 parity=BAD dropped, 5 bytes in 5 cycles (held 0) |
| 10285 | yapp monitor | RX pkt #54 on the input: addr=3 len=3 parity=bad gap=0 |
| 10285 | reference | Packet dropped: illegal address 3 (len=3) |
| 10285 | **DUT** | ROUTER DROPS PACKET addr=3 length=3 (    illegal address) |
| 10290 | yapp driver | TX pkt #54 accepted by the DUT |
| 10290 | yapp driver | TX pkt #55: addr=1 len=1 parity=good delay=0 |
| 10295 | **DUT** | IN  pkt #55 header: addr=1 len=1 -> channel 1 |
| 10305 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=1 (receiver waited 0 cycle(s)) |
| 10315 | **DUT** | IN  pkt #55 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10315 | yapp monitor | RX pkt #55 on the input: addr=1 len=1 parity=good gap=0 |
| 10315 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 10320 | yapp driver | TX pkt #55 accepted by the DUT |
| 10320 | yapp driver | TX pkt #56: addr=0 len=2 parity=good delay=0 |
| 10325 | **DUT** | IN  pkt #56 header: addr=0 len=2 -> channel 0 |
| 10325 | **DUT** | OUT ch1 pkt #8 done: 3 bytes in 3 cycles |
| 10325 | ch1 monitor | ch1 RX pkt #8: addr=1 len=1 parity=good |
| 10325 | scoreboard | ch1 pkt matched: addr=1 len=1 (36 matched so far) |
| 10350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 10350 | error checker | error pulse 6 cycles after the bad packet (0 still owed) |
| 10355 | **DUT** | IN  pkt #56 complete: addr=0 len=2 parity=ok forwarded, 4 bytes in 4 cycles (held 0) |
| 10355 | yapp monitor | RX pkt #56 on the input: addr=0 len=2 parity=good gap=0 |
| 10355 | reference | Packet forwarded: addr=0 len=2 -> channel 0 |
| 10360 | yapp driver | TX pkt #56 accepted by the DUT |
| 10360 | **test** | STAGE: burst 5/5 sent: addr0..3 2/3/4/2, bad parity 2, gap 0 11, length 1..3 |
| 10360 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 10390 | hbus driver | Executed READ  addr=0x1000 data=0x7b |
| 10395 | hbus monitor | Collected READ  addr=0x1000 data=0x7b |
| 10415 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 26 cycle(s)) |
| 10420 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 10425 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 10430 | ch0 driver | ch0: packet consumed (response delay 26) |
| 10450 | hbus driver | Executed READ  addr=0x1004 data=0x12 |
| 10455 | hbus monitor | Collected READ  addr=0x1004 data=0x12 |
| 10480 | hbus driver | Executed READ  addr=0x1005 data=0x0b |
| 10485 | hbus monitor | Collected READ  addr=0x1005 data=0x0b |
| 10510 | hbus driver | Executed READ  addr=0x1006 data=0x08 |
| 10515 | hbus monitor | Collected READ  addr=0x1006 data=0x08 |
| 10540 | hbus driver | Executed READ  addr=0x1009 data=0x0d |
| 10545 | hbus monitor | Collected READ  addr=0x1009 data=0x0d |
| 10570 | hbus driver | Executed READ  addr=0x100a data=0x0a |
| 10575 | hbus monitor | Collected READ  addr=0x100a data=0x0a |
| 10600 | hbus driver | Executed READ  addr=0x100b data=0x17 |
| 10605 | hbus monitor | Collected READ  addr=0x100b data=0x17 |
| 10630 | hbus driver | Executed READ  addr=0x100d data=0x02 |
| 10635 | hbus monitor | Collected READ  addr=0x100d data=0x02 |
| 10660 | hbus driver | Executed READ  addr=0x1010 data=0x08 |
| 10665 | hbus monitor | Collected READ  addr=0x1010 data=0x08 |
| 10690 | hbus driver | Executed READ  addr=0x1011 data=0x46 |
| 10695 | hbus monitor | Collected READ  addr=0x1011 data=0x46 |
| 10705 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 30 cycles |
| 10705 | ch0 monitor | ch0 RX pkt #8: addr=0 len=1 parity=good |
| 10705 | scoreboard | ch0 pkt matched: addr=0 len=1 (37 matched so far) |
| 10715 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=2 (receiver waited 0 cycle(s)) |
| 10720 | hbus driver | Executed READ  addr=0x1012 data=0x05 |
| 10725 | hbus monitor | Collected READ  addr=0x1012 data=0x05 |
| 10740 | ch1 driver | ch1: packet consumed (response delay 4) |
| 10745 | **DUT** | OUT ch0 pkt #9 done: 4 bytes in 4 cycles |
| 10745 | ch0 monitor | ch0 RX pkt #9: addr=0 len=2 parity=good |
| 10745 | scoreboard | ch0 pkt matched: addr=0 len=2 (38 matched so far) |
| 10820 | ch0 driver | ch0: packet consumed (response delay 26) |
| 10865 | **test** | STAGE: done: 56 packets (38 forwarded, 18 dropped), 3 storm burst(s), 38 scoreboard matches, 36 HBUS reads checked, 18 error pulses for 18 bad packets |
| 11065 | error checker | error pulse report: 18 bad packets, 18 pulses, 0 outside 1..10 cycles, at most 2 owed at once |
| 11065 | ch0 monitor | Channel 0 report: 9 packets collected |
| 11065 | ch1 monitor | Channel 1 report: 8 packets collected |
| 11065 | ch2 monitor | Channel 2 report: 21 packets collected |
| 11065 | hbus monitor | HBUS report: 20 writes, 37 reads |
| 11065 | coverage | Coverage of the router configuration: 78.3% |
| 11065 | coverage | HBUS address coverage: 57 accesses sampled, coverage 40.3% |
| 11065 | coverage | HBUS register bits coverage: 10 writes to ctrl_reg/en_reg, coverage 86.4% |
| 11065 | coverage | HBUS counter value coverage: 8 counter reads sampled, coverage 55.6% |
| 11065 | coverage | HBUS yapp_mem data coverage: 20 accesses sampled, coverage 29.4% |
| 11065 | reference |  |
| 11065 | reference | HBUS reads checked against the model: 36 (0 mismatches, 1 of memory bytes never written) |
| 11065 | scoreboard |  |
| 11065 | yapp driver | YAPP driver report: 56 packets sent |
| 11065 | coverage | YAPP gap coverage: 55 gaps sampled, coverage 75.0% |
| 11065 | yapp monitor | YAPP monitor report: 56 packets collected, 18 with bad parity |
| 11065 | yapp monitor | YAPP gaps: 44 back to back, 4 of 1 cycle, 0 of 2, 7 longer |
| 11065 | coverage | YAPP packet coverage: 56 packets sampled, coverage 73.3% |
