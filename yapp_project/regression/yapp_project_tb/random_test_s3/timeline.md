# random_test seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 6us · wall 4.1 s · log [`random_test_s3.log`](random_test_s3.log)

Waves: `random_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_test_s3%2Frandom_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **11** packet(s) (1 with bad parity); the input monitor saw 11.
- Router: **7** forwarded, **4** dropped (3 oversized, 1 illegal address 3).
- Packets out: ch0 **2**, ch1 **2**, ch2 **3**.
- Scoreboard: 7 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **2** time(s), longest hold 20 cycle(s).
- Error pulses: 1.
- HBUS: 6 write(s), 21 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_SLOW, ch1 CHANNEL_RX_PROFILE_SLOW, ch2 CHANNEL_RX_PROFILE_STALLY |
| 0 | random scenario: 11 packets in 2 bursts |
| 180 | burst 1/2: ctrl=0x9d (maxpktsize 29) en=0xff (router on, counter enables 1111111), 5 packet(s) |
| 2160 | burst 1/2 sent: addr0..3 2/1/2/0, bad parity 0, gap 0 1, length 1..63 |
| 2450 | burst 2/2: ctrl=0xfe (maxpktsize 62) en=0x77 (router on, counter enables 0111011), 6 packet(s) |
| 4800 | burst 2/2 sent: addr0..3 1/2/2/1, bad parity 1, gap 0 0, length 1..63 |
| 4800 | final reads: every register and the stored packet, checked against the reference model |
| 5435 | done: 11 packets (7 forwarded, 4 dropped), 0 storm burst(s), 7 scoreboard matches, 21 HBUS reads checked, 1 error pulses for 1 bad packets |

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

206 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_SLOW, ch1 CHANNEL_RX_PROFILE_SLOW, ch2 CHANNEL_RX_PROFILE_STALLY |
| 0 | **test** | STAGE: random scenario: 11 packets in 2 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x9d |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=29 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x9d |
| 75 | reference | maxpktsize is now 29 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 95 | reference | router_en is now 1 (en_reg 0xff) |
| 120 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 150 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 155 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 180 | hbus driver | Executed READ  addr=0x1007 data=0x00 |
| 180 | **test** | STAGE: burst 1/2: ctrl=0x9d (maxpktsize 29) en=0xff (router on, counter enables 1111111), 5 packet(s) |
| 180 | yapp driver | TX pkt #1: addr=2 len=1 parity=good delay=1 |
| 185 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 205 | **DUT** | IN  pkt #1 header: addr=2 len=1 -> channel 2 |
| 225 | **DUT** | IN  pkt #1 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 225 | yapp monitor | RX pkt #1 on the input: addr=2 len=1 parity=good gap=15 |
| 225 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 230 | yapp driver | TX pkt #1 accepted by the DUT |
| 230 | yapp driver | TX pkt #2: addr=0 len=1 parity=good delay=0 |
| 235 | **DUT** | IN  pkt #2 header: addr=0 len=1 -> channel 0 |
| 255 | **DUT** | IN  pkt #2 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 255 | yapp monitor | RX pkt #2 on the input: addr=0 len=1 parity=good gap=0 |
| 255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 260 | yapp driver | TX pkt #2 accepted by the DUT |
| 260 | yapp driver | TX pkt #3: addr=2 len=63 parity=good delay=1 |
| 275 | **DUT** | IN  pkt #3 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 29) |
| 315 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=1 (receiver waited 10 cycle(s)) |
| 330 | ch2 driver | ch2: packet consumed (response delay 10) |
| 385 | **DUT** | OUT ch2 pkt #1 done: 3 bytes in 8 cycles |
| 385 | ch2 monitor | ch2 RX pkt #1: addr=2 len=1 parity=good |
| 385 | scoreboard | ch2 pkt matched: addr=2 len=1 (1 matched so far) |
| 460 | ch2 driver | ch2: packet consumed (response delay 4) |
| 485 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 24 cycle(s)) |
| 500 | ch0 driver | ch0: packet consumed (response delay 24) |
| 825 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 35 cycles |
| 825 | ch0 monitor | ch0 RX pkt #1: addr=0 len=1 parity=good |
| 825 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 900 | ch0 driver | ch0: packet consumed (response delay 31) |
| 915 | **DUT** | IN  pkt #3 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 915 | yapp monitor | RX pkt #3 on the input: addr=2 len=63 parity=good gap=1 |
| 915 | reference | Packet dropped: length 63 > maxpktsize 29 (addr=2) |
| 915 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 920 | yapp driver | TX pkt #3 accepted by the DUT |
| 920 | yapp driver | TX pkt #4: addr=0 len=63 parity=good delay=3 |
| 955 | **DUT** | IN  pkt #4 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 29) |
| 1595 | **DUT** | IN  pkt #4 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1595 | yapp monitor | RX pkt #4 on the input: addr=0 len=63 parity=good gap=3 |
| 1595 | reference | Packet dropped: length 63 > maxpktsize 29 (addr=0) |
| 1595 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 1600 | yapp driver | TX pkt #4 accepted by the DUT |
| 1600 | yapp driver | TX pkt #5: addr=1 len=28 parity=good delay=6 |
| 1665 | **DUT** | IN  pkt #5 header: addr=1 len=28 -> channel 1 |
| 1825 | **DUT** | SUSPEND asserted: FIFO 1 full, byte 0xff held (pkt #5) |
| 2015 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=28 (receiver waited 34 cycle(s)) |
| 2025 | **DUT** | SUSPEND released after 20 cycle(s) |
| 2155 | **DUT** | IN  pkt #5 complete: addr=1 len=28 parity=ok forwarded, 30 bytes in 50 cycles (held 20) |
| 2155 | yapp monitor | RX pkt #5 on the input: addr=1 len=28 parity=good gap=6 |
| 2155 | reference | Packet forwarded: addr=1 len=28 -> channel 1 |
| 2160 | yapp driver | TX pkt #5 accepted by the DUT |
| 2160 | **test** | STAGE: burst 1/2 sent: addr0..3 2/1/2/0, bad parity 0, gap 0 1, length 1..63 |
| 2180 | hbus driver | Executed WRITE addr=0x1000 data=0xfe |
| 2185 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 2185 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 2185 | reference | maxpktsize is now 62 |
| 2200 | hbus driver | Executed WRITE addr=0x1001 data=0x77 |
| 2205 | hbus monitor | Collected WRITE addr=0x1001 data=0x77 |
| 2205 | reference | router_en is now 1 (en_reg 0x77) |
| 2230 | hbus driver | Executed READ  addr=0x100d data=0x1c |
| 2235 | hbus monitor | Collected READ  addr=0x100d data=0x1c |
| 2260 | hbus driver | Executed READ  addr=0x1011 data=0xc4 |
| 2265 | hbus monitor | Collected READ  addr=0x1011 data=0xc4 |
| 2280 | hbus driver | Executed WRITE addr=0x1195 data=0x6c |
| 2285 | hbus monitor | Collected WRITE addr=0x1195 data=0x6c |
| 2300 | ch1 driver | ch1: packet consumed (response delay 34) |
| 2310 | hbus driver | Executed READ  addr=0x1195 data=0x6c |
| 2315 | hbus monitor | Collected READ  addr=0x1195 data=0x6c |
| 2340 | hbus driver | Executed READ  addr=0x1019 data=0xaa |
| 2345 | hbus monitor | Collected READ  addr=0x1019 data=0xaa |
| 2370 | hbus driver | Executed READ  addr=0x100d data=0x1c |
| 2375 | hbus monitor | Collected READ  addr=0x100d data=0x1c |
| 2390 | hbus driver | Executed WRITE addr=0x1151 data=0xf4 |
| 2395 | hbus monitor | Collected WRITE addr=0x1151 data=0xf4 |
| 2420 | hbus driver | Executed READ  addr=0x1151 data=0xf4 |
| 2425 | hbus monitor | Collected READ  addr=0x1151 data=0xf4 |
| 2450 | hbus driver | Executed READ  addr=0x1092 data=0x00 |
| 2450 | **test** | STAGE: burst 2/2: ctrl=0xfe (maxpktsize 62) en=0x77 (router on, counter enables 0111011), 6 packet(s) |
| 2450 | yapp driver | TX pkt #6: addr=3 len=6 parity=good delay=16 |
| 2455 | hbus monitor | Collected READ  addr=0x1092 data=0x00 |
| 2625 | **DUT** | IN  pkt #6 header: addr=3 len=6 -> DROP (illegal address 3) |
| 2655 | **DUT** | OUT ch1 pkt #1 done: 30 bytes in 65 cycles |
| 2655 | ch1 monitor | ch1 RX pkt #1: addr=1 len=28 parity=good |
| 2655 | scoreboard | ch1 pkt matched: addr=1 len=28 (3 matched so far) |
| 2695 | **DUT** | IN  pkt #6 complete: addr=3 len=6 parity=ok dropped, 8 bytes in 8 cycles (held 0) |
| 2695 | yapp monitor | RX pkt #6 on the input: addr=3 len=6 parity=good gap=46 |
| 2695 | reference | Packet dropped: illegal address 3 (len=6) |
| 2695 | **DUT** | ROUTER DROPS PACKET addr=3 length=6 (    illegal address) |
| 2700 | yapp driver | TX pkt #6 accepted by the DUT |
| 2700 | yapp driver | TX pkt #7: addr=2 len=52 parity=good delay=1 |
| 2715 | **DUT** | IN  pkt #7 header: addr=2 len=52 -> channel 2 |
| 2785 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=52 (receiver waited 6 cycle(s)) |
| 3190 | ch1 driver | ch1: packet consumed (response delay 34) |
| 3245 | **DUT** | IN  pkt #7 complete: addr=2 len=52 parity=ok forwarded, 54 bytes in 54 cycles (held 0) |
| 3245 | yapp monitor | RX pkt #7 on the input: addr=2 len=52 parity=good gap=1 |
| 3245 | reference | Packet forwarded: addr=2 len=52 -> channel 2 |
| 3250 | yapp driver | TX pkt #7 accepted by the DUT |
| 3250 | yapp driver | TX pkt #8: addr=2 len=13 parity=bad delay=8 |
| 3310 | ch2 driver | ch2: packet consumed (response delay 6) |
| 3335 | **DUT** | IN  pkt #8 header: addr=2 len=13 -> channel 2 |
| 3395 | **DUT** | OUT ch2 pkt #2 done: 54 bytes in 62 cycles |
| 3395 | ch2 monitor | ch2 RX pkt #2: addr=2 len=52 parity=good |
| 3395 | scoreboard | ch2 pkt matched: addr=2 len=52 (4 matched so far) |
| 3405 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=13 (receiver waited 0 cycle(s)) |
| 3475 | **DUT** | IN  pkt #8 complete: addr=2 len=13 parity=BAD forwarded, 15 bytes in 15 cycles (held 0) |
| 3475 | yapp monitor | RX pkt #8 on the input: addr=2 len=13 parity=bad gap=8 |
| 3475 | reference | Packet forwarded: addr=2 len=13 -> channel 2 |
| 3480 | yapp driver | TX pkt #8 accepted by the DUT |
| 3480 | yapp driver | TX pkt #9: addr=1 len=63 parity=good delay=3 |
| 3515 | **DUT** | IN  pkt #9 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 3545 | **DUT** | OUT ch2 pkt #3 done: 15 bytes in 15 cycles |
| 3545 | ch2 monitor | ch2 RX pkt #3: addr=2 len=13 parity=bad |
| 3545 | scoreboard | ch2 pkt matched: addr=2 len=13 (5 matched so far) |
| 3550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 3550 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 3860 | ch2 driver | ch2: packet consumed (response delay 7) |
| 4155 | **DUT** | IN  pkt #9 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4155 | yapp monitor | RX pkt #9 on the input: addr=1 len=63 parity=good gap=3 |
| 4155 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=1) |
| 4155 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 4160 | yapp driver | TX pkt #9 accepted by the DUT |
| 4160 | yapp driver | TX pkt #10: addr=0 len=28 parity=good delay=20 |
| 4365 | **DUT** | IN  pkt #10 header: addr=0 len=28 -> channel 0 |
| 4525 | **DUT** | SUSPEND asserted: FIFO 0 full, byte 0xcb held (pkt #10) |
| 4615 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=28 (receiver waited 24 cycle(s)) |
| 4625 | **DUT** | SUSPEND released after 10 cycle(s) |
| 4755 | **DUT** | IN  pkt #10 complete: addr=0 len=28 parity=ok forwarded, 30 bytes in 40 cycles (held 10) |
| 4755 | yapp monitor | RX pkt #10 on the input: addr=0 len=28 parity=good gap=20 |
| 4755 | reference | Packet forwarded: addr=0 len=28 -> channel 0 |
| 4760 | yapp driver | TX pkt #10 accepted by the DUT |
| 4760 | yapp driver | TX pkt #11: addr=1 len=1 parity=good delay=1 |
| 4775 | **DUT** | IN  pkt #11 header: addr=1 len=1 -> channel 1 |
| 4795 | **DUT** | IN  pkt #11 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4795 | yapp monitor | RX pkt #11 on the input: addr=1 len=1 parity=good gap=1 |
| 4795 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 4800 | yapp driver | TX pkt #11 accepted by the DUT |
| 4800 | **test** | STAGE: burst 2/2 sent: addr0..3 1/2/2/1, bad parity 1, gap 0 0, length 1..63 |
| 4800 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 4830 | hbus driver | Executed READ  addr=0x1000 data=0xfe |
| 4835 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 4860 | hbus driver | Executed READ  addr=0x1001 data=0x77 |
| 4865 | hbus monitor | Collected READ  addr=0x1001 data=0x77 |
| 4890 | hbus driver | Executed READ  addr=0x1004 data=0x01 |
| 4895 | hbus monitor | Collected READ  addr=0x1004 data=0x01 |
| 4900 | ch0 driver | ch0: packet consumed (response delay 24) |
| 4920 | hbus driver | Executed READ  addr=0x1005 data=0x03 |
| 4925 | hbus monitor | Collected READ  addr=0x1005 data=0x03 |
| 4950 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 4955 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4980 | hbus driver | Executed READ  addr=0x1009 data=0x03 |
| 4985 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=1 (receiver waited 20 cycle(s)) |
| 4985 | hbus monitor | Collected READ  addr=0x1009 data=0x03 |
| 5000 | ch1 driver | ch1: packet consumed (response delay 20) |
| 5010 | hbus driver | Executed READ  addr=0x100a data=0x03 |
| 5015 | hbus monitor | Collected READ  addr=0x100a data=0x03 |
| 5040 | hbus driver | Executed READ  addr=0x100b data=0x04 |
| 5045 | hbus monitor | Collected READ  addr=0x100b data=0x04 |
| 5070 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 5075 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 5100 | hbus driver | Executed READ  addr=0x1010 data=0x05 |
| 5105 | hbus monitor | Collected READ  addr=0x1010 data=0x05 |
| 5130 | hbus driver | Executed READ  addr=0x1011 data=0x0f |
| 5135 | hbus monitor | Collected READ  addr=0x1011 data=0x0f |
| 5215 | **DUT** | OUT ch1 pkt #2 done: 3 bytes in 24 cycles |
| 5215 | ch1 monitor | ch1 RX pkt #2: addr=1 len=1 parity=good |
| 5215 | scoreboard | ch1 pkt matched: addr=1 len=1 (6 matched so far) |
| 5240 | ch1 driver | ch1: packet consumed (response delay 20) |
| 5315 | **DUT** | OUT ch0 pkt #2 done: 30 bytes in 71 cycles |
| 5315 | ch0 monitor | ch0 RX pkt #2: addr=0 len=28 parity=good |
| 5315 | scoreboard | ch0 pkt matched: addr=0 len=28 (7 matched so far) |
| 5435 | **test** | STAGE: done: 11 packets (7 forwarded, 4 dropped), 0 storm burst(s), 7 scoreboard matches, 21 HBUS reads checked, 1 error pulses for 1 bad packets |
| 5480 | ch0 driver | ch0: packet consumed (response delay 40) |
| 5635 | error checker | error pulse report: 1 bad packets, 1 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 5635 | ch0 monitor | Channel 0 report: 2 packets collected |
| 5635 | ch1 monitor | Channel 1 report: 2 packets collected |
| 5635 | ch2 monitor | Channel 2 report: 3 packets collected |
| 5635 | hbus monitor | HBUS report: 6 writes, 21 reads |
| 5635 | coverage | Coverage of the router configuration: 69.6% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 0 / 0 / 5 / 6 / 0 packets · length < max / = max / max+1 / > max+1 : 8 / 0 / 1 / 2 · forwarded good / bad : 6 / 1 · dropped address 3 good / bad : 1 / 0 · dropped oversized good / bad : 3 / 0 · counter enables none / mixed / all : 0 / 6 / 5 |
| 5635 | coverage | HBUS address coverage: 27 accesses sampled, coverage 42.9% |
| 5635 | coverage | HBUS register bits coverage: 4 writes to ctrl_reg/en_reg, coverage 77.3% |
| 5635 | coverage | HBUS counter value coverage: 6 counter reads sampled, coverage 51.9% |
| 5635 | coverage | HBUS yapp_mem data coverage: 4 accesses sampled, coverage 29.4% |
| 5635 | reference | --- Reference model report --- · forwarded to scoreboard : 7 · dropped (router disabled) : 0 · dropped (oversized) : 3 · dropped (address 3) : 1 · counters parity/oversized/addr0..3 : 1 / 3 / 3 3 4 0 |
| 5635 | reference | HBUS reads checked against the model: 21 (0 mismatches, 0 of memory bytes never written) |
| 5635 | scoreboard | --- Scoreboard report --- · packets received : 7 · packets matched : 7 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 5635 | yapp driver | YAPP driver report: 11 packets sent |
| 5635 | coverage | YAPP gap coverage: 10 gaps sampled, coverage 75.0% |
| 5635 | yapp monitor | YAPP monitor report: 11 packets collected, 1 with bad parity |
| 5635 | yapp monitor | YAPP gaps: 1 back to back, 3 of 1 cycle, 0 of 2, 6 longer |
| 5635 | coverage | YAPP packet coverage: 11 packets sampled, coverage 53.3% |
