# hbus_sweep_test  seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 319us · log `hbus_sweep_test_s3.log`

Waves: `hbus_sweep_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fhbus_sweep_test_s3%2Fhbus_sweep_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

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

11348 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: 1. one 20-byte packet to address 0, so yapp_pkt_mem holds known bytes |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 255 | **DUT** | IN  pkt #1 header: addr=0 len=20 -> channel 0 |
| 355 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=20 (receiver waited 9 cycle(s)) |
| 465 | **DUT** | IN  pkt #1 complete: addr=0 len=20 parity=ok forwarded, 22 bytes in 22 cycles (held 0) |
| 465 | yapp monitor | RX pkt #1 on the input: addr=0 len=20 parity=good gap=20 |
| 465 | reference | Packet forwarded: addr=0 len=20 -> channel 0 |
| 470 | **test** | STAGE: 2. every address 0x1000..0x100f, registers and holes: write 0x00, 0xff, 0x55, 0xaa, read the window back |
| 495 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 495 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 495 | reference | maxpktsize is now 0 |
| 525 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 555 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 560 | ch0 driver | ch0: packet consumed (response delay 9) |
| 585 | **DUT** | OUT ch0 pkt #1 done: 22 bytes in 24 cycles |
| 585 | ch0 monitor | ch0 RX pkt #1: addr=0 len=20 parity=good |
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
| 990 | ch0 driver | ch0: packet consumed (response delay 1) |
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
| 41515 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 41545 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 41575 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 41595 | hbus monitor | Collected WRITE addr=0x101e data=0xdf |
| 41625 | hbus monitor | Collected READ  addr=0x101e data=0x0e |
| 41655 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 41685 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 41715 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 41745 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 41775 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 41805 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 41835 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 41865 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 41895 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 41925 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 41955 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 41985 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42015 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 42045 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 42075 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42105 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42125 | hbus monitor | Collected WRITE addr=0x101f data=0x20 |
| 42155 | hbus monitor | Collected READ  addr=0x101f data=0xfa |
| 42185 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42215 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42245 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42275 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42305 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42335 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42365 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42395 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42425 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42455 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 42485 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 42515 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 42545 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 42575 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 42605 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 42635 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 42655 | hbus monitor | Collected WRITE addr=0x1020 data=0x15 |
| 42685 | hbus monitor | Collected READ  addr=0x1020 data=0x7f |
| 42715 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 42745 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 42775 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 42805 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 42835 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 42865 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 42895 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 42925 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 42955 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 42985 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43015 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 43045 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 43075 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43105 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43135 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43165 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43185 | hbus monitor | Collected WRITE addr=0x1021 data=0x7a |
| 43215 | hbus monitor | Collected READ  addr=0x1021 data=0xa0 |
| 43245 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43275 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43305 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43335 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43365 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43395 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43425 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43455 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 43485 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 43515 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 43545 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 43575 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 43605 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 43635 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 43665 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 43695 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 43715 | hbus monitor | Collected WRITE addr=0x1022 data=0x39 |
| 43745 | hbus monitor | Collected READ  addr=0x1022 data=0x07 |
| 43775 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 43805 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 43835 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 43865 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 43895 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 43925 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 43955 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 43985 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44015 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 44045 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 44075 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44105 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44135 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44165 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44195 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44225 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44245 | hbus monitor | Collected WRITE addr=0x1023 data=0xc5 |
| 44275 | hbus monitor | Collected READ  addr=0x1023 data=0x2e |
| 44305 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44335 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44365 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44395 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44425 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44455 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 44485 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 44515 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 44545 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 44575 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 44605 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 44635 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 44665 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 44695 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 44725 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 44755 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 44775 | hbus monitor | Collected WRITE addr=0x1024 data=0x42 |
| 44805 | hbus monitor | Collected READ  addr=0x1024 data=0xd8 |
| 44835 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 44865 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 44895 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 44925 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 44955 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 44985 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45015 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 45045 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 45075 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45105 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45135 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45165 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45195 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45225 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45255 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45285 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45305 | hbus monitor | Collected WRITE addr=0x1025 data=0x04 |
| 45335 | hbus monitor | Collected READ  addr=0x1025 data=0x00 |
| 45365 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45395 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45425 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45455 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 45485 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 45515 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 45545 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 45575 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 45605 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 45635 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 45665 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 45695 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 45725 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 45755 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 45785 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 45815 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 45835 | hbus monitor | Collected WRITE addr=0x1026 data=0xe0 |
| 45865 | hbus monitor | Collected READ  addr=0x1026 data=0x00 |
| 45895 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 45925 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 45955 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 45985 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46015 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 46045 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 46075 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46105 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46135 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46165 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46195 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46225 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46255 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46285 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46315 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46345 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46365 | hbus monitor | Collected WRITE addr=0x1027 data=0x73 |
| 46395 | hbus monitor | Collected READ  addr=0x1027 data=0x00 |
| 46425 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46455 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 46485 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 46515 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 46545 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 46575 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 46605 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 46635 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 46665 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 46695 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 46725 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 46755 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 46785 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 46815 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 46845 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 46875 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 46895 | hbus monitor | Collected WRITE addr=0x1028 data=0xc3 |
| 46925 | hbus monitor | Collected READ  addr=0x1028 data=0x00 |
| 46955 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 46985 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47015 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 47045 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 47075 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47105 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47135 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47165 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47195 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47225 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47255 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47285 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47315 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47345 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47375 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47405 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47425 | hbus monitor | Collected WRITE addr=0x1029 data=0x26 |
| 47455 | hbus monitor | Collected READ  addr=0x1029 data=0x00 |
| 47485 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 47515 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 47545 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 47575 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 47605 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 47635 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 47665 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 47695 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 47725 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 47755 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 47785 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 47815 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 47845 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 47875 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 47905 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 47935 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 47955 | hbus monitor | Collected WRITE addr=0x102a data=0x6b |
| 47985 | hbus monitor | Collected READ  addr=0x102a data=0x00 |
| 48015 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 48045 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 48075 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48105 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48135 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48165 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48195 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48225 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48255 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48285 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48315 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48345 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48375 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48405 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48435 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 48465 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 48485 | hbus monitor | Collected WRITE addr=0x102b data=0x78 |
| 48515 | hbus monitor | Collected READ  addr=0x102b data=0x00 |
| 48545 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 48575 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 48605 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 48635 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 48665 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 48695 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 48725 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 48755 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 48785 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 48815 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 48845 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 48875 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 48905 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 48935 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 48965 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 48995 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49015 | hbus monitor | Collected WRITE addr=0x102c data=0x01 |
| 49045 | hbus monitor | Collected READ  addr=0x102c data=0x00 |
| 49075 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49105 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49135 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49165 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49195 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49225 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49255 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49285 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49315 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49345 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49375 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49405 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49435 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 49465 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 49495 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 49525 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 49545 | hbus monitor | Collected WRITE addr=0x102d data=0x27 |
| 49575 | hbus monitor | Collected READ  addr=0x102d data=0x00 |
| 49605 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 49635 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 49665 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 49695 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 49725 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 49755 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 49785 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 49815 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 49845 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 49875 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 49905 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 49935 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 49965 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 49995 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50025 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 50055 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 50075 | hbus monitor | Collected WRITE addr=0x102e data=0x54 |
| 50105 | hbus monitor | Collected READ  addr=0x102e data=0x00 |
| 50135 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50165 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50195 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50225 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50255 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50285 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50315 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50345 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50375 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50405 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50435 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 50465 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 50495 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 50525 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 50555 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 50585 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 50605 | hbus monitor | Collected WRITE addr=0x102f data=0xbc |
| 50635 | hbus monitor | Collected READ  addr=0x102f data=0x00 |
| 50665 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 50695 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 50725 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 50755 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 50785 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 50815 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 50845 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 50875 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 50905 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 50935 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 50965 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 50995 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51025 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 51055 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 51085 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51115 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51135 | hbus monitor | Collected WRITE addr=0x1030 data=0x36 |
| 51165 | hbus monitor | Collected READ  addr=0x1030 data=0x00 |
| 51195 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51225 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51255 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51285 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51315 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51345 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51375 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51405 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51435 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 51465 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 51495 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 51525 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 51555 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 51585 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 51615 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 51645 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 51665 | hbus monitor | Collected WRITE addr=0x1031 data=0x60 |
| 51695 | hbus monitor | Collected READ  addr=0x1031 data=0x00 |
| 51725 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 51755 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 51785 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 51815 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 51845 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 51875 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 51905 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 51935 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 51965 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 51995 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52025 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 52055 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 52085 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52115 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52145 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52175 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52195 | hbus monitor | Collected WRITE addr=0x1032 data=0x1c |
| 52225 | hbus monitor | Collected READ  addr=0x1032 data=0x00 |
| 52255 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52285 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52315 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52345 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52375 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52405 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52435 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 52465 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 52495 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 52525 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 52555 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 52585 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 52615 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 52645 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 52675 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 52705 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 52725 | hbus monitor | Collected WRITE addr=0x1033 data=0xda |
| 52755 | hbus monitor | Collected READ  addr=0x1033 data=0x00 |
| 52785 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 52815 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 52845 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 52875 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 52905 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 52935 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 52965 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 52995 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53025 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 53055 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 53085 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53115 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53145 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53175 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53205 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53235 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53255 | hbus monitor | Collected WRITE addr=0x1034 data=0x66 |
| 53285 | hbus monitor | Collected READ  addr=0x1034 data=0x00 |
| 53315 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53345 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53375 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53405 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53435 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 53465 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 53495 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 53525 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 53555 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 53585 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 53615 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 53645 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 53675 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 53705 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 53735 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 53765 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 53785 | hbus monitor | Collected WRITE addr=0x1035 data=0x36 |
| 53815 | hbus monitor | Collected READ  addr=0x1035 data=0x00 |
| 53845 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 53875 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 53905 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 53935 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 53965 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 53995 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54025 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 54055 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 54085 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54115 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54145 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54175 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54205 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54235 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54265 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54295 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54315 | hbus monitor | Collected WRITE addr=0x1036 data=0x20 |
| 54345 | hbus monitor | Collected READ  addr=0x1036 data=0x00 |
| 54375 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54405 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54435 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 54465 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 54495 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 54525 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 54555 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 54585 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 54615 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 54645 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 54675 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 54705 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 54735 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 54765 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 54795 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 54825 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 54845 | hbus monitor | Collected WRITE addr=0x1037 data=0xea |
| 54875 | hbus monitor | Collected READ  addr=0x1037 data=0x00 |
| 54905 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 54935 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 54965 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 54995 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55025 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 55055 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 55085 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55115 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55145 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55175 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55205 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55235 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55265 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55295 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55325 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55355 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55375 | hbus monitor | Collected WRITE addr=0x1038 data=0x58 |
| 55405 | hbus monitor | Collected READ  addr=0x1038 data=0x00 |
| 55435 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 55465 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 55495 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 55525 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 55555 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 55585 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 55615 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 55645 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 55675 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 55705 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 55735 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 55765 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 55795 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 55825 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 55855 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 55885 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 55905 | hbus monitor | Collected WRITE addr=0x1039 data=0x38 |
| 55935 | hbus monitor | Collected READ  addr=0x1039 data=0x00 |
| 55965 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 55995 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56025 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 56055 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 56085 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56115 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56145 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56175 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56205 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56235 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56265 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56295 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56325 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56355 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56385 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56415 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56435 | hbus monitor | Collected WRITE addr=0x103a data=0xca |
| 56465 | hbus monitor | Collected READ  addr=0x103a data=0x00 |
| 56495 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 56525 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 56555 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 56585 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 56615 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 56645 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 56675 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 56705 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 56735 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 56765 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 56795 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 56825 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 56855 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 56885 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 56915 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 56945 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 56965 | hbus monitor | Collected WRITE addr=0x103b data=0xd8 |
| 56995 | hbus monitor | Collected READ  addr=0x103b data=0x00 |
| 57025 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 57055 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 57085 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57115 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57145 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57175 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57205 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57235 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57265 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57295 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57325 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57355 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57385 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57415 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57445 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 57475 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 57495 | hbus monitor | Collected WRITE addr=0x103c data=0x63 |
| 57525 | hbus monitor | Collected READ  addr=0x103c data=0x00 |
| 57555 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 57585 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 57615 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 57645 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 57675 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 57705 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 57735 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 57765 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 57795 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 57825 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 57855 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 57885 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 57915 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 57945 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 57975 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58005 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58025 | hbus monitor | Collected WRITE addr=0x103d data=0x90 |
| 58055 | hbus monitor | Collected READ  addr=0x103d data=0x00 |
| 58085 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58115 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58145 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58175 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58205 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58235 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58265 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58295 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58325 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58355 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58385 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58415 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58445 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 58475 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 58505 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 58535 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 58555 | hbus monitor | Collected WRITE addr=0x103e data=0x0f |
| 58585 | hbus monitor | Collected READ  addr=0x103e data=0x00 |
| 58615 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 58645 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 58675 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 58705 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 58735 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 58765 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 58795 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 58825 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 58855 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 58885 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 58915 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 58945 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 58975 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59005 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59035 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 59065 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 59085 | hbus monitor | Collected WRITE addr=0x103f data=0xa5 |
| 59115 | hbus monitor | Collected READ  addr=0x103f data=0x00 |
| 59145 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59175 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59205 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59235 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59265 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59295 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59325 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59355 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59385 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59415 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59445 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 59475 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 59505 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 59535 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 59565 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 59595 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 59615 | hbus monitor | Collected WRITE addr=0x1040 data=0xfb |
| 59645 | hbus monitor | Collected READ  addr=0x1040 data=0x00 |
| 59675 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 59705 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 59735 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 59765 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 59795 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 59825 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 59855 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 59885 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 59915 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 59945 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 59975 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60005 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60035 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 60065 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 60095 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60125 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60145 | hbus monitor | Collected WRITE addr=0x1041 data=0x15 |
| 60175 | hbus monitor | Collected READ  addr=0x1041 data=0x00 |
| 60205 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60235 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60265 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60295 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60325 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60355 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60385 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60415 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60445 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 60475 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 60505 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 60535 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 60565 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 60595 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 60625 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 60655 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 60675 | hbus monitor | Collected WRITE addr=0x1042 data=0xf7 |
| 60705 | hbus monitor | Collected READ  addr=0x1042 data=0x00 |
| 60735 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 60765 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 60795 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 60825 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 60855 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 60885 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 60915 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 60945 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 60975 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61005 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61035 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 61065 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 61095 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61125 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61155 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61185 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61205 | hbus monitor | Collected WRITE addr=0x1043 data=0x3b |
| 61235 | hbus monitor | Collected READ  addr=0x1043 data=0x00 |
| 61265 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61295 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61325 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61355 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61385 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61415 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61445 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 61475 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 61505 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 61535 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 61565 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 61595 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 61625 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 61655 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 61685 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 61715 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 61735 | hbus monitor | Collected WRITE addr=0x1044 data=0x4a |
| 61765 | hbus monitor | Collected READ  addr=0x1044 data=0x00 |
| 61795 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 61825 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 61855 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 61885 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 61915 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 61945 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 61975 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62005 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62035 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 62065 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 62095 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62125 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62155 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62185 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62215 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62245 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62265 | hbus monitor | Collected WRITE addr=0x1045 data=0x8e |
| 62295 | hbus monitor | Collected READ  addr=0x1045 data=0x00 |
| 62325 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62355 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62385 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62415 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62445 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 62475 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 62505 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 62535 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 62565 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 62595 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 62625 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 62655 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 62685 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 62715 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 62745 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 62775 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 62795 | hbus monitor | Collected WRITE addr=0x1046 data=0xc9 |
| 62825 | hbus monitor | Collected READ  addr=0x1046 data=0x00 |
| 62855 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 62885 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 62915 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 62945 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 62975 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63005 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63035 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 63065 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 63095 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63125 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63155 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63185 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63215 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63245 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63275 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63305 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63325 | hbus monitor | Collected WRITE addr=0x1047 data=0x58 |
| 63355 | hbus monitor | Collected READ  addr=0x1047 data=0x00 |
| 63385 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63415 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63445 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 63475 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 63505 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 63535 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 63565 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 63595 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 63625 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 63655 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 63685 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 63715 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 63745 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 63775 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 63805 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 63835 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 63855 | hbus monitor | Collected WRITE addr=0x1048 data=0xde |
| 63885 | hbus monitor | Collected READ  addr=0x1048 data=0x00 |
| 63915 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 63945 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 63975 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64005 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64035 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 64065 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 64095 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64125 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64155 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64185 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64215 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64245 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64275 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64305 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64335 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64365 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64385 | hbus monitor | Collected WRITE addr=0x1049 data=0x1d |
| 64415 | hbus monitor | Collected READ  addr=0x1049 data=0x00 |
| 64445 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 64475 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 64505 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 64535 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 64565 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 64595 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 64625 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 64655 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 64685 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 64715 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 64745 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 64775 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 64805 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 64835 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 64865 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 64895 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 64915 | hbus monitor | Collected WRITE addr=0x104a data=0x0a |
| 64945 | hbus monitor | Collected READ  addr=0x104a data=0x00 |
| 64975 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65005 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65035 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 65065 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 65095 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65125 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65155 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65185 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65215 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65245 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65275 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65305 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65335 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65365 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65395 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65425 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65445 | hbus monitor | Collected WRITE addr=0x104b data=0xe1 |
| 65475 | hbus monitor | Collected READ  addr=0x104b data=0x00 |
| 65505 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 65535 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 65565 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 65595 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 65625 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 65655 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 65685 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 65715 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 65745 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 65775 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 65805 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 65835 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 65865 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 65895 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 65925 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 65955 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 65975 | hbus monitor | Collected WRITE addr=0x104c data=0xe6 |
| 66005 | hbus monitor | Collected READ  addr=0x104c data=0x00 |
| 66035 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 66065 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 66095 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66125 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66155 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66215 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66245 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66275 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66305 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66335 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66365 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66395 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66425 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66455 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 66485 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 66505 | hbus monitor | Collected WRITE addr=0x104d data=0xfd |
| 66535 | hbus monitor | Collected READ  addr=0x104d data=0x00 |
| 66565 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 66595 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 66625 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 66655 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 66685 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 66715 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 66745 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 66775 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 66805 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 66835 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 66865 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 66895 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 66925 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 66955 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 66985 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67015 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67035 | hbus monitor | Collected WRITE addr=0x104e data=0xdf |
| 67065 | hbus monitor | Collected READ  addr=0x104e data=0x00 |
| 67095 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67125 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67155 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67185 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67215 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67245 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67275 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67305 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67335 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67365 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67395 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67425 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67455 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 67485 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 67515 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 67545 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 67565 | hbus monitor | Collected WRITE addr=0x104f data=0x9f |
| 67595 | hbus monitor | Collected READ  addr=0x104f data=0x00 |
| 67625 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 67655 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 67685 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 67715 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 67745 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 67775 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 67805 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 67835 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 67865 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 67895 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 67925 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 67955 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 67985 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68015 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 68045 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 68070 | **test** | STAGE: 5. the unmapped range 0x1050..0x10ff: the edges and 6 addresses in between, write and read 0 |
| 68075 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 68095 | hbus monitor | Collected WRITE addr=0x1050 data=0xff |
| 68125 | hbus monitor | Collected READ  addr=0x1050 data=0x00 |
| 68155 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68185 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68215 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68245 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68275 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68305 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68335 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68365 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68395 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68425 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68455 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 68485 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 68515 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 68545 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 68575 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 68605 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 68625 | hbus monitor | Collected WRITE addr=0x10ff data=0xff |
| 68655 | hbus monitor | Collected READ  addr=0x10ff data=0x00 |
| 68685 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 68715 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 68745 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 68775 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 68805 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 68835 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 68865 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 68895 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 68925 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 68955 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 68985 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69015 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 69045 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 69075 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69105 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69135 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69155 | hbus monitor | Collected WRITE addr=0x10e1 data=0xef |
| 69185 | hbus monitor | Collected READ  addr=0x10e1 data=0x00 |
| 69215 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69245 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69275 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69305 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69335 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69365 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69395 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69425 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69455 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 69485 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 69515 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 69545 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 69575 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 69605 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 69635 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 69665 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 69685 | hbus monitor | Collected WRITE addr=0x1077 data=0xf7 |
| 69715 | hbus monitor | Collected READ  addr=0x1077 data=0x00 |
| 69745 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 69775 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 69805 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 69835 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 69865 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 69895 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 69925 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 69955 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 69985 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70015 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 70045 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 70075 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70105 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70135 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70165 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70195 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70215 | hbus monitor | Collected WRITE addr=0x10a8 data=0x85 |
| 70245 | hbus monitor | Collected READ  addr=0x10a8 data=0x00 |
| 70275 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70305 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70335 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70365 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70395 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70425 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70455 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 70485 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 70515 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 70545 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 70575 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 70605 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 70635 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 70665 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 70695 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 70725 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 70745 | hbus monitor | Collected WRITE addr=0x10a5 data=0x08 |
| 70775 | hbus monitor | Collected READ  addr=0x10a5 data=0x00 |
| 70805 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 70835 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 70865 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 70895 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 70925 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 70955 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 70985 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71015 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 71045 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 71075 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71105 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71135 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71165 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71195 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71225 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71255 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71275 | hbus monitor | Collected WRITE addr=0x10ee data=0x19 |
| 71305 | hbus monitor | Collected READ  addr=0x10ee data=0x00 |
| 71335 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71365 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71395 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71425 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71455 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 71485 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 71515 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 71545 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 71575 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 71605 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 71635 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 71665 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 71695 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 71725 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 71755 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 71785 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 71805 | hbus monitor | Collected WRITE addr=0x10a6 data=0x64 |
| 71835 | hbus monitor | Collected READ  addr=0x10a6 data=0x00 |
| 71865 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 71895 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 71925 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 71955 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 71985 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 72015 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 72045 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 72075 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 72105 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 72135 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 72165 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 72195 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 72225 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 72255 | hbus monitor | Collected READ  addr=0x100d data=0x14 |
| 72285 | hbus monitor | Collected READ  addr=0x100e data=0x00 |
| 72310 | **test** | STAGE: 6. yapp_mem: every byte written and read back with 0x00, 0xff, 0x55, 0xaa and a random value |
| 72315 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 72335 | hbus monitor | Collected WRITE addr=0x1100 data=0x00 |
| 72365 | hbus monitor | Collected READ  addr=0x1100 data=0x00 |
| 72385 | hbus monitor | Collected WRITE addr=0x1101 data=0x00 |
| 72415 | hbus monitor | Collected READ  addr=0x1101 data=0x00 |
| 72435 | hbus monitor | Collected WRITE addr=0x1102 data=0x00 |
| 72465 | hbus monitor | Collected READ  addr=0x1102 data=0x00 |
| 72485 | hbus monitor | Collected WRITE addr=0x1103 data=0x00 |
| 72515 | hbus monitor | Collected READ  addr=0x1103 data=0x00 |
| 72535 | hbus monitor | Collected WRITE addr=0x1104 data=0x00 |
| 72565 | hbus monitor | Collected READ  addr=0x1104 data=0x00 |
| 72585 | hbus monitor | Collected WRITE addr=0x1105 data=0x00 |
| 72615 | hbus monitor | Collected READ  addr=0x1105 data=0x00 |
| 72635 | hbus monitor | Collected WRITE addr=0x1106 data=0x00 |
| 72665 | hbus monitor | Collected READ  addr=0x1106 data=0x00 |
| 72685 | hbus monitor | Collected WRITE addr=0x1107 data=0x00 |
| 72715 | hbus monitor | Collected READ  addr=0x1107 data=0x00 |
| 72735 | hbus monitor | Collected WRITE addr=0x1108 data=0x00 |
| 72765 | hbus monitor | Collected READ  addr=0x1108 data=0x00 |
| 72785 | hbus monitor | Collected WRITE addr=0x1109 data=0x00 |
| 72815 | hbus monitor | Collected READ  addr=0x1109 data=0x00 |
| 72835 | hbus monitor | Collected WRITE addr=0x110a data=0x00 |
| 72865 | hbus monitor | Collected READ  addr=0x110a data=0x00 |
| 72885 | hbus monitor | Collected WRITE addr=0x110b data=0x00 |
| 72915 | hbus monitor | Collected READ  addr=0x110b data=0x00 |
| 72935 | hbus monitor | Collected WRITE addr=0x110c data=0x00 |
| 72965 | hbus monitor | Collected READ  addr=0x110c data=0x00 |
| 72985 | hbus monitor | Collected WRITE addr=0x110d data=0x00 |
| 73015 | hbus monitor | Collected READ  addr=0x110d data=0x00 |
| 73035 | hbus monitor | Collected WRITE addr=0x110e data=0x00 |
| 73065 | hbus monitor | Collected READ  addr=0x110e data=0x00 |
| 73085 | hbus monitor | Collected WRITE addr=0x110f data=0x00 |
| 73115 | hbus monitor | Collected READ  addr=0x110f data=0x00 |
| 73135 | hbus monitor | Collected WRITE addr=0x1110 data=0x00 |
| 73165 | hbus monitor | Collected READ  addr=0x1110 data=0x00 |
| 73185 | hbus monitor | Collected WRITE addr=0x1111 data=0x00 |
| 73215 | hbus monitor | Collected READ  addr=0x1111 data=0x00 |
| 73235 | hbus monitor | Collected WRITE addr=0x1112 data=0x00 |
| 73265 | hbus monitor | Collected READ  addr=0x1112 data=0x00 |
| 73285 | hbus monitor | Collected WRITE addr=0x1113 data=0x00 |
| 73315 | hbus monitor | Collected READ  addr=0x1113 data=0x00 |
| 73335 | hbus monitor | Collected WRITE addr=0x1114 data=0x00 |
| 73365 | hbus monitor | Collected READ  addr=0x1114 data=0x00 |
| 73385 | hbus monitor | Collected WRITE addr=0x1115 data=0x00 |
| 73415 | hbus monitor | Collected READ  addr=0x1115 data=0x00 |
| 73435 | hbus monitor | Collected WRITE addr=0x1116 data=0x00 |
| 73465 | hbus monitor | Collected READ  addr=0x1116 data=0x00 |
| 73485 | hbus monitor | Collected WRITE addr=0x1117 data=0x00 |
| 73515 | hbus monitor | Collected READ  addr=0x1117 data=0x00 |
| 73535 | hbus monitor | Collected WRITE addr=0x1118 data=0x00 |
| 73565 | hbus monitor | Collected READ  addr=0x1118 data=0x00 |
| 73585 | hbus monitor | Collected WRITE addr=0x1119 data=0x00 |
| 73615 | hbus monitor | Collected READ  addr=0x1119 data=0x00 |
| 73635 | hbus monitor | Collected WRITE addr=0x111a data=0x00 |
| 73665 | hbus monitor | Collected READ  addr=0x111a data=0x00 |
| 73685 | hbus monitor | Collected WRITE addr=0x111b data=0x00 |
| 73715 | hbus monitor | Collected READ  addr=0x111b data=0x00 |
| 73735 | hbus monitor | Collected WRITE addr=0x111c data=0x00 |
| 73765 | hbus monitor | Collected READ  addr=0x111c data=0x00 |
| 73785 | hbus monitor | Collected WRITE addr=0x111d data=0x00 |
| 73815 | hbus monitor | Collected READ  addr=0x111d data=0x00 |
| 73835 | hbus monitor | Collected WRITE addr=0x111e data=0x00 |
| 73865 | hbus monitor | Collected READ  addr=0x111e data=0x00 |
| 73885 | hbus monitor | Collected WRITE addr=0x111f data=0x00 |
| 73915 | hbus monitor | Collected READ  addr=0x111f data=0x00 |
| 73935 | hbus monitor | Collected WRITE addr=0x1120 data=0x00 |
| 73965 | hbus monitor | Collected READ  addr=0x1120 data=0x00 |
| 73985 | hbus monitor | Collected WRITE addr=0x1121 data=0x00 |
| 74015 | hbus monitor | Collected READ  addr=0x1121 data=0x00 |
| 74035 | hbus monitor | Collected WRITE addr=0x1122 data=0x00 |
| 74065 | hbus monitor | Collected READ  addr=0x1122 data=0x00 |
| 74085 | hbus monitor | Collected WRITE addr=0x1123 data=0x00 |
| 74115 | hbus monitor | Collected READ  addr=0x1123 data=0x00 |
| 74135 | hbus monitor | Collected WRITE addr=0x1124 data=0x00 |
| 74165 | hbus monitor | Collected READ  addr=0x1124 data=0x00 |
| 74185 | hbus monitor | Collected WRITE addr=0x1125 data=0x00 |
| 74215 | hbus monitor | Collected READ  addr=0x1125 data=0x00 |
| 74235 | hbus monitor | Collected WRITE addr=0x1126 data=0x00 |
| 74265 | hbus monitor | Collected READ  addr=0x1126 data=0x00 |
| 74285 | hbus monitor | Collected WRITE addr=0x1127 data=0x00 |
| 74315 | hbus monitor | Collected READ  addr=0x1127 data=0x00 |
| 74335 | hbus monitor | Collected WRITE addr=0x1128 data=0x00 |
| 74365 | hbus monitor | Collected READ  addr=0x1128 data=0x00 |
| 74385 | hbus monitor | Collected WRITE addr=0x1129 data=0x00 |
| 74415 | hbus monitor | Collected READ  addr=0x1129 data=0x00 |
| 74435 | hbus monitor | Collected WRITE addr=0x112a data=0x00 |
| 74465 | hbus monitor | Collected READ  addr=0x112a data=0x00 |
| 74485 | hbus monitor | Collected WRITE addr=0x112b data=0x00 |
| 74515 | hbus monitor | Collected READ  addr=0x112b data=0x00 |
| 74535 | hbus monitor | Collected WRITE addr=0x112c data=0x00 |
| 74565 | hbus monitor | Collected READ  addr=0x112c data=0x00 |
| 74585 | hbus monitor | Collected WRITE addr=0x112d data=0x00 |
| 74615 | hbus monitor | Collected READ  addr=0x112d data=0x00 |
| 74635 | hbus monitor | Collected WRITE addr=0x112e data=0x00 |
| 74665 | hbus monitor | Collected READ  addr=0x112e data=0x00 |
| 74685 | hbus monitor | Collected WRITE addr=0x112f data=0x00 |
| 74715 | hbus monitor | Collected READ  addr=0x112f data=0x00 |
| 74735 | hbus monitor | Collected WRITE addr=0x1130 data=0x00 |
| 74765 | hbus monitor | Collected READ  addr=0x1130 data=0x00 |
| 74785 | hbus monitor | Collected WRITE addr=0x1131 data=0x00 |
| 74815 | hbus monitor | Collected READ  addr=0x1131 data=0x00 |
| 74835 | hbus monitor | Collected WRITE addr=0x1132 data=0x00 |
| 74865 | hbus monitor | Collected READ  addr=0x1132 data=0x00 |
| 74885 | hbus monitor | Collected WRITE addr=0x1133 data=0x00 |
| 74915 | hbus monitor | Collected READ  addr=0x1133 data=0x00 |
| 74935 | hbus monitor | Collected WRITE addr=0x1134 data=0x00 |
| 74965 | hbus monitor | Collected READ  addr=0x1134 data=0x00 |
| 74985 | hbus monitor | Collected WRITE addr=0x1135 data=0x00 |
| 75015 | hbus monitor | Collected READ  addr=0x1135 data=0x00 |
| 75035 | hbus monitor | Collected WRITE addr=0x1136 data=0x00 |
| 75065 | hbus monitor | Collected READ  addr=0x1136 data=0x00 |
| 75085 | hbus monitor | Collected WRITE addr=0x1137 data=0x00 |
| 75115 | hbus monitor | Collected READ  addr=0x1137 data=0x00 |
| 75135 | hbus monitor | Collected WRITE addr=0x1138 data=0x00 |
| 75165 | hbus monitor | Collected READ  addr=0x1138 data=0x00 |
| 75185 | hbus monitor | Collected WRITE addr=0x1139 data=0x00 |
| 75215 | hbus monitor | Collected READ  addr=0x1139 data=0x00 |
| 75235 | hbus monitor | Collected WRITE addr=0x113a data=0x00 |
| 75265 | hbus monitor | Collected READ  addr=0x113a data=0x00 |
| 75285 | hbus monitor | Collected WRITE addr=0x113b data=0x00 |
| 75315 | hbus monitor | Collected READ  addr=0x113b data=0x00 |
| 75335 | hbus monitor | Collected WRITE addr=0x113c data=0x00 |
| 75365 | hbus monitor | Collected READ  addr=0x113c data=0x00 |
| 75385 | hbus monitor | Collected WRITE addr=0x113d data=0x00 |
| 75415 | hbus monitor | Collected READ  addr=0x113d data=0x00 |
| 75435 | hbus monitor | Collected WRITE addr=0x113e data=0x00 |
| 75465 | hbus monitor | Collected READ  addr=0x113e data=0x00 |
| 75485 | hbus monitor | Collected WRITE addr=0x113f data=0x00 |
| 75515 | hbus monitor | Collected READ  addr=0x113f data=0x00 |
| 75535 | hbus monitor | Collected WRITE addr=0x1140 data=0x00 |
| 75565 | hbus monitor | Collected READ  addr=0x1140 data=0x00 |
| 75585 | hbus monitor | Collected WRITE addr=0x1141 data=0x00 |
| 75615 | hbus monitor | Collected READ  addr=0x1141 data=0x00 |
| 75635 | hbus monitor | Collected WRITE addr=0x1142 data=0x00 |
| 75665 | hbus monitor | Collected READ  addr=0x1142 data=0x00 |
| 75685 | hbus monitor | Collected WRITE addr=0x1143 data=0x00 |
| 75715 | hbus monitor | Collected READ  addr=0x1143 data=0x00 |
| 75735 | hbus monitor | Collected WRITE addr=0x1144 data=0x00 |
| 75765 | hbus monitor | Collected READ  addr=0x1144 data=0x00 |
| 75785 | hbus monitor | Collected WRITE addr=0x1145 data=0x00 |
| 75815 | hbus monitor | Collected READ  addr=0x1145 data=0x00 |
| 75835 | hbus monitor | Collected WRITE addr=0x1146 data=0x00 |
| 75865 | hbus monitor | Collected READ  addr=0x1146 data=0x00 |
| 75885 | hbus monitor | Collected WRITE addr=0x1147 data=0x00 |
| 75915 | hbus monitor | Collected READ  addr=0x1147 data=0x00 |
| 75935 | hbus monitor | Collected WRITE addr=0x1148 data=0x00 |
| 75965 | hbus monitor | Collected READ  addr=0x1148 data=0x00 |
| 75985 | hbus monitor | Collected WRITE addr=0x1149 data=0x00 |
| 76015 | hbus monitor | Collected READ  addr=0x1149 data=0x00 |
| 76035 | hbus monitor | Collected WRITE addr=0x114a data=0x00 |
| 76065 | hbus monitor | Collected READ  addr=0x114a data=0x00 |
| 76085 | hbus monitor | Collected WRITE addr=0x114b data=0x00 |
| 76115 | hbus monitor | Collected READ  addr=0x114b data=0x00 |
| 76135 | hbus monitor | Collected WRITE addr=0x114c data=0x00 |
| 76165 | hbus monitor | Collected READ  addr=0x114c data=0x00 |
| 76185 | hbus monitor | Collected WRITE addr=0x114d data=0x00 |
| 76215 | hbus monitor | Collected READ  addr=0x114d data=0x00 |
| 76235 | hbus monitor | Collected WRITE addr=0x114e data=0x00 |
| 76265 | hbus monitor | Collected READ  addr=0x114e data=0x00 |
| 76285 | hbus monitor | Collected WRITE addr=0x114f data=0x00 |
| 76315 | hbus monitor | Collected READ  addr=0x114f data=0x00 |
| 76335 | hbus monitor | Collected WRITE addr=0x1150 data=0x00 |
| 76365 | hbus monitor | Collected READ  addr=0x1150 data=0x00 |
| 76385 | hbus monitor | Collected WRITE addr=0x1151 data=0x00 |
| 76415 | hbus monitor | Collected READ  addr=0x1151 data=0x00 |
| 76435 | hbus monitor | Collected WRITE addr=0x1152 data=0x00 |
| 76465 | hbus monitor | Collected READ  addr=0x1152 data=0x00 |
| 76485 | hbus monitor | Collected WRITE addr=0x1153 data=0x00 |
| 76515 | hbus monitor | Collected READ  addr=0x1153 data=0x00 |
| 76535 | hbus monitor | Collected WRITE addr=0x1154 data=0x00 |
| 76565 | hbus monitor | Collected READ  addr=0x1154 data=0x00 |
| 76585 | hbus monitor | Collected WRITE addr=0x1155 data=0x00 |
| 76615 | hbus monitor | Collected READ  addr=0x1155 data=0x00 |
| 76635 | hbus monitor | Collected WRITE addr=0x1156 data=0x00 |
| 76665 | hbus monitor | Collected READ  addr=0x1156 data=0x00 |
| 76685 | hbus monitor | Collected WRITE addr=0x1157 data=0x00 |
| 76715 | hbus monitor | Collected READ  addr=0x1157 data=0x00 |
| 76735 | hbus monitor | Collected WRITE addr=0x1158 data=0x00 |
| 76765 | hbus monitor | Collected READ  addr=0x1158 data=0x00 |
| 76785 | hbus monitor | Collected WRITE addr=0x1159 data=0x00 |
| 76815 | hbus monitor | Collected READ  addr=0x1159 data=0x00 |
| 76835 | hbus monitor | Collected WRITE addr=0x115a data=0x00 |
| 76865 | hbus monitor | Collected READ  addr=0x115a data=0x00 |
| 76885 | hbus monitor | Collected WRITE addr=0x115b data=0x00 |
| 76915 | hbus monitor | Collected READ  addr=0x115b data=0x00 |
| 76935 | hbus monitor | Collected WRITE addr=0x115c data=0x00 |
| 76965 | hbus monitor | Collected READ  addr=0x115c data=0x00 |
| 76985 | hbus monitor | Collected WRITE addr=0x115d data=0x00 |
| 77015 | hbus monitor | Collected READ  addr=0x115d data=0x00 |
| 77035 | hbus monitor | Collected WRITE addr=0x115e data=0x00 |
| 77065 | hbus monitor | Collected READ  addr=0x115e data=0x00 |
| 77085 | hbus monitor | Collected WRITE addr=0x115f data=0x00 |
| 77115 | hbus monitor | Collected READ  addr=0x115f data=0x00 |
| 77135 | hbus monitor | Collected WRITE addr=0x1160 data=0x00 |
| 77165 | hbus monitor | Collected READ  addr=0x1160 data=0x00 |
| 77185 | hbus monitor | Collected WRITE addr=0x1161 data=0x00 |
| 77215 | hbus monitor | Collected READ  addr=0x1161 data=0x00 |
| 77235 | hbus monitor | Collected WRITE addr=0x1162 data=0x00 |
| 77265 | hbus monitor | Collected READ  addr=0x1162 data=0x00 |
| 77285 | hbus monitor | Collected WRITE addr=0x1163 data=0x00 |
| 77315 | hbus monitor | Collected READ  addr=0x1163 data=0x00 |
| 77335 | hbus monitor | Collected WRITE addr=0x1164 data=0x00 |
| 77365 | hbus monitor | Collected READ  addr=0x1164 data=0x00 |
| 77385 | hbus monitor | Collected WRITE addr=0x1165 data=0x00 |
| 77415 | hbus monitor | Collected READ  addr=0x1165 data=0x00 |
| 77435 | hbus monitor | Collected WRITE addr=0x1166 data=0x00 |
| 77465 | hbus monitor | Collected READ  addr=0x1166 data=0x00 |
| 77485 | hbus monitor | Collected WRITE addr=0x1167 data=0x00 |
| 77515 | hbus monitor | Collected READ  addr=0x1167 data=0x00 |
| 77535 | hbus monitor | Collected WRITE addr=0x1168 data=0x00 |
| 77565 | hbus monitor | Collected READ  addr=0x1168 data=0x00 |
| 77585 | hbus monitor | Collected WRITE addr=0x1169 data=0x00 |
| 77615 | hbus monitor | Collected READ  addr=0x1169 data=0x00 |
| 77635 | hbus monitor | Collected WRITE addr=0x116a data=0x00 |
| 77665 | hbus monitor | Collected READ  addr=0x116a data=0x00 |
| 77685 | hbus monitor | Collected WRITE addr=0x116b data=0x00 |
| 77715 | hbus monitor | Collected READ  addr=0x116b data=0x00 |
| 77735 | hbus monitor | Collected WRITE addr=0x116c data=0x00 |
| 77765 | hbus monitor | Collected READ  addr=0x116c data=0x00 |
| 77785 | hbus monitor | Collected WRITE addr=0x116d data=0x00 |
| 77815 | hbus monitor | Collected READ  addr=0x116d data=0x00 |
| 77835 | hbus monitor | Collected WRITE addr=0x116e data=0x00 |
| 77865 | hbus monitor | Collected READ  addr=0x116e data=0x00 |
| 77885 | hbus monitor | Collected WRITE addr=0x116f data=0x00 |
| 77915 | hbus monitor | Collected READ  addr=0x116f data=0x00 |
| 77935 | hbus monitor | Collected WRITE addr=0x1170 data=0x00 |
| 77965 | hbus monitor | Collected READ  addr=0x1170 data=0x00 |
| 77985 | hbus monitor | Collected WRITE addr=0x1171 data=0x00 |
| 78015 | hbus monitor | Collected READ  addr=0x1171 data=0x00 |
| 78035 | hbus monitor | Collected WRITE addr=0x1172 data=0x00 |
| 78065 | hbus monitor | Collected READ  addr=0x1172 data=0x00 |
| 78085 | hbus monitor | Collected WRITE addr=0x1173 data=0x00 |
| 78115 | hbus monitor | Collected READ  addr=0x1173 data=0x00 |
| 78135 | hbus monitor | Collected WRITE addr=0x1174 data=0x00 |
| 78165 | hbus monitor | Collected READ  addr=0x1174 data=0x00 |
| 78185 | hbus monitor | Collected WRITE addr=0x1175 data=0x00 |
| 78215 | hbus monitor | Collected READ  addr=0x1175 data=0x00 |
| 78235 | hbus monitor | Collected WRITE addr=0x1176 data=0x00 |
| 78265 | hbus monitor | Collected READ  addr=0x1176 data=0x00 |
| 78285 | hbus monitor | Collected WRITE addr=0x1177 data=0x00 |
| 78315 | hbus monitor | Collected READ  addr=0x1177 data=0x00 |
| 78335 | hbus monitor | Collected WRITE addr=0x1178 data=0x00 |
| 78365 | hbus monitor | Collected READ  addr=0x1178 data=0x00 |
| 78385 | hbus monitor | Collected WRITE addr=0x1179 data=0x00 |
| 78415 | hbus monitor | Collected READ  addr=0x1179 data=0x00 |
| 78435 | hbus monitor | Collected WRITE addr=0x117a data=0x00 |
| 78465 | hbus monitor | Collected READ  addr=0x117a data=0x00 |
| 78485 | hbus monitor | Collected WRITE addr=0x117b data=0x00 |
| 78515 | hbus monitor | Collected READ  addr=0x117b data=0x00 |
| 78535 | hbus monitor | Collected WRITE addr=0x117c data=0x00 |
| 78565 | hbus monitor | Collected READ  addr=0x117c data=0x00 |
| 78585 | hbus monitor | Collected WRITE addr=0x117d data=0x00 |
| 78615 | hbus monitor | Collected READ  addr=0x117d data=0x00 |
| 78635 | hbus monitor | Collected WRITE addr=0x117e data=0x00 |
| 78665 | hbus monitor | Collected READ  addr=0x117e data=0x00 |
| 78685 | hbus monitor | Collected WRITE addr=0x117f data=0x00 |
| 78715 | hbus monitor | Collected READ  addr=0x117f data=0x00 |
| 78735 | hbus monitor | Collected WRITE addr=0x1180 data=0x00 |
| 78765 | hbus monitor | Collected READ  addr=0x1180 data=0x00 |
| 78785 | hbus monitor | Collected WRITE addr=0x1181 data=0x00 |
| 78815 | hbus monitor | Collected READ  addr=0x1181 data=0x00 |
| 78835 | hbus monitor | Collected WRITE addr=0x1182 data=0x00 |
| 78865 | hbus monitor | Collected READ  addr=0x1182 data=0x00 |
| 78885 | hbus monitor | Collected WRITE addr=0x1183 data=0x00 |
| 78915 | hbus monitor | Collected READ  addr=0x1183 data=0x00 |
| 78935 | hbus monitor | Collected WRITE addr=0x1184 data=0x00 |
| 78965 | hbus monitor | Collected READ  addr=0x1184 data=0x00 |
| 78985 | hbus monitor | Collected WRITE addr=0x1185 data=0x00 |
| 79015 | hbus monitor | Collected READ  addr=0x1185 data=0x00 |
| 79035 | hbus monitor | Collected WRITE addr=0x1186 data=0x00 |
| 79065 | hbus monitor | Collected READ  addr=0x1186 data=0x00 |
| 79085 | hbus monitor | Collected WRITE addr=0x1187 data=0x00 |
| 79115 | hbus monitor | Collected READ  addr=0x1187 data=0x00 |
| 79135 | hbus monitor | Collected WRITE addr=0x1188 data=0x00 |
| 79165 | hbus monitor | Collected READ  addr=0x1188 data=0x00 |
| 79185 | hbus monitor | Collected WRITE addr=0x1189 data=0x00 |
| 79215 | hbus monitor | Collected READ  addr=0x1189 data=0x00 |
| 79235 | hbus monitor | Collected WRITE addr=0x118a data=0x00 |
| 79265 | hbus monitor | Collected READ  addr=0x118a data=0x00 |
| 79285 | hbus monitor | Collected WRITE addr=0x118b data=0x00 |
| 79315 | hbus monitor | Collected READ  addr=0x118b data=0x00 |
| 79335 | hbus monitor | Collected WRITE addr=0x118c data=0x00 |
| 79365 | hbus monitor | Collected READ  addr=0x118c data=0x00 |
| 79385 | hbus monitor | Collected WRITE addr=0x118d data=0x00 |
| 79415 | hbus monitor | Collected READ  addr=0x118d data=0x00 |
| 79435 | hbus monitor | Collected WRITE addr=0x118e data=0x00 |
| 79465 | hbus monitor | Collected READ  addr=0x118e data=0x00 |
| 79485 | hbus monitor | Collected WRITE addr=0x118f data=0x00 |
| 79515 | hbus monitor | Collected READ  addr=0x118f data=0x00 |
| 79535 | hbus monitor | Collected WRITE addr=0x1190 data=0x00 |
| 79565 | hbus monitor | Collected READ  addr=0x1190 data=0x00 |
| 79585 | hbus monitor | Collected WRITE addr=0x1191 data=0x00 |
| 79615 | hbus monitor | Collected READ  addr=0x1191 data=0x00 |
| 79635 | hbus monitor | Collected WRITE addr=0x1192 data=0x00 |
| 79665 | hbus monitor | Collected READ  addr=0x1192 data=0x00 |
| 79685 | hbus monitor | Collected WRITE addr=0x1193 data=0x00 |
| 79715 | hbus monitor | Collected READ  addr=0x1193 data=0x00 |
| 79735 | hbus monitor | Collected WRITE addr=0x1194 data=0x00 |
| 79765 | hbus monitor | Collected READ  addr=0x1194 data=0x00 |
| 79785 | hbus monitor | Collected WRITE addr=0x1195 data=0x00 |
| 79815 | hbus monitor | Collected READ  addr=0x1195 data=0x00 |
| 79835 | hbus monitor | Collected WRITE addr=0x1196 data=0x00 |
| 79865 | hbus monitor | Collected READ  addr=0x1196 data=0x00 |
| 79885 | hbus monitor | Collected WRITE addr=0x1197 data=0x00 |
| 79915 | hbus monitor | Collected READ  addr=0x1197 data=0x00 |
| 79935 | hbus monitor | Collected WRITE addr=0x1198 data=0x00 |
| 79965 | hbus monitor | Collected READ  addr=0x1198 data=0x00 |
| 79985 | hbus monitor | Collected WRITE addr=0x1199 data=0x00 |
| 80015 | hbus monitor | Collected READ  addr=0x1199 data=0x00 |
| 80035 | hbus monitor | Collected WRITE addr=0x119a data=0x00 |
| 80065 | hbus monitor | Collected READ  addr=0x119a data=0x00 |
| 80085 | hbus monitor | Collected WRITE addr=0x119b data=0x00 |
| 80115 | hbus monitor | Collected READ  addr=0x119b data=0x00 |
| 80135 | hbus monitor | Collected WRITE addr=0x119c data=0x00 |
| 80165 | hbus monitor | Collected READ  addr=0x119c data=0x00 |
| 80185 | hbus monitor | Collected WRITE addr=0x119d data=0x00 |
| 80215 | hbus monitor | Collected READ  addr=0x119d data=0x00 |
| 80235 | hbus monitor | Collected WRITE addr=0x119e data=0x00 |
| 80265 | hbus monitor | Collected READ  addr=0x119e data=0x00 |
| 80285 | hbus monitor | Collected WRITE addr=0x119f data=0x00 |
| 80315 | hbus monitor | Collected READ  addr=0x119f data=0x00 |
| 80335 | hbus monitor | Collected WRITE addr=0x11a0 data=0x00 |
| 80365 | hbus monitor | Collected READ  addr=0x11a0 data=0x00 |
| 80385 | hbus monitor | Collected WRITE addr=0x11a1 data=0x00 |
| 80415 | hbus monitor | Collected READ  addr=0x11a1 data=0x00 |
| 80435 | hbus monitor | Collected WRITE addr=0x11a2 data=0x00 |
| 80465 | hbus monitor | Collected READ  addr=0x11a2 data=0x00 |
| 80485 | hbus monitor | Collected WRITE addr=0x11a3 data=0x00 |
| 80515 | hbus monitor | Collected READ  addr=0x11a3 data=0x00 |
| 80535 | hbus monitor | Collected WRITE addr=0x11a4 data=0x00 |
| 80565 | hbus monitor | Collected READ  addr=0x11a4 data=0x00 |
| 80585 | hbus monitor | Collected WRITE addr=0x11a5 data=0x00 |
| 80615 | hbus monitor | Collected READ  addr=0x11a5 data=0x00 |
| 80635 | hbus monitor | Collected WRITE addr=0x11a6 data=0x00 |
| 80665 | hbus monitor | Collected READ  addr=0x11a6 data=0x00 |
| 80685 | hbus monitor | Collected WRITE addr=0x11a7 data=0x00 |
| 80715 | hbus monitor | Collected READ  addr=0x11a7 data=0x00 |
| 80735 | hbus monitor | Collected WRITE addr=0x11a8 data=0x00 |
| 80765 | hbus monitor | Collected READ  addr=0x11a8 data=0x00 |
| 80785 | hbus monitor | Collected WRITE addr=0x11a9 data=0x00 |
| 80815 | hbus monitor | Collected READ  addr=0x11a9 data=0x00 |
| 80835 | hbus monitor | Collected WRITE addr=0x11aa data=0x00 |
| 80865 | hbus monitor | Collected READ  addr=0x11aa data=0x00 |
| 80885 | hbus monitor | Collected WRITE addr=0x11ab data=0x00 |
| 80915 | hbus monitor | Collected READ  addr=0x11ab data=0x00 |
| 80935 | hbus monitor | Collected WRITE addr=0x11ac data=0x00 |
| 80965 | hbus monitor | Collected READ  addr=0x11ac data=0x00 |
| 80985 | hbus monitor | Collected WRITE addr=0x11ad data=0x00 |
| 81015 | hbus monitor | Collected READ  addr=0x11ad data=0x00 |
| 81035 | hbus monitor | Collected WRITE addr=0x11ae data=0x00 |
| 81065 | hbus monitor | Collected READ  addr=0x11ae data=0x00 |
| 81085 | hbus monitor | Collected WRITE addr=0x11af data=0x00 |
| 81115 | hbus monitor | Collected READ  addr=0x11af data=0x00 |
| 81135 | hbus monitor | Collected WRITE addr=0x11b0 data=0x00 |
| 81165 | hbus monitor | Collected READ  addr=0x11b0 data=0x00 |
| 81185 | hbus monitor | Collected WRITE addr=0x11b1 data=0x00 |
| 81215 | hbus monitor | Collected READ  addr=0x11b1 data=0x00 |
| 81235 | hbus monitor | Collected WRITE addr=0x11b2 data=0x00 |
| 81265 | hbus monitor | Collected READ  addr=0x11b2 data=0x00 |
| 81285 | hbus monitor | Collected WRITE addr=0x11b3 data=0x00 |
| 81315 | hbus monitor | Collected READ  addr=0x11b3 data=0x00 |
| 81335 | hbus monitor | Collected WRITE addr=0x11b4 data=0x00 |
| 81365 | hbus monitor | Collected READ  addr=0x11b4 data=0x00 |
| 81385 | hbus monitor | Collected WRITE addr=0x11b5 data=0x00 |
| 81415 | hbus monitor | Collected READ  addr=0x11b5 data=0x00 |
| 81435 | hbus monitor | Collected WRITE addr=0x11b6 data=0x00 |
| 81465 | hbus monitor | Collected READ  addr=0x11b6 data=0x00 |
| 81485 | hbus monitor | Collected WRITE addr=0x11b7 data=0x00 |
| 81515 | hbus monitor | Collected READ  addr=0x11b7 data=0x00 |
| 81535 | hbus monitor | Collected WRITE addr=0x11b8 data=0x00 |
| 81565 | hbus monitor | Collected READ  addr=0x11b8 data=0x00 |
| 81585 | hbus monitor | Collected WRITE addr=0x11b9 data=0x00 |
| 81615 | hbus monitor | Collected READ  addr=0x11b9 data=0x00 |
| 81635 | hbus monitor | Collected WRITE addr=0x11ba data=0x00 |
| 81665 | hbus monitor | Collected READ  addr=0x11ba data=0x00 |
| 81685 | hbus monitor | Collected WRITE addr=0x11bb data=0x00 |
| 81715 | hbus monitor | Collected READ  addr=0x11bb data=0x00 |
| 81735 | hbus monitor | Collected WRITE addr=0x11bc data=0x00 |
| 81765 | hbus monitor | Collected READ  addr=0x11bc data=0x00 |
| 81785 | hbus monitor | Collected WRITE addr=0x11bd data=0x00 |
| 81815 | hbus monitor | Collected READ  addr=0x11bd data=0x00 |
| 81835 | hbus monitor | Collected WRITE addr=0x11be data=0x00 |
| 81865 | hbus monitor | Collected READ  addr=0x11be data=0x00 |
| 81885 | hbus monitor | Collected WRITE addr=0x11bf data=0x00 |
| 81915 | hbus monitor | Collected READ  addr=0x11bf data=0x00 |
| 81935 | hbus monitor | Collected WRITE addr=0x11c0 data=0x00 |
| 81965 | hbus monitor | Collected READ  addr=0x11c0 data=0x00 |
| 81985 | hbus monitor | Collected WRITE addr=0x11c1 data=0x00 |
| 82015 | hbus monitor | Collected READ  addr=0x11c1 data=0x00 |
| 82035 | hbus monitor | Collected WRITE addr=0x11c2 data=0x00 |
| 82065 | hbus monitor | Collected READ  addr=0x11c2 data=0x00 |
| 82085 | hbus monitor | Collected WRITE addr=0x11c3 data=0x00 |
| 82115 | hbus monitor | Collected READ  addr=0x11c3 data=0x00 |
| 82135 | hbus monitor | Collected WRITE addr=0x11c4 data=0x00 |
| 82165 | hbus monitor | Collected READ  addr=0x11c4 data=0x00 |
| 82185 | hbus monitor | Collected WRITE addr=0x11c5 data=0x00 |
| 82215 | hbus monitor | Collected READ  addr=0x11c5 data=0x00 |
| 82235 | hbus monitor | Collected WRITE addr=0x11c6 data=0x00 |
| 82265 | hbus monitor | Collected READ  addr=0x11c6 data=0x00 |
| 82285 | hbus monitor | Collected WRITE addr=0x11c7 data=0x00 |
| 82315 | hbus monitor | Collected READ  addr=0x11c7 data=0x00 |
| 82335 | hbus monitor | Collected WRITE addr=0x11c8 data=0x00 |
| 82365 | hbus monitor | Collected READ  addr=0x11c8 data=0x00 |
| 82385 | hbus monitor | Collected WRITE addr=0x11c9 data=0x00 |
| 82415 | hbus monitor | Collected READ  addr=0x11c9 data=0x00 |
| 82435 | hbus monitor | Collected WRITE addr=0x11ca data=0x00 |
| 82465 | hbus monitor | Collected READ  addr=0x11ca data=0x00 |
| 82485 | hbus monitor | Collected WRITE addr=0x11cb data=0x00 |
| 82515 | hbus monitor | Collected READ  addr=0x11cb data=0x00 |
| 82535 | hbus monitor | Collected WRITE addr=0x11cc data=0x00 |
| 82565 | hbus monitor | Collected READ  addr=0x11cc data=0x00 |
| 82585 | hbus monitor | Collected WRITE addr=0x11cd data=0x00 |
| 82615 | hbus monitor | Collected READ  addr=0x11cd data=0x00 |
| 82635 | hbus monitor | Collected WRITE addr=0x11ce data=0x00 |
| 82665 | hbus monitor | Collected READ  addr=0x11ce data=0x00 |
| 82685 | hbus monitor | Collected WRITE addr=0x11cf data=0x00 |
| 82715 | hbus monitor | Collected READ  addr=0x11cf data=0x00 |
| 82735 | hbus monitor | Collected WRITE addr=0x11d0 data=0x00 |
| 82765 | hbus monitor | Collected READ  addr=0x11d0 data=0x00 |
| 82785 | hbus monitor | Collected WRITE addr=0x11d1 data=0x00 |
| 82815 | hbus monitor | Collected READ  addr=0x11d1 data=0x00 |
| 82835 | hbus monitor | Collected WRITE addr=0x11d2 data=0x00 |
| 82865 | hbus monitor | Collected READ  addr=0x11d2 data=0x00 |
| 82885 | hbus monitor | Collected WRITE addr=0x11d3 data=0x00 |
| 82915 | hbus monitor | Collected READ  addr=0x11d3 data=0x00 |
| 82935 | hbus monitor | Collected WRITE addr=0x11d4 data=0x00 |
| 82965 | hbus monitor | Collected READ  addr=0x11d4 data=0x00 |
| 82985 | hbus monitor | Collected WRITE addr=0x11d5 data=0x00 |
| 83015 | hbus monitor | Collected READ  addr=0x11d5 data=0x00 |
| 83035 | hbus monitor | Collected WRITE addr=0x11d6 data=0x00 |
| 83065 | hbus monitor | Collected READ  addr=0x11d6 data=0x00 |
| 83085 | hbus monitor | Collected WRITE addr=0x11d7 data=0x00 |
| 83115 | hbus monitor | Collected READ  addr=0x11d7 data=0x00 |
| 83135 | hbus monitor | Collected WRITE addr=0x11d8 data=0x00 |
| 83165 | hbus monitor | Collected READ  addr=0x11d8 data=0x00 |
| 83185 | hbus monitor | Collected WRITE addr=0x11d9 data=0x00 |
| 83215 | hbus monitor | Collected READ  addr=0x11d9 data=0x00 |
| 83235 | hbus monitor | Collected WRITE addr=0x11da data=0x00 |
| 83265 | hbus monitor | Collected READ  addr=0x11da data=0x00 |
| 83285 | hbus monitor | Collected WRITE addr=0x11db data=0x00 |
| 83315 | hbus monitor | Collected READ  addr=0x11db data=0x00 |
| 83335 | hbus monitor | Collected WRITE addr=0x11dc data=0x00 |
| 83365 | hbus monitor | Collected READ  addr=0x11dc data=0x00 |
| 83385 | hbus monitor | Collected WRITE addr=0x11dd data=0x00 |
| 83415 | hbus monitor | Collected READ  addr=0x11dd data=0x00 |
| 83435 | hbus monitor | Collected WRITE addr=0x11de data=0x00 |
| 83465 | hbus monitor | Collected READ  addr=0x11de data=0x00 |
| 83485 | hbus monitor | Collected WRITE addr=0x11df data=0x00 |
| 83515 | hbus monitor | Collected READ  addr=0x11df data=0x00 |
| 83535 | hbus monitor | Collected WRITE addr=0x11e0 data=0x00 |
| 83565 | hbus monitor | Collected READ  addr=0x11e0 data=0x00 |
| 83585 | hbus monitor | Collected WRITE addr=0x11e1 data=0x00 |
| 83615 | hbus monitor | Collected READ  addr=0x11e1 data=0x00 |
| 83635 | hbus monitor | Collected WRITE addr=0x11e2 data=0x00 |
| 83665 | hbus monitor | Collected READ  addr=0x11e2 data=0x00 |
| 83685 | hbus monitor | Collected WRITE addr=0x11e3 data=0x00 |
| 83715 | hbus monitor | Collected READ  addr=0x11e3 data=0x00 |
| 83735 | hbus monitor | Collected WRITE addr=0x11e4 data=0x00 |
| 83765 | hbus monitor | Collected READ  addr=0x11e4 data=0x00 |
| 83785 | hbus monitor | Collected WRITE addr=0x11e5 data=0x00 |
| 83815 | hbus monitor | Collected READ  addr=0x11e5 data=0x00 |
| 83835 | hbus monitor | Collected WRITE addr=0x11e6 data=0x00 |
| 83865 | hbus monitor | Collected READ  addr=0x11e6 data=0x00 |
| 83885 | hbus monitor | Collected WRITE addr=0x11e7 data=0x00 |
| 83915 | hbus monitor | Collected READ  addr=0x11e7 data=0x00 |
| 83935 | hbus monitor | Collected WRITE addr=0x11e8 data=0x00 |
| 83965 | hbus monitor | Collected READ  addr=0x11e8 data=0x00 |
| 83985 | hbus monitor | Collected WRITE addr=0x11e9 data=0x00 |
| 84015 | hbus monitor | Collected READ  addr=0x11e9 data=0x00 |
| 84035 | hbus monitor | Collected WRITE addr=0x11ea data=0x00 |
| 84065 | hbus monitor | Collected READ  addr=0x11ea data=0x00 |
| 84085 | hbus monitor | Collected WRITE addr=0x11eb data=0x00 |
| 84115 | hbus monitor | Collected READ  addr=0x11eb data=0x00 |
| 84135 | hbus monitor | Collected WRITE addr=0x11ec data=0x00 |
| 84165 | hbus monitor | Collected READ  addr=0x11ec data=0x00 |
| 84185 | hbus monitor | Collected WRITE addr=0x11ed data=0x00 |
| 84215 | hbus monitor | Collected READ  addr=0x11ed data=0x00 |
| 84235 | hbus monitor | Collected WRITE addr=0x11ee data=0x00 |
| 84265 | hbus monitor | Collected READ  addr=0x11ee data=0x00 |
| 84285 | hbus monitor | Collected WRITE addr=0x11ef data=0x00 |
| 84315 | hbus monitor | Collected READ  addr=0x11ef data=0x00 |
| 84335 | hbus monitor | Collected WRITE addr=0x11f0 data=0x00 |
| 84365 | hbus monitor | Collected READ  addr=0x11f0 data=0x00 |
| 84385 | hbus monitor | Collected WRITE addr=0x11f1 data=0x00 |
| 84415 | hbus monitor | Collected READ  addr=0x11f1 data=0x00 |
| 84435 | hbus monitor | Collected WRITE addr=0x11f2 data=0x00 |
| 84465 | hbus monitor | Collected READ  addr=0x11f2 data=0x00 |
| 84485 | hbus monitor | Collected WRITE addr=0x11f3 data=0x00 |
| 84515 | hbus monitor | Collected READ  addr=0x11f3 data=0x00 |
| 84535 | hbus monitor | Collected WRITE addr=0x11f4 data=0x00 |
| 84565 | hbus monitor | Collected READ  addr=0x11f4 data=0x00 |
| 84585 | hbus monitor | Collected WRITE addr=0x11f5 data=0x00 |
| 84615 | hbus monitor | Collected READ  addr=0x11f5 data=0x00 |
| 84635 | hbus monitor | Collected WRITE addr=0x11f6 data=0x00 |
| 84665 | hbus monitor | Collected READ  addr=0x11f6 data=0x00 |
| 84685 | hbus monitor | Collected WRITE addr=0x11f7 data=0x00 |
| 84715 | hbus monitor | Collected READ  addr=0x11f7 data=0x00 |
| 84735 | hbus monitor | Collected WRITE addr=0x11f8 data=0x00 |
| 84765 | hbus monitor | Collected READ  addr=0x11f8 data=0x00 |
| 84785 | hbus monitor | Collected WRITE addr=0x11f9 data=0x00 |
| 84815 | hbus monitor | Collected READ  addr=0x11f9 data=0x00 |
| 84835 | hbus monitor | Collected WRITE addr=0x11fa data=0x00 |
| 84865 | hbus monitor | Collected READ  addr=0x11fa data=0x00 |
| 84885 | hbus monitor | Collected WRITE addr=0x11fb data=0x00 |
| 84915 | hbus monitor | Collected READ  addr=0x11fb data=0x00 |
| 84935 | hbus monitor | Collected WRITE addr=0x11fc data=0x00 |
| 84965 | hbus monitor | Collected READ  addr=0x11fc data=0x00 |
| 84985 | hbus monitor | Collected WRITE addr=0x11fd data=0x00 |
| 85015 | hbus monitor | Collected READ  addr=0x11fd data=0x00 |
| 85035 | hbus monitor | Collected WRITE addr=0x11fe data=0x00 |
| 85065 | hbus monitor | Collected READ  addr=0x11fe data=0x00 |
| 85085 | hbus monitor | Collected WRITE addr=0x11ff data=0x00 |
| 85115 | hbus monitor | Collected READ  addr=0x11ff data=0x00 |
| 85135 | hbus monitor | Collected WRITE addr=0x1100 data=0xff |
| 85165 | hbus monitor | Collected READ  addr=0x1100 data=0xff |
| 85185 | hbus monitor | Collected WRITE addr=0x1101 data=0xff |
| 85215 | hbus monitor | Collected READ  addr=0x1101 data=0xff |
| 85235 | hbus monitor | Collected WRITE addr=0x1102 data=0xff |
| 85265 | hbus monitor | Collected READ  addr=0x1102 data=0xff |
| 85285 | hbus monitor | Collected WRITE addr=0x1103 data=0xff |
| 85315 | hbus monitor | Collected READ  addr=0x1103 data=0xff |
| 85335 | hbus monitor | Collected WRITE addr=0x1104 data=0xff |
| 85365 | hbus monitor | Collected READ  addr=0x1104 data=0xff |
| 85385 | hbus monitor | Collected WRITE addr=0x1105 data=0xff |
| 85415 | hbus monitor | Collected READ  addr=0x1105 data=0xff |
| 85435 | hbus monitor | Collected WRITE addr=0x1106 data=0xff |
| 85465 | hbus monitor | Collected READ  addr=0x1106 data=0xff |
| 85485 | hbus monitor | Collected WRITE addr=0x1107 data=0xff |
| 85515 | hbus monitor | Collected READ  addr=0x1107 data=0xff |
| 85535 | hbus monitor | Collected WRITE addr=0x1108 data=0xff |
| 85565 | hbus monitor | Collected READ  addr=0x1108 data=0xff |
| 85585 | hbus monitor | Collected WRITE addr=0x1109 data=0xff |
| 85615 | hbus monitor | Collected READ  addr=0x1109 data=0xff |
| 85635 | hbus monitor | Collected WRITE addr=0x110a data=0xff |
| 85665 | hbus monitor | Collected READ  addr=0x110a data=0xff |
| 85685 | hbus monitor | Collected WRITE addr=0x110b data=0xff |
| 85715 | hbus monitor | Collected READ  addr=0x110b data=0xff |
| 85735 | hbus monitor | Collected WRITE addr=0x110c data=0xff |
| 85765 | hbus monitor | Collected READ  addr=0x110c data=0xff |
| 85785 | hbus monitor | Collected WRITE addr=0x110d data=0xff |
| 85815 | hbus monitor | Collected READ  addr=0x110d data=0xff |
| 85835 | hbus monitor | Collected WRITE addr=0x110e data=0xff |
| 85865 | hbus monitor | Collected READ  addr=0x110e data=0xff |
| 85885 | hbus monitor | Collected WRITE addr=0x110f data=0xff |
| 85915 | hbus monitor | Collected READ  addr=0x110f data=0xff |
| 85935 | hbus monitor | Collected WRITE addr=0x1110 data=0xff |
| 85965 | hbus monitor | Collected READ  addr=0x1110 data=0xff |
| 85985 | hbus monitor | Collected WRITE addr=0x1111 data=0xff |
| 86015 | hbus monitor | Collected READ  addr=0x1111 data=0xff |
| 86035 | hbus monitor | Collected WRITE addr=0x1112 data=0xff |
| 86065 | hbus monitor | Collected READ  addr=0x1112 data=0xff |
| 86085 | hbus monitor | Collected WRITE addr=0x1113 data=0xff |
| 86115 | hbus monitor | Collected READ  addr=0x1113 data=0xff |
| 86135 | hbus monitor | Collected WRITE addr=0x1114 data=0xff |
| 86165 | hbus monitor | Collected READ  addr=0x1114 data=0xff |
| 86185 | hbus monitor | Collected WRITE addr=0x1115 data=0xff |
| 86215 | hbus monitor | Collected READ  addr=0x1115 data=0xff |
| 86235 | hbus monitor | Collected WRITE addr=0x1116 data=0xff |
| 86265 | hbus monitor | Collected READ  addr=0x1116 data=0xff |
| 86285 | hbus monitor | Collected WRITE addr=0x1117 data=0xff |
| 86315 | hbus monitor | Collected READ  addr=0x1117 data=0xff |
| 86335 | hbus monitor | Collected WRITE addr=0x1118 data=0xff |
| 86365 | hbus monitor | Collected READ  addr=0x1118 data=0xff |
| 86385 | hbus monitor | Collected WRITE addr=0x1119 data=0xff |
| 86415 | hbus monitor | Collected READ  addr=0x1119 data=0xff |
| 86435 | hbus monitor | Collected WRITE addr=0x111a data=0xff |
| 86465 | hbus monitor | Collected READ  addr=0x111a data=0xff |
| 86485 | hbus monitor | Collected WRITE addr=0x111b data=0xff |
| 86515 | hbus monitor | Collected READ  addr=0x111b data=0xff |
| 86535 | hbus monitor | Collected WRITE addr=0x111c data=0xff |
| 86565 | hbus monitor | Collected READ  addr=0x111c data=0xff |
| 86585 | hbus monitor | Collected WRITE addr=0x111d data=0xff |
| 86615 | hbus monitor | Collected READ  addr=0x111d data=0xff |
| 86635 | hbus monitor | Collected WRITE addr=0x111e data=0xff |
| 86665 | hbus monitor | Collected READ  addr=0x111e data=0xff |
| 86685 | hbus monitor | Collected WRITE addr=0x111f data=0xff |
| 86715 | hbus monitor | Collected READ  addr=0x111f data=0xff |
| 86735 | hbus monitor | Collected WRITE addr=0x1120 data=0xff |
| 86765 | hbus monitor | Collected READ  addr=0x1120 data=0xff |
| 86785 | hbus monitor | Collected WRITE addr=0x1121 data=0xff |
| 86815 | hbus monitor | Collected READ  addr=0x1121 data=0xff |
| 86835 | hbus monitor | Collected WRITE addr=0x1122 data=0xff |
| 86865 | hbus monitor | Collected READ  addr=0x1122 data=0xff |
| 86885 | hbus monitor | Collected WRITE addr=0x1123 data=0xff |
| 86915 | hbus monitor | Collected READ  addr=0x1123 data=0xff |
| 86935 | hbus monitor | Collected WRITE addr=0x1124 data=0xff |
| 86965 | hbus monitor | Collected READ  addr=0x1124 data=0xff |
| 86985 | hbus monitor | Collected WRITE addr=0x1125 data=0xff |
| 87015 | hbus monitor | Collected READ  addr=0x1125 data=0xff |
| 87035 | hbus monitor | Collected WRITE addr=0x1126 data=0xff |
| 87065 | hbus monitor | Collected READ  addr=0x1126 data=0xff |
| 87085 | hbus monitor | Collected WRITE addr=0x1127 data=0xff |
| 87115 | hbus monitor | Collected READ  addr=0x1127 data=0xff |
| 87135 | hbus monitor | Collected WRITE addr=0x1128 data=0xff |
| 87165 | hbus monitor | Collected READ  addr=0x1128 data=0xff |
| 87185 | hbus monitor | Collected WRITE addr=0x1129 data=0xff |
| 87215 | hbus monitor | Collected READ  addr=0x1129 data=0xff |
| 87235 | hbus monitor | Collected WRITE addr=0x112a data=0xff |
| 87265 | hbus monitor | Collected READ  addr=0x112a data=0xff |
| 87285 | hbus monitor | Collected WRITE addr=0x112b data=0xff |
| 87315 | hbus monitor | Collected READ  addr=0x112b data=0xff |
| 87335 | hbus monitor | Collected WRITE addr=0x112c data=0xff |
| 87365 | hbus monitor | Collected READ  addr=0x112c data=0xff |
| 87385 | hbus monitor | Collected WRITE addr=0x112d data=0xff |
| 87415 | hbus monitor | Collected READ  addr=0x112d data=0xff |
| 87435 | hbus monitor | Collected WRITE addr=0x112e data=0xff |
| 87465 | hbus monitor | Collected READ  addr=0x112e data=0xff |
| 87485 | hbus monitor | Collected WRITE addr=0x112f data=0xff |
| 87515 | hbus monitor | Collected READ  addr=0x112f data=0xff |
| 87535 | hbus monitor | Collected WRITE addr=0x1130 data=0xff |
| 87565 | hbus monitor | Collected READ  addr=0x1130 data=0xff |
| 87585 | hbus monitor | Collected WRITE addr=0x1131 data=0xff |
| 87615 | hbus monitor | Collected READ  addr=0x1131 data=0xff |
| 87635 | hbus monitor | Collected WRITE addr=0x1132 data=0xff |
| 87665 | hbus monitor | Collected READ  addr=0x1132 data=0xff |
| 87685 | hbus monitor | Collected WRITE addr=0x1133 data=0xff |
| 87715 | hbus monitor | Collected READ  addr=0x1133 data=0xff |
| 87735 | hbus monitor | Collected WRITE addr=0x1134 data=0xff |
| 87765 | hbus monitor | Collected READ  addr=0x1134 data=0xff |
| 87785 | hbus monitor | Collected WRITE addr=0x1135 data=0xff |
| 87815 | hbus monitor | Collected READ  addr=0x1135 data=0xff |
| 87835 | hbus monitor | Collected WRITE addr=0x1136 data=0xff |
| 87865 | hbus monitor | Collected READ  addr=0x1136 data=0xff |
| 87885 | hbus monitor | Collected WRITE addr=0x1137 data=0xff |
| 87915 | hbus monitor | Collected READ  addr=0x1137 data=0xff |
| 87935 | hbus monitor | Collected WRITE addr=0x1138 data=0xff |
| 87965 | hbus monitor | Collected READ  addr=0x1138 data=0xff |
| 87985 | hbus monitor | Collected WRITE addr=0x1139 data=0xff |
| 88015 | hbus monitor | Collected READ  addr=0x1139 data=0xff |
| 88035 | hbus monitor | Collected WRITE addr=0x113a data=0xff |
| 88065 | hbus monitor | Collected READ  addr=0x113a data=0xff |
| 88085 | hbus monitor | Collected WRITE addr=0x113b data=0xff |
| 88115 | hbus monitor | Collected READ  addr=0x113b data=0xff |
| 88135 | hbus monitor | Collected WRITE addr=0x113c data=0xff |
| 88165 | hbus monitor | Collected READ  addr=0x113c data=0xff |
| 88185 | hbus monitor | Collected WRITE addr=0x113d data=0xff |
| 88215 | hbus monitor | Collected READ  addr=0x113d data=0xff |
| 88235 | hbus monitor | Collected WRITE addr=0x113e data=0xff |
| 88265 | hbus monitor | Collected READ  addr=0x113e data=0xff |
| 88285 | hbus monitor | Collected WRITE addr=0x113f data=0xff |
| 88315 | hbus monitor | Collected READ  addr=0x113f data=0xff |
| 88335 | hbus monitor | Collected WRITE addr=0x1140 data=0xff |
| 88365 | hbus monitor | Collected READ  addr=0x1140 data=0xff |
| 88385 | hbus monitor | Collected WRITE addr=0x1141 data=0xff |
| 88415 | hbus monitor | Collected READ  addr=0x1141 data=0xff |
| 88435 | hbus monitor | Collected WRITE addr=0x1142 data=0xff |
| 88465 | hbus monitor | Collected READ  addr=0x1142 data=0xff |
| 88485 | hbus monitor | Collected WRITE addr=0x1143 data=0xff |
| 88515 | hbus monitor | Collected READ  addr=0x1143 data=0xff |
| 88535 | hbus monitor | Collected WRITE addr=0x1144 data=0xff |
| 88565 | hbus monitor | Collected READ  addr=0x1144 data=0xff |
| 88585 | hbus monitor | Collected WRITE addr=0x1145 data=0xff |
| 88615 | hbus monitor | Collected READ  addr=0x1145 data=0xff |
| 88635 | hbus monitor | Collected WRITE addr=0x1146 data=0xff |
| 88665 | hbus monitor | Collected READ  addr=0x1146 data=0xff |
| 88685 | hbus monitor | Collected WRITE addr=0x1147 data=0xff |
| 88715 | hbus monitor | Collected READ  addr=0x1147 data=0xff |
| 88735 | hbus monitor | Collected WRITE addr=0x1148 data=0xff |
| 88765 | hbus monitor | Collected READ  addr=0x1148 data=0xff |
| 88785 | hbus monitor | Collected WRITE addr=0x1149 data=0xff |
| 88815 | hbus monitor | Collected READ  addr=0x1149 data=0xff |
| 88835 | hbus monitor | Collected WRITE addr=0x114a data=0xff |
| 88865 | hbus monitor | Collected READ  addr=0x114a data=0xff |
| 88885 | hbus monitor | Collected WRITE addr=0x114b data=0xff |
| 88915 | hbus monitor | Collected READ  addr=0x114b data=0xff |
| 88935 | hbus monitor | Collected WRITE addr=0x114c data=0xff |
| 88965 | hbus monitor | Collected READ  addr=0x114c data=0xff |
| 88985 | hbus monitor | Collected WRITE addr=0x114d data=0xff |
| 89015 | hbus monitor | Collected READ  addr=0x114d data=0xff |
| 89035 | hbus monitor | Collected WRITE addr=0x114e data=0xff |
| 89065 | hbus monitor | Collected READ  addr=0x114e data=0xff |
| 89085 | hbus monitor | Collected WRITE addr=0x114f data=0xff |
| 89115 | hbus monitor | Collected READ  addr=0x114f data=0xff |
| 89135 | hbus monitor | Collected WRITE addr=0x1150 data=0xff |
| 89165 | hbus monitor | Collected READ  addr=0x1150 data=0xff |
| 89185 | hbus monitor | Collected WRITE addr=0x1151 data=0xff |
| 89215 | hbus monitor | Collected READ  addr=0x1151 data=0xff |
| 89235 | hbus monitor | Collected WRITE addr=0x1152 data=0xff |
| 89265 | hbus monitor | Collected READ  addr=0x1152 data=0xff |
| 89285 | hbus monitor | Collected WRITE addr=0x1153 data=0xff |
| 89315 | hbus monitor | Collected READ  addr=0x1153 data=0xff |
| 89335 | hbus monitor | Collected WRITE addr=0x1154 data=0xff |
| 89365 | hbus monitor | Collected READ  addr=0x1154 data=0xff |
| 89385 | hbus monitor | Collected WRITE addr=0x1155 data=0xff |
| 89415 | hbus monitor | Collected READ  addr=0x1155 data=0xff |
| 89435 | hbus monitor | Collected WRITE addr=0x1156 data=0xff |
| 89465 | hbus monitor | Collected READ  addr=0x1156 data=0xff |
| 89485 | hbus monitor | Collected WRITE addr=0x1157 data=0xff |
| 89515 | hbus monitor | Collected READ  addr=0x1157 data=0xff |
| 89535 | hbus monitor | Collected WRITE addr=0x1158 data=0xff |
| 89565 | hbus monitor | Collected READ  addr=0x1158 data=0xff |
| 89585 | hbus monitor | Collected WRITE addr=0x1159 data=0xff |
| 89615 | hbus monitor | Collected READ  addr=0x1159 data=0xff |
| 89635 | hbus monitor | Collected WRITE addr=0x115a data=0xff |
| 89665 | hbus monitor | Collected READ  addr=0x115a data=0xff |
| 89685 | hbus monitor | Collected WRITE addr=0x115b data=0xff |
| 89715 | hbus monitor | Collected READ  addr=0x115b data=0xff |
| 89735 | hbus monitor | Collected WRITE addr=0x115c data=0xff |
| 89765 | hbus monitor | Collected READ  addr=0x115c data=0xff |
| 89785 | hbus monitor | Collected WRITE addr=0x115d data=0xff |
| 89815 | hbus monitor | Collected READ  addr=0x115d data=0xff |
| 89835 | hbus monitor | Collected WRITE addr=0x115e data=0xff |
| 89865 | hbus monitor | Collected READ  addr=0x115e data=0xff |
| 89885 | hbus monitor | Collected WRITE addr=0x115f data=0xff |
| 89915 | hbus monitor | Collected READ  addr=0x115f data=0xff |
| 89935 | hbus monitor | Collected WRITE addr=0x1160 data=0xff |
| 89965 | hbus monitor | Collected READ  addr=0x1160 data=0xff |
| 89985 | hbus monitor | Collected WRITE addr=0x1161 data=0xff |
| 90015 | hbus monitor | Collected READ  addr=0x1161 data=0xff |
| 90035 | hbus monitor | Collected WRITE addr=0x1162 data=0xff |
| 90065 | hbus monitor | Collected READ  addr=0x1162 data=0xff |
| 90085 | hbus monitor | Collected WRITE addr=0x1163 data=0xff |
| 90115 | hbus monitor | Collected READ  addr=0x1163 data=0xff |
| 90135 | hbus monitor | Collected WRITE addr=0x1164 data=0xff |
| 90165 | hbus monitor | Collected READ  addr=0x1164 data=0xff |
| 90185 | hbus monitor | Collected WRITE addr=0x1165 data=0xff |
| 90215 | hbus monitor | Collected READ  addr=0x1165 data=0xff |
| 90235 | hbus monitor | Collected WRITE addr=0x1166 data=0xff |
| 90265 | hbus monitor | Collected READ  addr=0x1166 data=0xff |
| 90285 | hbus monitor | Collected WRITE addr=0x1167 data=0xff |
| 90315 | hbus monitor | Collected READ  addr=0x1167 data=0xff |
| 90335 | hbus monitor | Collected WRITE addr=0x1168 data=0xff |
| 90365 | hbus monitor | Collected READ  addr=0x1168 data=0xff |
| 90385 | hbus monitor | Collected WRITE addr=0x1169 data=0xff |
| 90415 | hbus monitor | Collected READ  addr=0x1169 data=0xff |
| 90435 | hbus monitor | Collected WRITE addr=0x116a data=0xff |
| 90465 | hbus monitor | Collected READ  addr=0x116a data=0xff |
| 90485 | hbus monitor | Collected WRITE addr=0x116b data=0xff |
| 90515 | hbus monitor | Collected READ  addr=0x116b data=0xff |
| 90535 | hbus monitor | Collected WRITE addr=0x116c data=0xff |
| 90565 | hbus monitor | Collected READ  addr=0x116c data=0xff |
| 90585 | hbus monitor | Collected WRITE addr=0x116d data=0xff |
| 90615 | hbus monitor | Collected READ  addr=0x116d data=0xff |
| 90635 | hbus monitor | Collected WRITE addr=0x116e data=0xff |
| 90665 | hbus monitor | Collected READ  addr=0x116e data=0xff |
| 90685 | hbus monitor | Collected WRITE addr=0x116f data=0xff |
| 90715 | hbus monitor | Collected READ  addr=0x116f data=0xff |
| 90735 | hbus monitor | Collected WRITE addr=0x1170 data=0xff |
| 90765 | hbus monitor | Collected READ  addr=0x1170 data=0xff |
| 90785 | hbus monitor | Collected WRITE addr=0x1171 data=0xff |
| 90815 | hbus monitor | Collected READ  addr=0x1171 data=0xff |
| 90835 | hbus monitor | Collected WRITE addr=0x1172 data=0xff |
| 90865 | hbus monitor | Collected READ  addr=0x1172 data=0xff |
| 90885 | hbus monitor | Collected WRITE addr=0x1173 data=0xff |
| 90915 | hbus monitor | Collected READ  addr=0x1173 data=0xff |
| 90935 | hbus monitor | Collected WRITE addr=0x1174 data=0xff |
| 90965 | hbus monitor | Collected READ  addr=0x1174 data=0xff |
| 90985 | hbus monitor | Collected WRITE addr=0x1175 data=0xff |
| 91015 | hbus monitor | Collected READ  addr=0x1175 data=0xff |
| 91035 | hbus monitor | Collected WRITE addr=0x1176 data=0xff |
| 91065 | hbus monitor | Collected READ  addr=0x1176 data=0xff |
| 91085 | hbus monitor | Collected WRITE addr=0x1177 data=0xff |
| 91115 | hbus monitor | Collected READ  addr=0x1177 data=0xff |
| 91135 | hbus monitor | Collected WRITE addr=0x1178 data=0xff |
| 91165 | hbus monitor | Collected READ  addr=0x1178 data=0xff |
| 91185 | hbus monitor | Collected WRITE addr=0x1179 data=0xff |
| 91215 | hbus monitor | Collected READ  addr=0x1179 data=0xff |
| 91235 | hbus monitor | Collected WRITE addr=0x117a data=0xff |
| 91265 | hbus monitor | Collected READ  addr=0x117a data=0xff |
| 91285 | hbus monitor | Collected WRITE addr=0x117b data=0xff |
| 91315 | hbus monitor | Collected READ  addr=0x117b data=0xff |
| 91335 | hbus monitor | Collected WRITE addr=0x117c data=0xff |
| 91365 | hbus monitor | Collected READ  addr=0x117c data=0xff |
| 91385 | hbus monitor | Collected WRITE addr=0x117d data=0xff |
| 91415 | hbus monitor | Collected READ  addr=0x117d data=0xff |
| 91435 | hbus monitor | Collected WRITE addr=0x117e data=0xff |
| 91465 | hbus monitor | Collected READ  addr=0x117e data=0xff |
| 91485 | hbus monitor | Collected WRITE addr=0x117f data=0xff |
| 91515 | hbus monitor | Collected READ  addr=0x117f data=0xff |
| 91535 | hbus monitor | Collected WRITE addr=0x1180 data=0xff |
| 91565 | hbus monitor | Collected READ  addr=0x1180 data=0xff |
| 91585 | hbus monitor | Collected WRITE addr=0x1181 data=0xff |
| 91615 | hbus monitor | Collected READ  addr=0x1181 data=0xff |
| 91635 | hbus monitor | Collected WRITE addr=0x1182 data=0xff |
| 91665 | hbus monitor | Collected READ  addr=0x1182 data=0xff |
| 91685 | hbus monitor | Collected WRITE addr=0x1183 data=0xff |
| 91715 | hbus monitor | Collected READ  addr=0x1183 data=0xff |
| 91735 | hbus monitor | Collected WRITE addr=0x1184 data=0xff |
| 91765 | hbus monitor | Collected READ  addr=0x1184 data=0xff |
| 91785 | hbus monitor | Collected WRITE addr=0x1185 data=0xff |
| 91815 | hbus monitor | Collected READ  addr=0x1185 data=0xff |
| 91835 | hbus monitor | Collected WRITE addr=0x1186 data=0xff |
| 91865 | hbus monitor | Collected READ  addr=0x1186 data=0xff |
| 91885 | hbus monitor | Collected WRITE addr=0x1187 data=0xff |
| 91915 | hbus monitor | Collected READ  addr=0x1187 data=0xff |
| 91935 | hbus monitor | Collected WRITE addr=0x1188 data=0xff |
| 91965 | hbus monitor | Collected READ  addr=0x1188 data=0xff |
| 91985 | hbus monitor | Collected WRITE addr=0x1189 data=0xff |
| 92015 | hbus monitor | Collected READ  addr=0x1189 data=0xff |
| 92035 | hbus monitor | Collected WRITE addr=0x118a data=0xff |
| 92065 | hbus monitor | Collected READ  addr=0x118a data=0xff |
| 92085 | hbus monitor | Collected WRITE addr=0x118b data=0xff |
| 92115 | hbus monitor | Collected READ  addr=0x118b data=0xff |
| 92135 | hbus monitor | Collected WRITE addr=0x118c data=0xff |
| 92165 | hbus monitor | Collected READ  addr=0x118c data=0xff |
| 92185 | hbus monitor | Collected WRITE addr=0x118d data=0xff |
| 92215 | hbus monitor | Collected READ  addr=0x118d data=0xff |
| 92235 | hbus monitor | Collected WRITE addr=0x118e data=0xff |
| 92265 | hbus monitor | Collected READ  addr=0x118e data=0xff |
| 92285 | hbus monitor | Collected WRITE addr=0x118f data=0xff |
| 92315 | hbus monitor | Collected READ  addr=0x118f data=0xff |
| 92335 | hbus monitor | Collected WRITE addr=0x1190 data=0xff |
| 92365 | hbus monitor | Collected READ  addr=0x1190 data=0xff |
| 92385 | hbus monitor | Collected WRITE addr=0x1191 data=0xff |
| 92415 | hbus monitor | Collected READ  addr=0x1191 data=0xff |
| 92435 | hbus monitor | Collected WRITE addr=0x1192 data=0xff |
| 92465 | hbus monitor | Collected READ  addr=0x1192 data=0xff |
| 92485 | hbus monitor | Collected WRITE addr=0x1193 data=0xff |
| 92515 | hbus monitor | Collected READ  addr=0x1193 data=0xff |
| 92535 | hbus monitor | Collected WRITE addr=0x1194 data=0xff |
| 92565 | hbus monitor | Collected READ  addr=0x1194 data=0xff |
| 92585 | hbus monitor | Collected WRITE addr=0x1195 data=0xff |
| 92615 | hbus monitor | Collected READ  addr=0x1195 data=0xff |
| 92635 | hbus monitor | Collected WRITE addr=0x1196 data=0xff |
| 92665 | hbus monitor | Collected READ  addr=0x1196 data=0xff |
| 92685 | hbus monitor | Collected WRITE addr=0x1197 data=0xff |
| 92715 | hbus monitor | Collected READ  addr=0x1197 data=0xff |
| 92735 | hbus monitor | Collected WRITE addr=0x1198 data=0xff |
| 92765 | hbus monitor | Collected READ  addr=0x1198 data=0xff |
| 92785 | hbus monitor | Collected WRITE addr=0x1199 data=0xff |
| 92815 | hbus monitor | Collected READ  addr=0x1199 data=0xff |
| 92835 | hbus monitor | Collected WRITE addr=0x119a data=0xff |
| 92865 | hbus monitor | Collected READ  addr=0x119a data=0xff |
| 92885 | hbus monitor | Collected WRITE addr=0x119b data=0xff |
| 92915 | hbus monitor | Collected READ  addr=0x119b data=0xff |
| 92935 | hbus monitor | Collected WRITE addr=0x119c data=0xff |
| 92965 | hbus monitor | Collected READ  addr=0x119c data=0xff |
| 92985 | hbus monitor | Collected WRITE addr=0x119d data=0xff |
| 93015 | hbus monitor | Collected READ  addr=0x119d data=0xff |
| 93035 | hbus monitor | Collected WRITE addr=0x119e data=0xff |
| 93065 | hbus monitor | Collected READ  addr=0x119e data=0xff |
| 93085 | hbus monitor | Collected WRITE addr=0x119f data=0xff |
| 93115 | hbus monitor | Collected READ  addr=0x119f data=0xff |
| 93135 | hbus monitor | Collected WRITE addr=0x11a0 data=0xff |
| 93165 | hbus monitor | Collected READ  addr=0x11a0 data=0xff |
| 93185 | hbus monitor | Collected WRITE addr=0x11a1 data=0xff |
| 93215 | hbus monitor | Collected READ  addr=0x11a1 data=0xff |
| 93235 | hbus monitor | Collected WRITE addr=0x11a2 data=0xff |
| 93265 | hbus monitor | Collected READ  addr=0x11a2 data=0xff |
| 93285 | hbus monitor | Collected WRITE addr=0x11a3 data=0xff |
| 93315 | hbus monitor | Collected READ  addr=0x11a3 data=0xff |
| 93335 | hbus monitor | Collected WRITE addr=0x11a4 data=0xff |
| 93365 | hbus monitor | Collected READ  addr=0x11a4 data=0xff |
| 93385 | hbus monitor | Collected WRITE addr=0x11a5 data=0xff |
| 93415 | hbus monitor | Collected READ  addr=0x11a5 data=0xff |
| 93435 | hbus monitor | Collected WRITE addr=0x11a6 data=0xff |
| 93465 | hbus monitor | Collected READ  addr=0x11a6 data=0xff |
| 93485 | hbus monitor | Collected WRITE addr=0x11a7 data=0xff |
| 93515 | hbus monitor | Collected READ  addr=0x11a7 data=0xff |
| 93535 | hbus monitor | Collected WRITE addr=0x11a8 data=0xff |
| 93565 | hbus monitor | Collected READ  addr=0x11a8 data=0xff |
| 93585 | hbus monitor | Collected WRITE addr=0x11a9 data=0xff |
| 93615 | hbus monitor | Collected READ  addr=0x11a9 data=0xff |
| 93635 | hbus monitor | Collected WRITE addr=0x11aa data=0xff |
| 93665 | hbus monitor | Collected READ  addr=0x11aa data=0xff |
| 93685 | hbus monitor | Collected WRITE addr=0x11ab data=0xff |
| 93715 | hbus monitor | Collected READ  addr=0x11ab data=0xff |
| 93735 | hbus monitor | Collected WRITE addr=0x11ac data=0xff |
| 93765 | hbus monitor | Collected READ  addr=0x11ac data=0xff |
| 93785 | hbus monitor | Collected WRITE addr=0x11ad data=0xff |
| 93815 | hbus monitor | Collected READ  addr=0x11ad data=0xff |
| 93835 | hbus monitor | Collected WRITE addr=0x11ae data=0xff |
| 93865 | hbus monitor | Collected READ  addr=0x11ae data=0xff |
| 93885 | hbus monitor | Collected WRITE addr=0x11af data=0xff |
| 93915 | hbus monitor | Collected READ  addr=0x11af data=0xff |
| 93935 | hbus monitor | Collected WRITE addr=0x11b0 data=0xff |
| 93965 | hbus monitor | Collected READ  addr=0x11b0 data=0xff |
| 93985 | hbus monitor | Collected WRITE addr=0x11b1 data=0xff |
| 94015 | hbus monitor | Collected READ  addr=0x11b1 data=0xff |
| 94035 | hbus monitor | Collected WRITE addr=0x11b2 data=0xff |
| 94065 | hbus monitor | Collected READ  addr=0x11b2 data=0xff |
| 94085 | hbus monitor | Collected WRITE addr=0x11b3 data=0xff |
| 94115 | hbus monitor | Collected READ  addr=0x11b3 data=0xff |
| 94135 | hbus monitor | Collected WRITE addr=0x11b4 data=0xff |
| 94165 | hbus monitor | Collected READ  addr=0x11b4 data=0xff |
| 94185 | hbus monitor | Collected WRITE addr=0x11b5 data=0xff |
| 94215 | hbus monitor | Collected READ  addr=0x11b5 data=0xff |
| 94235 | hbus monitor | Collected WRITE addr=0x11b6 data=0xff |
| 94265 | hbus monitor | Collected READ  addr=0x11b6 data=0xff |
| 94285 | hbus monitor | Collected WRITE addr=0x11b7 data=0xff |
| 94315 | hbus monitor | Collected READ  addr=0x11b7 data=0xff |
| 94335 | hbus monitor | Collected WRITE addr=0x11b8 data=0xff |
| 94365 | hbus monitor | Collected READ  addr=0x11b8 data=0xff |
| 94385 | hbus monitor | Collected WRITE addr=0x11b9 data=0xff |
| 94415 | hbus monitor | Collected READ  addr=0x11b9 data=0xff |
| 94435 | hbus monitor | Collected WRITE addr=0x11ba data=0xff |
| 94465 | hbus monitor | Collected READ  addr=0x11ba data=0xff |
| 94485 | hbus monitor | Collected WRITE addr=0x11bb data=0xff |
| 94515 | hbus monitor | Collected READ  addr=0x11bb data=0xff |
| 94535 | hbus monitor | Collected WRITE addr=0x11bc data=0xff |
| 94565 | hbus monitor | Collected READ  addr=0x11bc data=0xff |
| 94585 | hbus monitor | Collected WRITE addr=0x11bd data=0xff |
| 94615 | hbus monitor | Collected READ  addr=0x11bd data=0xff |
| 94635 | hbus monitor | Collected WRITE addr=0x11be data=0xff |
| 94665 | hbus monitor | Collected READ  addr=0x11be data=0xff |
| 94685 | hbus monitor | Collected WRITE addr=0x11bf data=0xff |
| 94715 | hbus monitor | Collected READ  addr=0x11bf data=0xff |
| 94735 | hbus monitor | Collected WRITE addr=0x11c0 data=0xff |
| 94765 | hbus monitor | Collected READ  addr=0x11c0 data=0xff |
| 94785 | hbus monitor | Collected WRITE addr=0x11c1 data=0xff |
| 94815 | hbus monitor | Collected READ  addr=0x11c1 data=0xff |
| 94835 | hbus monitor | Collected WRITE addr=0x11c2 data=0xff |
| 94865 | hbus monitor | Collected READ  addr=0x11c2 data=0xff |
| 94885 | hbus monitor | Collected WRITE addr=0x11c3 data=0xff |
| 94915 | hbus monitor | Collected READ  addr=0x11c3 data=0xff |
| 94935 | hbus monitor | Collected WRITE addr=0x11c4 data=0xff |
| 94965 | hbus monitor | Collected READ  addr=0x11c4 data=0xff |
| 94985 | hbus monitor | Collected WRITE addr=0x11c5 data=0xff |
| 95015 | hbus monitor | Collected READ  addr=0x11c5 data=0xff |
| 95035 | hbus monitor | Collected WRITE addr=0x11c6 data=0xff |
| 95065 | hbus monitor | Collected READ  addr=0x11c6 data=0xff |
| 95085 | hbus monitor | Collected WRITE addr=0x11c7 data=0xff |
| 95115 | hbus monitor | Collected READ  addr=0x11c7 data=0xff |
| 95135 | hbus monitor | Collected WRITE addr=0x11c8 data=0xff |
| 95165 | hbus monitor | Collected READ  addr=0x11c8 data=0xff |
| 95185 | hbus monitor | Collected WRITE addr=0x11c9 data=0xff |
| 95215 | hbus monitor | Collected READ  addr=0x11c9 data=0xff |
| 95235 | hbus monitor | Collected WRITE addr=0x11ca data=0xff |
| 95265 | hbus monitor | Collected READ  addr=0x11ca data=0xff |
| 95285 | hbus monitor | Collected WRITE addr=0x11cb data=0xff |
| 95315 | hbus monitor | Collected READ  addr=0x11cb data=0xff |
| 95335 | hbus monitor | Collected WRITE addr=0x11cc data=0xff |
| 95365 | hbus monitor | Collected READ  addr=0x11cc data=0xff |
| 95385 | hbus monitor | Collected WRITE addr=0x11cd data=0xff |
| 95415 | hbus monitor | Collected READ  addr=0x11cd data=0xff |
| 95435 | hbus monitor | Collected WRITE addr=0x11ce data=0xff |
| 95465 | hbus monitor | Collected READ  addr=0x11ce data=0xff |
| 95485 | hbus monitor | Collected WRITE addr=0x11cf data=0xff |
| 95515 | hbus monitor | Collected READ  addr=0x11cf data=0xff |
| 95535 | hbus monitor | Collected WRITE addr=0x11d0 data=0xff |
| 95565 | hbus monitor | Collected READ  addr=0x11d0 data=0xff |
| 95585 | hbus monitor | Collected WRITE addr=0x11d1 data=0xff |
| 95615 | hbus monitor | Collected READ  addr=0x11d1 data=0xff |
| 95635 | hbus monitor | Collected WRITE addr=0x11d2 data=0xff |
| 95665 | hbus monitor | Collected READ  addr=0x11d2 data=0xff |
| 95685 | hbus monitor | Collected WRITE addr=0x11d3 data=0xff |
| 95715 | hbus monitor | Collected READ  addr=0x11d3 data=0xff |
| 95735 | hbus monitor | Collected WRITE addr=0x11d4 data=0xff |
| 95765 | hbus monitor | Collected READ  addr=0x11d4 data=0xff |
| 95785 | hbus monitor | Collected WRITE addr=0x11d5 data=0xff |
| 95815 | hbus monitor | Collected READ  addr=0x11d5 data=0xff |
| 95835 | hbus monitor | Collected WRITE addr=0x11d6 data=0xff |
| 95865 | hbus monitor | Collected READ  addr=0x11d6 data=0xff |
| 95885 | hbus monitor | Collected WRITE addr=0x11d7 data=0xff |
| 95915 | hbus monitor | Collected READ  addr=0x11d7 data=0xff |
| 95935 | hbus monitor | Collected WRITE addr=0x11d8 data=0xff |
| 95965 | hbus monitor | Collected READ  addr=0x11d8 data=0xff |
| 95985 | hbus monitor | Collected WRITE addr=0x11d9 data=0xff |
| 96015 | hbus monitor | Collected READ  addr=0x11d9 data=0xff |
| 96035 | hbus monitor | Collected WRITE addr=0x11da data=0xff |
| 96065 | hbus monitor | Collected READ  addr=0x11da data=0xff |
| 96085 | hbus monitor | Collected WRITE addr=0x11db data=0xff |
| 96115 | hbus monitor | Collected READ  addr=0x11db data=0xff |
| 96135 | hbus monitor | Collected WRITE addr=0x11dc data=0xff |
| 96165 | hbus monitor | Collected READ  addr=0x11dc data=0xff |
| 96185 | hbus monitor | Collected WRITE addr=0x11dd data=0xff |
| 96215 | hbus monitor | Collected READ  addr=0x11dd data=0xff |
| 96235 | hbus monitor | Collected WRITE addr=0x11de data=0xff |
| 96265 | hbus monitor | Collected READ  addr=0x11de data=0xff |
| 96285 | hbus monitor | Collected WRITE addr=0x11df data=0xff |
| 96315 | hbus monitor | Collected READ  addr=0x11df data=0xff |
| 96335 | hbus monitor | Collected WRITE addr=0x11e0 data=0xff |
| 96365 | hbus monitor | Collected READ  addr=0x11e0 data=0xff |
| 96385 | hbus monitor | Collected WRITE addr=0x11e1 data=0xff |
| 96415 | hbus monitor | Collected READ  addr=0x11e1 data=0xff |
| 96435 | hbus monitor | Collected WRITE addr=0x11e2 data=0xff |
| 96465 | hbus monitor | Collected READ  addr=0x11e2 data=0xff |
| 96485 | hbus monitor | Collected WRITE addr=0x11e3 data=0xff |
| 96515 | hbus monitor | Collected READ  addr=0x11e3 data=0xff |
| 96535 | hbus monitor | Collected WRITE addr=0x11e4 data=0xff |
| 96565 | hbus monitor | Collected READ  addr=0x11e4 data=0xff |
| 96585 | hbus monitor | Collected WRITE addr=0x11e5 data=0xff |
| 96615 | hbus monitor | Collected READ  addr=0x11e5 data=0xff |
| 96635 | hbus monitor | Collected WRITE addr=0x11e6 data=0xff |
| 96665 | hbus monitor | Collected READ  addr=0x11e6 data=0xff |
| 96685 | hbus monitor | Collected WRITE addr=0x11e7 data=0xff |
| 96715 | hbus monitor | Collected READ  addr=0x11e7 data=0xff |
| 96735 | hbus monitor | Collected WRITE addr=0x11e8 data=0xff |
| 96765 | hbus monitor | Collected READ  addr=0x11e8 data=0xff |
| 96785 | hbus monitor | Collected WRITE addr=0x11e9 data=0xff |
| 96815 | hbus monitor | Collected READ  addr=0x11e9 data=0xff |
| 96835 | hbus monitor | Collected WRITE addr=0x11ea data=0xff |
| 96865 | hbus monitor | Collected READ  addr=0x11ea data=0xff |
| 96885 | hbus monitor | Collected WRITE addr=0x11eb data=0xff |
| 96915 | hbus monitor | Collected READ  addr=0x11eb data=0xff |
| 96935 | hbus monitor | Collected WRITE addr=0x11ec data=0xff |
| 96965 | hbus monitor | Collected READ  addr=0x11ec data=0xff |
| 96985 | hbus monitor | Collected WRITE addr=0x11ed data=0xff |
| 97015 | hbus monitor | Collected READ  addr=0x11ed data=0xff |
| 97035 | hbus monitor | Collected WRITE addr=0x11ee data=0xff |
| 97065 | hbus monitor | Collected READ  addr=0x11ee data=0xff |
| 97085 | hbus monitor | Collected WRITE addr=0x11ef data=0xff |
| 97115 | hbus monitor | Collected READ  addr=0x11ef data=0xff |
| 97135 | hbus monitor | Collected WRITE addr=0x11f0 data=0xff |
| 97165 | hbus monitor | Collected READ  addr=0x11f0 data=0xff |
| 97185 | hbus monitor | Collected WRITE addr=0x11f1 data=0xff |
| 97215 | hbus monitor | Collected READ  addr=0x11f1 data=0xff |
| 97235 | hbus monitor | Collected WRITE addr=0x11f2 data=0xff |
| 97265 | hbus monitor | Collected READ  addr=0x11f2 data=0xff |
| 97285 | hbus monitor | Collected WRITE addr=0x11f3 data=0xff |
| 97315 | hbus monitor | Collected READ  addr=0x11f3 data=0xff |
| 97335 | hbus monitor | Collected WRITE addr=0x11f4 data=0xff |
| 97365 | hbus monitor | Collected READ  addr=0x11f4 data=0xff |
| 97385 | hbus monitor | Collected WRITE addr=0x11f5 data=0xff |
| 97415 | hbus monitor | Collected READ  addr=0x11f5 data=0xff |
| 97435 | hbus monitor | Collected WRITE addr=0x11f6 data=0xff |
| 97465 | hbus monitor | Collected READ  addr=0x11f6 data=0xff |
| 97485 | hbus monitor | Collected WRITE addr=0x11f7 data=0xff |
| 97515 | hbus monitor | Collected READ  addr=0x11f7 data=0xff |
| 97535 | hbus monitor | Collected WRITE addr=0x11f8 data=0xff |
| 97565 | hbus monitor | Collected READ  addr=0x11f8 data=0xff |
| 97585 | hbus monitor | Collected WRITE addr=0x11f9 data=0xff |
| 97615 | hbus monitor | Collected READ  addr=0x11f9 data=0xff |
| 97635 | hbus monitor | Collected WRITE addr=0x11fa data=0xff |
| 97665 | hbus monitor | Collected READ  addr=0x11fa data=0xff |
| 97685 | hbus monitor | Collected WRITE addr=0x11fb data=0xff |
| 97715 | hbus monitor | Collected READ  addr=0x11fb data=0xff |
| 97735 | hbus monitor | Collected WRITE addr=0x11fc data=0xff |
| 97765 | hbus monitor | Collected READ  addr=0x11fc data=0xff |
| 97785 | hbus monitor | Collected WRITE addr=0x11fd data=0xff |
| 97815 | hbus monitor | Collected READ  addr=0x11fd data=0xff |
| 97835 | hbus monitor | Collected WRITE addr=0x11fe data=0xff |
| 97865 | hbus monitor | Collected READ  addr=0x11fe data=0xff |
| 97885 | hbus monitor | Collected WRITE addr=0x11ff data=0xff |
| 97915 | hbus monitor | Collected READ  addr=0x11ff data=0xff |
| 97935 | hbus monitor | Collected WRITE addr=0x1100 data=0x55 |
| 97965 | hbus monitor | Collected READ  addr=0x1100 data=0x55 |
| 97985 | hbus monitor | Collected WRITE addr=0x1101 data=0x55 |
| 98015 | hbus monitor | Collected READ  addr=0x1101 data=0x55 |
| 98035 | hbus monitor | Collected WRITE addr=0x1102 data=0x55 |
| 98065 | hbus monitor | Collected READ  addr=0x1102 data=0x55 |
| 98085 | hbus monitor | Collected WRITE addr=0x1103 data=0x55 |
| 98115 | hbus monitor | Collected READ  addr=0x1103 data=0x55 |
| 98135 | hbus monitor | Collected WRITE addr=0x1104 data=0x55 |
| 98165 | hbus monitor | Collected READ  addr=0x1104 data=0x55 |
| 98185 | hbus monitor | Collected WRITE addr=0x1105 data=0x55 |
| 98215 | hbus monitor | Collected READ  addr=0x1105 data=0x55 |
| 98235 | hbus monitor | Collected WRITE addr=0x1106 data=0x55 |
| 98265 | hbus monitor | Collected READ  addr=0x1106 data=0x55 |
| 98285 | hbus monitor | Collected WRITE addr=0x1107 data=0x55 |
| 98315 | hbus monitor | Collected READ  addr=0x1107 data=0x55 |
| 98335 | hbus monitor | Collected WRITE addr=0x1108 data=0x55 |
| 98365 | hbus monitor | Collected READ  addr=0x1108 data=0x55 |
| 98385 | hbus monitor | Collected WRITE addr=0x1109 data=0x55 |
| 98415 | hbus monitor | Collected READ  addr=0x1109 data=0x55 |
| 98435 | hbus monitor | Collected WRITE addr=0x110a data=0x55 |
| 98465 | hbus monitor | Collected READ  addr=0x110a data=0x55 |
| 98485 | hbus monitor | Collected WRITE addr=0x110b data=0x55 |
| 98515 | hbus monitor | Collected READ  addr=0x110b data=0x55 |
| 98535 | hbus monitor | Collected WRITE addr=0x110c data=0x55 |
| 98565 | hbus monitor | Collected READ  addr=0x110c data=0x55 |
| 98585 | hbus monitor | Collected WRITE addr=0x110d data=0x55 |
| 98615 | hbus monitor | Collected READ  addr=0x110d data=0x55 |
| 98635 | hbus monitor | Collected WRITE addr=0x110e data=0x55 |
| 98665 | hbus monitor | Collected READ  addr=0x110e data=0x55 |
| 98685 | hbus monitor | Collected WRITE addr=0x110f data=0x55 |
| 98715 | hbus monitor | Collected READ  addr=0x110f data=0x55 |
| 98735 | hbus monitor | Collected WRITE addr=0x1110 data=0x55 |
| 98765 | hbus monitor | Collected READ  addr=0x1110 data=0x55 |
| 98785 | hbus monitor | Collected WRITE addr=0x1111 data=0x55 |
| 98815 | hbus monitor | Collected READ  addr=0x1111 data=0x55 |
| 98835 | hbus monitor | Collected WRITE addr=0x1112 data=0x55 |
| 98865 | hbus monitor | Collected READ  addr=0x1112 data=0x55 |
| 98885 | hbus monitor | Collected WRITE addr=0x1113 data=0x55 |
| 98915 | hbus monitor | Collected READ  addr=0x1113 data=0x55 |
| 98935 | hbus monitor | Collected WRITE addr=0x1114 data=0x55 |
| 98965 | hbus monitor | Collected READ  addr=0x1114 data=0x55 |
| 98985 | hbus monitor | Collected WRITE addr=0x1115 data=0x55 |
| 99015 | hbus monitor | Collected READ  addr=0x1115 data=0x55 |
| 99035 | hbus monitor | Collected WRITE addr=0x1116 data=0x55 |
| 99065 | hbus monitor | Collected READ  addr=0x1116 data=0x55 |
| 99085 | hbus monitor | Collected WRITE addr=0x1117 data=0x55 |
| 99115 | hbus monitor | Collected READ  addr=0x1117 data=0x55 |
| 99135 | hbus monitor | Collected WRITE addr=0x1118 data=0x55 |
| 99165 | hbus monitor | Collected READ  addr=0x1118 data=0x55 |
| 99185 | hbus monitor | Collected WRITE addr=0x1119 data=0x55 |
| 99215 | hbus monitor | Collected READ  addr=0x1119 data=0x55 |
| 99235 | hbus monitor | Collected WRITE addr=0x111a data=0x55 |
| 99265 | hbus monitor | Collected READ  addr=0x111a data=0x55 |
| 99285 | hbus monitor | Collected WRITE addr=0x111b data=0x55 |
| 99315 | hbus monitor | Collected READ  addr=0x111b data=0x55 |
| 99335 | hbus monitor | Collected WRITE addr=0x111c data=0x55 |
| 99365 | hbus monitor | Collected READ  addr=0x111c data=0x55 |
| 99385 | hbus monitor | Collected WRITE addr=0x111d data=0x55 |
| 99415 | hbus monitor | Collected READ  addr=0x111d data=0x55 |
| 99435 | hbus monitor | Collected WRITE addr=0x111e data=0x55 |
| 99465 | hbus monitor | Collected READ  addr=0x111e data=0x55 |
| 99485 | hbus monitor | Collected WRITE addr=0x111f data=0x55 |
| 99515 | hbus monitor | Collected READ  addr=0x111f data=0x55 |
| 99535 | hbus monitor | Collected WRITE addr=0x1120 data=0x55 |
| 99565 | hbus monitor | Collected READ  addr=0x1120 data=0x55 |
| 99585 | hbus monitor | Collected WRITE addr=0x1121 data=0x55 |
| 99615 | hbus monitor | Collected READ  addr=0x1121 data=0x55 |
| 99635 | hbus monitor | Collected WRITE addr=0x1122 data=0x55 |
| 99665 | hbus monitor | Collected READ  addr=0x1122 data=0x55 |
| 99685 | hbus monitor | Collected WRITE addr=0x1123 data=0x55 |
| 99715 | hbus monitor | Collected READ  addr=0x1123 data=0x55 |
| 99735 | hbus monitor | Collected WRITE addr=0x1124 data=0x55 |
| 99765 | hbus monitor | Collected READ  addr=0x1124 data=0x55 |
| 99785 | hbus monitor | Collected WRITE addr=0x1125 data=0x55 |
| 99815 | hbus monitor | Collected READ  addr=0x1125 data=0x55 |
| 99835 | hbus monitor | Collected WRITE addr=0x1126 data=0x55 |
| 99865 | hbus monitor | Collected READ  addr=0x1126 data=0x55 |
| 99885 | hbus monitor | Collected WRITE addr=0x1127 data=0x55 |
| 99915 | hbus monitor | Collected READ  addr=0x1127 data=0x55 |
| 99935 | hbus monitor | Collected WRITE addr=0x1128 data=0x55 |
| 99965 | hbus monitor | Collected READ  addr=0x1128 data=0x55 |
| 99985 | hbus monitor | Collected WRITE addr=0x1129 data=0x55 |
| 100015 | hbus monitor | Collected READ  addr=0x1129 data=0x55 |
| 100035 | hbus monitor | Collected WRITE addr=0x112a data=0x55 |
| 100065 | hbus monitor | Collected READ  addr=0x112a data=0x55 |
| 100085 | hbus monitor | Collected WRITE addr=0x112b data=0x55 |
| 100115 | hbus monitor | Collected READ  addr=0x112b data=0x55 |
| 100135 | hbus monitor | Collected WRITE addr=0x112c data=0x55 |
| 100165 | hbus monitor | Collected READ  addr=0x112c data=0x55 |
| 100185 | hbus monitor | Collected WRITE addr=0x112d data=0x55 |
| 100215 | hbus monitor | Collected READ  addr=0x112d data=0x55 |
| 100235 | hbus monitor | Collected WRITE addr=0x112e data=0x55 |
| 100265 | hbus monitor | Collected READ  addr=0x112e data=0x55 |
| 100285 | hbus monitor | Collected WRITE addr=0x112f data=0x55 |
| 100315 | hbus monitor | Collected READ  addr=0x112f data=0x55 |
| 100335 | hbus monitor | Collected WRITE addr=0x1130 data=0x55 |
| 100365 | hbus monitor | Collected READ  addr=0x1130 data=0x55 |
| 100385 | hbus monitor | Collected WRITE addr=0x1131 data=0x55 |
| 100415 | hbus monitor | Collected READ  addr=0x1131 data=0x55 |
| 100435 | hbus monitor | Collected WRITE addr=0x1132 data=0x55 |
| 100465 | hbus monitor | Collected READ  addr=0x1132 data=0x55 |
| 100485 | hbus monitor | Collected WRITE addr=0x1133 data=0x55 |
| 100515 | hbus monitor | Collected READ  addr=0x1133 data=0x55 |
| 100535 | hbus monitor | Collected WRITE addr=0x1134 data=0x55 |
| 100565 | hbus monitor | Collected READ  addr=0x1134 data=0x55 |
| 100585 | hbus monitor | Collected WRITE addr=0x1135 data=0x55 |
| 100615 | hbus monitor | Collected READ  addr=0x1135 data=0x55 |
| 100635 | hbus monitor | Collected WRITE addr=0x1136 data=0x55 |
| 100665 | hbus monitor | Collected READ  addr=0x1136 data=0x55 |
| 100685 | hbus monitor | Collected WRITE addr=0x1137 data=0x55 |
| 100715 | hbus monitor | Collected READ  addr=0x1137 data=0x55 |
| 100735 | hbus monitor | Collected WRITE addr=0x1138 data=0x55 |
| 100765 | hbus monitor | Collected READ  addr=0x1138 data=0x55 |
| 100785 | hbus monitor | Collected WRITE addr=0x1139 data=0x55 |
| 100815 | hbus monitor | Collected READ  addr=0x1139 data=0x55 |
| 100835 | hbus monitor | Collected WRITE addr=0x113a data=0x55 |
| 100865 | hbus monitor | Collected READ  addr=0x113a data=0x55 |
| 100885 | hbus monitor | Collected WRITE addr=0x113b data=0x55 |
| 100915 | hbus monitor | Collected READ  addr=0x113b data=0x55 |
| 100935 | hbus monitor | Collected WRITE addr=0x113c data=0x55 |
| 100965 | hbus monitor | Collected READ  addr=0x113c data=0x55 |
| 100985 | hbus monitor | Collected WRITE addr=0x113d data=0x55 |
| 101015 | hbus monitor | Collected READ  addr=0x113d data=0x55 |
| 101035 | hbus monitor | Collected WRITE addr=0x113e data=0x55 |
| 101065 | hbus monitor | Collected READ  addr=0x113e data=0x55 |
| 101085 | hbus monitor | Collected WRITE addr=0x113f data=0x55 |
| 101115 | hbus monitor | Collected READ  addr=0x113f data=0x55 |
| 101135 | hbus monitor | Collected WRITE addr=0x1140 data=0x55 |
| 101165 | hbus monitor | Collected READ  addr=0x1140 data=0x55 |
| 101185 | hbus monitor | Collected WRITE addr=0x1141 data=0x55 |
| 101215 | hbus monitor | Collected READ  addr=0x1141 data=0x55 |
| 101235 | hbus monitor | Collected WRITE addr=0x1142 data=0x55 |
| 101265 | hbus monitor | Collected READ  addr=0x1142 data=0x55 |
| 101285 | hbus monitor | Collected WRITE addr=0x1143 data=0x55 |
| 101315 | hbus monitor | Collected READ  addr=0x1143 data=0x55 |
| 101335 | hbus monitor | Collected WRITE addr=0x1144 data=0x55 |
| 101365 | hbus monitor | Collected READ  addr=0x1144 data=0x55 |
| 101385 | hbus monitor | Collected WRITE addr=0x1145 data=0x55 |
| 101415 | hbus monitor | Collected READ  addr=0x1145 data=0x55 |
| 101435 | hbus monitor | Collected WRITE addr=0x1146 data=0x55 |
| 101465 | hbus monitor | Collected READ  addr=0x1146 data=0x55 |
| 101485 | hbus monitor | Collected WRITE addr=0x1147 data=0x55 |
| 101515 | hbus monitor | Collected READ  addr=0x1147 data=0x55 |
| 101535 | hbus monitor | Collected WRITE addr=0x1148 data=0x55 |
| 101565 | hbus monitor | Collected READ  addr=0x1148 data=0x55 |
| 101585 | hbus monitor | Collected WRITE addr=0x1149 data=0x55 |
| 101615 | hbus monitor | Collected READ  addr=0x1149 data=0x55 |
| 101635 | hbus monitor | Collected WRITE addr=0x114a data=0x55 |
| 101665 | hbus monitor | Collected READ  addr=0x114a data=0x55 |
| 101685 | hbus monitor | Collected WRITE addr=0x114b data=0x55 |
| 101715 | hbus monitor | Collected READ  addr=0x114b data=0x55 |
| 101735 | hbus monitor | Collected WRITE addr=0x114c data=0x55 |
| 101765 | hbus monitor | Collected READ  addr=0x114c data=0x55 |
| 101785 | hbus monitor | Collected WRITE addr=0x114d data=0x55 |
| 101815 | hbus monitor | Collected READ  addr=0x114d data=0x55 |
| 101835 | hbus monitor | Collected WRITE addr=0x114e data=0x55 |
| 101865 | hbus monitor | Collected READ  addr=0x114e data=0x55 |
| 101885 | hbus monitor | Collected WRITE addr=0x114f data=0x55 |
| 101915 | hbus monitor | Collected READ  addr=0x114f data=0x55 |
| 101935 | hbus monitor | Collected WRITE addr=0x1150 data=0x55 |
| 101965 | hbus monitor | Collected READ  addr=0x1150 data=0x55 |
| 101985 | hbus monitor | Collected WRITE addr=0x1151 data=0x55 |
| 102015 | hbus monitor | Collected READ  addr=0x1151 data=0x55 |
| 102035 | hbus monitor | Collected WRITE addr=0x1152 data=0x55 |
| 102065 | hbus monitor | Collected READ  addr=0x1152 data=0x55 |
| 102085 | hbus monitor | Collected WRITE addr=0x1153 data=0x55 |
| 102115 | hbus monitor | Collected READ  addr=0x1153 data=0x55 |
| 102135 | hbus monitor | Collected WRITE addr=0x1154 data=0x55 |
| 102165 | hbus monitor | Collected READ  addr=0x1154 data=0x55 |
| 102185 | hbus monitor | Collected WRITE addr=0x1155 data=0x55 |
| 102215 | hbus monitor | Collected READ  addr=0x1155 data=0x55 |
| 102235 | hbus monitor | Collected WRITE addr=0x1156 data=0x55 |
| 102265 | hbus monitor | Collected READ  addr=0x1156 data=0x55 |
| 102285 | hbus monitor | Collected WRITE addr=0x1157 data=0x55 |
| 102315 | hbus monitor | Collected READ  addr=0x1157 data=0x55 |
| 102335 | hbus monitor | Collected WRITE addr=0x1158 data=0x55 |
| 102365 | hbus monitor | Collected READ  addr=0x1158 data=0x55 |
| 102385 | hbus monitor | Collected WRITE addr=0x1159 data=0x55 |
| 102415 | hbus monitor | Collected READ  addr=0x1159 data=0x55 |
| 102435 | hbus monitor | Collected WRITE addr=0x115a data=0x55 |
| 102465 | hbus monitor | Collected READ  addr=0x115a data=0x55 |
| 102485 | hbus monitor | Collected WRITE addr=0x115b data=0x55 |
| 102515 | hbus monitor | Collected READ  addr=0x115b data=0x55 |
| 102535 | hbus monitor | Collected WRITE addr=0x115c data=0x55 |
| 102565 | hbus monitor | Collected READ  addr=0x115c data=0x55 |
| 102585 | hbus monitor | Collected WRITE addr=0x115d data=0x55 |
| 102615 | hbus monitor | Collected READ  addr=0x115d data=0x55 |
| 102635 | hbus monitor | Collected WRITE addr=0x115e data=0x55 |
| 102665 | hbus monitor | Collected READ  addr=0x115e data=0x55 |
| 102685 | hbus monitor | Collected WRITE addr=0x115f data=0x55 |
| 102715 | hbus monitor | Collected READ  addr=0x115f data=0x55 |
| 102735 | hbus monitor | Collected WRITE addr=0x1160 data=0x55 |
| 102765 | hbus monitor | Collected READ  addr=0x1160 data=0x55 |
| 102785 | hbus monitor | Collected WRITE addr=0x1161 data=0x55 |
| 102815 | hbus monitor | Collected READ  addr=0x1161 data=0x55 |
| 102835 | hbus monitor | Collected WRITE addr=0x1162 data=0x55 |
| 102865 | hbus monitor | Collected READ  addr=0x1162 data=0x55 |
| 102885 | hbus monitor | Collected WRITE addr=0x1163 data=0x55 |
| 102915 | hbus monitor | Collected READ  addr=0x1163 data=0x55 |
| 102935 | hbus monitor | Collected WRITE addr=0x1164 data=0x55 |
| 102965 | hbus monitor | Collected READ  addr=0x1164 data=0x55 |
| 102985 | hbus monitor | Collected WRITE addr=0x1165 data=0x55 |
| 103015 | hbus monitor | Collected READ  addr=0x1165 data=0x55 |
| 103035 | hbus monitor | Collected WRITE addr=0x1166 data=0x55 |
| 103065 | hbus monitor | Collected READ  addr=0x1166 data=0x55 |
| 103085 | hbus monitor | Collected WRITE addr=0x1167 data=0x55 |
| 103115 | hbus monitor | Collected READ  addr=0x1167 data=0x55 |
| 103135 | hbus monitor | Collected WRITE addr=0x1168 data=0x55 |
| 103165 | hbus monitor | Collected READ  addr=0x1168 data=0x55 |
| 103185 | hbus monitor | Collected WRITE addr=0x1169 data=0x55 |
| 103215 | hbus monitor | Collected READ  addr=0x1169 data=0x55 |
| 103235 | hbus monitor | Collected WRITE addr=0x116a data=0x55 |
| 103265 | hbus monitor | Collected READ  addr=0x116a data=0x55 |
| 103285 | hbus monitor | Collected WRITE addr=0x116b data=0x55 |
| 103315 | hbus monitor | Collected READ  addr=0x116b data=0x55 |
| 103335 | hbus monitor | Collected WRITE addr=0x116c data=0x55 |
| 103365 | hbus monitor | Collected READ  addr=0x116c data=0x55 |
| 103385 | hbus monitor | Collected WRITE addr=0x116d data=0x55 |
| 103415 | hbus monitor | Collected READ  addr=0x116d data=0x55 |
| 103435 | hbus monitor | Collected WRITE addr=0x116e data=0x55 |
| 103465 | hbus monitor | Collected READ  addr=0x116e data=0x55 |
| 103485 | hbus monitor | Collected WRITE addr=0x116f data=0x55 |
| 103515 | hbus monitor | Collected READ  addr=0x116f data=0x55 |
| 103535 | hbus monitor | Collected WRITE addr=0x1170 data=0x55 |
| 103565 | hbus monitor | Collected READ  addr=0x1170 data=0x55 |
| 103585 | hbus monitor | Collected WRITE addr=0x1171 data=0x55 |
| 103615 | hbus monitor | Collected READ  addr=0x1171 data=0x55 |
| 103635 | hbus monitor | Collected WRITE addr=0x1172 data=0x55 |
| 103665 | hbus monitor | Collected READ  addr=0x1172 data=0x55 |
| 103685 | hbus monitor | Collected WRITE addr=0x1173 data=0x55 |
| 103715 | hbus monitor | Collected READ  addr=0x1173 data=0x55 |
| 103735 | hbus monitor | Collected WRITE addr=0x1174 data=0x55 |
| 103765 | hbus monitor | Collected READ  addr=0x1174 data=0x55 |
| 103785 | hbus monitor | Collected WRITE addr=0x1175 data=0x55 |
| 103815 | hbus monitor | Collected READ  addr=0x1175 data=0x55 |
| 103835 | hbus monitor | Collected WRITE addr=0x1176 data=0x55 |
| 103865 | hbus monitor | Collected READ  addr=0x1176 data=0x55 |
| 103885 | hbus monitor | Collected WRITE addr=0x1177 data=0x55 |
| 103915 | hbus monitor | Collected READ  addr=0x1177 data=0x55 |
| 103935 | hbus monitor | Collected WRITE addr=0x1178 data=0x55 |
| 103965 | hbus monitor | Collected READ  addr=0x1178 data=0x55 |
| 103985 | hbus monitor | Collected WRITE addr=0x1179 data=0x55 |
| 104015 | hbus monitor | Collected READ  addr=0x1179 data=0x55 |
| 104035 | hbus monitor | Collected WRITE addr=0x117a data=0x55 |
| 104065 | hbus monitor | Collected READ  addr=0x117a data=0x55 |
| 104085 | hbus monitor | Collected WRITE addr=0x117b data=0x55 |
| 104115 | hbus monitor | Collected READ  addr=0x117b data=0x55 |
| 104135 | hbus monitor | Collected WRITE addr=0x117c data=0x55 |
| 104165 | hbus monitor | Collected READ  addr=0x117c data=0x55 |
| 104185 | hbus monitor | Collected WRITE addr=0x117d data=0x55 |
| 104215 | hbus monitor | Collected READ  addr=0x117d data=0x55 |
| 104235 | hbus monitor | Collected WRITE addr=0x117e data=0x55 |
| 104265 | hbus monitor | Collected READ  addr=0x117e data=0x55 |
| 104285 | hbus monitor | Collected WRITE addr=0x117f data=0x55 |
| 104315 | hbus monitor | Collected READ  addr=0x117f data=0x55 |
| 104335 | hbus monitor | Collected WRITE addr=0x1180 data=0x55 |
| 104365 | hbus monitor | Collected READ  addr=0x1180 data=0x55 |
| 104385 | hbus monitor | Collected WRITE addr=0x1181 data=0x55 |
| 104415 | hbus monitor | Collected READ  addr=0x1181 data=0x55 |
| 104435 | hbus monitor | Collected WRITE addr=0x1182 data=0x55 |
| 104465 | hbus monitor | Collected READ  addr=0x1182 data=0x55 |
| 104485 | hbus monitor | Collected WRITE addr=0x1183 data=0x55 |
| 104515 | hbus monitor | Collected READ  addr=0x1183 data=0x55 |
| 104535 | hbus monitor | Collected WRITE addr=0x1184 data=0x55 |
| 104565 | hbus monitor | Collected READ  addr=0x1184 data=0x55 |
| 104585 | hbus monitor | Collected WRITE addr=0x1185 data=0x55 |
| 104615 | hbus monitor | Collected READ  addr=0x1185 data=0x55 |
| 104635 | hbus monitor | Collected WRITE addr=0x1186 data=0x55 |
| 104665 | hbus monitor | Collected READ  addr=0x1186 data=0x55 |
| 104685 | hbus monitor | Collected WRITE addr=0x1187 data=0x55 |
| 104715 | hbus monitor | Collected READ  addr=0x1187 data=0x55 |
| 104735 | hbus monitor | Collected WRITE addr=0x1188 data=0x55 |
| 104765 | hbus monitor | Collected READ  addr=0x1188 data=0x55 |
| 104785 | hbus monitor | Collected WRITE addr=0x1189 data=0x55 |
| 104815 | hbus monitor | Collected READ  addr=0x1189 data=0x55 |
| 104835 | hbus monitor | Collected WRITE addr=0x118a data=0x55 |
| 104865 | hbus monitor | Collected READ  addr=0x118a data=0x55 |
| 104885 | hbus monitor | Collected WRITE addr=0x118b data=0x55 |
| 104915 | hbus monitor | Collected READ  addr=0x118b data=0x55 |
| 104935 | hbus monitor | Collected WRITE addr=0x118c data=0x55 |
| 104965 | hbus monitor | Collected READ  addr=0x118c data=0x55 |
| 104985 | hbus monitor | Collected WRITE addr=0x118d data=0x55 |
| 105015 | hbus monitor | Collected READ  addr=0x118d data=0x55 |
| 105035 | hbus monitor | Collected WRITE addr=0x118e data=0x55 |
| 105065 | hbus monitor | Collected READ  addr=0x118e data=0x55 |
| 105085 | hbus monitor | Collected WRITE addr=0x118f data=0x55 |
| 105115 | hbus monitor | Collected READ  addr=0x118f data=0x55 |
| 105135 | hbus monitor | Collected WRITE addr=0x1190 data=0x55 |
| 105165 | hbus monitor | Collected READ  addr=0x1190 data=0x55 |
| 105185 | hbus monitor | Collected WRITE addr=0x1191 data=0x55 |
| 105215 | hbus monitor | Collected READ  addr=0x1191 data=0x55 |
| 105235 | hbus monitor | Collected WRITE addr=0x1192 data=0x55 |
| 105265 | hbus monitor | Collected READ  addr=0x1192 data=0x55 |
| 105285 | hbus monitor | Collected WRITE addr=0x1193 data=0x55 |
| 105315 | hbus monitor | Collected READ  addr=0x1193 data=0x55 |
| 105335 | hbus monitor | Collected WRITE addr=0x1194 data=0x55 |
| 105365 | hbus monitor | Collected READ  addr=0x1194 data=0x55 |
| 105385 | hbus monitor | Collected WRITE addr=0x1195 data=0x55 |
| 105415 | hbus monitor | Collected READ  addr=0x1195 data=0x55 |
| 105435 | hbus monitor | Collected WRITE addr=0x1196 data=0x55 |
| 105465 | hbus monitor | Collected READ  addr=0x1196 data=0x55 |
| 105485 | hbus monitor | Collected WRITE addr=0x1197 data=0x55 |
| 105515 | hbus monitor | Collected READ  addr=0x1197 data=0x55 |
| 105535 | hbus monitor | Collected WRITE addr=0x1198 data=0x55 |
| 105565 | hbus monitor | Collected READ  addr=0x1198 data=0x55 |
| 105585 | hbus monitor | Collected WRITE addr=0x1199 data=0x55 |
| 105615 | hbus monitor | Collected READ  addr=0x1199 data=0x55 |
| 105635 | hbus monitor | Collected WRITE addr=0x119a data=0x55 |
| 105665 | hbus monitor | Collected READ  addr=0x119a data=0x55 |
| 105685 | hbus monitor | Collected WRITE addr=0x119b data=0x55 |
| 105715 | hbus monitor | Collected READ  addr=0x119b data=0x55 |
| 105735 | hbus monitor | Collected WRITE addr=0x119c data=0x55 |
| 105765 | hbus monitor | Collected READ  addr=0x119c data=0x55 |
| 105785 | hbus monitor | Collected WRITE addr=0x119d data=0x55 |
| 105815 | hbus monitor | Collected READ  addr=0x119d data=0x55 |
| 105835 | hbus monitor | Collected WRITE addr=0x119e data=0x55 |
| 105865 | hbus monitor | Collected READ  addr=0x119e data=0x55 |
| 105885 | hbus monitor | Collected WRITE addr=0x119f data=0x55 |
| 105915 | hbus monitor | Collected READ  addr=0x119f data=0x55 |
| 105935 | hbus monitor | Collected WRITE addr=0x11a0 data=0x55 |
| 105965 | hbus monitor | Collected READ  addr=0x11a0 data=0x55 |
| 105985 | hbus monitor | Collected WRITE addr=0x11a1 data=0x55 |
| 106015 | hbus monitor | Collected READ  addr=0x11a1 data=0x55 |
| 106035 | hbus monitor | Collected WRITE addr=0x11a2 data=0x55 |
| 106065 | hbus monitor | Collected READ  addr=0x11a2 data=0x55 |
| 106085 | hbus monitor | Collected WRITE addr=0x11a3 data=0x55 |
| 106115 | hbus monitor | Collected READ  addr=0x11a3 data=0x55 |
| 106135 | hbus monitor | Collected WRITE addr=0x11a4 data=0x55 |
| 106165 | hbus monitor | Collected READ  addr=0x11a4 data=0x55 |
| 106185 | hbus monitor | Collected WRITE addr=0x11a5 data=0x55 |
| 106215 | hbus monitor | Collected READ  addr=0x11a5 data=0x55 |
| 106235 | hbus monitor | Collected WRITE addr=0x11a6 data=0x55 |
| 106265 | hbus monitor | Collected READ  addr=0x11a6 data=0x55 |
| 106285 | hbus monitor | Collected WRITE addr=0x11a7 data=0x55 |
| 106315 | hbus monitor | Collected READ  addr=0x11a7 data=0x55 |
| 106335 | hbus monitor | Collected WRITE addr=0x11a8 data=0x55 |
| 106365 | hbus monitor | Collected READ  addr=0x11a8 data=0x55 |
| 106385 | hbus monitor | Collected WRITE addr=0x11a9 data=0x55 |
| 106415 | hbus monitor | Collected READ  addr=0x11a9 data=0x55 |
| 106435 | hbus monitor | Collected WRITE addr=0x11aa data=0x55 |
| 106465 | hbus monitor | Collected READ  addr=0x11aa data=0x55 |
| 106485 | hbus monitor | Collected WRITE addr=0x11ab data=0x55 |
| 106515 | hbus monitor | Collected READ  addr=0x11ab data=0x55 |
| 106535 | hbus monitor | Collected WRITE addr=0x11ac data=0x55 |
| 106565 | hbus monitor | Collected READ  addr=0x11ac data=0x55 |
| 106585 | hbus monitor | Collected WRITE addr=0x11ad data=0x55 |
| 106615 | hbus monitor | Collected READ  addr=0x11ad data=0x55 |
| 106635 | hbus monitor | Collected WRITE addr=0x11ae data=0x55 |
| 106665 | hbus monitor | Collected READ  addr=0x11ae data=0x55 |
| 106685 | hbus monitor | Collected WRITE addr=0x11af data=0x55 |
| 106715 | hbus monitor | Collected READ  addr=0x11af data=0x55 |
| 106735 | hbus monitor | Collected WRITE addr=0x11b0 data=0x55 |
| 106765 | hbus monitor | Collected READ  addr=0x11b0 data=0x55 |
| 106785 | hbus monitor | Collected WRITE addr=0x11b1 data=0x55 |
| 106815 | hbus monitor | Collected READ  addr=0x11b1 data=0x55 |
| 106835 | hbus monitor | Collected WRITE addr=0x11b2 data=0x55 |
| 106865 | hbus monitor | Collected READ  addr=0x11b2 data=0x55 |
| 106885 | hbus monitor | Collected WRITE addr=0x11b3 data=0x55 |
| 106915 | hbus monitor | Collected READ  addr=0x11b3 data=0x55 |
| 106935 | hbus monitor | Collected WRITE addr=0x11b4 data=0x55 |
| 106965 | hbus monitor | Collected READ  addr=0x11b4 data=0x55 |
| 106985 | hbus monitor | Collected WRITE addr=0x11b5 data=0x55 |
| 107015 | hbus monitor | Collected READ  addr=0x11b5 data=0x55 |
| 107035 | hbus monitor | Collected WRITE addr=0x11b6 data=0x55 |
| 107065 | hbus monitor | Collected READ  addr=0x11b6 data=0x55 |
| 107085 | hbus monitor | Collected WRITE addr=0x11b7 data=0x55 |
| 107115 | hbus monitor | Collected READ  addr=0x11b7 data=0x55 |
| 107135 | hbus monitor | Collected WRITE addr=0x11b8 data=0x55 |
| 107165 | hbus monitor | Collected READ  addr=0x11b8 data=0x55 |
| 107185 | hbus monitor | Collected WRITE addr=0x11b9 data=0x55 |
| 107215 | hbus monitor | Collected READ  addr=0x11b9 data=0x55 |
| 107235 | hbus monitor | Collected WRITE addr=0x11ba data=0x55 |
| 107265 | hbus monitor | Collected READ  addr=0x11ba data=0x55 |
| 107285 | hbus monitor | Collected WRITE addr=0x11bb data=0x55 |
| 107315 | hbus monitor | Collected READ  addr=0x11bb data=0x55 |
| 107335 | hbus monitor | Collected WRITE addr=0x11bc data=0x55 |
| 107365 | hbus monitor | Collected READ  addr=0x11bc data=0x55 |
| 107385 | hbus monitor | Collected WRITE addr=0x11bd data=0x55 |
| 107415 | hbus monitor | Collected READ  addr=0x11bd data=0x55 |
| 107435 | hbus monitor | Collected WRITE addr=0x11be data=0x55 |
| 107465 | hbus monitor | Collected READ  addr=0x11be data=0x55 |
| 107485 | hbus monitor | Collected WRITE addr=0x11bf data=0x55 |
| 107515 | hbus monitor | Collected READ  addr=0x11bf data=0x55 |
| 107535 | hbus monitor | Collected WRITE addr=0x11c0 data=0x55 |
| 107565 | hbus monitor | Collected READ  addr=0x11c0 data=0x55 |
| 107585 | hbus monitor | Collected WRITE addr=0x11c1 data=0x55 |
| 107615 | hbus monitor | Collected READ  addr=0x11c1 data=0x55 |
| 107635 | hbus monitor | Collected WRITE addr=0x11c2 data=0x55 |
| 107665 | hbus monitor | Collected READ  addr=0x11c2 data=0x55 |
| 107685 | hbus monitor | Collected WRITE addr=0x11c3 data=0x55 |
| 107715 | hbus monitor | Collected READ  addr=0x11c3 data=0x55 |
| 107735 | hbus monitor | Collected WRITE addr=0x11c4 data=0x55 |
| 107765 | hbus monitor | Collected READ  addr=0x11c4 data=0x55 |
| 107785 | hbus monitor | Collected WRITE addr=0x11c5 data=0x55 |
| 107815 | hbus monitor | Collected READ  addr=0x11c5 data=0x55 |
| 107835 | hbus monitor | Collected WRITE addr=0x11c6 data=0x55 |
| 107865 | hbus monitor | Collected READ  addr=0x11c6 data=0x55 |
| 107885 | hbus monitor | Collected WRITE addr=0x11c7 data=0x55 |
| 107915 | hbus monitor | Collected READ  addr=0x11c7 data=0x55 |
| 107935 | hbus monitor | Collected WRITE addr=0x11c8 data=0x55 |
| 107965 | hbus monitor | Collected READ  addr=0x11c8 data=0x55 |
| 107985 | hbus monitor | Collected WRITE addr=0x11c9 data=0x55 |
| 108015 | hbus monitor | Collected READ  addr=0x11c9 data=0x55 |
| 108035 | hbus monitor | Collected WRITE addr=0x11ca data=0x55 |
| 108065 | hbus monitor | Collected READ  addr=0x11ca data=0x55 |
| 108085 | hbus monitor | Collected WRITE addr=0x11cb data=0x55 |
| 108115 | hbus monitor | Collected READ  addr=0x11cb data=0x55 |
| 108135 | hbus monitor | Collected WRITE addr=0x11cc data=0x55 |
| 108165 | hbus monitor | Collected READ  addr=0x11cc data=0x55 |
| 108185 | hbus monitor | Collected WRITE addr=0x11cd data=0x55 |
| 108215 | hbus monitor | Collected READ  addr=0x11cd data=0x55 |
| 108235 | hbus monitor | Collected WRITE addr=0x11ce data=0x55 |
| 108265 | hbus monitor | Collected READ  addr=0x11ce data=0x55 |
| 108285 | hbus monitor | Collected WRITE addr=0x11cf data=0x55 |
| 108315 | hbus monitor | Collected READ  addr=0x11cf data=0x55 |
| 108335 | hbus monitor | Collected WRITE addr=0x11d0 data=0x55 |
| 108365 | hbus monitor | Collected READ  addr=0x11d0 data=0x55 |
| 108385 | hbus monitor | Collected WRITE addr=0x11d1 data=0x55 |
| 108415 | hbus monitor | Collected READ  addr=0x11d1 data=0x55 |
| 108435 | hbus monitor | Collected WRITE addr=0x11d2 data=0x55 |
| 108465 | hbus monitor | Collected READ  addr=0x11d2 data=0x55 |
| 108485 | hbus monitor | Collected WRITE addr=0x11d3 data=0x55 |
| 108515 | hbus monitor | Collected READ  addr=0x11d3 data=0x55 |
| 108535 | hbus monitor | Collected WRITE addr=0x11d4 data=0x55 |
| 108565 | hbus monitor | Collected READ  addr=0x11d4 data=0x55 |
| 108585 | hbus monitor | Collected WRITE addr=0x11d5 data=0x55 |
| 108615 | hbus monitor | Collected READ  addr=0x11d5 data=0x55 |
| 108635 | hbus monitor | Collected WRITE addr=0x11d6 data=0x55 |
| 108665 | hbus monitor | Collected READ  addr=0x11d6 data=0x55 |
| 108685 | hbus monitor | Collected WRITE addr=0x11d7 data=0x55 |
| 108715 | hbus monitor | Collected READ  addr=0x11d7 data=0x55 |
| 108735 | hbus monitor | Collected WRITE addr=0x11d8 data=0x55 |
| 108765 | hbus monitor | Collected READ  addr=0x11d8 data=0x55 |
| 108785 | hbus monitor | Collected WRITE addr=0x11d9 data=0x55 |
| 108815 | hbus monitor | Collected READ  addr=0x11d9 data=0x55 |
| 108835 | hbus monitor | Collected WRITE addr=0x11da data=0x55 |
| 108865 | hbus monitor | Collected READ  addr=0x11da data=0x55 |
| 108885 | hbus monitor | Collected WRITE addr=0x11db data=0x55 |
| 108915 | hbus monitor | Collected READ  addr=0x11db data=0x55 |
| 108935 | hbus monitor | Collected WRITE addr=0x11dc data=0x55 |
| 108965 | hbus monitor | Collected READ  addr=0x11dc data=0x55 |
| 108985 | hbus monitor | Collected WRITE addr=0x11dd data=0x55 |
| 109015 | hbus monitor | Collected READ  addr=0x11dd data=0x55 |
| 109035 | hbus monitor | Collected WRITE addr=0x11de data=0x55 |
| 109065 | hbus monitor | Collected READ  addr=0x11de data=0x55 |
| 109085 | hbus monitor | Collected WRITE addr=0x11df data=0x55 |
| 109115 | hbus monitor | Collected READ  addr=0x11df data=0x55 |
| 109135 | hbus monitor | Collected WRITE addr=0x11e0 data=0x55 |
| 109165 | hbus monitor | Collected READ  addr=0x11e0 data=0x55 |
| 109185 | hbus monitor | Collected WRITE addr=0x11e1 data=0x55 |
| 109215 | hbus monitor | Collected READ  addr=0x11e1 data=0x55 |
| 109235 | hbus monitor | Collected WRITE addr=0x11e2 data=0x55 |
| 109265 | hbus monitor | Collected READ  addr=0x11e2 data=0x55 |
| 109285 | hbus monitor | Collected WRITE addr=0x11e3 data=0x55 |
| 109315 | hbus monitor | Collected READ  addr=0x11e3 data=0x55 |
| 109335 | hbus monitor | Collected WRITE addr=0x11e4 data=0x55 |
| 109365 | hbus monitor | Collected READ  addr=0x11e4 data=0x55 |
| 109385 | hbus monitor | Collected WRITE addr=0x11e5 data=0x55 |
| 109415 | hbus monitor | Collected READ  addr=0x11e5 data=0x55 |
| 109435 | hbus monitor | Collected WRITE addr=0x11e6 data=0x55 |
| 109465 | hbus monitor | Collected READ  addr=0x11e6 data=0x55 |
| 109485 | hbus monitor | Collected WRITE addr=0x11e7 data=0x55 |
| 109515 | hbus monitor | Collected READ  addr=0x11e7 data=0x55 |
| 109535 | hbus monitor | Collected WRITE addr=0x11e8 data=0x55 |
| 109565 | hbus monitor | Collected READ  addr=0x11e8 data=0x55 |
| 109585 | hbus monitor | Collected WRITE addr=0x11e9 data=0x55 |
| 109615 | hbus monitor | Collected READ  addr=0x11e9 data=0x55 |
| 109635 | hbus monitor | Collected WRITE addr=0x11ea data=0x55 |
| 109665 | hbus monitor | Collected READ  addr=0x11ea data=0x55 |
| 109685 | hbus monitor | Collected WRITE addr=0x11eb data=0x55 |
| 109715 | hbus monitor | Collected READ  addr=0x11eb data=0x55 |
| 109735 | hbus monitor | Collected WRITE addr=0x11ec data=0x55 |
| 109765 | hbus monitor | Collected READ  addr=0x11ec data=0x55 |
| 109785 | hbus monitor | Collected WRITE addr=0x11ed data=0x55 |
| 109815 | hbus monitor | Collected READ  addr=0x11ed data=0x55 |
| 109835 | hbus monitor | Collected WRITE addr=0x11ee data=0x55 |
| 109865 | hbus monitor | Collected READ  addr=0x11ee data=0x55 |
| 109885 | hbus monitor | Collected WRITE addr=0x11ef data=0x55 |
| 109915 | hbus monitor | Collected READ  addr=0x11ef data=0x55 |
| 109935 | hbus monitor | Collected WRITE addr=0x11f0 data=0x55 |
| 109965 | hbus monitor | Collected READ  addr=0x11f0 data=0x55 |
| 109985 | hbus monitor | Collected WRITE addr=0x11f1 data=0x55 |
| 110015 | hbus monitor | Collected READ  addr=0x11f1 data=0x55 |
| 110035 | hbus monitor | Collected WRITE addr=0x11f2 data=0x55 |
| 110065 | hbus monitor | Collected READ  addr=0x11f2 data=0x55 |
| 110085 | hbus monitor | Collected WRITE addr=0x11f3 data=0x55 |
| 110115 | hbus monitor | Collected READ  addr=0x11f3 data=0x55 |
| 110135 | hbus monitor | Collected WRITE addr=0x11f4 data=0x55 |
| 110165 | hbus monitor | Collected READ  addr=0x11f4 data=0x55 |
| 110185 | hbus monitor | Collected WRITE addr=0x11f5 data=0x55 |
| 110215 | hbus monitor | Collected READ  addr=0x11f5 data=0x55 |
| 110235 | hbus monitor | Collected WRITE addr=0x11f6 data=0x55 |
| 110265 | hbus monitor | Collected READ  addr=0x11f6 data=0x55 |
| 110285 | hbus monitor | Collected WRITE addr=0x11f7 data=0x55 |
| 110315 | hbus monitor | Collected READ  addr=0x11f7 data=0x55 |
| 110335 | hbus monitor | Collected WRITE addr=0x11f8 data=0x55 |
| 110365 | hbus monitor | Collected READ  addr=0x11f8 data=0x55 |
| 110385 | hbus monitor | Collected WRITE addr=0x11f9 data=0x55 |
| 110415 | hbus monitor | Collected READ  addr=0x11f9 data=0x55 |
| 110435 | hbus monitor | Collected WRITE addr=0x11fa data=0x55 |
| 110465 | hbus monitor | Collected READ  addr=0x11fa data=0x55 |
| 110485 | hbus monitor | Collected WRITE addr=0x11fb data=0x55 |
| 110515 | hbus monitor | Collected READ  addr=0x11fb data=0x55 |
| 110535 | hbus monitor | Collected WRITE addr=0x11fc data=0x55 |
| 110565 | hbus monitor | Collected READ  addr=0x11fc data=0x55 |
| 110585 | hbus monitor | Collected WRITE addr=0x11fd data=0x55 |
| 110615 | hbus monitor | Collected READ  addr=0x11fd data=0x55 |
| 110635 | hbus monitor | Collected WRITE addr=0x11fe data=0x55 |
| 110665 | hbus monitor | Collected READ  addr=0x11fe data=0x55 |
| 110685 | hbus monitor | Collected WRITE addr=0x11ff data=0x55 |
| 110715 | hbus monitor | Collected READ  addr=0x11ff data=0x55 |
| 110735 | hbus monitor | Collected WRITE addr=0x1100 data=0xaa |
| 110765 | hbus monitor | Collected READ  addr=0x1100 data=0xaa |
| 110785 | hbus monitor | Collected WRITE addr=0x1101 data=0xaa |
| 110815 | hbus monitor | Collected READ  addr=0x1101 data=0xaa |
| 110835 | hbus monitor | Collected WRITE addr=0x1102 data=0xaa |
| 110865 | hbus monitor | Collected READ  addr=0x1102 data=0xaa |
| 110885 | hbus monitor | Collected WRITE addr=0x1103 data=0xaa |
| 110915 | hbus monitor | Collected READ  addr=0x1103 data=0xaa |
| 110935 | hbus monitor | Collected WRITE addr=0x1104 data=0xaa |
| 110965 | hbus monitor | Collected READ  addr=0x1104 data=0xaa |
| 110985 | hbus monitor | Collected WRITE addr=0x1105 data=0xaa |
| 111015 | hbus monitor | Collected READ  addr=0x1105 data=0xaa |
| 111035 | hbus monitor | Collected WRITE addr=0x1106 data=0xaa |
| 111065 | hbus monitor | Collected READ  addr=0x1106 data=0xaa |
| 111085 | hbus monitor | Collected WRITE addr=0x1107 data=0xaa |
| 111115 | hbus monitor | Collected READ  addr=0x1107 data=0xaa |
| 111135 | hbus monitor | Collected WRITE addr=0x1108 data=0xaa |
| 111165 | hbus monitor | Collected READ  addr=0x1108 data=0xaa |
| 111185 | hbus monitor | Collected WRITE addr=0x1109 data=0xaa |
| 111215 | hbus monitor | Collected READ  addr=0x1109 data=0xaa |
| 111235 | hbus monitor | Collected WRITE addr=0x110a data=0xaa |
| 111265 | hbus monitor | Collected READ  addr=0x110a data=0xaa |
| 111285 | hbus monitor | Collected WRITE addr=0x110b data=0xaa |
| 111315 | hbus monitor | Collected READ  addr=0x110b data=0xaa |
| 111335 | hbus monitor | Collected WRITE addr=0x110c data=0xaa |
| 111365 | hbus monitor | Collected READ  addr=0x110c data=0xaa |
| 111385 | hbus monitor | Collected WRITE addr=0x110d data=0xaa |
| 111415 | hbus monitor | Collected READ  addr=0x110d data=0xaa |
| 111435 | hbus monitor | Collected WRITE addr=0x110e data=0xaa |
| 111465 | hbus monitor | Collected READ  addr=0x110e data=0xaa |
| 111485 | hbus monitor | Collected WRITE addr=0x110f data=0xaa |
| 111515 | hbus monitor | Collected READ  addr=0x110f data=0xaa |
| 111535 | hbus monitor | Collected WRITE addr=0x1110 data=0xaa |
| 111565 | hbus monitor | Collected READ  addr=0x1110 data=0xaa |
| 111585 | hbus monitor | Collected WRITE addr=0x1111 data=0xaa |
| 111615 | hbus monitor | Collected READ  addr=0x1111 data=0xaa |
| 111635 | hbus monitor | Collected WRITE addr=0x1112 data=0xaa |
| 111665 | hbus monitor | Collected READ  addr=0x1112 data=0xaa |
| 111685 | hbus monitor | Collected WRITE addr=0x1113 data=0xaa |
| 111715 | hbus monitor | Collected READ  addr=0x1113 data=0xaa |
| 111735 | hbus monitor | Collected WRITE addr=0x1114 data=0xaa |
| 111765 | hbus monitor | Collected READ  addr=0x1114 data=0xaa |
| 111785 | hbus monitor | Collected WRITE addr=0x1115 data=0xaa |
| 111815 | hbus monitor | Collected READ  addr=0x1115 data=0xaa |
| 111835 | hbus monitor | Collected WRITE addr=0x1116 data=0xaa |
| 111865 | hbus monitor | Collected READ  addr=0x1116 data=0xaa |
| 111885 | hbus monitor | Collected WRITE addr=0x1117 data=0xaa |
| 111915 | hbus monitor | Collected READ  addr=0x1117 data=0xaa |
| 111935 | hbus monitor | Collected WRITE addr=0x1118 data=0xaa |
| 111965 | hbus monitor | Collected READ  addr=0x1118 data=0xaa |
| 111985 | hbus monitor | Collected WRITE addr=0x1119 data=0xaa |
| 112015 | hbus monitor | Collected READ  addr=0x1119 data=0xaa |
| 112035 | hbus monitor | Collected WRITE addr=0x111a data=0xaa |
| 112065 | hbus monitor | Collected READ  addr=0x111a data=0xaa |
| 112085 | hbus monitor | Collected WRITE addr=0x111b data=0xaa |
| 112115 | hbus monitor | Collected READ  addr=0x111b data=0xaa |
| 112135 | hbus monitor | Collected WRITE addr=0x111c data=0xaa |
| 112165 | hbus monitor | Collected READ  addr=0x111c data=0xaa |
| 112185 | hbus monitor | Collected WRITE addr=0x111d data=0xaa |
| 112215 | hbus monitor | Collected READ  addr=0x111d data=0xaa |
| 112235 | hbus monitor | Collected WRITE addr=0x111e data=0xaa |
| 112265 | hbus monitor | Collected READ  addr=0x111e data=0xaa |
| 112285 | hbus monitor | Collected WRITE addr=0x111f data=0xaa |
| 112315 | hbus monitor | Collected READ  addr=0x111f data=0xaa |
| 112335 | hbus monitor | Collected WRITE addr=0x1120 data=0xaa |
| 112365 | hbus monitor | Collected READ  addr=0x1120 data=0xaa |
| 112385 | hbus monitor | Collected WRITE addr=0x1121 data=0xaa |
| 112415 | hbus monitor | Collected READ  addr=0x1121 data=0xaa |
| 112435 | hbus monitor | Collected WRITE addr=0x1122 data=0xaa |
| 112465 | hbus monitor | Collected READ  addr=0x1122 data=0xaa |
| 112485 | hbus monitor | Collected WRITE addr=0x1123 data=0xaa |
| 112515 | hbus monitor | Collected READ  addr=0x1123 data=0xaa |
| 112535 | hbus monitor | Collected WRITE addr=0x1124 data=0xaa |
| 112565 | hbus monitor | Collected READ  addr=0x1124 data=0xaa |
| 112585 | hbus monitor | Collected WRITE addr=0x1125 data=0xaa |
| 112615 | hbus monitor | Collected READ  addr=0x1125 data=0xaa |
| 112635 | hbus monitor | Collected WRITE addr=0x1126 data=0xaa |
| 112665 | hbus monitor | Collected READ  addr=0x1126 data=0xaa |
| 112685 | hbus monitor | Collected WRITE addr=0x1127 data=0xaa |
| 112715 | hbus monitor | Collected READ  addr=0x1127 data=0xaa |
| 112735 | hbus monitor | Collected WRITE addr=0x1128 data=0xaa |
| 112765 | hbus monitor | Collected READ  addr=0x1128 data=0xaa |
| 112785 | hbus monitor | Collected WRITE addr=0x1129 data=0xaa |
| 112815 | hbus monitor | Collected READ  addr=0x1129 data=0xaa |
| 112835 | hbus monitor | Collected WRITE addr=0x112a data=0xaa |
| 112865 | hbus monitor | Collected READ  addr=0x112a data=0xaa |
| 112885 | hbus monitor | Collected WRITE addr=0x112b data=0xaa |
| 112915 | hbus monitor | Collected READ  addr=0x112b data=0xaa |
| 112935 | hbus monitor | Collected WRITE addr=0x112c data=0xaa |
| 112965 | hbus monitor | Collected READ  addr=0x112c data=0xaa |
| 112985 | hbus monitor | Collected WRITE addr=0x112d data=0xaa |
| 113015 | hbus monitor | Collected READ  addr=0x112d data=0xaa |
| 113035 | hbus monitor | Collected WRITE addr=0x112e data=0xaa |
| 113065 | hbus monitor | Collected READ  addr=0x112e data=0xaa |
| 113085 | hbus monitor | Collected WRITE addr=0x112f data=0xaa |
| 113115 | hbus monitor | Collected READ  addr=0x112f data=0xaa |
| 113135 | hbus monitor | Collected WRITE addr=0x1130 data=0xaa |
| 113165 | hbus monitor | Collected READ  addr=0x1130 data=0xaa |
| 113185 | hbus monitor | Collected WRITE addr=0x1131 data=0xaa |
| 113215 | hbus monitor | Collected READ  addr=0x1131 data=0xaa |
| 113235 | hbus monitor | Collected WRITE addr=0x1132 data=0xaa |
| 113265 | hbus monitor | Collected READ  addr=0x1132 data=0xaa |
| 113285 | hbus monitor | Collected WRITE addr=0x1133 data=0xaa |
| 113315 | hbus monitor | Collected READ  addr=0x1133 data=0xaa |
| 113335 | hbus monitor | Collected WRITE addr=0x1134 data=0xaa |
| 113365 | hbus monitor | Collected READ  addr=0x1134 data=0xaa |
| 113385 | hbus monitor | Collected WRITE addr=0x1135 data=0xaa |
| 113415 | hbus monitor | Collected READ  addr=0x1135 data=0xaa |
| 113435 | hbus monitor | Collected WRITE addr=0x1136 data=0xaa |
| 113465 | hbus monitor | Collected READ  addr=0x1136 data=0xaa |
| 113485 | hbus monitor | Collected WRITE addr=0x1137 data=0xaa |
| 113515 | hbus monitor | Collected READ  addr=0x1137 data=0xaa |
| 113535 | hbus monitor | Collected WRITE addr=0x1138 data=0xaa |
| 113565 | hbus monitor | Collected READ  addr=0x1138 data=0xaa |
| 113585 | hbus monitor | Collected WRITE addr=0x1139 data=0xaa |
| 113615 | hbus monitor | Collected READ  addr=0x1139 data=0xaa |
| 113635 | hbus monitor | Collected WRITE addr=0x113a data=0xaa |
| 113665 | hbus monitor | Collected READ  addr=0x113a data=0xaa |
| 113685 | hbus monitor | Collected WRITE addr=0x113b data=0xaa |
| 113715 | hbus monitor | Collected READ  addr=0x113b data=0xaa |
| 113735 | hbus monitor | Collected WRITE addr=0x113c data=0xaa |
| 113765 | hbus monitor | Collected READ  addr=0x113c data=0xaa |
| 113785 | hbus monitor | Collected WRITE addr=0x113d data=0xaa |
| 113815 | hbus monitor | Collected READ  addr=0x113d data=0xaa |
| 113835 | hbus monitor | Collected WRITE addr=0x113e data=0xaa |
| 113865 | hbus monitor | Collected READ  addr=0x113e data=0xaa |
| 113885 | hbus monitor | Collected WRITE addr=0x113f data=0xaa |
| 113915 | hbus monitor | Collected READ  addr=0x113f data=0xaa |
| 113935 | hbus monitor | Collected WRITE addr=0x1140 data=0xaa |
| 113965 | hbus monitor | Collected READ  addr=0x1140 data=0xaa |
| 113985 | hbus monitor | Collected WRITE addr=0x1141 data=0xaa |
| 114015 | hbus monitor | Collected READ  addr=0x1141 data=0xaa |
| 114035 | hbus monitor | Collected WRITE addr=0x1142 data=0xaa |
| 114065 | hbus monitor | Collected READ  addr=0x1142 data=0xaa |
| 114085 | hbus monitor | Collected WRITE addr=0x1143 data=0xaa |
| 114115 | hbus monitor | Collected READ  addr=0x1143 data=0xaa |
| 114135 | hbus monitor | Collected WRITE addr=0x1144 data=0xaa |
| 114165 | hbus monitor | Collected READ  addr=0x1144 data=0xaa |
| 114185 | hbus monitor | Collected WRITE addr=0x1145 data=0xaa |
| 114215 | hbus monitor | Collected READ  addr=0x1145 data=0xaa |
| 114235 | hbus monitor | Collected WRITE addr=0x1146 data=0xaa |
| 114265 | hbus monitor | Collected READ  addr=0x1146 data=0xaa |
| 114285 | hbus monitor | Collected WRITE addr=0x1147 data=0xaa |
| 114315 | hbus monitor | Collected READ  addr=0x1147 data=0xaa |
| 114335 | hbus monitor | Collected WRITE addr=0x1148 data=0xaa |
| 114365 | hbus monitor | Collected READ  addr=0x1148 data=0xaa |
| 114385 | hbus monitor | Collected WRITE addr=0x1149 data=0xaa |
| 114415 | hbus monitor | Collected READ  addr=0x1149 data=0xaa |
| 114435 | hbus monitor | Collected WRITE addr=0x114a data=0xaa |
| 114465 | hbus monitor | Collected READ  addr=0x114a data=0xaa |
| 114485 | hbus monitor | Collected WRITE addr=0x114b data=0xaa |
| 114515 | hbus monitor | Collected READ  addr=0x114b data=0xaa |
| 114535 | hbus monitor | Collected WRITE addr=0x114c data=0xaa |
| 114565 | hbus monitor | Collected READ  addr=0x114c data=0xaa |
| 114585 | hbus monitor | Collected WRITE addr=0x114d data=0xaa |
| 114615 | hbus monitor | Collected READ  addr=0x114d data=0xaa |
| 114635 | hbus monitor | Collected WRITE addr=0x114e data=0xaa |
| 114665 | hbus monitor | Collected READ  addr=0x114e data=0xaa |
| 114685 | hbus monitor | Collected WRITE addr=0x114f data=0xaa |
| 114715 | hbus monitor | Collected READ  addr=0x114f data=0xaa |
| 114735 | hbus monitor | Collected WRITE addr=0x1150 data=0xaa |
| 114765 | hbus monitor | Collected READ  addr=0x1150 data=0xaa |
| 114785 | hbus monitor | Collected WRITE addr=0x1151 data=0xaa |
| 114815 | hbus monitor | Collected READ  addr=0x1151 data=0xaa |
| 114835 | hbus monitor | Collected WRITE addr=0x1152 data=0xaa |
| 114865 | hbus monitor | Collected READ  addr=0x1152 data=0xaa |
| 114885 | hbus monitor | Collected WRITE addr=0x1153 data=0xaa |
| 114915 | hbus monitor | Collected READ  addr=0x1153 data=0xaa |
| 114935 | hbus monitor | Collected WRITE addr=0x1154 data=0xaa |
| 114965 | hbus monitor | Collected READ  addr=0x1154 data=0xaa |
| 114985 | hbus monitor | Collected WRITE addr=0x1155 data=0xaa |
| 115015 | hbus monitor | Collected READ  addr=0x1155 data=0xaa |
| 115035 | hbus monitor | Collected WRITE addr=0x1156 data=0xaa |
| 115065 | hbus monitor | Collected READ  addr=0x1156 data=0xaa |
| 115085 | hbus monitor | Collected WRITE addr=0x1157 data=0xaa |
| 115115 | hbus monitor | Collected READ  addr=0x1157 data=0xaa |
| 115135 | hbus monitor | Collected WRITE addr=0x1158 data=0xaa |
| 115165 | hbus monitor | Collected READ  addr=0x1158 data=0xaa |
| 115185 | hbus monitor | Collected WRITE addr=0x1159 data=0xaa |
| 115215 | hbus monitor | Collected READ  addr=0x1159 data=0xaa |
| 115235 | hbus monitor | Collected WRITE addr=0x115a data=0xaa |
| 115265 | hbus monitor | Collected READ  addr=0x115a data=0xaa |
| 115285 | hbus monitor | Collected WRITE addr=0x115b data=0xaa |
| 115315 | hbus monitor | Collected READ  addr=0x115b data=0xaa |
| 115335 | hbus monitor | Collected WRITE addr=0x115c data=0xaa |
| 115365 | hbus monitor | Collected READ  addr=0x115c data=0xaa |
| 115385 | hbus monitor | Collected WRITE addr=0x115d data=0xaa |
| 115415 | hbus monitor | Collected READ  addr=0x115d data=0xaa |
| 115435 | hbus monitor | Collected WRITE addr=0x115e data=0xaa |
| 115465 | hbus monitor | Collected READ  addr=0x115e data=0xaa |
| 115485 | hbus monitor | Collected WRITE addr=0x115f data=0xaa |
| 115515 | hbus monitor | Collected READ  addr=0x115f data=0xaa |
| 115535 | hbus monitor | Collected WRITE addr=0x1160 data=0xaa |
| 115565 | hbus monitor | Collected READ  addr=0x1160 data=0xaa |
| 115585 | hbus monitor | Collected WRITE addr=0x1161 data=0xaa |
| 115615 | hbus monitor | Collected READ  addr=0x1161 data=0xaa |
| 115635 | hbus monitor | Collected WRITE addr=0x1162 data=0xaa |
| 115665 | hbus monitor | Collected READ  addr=0x1162 data=0xaa |
| 115685 | hbus monitor | Collected WRITE addr=0x1163 data=0xaa |
| 115715 | hbus monitor | Collected READ  addr=0x1163 data=0xaa |
| 115735 | hbus monitor | Collected WRITE addr=0x1164 data=0xaa |
| 115765 | hbus monitor | Collected READ  addr=0x1164 data=0xaa |
| 115785 | hbus monitor | Collected WRITE addr=0x1165 data=0xaa |
| 115815 | hbus monitor | Collected READ  addr=0x1165 data=0xaa |
| 115835 | hbus monitor | Collected WRITE addr=0x1166 data=0xaa |
| 115865 | hbus monitor | Collected READ  addr=0x1166 data=0xaa |
| 115885 | hbus monitor | Collected WRITE addr=0x1167 data=0xaa |
| 115915 | hbus monitor | Collected READ  addr=0x1167 data=0xaa |
| 115935 | hbus monitor | Collected WRITE addr=0x1168 data=0xaa |
| 115965 | hbus monitor | Collected READ  addr=0x1168 data=0xaa |
| 115985 | hbus monitor | Collected WRITE addr=0x1169 data=0xaa |
| 116015 | hbus monitor | Collected READ  addr=0x1169 data=0xaa |
| 116035 | hbus monitor | Collected WRITE addr=0x116a data=0xaa |
| 116065 | hbus monitor | Collected READ  addr=0x116a data=0xaa |
| 116085 | hbus monitor | Collected WRITE addr=0x116b data=0xaa |
| 116115 | hbus monitor | Collected READ  addr=0x116b data=0xaa |
| 116135 | hbus monitor | Collected WRITE addr=0x116c data=0xaa |
| 116165 | hbus monitor | Collected READ  addr=0x116c data=0xaa |
| 116185 | hbus monitor | Collected WRITE addr=0x116d data=0xaa |
| 116215 | hbus monitor | Collected READ  addr=0x116d data=0xaa |
| 116235 | hbus monitor | Collected WRITE addr=0x116e data=0xaa |
| 116265 | hbus monitor | Collected READ  addr=0x116e data=0xaa |
| 116285 | hbus monitor | Collected WRITE addr=0x116f data=0xaa |
| 116315 | hbus monitor | Collected READ  addr=0x116f data=0xaa |
| 116335 | hbus monitor | Collected WRITE addr=0x1170 data=0xaa |
| 116365 | hbus monitor | Collected READ  addr=0x1170 data=0xaa |
| 116385 | hbus monitor | Collected WRITE addr=0x1171 data=0xaa |
| 116415 | hbus monitor | Collected READ  addr=0x1171 data=0xaa |
| 116435 | hbus monitor | Collected WRITE addr=0x1172 data=0xaa |
| 116465 | hbus monitor | Collected READ  addr=0x1172 data=0xaa |
| 116485 | hbus monitor | Collected WRITE addr=0x1173 data=0xaa |
| 116515 | hbus monitor | Collected READ  addr=0x1173 data=0xaa |
| 116535 | hbus monitor | Collected WRITE addr=0x1174 data=0xaa |
| 116565 | hbus monitor | Collected READ  addr=0x1174 data=0xaa |
| 116585 | hbus monitor | Collected WRITE addr=0x1175 data=0xaa |
| 116615 | hbus monitor | Collected READ  addr=0x1175 data=0xaa |
| 116635 | hbus monitor | Collected WRITE addr=0x1176 data=0xaa |
| 116665 | hbus monitor | Collected READ  addr=0x1176 data=0xaa |
| 116685 | hbus monitor | Collected WRITE addr=0x1177 data=0xaa |
| 116715 | hbus monitor | Collected READ  addr=0x1177 data=0xaa |
| 116735 | hbus monitor | Collected WRITE addr=0x1178 data=0xaa |
| 116765 | hbus monitor | Collected READ  addr=0x1178 data=0xaa |
| 116785 | hbus monitor | Collected WRITE addr=0x1179 data=0xaa |
| 116815 | hbus monitor | Collected READ  addr=0x1179 data=0xaa |
| 116835 | hbus monitor | Collected WRITE addr=0x117a data=0xaa |
| 116865 | hbus monitor | Collected READ  addr=0x117a data=0xaa |
| 116885 | hbus monitor | Collected WRITE addr=0x117b data=0xaa |
| 116915 | hbus monitor | Collected READ  addr=0x117b data=0xaa |
| 116935 | hbus monitor | Collected WRITE addr=0x117c data=0xaa |
| 116965 | hbus monitor | Collected READ  addr=0x117c data=0xaa |
| 116985 | hbus monitor | Collected WRITE addr=0x117d data=0xaa |
| 117015 | hbus monitor | Collected READ  addr=0x117d data=0xaa |
| 117035 | hbus monitor | Collected WRITE addr=0x117e data=0xaa |
| 117065 | hbus monitor | Collected READ  addr=0x117e data=0xaa |
| 117085 | hbus monitor | Collected WRITE addr=0x117f data=0xaa |
| 117115 | hbus monitor | Collected READ  addr=0x117f data=0xaa |
| 117135 | hbus monitor | Collected WRITE addr=0x1180 data=0xaa |
| 117165 | hbus monitor | Collected READ  addr=0x1180 data=0xaa |
| 117185 | hbus monitor | Collected WRITE addr=0x1181 data=0xaa |
| 117215 | hbus monitor | Collected READ  addr=0x1181 data=0xaa |
| 117235 | hbus monitor | Collected WRITE addr=0x1182 data=0xaa |
| 117265 | hbus monitor | Collected READ  addr=0x1182 data=0xaa |
| 117285 | hbus monitor | Collected WRITE addr=0x1183 data=0xaa |
| 117315 | hbus monitor | Collected READ  addr=0x1183 data=0xaa |
| 117335 | hbus monitor | Collected WRITE addr=0x1184 data=0xaa |
| 117365 | hbus monitor | Collected READ  addr=0x1184 data=0xaa |
| 117385 | hbus monitor | Collected WRITE addr=0x1185 data=0xaa |
| 117415 | hbus monitor | Collected READ  addr=0x1185 data=0xaa |
| 117435 | hbus monitor | Collected WRITE addr=0x1186 data=0xaa |
| 117465 | hbus monitor | Collected READ  addr=0x1186 data=0xaa |
| 117485 | hbus monitor | Collected WRITE addr=0x1187 data=0xaa |
| 117515 | hbus monitor | Collected READ  addr=0x1187 data=0xaa |
| 117535 | hbus monitor | Collected WRITE addr=0x1188 data=0xaa |
| 117565 | hbus monitor | Collected READ  addr=0x1188 data=0xaa |
| 117585 | hbus monitor | Collected WRITE addr=0x1189 data=0xaa |
| 117615 | hbus monitor | Collected READ  addr=0x1189 data=0xaa |
| 117635 | hbus monitor | Collected WRITE addr=0x118a data=0xaa |
| 117665 | hbus monitor | Collected READ  addr=0x118a data=0xaa |
| 117685 | hbus monitor | Collected WRITE addr=0x118b data=0xaa |
| 117715 | hbus monitor | Collected READ  addr=0x118b data=0xaa |
| 117735 | hbus monitor | Collected WRITE addr=0x118c data=0xaa |
| 117765 | hbus monitor | Collected READ  addr=0x118c data=0xaa |
| 117785 | hbus monitor | Collected WRITE addr=0x118d data=0xaa |
| 117815 | hbus monitor | Collected READ  addr=0x118d data=0xaa |
| 117835 | hbus monitor | Collected WRITE addr=0x118e data=0xaa |
| 117865 | hbus monitor | Collected READ  addr=0x118e data=0xaa |
| 117885 | hbus monitor | Collected WRITE addr=0x118f data=0xaa |
| 117915 | hbus monitor | Collected READ  addr=0x118f data=0xaa |
| 117935 | hbus monitor | Collected WRITE addr=0x1190 data=0xaa |
| 117965 | hbus monitor | Collected READ  addr=0x1190 data=0xaa |
| 117985 | hbus monitor | Collected WRITE addr=0x1191 data=0xaa |
| 118015 | hbus monitor | Collected READ  addr=0x1191 data=0xaa |
| 118035 | hbus monitor | Collected WRITE addr=0x1192 data=0xaa |
| 118065 | hbus monitor | Collected READ  addr=0x1192 data=0xaa |
| 118085 | hbus monitor | Collected WRITE addr=0x1193 data=0xaa |
| 118115 | hbus monitor | Collected READ  addr=0x1193 data=0xaa |
| 118135 | hbus monitor | Collected WRITE addr=0x1194 data=0xaa |
| 118165 | hbus monitor | Collected READ  addr=0x1194 data=0xaa |
| 118185 | hbus monitor | Collected WRITE addr=0x1195 data=0xaa |
| 118215 | hbus monitor | Collected READ  addr=0x1195 data=0xaa |
| 118235 | hbus monitor | Collected WRITE addr=0x1196 data=0xaa |
| 118265 | hbus monitor | Collected READ  addr=0x1196 data=0xaa |
| 118285 | hbus monitor | Collected WRITE addr=0x1197 data=0xaa |
| 118315 | hbus monitor | Collected READ  addr=0x1197 data=0xaa |
| 118335 | hbus monitor | Collected WRITE addr=0x1198 data=0xaa |
| 118365 | hbus monitor | Collected READ  addr=0x1198 data=0xaa |
| 118385 | hbus monitor | Collected WRITE addr=0x1199 data=0xaa |
| 118415 | hbus monitor | Collected READ  addr=0x1199 data=0xaa |
| 118435 | hbus monitor | Collected WRITE addr=0x119a data=0xaa |
| 118465 | hbus monitor | Collected READ  addr=0x119a data=0xaa |
| 118485 | hbus monitor | Collected WRITE addr=0x119b data=0xaa |
| 118515 | hbus monitor | Collected READ  addr=0x119b data=0xaa |
| 118535 | hbus monitor | Collected WRITE addr=0x119c data=0xaa |
| 118565 | hbus monitor | Collected READ  addr=0x119c data=0xaa |
| 118585 | hbus monitor | Collected WRITE addr=0x119d data=0xaa |
| 118615 | hbus monitor | Collected READ  addr=0x119d data=0xaa |
| 118635 | hbus monitor | Collected WRITE addr=0x119e data=0xaa |
| 118665 | hbus monitor | Collected READ  addr=0x119e data=0xaa |
| 118685 | hbus monitor | Collected WRITE addr=0x119f data=0xaa |
| 118715 | hbus monitor | Collected READ  addr=0x119f data=0xaa |
| 118735 | hbus monitor | Collected WRITE addr=0x11a0 data=0xaa |
| 118765 | hbus monitor | Collected READ  addr=0x11a0 data=0xaa |
| 118785 | hbus monitor | Collected WRITE addr=0x11a1 data=0xaa |
| 118815 | hbus monitor | Collected READ  addr=0x11a1 data=0xaa |
| 118835 | hbus monitor | Collected WRITE addr=0x11a2 data=0xaa |
| 118865 | hbus monitor | Collected READ  addr=0x11a2 data=0xaa |
| 118885 | hbus monitor | Collected WRITE addr=0x11a3 data=0xaa |
| 118915 | hbus monitor | Collected READ  addr=0x11a3 data=0xaa |
| 118935 | hbus monitor | Collected WRITE addr=0x11a4 data=0xaa |
| 118965 | hbus monitor | Collected READ  addr=0x11a4 data=0xaa |
| 118985 | hbus monitor | Collected WRITE addr=0x11a5 data=0xaa |
| 119015 | hbus monitor | Collected READ  addr=0x11a5 data=0xaa |
| 119035 | hbus monitor | Collected WRITE addr=0x11a6 data=0xaa |
| 119065 | hbus monitor | Collected READ  addr=0x11a6 data=0xaa |
| 119085 | hbus monitor | Collected WRITE addr=0x11a7 data=0xaa |
| 119115 | hbus monitor | Collected READ  addr=0x11a7 data=0xaa |
| 119135 | hbus monitor | Collected WRITE addr=0x11a8 data=0xaa |
| 119165 | hbus monitor | Collected READ  addr=0x11a8 data=0xaa |
| 119185 | hbus monitor | Collected WRITE addr=0x11a9 data=0xaa |
| 119215 | hbus monitor | Collected READ  addr=0x11a9 data=0xaa |
| 119235 | hbus monitor | Collected WRITE addr=0x11aa data=0xaa |
| 119265 | hbus monitor | Collected READ  addr=0x11aa data=0xaa |
| 119285 | hbus monitor | Collected WRITE addr=0x11ab data=0xaa |
| 119315 | hbus monitor | Collected READ  addr=0x11ab data=0xaa |
| 119335 | hbus monitor | Collected WRITE addr=0x11ac data=0xaa |
| 119365 | hbus monitor | Collected READ  addr=0x11ac data=0xaa |
| 119385 | hbus monitor | Collected WRITE addr=0x11ad data=0xaa |
| 119415 | hbus monitor | Collected READ  addr=0x11ad data=0xaa |
| 119435 | hbus monitor | Collected WRITE addr=0x11ae data=0xaa |
| 119465 | hbus monitor | Collected READ  addr=0x11ae data=0xaa |
| 119485 | hbus monitor | Collected WRITE addr=0x11af data=0xaa |
| 119515 | hbus monitor | Collected READ  addr=0x11af data=0xaa |
| 119535 | hbus monitor | Collected WRITE addr=0x11b0 data=0xaa |
| 119565 | hbus monitor | Collected READ  addr=0x11b0 data=0xaa |
| 119585 | hbus monitor | Collected WRITE addr=0x11b1 data=0xaa |
| 119615 | hbus monitor | Collected READ  addr=0x11b1 data=0xaa |
| 119635 | hbus monitor | Collected WRITE addr=0x11b2 data=0xaa |
| 119665 | hbus monitor | Collected READ  addr=0x11b2 data=0xaa |
| 119685 | hbus monitor | Collected WRITE addr=0x11b3 data=0xaa |
| 119715 | hbus monitor | Collected READ  addr=0x11b3 data=0xaa |
| 119735 | hbus monitor | Collected WRITE addr=0x11b4 data=0xaa |
| 119765 | hbus monitor | Collected READ  addr=0x11b4 data=0xaa |
| 119785 | hbus monitor | Collected WRITE addr=0x11b5 data=0xaa |
| 119815 | hbus monitor | Collected READ  addr=0x11b5 data=0xaa |
| 119835 | hbus monitor | Collected WRITE addr=0x11b6 data=0xaa |
| 119865 | hbus monitor | Collected READ  addr=0x11b6 data=0xaa |
| 119885 | hbus monitor | Collected WRITE addr=0x11b7 data=0xaa |
| 119915 | hbus monitor | Collected READ  addr=0x11b7 data=0xaa |
| 119935 | hbus monitor | Collected WRITE addr=0x11b8 data=0xaa |
| 119965 | hbus monitor | Collected READ  addr=0x11b8 data=0xaa |
| 119985 | hbus monitor | Collected WRITE addr=0x11b9 data=0xaa |
| 120015 | hbus monitor | Collected READ  addr=0x11b9 data=0xaa |
| 120035 | hbus monitor | Collected WRITE addr=0x11ba data=0xaa |
| 120065 | hbus monitor | Collected READ  addr=0x11ba data=0xaa |
| 120085 | hbus monitor | Collected WRITE addr=0x11bb data=0xaa |
| 120115 | hbus monitor | Collected READ  addr=0x11bb data=0xaa |
| 120135 | hbus monitor | Collected WRITE addr=0x11bc data=0xaa |
| 120165 | hbus monitor | Collected READ  addr=0x11bc data=0xaa |
| 120185 | hbus monitor | Collected WRITE addr=0x11bd data=0xaa |
| 120215 | hbus monitor | Collected READ  addr=0x11bd data=0xaa |
| 120235 | hbus monitor | Collected WRITE addr=0x11be data=0xaa |
| 120265 | hbus monitor | Collected READ  addr=0x11be data=0xaa |
| 120285 | hbus monitor | Collected WRITE addr=0x11bf data=0xaa |
| 120315 | hbus monitor | Collected READ  addr=0x11bf data=0xaa |
| 120335 | hbus monitor | Collected WRITE addr=0x11c0 data=0xaa |
| 120365 | hbus monitor | Collected READ  addr=0x11c0 data=0xaa |
| 120385 | hbus monitor | Collected WRITE addr=0x11c1 data=0xaa |
| 120415 | hbus monitor | Collected READ  addr=0x11c1 data=0xaa |
| 120435 | hbus monitor | Collected WRITE addr=0x11c2 data=0xaa |
| 120465 | hbus monitor | Collected READ  addr=0x11c2 data=0xaa |
| 120485 | hbus monitor | Collected WRITE addr=0x11c3 data=0xaa |
| 120515 | hbus monitor | Collected READ  addr=0x11c3 data=0xaa |
| 120535 | hbus monitor | Collected WRITE addr=0x11c4 data=0xaa |
| 120565 | hbus monitor | Collected READ  addr=0x11c4 data=0xaa |
| 120585 | hbus monitor | Collected WRITE addr=0x11c5 data=0xaa |
| 120615 | hbus monitor | Collected READ  addr=0x11c5 data=0xaa |
| 120635 | hbus monitor | Collected WRITE addr=0x11c6 data=0xaa |
| 120665 | hbus monitor | Collected READ  addr=0x11c6 data=0xaa |
| 120685 | hbus monitor | Collected WRITE addr=0x11c7 data=0xaa |
| 120715 | hbus monitor | Collected READ  addr=0x11c7 data=0xaa |
| 120735 | hbus monitor | Collected WRITE addr=0x11c8 data=0xaa |
| 120765 | hbus monitor | Collected READ  addr=0x11c8 data=0xaa |
| 120785 | hbus monitor | Collected WRITE addr=0x11c9 data=0xaa |
| 120815 | hbus monitor | Collected READ  addr=0x11c9 data=0xaa |
| 120835 | hbus monitor | Collected WRITE addr=0x11ca data=0xaa |
| 120865 | hbus monitor | Collected READ  addr=0x11ca data=0xaa |
| 120885 | hbus monitor | Collected WRITE addr=0x11cb data=0xaa |
| 120915 | hbus monitor | Collected READ  addr=0x11cb data=0xaa |
| 120935 | hbus monitor | Collected WRITE addr=0x11cc data=0xaa |
| 120965 | hbus monitor | Collected READ  addr=0x11cc data=0xaa |
| 120985 | hbus monitor | Collected WRITE addr=0x11cd data=0xaa |
| 121015 | hbus monitor | Collected READ  addr=0x11cd data=0xaa |
| 121035 | hbus monitor | Collected WRITE addr=0x11ce data=0xaa |
| 121065 | hbus monitor | Collected READ  addr=0x11ce data=0xaa |
| 121085 | hbus monitor | Collected WRITE addr=0x11cf data=0xaa |
| 121115 | hbus monitor | Collected READ  addr=0x11cf data=0xaa |
| 121135 | hbus monitor | Collected WRITE addr=0x11d0 data=0xaa |
| 121165 | hbus monitor | Collected READ  addr=0x11d0 data=0xaa |
| 121185 | hbus monitor | Collected WRITE addr=0x11d1 data=0xaa |
| 121215 | hbus monitor | Collected READ  addr=0x11d1 data=0xaa |
| 121235 | hbus monitor | Collected WRITE addr=0x11d2 data=0xaa |
| 121265 | hbus monitor | Collected READ  addr=0x11d2 data=0xaa |
| 121285 | hbus monitor | Collected WRITE addr=0x11d3 data=0xaa |
| 121315 | hbus monitor | Collected READ  addr=0x11d3 data=0xaa |
| 121335 | hbus monitor | Collected WRITE addr=0x11d4 data=0xaa |
| 121365 | hbus monitor | Collected READ  addr=0x11d4 data=0xaa |
| 121385 | hbus monitor | Collected WRITE addr=0x11d5 data=0xaa |
| 121415 | hbus monitor | Collected READ  addr=0x11d5 data=0xaa |
| 121435 | hbus monitor | Collected WRITE addr=0x11d6 data=0xaa |
| 121465 | hbus monitor | Collected READ  addr=0x11d6 data=0xaa |
| 121485 | hbus monitor | Collected WRITE addr=0x11d7 data=0xaa |
| 121515 | hbus monitor | Collected READ  addr=0x11d7 data=0xaa |
| 121535 | hbus monitor | Collected WRITE addr=0x11d8 data=0xaa |
| 121565 | hbus monitor | Collected READ  addr=0x11d8 data=0xaa |
| 121585 | hbus monitor | Collected WRITE addr=0x11d9 data=0xaa |
| 121615 | hbus monitor | Collected READ  addr=0x11d9 data=0xaa |
| 121635 | hbus monitor | Collected WRITE addr=0x11da data=0xaa |
| 121665 | hbus monitor | Collected READ  addr=0x11da data=0xaa |
| 121685 | hbus monitor | Collected WRITE addr=0x11db data=0xaa |
| 121715 | hbus monitor | Collected READ  addr=0x11db data=0xaa |
| 121735 | hbus monitor | Collected WRITE addr=0x11dc data=0xaa |
| 121765 | hbus monitor | Collected READ  addr=0x11dc data=0xaa |
| 121785 | hbus monitor | Collected WRITE addr=0x11dd data=0xaa |
| 121815 | hbus monitor | Collected READ  addr=0x11dd data=0xaa |
| 121835 | hbus monitor | Collected WRITE addr=0x11de data=0xaa |
| 121865 | hbus monitor | Collected READ  addr=0x11de data=0xaa |
| 121885 | hbus monitor | Collected WRITE addr=0x11df data=0xaa |
| 121915 | hbus monitor | Collected READ  addr=0x11df data=0xaa |
| 121935 | hbus monitor | Collected WRITE addr=0x11e0 data=0xaa |
| 121965 | hbus monitor | Collected READ  addr=0x11e0 data=0xaa |
| 121985 | hbus monitor | Collected WRITE addr=0x11e1 data=0xaa |
| 122015 | hbus monitor | Collected READ  addr=0x11e1 data=0xaa |
| 122035 | hbus monitor | Collected WRITE addr=0x11e2 data=0xaa |
| 122065 | hbus monitor | Collected READ  addr=0x11e2 data=0xaa |
| 122085 | hbus monitor | Collected WRITE addr=0x11e3 data=0xaa |
| 122115 | hbus monitor | Collected READ  addr=0x11e3 data=0xaa |
| 122135 | hbus monitor | Collected WRITE addr=0x11e4 data=0xaa |
| 122165 | hbus monitor | Collected READ  addr=0x11e4 data=0xaa |
| 122185 | hbus monitor | Collected WRITE addr=0x11e5 data=0xaa |
| 122215 | hbus monitor | Collected READ  addr=0x11e5 data=0xaa |
| 122235 | hbus monitor | Collected WRITE addr=0x11e6 data=0xaa |
| 122265 | hbus monitor | Collected READ  addr=0x11e6 data=0xaa |
| 122285 | hbus monitor | Collected WRITE addr=0x11e7 data=0xaa |
| 122315 | hbus monitor | Collected READ  addr=0x11e7 data=0xaa |
| 122335 | hbus monitor | Collected WRITE addr=0x11e8 data=0xaa |
| 122365 | hbus monitor | Collected READ  addr=0x11e8 data=0xaa |
| 122385 | hbus monitor | Collected WRITE addr=0x11e9 data=0xaa |
| 122415 | hbus monitor | Collected READ  addr=0x11e9 data=0xaa |
| 122435 | hbus monitor | Collected WRITE addr=0x11ea data=0xaa |
| 122465 | hbus monitor | Collected READ  addr=0x11ea data=0xaa |
| 122485 | hbus monitor | Collected WRITE addr=0x11eb data=0xaa |
| 122515 | hbus monitor | Collected READ  addr=0x11eb data=0xaa |
| 122535 | hbus monitor | Collected WRITE addr=0x11ec data=0xaa |
| 122565 | hbus monitor | Collected READ  addr=0x11ec data=0xaa |
| 122585 | hbus monitor | Collected WRITE addr=0x11ed data=0xaa |
| 122615 | hbus monitor | Collected READ  addr=0x11ed data=0xaa |
| 122635 | hbus monitor | Collected WRITE addr=0x11ee data=0xaa |
| 122665 | hbus monitor | Collected READ  addr=0x11ee data=0xaa |
| 122685 | hbus monitor | Collected WRITE addr=0x11ef data=0xaa |
| 122715 | hbus monitor | Collected READ  addr=0x11ef data=0xaa |
| 122735 | hbus monitor | Collected WRITE addr=0x11f0 data=0xaa |
| 122765 | hbus monitor | Collected READ  addr=0x11f0 data=0xaa |
| 122785 | hbus monitor | Collected WRITE addr=0x11f1 data=0xaa |
| 122815 | hbus monitor | Collected READ  addr=0x11f1 data=0xaa |
| 122835 | hbus monitor | Collected WRITE addr=0x11f2 data=0xaa |
| 122865 | hbus monitor | Collected READ  addr=0x11f2 data=0xaa |
| 122885 | hbus monitor | Collected WRITE addr=0x11f3 data=0xaa |
| 122915 | hbus monitor | Collected READ  addr=0x11f3 data=0xaa |
| 122935 | hbus monitor | Collected WRITE addr=0x11f4 data=0xaa |
| 122965 | hbus monitor | Collected READ  addr=0x11f4 data=0xaa |
| 122985 | hbus monitor | Collected WRITE addr=0x11f5 data=0xaa |
| 123015 | hbus monitor | Collected READ  addr=0x11f5 data=0xaa |
| 123035 | hbus monitor | Collected WRITE addr=0x11f6 data=0xaa |
| 123065 | hbus monitor | Collected READ  addr=0x11f6 data=0xaa |
| 123085 | hbus monitor | Collected WRITE addr=0x11f7 data=0xaa |
| 123115 | hbus monitor | Collected READ  addr=0x11f7 data=0xaa |
| 123135 | hbus monitor | Collected WRITE addr=0x11f8 data=0xaa |
| 123165 | hbus monitor | Collected READ  addr=0x11f8 data=0xaa |
| 123185 | hbus monitor | Collected WRITE addr=0x11f9 data=0xaa |
| 123215 | hbus monitor | Collected READ  addr=0x11f9 data=0xaa |
| 123235 | hbus monitor | Collected WRITE addr=0x11fa data=0xaa |
| 123265 | hbus monitor | Collected READ  addr=0x11fa data=0xaa |
| 123285 | hbus monitor | Collected WRITE addr=0x11fb data=0xaa |
| 123315 | hbus monitor | Collected READ  addr=0x11fb data=0xaa |
| 123335 | hbus monitor | Collected WRITE addr=0x11fc data=0xaa |
| 123365 | hbus monitor | Collected READ  addr=0x11fc data=0xaa |
| 123385 | hbus monitor | Collected WRITE addr=0x11fd data=0xaa |
| 123415 | hbus monitor | Collected READ  addr=0x11fd data=0xaa |
| 123435 | hbus monitor | Collected WRITE addr=0x11fe data=0xaa |
| 123465 | hbus monitor | Collected READ  addr=0x11fe data=0xaa |
| 123485 | hbus monitor | Collected WRITE addr=0x11ff data=0xaa |
| 123515 | hbus monitor | Collected READ  addr=0x11ff data=0xaa |
| 123535 | hbus monitor | Collected WRITE addr=0x1100 data=0x7c |
| 123565 | hbus monitor | Collected READ  addr=0x1100 data=0x7c |
| 123585 | hbus monitor | Collected WRITE addr=0x1101 data=0x6e |
| 123615 | hbus monitor | Collected READ  addr=0x1101 data=0x6e |
| 123635 | hbus monitor | Collected WRITE addr=0x1102 data=0x2f |
| 123665 | hbus monitor | Collected READ  addr=0x1102 data=0x2f |
| 123685 | hbus monitor | Collected WRITE addr=0x1103 data=0x5c |
| 123715 | hbus monitor | Collected READ  addr=0x1103 data=0x5c |
| 123735 | hbus monitor | Collected WRITE addr=0x1104 data=0xa3 |
| 123765 | hbus monitor | Collected READ  addr=0x1104 data=0xa3 |
| 123785 | hbus monitor | Collected WRITE addr=0x1105 data=0x4d |
| 123815 | hbus monitor | Collected READ  addr=0x1105 data=0x4d |
| 123835 | hbus monitor | Collected WRITE addr=0x1106 data=0x48 |
| 123865 | hbus monitor | Collected READ  addr=0x1106 data=0x48 |
| 123885 | hbus monitor | Collected WRITE addr=0x1107 data=0x3d |
| 123915 | hbus monitor | Collected READ  addr=0x1107 data=0x3d |
| 123935 | hbus monitor | Collected WRITE addr=0x1108 data=0xe7 |
| 123965 | hbus monitor | Collected READ  addr=0x1108 data=0xe7 |
| 123985 | hbus monitor | Collected WRITE addr=0x1109 data=0x85 |
| 124015 | hbus monitor | Collected READ  addr=0x1109 data=0x85 |
| 124035 | hbus monitor | Collected WRITE addr=0x110a data=0x08 |
| 124065 | hbus monitor | Collected READ  addr=0x110a data=0x08 |
| 124085 | hbus monitor | Collected WRITE addr=0x110b data=0xed |
| 124115 | hbus monitor | Collected READ  addr=0x110b data=0xed |
| 124135 | hbus monitor | Collected WRITE addr=0x110c data=0x75 |
| 124165 | hbus monitor | Collected READ  addr=0x110c data=0x75 |
| 124185 | hbus monitor | Collected WRITE addr=0x110d data=0x64 |
| 124215 | hbus monitor | Collected READ  addr=0x110d data=0x64 |
| 124235 | hbus monitor | Collected WRITE addr=0x110e data=0xca |
| 124265 | hbus monitor | Collected READ  addr=0x110e data=0xca |
| 124285 | hbus monitor | Collected WRITE addr=0x110f data=0x1f |
| 124315 | hbus monitor | Collected READ  addr=0x110f data=0x1f |
| 124335 | hbus monitor | Collected WRITE addr=0x1110 data=0x11 |
| 124365 | hbus monitor | Collected READ  addr=0x1110 data=0x11 |
| 124385 | hbus monitor | Collected WRITE addr=0x1111 data=0x75 |
| 124415 | hbus monitor | Collected READ  addr=0x1111 data=0x75 |
| 124435 | hbus monitor | Collected WRITE addr=0x1112 data=0x7e |
| 124465 | hbus monitor | Collected READ  addr=0x1112 data=0x7e |
| 124485 | hbus monitor | Collected WRITE addr=0x1113 data=0xfd |
| 124515 | hbus monitor | Collected READ  addr=0x1113 data=0xfd |
| 124535 | hbus monitor | Collected WRITE addr=0x1114 data=0x7a |
| 124565 | hbus monitor | Collected READ  addr=0x1114 data=0x7a |
| 124585 | hbus monitor | Collected WRITE addr=0x1115 data=0x1a |
| 124615 | hbus monitor | Collected READ  addr=0x1115 data=0x1a |
| 124635 | hbus monitor | Collected WRITE addr=0x1116 data=0x6b |
| 124665 | hbus monitor | Collected READ  addr=0x1116 data=0x6b |
| 124685 | hbus monitor | Collected WRITE addr=0x1117 data=0x52 |
| 124715 | hbus monitor | Collected READ  addr=0x1117 data=0x52 |
| 124735 | hbus monitor | Collected WRITE addr=0x1118 data=0x62 |
| 124765 | hbus monitor | Collected READ  addr=0x1118 data=0x62 |
| 124785 | hbus monitor | Collected WRITE addr=0x1119 data=0xd8 |
| 124815 | hbus monitor | Collected READ  addr=0x1119 data=0xd8 |
| 124835 | hbus monitor | Collected WRITE addr=0x111a data=0xab |
| 124865 | hbus monitor | Collected READ  addr=0x111a data=0xab |
| 124885 | hbus monitor | Collected WRITE addr=0x111b data=0x5a |
| 124915 | hbus monitor | Collected READ  addr=0x111b data=0x5a |
| 124935 | hbus monitor | Collected WRITE addr=0x111c data=0x54 |
| 124965 | hbus monitor | Collected READ  addr=0x111c data=0x54 |
| 124985 | hbus monitor | Collected WRITE addr=0x111d data=0x99 |
| 125015 | hbus monitor | Collected READ  addr=0x111d data=0x99 |
| 125035 | hbus monitor | Collected WRITE addr=0x111e data=0x7b |
| 125065 | hbus monitor | Collected READ  addr=0x111e data=0x7b |
| 125085 | hbus monitor | Collected WRITE addr=0x111f data=0x86 |
| 125115 | hbus monitor | Collected READ  addr=0x111f data=0x86 |
| 125135 | hbus monitor | Collected WRITE addr=0x1120 data=0xcc |
| 125165 | hbus monitor | Collected READ  addr=0x1120 data=0xcc |
| 125185 | hbus monitor | Collected WRITE addr=0x1121 data=0x5a |
| 125215 | hbus monitor | Collected READ  addr=0x1121 data=0x5a |
| 125235 | hbus monitor | Collected WRITE addr=0x1122 data=0xba |
| 125265 | hbus monitor | Collected READ  addr=0x1122 data=0xba |
| 125285 | hbus monitor | Collected WRITE addr=0x1123 data=0xfe |
| 125315 | hbus monitor | Collected READ  addr=0x1123 data=0xfe |
| 125335 | hbus monitor | Collected WRITE addr=0x1124 data=0xb9 |
| 125365 | hbus monitor | Collected READ  addr=0x1124 data=0xb9 |
| 125385 | hbus monitor | Collected WRITE addr=0x1125 data=0x07 |
| 125415 | hbus monitor | Collected READ  addr=0x1125 data=0x07 |
| 125435 | hbus monitor | Collected WRITE addr=0x1126 data=0x2c |
| 125465 | hbus monitor | Collected READ  addr=0x1126 data=0x2c |
| 125485 | hbus monitor | Collected WRITE addr=0x1127 data=0xad |
| 125515 | hbus monitor | Collected READ  addr=0x1127 data=0xad |
| 125535 | hbus monitor | Collected WRITE addr=0x1128 data=0x38 |
| 125565 | hbus monitor | Collected READ  addr=0x1128 data=0x38 |
| 125585 | hbus monitor | Collected WRITE addr=0x1129 data=0x8c |
| 125615 | hbus monitor | Collected READ  addr=0x1129 data=0x8c |
| 125635 | hbus monitor | Collected WRITE addr=0x112a data=0xdf |
| 125665 | hbus monitor | Collected READ  addr=0x112a data=0xdf |
| 125685 | hbus monitor | Collected WRITE addr=0x112b data=0x7a |
| 125715 | hbus monitor | Collected READ  addr=0x112b data=0x7a |
| 125735 | hbus monitor | Collected WRITE addr=0x112c data=0x38 |
| 125765 | hbus monitor | Collected READ  addr=0x112c data=0x38 |
| 125785 | hbus monitor | Collected WRITE addr=0x112d data=0xab |
| 125815 | hbus monitor | Collected READ  addr=0x112d data=0xab |
| 125835 | hbus monitor | Collected WRITE addr=0x112e data=0x60 |
| 125865 | hbus monitor | Collected READ  addr=0x112e data=0x60 |
| 125885 | hbus monitor | Collected WRITE addr=0x112f data=0x05 |
| 125915 | hbus monitor | Collected READ  addr=0x112f data=0x05 |
| 125935 | hbus monitor | Collected WRITE addr=0x1130 data=0xc8 |
| 125965 | hbus monitor | Collected READ  addr=0x1130 data=0xc8 |
| 125985 | hbus monitor | Collected WRITE addr=0x1131 data=0x95 |
| 126015 | hbus monitor | Collected READ  addr=0x1131 data=0x95 |
| 126035 | hbus monitor | Collected WRITE addr=0x1132 data=0x7c |
| 126065 | hbus monitor | Collected READ  addr=0x1132 data=0x7c |
| 126085 | hbus monitor | Collected WRITE addr=0x1133 data=0xf8 |
| 126115 | hbus monitor | Collected READ  addr=0x1133 data=0xf8 |
| 126135 | hbus monitor | Collected WRITE addr=0x1134 data=0x31 |
| 126165 | hbus monitor | Collected READ  addr=0x1134 data=0x31 |
| 126185 | hbus monitor | Collected WRITE addr=0x1135 data=0x6b |
| 126215 | hbus monitor | Collected READ  addr=0x1135 data=0x6b |
| 126235 | hbus monitor | Collected WRITE addr=0x1136 data=0x96 |
| 126265 | hbus monitor | Collected READ  addr=0x1136 data=0x96 |
| 126285 | hbus monitor | Collected WRITE addr=0x1137 data=0x95 |
| 126315 | hbus monitor | Collected READ  addr=0x1137 data=0x95 |
| 126335 | hbus monitor | Collected WRITE addr=0x1138 data=0x61 |
| 126365 | hbus monitor | Collected READ  addr=0x1138 data=0x61 |
| 126385 | hbus monitor | Collected WRITE addr=0x1139 data=0xdf |
| 126415 | hbus monitor | Collected READ  addr=0x1139 data=0xdf |
| 126435 | hbus monitor | Collected WRITE addr=0x113a data=0xb5 |
| 126465 | hbus monitor | Collected READ  addr=0x113a data=0xb5 |
| 126485 | hbus monitor | Collected WRITE addr=0x113b data=0xbf |
| 126515 | hbus monitor | Collected READ  addr=0x113b data=0xbf |
| 126535 | hbus monitor | Collected WRITE addr=0x113c data=0x0c |
| 126565 | hbus monitor | Collected READ  addr=0x113c data=0x0c |
| 126585 | hbus monitor | Collected WRITE addr=0x113d data=0x7d |
| 126615 | hbus monitor | Collected READ  addr=0x113d data=0x7d |
| 126635 | hbus monitor | Collected WRITE addr=0x113e data=0xd0 |
| 126665 | hbus monitor | Collected READ  addr=0x113e data=0xd0 |
| 126685 | hbus monitor | Collected WRITE addr=0x113f data=0xc1 |
| 126715 | hbus monitor | Collected READ  addr=0x113f data=0xc1 |
| 126735 | hbus monitor | Collected WRITE addr=0x1140 data=0xb3 |
| 126765 | hbus monitor | Collected READ  addr=0x1140 data=0xb3 |
| 126785 | hbus monitor | Collected WRITE addr=0x1141 data=0x5f |
| 126815 | hbus monitor | Collected READ  addr=0x1141 data=0x5f |
| 126835 | hbus monitor | Collected WRITE addr=0x1142 data=0x68 |
| 126865 | hbus monitor | Collected READ  addr=0x1142 data=0x68 |
| 126885 | hbus monitor | Collected WRITE addr=0x1143 data=0xc8 |
| 126915 | hbus monitor | Collected READ  addr=0x1143 data=0xc8 |
| 126935 | hbus monitor | Collected WRITE addr=0x1144 data=0x91 |
| 126965 | hbus monitor | Collected READ  addr=0x1144 data=0x91 |
| 126985 | hbus monitor | Collected WRITE addr=0x1145 data=0x7c |
| 127015 | hbus monitor | Collected READ  addr=0x1145 data=0x7c |
| 127035 | hbus monitor | Collected WRITE addr=0x1146 data=0xda |
| 127065 | hbus monitor | Collected READ  addr=0x1146 data=0xda |
| 127085 | hbus monitor | Collected WRITE addr=0x1147 data=0x0e |
| 127115 | hbus monitor | Collected READ  addr=0x1147 data=0x0e |
| 127135 | hbus monitor | Collected WRITE addr=0x1148 data=0xee |
| 127165 | hbus monitor | Collected READ  addr=0x1148 data=0xee |
| 127185 | hbus monitor | Collected WRITE addr=0x1149 data=0x83 |
| 127215 | hbus monitor | Collected READ  addr=0x1149 data=0x83 |
| 127235 | hbus monitor | Collected WRITE addr=0x114a data=0xb8 |
| 127265 | hbus monitor | Collected READ  addr=0x114a data=0xb8 |
| 127285 | hbus monitor | Collected WRITE addr=0x114b data=0x8f |
| 127315 | hbus monitor | Collected READ  addr=0x114b data=0x8f |
| 127335 | hbus monitor | Collected WRITE addr=0x114c data=0xa2 |
| 127365 | hbus monitor | Collected READ  addr=0x114c data=0xa2 |
| 127385 | hbus monitor | Collected WRITE addr=0x114d data=0x2e |
| 127415 | hbus monitor | Collected READ  addr=0x114d data=0x2e |
| 127435 | hbus monitor | Collected WRITE addr=0x114e data=0xba |
| 127465 | hbus monitor | Collected READ  addr=0x114e data=0xba |
| 127485 | hbus monitor | Collected WRITE addr=0x114f data=0x46 |
| 127515 | hbus monitor | Collected READ  addr=0x114f data=0x46 |
| 127535 | hbus monitor | Collected WRITE addr=0x1150 data=0x73 |
| 127565 | hbus monitor | Collected READ  addr=0x1150 data=0x73 |
| 127585 | hbus monitor | Collected WRITE addr=0x1151 data=0x63 |
| 127615 | hbus monitor | Collected READ  addr=0x1151 data=0x63 |
| 127635 | hbus monitor | Collected WRITE addr=0x1152 data=0xf7 |
| 127665 | hbus monitor | Collected READ  addr=0x1152 data=0xf7 |
| 127685 | hbus monitor | Collected WRITE addr=0x1153 data=0x71 |
| 127715 | hbus monitor | Collected READ  addr=0x1153 data=0x71 |
| 127735 | hbus monitor | Collected WRITE addr=0x1154 data=0x23 |
| 127765 | hbus monitor | Collected READ  addr=0x1154 data=0x23 |
| 127785 | hbus monitor | Collected WRITE addr=0x1155 data=0x80 |
| 127815 | hbus monitor | Collected READ  addr=0x1155 data=0x80 |
| 127835 | hbus monitor | Collected WRITE addr=0x1156 data=0x60 |
| 127865 | hbus monitor | Collected READ  addr=0x1156 data=0x60 |
| 127885 | hbus monitor | Collected WRITE addr=0x1157 data=0x8a |
| 127915 | hbus monitor | Collected READ  addr=0x1157 data=0x8a |
| 127935 | hbus monitor | Collected WRITE addr=0x1158 data=0xf6 |
| 127965 | hbus monitor | Collected READ  addr=0x1158 data=0xf6 |
| 127985 | hbus monitor | Collected WRITE addr=0x1159 data=0x89 |
| 128015 | hbus monitor | Collected READ  addr=0x1159 data=0x89 |
| 128035 | hbus monitor | Collected WRITE addr=0x115a data=0x6f |
| 128065 | hbus monitor | Collected READ  addr=0x115a data=0x6f |
| 128085 | hbus monitor | Collected WRITE addr=0x115b data=0x11 |
| 128115 | hbus monitor | Collected READ  addr=0x115b data=0x11 |
| 128135 | hbus monitor | Collected WRITE addr=0x115c data=0x70 |
| 128165 | hbus monitor | Collected READ  addr=0x115c data=0x70 |
| 128185 | hbus monitor | Collected WRITE addr=0x115d data=0x4d |
| 128215 | hbus monitor | Collected READ  addr=0x115d data=0x4d |
| 128235 | hbus monitor | Collected WRITE addr=0x115e data=0xce |
| 128265 | hbus monitor | Collected READ  addr=0x115e data=0xce |
| 128285 | hbus monitor | Collected WRITE addr=0x115f data=0x0f |
| 128315 | hbus monitor | Collected READ  addr=0x115f data=0x0f |
| 128335 | hbus monitor | Collected WRITE addr=0x1160 data=0x57 |
| 128365 | hbus monitor | Collected READ  addr=0x1160 data=0x57 |
| 128385 | hbus monitor | Collected WRITE addr=0x1161 data=0x1f |
| 128415 | hbus monitor | Collected READ  addr=0x1161 data=0x1f |
| 128435 | hbus monitor | Collected WRITE addr=0x1162 data=0xfe |
| 128465 | hbus monitor | Collected READ  addr=0x1162 data=0xfe |
| 128485 | hbus monitor | Collected WRITE addr=0x1163 data=0xc4 |
| 128515 | hbus monitor | Collected READ  addr=0x1163 data=0xc4 |
| 128535 | hbus monitor | Collected WRITE addr=0x1164 data=0x11 |
| 128565 | hbus monitor | Collected READ  addr=0x1164 data=0x11 |
| 128585 | hbus monitor | Collected WRITE addr=0x1165 data=0x3b |
| 128615 | hbus monitor | Collected READ  addr=0x1165 data=0x3b |
| 128635 | hbus monitor | Collected WRITE addr=0x1166 data=0xbf |
| 128665 | hbus monitor | Collected READ  addr=0x1166 data=0xbf |
| 128685 | hbus monitor | Collected WRITE addr=0x1167 data=0x40 |
| 128715 | hbus monitor | Collected READ  addr=0x1167 data=0x40 |
| 128735 | hbus monitor | Collected WRITE addr=0x1168 data=0xfb |
| 128765 | hbus monitor | Collected READ  addr=0x1168 data=0xfb |
| 128785 | hbus monitor | Collected WRITE addr=0x1169 data=0xf7 |
| 128815 | hbus monitor | Collected READ  addr=0x1169 data=0xf7 |
| 128835 | hbus monitor | Collected WRITE addr=0x116a data=0x95 |
| 128865 | hbus monitor | Collected READ  addr=0x116a data=0x95 |
| 128885 | hbus monitor | Collected WRITE addr=0x116b data=0x5c |
| 128915 | hbus monitor | Collected READ  addr=0x116b data=0x5c |
| 128935 | hbus monitor | Collected WRITE addr=0x116c data=0x73 |
| 128965 | hbus monitor | Collected READ  addr=0x116c data=0x73 |
| 128985 | hbus monitor | Collected WRITE addr=0x116d data=0x80 |
| 129015 | hbus monitor | Collected READ  addr=0x116d data=0x80 |
| 129035 | hbus monitor | Collected WRITE addr=0x116e data=0xdd |
| 129065 | hbus monitor | Collected READ  addr=0x116e data=0xdd |
| 129085 | hbus monitor | Collected WRITE addr=0x116f data=0xf3 |
| 129115 | hbus monitor | Collected READ  addr=0x116f data=0xf3 |
| 129135 | hbus monitor | Collected WRITE addr=0x1170 data=0x2f |
| 129165 | hbus monitor | Collected READ  addr=0x1170 data=0x2f |
| 129185 | hbus monitor | Collected WRITE addr=0x1171 data=0x9b |
| 129215 | hbus monitor | Collected READ  addr=0x1171 data=0x9b |
| 129235 | hbus monitor | Collected WRITE addr=0x1172 data=0xf3 |
| 129265 | hbus monitor | Collected READ  addr=0x1172 data=0xf3 |
| 129285 | hbus monitor | Collected WRITE addr=0x1173 data=0xcc |
| 129315 | hbus monitor | Collected READ  addr=0x1173 data=0xcc |
| 129335 | hbus monitor | Collected WRITE addr=0x1174 data=0xcc |
| 129365 | hbus monitor | Collected READ  addr=0x1174 data=0xcc |
| 129385 | hbus monitor | Collected WRITE addr=0x1175 data=0x84 |
| 129415 | hbus monitor | Collected READ  addr=0x1175 data=0x84 |
| 129435 | hbus monitor | Collected WRITE addr=0x1176 data=0x3d |
| 129465 | hbus monitor | Collected READ  addr=0x1176 data=0x3d |
| 129485 | hbus monitor | Collected WRITE addr=0x1177 data=0xe7 |
| 129515 | hbus monitor | Collected READ  addr=0x1177 data=0xe7 |
| 129535 | hbus monitor | Collected WRITE addr=0x1178 data=0x55 |
| 129565 | hbus monitor | Collected READ  addr=0x1178 data=0x55 |
| 129585 | hbus monitor | Collected WRITE addr=0x1179 data=0xba |
| 129615 | hbus monitor | Collected READ  addr=0x1179 data=0xba |
| 129635 | hbus monitor | Collected WRITE addr=0x117a data=0x81 |
| 129665 | hbus monitor | Collected READ  addr=0x117a data=0x81 |
| 129685 | hbus monitor | Collected WRITE addr=0x117b data=0x37 |
| 129715 | hbus monitor | Collected READ  addr=0x117b data=0x37 |
| 129735 | hbus monitor | Collected WRITE addr=0x117c data=0xbd |
| 129765 | hbus monitor | Collected READ  addr=0x117c data=0xbd |
| 129785 | hbus monitor | Collected WRITE addr=0x117d data=0x50 |
| 129815 | hbus monitor | Collected READ  addr=0x117d data=0x50 |
| 129835 | hbus monitor | Collected WRITE addr=0x117e data=0x90 |
| 129865 | hbus monitor | Collected READ  addr=0x117e data=0x90 |
| 129885 | hbus monitor | Collected WRITE addr=0x117f data=0x84 |
| 129915 | hbus monitor | Collected READ  addr=0x117f data=0x84 |
| 129935 | hbus monitor | Collected WRITE addr=0x1180 data=0x6e |
| 129965 | hbus monitor | Collected READ  addr=0x1180 data=0x6e |
| 129985 | hbus monitor | Collected WRITE addr=0x1181 data=0xc4 |
| 130015 | hbus monitor | Collected READ  addr=0x1181 data=0xc4 |
| 130035 | hbus monitor | Collected WRITE addr=0x1182 data=0x7a |
| 130065 | hbus monitor | Collected READ  addr=0x1182 data=0x7a |
| 130085 | hbus monitor | Collected WRITE addr=0x1183 data=0x07 |
| 130115 | hbus monitor | Collected READ  addr=0x1183 data=0x07 |
| 130135 | hbus monitor | Collected WRITE addr=0x1184 data=0x67 |
| 130165 | hbus monitor | Collected READ  addr=0x1184 data=0x67 |
| 130185 | hbus monitor | Collected WRITE addr=0x1185 data=0x38 |
| 130215 | hbus monitor | Collected READ  addr=0x1185 data=0x38 |
| 130235 | hbus monitor | Collected WRITE addr=0x1186 data=0x5d |
| 130265 | hbus monitor | Collected READ  addr=0x1186 data=0x5d |
| 130285 | hbus monitor | Collected WRITE addr=0x1187 data=0xea |
| 130315 | hbus monitor | Collected READ  addr=0x1187 data=0xea |
| 130335 | hbus monitor | Collected WRITE addr=0x1188 data=0x3a |
| 130365 | hbus monitor | Collected READ  addr=0x1188 data=0x3a |
| 130385 | hbus monitor | Collected WRITE addr=0x1189 data=0x8b |
| 130415 | hbus monitor | Collected READ  addr=0x1189 data=0x8b |
| 130435 | hbus monitor | Collected WRITE addr=0x118a data=0x0f |
| 130465 | hbus monitor | Collected READ  addr=0x118a data=0x0f |
| 130485 | hbus monitor | Collected WRITE addr=0x118b data=0x3c |
| 130515 | hbus monitor | Collected READ  addr=0x118b data=0x3c |
| 130535 | hbus monitor | Collected WRITE addr=0x118c data=0x2d |
| 130565 | hbus monitor | Collected READ  addr=0x118c data=0x2d |
| 130585 | hbus monitor | Collected WRITE addr=0x118d data=0x36 |
| 130615 | hbus monitor | Collected READ  addr=0x118d data=0x36 |
| 130635 | hbus monitor | Collected WRITE addr=0x118e data=0x93 |
| 130665 | hbus monitor | Collected READ  addr=0x118e data=0x93 |
| 130685 | hbus monitor | Collected WRITE addr=0x118f data=0x96 |
| 130715 | hbus monitor | Collected READ  addr=0x118f data=0x96 |
| 130735 | hbus monitor | Collected WRITE addr=0x1190 data=0x8e |
| 130765 | hbus monitor | Collected READ  addr=0x1190 data=0x8e |
| 130785 | hbus monitor | Collected WRITE addr=0x1191 data=0xf5 |
| 130815 | hbus monitor | Collected READ  addr=0x1191 data=0xf5 |
| 130835 | hbus monitor | Collected WRITE addr=0x1192 data=0x00 |
| 130865 | hbus monitor | Collected READ  addr=0x1192 data=0x00 |
| 130885 | hbus monitor | Collected WRITE addr=0x1193 data=0x4e |
| 130915 | hbus monitor | Collected READ  addr=0x1193 data=0x4e |
| 130935 | hbus monitor | Collected WRITE addr=0x1194 data=0x34 |
| 130965 | hbus monitor | Collected READ  addr=0x1194 data=0x34 |
| 130985 | hbus monitor | Collected WRITE addr=0x1195 data=0xde |
| 131015 | hbus monitor | Collected READ  addr=0x1195 data=0xde |
| 131035 | hbus monitor | Collected WRITE addr=0x1196 data=0x4e |
| 131065 | hbus monitor | Collected READ  addr=0x1196 data=0x4e |
| 131085 | hbus monitor | Collected WRITE addr=0x1197 data=0x09 |
| 131115 | hbus monitor | Collected READ  addr=0x1197 data=0x09 |
| 131135 | hbus monitor | Collected WRITE addr=0x1198 data=0xe9 |
| 131165 | hbus monitor | Collected READ  addr=0x1198 data=0xe9 |
| 131185 | hbus monitor | Collected WRITE addr=0x1199 data=0x97 |
| 131215 | hbus monitor | Collected READ  addr=0x1199 data=0x97 |
| 131235 | hbus monitor | Collected WRITE addr=0x119a data=0xa5 |
| 131265 | hbus monitor | Collected READ  addr=0x119a data=0xa5 |
| 131285 | hbus monitor | Collected WRITE addr=0x119b data=0x8e |
| 131315 | hbus monitor | Collected READ  addr=0x119b data=0x8e |
| 131335 | hbus monitor | Collected WRITE addr=0x119c data=0xfa |
| 131365 | hbus monitor | Collected READ  addr=0x119c data=0xfa |
| 131385 | hbus monitor | Collected WRITE addr=0x119d data=0x94 |
| 131415 | hbus monitor | Collected READ  addr=0x119d data=0x94 |
| 131435 | hbus monitor | Collected WRITE addr=0x119e data=0xf1 |
| 131465 | hbus monitor | Collected READ  addr=0x119e data=0xf1 |
| 131485 | hbus monitor | Collected WRITE addr=0x119f data=0x65 |
| 131515 | hbus monitor | Collected READ  addr=0x119f data=0x65 |
| 131535 | hbus monitor | Collected WRITE addr=0x11a0 data=0xbe |
| 131565 | hbus monitor | Collected READ  addr=0x11a0 data=0xbe |
| 131585 | hbus monitor | Collected WRITE addr=0x11a1 data=0x81 |
| 131615 | hbus monitor | Collected READ  addr=0x11a1 data=0x81 |
| 131635 | hbus monitor | Collected WRITE addr=0x11a2 data=0xed |
| 131665 | hbus monitor | Collected READ  addr=0x11a2 data=0xed |
| 131685 | hbus monitor | Collected WRITE addr=0x11a3 data=0xe1 |
| 131715 | hbus monitor | Collected READ  addr=0x11a3 data=0xe1 |
| 131735 | hbus monitor | Collected WRITE addr=0x11a4 data=0xc6 |
| 131765 | hbus monitor | Collected READ  addr=0x11a4 data=0xc6 |
| 131785 | hbus monitor | Collected WRITE addr=0x11a5 data=0xb7 |
| 131815 | hbus monitor | Collected READ  addr=0x11a5 data=0xb7 |
| 131835 | hbus monitor | Collected WRITE addr=0x11a6 data=0x96 |
| 131865 | hbus monitor | Collected READ  addr=0x11a6 data=0x96 |
| 131885 | hbus monitor | Collected WRITE addr=0x11a7 data=0xd8 |
| 131915 | hbus monitor | Collected READ  addr=0x11a7 data=0xd8 |
| 131935 | hbus monitor | Collected WRITE addr=0x11a8 data=0x44 |
| 131965 | hbus monitor | Collected READ  addr=0x11a8 data=0x44 |
| 131985 | hbus monitor | Collected WRITE addr=0x11a9 data=0x37 |
| 132015 | hbus monitor | Collected READ  addr=0x11a9 data=0x37 |
| 132035 | hbus monitor | Collected WRITE addr=0x11aa data=0x0b |
| 132065 | hbus monitor | Collected READ  addr=0x11aa data=0x0b |
| 132085 | hbus monitor | Collected WRITE addr=0x11ab data=0xab |
| 132115 | hbus monitor | Collected READ  addr=0x11ab data=0xab |
| 132135 | hbus monitor | Collected WRITE addr=0x11ac data=0x46 |
| 132165 | hbus monitor | Collected READ  addr=0x11ac data=0x46 |
| 132185 | hbus monitor | Collected WRITE addr=0x11ad data=0x62 |
| 132215 | hbus monitor | Collected READ  addr=0x11ad data=0x62 |
| 132235 | hbus monitor | Collected WRITE addr=0x11ae data=0xd5 |
| 132265 | hbus monitor | Collected READ  addr=0x11ae data=0xd5 |
| 132285 | hbus monitor | Collected WRITE addr=0x11af data=0xb3 |
| 132315 | hbus monitor | Collected READ  addr=0x11af data=0xb3 |
| 132335 | hbus monitor | Collected WRITE addr=0x11b0 data=0x1f |
| 132365 | hbus monitor | Collected READ  addr=0x11b0 data=0x1f |
| 132385 | hbus monitor | Collected WRITE addr=0x11b1 data=0xe6 |
| 132415 | hbus monitor | Collected READ  addr=0x11b1 data=0xe6 |
| 132435 | hbus monitor | Collected WRITE addr=0x11b2 data=0x37 |
| 132465 | hbus monitor | Collected READ  addr=0x11b2 data=0x37 |
| 132485 | hbus monitor | Collected WRITE addr=0x11b3 data=0x0d |
| 132515 | hbus monitor | Collected READ  addr=0x11b3 data=0x0d |
| 132535 | hbus monitor | Collected WRITE addr=0x11b4 data=0xf5 |
| 132565 | hbus monitor | Collected READ  addr=0x11b4 data=0xf5 |
| 132585 | hbus monitor | Collected WRITE addr=0x11b5 data=0x11 |
| 132615 | hbus monitor | Collected READ  addr=0x11b5 data=0x11 |
| 132635 | hbus monitor | Collected WRITE addr=0x11b6 data=0x6f |
| 132665 | hbus monitor | Collected READ  addr=0x11b6 data=0x6f |
| 132685 | hbus monitor | Collected WRITE addr=0x11b7 data=0xfc |
| 132715 | hbus monitor | Collected READ  addr=0x11b7 data=0xfc |
| 132735 | hbus monitor | Collected WRITE addr=0x11b8 data=0x74 |
| 132765 | hbus monitor | Collected READ  addr=0x11b8 data=0x74 |
| 132785 | hbus monitor | Collected WRITE addr=0x11b9 data=0xf0 |
| 132815 | hbus monitor | Collected READ  addr=0x11b9 data=0xf0 |
| 132835 | hbus monitor | Collected WRITE addr=0x11ba data=0x3d |
| 132865 | hbus monitor | Collected READ  addr=0x11ba data=0x3d |
| 132885 | hbus monitor | Collected WRITE addr=0x11bb data=0xfa |
| 132915 | hbus monitor | Collected READ  addr=0x11bb data=0xfa |
| 132935 | hbus monitor | Collected WRITE addr=0x11bc data=0xa3 |
| 132965 | hbus monitor | Collected READ  addr=0x11bc data=0xa3 |
| 132985 | hbus monitor | Collected WRITE addr=0x11bd data=0xd6 |
| 133015 | hbus monitor | Collected READ  addr=0x11bd data=0xd6 |
| 133035 | hbus monitor | Collected WRITE addr=0x11be data=0x20 |
| 133065 | hbus monitor | Collected READ  addr=0x11be data=0x20 |
| 133085 | hbus monitor | Collected WRITE addr=0x11bf data=0xf1 |
| 133115 | hbus monitor | Collected READ  addr=0x11bf data=0xf1 |
| 133135 | hbus monitor | Collected WRITE addr=0x11c0 data=0xc1 |
| 133165 | hbus monitor | Collected READ  addr=0x11c0 data=0xc1 |
| 133185 | hbus monitor | Collected WRITE addr=0x11c1 data=0xa4 |
| 133215 | hbus monitor | Collected READ  addr=0x11c1 data=0xa4 |
| 133235 | hbus monitor | Collected WRITE addr=0x11c2 data=0x42 |
| 133265 | hbus monitor | Collected READ  addr=0x11c2 data=0x42 |
| 133285 | hbus monitor | Collected WRITE addr=0x11c3 data=0x74 |
| 133315 | hbus monitor | Collected READ  addr=0x11c3 data=0x74 |
| 133335 | hbus monitor | Collected WRITE addr=0x11c4 data=0x94 |
| 133365 | hbus monitor | Collected READ  addr=0x11c4 data=0x94 |
| 133385 | hbus monitor | Collected WRITE addr=0x11c5 data=0xb7 |
| 133415 | hbus monitor | Collected READ  addr=0x11c5 data=0xb7 |
| 133435 | hbus monitor | Collected WRITE addr=0x11c6 data=0xde |
| 133465 | hbus monitor | Collected READ  addr=0x11c6 data=0xde |
| 133485 | hbus monitor | Collected WRITE addr=0x11c7 data=0xc1 |
| 133515 | hbus monitor | Collected READ  addr=0x11c7 data=0xc1 |
| 133535 | hbus monitor | Collected WRITE addr=0x11c8 data=0xc0 |
| 133565 | hbus monitor | Collected READ  addr=0x11c8 data=0xc0 |
| 133585 | hbus monitor | Collected WRITE addr=0x11c9 data=0x25 |
| 133615 | hbus monitor | Collected READ  addr=0x11c9 data=0x25 |
| 133635 | hbus monitor | Collected WRITE addr=0x11ca data=0xed |
| 133665 | hbus monitor | Collected READ  addr=0x11ca data=0xed |
| 133685 | hbus monitor | Collected WRITE addr=0x11cb data=0xb6 |
| 133715 | hbus monitor | Collected READ  addr=0x11cb data=0xb6 |
| 133735 | hbus monitor | Collected WRITE addr=0x11cc data=0xcb |
| 133765 | hbus monitor | Collected READ  addr=0x11cc data=0xcb |
| 133785 | hbus monitor | Collected WRITE addr=0x11cd data=0x9c |
| 133815 | hbus monitor | Collected READ  addr=0x11cd data=0x9c |
| 133835 | hbus monitor | Collected WRITE addr=0x11ce data=0x45 |
| 133865 | hbus monitor | Collected READ  addr=0x11ce data=0x45 |
| 133885 | hbus monitor | Collected WRITE addr=0x11cf data=0x24 |
| 133915 | hbus monitor | Collected READ  addr=0x11cf data=0x24 |
| 133935 | hbus monitor | Collected WRITE addr=0x11d0 data=0xfb |
| 133965 | hbus monitor | Collected READ  addr=0x11d0 data=0xfb |
| 133985 | hbus monitor | Collected WRITE addr=0x11d1 data=0x12 |
| 134015 | hbus monitor | Collected READ  addr=0x11d1 data=0x12 |
| 134035 | hbus monitor | Collected WRITE addr=0x11d2 data=0x14 |
| 134065 | hbus monitor | Collected READ  addr=0x11d2 data=0x14 |
| 134085 | hbus monitor | Collected WRITE addr=0x11d3 data=0x3f |
| 134115 | hbus monitor | Collected READ  addr=0x11d3 data=0x3f |
| 134135 | hbus monitor | Collected WRITE addr=0x11d4 data=0x97 |
| 134165 | hbus monitor | Collected READ  addr=0x11d4 data=0x97 |
| 134185 | hbus monitor | Collected WRITE addr=0x11d5 data=0x2b |
| 134215 | hbus monitor | Collected READ  addr=0x11d5 data=0x2b |
| 134235 | hbus monitor | Collected WRITE addr=0x11d6 data=0x56 |
| 134265 | hbus monitor | Collected READ  addr=0x11d6 data=0x56 |
| 134285 | hbus monitor | Collected WRITE addr=0x11d7 data=0x34 |
| 134315 | hbus monitor | Collected READ  addr=0x11d7 data=0x34 |
| 134335 | hbus monitor | Collected WRITE addr=0x11d8 data=0xfa |
| 134365 | hbus monitor | Collected READ  addr=0x11d8 data=0xfa |
| 134385 | hbus monitor | Collected WRITE addr=0x11d9 data=0x1c |
| 134415 | hbus monitor | Collected READ  addr=0x11d9 data=0x1c |
| 134435 | hbus monitor | Collected WRITE addr=0x11da data=0x30 |
| 134465 | hbus monitor | Collected READ  addr=0x11da data=0x30 |
| 134485 | hbus monitor | Collected WRITE addr=0x11db data=0x5b |
| 134515 | hbus monitor | Collected READ  addr=0x11db data=0x5b |
| 134535 | hbus monitor | Collected WRITE addr=0x11dc data=0xe1 |
| 134565 | hbus monitor | Collected READ  addr=0x11dc data=0xe1 |
| 134585 | hbus monitor | Collected WRITE addr=0x11dd data=0x91 |
| 134615 | hbus monitor | Collected READ  addr=0x11dd data=0x91 |
| 134635 | hbus monitor | Collected WRITE addr=0x11de data=0xa0 |
| 134665 | hbus monitor | Collected READ  addr=0x11de data=0xa0 |
| 134685 | hbus monitor | Collected WRITE addr=0x11df data=0x74 |
| 134715 | hbus monitor | Collected READ  addr=0x11df data=0x74 |
| 134735 | hbus monitor | Collected WRITE addr=0x11e0 data=0x4e |
| 134765 | hbus monitor | Collected READ  addr=0x11e0 data=0x4e |
| 134785 | hbus monitor | Collected WRITE addr=0x11e1 data=0xd2 |
| 134815 | hbus monitor | Collected READ  addr=0x11e1 data=0xd2 |
| 134835 | hbus monitor | Collected WRITE addr=0x11e2 data=0x40 |
| 134865 | hbus monitor | Collected READ  addr=0x11e2 data=0x40 |
| 134885 | hbus monitor | Collected WRITE addr=0x11e3 data=0x97 |
| 134915 | hbus monitor | Collected READ  addr=0x11e3 data=0x97 |
| 134935 | hbus monitor | Collected WRITE addr=0x11e4 data=0x63 |
| 134965 | hbus monitor | Collected READ  addr=0x11e4 data=0x63 |
| 134985 | hbus monitor | Collected WRITE addr=0x11e5 data=0x9d |
| 135015 | hbus monitor | Collected READ  addr=0x11e5 data=0x9d |
| 135035 | hbus monitor | Collected WRITE addr=0x11e6 data=0x44 |
| 135065 | hbus monitor | Collected READ  addr=0x11e6 data=0x44 |
| 135085 | hbus monitor | Collected WRITE addr=0x11e7 data=0x7f |
| 135115 | hbus monitor | Collected READ  addr=0x11e7 data=0x7f |
| 135135 | hbus monitor | Collected WRITE addr=0x11e8 data=0x70 |
| 135165 | hbus monitor | Collected READ  addr=0x11e8 data=0x70 |
| 135185 | hbus monitor | Collected WRITE addr=0x11e9 data=0x21 |
| 135215 | hbus monitor | Collected READ  addr=0x11e9 data=0x21 |
| 135235 | hbus monitor | Collected WRITE addr=0x11ea data=0x53 |
| 135265 | hbus monitor | Collected READ  addr=0x11ea data=0x53 |
| 135285 | hbus monitor | Collected WRITE addr=0x11eb data=0x4a |
| 135315 | hbus monitor | Collected READ  addr=0x11eb data=0x4a |
| 135335 | hbus monitor | Collected WRITE addr=0x11ec data=0x7b |
| 135365 | hbus monitor | Collected READ  addr=0x11ec data=0x7b |
| 135385 | hbus monitor | Collected WRITE addr=0x11ed data=0x19 |
| 135415 | hbus monitor | Collected READ  addr=0x11ed data=0x19 |
| 135435 | hbus monitor | Collected WRITE addr=0x11ee data=0xbc |
| 135465 | hbus monitor | Collected READ  addr=0x11ee data=0xbc |
| 135485 | hbus monitor | Collected WRITE addr=0x11ef data=0xf8 |
| 135515 | hbus monitor | Collected READ  addr=0x11ef data=0xf8 |
| 135535 | hbus monitor | Collected WRITE addr=0x11f0 data=0x0d |
| 135565 | hbus monitor | Collected READ  addr=0x11f0 data=0x0d |
| 135585 | hbus monitor | Collected WRITE addr=0x11f1 data=0x8e |
| 135615 | hbus monitor | Collected READ  addr=0x11f1 data=0x8e |
| 135635 | hbus monitor | Collected WRITE addr=0x11f2 data=0xa8 |
| 135665 | hbus monitor | Collected READ  addr=0x11f2 data=0xa8 |
| 135685 | hbus monitor | Collected WRITE addr=0x11f3 data=0xeb |
| 135715 | hbus monitor | Collected READ  addr=0x11f3 data=0xeb |
| 135735 | hbus monitor | Collected WRITE addr=0x11f4 data=0x86 |
| 135765 | hbus monitor | Collected READ  addr=0x11f4 data=0x86 |
| 135785 | hbus monitor | Collected WRITE addr=0x11f5 data=0x3c |
| 135815 | hbus monitor | Collected READ  addr=0x11f5 data=0x3c |
| 135835 | hbus monitor | Collected WRITE addr=0x11f6 data=0x6e |
| 135865 | hbus monitor | Collected READ  addr=0x11f6 data=0x6e |
| 135885 | hbus monitor | Collected WRITE addr=0x11f7 data=0x09 |
| 135915 | hbus monitor | Collected READ  addr=0x11f7 data=0x09 |
| 135935 | hbus monitor | Collected WRITE addr=0x11f8 data=0xe7 |
| 135965 | hbus monitor | Collected READ  addr=0x11f8 data=0xe7 |
| 135985 | hbus monitor | Collected WRITE addr=0x11f9 data=0xa0 |
| 136015 | hbus monitor | Collected READ  addr=0x11f9 data=0xa0 |
| 136035 | hbus monitor | Collected WRITE addr=0x11fa data=0xc8 |
| 136065 | hbus monitor | Collected READ  addr=0x11fa data=0xc8 |
| 136085 | hbus monitor | Collected WRITE addr=0x11fb data=0x63 |
| 136115 | hbus monitor | Collected READ  addr=0x11fb data=0x63 |
| 136135 | hbus monitor | Collected WRITE addr=0x11fc data=0x65 |
| 136165 | hbus monitor | Collected READ  addr=0x11fc data=0x65 |
| 136185 | hbus monitor | Collected WRITE addr=0x11fd data=0xa3 |
| 136215 | hbus monitor | Collected READ  addr=0x11fd data=0xa3 |
| 136235 | hbus monitor | Collected WRITE addr=0x11fe data=0x44 |
| 136265 | hbus monitor | Collected READ  addr=0x11fe data=0x44 |
| 136285 | hbus monitor | Collected WRITE addr=0x11ff data=0x38 |
| 136310 | **test** | STAGE: 7. the counters at 0, in between and at 255: maxpktsize = 1, 2-byte packets with bad parity |
| 136315 | hbus monitor | Collected READ  addr=0x11ff data=0x38 |
| 136335 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 136335 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 136335 | reference | maxpktsize is now 1 |
| 136365 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 136395 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 136425 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 136455 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 136485 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 136510 | **test** | STAGE: 7.1 en_reg = 0x17: 255 packets to address 0, counters read after 100 and after 255 |
| 136515 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 136535 | hbus monitor | Collected WRITE addr=0x1001 data=0x17 |
| 136535 | reference | router_en is now 1 (en_reg 0x17) |
| 136745 | **DUT** | IN  pkt #2 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 136775 | **DUT** | IN  pkt #2 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 136775 | yapp monitor | RX pkt #2 on the input: addr=0 len=2 parity=bad gap=13627 |
| 136775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 136775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 136870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 136975 | **DUT** | IN  pkt #3 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137005 | **DUT** | IN  pkt #3 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137005 | yapp monitor | RX pkt #3 on the input: addr=0 len=2 parity=bad gap=19 |
| 137005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 137215 | **DUT** | IN  pkt #4 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137245 | **DUT** | IN  pkt #4 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137245 | yapp monitor | RX pkt #4 on the input: addr=0 len=2 parity=bad gap=20 |
| 137245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 137355 | **DUT** | IN  pkt #5 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137385 | **DUT** | IN  pkt #5 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137385 | yapp monitor | RX pkt #5 on the input: addr=0 len=2 parity=bad gap=10 |
| 137385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 137475 | **DUT** | IN  pkt #6 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137505 | **DUT** | IN  pkt #6 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137505 | yapp monitor | RX pkt #6 on the input: addr=0 len=2 parity=bad gap=8 |
| 137505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137505 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 137555 | **DUT** | IN  pkt #7 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137585 | **DUT** | IN  pkt #7 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137585 | yapp monitor | RX pkt #7 on the input: addr=0 len=2 parity=bad gap=4 |
| 137585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137585 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 137785 | **DUT** | IN  pkt #8 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137815 | **DUT** | IN  pkt #8 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137815 | yapp monitor | RX pkt #8 on the input: addr=0 len=2 parity=bad gap=19 |
| 137815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 137855 | **DUT** | IN  pkt #9 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137885 | **DUT** | IN  pkt #9 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137885 | yapp monitor | RX pkt #9 on the input: addr=0 len=2 parity=bad gap=3 |
| 137885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 137965 | **DUT** | IN  pkt #10 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 137970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 137995 | **DUT** | IN  pkt #10 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 137995 | yapp monitor | RX pkt #10 on the input: addr=0 len=2 parity=bad gap=7 |
| 137995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 137995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 138205 | **DUT** | IN  pkt #11 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138235 | **DUT** | IN  pkt #11 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138235 | yapp monitor | RX pkt #11 on the input: addr=0 len=2 parity=bad gap=20 |
| 138235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 138445 | **DUT** | IN  pkt #12 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138475 | **DUT** | IN  pkt #12 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138475 | yapp monitor | RX pkt #12 on the input: addr=0 len=2 parity=bad gap=20 |
| 138475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 138545 | **DUT** | IN  pkt #13 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138575 | **DUT** | IN  pkt #13 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138575 | yapp monitor | RX pkt #13 on the input: addr=0 len=2 parity=bad gap=6 |
| 138575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 138785 | **DUT** | IN  pkt #14 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 138815 | **DUT** | IN  pkt #14 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 138815 | yapp monitor | RX pkt #14 on the input: addr=0 len=2 parity=bad gap=20 |
| 138815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 138815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 138870 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 139025 | **DUT** | IN  pkt #15 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139055 | **DUT** | IN  pkt #15 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139055 | yapp monitor | RX pkt #15 on the input: addr=0 len=2 parity=bad gap=20 |
| 139055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139090 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 139265 | **DUT** | IN  pkt #16 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139295 | **DUT** | IN  pkt #16 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139295 | yapp monitor | RX pkt #16 on the input: addr=0 len=2 parity=bad gap=20 |
| 139295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 139465 | **DUT** | IN  pkt #17 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139495 | **DUT** | IN  pkt #17 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139495 | yapp monitor | RX pkt #17 on the input: addr=0 len=2 parity=bad gap=16 |
| 139495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 139705 | **DUT** | IN  pkt #18 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139735 | **DUT** | IN  pkt #18 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139735 | yapp monitor | RX pkt #18 on the input: addr=0 len=2 parity=bad gap=20 |
| 139735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 139750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 139945 | **DUT** | IN  pkt #19 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 139975 | **DUT** | IN  pkt #19 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 139975 | yapp monitor | RX pkt #19 on the input: addr=0 len=2 parity=bad gap=20 |
| 139975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 139975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140070 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 140185 | **DUT** | IN  pkt #20 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140215 | **DUT** | IN  pkt #20 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140215 | yapp monitor | RX pkt #20 on the input: addr=0 len=2 parity=bad gap=20 |
| 140215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140230 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 140245 | **DUT** | IN  pkt #21 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140275 | **DUT** | IN  pkt #21 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140275 | yapp monitor | RX pkt #21 on the input: addr=0 len=2 parity=bad gap=2 |
| 140275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140350 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 140445 | **DUT** | IN  pkt #22 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140475 | **DUT** | IN  pkt #22 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140475 | yapp monitor | RX pkt #22 on the input: addr=0 len=2 parity=bad gap=16 |
| 140475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 140565 | **DUT** | IN  pkt #23 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140595 | **DUT** | IN  pkt #23 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140595 | yapp monitor | RX pkt #23 on the input: addr=0 len=2 parity=bad gap=8 |
| 140595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140670 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 140705 | **DUT** | IN  pkt #24 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140735 | **DUT** | IN  pkt #24 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140735 | yapp monitor | RX pkt #24 on the input: addr=0 len=2 parity=bad gap=10 |
| 140735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 140790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 140945 | **DUT** | IN  pkt #25 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 140975 | **DUT** | IN  pkt #25 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 140975 | yapp monitor | RX pkt #25 on the input: addr=0 len=2 parity=bad gap=20 |
| 140975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 140975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 141105 | **DUT** | IN  pkt #26 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141135 | **DUT** | IN  pkt #26 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141135 | yapp monitor | RX pkt #26 on the input: addr=0 len=2 parity=bad gap=12 |
| 141135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 141245 | **DUT** | IN  pkt #27 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141275 | **DUT** | IN  pkt #27 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141275 | yapp monitor | RX pkt #27 on the input: addr=0 len=2 parity=bad gap=10 |
| 141275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 141445 | **DUT** | IN  pkt #28 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141475 | **DUT** | IN  pkt #28 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141475 | yapp monitor | RX pkt #28 on the input: addr=0 len=2 parity=bad gap=16 |
| 141475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 141635 | **DUT** | IN  pkt #29 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141665 | **DUT** | IN  pkt #29 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141665 | yapp monitor | RX pkt #29 on the input: addr=0 len=2 parity=bad gap=15 |
| 141665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141665 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141690 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 141875 | **DUT** | IN  pkt #30 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 141905 | **DUT** | IN  pkt #30 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 141905 | yapp monitor | RX pkt #30 on the input: addr=0 len=2 parity=bad gap=20 |
| 141905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 141905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 141995 | **DUT** | IN  pkt #31 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142010 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 142025 | **DUT** | IN  pkt #31 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142025 | yapp monitor | RX pkt #31 on the input: addr=0 len=2 parity=bad gap=8 |
| 142025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 142175 | **DUT** | IN  pkt #32 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142205 | **DUT** | IN  pkt #32 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142205 | yapp monitor | RX pkt #32 on the input: addr=0 len=2 parity=bad gap=14 |
| 142205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 142355 | **DUT** | IN  pkt #33 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142385 | **DUT** | IN  pkt #33 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142385 | yapp monitor | RX pkt #33 on the input: addr=0 len=2 parity=bad gap=14 |
| 142385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142385 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 142595 | **DUT** | IN  pkt #34 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142625 | **DUT** | IN  pkt #34 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142625 | yapp monitor | RX pkt #34 on the input: addr=0 len=2 parity=bad gap=20 |
| 142625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 142805 | **DUT** | IN  pkt #35 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142835 | **DUT** | IN  pkt #35 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142835 | yapp monitor | RX pkt #35 on the input: addr=0 len=2 parity=bad gap=17 |
| 142835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 142910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 142955 | **DUT** | IN  pkt #36 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 142985 | **DUT** | IN  pkt #36 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 142985 | yapp monitor | RX pkt #36 on the input: addr=0 len=2 parity=bad gap=11 |
| 142985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 142985 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143050 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 143195 | **DUT** | IN  pkt #37 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143225 | **DUT** | IN  pkt #37 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143225 | yapp monitor | RX pkt #37 on the input: addr=0 len=2 parity=bad gap=20 |
| 143225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 143435 | **DUT** | IN  pkt #38 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143465 | **DUT** | IN  pkt #38 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143465 | yapp monitor | RX pkt #38 on the input: addr=0 len=2 parity=bad gap=20 |
| 143465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143465 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 143575 | **DUT** | IN  pkt #39 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143605 | **DUT** | IN  pkt #39 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143605 | yapp monitor | RX pkt #39 on the input: addr=0 len=2 parity=bad gap=10 |
| 143605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143650 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 143815 | **DUT** | IN  pkt #40 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 143845 | **DUT** | IN  pkt #40 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 143845 | yapp monitor | RX pkt #40 on the input: addr=0 len=2 parity=bad gap=20 |
| 143845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 143845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 143870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 144055 | **DUT** | IN  pkt #41 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144085 | **DUT** | IN  pkt #41 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144085 | yapp monitor | RX pkt #41 on the input: addr=0 len=2 parity=bad gap=20 |
| 144085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 144265 | **DUT** | IN  pkt #42 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144295 | **DUT** | IN  pkt #42 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144295 | yapp monitor | RX pkt #42 on the input: addr=0 len=2 parity=bad gap=17 |
| 144295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144375 | **DUT** | IN  pkt #43 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 144405 | **DUT** | IN  pkt #43 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144405 | yapp monitor | RX pkt #43 on the input: addr=0 len=2 parity=bad gap=7 |
| 144405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144405 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 144585 | **DUT** | IN  pkt #44 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144615 | **DUT** | IN  pkt #44 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144615 | yapp monitor | RX pkt #44 on the input: addr=0 len=2 parity=bad gap=17 |
| 144615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144695 | **DUT** | IN  pkt #45 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 144725 | **DUT** | IN  pkt #45 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144725 | yapp monitor | RX pkt #45 on the input: addr=0 len=2 parity=bad gap=7 |
| 144725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 144815 | **DUT** | IN  pkt #46 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 144845 | **DUT** | IN  pkt #46 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 144845 | yapp monitor | RX pkt #46 on the input: addr=0 len=2 parity=bad gap=8 |
| 144845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 144845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 144910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 145055 | **DUT** | IN  pkt #47 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145085 | **DUT** | IN  pkt #47 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145085 | yapp monitor | RX pkt #47 on the input: addr=0 len=2 parity=bad gap=20 |
| 145085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 145285 | **DUT** | IN  pkt #48 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145315 | **DUT** | IN  pkt #48 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145315 | yapp monitor | RX pkt #48 on the input: addr=0 len=2 parity=bad gap=19 |
| 145315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 145525 | **DUT** | IN  pkt #49 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145555 | **DUT** | IN  pkt #49 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145555 | yapp monitor | RX pkt #49 on the input: addr=0 len=2 parity=bad gap=20 |
| 145555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 145735 | **DUT** | IN  pkt #50 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145765 | **DUT** | IN  pkt #50 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145765 | yapp monitor | RX pkt #50 on the input: addr=0 len=2 parity=bad gap=17 |
| 145765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 145790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 145935 | **DUT** | IN  pkt #51 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 145965 | **DUT** | IN  pkt #51 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 145965 | yapp monitor | RX pkt #51 on the input: addr=0 len=2 parity=bad gap=16 |
| 145965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 145965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 146085 | **DUT** | IN  pkt #52 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146115 | **DUT** | IN  pkt #52 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146115 | yapp monitor | RX pkt #52 on the input: addr=0 len=2 parity=bad gap=11 |
| 146115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146115 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 146325 | **DUT** | IN  pkt #53 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146355 | **DUT** | IN  pkt #53 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146355 | yapp monitor | RX pkt #53 on the input: addr=0 len=2 parity=bad gap=20 |
| 146355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 146435 | **DUT** | IN  pkt #54 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146465 | **DUT** | IN  pkt #54 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146465 | yapp monitor | RX pkt #54 on the input: addr=0 len=2 parity=bad gap=7 |
| 146465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146465 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 146645 | **DUT** | IN  pkt #55 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146675 | **DUT** | IN  pkt #55 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146675 | yapp monitor | RX pkt #55 on the input: addr=0 len=2 parity=bad gap=17 |
| 146675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 146875 | **DUT** | IN  pkt #56 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 146905 | **DUT** | IN  pkt #56 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 146905 | yapp monitor | RX pkt #56 on the input: addr=0 len=2 parity=bad gap=19 |
| 146905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 146905 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 146950 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 147075 | **DUT** | IN  pkt #57 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147105 | **DUT** | IN  pkt #57 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147105 | yapp monitor | RX pkt #57 on the input: addr=0 len=2 parity=bad gap=16 |
| 147105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 147285 | **DUT** | IN  pkt #58 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147315 | **DUT** | IN  pkt #58 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147315 | yapp monitor | RX pkt #58 on the input: addr=0 len=2 parity=bad gap=17 |
| 147315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 147525 | **DUT** | IN  pkt #59 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147555 | **DUT** | IN  pkt #59 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147555 | yapp monitor | RX pkt #59 on the input: addr=0 len=2 parity=bad gap=20 |
| 147555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147610 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 147745 | **DUT** | IN  pkt #60 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147775 | **DUT** | IN  pkt #60 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147775 | yapp monitor | RX pkt #60 on the input: addr=0 len=2 parity=bad gap=18 |
| 147775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147825 | **DUT** | IN  pkt #61 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 147830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 147855 | **DUT** | IN  pkt #61 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 147855 | yapp monitor | RX pkt #61 on the input: addr=0 len=2 parity=bad gap=4 |
| 147855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 147855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 147890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 148005 | **DUT** | IN  pkt #62 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148035 | **DUT** | IN  pkt #62 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148035 | yapp monitor | RX pkt #62 on the input: addr=0 len=2 parity=bad gap=14 |
| 148035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148035 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148075 | **DUT** | IN  pkt #63 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 148105 | **DUT** | IN  pkt #63 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148105 | yapp monitor | RX pkt #63 on the input: addr=0 len=2 parity=bad gap=3 |
| 148105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 148295 | **DUT** | IN  pkt #64 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148325 | **DUT** | IN  pkt #64 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148325 | yapp monitor | RX pkt #64 on the input: addr=0 len=2 parity=bad gap=18 |
| 148325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 148525 | **DUT** | IN  pkt #65 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148555 | **DUT** | IN  pkt #65 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148555 | yapp monitor | RX pkt #65 on the input: addr=0 len=2 parity=bad gap=19 |
| 148555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 148745 | **DUT** | IN  pkt #66 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148775 | **DUT** | IN  pkt #66 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148775 | yapp monitor | RX pkt #66 on the input: addr=0 len=2 parity=bad gap=18 |
| 148775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148795 | **DUT** | IN  pkt #67 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 148825 | **DUT** | IN  pkt #67 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 148825 | yapp monitor | RX pkt #67 on the input: addr=0 len=2 parity=bad gap=1 |
| 148825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 148825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 148870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 148880 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 149035 | **DUT** | IN  pkt #68 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149065 | **DUT** | IN  pkt #68 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149065 | yapp monitor | RX pkt #68 on the input: addr=0 len=2 parity=bad gap=20 |
| 149065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149065 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149115 | **DUT** | IN  pkt #69 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 149145 | **DUT** | IN  pkt #69 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149145 | yapp monitor | RX pkt #69 on the input: addr=0 len=2 parity=bad gap=4 |
| 149145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149185 | **DUT** | IN  pkt #70 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 149215 | **DUT** | IN  pkt #70 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149215 | yapp monitor | RX pkt #70 on the input: addr=0 len=2 parity=bad gap=3 |
| 149215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149245 | **DUT** | IN  pkt #71 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 149275 | **DUT** | IN  pkt #71 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149275 | yapp monitor | RX pkt #71 on the input: addr=0 len=2 parity=bad gap=2 |
| 149275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 149445 | **DUT** | IN  pkt #72 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149475 | **DUT** | IN  pkt #72 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149475 | yapp monitor | RX pkt #72 on the input: addr=0 len=2 parity=bad gap=16 |
| 149475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149495 | **DUT** | IN  pkt #73 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149525 | **DUT** | IN  pkt #73 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149525 | yapp monitor | RX pkt #73 on the input: addr=0 len=2 parity=bad gap=1 |
| 149525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 149570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 149625 | **DUT** | IN  pkt #74 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149655 | **DUT** | IN  pkt #74 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149655 | yapp monitor | RX pkt #74 on the input: addr=0 len=2 parity=bad gap=9 |
| 149655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 149865 | **DUT** | IN  pkt #75 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 149895 | **DUT** | IN  pkt #75 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 149895 | yapp monitor | RX pkt #75 on the input: addr=0 len=2 parity=bad gap=20 |
| 149895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 149895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 149990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 150075 | **DUT** | IN  pkt #76 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150105 | **DUT** | IN  pkt #76 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150105 | yapp monitor | RX pkt #76 on the input: addr=0 len=2 parity=bad gap=17 |
| 150105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 150305 | **DUT** | IN  pkt #77 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150335 | **DUT** | IN  pkt #77 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150335 | yapp monitor | RX pkt #77 on the input: addr=0 len=2 parity=bad gap=19 |
| 150335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150335 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 150495 | **DUT** | IN  pkt #78 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150525 | **DUT** | IN  pkt #78 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150525 | yapp monitor | RX pkt #78 on the input: addr=0 len=2 parity=bad gap=15 |
| 150525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150525 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 150735 | **DUT** | IN  pkt #79 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150765 | **DUT** | IN  pkt #79 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150765 | yapp monitor | RX pkt #79 on the input: addr=0 len=2 parity=bad gap=20 |
| 150765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 150830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 150965 | **DUT** | IN  pkt #80 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 150995 | **DUT** | IN  pkt #80 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 150995 | yapp monitor | RX pkt #80 on the input: addr=0 len=2 parity=bad gap=19 |
| 150995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 150995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 151135 | **DUT** | IN  pkt #81 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151165 | **DUT** | IN  pkt #81 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151165 | yapp monitor | RX pkt #81 on the input: addr=0 len=2 parity=bad gap=13 |
| 151165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151165 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151245 | **DUT** | IN  pkt #82 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 151275 | **DUT** | IN  pkt #82 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151275 | yapp monitor | RX pkt #82 on the input: addr=0 len=2 parity=bad gap=7 |
| 151275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151275 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 151485 | **DUT** | IN  pkt #83 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151515 | **DUT** | IN  pkt #83 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151515 | yapp monitor | RX pkt #83 on the input: addr=0 len=2 parity=bad gap=20 |
| 151515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 151645 | **DUT** | IN  pkt #84 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151675 | **DUT** | IN  pkt #84 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151675 | yapp monitor | RX pkt #84 on the input: addr=0 len=2 parity=bad gap=12 |
| 151675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 151795 | **DUT** | IN  pkt #85 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151825 | **DUT** | IN  pkt #85 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151825 | yapp monitor | RX pkt #85 on the input: addr=0 len=2 parity=bad gap=11 |
| 151825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151895 | **DUT** | IN  pkt #86 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 151925 | **DUT** | IN  pkt #86 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 151925 | yapp monitor | RX pkt #86 on the input: addr=0 len=2 parity=bad gap=6 |
| 151925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 151925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 151930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 151970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 152075 | **DUT** | IN  pkt #87 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152105 | **DUT** | IN  pkt #87 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152105 | yapp monitor | RX pkt #87 on the input: addr=0 len=2 parity=bad gap=14 |
| 152105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152125 | **DUT** | IN  pkt #88 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152155 | **DUT** | IN  pkt #88 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152155 | yapp monitor | RX pkt #88 on the input: addr=0 len=2 parity=bad gap=1 |
| 152155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 152180 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 152265 | **DUT** | IN  pkt #89 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152295 | **DUT** | IN  pkt #89 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152295 | yapp monitor | RX pkt #89 on the input: addr=0 len=2 parity=bad gap=10 |
| 152295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 152485 | **DUT** | IN  pkt #90 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152515 | **DUT** | IN  pkt #90 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152515 | yapp monitor | RX pkt #90 on the input: addr=0 len=2 parity=bad gap=18 |
| 152515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 152675 | **DUT** | IN  pkt #91 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152705 | **DUT** | IN  pkt #91 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152705 | yapp monitor | RX pkt #91 on the input: addr=0 len=2 parity=bad gap=15 |
| 152705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152730 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 152865 | **DUT** | IN  pkt #92 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152895 | **DUT** | IN  pkt #92 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152895 | yapp monitor | RX pkt #92 on the input: addr=0 len=2 parity=bad gap=15 |
| 152895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152915 | **DUT** | IN  pkt #93 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 152945 | **DUT** | IN  pkt #93 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 152945 | yapp monitor | RX pkt #93 on the input: addr=0 len=2 parity=bad gap=1 |
| 152945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 152945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 152950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 153015 | **DUT** | IN  pkt #94 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153045 | **DUT** | IN  pkt #94 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153045 | yapp monitor | RX pkt #94 on the input: addr=0 len=2 parity=bad gap=6 |
| 153045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153045 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 153090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 153105 | **DUT** | IN  pkt #95 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153135 | **DUT** | IN  pkt #95 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153135 | yapp monitor | RX pkt #95 on the input: addr=0 len=2 parity=bad gap=5 |
| 153135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 153335 | **DUT** | IN  pkt #96 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153365 | **DUT** | IN  pkt #96 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153365 | yapp monitor | RX pkt #96 on the input: addr=0 len=2 parity=bad gap=19 |
| 153365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153365 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 153575 | **DUT** | IN  pkt #97 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153605 | **DUT** | IN  pkt #97 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153605 | yapp monitor | RX pkt #97 on the input: addr=0 len=2 parity=bad gap=20 |
| 153605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153605 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 153775 | **DUT** | IN  pkt #98 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153805 | **DUT** | IN  pkt #98 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153805 | yapp monitor | RX pkt #98 on the input: addr=0 len=2 parity=bad gap=16 |
| 153805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153805 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153825 | **DUT** | IN  pkt #99 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 153855 | **DUT** | IN  pkt #99 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 153855 | yapp monitor | RX pkt #99 on the input: addr=0 len=2 parity=bad gap=1 |
| 153855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 153855 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 153870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 153910 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 154065 | **DUT** | IN  pkt #100 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154095 | **DUT** | IN  pkt #100 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154095 | yapp monitor | RX pkt #100 on the input: addr=0 len=2 parity=bad gap=20 |
| 154095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 154295 | **DUT** | IN  pkt #101 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154325 | **DUT** | IN  pkt #101 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154325 | yapp monitor | RX pkt #101 on the input: addr=0 len=2 parity=bad gap=19 |
| 154325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154365 | hbus monitor | Collected READ  addr=0x1004 data=0x64 |
| 154370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 154395 | hbus monitor | Collected READ  addr=0x1005 data=0x64 |
| 154425 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 154455 | hbus monitor | Collected READ  addr=0x1009 data=0x64 |
| 154485 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 154515 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 154585 | **DUT** | IN  pkt #102 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154615 | **DUT** | IN  pkt #102 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154615 | yapp monitor | RX pkt #102 on the input: addr=0 len=2 parity=bad gap=25 |
| 154615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 154705 | **DUT** | IN  pkt #103 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154735 | **DUT** | IN  pkt #103 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154735 | yapp monitor | RX pkt #103 on the input: addr=0 len=2 parity=bad gap=8 |
| 154735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 154915 | **DUT** | IN  pkt #104 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 154945 | **DUT** | IN  pkt #104 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 154945 | yapp monitor | RX pkt #104 on the input: addr=0 len=2 parity=bad gap=17 |
| 154945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 154945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 154970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 155155 | **DUT** | IN  pkt #105 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155185 | **DUT** | IN  pkt #105 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155185 | yapp monitor | RX pkt #105 on the input: addr=0 len=2 parity=bad gap=20 |
| 155185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 155395 | **DUT** | IN  pkt #106 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155425 | **DUT** | IN  pkt #106 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155425 | yapp monitor | RX pkt #106 on the input: addr=0 len=2 parity=bad gap=20 |
| 155425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155425 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 155605 | **DUT** | IN  pkt #107 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155635 | **DUT** | IN  pkt #107 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155635 | yapp monitor | RX pkt #107 on the input: addr=0 len=2 parity=bad gap=17 |
| 155635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155635 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155655 | **DUT** | IN  pkt #108 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155685 | **DUT** | IN  pkt #108 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155685 | yapp monitor | RX pkt #108 on the input: addr=0 len=2 parity=bad gap=1 |
| 155685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 155720 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 155745 | **DUT** | IN  pkt #109 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 155775 | **DUT** | IN  pkt #109 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 155775 | yapp monitor | RX pkt #109 on the input: addr=0 len=2 parity=bad gap=5 |
| 155775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 155775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 155830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 155975 | **DUT** | IN  pkt #110 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156005 | **DUT** | IN  pkt #110 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156005 | yapp monitor | RX pkt #110 on the input: addr=0 len=2 parity=bad gap=19 |
| 156005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 156165 | **DUT** | IN  pkt #111 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156195 | **DUT** | IN  pkt #111 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156195 | yapp monitor | RX pkt #111 on the input: addr=0 len=2 parity=bad gap=15 |
| 156195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156365 | **DUT** | IN  pkt #112 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156395 | **DUT** | IN  pkt #112 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156395 | yapp monitor | RX pkt #112 on the input: addr=0 len=2 parity=bad gap=16 |
| 156395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 156485 | **DUT** | IN  pkt #113 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156515 | **DUT** | IN  pkt #113 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156515 | yapp monitor | RX pkt #113 on the input: addr=0 len=2 parity=bad gap=8 |
| 156515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156705 | **DUT** | IN  pkt #114 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156735 | **DUT** | IN  pkt #114 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156735 | yapp monitor | RX pkt #114 on the input: addr=0 len=2 parity=bad gap=18 |
| 156735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 156790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 156915 | **DUT** | IN  pkt #115 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 156945 | **DUT** | IN  pkt #115 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 156945 | yapp monitor | RX pkt #115 on the input: addr=0 len=2 parity=bad gap=17 |
| 156945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 156945 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 157145 | **DUT** | IN  pkt #116 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157175 | **DUT** | IN  pkt #116 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157175 | yapp monitor | RX pkt #116 on the input: addr=0 len=2 parity=bad gap=19 |
| 157175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157175 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157190 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 157385 | **DUT** | IN  pkt #117 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157415 | **DUT** | IN  pkt #117 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157415 | yapp monitor | RX pkt #117 on the input: addr=0 len=2 parity=bad gap=20 |
| 157415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157445 | **DUT** | IN  pkt #118 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157475 | **DUT** | IN  pkt #118 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157475 | yapp monitor | RX pkt #118 on the input: addr=0 len=2 parity=bad gap=2 |
| 157475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 157530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 157635 | **DUT** | IN  pkt #119 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157665 | **DUT** | IN  pkt #119 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157665 | yapp monitor | RX pkt #119 on the input: addr=0 len=2 parity=bad gap=15 |
| 157665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157665 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157690 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 157785 | **DUT** | IN  pkt #120 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 157815 | **DUT** | IN  pkt #120 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 157815 | yapp monitor | RX pkt #120 on the input: addr=0 len=2 parity=bad gap=11 |
| 157815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 157815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 157830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 158025 | **DUT** | IN  pkt #121 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158055 | **DUT** | IN  pkt #121 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158055 | yapp monitor | RX pkt #121 on the input: addr=0 len=2 parity=bad gap=20 |
| 158055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158075 | **DUT** | IN  pkt #122 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158105 | **DUT** | IN  pkt #122 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158105 | yapp monitor | RX pkt #122 on the input: addr=0 len=2 parity=bad gap=1 |
| 158105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158105 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158125 | **DUT** | IN  pkt #123 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158150 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 158155 | **DUT** | IN  pkt #123 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158155 | yapp monitor | RX pkt #123 on the input: addr=0 len=2 parity=bad gap=1 |
| 158155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158160 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 158190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 158265 | **DUT** | IN  pkt #124 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158295 | **DUT** | IN  pkt #124 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158295 | yapp monitor | RX pkt #124 on the input: addr=0 len=2 parity=bad gap=10 |
| 158295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158295 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158310 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 158485 | **DUT** | IN  pkt #125 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158515 | **DUT** | IN  pkt #125 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158515 | yapp monitor | RX pkt #125 on the input: addr=0 len=2 parity=bad gap=18 |
| 158515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 158645 | **DUT** | IN  pkt #126 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158675 | **DUT** | IN  pkt #126 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158675 | yapp monitor | RX pkt #126 on the input: addr=0 len=2 parity=bad gap=12 |
| 158675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158745 | **DUT** | IN  pkt #127 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 158775 | **DUT** | IN  pkt #127 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158775 | yapp monitor | RX pkt #127 on the input: addr=0 len=2 parity=bad gap=6 |
| 158775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 158790 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 158935 | **DUT** | IN  pkt #128 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 158965 | **DUT** | IN  pkt #128 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 158965 | yapp monitor | RX pkt #128 on the input: addr=0 len=2 parity=bad gap=15 |
| 158965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 158965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 159065 | **DUT** | IN  pkt #129 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159095 | **DUT** | IN  pkt #129 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159095 | yapp monitor | RX pkt #129 on the input: addr=0 len=2 parity=bad gap=9 |
| 159095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159095 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159110 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 159295 | **DUT** | IN  pkt #130 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159325 | **DUT** | IN  pkt #130 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159325 | yapp monitor | RX pkt #130 on the input: addr=0 len=2 parity=bad gap=19 |
| 159325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159385 | **DUT** | IN  pkt #131 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 159415 | **DUT** | IN  pkt #131 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159415 | yapp monitor | RX pkt #131 on the input: addr=0 len=2 parity=bad gap=5 |
| 159415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 159625 | **DUT** | IN  pkt #132 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159655 | **DUT** | IN  pkt #132 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159655 | yapp monitor | RX pkt #132 on the input: addr=0 len=2 parity=bad gap=20 |
| 159655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159745 | **DUT** | IN  pkt #133 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 159750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 159775 | **DUT** | IN  pkt #133 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 159775 | yapp monitor | RX pkt #133 on the input: addr=0 len=2 parity=bad gap=8 |
| 159775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 159775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 159830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 159985 | **DUT** | IN  pkt #134 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160015 | **DUT** | IN  pkt #134 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160015 | yapp monitor | RX pkt #134 on the input: addr=0 len=2 parity=bad gap=20 |
| 160015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160015 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 160145 | **DUT** | IN  pkt #135 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160175 | **DUT** | IN  pkt #135 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160175 | yapp monitor | RX pkt #135 on the input: addr=0 len=2 parity=bad gap=12 |
| 160175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160175 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 160235 | **DUT** | IN  pkt #136 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160265 | **DUT** | IN  pkt #136 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160265 | yapp monitor | RX pkt #136 on the input: addr=0 len=2 parity=bad gap=5 |
| 160265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160265 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 160345 | **DUT** | IN  pkt #137 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160375 | **DUT** | IN  pkt #137 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160375 | yapp monitor | RX pkt #137 on the input: addr=0 len=2 parity=bad gap=7 |
| 160375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 160465 | **DUT** | IN  pkt #138 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160495 | **DUT** | IN  pkt #138 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160495 | yapp monitor | RX pkt #138 on the input: addr=0 len=2 parity=bad gap=8 |
| 160495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 160705 | **DUT** | IN  pkt #139 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160735 | **DUT** | IN  pkt #139 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160735 | yapp monitor | RX pkt #139 on the input: addr=0 len=2 parity=bad gap=20 |
| 160735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160735 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 160805 | **DUT** | IN  pkt #140 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 160835 | **DUT** | IN  pkt #140 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 160835 | yapp monitor | RX pkt #140 on the input: addr=0 len=2 parity=bad gap=6 |
| 160835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 160835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 160890 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 160995 | **DUT** | IN  pkt #141 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161025 | **DUT** | IN  pkt #141 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161025 | yapp monitor | RX pkt #141 on the input: addr=0 len=2 parity=bad gap=15 |
| 161025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161025 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 161185 | **DUT** | IN  pkt #142 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161215 | **DUT** | IN  pkt #142 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161215 | yapp monitor | RX pkt #142 on the input: addr=0 len=2 parity=bad gap=15 |
| 161215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 161415 | **DUT** | IN  pkt #143 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161445 | **DUT** | IN  pkt #143 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161445 | yapp monitor | RX pkt #143 on the input: addr=0 len=2 parity=bad gap=19 |
| 161445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 161625 | **DUT** | IN  pkt #144 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161655 | **DUT** | IN  pkt #144 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161655 | yapp monitor | RX pkt #144 on the input: addr=0 len=2 parity=bad gap=17 |
| 161655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 161865 | **DUT** | IN  pkt #145 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161895 | **DUT** | IN  pkt #145 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 161895 | yapp monitor | RX pkt #145 on the input: addr=0 len=2 parity=bad gap=20 |
| 161895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 161895 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 161985 | **DUT** | IN  pkt #146 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 161990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 162015 | **DUT** | IN  pkt #146 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162015 | yapp monitor | RX pkt #146 on the input: addr=0 len=2 parity=bad gap=8 |
| 162015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162015 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 162195 | **DUT** | IN  pkt #147 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162225 | **DUT** | IN  pkt #147 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162225 | yapp monitor | RX pkt #147 on the input: addr=0 len=2 parity=bad gap=17 |
| 162225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162225 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162275 | **DUT** | IN  pkt #148 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162305 | **DUT** | IN  pkt #148 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162305 | yapp monitor | RX pkt #148 on the input: addr=0 len=2 parity=bad gap=4 |
| 162305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 162340 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 162435 | **DUT** | IN  pkt #149 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162465 | **DUT** | IN  pkt #149 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162465 | yapp monitor | RX pkt #149 on the input: addr=0 len=2 parity=bad gap=12 |
| 162465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162465 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 162615 | **DUT** | IN  pkt #150 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162645 | **DUT** | IN  pkt #150 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162645 | yapp monitor | RX pkt #150 on the input: addr=0 len=2 parity=bad gap=14 |
| 162645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 162815 | **DUT** | IN  pkt #151 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 162845 | **DUT** | IN  pkt #151 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 162845 | yapp monitor | RX pkt #151 on the input: addr=0 len=2 parity=bad gap=16 |
| 162845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 162845 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 162930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 163055 | **DUT** | IN  pkt #152 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163085 | **DUT** | IN  pkt #152 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163085 | yapp monitor | RX pkt #152 on the input: addr=0 len=2 parity=bad gap=20 |
| 163085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 163215 | **DUT** | IN  pkt #153 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163245 | **DUT** | IN  pkt #153 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163245 | yapp monitor | RX pkt #153 on the input: addr=0 len=2 parity=bad gap=12 |
| 163245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 163455 | **DUT** | IN  pkt #154 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163485 | **DUT** | IN  pkt #154 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163485 | yapp monitor | RX pkt #154 on the input: addr=0 len=2 parity=bad gap=20 |
| 163485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163485 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 163585 | **DUT** | IN  pkt #155 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163615 | **DUT** | IN  pkt #155 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163615 | yapp monitor | RX pkt #155 on the input: addr=0 len=2 parity=bad gap=9 |
| 163615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163645 | **DUT** | IN  pkt #156 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 163675 | **DUT** | IN  pkt #156 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163675 | yapp monitor | RX pkt #156 on the input: addr=0 len=2 parity=bad gap=2 |
| 163675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163675 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 163885 | **DUT** | IN  pkt #157 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 163915 | **DUT** | IN  pkt #157 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 163915 | yapp monitor | RX pkt #157 on the input: addr=0 len=2 parity=bad gap=20 |
| 163915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 163915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 163950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 164115 | **DUT** | IN  pkt #158 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164145 | **DUT** | IN  pkt #158 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164145 | yapp monitor | RX pkt #158 on the input: addr=0 len=2 parity=bad gap=19 |
| 164145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164145 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164250 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 164325 | **DUT** | IN  pkt #159 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164355 | **DUT** | IN  pkt #159 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164355 | yapp monitor | RX pkt #159 on the input: addr=0 len=2 parity=bad gap=17 |
| 164355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164385 | **DUT** | IN  pkt #160 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164410 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 164415 | **DUT** | IN  pkt #160 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164415 | yapp monitor | RX pkt #160 on the input: addr=0 len=2 parity=bad gap=2 |
| 164415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164415 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164470 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 164595 | **DUT** | IN  pkt #161 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164625 | **DUT** | IN  pkt #161 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164625 | yapp monitor | RX pkt #161 on the input: addr=0 len=2 parity=bad gap=17 |
| 164625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164625 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164730 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 164795 | **DUT** | IN  pkt #162 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 164825 | **DUT** | IN  pkt #162 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 164825 | yapp monitor | RX pkt #162 on the input: addr=0 len=2 parity=bad gap=16 |
| 164825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 164825 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 164870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 165015 | **DUT** | IN  pkt #163 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165045 | **DUT** | IN  pkt #163 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165045 | yapp monitor | RX pkt #163 on the input: addr=0 len=2 parity=bad gap=18 |
| 165045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165045 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 165105 | **DUT** | IN  pkt #164 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165135 | **DUT** | IN  pkt #164 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165135 | yapp monitor | RX pkt #164 on the input: addr=0 len=2 parity=bad gap=5 |
| 165135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165155 | **DUT** | IN  pkt #165 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165170 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 165185 | **DUT** | IN  pkt #165 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165185 | yapp monitor | RX pkt #165 on the input: addr=0 len=2 parity=bad gap=1 |
| 165185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165185 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 165395 | **DUT** | IN  pkt #166 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165425 | **DUT** | IN  pkt #166 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165425 | yapp monitor | RX pkt #166 on the input: addr=0 len=2 parity=bad gap=20 |
| 165425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165425 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 165615 | **DUT** | IN  pkt #167 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165645 | **DUT** | IN  pkt #167 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165645 | yapp monitor | RX pkt #167 on the input: addr=0 len=2 parity=bad gap=18 |
| 165645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165645 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165665 | **DUT** | IN  pkt #168 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165695 | **DUT** | IN  pkt #168 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165695 | yapp monitor | RX pkt #168 on the input: addr=0 len=2 parity=bad gap=1 |
| 165695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 165750 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 165835 | **DUT** | IN  pkt #169 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165865 | **DUT** | IN  pkt #169 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165865 | yapp monitor | RX pkt #169 on the input: addr=0 len=2 parity=bad gap=13 |
| 165865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165865 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165895 | **DUT** | IN  pkt #170 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 165925 | **DUT** | IN  pkt #170 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 165925 | yapp monitor | RX pkt #170 on the input: addr=0 len=2 parity=bad gap=2 |
| 165925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 165925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 165930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 165950 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 166105 | **DUT** | IN  pkt #171 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166135 | **DUT** | IN  pkt #171 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166135 | yapp monitor | RX pkt #171 on the input: addr=0 len=2 parity=bad gap=17 |
| 166135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 166215 | **DUT** | IN  pkt #172 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166245 | **DUT** | IN  pkt #172 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166245 | yapp monitor | RX pkt #172 on the input: addr=0 len=2 parity=bad gap=7 |
| 166245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 166285 | **DUT** | IN  pkt #173 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166315 | **DUT** | IN  pkt #173 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166315 | yapp monitor | RX pkt #173 on the input: addr=0 len=2 parity=bad gap=3 |
| 166315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166350 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 166525 | **DUT** | IN  pkt #174 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166555 | **DUT** | IN  pkt #174 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166555 | yapp monitor | RX pkt #174 on the input: addr=0 len=2 parity=bad gap=20 |
| 166555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166555 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 166675 | **DUT** | IN  pkt #175 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166705 | **DUT** | IN  pkt #175 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166705 | yapp monitor | RX pkt #175 on the input: addr=0 len=2 parity=bad gap=11 |
| 166705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166705 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 166855 | **DUT** | IN  pkt #176 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 166885 | **DUT** | IN  pkt #176 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 166885 | yapp monitor | RX pkt #176 on the input: addr=0 len=2 parity=bad gap=14 |
| 166885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 166885 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 166910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 167095 | **DUT** | IN  pkt #177 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167125 | **DUT** | IN  pkt #177 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167125 | yapp monitor | RX pkt #177 on the input: addr=0 len=2 parity=bad gap=20 |
| 167125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167125 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 167275 | **DUT** | IN  pkt #178 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167305 | **DUT** | IN  pkt #178 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167305 | yapp monitor | RX pkt #178 on the input: addr=0 len=2 parity=bad gap=14 |
| 167305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167370 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 167505 | **DUT** | IN  pkt #179 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167535 | **DUT** | IN  pkt #179 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167535 | yapp monitor | RX pkt #179 on the input: addr=0 len=2 parity=bad gap=19 |
| 167535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167535 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167570 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 167625 | **DUT** | IN  pkt #180 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167655 | **DUT** | IN  pkt #180 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167655 | yapp monitor | RX pkt #180 on the input: addr=0 len=2 parity=bad gap=8 |
| 167655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167655 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 167805 | **DUT** | IN  pkt #181 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167835 | **DUT** | IN  pkt #181 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167835 | yapp monitor | RX pkt #181 on the input: addr=0 len=2 parity=bad gap=14 |
| 167835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167835 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 167850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 167935 | **DUT** | IN  pkt #182 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 167965 | **DUT** | IN  pkt #182 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 167965 | yapp monitor | RX pkt #182 on the input: addr=0 len=2 parity=bad gap=9 |
| 167965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 167965 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 168175 | **DUT** | IN  pkt #183 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168205 | **DUT** | IN  pkt #183 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168205 | yapp monitor | RX pkt #183 on the input: addr=0 len=2 parity=bad gap=20 |
| 168205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168235 | **DUT** | IN  pkt #184 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168265 | **DUT** | IN  pkt #184 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168265 | yapp monitor | RX pkt #184 on the input: addr=0 len=2 parity=bad gap=2 |
| 168265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168265 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168270 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 168330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 168415 | **DUT** | IN  pkt #185 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168445 | **DUT** | IN  pkt #185 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168445 | yapp monitor | RX pkt #185 on the input: addr=0 len=2 parity=bad gap=14 |
| 168445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 168655 | **DUT** | IN  pkt #186 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168685 | **DUT** | IN  pkt #186 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168685 | yapp monitor | RX pkt #186 on the input: addr=0 len=2 parity=bad gap=20 |
| 168685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168745 | **DUT** | IN  pkt #187 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 168775 | **DUT** | IN  pkt #187 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168775 | yapp monitor | RX pkt #187 on the input: addr=0 len=2 parity=bad gap=5 |
| 168775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168775 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 168870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 168965 | **DUT** | IN  pkt #188 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 168995 | **DUT** | IN  pkt #188 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 168995 | yapp monitor | RX pkt #188 on the input: addr=0 len=2 parity=bad gap=18 |
| 168995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 168995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 169205 | **DUT** | IN  pkt #189 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169235 | **DUT** | IN  pkt #189 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169235 | yapp monitor | RX pkt #189 on the input: addr=0 len=2 parity=bad gap=20 |
| 169235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169235 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 169445 | **DUT** | IN  pkt #190 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169475 | **DUT** | IN  pkt #190 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169475 | yapp monitor | RX pkt #190 on the input: addr=0 len=2 parity=bad gap=20 |
| 169475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169475 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 169585 | **DUT** | IN  pkt #191 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169615 | **DUT** | IN  pkt #191 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169615 | yapp monitor | RX pkt #191 on the input: addr=0 len=2 parity=bad gap=10 |
| 169615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 169725 | **DUT** | IN  pkt #192 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169755 | **DUT** | IN  pkt #192 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169755 | yapp monitor | RX pkt #192 on the input: addr=0 len=2 parity=bad gap=10 |
| 169755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 169925 | **DUT** | IN  pkt #193 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 169955 | **DUT** | IN  pkt #193 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 169955 | yapp monitor | RX pkt #193 on the input: addr=0 len=2 parity=bad gap=16 |
| 169955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 169955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 169975 | **DUT** | IN  pkt #194 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170005 | **DUT** | IN  pkt #194 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170005 | yapp monitor | RX pkt #194 on the input: addr=0 len=2 parity=bad gap=1 |
| 170005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 170050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 170175 | **DUT** | IN  pkt #195 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170205 | **DUT** | IN  pkt #195 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170205 | yapp monitor | RX pkt #195 on the input: addr=0 len=2 parity=bad gap=16 |
| 170205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 170415 | **DUT** | IN  pkt #196 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170445 | **DUT** | IN  pkt #196 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170445 | yapp monitor | RX pkt #196 on the input: addr=0 len=2 parity=bad gap=20 |
| 170445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 170655 | **DUT** | IN  pkt #197 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170685 | **DUT** | IN  pkt #197 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170685 | yapp monitor | RX pkt #197 on the input: addr=0 len=2 parity=bad gap=20 |
| 170685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170770 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 170895 | **DUT** | IN  pkt #198 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 170925 | **DUT** | IN  pkt #198 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 170925 | yapp monitor | RX pkt #198 on the input: addr=0 len=2 parity=bad gap=20 |
| 170925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 170925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 170990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 171105 | **DUT** | IN  pkt #199 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171135 | **DUT** | IN  pkt #199 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171135 | yapp monitor | RX pkt #199 on the input: addr=0 len=2 parity=bad gap=17 |
| 171135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171135 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171190 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 171325 | **DUT** | IN  pkt #200 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171355 | **DUT** | IN  pkt #200 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171355 | yapp monitor | RX pkt #200 on the input: addr=0 len=2 parity=bad gap=18 |
| 171355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 171535 | **DUT** | IN  pkt #201 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171565 | **DUT** | IN  pkt #201 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171565 | yapp monitor | RX pkt #201 on the input: addr=0 len=2 parity=bad gap=17 |
| 171565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171630 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 171725 | **DUT** | IN  pkt #202 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171755 | **DUT** | IN  pkt #202 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171755 | yapp monitor | RX pkt #202 on the input: addr=0 len=2 parity=bad gap=15 |
| 171755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171755 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171775 | **DUT** | IN  pkt #203 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 171805 | **DUT** | IN  pkt #203 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171805 | yapp monitor | RX pkt #203 on the input: addr=0 len=2 parity=bad gap=1 |
| 171805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171805 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 171890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 171925 | **DUT** | IN  pkt #204 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 171955 | **DUT** | IN  pkt #204 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 171955 | yapp monitor | RX pkt #204 on the input: addr=0 len=2 parity=bad gap=11 |
| 171955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 171955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172030 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 172125 | **DUT** | IN  pkt #205 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172155 | **DUT** | IN  pkt #205 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172155 | yapp monitor | RX pkt #205 on the input: addr=0 len=2 parity=bad gap=16 |
| 172155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172155 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172170 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 172365 | **DUT** | IN  pkt #206 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172395 | **DUT** | IN  pkt #206 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172395 | yapp monitor | RX pkt #206 on the input: addr=0 len=2 parity=bad gap=20 |
| 172395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172395 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172415 | **DUT** | IN  pkt #207 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 172445 | **DUT** | IN  pkt #207 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172445 | yapp monitor | RX pkt #207 on the input: addr=0 len=2 parity=bad gap=1 |
| 172445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172445 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172505 | **DUT** | IN  pkt #208 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172530 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 172535 | **DUT** | IN  pkt #208 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172535 | yapp monitor | RX pkt #208 on the input: addr=0 len=2 parity=bad gap=5 |
| 172535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172535 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 172715 | **DUT** | IN  pkt #209 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172745 | **DUT** | IN  pkt #209 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172745 | yapp monitor | RX pkt #209 on the input: addr=0 len=2 parity=bad gap=17 |
| 172745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172745 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 172810 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 172955 | **DUT** | IN  pkt #210 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 172985 | **DUT** | IN  pkt #210 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 172985 | yapp monitor | RX pkt #210 on the input: addr=0 len=2 parity=bad gap=20 |
| 172985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 172985 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173030 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 173185 | **DUT** | IN  pkt #211 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173215 | **DUT** | IN  pkt #211 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173215 | yapp monitor | RX pkt #211 on the input: addr=0 len=2 parity=bad gap=19 |
| 173215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173270 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 173275 | **DUT** | IN  pkt #212 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173305 | **DUT** | IN  pkt #212 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173305 | yapp monitor | RX pkt #212 on the input: addr=0 len=2 parity=bad gap=5 |
| 173305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173305 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173325 | **DUT** | IN  pkt #213 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173350 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 173355 | **DUT** | IN  pkt #213 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173355 | yapp monitor | RX pkt #213 on the input: addr=0 len=2 parity=bad gap=1 |
| 173355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173355 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 173565 | **DUT** | IN  pkt #214 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173595 | **DUT** | IN  pkt #214 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173595 | yapp monitor | RX pkt #214 on the input: addr=0 len=2 parity=bad gap=20 |
| 173595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173595 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 173785 | **DUT** | IN  pkt #215 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173815 | **DUT** | IN  pkt #215 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173815 | yapp monitor | RX pkt #215 on the input: addr=0 len=2 parity=bad gap=18 |
| 173815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 173830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 173925 | **DUT** | IN  pkt #216 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 173955 | **DUT** | IN  pkt #216 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 173955 | yapp monitor | RX pkt #216 on the input: addr=0 len=2 parity=bad gap=10 |
| 173955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 173955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 174055 | **DUT** | IN  pkt #217 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174085 | **DUT** | IN  pkt #217 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174085 | yapp monitor | RX pkt #217 on the input: addr=0 len=2 parity=bad gap=9 |
| 174085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174085 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174110 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 174255 | **DUT** | IN  pkt #218 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174285 | **DUT** | IN  pkt #218 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174285 | yapp monitor | RX pkt #218 on the input: addr=0 len=2 parity=bad gap=16 |
| 174285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174285 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 174485 | **DUT** | IN  pkt #219 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174515 | **DUT** | IN  pkt #219 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174515 | yapp monitor | RX pkt #219 on the input: addr=0 len=2 parity=bad gap=19 |
| 174515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174515 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174535 | **DUT** | IN  pkt #220 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174565 | **DUT** | IN  pkt #220 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174565 | yapp monitor | RX pkt #220 on the input: addr=0 len=2 parity=bad gap=1 |
| 174565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174585 | **DUT** | IN  pkt #221 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 174600 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 174615 | **DUT** | IN  pkt #221 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174615 | yapp monitor | RX pkt #221 on the input: addr=0 len=2 parity=bad gap=1 |
| 174615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 174735 | **DUT** | IN  pkt #222 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174765 | **DUT** | IN  pkt #222 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174765 | yapp monitor | RX pkt #222 on the input: addr=0 len=2 parity=bad gap=11 |
| 174765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174765 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 174830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 174945 | **DUT** | IN  pkt #223 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 174975 | **DUT** | IN  pkt #223 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 174975 | yapp monitor | RX pkt #223 on the input: addr=0 len=2 parity=bad gap=17 |
| 174975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 174975 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 175185 | **DUT** | IN  pkt #224 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175215 | **DUT** | IN  pkt #224 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175215 | yapp monitor | RX pkt #224 on the input: addr=0 len=2 parity=bad gap=20 |
| 175215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175215 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 175425 | **DUT** | IN  pkt #225 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175455 | **DUT** | IN  pkt #225 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175455 | yapp monitor | RX pkt #225 on the input: addr=0 len=2 parity=bad gap=20 |
| 175455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175455 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175510 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 175665 | **DUT** | IN  pkt #226 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175695 | **DUT** | IN  pkt #226 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175695 | yapp monitor | RX pkt #226 on the input: addr=0 len=2 parity=bad gap=20 |
| 175695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175695 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 175895 | **DUT** | IN  pkt #227 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 175925 | **DUT** | IN  pkt #227 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 175925 | yapp monitor | RX pkt #227 on the input: addr=0 len=2 parity=bad gap=19 |
| 175925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 175925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 175970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 176045 | **DUT** | IN  pkt #228 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176075 | **DUT** | IN  pkt #228 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176075 | yapp monitor | RX pkt #228 on the input: addr=0 len=2 parity=bad gap=11 |
| 176075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176075 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176110 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 176285 | **DUT** | IN  pkt #229 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176315 | **DUT** | IN  pkt #229 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176315 | yapp monitor | RX pkt #229 on the input: addr=0 len=2 parity=bad gap=20 |
| 176315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176315 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 176515 | **DUT** | IN  pkt #230 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176545 | **DUT** | IN  pkt #230 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176545 | yapp monitor | RX pkt #230 on the input: addr=0 len=2 parity=bad gap=19 |
| 176545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176545 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 176755 | **DUT** | IN  pkt #231 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 176785 | **DUT** | IN  pkt #231 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 176785 | yapp monitor | RX pkt #231 on the input: addr=0 len=2 parity=bad gap=20 |
| 176785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 176785 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 176890 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 176985 | **DUT** | IN  pkt #232 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177015 | **DUT** | IN  pkt #232 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177015 | yapp monitor | RX pkt #232 on the input: addr=0 len=2 parity=bad gap=19 |
| 177015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177015 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 177165 | **DUT** | IN  pkt #233 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177195 | **DUT** | IN  pkt #233 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177195 | yapp monitor | RX pkt #233 on the input: addr=0 len=2 parity=bad gap=14 |
| 177195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 177295 | **DUT** | IN  pkt #234 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177325 | **DUT** | IN  pkt #234 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177325 | yapp monitor | RX pkt #234 on the input: addr=0 len=2 parity=bad gap=9 |
| 177325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177325 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 177535 | **DUT** | IN  pkt #235 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177565 | **DUT** | IN  pkt #235 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177565 | yapp monitor | RX pkt #235 on the input: addr=0 len=2 parity=bad gap=20 |
| 177565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177565 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 177695 | **DUT** | IN  pkt #236 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177725 | **DUT** | IN  pkt #236 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177725 | yapp monitor | RX pkt #236 on the input: addr=0 len=2 parity=bad gap=12 |
| 177725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177725 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 177895 | **DUT** | IN  pkt #237 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177925 | **DUT** | IN  pkt #237 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177925 | yapp monitor | RX pkt #237 on the input: addr=0 len=2 parity=bad gap=16 |
| 177925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177925 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 177950 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 177965 | **DUT** | IN  pkt #238 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 177995 | **DUT** | IN  pkt #238 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 177995 | yapp monitor | RX pkt #238 on the input: addr=0 len=2 parity=bad gap=3 |
| 177995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 177995 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 178175 | **DUT** | IN  pkt #239 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178205 | **DUT** | IN  pkt #239 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178205 | yapp monitor | RX pkt #239 on the input: addr=0 len=2 parity=bad gap=17 |
| 178205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178205 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178225 | **DUT** | IN  pkt #240 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178255 | **DUT** | IN  pkt #240 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178255 | yapp monitor | RX pkt #240 on the input: addr=0 len=2 parity=bad gap=1 |
| 178255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178255 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 178300 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 178465 | **DUT** | IN  pkt #241 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178495 | **DUT** | IN  pkt #241 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178495 | yapp monitor | RX pkt #241 on the input: addr=0 len=2 parity=bad gap=20 |
| 178495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178495 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178550 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 178685 | **DUT** | IN  pkt #242 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178715 | **DUT** | IN  pkt #242 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178715 | yapp monitor | RX pkt #242 on the input: addr=0 len=2 parity=bad gap=18 |
| 178715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178715 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 178925 | **DUT** | IN  pkt #243 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 178955 | **DUT** | IN  pkt #243 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 178955 | yapp monitor | RX pkt #243 on the input: addr=0 len=2 parity=bad gap=20 |
| 178955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 178955 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 178990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 179165 | **DUT** | IN  pkt #244 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179195 | **DUT** | IN  pkt #244 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179195 | yapp monitor | RX pkt #244 on the input: addr=0 len=2 parity=bad gap=20 |
| 179195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179195 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 179345 | **DUT** | IN  pkt #245 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179375 | **DUT** | IN  pkt #245 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179375 | yapp monitor | RX pkt #245 on the input: addr=0 len=2 parity=bad gap=14 |
| 179375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179410 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 179585 | **DUT** | IN  pkt #246 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179615 | **DUT** | IN  pkt #246 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179615 | yapp monitor | RX pkt #246 on the input: addr=0 len=2 parity=bad gap=20 |
| 179615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179615 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179655 | **DUT** | IN  pkt #247 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179670 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 179685 | **DUT** | IN  pkt #247 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179685 | yapp monitor | RX pkt #247 on the input: addr=0 len=2 parity=bad gap=3 |
| 179685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 179885 | **DUT** | IN  pkt #248 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 179915 | **DUT** | IN  pkt #248 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 179915 | yapp monitor | RX pkt #248 on the input: addr=0 len=2 parity=bad gap=19 |
| 179915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 179915 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 179950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 180025 | **DUT** | IN  pkt #249 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180055 | **DUT** | IN  pkt #249 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180055 | yapp monitor | RX pkt #249 on the input: addr=0 len=2 parity=bad gap=10 |
| 180055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180055 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 180215 | **DUT** | IN  pkt #250 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180245 | **DUT** | IN  pkt #250 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180245 | yapp monitor | RX pkt #250 on the input: addr=0 len=2 parity=bad gap=15 |
| 180245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 180345 | **DUT** | IN  pkt #251 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180375 | **DUT** | IN  pkt #251 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180375 | yapp monitor | RX pkt #251 on the input: addr=0 len=2 parity=bad gap=9 |
| 180375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180375 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 180455 | **DUT** | IN  pkt #252 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180485 | **DUT** | IN  pkt #252 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180485 | yapp monitor | RX pkt #252 on the input: addr=0 len=2 parity=bad gap=7 |
| 180485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180485 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 180545 | **DUT** | IN  pkt #253 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180575 | **DUT** | IN  pkt #253 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180575 | yapp monitor | RX pkt #253 on the input: addr=0 len=2 parity=bad gap=5 |
| 180575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180575 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 180785 | **DUT** | IN  pkt #254 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 180815 | **DUT** | IN  pkt #254 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 180815 | yapp monitor | RX pkt #254 on the input: addr=0 len=2 parity=bad gap=20 |
| 180815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 180815 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 180850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 180975 | **DUT** | IN  pkt #255 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181005 | **DUT** | IN  pkt #255 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181005 | yapp monitor | RX pkt #255 on the input: addr=0 len=2 parity=bad gap=15 |
| 181005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 181005 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 181070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 181215 | **DUT** | IN  pkt #256 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181245 | **DUT** | IN  pkt #256 complete: addr=0 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181245 | yapp monitor | RX pkt #256 on the input: addr=0 len=2 parity=bad gap=20 |
| 181245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=0) |
| 181245 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 181285 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 181315 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 181330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 181345 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 181375 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 181405 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 181430 | **test** | STAGE: 7.2 en_reg = 0x21: 255 packets to address 1, counters read after 100 and after 255 |
| 181435 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 181455 | hbus monitor | Collected WRITE addr=0x1001 data=0x21 |
| 181455 | reference | router_en is now 1 (en_reg 0x21) |
| 181615 | **DUT** | IN  pkt #257 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181645 | **DUT** | IN  pkt #257 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181645 | yapp monitor | RX pkt #257 on the input: addr=1 len=2 parity=bad gap=36 |
| 181645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 181855 | **DUT** | IN  pkt #258 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 181885 | **DUT** | IN  pkt #258 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 181885 | yapp monitor | RX pkt #258 on the input: addr=1 len=2 parity=bad gap=20 |
| 181885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 181885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 181970 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 182095 | **DUT** | IN  pkt #259 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182125 | **DUT** | IN  pkt #259 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182125 | yapp monitor | RX pkt #259 on the input: addr=1 len=2 parity=bad gap=20 |
| 182125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 182215 | **DUT** | IN  pkt #260 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182245 | **DUT** | IN  pkt #260 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182245 | yapp monitor | RX pkt #260 on the input: addr=1 len=2 parity=bad gap=8 |
| 182245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 182445 | **DUT** | IN  pkt #261 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182475 | **DUT** | IN  pkt #261 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182475 | yapp monitor | RX pkt #261 on the input: addr=1 len=2 parity=bad gap=19 |
| 182475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182475 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182505 | **DUT** | IN  pkt #262 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 182535 | **DUT** | IN  pkt #262 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182535 | yapp monitor | RX pkt #262 on the input: addr=1 len=2 parity=bad gap=2 |
| 182535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182630 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 182725 | **DUT** | IN  pkt #263 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182755 | **DUT** | IN  pkt #263 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182755 | yapp monitor | RX pkt #263 on the input: addr=1 len=2 parity=bad gap=18 |
| 182755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182795 | **DUT** | IN  pkt #264 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 182810 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 182825 | **DUT** | IN  pkt #264 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 182825 | yapp monitor | RX pkt #264 on the input: addr=1 len=2 parity=bad gap=3 |
| 182825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 182825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 182890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 183005 | **DUT** | IN  pkt #265 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183035 | **DUT** | IN  pkt #265 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183035 | yapp monitor | RX pkt #265 on the input: addr=1 len=2 parity=bad gap=17 |
| 183035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183035 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 183245 | **DUT** | IN  pkt #266 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183275 | **DUT** | IN  pkt #266 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183275 | yapp monitor | RX pkt #266 on the input: addr=1 len=2 parity=bad gap=20 |
| 183275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 183315 | **DUT** | IN  pkt #267 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183345 | **DUT** | IN  pkt #267 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183345 | yapp monitor | RX pkt #267 on the input: addr=1 len=2 parity=bad gap=3 |
| 183345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 183495 | **DUT** | IN  pkt #268 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183525 | **DUT** | IN  pkt #268 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183525 | yapp monitor | RX pkt #268 on the input: addr=1 len=2 parity=bad gap=14 |
| 183525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183525 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 183645 | **DUT** | IN  pkt #269 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183675 | **DUT** | IN  pkt #269 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183675 | yapp monitor | RX pkt #269 on the input: addr=1 len=2 parity=bad gap=11 |
| 183675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 183865 | **DUT** | IN  pkt #270 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 183895 | **DUT** | IN  pkt #270 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 183895 | yapp monitor | RX pkt #270 on the input: addr=1 len=2 parity=bad gap=18 |
| 183895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 183895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 183910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 184105 | **DUT** | IN  pkt #271 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184135 | **DUT** | IN  pkt #271 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184135 | yapp monitor | RX pkt #271 on the input: addr=1 len=2 parity=bad gap=20 |
| 184135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184185 | **DUT** | IN  pkt #272 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184215 | **DUT** | IN  pkt #272 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184215 | yapp monitor | RX pkt #272 on the input: addr=1 len=2 parity=bad gap=4 |
| 184215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 184240 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 184345 | **DUT** | IN  pkt #273 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184375 | **DUT** | IN  pkt #273 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184375 | yapp monitor | RX pkt #273 on the input: addr=1 len=2 parity=bad gap=12 |
| 184375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 184585 | **DUT** | IN  pkt #274 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184615 | **DUT** | IN  pkt #274 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184615 | yapp monitor | RX pkt #274 on the input: addr=1 len=2 parity=bad gap=20 |
| 184615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 184805 | **DUT** | IN  pkt #275 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 184835 | **DUT** | IN  pkt #275 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 184835 | yapp monitor | RX pkt #275 on the input: addr=1 len=2 parity=bad gap=18 |
| 184835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 184835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 184890 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 185045 | **DUT** | IN  pkt #276 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185075 | **DUT** | IN  pkt #276 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185075 | yapp monitor | RX pkt #276 on the input: addr=1 len=2 parity=bad gap=20 |
| 185075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185115 | **DUT** | IN  pkt #277 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185145 | **DUT** | IN  pkt #277 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185145 | yapp monitor | RX pkt #277 on the input: addr=1 len=2 parity=bad gap=3 |
| 185145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 185190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 185215 | **DUT** | IN  pkt #278 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185245 | **DUT** | IN  pkt #278 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185245 | yapp monitor | RX pkt #278 on the input: addr=1 len=2 parity=bad gap=6 |
| 185245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 185385 | **DUT** | IN  pkt #279 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185415 | **DUT** | IN  pkt #279 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185415 | yapp monitor | RX pkt #279 on the input: addr=1 len=2 parity=bad gap=13 |
| 185415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 185565 | **DUT** | IN  pkt #280 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185595 | **DUT** | IN  pkt #280 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185595 | yapp monitor | RX pkt #280 on the input: addr=1 len=2 parity=bad gap=14 |
| 185595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 185805 | **DUT** | IN  pkt #281 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 185835 | **DUT** | IN  pkt #281 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 185835 | yapp monitor | RX pkt #281 on the input: addr=1 len=2 parity=bad gap=20 |
| 185835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 185835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 185870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 186025 | **DUT** | IN  pkt #282 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186055 | **DUT** | IN  pkt #282 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186055 | yapp monitor | RX pkt #282 on the input: addr=1 len=2 parity=bad gap=18 |
| 186055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186055 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186150 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 186175 | **DUT** | IN  pkt #283 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186205 | **DUT** | IN  pkt #283 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186205 | yapp monitor | RX pkt #283 on the input: addr=1 len=2 parity=bad gap=11 |
| 186205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 186405 | **DUT** | IN  pkt #284 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186435 | **DUT** | IN  pkt #284 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186435 | yapp monitor | RX pkt #284 on the input: addr=1 len=2 parity=bad gap=19 |
| 186435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186435 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186490 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 186625 | **DUT** | IN  pkt #285 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186655 | **DUT** | IN  pkt #285 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186655 | yapp monitor | RX pkt #285 on the input: addr=1 len=2 parity=bad gap=18 |
| 186655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 186735 | **DUT** | IN  pkt #286 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 186765 | **DUT** | IN  pkt #286 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 186765 | yapp monitor | RX pkt #286 on the input: addr=1 len=2 parity=bad gap=7 |
| 186765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 186765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 186830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 186975 | **DUT** | IN  pkt #287 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187005 | **DUT** | IN  pkt #287 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187005 | yapp monitor | RX pkt #287 on the input: addr=1 len=2 parity=bad gap=20 |
| 187005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187025 | **DUT** | IN  pkt #288 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187055 | **DUT** | IN  pkt #288 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187055 | yapp monitor | RX pkt #288 on the input: addr=1 len=2 parity=bad gap=1 |
| 187055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187055 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 187100 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 187205 | **DUT** | IN  pkt #289 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187235 | **DUT** | IN  pkt #289 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187235 | yapp monitor | RX pkt #289 on the input: addr=1 len=2 parity=bad gap=14 |
| 187235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 187405 | **DUT** | IN  pkt #290 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187435 | **DUT** | IN  pkt #290 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187435 | yapp monitor | RX pkt #290 on the input: addr=1 len=2 parity=bad gap=16 |
| 187435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187435 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 187485 | **DUT** | IN  pkt #291 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187515 | **DUT** | IN  pkt #291 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187515 | yapp monitor | RX pkt #291 on the input: addr=1 len=2 parity=bad gap=4 |
| 187515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 187725 | **DUT** | IN  pkt #292 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187755 | **DUT** | IN  pkt #292 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187755 | yapp monitor | RX pkt #292 on the input: addr=1 len=2 parity=bad gap=20 |
| 187755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 187790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 187965 | **DUT** | IN  pkt #293 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 187995 | **DUT** | IN  pkt #293 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 187995 | yapp monitor | RX pkt #293 on the input: addr=1 len=2 parity=bad gap=20 |
| 187995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 187995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188010 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 188205 | **DUT** | IN  pkt #294 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188235 | **DUT** | IN  pkt #294 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188235 | yapp monitor | RX pkt #294 on the input: addr=1 len=2 parity=bad gap=20 |
| 188235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188435 | **DUT** | IN  pkt #295 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188465 | **DUT** | IN  pkt #295 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188465 | yapp monitor | RX pkt #295 on the input: addr=1 len=2 parity=bad gap=19 |
| 188465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188465 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188515 | **DUT** | IN  pkt #296 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188545 | **DUT** | IN  pkt #296 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188545 | yapp monitor | RX pkt #296 on the input: addr=1 len=2 parity=bad gap=4 |
| 188545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188570 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 188580 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188635 | **DUT** | IN  pkt #297 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188665 | **DUT** | IN  pkt #297 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188665 | yapp monitor | RX pkt #297 on the input: addr=1 len=2 parity=bad gap=8 |
| 188665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188665 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 188745 | **DUT** | IN  pkt #298 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188775 | **DUT** | IN  pkt #298 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188775 | yapp monitor | RX pkt #298 on the input: addr=1 len=2 parity=bad gap=7 |
| 188775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188775 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188845 | **DUT** | IN  pkt #299 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 188875 | **DUT** | IN  pkt #299 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188875 | yapp monitor | RX pkt #299 on the input: addr=1 len=2 parity=bad gap=6 |
| 188875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188875 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188910 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 188925 | **DUT** | IN  pkt #300 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 188955 | **DUT** | IN  pkt #300 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 188955 | yapp monitor | RX pkt #300 on the input: addr=1 len=2 parity=bad gap=4 |
| 188955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 188955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 188970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 188995 | **DUT** | IN  pkt #301 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189025 | **DUT** | IN  pkt #301 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189025 | yapp monitor | RX pkt #301 on the input: addr=1 len=2 parity=bad gap=3 |
| 189025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 189225 | **DUT** | IN  pkt #302 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189255 | **DUT** | IN  pkt #302 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189255 | yapp monitor | RX pkt #302 on the input: addr=1 len=2 parity=bad gap=19 |
| 189255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 189375 | **DUT** | IN  pkt #303 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189405 | **DUT** | IN  pkt #303 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189405 | yapp monitor | RX pkt #303 on the input: addr=1 len=2 parity=bad gap=11 |
| 189405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189455 | **DUT** | IN  pkt #304 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189485 | **DUT** | IN  pkt #304 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189485 | yapp monitor | RX pkt #304 on the input: addr=1 len=2 parity=bad gap=4 |
| 189485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 189550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 189695 | **DUT** | IN  pkt #305 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189725 | **DUT** | IN  pkt #305 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189725 | yapp monitor | RX pkt #305 on the input: addr=1 len=2 parity=bad gap=20 |
| 189725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 189810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 189925 | **DUT** | IN  pkt #306 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 189955 | **DUT** | IN  pkt #306 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 189955 | yapp monitor | RX pkt #306 on the input: addr=1 len=2 parity=bad gap=19 |
| 189955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 189955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 190135 | **DUT** | IN  pkt #307 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190165 | **DUT** | IN  pkt #307 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190165 | yapp monitor | RX pkt #307 on the input: addr=1 len=2 parity=bad gap=17 |
| 190165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190165 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 190335 | **DUT** | IN  pkt #308 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190365 | **DUT** | IN  pkt #308 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190365 | yapp monitor | RX pkt #308 on the input: addr=1 len=2 parity=bad gap=16 |
| 190365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 190475 | **DUT** | IN  pkt #309 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190505 | **DUT** | IN  pkt #309 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190505 | yapp monitor | RX pkt #309 on the input: addr=1 len=2 parity=bad gap=10 |
| 190505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 190645 | **DUT** | IN  pkt #310 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190675 | **DUT** | IN  pkt #310 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190675 | yapp monitor | RX pkt #310 on the input: addr=1 len=2 parity=bad gap=13 |
| 190675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 190855 | **DUT** | IN  pkt #311 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190885 | **DUT** | IN  pkt #311 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190885 | yapp monitor | RX pkt #311 on the input: addr=1 len=2 parity=bad gap=17 |
| 190885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 190910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 190935 | **DUT** | IN  pkt #312 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 190965 | **DUT** | IN  pkt #312 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 190965 | yapp monitor | RX pkt #312 on the input: addr=1 len=2 parity=bad gap=4 |
| 190965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 190965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 191115 | **DUT** | IN  pkt #313 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191145 | **DUT** | IN  pkt #313 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191145 | yapp monitor | RX pkt #313 on the input: addr=1 len=2 parity=bad gap=14 |
| 191145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191205 | **DUT** | IN  pkt #314 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 191235 | **DUT** | IN  pkt #314 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191235 | yapp monitor | RX pkt #314 on the input: addr=1 len=2 parity=bad gap=5 |
| 191235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 191445 | **DUT** | IN  pkt #315 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191475 | **DUT** | IN  pkt #315 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191475 | yapp monitor | RX pkt #315 on the input: addr=1 len=2 parity=bad gap=20 |
| 191475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191475 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 191685 | **DUT** | IN  pkt #316 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191715 | **DUT** | IN  pkt #316 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191715 | yapp monitor | RX pkt #316 on the input: addr=1 len=2 parity=bad gap=20 |
| 191715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 191875 | **DUT** | IN  pkt #317 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 191905 | **DUT** | IN  pkt #317 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 191905 | yapp monitor | RX pkt #317 on the input: addr=1 len=2 parity=bad gap=15 |
| 191905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 191905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 191930 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 192085 | **DUT** | IN  pkt #318 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192115 | **DUT** | IN  pkt #318 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192115 | yapp monitor | RX pkt #318 on the input: addr=1 len=2 parity=bad gap=17 |
| 192115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192165 | **DUT** | IN  pkt #319 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 192195 | **DUT** | IN  pkt #319 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192195 | yapp monitor | RX pkt #319 on the input: addr=1 len=2 parity=bad gap=4 |
| 192195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 192375 | **DUT** | IN  pkt #320 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192405 | **DUT** | IN  pkt #320 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192405 | yapp monitor | RX pkt #320 on the input: addr=1 len=2 parity=bad gap=17 |
| 192405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192405 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 192615 | **DUT** | IN  pkt #321 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192645 | **DUT** | IN  pkt #321 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192645 | yapp monitor | RX pkt #321 on the input: addr=1 len=2 parity=bad gap=20 |
| 192645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 192725 | **DUT** | IN  pkt #322 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192755 | **DUT** | IN  pkt #322 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192755 | yapp monitor | RX pkt #322 on the input: addr=1 len=2 parity=bad gap=7 |
| 192755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192795 | **DUT** | IN  pkt #323 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192825 | **DUT** | IN  pkt #323 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192825 | yapp monitor | RX pkt #323 on the input: addr=1 len=2 parity=bad gap=3 |
| 192825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 192830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 192870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 192965 | **DUT** | IN  pkt #324 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 192995 | **DUT** | IN  pkt #324 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 192995 | yapp monitor | RX pkt #324 on the input: addr=1 len=2 parity=bad gap=13 |
| 192995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 192995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 193155 | **DUT** | IN  pkt #325 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193185 | **DUT** | IN  pkt #325 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193185 | yapp monitor | RX pkt #325 on the input: addr=1 len=2 parity=bad gap=15 |
| 193185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 193365 | **DUT** | IN  pkt #326 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193395 | **DUT** | IN  pkt #326 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193395 | yapp monitor | RX pkt #326 on the input: addr=1 len=2 parity=bad gap=17 |
| 193395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 193605 | **DUT** | IN  pkt #327 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193635 | **DUT** | IN  pkt #327 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193635 | yapp monitor | RX pkt #327 on the input: addr=1 len=2 parity=bad gap=20 |
| 193635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 193845 | **DUT** | IN  pkt #328 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 193875 | **DUT** | IN  pkt #328 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 193875 | yapp monitor | RX pkt #328 on the input: addr=1 len=2 parity=bad gap=20 |
| 193875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 193875 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 193950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 194085 | **DUT** | IN  pkt #329 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194115 | **DUT** | IN  pkt #329 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194115 | yapp monitor | RX pkt #329 on the input: addr=1 len=2 parity=bad gap=20 |
| 194115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 194305 | **DUT** | IN  pkt #330 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194335 | **DUT** | IN  pkt #330 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194335 | yapp monitor | RX pkt #330 on the input: addr=1 len=2 parity=bad gap=18 |
| 194335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 194525 | **DUT** | IN  pkt #331 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194555 | **DUT** | IN  pkt #331 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194555 | yapp monitor | RX pkt #331 on the input: addr=1 len=2 parity=bad gap=18 |
| 194555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 194665 | **DUT** | IN  pkt #332 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194695 | **DUT** | IN  pkt #332 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194695 | yapp monitor | RX pkt #332 on the input: addr=1 len=2 parity=bad gap=10 |
| 194695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 194875 | **DUT** | IN  pkt #333 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 194905 | **DUT** | IN  pkt #333 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 194905 | yapp monitor | RX pkt #333 on the input: addr=1 len=2 parity=bad gap=17 |
| 194905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 194905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 194950 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 195045 | **DUT** | IN  pkt #334 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195075 | **DUT** | IN  pkt #334 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195075 | yapp monitor | RX pkt #334 on the input: addr=1 len=2 parity=bad gap=13 |
| 195075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195075 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195130 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 195285 | **DUT** | IN  pkt #335 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195315 | **DUT** | IN  pkt #335 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195315 | yapp monitor | RX pkt #335 on the input: addr=1 len=2 parity=bad gap=20 |
| 195315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 195485 | **DUT** | IN  pkt #336 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195515 | **DUT** | IN  pkt #336 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195515 | yapp monitor | RX pkt #336 on the input: addr=1 len=2 parity=bad gap=16 |
| 195515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 195685 | **DUT** | IN  pkt #337 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195715 | **DUT** | IN  pkt #337 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195715 | yapp monitor | RX pkt #337 on the input: addr=1 len=2 parity=bad gap=16 |
| 195715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 195895 | **DUT** | IN  pkt #338 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195925 | **DUT** | IN  pkt #338 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195925 | yapp monitor | RX pkt #338 on the input: addr=1 len=2 parity=bad gap=17 |
| 195925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195925 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 195955 | **DUT** | IN  pkt #339 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 195970 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 195985 | **DUT** | IN  pkt #339 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 195985 | yapp monitor | RX pkt #339 on the input: addr=1 len=2 parity=bad gap=2 |
| 195985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 195985 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196065 | **DUT** | IN  pkt #340 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 196095 | **DUT** | IN  pkt #340 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196095 | yapp monitor | RX pkt #340 on the input: addr=1 len=2 parity=bad gap=7 |
| 196095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196095 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 196305 | **DUT** | IN  pkt #341 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196335 | **DUT** | IN  pkt #341 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196335 | yapp monitor | RX pkt #341 on the input: addr=1 len=2 parity=bad gap=20 |
| 196335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 196545 | **DUT** | IN  pkt #342 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196575 | **DUT** | IN  pkt #342 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196575 | yapp monitor | RX pkt #342 on the input: addr=1 len=2 parity=bad gap=20 |
| 196575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196615 | **DUT** | IN  pkt #343 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 196645 | **DUT** | IN  pkt #343 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196645 | yapp monitor | RX pkt #343 on the input: addr=1 len=2 parity=bad gap=3 |
| 196645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 196855 | **DUT** | IN  pkt #344 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196885 | **DUT** | IN  pkt #344 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196885 | yapp monitor | RX pkt #344 on the input: addr=1 len=2 parity=bad gap=20 |
| 196885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196925 | **DUT** | IN  pkt #345 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 196930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 196955 | **DUT** | IN  pkt #345 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 196955 | yapp monitor | RX pkt #345 on the input: addr=1 len=2 parity=bad gap=3 |
| 196955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 196955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 196970 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 197095 | **DUT** | IN  pkt #346 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197125 | **DUT** | IN  pkt #346 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197125 | yapp monitor | RX pkt #346 on the input: addr=1 len=2 parity=bad gap=13 |
| 197125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 197205 | **DUT** | IN  pkt #347 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197235 | **DUT** | IN  pkt #347 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197235 | yapp monitor | RX pkt #347 on the input: addr=1 len=2 parity=bad gap=7 |
| 197235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197235 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197255 | **DUT** | IN  pkt #348 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197285 | **DUT** | IN  pkt #348 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197285 | yapp monitor | RX pkt #348 on the input: addr=1 len=2 parity=bad gap=1 |
| 197285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 197320 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 197395 | **DUT** | IN  pkt #349 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197425 | **DUT** | IN  pkt #349 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197425 | yapp monitor | RX pkt #349 on the input: addr=1 len=2 parity=bad gap=10 |
| 197425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 197535 | **DUT** | IN  pkt #350 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197565 | **DUT** | IN  pkt #350 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197565 | yapp monitor | RX pkt #350 on the input: addr=1 len=2 parity=bad gap=10 |
| 197565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197565 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197645 | **DUT** | IN  pkt #351 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197650 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 197675 | **DUT** | IN  pkt #351 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197675 | yapp monitor | RX pkt #351 on the input: addr=1 len=2 parity=bad gap=7 |
| 197675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 197735 | **DUT** | IN  pkt #352 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 197765 | **DUT** | IN  pkt #352 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 197765 | yapp monitor | RX pkt #352 on the input: addr=1 len=2 parity=bad gap=5 |
| 197765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 197765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 197790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 197975 | **DUT** | IN  pkt #353 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198005 | **DUT** | IN  pkt #353 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198005 | yapp monitor | RX pkt #353 on the input: addr=1 len=2 parity=bad gap=20 |
| 198005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 198215 | **DUT** | IN  pkt #354 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198245 | **DUT** | IN  pkt #354 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198245 | yapp monitor | RX pkt #354 on the input: addr=1 len=2 parity=bad gap=20 |
| 198245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 198415 | **DUT** | IN  pkt #355 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198445 | **DUT** | IN  pkt #355 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198445 | yapp monitor | RX pkt #355 on the input: addr=1 len=2 parity=bad gap=16 |
| 198445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 198645 | **DUT** | IN  pkt #356 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 198675 | **DUT** | IN  pkt #356 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 198675 | yapp monitor | RX pkt #356 on the input: addr=1 len=2 parity=bad gap=19 |
| 198675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 198675 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 198715 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 198745 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 198750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 198775 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 198805 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 198835 | hbus monitor | Collected READ  addr=0x100a data=0x64 |
| 198865 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 199055 | **DUT** | IN  pkt #357 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199085 | **DUT** | IN  pkt #357 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199085 | yapp monitor | RX pkt #357 on the input: addr=1 len=2 parity=bad gap=37 |
| 199085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199085 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199150 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199295 | **DUT** | IN  pkt #358 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199325 | **DUT** | IN  pkt #358 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199325 | yapp monitor | RX pkt #358 on the input: addr=1 len=2 parity=bad gap=20 |
| 199325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 199495 | **DUT** | IN  pkt #359 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199525 | **DUT** | IN  pkt #359 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199525 | yapp monitor | RX pkt #359 on the input: addr=1 len=2 parity=bad gap=16 |
| 199525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199525 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199545 | **DUT** | IN  pkt #360 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 199575 | **DUT** | IN  pkt #360 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199575 | yapp monitor | RX pkt #360 on the input: addr=1 len=2 parity=bad gap=1 |
| 199575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 199695 | **DUT** | IN  pkt #361 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199725 | **DUT** | IN  pkt #361 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199725 | yapp monitor | RX pkt #361 on the input: addr=1 len=2 parity=bad gap=11 |
| 199725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199725 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199755 | **DUT** | IN  pkt #362 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 199785 | **DUT** | IN  pkt #362 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 199785 | yapp monitor | RX pkt #362 on the input: addr=1 len=2 parity=bad gap=2 |
| 199785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 199785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 199790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 199850 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 199995 | **DUT** | IN  pkt #363 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200025 | **DUT** | IN  pkt #363 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200025 | yapp monitor | RX pkt #363 on the input: addr=1 len=2 parity=bad gap=20 |
| 200025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 200235 | **DUT** | IN  pkt #364 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200265 | **DUT** | IN  pkt #364 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200265 | yapp monitor | RX pkt #364 on the input: addr=1 len=2 parity=bad gap=20 |
| 200265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 200365 | **DUT** | IN  pkt #365 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200395 | **DUT** | IN  pkt #365 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200395 | yapp monitor | RX pkt #365 on the input: addr=1 len=2 parity=bad gap=9 |
| 200395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200395 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 200485 | **DUT** | IN  pkt #366 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200515 | **DUT** | IN  pkt #366 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200515 | yapp monitor | RX pkt #366 on the input: addr=1 len=2 parity=bad gap=8 |
| 200515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200515 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 200725 | **DUT** | IN  pkt #367 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200755 | **DUT** | IN  pkt #367 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200755 | yapp monitor | RX pkt #367 on the input: addr=1 len=2 parity=bad gap=20 |
| 200755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 200830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 200965 | **DUT** | IN  pkt #368 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 200995 | **DUT** | IN  pkt #368 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 200995 | yapp monitor | RX pkt #368 on the input: addr=1 len=2 parity=bad gap=20 |
| 200995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 200995 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 201085 | **DUT** | IN  pkt #369 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201115 | **DUT** | IN  pkt #369 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201115 | yapp monitor | RX pkt #369 on the input: addr=1 len=2 parity=bad gap=8 |
| 201115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 201225 | **DUT** | IN  pkt #370 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201255 | **DUT** | IN  pkt #370 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201255 | yapp monitor | RX pkt #370 on the input: addr=1 len=2 parity=bad gap=10 |
| 201255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201255 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 201415 | **DUT** | IN  pkt #371 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201445 | **DUT** | IN  pkt #371 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201445 | yapp monitor | RX pkt #371 on the input: addr=1 len=2 parity=bad gap=15 |
| 201445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 201615 | **DUT** | IN  pkt #372 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201645 | **DUT** | IN  pkt #372 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201645 | yapp monitor | RX pkt #372 on the input: addr=1 len=2 parity=bad gap=16 |
| 201645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 201775 | **DUT** | IN  pkt #373 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 201805 | **DUT** | IN  pkt #373 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 201805 | yapp monitor | RX pkt #373 on the input: addr=1 len=2 parity=bad gap=12 |
| 201805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 201805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 201870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 202015 | **DUT** | IN  pkt #374 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202045 | **DUT** | IN  pkt #374 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202045 | yapp monitor | RX pkt #374 on the input: addr=1 len=2 parity=bad gap=20 |
| 202045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202075 | **DUT** | IN  pkt #375 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202105 | **DUT** | IN  pkt #375 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202105 | yapp monitor | RX pkt #375 on the input: addr=1 len=2 parity=bad gap=2 |
| 202105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 202150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 202175 | **DUT** | IN  pkt #376 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202205 | **DUT** | IN  pkt #376 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202205 | yapp monitor | RX pkt #376 on the input: addr=1 len=2 parity=bad gap=6 |
| 202205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 202415 | **DUT** | IN  pkt #377 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202445 | **DUT** | IN  pkt #377 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202445 | yapp monitor | RX pkt #377 on the input: addr=1 len=2 parity=bad gap=20 |
| 202445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 202515 | **DUT** | IN  pkt #378 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202545 | **DUT** | IN  pkt #378 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202545 | yapp monitor | RX pkt #378 on the input: addr=1 len=2 parity=bad gap=6 |
| 202545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 202755 | **DUT** | IN  pkt #379 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202785 | **DUT** | IN  pkt #379 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202785 | yapp monitor | RX pkt #379 on the input: addr=1 len=2 parity=bad gap=20 |
| 202785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202785 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 202925 | **DUT** | IN  pkt #380 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 202955 | **DUT** | IN  pkt #380 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 202955 | yapp monitor | RX pkt #380 on the input: addr=1 len=2 parity=bad gap=13 |
| 202955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 202955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 202990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 203165 | **DUT** | IN  pkt #381 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203195 | **DUT** | IN  pkt #381 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203195 | yapp monitor | RX pkt #381 on the input: addr=1 len=2 parity=bad gap=20 |
| 203195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 203315 | **DUT** | IN  pkt #382 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203345 | **DUT** | IN  pkt #382 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203345 | yapp monitor | RX pkt #382 on the input: addr=1 len=2 parity=bad gap=11 |
| 203345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 203545 | **DUT** | IN  pkt #383 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203575 | **DUT** | IN  pkt #383 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203575 | yapp monitor | RX pkt #383 on the input: addr=1 len=2 parity=bad gap=19 |
| 203575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 203735 | **DUT** | IN  pkt #384 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 203765 | **DUT** | IN  pkt #384 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 203765 | yapp monitor | RX pkt #384 on the input: addr=1 len=2 parity=bad gap=15 |
| 203765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 203765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 203810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 203975 | **DUT** | IN  pkt #385 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204005 | **DUT** | IN  pkt #385 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204005 | yapp monitor | RX pkt #385 on the input: addr=1 len=2 parity=bad gap=20 |
| 204005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 204215 | **DUT** | IN  pkt #386 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204245 | **DUT** | IN  pkt #386 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204245 | yapp monitor | RX pkt #386 on the input: addr=1 len=2 parity=bad gap=20 |
| 204245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 204395 | **DUT** | IN  pkt #387 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204425 | **DUT** | IN  pkt #387 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204425 | yapp monitor | RX pkt #387 on the input: addr=1 len=2 parity=bad gap=14 |
| 204425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 204605 | **DUT** | IN  pkt #388 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204635 | **DUT** | IN  pkt #388 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204635 | yapp monitor | RX pkt #388 on the input: addr=1 len=2 parity=bad gap=17 |
| 204635 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204635 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 204845 | **DUT** | IN  pkt #389 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 204875 | **DUT** | IN  pkt #389 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 204875 | yapp monitor | RX pkt #389 on the input: addr=1 len=2 parity=bad gap=20 |
| 204875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 204875 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 204910 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 205085 | **DUT** | IN  pkt #390 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205115 | **DUT** | IN  pkt #390 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205115 | yapp monitor | RX pkt #390 on the input: addr=1 len=2 parity=bad gap=20 |
| 205115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205130 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 205305 | **DUT** | IN  pkt #391 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205335 | **DUT** | IN  pkt #391 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205335 | yapp monitor | RX pkt #391 on the input: addr=1 len=2 parity=bad gap=18 |
| 205335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 205465 | **DUT** | IN  pkt #392 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205495 | **DUT** | IN  pkt #392 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205495 | yapp monitor | RX pkt #392 on the input: addr=1 len=2 parity=bad gap=12 |
| 205495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205495 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 205675 | **DUT** | IN  pkt #393 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205705 | **DUT** | IN  pkt #393 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205705 | yapp monitor | RX pkt #393 on the input: addr=1 len=2 parity=bad gap=17 |
| 205705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205770 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 205915 | **DUT** | IN  pkt #394 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 205945 | **DUT** | IN  pkt #394 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 205945 | yapp monitor | RX pkt #394 on the input: addr=1 len=2 parity=bad gap=20 |
| 205945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 205945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 205990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 206125 | **DUT** | IN  pkt #395 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206155 | **DUT** | IN  pkt #395 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206155 | yapp monitor | RX pkt #395 on the input: addr=1 len=2 parity=bad gap=17 |
| 206155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 206355 | **DUT** | IN  pkt #396 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206385 | **DUT** | IN  pkt #396 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206385 | yapp monitor | RX pkt #396 on the input: addr=1 len=2 parity=bad gap=19 |
| 206385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206475 | **DUT** | IN  pkt #397 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 206505 | **DUT** | IN  pkt #397 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206505 | yapp monitor | RX pkt #397 on the input: addr=1 len=2 parity=bad gap=8 |
| 206505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206505 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 206685 | **DUT** | IN  pkt #398 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206715 | **DUT** | IN  pkt #398 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206715 | yapp monitor | RX pkt #398 on the input: addr=1 len=2 parity=bad gap=17 |
| 206715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 206925 | **DUT** | IN  pkt #399 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206955 | **DUT** | IN  pkt #399 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 206955 | yapp monitor | RX pkt #399 on the input: addr=1 len=2 parity=bad gap=20 |
| 206955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 206955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 206975 | **DUT** | IN  pkt #400 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 206990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 207005 | **DUT** | IN  pkt #400 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207005 | yapp monitor | RX pkt #400 on the input: addr=1 len=2 parity=bad gap=1 |
| 207005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 207215 | **DUT** | IN  pkt #401 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207245 | **DUT** | IN  pkt #401 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207245 | yapp monitor | RX pkt #401 on the input: addr=1 len=2 parity=bad gap=20 |
| 207245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 207455 | **DUT** | IN  pkt #402 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207485 | **DUT** | IN  pkt #402 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207485 | yapp monitor | RX pkt #402 on the input: addr=1 len=2 parity=bad gap=20 |
| 207485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 207675 | **DUT** | IN  pkt #403 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207705 | **DUT** | IN  pkt #403 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207705 | yapp monitor | RX pkt #403 on the input: addr=1 len=2 parity=bad gap=18 |
| 207705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207705 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 207750 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 207915 | **DUT** | IN  pkt #404 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 207945 | **DUT** | IN  pkt #404 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 207945 | yapp monitor | RX pkt #404 on the input: addr=1 len=2 parity=bad gap=20 |
| 207945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 207945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 208035 | **DUT** | IN  pkt #405 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208065 | **DUT** | IN  pkt #405 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208065 | yapp monitor | RX pkt #405 on the input: addr=1 len=2 parity=bad gap=8 |
| 208065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 208265 | **DUT** | IN  pkt #406 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208295 | **DUT** | IN  pkt #406 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208295 | yapp monitor | RX pkt #406 on the input: addr=1 len=2 parity=bad gap=19 |
| 208295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208355 | **DUT** | IN  pkt #407 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208385 | **DUT** | IN  pkt #407 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208385 | yapp monitor | RX pkt #407 on the input: addr=1 len=2 parity=bad gap=5 |
| 208385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 208410 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 208455 | **DUT** | IN  pkt #408 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208485 | **DUT** | IN  pkt #408 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208485 | yapp monitor | RX pkt #408 on the input: addr=1 len=2 parity=bad gap=6 |
| 208485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 208525 | **DUT** | IN  pkt #409 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208555 | **DUT** | IN  pkt #409 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208555 | yapp monitor | RX pkt #409 on the input: addr=1 len=2 parity=bad gap=3 |
| 208555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 208765 | **DUT** | IN  pkt #410 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208795 | **DUT** | IN  pkt #410 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208795 | yapp monitor | RX pkt #410 on the input: addr=1 len=2 parity=bad gap=20 |
| 208795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 208865 | **DUT** | IN  pkt #411 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 208895 | **DUT** | IN  pkt #411 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 208895 | yapp monitor | RX pkt #411 on the input: addr=1 len=2 parity=bad gap=6 |
| 208895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 208895 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 208950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 209075 | **DUT** | IN  pkt #412 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209105 | **DUT** | IN  pkt #412 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209105 | yapp monitor | RX pkt #412 on the input: addr=1 len=2 parity=bad gap=17 |
| 209105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 209285 | **DUT** | IN  pkt #413 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209315 | **DUT** | IN  pkt #413 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209315 | yapp monitor | RX pkt #413 on the input: addr=1 len=2 parity=bad gap=17 |
| 209315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209315 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 209515 | **DUT** | IN  pkt #414 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209545 | **DUT** | IN  pkt #414 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209545 | yapp monitor | RX pkt #414 on the input: addr=1 len=2 parity=bad gap=19 |
| 209545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209545 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 209725 | **DUT** | IN  pkt #415 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209755 | **DUT** | IN  pkt #415 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209755 | yapp monitor | RX pkt #415 on the input: addr=1 len=2 parity=bad gap=17 |
| 209755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 209770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 209925 | **DUT** | IN  pkt #416 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 209955 | **DUT** | IN  pkt #416 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 209955 | yapp monitor | RX pkt #416 on the input: addr=1 len=2 parity=bad gap=16 |
| 209955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 209955 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 210165 | **DUT** | IN  pkt #417 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210195 | **DUT** | IN  pkt #417 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210195 | yapp monitor | RX pkt #417 on the input: addr=1 len=2 parity=bad gap=20 |
| 210195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210270 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 210295 | **DUT** | IN  pkt #418 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210325 | **DUT** | IN  pkt #418 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210325 | yapp monitor | RX pkt #418 on the input: addr=1 len=2 parity=bad gap=9 |
| 210325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 210535 | **DUT** | IN  pkt #419 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210565 | **DUT** | IN  pkt #419 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210565 | yapp monitor | RX pkt #419 on the input: addr=1 len=2 parity=bad gap=20 |
| 210565 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210565 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210590 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 210725 | **DUT** | IN  pkt #420 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210755 | **DUT** | IN  pkt #420 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210755 | yapp monitor | RX pkt #420 on the input: addr=1 len=2 parity=bad gap=15 |
| 210755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 210810 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 210945 | **DUT** | IN  pkt #421 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 210975 | **DUT** | IN  pkt #421 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 210975 | yapp monitor | RX pkt #421 on the input: addr=1 len=2 parity=bad gap=18 |
| 210975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 210975 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211030 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 211185 | **DUT** | IN  pkt #422 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211215 | **DUT** | IN  pkt #422 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211215 | yapp monitor | RX pkt #422 on the input: addr=1 len=2 parity=bad gap=20 |
| 211215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211215 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 211325 | **DUT** | IN  pkt #423 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211355 | **DUT** | IN  pkt #423 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211355 | yapp monitor | RX pkt #423 on the input: addr=1 len=2 parity=bad gap=10 |
| 211355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211355 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 211565 | **DUT** | IN  pkt #424 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211595 | **DUT** | IN  pkt #424 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211595 | yapp monitor | RX pkt #424 on the input: addr=1 len=2 parity=bad gap=20 |
| 211595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 211665 | **DUT** | IN  pkt #425 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211695 | **DUT** | IN  pkt #425 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211695 | yapp monitor | RX pkt #425 on the input: addr=1 len=2 parity=bad gap=6 |
| 211695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 211885 | **DUT** | IN  pkt #426 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 211915 | **DUT** | IN  pkt #426 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 211915 | yapp monitor | RX pkt #426 on the input: addr=1 len=2 parity=bad gap=18 |
| 211915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 211915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 211950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 212105 | **DUT** | IN  pkt #427 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212135 | **DUT** | IN  pkt #427 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212135 | yapp monitor | RX pkt #427 on the input: addr=1 len=2 parity=bad gap=18 |
| 212135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212135 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212155 | **DUT** | IN  pkt #428 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212185 | **DUT** | IN  pkt #428 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212185 | yapp monitor | RX pkt #428 on the input: addr=1 len=2 parity=bad gap=1 |
| 212185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 212240 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 212265 | **DUT** | IN  pkt #429 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212295 | **DUT** | IN  pkt #429 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212295 | yapp monitor | RX pkt #429 on the input: addr=1 len=2 parity=bad gap=7 |
| 212295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212295 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 212505 | **DUT** | IN  pkt #430 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212535 | **DUT** | IN  pkt #430 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212535 | yapp monitor | RX pkt #430 on the input: addr=1 len=2 parity=bad gap=20 |
| 212535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212535 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 212555 | **DUT** | IN  pkt #431 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212585 | **DUT** | IN  pkt #431 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212585 | yapp monitor | RX pkt #431 on the input: addr=1 len=2 parity=bad gap=1 |
| 212585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212650 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 212795 | **DUT** | IN  pkt #432 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 212825 | **DUT** | IN  pkt #432 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 212825 | yapp monitor | RX pkt #432 on the input: addr=1 len=2 parity=bad gap=20 |
| 212825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 212825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 212870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 213035 | **DUT** | IN  pkt #433 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213065 | **DUT** | IN  pkt #433 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213065 | yapp monitor | RX pkt #433 on the input: addr=1 len=2 parity=bad gap=20 |
| 213065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 213195 | **DUT** | IN  pkt #434 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213225 | **DUT** | IN  pkt #434 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213225 | yapp monitor | RX pkt #434 on the input: addr=1 len=2 parity=bad gap=12 |
| 213225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213290 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 213425 | **DUT** | IN  pkt #435 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213455 | **DUT** | IN  pkt #435 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213455 | yapp monitor | RX pkt #435 on the input: addr=1 len=2 parity=bad gap=19 |
| 213455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213455 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213490 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 213625 | **DUT** | IN  pkt #436 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213655 | **DUT** | IN  pkt #436 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213655 | yapp monitor | RX pkt #436 on the input: addr=1 len=2 parity=bad gap=16 |
| 213655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 213765 | **DUT** | IN  pkt #437 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213795 | **DUT** | IN  pkt #437 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213795 | yapp monitor | RX pkt #437 on the input: addr=1 len=2 parity=bad gap=10 |
| 213795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213850 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 213905 | **DUT** | IN  pkt #438 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 213935 | **DUT** | IN  pkt #438 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 213935 | yapp monitor | RX pkt #438 on the input: addr=1 len=2 parity=bad gap=10 |
| 213935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 213935 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 213970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214065 | **DUT** | IN  pkt #439 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214095 | **DUT** | IN  pkt #439 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214095 | yapp monitor | RX pkt #439 on the input: addr=1 len=2 parity=bad gap=12 |
| 214095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214095 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214305 | **DUT** | IN  pkt #440 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214335 | **DUT** | IN  pkt #440 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214335 | yapp monitor | RX pkt #440 on the input: addr=1 len=2 parity=bad gap=20 |
| 214335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214335 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 214545 | **DUT** | IN  pkt #441 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214575 | **DUT** | IN  pkt #441 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214575 | yapp monitor | RX pkt #441 on the input: addr=1 len=2 parity=bad gap=20 |
| 214575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214575 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 214735 | **DUT** | IN  pkt #442 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214765 | **DUT** | IN  pkt #442 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214765 | yapp monitor | RX pkt #442 on the input: addr=1 len=2 parity=bad gap=15 |
| 214765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214795 | **DUT** | IN  pkt #443 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 214825 | **DUT** | IN  pkt #443 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 214825 | yapp monitor | RX pkt #443 on the input: addr=1 len=2 parity=bad gap=2 |
| 214825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 214825 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 214830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 214890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 215035 | **DUT** | IN  pkt #444 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215065 | **DUT** | IN  pkt #444 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215065 | yapp monitor | RX pkt #444 on the input: addr=1 len=2 parity=bad gap=20 |
| 215065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 215155 | **DUT** | IN  pkt #445 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215185 | **DUT** | IN  pkt #445 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215185 | yapp monitor | RX pkt #445 on the input: addr=1 len=2 parity=bad gap=8 |
| 215185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215185 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215290 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 215395 | **DUT** | IN  pkt #446 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215425 | **DUT** | IN  pkt #446 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215425 | yapp monitor | RX pkt #446 on the input: addr=1 len=2 parity=bad gap=20 |
| 215425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215450 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 215635 | **DUT** | IN  pkt #447 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215665 | **DUT** | IN  pkt #447 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215665 | yapp monitor | RX pkt #447 on the input: addr=1 len=2 parity=bad gap=20 |
| 215665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215665 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215765 | **DUT** | IN  pkt #448 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215770 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 215795 | **DUT** | IN  pkt #448 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215795 | yapp monitor | RX pkt #448 on the input: addr=1 len=2 parity=bad gap=9 |
| 215795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 215870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 215915 | **DUT** | IN  pkt #449 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 215945 | **DUT** | IN  pkt #449 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 215945 | yapp monitor | RX pkt #449 on the input: addr=1 len=2 parity=bad gap=11 |
| 215945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 215945 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 216035 | **DUT** | IN  pkt #450 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216065 | **DUT** | IN  pkt #450 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216065 | yapp monitor | RX pkt #450 on the input: addr=1 len=2 parity=bad gap=8 |
| 216065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216065 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216090 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 216235 | **DUT** | IN  pkt #451 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216265 | **DUT** | IN  pkt #451 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216265 | yapp monitor | RX pkt #451 on the input: addr=1 len=2 parity=bad gap=16 |
| 216265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 216335 | **DUT** | IN  pkt #452 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216365 | **DUT** | IN  pkt #452 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216365 | yapp monitor | RX pkt #452 on the input: addr=1 len=2 parity=bad gap=6 |
| 216365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216365 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216430 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 216575 | **DUT** | IN  pkt #453 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216605 | **DUT** | IN  pkt #453 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216605 | yapp monitor | RX pkt #453 on the input: addr=1 len=2 parity=bad gap=20 |
| 216605 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216605 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216665 | **DUT** | IN  pkt #454 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 216695 | **DUT** | IN  pkt #454 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216695 | yapp monitor | RX pkt #454 on the input: addr=1 len=2 parity=bad gap=5 |
| 216695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216695 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216710 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 216805 | **DUT** | IN  pkt #455 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 216835 | **DUT** | IN  pkt #455 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 216835 | yapp monitor | RX pkt #455 on the input: addr=1 len=2 parity=bad gap=10 |
| 216835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 216835 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 216890 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 216995 | **DUT** | IN  pkt #456 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217025 | **DUT** | IN  pkt #456 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217025 | yapp monitor | RX pkt #456 on the input: addr=1 len=2 parity=bad gap=15 |
| 217025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 217235 | **DUT** | IN  pkt #457 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217265 | **DUT** | IN  pkt #457 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217265 | yapp monitor | RX pkt #457 on the input: addr=1 len=2 parity=bad gap=20 |
| 217265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217265 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 217385 | **DUT** | IN  pkt #458 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217415 | **DUT** | IN  pkt #458 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217415 | yapp monitor | RX pkt #458 on the input: addr=1 len=2 parity=bad gap=11 |
| 217415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 217625 | **DUT** | IN  pkt #459 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217655 | **DUT** | IN  pkt #459 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217655 | yapp monitor | RX pkt #459 on the input: addr=1 len=2 parity=bad gap=20 |
| 217655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 217835 | **DUT** | IN  pkt #460 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 217865 | **DUT** | IN  pkt #460 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 217865 | yapp monitor | RX pkt #460 on the input: addr=1 len=2 parity=bad gap=17 |
| 217865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 217865 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 217930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 217975 | **DUT** | IN  pkt #461 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218005 | **DUT** | IN  pkt #461 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218005 | yapp monitor | RX pkt #461 on the input: addr=1 len=2 parity=bad gap=10 |
| 218005 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218005 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218050 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 218195 | **DUT** | IN  pkt #462 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218225 | **DUT** | IN  pkt #462 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218225 | yapp monitor | RX pkt #462 on the input: addr=1 len=2 parity=bad gap=18 |
| 218225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218225 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 218345 | **DUT** | IN  pkt #463 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218375 | **DUT** | IN  pkt #463 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218375 | yapp monitor | RX pkt #463 on the input: addr=1 len=2 parity=bad gap=11 |
| 218375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 218525 | **DUT** | IN  pkt #464 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218555 | **DUT** | IN  pkt #464 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218555 | yapp monitor | RX pkt #464 on the input: addr=1 len=2 parity=bad gap=14 |
| 218555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218555 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 218765 | **DUT** | IN  pkt #465 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 218795 | **DUT** | IN  pkt #465 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 218795 | yapp monitor | RX pkt #465 on the input: addr=1 len=2 parity=bad gap=20 |
| 218795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 218795 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 218830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 218985 | **DUT** | IN  pkt #466 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219015 | **DUT** | IN  pkt #466 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219015 | yapp monitor | RX pkt #466 on the input: addr=1 len=2 parity=bad gap=18 |
| 219015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219015 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 219115 | **DUT** | IN  pkt #467 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219145 | **DUT** | IN  pkt #467 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219145 | yapp monitor | RX pkt #467 on the input: addr=1 len=2 parity=bad gap=9 |
| 219145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219145 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219210 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 219355 | **DUT** | IN  pkt #468 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219385 | **DUT** | IN  pkt #468 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219385 | yapp monitor | RX pkt #468 on the input: addr=1 len=2 parity=bad gap=20 |
| 219385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219385 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219430 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 219595 | **DUT** | IN  pkt #469 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219625 | **DUT** | IN  pkt #469 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219625 | yapp monitor | RX pkt #469 on the input: addr=1 len=2 parity=bad gap=20 |
| 219625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219625 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219690 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 219775 | **DUT** | IN  pkt #470 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 219805 | **DUT** | IN  pkt #470 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 219805 | yapp monitor | RX pkt #470 on the input: addr=1 len=2 parity=bad gap=14 |
| 219805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 219805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 219890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 220015 | **DUT** | IN  pkt #471 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220045 | **DUT** | IN  pkt #471 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220045 | yapp monitor | RX pkt #471 on the input: addr=1 len=2 parity=bad gap=20 |
| 220045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220045 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220075 | **DUT** | IN  pkt #472 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220105 | **DUT** | IN  pkt #472 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220105 | yapp monitor | RX pkt #472 on the input: addr=1 len=2 parity=bad gap=2 |
| 220105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 220170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 220215 | **DUT** | IN  pkt #473 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220245 | **DUT** | IN  pkt #473 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220245 | yapp monitor | RX pkt #473 on the input: addr=1 len=2 parity=bad gap=10 |
| 220245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220245 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220290 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 220455 | **DUT** | IN  pkt #474 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220485 | **DUT** | IN  pkt #474 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220485 | yapp monitor | RX pkt #474 on the input: addr=1 len=2 parity=bad gap=20 |
| 220485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220485 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 220655 | **DUT** | IN  pkt #475 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220685 | **DUT** | IN  pkt #475 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220685 | yapp monitor | RX pkt #475 on the input: addr=1 len=2 parity=bad gap=16 |
| 220685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220685 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 220775 | **DUT** | IN  pkt #476 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 220805 | **DUT** | IN  pkt #476 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 220805 | yapp monitor | RX pkt #476 on the input: addr=1 len=2 parity=bad gap=8 |
| 220805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 220805 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 220830 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 220985 | **DUT** | IN  pkt #477 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221015 | **DUT** | IN  pkt #477 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221015 | yapp monitor | RX pkt #477 on the input: addr=1 len=2 parity=bad gap=17 |
| 221015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221015 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 221165 | **DUT** | IN  pkt #478 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221195 | **DUT** | IN  pkt #478 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221195 | yapp monitor | RX pkt #478 on the input: addr=1 len=2 parity=bad gap=14 |
| 221195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221195 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 221385 | **DUT** | IN  pkt #479 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221415 | **DUT** | IN  pkt #479 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221415 | yapp monitor | RX pkt #479 on the input: addr=1 len=2 parity=bad gap=18 |
| 221415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221415 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221510 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 221585 | **DUT** | IN  pkt #480 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221615 | **DUT** | IN  pkt #480 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221615 | yapp monitor | RX pkt #480 on the input: addr=1 len=2 parity=bad gap=16 |
| 221615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221615 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221635 | **DUT** | IN  pkt #481 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 221665 | **DUT** | IN  pkt #481 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221665 | yapp monitor | RX pkt #481 on the input: addr=1 len=2 parity=bad gap=1 |
| 221665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221665 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221685 | **DUT** | IN  pkt #482 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221690 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 221715 | **DUT** | IN  pkt #482 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221715 | yapp monitor | RX pkt #482 on the input: addr=1 len=2 parity=bad gap=1 |
| 221715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221715 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221735 | **DUT** | IN  pkt #483 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221765 | **DUT** | IN  pkt #483 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221765 | yapp monitor | RX pkt #483 on the input: addr=1 len=2 parity=bad gap=1 |
| 221765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 221790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 221800 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 221875 | **DUT** | IN  pkt #484 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 221905 | **DUT** | IN  pkt #484 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 221905 | yapp monitor | RX pkt #484 on the input: addr=1 len=2 parity=bad gap=10 |
| 221905 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 221905 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222010 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 222085 | **DUT** | IN  pkt #485 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222115 | **DUT** | IN  pkt #485 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222115 | yapp monitor | RX pkt #485 on the input: addr=1 len=2 parity=bad gap=17 |
| 222115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222115 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 222295 | **DUT** | IN  pkt #486 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222325 | **DUT** | IN  pkt #486 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222325 | yapp monitor | RX pkt #486 on the input: addr=1 len=2 parity=bad gap=17 |
| 222325 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222325 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222345 | **DUT** | IN  pkt #487 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 222375 | **DUT** | IN  pkt #487 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222375 | yapp monitor | RX pkt #487 on the input: addr=1 len=2 parity=bad gap=1 |
| 222375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222375 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 222555 | **DUT** | IN  pkt #488 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222585 | **DUT** | IN  pkt #488 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222585 | yapp monitor | RX pkt #488 on the input: addr=1 len=2 parity=bad gap=17 |
| 222585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222585 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222615 | **DUT** | IN  pkt #489 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 222645 | **DUT** | IN  pkt #489 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222645 | yapp monitor | RX pkt #489 on the input: addr=1 len=2 parity=bad gap=2 |
| 222645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 222835 | **DUT** | IN  pkt #490 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 222865 | **DUT** | IN  pkt #490 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 222865 | yapp monitor | RX pkt #490 on the input: addr=1 len=2 parity=bad gap=18 |
| 222865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 222865 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 222970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 223075 | **DUT** | IN  pkt #491 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223105 | **DUT** | IN  pkt #491 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223105 | yapp monitor | RX pkt #491 on the input: addr=1 len=2 parity=bad gap=20 |
| 223105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 223315 | **DUT** | IN  pkt #492 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223345 | **DUT** | IN  pkt #492 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223345 | yapp monitor | RX pkt #492 on the input: addr=1 len=2 parity=bad gap=20 |
| 223345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223345 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223395 | **DUT** | IN  pkt #493 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223425 | **DUT** | IN  pkt #493 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223425 | yapp monitor | RX pkt #493 on the input: addr=1 len=2 parity=bad gap=4 |
| 223425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 223460 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 223625 | **DUT** | IN  pkt #494 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223655 | **DUT** | IN  pkt #494 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223655 | yapp monitor | RX pkt #494 on the input: addr=1 len=2 parity=bad gap=19 |
| 223655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223655 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223725 | **DUT** | IN  pkt #495 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 223755 | **DUT** | IN  pkt #495 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223755 | yapp monitor | RX pkt #495 on the input: addr=1 len=2 parity=bad gap=6 |
| 223755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223755 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 223885 | **DUT** | IN  pkt #496 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 223915 | **DUT** | IN  pkt #496 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 223915 | yapp monitor | RX pkt #496 on the input: addr=1 len=2 parity=bad gap=12 |
| 223915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 223915 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 223950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 224125 | **DUT** | IN  pkt #497 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224155 | **DUT** | IN  pkt #497 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224155 | yapp monitor | RX pkt #497 on the input: addr=1 len=2 parity=bad gap=20 |
| 224155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224155 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224170 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 224255 | **DUT** | IN  pkt #498 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224285 | **DUT** | IN  pkt #498 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224285 | yapp monitor | RX pkt #498 on the input: addr=1 len=2 parity=bad gap=9 |
| 224285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224285 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 224425 | **DUT** | IN  pkt #499 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224455 | **DUT** | IN  pkt #499 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224455 | yapp monitor | RX pkt #499 on the input: addr=1 len=2 parity=bad gap=13 |
| 224455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224455 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 224615 | **DUT** | IN  pkt #500 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224645 | **DUT** | IN  pkt #500 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224645 | yapp monitor | RX pkt #500 on the input: addr=1 len=2 parity=bad gap=15 |
| 224645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224645 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224670 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 224855 | **DUT** | IN  pkt #501 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 224885 | **DUT** | IN  pkt #501 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 224885 | yapp monitor | RX pkt #501 on the input: addr=1 len=2 parity=bad gap=20 |
| 224885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 224885 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 224930 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 225095 | **DUT** | IN  pkt #502 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225125 | **DUT** | IN  pkt #502 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225125 | yapp monitor | RX pkt #502 on the input: addr=1 len=2 parity=bad gap=20 |
| 225125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225125 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 225245 | **DUT** | IN  pkt #503 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225275 | **DUT** | IN  pkt #503 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225275 | yapp monitor | RX pkt #503 on the input: addr=1 len=2 parity=bad gap=11 |
| 225275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225275 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225290 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 225395 | **DUT** | IN  pkt #504 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225425 | **DUT** | IN  pkt #504 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225425 | yapp monitor | RX pkt #504 on the input: addr=1 len=2 parity=bad gap=11 |
| 225425 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225425 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225530 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 225565 | **DUT** | IN  pkt #505 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225595 | **DUT** | IN  pkt #505 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225595 | yapp monitor | RX pkt #505 on the input: addr=1 len=2 parity=bad gap=13 |
| 225595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225595 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 225735 | **DUT** | IN  pkt #506 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225765 | **DUT** | IN  pkt #506 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225765 | yapp monitor | RX pkt #506 on the input: addr=1 len=2 parity=bad gap=13 |
| 225765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225765 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225790 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 225935 | **DUT** | IN  pkt #507 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 225965 | **DUT** | IN  pkt #507 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 225965 | yapp monitor | RX pkt #507 on the input: addr=1 len=2 parity=bad gap=16 |
| 225965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 225965 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 225995 | **DUT** | IN  pkt #508 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226025 | **DUT** | IN  pkt #508 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226025 | yapp monitor | RX pkt #508 on the input: addr=1 len=2 parity=bad gap=2 |
| 226025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 226025 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 226030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 226075 | **DUT** | IN  pkt #509 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 226105 | **DUT** | IN  pkt #509 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226105 | yapp monitor | RX pkt #509 on the input: addr=1 len=2 parity=bad gap=4 |
| 226105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 226105 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 226150 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 226175 | **DUT** | IN  pkt #510 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226205 | **DUT** | IN  pkt #510 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226205 | yapp monitor | RX pkt #510 on the input: addr=1 len=2 parity=bad gap=6 |
| 226205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 226205 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 226290 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 226415 | **DUT** | IN  pkt #511 header: addr=1 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226445 | **DUT** | IN  pkt #511 complete: addr=1 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226445 | yapp monitor | RX pkt #511 on the input: addr=1 len=2 parity=bad gap=20 |
| 226445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=1) |
| 226445 | **DUT** | ROUTER DROPS PACKET addr=1 length=2 (length > maxpktsize) |
| 226485 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 226510 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 226515 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 226545 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 226575 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 226605 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 226630 | **test** | STAGE: 7.3 en_reg = 0x41: 255 packets to address 2, counters read after 100 and after 255 |
| 226635 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 226655 | hbus monitor | Collected WRITE addr=0x1001 data=0x41 |
| 226655 | reference | router_en is now 1 (en_reg 0x41) |
| 226685 | **DUT** | IN  pkt #512 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226715 | **DUT** | IN  pkt #512 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226715 | yapp monitor | RX pkt #512 on the input: addr=2 len=2 parity=bad gap=23 |
| 226715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226730 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 226835 | **DUT** | IN  pkt #513 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 226865 | **DUT** | IN  pkt #513 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 226865 | yapp monitor | RX pkt #513 on the input: addr=2 len=2 parity=bad gap=11 |
| 226865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 226865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 226970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 227035 | **DUT** | IN  pkt #514 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227065 | **DUT** | IN  pkt #514 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227065 | yapp monitor | RX pkt #514 on the input: addr=2 len=2 parity=bad gap=16 |
| 227065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 227235 | **DUT** | IN  pkt #515 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227265 | **DUT** | IN  pkt #515 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227265 | yapp monitor | RX pkt #515 on the input: addr=2 len=2 parity=bad gap=16 |
| 227265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 227355 | **DUT** | IN  pkt #516 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227385 | **DUT** | IN  pkt #516 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227385 | yapp monitor | RX pkt #516 on the input: addr=2 len=2 parity=bad gap=8 |
| 227385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227385 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227405 | **DUT** | IN  pkt #517 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227430 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 227435 | **DUT** | IN  pkt #517 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227435 | yapp monitor | RX pkt #517 on the input: addr=2 len=2 parity=bad gap=1 |
| 227435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227470 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 227495 | **DUT** | IN  pkt #518 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227525 | **DUT** | IN  pkt #518 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227525 | yapp monitor | RX pkt #518 on the input: addr=2 len=2 parity=bad gap=5 |
| 227525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 227565 | **DUT** | IN  pkt #519 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227595 | **DUT** | IN  pkt #519 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227595 | yapp monitor | RX pkt #519 on the input: addr=2 len=2 parity=bad gap=3 |
| 227595 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227595 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227630 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 227805 | **DUT** | IN  pkt #520 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227835 | **DUT** | IN  pkt #520 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227835 | yapp monitor | RX pkt #520 on the input: addr=2 len=2 parity=bad gap=20 |
| 227835 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227835 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 227850 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 227915 | **DUT** | IN  pkt #521 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 227945 | **DUT** | IN  pkt #521 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 227945 | yapp monitor | RX pkt #521 on the input: addr=2 len=2 parity=bad gap=7 |
| 227945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 227945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 228155 | **DUT** | IN  pkt #522 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228185 | **DUT** | IN  pkt #522 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228185 | yapp monitor | RX pkt #522 on the input: addr=2 len=2 parity=bad gap=20 |
| 228185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228225 | **DUT** | IN  pkt #523 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 228255 | **DUT** | IN  pkt #523 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228255 | yapp monitor | RX pkt #523 on the input: addr=2 len=2 parity=bad gap=3 |
| 228255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 228465 | **DUT** | IN  pkt #524 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228495 | **DUT** | IN  pkt #524 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228495 | yapp monitor | RX pkt #524 on the input: addr=2 len=2 parity=bad gap=20 |
| 228495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 228635 | **DUT** | IN  pkt #525 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228665 | **DUT** | IN  pkt #525 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228665 | yapp monitor | RX pkt #525 on the input: addr=2 len=2 parity=bad gap=13 |
| 228665 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228665 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228685 | **DUT** | IN  pkt #526 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228710 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 228715 | **DUT** | IN  pkt #526 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228715 | yapp monitor | RX pkt #526 on the input: addr=2 len=2 parity=bad gap=1 |
| 228715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 228750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 228915 | **DUT** | IN  pkt #527 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 228945 | **DUT** | IN  pkt #527 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 228945 | yapp monitor | RX pkt #527 on the input: addr=2 len=2 parity=bad gap=19 |
| 228945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 228945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229045 | **DUT** | IN  pkt #528 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 229075 | **DUT** | IN  pkt #528 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229075 | yapp monitor | RX pkt #528 on the input: addr=2 len=2 parity=bad gap=9 |
| 229075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 229255 | **DUT** | IN  pkt #529 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229285 | **DUT** | IN  pkt #529 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229285 | yapp monitor | RX pkt #529 on the input: addr=2 len=2 parity=bad gap=17 |
| 229285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229310 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 229465 | **DUT** | IN  pkt #530 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229495 | **DUT** | IN  pkt #530 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229495 | yapp monitor | RX pkt #530 on the input: addr=2 len=2 parity=bad gap=17 |
| 229495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 229705 | **DUT** | IN  pkt #531 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229735 | **DUT** | IN  pkt #531 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229735 | yapp monitor | RX pkt #531 on the input: addr=2 len=2 parity=bad gap=20 |
| 229735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229755 | **DUT** | IN  pkt #532 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229785 | **DUT** | IN  pkt #532 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229785 | yapp monitor | RX pkt #532 on the input: addr=2 len=2 parity=bad gap=1 |
| 229785 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229785 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 229840 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 229905 | **DUT** | IN  pkt #533 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 229935 | **DUT** | IN  pkt #533 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 229935 | yapp monitor | RX pkt #533 on the input: addr=2 len=2 parity=bad gap=11 |
| 229935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 229935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 229970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 229985 | **DUT** | IN  pkt #534 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230015 | **DUT** | IN  pkt #534 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230015 | yapp monitor | RX pkt #534 on the input: addr=2 len=2 parity=bad gap=4 |
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
| 230615 | **DUT** | IN  pkt #537 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230645 | **DUT** | IN  pkt #537 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230645 | yapp monitor | RX pkt #537 on the input: addr=2 len=2 parity=bad gap=12 |
| 230645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 230845 | **DUT** | IN  pkt #538 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 230875 | **DUT** | IN  pkt #538 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 230875 | yapp monitor | RX pkt #538 on the input: addr=2 len=2 parity=bad gap=19 |
| 230875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 230875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 230890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 231085 | **DUT** | IN  pkt #539 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231115 | **DUT** | IN  pkt #539 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231115 | yapp monitor | RX pkt #539 on the input: addr=2 len=2 parity=bad gap=20 |
| 231115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231115 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 231325 | **DUT** | IN  pkt #540 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231355 | **DUT** | IN  pkt #540 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231355 | yapp monitor | RX pkt #540 on the input: addr=2 len=2 parity=bad gap=20 |
| 231355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231355 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231370 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 231555 | **DUT** | IN  pkt #541 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231585 | **DUT** | IN  pkt #541 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231585 | yapp monitor | RX pkt #541 on the input: addr=2 len=2 parity=bad gap=19 |
| 231585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 231795 | **DUT** | IN  pkt #542 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 231825 | **DUT** | IN  pkt #542 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 231825 | yapp monitor | RX pkt #542 on the input: addr=2 len=2 parity=bad gap=20 |
| 231825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 231825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 231930 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 232025 | **DUT** | IN  pkt #543 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232055 | **DUT** | IN  pkt #543 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232055 | yapp monitor | RX pkt #543 on the input: addr=2 len=2 parity=bad gap=19 |
| 232055 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232055 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 232105 | **DUT** | IN  pkt #544 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232135 | **DUT** | IN  pkt #544 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232135 | yapp monitor | RX pkt #544 on the input: addr=2 len=2 parity=bad gap=4 |
| 232135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232195 | **DUT** | IN  pkt #545 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232225 | **DUT** | IN  pkt #545 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232225 | yapp monitor | RX pkt #545 on the input: addr=2 len=2 parity=bad gap=5 |
| 232225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 232250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 232425 | **DUT** | IN  pkt #546 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232455 | **DUT** | IN  pkt #546 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232455 | yapp monitor | RX pkt #546 on the input: addr=2 len=2 parity=bad gap=19 |
| 232455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 232655 | **DUT** | IN  pkt #547 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232685 | **DUT** | IN  pkt #547 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232685 | yapp monitor | RX pkt #547 on the input: addr=2 len=2 parity=bad gap=19 |
| 232685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 232895 | **DUT** | IN  pkt #548 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232925 | **DUT** | IN  pkt #548 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232925 | yapp monitor | RX pkt #548 on the input: addr=2 len=2 parity=bad gap=20 |
| 232925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 232945 | **DUT** | IN  pkt #549 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 232975 | **DUT** | IN  pkt #549 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 232975 | yapp monitor | RX pkt #549 on the input: addr=2 len=2 parity=bad gap=1 |
| 232975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 232975 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 233020 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 233145 | **DUT** | IN  pkt #550 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233175 | **DUT** | IN  pkt #550 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233175 | yapp monitor | RX pkt #550 on the input: addr=2 len=2 parity=bad gap=16 |
| 233175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233190 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 233365 | **DUT** | IN  pkt #551 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233395 | **DUT** | IN  pkt #551 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233395 | yapp monitor | RX pkt #551 on the input: addr=2 len=2 parity=bad gap=18 |
| 233395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233395 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233470 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 233595 | **DUT** | IN  pkt #552 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233625 | **DUT** | IN  pkt #552 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233625 | yapp monitor | RX pkt #552 on the input: addr=2 len=2 parity=bad gap=19 |
| 233625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 233835 | **DUT** | IN  pkt #553 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 233865 | **DUT** | IN  pkt #553 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 233865 | yapp monitor | RX pkt #553 on the input: addr=2 len=2 parity=bad gap=20 |
| 233865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 233865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 233930 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 234015 | **DUT** | IN  pkt #554 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234045 | **DUT** | IN  pkt #554 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234045 | yapp monitor | RX pkt #554 on the input: addr=2 len=2 parity=bad gap=14 |
| 234045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 234135 | **DUT** | IN  pkt #555 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234165 | **DUT** | IN  pkt #555 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234165 | yapp monitor | RX pkt #555 on the input: addr=2 len=2 parity=bad gap=8 |
| 234165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234210 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234375 | **DUT** | IN  pkt #556 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234405 | **DUT** | IN  pkt #556 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234405 | yapp monitor | RX pkt #556 on the input: addr=2 len=2 parity=bad gap=20 |
| 234405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 234615 | **DUT** | IN  pkt #557 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234645 | **DUT** | IN  pkt #557 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234645 | yapp monitor | RX pkt #557 on the input: addr=2 len=2 parity=bad gap=20 |
| 234645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 234835 | **DUT** | IN  pkt #558 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 234865 | **DUT** | IN  pkt #558 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 234865 | yapp monitor | RX pkt #558 on the input: addr=2 len=2 parity=bad gap=18 |
| 234865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 234865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 234970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 235045 | **DUT** | IN  pkt #559 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235075 | **DUT** | IN  pkt #559 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235075 | yapp monitor | RX pkt #559 on the input: addr=2 len=2 parity=bad gap=17 |
| 235075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235130 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 235185 | **DUT** | IN  pkt #560 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235215 | **DUT** | IN  pkt #560 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235215 | yapp monitor | RX pkt #560 on the input: addr=2 len=2 parity=bad gap=10 |
| 235215 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235215 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235235 | **DUT** | IN  pkt #561 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235250 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 235265 | **DUT** | IN  pkt #561 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235265 | yapp monitor | RX pkt #561 on the input: addr=2 len=2 parity=bad gap=1 |
| 235265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235285 | **DUT** | IN  pkt #562 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235290 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 235315 | **DUT** | IN  pkt #562 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235315 | yapp monitor | RX pkt #562 on the input: addr=2 len=2 parity=bad gap=1 |
| 235315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 235465 | **DUT** | IN  pkt #563 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235495 | **DUT** | IN  pkt #563 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235495 | yapp monitor | RX pkt #563 on the input: addr=2 len=2 parity=bad gap=14 |
| 235495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235590 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 235615 | **DUT** | IN  pkt #564 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235645 | **DUT** | IN  pkt #564 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235645 | yapp monitor | RX pkt #564 on the input: addr=2 len=2 parity=bad gap=11 |
| 235645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235730 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 235835 | **DUT** | IN  pkt #565 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 235865 | **DUT** | IN  pkt #565 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 235865 | yapp monitor | RX pkt #565 on the input: addr=2 len=2 parity=bad gap=18 |
| 235865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 235865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 235910 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 236075 | **DUT** | IN  pkt #566 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236105 | **DUT** | IN  pkt #566 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236105 | yapp monitor | RX pkt #566 on the input: addr=2 len=2 parity=bad gap=20 |
| 236105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236170 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 236265 | **DUT** | IN  pkt #567 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236295 | **DUT** | IN  pkt #567 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236295 | yapp monitor | RX pkt #567 on the input: addr=2 len=2 parity=bad gap=15 |
| 236295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 236505 | **DUT** | IN  pkt #568 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236535 | **DUT** | IN  pkt #568 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236535 | yapp monitor | RX pkt #568 on the input: addr=2 len=2 parity=bad gap=20 |
| 236535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 236555 | **DUT** | IN  pkt #569 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236585 | **DUT** | IN  pkt #569 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236585 | yapp monitor | RX pkt #569 on the input: addr=2 len=2 parity=bad gap=1 |
| 236585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236650 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 236685 | **DUT** | IN  pkt #570 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236715 | **DUT** | IN  pkt #570 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236715 | yapp monitor | RX pkt #570 on the input: addr=2 len=2 parity=bad gap=9 |
| 236715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 236750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 236915 | **DUT** | IN  pkt #571 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 236945 | **DUT** | IN  pkt #571 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 236945 | yapp monitor | RX pkt #571 on the input: addr=2 len=2 parity=bad gap=19 |
| 236945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 236945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 237155 | **DUT** | IN  pkt #572 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237185 | **DUT** | IN  pkt #572 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237185 | yapp monitor | RX pkt #572 on the input: addr=2 len=2 parity=bad gap=20 |
| 237185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 237285 | **DUT** | IN  pkt #573 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237315 | **DUT** | IN  pkt #573 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237315 | yapp monitor | RX pkt #573 on the input: addr=2 len=2 parity=bad gap=9 |
| 237315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237335 | **DUT** | IN  pkt #574 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237365 | **DUT** | IN  pkt #574 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237365 | yapp monitor | RX pkt #574 on the input: addr=2 len=2 parity=bad gap=1 |
| 237365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237365 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 237410 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 237495 | **DUT** | IN  pkt #575 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237525 | **DUT** | IN  pkt #575 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237525 | yapp monitor | RX pkt #575 on the input: addr=2 len=2 parity=bad gap=12 |
| 237525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 237695 | **DUT** | IN  pkt #576 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237725 | **DUT** | IN  pkt #576 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237725 | yapp monitor | RX pkt #576 on the input: addr=2 len=2 parity=bad gap=16 |
| 237725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 237905 | **DUT** | IN  pkt #577 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 237935 | **DUT** | IN  pkt #577 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 237935 | yapp monitor | RX pkt #577 on the input: addr=2 len=2 parity=bad gap=17 |
| 237935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 237935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 237970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 238145 | **DUT** | IN  pkt #578 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238175 | **DUT** | IN  pkt #578 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238175 | yapp monitor | RX pkt #578 on the input: addr=2 len=2 parity=bad gap=20 |
| 238175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238230 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 238345 | **DUT** | IN  pkt #579 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238375 | **DUT** | IN  pkt #579 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238375 | yapp monitor | RX pkt #579 on the input: addr=2 len=2 parity=bad gap=16 |
| 238375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238470 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 238525 | **DUT** | IN  pkt #580 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238555 | **DUT** | IN  pkt #580 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238555 | yapp monitor | RX pkt #580 on the input: addr=2 len=2 parity=bad gap=14 |
| 238555 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238555 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238570 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 238765 | **DUT** | IN  pkt #581 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238795 | **DUT** | IN  pkt #581 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238795 | yapp monitor | RX pkt #581 on the input: addr=2 len=2 parity=bad gap=20 |
| 238795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238815 | **DUT** | IN  pkt #582 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 238830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 238845 | **DUT** | IN  pkt #582 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 238845 | yapp monitor | RX pkt #582 on the input: addr=2 len=2 parity=bad gap=1 |
| 238845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 238845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 238930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 239035 | **DUT** | IN  pkt #583 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239065 | **DUT** | IN  pkt #583 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239065 | yapp monitor | RX pkt #583 on the input: addr=2 len=2 parity=bad gap=18 |
| 239065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 239145 | **DUT** | IN  pkt #584 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239175 | **DUT** | IN  pkt #584 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239175 | yapp monitor | RX pkt #584 on the input: addr=2 len=2 parity=bad gap=7 |
| 239175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 239385 | **DUT** | IN  pkt #585 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239415 | **DUT** | IN  pkt #585 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239415 | yapp monitor | RX pkt #585 on the input: addr=2 len=2 parity=bad gap=20 |
| 239415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 239625 | **DUT** | IN  pkt #586 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239655 | **DUT** | IN  pkt #586 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239655 | yapp monitor | RX pkt #586 on the input: addr=2 len=2 parity=bad gap=20 |
| 239655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239715 | **DUT** | IN  pkt #587 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239745 | **DUT** | IN  pkt #587 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239745 | yapp monitor | RX pkt #587 on the input: addr=2 len=2 parity=bad gap=5 |
| 239745 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239745 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 239750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 239770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 239955 | **DUT** | IN  pkt #588 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 239985 | **DUT** | IN  pkt #588 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 239985 | yapp monitor | RX pkt #588 on the input: addr=2 len=2 parity=bad gap=20 |
| 239985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 239985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 240195 | **DUT** | IN  pkt #589 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240225 | **DUT** | IN  pkt #589 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240225 | yapp monitor | RX pkt #589 on the input: addr=2 len=2 parity=bad gap=20 |
| 240225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 240405 | **DUT** | IN  pkt #590 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240435 | **DUT** | IN  pkt #590 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240435 | yapp monitor | RX pkt #590 on the input: addr=2 len=2 parity=bad gap=17 |
| 240435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240475 | **DUT** | IN  pkt #591 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240505 | **DUT** | IN  pkt #591 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240505 | yapp monitor | RX pkt #591 on the input: addr=2 len=2 parity=bad gap=3 |
| 240505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240510 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 240550 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 240695 | **DUT** | IN  pkt #592 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240725 | **DUT** | IN  pkt #592 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240725 | yapp monitor | RX pkt #592 on the input: addr=2 len=2 parity=bad gap=18 |
| 240725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 240770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 240895 | **DUT** | IN  pkt #593 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 240925 | **DUT** | IN  pkt #593 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 240925 | yapp monitor | RX pkt #593 on the input: addr=2 len=2 parity=bad gap=16 |
| 240925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 240925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 241035 | **DUT** | IN  pkt #594 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241065 | **DUT** | IN  pkt #594 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241065 | yapp monitor | RX pkt #594 on the input: addr=2 len=2 parity=bad gap=10 |
| 241065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241130 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 241195 | **DUT** | IN  pkt #595 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241225 | **DUT** | IN  pkt #595 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241225 | yapp monitor | RX pkt #595 on the input: addr=2 len=2 parity=bad gap=12 |
| 241225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241245 | **DUT** | IN  pkt #596 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241275 | **DUT** | IN  pkt #596 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241275 | yapp monitor | RX pkt #596 on the input: addr=2 len=2 parity=bad gap=1 |
| 241275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241290 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 241300 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 241485 | **DUT** | IN  pkt #597 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241515 | **DUT** | IN  pkt #597 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241515 | yapp monitor | RX pkt #597 on the input: addr=2 len=2 parity=bad gap=20 |
| 241515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 241645 | **DUT** | IN  pkt #598 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241675 | **DUT** | IN  pkt #598 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241675 | yapp monitor | RX pkt #598 on the input: addr=2 len=2 parity=bad gap=12 |
| 241675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 241725 | **DUT** | IN  pkt #599 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241755 | **DUT** | IN  pkt #599 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241755 | yapp monitor | RX pkt #599 on the input: addr=2 len=2 parity=bad gap=4 |
| 241755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241755 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 241845 | **DUT** | IN  pkt #600 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 241875 | **DUT** | IN  pkt #600 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 241875 | yapp monitor | RX pkt #600 on the input: addr=2 len=2 parity=bad gap=8 |
| 241875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 241875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 241950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 242045 | **DUT** | IN  pkt #601 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242075 | **DUT** | IN  pkt #601 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242075 | yapp monitor | RX pkt #601 on the input: addr=2 len=2 parity=bad gap=16 |
| 242075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 242225 | **DUT** | IN  pkt #602 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242255 | **DUT** | IN  pkt #602 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242255 | yapp monitor | RX pkt #602 on the input: addr=2 len=2 parity=bad gap=14 |
| 242255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242290 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 242375 | **DUT** | IN  pkt #603 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242405 | **DUT** | IN  pkt #603 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242405 | yapp monitor | RX pkt #603 on the input: addr=2 len=2 parity=bad gap=11 |
| 242405 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242405 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242430 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 242615 | **DUT** | IN  pkt #604 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242645 | **DUT** | IN  pkt #604 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242645 | yapp monitor | RX pkt #604 on the input: addr=2 len=2 parity=bad gap=20 |
| 242645 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242645 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 242855 | **DUT** | IN  pkt #605 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 242885 | **DUT** | IN  pkt #605 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 242885 | yapp monitor | RX pkt #605 on the input: addr=2 len=2 parity=bad gap=20 |
| 242885 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 242885 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 242910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 243005 | **DUT** | IN  pkt #606 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243035 | **DUT** | IN  pkt #606 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243035 | yapp monitor | RX pkt #606 on the input: addr=2 len=2 parity=bad gap=11 |
| 243035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 243215 | **DUT** | IN  pkt #607 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243245 | **DUT** | IN  pkt #607 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243245 | yapp monitor | RX pkt #607 on the input: addr=2 len=2 parity=bad gap=17 |
| 243245 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243245 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243455 | **DUT** | IN  pkt #608 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243485 | **DUT** | IN  pkt #608 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243485 | yapp monitor | RX pkt #608 on the input: addr=2 len=2 parity=bad gap=20 |
| 243485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243485 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 243695 | **DUT** | IN  pkt #609 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243725 | **DUT** | IN  pkt #609 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243725 | yapp monitor | RX pkt #609 on the input: addr=2 len=2 parity=bad gap=20 |
| 243725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 243790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 243935 | **DUT** | IN  pkt #610 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 243965 | **DUT** | IN  pkt #610 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 243965 | yapp monitor | RX pkt #610 on the input: addr=2 len=2 parity=bad gap=20 |
| 243965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 243965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 244145 | **DUT** | IN  pkt #611 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244175 | **DUT** | IN  pkt #611 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244175 | yapp monitor | RX pkt #611 on the input: addr=2 len=2 parity=bad gap=17 |
| 244175 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244175 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 244215 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 244245 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 244275 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 244305 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 244335 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 244365 | hbus monitor | Collected READ  addr=0x100b data=0x64 |
| 244485 | **DUT** | IN  pkt #612 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244515 | **DUT** | IN  pkt #612 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244515 | yapp monitor | RX pkt #612 on the input: addr=2 len=2 parity=bad gap=30 |
| 244515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 244585 | **DUT** | IN  pkt #613 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244615 | **DUT** | IN  pkt #613 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244615 | yapp monitor | RX pkt #613 on the input: addr=2 len=2 parity=bad gap=6 |
| 244615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244710 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 244795 | **DUT** | IN  pkt #614 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 244825 | **DUT** | IN  pkt #614 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 244825 | yapp monitor | RX pkt #614 on the input: addr=2 len=2 parity=bad gap=17 |
| 244825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 244825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 244870 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 245015 | **DUT** | IN  pkt #615 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245045 | **DUT** | IN  pkt #615 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245045 | yapp monitor | RX pkt #615 on the input: addr=2 len=2 parity=bad gap=18 |
| 245045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245065 | **DUT** | IN  pkt #616 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245090 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 245095 | **DUT** | IN  pkt #616 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245095 | yapp monitor | RX pkt #616 on the input: addr=2 len=2 parity=bad gap=1 |
| 245095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245125 | **DUT** | IN  pkt #617 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245155 | **DUT** | IN  pkt #617 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245155 | yapp monitor | RX pkt #617 on the input: addr=2 len=2 parity=bad gap=2 |
| 245155 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245155 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 245210 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 245255 | **DUT** | IN  pkt #618 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245285 | **DUT** | IN  pkt #618 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245285 | yapp monitor | RX pkt #618 on the input: addr=2 len=2 parity=bad gap=9 |
| 245285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245310 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 245495 | **DUT** | IN  pkt #619 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245525 | **DUT** | IN  pkt #619 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245525 | yapp monitor | RX pkt #619 on the input: addr=2 len=2 parity=bad gap=20 |
| 245525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 245685 | **DUT** | IN  pkt #620 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245715 | **DUT** | IN  pkt #620 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245715 | yapp monitor | RX pkt #620 on the input: addr=2 len=2 parity=bad gap=15 |
| 245715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 245915 | **DUT** | IN  pkt #621 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 245945 | **DUT** | IN  pkt #621 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 245945 | yapp monitor | RX pkt #621 on the input: addr=2 len=2 parity=bad gap=19 |
| 245945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 245945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 245990 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 246045 | **DUT** | IN  pkt #622 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246075 | **DUT** | IN  pkt #622 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246075 | yapp monitor | RX pkt #622 on the input: addr=2 len=2 parity=bad gap=9 |
| 246075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246090 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 246095 | **DUT** | IN  pkt #623 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246125 | **DUT** | IN  pkt #623 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246125 | yapp monitor | RX pkt #623 on the input: addr=2 len=2 parity=bad gap=1 |
| 246125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246125 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246190 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 246325 | **DUT** | IN  pkt #624 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246355 | **DUT** | IN  pkt #624 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246355 | yapp monitor | RX pkt #624 on the input: addr=2 len=2 parity=bad gap=19 |
| 246355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246355 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 246475 | **DUT** | IN  pkt #625 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246505 | **DUT** | IN  pkt #625 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246505 | yapp monitor | RX pkt #625 on the input: addr=2 len=2 parity=bad gap=11 |
| 246505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 246675 | **DUT** | IN  pkt #626 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246705 | **DUT** | IN  pkt #626 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246705 | yapp monitor | RX pkt #626 on the input: addr=2 len=2 parity=bad gap=16 |
| 246705 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246705 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246810 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 246915 | **DUT** | IN  pkt #627 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 246945 | **DUT** | IN  pkt #627 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 246945 | yapp monitor | RX pkt #627 on the input: addr=2 len=2 parity=bad gap=20 |
| 246945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 246945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 246970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 247075 | **DUT** | IN  pkt #628 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247105 | **DUT** | IN  pkt #628 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247105 | yapp monitor | RX pkt #628 on the input: addr=2 len=2 parity=bad gap=12 |
| 247105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 247245 | **DUT** | IN  pkt #629 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247275 | **DUT** | IN  pkt #629 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247275 | yapp monitor | RX pkt #629 on the input: addr=2 len=2 parity=bad gap=13 |
| 247275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247310 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 247315 | **DUT** | IN  pkt #630 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247345 | **DUT** | IN  pkt #630 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247345 | yapp monitor | RX pkt #630 on the input: addr=2 len=2 parity=bad gap=3 |
| 247345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 247555 | **DUT** | IN  pkt #631 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247585 | **DUT** | IN  pkt #631 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247585 | yapp monitor | RX pkt #631 on the input: addr=2 len=2 parity=bad gap=20 |
| 247585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 247775 | **DUT** | IN  pkt #632 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247805 | **DUT** | IN  pkt #632 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247805 | yapp monitor | RX pkt #632 on the input: addr=2 len=2 parity=bad gap=18 |
| 247805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247885 | **DUT** | IN  pkt #633 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 247890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 247915 | **DUT** | IN  pkt #633 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 247915 | yapp monitor | RX pkt #633 on the input: addr=2 len=2 parity=bad gap=7 |
| 247915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 247915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 247950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 248045 | **DUT** | IN  pkt #634 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248075 | **DUT** | IN  pkt #634 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248075 | yapp monitor | RX pkt #634 on the input: addr=2 len=2 parity=bad gap=12 |
| 248075 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248075 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248110 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 248285 | **DUT** | IN  pkt #635 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248315 | **DUT** | IN  pkt #635 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248315 | yapp monitor | RX pkt #635 on the input: addr=2 len=2 parity=bad gap=20 |
| 248315 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248315 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 248465 | **DUT** | IN  pkt #636 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248495 | **DUT** | IN  pkt #636 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248495 | yapp monitor | RX pkt #636 on the input: addr=2 len=2 parity=bad gap=14 |
| 248495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248530 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 248705 | **DUT** | IN  pkt #637 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248735 | **DUT** | IN  pkt #637 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248735 | yapp monitor | RX pkt #637 on the input: addr=2 len=2 parity=bad gap=20 |
| 248735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 248945 | **DUT** | IN  pkt #638 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 248975 | **DUT** | IN  pkt #638 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 248975 | yapp monitor | RX pkt #638 on the input: addr=2 len=2 parity=bad gap=20 |
| 248975 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 248975 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 248995 | **DUT** | IN  pkt #639 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 249025 | **DUT** | IN  pkt #639 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249025 | yapp monitor | RX pkt #639 on the input: addr=2 len=2 parity=bad gap=1 |
| 249025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249050 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 249235 | **DUT** | IN  pkt #640 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249265 | **DUT** | IN  pkt #640 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249265 | yapp monitor | RX pkt #640 on the input: addr=2 len=2 parity=bad gap=20 |
| 249265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 249405 | **DUT** | IN  pkt #641 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249435 | **DUT** | IN  pkt #641 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249435 | yapp monitor | RX pkt #641 on the input: addr=2 len=2 parity=bad gap=13 |
| 249435 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249435 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249450 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 249555 | **DUT** | IN  pkt #642 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249585 | **DUT** | IN  pkt #642 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249585 | yapp monitor | RX pkt #642 on the input: addr=2 len=2 parity=bad gap=11 |
| 249585 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249585 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 249795 | **DUT** | IN  pkt #643 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 249825 | **DUT** | IN  pkt #643 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 249825 | yapp monitor | RX pkt #643 on the input: addr=2 len=2 parity=bad gap=20 |
| 249825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 249825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 249850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 250035 | **DUT** | IN  pkt #644 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250065 | **DUT** | IN  pkt #644 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250065 | yapp monitor | RX pkt #644 on the input: addr=2 len=2 parity=bad gap=20 |
| 250065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 250245 | **DUT** | IN  pkt #645 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250275 | **DUT** | IN  pkt #645 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250275 | yapp monitor | RX pkt #645 on the input: addr=2 len=2 parity=bad gap=17 |
| 250275 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250275 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250330 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 250475 | **DUT** | IN  pkt #646 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250505 | **DUT** | IN  pkt #646 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250505 | yapp monitor | RX pkt #646 on the input: addr=2 len=2 parity=bad gap=19 |
| 250505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250570 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 250595 | **DUT** | IN  pkt #647 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250625 | **DUT** | IN  pkt #647 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250625 | yapp monitor | RX pkt #647 on the input: addr=2 len=2 parity=bad gap=8 |
| 250625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250650 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 250795 | **DUT** | IN  pkt #648 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 250825 | **DUT** | IN  pkt #648 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 250825 | yapp monitor | RX pkt #648 on the input: addr=2 len=2 parity=bad gap=16 |
| 250825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 250825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 250890 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 251035 | **DUT** | IN  pkt #649 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251065 | **DUT** | IN  pkt #649 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251065 | yapp monitor | RX pkt #649 on the input: addr=2 len=2 parity=bad gap=20 |
| 251065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251085 | **DUT** | IN  pkt #650 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 251115 | **DUT** | IN  pkt #650 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251115 | yapp monitor | RX pkt #650 on the input: addr=2 len=2 parity=bad gap=1 |
| 251115 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251115 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 251175 | **DUT** | IN  pkt #651 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251205 | **DUT** | IN  pkt #651 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251205 | yapp monitor | RX pkt #651 on the input: addr=2 len=2 parity=bad gap=5 |
| 251205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251205 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 251385 | **DUT** | IN  pkt #652 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251415 | **DUT** | IN  pkt #652 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251415 | yapp monitor | RX pkt #652 on the input: addr=2 len=2 parity=bad gap=17 |
| 251415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251430 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 251505 | **DUT** | IN  pkt #653 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251535 | **DUT** | IN  pkt #653 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251535 | yapp monitor | RX pkt #653 on the input: addr=2 len=2 parity=bad gap=8 |
| 251535 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251535 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251570 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 251705 | **DUT** | IN  pkt #654 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251735 | **DUT** | IN  pkt #654 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251735 | yapp monitor | RX pkt #654 on the input: addr=2 len=2 parity=bad gap=16 |
| 251735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 251865 | **DUT** | IN  pkt #655 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 251895 | **DUT** | IN  pkt #655 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 251895 | yapp monitor | RX pkt #655 on the input: addr=2 len=2 parity=bad gap=12 |
| 251895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 251895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 251910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 252105 | **DUT** | IN  pkt #656 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252135 | **DUT** | IN  pkt #656 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252135 | yapp monitor | RX pkt #656 on the input: addr=2 len=2 parity=bad gap=20 |
| 252135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 252305 | **DUT** | IN  pkt #657 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252335 | **DUT** | IN  pkt #657 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252335 | yapp monitor | RX pkt #657 on the input: addr=2 len=2 parity=bad gap=16 |
| 252335 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252335 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 252515 | **DUT** | IN  pkt #658 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252545 | **DUT** | IN  pkt #658 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252545 | yapp monitor | RX pkt #658 on the input: addr=2 len=2 parity=bad gap=17 |
| 252545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252570 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 252695 | **DUT** | IN  pkt #659 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252725 | **DUT** | IN  pkt #659 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252725 | yapp monitor | RX pkt #659 on the input: addr=2 len=2 parity=bad gap=14 |
| 252725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 252770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 252915 | **DUT** | IN  pkt #660 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 252945 | **DUT** | IN  pkt #660 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 252945 | yapp monitor | RX pkt #660 on the input: addr=2 len=2 parity=bad gap=18 |
| 252945 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 252945 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253050 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 253155 | **DUT** | IN  pkt #661 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253185 | **DUT** | IN  pkt #661 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253185 | yapp monitor | RX pkt #661 on the input: addr=2 len=2 parity=bad gap=20 |
| 253185 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253185 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 253255 | **DUT** | IN  pkt #662 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253285 | **DUT** | IN  pkt #662 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253285 | yapp monitor | RX pkt #662 on the input: addr=2 len=2 parity=bad gap=6 |
| 253285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253310 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 253445 | **DUT** | IN  pkt #663 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253475 | **DUT** | IN  pkt #663 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253475 | yapp monitor | RX pkt #663 on the input: addr=2 len=2 parity=bad gap=15 |
| 253475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 253595 | **DUT** | IN  pkt #664 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253625 | **DUT** | IN  pkt #664 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253625 | yapp monitor | RX pkt #664 on the input: addr=2 len=2 parity=bad gap=11 |
| 253625 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253625 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 253785 | **DUT** | IN  pkt #665 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253815 | **DUT** | IN  pkt #665 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253815 | yapp monitor | RX pkt #665 on the input: addr=2 len=2 parity=bad gap=15 |
| 253815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 253830 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 253955 | **DUT** | IN  pkt #666 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 253985 | **DUT** | IN  pkt #666 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 253985 | yapp monitor | RX pkt #666 on the input: addr=2 len=2 parity=bad gap=13 |
| 253985 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 253985 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254010 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 254195 | **DUT** | IN  pkt #667 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254225 | **DUT** | IN  pkt #667 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254225 | yapp monitor | RX pkt #667 on the input: addr=2 len=2 parity=bad gap=20 |
| 254225 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254225 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254255 | **DUT** | IN  pkt #668 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254285 | **DUT** | IN  pkt #668 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254285 | yapp monitor | RX pkt #668 on the input: addr=2 len=2 parity=bad gap=2 |
| 254285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254330 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 254350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 254495 | **DUT** | IN  pkt #669 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254525 | **DUT** | IN  pkt #669 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254525 | yapp monitor | RX pkt #669 on the input: addr=2 len=2 parity=bad gap=20 |
| 254525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 254705 | **DUT** | IN  pkt #670 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254735 | **DUT** | IN  pkt #670 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254735 | yapp monitor | RX pkt #670 on the input: addr=2 len=2 parity=bad gap=17 |
| 254735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 254770 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 254935 | **DUT** | IN  pkt #671 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 254965 | **DUT** | IN  pkt #671 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 254965 | yapp monitor | RX pkt #671 on the input: addr=2 len=2 parity=bad gap=19 |
| 254965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 254965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 255135 | **DUT** | IN  pkt #672 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255165 | **DUT** | IN  pkt #672 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255165 | yapp monitor | RX pkt #672 on the input: addr=2 len=2 parity=bad gap=16 |
| 255165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 255365 | **DUT** | IN  pkt #673 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255395 | **DUT** | IN  pkt #673 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255395 | yapp monitor | RX pkt #673 on the input: addr=2 len=2 parity=bad gap=19 |
| 255395 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255395 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255435 | **DUT** | IN  pkt #674 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 255465 | **DUT** | IN  pkt #674 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255465 | yapp monitor | RX pkt #674 on the input: addr=2 len=2 parity=bad gap=3 |
| 255465 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255465 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 255645 | **DUT** | IN  pkt #675 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255675 | **DUT** | IN  pkt #675 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255675 | yapp monitor | RX pkt #675 on the input: addr=2 len=2 parity=bad gap=17 |
| 255675 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255675 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255690 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 255775 | **DUT** | IN  pkt #676 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 255805 | **DUT** | IN  pkt #676 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 255805 | yapp monitor | RX pkt #676 on the input: addr=2 len=2 parity=bad gap=9 |
| 255805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 255805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 255890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 256015 | **DUT** | IN  pkt #677 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256045 | **DUT** | IN  pkt #677 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256045 | yapp monitor | RX pkt #677 on the input: addr=2 len=2 parity=bad gap=20 |
| 256045 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256045 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256110 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 256235 | **DUT** | IN  pkt #678 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256265 | **DUT** | IN  pkt #678 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256265 | yapp monitor | RX pkt #678 on the input: addr=2 len=2 parity=bad gap=18 |
| 256265 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256265 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256330 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 256345 | **DUT** | IN  pkt #679 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256375 | **DUT** | IN  pkt #679 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256375 | yapp monitor | RX pkt #679 on the input: addr=2 len=2 parity=bad gap=7 |
| 256375 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256375 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256390 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 256425 | **DUT** | IN  pkt #680 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256455 | **DUT** | IN  pkt #680 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256455 | yapp monitor | RX pkt #680 on the input: addr=2 len=2 parity=bad gap=4 |
| 256455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256495 | **DUT** | IN  pkt #681 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256525 | **DUT** | IN  pkt #681 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256525 | yapp monitor | RX pkt #681 on the input: addr=2 len=2 parity=bad gap=3 |
| 256525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 256590 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 256735 | **DUT** | IN  pkt #682 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256765 | **DUT** | IN  pkt #682 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256765 | yapp monitor | RX pkt #682 on the input: addr=2 len=2 parity=bad gap=20 |
| 256765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256850 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 256865 | **DUT** | IN  pkt #683 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 256895 | **DUT** | IN  pkt #683 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 256895 | yapp monitor | RX pkt #683 on the input: addr=2 len=2 parity=bad gap=9 |
| 256895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 256895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 256950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 257065 | **DUT** | IN  pkt #684 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257095 | **DUT** | IN  pkt #684 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257095 | yapp monitor | RX pkt #684 on the input: addr=2 len=2 parity=bad gap=16 |
| 257095 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257095 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 257265 | **DUT** | IN  pkt #685 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257295 | **DUT** | IN  pkt #685 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257295 | yapp monitor | RX pkt #685 on the input: addr=2 len=2 parity=bad gap=16 |
| 257295 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257295 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 257475 | **DUT** | IN  pkt #686 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257505 | **DUT** | IN  pkt #686 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257505 | yapp monitor | RX pkt #686 on the input: addr=2 len=2 parity=bad gap=17 |
| 257505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257530 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 257705 | **DUT** | IN  pkt #687 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257735 | **DUT** | IN  pkt #687 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257735 | yapp monitor | RX pkt #687 on the input: addr=2 len=2 parity=bad gap=19 |
| 257735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 257830 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 257925 | **DUT** | IN  pkt #688 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 257955 | **DUT** | IN  pkt #688 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 257955 | yapp monitor | RX pkt #688 on the input: addr=2 len=2 parity=bad gap=18 |
| 257955 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 257955 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 258105 | **DUT** | IN  pkt #689 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258135 | **DUT** | IN  pkt #689 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258135 | yapp monitor | RX pkt #689 on the input: addr=2 len=2 parity=bad gap=14 |
| 258135 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258135 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258150 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 258335 | **DUT** | IN  pkt #690 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258365 | **DUT** | IN  pkt #690 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258365 | yapp monitor | RX pkt #690 on the input: addr=2 len=2 parity=bad gap=19 |
| 258365 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258365 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258385 | **DUT** | IN  pkt #691 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258415 | **DUT** | IN  pkt #691 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258415 | yapp monitor | RX pkt #691 on the input: addr=2 len=2 parity=bad gap=1 |
| 258415 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258415 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258450 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 258460 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 258625 | **DUT** | IN  pkt #692 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258655 | **DUT** | IN  pkt #692 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258655 | yapp monitor | RX pkt #692 on the input: addr=2 len=2 parity=bad gap=20 |
| 258655 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258655 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258710 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 258835 | **DUT** | IN  pkt #693 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 258865 | **DUT** | IN  pkt #693 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 258865 | yapp monitor | RX pkt #693 on the input: addr=2 len=2 parity=bad gap=17 |
| 258865 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 258865 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 258970 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 259075 | **DUT** | IN  pkt #694 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259105 | **DUT** | IN  pkt #694 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259105 | yapp monitor | RX pkt #694 on the input: addr=2 len=2 parity=bad gap=20 |
| 259105 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259105 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 259275 | **DUT** | IN  pkt #695 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259305 | **DUT** | IN  pkt #695 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259305 | yapp monitor | RX pkt #695 on the input: addr=2 len=2 parity=bad gap=16 |
| 259305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259370 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 259475 | **DUT** | IN  pkt #696 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259505 | **DUT** | IN  pkt #696 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259505 | yapp monitor | RX pkt #696 on the input: addr=2 len=2 parity=bad gap=16 |
| 259505 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259505 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259610 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 259665 | **DUT** | IN  pkt #697 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259695 | **DUT** | IN  pkt #697 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259695 | yapp monitor | RX pkt #697 on the input: addr=2 len=2 parity=bad gap=15 |
| 259695 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259695 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 259845 | **DUT** | IN  pkt #698 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 259875 | **DUT** | IN  pkt #698 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 259875 | yapp monitor | RX pkt #698 on the input: addr=2 len=2 parity=bad gap=14 |
| 259875 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 259875 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 259930 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260005 | **DUT** | IN  pkt #699 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260035 | **DUT** | IN  pkt #699 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260035 | yapp monitor | RX pkt #699 on the input: addr=2 len=2 parity=bad gap=12 |
| 260035 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260035 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260090 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260095 | **DUT** | IN  pkt #700 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260125 | **DUT** | IN  pkt #700 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260125 | yapp monitor | RX pkt #700 on the input: addr=2 len=2 parity=bad gap=5 |
| 260125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260125 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260165 | **DUT** | IN  pkt #701 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260195 | **DUT** | IN  pkt #701 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260195 | yapp monitor | RX pkt #701 on the input: addr=2 len=2 parity=bad gap=3 |
| 260195 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260195 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 260250 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260315 | **DUT** | IN  pkt #702 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260345 | **DUT** | IN  pkt #702 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260345 | yapp monitor | RX pkt #702 on the input: addr=2 len=2 parity=bad gap=11 |
| 260345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 260485 | **DUT** | IN  pkt #703 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260515 | **DUT** | IN  pkt #703 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260515 | yapp monitor | RX pkt #703 on the input: addr=2 len=2 parity=bad gap=13 |
| 260515 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260515 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260570 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260705 | **DUT** | IN  pkt #704 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260735 | **DUT** | IN  pkt #704 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260735 | yapp monitor | RX pkt #704 on the input: addr=2 len=2 parity=bad gap=18 |
| 260735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260785 | **DUT** | IN  pkt #705 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 260790 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 260815 | **DUT** | IN  pkt #705 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 260815 | yapp monitor | RX pkt #705 on the input: addr=2 len=2 parity=bad gap=4 |
| 260815 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 260815 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 260850 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 260985 | **DUT** | IN  pkt #706 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261015 | **DUT** | IN  pkt #706 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261015 | yapp monitor | RX pkt #706 on the input: addr=2 len=2 parity=bad gap=16 |
| 261015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 261055 | **DUT** | IN  pkt #707 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261085 | **DUT** | IN  pkt #707 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261085 | yapp monitor | RX pkt #707 on the input: addr=2 len=2 parity=bad gap=3 |
| 261085 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261085 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261115 | **DUT** | IN  pkt #708 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261145 | **DUT** | IN  pkt #708 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261145 | yapp monitor | RX pkt #708 on the input: addr=2 len=2 parity=bad gap=2 |
| 261145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 261190 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 261205 | **DUT** | IN  pkt #709 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261235 | **DUT** | IN  pkt #709 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261235 | yapp monitor | RX pkt #709 on the input: addr=2 len=2 parity=bad gap=5 |
| 261235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 261445 | **DUT** | IN  pkt #710 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261475 | **DUT** | IN  pkt #710 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261475 | yapp monitor | RX pkt #710 on the input: addr=2 len=2 parity=bad gap=20 |
| 261475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261515 | **DUT** | IN  pkt #711 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261530 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 261545 | **DUT** | IN  pkt #711 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261545 | yapp monitor | RX pkt #711 on the input: addr=2 len=2 parity=bad gap=3 |
| 261545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 261695 | **DUT** | IN  pkt #712 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261725 | **DUT** | IN  pkt #712 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261725 | yapp monitor | RX pkt #712 on the input: addr=2 len=2 parity=bad gap=14 |
| 261725 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261725 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 261810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 261935 | **DUT** | IN  pkt #713 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 261965 | **DUT** | IN  pkt #713 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 261965 | yapp monitor | RX pkt #713 on the input: addr=2 len=2 parity=bad gap=20 |
| 261965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 261965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 262115 | **DUT** | IN  pkt #714 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262145 | **DUT** | IN  pkt #714 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262145 | yapp monitor | RX pkt #714 on the input: addr=2 len=2 parity=bad gap=14 |
| 262145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 262275 | **DUT** | IN  pkt #715 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262305 | **DUT** | IN  pkt #715 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262305 | yapp monitor | RX pkt #715 on the input: addr=2 len=2 parity=bad gap=12 |
| 262305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 262495 | **DUT** | IN  pkt #716 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262525 | **DUT** | IN  pkt #716 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262525 | yapp monitor | RX pkt #716 on the input: addr=2 len=2 parity=bad gap=18 |
| 262525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 262735 | **DUT** | IN  pkt #717 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262765 | **DUT** | IN  pkt #717 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262765 | yapp monitor | RX pkt #717 on the input: addr=2 len=2 parity=bad gap=20 |
| 262765 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262765 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 262830 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 262935 | **DUT** | IN  pkt #718 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 262965 | **DUT** | IN  pkt #718 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 262965 | yapp monitor | RX pkt #718 on the input: addr=2 len=2 parity=bad gap=16 |
| 262965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 262965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263010 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 263175 | **DUT** | IN  pkt #719 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263205 | **DUT** | IN  pkt #719 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263205 | yapp monitor | RX pkt #719 on the input: addr=2 len=2 parity=bad gap=20 |
| 263205 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263205 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263230 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263415 | **DUT** | IN  pkt #720 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263445 | **DUT** | IN  pkt #720 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263445 | yapp monitor | RX pkt #720 on the input: addr=2 len=2 parity=bad gap=20 |
| 263445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263490 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 263655 | **DUT** | IN  pkt #721 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263685 | **DUT** | IN  pkt #721 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263685 | yapp monitor | RX pkt #721 on the input: addr=2 len=2 parity=bad gap=20 |
| 263685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263705 | **DUT** | IN  pkt #722 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263710 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 263735 | **DUT** | IN  pkt #722 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263735 | yapp monitor | RX pkt #722 on the input: addr=2 len=2 parity=bad gap=1 |
| 263735 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263735 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263750 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 263765 | **DUT** | IN  pkt #723 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 263795 | **DUT** | IN  pkt #723 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 263795 | yapp monitor | RX pkt #723 on the input: addr=2 len=2 parity=bad gap=2 |
| 263795 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 263795 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 263870 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 263995 | **DUT** | IN  pkt #724 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264025 | **DUT** | IN  pkt #724 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264025 | yapp monitor | RX pkt #724 on the input: addr=2 len=2 parity=bad gap=19 |
| 264025 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264025 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264070 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 264205 | **DUT** | IN  pkt #725 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264235 | **DUT** | IN  pkt #725 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264235 | yapp monitor | RX pkt #725 on the input: addr=2 len=2 parity=bad gap=17 |
| 264235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264270 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 264445 | **DUT** | IN  pkt #726 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264475 | **DUT** | IN  pkt #726 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264475 | yapp monitor | RX pkt #726 on the input: addr=2 len=2 parity=bad gap=20 |
| 264475 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264475 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264490 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 264685 | **DUT** | IN  pkt #727 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264715 | **DUT** | IN  pkt #727 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264715 | yapp monitor | RX pkt #727 on the input: addr=2 len=2 parity=bad gap=20 |
| 264715 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264715 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264750 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 264885 | **DUT** | IN  pkt #728 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264915 | **DUT** | IN  pkt #728 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264915 | yapp monitor | RX pkt #728 on the input: addr=2 len=2 parity=bad gap=16 |
| 264915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 264965 | **DUT** | IN  pkt #729 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 264990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 264995 | **DUT** | IN  pkt #729 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 264995 | yapp monitor | RX pkt #729 on the input: addr=2 len=2 parity=bad gap=4 |
| 264995 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 264995 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 265205 | **DUT** | IN  pkt #730 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265235 | **DUT** | IN  pkt #730 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265235 | yapp monitor | RX pkt #730 on the input: addr=2 len=2 parity=bad gap=20 |
| 265235 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265235 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 265415 | **DUT** | IN  pkt #731 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265445 | **DUT** | IN  pkt #731 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265445 | yapp monitor | RX pkt #731 on the input: addr=2 len=2 parity=bad gap=17 |
| 265445 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265445 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265470 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 265545 | **DUT** | IN  pkt #732 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265575 | **DUT** | IN  pkt #732 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265575 | yapp monitor | RX pkt #732 on the input: addr=2 len=2 parity=bad gap=9 |
| 265575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265670 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 265745 | **DUT** | IN  pkt #733 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265775 | **DUT** | IN  pkt #733 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265775 | yapp monitor | RX pkt #733 on the input: addr=2 len=2 parity=bad gap=16 |
| 265775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265810 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 265905 | **DUT** | IN  pkt #734 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 265935 | **DUT** | IN  pkt #734 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 265935 | yapp monitor | RX pkt #734 on the input: addr=2 len=2 parity=bad gap=12 |
| 265935 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 265935 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 265970 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 266115 | **DUT** | IN  pkt #735 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266145 | **DUT** | IN  pkt #735 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266145 | yapp monitor | RX pkt #735 on the input: addr=2 len=2 parity=bad gap=17 |
| 266145 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266145 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 266355 | **DUT** | IN  pkt #736 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266385 | **DUT** | IN  pkt #736 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266385 | yapp monitor | RX pkt #736 on the input: addr=2 len=2 parity=bad gap=20 |
| 266385 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266385 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 266585 | **DUT** | IN  pkt #737 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266615 | **DUT** | IN  pkt #737 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266615 | yapp monitor | RX pkt #737 on the input: addr=2 len=2 parity=bad gap=19 |
| 266615 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266615 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 266825 | **DUT** | IN  pkt #738 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266855 | **DUT** | IN  pkt #738 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266855 | yapp monitor | RX pkt #738 on the input: addr=2 len=2 parity=bad gap=20 |
| 266855 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266855 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266895 | **DUT** | IN  pkt #739 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 266925 | **DUT** | IN  pkt #739 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 266925 | yapp monitor | RX pkt #739 on the input: addr=2 len=2 parity=bad gap=3 |
| 266925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 266925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 266950 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 266990 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 267135 | **DUT** | IN  pkt #740 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267165 | **DUT** | IN  pkt #740 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267165 | yapp monitor | RX pkt #740 on the input: addr=2 len=2 parity=bad gap=20 |
| 267165 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267165 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267250 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 267315 | **DUT** | IN  pkt #741 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267345 | **DUT** | IN  pkt #741 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267345 | yapp monitor | RX pkt #741 on the input: addr=2 len=2 parity=bad gap=14 |
| 267345 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267345 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267450 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 267455 | **DUT** | IN  pkt #742 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267485 | **DUT** | IN  pkt #742 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267485 | yapp monitor | RX pkt #742 on the input: addr=2 len=2 parity=bad gap=10 |
| 267485 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267485 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267545 | **DUT** | IN  pkt #743 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267570 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 267575 | **DUT** | IN  pkt #743 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267575 | yapp monitor | RX pkt #743 on the input: addr=2 len=2 parity=bad gap=5 |
| 267575 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267575 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267590 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 267775 | **DUT** | IN  pkt #744 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 267805 | **DUT** | IN  pkt #744 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 267805 | yapp monitor | RX pkt #744 on the input: addr=2 len=2 parity=bad gap=19 |
| 267805 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 267805 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 267890 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 267985 | **DUT** | IN  pkt #745 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268015 | **DUT** | IN  pkt #745 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268015 | yapp monitor | RX pkt #745 on the input: addr=2 len=2 parity=bad gap=17 |
| 268015 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268015 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268050 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 268225 | **DUT** | IN  pkt #746 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268255 | **DUT** | IN  pkt #746 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268255 | yapp monitor | RX pkt #746 on the input: addr=2 len=2 parity=bad gap=20 |
| 268255 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268255 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268310 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 268425 | **DUT** | IN  pkt #747 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268455 | **DUT** | IN  pkt #747 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268455 | yapp monitor | RX pkt #747 on the input: addr=2 len=2 parity=bad gap=16 |
| 268455 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268455 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268550 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 268655 | **DUT** | IN  pkt #748 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268685 | **DUT** | IN  pkt #748 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268685 | yapp monitor | RX pkt #748 on the input: addr=2 len=2 parity=bad gap=19 |
| 268685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 268750 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 268895 | **DUT** | IN  pkt #749 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 268925 | **DUT** | IN  pkt #749 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 268925 | yapp monitor | RX pkt #749 on the input: addr=2 len=2 parity=bad gap=20 |
| 268925 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 268925 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 269095 | **DUT** | IN  pkt #750 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269125 | **DUT** | IN  pkt #750 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269125 | yapp monitor | RX pkt #750 on the input: addr=2 len=2 parity=bad gap=16 |
| 269125 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269125 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 269325 | **DUT** | IN  pkt #751 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269355 | **DUT** | IN  pkt #751 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269355 | yapp monitor | RX pkt #751 on the input: addr=2 len=2 parity=bad gap=19 |
| 269355 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269355 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 269465 | **DUT** | IN  pkt #752 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269495 | **DUT** | IN  pkt #752 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269495 | yapp monitor | RX pkt #752 on the input: addr=2 len=2 parity=bad gap=10 |
| 269495 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269495 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269510 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 269655 | **DUT** | IN  pkt #753 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269685 | **DUT** | IN  pkt #753 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269685 | yapp monitor | RX pkt #753 on the input: addr=2 len=2 parity=bad gap=15 |
| 269685 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269685 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 269795 | **DUT** | IN  pkt #754 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 269825 | **DUT** | IN  pkt #754 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 269825 | yapp monitor | RX pkt #754 on the input: addr=2 len=2 parity=bad gap=10 |
| 269825 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 269825 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 269850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 270035 | **DUT** | IN  pkt #755 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270065 | **DUT** | IN  pkt #755 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270065 | yapp monitor | RX pkt #755 on the input: addr=2 len=2 parity=bad gap=20 |
| 270065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 270255 | **DUT** | IN  pkt #756 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270285 | **DUT** | IN  pkt #756 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270285 | yapp monitor | RX pkt #756 on the input: addr=2 len=2 parity=bad gap=18 |
| 270285 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270285 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 270495 | **DUT** | IN  pkt #757 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270525 | **DUT** | IN  pkt #757 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270525 | yapp monitor | RX pkt #757 on the input: addr=2 len=2 parity=bad gap=20 |
| 270525 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270525 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 270725 | **DUT** | IN  pkt #758 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270755 | **DUT** | IN  pkt #758 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270755 | yapp monitor | RX pkt #758 on the input: addr=2 len=2 parity=bad gap=19 |
| 270755 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270755 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270810 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 270865 | **DUT** | IN  pkt #759 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 270895 | **DUT** | IN  pkt #759 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 270895 | yapp monitor | RX pkt #759 on the input: addr=2 len=2 parity=bad gap=10 |
| 270895 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 270895 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 270930 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 271035 | **DUT** | IN  pkt #760 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271065 | **DUT** | IN  pkt #760 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271065 | yapp monitor | RX pkt #760 on the input: addr=2 len=2 parity=bad gap=13 |
| 271065 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271065 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271110 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 271275 | **DUT** | IN  pkt #761 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271305 | **DUT** | IN  pkt #761 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271305 | yapp monitor | RX pkt #761 on the input: addr=2 len=2 parity=bad gap=20 |
| 271305 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271305 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271370 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 271515 | **DUT** | IN  pkt #762 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271545 | **DUT** | IN  pkt #762 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271545 | yapp monitor | RX pkt #762 on the input: addr=2 len=2 parity=bad gap=20 |
| 271545 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271545 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 271745 | **DUT** | IN  pkt #763 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271775 | **DUT** | IN  pkt #763 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271775 | yapp monitor | RX pkt #763 on the input: addr=2 len=2 parity=bad gap=19 |
| 271775 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271775 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271815 | **DUT** | IN  pkt #764 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 271845 | **DUT** | IN  pkt #764 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271845 | yapp monitor | RX pkt #764 on the input: addr=2 len=2 parity=bad gap=3 |
| 271845 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271845 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271870 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 271885 | **DUT** | IN  pkt #765 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271915 | **DUT** | IN  pkt #765 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271915 | yapp monitor | RX pkt #765 on the input: addr=2 len=2 parity=bad gap=3 |
| 271915 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271915 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 271935 | **DUT** | IN  pkt #766 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 271950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 271965 | **DUT** | IN  pkt #766 complete: addr=2 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 271965 | yapp monitor | RX pkt #766 on the input: addr=2 len=2 parity=bad gap=1 |
| 271965 | reference | Packet dropped: length 2 > maxpktsize 1 (addr=2) |
| 271965 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 272005 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 272035 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 272050 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 272065 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 272095 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 272125 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 272150 | **test** | STAGE: 7.4 en_reg = 0x81: 255 packets to address 3, counters read after 100 and after 255 |
| 272155 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 272175 | hbus monitor | Collected WRITE addr=0x1001 data=0x81 |
| 272175 | reference | router_en is now 1 (en_reg 0x81) |
| 272255 | **DUT** | IN  pkt #767 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272285 | **DUT** | IN  pkt #767 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272285 | yapp monitor | RX pkt #767 on the input: addr=3 len=2 parity=bad gap=28 |
| 272285 | reference | Packet dropped: illegal address 3 (len=2) |
| 272285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 272495 | **DUT** | IN  pkt #768 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272525 | **DUT** | IN  pkt #768 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272525 | yapp monitor | RX pkt #768 on the input: addr=3 len=2 parity=bad gap=20 |
| 272525 | reference | Packet dropped: illegal address 3 (len=2) |
| 272525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272590 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 272605 | **DUT** | IN  pkt #769 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272635 | **DUT** | IN  pkt #769 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272635 | yapp monitor | RX pkt #769 on the input: addr=3 len=2 parity=bad gap=7 |
| 272635 | reference | Packet dropped: illegal address 3 (len=2) |
| 272635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 272835 | **DUT** | IN  pkt #770 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272865 | **DUT** | IN  pkt #770 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272865 | yapp monitor | RX pkt #770 on the input: addr=3 len=2 parity=bad gap=19 |
| 272865 | reference | Packet dropped: illegal address 3 (len=2) |
| 272865 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 272890 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 272965 | **DUT** | IN  pkt #771 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 272995 | **DUT** | IN  pkt #771 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 272995 | yapp monitor | RX pkt #771 on the input: addr=3 len=2 parity=bad gap=9 |
| 272995 | reference | Packet dropped: illegal address 3 (len=2) |
| 272995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 273165 | **DUT** | IN  pkt #772 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273195 | **DUT** | IN  pkt #772 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273195 | yapp monitor | RX pkt #772 on the input: addr=3 len=2 parity=bad gap=16 |
| 273195 | reference | Packet dropped: illegal address 3 (len=2) |
| 273195 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273230 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 273355 | **DUT** | IN  pkt #773 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273385 | **DUT** | IN  pkt #773 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273385 | yapp monitor | RX pkt #773 on the input: addr=3 len=2 parity=bad gap=15 |
| 273385 | reference | Packet dropped: illegal address 3 (len=2) |
| 273385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273435 | **DUT** | IN  pkt #774 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273450 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 273465 | **DUT** | IN  pkt #774 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273465 | yapp monitor | RX pkt #774 on the input: addr=3 len=2 parity=bad gap=4 |
| 273465 | reference | Packet dropped: illegal address 3 (len=2) |
| 273465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273510 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 273575 | **DUT** | IN  pkt #775 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273605 | **DUT** | IN  pkt #775 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273605 | yapp monitor | RX pkt #775 on the input: addr=3 len=2 parity=bad gap=10 |
| 273605 | reference | Packet dropped: illegal address 3 (len=2) |
| 273605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 273685 | **DUT** | IN  pkt #776 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273715 | **DUT** | IN  pkt #776 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273715 | yapp monitor | RX pkt #776 on the input: addr=3 len=2 parity=bad gap=7 |
| 273715 | reference | Packet dropped: illegal address 3 (len=2) |
| 273715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 273790 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 273925 | **DUT** | IN  pkt #777 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 273955 | **DUT** | IN  pkt #777 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 273955 | yapp monitor | RX pkt #777 on the input: addr=3 len=2 parity=bad gap=20 |
| 273955 | reference | Packet dropped: illegal address 3 (len=2) |
| 273955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 274155 | **DUT** | IN  pkt #778 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274185 | **DUT** | IN  pkt #778 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274185 | yapp monitor | RX pkt #778 on the input: addr=3 len=2 parity=bad gap=19 |
| 274185 | reference | Packet dropped: illegal address 3 (len=2) |
| 274185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274250 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 274395 | **DUT** | IN  pkt #779 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274425 | **DUT** | IN  pkt #779 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274425 | yapp monitor | RX pkt #779 on the input: addr=3 len=2 parity=bad gap=20 |
| 274425 | reference | Packet dropped: illegal address 3 (len=2) |
| 274425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274470 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 274635 | **DUT** | IN  pkt #780 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274665 | **DUT** | IN  pkt #780 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274665 | yapp monitor | RX pkt #780 on the input: addr=3 len=2 parity=bad gap=20 |
| 274665 | reference | Packet dropped: illegal address 3 (len=2) |
| 274665 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274730 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 274815 | **DUT** | IN  pkt #781 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274845 | **DUT** | IN  pkt #781 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274845 | yapp monitor | RX pkt #781 on the input: addr=3 len=2 parity=bad gap=14 |
| 274845 | reference | Packet dropped: illegal address 3 (len=2) |
| 274845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 274930 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 274965 | **DUT** | IN  pkt #782 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 274995 | **DUT** | IN  pkt #782 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 274995 | yapp monitor | RX pkt #782 on the input: addr=3 len=2 parity=bad gap=11 |
| 274995 | reference | Packet dropped: illegal address 3 (len=2) |
| 274995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 275195 | **DUT** | IN  pkt #783 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275225 | **DUT** | IN  pkt #783 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275225 | yapp monitor | RX pkt #783 on the input: addr=3 len=2 parity=bad gap=19 |
| 275225 | reference | Packet dropped: illegal address 3 (len=2) |
| 275225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275435 | **DUT** | IN  pkt #784 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275465 | **DUT** | IN  pkt #784 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275465 | yapp monitor | RX pkt #784 on the input: addr=3 len=2 parity=bad gap=20 |
| 275465 | reference | Packet dropped: illegal address 3 (len=2) |
| 275465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275515 | **DUT** | IN  pkt #785 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 275545 | **DUT** | IN  pkt #785 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275545 | yapp monitor | RX pkt #785 on the input: addr=3 len=2 parity=bad gap=4 |
| 275545 | reference | Packet dropped: illegal address 3 (len=2) |
| 275545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275590 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 275715 | **DUT** | IN  pkt #786 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275745 | **DUT** | IN  pkt #786 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275745 | yapp monitor | RX pkt #786 on the input: addr=3 len=2 parity=bad gap=16 |
| 275745 | reference | Packet dropped: illegal address 3 (len=2) |
| 275745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275770 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 275825 | **DUT** | IN  pkt #787 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275855 | **DUT** | IN  pkt #787 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275855 | yapp monitor | RX pkt #787 on the input: addr=3 len=2 parity=bad gap=7 |
| 275855 | reference | Packet dropped: illegal address 3 (len=2) |
| 275855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 275890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 275915 | **DUT** | IN  pkt #788 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 275945 | **DUT** | IN  pkt #788 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 275945 | yapp monitor | RX pkt #788 on the input: addr=3 len=2 parity=bad gap=5 |
| 275945 | reference | Packet dropped: illegal address 3 (len=2) |
| 275945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276010 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 276155 | **DUT** | IN  pkt #789 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276185 | **DUT** | IN  pkt #789 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276185 | yapp monitor | RX pkt #789 on the input: addr=3 len=2 parity=bad gap=20 |
| 276185 | reference | Packet dropped: illegal address 3 (len=2) |
| 276185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276230 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 276285 | **DUT** | IN  pkt #790 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276315 | **DUT** | IN  pkt #790 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276315 | yapp monitor | RX pkt #790 on the input: addr=3 len=2 parity=bad gap=9 |
| 276315 | reference | Packet dropped: illegal address 3 (len=2) |
| 276315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276330 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 276525 | **DUT** | IN  pkt #791 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276555 | **DUT** | IN  pkt #791 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276555 | yapp monitor | RX pkt #791 on the input: addr=3 len=2 parity=bad gap=20 |
| 276555 | reference | Packet dropped: illegal address 3 (len=2) |
| 276555 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276590 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 276745 | **DUT** | IN  pkt #792 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276775 | **DUT** | IN  pkt #792 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276775 | yapp monitor | RX pkt #792 on the input: addr=3 len=2 parity=bad gap=18 |
| 276775 | reference | Packet dropped: illegal address 3 (len=2) |
| 276775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276815 | **DUT** | IN  pkt #793 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276845 | **DUT** | IN  pkt #793 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276845 | yapp monitor | RX pkt #793 on the input: addr=3 len=2 parity=bad gap=3 |
| 276845 | reference | Packet dropped: illegal address 3 (len=2) |
| 276845 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 276885 | **DUT** | IN  pkt #794 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276910 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 276915 | **DUT** | IN  pkt #794 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276915 | yapp monitor | RX pkt #794 on the input: addr=3 len=2 parity=bad gap=3 |
| 276915 | reference | Packet dropped: illegal address 3 (len=2) |
| 276915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276945 | **DUT** | IN  pkt #795 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 276975 | **DUT** | IN  pkt #795 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 276975 | yapp monitor | RX pkt #795 on the input: addr=3 len=2 parity=bad gap=2 |
| 276975 | reference | Packet dropped: illegal address 3 (len=2) |
| 276975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 276990 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 277010 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 277055 | **DUT** | IN  pkt #796 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277085 | **DUT** | IN  pkt #796 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277085 | yapp monitor | RX pkt #796 on the input: addr=3 len=2 parity=bad gap=7 |
| 277085 | reference | Packet dropped: illegal address 3 (len=2) |
| 277085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277170 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 277215 | **DUT** | IN  pkt #797 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277245 | **DUT** | IN  pkt #797 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277245 | yapp monitor | RX pkt #797 on the input: addr=3 len=2 parity=bad gap=12 |
| 277245 | reference | Packet dropped: illegal address 3 (len=2) |
| 277245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277285 | **DUT** | IN  pkt #798 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277315 | **DUT** | IN  pkt #798 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277315 | yapp monitor | RX pkt #798 on the input: addr=3 len=2 parity=bad gap=3 |
| 277315 | reference | Packet dropped: illegal address 3 (len=2) |
| 277315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 277370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 277485 | **DUT** | IN  pkt #799 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277515 | **DUT** | IN  pkt #799 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277515 | yapp monitor | RX pkt #799 on the input: addr=3 len=2 parity=bad gap=16 |
| 277515 | reference | Packet dropped: illegal address 3 (len=2) |
| 277515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277550 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 277725 | **DUT** | IN  pkt #800 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277755 | **DUT** | IN  pkt #800 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277755 | yapp monitor | RX pkt #800 on the input: addr=3 len=2 parity=bad gap=20 |
| 277755 | reference | Packet dropped: illegal address 3 (len=2) |
| 277755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 277770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 277965 | **DUT** | IN  pkt #801 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 277995 | **DUT** | IN  pkt #801 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 277995 | yapp monitor | RX pkt #801 on the input: addr=3 len=2 parity=bad gap=20 |
| 277995 | reference | Packet dropped: illegal address 3 (len=2) |
| 277995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 278125 | **DUT** | IN  pkt #802 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278155 | **DUT** | IN  pkt #802 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278155 | yapp monitor | RX pkt #802 on the input: addr=3 len=2 parity=bad gap=12 |
| 278155 | reference | Packet dropped: illegal address 3 (len=2) |
| 278155 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278190 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 278365 | **DUT** | IN  pkt #803 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278395 | **DUT** | IN  pkt #803 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278395 | yapp monitor | RX pkt #803 on the input: addr=3 len=2 parity=bad gap=20 |
| 278395 | reference | Packet dropped: illegal address 3 (len=2) |
| 278395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278410 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 278435 | **DUT** | IN  pkt #804 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278465 | **DUT** | IN  pkt #804 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278465 | yapp monitor | RX pkt #804 on the input: addr=3 len=2 parity=bad gap=3 |
| 278465 | reference | Packet dropped: illegal address 3 (len=2) |
| 278465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278490 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 278545 | **DUT** | IN  pkt #805 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278575 | **DUT** | IN  pkt #805 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278575 | yapp monitor | RX pkt #805 on the input: addr=3 len=2 parity=bad gap=7 |
| 278575 | reference | Packet dropped: illegal address 3 (len=2) |
| 278575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 278615 | **DUT** | IN  pkt #806 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278645 | **DUT** | IN  pkt #806 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278645 | yapp monitor | RX pkt #806 on the input: addr=3 len=2 parity=bad gap=3 |
| 278645 | reference | Packet dropped: illegal address 3 (len=2) |
| 278645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278690 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 278855 | **DUT** | IN  pkt #807 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 278885 | **DUT** | IN  pkt #807 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 278885 | yapp monitor | RX pkt #807 on the input: addr=3 len=2 parity=bad gap=20 |
| 278885 | reference | Packet dropped: illegal address 3 (len=2) |
| 278885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 278910 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279095 | **DUT** | IN  pkt #808 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279125 | **DUT** | IN  pkt #808 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279125 | yapp monitor | RX pkt #808 on the input: addr=3 len=2 parity=bad gap=20 |
| 279125 | reference | Packet dropped: illegal address 3 (len=2) |
| 279125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279170 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 279335 | **DUT** | IN  pkt #809 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279365 | **DUT** | IN  pkt #809 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279365 | yapp monitor | RX pkt #809 on the input: addr=3 len=2 parity=bad gap=20 |
| 279365 | reference | Packet dropped: illegal address 3 (len=2) |
| 279365 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279390 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279555 | **DUT** | IN  pkt #810 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279585 | **DUT** | IN  pkt #810 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279585 | yapp monitor | RX pkt #810 on the input: addr=3 len=2 parity=bad gap=18 |
| 279585 | reference | Packet dropped: illegal address 3 (len=2) |
| 279585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 279685 | **DUT** | IN  pkt #811 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279715 | **DUT** | IN  pkt #811 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279715 | yapp monitor | RX pkt #811 on the input: addr=3 len=2 parity=bad gap=9 |
| 279715 | reference | Packet dropped: illegal address 3 (len=2) |
| 279715 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279735 | **DUT** | IN  pkt #812 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279765 | **DUT** | IN  pkt #812 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279765 | yapp monitor | RX pkt #812 on the input: addr=3 len=2 parity=bad gap=1 |
| 279765 | reference | Packet dropped: illegal address 3 (len=2) |
| 279765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 279770 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 279810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 279955 | **DUT** | IN  pkt #813 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 279985 | **DUT** | IN  pkt #813 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 279985 | yapp monitor | RX pkt #813 on the input: addr=3 len=2 parity=bad gap=18 |
| 279985 | reference | Packet dropped: illegal address 3 (len=2) |
| 279985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280090 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 280195 | **DUT** | IN  pkt #814 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280225 | **DUT** | IN  pkt #814 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280225 | yapp monitor | RX pkt #814 on the input: addr=3 len=2 parity=bad gap=20 |
| 280225 | reference | Packet dropped: illegal address 3 (len=2) |
| 280225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280250 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 280375 | **DUT** | IN  pkt #815 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280405 | **DUT** | IN  pkt #815 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280405 | yapp monitor | RX pkt #815 on the input: addr=3 len=2 parity=bad gap=14 |
| 280405 | reference | Packet dropped: illegal address 3 (len=2) |
| 280405 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280450 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 280605 | **DUT** | IN  pkt #816 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280635 | **DUT** | IN  pkt #816 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280635 | yapp monitor | RX pkt #816 on the input: addr=3 len=2 parity=bad gap=19 |
| 280635 | reference | Packet dropped: illegal address 3 (len=2) |
| 280635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 280825 | **DUT** | IN  pkt #817 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 280855 | **DUT** | IN  pkt #817 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 280855 | yapp monitor | RX pkt #817 on the input: addr=3 len=2 parity=bad gap=18 |
| 280855 | reference | Packet dropped: illegal address 3 (len=2) |
| 280855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 280870 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281025 | **DUT** | IN  pkt #818 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281055 | **DUT** | IN  pkt #818 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281055 | yapp monitor | RX pkt #818 on the input: addr=3 len=2 parity=bad gap=16 |
| 281055 | reference | Packet dropped: illegal address 3 (len=2) |
| 281055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 281235 | **DUT** | IN  pkt #819 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281265 | **DUT** | IN  pkt #819 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281265 | yapp monitor | RX pkt #819 on the input: addr=3 len=2 parity=bad gap=17 |
| 281265 | reference | Packet dropped: illegal address 3 (len=2) |
| 281265 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281295 | **DUT** | IN  pkt #820 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281325 | **DUT** | IN  pkt #820 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281325 | yapp monitor | RX pkt #820 on the input: addr=3 len=2 parity=bad gap=2 |
| 281325 | reference | Packet dropped: illegal address 3 (len=2) |
| 281325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281345 | **DUT** | IN  pkt #821 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 281375 | **DUT** | IN  pkt #821 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281375 | yapp monitor | RX pkt #821 on the input: addr=3 len=2 parity=bad gap=1 |
| 281375 | reference | Packet dropped: illegal address 3 (len=2) |
| 281375 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 281430 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 281565 | **DUT** | IN  pkt #822 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281595 | **DUT** | IN  pkt #822 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281595 | yapp monitor | RX pkt #822 on the input: addr=3 len=2 parity=bad gap=18 |
| 281595 | reference | Packet dropped: illegal address 3 (len=2) |
| 281595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281610 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 281715 | **DUT** | IN  pkt #823 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281745 | **DUT** | IN  pkt #823 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281745 | yapp monitor | RX pkt #823 on the input: addr=3 len=2 parity=bad gap=11 |
| 281745 | reference | Packet dropped: illegal address 3 (len=2) |
| 281745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281795 | **DUT** | IN  pkt #824 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 281825 | **DUT** | IN  pkt #824 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 281825 | yapp monitor | RX pkt #824 on the input: addr=3 len=2 parity=bad gap=4 |
| 281825 | reference | Packet dropped: illegal address 3 (len=2) |
| 281825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 281850 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 281860 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 282035 | **DUT** | IN  pkt #825 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282065 | **DUT** | IN  pkt #825 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282065 | yapp monitor | RX pkt #825 on the input: addr=3 len=2 parity=bad gap=20 |
| 282065 | reference | Packet dropped: illegal address 3 (len=2) |
| 282065 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282165 | **DUT** | IN  pkt #826 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282170 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 282195 | **DUT** | IN  pkt #826 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282195 | yapp monitor | RX pkt #826 on the input: addr=3 len=2 parity=bad gap=9 |
| 282195 | reference | Packet dropped: illegal address 3 (len=2) |
| 282195 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282270 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 282295 | **DUT** | IN  pkt #827 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282325 | **DUT** | IN  pkt #827 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282325 | yapp monitor | RX pkt #827 on the input: addr=3 len=2 parity=bad gap=9 |
| 282325 | reference | Packet dropped: illegal address 3 (len=2) |
| 282325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282370 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 282535 | **DUT** | IN  pkt #828 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282565 | **DUT** | IN  pkt #828 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282565 | yapp monitor | RX pkt #828 on the input: addr=3 len=2 parity=bad gap=20 |
| 282565 | reference | Packet dropped: illegal address 3 (len=2) |
| 282565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282590 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 282765 | **DUT** | IN  pkt #829 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282795 | **DUT** | IN  pkt #829 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282795 | yapp monitor | RX pkt #829 on the input: addr=3 len=2 parity=bad gap=19 |
| 282795 | reference | Packet dropped: illegal address 3 (len=2) |
| 282795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282830 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 282915 | **DUT** | IN  pkt #830 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 282945 | **DUT** | IN  pkt #830 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 282945 | yapp monitor | RX pkt #830 on the input: addr=3 len=2 parity=bad gap=11 |
| 282945 | reference | Packet dropped: illegal address 3 (len=2) |
| 282945 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 282970 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 283085 | **DUT** | IN  pkt #831 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283115 | **DUT** | IN  pkt #831 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283115 | yapp monitor | RX pkt #831 on the input: addr=3 len=2 parity=bad gap=13 |
| 283115 | reference | Packet dropped: illegal address 3 (len=2) |
| 283115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283150 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 283265 | **DUT** | IN  pkt #832 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283295 | **DUT** | IN  pkt #832 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283295 | yapp monitor | RX pkt #832 on the input: addr=3 len=2 parity=bad gap=14 |
| 283295 | reference | Packet dropped: illegal address 3 (len=2) |
| 283295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283350 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 283475 | **DUT** | IN  pkt #833 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283505 | **DUT** | IN  pkt #833 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283505 | yapp monitor | RX pkt #833 on the input: addr=3 len=2 parity=bad gap=17 |
| 283505 | reference | Packet dropped: illegal address 3 (len=2) |
| 283505 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283545 | **DUT** | IN  pkt #834 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283575 | **DUT** | IN  pkt #834 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283575 | yapp monitor | RX pkt #834 on the input: addr=3 len=2 parity=bad gap=3 |
| 283575 | reference | Packet dropped: illegal address 3 (len=2) |
| 283575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283590 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 283610 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 283675 | **DUT** | IN  pkt #835 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283705 | **DUT** | IN  pkt #835 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283705 | yapp monitor | RX pkt #835 on the input: addr=3 len=2 parity=bad gap=9 |
| 283705 | reference | Packet dropped: illegal address 3 (len=2) |
| 283705 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283750 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 283855 | **DUT** | IN  pkt #836 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 283885 | **DUT** | IN  pkt #836 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 283885 | yapp monitor | RX pkt #836 on the input: addr=3 len=2 parity=bad gap=14 |
| 283885 | reference | Packet dropped: illegal address 3 (len=2) |
| 283885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 283950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 284095 | **DUT** | IN  pkt #837 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284125 | **DUT** | IN  pkt #837 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284125 | yapp monitor | RX pkt #837 on the input: addr=3 len=2 parity=bad gap=20 |
| 284125 | reference | Packet dropped: illegal address 3 (len=2) |
| 284125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284210 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 284305 | **DUT** | IN  pkt #838 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284335 | **DUT** | IN  pkt #838 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284335 | yapp monitor | RX pkt #838 on the input: addr=3 len=2 parity=bad gap=17 |
| 284335 | reference | Packet dropped: illegal address 3 (len=2) |
| 284335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 284455 | **DUT** | IN  pkt #839 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284485 | **DUT** | IN  pkt #839 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284485 | yapp monitor | RX pkt #839 on the input: addr=3 len=2 parity=bad gap=11 |
| 284485 | reference | Packet dropped: illegal address 3 (len=2) |
| 284485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284510 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 284545 | **DUT** | IN  pkt #840 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284575 | **DUT** | IN  pkt #840 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284575 | yapp monitor | RX pkt #840 on the input: addr=3 len=2 parity=bad gap=5 |
| 284575 | reference | Packet dropped: illegal address 3 (len=2) |
| 284575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 284745 | **DUT** | IN  pkt #841 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 284775 | **DUT** | IN  pkt #841 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 284775 | yapp monitor | RX pkt #841 on the input: addr=3 len=2 parity=bad gap=16 |
| 284775 | reference | Packet dropped: illegal address 3 (len=2) |
| 284775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 284870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 284975 | **DUT** | IN  pkt #842 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285005 | **DUT** | IN  pkt #842 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285005 | yapp monitor | RX pkt #842 on the input: addr=3 len=2 parity=bad gap=19 |
| 285005 | reference | Packet dropped: illegal address 3 (len=2) |
| 285005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285070 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 285075 | **DUT** | IN  pkt #843 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285105 | **DUT** | IN  pkt #843 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285105 | yapp monitor | RX pkt #843 on the input: addr=3 len=2 parity=bad gap=6 |
| 285105 | reference | Packet dropped: illegal address 3 (len=2) |
| 285105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285210 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 285315 | **DUT** | IN  pkt #844 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285345 | **DUT** | IN  pkt #844 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285345 | yapp monitor | RX pkt #844 on the input: addr=3 len=2 parity=bad gap=20 |
| 285345 | reference | Packet dropped: illegal address 3 (len=2) |
| 285345 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285370 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 285555 | **DUT** | IN  pkt #845 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285585 | **DUT** | IN  pkt #845 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285585 | yapp monitor | RX pkt #845 on the input: addr=3 len=2 parity=bad gap=20 |
| 285585 | reference | Packet dropped: illegal address 3 (len=2) |
| 285585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285615 | **DUT** | IN  pkt #846 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285645 | **DUT** | IN  pkt #846 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285645 | yapp monitor | RX pkt #846 on the input: addr=3 len=2 parity=bad gap=2 |
| 285645 | reference | Packet dropped: illegal address 3 (len=2) |
| 285645 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285690 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 285710 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 285795 | **DUT** | IN  pkt #847 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285825 | **DUT** | IN  pkt #847 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285825 | yapp monitor | RX pkt #847 on the input: addr=3 len=2 parity=bad gap=14 |
| 285825 | reference | Packet dropped: illegal address 3 (len=2) |
| 285825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285845 | **DUT** | IN  pkt #848 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 285850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 285875 | **DUT** | IN  pkt #848 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 285875 | yapp monitor | RX pkt #848 on the input: addr=3 len=2 parity=bad gap=1 |
| 285875 | reference | Packet dropped: illegal address 3 (len=2) |
| 285875 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 285950 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 285985 | **DUT** | IN  pkt #849 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286015 | **DUT** | IN  pkt #849 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286015 | yapp monitor | RX pkt #849 on the input: addr=3 len=2 parity=bad gap=10 |
| 286015 | reference | Packet dropped: illegal address 3 (len=2) |
| 286015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286070 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 286115 | **DUT** | IN  pkt #850 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286145 | **DUT** | IN  pkt #850 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286145 | yapp monitor | RX pkt #850 on the input: addr=3 len=2 parity=bad gap=9 |
| 286145 | reference | Packet dropped: illegal address 3 (len=2) |
| 286145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 286355 | **DUT** | IN  pkt #851 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286385 | **DUT** | IN  pkt #851 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286385 | yapp monitor | RX pkt #851 on the input: addr=3 len=2 parity=bad gap=20 |
| 286385 | reference | Packet dropped: illegal address 3 (len=2) |
| 286385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 286585 | **DUT** | IN  pkt #852 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286615 | **DUT** | IN  pkt #852 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286615 | yapp monitor | RX pkt #852 on the input: addr=3 len=2 parity=bad gap=19 |
| 286615 | reference | Packet dropped: illegal address 3 (len=2) |
| 286615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286630 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 286745 | **DUT** | IN  pkt #853 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 286775 | **DUT** | IN  pkt #853 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 286775 | yapp monitor | RX pkt #853 on the input: addr=3 len=2 parity=bad gap=12 |
| 286775 | reference | Packet dropped: illegal address 3 (len=2) |
| 286775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 286790 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 286975 | **DUT** | IN  pkt #854 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287005 | **DUT** | IN  pkt #854 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287005 | yapp monitor | RX pkt #854 on the input: addr=3 len=2 parity=bad gap=19 |
| 287005 | reference | Packet dropped: illegal address 3 (len=2) |
| 287005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 287165 | **DUT** | IN  pkt #855 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287195 | **DUT** | IN  pkt #855 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287195 | yapp monitor | RX pkt #855 on the input: addr=3 len=2 parity=bad gap=15 |
| 287195 | reference | Packet dropped: illegal address 3 (len=2) |
| 287195 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287210 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 287285 | **DUT** | IN  pkt #856 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287315 | **DUT** | IN  pkt #856 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287315 | yapp monitor | RX pkt #856 on the input: addr=3 len=2 parity=bad gap=8 |
| 287315 | reference | Packet dropped: illegal address 3 (len=2) |
| 287315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287390 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 287485 | **DUT** | IN  pkt #857 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287515 | **DUT** | IN  pkt #857 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287515 | yapp monitor | RX pkt #857 on the input: addr=3 len=2 parity=bad gap=16 |
| 287515 | reference | Packet dropped: illegal address 3 (len=2) |
| 287515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287530 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 287695 | **DUT** | IN  pkt #858 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287725 | **DUT** | IN  pkt #858 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287725 | yapp monitor | RX pkt #858 on the input: addr=3 len=2 parity=bad gap=17 |
| 287725 | reference | Packet dropped: illegal address 3 (len=2) |
| 287725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287745 | **DUT** | IN  pkt #859 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287775 | **DUT** | IN  pkt #859 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287775 | yapp monitor | RX pkt #859 on the input: addr=3 len=2 parity=bad gap=1 |
| 287775 | reference | Packet dropped: illegal address 3 (len=2) |
| 287775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287790 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 287830 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 287905 | **DUT** | IN  pkt #860 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 287935 | **DUT** | IN  pkt #860 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 287935 | yapp monitor | RX pkt #860 on the input: addr=3 len=2 parity=bad gap=12 |
| 287935 | reference | Packet dropped: illegal address 3 (len=2) |
| 287935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 287990 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 288145 | **DUT** | IN  pkt #861 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288175 | **DUT** | IN  pkt #861 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288175 | yapp monitor | RX pkt #861 on the input: addr=3 len=2 parity=bad gap=20 |
| 288175 | reference | Packet dropped: illegal address 3 (len=2) |
| 288175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288210 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 288365 | **DUT** | IN  pkt #862 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288395 | **DUT** | IN  pkt #862 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288395 | yapp monitor | RX pkt #862 on the input: addr=3 len=2 parity=bad gap=18 |
| 288395 | reference | Packet dropped: illegal address 3 (len=2) |
| 288395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 288535 | **DUT** | IN  pkt #863 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288565 | **DUT** | IN  pkt #863 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288565 | yapp monitor | RX pkt #863 on the input: addr=3 len=2 parity=bad gap=13 |
| 288565 | reference | Packet dropped: illegal address 3 (len=2) |
| 288565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 288745 | **DUT** | IN  pkt #864 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 288775 | **DUT** | IN  pkt #864 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 288775 | yapp monitor | RX pkt #864 on the input: addr=3 len=2 parity=bad gap=17 |
| 288775 | reference | Packet dropped: illegal address 3 (len=2) |
| 288775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 288870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 288985 | **DUT** | IN  pkt #865 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289015 | **DUT** | IN  pkt #865 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289015 | yapp monitor | RX pkt #865 on the input: addr=3 len=2 parity=bad gap=20 |
| 289015 | reference | Packet dropped: illegal address 3 (len=2) |
| 289015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289030 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 289225 | **DUT** | IN  pkt #866 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289255 | **DUT** | IN  pkt #866 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289255 | yapp monitor | RX pkt #866 on the input: addr=3 len=2 parity=bad gap=20 |
| 289255 | reference | Packet dropped: illegal address 3 (len=2) |
| 289255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289295 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 289325 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 289350 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 289355 | hbus monitor | Collected READ  addr=0x1006 data=0x64 |
| 289385 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 289415 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 289445 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 289585 | **DUT** | IN  pkt #867 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289615 | **DUT** | IN  pkt #867 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289615 | yapp monitor | RX pkt #867 on the input: addr=3 len=2 parity=bad gap=32 |
| 289615 | reference | Packet dropped: illegal address 3 (len=2) |
| 289615 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289650 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 289805 | **DUT** | IN  pkt #868 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289835 | **DUT** | IN  pkt #868 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289835 | yapp monitor | RX pkt #868 on the input: addr=3 len=2 parity=bad gap=18 |
| 289835 | reference | Packet dropped: illegal address 3 (len=2) |
| 289835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 289870 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 289925 | **DUT** | IN  pkt #869 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 289955 | **DUT** | IN  pkt #869 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 289955 | yapp monitor | RX pkt #869 on the input: addr=3 len=2 parity=bad gap=8 |
| 289955 | reference | Packet dropped: illegal address 3 (len=2) |
| 289955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290005 | **DUT** | IN  pkt #870 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290010 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 290035 | **DUT** | IN  pkt #870 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290035 | yapp monitor | RX pkt #870 on the input: addr=3 len=2 parity=bad gap=4 |
| 290035 | reference | Packet dropped: illegal address 3 (len=2) |
| 290035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 290215 | **DUT** | IN  pkt #871 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290245 | **DUT** | IN  pkt #871 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290245 | yapp monitor | RX pkt #871 on the input: addr=3 len=2 parity=bad gap=17 |
| 290245 | reference | Packet dropped: illegal address 3 (len=2) |
| 290245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290270 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 290355 | **DUT** | IN  pkt #872 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290385 | **DUT** | IN  pkt #872 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290385 | yapp monitor | RX pkt #872 on the input: addr=3 len=2 parity=bad gap=10 |
| 290385 | reference | Packet dropped: illegal address 3 (len=2) |
| 290385 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290490 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 290555 | **DUT** | IN  pkt #873 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290585 | **DUT** | IN  pkt #873 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290585 | yapp monitor | RX pkt #873 on the input: addr=3 len=2 parity=bad gap=16 |
| 290585 | reference | Packet dropped: illegal address 3 (len=2) |
| 290585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290605 | **DUT** | IN  pkt #874 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290630 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 290635 | **DUT** | IN  pkt #874 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290635 | yapp monitor | RX pkt #874 on the input: addr=3 len=2 parity=bad gap=1 |
| 290635 | reference | Packet dropped: illegal address 3 (len=2) |
| 290635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290670 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 290845 | **DUT** | IN  pkt #875 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 290875 | **DUT** | IN  pkt #875 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 290875 | yapp monitor | RX pkt #875 on the input: addr=3 len=2 parity=bad gap=20 |
| 290875 | reference | Packet dropped: illegal address 3 (len=2) |
| 290875 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 290890 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 291005 | **DUT** | IN  pkt #876 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291035 | **DUT** | IN  pkt #876 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291035 | yapp monitor | RX pkt #876 on the input: addr=3 len=2 parity=bad gap=12 |
| 291035 | reference | Packet dropped: illegal address 3 (len=2) |
| 291035 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291050 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 291225 | **DUT** | IN  pkt #877 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291255 | **DUT** | IN  pkt #877 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291255 | yapp monitor | RX pkt #877 on the input: addr=3 len=2 parity=bad gap=18 |
| 291255 | reference | Packet dropped: illegal address 3 (len=2) |
| 291255 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291270 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 291435 | **DUT** | IN  pkt #878 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291465 | **DUT** | IN  pkt #878 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291465 | yapp monitor | RX pkt #878 on the input: addr=3 len=2 parity=bad gap=17 |
| 291465 | reference | Packet dropped: illegal address 3 (len=2) |
| 291465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 291605 | **DUT** | IN  pkt #879 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291635 | **DUT** | IN  pkt #879 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291635 | yapp monitor | RX pkt #879 on the input: addr=3 len=2 parity=bad gap=13 |
| 291635 | reference | Packet dropped: illegal address 3 (len=2) |
| 291635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291710 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 291725 | **DUT** | IN  pkt #880 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291755 | **DUT** | IN  pkt #880 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291755 | yapp monitor | RX pkt #880 on the input: addr=3 len=2 parity=bad gap=8 |
| 291755 | reference | Packet dropped: illegal address 3 (len=2) |
| 291755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291790 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 291855 | **DUT** | IN  pkt #881 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 291885 | **DUT** | IN  pkt #881 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 291885 | yapp monitor | RX pkt #881 on the input: addr=3 len=2 parity=bad gap=9 |
| 291885 | reference | Packet dropped: illegal address 3 (len=2) |
| 291885 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 291950 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 292085 | **DUT** | IN  pkt #882 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292115 | **DUT** | IN  pkt #882 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292115 | yapp monitor | RX pkt #882 on the input: addr=3 len=2 parity=bad gap=19 |
| 292115 | reference | Packet dropped: illegal address 3 (len=2) |
| 292115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292190 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 292315 | **DUT** | IN  pkt #883 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292345 | **DUT** | IN  pkt #883 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292345 | yapp monitor | RX pkt #883 on the input: addr=3 len=2 parity=bad gap=19 |
| 292345 | reference | Packet dropped: illegal address 3 (len=2) |
| 292345 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292390 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 292535 | **DUT** | IN  pkt #884 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292565 | **DUT** | IN  pkt #884 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292565 | yapp monitor | RX pkt #884 on the input: addr=3 len=2 parity=bad gap=18 |
| 292565 | reference | Packet dropped: illegal address 3 (len=2) |
| 292565 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292610 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 292765 | **DUT** | IN  pkt #885 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292795 | **DUT** | IN  pkt #885 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292795 | yapp monitor | RX pkt #885 on the input: addr=3 len=2 parity=bad gap=19 |
| 292795 | reference | Packet dropped: illegal address 3 (len=2) |
| 292795 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 292810 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 292895 | **DUT** | IN  pkt #886 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 292925 | **DUT** | IN  pkt #886 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 292925 | yapp monitor | RX pkt #886 on the input: addr=3 len=2 parity=bad gap=9 |
| 292925 | reference | Packet dropped: illegal address 3 (len=2) |
| 292925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 293135 | **DUT** | IN  pkt #887 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293165 | **DUT** | IN  pkt #887 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293165 | yapp monitor | RX pkt #887 on the input: addr=3 len=2 parity=bad gap=20 |
| 293165 | reference | Packet dropped: illegal address 3 (len=2) |
| 293165 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293230 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 293375 | **DUT** | IN  pkt #888 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293405 | **DUT** | IN  pkt #888 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293405 | yapp monitor | RX pkt #888 on the input: addr=3 len=2 parity=bad gap=20 |
| 293405 | reference | Packet dropped: illegal address 3 (len=2) |
| 293405 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293490 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 293595 | **DUT** | IN  pkt #889 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293625 | **DUT** | IN  pkt #889 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293625 | yapp monitor | RX pkt #889 on the input: addr=3 len=2 parity=bad gap=18 |
| 293625 | reference | Packet dropped: illegal address 3 (len=2) |
| 293625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293645 | **DUT** | IN  pkt #890 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 293675 | **DUT** | IN  pkt #890 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293675 | yapp monitor | RX pkt #890 on the input: addr=3 len=2 parity=bad gap=1 |
| 293675 | reference | Packet dropped: illegal address 3 (len=2) |
| 293675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 293710 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 293875 | **DUT** | IN  pkt #891 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 293905 | **DUT** | IN  pkt #891 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 293905 | yapp monitor | RX pkt #891 on the input: addr=3 len=2 parity=bad gap=19 |
| 293905 | reference | Packet dropped: illegal address 3 (len=2) |
| 293905 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294010 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 294115 | **DUT** | IN  pkt #892 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294145 | **DUT** | IN  pkt #892 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294145 | yapp monitor | RX pkt #892 on the input: addr=3 len=2 parity=bad gap=20 |
| 294145 | reference | Packet dropped: illegal address 3 (len=2) |
| 294145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294170 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 294205 | **DUT** | IN  pkt #893 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294235 | **DUT** | IN  pkt #893 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294235 | yapp monitor | RX pkt #893 on the input: addr=3 len=2 parity=bad gap=5 |
| 294235 | reference | Packet dropped: illegal address 3 (len=2) |
| 294235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 294445 | **DUT** | IN  pkt #894 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294475 | **DUT** | IN  pkt #894 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294475 | yapp monitor | RX pkt #894 on the input: addr=3 len=2 parity=bad gap=20 |
| 294475 | reference | Packet dropped: illegal address 3 (len=2) |
| 294475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 294575 | **DUT** | IN  pkt #895 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294605 | **DUT** | IN  pkt #895 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294605 | yapp monitor | RX pkt #895 on the input: addr=3 len=2 parity=bad gap=9 |
| 294605 | reference | Packet dropped: illegal address 3 (len=2) |
| 294605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294670 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 294755 | **DUT** | IN  pkt #896 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294785 | **DUT** | IN  pkt #896 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294785 | yapp monitor | RX pkt #896 on the input: addr=3 len=2 parity=bad gap=14 |
| 294785 | reference | Packet dropped: illegal address 3 (len=2) |
| 294785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 294925 | **DUT** | IN  pkt #897 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294955 | **DUT** | IN  pkt #897 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 294955 | yapp monitor | RX pkt #897 on the input: addr=3 len=2 parity=bad gap=13 |
| 294955 | reference | Packet dropped: illegal address 3 (len=2) |
| 294955 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 294975 | **DUT** | IN  pkt #898 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 294990 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 295005 | **DUT** | IN  pkt #898 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295005 | yapp monitor | RX pkt #898 on the input: addr=3 len=2 parity=bad gap=1 |
| 295005 | reference | Packet dropped: illegal address 3 (len=2) |
| 295005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295090 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 295195 | **DUT** | IN  pkt #899 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295225 | **DUT** | IN  pkt #899 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295225 | yapp monitor | RX pkt #899 on the input: addr=3 len=2 parity=bad gap=18 |
| 295225 | reference | Packet dropped: illegal address 3 (len=2) |
| 295225 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295270 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 295435 | **DUT** | IN  pkt #900 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295465 | **DUT** | IN  pkt #900 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295465 | yapp monitor | RX pkt #900 on the input: addr=3 len=2 parity=bad gap=20 |
| 295465 | reference | Packet dropped: illegal address 3 (len=2) |
| 295465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 295625 | **DUT** | IN  pkt #901 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295655 | **DUT** | IN  pkt #901 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295655 | yapp monitor | RX pkt #901 on the input: addr=3 len=2 parity=bad gap=15 |
| 295655 | reference | Packet dropped: illegal address 3 (len=2) |
| 295655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 295865 | **DUT** | IN  pkt #902 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 295895 | **DUT** | IN  pkt #902 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 295895 | yapp monitor | RX pkt #902 on the input: addr=3 len=2 parity=bad gap=20 |
| 295895 | reference | Packet dropped: illegal address 3 (len=2) |
| 295895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 295910 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 296065 | **DUT** | IN  pkt #903 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296095 | **DUT** | IN  pkt #903 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296095 | yapp monitor | RX pkt #903 on the input: addr=3 len=2 parity=bad gap=16 |
| 296095 | reference | Packet dropped: illegal address 3 (len=2) |
| 296095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 296305 | **DUT** | IN  pkt #904 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296335 | **DUT** | IN  pkt #904 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296335 | yapp monitor | RX pkt #904 on the input: addr=3 len=2 parity=bad gap=20 |
| 296335 | reference | Packet dropped: illegal address 3 (len=2) |
| 296335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 296395 | **DUT** | IN  pkt #905 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296425 | **DUT** | IN  pkt #905 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296425 | yapp monitor | RX pkt #905 on the input: addr=3 len=2 parity=bad gap=5 |
| 296425 | reference | Packet dropped: illegal address 3 (len=2) |
| 296425 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296490 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 296625 | **DUT** | IN  pkt #906 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296655 | **DUT** | IN  pkt #906 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296655 | yapp monitor | RX pkt #906 on the input: addr=3 len=2 parity=bad gap=19 |
| 296655 | reference | Packet dropped: illegal address 3 (len=2) |
| 296655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296690 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 296865 | **DUT** | IN  pkt #907 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 296895 | **DUT** | IN  pkt #907 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 296895 | yapp monitor | RX pkt #907 on the input: addr=3 len=2 parity=bad gap=20 |
| 296895 | reference | Packet dropped: illegal address 3 (len=2) |
| 296895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 296950 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 297065 | **DUT** | IN  pkt #908 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297095 | **DUT** | IN  pkt #908 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297095 | yapp monitor | RX pkt #908 on the input: addr=3 len=2 parity=bad gap=16 |
| 297095 | reference | Packet dropped: illegal address 3 (len=2) |
| 297095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297190 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 297295 | **DUT** | IN  pkt #909 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297325 | **DUT** | IN  pkt #909 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297325 | yapp monitor | RX pkt #909 on the input: addr=3 len=2 parity=bad gap=19 |
| 297325 | reference | Packet dropped: illegal address 3 (len=2) |
| 297325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 297455 | **DUT** | IN  pkt #910 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297485 | **DUT** | IN  pkt #910 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297485 | yapp monitor | RX pkt #910 on the input: addr=3 len=2 parity=bad gap=12 |
| 297485 | reference | Packet dropped: illegal address 3 (len=2) |
| 297485 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297550 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 297655 | **DUT** | IN  pkt #911 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297685 | **DUT** | IN  pkt #911 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297685 | yapp monitor | RX pkt #911 on the input: addr=3 len=2 parity=bad gap=16 |
| 297685 | reference | Packet dropped: illegal address 3 (len=2) |
| 297685 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297730 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 297775 | **DUT** | IN  pkt #912 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 297805 | **DUT** | IN  pkt #912 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 297805 | yapp monitor | RX pkt #912 on the input: addr=3 len=2 parity=bad gap=8 |
| 297805 | reference | Packet dropped: illegal address 3 (len=2) |
| 297805 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 297870 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 298015 | **DUT** | IN  pkt #913 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298045 | **DUT** | IN  pkt #913 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298045 | yapp monitor | RX pkt #913 on the input: addr=3 len=2 parity=bad gap=20 |
| 298045 | reference | Packet dropped: illegal address 3 (len=2) |
| 298045 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298130 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 298255 | **DUT** | IN  pkt #914 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298285 | **DUT** | IN  pkt #914 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298285 | yapp monitor | RX pkt #914 on the input: addr=3 len=2 parity=bad gap=20 |
| 298285 | reference | Packet dropped: illegal address 3 (len=2) |
| 298285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298305 | **DUT** | IN  pkt #915 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298335 | **DUT** | IN  pkt #915 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298335 | yapp monitor | RX pkt #915 on the input: addr=3 len=2 parity=bad gap=1 |
| 298335 | reference | Packet dropped: illegal address 3 (len=2) |
| 298335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298350 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 298390 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 298495 | **DUT** | IN  pkt #916 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298525 | **DUT** | IN  pkt #916 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298525 | yapp monitor | RX pkt #916 on the input: addr=3 len=2 parity=bad gap=15 |
| 298525 | reference | Packet dropped: illegal address 3 (len=2) |
| 298525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298610 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 298715 | **DUT** | IN  pkt #917 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298745 | **DUT** | IN  pkt #917 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298745 | yapp monitor | RX pkt #917 on the input: addr=3 len=2 parity=bad gap=18 |
| 298745 | reference | Packet dropped: illegal address 3 (len=2) |
| 298745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298790 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 298805 | **DUT** | IN  pkt #918 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298835 | **DUT** | IN  pkt #918 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298835 | yapp monitor | RX pkt #918 on the input: addr=3 len=2 parity=bad gap=5 |
| 298835 | reference | Packet dropped: illegal address 3 (len=2) |
| 298835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 298910 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 298965 | **DUT** | IN  pkt #919 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 298995 | **DUT** | IN  pkt #919 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 298995 | yapp monitor | RX pkt #919 on the input: addr=3 len=2 parity=bad gap=12 |
| 298995 | reference | Packet dropped: illegal address 3 (len=2) |
| 298995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 299205 | **DUT** | IN  pkt #920 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299235 | **DUT** | IN  pkt #920 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299235 | yapp monitor | RX pkt #920 on the input: addr=3 len=2 parity=bad gap=20 |
| 299235 | reference | Packet dropped: illegal address 3 (len=2) |
| 299235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299290 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 299445 | **DUT** | IN  pkt #921 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299475 | **DUT** | IN  pkt #921 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299475 | yapp monitor | RX pkt #921 on the input: addr=3 len=2 parity=bad gap=20 |
| 299475 | reference | Packet dropped: illegal address 3 (len=2) |
| 299475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299550 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 299665 | **DUT** | IN  pkt #922 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299695 | **DUT** | IN  pkt #922 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299695 | yapp monitor | RX pkt #922 on the input: addr=3 len=2 parity=bad gap=18 |
| 299695 | reference | Packet dropped: illegal address 3 (len=2) |
| 299695 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 299905 | **DUT** | IN  pkt #923 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 299935 | **DUT** | IN  pkt #923 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 299935 | yapp monitor | RX pkt #923 on the input: addr=3 len=2 parity=bad gap=20 |
| 299935 | reference | Packet dropped: illegal address 3 (len=2) |
| 299935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 299990 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 300055 | **DUT** | IN  pkt #924 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300085 | **DUT** | IN  pkt #924 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300085 | yapp monitor | RX pkt #924 on the input: addr=3 len=2 parity=bad gap=11 |
| 300085 | reference | Packet dropped: illegal address 3 (len=2) |
| 300085 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300130 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 300275 | **DUT** | IN  pkt #925 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300305 | **DUT** | IN  pkt #925 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300305 | yapp monitor | RX pkt #925 on the input: addr=3 len=2 parity=bad gap=18 |
| 300305 | reference | Packet dropped: illegal address 3 (len=2) |
| 300305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300365 | **DUT** | IN  pkt #926 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300395 | **DUT** | IN  pkt #926 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300395 | yapp monitor | RX pkt #926 on the input: addr=3 len=2 parity=bad gap=5 |
| 300395 | reference | Packet dropped: illegal address 3 (len=2) |
| 300395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300410 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 300430 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 300605 | **DUT** | IN  pkt #927 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300635 | **DUT** | IN  pkt #927 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300635 | yapp monitor | RX pkt #927 on the input: addr=3 len=2 parity=bad gap=20 |
| 300635 | reference | Packet dropped: illegal address 3 (len=2) |
| 300635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300650 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 300805 | **DUT** | IN  pkt #928 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 300835 | **DUT** | IN  pkt #928 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 300835 | yapp monitor | RX pkt #928 on the input: addr=3 len=2 parity=bad gap=16 |
| 300835 | reference | Packet dropped: illegal address 3 (len=2) |
| 300835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 300890 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 301045 | **DUT** | IN  pkt #929 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301075 | **DUT** | IN  pkt #929 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301075 | yapp monitor | RX pkt #929 on the input: addr=3 len=2 parity=bad gap=20 |
| 301075 | reference | Packet dropped: illegal address 3 (len=2) |
| 301075 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301150 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 301215 | **DUT** | IN  pkt #930 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301245 | **DUT** | IN  pkt #930 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301245 | yapp monitor | RX pkt #930 on the input: addr=3 len=2 parity=bad gap=13 |
| 301245 | reference | Packet dropped: illegal address 3 (len=2) |
| 301245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301295 | **DUT** | IN  pkt #931 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301325 | **DUT** | IN  pkt #931 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301325 | yapp monitor | RX pkt #931 on the input: addr=3 len=2 parity=bad gap=4 |
| 301325 | reference | Packet dropped: illegal address 3 (len=2) |
| 301325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301330 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 301390 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 301515 | **DUT** | IN  pkt #932 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301545 | **DUT** | IN  pkt #932 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301545 | yapp monitor | RX pkt #932 on the input: addr=3 len=2 parity=bad gap=18 |
| 301545 | reference | Packet dropped: illegal address 3 (len=2) |
| 301545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 301695 | **DUT** | IN  pkt #933 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301725 | **DUT** | IN  pkt #933 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301725 | yapp monitor | RX pkt #933 on the input: addr=3 len=2 parity=bad gap=14 |
| 301725 | reference | Packet dropped: illegal address 3 (len=2) |
| 301725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 301810 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 301935 | **DUT** | IN  pkt #934 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 301965 | **DUT** | IN  pkt #934 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 301965 | yapp monitor | RX pkt #934 on the input: addr=3 len=2 parity=bad gap=20 |
| 301965 | reference | Packet dropped: illegal address 3 (len=2) |
| 301965 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302030 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 302085 | **DUT** | IN  pkt #935 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302115 | **DUT** | IN  pkt #935 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302115 | yapp monitor | RX pkt #935 on the input: addr=3 len=2 parity=bad gap=11 |
| 302115 | reference | Packet dropped: illegal address 3 (len=2) |
| 302115 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302170 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 302325 | **DUT** | IN  pkt #936 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302355 | **DUT** | IN  pkt #936 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302355 | yapp monitor | RX pkt #936 on the input: addr=3 len=2 parity=bad gap=20 |
| 302355 | reference | Packet dropped: illegal address 3 (len=2) |
| 302355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 302485 | **DUT** | IN  pkt #937 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302515 | **DUT** | IN  pkt #937 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302515 | yapp monitor | RX pkt #937 on the input: addr=3 len=2 parity=bad gap=12 |
| 302515 | reference | Packet dropped: illegal address 3 (len=2) |
| 302515 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302590 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 302645 | **DUT** | IN  pkt #938 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302675 | **DUT** | IN  pkt #938 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302675 | yapp monitor | RX pkt #938 on the input: addr=3 len=2 parity=bad gap=12 |
| 302675 | reference | Packet dropped: illegal address 3 (len=2) |
| 302675 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302750 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 302885 | **DUT** | IN  pkt #939 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302915 | **DUT** | IN  pkt #939 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302915 | yapp monitor | RX pkt #939 on the input: addr=3 len=2 parity=bad gap=20 |
| 302915 | reference | Packet dropped: illegal address 3 (len=2) |
| 302915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 302965 | **DUT** | IN  pkt #940 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 302970 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 302995 | **DUT** | IN  pkt #940 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 302995 | yapp monitor | RX pkt #940 on the input: addr=3 len=2 parity=bad gap=4 |
| 302995 | reference | Packet dropped: illegal address 3 (len=2) |
| 302995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303070 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 303145 | **DUT** | IN  pkt #941 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303175 | **DUT** | IN  pkt #941 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303175 | yapp monitor | RX pkt #941 on the input: addr=3 len=2 parity=bad gap=14 |
| 303175 | reference | Packet dropped: illegal address 3 (len=2) |
| 303175 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303270 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 303375 | **DUT** | IN  pkt #942 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303405 | **DUT** | IN  pkt #942 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303405 | yapp monitor | RX pkt #942 on the input: addr=3 len=2 parity=bad gap=19 |
| 303405 | reference | Packet dropped: illegal address 3 (len=2) |
| 303405 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303435 | **DUT** | IN  pkt #943 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303465 | **DUT** | IN  pkt #943 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303465 | yapp monitor | RX pkt #943 on the input: addr=3 len=2 parity=bad gap=2 |
| 303465 | reference | Packet dropped: illegal address 3 (len=2) |
| 303465 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303470 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 303530 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 303665 | **DUT** | IN  pkt #944 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303695 | **DUT** | IN  pkt #944 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303695 | yapp monitor | RX pkt #944 on the input: addr=3 len=2 parity=bad gap=19 |
| 303695 | reference | Packet dropped: illegal address 3 (len=2) |
| 303695 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303730 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 303905 | **DUT** | IN  pkt #945 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 303935 | **DUT** | IN  pkt #945 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 303935 | yapp monitor | RX pkt #945 on the input: addr=3 len=2 parity=bad gap=20 |
| 303935 | reference | Packet dropped: illegal address 3 (len=2) |
| 303935 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 303990 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 304105 | **DUT** | IN  pkt #946 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304135 | **DUT** | IN  pkt #946 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304135 | yapp monitor | RX pkt #946 on the input: addr=3 len=2 parity=bad gap=16 |
| 304135 | reference | Packet dropped: illegal address 3 (len=2) |
| 304135 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304230 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 304305 | **DUT** | IN  pkt #947 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304335 | **DUT** | IN  pkt #947 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304335 | yapp monitor | RX pkt #947 on the input: addr=3 len=2 parity=bad gap=16 |
| 304335 | reference | Packet dropped: illegal address 3 (len=2) |
| 304335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304370 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 304505 | **DUT** | IN  pkt #948 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304535 | **DUT** | IN  pkt #948 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304535 | yapp monitor | RX pkt #948 on the input: addr=3 len=2 parity=bad gap=16 |
| 304535 | reference | Packet dropped: illegal address 3 (len=2) |
| 304535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 304575 | **DUT** | IN  pkt #949 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304605 | **DUT** | IN  pkt #949 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304605 | yapp monitor | RX pkt #949 on the input: addr=3 len=2 parity=bad gap=3 |
| 304605 | reference | Packet dropped: illegal address 3 (len=2) |
| 304605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304690 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 304695 | **DUT** | IN  pkt #950 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304725 | **DUT** | IN  pkt #950 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304725 | yapp monitor | RX pkt #950 on the input: addr=3 len=2 parity=bad gap=8 |
| 304725 | reference | Packet dropped: illegal address 3 (len=2) |
| 304725 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 304770 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 304895 | **DUT** | IN  pkt #951 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 304925 | **DUT** | IN  pkt #951 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 304925 | yapp monitor | RX pkt #951 on the input: addr=3 len=2 parity=bad gap=16 |
| 304925 | reference | Packet dropped: illegal address 3 (len=2) |
| 304925 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305010 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 305095 | **DUT** | IN  pkt #952 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305125 | **DUT** | IN  pkt #952 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305125 | yapp monitor | RX pkt #952 on the input: addr=3 len=2 parity=bad gap=16 |
| 305125 | reference | Packet dropped: illegal address 3 (len=2) |
| 305125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305285 | **DUT** | IN  pkt #953 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305315 | **DUT** | IN  pkt #953 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305315 | yapp monitor | RX pkt #953 on the input: addr=3 len=2 parity=bad gap=15 |
| 305315 | reference | Packet dropped: illegal address 3 (len=2) |
| 305315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305370 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 305515 | **DUT** | IN  pkt #954 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305545 | **DUT** | IN  pkt #954 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305545 | yapp monitor | RX pkt #954 on the input: addr=3 len=2 parity=bad gap=19 |
| 305545 | reference | Packet dropped: illegal address 3 (len=2) |
| 305545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305575 | **DUT** | IN  pkt #955 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305605 | **DUT** | IN  pkt #955 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305605 | yapp monitor | RX pkt #955 on the input: addr=3 len=2 parity=bad gap=2 |
| 305605 | reference | Packet dropped: illegal address 3 (len=2) |
| 305605 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305610 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet (1 more owed) |
| 305630 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305795 | **DUT** | IN  pkt #956 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305825 | **DUT** | IN  pkt #956 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305825 | yapp monitor | RX pkt #956 on the input: addr=3 len=2 parity=bad gap=18 |
| 305825 | reference | Packet dropped: illegal address 3 (len=2) |
| 305825 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305850 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 305945 | **DUT** | IN  pkt #957 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 305975 | **DUT** | IN  pkt #957 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 305975 | yapp monitor | RX pkt #957 on the input: addr=3 len=2 parity=bad gap=11 |
| 305975 | reference | Packet dropped: illegal address 3 (len=2) |
| 305975 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 305990 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 306185 | **DUT** | IN  pkt #958 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306215 | **DUT** | IN  pkt #958 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306215 | yapp monitor | RX pkt #958 on the input: addr=3 len=2 parity=bad gap=20 |
| 306215 | reference | Packet dropped: illegal address 3 (len=2) |
| 306215 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306310 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 306325 | **DUT** | IN  pkt #959 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306355 | **DUT** | IN  pkt #959 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306355 | yapp monitor | RX pkt #959 on the input: addr=3 len=2 parity=bad gap=10 |
| 306355 | reference | Packet dropped: illegal address 3 (len=2) |
| 306355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306430 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 306565 | **DUT** | IN  pkt #960 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306595 | **DUT** | IN  pkt #960 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306595 | yapp monitor | RX pkt #960 on the input: addr=3 len=2 parity=bad gap=20 |
| 306595 | reference | Packet dropped: illegal address 3 (len=2) |
| 306595 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306650 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 306665 | **DUT** | IN  pkt #961 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306695 | **DUT** | IN  pkt #961 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306695 | yapp monitor | RX pkt #961 on the input: addr=3 len=2 parity=bad gap=6 |
| 306695 | reference | Packet dropped: illegal address 3 (len=2) |
| 306695 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306755 | **DUT** | IN  pkt #962 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 306785 | **DUT** | IN  pkt #962 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 306785 | yapp monitor | RX pkt #962 on the input: addr=3 len=2 parity=bad gap=5 |
| 306785 | reference | Packet dropped: illegal address 3 (len=2) |
| 306785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 306790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 306810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 306985 | **DUT** | IN  pkt #963 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307015 | **DUT** | IN  pkt #963 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307015 | yapp monitor | RX pkt #963 on the input: addr=3 len=2 parity=bad gap=19 |
| 307015 | reference | Packet dropped: illegal address 3 (len=2) |
| 307015 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307075 | **DUT** | IN  pkt #964 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307105 | **DUT** | IN  pkt #964 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307105 | yapp monitor | RX pkt #964 on the input: addr=3 len=2 parity=bad gap=5 |
| 307105 | reference | Packet dropped: illegal address 3 (len=2) |
| 307105 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307110 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 307130 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 307295 | **DUT** | IN  pkt #965 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307325 | **DUT** | IN  pkt #965 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307325 | yapp monitor | RX pkt #965 on the input: addr=3 len=2 parity=bad gap=18 |
| 307325 | reference | Packet dropped: illegal address 3 (len=2) |
| 307325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307410 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet |
| 307495 | **DUT** | IN  pkt #966 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307525 | **DUT** | IN  pkt #966 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307525 | yapp monitor | RX pkt #966 on the input: addr=3 len=2 parity=bad gap=16 |
| 307525 | reference | Packet dropped: illegal address 3 (len=2) |
| 307525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307550 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 307735 | **DUT** | IN  pkt #967 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 307765 | **DUT** | IN  pkt #967 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 307765 | yapp monitor | RX pkt #967 on the input: addr=3 len=2 parity=bad gap=20 |
| 307765 | reference | Packet dropped: illegal address 3 (len=2) |
| 307765 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 307810 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 307975 | **DUT** | IN  pkt #968 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308005 | **DUT** | IN  pkt #968 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308005 | yapp monitor | RX pkt #968 on the input: addr=3 len=2 parity=bad gap=20 |
| 308005 | reference | Packet dropped: illegal address 3 (len=2) |
| 308005 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308025 | **DUT** | IN  pkt #969 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308030 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 308055 | **DUT** | IN  pkt #969 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308055 | yapp monitor | RX pkt #969 on the input: addr=3 len=2 parity=bad gap=1 |
| 308055 | reference | Packet dropped: illegal address 3 (len=2) |
| 308055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 308255 | **DUT** | IN  pkt #970 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308285 | **DUT** | IN  pkt #970 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308285 | yapp monitor | RX pkt #970 on the input: addr=3 len=2 parity=bad gap=19 |
| 308285 | reference | Packet dropped: illegal address 3 (len=2) |
| 308285 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308325 | **DUT** | IN  pkt #971 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308355 | **DUT** | IN  pkt #971 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308355 | yapp monitor | RX pkt #971 on the input: addr=3 len=2 parity=bad gap=3 |
| 308355 | reference | Packet dropped: illegal address 3 (len=2) |
| 308355 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308370 | **DUT** | ERROR pulse, 8 cycle(s) after the bad-parity packet (1 more owed) |
| 308410 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 308545 | **DUT** | IN  pkt #972 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308575 | **DUT** | IN  pkt #972 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308575 | yapp monitor | RX pkt #972 on the input: addr=3 len=2 parity=bad gap=18 |
| 308575 | reference | Packet dropped: illegal address 3 (len=2) |
| 308575 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308630 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 308715 | **DUT** | IN  pkt #973 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308745 | **DUT** | IN  pkt #973 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308745 | yapp monitor | RX pkt #973 on the input: addr=3 len=2 parity=bad gap=13 |
| 308745 | reference | Packet dropped: illegal address 3 (len=2) |
| 308745 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 308810 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 308955 | **DUT** | IN  pkt #974 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 308985 | **DUT** | IN  pkt #974 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 308985 | yapp monitor | RX pkt #974 on the input: addr=3 len=2 parity=bad gap=20 |
| 308985 | reference | Packet dropped: illegal address 3 (len=2) |
| 308985 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309030 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309095 | **DUT** | IN  pkt #975 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309125 | **DUT** | IN  pkt #975 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309125 | yapp monitor | RX pkt #975 on the input: addr=3 len=2 parity=bad gap=10 |
| 309125 | reference | Packet dropped: illegal address 3 (len=2) |
| 309125 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309150 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 309155 | **DUT** | IN  pkt #976 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309185 | **DUT** | IN  pkt #976 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309185 | yapp monitor | RX pkt #976 on the input: addr=3 len=2 parity=bad gap=2 |
| 309185 | reference | Packet dropped: illegal address 3 (len=2) |
| 309185 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309210 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 309305 | **DUT** | IN  pkt #977 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309335 | **DUT** | IN  pkt #977 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309335 | yapp monitor | RX pkt #977 on the input: addr=3 len=2 parity=bad gap=11 |
| 309335 | reference | Packet dropped: illegal address 3 (len=2) |
| 309335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309350 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 309495 | **DUT** | IN  pkt #978 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309525 | **DUT** | IN  pkt #978 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309525 | yapp monitor | RX pkt #978 on the input: addr=3 len=2 parity=bad gap=15 |
| 309525 | reference | Packet dropped: illegal address 3 (len=2) |
| 309525 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309570 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309595 | **DUT** | IN  pkt #979 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309625 | **DUT** | IN  pkt #979 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309625 | yapp monitor | RX pkt #979 on the input: addr=3 len=2 parity=bad gap=6 |
| 309625 | reference | Packet dropped: illegal address 3 (len=2) |
| 309625 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309670 | **DUT** | ERROR pulse, 4 cycle(s) after the bad-parity packet |
| 309725 | **DUT** | IN  pkt #980 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309755 | **DUT** | IN  pkt #980 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309755 | yapp monitor | RX pkt #980 on the input: addr=3 len=2 parity=bad gap=9 |
| 309755 | reference | Packet dropped: illegal address 3 (len=2) |
| 309755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 309770 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 309965 | **DUT** | IN  pkt #981 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 309995 | **DUT** | IN  pkt #981 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 309995 | yapp monitor | RX pkt #981 on the input: addr=3 len=2 parity=bad gap=20 |
| 309995 | reference | Packet dropped: illegal address 3 (len=2) |
| 309995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310030 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 310205 | **DUT** | IN  pkt #982 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310235 | **DUT** | IN  pkt #982 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310235 | yapp monitor | RX pkt #982 on the input: addr=3 len=2 parity=bad gap=20 |
| 310235 | reference | Packet dropped: illegal address 3 (len=2) |
| 310235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310250 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 310445 | **DUT** | IN  pkt #983 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310475 | **DUT** | IN  pkt #983 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310475 | yapp monitor | RX pkt #983 on the input: addr=3 len=2 parity=bad gap=20 |
| 310475 | reference | Packet dropped: illegal address 3 (len=2) |
| 310475 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310510 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 310665 | **DUT** | IN  pkt #984 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310695 | **DUT** | IN  pkt #984 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310695 | yapp monitor | RX pkt #984 on the input: addr=3 len=2 parity=bad gap=18 |
| 310695 | reference | Packet dropped: illegal address 3 (len=2) |
| 310695 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310790 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 310885 | **DUT** | IN  pkt #985 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 310915 | **DUT** | IN  pkt #985 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 310915 | yapp monitor | RX pkt #985 on the input: addr=3 len=2 parity=bad gap=18 |
| 310915 | reference | Packet dropped: illegal address 3 (len=2) |
| 310915 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 310970 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 311125 | **DUT** | IN  pkt #986 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311155 | **DUT** | IN  pkt #986 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311155 | yapp monitor | RX pkt #986 on the input: addr=3 len=2 parity=bad gap=20 |
| 311155 | reference | Packet dropped: illegal address 3 (len=2) |
| 311155 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311230 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 311365 | **DUT** | IN  pkt #987 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311395 | **DUT** | IN  pkt #987 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311395 | yapp monitor | RX pkt #987 on the input: addr=3 len=2 parity=bad gap=20 |
| 311395 | reference | Packet dropped: illegal address 3 (len=2) |
| 311395 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311450 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 311555 | **DUT** | IN  pkt #988 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311585 | **DUT** | IN  pkt #988 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311585 | yapp monitor | RX pkt #988 on the input: addr=3 len=2 parity=bad gap=15 |
| 311585 | reference | Packet dropped: illegal address 3 (len=2) |
| 311585 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311610 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 311785 | **DUT** | IN  pkt #989 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 311815 | **DUT** | IN  pkt #989 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 311815 | yapp monitor | RX pkt #989 on the input: addr=3 len=2 parity=bad gap=19 |
| 311815 | reference | Packet dropped: illegal address 3 (len=2) |
| 311815 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 311910 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 312025 | **DUT** | IN  pkt #990 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312055 | **DUT** | IN  pkt #990 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312055 | yapp monitor | RX pkt #990 on the input: addr=3 len=2 parity=bad gap=20 |
| 312055 | reference | Packet dropped: illegal address 3 (len=2) |
| 312055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312070 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 312265 | **DUT** | IN  pkt #991 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312295 | **DUT** | IN  pkt #991 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312295 | yapp monitor | RX pkt #991 on the input: addr=3 len=2 parity=bad gap=20 |
| 312295 | reference | Packet dropped: illegal address 3 (len=2) |
| 312295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312390 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 312505 | **DUT** | IN  pkt #992 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312535 | **DUT** | IN  pkt #992 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312535 | yapp monitor | RX pkt #992 on the input: addr=3 len=2 parity=bad gap=20 |
| 312535 | reference | Packet dropped: illegal address 3 (len=2) |
| 312535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 312725 | **DUT** | IN  pkt #993 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312755 | **DUT** | IN  pkt #993 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312755 | yapp monitor | RX pkt #993 on the input: addr=3 len=2 parity=bad gap=18 |
| 312755 | reference | Packet dropped: illegal address 3 (len=2) |
| 312755 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 312830 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 312965 | **DUT** | IN  pkt #994 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 312995 | **DUT** | IN  pkt #994 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 312995 | yapp monitor | RX pkt #994 on the input: addr=3 len=2 parity=bad gap=20 |
| 312995 | reference | Packet dropped: illegal address 3 (len=2) |
| 312995 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313050 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 313205 | **DUT** | IN  pkt #995 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313235 | **DUT** | IN  pkt #995 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313235 | yapp monitor | RX pkt #995 on the input: addr=3 len=2 parity=bad gap=20 |
| 313235 | reference | Packet dropped: illegal address 3 (len=2) |
| 313235 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313265 | **DUT** | IN  pkt #996 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313295 | **DUT** | IN  pkt #996 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313295 | yapp monitor | RX pkt #996 on the input: addr=3 len=2 parity=bad gap=2 |
| 313295 | reference | Packet dropped: illegal address 3 (len=2) |
| 313295 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313310 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet (1 more owed) |
| 313330 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 313505 | **DUT** | IN  pkt #997 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313535 | **DUT** | IN  pkt #997 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313535 | yapp monitor | RX pkt #997 on the input: addr=3 len=2 parity=bad gap=20 |
| 313535 | reference | Packet dropped: illegal address 3 (len=2) |
| 313535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 313625 | **DUT** | IN  pkt #998 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313655 | **DUT** | IN  pkt #998 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313655 | yapp monitor | RX pkt #998 on the input: addr=3 len=2 parity=bad gap=8 |
| 313655 | reference | Packet dropped: illegal address 3 (len=2) |
| 313655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313670 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 313865 | **DUT** | IN  pkt #999 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 313895 | **DUT** | IN  pkt #999 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 313895 | yapp monitor | RX pkt #999 on the input: addr=3 len=2 parity=bad gap=20 |
| 313895 | reference | Packet dropped: illegal address 3 (len=2) |
| 313895 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 313990 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 313995 | **DUT** | IN  pkt #1000 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 314025 | **DUT** | IN  pkt #1000 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 314025 | yapp monitor | RX pkt #1000 on the input: addr=3 len=2 parity=bad gap=9 |
| 314025 | reference | Packet dropped: illegal address 3 (len=2) |
| 314025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 314065 | **DUT** | IN  pkt #1001 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 314090 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 314095 | **DUT** | IN  pkt #1001 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 314095 | yapp monitor | RX pkt #1001 on the input: addr=3 len=2 parity=bad gap=3 |
| 314095 | reference | Packet dropped: illegal address 3 (len=2) |
| 314095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 314130 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 314275 | **DUT** | IN  pkt #1002 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 314305 | **DUT** | IN  pkt #1002 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 314305 | yapp monitor | RX pkt #1002 on the input: addr=3 len=2 parity=bad gap=17 |
| 314305 | reference | Packet dropped: illegal address 3 (len=2) |
| 314305 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 314330 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 314515 | **DUT** | IN  pkt #1003 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 314545 | **DUT** | IN  pkt #1003 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 314545 | yapp monitor | RX pkt #1003 on the input: addr=3 len=2 parity=bad gap=20 |
| 314545 | reference | Packet dropped: illegal address 3 (len=2) |
| 314545 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 314650 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 314755 | **DUT** | IN  pkt #1004 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 314785 | **DUT** | IN  pkt #1004 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 314785 | yapp monitor | RX pkt #1004 on the input: addr=3 len=2 parity=bad gap=20 |
| 314785 | reference | Packet dropped: illegal address 3 (len=2) |
| 314785 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 314810 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 314995 | **DUT** | IN  pkt #1005 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315025 | **DUT** | IN  pkt #1005 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315025 | yapp monitor | RX pkt #1005 on the input: addr=3 len=2 parity=bad gap=20 |
| 315025 | reference | Packet dropped: illegal address 3 (len=2) |
| 315025 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315130 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 315215 | **DUT** | IN  pkt #1006 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315245 | **DUT** | IN  pkt #1006 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315245 | yapp monitor | RX pkt #1006 on the input: addr=3 len=2 parity=bad gap=18 |
| 315245 | reference | Packet dropped: illegal address 3 (len=2) |
| 315245 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315305 | **DUT** | IN  pkt #1007 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315310 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 315335 | **DUT** | IN  pkt #1007 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315335 | yapp monitor | RX pkt #1007 on the input: addr=3 len=2 parity=bad gap=5 |
| 315335 | reference | Packet dropped: illegal address 3 (len=2) |
| 315335 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315385 | **DUT** | IN  pkt #1008 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315415 | **DUT** | IN  pkt #1008 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315415 | yapp monitor | RX pkt #1008 on the input: addr=3 len=2 parity=bad gap=4 |
| 315415 | reference | Packet dropped: illegal address 3 (len=2) |
| 315415 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315430 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 315440 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 315625 | **DUT** | IN  pkt #1009 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315655 | **DUT** | IN  pkt #1009 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315655 | yapp monitor | RX pkt #1009 on the input: addr=3 len=2 parity=bad gap=20 |
| 315655 | reference | Packet dropped: illegal address 3 (len=2) |
| 315655 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315750 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet |
| 315825 | **DUT** | IN  pkt #1010 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 315855 | **DUT** | IN  pkt #1010 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 315855 | yapp monitor | RX pkt #1010 on the input: addr=3 len=2 parity=bad gap=16 |
| 315855 | reference | Packet dropped: illegal address 3 (len=2) |
| 315855 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 315890 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 316065 | **DUT** | IN  pkt #1011 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316095 | **DUT** | IN  pkt #1011 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316095 | yapp monitor | RX pkt #1011 on the input: addr=3 len=2 parity=bad gap=20 |
| 316095 | reference | Packet dropped: illegal address 3 (len=2) |
| 316095 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316115 | **DUT** | IN  pkt #1012 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316145 | **DUT** | IN  pkt #1012 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316145 | yapp monitor | RX pkt #1012 on the input: addr=3 len=2 parity=bad gap=1 |
| 316145 | reference | Packet dropped: illegal address 3 (len=2) |
| 316145 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316150 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet (1 more owed) |
| 316250 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet |
| 316295 | **DUT** | IN  pkt #1013 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316325 | **DUT** | IN  pkt #1013 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316325 | yapp monitor | RX pkt #1013 on the input: addr=3 len=2 parity=bad gap=14 |
| 316325 | reference | Packet dropped: illegal address 3 (len=2) |
| 316325 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316350 | **DUT** | ERROR pulse, 2 cycle(s) after the bad-parity packet |
| 316505 | **DUT** | IN  pkt #1014 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316535 | **DUT** | IN  pkt #1014 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316535 | yapp monitor | RX pkt #1014 on the input: addr=3 len=2 parity=bad gap=17 |
| 316535 | reference | Packet dropped: illegal address 3 (len=2) |
| 316535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316550 | **DUT** | ERROR pulse, 1 cycle(s) after the bad-parity packet |
| 316745 | **DUT** | IN  pkt #1015 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316775 | **DUT** | IN  pkt #1015 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316775 | yapp monitor | RX pkt #1015 on the input: addr=3 len=2 parity=bad gap=20 |
| 316775 | reference | Packet dropped: illegal address 3 (len=2) |
| 316775 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316805 | **DUT** | IN  pkt #1016 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 316835 | **DUT** | IN  pkt #1016 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 316835 | yapp monitor | RX pkt #1016 on the input: addr=3 len=2 parity=bad gap=2 |
| 316835 | reference | Packet dropped: illegal address 3 (len=2) |
| 316835 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 316870 | **DUT** | ERROR pulse, 9 cycle(s) after the bad-parity packet (1 more owed) |
| 316890 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 317025 | **DUT** | IN  pkt #1017 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 317055 | **DUT** | IN  pkt #1017 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 317055 | yapp monitor | RX pkt #1017 on the input: addr=3 len=2 parity=bad gap=18 |
| 317055 | reference | Packet dropped: illegal address 3 (len=2) |
| 317055 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 317110 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 317235 | **DUT** | IN  pkt #1018 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 317265 | **DUT** | IN  pkt #1018 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 317265 | yapp monitor | RX pkt #1018 on the input: addr=3 len=2 parity=bad gap=17 |
| 317265 | reference | Packet dropped: illegal address 3 (len=2) |
| 317265 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 317285 | **DUT** | IN  pkt #1019 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 317315 | **DUT** | IN  pkt #1019 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 317315 | yapp monitor | RX pkt #1019 on the input: addr=3 len=2 parity=bad gap=1 |
| 317315 | reference | Packet dropped: illegal address 3 (len=2) |
| 317315 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 317370 | **DUT** | ERROR pulse, 10 cycle(s) after the bad-parity packet (1 more owed) |
| 317380 | **DUT** | ERROR pulse, 6 cycle(s) after the bad-parity packet |
| 317505 | **DUT** | IN  pkt #1020 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 317535 | **DUT** | IN  pkt #1020 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 317535 | yapp monitor | RX pkt #1020 on the input: addr=3 len=2 parity=bad gap=18 |
| 317535 | reference | Packet dropped: illegal address 3 (len=2) |
| 317535 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 317590 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 317605 | **DUT** | IN  pkt #1021 header: addr=3 len=2 -> DROP (oversized: len 2 > maxpktsize 1) |
| 317635 | **DUT** | IN  pkt #1021 complete: addr=3 len=2 parity=BAD dropped, 4 bytes in 4 cycles (held 0) |
| 317635 | yapp monitor | RX pkt #1021 on the input: addr=3 len=2 parity=bad gap=6 |
| 317635 | reference | Packet dropped: illegal address 3 (len=2) |
| 317635 | **DUT** | ROUTER DROPS PACKET addr=3 length=2 (    illegal address) |
| 317675 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 317690 | **DUT** | ERROR pulse, 5 cycle(s) after the bad-parity packet |
| 317705 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 317735 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 317765 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 317795 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 317820 | **test** | STAGE: 8. ctrl_reg and en_reg back to their reset values, every register read |
| 317825 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 317845 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 317845 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 317845 | reference | maxpktsize is now 63 |
| 317865 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 317865 | reference | router_en is now 1 (en_reg 0x01) |
| 317895 | hbus monitor | Collected READ  addr=0x1000 data=0x3f |
| 317925 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 317955 | hbus monitor | Collected READ  addr=0x1002 data=0x00 |
| 317985 | hbus monitor | Collected READ  addr=0x1003 data=0x00 |
| 318015 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 318045 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 318075 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 318105 | hbus monitor | Collected READ  addr=0x1007 data=0x00 |
| 318135 | hbus monitor | Collected READ  addr=0x1008 data=0x00 |
| 318165 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 318195 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 318225 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 318255 | hbus monitor | Collected READ  addr=0x100c data=0x00 |
| 318280 | **test** | STAGE: sweep done: 1021 packets, 3628 HBUS reads |
| 318285 | hbus monitor | Collected READ  addr=0x100d data=0x02 |
| 318775 | **test** | STAGE: 9. the four HBUS coverage collectors are at 100 % and every read matched the model |
| 318775 | **test** | HBUS address map coverage 100% |
| 318775 | **test** | ctrl_reg / en_reg bits coverage 100% |
| 318775 | **test** | yapp_mem data patterns coverage 100% |
| 318775 | **test** | counter values coverage 100% |
| 318775 | **test** | STAGE: done: 3585 HBUS reads checked against the model, 0 mismatches, 43 memory bytes never written |
| 318975 | ch0 monitor | Channel 0 report: 1 packets collected |
| 318975 | ch1 monitor | Channel 1 report: 0 packets collected |
| 318975 | ch2 monitor | Channel 2 report: 0 packets collected |
| 318975 | hbus monitor | HBUS report: 1459 writes, 3628 reads |
| 318975 | coverage | Coverage of the router configuration: 60.9% |
| 318975 | coverage | HBUS address coverage: 5087 accesses sampled, coverage 100.0% |
| 318975 | coverage | HBUS register bits coverage: 51 writes to ctrl_reg/en_reg, coverage 100.0% |
| 318975 | coverage | HBUS counter value coverage: 876 counter reads sampled, coverage 100.0% |
| 318975 | coverage | HBUS yapp_mem data coverage: 2560 accesses sampled, coverage 100.0% |
| 318975 | reference |  |
| 318975 | reference | HBUS reads checked against the model: 3585 (0 mismatches, 43 of memory bytes never written) |
| 318975 | scoreboard |  |
| 318975 | coverage | YAPP gap coverage: 1020 gaps sampled, coverage 75.0% |
| 318975 | yapp monitor | YAPP monitor report: 1021 packets collected, 1020 with bad parity |
| 318975 | yapp monitor | YAPP gaps: 0 back to back, 55 of 1 cycle, 27 of 2, 938 longer |
| 318975 | coverage | YAPP packet coverage: 1021 packets sampled, coverage 50.0% |
