# hbus_sweep_test  seed 4

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 315us · log `hbus_sweep_test_s4.log`

Waves: `hbus_sweep_test_s4.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fhbus_sweep_test_s4%2Fhbus_sweep_test_s4.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 1021.
- Router: **1** forwarded, **1020** dropped (1020 oversized).
- Packets out: ch0 **1**, ch1 **0**, ch2 **0**.
- Scoreboard: 1 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 1020.
- HBUS: 1459 write(s), 3628 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | 1. one 20-byte packet to address 0, so yapp_pkt_mem holds known bytes |
| 480 | 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 32520 | 3. ctrl_reg and en_reg: walking one and walking zero |
| 34160 | 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 68080 | 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 72320 | 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 136320 | 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136520 | 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 180830 | 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 226260 | 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 270270 | 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 313760 | 8. ctrl_reg and en_reg back to their reset values, every register read |
| 314220 | sweep done: 1021 packets, 3628 HBUS reads |
| 314715 | 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 314715 | done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 0**

![first packet out on channel 0](wave_first_packet_out.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

11348 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. one 20-byte packet to address 0, so yapp_pkt_mem holds known bytes |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 265 | **DUT** | IN  pkt #1 header: addr=0 len=20 -> channel 0 |
| 355 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=20 (receiver waited 8 cycle(s)) |
| 475 | **DUT** | IN  pkt #1 complete: addr=0 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 475 | yapp monitor | RX pkt #1 on the input: addr=0 len=20 parity=good gap=21 |
| 475 | reference | Packet forwarded: addr=0 len=20 -> channel 0 |
| 480 | **test** | STAGE: 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 505 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 505 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 505 | reference | maxpktsize is now 0 |
| 535 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 560 | ch0 driver | ch0: packet consumed (response delay 8) |
| 565 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 675 | **DUT** | OUT ch0 pkt #1 done: 22 bytes in 33 cycles |
| 675 | ch0 monitor | ch0 RX pkt #1: addr=0 len=20 parity=good |
| 675 | scoreboard | ch0 pkt matched: addr=0 len=20 (1 matched so far) |
| 685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 890 | ch0 driver | ch0: packet consumed (response delay 10) |
| 895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1005 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 1005 | hbus monitor | Collected WRITE addr=0x1000 data=0xff |
| 1005 | reference | maxpktsize is now 63 |
| 1035 | hbus monitor | Collected READ  addr=0x1000 data=0xff |
| 1065 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1505 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1505 | hbus monitor | Collected WRITE addr=0x1000 data=0x55 |
| 1505 | reference | maxpktsize is now 21 |
| 1535 | hbus monitor | Collected READ  addr=0x1000 data=0x55 |
| 1565 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2005 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 2005 | hbus monitor | Collected WRITE addr=0x1000 data=0xaa |
| 2005 | reference | maxpktsize is now 42 |
| 2035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2065 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 2095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2505 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 2505 | hbus monitor | Collected WRITE addr=0x1001 data=0x00 |
| 2505 | reference | router_en is now 0 (en_reg 0x00) |
| 2535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2565 | hbus monitor | Collected READ  addr=0x1001 data=0x00 |
| 2595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3005 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 3005 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 3005 | reference | router_en is now 1 (en_reg 0xff) |
| 3035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3065 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 3095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3505 | hbus monitor | Collected WRITE addr=0x1001 data=0x55 |
| 3505 | reference | router_en is now 1 (en_reg 0x55) |
| 3535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3565 | hbus monitor | Collected READ  addr=0x1001 data=0x55 |
| 3595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4005 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 4005 | hbus monitor | Collected WRITE addr=0x1001 data=0xaa |
| 4005 | reference | router_en is now 0 (en_reg 0xaa) |
| 4035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4505 | hbus monitor | Collected WRITE addr=0x1002 data=0x00 |
| 4535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5005 | hbus monitor | Collected WRITE addr=0x1002 data=0xff |
| 5035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5505 | hbus monitor | Collected WRITE addr=0x1002 data=0x55 |
| 5535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6005 | hbus monitor | Collected WRITE addr=0x1002 data=0xaa |
| 6035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6505 | hbus monitor | Collected WRITE addr=0x1003 data=0x00 |
| 6535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7005 | hbus monitor | Collected WRITE addr=0x1003 data=0xff |
| 7035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7505 | hbus monitor | Collected WRITE addr=0x1003 data=0x55 |
| 7535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8005 | hbus monitor | Collected WRITE addr=0x1003 data=0xaa |
| 8035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8505 | hbus monitor | Collected WRITE addr=0x1004 data=0x00 |
| 8535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9005 | hbus monitor | Collected WRITE addr=0x1004 data=0xff |
| 9035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9505 | hbus monitor | Collected WRITE addr=0x1004 data=0x55 |
| 9535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10005 | hbus monitor | Collected WRITE addr=0x1004 data=0xaa |
| 10035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10505 | hbus monitor | Collected WRITE addr=0x1005 data=0x00 |
| 10535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11005 | hbus monitor | Collected WRITE addr=0x1005 data=0xff |
| 11035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11505 | hbus monitor | Collected WRITE addr=0x1005 data=0x55 |
| 11535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12005 | hbus monitor | Collected WRITE addr=0x1005 data=0xaa |
| 12035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12505 | hbus monitor | Collected WRITE addr=0x1006 data=0x00 |
| 12535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13005 | hbus monitor | Collected WRITE addr=0x1006 data=0xff |
| 13035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13505 | hbus monitor | Collected WRITE addr=0x1006 data=0x55 |
| 13535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14005 | hbus monitor | Collected WRITE addr=0x1006 data=0xaa |
| 14035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14505 | hbus monitor | Collected WRITE addr=0x1007 data=0x00 |
| 14535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15005 | hbus monitor | Collected WRITE addr=0x1007 data=0xff |
| 15035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15505 | hbus monitor | Collected WRITE addr=0x1007 data=0x55 |
| 15535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16005 | hbus monitor | Collected WRITE addr=0x1007 data=0xaa |
| 16035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16505 | hbus monitor | Collected WRITE addr=0x1008 data=0x00 |
| 16535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17005 | hbus monitor | Collected WRITE addr=0x1008 data=0xff |
| 17035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17505 | hbus monitor | Collected WRITE addr=0x1008 data=0x55 |
| 17535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18005 | hbus monitor | Collected WRITE addr=0x1008 data=0xaa |
| 18035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18505 | hbus monitor | Collected WRITE addr=0x1009 data=0x00 |
| 18535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19005 | hbus monitor | Collected WRITE addr=0x1009 data=0xff |
| 19035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19505 | hbus monitor | Collected WRITE addr=0x1009 data=0x55 |
| 19535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20005 | hbus monitor | Collected WRITE addr=0x1009 data=0xaa |
| 20035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20505 | hbus monitor | Collected WRITE addr=0x100a data=0x00 |
| 20535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21005 | hbus monitor | Collected WRITE addr=0x100a data=0xff |
| 21035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21505 | hbus monitor | Collected WRITE addr=0x100a data=0x55 |
| 21535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22005 | hbus monitor | Collected WRITE addr=0x100a data=0xaa |
| 22035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22505 | hbus monitor | Collected WRITE addr=0x100b data=0x00 |
| 22535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23005 | hbus monitor | Collected WRITE addr=0x100b data=0xff |
| 23035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23505 | hbus monitor | Collected WRITE addr=0x100b data=0x55 |
| 23535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24005 | hbus monitor | Collected WRITE addr=0x100b data=0xaa |
| 24035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24505 | hbus monitor | Collected WRITE addr=0x100c data=0x00 |
| 24535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25005 | hbus monitor | Collected WRITE addr=0x100c data=0xff |
| 25035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25505 | hbus monitor | Collected WRITE addr=0x100c data=0x55 |
| 25535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26005 | hbus monitor | Collected WRITE addr=0x100c data=0xaa |
| 26035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26505 | hbus monitor | Collected WRITE addr=0x100d data=0x00 |
| 26535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27005 | hbus monitor | Collected WRITE addr=0x100d data=0xff |
| 27035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27505 | hbus monitor | Collected WRITE addr=0x100d data=0x55 |
| 27535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28005 | hbus monitor | Collected WRITE addr=0x100d data=0xaa |
| 28035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28505 | hbus monitor | Collected WRITE addr=0x100e data=0x00 |
| 28535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29005 | hbus monitor | Collected WRITE addr=0x100e data=0xff |
| 29035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29505 | hbus monitor | Collected WRITE addr=0x100e data=0x55 |
| 29535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30005 | hbus monitor | Collected WRITE addr=0x100e data=0xaa |
| 30035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30505 | hbus monitor | Collected WRITE addr=0x100f data=0x00 |
| 30535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31005 | hbus monitor | Collected WRITE addr=0x100f data=0xff |
| 31035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31505 | hbus monitor | Collected WRITE addr=0x100f data=0x55 |
| 31535 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31565 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 32005 | hbus monitor | Collected WRITE addr=0x100f data=0xaa |
| 32035 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 32065 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 32095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 32125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 32155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 32185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 32215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 32245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 32275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 32305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 32335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 32365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 32395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 32425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 32455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 32485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 32505 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 32505 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 32505 | reference | maxpktsize is now 63 |
| 32520 | **test** | STAGE: 3. ctrl_reg and en_reg: walking one and walking zero |
| 32525 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 32525 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 32525 | reference | router_en is now 1 (en_reg 0x01) |
| 32545 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 32545 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 32545 | reference | maxpktsize is now 1 |
| 32575 | hbus monitor | Collected READ  addr=0x1000 data=0x01 |
| 32595 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 32595 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 32595 | reference | maxpktsize is now 62 |
| 32625 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 32645 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 32645 | hbus monitor | Collected WRITE addr=0x1000 data=0x02 |
| 32645 | reference | maxpktsize is now 2 |
| 32675 | hbus monitor | Collected READ  addr=0x1000 data=0x02 |
| 32695 | **DUT** | CONFIG router_en=1 maxpktsize=61 |
| 32695 | hbus monitor | Collected WRITE addr=0x1000 data=0xfd |
| 32695 | reference | maxpktsize is now 61 |
| 32725 | hbus monitor | Collected READ  addr=0x1000 data=0xfd |
| 32745 | **DUT** | CONFIG router_en=1 maxpktsize=4 |
| 32745 | hbus monitor | Collected WRITE addr=0x1000 data=0x04 |
| 32745 | reference | maxpktsize is now 4 |
| 32775 | hbus monitor | Collected READ  addr=0x1000 data=0x04 |
| 32795 | **DUT** | CONFIG router_en=1 maxpktsize=59 |
| 32795 | hbus monitor | Collected WRITE addr=0x1000 data=0xfb |
| 32795 | reference | maxpktsize is now 59 |
| 32825 | hbus monitor | Collected READ  addr=0x1000 data=0xfb |
| 32845 | **DUT** | CONFIG router_en=1 maxpktsize=8 |
| 32845 | hbus monitor | Collected WRITE addr=0x1000 data=0x08 |
| 32845 | reference | maxpktsize is now 8 |
| 32875 | hbus monitor | Collected READ  addr=0x1000 data=0x08 |
| 32895 | **DUT** | CONFIG router_en=1 maxpktsize=55 |
| 32895 | hbus monitor | Collected WRITE addr=0x1000 data=0xf7 |
| 32895 | reference | maxpktsize is now 55 |
| 32925 | hbus monitor | Collected READ  addr=0x1000 data=0xf7 |
| 32945 | **DUT** | CONFIG router_en=1 maxpktsize=16 |
| 32945 | hbus monitor | Collected WRITE addr=0x1000 data=0x10 |
| 32945 | reference | maxpktsize is now 16 |
| 32975 | hbus monitor | Collected READ  addr=0x1000 data=0x10 |
| 32995 | **DUT** | CONFIG router_en=1 maxpktsize=47 |
| 32995 | hbus monitor | Collected WRITE addr=0x1000 data=0xef |
| 32995 | reference | maxpktsize is now 47 |
| 33025 | hbus monitor | Collected READ  addr=0x1000 data=0xef |
| 33045 | **DUT** | CONFIG router_en=1 maxpktsize=32 |
| 33045 | hbus monitor | Collected WRITE addr=0x1000 data=0x20 |
| 33045 | reference | maxpktsize is now 32 |
| 33075 | hbus monitor | Collected READ  addr=0x1000 data=0x20 |
| 33095 | **DUT** | CONFIG router_en=1 maxpktsize=31 |
| 33095 | hbus monitor | Collected WRITE addr=0x1000 data=0xdf |
| 33095 | reference | maxpktsize is now 31 |
| 33125 | hbus monitor | Collected READ  addr=0x1000 data=0xdf |
| 33145 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33145 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 33145 | reference | maxpktsize is now 0 |
| 33175 | hbus monitor | Collected READ  addr=0x1000 data=0x40 |
| 33195 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33195 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 33195 | reference | maxpktsize is now 63 |
| 33225 | hbus monitor | Collected READ  addr=0x1000 data=0xbf |
| 33245 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33245 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 33245 | reference | maxpktsize is now 0 |
| 33275 | hbus monitor | Collected READ  addr=0x1000 data=0x80 |
| 33295 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33295 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 33295 | reference | maxpktsize is now 63 |
| 33325 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 33345 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 33345 | reference | router_en is now 1 (en_reg 0x01) |
| 33375 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 33395 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33395 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 33395 | reference | router_en is now 0 (en_reg 0xfe) |
| 33425 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 33445 | hbus monitor | Collected WRITE addr=0x1001 data=0x02 |
| 33445 | reference | router_en is now 0 (en_reg 0x02) |
| 33475 | hbus monitor | Collected READ  addr=0x1001 data=0x02 |
| 33495 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33495 | hbus monitor | Collected WRITE addr=0x1001 data=0xfd |
| 33495 | reference | router_en is now 1 (en_reg 0xfd) |
| 33525 | hbus monitor | Collected READ  addr=0x1001 data=0xfd |
| 33545 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33545 | hbus monitor | Collected WRITE addr=0x1001 data=0x04 |
| 33545 | reference | router_en is now 0 (en_reg 0x04) |
| 33575 | hbus monitor | Collected READ  addr=0x1001 data=0x04 |
| 33595 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33595 | hbus monitor | Collected WRITE addr=0x1001 data=0xfb |
| 33595 | reference | router_en is now 1 (en_reg 0xfb) |
| 33625 | hbus monitor | Collected READ  addr=0x1001 data=0xfb |
| 33645 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33645 | hbus monitor | Collected WRITE addr=0x1001 data=0x08 |
| 33645 | reference | router_en is now 0 (en_reg 0x08) |
| 33675 | hbus monitor | Collected READ  addr=0x1001 data=0x08 |
| 33695 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33695 | hbus monitor | Collected WRITE addr=0x1001 data=0xf7 |
| 33695 | reference | router_en is now 1 (en_reg 0xf7) |
| 33725 | hbus monitor | Collected READ  addr=0x1001 data=0xf7 |
| 33745 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33745 | hbus monitor | Collected WRITE addr=0x1001 data=0x10 |
| 33745 | reference | router_en is now 0 (en_reg 0x10) |
| 33775 | hbus monitor | Collected READ  addr=0x1001 data=0x10 |
| 33795 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33795 | hbus monitor | Collected WRITE addr=0x1001 data=0xef |
| 33795 | reference | router_en is now 1 (en_reg 0xef) |
| 33825 | hbus monitor | Collected READ  addr=0x1001 data=0xef |
| 33845 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33845 | hbus monitor | Collected WRITE addr=0x1001 data=0x20 |
| 33845 | reference | router_en is now 0 (en_reg 0x20) |
| 33875 | hbus monitor | Collected READ  addr=0x1001 data=0x20 |
| 33895 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33895 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 33895 | reference | router_en is now 1 (en_reg 0xdf) |
| 33925 | hbus monitor | Collected READ  addr=0x1001 data=0xdf |
| 33945 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33945 | hbus monitor | Collected WRITE addr=0x1001 data=0x40 |
| 33945 | reference | router_en is now 0 (en_reg 0x40) |
| 33975 | hbus monitor | Collected READ  addr=0x1001 data=0x40 |
| 33995 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33995 | hbus monitor | Collected WRITE addr=0x1001 data=0xbf |
| 33995 | reference | router_en is now 1 (en_reg 0xbf) |
| 34025 | hbus monitor | Collected READ  addr=0x1001 data=0xbf |
| 34045 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 34045 | hbus monitor | Collected WRITE addr=0x1001 data=0x80 |
| 34045 | reference | router_en is now 0 (en_reg 0x80) |
| 34075 | hbus monitor | Collected READ  addr=0x1001 data=0x80 |
| 34095 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 34095 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 34095 | reference | router_en is now 1 (en_reg 0x7f) |
| 34125 | hbus monitor | Collected READ  addr=0x1001 data=0x7f |
| 34145 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 34145 | reference | maxpktsize is now 63 |
| 34160 | **test** | STAGE: 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 34165 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 34165 | reference | router_en is now 1 (en_reg 0x01) |
| 34185 | hbus monitor | Collected WRITE addr=0x1010 data=0xd4 |
| 34215 | hbus monitor | Collected READ  addr=0x1010 data=0x50 |
| 34245 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34275 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34305 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34335 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34365 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34395 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34425 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34455 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 34485 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 34515 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 34545 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 34575 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 34605 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 34635 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 34665 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 34695 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 34715 | hbus monitor | Collected WRITE addr=0x1011 data=0x93 |
| 34745 | hbus monitor | Collected READ  addr=0x1011 data=0x0e |
| 34775 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34805 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34835 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34865 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34895 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34925 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34955 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34985 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35015 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35045 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 35075 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 35105 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35135 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35165 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35195 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35225 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35245 | hbus monitor | Collected WRITE addr=0x1012 data=0xbf |
| 35275 | hbus monitor | Collected READ  addr=0x1012 data=0x94 |
| 35305 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35335 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35365 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35395 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35425 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35455 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 35485 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 35515 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35545 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35575 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 35605 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 35635 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35665 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35695 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35725 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35755 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35775 | hbus monitor | Collected WRITE addr=0x1013 data=0x3c |
| 35805 | hbus monitor | Collected READ  addr=0x1013 data=0xfd |
| 35835 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35865 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35895 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35925 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35955 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35985 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36015 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36045 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36075 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 36105 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36135 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36165 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36195 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36225 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36255 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36285 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36305 | hbus monitor | Collected WRITE addr=0x1014 data=0x6f |
| 36335 | hbus monitor | Collected READ  addr=0x1014 data=0x59 |
| 36365 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36395 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36425 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36455 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 36485 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 36515 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36545 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36575 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36605 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 36635 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36665 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36695 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36725 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36755 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36785 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36815 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36835 | hbus monitor | Collected WRITE addr=0x1015 data=0x8b |
| 36865 | hbus monitor | Collected READ  addr=0x1015 data=0x37 |
| 36895 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36925 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36955 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36985 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37015 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37045 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 37075 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 37105 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37135 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37165 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37195 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37225 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37255 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37285 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37315 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37345 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37365 | hbus monitor | Collected WRITE addr=0x1016 data=0x53 |
| 37395 | hbus monitor | Collected READ  addr=0x1016 data=0x92 |
| 37425 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37455 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 37485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 37515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 37605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 37635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37895 | hbus monitor | Collected WRITE addr=0x1017 data=0x44 |
| 37925 | hbus monitor | Collected READ  addr=0x1017 data=0xd6 |
| 37955 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37985 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38015 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38045 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 38075 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 38105 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38135 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38165 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38195 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38225 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38255 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38285 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38315 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38345 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38375 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38405 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38425 | hbus monitor | Collected WRITE addr=0x1018 data=0x3d |
| 38455 | hbus monitor | Collected READ  addr=0x1018 data=0x87 |
| 38485 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 38515 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38545 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38575 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 38605 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 38635 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38665 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38695 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38725 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38755 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38785 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38815 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38845 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38875 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38905 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38935 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38955 | hbus monitor | Collected WRITE addr=0x1019 data=0x38 |
| 38985 | hbus monitor | Collected READ  addr=0x1019 data=0x82 |
| 39015 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39045 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 39075 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 39105 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39135 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39165 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39195 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39225 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39255 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39285 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39315 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39345 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39375 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39405 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39435 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39465 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 39485 | hbus monitor | Collected WRITE addr=0x101a data=0x80 |
| 39515 | hbus monitor | Collected READ  addr=0x101a data=0xc7 |
| 39545 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39575 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 39605 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 39635 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39665 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39695 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39725 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39755 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39785 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39815 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39845 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39875 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39905 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39935 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39965 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39995 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40015 | hbus monitor | Collected WRITE addr=0x101b data=0x8b |
| 40045 | hbus monitor | Collected READ  addr=0x101b data=0xd8 |
| 40075 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40105 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40135 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40165 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40195 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40225 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40255 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40285 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40315 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40345 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40375 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40405 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40435 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40465 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 40495 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 40525 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40545 | hbus monitor | Collected WRITE addr=0x101c data=0x87 |
| 40575 | hbus monitor | Collected READ  addr=0x101c data=0xb9 |
| 40605 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40635 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40665 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40695 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40725 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40755 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40785 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40815 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40845 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40875 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40905 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40935 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40965 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40995 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41025 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 41055 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 41075 | hbus monitor | Collected WRITE addr=0x101d data=0x83 |
| 41105 | hbus monitor | Collected READ  addr=0x101d data=0x24 |
| 41135 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41165 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41195 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41225 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41255 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41285 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41315 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41345 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41375 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41405 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41435 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41465 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 41495 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 41525 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41555 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 41585 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 41605 | hbus monitor | Collected WRITE addr=0x101e data=0x44 |
| 41635 | hbus monitor | Collected READ  addr=0x101e data=0xc2 |
| 41665 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41695 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41725 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41755 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41785 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41815 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41845 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41875 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41905 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41935 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41965 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41995 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42025 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 42055 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 42085 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42115 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42135 | hbus monitor | Collected WRITE addr=0x101f data=0x89 |
| 42165 | hbus monitor | Collected READ  addr=0x101f data=0x26 |
| 42195 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42225 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42255 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42285 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42315 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42345 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42375 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42405 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42435 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42465 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 42495 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42525 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42555 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 42585 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 42615 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42645 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42665 | hbus monitor | Collected WRITE addr=0x1020 data=0x3b |
| 42695 | hbus monitor | Collected READ  addr=0x1020 data=0x3d |
| 42725 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42755 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42785 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42815 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42845 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42875 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42905 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42935 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42965 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42995 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43025 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 43055 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 43085 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43115 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43145 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43175 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43195 | hbus monitor | Collected WRITE addr=0x1021 data=0xaa |
| 43225 | hbus monitor | Collected READ  addr=0x1021 data=0xa9 |
| 43255 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43285 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43315 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43345 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43375 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43405 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43435 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43465 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 43495 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 43525 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43555 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 43585 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 43615 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43645 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43675 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43705 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43725 | hbus monitor | Collected WRITE addr=0x1022 data=0x41 |
| 43755 | hbus monitor | Collected READ  addr=0x1022 data=0x20 |
| 43785 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43815 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43845 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43875 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43905 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43935 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43965 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43995 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44025 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 44055 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 44085 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44115 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44145 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44175 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44205 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44235 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44255 | hbus monitor | Collected WRITE addr=0x1023 data=0x80 |
| 44285 | hbus monitor | Collected READ  addr=0x1023 data=0x84 |
| 44315 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44345 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44375 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44405 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44435 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44465 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 44495 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 44525 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44555 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 44585 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 44615 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44645 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44675 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44705 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44735 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44765 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44785 | hbus monitor | Collected WRITE addr=0x1024 data=0x55 |
| 44815 | hbus monitor | Collected READ  addr=0x1024 data=0x1a |
| 44845 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44875 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44905 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44935 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44965 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44995 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45025 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 45055 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 45085 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45115 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45145 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45175 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45205 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45235 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45265 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45295 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45315 | hbus monitor | Collected WRITE addr=0x1025 data=0x83 |
| 45345 | hbus monitor | Collected READ  addr=0x1025 data=0x00 |
| 45375 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45405 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45435 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45465 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 45495 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 45525 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45555 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 45585 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 45615 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45645 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45675 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45705 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45735 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45765 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45795 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45825 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45845 | hbus monitor | Collected WRITE addr=0x1026 data=0x14 |
| 45875 | hbus monitor | Collected READ  addr=0x1026 data=0x00 |
| 45905 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45935 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45965 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45995 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46025 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 46055 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 46085 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46115 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46145 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46175 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46205 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46235 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46265 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46295 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46325 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46355 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46375 | hbus monitor | Collected WRITE addr=0x1027 data=0x7f |
| 46405 | hbus monitor | Collected READ  addr=0x1027 data=0x00 |
| 46435 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46465 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 46495 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 46525 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46555 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 46585 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 46615 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46645 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46675 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46705 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46735 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46765 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46795 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46825 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46855 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46885 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46905 | hbus monitor | Collected WRITE addr=0x1028 data=0x4f |
| 46935 | hbus monitor | Collected READ  addr=0x1028 data=0x00 |
| 46965 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46995 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47025 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 47055 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 47085 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47115 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47145 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47175 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47205 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47235 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47265 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47295 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47325 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47355 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47385 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47415 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47435 | hbus monitor | Collected WRITE addr=0x1029 data=0x6c |
| 47465 | hbus monitor | Collected READ  addr=0x1029 data=0x00 |
| 47495 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 47525 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47555 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 47585 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 47615 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47645 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47675 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47705 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47735 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47765 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47795 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47825 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47855 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47885 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47915 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47945 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47965 | hbus monitor | Collected WRITE addr=0x102a data=0x3f |
| 47995 | hbus monitor | Collected READ  addr=0x102a data=0x00 |
| 48025 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 48055 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 48085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 48475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 48495 | hbus monitor | Collected WRITE addr=0x102b data=0x5d |
| 48525 | hbus monitor | Collected READ  addr=0x102b data=0x00 |
| 48555 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 48585 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 48615 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48645 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48675 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48705 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48735 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48765 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48795 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48825 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48855 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48885 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48915 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48945 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48975 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 49005 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49025 | hbus monitor | Collected WRITE addr=0x102c data=0x14 |
| 49055 | hbus monitor | Collected READ  addr=0x102c data=0x00 |
| 49085 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49115 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49145 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49175 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49205 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49235 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49265 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49295 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49325 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49355 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49385 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49415 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49445 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 49475 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 49505 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 49535 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49555 | hbus monitor | Collected WRITE addr=0x102d data=0xd1 |
| 49585 | hbus monitor | Collected READ  addr=0x102d data=0x00 |
| 49615 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49645 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49675 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49705 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49735 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49765 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49795 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49825 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49855 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49885 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49915 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49945 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49975 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 50005 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50035 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 50065 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 50085 | hbus monitor | Collected WRITE addr=0x102e data=0x24 |
| 50115 | hbus monitor | Collected READ  addr=0x102e data=0x00 |
| 50145 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50175 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50205 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50235 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50265 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50295 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50325 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50355 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50385 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50415 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50445 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 50475 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 50505 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 50535 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50565 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 50595 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 50615 | hbus monitor | Collected WRITE addr=0x102f data=0xb1 |
| 50645 | hbus monitor | Collected READ  addr=0x102f data=0x00 |
| 50675 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50705 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50735 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50765 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50795 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50825 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50855 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50885 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50915 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50945 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50975 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 51005 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51035 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 51065 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 51095 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51125 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51145 | hbus monitor | Collected WRITE addr=0x1030 data=0xc5 |
| 51175 | hbus monitor | Collected READ  addr=0x1030 data=0x00 |
| 51205 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51235 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51265 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51295 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51325 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51355 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51385 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51415 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51445 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 51475 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 51505 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 51535 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51565 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 51595 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 51625 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51655 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51675 | hbus monitor | Collected WRITE addr=0x1031 data=0x13 |
| 51705 | hbus monitor | Collected READ  addr=0x1031 data=0x00 |
| 51735 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51765 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51795 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51825 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51855 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51885 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51915 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51945 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51975 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 52005 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52035 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 52065 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 52095 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52125 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52155 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52185 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52205 | hbus monitor | Collected WRITE addr=0x1032 data=0xa5 |
| 52235 | hbus monitor | Collected READ  addr=0x1032 data=0x00 |
| 52265 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52295 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52325 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52355 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52385 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52415 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52445 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 52475 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 52505 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 52535 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52565 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 52595 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 52625 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52655 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52685 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52715 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52735 | hbus monitor | Collected WRITE addr=0x1033 data=0x9f |
| 52765 | hbus monitor | Collected READ  addr=0x1033 data=0x00 |
| 52795 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52825 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52855 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52885 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52915 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52945 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52975 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 53005 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53035 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 53065 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 53095 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53125 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53155 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53185 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53215 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53245 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53265 | hbus monitor | Collected WRITE addr=0x1034 data=0x59 |
| 53295 | hbus monitor | Collected READ  addr=0x1034 data=0x00 |
| 53325 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53355 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53385 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53415 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53445 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 53475 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 53505 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 53535 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53565 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 53595 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 53625 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53655 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53685 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53715 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53745 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53775 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53795 | hbus monitor | Collected WRITE addr=0x1035 data=0x51 |
| 53825 | hbus monitor | Collected READ  addr=0x1035 data=0x00 |
| 53855 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53885 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53915 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53945 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53975 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 54005 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54035 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 54065 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 54095 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54125 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54155 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54185 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54215 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54245 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54275 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54305 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54325 | hbus monitor | Collected WRITE addr=0x1036 data=0xc5 |
| 54355 | hbus monitor | Collected READ  addr=0x1036 data=0x00 |
| 54385 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54415 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54445 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 54475 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 54505 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 54535 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54565 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 54595 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 54625 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54655 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54685 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54715 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54745 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54775 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54805 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54835 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54855 | hbus monitor | Collected WRITE addr=0x1037 data=0xbc |
| 54885 | hbus monitor | Collected READ  addr=0x1037 data=0x00 |
| 54915 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54945 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54975 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 55005 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55035 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 55065 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 55095 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55125 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55155 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55185 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55215 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55245 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55275 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55305 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55335 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55365 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55385 | hbus monitor | Collected WRITE addr=0x1038 data=0x30 |
| 55415 | hbus monitor | Collected READ  addr=0x1038 data=0x00 |
| 55445 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 55475 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 55505 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 55535 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55565 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 55595 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 55625 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55655 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55685 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55715 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55745 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55775 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55805 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55835 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55865 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55895 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55915 | hbus monitor | Collected WRITE addr=0x1039 data=0x6c |
| 55945 | hbus monitor | Collected READ  addr=0x1039 data=0x00 |
| 55975 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 56005 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56035 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 56065 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 56095 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56125 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56155 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56185 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56215 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56245 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56275 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56305 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56335 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56365 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56395 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56425 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56445 | hbus monitor | Collected WRITE addr=0x103a data=0x2d |
| 56475 | hbus monitor | Collected READ  addr=0x103a data=0x00 |
| 56505 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 56535 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56565 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 56595 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 56625 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56655 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56685 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56715 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56745 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56775 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56805 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56835 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56865 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56895 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56925 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56955 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56975 | hbus monitor | Collected WRITE addr=0x103b data=0x9f |
| 57005 | hbus monitor | Collected READ  addr=0x103b data=0x00 |
| 57035 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 57065 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 57095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 57485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 57505 | hbus monitor | Collected WRITE addr=0x103c data=0xcc |
| 57535 | hbus monitor | Collected READ  addr=0x103c data=0x00 |
| 57565 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 57595 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 57625 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57655 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57685 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57715 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57745 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57775 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57805 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57835 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57865 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57895 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57925 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57955 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57985 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58015 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58035 | hbus monitor | Collected WRITE addr=0x103d data=0x5f |
| 58065 | hbus monitor | Collected READ  addr=0x103d data=0x00 |
| 58095 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58125 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58155 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58185 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58215 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58245 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58275 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58305 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58335 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58365 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58395 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58425 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58455 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 58485 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 58515 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58545 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58565 | hbus monitor | Collected WRITE addr=0x103e data=0x9f |
| 58595 | hbus monitor | Collected READ  addr=0x103e data=0x00 |
| 58625 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58655 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58685 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58715 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58745 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58775 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58805 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58835 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58865 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58895 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58925 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58955 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58985 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59015 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59045 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 59075 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 59095 | hbus monitor | Collected WRITE addr=0x103f data=0xc2 |
| 59125 | hbus monitor | Collected READ  addr=0x103f data=0x00 |
| 59155 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59185 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59215 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59245 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59275 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59305 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59335 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59365 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59395 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59425 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59455 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 59485 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 59515 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59545 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59575 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 59605 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 59625 | hbus monitor | Collected WRITE addr=0x1040 data=0xb8 |
| 59655 | hbus monitor | Collected READ  addr=0x1040 data=0x00 |
| 59685 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59715 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59745 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59775 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59805 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59835 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59865 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59895 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59925 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59955 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59985 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60015 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60045 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 60075 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 60105 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60135 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60155 | hbus monitor | Collected WRITE addr=0x1041 data=0xc6 |
| 60185 | hbus monitor | Collected READ  addr=0x1041 data=0x00 |
| 60215 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60245 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60275 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60305 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60335 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60365 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60395 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60425 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60455 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 60485 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 60515 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60545 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60575 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 60605 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 60635 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60665 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60685 | hbus monitor | Collected WRITE addr=0x1042 data=0x47 |
| 60715 | hbus monitor | Collected READ  addr=0x1042 data=0x00 |
| 60745 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60775 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60805 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60835 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60865 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60895 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60925 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60955 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60985 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61015 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61045 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 61075 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 61105 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61135 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61165 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61195 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61215 | hbus monitor | Collected WRITE addr=0x1043 data=0xfa |
| 61245 | hbus monitor | Collected READ  addr=0x1043 data=0x00 |
| 61275 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61305 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61335 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61365 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61395 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61425 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61455 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 61485 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 61515 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61545 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61575 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 61605 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 61635 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61665 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61695 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61725 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61745 | hbus monitor | Collected WRITE addr=0x1044 data=0xa4 |
| 61775 | hbus monitor | Collected READ  addr=0x1044 data=0x00 |
| 61805 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61835 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61865 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61895 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61925 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61955 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61985 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62015 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62045 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 62075 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 62105 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62135 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62165 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62195 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62225 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62255 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62275 | hbus monitor | Collected WRITE addr=0x1045 data=0x5f |
| 62305 | hbus monitor | Collected READ  addr=0x1045 data=0x00 |
| 62335 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62365 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62395 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62425 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62455 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 62485 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 62515 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62545 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62575 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 62605 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 62635 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62665 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62695 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62725 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62755 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62785 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62805 | hbus monitor | Collected WRITE addr=0x1046 data=0xd7 |
| 62835 | hbus monitor | Collected READ  addr=0x1046 data=0x00 |
| 62865 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62895 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62925 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62955 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62985 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63015 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63045 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 63075 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 63105 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63135 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63165 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63195 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63225 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63255 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63285 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63315 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63335 | hbus monitor | Collected WRITE addr=0x1047 data=0xdc |
| 63365 | hbus monitor | Collected READ  addr=0x1047 data=0x00 |
| 63395 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63425 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63455 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 63485 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 63515 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63545 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63575 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 63605 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 63635 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63665 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63695 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63725 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63755 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63785 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63815 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63845 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63865 | hbus monitor | Collected WRITE addr=0x1048 data=0x3e |
| 63895 | hbus monitor | Collected READ  addr=0x1048 data=0x00 |
| 63925 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63955 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 64075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 64105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64395 | hbus monitor | Collected WRITE addr=0x1049 data=0xc0 |
| 64425 | hbus monitor | Collected READ  addr=0x1049 data=0x00 |
| 64455 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 64485 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 64515 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64545 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64575 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 64605 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 64635 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64665 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64695 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64725 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64755 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64785 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64815 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64845 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64875 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64905 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64925 | hbus monitor | Collected WRITE addr=0x104a data=0xc6 |
| 64955 | hbus monitor | Collected READ  addr=0x104a data=0x00 |
| 64985 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65015 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65045 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 65075 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 65105 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65135 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65165 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65195 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65225 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65255 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65285 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65315 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65345 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65375 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65405 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65435 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65455 | hbus monitor | Collected WRITE addr=0x104b data=0x1f |
| 65485 | hbus monitor | Collected READ  addr=0x104b data=0x00 |
| 65515 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65545 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65575 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 65605 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 65635 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65665 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65695 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65725 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65755 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65785 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65815 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65845 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65875 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65905 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65935 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65965 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65985 | hbus monitor | Collected WRITE addr=0x104c data=0x83 |
| 66015 | hbus monitor | Collected READ  addr=0x104c data=0x00 |
| 66045 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 66075 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 66105 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66135 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66165 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66195 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66225 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66255 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66285 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66315 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66345 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66375 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66405 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66435 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66465 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 66495 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 66515 | hbus monitor | Collected WRITE addr=0x104d data=0x08 |
| 66545 | hbus monitor | Collected READ  addr=0x104d data=0x00 |
| 66575 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 66605 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 66635 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66665 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66695 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66725 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66755 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66785 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66815 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66845 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66875 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66905 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66935 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66965 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66995 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67025 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67045 | hbus monitor | Collected WRITE addr=0x104e data=0x91 |
| 67075 | hbus monitor | Collected READ  addr=0x104e data=0x00 |
| 67105 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67135 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67165 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67195 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67225 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67255 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67285 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67315 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67345 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67375 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67405 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67435 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67465 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 67495 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 67525 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67555 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67575 | hbus monitor | Collected WRITE addr=0x104f data=0x40 |
| 67605 | hbus monitor | Collected READ  addr=0x104f data=0x00 |
| 67635 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67665 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67695 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67725 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67755 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67785 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67815 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67845 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67875 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67905 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67935 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67965 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67995 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68025 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 68055 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 68080 | **test** | STAGE: 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 68085 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 68105 | hbus monitor | Collected WRITE addr=0x1050 data=0xff |
| 68135 | hbus monitor | Collected READ  addr=0x1050 data=0x00 |
| 68165 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68195 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68225 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68255 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68285 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68315 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68345 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68375 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68405 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68435 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68465 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 68495 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 68525 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68555 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 68585 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 68615 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 68635 | hbus monitor | Collected WRITE addr=0x10ff data=0xff |
| 68665 | hbus monitor | Collected READ  addr=0x10ff data=0x00 |
| 68695 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68725 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68755 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68785 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68815 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68845 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68875 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68905 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68935 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68965 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68995 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69025 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 69055 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 69085 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69115 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69145 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69165 | hbus monitor | Collected WRITE addr=0x10f6 data=0xae |
| 69195 | hbus monitor | Collected READ  addr=0x10f6 data=0x00 |
| 69225 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69255 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69285 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69315 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69345 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69375 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69405 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69435 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69465 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 69495 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 69525 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69555 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 69585 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 69615 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69645 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69675 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69695 | hbus monitor | Collected WRITE addr=0x1088 data=0x58 |
| 69725 | hbus monitor | Collected READ  addr=0x1088 data=0x00 |
| 69755 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69785 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69815 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69845 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69875 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69905 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69935 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69965 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69995 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70025 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 70055 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 70085 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70115 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70145 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70175 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70205 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70225 | hbus monitor | Collected WRITE addr=0x1081 data=0xd0 |
| 70255 | hbus monitor | Collected READ  addr=0x1081 data=0x00 |
| 70285 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70315 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70345 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70375 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70405 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70435 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70465 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 70495 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 70525 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70555 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 70585 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 70615 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70645 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70675 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70705 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70735 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70755 | hbus monitor | Collected WRITE addr=0x10f4 data=0xd9 |
| 70785 | hbus monitor | Collected READ  addr=0x10f4 data=0x00 |
| 70815 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70845 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70875 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70905 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70935 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70965 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70995 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71025 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 71055 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 71085 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71115 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71145 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71175 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71205 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71235 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71265 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71285 | hbus monitor | Collected WRITE addr=0x10cf data=0x3c |
| 71315 | hbus monitor | Collected READ  addr=0x10cf data=0x00 |
| 71345 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71375 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71405 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71435 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71465 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 71495 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 71525 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71555 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 71585 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 71615 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71645 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71675 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71705 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71735 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71765 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71795 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71815 | hbus monitor | Collected WRITE addr=0x1054 data=0x39 |
| 71845 | hbus monitor | Collected READ  addr=0x1054 data=0x00 |
| 71875 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71905 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71935 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71965 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71995 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 72025 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 72055 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 72085 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 72115 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 72145 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 72175 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 72205 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 72235 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 72265 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 72295 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 72320 | **test** | STAGE: 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 72325 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 72345 | hbus monitor | Collected WRITE addr=0x1100 data=0x00 |
| 72375 | hbus monitor | Collected READ  addr=0x1100 data=0x00 |
| 72395 | hbus monitor | Collected WRITE addr=0x1101 data=0x00 |
| 72425 | hbus monitor | Collected READ  addr=0x1101 data=0x00 |
| 72445 | hbus monitor | Collected WRITE addr=0x1102 data=0x00 |
| 72475 | hbus monitor | Collected READ  addr=0x1102 data=0x00 |
| 72495 | hbus monitor | Collected WRITE addr=0x1103 data=0x00 |
| 72525 | hbus monitor | Collected READ  addr=0x1103 data=0x00 |
| 72545 | hbus monitor | Collected WRITE addr=0x1104 data=0x00 |
| 72575 | hbus monitor | Collected READ  addr=0x1104 data=0x00 |
| 72595 | hbus monitor | Collected WRITE addr=0x1105 data=0x00 |
| 72625 | hbus monitor | Collected READ  addr=0x1105 data=0x00 |
| 72645 | hbus monitor | Collected WRITE addr=0x1106 data=0x00 |
| 72675 | hbus monitor | Collected READ  addr=0x1106 data=0x00 |
| 72695 | hbus monitor | Collected WRITE addr=0x1107 data=0x00 |
| 72725 | hbus monitor | Collected READ  addr=0x1107 data=0x00 |
| 72745 | hbus monitor | Collected WRITE addr=0x1108 data=0x00 |
| 72775 | hbus monitor | Collected READ  addr=0x1108 data=0x00 |
| 72795 | hbus monitor | Collected WRITE addr=0x1109 data=0x00 |
| 72825 | hbus monitor | Collected READ  addr=0x1109 data=0x00 |
| 72845 | hbus monitor | Collected WRITE addr=0x110a data=0x00 |
| 72875 | hbus monitor | Collected READ  addr=0x110a data=0x00 |
| 72895 | hbus monitor | Collected WRITE addr=0x110b data=0x00 |
| 72925 | hbus monitor | Collected READ  addr=0x110b data=0x00 |
| 72945 | hbus monitor | Collected WRITE addr=0x110c data=0x00 |
| 72975 | hbus monitor | Collected READ  addr=0x110c data=0x00 |
| 72995 | hbus monitor | Collected WRITE addr=0x110d data=0x00 |
| 73025 | hbus monitor | Collected READ  addr=0x110d data=0x00 |
| 73045 | hbus monitor | Collected WRITE addr=0x110e data=0x00 |
| 73075 | hbus monitor | Collected READ  addr=0x110e data=0x00 |
| 73095 | hbus monitor | Collected WRITE addr=0x110f data=0x00 |
| 73125 | hbus monitor | Collected READ  addr=0x110f data=0x00 |
| 73145 | hbus monitor | Collected WRITE addr=0x1110 data=0x00 |
| 73175 | hbus monitor | Collected READ  addr=0x1110 data=0x00 |
| 73195 | hbus monitor | Collected WRITE addr=0x1111 data=0x00 |
| 73225 | hbus monitor | Collected READ  addr=0x1111 data=0x00 |
| 73245 | hbus monitor | Collected WRITE addr=0x1112 data=0x00 |
| 73275 | hbus monitor | Collected READ  addr=0x1112 data=0x00 |
| 73295 | hbus monitor | Collected WRITE addr=0x1113 data=0x00 |
| 73325 | hbus monitor | Collected READ  addr=0x1113 data=0x00 |
| 73345 | hbus monitor | Collected WRITE addr=0x1114 data=0x00 |
| 73375 | hbus monitor | Collected READ  addr=0x1114 data=0x00 |
| 73395 | hbus monitor | Collected WRITE addr=0x1115 data=0x00 |
| 73425 | hbus monitor | Collected READ  addr=0x1115 data=0x00 |
| 73445 | hbus monitor | Collected WRITE addr=0x1116 data=0x00 |
| 73475 | hbus monitor | Collected READ  addr=0x1116 data=0x00 |
| 73495 | hbus monitor | Collected WRITE addr=0x1117 data=0x00 |
| 73525 | hbus monitor | Collected READ  addr=0x1117 data=0x00 |
| 73545 | hbus monitor | Collected WRITE addr=0x1118 data=0x00 |
| 73575 | hbus monitor | Collected READ  addr=0x1118 data=0x00 |
| 73595 | hbus monitor | Collected WRITE addr=0x1119 data=0x00 |
| 73625 | hbus monitor | Collected READ  addr=0x1119 data=0x00 |
| 73645 | hbus monitor | Collected WRITE addr=0x111a data=0x00 |
| 73675 | hbus monitor | Collected READ  addr=0x111a data=0x00 |
| 73695 | hbus monitor | Collected WRITE addr=0x111b data=0x00 |
| 73725 | hbus monitor | Collected READ  addr=0x111b data=0x00 |
| 73745 | hbus monitor | Collected WRITE addr=0x111c data=0x00 |
| 73775 | hbus monitor | Collected READ  addr=0x111c data=0x00 |
| 73795 | hbus monitor | Collected WRITE addr=0x111d data=0x00 |
| 73825 | hbus monitor | Collected READ  addr=0x111d data=0x00 |
| 73845 | hbus monitor | Collected WRITE addr=0x111e data=0x00 |
| 73875 | hbus monitor | Collected READ  addr=0x111e data=0x00 |
| 73895 | hbus monitor | Collected WRITE addr=0x111f data=0x00 |
| 73925 | hbus monitor | Collected READ  addr=0x111f data=0x00 |
| 73945 | hbus monitor | Collected WRITE addr=0x1120 data=0x00 |
| 73975 | hbus monitor | Collected READ  addr=0x1120 data=0x00 |
| 73995 | hbus monitor | Collected WRITE addr=0x1121 data=0x00 |
| 74025 | hbus monitor | Collected READ  addr=0x1121 data=0x00 |
| 74045 | hbus monitor | Collected WRITE addr=0x1122 data=0x00 |
| 74075 | hbus monitor | Collected READ  addr=0x1122 data=0x00 |
| 74095 | hbus monitor | Collected WRITE addr=0x1123 data=0x00 |
| 74125 | hbus monitor | Collected READ  addr=0x1123 data=0x00 |
| 74145 | hbus monitor | Collected WRITE addr=0x1124 data=0x00 |
| 74175 | hbus monitor | Collected READ  addr=0x1124 data=0x00 |
| 74195 | hbus monitor | Collected WRITE addr=0x1125 data=0x00 |
| 74225 | hbus monitor | Collected READ  addr=0x1125 data=0x00 |
| 74245 | hbus monitor | Collected WRITE addr=0x1126 data=0x00 |
| 74275 | hbus monitor | Collected READ  addr=0x1126 data=0x00 |
| 74295 | hbus monitor | Collected WRITE addr=0x1127 data=0x00 |
| 74325 | hbus monitor | Collected READ  addr=0x1127 data=0x00 |
| 74345 | hbus monitor | Collected WRITE addr=0x1128 data=0x00 |
| 74375 | hbus monitor | Collected READ  addr=0x1128 data=0x00 |
| 74395 | hbus monitor | Collected WRITE addr=0x1129 data=0x00 |
| 74425 | hbus monitor | Collected READ  addr=0x1129 data=0x00 |
| 74445 | hbus monitor | Collected WRITE addr=0x112a data=0x00 |
| 74475 | hbus monitor | Collected READ  addr=0x112a data=0x00 |
| 74495 | hbus monitor | Collected WRITE addr=0x112b data=0x00 |
| 74525 | hbus monitor | Collected READ  addr=0x112b data=0x00 |
| 74545 | hbus monitor | Collected WRITE addr=0x112c data=0x00 |
| 74575 | hbus monitor | Collected READ  addr=0x112c data=0x00 |
| 74595 | hbus monitor | Collected WRITE addr=0x112d data=0x00 |
| 74625 | hbus monitor | Collected READ  addr=0x112d data=0x00 |
| 74645 | hbus monitor | Collected WRITE addr=0x112e data=0x00 |
| 74675 | hbus monitor | Collected READ  addr=0x112e data=0x00 |
| 74695 | hbus monitor | Collected WRITE addr=0x112f data=0x00 |
| 74725 | hbus monitor | Collected READ  addr=0x112f data=0x00 |
| 74745 | hbus monitor | Collected WRITE addr=0x1130 data=0x00 |
| 74775 | hbus monitor | Collected READ  addr=0x1130 data=0x00 |
| 74795 | hbus monitor | Collected WRITE addr=0x1131 data=0x00 |
| 74825 | hbus monitor | Collected READ  addr=0x1131 data=0x00 |
| 74845 | hbus monitor | Collected WRITE addr=0x1132 data=0x00 |
| 74875 | hbus monitor | Collected READ  addr=0x1132 data=0x00 |
| 74895 | hbus monitor | Collected WRITE addr=0x1133 data=0x00 |
| 74925 | hbus monitor | Collected READ  addr=0x1133 data=0x00 |
| 74945 | hbus monitor | Collected WRITE addr=0x1134 data=0x00 |
| 74975 | hbus monitor | Collected READ  addr=0x1134 data=0x00 |
| 74995 | hbus monitor | Collected WRITE addr=0x1135 data=0x00 |
| 75025 | hbus monitor | Collected READ  addr=0x1135 data=0x00 |
| 75045 | hbus monitor | Collected WRITE addr=0x1136 data=0x00 |
| 75075 | hbus monitor | Collected READ  addr=0x1136 data=0x00 |
| 75095 | hbus monitor | Collected WRITE addr=0x1137 data=0x00 |
| 75125 | hbus monitor | Collected READ  addr=0x1137 data=0x00 |
| 75145 | hbus monitor | Collected WRITE addr=0x1138 data=0x00 |
| 75175 | hbus monitor | Collected READ  addr=0x1138 data=0x00 |
| 75195 | hbus monitor | Collected WRITE addr=0x1139 data=0x00 |
| 75225 | hbus monitor | Collected READ  addr=0x1139 data=0x00 |
| 75245 | hbus monitor | Collected WRITE addr=0x113a data=0x00 |
| 75275 | hbus monitor | Collected READ  addr=0x113a data=0x00 |
| 75295 | hbus monitor | Collected WRITE addr=0x113b data=0x00 |
| 75325 | hbus monitor | Collected READ  addr=0x113b data=0x00 |
| 75345 | hbus monitor | Collected WRITE addr=0x113c data=0x00 |
| 75375 | hbus monitor | Collected READ  addr=0x113c data=0x00 |
| 75395 | hbus monitor | Collected WRITE addr=0x113d data=0x00 |
| 75425 | hbus monitor | Collected READ  addr=0x113d data=0x00 |
| 75445 | hbus monitor | Collected WRITE addr=0x113e data=0x00 |
| 75475 | hbus monitor | Collected READ  addr=0x113e data=0x00 |
| 75495 | hbus monitor | Collected WRITE addr=0x113f data=0x00 |
| 75525 | hbus monitor | Collected READ  addr=0x113f data=0x00 |
| 75545 | hbus monitor | Collected WRITE addr=0x1140 data=0x00 |
| 75575 | hbus monitor | Collected READ  addr=0x1140 data=0x00 |
| 75595 | hbus monitor | Collected WRITE addr=0x1141 data=0x00 |
| 75625 | hbus monitor | Collected READ  addr=0x1141 data=0x00 |
| 75645 | hbus monitor | Collected WRITE addr=0x1142 data=0x00 |
| 75675 | hbus monitor | Collected READ  addr=0x1142 data=0x00 |
| 75695 | hbus monitor | Collected WRITE addr=0x1143 data=0x00 |
| 75725 | hbus monitor | Collected READ  addr=0x1143 data=0x00 |
| 75745 | hbus monitor | Collected WRITE addr=0x1144 data=0x00 |
| 75775 | hbus monitor | Collected READ  addr=0x1144 data=0x00 |
| 75795 | hbus monitor | Collected WRITE addr=0x1145 data=0x00 |
| 75825 | hbus monitor | Collected READ  addr=0x1145 data=0x00 |
| 75845 | hbus monitor | Collected WRITE addr=0x1146 data=0x00 |
| 75875 | hbus monitor | Collected READ  addr=0x1146 data=0x00 |
| 75895 | hbus monitor | Collected WRITE addr=0x1147 data=0x00 |
| 75925 | hbus monitor | Collected READ  addr=0x1147 data=0x00 |
| 75945 | hbus monitor | Collected WRITE addr=0x1148 data=0x00 |
| 75975 | hbus monitor | Collected READ  addr=0x1148 data=0x00 |
| 75995 | hbus monitor | Collected WRITE addr=0x1149 data=0x00 |
| 76025 | hbus monitor | Collected READ  addr=0x1149 data=0x00 |
| 76045 | hbus monitor | Collected WRITE addr=0x114a data=0x00 |
| 76075 | hbus monitor | Collected READ  addr=0x114a data=0x00 |
| 76095 | hbus monitor | Collected WRITE addr=0x114b data=0x00 |
| 76125 | hbus monitor | Collected READ  addr=0x114b data=0x00 |
| 76145 | hbus monitor | Collected WRITE addr=0x114c data=0x00 |
| 76175 | hbus monitor | Collected READ  addr=0x114c data=0x00 |
| 76195 | hbus monitor | Collected WRITE addr=0x114d data=0x00 |
| 76225 | hbus monitor | Collected READ  addr=0x114d data=0x00 |
| 76245 | hbus monitor | Collected WRITE addr=0x114e data=0x00 |
| 76275 | hbus monitor | Collected READ  addr=0x114e data=0x00 |
| 76295 | hbus monitor | Collected WRITE addr=0x114f data=0x00 |
| 76325 | hbus monitor | Collected READ  addr=0x114f data=0x00 |
| 76345 | hbus monitor | Collected WRITE addr=0x1150 data=0x00 |
| 76375 | hbus monitor | Collected READ  addr=0x1150 data=0x00 |
| 76395 | hbus monitor | Collected WRITE addr=0x1151 data=0x00 |
| 76425 | hbus monitor | Collected READ  addr=0x1151 data=0x00 |
| 76445 | hbus monitor | Collected WRITE addr=0x1152 data=0x00 |
| 76475 | hbus monitor | Collected READ  addr=0x1152 data=0x00 |
| 76495 | hbus monitor | Collected WRITE addr=0x1153 data=0x00 |
| 76525 | hbus monitor | Collected READ  addr=0x1153 data=0x00 |
| 76545 | hbus monitor | Collected WRITE addr=0x1154 data=0x00 |
| 76575 | hbus monitor | Collected READ  addr=0x1154 data=0x00 |
| 76595 | hbus monitor | Collected WRITE addr=0x1155 data=0x00 |
| 76625 | hbus monitor | Collected READ  addr=0x1155 data=0x00 |
| 76645 | hbus monitor | Collected WRITE addr=0x1156 data=0x00 |
| 76675 | hbus monitor | Collected READ  addr=0x1156 data=0x00 |
| 76695 | hbus monitor | Collected WRITE addr=0x1157 data=0x00 |
| 76725 | hbus monitor | Collected READ  addr=0x1157 data=0x00 |
| 76745 | hbus monitor | Collected WRITE addr=0x1158 data=0x00 |
| 76775 | hbus monitor | Collected READ  addr=0x1158 data=0x00 |
| 76795 | hbus monitor | Collected WRITE addr=0x1159 data=0x00 |
| 76825 | hbus monitor | Collected READ  addr=0x1159 data=0x00 |
| 76845 | hbus monitor | Collected WRITE addr=0x115a data=0x00 |
| 76875 | hbus monitor | Collected READ  addr=0x115a data=0x00 |
| 76895 | hbus monitor | Collected WRITE addr=0x115b data=0x00 |
| 76925 | hbus monitor | Collected READ  addr=0x115b data=0x00 |
| 76945 | hbus monitor | Collected WRITE addr=0x115c data=0x00 |
| 76975 | hbus monitor | Collected READ  addr=0x115c data=0x00 |
| 76995 | hbus monitor | Collected WRITE addr=0x115d data=0x00 |
| 77025 | hbus monitor | Collected READ  addr=0x115d data=0x00 |
| 77045 | hbus monitor | Collected WRITE addr=0x115e data=0x00 |
| 77075 | hbus monitor | Collected READ  addr=0x115e data=0x00 |
| 77095 | hbus monitor | Collected WRITE addr=0x115f data=0x00 |
| 77125 | hbus monitor | Collected READ  addr=0x115f data=0x00 |
| 77145 | hbus monitor | Collected WRITE addr=0x1160 data=0x00 |
| 77175 | hbus monitor | Collected READ  addr=0x1160 data=0x00 |
| 77195 | hbus monitor | Collected WRITE addr=0x1161 data=0x00 |
| 77225 | hbus monitor | Collected READ  addr=0x1161 data=0x00 |
| 77245 | hbus monitor | Collected WRITE addr=0x1162 data=0x00 |
| 77275 | hbus monitor | Collected READ  addr=0x1162 data=0x00 |
| 77295 | hbus monitor | Collected WRITE addr=0x1163 data=0x00 |
| 77325 | hbus monitor | Collected READ  addr=0x1163 data=0x00 |
| 77345 | hbus monitor | Collected WRITE addr=0x1164 data=0x00 |
| 77375 | hbus monitor | Collected READ  addr=0x1164 data=0x00 |
| 77395 | hbus monitor | Collected WRITE addr=0x1165 data=0x00 |
| 77425 | hbus monitor | Collected READ  addr=0x1165 data=0x00 |
| 77445 | hbus monitor | Collected WRITE addr=0x1166 data=0x00 |
| 77475 | hbus monitor | Collected READ  addr=0x1166 data=0x00 |
| 77495 | hbus monitor | Collected WRITE addr=0x1167 data=0x00 |
| 77525 | hbus monitor | Collected READ  addr=0x1167 data=0x00 |
| 77545 | hbus monitor | Collected WRITE addr=0x1168 data=0x00 |
| 77575 | hbus monitor | Collected READ  addr=0x1168 data=0x00 |
| 77595 | hbus monitor | Collected WRITE addr=0x1169 data=0x00 |
| 77625 | hbus monitor | Collected READ  addr=0x1169 data=0x00 |
| 77645 | hbus monitor | Collected WRITE addr=0x116a data=0x00 |
| 77675 | hbus monitor | Collected READ  addr=0x116a data=0x00 |
| 77695 | hbus monitor | Collected WRITE addr=0x116b data=0x00 |
| 77725 | hbus monitor | Collected READ  addr=0x116b data=0x00 |
| 77745 | hbus monitor | Collected WRITE addr=0x116c data=0x00 |
| 77775 | hbus monitor | Collected READ  addr=0x116c data=0x00 |
| 77795 | hbus monitor | Collected WRITE addr=0x116d data=0x00 |
| 77825 | hbus monitor | Collected READ  addr=0x116d data=0x00 |
| 77845 | hbus monitor | Collected WRITE addr=0x116e data=0x00 |
| 77875 | hbus monitor | Collected READ  addr=0x116e data=0x00 |
| 77895 | hbus monitor | Collected WRITE addr=0x116f data=0x00 |
| 77925 | hbus monitor | Collected READ  addr=0x116f data=0x00 |
| 77945 | hbus monitor | Collected WRITE addr=0x1170 data=0x00 |
| 77975 | hbus monitor | Collected READ  addr=0x1170 data=0x00 |
| 77995 | hbus monitor | Collected WRITE addr=0x1171 data=0x00 |
| 78025 | hbus monitor | Collected READ  addr=0x1171 data=0x00 |
| 78045 | hbus monitor | Collected WRITE addr=0x1172 data=0x00 |
| 78075 | hbus monitor | Collected READ  addr=0x1172 data=0x00 |
| 78095 | hbus monitor | Collected WRITE addr=0x1173 data=0x00 |
| 78125 | hbus monitor | Collected READ  addr=0x1173 data=0x00 |
| 78145 | hbus monitor | Collected WRITE addr=0x1174 data=0x00 |
| 78175 | hbus monitor | Collected READ  addr=0x1174 data=0x00 |
| 78195 | hbus monitor | Collected WRITE addr=0x1175 data=0x00 |
| 78225 | hbus monitor | Collected READ  addr=0x1175 data=0x00 |
| 78245 | hbus monitor | Collected WRITE addr=0x1176 data=0x00 |
| 78275 | hbus monitor | Collected READ  addr=0x1176 data=0x00 |
| 78295 | hbus monitor | Collected WRITE addr=0x1177 data=0x00 |
| 78325 | hbus monitor | Collected READ  addr=0x1177 data=0x00 |
| 78345 | hbus monitor | Collected WRITE addr=0x1178 data=0x00 |
| 78375 | hbus monitor | Collected READ  addr=0x1178 data=0x00 |
| 78395 | hbus monitor | Collected WRITE addr=0x1179 data=0x00 |
| 78425 | hbus monitor | Collected READ  addr=0x1179 data=0x00 |
| 78445 | hbus monitor | Collected WRITE addr=0x117a data=0x00 |
| 78475 | hbus monitor | Collected READ  addr=0x117a data=0x00 |
| 78495 | hbus monitor | Collected WRITE addr=0x117b data=0x00 |
| 78525 | hbus monitor | Collected READ  addr=0x117b data=0x00 |
| 78545 | hbus monitor | Collected WRITE addr=0x117c data=0x00 |
| 78575 | hbus monitor | Collected READ  addr=0x117c data=0x00 |
| 78595 | hbus monitor | Collected WRITE addr=0x117d data=0x00 |
| 78625 | hbus monitor | Collected READ  addr=0x117d data=0x00 |
| 78645 | hbus monitor | Collected WRITE addr=0x117e data=0x00 |
| 78675 | hbus monitor | Collected READ  addr=0x117e data=0x00 |
| 78695 | hbus monitor | Collected WRITE addr=0x117f data=0x00 |
| 78725 | hbus monitor | Collected READ  addr=0x117f data=0x00 |
| 78745 | hbus monitor | Collected WRITE addr=0x1180 data=0x00 |
| 78775 | hbus monitor | Collected READ  addr=0x1180 data=0x00 |
| 78795 | hbus monitor | Collected WRITE addr=0x1181 data=0x00 |
| 78825 | hbus monitor | Collected READ  addr=0x1181 data=0x00 |
| 78845 | hbus monitor | Collected WRITE addr=0x1182 data=0x00 |
| 78875 | hbus monitor | Collected READ  addr=0x1182 data=0x00 |
| 78895 | hbus monitor | Collected WRITE addr=0x1183 data=0x00 |
| 78925 | hbus monitor | Collected READ  addr=0x1183 data=0x00 |
| 78945 | hbus monitor | Collected WRITE addr=0x1184 data=0x00 |
| 78975 | hbus monitor | Collected READ  addr=0x1184 data=0x00 |
| 78995 | hbus monitor | Collected WRITE addr=0x1185 data=0x00 |
| 79025 | hbus monitor | Collected READ  addr=0x1185 data=0x00 |
| 79045 | hbus monitor | Collected WRITE addr=0x1186 data=0x00 |
| 79075 | hbus monitor | Collected READ  addr=0x1186 data=0x00 |
| 79095 | hbus monitor | Collected WRITE addr=0x1187 data=0x00 |
| 79125 | hbus monitor | Collected READ  addr=0x1187 data=0x00 |
| 79145 | hbus monitor | Collected WRITE addr=0x1188 data=0x00 |
| 79175 | hbus monitor | Collected READ  addr=0x1188 data=0x00 |
| 79195 | hbus monitor | Collected WRITE addr=0x1189 data=0x00 |
| 79225 | hbus monitor | Collected READ  addr=0x1189 data=0x00 |
| 79245 | hbus monitor | Collected WRITE addr=0x118a data=0x00 |
| 79275 | hbus monitor | Collected READ  addr=0x118a data=0x00 |
| 79295 | hbus monitor | Collected WRITE addr=0x118b data=0x00 |
| 79325 | hbus monitor | Collected READ  addr=0x118b data=0x00 |
| 79345 | hbus monitor | Collected WRITE addr=0x118c data=0x00 |
| 79375 | hbus monitor | Collected READ  addr=0x118c data=0x00 |
| 79395 | hbus monitor | Collected WRITE addr=0x118d data=0x00 |
| 79425 | hbus monitor | Collected READ  addr=0x118d data=0x00 |
| 79445 | hbus monitor | Collected WRITE addr=0x118e data=0x00 |
| 79475 | hbus monitor | Collected READ  addr=0x118e data=0x00 |
| 79495 | hbus monitor | Collected WRITE addr=0x118f data=0x00 |
| 79525 | hbus monitor | Collected READ  addr=0x118f data=0x00 |
| 79545 | hbus monitor | Collected WRITE addr=0x1190 data=0x00 |
| 79575 | hbus monitor | Collected READ  addr=0x1190 data=0x00 |
| 79595 | hbus monitor | Collected WRITE addr=0x1191 data=0x00 |
| 79625 | hbus monitor | Collected READ  addr=0x1191 data=0x00 |
| 79645 | hbus monitor | Collected WRITE addr=0x1192 data=0x00 |
| 79675 | hbus monitor | Collected READ  addr=0x1192 data=0x00 |
| 79695 | hbus monitor | Collected WRITE addr=0x1193 data=0x00 |
| 79725 | hbus monitor | Collected READ  addr=0x1193 data=0x00 |
| 79745 | hbus monitor | Collected WRITE addr=0x1194 data=0x00 |
| 79775 | hbus monitor | Collected READ  addr=0x1194 data=0x00 |
| 79795 | hbus monitor | Collected WRITE addr=0x1195 data=0x00 |
| 79825 | hbus monitor | Collected READ  addr=0x1195 data=0x00 |
| 79845 | hbus monitor | Collected WRITE addr=0x1196 data=0x00 |
| 79875 | hbus monitor | Collected READ  addr=0x1196 data=0x00 |
| 79895 | hbus monitor | Collected WRITE addr=0x1197 data=0x00 |
| 79925 | hbus monitor | Collected READ  addr=0x1197 data=0x00 |
| 79945 | hbus monitor | Collected WRITE addr=0x1198 data=0x00 |
| 79975 | hbus monitor | Collected READ  addr=0x1198 data=0x00 |
| 79995 | hbus monitor | Collected WRITE addr=0x1199 data=0x00 |
| 80025 | hbus monitor | Collected READ  addr=0x1199 data=0x00 |
| 80045 | hbus monitor | Collected WRITE addr=0x119a data=0x00 |
| 80075 | hbus monitor | Collected READ  addr=0x119a data=0x00 |
| 80095 | hbus monitor | Collected WRITE addr=0x119b data=0x00 |
| 80125 | hbus monitor | Collected READ  addr=0x119b data=0x00 |
| 80145 | hbus monitor | Collected WRITE addr=0x119c data=0x00 |
| 80175 | hbus monitor | Collected READ  addr=0x119c data=0x00 |
| 80195 | hbus monitor | Collected WRITE addr=0x119d data=0x00 |
| 80225 | hbus monitor | Collected READ  addr=0x119d data=0x00 |
| 80245 | hbus monitor | Collected WRITE addr=0x119e data=0x00 |
| 80275 | hbus monitor | Collected READ  addr=0x119e data=0x00 |
| 80295 | hbus monitor | Collected WRITE addr=0x119f data=0x00 |
| 80325 | hbus monitor | Collected READ  addr=0x119f data=0x00 |
| 80345 | hbus monitor | Collected WRITE addr=0x11a0 data=0x00 |
| 80375 | hbus monitor | Collected READ  addr=0x11a0 data=0x00 |
| 80395 | hbus monitor | Collected WRITE addr=0x11a1 data=0x00 |
| 80425 | hbus monitor | Collected READ  addr=0x11a1 data=0x00 |
| 80445 | hbus monitor | Collected WRITE addr=0x11a2 data=0x00 |
| 80475 | hbus monitor | Collected READ  addr=0x11a2 data=0x00 |
| 80495 | hbus monitor | Collected WRITE addr=0x11a3 data=0x00 |
| 80525 | hbus monitor | Collected READ  addr=0x11a3 data=0x00 |
| 80545 | hbus monitor | Collected WRITE addr=0x11a4 data=0x00 |
| 80575 | hbus monitor | Collected READ  addr=0x11a4 data=0x00 |
| 80595 | hbus monitor | Collected WRITE addr=0x11a5 data=0x00 |
| 80625 | hbus monitor | Collected READ  addr=0x11a5 data=0x00 |
| 80645 | hbus monitor | Collected WRITE addr=0x11a6 data=0x00 |
| 80675 | hbus monitor | Collected READ  addr=0x11a6 data=0x00 |
| 80695 | hbus monitor | Collected WRITE addr=0x11a7 data=0x00 |
| 80725 | hbus monitor | Collected READ  addr=0x11a7 data=0x00 |
| 80745 | hbus monitor | Collected WRITE addr=0x11a8 data=0x00 |
| 80775 | hbus monitor | Collected READ  addr=0x11a8 data=0x00 |
| 80795 | hbus monitor | Collected WRITE addr=0x11a9 data=0x00 |
| 80825 | hbus monitor | Collected READ  addr=0x11a9 data=0x00 |
| 80845 | hbus monitor | Collected WRITE addr=0x11aa data=0x00 |
| 80875 | hbus monitor | Collected READ  addr=0x11aa data=0x00 |
| 80895 | hbus monitor | Collected WRITE addr=0x11ab data=0x00 |
| 80925 | hbus monitor | Collected READ  addr=0x11ab data=0x00 |
| 80945 | hbus monitor | Collected WRITE addr=0x11ac data=0x00 |
| 80975 | hbus monitor | Collected READ  addr=0x11ac data=0x00 |
| 80995 | hbus monitor | Collected WRITE addr=0x11ad data=0x00 |
| 81025 | hbus monitor | Collected READ  addr=0x11ad data=0x00 |
| 81045 | hbus monitor | Collected WRITE addr=0x11ae data=0x00 |
| 81075 | hbus monitor | Collected READ  addr=0x11ae data=0x00 |
| 81095 | hbus monitor | Collected WRITE addr=0x11af data=0x00 |
| 81125 | hbus monitor | Collected READ  addr=0x11af data=0x00 |
| 81145 | hbus monitor | Collected WRITE addr=0x11b0 data=0x00 |
| 81175 | hbus monitor | Collected READ  addr=0x11b0 data=0x00 |
| 81195 | hbus monitor | Collected WRITE addr=0x11b1 data=0x00 |
| 81225 | hbus monitor | Collected READ  addr=0x11b1 data=0x00 |
| 81245 | hbus monitor | Collected WRITE addr=0x11b2 data=0x00 |
| 81275 | hbus monitor | Collected READ  addr=0x11b2 data=0x00 |
| 81295 | hbus monitor | Collected WRITE addr=0x11b3 data=0x00 |
| 81325 | hbus monitor | Collected READ  addr=0x11b3 data=0x00 |
| 81345 | hbus monitor | Collected WRITE addr=0x11b4 data=0x00 |
| 81375 | hbus monitor | Collected READ  addr=0x11b4 data=0x00 |
| 81395 | hbus monitor | Collected WRITE addr=0x11b5 data=0x00 |
| 81425 | hbus monitor | Collected READ  addr=0x11b5 data=0x00 |
| 81445 | hbus monitor | Collected WRITE addr=0x11b6 data=0x00 |
| 81475 | hbus monitor | Collected READ  addr=0x11b6 data=0x00 |
| 81495 | hbus monitor | Collected WRITE addr=0x11b7 data=0x00 |
| 81525 | hbus monitor | Collected READ  addr=0x11b7 data=0x00 |
| 81545 | hbus monitor | Collected WRITE addr=0x11b8 data=0x00 |
| 81575 | hbus monitor | Collected READ  addr=0x11b8 data=0x00 |
| 81595 | hbus monitor | Collected WRITE addr=0x11b9 data=0x00 |
| 81625 | hbus monitor | Collected READ  addr=0x11b9 data=0x00 |
| 81645 | hbus monitor | Collected WRITE addr=0x11ba data=0x00 |
| 81675 | hbus monitor | Collected READ  addr=0x11ba data=0x00 |
| 81695 | hbus monitor | Collected WRITE addr=0x11bb data=0x00 |
| 81725 | hbus monitor | Collected READ  addr=0x11bb data=0x00 |
| 81745 | hbus monitor | Collected WRITE addr=0x11bc data=0x00 |
| 81775 | hbus monitor | Collected READ  addr=0x11bc data=0x00 |
| 81795 | hbus monitor | Collected WRITE addr=0x11bd data=0x00 |
| 81825 | hbus monitor | Collected READ  addr=0x11bd data=0x00 |
| 81845 | hbus monitor | Collected WRITE addr=0x11be data=0x00 |
| 81875 | hbus monitor | Collected READ  addr=0x11be data=0x00 |
| 81895 | hbus monitor | Collected WRITE addr=0x11bf data=0x00 |
| 81925 | hbus monitor | Collected READ  addr=0x11bf data=0x00 |
| 81945 | hbus monitor | Collected WRITE addr=0x11c0 data=0x00 |
| 81975 | hbus monitor | Collected READ  addr=0x11c0 data=0x00 |
| 81995 | hbus monitor | Collected WRITE addr=0x11c1 data=0x00 |
| 82025 | hbus monitor | Collected READ  addr=0x11c1 data=0x00 |
| 82045 | hbus monitor | Collected WRITE addr=0x11c2 data=0x00 |
| 82075 | hbus monitor | Collected READ  addr=0x11c2 data=0x00 |
| 82095 | hbus monitor | Collected WRITE addr=0x11c3 data=0x00 |
| 82125 | hbus monitor | Collected READ  addr=0x11c3 data=0x00 |
| 82145 | hbus monitor | Collected WRITE addr=0x11c4 data=0x00 |
| 82175 | hbus monitor | Collected READ  addr=0x11c4 data=0x00 |
| 82195 | hbus monitor | Collected WRITE addr=0x11c5 data=0x00 |
| 82225 | hbus monitor | Collected READ  addr=0x11c5 data=0x00 |
| 82245 | hbus monitor | Collected WRITE addr=0x11c6 data=0x00 |
| 82275 | hbus monitor | Collected READ  addr=0x11c6 data=0x00 |
| 82295 | hbus monitor | Collected WRITE addr=0x11c7 data=0x00 |
| 82325 | hbus monitor | Collected READ  addr=0x11c7 data=0x00 |
| 82345 | hbus monitor | Collected WRITE addr=0x11c8 data=0x00 |
| 82375 | hbus monitor | Collected READ  addr=0x11c8 data=0x00 |
| 82395 | hbus monitor | Collected WRITE addr=0x11c9 data=0x00 |
| 82425 | hbus monitor | Collected READ  addr=0x11c9 data=0x00 |
| 82445 | hbus monitor | Collected WRITE addr=0x11ca data=0x00 |
| 82475 | hbus monitor | Collected READ  addr=0x11ca data=0x00 |
| 82495 | hbus monitor | Collected WRITE addr=0x11cb data=0x00 |
| 82525 | hbus monitor | Collected READ  addr=0x11cb data=0x00 |
| 82545 | hbus monitor | Collected WRITE addr=0x11cc data=0x00 |
| 82575 | hbus monitor | Collected READ  addr=0x11cc data=0x00 |
| 82595 | hbus monitor | Collected WRITE addr=0x11cd data=0x00 |
| 82625 | hbus monitor | Collected READ  addr=0x11cd data=0x00 |
| 82645 | hbus monitor | Collected WRITE addr=0x11ce data=0x00 |
| 82675 | hbus monitor | Collected READ  addr=0x11ce data=0x00 |
| 82695 | hbus monitor | Collected WRITE addr=0x11cf data=0x00 |
| 82725 | hbus monitor | Collected READ  addr=0x11cf data=0x00 |
| 82745 | hbus monitor | Collected WRITE addr=0x11d0 data=0x00 |
| 82775 | hbus monitor | Collected READ  addr=0x11d0 data=0x00 |
| 82795 | hbus monitor | Collected WRITE addr=0x11d1 data=0x00 |
| 82825 | hbus monitor | Collected READ  addr=0x11d1 data=0x00 |
| 82845 | hbus monitor | Collected WRITE addr=0x11d2 data=0x00 |
| 82875 | hbus monitor | Collected READ  addr=0x11d2 data=0x00 |
| 82895 | hbus monitor | Collected WRITE addr=0x11d3 data=0x00 |
| 82925 | hbus monitor | Collected READ  addr=0x11d3 data=0x00 |
| 82945 | hbus monitor | Collected WRITE addr=0x11d4 data=0x00 |
| 82975 | hbus monitor | Collected READ  addr=0x11d4 data=0x00 |
| 82995 | hbus monitor | Collected WRITE addr=0x11d5 data=0x00 |
| 83025 | hbus monitor | Collected READ  addr=0x11d5 data=0x00 |
| 83045 | hbus monitor | Collected WRITE addr=0x11d6 data=0x00 |
| 83075 | hbus monitor | Collected READ  addr=0x11d6 data=0x00 |
| 83095 | hbus monitor | Collected WRITE addr=0x11d7 data=0x00 |
| 83125 | hbus monitor | Collected READ  addr=0x11d7 data=0x00 |
| 83145 | hbus monitor | Collected WRITE addr=0x11d8 data=0x00 |
| 83175 | hbus monitor | Collected READ  addr=0x11d8 data=0x00 |
| 83195 | hbus monitor | Collected WRITE addr=0x11d9 data=0x00 |
| 83225 | hbus monitor | Collected READ  addr=0x11d9 data=0x00 |
| 83245 | hbus monitor | Collected WRITE addr=0x11da data=0x00 |
| 83275 | hbus monitor | Collected READ  addr=0x11da data=0x00 |
| 83295 | hbus monitor | Collected WRITE addr=0x11db data=0x00 |
| 83325 | hbus monitor | Collected READ  addr=0x11db data=0x00 |
| 83345 | hbus monitor | Collected WRITE addr=0x11dc data=0x00 |
| 83375 | hbus monitor | Collected READ  addr=0x11dc data=0x00 |
| 83395 | hbus monitor | Collected WRITE addr=0x11dd data=0x00 |
| 83425 | hbus monitor | Collected READ  addr=0x11dd data=0x00 |
| 83445 | hbus monitor | Collected WRITE addr=0x11de data=0x00 |
| 83475 | hbus monitor | Collected READ  addr=0x11de data=0x00 |
| 83495 | hbus monitor | Collected WRITE addr=0x11df data=0x00 |
| 83525 | hbus monitor | Collected READ  addr=0x11df data=0x00 |
| 83545 | hbus monitor | Collected WRITE addr=0x11e0 data=0x00 |
| 83575 | hbus monitor | Collected READ  addr=0x11e0 data=0x00 |
| 83595 | hbus monitor | Collected WRITE addr=0x11e1 data=0x00 |
| 83625 | hbus monitor | Collected READ  addr=0x11e1 data=0x00 |
| 83645 | hbus monitor | Collected WRITE addr=0x11e2 data=0x00 |
| 83675 | hbus monitor | Collected READ  addr=0x11e2 data=0x00 |
| 83695 | hbus monitor | Collected WRITE addr=0x11e3 data=0x00 |
| 83725 | hbus monitor | Collected READ  addr=0x11e3 data=0x00 |
| 83745 | hbus monitor | Collected WRITE addr=0x11e4 data=0x00 |
| 83775 | hbus monitor | Collected READ  addr=0x11e4 data=0x00 |
| 83795 | hbus monitor | Collected WRITE addr=0x11e5 data=0x00 |
| 83825 | hbus monitor | Collected READ  addr=0x11e5 data=0x00 |
| 83845 | hbus monitor | Collected WRITE addr=0x11e6 data=0x00 |
| 83875 | hbus monitor | Collected READ  addr=0x11e6 data=0x00 |
| 83895 | hbus monitor | Collected WRITE addr=0x11e7 data=0x00 |
| 83925 | hbus monitor | Collected READ  addr=0x11e7 data=0x00 |
| 83945 | hbus monitor | Collected WRITE addr=0x11e8 data=0x00 |
| 83975 | hbus monitor | Collected READ  addr=0x11e8 data=0x00 |
| 83995 | hbus monitor | Collected WRITE addr=0x11e9 data=0x00 |
| 84025 | hbus monitor | Collected READ  addr=0x11e9 data=0x00 |
| 84045 | hbus monitor | Collected WRITE addr=0x11ea data=0x00 |
| 84075 | hbus monitor | Collected READ  addr=0x11ea data=0x00 |
| 84095 | hbus monitor | Collected WRITE addr=0x11eb data=0x00 |
| 84125 | hbus monitor | Collected READ  addr=0x11eb data=0x00 |
| 84145 | hbus monitor | Collected WRITE addr=0x11ec data=0x00 |
| 84175 | hbus monitor | Collected READ  addr=0x11ec data=0x00 |
| 84195 | hbus monitor | Collected WRITE addr=0x11ed data=0x00 |
| 84225 | hbus monitor | Collected READ  addr=0x11ed data=0x00 |
| 84245 | hbus monitor | Collected WRITE addr=0x11ee data=0x00 |
| 84275 | hbus monitor | Collected READ  addr=0x11ee data=0x00 |
| 84295 | hbus monitor | Collected WRITE addr=0x11ef data=0x00 |
| 84325 | hbus monitor | Collected READ  addr=0x11ef data=0x00 |
| 84345 | hbus monitor | Collected WRITE addr=0x11f0 data=0x00 |
| 84375 | hbus monitor | Collected READ  addr=0x11f0 data=0x00 |
| 84395 | hbus monitor | Collected WRITE addr=0x11f1 data=0x00 |
| 84425 | hbus monitor | Collected READ  addr=0x11f1 data=0x00 |
| 84445 | hbus monitor | Collected WRITE addr=0x11f2 data=0x00 |
| 84475 | hbus monitor | Collected READ  addr=0x11f2 data=0x00 |
| 84495 | hbus monitor | Collected WRITE addr=0x11f3 data=0x00 |
| 84525 | hbus monitor | Collected READ  addr=0x11f3 data=0x00 |
| 84545 | hbus monitor | Collected WRITE addr=0x11f4 data=0x00 |
| 84575 | hbus monitor | Collected READ  addr=0x11f4 data=0x00 |
| 84595 | hbus monitor | Collected WRITE addr=0x11f5 data=0x00 |
| 84625 | hbus monitor | Collected READ  addr=0x11f5 data=0x00 |
| 84645 | hbus monitor | Collected WRITE addr=0x11f6 data=0x00 |
| 84675 | hbus monitor | Collected READ  addr=0x11f6 data=0x00 |
| 84695 | hbus monitor | Collected WRITE addr=0x11f7 data=0x00 |
| 84725 | hbus monitor | Collected READ  addr=0x11f7 data=0x00 |
| 84745 | hbus monitor | Collected WRITE addr=0x11f8 data=0x00 |
| 84775 | hbus monitor | Collected READ  addr=0x11f8 data=0x00 |
| 84795 | hbus monitor | Collected WRITE addr=0x11f9 data=0x00 |
| 84825 | hbus monitor | Collected READ  addr=0x11f9 data=0x00 |
| 84845 | hbus monitor | Collected WRITE addr=0x11fa data=0x00 |
| 84875 | hbus monitor | Collected READ  addr=0x11fa data=0x00 |
| 84895 | hbus monitor | Collected WRITE addr=0x11fb data=0x00 |
| 84925 | hbus monitor | Collected READ  addr=0x11fb data=0x00 |
| 84945 | hbus monitor | Collected WRITE addr=0x11fc data=0x00 |
| 84975 | hbus monitor | Collected READ  addr=0x11fc data=0x00 |
| 84995 | hbus monitor | Collected WRITE addr=0x11fd data=0x00 |
| 85025 | hbus monitor | Collected READ  addr=0x11fd data=0x00 |
| 85045 | hbus monitor | Collected WRITE addr=0x11fe data=0x00 |
| 85075 | hbus monitor | Collected READ  addr=0x11fe data=0x00 |
| 85095 | hbus monitor | Collected WRITE addr=0x11ff data=0x00 |
| 85125 | hbus monitor | Collected READ  addr=0x11ff data=0x00 |
| 85145 | hbus monitor | Collected WRITE addr=0x1100 data=0xff |
| 85175 | hbus monitor | Collected READ  addr=0x1100 data=0xff |
| 85195 | hbus monitor | Collected WRITE addr=0x1101 data=0xff |
| 85225 | hbus monitor | Collected READ  addr=0x1101 data=0xff |
| 85245 | hbus monitor | Collected WRITE addr=0x1102 data=0xff |
| 85275 | hbus monitor | Collected READ  addr=0x1102 data=0xff |
| 85295 | hbus monitor | Collected WRITE addr=0x1103 data=0xff |
| 85325 | hbus monitor | Collected READ  addr=0x1103 data=0xff |
| 85345 | hbus monitor | Collected WRITE addr=0x1104 data=0xff |
| 85375 | hbus monitor | Collected READ  addr=0x1104 data=0xff |
| 85395 | hbus monitor | Collected WRITE addr=0x1105 data=0xff |
| 85425 | hbus monitor | Collected READ  addr=0x1105 data=0xff |
| 85445 | hbus monitor | Collected WRITE addr=0x1106 data=0xff |
| 85475 | hbus monitor | Collected READ  addr=0x1106 data=0xff |
| 85495 | hbus monitor | Collected WRITE addr=0x1107 data=0xff |
| 85525 | hbus monitor | Collected READ  addr=0x1107 data=0xff |
| 85545 | hbus monitor | Collected WRITE addr=0x1108 data=0xff |
| 85575 | hbus monitor | Collected READ  addr=0x1108 data=0xff |
| 85595 | hbus monitor | Collected WRITE addr=0x1109 data=0xff |
| 85625 | hbus monitor | Collected READ  addr=0x1109 data=0xff |
| 85645 | hbus monitor | Collected WRITE addr=0x110a data=0xff |
| 85675 | hbus monitor | Collected READ  addr=0x110a data=0xff |
| 85695 | hbus monitor | Collected WRITE addr=0x110b data=0xff |
| 85725 | hbus monitor | Collected READ  addr=0x110b data=0xff |
| 85745 | hbus monitor | Collected WRITE addr=0x110c data=0xff |
| 85775 | hbus monitor | Collected READ  addr=0x110c data=0xff |
| 85795 | hbus monitor | Collected WRITE addr=0x110d data=0xff |
| 85825 | hbus monitor | Collected READ  addr=0x110d data=0xff |
| 85845 | hbus monitor | Collected WRITE addr=0x110e data=0xff |
| 85875 | hbus monitor | Collected READ  addr=0x110e data=0xff |
| 85895 | hbus monitor | Collected WRITE addr=0x110f data=0xff |
| 85925 | hbus monitor | Collected READ  addr=0x110f data=0xff |
| 85945 | hbus monitor | Collected WRITE addr=0x1110 data=0xff |
| 85975 | hbus monitor | Collected READ  addr=0x1110 data=0xff |
| 85995 | hbus monitor | Collected WRITE addr=0x1111 data=0xff |
| 86025 | hbus monitor | Collected READ  addr=0x1111 data=0xff |
| 86045 | hbus monitor | Collected WRITE addr=0x1112 data=0xff |
| 86075 | hbus monitor | Collected READ  addr=0x1112 data=0xff |
| 86095 | hbus monitor | Collected WRITE addr=0x1113 data=0xff |
| 86125 | hbus monitor | Collected READ  addr=0x1113 data=0xff |
| 86145 | hbus monitor | Collected WRITE addr=0x1114 data=0xff |
| 86175 | hbus monitor | Collected READ  addr=0x1114 data=0xff |
| 86195 | hbus monitor | Collected WRITE addr=0x1115 data=0xff |
| 86225 | hbus monitor | Collected READ  addr=0x1115 data=0xff |
| 86245 | hbus monitor | Collected WRITE addr=0x1116 data=0xff |
| 86275 | hbus monitor | Collected READ  addr=0x1116 data=0xff |
| 86295 | hbus monitor | Collected WRITE addr=0x1117 data=0xff |
| 86325 | hbus monitor | Collected READ  addr=0x1117 data=0xff |
| 86345 | hbus monitor | Collected WRITE addr=0x1118 data=0xff |
| 86375 | hbus monitor | Collected READ  addr=0x1118 data=0xff |
| 86395 | hbus monitor | Collected WRITE addr=0x1119 data=0xff |
| 86425 | hbus monitor | Collected READ  addr=0x1119 data=0xff |
| 86445 | hbus monitor | Collected WRITE addr=0x111a data=0xff |
| 86475 | hbus monitor | Collected READ  addr=0x111a data=0xff |
| 86495 | hbus monitor | Collected WRITE addr=0x111b data=0xff |
| 86525 | hbus monitor | Collected READ  addr=0x111b data=0xff |
| 86545 | hbus monitor | Collected WRITE addr=0x111c data=0xff |
| 86575 | hbus monitor | Collected READ  addr=0x111c data=0xff |
| 86595 | hbus monitor | Collected WRITE addr=0x111d data=0xff |
| 86625 | hbus monitor | Collected READ  addr=0x111d data=0xff |
| 86645 | hbus monitor | Collected WRITE addr=0x111e data=0xff |
| 86675 | hbus monitor | Collected READ  addr=0x111e data=0xff |
| 86695 | hbus monitor | Collected WRITE addr=0x111f data=0xff |
| 86725 | hbus monitor | Collected READ  addr=0x111f data=0xff |
| 86745 | hbus monitor | Collected WRITE addr=0x1120 data=0xff |
| 86775 | hbus monitor | Collected READ  addr=0x1120 data=0xff |
| 86795 | hbus monitor | Collected WRITE addr=0x1121 data=0xff |
| 86825 | hbus monitor | Collected READ  addr=0x1121 data=0xff |
| 86845 | hbus monitor | Collected WRITE addr=0x1122 data=0xff |
| 86875 | hbus monitor | Collected READ  addr=0x1122 data=0xff |
| 86895 | hbus monitor | Collected WRITE addr=0x1123 data=0xff |
| 86925 | hbus monitor | Collected READ  addr=0x1123 data=0xff |
| 86945 | hbus monitor | Collected WRITE addr=0x1124 data=0xff |
| 86975 | hbus monitor | Collected READ  addr=0x1124 data=0xff |
| 86995 | hbus monitor | Collected WRITE addr=0x1125 data=0xff |
| 87025 | hbus monitor | Collected READ  addr=0x1125 data=0xff |
| 87045 | hbus monitor | Collected WRITE addr=0x1126 data=0xff |
| 87075 | hbus monitor | Collected READ  addr=0x1126 data=0xff |
| 87095 | hbus monitor | Collected WRITE addr=0x1127 data=0xff |
| 87125 | hbus monitor | Collected READ  addr=0x1127 data=0xff |
| 87145 | hbus monitor | Collected WRITE addr=0x1128 data=0xff |
| 87175 | hbus monitor | Collected READ  addr=0x1128 data=0xff |
| 87195 | hbus monitor | Collected WRITE addr=0x1129 data=0xff |
| 87225 | hbus monitor | Collected READ  addr=0x1129 data=0xff |
| 87245 | hbus monitor | Collected WRITE addr=0x112a data=0xff |
| 87275 | hbus monitor | Collected READ  addr=0x112a data=0xff |
| 87295 | hbus monitor | Collected WRITE addr=0x112b data=0xff |
| 87325 | hbus monitor | Collected READ  addr=0x112b data=0xff |
| 87345 | hbus monitor | Collected WRITE addr=0x112c data=0xff |
| 87375 | hbus monitor | Collected READ  addr=0x112c data=0xff |
| 87395 | hbus monitor | Collected WRITE addr=0x112d data=0xff |
| 87425 | hbus monitor | Collected READ  addr=0x112d data=0xff |
| 87445 | hbus monitor | Collected WRITE addr=0x112e data=0xff |
| 87475 | hbus monitor | Collected READ  addr=0x112e data=0xff |
| 87495 | hbus monitor | Collected WRITE addr=0x112f data=0xff |
| 87525 | hbus monitor | Collected READ  addr=0x112f data=0xff |
| 87545 | hbus monitor | Collected WRITE addr=0x1130 data=0xff |
| 87575 | hbus monitor | Collected READ  addr=0x1130 data=0xff |
| 87595 | hbus monitor | Collected WRITE addr=0x1131 data=0xff |
| 87625 | hbus monitor | Collected READ  addr=0x1131 data=0xff |
| 87645 | hbus monitor | Collected WRITE addr=0x1132 data=0xff |
| 87675 | hbus monitor | Collected READ  addr=0x1132 data=0xff |
| 87695 | hbus monitor | Collected WRITE addr=0x1133 data=0xff |
| 87725 | hbus monitor | Collected READ  addr=0x1133 data=0xff |
| 87745 | hbus monitor | Collected WRITE addr=0x1134 data=0xff |
| 87775 | hbus monitor | Collected READ  addr=0x1134 data=0xff |
| 87795 | hbus monitor | Collected WRITE addr=0x1135 data=0xff |
| 87825 | hbus monitor | Collected READ  addr=0x1135 data=0xff |
| 87845 | hbus monitor | Collected WRITE addr=0x1136 data=0xff |
| 87875 | hbus monitor | Collected READ  addr=0x1136 data=0xff |
| 87895 | hbus monitor | Collected WRITE addr=0x1137 data=0xff |
| 87925 | hbus monitor | Collected READ  addr=0x1137 data=0xff |
| 87945 | hbus monitor | Collected WRITE addr=0x1138 data=0xff |
| 87975 | hbus monitor | Collected READ  addr=0x1138 data=0xff |
| 87995 | hbus monitor | Collected WRITE addr=0x1139 data=0xff |
| 88025 | hbus monitor | Collected READ  addr=0x1139 data=0xff |
| 88045 | hbus monitor | Collected WRITE addr=0x113a data=0xff |
| 88075 | hbus monitor | Collected READ  addr=0x113a data=0xff |
| 88095 | hbus monitor | Collected WRITE addr=0x113b data=0xff |
| 88125 | hbus monitor | Collected READ  addr=0x113b data=0xff |
| 88145 | hbus monitor | Collected WRITE addr=0x113c data=0xff |
| 88175 | hbus monitor | Collected READ  addr=0x113c data=0xff |
| 88195 | hbus monitor | Collected WRITE addr=0x113d data=0xff |
| 88225 | hbus monitor | Collected READ  addr=0x113d data=0xff |
| 88245 | hbus monitor | Collected WRITE addr=0x113e data=0xff |
| 88275 | hbus monitor | Collected READ  addr=0x113e data=0xff |
| 88295 | hbus monitor | Collected WRITE addr=0x113f data=0xff |
| 88325 | hbus monitor | Collected READ  addr=0x113f data=0xff |
| 88345 | hbus monitor | Collected WRITE addr=0x1140 data=0xff |
| 88375 | hbus monitor | Collected READ  addr=0x1140 data=0xff |
| 88395 | hbus monitor | Collected WRITE addr=0x1141 data=0xff |
| 88425 | hbus monitor | Collected READ  addr=0x1141 data=0xff |
| 88445 | hbus monitor | Collected WRITE addr=0x1142 data=0xff |
| 88475 | hbus monitor | Collected READ  addr=0x1142 data=0xff |
| 88495 | hbus monitor | Collected WRITE addr=0x1143 data=0xff |
| 88525 | hbus monitor | Collected READ  addr=0x1143 data=0xff |
| 88545 | hbus monitor | Collected WRITE addr=0x1144 data=0xff |
| 88575 | hbus monitor | Collected READ  addr=0x1144 data=0xff |
| 88595 | hbus monitor | Collected WRITE addr=0x1145 data=0xff |
| 88625 | hbus monitor | Collected READ  addr=0x1145 data=0xff |
| 88645 | hbus monitor | Collected WRITE addr=0x1146 data=0xff |
| 88675 | hbus monitor | Collected READ  addr=0x1146 data=0xff |
| 88695 | hbus monitor | Collected WRITE addr=0x1147 data=0xff |
| 88725 | hbus monitor | Collected READ  addr=0x1147 data=0xff |
| 88745 | hbus monitor | Collected WRITE addr=0x1148 data=0xff |
| 88775 | hbus monitor | Collected READ  addr=0x1148 data=0xff |
| 88795 | hbus monitor | Collected WRITE addr=0x1149 data=0xff |
| 88825 | hbus monitor | Collected READ  addr=0x1149 data=0xff |
| 88845 | hbus monitor | Collected WRITE addr=0x114a data=0xff |
| 88875 | hbus monitor | Collected READ  addr=0x114a data=0xff |
| 88895 | hbus monitor | Collected WRITE addr=0x114b data=0xff |
| 88925 | hbus monitor | Collected READ  addr=0x114b data=0xff |
| 88945 | hbus monitor | Collected WRITE addr=0x114c data=0xff |
| 88975 | hbus monitor | Collected READ  addr=0x114c data=0xff |
| 88995 | hbus monitor | Collected WRITE addr=0x114d data=0xff |
| 89025 | hbus monitor | Collected READ  addr=0x114d data=0xff |
| 89045 | hbus monitor | Collected WRITE addr=0x114e data=0xff |
| 89075 | hbus monitor | Collected READ  addr=0x114e data=0xff |
| 89095 | hbus monitor | Collected WRITE addr=0x114f data=0xff |
| 89125 | hbus monitor | Collected READ  addr=0x114f data=0xff |
| 89145 | hbus monitor | Collected WRITE addr=0x1150 data=0xff |
| 89175 | hbus monitor | Collected READ  addr=0x1150 data=0xff |
| 89195 | hbus monitor | Collected WRITE addr=0x1151 data=0xff |
| 89225 | hbus monitor | Collected READ  addr=0x1151 data=0xff |
| 89245 | hbus monitor | Collected WRITE addr=0x1152 data=0xff |
| 89275 | hbus monitor | Collected READ  addr=0x1152 data=0xff |
| 89295 | hbus monitor | Collected WRITE addr=0x1153 data=0xff |
| 89325 | hbus monitor | Collected READ  addr=0x1153 data=0xff |
| 89345 | hbus monitor | Collected WRITE addr=0x1154 data=0xff |
| 89375 | hbus monitor | Collected READ  addr=0x1154 data=0xff |
| 89395 | hbus monitor | Collected WRITE addr=0x1155 data=0xff |
| 89425 | hbus monitor | Collected READ  addr=0x1155 data=0xff |
| 89445 | hbus monitor | Collected WRITE addr=0x1156 data=0xff |
| 89475 | hbus monitor | Collected READ  addr=0x1156 data=0xff |
| 89495 | hbus monitor | Collected WRITE addr=0x1157 data=0xff |
| 89525 | hbus monitor | Collected READ  addr=0x1157 data=0xff |
| 89545 | hbus monitor | Collected WRITE addr=0x1158 data=0xff |
| 89575 | hbus monitor | Collected READ  addr=0x1158 data=0xff |
| 89595 | hbus monitor | Collected WRITE addr=0x1159 data=0xff |
| 89625 | hbus monitor | Collected READ  addr=0x1159 data=0xff |
| 89645 | hbus monitor | Collected WRITE addr=0x115a data=0xff |
| 89675 | hbus monitor | Collected READ  addr=0x115a data=0xff |
| 89695 | hbus monitor | Collected WRITE addr=0x115b data=0xff |
| 89725 | hbus monitor | Collected READ  addr=0x115b data=0xff |
| 89745 | hbus monitor | Collected WRITE addr=0x115c data=0xff |
| 89775 | hbus monitor | Collected READ  addr=0x115c data=0xff |
| 89795 | hbus monitor | Collected WRITE addr=0x115d data=0xff |
| 89825 | hbus monitor | Collected READ  addr=0x115d data=0xff |
| 89845 | hbus monitor | Collected WRITE addr=0x115e data=0xff |
| 89875 | hbus monitor | Collected READ  addr=0x115e data=0xff |
| 89895 | hbus monitor | Collected WRITE addr=0x115f data=0xff |
| 89925 | hbus monitor | Collected READ  addr=0x115f data=0xff |
| 89945 | hbus monitor | Collected WRITE addr=0x1160 data=0xff |
| 89975 | hbus monitor | Collected READ  addr=0x1160 data=0xff |
| 89995 | hbus monitor | Collected WRITE addr=0x1161 data=0xff |
| 90025 | hbus monitor | Collected READ  addr=0x1161 data=0xff |
| 90045 | hbus monitor | Collected WRITE addr=0x1162 data=0xff |
| 90075 | hbus monitor | Collected READ  addr=0x1162 data=0xff |
| 90095 | hbus monitor | Collected WRITE addr=0x1163 data=0xff |
| 90125 | hbus monitor | Collected READ  addr=0x1163 data=0xff |
| 90145 | hbus monitor | Collected WRITE addr=0x1164 data=0xff |
| 90175 | hbus monitor | Collected READ  addr=0x1164 data=0xff |
| 90195 | hbus monitor | Collected WRITE addr=0x1165 data=0xff |
| 90225 | hbus monitor | Collected READ  addr=0x1165 data=0xff |
| 90245 | hbus monitor | Collected WRITE addr=0x1166 data=0xff |
| 90275 | hbus monitor | Collected READ  addr=0x1166 data=0xff |
| 90295 | hbus monitor | Collected WRITE addr=0x1167 data=0xff |
| 90325 | hbus monitor | Collected READ  addr=0x1167 data=0xff |
| 90345 | hbus monitor | Collected WRITE addr=0x1168 data=0xff |
| 90375 | hbus monitor | Collected READ  addr=0x1168 data=0xff |
| 90395 | hbus monitor | Collected WRITE addr=0x1169 data=0xff |
| 90425 | hbus monitor | Collected READ  addr=0x1169 data=0xff |
| 90445 | hbus monitor | Collected WRITE addr=0x116a data=0xff |
| 90475 | hbus monitor | Collected READ  addr=0x116a data=0xff |
| 90495 | hbus monitor | Collected WRITE addr=0x116b data=0xff |
| 90525 | hbus monitor | Collected READ  addr=0x116b data=0xff |
| 90545 | hbus monitor | Collected WRITE addr=0x116c data=0xff |
| 90575 | hbus monitor | Collected READ  addr=0x116c data=0xff |
| 90595 | hbus monitor | Collected WRITE addr=0x116d data=0xff |
| 90625 | hbus monitor | Collected READ  addr=0x116d data=0xff |
| 90645 | hbus monitor | Collected WRITE addr=0x116e data=0xff |
| 90675 | hbus monitor | Collected READ  addr=0x116e data=0xff |
| 90695 | hbus monitor | Collected WRITE addr=0x116f data=0xff |
| 90725 | hbus monitor | Collected READ  addr=0x116f data=0xff |
| 90745 | hbus monitor | Collected WRITE addr=0x1170 data=0xff |
| 90775 | hbus monitor | Collected READ  addr=0x1170 data=0xff |
| 90795 | hbus monitor | Collected WRITE addr=0x1171 data=0xff |
| 90825 | hbus monitor | Collected READ  addr=0x1171 data=0xff |
| 90845 | hbus monitor | Collected WRITE addr=0x1172 data=0xff |
| 90875 | hbus monitor | Collected READ  addr=0x1172 data=0xff |
| 90895 | hbus monitor | Collected WRITE addr=0x1173 data=0xff |
| 90925 | hbus monitor | Collected READ  addr=0x1173 data=0xff |
| 90945 | hbus monitor | Collected WRITE addr=0x1174 data=0xff |
| 90975 | hbus monitor | Collected READ  addr=0x1174 data=0xff |
| 90995 | hbus monitor | Collected WRITE addr=0x1175 data=0xff |
| 91025 | hbus monitor | Collected READ  addr=0x1175 data=0xff |
| 91045 | hbus monitor | Collected WRITE addr=0x1176 data=0xff |
| 91075 | hbus monitor | Collected READ  addr=0x1176 data=0xff |
| 91095 | hbus monitor | Collected WRITE addr=0x1177 data=0xff |
| 91125 | hbus monitor | Collected READ  addr=0x1177 data=0xff |
| 91145 | hbus monitor | Collected WRITE addr=0x1178 data=0xff |
| 91175 | hbus monitor | Collected READ  addr=0x1178 data=0xff |
| 91195 | hbus monitor | Collected WRITE addr=0x1179 data=0xff |
| 91225 | hbus monitor | Collected READ  addr=0x1179 data=0xff |
| 91245 | hbus monitor | Collected WRITE addr=0x117a data=0xff |
| 91275 | hbus monitor | Collected READ  addr=0x117a data=0xff |
| 91295 | hbus monitor | Collected WRITE addr=0x117b data=0xff |
| 91325 | hbus monitor | Collected READ  addr=0x117b data=0xff |
| 91345 | hbus monitor | Collected WRITE addr=0x117c data=0xff |
| 91375 | hbus monitor | Collected READ  addr=0x117c data=0xff |
| 91395 | hbus monitor | Collected WRITE addr=0x117d data=0xff |
| 91425 | hbus monitor | Collected READ  addr=0x117d data=0xff |
| 91445 | hbus monitor | Collected WRITE addr=0x117e data=0xff |
| 91475 | hbus monitor | Collected READ  addr=0x117e data=0xff |
| 91495 | hbus monitor | Collected WRITE addr=0x117f data=0xff |
| 91525 | hbus monitor | Collected READ  addr=0x117f data=0xff |
| 91545 | hbus monitor | Collected WRITE addr=0x1180 data=0xff |
| 91575 | hbus monitor | Collected READ  addr=0x1180 data=0xff |
| 91595 | hbus monitor | Collected WRITE addr=0x1181 data=0xff |
| 91625 | hbus monitor | Collected READ  addr=0x1181 data=0xff |
| 91645 | hbus monitor | Collected WRITE addr=0x1182 data=0xff |
| 91675 | hbus monitor | Collected READ  addr=0x1182 data=0xff |
| 91695 | hbus monitor | Collected WRITE addr=0x1183 data=0xff |
| 91725 | hbus monitor | Collected READ  addr=0x1183 data=0xff |
| 91745 | hbus monitor | Collected WRITE addr=0x1184 data=0xff |
| 91775 | hbus monitor | Collected READ  addr=0x1184 data=0xff |
| 91795 | hbus monitor | Collected WRITE addr=0x1185 data=0xff |
| 91825 | hbus monitor | Collected READ  addr=0x1185 data=0xff |
| 91845 | hbus monitor | Collected WRITE addr=0x1186 data=0xff |
| 91875 | hbus monitor | Collected READ  addr=0x1186 data=0xff |
| 91895 | hbus monitor | Collected WRITE addr=0x1187 data=0xff |
| 91925 | hbus monitor | Collected READ  addr=0x1187 data=0xff |
| 91945 | hbus monitor | Collected WRITE addr=0x1188 data=0xff |
| 91975 | hbus monitor | Collected READ  addr=0x1188 data=0xff |
| 91995 | hbus monitor | Collected WRITE addr=0x1189 data=0xff |
| 92025 | hbus monitor | Collected READ  addr=0x1189 data=0xff |
| 92045 | hbus monitor | Collected WRITE addr=0x118a data=0xff |
| 92075 | hbus monitor | Collected READ  addr=0x118a data=0xff |
| 92095 | hbus monitor | Collected WRITE addr=0x118b data=0xff |
| 92125 | hbus monitor | Collected READ  addr=0x118b data=0xff |
| 92145 | hbus monitor | Collected WRITE addr=0x118c data=0xff |
| 92175 | hbus monitor | Collected READ  addr=0x118c data=0xff |
| 92195 | hbus monitor | Collected WRITE addr=0x118d data=0xff |
| 92225 | hbus monitor | Collected READ  addr=0x118d data=0xff |
| 92245 | hbus monitor | Collected WRITE addr=0x118e data=0xff |
| 92275 | hbus monitor | Collected READ  addr=0x118e data=0xff |
| 92295 | hbus monitor | Collected WRITE addr=0x118f data=0xff |
| 92325 | hbus monitor | Collected READ  addr=0x118f data=0xff |
| 92345 | hbus monitor | Collected WRITE addr=0x1190 data=0xff |
| 92375 | hbus monitor | Collected READ  addr=0x1190 data=0xff |
| 92395 | hbus monitor | Collected WRITE addr=0x1191 data=0xff |
| 92425 | hbus monitor | Collected READ  addr=0x1191 data=0xff |
| 92445 | hbus monitor | Collected WRITE addr=0x1192 data=0xff |
| 92475 | hbus monitor | Collected READ  addr=0x1192 data=0xff |
| 92495 | hbus monitor | Collected WRITE addr=0x1193 data=0xff |
| 92525 | hbus monitor | Collected READ  addr=0x1193 data=0xff |
| 92545 | hbus monitor | Collected WRITE addr=0x1194 data=0xff |
| 92575 | hbus monitor | Collected READ  addr=0x1194 data=0xff |
| 92595 | hbus monitor | Collected WRITE addr=0x1195 data=0xff |
| 92625 | hbus monitor | Collected READ  addr=0x1195 data=0xff |
| 92645 | hbus monitor | Collected WRITE addr=0x1196 data=0xff |
| 92675 | hbus monitor | Collected READ  addr=0x1196 data=0xff |
| 92695 | hbus monitor | Collected WRITE addr=0x1197 data=0xff |
| 92725 | hbus monitor | Collected READ  addr=0x1197 data=0xff |
| 92745 | hbus monitor | Collected WRITE addr=0x1198 data=0xff |
| 92775 | hbus monitor | Collected READ  addr=0x1198 data=0xff |
| 92795 | hbus monitor | Collected WRITE addr=0x1199 data=0xff |
| 92825 | hbus monitor | Collected READ  addr=0x1199 data=0xff |
| 92845 | hbus monitor | Collected WRITE addr=0x119a data=0xff |
| 92875 | hbus monitor | Collected READ  addr=0x119a data=0xff |
| 92895 | hbus monitor | Collected WRITE addr=0x119b data=0xff |
| 92925 | hbus monitor | Collected READ  addr=0x119b data=0xff |
| 92945 | hbus monitor | Collected WRITE addr=0x119c data=0xff |
| 92975 | hbus monitor | Collected READ  addr=0x119c data=0xff |
| 92995 | hbus monitor | Collected WRITE addr=0x119d data=0xff |
| 93025 | hbus monitor | Collected READ  addr=0x119d data=0xff |
| 93045 | hbus monitor | Collected WRITE addr=0x119e data=0xff |
| 93075 | hbus monitor | Collected READ  addr=0x119e data=0xff |
| 93095 | hbus monitor | Collected WRITE addr=0x119f data=0xff |
| 93125 | hbus monitor | Collected READ  addr=0x119f data=0xff |
| 93145 | hbus monitor | Collected WRITE addr=0x11a0 data=0xff |
| 93175 | hbus monitor | Collected READ  addr=0x11a0 data=0xff |
| 93195 | hbus monitor | Collected WRITE addr=0x11a1 data=0xff |
| 93225 | hbus monitor | Collected READ  addr=0x11a1 data=0xff |
| 93245 | hbus monitor | Collected WRITE addr=0x11a2 data=0xff |
| 93275 | hbus monitor | Collected READ  addr=0x11a2 data=0xff |
| 93295 | hbus monitor | Collected WRITE addr=0x11a3 data=0xff |
| 93325 | hbus monitor | Collected READ  addr=0x11a3 data=0xff |
| 93345 | hbus monitor | Collected WRITE addr=0x11a4 data=0xff |
| 93375 | hbus monitor | Collected READ  addr=0x11a4 data=0xff |
| 93395 | hbus monitor | Collected WRITE addr=0x11a5 data=0xff |
| 93425 | hbus monitor | Collected READ  addr=0x11a5 data=0xff |
| 93445 | hbus monitor | Collected WRITE addr=0x11a6 data=0xff |
| 93475 | hbus monitor | Collected READ  addr=0x11a6 data=0xff |
| 93495 | hbus monitor | Collected WRITE addr=0x11a7 data=0xff |
| 93525 | hbus monitor | Collected READ  addr=0x11a7 data=0xff |
| 93545 | hbus monitor | Collected WRITE addr=0x11a8 data=0xff |
| 93575 | hbus monitor | Collected READ  addr=0x11a8 data=0xff |
| 93595 | hbus monitor | Collected WRITE addr=0x11a9 data=0xff |
| 93625 | hbus monitor | Collected READ  addr=0x11a9 data=0xff |
| 93645 | hbus monitor | Collected WRITE addr=0x11aa data=0xff |
| 93675 | hbus monitor | Collected READ  addr=0x11aa data=0xff |
| 93695 | hbus monitor | Collected WRITE addr=0x11ab data=0xff |
| 93725 | hbus monitor | Collected READ  addr=0x11ab data=0xff |
| 93745 | hbus monitor | Collected WRITE addr=0x11ac data=0xff |
| 93775 | hbus monitor | Collected READ  addr=0x11ac data=0xff |
| 93795 | hbus monitor | Collected WRITE addr=0x11ad data=0xff |
| 93825 | hbus monitor | Collected READ  addr=0x11ad data=0xff |
| 93845 | hbus monitor | Collected WRITE addr=0x11ae data=0xff |
| 93875 | hbus monitor | Collected READ  addr=0x11ae data=0xff |
| 93895 | hbus monitor | Collected WRITE addr=0x11af data=0xff |
| 93925 | hbus monitor | Collected READ  addr=0x11af data=0xff |
| 93945 | hbus monitor | Collected WRITE addr=0x11b0 data=0xff |
| 93975 | hbus monitor | Collected READ  addr=0x11b0 data=0xff |
| 93995 | hbus monitor | Collected WRITE addr=0x11b1 data=0xff |
| 94025 | hbus monitor | Collected READ  addr=0x11b1 data=0xff |
| 94045 | hbus monitor | Collected WRITE addr=0x11b2 data=0xff |
| 94075 | hbus monitor | Collected READ  addr=0x11b2 data=0xff |
| 94095 | hbus monitor | Collected WRITE addr=0x11b3 data=0xff |
| 94125 | hbus monitor | Collected READ  addr=0x11b3 data=0xff |
| 94145 | hbus monitor | Collected WRITE addr=0x11b4 data=0xff |
| 94175 | hbus monitor | Collected READ  addr=0x11b4 data=0xff |
| 94195 | hbus monitor | Collected WRITE addr=0x11b5 data=0xff |
| 94225 | hbus monitor | Collected READ  addr=0x11b5 data=0xff |
| 94245 | hbus monitor | Collected WRITE addr=0x11b6 data=0xff |
| 94275 | hbus monitor | Collected READ  addr=0x11b6 data=0xff |
| 94295 | hbus monitor | Collected WRITE addr=0x11b7 data=0xff |
| 94325 | hbus monitor | Collected READ  addr=0x11b7 data=0xff |
| 94345 | hbus monitor | Collected WRITE addr=0x11b8 data=0xff |
| 94375 | hbus monitor | Collected READ  addr=0x11b8 data=0xff |
| 94395 | hbus monitor | Collected WRITE addr=0x11b9 data=0xff |
| 94425 | hbus monitor | Collected READ  addr=0x11b9 data=0xff |
| 94445 | hbus monitor | Collected WRITE addr=0x11ba data=0xff |
| 94475 | hbus monitor | Collected READ  addr=0x11ba data=0xff |
| 94495 | hbus monitor | Collected WRITE addr=0x11bb data=0xff |
| 94525 | hbus monitor | Collected READ  addr=0x11bb data=0xff |
| 94545 | hbus monitor | Collected WRITE addr=0x11bc data=0xff |
| 94575 | hbus monitor | Collected READ  addr=0x11bc data=0xff |
| 94595 | hbus monitor | Collected WRITE addr=0x11bd data=0xff |
| 94625 | hbus monitor | Collected READ  addr=0x11bd data=0xff |
| 94645 | hbus monitor | Collected WRITE addr=0x11be data=0xff |
| 94675 | hbus monitor | Collected READ  addr=0x11be data=0xff |
| 94695 | hbus monitor | Collected WRITE addr=0x11bf data=0xff |
| 94725 | hbus monitor | Collected READ  addr=0x11bf data=0xff |
| 94745 | hbus monitor | Collected WRITE addr=0x11c0 data=0xff |
| 94775 | hbus monitor | Collected READ  addr=0x11c0 data=0xff |
| 94795 | hbus monitor | Collected WRITE addr=0x11c1 data=0xff |
| 94825 | hbus monitor | Collected READ  addr=0x11c1 data=0xff |
| 94845 | hbus monitor | Collected WRITE addr=0x11c2 data=0xff |
| 94875 | hbus monitor | Collected READ  addr=0x11c2 data=0xff |
| 94895 | hbus monitor | Collected WRITE addr=0x11c3 data=0xff |
| 94925 | hbus monitor | Collected READ  addr=0x11c3 data=0xff |
| 94945 | hbus monitor | Collected WRITE addr=0x11c4 data=0xff |
| 94975 | hbus monitor | Collected READ  addr=0x11c4 data=0xff |
| 94995 | hbus monitor | Collected WRITE addr=0x11c5 data=0xff |
| 95025 | hbus monitor | Collected READ  addr=0x11c5 data=0xff |
| 95045 | hbus monitor | Collected WRITE addr=0x11c6 data=0xff |
| 95075 | hbus monitor | Collected READ  addr=0x11c6 data=0xff |
| 95095 | hbus monitor | Collected WRITE addr=0x11c7 data=0xff |
| 95125 | hbus monitor | Collected READ  addr=0x11c7 data=0xff |
| 95145 | hbus monitor | Collected WRITE addr=0x11c8 data=0xff |
| 95175 | hbus monitor | Collected READ  addr=0x11c8 data=0xff |
| 95195 | hbus monitor | Collected WRITE addr=0x11c9 data=0xff |
| 95225 | hbus monitor | Collected READ  addr=0x11c9 data=0xff |
| 95245 | hbus monitor | Collected WRITE addr=0x11ca data=0xff |
| 95275 | hbus monitor | Collected READ  addr=0x11ca data=0xff |
| 95295 | hbus monitor | Collected WRITE addr=0x11cb data=0xff |
| 95325 | hbus monitor | Collected READ  addr=0x11cb data=0xff |
| 95345 | hbus monitor | Collected WRITE addr=0x11cc data=0xff |
| 95375 | hbus monitor | Collected READ  addr=0x11cc data=0xff |
| 95395 | hbus monitor | Collected WRITE addr=0x11cd data=0xff |
| 95425 | hbus monitor | Collected READ  addr=0x11cd data=0xff |
| 95445 | hbus monitor | Collected WRITE addr=0x11ce data=0xff |
| 95475 | hbus monitor | Collected READ  addr=0x11ce data=0xff |
| 95495 | hbus monitor | Collected WRITE addr=0x11cf data=0xff |
| 95525 | hbus monitor | Collected READ  addr=0x11cf data=0xff |
| 95545 | hbus monitor | Collected WRITE addr=0x11d0 data=0xff |
| 95575 | hbus monitor | Collected READ  addr=0x11d0 data=0xff |
| 95595 | hbus monitor | Collected WRITE addr=0x11d1 data=0xff |
| 95625 | hbus monitor | Collected READ  addr=0x11d1 data=0xff |
| 95645 | hbus monitor | Collected WRITE addr=0x11d2 data=0xff |
| 95675 | hbus monitor | Collected READ  addr=0x11d2 data=0xff |
| 95695 | hbus monitor | Collected WRITE addr=0x11d3 data=0xff |
| 95725 | hbus monitor | Collected READ  addr=0x11d3 data=0xff |
| 95745 | hbus monitor | Collected WRITE addr=0x11d4 data=0xff |
| 95775 | hbus monitor | Collected READ  addr=0x11d4 data=0xff |
| 95795 | hbus monitor | Collected WRITE addr=0x11d5 data=0xff |
| 95825 | hbus monitor | Collected READ  addr=0x11d5 data=0xff |
| 95845 | hbus monitor | Collected WRITE addr=0x11d6 data=0xff |
| 95875 | hbus monitor | Collected READ  addr=0x11d6 data=0xff |
| 95895 | hbus monitor | Collected WRITE addr=0x11d7 data=0xff |
| 95925 | hbus monitor | Collected READ  addr=0x11d7 data=0xff |
| 95945 | hbus monitor | Collected WRITE addr=0x11d8 data=0xff |
| 95975 | hbus monitor | Collected READ  addr=0x11d8 data=0xff |
| 95995 | hbus monitor | Collected WRITE addr=0x11d9 data=0xff |
| 96025 | hbus monitor | Collected READ  addr=0x11d9 data=0xff |
| 96045 | hbus monitor | Collected WRITE addr=0x11da data=0xff |
| 96075 | hbus monitor | Collected READ  addr=0x11da data=0xff |
| 96095 | hbus monitor | Collected WRITE addr=0x11db data=0xff |
| 96125 | hbus monitor | Collected READ  addr=0x11db data=0xff |
| 96145 | hbus monitor | Collected WRITE addr=0x11dc data=0xff |
| 96175 | hbus monitor | Collected READ  addr=0x11dc data=0xff |
| 96195 | hbus monitor | Collected WRITE addr=0x11dd data=0xff |
| 96225 | hbus monitor | Collected READ  addr=0x11dd data=0xff |
| 96245 | hbus monitor | Collected WRITE addr=0x11de data=0xff |
| 96275 | hbus monitor | Collected READ  addr=0x11de data=0xff |
| 96295 | hbus monitor | Collected WRITE addr=0x11df data=0xff |
| 96325 | hbus monitor | Collected READ  addr=0x11df data=0xff |
| 96345 | hbus monitor | Collected WRITE addr=0x11e0 data=0xff |
| 96375 | hbus monitor | Collected READ  addr=0x11e0 data=0xff |
| 96395 | hbus monitor | Collected WRITE addr=0x11e1 data=0xff |
| 96425 | hbus monitor | Collected READ  addr=0x11e1 data=0xff |
| 96445 | hbus monitor | Collected WRITE addr=0x11e2 data=0xff |
| 96475 | hbus monitor | Collected READ  addr=0x11e2 data=0xff |
| 96495 | hbus monitor | Collected WRITE addr=0x11e3 data=0xff |
| 96525 | hbus monitor | Collected READ  addr=0x11e3 data=0xff |
| 96545 | hbus monitor | Collected WRITE addr=0x11e4 data=0xff |
| 96575 | hbus monitor | Collected READ  addr=0x11e4 data=0xff |
| 96595 | hbus monitor | Collected WRITE addr=0x11e5 data=0xff |
| 96625 | hbus monitor | Collected READ  addr=0x11e5 data=0xff |
| 96645 | hbus monitor | Collected WRITE addr=0x11e6 data=0xff |
| 96675 | hbus monitor | Collected READ  addr=0x11e6 data=0xff |
| 96695 | hbus monitor | Collected WRITE addr=0x11e7 data=0xff |
| 96725 | hbus monitor | Collected READ  addr=0x11e7 data=0xff |
| 96745 | hbus monitor | Collected WRITE addr=0x11e8 data=0xff |
| 96775 | hbus monitor | Collected READ  addr=0x11e8 data=0xff |
| 96795 | hbus monitor | Collected WRITE addr=0x11e9 data=0xff |
| 96825 | hbus monitor | Collected READ  addr=0x11e9 data=0xff |
| 96845 | hbus monitor | Collected WRITE addr=0x11ea data=0xff |
| 96875 | hbus monitor | Collected READ  addr=0x11ea data=0xff |
| 96895 | hbus monitor | Collected WRITE addr=0x11eb data=0xff |
| 96925 | hbus monitor | Collected READ  addr=0x11eb data=0xff |
| 96945 | hbus monitor | Collected WRITE addr=0x11ec data=0xff |
| 96975 | hbus monitor | Collected READ  addr=0x11ec data=0xff |
| 96995 | hbus monitor | Collected WRITE addr=0x11ed data=0xff |
| 97025 | hbus monitor | Collected READ  addr=0x11ed data=0xff |
| 97045 | hbus monitor | Collected WRITE addr=0x11ee data=0xff |
| 97075 | hbus monitor | Collected READ  addr=0x11ee data=0xff |
| 97095 | hbus monitor | Collected WRITE addr=0x11ef data=0xff |
| 97125 | hbus monitor | Collected READ  addr=0x11ef data=0xff |
| 97145 | hbus monitor | Collected WRITE addr=0x11f0 data=0xff |
| 97175 | hbus monitor | Collected READ  addr=0x11f0 data=0xff |
| 97195 | hbus monitor | Collected WRITE addr=0x11f1 data=0xff |
| 97225 | hbus monitor | Collected READ  addr=0x11f1 data=0xff |
| 97245 | hbus monitor | Collected WRITE addr=0x11f2 data=0xff |
| 97275 | hbus monitor | Collected READ  addr=0x11f2 data=0xff |
| 97295 | hbus monitor | Collected WRITE addr=0x11f3 data=0xff |
| 97325 | hbus monitor | Collected READ  addr=0x11f3 data=0xff |
| 97345 | hbus monitor | Collected WRITE addr=0x11f4 data=0xff |
| 97375 | hbus monitor | Collected READ  addr=0x11f4 data=0xff |
| 97395 | hbus monitor | Collected WRITE addr=0x11f5 data=0xff |
| 97425 | hbus monitor | Collected READ  addr=0x11f5 data=0xff |
| 97445 | hbus monitor | Collected WRITE addr=0x11f6 data=0xff |
| 97475 | hbus monitor | Collected READ  addr=0x11f6 data=0xff |
| 97495 | hbus monitor | Collected WRITE addr=0x11f7 data=0xff |
| 97525 | hbus monitor | Collected READ  addr=0x11f7 data=0xff |
| 97545 | hbus monitor | Collected WRITE addr=0x11f8 data=0xff |
| 97575 | hbus monitor | Collected READ  addr=0x11f8 data=0xff |
| 97595 | hbus monitor | Collected WRITE addr=0x11f9 data=0xff |
| 97625 | hbus monitor | Collected READ  addr=0x11f9 data=0xff |
| 97645 | hbus monitor | Collected WRITE addr=0x11fa data=0xff |
| 97675 | hbus monitor | Collected READ  addr=0x11fa data=0xff |
| 97695 | hbus monitor | Collected WRITE addr=0x11fb data=0xff |
| 97725 | hbus monitor | Collected READ  addr=0x11fb data=0xff |
| 97745 | hbus monitor | Collected WRITE addr=0x11fc data=0xff |
| 97775 | hbus monitor | Collected READ  addr=0x11fc data=0xff |
| 97795 | hbus monitor | Collected WRITE addr=0x11fd data=0xff |
| 97825 | hbus monitor | Collected READ  addr=0x11fd data=0xff |
| 97845 | hbus monitor | Collected WRITE addr=0x11fe data=0xff |
| 97875 | hbus monitor | Collected READ  addr=0x11fe data=0xff |
| 97895 | hbus monitor | Collected WRITE addr=0x11ff data=0xff |
| 97925 | hbus monitor | Collected READ  addr=0x11ff data=0xff |
| 97945 | hbus monitor | Collected WRITE addr=0x1100 data=0x55 |
| 97975 | hbus monitor | Collected READ  addr=0x1100 data=0x55 |
| 97995 | hbus monitor | Collected WRITE addr=0x1101 data=0x55 |
| 98025 | hbus monitor | Collected READ  addr=0x1101 data=0x55 |
| 98045 | hbus monitor | Collected WRITE addr=0x1102 data=0x55 |
| 98075 | hbus monitor | Collected READ  addr=0x1102 data=0x55 |
| 98095 | hbus monitor | Collected WRITE addr=0x1103 data=0x55 |
| 98125 | hbus monitor | Collected READ  addr=0x1103 data=0x55 |
| 98145 | hbus monitor | Collected WRITE addr=0x1104 data=0x55 |
| 98175 | hbus monitor | Collected READ  addr=0x1104 data=0x55 |
| 98195 | hbus monitor | Collected WRITE addr=0x1105 data=0x55 |
| 98225 | hbus monitor | Collected READ  addr=0x1105 data=0x55 |
| 98245 | hbus monitor | Collected WRITE addr=0x1106 data=0x55 |
| 98275 | hbus monitor | Collected READ  addr=0x1106 data=0x55 |
| 98295 | hbus monitor | Collected WRITE addr=0x1107 data=0x55 |
| 98325 | hbus monitor | Collected READ  addr=0x1107 data=0x55 |
| 98345 | hbus monitor | Collected WRITE addr=0x1108 data=0x55 |
| 98375 | hbus monitor | Collected READ  addr=0x1108 data=0x55 |
| 98395 | hbus monitor | Collected WRITE addr=0x1109 data=0x55 |
| 98425 | hbus monitor | Collected READ  addr=0x1109 data=0x55 |
| 98445 | hbus monitor | Collected WRITE addr=0x110a data=0x55 |
| 98475 | hbus monitor | Collected READ  addr=0x110a data=0x55 |
| 98495 | hbus monitor | Collected WRITE addr=0x110b data=0x55 |
| 98525 | hbus monitor | Collected READ  addr=0x110b data=0x55 |
| 98545 | hbus monitor | Collected WRITE addr=0x110c data=0x55 |
| 98575 | hbus monitor | Collected READ  addr=0x110c data=0x55 |
| 98595 | hbus monitor | Collected WRITE addr=0x110d data=0x55 |
| 98625 | hbus monitor | Collected READ  addr=0x110d data=0x55 |
| 98645 | hbus monitor | Collected WRITE addr=0x110e data=0x55 |
| 98675 | hbus monitor | Collected READ  addr=0x110e data=0x55 |
| 98695 | hbus monitor | Collected WRITE addr=0x110f data=0x55 |
| 98725 | hbus monitor | Collected READ  addr=0x110f data=0x55 |
| 98745 | hbus monitor | Collected WRITE addr=0x1110 data=0x55 |
| 98775 | hbus monitor | Collected READ  addr=0x1110 data=0x55 |
| 98795 | hbus monitor | Collected WRITE addr=0x1111 data=0x55 |
| 98825 | hbus monitor | Collected READ  addr=0x1111 data=0x55 |
| 98845 | hbus monitor | Collected WRITE addr=0x1112 data=0x55 |
| 98875 | hbus monitor | Collected READ  addr=0x1112 data=0x55 |
| 98895 | hbus monitor | Collected WRITE addr=0x1113 data=0x55 |
| 98925 | hbus monitor | Collected READ  addr=0x1113 data=0x55 |
| 98945 | hbus monitor | Collected WRITE addr=0x1114 data=0x55 |
| 98975 | hbus monitor | Collected READ  addr=0x1114 data=0x55 |
| 98995 | hbus monitor | Collected WRITE addr=0x1115 data=0x55 |
| 99025 | hbus monitor | Collected READ  addr=0x1115 data=0x55 |
| 99045 | hbus monitor | Collected WRITE addr=0x1116 data=0x55 |
| 99075 | hbus monitor | Collected READ  addr=0x1116 data=0x55 |
| 99095 | hbus monitor | Collected WRITE addr=0x1117 data=0x55 |
| 99125 | hbus monitor | Collected READ  addr=0x1117 data=0x55 |
| 99145 | hbus monitor | Collected WRITE addr=0x1118 data=0x55 |
| 99175 | hbus monitor | Collected READ  addr=0x1118 data=0x55 |
| 99195 | hbus monitor | Collected WRITE addr=0x1119 data=0x55 |
| 99225 | hbus monitor | Collected READ  addr=0x1119 data=0x55 |
| 99245 | hbus monitor | Collected WRITE addr=0x111a data=0x55 |
| 99275 | hbus monitor | Collected READ  addr=0x111a data=0x55 |
| 99295 | hbus monitor | Collected WRITE addr=0x111b data=0x55 |
| 99325 | hbus monitor | Collected READ  addr=0x111b data=0x55 |
| 99345 | hbus monitor | Collected WRITE addr=0x111c data=0x55 |
| 99375 | hbus monitor | Collected READ  addr=0x111c data=0x55 |
| 99395 | hbus monitor | Collected WRITE addr=0x111d data=0x55 |
| 99425 | hbus monitor | Collected READ  addr=0x111d data=0x55 |
| 99445 | hbus monitor | Collected WRITE addr=0x111e data=0x55 |
| 99475 | hbus monitor | Collected READ  addr=0x111e data=0x55 |
| 99495 | hbus monitor | Collected WRITE addr=0x111f data=0x55 |
| 99525 | hbus monitor | Collected READ  addr=0x111f data=0x55 |
| 99545 | hbus monitor | Collected WRITE addr=0x1120 data=0x55 |
| 99575 | hbus monitor | Collected READ  addr=0x1120 data=0x55 |
| 99595 | hbus monitor | Collected WRITE addr=0x1121 data=0x55 |
| 99625 | hbus monitor | Collected READ  addr=0x1121 data=0x55 |
| 99645 | hbus monitor | Collected WRITE addr=0x1122 data=0x55 |
| 99675 | hbus monitor | Collected READ  addr=0x1122 data=0x55 |
| 99695 | hbus monitor | Collected WRITE addr=0x1123 data=0x55 |
| 99725 | hbus monitor | Collected READ  addr=0x1123 data=0x55 |
| 99745 | hbus monitor | Collected WRITE addr=0x1124 data=0x55 |
| 99775 | hbus monitor | Collected READ  addr=0x1124 data=0x55 |
| 99795 | hbus monitor | Collected WRITE addr=0x1125 data=0x55 |
| 99825 | hbus monitor | Collected READ  addr=0x1125 data=0x55 |
| 99845 | hbus monitor | Collected WRITE addr=0x1126 data=0x55 |
| 99875 | hbus monitor | Collected READ  addr=0x1126 data=0x55 |
| 99895 | hbus monitor | Collected WRITE addr=0x1127 data=0x55 |
| 99925 | hbus monitor | Collected READ  addr=0x1127 data=0x55 |
| 99945 | hbus monitor | Collected WRITE addr=0x1128 data=0x55 |
| 99975 | hbus monitor | Collected READ  addr=0x1128 data=0x55 |
| 99995 | hbus monitor | Collected WRITE addr=0x1129 data=0x55 |
| 100025 | hbus monitor | Collected READ  addr=0x1129 data=0x55 |
| 100045 | hbus monitor | Collected WRITE addr=0x112a data=0x55 |
| 100075 | hbus monitor | Collected READ  addr=0x112a data=0x55 |
| 100095 | hbus monitor | Collected WRITE addr=0x112b data=0x55 |
| 100125 | hbus monitor | Collected READ  addr=0x112b data=0x55 |
| 100145 | hbus monitor | Collected WRITE addr=0x112c data=0x55 |
| 100175 | hbus monitor | Collected READ  addr=0x112c data=0x55 |
| 100195 | hbus monitor | Collected WRITE addr=0x112d data=0x55 |
| 100225 | hbus monitor | Collected READ  addr=0x112d data=0x55 |
| 100245 | hbus monitor | Collected WRITE addr=0x112e data=0x55 |
| 100275 | hbus monitor | Collected READ  addr=0x112e data=0x55 |
| 100295 | hbus monitor | Collected WRITE addr=0x112f data=0x55 |
| 100325 | hbus monitor | Collected READ  addr=0x112f data=0x55 |
| 100345 | hbus monitor | Collected WRITE addr=0x1130 data=0x55 |
| 100375 | hbus monitor | Collected READ  addr=0x1130 data=0x55 |
| 100395 | hbus monitor | Collected WRITE addr=0x1131 data=0x55 |
| 100425 | hbus monitor | Collected READ  addr=0x1131 data=0x55 |
| 100445 | hbus monitor | Collected WRITE addr=0x1132 data=0x55 |
| 100475 | hbus monitor | Collected READ  addr=0x1132 data=0x55 |
| 100495 | hbus monitor | Collected WRITE addr=0x1133 data=0x55 |
| 100525 | hbus monitor | Collected READ  addr=0x1133 data=0x55 |
| 100545 | hbus monitor | Collected WRITE addr=0x1134 data=0x55 |
| 100575 | hbus monitor | Collected READ  addr=0x1134 data=0x55 |
| 100595 | hbus monitor | Collected WRITE addr=0x1135 data=0x55 |
| 100625 | hbus monitor | Collected READ  addr=0x1135 data=0x55 |
| 100645 | hbus monitor | Collected WRITE addr=0x1136 data=0x55 |
| 100675 | hbus monitor | Collected READ  addr=0x1136 data=0x55 |
| 100695 | hbus monitor | Collected WRITE addr=0x1137 data=0x55 |
| 100725 | hbus monitor | Collected READ  addr=0x1137 data=0x55 |
| 100745 | hbus monitor | Collected WRITE addr=0x1138 data=0x55 |
| 100775 | hbus monitor | Collected READ  addr=0x1138 data=0x55 |
| 100795 | hbus monitor | Collected WRITE addr=0x1139 data=0x55 |
| 100825 | hbus monitor | Collected READ  addr=0x1139 data=0x55 |
| 100845 | hbus monitor | Collected WRITE addr=0x113a data=0x55 |
| 100875 | hbus monitor | Collected READ  addr=0x113a data=0x55 |
| 100895 | hbus monitor | Collected WRITE addr=0x113b data=0x55 |
| 100925 | hbus monitor | Collected READ  addr=0x113b data=0x55 |
| 100945 | hbus monitor | Collected WRITE addr=0x113c data=0x55 |
| 100975 | hbus monitor | Collected READ  addr=0x113c data=0x55 |
| 100995 | hbus monitor | Collected WRITE addr=0x113d data=0x55 |
| 101025 | hbus monitor | Collected READ  addr=0x113d data=0x55 |
| 101045 | hbus monitor | Collected WRITE addr=0x113e data=0x55 |
| 101075 | hbus monitor | Collected READ  addr=0x113e data=0x55 |
| 101095 | hbus monitor | Collected WRITE addr=0x113f data=0x55 |
| 101125 | hbus monitor | Collected READ  addr=0x113f data=0x55 |
| 101145 | hbus monitor | Collected WRITE addr=0x1140 data=0x55 |
| 101175 | hbus monitor | Collected READ  addr=0x1140 data=0x55 |
| 101195 | hbus monitor | Collected WRITE addr=0x1141 data=0x55 |
| 101225 | hbus monitor | Collected READ  addr=0x1141 data=0x55 |
| 101245 | hbus monitor | Collected WRITE addr=0x1142 data=0x55 |
| 101275 | hbus monitor | Collected READ  addr=0x1142 data=0x55 |
| 101295 | hbus monitor | Collected WRITE addr=0x1143 data=0x55 |
| 101325 | hbus monitor | Collected READ  addr=0x1143 data=0x55 |
| 101345 | hbus monitor | Collected WRITE addr=0x1144 data=0x55 |
| 101375 | hbus monitor | Collected READ  addr=0x1144 data=0x55 |
| 101395 | hbus monitor | Collected WRITE addr=0x1145 data=0x55 |
| 101425 | hbus monitor | Collected READ  addr=0x1145 data=0x55 |
| 101445 | hbus monitor | Collected WRITE addr=0x1146 data=0x55 |
| 101475 | hbus monitor | Collected READ  addr=0x1146 data=0x55 |
| 101495 | hbus monitor | Collected WRITE addr=0x1147 data=0x55 |
| 101525 | hbus monitor | Collected READ  addr=0x1147 data=0x55 |
| 101545 | hbus monitor | Collected WRITE addr=0x1148 data=0x55 |
| 101575 | hbus monitor | Collected READ  addr=0x1148 data=0x55 |
| 101595 | hbus monitor | Collected WRITE addr=0x1149 data=0x55 |
| 101625 | hbus monitor | Collected READ  addr=0x1149 data=0x55 |
| 101645 | hbus monitor | Collected WRITE addr=0x114a data=0x55 |
| 101675 | hbus monitor | Collected READ  addr=0x114a data=0x55 |
| 101695 | hbus monitor | Collected WRITE addr=0x114b data=0x55 |
| 101725 | hbus monitor | Collected READ  addr=0x114b data=0x55 |
| 101745 | hbus monitor | Collected WRITE addr=0x114c data=0x55 |
| 101775 | hbus monitor | Collected READ  addr=0x114c data=0x55 |
| 101795 | hbus monitor | Collected WRITE addr=0x114d data=0x55 |
| 101825 | hbus monitor | Collected READ  addr=0x114d data=0x55 |
| 101845 | hbus monitor | Collected WRITE addr=0x114e data=0x55 |
| 101875 | hbus monitor | Collected READ  addr=0x114e data=0x55 |
| 101895 | hbus monitor | Collected WRITE addr=0x114f data=0x55 |
| 101925 | hbus monitor | Collected READ  addr=0x114f data=0x55 |
| 101945 | hbus monitor | Collected WRITE addr=0x1150 data=0x55 |
| 101975 | hbus monitor | Collected READ  addr=0x1150 data=0x55 |
| 101995 | hbus monitor | Collected WRITE addr=0x1151 data=0x55 |
| 102025 | hbus monitor | Collected READ  addr=0x1151 data=0x55 |
| 102045 | hbus monitor | Collected WRITE addr=0x1152 data=0x55 |
| 102075 | hbus monitor | Collected READ  addr=0x1152 data=0x55 |
| 102095 | hbus monitor | Collected WRITE addr=0x1153 data=0x55 |
| 102125 | hbus monitor | Collected READ  addr=0x1153 data=0x55 |
| 102145 | hbus monitor | Collected WRITE addr=0x1154 data=0x55 |
| 102175 | hbus monitor | Collected READ  addr=0x1154 data=0x55 |
| 102195 | hbus monitor | Collected WRITE addr=0x1155 data=0x55 |
| 102225 | hbus monitor | Collected READ  addr=0x1155 data=0x55 |
| 102245 | hbus monitor | Collected WRITE addr=0x1156 data=0x55 |
| 102275 | hbus monitor | Collected READ  addr=0x1156 data=0x55 |
| 102295 | hbus monitor | Collected WRITE addr=0x1157 data=0x55 |
| 102325 | hbus monitor | Collected READ  addr=0x1157 data=0x55 |
| 102345 | hbus monitor | Collected WRITE addr=0x1158 data=0x55 |
| 102375 | hbus monitor | Collected READ  addr=0x1158 data=0x55 |
| 102395 | hbus monitor | Collected WRITE addr=0x1159 data=0x55 |
| 102425 | hbus monitor | Collected READ  addr=0x1159 data=0x55 |
| 102445 | hbus monitor | Collected WRITE addr=0x115a data=0x55 |
| 102475 | hbus monitor | Collected READ  addr=0x115a data=0x55 |
| 102495 | hbus monitor | Collected WRITE addr=0x115b data=0x55 |
| 102525 | hbus monitor | Collected READ  addr=0x115b data=0x55 |
| 102545 | hbus monitor | Collected WRITE addr=0x115c data=0x55 |
| 102575 | hbus monitor | Collected READ  addr=0x115c data=0x55 |
| 102595 | hbus monitor | Collected WRITE addr=0x115d data=0x55 |
| 102625 | hbus monitor | Collected READ  addr=0x115d data=0x55 |
| 102645 | hbus monitor | Collected WRITE addr=0x115e data=0x55 |
| 102675 | hbus monitor | Collected READ  addr=0x115e data=0x55 |
| 102695 | hbus monitor | Collected WRITE addr=0x115f data=0x55 |
| 102725 | hbus monitor | Collected READ  addr=0x115f data=0x55 |
| 102745 | hbus monitor | Collected WRITE addr=0x1160 data=0x55 |
| 102775 | hbus monitor | Collected READ  addr=0x1160 data=0x55 |
| 102795 | hbus monitor | Collected WRITE addr=0x1161 data=0x55 |
| 102825 | hbus monitor | Collected READ  addr=0x1161 data=0x55 |
| 102845 | hbus monitor | Collected WRITE addr=0x1162 data=0x55 |
| 102875 | hbus monitor | Collected READ  addr=0x1162 data=0x55 |
| 102895 | hbus monitor | Collected WRITE addr=0x1163 data=0x55 |
| 102925 | hbus monitor | Collected READ  addr=0x1163 data=0x55 |
| 102945 | hbus monitor | Collected WRITE addr=0x1164 data=0x55 |
| 102975 | hbus monitor | Collected READ  addr=0x1164 data=0x55 |
| 102995 | hbus monitor | Collected WRITE addr=0x1165 data=0x55 |
| 103025 | hbus monitor | Collected READ  addr=0x1165 data=0x55 |
| 103045 | hbus monitor | Collected WRITE addr=0x1166 data=0x55 |
| 103075 | hbus monitor | Collected READ  addr=0x1166 data=0x55 |
| 103095 | hbus monitor | Collected WRITE addr=0x1167 data=0x55 |
| 103125 | hbus monitor | Collected READ  addr=0x1167 data=0x55 |
| 103145 | hbus monitor | Collected WRITE addr=0x1168 data=0x55 |
| 103175 | hbus monitor | Collected READ  addr=0x1168 data=0x55 |
| 103195 | hbus monitor | Collected WRITE addr=0x1169 data=0x55 |
| 103225 | hbus monitor | Collected READ  addr=0x1169 data=0x55 |
| 103245 | hbus monitor | Collected WRITE addr=0x116a data=0x55 |
| 103275 | hbus monitor | Collected READ  addr=0x116a data=0x55 |
| 103295 | hbus monitor | Collected WRITE addr=0x116b data=0x55 |
| 103325 | hbus monitor | Collected READ  addr=0x116b data=0x55 |
| 103345 | hbus monitor | Collected WRITE addr=0x116c data=0x55 |
| 103375 | hbus monitor | Collected READ  addr=0x116c data=0x55 |
| 103395 | hbus monitor | Collected WRITE addr=0x116d data=0x55 |
| 103425 | hbus monitor | Collected READ  addr=0x116d data=0x55 |
| 103445 | hbus monitor | Collected WRITE addr=0x116e data=0x55 |
| 103475 | hbus monitor | Collected READ  addr=0x116e data=0x55 |
| 103495 | hbus monitor | Collected WRITE addr=0x116f data=0x55 |
| 103525 | hbus monitor | Collected READ  addr=0x116f data=0x55 |
| 103545 | hbus monitor | Collected WRITE addr=0x1170 data=0x55 |
| 103575 | hbus monitor | Collected READ  addr=0x1170 data=0x55 |
| 103595 | hbus monitor | Collected WRITE addr=0x1171 data=0x55 |
| 103625 | hbus monitor | Collected READ  addr=0x1171 data=0x55 |
| 103645 | hbus monitor | Collected WRITE addr=0x1172 data=0x55 |
| 103675 | hbus monitor | Collected READ  addr=0x1172 data=0x55 |
| 103695 | hbus monitor | Collected WRITE addr=0x1173 data=0x55 |
| 103725 | hbus monitor | Collected READ  addr=0x1173 data=0x55 |
| 103745 | hbus monitor | Collected WRITE addr=0x1174 data=0x55 |
| 103775 | hbus monitor | Collected READ  addr=0x1174 data=0x55 |
| 103795 | hbus monitor | Collected WRITE addr=0x1175 data=0x55 |
| 103825 | hbus monitor | Collected READ  addr=0x1175 data=0x55 |
| 103845 | hbus monitor | Collected WRITE addr=0x1176 data=0x55 |
| 103875 | hbus monitor | Collected READ  addr=0x1176 data=0x55 |
| 103895 | hbus monitor | Collected WRITE addr=0x1177 data=0x55 |
| 103925 | hbus monitor | Collected READ  addr=0x1177 data=0x55 |
| 103945 | hbus monitor | Collected WRITE addr=0x1178 data=0x55 |
| 103975 | hbus monitor | Collected READ  addr=0x1178 data=0x55 |
| 103995 | hbus monitor | Collected WRITE addr=0x1179 data=0x55 |
| 104025 | hbus monitor | Collected READ  addr=0x1179 data=0x55 |
| 104045 | hbus monitor | Collected WRITE addr=0x117a data=0x55 |
| 104075 | hbus monitor | Collected READ  addr=0x117a data=0x55 |
| 104095 | hbus monitor | Collected WRITE addr=0x117b data=0x55 |
| 104125 | hbus monitor | Collected READ  addr=0x117b data=0x55 |
| 104145 | hbus monitor | Collected WRITE addr=0x117c data=0x55 |
| 104175 | hbus monitor | Collected READ  addr=0x117c data=0x55 |
| 104195 | hbus monitor | Collected WRITE addr=0x117d data=0x55 |
| 104225 | hbus monitor | Collected READ  addr=0x117d data=0x55 |
| 104245 | hbus monitor | Collected WRITE addr=0x117e data=0x55 |
| 104275 | hbus monitor | Collected READ  addr=0x117e data=0x55 |
| 104295 | hbus monitor | Collected WRITE addr=0x117f data=0x55 |
| 104325 | hbus monitor | Collected READ  addr=0x117f data=0x55 |
| 104345 | hbus monitor | Collected WRITE addr=0x1180 data=0x55 |
| 104375 | hbus monitor | Collected READ  addr=0x1180 data=0x55 |
| 104395 | hbus monitor | Collected WRITE addr=0x1181 data=0x55 |
| 104425 | hbus monitor | Collected READ  addr=0x1181 data=0x55 |
| 104445 | hbus monitor | Collected WRITE addr=0x1182 data=0x55 |
| 104475 | hbus monitor | Collected READ  addr=0x1182 data=0x55 |
| 104495 | hbus monitor | Collected WRITE addr=0x1183 data=0x55 |
| 104525 | hbus monitor | Collected READ  addr=0x1183 data=0x55 |
| 104545 | hbus monitor | Collected WRITE addr=0x1184 data=0x55 |
| 104575 | hbus monitor | Collected READ  addr=0x1184 data=0x55 |
| 104595 | hbus monitor | Collected WRITE addr=0x1185 data=0x55 |
| 104625 | hbus monitor | Collected READ  addr=0x1185 data=0x55 |
| 104645 | hbus monitor | Collected WRITE addr=0x1186 data=0x55 |
| 104675 | hbus monitor | Collected READ  addr=0x1186 data=0x55 |
| 104695 | hbus monitor | Collected WRITE addr=0x1187 data=0x55 |
| 104725 | hbus monitor | Collected READ  addr=0x1187 data=0x55 |
| 104745 | hbus monitor | Collected WRITE addr=0x1188 data=0x55 |
| 104775 | hbus monitor | Collected READ  addr=0x1188 data=0x55 |
| 104795 | hbus monitor | Collected WRITE addr=0x1189 data=0x55 |
| 104825 | hbus monitor | Collected READ  addr=0x1189 data=0x55 |
| 104845 | hbus monitor | Collected WRITE addr=0x118a data=0x55 |
| 104875 | hbus monitor | Collected READ  addr=0x118a data=0x55 |
| 104895 | hbus monitor | Collected WRITE addr=0x118b data=0x55 |
| 104925 | hbus monitor | Collected READ  addr=0x118b data=0x55 |
| 104945 | hbus monitor | Collected WRITE addr=0x118c data=0x55 |
| 104975 | hbus monitor | Collected READ  addr=0x118c data=0x55 |
| 104995 | hbus monitor | Collected WRITE addr=0x118d data=0x55 |
| 105025 | hbus monitor | Collected READ  addr=0x118d data=0x55 |
| 105045 | hbus monitor | Collected WRITE addr=0x118e data=0x55 |
| 105075 | hbus monitor | Collected READ  addr=0x118e data=0x55 |
| 105095 | hbus monitor | Collected WRITE addr=0x118f data=0x55 |
| 105125 | hbus monitor | Collected READ  addr=0x118f data=0x55 |
| 105145 | hbus monitor | Collected WRITE addr=0x1190 data=0x55 |
| 105175 | hbus monitor | Collected READ  addr=0x1190 data=0x55 |
| 105195 | hbus monitor | Collected WRITE addr=0x1191 data=0x55 |
| 105225 | hbus monitor | Collected READ  addr=0x1191 data=0x55 |
| 105245 | hbus monitor | Collected WRITE addr=0x1192 data=0x55 |
| 105275 | hbus monitor | Collected READ  addr=0x1192 data=0x55 |
| 105295 | hbus monitor | Collected WRITE addr=0x1193 data=0x55 |
| 105325 | hbus monitor | Collected READ  addr=0x1193 data=0x55 |
| 105345 | hbus monitor | Collected WRITE addr=0x1194 data=0x55 |
| 105375 | hbus monitor | Collected READ  addr=0x1194 data=0x55 |
| 105395 | hbus monitor | Collected WRITE addr=0x1195 data=0x55 |
| 105425 | hbus monitor | Collected READ  addr=0x1195 data=0x55 |
| 105445 | hbus monitor | Collected WRITE addr=0x1196 data=0x55 |
| 105475 | hbus monitor | Collected READ  addr=0x1196 data=0x55 |
| 105495 | hbus monitor | Collected WRITE addr=0x1197 data=0x55 |
| 105525 | hbus monitor | Collected READ  addr=0x1197 data=0x55 |
| 105545 | hbus monitor | Collected WRITE addr=0x1198 data=0x55 |
| 105575 | hbus monitor | Collected READ  addr=0x1198 data=0x55 |
| 105595 | hbus monitor | Collected WRITE addr=0x1199 data=0x55 |
| 105625 | hbus monitor | Collected READ  addr=0x1199 data=0x55 |
| 105645 | hbus monitor | Collected WRITE addr=0x119a data=0x55 |
| 105675 | hbus monitor | Collected READ  addr=0x119a data=0x55 |
| 105695 | hbus monitor | Collected WRITE addr=0x119b data=0x55 |
| 105725 | hbus monitor | Collected READ  addr=0x119b data=0x55 |
| 105745 | hbus monitor | Collected WRITE addr=0x119c data=0x55 |
| 105775 | hbus monitor | Collected READ  addr=0x119c data=0x55 |
| 105795 | hbus monitor | Collected WRITE addr=0x119d data=0x55 |
| 105825 | hbus monitor | Collected READ  addr=0x119d data=0x55 |
| 105845 | hbus monitor | Collected WRITE addr=0x119e data=0x55 |
| 105875 | hbus monitor | Collected READ  addr=0x119e data=0x55 |
| 105895 | hbus monitor | Collected WRITE addr=0x119f data=0x55 |
| 105925 | hbus monitor | Collected READ  addr=0x119f data=0x55 |
| 105945 | hbus monitor | Collected WRITE addr=0x11a0 data=0x55 |
| 105975 | hbus monitor | Collected READ  addr=0x11a0 data=0x55 |
| 105995 | hbus monitor | Collected WRITE addr=0x11a1 data=0x55 |
| 106025 | hbus monitor | Collected READ  addr=0x11a1 data=0x55 |
| 106045 | hbus monitor | Collected WRITE addr=0x11a2 data=0x55 |
| 106075 | hbus monitor | Collected READ  addr=0x11a2 data=0x55 |
| 106095 | hbus monitor | Collected WRITE addr=0x11a3 data=0x55 |
| 106125 | hbus monitor | Collected READ  addr=0x11a3 data=0x55 |
| 106145 | hbus monitor | Collected WRITE addr=0x11a4 data=0x55 |
| 106175 | hbus monitor | Collected READ  addr=0x11a4 data=0x55 |
| 106195 | hbus monitor | Collected WRITE addr=0x11a5 data=0x55 |
| 106225 | hbus monitor | Collected READ  addr=0x11a5 data=0x55 |
| 106245 | hbus monitor | Collected WRITE addr=0x11a6 data=0x55 |
| 106275 | hbus monitor | Collected READ  addr=0x11a6 data=0x55 |
| 106295 | hbus monitor | Collected WRITE addr=0x11a7 data=0x55 |
| 106325 | hbus monitor | Collected READ  addr=0x11a7 data=0x55 |
| 106345 | hbus monitor | Collected WRITE addr=0x11a8 data=0x55 |
| 106375 | hbus monitor | Collected READ  addr=0x11a8 data=0x55 |
| 106395 | hbus monitor | Collected WRITE addr=0x11a9 data=0x55 |
| 106425 | hbus monitor | Collected READ  addr=0x11a9 data=0x55 |
| 106445 | hbus monitor | Collected WRITE addr=0x11aa data=0x55 |
| 106475 | hbus monitor | Collected READ  addr=0x11aa data=0x55 |
| 106495 | hbus monitor | Collected WRITE addr=0x11ab data=0x55 |
| 106525 | hbus monitor | Collected READ  addr=0x11ab data=0x55 |
| 106545 | hbus monitor | Collected WRITE addr=0x11ac data=0x55 |
| 106575 | hbus monitor | Collected READ  addr=0x11ac data=0x55 |
| 106595 | hbus monitor | Collected WRITE addr=0x11ad data=0x55 |
| 106625 | hbus monitor | Collected READ  addr=0x11ad data=0x55 |
| 106645 | hbus monitor | Collected WRITE addr=0x11ae data=0x55 |
| 106675 | hbus monitor | Collected READ  addr=0x11ae data=0x55 |
| 106695 | hbus monitor | Collected WRITE addr=0x11af data=0x55 |
| 106725 | hbus monitor | Collected READ  addr=0x11af data=0x55 |
| 106745 | hbus monitor | Collected WRITE addr=0x11b0 data=0x55 |
| 106775 | hbus monitor | Collected READ  addr=0x11b0 data=0x55 |
| 106795 | hbus monitor | Collected WRITE addr=0x11b1 data=0x55 |
| 106825 | hbus monitor | Collected READ  addr=0x11b1 data=0x55 |
| 106845 | hbus monitor | Collected WRITE addr=0x11b2 data=0x55 |
| 106875 | hbus monitor | Collected READ  addr=0x11b2 data=0x55 |
| 106895 | hbus monitor | Collected WRITE addr=0x11b3 data=0x55 |
| 106925 | hbus monitor | Collected READ  addr=0x11b3 data=0x55 |
| 106945 | hbus monitor | Collected WRITE addr=0x11b4 data=0x55 |
| 106975 | hbus monitor | Collected READ  addr=0x11b4 data=0x55 |
| 106995 | hbus monitor | Collected WRITE addr=0x11b5 data=0x55 |
| 107025 | hbus monitor | Collected READ  addr=0x11b5 data=0x55 |
| 107045 | hbus monitor | Collected WRITE addr=0x11b6 data=0x55 |
| 107075 | hbus monitor | Collected READ  addr=0x11b6 data=0x55 |
| 107095 | hbus monitor | Collected WRITE addr=0x11b7 data=0x55 |
| 107125 | hbus monitor | Collected READ  addr=0x11b7 data=0x55 |
| 107145 | hbus monitor | Collected WRITE addr=0x11b8 data=0x55 |
| 107175 | hbus monitor | Collected READ  addr=0x11b8 data=0x55 |
| 107195 | hbus monitor | Collected WRITE addr=0x11b9 data=0x55 |
| 107225 | hbus monitor | Collected READ  addr=0x11b9 data=0x55 |
| 107245 | hbus monitor | Collected WRITE addr=0x11ba data=0x55 |
| 107275 | hbus monitor | Collected READ  addr=0x11ba data=0x55 |
| 107295 | hbus monitor | Collected WRITE addr=0x11bb data=0x55 |
| 107325 | hbus monitor | Collected READ  addr=0x11bb data=0x55 |
| 107345 | hbus monitor | Collected WRITE addr=0x11bc data=0x55 |
| 107375 | hbus monitor | Collected READ  addr=0x11bc data=0x55 |
| 107395 | hbus monitor | Collected WRITE addr=0x11bd data=0x55 |
| 107425 | hbus monitor | Collected READ  addr=0x11bd data=0x55 |
| 107445 | hbus monitor | Collected WRITE addr=0x11be data=0x55 |
| 107475 | hbus monitor | Collected READ  addr=0x11be data=0x55 |
| 107495 | hbus monitor | Collected WRITE addr=0x11bf data=0x55 |
| 107525 | hbus monitor | Collected READ  addr=0x11bf data=0x55 |
| 107545 | hbus monitor | Collected WRITE addr=0x11c0 data=0x55 |
| 107575 | hbus monitor | Collected READ  addr=0x11c0 data=0x55 |
| 107595 | hbus monitor | Collected WRITE addr=0x11c1 data=0x55 |
| 107625 | hbus monitor | Collected READ  addr=0x11c1 data=0x55 |
| 107645 | hbus monitor | Collected WRITE addr=0x11c2 data=0x55 |
| 107675 | hbus monitor | Collected READ  addr=0x11c2 data=0x55 |
| 107695 | hbus monitor | Collected WRITE addr=0x11c3 data=0x55 |
| 107725 | hbus monitor | Collected READ  addr=0x11c3 data=0x55 |
| 107745 | hbus monitor | Collected WRITE addr=0x11c4 data=0x55 |
| 107775 | hbus monitor | Collected READ  addr=0x11c4 data=0x55 |
| 107795 | hbus monitor | Collected WRITE addr=0x11c5 data=0x55 |
| 107825 | hbus monitor | Collected READ  addr=0x11c5 data=0x55 |
| 107845 | hbus monitor | Collected WRITE addr=0x11c6 data=0x55 |
| 107875 | hbus monitor | Collected READ  addr=0x11c6 data=0x55 |
| 107895 | hbus monitor | Collected WRITE addr=0x11c7 data=0x55 |
| 107925 | hbus monitor | Collected READ  addr=0x11c7 data=0x55 |
| 107945 | hbus monitor | Collected WRITE addr=0x11c8 data=0x55 |
| 107975 | hbus monitor | Collected READ  addr=0x11c8 data=0x55 |
| 107995 | hbus monitor | Collected WRITE addr=0x11c9 data=0x55 |
| 108025 | hbus monitor | Collected READ  addr=0x11c9 data=0x55 |
| 108045 | hbus monitor | Collected WRITE addr=0x11ca data=0x55 |
| 108075 | hbus monitor | Collected READ  addr=0x11ca data=0x55 |
| 108095 | hbus monitor | Collected WRITE addr=0x11cb data=0x55 |
| 108125 | hbus monitor | Collected READ  addr=0x11cb data=0x55 |
| 108145 | hbus monitor | Collected WRITE addr=0x11cc data=0x55 |
| 108175 | hbus monitor | Collected READ  addr=0x11cc data=0x55 |
| 108195 | hbus monitor | Collected WRITE addr=0x11cd data=0x55 |
| 108225 | hbus monitor | Collected READ  addr=0x11cd data=0x55 |
| 108245 | hbus monitor | Collected WRITE addr=0x11ce data=0x55 |
| 108275 | hbus monitor | Collected READ  addr=0x11ce data=0x55 |
| 108295 | hbus monitor | Collected WRITE addr=0x11cf data=0x55 |
| 108325 | hbus monitor | Collected READ  addr=0x11cf data=0x55 |
| 108345 | hbus monitor | Collected WRITE addr=0x11d0 data=0x55 |
| 108375 | hbus monitor | Collected READ  addr=0x11d0 data=0x55 |
| 108395 | hbus monitor | Collected WRITE addr=0x11d1 data=0x55 |
| 108425 | hbus monitor | Collected READ  addr=0x11d1 data=0x55 |
| 108445 | hbus monitor | Collected WRITE addr=0x11d2 data=0x55 |
| 108475 | hbus monitor | Collected READ  addr=0x11d2 data=0x55 |
| 108495 | hbus monitor | Collected WRITE addr=0x11d3 data=0x55 |
| 108525 | hbus monitor | Collected READ  addr=0x11d3 data=0x55 |
| 108545 | hbus monitor | Collected WRITE addr=0x11d4 data=0x55 |
| 108575 | hbus monitor | Collected READ  addr=0x11d4 data=0x55 |
| 108595 | hbus monitor | Collected WRITE addr=0x11d5 data=0x55 |
| 108625 | hbus monitor | Collected READ  addr=0x11d5 data=0x55 |
| 108645 | hbus monitor | Collected WRITE addr=0x11d6 data=0x55 |
| 108675 | hbus monitor | Collected READ  addr=0x11d6 data=0x55 |
| 108695 | hbus monitor | Collected WRITE addr=0x11d7 data=0x55 |
| 108725 | hbus monitor | Collected READ  addr=0x11d7 data=0x55 |
| 108745 | hbus monitor | Collected WRITE addr=0x11d8 data=0x55 |
| 108775 | hbus monitor | Collected READ  addr=0x11d8 data=0x55 |
| 108795 | hbus monitor | Collected WRITE addr=0x11d9 data=0x55 |
| 108825 | hbus monitor | Collected READ  addr=0x11d9 data=0x55 |
| 108845 | hbus monitor | Collected WRITE addr=0x11da data=0x55 |
| 108875 | hbus monitor | Collected READ  addr=0x11da data=0x55 |
| 108895 | hbus monitor | Collected WRITE addr=0x11db data=0x55 |
| 108925 | hbus monitor | Collected READ  addr=0x11db data=0x55 |
| 108945 | hbus monitor | Collected WRITE addr=0x11dc data=0x55 |
| 108975 | hbus monitor | Collected READ  addr=0x11dc data=0x55 |
| 108995 | hbus monitor | Collected WRITE addr=0x11dd data=0x55 |
| 109025 | hbus monitor | Collected READ  addr=0x11dd data=0x55 |
| 109045 | hbus monitor | Collected WRITE addr=0x11de data=0x55 |
| 109075 | hbus monitor | Collected READ  addr=0x11de data=0x55 |
| 109095 | hbus monitor | Collected WRITE addr=0x11df data=0x55 |
| 109125 | hbus monitor | Collected READ  addr=0x11df data=0x55 |
| 109145 | hbus monitor | Collected WRITE addr=0x11e0 data=0x55 |
| 109175 | hbus monitor | Collected READ  addr=0x11e0 data=0x55 |
| 109195 | hbus monitor | Collected WRITE addr=0x11e1 data=0x55 |
| 109225 | hbus monitor | Collected READ  addr=0x11e1 data=0x55 |
| 109245 | hbus monitor | Collected WRITE addr=0x11e2 data=0x55 |
| 109275 | hbus monitor | Collected READ  addr=0x11e2 data=0x55 |
| 109295 | hbus monitor | Collected WRITE addr=0x11e3 data=0x55 |
| 109325 | hbus monitor | Collected READ  addr=0x11e3 data=0x55 |
| 109345 | hbus monitor | Collected WRITE addr=0x11e4 data=0x55 |
| 109375 | hbus monitor | Collected READ  addr=0x11e4 data=0x55 |
| 109395 | hbus monitor | Collected WRITE addr=0x11e5 data=0x55 |
| 109425 | hbus monitor | Collected READ  addr=0x11e5 data=0x55 |
| 109445 | hbus monitor | Collected WRITE addr=0x11e6 data=0x55 |
| 109475 | hbus monitor | Collected READ  addr=0x11e6 data=0x55 |
| 109495 | hbus monitor | Collected WRITE addr=0x11e7 data=0x55 |
| 109525 | hbus monitor | Collected READ  addr=0x11e7 data=0x55 |
| 109545 | hbus monitor | Collected WRITE addr=0x11e8 data=0x55 |
| 109575 | hbus monitor | Collected READ  addr=0x11e8 data=0x55 |
| 109595 | hbus monitor | Collected WRITE addr=0x11e9 data=0x55 |
| 109625 | hbus monitor | Collected READ  addr=0x11e9 data=0x55 |
| 109645 | hbus monitor | Collected WRITE addr=0x11ea data=0x55 |
| 109675 | hbus monitor | Collected READ  addr=0x11ea data=0x55 |
| 109695 | hbus monitor | Collected WRITE addr=0x11eb data=0x55 |
| 109725 | hbus monitor | Collected READ  addr=0x11eb data=0x55 |
| 109745 | hbus monitor | Collected WRITE addr=0x11ec data=0x55 |
| 109775 | hbus monitor | Collected READ  addr=0x11ec data=0x55 |
| 109795 | hbus monitor | Collected WRITE addr=0x11ed data=0x55 |
| 109825 | hbus monitor | Collected READ  addr=0x11ed data=0x55 |
| 109845 | hbus monitor | Collected WRITE addr=0x11ee data=0x55 |
| 109875 | hbus monitor | Collected READ  addr=0x11ee data=0x55 |
| 109895 | hbus monitor | Collected WRITE addr=0x11ef data=0x55 |
| 109925 | hbus monitor | Collected READ  addr=0x11ef data=0x55 |
| 109945 | hbus monitor | Collected WRITE addr=0x11f0 data=0x55 |
| 109975 | hbus monitor | Collected READ  addr=0x11f0 data=0x55 |
| 109995 | hbus monitor | Collected WRITE addr=0x11f1 data=0x55 |
| 110025 | hbus monitor | Collected READ  addr=0x11f1 data=0x55 |
| 110045 | hbus monitor | Collected WRITE addr=0x11f2 data=0x55 |
| 110075 | hbus monitor | Collected READ  addr=0x11f2 data=0x55 |
| 110095 | hbus monitor | Collected WRITE addr=0x11f3 data=0x55 |
| 110125 | hbus monitor | Collected READ  addr=0x11f3 data=0x55 |
| 110145 | hbus monitor | Collected WRITE addr=0x11f4 data=0x55 |
| 110175 | hbus monitor | Collected READ  addr=0x11f4 data=0x55 |
| 110195 | hbus monitor | Collected WRITE addr=0x11f5 data=0x55 |
| 110225 | hbus monitor | Collected READ  addr=0x11f5 data=0x55 |
| 110245 | hbus monitor | Collected WRITE addr=0x11f6 data=0x55 |
| 110275 | hbus monitor | Collected READ  addr=0x11f6 data=0x55 |
| 110295 | hbus monitor | Collected WRITE addr=0x11f7 data=0x55 |
| 110325 | hbus monitor | Collected READ  addr=0x11f7 data=0x55 |
| 110345 | hbus monitor | Collected WRITE addr=0x11f8 data=0x55 |
| 110375 | hbus monitor | Collected READ  addr=0x11f8 data=0x55 |
| 110395 | hbus monitor | Collected WRITE addr=0x11f9 data=0x55 |
| 110425 | hbus monitor | Collected READ  addr=0x11f9 data=0x55 |
| 110445 | hbus monitor | Collected WRITE addr=0x11fa data=0x55 |
| 110475 | hbus monitor | Collected READ  addr=0x11fa data=0x55 |
| 110495 | hbus monitor | Collected WRITE addr=0x11fb data=0x55 |
| 110525 | hbus monitor | Collected READ  addr=0x11fb data=0x55 |
| 110545 | hbus monitor | Collected WRITE addr=0x11fc data=0x55 |
| 110575 | hbus monitor | Collected READ  addr=0x11fc data=0x55 |
| 110595 | hbus monitor | Collected WRITE addr=0x11fd data=0x55 |
| 110625 | hbus monitor | Collected READ  addr=0x11fd data=0x55 |
| 110645 | hbus monitor | Collected WRITE addr=0x11fe data=0x55 |
| 110675 | hbus monitor | Collected READ  addr=0x11fe data=0x55 |
| 110695 | hbus monitor | Collected WRITE addr=0x11ff data=0x55 |
| 110725 | hbus monitor | Collected READ  addr=0x11ff data=0x55 |
| 110745 | hbus monitor | Collected WRITE addr=0x1100 data=0xaa |
| 110775 | hbus monitor | Collected READ  addr=0x1100 data=0xaa |
| 110795 | hbus monitor | Collected WRITE addr=0x1101 data=0xaa |
| 110825 | hbus monitor | Collected READ  addr=0x1101 data=0xaa |
| 110845 | hbus monitor | Collected WRITE addr=0x1102 data=0xaa |
| 110875 | hbus monitor | Collected READ  addr=0x1102 data=0xaa |
| 110895 | hbus monitor | Collected WRITE addr=0x1103 data=0xaa |
| 110925 | hbus monitor | Collected READ  addr=0x1103 data=0xaa |
| 110945 | hbus monitor | Collected WRITE addr=0x1104 data=0xaa |
| 110975 | hbus monitor | Collected READ  addr=0x1104 data=0xaa |
| 110995 | hbus monitor | Collected WRITE addr=0x1105 data=0xaa |
| 111025 | hbus monitor | Collected READ  addr=0x1105 data=0xaa |
| 111045 | hbus monitor | Collected WRITE addr=0x1106 data=0xaa |
| 111075 | hbus monitor | Collected READ  addr=0x1106 data=0xaa |
| 111095 | hbus monitor | Collected WRITE addr=0x1107 data=0xaa |
| 111125 | hbus monitor | Collected READ  addr=0x1107 data=0xaa |
| 111145 | hbus monitor | Collected WRITE addr=0x1108 data=0xaa |
| 111175 | hbus monitor | Collected READ  addr=0x1108 data=0xaa |
| 111195 | hbus monitor | Collected WRITE addr=0x1109 data=0xaa |
| 111225 | hbus monitor | Collected READ  addr=0x1109 data=0xaa |
| 111245 | hbus monitor | Collected WRITE addr=0x110a data=0xaa |
| 111275 | hbus monitor | Collected READ  addr=0x110a data=0xaa |
| 111295 | hbus monitor | Collected WRITE addr=0x110b data=0xaa |
| 111325 | hbus monitor | Collected READ  addr=0x110b data=0xaa |
| 111345 | hbus monitor | Collected WRITE addr=0x110c data=0xaa |
| 111375 | hbus monitor | Collected READ  addr=0x110c data=0xaa |
| 111395 | hbus monitor | Collected WRITE addr=0x110d data=0xaa |
| 111425 | hbus monitor | Collected READ  addr=0x110d data=0xaa |
| 111445 | hbus monitor | Collected WRITE addr=0x110e data=0xaa |
| 111475 | hbus monitor | Collected READ  addr=0x110e data=0xaa |
| 111495 | hbus monitor | Collected WRITE addr=0x110f data=0xaa |
| 111525 | hbus monitor | Collected READ  addr=0x110f data=0xaa |
| 111545 | hbus monitor | Collected WRITE addr=0x1110 data=0xaa |
| 111575 | hbus monitor | Collected READ  addr=0x1110 data=0xaa |
| 111595 | hbus monitor | Collected WRITE addr=0x1111 data=0xaa |
| 111625 | hbus monitor | Collected READ  addr=0x1111 data=0xaa |
| 111645 | hbus monitor | Collected WRITE addr=0x1112 data=0xaa |
| 111675 | hbus monitor | Collected READ  addr=0x1112 data=0xaa |
| 111695 | hbus monitor | Collected WRITE addr=0x1113 data=0xaa |
| 111725 | hbus monitor | Collected READ  addr=0x1113 data=0xaa |
| 111745 | hbus monitor | Collected WRITE addr=0x1114 data=0xaa |
| 111775 | hbus monitor | Collected READ  addr=0x1114 data=0xaa |
| 111795 | hbus monitor | Collected WRITE addr=0x1115 data=0xaa |
| 111825 | hbus monitor | Collected READ  addr=0x1115 data=0xaa |
| 111845 | hbus monitor | Collected WRITE addr=0x1116 data=0xaa |
| 111875 | hbus monitor | Collected READ  addr=0x1116 data=0xaa |
| 111895 | hbus monitor | Collected WRITE addr=0x1117 data=0xaa |
| 111925 | hbus monitor | Collected READ  addr=0x1117 data=0xaa |
| 111945 | hbus monitor | Collected WRITE addr=0x1118 data=0xaa |
| 111975 | hbus monitor | Collected READ  addr=0x1118 data=0xaa |
| 111995 | hbus monitor | Collected WRITE addr=0x1119 data=0xaa |
| 112025 | hbus monitor | Collected READ  addr=0x1119 data=0xaa |
| 112045 | hbus monitor | Collected WRITE addr=0x111a data=0xaa |
| 112075 | hbus monitor | Collected READ  addr=0x111a data=0xaa |
| 112095 | hbus monitor | Collected WRITE addr=0x111b data=0xaa |
| 112125 | hbus monitor | Collected READ  addr=0x111b data=0xaa |
| 112145 | hbus monitor | Collected WRITE addr=0x111c data=0xaa |
| 112175 | hbus monitor | Collected READ  addr=0x111c data=0xaa |
| 112195 | hbus monitor | Collected WRITE addr=0x111d data=0xaa |
| 112225 | hbus monitor | Collected READ  addr=0x111d data=0xaa |
| 112245 | hbus monitor | Collected WRITE addr=0x111e data=0xaa |
| 112275 | hbus monitor | Collected READ  addr=0x111e data=0xaa |
| 112295 | hbus monitor | Collected WRITE addr=0x111f data=0xaa |
| 112325 | hbus monitor | Collected READ  addr=0x111f data=0xaa |
| 112345 | hbus monitor | Collected WRITE addr=0x1120 data=0xaa |
| 112375 | hbus monitor | Collected READ  addr=0x1120 data=0xaa |
| 112395 | hbus monitor | Collected WRITE addr=0x1121 data=0xaa |
| 112425 | hbus monitor | Collected READ  addr=0x1121 data=0xaa |
| 112445 | hbus monitor | Collected WRITE addr=0x1122 data=0xaa |
| 112475 | hbus monitor | Collected READ  addr=0x1122 data=0xaa |
| 112495 | hbus monitor | Collected WRITE addr=0x1123 data=0xaa |
| 112525 | hbus monitor | Collected READ  addr=0x1123 data=0xaa |
| 112545 | hbus monitor | Collected WRITE addr=0x1124 data=0xaa |
| 112575 | hbus monitor | Collected READ  addr=0x1124 data=0xaa |
| 112595 | hbus monitor | Collected WRITE addr=0x1125 data=0xaa |
| 112625 | hbus monitor | Collected READ  addr=0x1125 data=0xaa |
| 112645 | hbus monitor | Collected WRITE addr=0x1126 data=0xaa |
| 112675 | hbus monitor | Collected READ  addr=0x1126 data=0xaa |
| 112695 | hbus monitor | Collected WRITE addr=0x1127 data=0xaa |
| 112725 | hbus monitor | Collected READ  addr=0x1127 data=0xaa |
| 112745 | hbus monitor | Collected WRITE addr=0x1128 data=0xaa |
| 112775 | hbus monitor | Collected READ  addr=0x1128 data=0xaa |
| 112795 | hbus monitor | Collected WRITE addr=0x1129 data=0xaa |
| 112825 | hbus monitor | Collected READ  addr=0x1129 data=0xaa |
| 112845 | hbus monitor | Collected WRITE addr=0x112a data=0xaa |
| 112875 | hbus monitor | Collected READ  addr=0x112a data=0xaa |
| 112895 | hbus monitor | Collected WRITE addr=0x112b data=0xaa |
| 112925 | hbus monitor | Collected READ  addr=0x112b data=0xaa |
| 112945 | hbus monitor | Collected WRITE addr=0x112c data=0xaa |
| 112975 | hbus monitor | Collected READ  addr=0x112c data=0xaa |
| 112995 | hbus monitor | Collected WRITE addr=0x112d data=0xaa |
| 113025 | hbus monitor | Collected READ  addr=0x112d data=0xaa |
| 113045 | hbus monitor | Collected WRITE addr=0x112e data=0xaa |
| 113075 | hbus monitor | Collected READ  addr=0x112e data=0xaa |
| 113095 | hbus monitor | Collected WRITE addr=0x112f data=0xaa |
| 113125 | hbus monitor | Collected READ  addr=0x112f data=0xaa |
| 113145 | hbus monitor | Collected WRITE addr=0x1130 data=0xaa |
| 113175 | hbus monitor | Collected READ  addr=0x1130 data=0xaa |
| 113195 | hbus monitor | Collected WRITE addr=0x1131 data=0xaa |
| 113225 | hbus monitor | Collected READ  addr=0x1131 data=0xaa |
| 113245 | hbus monitor | Collected WRITE addr=0x1132 data=0xaa |
| 113275 | hbus monitor | Collected READ  addr=0x1132 data=0xaa |
| 113295 | hbus monitor | Collected WRITE addr=0x1133 data=0xaa |
| 113325 | hbus monitor | Collected READ  addr=0x1133 data=0xaa |
| 113345 | hbus monitor | Collected WRITE addr=0x1134 data=0xaa |
| 113375 | hbus monitor | Collected READ  addr=0x1134 data=0xaa |
| 113395 | hbus monitor | Collected WRITE addr=0x1135 data=0xaa |
| 113425 | hbus monitor | Collected READ  addr=0x1135 data=0xaa |
| 113445 | hbus monitor | Collected WRITE addr=0x1136 data=0xaa |
| 113475 | hbus monitor | Collected READ  addr=0x1136 data=0xaa |
| 113495 | hbus monitor | Collected WRITE addr=0x1137 data=0xaa |
| 113525 | hbus monitor | Collected READ  addr=0x1137 data=0xaa |
| 113545 | hbus monitor | Collected WRITE addr=0x1138 data=0xaa |
| 113575 | hbus monitor | Collected READ  addr=0x1138 data=0xaa |
| 113595 | hbus monitor | Collected WRITE addr=0x1139 data=0xaa |
| 113625 | hbus monitor | Collected READ  addr=0x1139 data=0xaa |
| 113645 | hbus monitor | Collected WRITE addr=0x113a data=0xaa |
| 113675 | hbus monitor | Collected READ  addr=0x113a data=0xaa |
| 113695 | hbus monitor | Collected WRITE addr=0x113b data=0xaa |
| 113725 | hbus monitor | Collected READ  addr=0x113b data=0xaa |
| 113745 | hbus monitor | Collected WRITE addr=0x113c data=0xaa |
| 113775 | hbus monitor | Collected READ  addr=0x113c data=0xaa |
| 113795 | hbus monitor | Collected WRITE addr=0x113d data=0xaa |
| 113825 | hbus monitor | Collected READ  addr=0x113d data=0xaa |
| 113845 | hbus monitor | Collected WRITE addr=0x113e data=0xaa |
| 113875 | hbus monitor | Collected READ  addr=0x113e data=0xaa |
| 113895 | hbus monitor | Collected WRITE addr=0x113f data=0xaa |
| 113925 | hbus monitor | Collected READ  addr=0x113f data=0xaa |
| 113945 | hbus monitor | Collected WRITE addr=0x1140 data=0xaa |
| 113975 | hbus monitor | Collected READ  addr=0x1140 data=0xaa |
| 113995 | hbus monitor | Collected WRITE addr=0x1141 data=0xaa |
| 114025 | hbus monitor | Collected READ  addr=0x1141 data=0xaa |
| 114045 | hbus monitor | Collected WRITE addr=0x1142 data=0xaa |
| 114075 | hbus monitor | Collected READ  addr=0x1142 data=0xaa |
| 114095 | hbus monitor | Collected WRITE addr=0x1143 data=0xaa |
| 114125 | hbus monitor | Collected READ  addr=0x1143 data=0xaa |
| 114145 | hbus monitor | Collected WRITE addr=0x1144 data=0xaa |
| 114175 | hbus monitor | Collected READ  addr=0x1144 data=0xaa |
| 114195 | hbus monitor | Collected WRITE addr=0x1145 data=0xaa |
| 114225 | hbus monitor | Collected READ  addr=0x1145 data=0xaa |
| 114245 | hbus monitor | Collected WRITE addr=0x1146 data=0xaa |
| 114275 | hbus monitor | Collected READ  addr=0x1146 data=0xaa |
| 114295 | hbus monitor | Collected WRITE addr=0x1147 data=0xaa |
| 114325 | hbus monitor | Collected READ  addr=0x1147 data=0xaa |
| 114345 | hbus monitor | Collected WRITE addr=0x1148 data=0xaa |
| 114375 | hbus monitor | Collected READ  addr=0x1148 data=0xaa |
| 114395 | hbus monitor | Collected WRITE addr=0x1149 data=0xaa |
| 114425 | hbus monitor | Collected READ  addr=0x1149 data=0xaa |
| 114445 | hbus monitor | Collected WRITE addr=0x114a data=0xaa |
| 114475 | hbus monitor | Collected READ  addr=0x114a data=0xaa |
| 114495 | hbus monitor | Collected WRITE addr=0x114b data=0xaa |
| 114525 | hbus monitor | Collected READ  addr=0x114b data=0xaa |
| 114545 | hbus monitor | Collected WRITE addr=0x114c data=0xaa |
| 114575 | hbus monitor | Collected READ  addr=0x114c data=0xaa |
| 114595 | hbus monitor | Collected WRITE addr=0x114d data=0xaa |
| 114625 | hbus monitor | Collected READ  addr=0x114d data=0xaa |
| 114645 | hbus monitor | Collected WRITE addr=0x114e data=0xaa |
| 114675 | hbus monitor | Collected READ  addr=0x114e data=0xaa |
| 114695 | hbus monitor | Collected WRITE addr=0x114f data=0xaa |
| 114725 | hbus monitor | Collected READ  addr=0x114f data=0xaa |
| 114745 | hbus monitor | Collected WRITE addr=0x1150 data=0xaa |
| 114775 | hbus monitor | Collected READ  addr=0x1150 data=0xaa |
| 114795 | hbus monitor | Collected WRITE addr=0x1151 data=0xaa |
| 114825 | hbus monitor | Collected READ  addr=0x1151 data=0xaa |
| 114845 | hbus monitor | Collected WRITE addr=0x1152 data=0xaa |
| 114875 | hbus monitor | Collected READ  addr=0x1152 data=0xaa |
| 114895 | hbus monitor | Collected WRITE addr=0x1153 data=0xaa |
| 114925 | hbus monitor | Collected READ  addr=0x1153 data=0xaa |
| 114945 | hbus monitor | Collected WRITE addr=0x1154 data=0xaa |
| 114975 | hbus monitor | Collected READ  addr=0x1154 data=0xaa |
| 114995 | hbus monitor | Collected WRITE addr=0x1155 data=0xaa |
| 115025 | hbus monitor | Collected READ  addr=0x1155 data=0xaa |
| 115045 | hbus monitor | Collected WRITE addr=0x1156 data=0xaa |
| 115075 | hbus monitor | Collected READ  addr=0x1156 data=0xaa |
| 115095 | hbus monitor | Collected WRITE addr=0x1157 data=0xaa |
| 115125 | hbus monitor | Collected READ  addr=0x1157 data=0xaa |
| 115145 | hbus monitor | Collected WRITE addr=0x1158 data=0xaa |
| 115175 | hbus monitor | Collected READ  addr=0x1158 data=0xaa |
| 115195 | hbus monitor | Collected WRITE addr=0x1159 data=0xaa |
| 115225 | hbus monitor | Collected READ  addr=0x1159 data=0xaa |
| 115245 | hbus monitor | Collected WRITE addr=0x115a data=0xaa |
| 115275 | hbus monitor | Collected READ  addr=0x115a data=0xaa |
| 115295 | hbus monitor | Collected WRITE addr=0x115b data=0xaa |
| 115325 | hbus monitor | Collected READ  addr=0x115b data=0xaa |
| 115345 | hbus monitor | Collected WRITE addr=0x115c data=0xaa |
| 115375 | hbus monitor | Collected READ  addr=0x115c data=0xaa |
| 115395 | hbus monitor | Collected WRITE addr=0x115d data=0xaa |
| 115425 | hbus monitor | Collected READ  addr=0x115d data=0xaa |
| 115445 | hbus monitor | Collected WRITE addr=0x115e data=0xaa |
| 115475 | hbus monitor | Collected READ  addr=0x115e data=0xaa |
| 115495 | hbus monitor | Collected WRITE addr=0x115f data=0xaa |
| 115525 | hbus monitor | Collected READ  addr=0x115f data=0xaa |
| 115545 | hbus monitor | Collected WRITE addr=0x1160 data=0xaa |
| 115575 | hbus monitor | Collected READ  addr=0x1160 data=0xaa |
| 115595 | hbus monitor | Collected WRITE addr=0x1161 data=0xaa |
| 115625 | hbus monitor | Collected READ  addr=0x1161 data=0xaa |
| 115645 | hbus monitor | Collected WRITE addr=0x1162 data=0xaa |
| 115675 | hbus monitor | Collected READ  addr=0x1162 data=0xaa |
| 115695 | hbus monitor | Collected WRITE addr=0x1163 data=0xaa |
| 115725 | hbus monitor | Collected READ  addr=0x1163 data=0xaa |
| 115745 | hbus monitor | Collected WRITE addr=0x1164 data=0xaa |
| 115775 | hbus monitor | Collected READ  addr=0x1164 data=0xaa |
| 115795 | hbus monitor | Collected WRITE addr=0x1165 data=0xaa |
| 115825 | hbus monitor | Collected READ  addr=0x1165 data=0xaa |
| 115845 | hbus monitor | Collected WRITE addr=0x1166 data=0xaa |
| 115875 | hbus monitor | Collected READ  addr=0x1166 data=0xaa |
| 115895 | hbus monitor | Collected WRITE addr=0x1167 data=0xaa |
| 115925 | hbus monitor | Collected READ  addr=0x1167 data=0xaa |
| 115945 | hbus monitor | Collected WRITE addr=0x1168 data=0xaa |
| 115975 | hbus monitor | Collected READ  addr=0x1168 data=0xaa |
| 115995 | hbus monitor | Collected WRITE addr=0x1169 data=0xaa |
| 116025 | hbus monitor | Collected READ  addr=0x1169 data=0xaa |
| 116045 | hbus monitor | Collected WRITE addr=0x116a data=0xaa |
| 116075 | hbus monitor | Collected READ  addr=0x116a data=0xaa |
| 116095 | hbus monitor | Collected WRITE addr=0x116b data=0xaa |
| 116125 | hbus monitor | Collected READ  addr=0x116b data=0xaa |
| 116145 | hbus monitor | Collected WRITE addr=0x116c data=0xaa |
| 116175 | hbus monitor | Collected READ  addr=0x116c data=0xaa |
| 116195 | hbus monitor | Collected WRITE addr=0x116d data=0xaa |
| 116225 | hbus monitor | Collected READ  addr=0x116d data=0xaa |
| 116245 | hbus monitor | Collected WRITE addr=0x116e data=0xaa |
| 116275 | hbus monitor | Collected READ  addr=0x116e data=0xaa |
| 116295 | hbus monitor | Collected WRITE addr=0x116f data=0xaa |
| 116325 | hbus monitor | Collected READ  addr=0x116f data=0xaa |
| 116345 | hbus monitor | Collected WRITE addr=0x1170 data=0xaa |
| 116375 | hbus monitor | Collected READ  addr=0x1170 data=0xaa |
| 116395 | hbus monitor | Collected WRITE addr=0x1171 data=0xaa |
| 116425 | hbus monitor | Collected READ  addr=0x1171 data=0xaa |
| 116445 | hbus monitor | Collected WRITE addr=0x1172 data=0xaa |
| 116475 | hbus monitor | Collected READ  addr=0x1172 data=0xaa |
| 116495 | hbus monitor | Collected WRITE addr=0x1173 data=0xaa |
| 116525 | hbus monitor | Collected READ  addr=0x1173 data=0xaa |
| 116545 | hbus monitor | Collected WRITE addr=0x1174 data=0xaa |
| 116575 | hbus monitor | Collected READ  addr=0x1174 data=0xaa |
| 116595 | hbus monitor | Collected WRITE addr=0x1175 data=0xaa |
| 116625 | hbus monitor | Collected READ  addr=0x1175 data=0xaa |
| 116645 | hbus monitor | Collected WRITE addr=0x1176 data=0xaa |
| 116675 | hbus monitor | Collected READ  addr=0x1176 data=0xaa |
| 116695 | hbus monitor | Collected WRITE addr=0x1177 data=0xaa |
| 116725 | hbus monitor | Collected READ  addr=0x1177 data=0xaa |
| 116745 | hbus monitor | Collected WRITE addr=0x1178 data=0xaa |
| 116775 | hbus monitor | Collected READ  addr=0x1178 data=0xaa |
| 116795 | hbus monitor | Collected WRITE addr=0x1179 data=0xaa |
| 116825 | hbus monitor | Collected READ  addr=0x1179 data=0xaa |
| 116845 | hbus monitor | Collected WRITE addr=0x117a data=0xaa |
| 116875 | hbus monitor | Collected READ  addr=0x117a data=0xaa |
| 116895 | hbus monitor | Collected WRITE addr=0x117b data=0xaa |
| 116925 | hbus monitor | Collected READ  addr=0x117b data=0xaa |
| 116945 | hbus monitor | Collected WRITE addr=0x117c data=0xaa |
| 116975 | hbus monitor | Collected READ  addr=0x117c data=0xaa |
| 116995 | hbus monitor | Collected WRITE addr=0x117d data=0xaa |
| 117025 | hbus monitor | Collected READ  addr=0x117d data=0xaa |
| 117045 | hbus monitor | Collected WRITE addr=0x117e data=0xaa |
| 117075 | hbus monitor | Collected READ  addr=0x117e data=0xaa |
| 117095 | hbus monitor | Collected WRITE addr=0x117f data=0xaa |
| 117125 | hbus monitor | Collected READ  addr=0x117f data=0xaa |
| 117145 | hbus monitor | Collected WRITE addr=0x1180 data=0xaa |
| 117175 | hbus monitor | Collected READ  addr=0x1180 data=0xaa |
| 117195 | hbus monitor | Collected WRITE addr=0x1181 data=0xaa |
| 117225 | hbus monitor | Collected READ  addr=0x1181 data=0xaa |
| 117245 | hbus monitor | Collected WRITE addr=0x1182 data=0xaa |
| 117275 | hbus monitor | Collected READ  addr=0x1182 data=0xaa |
| 117295 | hbus monitor | Collected WRITE addr=0x1183 data=0xaa |
| 117325 | hbus monitor | Collected READ  addr=0x1183 data=0xaa |
| 117345 | hbus monitor | Collected WRITE addr=0x1184 data=0xaa |
| 117375 | hbus monitor | Collected READ  addr=0x1184 data=0xaa |
| 117395 | hbus monitor | Collected WRITE addr=0x1185 data=0xaa |
| 117425 | hbus monitor | Collected READ  addr=0x1185 data=0xaa |
| 117445 | hbus monitor | Collected WRITE addr=0x1186 data=0xaa |
| 117475 | hbus monitor | Collected READ  addr=0x1186 data=0xaa |
| 117495 | hbus monitor | Collected WRITE addr=0x1187 data=0xaa |
| 117525 | hbus monitor | Collected READ  addr=0x1187 data=0xaa |
| 117545 | hbus monitor | Collected WRITE addr=0x1188 data=0xaa |
| 117575 | hbus monitor | Collected READ  addr=0x1188 data=0xaa |
| 117595 | hbus monitor | Collected WRITE addr=0x1189 data=0xaa |
| 117625 | hbus monitor | Collected READ  addr=0x1189 data=0xaa |
| 117645 | hbus monitor | Collected WRITE addr=0x118a data=0xaa |
| 117675 | hbus monitor | Collected READ  addr=0x118a data=0xaa |
| 117695 | hbus monitor | Collected WRITE addr=0x118b data=0xaa |
| 117725 | hbus monitor | Collected READ  addr=0x118b data=0xaa |
| 117745 | hbus monitor | Collected WRITE addr=0x118c data=0xaa |
| 117775 | hbus monitor | Collected READ  addr=0x118c data=0xaa |
| 117795 | hbus monitor | Collected WRITE addr=0x118d data=0xaa |
| 117825 | hbus monitor | Collected READ  addr=0x118d data=0xaa |
| 117845 | hbus monitor | Collected WRITE addr=0x118e data=0xaa |
| 117875 | hbus monitor | Collected READ  addr=0x118e data=0xaa |
| 117895 | hbus monitor | Collected WRITE addr=0x118f data=0xaa |
| 117925 | hbus monitor | Collected READ  addr=0x118f data=0xaa |
| 117945 | hbus monitor | Collected WRITE addr=0x1190 data=0xaa |
| 117975 | hbus monitor | Collected READ  addr=0x1190 data=0xaa |
| 117995 | hbus monitor | Collected WRITE addr=0x1191 data=0xaa |
| 118025 | hbus monitor | Collected READ  addr=0x1191 data=0xaa |
| 118045 | hbus monitor | Collected WRITE addr=0x1192 data=0xaa |
| 118075 | hbus monitor | Collected READ  addr=0x1192 data=0xaa |
| 118095 | hbus monitor | Collected WRITE addr=0x1193 data=0xaa |
| 118125 | hbus monitor | Collected READ  addr=0x1193 data=0xaa |
| 118145 | hbus monitor | Collected WRITE addr=0x1194 data=0xaa |
| 118175 | hbus monitor | Collected READ  addr=0x1194 data=0xaa |
| 118195 | hbus monitor | Collected WRITE addr=0x1195 data=0xaa |
| 118225 | hbus monitor | Collected READ  addr=0x1195 data=0xaa |
| 118245 | hbus monitor | Collected WRITE addr=0x1196 data=0xaa |
| 118275 | hbus monitor | Collected READ  addr=0x1196 data=0xaa |
| 118295 | hbus monitor | Collected WRITE addr=0x1197 data=0xaa |
| 118325 | hbus monitor | Collected READ  addr=0x1197 data=0xaa |
| 118345 | hbus monitor | Collected WRITE addr=0x1198 data=0xaa |
| 118375 | hbus monitor | Collected READ  addr=0x1198 data=0xaa |
| 118395 | hbus monitor | Collected WRITE addr=0x1199 data=0xaa |
| 118425 | hbus monitor | Collected READ  addr=0x1199 data=0xaa |
| 118445 | hbus monitor | Collected WRITE addr=0x119a data=0xaa |
| 118475 | hbus monitor | Collected READ  addr=0x119a data=0xaa |
| 118495 | hbus monitor | Collected WRITE addr=0x119b data=0xaa |
| 118525 | hbus monitor | Collected READ  addr=0x119b data=0xaa |
| 118545 | hbus monitor | Collected WRITE addr=0x119c data=0xaa |
| 118575 | hbus monitor | Collected READ  addr=0x119c data=0xaa |
| 118595 | hbus monitor | Collected WRITE addr=0x119d data=0xaa |
| 118625 | hbus monitor | Collected READ  addr=0x119d data=0xaa |
| 118645 | hbus monitor | Collected WRITE addr=0x119e data=0xaa |
| 118675 | hbus monitor | Collected READ  addr=0x119e data=0xaa |
| 118695 | hbus monitor | Collected WRITE addr=0x119f data=0xaa |
| 118725 | hbus monitor | Collected READ  addr=0x119f data=0xaa |
| 118745 | hbus monitor | Collected WRITE addr=0x11a0 data=0xaa |
| 118775 | hbus monitor | Collected READ  addr=0x11a0 data=0xaa |
| 118795 | hbus monitor | Collected WRITE addr=0x11a1 data=0xaa |
| 118825 | hbus monitor | Collected READ  addr=0x11a1 data=0xaa |
| 118845 | hbus monitor | Collected WRITE addr=0x11a2 data=0xaa |
| 118875 | hbus monitor | Collected READ  addr=0x11a2 data=0xaa |
| 118895 | hbus monitor | Collected WRITE addr=0x11a3 data=0xaa |
| 118925 | hbus monitor | Collected READ  addr=0x11a3 data=0xaa |
| 118945 | hbus monitor | Collected WRITE addr=0x11a4 data=0xaa |
| 118975 | hbus monitor | Collected READ  addr=0x11a4 data=0xaa |
| 118995 | hbus monitor | Collected WRITE addr=0x11a5 data=0xaa |
| 119025 | hbus monitor | Collected READ  addr=0x11a5 data=0xaa |
| 119045 | hbus monitor | Collected WRITE addr=0x11a6 data=0xaa |
| 119075 | hbus monitor | Collected READ  addr=0x11a6 data=0xaa |
| 119095 | hbus monitor | Collected WRITE addr=0x11a7 data=0xaa |
| 119125 | hbus monitor | Collected READ  addr=0x11a7 data=0xaa |
| 119145 | hbus monitor | Collected WRITE addr=0x11a8 data=0xaa |
| 119175 | hbus monitor | Collected READ  addr=0x11a8 data=0xaa |
| 119195 | hbus monitor | Collected WRITE addr=0x11a9 data=0xaa |
| 119225 | hbus monitor | Collected READ  addr=0x11a9 data=0xaa |
| 119245 | hbus monitor | Collected WRITE addr=0x11aa data=0xaa |
| 119275 | hbus monitor | Collected READ  addr=0x11aa data=0xaa |
| 119295 | hbus monitor | Collected WRITE addr=0x11ab data=0xaa |
| 119325 | hbus monitor | Collected READ  addr=0x11ab data=0xaa |
| 119345 | hbus monitor | Collected WRITE addr=0x11ac data=0xaa |
| 119375 | hbus monitor | Collected READ  addr=0x11ac data=0xaa |
| 119395 | hbus monitor | Collected WRITE addr=0x11ad data=0xaa |
| 119425 | hbus monitor | Collected READ  addr=0x11ad data=0xaa |
| 119445 | hbus monitor | Collected WRITE addr=0x11ae data=0xaa |
| 119475 | hbus monitor | Collected READ  addr=0x11ae data=0xaa |
| 119495 | hbus monitor | Collected WRITE addr=0x11af data=0xaa |
| 119525 | hbus monitor | Collected READ  addr=0x11af data=0xaa |
| 119545 | hbus monitor | Collected WRITE addr=0x11b0 data=0xaa |
| 119575 | hbus monitor | Collected READ  addr=0x11b0 data=0xaa |
| 119595 | hbus monitor | Collected WRITE addr=0x11b1 data=0xaa |
| 119625 | hbus monitor | Collected READ  addr=0x11b1 data=0xaa |
| 119645 | hbus monitor | Collected WRITE addr=0x11b2 data=0xaa |
| 119675 | hbus monitor | Collected READ  addr=0x11b2 data=0xaa |
| 119695 | hbus monitor | Collected WRITE addr=0x11b3 data=0xaa |
| 119725 | hbus monitor | Collected READ  addr=0x11b3 data=0xaa |
| 119745 | hbus monitor | Collected WRITE addr=0x11b4 data=0xaa |
| 119775 | hbus monitor | Collected READ  addr=0x11b4 data=0xaa |
| 119795 | hbus monitor | Collected WRITE addr=0x11b5 data=0xaa |
| 119825 | hbus monitor | Collected READ  addr=0x11b5 data=0xaa |
| 119845 | hbus monitor | Collected WRITE addr=0x11b6 data=0xaa |
| 119875 | hbus monitor | Collected READ  addr=0x11b6 data=0xaa |
| 119895 | hbus monitor | Collected WRITE addr=0x11b7 data=0xaa |
| 119925 | hbus monitor | Collected READ  addr=0x11b7 data=0xaa |
| 119945 | hbus monitor | Collected WRITE addr=0x11b8 data=0xaa |
| 119975 | hbus monitor | Collected READ  addr=0x11b8 data=0xaa |
| 119995 | hbus monitor | Collected WRITE addr=0x11b9 data=0xaa |
| 120025 | hbus monitor | Collected READ  addr=0x11b9 data=0xaa |
| 120045 | hbus monitor | Collected WRITE addr=0x11ba data=0xaa |
| 120075 | hbus monitor | Collected READ  addr=0x11ba data=0xaa |
| 120095 | hbus monitor | Collected WRITE addr=0x11bb data=0xaa |
| 120125 | hbus monitor | Collected READ  addr=0x11bb data=0xaa |
| 120145 | hbus monitor | Collected WRITE addr=0x11bc data=0xaa |
| 120175 | hbus monitor | Collected READ  addr=0x11bc data=0xaa |
| 120195 | hbus monitor | Collected WRITE addr=0x11bd data=0xaa |
| 120225 | hbus monitor | Collected READ  addr=0x11bd data=0xaa |
| 120245 | hbus monitor | Collected WRITE addr=0x11be data=0xaa |
| 120275 | hbus monitor | Collected READ  addr=0x11be data=0xaa |
| 120295 | hbus monitor | Collected WRITE addr=0x11bf data=0xaa |
| 120325 | hbus monitor | Collected READ  addr=0x11bf data=0xaa |
| 120345 | hbus monitor | Collected WRITE addr=0x11c0 data=0xaa |
| 120375 | hbus monitor | Collected READ  addr=0x11c0 data=0xaa |
| 120395 | hbus monitor | Collected WRITE addr=0x11c1 data=0xaa |
| 120425 | hbus monitor | Collected READ  addr=0x11c1 data=0xaa |
| 120445 | hbus monitor | Collected WRITE addr=0x11c2 data=0xaa |
| 120475 | hbus monitor | Collected READ  addr=0x11c2 data=0xaa |
| 120495 | hbus monitor | Collected WRITE addr=0x11c3 data=0xaa |
| 120525 | hbus monitor | Collected READ  addr=0x11c3 data=0xaa |
| 120545 | hbus monitor | Collected WRITE addr=0x11c4 data=0xaa |
| 120575 | hbus monitor | Collected READ  addr=0x11c4 data=0xaa |
| 120595 | hbus monitor | Collected WRITE addr=0x11c5 data=0xaa |
| 120625 | hbus monitor | Collected READ  addr=0x11c5 data=0xaa |
| 120645 | hbus monitor | Collected WRITE addr=0x11c6 data=0xaa |
| 120675 | hbus monitor | Collected READ  addr=0x11c6 data=0xaa |
| 120695 | hbus monitor | Collected WRITE addr=0x11c7 data=0xaa |
| 120725 | hbus monitor | Collected READ  addr=0x11c7 data=0xaa |
| 120745 | hbus monitor | Collected WRITE addr=0x11c8 data=0xaa |
| 120775 | hbus monitor | Collected READ  addr=0x11c8 data=0xaa |
| 120795 | hbus monitor | Collected WRITE addr=0x11c9 data=0xaa |
| 120825 | hbus monitor | Collected READ  addr=0x11c9 data=0xaa |
| 120845 | hbus monitor | Collected WRITE addr=0x11ca data=0xaa |
| 120875 | hbus monitor | Collected READ  addr=0x11ca data=0xaa |
| 120895 | hbus monitor | Collected WRITE addr=0x11cb data=0xaa |
| 120925 | hbus monitor | Collected READ  addr=0x11cb data=0xaa |
| 120945 | hbus monitor | Collected WRITE addr=0x11cc data=0xaa |
| 120975 | hbus monitor | Collected READ  addr=0x11cc data=0xaa |
| 120995 | hbus monitor | Collected WRITE addr=0x11cd data=0xaa |
| 121025 | hbus monitor | Collected READ  addr=0x11cd data=0xaa |
| 121045 | hbus monitor | Collected WRITE addr=0x11ce data=0xaa |
| 121075 | hbus monitor | Collected READ  addr=0x11ce data=0xaa |
| 121095 | hbus monitor | Collected WRITE addr=0x11cf data=0xaa |
| 121125 | hbus monitor | Collected READ  addr=0x11cf data=0xaa |
| 121145 | hbus monitor | Collected WRITE addr=0x11d0 data=0xaa |
| 121175 | hbus monitor | Collected READ  addr=0x11d0 data=0xaa |
| 121195 | hbus monitor | Collected WRITE addr=0x11d1 data=0xaa |
| 121225 | hbus monitor | Collected READ  addr=0x11d1 data=0xaa |
| 121245 | hbus monitor | Collected WRITE addr=0x11d2 data=0xaa |
| 121275 | hbus monitor | Collected READ  addr=0x11d2 data=0xaa |
| 121295 | hbus monitor | Collected WRITE addr=0x11d3 data=0xaa |
| 121325 | hbus monitor | Collected READ  addr=0x11d3 data=0xaa |
| 121345 | hbus monitor | Collected WRITE addr=0x11d4 data=0xaa |
| 121375 | hbus monitor | Collected READ  addr=0x11d4 data=0xaa |
| 121395 | hbus monitor | Collected WRITE addr=0x11d5 data=0xaa |
| 121425 | hbus monitor | Collected READ  addr=0x11d5 data=0xaa |
| 121445 | hbus monitor | Collected WRITE addr=0x11d6 data=0xaa |
| 121475 | hbus monitor | Collected READ  addr=0x11d6 data=0xaa |
| 121495 | hbus monitor | Collected WRITE addr=0x11d7 data=0xaa |
| 121525 | hbus monitor | Collected READ  addr=0x11d7 data=0xaa |
| 121545 | hbus monitor | Collected WRITE addr=0x11d8 data=0xaa |
| 121575 | hbus monitor | Collected READ  addr=0x11d8 data=0xaa |
| 121595 | hbus monitor | Collected WRITE addr=0x11d9 data=0xaa |
| 121625 | hbus monitor | Collected READ  addr=0x11d9 data=0xaa |
| 121645 | hbus monitor | Collected WRITE addr=0x11da data=0xaa |
| 121675 | hbus monitor | Collected READ  addr=0x11da data=0xaa |
| 121695 | hbus monitor | Collected WRITE addr=0x11db data=0xaa |
| 121725 | hbus monitor | Collected READ  addr=0x11db data=0xaa |
| 121745 | hbus monitor | Collected WRITE addr=0x11dc data=0xaa |
| 121775 | hbus monitor | Collected READ  addr=0x11dc data=0xaa |
| 121795 | hbus monitor | Collected WRITE addr=0x11dd data=0xaa |
| 121825 | hbus monitor | Collected READ  addr=0x11dd data=0xaa |
| 121845 | hbus monitor | Collected WRITE addr=0x11de data=0xaa |
| 121875 | hbus monitor | Collected READ  addr=0x11de data=0xaa |
| 121895 | hbus monitor | Collected WRITE addr=0x11df data=0xaa |
| 121925 | hbus monitor | Collected READ  addr=0x11df data=0xaa |
| 121945 | hbus monitor | Collected WRITE addr=0x11e0 data=0xaa |
| 121975 | hbus monitor | Collected READ  addr=0x11e0 data=0xaa |
| 121995 | hbus monitor | Collected WRITE addr=0x11e1 data=0xaa |
| 122025 | hbus monitor | Collected READ  addr=0x11e1 data=0xaa |
| 122045 | hbus monitor | Collected WRITE addr=0x11e2 data=0xaa |
| 122075 | hbus monitor | Collected READ  addr=0x11e2 data=0xaa |
| 122095 | hbus monitor | Collected WRITE addr=0x11e3 data=0xaa |
| 122125 | hbus monitor | Collected READ  addr=0x11e3 data=0xaa |
| 122145 | hbus monitor | Collected WRITE addr=0x11e4 data=0xaa |
| 122175 | hbus monitor | Collected READ  addr=0x11e4 data=0xaa |
| 122195 | hbus monitor | Collected WRITE addr=0x11e5 data=0xaa |
| 122225 | hbus monitor | Collected READ  addr=0x11e5 data=0xaa |
| 122245 | hbus monitor | Collected WRITE addr=0x11e6 data=0xaa |
| 122275 | hbus monitor | Collected READ  addr=0x11e6 data=0xaa |
| 122295 | hbus monitor | Collected WRITE addr=0x11e7 data=0xaa |
| 122325 | hbus monitor | Collected READ  addr=0x11e7 data=0xaa |
| 122345 | hbus monitor | Collected WRITE addr=0x11e8 data=0xaa |
| 122375 | hbus monitor | Collected READ  addr=0x11e8 data=0xaa |
| 122395 | hbus monitor | Collected WRITE addr=0x11e9 data=0xaa |
| 122425 | hbus monitor | Collected READ  addr=0x11e9 data=0xaa |
| 122445 | hbus monitor | Collected WRITE addr=0x11ea data=0xaa |
| 122475 | hbus monitor | Collected READ  addr=0x11ea data=0xaa |
| 122495 | hbus monitor | Collected WRITE addr=0x11eb data=0xaa |
| 122525 | hbus monitor | Collected READ  addr=0x11eb data=0xaa |
| 122545 | hbus monitor | Collected WRITE addr=0x11ec data=0xaa |
| 122575 | hbus monitor | Collected READ  addr=0x11ec data=0xaa |
| 122595 | hbus monitor | Collected WRITE addr=0x11ed data=0xaa |
| 122625 | hbus monitor | Collected READ  addr=0x11ed data=0xaa |
| 122645 | hbus monitor | Collected WRITE addr=0x11ee data=0xaa |
| 122675 | hbus monitor | Collected READ  addr=0x11ee data=0xaa |
| 122695 | hbus monitor | Collected WRITE addr=0x11ef data=0xaa |
| 122725 | hbus monitor | Collected READ  addr=0x11ef data=0xaa |
| 122745 | hbus monitor | Collected WRITE addr=0x11f0 data=0xaa |
| 122775 | hbus monitor | Collected READ  addr=0x11f0 data=0xaa |
| 122795 | hbus monitor | Collected WRITE addr=0x11f1 data=0xaa |
| 122825 | hbus monitor | Collected READ  addr=0x11f1 data=0xaa |
| 122845 | hbus monitor | Collected WRITE addr=0x11f2 data=0xaa |
| 122875 | hbus monitor | Collected READ  addr=0x11f2 data=0xaa |
| 122895 | hbus monitor | Collected WRITE addr=0x11f3 data=0xaa |
| 122925 | hbus monitor | Collected READ  addr=0x11f3 data=0xaa |
| 122945 | hbus monitor | Collected WRITE addr=0x11f4 data=0xaa |
| 122975 | hbus monitor | Collected READ  addr=0x11f4 data=0xaa |
| 122995 | hbus monitor | Collected WRITE addr=0x11f5 data=0xaa |
| 123025 | hbus monitor | Collected READ  addr=0x11f5 data=0xaa |
| 123045 | hbus monitor | Collected WRITE addr=0x11f6 data=0xaa |
| 123075 | hbus monitor | Collected READ  addr=0x11f6 data=0xaa |
| 123095 | hbus monitor | Collected WRITE addr=0x11f7 data=0xaa |
| 123125 | hbus monitor | Collected READ  addr=0x11f7 data=0xaa |
| 123145 | hbus monitor | Collected WRITE addr=0x11f8 data=0xaa |
| 123175 | hbus monitor | Collected READ  addr=0x11f8 data=0xaa |
| 123195 | hbus monitor | Collected WRITE addr=0x11f9 data=0xaa |
| 123225 | hbus monitor | Collected READ  addr=0x11f9 data=0xaa |
| 123245 | hbus monitor | Collected WRITE addr=0x11fa data=0xaa |
| 123275 | hbus monitor | Collected READ  addr=0x11fa data=0xaa |
| 123295 | hbus monitor | Collected WRITE addr=0x11fb data=0xaa |
| 123325 | hbus monitor | Collected READ  addr=0x11fb data=0xaa |
| 123345 | hbus monitor | Collected WRITE addr=0x11fc data=0xaa |
| 123375 | hbus monitor | Collected READ  addr=0x11fc data=0xaa |
| 123395 | hbus monitor | Collected WRITE addr=0x11fd data=0xaa |
| 123425 | hbus monitor | Collected READ  addr=0x11fd data=0xaa |
| 123445 | hbus monitor | Collected WRITE addr=0x11fe data=0xaa |
| 123475 | hbus monitor | Collected READ  addr=0x11fe data=0xaa |
| 123495 | hbus monitor | Collected WRITE addr=0x11ff data=0xaa |
| 123525 | hbus monitor | Collected READ  addr=0x11ff data=0xaa |
| 123545 | hbus monitor | Collected WRITE addr=0x1100 data=0xb2 |
| 123575 | hbus monitor | Collected READ  addr=0x1100 data=0xb2 |
| 123595 | hbus monitor | Collected WRITE addr=0x1101 data=0xd8 |
| 123625 | hbus monitor | Collected READ  addr=0x1101 data=0xd8 |
| 123645 | hbus monitor | Collected WRITE addr=0x1102 data=0x9f |
| 123675 | hbus monitor | Collected READ  addr=0x1102 data=0x9f |
| 123695 | hbus monitor | Collected WRITE addr=0x1103 data=0x97 |
| 123725 | hbus monitor | Collected READ  addr=0x1103 data=0x97 |
| 123745 | hbus monitor | Collected WRITE addr=0x1104 data=0x6a |
| 123775 | hbus monitor | Collected READ  addr=0x1104 data=0x6a |
| 123795 | hbus monitor | Collected WRITE addr=0x1105 data=0x88 |
| 123825 | hbus monitor | Collected READ  addr=0x1105 data=0x88 |
| 123845 | hbus monitor | Collected WRITE addr=0x1106 data=0xc9 |
| 123875 | hbus monitor | Collected READ  addr=0x1106 data=0xc9 |
| 123895 | hbus monitor | Collected WRITE addr=0x1107 data=0xf2 |
| 123925 | hbus monitor | Collected READ  addr=0x1107 data=0xf2 |
| 123945 | hbus monitor | Collected WRITE addr=0x1108 data=0xcb |
| 123975 | hbus monitor | Collected READ  addr=0x1108 data=0xcb |
| 123995 | hbus monitor | Collected WRITE addr=0x1109 data=0xc8 |
| 124025 | hbus monitor | Collected READ  addr=0x1109 data=0xc8 |
| 124045 | hbus monitor | Collected WRITE addr=0x110a data=0x0d |
| 124075 | hbus monitor | Collected READ  addr=0x110a data=0x0d |
| 124095 | hbus monitor | Collected WRITE addr=0x110b data=0x9d |
| 124125 | hbus monitor | Collected READ  addr=0x110b data=0x9d |
| 124145 | hbus monitor | Collected WRITE addr=0x110c data=0x12 |
| 124175 | hbus monitor | Collected READ  addr=0x110c data=0x12 |
| 124195 | hbus monitor | Collected WRITE addr=0x110d data=0xd2 |
| 124225 | hbus monitor | Collected READ  addr=0x110d data=0xd2 |
| 124245 | hbus monitor | Collected WRITE addr=0x110e data=0x12 |
| 124275 | hbus monitor | Collected READ  addr=0x110e data=0x12 |
| 124295 | hbus monitor | Collected WRITE addr=0x110f data=0x76 |
| 124325 | hbus monitor | Collected READ  addr=0x110f data=0x76 |
| 124345 | hbus monitor | Collected WRITE addr=0x1110 data=0xc0 |
| 124375 | hbus monitor | Collected READ  addr=0x1110 data=0xc0 |
| 124395 | hbus monitor | Collected WRITE addr=0x1111 data=0x71 |
| 124425 | hbus monitor | Collected READ  addr=0x1111 data=0x71 |
| 124445 | hbus monitor | Collected WRITE addr=0x1112 data=0x71 |
| 124475 | hbus monitor | Collected READ  addr=0x1112 data=0x71 |
| 124495 | hbus monitor | Collected WRITE addr=0x1113 data=0x42 |
| 124525 | hbus monitor | Collected READ  addr=0x1113 data=0x42 |
| 124545 | hbus monitor | Collected WRITE addr=0x1114 data=0xd3 |
| 124575 | hbus monitor | Collected READ  addr=0x1114 data=0xd3 |
| 124595 | hbus monitor | Collected WRITE addr=0x1115 data=0xa6 |
| 124625 | hbus monitor | Collected READ  addr=0x1115 data=0xa6 |
| 124645 | hbus monitor | Collected WRITE addr=0x1116 data=0x3c |
| 124675 | hbus monitor | Collected READ  addr=0x1116 data=0x3c |
| 124695 | hbus monitor | Collected WRITE addr=0x1117 data=0x15 |
| 124725 | hbus monitor | Collected READ  addr=0x1117 data=0x15 |
| 124745 | hbus monitor | Collected WRITE addr=0x1118 data=0x7a |
| 124775 | hbus monitor | Collected READ  addr=0x1118 data=0x7a |
| 124795 | hbus monitor | Collected WRITE addr=0x1119 data=0xc2 |
| 124825 | hbus monitor | Collected READ  addr=0x1119 data=0xc2 |
| 124845 | hbus monitor | Collected WRITE addr=0x111a data=0x02 |
| 124875 | hbus monitor | Collected READ  addr=0x111a data=0x02 |
| 124895 | hbus monitor | Collected WRITE addr=0x111b data=0xc9 |
| 124925 | hbus monitor | Collected READ  addr=0x111b data=0xc9 |
| 124945 | hbus monitor | Collected WRITE addr=0x111c data=0xb8 |
| 124975 | hbus monitor | Collected READ  addr=0x111c data=0xb8 |
| 124995 | hbus monitor | Collected WRITE addr=0x111d data=0x6f |
| 125025 | hbus monitor | Collected READ  addr=0x111d data=0x6f |
| 125045 | hbus monitor | Collected WRITE addr=0x111e data=0xe7 |
| 125075 | hbus monitor | Collected READ  addr=0x111e data=0xe7 |
| 125095 | hbus monitor | Collected WRITE addr=0x111f data=0x2f |
| 125125 | hbus monitor | Collected READ  addr=0x111f data=0x2f |
| 125145 | hbus monitor | Collected WRITE addr=0x1120 data=0xdb |
| 125175 | hbus monitor | Collected READ  addr=0x1120 data=0xdb |
| 125195 | hbus monitor | Collected WRITE addr=0x1121 data=0x8f |
| 125225 | hbus monitor | Collected READ  addr=0x1121 data=0x8f |
| 125245 | hbus monitor | Collected WRITE addr=0x1122 data=0xdc |
| 125275 | hbus monitor | Collected READ  addr=0x1122 data=0xdc |
| 125295 | hbus monitor | Collected WRITE addr=0x1123 data=0xbe |
| 125325 | hbus monitor | Collected READ  addr=0x1123 data=0xbe |
| 125345 | hbus monitor | Collected WRITE addr=0x1124 data=0x31 |
| 125375 | hbus monitor | Collected READ  addr=0x1124 data=0x31 |
| 125395 | hbus monitor | Collected WRITE addr=0x1125 data=0x6b |
| 125425 | hbus monitor | Collected READ  addr=0x1125 data=0x6b |
| 125445 | hbus monitor | Collected WRITE addr=0x1126 data=0x71 |
| 125475 | hbus monitor | Collected READ  addr=0x1126 data=0x71 |
| 125495 | hbus monitor | Collected WRITE addr=0x1127 data=0x0f |
| 125525 | hbus monitor | Collected READ  addr=0x1127 data=0x0f |
| 125545 | hbus monitor | Collected WRITE addr=0x1128 data=0x3c |
| 125575 | hbus monitor | Collected READ  addr=0x1128 data=0x3c |
| 125595 | hbus monitor | Collected WRITE addr=0x1129 data=0x2e |
| 125625 | hbus monitor | Collected READ  addr=0x1129 data=0x2e |
| 125645 | hbus monitor | Collected WRITE addr=0x112a data=0xbe |
| 125675 | hbus monitor | Collected READ  addr=0x112a data=0xbe |
| 125695 | hbus monitor | Collected WRITE addr=0x112b data=0x85 |
| 125725 | hbus monitor | Collected READ  addr=0x112b data=0x85 |
| 125745 | hbus monitor | Collected WRITE addr=0x112c data=0xc2 |
| 125775 | hbus monitor | Collected READ  addr=0x112c data=0xc2 |
| 125795 | hbus monitor | Collected WRITE addr=0x112d data=0x03 |
| 125825 | hbus monitor | Collected READ  addr=0x112d data=0x03 |
| 125845 | hbus monitor | Collected WRITE addr=0x112e data=0x75 |
| 125875 | hbus monitor | Collected READ  addr=0x112e data=0x75 |
| 125895 | hbus monitor | Collected WRITE addr=0x112f data=0x2d |
| 125925 | hbus monitor | Collected READ  addr=0x112f data=0x2d |
| 125945 | hbus monitor | Collected WRITE addr=0x1130 data=0x17 |
| 125975 | hbus monitor | Collected READ  addr=0x1130 data=0x17 |
| 125995 | hbus monitor | Collected WRITE addr=0x1131 data=0x24 |
| 126025 | hbus monitor | Collected READ  addr=0x1131 data=0x24 |
| 126045 | hbus monitor | Collected WRITE addr=0x1132 data=0x34 |
| 126075 | hbus monitor | Collected READ  addr=0x1132 data=0x34 |
| 126095 | hbus monitor | Collected WRITE addr=0x1133 data=0x0e |
| 126125 | hbus monitor | Collected READ  addr=0x1133 data=0x0e |
| 126145 | hbus monitor | Collected WRITE addr=0x1134 data=0x75 |
| 126175 | hbus monitor | Collected READ  addr=0x1134 data=0x75 |
| 126195 | hbus monitor | Collected WRITE addr=0x1135 data=0xc8 |
| 126225 | hbus monitor | Collected READ  addr=0x1135 data=0xc8 |
| 126245 | hbus monitor | Collected WRITE addr=0x1136 data=0x53 |
| 126275 | hbus monitor | Collected READ  addr=0x1136 data=0x53 |
| 126295 | hbus monitor | Collected WRITE addr=0x1137 data=0x7c |
| 126325 | hbus monitor | Collected READ  addr=0x1137 data=0x7c |
| 126345 | hbus monitor | Collected WRITE addr=0x1138 data=0x04 |
| 126375 | hbus monitor | Collected READ  addr=0x1138 data=0x04 |
| 126395 | hbus monitor | Collected WRITE addr=0x1139 data=0xc5 |
| 126425 | hbus monitor | Collected READ  addr=0x1139 data=0xc5 |
| 126445 | hbus monitor | Collected WRITE addr=0x113a data=0xc8 |
| 126475 | hbus monitor | Collected READ  addr=0x113a data=0xc8 |
| 126495 | hbus monitor | Collected WRITE addr=0x113b data=0x8f |
| 126525 | hbus monitor | Collected READ  addr=0x113b data=0x8f |
| 126545 | hbus monitor | Collected WRITE addr=0x113c data=0x3c |
| 126575 | hbus monitor | Collected READ  addr=0x113c data=0x3c |
| 126595 | hbus monitor | Collected WRITE addr=0x113d data=0x77 |
| 126625 | hbus monitor | Collected READ  addr=0x113d data=0x77 |
| 126645 | hbus monitor | Collected WRITE addr=0x113e data=0x1e |
| 126675 | hbus monitor | Collected READ  addr=0x113e data=0x1e |
| 126695 | hbus monitor | Collected WRITE addr=0x113f data=0x29 |
| 126725 | hbus monitor | Collected READ  addr=0x113f data=0x29 |
| 126745 | hbus monitor | Collected WRITE addr=0x1140 data=0x38 |
| 126775 | hbus monitor | Collected READ  addr=0x1140 data=0x38 |
| 126795 | hbus monitor | Collected WRITE addr=0x1141 data=0xe4 |
| 126825 | hbus monitor | Collected READ  addr=0x1141 data=0xe4 |
| 126845 | hbus monitor | Collected WRITE addr=0x1142 data=0x26 |
| 126875 | hbus monitor | Collected READ  addr=0x1142 data=0x26 |
| 126895 | hbus monitor | Collected WRITE addr=0x1143 data=0x8a |
| 126925 | hbus monitor | Collected READ  addr=0x1143 data=0x8a |
| 126945 | hbus monitor | Collected WRITE addr=0x1144 data=0x37 |
| 126975 | hbus monitor | Collected READ  addr=0x1144 data=0x37 |
| 126995 | hbus monitor | Collected WRITE addr=0x1145 data=0xc6 |
| 127025 | hbus monitor | Collected READ  addr=0x1145 data=0xc6 |
| 127045 | hbus monitor | Collected WRITE addr=0x1146 data=0x61 |
| 127075 | hbus monitor | Collected READ  addr=0x1146 data=0x61 |
| 127095 | hbus monitor | Collected WRITE addr=0x1147 data=0xdb |
| 127125 | hbus monitor | Collected READ  addr=0x1147 data=0xdb |
| 127145 | hbus monitor | Collected WRITE addr=0x1148 data=0xc0 |
| 127175 | hbus monitor | Collected READ  addr=0x1148 data=0xc0 |
| 127195 | hbus monitor | Collected WRITE addr=0x1149 data=0x56 |
| 127225 | hbus monitor | Collected READ  addr=0x1149 data=0x56 |
| 127245 | hbus monitor | Collected WRITE addr=0x114a data=0x8b |
| 127275 | hbus monitor | Collected READ  addr=0x114a data=0x8b |
| 127295 | hbus monitor | Collected WRITE addr=0x114b data=0xea |
| 127325 | hbus monitor | Collected READ  addr=0x114b data=0xea |
| 127345 | hbus monitor | Collected WRITE addr=0x114c data=0x23 |
| 127375 | hbus monitor | Collected READ  addr=0x114c data=0x23 |
| 127395 | hbus monitor | Collected WRITE addr=0x114d data=0x8d |
| 127425 | hbus monitor | Collected READ  addr=0x114d data=0x8d |
| 127445 | hbus monitor | Collected WRITE addr=0x114e data=0xcd |
| 127475 | hbus monitor | Collected READ  addr=0x114e data=0xcd |
| 127495 | hbus monitor | Collected WRITE addr=0x114f data=0x38 |
| 127525 | hbus monitor | Collected READ  addr=0x114f data=0x38 |
| 127545 | hbus monitor | Collected WRITE addr=0x1150 data=0xcb |
| 127575 | hbus monitor | Collected READ  addr=0x1150 data=0xcb |
| 127595 | hbus monitor | Collected WRITE addr=0x1151 data=0xe3 |
| 127625 | hbus monitor | Collected READ  addr=0x1151 data=0xe3 |
| 127645 | hbus monitor | Collected WRITE addr=0x1152 data=0x94 |
| 127675 | hbus monitor | Collected READ  addr=0x1152 data=0x94 |
| 127695 | hbus monitor | Collected WRITE addr=0x1153 data=0xe9 |
| 127725 | hbus monitor | Collected READ  addr=0x1153 data=0xe9 |
| 127745 | hbus monitor | Collected WRITE addr=0x1154 data=0x54 |
| 127775 | hbus monitor | Collected READ  addr=0x1154 data=0x54 |
| 127795 | hbus monitor | Collected WRITE addr=0x1155 data=0xa7 |
| 127825 | hbus monitor | Collected READ  addr=0x1155 data=0xa7 |
| 127845 | hbus monitor | Collected WRITE addr=0x1156 data=0xe2 |
| 127875 | hbus monitor | Collected READ  addr=0x1156 data=0xe2 |
| 127895 | hbus monitor | Collected WRITE addr=0x1157 data=0xbe |
| 127925 | hbus monitor | Collected READ  addr=0x1157 data=0xbe |
| 127945 | hbus monitor | Collected WRITE addr=0x1158 data=0x27 |
| 127975 | hbus monitor | Collected READ  addr=0x1158 data=0x27 |
| 127995 | hbus monitor | Collected WRITE addr=0x1159 data=0xa1 |
| 128025 | hbus monitor | Collected READ  addr=0x1159 data=0xa1 |
| 128045 | hbus monitor | Collected WRITE addr=0x115a data=0x28 |
| 128075 | hbus monitor | Collected READ  addr=0x115a data=0x28 |
| 128095 | hbus monitor | Collected WRITE addr=0x115b data=0x14 |
| 128125 | hbus monitor | Collected READ  addr=0x115b data=0x14 |
| 128145 | hbus monitor | Collected WRITE addr=0x115c data=0xcb |
| 128175 | hbus monitor | Collected READ  addr=0x115c data=0xcb |
| 128195 | hbus monitor | Collected WRITE addr=0x115d data=0x91 |
| 128225 | hbus monitor | Collected READ  addr=0x115d data=0x91 |
| 128245 | hbus monitor | Collected WRITE addr=0x115e data=0x67 |
| 128275 | hbus monitor | Collected READ  addr=0x115e data=0x67 |
| 128295 | hbus monitor | Collected WRITE addr=0x115f data=0x2a |
| 128325 | hbus monitor | Collected READ  addr=0x115f data=0x2a |
| 128345 | hbus monitor | Collected WRITE addr=0x1160 data=0xe6 |
| 128375 | hbus monitor | Collected READ  addr=0x1160 data=0xe6 |
| 128395 | hbus monitor | Collected WRITE addr=0x1161 data=0x09 |
| 128425 | hbus monitor | Collected READ  addr=0x1161 data=0x09 |
| 128445 | hbus monitor | Collected WRITE addr=0x1162 data=0xac |
| 128475 | hbus monitor | Collected READ  addr=0x1162 data=0xac |
| 128495 | hbus monitor | Collected WRITE addr=0x1163 data=0xac |
| 128525 | hbus monitor | Collected READ  addr=0x1163 data=0xac |
| 128545 | hbus monitor | Collected WRITE addr=0x1164 data=0x7e |
| 128575 | hbus monitor | Collected READ  addr=0x1164 data=0x7e |
| 128595 | hbus monitor | Collected WRITE addr=0x1165 data=0xa8 |
| 128625 | hbus monitor | Collected READ  addr=0x1165 data=0xa8 |
| 128645 | hbus monitor | Collected WRITE addr=0x1166 data=0x04 |
| 128675 | hbus monitor | Collected READ  addr=0x1166 data=0x04 |
| 128695 | hbus monitor | Collected WRITE addr=0x1167 data=0x3b |
| 128725 | hbus monitor | Collected READ  addr=0x1167 data=0x3b |
| 128745 | hbus monitor | Collected WRITE addr=0x1168 data=0xe0 |
| 128775 | hbus monitor | Collected READ  addr=0x1168 data=0xe0 |
| 128795 | hbus monitor | Collected WRITE addr=0x1169 data=0xf6 |
| 128825 | hbus monitor | Collected READ  addr=0x1169 data=0xf6 |
| 128845 | hbus monitor | Collected WRITE addr=0x116a data=0xc7 |
| 128875 | hbus monitor | Collected READ  addr=0x116a data=0xc7 |
| 128895 | hbus monitor | Collected WRITE addr=0x116b data=0x69 |
| 128925 | hbus monitor | Collected READ  addr=0x116b data=0x69 |
| 128945 | hbus monitor | Collected WRITE addr=0x116c data=0xc9 |
| 128975 | hbus monitor | Collected READ  addr=0x116c data=0xc9 |
| 128995 | hbus monitor | Collected WRITE addr=0x116d data=0x5c |
| 129025 | hbus monitor | Collected READ  addr=0x116d data=0x5c |
| 129045 | hbus monitor | Collected WRITE addr=0x116e data=0xc9 |
| 129075 | hbus monitor | Collected READ  addr=0x116e data=0xc9 |
| 129095 | hbus monitor | Collected WRITE addr=0x116f data=0x87 |
| 129125 | hbus monitor | Collected READ  addr=0x116f data=0x87 |
| 129145 | hbus monitor | Collected WRITE addr=0x1170 data=0x91 |
| 129175 | hbus monitor | Collected READ  addr=0x1170 data=0x91 |
| 129195 | hbus monitor | Collected WRITE addr=0x1171 data=0x51 |
| 129225 | hbus monitor | Collected READ  addr=0x1171 data=0x51 |
| 129245 | hbus monitor | Collected WRITE addr=0x1172 data=0x91 |
| 129275 | hbus monitor | Collected READ  addr=0x1172 data=0x91 |
| 129295 | hbus monitor | Collected WRITE addr=0x1173 data=0xfb |
| 129325 | hbus monitor | Collected READ  addr=0x1173 data=0xfb |
| 129345 | hbus monitor | Collected WRITE addr=0x1174 data=0x5c |
| 129375 | hbus monitor | Collected READ  addr=0x1174 data=0x5c |
| 129395 | hbus monitor | Collected WRITE addr=0x1175 data=0x38 |
| 129425 | hbus monitor | Collected READ  addr=0x1175 data=0x38 |
| 129445 | hbus monitor | Collected WRITE addr=0x1176 data=0xef |
| 129475 | hbus monitor | Collected READ  addr=0x1176 data=0xef |
| 129495 | hbus monitor | Collected WRITE addr=0x1177 data=0x15 |
| 129525 | hbus monitor | Collected READ  addr=0x1177 data=0x15 |
| 129545 | hbus monitor | Collected WRITE addr=0x1178 data=0xa6 |
| 129575 | hbus monitor | Collected READ  addr=0x1178 data=0xa6 |
| 129595 | hbus monitor | Collected WRITE addr=0x1179 data=0x72 |
| 129625 | hbus monitor | Collected READ  addr=0x1179 data=0x72 |
| 129645 | hbus monitor | Collected WRITE addr=0x117a data=0x09 |
| 129675 | hbus monitor | Collected READ  addr=0x117a data=0x09 |
| 129695 | hbus monitor | Collected WRITE addr=0x117b data=0xdf |
| 129725 | hbus monitor | Collected READ  addr=0x117b data=0xdf |
| 129745 | hbus monitor | Collected WRITE addr=0x117c data=0x61 |
| 129775 | hbus monitor | Collected READ  addr=0x117c data=0x61 |
| 129795 | hbus monitor | Collected WRITE addr=0x117d data=0x0b |
| 129825 | hbus monitor | Collected READ  addr=0x117d data=0x0b |
| 129845 | hbus monitor | Collected WRITE addr=0x117e data=0x28 |
| 129875 | hbus monitor | Collected READ  addr=0x117e data=0x28 |
| 129895 | hbus monitor | Collected WRITE addr=0x117f data=0x15 |
| 129925 | hbus monitor | Collected READ  addr=0x117f data=0x15 |
| 129945 | hbus monitor | Collected WRITE addr=0x1180 data=0x2d |
| 129975 | hbus monitor | Collected READ  addr=0x1180 data=0x2d |
| 129995 | hbus monitor | Collected WRITE addr=0x1181 data=0x84 |
| 130025 | hbus monitor | Collected READ  addr=0x1181 data=0x84 |
| 130045 | hbus monitor | Collected WRITE addr=0x1182 data=0x60 |
| 130075 | hbus monitor | Collected READ  addr=0x1182 data=0x60 |
| 130095 | hbus monitor | Collected WRITE addr=0x1183 data=0x3a |
| 130125 | hbus monitor | Collected READ  addr=0x1183 data=0x3a |
| 130145 | hbus monitor | Collected WRITE addr=0x1184 data=0x01 |
| 130175 | hbus monitor | Collected READ  addr=0x1184 data=0x01 |
| 130195 | hbus monitor | Collected WRITE addr=0x1185 data=0x88 |
| 130225 | hbus monitor | Collected READ  addr=0x1185 data=0x88 |
| 130245 | hbus monitor | Collected WRITE addr=0x1186 data=0x20 |
| 130275 | hbus monitor | Collected READ  addr=0x1186 data=0x20 |
| 130295 | hbus monitor | Collected WRITE addr=0x1187 data=0x9a |
| 130325 | hbus monitor | Collected READ  addr=0x1187 data=0x9a |
| 130345 | hbus monitor | Collected WRITE addr=0x1188 data=0xca |
| 130375 | hbus monitor | Collected READ  addr=0x1188 data=0xca |
| 130395 | hbus monitor | Collected WRITE addr=0x1189 data=0x9a |
| 130425 | hbus monitor | Collected READ  addr=0x1189 data=0x9a |
| 130445 | hbus monitor | Collected WRITE addr=0x118a data=0x8e |
| 130475 | hbus monitor | Collected READ  addr=0x118a data=0x8e |
| 130495 | hbus monitor | Collected WRITE addr=0x118b data=0x3a |
| 130525 | hbus monitor | Collected READ  addr=0x118b data=0x3a |
| 130545 | hbus monitor | Collected WRITE addr=0x118c data=0x26 |
| 130575 | hbus monitor | Collected READ  addr=0x118c data=0x26 |
| 130595 | hbus monitor | Collected WRITE addr=0x118d data=0x7e |
| 130625 | hbus monitor | Collected READ  addr=0x118d data=0x7e |
| 130645 | hbus monitor | Collected WRITE addr=0x118e data=0xe4 |
| 130675 | hbus monitor | Collected READ  addr=0x118e data=0xe4 |
| 130695 | hbus monitor | Collected WRITE addr=0x118f data=0x92 |
| 130725 | hbus monitor | Collected READ  addr=0x118f data=0x92 |
| 130745 | hbus monitor | Collected WRITE addr=0x1190 data=0xef |
| 130775 | hbus monitor | Collected READ  addr=0x1190 data=0xef |
| 130795 | hbus monitor | Collected WRITE addr=0x1191 data=0xcb |
| 130825 | hbus monitor | Collected READ  addr=0x1191 data=0xcb |
| 130845 | hbus monitor | Collected WRITE addr=0x1192 data=0xf2 |
| 130875 | hbus monitor | Collected READ  addr=0x1192 data=0xf2 |
| 130895 | hbus monitor | Collected WRITE addr=0x1193 data=0xbd |
| 130925 | hbus monitor | Collected READ  addr=0x1193 data=0xbd |
| 130945 | hbus monitor | Collected WRITE addr=0x1194 data=0xc5 |
| 130975 | hbus monitor | Collected READ  addr=0x1194 data=0xc5 |
| 130995 | hbus monitor | Collected WRITE addr=0x1195 data=0x37 |
| 131025 | hbus monitor | Collected READ  addr=0x1195 data=0x37 |
| 131045 | hbus monitor | Collected WRITE addr=0x1196 data=0xcf |
| 131075 | hbus monitor | Collected READ  addr=0x1196 data=0xcf |
| 131095 | hbus monitor | Collected WRITE addr=0x1197 data=0x80 |
| 131125 | hbus monitor | Collected READ  addr=0x1197 data=0x80 |
| 131145 | hbus monitor | Collected WRITE addr=0x1198 data=0xf6 |
| 131175 | hbus monitor | Collected READ  addr=0x1198 data=0xf6 |
| 131195 | hbus monitor | Collected WRITE addr=0x1199 data=0x25 |
| 131225 | hbus monitor | Collected READ  addr=0x1199 data=0x25 |
| 131245 | hbus monitor | Collected WRITE addr=0x119a data=0x69 |
| 131275 | hbus monitor | Collected READ  addr=0x119a data=0x69 |
| 131295 | hbus monitor | Collected WRITE addr=0x119b data=0x69 |
| 131325 | hbus monitor | Collected READ  addr=0x119b data=0x69 |
| 131345 | hbus monitor | Collected WRITE addr=0x119c data=0xdc |
| 131375 | hbus monitor | Collected READ  addr=0x119c data=0xdc |
| 131395 | hbus monitor | Collected WRITE addr=0x119d data=0xf5 |
| 131425 | hbus monitor | Collected READ  addr=0x119d data=0xf5 |
| 131445 | hbus monitor | Collected WRITE addr=0x119e data=0x7d |
| 131475 | hbus monitor | Collected READ  addr=0x119e data=0x7d |
| 131495 | hbus monitor | Collected WRITE addr=0x119f data=0x1c |
| 131525 | hbus monitor | Collected READ  addr=0x119f data=0x1c |
| 131545 | hbus monitor | Collected WRITE addr=0x11a0 data=0xb7 |
| 131575 | hbus monitor | Collected READ  addr=0x11a0 data=0xb7 |
| 131595 | hbus monitor | Collected WRITE addr=0x11a1 data=0xe3 |
| 131625 | hbus monitor | Collected READ  addr=0x11a1 data=0xe3 |
| 131645 | hbus monitor | Collected WRITE addr=0x11a2 data=0x67 |
| 131675 | hbus monitor | Collected READ  addr=0x11a2 data=0x67 |
| 131695 | hbus monitor | Collected WRITE addr=0x11a3 data=0x16 |
| 131725 | hbus monitor | Collected READ  addr=0x11a3 data=0x16 |
| 131745 | hbus monitor | Collected WRITE addr=0x11a4 data=0xc5 |
| 131775 | hbus monitor | Collected READ  addr=0x11a4 data=0xc5 |
| 131795 | hbus monitor | Collected WRITE addr=0x11a5 data=0x3f |
| 131825 | hbus monitor | Collected READ  addr=0x11a5 data=0x3f |
| 131845 | hbus monitor | Collected WRITE addr=0x11a6 data=0x46 |
| 131875 | hbus monitor | Collected READ  addr=0x11a6 data=0x46 |
| 131895 | hbus monitor | Collected WRITE addr=0x11a7 data=0xce |
| 131925 | hbus monitor | Collected READ  addr=0x11a7 data=0xce |
| 131945 | hbus monitor | Collected WRITE addr=0x11a8 data=0xda |
| 131975 | hbus monitor | Collected READ  addr=0x11a8 data=0xda |
| 131995 | hbus monitor | Collected WRITE addr=0x11a9 data=0x94 |
| 132025 | hbus monitor | Collected READ  addr=0x11a9 data=0x94 |
| 132045 | hbus monitor | Collected WRITE addr=0x11aa data=0xe6 |
| 132075 | hbus monitor | Collected READ  addr=0x11aa data=0xe6 |
| 132095 | hbus monitor | Collected WRITE addr=0x11ab data=0x6b |
| 132125 | hbus monitor | Collected READ  addr=0x11ab data=0x6b |
| 132145 | hbus monitor | Collected WRITE addr=0x11ac data=0x50 |
| 132175 | hbus monitor | Collected READ  addr=0x11ac data=0x50 |
| 132195 | hbus monitor | Collected WRITE addr=0x11ad data=0x01 |
| 132225 | hbus monitor | Collected READ  addr=0x11ad data=0x01 |
| 132245 | hbus monitor | Collected WRITE addr=0x11ae data=0x36 |
| 132275 | hbus monitor | Collected READ  addr=0x11ae data=0x36 |
| 132295 | hbus monitor | Collected WRITE addr=0x11af data=0x56 |
| 132325 | hbus monitor | Collected READ  addr=0x11af data=0x56 |
| 132345 | hbus monitor | Collected WRITE addr=0x11b0 data=0xe7 |
| 132375 | hbus monitor | Collected READ  addr=0x11b0 data=0xe7 |
| 132395 | hbus monitor | Collected WRITE addr=0x11b1 data=0x2c |
| 132425 | hbus monitor | Collected READ  addr=0x11b1 data=0x2c |
| 132445 | hbus monitor | Collected WRITE addr=0x11b2 data=0xd8 |
| 132475 | hbus monitor | Collected READ  addr=0x11b2 data=0xd8 |
| 132495 | hbus monitor | Collected WRITE addr=0x11b3 data=0x01 |
| 132525 | hbus monitor | Collected READ  addr=0x11b3 data=0x01 |
| 132545 | hbus monitor | Collected WRITE addr=0x11b4 data=0x24 |
| 132575 | hbus monitor | Collected READ  addr=0x11b4 data=0x24 |
| 132595 | hbus monitor | Collected WRITE addr=0x11b5 data=0x51 |
| 132625 | hbus monitor | Collected READ  addr=0x11b5 data=0x51 |
| 132645 | hbus monitor | Collected WRITE addr=0x11b6 data=0x7a |
| 132675 | hbus monitor | Collected READ  addr=0x11b6 data=0x7a |
| 132695 | hbus monitor | Collected WRITE addr=0x11b7 data=0x82 |
| 132725 | hbus monitor | Collected READ  addr=0x11b7 data=0x82 |
| 132745 | hbus monitor | Collected WRITE addr=0x11b8 data=0xd5 |
| 132775 | hbus monitor | Collected READ  addr=0x11b8 data=0xd5 |
| 132795 | hbus monitor | Collected WRITE addr=0x11b9 data=0x30 |
| 132825 | hbus monitor | Collected READ  addr=0x11b9 data=0x30 |
| 132845 | hbus monitor | Collected WRITE addr=0x11ba data=0x24 |
| 132875 | hbus monitor | Collected READ  addr=0x11ba data=0x24 |
| 132895 | hbus monitor | Collected WRITE addr=0x11bb data=0x9d |
| 132925 | hbus monitor | Collected READ  addr=0x11bb data=0x9d |
| 132945 | hbus monitor | Collected WRITE addr=0x11bc data=0xbb |
| 132975 | hbus monitor | Collected READ  addr=0x11bc data=0xbb |
| 132995 | hbus monitor | Collected WRITE addr=0x11bd data=0x80 |
| 133025 | hbus monitor | Collected READ  addr=0x11bd data=0x80 |
| 133045 | hbus monitor | Collected WRITE addr=0x11be data=0x21 |
| 133075 | hbus monitor | Collected READ  addr=0x11be data=0x21 |
| 133095 | hbus monitor | Collected WRITE addr=0x11bf data=0xe1 |
| 133125 | hbus monitor | Collected READ  addr=0x11bf data=0xe1 |
| 133145 | hbus monitor | Collected WRITE addr=0x11c0 data=0x2d |
| 133175 | hbus monitor | Collected READ  addr=0x11c0 data=0x2d |
| 133195 | hbus monitor | Collected WRITE addr=0x11c1 data=0xda |
| 133225 | hbus monitor | Collected READ  addr=0x11c1 data=0xda |
| 133245 | hbus monitor | Collected WRITE addr=0x11c2 data=0x9f |
| 133275 | hbus monitor | Collected READ  addr=0x11c2 data=0x9f |
| 133295 | hbus monitor | Collected WRITE addr=0x11c3 data=0x5b |
| 133325 | hbus monitor | Collected READ  addr=0x11c3 data=0x5b |
| 133345 | hbus monitor | Collected WRITE addr=0x11c4 data=0x99 |
| 133375 | hbus monitor | Collected READ  addr=0x11c4 data=0x99 |
| 133395 | hbus monitor | Collected WRITE addr=0x11c5 data=0x6c |
| 133425 | hbus monitor | Collected READ  addr=0x11c5 data=0x6c |
| 133445 | hbus monitor | Collected WRITE addr=0x11c6 data=0xd4 |
| 133475 | hbus monitor | Collected READ  addr=0x11c6 data=0xd4 |
| 133495 | hbus monitor | Collected WRITE addr=0x11c7 data=0xca |
| 133525 | hbus monitor | Collected READ  addr=0x11c7 data=0xca |
| 133545 | hbus monitor | Collected WRITE addr=0x11c8 data=0x36 |
| 133575 | hbus monitor | Collected READ  addr=0x11c8 data=0x36 |
| 133595 | hbus monitor | Collected WRITE addr=0x11c9 data=0xa1 |
| 133625 | hbus monitor | Collected READ  addr=0x11c9 data=0xa1 |
| 133645 | hbus monitor | Collected WRITE addr=0x11ca data=0x05 |
| 133675 | hbus monitor | Collected READ  addr=0x11ca data=0x05 |
| 133695 | hbus monitor | Collected WRITE addr=0x11cb data=0x9f |
| 133725 | hbus monitor | Collected READ  addr=0x11cb data=0x9f |
| 133745 | hbus monitor | Collected WRITE addr=0x11cc data=0xe3 |
| 133775 | hbus monitor | Collected READ  addr=0x11cc data=0xe3 |
| 133795 | hbus monitor | Collected WRITE addr=0x11cd data=0x32 |
| 133825 | hbus monitor | Collected READ  addr=0x11cd data=0x32 |
| 133845 | hbus monitor | Collected WRITE addr=0x11ce data=0x49 |
| 133875 | hbus monitor | Collected READ  addr=0x11ce data=0x49 |
| 133895 | hbus monitor | Collected WRITE addr=0x11cf data=0xb9 |
| 133925 | hbus monitor | Collected READ  addr=0x11cf data=0xb9 |
| 133945 | hbus monitor | Collected WRITE addr=0x11d0 data=0x8c |
| 133975 | hbus monitor | Collected READ  addr=0x11d0 data=0x8c |
| 133995 | hbus monitor | Collected WRITE addr=0x11d1 data=0x42 |
| 134025 | hbus monitor | Collected READ  addr=0x11d1 data=0x42 |
| 134045 | hbus monitor | Collected WRITE addr=0x11d2 data=0x99 |
| 134075 | hbus monitor | Collected READ  addr=0x11d2 data=0x99 |
| 134095 | hbus monitor | Collected WRITE addr=0x11d3 data=0x95 |
| 134125 | hbus monitor | Collected READ  addr=0x11d3 data=0x95 |
| 134145 | hbus monitor | Collected WRITE addr=0x11d4 data=0xc7 |
| 134175 | hbus monitor | Collected READ  addr=0x11d4 data=0xc7 |
| 134195 | hbus monitor | Collected WRITE addr=0x11d5 data=0xc9 |
| 134225 | hbus monitor | Collected READ  addr=0x11d5 data=0xc9 |
| 134245 | hbus monitor | Collected WRITE addr=0x11d6 data=0x47 |
| 134275 | hbus monitor | Collected READ  addr=0x11d6 data=0x47 |
| 134295 | hbus monitor | Collected WRITE addr=0x11d7 data=0x01 |
| 134325 | hbus monitor | Collected READ  addr=0x11d7 data=0x01 |
| 134345 | hbus monitor | Collected WRITE addr=0x11d8 data=0x4f |
| 134375 | hbus monitor | Collected READ  addr=0x11d8 data=0x4f |
| 134395 | hbus monitor | Collected WRITE addr=0x11d9 data=0xab |
| 134425 | hbus monitor | Collected READ  addr=0x11d9 data=0xab |
| 134445 | hbus monitor | Collected WRITE addr=0x11da data=0xa4 |
| 134475 | hbus monitor | Collected READ  addr=0x11da data=0xa4 |
| 134495 | hbus monitor | Collected WRITE addr=0x11db data=0x6d |
| 134525 | hbus monitor | Collected READ  addr=0x11db data=0x6d |
| 134545 | hbus monitor | Collected WRITE addr=0x11dc data=0x57 |
| 134575 | hbus monitor | Collected READ  addr=0x11dc data=0x57 |
| 134595 | hbus monitor | Collected WRITE addr=0x11dd data=0x4d |
| 134625 | hbus monitor | Collected READ  addr=0x11dd data=0x4d |
| 134645 | hbus monitor | Collected WRITE addr=0x11de data=0xd6 |
| 134675 | hbus monitor | Collected READ  addr=0x11de data=0xd6 |
| 134695 | hbus monitor | Collected WRITE addr=0x11df data=0x56 |
| 134725 | hbus monitor | Collected READ  addr=0x11df data=0x56 |
| 134745 | hbus monitor | Collected WRITE addr=0x11e0 data=0xf5 |
| 134775 | hbus monitor | Collected READ  addr=0x11e0 data=0xf5 |
| 134795 | hbus monitor | Collected WRITE addr=0x11e1 data=0xaa |
| 134825 | hbus monitor | Collected READ  addr=0x11e1 data=0xaa |
| 134845 | hbus monitor | Collected WRITE addr=0x11e2 data=0xf1 |
| 134875 | hbus monitor | Collected READ  addr=0x11e2 data=0xf1 |
| 134895 | hbus monitor | Collected WRITE addr=0x11e3 data=0x6d |
| 134925 | hbus monitor | Collected READ  addr=0x11e3 data=0x6d |
| 134945 | hbus monitor | Collected WRITE addr=0x11e4 data=0xd6 |
| 134975 | hbus monitor | Collected READ  addr=0x11e4 data=0xd6 |
| 134995 | hbus monitor | Collected WRITE addr=0x11e5 data=0xe0 |
| 135025 | hbus monitor | Collected READ  addr=0x11e5 data=0xe0 |
| 135045 | hbus monitor | Collected WRITE addr=0x11e6 data=0x7c |
| 135075 | hbus monitor | Collected READ  addr=0x11e6 data=0x7c |
| 135095 | hbus monitor | Collected WRITE addr=0x11e7 data=0xe7 |
| 135125 | hbus monitor | Collected READ  addr=0x11e7 data=0xe7 |
| 135145 | hbus monitor | Collected WRITE addr=0x11e8 data=0xfe |
| 135175 | hbus monitor | Collected READ  addr=0x11e8 data=0xfe |
| 135195 | hbus monitor | Collected WRITE addr=0x11e9 data=0x05 |
| 135225 | hbus monitor | Collected READ  addr=0x11e9 data=0x05 |
| 135245 | hbus monitor | Collected WRITE addr=0x11ea data=0xac |
| 135275 | hbus monitor | Collected READ  addr=0x11ea data=0xac |
| 135295 | hbus monitor | Collected WRITE addr=0x11eb data=0x45 |
| 135325 | hbus monitor | Collected READ  addr=0x11eb data=0x45 |
| 135345 | hbus monitor | Collected WRITE addr=0x11ec data=0x5d |
| 135375 | hbus monitor | Collected READ  addr=0x11ec data=0x5d |
| 135395 | hbus monitor | Collected WRITE addr=0x11ed data=0xa7 |
| 135425 | hbus monitor | Collected READ  addr=0x11ed data=0xa7 |
| 135445 | hbus monitor | Collected WRITE addr=0x11ee data=0xab |
| 135475 | hbus monitor | Collected READ  addr=0x11ee data=0xab |
| 135495 | hbus monitor | Collected WRITE addr=0x11ef data=0x0a |
| 135525 | hbus monitor | Collected READ  addr=0x11ef data=0x0a |
| 135545 | hbus monitor | Collected WRITE addr=0x11f0 data=0xcb |
| 135575 | hbus monitor | Collected READ  addr=0x11f0 data=0xcb |
| 135595 | hbus monitor | Collected WRITE addr=0x11f1 data=0x2d |
| 135625 | hbus monitor | Collected READ  addr=0x11f1 data=0x2d |
| 135645 | hbus monitor | Collected WRITE addr=0x11f2 data=0x74 |
| 135675 | hbus monitor | Collected READ  addr=0x11f2 data=0x74 |
| 135695 | hbus monitor | Collected WRITE addr=0x11f3 data=0x23 |
| 135725 | hbus monitor | Collected READ  addr=0x11f3 data=0x23 |
| 135745 | hbus monitor | Collected WRITE addr=0x11f4 data=0xfd |
| 135775 | hbus monitor | Collected READ  addr=0x11f4 data=0xfd |
| 135795 | hbus monitor | Collected WRITE addr=0x11f5 data=0x32 |
| 135825 | hbus monitor | Collected READ  addr=0x11f5 data=0x32 |
| 135845 | hbus monitor | Collected WRITE addr=0x11f6 data=0xfa |
| 135875 | hbus monitor | Collected READ  addr=0x11f6 data=0xfa |
| 135895 | hbus monitor | Collected WRITE addr=0x11f7 data=0x12 |
| 135925 | hbus monitor | Collected READ  addr=0x11f7 data=0x12 |
| 135945 | hbus monitor | Collected WRITE addr=0x11f8 data=0x3b |
| 135975 | hbus monitor | Collected READ  addr=0x11f8 data=0x3b |
| 135995 | hbus monitor | Collected WRITE addr=0x11f9 data=0xd8 |
| 136025 | hbus monitor | Collected READ  addr=0x11f9 data=0xd8 |
| 136045 | hbus monitor | Collected WRITE addr=0x11fa data=0x1c |
| 136075 | hbus monitor | Collected READ  addr=0x11fa data=0x1c |
| 136095 | hbus monitor | Collected WRITE addr=0x11fb data=0x40 |
| 136125 | hbus monitor | Collected READ  addr=0x11fb data=0x40 |
| 136145 | hbus monitor | Collected WRITE addr=0x11fc data=0x89 |
| 136175 | hbus monitor | Collected READ  addr=0x11fc data=0x89 |
| 136195 | hbus monitor | Collected WRITE addr=0x11fd data=0xdd |
| 136225 | hbus monitor | Collected READ  addr=0x11fd data=0xdd |
| 136245 | hbus monitor | Collected WRITE addr=0x11fe data=0xc9 |
| 136275 | hbus monitor | Collected READ  addr=0x11fe data=0xc9 |
| 136295 | hbus monitor | Collected WRITE addr=0x11ff data=0x87 |
| 136320 | **test** | STAGE: 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136325 | hbus monitor | Collected READ  addr=0x11ff data=0x87 |
| 136345 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 136345 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 136345 | reference | maxpktsize is now 1 |
| 136375 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 136405 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 136435 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 136465 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 136495 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 136520 | **test** | STAGE: 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 136525 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 136545 | hbus monitor | Collected WRITE addr=0x1001 data=0x17 |
| 136545 | reference | router_en is now 1 (en_reg 0x17) |
| 136755 | **DUT** | IN  pkt #2 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136785 | **DUT** | IN  pkt #2 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136785 | yapp monitor | RX pkt #2 on the input: addr=0 len=2 parity=bad gap=13627 |
| 136785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 136935 | **DUT** | IN  pkt #3 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136965 | **DUT** | IN  pkt #3 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136965 | yapp monitor | RX pkt #3 on the input: addr=0 len=2 parity=bad gap=14 |
| 136965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136990 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 137095 | **DUT** | IN  pkt #4 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137125 | **DUT** | IN  pkt #4 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137125 | yapp monitor | RX pkt #4 on the input: addr=0 len=2 parity=bad gap=12 |
| 137125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 137225 | **DUT** | IN  pkt #5 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137255 | **DUT** | IN  pkt #5 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137255 | yapp monitor | RX pkt #5 on the input: addr=0 len=2 parity=bad gap=9 |
| 137255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 137385 | **DUT** | IN  pkt #6 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137415 | **DUT** | IN  pkt #6 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137415 | yapp monitor | RX pkt #6 on the input: addr=0 len=2 parity=bad gap=12 |
| 137415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 137615 | **DUT** | IN  pkt #7 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137645 | **DUT** | IN  pkt #7 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137645 | yapp monitor | RX pkt #7 on the input: addr=0 len=2 parity=bad gap=19 |
| 137645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 137755 | **DUT** | IN  pkt #8 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137785 | **DUT** | IN  pkt #8 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137785 | yapp monitor | RX pkt #8 on the input: addr=0 len=2 parity=bad gap=10 |
| 137785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 137845 | **DUT** | IN  pkt #9 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137875 | **DUT** | IN  pkt #9 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137875 | yapp monitor | RX pkt #9 on the input: addr=0 len=2 parity=bad gap=5 |
| 137875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137875 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 138055 | **DUT** | IN  pkt #10 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138085 | **DUT** | IN  pkt #10 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138085 | yapp monitor | RX pkt #10 on the input: addr=0 len=2 parity=bad gap=17 |
| 138085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 138295 | **DUT** | IN  pkt #11 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138325 | **DUT** | IN  pkt #11 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138325 | yapp monitor | RX pkt #11 on the input: addr=0 len=2 parity=bad gap=20 |
| 138325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 138535 | **DUT** | IN  pkt #12 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138565 | **DUT** | IN  pkt #12 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138565 | yapp monitor | RX pkt #12 on the input: addr=0 len=2 parity=bad gap=20 |
| 138565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138590 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 138765 | **DUT** | IN  pkt #13 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138795 | **DUT** | IN  pkt #13 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138795 | yapp monitor | RX pkt #13 on the input: addr=0 len=2 parity=bad gap=19 |
| 138795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138795 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 138995 | **DUT** | IN  pkt #14 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139025 | **DUT** | IN  pkt #14 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139025 | yapp monitor | RX pkt #14 on the input: addr=0 len=2 parity=bad gap=19 |
| 139025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 139215 | **DUT** | IN  pkt #15 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139245 | **DUT** | IN  pkt #15 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139245 | yapp monitor | RX pkt #15 on the input: addr=0 len=2 parity=bad gap=18 |
| 139245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 139445 | **DUT** | IN  pkt #16 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139475 | **DUT** | IN  pkt #16 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139475 | yapp monitor | RX pkt #16 on the input: addr=0 len=2 parity=bad gap=19 |
| 139475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139495 | **DUT** | IN  pkt #17 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139525 | **DUT** | IN  pkt #17 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139525 | yapp monitor | RX pkt #17 on the input: addr=0 len=2 parity=bad gap=1 |
| 139525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 139560 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 139735 | **DUT** | IN  pkt #18 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139765 | **DUT** | IN  pkt #18 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139765 | yapp monitor | RX pkt #18 on the input: addr=0 len=2 parity=bad gap=20 |
| 139765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 139975 | **DUT** | IN  pkt #19 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140005 | **DUT** | IN  pkt #19 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140005 | yapp monitor | RX pkt #19 on the input: addr=0 len=2 parity=bad gap=20 |
| 140005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 140095 | **DUT** | IN  pkt #20 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140125 | **DUT** | IN  pkt #20 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140125 | yapp monitor | RX pkt #20 on the input: addr=0 len=2 parity=bad gap=8 |
| 140125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 140335 | **DUT** | IN  pkt #21 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140365 | **DUT** | IN  pkt #21 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140365 | yapp monitor | RX pkt #21 on the input: addr=0 len=2 parity=bad gap=20 |
| 140365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140405 | **DUT** | IN  pkt #22 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 140435 | **DUT** | IN  pkt #22 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140435 | yapp monitor | RX pkt #22 on the input: addr=0 len=2 parity=bad gap=3 |
| 140435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140435 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140510 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 140615 | **DUT** | IN  pkt #23 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140645 | **DUT** | IN  pkt #23 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140645 | yapp monitor | RX pkt #23 on the input: addr=0 len=2 parity=bad gap=17 |
| 140645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 140855 | **DUT** | IN  pkt #24 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140885 | **DUT** | IN  pkt #24 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140885 | yapp monitor | RX pkt #24 on the input: addr=0 len=2 parity=bad gap=20 |
| 140885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 141065 | **DUT** | IN  pkt #25 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141095 | **DUT** | IN  pkt #25 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141095 | yapp monitor | RX pkt #25 on the input: addr=0 len=2 parity=bad gap=17 |
| 141095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 141305 | **DUT** | IN  pkt #26 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141335 | **DUT** | IN  pkt #26 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141335 | yapp monitor | RX pkt #26 on the input: addr=0 len=2 parity=bad gap=20 |
| 141335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 141365 | **DUT** | IN  pkt #27 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141395 | **DUT** | IN  pkt #27 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141395 | yapp monitor | RX pkt #27 on the input: addr=0 len=2 parity=bad gap=2 |
| 141395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 141585 | **DUT** | IN  pkt #28 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141615 | **DUT** | IN  pkt #28 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141615 | yapp monitor | RX pkt #28 on the input: addr=0 len=2 parity=bad gap=18 |
| 141615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141645 | **DUT** | IN  pkt #29 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 141675 | **DUT** | IN  pkt #29 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141675 | yapp monitor | RX pkt #29 on the input: addr=0 len=2 parity=bad gap=2 |
| 141675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141695 | **DUT** | IN  pkt #30 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 141725 | **DUT** | IN  pkt #30 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141725 | yapp monitor | RX pkt #30 on the input: addr=0 len=2 parity=bad gap=1 |
| 141725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 141825 | **DUT** | IN  pkt #31 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141855 | **DUT** | IN  pkt #31 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141855 | yapp monitor | RX pkt #31 on the input: addr=0 len=2 parity=bad gap=9 |
| 141855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 142065 | **DUT** | IN  pkt #32 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142095 | **DUT** | IN  pkt #32 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142095 | yapp monitor | RX pkt #32 on the input: addr=0 len=2 parity=bad gap=20 |
| 142095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142115 | **DUT** | IN  pkt #33 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 142145 | **DUT** | IN  pkt #33 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142145 | yapp monitor | RX pkt #33 on the input: addr=0 len=2 parity=bad gap=1 |
| 142145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 142355 | **DUT** | IN  pkt #34 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142385 | **DUT** | IN  pkt #34 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142385 | yapp monitor | RX pkt #34 on the input: addr=0 len=2 parity=bad gap=20 |
| 142385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 142555 | **DUT** | IN  pkt #35 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142585 | **DUT** | IN  pkt #35 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142585 | yapp monitor | RX pkt #35 on the input: addr=0 len=2 parity=bad gap=16 |
| 142585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 142795 | **DUT** | IN  pkt #36 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142825 | **DUT** | IN  pkt #36 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142825 | yapp monitor | RX pkt #36 on the input: addr=0 len=2 parity=bad gap=20 |
| 142825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 142915 | **DUT** | IN  pkt #37 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142945 | **DUT** | IN  pkt #37 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142945 | yapp monitor | RX pkt #37 on the input: addr=0 len=2 parity=bad gap=8 |
| 142945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 143085 | **DUT** | IN  pkt #38 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143115 | **DUT** | IN  pkt #38 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143115 | yapp monitor | RX pkt #38 on the input: addr=0 len=2 parity=bad gap=13 |
| 143115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 143285 | **DUT** | IN  pkt #39 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143315 | **DUT** | IN  pkt #39 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143315 | yapp monitor | RX pkt #39 on the input: addr=0 len=2 parity=bad gap=16 |
| 143315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 143515 | **DUT** | IN  pkt #40 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143545 | **DUT** | IN  pkt #40 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143545 | yapp monitor | RX pkt #40 on the input: addr=0 len=2 parity=bad gap=19 |
| 143545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 143745 | **DUT** | IN  pkt #41 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143775 | **DUT** | IN  pkt #41 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143775 | yapp monitor | RX pkt #41 on the input: addr=0 len=2 parity=bad gap=19 |
| 143775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 143885 | **DUT** | IN  pkt #42 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143915 | **DUT** | IN  pkt #42 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143915 | yapp monitor | RX pkt #42 on the input: addr=0 len=2 parity=bad gap=10 |
| 143915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143945 | **DUT** | IN  pkt #43 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 143975 | **DUT** | IN  pkt #43 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143975 | yapp monitor | RX pkt #43 on the input: addr=0 len=2 parity=bad gap=2 |
| 143975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144065 | **DUT** | IN  pkt #44 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144070 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 144095 | **DUT** | IN  pkt #44 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144095 | yapp monitor | RX pkt #44 on the input: addr=0 len=2 parity=bad gap=8 |
| 144095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144115 | **DUT** | IN  pkt #45 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144145 | **DUT** | IN  pkt #45 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144145 | yapp monitor | RX pkt #45 on the input: addr=0 len=2 parity=bad gap=1 |
| 144145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 144250 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 144345 | **DUT** | IN  pkt #46 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144375 | **DUT** | IN  pkt #46 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144375 | yapp monitor | RX pkt #46 on the input: addr=0 len=2 parity=bad gap=19 |
| 144375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 144585 | **DUT** | IN  pkt #47 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144615 | **DUT** | IN  pkt #47 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144615 | yapp monitor | RX pkt #47 on the input: addr=0 len=2 parity=bad gap=20 |
| 144615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144675 | **DUT** | IN  pkt #48 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144705 | **DUT** | IN  pkt #48 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144705 | yapp monitor | RX pkt #48 on the input: addr=0 len=2 parity=bad gap=5 |
| 144705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 144730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 144835 | **DUT** | IN  pkt #49 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144865 | **DUT** | IN  pkt #49 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144865 | yapp monitor | RX pkt #49 on the input: addr=0 len=2 parity=bad gap=12 |
| 144865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144865 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 145065 | **DUT** | IN  pkt #50 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145095 | **DUT** | IN  pkt #50 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145095 | yapp monitor | RX pkt #50 on the input: addr=0 len=2 parity=bad gap=19 |
| 145095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 145295 | **DUT** | IN  pkt #51 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145325 | **DUT** | IN  pkt #51 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145325 | yapp monitor | RX pkt #51 on the input: addr=0 len=2 parity=bad gap=19 |
| 145325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 145525 | **DUT** | IN  pkt #52 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145555 | **DUT** | IN  pkt #52 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145555 | yapp monitor | RX pkt #52 on the input: addr=0 len=2 parity=bad gap=19 |
| 145555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145575 | **DUT** | IN  pkt #53 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145605 | **DUT** | IN  pkt #53 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145605 | yapp monitor | RX pkt #53 on the input: addr=0 len=2 parity=bad gap=1 |
| 145605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 145640 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 145795 | **DUT** | IN  pkt #54 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145825 | **DUT** | IN  pkt #54 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145825 | yapp monitor | RX pkt #54 on the input: addr=0 len=2 parity=bad gap=18 |
| 145825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 145865 | **DUT** | IN  pkt #55 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145895 | **DUT** | IN  pkt #55 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145895 | yapp monitor | RX pkt #55 on the input: addr=0 len=2 parity=bad gap=3 |
| 145895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 146105 | **DUT** | IN  pkt #56 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146135 | **DUT** | IN  pkt #56 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146135 | yapp monitor | RX pkt #56 on the input: addr=0 len=2 parity=bad gap=20 |
| 146135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 146185 | **DUT** | IN  pkt #57 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146215 | **DUT** | IN  pkt #57 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146215 | yapp monitor | RX pkt #57 on the input: addr=0 len=2 parity=bad gap=4 |
| 146215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 146375 | **DUT** | IN  pkt #58 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146405 | **DUT** | IN  pkt #58 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146405 | yapp monitor | RX pkt #58 on the input: addr=0 len=2 parity=bad gap=15 |
| 146405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 146605 | **DUT** | IN  pkt #59 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146635 | **DUT** | IN  pkt #59 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146635 | yapp monitor | RX pkt #59 on the input: addr=0 len=2 parity=bad gap=19 |
| 146635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146635 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146670 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 146845 | **DUT** | IN  pkt #60 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146875 | **DUT** | IN  pkt #60 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146875 | yapp monitor | RX pkt #60 on the input: addr=0 len=2 parity=bad gap=20 |
| 146875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146875 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 147085 | **DUT** | IN  pkt #61 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147115 | **DUT** | IN  pkt #61 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147115 | yapp monitor | RX pkt #61 on the input: addr=0 len=2 parity=bad gap=20 |
| 147115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 147155 | **DUT** | IN  pkt #62 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147185 | **DUT** | IN  pkt #62 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147185 | yapp monitor | RX pkt #62 on the input: addr=0 len=2 parity=bad gap=3 |
| 147185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 147295 | **DUT** | IN  pkt #63 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147325 | **DUT** | IN  pkt #63 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147325 | yapp monitor | RX pkt #63 on the input: addr=0 len=2 parity=bad gap=10 |
| 147325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 147445 | **DUT** | IN  pkt #64 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147475 | **DUT** | IN  pkt #64 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147475 | yapp monitor | RX pkt #64 on the input: addr=0 len=2 parity=bad gap=11 |
| 147475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 147685 | **DUT** | IN  pkt #65 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147715 | **DUT** | IN  pkt #65 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147715 | yapp monitor | RX pkt #65 on the input: addr=0 len=2 parity=bad gap=20 |
| 147715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147715 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 147925 | **DUT** | IN  pkt #66 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147955 | **DUT** | IN  pkt #66 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147955 | yapp monitor | RX pkt #66 on the input: addr=0 len=2 parity=bad gap=20 |
| 147955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147995 | **DUT** | IN  pkt #67 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148025 | **DUT** | IN  pkt #67 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148025 | yapp monitor | RX pkt #67 on the input: addr=0 len=2 parity=bad gap=3 |
| 148025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 148070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 148235 | **DUT** | IN  pkt #68 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148265 | **DUT** | IN  pkt #68 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148265 | yapp monitor | RX pkt #68 on the input: addr=0 len=2 parity=bad gap=20 |
| 148265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148265 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 148395 | **DUT** | IN  pkt #69 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148425 | **DUT** | IN  pkt #69 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148425 | yapp monitor | RX pkt #69 on the input: addr=0 len=2 parity=bad gap=12 |
| 148425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148425 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 148565 | **DUT** | IN  pkt #70 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148595 | **DUT** | IN  pkt #70 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148595 | yapp monitor | RX pkt #70 on the input: addr=0 len=2 parity=bad gap=13 |
| 148595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148670 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 148795 | **DUT** | IN  pkt #71 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148825 | **DUT** | IN  pkt #71 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148825 | yapp monitor | RX pkt #71 on the input: addr=0 len=2 parity=bad gap=19 |
| 148825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148865 | **DUT** | IN  pkt #72 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 148895 | **DUT** | IN  pkt #72 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148895 | yapp monitor | RX pkt #72 on the input: addr=0 len=2 parity=bad gap=3 |
| 148895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 149095 | **DUT** | IN  pkt #73 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149125 | **DUT** | IN  pkt #73 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149125 | yapp monitor | RX pkt #73 on the input: addr=0 len=2 parity=bad gap=19 |
| 149125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 149215 | **DUT** | IN  pkt #74 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149245 | **DUT** | IN  pkt #74 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149245 | yapp monitor | RX pkt #74 on the input: addr=0 len=2 parity=bad gap=8 |
| 149245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 149375 | **DUT** | IN  pkt #75 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149405 | **DUT** | IN  pkt #75 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149405 | yapp monitor | RX pkt #75 on the input: addr=0 len=2 parity=bad gap=12 |
| 149405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 149505 | **DUT** | IN  pkt #76 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149535 | **DUT** | IN  pkt #76 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149535 | yapp monitor | RX pkt #76 on the input: addr=0 len=2 parity=bad gap=9 |
| 149535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149535 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 149625 | **DUT** | IN  pkt #77 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149655 | **DUT** | IN  pkt #77 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149655 | yapp monitor | RX pkt #77 on the input: addr=0 len=2 parity=bad gap=8 |
| 149655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 149865 | **DUT** | IN  pkt #78 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149895 | **DUT** | IN  pkt #78 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149895 | yapp monitor | RX pkt #78 on the input: addr=0 len=2 parity=bad gap=20 |
| 149895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 150085 | **DUT** | IN  pkt #79 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150115 | **DUT** | IN  pkt #79 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150115 | yapp monitor | RX pkt #79 on the input: addr=0 len=2 parity=bad gap=18 |
| 150115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 150295 | **DUT** | IN  pkt #80 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150325 | **DUT** | IN  pkt #80 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150325 | yapp monitor | RX pkt #80 on the input: addr=0 len=2 parity=bad gap=17 |
| 150325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 150375 | **DUT** | IN  pkt #81 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150405 | **DUT** | IN  pkt #81 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150405 | yapp monitor | RX pkt #81 on the input: addr=0 len=2 parity=bad gap=4 |
| 150405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 150615 | **DUT** | IN  pkt #82 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150645 | **DUT** | IN  pkt #82 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150645 | yapp monitor | RX pkt #82 on the input: addr=0 len=2 parity=bad gap=20 |
| 150645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 150855 | **DUT** | IN  pkt #83 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150885 | **DUT** | IN  pkt #83 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150885 | yapp monitor | RX pkt #83 on the input: addr=0 len=2 parity=bad gap=20 |
| 150885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 151065 | **DUT** | IN  pkt #84 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151095 | **DUT** | IN  pkt #84 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151095 | yapp monitor | RX pkt #84 on the input: addr=0 len=2 parity=bad gap=17 |
| 151095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151110 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 151175 | **DUT** | IN  pkt #85 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151205 | **DUT** | IN  pkt #85 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151205 | yapp monitor | RX pkt #85 on the input: addr=0 len=2 parity=bad gap=7 |
| 151205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 151285 | **DUT** | IN  pkt #86 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151315 | **DUT** | IN  pkt #86 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151315 | yapp monitor | RX pkt #86 on the input: addr=0 len=2 parity=bad gap=7 |
| 151315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 151525 | **DUT** | IN  pkt #87 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151555 | **DUT** | IN  pkt #87 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151555 | yapp monitor | RX pkt #87 on the input: addr=0 len=2 parity=bad gap=20 |
| 151555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 151665 | **DUT** | IN  pkt #88 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151695 | **DUT** | IN  pkt #88 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151695 | yapp monitor | RX pkt #88 on the input: addr=0 len=2 parity=bad gap=10 |
| 151695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151715 | **DUT** | IN  pkt #89 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 151745 | **DUT** | IN  pkt #89 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151745 | yapp monitor | RX pkt #89 on the input: addr=0 len=2 parity=bad gap=1 |
| 151745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151765 | **DUT** | IN  pkt #90 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 151795 | **DUT** | IN  pkt #90 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151795 | yapp monitor | RX pkt #90 on the input: addr=0 len=2 parity=bad gap=1 |
| 151795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151795 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 151925 | **DUT** | IN  pkt #91 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151955 | **DUT** | IN  pkt #91 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151955 | yapp monitor | RX pkt #91 on the input: addr=0 len=2 parity=bad gap=12 |
| 151955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 152155 | **DUT** | IN  pkt #92 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152185 | **DUT** | IN  pkt #92 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152185 | yapp monitor | RX pkt #92 on the input: addr=0 len=2 parity=bad gap=19 |
| 152185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 152335 | **DUT** | IN  pkt #93 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152365 | **DUT** | IN  pkt #93 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152365 | yapp monitor | RX pkt #93 on the input: addr=0 len=2 parity=bad gap=14 |
| 152365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 152525 | **DUT** | IN  pkt #94 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152555 | **DUT** | IN  pkt #94 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152555 | yapp monitor | RX pkt #94 on the input: addr=0 len=2 parity=bad gap=15 |
| 152555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 152595 | **DUT** | IN  pkt #95 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152625 | **DUT** | IN  pkt #95 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152625 | yapp monitor | RX pkt #95 on the input: addr=0 len=2 parity=bad gap=3 |
| 152625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 152775 | **DUT** | IN  pkt #96 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152805 | **DUT** | IN  pkt #96 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152805 | yapp monitor | RX pkt #96 on the input: addr=0 len=2 parity=bad gap=14 |
| 152805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152805 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152830 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 152985 | **DUT** | IN  pkt #97 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153015 | **DUT** | IN  pkt #97 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153015 | yapp monitor | RX pkt #97 on the input: addr=0 len=2 parity=bad gap=17 |
| 153015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153015 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 153225 | **DUT** | IN  pkt #98 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153255 | **DUT** | IN  pkt #98 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153255 | yapp monitor | RX pkt #98 on the input: addr=0 len=2 parity=bad gap=20 |
| 153255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 153445 | **DUT** | IN  pkt #99 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153475 | **DUT** | IN  pkt #99 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153475 | yapp monitor | RX pkt #99 on the input: addr=0 len=2 parity=bad gap=18 |
| 153475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 153545 | **DUT** | IN  pkt #100 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153575 | **DUT** | IN  pkt #100 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153575 | yapp monitor | RX pkt #100 on the input: addr=0 len=2 parity=bad gap=6 |
| 153575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153655 | **DUT** | IN  pkt #101 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 153685 | **DUT** | IN  pkt #101 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153685 | yapp monitor | RX pkt #101 on the input: addr=0 len=2 parity=bad gap=7 |
| 153685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153725 | hbus monitor | Collected READ  addr=0x1004 data=0x64 |
| 153730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 153755 | hbus monitor | Collected READ  addr=0x1005 data=0x64 |
| 153785 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 153815 | hbus monitor | Collected READ  addr=0x1009 data=0x64 |
| 153845 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 153875 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 154055 | **DUT** | IN  pkt #102 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154085 | **DUT** | IN  pkt #102 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154085 | yapp monitor | RX pkt #102 on the input: addr=0 len=2 parity=bad gap=36 |
| 154085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 154125 | **DUT** | IN  pkt #103 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154155 | **DUT** | IN  pkt #103 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154155 | yapp monitor | RX pkt #103 on the input: addr=0 len=2 parity=bad gap=3 |
| 154155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 154325 | **DUT** | IN  pkt #104 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154355 | **DUT** | IN  pkt #104 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154355 | yapp monitor | RX pkt #104 on the input: addr=0 len=2 parity=bad gap=16 |
| 154355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 154565 | **DUT** | IN  pkt #105 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154595 | **DUT** | IN  pkt #105 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154595 | yapp monitor | RX pkt #105 on the input: addr=0 len=2 parity=bad gap=20 |
| 154595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 154805 | **DUT** | IN  pkt #106 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154835 | **DUT** | IN  pkt #106 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154835 | yapp monitor | RX pkt #106 on the input: addr=0 len=2 parity=bad gap=20 |
| 154835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 155045 | **DUT** | IN  pkt #107 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155075 | **DUT** | IN  pkt #107 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155075 | yapp monitor | RX pkt #107 on the input: addr=0 len=2 parity=bad gap=20 |
| 155075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155130 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 155155 | **DUT** | IN  pkt #108 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155185 | **DUT** | IN  pkt #108 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155185 | yapp monitor | RX pkt #108 on the input: addr=0 len=2 parity=bad gap=7 |
| 155185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 155385 | **DUT** | IN  pkt #109 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155415 | **DUT** | IN  pkt #109 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155415 | yapp monitor | RX pkt #109 on the input: addr=0 len=2 parity=bad gap=19 |
| 155415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 155595 | **DUT** | IN  pkt #110 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155625 | **DUT** | IN  pkt #110 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155625 | yapp monitor | RX pkt #110 on the input: addr=0 len=2 parity=bad gap=17 |
| 155625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155690 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 155795 | **DUT** | IN  pkt #111 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155825 | **DUT** | IN  pkt #111 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155825 | yapp monitor | RX pkt #111 on the input: addr=0 len=2 parity=bad gap=16 |
| 155825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155895 | **DUT** | IN  pkt #112 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155925 | **DUT** | IN  pkt #112 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155925 | yapp monitor | RX pkt #112 on the input: addr=0 len=2 parity=bad gap=6 |
| 155925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 155970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 156135 | **DUT** | IN  pkt #113 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156165 | **DUT** | IN  pkt #113 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156165 | yapp monitor | RX pkt #113 on the input: addr=0 len=2 parity=bad gap=20 |
| 156165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 156225 | **DUT** | IN  pkt #114 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156255 | **DUT** | IN  pkt #114 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156255 | yapp monitor | RX pkt #114 on the input: addr=0 len=2 parity=bad gap=5 |
| 156255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156305 | **DUT** | IN  pkt #115 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156335 | **DUT** | IN  pkt #115 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156335 | yapp monitor | RX pkt #115 on the input: addr=0 len=2 parity=bad gap=4 |
| 156335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 156545 | **DUT** | IN  pkt #116 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156575 | **DUT** | IN  pkt #116 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156575 | yapp monitor | RX pkt #116 on the input: addr=0 len=2 parity=bad gap=20 |
| 156575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156615 | **DUT** | IN  pkt #117 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156645 | **DUT** | IN  pkt #117 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156645 | yapp monitor | RX pkt #117 on the input: addr=0 len=2 parity=bad gap=3 |
| 156645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 156855 | **DUT** | IN  pkt #118 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156885 | **DUT** | IN  pkt #118 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156885 | yapp monitor | RX pkt #118 on the input: addr=0 len=2 parity=bad gap=20 |
| 156885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156905 | **DUT** | IN  pkt #119 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 156935 | **DUT** | IN  pkt #119 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156935 | yapp monitor | RX pkt #119 on the input: addr=0 len=2 parity=bad gap=1 |
| 156935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157030 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 157115 | **DUT** | IN  pkt #120 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157145 | **DUT** | IN  pkt #120 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157145 | yapp monitor | RX pkt #120 on the input: addr=0 len=2 parity=bad gap=17 |
| 157145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 157205 | **DUT** | IN  pkt #121 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157235 | **DUT** | IN  pkt #121 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157235 | yapp monitor | RX pkt #121 on the input: addr=0 len=2 parity=bad gap=5 |
| 157235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 157375 | **DUT** | IN  pkt #122 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157405 | **DUT** | IN  pkt #122 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157405 | yapp monitor | RX pkt #122 on the input: addr=0 len=2 parity=bad gap=13 |
| 157405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 157615 | **DUT** | IN  pkt #123 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157645 | **DUT** | IN  pkt #123 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157645 | yapp monitor | RX pkt #123 on the input: addr=0 len=2 parity=bad gap=20 |
| 157645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157705 | **DUT** | IN  pkt #124 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 157735 | **DUT** | IN  pkt #124 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157735 | yapp monitor | RX pkt #124 on the input: addr=0 len=2 parity=bad gap=5 |
| 157735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 157855 | **DUT** | IN  pkt #125 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157885 | **DUT** | IN  pkt #125 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157885 | yapp monitor | RX pkt #125 on the input: addr=0 len=2 parity=bad gap=11 |
| 157885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 158095 | **DUT** | IN  pkt #126 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158125 | **DUT** | IN  pkt #126 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158125 | yapp monitor | RX pkt #126 on the input: addr=0 len=2 parity=bad gap=20 |
| 158125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 158275 | **DUT** | IN  pkt #127 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158305 | **DUT** | IN  pkt #127 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158305 | yapp monitor | RX pkt #127 on the input: addr=0 len=2 parity=bad gap=14 |
| 158305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 158515 | **DUT** | IN  pkt #128 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158545 | **DUT** | IN  pkt #128 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158545 | yapp monitor | RX pkt #128 on the input: addr=0 len=2 parity=bad gap=20 |
| 158545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 158755 | **DUT** | IN  pkt #129 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158785 | **DUT** | IN  pkt #129 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158785 | yapp monitor | RX pkt #129 on the input: addr=0 len=2 parity=bad gap=20 |
| 158785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 158965 | **DUT** | IN  pkt #130 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158995 | **DUT** | IN  pkt #130 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158995 | yapp monitor | RX pkt #130 on the input: addr=0 len=2 parity=bad gap=17 |
| 158995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 159205 | **DUT** | IN  pkt #131 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159235 | **DUT** | IN  pkt #131 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159235 | yapp monitor | RX pkt #131 on the input: addr=0 len=2 parity=bad gap=20 |
| 159235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 159295 | **DUT** | IN  pkt #132 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159325 | **DUT** | IN  pkt #132 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159325 | yapp monitor | RX pkt #132 on the input: addr=0 len=2 parity=bad gap=5 |
| 159325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 159475 | **DUT** | IN  pkt #133 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159505 | **DUT** | IN  pkt #133 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159505 | yapp monitor | RX pkt #133 on the input: addr=0 len=2 parity=bad gap=14 |
| 159505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159505 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159525 | **DUT** | IN  pkt #134 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159555 | **DUT** | IN  pkt #134 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159555 | yapp monitor | RX pkt #134 on the input: addr=0 len=2 parity=bad gap=1 |
| 159555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159610 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 159620 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 159695 | **DUT** | IN  pkt #135 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159725 | **DUT** | IN  pkt #135 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159725 | yapp monitor | RX pkt #135 on the input: addr=0 len=2 parity=bad gap=13 |
| 159725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 159935 | **DUT** | IN  pkt #136 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159965 | **DUT** | IN  pkt #136 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159965 | yapp monitor | RX pkt #136 on the input: addr=0 len=2 parity=bad gap=20 |
| 159965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 160175 | **DUT** | IN  pkt #137 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160205 | **DUT** | IN  pkt #137 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160205 | yapp monitor | RX pkt #137 on the input: addr=0 len=2 parity=bad gap=20 |
| 160205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160270 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 160295 | **DUT** | IN  pkt #138 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160325 | **DUT** | IN  pkt #138 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160325 | yapp monitor | RX pkt #138 on the input: addr=0 len=2 parity=bad gap=8 |
| 160325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 160525 | **DUT** | IN  pkt #139 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160555 | **DUT** | IN  pkt #139 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160555 | yapp monitor | RX pkt #139 on the input: addr=0 len=2 parity=bad gap=19 |
| 160555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 160655 | **DUT** | IN  pkt #140 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160685 | **DUT** | IN  pkt #140 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160685 | yapp monitor | RX pkt #140 on the input: addr=0 len=2 parity=bad gap=9 |
| 160685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 160895 | **DUT** | IN  pkt #141 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160925 | **DUT** | IN  pkt #141 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160925 | yapp monitor | RX pkt #141 on the input: addr=0 len=2 parity=bad gap=20 |
| 160925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161005 | **DUT** | IN  pkt #142 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 161035 | **DUT** | IN  pkt #142 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161035 | yapp monitor | RX pkt #142 on the input: addr=0 len=2 parity=bad gap=7 |
| 161035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161035 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 161245 | **DUT** | IN  pkt #143 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161275 | **DUT** | IN  pkt #143 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161275 | yapp monitor | RX pkt #143 on the input: addr=0 len=2 parity=bad gap=20 |
| 161275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 161485 | **DUT** | IN  pkt #144 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161515 | **DUT** | IN  pkt #144 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161515 | yapp monitor | RX pkt #144 on the input: addr=0 len=2 parity=bad gap=20 |
| 161515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 161725 | **DUT** | IN  pkt #145 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161755 | **DUT** | IN  pkt #145 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161755 | yapp monitor | RX pkt #145 on the input: addr=0 len=2 parity=bad gap=20 |
| 161755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 161965 | **DUT** | IN  pkt #146 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161995 | **DUT** | IN  pkt #146 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161995 | yapp monitor | RX pkt #146 on the input: addr=0 len=2 parity=bad gap=20 |
| 161995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 162075 | **DUT** | IN  pkt #147 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162105 | **DUT** | IN  pkt #147 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162105 | yapp monitor | RX pkt #147 on the input: addr=0 len=2 parity=bad gap=7 |
| 162105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 162315 | **DUT** | IN  pkt #148 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162345 | **DUT** | IN  pkt #148 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162345 | yapp monitor | RX pkt #148 on the input: addr=0 len=2 parity=bad gap=20 |
| 162345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162345 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162410 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 162555 | **DUT** | IN  pkt #149 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162585 | **DUT** | IN  pkt #149 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162585 | yapp monitor | RX pkt #149 on the input: addr=0 len=2 parity=bad gap=20 |
| 162585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 162795 | **DUT** | IN  pkt #150 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162825 | **DUT** | IN  pkt #150 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162825 | yapp monitor | RX pkt #150 on the input: addr=0 len=2 parity=bad gap=20 |
| 162825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 162935 | **DUT** | IN  pkt #151 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162965 | **DUT** | IN  pkt #151 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162965 | yapp monitor | RX pkt #151 on the input: addr=0 len=2 parity=bad gap=10 |
| 162965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 163135 | **DUT** | IN  pkt #152 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163165 | **DUT** | IN  pkt #152 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163165 | yapp monitor | RX pkt #152 on the input: addr=0 len=2 parity=bad gap=16 |
| 163165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 163375 | **DUT** | IN  pkt #153 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163405 | **DUT** | IN  pkt #153 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163405 | yapp monitor | RX pkt #153 on the input: addr=0 len=2 parity=bad gap=20 |
| 163405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 163615 | **DUT** | IN  pkt #154 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163645 | **DUT** | IN  pkt #154 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163645 | yapp monitor | RX pkt #154 on the input: addr=0 len=2 parity=bad gap=20 |
| 163645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 163855 | **DUT** | IN  pkt #155 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163885 | **DUT** | IN  pkt #155 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163885 | yapp monitor | RX pkt #155 on the input: addr=0 len=2 parity=bad gap=20 |
| 163885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 164095 | **DUT** | IN  pkt #156 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164125 | **DUT** | IN  pkt #156 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164125 | yapp monitor | RX pkt #156 on the input: addr=0 len=2 parity=bad gap=20 |
| 164125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 164335 | **DUT** | IN  pkt #157 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164365 | **DUT** | IN  pkt #157 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164365 | yapp monitor | RX pkt #157 on the input: addr=0 len=2 parity=bad gap=20 |
| 164365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 164575 | **DUT** | IN  pkt #158 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164605 | **DUT** | IN  pkt #158 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164605 | yapp monitor | RX pkt #158 on the input: addr=0 len=2 parity=bad gap=20 |
| 164605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164635 | **DUT** | IN  pkt #159 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164665 | **DUT** | IN  pkt #159 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164665 | yapp monitor | RX pkt #159 on the input: addr=0 len=2 parity=bad gap=2 |
| 164665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164665 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 164710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 164745 | **DUT** | IN  pkt #160 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164775 | **DUT** | IN  pkt #160 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164775 | yapp monitor | RX pkt #160 on the input: addr=0 len=2 parity=bad gap=7 |
| 164775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 164945 | **DUT** | IN  pkt #161 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164975 | **DUT** | IN  pkt #161 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164975 | yapp monitor | RX pkt #161 on the input: addr=0 len=2 parity=bad gap=16 |
| 164975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 165095 | **DUT** | IN  pkt #162 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165125 | **DUT** | IN  pkt #162 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165125 | yapp monitor | RX pkt #162 on the input: addr=0 len=2 parity=bad gap=11 |
| 165125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 165165 | **DUT** | IN  pkt #163 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165195 | **DUT** | IN  pkt #163 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165195 | yapp monitor | RX pkt #163 on the input: addr=0 len=2 parity=bad gap=3 |
| 165195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165215 | **DUT** | IN  pkt #164 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 165245 | **DUT** | IN  pkt #164 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165245 | yapp monitor | RX pkt #164 on the input: addr=0 len=2 parity=bad gap=1 |
| 165245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 165445 | **DUT** | IN  pkt #165 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165475 | **DUT** | IN  pkt #165 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165475 | yapp monitor | RX pkt #165 on the input: addr=0 len=2 parity=bad gap=19 |
| 165475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 165535 | **DUT** | IN  pkt #166 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165565 | **DUT** | IN  pkt #166 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165565 | yapp monitor | RX pkt #166 on the input: addr=0 len=2 parity=bad gap=5 |
| 165565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 165755 | **DUT** | IN  pkt #167 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165785 | **DUT** | IN  pkt #167 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165785 | yapp monitor | RX pkt #167 on the input: addr=0 len=2 parity=bad gap=18 |
| 165785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 165855 | **DUT** | IN  pkt #168 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165885 | **DUT** | IN  pkt #168 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165885 | yapp monitor | RX pkt #168 on the input: addr=0 len=2 parity=bad gap=6 |
| 165885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 166085 | **DUT** | IN  pkt #169 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166115 | **DUT** | IN  pkt #169 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166115 | yapp monitor | RX pkt #169 on the input: addr=0 len=2 parity=bad gap=19 |
| 166115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166155 | **DUT** | IN  pkt #170 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 166185 | **DUT** | IN  pkt #170 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166185 | yapp monitor | RX pkt #170 on the input: addr=0 len=2 parity=bad gap=3 |
| 166185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166205 | **DUT** | IN  pkt #171 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166235 | **DUT** | IN  pkt #171 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166235 | yapp monitor | RX pkt #171 on the input: addr=0 len=2 parity=bad gap=1 |
| 166235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166250 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 166260 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 166445 | **DUT** | IN  pkt #172 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166475 | **DUT** | IN  pkt #172 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166475 | yapp monitor | RX pkt #172 on the input: addr=0 len=2 parity=bad gap=20 |
| 166475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 166535 | **DUT** | IN  pkt #173 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166565 | **DUT** | IN  pkt #173 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166565 | yapp monitor | RX pkt #173 on the input: addr=0 len=2 parity=bad gap=5 |
| 166565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166590 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 166775 | **DUT** | IN  pkt #174 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166805 | **DUT** | IN  pkt #174 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166805 | yapp monitor | RX pkt #174 on the input: addr=0 len=2 parity=bad gap=20 |
| 166805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166805 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166825 | **DUT** | IN  pkt #175 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166850 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 166855 | **DUT** | IN  pkt #175 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166855 | yapp monitor | RX pkt #175 on the input: addr=0 len=2 parity=bad gap=1 |
| 166855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166945 | **DUT** | IN  pkt #176 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 166975 | **DUT** | IN  pkt #176 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166975 | yapp monitor | RX pkt #176 on the input: addr=0 len=2 parity=bad gap=8 |
| 166975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 167165 | **DUT** | IN  pkt #177 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167195 | **DUT** | IN  pkt #177 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167195 | yapp monitor | RX pkt #177 on the input: addr=0 len=2 parity=bad gap=18 |
| 167195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 167405 | **DUT** | IN  pkt #178 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167435 | **DUT** | IN  pkt #178 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167435 | yapp monitor | RX pkt #178 on the input: addr=0 len=2 parity=bad gap=20 |
| 167435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167435 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 167605 | **DUT** | IN  pkt #179 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167635 | **DUT** | IN  pkt #179 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167635 | yapp monitor | RX pkt #179 on the input: addr=0 len=2 parity=bad gap=16 |
| 167635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167635 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 167765 | **DUT** | IN  pkt #180 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167795 | **DUT** | IN  pkt #180 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167795 | yapp monitor | RX pkt #180 on the input: addr=0 len=2 parity=bad gap=12 |
| 167795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167795 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 167875 | **DUT** | IN  pkt #181 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167905 | **DUT** | IN  pkt #181 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167905 | yapp monitor | RX pkt #181 on the input: addr=0 len=2 parity=bad gap=7 |
| 167905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167930 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 168115 | **DUT** | IN  pkt #182 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168145 | **DUT** | IN  pkt #182 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168145 | yapp monitor | RX pkt #182 on the input: addr=0 len=2 parity=bad gap=20 |
| 168145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168250 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 168355 | **DUT** | IN  pkt #183 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168385 | **DUT** | IN  pkt #183 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168385 | yapp monitor | RX pkt #183 on the input: addr=0 len=2 parity=bad gap=20 |
| 168385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 168415 | **DUT** | IN  pkt #184 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168445 | **DUT** | IN  pkt #184 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168445 | yapp monitor | RX pkt #184 on the input: addr=0 len=2 parity=bad gap=2 |
| 168445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168465 | **DUT** | IN  pkt #185 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168495 | **DUT** | IN  pkt #185 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168495 | yapp monitor | RX pkt #185 on the input: addr=0 len=2 parity=bad gap=1 |
| 168495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 168540 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 168705 | **DUT** | IN  pkt #186 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168735 | **DUT** | IN  pkt #186 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168735 | yapp monitor | RX pkt #186 on the input: addr=0 len=2 parity=bad gap=20 |
| 168735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 168945 | **DUT** | IN  pkt #187 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168975 | **DUT** | IN  pkt #187 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168975 | yapp monitor | RX pkt #187 on the input: addr=0 len=2 parity=bad gap=20 |
| 168975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168995 | **DUT** | IN  pkt #188 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 169025 | **DUT** | IN  pkt #188 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169025 | yapp monitor | RX pkt #188 on the input: addr=0 len=2 parity=bad gap=1 |
| 169025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169045 | **DUT** | IN  pkt #189 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 169075 | **DUT** | IN  pkt #189 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169075 | yapp monitor | RX pkt #189 on the input: addr=0 len=2 parity=bad gap=1 |
| 169075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 169285 | **DUT** | IN  pkt #190 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169315 | **DUT** | IN  pkt #190 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169315 | yapp monitor | RX pkt #190 on the input: addr=0 len=2 parity=bad gap=20 |
| 169315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 169525 | **DUT** | IN  pkt #191 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169555 | **DUT** | IN  pkt #191 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169555 | yapp monitor | RX pkt #191 on the input: addr=0 len=2 parity=bad gap=20 |
| 169555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 169705 | **DUT** | IN  pkt #192 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169735 | **DUT** | IN  pkt #192 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169735 | yapp monitor | RX pkt #192 on the input: addr=0 len=2 parity=bad gap=14 |
| 169735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169755 | **DUT** | IN  pkt #193 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169785 | **DUT** | IN  pkt #193 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169785 | yapp monitor | RX pkt #193 on the input: addr=0 len=2 parity=bad gap=1 |
| 169785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169805 | **DUT** | IN  pkt #194 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 169835 | **DUT** | IN  pkt #194 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169835 | yapp monitor | RX pkt #194 on the input: addr=0 len=2 parity=bad gap=1 |
| 169835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169840 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 169870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 170015 | **DUT** | IN  pkt #195 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170045 | **DUT** | IN  pkt #195 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170045 | yapp monitor | RX pkt #195 on the input: addr=0 len=2 parity=bad gap=17 |
| 170045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170045 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 170245 | **DUT** | IN  pkt #196 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170275 | **DUT** | IN  pkt #196 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170275 | yapp monitor | RX pkt #196 on the input: addr=0 len=2 parity=bad gap=19 |
| 170275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 170445 | **DUT** | IN  pkt #197 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170475 | **DUT** | IN  pkt #197 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170475 | yapp monitor | RX pkt #197 on the input: addr=0 len=2 parity=bad gap=16 |
| 170475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 170545 | **DUT** | IN  pkt #198 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170575 | **DUT** | IN  pkt #198 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170575 | yapp monitor | RX pkt #198 on the input: addr=0 len=2 parity=bad gap=6 |
| 170575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 170695 | **DUT** | IN  pkt #199 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170725 | **DUT** | IN  pkt #199 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170725 | yapp monitor | RX pkt #199 on the input: addr=0 len=2 parity=bad gap=11 |
| 170725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170750 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 170835 | **DUT** | IN  pkt #200 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170865 | **DUT** | IN  pkt #200 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170865 | yapp monitor | RX pkt #200 on the input: addr=0 len=2 parity=bad gap=10 |
| 170865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170865 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 171055 | **DUT** | IN  pkt #201 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171085 | **DUT** | IN  pkt #201 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171085 | yapp monitor | RX pkt #201 on the input: addr=0 len=2 parity=bad gap=18 |
| 171085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171135 | **DUT** | IN  pkt #202 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 171165 | **DUT** | IN  pkt #202 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171165 | yapp monitor | RX pkt #202 on the input: addr=0 len=2 parity=bad gap=4 |
| 171165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 171375 | **DUT** | IN  pkt #203 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171405 | **DUT** | IN  pkt #203 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171405 | yapp monitor | RX pkt #203 on the input: addr=0 len=2 parity=bad gap=20 |
| 171405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171435 | **DUT** | IN  pkt #204 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171465 | **DUT** | IN  pkt #204 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171465 | yapp monitor | RX pkt #204 on the input: addr=0 len=2 parity=bad gap=2 |
| 171465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171465 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 171530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 171645 | **DUT** | IN  pkt #205 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171675 | **DUT** | IN  pkt #205 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171675 | yapp monitor | RX pkt #205 on the input: addr=0 len=2 parity=bad gap=17 |
| 171675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 171885 | **DUT** | IN  pkt #206 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171915 | **DUT** | IN  pkt #206 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171915 | yapp monitor | RX pkt #206 on the input: addr=0 len=2 parity=bad gap=20 |
| 171915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171935 | **DUT** | IN  pkt #207 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 171965 | **DUT** | IN  pkt #207 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171965 | yapp monitor | RX pkt #207 on the input: addr=0 len=2 parity=bad gap=1 |
| 171965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 172135 | **DUT** | IN  pkt #208 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172165 | **DUT** | IN  pkt #208 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172165 | yapp monitor | RX pkt #208 on the input: addr=0 len=2 parity=bad gap=16 |
| 172165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 172225 | **DUT** | IN  pkt #209 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172255 | **DUT** | IN  pkt #209 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172255 | yapp monitor | RX pkt #209 on the input: addr=0 len=2 parity=bad gap=5 |
| 172255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 172375 | **DUT** | IN  pkt #210 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172405 | **DUT** | IN  pkt #210 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172405 | yapp monitor | RX pkt #210 on the input: addr=0 len=2 parity=bad gap=11 |
| 172405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 172615 | **DUT** | IN  pkt #211 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172645 | **DUT** | IN  pkt #211 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172645 | yapp monitor | RX pkt #211 on the input: addr=0 len=2 parity=bad gap=20 |
| 172645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 172855 | **DUT** | IN  pkt #212 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172885 | **DUT** | IN  pkt #212 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172885 | yapp monitor | RX pkt #212 on the input: addr=0 len=2 parity=bad gap=20 |
| 172885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 172975 | **DUT** | IN  pkt #213 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173005 | **DUT** | IN  pkt #213 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173005 | yapp monitor | RX pkt #213 on the input: addr=0 len=2 parity=bad gap=8 |
| 173005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 173215 | **DUT** | IN  pkt #214 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173245 | **DUT** | IN  pkt #214 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173245 | yapp monitor | RX pkt #214 on the input: addr=0 len=2 parity=bad gap=20 |
| 173245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173285 | **DUT** | IN  pkt #215 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173315 | **DUT** | IN  pkt #215 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173315 | yapp monitor | RX pkt #215 on the input: addr=0 len=2 parity=bad gap=3 |
| 173315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 173370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 173415 | **DUT** | IN  pkt #216 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173445 | **DUT** | IN  pkt #216 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173445 | yapp monitor | RX pkt #216 on the input: addr=0 len=2 parity=bad gap=9 |
| 173445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 173515 | **DUT** | IN  pkt #217 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173545 | **DUT** | IN  pkt #217 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173545 | yapp monitor | RX pkt #217 on the input: addr=0 len=2 parity=bad gap=6 |
| 173545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 173665 | **DUT** | IN  pkt #218 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173695 | **DUT** | IN  pkt #218 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173695 | yapp monitor | RX pkt #218 on the input: addr=0 len=2 parity=bad gap=11 |
| 173695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 173905 | **DUT** | IN  pkt #219 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173935 | **DUT** | IN  pkt #219 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173935 | yapp monitor | RX pkt #219 on the input: addr=0 len=2 parity=bad gap=20 |
| 173935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 174045 | **DUT** | IN  pkt #220 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174075 | **DUT** | IN  pkt #220 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174075 | yapp monitor | RX pkt #220 on the input: addr=0 len=2 parity=bad gap=10 |
| 174075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 174255 | **DUT** | IN  pkt #221 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174285 | **DUT** | IN  pkt #221 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174285 | yapp monitor | RX pkt #221 on the input: addr=0 len=2 parity=bad gap=17 |
| 174285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174285 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174325 | **DUT** | IN  pkt #222 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 174355 | **DUT** | IN  pkt #222 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174355 | yapp monitor | RX pkt #222 on the input: addr=0 len=2 parity=bad gap=3 |
| 174355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 174565 | **DUT** | IN  pkt #223 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174595 | **DUT** | IN  pkt #223 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174595 | yapp monitor | RX pkt #223 on the input: addr=0 len=2 parity=bad gap=20 |
| 174595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 174665 | **DUT** | IN  pkt #224 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174695 | **DUT** | IN  pkt #224 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174695 | yapp monitor | RX pkt #224 on the input: addr=0 len=2 parity=bad gap=6 |
| 174695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 174905 | **DUT** | IN  pkt #225 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174935 | **DUT** | IN  pkt #225 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174935 | yapp monitor | RX pkt #225 on the input: addr=0 len=2 parity=bad gap=20 |
| 174935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 175115 | **DUT** | IN  pkt #226 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175145 | **DUT** | IN  pkt #226 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175145 | yapp monitor | RX pkt #226 on the input: addr=0 len=2 parity=bad gap=17 |
| 175145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 175285 | **DUT** | IN  pkt #227 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175315 | **DUT** | IN  pkt #227 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175315 | yapp monitor | RX pkt #227 on the input: addr=0 len=2 parity=bad gap=13 |
| 175315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 175505 | **DUT** | IN  pkt #228 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175535 | **DUT** | IN  pkt #228 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175535 | yapp monitor | RX pkt #228 on the input: addr=0 len=2 parity=bad gap=18 |
| 175535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175535 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175570 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 175715 | **DUT** | IN  pkt #229 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175745 | **DUT** | IN  pkt #229 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175745 | yapp monitor | RX pkt #229 on the input: addr=0 len=2 parity=bad gap=17 |
| 175745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 175955 | **DUT** | IN  pkt #230 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175985 | **DUT** | IN  pkt #230 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175985 | yapp monitor | RX pkt #230 on the input: addr=0 len=2 parity=bad gap=20 |
| 175985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175985 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 176095 | **DUT** | IN  pkt #231 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176125 | **DUT** | IN  pkt #231 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176125 | yapp monitor | RX pkt #231 on the input: addr=0 len=2 parity=bad gap=10 |
| 176125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 176315 | **DUT** | IN  pkt #232 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176345 | **DUT** | IN  pkt #232 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176345 | yapp monitor | RX pkt #232 on the input: addr=0 len=2 parity=bad gap=18 |
| 176345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176345 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 176425 | **DUT** | IN  pkt #233 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176455 | **DUT** | IN  pkt #233 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176455 | yapp monitor | RX pkt #233 on the input: addr=0 len=2 parity=bad gap=7 |
| 176455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176455 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 176575 | **DUT** | IN  pkt #234 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176605 | **DUT** | IN  pkt #234 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176605 | yapp monitor | RX pkt #234 on the input: addr=0 len=2 parity=bad gap=11 |
| 176605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 176815 | **DUT** | IN  pkt #235 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176845 | **DUT** | IN  pkt #235 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176845 | yapp monitor | RX pkt #235 on the input: addr=0 len=2 parity=bad gap=20 |
| 176845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 176945 | **DUT** | IN  pkt #236 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176975 | **DUT** | IN  pkt #236 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176975 | yapp monitor | RX pkt #236 on the input: addr=0 len=2 parity=bad gap=9 |
| 176975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 177135 | **DUT** | IN  pkt #237 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177165 | **DUT** | IN  pkt #237 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177165 | yapp monitor | RX pkt #237 on the input: addr=0 len=2 parity=bad gap=15 |
| 177165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177230 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 177365 | **DUT** | IN  pkt #238 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177395 | **DUT** | IN  pkt #238 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177395 | yapp monitor | RX pkt #238 on the input: addr=0 len=2 parity=bad gap=19 |
| 177395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 177475 | **DUT** | IN  pkt #239 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177505 | **DUT** | IN  pkt #239 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177505 | yapp monitor | RX pkt #239 on the input: addr=0 len=2 parity=bad gap=7 |
| 177505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177505 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 177705 | **DUT** | IN  pkt #240 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177735 | **DUT** | IN  pkt #240 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177735 | yapp monitor | RX pkt #240 on the input: addr=0 len=2 parity=bad gap=19 |
| 177735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 177915 | **DUT** | IN  pkt #241 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177945 | **DUT** | IN  pkt #241 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177945 | yapp monitor | RX pkt #241 on the input: addr=0 len=2 parity=bad gap=17 |
| 177945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 178045 | **DUT** | IN  pkt #242 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178075 | **DUT** | IN  pkt #242 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178075 | yapp monitor | RX pkt #242 on the input: addr=0 len=2 parity=bad gap=9 |
| 178075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 178285 | **DUT** | IN  pkt #243 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178315 | **DUT** | IN  pkt #243 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178315 | yapp monitor | RX pkt #243 on the input: addr=0 len=2 parity=bad gap=20 |
| 178315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178350 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 178425 | **DUT** | IN  pkt #244 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178455 | **DUT** | IN  pkt #244 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178455 | yapp monitor | RX pkt #244 on the input: addr=0 len=2 parity=bad gap=10 |
| 178455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178455 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178470 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 178635 | **DUT** | IN  pkt #245 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178665 | **DUT** | IN  pkt #245 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178665 | yapp monitor | RX pkt #245 on the input: addr=0 len=2 parity=bad gap=17 |
| 178665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178665 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178730 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 178735 | **DUT** | IN  pkt #246 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178765 | **DUT** | IN  pkt #246 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178765 | yapp monitor | RX pkt #246 on the input: addr=0 len=2 parity=bad gap=6 |
| 178765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 178975 | **DUT** | IN  pkt #247 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179005 | **DUT** | IN  pkt #247 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179005 | yapp monitor | RX pkt #247 on the input: addr=0 len=2 parity=bad gap=20 |
| 179005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179045 | **DUT** | IN  pkt #248 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179075 | **DUT** | IN  pkt #248 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179075 | yapp monitor | RX pkt #248 on the input: addr=0 len=2 parity=bad gap=3 |
| 179075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 179105 | **DUT** | IN  pkt #249 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179130 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 179135 | **DUT** | IN  pkt #249 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179135 | yapp monitor | RX pkt #249 on the input: addr=0 len=2 parity=bad gap=2 |
| 179135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179190 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 179265 | **DUT** | IN  pkt #250 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179295 | **DUT** | IN  pkt #250 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179295 | yapp monitor | RX pkt #250 on the input: addr=0 len=2 parity=bad gap=12 |
| 179295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 179495 | **DUT** | IN  pkt #251 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179525 | **DUT** | IN  pkt #251 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179525 | yapp monitor | RX pkt #251 on the input: addr=0 len=2 parity=bad gap=19 |
| 179525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 179715 | **DUT** | IN  pkt #252 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179745 | **DUT** | IN  pkt #252 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179745 | yapp monitor | RX pkt #252 on the input: addr=0 len=2 parity=bad gap=18 |
| 179745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 179955 | **DUT** | IN  pkt #253 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179985 | **DUT** | IN  pkt #253 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179985 | yapp monitor | RX pkt #253 on the input: addr=0 len=2 parity=bad gap=20 |
| 179985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179985 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 180195 | **DUT** | IN  pkt #254 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180225 | **DUT** | IN  pkt #254 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180225 | yapp monitor | RX pkt #254 on the input: addr=0 len=2 parity=bad gap=20 |
| 180225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 180405 | **DUT** | IN  pkt #255 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180435 | **DUT** | IN  pkt #255 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180435 | yapp monitor | RX pkt #255 on the input: addr=0 len=2 parity=bad gap=17 |
| 180435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180435 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180510 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 180615 | **DUT** | IN  pkt #256 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180645 | **DUT** | IN  pkt #256 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180645 | yapp monitor | RX pkt #256 on the input: addr=0 len=2 parity=bad gap=17 |
| 180645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 180685 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 180715 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 180745 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 180775 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 180805 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 180830 | **test** | STAGE: 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 180835 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 180855 | hbus monitor | Collected WRITE addr=0x1001 data=0x21 |
| 180855 | reference | router_en is now 1 (en_reg 0x21) |
| 181025 | **DUT** | IN  pkt #257 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181055 | **DUT** | IN  pkt #257 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181055 | yapp monitor | RX pkt #257 on the input: addr=1 len=2 parity=bad gap=37 |
| 181055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181055 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 181265 | **DUT** | IN  pkt #258 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181295 | **DUT** | IN  pkt #258 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181295 | yapp monitor | RX pkt #258 on the input: addr=1 len=2 parity=bad gap=20 |
| 181295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181325 | **DUT** | IN  pkt #259 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 181355 | **DUT** | IN  pkt #259 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181355 | yapp monitor | RX pkt #259 on the input: addr=1 len=2 parity=bad gap=2 |
| 181355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 181475 | **DUT** | IN  pkt #260 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181505 | **DUT** | IN  pkt #260 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181505 | yapp monitor | RX pkt #260 on the input: addr=1 len=2 parity=bad gap=11 |
| 181505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 181675 | **DUT** | IN  pkt #261 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181705 | **DUT** | IN  pkt #261 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181705 | yapp monitor | RX pkt #261 on the input: addr=1 len=2 parity=bad gap=16 |
| 181705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 181915 | **DUT** | IN  pkt #262 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181945 | **DUT** | IN  pkt #262 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181945 | yapp monitor | RX pkt #262 on the input: addr=1 len=2 parity=bad gap=20 |
| 181945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 182035 | **DUT** | IN  pkt #263 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182065 | **DUT** | IN  pkt #263 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182065 | yapp monitor | RX pkt #263 on the input: addr=1 len=2 parity=bad gap=8 |
| 182065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 182175 | **DUT** | IN  pkt #264 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182205 | **DUT** | IN  pkt #264 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182205 | yapp monitor | RX pkt #264 on the input: addr=1 len=2 parity=bad gap=10 |
| 182205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182235 | **DUT** | IN  pkt #265 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182265 | **DUT** | IN  pkt #265 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182265 | yapp monitor | RX pkt #265 on the input: addr=1 len=2 parity=bad gap=2 |
| 182265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 182310 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 182385 | **DUT** | IN  pkt #266 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182415 | **DUT** | IN  pkt #266 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182415 | yapp monitor | RX pkt #266 on the input: addr=1 len=2 parity=bad gap=11 |
| 182415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182450 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 182545 | **DUT** | IN  pkt #267 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182575 | **DUT** | IN  pkt #267 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182575 | yapp monitor | RX pkt #267 on the input: addr=1 len=2 parity=bad gap=12 |
| 182575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 182785 | **DUT** | IN  pkt #268 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182815 | **DUT** | IN  pkt #268 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182815 | yapp monitor | RX pkt #268 on the input: addr=1 len=2 parity=bad gap=20 |
| 182815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182815 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 182945 | **DUT** | IN  pkt #269 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182975 | **DUT** | IN  pkt #269 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182975 | yapp monitor | RX pkt #269 on the input: addr=1 len=2 parity=bad gap=12 |
| 182975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 183175 | **DUT** | IN  pkt #270 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183205 | **DUT** | IN  pkt #270 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183205 | yapp monitor | RX pkt #270 on the input: addr=1 len=2 parity=bad gap=19 |
| 183205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 183345 | **DUT** | IN  pkt #271 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183375 | **DUT** | IN  pkt #271 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183375 | yapp monitor | RX pkt #271 on the input: addr=1 len=2 parity=bad gap=13 |
| 183375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 183555 | **DUT** | IN  pkt #272 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183585 | **DUT** | IN  pkt #272 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183585 | yapp monitor | RX pkt #272 on the input: addr=1 len=2 parity=bad gap=17 |
| 183585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 183705 | **DUT** | IN  pkt #273 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183735 | **DUT** | IN  pkt #273 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183735 | yapp monitor | RX pkt #273 on the input: addr=1 len=2 parity=bad gap=11 |
| 183735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183735 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 183755 | **DUT** | IN  pkt #274 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183785 | **DUT** | IN  pkt #274 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183785 | yapp monitor | RX pkt #274 on the input: addr=1 len=2 parity=bad gap=1 |
| 183785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 183995 | **DUT** | IN  pkt #275 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184025 | **DUT** | IN  pkt #275 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184025 | yapp monitor | RX pkt #275 on the input: addr=1 len=2 parity=bad gap=20 |
| 184025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 184135 | **DUT** | IN  pkt #276 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184165 | **DUT** | IN  pkt #276 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184165 | yapp monitor | RX pkt #276 on the input: addr=1 len=2 parity=bad gap=10 |
| 184165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 184215 | **DUT** | IN  pkt #277 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184245 | **DUT** | IN  pkt #277 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184245 | yapp monitor | RX pkt #277 on the input: addr=1 len=2 parity=bad gap=4 |
| 184245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 184455 | **DUT** | IN  pkt #278 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184485 | **DUT** | IN  pkt #278 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184485 | yapp monitor | RX pkt #278 on the input: addr=1 len=2 parity=bad gap=20 |
| 184485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 184565 | **DUT** | IN  pkt #279 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184595 | **DUT** | IN  pkt #279 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184595 | yapp monitor | RX pkt #279 on the input: addr=1 len=2 parity=bad gap=7 |
| 184595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184670 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 184695 | **DUT** | IN  pkt #280 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184725 | **DUT** | IN  pkt #280 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184725 | yapp monitor | RX pkt #280 on the input: addr=1 len=2 parity=bad gap=9 |
| 184725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 184925 | **DUT** | IN  pkt #281 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184955 | **DUT** | IN  pkt #281 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184955 | yapp monitor | RX pkt #281 on the input: addr=1 len=2 parity=bad gap=19 |
| 184955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 185155 | **DUT** | IN  pkt #282 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185185 | **DUT** | IN  pkt #282 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185185 | yapp monitor | RX pkt #282 on the input: addr=1 len=2 parity=bad gap=19 |
| 185185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 185275 | **DUT** | IN  pkt #283 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185305 | **DUT** | IN  pkt #283 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185305 | yapp monitor | RX pkt #283 on the input: addr=1 len=2 parity=bad gap=8 |
| 185305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185305 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 185375 | **DUT** | IN  pkt #284 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185405 | **DUT** | IN  pkt #284 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185405 | yapp monitor | RX pkt #284 on the input: addr=1 len=2 parity=bad gap=6 |
| 185405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 185615 | **DUT** | IN  pkt #285 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185645 | **DUT** | IN  pkt #285 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185645 | yapp monitor | RX pkt #285 on the input: addr=1 len=2 parity=bad gap=20 |
| 185645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 185795 | **DUT** | IN  pkt #286 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185825 | **DUT** | IN  pkt #286 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185825 | yapp monitor | RX pkt #286 on the input: addr=1 len=2 parity=bad gap=14 |
| 185825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 185885 | **DUT** | IN  pkt #287 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185915 | **DUT** | IN  pkt #287 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185915 | yapp monitor | RX pkt #287 on the input: addr=1 len=2 parity=bad gap=5 |
| 185915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 185965 | **DUT** | IN  pkt #288 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185995 | **DUT** | IN  pkt #288 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185995 | yapp monitor | RX pkt #288 on the input: addr=1 len=2 parity=bad gap=4 |
| 185995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 186115 | **DUT** | IN  pkt #289 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186145 | **DUT** | IN  pkt #289 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186145 | yapp monitor | RX pkt #289 on the input: addr=1 len=2 parity=bad gap=11 |
| 186145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 186285 | **DUT** | IN  pkt #290 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186315 | **DUT** | IN  pkt #290 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186315 | yapp monitor | RX pkt #290 on the input: addr=1 len=2 parity=bad gap=13 |
| 186315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186350 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 186525 | **DUT** | IN  pkt #291 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186555 | **DUT** | IN  pkt #291 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186555 | yapp monitor | RX pkt #291 on the input: addr=1 len=2 parity=bad gap=20 |
| 186555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 186705 | **DUT** | IN  pkt #292 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186735 | **DUT** | IN  pkt #292 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186735 | yapp monitor | RX pkt #292 on the input: addr=1 len=2 parity=bad gap=14 |
| 186735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186735 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186755 | **DUT** | IN  pkt #293 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 186785 | **DUT** | IN  pkt #293 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186785 | yapp monitor | RX pkt #293 on the input: addr=1 len=2 parity=bad gap=1 |
| 186785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 186955 | **DUT** | IN  pkt #294 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186985 | **DUT** | IN  pkt #294 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186985 | yapp monitor | RX pkt #294 on the input: addr=1 len=2 parity=bad gap=16 |
| 186985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 187195 | **DUT** | IN  pkt #295 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187225 | **DUT** | IN  pkt #295 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187225 | yapp monitor | RX pkt #295 on the input: addr=1 len=2 parity=bad gap=20 |
| 187225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 187435 | **DUT** | IN  pkt #296 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187465 | **DUT** | IN  pkt #296 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187465 | yapp monitor | RX pkt #296 on the input: addr=1 len=2 parity=bad gap=20 |
| 187465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 187565 | **DUT** | IN  pkt #297 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187595 | **DUT** | IN  pkt #297 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187595 | yapp monitor | RX pkt #297 on the input: addr=1 len=2 parity=bad gap=9 |
| 187595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 187805 | **DUT** | IN  pkt #298 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187835 | **DUT** | IN  pkt #298 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187835 | yapp monitor | RX pkt #298 on the input: addr=1 len=2 parity=bad gap=20 |
| 187835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 188015 | **DUT** | IN  pkt #299 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188045 | **DUT** | IN  pkt #299 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188045 | yapp monitor | RX pkt #299 on the input: addr=1 len=2 parity=bad gap=17 |
| 188045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 188235 | **DUT** | IN  pkt #300 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188265 | **DUT** | IN  pkt #300 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188265 | yapp monitor | RX pkt #300 on the input: addr=1 len=2 parity=bad gap=18 |
| 188265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 188475 | **DUT** | IN  pkt #301 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188505 | **DUT** | IN  pkt #301 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188505 | yapp monitor | RX pkt #301 on the input: addr=1 len=2 parity=bad gap=20 |
| 188505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 188555 | **DUT** | IN  pkt #302 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188585 | **DUT** | IN  pkt #302 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188585 | yapp monitor | RX pkt #302 on the input: addr=1 len=2 parity=bad gap=4 |
| 188585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188650 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 188795 | **DUT** | IN  pkt #303 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188825 | **DUT** | IN  pkt #303 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188825 | yapp monitor | RX pkt #303 on the input: addr=1 len=2 parity=bad gap=20 |
| 188825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 188905 | **DUT** | IN  pkt #304 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188935 | **DUT** | IN  pkt #304 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188935 | yapp monitor | RX pkt #304 on the input: addr=1 len=2 parity=bad gap=7 |
| 188935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189030 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 189145 | **DUT** | IN  pkt #305 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189175 | **DUT** | IN  pkt #305 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189175 | yapp monitor | RX pkt #305 on the input: addr=1 len=2 parity=bad gap=20 |
| 189175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189175 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189190 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 189315 | **DUT** | IN  pkt #306 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189345 | **DUT** | IN  pkt #306 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189345 | yapp monitor | RX pkt #306 on the input: addr=1 len=2 parity=bad gap=13 |
| 189345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 189555 | **DUT** | IN  pkt #307 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189585 | **DUT** | IN  pkt #307 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189585 | yapp monitor | RX pkt #307 on the input: addr=1 len=2 parity=bad gap=20 |
| 189585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189615 | **DUT** | IN  pkt #308 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189645 | **DUT** | IN  pkt #308 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189645 | yapp monitor | RX pkt #308 on the input: addr=1 len=2 parity=bad gap=2 |
| 189645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 189710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 189855 | **DUT** | IN  pkt #309 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189885 | **DUT** | IN  pkt #309 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189885 | yapp monitor | RX pkt #309 on the input: addr=1 len=2 parity=bad gap=20 |
| 189885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189955 | **DUT** | IN  pkt #310 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 189985 | **DUT** | IN  pkt #310 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189985 | yapp monitor | RX pkt #310 on the input: addr=1 len=2 parity=bad gap=6 |
| 189985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 190195 | **DUT** | IN  pkt #311 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190225 | **DUT** | IN  pkt #311 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190225 | yapp monitor | RX pkt #311 on the input: addr=1 len=2 parity=bad gap=20 |
| 190225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 190355 | **DUT** | IN  pkt #312 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190385 | **DUT** | IN  pkt #312 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190385 | yapp monitor | RX pkt #312 on the input: addr=1 len=2 parity=bad gap=12 |
| 190385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 190585 | **DUT** | IN  pkt #313 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190615 | **DUT** | IN  pkt #313 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190615 | yapp monitor | RX pkt #313 on the input: addr=1 len=2 parity=bad gap=19 |
| 190615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 190645 | **DUT** | IN  pkt #314 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190675 | **DUT** | IN  pkt #314 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190675 | yapp monitor | RX pkt #314 on the input: addr=1 len=2 parity=bad gap=2 |
| 190675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 190845 | **DUT** | IN  pkt #315 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190875 | **DUT** | IN  pkt #315 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190875 | yapp monitor | RX pkt #315 on the input: addr=1 len=2 parity=bad gap=16 |
| 190875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190875 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 190935 | **DUT** | IN  pkt #316 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190965 | **DUT** | IN  pkt #316 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190965 | yapp monitor | RX pkt #316 on the input: addr=1 len=2 parity=bad gap=5 |
| 190965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 191035 | **DUT** | IN  pkt #317 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191065 | **DUT** | IN  pkt #317 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191065 | yapp monitor | RX pkt #317 on the input: addr=1 len=2 parity=bad gap=6 |
| 191065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 191245 | **DUT** | IN  pkt #318 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191275 | **DUT** | IN  pkt #318 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191275 | yapp monitor | RX pkt #318 on the input: addr=1 len=2 parity=bad gap=17 |
| 191275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 191485 | **DUT** | IN  pkt #319 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191515 | **DUT** | IN  pkt #319 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191515 | yapp monitor | RX pkt #319 on the input: addr=1 len=2 parity=bad gap=20 |
| 191515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 191695 | **DUT** | IN  pkt #320 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191725 | **DUT** | IN  pkt #320 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191725 | yapp monitor | RX pkt #320 on the input: addr=1 len=2 parity=bad gap=17 |
| 191725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 191935 | **DUT** | IN  pkt #321 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191965 | **DUT** | IN  pkt #321 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191965 | yapp monitor | RX pkt #321 on the input: addr=1 len=2 parity=bad gap=20 |
| 191965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 192085 | **DUT** | IN  pkt #322 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192115 | **DUT** | IN  pkt #322 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192115 | yapp monitor | RX pkt #322 on the input: addr=1 len=2 parity=bad gap=11 |
| 192115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 192275 | **DUT** | IN  pkt #323 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192305 | **DUT** | IN  pkt #323 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192305 | yapp monitor | RX pkt #323 on the input: addr=1 len=2 parity=bad gap=15 |
| 192305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192305 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192375 | **DUT** | IN  pkt #324 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192405 | **DUT** | IN  pkt #324 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192405 | yapp monitor | RX pkt #324 on the input: addr=1 len=2 parity=bad gap=6 |
| 192405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192410 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 192450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 192605 | **DUT** | IN  pkt #325 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192635 | **DUT** | IN  pkt #325 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192635 | yapp monitor | RX pkt #325 on the input: addr=1 len=2 parity=bad gap=19 |
| 192635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 192665 | **DUT** | IN  pkt #326 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192695 | **DUT** | IN  pkt #326 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192695 | yapp monitor | RX pkt #326 on the input: addr=1 len=2 parity=bad gap=2 |
| 192695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192710 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 192815 | **DUT** | IN  pkt #327 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192845 | **DUT** | IN  pkt #327 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192845 | yapp monitor | RX pkt #327 on the input: addr=1 len=2 parity=bad gap=11 |
| 192845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192845 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 193045 | **DUT** | IN  pkt #328 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193075 | **DUT** | IN  pkt #328 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193075 | yapp monitor | RX pkt #328 on the input: addr=1 len=2 parity=bad gap=19 |
| 193075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 193285 | **DUT** | IN  pkt #329 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193315 | **DUT** | IN  pkt #329 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193315 | yapp monitor | RX pkt #329 on the input: addr=1 len=2 parity=bad gap=20 |
| 193315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 193435 | **DUT** | IN  pkt #330 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193465 | **DUT** | IN  pkt #330 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193465 | yapp monitor | RX pkt #330 on the input: addr=1 len=2 parity=bad gap=11 |
| 193465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193510 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 193575 | **DUT** | IN  pkt #331 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193605 | **DUT** | IN  pkt #331 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193605 | yapp monitor | RX pkt #331 on the input: addr=1 len=2 parity=bad gap=10 |
| 193605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 193695 | **DUT** | IN  pkt #332 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193725 | **DUT** | IN  pkt #332 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193725 | yapp monitor | RX pkt #332 on the input: addr=1 len=2 parity=bad gap=8 |
| 193725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 193935 | **DUT** | IN  pkt #333 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193965 | **DUT** | IN  pkt #333 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193965 | yapp monitor | RX pkt #333 on the input: addr=1 len=2 parity=bad gap=20 |
| 193965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 194145 | **DUT** | IN  pkt #334 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194175 | **DUT** | IN  pkt #334 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194175 | yapp monitor | RX pkt #334 on the input: addr=1 len=2 parity=bad gap=17 |
| 194175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194175 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194195 | **DUT** | IN  pkt #335 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194225 | **DUT** | IN  pkt #335 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194225 | yapp monitor | RX pkt #335 on the input: addr=1 len=2 parity=bad gap=1 |
| 194225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 194285 | **DUT** | IN  pkt #336 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194315 | **DUT** | IN  pkt #336 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194315 | yapp monitor | RX pkt #336 on the input: addr=1 len=2 parity=bad gap=5 |
| 194315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 194350 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 194525 | **DUT** | IN  pkt #337 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194555 | **DUT** | IN  pkt #337 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194555 | yapp monitor | RX pkt #337 on the input: addr=1 len=2 parity=bad gap=20 |
| 194555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 194685 | **DUT** | IN  pkt #338 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194715 | **DUT** | IN  pkt #338 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194715 | yapp monitor | RX pkt #338 on the input: addr=1 len=2 parity=bad gap=12 |
| 194715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 194835 | **DUT** | IN  pkt #339 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194865 | **DUT** | IN  pkt #339 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194865 | yapp monitor | RX pkt #339 on the input: addr=1 len=2 parity=bad gap=11 |
| 194865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194865 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 195005 | **DUT** | IN  pkt #340 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195035 | **DUT** | IN  pkt #340 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195035 | yapp monitor | RX pkt #340 on the input: addr=1 len=2 parity=bad gap=13 |
| 195035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 195055 | **DUT** | IN  pkt #341 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195085 | **DUT** | IN  pkt #341 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195085 | yapp monitor | RX pkt #341 on the input: addr=1 len=2 parity=bad gap=1 |
| 195085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195105 | **DUT** | IN  pkt #342 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195135 | **DUT** | IN  pkt #342 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195135 | yapp monitor | RX pkt #342 on the input: addr=1 len=2 parity=bad gap=1 |
| 195135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 195190 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 195345 | **DUT** | IN  pkt #343 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195375 | **DUT** | IN  pkt #343 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195375 | yapp monitor | RX pkt #343 on the input: addr=1 len=2 parity=bad gap=20 |
| 195375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 195515 | **DUT** | IN  pkt #344 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195545 | **DUT** | IN  pkt #344 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195545 | yapp monitor | RX pkt #344 on the input: addr=1 len=2 parity=bad gap=13 |
| 195545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 195725 | **DUT** | IN  pkt #345 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195755 | **DUT** | IN  pkt #345 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195755 | yapp monitor | RX pkt #345 on the input: addr=1 len=2 parity=bad gap=17 |
| 195755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195775 | **DUT** | IN  pkt #346 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 195805 | **DUT** | IN  pkt #346 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195805 | yapp monitor | RX pkt #346 on the input: addr=1 len=2 parity=bad gap=1 |
| 195805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 195995 | **DUT** | IN  pkt #347 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196025 | **DUT** | IN  pkt #347 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196025 | yapp monitor | RX pkt #347 on the input: addr=1 len=2 parity=bad gap=18 |
| 196025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196045 | **DUT** | IN  pkt #348 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 196075 | **DUT** | IN  pkt #348 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196075 | yapp monitor | RX pkt #348 on the input: addr=1 len=2 parity=bad gap=1 |
| 196075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196110 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 196135 | **DUT** | IN  pkt #349 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196165 | **DUT** | IN  pkt #349 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196165 | yapp monitor | RX pkt #349 on the input: addr=1 len=2 parity=bad gap=5 |
| 196165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 196335 | **DUT** | IN  pkt #350 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196365 | **DUT** | IN  pkt #350 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196365 | yapp monitor | RX pkt #350 on the input: addr=1 len=2 parity=bad gap=16 |
| 196365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 196575 | **DUT** | IN  pkt #351 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196605 | **DUT** | IN  pkt #351 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196605 | yapp monitor | RX pkt #351 on the input: addr=1 len=2 parity=bad gap=20 |
| 196605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 196815 | **DUT** | IN  pkt #352 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196845 | **DUT** | IN  pkt #352 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196845 | yapp monitor | RX pkt #352 on the input: addr=1 len=2 parity=bad gap=20 |
| 196845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196845 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 197035 | **DUT** | IN  pkt #353 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197065 | **DUT** | IN  pkt #353 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197065 | yapp monitor | RX pkt #353 on the input: addr=1 len=2 parity=bad gap=18 |
| 197065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 197225 | **DUT** | IN  pkt #354 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197255 | **DUT** | IN  pkt #354 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197255 | yapp monitor | RX pkt #354 on the input: addr=1 len=2 parity=bad gap=15 |
| 197255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 197445 | **DUT** | IN  pkt #355 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197475 | **DUT** | IN  pkt #355 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197475 | yapp monitor | RX pkt #355 on the input: addr=1 len=2 parity=bad gap=18 |
| 197475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197475 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 197685 | **DUT** | IN  pkt #356 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197715 | **DUT** | IN  pkt #356 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197715 | yapp monitor | RX pkt #356 on the input: addr=1 len=2 parity=bad gap=20 |
| 197715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197755 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 197785 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 197790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 197815 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 197845 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 197875 | hbus monitor | Collected READ  addr=0x100a data=0x64 |
| 197905 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 198115 | **DUT** | IN  pkt #357 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198145 | **DUT** | IN  pkt #357 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198145 | yapp monitor | RX pkt #357 on the input: addr=1 len=2 parity=bad gap=39 |
| 198145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 198315 | **DUT** | IN  pkt #358 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198345 | **DUT** | IN  pkt #358 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198345 | yapp monitor | RX pkt #358 on the input: addr=1 len=2 parity=bad gap=16 |
| 198345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198365 | **DUT** | IN  pkt #359 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198395 | **DUT** | IN  pkt #359 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198395 | yapp monitor | RX pkt #359 on the input: addr=1 len=2 parity=bad gap=1 |
| 198395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198410 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 198420 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 198605 | **DUT** | IN  pkt #360 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198635 | **DUT** | IN  pkt #360 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198635 | yapp monitor | RX pkt #360 on the input: addr=1 len=2 parity=bad gap=20 |
| 198635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198670 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 198785 | **DUT** | IN  pkt #361 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198815 | **DUT** | IN  pkt #361 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198815 | yapp monitor | RX pkt #361 on the input: addr=1 len=2 parity=bad gap=14 |
| 198815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198815 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 198945 | **DUT** | IN  pkt #362 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198975 | **DUT** | IN  pkt #362 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198975 | yapp monitor | RX pkt #362 on the input: addr=1 len=2 parity=bad gap=12 |
| 198975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 199055 | **DUT** | IN  pkt #363 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199085 | **DUT** | IN  pkt #363 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199085 | yapp monitor | RX pkt #363 on the input: addr=1 len=2 parity=bad gap=7 |
| 199085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199295 | **DUT** | IN  pkt #364 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199325 | **DUT** | IN  pkt #364 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199325 | yapp monitor | RX pkt #364 on the input: addr=1 len=2 parity=bad gap=20 |
| 199325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 199535 | **DUT** | IN  pkt #365 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199565 | **DUT** | IN  pkt #365 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199565 | yapp monitor | RX pkt #365 on the input: addr=1 len=2 parity=bad gap=20 |
| 199565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199565 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199755 | **DUT** | IN  pkt #366 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199785 | **DUT** | IN  pkt #366 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199785 | yapp monitor | RX pkt #366 on the input: addr=1 len=2 parity=bad gap=18 |
| 199785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199995 | **DUT** | IN  pkt #367 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200025 | **DUT** | IN  pkt #367 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200025 | yapp monitor | RX pkt #367 on the input: addr=1 len=2 parity=bad gap=20 |
| 200025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 200235 | **DUT** | IN  pkt #368 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200265 | **DUT** | IN  pkt #368 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200265 | yapp monitor | RX pkt #368 on the input: addr=1 len=2 parity=bad gap=20 |
| 200265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 200475 | **DUT** | IN  pkt #369 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200505 | **DUT** | IN  pkt #369 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200505 | yapp monitor | RX pkt #369 on the input: addr=1 len=2 parity=bad gap=20 |
| 200505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 200675 | **DUT** | IN  pkt #370 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200705 | **DUT** | IN  pkt #370 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200705 | yapp monitor | RX pkt #370 on the input: addr=1 len=2 parity=bad gap=16 |
| 200705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 200915 | **DUT** | IN  pkt #371 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200945 | **DUT** | IN  pkt #371 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200945 | yapp monitor | RX pkt #371 on the input: addr=1 len=2 parity=bad gap=20 |
| 200945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201045 | **DUT** | IN  pkt #372 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 201075 | **DUT** | IN  pkt #372 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201075 | yapp monitor | RX pkt #372 on the input: addr=1 len=2 parity=bad gap=9 |
| 201075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 201285 | **DUT** | IN  pkt #373 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201315 | **DUT** | IN  pkt #373 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201315 | yapp monitor | RX pkt #373 on the input: addr=1 len=2 parity=bad gap=20 |
| 201315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 201525 | **DUT** | IN  pkt #374 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201555 | **DUT** | IN  pkt #374 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201555 | yapp monitor | RX pkt #374 on the input: addr=1 len=2 parity=bad gap=20 |
| 201555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201605 | **DUT** | IN  pkt #375 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 201635 | **DUT** | IN  pkt #375 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201635 | yapp monitor | RX pkt #375 on the input: addr=1 len=2 parity=bad gap=4 |
| 201635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201655 | **DUT** | IN  pkt #376 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201685 | **DUT** | IN  pkt #376 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201685 | yapp monitor | RX pkt #376 on the input: addr=1 len=2 parity=bad gap=1 |
| 201685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201685 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 201730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 201885 | **DUT** | IN  pkt #377 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201915 | **DUT** | IN  pkt #377 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201915 | yapp monitor | RX pkt #377 on the input: addr=1 len=2 parity=bad gap=19 |
| 201915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 202035 | **DUT** | IN  pkt #378 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202065 | **DUT** | IN  pkt #378 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202065 | yapp monitor | RX pkt #378 on the input: addr=1 len=2 parity=bad gap=11 |
| 202065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 202265 | **DUT** | IN  pkt #379 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202295 | **DUT** | IN  pkt #379 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202295 | yapp monitor | RX pkt #379 on the input: addr=1 len=2 parity=bad gap=19 |
| 202295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 202475 | **DUT** | IN  pkt #380 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202505 | **DUT** | IN  pkt #380 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202505 | yapp monitor | RX pkt #380 on the input: addr=1 len=2 parity=bad gap=17 |
| 202505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 202715 | **DUT** | IN  pkt #381 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202745 | **DUT** | IN  pkt #381 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202745 | yapp monitor | RX pkt #381 on the input: addr=1 len=2 parity=bad gap=20 |
| 202745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202745 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 202915 | **DUT** | IN  pkt #382 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202945 | **DUT** | IN  pkt #382 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202945 | yapp monitor | RX pkt #382 on the input: addr=1 len=2 parity=bad gap=16 |
| 202945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 203135 | **DUT** | IN  pkt #383 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203165 | **DUT** | IN  pkt #383 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203165 | yapp monitor | RX pkt #383 on the input: addr=1 len=2 parity=bad gap=18 |
| 203165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 203365 | **DUT** | IN  pkt #384 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203395 | **DUT** | IN  pkt #384 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203395 | yapp monitor | RX pkt #384 on the input: addr=1 len=2 parity=bad gap=19 |
| 203395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 203485 | **DUT** | IN  pkt #385 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203515 | **DUT** | IN  pkt #385 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203515 | yapp monitor | RX pkt #385 on the input: addr=1 len=2 parity=bad gap=8 |
| 203515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 203685 | **DUT** | IN  pkt #386 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203715 | **DUT** | IN  pkt #386 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203715 | yapp monitor | RX pkt #386 on the input: addr=1 len=2 parity=bad gap=16 |
| 203715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 203925 | **DUT** | IN  pkt #387 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203955 | **DUT** | IN  pkt #387 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203955 | yapp monitor | RX pkt #387 on the input: addr=1 len=2 parity=bad gap=20 |
| 203955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 204165 | **DUT** | IN  pkt #388 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204195 | **DUT** | IN  pkt #388 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204195 | yapp monitor | RX pkt #388 on the input: addr=1 len=2 parity=bad gap=20 |
| 204195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 204405 | **DUT** | IN  pkt #389 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204435 | **DUT** | IN  pkt #389 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204435 | yapp monitor | RX pkt #389 on the input: addr=1 len=2 parity=bad gap=20 |
| 204435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204435 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204510 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 204645 | **DUT** | IN  pkt #390 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204675 | **DUT** | IN  pkt #390 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204675 | yapp monitor | RX pkt #390 on the input: addr=1 len=2 parity=bad gap=20 |
| 204675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 204865 | **DUT** | IN  pkt #391 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204895 | **DUT** | IN  pkt #391 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204895 | yapp monitor | RX pkt #391 on the input: addr=1 len=2 parity=bad gap=18 |
| 204895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 205065 | **DUT** | IN  pkt #392 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205095 | **DUT** | IN  pkt #392 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205095 | yapp monitor | RX pkt #392 on the input: addr=1 len=2 parity=bad gap=16 |
| 205095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205095 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205125 | **DUT** | IN  pkt #393 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205155 | **DUT** | IN  pkt #393 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205155 | yapp monitor | RX pkt #393 on the input: addr=1 len=2 parity=bad gap=2 |
| 205155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 205210 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 205365 | **DUT** | IN  pkt #394 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205395 | **DUT** | IN  pkt #394 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205395 | yapp monitor | RX pkt #394 on the input: addr=1 len=2 parity=bad gap=20 |
| 205395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 205605 | **DUT** | IN  pkt #395 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205635 | **DUT** | IN  pkt #395 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205635 | yapp monitor | RX pkt #395 on the input: addr=1 len=2 parity=bad gap=20 |
| 205635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 205825 | **DUT** | IN  pkt #396 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205855 | **DUT** | IN  pkt #396 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205855 | yapp monitor | RX pkt #396 on the input: addr=1 len=2 parity=bad gap=18 |
| 205855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205855 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 206035 | **DUT** | IN  pkt #397 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206065 | **DUT** | IN  pkt #397 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206065 | yapp monitor | RX pkt #397 on the input: addr=1 len=2 parity=bad gap=17 |
| 206065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 206275 | **DUT** | IN  pkt #398 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206305 | **DUT** | IN  pkt #398 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206305 | yapp monitor | RX pkt #398 on the input: addr=1 len=2 parity=bad gap=20 |
| 206305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206305 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 206475 | **DUT** | IN  pkt #399 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206505 | **DUT** | IN  pkt #399 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206505 | yapp monitor | RX pkt #399 on the input: addr=1 len=2 parity=bad gap=16 |
| 206505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 206615 | **DUT** | IN  pkt #400 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206645 | **DUT** | IN  pkt #400 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206645 | yapp monitor | RX pkt #400 on the input: addr=1 len=2 parity=bad gap=10 |
| 206645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 206855 | **DUT** | IN  pkt #401 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206885 | **DUT** | IN  pkt #401 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206885 | yapp monitor | RX pkt #401 on the input: addr=1 len=2 parity=bad gap=20 |
| 206885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 206935 | **DUT** | IN  pkt #402 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206965 | **DUT** | IN  pkt #402 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206965 | yapp monitor | RX pkt #402 on the input: addr=1 len=2 parity=bad gap=4 |
| 206965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206995 | **DUT** | IN  pkt #403 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 207025 | **DUT** | IN  pkt #403 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207025 | yapp monitor | RX pkt #403 on the input: addr=1 len=2 parity=bad gap=2 |
| 207025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 207205 | **DUT** | IN  pkt #404 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207235 | **DUT** | IN  pkt #404 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207235 | yapp monitor | RX pkt #404 on the input: addr=1 len=2 parity=bad gap=17 |
| 207235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 207295 | **DUT** | IN  pkt #405 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207325 | **DUT** | IN  pkt #405 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207325 | yapp monitor | RX pkt #405 on the input: addr=1 len=2 parity=bad gap=5 |
| 207325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 207535 | **DUT** | IN  pkt #406 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207565 | **DUT** | IN  pkt #406 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207565 | yapp monitor | RX pkt #406 on the input: addr=1 len=2 parity=bad gap=20 |
| 207565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207565 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 207775 | **DUT** | IN  pkt #407 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207805 | **DUT** | IN  pkt #407 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207805 | yapp monitor | RX pkt #407 on the input: addr=1 len=2 parity=bad gap=20 |
| 207805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 208015 | **DUT** | IN  pkt #408 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208045 | **DUT** | IN  pkt #408 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208045 | yapp monitor | RX pkt #408 on the input: addr=1 len=2 parity=bad gap=20 |
| 208045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 208255 | **DUT** | IN  pkt #409 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208285 | **DUT** | IN  pkt #409 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208285 | yapp monitor | RX pkt #409 on the input: addr=1 len=2 parity=bad gap=20 |
| 208285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 208445 | **DUT** | IN  pkt #410 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208475 | **DUT** | IN  pkt #410 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208475 | yapp monitor | RX pkt #410 on the input: addr=1 len=2 parity=bad gap=15 |
| 208475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208475 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 208615 | **DUT** | IN  pkt #411 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208645 | **DUT** | IN  pkt #411 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208645 | yapp monitor | RX pkt #411 on the input: addr=1 len=2 parity=bad gap=13 |
| 208645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 208855 | **DUT** | IN  pkt #412 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208885 | **DUT** | IN  pkt #412 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208885 | yapp monitor | RX pkt #412 on the input: addr=1 len=2 parity=bad gap=20 |
| 208885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208915 | **DUT** | IN  pkt #413 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 208945 | **DUT** | IN  pkt #413 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208945 | yapp monitor | RX pkt #413 on the input: addr=1 len=2 parity=bad gap=2 |
| 208945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 209155 | **DUT** | IN  pkt #414 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209185 | **DUT** | IN  pkt #414 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209185 | yapp monitor | RX pkt #414 on the input: addr=1 len=2 parity=bad gap=20 |
| 209185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 209355 | **DUT** | IN  pkt #415 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209385 | **DUT** | IN  pkt #415 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209385 | yapp monitor | RX pkt #415 on the input: addr=1 len=2 parity=bad gap=16 |
| 209385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 209595 | **DUT** | IN  pkt #416 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209625 | **DUT** | IN  pkt #416 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209625 | yapp monitor | RX pkt #416 on the input: addr=1 len=2 parity=bad gap=20 |
| 209625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209625 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 209695 | **DUT** | IN  pkt #417 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209725 | **DUT** | IN  pkt #417 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209725 | yapp monitor | RX pkt #417 on the input: addr=1 len=2 parity=bad gap=6 |
| 209725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 209825 | **DUT** | IN  pkt #418 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209855 | **DUT** | IN  pkt #418 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209855 | yapp monitor | RX pkt #418 on the input: addr=1 len=2 parity=bad gap=9 |
| 209855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209855 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 210045 | **DUT** | IN  pkt #419 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210075 | **DUT** | IN  pkt #419 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210075 | yapp monitor | RX pkt #419 on the input: addr=1 len=2 parity=bad gap=18 |
| 210075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 210245 | **DUT** | IN  pkt #420 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210275 | **DUT** | IN  pkt #420 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210275 | yapp monitor | RX pkt #420 on the input: addr=1 len=2 parity=bad gap=16 |
| 210275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 210355 | **DUT** | IN  pkt #421 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210385 | **DUT** | IN  pkt #421 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210385 | yapp monitor | RX pkt #421 on the input: addr=1 len=2 parity=bad gap=7 |
| 210385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 210555 | **DUT** | IN  pkt #422 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210585 | **DUT** | IN  pkt #422 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210585 | yapp monitor | RX pkt #422 on the input: addr=1 len=2 parity=bad gap=16 |
| 210585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210615 | **DUT** | IN  pkt #423 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 210645 | **DUT** | IN  pkt #423 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210645 | yapp monitor | RX pkt #423 on the input: addr=1 len=2 parity=bad gap=2 |
| 210645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210665 | **DUT** | IN  pkt #424 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 210695 | **DUT** | IN  pkt #424 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210695 | yapp monitor | RX pkt #424 on the input: addr=1 len=2 parity=bad gap=1 |
| 210695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 210905 | **DUT** | IN  pkt #425 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210935 | **DUT** | IN  pkt #425 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210935 | yapp monitor | RX pkt #425 on the input: addr=1 len=2 parity=bad gap=20 |
| 210935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 211125 | **DUT** | IN  pkt #426 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211155 | **DUT** | IN  pkt #426 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211155 | yapp monitor | RX pkt #426 on the input: addr=1 len=2 parity=bad gap=18 |
| 211155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211230 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 211285 | **DUT** | IN  pkt #427 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211315 | **DUT** | IN  pkt #427 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211315 | yapp monitor | RX pkt #427 on the input: addr=1 len=2 parity=bad gap=12 |
| 211315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211365 | **DUT** | IN  pkt #428 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 211395 | **DUT** | IN  pkt #428 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211395 | yapp monitor | RX pkt #428 on the input: addr=1 len=2 parity=bad gap=4 |
| 211395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 211595 | **DUT** | IN  pkt #429 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211625 | **DUT** | IN  pkt #429 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211625 | yapp monitor | RX pkt #429 on the input: addr=1 len=2 parity=bad gap=19 |
| 211625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211625 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211665 | **DUT** | IN  pkt #430 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211690 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 211695 | **DUT** | IN  pkt #430 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211695 | yapp monitor | RX pkt #430 on the input: addr=1 len=2 parity=bad gap=3 |
| 211695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 211905 | **DUT** | IN  pkt #431 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211935 | **DUT** | IN  pkt #431 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211935 | yapp monitor | RX pkt #431 on the input: addr=1 len=2 parity=bad gap=20 |
| 211935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211990 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 212015 | **DUT** | IN  pkt #432 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212045 | **DUT** | IN  pkt #432 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212045 | yapp monitor | RX pkt #432 on the input: addr=1 len=2 parity=bad gap=7 |
| 212045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 212185 | **DUT** | IN  pkt #433 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212215 | **DUT** | IN  pkt #433 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212215 | yapp monitor | RX pkt #433 on the input: addr=1 len=2 parity=bad gap=13 |
| 212215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212230 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 212415 | **DUT** | IN  pkt #434 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212445 | **DUT** | IN  pkt #434 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212445 | yapp monitor | RX pkt #434 on the input: addr=1 len=2 parity=bad gap=19 |
| 212445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 212575 | **DUT** | IN  pkt #435 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212605 | **DUT** | IN  pkt #435 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212605 | yapp monitor | RX pkt #435 on the input: addr=1 len=2 parity=bad gap=12 |
| 212605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 212815 | **DUT** | IN  pkt #436 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212845 | **DUT** | IN  pkt #436 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212845 | yapp monitor | RX pkt #436 on the input: addr=1 len=2 parity=bad gap=20 |
| 212845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212845 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 212915 | **DUT** | IN  pkt #437 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212945 | **DUT** | IN  pkt #437 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212945 | yapp monitor | RX pkt #437 on the input: addr=1 len=2 parity=bad gap=6 |
| 212945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 213105 | **DUT** | IN  pkt #438 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213135 | **DUT** | IN  pkt #438 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213135 | yapp monitor | RX pkt #438 on the input: addr=1 len=2 parity=bad gap=15 |
| 213135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 213345 | **DUT** | IN  pkt #439 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213375 | **DUT** | IN  pkt #439 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213375 | yapp monitor | RX pkt #439 on the input: addr=1 len=2 parity=bad gap=20 |
| 213375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 213585 | **DUT** | IN  pkt #440 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213615 | **DUT** | IN  pkt #440 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213615 | yapp monitor | RX pkt #440 on the input: addr=1 len=2 parity=bad gap=20 |
| 213615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 213775 | **DUT** | IN  pkt #441 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213805 | **DUT** | IN  pkt #441 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213805 | yapp monitor | RX pkt #441 on the input: addr=1 len=2 parity=bad gap=15 |
| 213805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 213955 | **DUT** | IN  pkt #442 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213985 | **DUT** | IN  pkt #442 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213985 | yapp monitor | RX pkt #442 on the input: addr=1 len=2 parity=bad gap=14 |
| 213985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214005 | **DUT** | IN  pkt #443 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 214035 | **DUT** | IN  pkt #443 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214035 | yapp monitor | RX pkt #443 on the input: addr=1 len=2 parity=bad gap=1 |
| 214035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214055 | **DUT** | IN  pkt #444 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214085 | **DUT** | IN  pkt #444 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214085 | yapp monitor | RX pkt #444 on the input: addr=1 len=2 parity=bad gap=1 |
| 214085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 214120 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214245 | **DUT** | IN  pkt #445 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214275 | **DUT** | IN  pkt #445 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214275 | yapp monitor | RX pkt #445 on the input: addr=1 len=2 parity=bad gap=15 |
| 214275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 214475 | **DUT** | IN  pkt #446 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214505 | **DUT** | IN  pkt #446 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214505 | yapp monitor | RX pkt #446 on the input: addr=1 len=2 parity=bad gap=19 |
| 214505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 214575 | **DUT** | IN  pkt #447 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214605 | **DUT** | IN  pkt #447 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214605 | yapp monitor | RX pkt #447 on the input: addr=1 len=2 parity=bad gap=6 |
| 214605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 214695 | **DUT** | IN  pkt #448 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214725 | **DUT** | IN  pkt #448 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214725 | yapp monitor | RX pkt #448 on the input: addr=1 len=2 parity=bad gap=8 |
| 214725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214750 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 214825 | **DUT** | IN  pkt #449 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214855 | **DUT** | IN  pkt #449 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214855 | yapp monitor | RX pkt #449 on the input: addr=1 len=2 parity=bad gap=9 |
| 214855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214855 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 215025 | **DUT** | IN  pkt #450 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215055 | **DUT** | IN  pkt #450 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215055 | yapp monitor | RX pkt #450 on the input: addr=1 len=2 parity=bad gap=16 |
| 215055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215055 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 215105 | **DUT** | IN  pkt #451 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215135 | **DUT** | IN  pkt #451 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215135 | yapp monitor | RX pkt #451 on the input: addr=1 len=2 parity=bad gap=4 |
| 215135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215190 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 215225 | **DUT** | IN  pkt #452 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215255 | **DUT** | IN  pkt #452 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215255 | yapp monitor | RX pkt #452 on the input: addr=1 len=2 parity=bad gap=8 |
| 215255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 215435 | **DUT** | IN  pkt #453 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215465 | **DUT** | IN  pkt #453 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215465 | yapp monitor | RX pkt #453 on the input: addr=1 len=2 parity=bad gap=17 |
| 215465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 215675 | **DUT** | IN  pkt #454 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215705 | **DUT** | IN  pkt #454 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215705 | yapp monitor | RX pkt #454 on the input: addr=1 len=2 parity=bad gap=20 |
| 215705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215725 | **DUT** | IN  pkt #455 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215750 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 215755 | **DUT** | IN  pkt #455 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215755 | yapp monitor | RX pkt #455 on the input: addr=1 len=2 parity=bad gap=1 |
| 215755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 215925 | **DUT** | IN  pkt #456 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215955 | **DUT** | IN  pkt #456 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215955 | yapp monitor | RX pkt #456 on the input: addr=1 len=2 parity=bad gap=16 |
| 215955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216015 | **DUT** | IN  pkt #457 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 216045 | **DUT** | IN  pkt #457 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216045 | yapp monitor | RX pkt #457 on the input: addr=1 len=2 parity=bad gap=5 |
| 216045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 216155 | **DUT** | IN  pkt #458 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216185 | **DUT** | IN  pkt #458 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216185 | yapp monitor | RX pkt #458 on the input: addr=1 len=2 parity=bad gap=10 |
| 216185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 216385 | **DUT** | IN  pkt #459 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216415 | **DUT** | IN  pkt #459 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216415 | yapp monitor | RX pkt #459 on the input: addr=1 len=2 parity=bad gap=19 |
| 216415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216470 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 216605 | **DUT** | IN  pkt #460 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216635 | **DUT** | IN  pkt #460 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216635 | yapp monitor | RX pkt #460 on the input: addr=1 len=2 parity=bad gap=18 |
| 216635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 216835 | **DUT** | IN  pkt #461 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216865 | **DUT** | IN  pkt #461 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216865 | yapp monitor | RX pkt #461 on the input: addr=1 len=2 parity=bad gap=19 |
| 216865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216865 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 217075 | **DUT** | IN  pkt #462 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217105 | **DUT** | IN  pkt #462 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217105 | yapp monitor | RX pkt #462 on the input: addr=1 len=2 parity=bad gap=20 |
| 217105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 217315 | **DUT** | IN  pkt #463 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217345 | **DUT** | IN  pkt #463 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217345 | yapp monitor | RX pkt #463 on the input: addr=1 len=2 parity=bad gap=20 |
| 217345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 217555 | **DUT** | IN  pkt #464 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217585 | **DUT** | IN  pkt #464 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217585 | yapp monitor | RX pkt #464 on the input: addr=1 len=2 parity=bad gap=20 |
| 217585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 217775 | **DUT** | IN  pkt #465 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217805 | **DUT** | IN  pkt #465 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217805 | yapp monitor | RX pkt #465 on the input: addr=1 len=2 parity=bad gap=18 |
| 217805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 217945 | **DUT** | IN  pkt #466 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217975 | **DUT** | IN  pkt #466 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217975 | yapp monitor | RX pkt #466 on the input: addr=1 len=2 parity=bad gap=13 |
| 217975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 218075 | **DUT** | IN  pkt #467 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218105 | **DUT** | IN  pkt #467 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218105 | yapp monitor | RX pkt #467 on the input: addr=1 len=2 parity=bad gap=9 |
| 218105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 218225 | **DUT** | IN  pkt #468 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218255 | **DUT** | IN  pkt #468 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218255 | yapp monitor | RX pkt #468 on the input: addr=1 len=2 parity=bad gap=11 |
| 218255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 218365 | **DUT** | IN  pkt #469 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218395 | **DUT** | IN  pkt #469 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218395 | yapp monitor | RX pkt #469 on the input: addr=1 len=2 parity=bad gap=10 |
| 218395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218410 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 218495 | **DUT** | IN  pkt #470 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218525 | **DUT** | IN  pkt #470 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218525 | yapp monitor | RX pkt #470 on the input: addr=1 len=2 parity=bad gap=9 |
| 218525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218525 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 218735 | **DUT** | IN  pkt #471 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218765 | **DUT** | IN  pkt #471 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218765 | yapp monitor | RX pkt #471 on the input: addr=1 len=2 parity=bad gap=20 |
| 218765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 218955 | **DUT** | IN  pkt #472 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218985 | **DUT** | IN  pkt #472 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218985 | yapp monitor | RX pkt #472 on the input: addr=1 len=2 parity=bad gap=18 |
| 218985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219015 | **DUT** | IN  pkt #473 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219045 | **DUT** | IN  pkt #473 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219045 | yapp monitor | RX pkt #473 on the input: addr=1 len=2 parity=bad gap=2 |
| 219045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 219070 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 219195 | **DUT** | IN  pkt #474 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219225 | **DUT** | IN  pkt #474 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219225 | yapp monitor | RX pkt #474 on the input: addr=1 len=2 parity=bad gap=14 |
| 219225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 219435 | **DUT** | IN  pkt #475 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219465 | **DUT** | IN  pkt #475 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219465 | yapp monitor | RX pkt #475 on the input: addr=1 len=2 parity=bad gap=20 |
| 219465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 219675 | **DUT** | IN  pkt #476 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219705 | **DUT** | IN  pkt #476 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219705 | yapp monitor | RX pkt #476 on the input: addr=1 len=2 parity=bad gap=20 |
| 219705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219750 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 219785 | **DUT** | IN  pkt #477 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219815 | **DUT** | IN  pkt #477 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219815 | yapp monitor | RX pkt #477 on the input: addr=1 len=2 parity=bad gap=7 |
| 219815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219815 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219855 | **DUT** | IN  pkt #478 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219885 | **DUT** | IN  pkt #478 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219885 | yapp monitor | RX pkt #478 on the input: addr=1 len=2 parity=bad gap=3 |
| 219885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219910 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 219950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 220035 | **DUT** | IN  pkt #479 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220065 | **DUT** | IN  pkt #479 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220065 | yapp monitor | RX pkt #479 on the input: addr=1 len=2 parity=bad gap=14 |
| 220065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 220175 | **DUT** | IN  pkt #480 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220205 | **DUT** | IN  pkt #480 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220205 | yapp monitor | RX pkt #480 on the input: addr=1 len=2 parity=bad gap=10 |
| 220205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220225 | **DUT** | IN  pkt #481 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220255 | **DUT** | IN  pkt #481 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220255 | yapp monitor | RX pkt #481 on the input: addr=1 len=2 parity=bad gap=1 |
| 220255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220270 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 220310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 220345 | **DUT** | IN  pkt #482 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220375 | **DUT** | IN  pkt #482 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220375 | yapp monitor | RX pkt #482 on the input: addr=1 len=2 parity=bad gap=8 |
| 220375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 220545 | **DUT** | IN  pkt #483 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220575 | **DUT** | IN  pkt #483 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220575 | yapp monitor | RX pkt #483 on the input: addr=1 len=2 parity=bad gap=16 |
| 220575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220605 | **DUT** | IN  pkt #484 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 220635 | **DUT** | IN  pkt #484 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220635 | yapp monitor | RX pkt #484 on the input: addr=1 len=2 parity=bad gap=2 |
| 220635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 220755 | **DUT** | IN  pkt #485 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220785 | **DUT** | IN  pkt #485 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220785 | yapp monitor | RX pkt #485 on the input: addr=1 len=2 parity=bad gap=11 |
| 220785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 220995 | **DUT** | IN  pkt #486 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221025 | **DUT** | IN  pkt #486 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221025 | yapp monitor | RX pkt #486 on the input: addr=1 len=2 parity=bad gap=20 |
| 221025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 221195 | **DUT** | IN  pkt #487 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221225 | **DUT** | IN  pkt #487 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221225 | yapp monitor | RX pkt #487 on the input: addr=1 len=2 parity=bad gap=16 |
| 221225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221290 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 221365 | **DUT** | IN  pkt #488 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221395 | **DUT** | IN  pkt #488 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221395 | yapp monitor | RX pkt #488 on the input: addr=1 len=2 parity=bad gap=13 |
| 221395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 221475 | **DUT** | IN  pkt #489 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221505 | **DUT** | IN  pkt #489 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221505 | yapp monitor | RX pkt #489 on the input: addr=1 len=2 parity=bad gap=7 |
| 221505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 221715 | **DUT** | IN  pkt #490 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221745 | **DUT** | IN  pkt #490 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221745 | yapp monitor | RX pkt #490 on the input: addr=1 len=2 parity=bad gap=20 |
| 221745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221745 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 221905 | **DUT** | IN  pkt #491 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221935 | **DUT** | IN  pkt #491 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221935 | yapp monitor | RX pkt #491 on the input: addr=1 len=2 parity=bad gap=15 |
| 221935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 222135 | **DUT** | IN  pkt #492 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222165 | **DUT** | IN  pkt #492 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222165 | yapp monitor | RX pkt #492 on the input: addr=1 len=2 parity=bad gap=19 |
| 222165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 222365 | **DUT** | IN  pkt #493 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222395 | **DUT** | IN  pkt #493 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222395 | yapp monitor | RX pkt #493 on the input: addr=1 len=2 parity=bad gap=19 |
| 222395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222410 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 222515 | **DUT** | IN  pkt #494 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222545 | **DUT** | IN  pkt #494 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222545 | yapp monitor | RX pkt #494 on the input: addr=1 len=2 parity=bad gap=11 |
| 222545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 222755 | **DUT** | IN  pkt #495 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222785 | **DUT** | IN  pkt #495 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222785 | yapp monitor | RX pkt #495 on the input: addr=1 len=2 parity=bad gap=20 |
| 222785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 222995 | **DUT** | IN  pkt #496 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223025 | **DUT** | IN  pkt #496 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223025 | yapp monitor | RX pkt #496 on the input: addr=1 len=2 parity=bad gap=20 |
| 223025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 223225 | **DUT** | IN  pkt #497 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223255 | **DUT** | IN  pkt #497 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223255 | yapp monitor | RX pkt #497 on the input: addr=1 len=2 parity=bad gap=19 |
| 223255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 223415 | **DUT** | IN  pkt #498 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223445 | **DUT** | IN  pkt #498 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223445 | yapp monitor | RX pkt #498 on the input: addr=1 len=2 parity=bad gap=15 |
| 223445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223490 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 223635 | **DUT** | IN  pkt #499 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223665 | **DUT** | IN  pkt #499 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223665 | yapp monitor | RX pkt #499 on the input: addr=1 len=2 parity=bad gap=18 |
| 223665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223665 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 223855 | **DUT** | IN  pkt #500 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223885 | **DUT** | IN  pkt #500 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223885 | yapp monitor | RX pkt #500 on the input: addr=1 len=2 parity=bad gap=18 |
| 223885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 224075 | **DUT** | IN  pkt #501 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224105 | **DUT** | IN  pkt #501 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224105 | yapp monitor | RX pkt #501 on the input: addr=1 len=2 parity=bad gap=18 |
| 224105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 224285 | **DUT** | IN  pkt #502 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224315 | **DUT** | IN  pkt #502 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224315 | yapp monitor | RX pkt #502 on the input: addr=1 len=2 parity=bad gap=17 |
| 224315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 224515 | **DUT** | IN  pkt #503 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224545 | **DUT** | IN  pkt #503 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224545 | yapp monitor | RX pkt #503 on the input: addr=1 len=2 parity=bad gap=19 |
| 224545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 224755 | **DUT** | IN  pkt #504 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224785 | **DUT** | IN  pkt #504 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224785 | yapp monitor | RX pkt #504 on the input: addr=1 len=2 parity=bad gap=20 |
| 224785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 224945 | **DUT** | IN  pkt #505 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224975 | **DUT** | IN  pkt #505 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224975 | yapp monitor | RX pkt #505 on the input: addr=1 len=2 parity=bad gap=15 |
| 224975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 225185 | **DUT** | IN  pkt #506 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225215 | **DUT** | IN  pkt #506 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225215 | yapp monitor | RX pkt #506 on the input: addr=1 len=2 parity=bad gap=20 |
| 225215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 225425 | **DUT** | IN  pkt #507 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225455 | **DUT** | IN  pkt #507 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225455 | yapp monitor | RX pkt #507 on the input: addr=1 len=2 parity=bad gap=20 |
| 225455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225455 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 225505 | **DUT** | IN  pkt #508 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225535 | **DUT** | IN  pkt #508 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225535 | yapp monitor | RX pkt #508 on the input: addr=1 len=2 parity=bad gap=4 |
| 225535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 225625 | **DUT** | IN  pkt #509 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225655 | **DUT** | IN  pkt #509 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225655 | yapp monitor | RX pkt #509 on the input: addr=1 len=2 parity=bad gap=8 |
| 225655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 225825 | **DUT** | IN  pkt #510 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225855 | **DUT** | IN  pkt #510 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225855 | yapp monitor | RX pkt #510 on the input: addr=1 len=2 parity=bad gap=16 |
| 225855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225855 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 226045 | **DUT** | IN  pkt #511 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226075 | **DUT** | IN  pkt #511 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226075 | yapp monitor | RX pkt #511 on the input: addr=1 len=2 parity=bad gap=18 |
| 226075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 226075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 226090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 226115 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 226145 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 226175 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 226205 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 226235 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 226260 | **test** | STAGE: 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 226265 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 226285 | hbus monitor | Collected WRITE addr=0x1001 data=0x41 |
| 226285 | reference | router_en is now 1 (en_reg 0x41) |
| 226495 | **DUT** | IN  pkt #512 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226525 | **DUT** | IN  pkt #512 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226525 | yapp monitor | RX pkt #512 on the input: addr=2 len=2 parity=bad gap=41 |
| 226525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226575 | **DUT** | IN  pkt #513 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226605 | **DUT** | IN  pkt #513 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226605 | yapp monitor | RX pkt #513 on the input: addr=2 len=2 parity=bad gap=4 |
| 226605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226605 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 226670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 226815 | **DUT** | IN  pkt #514 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226845 | **DUT** | IN  pkt #514 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226845 | yapp monitor | RX pkt #514 on the input: addr=2 len=2 parity=bad gap=20 |
| 226845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 227035 | **DUT** | IN  pkt #515 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227065 | **DUT** | IN  pkt #515 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227065 | yapp monitor | RX pkt #515 on the input: addr=2 len=2 parity=bad gap=18 |
| 227065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 227145 | **DUT** | IN  pkt #516 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227175 | **DUT** | IN  pkt #516 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227175 | yapp monitor | RX pkt #516 on the input: addr=2 len=2 parity=bad gap=7 |
| 227175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 227345 | **DUT** | IN  pkt #517 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227375 | **DUT** | IN  pkt #517 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227375 | yapp monitor | RX pkt #517 on the input: addr=2 len=2 parity=bad gap=16 |
| 227375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 227545 | **DUT** | IN  pkt #518 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227575 | **DUT** | IN  pkt #518 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227575 | yapp monitor | RX pkt #518 on the input: addr=2 len=2 parity=bad gap=16 |
| 227575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 227625 | **DUT** | IN  pkt #519 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227655 | **DUT** | IN  pkt #519 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227655 | yapp monitor | RX pkt #519 on the input: addr=2 len=2 parity=bad gap=4 |
| 227655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 227765 | **DUT** | IN  pkt #520 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227795 | **DUT** | IN  pkt #520 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227795 | yapp monitor | RX pkt #520 on the input: addr=2 len=2 parity=bad gap=10 |
| 227795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 227985 | **DUT** | IN  pkt #521 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228015 | **DUT** | IN  pkt #521 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228015 | yapp monitor | RX pkt #521 on the input: addr=2 len=2 parity=bad gap=18 |
| 228015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 228185 | **DUT** | IN  pkt #522 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228215 | **DUT** | IN  pkt #522 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228215 | yapp monitor | RX pkt #522 on the input: addr=2 len=2 parity=bad gap=16 |
| 228215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228230 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 228415 | **DUT** | IN  pkt #523 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228445 | **DUT** | IN  pkt #523 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228445 | yapp monitor | RX pkt #523 on the input: addr=2 len=2 parity=bad gap=19 |
| 228445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228465 | **DUT** | IN  pkt #524 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228495 | **DUT** | IN  pkt #524 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228495 | yapp monitor | RX pkt #524 on the input: addr=2 len=2 parity=bad gap=1 |
| 228495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 228540 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 228705 | **DUT** | IN  pkt #525 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228735 | **DUT** | IN  pkt #525 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228735 | yapp monitor | RX pkt #525 on the input: addr=2 len=2 parity=bad gap=20 |
| 228735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228785 | **DUT** | IN  pkt #526 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 228815 | **DUT** | IN  pkt #526 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228815 | yapp monitor | RX pkt #526 on the input: addr=2 len=2 parity=bad gap=4 |
| 228815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 228895 | **DUT** | IN  pkt #527 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228925 | **DUT** | IN  pkt #527 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228925 | yapp monitor | RX pkt #527 on the input: addr=2 len=2 parity=bad gap=7 |
| 228925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 229035 | **DUT** | IN  pkt #528 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229065 | **DUT** | IN  pkt #528 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229065 | yapp monitor | RX pkt #528 on the input: addr=2 len=2 parity=bad gap=10 |
| 229065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 229245 | **DUT** | IN  pkt #529 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229275 | **DUT** | IN  pkt #529 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229275 | yapp monitor | RX pkt #529 on the input: addr=2 len=2 parity=bad gap=17 |
| 229275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 229485 | **DUT** | IN  pkt #530 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229515 | **DUT** | IN  pkt #530 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229515 | yapp monitor | RX pkt #530 on the input: addr=2 len=2 parity=bad gap=20 |
| 229515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229545 | **DUT** | IN  pkt #531 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 229575 | **DUT** | IN  pkt #531 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229575 | yapp monitor | RX pkt #531 on the input: addr=2 len=2 parity=bad gap=2 |
| 229575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229625 | **DUT** | IN  pkt #532 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229655 | **DUT** | IN  pkt #532 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229655 | yapp monitor | RX pkt #532 on the input: addr=2 len=2 parity=bad gap=4 |
| 229655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 229680 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 229755 | **DUT** | IN  pkt #533 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229785 | **DUT** | IN  pkt #533 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229785 | yapp monitor | RX pkt #533 on the input: addr=2 len=2 parity=bad gap=9 |
| 229785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 229985 | **DUT** | IN  pkt #534 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230015 | **DUT** | IN  pkt #534 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230015 | yapp monitor | RX pkt #534 on the input: addr=2 len=2 parity=bad gap=19 |
| 230015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 230225 | **DUT** | IN  pkt #535 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230255 | **DUT** | IN  pkt #535 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230255 | yapp monitor | RX pkt #535 on the input: addr=2 len=2 parity=bad gap=20 |
| 230255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 230455 | **DUT** | IN  pkt #536 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230485 | **DUT** | IN  pkt #536 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230485 | yapp monitor | RX pkt #536 on the input: addr=2 len=2 parity=bad gap=19 |
| 230485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230485 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230530 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 230625 | **DUT** | IN  pkt #537 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230655 | **DUT** | IN  pkt #537 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230655 | yapp monitor | RX pkt #537 on the input: addr=2 len=2 parity=bad gap=13 |
| 230655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 230825 | **DUT** | IN  pkt #538 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230855 | **DUT** | IN  pkt #538 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230855 | yapp monitor | RX pkt #538 on the input: addr=2 len=2 parity=bad gap=16 |
| 230855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230905 | **DUT** | IN  pkt #539 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230935 | **DUT** | IN  pkt #539 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230935 | yapp monitor | RX pkt #539 on the input: addr=2 len=2 parity=bad gap=4 |
| 230935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 230960 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 231115 | **DUT** | IN  pkt #540 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231145 | **DUT** | IN  pkt #540 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231145 | yapp monitor | RX pkt #540 on the input: addr=2 len=2 parity=bad gap=17 |
| 231145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 231285 | **DUT** | IN  pkt #541 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231315 | **DUT** | IN  pkt #541 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231315 | yapp monitor | RX pkt #541 on the input: addr=2 len=2 parity=bad gap=13 |
| 231315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231365 | **DUT** | IN  pkt #542 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 231395 | **DUT** | IN  pkt #542 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231395 | yapp monitor | RX pkt #542 on the input: addr=2 len=2 parity=bad gap=4 |
| 231395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231395 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231445 | **DUT** | IN  pkt #543 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 231475 | **DUT** | IN  pkt #543 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231475 | yapp monitor | RX pkt #543 on the input: addr=2 len=2 parity=bad gap=4 |
| 231475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231505 | **DUT** | IN  pkt #544 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231535 | **DUT** | IN  pkt #544 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231535 | yapp monitor | RX pkt #544 on the input: addr=2 len=2 parity=bad gap=2 |
| 231535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 231570 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 231635 | **DUT** | IN  pkt #545 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231665 | **DUT** | IN  pkt #545 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231665 | yapp monitor | RX pkt #545 on the input: addr=2 len=2 parity=bad gap=9 |
| 231665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 231795 | **DUT** | IN  pkt #546 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231825 | **DUT** | IN  pkt #546 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231825 | yapp monitor | RX pkt #546 on the input: addr=2 len=2 parity=bad gap=12 |
| 231825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231855 | **DUT** | IN  pkt #547 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231885 | **DUT** | IN  pkt #547 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231885 | yapp monitor | RX pkt #547 on the input: addr=2 len=2 parity=bad gap=2 |
| 231885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231915 | **DUT** | IN  pkt #548 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 231945 | **DUT** | IN  pkt #548 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231945 | yapp monitor | RX pkt #548 on the input: addr=2 len=2 parity=bad gap=2 |
| 231945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 232010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 232155 | **DUT** | IN  pkt #549 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232185 | **DUT** | IN  pkt #549 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232185 | yapp monitor | RX pkt #549 on the input: addr=2 len=2 parity=bad gap=20 |
| 232185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 232395 | **DUT** | IN  pkt #550 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232425 | **DUT** | IN  pkt #550 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232425 | yapp monitor | RX pkt #550 on the input: addr=2 len=2 parity=bad gap=20 |
| 232425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 232545 | **DUT** | IN  pkt #551 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232575 | **DUT** | IN  pkt #551 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232575 | yapp monitor | RX pkt #551 on the input: addr=2 len=2 parity=bad gap=11 |
| 232575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 232785 | **DUT** | IN  pkt #552 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232815 | **DUT** | IN  pkt #552 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232815 | yapp monitor | RX pkt #552 on the input: addr=2 len=2 parity=bad gap=20 |
| 232815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 233025 | **DUT** | IN  pkt #553 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233055 | **DUT** | IN  pkt #553 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233055 | yapp monitor | RX pkt #553 on the input: addr=2 len=2 parity=bad gap=20 |
| 233055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 233115 | **DUT** | IN  pkt #554 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233145 | **DUT** | IN  pkt #554 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233145 | yapp monitor | RX pkt #554 on the input: addr=2 len=2 parity=bad gap=5 |
| 233145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 233225 | **DUT** | IN  pkt #555 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233255 | **DUT** | IN  pkt #555 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233255 | yapp monitor | RX pkt #555 on the input: addr=2 len=2 parity=bad gap=7 |
| 233255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 233465 | **DUT** | IN  pkt #556 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233495 | **DUT** | IN  pkt #556 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233495 | yapp monitor | RX pkt #556 on the input: addr=2 len=2 parity=bad gap=20 |
| 233495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 233515 | **DUT** | IN  pkt #557 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233545 | **DUT** | IN  pkt #557 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233545 | yapp monitor | RX pkt #557 on the input: addr=2 len=2 parity=bad gap=1 |
| 233545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 233665 | **DUT** | IN  pkt #558 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233695 | **DUT** | IN  pkt #558 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233695 | yapp monitor | RX pkt #558 on the input: addr=2 len=2 parity=bad gap=11 |
| 233695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 233865 | **DUT** | IN  pkt #559 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233895 | **DUT** | IN  pkt #559 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233895 | yapp monitor | RX pkt #559 on the input: addr=2 len=2 parity=bad gap=16 |
| 233895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233955 | **DUT** | IN  pkt #560 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233985 | **DUT** | IN  pkt #560 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233985 | yapp monitor | RX pkt #560 on the input: addr=2 len=2 parity=bad gap=5 |
| 233985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 234010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 234195 | **DUT** | IN  pkt #561 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234225 | **DUT** | IN  pkt #561 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234225 | yapp monitor | RX pkt #561 on the input: addr=2 len=2 parity=bad gap=20 |
| 234225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234275 | **DUT** | IN  pkt #562 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234305 | **DUT** | IN  pkt #562 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234305 | yapp monitor | RX pkt #562 on the input: addr=2 len=2 parity=bad gap=4 |
| 234305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 234340 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 234485 | **DUT** | IN  pkt #563 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234515 | **DUT** | IN  pkt #563 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234515 | yapp monitor | RX pkt #563 on the input: addr=2 len=2 parity=bad gap=17 |
| 234515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 234715 | **DUT** | IN  pkt #564 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234745 | **DUT** | IN  pkt #564 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234745 | yapp monitor | RX pkt #564 on the input: addr=2 len=2 parity=bad gap=19 |
| 234745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234895 | **DUT** | IN  pkt #565 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234925 | **DUT** | IN  pkt #565 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234925 | yapp monitor | RX pkt #565 on the input: addr=2 len=2 parity=bad gap=14 |
| 234925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 235135 | **DUT** | IN  pkt #566 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235165 | **DUT** | IN  pkt #566 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235165 | yapp monitor | RX pkt #566 on the input: addr=2 len=2 parity=bad gap=20 |
| 235165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 235375 | **DUT** | IN  pkt #567 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235405 | **DUT** | IN  pkt #567 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235405 | yapp monitor | RX pkt #567 on the input: addr=2 len=2 parity=bad gap=20 |
| 235405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 235525 | **DUT** | IN  pkt #568 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235555 | **DUT** | IN  pkt #568 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235555 | yapp monitor | RX pkt #568 on the input: addr=2 len=2 parity=bad gap=11 |
| 235555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235555 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 235685 | **DUT** | IN  pkt #569 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235715 | **DUT** | IN  pkt #569 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235715 | yapp monitor | RX pkt #569 on the input: addr=2 len=2 parity=bad gap=12 |
| 235715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235765 | **DUT** | IN  pkt #570 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 235795 | **DUT** | IN  pkt #570 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235795 | yapp monitor | RX pkt #570 on the input: addr=2 len=2 parity=bad gap=4 |
| 235795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 236005 | **DUT** | IN  pkt #571 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236035 | **DUT** | IN  pkt #571 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236035 | yapp monitor | RX pkt #571 on the input: addr=2 len=2 parity=bad gap=20 |
| 236035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 236155 | **DUT** | IN  pkt #572 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236185 | **DUT** | IN  pkt #572 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236185 | yapp monitor | RX pkt #572 on the input: addr=2 len=2 parity=bad gap=11 |
| 236185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 236395 | **DUT** | IN  pkt #573 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236425 | **DUT** | IN  pkt #573 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236425 | yapp monitor | RX pkt #573 on the input: addr=2 len=2 parity=bad gap=20 |
| 236425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 236635 | **DUT** | IN  pkt #574 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236665 | **DUT** | IN  pkt #574 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236665 | yapp monitor | RX pkt #574 on the input: addr=2 len=2 parity=bad gap=20 |
| 236665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 236845 | **DUT** | IN  pkt #575 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236875 | **DUT** | IN  pkt #575 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236875 | yapp monitor | RX pkt #575 on the input: addr=2 len=2 parity=bad gap=17 |
| 236875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236910 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 237075 | **DUT** | IN  pkt #576 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237105 | **DUT** | IN  pkt #576 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237105 | yapp monitor | RX pkt #576 on the input: addr=2 len=2 parity=bad gap=19 |
| 237105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 237245 | **DUT** | IN  pkt #577 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237275 | **DUT** | IN  pkt #577 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237275 | yapp monitor | RX pkt #577 on the input: addr=2 len=2 parity=bad gap=13 |
| 237275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 237425 | **DUT** | IN  pkt #578 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237455 | **DUT** | IN  pkt #578 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237455 | yapp monitor | RX pkt #578 on the input: addr=2 len=2 parity=bad gap=14 |
| 237455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 237495 | **DUT** | IN  pkt #579 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237525 | **DUT** | IN  pkt #579 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237525 | yapp monitor | RX pkt #579 on the input: addr=2 len=2 parity=bad gap=3 |
| 237525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 237685 | **DUT** | IN  pkt #580 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237715 | **DUT** | IN  pkt #580 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237715 | yapp monitor | RX pkt #580 on the input: addr=2 len=2 parity=bad gap=15 |
| 237715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 237835 | **DUT** | IN  pkt #581 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237865 | **DUT** | IN  pkt #581 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237865 | yapp monitor | RX pkt #581 on the input: addr=2 len=2 parity=bad gap=11 |
| 237865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 238005 | **DUT** | IN  pkt #582 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238035 | **DUT** | IN  pkt #582 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238035 | yapp monitor | RX pkt #582 on the input: addr=2 len=2 parity=bad gap=13 |
| 238035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 238145 | **DUT** | IN  pkt #583 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238175 | **DUT** | IN  pkt #583 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238175 | yapp monitor | RX pkt #583 on the input: addr=2 len=2 parity=bad gap=10 |
| 238175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 238375 | **DUT** | IN  pkt #584 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238405 | **DUT** | IN  pkt #584 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238405 | yapp monitor | RX pkt #584 on the input: addr=2 len=2 parity=bad gap=19 |
| 238405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 238585 | **DUT** | IN  pkt #585 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238615 | **DUT** | IN  pkt #585 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238615 | yapp monitor | RX pkt #585 on the input: addr=2 len=2 parity=bad gap=17 |
| 238615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 238825 | **DUT** | IN  pkt #586 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238855 | **DUT** | IN  pkt #586 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238855 | yapp monitor | RX pkt #586 on the input: addr=2 len=2 parity=bad gap=20 |
| 238855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 239065 | **DUT** | IN  pkt #587 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239095 | **DUT** | IN  pkt #587 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239095 | yapp monitor | RX pkt #587 on the input: addr=2 len=2 parity=bad gap=20 |
| 239095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239110 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 239135 | **DUT** | IN  pkt #588 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239165 | **DUT** | IN  pkt #588 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239165 | yapp monitor | RX pkt #588 on the input: addr=2 len=2 parity=bad gap=3 |
| 239165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239185 | **DUT** | IN  pkt #589 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239215 | **DUT** | IN  pkt #589 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239215 | yapp monitor | RX pkt #589 on the input: addr=2 len=2 parity=bad gap=1 |
| 239215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 239260 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 239385 | **DUT** | IN  pkt #590 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239415 | **DUT** | IN  pkt #590 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239415 | yapp monitor | RX pkt #590 on the input: addr=2 len=2 parity=bad gap=16 |
| 239415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 239625 | **DUT** | IN  pkt #591 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239655 | **DUT** | IN  pkt #591 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239655 | yapp monitor | RX pkt #591 on the input: addr=2 len=2 parity=bad gap=20 |
| 239655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 239815 | **DUT** | IN  pkt #592 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239845 | **DUT** | IN  pkt #592 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239845 | yapp monitor | RX pkt #592 on the input: addr=2 len=2 parity=bad gap=15 |
| 239845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 240055 | **DUT** | IN  pkt #593 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240085 | **DUT** | IN  pkt #593 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240085 | yapp monitor | RX pkt #593 on the input: addr=2 len=2 parity=bad gap=20 |
| 240085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 240275 | **DUT** | IN  pkt #594 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240305 | **DUT** | IN  pkt #594 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240305 | yapp monitor | RX pkt #594 on the input: addr=2 len=2 parity=bad gap=18 |
| 240305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240410 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 240515 | **DUT** | IN  pkt #595 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240545 | **DUT** | IN  pkt #595 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240545 | yapp monitor | RX pkt #595 on the input: addr=2 len=2 parity=bad gap=20 |
| 240545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 240755 | **DUT** | IN  pkt #596 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240785 | **DUT** | IN  pkt #596 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240785 | yapp monitor | RX pkt #596 on the input: addr=2 len=2 parity=bad gap=20 |
| 240785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 240995 | **DUT** | IN  pkt #597 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241025 | **DUT** | IN  pkt #597 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241025 | yapp monitor | RX pkt #597 on the input: addr=2 len=2 parity=bad gap=20 |
| 241025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 241225 | **DUT** | IN  pkt #598 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241255 | **DUT** | IN  pkt #598 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241255 | yapp monitor | RX pkt #598 on the input: addr=2 len=2 parity=bad gap=19 |
| 241255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 241465 | **DUT** | IN  pkt #599 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241495 | **DUT** | IN  pkt #599 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241495 | yapp monitor | RX pkt #599 on the input: addr=2 len=2 parity=bad gap=20 |
| 241495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 241515 | **DUT** | IN  pkt #600 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241545 | **DUT** | IN  pkt #600 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241545 | yapp monitor | RX pkt #600 on the input: addr=2 len=2 parity=bad gap=1 |
| 241545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 241655 | **DUT** | IN  pkt #601 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241685 | **DUT** | IN  pkt #601 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241685 | yapp monitor | RX pkt #601 on the input: addr=2 len=2 parity=bad gap=10 |
| 241685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 241895 | **DUT** | IN  pkt #602 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241925 | **DUT** | IN  pkt #602 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241925 | yapp monitor | RX pkt #602 on the input: addr=2 len=2 parity=bad gap=20 |
| 241925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241950 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 242125 | **DUT** | IN  pkt #603 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242155 | **DUT** | IN  pkt #603 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242155 | yapp monitor | RX pkt #603 on the input: addr=2 len=2 parity=bad gap=19 |
| 242155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242155 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 242355 | **DUT** | IN  pkt #604 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242385 | **DUT** | IN  pkt #604 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242385 | yapp monitor | RX pkt #604 on the input: addr=2 len=2 parity=bad gap=19 |
| 242385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242385 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242465 | **DUT** | IN  pkt #605 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 242495 | **DUT** | IN  pkt #605 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242495 | yapp monitor | RX pkt #605 on the input: addr=2 len=2 parity=bad gap=7 |
| 242495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 242565 | **DUT** | IN  pkt #606 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242595 | **DUT** | IN  pkt #606 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242595 | yapp monitor | RX pkt #606 on the input: addr=2 len=2 parity=bad gap=6 |
| 242595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242595 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 242705 | **DUT** | IN  pkt #607 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242735 | **DUT** | IN  pkt #607 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242735 | yapp monitor | RX pkt #607 on the input: addr=2 len=2 parity=bad gap=10 |
| 242735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 242775 | **DUT** | IN  pkt #608 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242805 | **DUT** | IN  pkt #608 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242805 | yapp monitor | RX pkt #608 on the input: addr=2 len=2 parity=bad gap=3 |
| 242805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242850 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 242895 | **DUT** | IN  pkt #609 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242925 | **DUT** | IN  pkt #609 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242925 | yapp monitor | RX pkt #609 on the input: addr=2 len=2 parity=bad gap=8 |
| 242925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243135 | **DUT** | IN  pkt #610 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243165 | **DUT** | IN  pkt #610 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243165 | yapp monitor | RX pkt #610 on the input: addr=2 len=2 parity=bad gap=20 |
| 243165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243245 | **DUT** | IN  pkt #611 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 243275 | **DUT** | IN  pkt #611 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243275 | yapp monitor | RX pkt #611 on the input: addr=2 len=2 parity=bad gap=7 |
| 243275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 243315 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 243345 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 243375 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 243405 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 243435 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 243465 | hbus monitor | Collected READ  addr=0x100b data=0x64 |
| 243515 | **DUT** | IN  pkt #612 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243545 | **DUT** | IN  pkt #612 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243545 | yapp monitor | RX pkt #612 on the input: addr=2 len=2 parity=bad gap=23 |
| 243545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 243755 | **DUT** | IN  pkt #613 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243785 | **DUT** | IN  pkt #613 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243785 | yapp monitor | RX pkt #613 on the input: addr=2 len=2 parity=bad gap=20 |
| 243785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243915 | **DUT** | IN  pkt #614 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243945 | **DUT** | IN  pkt #614 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243945 | yapp monitor | RX pkt #614 on the input: addr=2 len=2 parity=bad gap=12 |
| 243945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 244155 | **DUT** | IN  pkt #615 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244185 | **DUT** | IN  pkt #615 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244185 | yapp monitor | RX pkt #615 on the input: addr=2 len=2 parity=bad gap=20 |
| 244185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 244305 | **DUT** | IN  pkt #616 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244335 | **DUT** | IN  pkt #616 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244335 | yapp monitor | RX pkt #616 on the input: addr=2 len=2 parity=bad gap=11 |
| 244335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244335 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 244435 | **DUT** | IN  pkt #617 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244465 | **DUT** | IN  pkt #617 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244465 | yapp monitor | RX pkt #617 on the input: addr=2 len=2 parity=bad gap=9 |
| 244465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244555 | **DUT** | IN  pkt #618 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 244585 | **DUT** | IN  pkt #618 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244585 | yapp monitor | RX pkt #618 on the input: addr=2 len=2 parity=bad gap=8 |
| 244585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244650 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 244755 | **DUT** | IN  pkt #619 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244785 | **DUT** | IN  pkt #619 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244785 | yapp monitor | RX pkt #619 on the input: addr=2 len=2 parity=bad gap=16 |
| 244785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244815 | **DUT** | IN  pkt #620 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244845 | **DUT** | IN  pkt #620 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244845 | yapp monitor | RX pkt #620 on the input: addr=2 len=2 parity=bad gap=2 |
| 244845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 244910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 245055 | **DUT** | IN  pkt #621 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245085 | **DUT** | IN  pkt #621 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245085 | yapp monitor | RX pkt #621 on the input: addr=2 len=2 parity=bad gap=20 |
| 245085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245115 | **DUT** | IN  pkt #622 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245145 | **DUT** | IN  pkt #622 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245145 | yapp monitor | RX pkt #622 on the input: addr=2 len=2 parity=bad gap=2 |
| 245145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 245190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 245345 | **DUT** | IN  pkt #623 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245375 | **DUT** | IN  pkt #623 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245375 | yapp monitor | RX pkt #623 on the input: addr=2 len=2 parity=bad gap=19 |
| 245375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 245585 | **DUT** | IN  pkt #624 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245615 | **DUT** | IN  pkt #624 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245615 | yapp monitor | RX pkt #624 on the input: addr=2 len=2 parity=bad gap=20 |
| 245615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 245785 | **DUT** | IN  pkt #625 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245815 | **DUT** | IN  pkt #625 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245815 | yapp monitor | RX pkt #625 on the input: addr=2 len=2 parity=bad gap=16 |
| 245815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 245995 | **DUT** | IN  pkt #626 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246025 | **DUT** | IN  pkt #626 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246025 | yapp monitor | RX pkt #626 on the input: addr=2 len=2 parity=bad gap=17 |
| 246025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 246175 | **DUT** | IN  pkt #627 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246205 | **DUT** | IN  pkt #627 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246205 | yapp monitor | RX pkt #627 on the input: addr=2 len=2 parity=bad gap=14 |
| 246205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246205 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 246295 | **DUT** | IN  pkt #628 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246325 | **DUT** | IN  pkt #628 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246325 | yapp monitor | RX pkt #628 on the input: addr=2 len=2 parity=bad gap=8 |
| 246325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 246515 | **DUT** | IN  pkt #629 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246545 | **DUT** | IN  pkt #629 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246545 | yapp monitor | RX pkt #629 on the input: addr=2 len=2 parity=bad gap=18 |
| 246545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 246715 | **DUT** | IN  pkt #630 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246745 | **DUT** | IN  pkt #630 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246745 | yapp monitor | RX pkt #630 on the input: addr=2 len=2 parity=bad gap=16 |
| 246745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 246915 | **DUT** | IN  pkt #631 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246945 | **DUT** | IN  pkt #631 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246945 | yapp monitor | RX pkt #631 on the input: addr=2 len=2 parity=bad gap=16 |
| 246945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 247155 | **DUT** | IN  pkt #632 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247185 | **DUT** | IN  pkt #632 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247185 | yapp monitor | RX pkt #632 on the input: addr=2 len=2 parity=bad gap=20 |
| 247185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247285 | **DUT** | IN  pkt #633 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 247315 | **DUT** | IN  pkt #633 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247315 | yapp monitor | RX pkt #633 on the input: addr=2 len=2 parity=bad gap=9 |
| 247315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247335 | **DUT** | IN  pkt #634 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247365 | **DUT** | IN  pkt #634 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247365 | yapp monitor | RX pkt #634 on the input: addr=2 len=2 parity=bad gap=1 |
| 247365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247365 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 247400 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 247545 | **DUT** | IN  pkt #635 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247575 | **DUT** | IN  pkt #635 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247575 | yapp monitor | RX pkt #635 on the input: addr=2 len=2 parity=bad gap=17 |
| 247575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 247775 | **DUT** | IN  pkt #636 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247805 | **DUT** | IN  pkt #636 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247805 | yapp monitor | RX pkt #636 on the input: addr=2 len=2 parity=bad gap=19 |
| 247805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 248015 | **DUT** | IN  pkt #637 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248045 | **DUT** | IN  pkt #637 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248045 | yapp monitor | RX pkt #637 on the input: addr=2 len=2 parity=bad gap=20 |
| 248045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 248225 | **DUT** | IN  pkt #638 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248255 | **DUT** | IN  pkt #638 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248255 | yapp monitor | RX pkt #638 on the input: addr=2 len=2 parity=bad gap=17 |
| 248255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 248445 | **DUT** | IN  pkt #639 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248475 | **DUT** | IN  pkt #639 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248475 | yapp monitor | RX pkt #639 on the input: addr=2 len=2 parity=bad gap=18 |
| 248475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 248605 | **DUT** | IN  pkt #640 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248635 | **DUT** | IN  pkt #640 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248635 | yapp monitor | RX pkt #640 on the input: addr=2 len=2 parity=bad gap=12 |
| 248635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248635 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 248815 | **DUT** | IN  pkt #641 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248845 | **DUT** | IN  pkt #641 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248845 | yapp monitor | RX pkt #641 on the input: addr=2 len=2 parity=bad gap=17 |
| 248845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 248965 | **DUT** | IN  pkt #642 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248995 | **DUT** | IN  pkt #642 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248995 | yapp monitor | RX pkt #642 on the input: addr=2 len=2 parity=bad gap=11 |
| 248995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 249155 | **DUT** | IN  pkt #643 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249185 | **DUT** | IN  pkt #643 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249185 | yapp monitor | RX pkt #643 on the input: addr=2 len=2 parity=bad gap=15 |
| 249185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 249295 | **DUT** | IN  pkt #644 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249325 | **DUT** | IN  pkt #644 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249325 | yapp monitor | RX pkt #644 on the input: addr=2 len=2 parity=bad gap=10 |
| 249325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 249495 | **DUT** | IN  pkt #645 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249525 | **DUT** | IN  pkt #645 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249525 | yapp monitor | RX pkt #645 on the input: addr=2 len=2 parity=bad gap=16 |
| 249525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249545 | **DUT** | IN  pkt #646 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 249575 | **DUT** | IN  pkt #646 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249575 | yapp monitor | RX pkt #646 on the input: addr=2 len=2 parity=bad gap=1 |
| 249575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249665 | **DUT** | IN  pkt #647 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 249695 | **DUT** | IN  pkt #647 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249695 | yapp monitor | RX pkt #647 on the input: addr=2 len=2 parity=bad gap=8 |
| 249695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249735 | **DUT** | IN  pkt #648 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 249765 | **DUT** | IN  pkt #648 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249765 | yapp monitor | RX pkt #648 on the input: addr=2 len=2 parity=bad gap=3 |
| 249765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 249795 | **DUT** | IN  pkt #649 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249825 | **DUT** | IN  pkt #649 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249825 | yapp monitor | RX pkt #649 on the input: addr=2 len=2 parity=bad gap=2 |
| 249825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 249935 | **DUT** | IN  pkt #650 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249965 | **DUT** | IN  pkt #650 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249965 | yapp monitor | RX pkt #650 on the input: addr=2 len=2 parity=bad gap=10 |
| 249965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 250175 | **DUT** | IN  pkt #651 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250205 | **DUT** | IN  pkt #651 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250205 | yapp monitor | RX pkt #651 on the input: addr=2 len=2 parity=bad gap=20 |
| 250205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250205 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 250415 | **DUT** | IN  pkt #652 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250445 | **DUT** | IN  pkt #652 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250445 | yapp monitor | RX pkt #652 on the input: addr=2 len=2 parity=bad gap=20 |
| 250445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250465 | **DUT** | IN  pkt #653 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250495 | **DUT** | IN  pkt #653 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250495 | yapp monitor | RX pkt #653 on the input: addr=2 len=2 parity=bad gap=1 |
| 250495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 250550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 250705 | **DUT** | IN  pkt #654 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250735 | **DUT** | IN  pkt #654 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250735 | yapp monitor | RX pkt #654 on the input: addr=2 len=2 parity=bad gap=20 |
| 250735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 250935 | **DUT** | IN  pkt #655 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250965 | **DUT** | IN  pkt #655 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250965 | yapp monitor | RX pkt #655 on the input: addr=2 len=2 parity=bad gap=19 |
| 250965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 251035 | **DUT** | IN  pkt #656 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251065 | **DUT** | IN  pkt #656 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251065 | yapp monitor | RX pkt #656 on the input: addr=2 len=2 parity=bad gap=6 |
| 251065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 251255 | **DUT** | IN  pkt #657 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251285 | **DUT** | IN  pkt #657 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251285 | yapp monitor | RX pkt #657 on the input: addr=2 len=2 parity=bad gap=18 |
| 251285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251330 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 251495 | **DUT** | IN  pkt #658 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251525 | **DUT** | IN  pkt #658 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251525 | yapp monitor | RX pkt #658 on the input: addr=2 len=2 parity=bad gap=20 |
| 251525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 251725 | **DUT** | IN  pkt #659 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251755 | **DUT** | IN  pkt #659 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251755 | yapp monitor | RX pkt #659 on the input: addr=2 len=2 parity=bad gap=19 |
| 251755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251755 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 251965 | **DUT** | IN  pkt #660 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251995 | **DUT** | IN  pkt #660 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251995 | yapp monitor | RX pkt #660 on the input: addr=2 len=2 parity=bad gap=20 |
| 251995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 252035 | **DUT** | IN  pkt #661 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252065 | **DUT** | IN  pkt #661 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252065 | yapp monitor | RX pkt #661 on the input: addr=2 len=2 parity=bad gap=3 |
| 252065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252085 | **DUT** | IN  pkt #662 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 252115 | **DUT** | IN  pkt #662 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252115 | yapp monitor | RX pkt #662 on the input: addr=2 len=2 parity=bad gap=1 |
| 252115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252115 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252185 | **DUT** | IN  pkt #663 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 252215 | **DUT** | IN  pkt #663 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252215 | yapp monitor | RX pkt #663 on the input: addr=2 len=2 parity=bad gap=6 |
| 252215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252230 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 252395 | **DUT** | IN  pkt #664 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252425 | **DUT** | IN  pkt #664 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252425 | yapp monitor | RX pkt #664 on the input: addr=2 len=2 parity=bad gap=17 |
| 252425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 252635 | **DUT** | IN  pkt #665 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252665 | **DUT** | IN  pkt #665 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252665 | yapp monitor | RX pkt #665 on the input: addr=2 len=2 parity=bad gap=20 |
| 252665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 252835 | **DUT** | IN  pkt #666 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252865 | **DUT** | IN  pkt #666 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252865 | yapp monitor | RX pkt #666 on the input: addr=2 len=2 parity=bad gap=16 |
| 252865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 253075 | **DUT** | IN  pkt #667 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253105 | **DUT** | IN  pkt #667 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253105 | yapp monitor | RX pkt #667 on the input: addr=2 len=2 parity=bad gap=20 |
| 253105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 253315 | **DUT** | IN  pkt #668 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253345 | **DUT** | IN  pkt #668 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253345 | yapp monitor | RX pkt #668 on the input: addr=2 len=2 parity=bad gap=20 |
| 253345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 253425 | **DUT** | IN  pkt #669 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253455 | **DUT** | IN  pkt #669 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253455 | yapp monitor | RX pkt #669 on the input: addr=2 len=2 parity=bad gap=7 |
| 253455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 253615 | **DUT** | IN  pkt #670 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253645 | **DUT** | IN  pkt #670 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253645 | yapp monitor | RX pkt #670 on the input: addr=2 len=2 parity=bad gap=15 |
| 253645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 253775 | **DUT** | IN  pkt #671 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253805 | **DUT** | IN  pkt #671 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253805 | yapp monitor | RX pkt #671 on the input: addr=2 len=2 parity=bad gap=12 |
| 253805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 253975 | **DUT** | IN  pkt #672 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254005 | **DUT** | IN  pkt #672 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254005 | yapp monitor | RX pkt #672 on the input: addr=2 len=2 parity=bad gap=16 |
| 254005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 254155 | **DUT** | IN  pkt #673 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254185 | **DUT** | IN  pkt #673 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254185 | yapp monitor | RX pkt #673 on the input: addr=2 len=2 parity=bad gap=14 |
| 254185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254250 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 254395 | **DUT** | IN  pkt #674 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254425 | **DUT** | IN  pkt #674 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254425 | yapp monitor | RX pkt #674 on the input: addr=2 len=2 parity=bad gap=20 |
| 254425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 254495 | **DUT** | IN  pkt #675 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254525 | **DUT** | IN  pkt #675 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254525 | yapp monitor | RX pkt #675 on the input: addr=2 len=2 parity=bad gap=6 |
| 254525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 254695 | **DUT** | IN  pkt #676 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254725 | **DUT** | IN  pkt #676 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254725 | yapp monitor | RX pkt #676 on the input: addr=2 len=2 parity=bad gap=16 |
| 254725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254750 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 254915 | **DUT** | IN  pkt #677 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254945 | **DUT** | IN  pkt #677 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254945 | yapp monitor | RX pkt #677 on the input: addr=2 len=2 parity=bad gap=18 |
| 254945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 255155 | **DUT** | IN  pkt #678 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255185 | **DUT** | IN  pkt #678 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255185 | yapp monitor | RX pkt #678 on the input: addr=2 len=2 parity=bad gap=20 |
| 255185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 255365 | **DUT** | IN  pkt #679 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255395 | **DUT** | IN  pkt #679 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255395 | yapp monitor | RX pkt #679 on the input: addr=2 len=2 parity=bad gap=17 |
| 255395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255395 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 255605 | **DUT** | IN  pkt #680 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255635 | **DUT** | IN  pkt #680 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255635 | yapp monitor | RX pkt #680 on the input: addr=2 len=2 parity=bad gap=20 |
| 255635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255635 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255695 | **DUT** | IN  pkt #681 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 255725 | **DUT** | IN  pkt #681 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255725 | yapp monitor | RX pkt #681 on the input: addr=2 len=2 parity=bad gap=5 |
| 255725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 255845 | **DUT** | IN  pkt #682 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255875 | **DUT** | IN  pkt #682 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255875 | yapp monitor | RX pkt #682 on the input: addr=2 len=2 parity=bad gap=11 |
| 255875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255930 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 256025 | **DUT** | IN  pkt #683 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256055 | **DUT** | IN  pkt #683 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256055 | yapp monitor | RX pkt #683 on the input: addr=2 len=2 parity=bad gap=14 |
| 256055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 256105 | **DUT** | IN  pkt #684 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256135 | **DUT** | IN  pkt #684 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256135 | yapp monitor | RX pkt #684 on the input: addr=2 len=2 parity=bad gap=4 |
| 256135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 256345 | **DUT** | IN  pkt #685 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256375 | **DUT** | IN  pkt #685 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256375 | yapp monitor | RX pkt #685 on the input: addr=2 len=2 parity=bad gap=20 |
| 256375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 256425 | **DUT** | IN  pkt #686 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256455 | **DUT** | IN  pkt #686 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256455 | yapp monitor | RX pkt #686 on the input: addr=2 len=2 parity=bad gap=4 |
| 256455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 256595 | **DUT** | IN  pkt #687 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256625 | **DUT** | IN  pkt #687 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256625 | yapp monitor | RX pkt #687 on the input: addr=2 len=2 parity=bad gap=13 |
| 256625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256645 | **DUT** | IN  pkt #688 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256675 | **DUT** | IN  pkt #688 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256675 | yapp monitor | RX pkt #688 on the input: addr=2 len=2 parity=bad gap=1 |
| 256675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 256740 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 256885 | **DUT** | IN  pkt #689 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256915 | **DUT** | IN  pkt #689 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256915 | yapp monitor | RX pkt #689 on the input: addr=2 len=2 parity=bad gap=20 |
| 256915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 257125 | **DUT** | IN  pkt #690 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257155 | **DUT** | IN  pkt #690 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257155 | yapp monitor | RX pkt #690 on the input: addr=2 len=2 parity=bad gap=20 |
| 257155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257155 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257210 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 257345 | **DUT** | IN  pkt #691 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257375 | **DUT** | IN  pkt #691 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257375 | yapp monitor | RX pkt #691 on the input: addr=2 len=2 parity=bad gap=18 |
| 257375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 257445 | **DUT** | IN  pkt #692 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257475 | **DUT** | IN  pkt #692 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257475 | yapp monitor | RX pkt #692 on the input: addr=2 len=2 parity=bad gap=6 |
| 257475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 257685 | **DUT** | IN  pkt #693 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257715 | **DUT** | IN  pkt #693 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257715 | yapp monitor | RX pkt #693 on the input: addr=2 len=2 parity=bad gap=20 |
| 257715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257735 | **DUT** | IN  pkt #694 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257765 | **DUT** | IN  pkt #694 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257765 | yapp monitor | RX pkt #694 on the input: addr=2 len=2 parity=bad gap=1 |
| 257765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 257800 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 257965 | **DUT** | IN  pkt #695 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257995 | **DUT** | IN  pkt #695 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257995 | yapp monitor | RX pkt #695 on the input: addr=2 len=2 parity=bad gap=19 |
| 257995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 258185 | **DUT** | IN  pkt #696 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258215 | **DUT** | IN  pkt #696 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258215 | yapp monitor | RX pkt #696 on the input: addr=2 len=2 parity=bad gap=18 |
| 258215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 258385 | **DUT** | IN  pkt #697 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258415 | **DUT** | IN  pkt #697 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258415 | yapp monitor | RX pkt #697 on the input: addr=2 len=2 parity=bad gap=16 |
| 258415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258450 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 258625 | **DUT** | IN  pkt #698 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258655 | **DUT** | IN  pkt #698 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258655 | yapp monitor | RX pkt #698 on the input: addr=2 len=2 parity=bad gap=20 |
| 258655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 258825 | **DUT** | IN  pkt #699 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258855 | **DUT** | IN  pkt #699 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258855 | yapp monitor | RX pkt #699 on the input: addr=2 len=2 parity=bad gap=16 |
| 258855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 258975 | **DUT** | IN  pkt #700 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259005 | **DUT** | IN  pkt #700 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259005 | yapp monitor | RX pkt #700 on the input: addr=2 len=2 parity=bad gap=11 |
| 259005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 259165 | **DUT** | IN  pkt #701 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259195 | **DUT** | IN  pkt #701 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259195 | yapp monitor | RX pkt #701 on the input: addr=2 len=2 parity=bad gap=15 |
| 259195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259195 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 259405 | **DUT** | IN  pkt #702 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259435 | **DUT** | IN  pkt #702 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259435 | yapp monitor | RX pkt #702 on the input: addr=2 len=2 parity=bad gap=20 |
| 259435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 259645 | **DUT** | IN  pkt #703 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259675 | **DUT** | IN  pkt #703 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259675 | yapp monitor | RX pkt #703 on the input: addr=2 len=2 parity=bad gap=20 |
| 259675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 259715 | **DUT** | IN  pkt #704 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259745 | **DUT** | IN  pkt #704 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259745 | yapp monitor | RX pkt #704 on the input: addr=2 len=2 parity=bad gap=3 |
| 259745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259765 | **DUT** | IN  pkt #705 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 259795 | **DUT** | IN  pkt #705 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259795 | yapp monitor | RX pkt #705 on the input: addr=2 len=2 parity=bad gap=1 |
| 259795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 260005 | **DUT** | IN  pkt #706 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260035 | **DUT** | IN  pkt #706 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260035 | yapp monitor | RX pkt #706 on the input: addr=2 len=2 parity=bad gap=20 |
| 260035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260215 | **DUT** | IN  pkt #707 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260245 | **DUT** | IN  pkt #707 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260245 | yapp monitor | RX pkt #707 on the input: addr=2 len=2 parity=bad gap=17 |
| 260245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 260435 | **DUT** | IN  pkt #708 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260465 | **DUT** | IN  pkt #708 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260465 | yapp monitor | RX pkt #708 on the input: addr=2 len=2 parity=bad gap=18 |
| 260465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260545 | **DUT** | IN  pkt #709 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 260575 | **DUT** | IN  pkt #709 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260575 | yapp monitor | RX pkt #709 on the input: addr=2 len=2 parity=bad gap=7 |
| 260575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260785 | **DUT** | IN  pkt #710 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260815 | **DUT** | IN  pkt #710 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260815 | yapp monitor | RX pkt #710 on the input: addr=2 len=2 parity=bad gap=20 |
| 260815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 261025 | **DUT** | IN  pkt #711 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261055 | **DUT** | IN  pkt #711 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261055 | yapp monitor | RX pkt #711 on the input: addr=2 len=2 parity=bad gap=20 |
| 261055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 261265 | **DUT** | IN  pkt #712 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261295 | **DUT** | IN  pkt #712 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261295 | yapp monitor | RX pkt #712 on the input: addr=2 len=2 parity=bad gap=20 |
| 261295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 261415 | **DUT** | IN  pkt #713 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261445 | **DUT** | IN  pkt #713 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261445 | yapp monitor | RX pkt #713 on the input: addr=2 len=2 parity=bad gap=11 |
| 261445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 261625 | **DUT** | IN  pkt #714 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261655 | **DUT** | IN  pkt #714 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261655 | yapp monitor | RX pkt #714 on the input: addr=2 len=2 parity=bad gap=17 |
| 261655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 261865 | **DUT** | IN  pkt #715 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261895 | **DUT** | IN  pkt #715 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261895 | yapp monitor | RX pkt #715 on the input: addr=2 len=2 parity=bad gap=20 |
| 261895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 262095 | **DUT** | IN  pkt #716 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262125 | **DUT** | IN  pkt #716 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262125 | yapp monitor | RX pkt #716 on the input: addr=2 len=2 parity=bad gap=19 |
| 262125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262125 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262165 | **DUT** | IN  pkt #717 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 262195 | **DUT** | IN  pkt #717 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262195 | yapp monitor | RX pkt #717 on the input: addr=2 len=2 parity=bad gap=3 |
| 262195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262195 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262270 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 262375 | **DUT** | IN  pkt #718 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262405 | **DUT** | IN  pkt #718 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262405 | yapp monitor | RX pkt #718 on the input: addr=2 len=2 parity=bad gap=17 |
| 262405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 262505 | **DUT** | IN  pkt #719 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262535 | **DUT** | IN  pkt #719 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262535 | yapp monitor | RX pkt #719 on the input: addr=2 len=2 parity=bad gap=9 |
| 262535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262555 | **DUT** | IN  pkt #720 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262585 | **DUT** | IN  pkt #720 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262585 | yapp monitor | RX pkt #720 on the input: addr=2 len=2 parity=bad gap=1 |
| 262585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 262640 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 262755 | **DUT** | IN  pkt #721 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262785 | **DUT** | IN  pkt #721 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262785 | yapp monitor | RX pkt #721 on the input: addr=2 len=2 parity=bad gap=16 |
| 262785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 262885 | **DUT** | IN  pkt #722 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262915 | **DUT** | IN  pkt #722 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262915 | yapp monitor | RX pkt #722 on the input: addr=2 len=2 parity=bad gap=9 |
| 262915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262970 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 263105 | **DUT** | IN  pkt #723 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263135 | **DUT** | IN  pkt #723 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263135 | yapp monitor | RX pkt #723 on the input: addr=2 len=2 parity=bad gap=18 |
| 263135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263190 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 263295 | **DUT** | IN  pkt #724 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263325 | **DUT** | IN  pkt #724 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263325 | yapp monitor | RX pkt #724 on the input: addr=2 len=2 parity=bad gap=15 |
| 263325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 263515 | **DUT** | IN  pkt #725 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263545 | **DUT** | IN  pkt #725 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263545 | yapp monitor | RX pkt #725 on the input: addr=2 len=2 parity=bad gap=18 |
| 263545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 263645 | **DUT** | IN  pkt #726 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263675 | **DUT** | IN  pkt #726 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263675 | yapp monitor | RX pkt #726 on the input: addr=2 len=2 parity=bad gap=9 |
| 263675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 263715 | **DUT** | IN  pkt #727 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263745 | **DUT** | IN  pkt #727 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263745 | yapp monitor | RX pkt #727 on the input: addr=2 len=2 parity=bad gap=3 |
| 263745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263785 | **DUT** | IN  pkt #728 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263815 | **DUT** | IN  pkt #728 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263815 | yapp monitor | RX pkt #728 on the input: addr=2 len=2 parity=bad gap=3 |
| 263815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263855 | **DUT** | IN  pkt #729 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263885 | **DUT** | IN  pkt #729 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263885 | yapp monitor | RX pkt #729 on the input: addr=2 len=2 parity=bad gap=3 |
| 263885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263910 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 263950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 264025 | **DUT** | IN  pkt #730 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264055 | **DUT** | IN  pkt #730 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264055 | yapp monitor | RX pkt #730 on the input: addr=2 len=2 parity=bad gap=13 |
| 264055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 264135 | **DUT** | IN  pkt #731 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264165 | **DUT** | IN  pkt #731 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264165 | yapp monitor | RX pkt #731 on the input: addr=2 len=2 parity=bad gap=7 |
| 264165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 264295 | **DUT** | IN  pkt #732 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264325 | **DUT** | IN  pkt #732 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264325 | yapp monitor | RX pkt #732 on the input: addr=2 len=2 parity=bad gap=12 |
| 264325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264345 | **DUT** | IN  pkt #733 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 264375 | **DUT** | IN  pkt #733 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264375 | yapp monitor | RX pkt #733 on the input: addr=2 len=2 parity=bad gap=1 |
| 264375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 264565 | **DUT** | IN  pkt #734 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264595 | **DUT** | IN  pkt #734 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264595 | yapp monitor | RX pkt #734 on the input: addr=2 len=2 parity=bad gap=18 |
| 264595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264595 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264655 | **DUT** | IN  pkt #735 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264670 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 264685 | **DUT** | IN  pkt #735 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264685 | yapp monitor | RX pkt #735 on the input: addr=2 len=2 parity=bad gap=5 |
| 264685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 264895 | **DUT** | IN  pkt #736 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264925 | **DUT** | IN  pkt #736 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264925 | yapp monitor | RX pkt #736 on the input: addr=2 len=2 parity=bad gap=20 |
| 264925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 265035 | **DUT** | IN  pkt #737 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265065 | **DUT** | IN  pkt #737 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265065 | yapp monitor | RX pkt #737 on the input: addr=2 len=2 parity=bad gap=10 |
| 265065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 265275 | **DUT** | IN  pkt #738 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265305 | **DUT** | IN  pkt #738 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265305 | yapp monitor | RX pkt #738 on the input: addr=2 len=2 parity=bad gap=20 |
| 265305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 265475 | **DUT** | IN  pkt #739 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265505 | **DUT** | IN  pkt #739 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265505 | yapp monitor | RX pkt #739 on the input: addr=2 len=2 parity=bad gap=16 |
| 265505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 265655 | **DUT** | IN  pkt #740 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265685 | **DUT** | IN  pkt #740 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265685 | yapp monitor | RX pkt #740 on the input: addr=2 len=2 parity=bad gap=14 |
| 265685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 265875 | **DUT** | IN  pkt #741 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265905 | **DUT** | IN  pkt #741 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265905 | yapp monitor | RX pkt #741 on the input: addr=2 len=2 parity=bad gap=18 |
| 265905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265905 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265955 | **DUT** | IN  pkt #742 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265985 | **DUT** | IN  pkt #742 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265985 | yapp monitor | RX pkt #742 on the input: addr=2 len=2 parity=bad gap=4 |
| 265985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266010 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 266020 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 266025 | **DUT** | IN  pkt #743 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266055 | **DUT** | IN  pkt #743 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266055 | yapp monitor | RX pkt #743 on the input: addr=2 len=2 parity=bad gap=3 |
| 266055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266150 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 266265 | **DUT** | IN  pkt #744 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266295 | **DUT** | IN  pkt #744 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266295 | yapp monitor | RX pkt #744 on the input: addr=2 len=2 parity=bad gap=20 |
| 266295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 266465 | **DUT** | IN  pkt #745 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266495 | **DUT** | IN  pkt #745 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266495 | yapp monitor | RX pkt #745 on the input: addr=2 len=2 parity=bad gap=16 |
| 266495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266515 | **DUT** | IN  pkt #746 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266545 | **DUT** | IN  pkt #746 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266545 | yapp monitor | RX pkt #746 on the input: addr=2 len=2 parity=bad gap=1 |
| 266545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 266650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 266685 | **DUT** | IN  pkt #747 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266715 | **DUT** | IN  pkt #747 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266715 | yapp monitor | RX pkt #747 on the input: addr=2 len=2 parity=bad gap=13 |
| 266715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 266855 | **DUT** | IN  pkt #748 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266885 | **DUT** | IN  pkt #748 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266885 | yapp monitor | RX pkt #748 on the input: addr=2 len=2 parity=bad gap=13 |
| 266885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 267065 | **DUT** | IN  pkt #749 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267095 | **DUT** | IN  pkt #749 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267095 | yapp monitor | RX pkt #749 on the input: addr=2 len=2 parity=bad gap=17 |
| 267095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267110 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 267305 | **DUT** | IN  pkt #750 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267335 | **DUT** | IN  pkt #750 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267335 | yapp monitor | RX pkt #750 on the input: addr=2 len=2 parity=bad gap=20 |
| 267335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267335 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 267495 | **DUT** | IN  pkt #751 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267525 | **DUT** | IN  pkt #751 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267525 | yapp monitor | RX pkt #751 on the input: addr=2 len=2 parity=bad gap=15 |
| 267525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 267735 | **DUT** | IN  pkt #752 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267765 | **DUT** | IN  pkt #752 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267765 | yapp monitor | RX pkt #752 on the input: addr=2 len=2 parity=bad gap=20 |
| 267765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 267815 | **DUT** | IN  pkt #753 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267845 | **DUT** | IN  pkt #753 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267845 | yapp monitor | RX pkt #753 on the input: addr=2 len=2 parity=bad gap=4 |
| 267845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 267955 | **DUT** | IN  pkt #754 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267985 | **DUT** | IN  pkt #754 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267985 | yapp monitor | RX pkt #754 on the input: addr=2 len=2 parity=bad gap=10 |
| 267985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 268195 | **DUT** | IN  pkt #755 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268225 | **DUT** | IN  pkt #755 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268225 | yapp monitor | RX pkt #755 on the input: addr=2 len=2 parity=bad gap=20 |
| 268225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 268305 | **DUT** | IN  pkt #756 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268335 | **DUT** | IN  pkt #756 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268335 | yapp monitor | RX pkt #756 on the input: addr=2 len=2 parity=bad gap=7 |
| 268335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268335 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 268515 | **DUT** | IN  pkt #757 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268545 | **DUT** | IN  pkt #757 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268545 | yapp monitor | RX pkt #757 on the input: addr=2 len=2 parity=bad gap=17 |
| 268545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 268745 | **DUT** | IN  pkt #758 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268775 | **DUT** | IN  pkt #758 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268775 | yapp monitor | RX pkt #758 on the input: addr=2 len=2 parity=bad gap=19 |
| 268775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268795 | **DUT** | IN  pkt #759 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268825 | **DUT** | IN  pkt #759 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268825 | yapp monitor | RX pkt #759 on the input: addr=2 len=2 parity=bad gap=1 |
| 268825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 268880 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 268895 | **DUT** | IN  pkt #760 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268925 | **DUT** | IN  pkt #760 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268925 | yapp monitor | RX pkt #760 on the input: addr=2 len=2 parity=bad gap=6 |
| 268925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 269065 | **DUT** | IN  pkt #761 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269095 | **DUT** | IN  pkt #761 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269095 | yapp monitor | RX pkt #761 on the input: addr=2 len=2 parity=bad gap=13 |
| 269095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 269245 | **DUT** | IN  pkt #762 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269275 | **DUT** | IN  pkt #762 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269275 | yapp monitor | RX pkt #762 on the input: addr=2 len=2 parity=bad gap=14 |
| 269275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269475 | **DUT** | IN  pkt #763 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269505 | **DUT** | IN  pkt #763 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269505 | yapp monitor | RX pkt #763 on the input: addr=2 len=2 parity=bad gap=19 |
| 269505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 269625 | **DUT** | IN  pkt #764 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269655 | **DUT** | IN  pkt #764 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269655 | yapp monitor | RX pkt #764 on the input: addr=2 len=2 parity=bad gap=11 |
| 269655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269865 | **DUT** | IN  pkt #765 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269895 | **DUT** | IN  pkt #765 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269895 | yapp monitor | RX pkt #765 on the input: addr=2 len=2 parity=bad gap=20 |
| 269895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 270055 | **DUT** | IN  pkt #766 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270085 | **DUT** | IN  pkt #766 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270085 | yapp monitor | RX pkt #766 on the input: addr=2 len=2 parity=bad gap=15 |
| 270085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 270125 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 270155 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 270185 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 270215 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 270245 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 270270 | **test** | STAGE: 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 270275 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 270295 | hbus monitor | Collected WRITE addr=0x1001 data=0x81 |
| 270295 | reference | router_en is now 1 (en_reg 0x81) |
| 270405 | **DUT** | IN  pkt #767 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270435 | **DUT** | IN  pkt #767 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270435 | yapp monitor | RX pkt #767 on the input: addr=3 len=2 parity=bad gap=31 |
| 270435 | reference | Packet dropped: illegal address 3 (len=2) |
| 270435 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270490 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 270565 | **DUT** | IN  pkt #768 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270595 | **DUT** | IN  pkt #768 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270595 | yapp monitor | RX pkt #768 on the input: addr=3 len=2 parity=bad gap=12 |
| 270595 | reference | Packet dropped: illegal address 3 (len=2) |
| 270595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270635 | **DUT** | IN  pkt #769 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 270665 | **DUT** | IN  pkt #769 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270665 | yapp monitor | RX pkt #769 on the input: addr=3 len=2 parity=bad gap=3 |
| 270665 | reference | Packet dropped: illegal address 3 (len=2) |
| 270665 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270730 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 270795 | **DUT** | IN  pkt #770 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270825 | **DUT** | IN  pkt #770 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270825 | yapp monitor | RX pkt #770 on the input: addr=3 len=2 parity=bad gap=12 |
| 270825 | reference | Packet dropped: illegal address 3 (len=2) |
| 270825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 270965 | **DUT** | IN  pkt #771 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270995 | **DUT** | IN  pkt #771 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270995 | yapp monitor | RX pkt #771 on the input: addr=3 len=2 parity=bad gap=13 |
| 270995 | reference | Packet dropped: illegal address 3 (len=2) |
| 270995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 271115 | **DUT** | IN  pkt #772 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271145 | **DUT** | IN  pkt #772 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271145 | yapp monitor | RX pkt #772 on the input: addr=3 len=2 parity=bad gap=11 |
| 271145 | reference | Packet dropped: illegal address 3 (len=2) |
| 271145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 271345 | **DUT** | IN  pkt #773 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271375 | **DUT** | IN  pkt #773 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271375 | yapp monitor | RX pkt #773 on the input: addr=3 len=2 parity=bad gap=19 |
| 271375 | reference | Packet dropped: illegal address 3 (len=2) |
| 271375 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 271565 | **DUT** | IN  pkt #774 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271595 | **DUT** | IN  pkt #774 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271595 | yapp monitor | RX pkt #774 on the input: addr=3 len=2 parity=bad gap=18 |
| 271595 | reference | Packet dropped: illegal address 3 (len=2) |
| 271595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 271775 | **DUT** | IN  pkt #775 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271805 | **DUT** | IN  pkt #775 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271805 | yapp monitor | RX pkt #775 on the input: addr=3 len=2 parity=bad gap=17 |
| 271805 | reference | Packet dropped: illegal address 3 (len=2) |
| 271805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 272015 | **DUT** | IN  pkt #776 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272045 | **DUT** | IN  pkt #776 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272045 | yapp monitor | RX pkt #776 on the input: addr=3 len=2 parity=bad gap=20 |
| 272045 | reference | Packet dropped: illegal address 3 (len=2) |
| 272045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 272125 | **DUT** | IN  pkt #777 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272155 | **DUT** | IN  pkt #777 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272155 | yapp monitor | RX pkt #777 on the input: addr=3 len=2 parity=bad gap=7 |
| 272155 | reference | Packet dropped: illegal address 3 (len=2) |
| 272155 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272170 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 272335 | **DUT** | IN  pkt #778 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272365 | **DUT** | IN  pkt #778 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272365 | yapp monitor | RX pkt #778 on the input: addr=3 len=2 parity=bad gap=17 |
| 272365 | reference | Packet dropped: illegal address 3 (len=2) |
| 272365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 272575 | **DUT** | IN  pkt #779 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272605 | **DUT** | IN  pkt #779 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272605 | yapp monitor | RX pkt #779 on the input: addr=3 len=2 parity=bad gap=20 |
| 272605 | reference | Packet dropped: illegal address 3 (len=2) |
| 272605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272645 | **DUT** | IN  pkt #780 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272675 | **DUT** | IN  pkt #780 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272675 | yapp monitor | RX pkt #780 on the input: addr=3 len=2 parity=bad gap=3 |
| 272675 | reference | Packet dropped: illegal address 3 (len=2) |
| 272675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 272725 | **DUT** | IN  pkt #781 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 272755 | **DUT** | IN  pkt #781 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272755 | yapp monitor | RX pkt #781 on the input: addr=3 len=2 parity=bad gap=4 |
| 272755 | reference | Packet dropped: illegal address 3 (len=2) |
| 272755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272775 | **DUT** | IN  pkt #782 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272805 | **DUT** | IN  pkt #782 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272805 | yapp monitor | RX pkt #782 on the input: addr=3 len=2 parity=bad gap=1 |
| 272805 | reference | Packet dropped: illegal address 3 (len=2) |
| 272805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 272840 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 272985 | **DUT** | IN  pkt #783 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273015 | **DUT** | IN  pkt #783 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273015 | yapp monitor | RX pkt #783 on the input: addr=3 len=2 parity=bad gap=17 |
| 273015 | reference | Packet dropped: illegal address 3 (len=2) |
| 273015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 273185 | **DUT** | IN  pkt #784 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273215 | **DUT** | IN  pkt #784 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273215 | yapp monitor | RX pkt #784 on the input: addr=3 len=2 parity=bad gap=16 |
| 273215 | reference | Packet dropped: illegal address 3 (len=2) |
| 273215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 273405 | **DUT** | IN  pkt #785 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273435 | **DUT** | IN  pkt #785 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273435 | yapp monitor | RX pkt #785 on the input: addr=3 len=2 parity=bad gap=18 |
| 273435 | reference | Packet dropped: illegal address 3 (len=2) |
| 273435 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273450 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 273485 | **DUT** | IN  pkt #786 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273515 | **DUT** | IN  pkt #786 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273515 | yapp monitor | RX pkt #786 on the input: addr=3 len=2 parity=bad gap=4 |
| 273515 | reference | Packet dropped: illegal address 3 (len=2) |
| 273515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 273685 | **DUT** | IN  pkt #787 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273715 | **DUT** | IN  pkt #787 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273715 | yapp monitor | RX pkt #787 on the input: addr=3 len=2 parity=bad gap=16 |
| 273715 | reference | Packet dropped: illegal address 3 (len=2) |
| 273715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 273835 | **DUT** | IN  pkt #788 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273865 | **DUT** | IN  pkt #788 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273865 | yapp monitor | RX pkt #788 on the input: addr=3 len=2 parity=bad gap=11 |
| 273865 | reference | Packet dropped: illegal address 3 (len=2) |
| 273865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 274055 | **DUT** | IN  pkt #789 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274085 | **DUT** | IN  pkt #789 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274085 | yapp monitor | RX pkt #789 on the input: addr=3 len=2 parity=bad gap=18 |
| 274085 | reference | Packet dropped: illegal address 3 (len=2) |
| 274085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 274125 | **DUT** | IN  pkt #790 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274155 | **DUT** | IN  pkt #790 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274155 | yapp monitor | RX pkt #790 on the input: addr=3 len=2 parity=bad gap=3 |
| 274155 | reference | Packet dropped: illegal address 3 (len=2) |
| 274155 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 274365 | **DUT** | IN  pkt #791 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274395 | **DUT** | IN  pkt #791 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274395 | yapp monitor | RX pkt #791 on the input: addr=3 len=2 parity=bad gap=20 |
| 274395 | reference | Packet dropped: illegal address 3 (len=2) |
| 274395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274410 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 274575 | **DUT** | IN  pkt #792 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274605 | **DUT** | IN  pkt #792 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274605 | yapp monitor | RX pkt #792 on the input: addr=3 len=2 parity=bad gap=17 |
| 274605 | reference | Packet dropped: illegal address 3 (len=2) |
| 274605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 274785 | **DUT** | IN  pkt #793 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274815 | **DUT** | IN  pkt #793 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274815 | yapp monitor | RX pkt #793 on the input: addr=3 len=2 parity=bad gap=17 |
| 274815 | reference | Packet dropped: illegal address 3 (len=2) |
| 274815 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 274935 | **DUT** | IN  pkt #794 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274965 | **DUT** | IN  pkt #794 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274965 | yapp monitor | RX pkt #794 on the input: addr=3 len=2 parity=bad gap=11 |
| 274965 | reference | Packet dropped: illegal address 3 (len=2) |
| 274965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275175 | **DUT** | IN  pkt #795 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275205 | **DUT** | IN  pkt #795 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275205 | yapp monitor | RX pkt #795 on the input: addr=3 len=2 parity=bad gap=20 |
| 275205 | reference | Packet dropped: illegal address 3 (len=2) |
| 275205 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 275385 | **DUT** | IN  pkt #796 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275415 | **DUT** | IN  pkt #796 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275415 | yapp monitor | RX pkt #796 on the input: addr=3 len=2 parity=bad gap=17 |
| 275415 | reference | Packet dropped: illegal address 3 (len=2) |
| 275415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 275625 | **DUT** | IN  pkt #797 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275655 | **DUT** | IN  pkt #797 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275655 | yapp monitor | RX pkt #797 on the input: addr=3 len=2 parity=bad gap=20 |
| 275655 | reference | Packet dropped: illegal address 3 (len=2) |
| 275655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275735 | **DUT** | IN  pkt #798 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 275765 | **DUT** | IN  pkt #798 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275765 | yapp monitor | RX pkt #798 on the input: addr=3 len=2 parity=bad gap=7 |
| 275765 | reference | Packet dropped: illegal address 3 (len=2) |
| 275765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275965 | **DUT** | IN  pkt #799 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275995 | **DUT** | IN  pkt #799 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275995 | yapp monitor | RX pkt #799 on the input: addr=3 len=2 parity=bad gap=19 |
| 275995 | reference | Packet dropped: illegal address 3 (len=2) |
| 275995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 276035 | **DUT** | IN  pkt #800 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276065 | **DUT** | IN  pkt #800 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276065 | yapp monitor | RX pkt #800 on the input: addr=3 len=2 parity=bad gap=3 |
| 276065 | reference | Packet dropped: illegal address 3 (len=2) |
| 276065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 276135 | **DUT** | IN  pkt #801 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276165 | **DUT** | IN  pkt #801 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276165 | yapp monitor | RX pkt #801 on the input: addr=3 len=2 parity=bad gap=6 |
| 276165 | reference | Packet dropped: illegal address 3 (len=2) |
| 276165 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 276335 | **DUT** | IN  pkt #802 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276365 | **DUT** | IN  pkt #802 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276365 | yapp monitor | RX pkt #802 on the input: addr=3 len=2 parity=bad gap=16 |
| 276365 | reference | Packet dropped: illegal address 3 (len=2) |
| 276365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 276505 | **DUT** | IN  pkt #803 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276535 | **DUT** | IN  pkt #803 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276535 | yapp monitor | RX pkt #803 on the input: addr=3 len=2 parity=bad gap=13 |
| 276535 | reference | Packet dropped: illegal address 3 (len=2) |
| 276535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 276745 | **DUT** | IN  pkt #804 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276775 | **DUT** | IN  pkt #804 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276775 | yapp monitor | RX pkt #804 on the input: addr=3 len=2 parity=bad gap=20 |
| 276775 | reference | Packet dropped: illegal address 3 (len=2) |
| 276775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 276955 | **DUT** | IN  pkt #805 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276985 | **DUT** | IN  pkt #805 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276985 | yapp monitor | RX pkt #805 on the input: addr=3 len=2 parity=bad gap=17 |
| 276985 | reference | Packet dropped: illegal address 3 (len=2) |
| 276985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277030 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 277175 | **DUT** | IN  pkt #806 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277205 | **DUT** | IN  pkt #806 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277205 | yapp monitor | RX pkt #806 on the input: addr=3 len=2 parity=bad gap=18 |
| 277205 | reference | Packet dropped: illegal address 3 (len=2) |
| 277205 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277225 | **DUT** | IN  pkt #807 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277250 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 277255 | **DUT** | IN  pkt #807 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277255 | yapp monitor | RX pkt #807 on the input: addr=3 len=2 parity=bad gap=1 |
| 277255 | reference | Packet dropped: illegal address 3 (len=2) |
| 277255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 277455 | **DUT** | IN  pkt #808 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277485 | **DUT** | IN  pkt #808 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277485 | yapp monitor | RX pkt #808 on the input: addr=3 len=2 parity=bad gap=19 |
| 277485 | reference | Packet dropped: illegal address 3 (len=2) |
| 277485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 277655 | **DUT** | IN  pkt #809 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277685 | **DUT** | IN  pkt #809 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277685 | yapp monitor | RX pkt #809 on the input: addr=3 len=2 parity=bad gap=16 |
| 277685 | reference | Packet dropped: illegal address 3 (len=2) |
| 277685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 277775 | **DUT** | IN  pkt #810 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277805 | **DUT** | IN  pkt #810 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277805 | yapp monitor | RX pkt #810 on the input: addr=3 len=2 parity=bad gap=8 |
| 277805 | reference | Packet dropped: illegal address 3 (len=2) |
| 277805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 277915 | **DUT** | IN  pkt #811 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277945 | **DUT** | IN  pkt #811 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277945 | yapp monitor | RX pkt #811 on the input: addr=3 len=2 parity=bad gap=10 |
| 277945 | reference | Packet dropped: illegal address 3 (len=2) |
| 277945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 278035 | **DUT** | IN  pkt #812 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278065 | **DUT** | IN  pkt #812 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278065 | yapp monitor | RX pkt #812 on the input: addr=3 len=2 parity=bad gap=8 |
| 278065 | reference | Packet dropped: illegal address 3 (len=2) |
| 278065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 278255 | **DUT** | IN  pkt #813 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278285 | **DUT** | IN  pkt #813 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278285 | yapp monitor | RX pkt #813 on the input: addr=3 len=2 parity=bad gap=18 |
| 278285 | reference | Packet dropped: illegal address 3 (len=2) |
| 278285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 278395 | **DUT** | IN  pkt #814 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278425 | **DUT** | IN  pkt #814 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278425 | yapp monitor | RX pkt #814 on the input: addr=3 len=2 parity=bad gap=10 |
| 278425 | reference | Packet dropped: illegal address 3 (len=2) |
| 278425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 278585 | **DUT** | IN  pkt #815 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278615 | **DUT** | IN  pkt #815 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278615 | yapp monitor | RX pkt #815 on the input: addr=3 len=2 parity=bad gap=15 |
| 278615 | reference | Packet dropped: illegal address 3 (len=2) |
| 278615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 278825 | **DUT** | IN  pkt #816 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278855 | **DUT** | IN  pkt #816 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278855 | yapp monitor | RX pkt #816 on the input: addr=3 len=2 parity=bad gap=20 |
| 278855 | reference | Packet dropped: illegal address 3 (len=2) |
| 278855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278875 | **DUT** | IN  pkt #817 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278905 | **DUT** | IN  pkt #817 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278905 | yapp monitor | RX pkt #817 on the input: addr=3 len=2 parity=bad gap=1 |
| 278905 | reference | Packet dropped: illegal address 3 (len=2) |
| 278905 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 278960 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 279115 | **DUT** | IN  pkt #818 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279145 | **DUT** | IN  pkt #818 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279145 | yapp monitor | RX pkt #818 on the input: addr=3 len=2 parity=bad gap=20 |
| 279145 | reference | Packet dropped: illegal address 3 (len=2) |
| 279145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 279325 | **DUT** | IN  pkt #819 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279355 | **DUT** | IN  pkt #819 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279355 | yapp monitor | RX pkt #819 on the input: addr=3 len=2 parity=bad gap=17 |
| 279355 | reference | Packet dropped: illegal address 3 (len=2) |
| 279355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 279565 | **DUT** | IN  pkt #820 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279595 | **DUT** | IN  pkt #820 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279595 | yapp monitor | RX pkt #820 on the input: addr=3 len=2 parity=bad gap=20 |
| 279595 | reference | Packet dropped: illegal address 3 (len=2) |
| 279595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 279655 | **DUT** | IN  pkt #821 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279685 | **DUT** | IN  pkt #821 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279685 | yapp monitor | RX pkt #821 on the input: addr=3 len=2 parity=bad gap=5 |
| 279685 | reference | Packet dropped: illegal address 3 (len=2) |
| 279685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279725 | **DUT** | IN  pkt #822 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279755 | **DUT** | IN  pkt #822 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279755 | yapp monitor | RX pkt #822 on the input: addr=3 len=2 parity=bad gap=3 |
| 279755 | reference | Packet dropped: illegal address 3 (len=2) |
| 279755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 279955 | **DUT** | IN  pkt #823 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279985 | **DUT** | IN  pkt #823 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279985 | yapp monitor | RX pkt #823 on the input: addr=3 len=2 parity=bad gap=19 |
| 279985 | reference | Packet dropped: illegal address 3 (len=2) |
| 279985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 280195 | **DUT** | IN  pkt #824 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280225 | **DUT** | IN  pkt #824 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280225 | yapp monitor | RX pkt #824 on the input: addr=3 len=2 parity=bad gap=20 |
| 280225 | reference | Packet dropped: illegal address 3 (len=2) |
| 280225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 280355 | **DUT** | IN  pkt #825 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280385 | **DUT** | IN  pkt #825 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280385 | yapp monitor | RX pkt #825 on the input: addr=3 len=2 parity=bad gap=12 |
| 280385 | reference | Packet dropped: illegal address 3 (len=2) |
| 280385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 280595 | **DUT** | IN  pkt #826 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280625 | **DUT** | IN  pkt #826 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280625 | yapp monitor | RX pkt #826 on the input: addr=3 len=2 parity=bad gap=20 |
| 280625 | reference | Packet dropped: illegal address 3 (len=2) |
| 280625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 280795 | **DUT** | IN  pkt #827 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280825 | **DUT** | IN  pkt #827 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280825 | yapp monitor | RX pkt #827 on the input: addr=3 len=2 parity=bad gap=16 |
| 280825 | reference | Packet dropped: illegal address 3 (len=2) |
| 280825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 280915 | **DUT** | IN  pkt #828 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280945 | **DUT** | IN  pkt #828 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280945 | yapp monitor | RX pkt #828 on the input: addr=3 len=2 parity=bad gap=8 |
| 280945 | reference | Packet dropped: illegal address 3 (len=2) |
| 280945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 281155 | **DUT** | IN  pkt #829 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281185 | **DUT** | IN  pkt #829 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281185 | yapp monitor | RX pkt #829 on the input: addr=3 len=2 parity=bad gap=20 |
| 281185 | reference | Packet dropped: illegal address 3 (len=2) |
| 281185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 281245 | **DUT** | IN  pkt #830 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281275 | **DUT** | IN  pkt #830 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281275 | yapp monitor | RX pkt #830 on the input: addr=3 len=2 parity=bad gap=5 |
| 281275 | reference | Packet dropped: illegal address 3 (len=2) |
| 281275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281485 | **DUT** | IN  pkt #831 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281515 | **DUT** | IN  pkt #831 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281515 | yapp monitor | RX pkt #831 on the input: addr=3 len=2 parity=bad gap=20 |
| 281515 | reference | Packet dropped: illegal address 3 (len=2) |
| 281515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 281725 | **DUT** | IN  pkt #832 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281755 | **DUT** | IN  pkt #832 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281755 | yapp monitor | RX pkt #832 on the input: addr=3 len=2 parity=bad gap=20 |
| 281755 | reference | Packet dropped: illegal address 3 (len=2) |
| 281755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281945 | **DUT** | IN  pkt #833 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281975 | **DUT** | IN  pkt #833 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281975 | yapp monitor | RX pkt #833 on the input: addr=3 len=2 parity=bad gap=18 |
| 281975 | reference | Packet dropped: illegal address 3 (len=2) |
| 281975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 282135 | **DUT** | IN  pkt #834 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282165 | **DUT** | IN  pkt #834 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282165 | yapp monitor | RX pkt #834 on the input: addr=3 len=2 parity=bad gap=15 |
| 282165 | reference | Packet dropped: illegal address 3 (len=2) |
| 282165 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 282335 | **DUT** | IN  pkt #835 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282365 | **DUT** | IN  pkt #835 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282365 | yapp monitor | RX pkt #835 on the input: addr=3 len=2 parity=bad gap=16 |
| 282365 | reference | Packet dropped: illegal address 3 (len=2) |
| 282365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 282525 | **DUT** | IN  pkt #836 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282555 | **DUT** | IN  pkt #836 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282555 | yapp monitor | RX pkt #836 on the input: addr=3 len=2 parity=bad gap=15 |
| 282555 | reference | Packet dropped: illegal address 3 (len=2) |
| 282555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 282735 | **DUT** | IN  pkt #837 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282765 | **DUT** | IN  pkt #837 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282765 | yapp monitor | RX pkt #837 on the input: addr=3 len=2 parity=bad gap=17 |
| 282765 | reference | Packet dropped: illegal address 3 (len=2) |
| 282765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 282845 | **DUT** | IN  pkt #838 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282875 | **DUT** | IN  pkt #838 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282875 | yapp monitor | RX pkt #838 on the input: addr=3 len=2 parity=bad gap=7 |
| 282875 | reference | Packet dropped: illegal address 3 (len=2) |
| 282875 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 283025 | **DUT** | IN  pkt #839 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283055 | **DUT** | IN  pkt #839 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283055 | yapp monitor | RX pkt #839 on the input: addr=3 len=2 parity=bad gap=14 |
| 283055 | reference | Packet dropped: illegal address 3 (len=2) |
| 283055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 283255 | **DUT** | IN  pkt #840 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283285 | **DUT** | IN  pkt #840 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283285 | yapp monitor | RX pkt #840 on the input: addr=3 len=2 parity=bad gap=19 |
| 283285 | reference | Packet dropped: illegal address 3 (len=2) |
| 283285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283330 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 283455 | **DUT** | IN  pkt #841 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283485 | **DUT** | IN  pkt #841 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283485 | yapp monitor | RX pkt #841 on the input: addr=3 len=2 parity=bad gap=16 |
| 283485 | reference | Packet dropped: illegal address 3 (len=2) |
| 283485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283535 | **DUT** | IN  pkt #842 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283565 | **DUT** | IN  pkt #842 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283565 | yapp monitor | RX pkt #842 on the input: addr=3 len=2 parity=bad gap=4 |
| 283565 | reference | Packet dropped: illegal address 3 (len=2) |
| 283565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 283630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 283745 | **DUT** | IN  pkt #843 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283775 | **DUT** | IN  pkt #843 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283775 | yapp monitor | RX pkt #843 on the input: addr=3 len=2 parity=bad gap=17 |
| 283775 | reference | Packet dropped: illegal address 3 (len=2) |
| 283775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 283985 | **DUT** | IN  pkt #844 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284015 | **DUT** | IN  pkt #844 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284015 | yapp monitor | RX pkt #844 on the input: addr=3 len=2 parity=bad gap=20 |
| 284015 | reference | Packet dropped: illegal address 3 (len=2) |
| 284015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 284225 | **DUT** | IN  pkt #845 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284255 | **DUT** | IN  pkt #845 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284255 | yapp monitor | RX pkt #845 on the input: addr=3 len=2 parity=bad gap=20 |
| 284255 | reference | Packet dropped: illegal address 3 (len=2) |
| 284255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 284425 | **DUT** | IN  pkt #846 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284455 | **DUT** | IN  pkt #846 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284455 | yapp monitor | RX pkt #846 on the input: addr=3 len=2 parity=bad gap=16 |
| 284455 | reference | Packet dropped: illegal address 3 (len=2) |
| 284455 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 284645 | **DUT** | IN  pkt #847 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284675 | **DUT** | IN  pkt #847 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284675 | yapp monitor | RX pkt #847 on the input: addr=3 len=2 parity=bad gap=18 |
| 284675 | reference | Packet dropped: illegal address 3 (len=2) |
| 284675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 284835 | **DUT** | IN  pkt #848 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284865 | **DUT** | IN  pkt #848 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284865 | yapp monitor | RX pkt #848 on the input: addr=3 len=2 parity=bad gap=15 |
| 284865 | reference | Packet dropped: illegal address 3 (len=2) |
| 284865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284885 | **DUT** | IN  pkt #849 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 284915 | **DUT** | IN  pkt #849 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284915 | yapp monitor | RX pkt #849 on the input: addr=3 len=2 parity=bad gap=1 |
| 284915 | reference | Packet dropped: illegal address 3 (len=2) |
| 284915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284945 | **DUT** | IN  pkt #850 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284975 | **DUT** | IN  pkt #850 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284975 | yapp monitor | RX pkt #850 on the input: addr=3 len=2 parity=bad gap=2 |
| 284975 | reference | Packet dropped: illegal address 3 (len=2) |
| 284975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 285010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 285015 | **DUT** | IN  pkt #851 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285045 | **DUT** | IN  pkt #851 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285045 | yapp monitor | RX pkt #851 on the input: addr=3 len=2 parity=bad gap=3 |
| 285045 | reference | Packet dropped: illegal address 3 (len=2) |
| 285045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 285235 | **DUT** | IN  pkt #852 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285265 | **DUT** | IN  pkt #852 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285265 | yapp monitor | RX pkt #852 on the input: addr=3 len=2 parity=bad gap=18 |
| 285265 | reference | Packet dropped: illegal address 3 (len=2) |
| 285265 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 285445 | **DUT** | IN  pkt #853 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285475 | **DUT** | IN  pkt #853 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285475 | yapp monitor | RX pkt #853 on the input: addr=3 len=2 parity=bad gap=17 |
| 285475 | reference | Packet dropped: illegal address 3 (len=2) |
| 285475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 285585 | **DUT** | IN  pkt #854 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285615 | **DUT** | IN  pkt #854 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285615 | yapp monitor | RX pkt #854 on the input: addr=3 len=2 parity=bad gap=10 |
| 285615 | reference | Packet dropped: illegal address 3 (len=2) |
| 285615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 285805 | **DUT** | IN  pkt #855 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285835 | **DUT** | IN  pkt #855 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285835 | yapp monitor | RX pkt #855 on the input: addr=3 len=2 parity=bad gap=18 |
| 285835 | reference | Packet dropped: illegal address 3 (len=2) |
| 285835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 286035 | **DUT** | IN  pkt #856 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286065 | **DUT** | IN  pkt #856 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286065 | yapp monitor | RX pkt #856 on the input: addr=3 len=2 parity=bad gap=19 |
| 286065 | reference | Packet dropped: illegal address 3 (len=2) |
| 286065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 286275 | **DUT** | IN  pkt #857 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286305 | **DUT** | IN  pkt #857 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286305 | yapp monitor | RX pkt #857 on the input: addr=3 len=2 parity=bad gap=20 |
| 286305 | reference | Packet dropped: illegal address 3 (len=2) |
| 286305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 286515 | **DUT** | IN  pkt #858 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286545 | **DUT** | IN  pkt #858 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286545 | yapp monitor | RX pkt #858 on the input: addr=3 len=2 parity=bad gap=20 |
| 286545 | reference | Packet dropped: illegal address 3 (len=2) |
| 286545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286645 | **DUT** | IN  pkt #859 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 286675 | **DUT** | IN  pkt #859 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286675 | yapp monitor | RX pkt #859 on the input: addr=3 len=2 parity=bad gap=9 |
| 286675 | reference | Packet dropped: illegal address 3 (len=2) |
| 286675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 286885 | **DUT** | IN  pkt #860 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286915 | **DUT** | IN  pkt #860 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286915 | yapp monitor | RX pkt #860 on the input: addr=3 len=2 parity=bad gap=20 |
| 286915 | reference | Packet dropped: illegal address 3 (len=2) |
| 286915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286970 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 286985 | **DUT** | IN  pkt #861 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287015 | **DUT** | IN  pkt #861 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287015 | yapp monitor | RX pkt #861 on the input: addr=3 len=2 parity=bad gap=6 |
| 287015 | reference | Packet dropped: illegal address 3 (len=2) |
| 287015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 287225 | **DUT** | IN  pkt #862 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287255 | **DUT** | IN  pkt #862 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287255 | yapp monitor | RX pkt #862 on the input: addr=3 len=2 parity=bad gap=20 |
| 287255 | reference | Packet dropped: illegal address 3 (len=2) |
| 287255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 287465 | **DUT** | IN  pkt #863 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287495 | **DUT** | IN  pkt #863 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287495 | yapp monitor | RX pkt #863 on the input: addr=3 len=2 parity=bad gap=20 |
| 287495 | reference | Packet dropped: illegal address 3 (len=2) |
| 287495 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 287595 | **DUT** | IN  pkt #864 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287625 | **DUT** | IN  pkt #864 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287625 | yapp monitor | RX pkt #864 on the input: addr=3 len=2 parity=bad gap=9 |
| 287625 | reference | Packet dropped: illegal address 3 (len=2) |
| 287625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287690 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 287835 | **DUT** | IN  pkt #865 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287865 | **DUT** | IN  pkt #865 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287865 | yapp monitor | RX pkt #865 on the input: addr=3 len=2 parity=bad gap=20 |
| 287865 | reference | Packet dropped: illegal address 3 (len=2) |
| 287865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 288035 | **DUT** | IN  pkt #866 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288065 | **DUT** | IN  pkt #866 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288065 | yapp monitor | RX pkt #866 on the input: addr=3 len=2 parity=bad gap=16 |
| 288065 | reference | Packet dropped: illegal address 3 (len=2) |
| 288065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 288105 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 288135 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 288165 | hbus monitor | Collected READ  addr=0x1006 data=0x64 |
| 288195 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 288225 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 288255 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 288275 | **DUT** | IN  pkt #867 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288305 | **DUT** | IN  pkt #867 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288305 | yapp monitor | RX pkt #867 on the input: addr=3 len=2 parity=bad gap=20 |
| 288305 | reference | Packet dropped: illegal address 3 (len=2) |
| 288305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288410 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 288415 | **DUT** | IN  pkt #868 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288445 | **DUT** | IN  pkt #868 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288445 | yapp monitor | RX pkt #868 on the input: addr=3 len=2 parity=bad gap=10 |
| 288445 | reference | Packet dropped: illegal address 3 (len=2) |
| 288445 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 288545 | **DUT** | IN  pkt #869 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288575 | **DUT** | IN  pkt #869 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288575 | yapp monitor | RX pkt #869 on the input: addr=3 len=2 parity=bad gap=9 |
| 288575 | reference | Packet dropped: illegal address 3 (len=2) |
| 288575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 288685 | **DUT** | IN  pkt #870 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288715 | **DUT** | IN  pkt #870 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288715 | yapp monitor | RX pkt #870 on the input: addr=3 len=2 parity=bad gap=10 |
| 288715 | reference | Packet dropped: illegal address 3 (len=2) |
| 288715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288735 | **DUT** | IN  pkt #871 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 288765 | **DUT** | IN  pkt #871 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288765 | yapp monitor | RX pkt #871 on the input: addr=3 len=2 parity=bad gap=1 |
| 288765 | reference | Packet dropped: illegal address 3 (len=2) |
| 288765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288815 | **DUT** | IN  pkt #872 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288845 | **DUT** | IN  pkt #872 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288845 | yapp monitor | RX pkt #872 on the input: addr=3 len=2 parity=bad gap=4 |
| 288845 | reference | Packet dropped: illegal address 3 (len=2) |
| 288845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288850 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 288910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 289055 | **DUT** | IN  pkt #873 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289085 | **DUT** | IN  pkt #873 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289085 | yapp monitor | RX pkt #873 on the input: addr=3 len=2 parity=bad gap=20 |
| 289085 | reference | Packet dropped: illegal address 3 (len=2) |
| 289085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 289255 | **DUT** | IN  pkt #874 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289285 | **DUT** | IN  pkt #874 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289285 | yapp monitor | RX pkt #874 on the input: addr=3 len=2 parity=bad gap=16 |
| 289285 | reference | Packet dropped: illegal address 3 (len=2) |
| 289285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289310 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 289455 | **DUT** | IN  pkt #875 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289485 | **DUT** | IN  pkt #875 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289485 | yapp monitor | RX pkt #875 on the input: addr=3 len=2 parity=bad gap=16 |
| 289485 | reference | Packet dropped: illegal address 3 (len=2) |
| 289485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 289695 | **DUT** | IN  pkt #876 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289725 | **DUT** | IN  pkt #876 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289725 | yapp monitor | RX pkt #876 on the input: addr=3 len=2 parity=bad gap=20 |
| 289725 | reference | Packet dropped: illegal address 3 (len=2) |
| 289725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289785 | **DUT** | IN  pkt #877 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 289815 | **DUT** | IN  pkt #877 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289815 | yapp monitor | RX pkt #877 on the input: addr=3 len=2 parity=bad gap=5 |
| 289815 | reference | Packet dropped: illegal address 3 (len=2) |
| 289815 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 290025 | **DUT** | IN  pkt #878 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290055 | **DUT** | IN  pkt #878 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290055 | yapp monitor | RX pkt #878 on the input: addr=3 len=2 parity=bad gap=20 |
| 290055 | reference | Packet dropped: illegal address 3 (len=2) |
| 290055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290150 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 290265 | **DUT** | IN  pkt #879 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290295 | **DUT** | IN  pkt #879 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290295 | yapp monitor | RX pkt #879 on the input: addr=3 len=2 parity=bad gap=20 |
| 290295 | reference | Packet dropped: illegal address 3 (len=2) |
| 290295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 290385 | **DUT** | IN  pkt #880 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290415 | **DUT** | IN  pkt #880 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290415 | yapp monitor | RX pkt #880 on the input: addr=3 len=2 parity=bad gap=8 |
| 290415 | reference | Packet dropped: illegal address 3 (len=2) |
| 290415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290445 | **DUT** | IN  pkt #881 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290450 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 290475 | **DUT** | IN  pkt #881 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290475 | yapp monitor | RX pkt #881 on the input: addr=3 len=2 parity=bad gap=2 |
| 290475 | reference | Packet dropped: illegal address 3 (len=2) |
| 290475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 290685 | **DUT** | IN  pkt #882 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290715 | **DUT** | IN  pkt #882 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290715 | yapp monitor | RX pkt #882 on the input: addr=3 len=2 parity=bad gap=20 |
| 290715 | reference | Packet dropped: illegal address 3 (len=2) |
| 290715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 290905 | **DUT** | IN  pkt #883 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290935 | **DUT** | IN  pkt #883 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290935 | yapp monitor | RX pkt #883 on the input: addr=3 len=2 parity=bad gap=18 |
| 290935 | reference | Packet dropped: illegal address 3 (len=2) |
| 290935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 290955 | **DUT** | IN  pkt #884 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290985 | **DUT** | IN  pkt #884 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290985 | yapp monitor | RX pkt #884 on the input: addr=3 len=2 parity=bad gap=1 |
| 290985 | reference | Packet dropped: illegal address 3 (len=2) |
| 290985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 291195 | **DUT** | IN  pkt #885 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291225 | **DUT** | IN  pkt #885 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291225 | yapp monitor | RX pkt #885 on the input: addr=3 len=2 parity=bad gap=20 |
| 291225 | reference | Packet dropped: illegal address 3 (len=2) |
| 291225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 291395 | **DUT** | IN  pkt #886 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291425 | **DUT** | IN  pkt #886 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291425 | yapp monitor | RX pkt #886 on the input: addr=3 len=2 parity=bad gap=16 |
| 291425 | reference | Packet dropped: illegal address 3 (len=2) |
| 291425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291445 | **DUT** | IN  pkt #887 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 291475 | **DUT** | IN  pkt #887 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291475 | yapp monitor | RX pkt #887 on the input: addr=3 len=2 parity=bad gap=1 |
| 291475 | reference | Packet dropped: illegal address 3 (len=2) |
| 291475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 291615 | **DUT** | IN  pkt #888 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291645 | **DUT** | IN  pkt #888 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291645 | yapp monitor | RX pkt #888 on the input: addr=3 len=2 parity=bad gap=13 |
| 291645 | reference | Packet dropped: illegal address 3 (len=2) |
| 291645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291725 | **DUT** | IN  pkt #889 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 291755 | **DUT** | IN  pkt #889 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291755 | yapp monitor | RX pkt #889 on the input: addr=3 len=2 parity=bad gap=7 |
| 291755 | reference | Packet dropped: illegal address 3 (len=2) |
| 291755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 291855 | **DUT** | IN  pkt #890 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291885 | **DUT** | IN  pkt #890 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291885 | yapp monitor | RX pkt #890 on the input: addr=3 len=2 parity=bad gap=9 |
| 291885 | reference | Packet dropped: illegal address 3 (len=2) |
| 291885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 291995 | **DUT** | IN  pkt #891 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292025 | **DUT** | IN  pkt #891 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292025 | yapp monitor | RX pkt #891 on the input: addr=3 len=2 parity=bad gap=10 |
| 292025 | reference | Packet dropped: illegal address 3 (len=2) |
| 292025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 292205 | **DUT** | IN  pkt #892 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292235 | **DUT** | IN  pkt #892 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292235 | yapp monitor | RX pkt #892 on the input: addr=3 len=2 parity=bad gap=17 |
| 292235 | reference | Packet dropped: illegal address 3 (len=2) |
| 292235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 292415 | **DUT** | IN  pkt #893 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292445 | **DUT** | IN  pkt #893 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292445 | yapp monitor | RX pkt #893 on the input: addr=3 len=2 parity=bad gap=17 |
| 292445 | reference | Packet dropped: illegal address 3 (len=2) |
| 292445 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 292655 | **DUT** | IN  pkt #894 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292685 | **DUT** | IN  pkt #894 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292685 | yapp monitor | RX pkt #894 on the input: addr=3 len=2 parity=bad gap=20 |
| 292685 | reference | Packet dropped: illegal address 3 (len=2) |
| 292685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292705 | **DUT** | IN  pkt #895 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292735 | **DUT** | IN  pkt #895 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292735 | yapp monitor | RX pkt #895 on the input: addr=3 len=2 parity=bad gap=1 |
| 292735 | reference | Packet dropped: illegal address 3 (len=2) |
| 292735 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 292755 | **DUT** | IN  pkt #896 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292785 | **DUT** | IN  pkt #896 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292785 | yapp monitor | RX pkt #896 on the input: addr=3 len=2 parity=bad gap=1 |
| 292785 | reference | Packet dropped: illegal address 3 (len=2) |
| 292785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 292890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 292935 | **DUT** | IN  pkt #897 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292965 | **DUT** | IN  pkt #897 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292965 | yapp monitor | RX pkt #897 on the input: addr=3 len=2 parity=bad gap=14 |
| 292965 | reference | Packet dropped: illegal address 3 (len=2) |
| 292965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292985 | **DUT** | IN  pkt #898 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292990 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 293015 | **DUT** | IN  pkt #898 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293015 | yapp monitor | RX pkt #898 on the input: addr=3 len=2 parity=bad gap=1 |
| 293015 | reference | Packet dropped: illegal address 3 (len=2) |
| 293015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 293095 | **DUT** | IN  pkt #899 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293125 | **DUT** | IN  pkt #899 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293125 | yapp monitor | RX pkt #899 on the input: addr=3 len=2 parity=bad gap=7 |
| 293125 | reference | Packet dropped: illegal address 3 (len=2) |
| 293125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 293295 | **DUT** | IN  pkt #900 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293325 | **DUT** | IN  pkt #900 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293325 | yapp monitor | RX pkt #900 on the input: addr=3 len=2 parity=bad gap=16 |
| 293325 | reference | Packet dropped: illegal address 3 (len=2) |
| 293325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 293395 | **DUT** | IN  pkt #901 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293425 | **DUT** | IN  pkt #901 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293425 | yapp monitor | RX pkt #901 on the input: addr=3 len=2 parity=bad gap=6 |
| 293425 | reference | Packet dropped: illegal address 3 (len=2) |
| 293425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 293605 | **DUT** | IN  pkt #902 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293635 | **DUT** | IN  pkt #902 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293635 | yapp monitor | RX pkt #902 on the input: addr=3 len=2 parity=bad gap=17 |
| 293635 | reference | Packet dropped: illegal address 3 (len=2) |
| 293635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293655 | **DUT** | IN  pkt #903 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293685 | **DUT** | IN  pkt #903 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293685 | yapp monitor | RX pkt #903 on the input: addr=3 len=2 parity=bad gap=1 |
| 293685 | reference | Packet dropped: illegal address 3 (len=2) |
| 293685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 293730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 293735 | **DUT** | IN  pkt #904 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293765 | **DUT** | IN  pkt #904 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293765 | yapp monitor | RX pkt #904 on the input: addr=3 len=2 parity=bad gap=4 |
| 293765 | reference | Packet dropped: illegal address 3 (len=2) |
| 293765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 293935 | **DUT** | IN  pkt #905 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293965 | **DUT** | IN  pkt #905 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293965 | yapp monitor | RX pkt #905 on the input: addr=3 len=2 parity=bad gap=16 |
| 293965 | reference | Packet dropped: illegal address 3 (len=2) |
| 293965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 294085 | **DUT** | IN  pkt #906 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294115 | **DUT** | IN  pkt #906 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294115 | yapp monitor | RX pkt #906 on the input: addr=3 len=2 parity=bad gap=11 |
| 294115 | reference | Packet dropped: illegal address 3 (len=2) |
| 294115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 294305 | **DUT** | IN  pkt #907 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294335 | **DUT** | IN  pkt #907 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294335 | yapp monitor | RX pkt #907 on the input: addr=3 len=2 parity=bad gap=18 |
| 294335 | reference | Packet dropped: illegal address 3 (len=2) |
| 294335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 294545 | **DUT** | IN  pkt #908 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294575 | **DUT** | IN  pkt #908 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294575 | yapp monitor | RX pkt #908 on the input: addr=3 len=2 parity=bad gap=20 |
| 294575 | reference | Packet dropped: illegal address 3 (len=2) |
| 294575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 294615 | **DUT** | IN  pkt #909 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294645 | **DUT** | IN  pkt #909 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294645 | yapp monitor | RX pkt #909 on the input: addr=3 len=2 parity=bad gap=3 |
| 294645 | reference | Packet dropped: illegal address 3 (len=2) |
| 294645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 294835 | **DUT** | IN  pkt #910 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294865 | **DUT** | IN  pkt #910 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294865 | yapp monitor | RX pkt #910 on the input: addr=3 len=2 parity=bad gap=18 |
| 294865 | reference | Packet dropped: illegal address 3 (len=2) |
| 294865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 295075 | **DUT** | IN  pkt #911 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295105 | **DUT** | IN  pkt #911 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295105 | yapp monitor | RX pkt #911 on the input: addr=3 len=2 parity=bad gap=20 |
| 295105 | reference | Packet dropped: illegal address 3 (len=2) |
| 295105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 295295 | **DUT** | IN  pkt #912 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295325 | **DUT** | IN  pkt #912 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295325 | yapp monitor | RX pkt #912 on the input: addr=3 len=2 parity=bad gap=18 |
| 295325 | reference | Packet dropped: illegal address 3 (len=2) |
| 295325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 295525 | **DUT** | IN  pkt #913 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295555 | **DUT** | IN  pkt #913 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295555 | yapp monitor | RX pkt #913 on the input: addr=3 len=2 parity=bad gap=19 |
| 295555 | reference | Packet dropped: illegal address 3 (len=2) |
| 295555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 295695 | **DUT** | IN  pkt #914 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295725 | **DUT** | IN  pkt #914 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295725 | yapp monitor | RX pkt #914 on the input: addr=3 len=2 parity=bad gap=13 |
| 295725 | reference | Packet dropped: illegal address 3 (len=2) |
| 295725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 295855 | **DUT** | IN  pkt #915 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295885 | **DUT** | IN  pkt #915 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295885 | yapp monitor | RX pkt #915 on the input: addr=3 len=2 parity=bad gap=12 |
| 295885 | reference | Packet dropped: illegal address 3 (len=2) |
| 295885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295915 | **DUT** | IN  pkt #916 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295945 | **DUT** | IN  pkt #916 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295945 | yapp monitor | RX pkt #916 on the input: addr=3 len=2 parity=bad gap=2 |
| 295945 | reference | Packet dropped: illegal address 3 (len=2) |
| 295945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 295965 | **DUT** | IN  pkt #917 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295995 | **DUT** | IN  pkt #917 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295995 | yapp monitor | RX pkt #917 on the input: addr=3 len=2 parity=bad gap=1 |
| 295995 | reference | Packet dropped: illegal address 3 (len=2) |
| 295995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 296020 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 296205 | **DUT** | IN  pkt #918 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296235 | **DUT** | IN  pkt #918 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296235 | yapp monitor | RX pkt #918 on the input: addr=3 len=2 parity=bad gap=20 |
| 296235 | reference | Packet dropped: illegal address 3 (len=2) |
| 296235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296265 | **DUT** | IN  pkt #919 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 296295 | **DUT** | IN  pkt #919 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296295 | yapp monitor | RX pkt #919 on the input: addr=3 len=2 parity=bad gap=2 |
| 296295 | reference | Packet dropped: illegal address 3 (len=2) |
| 296295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296335 | **DUT** | IN  pkt #920 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296365 | **DUT** | IN  pkt #920 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296365 | yapp monitor | RX pkt #920 on the input: addr=3 len=2 parity=bad gap=3 |
| 296365 | reference | Packet dropped: illegal address 3 (len=2) |
| 296365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 296430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 296545 | **DUT** | IN  pkt #921 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296575 | **DUT** | IN  pkt #921 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296575 | yapp monitor | RX pkt #921 on the input: addr=3 len=2 parity=bad gap=17 |
| 296575 | reference | Packet dropped: illegal address 3 (len=2) |
| 296575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296595 | **DUT** | IN  pkt #922 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296625 | **DUT** | IN  pkt #922 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296625 | yapp monitor | RX pkt #922 on the input: addr=3 len=2 parity=bad gap=1 |
| 296625 | reference | Packet dropped: illegal address 3 (len=2) |
| 296625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 296715 | **DUT** | IN  pkt #923 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 296745 | **DUT** | IN  pkt #923 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296745 | yapp monitor | RX pkt #923 on the input: addr=3 len=2 parity=bad gap=8 |
| 296745 | reference | Packet dropped: illegal address 3 (len=2) |
| 296745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296810 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 296955 | **DUT** | IN  pkt #924 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296985 | **DUT** | IN  pkt #924 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296985 | yapp monitor | RX pkt #924 on the input: addr=3 len=2 parity=bad gap=20 |
| 296985 | reference | Packet dropped: illegal address 3 (len=2) |
| 296985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297030 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 297185 | **DUT** | IN  pkt #925 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297215 | **DUT** | IN  pkt #925 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297215 | yapp monitor | RX pkt #925 on the input: addr=3 len=2 parity=bad gap=19 |
| 297215 | reference | Packet dropped: illegal address 3 (len=2) |
| 297215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 297355 | **DUT** | IN  pkt #926 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297385 | **DUT** | IN  pkt #926 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297385 | yapp monitor | RX pkt #926 on the input: addr=3 len=2 parity=bad gap=13 |
| 297385 | reference | Packet dropped: illegal address 3 (len=2) |
| 297385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297415 | **DUT** | IN  pkt #927 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297445 | **DUT** | IN  pkt #927 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297445 | yapp monitor | RX pkt #927 on the input: addr=3 len=2 parity=bad gap=2 |
| 297445 | reference | Packet dropped: illegal address 3 (len=2) |
| 297445 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 297470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 297565 | **DUT** | IN  pkt #928 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297595 | **DUT** | IN  pkt #928 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297595 | yapp monitor | RX pkt #928 on the input: addr=3 len=2 parity=bad gap=11 |
| 297595 | reference | Packet dropped: illegal address 3 (len=2) |
| 297595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 297675 | **DUT** | IN  pkt #929 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297705 | **DUT** | IN  pkt #929 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297705 | yapp monitor | RX pkt #929 on the input: addr=3 len=2 parity=bad gap=7 |
| 297705 | reference | Packet dropped: illegal address 3 (len=2) |
| 297705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 297885 | **DUT** | IN  pkt #930 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297915 | **DUT** | IN  pkt #930 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297915 | yapp monitor | RX pkt #930 on the input: addr=3 len=2 parity=bad gap=17 |
| 297915 | reference | Packet dropped: illegal address 3 (len=2) |
| 297915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 298115 | **DUT** | IN  pkt #931 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298145 | **DUT** | IN  pkt #931 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298145 | yapp monitor | RX pkt #931 on the input: addr=3 len=2 parity=bad gap=19 |
| 298145 | reference | Packet dropped: illegal address 3 (len=2) |
| 298145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 298305 | **DUT** | IN  pkt #932 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298335 | **DUT** | IN  pkt #932 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298335 | yapp monitor | RX pkt #932 on the input: addr=3 len=2 parity=bad gap=15 |
| 298335 | reference | Packet dropped: illegal address 3 (len=2) |
| 298335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 298525 | **DUT** | IN  pkt #933 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298555 | **DUT** | IN  pkt #933 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298555 | yapp monitor | RX pkt #933 on the input: addr=3 len=2 parity=bad gap=18 |
| 298555 | reference | Packet dropped: illegal address 3 (len=2) |
| 298555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 298595 | **DUT** | IN  pkt #934 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298625 | **DUT** | IN  pkt #934 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298625 | yapp monitor | RX pkt #934 on the input: addr=3 len=2 parity=bad gap=3 |
| 298625 | reference | Packet dropped: illegal address 3 (len=2) |
| 298625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 298675 | **DUT** | IN  pkt #935 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298705 | **DUT** | IN  pkt #935 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298705 | yapp monitor | RX pkt #935 on the input: addr=3 len=2 parity=bad gap=4 |
| 298705 | reference | Packet dropped: illegal address 3 (len=2) |
| 298705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 298845 | **DUT** | IN  pkt #936 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298875 | **DUT** | IN  pkt #936 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298875 | yapp monitor | RX pkt #936 on the input: addr=3 len=2 parity=bad gap=13 |
| 298875 | reference | Packet dropped: illegal address 3 (len=2) |
| 298875 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 299035 | **DUT** | IN  pkt #937 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299065 | **DUT** | IN  pkt #937 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299065 | yapp monitor | RX pkt #937 on the input: addr=3 len=2 parity=bad gap=15 |
| 299065 | reference | Packet dropped: illegal address 3 (len=2) |
| 299065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 299185 | **DUT** | IN  pkt #938 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299215 | **DUT** | IN  pkt #938 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299215 | yapp monitor | RX pkt #938 on the input: addr=3 len=2 parity=bad gap=11 |
| 299215 | reference | Packet dropped: illegal address 3 (len=2) |
| 299215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 299275 | **DUT** | IN  pkt #939 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299305 | **DUT** | IN  pkt #939 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299305 | yapp monitor | RX pkt #939 on the input: addr=3 len=2 parity=bad gap=5 |
| 299305 | reference | Packet dropped: illegal address 3 (len=2) |
| 299305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299370 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 299385 | **DUT** | IN  pkt #940 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299415 | **DUT** | IN  pkt #940 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299415 | yapp monitor | RX pkt #940 on the input: addr=3 len=2 parity=bad gap=7 |
| 299415 | reference | Packet dropped: illegal address 3 (len=2) |
| 299415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 299615 | **DUT** | IN  pkt #941 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299645 | **DUT** | IN  pkt #941 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299645 | yapp monitor | RX pkt #941 on the input: addr=3 len=2 parity=bad gap=19 |
| 299645 | reference | Packet dropped: illegal address 3 (len=2) |
| 299645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 299825 | **DUT** | IN  pkt #942 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299855 | **DUT** | IN  pkt #942 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299855 | yapp monitor | RX pkt #942 on the input: addr=3 len=2 parity=bad gap=17 |
| 299855 | reference | Packet dropped: illegal address 3 (len=2) |
| 299855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 299895 | **DUT** | IN  pkt #943 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299925 | **DUT** | IN  pkt #943 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299925 | yapp monitor | RX pkt #943 on the input: addr=3 len=2 parity=bad gap=3 |
| 299925 | reference | Packet dropped: illegal address 3 (len=2) |
| 299925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 300055 | **DUT** | IN  pkt #944 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300085 | **DUT** | IN  pkt #944 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300085 | yapp monitor | RX pkt #944 on the input: addr=3 len=2 parity=bad gap=12 |
| 300085 | reference | Packet dropped: illegal address 3 (len=2) |
| 300085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 300145 | **DUT** | IN  pkt #945 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300175 | **DUT** | IN  pkt #945 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300175 | yapp monitor | RX pkt #945 on the input: addr=3 len=2 parity=bad gap=5 |
| 300175 | reference | Packet dropped: illegal address 3 (len=2) |
| 300175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 300255 | **DUT** | IN  pkt #946 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300285 | **DUT** | IN  pkt #946 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300285 | yapp monitor | RX pkt #946 on the input: addr=3 len=2 parity=bad gap=7 |
| 300285 | reference | Packet dropped: illegal address 3 (len=2) |
| 300285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 300495 | **DUT** | IN  pkt #947 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300525 | **DUT** | IN  pkt #947 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300525 | yapp monitor | RX pkt #947 on the input: addr=3 len=2 parity=bad gap=20 |
| 300525 | reference | Packet dropped: illegal address 3 (len=2) |
| 300525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300590 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 300665 | **DUT** | IN  pkt #948 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300695 | **DUT** | IN  pkt #948 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300695 | yapp monitor | RX pkt #948 on the input: addr=3 len=2 parity=bad gap=13 |
| 300695 | reference | Packet dropped: illegal address 3 (len=2) |
| 300695 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300710 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 300905 | **DUT** | IN  pkt #949 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300935 | **DUT** | IN  pkt #949 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300935 | yapp monitor | RX pkt #949 on the input: addr=3 len=2 parity=bad gap=20 |
| 300935 | reference | Packet dropped: illegal address 3 (len=2) |
| 300935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301030 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 301105 | **DUT** | IN  pkt #950 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301135 | **DUT** | IN  pkt #950 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301135 | yapp monitor | RX pkt #950 on the input: addr=3 len=2 parity=bad gap=16 |
| 301135 | reference | Packet dropped: illegal address 3 (len=2) |
| 301135 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301165 | **DUT** | IN  pkt #951 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 301195 | **DUT** | IN  pkt #951 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301195 | yapp monitor | RX pkt #951 on the input: addr=3 len=2 parity=bad gap=2 |
| 301195 | reference | Packet dropped: illegal address 3 (len=2) |
| 301195 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 301275 | **DUT** | IN  pkt #952 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301305 | **DUT** | IN  pkt #952 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301305 | yapp monitor | RX pkt #952 on the input: addr=3 len=2 parity=bad gap=7 |
| 301305 | reference | Packet dropped: illegal address 3 (len=2) |
| 301305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 301435 | **DUT** | IN  pkt #953 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301465 | **DUT** | IN  pkt #953 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301465 | yapp monitor | RX pkt #953 on the input: addr=3 len=2 parity=bad gap=12 |
| 301465 | reference | Packet dropped: illegal address 3 (len=2) |
| 301465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301485 | **DUT** | IN  pkt #954 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301510 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 301515 | **DUT** | IN  pkt #954 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301515 | yapp monitor | RX pkt #954 on the input: addr=3 len=2 parity=bad gap=1 |
| 301515 | reference | Packet dropped: illegal address 3 (len=2) |
| 301515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 301615 | **DUT** | IN  pkt #955 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301645 | **DUT** | IN  pkt #955 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301645 | yapp monitor | RX pkt #955 on the input: addr=3 len=2 parity=bad gap=9 |
| 301645 | reference | Packet dropped: illegal address 3 (len=2) |
| 301645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 301835 | **DUT** | IN  pkt #956 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301865 | **DUT** | IN  pkt #956 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301865 | yapp monitor | RX pkt #956 on the input: addr=3 len=2 parity=bad gap=18 |
| 301865 | reference | Packet dropped: illegal address 3 (len=2) |
| 301865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 301955 | **DUT** | IN  pkt #957 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301985 | **DUT** | IN  pkt #957 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301985 | yapp monitor | RX pkt #957 on the input: addr=3 len=2 parity=bad gap=8 |
| 301985 | reference | Packet dropped: illegal address 3 (len=2) |
| 301985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 302085 | **DUT** | IN  pkt #958 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302115 | **DUT** | IN  pkt #958 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302115 | yapp monitor | RX pkt #958 on the input: addr=3 len=2 parity=bad gap=9 |
| 302115 | reference | Packet dropped: illegal address 3 (len=2) |
| 302115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 302185 | **DUT** | IN  pkt #959 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302215 | **DUT** | IN  pkt #959 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302215 | yapp monitor | RX pkt #959 on the input: addr=3 len=2 parity=bad gap=6 |
| 302215 | reference | Packet dropped: illegal address 3 (len=2) |
| 302215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 302395 | **DUT** | IN  pkt #960 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302425 | **DUT** | IN  pkt #960 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302425 | yapp monitor | RX pkt #960 on the input: addr=3 len=2 parity=bad gap=17 |
| 302425 | reference | Packet dropped: illegal address 3 (len=2) |
| 302425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 302555 | **DUT** | IN  pkt #961 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302585 | **DUT** | IN  pkt #961 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302585 | yapp monitor | RX pkt #961 on the input: addr=3 len=2 parity=bad gap=12 |
| 302585 | reference | Packet dropped: illegal address 3 (len=2) |
| 302585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 302755 | **DUT** | IN  pkt #962 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302785 | **DUT** | IN  pkt #962 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302785 | yapp monitor | RX pkt #962 on the input: addr=3 len=2 parity=bad gap=16 |
| 302785 | reference | Packet dropped: illegal address 3 (len=2) |
| 302785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302805 | **DUT** | IN  pkt #963 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 302835 | **DUT** | IN  pkt #963 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302835 | yapp monitor | RX pkt #963 on the input: addr=3 len=2 parity=bad gap=1 |
| 302835 | reference | Packet dropped: illegal address 3 (len=2) |
| 302835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 303025 | **DUT** | IN  pkt #964 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303055 | **DUT** | IN  pkt #964 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303055 | yapp monitor | RX pkt #964 on the input: addr=3 len=2 parity=bad gap=18 |
| 303055 | reference | Packet dropped: illegal address 3 (len=2) |
| 303055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303185 | **DUT** | IN  pkt #965 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303215 | **DUT** | IN  pkt #965 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303215 | yapp monitor | RX pkt #965 on the input: addr=3 len=2 parity=bad gap=12 |
| 303215 | reference | Packet dropped: illegal address 3 (len=2) |
| 303215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303285 | **DUT** | IN  pkt #966 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303315 | **DUT** | IN  pkt #966 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303315 | yapp monitor | RX pkt #966 on the input: addr=3 len=2 parity=bad gap=6 |
| 303315 | reference | Packet dropped: illegal address 3 (len=2) |
| 303315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 303525 | **DUT** | IN  pkt #967 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303555 | **DUT** | IN  pkt #967 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303555 | yapp monitor | RX pkt #967 on the input: addr=3 len=2 parity=bad gap=20 |
| 303555 | reference | Packet dropped: illegal address 3 (len=2) |
| 303555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 303655 | **DUT** | IN  pkt #968 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303685 | **DUT** | IN  pkt #968 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303685 | yapp monitor | RX pkt #968 on the input: addr=3 len=2 parity=bad gap=9 |
| 303685 | reference | Packet dropped: illegal address 3 (len=2) |
| 303685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 303885 | **DUT** | IN  pkt #969 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303915 | **DUT** | IN  pkt #969 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303915 | yapp monitor | RX pkt #969 on the input: addr=3 len=2 parity=bad gap=19 |
| 303915 | reference | Packet dropped: illegal address 3 (len=2) |
| 303915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303985 | **DUT** | IN  pkt #970 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304015 | **DUT** | IN  pkt #970 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304015 | yapp monitor | RX pkt #970 on the input: addr=3 len=2 parity=bad gap=6 |
| 304015 | reference | Packet dropped: illegal address 3 (len=2) |
| 304015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 304205 | **DUT** | IN  pkt #971 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304235 | **DUT** | IN  pkt #971 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304235 | yapp monitor | RX pkt #971 on the input: addr=3 len=2 parity=bad gap=18 |
| 304235 | reference | Packet dropped: illegal address 3 (len=2) |
| 304235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 304445 | **DUT** | IN  pkt #972 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304475 | **DUT** | IN  pkt #972 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304475 | yapp monitor | RX pkt #972 on the input: addr=3 len=2 parity=bad gap=20 |
| 304475 | reference | Packet dropped: illegal address 3 (len=2) |
| 304475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 304675 | **DUT** | IN  pkt #973 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304705 | **DUT** | IN  pkt #973 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304705 | yapp monitor | RX pkt #973 on the input: addr=3 len=2 parity=bad gap=19 |
| 304705 | reference | Packet dropped: illegal address 3 (len=2) |
| 304705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 304835 | **DUT** | IN  pkt #974 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304865 | **DUT** | IN  pkt #974 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304865 | yapp monitor | RX pkt #974 on the input: addr=3 len=2 parity=bad gap=12 |
| 304865 | reference | Packet dropped: illegal address 3 (len=2) |
| 304865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305075 | **DUT** | IN  pkt #975 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305105 | **DUT** | IN  pkt #975 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305105 | yapp monitor | RX pkt #975 on the input: addr=3 len=2 parity=bad gap=20 |
| 305105 | reference | Packet dropped: illegal address 3 (len=2) |
| 305105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 305315 | **DUT** | IN  pkt #976 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305345 | **DUT** | IN  pkt #976 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305345 | yapp monitor | RX pkt #976 on the input: addr=3 len=2 parity=bad gap=20 |
| 305345 | reference | Packet dropped: illegal address 3 (len=2) |
| 305345 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305475 | **DUT** | IN  pkt #977 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305505 | **DUT** | IN  pkt #977 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305505 | yapp monitor | RX pkt #977 on the input: addr=3 len=2 parity=bad gap=12 |
| 305505 | reference | Packet dropped: illegal address 3 (len=2) |
| 305505 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305715 | **DUT** | IN  pkt #978 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305745 | **DUT** | IN  pkt #978 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305745 | yapp monitor | RX pkt #978 on the input: addr=3 len=2 parity=bad gap=20 |
| 305745 | reference | Packet dropped: illegal address 3 (len=2) |
| 305745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 305855 | **DUT** | IN  pkt #979 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305885 | **DUT** | IN  pkt #979 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305885 | yapp monitor | RX pkt #979 on the input: addr=3 len=2 parity=bad gap=10 |
| 305885 | reference | Packet dropped: illegal address 3 (len=2) |
| 305885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305945 | **DUT** | IN  pkt #980 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 305975 | **DUT** | IN  pkt #980 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305975 | yapp monitor | RX pkt #980 on the input: addr=3 len=2 parity=bad gap=5 |
| 305975 | reference | Packet dropped: illegal address 3 (len=2) |
| 305975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 305995 | **DUT** | IN  pkt #981 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306025 | **DUT** | IN  pkt #981 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306025 | yapp monitor | RX pkt #981 on the input: addr=3 len=2 parity=bad gap=1 |
| 306025 | reference | Packet dropped: illegal address 3 (len=2) |
| 306025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 306105 | **DUT** | IN  pkt #982 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306135 | **DUT** | IN  pkt #982 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306135 | yapp monitor | RX pkt #982 on the input: addr=3 len=2 parity=bad gap=7 |
| 306135 | reference | Packet dropped: illegal address 3 (len=2) |
| 306135 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 306345 | **DUT** | IN  pkt #983 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306375 | **DUT** | IN  pkt #983 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306375 | yapp monitor | RX pkt #983 on the input: addr=3 len=2 parity=bad gap=20 |
| 306375 | reference | Packet dropped: illegal address 3 (len=2) |
| 306375 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306445 | **DUT** | IN  pkt #984 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 306475 | **DUT** | IN  pkt #984 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306475 | yapp monitor | RX pkt #984 on the input: addr=3 len=2 parity=bad gap=6 |
| 306475 | reference | Packet dropped: illegal address 3 (len=2) |
| 306475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 306615 | **DUT** | IN  pkt #985 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306645 | **DUT** | IN  pkt #985 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306645 | yapp monitor | RX pkt #985 on the input: addr=3 len=2 parity=bad gap=13 |
| 306645 | reference | Packet dropped: illegal address 3 (len=2) |
| 306645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 306815 | **DUT** | IN  pkt #986 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306845 | **DUT** | IN  pkt #986 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306845 | yapp monitor | RX pkt #986 on the input: addr=3 len=2 parity=bad gap=16 |
| 306845 | reference | Packet dropped: illegal address 3 (len=2) |
| 306845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 307055 | **DUT** | IN  pkt #987 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307085 | **DUT** | IN  pkt #987 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307085 | yapp monitor | RX pkt #987 on the input: addr=3 len=2 parity=bad gap=20 |
| 307085 | reference | Packet dropped: illegal address 3 (len=2) |
| 307085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 307215 | **DUT** | IN  pkt #988 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307245 | **DUT** | IN  pkt #988 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307245 | yapp monitor | RX pkt #988 on the input: addr=3 len=2 parity=bad gap=12 |
| 307245 | reference | Packet dropped: illegal address 3 (len=2) |
| 307245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 307455 | **DUT** | IN  pkt #989 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307485 | **DUT** | IN  pkt #989 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307485 | yapp monitor | RX pkt #989 on the input: addr=3 len=2 parity=bad gap=20 |
| 307485 | reference | Packet dropped: illegal address 3 (len=2) |
| 307485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 307695 | **DUT** | IN  pkt #990 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307725 | **DUT** | IN  pkt #990 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307725 | yapp monitor | RX pkt #990 on the input: addr=3 len=2 parity=bad gap=20 |
| 307725 | reference | Packet dropped: illegal address 3 (len=2) |
| 307725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307765 | **DUT** | IN  pkt #991 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 307795 | **DUT** | IN  pkt #991 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307795 | yapp monitor | RX pkt #991 on the input: addr=3 len=2 parity=bad gap=3 |
| 307795 | reference | Packet dropped: illegal address 3 (len=2) |
| 307795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 307925 | **DUT** | IN  pkt #992 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307955 | **DUT** | IN  pkt #992 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307955 | yapp monitor | RX pkt #992 on the input: addr=3 len=2 parity=bad gap=12 |
| 307955 | reference | Packet dropped: illegal address 3 (len=2) |
| 307955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 308095 | **DUT** | IN  pkt #993 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308125 | **DUT** | IN  pkt #993 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308125 | yapp monitor | RX pkt #993 on the input: addr=3 len=2 parity=bad gap=13 |
| 308125 | reference | Packet dropped: illegal address 3 (len=2) |
| 308125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 308335 | **DUT** | IN  pkt #994 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308365 | **DUT** | IN  pkt #994 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308365 | yapp monitor | RX pkt #994 on the input: addr=3 len=2 parity=bad gap=20 |
| 308365 | reference | Packet dropped: illegal address 3 (len=2) |
| 308365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 308545 | **DUT** | IN  pkt #995 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308575 | **DUT** | IN  pkt #995 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308575 | yapp monitor | RX pkt #995 on the input: addr=3 len=2 parity=bad gap=17 |
| 308575 | reference | Packet dropped: illegal address 3 (len=2) |
| 308575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 308765 | **DUT** | IN  pkt #996 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308795 | **DUT** | IN  pkt #996 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308795 | yapp monitor | RX pkt #996 on the input: addr=3 len=2 parity=bad gap=18 |
| 308795 | reference | Packet dropped: illegal address 3 (len=2) |
| 308795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 309005 | **DUT** | IN  pkt #997 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309035 | **DUT** | IN  pkt #997 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309035 | yapp monitor | RX pkt #997 on the input: addr=3 len=2 parity=bad gap=20 |
| 309035 | reference | Packet dropped: illegal address 3 (len=2) |
| 309035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 309245 | **DUT** | IN  pkt #998 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309275 | **DUT** | IN  pkt #998 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309275 | yapp monitor | RX pkt #998 on the input: addr=3 len=2 parity=bad gap=20 |
| 309275 | reference | Packet dropped: illegal address 3 (len=2) |
| 309275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 309295 | **DUT** | IN  pkt #999 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309325 | **DUT** | IN  pkt #999 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309325 | yapp monitor | RX pkt #999 on the input: addr=3 len=2 parity=bad gap=1 |
| 309325 | reference | Packet dropped: illegal address 3 (len=2) |
| 309325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 309535 | **DUT** | IN  pkt #1000 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309565 | **DUT** | IN  pkt #1000 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309565 | yapp monitor | RX pkt #1000 on the input: addr=3 len=2 parity=bad gap=20 |
| 309565 | reference | Packet dropped: illegal address 3 (len=2) |
| 309565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 309755 | **DUT** | IN  pkt #1001 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309785 | **DUT** | IN  pkt #1001 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309785 | yapp monitor | RX pkt #1001 on the input: addr=3 len=2 parity=bad gap=18 |
| 309785 | reference | Packet dropped: illegal address 3 (len=2) |
| 309785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309955 | **DUT** | IN  pkt #1002 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309985 | **DUT** | IN  pkt #1002 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309985 | yapp monitor | RX pkt #1002 on the input: addr=3 len=2 parity=bad gap=16 |
| 309985 | reference | Packet dropped: illegal address 3 (len=2) |
| 309985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 310175 | **DUT** | IN  pkt #1003 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310205 | **DUT** | IN  pkt #1003 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310205 | yapp monitor | RX pkt #1003 on the input: addr=3 len=2 parity=bad gap=18 |
| 310205 | reference | Packet dropped: illegal address 3 (len=2) |
| 310205 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 310415 | **DUT** | IN  pkt #1004 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310445 | **DUT** | IN  pkt #1004 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310445 | yapp monitor | RX pkt #1004 on the input: addr=3 len=2 parity=bad gap=20 |
| 310445 | reference | Packet dropped: illegal address 3 (len=2) |
| 310445 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 310645 | **DUT** | IN  pkt #1005 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310675 | **DUT** | IN  pkt #1005 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310675 | yapp monitor | RX pkt #1005 on the input: addr=3 len=2 parity=bad gap=19 |
| 310675 | reference | Packet dropped: illegal address 3 (len=2) |
| 310675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 310865 | **DUT** | IN  pkt #1006 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310895 | **DUT** | IN  pkt #1006 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310895 | yapp monitor | RX pkt #1006 on the input: addr=3 len=2 parity=bad gap=18 |
| 310895 | reference | Packet dropped: illegal address 3 (len=2) |
| 310895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 311075 | **DUT** | IN  pkt #1007 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311105 | **DUT** | IN  pkt #1007 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311105 | yapp monitor | RX pkt #1007 on the input: addr=3 len=2 parity=bad gap=17 |
| 311105 | reference | Packet dropped: illegal address 3 (len=2) |
| 311105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 311285 | **DUT** | IN  pkt #1008 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311315 | **DUT** | IN  pkt #1008 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311315 | yapp monitor | RX pkt #1008 on the input: addr=3 len=2 parity=bad gap=17 |
| 311315 | reference | Packet dropped: illegal address 3 (len=2) |
| 311315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 311525 | **DUT** | IN  pkt #1009 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311555 | **DUT** | IN  pkt #1009 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311555 | yapp monitor | RX pkt #1009 on the input: addr=3 len=2 parity=bad gap=20 |
| 311555 | reference | Packet dropped: illegal address 3 (len=2) |
| 311555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 311765 | **DUT** | IN  pkt #1010 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311795 | **DUT** | IN  pkt #1010 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311795 | yapp monitor | RX pkt #1010 on the input: addr=3 len=2 parity=bad gap=20 |
| 311795 | reference | Packet dropped: illegal address 3 (len=2) |
| 311795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 312005 | **DUT** | IN  pkt #1011 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312035 | **DUT** | IN  pkt #1011 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312035 | yapp monitor | RX pkt #1011 on the input: addr=3 len=2 parity=bad gap=20 |
| 312035 | reference | Packet dropped: illegal address 3 (len=2) |
| 312035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 312245 | **DUT** | IN  pkt #1012 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312275 | **DUT** | IN  pkt #1012 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312275 | yapp monitor | RX pkt #1012 on the input: addr=3 len=2 parity=bad gap=20 |
| 312275 | reference | Packet dropped: illegal address 3 (len=2) |
| 312275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 312475 | **DUT** | IN  pkt #1013 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312505 | **DUT** | IN  pkt #1013 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312505 | yapp monitor | RX pkt #1013 on the input: addr=3 len=2 parity=bad gap=19 |
| 312505 | reference | Packet dropped: illegal address 3 (len=2) |
| 312505 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312535 | **DUT** | IN  pkt #1014 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 312565 | **DUT** | IN  pkt #1014 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312565 | yapp monitor | RX pkt #1014 on the input: addr=3 len=2 parity=bad gap=2 |
| 312565 | reference | Packet dropped: illegal address 3 (len=2) |
| 312565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 312645 | **DUT** | IN  pkt #1015 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312675 | **DUT** | IN  pkt #1015 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312675 | yapp monitor | RX pkt #1015 on the input: addr=3 len=2 parity=bad gap=7 |
| 312675 | reference | Packet dropped: illegal address 3 (len=2) |
| 312675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 312795 | **DUT** | IN  pkt #1016 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312825 | **DUT** | IN  pkt #1016 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312825 | yapp monitor | RX pkt #1016 on the input: addr=3 len=2 parity=bad gap=11 |
| 312825 | reference | Packet dropped: illegal address 3 (len=2) |
| 312825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 313015 | **DUT** | IN  pkt #1017 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313045 | **DUT** | IN  pkt #1017 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313045 | yapp monitor | RX pkt #1017 on the input: addr=3 len=2 parity=bad gap=18 |
| 313045 | reference | Packet dropped: illegal address 3 (len=2) |
| 313045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313085 | **DUT** | IN  pkt #1018 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 313115 | **DUT** | IN  pkt #1018 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313115 | yapp monitor | RX pkt #1018 on the input: addr=3 len=2 parity=bad gap=3 |
| 313115 | reference | Packet dropped: illegal address 3 (len=2) |
| 313115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 313265 | **DUT** | IN  pkt #1019 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313295 | **DUT** | IN  pkt #1019 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313295 | yapp monitor | RX pkt #1019 on the input: addr=3 len=2 parity=bad gap=14 |
| 313295 | reference | Packet dropped: illegal address 3 (len=2) |
| 313295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 313365 | **DUT** | IN  pkt #1020 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313395 | **DUT** | IN  pkt #1020 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313395 | yapp monitor | RX pkt #1020 on the input: addr=3 len=2 parity=bad gap=6 |
| 313395 | reference | Packet dropped: illegal address 3 (len=2) |
| 313395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 313545 | **DUT** | IN  pkt #1021 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313575 | **DUT** | IN  pkt #1021 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313575 | yapp monitor | RX pkt #1021 on the input: addr=3 len=2 parity=bad gap=14 |
| 313575 | reference | Packet dropped: illegal address 3 (len=2) |
| 313575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313615 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 313645 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 313670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 313675 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 313705 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 313735 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 313760 | **test** | STAGE: 8. ctrl_reg and en_reg back to their reset values, every register read |
| 313765 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 313785 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 313785 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 313785 | reference | maxpktsize is now 63 |
| 313805 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 313805 | reference | router_en is now 1 (en_reg 0x01) |
| 313835 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 313865 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 313895 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 313925 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 313955 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 313985 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 314015 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 314045 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 314075 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 314105 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 314135 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 314165 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 314195 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 314220 | **test** | STAGE: sweep done: 1021 packets, 3628 HBUS reads |
| 314225 | hbus monitor | Collected READ  addr=0x100d data=0x02 |
| 314715 | **test** | STAGE: 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 314715 | **test** | HBUS address map coverage 100% |
| 314715 | **test** | ctrl_reg / en_reg bits coverage 100% |
| 314715 | **test** | yapp_mem data patterns coverage 100% |
| 314715 | **test** | counter values coverage 100% |
| 314715 | **test** | STAGE: done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |
| 314915 | ch0 monitor | Channel 0 report: 1 packets collected |
| 314915 | ch1 monitor | Channel 1 report: 0 packets collected |
| 314915 | ch2 monitor | Channel 2 report: 0 packets collected |
| 314915 | hbus monitor | HBUS report: 1459 writes, 3628 reads |
| 314915 | coverage | Coverage of the router configuration: 60.9% |
| 314915 | coverage | HBUS address coverage: 5087 accesses sampled, coverage 100.0% |
| 314915 | coverage | HBUS register bits coverage: 51 writes to ctrl_reg/en_reg, coverage 100.0% |
| 314915 | coverage | HBUS counter value coverage: 876 counter reads sampled, coverage 100.0% |
| 314915 | coverage | HBUS yapp_mem data coverage: 2560 accesses sampled, coverage 100.0% |
| 314915 | reference |  |
| 314915 | reference | HBUS reads checked against the model: 3585 (0 mismatches, 43 of memory bytes never written) |
| 314915 | scoreboard |  |
| 314915 | coverage | YAPP gap coverage: 1020 gaps sampled, coverage 75.0% |
| 314915 | yapp monitor | YAPP monitor report: 1021 packets collected, 1020 with bad parity |
| 314915 | yapp monitor | YAPP gaps: 0 back to back, 64 of 1 cycle, 32 of 2, 924 longer |
| 314915 | coverage | YAPP packet coverage: 1021 packets sampled, coverage 50.0% |
