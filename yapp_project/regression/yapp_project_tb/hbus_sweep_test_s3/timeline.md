# hbus_sweep_test seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 319us · wall 117.3 s · log [`hbus_sweep_test_s3.log`](hbus_sweep_test_s3.log)

Waves: `hbus_sweep_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fhbus_sweep_test_s3%2Fhbus_sweep_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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
| 470 | 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 32510 | 3. ctrl_reg and en_reg: walking one and walking zero |
| 34150 | 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 68070 | 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 72310 | 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 136310 | 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136510 | 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 181430 | 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 226630 | 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 272150 | 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 317820 | 8. ctrl_reg and en_reg back to their reset values, every register read |
| 318280 | sweep done: 1021 packets, 3628 HBUS reads |
| 318775 | 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 318775 | done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |

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
| 255 | **DUT** | IN  pkt #1 header: addr=0 len=20 -> channel 0 |
| 355 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=20 (receiver waited 9 cycle(s)) |
| 465 | **DUT** | IN  pkt #1 complete: addr=0 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 465 | reference | Packet forwarded: addr=0 len=20 -> channel 0 |
| 470 | **test** | STAGE: 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 495 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 495 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 495 | reference | maxpktsize is now 0 |
| 525 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 555 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 585 | **DUT** | OUT ch0 pkt #1 done: 22 bytes in 24 cycles |
| 585 | scoreboard | ch0 pkt matched: addr=0 len=20 (1 matched so far) |
| 585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 995 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 995 | hbus monitor | Collected WRITE addr=0x1000 data=0xff |
| 995 | reference | maxpktsize is now 63 |
| 1025 | hbus monitor | Collected READ  addr=0x1000 data=0xff |
| 1055 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1495 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1495 | hbus monitor | Collected WRITE addr=0x1000 data=0x55 |
| 1495 | reference | maxpktsize is now 21 |
| 1525 | hbus monitor | Collected READ  addr=0x1000 data=0x55 |
| 1555 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 1615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 1645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 1675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 1705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 1735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 1765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 1795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 1825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 1855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 1885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 1915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 1945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 1975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 1995 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 1995 | hbus monitor | Collected WRITE addr=0x1000 data=0xaa |
| 1995 | reference | maxpktsize is now 42 |
| 2025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2055 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 2085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2495 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 2495 | hbus monitor | Collected WRITE addr=0x1001 data=0x00 |
| 2495 | reference | router_en is now 0 (en_reg 0x00) |
| 2525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 2555 | hbus monitor | Collected READ  addr=0x1001 data=0x00 |
| 2585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 2615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 2645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 2765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 2795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 2915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 2945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 2975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 2995 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 2995 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 2995 | reference | router_en is now 1 (en_reg 0xff) |
| 3025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3055 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 3085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3495 | hbus monitor | Collected WRITE addr=0x1001 data=0x55 |
| 3495 | reference | router_en is now 1 (en_reg 0x55) |
| 3525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 3555 | hbus monitor | Collected READ  addr=0x1001 data=0x55 |
| 3585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 3615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 3645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 3675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 3705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 3735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 3765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 3795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 3825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 3855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 3885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 3915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 3945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 3975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 3995 | **DUT** | CONFIG router_en=0 maxpktsize=42 |
| 3995 | hbus monitor | Collected WRITE addr=0x1001 data=0xaa |
| 3995 | reference | router_en is now 0 (en_reg 0xaa) |
| 4025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4495 | hbus monitor | Collected WRITE addr=0x1002 data=0x00 |
| 4525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 4555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 4585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 4615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 4645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 4675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 4705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 4735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 4765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 4795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 4825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 4855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 4885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 4915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 4945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 4975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 4995 | hbus monitor | Collected WRITE addr=0x1002 data=0xff |
| 5025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5495 | hbus monitor | Collected WRITE addr=0x1002 data=0x55 |
| 5525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 5555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 5585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 5615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 5645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 5675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 5705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 5735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 5765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 5795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 5825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 5855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 5885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 5915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 5945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 5975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 5995 | hbus monitor | Collected WRITE addr=0x1002 data=0xaa |
| 6025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6495 | hbus monitor | Collected WRITE addr=0x1003 data=0x00 |
| 6525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 6555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 6585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 6615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 6645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 6675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 6705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 6735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 6765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 6795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 6825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 6855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 6885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 6915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 6945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 6975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 6995 | hbus monitor | Collected WRITE addr=0x1003 data=0xff |
| 7025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7495 | hbus monitor | Collected WRITE addr=0x1003 data=0x55 |
| 7525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 7555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 7585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 7615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 7645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 7675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 7705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 7735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 7765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 7795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 7825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 7855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 7885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 7915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 7945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 7975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 7995 | hbus monitor | Collected WRITE addr=0x1003 data=0xaa |
| 8025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8495 | hbus monitor | Collected WRITE addr=0x1004 data=0x00 |
| 8525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 8555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 8585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 8615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 8645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 8675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 8705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 8735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 8765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 8795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 8825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 8855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 8885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 8915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 8945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 8975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 8995 | hbus monitor | Collected WRITE addr=0x1004 data=0xff |
| 9025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9495 | hbus monitor | Collected WRITE addr=0x1004 data=0x55 |
| 9525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 9555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 9585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 9615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 9645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 9675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 9705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 9735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 9765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 9795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 9825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 9855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 9885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 9915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 9945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 9975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 9995 | hbus monitor | Collected WRITE addr=0x1004 data=0xaa |
| 10025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10495 | hbus monitor | Collected WRITE addr=0x1005 data=0x00 |
| 10525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 10555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 10585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 10615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 10645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 10675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 10705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 10735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 10765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 10795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 10825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 10855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 10885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 10915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 10945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 10975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 10995 | hbus monitor | Collected WRITE addr=0x1005 data=0xff |
| 11025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11495 | hbus monitor | Collected WRITE addr=0x1005 data=0x55 |
| 11525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 11555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 11585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 11615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 11645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 11675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 11705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 11735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 11765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 11795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 11825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 11855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 11885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 11915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 11945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 11975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 11995 | hbus monitor | Collected WRITE addr=0x1005 data=0xaa |
| 12025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12495 | hbus monitor | Collected WRITE addr=0x1006 data=0x00 |
| 12525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 12555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 12585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 12615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 12645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 12675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 12705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 12735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 12765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 12795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 12825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 12855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 12885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 12915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 12945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 12975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 12995 | hbus monitor | Collected WRITE addr=0x1006 data=0xff |
| 13025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13495 | hbus monitor | Collected WRITE addr=0x1006 data=0x55 |
| 13525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 13555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 13585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 13615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 13645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 13675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 13705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 13735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 13765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 13795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 13825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 13855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 13885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 13915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 13945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 13975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 13995 | hbus monitor | Collected WRITE addr=0x1006 data=0xaa |
| 14025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14495 | hbus monitor | Collected WRITE addr=0x1007 data=0x00 |
| 14525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 14555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 14585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 14615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 14645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 14675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 14705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 14735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 14765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 14795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 14825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 14855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 14885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 14915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 14945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 14975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 14995 | hbus monitor | Collected WRITE addr=0x1007 data=0xff |
| 15025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15495 | hbus monitor | Collected WRITE addr=0x1007 data=0x55 |
| 15525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 15555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 15585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 15615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 15645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 15675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 15705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 15735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 15765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 15795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 15825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 15855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 15885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 15915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 15945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 15975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 15995 | hbus monitor | Collected WRITE addr=0x1007 data=0xaa |
| 16025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16495 | hbus monitor | Collected WRITE addr=0x1008 data=0x00 |
| 16525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 16555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 16585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 16615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 16645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 16675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 16705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 16735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 16765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 16795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 16825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 16855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 16885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 16915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 16945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 16975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 16995 | hbus monitor | Collected WRITE addr=0x1008 data=0xff |
| 17025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17495 | hbus monitor | Collected WRITE addr=0x1008 data=0x55 |
| 17525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 17555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 17585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 17615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 17645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 17675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 17705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 17735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 17765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 17795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 17825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 17855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 17885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 17915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 17945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 17975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 17995 | hbus monitor | Collected WRITE addr=0x1008 data=0xaa |
| 18025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18495 | hbus monitor | Collected WRITE addr=0x1009 data=0x00 |
| 18525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 18555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 18585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 18615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 18645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 18675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 18705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 18735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 18765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 18795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 18825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 18855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 18885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 18915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 18945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 18975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 18995 | hbus monitor | Collected WRITE addr=0x1009 data=0xff |
| 19025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19495 | hbus monitor | Collected WRITE addr=0x1009 data=0x55 |
| 19525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 19555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 19585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 19615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 19645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 19675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 19705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 19735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 19765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 19795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 19825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 19855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 19885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 19915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 19945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 19975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 19995 | hbus monitor | Collected WRITE addr=0x1009 data=0xaa |
| 20025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20495 | hbus monitor | Collected WRITE addr=0x100a data=0x00 |
| 20525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 20555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 20585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 20615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 20645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 20675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 20705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 20735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 20765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 20795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 20825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 20855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 20885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 20915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 20945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 20975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 20995 | hbus monitor | Collected WRITE addr=0x100a data=0xff |
| 21025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21495 | hbus monitor | Collected WRITE addr=0x100a data=0x55 |
| 21525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 21555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 21585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 21615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 21645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 21675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 21705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 21735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 21765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 21795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 21825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 21855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 21885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 21915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 21945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 21975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 21995 | hbus monitor | Collected WRITE addr=0x100a data=0xaa |
| 22025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22495 | hbus monitor | Collected WRITE addr=0x100b data=0x00 |
| 22525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 22555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 22585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 22615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 22645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 22675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 22705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 22735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 22765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 22795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 22825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 22855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 22885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 22915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 22945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 22975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 22995 | hbus monitor | Collected WRITE addr=0x100b data=0xff |
| 23025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23495 | hbus monitor | Collected WRITE addr=0x100b data=0x55 |
| 23525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 23555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 23585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 23615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 23645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 23675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 23705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 23735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 23765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 23795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 23825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 23855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 23885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 23915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 23945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 23975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 23995 | hbus monitor | Collected WRITE addr=0x100b data=0xaa |
| 24025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24495 | hbus monitor | Collected WRITE addr=0x100c data=0x00 |
| 24525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 24555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 24585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 24615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 24645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 24675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 24705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 24735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 24765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 24795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 24825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 24855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 24885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 24915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 24945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 24975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 24995 | hbus monitor | Collected WRITE addr=0x100c data=0xff |
| 25025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25495 | hbus monitor | Collected WRITE addr=0x100c data=0x55 |
| 25525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 25555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 25585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 25615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 25645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 25675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 25705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 25735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 25765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 25795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 25825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 25855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 25885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 25915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 25945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 25975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 25995 | hbus monitor | Collected WRITE addr=0x100c data=0xaa |
| 26025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26495 | hbus monitor | Collected WRITE addr=0x100d data=0x00 |
| 26525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 26555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 26585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 26615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 26645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 26675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 26705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 26735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 26765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 26795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 26825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 26855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 26885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 26915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 26945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 26975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 26995 | hbus monitor | Collected WRITE addr=0x100d data=0xff |
| 27025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27495 | hbus monitor | Collected WRITE addr=0x100d data=0x55 |
| 27525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 27555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 27585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 27615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 27645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 27675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 27705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 27735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 27765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 27795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 27825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 27855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 27885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 27915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 27945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 27975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 27995 | hbus monitor | Collected WRITE addr=0x100d data=0xaa |
| 28025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28495 | hbus monitor | Collected WRITE addr=0x100e data=0x00 |
| 28525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 28555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 28585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 28615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 28645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 28675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 28705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 28735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 28765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 28795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 28825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 28855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 28885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 28915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 28945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 28975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 28995 | hbus monitor | Collected WRITE addr=0x100e data=0xff |
| 29025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29495 | hbus monitor | Collected WRITE addr=0x100e data=0x55 |
| 29525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 29555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 29585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 29615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 29645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 29675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 29705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 29735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 29765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 29795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 29825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 29855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 29885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 29915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 29945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 29975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 29995 | hbus monitor | Collected WRITE addr=0x100e data=0xaa |
| 30025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30495 | hbus monitor | Collected WRITE addr=0x100f data=0x00 |
| 30525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 30555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 30585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 30615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 30645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 30675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 30705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 30735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 30765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 30795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 30825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 30855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 30885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 30915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 30945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 30975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 30995 | hbus monitor | Collected WRITE addr=0x100f data=0xff |
| 31025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31495 | hbus monitor | Collected WRITE addr=0x100f data=0x55 |
| 31525 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 31555 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 31585 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 31615 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 31645 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 31675 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 31705 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 31735 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 31765 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 31795 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 31825 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 31855 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 31885 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 31915 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 31945 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 31975 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 31995 | hbus monitor | Collected WRITE addr=0x100f data=0xaa |
| 32025 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 32055 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 32085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 32115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 32145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 32175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 32205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 32235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 32265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 32295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 32325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 32355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 32385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 32415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 32445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 32475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 32495 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 32495 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 32495 | reference | maxpktsize is now 63 |
| 32510 | **test** | STAGE: 3. ctrl_reg and en_reg: walking one and walking zero |
| 32515 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 32515 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 32515 | reference | router_en is now 1 (en_reg 0x01) |
| 32535 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 32535 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 32535 | reference | maxpktsize is now 1 |
| 32565 | hbus monitor | Collected READ  addr=0x1000 data=0x01 |
| 32585 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 32585 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 32585 | reference | maxpktsize is now 62 |
| 32615 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 32635 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 32635 | hbus monitor | Collected WRITE addr=0x1000 data=0x02 |
| 32635 | reference | maxpktsize is now 2 |
| 32665 | hbus monitor | Collected READ  addr=0x1000 data=0x02 |
| 32685 | **DUT** | CONFIG router_en=1 maxpktsize=61 |
| 32685 | hbus monitor | Collected WRITE addr=0x1000 data=0xfd |
| 32685 | reference | maxpktsize is now 61 |
| 32715 | hbus monitor | Collected READ  addr=0x1000 data=0xfd |
| 32735 | **DUT** | CONFIG router_en=1 maxpktsize=4 |
| 32735 | hbus monitor | Collected WRITE addr=0x1000 data=0x04 |
| 32735 | reference | maxpktsize is now 4 |
| 32765 | hbus monitor | Collected READ  addr=0x1000 data=0x04 |
| 32785 | **DUT** | CONFIG router_en=1 maxpktsize=59 |
| 32785 | hbus monitor | Collected WRITE addr=0x1000 data=0xfb |
| 32785 | reference | maxpktsize is now 59 |
| 32815 | hbus monitor | Collected READ  addr=0x1000 data=0xfb |
| 32835 | **DUT** | CONFIG router_en=1 maxpktsize=8 |
| 32835 | hbus monitor | Collected WRITE addr=0x1000 data=0x08 |
| 32835 | reference | maxpktsize is now 8 |
| 32865 | hbus monitor | Collected READ  addr=0x1000 data=0x08 |
| 32885 | **DUT** | CONFIG router_en=1 maxpktsize=55 |
| 32885 | hbus monitor | Collected WRITE addr=0x1000 data=0xf7 |
| 32885 | reference | maxpktsize is now 55 |
| 32915 | hbus monitor | Collected READ  addr=0x1000 data=0xf7 |
| 32935 | **DUT** | CONFIG router_en=1 maxpktsize=16 |
| 32935 | hbus monitor | Collected WRITE addr=0x1000 data=0x10 |
| 32935 | reference | maxpktsize is now 16 |
| 32965 | hbus monitor | Collected READ  addr=0x1000 data=0x10 |
| 32985 | **DUT** | CONFIG router_en=1 maxpktsize=47 |
| 32985 | hbus monitor | Collected WRITE addr=0x1000 data=0xef |
| 32985 | reference | maxpktsize is now 47 |
| 33015 | hbus monitor | Collected READ  addr=0x1000 data=0xef |
| 33035 | **DUT** | CONFIG router_en=1 maxpktsize=32 |
| 33035 | hbus monitor | Collected WRITE addr=0x1000 data=0x20 |
| 33035 | reference | maxpktsize is now 32 |
| 33065 | hbus monitor | Collected READ  addr=0x1000 data=0x20 |
| 33085 | **DUT** | CONFIG router_en=1 maxpktsize=31 |
| 33085 | hbus monitor | Collected WRITE addr=0x1000 data=0xdf |
| 33085 | reference | maxpktsize is now 31 |
| 33115 | hbus monitor | Collected READ  addr=0x1000 data=0xdf |
| 33135 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33135 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 33135 | reference | maxpktsize is now 0 |
| 33165 | hbus monitor | Collected READ  addr=0x1000 data=0x40 |
| 33185 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33185 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 33185 | reference | maxpktsize is now 63 |
| 33215 | hbus monitor | Collected READ  addr=0x1000 data=0xbf |
| 33235 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 33235 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 33235 | reference | maxpktsize is now 0 |
| 33265 | hbus monitor | Collected READ  addr=0x1000 data=0x80 |
| 33285 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33285 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 33285 | reference | maxpktsize is now 63 |
| 33315 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 33335 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 33335 | reference | router_en is now 1 (en_reg 0x01) |
| 33365 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 33385 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33385 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 33385 | reference | router_en is now 0 (en_reg 0xfe) |
| 33415 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 33435 | hbus monitor | Collected WRITE addr=0x1001 data=0x02 |
| 33435 | reference | router_en is now 0 (en_reg 0x02) |
| 33465 | hbus monitor | Collected READ  addr=0x1001 data=0x02 |
| 33485 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33485 | hbus monitor | Collected WRITE addr=0x1001 data=0xfd |
| 33485 | reference | router_en is now 1 (en_reg 0xfd) |
| 33515 | hbus monitor | Collected READ  addr=0x1001 data=0xfd |
| 33535 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33535 | hbus monitor | Collected WRITE addr=0x1001 data=0x04 |
| 33535 | reference | router_en is now 0 (en_reg 0x04) |
| 33565 | hbus monitor | Collected READ  addr=0x1001 data=0x04 |
| 33585 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33585 | hbus monitor | Collected WRITE addr=0x1001 data=0xfb |
| 33585 | reference | router_en is now 1 (en_reg 0xfb) |
| 33615 | hbus monitor | Collected READ  addr=0x1001 data=0xfb |
| 33635 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33635 | hbus monitor | Collected WRITE addr=0x1001 data=0x08 |
| 33635 | reference | router_en is now 0 (en_reg 0x08) |
| 33665 | hbus monitor | Collected READ  addr=0x1001 data=0x08 |
| 33685 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33685 | hbus monitor | Collected WRITE addr=0x1001 data=0xf7 |
| 33685 | reference | router_en is now 1 (en_reg 0xf7) |
| 33715 | hbus monitor | Collected READ  addr=0x1001 data=0xf7 |
| 33735 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33735 | hbus monitor | Collected WRITE addr=0x1001 data=0x10 |
| 33735 | reference | router_en is now 0 (en_reg 0x10) |
| 33765 | hbus monitor | Collected READ  addr=0x1001 data=0x10 |
| 33785 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33785 | hbus monitor | Collected WRITE addr=0x1001 data=0xef |
| 33785 | reference | router_en is now 1 (en_reg 0xef) |
| 33815 | hbus monitor | Collected READ  addr=0x1001 data=0xef |
| 33835 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33835 | hbus monitor | Collected WRITE addr=0x1001 data=0x20 |
| 33835 | reference | router_en is now 0 (en_reg 0x20) |
| 33865 | hbus monitor | Collected READ  addr=0x1001 data=0x20 |
| 33885 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33885 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 33885 | reference | router_en is now 1 (en_reg 0xdf) |
| 33915 | hbus monitor | Collected READ  addr=0x1001 data=0xdf |
| 33935 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 33935 | hbus monitor | Collected WRITE addr=0x1001 data=0x40 |
| 33935 | reference | router_en is now 0 (en_reg 0x40) |
| 33965 | hbus monitor | Collected READ  addr=0x1001 data=0x40 |
| 33985 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 33985 | hbus monitor | Collected WRITE addr=0x1001 data=0xbf |
| 33985 | reference | router_en is now 1 (en_reg 0xbf) |
| 34015 | hbus monitor | Collected READ  addr=0x1001 data=0xbf |
| 34035 | **DUT** | CONFIG router_en=0 maxpktsize=63 |
| 34035 | hbus monitor | Collected WRITE addr=0x1001 data=0x80 |
| 34035 | reference | router_en is now 0 (en_reg 0x80) |
| 34065 | hbus monitor | Collected READ  addr=0x1001 data=0x80 |
| 34085 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 34085 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 34085 | reference | router_en is now 1 (en_reg 0x7f) |
| 34115 | hbus monitor | Collected READ  addr=0x1001 data=0x7f |
| 34135 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 34135 | reference | maxpktsize is now 63 |
| 34150 | **test** | STAGE: 4. yapp_pkt_mem (read-only): write every byte, the reads still return the packet |
| 34155 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 34155 | reference | router_en is now 1 (en_reg 0x01) |
| 34175 | hbus monitor | Collected WRITE addr=0x1010 data=0x00 |
| 34205 | hbus monitor | Collected READ  addr=0x1010 data=0x50 |
| 34235 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34265 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34295 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34325 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34355 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34385 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34415 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34445 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 34475 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 34505 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 34535 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 34565 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 34595 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 34625 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 34655 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 34685 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 34705 | hbus monitor | Collected WRITE addr=0x1011 data=0x23 |
| 34735 | hbus monitor | Collected READ  addr=0x1011 data=0x02 |
| 34765 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 34795 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 34825 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 34855 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 34885 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 34915 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 34945 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 34975 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35005 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35035 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 35065 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 35095 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35125 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35155 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35185 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35215 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35235 | hbus monitor | Collected WRITE addr=0x1012 data=0x8f |
| 35265 | hbus monitor | Collected READ  addr=0x1012 data=0x23 |
| 35295 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35325 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35355 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35385 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35415 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35445 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 35475 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 35505 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 35535 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 35565 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 35595 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 35625 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 35655 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 35685 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 35715 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 35745 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 35765 | hbus monitor | Collected WRITE addr=0x1013 data=0xfe |
| 35795 | hbus monitor | Collected READ  addr=0x1013 data=0x95 |
| 35825 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 35855 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 35885 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 35915 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 35945 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 35975 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36005 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36035 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36065 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 36095 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36125 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36155 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36185 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36215 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36245 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36275 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36295 | hbus monitor | Collected WRITE addr=0x1014 data=0xf2 |
| 36325 | hbus monitor | Collected READ  addr=0x1014 data=0xb2 |
| 36355 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36385 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36415 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36445 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 36475 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 36505 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 36535 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 36565 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 36595 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 36625 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 36655 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 36685 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 36715 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 36745 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 36775 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 36805 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 36825 | hbus monitor | Collected WRITE addr=0x1015 data=0x67 |
| 36855 | hbus monitor | Collected READ  addr=0x1015 data=0xae |
| 36885 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 36915 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 36945 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 36975 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37005 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37035 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 37065 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 37095 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37125 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37155 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37185 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37215 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37245 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37275 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37305 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37335 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37355 | hbus monitor | Collected WRITE addr=0x1016 data=0x9a |
| 37385 | hbus monitor | Collected READ  addr=0x1016 data=0x03 |
| 37415 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37445 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 37475 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 37505 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 37535 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 37565 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 37595 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 37625 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 37655 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 37685 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 37715 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 37745 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 37775 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 37805 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 37835 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 37865 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 37885 | hbus monitor | Collected WRITE addr=0x1017 data=0x1e |
| 37915 | hbus monitor | Collected READ  addr=0x1017 data=0x2a |
| 37945 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 37975 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38005 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38035 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 38065 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 38095 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38125 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38155 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38185 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38215 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38245 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38275 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38305 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38335 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38365 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38395 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38415 | hbus monitor | Collected WRITE addr=0x1018 data=0x13 |
| 38445 | hbus monitor | Collected READ  addr=0x1018 data=0xf8 |
| 38475 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 38505 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 38535 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 38565 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 38595 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 38625 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 38655 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 38685 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 38715 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 38745 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 38775 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 38805 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 38835 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 38865 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 38895 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 38925 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 38945 | hbus monitor | Collected WRITE addr=0x1019 data=0x56 |
| 38975 | hbus monitor | Collected READ  addr=0x1019 data=0x33 |
| 39005 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39035 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 39065 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 39095 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39125 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39155 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39185 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39215 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39245 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39275 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39305 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39335 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39365 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39395 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39425 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39455 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 39475 | hbus monitor | Collected WRITE addr=0x101a data=0x43 |
| 39505 | hbus monitor | Collected READ  addr=0x101a data=0xaa |
| 39535 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 39565 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 39595 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 39625 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 39655 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 39685 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 39715 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 39745 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 39775 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 39805 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 39835 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 39865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 39895 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 39925 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 39955 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 39985 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40005 | hbus monitor | Collected WRITE addr=0x101b data=0x6d |
| 40035 | hbus monitor | Collected READ  addr=0x101b data=0x84 |
| 40065 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40095 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40125 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40155 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40185 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40215 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40245 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40275 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40305 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40335 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40365 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40395 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40425 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40455 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 40485 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 40515 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 40535 | hbus monitor | Collected WRITE addr=0x101c data=0xaa |
| 40565 | hbus monitor | Collected READ  addr=0x101c data=0xdb |
| 40595 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 40625 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 40655 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 40685 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 40715 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 40745 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 40775 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 40805 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 40835 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 40865 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 40895 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 40925 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 40955 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 40985 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41015 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 41045 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 41065 | hbus monitor | Collected WRITE addr=0x101d data=0x0c |
| 41095 | hbus monitor | Collected READ  addr=0x101d data=0x95 |
| 41125 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41155 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41185 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41215 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41245 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41275 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41305 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41335 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41365 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41395 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41425 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41455 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 41485 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
