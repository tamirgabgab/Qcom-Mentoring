# counter_wrap_test seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 42us · wall 10.9 s · log [`counter_wrap_test_s4.log`](counter_wrap_test_s4.log)

Waves: `counter_wrap_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fcounter_wrap_test_s4%2Fcounter_wrap_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **257** packet(s) (0 with bad parity); the input monitor saw 257.
- Router: **257** forwarded, **0** dropped.
- Packets out: ch0 **257**, ch1 **0**, ch2 **0**.
- Scoreboard: 257 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 1 write(s), 8 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 70 | 1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255 |
| 41670 | 2. the 256th packet wraps addr0_cnt_reg to 0 |
| 41750 | 3. one more packet: the counter goes on from 0 |
| 41990 | 4. the other counters are untouched and the scoreboard matched all 257 packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 0**

![first packet out on channel 0](wave_first_packet_out.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

2770 events; this table keeps the 1576 of the test, the DUT, the host bus, the checkers' reports and every warning or error, and only the first 1500 of those. The full list is in the log.

| time (ns) | who | event |
|---|---|---|
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | **test** | STAGE: 1. 255 one-byte packets to address 0: addr0_cnt_reg reaches 255 |
| 75 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 75 | reference | router_en is now 1 (en_reg 0xff) |
| 125 | **DUT** | IN  pkt #1 header: addr=0 len=1 -> channel 0 |
| 145 | **DUT** | IN  pkt #1 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 215 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 345 | **DUT** | IN  pkt #2 header: addr=0 len=1 -> channel 0 |
| 345 | **DUT** | OUT ch0 pkt #1 done: 3 bytes in 14 cycles |
| 345 | scoreboard | ch0 pkt matched: addr=0 len=1 (1 matched so far) |
| 355 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 365 | **DUT** | IN  pkt #2 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 365 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 435 | **DUT** | OUT ch0 pkt #2 done: 3 bytes in 9 cycles |
| 435 | scoreboard | ch0 pkt matched: addr=0 len=1 (2 matched so far) |
| 575 | **DUT** | IN  pkt #3 header: addr=0 len=1 -> channel 0 |
| 585 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 595 | **DUT** | IN  pkt #3 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 595 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 605 | **DUT** | OUT ch0 pkt #3 done: 3 bytes in 3 cycles |
| 605 | scoreboard | ch0 pkt matched: addr=0 len=1 (3 matched so far) |
| 725 | **DUT** | IN  pkt #4 header: addr=0 len=1 -> channel 0 |
| 735 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 745 | **DUT** | IN  pkt #4 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 755 | **DUT** | OUT ch0 pkt #4 done: 3 bytes in 3 cycles |
| 755 | scoreboard | ch0 pkt matched: addr=0 len=1 (4 matched so far) |
| 955 | **DUT** | IN  pkt #5 header: addr=0 len=1 -> channel 0 |
| 975 | **DUT** | IN  pkt #5 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1025 | **DUT** | IN  pkt #6 header: addr=0 len=1 -> channel 0 |
| 1045 | **DUT** | IN  pkt #6 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1065 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 1195 | **DUT** | OUT ch0 pkt #5 done: 3 bytes in 14 cycles |
| 1195 | scoreboard | ch0 pkt matched: addr=0 len=1 (5 matched so far) |
| 1205 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1225 | **DUT** | OUT ch0 pkt #6 done: 3 bytes in 3 cycles |
| 1225 | scoreboard | ch0 pkt matched: addr=0 len=1 (6 matched so far) |
| 1255 | **DUT** | IN  pkt #7 header: addr=0 len=1 -> channel 0 |
| 1265 | **DUT** | OUT ch0 pkt #7 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1275 | **DUT** | IN  pkt #7 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1285 | **DUT** | OUT ch0 pkt #7 done: 3 bytes in 3 cycles |
| 1285 | scoreboard | ch0 pkt matched: addr=0 len=1 (7 matched so far) |
| 1485 | **DUT** | IN  pkt #8 header: addr=0 len=1 -> channel 0 |
| 1505 | **DUT** | IN  pkt #8 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1555 | **DUT** | IN  pkt #9 header: addr=0 len=1 -> channel 0 |
| 1575 | **DUT** | IN  pkt #9 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1575 | **DUT** | OUT ch0 pkt #8 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 1575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1595 | **DUT** | IN  pkt #10 header: addr=0 len=1 -> channel 0 |
| 1615 | **DUT** | IN  pkt #10 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1615 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1705 | **DUT** | OUT ch0 pkt #8 done: 3 bytes in 14 cycles |
| 1705 | scoreboard | ch0 pkt matched: addr=0 len=1 (8 matched so far) |
| 1715 | **DUT** | OUT ch0 pkt #9 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1725 | **DUT** | IN  pkt #11 header: addr=0 len=1 -> channel 0 |
| 1735 | **DUT** | OUT ch0 pkt #9 done: 3 bytes in 3 cycles |
| 1735 | scoreboard | ch0 pkt matched: addr=0 len=1 (9 matched so far) |
| 1745 | **DUT** | IN  pkt #11 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1745 | **DUT** | OUT ch0 pkt #10 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1765 | **DUT** | OUT ch0 pkt #10 done: 3 bytes in 3 cycles |
| 1765 | scoreboard | ch0 pkt matched: addr=0 len=1 (10 matched so far) |
| 1775 | **DUT** | OUT ch0 pkt #11 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1795 | **DUT** | OUT ch0 pkt #11 done: 3 bytes in 3 cycles |
| 1795 | scoreboard | ch0 pkt matched: addr=0 len=1 (11 matched so far) |
| 1915 | **DUT** | IN  pkt #12 header: addr=0 len=1 -> channel 0 |
| 1925 | **DUT** | OUT ch0 pkt #12 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 1935 | **DUT** | IN  pkt #12 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 1935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 1945 | **DUT** | OUT ch0 pkt #12 done: 3 bytes in 3 cycles |
| 1945 | scoreboard | ch0 pkt matched: addr=0 len=1 (12 matched so far) |
| 2145 | **DUT** | IN  pkt #13 header: addr=0 len=1 -> channel 0 |
| 2165 | **DUT** | IN  pkt #13 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2205 | **DUT** | OUT ch0 pkt #13 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 2275 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> channel 0 |
| 2295 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2295 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2325 | **DUT** | OUT ch0 pkt #13 done: 3 bytes in 13 cycles |
| 2325 | scoreboard | ch0 pkt matched: addr=0 len=1 (13 matched so far) |
| 2335 | **DUT** | OUT ch0 pkt #14 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2355 | **DUT** | OUT ch0 pkt #14 done: 3 bytes in 3 cycles |
| 2355 | scoreboard | ch0 pkt matched: addr=0 len=1 (14 matched so far) |
| 2445 | **DUT** | IN  pkt #15 header: addr=0 len=1 -> channel 0 |
| 2465 | **DUT** | IN  pkt #15 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2495 | **DUT** | OUT ch0 pkt #15 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 2555 | **DUT** | OUT ch0 pkt #15 done: 3 bytes in 7 cycles |
| 2555 | scoreboard | ch0 pkt matched: addr=0 len=1 (15 matched so far) |
| 2565 | **DUT** | IN  pkt #16 header: addr=0 len=1 -> channel 0 |
| 2575 | **DUT** | OUT ch0 pkt #16 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2585 | **DUT** | IN  pkt #16 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2595 | **DUT** | OUT ch0 pkt #16 done: 3 bytes in 3 cycles |
| 2595 | scoreboard | ch0 pkt matched: addr=0 len=1 (16 matched so far) |
| 2765 | **DUT** | IN  pkt #17 header: addr=0 len=1 -> channel 0 |
| 2785 | **DUT** | IN  pkt #17 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2805 | **DUT** | OUT ch0 pkt #17 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 2835 | **DUT** | OUT ch0 pkt #17 done: 3 bytes in 4 cycles |
| 2835 | scoreboard | ch0 pkt matched: addr=0 len=1 (17 matched so far) |
| 2965 | **DUT** | IN  pkt #18 header: addr=0 len=1 -> channel 0 |
| 2975 | **DUT** | OUT ch0 pkt #18 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 2985 | **DUT** | IN  pkt #18 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 2985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 2995 | **DUT** | OUT ch0 pkt #18 done: 3 bytes in 3 cycles |
| 2995 | scoreboard | ch0 pkt matched: addr=0 len=1 (18 matched so far) |
| 3165 | **DUT** | IN  pkt #19 header: addr=0 len=1 -> channel 0 |
| 3175 | **DUT** | OUT ch0 pkt #19 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3185 | **DUT** | IN  pkt #19 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3195 | **DUT** | OUT ch0 pkt #19 done: 3 bytes in 3 cycles |
| 3195 | scoreboard | ch0 pkt matched: addr=0 len=1 (19 matched so far) |
| 3395 | **DUT** | IN  pkt #20 header: addr=0 len=1 -> channel 0 |
| 3415 | **DUT** | IN  pkt #20 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3485 | **DUT** | IN  pkt #21 header: addr=0 len=1 -> channel 0 |
| 3495 | **DUT** | OUT ch0 pkt #20 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 3505 | **DUT** | IN  pkt #21 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3555 | **DUT** | IN  pkt #22 header: addr=0 len=1 -> channel 0 |
| 3575 | **DUT** | IN  pkt #22 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3625 | **DUT** | OUT ch0 pkt #20 done: 3 bytes in 14 cycles |
| 3625 | scoreboard | ch0 pkt matched: addr=0 len=1 (20 matched so far) |
| 3635 | **DUT** | OUT ch0 pkt #21 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3655 | **DUT** | OUT ch0 pkt #21 done: 3 bytes in 3 cycles |
| 3655 | scoreboard | ch0 pkt matched: addr=0 len=1 (21 matched so far) |
| 3665 | **DUT** | OUT ch0 pkt #22 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3685 | **DUT** | OUT ch0 pkt #22 done: 3 bytes in 3 cycles |
| 3685 | scoreboard | ch0 pkt matched: addr=0 len=1 (22 matched so far) |
| 3695 | **DUT** | IN  pkt #23 header: addr=0 len=1 -> channel 0 |
| 3715 | **DUT** | IN  pkt #23 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3785 | **DUT** | OUT ch0 pkt #23 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 3875 | **DUT** | OUT ch0 pkt #23 done: 3 bytes in 10 cycles |
| 3875 | scoreboard | ch0 pkt matched: addr=0 len=1 (23 matched so far) |
| 3895 | **DUT** | IN  pkt #24 header: addr=0 len=1 -> channel 0 |
| 3905 | **DUT** | OUT ch0 pkt #24 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 3915 | **DUT** | IN  pkt #24 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 3915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 3925 | **DUT** | OUT ch0 pkt #24 done: 3 bytes in 3 cycles |
| 3925 | scoreboard | ch0 pkt matched: addr=0 len=1 (24 matched so far) |
| 4125 | **DUT** | IN  pkt #25 header: addr=0 len=1 -> channel 0 |
| 4135 | **DUT** | OUT ch0 pkt #25 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4145 | **DUT** | IN  pkt #25 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4145 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4155 | **DUT** | OUT ch0 pkt #25 done: 3 bytes in 3 cycles |
| 4155 | scoreboard | ch0 pkt matched: addr=0 len=1 (25 matched so far) |
| 4305 | **DUT** | IN  pkt #26 header: addr=0 len=1 -> channel 0 |
| 4315 | **DUT** | OUT ch0 pkt #26 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4325 | **DUT** | IN  pkt #26 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4335 | **DUT** | OUT ch0 pkt #26 done: 3 bytes in 3 cycles |
| 4335 | scoreboard | ch0 pkt matched: addr=0 len=1 (26 matched so far) |
| 4425 | **DUT** | IN  pkt #27 header: addr=0 len=1 -> channel 0 |
| 4445 | **DUT** | IN  pkt #27 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4465 | **DUT** | IN  pkt #28 header: addr=0 len=1 -> channel 0 |
| 4475 | **DUT** | OUT ch0 pkt #27 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 4485 | **DUT** | IN  pkt #28 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4605 | **DUT** | IN  pkt #29 header: addr=0 len=1 -> channel 0 |
| 4605 | **DUT** | OUT ch0 pkt #27 done: 3 bytes in 14 cycles |
| 4605 | scoreboard | ch0 pkt matched: addr=0 len=1 (27 matched so far) |
| 4615 | **DUT** | OUT ch0 pkt #28 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4625 | **DUT** | IN  pkt #29 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4635 | **DUT** | OUT ch0 pkt #28 done: 3 bytes in 3 cycles |
| 4635 | scoreboard | ch0 pkt matched: addr=0 len=1 (28 matched so far) |
| 4645 | **DUT** | OUT ch0 pkt #29 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4665 | **DUT** | OUT ch0 pkt #29 done: 3 bytes in 3 cycles |
| 4665 | scoreboard | ch0 pkt matched: addr=0 len=1 (29 matched so far) |
| 4775 | **DUT** | IN  pkt #30 header: addr=0 len=1 -> channel 0 |
| 4785 | **DUT** | OUT ch0 pkt #30 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 4795 | **DUT** | IN  pkt #30 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 4795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 4805 | **DUT** | OUT ch0 pkt #30 done: 3 bytes in 3 cycles |
| 4805 | scoreboard | ch0 pkt matched: addr=0 len=1 (30 matched so far) |
| 5005 | **DUT** | IN  pkt #31 header: addr=0 len=1 -> channel 0 |
| 5025 | **DUT** | IN  pkt #31 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5065 | **DUT** | OUT ch0 pkt #31 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 5185 | **DUT** | OUT ch0 pkt #31 done: 3 bytes in 13 cycles |
| 5185 | scoreboard | ch0 pkt matched: addr=0 len=1 (31 matched so far) |
| 5235 | **DUT** | IN  pkt #32 header: addr=0 len=1 -> channel 0 |
| 5245 | **DUT** | OUT ch0 pkt #32 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5255 | **DUT** | IN  pkt #32 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5265 | **DUT** | OUT ch0 pkt #32 done: 3 bytes in 3 cycles |
| 5265 | scoreboard | ch0 pkt matched: addr=0 len=1 (32 matched so far) |
| 5425 | **DUT** | IN  pkt #33 header: addr=0 len=1 -> channel 0 |
| 5435 | **DUT** | OUT ch0 pkt #33 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5445 | **DUT** | IN  pkt #33 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5455 | **DUT** | OUT ch0 pkt #33 done: 3 bytes in 3 cycles |
| 5455 | scoreboard | ch0 pkt matched: addr=0 len=1 (33 matched so far) |
| 5555 | **DUT** | IN  pkt #34 header: addr=0 len=1 -> channel 0 |
| 5575 | **DUT** | IN  pkt #34 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5645 | **DUT** | OUT ch0 pkt #34 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 5705 | **DUT** | IN  pkt #35 header: addr=0 len=1 -> channel 0 |
| 5725 | **DUT** | IN  pkt #35 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5775 | **DUT** | OUT ch0 pkt #34 done: 3 bytes in 14 cycles |
| 5775 | scoreboard | ch0 pkt matched: addr=0 len=1 (34 matched so far) |
| 5785 | **DUT** | OUT ch0 pkt #35 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5805 | **DUT** | OUT ch0 pkt #35 done: 3 bytes in 3 cycles |
| 5805 | scoreboard | ch0 pkt matched: addr=0 len=1 (35 matched so far) |
| 5935 | **DUT** | IN  pkt #36 header: addr=0 len=1 -> channel 0 |
| 5945 | **DUT** | OUT ch0 pkt #36 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 5955 | **DUT** | IN  pkt #36 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 5955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 5965 | **DUT** | OUT ch0 pkt #36 done: 3 bytes in 3 cycles |
| 5965 | scoreboard | ch0 pkt matched: addr=0 len=1 (36 matched so far) |
| 6165 | **DUT** | IN  pkt #37 header: addr=0 len=1 -> channel 0 |
| 6185 | **DUT** | IN  pkt #37 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6255 | **DUT** | OUT ch0 pkt #37 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 6285 | **DUT** | OUT ch0 pkt #37 done: 3 bytes in 4 cycles |
| 6285 | scoreboard | ch0 pkt matched: addr=0 len=1 (37 matched so far) |
| 6395 | **DUT** | IN  pkt #38 header: addr=0 len=1 -> channel 0 |
| 6405 | **DUT** | OUT ch0 pkt #38 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6415 | **DUT** | IN  pkt #38 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6415 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6425 | **DUT** | OUT ch0 pkt #38 done: 3 bytes in 3 cycles |
| 6425 | scoreboard | ch0 pkt matched: addr=0 len=1 (38 matched so far) |
| 6625 | **DUT** | IN  pkt #39 header: addr=0 len=1 -> channel 0 |
| 6645 | **DUT** | IN  pkt #39 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6735 | **DUT** | OUT ch0 pkt #39 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 6825 | **DUT** | OUT ch0 pkt #39 done: 3 bytes in 10 cycles |
| 6825 | scoreboard | ch0 pkt matched: addr=0 len=1 (39 matched so far) |
| 6855 | **DUT** | IN  pkt #40 header: addr=0 len=1 -> channel 0 |
| 6865 | **DUT** | OUT ch0 pkt #40 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6875 | **DUT** | IN  pkt #40 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6885 | **DUT** | OUT ch0 pkt #40 done: 3 bytes in 3 cycles |
| 6885 | scoreboard | ch0 pkt matched: addr=0 len=1 (40 matched so far) |
| 6895 | **DUT** | IN  pkt #41 header: addr=0 len=1 -> channel 0 |
| 6905 | **DUT** | OUT ch0 pkt #41 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 6915 | **DUT** | IN  pkt #41 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 6915 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 6925 | **DUT** | OUT ch0 pkt #41 done: 3 bytes in 3 cycles |
| 6925 | scoreboard | ch0 pkt matched: addr=0 len=1 (41 matched so far) |
| 7095 | **DUT** | IN  pkt #42 header: addr=0 len=1 -> channel 0 |
| 7115 | **DUT** | IN  pkt #42 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7185 | **DUT** | OUT ch0 pkt #42 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 7225 | **DUT** | IN  pkt #43 header: addr=0 len=1 -> channel 0 |
| 7245 | **DUT** | IN  pkt #43 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7315 | **DUT** | OUT ch0 pkt #42 done: 3 bytes in 14 cycles |
| 7315 | scoreboard | ch0 pkt matched: addr=0 len=1 (42 matched so far) |
| 7325 | **DUT** | OUT ch0 pkt #43 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7345 | **DUT** | OUT ch0 pkt #43 done: 3 bytes in 3 cycles |
| 7345 | scoreboard | ch0 pkt matched: addr=0 len=1 (43 matched so far) |
| 7455 | **DUT** | IN  pkt #44 header: addr=0 len=1 -> channel 0 |
| 7465 | **DUT** | OUT ch0 pkt #44 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7475 | **DUT** | IN  pkt #44 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7485 | **DUT** | OUT ch0 pkt #44 done: 3 bytes in 3 cycles |
| 7485 | scoreboard | ch0 pkt matched: addr=0 len=1 (44 matched so far) |
| 7645 | **DUT** | IN  pkt #45 header: addr=0 len=1 -> channel 0 |
| 7665 | **DUT** | IN  pkt #45 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7765 | **DUT** | OUT ch0 pkt #45 start: addr=0 len=1 (receiver waited 11 cycle(s)) |
| 7875 | **DUT** | IN  pkt #46 header: addr=0 len=1 -> channel 0 |
| 7885 | **DUT** | OUT ch0 pkt #45 done: 3 bytes in 13 cycles |
| 7885 | scoreboard | ch0 pkt matched: addr=0 len=1 (45 matched so far) |
| 7895 | **DUT** | IN  pkt #46 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7895 | **DUT** | OUT ch0 pkt #46 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7915 | **DUT** | OUT ch0 pkt #46 done: 3 bytes in 3 cycles |
| 7915 | scoreboard | ch0 pkt matched: addr=0 len=1 (46 matched so far) |
| 7935 | **DUT** | IN  pkt #47 header: addr=0 len=1 -> channel 0 |
| 7945 | **DUT** | OUT ch0 pkt #47 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 7955 | **DUT** | IN  pkt #47 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 7955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 7965 | **DUT** | OUT ch0 pkt #47 done: 3 bytes in 3 cycles |
| 7965 | scoreboard | ch0 pkt matched: addr=0 len=1 (47 matched so far) |
| 8165 | **DUT** | IN  pkt #48 header: addr=0 len=1 -> channel 0 |
| 8185 | **DUT** | IN  pkt #48 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8255 | **DUT** | OUT ch0 pkt #48 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 8365 | **DUT** | IN  pkt #49 header: addr=0 len=1 -> channel 0 |
| 8375 | **DUT** | OUT ch0 pkt #48 done: 3 bytes in 13 cycles |
| 8375 | scoreboard | ch0 pkt matched: addr=0 len=1 (48 matched so far) |
| 8385 | **DUT** | IN  pkt #49 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8385 | **DUT** | OUT ch0 pkt #49 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8385 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8405 | **DUT** | OUT ch0 pkt #49 done: 3 bytes in 3 cycles |
| 8405 | scoreboard | ch0 pkt matched: addr=0 len=1 (49 matched so far) |
| 8575 | **DUT** | IN  pkt #50 header: addr=0 len=1 -> channel 0 |
| 8585 | **DUT** | OUT ch0 pkt #50 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8595 | **DUT** | IN  pkt #50 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8595 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8615 | **DUT** | IN  pkt #51 header: addr=0 len=1 -> channel 0 |
| 8635 | **DUT** | IN  pkt #51 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8675 | **DUT** | OUT ch0 pkt #50 done: 3 bytes in 10 cycles |
| 8675 | scoreboard | ch0 pkt matched: addr=0 len=1 (50 matched so far) |
| 8685 | **DUT** | OUT ch0 pkt #51 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8705 | **DUT** | OUT ch0 pkt #51 done: 3 bytes in 3 cycles |
| 8705 | scoreboard | ch0 pkt matched: addr=0 len=1 (51 matched so far) |
| 8845 | **DUT** | IN  pkt #52 header: addr=0 len=1 -> channel 0 |
| 8855 | **DUT** | OUT ch0 pkt #52 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 8865 | **DUT** | IN  pkt #52 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 8865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 8875 | **DUT** | OUT ch0 pkt #52 done: 3 bytes in 3 cycles |
| 8875 | scoreboard | ch0 pkt matched: addr=0 len=1 (52 matched so far) |
| 9025 | **DUT** | IN  pkt #53 header: addr=0 len=1 -> channel 0 |
| 9035 | **DUT** | OUT ch0 pkt #53 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9045 | **DUT** | IN  pkt #53 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9045 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9055 | **DUT** | OUT ch0 pkt #53 done: 3 bytes in 3 cycles |
| 9055 | scoreboard | ch0 pkt matched: addr=0 len=1 (53 matched so far) |
| 9225 | **DUT** | IN  pkt #54 header: addr=0 len=1 -> channel 0 |
| 9245 | **DUT** | IN  pkt #54 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9245 | **DUT** | OUT ch0 pkt #54 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 9245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9315 | **DUT** | OUT ch0 pkt #54 done: 3 bytes in 8 cycles |
| 9315 | scoreboard | ch0 pkt matched: addr=0 len=1 (54 matched so far) |
| 9425 | **DUT** | IN  pkt #55 header: addr=0 len=1 -> channel 0 |
| 9445 | **DUT** | IN  pkt #55 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9525 | **DUT** | OUT ch0 pkt #55 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 9645 | **DUT** | OUT ch0 pkt #55 done: 3 bytes in 13 cycles |
| 9645 | scoreboard | ch0 pkt matched: addr=0 len=1 (55 matched so far) |
| 9655 | **DUT** | IN  pkt #56 header: addr=0 len=1 -> channel 0 |
| 9665 | **DUT** | OUT ch0 pkt #56 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9675 | **DUT** | IN  pkt #56 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9675 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9685 | **DUT** | OUT ch0 pkt #56 done: 3 bytes in 3 cycles |
| 9685 | scoreboard | ch0 pkt matched: addr=0 len=1 (56 matched so far) |
| 9885 | **DUT** | IN  pkt #57 header: addr=0 len=1 -> channel 0 |
| 9895 | **DUT** | OUT ch0 pkt #57 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9905 | **DUT** | IN  pkt #57 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9915 | **DUT** | OUT ch0 pkt #57 done: 3 bytes in 3 cycles |
| 9915 | scoreboard | ch0 pkt matched: addr=0 len=1 (57 matched so far) |
| 9935 | **DUT** | IN  pkt #58 header: addr=0 len=1 -> channel 0 |
| 9945 | **DUT** | OUT ch0 pkt #58 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 9955 | **DUT** | IN  pkt #58 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 9965 | **DUT** | OUT ch0 pkt #58 done: 3 bytes in 3 cycles |
| 9965 | scoreboard | ch0 pkt matched: addr=0 len=1 (58 matched so far) |
| 10015 | **DUT** | IN  pkt #59 header: addr=0 len=1 -> channel 0 |
| 10025 | **DUT** | OUT ch0 pkt #59 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10035 | **DUT** | IN  pkt #59 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10045 | **DUT** | OUT ch0 pkt #59 done: 3 bytes in 3 cycles |
| 10045 | scoreboard | ch0 pkt matched: addr=0 len=1 (59 matched so far) |
| 10175 | **DUT** | IN  pkt #60 header: addr=0 len=1 -> channel 0 |
| 10195 | **DUT** | IN  pkt #60 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10195 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10245 | **DUT** | OUT ch0 pkt #60 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 10325 | **DUT** | OUT ch0 pkt #60 done: 3 bytes in 9 cycles |
| 10325 | scoreboard | ch0 pkt matched: addr=0 len=1 (60 matched so far) |
| 10375 | **DUT** | IN  pkt #61 header: addr=0 len=1 -> channel 0 |
| 10385 | **DUT** | OUT ch0 pkt #61 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10395 | **DUT** | IN  pkt #61 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10405 | **DUT** | OUT ch0 pkt #61 done: 3 bytes in 3 cycles |
| 10405 | scoreboard | ch0 pkt matched: addr=0 len=1 (61 matched so far) |
| 10435 | **DUT** | IN  pkt #62 header: addr=0 len=1 -> channel 0 |
| 10445 | **DUT** | OUT ch0 pkt #62 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10455 | **DUT** | IN  pkt #62 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10465 | **DUT** | OUT ch0 pkt #62 done: 3 bytes in 3 cycles |
| 10465 | scoreboard | ch0 pkt matched: addr=0 len=1 (62 matched so far) |
| 10635 | **DUT** | IN  pkt #63 header: addr=0 len=1 -> channel 0 |
| 10645 | **DUT** | OUT ch0 pkt #63 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10655 | **DUT** | IN  pkt #63 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10665 | **DUT** | OUT ch0 pkt #63 done: 3 bytes in 3 cycles |
| 10665 | scoreboard | ch0 pkt matched: addr=0 len=1 (63 matched so far) |
| 10735 | **DUT** | IN  pkt #64 header: addr=0 len=1 -> channel 0 |
| 10745 | **DUT** | OUT ch0 pkt #64 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 10755 | **DUT** | IN  pkt #64 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10755 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10765 | **DUT** | OUT ch0 pkt #64 done: 3 bytes in 3 cycles |
| 10765 | scoreboard | ch0 pkt matched: addr=0 len=1 (64 matched so far) |
| 10935 | **DUT** | IN  pkt #65 header: addr=0 len=1 -> channel 0 |
| 10955 | **DUT** | IN  pkt #65 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 10975 | **DUT** | IN  pkt #66 header: addr=0 len=1 -> channel 0 |
| 10995 | **DUT** | IN  pkt #66 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 10995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11045 | **DUT** | OUT ch0 pkt #65 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 11145 | **DUT** | OUT ch0 pkt #65 done: 3 bytes in 11 cycles |
| 11145 | scoreboard | ch0 pkt matched: addr=0 len=1 (65 matched so far) |
| 11155 | **DUT** | OUT ch0 pkt #66 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11175 | **DUT** | OUT ch0 pkt #66 done: 3 bytes in 3 cycles |
| 11175 | scoreboard | ch0 pkt matched: addr=0 len=1 (66 matched so far) |
| 11195 | **DUT** | IN  pkt #67 header: addr=0 len=1 -> channel 0 |
| 11205 | **DUT** | OUT ch0 pkt #67 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11215 | **DUT** | IN  pkt #67 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11225 | **DUT** | OUT ch0 pkt #67 done: 3 bytes in 3 cycles |
| 11225 | scoreboard | ch0 pkt matched: addr=0 len=1 (67 matched so far) |
| 11235 | **DUT** | IN  pkt #68 header: addr=0 len=1 -> channel 0 |
| 11245 | **DUT** | OUT ch0 pkt #68 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11255 | **DUT** | IN  pkt #68 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11265 | **DUT** | OUT ch0 pkt #68 done: 3 bytes in 3 cycles |
| 11265 | scoreboard | ch0 pkt matched: addr=0 len=1 (68 matched so far) |
| 11375 | **DUT** | IN  pkt #69 header: addr=0 len=1 -> channel 0 |
| 11385 | **DUT** | OUT ch0 pkt #69 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11395 | **DUT** | IN  pkt #69 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11405 | **DUT** | OUT ch0 pkt #69 done: 3 bytes in 3 cycles |
| 11405 | scoreboard | ch0 pkt matched: addr=0 len=1 (69 matched so far) |
| 11565 | **DUT** | IN  pkt #70 header: addr=0 len=1 -> channel 0 |
| 11575 | **DUT** | OUT ch0 pkt #70 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11585 | **DUT** | IN  pkt #70 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11585 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11595 | **DUT** | OUT ch0 pkt #70 done: 3 bytes in 3 cycles |
| 11595 | scoreboard | ch0 pkt matched: addr=0 len=1 (70 matched so far) |
| 11725 | **DUT** | IN  pkt #71 header: addr=0 len=1 -> channel 0 |
| 11735 | **DUT** | OUT ch0 pkt #71 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11745 | **DUT** | IN  pkt #71 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11795 | **DUT** | IN  pkt #72 header: addr=0 len=1 -> channel 0 |
| 11815 | **DUT** | IN  pkt #72 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 11815 | **DUT** | OUT ch0 pkt #71 done: 3 bytes in 9 cycles |
| 11815 | scoreboard | ch0 pkt matched: addr=0 len=1 (71 matched so far) |
| 11815 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 11825 | **DUT** | OUT ch0 pkt #72 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 11845 | **DUT** | OUT ch0 pkt #72 done: 3 bytes in 3 cycles |
| 11845 | scoreboard | ch0 pkt matched: addr=0 len=1 (72 matched so far) |
| 12005 | **DUT** | IN  pkt #73 header: addr=0 len=1 -> channel 0 |
| 12025 | **DUT** | IN  pkt #73 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12045 | **DUT** | OUT ch0 pkt #73 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 12095 | **DUT** | IN  pkt #74 header: addr=0 len=1 -> channel 0 |
| 12115 | **DUT** | IN  pkt #74 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12145 | **DUT** | OUT ch0 pkt #73 done: 3 bytes in 11 cycles |
| 12145 | scoreboard | ch0 pkt matched: addr=0 len=1 (73 matched so far) |
| 12155 | **DUT** | OUT ch0 pkt #74 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12175 | **DUT** | OUT ch0 pkt #74 done: 3 bytes in 3 cycles |
| 12175 | scoreboard | ch0 pkt matched: addr=0 len=1 (74 matched so far) |
| 12235 | **DUT** | IN  pkt #75 header: addr=0 len=1 -> channel 0 |
| 12245 | **DUT** | OUT ch0 pkt #75 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12255 | **DUT** | IN  pkt #75 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12265 | **DUT** | OUT ch0 pkt #75 done: 3 bytes in 3 cycles |
| 12265 | scoreboard | ch0 pkt matched: addr=0 len=1 (75 matched so far) |
| 12435 | **DUT** | IN  pkt #76 header: addr=0 len=1 -> channel 0 |
| 12445 | **DUT** | OUT ch0 pkt #76 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12455 | **DUT** | IN  pkt #76 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12465 | **DUT** | OUT ch0 pkt #76 done: 3 bytes in 3 cycles |
| 12465 | scoreboard | ch0 pkt matched: addr=0 len=1 (76 matched so far) |
| 12505 | **DUT** | IN  pkt #77 header: addr=0 len=1 -> channel 0 |
| 12515 | **DUT** | OUT ch0 pkt #77 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12525 | **DUT** | IN  pkt #77 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12535 | **DUT** | OUT ch0 pkt #77 done: 3 bytes in 3 cycles |
| 12535 | scoreboard | ch0 pkt matched: addr=0 len=1 (77 matched so far) |
| 12625 | **DUT** | IN  pkt #78 header: addr=0 len=1 -> channel 0 |
| 12645 | **DUT** | IN  pkt #78 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12735 | **DUT** | OUT ch0 pkt #78 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 12765 | **DUT** | OUT ch0 pkt #78 done: 3 bytes in 4 cycles |
| 12765 | scoreboard | ch0 pkt matched: addr=0 len=1 (78 matched so far) |
| 12825 | **DUT** | IN  pkt #79 header: addr=0 len=1 -> channel 0 |
| 12835 | **DUT** | OUT ch0 pkt #79 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 12845 | **DUT** | IN  pkt #79 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 12845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 12855 | **DUT** | OUT ch0 pkt #79 done: 3 bytes in 3 cycles |
| 12855 | scoreboard | ch0 pkt matched: addr=0 len=1 (79 matched so far) |
| 13015 | **DUT** | IN  pkt #80 header: addr=0 len=1 -> channel 0 |
| 13025 | **DUT** | OUT ch0 pkt #80 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13035 | **DUT** | IN  pkt #80 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13045 | **DUT** | OUT ch0 pkt #80 done: 3 bytes in 3 cycles |
| 13045 | scoreboard | ch0 pkt matched: addr=0 len=1 (80 matched so far) |
| 13245 | **DUT** | IN  pkt #81 header: addr=0 len=1 -> channel 0 |
| 13255 | **DUT** | OUT ch0 pkt #81 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13265 | **DUT** | IN  pkt #81 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13305 | **DUT** | IN  pkt #82 header: addr=0 len=1 -> channel 0 |
| 13325 | **DUT** | IN  pkt #82 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13375 | **DUT** | IN  pkt #83 header: addr=0 len=1 -> channel 0 |
| 13385 | **DUT** | OUT ch0 pkt #81 done: 3 bytes in 14 cycles |
| 13385 | scoreboard | ch0 pkt matched: addr=0 len=1 (81 matched so far) |
| 13395 | **DUT** | IN  pkt #83 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13395 | **DUT** | OUT ch0 pkt #82 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13415 | **DUT** | OUT ch0 pkt #82 done: 3 bytes in 3 cycles |
| 13415 | scoreboard | ch0 pkt matched: addr=0 len=1 (82 matched so far) |
| 13425 | **DUT** | OUT ch0 pkt #83 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13445 | **DUT** | OUT ch0 pkt #83 done: 3 bytes in 3 cycles |
| 13445 | scoreboard | ch0 pkt matched: addr=0 len=1 (83 matched so far) |
| 13585 | **DUT** | IN  pkt #84 header: addr=0 len=1 -> channel 0 |
| 13595 | **DUT** | OUT ch0 pkt #84 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13605 | **DUT** | IN  pkt #84 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13615 | **DUT** | OUT ch0 pkt #84 done: 3 bytes in 3 cycles |
| 13615 | scoreboard | ch0 pkt matched: addr=0 len=1 (84 matched so far) |
| 13815 | **DUT** | IN  pkt #85 header: addr=0 len=1 -> channel 0 |
| 13835 | **DUT** | IN  pkt #85 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 13885 | **DUT** | OUT ch0 pkt #85 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 13925 | **DUT** | OUT ch0 pkt #85 done: 3 bytes in 5 cycles |
| 13925 | scoreboard | ch0 pkt matched: addr=0 len=1 (85 matched so far) |
| 13975 | **DUT** | IN  pkt #86 header: addr=0 len=1 -> channel 0 |
| 13985 | **DUT** | OUT ch0 pkt #86 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 13995 | **DUT** | IN  pkt #86 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 13995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14005 | **DUT** | OUT ch0 pkt #86 done: 3 bytes in 3 cycles |
| 14005 | scoreboard | ch0 pkt matched: addr=0 len=1 (86 matched so far) |
| 14035 | **DUT** | IN  pkt #87 header: addr=0 len=1 -> channel 0 |
| 14045 | **DUT** | OUT ch0 pkt #87 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14055 | **DUT** | IN  pkt #87 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14065 | **DUT** | OUT ch0 pkt #87 done: 3 bytes in 3 cycles |
| 14065 | scoreboard | ch0 pkt matched: addr=0 len=1 (87 matched so far) |
| 14105 | **DUT** | IN  pkt #88 header: addr=0 len=1 -> channel 0 |
| 14115 | **DUT** | OUT ch0 pkt #88 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14125 | **DUT** | IN  pkt #88 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14135 | **DUT** | OUT ch0 pkt #88 done: 3 bytes in 3 cycles |
| 14135 | scoreboard | ch0 pkt matched: addr=0 len=1 (88 matched so far) |
| 14185 | **DUT** | IN  pkt #89 header: addr=0 len=1 -> channel 0 |
| 14195 | **DUT** | OUT ch0 pkt #89 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14205 | **DUT** | IN  pkt #89 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14215 | **DUT** | OUT ch0 pkt #89 done: 3 bytes in 3 cycles |
| 14215 | scoreboard | ch0 pkt matched: addr=0 len=1 (89 matched so far) |
| 14415 | **DUT** | IN  pkt #90 header: addr=0 len=1 -> channel 0 |
| 14435 | **DUT** | IN  pkt #90 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14485 | **DUT** | OUT ch0 pkt #90 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 14545 | **DUT** | IN  pkt #91 header: addr=0 len=1 -> channel 0 |
| 14565 | **DUT** | IN  pkt #91 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14565 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14615 | **DUT** | OUT ch0 pkt #90 done: 3 bytes in 14 cycles |
| 14615 | scoreboard | ch0 pkt matched: addr=0 len=1 (90 matched so far) |
| 14625 | **DUT** | OUT ch0 pkt #91 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14645 | **DUT** | OUT ch0 pkt #91 done: 3 bytes in 3 cycles |
| 14645 | scoreboard | ch0 pkt matched: addr=0 len=1 (91 matched so far) |
| 14775 | **DUT** | IN  pkt #92 header: addr=0 len=1 -> channel 0 |
| 14785 | **DUT** | OUT ch0 pkt #92 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14795 | **DUT** | IN  pkt #92 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14795 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14805 | **DUT** | OUT ch0 pkt #92 done: 3 bytes in 3 cycles |
| 14805 | scoreboard | ch0 pkt matched: addr=0 len=1 (92 matched so far) |
| 14825 | **DUT** | IN  pkt #93 header: addr=0 len=1 -> channel 0 |
| 14835 | **DUT** | OUT ch0 pkt #93 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14845 | **DUT** | IN  pkt #93 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14845 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14915 | **DUT** | IN  pkt #94 header: addr=0 len=1 -> channel 0 |
| 14935 | **DUT** | IN  pkt #94 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 14935 | **DUT** | OUT ch0 pkt #93 done: 3 bytes in 11 cycles |
| 14935 | scoreboard | ch0 pkt matched: addr=0 len=1 (93 matched so far) |
| 14935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 14945 | **DUT** | OUT ch0 pkt #94 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 14965 | **DUT** | OUT ch0 pkt #94 done: 3 bytes in 3 cycles |
| 14965 | scoreboard | ch0 pkt matched: addr=0 len=1 (94 matched so far) |
| 14995 | **DUT** | IN  pkt #95 header: addr=0 len=1 -> channel 0 |
| 15005 | **DUT** | OUT ch0 pkt #95 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15015 | **DUT** | IN  pkt #95 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15025 | **DUT** | OUT ch0 pkt #95 done: 3 bytes in 3 cycles |
| 15025 | scoreboard | ch0 pkt matched: addr=0 len=1 (95 matched so far) |
| 15225 | **DUT** | IN  pkt #96 header: addr=0 len=1 -> channel 0 |
| 15235 | **DUT** | OUT ch0 pkt #96 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15245 | **DUT** | IN  pkt #96 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15245 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15255 | **DUT** | OUT ch0 pkt #96 done: 3 bytes in 3 cycles |
| 15255 | scoreboard | ch0 pkt matched: addr=0 len=1 (96 matched so far) |
| 15425 | **DUT** | IN  pkt #97 header: addr=0 len=1 -> channel 0 |
| 15445 | **DUT** | IN  pkt #97 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15515 | **DUT** | OUT ch0 pkt #97 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 15535 | **DUT** | IN  pkt #98 header: addr=0 len=1 -> channel 0 |
| 15555 | **DUT** | IN  pkt #98 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15605 | **DUT** | IN  pkt #99 header: addr=0 len=1 -> channel 0 |
| 15625 | **DUT** | IN  pkt #99 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15625 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15635 | **DUT** | OUT ch0 pkt #97 done: 3 bytes in 13 cycles |
| 15635 | scoreboard | ch0 pkt matched: addr=0 len=1 (97 matched so far) |
| 15645 | **DUT** | OUT ch0 pkt #98 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15665 | **DUT** | OUT ch0 pkt #98 done: 3 bytes in 3 cycles |
| 15665 | scoreboard | ch0 pkt matched: addr=0 len=1 (98 matched so far) |
| 15675 | **DUT** | OUT ch0 pkt #99 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15695 | **DUT** | OUT ch0 pkt #99 done: 3 bytes in 3 cycles |
| 15695 | scoreboard | ch0 pkt matched: addr=0 len=1 (99 matched so far) |
| 15805 | **DUT** | IN  pkt #100 header: addr=0 len=1 -> channel 0 |
| 15815 | **DUT** | OUT ch0 pkt #100 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 15825 | **DUT** | IN  pkt #100 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 15825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 15835 | **DUT** | OUT ch0 pkt #100 done: 3 bytes in 3 cycles |
| 15835 | scoreboard | ch0 pkt matched: addr=0 len=1 (100 matched so far) |
| 15995 | **DUT** | IN  pkt #101 header: addr=0 len=1 -> channel 0 |
| 16005 | **DUT** | OUT ch0 pkt #101 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16015 | **DUT** | IN  pkt #101 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16015 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16025 | **DUT** | OUT ch0 pkt #101 done: 3 bytes in 3 cycles |
| 16025 | scoreboard | ch0 pkt matched: addr=0 len=1 (101 matched so far) |
| 16185 | **DUT** | IN  pkt #102 header: addr=0 len=1 -> channel 0 |
| 16205 | **DUT** | IN  pkt #102 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16245 | **DUT** | OUT ch0 pkt #102 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 16305 | **DUT** | IN  pkt #103 header: addr=0 len=1 -> channel 0 |
| 16305 | **DUT** | OUT ch0 pkt #102 done: 3 bytes in 7 cycles |
| 16305 | scoreboard | ch0 pkt matched: addr=0 len=1 (102 matched so far) |
| 16315 | **DUT** | OUT ch0 pkt #103 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16325 | **DUT** | IN  pkt #103 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16335 | **DUT** | OUT ch0 pkt #103 done: 3 bytes in 3 cycles |
| 16335 | scoreboard | ch0 pkt matched: addr=0 len=1 (103 matched so far) |
| 16425 | **DUT** | IN  pkt #104 header: addr=0 len=1 -> channel 0 |
| 16435 | **DUT** | OUT ch0 pkt #104 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16445 | **DUT** | IN  pkt #104 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16455 | **DUT** | OUT ch0 pkt #104 done: 3 bytes in 3 cycles |
| 16455 | scoreboard | ch0 pkt matched: addr=0 len=1 (104 matched so far) |
| 16625 | **DUT** | IN  pkt #105 header: addr=0 len=1 -> channel 0 |
| 16645 | **DUT** | IN  pkt #105 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16705 | **DUT** | IN  pkt #106 header: addr=0 len=1 -> channel 0 |
| 16725 | **DUT** | IN  pkt #106 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16735 | **DUT** | OUT ch0 pkt #105 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 16855 | **DUT** | OUT ch0 pkt #105 done: 3 bytes in 13 cycles |
| 16855 | scoreboard | ch0 pkt matched: addr=0 len=1 (105 matched so far) |
| 16865 | **DUT** | OUT ch0 pkt #106 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16885 | **DUT** | OUT ch0 pkt #106 done: 3 bytes in 3 cycles |
| 16885 | scoreboard | ch0 pkt matched: addr=0 len=1 (106 matched so far) |
| 16925 | **DUT** | IN  pkt #107 header: addr=0 len=1 -> channel 0 |
| 16935 | **DUT** | OUT ch0 pkt #107 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 16945 | **DUT** | IN  pkt #107 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 16945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 16955 | **DUT** | OUT ch0 pkt #107 done: 3 bytes in 3 cycles |
| 16955 | scoreboard | ch0 pkt matched: addr=0 len=1 (107 matched so far) |
| 17105 | **DUT** | IN  pkt #108 header: addr=0 len=1 -> channel 0 |
| 17115 | **DUT** | OUT ch0 pkt #108 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17125 | **DUT** | IN  pkt #108 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17135 | **DUT** | OUT ch0 pkt #108 done: 3 bytes in 3 cycles |
| 17135 | scoreboard | ch0 pkt matched: addr=0 len=1 (108 matched so far) |
| 17165 | **DUT** | IN  pkt #109 header: addr=0 len=1 -> channel 0 |
| 17175 | **DUT** | OUT ch0 pkt #109 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17185 | **DUT** | IN  pkt #109 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17185 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17195 | **DUT** | OUT ch0 pkt #109 done: 3 bytes in 3 cycles |
| 17195 | scoreboard | ch0 pkt matched: addr=0 len=1 (109 matched so far) |
| 17375 | **DUT** | IN  pkt #110 header: addr=0 len=1 -> channel 0 |
| 17395 | **DUT** | IN  pkt #110 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17455 | **DUT** | OUT ch0 pkt #110 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 17515 | **DUT** | IN  pkt #111 header: addr=0 len=1 -> channel 0 |
| 17515 | **DUT** | OUT ch0 pkt #110 done: 3 bytes in 7 cycles |
| 17515 | scoreboard | ch0 pkt matched: addr=0 len=1 (110 matched so far) |
| 17525 | **DUT** | OUT ch0 pkt #111 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17535 | **DUT** | IN  pkt #111 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17545 | **DUT** | OUT ch0 pkt #111 done: 3 bytes in 3 cycles |
| 17545 | scoreboard | ch0 pkt matched: addr=0 len=1 (111 matched so far) |
| 17615 | **DUT** | IN  pkt #112 header: addr=0 len=1 -> channel 0 |
| 17625 | **DUT** | OUT ch0 pkt #112 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 17635 | **DUT** | IN  pkt #112 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17645 | **DUT** | OUT ch0 pkt #112 done: 3 bytes in 3 cycles |
| 17645 | scoreboard | ch0 pkt matched: addr=0 len=1 (112 matched so far) |
| 17815 | **DUT** | IN  pkt #113 header: addr=0 len=1 -> channel 0 |
| 17835 | **DUT** | IN  pkt #113 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 17835 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 17915 | **DUT** | OUT ch0 pkt #113 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 17975 | **DUT** | OUT ch0 pkt #113 done: 3 bytes in 7 cycles |
| 17975 | scoreboard | ch0 pkt matched: addr=0 len=1 (113 matched so far) |
| 18015 | **DUT** | IN  pkt #114 header: addr=0 len=1 -> channel 0 |
| 18025 | **DUT** | OUT ch0 pkt #114 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18035 | **DUT** | IN  pkt #114 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18045 | **DUT** | OUT ch0 pkt #114 done: 3 bytes in 3 cycles |
| 18045 | scoreboard | ch0 pkt matched: addr=0 len=1 (114 matched so far) |
| 18105 | **DUT** | IN  pkt #115 header: addr=0 len=1 -> channel 0 |
| 18115 | **DUT** | OUT ch0 pkt #115 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18125 | **DUT** | IN  pkt #115 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18135 | **DUT** | OUT ch0 pkt #115 done: 3 bytes in 3 cycles |
| 18135 | scoreboard | ch0 pkt matched: addr=0 len=1 (115 matched so far) |
| 18215 | **DUT** | IN  pkt #116 header: addr=0 len=1 -> channel 0 |
| 18235 | **DUT** | IN  pkt #116 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18315 | **DUT** | OUT ch0 pkt #116 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 18425 | **DUT** | OUT ch0 pkt #116 done: 3 bytes in 12 cycles |
| 18425 | scoreboard | ch0 pkt matched: addr=0 len=1 (116 matched so far) |
| 18445 | **DUT** | IN  pkt #117 header: addr=0 len=1 -> channel 0 |
| 18455 | **DUT** | OUT ch0 pkt #117 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18465 | **DUT** | IN  pkt #117 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18475 | **DUT** | OUT ch0 pkt #117 done: 3 bytes in 3 cycles |
| 18475 | scoreboard | ch0 pkt matched: addr=0 len=1 (117 matched so far) |
| 18675 | **DUT** | IN  pkt #118 header: addr=0 len=1 -> channel 0 |
| 18685 | **DUT** | OUT ch0 pkt #118 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 18695 | **DUT** | IN  pkt #118 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18695 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18705 | **DUT** | OUT ch0 pkt #118 done: 3 bytes in 3 cycles |
| 18705 | scoreboard | ch0 pkt matched: addr=0 len=1 (118 matched so far) |
| 18845 | **DUT** | IN  pkt #119 header: addr=0 len=1 -> channel 0 |
| 18865 | **DUT** | IN  pkt #119 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 18865 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 18955 | **DUT** | OUT ch0 pkt #119 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 19035 | **DUT** | OUT ch0 pkt #119 done: 3 bytes in 9 cycles |
| 19035 | scoreboard | ch0 pkt matched: addr=0 len=1 (119 matched so far) |
| 19075 | **DUT** | IN  pkt #120 header: addr=0 len=1 -> channel 0 |
| 19085 | **DUT** | OUT ch0 pkt #120 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19095 | **DUT** | IN  pkt #120 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19105 | **DUT** | OUT ch0 pkt #120 done: 3 bytes in 3 cycles |
| 19105 | scoreboard | ch0 pkt matched: addr=0 len=1 (120 matched so far) |
| 19195 | **DUT** | IN  pkt #121 header: addr=0 len=1 -> channel 0 |
| 19205 | **DUT** | OUT ch0 pkt #121 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19215 | **DUT** | IN  pkt #121 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19225 | **DUT** | OUT ch0 pkt #121 done: 3 bytes in 3 cycles |
| 19225 | scoreboard | ch0 pkt matched: addr=0 len=1 (121 matched so far) |
| 19405 | **DUT** | IN  pkt #122 header: addr=0 len=1 -> channel 0 |
| 19425 | **DUT** | IN  pkt #122 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19425 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19455 | **DUT** | OUT ch0 pkt #122 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 19485 | **DUT** | IN  pkt #123 header: addr=0 len=1 -> channel 0 |
| 19505 | **DUT** | IN  pkt #123 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19585 | **DUT** | OUT ch0 pkt #122 done: 3 bytes in 14 cycles |
| 19585 | scoreboard | ch0 pkt matched: addr=0 len=1 (122 matched so far) |
| 19595 | **DUT** | OUT ch0 pkt #123 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19615 | **DUT** | OUT ch0 pkt #123 done: 3 bytes in 3 cycles |
| 19615 | scoreboard | ch0 pkt matched: addr=0 len=1 (123 matched so far) |
| 19635 | **DUT** | IN  pkt #124 header: addr=0 len=1 -> channel 0 |
| 19645 | **DUT** | OUT ch0 pkt #124 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19655 | **DUT** | IN  pkt #124 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19665 | **DUT** | OUT ch0 pkt #124 done: 3 bytes in 3 cycles |
| 19665 | scoreboard | ch0 pkt matched: addr=0 len=1 (124 matched so far) |
| 19705 | **DUT** | IN  pkt #125 header: addr=0 len=1 -> channel 0 |
| 19715 | **DUT** | OUT ch0 pkt #125 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19725 | **DUT** | IN  pkt #125 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19735 | **DUT** | OUT ch0 pkt #125 done: 3 bytes in 3 cycles |
| 19735 | scoreboard | ch0 pkt matched: addr=0 len=1 (125 matched so far) |
| 19755 | **DUT** | IN  pkt #126 header: addr=0 len=1 -> channel 0 |
| 19765 | **DUT** | OUT ch0 pkt #126 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19775 | **DUT** | IN  pkt #126 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19775 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 19885 | **DUT** | OUT ch0 pkt #126 done: 3 bytes in 13 cycles |
| 19885 | scoreboard | ch0 pkt matched: addr=0 len=1 (126 matched so far) |
| 19975 | **DUT** | IN  pkt #127 header: addr=0 len=1 -> channel 0 |
| 19985 | **DUT** | OUT ch0 pkt #127 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 19995 | **DUT** | IN  pkt #127 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 19995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20005 | **DUT** | OUT ch0 pkt #127 done: 3 bytes in 3 cycles |
| 20005 | scoreboard | ch0 pkt matched: addr=0 len=1 (127 matched so far) |
| 20035 | **DUT** | IN  pkt #128 header: addr=0 len=1 -> channel 0 |
| 20045 | **DUT** | OUT ch0 pkt #128 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20055 | **DUT** | IN  pkt #128 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20065 | **DUT** | OUT ch0 pkt #128 done: 3 bytes in 3 cycles |
| 20065 | scoreboard | ch0 pkt matched: addr=0 len=1 (128 matched so far) |
| 20075 | **DUT** | IN  pkt #129 header: addr=0 len=1 -> channel 0 |
| 20085 | **DUT** | OUT ch0 pkt #129 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20095 | **DUT** | IN  pkt #129 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20105 | **DUT** | OUT ch0 pkt #129 done: 3 bytes in 3 cycles |
| 20105 | scoreboard | ch0 pkt matched: addr=0 len=1 (129 matched so far) |
| 20155 | **DUT** | IN  pkt #130 header: addr=0 len=1 -> channel 0 |
| 20175 | **DUT** | IN  pkt #130 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20265 | **DUT** | OUT ch0 pkt #130 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 20355 | **DUT** | IN  pkt #131 header: addr=0 len=1 -> channel 0 |
| 20375 | **DUT** | IN  pkt #131 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20375 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20395 | **DUT** | OUT ch0 pkt #130 done: 3 bytes in 14 cycles |
| 20395 | scoreboard | ch0 pkt matched: addr=0 len=1 (130 matched so far) |
| 20405 | **DUT** | OUT ch0 pkt #131 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20425 | **DUT** | OUT ch0 pkt #131 done: 3 bytes in 3 cycles |
| 20425 | scoreboard | ch0 pkt matched: addr=0 len=1 (131 matched so far) |
| 20585 | **DUT** | IN  pkt #132 header: addr=0 len=1 -> channel 0 |
| 20605 | **DUT** | IN  pkt #132 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20625 | **DUT** | OUT ch0 pkt #132 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 20715 | **DUT** | IN  pkt #133 header: addr=0 len=1 -> channel 0 |
| 20735 | **DUT** | IN  pkt #133 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20735 | **DUT** | OUT ch0 pkt #132 done: 3 bytes in 12 cycles |
| 20735 | scoreboard | ch0 pkt matched: addr=0 len=1 (132 matched so far) |
| 20735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20745 | **DUT** | OUT ch0 pkt #133 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20765 | **DUT** | OUT ch0 pkt #133 done: 3 bytes in 3 cycles |
| 20765 | scoreboard | ch0 pkt matched: addr=0 len=1 (133 matched so far) |
| 20925 | **DUT** | IN  pkt #134 header: addr=0 len=1 -> channel 0 |
| 20935 | **DUT** | OUT ch0 pkt #134 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20945 | **DUT** | IN  pkt #134 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20955 | **DUT** | OUT ch0 pkt #134 done: 3 bytes in 3 cycles |
| 20955 | scoreboard | ch0 pkt matched: addr=0 len=1 (134 matched so far) |
| 20965 | **DUT** | IN  pkt #135 header: addr=0 len=1 -> channel 0 |
| 20975 | **DUT** | OUT ch0 pkt #135 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 20985 | **DUT** | IN  pkt #135 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 20995 | **DUT** | OUT ch0 pkt #135 done: 3 bytes in 3 cycles |
| 20995 | scoreboard | ch0 pkt matched: addr=0 len=1 (135 matched so far) |
| 21195 | **DUT** | IN  pkt #136 header: addr=0 len=1 -> channel 0 |
| 21205 | **DUT** | OUT ch0 pkt #136 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21215 | **DUT** | IN  pkt #136 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21225 | **DUT** | OUT ch0 pkt #136 done: 3 bytes in 3 cycles |
| 21225 | scoreboard | ch0 pkt matched: addr=0 len=1 (136 matched so far) |
| 21415 | **DUT** | IN  pkt #137 header: addr=0 len=1 -> channel 0 |
| 21435 | **DUT** | IN  pkt #137 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21505 | **DUT** | OUT ch0 pkt #137 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 21605 | **DUT** | OUT ch0 pkt #137 done: 3 bytes in 11 cycles |
| 21605 | scoreboard | ch0 pkt matched: addr=0 len=1 (137 matched so far) |
| 21645 | **DUT** | IN  pkt #138 header: addr=0 len=1 -> channel 0 |
| 21655 | **DUT** | OUT ch0 pkt #138 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21665 | **DUT** | IN  pkt #138 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21665 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21675 | **DUT** | OUT ch0 pkt #138 done: 3 bytes in 3 cycles |
| 21675 | scoreboard | ch0 pkt matched: addr=0 len=1 (138 matched so far) |
| 21695 | **DUT** | IN  pkt #139 header: addr=0 len=1 -> channel 0 |
| 21705 | **DUT** | OUT ch0 pkt #139 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21715 | **DUT** | IN  pkt #139 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21725 | **DUT** | OUT ch0 pkt #139 done: 3 bytes in 3 cycles |
| 21725 | scoreboard | ch0 pkt matched: addr=0 len=1 (139 matched so far) |
| 21925 | **DUT** | IN  pkt #140 header: addr=0 len=1 -> channel 0 |
| 21935 | **DUT** | OUT ch0 pkt #140 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 21945 | **DUT** | IN  pkt #140 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 21945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 21955 | **DUT** | OUT ch0 pkt #140 done: 3 bytes in 3 cycles |
| 21955 | scoreboard | ch0 pkt matched: addr=0 len=1 (140 matched so far) |
| 22035 | **DUT** | IN  pkt #141 header: addr=0 len=1 -> channel 0 |
| 22045 | **DUT** | OUT ch0 pkt #141 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22055 | **DUT** | IN  pkt #141 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22065 | **DUT** | OUT ch0 pkt #141 done: 3 bytes in 3 cycles |
| 22065 | scoreboard | ch0 pkt matched: addr=0 len=1 (141 matched so far) |
| 22195 | **DUT** | IN  pkt #142 header: addr=0 len=1 -> channel 0 |
| 22215 | **DUT** | IN  pkt #142 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22305 | **DUT** | OUT ch0 pkt #142 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 22405 | **DUT** | OUT ch0 pkt #142 done: 3 bytes in 11 cycles |
| 22405 | scoreboard | ch0 pkt matched: addr=0 len=1 (142 matched so far) |
| 22425 | **DUT** | IN  pkt #143 header: addr=0 len=1 -> channel 0 |
| 22435 | **DUT** | OUT ch0 pkt #143 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22445 | **DUT** | IN  pkt #143 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22455 | **DUT** | OUT ch0 pkt #143 done: 3 bytes in 3 cycles |
| 22455 | scoreboard | ch0 pkt matched: addr=0 len=1 (143 matched so far) |
| 22635 | **DUT** | IN  pkt #144 header: addr=0 len=1 -> channel 0 |
| 22645 | **DUT** | OUT ch0 pkt #144 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22655 | **DUT** | IN  pkt #144 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22665 | **DUT** | OUT ch0 pkt #144 done: 3 bytes in 3 cycles |
| 22665 | scoreboard | ch0 pkt matched: addr=0 len=1 (144 matched so far) |
| 22725 | **DUT** | IN  pkt #145 header: addr=0 len=1 -> channel 0 |
| 22735 | **DUT** | OUT ch0 pkt #145 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22745 | **DUT** | IN  pkt #145 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22755 | **DUT** | OUT ch0 pkt #145 done: 3 bytes in 3 cycles |
| 22755 | scoreboard | ch0 pkt matched: addr=0 len=1 (145 matched so far) |
| 22925 | **DUT** | IN  pkt #146 header: addr=0 len=1 -> channel 0 |
| 22935 | **DUT** | OUT ch0 pkt #146 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 22945 | **DUT** | IN  pkt #146 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 22945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 22955 | **DUT** | OUT ch0 pkt #146 done: 3 bytes in 3 cycles |
| 22955 | scoreboard | ch0 pkt matched: addr=0 len=1 (146 matched so far) |
| 23155 | **DUT** | IN  pkt #147 header: addr=0 len=1 -> channel 0 |
| 23165 | **DUT** | OUT ch0 pkt #147 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23175 | **DUT** | IN  pkt #147 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23195 | **DUT** | OUT ch0 pkt #147 done: 3 bytes in 4 cycles |
| 23195 | scoreboard | ch0 pkt matched: addr=0 len=1 (147 matched so far) |
| 23315 | **DUT** | IN  pkt #148 header: addr=0 len=1 -> channel 0 |
| 23325 | **DUT** | OUT ch0 pkt #148 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23335 | **DUT** | IN  pkt #148 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23345 | **DUT** | OUT ch0 pkt #148 done: 3 bytes in 3 cycles |
| 23345 | scoreboard | ch0 pkt matched: addr=0 len=1 (148 matched so far) |
| 23535 | **DUT** | IN  pkt #149 header: addr=0 len=1 -> channel 0 |
| 23545 | **DUT** | OUT ch0 pkt #149 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23555 | **DUT** | IN  pkt #149 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23555 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23565 | **DUT** | OUT ch0 pkt #149 done: 3 bytes in 3 cycles |
| 23565 | scoreboard | ch0 pkt matched: addr=0 len=1 (149 matched so far) |
| 23625 | **DUT** | IN  pkt #150 header: addr=0 len=1 -> channel 0 |
| 23635 | **DUT** | OUT ch0 pkt #150 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 23645 | **DUT** | IN  pkt #150 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23645 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23655 | **DUT** | OUT ch0 pkt #150 done: 3 bytes in 3 cycles |
| 23655 | scoreboard | ch0 pkt matched: addr=0 len=1 (150 matched so far) |
| 23785 | **DUT** | IN  pkt #151 header: addr=0 len=1 -> channel 0 |
| 23805 | **DUT** | IN  pkt #151 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 23805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 23895 | **DUT** | OUT ch0 pkt #151 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 23965 | **DUT** | OUT ch0 pkt #151 done: 3 bytes in 8 cycles |
| 23965 | scoreboard | ch0 pkt matched: addr=0 len=1 (151 matched so far) |
| 24015 | **DUT** | IN  pkt #152 header: addr=0 len=1 -> channel 0 |
| 24035 | **DUT** | IN  pkt #152 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24095 | **DUT** | OUT ch0 pkt #152 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 24225 | **DUT** | OUT ch0 pkt #152 done: 3 bytes in 14 cycles |
| 24225 | scoreboard | ch0 pkt matched: addr=0 len=1 (152 matched so far) |
| 24245 | **DUT** | IN  pkt #153 header: addr=0 len=1 -> channel 0 |
| 24255 | **DUT** | OUT ch0 pkt #153 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24265 | **DUT** | IN  pkt #153 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24275 | **DUT** | OUT ch0 pkt #153 done: 3 bytes in 3 cycles |
| 24275 | scoreboard | ch0 pkt matched: addr=0 len=1 (153 matched so far) |
| 24475 | **DUT** | IN  pkt #154 header: addr=0 len=1 -> channel 0 |
| 24495 | **DUT** | IN  pkt #154 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24565 | **DUT** | OUT ch0 pkt #154 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 24655 | **DUT** | OUT ch0 pkt #154 done: 3 bytes in 10 cycles |
| 24655 | scoreboard | ch0 pkt matched: addr=0 len=1 (154 matched so far) |
| 24695 | **DUT** | IN  pkt #155 header: addr=0 len=1 -> channel 0 |
| 24705 | **DUT** | OUT ch0 pkt #155 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24715 | **DUT** | IN  pkt #155 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24725 | **DUT** | OUT ch0 pkt #155 done: 3 bytes in 3 cycles |
| 24725 | scoreboard | ch0 pkt matched: addr=0 len=1 (155 matched so far) |
| 24765 | **DUT** | IN  pkt #156 header: addr=0 len=1 -> channel 0 |
| 24775 | **DUT** | OUT ch0 pkt #156 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24785 | **DUT** | IN  pkt #156 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24785 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24795 | **DUT** | OUT ch0 pkt #156 done: 3 bytes in 3 cycles |
| 24795 | scoreboard | ch0 pkt matched: addr=0 len=1 (156 matched so far) |
| 24925 | **DUT** | IN  pkt #157 header: addr=0 len=1 -> channel 0 |
| 24935 | **DUT** | OUT ch0 pkt #157 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 24945 | **DUT** | IN  pkt #157 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 24945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 24955 | **DUT** | OUT ch0 pkt #157 done: 3 bytes in 3 cycles |
| 24955 | scoreboard | ch0 pkt matched: addr=0 len=1 (157 matched so far) |
| 25115 | **DUT** | IN  pkt #158 header: addr=0 len=1 -> channel 0 |
| 25125 | **DUT** | OUT ch0 pkt #158 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25135 | **DUT** | IN  pkt #158 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25135 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25145 | **DUT** | OUT ch0 pkt #158 done: 3 bytes in 3 cycles |
| 25145 | scoreboard | ch0 pkt matched: addr=0 len=1 (158 matched so far) |
| 25255 | **DUT** | IN  pkt #159 header: addr=0 len=1 -> channel 0 |
| 25265 | **DUT** | OUT ch0 pkt #159 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25275 | **DUT** | IN  pkt #159 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25275 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25285 | **DUT** | OUT ch0 pkt #159 done: 3 bytes in 3 cycles |
| 25285 | scoreboard | ch0 pkt matched: addr=0 len=1 (159 matched so far) |
| 25485 | **DUT** | IN  pkt #160 header: addr=0 len=1 -> channel 0 |
| 25505 | **DUT** | IN  pkt #160 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25505 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25545 | **DUT** | OUT ch0 pkt #160 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 25655 | **DUT** | OUT ch0 pkt #160 done: 3 bytes in 12 cycles |
| 25655 | scoreboard | ch0 pkt matched: addr=0 len=1 (160 matched so far) |
| 25695 | **DUT** | IN  pkt #161 header: addr=0 len=1 -> channel 0 |
| 25705 | **DUT** | OUT ch0 pkt #161 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25715 | **DUT** | IN  pkt #161 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25715 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25725 | **DUT** | OUT ch0 pkt #161 done: 3 bytes in 3 cycles |
| 25725 | scoreboard | ch0 pkt matched: addr=0 len=1 (161 matched so far) |
| 25875 | **DUT** | IN  pkt #162 header: addr=0 len=1 -> channel 0 |
| 25885 | **DUT** | OUT ch0 pkt #162 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25895 | **DUT** | IN  pkt #162 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25905 | **DUT** | OUT ch0 pkt #162 done: 3 bytes in 3 cycles |
| 25905 | scoreboard | ch0 pkt matched: addr=0 len=1 (162 matched so far) |
| 25965 | **DUT** | IN  pkt #163 header: addr=0 len=1 -> channel 0 |
| 25975 | **DUT** | OUT ch0 pkt #163 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 25985 | **DUT** | IN  pkt #163 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 25985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 25995 | **DUT** | OUT ch0 pkt #163 done: 3 bytes in 3 cycles |
| 25995 | scoreboard | ch0 pkt matched: addr=0 len=1 (163 matched so far) |
| 26035 | **DUT** | IN  pkt #164 header: addr=0 len=1 -> channel 0 |
| 26045 | **DUT** | OUT ch0 pkt #164 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26055 | **DUT** | IN  pkt #164 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26065 | **DUT** | OUT ch0 pkt #164 done: 3 bytes in 3 cycles |
| 26065 | scoreboard | ch0 pkt matched: addr=0 len=1 (164 matched so far) |
| 26265 | **DUT** | IN  pkt #165 header: addr=0 len=1 -> channel 0 |
| 26285 | **DUT** | IN  pkt #165 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26375 | **DUT** | OUT ch0 pkt #165 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 26415 | **DUT** | OUT ch0 pkt #165 done: 3 bytes in 5 cycles |
| 26415 | scoreboard | ch0 pkt matched: addr=0 len=1 (165 matched so far) |
| 26495 | **DUT** | IN  pkt #166 header: addr=0 len=1 -> channel 0 |
| 26505 | **DUT** | OUT ch0 pkt #166 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26515 | **DUT** | IN  pkt #166 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26635 | **DUT** | OUT ch0 pkt #166 done: 3 bytes in 14 cycles |
| 26635 | scoreboard | ch0 pkt matched: addr=0 len=1 (166 matched so far) |
| 26715 | **DUT** | IN  pkt #167 header: addr=0 len=1 -> channel 0 |
| 26735 | **DUT** | IN  pkt #167 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26735 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26785 | **DUT** | IN  pkt #168 header: addr=0 len=1 -> channel 0 |
| 26805 | **DUT** | IN  pkt #168 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 26805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 26815 | **DUT** | OUT ch0 pkt #167 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 26945 | **DUT** | OUT ch0 pkt #167 done: 3 bytes in 14 cycles |
| 26945 | scoreboard | ch0 pkt matched: addr=0 len=1 (167 matched so far) |
| 26955 | **DUT** | OUT ch0 pkt #168 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 26975 | **DUT** | OUT ch0 pkt #168 done: 3 bytes in 3 cycles |
| 26975 | scoreboard | ch0 pkt matched: addr=0 len=1 (168 matched so far) |
| 27005 | **DUT** | IN  pkt #169 header: addr=0 len=1 -> channel 0 |
| 27015 | **DUT** | OUT ch0 pkt #169 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27025 | **DUT** | IN  pkt #169 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27025 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27045 | **DUT** | IN  pkt #170 header: addr=0 len=1 -> channel 0 |
| 27065 | **DUT** | IN  pkt #170 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27125 | **DUT** | OUT ch0 pkt #169 done: 3 bytes in 12 cycles |
| 27125 | scoreboard | ch0 pkt matched: addr=0 len=1 (169 matched so far) |
| 27135 | **DUT** | OUT ch0 pkt #170 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27155 | **DUT** | OUT ch0 pkt #170 done: 3 bytes in 3 cycles |
| 27155 | scoreboard | ch0 pkt matched: addr=0 len=1 (170 matched so far) |
| 27265 | **DUT** | IN  pkt #171 header: addr=0 len=1 -> channel 0 |
| 27275 | **DUT** | OUT ch0 pkt #171 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27285 | **DUT** | IN  pkt #171 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27285 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27295 | **DUT** | OUT ch0 pkt #171 done: 3 bytes in 3 cycles |
| 27295 | scoreboard | ch0 pkt matched: addr=0 len=1 (171 matched so far) |
| 27495 | **DUT** | IN  pkt #172 header: addr=0 len=1 -> channel 0 |
| 27515 | **DUT** | IN  pkt #172 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27565 | **DUT** | OUT ch0 pkt #172 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 27605 | **DUT** | OUT ch0 pkt #172 done: 3 bytes in 5 cycles |
| 27605 | scoreboard | ch0 pkt matched: addr=0 len=1 (172 matched so far) |
| 27725 | **DUT** | IN  pkt #173 header: addr=0 len=1 -> channel 0 |
| 27735 | **DUT** | OUT ch0 pkt #173 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27745 | **DUT** | IN  pkt #173 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27755 | **DUT** | OUT ch0 pkt #173 done: 3 bytes in 3 cycles |
| 27755 | scoreboard | ch0 pkt matched: addr=0 len=1 (173 matched so far) |
| 27925 | **DUT** | IN  pkt #174 header: addr=0 len=1 -> channel 0 |
| 27935 | **DUT** | OUT ch0 pkt #174 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 27945 | **DUT** | IN  pkt #174 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 27945 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 27955 | **DUT** | OUT ch0 pkt #174 done: 3 bytes in 3 cycles |
| 27955 | scoreboard | ch0 pkt matched: addr=0 len=1 (174 matched so far) |
| 28155 | **DUT** | IN  pkt #175 header: addr=0 len=1 -> channel 0 |
| 28175 | **DUT** | IN  pkt #175 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28175 | **DUT** | OUT ch0 pkt #175 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 28175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28295 | **DUT** | IN  pkt #176 header: addr=0 len=1 -> channel 0 |
| 28305 | **DUT** | OUT ch0 pkt #175 done: 3 bytes in 14 cycles |
| 28305 | scoreboard | ch0 pkt matched: addr=0 len=1 (175 matched so far) |
| 28315 | **DUT** | IN  pkt #176 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28315 | **DUT** | OUT ch0 pkt #176 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28335 | **DUT** | OUT ch0 pkt #176 done: 3 bytes in 3 cycles |
| 28335 | scoreboard | ch0 pkt matched: addr=0 len=1 (176 matched so far) |
| 28385 | **DUT** | IN  pkt #177 header: addr=0 len=1 -> channel 0 |
| 28395 | **DUT** | OUT ch0 pkt #177 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28405 | **DUT** | IN  pkt #177 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28415 | **DUT** | OUT ch0 pkt #177 done: 3 bytes in 3 cycles |
| 28415 | scoreboard | ch0 pkt matched: addr=0 len=1 (177 matched so far) |
| 28445 | **DUT** | IN  pkt #178 header: addr=0 len=1 -> channel 0 |
| 28455 | **DUT** | OUT ch0 pkt #178 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28465 | **DUT** | IN  pkt #178 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28465 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28475 | **DUT** | OUT ch0 pkt #178 done: 3 bytes in 3 cycles |
| 28475 | scoreboard | ch0 pkt matched: addr=0 len=1 (178 matched so far) |
| 28615 | **DUT** | IN  pkt #179 header: addr=0 len=1 -> channel 0 |
| 28635 | **DUT** | IN  pkt #179 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28635 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28705 | **DUT** | IN  pkt #180 header: addr=0 len=1 -> channel 0 |
| 28725 | **DUT** | IN  pkt #180 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28725 | **DUT** | OUT ch0 pkt #179 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 28725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28745 | **DUT** | IN  pkt #181 header: addr=0 len=1 -> channel 0 |
| 28765 | **DUT** | IN  pkt #181 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28765 | **DUT** | OUT ch0 pkt #179 done: 3 bytes in 5 cycles |
| 28765 | scoreboard | ch0 pkt matched: addr=0 len=1 (179 matched so far) |
| 28765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28775 | **DUT** | OUT ch0 pkt #180 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28795 | **DUT** | OUT ch0 pkt #180 done: 3 bytes in 3 cycles |
| 28795 | scoreboard | ch0 pkt matched: addr=0 len=1 (180 matched so far) |
| 28805 | **DUT** | OUT ch0 pkt #181 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 28825 | **DUT** | OUT ch0 pkt #181 done: 3 bytes in 3 cycles |
| 28825 | scoreboard | ch0 pkt matched: addr=0 len=1 (181 matched so far) |
| 28855 | **DUT** | IN  pkt #182 header: addr=0 len=1 -> channel 0 |
| 28875 | **DUT** | IN  pkt #182 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 28875 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 28925 | **DUT** | OUT ch0 pkt #182 start: addr=0 len=1 (receiver waited 6 cycle(s)) |
| 29015 | **DUT** | OUT ch0 pkt #182 done: 3 bytes in 10 cycles |
| 29015 | scoreboard | ch0 pkt matched: addr=0 len=1 (182 matched so far) |
| 29045 | **DUT** | IN  pkt #183 header: addr=0 len=1 -> channel 0 |
| 29055 | **DUT** | OUT ch0 pkt #183 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29065 | **DUT** | IN  pkt #183 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29065 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29075 | **DUT** | OUT ch0 pkt #183 done: 3 bytes in 3 cycles |
| 29075 | scoreboard | ch0 pkt matched: addr=0 len=1 (183 matched so far) |
| 29185 | **DUT** | IN  pkt #184 header: addr=0 len=1 -> channel 0 |
| 29195 | **DUT** | OUT ch0 pkt #184 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29205 | **DUT** | IN  pkt #184 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29215 | **DUT** | OUT ch0 pkt #184 done: 3 bytes in 3 cycles |
| 29215 | scoreboard | ch0 pkt matched: addr=0 len=1 (184 matched so far) |
| 29415 | **DUT** | IN  pkt #185 header: addr=0 len=1 -> channel 0 |
| 29425 | **DUT** | OUT ch0 pkt #185 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29435 | **DUT** | IN  pkt #185 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29435 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29445 | **DUT** | OUT ch0 pkt #185 done: 3 bytes in 3 cycles |
| 29445 | scoreboard | ch0 pkt matched: addr=0 len=1 (185 matched so far) |
| 29635 | **DUT** | IN  pkt #186 header: addr=0 len=1 -> channel 0 |
| 29655 | **DUT** | IN  pkt #186 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29705 | **DUT** | IN  pkt #187 header: addr=0 len=1 -> channel 0 |
| 29725 | **DUT** | IN  pkt #187 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29725 | **DUT** | OUT ch0 pkt #186 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 29725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29825 | **DUT** | OUT ch0 pkt #186 done: 3 bytes in 11 cycles |
| 29825 | scoreboard | ch0 pkt matched: addr=0 len=1 (186 matched so far) |
| 29835 | **DUT** | OUT ch0 pkt #187 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29855 | **DUT** | OUT ch0 pkt #187 done: 3 bytes in 3 cycles |
| 29855 | scoreboard | ch0 pkt matched: addr=0 len=1 (187 matched so far) |
| 29875 | **DUT** | IN  pkt #188 header: addr=0 len=1 -> channel 0 |
| 29885 | **DUT** | OUT ch0 pkt #188 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 29895 | **DUT** | IN  pkt #188 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 29895 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 29905 | **DUT** | OUT ch0 pkt #188 done: 3 bytes in 3 cycles |
| 29905 | scoreboard | ch0 pkt matched: addr=0 len=1 (188 matched so far) |
| 30085 | **DUT** | IN  pkt #189 header: addr=0 len=1 -> channel 0 |
| 30105 | **DUT** | IN  pkt #189 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30105 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30195 | **DUT** | OUT ch0 pkt #189 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 30235 | **DUT** | OUT ch0 pkt #189 done: 3 bytes in 5 cycles |
| 30235 | scoreboard | ch0 pkt matched: addr=0 len=1 (189 matched so far) |
| 30285 | **DUT** | IN  pkt #190 header: addr=0 len=1 -> channel 0 |
| 30295 | **DUT** | OUT ch0 pkt #190 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30305 | **DUT** | IN  pkt #190 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30305 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30315 | **DUT** | OUT ch0 pkt #190 done: 3 bytes in 3 cycles |
| 30315 | scoreboard | ch0 pkt matched: addr=0 len=1 (190 matched so far) |
| 30475 | **DUT** | IN  pkt #191 header: addr=0 len=1 -> channel 0 |
| 30495 | **DUT** | IN  pkt #191 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30495 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30585 | **DUT** | OUT ch0 pkt #191 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 30695 | **DUT** | OUT ch0 pkt #191 done: 3 bytes in 12 cycles |
| 30695 | scoreboard | ch0 pkt matched: addr=0 len=1 (191 matched so far) |
| 30705 | **DUT** | IN  pkt #192 header: addr=0 len=1 -> channel 0 |
| 30715 | **DUT** | OUT ch0 pkt #192 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30725 | **DUT** | IN  pkt #192 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30725 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30735 | **DUT** | OUT ch0 pkt #192 done: 3 bytes in 3 cycles |
| 30735 | scoreboard | ch0 pkt matched: addr=0 len=1 (192 matched so far) |
| 30935 | **DUT** | IN  pkt #193 header: addr=0 len=1 -> channel 0 |
| 30945 | **DUT** | OUT ch0 pkt #193 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 30955 | **DUT** | IN  pkt #193 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 30955 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 30965 | **DUT** | OUT ch0 pkt #193 done: 3 bytes in 3 cycles |
| 30965 | scoreboard | ch0 pkt matched: addr=0 len=1 (193 matched so far) |
| 31015 | **DUT** | IN  pkt #194 header: addr=0 len=1 -> channel 0 |
| 31035 | **DUT** | IN  pkt #194 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31095 | **DUT** | IN  pkt #195 header: addr=0 len=1 -> channel 0 |
| 31115 | **DUT** | IN  pkt #195 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31115 | **DUT** | OUT ch0 pkt #194 start: addr=0 len=1 (receiver waited 9 cycle(s)) |
| 31115 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31175 | **DUT** | OUT ch0 pkt #194 done: 3 bytes in 7 cycles |
| 31175 | scoreboard | ch0 pkt matched: addr=0 len=1 (194 matched so far) |
| 31185 | **DUT** | OUT ch0 pkt #195 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31205 | **DUT** | OUT ch0 pkt #195 done: 3 bytes in 3 cycles |
| 31205 | scoreboard | ch0 pkt matched: addr=0 len=1 (195 matched so far) |
| 31325 | **DUT** | IN  pkt #196 header: addr=0 len=1 -> channel 0 |
| 31335 | **DUT** | OUT ch0 pkt #196 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31345 | **DUT** | IN  pkt #196 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31355 | **DUT** | OUT ch0 pkt #196 done: 3 bytes in 3 cycles |
| 31355 | scoreboard | ch0 pkt matched: addr=0 len=1 (196 matched so far) |
| 31525 | **DUT** | IN  pkt #197 header: addr=0 len=1 -> channel 0 |
| 31545 | **DUT** | IN  pkt #197 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31575 | **DUT** | OUT ch0 pkt #197 start: addr=0 len=1 (receiver waited 4 cycle(s)) |
| 31635 | **DUT** | OUT ch0 pkt #197 done: 3 bytes in 7 cycles |
| 31635 | scoreboard | ch0 pkt matched: addr=0 len=1 (197 matched so far) |
| 31745 | **DUT** | IN  pkt #198 header: addr=0 len=1 -> channel 0 |
| 31755 | **DUT** | OUT ch0 pkt #198 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 31765 | **DUT** | IN  pkt #198 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 31775 | **DUT** | OUT ch0 pkt #198 done: 3 bytes in 3 cycles |
| 31775 | scoreboard | ch0 pkt matched: addr=0 len=1 (198 matched so far) |
| 31975 | **DUT** | IN  pkt #199 header: addr=0 len=1 -> channel 0 |
| 31995 | **DUT** | IN  pkt #199 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 31995 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32015 | **DUT** | OUT ch0 pkt #199 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 32075 | **DUT** | IN  pkt #200 header: addr=0 len=1 -> channel 0 |
| 32095 | **DUT** | IN  pkt #200 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32135 | **DUT** | OUT ch0 pkt #199 done: 3 bytes in 13 cycles |
| 32135 | scoreboard | ch0 pkt matched: addr=0 len=1 (199 matched so far) |
| 32145 | **DUT** | OUT ch0 pkt #200 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32165 | **DUT** | OUT ch0 pkt #200 done: 3 bytes in 3 cycles |
| 32165 | scoreboard | ch0 pkt matched: addr=0 len=1 (200 matched so far) |
| 32305 | **DUT** | IN  pkt #201 header: addr=0 len=1 -> channel 0 |
| 32315 | **DUT** | OUT ch0 pkt #201 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32325 | **DUT** | IN  pkt #201 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32335 | **DUT** | OUT ch0 pkt #201 done: 3 bytes in 3 cycles |
| 32335 | scoreboard | ch0 pkt matched: addr=0 len=1 (201 matched so far) |
| 32515 | **DUT** | IN  pkt #202 header: addr=0 len=1 -> channel 0 |
| 32525 | **DUT** | OUT ch0 pkt #202 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32535 | **DUT** | IN  pkt #202 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32535 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32545 | **DUT** | OUT ch0 pkt #202 done: 3 bytes in 3 cycles |
| 32545 | scoreboard | ch0 pkt matched: addr=0 len=1 (202 matched so far) |
| 32745 | **DUT** | IN  pkt #203 header: addr=0 len=1 -> channel 0 |
| 32765 | **DUT** | IN  pkt #203 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32765 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32775 | **DUT** | OUT ch0 pkt #203 start: addr=0 len=1 (receiver waited 2 cycle(s)) |
| 32825 | **DUT** | OUT ch0 pkt #203 done: 3 bytes in 6 cycles |
| 32825 | scoreboard | ch0 pkt matched: addr=0 len=1 (203 matched so far) |
| 32965 | **DUT** | IN  pkt #204 header: addr=0 len=1 -> channel 0 |
| 32975 | **DUT** | OUT ch0 pkt #204 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 32985 | **DUT** | IN  pkt #204 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 32985 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 32995 | **DUT** | OUT ch0 pkt #204 done: 3 bytes in 3 cycles |
| 32995 | scoreboard | ch0 pkt matched: addr=0 len=1 (204 matched so far) |
| 33195 | **DUT** | IN  pkt #205 header: addr=0 len=1 -> channel 0 |
| 33205 | **DUT** | OUT ch0 pkt #205 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33215 | **DUT** | IN  pkt #205 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33215 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33315 | **DUT** | OUT ch0 pkt #205 done: 3 bytes in 12 cycles |
| 33315 | scoreboard | ch0 pkt matched: addr=0 len=1 (205 matched so far) |
| 33385 | **DUT** | IN  pkt #206 header: addr=0 len=1 -> channel 0 |
| 33405 | **DUT** | IN  pkt #206 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33405 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33495 | **DUT** | OUT ch0 pkt #206 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 33585 | **DUT** | IN  pkt #207 header: addr=0 len=1 -> channel 0 |
| 33595 | **DUT** | OUT ch0 pkt #206 done: 3 bytes in 11 cycles |
| 33595 | scoreboard | ch0 pkt matched: addr=0 len=1 (206 matched so far) |
| 33605 | **DUT** | IN  pkt #207 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33605 | **DUT** | OUT ch0 pkt #207 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33605 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33625 | **DUT** | OUT ch0 pkt #207 done: 3 bytes in 3 cycles |
| 33625 | scoreboard | ch0 pkt matched: addr=0 len=1 (207 matched so far) |
| 33735 | **DUT** | IN  pkt #208 header: addr=0 len=1 -> channel 0 |
| 33745 | **DUT** | OUT ch0 pkt #208 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 33755 | **DUT** | IN  pkt #208 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33755 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 33765 | **DUT** | OUT ch0 pkt #208 done: 3 bytes in 3 cycles |
| 33765 | scoreboard | ch0 pkt matched: addr=0 len=1 (208 matched so far) |
| 33915 | **DUT** | IN  pkt #209 header: addr=0 len=1 -> channel 0 |
| 33935 | **DUT** | IN  pkt #209 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34025 | **DUT** | OUT ch0 pkt #209 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 34105 | **DUT** | IN  pkt #210 header: addr=0 len=1 -> channel 0 |
| 34125 | **DUT** | IN  pkt #210 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34155 | **DUT** | OUT ch0 pkt #209 done: 3 bytes in 14 cycles |
| 34155 | scoreboard | ch0 pkt matched: addr=0 len=1 (209 matched so far) |
| 34165 | **DUT** | OUT ch0 pkt #210 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34185 | **DUT** | OUT ch0 pkt #210 done: 3 bytes in 3 cycles |
| 34185 | scoreboard | ch0 pkt matched: addr=0 len=1 (210 matched so far) |
| 34315 | **DUT** | IN  pkt #211 header: addr=0 len=1 -> channel 0 |
| 34335 | **DUT** | IN  pkt #211 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34335 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34375 | **DUT** | IN  pkt #212 header: addr=0 len=1 -> channel 0 |
| 34395 | **DUT** | IN  pkt #212 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34395 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34425 | **DUT** | OUT ch0 pkt #211 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 34495 | **DUT** | IN  pkt #213 header: addr=0 len=1 -> channel 0 |
| 34505 | **DUT** | OUT ch0 pkt #211 done: 3 bytes in 9 cycles |
| 34505 | scoreboard | ch0 pkt matched: addr=0 len=1 (211 matched so far) |
| 34515 | **DUT** | IN  pkt #213 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34515 | **DUT** | OUT ch0 pkt #212 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34515 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34535 | **DUT** | OUT ch0 pkt #212 done: 3 bytes in 3 cycles |
| 34535 | scoreboard | ch0 pkt matched: addr=0 len=1 (212 matched so far) |
| 34545 | **DUT** | OUT ch0 pkt #213 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34565 | **DUT** | OUT ch0 pkt #213 done: 3 bytes in 3 cycles |
| 34565 | scoreboard | ch0 pkt matched: addr=0 len=1 (213 matched so far) |
| 34635 | **DUT** | IN  pkt #214 header: addr=0 len=1 -> channel 0 |
| 34645 | **DUT** | OUT ch0 pkt #214 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 34655 | **DUT** | IN  pkt #214 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34655 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34665 | **DUT** | OUT ch0 pkt #214 done: 3 bytes in 3 cycles |
| 34665 | scoreboard | ch0 pkt matched: addr=0 len=1 (214 matched so far) |
| 34865 | **DUT** | IN  pkt #215 header: addr=0 len=1 -> channel 0 |
| 34885 | **DUT** | IN  pkt #215 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 34885 | **DUT** | OUT ch0 pkt #215 start: addr=0 len=1 (receiver waited 1 cycle(s)) |
| 34885 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 34995 | **DUT** | OUT ch0 pkt #215 done: 3 bytes in 12 cycles |
| 34995 | scoreboard | ch0 pkt matched: addr=0 len=1 (215 matched so far) |
| 35075 | **DUT** | IN  pkt #216 header: addr=0 len=1 -> channel 0 |
| 35085 | **DUT** | OUT ch0 pkt #216 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35095 | **DUT** | IN  pkt #216 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35095 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35105 | **DUT** | OUT ch0 pkt #216 done: 3 bytes in 3 cycles |
| 35105 | scoreboard | ch0 pkt matched: addr=0 len=1 (216 matched so far) |
| 35135 | **DUT** | IN  pkt #217 header: addr=0 len=1 -> channel 0 |
| 35145 | **DUT** | OUT ch0 pkt #217 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35155 | **DUT** | IN  pkt #217 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35155 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35165 | **DUT** | OUT ch0 pkt #217 done: 3 bytes in 3 cycles |
| 35165 | scoreboard | ch0 pkt matched: addr=0 len=1 (217 matched so far) |
| 35215 | **DUT** | IN  pkt #218 header: addr=0 len=1 -> channel 0 |
| 35225 | **DUT** | OUT ch0 pkt #218 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35235 | **DUT** | IN  pkt #218 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35235 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35245 | **DUT** | OUT ch0 pkt #218 done: 3 bytes in 3 cycles |
| 35245 | scoreboard | ch0 pkt matched: addr=0 len=1 (218 matched so far) |
| 35425 | **DUT** | IN  pkt #219 header: addr=0 len=1 -> channel 0 |
| 35435 | **DUT** | OUT ch0 pkt #219 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35445 | **DUT** | IN  pkt #219 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35445 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35455 | **DUT** | OUT ch0 pkt #219 done: 3 bytes in 3 cycles |
| 35455 | scoreboard | ch0 pkt matched: addr=0 len=1 (219 matched so far) |
| 35505 | **DUT** | IN  pkt #220 header: addr=0 len=1 -> channel 0 |
| 35515 | **DUT** | OUT ch0 pkt #220 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35525 | **DUT** | IN  pkt #220 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35525 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35535 | **DUT** | OUT ch0 pkt #220 done: 3 bytes in 3 cycles |
| 35535 | scoreboard | ch0 pkt matched: addr=0 len=1 (220 matched so far) |
| 35725 | **DUT** | IN  pkt #221 header: addr=0 len=1 -> channel 0 |
| 35745 | **DUT** | IN  pkt #221 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35815 | **DUT** | OUT ch0 pkt #221 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 35945 | **DUT** | OUT ch0 pkt #221 done: 3 bytes in 14 cycles |
| 35945 | scoreboard | ch0 pkt matched: addr=0 len=1 (221 matched so far) |
| 35955 | **DUT** | IN  pkt #222 header: addr=0 len=1 -> channel 0 |
| 35965 | **DUT** | OUT ch0 pkt #222 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 35975 | **DUT** | IN  pkt #222 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 35975 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 35985 | **DUT** | OUT ch0 pkt #222 done: 3 bytes in 3 cycles |
| 35985 | scoreboard | ch0 pkt matched: addr=0 len=1 (222 matched so far) |
| 36155 | **DUT** | IN  pkt #223 header: addr=0 len=1 -> channel 0 |
| 36175 | **DUT** | IN  pkt #223 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36175 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36215 | **DUT** | OUT ch0 pkt #223 start: addr=0 len=1 (receiver waited 5 cycle(s)) |
| 36325 | **DUT** | IN  pkt #224 header: addr=0 len=1 -> channel 0 |
| 36345 | **DUT** | IN  pkt #224 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36345 | **DUT** | OUT ch0 pkt #223 done: 3 bytes in 14 cycles |
| 36345 | scoreboard | ch0 pkt matched: addr=0 len=1 (223 matched so far) |
| 36345 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36355 | **DUT** | OUT ch0 pkt #224 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36375 | **DUT** | OUT ch0 pkt #224 done: 3 bytes in 3 cycles |
| 36375 | scoreboard | ch0 pkt matched: addr=0 len=1 (224 matched so far) |
| 36555 | **DUT** | IN  pkt #225 header: addr=0 len=1 -> channel 0 |
| 36565 | **DUT** | OUT ch0 pkt #225 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 36575 | **DUT** | IN  pkt #225 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36575 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36585 | **DUT** | OUT ch0 pkt #225 done: 3 bytes in 3 cycles |
| 36585 | scoreboard | ch0 pkt matched: addr=0 len=1 (225 matched so far) |
| 36785 | **DUT** | IN  pkt #226 header: addr=0 len=1 -> channel 0 |
| 36805 | **DUT** | IN  pkt #226 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 36805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 36865 | **DUT** | OUT ch0 pkt #226 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 36905 | **DUT** | OUT ch0 pkt #226 done: 3 bytes in 5 cycles |
| 36905 | scoreboard | ch0 pkt matched: addr=0 len=1 (226 matched so far) |
| 37015 | **DUT** | IN  pkt #227 header: addr=0 len=1 -> channel 0 |
| 37025 | **DUT** | OUT ch0 pkt #227 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37035 | **DUT** | IN  pkt #227 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37045 | **DUT** | OUT ch0 pkt #227 done: 3 bytes in 3 cycles |
| 37045 | scoreboard | ch0 pkt matched: addr=0 len=1 (227 matched so far) |
| 37185 | **DUT** | IN  pkt #228 header: addr=0 len=1 -> channel 0 |
| 37195 | **DUT** | OUT ch0 pkt #228 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37205 | **DUT** | IN  pkt #228 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37205 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37215 | **DUT** | OUT ch0 pkt #228 done: 3 bytes in 3 cycles |
| 37215 | scoreboard | ch0 pkt matched: addr=0 len=1 (228 matched so far) |
| 37245 | **DUT** | IN  pkt #229 header: addr=0 len=1 -> channel 0 |
| 37255 | **DUT** | OUT ch0 pkt #229 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37265 | **DUT** | IN  pkt #229 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37265 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37275 | **DUT** | OUT ch0 pkt #229 done: 3 bytes in 3 cycles |
| 37275 | scoreboard | ch0 pkt matched: addr=0 len=1 (229 matched so far) |
| 37305 | **DUT** | IN  pkt #230 header: addr=0 len=1 -> channel 0 |
| 37325 | **DUT** | IN  pkt #230 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37385 | **DUT** | OUT ch0 pkt #230 start: addr=0 len=1 (receiver waited 7 cycle(s)) |
| 37455 | **DUT** | IN  pkt #231 header: addr=0 len=1 -> channel 0 |
| 37475 | **DUT** | IN  pkt #231 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37475 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37505 | **DUT** | OUT ch0 pkt #230 done: 3 bytes in 13 cycles |
| 37505 | scoreboard | ch0 pkt matched: addr=0 len=1 (230 matched so far) |
| 37515 | **DUT** | OUT ch0 pkt #231 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37535 | **DUT** | OUT ch0 pkt #231 done: 3 bytes in 3 cycles |
| 37535 | scoreboard | ch0 pkt matched: addr=0 len=1 (231 matched so far) |
| 37685 | **DUT** | IN  pkt #232 header: addr=0 len=1 -> channel 0 |
| 37695 | **DUT** | OUT ch0 pkt #232 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 37705 | **DUT** | IN  pkt #232 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37715 | **DUT** | OUT ch0 pkt #232 done: 3 bytes in 3 cycles |
| 37715 | scoreboard | ch0 pkt matched: addr=0 len=1 (232 matched so far) |
| 37785 | **DUT** | IN  pkt #233 header: addr=0 len=1 -> channel 0 |
| 37805 | **DUT** | IN  pkt #233 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 37805 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 37875 | **DUT** | OUT ch0 pkt #233 start: addr=0 len=1 (receiver waited 8 cycle(s)) |
| 37965 | **DUT** | OUT ch0 pkt #233 done: 3 bytes in 10 cycles |
| 37965 | scoreboard | ch0 pkt matched: addr=0 len=1 (233 matched so far) |
| 38015 | **DUT** | IN  pkt #234 header: addr=0 len=1 -> channel 0 |
| 38025 | **DUT** | OUT ch0 pkt #234 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38035 | **DUT** | IN  pkt #234 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38035 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38045 | **DUT** | OUT ch0 pkt #234 done: 3 bytes in 3 cycles |
| 38045 | scoreboard | ch0 pkt matched: addr=0 len=1 (234 matched so far) |
| 38105 | **DUT** | IN  pkt #235 header: addr=0 len=1 -> channel 0 |
| 38115 | **DUT** | OUT ch0 pkt #235 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38125 | **DUT** | IN  pkt #235 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38125 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38215 | **DUT** | OUT ch0 pkt #235 done: 3 bytes in 11 cycles |
| 38215 | scoreboard | ch0 pkt matched: addr=0 len=1 (235 matched so far) |
| 38295 | **DUT** | IN  pkt #236 header: addr=0 len=1 -> channel 0 |
| 38305 | **DUT** | OUT ch0 pkt #236 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38315 | **DUT** | IN  pkt #236 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38315 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38325 | **DUT** | OUT ch0 pkt #236 done: 3 bytes in 3 cycles |
| 38325 | scoreboard | ch0 pkt matched: addr=0 len=1 (236 matched so far) |
| 38525 | **DUT** | IN  pkt #237 header: addr=0 len=1 -> channel 0 |
| 38545 | **DUT** | IN  pkt #237 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38545 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38635 | **DUT** | OUT ch0 pkt #237 start: addr=0 len=1 (receiver waited 10 cycle(s)) |
| 38675 | **DUT** | OUT ch0 pkt #237 done: 3 bytes in 5 cycles |
| 38675 | scoreboard | ch0 pkt matched: addr=0 len=1 (237 matched so far) |
| 38725 | **DUT** | IN  pkt #238 header: addr=0 len=1 -> channel 0 |
| 38735 | **DUT** | OUT ch0 pkt #238 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38745 | **DUT** | IN  pkt #238 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38745 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38755 | **DUT** | OUT ch0 pkt #238 done: 3 bytes in 3 cycles |
| 38755 | scoreboard | ch0 pkt matched: addr=0 len=1 (238 matched so far) |
| 38805 | **DUT** | IN  pkt #239 header: addr=0 len=1 -> channel 0 |
| 38815 | **DUT** | OUT ch0 pkt #239 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38825 | **DUT** | IN  pkt #239 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38825 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38835 | **DUT** | OUT ch0 pkt #239 done: 3 bytes in 3 cycles |
| 38835 | scoreboard | ch0 pkt matched: addr=0 len=1 (239 matched so far) |
| 38885 | **DUT** | IN  pkt #240 header: addr=0 len=1 -> channel 0 |
| 38895 | **DUT** | OUT ch0 pkt #240 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 38905 | **DUT** | IN  pkt #240 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 38905 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 38915 | **DUT** | OUT ch0 pkt #240 done: 3 bytes in 3 cycles |
| 38915 | scoreboard | ch0 pkt matched: addr=0 len=1 (240 matched so far) |
| 39035 | **DUT** | IN  pkt #241 header: addr=0 len=1 -> channel 0 |
| 39045 | **DUT** | OUT ch0 pkt #241 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39055 | **DUT** | IN  pkt #241 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39055 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39065 | **DUT** | OUT ch0 pkt #241 done: 3 bytes in 3 cycles |
| 39065 | scoreboard | ch0 pkt matched: addr=0 len=1 (241 matched so far) |
| 39235 | **DUT** | IN  pkt #242 header: addr=0 len=1 -> channel 0 |
| 39245 | **DUT** | OUT ch0 pkt #242 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39255 | **DUT** | IN  pkt #242 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39255 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39315 | **DUT** | OUT ch0 pkt #242 done: 3 bytes in 8 cycles |
| 39315 | scoreboard | ch0 pkt matched: addr=0 len=1 (242 matched so far) |
| 39465 | **DUT** | IN  pkt #243 header: addr=0 len=1 -> channel 0 |
| 39475 | **DUT** | OUT ch0 pkt #243 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39485 | **DUT** | IN  pkt #243 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39485 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39495 | **DUT** | OUT ch0 pkt #243 done: 3 bytes in 3 cycles |
| 39495 | scoreboard | ch0 pkt matched: addr=0 len=1 (243 matched so far) |
| 39685 | **DUT** | IN  pkt #244 header: addr=0 len=1 -> channel 0 |
| 39695 | **DUT** | OUT ch0 pkt #244 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 39705 | **DUT** | IN  pkt #244 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39705 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39715 | **DUT** | OUT ch0 pkt #244 done: 3 bytes in 3 cycles |
| 39715 | scoreboard | ch0 pkt matched: addr=0 len=1 (244 matched so far) |
| 39915 | **DUT** | IN  pkt #245 header: addr=0 len=1 -> channel 0 |
| 39935 | **DUT** | IN  pkt #245 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 39935 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 39955 | **DUT** | OUT ch0 pkt #245 start: addr=0 len=1 (receiver waited 3 cycle(s)) |
| 40065 | **DUT** | OUT ch0 pkt #245 done: 3 bytes in 12 cycles |
| 40065 | scoreboard | ch0 pkt matched: addr=0 len=1 (245 matched so far) |
| 40145 | **DUT** | IN  pkt #246 header: addr=0 len=1 -> channel 0 |
| 40155 | **DUT** | OUT ch0 pkt #246 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40165 | **DUT** | IN  pkt #246 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40165 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40175 | **DUT** | OUT ch0 pkt #246 done: 3 bytes in 3 cycles |
| 40175 | scoreboard | ch0 pkt matched: addr=0 len=1 (246 matched so far) |
| 40205 | **DUT** | IN  pkt #247 header: addr=0 len=1 -> channel 0 |
| 40215 | **DUT** | OUT ch0 pkt #247 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40225 | **DUT** | IN  pkt #247 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40225 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40235 | **DUT** | OUT ch0 pkt #247 done: 3 bytes in 3 cycles |
| 40235 | scoreboard | ch0 pkt matched: addr=0 len=1 (247 matched so far) |
| 40305 | **DUT** | IN  pkt #248 header: addr=0 len=1 -> channel 0 |
| 40315 | **DUT** | OUT ch0 pkt #248 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40325 | **DUT** | IN  pkt #248 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40325 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40425 | **DUT** | OUT ch0 pkt #248 done: 3 bytes in 12 cycles |
| 40425 | scoreboard | ch0 pkt matched: addr=0 len=1 (248 matched so far) |
| 40435 | **DUT** | IN  pkt #249 header: addr=0 len=1 -> channel 0 |
| 40445 | **DUT** | OUT ch0 pkt #249 start: addr=0 len=1 (receiver waited 0 cycle(s)) |
| 40455 | **DUT** | IN  pkt #249 complete: addr=0 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 40455 | reference | Packet forwarded: addr=0 len=1 -> channel 0 |
| 40465 | **DUT** | OUT ch0 pkt #249 done: 3 bytes in 3 cycles |
| 40465 | scoreboard | ch0 pkt matched: addr=0 len=1 (249 matched so far) |
| 40515 | **DUT** | IN  pkt #250 header: addr=0 len=1 -> channel 0 |
