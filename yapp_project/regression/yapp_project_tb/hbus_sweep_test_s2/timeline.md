# hbus_sweep_test seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 314us · wall 116.4 s · log [`hbus_sweep_test_s2.log`](hbus_sweep_test_s2.log)

Waves: `hbus_sweep_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fhbus_sweep_test_s2%2Fhbus_sweep_test_s2.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver quiet in this test (verbosity UVM_NONE); the input monitor saw **1021** packet(s).
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

11348 events; this table keeps the 10317 of the test, the DUT, the host bus, the checkers' reports and every warning or error, and only the first 1500 of those. The full list is in the log.

| time (ns) | who | event |
|---|---|---|
| 0 | **test** | STAGE: 1. one 20-byte packet to address 0, so yapp_pkt_mem holds known bytes |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 155 | **DUT** | IN  pkt #1 header: addr=0 len=20 -> channel 0 |
| 165 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=20 (receiver waited 0 cycle(s)) |
| 365 | **DUT** | IN  pkt #1 complete: addr=0 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 365 | reference | Packet forwarded: addr=0 len=20 -> channel 0 |
| 370 | **test** | STAGE: 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 395 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 395 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 395 | reference | maxpktsize is now 0 |
| 425 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 455 | **DUT** | OUT ch0 pkt #1 done: 22 bytes in 30 cycles |
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
