# hbus_sweep_test  seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 314us · log `hbus_sweep_test_s2.log`

Waves: `hbus_sweep_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fhbus_sweep_test_s2%2Fhbus_sweep_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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
| 370 | 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 32410 | 3. ctrl_reg and en_reg: walking one and walking zero |
| 34050 | 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 67970 | 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 72210 | 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 136210 | 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136410 | 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 181140 | 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 224150 | 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 268660 | 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 313210 | 8. ctrl_reg and en_reg back to their reset values, every register read |
| 313670 | sweep done: 1021 packets, 3628 HBUS reads |
| 314165 | 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 314165 | done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |

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
| 155 | **DUT** | IN  pkt #1 header: addr=0 len=20 -> channel 0 |
| 165 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=20 (receiver waited 0 cycle(s)) |
| 365 | **DUT** | IN  pkt #1 complete: addr=0 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 365 | yapp monitor | RX pkt #1 on the input: addr=0 len=20 parity=good gap=10 |
| 365 | reference | Packet forwarded: addr=0 len=20 -> channel 0 |
| 370 | ch0 driver | ch0: packet consumed (response delay 0) |
| 370 | **test** | STAGE: 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 395 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 395 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 395 | reference | maxpktsize is now 0 |
| 425 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 455 | **DUT** | OUT ch0 pkt #1 done: 22 bytes in 30 cycles |
| 455 | ch0 monitor | ch0 RX pkt #1: addr=0 len=20 parity=good |
| 455 | scoreboard | ch0 pkt matched: addr=0 len=20 (1 matched so far) |
| 455 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 770 | ch0 driver | ch0: packet consumed (response delay 7) |
| 785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 895 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 895 | hbus monitor | Collected WRITE addr=0x1000 data=0xff |
| 895 | reference | maxpktsize is now 63 |
| 925 | hbus monitor | Collected READ  addr=0x1000 data=0xff |
| 955 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1395 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1395 | hbus monitor | Collected WRITE addr=0x1000 data=0x55 |
| 1395 | reference | maxpktsize is now 21 |
| 1425 | hbus monitor | Collected READ  addr=0x1000 data=0x55 |
| 1455 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1895 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 1895 | hbus monitor | Collected WRITE addr=0x1000 data=0xaa |
| 1895 | reference | maxpktsize is now 42 |
| 1925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 1955 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2395 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 2395 | hbus monitor | Collected WRITE addr=0x1001 data=0x00 |
| 2395 | reference | router_en is now 0 (en_reg 0x00) |
| 2425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2455 | hbus monitor | Collected READ  addr=0x1001 data=0x00 |
| 2485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2895 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 2895 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 2895 | reference | router_en is now 1 (en_reg 0xff) |
| 2925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2955 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 2985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3395 | hbus monitor | Collected WRITE addr=0x1001 data=0x55 |
| 3395 | reference | router_en is now 1 (en_reg 0x55) |
| 3425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3455 | hbus monitor | Collected READ  addr=0x1001 data=0x55 |
| 3485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3895 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 3895 | hbus monitor | Collected WRITE addr=0x1001 data=0xaa |
| 3895 | reference | router_en is now 0 (en_reg 0xaa) |
| 3925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 3985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4395 | hbus monitor | Collected WRITE addr=0x1002 data=0x00 |
| 4425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4895 | hbus monitor | Collected WRITE addr=0x1002 data=0xff |
| 4925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5395 | hbus monitor | Collected WRITE addr=0x1002 data=0x55 |
| 5425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5895 | hbus monitor | Collected WRITE addr=0x1002 data=0xaa |
| 5925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6395 | hbus monitor | Collected WRITE addr=0x1003 data=0x00 |
| 6425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6895 | hbus monitor | Collected WRITE addr=0x1003 data=0xff |
| 6925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7395 | hbus monitor | Collected WRITE addr=0x1003 data=0x55 |
| 7425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7895 | hbus monitor | Collected WRITE addr=0x1003 data=0xaa |
| 7925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8395 | hbus monitor | Collected WRITE addr=0x1004 data=0x00 |
| 8425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8895 | hbus monitor | Collected WRITE addr=0x1004 data=0xff |
| 8925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9395 | hbus monitor | Collected WRITE addr=0x1004 data=0x55 |
| 9425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9895 | hbus monitor | Collected WRITE addr=0x1004 data=0xaa |
| 9925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10395 | hbus monitor | Collected WRITE addr=0x1005 data=0x00 |
| 10425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10895 | hbus monitor | Collected WRITE addr=0x1005 data=0xff |
| 10925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11395 | hbus monitor | Collected WRITE addr=0x1005 data=0x55 |
| 11425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11895 | hbus monitor | Collected WRITE addr=0x1005 data=0xaa |
| 11925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12395 | hbus monitor | Collected WRITE addr=0x1006 data=0x00 |
| 12425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12895 | hbus monitor | Collected WRITE addr=0x1006 data=0xff |
| 12925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13395 | hbus monitor | Collected WRITE addr=0x1006 data=0x55 |
| 13425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13895 | hbus monitor | Collected WRITE addr=0x1006 data=0xaa |
| 13925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14395 | hbus monitor | Collected WRITE addr=0x1007 data=0x00 |
| 14425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14895 | hbus monitor | Collected WRITE addr=0x1007 data=0xff |
| 14925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15395 | hbus monitor | Collected WRITE addr=0x1007 data=0x55 |
| 15425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15895 | hbus monitor | Collected WRITE addr=0x1007 data=0xaa |
| 15925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16395 | hbus monitor | Collected WRITE addr=0x1008 data=0x00 |
| 16425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16895 | hbus monitor | Collected WRITE addr=0x1008 data=0xff |
| 16925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17395 | hbus monitor | Collected WRITE addr=0x1008 data=0x55 |
| 17425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17895 | hbus monitor | Collected WRITE addr=0x1008 data=0xaa |
| 17925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18395 | hbus monitor | Collected WRITE addr=0x1009 data=0x00 |
| 18425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18895 | hbus monitor | Collected WRITE addr=0x1009 data=0xff |
| 18925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19395 | hbus monitor | Collected WRITE addr=0x1009 data=0x55 |
| 19425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19895 | hbus monitor | Collected WRITE addr=0x1009 data=0xaa |
| 19925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20395 | hbus monitor | Collected WRITE addr=0x100a data=0x00 |
| 20425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20895 | hbus monitor | Collected WRITE addr=0x100a data=0xff |
| 20925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21395 | hbus monitor | Collected WRITE addr=0x100a data=0x55 |
| 21425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21895 | hbus monitor | Collected WRITE addr=0x100a data=0xaa |
| 21925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22395 | hbus monitor | Collected WRITE addr=0x100b data=0x00 |
| 22425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22895 | hbus monitor | Collected WRITE addr=0x100b data=0xff |
| 22925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23395 | hbus monitor | Collected WRITE addr=0x100b data=0x55 |
| 23425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23895 | hbus monitor | Collected WRITE addr=0x100b data=0xaa |
| 23925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24395 | hbus monitor | Collected WRITE addr=0x100c data=0x00 |
| 24425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24895 | hbus monitor | Collected WRITE addr=0x100c data=0xff |
| 24925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25395 | hbus monitor | Collected WRITE addr=0x100c data=0x55 |
| 25425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25895 | hbus monitor | Collected WRITE addr=0x100c data=0xaa |
| 25925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26395 | hbus monitor | Collected WRITE addr=0x100d data=0x00 |
| 26425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26895 | hbus monitor | Collected WRITE addr=0x100d data=0xff |
| 26925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27395 | hbus monitor | Collected WRITE addr=0x100d data=0x55 |
| 27425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27895 | hbus monitor | Collected WRITE addr=0x100d data=0xaa |
| 27925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28395 | hbus monitor | Collected WRITE addr=0x100e data=0x00 |
| 28425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28895 | hbus monitor | Collected WRITE addr=0x100e data=0xff |
| 28925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29395 | hbus monitor | Collected WRITE addr=0x100e data=0x55 |
| 29425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29895 | hbus monitor | Collected WRITE addr=0x100e data=0xaa |
| 29925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30395 | hbus monitor | Collected WRITE addr=0x100f data=0x00 |
| 30425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30895 | hbus monitor | Collected WRITE addr=0x100f data=0xff |
| 30925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31395 | hbus monitor | Collected WRITE addr=0x100f data=0x55 |
| 31425 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31455 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31895 | hbus monitor | Collected WRITE addr=0x100f data=0xaa |
| 31925 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31955 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 32015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 32045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 32075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 32105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 32135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 32165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 32195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 32225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 32255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 32285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 32315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 32345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 32375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 32395 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 32395 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 32395 | reference | maxpktsize is now 63 |
| 32410 | **test** | STAGE: 3. ctrl_reg and en_reg: walking one and walking zero |
| 32415 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 32415 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 32415 | reference | router_en is now 1 (en_reg 0x01) |
| 32435 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 32435 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 32435 | reference | maxpktsize is now 1 |
| 32465 | hbus monitor | Collected READ  addr=0x1000 data=0x01 |
| 32485 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 32485 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 32485 | reference | maxpktsize is now 62 |
| 32515 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 32535 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 32535 | hbus monitor | Collected WRITE addr=0x1000 data=0x02 |
| 32535 | reference | maxpktsize is now 2 |
| 32565 | hbus monitor | Collected READ  addr=0x1000 data=0x02 |
| 32585 | **DUT** | CONFIG router_en=1 maxpktsize=61 |
| 32585 | hbus monitor | Collected WRITE addr=0x1000 data=0xfd |
| 32585 | reference | maxpktsize is now 61 |
| 32615 | hbus monitor | Collected READ  addr=0x1000 data=0xfd |
| 32635 | **DUT** | CONFIG router_en=1 maxpktsize=4 |
| 32635 | hbus monitor | Collected WRITE addr=0x1000 data=0x04 |
| 32635 | reference | maxpktsize is now 4 |
| 32665 | hbus monitor | Collected READ  addr=0x1000 data=0x04 |
| 32685 | **DUT** | CONFIG router_en=1 maxpktsize=59 |
| 32685 | hbus monitor | Collected WRITE addr=0x1000 data=0xfb |
| 32685 | reference | maxpktsize is now 59 |
| 32715 | hbus monitor | Collected READ  addr=0x1000 data=0xfb |
| 32735 | **DUT** | CONFIG router_en=1 maxpktsize=8 |
| 32735 | hbus monitor | Collected WRITE addr=0x1000 data=0x08 |
| 32735 | reference | maxpktsize is now 8 |
| 32765 | hbus monitor | Collected READ  addr=0x1000 data=0x08 |
| 32785 | **DUT** | CONFIG router_en=1 maxpktsize=55 |
| 32785 | hbus monitor | Collected WRITE addr=0x1000 data=0xf7 |
| 32785 | reference | maxpktsize is now 55 |
| 32815 | hbus monitor | Collected READ  addr=0x1000 data=0xf7 |
| 32835 | **DUT** | CONFIG router_en=1 maxpktsize=16 |
| 32835 | hbus monitor | Collected WRITE addr=0x1000 data=0x10 |
| 32835 | reference | maxpktsize is now 16 |
| 32865 | hbus monitor | Collected READ  addr=0x1000 data=0x10 |
| 32885 | **DUT** | CONFIG router_en=1 maxpktsize=47 |
| 32885 | hbus monitor | Collected WRITE addr=0x1000 data=0xef |
| 32885 | reference | maxpktsize is now 47 |
| 32915 | hbus monitor | Collected READ  addr=0x1000 data=0xef |
| 32935 | **DUT** | CONFIG router_en=1 maxpktsize=32 |
| 32935 | hbus monitor | Collected WRITE addr=0x1000 data=0x20 |
| 32935 | reference | maxpktsize is now 32 |
| 32965 | hbus monitor | Collected READ  addr=0x1000 data=0x20 |
| 32985 | **DUT** | CONFIG router_en=1 maxpktsize=31 |
| 32985 | hbus monitor | Collected WRITE addr=0x1000 data=0xdf |
| 32985 | reference | maxpktsize is now 31 |
| 33015 | hbus monitor | Collected READ  addr=0x1000 data=0xdf |
| 33035 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33035 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 33035 | reference | maxpktsize is now 0 |
| 33065 | hbus monitor | Collected READ  addr=0x1000 data=0x40 |
| 33085 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33085 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 33085 | reference | maxpktsize is now 63 |
| 33115 | hbus monitor | Collected READ  addr=0x1000 data=0xbf |
| 33135 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33135 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 33135 | reference | maxpktsize is now 0 |
| 33165 | hbus monitor | Collected READ  addr=0x1000 data=0x80 |
| 33185 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33185 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 33185 | reference | maxpktsize is now 63 |
| 33215 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 33235 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 33235 | reference | router_en is now 1 (en_reg 0x01) |
| 33265 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 33285 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33285 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 33285 | reference | router_en is now 0 (en_reg 0xfe) |
| 33315 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 33335 | hbus monitor | Collected WRITE addr=0x1001 data=0x02 |
| 33335 | reference | router_en is now 0 (en_reg 0x02) |
| 33365 | hbus monitor | Collected READ  addr=0x1001 data=0x02 |
| 33385 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33385 | hbus monitor | Collected WRITE addr=0x1001 data=0xfd |
| 33385 | reference | router_en is now 1 (en_reg 0xfd) |
| 33415 | hbus monitor | Collected READ  addr=0x1001 data=0xfd |
| 33435 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33435 | hbus monitor | Collected WRITE addr=0x1001 data=0x04 |
| 33435 | reference | router_en is now 0 (en_reg 0x04) |
| 33465 | hbus monitor | Collected READ  addr=0x1001 data=0x04 |
| 33485 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33485 | hbus monitor | Collected WRITE addr=0x1001 data=0xfb |
| 33485 | reference | router_en is now 1 (en_reg 0xfb) |
| 33515 | hbus monitor | Collected READ  addr=0x1001 data=0xfb |
| 33535 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33535 | hbus monitor | Collected WRITE addr=0x1001 data=0x08 |
| 33535 | reference | router_en is now 0 (en_reg 0x08) |
| 33565 | hbus monitor | Collected READ  addr=0x1001 data=0x08 |
| 33585 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33585 | hbus monitor | Collected WRITE addr=0x1001 data=0xf7 |
| 33585 | reference | router_en is now 1 (en_reg 0xf7) |
| 33615 | hbus monitor | Collected READ  addr=0x1001 data=0xf7 |
| 33635 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33635 | hbus monitor | Collected WRITE addr=0x1001 data=0x10 |
| 33635 | reference | router_en is now 0 (en_reg 0x10) |
| 33665 | hbus monitor | Collected READ  addr=0x1001 data=0x10 |
| 33685 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33685 | hbus monitor | Collected WRITE addr=0x1001 data=0xef |
| 33685 | reference | router_en is now 1 (en_reg 0xef) |
| 33715 | hbus monitor | Collected READ  addr=0x1001 data=0xef |
| 33735 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33735 | hbus monitor | Collected WRITE addr=0x1001 data=0x20 |
| 33735 | reference | router_en is now 0 (en_reg 0x20) |
| 33765 | hbus monitor | Collected READ  addr=0x1001 data=0x20 |
| 33785 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33785 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 33785 | reference | router_en is now 1 (en_reg 0xdf) |
| 33815 | hbus monitor | Collected READ  addr=0x1001 data=0xdf |
| 33835 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33835 | hbus monitor | Collected WRITE addr=0x1001 data=0x40 |
| 33835 | reference | router_en is now 0 (en_reg 0x40) |
| 33865 | hbus monitor | Collected READ  addr=0x1001 data=0x40 |
| 33885 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33885 | hbus monitor | Collected WRITE addr=0x1001 data=0xbf |
| 33885 | reference | router_en is now 1 (en_reg 0xbf) |
| 33915 | hbus monitor | Collected READ  addr=0x1001 data=0xbf |
| 33935 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33935 | hbus monitor | Collected WRITE addr=0x1001 data=0x80 |
| 33935 | reference | router_en is now 0 (en_reg 0x80) |
| 33965 | hbus monitor | Collected READ  addr=0x1001 data=0x80 |
| 33985 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33985 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 33985 | reference | router_en is now 1 (en_reg 0x7f) |
| 34015 | hbus monitor | Collected READ  addr=0x1001 data=0x7f |
| 34035 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 34035 | reference | maxpktsize is now 63 |
| 34050 | **test** | STAGE: 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 34055 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 34055 | reference | router_en is now 1 (en_reg 0x01) |
| 34075 | hbus monitor | Collected WRITE addr=0x1010 data=0x1d |
| 34105 | hbus monitor | Collected READ  addr=0x1010 data=0x50 |
| 34135 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34165 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34195 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34225 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34255 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34285 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34315 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34345 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 34375 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 34405 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 34435 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 34465 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 34495 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 34525 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 34555 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 34585 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 34605 | hbus monitor | Collected WRITE addr=0x1011 data=0xed |
| 34635 | hbus monitor | Collected READ  addr=0x1011 data=0x6c |
| 34665 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34695 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34725 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34755 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34785 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34815 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34845 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34875 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 34905 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 34935 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 34965 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 34995 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35025 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35055 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35085 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35115 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35135 | hbus monitor | Collected WRITE addr=0x1012 data=0x12 |
| 35165 | hbus monitor | Collected READ  addr=0x1012 data=0x92 |
| 35195 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35225 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35255 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35285 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35315 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35345 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 35375 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 35405 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35435 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35465 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 35495 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 35525 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35555 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35585 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35615 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35645 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35665 | hbus monitor | Collected WRITE addr=0x1013 data=0x14 |
| 35695 | hbus monitor | Collected READ  addr=0x1013 data=0x3f |
| 35725 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35755 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35785 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35815 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35845 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35875 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 35905 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 35935 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35965 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35995 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36025 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36055 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36085 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36115 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36145 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36175 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36195 | hbus monitor | Collected WRITE addr=0x1014 data=0x05 |
| 36225 | hbus monitor | Collected READ  addr=0x1014 data=0xce |
| 36255 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36285 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36315 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36345 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 36375 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 36405 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36435 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36465 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36495 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 36525 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36555 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36585 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36615 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36645 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36675 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36705 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36725 | hbus monitor | Collected WRITE addr=0x1015 data=0x01 |
| 36755 | hbus monitor | Collected READ  addr=0x1015 data=0x89 |
| 36785 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36815 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36845 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36875 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 36905 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 36935 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36965 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36995 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37025 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37055 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37085 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37115 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37145 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37175 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37205 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37235 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37255 | hbus monitor | Collected WRITE addr=0x1016 data=0xab |
| 37285 | hbus monitor | Collected READ  addr=0x1016 data=0x68 |
| 37315 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37345 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 37375 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 37405 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37435 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37465 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 37495 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 37525 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37555 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37585 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37615 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37645 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37675 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37705 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37735 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37765 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37785 | hbus monitor | Collected WRITE addr=0x1017 data=0x09 |
| 37815 | hbus monitor | Collected READ  addr=0x1017 data=0xc2 |
| 37845 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37875 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 37905 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 37935 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37965 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37995 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38025 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38055 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38085 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38115 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38145 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38175 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38205 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38235 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38265 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38295 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38315 | hbus monitor | Collected WRITE addr=0x1018 data=0xaf |
| 38345 | hbus monitor | Collected READ  addr=0x1018 data=0xa3 |
| 38375 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 38405 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38435 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38465 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 38495 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 38525 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38555 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38585 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38615 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38645 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38675 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38705 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38735 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38765 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38795 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38825 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38845 | hbus monitor | Collected WRITE addr=0x1019 data=0x9d |
| 38875 | hbus monitor | Collected READ  addr=0x1019 data=0x28 |
| 38905 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 38935 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38965 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38995 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39025 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39055 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39085 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39115 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39145 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39175 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39205 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39235 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39265 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39295 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39325 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39355 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 39375 | hbus monitor | Collected WRITE addr=0x101a data=0xe1 |
| 39405 | hbus monitor | Collected READ  addr=0x101a data=0xf1 |
| 39435 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39465 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 39495 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 39525 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39555 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39585 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39615 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39645 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39675 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39705 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39735 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39765 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39795 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39825 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39855 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39885 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 39905 | hbus monitor | Collected WRITE addr=0x101b data=0x20 |
| 39935 | hbus monitor | Collected READ  addr=0x101b data=0xd6 |
| 39965 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39995 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40025 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40055 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40085 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40115 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40145 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40175 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40205 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40235 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40265 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40295 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40325 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40355 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 40385 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 40415 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40435 | hbus monitor | Collected WRITE addr=0x101c data=0x94 |
| 40465 | hbus monitor | Collected READ  addr=0x101c data=0x70 |
| 40495 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40525 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40555 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40585 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40615 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40645 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40675 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40705 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40735 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40765 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40795 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40825 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40855 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40885 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 40915 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 40945 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40965 | hbus monitor | Collected WRITE addr=0x101d data=0x56 |
| 40995 | hbus monitor | Collected READ  addr=0x101d data=0xfa |
| 41025 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41055 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 41385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 41415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 41475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 41495 | hbus monitor | Collected WRITE addr=0x101e data=0x26 |
| 41525 | hbus monitor | Collected READ  addr=0x101e data=0xc6 |
| 41555 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41585 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41615 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41645 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41675 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41705 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41735 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41765 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41795 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41825 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41855 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41885 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 41915 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 41945 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41975 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42005 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42025 | hbus monitor | Collected WRITE addr=0x101f data=0x27 |
| 42055 | hbus monitor | Collected READ  addr=0x101f data=0x30 |
| 42085 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42115 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42145 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42175 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42205 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42235 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42265 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42295 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42325 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42355 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 42385 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42415 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42445 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 42475 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 42505 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42535 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42555 | hbus monitor | Collected WRITE addr=0x1020 data=0x97 |
| 42585 | hbus monitor | Collected READ  addr=0x1020 data=0xd5 |
| 42615 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42645 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42675 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42705 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42735 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42765 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42795 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42825 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42855 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42885 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 42915 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42945 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42975 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43005 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43035 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43065 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43085 | hbus monitor | Collected WRITE addr=0x1021 data=0x1d |
| 43115 | hbus monitor | Collected READ  addr=0x1021 data=0x9e |
| 43145 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43175 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43205 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43235 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43265 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43295 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43325 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43355 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 43385 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 43415 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43445 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 43475 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 43505 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43535 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43565 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43595 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43615 | hbus monitor | Collected WRITE addr=0x1022 data=0xf7 |
| 43645 | hbus monitor | Collected READ  addr=0x1022 data=0x94 |
| 43675 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43705 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43735 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43765 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43795 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43825 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43855 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43885 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 43915 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 43945 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43975 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44005 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44035 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44065 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44095 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44125 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44145 | hbus monitor | Collected WRITE addr=0x1023 data=0xfc |
| 44175 | hbus monitor | Collected READ  addr=0x1023 data=0xc4 |
| 44205 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44235 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44265 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44295 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44325 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44355 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 44385 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 44415 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44445 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 44475 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 44505 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44535 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44565 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44595 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44625 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44655 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44675 | hbus monitor | Collected WRITE addr=0x1024 data=0x4b |
| 44705 | hbus monitor | Collected READ  addr=0x1024 data=0xc9 |
| 44735 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44765 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44795 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44825 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44855 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44885 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 44915 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 44945 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44975 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45005 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45035 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45065 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45095 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45125 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45155 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45185 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45205 | hbus monitor | Collected WRITE addr=0x1025 data=0x7a |
| 45235 | hbus monitor | Collected READ  addr=0x1025 data=0x00 |
| 45265 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45295 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45325 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45355 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 45385 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 45415 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45445 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 45475 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 45505 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45535 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45565 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45595 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45625 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45655 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45685 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45715 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45735 | hbus monitor | Collected WRITE addr=0x1026 data=0x76 |
| 45765 | hbus monitor | Collected READ  addr=0x1026 data=0x00 |
| 45795 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45825 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45855 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45885 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 45915 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 45945 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45975 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46005 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46035 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46065 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46095 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46125 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46155 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46185 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46215 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46245 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46265 | hbus monitor | Collected WRITE addr=0x1027 data=0xeb |
| 46295 | hbus monitor | Collected READ  addr=0x1027 data=0x00 |
| 46325 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46355 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 46385 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 46415 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46445 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 46475 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 46505 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46535 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46565 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46595 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46625 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46655 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46685 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46715 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46745 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46775 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46795 | hbus monitor | Collected WRITE addr=0x1028 data=0xdb |
| 46825 | hbus monitor | Collected READ  addr=0x1028 data=0x00 |
| 46855 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46885 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 46915 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 46945 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46975 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47005 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47035 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47065 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47095 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47125 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47155 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47185 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47215 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47245 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47275 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47305 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47325 | hbus monitor | Collected WRITE addr=0x1029 data=0xd4 |
| 47355 | hbus monitor | Collected READ  addr=0x1029 data=0x00 |
| 47385 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 47415 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47445 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 47475 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 47505 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47535 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47565 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47595 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47625 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47655 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47685 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47715 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47745 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47775 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47805 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47835 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47855 | hbus monitor | Collected WRITE addr=0x102a data=0x44 |
| 47885 | hbus monitor | Collected READ  addr=0x102a data=0x00 |
| 47915 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 47945 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47975 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48005 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48035 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48065 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48095 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48125 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48155 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48185 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48215 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48245 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48275 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48305 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48335 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 48365 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 48385 | hbus monitor | Collected WRITE addr=0x102b data=0x8d |
| 48415 | hbus monitor | Collected READ  addr=0x102b data=0x00 |
| 48445 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 48475 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 48505 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48535 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48565 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48595 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48625 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48655 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48685 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48715 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48745 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48775 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48805 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48835 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48865 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 48895 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 48915 | hbus monitor | Collected WRITE addr=0x102c data=0x6f |
| 48945 | hbus monitor | Collected READ  addr=0x102c data=0x00 |
| 48975 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49005 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49035 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49065 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49095 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49125 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49155 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49185 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49215 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49245 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49275 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49305 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49335 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 49365 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 49395 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 49425 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49445 | hbus monitor | Collected WRITE addr=0x102d data=0xa3 |
| 49475 | hbus monitor | Collected READ  addr=0x102d data=0x00 |
| 49505 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49535 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49565 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49595 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49625 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49655 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49685 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49715 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49745 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49775 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49805 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49835 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49865 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 49895 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 49925 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 49955 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49975 | hbus monitor | Collected WRITE addr=0x102e data=0x6e |
| 50005 | hbus monitor | Collected READ  addr=0x102e data=0x00 |
| 50035 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50065 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 50365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 50395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 50425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 50485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 50505 | hbus monitor | Collected WRITE addr=0x102f data=0x84 |
| 50535 | hbus monitor | Collected READ  addr=0x102f data=0x00 |
| 50565 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50595 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50625 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50655 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50685 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50715 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50745 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50775 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50805 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50835 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50865 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 50895 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 50925 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 50955 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50985 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51015 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51035 | hbus monitor | Collected WRITE addr=0x1030 data=0x06 |
| 51065 | hbus monitor | Collected READ  addr=0x1030 data=0x00 |
| 51095 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51125 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51155 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51185 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51215 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51245 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51275 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51305 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51335 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 51365 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 51395 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 51425 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51455 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 51485 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 51515 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51545 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51565 | hbus monitor | Collected WRITE addr=0x1031 data=0x35 |
| 51595 | hbus monitor | Collected READ  addr=0x1031 data=0x00 |
| 51625 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51655 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51685 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51715 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51745 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51775 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51805 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51835 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51865 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 51895 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 51925 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 51955 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51985 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52015 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52045 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52075 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52095 | hbus monitor | Collected WRITE addr=0x1032 data=0x12 |
| 52125 | hbus monitor | Collected READ  addr=0x1032 data=0x00 |
| 52155 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52185 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52215 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52245 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52275 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52305 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52335 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 52365 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 52395 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 52425 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52455 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 52485 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 52515 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52545 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52575 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52605 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52625 | hbus monitor | Collected WRITE addr=0x1033 data=0xe5 |
| 52655 | hbus monitor | Collected READ  addr=0x1033 data=0x00 |
| 52685 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52715 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52745 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52775 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52805 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52835 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52865 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 52895 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 52925 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 52955 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52985 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53015 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53045 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53075 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53105 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53135 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53155 | hbus monitor | Collected WRITE addr=0x1034 data=0xc8 |
| 53185 | hbus monitor | Collected READ  addr=0x1034 data=0x00 |
| 53215 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53245 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53275 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53305 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53335 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 53365 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 53395 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 53425 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53455 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 53485 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 53515 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53545 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53575 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53605 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53635 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53665 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53685 | hbus monitor | Collected WRITE addr=0x1035 data=0x18 |
| 53715 | hbus monitor | Collected READ  addr=0x1035 data=0x00 |
| 53745 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53775 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53805 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53835 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53865 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 53895 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 53925 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 53955 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53985 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54015 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54045 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54075 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54105 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54135 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54165 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54195 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54215 | hbus monitor | Collected WRITE addr=0x1036 data=0x79 |
| 54245 | hbus monitor | Collected READ  addr=0x1036 data=0x00 |
| 54275 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54305 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54335 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 54365 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 54395 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 54425 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54455 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 54485 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 54515 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54545 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54575 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54605 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54635 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54665 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54695 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54725 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54745 | hbus monitor | Collected WRITE addr=0x1037 data=0x9d |
| 54775 | hbus monitor | Collected READ  addr=0x1037 data=0x00 |
| 54805 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54835 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54865 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 54895 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 54925 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 54955 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54985 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55015 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55045 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55075 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55105 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55135 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55165 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55195 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55225 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55255 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55275 | hbus monitor | Collected WRITE addr=0x1038 data=0x97 |
| 55305 | hbus monitor | Collected READ  addr=0x1038 data=0x00 |
| 55335 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 55365 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 55395 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 55425 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55455 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 55485 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 55515 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55545 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55575 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55605 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55635 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55665 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55695 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55725 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55755 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55785 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55805 | hbus monitor | Collected WRITE addr=0x1039 data=0xc4 |
| 55835 | hbus monitor | Collected READ  addr=0x1039 data=0x00 |
| 55865 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 55895 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 55925 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 55955 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55985 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56015 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56045 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56075 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56105 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56135 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56165 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56195 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56225 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56255 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56285 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56315 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56335 | hbus monitor | Collected WRITE addr=0x103a data=0x31 |
| 56365 | hbus monitor | Collected READ  addr=0x103a data=0x00 |
| 56395 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 56425 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56455 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 56485 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 56515 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56545 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56575 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56605 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56635 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56665 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56695 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56725 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56755 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56785 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56815 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56845 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56865 | hbus monitor | Collected WRITE addr=0x103b data=0xbe |
| 56895 | hbus monitor | Collected READ  addr=0x103b data=0x00 |
| 56925 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 56955 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56985 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57015 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57045 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57075 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57105 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57135 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57165 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57195 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57225 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57255 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57285 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57315 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57345 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 57375 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 57395 | hbus monitor | Collected WRITE addr=0x103c data=0x57 |
| 57425 | hbus monitor | Collected READ  addr=0x103c data=0x00 |
| 57455 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 57485 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 57515 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57545 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57575 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57605 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57635 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57665 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57695 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57725 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57755 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57785 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57815 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57845 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57875 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 57905 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 57925 | hbus monitor | Collected WRITE addr=0x103d data=0x67 |
| 57955 | hbus monitor | Collected READ  addr=0x103d data=0x00 |
| 57985 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58015 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58045 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58075 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58105 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58135 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58165 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58195 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58225 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58255 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58285 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58315 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58345 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 58375 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 58405 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58435 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58455 | hbus monitor | Collected WRITE addr=0x103e data=0xfc |
| 58485 | hbus monitor | Collected READ  addr=0x103e data=0x00 |
| 58515 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58545 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58575 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58605 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58635 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58665 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58695 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58725 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58755 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58785 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58815 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58845 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58875 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 58905 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 58935 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58965 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58985 | hbus monitor | Collected WRITE addr=0x103f data=0x0d |
| 59015 | hbus monitor | Collected READ  addr=0x103f data=0x00 |
| 59045 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59075 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59105 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59135 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59165 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59195 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59225 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59255 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59285 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59315 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59345 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 59375 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 59405 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59435 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59465 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 59495 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 59515 | hbus monitor | Collected WRITE addr=0x1040 data=0xb1 |
| 59545 | hbus monitor | Collected READ  addr=0x1040 data=0x00 |
| 59575 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59605 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59635 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59665 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59695 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59725 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59755 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59785 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59815 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59845 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59875 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 59905 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 59935 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59965 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59995 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60025 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60045 | hbus monitor | Collected WRITE addr=0x1041 data=0xa2 |
| 60075 | hbus monitor | Collected READ  addr=0x1041 data=0x00 |
| 60105 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60135 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60165 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60195 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60225 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60255 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60285 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60315 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60345 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 60375 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 60405 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60435 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60465 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 60495 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 60525 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60555 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60575 | hbus monitor | Collected WRITE addr=0x1042 data=0x2c |
| 60605 | hbus monitor | Collected READ  addr=0x1042 data=0x00 |
| 60635 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60665 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60695 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60725 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60755 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60785 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60815 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60845 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60875 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 60905 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 60935 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60965 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60995 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61025 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61055 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61085 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61105 | hbus monitor | Collected WRITE addr=0x1043 data=0x3d |
| 61135 | hbus monitor | Collected READ  addr=0x1043 data=0x00 |
| 61165 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61195 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61225 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61255 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61285 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61315 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61345 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 61375 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 61405 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61435 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61465 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 61495 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 61525 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61555 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61585 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61615 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61635 | hbus monitor | Collected WRITE addr=0x1044 data=0xcb |
| 61665 | hbus monitor | Collected READ  addr=0x1044 data=0x00 |
| 61695 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61725 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61755 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61785 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61815 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61845 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61875 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 61905 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 61935 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61965 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61995 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62025 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62055 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62085 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62115 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62145 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62165 | hbus monitor | Collected WRITE addr=0x1045 data=0xd0 |
| 62195 | hbus monitor | Collected READ  addr=0x1045 data=0x00 |
| 62225 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62255 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62285 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62315 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62345 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 62375 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 62405 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62435 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62465 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 62495 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 62525 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62555 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62585 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62615 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62645 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62675 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62695 | hbus monitor | Collected WRITE addr=0x1046 data=0x3e |
| 62725 | hbus monitor | Collected READ  addr=0x1046 data=0x00 |
| 62755 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62785 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62815 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62845 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62875 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 62905 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 62935 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62965 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62995 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63025 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63055 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63085 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63115 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63145 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63175 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63205 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63225 | hbus monitor | Collected WRITE addr=0x1047 data=0x1d |
| 63255 | hbus monitor | Collected READ  addr=0x1047 data=0x00 |
| 63285 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63315 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63345 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 63375 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 63405 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63435 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63465 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 63495 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 63525 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63555 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63585 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63615 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63645 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63675 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63705 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63735 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63755 | hbus monitor | Collected WRITE addr=0x1048 data=0xdf |
| 63785 | hbus monitor | Collected READ  addr=0x1048 data=0x00 |
| 63815 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63845 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63875 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 63905 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 63935 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63965 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63995 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64025 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64055 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64085 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64115 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64145 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64175 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64205 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64235 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64265 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64285 | hbus monitor | Collected WRITE addr=0x1049 data=0x62 |
| 64315 | hbus monitor | Collected READ  addr=0x1049 data=0x00 |
| 64345 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 64375 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 64405 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64435 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64465 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 64495 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 64525 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64555 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64585 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64615 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64645 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64675 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64705 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64735 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64765 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64795 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64815 | hbus monitor | Collected WRITE addr=0x104a data=0xda |
| 64845 | hbus monitor | Collected READ  addr=0x104a data=0x00 |
| 64875 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 64905 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 64935 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64965 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64995 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65025 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65055 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65085 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65115 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65145 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65175 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65205 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65235 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65265 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65295 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65325 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65345 | hbus monitor | Collected WRITE addr=0x104b data=0x8d |
| 65375 | hbus monitor | Collected READ  addr=0x104b data=0x00 |
| 65405 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65435 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65465 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 65495 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 65525 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65555 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65585 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65615 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65645 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65675 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65705 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65735 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65765 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65795 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65825 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65855 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65875 | hbus monitor | Collected WRITE addr=0x104c data=0x30 |
| 65905 | hbus monitor | Collected READ  addr=0x104c data=0x00 |
| 65935 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65965 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65995 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66025 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66055 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66085 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66115 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66145 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66175 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66205 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66235 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66265 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66295 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66325 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66355 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 66385 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 66405 | hbus monitor | Collected WRITE addr=0x104d data=0x9b |
| 66435 | hbus monitor | Collected READ  addr=0x104d data=0x00 |
| 66465 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 66495 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 66525 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66555 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66585 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66615 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66645 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66675 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66705 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66735 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66765 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66795 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66825 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66855 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66885 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 66915 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 66935 | hbus monitor | Collected WRITE addr=0x104e data=0xfb |
| 66965 | hbus monitor | Collected READ  addr=0x104e data=0x00 |
| 66995 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67025 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67055 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67085 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67115 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67145 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67175 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67205 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67235 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67265 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67295 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67325 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67355 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 67385 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 67415 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67445 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67465 | hbus monitor | Collected WRITE addr=0x104f data=0xcc |
| 67495 | hbus monitor | Collected READ  addr=0x104f data=0x00 |
| 67525 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67555 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 67915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 67945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67970 | **test** | STAGE: 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 67975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67995 | hbus monitor | Collected WRITE addr=0x1050 data=0xff |
| 68025 | hbus monitor | Collected READ  addr=0x1050 data=0x00 |
| 68055 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68085 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68115 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68145 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68175 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68205 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68235 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68265 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68295 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68325 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68355 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 68385 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 68415 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68445 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 68475 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 68505 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 68525 | hbus monitor | Collected WRITE addr=0x10ff data=0xff |
| 68555 | hbus monitor | Collected READ  addr=0x10ff data=0x00 |
| 68585 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68615 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68645 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68675 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68705 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68735 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68765 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68795 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68825 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68855 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68885 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 68915 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 68945 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68975 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69005 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69035 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69055 | hbus monitor | Collected WRITE addr=0x10bb data=0x2a |
| 69085 | hbus monitor | Collected READ  addr=0x10bb data=0x00 |
| 69115 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69145 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69175 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69205 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69235 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69265 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69295 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69325 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69355 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 69385 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 69415 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69445 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 69475 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 69505 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69535 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69565 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69585 | hbus monitor | Collected WRITE addr=0x109e data=0x33 |
| 69615 | hbus monitor | Collected READ  addr=0x109e data=0x00 |
| 69645 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69675 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69705 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69735 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69765 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69795 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69825 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69855 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69885 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 69915 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 69945 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69975 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70005 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70035 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70065 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70095 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70115 | hbus monitor | Collected WRITE addr=0x10e2 data=0xb2 |
| 70145 | hbus monitor | Collected READ  addr=0x10e2 data=0x00 |
| 70175 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70205 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70235 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70265 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70295 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70325 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70355 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 70385 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 70415 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70445 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 70475 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 70505 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70535 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70565 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70595 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70625 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70645 | hbus monitor | Collected WRITE addr=0x10f5 data=0xce |
| 70675 | hbus monitor | Collected READ  addr=0x10f5 data=0x00 |
| 70705 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70735 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70765 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70795 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70825 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70855 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70885 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 70915 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 70945 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70975 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71005 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71035 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71065 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71095 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71125 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71155 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71175 | hbus monitor | Collected WRITE addr=0x10b5 data=0x5f |
| 71205 | hbus monitor | Collected READ  addr=0x10b5 data=0x00 |
| 71235 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71265 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71295 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71325 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71355 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 71385 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 71415 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71445 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 71475 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 71505 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71535 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71565 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71595 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71625 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71655 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71685 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71705 | hbus monitor | Collected WRITE addr=0x10a8 data=0xe9 |
| 71735 | hbus monitor | Collected READ  addr=0x10a8 data=0x00 |
| 71765 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71795 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71825 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71855 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71885 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 71915 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 71945 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71975 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 72005 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 72035 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 72065 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 72095 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 72125 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 72155 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 72185 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 72210 | **test** | STAGE: 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 72215 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 72235 | hbus monitor | Collected WRITE addr=0x1100 data=0x00 |
| 72265 | hbus monitor | Collected READ  addr=0x1100 data=0x00 |
| 72285 | hbus monitor | Collected WRITE addr=0x1101 data=0x00 |
| 72315 | hbus monitor | Collected READ  addr=0x1101 data=0x00 |
| 72335 | hbus monitor | Collected WRITE addr=0x1102 data=0x00 |
| 72365 | hbus monitor | Collected READ  addr=0x1102 data=0x00 |
| 72385 | hbus monitor | Collected WRITE addr=0x1103 data=0x00 |
| 72415 | hbus monitor | Collected READ  addr=0x1103 data=0x00 |
| 72435 | hbus monitor | Collected WRITE addr=0x1104 data=0x00 |
| 72465 | hbus monitor | Collected READ  addr=0x1104 data=0x00 |
| 72485 | hbus monitor | Collected WRITE addr=0x1105 data=0x00 |
| 72515 | hbus monitor | Collected READ  addr=0x1105 data=0x00 |
| 72535 | hbus monitor | Collected WRITE addr=0x1106 data=0x00 |
| 72565 | hbus monitor | Collected READ  addr=0x1106 data=0x00 |
| 72585 | hbus monitor | Collected WRITE addr=0x1107 data=0x00 |
| 72615 | hbus monitor | Collected READ  addr=0x1107 data=0x00 |
| 72635 | hbus monitor | Collected WRITE addr=0x1108 data=0x00 |
| 72665 | hbus monitor | Collected READ  addr=0x1108 data=0x00 |
| 72685 | hbus monitor | Collected WRITE addr=0x1109 data=0x00 |
| 72715 | hbus monitor | Collected READ  addr=0x1109 data=0x00 |
| 72735 | hbus monitor | Collected WRITE addr=0x110a data=0x00 |
| 72765 | hbus monitor | Collected READ  addr=0x110a data=0x00 |
| 72785 | hbus monitor | Collected WRITE addr=0x110b data=0x00 |
| 72815 | hbus monitor | Collected READ  addr=0x110b data=0x00 |
| 72835 | hbus monitor | Collected WRITE addr=0x110c data=0x00 |
| 72865 | hbus monitor | Collected READ  addr=0x110c data=0x00 |
| 72885 | hbus monitor | Collected WRITE addr=0x110d data=0x00 |
| 72915 | hbus monitor | Collected READ  addr=0x110d data=0x00 |
| 72935 | hbus monitor | Collected WRITE addr=0x110e data=0x00 |
| 72965 | hbus monitor | Collected READ  addr=0x110e data=0x00 |
| 72985 | hbus monitor | Collected WRITE addr=0x110f data=0x00 |
| 73015 | hbus monitor | Collected READ  addr=0x110f data=0x00 |
| 73035 | hbus monitor | Collected WRITE addr=0x1110 data=0x00 |
| 73065 | hbus monitor | Collected READ  addr=0x1110 data=0x00 |
| 73085 | hbus monitor | Collected WRITE addr=0x1111 data=0x00 |
| 73115 | hbus monitor | Collected READ  addr=0x1111 data=0x00 |
| 73135 | hbus monitor | Collected WRITE addr=0x1112 data=0x00 |
| 73165 | hbus monitor | Collected READ  addr=0x1112 data=0x00 |
| 73185 | hbus monitor | Collected WRITE addr=0x1113 data=0x00 |
| 73215 | hbus monitor | Collected READ  addr=0x1113 data=0x00 |
| 73235 | hbus monitor | Collected WRITE addr=0x1114 data=0x00 |
| 73265 | hbus monitor | Collected READ  addr=0x1114 data=0x00 |
| 73285 | hbus monitor | Collected WRITE addr=0x1115 data=0x00 |
| 73315 | hbus monitor | Collected READ  addr=0x1115 data=0x00 |
| 73335 | hbus monitor | Collected WRITE addr=0x1116 data=0x00 |
| 73365 | hbus monitor | Collected READ  addr=0x1116 data=0x00 |
| 73385 | hbus monitor | Collected WRITE addr=0x1117 data=0x00 |
| 73415 | hbus monitor | Collected READ  addr=0x1117 data=0x00 |
| 73435 | hbus monitor | Collected WRITE addr=0x1118 data=0x00 |
| 73465 | hbus monitor | Collected READ  addr=0x1118 data=0x00 |
| 73485 | hbus monitor | Collected WRITE addr=0x1119 data=0x00 |
| 73515 | hbus monitor | Collected READ  addr=0x1119 data=0x00 |
| 73535 | hbus monitor | Collected WRITE addr=0x111a data=0x00 |
| 73565 | hbus monitor | Collected READ  addr=0x111a data=0x00 |
| 73585 | hbus monitor | Collected WRITE addr=0x111b data=0x00 |
| 73615 | hbus monitor | Collected READ  addr=0x111b data=0x00 |
| 73635 | hbus monitor | Collected WRITE addr=0x111c data=0x00 |
| 73665 | hbus monitor | Collected READ  addr=0x111c data=0x00 |
| 73685 | hbus monitor | Collected WRITE addr=0x111d data=0x00 |
| 73715 | hbus monitor | Collected READ  addr=0x111d data=0x00 |
| 73735 | hbus monitor | Collected WRITE addr=0x111e data=0x00 |
| 73765 | hbus monitor | Collected READ  addr=0x111e data=0x00 |
| 73785 | hbus monitor | Collected WRITE addr=0x111f data=0x00 |
| 73815 | hbus monitor | Collected READ  addr=0x111f data=0x00 |
| 73835 | hbus monitor | Collected WRITE addr=0x1120 data=0x00 |
| 73865 | hbus monitor | Collected READ  addr=0x1120 data=0x00 |
| 73885 | hbus monitor | Collected WRITE addr=0x1121 data=0x00 |
| 73915 | hbus monitor | Collected READ  addr=0x1121 data=0x00 |
| 73935 | hbus monitor | Collected WRITE addr=0x1122 data=0x00 |
| 73965 | hbus monitor | Collected READ  addr=0x1122 data=0x00 |
| 73985 | hbus monitor | Collected WRITE addr=0x1123 data=0x00 |
| 74015 | hbus monitor | Collected READ  addr=0x1123 data=0x00 |
| 74035 | hbus monitor | Collected WRITE addr=0x1124 data=0x00 |
| 74065 | hbus monitor | Collected READ  addr=0x1124 data=0x00 |
| 74085 | hbus monitor | Collected WRITE addr=0x1125 data=0x00 |
| 74115 | hbus monitor | Collected READ  addr=0x1125 data=0x00 |
| 74135 | hbus monitor | Collected WRITE addr=0x1126 data=0x00 |
| 74165 | hbus monitor | Collected READ  addr=0x1126 data=0x00 |
| 74185 | hbus monitor | Collected WRITE addr=0x1127 data=0x00 |
| 74215 | hbus monitor | Collected READ  addr=0x1127 data=0x00 |
| 74235 | hbus monitor | Collected WRITE addr=0x1128 data=0x00 |
| 74265 | hbus monitor | Collected READ  addr=0x1128 data=0x00 |
| 74285 | hbus monitor | Collected WRITE addr=0x1129 data=0x00 |
| 74315 | hbus monitor | Collected READ  addr=0x1129 data=0x00 |
| 74335 | hbus monitor | Collected WRITE addr=0x112a data=0x00 |
| 74365 | hbus monitor | Collected READ  addr=0x112a data=0x00 |
| 74385 | hbus monitor | Collected WRITE addr=0x112b data=0x00 |
| 74415 | hbus monitor | Collected READ  addr=0x112b data=0x00 |
| 74435 | hbus monitor | Collected WRITE addr=0x112c data=0x00 |
| 74465 | hbus monitor | Collected READ  addr=0x112c data=0x00 |
| 74485 | hbus monitor | Collected WRITE addr=0x112d data=0x00 |
| 74515 | hbus monitor | Collected READ  addr=0x112d data=0x00 |
| 74535 | hbus monitor | Collected WRITE addr=0x112e data=0x00 |
| 74565 | hbus monitor | Collected READ  addr=0x112e data=0x00 |
| 74585 | hbus monitor | Collected WRITE addr=0x112f data=0x00 |
| 74615 | hbus monitor | Collected READ  addr=0x112f data=0x00 |
| 74635 | hbus monitor | Collected WRITE addr=0x1130 data=0x00 |
| 74665 | hbus monitor | Collected READ  addr=0x1130 data=0x00 |
| 74685 | hbus monitor | Collected WRITE addr=0x1131 data=0x00 |
| 74715 | hbus monitor | Collected READ  addr=0x1131 data=0x00 |
| 74735 | hbus monitor | Collected WRITE addr=0x1132 data=0x00 |
| 74765 | hbus monitor | Collected READ  addr=0x1132 data=0x00 |
| 74785 | hbus monitor | Collected WRITE addr=0x1133 data=0x00 |
| 74815 | hbus monitor | Collected READ  addr=0x1133 data=0x00 |
| 74835 | hbus monitor | Collected WRITE addr=0x1134 data=0x00 |
| 74865 | hbus monitor | Collected READ  addr=0x1134 data=0x00 |
| 74885 | hbus monitor | Collected WRITE addr=0x1135 data=0x00 |
| 74915 | hbus monitor | Collected READ  addr=0x1135 data=0x00 |
| 74935 | hbus monitor | Collected WRITE addr=0x1136 data=0x00 |
| 74965 | hbus monitor | Collected READ  addr=0x1136 data=0x00 |
| 74985 | hbus monitor | Collected WRITE addr=0x1137 data=0x00 |
| 75015 | hbus monitor | Collected READ  addr=0x1137 data=0x00 |
| 75035 | hbus monitor | Collected WRITE addr=0x1138 data=0x00 |
| 75065 | hbus monitor | Collected READ  addr=0x1138 data=0x00 |
| 75085 | hbus monitor | Collected WRITE addr=0x1139 data=0x00 |
| 75115 | hbus monitor | Collected READ  addr=0x1139 data=0x00 |
| 75135 | hbus monitor | Collected WRITE addr=0x113a data=0x00 |
| 75165 | hbus monitor | Collected READ  addr=0x113a data=0x00 |
| 75185 | hbus monitor | Collected WRITE addr=0x113b data=0x00 |
| 75215 | hbus monitor | Collected READ  addr=0x113b data=0x00 |
| 75235 | hbus monitor | Collected WRITE addr=0x113c data=0x00 |
| 75265 | hbus monitor | Collected READ  addr=0x113c data=0x00 |
| 75285 | hbus monitor | Collected WRITE addr=0x113d data=0x00 |
| 75315 | hbus monitor | Collected READ  addr=0x113d data=0x00 |
| 75335 | hbus monitor | Collected WRITE addr=0x113e data=0x00 |
| 75365 | hbus monitor | Collected READ  addr=0x113e data=0x00 |
| 75385 | hbus monitor | Collected WRITE addr=0x113f data=0x00 |
| 75415 | hbus monitor | Collected READ  addr=0x113f data=0x00 |
| 75435 | hbus monitor | Collected WRITE addr=0x1140 data=0x00 |
| 75465 | hbus monitor | Collected READ  addr=0x1140 data=0x00 |
| 75485 | hbus monitor | Collected WRITE addr=0x1141 data=0x00 |
| 75515 | hbus monitor | Collected READ  addr=0x1141 data=0x00 |
| 75535 | hbus monitor | Collected WRITE addr=0x1142 data=0x00 |
| 75565 | hbus monitor | Collected READ  addr=0x1142 data=0x00 |
| 75585 | hbus monitor | Collected WRITE addr=0x1143 data=0x00 |
| 75615 | hbus monitor | Collected READ  addr=0x1143 data=0x00 |
| 75635 | hbus monitor | Collected WRITE addr=0x1144 data=0x00 |
| 75665 | hbus monitor | Collected READ  addr=0x1144 data=0x00 |
| 75685 | hbus monitor | Collected WRITE addr=0x1145 data=0x00 |
| 75715 | hbus monitor | Collected READ  addr=0x1145 data=0x00 |
| 75735 | hbus monitor | Collected WRITE addr=0x1146 data=0x00 |
| 75765 | hbus monitor | Collected READ  addr=0x1146 data=0x00 |
| 75785 | hbus monitor | Collected WRITE addr=0x1147 data=0x00 |
| 75815 | hbus monitor | Collected READ  addr=0x1147 data=0x00 |
| 75835 | hbus monitor | Collected WRITE addr=0x1148 data=0x00 |
| 75865 | hbus monitor | Collected READ  addr=0x1148 data=0x00 |
| 75885 | hbus monitor | Collected WRITE addr=0x1149 data=0x00 |
| 75915 | hbus monitor | Collected READ  addr=0x1149 data=0x00 |
| 75935 | hbus monitor | Collected WRITE addr=0x114a data=0x00 |
| 75965 | hbus monitor | Collected READ  addr=0x114a data=0x00 |
| 75985 | hbus monitor | Collected WRITE addr=0x114b data=0x00 |
| 76015 | hbus monitor | Collected READ  addr=0x114b data=0x00 |
| 76035 | hbus monitor | Collected WRITE addr=0x114c data=0x00 |
| 76065 | hbus monitor | Collected READ  addr=0x114c data=0x00 |
| 76085 | hbus monitor | Collected WRITE addr=0x114d data=0x00 |
| 76115 | hbus monitor | Collected READ  addr=0x114d data=0x00 |
| 76135 | hbus monitor | Collected WRITE addr=0x114e data=0x00 |
| 76165 | hbus monitor | Collected READ  addr=0x114e data=0x00 |
| 76185 | hbus monitor | Collected WRITE addr=0x114f data=0x00 |
| 76215 | hbus monitor | Collected READ  addr=0x114f data=0x00 |
| 76235 | hbus monitor | Collected WRITE addr=0x1150 data=0x00 |
| 76265 | hbus monitor | Collected READ  addr=0x1150 data=0x00 |
| 76285 | hbus monitor | Collected WRITE addr=0x1151 data=0x00 |
| 76315 | hbus monitor | Collected READ  addr=0x1151 data=0x00 |
| 76335 | hbus monitor | Collected WRITE addr=0x1152 data=0x00 |
| 76365 | hbus monitor | Collected READ  addr=0x1152 data=0x00 |
| 76385 | hbus monitor | Collected WRITE addr=0x1153 data=0x00 |
| 76415 | hbus monitor | Collected READ  addr=0x1153 data=0x00 |
| 76435 | hbus monitor | Collected WRITE addr=0x1154 data=0x00 |
| 76465 | hbus monitor | Collected READ  addr=0x1154 data=0x00 |
| 76485 | hbus monitor | Collected WRITE addr=0x1155 data=0x00 |
| 76515 | hbus monitor | Collected READ  addr=0x1155 data=0x00 |
| 76535 | hbus monitor | Collected WRITE addr=0x1156 data=0x00 |
| 76565 | hbus monitor | Collected READ  addr=0x1156 data=0x00 |
| 76585 | hbus monitor | Collected WRITE addr=0x1157 data=0x00 |
| 76615 | hbus monitor | Collected READ  addr=0x1157 data=0x00 |
| 76635 | hbus monitor | Collected WRITE addr=0x1158 data=0x00 |
| 76665 | hbus monitor | Collected READ  addr=0x1158 data=0x00 |
| 76685 | hbus monitor | Collected WRITE addr=0x1159 data=0x00 |
| 76715 | hbus monitor | Collected READ  addr=0x1159 data=0x00 |
| 76735 | hbus monitor | Collected WRITE addr=0x115a data=0x00 |
| 76765 | hbus monitor | Collected READ  addr=0x115a data=0x00 |
| 76785 | hbus monitor | Collected WRITE addr=0x115b data=0x00 |
| 76815 | hbus monitor | Collected READ  addr=0x115b data=0x00 |
| 76835 | hbus monitor | Collected WRITE addr=0x115c data=0x00 |
| 76865 | hbus monitor | Collected READ  addr=0x115c data=0x00 |
| 76885 | hbus monitor | Collected WRITE addr=0x115d data=0x00 |
| 76915 | hbus monitor | Collected READ  addr=0x115d data=0x00 |
| 76935 | hbus monitor | Collected WRITE addr=0x115e data=0x00 |
| 76965 | hbus monitor | Collected READ  addr=0x115e data=0x00 |
| 76985 | hbus monitor | Collected WRITE addr=0x115f data=0x00 |
| 77015 | hbus monitor | Collected READ  addr=0x115f data=0x00 |
| 77035 | hbus monitor | Collected WRITE addr=0x1160 data=0x00 |
| 77065 | hbus monitor | Collected READ  addr=0x1160 data=0x00 |
| 77085 | hbus monitor | Collected WRITE addr=0x1161 data=0x00 |
| 77115 | hbus monitor | Collected READ  addr=0x1161 data=0x00 |
| 77135 | hbus monitor | Collected WRITE addr=0x1162 data=0x00 |
| 77165 | hbus monitor | Collected READ  addr=0x1162 data=0x00 |
| 77185 | hbus monitor | Collected WRITE addr=0x1163 data=0x00 |
| 77215 | hbus monitor | Collected READ  addr=0x1163 data=0x00 |
| 77235 | hbus monitor | Collected WRITE addr=0x1164 data=0x00 |
| 77265 | hbus monitor | Collected READ  addr=0x1164 data=0x00 |
| 77285 | hbus monitor | Collected WRITE addr=0x1165 data=0x00 |
| 77315 | hbus monitor | Collected READ  addr=0x1165 data=0x00 |
| 77335 | hbus monitor | Collected WRITE addr=0x1166 data=0x00 |
| 77365 | hbus monitor | Collected READ  addr=0x1166 data=0x00 |
| 77385 | hbus monitor | Collected WRITE addr=0x1167 data=0x00 |
| 77415 | hbus monitor | Collected READ  addr=0x1167 data=0x00 |
| 77435 | hbus monitor | Collected WRITE addr=0x1168 data=0x00 |
| 77465 | hbus monitor | Collected READ  addr=0x1168 data=0x00 |
| 77485 | hbus monitor | Collected WRITE addr=0x1169 data=0x00 |
| 77515 | hbus monitor | Collected READ  addr=0x1169 data=0x00 |
| 77535 | hbus monitor | Collected WRITE addr=0x116a data=0x00 |
| 77565 | hbus monitor | Collected READ  addr=0x116a data=0x00 |
| 77585 | hbus monitor | Collected WRITE addr=0x116b data=0x00 |
| 77615 | hbus monitor | Collected READ  addr=0x116b data=0x00 |
| 77635 | hbus monitor | Collected WRITE addr=0x116c data=0x00 |
| 77665 | hbus monitor | Collected READ  addr=0x116c data=0x00 |
| 77685 | hbus monitor | Collected WRITE addr=0x116d data=0x00 |
| 77715 | hbus monitor | Collected READ  addr=0x116d data=0x00 |
| 77735 | hbus monitor | Collected WRITE addr=0x116e data=0x00 |
| 77765 | hbus monitor | Collected READ  addr=0x116e data=0x00 |
| 77785 | hbus monitor | Collected WRITE addr=0x116f data=0x00 |
| 77815 | hbus monitor | Collected READ  addr=0x116f data=0x00 |
| 77835 | hbus monitor | Collected WRITE addr=0x1170 data=0x00 |
| 77865 | hbus monitor | Collected READ  addr=0x1170 data=0x00 |
| 77885 | hbus monitor | Collected WRITE addr=0x1171 data=0x00 |
| 77915 | hbus monitor | Collected READ  addr=0x1171 data=0x00 |
| 77935 | hbus monitor | Collected WRITE addr=0x1172 data=0x00 |
| 77965 | hbus monitor | Collected READ  addr=0x1172 data=0x00 |
| 77985 | hbus monitor | Collected WRITE addr=0x1173 data=0x00 |
| 78015 | hbus monitor | Collected READ  addr=0x1173 data=0x00 |
| 78035 | hbus monitor | Collected WRITE addr=0x1174 data=0x00 |
| 78065 | hbus monitor | Collected READ  addr=0x1174 data=0x00 |
| 78085 | hbus monitor | Collected WRITE addr=0x1175 data=0x00 |
| 78115 | hbus monitor | Collected READ  addr=0x1175 data=0x00 |
| 78135 | hbus monitor | Collected WRITE addr=0x1176 data=0x00 |
| 78165 | hbus monitor | Collected READ  addr=0x1176 data=0x00 |
| 78185 | hbus monitor | Collected WRITE addr=0x1177 data=0x00 |
| 78215 | hbus monitor | Collected READ  addr=0x1177 data=0x00 |
| 78235 | hbus monitor | Collected WRITE addr=0x1178 data=0x00 |
| 78265 | hbus monitor | Collected READ  addr=0x1178 data=0x00 |
| 78285 | hbus monitor | Collected WRITE addr=0x1179 data=0x00 |
| 78315 | hbus monitor | Collected READ  addr=0x1179 data=0x00 |
| 78335 | hbus monitor | Collected WRITE addr=0x117a data=0x00 |
| 78365 | hbus monitor | Collected READ  addr=0x117a data=0x00 |
| 78385 | hbus monitor | Collected WRITE addr=0x117b data=0x00 |
| 78415 | hbus monitor | Collected READ  addr=0x117b data=0x00 |
| 78435 | hbus monitor | Collected WRITE addr=0x117c data=0x00 |
| 78465 | hbus monitor | Collected READ  addr=0x117c data=0x00 |
| 78485 | hbus monitor | Collected WRITE addr=0x117d data=0x00 |
| 78515 | hbus monitor | Collected READ  addr=0x117d data=0x00 |
| 78535 | hbus monitor | Collected WRITE addr=0x117e data=0x00 |
| 78565 | hbus monitor | Collected READ  addr=0x117e data=0x00 |
| 78585 | hbus monitor | Collected WRITE addr=0x117f data=0x00 |
| 78615 | hbus monitor | Collected READ  addr=0x117f data=0x00 |
| 78635 | hbus monitor | Collected WRITE addr=0x1180 data=0x00 |
| 78665 | hbus monitor | Collected READ  addr=0x1180 data=0x00 |
| 78685 | hbus monitor | Collected WRITE addr=0x1181 data=0x00 |
| 78715 | hbus monitor | Collected READ  addr=0x1181 data=0x00 |
| 78735 | hbus monitor | Collected WRITE addr=0x1182 data=0x00 |
| 78765 | hbus monitor | Collected READ  addr=0x1182 data=0x00 |
| 78785 | hbus monitor | Collected WRITE addr=0x1183 data=0x00 |
| 78815 | hbus monitor | Collected READ  addr=0x1183 data=0x00 |
| 78835 | hbus monitor | Collected WRITE addr=0x1184 data=0x00 |
| 78865 | hbus monitor | Collected READ  addr=0x1184 data=0x00 |
| 78885 | hbus monitor | Collected WRITE addr=0x1185 data=0x00 |
| 78915 | hbus monitor | Collected READ  addr=0x1185 data=0x00 |
| 78935 | hbus monitor | Collected WRITE addr=0x1186 data=0x00 |
| 78965 | hbus monitor | Collected READ  addr=0x1186 data=0x00 |
| 78985 | hbus monitor | Collected WRITE addr=0x1187 data=0x00 |
| 79015 | hbus monitor | Collected READ  addr=0x1187 data=0x00 |
| 79035 | hbus monitor | Collected WRITE addr=0x1188 data=0x00 |
| 79065 | hbus monitor | Collected READ  addr=0x1188 data=0x00 |
| 79085 | hbus monitor | Collected WRITE addr=0x1189 data=0x00 |
| 79115 | hbus monitor | Collected READ  addr=0x1189 data=0x00 |
| 79135 | hbus monitor | Collected WRITE addr=0x118a data=0x00 |
| 79165 | hbus monitor | Collected READ  addr=0x118a data=0x00 |
| 79185 | hbus monitor | Collected WRITE addr=0x118b data=0x00 |
| 79215 | hbus monitor | Collected READ  addr=0x118b data=0x00 |
| 79235 | hbus monitor | Collected WRITE addr=0x118c data=0x00 |
| 79265 | hbus monitor | Collected READ  addr=0x118c data=0x00 |
| 79285 | hbus monitor | Collected WRITE addr=0x118d data=0x00 |
| 79315 | hbus monitor | Collected READ  addr=0x118d data=0x00 |
| 79335 | hbus monitor | Collected WRITE addr=0x118e data=0x00 |
| 79365 | hbus monitor | Collected READ  addr=0x118e data=0x00 |
| 79385 | hbus monitor | Collected WRITE addr=0x118f data=0x00 |
| 79415 | hbus monitor | Collected READ  addr=0x118f data=0x00 |
| 79435 | hbus monitor | Collected WRITE addr=0x1190 data=0x00 |
| 79465 | hbus monitor | Collected READ  addr=0x1190 data=0x00 |
| 79485 | hbus monitor | Collected WRITE addr=0x1191 data=0x00 |
| 79515 | hbus monitor | Collected READ  addr=0x1191 data=0x00 |
| 79535 | hbus monitor | Collected WRITE addr=0x1192 data=0x00 |
| 79565 | hbus monitor | Collected READ  addr=0x1192 data=0x00 |
| 79585 | hbus monitor | Collected WRITE addr=0x1193 data=0x00 |
| 79615 | hbus monitor | Collected READ  addr=0x1193 data=0x00 |
| 79635 | hbus monitor | Collected WRITE addr=0x1194 data=0x00 |
| 79665 | hbus monitor | Collected READ  addr=0x1194 data=0x00 |
| 79685 | hbus monitor | Collected WRITE addr=0x1195 data=0x00 |
| 79715 | hbus monitor | Collected READ  addr=0x1195 data=0x00 |
| 79735 | hbus monitor | Collected WRITE addr=0x1196 data=0x00 |
| 79765 | hbus monitor | Collected READ  addr=0x1196 data=0x00 |
| 79785 | hbus monitor | Collected WRITE addr=0x1197 data=0x00 |
| 79815 | hbus monitor | Collected READ  addr=0x1197 data=0x00 |
| 79835 | hbus monitor | Collected WRITE addr=0x1198 data=0x00 |
| 79865 | hbus monitor | Collected READ  addr=0x1198 data=0x00 |
| 79885 | hbus monitor | Collected WRITE addr=0x1199 data=0x00 |
| 79915 | hbus monitor | Collected READ  addr=0x1199 data=0x00 |
| 79935 | hbus monitor | Collected WRITE addr=0x119a data=0x00 |
| 79965 | hbus monitor | Collected READ  addr=0x119a data=0x00 |
| 79985 | hbus monitor | Collected WRITE addr=0x119b data=0x00 |
| 80015 | hbus monitor | Collected READ  addr=0x119b data=0x00 |
| 80035 | hbus monitor | Collected WRITE addr=0x119c data=0x00 |
| 80065 | hbus monitor | Collected READ  addr=0x119c data=0x00 |
| 80085 | hbus monitor | Collected WRITE addr=0x119d data=0x00 |
| 80115 | hbus monitor | Collected READ  addr=0x119d data=0x00 |
| 80135 | hbus monitor | Collected WRITE addr=0x119e data=0x00 |
| 80165 | hbus monitor | Collected READ  addr=0x119e data=0x00 |
| 80185 | hbus monitor | Collected WRITE addr=0x119f data=0x00 |
| 80215 | hbus monitor | Collected READ  addr=0x119f data=0x00 |
| 80235 | hbus monitor | Collected WRITE addr=0x11a0 data=0x00 |
| 80265 | hbus monitor | Collected READ  addr=0x11a0 data=0x00 |
| 80285 | hbus monitor | Collected WRITE addr=0x11a1 data=0x00 |
| 80315 | hbus monitor | Collected READ  addr=0x11a1 data=0x00 |
| 80335 | hbus monitor | Collected WRITE addr=0x11a2 data=0x00 |
| 80365 | hbus monitor | Collected READ  addr=0x11a2 data=0x00 |
| 80385 | hbus monitor | Collected WRITE addr=0x11a3 data=0x00 |
| 80415 | hbus monitor | Collected READ  addr=0x11a3 data=0x00 |
| 80435 | hbus monitor | Collected WRITE addr=0x11a4 data=0x00 |
| 80465 | hbus monitor | Collected READ  addr=0x11a4 data=0x00 |
| 80485 | hbus monitor | Collected WRITE addr=0x11a5 data=0x00 |
| 80515 | hbus monitor | Collected READ  addr=0x11a5 data=0x00 |
| 80535 | hbus monitor | Collected WRITE addr=0x11a6 data=0x00 |
| 80565 | hbus monitor | Collected READ  addr=0x11a6 data=0x00 |
| 80585 | hbus monitor | Collected WRITE addr=0x11a7 data=0x00 |
| 80615 | hbus monitor | Collected READ  addr=0x11a7 data=0x00 |
| 80635 | hbus monitor | Collected WRITE addr=0x11a8 data=0x00 |
| 80665 | hbus monitor | Collected READ  addr=0x11a8 data=0x00 |
| 80685 | hbus monitor | Collected WRITE addr=0x11a9 data=0x00 |
| 80715 | hbus monitor | Collected READ  addr=0x11a9 data=0x00 |
| 80735 | hbus monitor | Collected WRITE addr=0x11aa data=0x00 |
| 80765 | hbus monitor | Collected READ  addr=0x11aa data=0x00 |
| 80785 | hbus monitor | Collected WRITE addr=0x11ab data=0x00 |
| 80815 | hbus monitor | Collected READ  addr=0x11ab data=0x00 |
| 80835 | hbus monitor | Collected WRITE addr=0x11ac data=0x00 |
| 80865 | hbus monitor | Collected READ  addr=0x11ac data=0x00 |
| 80885 | hbus monitor | Collected WRITE addr=0x11ad data=0x00 |
| 80915 | hbus monitor | Collected READ  addr=0x11ad data=0x00 |
| 80935 | hbus monitor | Collected WRITE addr=0x11ae data=0x00 |
| 80965 | hbus monitor | Collected READ  addr=0x11ae data=0x00 |
| 80985 | hbus monitor | Collected WRITE addr=0x11af data=0x00 |
| 81015 | hbus monitor | Collected READ  addr=0x11af data=0x00 |
| 81035 | hbus monitor | Collected WRITE addr=0x11b0 data=0x00 |
| 81065 | hbus monitor | Collected READ  addr=0x11b0 data=0x00 |
| 81085 | hbus monitor | Collected WRITE addr=0x11b1 data=0x00 |
| 81115 | hbus monitor | Collected READ  addr=0x11b1 data=0x00 |
| 81135 | hbus monitor | Collected WRITE addr=0x11b2 data=0x00 |
| 81165 | hbus monitor | Collected READ  addr=0x11b2 data=0x00 |
| 81185 | hbus monitor | Collected WRITE addr=0x11b3 data=0x00 |
| 81215 | hbus monitor | Collected READ  addr=0x11b3 data=0x00 |
| 81235 | hbus monitor | Collected WRITE addr=0x11b4 data=0x00 |
| 81265 | hbus monitor | Collected READ  addr=0x11b4 data=0x00 |
| 81285 | hbus monitor | Collected WRITE addr=0x11b5 data=0x00 |
| 81315 | hbus monitor | Collected READ  addr=0x11b5 data=0x00 |
| 81335 | hbus monitor | Collected WRITE addr=0x11b6 data=0x00 |
| 81365 | hbus monitor | Collected READ  addr=0x11b6 data=0x00 |
| 81385 | hbus monitor | Collected WRITE addr=0x11b7 data=0x00 |
| 81415 | hbus monitor | Collected READ  addr=0x11b7 data=0x00 |
| 81435 | hbus monitor | Collected WRITE addr=0x11b8 data=0x00 |
| 81465 | hbus monitor | Collected READ  addr=0x11b8 data=0x00 |
| 81485 | hbus monitor | Collected WRITE addr=0x11b9 data=0x00 |
| 81515 | hbus monitor | Collected READ  addr=0x11b9 data=0x00 |
| 81535 | hbus monitor | Collected WRITE addr=0x11ba data=0x00 |
| 81565 | hbus monitor | Collected READ  addr=0x11ba data=0x00 |
| 81585 | hbus monitor | Collected WRITE addr=0x11bb data=0x00 |
| 81615 | hbus monitor | Collected READ  addr=0x11bb data=0x00 |
| 81635 | hbus monitor | Collected WRITE addr=0x11bc data=0x00 |
| 81665 | hbus monitor | Collected READ  addr=0x11bc data=0x00 |
| 81685 | hbus monitor | Collected WRITE addr=0x11bd data=0x00 |
| 81715 | hbus monitor | Collected READ  addr=0x11bd data=0x00 |
| 81735 | hbus monitor | Collected WRITE addr=0x11be data=0x00 |
| 81765 | hbus monitor | Collected READ  addr=0x11be data=0x00 |
| 81785 | hbus monitor | Collected WRITE addr=0x11bf data=0x00 |
| 81815 | hbus monitor | Collected READ  addr=0x11bf data=0x00 |
| 81835 | hbus monitor | Collected WRITE addr=0x11c0 data=0x00 |
| 81865 | hbus monitor | Collected READ  addr=0x11c0 data=0x00 |
| 81885 | hbus monitor | Collected WRITE addr=0x11c1 data=0x00 |
| 81915 | hbus monitor | Collected READ  addr=0x11c1 data=0x00 |
| 81935 | hbus monitor | Collected WRITE addr=0x11c2 data=0x00 |
| 81965 | hbus monitor | Collected READ  addr=0x11c2 data=0x00 |
| 81985 | hbus monitor | Collected WRITE addr=0x11c3 data=0x00 |
| 82015 | hbus monitor | Collected READ  addr=0x11c3 data=0x00 |
| 82035 | hbus monitor | Collected WRITE addr=0x11c4 data=0x00 |
| 82065 | hbus monitor | Collected READ  addr=0x11c4 data=0x00 |
| 82085 | hbus monitor | Collected WRITE addr=0x11c5 data=0x00 |
| 82115 | hbus monitor | Collected READ  addr=0x11c5 data=0x00 |
| 82135 | hbus monitor | Collected WRITE addr=0x11c6 data=0x00 |
| 82165 | hbus monitor | Collected READ  addr=0x11c6 data=0x00 |
| 82185 | hbus monitor | Collected WRITE addr=0x11c7 data=0x00 |
| 82215 | hbus monitor | Collected READ  addr=0x11c7 data=0x00 |
| 82235 | hbus monitor | Collected WRITE addr=0x11c8 data=0x00 |
| 82265 | hbus monitor | Collected READ  addr=0x11c8 data=0x00 |
| 82285 | hbus monitor | Collected WRITE addr=0x11c9 data=0x00 |
| 82315 | hbus monitor | Collected READ  addr=0x11c9 data=0x00 |
| 82335 | hbus monitor | Collected WRITE addr=0x11ca data=0x00 |
| 82365 | hbus monitor | Collected READ  addr=0x11ca data=0x00 |
| 82385 | hbus monitor | Collected WRITE addr=0x11cb data=0x00 |
| 82415 | hbus monitor | Collected READ  addr=0x11cb data=0x00 |
| 82435 | hbus monitor | Collected WRITE addr=0x11cc data=0x00 |
| 82465 | hbus monitor | Collected READ  addr=0x11cc data=0x00 |
| 82485 | hbus monitor | Collected WRITE addr=0x11cd data=0x00 |
| 82515 | hbus monitor | Collected READ  addr=0x11cd data=0x00 |
| 82535 | hbus monitor | Collected WRITE addr=0x11ce data=0x00 |
| 82565 | hbus monitor | Collected READ  addr=0x11ce data=0x00 |
| 82585 | hbus monitor | Collected WRITE addr=0x11cf data=0x00 |
| 82615 | hbus monitor | Collected READ  addr=0x11cf data=0x00 |
| 82635 | hbus monitor | Collected WRITE addr=0x11d0 data=0x00 |
| 82665 | hbus monitor | Collected READ  addr=0x11d0 data=0x00 |
| 82685 | hbus monitor | Collected WRITE addr=0x11d1 data=0x00 |
| 82715 | hbus monitor | Collected READ  addr=0x11d1 data=0x00 |
| 82735 | hbus monitor | Collected WRITE addr=0x11d2 data=0x00 |
| 82765 | hbus monitor | Collected READ  addr=0x11d2 data=0x00 |
| 82785 | hbus monitor | Collected WRITE addr=0x11d3 data=0x00 |
| 82815 | hbus monitor | Collected READ  addr=0x11d3 data=0x00 |
| 82835 | hbus monitor | Collected WRITE addr=0x11d4 data=0x00 |
| 82865 | hbus monitor | Collected READ  addr=0x11d4 data=0x00 |
| 82885 | hbus monitor | Collected WRITE addr=0x11d5 data=0x00 |
| 82915 | hbus monitor | Collected READ  addr=0x11d5 data=0x00 |
| 82935 | hbus monitor | Collected WRITE addr=0x11d6 data=0x00 |
| 82965 | hbus monitor | Collected READ  addr=0x11d6 data=0x00 |
| 82985 | hbus monitor | Collected WRITE addr=0x11d7 data=0x00 |
| 83015 | hbus monitor | Collected READ  addr=0x11d7 data=0x00 |
| 83035 | hbus monitor | Collected WRITE addr=0x11d8 data=0x00 |
| 83065 | hbus monitor | Collected READ  addr=0x11d8 data=0x00 |
| 83085 | hbus monitor | Collected WRITE addr=0x11d9 data=0x00 |
| 83115 | hbus monitor | Collected READ  addr=0x11d9 data=0x00 |
| 83135 | hbus monitor | Collected WRITE addr=0x11da data=0x00 |
| 83165 | hbus monitor | Collected READ  addr=0x11da data=0x00 |
| 83185 | hbus monitor | Collected WRITE addr=0x11db data=0x00 |
| 83215 | hbus monitor | Collected READ  addr=0x11db data=0x00 |
| 83235 | hbus monitor | Collected WRITE addr=0x11dc data=0x00 |
| 83265 | hbus monitor | Collected READ  addr=0x11dc data=0x00 |
| 83285 | hbus monitor | Collected WRITE addr=0x11dd data=0x00 |
| 83315 | hbus monitor | Collected READ  addr=0x11dd data=0x00 |
| 83335 | hbus monitor | Collected WRITE addr=0x11de data=0x00 |
| 83365 | hbus monitor | Collected READ  addr=0x11de data=0x00 |
| 83385 | hbus monitor | Collected WRITE addr=0x11df data=0x00 |
| 83415 | hbus monitor | Collected READ  addr=0x11df data=0x00 |
| 83435 | hbus monitor | Collected WRITE addr=0x11e0 data=0x00 |
| 83465 | hbus monitor | Collected READ  addr=0x11e0 data=0x00 |
| 83485 | hbus monitor | Collected WRITE addr=0x11e1 data=0x00 |
| 83515 | hbus monitor | Collected READ  addr=0x11e1 data=0x00 |
| 83535 | hbus monitor | Collected WRITE addr=0x11e2 data=0x00 |
| 83565 | hbus monitor | Collected READ  addr=0x11e2 data=0x00 |
| 83585 | hbus monitor | Collected WRITE addr=0x11e3 data=0x00 |
| 83615 | hbus monitor | Collected READ  addr=0x11e3 data=0x00 |
| 83635 | hbus monitor | Collected WRITE addr=0x11e4 data=0x00 |
| 83665 | hbus monitor | Collected READ  addr=0x11e4 data=0x00 |
| 83685 | hbus monitor | Collected WRITE addr=0x11e5 data=0x00 |
| 83715 | hbus monitor | Collected READ  addr=0x11e5 data=0x00 |
| 83735 | hbus monitor | Collected WRITE addr=0x11e6 data=0x00 |
| 83765 | hbus monitor | Collected READ  addr=0x11e6 data=0x00 |
| 83785 | hbus monitor | Collected WRITE addr=0x11e7 data=0x00 |
| 83815 | hbus monitor | Collected READ  addr=0x11e7 data=0x00 |
| 83835 | hbus monitor | Collected WRITE addr=0x11e8 data=0x00 |
| 83865 | hbus monitor | Collected READ  addr=0x11e8 data=0x00 |
| 83885 | hbus monitor | Collected WRITE addr=0x11e9 data=0x00 |
| 83915 | hbus monitor | Collected READ  addr=0x11e9 data=0x00 |
| 83935 | hbus monitor | Collected WRITE addr=0x11ea data=0x00 |
| 83965 | hbus monitor | Collected READ  addr=0x11ea data=0x00 |
| 83985 | hbus monitor | Collected WRITE addr=0x11eb data=0x00 |
| 84015 | hbus monitor | Collected READ  addr=0x11eb data=0x00 |
| 84035 | hbus monitor | Collected WRITE addr=0x11ec data=0x00 |
| 84065 | hbus monitor | Collected READ  addr=0x11ec data=0x00 |
| 84085 | hbus monitor | Collected WRITE addr=0x11ed data=0x00 |
| 84115 | hbus monitor | Collected READ  addr=0x11ed data=0x00 |
| 84135 | hbus monitor | Collected WRITE addr=0x11ee data=0x00 |
| 84165 | hbus monitor | Collected READ  addr=0x11ee data=0x00 |
| 84185 | hbus monitor | Collected WRITE addr=0x11ef data=0x00 |
| 84215 | hbus monitor | Collected READ  addr=0x11ef data=0x00 |
| 84235 | hbus monitor | Collected WRITE addr=0x11f0 data=0x00 |
| 84265 | hbus monitor | Collected READ  addr=0x11f0 data=0x00 |
| 84285 | hbus monitor | Collected WRITE addr=0x11f1 data=0x00 |
| 84315 | hbus monitor | Collected READ  addr=0x11f1 data=0x00 |
| 84335 | hbus monitor | Collected WRITE addr=0x11f2 data=0x00 |
| 84365 | hbus monitor | Collected READ  addr=0x11f2 data=0x00 |
| 84385 | hbus monitor | Collected WRITE addr=0x11f3 data=0x00 |
| 84415 | hbus monitor | Collected READ  addr=0x11f3 data=0x00 |
| 84435 | hbus monitor | Collected WRITE addr=0x11f4 data=0x00 |
| 84465 | hbus monitor | Collected READ  addr=0x11f4 data=0x00 |
| 84485 | hbus monitor | Collected WRITE addr=0x11f5 data=0x00 |
| 84515 | hbus monitor | Collected READ  addr=0x11f5 data=0x00 |
| 84535 | hbus monitor | Collected WRITE addr=0x11f6 data=0x00 |
| 84565 | hbus monitor | Collected READ  addr=0x11f6 data=0x00 |
| 84585 | hbus monitor | Collected WRITE addr=0x11f7 data=0x00 |
| 84615 | hbus monitor | Collected READ  addr=0x11f7 data=0x00 |
| 84635 | hbus monitor | Collected WRITE addr=0x11f8 data=0x00 |
| 84665 | hbus monitor | Collected READ  addr=0x11f8 data=0x00 |
| 84685 | hbus monitor | Collected WRITE addr=0x11f9 data=0x00 |
| 84715 | hbus monitor | Collected READ  addr=0x11f9 data=0x00 |
| 84735 | hbus monitor | Collected WRITE addr=0x11fa data=0x00 |
| 84765 | hbus monitor | Collected READ  addr=0x11fa data=0x00 |
| 84785 | hbus monitor | Collected WRITE addr=0x11fb data=0x00 |
| 84815 | hbus monitor | Collected READ  addr=0x11fb data=0x00 |
| 84835 | hbus monitor | Collected WRITE addr=0x11fc data=0x00 |
| 84865 | hbus monitor | Collected READ  addr=0x11fc data=0x00 |
| 84885 | hbus monitor | Collected WRITE addr=0x11fd data=0x00 |
| 84915 | hbus monitor | Collected READ  addr=0x11fd data=0x00 |
| 84935 | hbus monitor | Collected WRITE addr=0x11fe data=0x00 |
| 84965 | hbus monitor | Collected READ  addr=0x11fe data=0x00 |
| 84985 | hbus monitor | Collected WRITE addr=0x11ff data=0x00 |
| 85015 | hbus monitor | Collected READ  addr=0x11ff data=0x00 |
| 85035 | hbus monitor | Collected WRITE addr=0x1100 data=0xff |
| 85065 | hbus monitor | Collected READ  addr=0x1100 data=0xff |
| 85085 | hbus monitor | Collected WRITE addr=0x1101 data=0xff |
| 85115 | hbus monitor | Collected READ  addr=0x1101 data=0xff |
| 85135 | hbus monitor | Collected WRITE addr=0x1102 data=0xff |
| 85165 | hbus monitor | Collected READ  addr=0x1102 data=0xff |
| 85185 | hbus monitor | Collected WRITE addr=0x1103 data=0xff |
| 85215 | hbus monitor | Collected READ  addr=0x1103 data=0xff |
| 85235 | hbus monitor | Collected WRITE addr=0x1104 data=0xff |
| 85265 | hbus monitor | Collected READ  addr=0x1104 data=0xff |
| 85285 | hbus monitor | Collected WRITE addr=0x1105 data=0xff |
| 85315 | hbus monitor | Collected READ  addr=0x1105 data=0xff |
| 85335 | hbus monitor | Collected WRITE addr=0x1106 data=0xff |
| 85365 | hbus monitor | Collected READ  addr=0x1106 data=0xff |
| 85385 | hbus monitor | Collected WRITE addr=0x1107 data=0xff |
| 85415 | hbus monitor | Collected READ  addr=0x1107 data=0xff |
| 85435 | hbus monitor | Collected WRITE addr=0x1108 data=0xff |
| 85465 | hbus monitor | Collected READ  addr=0x1108 data=0xff |
| 85485 | hbus monitor | Collected WRITE addr=0x1109 data=0xff |
| 85515 | hbus monitor | Collected READ  addr=0x1109 data=0xff |
| 85535 | hbus monitor | Collected WRITE addr=0x110a data=0xff |
| 85565 | hbus monitor | Collected READ  addr=0x110a data=0xff |
| 85585 | hbus monitor | Collected WRITE addr=0x110b data=0xff |
| 85615 | hbus monitor | Collected READ  addr=0x110b data=0xff |
| 85635 | hbus monitor | Collected WRITE addr=0x110c data=0xff |
| 85665 | hbus monitor | Collected READ  addr=0x110c data=0xff |
| 85685 | hbus monitor | Collected WRITE addr=0x110d data=0xff |
| 85715 | hbus monitor | Collected READ  addr=0x110d data=0xff |
| 85735 | hbus monitor | Collected WRITE addr=0x110e data=0xff |
| 85765 | hbus monitor | Collected READ  addr=0x110e data=0xff |
| 85785 | hbus monitor | Collected WRITE addr=0x110f data=0xff |
| 85815 | hbus monitor | Collected READ  addr=0x110f data=0xff |
| 85835 | hbus monitor | Collected WRITE addr=0x1110 data=0xff |
| 85865 | hbus monitor | Collected READ  addr=0x1110 data=0xff |
| 85885 | hbus monitor | Collected WRITE addr=0x1111 data=0xff |
| 85915 | hbus monitor | Collected READ  addr=0x1111 data=0xff |
| 85935 | hbus monitor | Collected WRITE addr=0x1112 data=0xff |
| 85965 | hbus monitor | Collected READ  addr=0x1112 data=0xff |
| 85985 | hbus monitor | Collected WRITE addr=0x1113 data=0xff |
| 86015 | hbus monitor | Collected READ  addr=0x1113 data=0xff |
| 86035 | hbus monitor | Collected WRITE addr=0x1114 data=0xff |
| 86065 | hbus monitor | Collected READ  addr=0x1114 data=0xff |
| 86085 | hbus monitor | Collected WRITE addr=0x1115 data=0xff |
| 86115 | hbus monitor | Collected READ  addr=0x1115 data=0xff |
| 86135 | hbus monitor | Collected WRITE addr=0x1116 data=0xff |
| 86165 | hbus monitor | Collected READ  addr=0x1116 data=0xff |
| 86185 | hbus monitor | Collected WRITE addr=0x1117 data=0xff |
| 86215 | hbus monitor | Collected READ  addr=0x1117 data=0xff |
| 86235 | hbus monitor | Collected WRITE addr=0x1118 data=0xff |
| 86265 | hbus monitor | Collected READ  addr=0x1118 data=0xff |
| 86285 | hbus monitor | Collected WRITE addr=0x1119 data=0xff |
| 86315 | hbus monitor | Collected READ  addr=0x1119 data=0xff |
| 86335 | hbus monitor | Collected WRITE addr=0x111a data=0xff |
| 86365 | hbus monitor | Collected READ  addr=0x111a data=0xff |
| 86385 | hbus monitor | Collected WRITE addr=0x111b data=0xff |
| 86415 | hbus monitor | Collected READ  addr=0x111b data=0xff |
| 86435 | hbus monitor | Collected WRITE addr=0x111c data=0xff |
| 86465 | hbus monitor | Collected READ  addr=0x111c data=0xff |
| 86485 | hbus monitor | Collected WRITE addr=0x111d data=0xff |
| 86515 | hbus monitor | Collected READ  addr=0x111d data=0xff |
| 86535 | hbus monitor | Collected WRITE addr=0x111e data=0xff |
| 86565 | hbus monitor | Collected READ  addr=0x111e data=0xff |
| 86585 | hbus monitor | Collected WRITE addr=0x111f data=0xff |
| 86615 | hbus monitor | Collected READ  addr=0x111f data=0xff |
| 86635 | hbus monitor | Collected WRITE addr=0x1120 data=0xff |
| 86665 | hbus monitor | Collected READ  addr=0x1120 data=0xff |
| 86685 | hbus monitor | Collected WRITE addr=0x1121 data=0xff |
| 86715 | hbus monitor | Collected READ  addr=0x1121 data=0xff |
| 86735 | hbus monitor | Collected WRITE addr=0x1122 data=0xff |
| 86765 | hbus monitor | Collected READ  addr=0x1122 data=0xff |
| 86785 | hbus monitor | Collected WRITE addr=0x1123 data=0xff |
| 86815 | hbus monitor | Collected READ  addr=0x1123 data=0xff |
| 86835 | hbus monitor | Collected WRITE addr=0x1124 data=0xff |
| 86865 | hbus monitor | Collected READ  addr=0x1124 data=0xff |
| 86885 | hbus monitor | Collected WRITE addr=0x1125 data=0xff |
| 86915 | hbus monitor | Collected READ  addr=0x1125 data=0xff |
| 86935 | hbus monitor | Collected WRITE addr=0x1126 data=0xff |
| 86965 | hbus monitor | Collected READ  addr=0x1126 data=0xff |
| 86985 | hbus monitor | Collected WRITE addr=0x1127 data=0xff |
| 87015 | hbus monitor | Collected READ  addr=0x1127 data=0xff |
| 87035 | hbus monitor | Collected WRITE addr=0x1128 data=0xff |
| 87065 | hbus monitor | Collected READ  addr=0x1128 data=0xff |
| 87085 | hbus monitor | Collected WRITE addr=0x1129 data=0xff |
| 87115 | hbus monitor | Collected READ  addr=0x1129 data=0xff |
| 87135 | hbus monitor | Collected WRITE addr=0x112a data=0xff |
| 87165 | hbus monitor | Collected READ  addr=0x112a data=0xff |
| 87185 | hbus monitor | Collected WRITE addr=0x112b data=0xff |
| 87215 | hbus monitor | Collected READ  addr=0x112b data=0xff |
| 87235 | hbus monitor | Collected WRITE addr=0x112c data=0xff |
| 87265 | hbus monitor | Collected READ  addr=0x112c data=0xff |
| 87285 | hbus monitor | Collected WRITE addr=0x112d data=0xff |
| 87315 | hbus monitor | Collected READ  addr=0x112d data=0xff |
| 87335 | hbus monitor | Collected WRITE addr=0x112e data=0xff |
| 87365 | hbus monitor | Collected READ  addr=0x112e data=0xff |
| 87385 | hbus monitor | Collected WRITE addr=0x112f data=0xff |
| 87415 | hbus monitor | Collected READ  addr=0x112f data=0xff |
| 87435 | hbus monitor | Collected WRITE addr=0x1130 data=0xff |
| 87465 | hbus monitor | Collected READ  addr=0x1130 data=0xff |
| 87485 | hbus monitor | Collected WRITE addr=0x1131 data=0xff |
| 87515 | hbus monitor | Collected READ  addr=0x1131 data=0xff |
| 87535 | hbus monitor | Collected WRITE addr=0x1132 data=0xff |
| 87565 | hbus monitor | Collected READ  addr=0x1132 data=0xff |
| 87585 | hbus monitor | Collected WRITE addr=0x1133 data=0xff |
| 87615 | hbus monitor | Collected READ  addr=0x1133 data=0xff |
| 87635 | hbus monitor | Collected WRITE addr=0x1134 data=0xff |
| 87665 | hbus monitor | Collected READ  addr=0x1134 data=0xff |
| 87685 | hbus monitor | Collected WRITE addr=0x1135 data=0xff |
| 87715 | hbus monitor | Collected READ  addr=0x1135 data=0xff |
| 87735 | hbus monitor | Collected WRITE addr=0x1136 data=0xff |
| 87765 | hbus monitor | Collected READ  addr=0x1136 data=0xff |
| 87785 | hbus monitor | Collected WRITE addr=0x1137 data=0xff |
| 87815 | hbus monitor | Collected READ  addr=0x1137 data=0xff |
| 87835 | hbus monitor | Collected WRITE addr=0x1138 data=0xff |
| 87865 | hbus monitor | Collected READ  addr=0x1138 data=0xff |
| 87885 | hbus monitor | Collected WRITE addr=0x1139 data=0xff |
| 87915 | hbus monitor | Collected READ  addr=0x1139 data=0xff |
| 87935 | hbus monitor | Collected WRITE addr=0x113a data=0xff |
| 87965 | hbus monitor | Collected READ  addr=0x113a data=0xff |
| 87985 | hbus monitor | Collected WRITE addr=0x113b data=0xff |
| 88015 | hbus monitor | Collected READ  addr=0x113b data=0xff |
| 88035 | hbus monitor | Collected WRITE addr=0x113c data=0xff |
| 88065 | hbus monitor | Collected READ  addr=0x113c data=0xff |
| 88085 | hbus monitor | Collected WRITE addr=0x113d data=0xff |
| 88115 | hbus monitor | Collected READ  addr=0x113d data=0xff |
| 88135 | hbus monitor | Collected WRITE addr=0x113e data=0xff |
| 88165 | hbus monitor | Collected READ  addr=0x113e data=0xff |
| 88185 | hbus monitor | Collected WRITE addr=0x113f data=0xff |
| 88215 | hbus monitor | Collected READ  addr=0x113f data=0xff |
| 88235 | hbus monitor | Collected WRITE addr=0x1140 data=0xff |
| 88265 | hbus monitor | Collected READ  addr=0x1140 data=0xff |
| 88285 | hbus monitor | Collected WRITE addr=0x1141 data=0xff |
| 88315 | hbus monitor | Collected READ  addr=0x1141 data=0xff |
| 88335 | hbus monitor | Collected WRITE addr=0x1142 data=0xff |
| 88365 | hbus monitor | Collected READ  addr=0x1142 data=0xff |
| 88385 | hbus monitor | Collected WRITE addr=0x1143 data=0xff |
| 88415 | hbus monitor | Collected READ  addr=0x1143 data=0xff |
| 88435 | hbus monitor | Collected WRITE addr=0x1144 data=0xff |
| 88465 | hbus monitor | Collected READ  addr=0x1144 data=0xff |
| 88485 | hbus monitor | Collected WRITE addr=0x1145 data=0xff |
| 88515 | hbus monitor | Collected READ  addr=0x1145 data=0xff |
| 88535 | hbus monitor | Collected WRITE addr=0x1146 data=0xff |
| 88565 | hbus monitor | Collected READ  addr=0x1146 data=0xff |
| 88585 | hbus monitor | Collected WRITE addr=0x1147 data=0xff |
| 88615 | hbus monitor | Collected READ  addr=0x1147 data=0xff |
| 88635 | hbus monitor | Collected WRITE addr=0x1148 data=0xff |
| 88665 | hbus monitor | Collected READ  addr=0x1148 data=0xff |
| 88685 | hbus monitor | Collected WRITE addr=0x1149 data=0xff |
| 88715 | hbus monitor | Collected READ  addr=0x1149 data=0xff |
| 88735 | hbus monitor | Collected WRITE addr=0x114a data=0xff |
| 88765 | hbus monitor | Collected READ  addr=0x114a data=0xff |
| 88785 | hbus monitor | Collected WRITE addr=0x114b data=0xff |
| 88815 | hbus monitor | Collected READ  addr=0x114b data=0xff |
| 88835 | hbus monitor | Collected WRITE addr=0x114c data=0xff |
| 88865 | hbus monitor | Collected READ  addr=0x114c data=0xff |
| 88885 | hbus monitor | Collected WRITE addr=0x114d data=0xff |
| 88915 | hbus monitor | Collected READ  addr=0x114d data=0xff |
| 88935 | hbus monitor | Collected WRITE addr=0x114e data=0xff |
| 88965 | hbus monitor | Collected READ  addr=0x114e data=0xff |
| 88985 | hbus monitor | Collected WRITE addr=0x114f data=0xff |
| 89015 | hbus monitor | Collected READ  addr=0x114f data=0xff |
| 89035 | hbus monitor | Collected WRITE addr=0x1150 data=0xff |
| 89065 | hbus monitor | Collected READ  addr=0x1150 data=0xff |
| 89085 | hbus monitor | Collected WRITE addr=0x1151 data=0xff |
| 89115 | hbus monitor | Collected READ  addr=0x1151 data=0xff |
| 89135 | hbus monitor | Collected WRITE addr=0x1152 data=0xff |
| 89165 | hbus monitor | Collected READ  addr=0x1152 data=0xff |
| 89185 | hbus monitor | Collected WRITE addr=0x1153 data=0xff |
| 89215 | hbus monitor | Collected READ  addr=0x1153 data=0xff |
| 89235 | hbus monitor | Collected WRITE addr=0x1154 data=0xff |
| 89265 | hbus monitor | Collected READ  addr=0x1154 data=0xff |
| 89285 | hbus monitor | Collected WRITE addr=0x1155 data=0xff |
| 89315 | hbus monitor | Collected READ  addr=0x1155 data=0xff |
| 89335 | hbus monitor | Collected WRITE addr=0x1156 data=0xff |
| 89365 | hbus monitor | Collected READ  addr=0x1156 data=0xff |
| 89385 | hbus monitor | Collected WRITE addr=0x1157 data=0xff |
| 89415 | hbus monitor | Collected READ  addr=0x1157 data=0xff |
| 89435 | hbus monitor | Collected WRITE addr=0x1158 data=0xff |
| 89465 | hbus monitor | Collected READ  addr=0x1158 data=0xff |
| 89485 | hbus monitor | Collected WRITE addr=0x1159 data=0xff |
| 89515 | hbus monitor | Collected READ  addr=0x1159 data=0xff |
| 89535 | hbus monitor | Collected WRITE addr=0x115a data=0xff |
| 89565 | hbus monitor | Collected READ  addr=0x115a data=0xff |
| 89585 | hbus monitor | Collected WRITE addr=0x115b data=0xff |
| 89615 | hbus monitor | Collected READ  addr=0x115b data=0xff |
| 89635 | hbus monitor | Collected WRITE addr=0x115c data=0xff |
| 89665 | hbus monitor | Collected READ  addr=0x115c data=0xff |
| 89685 | hbus monitor | Collected WRITE addr=0x115d data=0xff |
| 89715 | hbus monitor | Collected READ  addr=0x115d data=0xff |
| 89735 | hbus monitor | Collected WRITE addr=0x115e data=0xff |
| 89765 | hbus monitor | Collected READ  addr=0x115e data=0xff |
| 89785 | hbus monitor | Collected WRITE addr=0x115f data=0xff |
| 89815 | hbus monitor | Collected READ  addr=0x115f data=0xff |
| 89835 | hbus monitor | Collected WRITE addr=0x1160 data=0xff |
| 89865 | hbus monitor | Collected READ  addr=0x1160 data=0xff |
| 89885 | hbus monitor | Collected WRITE addr=0x1161 data=0xff |
| 89915 | hbus monitor | Collected READ  addr=0x1161 data=0xff |
| 89935 | hbus monitor | Collected WRITE addr=0x1162 data=0xff |
| 89965 | hbus monitor | Collected READ  addr=0x1162 data=0xff |
| 89985 | hbus monitor | Collected WRITE addr=0x1163 data=0xff |
| 90015 | hbus monitor | Collected READ  addr=0x1163 data=0xff |
| 90035 | hbus monitor | Collected WRITE addr=0x1164 data=0xff |
| 90065 | hbus monitor | Collected READ  addr=0x1164 data=0xff |
| 90085 | hbus monitor | Collected WRITE addr=0x1165 data=0xff |
| 90115 | hbus monitor | Collected READ  addr=0x1165 data=0xff |
| 90135 | hbus monitor | Collected WRITE addr=0x1166 data=0xff |
| 90165 | hbus monitor | Collected READ  addr=0x1166 data=0xff |
| 90185 | hbus monitor | Collected WRITE addr=0x1167 data=0xff |
| 90215 | hbus monitor | Collected READ  addr=0x1167 data=0xff |
| 90235 | hbus monitor | Collected WRITE addr=0x1168 data=0xff |
| 90265 | hbus monitor | Collected READ  addr=0x1168 data=0xff |
| 90285 | hbus monitor | Collected WRITE addr=0x1169 data=0xff |
| 90315 | hbus monitor | Collected READ  addr=0x1169 data=0xff |
| 90335 | hbus monitor | Collected WRITE addr=0x116a data=0xff |
| 90365 | hbus monitor | Collected READ  addr=0x116a data=0xff |
| 90385 | hbus monitor | Collected WRITE addr=0x116b data=0xff |
| 90415 | hbus monitor | Collected READ  addr=0x116b data=0xff |
| 90435 | hbus monitor | Collected WRITE addr=0x116c data=0xff |
| 90465 | hbus monitor | Collected READ  addr=0x116c data=0xff |
| 90485 | hbus monitor | Collected WRITE addr=0x116d data=0xff |
| 90515 | hbus monitor | Collected READ  addr=0x116d data=0xff |
| 90535 | hbus monitor | Collected WRITE addr=0x116e data=0xff |
| 90565 | hbus monitor | Collected READ  addr=0x116e data=0xff |
| 90585 | hbus monitor | Collected WRITE addr=0x116f data=0xff |
| 90615 | hbus monitor | Collected READ  addr=0x116f data=0xff |
| 90635 | hbus monitor | Collected WRITE addr=0x1170 data=0xff |
| 90665 | hbus monitor | Collected READ  addr=0x1170 data=0xff |
| 90685 | hbus monitor | Collected WRITE addr=0x1171 data=0xff |
| 90715 | hbus monitor | Collected READ  addr=0x1171 data=0xff |
| 90735 | hbus monitor | Collected WRITE addr=0x1172 data=0xff |
| 90765 | hbus monitor | Collected READ  addr=0x1172 data=0xff |
| 90785 | hbus monitor | Collected WRITE addr=0x1173 data=0xff |
| 90815 | hbus monitor | Collected READ  addr=0x1173 data=0xff |
| 90835 | hbus monitor | Collected WRITE addr=0x1174 data=0xff |
| 90865 | hbus monitor | Collected READ  addr=0x1174 data=0xff |
| 90885 | hbus monitor | Collected WRITE addr=0x1175 data=0xff |
| 90915 | hbus monitor | Collected READ  addr=0x1175 data=0xff |
| 90935 | hbus monitor | Collected WRITE addr=0x1176 data=0xff |
| 90965 | hbus monitor | Collected READ  addr=0x1176 data=0xff |
| 90985 | hbus monitor | Collected WRITE addr=0x1177 data=0xff |
| 91015 | hbus monitor | Collected READ  addr=0x1177 data=0xff |
| 91035 | hbus monitor | Collected WRITE addr=0x1178 data=0xff |
| 91065 | hbus monitor | Collected READ  addr=0x1178 data=0xff |
| 91085 | hbus monitor | Collected WRITE addr=0x1179 data=0xff |
| 91115 | hbus monitor | Collected READ  addr=0x1179 data=0xff |
| 91135 | hbus monitor | Collected WRITE addr=0x117a data=0xff |
| 91165 | hbus monitor | Collected READ  addr=0x117a data=0xff |
| 91185 | hbus monitor | Collected WRITE addr=0x117b data=0xff |
| 91215 | hbus monitor | Collected READ  addr=0x117b data=0xff |
| 91235 | hbus monitor | Collected WRITE addr=0x117c data=0xff |
| 91265 | hbus monitor | Collected READ  addr=0x117c data=0xff |
| 91285 | hbus monitor | Collected WRITE addr=0x117d data=0xff |
| 91315 | hbus monitor | Collected READ  addr=0x117d data=0xff |
| 91335 | hbus monitor | Collected WRITE addr=0x117e data=0xff |
| 91365 | hbus monitor | Collected READ  addr=0x117e data=0xff |
| 91385 | hbus monitor | Collected WRITE addr=0x117f data=0xff |
| 91415 | hbus monitor | Collected READ  addr=0x117f data=0xff |
| 91435 | hbus monitor | Collected WRITE addr=0x1180 data=0xff |
| 91465 | hbus monitor | Collected READ  addr=0x1180 data=0xff |
| 91485 | hbus monitor | Collected WRITE addr=0x1181 data=0xff |
| 91515 | hbus monitor | Collected READ  addr=0x1181 data=0xff |
| 91535 | hbus monitor | Collected WRITE addr=0x1182 data=0xff |
| 91565 | hbus monitor | Collected READ  addr=0x1182 data=0xff |
| 91585 | hbus monitor | Collected WRITE addr=0x1183 data=0xff |
| 91615 | hbus monitor | Collected READ  addr=0x1183 data=0xff |
| 91635 | hbus monitor | Collected WRITE addr=0x1184 data=0xff |
| 91665 | hbus monitor | Collected READ  addr=0x1184 data=0xff |
| 91685 | hbus monitor | Collected WRITE addr=0x1185 data=0xff |
| 91715 | hbus monitor | Collected READ  addr=0x1185 data=0xff |
| 91735 | hbus monitor | Collected WRITE addr=0x1186 data=0xff |
| 91765 | hbus monitor | Collected READ  addr=0x1186 data=0xff |
| 91785 | hbus monitor | Collected WRITE addr=0x1187 data=0xff |
| 91815 | hbus monitor | Collected READ  addr=0x1187 data=0xff |
| 91835 | hbus monitor | Collected WRITE addr=0x1188 data=0xff |
| 91865 | hbus monitor | Collected READ  addr=0x1188 data=0xff |
| 91885 | hbus monitor | Collected WRITE addr=0x1189 data=0xff |
| 91915 | hbus monitor | Collected READ  addr=0x1189 data=0xff |
| 91935 | hbus monitor | Collected WRITE addr=0x118a data=0xff |
| 91965 | hbus monitor | Collected READ  addr=0x118a data=0xff |
| 91985 | hbus monitor | Collected WRITE addr=0x118b data=0xff |
| 92015 | hbus monitor | Collected READ  addr=0x118b data=0xff |
| 92035 | hbus monitor | Collected WRITE addr=0x118c data=0xff |
| 92065 | hbus monitor | Collected READ  addr=0x118c data=0xff |
| 92085 | hbus monitor | Collected WRITE addr=0x118d data=0xff |
| 92115 | hbus monitor | Collected READ  addr=0x118d data=0xff |
| 92135 | hbus monitor | Collected WRITE addr=0x118e data=0xff |
| 92165 | hbus monitor | Collected READ  addr=0x118e data=0xff |
| 92185 | hbus monitor | Collected WRITE addr=0x118f data=0xff |
| 92215 | hbus monitor | Collected READ  addr=0x118f data=0xff |
| 92235 | hbus monitor | Collected WRITE addr=0x1190 data=0xff |
| 92265 | hbus monitor | Collected READ  addr=0x1190 data=0xff |
| 92285 | hbus monitor | Collected WRITE addr=0x1191 data=0xff |
| 92315 | hbus monitor | Collected READ  addr=0x1191 data=0xff |
| 92335 | hbus monitor | Collected WRITE addr=0x1192 data=0xff |
| 92365 | hbus monitor | Collected READ  addr=0x1192 data=0xff |
| 92385 | hbus monitor | Collected WRITE addr=0x1193 data=0xff |
| 92415 | hbus monitor | Collected READ  addr=0x1193 data=0xff |
| 92435 | hbus monitor | Collected WRITE addr=0x1194 data=0xff |
| 92465 | hbus monitor | Collected READ  addr=0x1194 data=0xff |
| 92485 | hbus monitor | Collected WRITE addr=0x1195 data=0xff |
| 92515 | hbus monitor | Collected READ  addr=0x1195 data=0xff |
| 92535 | hbus monitor | Collected WRITE addr=0x1196 data=0xff |
| 92565 | hbus monitor | Collected READ  addr=0x1196 data=0xff |
| 92585 | hbus monitor | Collected WRITE addr=0x1197 data=0xff |
| 92615 | hbus monitor | Collected READ  addr=0x1197 data=0xff |
| 92635 | hbus monitor | Collected WRITE addr=0x1198 data=0xff |
| 92665 | hbus monitor | Collected READ  addr=0x1198 data=0xff |
| 92685 | hbus monitor | Collected WRITE addr=0x1199 data=0xff |
| 92715 | hbus monitor | Collected READ  addr=0x1199 data=0xff |
| 92735 | hbus monitor | Collected WRITE addr=0x119a data=0xff |
| 92765 | hbus monitor | Collected READ  addr=0x119a data=0xff |
| 92785 | hbus monitor | Collected WRITE addr=0x119b data=0xff |
| 92815 | hbus monitor | Collected READ  addr=0x119b data=0xff |
| 92835 | hbus monitor | Collected WRITE addr=0x119c data=0xff |
| 92865 | hbus monitor | Collected READ  addr=0x119c data=0xff |
| 92885 | hbus monitor | Collected WRITE addr=0x119d data=0xff |
| 92915 | hbus monitor | Collected READ  addr=0x119d data=0xff |
| 92935 | hbus monitor | Collected WRITE addr=0x119e data=0xff |
| 92965 | hbus monitor | Collected READ  addr=0x119e data=0xff |
| 92985 | hbus monitor | Collected WRITE addr=0x119f data=0xff |
| 93015 | hbus monitor | Collected READ  addr=0x119f data=0xff |
| 93035 | hbus monitor | Collected WRITE addr=0x11a0 data=0xff |
| 93065 | hbus monitor | Collected READ  addr=0x11a0 data=0xff |
| 93085 | hbus monitor | Collected WRITE addr=0x11a1 data=0xff |
| 93115 | hbus monitor | Collected READ  addr=0x11a1 data=0xff |
| 93135 | hbus monitor | Collected WRITE addr=0x11a2 data=0xff |
| 93165 | hbus monitor | Collected READ  addr=0x11a2 data=0xff |
| 93185 | hbus monitor | Collected WRITE addr=0x11a3 data=0xff |
| 93215 | hbus monitor | Collected READ  addr=0x11a3 data=0xff |
| 93235 | hbus monitor | Collected WRITE addr=0x11a4 data=0xff |
| 93265 | hbus monitor | Collected READ  addr=0x11a4 data=0xff |
| 93285 | hbus monitor | Collected WRITE addr=0x11a5 data=0xff |
| 93315 | hbus monitor | Collected READ  addr=0x11a5 data=0xff |
| 93335 | hbus monitor | Collected WRITE addr=0x11a6 data=0xff |
| 93365 | hbus monitor | Collected READ  addr=0x11a6 data=0xff |
| 93385 | hbus monitor | Collected WRITE addr=0x11a7 data=0xff |
| 93415 | hbus monitor | Collected READ  addr=0x11a7 data=0xff |
| 93435 | hbus monitor | Collected WRITE addr=0x11a8 data=0xff |
| 93465 | hbus monitor | Collected READ  addr=0x11a8 data=0xff |
| 93485 | hbus monitor | Collected WRITE addr=0x11a9 data=0xff |
| 93515 | hbus monitor | Collected READ  addr=0x11a9 data=0xff |
| 93535 | hbus monitor | Collected WRITE addr=0x11aa data=0xff |
| 93565 | hbus monitor | Collected READ  addr=0x11aa data=0xff |
| 93585 | hbus monitor | Collected WRITE addr=0x11ab data=0xff |
| 93615 | hbus monitor | Collected READ  addr=0x11ab data=0xff |
| 93635 | hbus monitor | Collected WRITE addr=0x11ac data=0xff |
| 93665 | hbus monitor | Collected READ  addr=0x11ac data=0xff |
| 93685 | hbus monitor | Collected WRITE addr=0x11ad data=0xff |
| 93715 | hbus monitor | Collected READ  addr=0x11ad data=0xff |
| 93735 | hbus monitor | Collected WRITE addr=0x11ae data=0xff |
| 93765 | hbus monitor | Collected READ  addr=0x11ae data=0xff |
| 93785 | hbus monitor | Collected WRITE addr=0x11af data=0xff |
| 93815 | hbus monitor | Collected READ  addr=0x11af data=0xff |
| 93835 | hbus monitor | Collected WRITE addr=0x11b0 data=0xff |
| 93865 | hbus monitor | Collected READ  addr=0x11b0 data=0xff |
| 93885 | hbus monitor | Collected WRITE addr=0x11b1 data=0xff |
| 93915 | hbus monitor | Collected READ  addr=0x11b1 data=0xff |
| 93935 | hbus monitor | Collected WRITE addr=0x11b2 data=0xff |
| 93965 | hbus monitor | Collected READ  addr=0x11b2 data=0xff |
| 93985 | hbus monitor | Collected WRITE addr=0x11b3 data=0xff |
| 94015 | hbus monitor | Collected READ  addr=0x11b3 data=0xff |
| 94035 | hbus monitor | Collected WRITE addr=0x11b4 data=0xff |
| 94065 | hbus monitor | Collected READ  addr=0x11b4 data=0xff |
| 94085 | hbus monitor | Collected WRITE addr=0x11b5 data=0xff |
| 94115 | hbus monitor | Collected READ  addr=0x11b5 data=0xff |
| 94135 | hbus monitor | Collected WRITE addr=0x11b6 data=0xff |
| 94165 | hbus monitor | Collected READ  addr=0x11b6 data=0xff |
| 94185 | hbus monitor | Collected WRITE addr=0x11b7 data=0xff |
| 94215 | hbus monitor | Collected READ  addr=0x11b7 data=0xff |
| 94235 | hbus monitor | Collected WRITE addr=0x11b8 data=0xff |
| 94265 | hbus monitor | Collected READ  addr=0x11b8 data=0xff |
| 94285 | hbus monitor | Collected WRITE addr=0x11b9 data=0xff |
| 94315 | hbus monitor | Collected READ  addr=0x11b9 data=0xff |
| 94335 | hbus monitor | Collected WRITE addr=0x11ba data=0xff |
| 94365 | hbus monitor | Collected READ  addr=0x11ba data=0xff |
| 94385 | hbus monitor | Collected WRITE addr=0x11bb data=0xff |
| 94415 | hbus monitor | Collected READ  addr=0x11bb data=0xff |
| 94435 | hbus monitor | Collected WRITE addr=0x11bc data=0xff |
| 94465 | hbus monitor | Collected READ  addr=0x11bc data=0xff |
| 94485 | hbus monitor | Collected WRITE addr=0x11bd data=0xff |
| 94515 | hbus monitor | Collected READ  addr=0x11bd data=0xff |
| 94535 | hbus monitor | Collected WRITE addr=0x11be data=0xff |
| 94565 | hbus monitor | Collected READ  addr=0x11be data=0xff |
| 94585 | hbus monitor | Collected WRITE addr=0x11bf data=0xff |
| 94615 | hbus monitor | Collected READ  addr=0x11bf data=0xff |
| 94635 | hbus monitor | Collected WRITE addr=0x11c0 data=0xff |
| 94665 | hbus monitor | Collected READ  addr=0x11c0 data=0xff |
| 94685 | hbus monitor | Collected WRITE addr=0x11c1 data=0xff |
| 94715 | hbus monitor | Collected READ  addr=0x11c1 data=0xff |
| 94735 | hbus monitor | Collected WRITE addr=0x11c2 data=0xff |
| 94765 | hbus monitor | Collected READ  addr=0x11c2 data=0xff |
| 94785 | hbus monitor | Collected WRITE addr=0x11c3 data=0xff |
| 94815 | hbus monitor | Collected READ  addr=0x11c3 data=0xff |
| 94835 | hbus monitor | Collected WRITE addr=0x11c4 data=0xff |
| 94865 | hbus monitor | Collected READ  addr=0x11c4 data=0xff |
| 94885 | hbus monitor | Collected WRITE addr=0x11c5 data=0xff |
| 94915 | hbus monitor | Collected READ  addr=0x11c5 data=0xff |
| 94935 | hbus monitor | Collected WRITE addr=0x11c6 data=0xff |
| 94965 | hbus monitor | Collected READ  addr=0x11c6 data=0xff |
| 94985 | hbus monitor | Collected WRITE addr=0x11c7 data=0xff |
| 95015 | hbus monitor | Collected READ  addr=0x11c7 data=0xff |
| 95035 | hbus monitor | Collected WRITE addr=0x11c8 data=0xff |
| 95065 | hbus monitor | Collected READ  addr=0x11c8 data=0xff |
| 95085 | hbus monitor | Collected WRITE addr=0x11c9 data=0xff |
| 95115 | hbus monitor | Collected READ  addr=0x11c9 data=0xff |
| 95135 | hbus monitor | Collected WRITE addr=0x11ca data=0xff |
| 95165 | hbus monitor | Collected READ  addr=0x11ca data=0xff |
| 95185 | hbus monitor | Collected WRITE addr=0x11cb data=0xff |
| 95215 | hbus monitor | Collected READ  addr=0x11cb data=0xff |
| 95235 | hbus monitor | Collected WRITE addr=0x11cc data=0xff |
| 95265 | hbus monitor | Collected READ  addr=0x11cc data=0xff |
| 95285 | hbus monitor | Collected WRITE addr=0x11cd data=0xff |
| 95315 | hbus monitor | Collected READ  addr=0x11cd data=0xff |
| 95335 | hbus monitor | Collected WRITE addr=0x11ce data=0xff |
| 95365 | hbus monitor | Collected READ  addr=0x11ce data=0xff |
| 95385 | hbus monitor | Collected WRITE addr=0x11cf data=0xff |
| 95415 | hbus monitor | Collected READ  addr=0x11cf data=0xff |
| 95435 | hbus monitor | Collected WRITE addr=0x11d0 data=0xff |
| 95465 | hbus monitor | Collected READ  addr=0x11d0 data=0xff |
| 95485 | hbus monitor | Collected WRITE addr=0x11d1 data=0xff |
| 95515 | hbus monitor | Collected READ  addr=0x11d1 data=0xff |
| 95535 | hbus monitor | Collected WRITE addr=0x11d2 data=0xff |
| 95565 | hbus monitor | Collected READ  addr=0x11d2 data=0xff |
| 95585 | hbus monitor | Collected WRITE addr=0x11d3 data=0xff |
| 95615 | hbus monitor | Collected READ  addr=0x11d3 data=0xff |
| 95635 | hbus monitor | Collected WRITE addr=0x11d4 data=0xff |
| 95665 | hbus monitor | Collected READ  addr=0x11d4 data=0xff |
| 95685 | hbus monitor | Collected WRITE addr=0x11d5 data=0xff |
| 95715 | hbus monitor | Collected READ  addr=0x11d5 data=0xff |
| 95735 | hbus monitor | Collected WRITE addr=0x11d6 data=0xff |
| 95765 | hbus monitor | Collected READ  addr=0x11d6 data=0xff |
| 95785 | hbus monitor | Collected WRITE addr=0x11d7 data=0xff |
| 95815 | hbus monitor | Collected READ  addr=0x11d7 data=0xff |
| 95835 | hbus monitor | Collected WRITE addr=0x11d8 data=0xff |
| 95865 | hbus monitor | Collected READ  addr=0x11d8 data=0xff |
| 95885 | hbus monitor | Collected WRITE addr=0x11d9 data=0xff |
| 95915 | hbus monitor | Collected READ  addr=0x11d9 data=0xff |
| 95935 | hbus monitor | Collected WRITE addr=0x11da data=0xff |
| 95965 | hbus monitor | Collected READ  addr=0x11da data=0xff |
| 95985 | hbus monitor | Collected WRITE addr=0x11db data=0xff |
| 96015 | hbus monitor | Collected READ  addr=0x11db data=0xff |
| 96035 | hbus monitor | Collected WRITE addr=0x11dc data=0xff |
| 96065 | hbus monitor | Collected READ  addr=0x11dc data=0xff |
| 96085 | hbus monitor | Collected WRITE addr=0x11dd data=0xff |
| 96115 | hbus monitor | Collected READ  addr=0x11dd data=0xff |
| 96135 | hbus monitor | Collected WRITE addr=0x11de data=0xff |
| 96165 | hbus monitor | Collected READ  addr=0x11de data=0xff |
| 96185 | hbus monitor | Collected WRITE addr=0x11df data=0xff |
| 96215 | hbus monitor | Collected READ  addr=0x11df data=0xff |
| 96235 | hbus monitor | Collected WRITE addr=0x11e0 data=0xff |
| 96265 | hbus monitor | Collected READ  addr=0x11e0 data=0xff |
| 96285 | hbus monitor | Collected WRITE addr=0x11e1 data=0xff |
| 96315 | hbus monitor | Collected READ  addr=0x11e1 data=0xff |
| 96335 | hbus monitor | Collected WRITE addr=0x11e2 data=0xff |
| 96365 | hbus monitor | Collected READ  addr=0x11e2 data=0xff |
| 96385 | hbus monitor | Collected WRITE addr=0x11e3 data=0xff |
| 96415 | hbus monitor | Collected READ  addr=0x11e3 data=0xff |
| 96435 | hbus monitor | Collected WRITE addr=0x11e4 data=0xff |
| 96465 | hbus monitor | Collected READ  addr=0x11e4 data=0xff |
| 96485 | hbus monitor | Collected WRITE addr=0x11e5 data=0xff |
| 96515 | hbus monitor | Collected READ  addr=0x11e5 data=0xff |
| 96535 | hbus monitor | Collected WRITE addr=0x11e6 data=0xff |
| 96565 | hbus monitor | Collected READ  addr=0x11e6 data=0xff |
| 96585 | hbus monitor | Collected WRITE addr=0x11e7 data=0xff |
| 96615 | hbus monitor | Collected READ  addr=0x11e7 data=0xff |
| 96635 | hbus monitor | Collected WRITE addr=0x11e8 data=0xff |
| 96665 | hbus monitor | Collected READ  addr=0x11e8 data=0xff |
| 96685 | hbus monitor | Collected WRITE addr=0x11e9 data=0xff |
| 96715 | hbus monitor | Collected READ  addr=0x11e9 data=0xff |
| 96735 | hbus monitor | Collected WRITE addr=0x11ea data=0xff |
| 96765 | hbus monitor | Collected READ  addr=0x11ea data=0xff |
| 96785 | hbus monitor | Collected WRITE addr=0x11eb data=0xff |
| 96815 | hbus monitor | Collected READ  addr=0x11eb data=0xff |
| 96835 | hbus monitor | Collected WRITE addr=0x11ec data=0xff |
| 96865 | hbus monitor | Collected READ  addr=0x11ec data=0xff |
| 96885 | hbus monitor | Collected WRITE addr=0x11ed data=0xff |
| 96915 | hbus monitor | Collected READ  addr=0x11ed data=0xff |
| 96935 | hbus monitor | Collected WRITE addr=0x11ee data=0xff |
| 96965 | hbus monitor | Collected READ  addr=0x11ee data=0xff |
| 96985 | hbus monitor | Collected WRITE addr=0x11ef data=0xff |
| 97015 | hbus monitor | Collected READ  addr=0x11ef data=0xff |
| 97035 | hbus monitor | Collected WRITE addr=0x11f0 data=0xff |
| 97065 | hbus monitor | Collected READ  addr=0x11f0 data=0xff |
| 97085 | hbus monitor | Collected WRITE addr=0x11f1 data=0xff |
| 97115 | hbus monitor | Collected READ  addr=0x11f1 data=0xff |
| 97135 | hbus monitor | Collected WRITE addr=0x11f2 data=0xff |
| 97165 | hbus monitor | Collected READ  addr=0x11f2 data=0xff |
| 97185 | hbus monitor | Collected WRITE addr=0x11f3 data=0xff |
| 97215 | hbus monitor | Collected READ  addr=0x11f3 data=0xff |
| 97235 | hbus monitor | Collected WRITE addr=0x11f4 data=0xff |
| 97265 | hbus monitor | Collected READ  addr=0x11f4 data=0xff |
| 97285 | hbus monitor | Collected WRITE addr=0x11f5 data=0xff |
| 97315 | hbus monitor | Collected READ  addr=0x11f5 data=0xff |
| 97335 | hbus monitor | Collected WRITE addr=0x11f6 data=0xff |
| 97365 | hbus monitor | Collected READ  addr=0x11f6 data=0xff |
| 97385 | hbus monitor | Collected WRITE addr=0x11f7 data=0xff |
| 97415 | hbus monitor | Collected READ  addr=0x11f7 data=0xff |
| 97435 | hbus monitor | Collected WRITE addr=0x11f8 data=0xff |
| 97465 | hbus monitor | Collected READ  addr=0x11f8 data=0xff |
| 97485 | hbus monitor | Collected WRITE addr=0x11f9 data=0xff |
| 97515 | hbus monitor | Collected READ  addr=0x11f9 data=0xff |
| 97535 | hbus monitor | Collected WRITE addr=0x11fa data=0xff |
| 97565 | hbus monitor | Collected READ  addr=0x11fa data=0xff |
| 97585 | hbus monitor | Collected WRITE addr=0x11fb data=0xff |
| 97615 | hbus monitor | Collected READ  addr=0x11fb data=0xff |
| 97635 | hbus monitor | Collected WRITE addr=0x11fc data=0xff |
| 97665 | hbus monitor | Collected READ  addr=0x11fc data=0xff |
| 97685 | hbus monitor | Collected WRITE addr=0x11fd data=0xff |
| 97715 | hbus monitor | Collected READ  addr=0x11fd data=0xff |
| 97735 | hbus monitor | Collected WRITE addr=0x11fe data=0xff |
| 97765 | hbus monitor | Collected READ  addr=0x11fe data=0xff |
| 97785 | hbus monitor | Collected WRITE addr=0x11ff data=0xff |
| 97815 | hbus monitor | Collected READ  addr=0x11ff data=0xff |
| 97835 | hbus monitor | Collected WRITE addr=0x1100 data=0x55 |
| 97865 | hbus monitor | Collected READ  addr=0x1100 data=0x55 |
| 97885 | hbus monitor | Collected WRITE addr=0x1101 data=0x55 |
| 97915 | hbus monitor | Collected READ  addr=0x1101 data=0x55 |
| 97935 | hbus monitor | Collected WRITE addr=0x1102 data=0x55 |
| 97965 | hbus monitor | Collected READ  addr=0x1102 data=0x55 |
| 97985 | hbus monitor | Collected WRITE addr=0x1103 data=0x55 |
| 98015 | hbus monitor | Collected READ  addr=0x1103 data=0x55 |
| 98035 | hbus monitor | Collected WRITE addr=0x1104 data=0x55 |
| 98065 | hbus monitor | Collected READ  addr=0x1104 data=0x55 |
| 98085 | hbus monitor | Collected WRITE addr=0x1105 data=0x55 |
| 98115 | hbus monitor | Collected READ  addr=0x1105 data=0x55 |
| 98135 | hbus monitor | Collected WRITE addr=0x1106 data=0x55 |
| 98165 | hbus monitor | Collected READ  addr=0x1106 data=0x55 |
| 98185 | hbus monitor | Collected WRITE addr=0x1107 data=0x55 |
| 98215 | hbus monitor | Collected READ  addr=0x1107 data=0x55 |
| 98235 | hbus monitor | Collected WRITE addr=0x1108 data=0x55 |
| 98265 | hbus monitor | Collected READ  addr=0x1108 data=0x55 |
| 98285 | hbus monitor | Collected WRITE addr=0x1109 data=0x55 |
| 98315 | hbus monitor | Collected READ  addr=0x1109 data=0x55 |
| 98335 | hbus monitor | Collected WRITE addr=0x110a data=0x55 |
| 98365 | hbus monitor | Collected READ  addr=0x110a data=0x55 |
| 98385 | hbus monitor | Collected WRITE addr=0x110b data=0x55 |
| 98415 | hbus monitor | Collected READ  addr=0x110b data=0x55 |
| 98435 | hbus monitor | Collected WRITE addr=0x110c data=0x55 |
| 98465 | hbus monitor | Collected READ  addr=0x110c data=0x55 |
| 98485 | hbus monitor | Collected WRITE addr=0x110d data=0x55 |
| 98515 | hbus monitor | Collected READ  addr=0x110d data=0x55 |
| 98535 | hbus monitor | Collected WRITE addr=0x110e data=0x55 |
| 98565 | hbus monitor | Collected READ  addr=0x110e data=0x55 |
| 98585 | hbus monitor | Collected WRITE addr=0x110f data=0x55 |
| 98615 | hbus monitor | Collected READ  addr=0x110f data=0x55 |
| 98635 | hbus monitor | Collected WRITE addr=0x1110 data=0x55 |
| 98665 | hbus monitor | Collected READ  addr=0x1110 data=0x55 |
| 98685 | hbus monitor | Collected WRITE addr=0x1111 data=0x55 |
| 98715 | hbus monitor | Collected READ  addr=0x1111 data=0x55 |
| 98735 | hbus monitor | Collected WRITE addr=0x1112 data=0x55 |
| 98765 | hbus monitor | Collected READ  addr=0x1112 data=0x55 |
| 98785 | hbus monitor | Collected WRITE addr=0x1113 data=0x55 |
| 98815 | hbus monitor | Collected READ  addr=0x1113 data=0x55 |
| 98835 | hbus monitor | Collected WRITE addr=0x1114 data=0x55 |
| 98865 | hbus monitor | Collected READ  addr=0x1114 data=0x55 |
| 98885 | hbus monitor | Collected WRITE addr=0x1115 data=0x55 |
| 98915 | hbus monitor | Collected READ  addr=0x1115 data=0x55 |
| 98935 | hbus monitor | Collected WRITE addr=0x1116 data=0x55 |
| 98965 | hbus monitor | Collected READ  addr=0x1116 data=0x55 |
| 98985 | hbus monitor | Collected WRITE addr=0x1117 data=0x55 |
| 99015 | hbus monitor | Collected READ  addr=0x1117 data=0x55 |
| 99035 | hbus monitor | Collected WRITE addr=0x1118 data=0x55 |
| 99065 | hbus monitor | Collected READ  addr=0x1118 data=0x55 |
| 99085 | hbus monitor | Collected WRITE addr=0x1119 data=0x55 |
| 99115 | hbus monitor | Collected READ  addr=0x1119 data=0x55 |
| 99135 | hbus monitor | Collected WRITE addr=0x111a data=0x55 |
| 99165 | hbus monitor | Collected READ  addr=0x111a data=0x55 |
| 99185 | hbus monitor | Collected WRITE addr=0x111b data=0x55 |
| 99215 | hbus monitor | Collected READ  addr=0x111b data=0x55 |
| 99235 | hbus monitor | Collected WRITE addr=0x111c data=0x55 |
| 99265 | hbus monitor | Collected READ  addr=0x111c data=0x55 |
| 99285 | hbus monitor | Collected WRITE addr=0x111d data=0x55 |
| 99315 | hbus monitor | Collected READ  addr=0x111d data=0x55 |
| 99335 | hbus monitor | Collected WRITE addr=0x111e data=0x55 |
| 99365 | hbus monitor | Collected READ  addr=0x111e data=0x55 |
| 99385 | hbus monitor | Collected WRITE addr=0x111f data=0x55 |
| 99415 | hbus monitor | Collected READ  addr=0x111f data=0x55 |
| 99435 | hbus monitor | Collected WRITE addr=0x1120 data=0x55 |
| 99465 | hbus monitor | Collected READ  addr=0x1120 data=0x55 |
| 99485 | hbus monitor | Collected WRITE addr=0x1121 data=0x55 |
| 99515 | hbus monitor | Collected READ  addr=0x1121 data=0x55 |
| 99535 | hbus monitor | Collected WRITE addr=0x1122 data=0x55 |
| 99565 | hbus monitor | Collected READ  addr=0x1122 data=0x55 |
| 99585 | hbus monitor | Collected WRITE addr=0x1123 data=0x55 |
| 99615 | hbus monitor | Collected READ  addr=0x1123 data=0x55 |
| 99635 | hbus monitor | Collected WRITE addr=0x1124 data=0x55 |
| 99665 | hbus monitor | Collected READ  addr=0x1124 data=0x55 |
| 99685 | hbus monitor | Collected WRITE addr=0x1125 data=0x55 |
| 99715 | hbus monitor | Collected READ  addr=0x1125 data=0x55 |
| 99735 | hbus monitor | Collected WRITE addr=0x1126 data=0x55 |
| 99765 | hbus monitor | Collected READ  addr=0x1126 data=0x55 |
| 99785 | hbus monitor | Collected WRITE addr=0x1127 data=0x55 |
| 99815 | hbus monitor | Collected READ  addr=0x1127 data=0x55 |
| 99835 | hbus monitor | Collected WRITE addr=0x1128 data=0x55 |
| 99865 | hbus monitor | Collected READ  addr=0x1128 data=0x55 |
| 99885 | hbus monitor | Collected WRITE addr=0x1129 data=0x55 |
| 99915 | hbus monitor | Collected READ  addr=0x1129 data=0x55 |
| 99935 | hbus monitor | Collected WRITE addr=0x112a data=0x55 |
| 99965 | hbus monitor | Collected READ  addr=0x112a data=0x55 |
| 99985 | hbus monitor | Collected WRITE addr=0x112b data=0x55 |
| 100015 | hbus monitor | Collected READ  addr=0x112b data=0x55 |
| 100035 | hbus monitor | Collected WRITE addr=0x112c data=0x55 |
| 100065 | hbus monitor | Collected READ  addr=0x112c data=0x55 |
| 100085 | hbus monitor | Collected WRITE addr=0x112d data=0x55 |
| 100115 | hbus monitor | Collected READ  addr=0x112d data=0x55 |
| 100135 | hbus monitor | Collected WRITE addr=0x112e data=0x55 |
| 100165 | hbus monitor | Collected READ  addr=0x112e data=0x55 |
| 100185 | hbus monitor | Collected WRITE addr=0x112f data=0x55 |
| 100215 | hbus monitor | Collected READ  addr=0x112f data=0x55 |
| 100235 | hbus monitor | Collected WRITE addr=0x1130 data=0x55 |
| 100265 | hbus monitor | Collected READ  addr=0x1130 data=0x55 |
| 100285 | hbus monitor | Collected WRITE addr=0x1131 data=0x55 |
| 100315 | hbus monitor | Collected READ  addr=0x1131 data=0x55 |
| 100335 | hbus monitor | Collected WRITE addr=0x1132 data=0x55 |
| 100365 | hbus monitor | Collected READ  addr=0x1132 data=0x55 |
| 100385 | hbus monitor | Collected WRITE addr=0x1133 data=0x55 |
| 100415 | hbus monitor | Collected READ  addr=0x1133 data=0x55 |
| 100435 | hbus monitor | Collected WRITE addr=0x1134 data=0x55 |
| 100465 | hbus monitor | Collected READ  addr=0x1134 data=0x55 |
| 100485 | hbus monitor | Collected WRITE addr=0x1135 data=0x55 |
| 100515 | hbus monitor | Collected READ  addr=0x1135 data=0x55 |
| 100535 | hbus monitor | Collected WRITE addr=0x1136 data=0x55 |
| 100565 | hbus monitor | Collected READ  addr=0x1136 data=0x55 |
| 100585 | hbus monitor | Collected WRITE addr=0x1137 data=0x55 |
| 100615 | hbus monitor | Collected READ  addr=0x1137 data=0x55 |
| 100635 | hbus monitor | Collected WRITE addr=0x1138 data=0x55 |
| 100665 | hbus monitor | Collected READ  addr=0x1138 data=0x55 |
| 100685 | hbus monitor | Collected WRITE addr=0x1139 data=0x55 |
| 100715 | hbus monitor | Collected READ  addr=0x1139 data=0x55 |
| 100735 | hbus monitor | Collected WRITE addr=0x113a data=0x55 |
| 100765 | hbus monitor | Collected READ  addr=0x113a data=0x55 |
| 100785 | hbus monitor | Collected WRITE addr=0x113b data=0x55 |
| 100815 | hbus monitor | Collected READ  addr=0x113b data=0x55 |
| 100835 | hbus monitor | Collected WRITE addr=0x113c data=0x55 |
| 100865 | hbus monitor | Collected READ  addr=0x113c data=0x55 |
| 100885 | hbus monitor | Collected WRITE addr=0x113d data=0x55 |
| 100915 | hbus monitor | Collected READ  addr=0x113d data=0x55 |
| 100935 | hbus monitor | Collected WRITE addr=0x113e data=0x55 |
| 100965 | hbus monitor | Collected READ  addr=0x113e data=0x55 |
| 100985 | hbus monitor | Collected WRITE addr=0x113f data=0x55 |
| 101015 | hbus monitor | Collected READ  addr=0x113f data=0x55 |
| 101035 | hbus monitor | Collected WRITE addr=0x1140 data=0x55 |
| 101065 | hbus monitor | Collected READ  addr=0x1140 data=0x55 |
| 101085 | hbus monitor | Collected WRITE addr=0x1141 data=0x55 |
| 101115 | hbus monitor | Collected READ  addr=0x1141 data=0x55 |
| 101135 | hbus monitor | Collected WRITE addr=0x1142 data=0x55 |
| 101165 | hbus monitor | Collected READ  addr=0x1142 data=0x55 |
| 101185 | hbus monitor | Collected WRITE addr=0x1143 data=0x55 |
| 101215 | hbus monitor | Collected READ  addr=0x1143 data=0x55 |
| 101235 | hbus monitor | Collected WRITE addr=0x1144 data=0x55 |
| 101265 | hbus monitor | Collected READ  addr=0x1144 data=0x55 |
| 101285 | hbus monitor | Collected WRITE addr=0x1145 data=0x55 |
| 101315 | hbus monitor | Collected READ  addr=0x1145 data=0x55 |
| 101335 | hbus monitor | Collected WRITE addr=0x1146 data=0x55 |
| 101365 | hbus monitor | Collected READ  addr=0x1146 data=0x55 |
| 101385 | hbus monitor | Collected WRITE addr=0x1147 data=0x55 |
| 101415 | hbus monitor | Collected READ  addr=0x1147 data=0x55 |
| 101435 | hbus monitor | Collected WRITE addr=0x1148 data=0x55 |
| 101465 | hbus monitor | Collected READ  addr=0x1148 data=0x55 |
| 101485 | hbus monitor | Collected WRITE addr=0x1149 data=0x55 |
| 101515 | hbus monitor | Collected READ  addr=0x1149 data=0x55 |
| 101535 | hbus monitor | Collected WRITE addr=0x114a data=0x55 |
| 101565 | hbus monitor | Collected READ  addr=0x114a data=0x55 |
| 101585 | hbus monitor | Collected WRITE addr=0x114b data=0x55 |
| 101615 | hbus monitor | Collected READ  addr=0x114b data=0x55 |
| 101635 | hbus monitor | Collected WRITE addr=0x114c data=0x55 |
| 101665 | hbus monitor | Collected READ  addr=0x114c data=0x55 |
| 101685 | hbus monitor | Collected WRITE addr=0x114d data=0x55 |
| 101715 | hbus monitor | Collected READ  addr=0x114d data=0x55 |
| 101735 | hbus monitor | Collected WRITE addr=0x114e data=0x55 |
| 101765 | hbus monitor | Collected READ  addr=0x114e data=0x55 |
| 101785 | hbus monitor | Collected WRITE addr=0x114f data=0x55 |
| 101815 | hbus monitor | Collected READ  addr=0x114f data=0x55 |
| 101835 | hbus monitor | Collected WRITE addr=0x1150 data=0x55 |
| 101865 | hbus monitor | Collected READ  addr=0x1150 data=0x55 |
| 101885 | hbus monitor | Collected WRITE addr=0x1151 data=0x55 |
| 101915 | hbus monitor | Collected READ  addr=0x1151 data=0x55 |
| 101935 | hbus monitor | Collected WRITE addr=0x1152 data=0x55 |
| 101965 | hbus monitor | Collected READ  addr=0x1152 data=0x55 |
| 101985 | hbus monitor | Collected WRITE addr=0x1153 data=0x55 |
| 102015 | hbus monitor | Collected READ  addr=0x1153 data=0x55 |
| 102035 | hbus monitor | Collected WRITE addr=0x1154 data=0x55 |
| 102065 | hbus monitor | Collected READ  addr=0x1154 data=0x55 |
| 102085 | hbus monitor | Collected WRITE addr=0x1155 data=0x55 |
| 102115 | hbus monitor | Collected READ  addr=0x1155 data=0x55 |
| 102135 | hbus monitor | Collected WRITE addr=0x1156 data=0x55 |
| 102165 | hbus monitor | Collected READ  addr=0x1156 data=0x55 |
| 102185 | hbus monitor | Collected WRITE addr=0x1157 data=0x55 |
| 102215 | hbus monitor | Collected READ  addr=0x1157 data=0x55 |
| 102235 | hbus monitor | Collected WRITE addr=0x1158 data=0x55 |
| 102265 | hbus monitor | Collected READ  addr=0x1158 data=0x55 |
| 102285 | hbus monitor | Collected WRITE addr=0x1159 data=0x55 |
| 102315 | hbus monitor | Collected READ  addr=0x1159 data=0x55 |
| 102335 | hbus monitor | Collected WRITE addr=0x115a data=0x55 |
| 102365 | hbus monitor | Collected READ  addr=0x115a data=0x55 |
| 102385 | hbus monitor | Collected WRITE addr=0x115b data=0x55 |
| 102415 | hbus monitor | Collected READ  addr=0x115b data=0x55 |
| 102435 | hbus monitor | Collected WRITE addr=0x115c data=0x55 |
| 102465 | hbus monitor | Collected READ  addr=0x115c data=0x55 |
| 102485 | hbus monitor | Collected WRITE addr=0x115d data=0x55 |
| 102515 | hbus monitor | Collected READ  addr=0x115d data=0x55 |
| 102535 | hbus monitor | Collected WRITE addr=0x115e data=0x55 |
| 102565 | hbus monitor | Collected READ  addr=0x115e data=0x55 |
| 102585 | hbus monitor | Collected WRITE addr=0x115f data=0x55 |
| 102615 | hbus monitor | Collected READ  addr=0x115f data=0x55 |
| 102635 | hbus monitor | Collected WRITE addr=0x1160 data=0x55 |
| 102665 | hbus monitor | Collected READ  addr=0x1160 data=0x55 |
| 102685 | hbus monitor | Collected WRITE addr=0x1161 data=0x55 |
| 102715 | hbus monitor | Collected READ  addr=0x1161 data=0x55 |
| 102735 | hbus monitor | Collected WRITE addr=0x1162 data=0x55 |
| 102765 | hbus monitor | Collected READ  addr=0x1162 data=0x55 |
| 102785 | hbus monitor | Collected WRITE addr=0x1163 data=0x55 |
| 102815 | hbus monitor | Collected READ  addr=0x1163 data=0x55 |
| 102835 | hbus monitor | Collected WRITE addr=0x1164 data=0x55 |
| 102865 | hbus monitor | Collected READ  addr=0x1164 data=0x55 |
| 102885 | hbus monitor | Collected WRITE addr=0x1165 data=0x55 |
| 102915 | hbus monitor | Collected READ  addr=0x1165 data=0x55 |
| 102935 | hbus monitor | Collected WRITE addr=0x1166 data=0x55 |
| 102965 | hbus monitor | Collected READ  addr=0x1166 data=0x55 |
| 102985 | hbus monitor | Collected WRITE addr=0x1167 data=0x55 |
| 103015 | hbus monitor | Collected READ  addr=0x1167 data=0x55 |
| 103035 | hbus monitor | Collected WRITE addr=0x1168 data=0x55 |
| 103065 | hbus monitor | Collected READ  addr=0x1168 data=0x55 |
| 103085 | hbus monitor | Collected WRITE addr=0x1169 data=0x55 |
| 103115 | hbus monitor | Collected READ  addr=0x1169 data=0x55 |
| 103135 | hbus monitor | Collected WRITE addr=0x116a data=0x55 |
| 103165 | hbus monitor | Collected READ  addr=0x116a data=0x55 |
| 103185 | hbus monitor | Collected WRITE addr=0x116b data=0x55 |
| 103215 | hbus monitor | Collected READ  addr=0x116b data=0x55 |
| 103235 | hbus monitor | Collected WRITE addr=0x116c data=0x55 |
| 103265 | hbus monitor | Collected READ  addr=0x116c data=0x55 |
| 103285 | hbus monitor | Collected WRITE addr=0x116d data=0x55 |
| 103315 | hbus monitor | Collected READ  addr=0x116d data=0x55 |
| 103335 | hbus monitor | Collected WRITE addr=0x116e data=0x55 |
| 103365 | hbus monitor | Collected READ  addr=0x116e data=0x55 |
| 103385 | hbus monitor | Collected WRITE addr=0x116f data=0x55 |
| 103415 | hbus monitor | Collected READ  addr=0x116f data=0x55 |
| 103435 | hbus monitor | Collected WRITE addr=0x1170 data=0x55 |
| 103465 | hbus monitor | Collected READ  addr=0x1170 data=0x55 |
| 103485 | hbus monitor | Collected WRITE addr=0x1171 data=0x55 |
| 103515 | hbus monitor | Collected READ  addr=0x1171 data=0x55 |
| 103535 | hbus monitor | Collected WRITE addr=0x1172 data=0x55 |
| 103565 | hbus monitor | Collected READ  addr=0x1172 data=0x55 |
| 103585 | hbus monitor | Collected WRITE addr=0x1173 data=0x55 |
| 103615 | hbus monitor | Collected READ  addr=0x1173 data=0x55 |
| 103635 | hbus monitor | Collected WRITE addr=0x1174 data=0x55 |
| 103665 | hbus monitor | Collected READ  addr=0x1174 data=0x55 |
| 103685 | hbus monitor | Collected WRITE addr=0x1175 data=0x55 |
| 103715 | hbus monitor | Collected READ  addr=0x1175 data=0x55 |
| 103735 | hbus monitor | Collected WRITE addr=0x1176 data=0x55 |
| 103765 | hbus monitor | Collected READ  addr=0x1176 data=0x55 |
| 103785 | hbus monitor | Collected WRITE addr=0x1177 data=0x55 |
| 103815 | hbus monitor | Collected READ  addr=0x1177 data=0x55 |
| 103835 | hbus monitor | Collected WRITE addr=0x1178 data=0x55 |
| 103865 | hbus monitor | Collected READ  addr=0x1178 data=0x55 |
| 103885 | hbus monitor | Collected WRITE addr=0x1179 data=0x55 |
| 103915 | hbus monitor | Collected READ  addr=0x1179 data=0x55 |
| 103935 | hbus monitor | Collected WRITE addr=0x117a data=0x55 |
| 103965 | hbus monitor | Collected READ  addr=0x117a data=0x55 |
| 103985 | hbus monitor | Collected WRITE addr=0x117b data=0x55 |
| 104015 | hbus monitor | Collected READ  addr=0x117b data=0x55 |
| 104035 | hbus monitor | Collected WRITE addr=0x117c data=0x55 |
| 104065 | hbus monitor | Collected READ  addr=0x117c data=0x55 |
| 104085 | hbus monitor | Collected WRITE addr=0x117d data=0x55 |
| 104115 | hbus monitor | Collected READ  addr=0x117d data=0x55 |
| 104135 | hbus monitor | Collected WRITE addr=0x117e data=0x55 |
| 104165 | hbus monitor | Collected READ  addr=0x117e data=0x55 |
| 104185 | hbus monitor | Collected WRITE addr=0x117f data=0x55 |
| 104215 | hbus monitor | Collected READ  addr=0x117f data=0x55 |
| 104235 | hbus monitor | Collected WRITE addr=0x1180 data=0x55 |
| 104265 | hbus monitor | Collected READ  addr=0x1180 data=0x55 |
| 104285 | hbus monitor | Collected WRITE addr=0x1181 data=0x55 |
| 104315 | hbus monitor | Collected READ  addr=0x1181 data=0x55 |
| 104335 | hbus monitor | Collected WRITE addr=0x1182 data=0x55 |
| 104365 | hbus monitor | Collected READ  addr=0x1182 data=0x55 |
| 104385 | hbus monitor | Collected WRITE addr=0x1183 data=0x55 |
| 104415 | hbus monitor | Collected READ  addr=0x1183 data=0x55 |
| 104435 | hbus monitor | Collected WRITE addr=0x1184 data=0x55 |
| 104465 | hbus monitor | Collected READ  addr=0x1184 data=0x55 |
| 104485 | hbus monitor | Collected WRITE addr=0x1185 data=0x55 |
| 104515 | hbus monitor | Collected READ  addr=0x1185 data=0x55 |
| 104535 | hbus monitor | Collected WRITE addr=0x1186 data=0x55 |
| 104565 | hbus monitor | Collected READ  addr=0x1186 data=0x55 |
| 104585 | hbus monitor | Collected WRITE addr=0x1187 data=0x55 |
| 104615 | hbus monitor | Collected READ  addr=0x1187 data=0x55 |
| 104635 | hbus monitor | Collected WRITE addr=0x1188 data=0x55 |
| 104665 | hbus monitor | Collected READ  addr=0x1188 data=0x55 |
| 104685 | hbus monitor | Collected WRITE addr=0x1189 data=0x55 |
| 104715 | hbus monitor | Collected READ  addr=0x1189 data=0x55 |
| 104735 | hbus monitor | Collected WRITE addr=0x118a data=0x55 |
| 104765 | hbus monitor | Collected READ  addr=0x118a data=0x55 |
| 104785 | hbus monitor | Collected WRITE addr=0x118b data=0x55 |
| 104815 | hbus monitor | Collected READ  addr=0x118b data=0x55 |
| 104835 | hbus monitor | Collected WRITE addr=0x118c data=0x55 |
| 104865 | hbus monitor | Collected READ  addr=0x118c data=0x55 |
| 104885 | hbus monitor | Collected WRITE addr=0x118d data=0x55 |
| 104915 | hbus monitor | Collected READ  addr=0x118d data=0x55 |
| 104935 | hbus monitor | Collected WRITE addr=0x118e data=0x55 |
| 104965 | hbus monitor | Collected READ  addr=0x118e data=0x55 |
| 104985 | hbus monitor | Collected WRITE addr=0x118f data=0x55 |
| 105015 | hbus monitor | Collected READ  addr=0x118f data=0x55 |
| 105035 | hbus monitor | Collected WRITE addr=0x1190 data=0x55 |
| 105065 | hbus monitor | Collected READ  addr=0x1190 data=0x55 |
| 105085 | hbus monitor | Collected WRITE addr=0x1191 data=0x55 |
| 105115 | hbus monitor | Collected READ  addr=0x1191 data=0x55 |
| 105135 | hbus monitor | Collected WRITE addr=0x1192 data=0x55 |
| 105165 | hbus monitor | Collected READ  addr=0x1192 data=0x55 |
| 105185 | hbus monitor | Collected WRITE addr=0x1193 data=0x55 |
| 105215 | hbus monitor | Collected READ  addr=0x1193 data=0x55 |
| 105235 | hbus monitor | Collected WRITE addr=0x1194 data=0x55 |
| 105265 | hbus monitor | Collected READ  addr=0x1194 data=0x55 |
| 105285 | hbus monitor | Collected WRITE addr=0x1195 data=0x55 |
| 105315 | hbus monitor | Collected READ  addr=0x1195 data=0x55 |
| 105335 | hbus monitor | Collected WRITE addr=0x1196 data=0x55 |
| 105365 | hbus monitor | Collected READ  addr=0x1196 data=0x55 |
| 105385 | hbus monitor | Collected WRITE addr=0x1197 data=0x55 |
| 105415 | hbus monitor | Collected READ  addr=0x1197 data=0x55 |
| 105435 | hbus monitor | Collected WRITE addr=0x1198 data=0x55 |
| 105465 | hbus monitor | Collected READ  addr=0x1198 data=0x55 |
| 105485 | hbus monitor | Collected WRITE addr=0x1199 data=0x55 |
| 105515 | hbus monitor | Collected READ  addr=0x1199 data=0x55 |
| 105535 | hbus monitor | Collected WRITE addr=0x119a data=0x55 |
| 105565 | hbus monitor | Collected READ  addr=0x119a data=0x55 |
| 105585 | hbus monitor | Collected WRITE addr=0x119b data=0x55 |
| 105615 | hbus monitor | Collected READ  addr=0x119b data=0x55 |
| 105635 | hbus monitor | Collected WRITE addr=0x119c data=0x55 |
| 105665 | hbus monitor | Collected READ  addr=0x119c data=0x55 |
| 105685 | hbus monitor | Collected WRITE addr=0x119d data=0x55 |
| 105715 | hbus monitor | Collected READ  addr=0x119d data=0x55 |
| 105735 | hbus monitor | Collected WRITE addr=0x119e data=0x55 |
| 105765 | hbus monitor | Collected READ  addr=0x119e data=0x55 |
| 105785 | hbus monitor | Collected WRITE addr=0x119f data=0x55 |
| 105815 | hbus monitor | Collected READ  addr=0x119f data=0x55 |
| 105835 | hbus monitor | Collected WRITE addr=0x11a0 data=0x55 |
| 105865 | hbus monitor | Collected READ  addr=0x11a0 data=0x55 |
| 105885 | hbus monitor | Collected WRITE addr=0x11a1 data=0x55 |
| 105915 | hbus monitor | Collected READ  addr=0x11a1 data=0x55 |
| 105935 | hbus monitor | Collected WRITE addr=0x11a2 data=0x55 |
| 105965 | hbus monitor | Collected READ  addr=0x11a2 data=0x55 |
| 105985 | hbus monitor | Collected WRITE addr=0x11a3 data=0x55 |
| 106015 | hbus monitor | Collected READ  addr=0x11a3 data=0x55 |
| 106035 | hbus monitor | Collected WRITE addr=0x11a4 data=0x55 |
| 106065 | hbus monitor | Collected READ  addr=0x11a4 data=0x55 |
| 106085 | hbus monitor | Collected WRITE addr=0x11a5 data=0x55 |
| 106115 | hbus monitor | Collected READ  addr=0x11a5 data=0x55 |
| 106135 | hbus monitor | Collected WRITE addr=0x11a6 data=0x55 |
| 106165 | hbus monitor | Collected READ  addr=0x11a6 data=0x55 |
| 106185 | hbus monitor | Collected WRITE addr=0x11a7 data=0x55 |
| 106215 | hbus monitor | Collected READ  addr=0x11a7 data=0x55 |
| 106235 | hbus monitor | Collected WRITE addr=0x11a8 data=0x55 |
| 106265 | hbus monitor | Collected READ  addr=0x11a8 data=0x55 |
| 106285 | hbus monitor | Collected WRITE addr=0x11a9 data=0x55 |
| 106315 | hbus monitor | Collected READ  addr=0x11a9 data=0x55 |
| 106335 | hbus monitor | Collected WRITE addr=0x11aa data=0x55 |
| 106365 | hbus monitor | Collected READ  addr=0x11aa data=0x55 |
| 106385 | hbus monitor | Collected WRITE addr=0x11ab data=0x55 |
| 106415 | hbus monitor | Collected READ  addr=0x11ab data=0x55 |
| 106435 | hbus monitor | Collected WRITE addr=0x11ac data=0x55 |
| 106465 | hbus monitor | Collected READ  addr=0x11ac data=0x55 |
| 106485 | hbus monitor | Collected WRITE addr=0x11ad data=0x55 |
| 106515 | hbus monitor | Collected READ  addr=0x11ad data=0x55 |
| 106535 | hbus monitor | Collected WRITE addr=0x11ae data=0x55 |
| 106565 | hbus monitor | Collected READ  addr=0x11ae data=0x55 |
| 106585 | hbus monitor | Collected WRITE addr=0x11af data=0x55 |
| 106615 | hbus monitor | Collected READ  addr=0x11af data=0x55 |
| 106635 | hbus monitor | Collected WRITE addr=0x11b0 data=0x55 |
| 106665 | hbus monitor | Collected READ  addr=0x11b0 data=0x55 |
| 106685 | hbus monitor | Collected WRITE addr=0x11b1 data=0x55 |
| 106715 | hbus monitor | Collected READ  addr=0x11b1 data=0x55 |
| 106735 | hbus monitor | Collected WRITE addr=0x11b2 data=0x55 |
| 106765 | hbus monitor | Collected READ  addr=0x11b2 data=0x55 |
| 106785 | hbus monitor | Collected WRITE addr=0x11b3 data=0x55 |
| 106815 | hbus monitor | Collected READ  addr=0x11b3 data=0x55 |
| 106835 | hbus monitor | Collected WRITE addr=0x11b4 data=0x55 |
| 106865 | hbus monitor | Collected READ  addr=0x11b4 data=0x55 |
| 106885 | hbus monitor | Collected WRITE addr=0x11b5 data=0x55 |
| 106915 | hbus monitor | Collected READ  addr=0x11b5 data=0x55 |
| 106935 | hbus monitor | Collected WRITE addr=0x11b6 data=0x55 |
| 106965 | hbus monitor | Collected READ  addr=0x11b6 data=0x55 |
| 106985 | hbus monitor | Collected WRITE addr=0x11b7 data=0x55 |
| 107015 | hbus monitor | Collected READ  addr=0x11b7 data=0x55 |
| 107035 | hbus monitor | Collected WRITE addr=0x11b8 data=0x55 |
| 107065 | hbus monitor | Collected READ  addr=0x11b8 data=0x55 |
| 107085 | hbus monitor | Collected WRITE addr=0x11b9 data=0x55 |
| 107115 | hbus monitor | Collected READ  addr=0x11b9 data=0x55 |
| 107135 | hbus monitor | Collected WRITE addr=0x11ba data=0x55 |
| 107165 | hbus monitor | Collected READ  addr=0x11ba data=0x55 |
| 107185 | hbus monitor | Collected WRITE addr=0x11bb data=0x55 |
| 107215 | hbus monitor | Collected READ  addr=0x11bb data=0x55 |
| 107235 | hbus monitor | Collected WRITE addr=0x11bc data=0x55 |
| 107265 | hbus monitor | Collected READ  addr=0x11bc data=0x55 |
| 107285 | hbus monitor | Collected WRITE addr=0x11bd data=0x55 |
| 107315 | hbus monitor | Collected READ  addr=0x11bd data=0x55 |
| 107335 | hbus monitor | Collected WRITE addr=0x11be data=0x55 |
| 107365 | hbus monitor | Collected READ  addr=0x11be data=0x55 |
| 107385 | hbus monitor | Collected WRITE addr=0x11bf data=0x55 |
| 107415 | hbus monitor | Collected READ  addr=0x11bf data=0x55 |
| 107435 | hbus monitor | Collected WRITE addr=0x11c0 data=0x55 |
| 107465 | hbus monitor | Collected READ  addr=0x11c0 data=0x55 |
| 107485 | hbus monitor | Collected WRITE addr=0x11c1 data=0x55 |
| 107515 | hbus monitor | Collected READ  addr=0x11c1 data=0x55 |
| 107535 | hbus monitor | Collected WRITE addr=0x11c2 data=0x55 |
| 107565 | hbus monitor | Collected READ  addr=0x11c2 data=0x55 |
| 107585 | hbus monitor | Collected WRITE addr=0x11c3 data=0x55 |
| 107615 | hbus monitor | Collected READ  addr=0x11c3 data=0x55 |
| 107635 | hbus monitor | Collected WRITE addr=0x11c4 data=0x55 |
| 107665 | hbus monitor | Collected READ  addr=0x11c4 data=0x55 |
| 107685 | hbus monitor | Collected WRITE addr=0x11c5 data=0x55 |
| 107715 | hbus monitor | Collected READ  addr=0x11c5 data=0x55 |
| 107735 | hbus monitor | Collected WRITE addr=0x11c6 data=0x55 |
| 107765 | hbus monitor | Collected READ  addr=0x11c6 data=0x55 |
| 107785 | hbus monitor | Collected WRITE addr=0x11c7 data=0x55 |
| 107815 | hbus monitor | Collected READ  addr=0x11c7 data=0x55 |
| 107835 | hbus monitor | Collected WRITE addr=0x11c8 data=0x55 |
| 107865 | hbus monitor | Collected READ  addr=0x11c8 data=0x55 |
| 107885 | hbus monitor | Collected WRITE addr=0x11c9 data=0x55 |
| 107915 | hbus monitor | Collected READ  addr=0x11c9 data=0x55 |
| 107935 | hbus monitor | Collected WRITE addr=0x11ca data=0x55 |
| 107965 | hbus monitor | Collected READ  addr=0x11ca data=0x55 |
| 107985 | hbus monitor | Collected WRITE addr=0x11cb data=0x55 |
| 108015 | hbus monitor | Collected READ  addr=0x11cb data=0x55 |
| 108035 | hbus monitor | Collected WRITE addr=0x11cc data=0x55 |
| 108065 | hbus monitor | Collected READ  addr=0x11cc data=0x55 |
| 108085 | hbus monitor | Collected WRITE addr=0x11cd data=0x55 |
| 108115 | hbus monitor | Collected READ  addr=0x11cd data=0x55 |
| 108135 | hbus monitor | Collected WRITE addr=0x11ce data=0x55 |
| 108165 | hbus monitor | Collected READ  addr=0x11ce data=0x55 |
| 108185 | hbus monitor | Collected WRITE addr=0x11cf data=0x55 |
| 108215 | hbus monitor | Collected READ  addr=0x11cf data=0x55 |
| 108235 | hbus monitor | Collected WRITE addr=0x11d0 data=0x55 |
| 108265 | hbus monitor | Collected READ  addr=0x11d0 data=0x55 |
| 108285 | hbus monitor | Collected WRITE addr=0x11d1 data=0x55 |
| 108315 | hbus monitor | Collected READ  addr=0x11d1 data=0x55 |
| 108335 | hbus monitor | Collected WRITE addr=0x11d2 data=0x55 |
| 108365 | hbus monitor | Collected READ  addr=0x11d2 data=0x55 |
| 108385 | hbus monitor | Collected WRITE addr=0x11d3 data=0x55 |
| 108415 | hbus monitor | Collected READ  addr=0x11d3 data=0x55 |
| 108435 | hbus monitor | Collected WRITE addr=0x11d4 data=0x55 |
| 108465 | hbus monitor | Collected READ  addr=0x11d4 data=0x55 |
| 108485 | hbus monitor | Collected WRITE addr=0x11d5 data=0x55 |
| 108515 | hbus monitor | Collected READ  addr=0x11d5 data=0x55 |
| 108535 | hbus monitor | Collected WRITE addr=0x11d6 data=0x55 |
| 108565 | hbus monitor | Collected READ  addr=0x11d6 data=0x55 |
| 108585 | hbus monitor | Collected WRITE addr=0x11d7 data=0x55 |
| 108615 | hbus monitor | Collected READ  addr=0x11d7 data=0x55 |
| 108635 | hbus monitor | Collected WRITE addr=0x11d8 data=0x55 |
| 108665 | hbus monitor | Collected READ  addr=0x11d8 data=0x55 |
| 108685 | hbus monitor | Collected WRITE addr=0x11d9 data=0x55 |
| 108715 | hbus monitor | Collected READ  addr=0x11d9 data=0x55 |
| 108735 | hbus monitor | Collected WRITE addr=0x11da data=0x55 |
| 108765 | hbus monitor | Collected READ  addr=0x11da data=0x55 |
| 108785 | hbus monitor | Collected WRITE addr=0x11db data=0x55 |
| 108815 | hbus monitor | Collected READ  addr=0x11db data=0x55 |
| 108835 | hbus monitor | Collected WRITE addr=0x11dc data=0x55 |
| 108865 | hbus monitor | Collected READ  addr=0x11dc data=0x55 |
| 108885 | hbus monitor | Collected WRITE addr=0x11dd data=0x55 |
| 108915 | hbus monitor | Collected READ  addr=0x11dd data=0x55 |
| 108935 | hbus monitor | Collected WRITE addr=0x11de data=0x55 |
| 108965 | hbus monitor | Collected READ  addr=0x11de data=0x55 |
| 108985 | hbus monitor | Collected WRITE addr=0x11df data=0x55 |
| 109015 | hbus monitor | Collected READ  addr=0x11df data=0x55 |
| 109035 | hbus monitor | Collected WRITE addr=0x11e0 data=0x55 |
| 109065 | hbus monitor | Collected READ  addr=0x11e0 data=0x55 |
| 109085 | hbus monitor | Collected WRITE addr=0x11e1 data=0x55 |
| 109115 | hbus monitor | Collected READ  addr=0x11e1 data=0x55 |
| 109135 | hbus monitor | Collected WRITE addr=0x11e2 data=0x55 |
| 109165 | hbus monitor | Collected READ  addr=0x11e2 data=0x55 |
| 109185 | hbus monitor | Collected WRITE addr=0x11e3 data=0x55 |
| 109215 | hbus monitor | Collected READ  addr=0x11e3 data=0x55 |
| 109235 | hbus monitor | Collected WRITE addr=0x11e4 data=0x55 |
| 109265 | hbus monitor | Collected READ  addr=0x11e4 data=0x55 |
| 109285 | hbus monitor | Collected WRITE addr=0x11e5 data=0x55 |
| 109315 | hbus monitor | Collected READ  addr=0x11e5 data=0x55 |
| 109335 | hbus monitor | Collected WRITE addr=0x11e6 data=0x55 |
| 109365 | hbus monitor | Collected READ  addr=0x11e6 data=0x55 |
| 109385 | hbus monitor | Collected WRITE addr=0x11e7 data=0x55 |
| 109415 | hbus monitor | Collected READ  addr=0x11e7 data=0x55 |
| 109435 | hbus monitor | Collected WRITE addr=0x11e8 data=0x55 |
| 109465 | hbus monitor | Collected READ  addr=0x11e8 data=0x55 |
| 109485 | hbus monitor | Collected WRITE addr=0x11e9 data=0x55 |
| 109515 | hbus monitor | Collected READ  addr=0x11e9 data=0x55 |
| 109535 | hbus monitor | Collected WRITE addr=0x11ea data=0x55 |
| 109565 | hbus monitor | Collected READ  addr=0x11ea data=0x55 |
| 109585 | hbus monitor | Collected WRITE addr=0x11eb data=0x55 |
| 109615 | hbus monitor | Collected READ  addr=0x11eb data=0x55 |
| 109635 | hbus monitor | Collected WRITE addr=0x11ec data=0x55 |
| 109665 | hbus monitor | Collected READ  addr=0x11ec data=0x55 |
| 109685 | hbus monitor | Collected WRITE addr=0x11ed data=0x55 |
| 109715 | hbus monitor | Collected READ  addr=0x11ed data=0x55 |
| 109735 | hbus monitor | Collected WRITE addr=0x11ee data=0x55 |
| 109765 | hbus monitor | Collected READ  addr=0x11ee data=0x55 |
| 109785 | hbus monitor | Collected WRITE addr=0x11ef data=0x55 |
| 109815 | hbus monitor | Collected READ  addr=0x11ef data=0x55 |
| 109835 | hbus monitor | Collected WRITE addr=0x11f0 data=0x55 |
| 109865 | hbus monitor | Collected READ  addr=0x11f0 data=0x55 |
| 109885 | hbus monitor | Collected WRITE addr=0x11f1 data=0x55 |
| 109915 | hbus monitor | Collected READ  addr=0x11f1 data=0x55 |
| 109935 | hbus monitor | Collected WRITE addr=0x11f2 data=0x55 |
| 109965 | hbus monitor | Collected READ  addr=0x11f2 data=0x55 |
| 109985 | hbus monitor | Collected WRITE addr=0x11f3 data=0x55 |
| 110015 | hbus monitor | Collected READ  addr=0x11f3 data=0x55 |
| 110035 | hbus monitor | Collected WRITE addr=0x11f4 data=0x55 |
| 110065 | hbus monitor | Collected READ  addr=0x11f4 data=0x55 |
| 110085 | hbus monitor | Collected WRITE addr=0x11f5 data=0x55 |
| 110115 | hbus monitor | Collected READ  addr=0x11f5 data=0x55 |
| 110135 | hbus monitor | Collected WRITE addr=0x11f6 data=0x55 |
| 110165 | hbus monitor | Collected READ  addr=0x11f6 data=0x55 |
| 110185 | hbus monitor | Collected WRITE addr=0x11f7 data=0x55 |
| 110215 | hbus monitor | Collected READ  addr=0x11f7 data=0x55 |
| 110235 | hbus monitor | Collected WRITE addr=0x11f8 data=0x55 |
| 110265 | hbus monitor | Collected READ  addr=0x11f8 data=0x55 |
| 110285 | hbus monitor | Collected WRITE addr=0x11f9 data=0x55 |
| 110315 | hbus monitor | Collected READ  addr=0x11f9 data=0x55 |
| 110335 | hbus monitor | Collected WRITE addr=0x11fa data=0x55 |
| 110365 | hbus monitor | Collected READ  addr=0x11fa data=0x55 |
| 110385 | hbus monitor | Collected WRITE addr=0x11fb data=0x55 |
| 110415 | hbus monitor | Collected READ  addr=0x11fb data=0x55 |
| 110435 | hbus monitor | Collected WRITE addr=0x11fc data=0x55 |
| 110465 | hbus monitor | Collected READ  addr=0x11fc data=0x55 |
| 110485 | hbus monitor | Collected WRITE addr=0x11fd data=0x55 |
| 110515 | hbus monitor | Collected READ  addr=0x11fd data=0x55 |
| 110535 | hbus monitor | Collected WRITE addr=0x11fe data=0x55 |
| 110565 | hbus monitor | Collected READ  addr=0x11fe data=0x55 |
| 110585 | hbus monitor | Collected WRITE addr=0x11ff data=0x55 |
| 110615 | hbus monitor | Collected READ  addr=0x11ff data=0x55 |
| 110635 | hbus monitor | Collected WRITE addr=0x1100 data=0xaa |
| 110665 | hbus monitor | Collected READ  addr=0x1100 data=0xaa |
| 110685 | hbus monitor | Collected WRITE addr=0x1101 data=0xaa |
| 110715 | hbus monitor | Collected READ  addr=0x1101 data=0xaa |
| 110735 | hbus monitor | Collected WRITE addr=0x1102 data=0xaa |
| 110765 | hbus monitor | Collected READ  addr=0x1102 data=0xaa |
| 110785 | hbus monitor | Collected WRITE addr=0x1103 data=0xaa |
| 110815 | hbus monitor | Collected READ  addr=0x1103 data=0xaa |
| 110835 | hbus monitor | Collected WRITE addr=0x1104 data=0xaa |
| 110865 | hbus monitor | Collected READ  addr=0x1104 data=0xaa |
| 110885 | hbus monitor | Collected WRITE addr=0x1105 data=0xaa |
| 110915 | hbus monitor | Collected READ  addr=0x1105 data=0xaa |
| 110935 | hbus monitor | Collected WRITE addr=0x1106 data=0xaa |
| 110965 | hbus monitor | Collected READ  addr=0x1106 data=0xaa |
| 110985 | hbus monitor | Collected WRITE addr=0x1107 data=0xaa |
| 111015 | hbus monitor | Collected READ  addr=0x1107 data=0xaa |
| 111035 | hbus monitor | Collected WRITE addr=0x1108 data=0xaa |
| 111065 | hbus monitor | Collected READ  addr=0x1108 data=0xaa |
| 111085 | hbus monitor | Collected WRITE addr=0x1109 data=0xaa |
| 111115 | hbus monitor | Collected READ  addr=0x1109 data=0xaa |
| 111135 | hbus monitor | Collected WRITE addr=0x110a data=0xaa |
| 111165 | hbus monitor | Collected READ  addr=0x110a data=0xaa |
| 111185 | hbus monitor | Collected WRITE addr=0x110b data=0xaa |
| 111215 | hbus monitor | Collected READ  addr=0x110b data=0xaa |
| 111235 | hbus monitor | Collected WRITE addr=0x110c data=0xaa |
| 111265 | hbus monitor | Collected READ  addr=0x110c data=0xaa |
| 111285 | hbus monitor | Collected WRITE addr=0x110d data=0xaa |
| 111315 | hbus monitor | Collected READ  addr=0x110d data=0xaa |
| 111335 | hbus monitor | Collected WRITE addr=0x110e data=0xaa |
| 111365 | hbus monitor | Collected READ  addr=0x110e data=0xaa |
| 111385 | hbus monitor | Collected WRITE addr=0x110f data=0xaa |
| 111415 | hbus monitor | Collected READ  addr=0x110f data=0xaa |
| 111435 | hbus monitor | Collected WRITE addr=0x1110 data=0xaa |
| 111465 | hbus monitor | Collected READ  addr=0x1110 data=0xaa |
| 111485 | hbus monitor | Collected WRITE addr=0x1111 data=0xaa |
| 111515 | hbus monitor | Collected READ  addr=0x1111 data=0xaa |
| 111535 | hbus monitor | Collected WRITE addr=0x1112 data=0xaa |
| 111565 | hbus monitor | Collected READ  addr=0x1112 data=0xaa |
| 111585 | hbus monitor | Collected WRITE addr=0x1113 data=0xaa |
| 111615 | hbus monitor | Collected READ  addr=0x1113 data=0xaa |
| 111635 | hbus monitor | Collected WRITE addr=0x1114 data=0xaa |
| 111665 | hbus monitor | Collected READ  addr=0x1114 data=0xaa |
| 111685 | hbus monitor | Collected WRITE addr=0x1115 data=0xaa |
| 111715 | hbus monitor | Collected READ  addr=0x1115 data=0xaa |
| 111735 | hbus monitor | Collected WRITE addr=0x1116 data=0xaa |
| 111765 | hbus monitor | Collected READ  addr=0x1116 data=0xaa |
| 111785 | hbus monitor | Collected WRITE addr=0x1117 data=0xaa |
| 111815 | hbus monitor | Collected READ  addr=0x1117 data=0xaa |
| 111835 | hbus monitor | Collected WRITE addr=0x1118 data=0xaa |
| 111865 | hbus monitor | Collected READ  addr=0x1118 data=0xaa |
| 111885 | hbus monitor | Collected WRITE addr=0x1119 data=0xaa |
| 111915 | hbus monitor | Collected READ  addr=0x1119 data=0xaa |
| 111935 | hbus monitor | Collected WRITE addr=0x111a data=0xaa |
| 111965 | hbus monitor | Collected READ  addr=0x111a data=0xaa |
| 111985 | hbus monitor | Collected WRITE addr=0x111b data=0xaa |
| 112015 | hbus monitor | Collected READ  addr=0x111b data=0xaa |
| 112035 | hbus monitor | Collected WRITE addr=0x111c data=0xaa |
| 112065 | hbus monitor | Collected READ  addr=0x111c data=0xaa |
| 112085 | hbus monitor | Collected WRITE addr=0x111d data=0xaa |
| 112115 | hbus monitor | Collected READ  addr=0x111d data=0xaa |
| 112135 | hbus monitor | Collected WRITE addr=0x111e data=0xaa |
| 112165 | hbus monitor | Collected READ  addr=0x111e data=0xaa |
| 112185 | hbus monitor | Collected WRITE addr=0x111f data=0xaa |
| 112215 | hbus monitor | Collected READ  addr=0x111f data=0xaa |
| 112235 | hbus monitor | Collected WRITE addr=0x1120 data=0xaa |
| 112265 | hbus monitor | Collected READ  addr=0x1120 data=0xaa |
| 112285 | hbus monitor | Collected WRITE addr=0x1121 data=0xaa |
| 112315 | hbus monitor | Collected READ  addr=0x1121 data=0xaa |
| 112335 | hbus monitor | Collected WRITE addr=0x1122 data=0xaa |
| 112365 | hbus monitor | Collected READ  addr=0x1122 data=0xaa |
| 112385 | hbus monitor | Collected WRITE addr=0x1123 data=0xaa |
| 112415 | hbus monitor | Collected READ  addr=0x1123 data=0xaa |
| 112435 | hbus monitor | Collected WRITE addr=0x1124 data=0xaa |
| 112465 | hbus monitor | Collected READ  addr=0x1124 data=0xaa |
| 112485 | hbus monitor | Collected WRITE addr=0x1125 data=0xaa |
| 112515 | hbus monitor | Collected READ  addr=0x1125 data=0xaa |
| 112535 | hbus monitor | Collected WRITE addr=0x1126 data=0xaa |
| 112565 | hbus monitor | Collected READ  addr=0x1126 data=0xaa |
| 112585 | hbus monitor | Collected WRITE addr=0x1127 data=0xaa |
| 112615 | hbus monitor | Collected READ  addr=0x1127 data=0xaa |
| 112635 | hbus monitor | Collected WRITE addr=0x1128 data=0xaa |
| 112665 | hbus monitor | Collected READ  addr=0x1128 data=0xaa |
| 112685 | hbus monitor | Collected WRITE addr=0x1129 data=0xaa |
| 112715 | hbus monitor | Collected READ  addr=0x1129 data=0xaa |
| 112735 | hbus monitor | Collected WRITE addr=0x112a data=0xaa |
| 112765 | hbus monitor | Collected READ  addr=0x112a data=0xaa |
| 112785 | hbus monitor | Collected WRITE addr=0x112b data=0xaa |
| 112815 | hbus monitor | Collected READ  addr=0x112b data=0xaa |
| 112835 | hbus monitor | Collected WRITE addr=0x112c data=0xaa |
| 112865 | hbus monitor | Collected READ  addr=0x112c data=0xaa |
| 112885 | hbus monitor | Collected WRITE addr=0x112d data=0xaa |
| 112915 | hbus monitor | Collected READ  addr=0x112d data=0xaa |
| 112935 | hbus monitor | Collected WRITE addr=0x112e data=0xaa |
| 112965 | hbus monitor | Collected READ  addr=0x112e data=0xaa |
| 112985 | hbus monitor | Collected WRITE addr=0x112f data=0xaa |
| 113015 | hbus monitor | Collected READ  addr=0x112f data=0xaa |
| 113035 | hbus monitor | Collected WRITE addr=0x1130 data=0xaa |
| 113065 | hbus monitor | Collected READ  addr=0x1130 data=0xaa |
| 113085 | hbus monitor | Collected WRITE addr=0x1131 data=0xaa |
| 113115 | hbus monitor | Collected READ  addr=0x1131 data=0xaa |
| 113135 | hbus monitor | Collected WRITE addr=0x1132 data=0xaa |
| 113165 | hbus monitor | Collected READ  addr=0x1132 data=0xaa |
| 113185 | hbus monitor | Collected WRITE addr=0x1133 data=0xaa |
| 113215 | hbus monitor | Collected READ  addr=0x1133 data=0xaa |
| 113235 | hbus monitor | Collected WRITE addr=0x1134 data=0xaa |
| 113265 | hbus monitor | Collected READ  addr=0x1134 data=0xaa |
| 113285 | hbus monitor | Collected WRITE addr=0x1135 data=0xaa |
| 113315 | hbus monitor | Collected READ  addr=0x1135 data=0xaa |
| 113335 | hbus monitor | Collected WRITE addr=0x1136 data=0xaa |
| 113365 | hbus monitor | Collected READ  addr=0x1136 data=0xaa |
| 113385 | hbus monitor | Collected WRITE addr=0x1137 data=0xaa |
| 113415 | hbus monitor | Collected READ  addr=0x1137 data=0xaa |
| 113435 | hbus monitor | Collected WRITE addr=0x1138 data=0xaa |
| 113465 | hbus monitor | Collected READ  addr=0x1138 data=0xaa |
| 113485 | hbus monitor | Collected WRITE addr=0x1139 data=0xaa |
| 113515 | hbus monitor | Collected READ  addr=0x1139 data=0xaa |
| 113535 | hbus monitor | Collected WRITE addr=0x113a data=0xaa |
| 113565 | hbus monitor | Collected READ  addr=0x113a data=0xaa |
| 113585 | hbus monitor | Collected WRITE addr=0x113b data=0xaa |
| 113615 | hbus monitor | Collected READ  addr=0x113b data=0xaa |
| 113635 | hbus monitor | Collected WRITE addr=0x113c data=0xaa |
| 113665 | hbus monitor | Collected READ  addr=0x113c data=0xaa |
| 113685 | hbus monitor | Collected WRITE addr=0x113d data=0xaa |
| 113715 | hbus monitor | Collected READ  addr=0x113d data=0xaa |
| 113735 | hbus monitor | Collected WRITE addr=0x113e data=0xaa |
| 113765 | hbus monitor | Collected READ  addr=0x113e data=0xaa |
| 113785 | hbus monitor | Collected WRITE addr=0x113f data=0xaa |
| 113815 | hbus monitor | Collected READ  addr=0x113f data=0xaa |
| 113835 | hbus monitor | Collected WRITE addr=0x1140 data=0xaa |
| 113865 | hbus monitor | Collected READ  addr=0x1140 data=0xaa |
| 113885 | hbus monitor | Collected WRITE addr=0x1141 data=0xaa |
| 113915 | hbus monitor | Collected READ  addr=0x1141 data=0xaa |
| 113935 | hbus monitor | Collected WRITE addr=0x1142 data=0xaa |
| 113965 | hbus monitor | Collected READ  addr=0x1142 data=0xaa |
| 113985 | hbus monitor | Collected WRITE addr=0x1143 data=0xaa |
| 114015 | hbus monitor | Collected READ  addr=0x1143 data=0xaa |
| 114035 | hbus monitor | Collected WRITE addr=0x1144 data=0xaa |
| 114065 | hbus monitor | Collected READ  addr=0x1144 data=0xaa |
| 114085 | hbus monitor | Collected WRITE addr=0x1145 data=0xaa |
| 114115 | hbus monitor | Collected READ  addr=0x1145 data=0xaa |
| 114135 | hbus monitor | Collected WRITE addr=0x1146 data=0xaa |
| 114165 | hbus monitor | Collected READ  addr=0x1146 data=0xaa |
| 114185 | hbus monitor | Collected WRITE addr=0x1147 data=0xaa |
| 114215 | hbus monitor | Collected READ  addr=0x1147 data=0xaa |
| 114235 | hbus monitor | Collected WRITE addr=0x1148 data=0xaa |
| 114265 | hbus monitor | Collected READ  addr=0x1148 data=0xaa |
| 114285 | hbus monitor | Collected WRITE addr=0x1149 data=0xaa |
| 114315 | hbus monitor | Collected READ  addr=0x1149 data=0xaa |
| 114335 | hbus monitor | Collected WRITE addr=0x114a data=0xaa |
| 114365 | hbus monitor | Collected READ  addr=0x114a data=0xaa |
| 114385 | hbus monitor | Collected WRITE addr=0x114b data=0xaa |
| 114415 | hbus monitor | Collected READ  addr=0x114b data=0xaa |
| 114435 | hbus monitor | Collected WRITE addr=0x114c data=0xaa |
| 114465 | hbus monitor | Collected READ  addr=0x114c data=0xaa |
| 114485 | hbus monitor | Collected WRITE addr=0x114d data=0xaa |
| 114515 | hbus monitor | Collected READ  addr=0x114d data=0xaa |
| 114535 | hbus monitor | Collected WRITE addr=0x114e data=0xaa |
| 114565 | hbus monitor | Collected READ  addr=0x114e data=0xaa |
| 114585 | hbus monitor | Collected WRITE addr=0x114f data=0xaa |
| 114615 | hbus monitor | Collected READ  addr=0x114f data=0xaa |
| 114635 | hbus monitor | Collected WRITE addr=0x1150 data=0xaa |
| 114665 | hbus monitor | Collected READ  addr=0x1150 data=0xaa |
| 114685 | hbus monitor | Collected WRITE addr=0x1151 data=0xaa |
| 114715 | hbus monitor | Collected READ  addr=0x1151 data=0xaa |
| 114735 | hbus monitor | Collected WRITE addr=0x1152 data=0xaa |
| 114765 | hbus monitor | Collected READ  addr=0x1152 data=0xaa |
| 114785 | hbus monitor | Collected WRITE addr=0x1153 data=0xaa |
| 114815 | hbus monitor | Collected READ  addr=0x1153 data=0xaa |
| 114835 | hbus monitor | Collected WRITE addr=0x1154 data=0xaa |
| 114865 | hbus monitor | Collected READ  addr=0x1154 data=0xaa |
| 114885 | hbus monitor | Collected WRITE addr=0x1155 data=0xaa |
| 114915 | hbus monitor | Collected READ  addr=0x1155 data=0xaa |
| 114935 | hbus monitor | Collected WRITE addr=0x1156 data=0xaa |
| 114965 | hbus monitor | Collected READ  addr=0x1156 data=0xaa |
| 114985 | hbus monitor | Collected WRITE addr=0x1157 data=0xaa |
| 115015 | hbus monitor | Collected READ  addr=0x1157 data=0xaa |
| 115035 | hbus monitor | Collected WRITE addr=0x1158 data=0xaa |
| 115065 | hbus monitor | Collected READ  addr=0x1158 data=0xaa |
| 115085 | hbus monitor | Collected WRITE addr=0x1159 data=0xaa |
| 115115 | hbus monitor | Collected READ  addr=0x1159 data=0xaa |
| 115135 | hbus monitor | Collected WRITE addr=0x115a data=0xaa |
| 115165 | hbus monitor | Collected READ  addr=0x115a data=0xaa |
| 115185 | hbus monitor | Collected WRITE addr=0x115b data=0xaa |
| 115215 | hbus monitor | Collected READ  addr=0x115b data=0xaa |
| 115235 | hbus monitor | Collected WRITE addr=0x115c data=0xaa |
| 115265 | hbus monitor | Collected READ  addr=0x115c data=0xaa |
| 115285 | hbus monitor | Collected WRITE addr=0x115d data=0xaa |
| 115315 | hbus monitor | Collected READ  addr=0x115d data=0xaa |
| 115335 | hbus monitor | Collected WRITE addr=0x115e data=0xaa |
| 115365 | hbus monitor | Collected READ  addr=0x115e data=0xaa |
| 115385 | hbus monitor | Collected WRITE addr=0x115f data=0xaa |
| 115415 | hbus monitor | Collected READ  addr=0x115f data=0xaa |
| 115435 | hbus monitor | Collected WRITE addr=0x1160 data=0xaa |
| 115465 | hbus monitor | Collected READ  addr=0x1160 data=0xaa |
| 115485 | hbus monitor | Collected WRITE addr=0x1161 data=0xaa |
| 115515 | hbus monitor | Collected READ  addr=0x1161 data=0xaa |
| 115535 | hbus monitor | Collected WRITE addr=0x1162 data=0xaa |
| 115565 | hbus monitor | Collected READ  addr=0x1162 data=0xaa |
| 115585 | hbus monitor | Collected WRITE addr=0x1163 data=0xaa |
| 115615 | hbus monitor | Collected READ  addr=0x1163 data=0xaa |
| 115635 | hbus monitor | Collected WRITE addr=0x1164 data=0xaa |
| 115665 | hbus monitor | Collected READ  addr=0x1164 data=0xaa |
| 115685 | hbus monitor | Collected WRITE addr=0x1165 data=0xaa |
| 115715 | hbus monitor | Collected READ  addr=0x1165 data=0xaa |
| 115735 | hbus monitor | Collected WRITE addr=0x1166 data=0xaa |
| 115765 | hbus monitor | Collected READ  addr=0x1166 data=0xaa |
| 115785 | hbus monitor | Collected WRITE addr=0x1167 data=0xaa |
| 115815 | hbus monitor | Collected READ  addr=0x1167 data=0xaa |
| 115835 | hbus monitor | Collected WRITE addr=0x1168 data=0xaa |
| 115865 | hbus monitor | Collected READ  addr=0x1168 data=0xaa |
| 115885 | hbus monitor | Collected WRITE addr=0x1169 data=0xaa |
| 115915 | hbus monitor | Collected READ  addr=0x1169 data=0xaa |
| 115935 | hbus monitor | Collected WRITE addr=0x116a data=0xaa |
| 115965 | hbus monitor | Collected READ  addr=0x116a data=0xaa |
| 115985 | hbus monitor | Collected WRITE addr=0x116b data=0xaa |
| 116015 | hbus monitor | Collected READ  addr=0x116b data=0xaa |
| 116035 | hbus monitor | Collected WRITE addr=0x116c data=0xaa |
| 116065 | hbus monitor | Collected READ  addr=0x116c data=0xaa |
| 116085 | hbus monitor | Collected WRITE addr=0x116d data=0xaa |
| 116115 | hbus monitor | Collected READ  addr=0x116d data=0xaa |
| 116135 | hbus monitor | Collected WRITE addr=0x116e data=0xaa |
| 116165 | hbus monitor | Collected READ  addr=0x116e data=0xaa |
| 116185 | hbus monitor | Collected WRITE addr=0x116f data=0xaa |
| 116215 | hbus monitor | Collected READ  addr=0x116f data=0xaa |
| 116235 | hbus monitor | Collected WRITE addr=0x1170 data=0xaa |
| 116265 | hbus monitor | Collected READ  addr=0x1170 data=0xaa |
| 116285 | hbus monitor | Collected WRITE addr=0x1171 data=0xaa |
| 116315 | hbus monitor | Collected READ  addr=0x1171 data=0xaa |
| 116335 | hbus monitor | Collected WRITE addr=0x1172 data=0xaa |
| 116365 | hbus monitor | Collected READ  addr=0x1172 data=0xaa |
| 116385 | hbus monitor | Collected WRITE addr=0x1173 data=0xaa |
| 116415 | hbus monitor | Collected READ  addr=0x1173 data=0xaa |
| 116435 | hbus monitor | Collected WRITE addr=0x1174 data=0xaa |
| 116465 | hbus monitor | Collected READ  addr=0x1174 data=0xaa |
| 116485 | hbus monitor | Collected WRITE addr=0x1175 data=0xaa |
| 116515 | hbus monitor | Collected READ  addr=0x1175 data=0xaa |
| 116535 | hbus monitor | Collected WRITE addr=0x1176 data=0xaa |
| 116565 | hbus monitor | Collected READ  addr=0x1176 data=0xaa |
| 116585 | hbus monitor | Collected WRITE addr=0x1177 data=0xaa |
| 116615 | hbus monitor | Collected READ  addr=0x1177 data=0xaa |
| 116635 | hbus monitor | Collected WRITE addr=0x1178 data=0xaa |
| 116665 | hbus monitor | Collected READ  addr=0x1178 data=0xaa |
| 116685 | hbus monitor | Collected WRITE addr=0x1179 data=0xaa |
| 116715 | hbus monitor | Collected READ  addr=0x1179 data=0xaa |
| 116735 | hbus monitor | Collected WRITE addr=0x117a data=0xaa |
| 116765 | hbus monitor | Collected READ  addr=0x117a data=0xaa |
| 116785 | hbus monitor | Collected WRITE addr=0x117b data=0xaa |
| 116815 | hbus monitor | Collected READ  addr=0x117b data=0xaa |
| 116835 | hbus monitor | Collected WRITE addr=0x117c data=0xaa |
| 116865 | hbus monitor | Collected READ  addr=0x117c data=0xaa |
| 116885 | hbus monitor | Collected WRITE addr=0x117d data=0xaa |
| 116915 | hbus monitor | Collected READ  addr=0x117d data=0xaa |
| 116935 | hbus monitor | Collected WRITE addr=0x117e data=0xaa |
| 116965 | hbus monitor | Collected READ  addr=0x117e data=0xaa |
| 116985 | hbus monitor | Collected WRITE addr=0x117f data=0xaa |
| 117015 | hbus monitor | Collected READ  addr=0x117f data=0xaa |
| 117035 | hbus monitor | Collected WRITE addr=0x1180 data=0xaa |
| 117065 | hbus monitor | Collected READ  addr=0x1180 data=0xaa |
| 117085 | hbus monitor | Collected WRITE addr=0x1181 data=0xaa |
| 117115 | hbus monitor | Collected READ  addr=0x1181 data=0xaa |
| 117135 | hbus monitor | Collected WRITE addr=0x1182 data=0xaa |
| 117165 | hbus monitor | Collected READ  addr=0x1182 data=0xaa |
| 117185 | hbus monitor | Collected WRITE addr=0x1183 data=0xaa |
| 117215 | hbus monitor | Collected READ  addr=0x1183 data=0xaa |
| 117235 | hbus monitor | Collected WRITE addr=0x1184 data=0xaa |
| 117265 | hbus monitor | Collected READ  addr=0x1184 data=0xaa |
| 117285 | hbus monitor | Collected WRITE addr=0x1185 data=0xaa |
| 117315 | hbus monitor | Collected READ  addr=0x1185 data=0xaa |
| 117335 | hbus monitor | Collected WRITE addr=0x1186 data=0xaa |
| 117365 | hbus monitor | Collected READ  addr=0x1186 data=0xaa |
| 117385 | hbus monitor | Collected WRITE addr=0x1187 data=0xaa |
| 117415 | hbus monitor | Collected READ  addr=0x1187 data=0xaa |
| 117435 | hbus monitor | Collected WRITE addr=0x1188 data=0xaa |
| 117465 | hbus monitor | Collected READ  addr=0x1188 data=0xaa |
| 117485 | hbus monitor | Collected WRITE addr=0x1189 data=0xaa |
| 117515 | hbus monitor | Collected READ  addr=0x1189 data=0xaa |
| 117535 | hbus monitor | Collected WRITE addr=0x118a data=0xaa |
| 117565 | hbus monitor | Collected READ  addr=0x118a data=0xaa |
| 117585 | hbus monitor | Collected WRITE addr=0x118b data=0xaa |
| 117615 | hbus monitor | Collected READ  addr=0x118b data=0xaa |
| 117635 | hbus monitor | Collected WRITE addr=0x118c data=0xaa |
| 117665 | hbus monitor | Collected READ  addr=0x118c data=0xaa |
| 117685 | hbus monitor | Collected WRITE addr=0x118d data=0xaa |
| 117715 | hbus monitor | Collected READ  addr=0x118d data=0xaa |
| 117735 | hbus monitor | Collected WRITE addr=0x118e data=0xaa |
| 117765 | hbus monitor | Collected READ  addr=0x118e data=0xaa |
| 117785 | hbus monitor | Collected WRITE addr=0x118f data=0xaa |
| 117815 | hbus monitor | Collected READ  addr=0x118f data=0xaa |
| 117835 | hbus monitor | Collected WRITE addr=0x1190 data=0xaa |
| 117865 | hbus monitor | Collected READ  addr=0x1190 data=0xaa |
| 117885 | hbus monitor | Collected WRITE addr=0x1191 data=0xaa |
| 117915 | hbus monitor | Collected READ  addr=0x1191 data=0xaa |
| 117935 | hbus monitor | Collected WRITE addr=0x1192 data=0xaa |
| 117965 | hbus monitor | Collected READ  addr=0x1192 data=0xaa |
| 117985 | hbus monitor | Collected WRITE addr=0x1193 data=0xaa |
| 118015 | hbus monitor | Collected READ  addr=0x1193 data=0xaa |
| 118035 | hbus monitor | Collected WRITE addr=0x1194 data=0xaa |
| 118065 | hbus monitor | Collected READ  addr=0x1194 data=0xaa |
| 118085 | hbus monitor | Collected WRITE addr=0x1195 data=0xaa |
| 118115 | hbus monitor | Collected READ  addr=0x1195 data=0xaa |
| 118135 | hbus monitor | Collected WRITE addr=0x1196 data=0xaa |
| 118165 | hbus monitor | Collected READ  addr=0x1196 data=0xaa |
| 118185 | hbus monitor | Collected WRITE addr=0x1197 data=0xaa |
| 118215 | hbus monitor | Collected READ  addr=0x1197 data=0xaa |
| 118235 | hbus monitor | Collected WRITE addr=0x1198 data=0xaa |
| 118265 | hbus monitor | Collected READ  addr=0x1198 data=0xaa |
| 118285 | hbus monitor | Collected WRITE addr=0x1199 data=0xaa |
| 118315 | hbus monitor | Collected READ  addr=0x1199 data=0xaa |
| 118335 | hbus monitor | Collected WRITE addr=0x119a data=0xaa |
| 118365 | hbus monitor | Collected READ  addr=0x119a data=0xaa |
| 118385 | hbus monitor | Collected WRITE addr=0x119b data=0xaa |
| 118415 | hbus monitor | Collected READ  addr=0x119b data=0xaa |
| 118435 | hbus monitor | Collected WRITE addr=0x119c data=0xaa |
| 118465 | hbus monitor | Collected READ  addr=0x119c data=0xaa |
| 118485 | hbus monitor | Collected WRITE addr=0x119d data=0xaa |
| 118515 | hbus monitor | Collected READ  addr=0x119d data=0xaa |
| 118535 | hbus monitor | Collected WRITE addr=0x119e data=0xaa |
| 118565 | hbus monitor | Collected READ  addr=0x119e data=0xaa |
| 118585 | hbus monitor | Collected WRITE addr=0x119f data=0xaa |
| 118615 | hbus monitor | Collected READ  addr=0x119f data=0xaa |
| 118635 | hbus monitor | Collected WRITE addr=0x11a0 data=0xaa |
| 118665 | hbus monitor | Collected READ  addr=0x11a0 data=0xaa |
| 118685 | hbus monitor | Collected WRITE addr=0x11a1 data=0xaa |
| 118715 | hbus monitor | Collected READ  addr=0x11a1 data=0xaa |
| 118735 | hbus monitor | Collected WRITE addr=0x11a2 data=0xaa |
| 118765 | hbus monitor | Collected READ  addr=0x11a2 data=0xaa |
| 118785 | hbus monitor | Collected WRITE addr=0x11a3 data=0xaa |
| 118815 | hbus monitor | Collected READ  addr=0x11a3 data=0xaa |
| 118835 | hbus monitor | Collected WRITE addr=0x11a4 data=0xaa |
| 118865 | hbus monitor | Collected READ  addr=0x11a4 data=0xaa |
| 118885 | hbus monitor | Collected WRITE addr=0x11a5 data=0xaa |
| 118915 | hbus monitor | Collected READ  addr=0x11a5 data=0xaa |
| 118935 | hbus monitor | Collected WRITE addr=0x11a6 data=0xaa |
| 118965 | hbus monitor | Collected READ  addr=0x11a6 data=0xaa |
| 118985 | hbus monitor | Collected WRITE addr=0x11a7 data=0xaa |
| 119015 | hbus monitor | Collected READ  addr=0x11a7 data=0xaa |
| 119035 | hbus monitor | Collected WRITE addr=0x11a8 data=0xaa |
| 119065 | hbus monitor | Collected READ  addr=0x11a8 data=0xaa |
| 119085 | hbus monitor | Collected WRITE addr=0x11a9 data=0xaa |
| 119115 | hbus monitor | Collected READ  addr=0x11a9 data=0xaa |
| 119135 | hbus monitor | Collected WRITE addr=0x11aa data=0xaa |
| 119165 | hbus monitor | Collected READ  addr=0x11aa data=0xaa |
| 119185 | hbus monitor | Collected WRITE addr=0x11ab data=0xaa |
| 119215 | hbus monitor | Collected READ  addr=0x11ab data=0xaa |
| 119235 | hbus monitor | Collected WRITE addr=0x11ac data=0xaa |
| 119265 | hbus monitor | Collected READ  addr=0x11ac data=0xaa |
| 119285 | hbus monitor | Collected WRITE addr=0x11ad data=0xaa |
| 119315 | hbus monitor | Collected READ  addr=0x11ad data=0xaa |
| 119335 | hbus monitor | Collected WRITE addr=0x11ae data=0xaa |
| 119365 | hbus monitor | Collected READ  addr=0x11ae data=0xaa |
| 119385 | hbus monitor | Collected WRITE addr=0x11af data=0xaa |
| 119415 | hbus monitor | Collected READ  addr=0x11af data=0xaa |
| 119435 | hbus monitor | Collected WRITE addr=0x11b0 data=0xaa |
| 119465 | hbus monitor | Collected READ  addr=0x11b0 data=0xaa |
| 119485 | hbus monitor | Collected WRITE addr=0x11b1 data=0xaa |
| 119515 | hbus monitor | Collected READ  addr=0x11b1 data=0xaa |
| 119535 | hbus monitor | Collected WRITE addr=0x11b2 data=0xaa |
| 119565 | hbus monitor | Collected READ  addr=0x11b2 data=0xaa |
| 119585 | hbus monitor | Collected WRITE addr=0x11b3 data=0xaa |
| 119615 | hbus monitor | Collected READ  addr=0x11b3 data=0xaa |
| 119635 | hbus monitor | Collected WRITE addr=0x11b4 data=0xaa |
| 119665 | hbus monitor | Collected READ  addr=0x11b4 data=0xaa |
| 119685 | hbus monitor | Collected WRITE addr=0x11b5 data=0xaa |
| 119715 | hbus monitor | Collected READ  addr=0x11b5 data=0xaa |
| 119735 | hbus monitor | Collected WRITE addr=0x11b6 data=0xaa |
| 119765 | hbus monitor | Collected READ  addr=0x11b6 data=0xaa |
| 119785 | hbus monitor | Collected WRITE addr=0x11b7 data=0xaa |
| 119815 | hbus monitor | Collected READ  addr=0x11b7 data=0xaa |
| 119835 | hbus monitor | Collected WRITE addr=0x11b8 data=0xaa |
| 119865 | hbus monitor | Collected READ  addr=0x11b8 data=0xaa |
| 119885 | hbus monitor | Collected WRITE addr=0x11b9 data=0xaa |
| 119915 | hbus monitor | Collected READ  addr=0x11b9 data=0xaa |
| 119935 | hbus monitor | Collected WRITE addr=0x11ba data=0xaa |
| 119965 | hbus monitor | Collected READ  addr=0x11ba data=0xaa |
| 119985 | hbus monitor | Collected WRITE addr=0x11bb data=0xaa |
| 120015 | hbus monitor | Collected READ  addr=0x11bb data=0xaa |
| 120035 | hbus monitor | Collected WRITE addr=0x11bc data=0xaa |
| 120065 | hbus monitor | Collected READ  addr=0x11bc data=0xaa |
| 120085 | hbus monitor | Collected WRITE addr=0x11bd data=0xaa |
| 120115 | hbus monitor | Collected READ  addr=0x11bd data=0xaa |
| 120135 | hbus monitor | Collected WRITE addr=0x11be data=0xaa |
| 120165 | hbus monitor | Collected READ  addr=0x11be data=0xaa |
| 120185 | hbus monitor | Collected WRITE addr=0x11bf data=0xaa |
| 120215 | hbus monitor | Collected READ  addr=0x11bf data=0xaa |
| 120235 | hbus monitor | Collected WRITE addr=0x11c0 data=0xaa |
| 120265 | hbus monitor | Collected READ  addr=0x11c0 data=0xaa |
| 120285 | hbus monitor | Collected WRITE addr=0x11c1 data=0xaa |
| 120315 | hbus monitor | Collected READ  addr=0x11c1 data=0xaa |
| 120335 | hbus monitor | Collected WRITE addr=0x11c2 data=0xaa |
| 120365 | hbus monitor | Collected READ  addr=0x11c2 data=0xaa |
| 120385 | hbus monitor | Collected WRITE addr=0x11c3 data=0xaa |
| 120415 | hbus monitor | Collected READ  addr=0x11c3 data=0xaa |
| 120435 | hbus monitor | Collected WRITE addr=0x11c4 data=0xaa |
| 120465 | hbus monitor | Collected READ  addr=0x11c4 data=0xaa |
| 120485 | hbus monitor | Collected WRITE addr=0x11c5 data=0xaa |
| 120515 | hbus monitor | Collected READ  addr=0x11c5 data=0xaa |
| 120535 | hbus monitor | Collected WRITE addr=0x11c6 data=0xaa |
| 120565 | hbus monitor | Collected READ  addr=0x11c6 data=0xaa |
| 120585 | hbus monitor | Collected WRITE addr=0x11c7 data=0xaa |
| 120615 | hbus monitor | Collected READ  addr=0x11c7 data=0xaa |
| 120635 | hbus monitor | Collected WRITE addr=0x11c8 data=0xaa |
| 120665 | hbus monitor | Collected READ  addr=0x11c8 data=0xaa |
| 120685 | hbus monitor | Collected WRITE addr=0x11c9 data=0xaa |
| 120715 | hbus monitor | Collected READ  addr=0x11c9 data=0xaa |
| 120735 | hbus monitor | Collected WRITE addr=0x11ca data=0xaa |
| 120765 | hbus monitor | Collected READ  addr=0x11ca data=0xaa |
| 120785 | hbus monitor | Collected WRITE addr=0x11cb data=0xaa |
| 120815 | hbus monitor | Collected READ  addr=0x11cb data=0xaa |
| 120835 | hbus monitor | Collected WRITE addr=0x11cc data=0xaa |
| 120865 | hbus monitor | Collected READ  addr=0x11cc data=0xaa |
| 120885 | hbus monitor | Collected WRITE addr=0x11cd data=0xaa |
| 120915 | hbus monitor | Collected READ  addr=0x11cd data=0xaa |
| 120935 | hbus monitor | Collected WRITE addr=0x11ce data=0xaa |
| 120965 | hbus monitor | Collected READ  addr=0x11ce data=0xaa |
| 120985 | hbus monitor | Collected WRITE addr=0x11cf data=0xaa |
| 121015 | hbus monitor | Collected READ  addr=0x11cf data=0xaa |
| 121035 | hbus monitor | Collected WRITE addr=0x11d0 data=0xaa |
| 121065 | hbus monitor | Collected READ  addr=0x11d0 data=0xaa |
| 121085 | hbus monitor | Collected WRITE addr=0x11d1 data=0xaa |
| 121115 | hbus monitor | Collected READ  addr=0x11d1 data=0xaa |
| 121135 | hbus monitor | Collected WRITE addr=0x11d2 data=0xaa |
| 121165 | hbus monitor | Collected READ  addr=0x11d2 data=0xaa |
| 121185 | hbus monitor | Collected WRITE addr=0x11d3 data=0xaa |
| 121215 | hbus monitor | Collected READ  addr=0x11d3 data=0xaa |
| 121235 | hbus monitor | Collected WRITE addr=0x11d4 data=0xaa |
| 121265 | hbus monitor | Collected READ  addr=0x11d4 data=0xaa |
| 121285 | hbus monitor | Collected WRITE addr=0x11d5 data=0xaa |
| 121315 | hbus monitor | Collected READ  addr=0x11d5 data=0xaa |
| 121335 | hbus monitor | Collected WRITE addr=0x11d6 data=0xaa |
| 121365 | hbus monitor | Collected READ  addr=0x11d6 data=0xaa |
| 121385 | hbus monitor | Collected WRITE addr=0x11d7 data=0xaa |
| 121415 | hbus monitor | Collected READ  addr=0x11d7 data=0xaa |
| 121435 | hbus monitor | Collected WRITE addr=0x11d8 data=0xaa |
| 121465 | hbus monitor | Collected READ  addr=0x11d8 data=0xaa |
| 121485 | hbus monitor | Collected WRITE addr=0x11d9 data=0xaa |
| 121515 | hbus monitor | Collected READ  addr=0x11d9 data=0xaa |
| 121535 | hbus monitor | Collected WRITE addr=0x11da data=0xaa |
| 121565 | hbus monitor | Collected READ  addr=0x11da data=0xaa |
| 121585 | hbus monitor | Collected WRITE addr=0x11db data=0xaa |
| 121615 | hbus monitor | Collected READ  addr=0x11db data=0xaa |
| 121635 | hbus monitor | Collected WRITE addr=0x11dc data=0xaa |
| 121665 | hbus monitor | Collected READ  addr=0x11dc data=0xaa |
| 121685 | hbus monitor | Collected WRITE addr=0x11dd data=0xaa |
| 121715 | hbus monitor | Collected READ  addr=0x11dd data=0xaa |
| 121735 | hbus monitor | Collected WRITE addr=0x11de data=0xaa |
| 121765 | hbus monitor | Collected READ  addr=0x11de data=0xaa |
| 121785 | hbus monitor | Collected WRITE addr=0x11df data=0xaa |
| 121815 | hbus monitor | Collected READ  addr=0x11df data=0xaa |
| 121835 | hbus monitor | Collected WRITE addr=0x11e0 data=0xaa |
| 121865 | hbus monitor | Collected READ  addr=0x11e0 data=0xaa |
| 121885 | hbus monitor | Collected WRITE addr=0x11e1 data=0xaa |
| 121915 | hbus monitor | Collected READ  addr=0x11e1 data=0xaa |
| 121935 | hbus monitor | Collected WRITE addr=0x11e2 data=0xaa |
| 121965 | hbus monitor | Collected READ  addr=0x11e2 data=0xaa |
| 121985 | hbus monitor | Collected WRITE addr=0x11e3 data=0xaa |
| 122015 | hbus monitor | Collected READ  addr=0x11e3 data=0xaa |
| 122035 | hbus monitor | Collected WRITE addr=0x11e4 data=0xaa |
| 122065 | hbus monitor | Collected READ  addr=0x11e4 data=0xaa |
| 122085 | hbus monitor | Collected WRITE addr=0x11e5 data=0xaa |
| 122115 | hbus monitor | Collected READ  addr=0x11e5 data=0xaa |
| 122135 | hbus monitor | Collected WRITE addr=0x11e6 data=0xaa |
| 122165 | hbus monitor | Collected READ  addr=0x11e6 data=0xaa |
| 122185 | hbus monitor | Collected WRITE addr=0x11e7 data=0xaa |
| 122215 | hbus monitor | Collected READ  addr=0x11e7 data=0xaa |
| 122235 | hbus monitor | Collected WRITE addr=0x11e8 data=0xaa |
| 122265 | hbus monitor | Collected READ  addr=0x11e8 data=0xaa |
| 122285 | hbus monitor | Collected WRITE addr=0x11e9 data=0xaa |
| 122315 | hbus monitor | Collected READ  addr=0x11e9 data=0xaa |
| 122335 | hbus monitor | Collected WRITE addr=0x11ea data=0xaa |
| 122365 | hbus monitor | Collected READ  addr=0x11ea data=0xaa |
| 122385 | hbus monitor | Collected WRITE addr=0x11eb data=0xaa |
| 122415 | hbus monitor | Collected READ  addr=0x11eb data=0xaa |
| 122435 | hbus monitor | Collected WRITE addr=0x11ec data=0xaa |
| 122465 | hbus monitor | Collected READ  addr=0x11ec data=0xaa |
| 122485 | hbus monitor | Collected WRITE addr=0x11ed data=0xaa |
| 122515 | hbus monitor | Collected READ  addr=0x11ed data=0xaa |
| 122535 | hbus monitor | Collected WRITE addr=0x11ee data=0xaa |
| 122565 | hbus monitor | Collected READ  addr=0x11ee data=0xaa |
| 122585 | hbus monitor | Collected WRITE addr=0x11ef data=0xaa |
| 122615 | hbus monitor | Collected READ  addr=0x11ef data=0xaa |
| 122635 | hbus monitor | Collected WRITE addr=0x11f0 data=0xaa |
| 122665 | hbus monitor | Collected READ  addr=0x11f0 data=0xaa |
| 122685 | hbus monitor | Collected WRITE addr=0x11f1 data=0xaa |
| 122715 | hbus monitor | Collected READ  addr=0x11f1 data=0xaa |
| 122735 | hbus monitor | Collected WRITE addr=0x11f2 data=0xaa |
| 122765 | hbus monitor | Collected READ  addr=0x11f2 data=0xaa |
| 122785 | hbus monitor | Collected WRITE addr=0x11f3 data=0xaa |
| 122815 | hbus monitor | Collected READ  addr=0x11f3 data=0xaa |
| 122835 | hbus monitor | Collected WRITE addr=0x11f4 data=0xaa |
| 122865 | hbus monitor | Collected READ  addr=0x11f4 data=0xaa |
| 122885 | hbus monitor | Collected WRITE addr=0x11f5 data=0xaa |
| 122915 | hbus monitor | Collected READ  addr=0x11f5 data=0xaa |
| 122935 | hbus monitor | Collected WRITE addr=0x11f6 data=0xaa |
| 122965 | hbus monitor | Collected READ  addr=0x11f6 data=0xaa |
| 122985 | hbus monitor | Collected WRITE addr=0x11f7 data=0xaa |
| 123015 | hbus monitor | Collected READ  addr=0x11f7 data=0xaa |
| 123035 | hbus monitor | Collected WRITE addr=0x11f8 data=0xaa |
| 123065 | hbus monitor | Collected READ  addr=0x11f8 data=0xaa |
| 123085 | hbus monitor | Collected WRITE addr=0x11f9 data=0xaa |
| 123115 | hbus monitor | Collected READ  addr=0x11f9 data=0xaa |
| 123135 | hbus monitor | Collected WRITE addr=0x11fa data=0xaa |
| 123165 | hbus monitor | Collected READ  addr=0x11fa data=0xaa |
| 123185 | hbus monitor | Collected WRITE addr=0x11fb data=0xaa |
| 123215 | hbus monitor | Collected READ  addr=0x11fb data=0xaa |
| 123235 | hbus monitor | Collected WRITE addr=0x11fc data=0xaa |
| 123265 | hbus monitor | Collected READ  addr=0x11fc data=0xaa |
| 123285 | hbus monitor | Collected WRITE addr=0x11fd data=0xaa |
| 123315 | hbus monitor | Collected READ  addr=0x11fd data=0xaa |
| 123335 | hbus monitor | Collected WRITE addr=0x11fe data=0xaa |
| 123365 | hbus monitor | Collected READ  addr=0x11fe data=0xaa |
| 123385 | hbus monitor | Collected WRITE addr=0x11ff data=0xaa |
| 123415 | hbus monitor | Collected READ  addr=0x11ff data=0xaa |
| 123435 | hbus monitor | Collected WRITE addr=0x1100 data=0x21 |
| 123465 | hbus monitor | Collected READ  addr=0x1100 data=0x21 |
| 123485 | hbus monitor | Collected WRITE addr=0x1101 data=0x87 |
| 123515 | hbus monitor | Collected READ  addr=0x1101 data=0x87 |
| 123535 | hbus monitor | Collected WRITE addr=0x1102 data=0x2e |
| 123565 | hbus monitor | Collected READ  addr=0x1102 data=0x2e |
| 123585 | hbus monitor | Collected WRITE addr=0x1103 data=0xba |
| 123615 | hbus monitor | Collected READ  addr=0x1103 data=0xba |
| 123635 | hbus monitor | Collected WRITE addr=0x1104 data=0x2d |
| 123665 | hbus monitor | Collected READ  addr=0x1104 data=0x2d |
| 123685 | hbus monitor | Collected WRITE addr=0x1105 data=0x95 |
| 123715 | hbus monitor | Collected READ  addr=0x1105 data=0x95 |
| 123735 | hbus monitor | Collected WRITE addr=0x1106 data=0xcc |
| 123765 | hbus monitor | Collected READ  addr=0x1106 data=0xcc |
| 123785 | hbus monitor | Collected WRITE addr=0x1107 data=0x93 |
| 123815 | hbus monitor | Collected READ  addr=0x1107 data=0x93 |
| 123835 | hbus monitor | Collected WRITE addr=0x1108 data=0x86 |
| 123865 | hbus monitor | Collected READ  addr=0x1108 data=0x86 |
| 123885 | hbus monitor | Collected WRITE addr=0x1109 data=0x58 |
| 123915 | hbus monitor | Collected READ  addr=0x1109 data=0x58 |
| 123935 | hbus monitor | Collected WRITE addr=0x110a data=0x54 |
| 123965 | hbus monitor | Collected READ  addr=0x110a data=0x54 |
| 123985 | hbus monitor | Collected WRITE addr=0x110b data=0x05 |
| 124015 | hbus monitor | Collected READ  addr=0x110b data=0x05 |
| 124035 | hbus monitor | Collected WRITE addr=0x110c data=0x17 |
| 124065 | hbus monitor | Collected READ  addr=0x110c data=0x17 |
| 124085 | hbus monitor | Collected WRITE addr=0x110d data=0xb5 |
| 124115 | hbus monitor | Collected READ  addr=0x110d data=0xb5 |
| 124135 | hbus monitor | Collected WRITE addr=0x110e data=0xd1 |
| 124165 | hbus monitor | Collected READ  addr=0x110e data=0xd1 |
| 124185 | hbus monitor | Collected WRITE addr=0x110f data=0x70 |
| 124215 | hbus monitor | Collected READ  addr=0x110f data=0x70 |
| 124235 | hbus monitor | Collected WRITE addr=0x1110 data=0xed |
| 124265 | hbus monitor | Collected READ  addr=0x1110 data=0xed |
| 124285 | hbus monitor | Collected WRITE addr=0x1111 data=0x32 |
| 124315 | hbus monitor | Collected READ  addr=0x1111 data=0x32 |
| 124335 | hbus monitor | Collected WRITE addr=0x1112 data=0x53 |
| 124365 | hbus monitor | Collected READ  addr=0x1112 data=0x53 |
| 124385 | hbus monitor | Collected WRITE addr=0x1113 data=0x52 |
| 124415 | hbus monitor | Collected READ  addr=0x1113 data=0x52 |
| 124435 | hbus monitor | Collected WRITE addr=0x1114 data=0xe5 |
| 124465 | hbus monitor | Collected READ  addr=0x1114 data=0xe5 |
| 124485 | hbus monitor | Collected WRITE addr=0x1115 data=0x33 |
| 124515 | hbus monitor | Collected READ  addr=0x1115 data=0x33 |
| 124535 | hbus monitor | Collected WRITE addr=0x1116 data=0xdf |
| 124565 | hbus monitor | Collected READ  addr=0x1116 data=0xdf |
| 124585 | hbus monitor | Collected WRITE addr=0x1117 data=0xe8 |
| 124615 | hbus monitor | Collected READ  addr=0x1117 data=0xe8 |
| 124635 | hbus monitor | Collected WRITE addr=0x1118 data=0x5e |
| 124665 | hbus monitor | Collected READ  addr=0x1118 data=0x5e |
| 124685 | hbus monitor | Collected WRITE addr=0x1119 data=0xa7 |
| 124715 | hbus monitor | Collected READ  addr=0x1119 data=0xa7 |
| 124735 | hbus monitor | Collected WRITE addr=0x111a data=0xa3 |
| 124765 | hbus monitor | Collected READ  addr=0x111a data=0xa3 |
| 124785 | hbus monitor | Collected WRITE addr=0x111b data=0xb3 |
| 124815 | hbus monitor | Collected READ  addr=0x111b data=0xb3 |
| 124835 | hbus monitor | Collected WRITE addr=0x111c data=0xa4 |
| 124865 | hbus monitor | Collected READ  addr=0x111c data=0xa4 |
| 124885 | hbus monitor | Collected WRITE addr=0x111d data=0xe1 |
| 124915 | hbus monitor | Collected READ  addr=0x111d data=0xe1 |
| 124935 | hbus monitor | Collected WRITE addr=0x111e data=0xbb |
| 124965 | hbus monitor | Collected READ  addr=0x111e data=0xbb |
| 124985 | hbus monitor | Collected WRITE addr=0x111f data=0x61 |
| 125015 | hbus monitor | Collected READ  addr=0x111f data=0x61 |
| 125035 | hbus monitor | Collected WRITE addr=0x1120 data=0xaf |
| 125065 | hbus monitor | Collected READ  addr=0x1120 data=0xaf |
| 125085 | hbus monitor | Collected WRITE addr=0x1121 data=0x90 |
| 125115 | hbus monitor | Collected READ  addr=0x1121 data=0x90 |
| 125135 | hbus monitor | Collected WRITE addr=0x1122 data=0x32 |
| 125165 | hbus monitor | Collected READ  addr=0x1122 data=0x32 |
| 125185 | hbus monitor | Collected WRITE addr=0x1123 data=0xd7 |
| 125215 | hbus monitor | Collected READ  addr=0x1123 data=0xd7 |
| 125235 | hbus monitor | Collected WRITE addr=0x1124 data=0x9f |
| 125265 | hbus monitor | Collected READ  addr=0x1124 data=0x9f |
| 125285 | hbus monitor | Collected WRITE addr=0x1125 data=0x8d |
| 125315 | hbus monitor | Collected READ  addr=0x1125 data=0x8d |
| 125335 | hbus monitor | Collected WRITE addr=0x1126 data=0x6d |
| 125365 | hbus monitor | Collected READ  addr=0x1126 data=0x6d |
| 125385 | hbus monitor | Collected WRITE addr=0x1127 data=0xd7 |
| 125415 | hbus monitor | Collected READ  addr=0x1127 data=0xd7 |
| 125435 | hbus monitor | Collected WRITE addr=0x1128 data=0x7e |
| 125465 | hbus monitor | Collected READ  addr=0x1128 data=0x7e |
| 125485 | hbus monitor | Collected WRITE addr=0x1129 data=0xae |
| 125515 | hbus monitor | Collected READ  addr=0x1129 data=0xae |
| 125535 | hbus monitor | Collected WRITE addr=0x112a data=0x80 |
| 125565 | hbus monitor | Collected READ  addr=0x112a data=0x80 |
| 125585 | hbus monitor | Collected WRITE addr=0x112b data=0x38 |
| 125615 | hbus monitor | Collected READ  addr=0x112b data=0x38 |
| 125635 | hbus monitor | Collected WRITE addr=0x112c data=0x7a |
| 125665 | hbus monitor | Collected READ  addr=0x112c data=0x7a |
| 125685 | hbus monitor | Collected WRITE addr=0x112d data=0xdc |
| 125715 | hbus monitor | Collected READ  addr=0x112d data=0xdc |
| 125735 | hbus monitor | Collected WRITE addr=0x112e data=0xd9 |
| 125765 | hbus monitor | Collected READ  addr=0x112e data=0xd9 |
| 125785 | hbus monitor | Collected WRITE addr=0x112f data=0xd1 |
| 125815 | hbus monitor | Collected READ  addr=0x112f data=0xd1 |
| 125835 | hbus monitor | Collected WRITE addr=0x1130 data=0x94 |
| 125865 | hbus monitor | Collected READ  addr=0x1130 data=0x94 |
| 125885 | hbus monitor | Collected WRITE addr=0x1131 data=0x0c |
| 125915 | hbus monitor | Collected READ  addr=0x1131 data=0x0c |
| 125935 | hbus monitor | Collected WRITE addr=0x1132 data=0x98 |
| 125965 | hbus monitor | Collected READ  addr=0x1132 data=0x98 |
| 125985 | hbus monitor | Collected WRITE addr=0x1133 data=0xe0 |
| 126015 | hbus monitor | Collected READ  addr=0x1133 data=0xe0 |
| 126035 | hbus monitor | Collected WRITE addr=0x1134 data=0xd9 |
| 126065 | hbus monitor | Collected READ  addr=0x1134 data=0xd9 |
| 126085 | hbus monitor | Collected WRITE addr=0x1135 data=0x2b |
| 126115 | hbus monitor | Collected READ  addr=0x1135 data=0x2b |
| 126135 | hbus monitor | Collected WRITE addr=0x1136 data=0x3e |
| 126165 | hbus monitor | Collected READ  addr=0x1136 data=0x3e |
| 126185 | hbus monitor | Collected WRITE addr=0x1137 data=0xee |
| 126215 | hbus monitor | Collected READ  addr=0x1137 data=0xee |
| 126235 | hbus monitor | Collected WRITE addr=0x1138 data=0x91 |
| 126265 | hbus monitor | Collected READ  addr=0x1138 data=0x91 |
| 126285 | hbus monitor | Collected WRITE addr=0x1139 data=0xd2 |
| 126315 | hbus monitor | Collected READ  addr=0x1139 data=0xd2 |
| 126335 | hbus monitor | Collected WRITE addr=0x113a data=0x58 |
| 126365 | hbus monitor | Collected READ  addr=0x113a data=0x58 |
| 126385 | hbus monitor | Collected WRITE addr=0x113b data=0x13 |
| 126415 | hbus monitor | Collected READ  addr=0x113b data=0x13 |
| 126435 | hbus monitor | Collected WRITE addr=0x113c data=0x23 |
| 126465 | hbus monitor | Collected READ  addr=0x113c data=0x23 |
| 126485 | hbus monitor | Collected WRITE addr=0x113d data=0xdd |
| 126515 | hbus monitor | Collected READ  addr=0x113d data=0xdd |
| 126535 | hbus monitor | Collected WRITE addr=0x113e data=0xec |
| 126565 | hbus monitor | Collected READ  addr=0x113e data=0xec |
| 126585 | hbus monitor | Collected WRITE addr=0x113f data=0x0e |
| 126615 | hbus monitor | Collected READ  addr=0x113f data=0x0e |
| 126635 | hbus monitor | Collected WRITE addr=0x1140 data=0x77 |
| 126665 | hbus monitor | Collected READ  addr=0x1140 data=0x77 |
| 126685 | hbus monitor | Collected WRITE addr=0x1141 data=0x71 |
| 126715 | hbus monitor | Collected READ  addr=0x1141 data=0x71 |
| 126735 | hbus monitor | Collected WRITE addr=0x1142 data=0xf6 |
| 126765 | hbus monitor | Collected READ  addr=0x1142 data=0xf6 |
| 126785 | hbus monitor | Collected WRITE addr=0x1143 data=0xe6 |
| 126815 | hbus monitor | Collected READ  addr=0x1143 data=0xe6 |
| 126835 | hbus monitor | Collected WRITE addr=0x1144 data=0x62 |
| 126865 | hbus monitor | Collected READ  addr=0x1144 data=0x62 |
| 126885 | hbus monitor | Collected WRITE addr=0x1145 data=0x65 |
| 126915 | hbus monitor | Collected READ  addr=0x1145 data=0x65 |
| 126935 | hbus monitor | Collected WRITE addr=0x1146 data=0x9f |
| 126965 | hbus monitor | Collected READ  addr=0x1146 data=0x9f |
| 126985 | hbus monitor | Collected WRITE addr=0x1147 data=0xc0 |
| 127015 | hbus monitor | Collected READ  addr=0x1147 data=0xc0 |
| 127035 | hbus monitor | Collected WRITE addr=0x1148 data=0x2b |
| 127065 | hbus monitor | Collected READ  addr=0x1148 data=0x2b |
| 127085 | hbus monitor | Collected WRITE addr=0x1149 data=0x64 |
| 127115 | hbus monitor | Collected READ  addr=0x1149 data=0x64 |
| 127135 | hbus monitor | Collected WRITE addr=0x114a data=0x71 |
| 127165 | hbus monitor | Collected READ  addr=0x114a data=0x71 |
| 127185 | hbus monitor | Collected WRITE addr=0x114b data=0x84 |
| 127215 | hbus monitor | Collected READ  addr=0x114b data=0x84 |
| 127235 | hbus monitor | Collected WRITE addr=0x114c data=0x62 |
| 127265 | hbus monitor | Collected READ  addr=0x114c data=0x62 |
| 127285 | hbus monitor | Collected WRITE addr=0x114d data=0xf5 |
| 127315 | hbus monitor | Collected READ  addr=0x114d data=0xf5 |
| 127335 | hbus monitor | Collected WRITE addr=0x114e data=0x4a |
| 127365 | hbus monitor | Collected READ  addr=0x114e data=0x4a |
| 127385 | hbus monitor | Collected WRITE addr=0x114f data=0xf6 |
| 127415 | hbus monitor | Collected READ  addr=0x114f data=0xf6 |
| 127435 | hbus monitor | Collected WRITE addr=0x1150 data=0xa3 |
| 127465 | hbus monitor | Collected READ  addr=0x1150 data=0xa3 |
| 127485 | hbus monitor | Collected WRITE addr=0x1151 data=0xdc |
| 127515 | hbus monitor | Collected READ  addr=0x1151 data=0xdc |
| 127535 | hbus monitor | Collected WRITE addr=0x1152 data=0xb8 |
| 127565 | hbus monitor | Collected READ  addr=0x1152 data=0xb8 |
| 127585 | hbus monitor | Collected WRITE addr=0x1153 data=0x71 |
| 127615 | hbus monitor | Collected READ  addr=0x1153 data=0x71 |
| 127635 | hbus monitor | Collected WRITE addr=0x1154 data=0x71 |
| 127665 | hbus monitor | Collected READ  addr=0x1154 data=0x71 |
| 127685 | hbus monitor | Collected WRITE addr=0x1155 data=0x79 |
| 127715 | hbus monitor | Collected READ  addr=0x1155 data=0x79 |
| 127735 | hbus monitor | Collected WRITE addr=0x1156 data=0xc4 |
| 127765 | hbus monitor | Collected READ  addr=0x1156 data=0xc4 |
| 127785 | hbus monitor | Collected WRITE addr=0x1157 data=0xfc |
| 127815 | hbus monitor | Collected READ  addr=0x1157 data=0xfc |
| 127835 | hbus monitor | Collected WRITE addr=0x1158 data=0xda |
| 127865 | hbus monitor | Collected READ  addr=0x1158 data=0xda |
| 127885 | hbus monitor | Collected WRITE addr=0x1159 data=0x87 |
| 127915 | hbus monitor | Collected READ  addr=0x1159 data=0x87 |
| 127935 | hbus monitor | Collected WRITE addr=0x115a data=0xe6 |
| 127965 | hbus monitor | Collected READ  addr=0x115a data=0xe6 |
| 127985 | hbus monitor | Collected WRITE addr=0x115b data=0x48 |
| 128015 | hbus monitor | Collected READ  addr=0x115b data=0x48 |
| 128035 | hbus monitor | Collected WRITE addr=0x115c data=0xcb |
| 128065 | hbus monitor | Collected READ  addr=0x115c data=0xcb |
| 128085 | hbus monitor | Collected WRITE addr=0x115d data=0xa0 |
| 128115 | hbus monitor | Collected READ  addr=0x115d data=0xa0 |
| 128135 | hbus monitor | Collected WRITE addr=0x115e data=0x6b |
| 128165 | hbus monitor | Collected READ  addr=0x115e data=0x6b |
| 128185 | hbus monitor | Collected WRITE addr=0x115f data=0x52 |
| 128215 | hbus monitor | Collected READ  addr=0x115f data=0x52 |
| 128235 | hbus monitor | Collected WRITE addr=0x1160 data=0xcb |
| 128265 | hbus monitor | Collected READ  addr=0x1160 data=0xcb |
| 128285 | hbus monitor | Collected WRITE addr=0x1161 data=0xf7 |
| 128315 | hbus monitor | Collected READ  addr=0x1161 data=0xf7 |
| 128335 | hbus monitor | Collected WRITE addr=0x1162 data=0xbe |
| 128365 | hbus monitor | Collected READ  addr=0x1162 data=0xbe |
| 128385 | hbus monitor | Collected WRITE addr=0x1163 data=0x9b |
| 128415 | hbus monitor | Collected READ  addr=0x1163 data=0x9b |
| 128435 | hbus monitor | Collected WRITE addr=0x1164 data=0x66 |
| 128465 | hbus monitor | Collected READ  addr=0x1164 data=0x66 |
| 128485 | hbus monitor | Collected WRITE addr=0x1165 data=0xc4 |
| 128515 | hbus monitor | Collected READ  addr=0x1165 data=0xc4 |
| 128535 | hbus monitor | Collected WRITE addr=0x1166 data=0x0c |
| 128565 | hbus monitor | Collected READ  addr=0x1166 data=0x0c |
| 128585 | hbus monitor | Collected WRITE addr=0x1167 data=0x47 |
| 128615 | hbus monitor | Collected READ  addr=0x1167 data=0x47 |
| 128635 | hbus monitor | Collected WRITE addr=0x1168 data=0x3a |
| 128665 | hbus monitor | Collected READ  addr=0x1168 data=0x3a |
| 128685 | hbus monitor | Collected WRITE addr=0x1169 data=0x1e |
| 128715 | hbus monitor | Collected READ  addr=0x1169 data=0x1e |
| 128735 | hbus monitor | Collected WRITE addr=0x116a data=0x42 |
| 128765 | hbus monitor | Collected READ  addr=0x116a data=0x42 |
| 128785 | hbus monitor | Collected WRITE addr=0x116b data=0xcd |
| 128815 | hbus monitor | Collected READ  addr=0x116b data=0xcd |
| 128835 | hbus monitor | Collected WRITE addr=0x116c data=0x08 |
| 128865 | hbus monitor | Collected READ  addr=0x116c data=0x08 |
| 128885 | hbus monitor | Collected WRITE addr=0x116d data=0x28 |
| 128915 | hbus monitor | Collected READ  addr=0x116d data=0x28 |
| 128935 | hbus monitor | Collected WRITE addr=0x116e data=0xde |
| 128965 | hbus monitor | Collected READ  addr=0x116e data=0xde |
| 128985 | hbus monitor | Collected WRITE addr=0x116f data=0xba |
| 129015 | hbus monitor | Collected READ  addr=0x116f data=0xba |
| 129035 | hbus monitor | Collected WRITE addr=0x1170 data=0x67 |
| 129065 | hbus monitor | Collected READ  addr=0x1170 data=0x67 |
| 129085 | hbus monitor | Collected WRITE addr=0x1171 data=0x1a |
| 129115 | hbus monitor | Collected READ  addr=0x1171 data=0x1a |
| 129135 | hbus monitor | Collected WRITE addr=0x1172 data=0x24 |
| 129165 | hbus monitor | Collected READ  addr=0x1172 data=0x24 |
| 129185 | hbus monitor | Collected WRITE addr=0x1173 data=0x8e |
| 129215 | hbus monitor | Collected READ  addr=0x1173 data=0x8e |
| 129235 | hbus monitor | Collected WRITE addr=0x1174 data=0x21 |
| 129265 | hbus monitor | Collected READ  addr=0x1174 data=0x21 |
| 129285 | hbus monitor | Collected WRITE addr=0x1175 data=0xd8 |
| 129315 | hbus monitor | Collected READ  addr=0x1175 data=0xd8 |
| 129335 | hbus monitor | Collected WRITE addr=0x1176 data=0xea |
| 129365 | hbus monitor | Collected READ  addr=0x1176 data=0xea |
| 129385 | hbus monitor | Collected WRITE addr=0x1177 data=0x1e |
| 129415 | hbus monitor | Collected READ  addr=0x1177 data=0x1e |
| 129435 | hbus monitor | Collected WRITE addr=0x1178 data=0xf0 |
| 129465 | hbus monitor | Collected READ  addr=0x1178 data=0xf0 |
| 129485 | hbus monitor | Collected WRITE addr=0x1179 data=0x59 |
| 129515 | hbus monitor | Collected READ  addr=0x1179 data=0x59 |
| 129535 | hbus monitor | Collected WRITE addr=0x117a data=0xf2 |
| 129565 | hbus monitor | Collected READ  addr=0x117a data=0xf2 |
| 129585 | hbus monitor | Collected WRITE addr=0x117b data=0x40 |
| 129615 | hbus monitor | Collected READ  addr=0x117b data=0x40 |
| 129635 | hbus monitor | Collected WRITE addr=0x117c data=0x35 |
| 129665 | hbus monitor | Collected READ  addr=0x117c data=0x35 |
| 129685 | hbus monitor | Collected WRITE addr=0x117d data=0x84 |
| 129715 | hbus monitor | Collected READ  addr=0x117d data=0x84 |
| 129735 | hbus monitor | Collected WRITE addr=0x117e data=0x23 |
| 129765 | hbus monitor | Collected READ  addr=0x117e data=0x23 |
| 129785 | hbus monitor | Collected WRITE addr=0x117f data=0x02 |
| 129815 | hbus monitor | Collected READ  addr=0x117f data=0x02 |
| 129835 | hbus monitor | Collected WRITE addr=0x1180 data=0x68 |
| 129865 | hbus monitor | Collected READ  addr=0x1180 data=0x68 |
| 129885 | hbus monitor | Collected WRITE addr=0x1181 data=0x9a |
| 129915 | hbus monitor | Collected READ  addr=0x1181 data=0x9a |
| 129935 | hbus monitor | Collected WRITE addr=0x1182 data=0x8e |
| 129965 | hbus monitor | Collected READ  addr=0x1182 data=0x8e |
| 129985 | hbus monitor | Collected WRITE addr=0x1183 data=0xb7 |
| 130015 | hbus monitor | Collected READ  addr=0x1183 data=0xb7 |
| 130035 | hbus monitor | Collected WRITE addr=0x1184 data=0x1a |
| 130065 | hbus monitor | Collected READ  addr=0x1184 data=0x1a |
| 130085 | hbus monitor | Collected WRITE addr=0x1185 data=0xce |
| 130115 | hbus monitor | Collected READ  addr=0x1185 data=0xce |
| 130135 | hbus monitor | Collected WRITE addr=0x1186 data=0x7e |
| 130165 | hbus monitor | Collected READ  addr=0x1186 data=0x7e |
| 130185 | hbus monitor | Collected WRITE addr=0x1187 data=0x3e |
| 130215 | hbus monitor | Collected READ  addr=0x1187 data=0x3e |
| 130235 | hbus monitor | Collected WRITE addr=0x1188 data=0x9c |
| 130265 | hbus monitor | Collected READ  addr=0x1188 data=0x9c |
| 130285 | hbus monitor | Collected WRITE addr=0x1189 data=0xd2 |
| 130315 | hbus monitor | Collected READ  addr=0x1189 data=0xd2 |
| 130335 | hbus monitor | Collected WRITE addr=0x118a data=0xe1 |
| 130365 | hbus monitor | Collected READ  addr=0x118a data=0xe1 |
| 130385 | hbus monitor | Collected WRITE addr=0x118b data=0x8b |
| 130415 | hbus monitor | Collected READ  addr=0x118b data=0x8b |
| 130435 | hbus monitor | Collected WRITE addr=0x118c data=0x38 |
| 130465 | hbus monitor | Collected READ  addr=0x118c data=0x38 |
| 130485 | hbus monitor | Collected WRITE addr=0x118d data=0x68 |
| 130515 | hbus monitor | Collected READ  addr=0x118d data=0x68 |
| 130535 | hbus monitor | Collected WRITE addr=0x118e data=0xe9 |
| 130565 | hbus monitor | Collected READ  addr=0x118e data=0xe9 |
| 130585 | hbus monitor | Collected WRITE addr=0x118f data=0x16 |
| 130615 | hbus monitor | Collected READ  addr=0x118f data=0x16 |
| 130635 | hbus monitor | Collected WRITE addr=0x1190 data=0x3e |
| 130665 | hbus monitor | Collected READ  addr=0x1190 data=0x3e |
| 130685 | hbus monitor | Collected WRITE addr=0x1191 data=0x40 |
| 130715 | hbus monitor | Collected READ  addr=0x1191 data=0x40 |
| 130735 | hbus monitor | Collected WRITE addr=0x1192 data=0x66 |
| 130765 | hbus monitor | Collected READ  addr=0x1192 data=0x66 |
| 130785 | hbus monitor | Collected WRITE addr=0x1193 data=0x20 |
| 130815 | hbus monitor | Collected READ  addr=0x1193 data=0x20 |
| 130835 | hbus monitor | Collected WRITE addr=0x1194 data=0x12 |
| 130865 | hbus monitor | Collected READ  addr=0x1194 data=0x12 |
| 130885 | hbus monitor | Collected WRITE addr=0x1195 data=0x5c |
| 130915 | hbus monitor | Collected READ  addr=0x1195 data=0x5c |
| 130935 | hbus monitor | Collected WRITE addr=0x1196 data=0xde |
| 130965 | hbus monitor | Collected READ  addr=0x1196 data=0xde |
| 130985 | hbus monitor | Collected WRITE addr=0x1197 data=0x50 |
| 131015 | hbus monitor | Collected READ  addr=0x1197 data=0x50 |
| 131035 | hbus monitor | Collected WRITE addr=0x1198 data=0xe1 |
| 131065 | hbus monitor | Collected READ  addr=0x1198 data=0xe1 |
| 131085 | hbus monitor | Collected WRITE addr=0x1199 data=0x76 |
| 131115 | hbus monitor | Collected READ  addr=0x1199 data=0x76 |
| 131135 | hbus monitor | Collected WRITE addr=0x119a data=0x9a |
| 131165 | hbus monitor | Collected READ  addr=0x119a data=0x9a |
| 131185 | hbus monitor | Collected WRITE addr=0x119b data=0x83 |
| 131215 | hbus monitor | Collected READ  addr=0x119b data=0x83 |
| 131235 | hbus monitor | Collected WRITE addr=0x119c data=0x6e |
| 131265 | hbus monitor | Collected READ  addr=0x119c data=0x6e |
| 131285 | hbus monitor | Collected WRITE addr=0x119d data=0x21 |
| 131315 | hbus monitor | Collected READ  addr=0x119d data=0x21 |
| 131335 | hbus monitor | Collected WRITE addr=0x119e data=0xee |
| 131365 | hbus monitor | Collected READ  addr=0x119e data=0xee |
| 131385 | hbus monitor | Collected WRITE addr=0x119f data=0x98 |
| 131415 | hbus monitor | Collected READ  addr=0x119f data=0x98 |
| 131435 | hbus monitor | Collected WRITE addr=0x11a0 data=0xe7 |
| 131465 | hbus monitor | Collected READ  addr=0x11a0 data=0xe7 |
| 131485 | hbus monitor | Collected WRITE addr=0x11a1 data=0x9d |
| 131515 | hbus monitor | Collected READ  addr=0x11a1 data=0x9d |
| 131535 | hbus monitor | Collected WRITE addr=0x11a2 data=0x84 |
| 131565 | hbus monitor | Collected READ  addr=0x11a2 data=0x84 |
| 131585 | hbus monitor | Collected WRITE addr=0x11a3 data=0x9f |
| 131615 | hbus monitor | Collected READ  addr=0x11a3 data=0x9f |
| 131635 | hbus monitor | Collected WRITE addr=0x11a4 data=0xc2 |
| 131665 | hbus monitor | Collected READ  addr=0x11a4 data=0xc2 |
| 131685 | hbus monitor | Collected WRITE addr=0x11a5 data=0x28 |
| 131715 | hbus monitor | Collected READ  addr=0x11a5 data=0x28 |
| 131735 | hbus monitor | Collected WRITE addr=0x11a6 data=0x06 |
| 131765 | hbus monitor | Collected READ  addr=0x11a6 data=0x06 |
| 131785 | hbus monitor | Collected WRITE addr=0x11a7 data=0xbc |
| 131815 | hbus monitor | Collected READ  addr=0x11a7 data=0xbc |
| 131835 | hbus monitor | Collected WRITE addr=0x11a8 data=0x62 |
| 131865 | hbus monitor | Collected READ  addr=0x11a8 data=0x62 |
| 131885 | hbus monitor | Collected WRITE addr=0x11a9 data=0x5d |
| 131915 | hbus monitor | Collected READ  addr=0x11a9 data=0x5d |
| 131935 | hbus monitor | Collected WRITE addr=0x11aa data=0x2e |
| 131965 | hbus monitor | Collected READ  addr=0x11aa data=0x2e |
| 131985 | hbus monitor | Collected WRITE addr=0x11ab data=0x8f |
| 132015 | hbus monitor | Collected READ  addr=0x11ab data=0x8f |
| 132035 | hbus monitor | Collected WRITE addr=0x11ac data=0xc8 |
| 132065 | hbus monitor | Collected READ  addr=0x11ac data=0xc8 |
| 132085 | hbus monitor | Collected WRITE addr=0x11ad data=0x79 |
| 132115 | hbus monitor | Collected READ  addr=0x11ad data=0x79 |
| 132135 | hbus monitor | Collected WRITE addr=0x11ae data=0x6d |
| 132165 | hbus monitor | Collected READ  addr=0x11ae data=0x6d |
| 132185 | hbus monitor | Collected WRITE addr=0x11af data=0x44 |
| 132215 | hbus monitor | Collected READ  addr=0x11af data=0x44 |
| 132235 | hbus monitor | Collected WRITE addr=0x11b0 data=0x3f |
| 132265 | hbus monitor | Collected READ  addr=0x11b0 data=0x3f |
| 132285 | hbus monitor | Collected WRITE addr=0x11b1 data=0x1e |
| 132315 | hbus monitor | Collected READ  addr=0x11b1 data=0x1e |
| 132335 | hbus monitor | Collected WRITE addr=0x11b2 data=0xcc |
| 132365 | hbus monitor | Collected READ  addr=0x11b2 data=0xcc |
| 132385 | hbus monitor | Collected WRITE addr=0x11b3 data=0xbc |
| 132415 | hbus monitor | Collected READ  addr=0x11b3 data=0xbc |
| 132435 | hbus monitor | Collected WRITE addr=0x11b4 data=0xae |
| 132465 | hbus monitor | Collected READ  addr=0x11b4 data=0xae |
| 132485 | hbus monitor | Collected WRITE addr=0x11b5 data=0xb1 |
| 132515 | hbus monitor | Collected READ  addr=0x11b5 data=0xb1 |
| 132535 | hbus monitor | Collected WRITE addr=0x11b6 data=0xbd |
| 132565 | hbus monitor | Collected READ  addr=0x11b6 data=0xbd |
| 132585 | hbus monitor | Collected WRITE addr=0x11b7 data=0xba |
| 132615 | hbus monitor | Collected READ  addr=0x11b7 data=0xba |
| 132635 | hbus monitor | Collected WRITE addr=0x11b8 data=0xfc |
| 132665 | hbus monitor | Collected READ  addr=0x11b8 data=0xfc |
| 132685 | hbus monitor | Collected WRITE addr=0x11b9 data=0x69 |
| 132715 | hbus monitor | Collected READ  addr=0x11b9 data=0x69 |
| 132735 | hbus monitor | Collected WRITE addr=0x11ba data=0x9d |
| 132765 | hbus monitor | Collected READ  addr=0x11ba data=0x9d |
| 132785 | hbus monitor | Collected WRITE addr=0x11bb data=0xfc |
| 132815 | hbus monitor | Collected READ  addr=0x11bb data=0xfc |
| 132835 | hbus monitor | Collected WRITE addr=0x11bc data=0x0a |
| 132865 | hbus monitor | Collected READ  addr=0x11bc data=0x0a |
| 132885 | hbus monitor | Collected WRITE addr=0x11bd data=0x29 |
| 132915 | hbus monitor | Collected READ  addr=0x11bd data=0x29 |
| 132935 | hbus monitor | Collected WRITE addr=0x11be data=0x62 |
| 132965 | hbus monitor | Collected READ  addr=0x11be data=0x62 |
| 132985 | hbus monitor | Collected WRITE addr=0x11bf data=0x58 |
| 133015 | hbus monitor | Collected READ  addr=0x11bf data=0x58 |
| 133035 | hbus monitor | Collected WRITE addr=0x11c0 data=0xef |
| 133065 | hbus monitor | Collected READ  addr=0x11c0 data=0xef |
| 133085 | hbus monitor | Collected WRITE addr=0x11c1 data=0x8a |
| 133115 | hbus monitor | Collected READ  addr=0x11c1 data=0x8a |
| 133135 | hbus monitor | Collected WRITE addr=0x11c2 data=0x22 |
| 133165 | hbus monitor | Collected READ  addr=0x11c2 data=0x22 |
| 133185 | hbus monitor | Collected WRITE addr=0x11c3 data=0x49 |
| 133215 | hbus monitor | Collected READ  addr=0x11c3 data=0x49 |
| 133235 | hbus monitor | Collected WRITE addr=0x11c4 data=0xb2 |
| 133265 | hbus monitor | Collected READ  addr=0x11c4 data=0xb2 |
| 133285 | hbus monitor | Collected WRITE addr=0x11c5 data=0x73 |
| 133315 | hbus monitor | Collected READ  addr=0x11c5 data=0x73 |
| 133335 | hbus monitor | Collected WRITE addr=0x11c6 data=0x11 |
| 133365 | hbus monitor | Collected READ  addr=0x11c6 data=0x11 |
| 133385 | hbus monitor | Collected WRITE addr=0x11c7 data=0x93 |
| 133415 | hbus monitor | Collected READ  addr=0x11c7 data=0x93 |
| 133435 | hbus monitor | Collected WRITE addr=0x11c8 data=0xf3 |
| 133465 | hbus monitor | Collected READ  addr=0x11c8 data=0xf3 |
| 133485 | hbus monitor | Collected WRITE addr=0x11c9 data=0xd4 |
| 133515 | hbus monitor | Collected READ  addr=0x11c9 data=0xd4 |
| 133535 | hbus monitor | Collected WRITE addr=0x11ca data=0xe9 |
| 133565 | hbus monitor | Collected READ  addr=0x11ca data=0xe9 |
| 133585 | hbus monitor | Collected WRITE addr=0x11cb data=0x32 |
| 133615 | hbus monitor | Collected READ  addr=0x11cb data=0x32 |
| 133635 | hbus monitor | Collected WRITE addr=0x11cc data=0xda |
| 133665 | hbus monitor | Collected READ  addr=0x11cc data=0xda |
| 133685 | hbus monitor | Collected WRITE addr=0x11cd data=0x41 |
| 133715 | hbus monitor | Collected READ  addr=0x11cd data=0x41 |
| 133735 | hbus monitor | Collected WRITE addr=0x11ce data=0x88 |
| 133765 | hbus monitor | Collected READ  addr=0x11ce data=0x88 |
| 133785 | hbus monitor | Collected WRITE addr=0x11cf data=0x3e |
| 133815 | hbus monitor | Collected READ  addr=0x11cf data=0x3e |
| 133835 | hbus monitor | Collected WRITE addr=0x11d0 data=0xfe |
| 133865 | hbus monitor | Collected READ  addr=0x11d0 data=0xfe |
| 133885 | hbus monitor | Collected WRITE addr=0x11d1 data=0x2b |
| 133915 | hbus monitor | Collected READ  addr=0x11d1 data=0x2b |
| 133935 | hbus monitor | Collected WRITE addr=0x11d2 data=0x8b |
| 133965 | hbus monitor | Collected READ  addr=0x11d2 data=0x8b |
| 133985 | hbus monitor | Collected WRITE addr=0x11d3 data=0x78 |
| 134015 | hbus monitor | Collected READ  addr=0x11d3 data=0x78 |
| 134035 | hbus monitor | Collected WRITE addr=0x11d4 data=0xed |
| 134065 | hbus monitor | Collected READ  addr=0x11d4 data=0xed |
| 134085 | hbus monitor | Collected WRITE addr=0x11d5 data=0x3e |
| 134115 | hbus monitor | Collected READ  addr=0x11d5 data=0x3e |
| 134135 | hbus monitor | Collected WRITE addr=0x11d6 data=0xa8 |
| 134165 | hbus monitor | Collected READ  addr=0x11d6 data=0xa8 |
| 134185 | hbus monitor | Collected WRITE addr=0x11d7 data=0x4f |
| 134215 | hbus monitor | Collected READ  addr=0x11d7 data=0x4f |
| 134235 | hbus monitor | Collected WRITE addr=0x11d8 data=0x66 |
| 134265 | hbus monitor | Collected READ  addr=0x11d8 data=0x66 |
| 134285 | hbus monitor | Collected WRITE addr=0x11d9 data=0xbc |
| 134315 | hbus monitor | Collected READ  addr=0x11d9 data=0xbc |
| 134335 | hbus monitor | Collected WRITE addr=0x11da data=0x16 |
| 134365 | hbus monitor | Collected READ  addr=0x11da data=0x16 |
| 134385 | hbus monitor | Collected WRITE addr=0x11db data=0x3a |
| 134415 | hbus monitor | Collected READ  addr=0x11db data=0x3a |
| 134435 | hbus monitor | Collected WRITE addr=0x11dc data=0xbc |
| 134465 | hbus monitor | Collected READ  addr=0x11dc data=0xbc |
| 134485 | hbus monitor | Collected WRITE addr=0x11dd data=0x67 |
| 134515 | hbus monitor | Collected READ  addr=0x11dd data=0x67 |
| 134535 | hbus monitor | Collected WRITE addr=0x11de data=0xc2 |
| 134565 | hbus monitor | Collected READ  addr=0x11de data=0xc2 |
| 134585 | hbus monitor | Collected WRITE addr=0x11df data=0x49 |
| 134615 | hbus monitor | Collected READ  addr=0x11df data=0x49 |
| 134635 | hbus monitor | Collected WRITE addr=0x11e0 data=0x9a |
| 134665 | hbus monitor | Collected READ  addr=0x11e0 data=0x9a |
| 134685 | hbus monitor | Collected WRITE addr=0x11e1 data=0x9e |
| 134715 | hbus monitor | Collected READ  addr=0x11e1 data=0x9e |
| 134735 | hbus monitor | Collected WRITE addr=0x11e2 data=0x3b |
| 134765 | hbus monitor | Collected READ  addr=0x11e2 data=0x3b |
| 134785 | hbus monitor | Collected WRITE addr=0x11e3 data=0x70 |
| 134815 | hbus monitor | Collected READ  addr=0x11e3 data=0x70 |
| 134835 | hbus monitor | Collected WRITE addr=0x11e4 data=0x8e |
| 134865 | hbus monitor | Collected READ  addr=0x11e4 data=0x8e |
| 134885 | hbus monitor | Collected WRITE addr=0x11e5 data=0xaf |
| 134915 | hbus monitor | Collected READ  addr=0x11e5 data=0xaf |
| 134935 | hbus monitor | Collected WRITE addr=0x11e6 data=0xa0 |
| 134965 | hbus monitor | Collected READ  addr=0x11e6 data=0xa0 |
| 134985 | hbus monitor | Collected WRITE addr=0x11e7 data=0x0d |
| 135015 | hbus monitor | Collected READ  addr=0x11e7 data=0x0d |
| 135035 | hbus monitor | Collected WRITE addr=0x11e8 data=0x21 |
| 135065 | hbus monitor | Collected READ  addr=0x11e8 data=0x21 |
| 135085 | hbus monitor | Collected WRITE addr=0x11e9 data=0x09 |
| 135115 | hbus monitor | Collected READ  addr=0x11e9 data=0x09 |
| 135135 | hbus monitor | Collected WRITE addr=0x11ea data=0x75 |
| 135165 | hbus monitor | Collected READ  addr=0x11ea data=0x75 |
| 135185 | hbus monitor | Collected WRITE addr=0x11eb data=0x22 |
| 135215 | hbus monitor | Collected READ  addr=0x11eb data=0x22 |
| 135235 | hbus monitor | Collected WRITE addr=0x11ec data=0x21 |
| 135265 | hbus monitor | Collected READ  addr=0x11ec data=0x21 |
| 135285 | hbus monitor | Collected WRITE addr=0x11ed data=0x85 |
| 135315 | hbus monitor | Collected READ  addr=0x11ed data=0x85 |
| 135335 | hbus monitor | Collected WRITE addr=0x11ee data=0xab |
| 135365 | hbus monitor | Collected READ  addr=0x11ee data=0xab |
| 135385 | hbus monitor | Collected WRITE addr=0x11ef data=0xfd |
| 135415 | hbus monitor | Collected READ  addr=0x11ef data=0xfd |
| 135435 | hbus monitor | Collected WRITE addr=0x11f0 data=0xa7 |
| 135465 | hbus monitor | Collected READ  addr=0x11f0 data=0xa7 |
| 135485 | hbus monitor | Collected WRITE addr=0x11f1 data=0xba |
| 135515 | hbus monitor | Collected READ  addr=0x11f1 data=0xba |
| 135535 | hbus monitor | Collected WRITE addr=0x11f2 data=0xc8 |
| 135565 | hbus monitor | Collected READ  addr=0x11f2 data=0xc8 |
| 135585 | hbus monitor | Collected WRITE addr=0x11f3 data=0xea |
| 135615 | hbus monitor | Collected READ  addr=0x11f3 data=0xea |
| 135635 | hbus monitor | Collected WRITE addr=0x11f4 data=0xda |
| 135665 | hbus monitor | Collected READ  addr=0x11f4 data=0xda |
| 135685 | hbus monitor | Collected WRITE addr=0x11f5 data=0x37 |
| 135715 | hbus monitor | Collected READ  addr=0x11f5 data=0x37 |
| 135735 | hbus monitor | Collected WRITE addr=0x11f6 data=0xf1 |
| 135765 | hbus monitor | Collected READ  addr=0x11f6 data=0xf1 |
| 135785 | hbus monitor | Collected WRITE addr=0x11f7 data=0x2d |
| 135815 | hbus monitor | Collected READ  addr=0x11f7 data=0x2d |
| 135835 | hbus monitor | Collected WRITE addr=0x11f8 data=0xdd |
| 135865 | hbus monitor | Collected READ  addr=0x11f8 data=0xdd |
| 135885 | hbus monitor | Collected WRITE addr=0x11f9 data=0xbd |
| 135915 | hbus monitor | Collected READ  addr=0x11f9 data=0xbd |
| 135935 | hbus monitor | Collected WRITE addr=0x11fa data=0xe4 |
| 135965 | hbus monitor | Collected READ  addr=0x11fa data=0xe4 |
| 135985 | hbus monitor | Collected WRITE addr=0x11fb data=0xdf |
| 136015 | hbus monitor | Collected READ  addr=0x11fb data=0xdf |
| 136035 | hbus monitor | Collected WRITE addr=0x11fc data=0x6f |
| 136065 | hbus monitor | Collected READ  addr=0x11fc data=0x6f |
| 136085 | hbus monitor | Collected WRITE addr=0x11fd data=0xea |
| 136115 | hbus monitor | Collected READ  addr=0x11fd data=0xea |
| 136135 | hbus monitor | Collected WRITE addr=0x11fe data=0xf3 |
| 136165 | hbus monitor | Collected READ  addr=0x11fe data=0xf3 |
| 136185 | hbus monitor | Collected WRITE addr=0x11ff data=0xe1 |
| 136210 | **test** | STAGE: 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136215 | hbus monitor | Collected READ  addr=0x11ff data=0xe1 |
| 136235 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 136235 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 136235 | reference | maxpktsize is now 1 |
| 136265 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 136295 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 136325 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 136355 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 136385 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 136410 | **test** | STAGE: 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 136415 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 136435 | hbus monitor | Collected WRITE addr=0x1001 data=0x17 |
| 136435 | reference | router_en is now 1 (en_reg 0x17) |
| 136645 | **DUT** | IN  pkt #2 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136675 | **DUT** | IN  pkt #2 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136675 | yapp monitor | RX pkt #2 on the input: addr=0 len=2 parity=bad gap=13627 |
| 136675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 136875 | **DUT** | IN  pkt #3 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136905 | **DUT** | IN  pkt #3 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136905 | yapp monitor | RX pkt #3 on the input: addr=0 len=2 parity=bad gap=19 |
| 136905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136925 | **DUT** | IN  pkt #4 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136955 | **DUT** | IN  pkt #4 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136955 | yapp monitor | RX pkt #4 on the input: addr=0 len=2 parity=bad gap=1 |
| 136955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136970 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 136975 | **DUT** | IN  pkt #5 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136980 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 137005 | **DUT** | IN  pkt #5 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137005 | yapp monitor | RX pkt #5 on the input: addr=0 len=2 parity=bad gap=1 |
| 137005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 137115 | **DUT** | IN  pkt #6 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137145 | **DUT** | IN  pkt #6 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137145 | yapp monitor | RX pkt #6 on the input: addr=0 len=2 parity=bad gap=10 |
| 137145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137185 | **DUT** | IN  pkt #7 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 137215 | **DUT** | IN  pkt #7 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137215 | yapp monitor | RX pkt #7 on the input: addr=0 len=2 parity=bad gap=3 |
| 137215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137235 | **DUT** | IN  pkt #8 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137265 | **DUT** | IN  pkt #8 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137265 | yapp monitor | RX pkt #8 on the input: addr=0 len=2 parity=bad gap=1 |
| 137265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137265 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 137335 | **DUT** | IN  pkt #9 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137365 | **DUT** | IN  pkt #9 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137365 | yapp monitor | RX pkt #9 on the input: addr=0 len=2 parity=bad gap=6 |
| 137365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 137385 | **DUT** | IN  pkt #10 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 137415 | **DUT** | IN  pkt #10 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137415 | yapp monitor | RX pkt #10 on the input: addr=0 len=2 parity=bad gap=1 |
| 137415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 137625 | **DUT** | IN  pkt #11 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137655 | **DUT** | IN  pkt #11 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137655 | yapp monitor | RX pkt #11 on the input: addr=0 len=2 parity=bad gap=20 |
| 137655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 137675 | **DUT** | IN  pkt #12 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137705 | **DUT** | IN  pkt #12 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137705 | yapp monitor | RX pkt #12 on the input: addr=0 len=2 parity=bad gap=1 |
| 137705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 137905 | **DUT** | IN  pkt #13 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137935 | **DUT** | IN  pkt #13 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137935 | yapp monitor | RX pkt #13 on the input: addr=0 len=2 parity=bad gap=19 |
| 137935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 138145 | **DUT** | IN  pkt #14 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138175 | **DUT** | IN  pkt #14 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138175 | yapp monitor | RX pkt #14 on the input: addr=0 len=2 parity=bad gap=20 |
| 138175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138175 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 138325 | **DUT** | IN  pkt #15 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138355 | **DUT** | IN  pkt #15 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138355 | yapp monitor | RX pkt #15 on the input: addr=0 len=2 parity=bad gap=14 |
| 138355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 138565 | **DUT** | IN  pkt #16 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138595 | **DUT** | IN  pkt #16 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138595 | yapp monitor | RX pkt #16 on the input: addr=0 len=2 parity=bad gap=20 |
| 138595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 138805 | **DUT** | IN  pkt #17 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138835 | **DUT** | IN  pkt #17 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138835 | yapp monitor | RX pkt #17 on the input: addr=0 len=2 parity=bad gap=20 |
| 138835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 139005 | **DUT** | IN  pkt #18 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139035 | **DUT** | IN  pkt #18 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139035 | yapp monitor | RX pkt #18 on the input: addr=0 len=2 parity=bad gap=16 |
| 139035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139035 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 139245 | **DUT** | IN  pkt #19 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139275 | **DUT** | IN  pkt #19 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139275 | yapp monitor | RX pkt #19 on the input: addr=0 len=2 parity=bad gap=20 |
| 139275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 139485 | **DUT** | IN  pkt #20 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139515 | **DUT** | IN  pkt #20 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139515 | yapp monitor | RX pkt #20 on the input: addr=0 len=2 parity=bad gap=20 |
| 139515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 139725 | **DUT** | IN  pkt #21 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139755 | **DUT** | IN  pkt #21 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139755 | yapp monitor | RX pkt #21 on the input: addr=0 len=2 parity=bad gap=20 |
| 139755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 139795 | **DUT** | IN  pkt #22 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139825 | **DUT** | IN  pkt #22 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139825 | yapp monitor | RX pkt #22 on the input: addr=0 len=2 parity=bad gap=3 |
| 139825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 140015 | **DUT** | IN  pkt #23 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140045 | **DUT** | IN  pkt #23 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140045 | yapp monitor | RX pkt #23 on the input: addr=0 len=2 parity=bad gap=18 |
| 140045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140045 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 140205 | **DUT** | IN  pkt #24 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140235 | **DUT** | IN  pkt #24 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140235 | yapp monitor | RX pkt #24 on the input: addr=0 len=2 parity=bad gap=15 |
| 140235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 140425 | **DUT** | IN  pkt #25 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140455 | **DUT** | IN  pkt #25 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140455 | yapp monitor | RX pkt #25 on the input: addr=0 len=2 parity=bad gap=18 |
| 140455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140455 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 140665 | **DUT** | IN  pkt #26 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140695 | **DUT** | IN  pkt #26 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140695 | yapp monitor | RX pkt #26 on the input: addr=0 len=2 parity=bad gap=20 |
| 140695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140710 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 140905 | **DUT** | IN  pkt #27 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140935 | **DUT** | IN  pkt #27 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140935 | yapp monitor | RX pkt #27 on the input: addr=0 len=2 parity=bad gap=20 |
| 140935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140995 | **DUT** | IN  pkt #28 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141025 | **DUT** | IN  pkt #28 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141025 | yapp monitor | RX pkt #28 on the input: addr=0 len=2 parity=bad gap=5 |
| 141025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141030 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 141050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 141225 | **DUT** | IN  pkt #29 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141255 | **DUT** | IN  pkt #29 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141255 | yapp monitor | RX pkt #29 on the input: addr=0 len=2 parity=bad gap=19 |
| 141255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 141385 | **DUT** | IN  pkt #30 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141415 | **DUT** | IN  pkt #30 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141415 | yapp monitor | RX pkt #30 on the input: addr=0 len=2 parity=bad gap=12 |
| 141415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141495 | **DUT** | IN  pkt #31 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 141525 | **DUT** | IN  pkt #31 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141525 | yapp monitor | RX pkt #31 on the input: addr=0 len=2 parity=bad gap=7 |
| 141525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 141735 | **DUT** | IN  pkt #32 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141765 | **DUT** | IN  pkt #32 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141765 | yapp monitor | RX pkt #32 on the input: addr=0 len=2 parity=bad gap=20 |
| 141765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 141805 | **DUT** | IN  pkt #33 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141835 | **DUT** | IN  pkt #33 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141835 | yapp monitor | RX pkt #33 on the input: addr=0 len=2 parity=bad gap=3 |
| 141835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 142045 | **DUT** | IN  pkt #34 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142075 | **DUT** | IN  pkt #34 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142075 | yapp monitor | RX pkt #34 on the input: addr=0 len=2 parity=bad gap=20 |
| 142075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 142215 | **DUT** | IN  pkt #35 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142245 | **DUT** | IN  pkt #35 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142245 | yapp monitor | RX pkt #35 on the input: addr=0 len=2 parity=bad gap=13 |
| 142245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 142355 | **DUT** | IN  pkt #36 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142385 | **DUT** | IN  pkt #36 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142385 | yapp monitor | RX pkt #36 on the input: addr=0 len=2 parity=bad gap=10 |
| 142385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 142595 | **DUT** | IN  pkt #37 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142625 | **DUT** | IN  pkt #37 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142625 | yapp monitor | RX pkt #37 on the input: addr=0 len=2 parity=bad gap=20 |
| 142625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142645 | **DUT** | IN  pkt #38 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 142675 | **DUT** | IN  pkt #38 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142675 | yapp monitor | RX pkt #38 on the input: addr=0 len=2 parity=bad gap=1 |
| 142675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 142885 | **DUT** | IN  pkt #39 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142915 | **DUT** | IN  pkt #39 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142915 | yapp monitor | RX pkt #39 on the input: addr=0 len=2 parity=bad gap=20 |
| 142915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142970 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 143095 | **DUT** | IN  pkt #40 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143125 | **DUT** | IN  pkt #40 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143125 | yapp monitor | RX pkt #40 on the input: addr=0 len=2 parity=bad gap=17 |
| 143125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 143325 | **DUT** | IN  pkt #41 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143355 | **DUT** | IN  pkt #41 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143355 | yapp monitor | RX pkt #41 on the input: addr=0 len=2 parity=bad gap=19 |
| 143355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 143375 | **DUT** | IN  pkt #42 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143405 | **DUT** | IN  pkt #42 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143405 | yapp monitor | RX pkt #42 on the input: addr=0 len=2 parity=bad gap=1 |
| 143405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 143585 | **DUT** | IN  pkt #43 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143615 | **DUT** | IN  pkt #43 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143615 | yapp monitor | RX pkt #43 on the input: addr=0 len=2 parity=bad gap=17 |
| 143615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143635 | **DUT** | IN  pkt #44 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143665 | **DUT** | IN  pkt #44 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143665 | yapp monitor | RX pkt #44 on the input: addr=0 len=2 parity=bad gap=1 |
| 143665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143665 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 143770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 143865 | **DUT** | IN  pkt #45 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143895 | **DUT** | IN  pkt #45 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143895 | yapp monitor | RX pkt #45 on the input: addr=0 len=2 parity=bad gap=19 |
| 143895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 144005 | **DUT** | IN  pkt #46 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144035 | **DUT** | IN  pkt #46 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144035 | yapp monitor | RX pkt #46 on the input: addr=0 len=2 parity=bad gap=10 |
| 144035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144035 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 144225 | **DUT** | IN  pkt #47 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144255 | **DUT** | IN  pkt #47 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144255 | yapp monitor | RX pkt #47 on the input: addr=0 len=2 parity=bad gap=18 |
| 144255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 144465 | **DUT** | IN  pkt #48 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144495 | **DUT** | IN  pkt #48 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144495 | yapp monitor | RX pkt #48 on the input: addr=0 len=2 parity=bad gap=20 |
| 144495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 144545 | **DUT** | IN  pkt #49 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144575 | **DUT** | IN  pkt #49 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144575 | yapp monitor | RX pkt #49 on the input: addr=0 len=2 parity=bad gap=4 |
| 144575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 144685 | **DUT** | IN  pkt #50 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144715 | **DUT** | IN  pkt #50 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144715 | yapp monitor | RX pkt #50 on the input: addr=0 len=2 parity=bad gap=10 |
| 144715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144715 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 144885 | **DUT** | IN  pkt #51 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144915 | **DUT** | IN  pkt #51 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144915 | yapp monitor | RX pkt #51 on the input: addr=0 len=2 parity=bad gap=16 |
| 144915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 145105 | **DUT** | IN  pkt #52 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145135 | **DUT** | IN  pkt #52 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145135 | yapp monitor | RX pkt #52 on the input: addr=0 len=2 parity=bad gap=18 |
| 145135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 145195 | **DUT** | IN  pkt #53 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145225 | **DUT** | IN  pkt #53 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145225 | yapp monitor | RX pkt #53 on the input: addr=0 len=2 parity=bad gap=5 |
| 145225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145290 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 145365 | **DUT** | IN  pkt #54 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145395 | **DUT** | IN  pkt #54 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145395 | yapp monitor | RX pkt #54 on the input: addr=0 len=2 parity=bad gap=13 |
| 145395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 145585 | **DUT** | IN  pkt #55 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145615 | **DUT** | IN  pkt #55 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145615 | yapp monitor | RX pkt #55 on the input: addr=0 len=2 parity=bad gap=18 |
| 145615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 145715 | **DUT** | IN  pkt #56 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145745 | **DUT** | IN  pkt #56 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145745 | yapp monitor | RX pkt #56 on the input: addr=0 len=2 parity=bad gap=9 |
| 145745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 145865 | **DUT** | IN  pkt #57 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145895 | **DUT** | IN  pkt #57 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145895 | yapp monitor | RX pkt #57 on the input: addr=0 len=2 parity=bad gap=11 |
| 145895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145915 | **DUT** | IN  pkt #58 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145945 | **DUT** | IN  pkt #58 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145945 | yapp monitor | RX pkt #58 on the input: addr=0 len=2 parity=bad gap=1 |
| 145945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 146000 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 146135 | **DUT** | IN  pkt #59 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146165 | **DUT** | IN  pkt #59 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146165 | yapp monitor | RX pkt #59 on the input: addr=0 len=2 parity=bad gap=18 |
| 146165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 146255 | **DUT** | IN  pkt #60 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146285 | **DUT** | IN  pkt #60 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146285 | yapp monitor | RX pkt #60 on the input: addr=0 len=2 parity=bad gap=8 |
| 146285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146285 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 146435 | **DUT** | IN  pkt #61 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146465 | **DUT** | IN  pkt #61 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146465 | yapp monitor | RX pkt #61 on the input: addr=0 len=2 parity=bad gap=14 |
| 146465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146465 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 146555 | **DUT** | IN  pkt #62 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146585 | **DUT** | IN  pkt #62 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146585 | yapp monitor | RX pkt #62 on the input: addr=0 len=2 parity=bad gap=8 |
| 146585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 146785 | **DUT** | IN  pkt #63 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146815 | **DUT** | IN  pkt #63 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146815 | yapp monitor | RX pkt #63 on the input: addr=0 len=2 parity=bad gap=19 |
| 146815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 147025 | **DUT** | IN  pkt #64 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147055 | **DUT** | IN  pkt #64 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147055 | yapp monitor | RX pkt #64 on the input: addr=0 len=2 parity=bad gap=20 |
| 147055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 147265 | **DUT** | IN  pkt #65 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147295 | **DUT** | IN  pkt #65 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147295 | yapp monitor | RX pkt #65 on the input: addr=0 len=2 parity=bad gap=20 |
| 147295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 147485 | **DUT** | IN  pkt #66 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147515 | **DUT** | IN  pkt #66 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147515 | yapp monitor | RX pkt #66 on the input: addr=0 len=2 parity=bad gap=18 |
| 147515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 147715 | **DUT** | IN  pkt #67 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147745 | **DUT** | IN  pkt #67 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147745 | yapp monitor | RX pkt #67 on the input: addr=0 len=2 parity=bad gap=19 |
| 147745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 147825 | **DUT** | IN  pkt #68 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147855 | **DUT** | IN  pkt #68 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147855 | yapp monitor | RX pkt #68 on the input: addr=0 len=2 parity=bad gap=7 |
| 147855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 147915 | **DUT** | IN  pkt #69 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147945 | **DUT** | IN  pkt #69 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147945 | yapp monitor | RX pkt #69 on the input: addr=0 len=2 parity=bad gap=5 |
| 147945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147995 | **DUT** | IN  pkt #70 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 148025 | **DUT** | IN  pkt #70 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148025 | yapp monitor | RX pkt #70 on the input: addr=0 len=2 parity=bad gap=4 |
| 148025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 148145 | **DUT** | IN  pkt #71 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148175 | **DUT** | IN  pkt #71 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148175 | yapp monitor | RX pkt #71 on the input: addr=0 len=2 parity=bad gap=11 |
| 148175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148175 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 148385 | **DUT** | IN  pkt #72 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148415 | **DUT** | IN  pkt #72 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148415 | yapp monitor | RX pkt #72 on the input: addr=0 len=2 parity=bad gap=20 |
| 148415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148470 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 148595 | **DUT** | IN  pkt #73 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148625 | **DUT** | IN  pkt #73 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148625 | yapp monitor | RX pkt #73 on the input: addr=0 len=2 parity=bad gap=17 |
| 148625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 148835 | **DUT** | IN  pkt #74 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148865 | **DUT** | IN  pkt #74 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148865 | yapp monitor | RX pkt #74 on the input: addr=0 len=2 parity=bad gap=20 |
| 148865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148865 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 149035 | **DUT** | IN  pkt #75 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149065 | **DUT** | IN  pkt #75 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149065 | yapp monitor | RX pkt #75 on the input: addr=0 len=2 parity=bad gap=16 |
| 149065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149065 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 149155 | **DUT** | IN  pkt #76 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149185 | **DUT** | IN  pkt #76 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149185 | yapp monitor | RX pkt #76 on the input: addr=0 len=2 parity=bad gap=8 |
| 149185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 149305 | **DUT** | IN  pkt #77 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149335 | **DUT** | IN  pkt #77 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149335 | yapp monitor | RX pkt #77 on the input: addr=0 len=2 parity=bad gap=11 |
| 149335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 149445 | **DUT** | IN  pkt #78 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149475 | **DUT** | IN  pkt #78 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149475 | yapp monitor | RX pkt #78 on the input: addr=0 len=2 parity=bad gap=10 |
| 149475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 149685 | **DUT** | IN  pkt #79 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149715 | **DUT** | IN  pkt #79 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149715 | yapp monitor | RX pkt #79 on the input: addr=0 len=2 parity=bad gap=20 |
| 149715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149715 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 149925 | **DUT** | IN  pkt #80 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149955 | **DUT** | IN  pkt #80 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149955 | yapp monitor | RX pkt #80 on the input: addr=0 len=2 parity=bad gap=20 |
| 149955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 150165 | **DUT** | IN  pkt #81 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150195 | **DUT** | IN  pkt #81 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150195 | yapp monitor | RX pkt #81 on the input: addr=0 len=2 parity=bad gap=20 |
| 150195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150270 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 150405 | **DUT** | IN  pkt #82 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150435 | **DUT** | IN  pkt #82 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150435 | yapp monitor | RX pkt #82 on the input: addr=0 len=2 parity=bad gap=20 |
| 150435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150435 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150490 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 150525 | **DUT** | IN  pkt #83 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150555 | **DUT** | IN  pkt #83 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150555 | yapp monitor | RX pkt #83 on the input: addr=0 len=2 parity=bad gap=8 |
| 150555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 150625 | **DUT** | IN  pkt #84 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150655 | **DUT** | IN  pkt #84 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150655 | yapp monitor | RX pkt #84 on the input: addr=0 len=2 parity=bad gap=6 |
| 150655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 150865 | **DUT** | IN  pkt #85 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150895 | **DUT** | IN  pkt #85 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150895 | yapp monitor | RX pkt #85 on the input: addr=0 len=2 parity=bad gap=20 |
| 150895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 151055 | **DUT** | IN  pkt #86 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151085 | **DUT** | IN  pkt #86 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151085 | yapp monitor | RX pkt #86 on the input: addr=0 len=2 parity=bad gap=15 |
| 151085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 151255 | **DUT** | IN  pkt #87 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151285 | **DUT** | IN  pkt #87 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151285 | yapp monitor | RX pkt #87 on the input: addr=0 len=2 parity=bad gap=16 |
| 151285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151285 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151330 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 151495 | **DUT** | IN  pkt #88 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151525 | **DUT** | IN  pkt #88 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151525 | yapp monitor | RX pkt #88 on the input: addr=0 len=2 parity=bad gap=20 |
| 151525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 151695 | **DUT** | IN  pkt #89 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151725 | **DUT** | IN  pkt #89 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151725 | yapp monitor | RX pkt #89 on the input: addr=0 len=2 parity=bad gap=16 |
| 151725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 151905 | **DUT** | IN  pkt #90 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151935 | **DUT** | IN  pkt #90 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151935 | yapp monitor | RX pkt #90 on the input: addr=0 len=2 parity=bad gap=17 |
| 151935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151935 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151990 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 152035 | **DUT** | IN  pkt #91 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152065 | **DUT** | IN  pkt #91 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152065 | yapp monitor | RX pkt #91 on the input: addr=0 len=2 parity=bad gap=9 |
| 152065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152065 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 152245 | **DUT** | IN  pkt #92 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152275 | **DUT** | IN  pkt #92 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152275 | yapp monitor | RX pkt #92 on the input: addr=0 len=2 parity=bad gap=17 |
| 152275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 152445 | **DUT** | IN  pkt #93 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152475 | **DUT** | IN  pkt #93 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152475 | yapp monitor | RX pkt #93 on the input: addr=0 len=2 parity=bad gap=16 |
| 152475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 152575 | **DUT** | IN  pkt #94 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152605 | **DUT** | IN  pkt #94 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152605 | yapp monitor | RX pkt #94 on the input: addr=0 len=2 parity=bad gap=9 |
| 152605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 152815 | **DUT** | IN  pkt #95 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152845 | **DUT** | IN  pkt #95 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152845 | yapp monitor | RX pkt #95 on the input: addr=0 len=2 parity=bad gap=20 |
| 152845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 153055 | **DUT** | IN  pkt #96 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153085 | **DUT** | IN  pkt #96 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153085 | yapp monitor | RX pkt #96 on the input: addr=0 len=2 parity=bad gap=20 |
| 153085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 153295 | **DUT** | IN  pkt #97 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153325 | **DUT** | IN  pkt #97 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153325 | yapp monitor | RX pkt #97 on the input: addr=0 len=2 parity=bad gap=20 |
| 153325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 153415 | **DUT** | IN  pkt #98 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153445 | **DUT** | IN  pkt #98 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153445 | yapp monitor | RX pkt #98 on the input: addr=0 len=2 parity=bad gap=8 |
| 153445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153465 | **DUT** | IN  pkt #99 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 153495 | **DUT** | IN  pkt #99 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153495 | yapp monitor | RX pkt #99 on the input: addr=0 len=2 parity=bad gap=1 |
| 153495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 153645 | **DUT** | IN  pkt #100 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153675 | **DUT** | IN  pkt #100 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153675 | yapp monitor | RX pkt #100 on the input: addr=0 len=2 parity=bad gap=14 |
| 153675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 153885 | **DUT** | IN  pkt #101 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153915 | **DUT** | IN  pkt #101 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153915 | yapp monitor | RX pkt #101 on the input: addr=0 len=2 parity=bad gap=20 |
| 153915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 153955 | hbus monitor | Collected READ  addr=0x1004 data=0x64 |
| 153985 | hbus monitor | Collected READ  addr=0x1005 data=0x64 |
| 154015 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 154045 | hbus monitor | Collected READ  addr=0x1009 data=0x64 |
| 154075 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 154105 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 154195 | **DUT** | IN  pkt #102 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154225 | **DUT** | IN  pkt #102 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154225 | yapp monitor | RX pkt #102 on the input: addr=0 len=2 parity=bad gap=27 |
| 154225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 154395 | **DUT** | IN  pkt #103 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154425 | **DUT** | IN  pkt #103 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154425 | yapp monitor | RX pkt #103 on the input: addr=0 len=2 parity=bad gap=16 |
| 154425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154425 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154445 | **DUT** | IN  pkt #104 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 154475 | **DUT** | IN  pkt #104 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154475 | yapp monitor | RX pkt #104 on the input: addr=0 len=2 parity=bad gap=1 |
| 154475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154495 | **DUT** | IN  pkt #105 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 154525 | **DUT** | IN  pkt #105 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154525 | yapp monitor | RX pkt #105 on the input: addr=0 len=2 parity=bad gap=1 |
| 154525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154555 | **DUT** | IN  pkt #106 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154585 | **DUT** | IN  pkt #106 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154585 | yapp monitor | RX pkt #106 on the input: addr=0 len=2 parity=bad gap=2 |
| 154585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 154630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 154765 | **DUT** | IN  pkt #107 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154795 | **DUT** | IN  pkt #107 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154795 | yapp monitor | RX pkt #107 on the input: addr=0 len=2 parity=bad gap=17 |
| 154795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154795 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 154925 | **DUT** | IN  pkt #108 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154955 | **DUT** | IN  pkt #108 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154955 | yapp monitor | RX pkt #108 on the input: addr=0 len=2 parity=bad gap=12 |
| 154955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 155165 | **DUT** | IN  pkt #109 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155195 | **DUT** | IN  pkt #109 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155195 | yapp monitor | RX pkt #109 on the input: addr=0 len=2 parity=bad gap=20 |
| 155195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 155305 | **DUT** | IN  pkt #110 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155335 | **DUT** | IN  pkt #110 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155335 | yapp monitor | RX pkt #110 on the input: addr=0 len=2 parity=bad gap=10 |
| 155335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 155545 | **DUT** | IN  pkt #111 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155575 | **DUT** | IN  pkt #111 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155575 | yapp monitor | RX pkt #111 on the input: addr=0 len=2 parity=bad gap=20 |
| 155575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 155785 | **DUT** | IN  pkt #112 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155815 | **DUT** | IN  pkt #112 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155815 | yapp monitor | RX pkt #112 on the input: addr=0 len=2 parity=bad gap=20 |
| 155815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155910 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 156025 | **DUT** | IN  pkt #113 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156055 | **DUT** | IN  pkt #113 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156055 | yapp monitor | RX pkt #113 on the input: addr=0 len=2 parity=bad gap=20 |
| 156055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 156225 | **DUT** | IN  pkt #114 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156255 | **DUT** | IN  pkt #114 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156255 | yapp monitor | RX pkt #114 on the input: addr=0 len=2 parity=bad gap=16 |
| 156255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156445 | **DUT** | IN  pkt #115 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156475 | **DUT** | IN  pkt #115 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156475 | yapp monitor | RX pkt #115 on the input: addr=0 len=2 parity=bad gap=18 |
| 156475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 156535 | **DUT** | IN  pkt #116 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156565 | **DUT** | IN  pkt #116 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156565 | yapp monitor | RX pkt #116 on the input: addr=0 len=2 parity=bad gap=5 |
| 156565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 156695 | **DUT** | IN  pkt #117 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156725 | **DUT** | IN  pkt #117 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156725 | yapp monitor | RX pkt #117 on the input: addr=0 len=2 parity=bad gap=12 |
| 156725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156745 | **DUT** | IN  pkt #118 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 156775 | **DUT** | IN  pkt #118 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156775 | yapp monitor | RX pkt #118 on the input: addr=0 len=2 parity=bad gap=1 |
| 156775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 156985 | **DUT** | IN  pkt #119 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157015 | **DUT** | IN  pkt #119 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157015 | yapp monitor | RX pkt #119 on the input: addr=0 len=2 parity=bad gap=20 |
| 157015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157015 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 157225 | **DUT** | IN  pkt #120 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157255 | **DUT** | IN  pkt #120 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157255 | yapp monitor | RX pkt #120 on the input: addr=0 len=2 parity=bad gap=20 |
| 157255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157275 | **DUT** | IN  pkt #121 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157305 | **DUT** | IN  pkt #121 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157305 | yapp monitor | RX pkt #121 on the input: addr=0 len=2 parity=bad gap=1 |
| 157305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 157360 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 157465 | **DUT** | IN  pkt #122 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157495 | **DUT** | IN  pkt #122 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157495 | yapp monitor | RX pkt #122 on the input: addr=0 len=2 parity=bad gap=15 |
| 157495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 157565 | **DUT** | IN  pkt #123 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157595 | **DUT** | IN  pkt #123 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157595 | yapp monitor | RX pkt #123 on the input: addr=0 len=2 parity=bad gap=6 |
| 157595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 157725 | **DUT** | IN  pkt #124 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157755 | **DUT** | IN  pkt #124 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157755 | yapp monitor | RX pkt #124 on the input: addr=0 len=2 parity=bad gap=12 |
| 157755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 157775 | **DUT** | IN  pkt #125 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157805 | **DUT** | IN  pkt #125 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157805 | yapp monitor | RX pkt #125 on the input: addr=0 len=2 parity=bad gap=1 |
| 157805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157805 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 158015 | **DUT** | IN  pkt #126 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158045 | **DUT** | IN  pkt #126 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158045 | yapp monitor | RX pkt #126 on the input: addr=0 len=2 parity=bad gap=20 |
| 158045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158045 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158065 | **DUT** | IN  pkt #127 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158095 | **DUT** | IN  pkt #127 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158095 | yapp monitor | RX pkt #127 on the input: addr=0 len=2 parity=bad gap=1 |
| 158095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 158135 | **DUT** | IN  pkt #128 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158140 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 158165 | **DUT** | IN  pkt #128 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158165 | yapp monitor | RX pkt #128 on the input: addr=0 len=2 parity=bad gap=3 |
| 158165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 158375 | **DUT** | IN  pkt #129 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158405 | **DUT** | IN  pkt #129 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158405 | yapp monitor | RX pkt #129 on the input: addr=0 len=2 parity=bad gap=20 |
| 158405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 158595 | **DUT** | IN  pkt #130 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158625 | **DUT** | IN  pkt #130 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158625 | yapp monitor | RX pkt #130 on the input: addr=0 len=2 parity=bad gap=18 |
| 158625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 158825 | **DUT** | IN  pkt #131 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158855 | **DUT** | IN  pkt #131 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158855 | yapp monitor | RX pkt #131 on the input: addr=0 len=2 parity=bad gap=19 |
| 158855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 159055 | **DUT** | IN  pkt #132 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159085 | **DUT** | IN  pkt #132 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159085 | yapp monitor | RX pkt #132 on the input: addr=0 len=2 parity=bad gap=19 |
| 159085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159135 | **DUT** | IN  pkt #133 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 159165 | **DUT** | IN  pkt #133 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159165 | yapp monitor | RX pkt #133 on the input: addr=0 len=2 parity=bad gap=4 |
| 159165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 159375 | **DUT** | IN  pkt #134 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159405 | **DUT** | IN  pkt #134 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159405 | yapp monitor | RX pkt #134 on the input: addr=0 len=2 parity=bad gap=20 |
| 159405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 159615 | **DUT** | IN  pkt #135 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159645 | **DUT** | IN  pkt #135 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159645 | yapp monitor | RX pkt #135 on the input: addr=0 len=2 parity=bad gap=20 |
| 159645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 159755 | **DUT** | IN  pkt #136 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159785 | **DUT** | IN  pkt #136 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159785 | yapp monitor | RX pkt #136 on the input: addr=0 len=2 parity=bad gap=10 |
| 159785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 159895 | **DUT** | IN  pkt #137 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159925 | **DUT** | IN  pkt #137 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159925 | yapp monitor | RX pkt #137 on the input: addr=0 len=2 parity=bad gap=10 |
| 159925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 159975 | **DUT** | IN  pkt #138 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160005 | **DUT** | IN  pkt #138 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160005 | yapp monitor | RX pkt #138 on the input: addr=0 len=2 parity=bad gap=4 |
| 160005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 160155 | **DUT** | IN  pkt #139 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160185 | **DUT** | IN  pkt #139 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160185 | yapp monitor | RX pkt #139 on the input: addr=0 len=2 parity=bad gap=14 |
| 160185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 160335 | **DUT** | IN  pkt #140 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160365 | **DUT** | IN  pkt #140 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160365 | yapp monitor | RX pkt #140 on the input: addr=0 len=2 parity=bad gap=14 |
| 160365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160385 | **DUT** | IN  pkt #141 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160415 | **DUT** | IN  pkt #141 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160415 | yapp monitor | RX pkt #141 on the input: addr=0 len=2 parity=bad gap=1 |
| 160415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 160470 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 160535 | **DUT** | IN  pkt #142 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160565 | **DUT** | IN  pkt #142 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160565 | yapp monitor | RX pkt #142 on the input: addr=0 len=2 parity=bad gap=11 |
| 160565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 160675 | **DUT** | IN  pkt #143 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160705 | **DUT** | IN  pkt #143 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160705 | yapp monitor | RX pkt #143 on the input: addr=0 len=2 parity=bad gap=10 |
| 160705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 160845 | **DUT** | IN  pkt #144 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160875 | **DUT** | IN  pkt #144 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160875 | yapp monitor | RX pkt #144 on the input: addr=0 len=2 parity=bad gap=13 |
| 160875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160875 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160910 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 161085 | **DUT** | IN  pkt #145 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161115 | **DUT** | IN  pkt #145 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161115 | yapp monitor | RX pkt #145 on the input: addr=0 len=2 parity=bad gap=20 |
| 161115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 161185 | **DUT** | IN  pkt #146 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161215 | **DUT** | IN  pkt #146 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161215 | yapp monitor | RX pkt #146 on the input: addr=0 len=2 parity=bad gap=6 |
| 161215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 161365 | **DUT** | IN  pkt #147 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161395 | **DUT** | IN  pkt #147 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161395 | yapp monitor | RX pkt #147 on the input: addr=0 len=2 parity=bad gap=14 |
| 161395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 161475 | **DUT** | IN  pkt #148 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161505 | **DUT** | IN  pkt #148 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161505 | yapp monitor | RX pkt #148 on the input: addr=0 len=2 parity=bad gap=7 |
| 161505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161505 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 161695 | **DUT** | IN  pkt #149 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161725 | **DUT** | IN  pkt #149 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161725 | yapp monitor | RX pkt #149 on the input: addr=0 len=2 parity=bad gap=18 |
| 161725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 161915 | **DUT** | IN  pkt #150 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161945 | **DUT** | IN  pkt #150 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161945 | yapp monitor | RX pkt #150 on the input: addr=0 len=2 parity=bad gap=18 |
| 161945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 162125 | **DUT** | IN  pkt #151 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162155 | **DUT** | IN  pkt #151 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162155 | yapp monitor | RX pkt #151 on the input: addr=0 len=2 parity=bad gap=17 |
| 162155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 162255 | **DUT** | IN  pkt #152 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162285 | **DUT** | IN  pkt #152 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162285 | yapp monitor | RX pkt #152 on the input: addr=0 len=2 parity=bad gap=9 |
| 162285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162285 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162345 | **DUT** | IN  pkt #153 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 162375 | **DUT** | IN  pkt #153 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162375 | yapp monitor | RX pkt #153 on the input: addr=0 len=2 parity=bad gap=5 |
| 162375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 162585 | **DUT** | IN  pkt #154 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162615 | **DUT** | IN  pkt #154 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162615 | yapp monitor | RX pkt #154 on the input: addr=0 len=2 parity=bad gap=20 |
| 162615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 162765 | **DUT** | IN  pkt #155 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162795 | **DUT** | IN  pkt #155 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162795 | yapp monitor | RX pkt #155 on the input: addr=0 len=2 parity=bad gap=14 |
| 162795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162795 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 162925 | **DUT** | IN  pkt #156 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162955 | **DUT** | IN  pkt #156 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162955 | yapp monitor | RX pkt #156 on the input: addr=0 len=2 parity=bad gap=12 |
| 162955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 163125 | **DUT** | IN  pkt #157 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163155 | **DUT** | IN  pkt #157 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163155 | yapp monitor | RX pkt #157 on the input: addr=0 len=2 parity=bad gap=16 |
| 163155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163230 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 163365 | **DUT** | IN  pkt #158 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163395 | **DUT** | IN  pkt #158 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163395 | yapp monitor | RX pkt #158 on the input: addr=0 len=2 parity=bad gap=20 |
| 163395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 163495 | **DUT** | IN  pkt #159 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163525 | **DUT** | IN  pkt #159 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163525 | yapp monitor | RX pkt #159 on the input: addr=0 len=2 parity=bad gap=9 |
| 163525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 163695 | **DUT** | IN  pkt #160 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163725 | **DUT** | IN  pkt #160 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163725 | yapp monitor | RX pkt #160 on the input: addr=0 len=2 parity=bad gap=16 |
| 163725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 163825 | **DUT** | IN  pkt #161 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163855 | **DUT** | IN  pkt #161 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163855 | yapp monitor | RX pkt #161 on the input: addr=0 len=2 parity=bad gap=9 |
| 163855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 163895 | **DUT** | IN  pkt #162 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163925 | **DUT** | IN  pkt #162 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163925 | yapp monitor | RX pkt #162 on the input: addr=0 len=2 parity=bad gap=3 |
| 163925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 164025 | **DUT** | IN  pkt #163 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164055 | **DUT** | IN  pkt #163 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164055 | yapp monitor | RX pkt #163 on the input: addr=0 len=2 parity=bad gap=9 |
| 164055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 164115 | **DUT** | IN  pkt #164 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164145 | **DUT** | IN  pkt #164 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164145 | yapp monitor | RX pkt #164 on the input: addr=0 len=2 parity=bad gap=5 |
| 164145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164245 | **DUT** | IN  pkt #165 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164250 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 164275 | **DUT** | IN  pkt #165 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164275 | yapp monitor | RX pkt #165 on the input: addr=0 len=2 parity=bad gap=9 |
| 164275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164345 | **DUT** | IN  pkt #166 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 164375 | **DUT** | IN  pkt #166 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164375 | yapp monitor | RX pkt #166 on the input: addr=0 len=2 parity=bad gap=6 |
| 164375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 164585 | **DUT** | IN  pkt #167 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164615 | **DUT** | IN  pkt #167 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164615 | yapp monitor | RX pkt #167 on the input: addr=0 len=2 parity=bad gap=20 |
| 164615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164645 | **DUT** | IN  pkt #168 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164675 | **DUT** | IN  pkt #168 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164675 | yapp monitor | RX pkt #168 on the input: addr=0 len=2 parity=bad gap=2 |
| 164675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 164730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 164855 | **DUT** | IN  pkt #169 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164885 | **DUT** | IN  pkt #169 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164885 | yapp monitor | RX pkt #169 on the input: addr=0 len=2 parity=bad gap=17 |
| 164885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 165095 | **DUT** | IN  pkt #170 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165125 | **DUT** | IN  pkt #170 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165125 | yapp monitor | RX pkt #170 on the input: addr=0 len=2 parity=bad gap=20 |
| 165125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 165335 | **DUT** | IN  pkt #171 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165365 | **DUT** | IN  pkt #171 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165365 | yapp monitor | RX pkt #171 on the input: addr=0 len=2 parity=bad gap=20 |
| 165365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 165535 | **DUT** | IN  pkt #172 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165565 | **DUT** | IN  pkt #172 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165565 | yapp monitor | RX pkt #172 on the input: addr=0 len=2 parity=bad gap=16 |
| 165565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165645 | **DUT** | IN  pkt #173 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 165675 | **DUT** | IN  pkt #173 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165675 | yapp monitor | RX pkt #173 on the input: addr=0 len=2 parity=bad gap=7 |
| 165675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 165865 | **DUT** | IN  pkt #174 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165895 | **DUT** | IN  pkt #174 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165895 | yapp monitor | RX pkt #174 on the input: addr=0 len=2 parity=bad gap=18 |
| 165895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 166005 | **DUT** | IN  pkt #175 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166035 | **DUT** | IN  pkt #175 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166035 | yapp monitor | RX pkt #175 on the input: addr=0 len=2 parity=bad gap=10 |
| 166035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166035 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 166195 | **DUT** | IN  pkt #176 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166225 | **DUT** | IN  pkt #176 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166225 | yapp monitor | RX pkt #176 on the input: addr=0 len=2 parity=bad gap=15 |
| 166225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 166415 | **DUT** | IN  pkt #177 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166445 | **DUT** | IN  pkt #177 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166445 | yapp monitor | RX pkt #177 on the input: addr=0 len=2 parity=bad gap=18 |
| 166445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 166655 | **DUT** | IN  pkt #178 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166685 | **DUT** | IN  pkt #178 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166685 | yapp monitor | RX pkt #178 on the input: addr=0 len=2 parity=bad gap=20 |
| 166685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166770 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 166895 | **DUT** | IN  pkt #179 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166925 | **DUT** | IN  pkt #179 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166925 | yapp monitor | RX pkt #179 on the input: addr=0 len=2 parity=bad gap=20 |
| 166925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 167135 | **DUT** | IN  pkt #180 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167165 | **DUT** | IN  pkt #180 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167165 | yapp monitor | RX pkt #180 on the input: addr=0 len=2 parity=bad gap=20 |
| 167165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 167265 | **DUT** | IN  pkt #181 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167295 | **DUT** | IN  pkt #181 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167295 | yapp monitor | RX pkt #181 on the input: addr=0 len=2 parity=bad gap=9 |
| 167295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 167355 | **DUT** | IN  pkt #182 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167385 | **DUT** | IN  pkt #182 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167385 | yapp monitor | RX pkt #182 on the input: addr=0 len=2 parity=bad gap=5 |
| 167385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167430 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 167585 | **DUT** | IN  pkt #183 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167615 | **DUT** | IN  pkt #183 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167615 | yapp monitor | RX pkt #183 on the input: addr=0 len=2 parity=bad gap=19 |
| 167615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 167805 | **DUT** | IN  pkt #184 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167835 | **DUT** | IN  pkt #184 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167835 | yapp monitor | RX pkt #184 on the input: addr=0 len=2 parity=bad gap=18 |
| 167835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 168045 | **DUT** | IN  pkt #185 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168075 | **DUT** | IN  pkt #185 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168075 | yapp monitor | RX pkt #185 on the input: addr=0 len=2 parity=bad gap=20 |
| 168075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168110 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 168285 | **DUT** | IN  pkt #186 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168315 | **DUT** | IN  pkt #186 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168315 | yapp monitor | RX pkt #186 on the input: addr=0 len=2 parity=bad gap=20 |
| 168315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 168515 | **DUT** | IN  pkt #187 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168545 | **DUT** | IN  pkt #187 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168545 | yapp monitor | RX pkt #187 on the input: addr=0 len=2 parity=bad gap=19 |
| 168545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 168705 | **DUT** | IN  pkt #188 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168735 | **DUT** | IN  pkt #188 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168735 | yapp monitor | RX pkt #188 on the input: addr=0 len=2 parity=bad gap=15 |
| 168735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 168945 | **DUT** | IN  pkt #189 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168975 | **DUT** | IN  pkt #189 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168975 | yapp monitor | RX pkt #189 on the input: addr=0 len=2 parity=bad gap=20 |
| 168975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168995 | **DUT** | IN  pkt #190 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 169025 | **DUT** | IN  pkt #190 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169025 | yapp monitor | RX pkt #190 on the input: addr=0 len=2 parity=bad gap=1 |
| 169025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169045 | **DUT** | IN  pkt #191 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 169075 | **DUT** | IN  pkt #191 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169075 | yapp monitor | RX pkt #191 on the input: addr=0 len=2 parity=bad gap=1 |
| 169075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 169175 | **DUT** | IN  pkt #192 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169205 | **DUT** | IN  pkt #192 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169205 | yapp monitor | RX pkt #192 on the input: addr=0 len=2 parity=bad gap=9 |
| 169205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169250 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 169305 | **DUT** | IN  pkt #193 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169335 | **DUT** | IN  pkt #193 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169335 | yapp monitor | RX pkt #193 on the input: addr=0 len=2 parity=bad gap=9 |
| 169335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 169355 | **DUT** | IN  pkt #194 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169385 | **DUT** | IN  pkt #194 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169385 | yapp monitor | RX pkt #194 on the input: addr=0 len=2 parity=bad gap=1 |
| 169385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 169595 | **DUT** | IN  pkt #195 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169625 | **DUT** | IN  pkt #195 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169625 | yapp monitor | RX pkt #195 on the input: addr=0 len=2 parity=bad gap=20 |
| 169625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 169815 | **DUT** | IN  pkt #196 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169845 | **DUT** | IN  pkt #196 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169845 | yapp monitor | RX pkt #196 on the input: addr=0 len=2 parity=bad gap=18 |
| 169845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169890 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 170035 | **DUT** | IN  pkt #197 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170065 | **DUT** | IN  pkt #197 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170065 | yapp monitor | RX pkt #197 on the input: addr=0 len=2 parity=bad gap=18 |
| 170065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170065 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 170275 | **DUT** | IN  pkt #198 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170305 | **DUT** | IN  pkt #198 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170305 | yapp monitor | RX pkt #198 on the input: addr=0 len=2 parity=bad gap=20 |
| 170305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170325 | **DUT** | IN  pkt #199 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 170355 | **DUT** | IN  pkt #199 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170355 | yapp monitor | RX pkt #199 on the input: addr=0 len=2 parity=bad gap=1 |
| 170355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 170565 | **DUT** | IN  pkt #200 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170595 | **DUT** | IN  pkt #200 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170595 | yapp monitor | RX pkt #200 on the input: addr=0 len=2 parity=bad gap=20 |
| 170595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 170805 | **DUT** | IN  pkt #201 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170835 | **DUT** | IN  pkt #201 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170835 | yapp monitor | RX pkt #201 on the input: addr=0 len=2 parity=bad gap=20 |
| 170835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 170955 | **DUT** | IN  pkt #202 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170985 | **DUT** | IN  pkt #202 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170985 | yapp monitor | RX pkt #202 on the input: addr=0 len=2 parity=bad gap=11 |
| 170985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170985 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 171145 | **DUT** | IN  pkt #203 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171175 | **DUT** | IN  pkt #203 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171175 | yapp monitor | RX pkt #203 on the input: addr=0 len=2 parity=bad gap=15 |
| 171175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171175 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 171295 | **DUT** | IN  pkt #204 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171325 | **DUT** | IN  pkt #204 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171325 | yapp monitor | RX pkt #204 on the input: addr=0 len=2 parity=bad gap=11 |
| 171325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 171485 | **DUT** | IN  pkt #205 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171515 | **DUT** | IN  pkt #205 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171515 | yapp monitor | RX pkt #205 on the input: addr=0 len=2 parity=bad gap=15 |
| 171515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 171655 | **DUT** | IN  pkt #206 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171685 | **DUT** | IN  pkt #206 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171685 | yapp monitor | RX pkt #206 on the input: addr=0 len=2 parity=bad gap=13 |
| 171685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 171865 | **DUT** | IN  pkt #207 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171895 | **DUT** | IN  pkt #207 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171895 | yapp monitor | RX pkt #207 on the input: addr=0 len=2 parity=bad gap=17 |
| 171895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 171935 | **DUT** | IN  pkt #208 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171965 | **DUT** | IN  pkt #208 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171965 | yapp monitor | RX pkt #208 on the input: addr=0 len=2 parity=bad gap=3 |
| 171965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 172155 | **DUT** | IN  pkt #209 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172185 | **DUT** | IN  pkt #209 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172185 | yapp monitor | RX pkt #209 on the input: addr=0 len=2 parity=bad gap=18 |
| 172185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 172245 | **DUT** | IN  pkt #210 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172275 | **DUT** | IN  pkt #210 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172275 | yapp monitor | RX pkt #210 on the input: addr=0 len=2 parity=bad gap=5 |
| 172275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 172485 | **DUT** | IN  pkt #211 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172515 | **DUT** | IN  pkt #211 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172515 | yapp monitor | RX pkt #211 on the input: addr=0 len=2 parity=bad gap=20 |
| 172515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 172725 | **DUT** | IN  pkt #212 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172755 | **DUT** | IN  pkt #212 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172755 | yapp monitor | RX pkt #212 on the input: addr=0 len=2 parity=bad gap=20 |
| 172755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 172965 | **DUT** | IN  pkt #213 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172995 | **DUT** | IN  pkt #213 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172995 | yapp monitor | RX pkt #213 on the input: addr=0 len=2 parity=bad gap=20 |
| 172995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 173205 | **DUT** | IN  pkt #214 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173235 | **DUT** | IN  pkt #214 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173235 | yapp monitor | RX pkt #214 on the input: addr=0 len=2 parity=bad gap=20 |
| 173235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 173445 | **DUT** | IN  pkt #215 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173475 | **DUT** | IN  pkt #215 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173475 | yapp monitor | RX pkt #215 on the input: addr=0 len=2 parity=bad gap=20 |
| 173475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 173675 | **DUT** | IN  pkt #216 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173705 | **DUT** | IN  pkt #216 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173705 | yapp monitor | RX pkt #216 on the input: addr=0 len=2 parity=bad gap=19 |
| 173705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 173915 | **DUT** | IN  pkt #217 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173945 | **DUT** | IN  pkt #217 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173945 | yapp monitor | RX pkt #217 on the input: addr=0 len=2 parity=bad gap=20 |
| 173945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 174095 | **DUT** | IN  pkt #218 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174125 | **DUT** | IN  pkt #218 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174125 | yapp monitor | RX pkt #218 on the input: addr=0 len=2 parity=bad gap=14 |
| 174125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 174335 | **DUT** | IN  pkt #219 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174365 | **DUT** | IN  pkt #219 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174365 | yapp monitor | RX pkt #219 on the input: addr=0 len=2 parity=bad gap=20 |
| 174365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 174515 | **DUT** | IN  pkt #220 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174545 | **DUT** | IN  pkt #220 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174545 | yapp monitor | RX pkt #220 on the input: addr=0 len=2 parity=bad gap=14 |
| 174545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 174755 | **DUT** | IN  pkt #221 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174785 | **DUT** | IN  pkt #221 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174785 | yapp monitor | RX pkt #221 on the input: addr=0 len=2 parity=bad gap=20 |
| 174785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 174995 | **DUT** | IN  pkt #222 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175025 | **DUT** | IN  pkt #222 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175025 | yapp monitor | RX pkt #222 on the input: addr=0 len=2 parity=bad gap=20 |
| 175025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 175175 | **DUT** | IN  pkt #223 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175205 | **DUT** | IN  pkt #223 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175205 | yapp monitor | RX pkt #223 on the input: addr=0 len=2 parity=bad gap=14 |
| 175205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 175375 | **DUT** | IN  pkt #224 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175405 | **DUT** | IN  pkt #224 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175405 | yapp monitor | RX pkt #224 on the input: addr=0 len=2 parity=bad gap=16 |
| 175405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 175605 | **DUT** | IN  pkt #225 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175635 | **DUT** | IN  pkt #225 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175635 | yapp monitor | RX pkt #225 on the input: addr=0 len=2 parity=bad gap=19 |
| 175635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175635 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 175725 | **DUT** | IN  pkt #226 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175755 | **DUT** | IN  pkt #226 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175755 | yapp monitor | RX pkt #226 on the input: addr=0 len=2 parity=bad gap=8 |
| 175755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 175875 | **DUT** | IN  pkt #227 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175905 | **DUT** | IN  pkt #227 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175905 | yapp monitor | RX pkt #227 on the input: addr=0 len=2 parity=bad gap=11 |
| 175905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175925 | **DUT** | IN  pkt #228 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175930 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 175955 | **DUT** | IN  pkt #228 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175955 | yapp monitor | RX pkt #228 on the input: addr=0 len=2 parity=bad gap=1 |
| 175955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 176155 | **DUT** | IN  pkt #229 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176185 | **DUT** | IN  pkt #229 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176185 | yapp monitor | RX pkt #229 on the input: addr=0 len=2 parity=bad gap=19 |
| 176185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 176395 | **DUT** | IN  pkt #230 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176425 | **DUT** | IN  pkt #230 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176425 | yapp monitor | RX pkt #230 on the input: addr=0 len=2 parity=bad gap=20 |
| 176425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176425 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 176625 | **DUT** | IN  pkt #231 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176655 | **DUT** | IN  pkt #231 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176655 | yapp monitor | RX pkt #231 on the input: addr=0 len=2 parity=bad gap=19 |
| 176655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176690 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 176785 | **DUT** | IN  pkt #232 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176815 | **DUT** | IN  pkt #232 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176815 | yapp monitor | RX pkt #232 on the input: addr=0 len=2 parity=bad gap=12 |
| 176815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 176995 | **DUT** | IN  pkt #233 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177025 | **DUT** | IN  pkt #233 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177025 | yapp monitor | RX pkt #233 on the input: addr=0 len=2 parity=bad gap=17 |
| 177025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 177235 | **DUT** | IN  pkt #234 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177265 | **DUT** | IN  pkt #234 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177265 | yapp monitor | RX pkt #234 on the input: addr=0 len=2 parity=bad gap=20 |
| 177265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177265 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 177465 | **DUT** | IN  pkt #235 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177495 | **DUT** | IN  pkt #235 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177495 | yapp monitor | RX pkt #235 on the input: addr=0 len=2 parity=bad gap=19 |
| 177495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 177695 | **DUT** | IN  pkt #236 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177725 | **DUT** | IN  pkt #236 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177725 | yapp monitor | RX pkt #236 on the input: addr=0 len=2 parity=bad gap=19 |
| 177725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 177845 | **DUT** | IN  pkt #237 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177875 | **DUT** | IN  pkt #237 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177875 | yapp monitor | RX pkt #237 on the input: addr=0 len=2 parity=bad gap=11 |
| 177875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177875 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 178085 | **DUT** | IN  pkt #238 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178115 | **DUT** | IN  pkt #238 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178115 | yapp monitor | RX pkt #238 on the input: addr=0 len=2 parity=bad gap=20 |
| 178115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 178325 | **DUT** | IN  pkt #239 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178355 | **DUT** | IN  pkt #239 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178355 | yapp monitor | RX pkt #239 on the input: addr=0 len=2 parity=bad gap=20 |
| 178355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 178515 | **DUT** | IN  pkt #240 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178545 | **DUT** | IN  pkt #240 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178545 | yapp monitor | RX pkt #240 on the input: addr=0 len=2 parity=bad gap=15 |
| 178545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 178755 | **DUT** | IN  pkt #241 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178785 | **DUT** | IN  pkt #241 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178785 | yapp monitor | RX pkt #241 on the input: addr=0 len=2 parity=bad gap=20 |
| 178785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 178835 | **DUT** | IN  pkt #242 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178865 | **DUT** | IN  pkt #242 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178865 | yapp monitor | RX pkt #242 on the input: addr=0 len=2 parity=bad gap=4 |
| 178865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178865 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178885 | **DUT** | IN  pkt #243 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178915 | **DUT** | IN  pkt #243 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178915 | yapp monitor | RX pkt #243 on the input: addr=0 len=2 parity=bad gap=1 |
| 178915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 178980 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 178995 | **DUT** | IN  pkt #244 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179025 | **DUT** | IN  pkt #244 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179025 | yapp monitor | RX pkt #244 on the input: addr=0 len=2 parity=bad gap=7 |
| 179025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179075 | **DUT** | IN  pkt #245 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179105 | **DUT** | IN  pkt #245 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179105 | yapp monitor | RX pkt #245 on the input: addr=0 len=2 parity=bad gap=4 |
| 179105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 179140 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 179315 | **DUT** | IN  pkt #246 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179345 | **DUT** | IN  pkt #246 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179345 | yapp monitor | RX pkt #246 on the input: addr=0 len=2 parity=bad gap=20 |
| 179345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179345 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 179555 | **DUT** | IN  pkt #247 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179585 | **DUT** | IN  pkt #247 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179585 | yapp monitor | RX pkt #247 on the input: addr=0 len=2 parity=bad gap=20 |
| 179585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 179795 | **DUT** | IN  pkt #248 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179825 | **DUT** | IN  pkt #248 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179825 | yapp monitor | RX pkt #248 on the input: addr=0 len=2 parity=bad gap=20 |
| 179825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179925 | **DUT** | IN  pkt #249 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 179955 | **DUT** | IN  pkt #249 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179955 | yapp monitor | RX pkt #249 on the input: addr=0 len=2 parity=bad gap=9 |
| 179955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 180165 | **DUT** | IN  pkt #250 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180195 | **DUT** | IN  pkt #250 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180195 | yapp monitor | RX pkt #250 on the input: addr=0 len=2 parity=bad gap=20 |
| 180195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180225 | **DUT** | IN  pkt #251 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 180255 | **DUT** | IN  pkt #251 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180255 | yapp monitor | RX pkt #251 on the input: addr=0 len=2 parity=bad gap=2 |
| 180255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180285 | **DUT** | IN  pkt #252 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 180315 | **DUT** | IN  pkt #252 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180315 | yapp monitor | RX pkt #252 on the input: addr=0 len=2 parity=bad gap=2 |
| 180315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 180525 | **DUT** | IN  pkt #253 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180555 | **DUT** | IN  pkt #253 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180555 | yapp monitor | RX pkt #253 on the input: addr=0 len=2 parity=bad gap=20 |
| 180555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 180725 | **DUT** | IN  pkt #254 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180755 | **DUT** | IN  pkt #254 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180755 | yapp monitor | RX pkt #254 on the input: addr=0 len=2 parity=bad gap=16 |
| 180755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 180875 | **DUT** | IN  pkt #255 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180905 | **DUT** | IN  pkt #255 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180905 | yapp monitor | RX pkt #255 on the input: addr=0 len=2 parity=bad gap=11 |
| 180905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180925 | **DUT** | IN  pkt #256 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180955 | **DUT** | IN  pkt #256 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180955 | yapp monitor | RX pkt #256 on the input: addr=0 len=2 parity=bad gap=1 |
| 180955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180970 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 180980 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 180995 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 181025 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 181055 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 181085 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 181115 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 181140 | **test** | STAGE: 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 181145 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 181165 | hbus monitor | Collected WRITE addr=0x1001 data=0x21 |
| 181165 | reference | router_en is now 1 (en_reg 0x21) |
| 181375 | **DUT** | IN  pkt #257 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181405 | **DUT** | IN  pkt #257 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181405 | yapp monitor | RX pkt #257 on the input: addr=1 len=2 parity=bad gap=41 |
| 181405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 181575 | **DUT** | IN  pkt #258 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181605 | **DUT** | IN  pkt #258 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181605 | yapp monitor | RX pkt #258 on the input: addr=1 len=2 parity=bad gap=16 |
| 181605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 181815 | **DUT** | IN  pkt #259 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181845 | **DUT** | IN  pkt #259 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181845 | yapp monitor | RX pkt #259 on the input: addr=1 len=2 parity=bad gap=20 |
| 181845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181845 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181890 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 182015 | **DUT** | IN  pkt #260 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182045 | **DUT** | IN  pkt #260 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182045 | yapp monitor | RX pkt #260 on the input: addr=1 len=2 parity=bad gap=16 |
| 182045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182085 | **DUT** | IN  pkt #261 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182115 | **DUT** | IN  pkt #261 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182115 | yapp monitor | RX pkt #261 on the input: addr=1 len=2 parity=bad gap=3 |
| 182115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 182170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 182295 | **DUT** | IN  pkt #262 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182325 | **DUT** | IN  pkt #262 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182325 | yapp monitor | RX pkt #262 on the input: addr=1 len=2 parity=bad gap=17 |
| 182325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 182505 | **DUT** | IN  pkt #263 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182535 | **DUT** | IN  pkt #263 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182535 | yapp monitor | RX pkt #263 on the input: addr=1 len=2 parity=bad gap=17 |
| 182535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182625 | **DUT** | IN  pkt #264 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 182655 | **DUT** | IN  pkt #264 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182655 | yapp monitor | RX pkt #264 on the input: addr=1 len=2 parity=bad gap=8 |
| 182655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 182865 | **DUT** | IN  pkt #265 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182895 | **DUT** | IN  pkt #265 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182895 | yapp monitor | RX pkt #265 on the input: addr=1 len=2 parity=bad gap=20 |
| 182895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182915 | **DUT** | IN  pkt #266 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 182945 | **DUT** | IN  pkt #266 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182945 | yapp monitor | RX pkt #266 on the input: addr=1 len=2 parity=bad gap=1 |
| 182945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 182995 | **DUT** | IN  pkt #267 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183025 | **DUT** | IN  pkt #267 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183025 | yapp monitor | RX pkt #267 on the input: addr=1 len=2 parity=bad gap=4 |
| 183025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183125 | **DUT** | IN  pkt #268 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 183155 | **DUT** | IN  pkt #268 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183155 | yapp monitor | RX pkt #268 on the input: addr=1 len=2 parity=bad gap=9 |
| 183155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183215 | **DUT** | IN  pkt #269 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183230 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 183245 | **DUT** | IN  pkt #269 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183245 | yapp monitor | RX pkt #269 on the input: addr=1 len=2 parity=bad gap=5 |
| 183245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 183325 | **DUT** | IN  pkt #270 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183355 | **DUT** | IN  pkt #270 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183355 | yapp monitor | RX pkt #270 on the input: addr=1 len=2 parity=bad gap=7 |
| 183355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 183435 | **DUT** | IN  pkt #271 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183465 | **DUT** | IN  pkt #271 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183465 | yapp monitor | RX pkt #271 on the input: addr=1 len=2 parity=bad gap=7 |
| 183465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183485 | **DUT** | IN  pkt #272 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183515 | **DUT** | IN  pkt #272 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183515 | yapp monitor | RX pkt #272 on the input: addr=1 len=2 parity=bad gap=1 |
| 183515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 183540 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 183545 | **DUT** | IN  pkt #273 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183575 | **DUT** | IN  pkt #273 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183575 | yapp monitor | RX pkt #273 on the input: addr=1 len=2 parity=bad gap=2 |
| 183575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 183765 | **DUT** | IN  pkt #274 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183795 | **DUT** | IN  pkt #274 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183795 | yapp monitor | RX pkt #274 on the input: addr=1 len=2 parity=bad gap=18 |
| 183795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 183975 | **DUT** | IN  pkt #275 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184005 | **DUT** | IN  pkt #275 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184005 | yapp monitor | RX pkt #275 on the input: addr=1 len=2 parity=bad gap=17 |
| 184005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 184205 | **DUT** | IN  pkt #276 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184235 | **DUT** | IN  pkt #276 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184235 | yapp monitor | RX pkt #276 on the input: addr=1 len=2 parity=bad gap=19 |
| 184235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 184325 | **DUT** | IN  pkt #277 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184355 | **DUT** | IN  pkt #277 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184355 | yapp monitor | RX pkt #277 on the input: addr=1 len=2 parity=bad gap=8 |
| 184355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184395 | **DUT** | IN  pkt #278 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184410 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 184425 | **DUT** | IN  pkt #278 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184425 | yapp monitor | RX pkt #278 on the input: addr=1 len=2 parity=bad gap=3 |
| 184425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 184605 | **DUT** | IN  pkt #279 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184635 | **DUT** | IN  pkt #279 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184635 | yapp monitor | RX pkt #279 on the input: addr=1 len=2 parity=bad gap=17 |
| 184635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 184765 | **DUT** | IN  pkt #280 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184795 | **DUT** | IN  pkt #280 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184795 | yapp monitor | RX pkt #280 on the input: addr=1 len=2 parity=bad gap=12 |
| 184795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 185005 | **DUT** | IN  pkt #281 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185035 | **DUT** | IN  pkt #281 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185035 | yapp monitor | RX pkt #281 on the input: addr=1 len=2 parity=bad gap=20 |
| 185035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 185205 | **DUT** | IN  pkt #282 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185235 | **DUT** | IN  pkt #282 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185235 | yapp monitor | RX pkt #282 on the input: addr=1 len=2 parity=bad gap=16 |
| 185235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185265 | **DUT** | IN  pkt #283 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185295 | **DUT** | IN  pkt #283 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185295 | yapp monitor | RX pkt #283 on the input: addr=1 len=2 parity=bad gap=2 |
| 185295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 185330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 185425 | **DUT** | IN  pkt #284 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185455 | **DUT** | IN  pkt #284 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185455 | yapp monitor | RX pkt #284 on the input: addr=1 len=2 parity=bad gap=12 |
| 185455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185455 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 185555 | **DUT** | IN  pkt #285 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185585 | **DUT** | IN  pkt #285 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185585 | yapp monitor | RX pkt #285 on the input: addr=1 len=2 parity=bad gap=9 |
| 185585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 185775 | **DUT** | IN  pkt #286 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185805 | **DUT** | IN  pkt #286 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185805 | yapp monitor | RX pkt #286 on the input: addr=1 len=2 parity=bad gap=18 |
| 185805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 185945 | **DUT** | IN  pkt #287 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185975 | **DUT** | IN  pkt #287 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185975 | yapp monitor | RX pkt #287 on the input: addr=1 len=2 parity=bad gap=13 |
| 185975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 186095 | **DUT** | IN  pkt #288 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186125 | **DUT** | IN  pkt #288 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186125 | yapp monitor | RX pkt #288 on the input: addr=1 len=2 parity=bad gap=11 |
| 186125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 186305 | **DUT** | IN  pkt #289 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186335 | **DUT** | IN  pkt #289 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186335 | yapp monitor | RX pkt #289 on the input: addr=1 len=2 parity=bad gap=17 |
| 186335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 186545 | **DUT** | IN  pkt #290 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186575 | **DUT** | IN  pkt #290 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186575 | yapp monitor | RX pkt #290 on the input: addr=1 len=2 parity=bad gap=20 |
| 186575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 186675 | **DUT** | IN  pkt #291 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186705 | **DUT** | IN  pkt #291 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186705 | yapp monitor | RX pkt #291 on the input: addr=1 len=2 parity=bad gap=9 |
| 186705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186725 | **DUT** | IN  pkt #292 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186755 | **DUT** | IN  pkt #292 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186755 | yapp monitor | RX pkt #292 on the input: addr=1 len=2 parity=bad gap=1 |
| 186755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 186820 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 186925 | **DUT** | IN  pkt #293 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186955 | **DUT** | IN  pkt #293 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186955 | yapp monitor | RX pkt #293 on the input: addr=1 len=2 parity=bad gap=16 |
| 186955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 187165 | **DUT** | IN  pkt #294 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187195 | **DUT** | IN  pkt #294 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187195 | yapp monitor | RX pkt #294 on the input: addr=1 len=2 parity=bad gap=20 |
| 187195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 187335 | **DUT** | IN  pkt #295 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187365 | **DUT** | IN  pkt #295 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187365 | yapp monitor | RX pkt #295 on the input: addr=1 len=2 parity=bad gap=13 |
| 187365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187390 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 187565 | **DUT** | IN  pkt #296 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187595 | **DUT** | IN  pkt #296 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187595 | yapp monitor | RX pkt #296 on the input: addr=1 len=2 parity=bad gap=19 |
| 187595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 187805 | **DUT** | IN  pkt #297 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187835 | **DUT** | IN  pkt #297 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187835 | yapp monitor | RX pkt #297 on the input: addr=1 len=2 parity=bad gap=20 |
| 187835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 187965 | **DUT** | IN  pkt #298 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187995 | **DUT** | IN  pkt #298 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187995 | yapp monitor | RX pkt #298 on the input: addr=1 len=2 parity=bad gap=12 |
| 187995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 188205 | **DUT** | IN  pkt #299 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188235 | **DUT** | IN  pkt #299 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188235 | yapp monitor | RX pkt #299 on the input: addr=1 len=2 parity=bad gap=20 |
| 188235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188365 | **DUT** | IN  pkt #300 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188395 | **DUT** | IN  pkt #300 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188395 | yapp monitor | RX pkt #300 on the input: addr=1 len=2 parity=bad gap=12 |
| 188395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188575 | **DUT** | IN  pkt #301 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188605 | **DUT** | IN  pkt #301 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188605 | yapp monitor | RX pkt #301 on the input: addr=1 len=2 parity=bad gap=17 |
| 188605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188685 | **DUT** | IN  pkt #302 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 188715 | **DUT** | IN  pkt #302 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188715 | yapp monitor | RX pkt #302 on the input: addr=1 len=2 parity=bad gap=7 |
| 188715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188925 | **DUT** | IN  pkt #303 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188955 | **DUT** | IN  pkt #303 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188955 | yapp monitor | RX pkt #303 on the input: addr=1 len=2 parity=bad gap=20 |
| 188955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 189015 | **DUT** | IN  pkt #304 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189045 | **DUT** | IN  pkt #304 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189045 | yapp monitor | RX pkt #304 on the input: addr=1 len=2 parity=bad gap=5 |
| 189045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189075 | **DUT** | IN  pkt #305 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 189105 | **DUT** | IN  pkt #305 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189105 | yapp monitor | RX pkt #305 on the input: addr=1 len=2 parity=bad gap=2 |
| 189105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 189315 | **DUT** | IN  pkt #306 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189345 | **DUT** | IN  pkt #306 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189345 | yapp monitor | RX pkt #306 on the input: addr=1 len=2 parity=bad gap=20 |
| 189345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 189375 | **DUT** | IN  pkt #307 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189405 | **DUT** | IN  pkt #307 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189405 | yapp monitor | RX pkt #307 on the input: addr=1 len=2 parity=bad gap=2 |
| 189405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189465 | **DUT** | IN  pkt #308 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 189495 | **DUT** | IN  pkt #308 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189495 | yapp monitor | RX pkt #308 on the input: addr=1 len=2 parity=bad gap=5 |
| 189495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189495 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 189665 | **DUT** | IN  pkt #309 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189695 | **DUT** | IN  pkt #309 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189695 | yapp monitor | RX pkt #309 on the input: addr=1 len=2 parity=bad gap=16 |
| 189695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 189905 | **DUT** | IN  pkt #310 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189935 | **DUT** | IN  pkt #310 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189935 | yapp monitor | RX pkt #310 on the input: addr=1 len=2 parity=bad gap=20 |
| 189935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 190145 | **DUT** | IN  pkt #311 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190175 | **DUT** | IN  pkt #311 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190175 | yapp monitor | RX pkt #311 on the input: addr=1 len=2 parity=bad gap=20 |
| 190175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190175 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 190385 | **DUT** | IN  pkt #312 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190415 | **DUT** | IN  pkt #312 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190415 | yapp monitor | RX pkt #312 on the input: addr=1 len=2 parity=bad gap=20 |
| 190415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190450 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 190485 | **DUT** | IN  pkt #313 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190515 | **DUT** | IN  pkt #313 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190515 | yapp monitor | RX pkt #313 on the input: addr=1 len=2 parity=bad gap=6 |
| 190515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 190625 | **DUT** | IN  pkt #314 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190655 | **DUT** | IN  pkt #314 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190655 | yapp monitor | RX pkt #314 on the input: addr=1 len=2 parity=bad gap=10 |
| 190655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 190865 | **DUT** | IN  pkt #315 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190895 | **DUT** | IN  pkt #315 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190895 | yapp monitor | RX pkt #315 on the input: addr=1 len=2 parity=bad gap=20 |
| 190895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 191085 | **DUT** | IN  pkt #316 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191115 | **DUT** | IN  pkt #316 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191115 | yapp monitor | RX pkt #316 on the input: addr=1 len=2 parity=bad gap=18 |
| 191115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 191315 | **DUT** | IN  pkt #317 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191345 | **DUT** | IN  pkt #317 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191345 | yapp monitor | RX pkt #317 on the input: addr=1 len=2 parity=bad gap=19 |
| 191345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 191555 | **DUT** | IN  pkt #318 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191585 | **DUT** | IN  pkt #318 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191585 | yapp monitor | RX pkt #318 on the input: addr=1 len=2 parity=bad gap=20 |
| 191585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 191685 | **DUT** | IN  pkt #319 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191715 | **DUT** | IN  pkt #319 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191715 | yapp monitor | RX pkt #319 on the input: addr=1 len=2 parity=bad gap=9 |
| 191715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 191885 | **DUT** | IN  pkt #320 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191915 | **DUT** | IN  pkt #320 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191915 | yapp monitor | RX pkt #320 on the input: addr=1 len=2 parity=bad gap=16 |
| 191915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 192055 | **DUT** | IN  pkt #321 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192085 | **DUT** | IN  pkt #321 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192085 | yapp monitor | RX pkt #321 on the input: addr=1 len=2 parity=bad gap=13 |
| 192085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 192295 | **DUT** | IN  pkt #322 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192325 | **DUT** | IN  pkt #322 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192325 | yapp monitor | RX pkt #322 on the input: addr=1 len=2 parity=bad gap=20 |
| 192325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 192475 | **DUT** | IN  pkt #323 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192505 | **DUT** | IN  pkt #323 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192505 | yapp monitor | RX pkt #323 on the input: addr=1 len=2 parity=bad gap=14 |
| 192505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192545 | **DUT** | IN  pkt #324 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 192575 | **DUT** | IN  pkt #324 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192575 | yapp monitor | RX pkt #324 on the input: addr=1 len=2 parity=bad gap=3 |
| 192575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 192725 | **DUT** | IN  pkt #325 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192755 | **DUT** | IN  pkt #325 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192755 | yapp monitor | RX pkt #325 on the input: addr=1 len=2 parity=bad gap=14 |
| 192755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 192965 | **DUT** | IN  pkt #326 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192995 | **DUT** | IN  pkt #326 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192995 | yapp monitor | RX pkt #326 on the input: addr=1 len=2 parity=bad gap=20 |
| 192995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 193105 | **DUT** | IN  pkt #327 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193135 | **DUT** | IN  pkt #327 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193135 | yapp monitor | RX pkt #327 on the input: addr=1 len=2 parity=bad gap=10 |
| 193135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 193345 | **DUT** | IN  pkt #328 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193375 | **DUT** | IN  pkt #328 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193375 | yapp monitor | RX pkt #328 on the input: addr=1 len=2 parity=bad gap=20 |
| 193375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 193585 | **DUT** | IN  pkt #329 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193615 | **DUT** | IN  pkt #329 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193615 | yapp monitor | RX pkt #329 on the input: addr=1 len=2 parity=bad gap=20 |
| 193615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 193795 | **DUT** | IN  pkt #330 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193825 | **DUT** | IN  pkt #330 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193825 | yapp monitor | RX pkt #330 on the input: addr=1 len=2 parity=bad gap=17 |
| 193825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 194005 | **DUT** | IN  pkt #331 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194035 | **DUT** | IN  pkt #331 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194035 | yapp monitor | RX pkt #331 on the input: addr=1 len=2 parity=bad gap=17 |
| 194035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 194205 | **DUT** | IN  pkt #332 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194235 | **DUT** | IN  pkt #332 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194235 | yapp monitor | RX pkt #332 on the input: addr=1 len=2 parity=bad gap=16 |
| 194235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 194375 | **DUT** | IN  pkt #333 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194405 | **DUT** | IN  pkt #333 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194405 | yapp monitor | RX pkt #333 on the input: addr=1 len=2 parity=bad gap=13 |
| 194405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 194475 | **DUT** | IN  pkt #334 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194505 | **DUT** | IN  pkt #334 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194505 | yapp monitor | RX pkt #334 on the input: addr=1 len=2 parity=bad gap=6 |
| 194505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 194715 | **DUT** | IN  pkt #335 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194745 | **DUT** | IN  pkt #335 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194745 | yapp monitor | RX pkt #335 on the input: addr=1 len=2 parity=bad gap=20 |
| 194745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194745 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 194835 | **DUT** | IN  pkt #336 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194865 | **DUT** | IN  pkt #336 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194865 | yapp monitor | RX pkt #336 on the input: addr=1 len=2 parity=bad gap=8 |
| 194865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194865 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 195075 | **DUT** | IN  pkt #337 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195105 | **DUT** | IN  pkt #337 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195105 | yapp monitor | RX pkt #337 on the input: addr=1 len=2 parity=bad gap=20 |
| 195105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195125 | **DUT** | IN  pkt #338 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 195155 | **DUT** | IN  pkt #338 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195155 | yapp monitor | RX pkt #338 on the input: addr=1 len=2 parity=bad gap=1 |
| 195155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195230 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 195365 | **DUT** | IN  pkt #339 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195395 | **DUT** | IN  pkt #339 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195395 | yapp monitor | RX pkt #339 on the input: addr=1 len=2 parity=bad gap=20 |
| 195395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 195465 | **DUT** | IN  pkt #340 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195495 | **DUT** | IN  pkt #340 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195495 | yapp monitor | RX pkt #340 on the input: addr=1 len=2 parity=bad gap=6 |
| 195495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195495 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195575 | **DUT** | IN  pkt #341 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 195605 | **DUT** | IN  pkt #341 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195605 | yapp monitor | RX pkt #341 on the input: addr=1 len=2 parity=bad gap=7 |
| 195605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195650 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 195735 | **DUT** | IN  pkt #342 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195765 | **DUT** | IN  pkt #342 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195765 | yapp monitor | RX pkt #342 on the input: addr=1 len=2 parity=bad gap=12 |
| 195765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 195975 | **DUT** | IN  pkt #343 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196005 | **DUT** | IN  pkt #343 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196005 | yapp monitor | RX pkt #343 on the input: addr=1 len=2 parity=bad gap=20 |
| 196005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 196215 | **DUT** | IN  pkt #344 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196245 | **DUT** | IN  pkt #344 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196245 | yapp monitor | RX pkt #344 on the input: addr=1 len=2 parity=bad gap=20 |
| 196245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 196355 | **DUT** | IN  pkt #345 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196385 | **DUT** | IN  pkt #345 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196385 | yapp monitor | RX pkt #345 on the input: addr=1 len=2 parity=bad gap=10 |
| 196385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 196495 | **DUT** | IN  pkt #346 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196525 | **DUT** | IN  pkt #346 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196525 | yapp monitor | RX pkt #346 on the input: addr=1 len=2 parity=bad gap=10 |
| 196525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196525 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196545 | **DUT** | IN  pkt #347 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196575 | **DUT** | IN  pkt #347 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196575 | yapp monitor | RX pkt #347 on the input: addr=1 len=2 parity=bad gap=1 |
| 196575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196590 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 196630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 196675 | **DUT** | IN  pkt #348 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196705 | **DUT** | IN  pkt #348 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196705 | yapp monitor | RX pkt #348 on the input: addr=1 len=2 parity=bad gap=9 |
| 196705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 196895 | **DUT** | IN  pkt #349 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196925 | **DUT** | IN  pkt #349 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196925 | yapp monitor | RX pkt #349 on the input: addr=1 len=2 parity=bad gap=18 |
| 196925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196925 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 197135 | **DUT** | IN  pkt #350 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197165 | **DUT** | IN  pkt #350 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197165 | yapp monitor | RX pkt #350 on the input: addr=1 len=2 parity=bad gap=20 |
| 197165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197230 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 197375 | **DUT** | IN  pkt #351 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197405 | **DUT** | IN  pkt #351 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197405 | yapp monitor | RX pkt #351 on the input: addr=1 len=2 parity=bad gap=20 |
| 197405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197485 | **DUT** | IN  pkt #352 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 197515 | **DUT** | IN  pkt #352 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197515 | yapp monitor | RX pkt #352 on the input: addr=1 len=2 parity=bad gap=7 |
| 197515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 197685 | **DUT** | IN  pkt #353 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197715 | **DUT** | IN  pkt #353 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197715 | yapp monitor | RX pkt #353 on the input: addr=1 len=2 parity=bad gap=16 |
| 197715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 197885 | **DUT** | IN  pkt #354 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197915 | **DUT** | IN  pkt #354 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197915 | yapp monitor | RX pkt #354 on the input: addr=1 len=2 parity=bad gap=16 |
| 197915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 197975 | **DUT** | IN  pkt #355 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198005 | **DUT** | IN  pkt #355 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198005 | yapp monitor | RX pkt #355 on the input: addr=1 len=2 parity=bad gap=5 |
| 198005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 198215 | **DUT** | IN  pkt #356 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198245 | **DUT** | IN  pkt #356 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198245 | yapp monitor | RX pkt #356 on the input: addr=1 len=2 parity=bad gap=20 |
| 198245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 198285 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 198315 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 198345 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 198375 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 198405 | hbus monitor | Collected READ  addr=0x100a data=0x64 |
| 198435 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 198585 | **DUT** | IN  pkt #357 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198615 | **DUT** | IN  pkt #357 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198615 | yapp monitor | RX pkt #357 on the input: addr=1 len=2 parity=bad gap=33 |
| 198615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 198665 | **DUT** | IN  pkt #358 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198695 | **DUT** | IN  pkt #358 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198695 | yapp monitor | RX pkt #358 on the input: addr=1 len=2 parity=bad gap=4 |
| 198695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198775 | **DUT** | IN  pkt #359 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 198805 | **DUT** | IN  pkt #359 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198805 | yapp monitor | RX pkt #359 on the input: addr=1 len=2 parity=bad gap=7 |
| 198805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198850 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 198995 | **DUT** | IN  pkt #360 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199025 | **DUT** | IN  pkt #360 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199025 | yapp monitor | RX pkt #360 on the input: addr=1 len=2 parity=bad gap=18 |
| 199025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 199235 | **DUT** | IN  pkt #361 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199265 | **DUT** | IN  pkt #361 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199265 | yapp monitor | RX pkt #361 on the input: addr=1 len=2 parity=bad gap=20 |
| 199265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 199335 | **DUT** | IN  pkt #362 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199365 | **DUT** | IN  pkt #362 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199365 | yapp monitor | RX pkt #362 on the input: addr=1 len=2 parity=bad gap=6 |
| 199365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199390 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 199515 | **DUT** | IN  pkt #363 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199545 | **DUT** | IN  pkt #363 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199545 | yapp monitor | RX pkt #363 on the input: addr=1 len=2 parity=bad gap=14 |
| 199545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 199755 | **DUT** | IN  pkt #364 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199785 | **DUT** | IN  pkt #364 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199785 | yapp monitor | RX pkt #364 on the input: addr=1 len=2 parity=bad gap=20 |
| 199785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199965 | **DUT** | IN  pkt #365 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199995 | **DUT** | IN  pkt #365 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199995 | yapp monitor | RX pkt #365 on the input: addr=1 len=2 parity=bad gap=17 |
| 199995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 200175 | **DUT** | IN  pkt #366 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200205 | **DUT** | IN  pkt #366 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200205 | yapp monitor | RX pkt #366 on the input: addr=1 len=2 parity=bad gap=17 |
| 200205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200270 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 200295 | **DUT** | IN  pkt #367 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200325 | **DUT** | IN  pkt #367 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200325 | yapp monitor | RX pkt #367 on the input: addr=1 len=2 parity=bad gap=8 |
| 200325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200345 | **DUT** | IN  pkt #368 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 200375 | **DUT** | IN  pkt #368 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200375 | yapp monitor | RX pkt #368 on the input: addr=1 len=2 parity=bad gap=1 |
| 200375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 200505 | **DUT** | IN  pkt #369 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200535 | **DUT** | IN  pkt #369 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200535 | yapp monitor | RX pkt #369 on the input: addr=1 len=2 parity=bad gap=12 |
| 200535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 200715 | **DUT** | IN  pkt #370 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200745 | **DUT** | IN  pkt #370 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200745 | yapp monitor | RX pkt #370 on the input: addr=1 len=2 parity=bad gap=17 |
| 200745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200745 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200810 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 200945 | **DUT** | IN  pkt #371 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200975 | **DUT** | IN  pkt #371 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200975 | yapp monitor | RX pkt #371 on the input: addr=1 len=2 parity=bad gap=19 |
| 200975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200995 | **DUT** | IN  pkt #372 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 201025 | **DUT** | IN  pkt #372 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201025 | yapp monitor | RX pkt #372 on the input: addr=1 len=2 parity=bad gap=1 |
| 201025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 201065 | **DUT** | IN  pkt #373 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201095 | **DUT** | IN  pkt #373 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201095 | yapp monitor | RX pkt #373 on the input: addr=1 len=2 parity=bad gap=3 |
| 201095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201095 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 201305 | **DUT** | IN  pkt #374 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201335 | **DUT** | IN  pkt #374 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201335 | yapp monitor | RX pkt #374 on the input: addr=1 len=2 parity=bad gap=20 |
| 201335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 201515 | **DUT** | IN  pkt #375 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201545 | **DUT** | IN  pkt #375 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201545 | yapp monitor | RX pkt #375 on the input: addr=1 len=2 parity=bad gap=17 |
| 201545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201565 | **DUT** | IN  pkt #376 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201595 | **DUT** | IN  pkt #376 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201595 | yapp monitor | RX pkt #376 on the input: addr=1 len=2 parity=bad gap=1 |
| 201595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 201620 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 201795 | **DUT** | IN  pkt #377 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201825 | **DUT** | IN  pkt #377 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201825 | yapp monitor | RX pkt #377 on the input: addr=1 len=2 parity=bad gap=19 |
| 201825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 201955 | **DUT** | IN  pkt #378 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201985 | **DUT** | IN  pkt #378 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201985 | yapp monitor | RX pkt #378 on the input: addr=1 len=2 parity=bad gap=12 |
| 201985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 202015 | **DUT** | IN  pkt #379 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202045 | **DUT** | IN  pkt #379 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202045 | yapp monitor | RX pkt #379 on the input: addr=1 len=2 parity=bad gap=2 |
| 202045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 202135 | **DUT** | IN  pkt #380 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202165 | **DUT** | IN  pkt #380 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202165 | yapp monitor | RX pkt #380 on the input: addr=1 len=2 parity=bad gap=8 |
| 202165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 202345 | **DUT** | IN  pkt #381 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202375 | **DUT** | IN  pkt #381 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202375 | yapp monitor | RX pkt #381 on the input: addr=1 len=2 parity=bad gap=17 |
| 202375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202405 | **DUT** | IN  pkt #382 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202435 | **DUT** | IN  pkt #382 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202435 | yapp monitor | RX pkt #382 on the input: addr=1 len=2 parity=bad gap=2 |
| 202435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202435 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 202485 | **DUT** | IN  pkt #383 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202490 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 202515 | **DUT** | IN  pkt #383 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202515 | yapp monitor | RX pkt #383 on the input: addr=1 len=2 parity=bad gap=4 |
| 202515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 202645 | **DUT** | IN  pkt #384 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202675 | **DUT** | IN  pkt #384 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202675 | yapp monitor | RX pkt #384 on the input: addr=1 len=2 parity=bad gap=12 |
| 202675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 202805 | **DUT** | IN  pkt #385 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202835 | **DUT** | IN  pkt #385 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202835 | yapp monitor | RX pkt #385 on the input: addr=1 len=2 parity=bad gap=12 |
| 202835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 202955 | **DUT** | IN  pkt #386 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202985 | **DUT** | IN  pkt #386 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202985 | yapp monitor | RX pkt #386 on the input: addr=1 len=2 parity=bad gap=11 |
| 202985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 203095 | **DUT** | IN  pkt #387 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203125 | **DUT** | IN  pkt #387 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203125 | yapp monitor | RX pkt #387 on the input: addr=1 len=2 parity=bad gap=10 |
| 203125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 203335 | **DUT** | IN  pkt #388 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203365 | **DUT** | IN  pkt #388 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203365 | yapp monitor | RX pkt #388 on the input: addr=1 len=2 parity=bad gap=20 |
| 203365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203390 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 203395 | **DUT** | IN  pkt #389 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203425 | **DUT** | IN  pkt #389 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203425 | yapp monitor | RX pkt #389 on the input: addr=1 len=2 parity=bad gap=2 |
| 203425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 203565 | **DUT** | IN  pkt #390 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203595 | **DUT** | IN  pkt #390 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203595 | yapp monitor | RX pkt #390 on the input: addr=1 len=2 parity=bad gap=13 |
| 203595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203615 | **DUT** | IN  pkt #391 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 203645 | **DUT** | IN  pkt #391 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203645 | yapp monitor | RX pkt #391 on the input: addr=1 len=2 parity=bad gap=1 |
| 203645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203675 | **DUT** | IN  pkt #392 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203705 | **DUT** | IN  pkt #392 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203705 | yapp monitor | RX pkt #392 on the input: addr=1 len=2 parity=bad gap=2 |
| 203705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 203750 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 203885 | **DUT** | IN  pkt #393 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203915 | **DUT** | IN  pkt #393 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203915 | yapp monitor | RX pkt #393 on the input: addr=1 len=2 parity=bad gap=17 |
| 203915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203935 | **DUT** | IN  pkt #394 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 203965 | **DUT** | IN  pkt #394 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203965 | yapp monitor | RX pkt #394 on the input: addr=1 len=2 parity=bad gap=1 |
| 203965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204005 | **DUT** | IN  pkt #395 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204035 | **DUT** | IN  pkt #395 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204035 | yapp monitor | RX pkt #395 on the input: addr=1 len=2 parity=bad gap=3 |
| 204035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 204090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 204245 | **DUT** | IN  pkt #396 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204275 | **DUT** | IN  pkt #396 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204275 | yapp monitor | RX pkt #396 on the input: addr=1 len=2 parity=bad gap=20 |
| 204275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 204465 | **DUT** | IN  pkt #397 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204495 | **DUT** | IN  pkt #397 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204495 | yapp monitor | RX pkt #397 on the input: addr=1 len=2 parity=bad gap=18 |
| 204495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204495 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 204695 | **DUT** | IN  pkt #398 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204725 | **DUT** | IN  pkt #398 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204725 | yapp monitor | RX pkt #398 on the input: addr=1 len=2 parity=bad gap=19 |
| 204725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 204865 | **DUT** | IN  pkt #399 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204895 | **DUT** | IN  pkt #399 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204895 | yapp monitor | RX pkt #399 on the input: addr=1 len=2 parity=bad gap=13 |
| 204895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 205055 | **DUT** | IN  pkt #400 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205085 | **DUT** | IN  pkt #400 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205085 | yapp monitor | RX pkt #400 on the input: addr=1 len=2 parity=bad gap=15 |
| 205085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 205255 | **DUT** | IN  pkt #401 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205285 | **DUT** | IN  pkt #401 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205285 | yapp monitor | RX pkt #401 on the input: addr=1 len=2 parity=bad gap=16 |
| 205285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205310 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 205415 | **DUT** | IN  pkt #402 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205445 | **DUT** | IN  pkt #402 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205445 | yapp monitor | RX pkt #402 on the input: addr=1 len=2 parity=bad gap=12 |
| 205445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 205575 | **DUT** | IN  pkt #403 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205605 | **DUT** | IN  pkt #403 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205605 | yapp monitor | RX pkt #403 on the input: addr=1 len=2 parity=bad gap=12 |
| 205605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 205815 | **DUT** | IN  pkt #404 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205845 | **DUT** | IN  pkt #404 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205845 | yapp monitor | RX pkt #404 on the input: addr=1 len=2 parity=bad gap=20 |
| 205845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205845 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205890 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 206055 | **DUT** | IN  pkt #405 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206085 | **DUT** | IN  pkt #405 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206085 | yapp monitor | RX pkt #405 on the input: addr=1 len=2 parity=bad gap=20 |
| 206085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 206205 | **DUT** | IN  pkt #406 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206235 | **DUT** | IN  pkt #406 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206235 | yapp monitor | RX pkt #406 on the input: addr=1 len=2 parity=bad gap=11 |
| 206235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 206325 | **DUT** | IN  pkt #407 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206355 | **DUT** | IN  pkt #407 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206355 | yapp monitor | RX pkt #407 on the input: addr=1 len=2 parity=bad gap=8 |
| 206355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 206525 | **DUT** | IN  pkt #408 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206555 | **DUT** | IN  pkt #408 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206555 | yapp monitor | RX pkt #408 on the input: addr=1 len=2 parity=bad gap=16 |
| 206555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 206675 | **DUT** | IN  pkt #409 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206705 | **DUT** | IN  pkt #409 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206705 | yapp monitor | RX pkt #409 on the input: addr=1 len=2 parity=bad gap=11 |
| 206705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206785 | **DUT** | IN  pkt #410 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 206815 | **DUT** | IN  pkt #410 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206815 | yapp monitor | RX pkt #410 on the input: addr=1 len=2 parity=bad gap=7 |
| 206815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206815 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 206875 | **DUT** | IN  pkt #411 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206905 | **DUT** | IN  pkt #411 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206905 | yapp monitor | RX pkt #411 on the input: addr=1 len=2 parity=bad gap=5 |
| 206905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206950 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 207115 | **DUT** | IN  pkt #412 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207145 | **DUT** | IN  pkt #412 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207145 | yapp monitor | RX pkt #412 on the input: addr=1 len=2 parity=bad gap=20 |
| 207145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 207325 | **DUT** | IN  pkt #413 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207355 | **DUT** | IN  pkt #413 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207355 | yapp monitor | RX pkt #413 on the input: addr=1 len=2 parity=bad gap=17 |
| 207355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 207565 | **DUT** | IN  pkt #414 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207595 | **DUT** | IN  pkt #414 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207595 | yapp monitor | RX pkt #414 on the input: addr=1 len=2 parity=bad gap=20 |
| 207595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 207795 | **DUT** | IN  pkt #415 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207825 | **DUT** | IN  pkt #415 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207825 | yapp monitor | RX pkt #415 on the input: addr=1 len=2 parity=bad gap=19 |
| 207825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 208025 | **DUT** | IN  pkt #416 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208055 | **DUT** | IN  pkt #416 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208055 | yapp monitor | RX pkt #416 on the input: addr=1 len=2 parity=bad gap=19 |
| 208055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208055 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 208155 | **DUT** | IN  pkt #417 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208185 | **DUT** | IN  pkt #417 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208185 | yapp monitor | RX pkt #417 on the input: addr=1 len=2 parity=bad gap=9 |
| 208185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 208265 | **DUT** | IN  pkt #418 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208295 | **DUT** | IN  pkt #418 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208295 | yapp monitor | RX pkt #418 on the input: addr=1 len=2 parity=bad gap=7 |
| 208295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 208505 | **DUT** | IN  pkt #419 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208535 | **DUT** | IN  pkt #419 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208535 | yapp monitor | RX pkt #419 on the input: addr=1 len=2 parity=bad gap=20 |
| 208535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 208745 | **DUT** | IN  pkt #420 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208775 | **DUT** | IN  pkt #420 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208775 | yapp monitor | RX pkt #420 on the input: addr=1 len=2 parity=bad gap=20 |
| 208775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208775 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 208945 | **DUT** | IN  pkt #421 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208975 | **DUT** | IN  pkt #421 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208975 | yapp monitor | RX pkt #421 on the input: addr=1 len=2 parity=bad gap=16 |
| 208975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 209185 | **DUT** | IN  pkt #422 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209215 | **DUT** | IN  pkt #422 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209215 | yapp monitor | RX pkt #422 on the input: addr=1 len=2 parity=bad gap=20 |
| 209215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 209315 | **DUT** | IN  pkt #423 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209345 | **DUT** | IN  pkt #423 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209345 | yapp monitor | RX pkt #423 on the input: addr=1 len=2 parity=bad gap=9 |
| 209345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 209515 | **DUT** | IN  pkt #424 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209545 | **DUT** | IN  pkt #424 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209545 | yapp monitor | RX pkt #424 on the input: addr=1 len=2 parity=bad gap=16 |
| 209545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 209755 | **DUT** | IN  pkt #425 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209785 | **DUT** | IN  pkt #425 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209785 | yapp monitor | RX pkt #425 on the input: addr=1 len=2 parity=bad gap=20 |
| 209785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 209975 | **DUT** | IN  pkt #426 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210005 | **DUT** | IN  pkt #426 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210005 | yapp monitor | RX pkt #426 on the input: addr=1 len=2 parity=bad gap=18 |
| 210005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 210215 | **DUT** | IN  pkt #427 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210245 | **DUT** | IN  pkt #427 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210245 | yapp monitor | RX pkt #427 on the input: addr=1 len=2 parity=bad gap=20 |
| 210245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 210375 | **DUT** | IN  pkt #428 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210405 | **DUT** | IN  pkt #428 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210405 | yapp monitor | RX pkt #428 on the input: addr=1 len=2 parity=bad gap=12 |
| 210405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 210615 | **DUT** | IN  pkt #429 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210645 | **DUT** | IN  pkt #429 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210645 | yapp monitor | RX pkt #429 on the input: addr=1 len=2 parity=bad gap=20 |
| 210645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210685 | **DUT** | IN  pkt #430 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 210715 | **DUT** | IN  pkt #430 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210715 | yapp monitor | RX pkt #430 on the input: addr=1 len=2 parity=bad gap=3 |
| 210715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 210925 | **DUT** | IN  pkt #431 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210955 | **DUT** | IN  pkt #431 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210955 | yapp monitor | RX pkt #431 on the input: addr=1 len=2 parity=bad gap=20 |
| 210955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 211095 | **DUT** | IN  pkt #432 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211125 | **DUT** | IN  pkt #432 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211125 | yapp monitor | RX pkt #432 on the input: addr=1 len=2 parity=bad gap=13 |
| 211125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 211335 | **DUT** | IN  pkt #433 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211365 | **DUT** | IN  pkt #433 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211365 | yapp monitor | RX pkt #433 on the input: addr=1 len=2 parity=bad gap=20 |
| 211365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211390 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 211525 | **DUT** | IN  pkt #434 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211555 | **DUT** | IN  pkt #434 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211555 | yapp monitor | RX pkt #434 on the input: addr=1 len=2 parity=bad gap=15 |
| 211555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 211755 | **DUT** | IN  pkt #435 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211785 | **DUT** | IN  pkt #435 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211785 | yapp monitor | RX pkt #435 on the input: addr=1 len=2 parity=bad gap=19 |
| 211785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211805 | **DUT** | IN  pkt #436 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211835 | **DUT** | IN  pkt #436 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211835 | yapp monitor | RX pkt #436 on the input: addr=1 len=2 parity=bad gap=1 |
| 211835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 211860 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 212035 | **DUT** | IN  pkt #437 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212065 | **DUT** | IN  pkt #437 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212065 | yapp monitor | RX pkt #437 on the input: addr=1 len=2 parity=bad gap=19 |
| 212065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 212265 | **DUT** | IN  pkt #438 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212295 | **DUT** | IN  pkt #438 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212295 | yapp monitor | RX pkt #438 on the input: addr=1 len=2 parity=bad gap=19 |
| 212295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 212475 | **DUT** | IN  pkt #439 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212505 | **DUT** | IN  pkt #439 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212505 | yapp monitor | RX pkt #439 on the input: addr=1 len=2 parity=bad gap=17 |
| 212505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212525 | **DUT** | IN  pkt #440 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 212555 | **DUT** | IN  pkt #440 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212555 | yapp monitor | RX pkt #440 on the input: addr=1 len=2 parity=bad gap=1 |
| 212555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 212765 | **DUT** | IN  pkt #441 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212795 | **DUT** | IN  pkt #441 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212795 | yapp monitor | RX pkt #441 on the input: addr=1 len=2 parity=bad gap=20 |
| 212795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 213005 | **DUT** | IN  pkt #442 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213035 | **DUT** | IN  pkt #442 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213035 | yapp monitor | RX pkt #442 on the input: addr=1 len=2 parity=bad gap=20 |
| 213035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 213185 | **DUT** | IN  pkt #443 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213215 | **DUT** | IN  pkt #443 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213215 | yapp monitor | RX pkt #443 on the input: addr=1 len=2 parity=bad gap=14 |
| 213215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 213275 | **DUT** | IN  pkt #444 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213305 | **DUT** | IN  pkt #444 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213305 | yapp monitor | RX pkt #444 on the input: addr=1 len=2 parity=bad gap=5 |
| 213305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213305 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 213385 | **DUT** | IN  pkt #445 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213415 | **DUT** | IN  pkt #445 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213415 | yapp monitor | RX pkt #445 on the input: addr=1 len=2 parity=bad gap=7 |
| 213415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 213625 | **DUT** | IN  pkt #446 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213655 | **DUT** | IN  pkt #446 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213655 | yapp monitor | RX pkt #446 on the input: addr=1 len=2 parity=bad gap=20 |
| 213655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 213675 | **DUT** | IN  pkt #447 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213705 | **DUT** | IN  pkt #447 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213705 | yapp monitor | RX pkt #447 on the input: addr=1 len=2 parity=bad gap=1 |
| 213705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213735 | **DUT** | IN  pkt #448 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213765 | **DUT** | IN  pkt #448 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213765 | yapp monitor | RX pkt #448 on the input: addr=1 len=2 parity=bad gap=2 |
| 213765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 213790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 213845 | **DUT** | IN  pkt #449 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213875 | **DUT** | IN  pkt #449 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213875 | yapp monitor | RX pkt #449 on the input: addr=1 len=2 parity=bad gap=7 |
| 213875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213875 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213905 | **DUT** | IN  pkt #450 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213935 | **DUT** | IN  pkt #450 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213935 | yapp monitor | RX pkt #450 on the input: addr=1 len=2 parity=bad gap=2 |
| 213935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 213970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214065 | **DUT** | IN  pkt #451 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214095 | **DUT** | IN  pkt #451 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214095 | yapp monitor | RX pkt #451 on the input: addr=1 len=2 parity=bad gap=12 |
| 214095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214095 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214305 | **DUT** | IN  pkt #452 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214335 | **DUT** | IN  pkt #452 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214335 | yapp monitor | RX pkt #452 on the input: addr=1 len=2 parity=bad gap=20 |
| 214335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 214465 | **DUT** | IN  pkt #453 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214495 | **DUT** | IN  pkt #453 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214495 | yapp monitor | RX pkt #453 on the input: addr=1 len=2 parity=bad gap=12 |
| 214495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214495 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 214575 | **DUT** | IN  pkt #454 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214605 | **DUT** | IN  pkt #454 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214605 | yapp monitor | RX pkt #454 on the input: addr=1 len=2 parity=bad gap=7 |
| 214605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 214675 | **DUT** | IN  pkt #455 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214705 | **DUT** | IN  pkt #455 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214705 | yapp monitor | RX pkt #455 on the input: addr=1 len=2 parity=bad gap=6 |
| 214705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214735 | **DUT** | IN  pkt #456 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214765 | **DUT** | IN  pkt #456 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214765 | yapp monitor | RX pkt #456 on the input: addr=1 len=2 parity=bad gap=2 |
| 214765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 214830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 214895 | **DUT** | IN  pkt #457 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214925 | **DUT** | IN  pkt #457 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214925 | yapp monitor | RX pkt #457 on the input: addr=1 len=2 parity=bad gap=12 |
| 214925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214925 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 215075 | **DUT** | IN  pkt #458 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215105 | **DUT** | IN  pkt #458 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215105 | yapp monitor | RX pkt #458 on the input: addr=1 len=2 parity=bad gap=14 |
| 215105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 215305 | **DUT** | IN  pkt #459 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215335 | **DUT** | IN  pkt #459 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215335 | yapp monitor | RX pkt #459 on the input: addr=1 len=2 parity=bad gap=19 |
| 215335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 215525 | **DUT** | IN  pkt #460 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215555 | **DUT** | IN  pkt #460 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215555 | yapp monitor | RX pkt #460 on the input: addr=1 len=2 parity=bad gap=18 |
| 215555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215585 | **DUT** | IN  pkt #461 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 215615 | **DUT** | IN  pkt #461 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215615 | yapp monitor | RX pkt #461 on the input: addr=1 len=2 parity=bad gap=2 |
| 215615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 215735 | **DUT** | IN  pkt #462 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215765 | **DUT** | IN  pkt #462 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215765 | yapp monitor | RX pkt #462 on the input: addr=1 len=2 parity=bad gap=11 |
| 215765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 215895 | **DUT** | IN  pkt #463 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215925 | **DUT** | IN  pkt #463 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215925 | yapp monitor | RX pkt #463 on the input: addr=1 len=2 parity=bad gap=12 |
| 215925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215925 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 216135 | **DUT** | IN  pkt #464 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216165 | **DUT** | IN  pkt #464 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216165 | yapp monitor | RX pkt #464 on the input: addr=1 len=2 parity=bad gap=20 |
| 216165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 216315 | **DUT** | IN  pkt #465 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216345 | **DUT** | IN  pkt #465 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216345 | yapp monitor | RX pkt #465 on the input: addr=1 len=2 parity=bad gap=14 |
| 216345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 216545 | **DUT** | IN  pkt #466 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216575 | **DUT** | IN  pkt #466 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216575 | yapp monitor | RX pkt #466 on the input: addr=1 len=2 parity=bad gap=19 |
| 216575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 216705 | **DUT** | IN  pkt #467 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216735 | **DUT** | IN  pkt #467 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216735 | yapp monitor | RX pkt #467 on the input: addr=1 len=2 parity=bad gap=12 |
| 216735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216735 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 216855 | **DUT** | IN  pkt #468 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216885 | **DUT** | IN  pkt #468 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216885 | yapp monitor | RX pkt #468 on the input: addr=1 len=2 parity=bad gap=11 |
| 216885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 217095 | **DUT** | IN  pkt #469 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217125 | **DUT** | IN  pkt #469 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217125 | yapp monitor | RX pkt #469 on the input: addr=1 len=2 parity=bad gap=20 |
| 217125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 217335 | **DUT** | IN  pkt #470 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217365 | **DUT** | IN  pkt #470 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217365 | yapp monitor | RX pkt #470 on the input: addr=1 len=2 parity=bad gap=20 |
| 217365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 217575 | **DUT** | IN  pkt #471 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217605 | **DUT** | IN  pkt #471 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217605 | yapp monitor | RX pkt #471 on the input: addr=1 len=2 parity=bad gap=20 |
| 217605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 217655 | **DUT** | IN  pkt #472 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217685 | **DUT** | IN  pkt #472 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217685 | yapp monitor | RX pkt #472 on the input: addr=1 len=2 parity=bad gap=4 |
| 217685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217685 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217705 | **DUT** | IN  pkt #473 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 217735 | **DUT** | IN  pkt #473 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217735 | yapp monitor | RX pkt #473 on the input: addr=1 len=2 parity=bad gap=1 |
| 217735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217735 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 217915 | **DUT** | IN  pkt #474 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217945 | **DUT** | IN  pkt #474 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217945 | yapp monitor | RX pkt #474 on the input: addr=1 len=2 parity=bad gap=17 |
| 217945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 218155 | **DUT** | IN  pkt #475 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218185 | **DUT** | IN  pkt #475 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218185 | yapp monitor | RX pkt #475 on the input: addr=1 len=2 parity=bad gap=20 |
| 218185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218250 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 218385 | **DUT** | IN  pkt #476 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218415 | **DUT** | IN  pkt #476 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218415 | yapp monitor | RX pkt #476 on the input: addr=1 len=2 parity=bad gap=19 |
| 218415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218450 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 218575 | **DUT** | IN  pkt #477 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218605 | **DUT** | IN  pkt #477 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218605 | yapp monitor | RX pkt #477 on the input: addr=1 len=2 parity=bad gap=15 |
| 218605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218665 | **DUT** | IN  pkt #478 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 218695 | **DUT** | IN  pkt #478 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218695 | yapp monitor | RX pkt #478 on the input: addr=1 len=2 parity=bad gap=5 |
| 218695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 218875 | **DUT** | IN  pkt #479 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218905 | **DUT** | IN  pkt #479 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218905 | yapp monitor | RX pkt #479 on the input: addr=1 len=2 parity=bad gap=17 |
| 218905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218950 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 218985 | **DUT** | IN  pkt #480 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219015 | **DUT** | IN  pkt #480 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219015 | yapp monitor | RX pkt #480 on the input: addr=1 len=2 parity=bad gap=7 |
| 219015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219015 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 219215 | **DUT** | IN  pkt #481 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219245 | **DUT** | IN  pkt #481 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219245 | yapp monitor | RX pkt #481 on the input: addr=1 len=2 parity=bad gap=19 |
| 219245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 219445 | **DUT** | IN  pkt #482 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219475 | **DUT** | IN  pkt #482 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219475 | yapp monitor | RX pkt #482 on the input: addr=1 len=2 parity=bad gap=19 |
| 219475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219475 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 219575 | **DUT** | IN  pkt #483 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219605 | **DUT** | IN  pkt #483 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219605 | yapp monitor | RX pkt #483 on the input: addr=1 len=2 parity=bad gap=9 |
| 219605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219625 | **DUT** | IN  pkt #484 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219650 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 219655 | **DUT** | IN  pkt #484 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219655 | yapp monitor | RX pkt #484 on the input: addr=1 len=2 parity=bad gap=1 |
| 219655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 219865 | **DUT** | IN  pkt #485 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219895 | **DUT** | IN  pkt #485 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219895 | yapp monitor | RX pkt #485 on the input: addr=1 len=2 parity=bad gap=20 |
| 219895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 220085 | **DUT** | IN  pkt #486 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220115 | **DUT** | IN  pkt #486 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220115 | yapp monitor | RX pkt #486 on the input: addr=1 len=2 parity=bad gap=18 |
| 220115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 220235 | **DUT** | IN  pkt #487 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220265 | **DUT** | IN  pkt #487 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220265 | yapp monitor | RX pkt #487 on the input: addr=1 len=2 parity=bad gap=11 |
| 220265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 220475 | **DUT** | IN  pkt #488 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220505 | **DUT** | IN  pkt #488 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220505 | yapp monitor | RX pkt #488 on the input: addr=1 len=2 parity=bad gap=20 |
| 220505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220525 | **DUT** | IN  pkt #489 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 220555 | **DUT** | IN  pkt #489 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220555 | yapp monitor | RX pkt #489 on the input: addr=1 len=2 parity=bad gap=1 |
| 220555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 220765 | **DUT** | IN  pkt #490 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220795 | **DUT** | IN  pkt #490 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220795 | yapp monitor | RX pkt #490 on the input: addr=1 len=2 parity=bad gap=20 |
| 220795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 220875 | **DUT** | IN  pkt #491 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220905 | **DUT** | IN  pkt #491 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220905 | yapp monitor | RX pkt #491 on the input: addr=1 len=2 parity=bad gap=7 |
| 220905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220970 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 220975 | **DUT** | IN  pkt #492 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221005 | **DUT** | IN  pkt #492 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221005 | yapp monitor | RX pkt #492 on the input: addr=1 len=2 parity=bad gap=6 |
| 221005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 221075 | **DUT** | IN  pkt #493 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221105 | **DUT** | IN  pkt #493 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221105 | yapp monitor | RX pkt #493 on the input: addr=1 len=2 parity=bad gap=6 |
| 221105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221125 | **DUT** | IN  pkt #494 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221155 | **DUT** | IN  pkt #494 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221155 | yapp monitor | RX pkt #494 on the input: addr=1 len=2 parity=bad gap=1 |
| 221155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 221220 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 221235 | **DUT** | IN  pkt #495 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221265 | **DUT** | IN  pkt #495 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221265 | yapp monitor | RX pkt #495 on the input: addr=1 len=2 parity=bad gap=7 |
| 221265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 221455 | **DUT** | IN  pkt #496 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221485 | **DUT** | IN  pkt #496 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221485 | yapp monitor | RX pkt #496 on the input: addr=1 len=2 parity=bad gap=18 |
| 221485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221525 | **DUT** | IN  pkt #497 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 221555 | **DUT** | IN  pkt #497 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221555 | yapp monitor | RX pkt #497 on the input: addr=1 len=2 parity=bad gap=3 |
| 221555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 221745 | **DUT** | IN  pkt #498 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221775 | **DUT** | IN  pkt #498 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221775 | yapp monitor | RX pkt #498 on the input: addr=1 len=2 parity=bad gap=18 |
| 221775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221775 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221810 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 221865 | **DUT** | IN  pkt #499 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221895 | **DUT** | IN  pkt #499 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221895 | yapp monitor | RX pkt #499 on the input: addr=1 len=2 parity=bad gap=8 |
| 221895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 222105 | **DUT** | IN  pkt #500 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222135 | **DUT** | IN  pkt #500 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222135 | yapp monitor | RX pkt #500 on the input: addr=1 len=2 parity=bad gap=20 |
| 222135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 222195 | **DUT** | IN  pkt #501 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222225 | **DUT** | IN  pkt #501 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222225 | yapp monitor | RX pkt #501 on the input: addr=1 len=2 parity=bad gap=5 |
| 222225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 222435 | **DUT** | IN  pkt #502 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222465 | **DUT** | IN  pkt #502 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222465 | yapp monitor | RX pkt #502 on the input: addr=1 len=2 parity=bad gap=20 |
| 222465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 222675 | **DUT** | IN  pkt #503 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222705 | **DUT** | IN  pkt #503 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222705 | yapp monitor | RX pkt #503 on the input: addr=1 len=2 parity=bad gap=20 |
| 222705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222735 | **DUT** | IN  pkt #504 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222765 | **DUT** | IN  pkt #504 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222765 | yapp monitor | RX pkt #504 on the input: addr=1 len=2 parity=bad gap=2 |
| 222765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 222830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 222965 | **DUT** | IN  pkt #505 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222995 | **DUT** | IN  pkt #505 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222995 | yapp monitor | RX pkt #505 on the input: addr=1 len=2 parity=bad gap=19 |
| 222995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223015 | **DUT** | IN  pkt #506 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223045 | **DUT** | IN  pkt #506 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223045 | yapp monitor | RX pkt #506 on the input: addr=1 len=2 parity=bad gap=1 |
| 223045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 223080 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 223255 | **DUT** | IN  pkt #507 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223285 | **DUT** | IN  pkt #507 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223285 | yapp monitor | RX pkt #507 on the input: addr=1 len=2 parity=bad gap=20 |
| 223285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223330 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 223485 | **DUT** | IN  pkt #508 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223515 | **DUT** | IN  pkt #508 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223515 | yapp monitor | RX pkt #508 on the input: addr=1 len=2 parity=bad gap=19 |
| 223515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 223545 | **DUT** | IN  pkt #509 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223575 | **DUT** | IN  pkt #509 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223575 | yapp monitor | RX pkt #509 on the input: addr=1 len=2 parity=bad gap=2 |
| 223575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 223735 | **DUT** | IN  pkt #510 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223765 | **DUT** | IN  pkt #510 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223765 | yapp monitor | RX pkt #510 on the input: addr=1 len=2 parity=bad gap=15 |
| 223765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 223935 | **DUT** | IN  pkt #511 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223965 | **DUT** | IN  pkt #511 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223965 | yapp monitor | RX pkt #511 on the input: addr=1 len=2 parity=bad gap=16 |
| 223965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224005 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 224035 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 224050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 224065 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 224095 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 224125 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 224150 | **test** | STAGE: 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 224155 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 224175 | hbus monitor | Collected WRITE addr=0x1001 data=0x41 |
| 224175 | reference | router_en is now 1 (en_reg 0x41) |
| 224385 | **DUT** | IN  pkt #512 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224415 | **DUT** | IN  pkt #512 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224415 | yapp monitor | RX pkt #512 on the input: addr=2 len=2 parity=bad gap=41 |
| 224415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 224415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 224470 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 224625 | **DUT** | IN  pkt #513 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224655 | **DUT** | IN  pkt #513 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224655 | yapp monitor | RX pkt #513 on the input: addr=2 len=2 parity=bad gap=20 |
| 224655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 224655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 224690 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 224865 | **DUT** | IN  pkt #514 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224895 | **DUT** | IN  pkt #514 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224895 | yapp monitor | RX pkt #514 on the input: addr=2 len=2 parity=bad gap=20 |
| 224895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 224895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 224950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 225085 | **DUT** | IN  pkt #515 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225115 | **DUT** | IN  pkt #515 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225115 | yapp monitor | RX pkt #515 on the input: addr=2 len=2 parity=bad gap=18 |
| 225115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 225115 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 225130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 225315 | **DUT** | IN  pkt #516 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225345 | **DUT** | IN  pkt #516 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225345 | yapp monitor | RX pkt #516 on the input: addr=2 len=2 parity=bad gap=19 |
| 225345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 225345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 225370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 225455 | **DUT** | IN  pkt #517 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225485 | **DUT** | IN  pkt #517 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225485 | yapp monitor | RX pkt #517 on the input: addr=2 len=2 parity=bad gap=10 |
| 225485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 225485 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 225550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 225665 | **DUT** | IN  pkt #518 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225695 | **DUT** | IN  pkt #518 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225695 | yapp monitor | RX pkt #518 on the input: addr=2 len=2 parity=bad gap=17 |
| 225695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 225695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 225745 | **DUT** | IN  pkt #519 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 225775 | **DUT** | IN  pkt #519 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225775 | yapp monitor | RX pkt #519 on the input: addr=2 len=2 parity=bad gap=4 |
| 225775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 225775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 225810 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 225985 | **DUT** | IN  pkt #520 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226015 | **DUT** | IN  pkt #520 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226015 | yapp monitor | RX pkt #520 on the input: addr=2 len=2 parity=bad gap=20 |
| 226015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226055 | **DUT** | IN  pkt #521 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 226085 | **DUT** | IN  pkt #521 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226085 | yapp monitor | RX pkt #521 on the input: addr=2 len=2 parity=bad gap=3 |
| 226085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 226275 | **DUT** | IN  pkt #522 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226305 | **DUT** | IN  pkt #522 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226305 | yapp monitor | RX pkt #522 on the input: addr=2 len=2 parity=bad gap=18 |
| 226305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 226515 | **DUT** | IN  pkt #523 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226545 | **DUT** | IN  pkt #523 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226545 | yapp monitor | RX pkt #523 on the input: addr=2 len=2 parity=bad gap=20 |
| 226545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226645 | **DUT** | IN  pkt #524 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 226675 | **DUT** | IN  pkt #524 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226675 | yapp monitor | RX pkt #524 on the input: addr=2 len=2 parity=bad gap=9 |
| 226675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 226795 | **DUT** | IN  pkt #525 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226825 | **DUT** | IN  pkt #525 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226825 | yapp monitor | RX pkt #525 on the input: addr=2 len=2 parity=bad gap=11 |
| 226825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 227035 | **DUT** | IN  pkt #526 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227065 | **DUT** | IN  pkt #526 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227065 | yapp monitor | RX pkt #526 on the input: addr=2 len=2 parity=bad gap=20 |
| 227065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 227175 | **DUT** | IN  pkt #527 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227205 | **DUT** | IN  pkt #527 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227205 | yapp monitor | RX pkt #527 on the input: addr=2 len=2 parity=bad gap=10 |
| 227205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227205 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 227305 | **DUT** | IN  pkt #528 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227335 | **DUT** | IN  pkt #528 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227335 | yapp monitor | RX pkt #528 on the input: addr=2 len=2 parity=bad gap=9 |
| 227335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227335 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 227545 | **DUT** | IN  pkt #529 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227575 | **DUT** | IN  pkt #529 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227575 | yapp monitor | RX pkt #529 on the input: addr=2 len=2 parity=bad gap=20 |
| 227575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 227765 | **DUT** | IN  pkt #530 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227795 | **DUT** | IN  pkt #530 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227795 | yapp monitor | RX pkt #530 on the input: addr=2 len=2 parity=bad gap=18 |
| 227795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 228005 | **DUT** | IN  pkt #531 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228035 | **DUT** | IN  pkt #531 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228035 | yapp monitor | RX pkt #531 on the input: addr=2 len=2 parity=bad gap=20 |
| 228035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228075 | **DUT** | IN  pkt #532 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 228105 | **DUT** | IN  pkt #532 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228105 | yapp monitor | RX pkt #532 on the input: addr=2 len=2 parity=bad gap=3 |
| 228105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 228235 | **DUT** | IN  pkt #533 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228265 | **DUT** | IN  pkt #533 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228265 | yapp monitor | RX pkt #533 on the input: addr=2 len=2 parity=bad gap=12 |
| 228265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 228395 | **DUT** | IN  pkt #534 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228425 | **DUT** | IN  pkt #534 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228425 | yapp monitor | RX pkt #534 on the input: addr=2 len=2 parity=bad gap=12 |
| 228425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 228605 | **DUT** | IN  pkt #535 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228635 | **DUT** | IN  pkt #535 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228635 | yapp monitor | RX pkt #535 on the input: addr=2 len=2 parity=bad gap=17 |
| 228635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228635 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 228755 | **DUT** | IN  pkt #536 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228785 | **DUT** | IN  pkt #536 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228785 | yapp monitor | RX pkt #536 on the input: addr=2 len=2 parity=bad gap=11 |
| 228785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 228965 | **DUT** | IN  pkt #537 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228995 | **DUT** | IN  pkt #537 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228995 | yapp monitor | RX pkt #537 on the input: addr=2 len=2 parity=bad gap=17 |
| 228995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 229165 | **DUT** | IN  pkt #538 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229195 | **DUT** | IN  pkt #538 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229195 | yapp monitor | RX pkt #538 on the input: addr=2 len=2 parity=bad gap=16 |
| 229195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229195 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 229405 | **DUT** | IN  pkt #539 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229435 | **DUT** | IN  pkt #539 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229435 | yapp monitor | RX pkt #539 on the input: addr=2 len=2 parity=bad gap=20 |
| 229435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229450 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 229645 | **DUT** | IN  pkt #540 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229675 | **DUT** | IN  pkt #540 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229675 | yapp monitor | RX pkt #540 on the input: addr=2 len=2 parity=bad gap=20 |
| 229675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 229885 | **DUT** | IN  pkt #541 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229915 | **DUT** | IN  pkt #541 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229915 | yapp monitor | RX pkt #541 on the input: addr=2 len=2 parity=bad gap=20 |
| 229915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229930 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 229985 | **DUT** | IN  pkt #542 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230015 | **DUT** | IN  pkt #542 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230015 | yapp monitor | RX pkt #542 on the input: addr=2 len=2 parity=bad gap=6 |
| 230015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 230145 | **DUT** | IN  pkt #543 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230175 | **DUT** | IN  pkt #543 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230175 | yapp monitor | RX pkt #543 on the input: addr=2 len=2 parity=bad gap=12 |
| 230175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230215 | **DUT** | IN  pkt #544 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 230245 | **DUT** | IN  pkt #544 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230245 | yapp monitor | RX pkt #544 on the input: addr=2 len=2 parity=bad gap=3 |
| 230245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 230455 | **DUT** | IN  pkt #545 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230485 | **DUT** | IN  pkt #545 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230485 | yapp monitor | RX pkt #545 on the input: addr=2 len=2 parity=bad gap=20 |
| 230485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230485 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230530 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 230595 | **DUT** | IN  pkt #546 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230625 | **DUT** | IN  pkt #546 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230625 | yapp monitor | RX pkt #546 on the input: addr=2 len=2 parity=bad gap=10 |
| 230625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 230765 | **DUT** | IN  pkt #547 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230795 | **DUT** | IN  pkt #547 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230795 | yapp monitor | RX pkt #547 on the input: addr=2 len=2 parity=bad gap=13 |
| 230795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 230995 | **DUT** | IN  pkt #548 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231025 | **DUT** | IN  pkt #548 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231025 | yapp monitor | RX pkt #548 on the input: addr=2 len=2 parity=bad gap=19 |
| 231025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 231235 | **DUT** | IN  pkt #549 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231265 | **DUT** | IN  pkt #549 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231265 | yapp monitor | RX pkt #549 on the input: addr=2 len=2 parity=bad gap=20 |
| 231265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 231475 | **DUT** | IN  pkt #550 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231505 | **DUT** | IN  pkt #550 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231505 | yapp monitor | RX pkt #550 on the input: addr=2 len=2 parity=bad gap=20 |
| 231505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231610 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 231655 | **DUT** | IN  pkt #551 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231685 | **DUT** | IN  pkt #551 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231685 | yapp monitor | RX pkt #551 on the input: addr=2 len=2 parity=bad gap=14 |
| 231685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231705 | **DUT** | IN  pkt #552 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 231735 | **DUT** | IN  pkt #552 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231735 | yapp monitor | RX pkt #552 on the input: addr=2 len=2 parity=bad gap=1 |
| 231735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 231825 | **DUT** | IN  pkt #553 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231855 | **DUT** | IN  pkt #553 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231855 | yapp monitor | RX pkt #553 on the input: addr=2 len=2 parity=bad gap=8 |
| 231855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 232035 | **DUT** | IN  pkt #554 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232065 | **DUT** | IN  pkt #554 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232065 | yapp monitor | RX pkt #554 on the input: addr=2 len=2 parity=bad gap=17 |
| 232065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232085 | **DUT** | IN  pkt #555 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 232115 | **DUT** | IN  pkt #555 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232115 | yapp monitor | RX pkt #555 on the input: addr=2 len=2 parity=bad gap=1 |
| 232115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232115 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 232205 | **DUT** | IN  pkt #556 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232235 | **DUT** | IN  pkt #556 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232235 | yapp monitor | RX pkt #556 on the input: addr=2 len=2 parity=bad gap=8 |
| 232235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 232445 | **DUT** | IN  pkt #557 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232475 | **DUT** | IN  pkt #557 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232475 | yapp monitor | RX pkt #557 on the input: addr=2 len=2 parity=bad gap=20 |
| 232475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 232685 | **DUT** | IN  pkt #558 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232715 | **DUT** | IN  pkt #558 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232715 | yapp monitor | RX pkt #558 on the input: addr=2 len=2 parity=bad gap=20 |
| 232715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 232925 | **DUT** | IN  pkt #559 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232955 | **DUT** | IN  pkt #559 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232955 | yapp monitor | RX pkt #559 on the input: addr=2 len=2 parity=bad gap=20 |
| 232955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 233165 | **DUT** | IN  pkt #560 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233195 | **DUT** | IN  pkt #560 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233195 | yapp monitor | RX pkt #560 on the input: addr=2 len=2 parity=bad gap=20 |
| 233195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233195 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 233335 | **DUT** | IN  pkt #561 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233365 | **DUT** | IN  pkt #561 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233365 | yapp monitor | RX pkt #561 on the input: addr=2 len=2 parity=bad gap=13 |
| 233365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233365 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 233505 | **DUT** | IN  pkt #562 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233535 | **DUT** | IN  pkt #562 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233535 | yapp monitor | RX pkt #562 on the input: addr=2 len=2 parity=bad gap=13 |
| 233535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 233745 | **DUT** | IN  pkt #563 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233775 | **DUT** | IN  pkt #563 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233775 | yapp monitor | RX pkt #563 on the input: addr=2 len=2 parity=bad gap=20 |
| 233775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233810 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 233855 | **DUT** | IN  pkt #564 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233885 | **DUT** | IN  pkt #564 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233885 | yapp monitor | RX pkt #564 on the input: addr=2 len=2 parity=bad gap=7 |
| 233885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 233975 | **DUT** | IN  pkt #565 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234005 | **DUT** | IN  pkt #565 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234005 | yapp monitor | RX pkt #565 on the input: addr=2 len=2 parity=bad gap=8 |
| 234005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234195 | **DUT** | IN  pkt #566 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234225 | **DUT** | IN  pkt #566 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234225 | yapp monitor | RX pkt #566 on the input: addr=2 len=2 parity=bad gap=18 |
| 234225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234295 | **DUT** | IN  pkt #567 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234325 | **DUT** | IN  pkt #567 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234325 | yapp monitor | RX pkt #567 on the input: addr=2 len=2 parity=bad gap=6 |
| 234325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 234370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234395 | **DUT** | IN  pkt #568 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234425 | **DUT** | IN  pkt #568 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234425 | yapp monitor | RX pkt #568 on the input: addr=2 len=2 parity=bad gap=6 |
| 234425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234445 | **DUT** | IN  pkt #569 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234475 | **DUT** | IN  pkt #569 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234475 | yapp monitor | RX pkt #569 on the input: addr=2 len=2 parity=bad gap=1 |
| 234475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 234675 | **DUT** | IN  pkt #570 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234705 | **DUT** | IN  pkt #570 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234705 | yapp monitor | RX pkt #570 on the input: addr=2 len=2 parity=bad gap=19 |
| 234705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234705 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 234905 | **DUT** | IN  pkt #571 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234935 | **DUT** | IN  pkt #571 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234935 | yapp monitor | RX pkt #571 on the input: addr=2 len=2 parity=bad gap=19 |
| 234935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 235005 | **DUT** | IN  pkt #572 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235035 | **DUT** | IN  pkt #572 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235035 | yapp monitor | RX pkt #572 on the input: addr=2 len=2 parity=bad gap=6 |
| 235035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 235205 | **DUT** | IN  pkt #573 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235235 | **DUT** | IN  pkt #573 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235235 | yapp monitor | RX pkt #573 on the input: addr=2 len=2 parity=bad gap=16 |
| 235235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 235435 | **DUT** | IN  pkt #574 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235465 | **DUT** | IN  pkt #574 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235465 | yapp monitor | RX pkt #574 on the input: addr=2 len=2 parity=bad gap=19 |
| 235465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235525 | **DUT** | IN  pkt #575 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 235555 | **DUT** | IN  pkt #575 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235555 | yapp monitor | RX pkt #575 on the input: addr=2 len=2 parity=bad gap=5 |
| 235555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235555 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 235635 | **DUT** | IN  pkt #576 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235665 | **DUT** | IN  pkt #576 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235665 | yapp monitor | RX pkt #576 on the input: addr=2 len=2 parity=bad gap=7 |
| 235665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235685 | **DUT** | IN  pkt #577 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235715 | **DUT** | IN  pkt #577 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235715 | yapp monitor | RX pkt #577 on the input: addr=2 len=2 parity=bad gap=1 |
| 235715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 235780 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 235835 | **DUT** | IN  pkt #578 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235865 | **DUT** | IN  pkt #578 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235865 | yapp monitor | RX pkt #578 on the input: addr=2 len=2 parity=bad gap=11 |
| 235865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 236005 | **DUT** | IN  pkt #579 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236035 | **DUT** | IN  pkt #579 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236035 | yapp monitor | RX pkt #579 on the input: addr=2 len=2 parity=bad gap=13 |
| 236035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236065 | **DUT** | IN  pkt #580 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 236095 | **DUT** | IN  pkt #580 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236095 | yapp monitor | RX pkt #580 on the input: addr=2 len=2 parity=bad gap=2 |
| 236095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 236295 | **DUT** | IN  pkt #581 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236325 | **DUT** | IN  pkt #581 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236325 | yapp monitor | RX pkt #581 on the input: addr=2 len=2 parity=bad gap=19 |
| 236325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 236435 | **DUT** | IN  pkt #582 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236465 | **DUT** | IN  pkt #582 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236465 | yapp monitor | RX pkt #582 on the input: addr=2 len=2 parity=bad gap=10 |
| 236465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 236595 | **DUT** | IN  pkt #583 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236625 | **DUT** | IN  pkt #583 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236625 | yapp monitor | RX pkt #583 on the input: addr=2 len=2 parity=bad gap=12 |
| 236625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 236835 | **DUT** | IN  pkt #584 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236865 | **DUT** | IN  pkt #584 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236865 | yapp monitor | RX pkt #584 on the input: addr=2 len=2 parity=bad gap=20 |
| 236865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 237025 | **DUT** | IN  pkt #585 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237055 | **DUT** | IN  pkt #585 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237055 | yapp monitor | RX pkt #585 on the input: addr=2 len=2 parity=bad gap=15 |
| 237055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237075 | **DUT** | IN  pkt #586 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237105 | **DUT** | IN  pkt #586 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237105 | yapp monitor | RX pkt #586 on the input: addr=2 len=2 parity=bad gap=1 |
| 237105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 237210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 237315 | **DUT** | IN  pkt #587 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237345 | **DUT** | IN  pkt #587 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237345 | yapp monitor | RX pkt #587 on the input: addr=2 len=2 parity=bad gap=20 |
| 237345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 237385 | **DUT** | IN  pkt #588 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237415 | **DUT** | IN  pkt #588 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237415 | yapp monitor | RX pkt #588 on the input: addr=2 len=2 parity=bad gap=3 |
| 237415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 237585 | **DUT** | IN  pkt #589 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237615 | **DUT** | IN  pkt #589 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237615 | yapp monitor | RX pkt #589 on the input: addr=2 len=2 parity=bad gap=16 |
| 237615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 237755 | **DUT** | IN  pkt #590 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237785 | **DUT** | IN  pkt #590 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237785 | yapp monitor | RX pkt #590 on the input: addr=2 len=2 parity=bad gap=13 |
| 237785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 237945 | **DUT** | IN  pkt #591 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237975 | **DUT** | IN  pkt #591 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237975 | yapp monitor | RX pkt #591 on the input: addr=2 len=2 parity=bad gap=15 |
| 237975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237975 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 238045 | **DUT** | IN  pkt #592 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238075 | **DUT** | IN  pkt #592 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238075 | yapp monitor | RX pkt #592 on the input: addr=2 len=2 parity=bad gap=6 |
| 238075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 238245 | **DUT** | IN  pkt #593 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238275 | **DUT** | IN  pkt #593 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238275 | yapp monitor | RX pkt #593 on the input: addr=2 len=2 parity=bad gap=16 |
| 238275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 238485 | **DUT** | IN  pkt #594 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238515 | **DUT** | IN  pkt #594 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238515 | yapp monitor | RX pkt #594 on the input: addr=2 len=2 parity=bad gap=20 |
| 238515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 238725 | **DUT** | IN  pkt #595 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238755 | **DUT** | IN  pkt #595 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238755 | yapp monitor | RX pkt #595 on the input: addr=2 len=2 parity=bad gap=20 |
| 238755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238755 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238810 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 238965 | **DUT** | IN  pkt #596 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238995 | **DUT** | IN  pkt #596 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238995 | yapp monitor | RX pkt #596 on the input: addr=2 len=2 parity=bad gap=20 |
| 238995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 239205 | **DUT** | IN  pkt #597 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239235 | **DUT** | IN  pkt #597 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239235 | yapp monitor | RX pkt #597 on the input: addr=2 len=2 parity=bad gap=20 |
| 239235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 239395 | **DUT** | IN  pkt #598 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239425 | **DUT** | IN  pkt #598 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239425 | yapp monitor | RX pkt #598 on the input: addr=2 len=2 parity=bad gap=15 |
| 239425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 239635 | **DUT** | IN  pkt #599 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239665 | **DUT** | IN  pkt #599 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239665 | yapp monitor | RX pkt #599 on the input: addr=2 len=2 parity=bad gap=20 |
| 239665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 239805 | **DUT** | IN  pkt #600 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239835 | **DUT** | IN  pkt #600 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239835 | yapp monitor | RX pkt #600 on the input: addr=2 len=2 parity=bad gap=13 |
| 239835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239835 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 240015 | **DUT** | IN  pkt #601 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240045 | **DUT** | IN  pkt #601 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240045 | yapp monitor | RX pkt #601 on the input: addr=2 len=2 parity=bad gap=17 |
| 240045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 240215 | **DUT** | IN  pkt #602 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240245 | **DUT** | IN  pkt #602 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240245 | yapp monitor | RX pkt #602 on the input: addr=2 len=2 parity=bad gap=16 |
| 240245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 240345 | **DUT** | IN  pkt #603 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240375 | **DUT** | IN  pkt #603 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240375 | yapp monitor | RX pkt #603 on the input: addr=2 len=2 parity=bad gap=9 |
| 240375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 240445 | **DUT** | IN  pkt #604 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240475 | **DUT** | IN  pkt #604 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240475 | yapp monitor | RX pkt #604 on the input: addr=2 len=2 parity=bad gap=6 |
| 240475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 240655 | **DUT** | IN  pkt #605 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240685 | **DUT** | IN  pkt #605 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240685 | yapp monitor | RX pkt #605 on the input: addr=2 len=2 parity=bad gap=17 |
| 240685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 240855 | **DUT** | IN  pkt #606 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240885 | **DUT** | IN  pkt #606 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240885 | yapp monitor | RX pkt #606 on the input: addr=2 len=2 parity=bad gap=16 |
| 240885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 241035 | **DUT** | IN  pkt #607 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241065 | **DUT** | IN  pkt #607 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241065 | yapp monitor | RX pkt #607 on the input: addr=2 len=2 parity=bad gap=14 |
| 241065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 241275 | **DUT** | IN  pkt #608 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241305 | **DUT** | IN  pkt #608 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241305 | yapp monitor | RX pkt #608 on the input: addr=2 len=2 parity=bad gap=20 |
| 241305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 241385 | **DUT** | IN  pkt #609 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241415 | **DUT** | IN  pkt #609 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241415 | yapp monitor | RX pkt #609 on the input: addr=2 len=2 parity=bad gap=7 |
| 241415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 241615 | **DUT** | IN  pkt #610 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241645 | **DUT** | IN  pkt #610 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241645 | yapp monitor | RX pkt #610 on the input: addr=2 len=2 parity=bad gap=19 |
| 241645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 241855 | **DUT** | IN  pkt #611 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241885 | **DUT** | IN  pkt #611 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241885 | yapp monitor | RX pkt #611 on the input: addr=2 len=2 parity=bad gap=20 |
| 241885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241925 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 241955 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 241970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 241985 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 242015 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 242045 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 242075 | hbus monitor | Collected READ  addr=0x100b data=0x64 |
| 242115 | **DUT** | IN  pkt #612 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242145 | **DUT** | IN  pkt #612 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242145 | yapp monitor | RX pkt #612 on the input: addr=2 len=2 parity=bad gap=22 |
| 242145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 242355 | **DUT** | IN  pkt #613 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242385 | **DUT** | IN  pkt #613 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242385 | yapp monitor | RX pkt #613 on the input: addr=2 len=2 parity=bad gap=20 |
| 242385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242385 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 242555 | **DUT** | IN  pkt #614 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242585 | **DUT** | IN  pkt #614 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242585 | yapp monitor | RX pkt #614 on the input: addr=2 len=2 parity=bad gap=16 |
| 242585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 242685 | **DUT** | IN  pkt #615 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242715 | **DUT** | IN  pkt #615 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242715 | yapp monitor | RX pkt #615 on the input: addr=2 len=2 parity=bad gap=9 |
| 242715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 242895 | **DUT** | IN  pkt #616 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242925 | **DUT** | IN  pkt #616 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242925 | yapp monitor | RX pkt #616 on the input: addr=2 len=2 parity=bad gap=17 |
| 242925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242975 | **DUT** | IN  pkt #617 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243005 | **DUT** | IN  pkt #617 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243005 | yapp monitor | RX pkt #617 on the input: addr=2 len=2 parity=bad gap=4 |
| 243005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 243095 | **DUT** | IN  pkt #618 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243125 | **DUT** | IN  pkt #618 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243125 | yapp monitor | RX pkt #618 on the input: addr=2 len=2 parity=bad gap=8 |
| 243125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243125 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 243225 | **DUT** | IN  pkt #619 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243255 | **DUT** | IN  pkt #619 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243255 | yapp monitor | RX pkt #619 on the input: addr=2 len=2 parity=bad gap=9 |
| 243255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 243435 | **DUT** | IN  pkt #620 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243465 | **DUT** | IN  pkt #620 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243465 | yapp monitor | RX pkt #620 on the input: addr=2 len=2 parity=bad gap=17 |
| 243465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243525 | **DUT** | IN  pkt #621 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243555 | **DUT** | IN  pkt #621 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243555 | yapp monitor | RX pkt #621 on the input: addr=2 len=2 parity=bad gap=5 |
| 243555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243555 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 243665 | **DUT** | IN  pkt #622 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243695 | **DUT** | IN  pkt #622 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243695 | yapp monitor | RX pkt #622 on the input: addr=2 len=2 parity=bad gap=10 |
| 243695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 243765 | **DUT** | IN  pkt #623 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243795 | **DUT** | IN  pkt #623 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243795 | yapp monitor | RX pkt #623 on the input: addr=2 len=2 parity=bad gap=6 |
| 243795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243845 | **DUT** | IN  pkt #624 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 243875 | **DUT** | IN  pkt #624 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243875 | yapp monitor | RX pkt #624 on the input: addr=2 len=2 parity=bad gap=4 |
| 243875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243930 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 243985 | **DUT** | IN  pkt #625 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244015 | **DUT** | IN  pkt #625 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244015 | yapp monitor | RX pkt #625 on the input: addr=2 len=2 parity=bad gap=10 |
| 244015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 244185 | **DUT** | IN  pkt #626 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244215 | **DUT** | IN  pkt #626 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244215 | yapp monitor | RX pkt #626 on the input: addr=2 len=2 parity=bad gap=16 |
| 244215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244230 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 244355 | **DUT** | IN  pkt #627 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244385 | **DUT** | IN  pkt #627 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244385 | yapp monitor | RX pkt #627 on the input: addr=2 len=2 parity=bad gap=13 |
| 244385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244385 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 244475 | **DUT** | IN  pkt #628 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244505 | **DUT** | IN  pkt #628 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244505 | yapp monitor | RX pkt #628 on the input: addr=2 len=2 parity=bad gap=8 |
| 244505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 244675 | **DUT** | IN  pkt #629 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244705 | **DUT** | IN  pkt #629 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244705 | yapp monitor | RX pkt #629 on the input: addr=2 len=2 parity=bad gap=16 |
| 244705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244705 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 244865 | **DUT** | IN  pkt #630 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244895 | **DUT** | IN  pkt #630 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244895 | yapp monitor | RX pkt #630 on the input: addr=2 len=2 parity=bad gap=15 |
| 244895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 245075 | **DUT** | IN  pkt #631 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245105 | **DUT** | IN  pkt #631 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245105 | yapp monitor | RX pkt #631 on the input: addr=2 len=2 parity=bad gap=17 |
| 245105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 245265 | **DUT** | IN  pkt #632 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245295 | **DUT** | IN  pkt #632 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245295 | yapp monitor | RX pkt #632 on the input: addr=2 len=2 parity=bad gap=15 |
| 245295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 245385 | **DUT** | IN  pkt #633 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245415 | **DUT** | IN  pkt #633 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245415 | yapp monitor | RX pkt #633 on the input: addr=2 len=2 parity=bad gap=8 |
| 245415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245445 | **DUT** | IN  pkt #634 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245475 | **DUT** | IN  pkt #634 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245475 | yapp monitor | RX pkt #634 on the input: addr=2 len=2 parity=bad gap=2 |
| 245475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 245530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 245655 | **DUT** | IN  pkt #635 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245685 | **DUT** | IN  pkt #635 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245685 | yapp monitor | RX pkt #635 on the input: addr=2 len=2 parity=bad gap=17 |
| 245685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245715 | **DUT** | IN  pkt #636 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 245745 | **DUT** | IN  pkt #636 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245745 | yapp monitor | RX pkt #636 on the input: addr=2 len=2 parity=bad gap=2 |
| 245745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 245855 | **DUT** | IN  pkt #637 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245885 | **DUT** | IN  pkt #637 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245885 | yapp monitor | RX pkt #637 on the input: addr=2 len=2 parity=bad gap=10 |
| 245885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245965 | **DUT** | IN  pkt #638 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 245995 | **DUT** | IN  pkt #638 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245995 | yapp monitor | RX pkt #638 on the input: addr=2 len=2 parity=bad gap=7 |
| 245995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 246205 | **DUT** | IN  pkt #639 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246235 | **DUT** | IN  pkt #639 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246235 | yapp monitor | RX pkt #639 on the input: addr=2 len=2 parity=bad gap=20 |
| 246235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 246445 | **DUT** | IN  pkt #640 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246475 | **DUT** | IN  pkt #640 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246475 | yapp monitor | RX pkt #640 on the input: addr=2 len=2 parity=bad gap=20 |
| 246475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 246655 | **DUT** | IN  pkt #641 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246685 | **DUT** | IN  pkt #641 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246685 | yapp monitor | RX pkt #641 on the input: addr=2 len=2 parity=bad gap=17 |
| 246685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246755 | **DUT** | IN  pkt #642 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246770 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 246785 | **DUT** | IN  pkt #642 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246785 | yapp monitor | RX pkt #642 on the input: addr=2 len=2 parity=bad gap=6 |
| 246785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 246975 | **DUT** | IN  pkt #643 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247005 | **DUT** | IN  pkt #643 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247005 | yapp monitor | RX pkt #643 on the input: addr=2 len=2 parity=bad gap=18 |
| 247005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 247145 | **DUT** | IN  pkt #644 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247175 | **DUT** | IN  pkt #644 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247175 | yapp monitor | RX pkt #644 on the input: addr=2 len=2 parity=bad gap=13 |
| 247175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 247325 | **DUT** | IN  pkt #645 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247355 | **DUT** | IN  pkt #645 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247355 | yapp monitor | RX pkt #645 on the input: addr=2 len=2 parity=bad gap=14 |
| 247355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247355 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 247415 | **DUT** | IN  pkt #646 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247445 | **DUT** | IN  pkt #646 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247445 | yapp monitor | RX pkt #646 on the input: addr=2 len=2 parity=bad gap=5 |
| 247445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247465 | **DUT** | IN  pkt #647 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247490 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 247495 | **DUT** | IN  pkt #647 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247495 | yapp monitor | RX pkt #647 on the input: addr=2 len=2 parity=bad gap=1 |
| 247495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247535 | **DUT** | IN  pkt #648 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247565 | **DUT** | IN  pkt #648 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247565 | yapp monitor | RX pkt #648 on the input: addr=2 len=2 parity=bad gap=3 |
| 247565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247565 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 247630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 247725 | **DUT** | IN  pkt #649 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247755 | **DUT** | IN  pkt #649 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247755 | yapp monitor | RX pkt #649 on the input: addr=2 len=2 parity=bad gap=15 |
| 247755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247755 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 247815 | **DUT** | IN  pkt #650 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247845 | **DUT** | IN  pkt #650 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247845 | yapp monitor | RX pkt #650 on the input: addr=2 len=2 parity=bad gap=5 |
| 247845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 248055 | **DUT** | IN  pkt #651 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248085 | **DUT** | IN  pkt #651 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248085 | yapp monitor | RX pkt #651 on the input: addr=2 len=2 parity=bad gap=20 |
| 248085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 248195 | **DUT** | IN  pkt #652 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248225 | **DUT** | IN  pkt #652 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248225 | yapp monitor | RX pkt #652 on the input: addr=2 len=2 parity=bad gap=10 |
| 248225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 248435 | **DUT** | IN  pkt #653 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248465 | **DUT** | IN  pkt #653 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248465 | yapp monitor | RX pkt #653 on the input: addr=2 len=2 parity=bad gap=20 |
| 248465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 248645 | **DUT** | IN  pkt #654 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248675 | **DUT** | IN  pkt #654 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248675 | yapp monitor | RX pkt #654 on the input: addr=2 len=2 parity=bad gap=17 |
| 248675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248705 | **DUT** | IN  pkt #655 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248730 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 248735 | **DUT** | IN  pkt #655 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248735 | yapp monitor | RX pkt #655 on the input: addr=2 len=2 parity=bad gap=2 |
| 248735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 248945 | **DUT** | IN  pkt #656 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248975 | **DUT** | IN  pkt #656 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248975 | yapp monitor | RX pkt #656 on the input: addr=2 len=2 parity=bad gap=20 |
| 248975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248975 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 249185 | **DUT** | IN  pkt #657 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249215 | **DUT** | IN  pkt #657 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249215 | yapp monitor | RX pkt #657 on the input: addr=2 len=2 parity=bad gap=20 |
| 249215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 249375 | **DUT** | IN  pkt #658 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249405 | **DUT** | IN  pkt #658 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249405 | yapp monitor | RX pkt #658 on the input: addr=2 len=2 parity=bad gap=15 |
| 249405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 249605 | **DUT** | IN  pkt #659 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249635 | **DUT** | IN  pkt #659 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249635 | yapp monitor | RX pkt #659 on the input: addr=2 len=2 parity=bad gap=19 |
| 249635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249635 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249685 | **DUT** | IN  pkt #660 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 249715 | **DUT** | IN  pkt #660 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249715 | yapp monitor | RX pkt #660 on the input: addr=2 len=2 parity=bad gap=4 |
| 249715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249765 | **DUT** | IN  pkt #661 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 249795 | **DUT** | IN  pkt #661 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249795 | yapp monitor | RX pkt #661 on the input: addr=2 len=2 parity=bad gap=4 |
| 249795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249850 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 250005 | **DUT** | IN  pkt #662 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250035 | **DUT** | IN  pkt #662 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250035 | yapp monitor | RX pkt #662 on the input: addr=2 len=2 parity=bad gap=20 |
| 250035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 250235 | **DUT** | IN  pkt #663 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250265 | **DUT** | IN  pkt #663 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250265 | yapp monitor | RX pkt #663 on the input: addr=2 len=2 parity=bad gap=19 |
| 250265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250310 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 250475 | **DUT** | IN  pkt #664 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250505 | **DUT** | IN  pkt #664 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250505 | yapp monitor | RX pkt #664 on the input: addr=2 len=2 parity=bad gap=20 |
| 250505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250565 | **DUT** | IN  pkt #665 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 250595 | **DUT** | IN  pkt #665 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250595 | yapp monitor | RX pkt #665 on the input: addr=2 len=2 parity=bad gap=5 |
| 250595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250595 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 250805 | **DUT** | IN  pkt #666 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250835 | **DUT** | IN  pkt #666 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250835 | yapp monitor | RX pkt #666 on the input: addr=2 len=2 parity=bad gap=20 |
| 250835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250835 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 251045 | **DUT** | IN  pkt #667 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251075 | **DUT** | IN  pkt #667 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251075 | yapp monitor | RX pkt #667 on the input: addr=2 len=2 parity=bad gap=20 |
| 251075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251130 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 251235 | **DUT** | IN  pkt #668 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251265 | **DUT** | IN  pkt #668 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251265 | yapp monitor | RX pkt #668 on the input: addr=2 len=2 parity=bad gap=15 |
| 251265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 251405 | **DUT** | IN  pkt #669 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251435 | **DUT** | IN  pkt #669 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251435 | yapp monitor | RX pkt #669 on the input: addr=2 len=2 parity=bad gap=13 |
| 251435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 251605 | **DUT** | IN  pkt #670 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251635 | **DUT** | IN  pkt #670 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251635 | yapp monitor | RX pkt #670 on the input: addr=2 len=2 parity=bad gap=16 |
| 251635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251635 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 251835 | **DUT** | IN  pkt #671 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251865 | **DUT** | IN  pkt #671 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251865 | yapp monitor | RX pkt #671 on the input: addr=2 len=2 parity=bad gap=19 |
| 251865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 252035 | **DUT** | IN  pkt #672 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252065 | **DUT** | IN  pkt #672 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252065 | yapp monitor | RX pkt #672 on the input: addr=2 len=2 parity=bad gap=16 |
| 252065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 252275 | **DUT** | IN  pkt #673 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252305 | **DUT** | IN  pkt #673 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252305 | yapp monitor | RX pkt #673 on the input: addr=2 len=2 parity=bad gap=20 |
| 252305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252410 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 252445 | **DUT** | IN  pkt #674 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252475 | **DUT** | IN  pkt #674 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252475 | yapp monitor | RX pkt #674 on the input: addr=2 len=2 parity=bad gap=13 |
| 252475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 252685 | **DUT** | IN  pkt #675 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252715 | **DUT** | IN  pkt #675 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252715 | yapp monitor | RX pkt #675 on the input: addr=2 len=2 parity=bad gap=20 |
| 252715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 252925 | **DUT** | IN  pkt #676 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252955 | **DUT** | IN  pkt #676 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252955 | yapp monitor | RX pkt #676 on the input: addr=2 len=2 parity=bad gap=20 |
| 252955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 253005 | **DUT** | IN  pkt #677 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253035 | **DUT** | IN  pkt #677 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253035 | yapp monitor | RX pkt #677 on the input: addr=2 len=2 parity=bad gap=4 |
| 253035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253055 | **DUT** | IN  pkt #678 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 253085 | **DUT** | IN  pkt #678 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253085 | yapp monitor | RX pkt #678 on the input: addr=2 len=2 parity=bad gap=1 |
| 253085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 253285 | **DUT** | IN  pkt #679 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253315 | **DUT** | IN  pkt #679 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253315 | yapp monitor | RX pkt #679 on the input: addr=2 len=2 parity=bad gap=19 |
| 253315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 253395 | **DUT** | IN  pkt #680 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253425 | **DUT** | IN  pkt #680 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253425 | yapp monitor | RX pkt #680 on the input: addr=2 len=2 parity=bad gap=7 |
| 253425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 253625 | **DUT** | IN  pkt #681 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253655 | **DUT** | IN  pkt #681 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253655 | yapp monitor | RX pkt #681 on the input: addr=2 len=2 parity=bad gap=19 |
| 253655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 253865 | **DUT** | IN  pkt #682 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253895 | **DUT** | IN  pkt #682 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253895 | yapp monitor | RX pkt #682 on the input: addr=2 len=2 parity=bad gap=20 |
| 253895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 254105 | **DUT** | IN  pkt #683 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254135 | **DUT** | IN  pkt #683 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254135 | yapp monitor | RX pkt #683 on the input: addr=2 len=2 parity=bad gap=20 |
| 254135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 254265 | **DUT** | IN  pkt #684 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254295 | **DUT** | IN  pkt #684 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254295 | yapp monitor | RX pkt #684 on the input: addr=2 len=2 parity=bad gap=12 |
| 254295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 254505 | **DUT** | IN  pkt #685 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254535 | **DUT** | IN  pkt #685 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254535 | yapp monitor | RX pkt #685 on the input: addr=2 len=2 parity=bad gap=20 |
| 254535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 254745 | **DUT** | IN  pkt #686 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254775 | **DUT** | IN  pkt #686 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254775 | yapp monitor | RX pkt #686 on the input: addr=2 len=2 parity=bad gap=20 |
| 254775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254790 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 254955 | **DUT** | IN  pkt #687 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254985 | **DUT** | IN  pkt #687 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254985 | yapp monitor | RX pkt #687 on the input: addr=2 len=2 parity=bad gap=17 |
| 254985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 255195 | **DUT** | IN  pkt #688 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255225 | **DUT** | IN  pkt #688 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255225 | yapp monitor | RX pkt #688 on the input: addr=2 len=2 parity=bad gap=20 |
| 255225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 255395 | **DUT** | IN  pkt #689 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255425 | **DUT** | IN  pkt #689 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255425 | yapp monitor | RX pkt #689 on the input: addr=2 len=2 parity=bad gap=16 |
| 255425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 255495 | **DUT** | IN  pkt #690 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255525 | **DUT** | IN  pkt #690 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255525 | yapp monitor | RX pkt #690 on the input: addr=2 len=2 parity=bad gap=6 |
| 255525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 255595 | **DUT** | IN  pkt #691 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255625 | **DUT** | IN  pkt #691 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255625 | yapp monitor | RX pkt #691 on the input: addr=2 len=2 parity=bad gap=6 |
| 255625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255655 | **DUT** | IN  pkt #692 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255685 | **DUT** | IN  pkt #692 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255685 | yapp monitor | RX pkt #692 on the input: addr=2 len=2 parity=bad gap=2 |
| 255685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255690 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 255710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 255895 | **DUT** | IN  pkt #693 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255925 | **DUT** | IN  pkt #693 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255925 | yapp monitor | RX pkt #693 on the input: addr=2 len=2 parity=bad gap=20 |
| 255925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 256125 | **DUT** | IN  pkt #694 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256155 | **DUT** | IN  pkt #694 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256155 | yapp monitor | RX pkt #694 on the input: addr=2 len=2 parity=bad gap=19 |
| 256155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256155 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256170 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 256365 | **DUT** | IN  pkt #695 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256395 | **DUT** | IN  pkt #695 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256395 | yapp monitor | RX pkt #695 on the input: addr=2 len=2 parity=bad gap=20 |
| 256395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256395 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 256535 | **DUT** | IN  pkt #696 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256565 | **DUT** | IN  pkt #696 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256565 | yapp monitor | RX pkt #696 on the input: addr=2 len=2 parity=bad gap=13 |
| 256565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256565 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 256745 | **DUT** | IN  pkt #697 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256775 | **DUT** | IN  pkt #697 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256775 | yapp monitor | RX pkt #697 on the input: addr=2 len=2 parity=bad gap=17 |
| 256775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256795 | **DUT** | IN  pkt #698 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256825 | **DUT** | IN  pkt #698 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256825 | yapp monitor | RX pkt #698 on the input: addr=2 len=2 parity=bad gap=1 |
| 256825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 256880 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 256965 | **DUT** | IN  pkt #699 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256995 | **DUT** | IN  pkt #699 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256995 | yapp monitor | RX pkt #699 on the input: addr=2 len=2 parity=bad gap=13 |
| 256995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 257145 | **DUT** | IN  pkt #700 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257175 | **DUT** | IN  pkt #700 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257175 | yapp monitor | RX pkt #700 on the input: addr=2 len=2 parity=bad gap=14 |
| 257175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257190 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 257205 | **DUT** | IN  pkt #701 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257235 | **DUT** | IN  pkt #701 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257235 | yapp monitor | RX pkt #701 on the input: addr=2 len=2 parity=bad gap=2 |
| 257235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 257415 | **DUT** | IN  pkt #702 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257445 | **DUT** | IN  pkt #702 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257445 | yapp monitor | RX pkt #702 on the input: addr=2 len=2 parity=bad gap=17 |
| 257445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 257475 | **DUT** | IN  pkt #703 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257505 | **DUT** | IN  pkt #703 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257505 | yapp monitor | RX pkt #703 on the input: addr=2 len=2 parity=bad gap=2 |
| 257505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 257715 | **DUT** | IN  pkt #704 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257745 | **DUT** | IN  pkt #704 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257745 | yapp monitor | RX pkt #704 on the input: addr=2 len=2 parity=bad gap=20 |
| 257745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 257955 | **DUT** | IN  pkt #705 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257985 | **DUT** | IN  pkt #705 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257985 | yapp monitor | RX pkt #705 on the input: addr=2 len=2 parity=bad gap=20 |
| 257985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 258025 | **DUT** | IN  pkt #706 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258055 | **DUT** | IN  pkt #706 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258055 | yapp monitor | RX pkt #706 on the input: addr=2 len=2 parity=bad gap=3 |
| 258055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258150 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 258225 | **DUT** | IN  pkt #707 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258255 | **DUT** | IN  pkt #707 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258255 | yapp monitor | RX pkt #707 on the input: addr=2 len=2 parity=bad gap=16 |
| 258255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 258465 | **DUT** | IN  pkt #708 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258495 | **DUT** | IN  pkt #708 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258495 | yapp monitor | RX pkt #708 on the input: addr=2 len=2 parity=bad gap=20 |
| 258495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 258665 | **DUT** | IN  pkt #709 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258695 | **DUT** | IN  pkt #709 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258695 | yapp monitor | RX pkt #709 on the input: addr=2 len=2 parity=bad gap=16 |
| 258695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 258825 | **DUT** | IN  pkt #710 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258855 | **DUT** | IN  pkt #710 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258855 | yapp monitor | RX pkt #710 on the input: addr=2 len=2 parity=bad gap=12 |
| 258855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 258965 | **DUT** | IN  pkt #711 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258995 | **DUT** | IN  pkt #711 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258995 | yapp monitor | RX pkt #711 on the input: addr=2 len=2 parity=bad gap=10 |
| 258995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 259185 | **DUT** | IN  pkt #712 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259215 | **DUT** | IN  pkt #712 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259215 | yapp monitor | RX pkt #712 on the input: addr=2 len=2 parity=bad gap=18 |
| 259215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 259325 | **DUT** | IN  pkt #713 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259355 | **DUT** | IN  pkt #713 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259355 | yapp monitor | RX pkt #713 on the input: addr=2 len=2 parity=bad gap=10 |
| 259355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259355 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 259415 | **DUT** | IN  pkt #714 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259445 | **DUT** | IN  pkt #714 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259445 | yapp monitor | RX pkt #714 on the input: addr=2 len=2 parity=bad gap=5 |
| 259445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259490 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 259585 | **DUT** | IN  pkt #715 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259615 | **DUT** | IN  pkt #715 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259615 | yapp monitor | RX pkt #715 on the input: addr=2 len=2 parity=bad gap=13 |
| 259615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 259785 | **DUT** | IN  pkt #716 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259815 | **DUT** | IN  pkt #716 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259815 | yapp monitor | RX pkt #716 on the input: addr=2 len=2 parity=bad gap=16 |
| 259815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259910 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 260015 | **DUT** | IN  pkt #717 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260045 | **DUT** | IN  pkt #717 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260045 | yapp monitor | RX pkt #717 on the input: addr=2 len=2 parity=bad gap=19 |
| 260045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 260225 | **DUT** | IN  pkt #718 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260255 | **DUT** | IN  pkt #718 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260255 | yapp monitor | RX pkt #718 on the input: addr=2 len=2 parity=bad gap=17 |
| 260255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260345 | **DUT** | IN  pkt #719 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260375 | **DUT** | IN  pkt #719 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260375 | yapp monitor | RX pkt #719 on the input: addr=2 len=2 parity=bad gap=8 |
| 260375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 260525 | **DUT** | IN  pkt #720 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260555 | **DUT** | IN  pkt #720 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260555 | yapp monitor | RX pkt #720 on the input: addr=2 len=2 parity=bad gap=14 |
| 260555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260555 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 260765 | **DUT** | IN  pkt #721 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260795 | **DUT** | IN  pkt #721 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260795 | yapp monitor | RX pkt #721 on the input: addr=2 len=2 parity=bad gap=20 |
| 260795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 260905 | **DUT** | IN  pkt #722 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260935 | **DUT** | IN  pkt #722 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260935 | yapp monitor | RX pkt #722 on the input: addr=2 len=2 parity=bad gap=10 |
| 260935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261030 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 261075 | **DUT** | IN  pkt #723 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261105 | **DUT** | IN  pkt #723 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261105 | yapp monitor | RX pkt #723 on the input: addr=2 len=2 parity=bad gap=13 |
| 261105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261155 | **DUT** | IN  pkt #724 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261185 | **DUT** | IN  pkt #724 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261185 | yapp monitor | RX pkt #724 on the input: addr=2 len=2 parity=bad gap=4 |
| 261185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 261220 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 261385 | **DUT** | IN  pkt #725 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261415 | **DUT** | IN  pkt #725 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261415 | yapp monitor | RX pkt #725 on the input: addr=2 len=2 parity=bad gap=19 |
| 261415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 261625 | **DUT** | IN  pkt #726 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261655 | **DUT** | IN  pkt #726 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261655 | yapp monitor | RX pkt #726 on the input: addr=2 len=2 parity=bad gap=20 |
| 261655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 261815 | **DUT** | IN  pkt #727 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261845 | **DUT** | IN  pkt #727 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261845 | yapp monitor | RX pkt #727 on the input: addr=2 len=2 parity=bad gap=15 |
| 261845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261865 | **DUT** | IN  pkt #728 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261890 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 261895 | **DUT** | IN  pkt #728 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261895 | yapp monitor | RX pkt #728 on the input: addr=2 len=2 parity=bad gap=1 |
| 261895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261925 | **DUT** | IN  pkt #729 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261955 | **DUT** | IN  pkt #729 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261955 | yapp monitor | RX pkt #729 on the input: addr=2 len=2 parity=bad gap=2 |
| 261955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 262010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 262135 | **DUT** | IN  pkt #730 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262165 | **DUT** | IN  pkt #730 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262165 | yapp monitor | RX pkt #730 on the input: addr=2 len=2 parity=bad gap=17 |
| 262165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 262255 | **DUT** | IN  pkt #731 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262285 | **DUT** | IN  pkt #731 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262285 | yapp monitor | RX pkt #731 on the input: addr=2 len=2 parity=bad gap=8 |
| 262285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 262495 | **DUT** | IN  pkt #732 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262525 | **DUT** | IN  pkt #732 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262525 | yapp monitor | RX pkt #732 on the input: addr=2 len=2 parity=bad gap=20 |
| 262525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262555 | **DUT** | IN  pkt #733 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262585 | **DUT** | IN  pkt #733 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262585 | yapp monitor | RX pkt #733 on the input: addr=2 len=2 parity=bad gap=2 |
| 262585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 262630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 262795 | **DUT** | IN  pkt #734 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262825 | **DUT** | IN  pkt #734 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262825 | yapp monitor | RX pkt #734 on the input: addr=2 len=2 parity=bad gap=20 |
| 262825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 263035 | **DUT** | IN  pkt #735 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263065 | **DUT** | IN  pkt #735 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263065 | yapp monitor | RX pkt #735 on the input: addr=2 len=2 parity=bad gap=20 |
| 263065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 263235 | **DUT** | IN  pkt #736 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263265 | **DUT** | IN  pkt #736 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263265 | yapp monitor | RX pkt #736 on the input: addr=2 len=2 parity=bad gap=16 |
| 263265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263395 | **DUT** | IN  pkt #737 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263425 | **DUT** | IN  pkt #737 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263425 | yapp monitor | RX pkt #737 on the input: addr=2 len=2 parity=bad gap=12 |
| 263425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263425 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263545 | **DUT** | IN  pkt #738 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263575 | **DUT** | IN  pkt #738 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263575 | yapp monitor | RX pkt #738 on the input: addr=2 len=2 parity=bad gap=11 |
| 263575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 263755 | **DUT** | IN  pkt #739 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263785 | **DUT** | IN  pkt #739 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263785 | yapp monitor | RX pkt #739 on the input: addr=2 len=2 parity=bad gap=17 |
| 263785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263815 | **DUT** | IN  pkt #740 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263845 | **DUT** | IN  pkt #740 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263845 | yapp monitor | RX pkt #740 on the input: addr=2 len=2 parity=bad gap=2 |
| 263845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 263870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263995 | **DUT** | IN  pkt #741 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264025 | **DUT** | IN  pkt #741 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264025 | yapp monitor | RX pkt #741 on the input: addr=2 len=2 parity=bad gap=14 |
| 264025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 264195 | **DUT** | IN  pkt #742 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264225 | **DUT** | IN  pkt #742 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264225 | yapp monitor | RX pkt #742 on the input: addr=2 len=2 parity=bad gap=16 |
| 264225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 264255 | **DUT** | IN  pkt #743 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264285 | **DUT** | IN  pkt #743 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264285 | yapp monitor | RX pkt #743 on the input: addr=2 len=2 parity=bad gap=2 |
| 264285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 264495 | **DUT** | IN  pkt #744 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264525 | **DUT** | IN  pkt #744 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264525 | yapp monitor | RX pkt #744 on the input: addr=2 len=2 parity=bad gap=20 |
| 264525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264590 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 264735 | **DUT** | IN  pkt #745 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264765 | **DUT** | IN  pkt #745 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264765 | yapp monitor | RX pkt #745 on the input: addr=2 len=2 parity=bad gap=20 |
| 264765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264850 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 264925 | **DUT** | IN  pkt #746 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264955 | **DUT** | IN  pkt #746 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264955 | yapp monitor | RX pkt #746 on the input: addr=2 len=2 parity=bad gap=15 |
| 264955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 265045 | **DUT** | IN  pkt #747 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265075 | **DUT** | IN  pkt #747 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265075 | yapp monitor | RX pkt #747 on the input: addr=2 len=2 parity=bad gap=8 |
| 265075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 265285 | **DUT** | IN  pkt #748 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265315 | **DUT** | IN  pkt #748 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265315 | yapp monitor | RX pkt #748 on the input: addr=2 len=2 parity=bad gap=20 |
| 265315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 265485 | **DUT** | IN  pkt #749 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265515 | **DUT** | IN  pkt #749 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265515 | yapp monitor | RX pkt #749 on the input: addr=2 len=2 parity=bad gap=16 |
| 265515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 265555 | **DUT** | IN  pkt #750 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265585 | **DUT** | IN  pkt #750 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265585 | yapp monitor | RX pkt #750 on the input: addr=2 len=2 parity=bad gap=3 |
| 265585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 265745 | **DUT** | IN  pkt #751 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265775 | **DUT** | IN  pkt #751 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265775 | yapp monitor | RX pkt #751 on the input: addr=2 len=2 parity=bad gap=15 |
| 265775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265810 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 265965 | **DUT** | IN  pkt #752 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265995 | **DUT** | IN  pkt #752 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265995 | yapp monitor | RX pkt #752 on the input: addr=2 len=2 parity=bad gap=18 |
| 265995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 266205 | **DUT** | IN  pkt #753 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266235 | **DUT** | IN  pkt #753 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266235 | yapp monitor | RX pkt #753 on the input: addr=2 len=2 parity=bad gap=20 |
| 266235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 266445 | **DUT** | IN  pkt #754 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266475 | **DUT** | IN  pkt #754 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266475 | yapp monitor | RX pkt #754 on the input: addr=2 len=2 parity=bad gap=20 |
| 266475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 266625 | **DUT** | IN  pkt #755 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266655 | **DUT** | IN  pkt #755 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266655 | yapp monitor | RX pkt #755 on the input: addr=2 len=2 parity=bad gap=14 |
| 266655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266705 | **DUT** | IN  pkt #756 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 266735 | **DUT** | IN  pkt #756 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266735 | yapp monitor | RX pkt #756 on the input: addr=2 len=2 parity=bad gap=4 |
| 266735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 266915 | **DUT** | IN  pkt #757 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266945 | **DUT** | IN  pkt #757 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266945 | yapp monitor | RX pkt #757 on the input: addr=2 len=2 parity=bad gap=17 |
| 266945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 267155 | **DUT** | IN  pkt #758 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267185 | **DUT** | IN  pkt #758 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267185 | yapp monitor | RX pkt #758 on the input: addr=2 len=2 parity=bad gap=20 |
| 267185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267205 | **DUT** | IN  pkt #759 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267235 | **DUT** | IN  pkt #759 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267235 | yapp monitor | RX pkt #759 on the input: addr=2 len=2 parity=bad gap=1 |
| 267235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 267295 | **DUT** | IN  pkt #760 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267300 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 267325 | **DUT** | IN  pkt #760 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267325 | yapp monitor | RX pkt #760 on the input: addr=2 len=2 parity=bad gap=5 |
| 267325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267325 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 267465 | **DUT** | IN  pkt #761 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267495 | **DUT** | IN  pkt #761 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267495 | yapp monitor | RX pkt #761 on the input: addr=2 len=2 parity=bad gap=13 |
| 267495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 267695 | **DUT** | IN  pkt #762 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267725 | **DUT** | IN  pkt #762 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267725 | yapp monitor | RX pkt #762 on the input: addr=2 len=2 parity=bad gap=19 |
| 267725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 267925 | **DUT** | IN  pkt #763 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267955 | **DUT** | IN  pkt #763 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267955 | yapp monitor | RX pkt #763 on the input: addr=2 len=2 parity=bad gap=19 |
| 267955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267975 | **DUT** | IN  pkt #764 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268005 | **DUT** | IN  pkt #764 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268005 | yapp monitor | RX pkt #764 on the input: addr=2 len=2 parity=bad gap=1 |
| 268005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268005 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 268040 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 268215 | **DUT** | IN  pkt #765 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268245 | **DUT** | IN  pkt #765 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268245 | yapp monitor | RX pkt #765 on the input: addr=2 len=2 parity=bad gap=20 |
| 268245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 268445 | **DUT** | IN  pkt #766 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268475 | **DUT** | IN  pkt #766 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268475 | yapp monitor | RX pkt #766 on the input: addr=2 len=2 parity=bad gap=19 |
| 268475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 268515 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 268545 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 268575 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 268605 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 268635 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 268660 | **test** | STAGE: 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 268665 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 268685 | hbus monitor | Collected WRITE addr=0x1001 data=0x81 |
| 268685 | reference | router_en is now 1 (en_reg 0x81) |
| 268825 | **DUT** | IN  pkt #767 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268855 | **DUT** | IN  pkt #767 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268855 | yapp monitor | RX pkt #767 on the input: addr=3 len=2 parity=bad gap=34 |
| 268855 | reference | Packet dropped: illegal address 3 (len=2) |
| 268855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 268870 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 268965 | **DUT** | IN  pkt #768 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268995 | **DUT** | IN  pkt #768 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268995 | yapp monitor | RX pkt #768 on the input: addr=3 len=2 parity=bad gap=10 |
| 268995 | reference | Packet dropped: illegal address 3 (len=2) |
| 268995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 269145 | **DUT** | IN  pkt #769 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269175 | **DUT** | IN  pkt #769 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269175 | yapp monitor | RX pkt #769 on the input: addr=3 len=2 parity=bad gap=14 |
| 269175 | reference | Packet dropped: illegal address 3 (len=2) |
| 269175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269190 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269245 | **DUT** | IN  pkt #770 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269275 | **DUT** | IN  pkt #770 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269275 | yapp monitor | RX pkt #770 on the input: addr=3 len=2 parity=bad gap=6 |
| 269275 | reference | Packet dropped: illegal address 3 (len=2) |
| 269275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269425 | **DUT** | IN  pkt #771 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269455 | **DUT** | IN  pkt #771 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269455 | yapp monitor | RX pkt #771 on the input: addr=3 len=2 parity=bad gap=14 |
| 269455 | reference | Packet dropped: illegal address 3 (len=2) |
| 269455 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 269625 | **DUT** | IN  pkt #772 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269655 | **DUT** | IN  pkt #772 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269655 | yapp monitor | RX pkt #772 on the input: addr=3 len=2 parity=bad gap=16 |
| 269655 | reference | Packet dropped: illegal address 3 (len=2) |
| 269655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269675 | **DUT** | IN  pkt #773 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269705 | **DUT** | IN  pkt #773 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269705 | yapp monitor | RX pkt #773 on the input: addr=3 len=2 parity=bad gap=1 |
| 269705 | reference | Packet dropped: illegal address 3 (len=2) |
| 269705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 269775 | **DUT** | IN  pkt #774 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269805 | **DUT** | IN  pkt #774 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269805 | yapp monitor | RX pkt #774 on the input: addr=3 len=2 parity=bad gap=6 |
| 269805 | reference | Packet dropped: illegal address 3 (len=2) |
| 269805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 269870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 270015 | **DUT** | IN  pkt #775 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270045 | **DUT** | IN  pkt #775 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270045 | yapp monitor | RX pkt #775 on the input: addr=3 len=2 parity=bad gap=20 |
| 270045 | reference | Packet dropped: illegal address 3 (len=2) |
| 270045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 270255 | **DUT** | IN  pkt #776 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270285 | **DUT** | IN  pkt #776 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270285 | yapp monitor | RX pkt #776 on the input: addr=3 len=2 parity=bad gap=20 |
| 270285 | reference | Packet dropped: illegal address 3 (len=2) |
| 270285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 270375 | **DUT** | IN  pkt #777 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270405 | **DUT** | IN  pkt #777 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270405 | yapp monitor | RX pkt #777 on the input: addr=3 len=2 parity=bad gap=8 |
| 270405 | reference | Packet dropped: illegal address 3 (len=2) |
| 270405 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 270595 | **DUT** | IN  pkt #778 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270625 | **DUT** | IN  pkt #778 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270625 | yapp monitor | RX pkt #778 on the input: addr=3 len=2 parity=bad gap=18 |
| 270625 | reference | Packet dropped: illegal address 3 (len=2) |
| 270625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 270695 | **DUT** | IN  pkt #779 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270725 | **DUT** | IN  pkt #779 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270725 | yapp monitor | RX pkt #779 on the input: addr=3 len=2 parity=bad gap=6 |
| 270725 | reference | Packet dropped: illegal address 3 (len=2) |
| 270725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270750 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 270795 | **DUT** | IN  pkt #780 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270825 | **DUT** | IN  pkt #780 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270825 | yapp monitor | RX pkt #780 on the input: addr=3 len=2 parity=bad gap=6 |
| 270825 | reference | Packet dropped: illegal address 3 (len=2) |
| 270825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 270890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 271025 | **DUT** | IN  pkt #781 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271055 | **DUT** | IN  pkt #781 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271055 | yapp monitor | RX pkt #781 on the input: addr=3 len=2 parity=bad gap=19 |
| 271055 | reference | Packet dropped: illegal address 3 (len=2) |
| 271055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271075 | **DUT** | IN  pkt #782 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 271105 | **DUT** | IN  pkt #782 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271105 | yapp monitor | RX pkt #782 on the input: addr=3 len=2 parity=bad gap=1 |
| 271105 | reference | Packet dropped: illegal address 3 (len=2) |
| 271105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 271215 | **DUT** | IN  pkt #783 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271245 | **DUT** | IN  pkt #783 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271245 | yapp monitor | RX pkt #783 on the input: addr=3 len=2 parity=bad gap=10 |
| 271245 | reference | Packet dropped: illegal address 3 (len=2) |
| 271245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 271385 | **DUT** | IN  pkt #784 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271415 | **DUT** | IN  pkt #784 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271415 | yapp monitor | RX pkt #784 on the input: addr=3 len=2 parity=bad gap=13 |
| 271415 | reference | Packet dropped: illegal address 3 (len=2) |
| 271415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 271625 | **DUT** | IN  pkt #785 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271655 | **DUT** | IN  pkt #785 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271655 | yapp monitor | RX pkt #785 on the input: addr=3 len=2 parity=bad gap=20 |
| 271655 | reference | Packet dropped: illegal address 3 (len=2) |
| 271655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 271795 | **DUT** | IN  pkt #786 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271825 | **DUT** | IN  pkt #786 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271825 | yapp monitor | RX pkt #786 on the input: addr=3 len=2 parity=bad gap=13 |
| 271825 | reference | Packet dropped: illegal address 3 (len=2) |
| 271825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 271930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 271995 | **DUT** | IN  pkt #787 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272025 | **DUT** | IN  pkt #787 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272025 | yapp monitor | RX pkt #787 on the input: addr=3 len=2 parity=bad gap=16 |
| 272025 | reference | Packet dropped: illegal address 3 (len=2) |
| 272025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 272195 | **DUT** | IN  pkt #788 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272225 | **DUT** | IN  pkt #788 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272225 | yapp monitor | RX pkt #788 on the input: addr=3 len=2 parity=bad gap=16 |
| 272225 | reference | Packet dropped: illegal address 3 (len=2) |
| 272225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 272295 | **DUT** | IN  pkt #789 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272325 | **DUT** | IN  pkt #789 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272325 | yapp monitor | RX pkt #789 on the input: addr=3 len=2 parity=bad gap=6 |
| 272325 | reference | Packet dropped: illegal address 3 (len=2) |
| 272325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 272365 | **DUT** | IN  pkt #790 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272395 | **DUT** | IN  pkt #790 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272395 | yapp monitor | RX pkt #790 on the input: addr=3 len=2 parity=bad gap=3 |
| 272395 | reference | Packet dropped: illegal address 3 (len=2) |
| 272395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 272605 | **DUT** | IN  pkt #791 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272635 | **DUT** | IN  pkt #791 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272635 | yapp monitor | RX pkt #791 on the input: addr=3 len=2 parity=bad gap=20 |
| 272635 | reference | Packet dropped: illegal address 3 (len=2) |
| 272635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 272835 | **DUT** | IN  pkt #792 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272865 | **DUT** | IN  pkt #792 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272865 | yapp monitor | RX pkt #792 on the input: addr=3 len=2 parity=bad gap=19 |
| 272865 | reference | Packet dropped: illegal address 3 (len=2) |
| 272865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 273015 | **DUT** | IN  pkt #793 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273045 | **DUT** | IN  pkt #793 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273045 | yapp monitor | RX pkt #793 on the input: addr=3 len=2 parity=bad gap=14 |
| 273045 | reference | Packet dropped: illegal address 3 (len=2) |
| 273045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 273115 | **DUT** | IN  pkt #794 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273145 | **DUT** | IN  pkt #794 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273145 | yapp monitor | RX pkt #794 on the input: addr=3 len=2 parity=bad gap=6 |
| 273145 | reference | Packet dropped: illegal address 3 (len=2) |
| 273145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 273355 | **DUT** | IN  pkt #795 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273385 | **DUT** | IN  pkt #795 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273385 | yapp monitor | RX pkt #795 on the input: addr=3 len=2 parity=bad gap=20 |
| 273385 | reference | Packet dropped: illegal address 3 (len=2) |
| 273385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 273585 | **DUT** | IN  pkt #796 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273615 | **DUT** | IN  pkt #796 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273615 | yapp monitor | RX pkt #796 on the input: addr=3 len=2 parity=bad gap=19 |
| 273615 | reference | Packet dropped: illegal address 3 (len=2) |
| 273615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 273825 | **DUT** | IN  pkt #797 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273855 | **DUT** | IN  pkt #797 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273855 | yapp monitor | RX pkt #797 on the input: addr=3 len=2 parity=bad gap=20 |
| 273855 | reference | Packet dropped: illegal address 3 (len=2) |
| 273855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 273965 | **DUT** | IN  pkt #798 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273995 | **DUT** | IN  pkt #798 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273995 | yapp monitor | RX pkt #798 on the input: addr=3 len=2 parity=bad gap=10 |
| 273995 | reference | Packet dropped: illegal address 3 (len=2) |
| 273995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274015 | **DUT** | IN  pkt #799 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 274045 | **DUT** | IN  pkt #799 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274045 | yapp monitor | RX pkt #799 on the input: addr=3 len=2 parity=bad gap=1 |
| 274045 | reference | Packet dropped: illegal address 3 (len=2) |
| 274045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 274225 | **DUT** | IN  pkt #800 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274255 | **DUT** | IN  pkt #800 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274255 | yapp monitor | RX pkt #800 on the input: addr=3 len=2 parity=bad gap=17 |
| 274255 | reference | Packet dropped: illegal address 3 (len=2) |
| 274255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 274395 | **DUT** | IN  pkt #801 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274425 | **DUT** | IN  pkt #801 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274425 | yapp monitor | RX pkt #801 on the input: addr=3 len=2 parity=bad gap=13 |
| 274425 | reference | Packet dropped: illegal address 3 (len=2) |
| 274425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 274635 | **DUT** | IN  pkt #802 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274665 | **DUT** | IN  pkt #802 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274665 | yapp monitor | RX pkt #802 on the input: addr=3 len=2 parity=bad gap=20 |
| 274665 | reference | Packet dropped: illegal address 3 (len=2) |
| 274665 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274705 | **DUT** | IN  pkt #803 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274730 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 274735 | **DUT** | IN  pkt #803 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274735 | yapp monitor | RX pkt #803 on the input: addr=3 len=2 parity=bad gap=3 |
| 274735 | reference | Packet dropped: illegal address 3 (len=2) |
| 274735 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 274875 | **DUT** | IN  pkt #804 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274905 | **DUT** | IN  pkt #804 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274905 | yapp monitor | RX pkt #804 on the input: addr=3 len=2 parity=bad gap=13 |
| 274905 | reference | Packet dropped: illegal address 3 (len=2) |
| 274905 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274950 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275115 | **DUT** | IN  pkt #805 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275145 | **DUT** | IN  pkt #805 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275145 | yapp monitor | RX pkt #805 on the input: addr=3 len=2 parity=bad gap=20 |
| 275145 | reference | Packet dropped: illegal address 3 (len=2) |
| 275145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 275355 | **DUT** | IN  pkt #806 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275385 | **DUT** | IN  pkt #806 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275385 | yapp monitor | RX pkt #806 on the input: addr=3 len=2 parity=bad gap=20 |
| 275385 | reference | Packet dropped: illegal address 3 (len=2) |
| 275385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275430 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275575 | **DUT** | IN  pkt #807 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275605 | **DUT** | IN  pkt #807 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275605 | yapp monitor | RX pkt #807 on the input: addr=3 len=2 parity=bad gap=18 |
| 275605 | reference | Packet dropped: illegal address 3 (len=2) |
| 275605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275650 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275705 | **DUT** | IN  pkt #808 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275735 | **DUT** | IN  pkt #808 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275735 | yapp monitor | RX pkt #808 on the input: addr=3 len=2 parity=bad gap=9 |
| 275735 | reference | Packet dropped: illegal address 3 (len=2) |
| 275735 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 275915 | **DUT** | IN  pkt #809 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275945 | **DUT** | IN  pkt #809 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275945 | yapp monitor | RX pkt #809 on the input: addr=3 len=2 parity=bad gap=17 |
| 275945 | reference | Packet dropped: illegal address 3 (len=2) |
| 275945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 276155 | **DUT** | IN  pkt #810 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276185 | **DUT** | IN  pkt #810 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276185 | yapp monitor | RX pkt #810 on the input: addr=3 len=2 parity=bad gap=20 |
| 276185 | reference | Packet dropped: illegal address 3 (len=2) |
| 276185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 276315 | **DUT** | IN  pkt #811 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276345 | **DUT** | IN  pkt #811 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276345 | yapp monitor | RX pkt #811 on the input: addr=3 len=2 parity=bad gap=12 |
| 276345 | reference | Packet dropped: illegal address 3 (len=2) |
| 276345 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 276525 | **DUT** | IN  pkt #812 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276555 | **DUT** | IN  pkt #812 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276555 | yapp monitor | RX pkt #812 on the input: addr=3 len=2 parity=bad gap=17 |
| 276555 | reference | Packet dropped: illegal address 3 (len=2) |
| 276555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 276765 | **DUT** | IN  pkt #813 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276795 | **DUT** | IN  pkt #813 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276795 | yapp monitor | RX pkt #813 on the input: addr=3 len=2 parity=bad gap=20 |
| 276795 | reference | Packet dropped: illegal address 3 (len=2) |
| 276795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 276985 | **DUT** | IN  pkt #814 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277015 | **DUT** | IN  pkt #814 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277015 | yapp monitor | RX pkt #814 on the input: addr=3 len=2 parity=bad gap=18 |
| 277015 | reference | Packet dropped: illegal address 3 (len=2) |
| 277015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 277195 | **DUT** | IN  pkt #815 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277225 | **DUT** | IN  pkt #815 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277225 | yapp monitor | RX pkt #815 on the input: addr=3 len=2 parity=bad gap=17 |
| 277225 | reference | Packet dropped: illegal address 3 (len=2) |
| 277225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277290 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 277435 | **DUT** | IN  pkt #816 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277465 | **DUT** | IN  pkt #816 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277465 | yapp monitor | RX pkt #816 on the input: addr=3 len=2 parity=bad gap=20 |
| 277465 | reference | Packet dropped: illegal address 3 (len=2) |
| 277465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277510 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 277535 | **DUT** | IN  pkt #817 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277565 | **DUT** | IN  pkt #817 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277565 | yapp monitor | RX pkt #817 on the input: addr=3 len=2 parity=bad gap=6 |
| 277565 | reference | Packet dropped: illegal address 3 (len=2) |
| 277565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277615 | **DUT** | IN  pkt #818 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277645 | **DUT** | IN  pkt #818 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277645 | yapp monitor | RX pkt #818 on the input: addr=3 len=2 parity=bad gap=4 |
| 277645 | reference | Packet dropped: illegal address 3 (len=2) |
| 277645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 277710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 277755 | **DUT** | IN  pkt #819 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277785 | **DUT** | IN  pkt #819 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277785 | yapp monitor | RX pkt #819 on the input: addr=3 len=2 parity=bad gap=10 |
| 277785 | reference | Packet dropped: illegal address 3 (len=2) |
| 277785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 277835 | **DUT** | IN  pkt #820 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277865 | **DUT** | IN  pkt #820 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277865 | yapp monitor | RX pkt #820 on the input: addr=3 len=2 parity=bad gap=4 |
| 277865 | reference | Packet dropped: illegal address 3 (len=2) |
| 277865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 278065 | **DUT** | IN  pkt #821 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278095 | **DUT** | IN  pkt #821 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278095 | yapp monitor | RX pkt #821 on the input: addr=3 len=2 parity=bad gap=19 |
| 278095 | reference | Packet dropped: illegal address 3 (len=2) |
| 278095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 278145 | **DUT** | IN  pkt #822 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278175 | **DUT** | IN  pkt #822 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278175 | yapp monitor | RX pkt #822 on the input: addr=3 len=2 parity=bad gap=4 |
| 278175 | reference | Packet dropped: illegal address 3 (len=2) |
| 278175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 278265 | **DUT** | IN  pkt #823 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278295 | **DUT** | IN  pkt #823 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278295 | yapp monitor | RX pkt #823 on the input: addr=3 len=2 parity=bad gap=8 |
| 278295 | reference | Packet dropped: illegal address 3 (len=2) |
| 278295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 278505 | **DUT** | IN  pkt #824 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278535 | **DUT** | IN  pkt #824 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278535 | yapp monitor | RX pkt #824 on the input: addr=3 len=2 parity=bad gap=20 |
| 278535 | reference | Packet dropped: illegal address 3 (len=2) |
| 278535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 278675 | **DUT** | IN  pkt #825 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278705 | **DUT** | IN  pkt #825 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278705 | yapp monitor | RX pkt #825 on the input: addr=3 len=2 parity=bad gap=13 |
| 278705 | reference | Packet dropped: illegal address 3 (len=2) |
| 278705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 278915 | **DUT** | IN  pkt #826 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278945 | **DUT** | IN  pkt #826 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278945 | yapp monitor | RX pkt #826 on the input: addr=3 len=2 parity=bad gap=20 |
| 278945 | reference | Packet dropped: illegal address 3 (len=2) |
| 278945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279085 | **DUT** | IN  pkt #827 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279115 | **DUT** | IN  pkt #827 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279115 | yapp monitor | RX pkt #827 on the input: addr=3 len=2 parity=bad gap=13 |
| 279115 | reference | Packet dropped: illegal address 3 (len=2) |
| 279115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 279325 | **DUT** | IN  pkt #828 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279355 | **DUT** | IN  pkt #828 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279355 | yapp monitor | RX pkt #828 on the input: addr=3 len=2 parity=bad gap=20 |
| 279355 | reference | Packet dropped: illegal address 3 (len=2) |
| 279355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 279385 | **DUT** | IN  pkt #829 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279415 | **DUT** | IN  pkt #829 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279415 | yapp monitor | RX pkt #829 on the input: addr=3 len=2 parity=bad gap=2 |
| 279415 | reference | Packet dropped: illegal address 3 (len=2) |
| 279415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 279555 | **DUT** | IN  pkt #830 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279585 | **DUT** | IN  pkt #830 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279585 | yapp monitor | RX pkt #830 on the input: addr=3 len=2 parity=bad gap=13 |
| 279585 | reference | Packet dropped: illegal address 3 (len=2) |
| 279585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279605 | **DUT** | IN  pkt #831 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279635 | **DUT** | IN  pkt #831 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279635 | yapp monitor | RX pkt #831 on the input: addr=3 len=2 parity=bad gap=1 |
| 279635 | reference | Packet dropped: illegal address 3 (len=2) |
| 279635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 279715 | **DUT** | IN  pkt #832 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279745 | **DUT** | IN  pkt #832 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279745 | yapp monitor | RX pkt #832 on the input: addr=3 len=2 parity=bad gap=7 |
| 279745 | reference | Packet dropped: illegal address 3 (len=2) |
| 279745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279765 | **DUT** | IN  pkt #833 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279795 | **DUT** | IN  pkt #833 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279795 | yapp monitor | RX pkt #833 on the input: addr=3 len=2 parity=bad gap=1 |
| 279795 | reference | Packet dropped: illegal address 3 (len=2) |
| 279795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 279965 | **DUT** | IN  pkt #834 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279995 | **DUT** | IN  pkt #834 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279995 | yapp monitor | RX pkt #834 on the input: addr=3 len=2 parity=bad gap=16 |
| 279995 | reference | Packet dropped: illegal address 3 (len=2) |
| 279995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 280015 | **DUT** | IN  pkt #835 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280045 | **DUT** | IN  pkt #835 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280045 | yapp monitor | RX pkt #835 on the input: addr=3 len=2 parity=bad gap=1 |
| 280045 | reference | Packet dropped: illegal address 3 (len=2) |
| 280045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 280215 | **DUT** | IN  pkt #836 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280245 | **DUT** | IN  pkt #836 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280245 | yapp monitor | RX pkt #836 on the input: addr=3 len=2 parity=bad gap=16 |
| 280245 | reference | Packet dropped: illegal address 3 (len=2) |
| 280245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280285 | **DUT** | IN  pkt #837 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 280315 | **DUT** | IN  pkt #837 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280315 | yapp monitor | RX pkt #837 on the input: addr=3 len=2 parity=bad gap=3 |
| 280315 | reference | Packet dropped: illegal address 3 (len=2) |
| 280315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 280355 | **DUT** | IN  pkt #838 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280385 | **DUT** | IN  pkt #838 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280385 | yapp monitor | RX pkt #838 on the input: addr=3 len=2 parity=bad gap=3 |
| 280385 | reference | Packet dropped: illegal address 3 (len=2) |
| 280385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 280575 | **DUT** | IN  pkt #839 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280605 | **DUT** | IN  pkt #839 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280605 | yapp monitor | RX pkt #839 on the input: addr=3 len=2 parity=bad gap=18 |
| 280605 | reference | Packet dropped: illegal address 3 (len=2) |
| 280605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 280695 | **DUT** | IN  pkt #840 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280725 | **DUT** | IN  pkt #840 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280725 | yapp monitor | RX pkt #840 on the input: addr=3 len=2 parity=bad gap=8 |
| 280725 | reference | Packet dropped: illegal address 3 (len=2) |
| 280725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280765 | **DUT** | IN  pkt #841 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 280795 | **DUT** | IN  pkt #841 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280795 | yapp monitor | RX pkt #841 on the input: addr=3 len=2 parity=bad gap=3 |
| 280795 | reference | Packet dropped: illegal address 3 (len=2) |
| 280795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281005 | **DUT** | IN  pkt #842 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281035 | **DUT** | IN  pkt #842 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281035 | yapp monitor | RX pkt #842 on the input: addr=3 len=2 parity=bad gap=20 |
| 281035 | reference | Packet dropped: illegal address 3 (len=2) |
| 281035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 281245 | **DUT** | IN  pkt #843 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281275 | **DUT** | IN  pkt #843 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281275 | yapp monitor | RX pkt #843 on the input: addr=3 len=2 parity=bad gap=20 |
| 281275 | reference | Packet dropped: illegal address 3 (len=2) |
| 281275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281335 | **DUT** | IN  pkt #844 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281365 | **DUT** | IN  pkt #844 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281365 | yapp monitor | RX pkt #844 on the input: addr=3 len=2 parity=bad gap=5 |
| 281365 | reference | Packet dropped: illegal address 3 (len=2) |
| 281365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 281545 | **DUT** | IN  pkt #845 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281575 | **DUT** | IN  pkt #845 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281575 | yapp monitor | RX pkt #845 on the input: addr=3 len=2 parity=bad gap=17 |
| 281575 | reference | Packet dropped: illegal address 3 (len=2) |
| 281575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 281775 | **DUT** | IN  pkt #846 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281805 | **DUT** | IN  pkt #846 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281805 | yapp monitor | RX pkt #846 on the input: addr=3 len=2 parity=bad gap=19 |
| 281805 | reference | Packet dropped: illegal address 3 (len=2) |
| 281805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 282015 | **DUT** | IN  pkt #847 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282045 | **DUT** | IN  pkt #847 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282045 | yapp monitor | RX pkt #847 on the input: addr=3 len=2 parity=bad gap=20 |
| 282045 | reference | Packet dropped: illegal address 3 (len=2) |
| 282045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 282205 | **DUT** | IN  pkt #848 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282235 | **DUT** | IN  pkt #848 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282235 | yapp monitor | RX pkt #848 on the input: addr=3 len=2 parity=bad gap=15 |
| 282235 | reference | Packet dropped: illegal address 3 (len=2) |
| 282235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 282435 | **DUT** | IN  pkt #849 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282465 | **DUT** | IN  pkt #849 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282465 | yapp monitor | RX pkt #849 on the input: addr=3 len=2 parity=bad gap=19 |
| 282465 | reference | Packet dropped: illegal address 3 (len=2) |
| 282465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 282615 | **DUT** | IN  pkt #850 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282645 | **DUT** | IN  pkt #850 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282645 | yapp monitor | RX pkt #850 on the input: addr=3 len=2 parity=bad gap=14 |
| 282645 | reference | Packet dropped: illegal address 3 (len=2) |
| 282645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 282815 | **DUT** | IN  pkt #851 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282845 | **DUT** | IN  pkt #851 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282845 | yapp monitor | RX pkt #851 on the input: addr=3 len=2 parity=bad gap=16 |
| 282845 | reference | Packet dropped: illegal address 3 (len=2) |
| 282845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282865 | **DUT** | IN  pkt #852 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282895 | **DUT** | IN  pkt #852 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282895 | yapp monitor | RX pkt #852 on the input: addr=3 len=2 parity=bad gap=1 |
| 282895 | reference | Packet dropped: illegal address 3 (len=2) |
| 282895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 282940 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 283035 | **DUT** | IN  pkt #853 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283065 | **DUT** | IN  pkt #853 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283065 | yapp monitor | RX pkt #853 on the input: addr=3 len=2 parity=bad gap=13 |
| 283065 | reference | Packet dropped: illegal address 3 (len=2) |
| 283065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 283185 | **DUT** | IN  pkt #854 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283215 | **DUT** | IN  pkt #854 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283215 | yapp monitor | RX pkt #854 on the input: addr=3 len=2 parity=bad gap=11 |
| 283215 | reference | Packet dropped: illegal address 3 (len=2) |
| 283215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 283425 | **DUT** | IN  pkt #855 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283455 | **DUT** | IN  pkt #855 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283455 | yapp monitor | RX pkt #855 on the input: addr=3 len=2 parity=bad gap=20 |
| 283455 | reference | Packet dropped: illegal address 3 (len=2) |
| 283455 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283510 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 283615 | **DUT** | IN  pkt #856 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283645 | **DUT** | IN  pkt #856 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283645 | yapp monitor | RX pkt #856 on the input: addr=3 len=2 parity=bad gap=15 |
| 283645 | reference | Packet dropped: illegal address 3 (len=2) |
| 283645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 283855 | **DUT** | IN  pkt #857 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283885 | **DUT** | IN  pkt #857 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283885 | yapp monitor | RX pkt #857 on the input: addr=3 len=2 parity=bad gap=20 |
| 283885 | reference | Packet dropped: illegal address 3 (len=2) |
| 283885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 283975 | **DUT** | IN  pkt #858 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284005 | **DUT** | IN  pkt #858 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284005 | yapp monitor | RX pkt #858 on the input: addr=3 len=2 parity=bad gap=8 |
| 284005 | reference | Packet dropped: illegal address 3 (len=2) |
| 284005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 284215 | **DUT** | IN  pkt #859 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284245 | **DUT** | IN  pkt #859 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284245 | yapp monitor | RX pkt #859 on the input: addr=3 len=2 parity=bad gap=20 |
| 284245 | reference | Packet dropped: illegal address 3 (len=2) |
| 284245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 284345 | **DUT** | IN  pkt #860 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284375 | **DUT** | IN  pkt #860 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284375 | yapp monitor | RX pkt #860 on the input: addr=3 len=2 parity=bad gap=9 |
| 284375 | reference | Packet dropped: illegal address 3 (len=2) |
| 284375 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 284545 | **DUT** | IN  pkt #861 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284575 | **DUT** | IN  pkt #861 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284575 | yapp monitor | RX pkt #861 on the input: addr=3 len=2 parity=bad gap=16 |
| 284575 | reference | Packet dropped: illegal address 3 (len=2) |
| 284575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 284655 | **DUT** | IN  pkt #862 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284685 | **DUT** | IN  pkt #862 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284685 | yapp monitor | RX pkt #862 on the input: addr=3 len=2 parity=bad gap=7 |
| 284685 | reference | Packet dropped: illegal address 3 (len=2) |
| 284685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 284895 | **DUT** | IN  pkt #863 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284925 | **DUT** | IN  pkt #863 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284925 | yapp monitor | RX pkt #863 on the input: addr=3 len=2 parity=bad gap=20 |
| 284925 | reference | Packet dropped: illegal address 3 (len=2) |
| 284925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285005 | **DUT** | IN  pkt #864 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 285035 | **DUT** | IN  pkt #864 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285035 | yapp monitor | RX pkt #864 on the input: addr=3 len=2 parity=bad gap=7 |
| 285035 | reference | Packet dropped: illegal address 3 (len=2) |
| 285035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285070 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 285215 | **DUT** | IN  pkt #865 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285245 | **DUT** | IN  pkt #865 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285245 | yapp monitor | RX pkt #865 on the input: addr=3 len=2 parity=bad gap=17 |
| 285245 | reference | Packet dropped: illegal address 3 (len=2) |
| 285245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285325 | **DUT** | IN  pkt #866 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 285355 | **DUT** | IN  pkt #866 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285355 | yapp monitor | RX pkt #866 on the input: addr=3 len=2 parity=bad gap=7 |
| 285355 | reference | Packet dropped: illegal address 3 (len=2) |
| 285355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 285395 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 285425 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 285455 | hbus monitor | Collected READ  addr=0x1006 data=0x64 |
| 285485 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 285515 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 285545 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 285755 | **DUT** | IN  pkt #867 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285785 | **DUT** | IN  pkt #867 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285785 | yapp monitor | RX pkt #867 on the input: addr=3 len=2 parity=bad gap=39 |
| 285785 | reference | Packet dropped: illegal address 3 (len=2) |
| 285785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285830 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 285945 | **DUT** | IN  pkt #868 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285975 | **DUT** | IN  pkt #868 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285975 | yapp monitor | RX pkt #868 on the input: addr=3 len=2 parity=bad gap=15 |
| 285975 | reference | Packet dropped: illegal address 3 (len=2) |
| 285975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 285995 | **DUT** | IN  pkt #869 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286025 | **DUT** | IN  pkt #869 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286025 | yapp monitor | RX pkt #869 on the input: addr=3 len=2 parity=bad gap=1 |
| 286025 | reference | Packet dropped: illegal address 3 (len=2) |
| 286025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 286215 | **DUT** | IN  pkt #870 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286245 | **DUT** | IN  pkt #870 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286245 | yapp monitor | RX pkt #870 on the input: addr=3 len=2 parity=bad gap=18 |
| 286245 | reference | Packet dropped: illegal address 3 (len=2) |
| 286245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 286315 | **DUT** | IN  pkt #871 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286345 | **DUT** | IN  pkt #871 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286345 | yapp monitor | RX pkt #871 on the input: addr=3 len=2 parity=bad gap=6 |
| 286345 | reference | Packet dropped: illegal address 3 (len=2) |
| 286345 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286410 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 286555 | **DUT** | IN  pkt #872 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286585 | **DUT** | IN  pkt #872 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286585 | yapp monitor | RX pkt #872 on the input: addr=3 len=2 parity=bad gap=20 |
| 286585 | reference | Packet dropped: illegal address 3 (len=2) |
| 286585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286625 | **DUT** | IN  pkt #873 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 286655 | **DUT** | IN  pkt #873 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286655 | yapp monitor | RX pkt #873 on the input: addr=3 len=2 parity=bad gap=3 |
| 286655 | reference | Packet dropped: illegal address 3 (len=2) |
| 286655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 286865 | **DUT** | IN  pkt #874 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286895 | **DUT** | IN  pkt #874 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286895 | yapp monitor | RX pkt #874 on the input: addr=3 len=2 parity=bad gap=20 |
| 286895 | reference | Packet dropped: illegal address 3 (len=2) |
| 286895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286915 | **DUT** | IN  pkt #875 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 286945 | **DUT** | IN  pkt #875 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286945 | yapp monitor | RX pkt #875 on the input: addr=3 len=2 parity=bad gap=1 |
| 286945 | reference | Packet dropped: illegal address 3 (len=2) |
| 286945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 287015 | **DUT** | IN  pkt #876 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287045 | **DUT** | IN  pkt #876 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287045 | yapp monitor | RX pkt #876 on the input: addr=3 len=2 parity=bad gap=6 |
| 287045 | reference | Packet dropped: illegal address 3 (len=2) |
| 287045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287070 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 287195 | **DUT** | IN  pkt #877 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287225 | **DUT** | IN  pkt #877 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287225 | yapp monitor | RX pkt #877 on the input: addr=3 len=2 parity=bad gap=14 |
| 287225 | reference | Packet dropped: illegal address 3 (len=2) |
| 287225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 287405 | **DUT** | IN  pkt #878 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287435 | **DUT** | IN  pkt #878 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287435 | yapp monitor | RX pkt #878 on the input: addr=3 len=2 parity=bad gap=17 |
| 287435 | reference | Packet dropped: illegal address 3 (len=2) |
| 287435 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287455 | **DUT** | IN  pkt #879 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 287485 | **DUT** | IN  pkt #879 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287485 | yapp monitor | RX pkt #879 on the input: addr=3 len=2 parity=bad gap=1 |
| 287485 | reference | Packet dropped: illegal address 3 (len=2) |
| 287485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 287695 | **DUT** | IN  pkt #880 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287725 | **DUT** | IN  pkt #880 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287725 | yapp monitor | RX pkt #880 on the input: addr=3 len=2 parity=bad gap=20 |
| 287725 | reference | Packet dropped: illegal address 3 (len=2) |
| 287725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 287925 | **DUT** | IN  pkt #881 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287955 | **DUT** | IN  pkt #881 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287955 | yapp monitor | RX pkt #881 on the input: addr=3 len=2 parity=bad gap=19 |
| 287955 | reference | Packet dropped: illegal address 3 (len=2) |
| 287955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287975 | **DUT** | IN  pkt #882 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288005 | **DUT** | IN  pkt #882 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288005 | yapp monitor | RX pkt #882 on the input: addr=3 len=2 parity=bad gap=1 |
| 288005 | reference | Packet dropped: illegal address 3 (len=2) |
| 288005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 288040 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 288075 | **DUT** | IN  pkt #883 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288105 | **DUT** | IN  pkt #883 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288105 | yapp monitor | RX pkt #883 on the input: addr=3 len=2 parity=bad gap=6 |
| 288105 | reference | Packet dropped: illegal address 3 (len=2) |
| 288105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 288305 | **DUT** | IN  pkt #884 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288335 | **DUT** | IN  pkt #884 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288335 | yapp monitor | RX pkt #884 on the input: addr=3 len=2 parity=bad gap=19 |
| 288335 | reference | Packet dropped: illegal address 3 (len=2) |
| 288335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 288545 | **DUT** | IN  pkt #885 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288575 | **DUT** | IN  pkt #885 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288575 | yapp monitor | RX pkt #885 on the input: addr=3 len=2 parity=bad gap=20 |
| 288575 | reference | Packet dropped: illegal address 3 (len=2) |
| 288575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 288775 | **DUT** | IN  pkt #886 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288805 | **DUT** | IN  pkt #886 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288805 | yapp monitor | RX pkt #886 on the input: addr=3 len=2 parity=bad gap=19 |
| 288805 | reference | Packet dropped: illegal address 3 (len=2) |
| 288805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288830 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 288895 | **DUT** | IN  pkt #887 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288925 | **DUT** | IN  pkt #887 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288925 | yapp monitor | RX pkt #887 on the input: addr=3 len=2 parity=bad gap=8 |
| 288925 | reference | Packet dropped: illegal address 3 (len=2) |
| 288925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 289115 | **DUT** | IN  pkt #888 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289145 | **DUT** | IN  pkt #888 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289145 | yapp monitor | RX pkt #888 on the input: addr=3 len=2 parity=bad gap=18 |
| 289145 | reference | Packet dropped: illegal address 3 (len=2) |
| 289145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 289325 | **DUT** | IN  pkt #889 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289355 | **DUT** | IN  pkt #889 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289355 | yapp monitor | RX pkt #889 on the input: addr=3 len=2 parity=bad gap=17 |
| 289355 | reference | Packet dropped: illegal address 3 (len=2) |
| 289355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 289565 | **DUT** | IN  pkt #890 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289595 | **DUT** | IN  pkt #890 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289595 | yapp monitor | RX pkt #890 on the input: addr=3 len=2 parity=bad gap=20 |
| 289595 | reference | Packet dropped: illegal address 3 (len=2) |
| 289595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 289775 | **DUT** | IN  pkt #891 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289805 | **DUT** | IN  pkt #891 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289805 | yapp monitor | RX pkt #891 on the input: addr=3 len=2 parity=bad gap=17 |
| 289805 | reference | Packet dropped: illegal address 3 (len=2) |
| 289805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 290005 | **DUT** | IN  pkt #892 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290035 | **DUT** | IN  pkt #892 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290035 | yapp monitor | RX pkt #892 on the input: addr=3 len=2 parity=bad gap=19 |
| 290035 | reference | Packet dropped: illegal address 3 (len=2) |
| 290035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 290245 | **DUT** | IN  pkt #893 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290275 | **DUT** | IN  pkt #893 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290275 | yapp monitor | RX pkt #893 on the input: addr=3 len=2 parity=bad gap=20 |
| 290275 | reference | Packet dropped: illegal address 3 (len=2) |
| 290275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 290405 | **DUT** | IN  pkt #894 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290435 | **DUT** | IN  pkt #894 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290435 | yapp monitor | RX pkt #894 on the input: addr=3 len=2 parity=bad gap=12 |
| 290435 | reference | Packet dropped: illegal address 3 (len=2) |
| 290435 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290490 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 290645 | **DUT** | IN  pkt #895 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290675 | **DUT** | IN  pkt #895 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290675 | yapp monitor | RX pkt #895 on the input: addr=3 len=2 parity=bad gap=20 |
| 290675 | reference | Packet dropped: illegal address 3 (len=2) |
| 290675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 290845 | **DUT** | IN  pkt #896 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290875 | **DUT** | IN  pkt #896 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290875 | yapp monitor | RX pkt #896 on the input: addr=3 len=2 parity=bad gap=16 |
| 290875 | reference | Packet dropped: illegal address 3 (len=2) |
| 290875 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 291085 | **DUT** | IN  pkt #897 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291115 | **DUT** | IN  pkt #897 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291115 | yapp monitor | RX pkt #897 on the input: addr=3 len=2 parity=bad gap=20 |
| 291115 | reference | Packet dropped: illegal address 3 (len=2) |
| 291115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 291205 | **DUT** | IN  pkt #898 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291235 | **DUT** | IN  pkt #898 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291235 | yapp monitor | RX pkt #898 on the input: addr=3 len=2 parity=bad gap=8 |
| 291235 | reference | Packet dropped: illegal address 3 (len=2) |
| 291235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 291435 | **DUT** | IN  pkt #899 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291465 | **DUT** | IN  pkt #899 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291465 | yapp monitor | RX pkt #899 on the input: addr=3 len=2 parity=bad gap=19 |
| 291465 | reference | Packet dropped: illegal address 3 (len=2) |
| 291465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 291655 | **DUT** | IN  pkt #900 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291685 | **DUT** | IN  pkt #900 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291685 | yapp monitor | RX pkt #900 on the input: addr=3 len=2 parity=bad gap=18 |
| 291685 | reference | Packet dropped: illegal address 3 (len=2) |
| 291685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 291765 | **DUT** | IN  pkt #901 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291795 | **DUT** | IN  pkt #901 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291795 | yapp monitor | RX pkt #901 on the input: addr=3 len=2 parity=bad gap=7 |
| 291795 | reference | Packet dropped: illegal address 3 (len=2) |
| 291795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 291885 | **DUT** | IN  pkt #902 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291915 | **DUT** | IN  pkt #902 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291915 | yapp monitor | RX pkt #902 on the input: addr=3 len=2 parity=bad gap=8 |
| 291915 | reference | Packet dropped: illegal address 3 (len=2) |
| 291915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 292055 | **DUT** | IN  pkt #903 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292085 | **DUT** | IN  pkt #903 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292085 | yapp monitor | RX pkt #903 on the input: addr=3 len=2 parity=bad gap=13 |
| 292085 | reference | Packet dropped: illegal address 3 (len=2) |
| 292085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 292285 | **DUT** | IN  pkt #904 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292315 | **DUT** | IN  pkt #904 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292315 | yapp monitor | RX pkt #904 on the input: addr=3 len=2 parity=bad gap=19 |
| 292315 | reference | Packet dropped: illegal address 3 (len=2) |
| 292315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 292435 | **DUT** | IN  pkt #905 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292465 | **DUT** | IN  pkt #905 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292465 | yapp monitor | RX pkt #905 on the input: addr=3 len=2 parity=bad gap=11 |
| 292465 | reference | Packet dropped: illegal address 3 (len=2) |
| 292465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 292615 | **DUT** | IN  pkt #906 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292645 | **DUT** | IN  pkt #906 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292645 | yapp monitor | RX pkt #906 on the input: addr=3 len=2 parity=bad gap=14 |
| 292645 | reference | Packet dropped: illegal address 3 (len=2) |
| 292645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 292735 | **DUT** | IN  pkt #907 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292765 | **DUT** | IN  pkt #907 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292765 | yapp monitor | RX pkt #907 on the input: addr=3 len=2 parity=bad gap=8 |
| 292765 | reference | Packet dropped: illegal address 3 (len=2) |
| 292765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292850 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 292975 | **DUT** | IN  pkt #908 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293005 | **DUT** | IN  pkt #908 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293005 | yapp monitor | RX pkt #908 on the input: addr=3 len=2 parity=bad gap=20 |
| 293005 | reference | Packet dropped: illegal address 3 (len=2) |
| 293005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 293215 | **DUT** | IN  pkt #909 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293245 | **DUT** | IN  pkt #909 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293245 | yapp monitor | RX pkt #909 on the input: addr=3 len=2 parity=bad gap=20 |
| 293245 | reference | Packet dropped: illegal address 3 (len=2) |
| 293245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 293455 | **DUT** | IN  pkt #910 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293485 | **DUT** | IN  pkt #910 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293485 | yapp monitor | RX pkt #910 on the input: addr=3 len=2 parity=bad gap=20 |
| 293485 | reference | Packet dropped: illegal address 3 (len=2) |
| 293485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 293695 | **DUT** | IN  pkt #911 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293725 | **DUT** | IN  pkt #911 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293725 | yapp monitor | RX pkt #911 on the input: addr=3 len=2 parity=bad gap=20 |
| 293725 | reference | Packet dropped: illegal address 3 (len=2) |
| 293725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 293935 | **DUT** | IN  pkt #912 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293965 | **DUT** | IN  pkt #912 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293965 | yapp monitor | RX pkt #912 on the input: addr=3 len=2 parity=bad gap=20 |
| 293965 | reference | Packet dropped: illegal address 3 (len=2) |
| 293965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 294175 | **DUT** | IN  pkt #913 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294205 | **DUT** | IN  pkt #913 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294205 | yapp monitor | RX pkt #913 on the input: addr=3 len=2 parity=bad gap=20 |
| 294205 | reference | Packet dropped: illegal address 3 (len=2) |
| 294205 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 294365 | **DUT** | IN  pkt #914 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294395 | **DUT** | IN  pkt #914 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294395 | yapp monitor | RX pkt #914 on the input: addr=3 len=2 parity=bad gap=15 |
| 294395 | reference | Packet dropped: illegal address 3 (len=2) |
| 294395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294410 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 294595 | **DUT** | IN  pkt #915 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294625 | **DUT** | IN  pkt #915 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294625 | yapp monitor | RX pkt #915 on the input: addr=3 len=2 parity=bad gap=19 |
| 294625 | reference | Packet dropped: illegal address 3 (len=2) |
| 294625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 294655 | **DUT** | IN  pkt #916 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294685 | **DUT** | IN  pkt #916 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294685 | yapp monitor | RX pkt #916 on the input: addr=3 len=2 parity=bad gap=2 |
| 294685 | reference | Packet dropped: illegal address 3 (len=2) |
| 294685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294770 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 294835 | **DUT** | IN  pkt #917 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294865 | **DUT** | IN  pkt #917 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294865 | yapp monitor | RX pkt #917 on the input: addr=3 len=2 parity=bad gap=14 |
| 294865 | reference | Packet dropped: illegal address 3 (len=2) |
| 294865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294905 | **DUT** | IN  pkt #918 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294935 | **DUT** | IN  pkt #918 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294935 | yapp monitor | RX pkt #918 on the input: addr=3 len=2 parity=bad gap=3 |
| 294935 | reference | Packet dropped: illegal address 3 (len=2) |
| 294935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294950 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 294970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 295145 | **DUT** | IN  pkt #919 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295175 | **DUT** | IN  pkt #919 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295175 | yapp monitor | RX pkt #919 on the input: addr=3 len=2 parity=bad gap=20 |
| 295175 | reference | Packet dropped: illegal address 3 (len=2) |
| 295175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 295305 | **DUT** | IN  pkt #920 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295335 | **DUT** | IN  pkt #920 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295335 | yapp monitor | RX pkt #920 on the input: addr=3 len=2 parity=bad gap=12 |
| 295335 | reference | Packet dropped: illegal address 3 (len=2) |
| 295335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295405 | **DUT** | IN  pkt #921 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 295435 | **DUT** | IN  pkt #921 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295435 | yapp monitor | RX pkt #921 on the input: addr=3 len=2 parity=bad gap=6 |
| 295435 | reference | Packet dropped: illegal address 3 (len=2) |
| 295435 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 295625 | **DUT** | IN  pkt #922 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295655 | **DUT** | IN  pkt #922 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295655 | yapp monitor | RX pkt #922 on the input: addr=3 len=2 parity=bad gap=18 |
| 295655 | reference | Packet dropped: illegal address 3 (len=2) |
| 295655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295735 | **DUT** | IN  pkt #923 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 295765 | **DUT** | IN  pkt #923 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295765 | yapp monitor | RX pkt #923 on the input: addr=3 len=2 parity=bad gap=7 |
| 295765 | reference | Packet dropped: illegal address 3 (len=2) |
| 295765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 295885 | **DUT** | IN  pkt #924 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295915 | **DUT** | IN  pkt #924 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295915 | yapp monitor | RX pkt #924 on the input: addr=3 len=2 parity=bad gap=11 |
| 295915 | reference | Packet dropped: illegal address 3 (len=2) |
| 295915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 296035 | **DUT** | IN  pkt #925 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296065 | **DUT** | IN  pkt #925 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296065 | yapp monitor | RX pkt #925 on the input: addr=3 len=2 parity=bad gap=11 |
| 296065 | reference | Packet dropped: illegal address 3 (len=2) |
| 296065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 296235 | **DUT** | IN  pkt #926 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296265 | **DUT** | IN  pkt #926 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296265 | yapp monitor | RX pkt #926 on the input: addr=3 len=2 parity=bad gap=16 |
| 296265 | reference | Packet dropped: illegal address 3 (len=2) |
| 296265 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296285 | **DUT** | IN  pkt #927 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296315 | **DUT** | IN  pkt #927 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296315 | yapp monitor | RX pkt #927 on the input: addr=3 len=2 parity=bad gap=1 |
| 296315 | reference | Packet dropped: illegal address 3 (len=2) |
| 296315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 296340 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 296435 | **DUT** | IN  pkt #928 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296465 | **DUT** | IN  pkt #928 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296465 | yapp monitor | RX pkt #928 on the input: addr=3 len=2 parity=bad gap=11 |
| 296465 | reference | Packet dropped: illegal address 3 (len=2) |
| 296465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 296635 | **DUT** | IN  pkt #929 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296665 | **DUT** | IN  pkt #929 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296665 | yapp monitor | RX pkt #929 on the input: addr=3 len=2 parity=bad gap=16 |
| 296665 | reference | Packet dropped: illegal address 3 (len=2) |
| 296665 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 296795 | **DUT** | IN  pkt #930 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296825 | **DUT** | IN  pkt #930 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296825 | yapp monitor | RX pkt #930 on the input: addr=3 len=2 parity=bad gap=12 |
| 296825 | reference | Packet dropped: illegal address 3 (len=2) |
| 296825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 296885 | **DUT** | IN  pkt #931 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296915 | **DUT** | IN  pkt #931 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296915 | yapp monitor | RX pkt #931 on the input: addr=3 len=2 parity=bad gap=5 |
| 296915 | reference | Packet dropped: illegal address 3 (len=2) |
| 296915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296935 | **DUT** | IN  pkt #932 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296965 | **DUT** | IN  pkt #932 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296965 | yapp monitor | RX pkt #932 on the input: addr=3 len=2 parity=bad gap=1 |
| 296965 | reference | Packet dropped: illegal address 3 (len=2) |
| 296965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 297000 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 297065 | **DUT** | IN  pkt #933 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297095 | **DUT** | IN  pkt #933 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297095 | yapp monitor | RX pkt #933 on the input: addr=3 len=2 parity=bad gap=9 |
| 297095 | reference | Packet dropped: illegal address 3 (len=2) |
| 297095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 297275 | **DUT** | IN  pkt #934 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297305 | **DUT** | IN  pkt #934 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297305 | yapp monitor | RX pkt #934 on the input: addr=3 len=2 parity=bad gap=17 |
| 297305 | reference | Packet dropped: illegal address 3 (len=2) |
| 297305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297335 | **DUT** | IN  pkt #935 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 297365 | **DUT** | IN  pkt #935 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297365 | yapp monitor | RX pkt #935 on the input: addr=3 len=2 parity=bad gap=2 |
| 297365 | reference | Packet dropped: illegal address 3 (len=2) |
| 297365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 297575 | **DUT** | IN  pkt #936 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297605 | **DUT** | IN  pkt #936 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297605 | yapp monitor | RX pkt #936 on the input: addr=3 len=2 parity=bad gap=20 |
| 297605 | reference | Packet dropped: illegal address 3 (len=2) |
| 297605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 297815 | **DUT** | IN  pkt #937 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297845 | **DUT** | IN  pkt #937 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297845 | yapp monitor | RX pkt #937 on the input: addr=3 len=2 parity=bad gap=20 |
| 297845 | reference | Packet dropped: illegal address 3 (len=2) |
| 297845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297890 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 297985 | **DUT** | IN  pkt #938 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298015 | **DUT** | IN  pkt #938 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298015 | yapp monitor | RX pkt #938 on the input: addr=3 len=2 parity=bad gap=13 |
| 298015 | reference | Packet dropped: illegal address 3 (len=2) |
| 298015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 298075 | **DUT** | IN  pkt #939 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298105 | **DUT** | IN  pkt #939 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298105 | yapp monitor | RX pkt #939 on the input: addr=3 len=2 parity=bad gap=5 |
| 298105 | reference | Packet dropped: illegal address 3 (len=2) |
| 298105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 298295 | **DUT** | IN  pkt #940 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298325 | **DUT** | IN  pkt #940 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298325 | yapp monitor | RX pkt #940 on the input: addr=3 len=2 parity=bad gap=18 |
| 298325 | reference | Packet dropped: illegal address 3 (len=2) |
| 298325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 298535 | **DUT** | IN  pkt #941 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298565 | **DUT** | IN  pkt #941 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298565 | yapp monitor | RX pkt #941 on the input: addr=3 len=2 parity=bad gap=20 |
| 298565 | reference | Packet dropped: illegal address 3 (len=2) |
| 298565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298590 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 298615 | **DUT** | IN  pkt #942 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298645 | **DUT** | IN  pkt #942 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298645 | yapp monitor | RX pkt #942 on the input: addr=3 len=2 parity=bad gap=4 |
| 298645 | reference | Packet dropped: illegal address 3 (len=2) |
| 298645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 298825 | **DUT** | IN  pkt #943 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298855 | **DUT** | IN  pkt #943 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298855 | yapp monitor | RX pkt #943 on the input: addr=3 len=2 parity=bad gap=17 |
| 298855 | reference | Packet dropped: illegal address 3 (len=2) |
| 298855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 299025 | **DUT** | IN  pkt #944 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299055 | **DUT** | IN  pkt #944 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299055 | yapp monitor | RX pkt #944 on the input: addr=3 len=2 parity=bad gap=16 |
| 299055 | reference | Packet dropped: illegal address 3 (len=2) |
| 299055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 299205 | **DUT** | IN  pkt #945 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299235 | **DUT** | IN  pkt #945 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299235 | yapp monitor | RX pkt #945 on the input: addr=3 len=2 parity=bad gap=14 |
| 299235 | reference | Packet dropped: illegal address 3 (len=2) |
| 299235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 299415 | **DUT** | IN  pkt #946 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299445 | **DUT** | IN  pkt #946 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299445 | yapp monitor | RX pkt #946 on the input: addr=3 len=2 parity=bad gap=17 |
| 299445 | reference | Packet dropped: illegal address 3 (len=2) |
| 299445 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299490 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 299545 | **DUT** | IN  pkt #947 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299575 | **DUT** | IN  pkt #947 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299575 | yapp monitor | RX pkt #947 on the input: addr=3 len=2 parity=bad gap=9 |
| 299575 | reference | Packet dropped: illegal address 3 (len=2) |
| 299575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 299765 | **DUT** | IN  pkt #948 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299795 | **DUT** | IN  pkt #948 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299795 | yapp monitor | RX pkt #948 on the input: addr=3 len=2 parity=bad gap=18 |
| 299795 | reference | Packet dropped: illegal address 3 (len=2) |
| 299795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 299895 | **DUT** | IN  pkt #949 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299925 | **DUT** | IN  pkt #949 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299925 | yapp monitor | RX pkt #949 on the input: addr=3 len=2 parity=bad gap=9 |
| 299925 | reference | Packet dropped: illegal address 3 (len=2) |
| 299925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 300135 | **DUT** | IN  pkt #950 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300165 | **DUT** | IN  pkt #950 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300165 | yapp monitor | RX pkt #950 on the input: addr=3 len=2 parity=bad gap=20 |
| 300165 | reference | Packet dropped: illegal address 3 (len=2) |
| 300165 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 300325 | **DUT** | IN  pkt #951 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300355 | **DUT** | IN  pkt #951 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300355 | yapp monitor | RX pkt #951 on the input: addr=3 len=2 parity=bad gap=15 |
| 300355 | reference | Packet dropped: illegal address 3 (len=2) |
| 300355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300410 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 300555 | **DUT** | IN  pkt #952 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300585 | **DUT** | IN  pkt #952 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300585 | yapp monitor | RX pkt #952 on the input: addr=3 len=2 parity=bad gap=19 |
| 300585 | reference | Packet dropped: illegal address 3 (len=2) |
| 300585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300650 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 300755 | **DUT** | IN  pkt #953 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300785 | **DUT** | IN  pkt #953 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300785 | yapp monitor | RX pkt #953 on the input: addr=3 len=2 parity=bad gap=16 |
| 300785 | reference | Packet dropped: illegal address 3 (len=2) |
| 300785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 300965 | **DUT** | IN  pkt #954 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300995 | **DUT** | IN  pkt #954 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300995 | yapp monitor | RX pkt #954 on the input: addr=3 len=2 parity=bad gap=17 |
| 300995 | reference | Packet dropped: illegal address 3 (len=2) |
| 300995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 301065 | **DUT** | IN  pkt #955 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301095 | **DUT** | IN  pkt #955 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301095 | yapp monitor | RX pkt #955 on the input: addr=3 len=2 parity=bad gap=6 |
| 301095 | reference | Packet dropped: illegal address 3 (len=2) |
| 301095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 301305 | **DUT** | IN  pkt #956 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301335 | **DUT** | IN  pkt #956 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301335 | yapp monitor | RX pkt #956 on the input: addr=3 len=2 parity=bad gap=20 |
| 301335 | reference | Packet dropped: illegal address 3 (len=2) |
| 301335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 301475 | **DUT** | IN  pkt #957 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301505 | **DUT** | IN  pkt #957 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301505 | yapp monitor | RX pkt #957 on the input: addr=3 len=2 parity=bad gap=13 |
| 301505 | reference | Packet dropped: illegal address 3 (len=2) |
| 301505 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 301625 | **DUT** | IN  pkt #958 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301655 | **DUT** | IN  pkt #958 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301655 | yapp monitor | RX pkt #958 on the input: addr=3 len=2 parity=bad gap=11 |
| 301655 | reference | Packet dropped: illegal address 3 (len=2) |
| 301655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 301805 | **DUT** | IN  pkt #959 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301835 | **DUT** | IN  pkt #959 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301835 | yapp monitor | RX pkt #959 on the input: addr=3 len=2 parity=bad gap=14 |
| 301835 | reference | Packet dropped: illegal address 3 (len=2) |
| 301835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 301985 | **DUT** | IN  pkt #960 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302015 | **DUT** | IN  pkt #960 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302015 | yapp monitor | RX pkt #960 on the input: addr=3 len=2 parity=bad gap=14 |
| 302015 | reference | Packet dropped: illegal address 3 (len=2) |
| 302015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 302225 | **DUT** | IN  pkt #961 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302255 | **DUT** | IN  pkt #961 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302255 | yapp monitor | RX pkt #961 on the input: addr=3 len=2 parity=bad gap=20 |
| 302255 | reference | Packet dropped: illegal address 3 (len=2) |
| 302255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 302445 | **DUT** | IN  pkt #962 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302475 | **DUT** | IN  pkt #962 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302475 | yapp monitor | RX pkt #962 on the input: addr=3 len=2 parity=bad gap=18 |
| 302475 | reference | Packet dropped: illegal address 3 (len=2) |
| 302475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 302685 | **DUT** | IN  pkt #963 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302715 | **DUT** | IN  pkt #963 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302715 | yapp monitor | RX pkt #963 on the input: addr=3 len=2 parity=bad gap=20 |
| 302715 | reference | Packet dropped: illegal address 3 (len=2) |
| 302715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 302925 | **DUT** | IN  pkt #964 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302955 | **DUT** | IN  pkt #964 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302955 | yapp monitor | RX pkt #964 on the input: addr=3 len=2 parity=bad gap=20 |
| 302955 | reference | Packet dropped: illegal address 3 (len=2) |
| 302955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302975 | **DUT** | IN  pkt #965 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303005 | **DUT** | IN  pkt #965 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303005 | yapp monitor | RX pkt #965 on the input: addr=3 len=2 parity=bad gap=1 |
| 303005 | reference | Packet dropped: illegal address 3 (len=2) |
| 303005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 303195 | **DUT** | IN  pkt #966 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303225 | **DUT** | IN  pkt #966 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303225 | yapp monitor | RX pkt #966 on the input: addr=3 len=2 parity=bad gap=18 |
| 303225 | reference | Packet dropped: illegal address 3 (len=2) |
| 303225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 303435 | **DUT** | IN  pkt #967 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303465 | **DUT** | IN  pkt #967 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303465 | yapp monitor | RX pkt #967 on the input: addr=3 len=2 parity=bad gap=20 |
| 303465 | reference | Packet dropped: illegal address 3 (len=2) |
| 303465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303485 | **DUT** | IN  pkt #968 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303515 | **DUT** | IN  pkt #968 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303515 | yapp monitor | RX pkt #968 on the input: addr=3 len=2 parity=bad gap=1 |
| 303515 | reference | Packet dropped: illegal address 3 (len=2) |
| 303515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 303540 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 303725 | **DUT** | IN  pkt #969 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303755 | **DUT** | IN  pkt #969 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303755 | yapp monitor | RX pkt #969 on the input: addr=3 len=2 parity=bad gap=20 |
| 303755 | reference | Packet dropped: illegal address 3 (len=2) |
| 303755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303835 | **DUT** | IN  pkt #970 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303865 | **DUT** | IN  pkt #970 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303865 | yapp monitor | RX pkt #970 on the input: addr=3 len=2 parity=bad gap=7 |
| 303865 | reference | Packet dropped: illegal address 3 (len=2) |
| 303865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 304075 | **DUT** | IN  pkt #971 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304105 | **DUT** | IN  pkt #971 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304105 | yapp monitor | RX pkt #971 on the input: addr=3 len=2 parity=bad gap=20 |
| 304105 | reference | Packet dropped: illegal address 3 (len=2) |
| 304105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304145 | **DUT** | IN  pkt #972 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 304175 | **DUT** | IN  pkt #972 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304175 | yapp monitor | RX pkt #972 on the input: addr=3 len=2 parity=bad gap=3 |
| 304175 | reference | Packet dropped: illegal address 3 (len=2) |
| 304175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 304335 | **DUT** | IN  pkt #973 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304365 | **DUT** | IN  pkt #973 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304365 | yapp monitor | RX pkt #973 on the input: addr=3 len=2 parity=bad gap=15 |
| 304365 | reference | Packet dropped: illegal address 3 (len=2) |
| 304365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 304535 | **DUT** | IN  pkt #974 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304565 | **DUT** | IN  pkt #974 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304565 | yapp monitor | RX pkt #974 on the input: addr=3 len=2 parity=bad gap=16 |
| 304565 | reference | Packet dropped: illegal address 3 (len=2) |
| 304565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 304755 | **DUT** | IN  pkt #975 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304785 | **DUT** | IN  pkt #975 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304785 | yapp monitor | RX pkt #975 on the input: addr=3 len=2 parity=bad gap=18 |
| 304785 | reference | Packet dropped: illegal address 3 (len=2) |
| 304785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304805 | **DUT** | IN  pkt #976 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304835 | **DUT** | IN  pkt #976 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304835 | yapp monitor | RX pkt #976 on the input: addr=3 len=2 parity=bad gap=1 |
| 304835 | reference | Packet dropped: illegal address 3 (len=2) |
| 304835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 304900 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 304915 | **DUT** | IN  pkt #977 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304945 | **DUT** | IN  pkt #977 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304945 | yapp monitor | RX pkt #977 on the input: addr=3 len=2 parity=bad gap=7 |
| 304945 | reference | Packet dropped: illegal address 3 (len=2) |
| 304945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 305155 | **DUT** | IN  pkt #978 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305185 | **DUT** | IN  pkt #978 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305185 | yapp monitor | RX pkt #978 on the input: addr=3 len=2 parity=bad gap=20 |
| 305185 | reference | Packet dropped: illegal address 3 (len=2) |
| 305185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305375 | **DUT** | IN  pkt #979 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305405 | **DUT** | IN  pkt #979 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305405 | yapp monitor | RX pkt #979 on the input: addr=3 len=2 parity=bad gap=18 |
| 305405 | reference | Packet dropped: illegal address 3 (len=2) |
| 305405 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 305615 | **DUT** | IN  pkt #980 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305645 | **DUT** | IN  pkt #980 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305645 | yapp monitor | RX pkt #980 on the input: addr=3 len=2 parity=bad gap=20 |
| 305645 | reference | Packet dropped: illegal address 3 (len=2) |
| 305645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 305825 | **DUT** | IN  pkt #981 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305855 | **DUT** | IN  pkt #981 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305855 | yapp monitor | RX pkt #981 on the input: addr=3 len=2 parity=bad gap=17 |
| 305855 | reference | Packet dropped: illegal address 3 (len=2) |
| 305855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 305945 | **DUT** | IN  pkt #982 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305975 | **DUT** | IN  pkt #982 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305975 | yapp monitor | RX pkt #982 on the input: addr=3 len=2 parity=bad gap=8 |
| 305975 | reference | Packet dropped: illegal address 3 (len=2) |
| 305975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 306185 | **DUT** | IN  pkt #983 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306215 | **DUT** | IN  pkt #983 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306215 | yapp monitor | RX pkt #983 on the input: addr=3 len=2 parity=bad gap=20 |
| 306215 | reference | Packet dropped: illegal address 3 (len=2) |
| 306215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 306425 | **DUT** | IN  pkt #984 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306455 | **DUT** | IN  pkt #984 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306455 | yapp monitor | RX pkt #984 on the input: addr=3 len=2 parity=bad gap=20 |
| 306455 | reference | Packet dropped: illegal address 3 (len=2) |
| 306455 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306470 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 306505 | **DUT** | IN  pkt #985 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306535 | **DUT** | IN  pkt #985 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306535 | yapp monitor | RX pkt #985 on the input: addr=3 len=2 parity=bad gap=4 |
| 306535 | reference | Packet dropped: illegal address 3 (len=2) |
| 306535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 306715 | **DUT** | IN  pkt #986 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306745 | **DUT** | IN  pkt #986 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306745 | yapp monitor | RX pkt #986 on the input: addr=3 len=2 parity=bad gap=17 |
| 306745 | reference | Packet dropped: illegal address 3 (len=2) |
| 306745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 306905 | **DUT** | IN  pkt #987 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306935 | **DUT** | IN  pkt #987 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306935 | yapp monitor | RX pkt #987 on the input: addr=3 len=2 parity=bad gap=15 |
| 306935 | reference | Packet dropped: illegal address 3 (len=2) |
| 306935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306950 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 307005 | **DUT** | IN  pkt #988 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307035 | **DUT** | IN  pkt #988 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307035 | yapp monitor | RX pkt #988 on the input: addr=3 len=2 parity=bad gap=6 |
| 307035 | reference | Packet dropped: illegal address 3 (len=2) |
| 307035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 307235 | **DUT** | IN  pkt #989 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307265 | **DUT** | IN  pkt #989 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307265 | yapp monitor | RX pkt #989 on the input: addr=3 len=2 parity=bad gap=19 |
| 307265 | reference | Packet dropped: illegal address 3 (len=2) |
| 307265 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 307435 | **DUT** | IN  pkt #990 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307465 | **DUT** | IN  pkt #990 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307465 | yapp monitor | RX pkt #990 on the input: addr=3 len=2 parity=bad gap=16 |
| 307465 | reference | Packet dropped: illegal address 3 (len=2) |
| 307465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307495 | **DUT** | IN  pkt #991 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307525 | **DUT** | IN  pkt #991 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307525 | yapp monitor | RX pkt #991 on the input: addr=3 len=2 parity=bad gap=2 |
| 307525 | reference | Packet dropped: illegal address 3 (len=2) |
| 307525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 307550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 307735 | **DUT** | IN  pkt #992 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307765 | **DUT** | IN  pkt #992 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307765 | yapp monitor | RX pkt #992 on the input: addr=3 len=2 parity=bad gap=20 |
| 307765 | reference | Packet dropped: illegal address 3 (len=2) |
| 307765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 307895 | **DUT** | IN  pkt #993 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307925 | **DUT** | IN  pkt #993 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307925 | yapp monitor | RX pkt #993 on the input: addr=3 len=2 parity=bad gap=12 |
| 307925 | reference | Packet dropped: illegal address 3 (len=2) |
| 307925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 308135 | **DUT** | IN  pkt #994 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308165 | **DUT** | IN  pkt #994 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308165 | yapp monitor | RX pkt #994 on the input: addr=3 len=2 parity=bad gap=20 |
| 308165 | reference | Packet dropped: illegal address 3 (len=2) |
| 308165 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308190 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 308255 | **DUT** | IN  pkt #995 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308285 | **DUT** | IN  pkt #995 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308285 | yapp monitor | RX pkt #995 on the input: addr=3 len=2 parity=bad gap=8 |
| 308285 | reference | Packet dropped: illegal address 3 (len=2) |
| 308285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 308395 | **DUT** | IN  pkt #996 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308425 | **DUT** | IN  pkt #996 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308425 | yapp monitor | RX pkt #996 on the input: addr=3 len=2 parity=bad gap=10 |
| 308425 | reference | Packet dropped: illegal address 3 (len=2) |
| 308425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 308595 | **DUT** | IN  pkt #997 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308625 | **DUT** | IN  pkt #997 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308625 | yapp monitor | RX pkt #997 on the input: addr=3 len=2 parity=bad gap=16 |
| 308625 | reference | Packet dropped: illegal address 3 (len=2) |
| 308625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 308795 | **DUT** | IN  pkt #998 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308825 | **DUT** | IN  pkt #998 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308825 | yapp monitor | RX pkt #998 on the input: addr=3 len=2 parity=bad gap=16 |
| 308825 | reference | Packet dropped: illegal address 3 (len=2) |
| 308825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309035 | **DUT** | IN  pkt #999 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309065 | **DUT** | IN  pkt #999 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309065 | yapp monitor | RX pkt #999 on the input: addr=3 len=2 parity=bad gap=20 |
| 309065 | reference | Packet dropped: illegal address 3 (len=2) |
| 309065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 309275 | **DUT** | IN  pkt #1000 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309305 | **DUT** | IN  pkt #1000 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309305 | yapp monitor | RX pkt #1000 on the input: addr=3 len=2 parity=bad gap=20 |
| 309305 | reference | Packet dropped: illegal address 3 (len=2) |
| 309305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309515 | **DUT** | IN  pkt #1001 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309545 | **DUT** | IN  pkt #1001 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309545 | yapp monitor | RX pkt #1001 on the input: addr=3 len=2 parity=bad gap=20 |
| 309545 | reference | Packet dropped: illegal address 3 (len=2) |
| 309545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309565 | **DUT** | IN  pkt #1002 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309595 | **DUT** | IN  pkt #1002 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309595 | yapp monitor | RX pkt #1002 on the input: addr=3 len=2 parity=bad gap=1 |
| 309595 | reference | Packet dropped: illegal address 3 (len=2) |
| 309595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 309620 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 309635 | **DUT** | IN  pkt #1003 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309665 | **DUT** | IN  pkt #1003 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309665 | yapp monitor | RX pkt #1003 on the input: addr=3 len=2 parity=bad gap=3 |
| 309665 | reference | Packet dropped: illegal address 3 (len=2) |
| 309665 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309690 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 309705 | **DUT** | IN  pkt #1004 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309735 | **DUT** | IN  pkt #1004 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309735 | yapp monitor | RX pkt #1004 on the input: addr=3 len=2 parity=bad gap=3 |
| 309735 | reference | Packet dropped: illegal address 3 (len=2) |
| 309735 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 309945 | **DUT** | IN  pkt #1005 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309975 | **DUT** | IN  pkt #1005 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309975 | yapp monitor | RX pkt #1005 on the input: addr=3 len=2 parity=bad gap=20 |
| 309975 | reference | Packet dropped: illegal address 3 (len=2) |
| 309975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 310145 | **DUT** | IN  pkt #1006 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310175 | **DUT** | IN  pkt #1006 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310175 | yapp monitor | RX pkt #1006 on the input: addr=3 len=2 parity=bad gap=16 |
| 310175 | reference | Packet dropped: illegal address 3 (len=2) |
| 310175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 310345 | **DUT** | IN  pkt #1007 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310375 | **DUT** | IN  pkt #1007 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310375 | yapp monitor | RX pkt #1007 on the input: addr=3 len=2 parity=bad gap=16 |
| 310375 | reference | Packet dropped: illegal address 3 (len=2) |
| 310375 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 310575 | **DUT** | IN  pkt #1008 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310605 | **DUT** | IN  pkt #1008 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310605 | yapp monitor | RX pkt #1008 on the input: addr=3 len=2 parity=bad gap=19 |
| 310605 | reference | Packet dropped: illegal address 3 (len=2) |
| 310605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 310745 | **DUT** | IN  pkt #1009 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310775 | **DUT** | IN  pkt #1009 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310775 | yapp monitor | RX pkt #1009 on the input: addr=3 len=2 parity=bad gap=13 |
| 310775 | reference | Packet dropped: illegal address 3 (len=2) |
| 310775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310790 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 310985 | **DUT** | IN  pkt #1010 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311015 | **DUT** | IN  pkt #1010 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311015 | yapp monitor | RX pkt #1010 on the input: addr=3 len=2 parity=bad gap=20 |
| 311015 | reference | Packet dropped: illegal address 3 (len=2) |
| 311015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 311225 | **DUT** | IN  pkt #1011 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311255 | **DUT** | IN  pkt #1011 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311255 | yapp monitor | RX pkt #1011 on the input: addr=3 len=2 parity=bad gap=20 |
| 311255 | reference | Packet dropped: illegal address 3 (len=2) |
| 311255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 311465 | **DUT** | IN  pkt #1012 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311495 | **DUT** | IN  pkt #1012 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311495 | yapp monitor | RX pkt #1012 on the input: addr=3 len=2 parity=bad gap=20 |
| 311495 | reference | Packet dropped: illegal address 3 (len=2) |
| 311495 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 311705 | **DUT** | IN  pkt #1013 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311735 | **DUT** | IN  pkt #1013 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311735 | yapp monitor | RX pkt #1013 on the input: addr=3 len=2 parity=bad gap=20 |
| 311735 | reference | Packet dropped: illegal address 3 (len=2) |
| 311735 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 311795 | **DUT** | IN  pkt #1014 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311825 | **DUT** | IN  pkt #1014 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311825 | yapp monitor | RX pkt #1014 on the input: addr=3 len=2 parity=bad gap=5 |
| 311825 | reference | Packet dropped: illegal address 3 (len=2) |
| 311825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 312005 | **DUT** | IN  pkt #1015 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312035 | **DUT** | IN  pkt #1015 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312035 | yapp monitor | RX pkt #1015 on the input: addr=3 len=2 parity=bad gap=17 |
| 312035 | reference | Packet dropped: illegal address 3 (len=2) |
| 312035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 312245 | **DUT** | IN  pkt #1016 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312275 | **DUT** | IN  pkt #1016 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312275 | yapp monitor | RX pkt #1016 on the input: addr=3 len=2 parity=bad gap=20 |
| 312275 | reference | Packet dropped: illegal address 3 (len=2) |
| 312275 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312295 | **DUT** | IN  pkt #1017 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312325 | **DUT** | IN  pkt #1017 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312325 | yapp monitor | RX pkt #1017 on the input: addr=3 len=2 parity=bad gap=1 |
| 312325 | reference | Packet dropped: illegal address 3 (len=2) |
| 312325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 312360 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 312455 | **DUT** | IN  pkt #1018 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312485 | **DUT** | IN  pkt #1018 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312485 | yapp monitor | RX pkt #1018 on the input: addr=3 len=2 parity=bad gap=12 |
| 312485 | reference | Packet dropped: illegal address 3 (len=2) |
| 312485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 312585 | **DUT** | IN  pkt #1019 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312615 | **DUT** | IN  pkt #1019 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312615 | yapp monitor | RX pkt #1019 on the input: addr=3 len=2 parity=bad gap=9 |
| 312615 | reference | Packet dropped: illegal address 3 (len=2) |
| 312615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 312755 | **DUT** | IN  pkt #1020 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312785 | **DUT** | IN  pkt #1020 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312785 | yapp monitor | RX pkt #1020 on the input: addr=3 len=2 parity=bad gap=13 |
| 312785 | reference | Packet dropped: illegal address 3 (len=2) |
| 312785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 312995 | **DUT** | IN  pkt #1021 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313025 | **DUT** | IN  pkt #1021 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313025 | yapp monitor | RX pkt #1021 on the input: addr=3 len=2 parity=bad gap=20 |
| 313025 | reference | Packet dropped: illegal address 3 (len=2) |
| 313025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 313065 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 313095 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 313125 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 313155 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 313185 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 313210 | **test** | STAGE: 8. ctrl_reg and en_reg back to their reset values, every register read |
| 313215 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 313235 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 313235 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 313235 | reference | maxpktsize is now 63 |
| 313255 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 313255 | reference | router_en is now 1 (en_reg 0x01) |
| 313285 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 313315 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 313345 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 313375 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 313405 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 313435 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 313465 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 313495 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 313525 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 313555 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 313585 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 313615 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 313645 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 313670 | **test** | STAGE: sweep done: 1021 packets, 3628 HBUS reads |
| 313675 | hbus monitor | Collected READ  addr=0x100d data=0x02 |
| 314165 | **test** | STAGE: 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 314165 | **test** | HBUS address map coverage 100% |
| 314165 | **test** | ctrl_reg / en_reg bits coverage 100% |
| 314165 | **test** | yapp_mem data patterns coverage 100% |
| 314165 | **test** | counter values coverage 100% |
| 314165 | **test** | STAGE: done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |
| 314365 | ch0 monitor | Channel 0 report: 1 packets collected |
| 314365 | ch1 monitor | Channel 1 report: 0 packets collected |
| 314365 | ch2 monitor | Channel 2 report: 0 packets collected |
| 314365 | hbus monitor | HBUS report: 1459 writes, 3628 reads |
| 314365 | coverage | Coverage of the router configuration: 60.9% |
| 314365 | coverage | HBUS address coverage: 5087 accesses sampled, coverage 100.0% |
| 314365 | coverage | HBUS register bits coverage: 51 writes to ctrl_reg/en_reg, coverage 100.0% |
| 314365 | coverage | HBUS counter value coverage: 876 counter reads sampled, coverage 100.0% |
| 314365 | coverage | HBUS yapp_mem data coverage: 2560 accesses sampled, coverage 100.0% |
| 314365 | reference |  |
| 314365 | reference | HBUS reads checked against the model: 3585 (0 mismatches, 43 of memory bytes never written) |
| 314365 | scoreboard |  |
| 314365 | coverage | YAPP gap coverage: 1020 gaps sampled, coverage 75.0% |
| 314365 | yapp monitor | YAPP monitor report: 1021 packets collected, 1020 with bad parity |
| 314365 | yapp monitor | YAPP gaps: 0 back to back, 71 of 1 cycle, 33 of 2, 916 longer |
| 314365 | coverage | YAPP packet coverage: 1021 packets sampled, coverage 50.0% |
