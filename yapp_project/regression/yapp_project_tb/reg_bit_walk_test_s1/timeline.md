# reg_bit_walk_test seed 1

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 3us · wall 0.3 s · log [`reg_bit_walk_test_s1.log`](reg_bit_walk_test_s1.log)

Waves: `reg_bit_walk_test_s1.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Freg_bit_walk_test_s1%2Freg_bit_walk_test_s1.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 0.
- Router: **0** forwarded, **0** dropped.
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 56 write(s), 54 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | RW register ctrl_reg: walking ones, walking zeros, 0x00 0xff 0xaa 0x55 |
| 1050 | RW register en_reg: walking ones, walking zeros, 0x00 0xff 0xaa 0x55 |
| 2050 | RO register parity_err_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2100 | RO register parity_err_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2150 | RO register oversized_pkt_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2200 | RO register oversized_pkt_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2250 | RO register addr3_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2300 | RO register addr3_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2350 | RO register addr0_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2400 | RO register addr0_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2450 | RO register addr1_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2500 | RO register addr1_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2550 | RO register addr2_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2600 | RO register addr2_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2650 | RO register mem_size_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2700 | RO register mem_size_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2750 | ctrl_reg and en_reg back to their reset values |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

379 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: RW register ctrl_reg: walking ones, walking zeros, 0x00 0xff 0xaa 0x55 |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x01 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=1 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x01 |
| 75 | reference | maxpktsize is now 1 |
| 100 | hbus driver | Executed READ  addr=0x1000 data=0x01 |
| 105 | hbus monitor | Collected READ  addr=0x1000 data=0x01 |
| 120 | hbus driver | Executed WRITE addr=0x1000 data=0x02 |
| 125 | **DUT** | CONFIG router_en=1 maxpktsize=2 |
| 125 | hbus monitor | Collected WRITE addr=0x1000 data=0x02 |
| 125 | reference | maxpktsize is now 2 |
| 150 | hbus driver | Executed READ  addr=0x1000 data=0x02 |
| 155 | hbus monitor | Collected READ  addr=0x1000 data=0x02 |
| 170 | hbus driver | Executed WRITE addr=0x1000 data=0x04 |
| 175 | **DUT** | CONFIG router_en=1 maxpktsize=4 |
| 175 | hbus monitor | Collected WRITE addr=0x1000 data=0x04 |
| 175 | reference | maxpktsize is now 4 |
| 200 | hbus driver | Executed READ  addr=0x1000 data=0x04 |
| 205 | hbus monitor | Collected READ  addr=0x1000 data=0x04 |
| 220 | hbus driver | Executed WRITE addr=0x1000 data=0x08 |
| 225 | **DUT** | CONFIG router_en=1 maxpktsize=8 |
| 225 | hbus monitor | Collected WRITE addr=0x1000 data=0x08 |
| 225 | reference | maxpktsize is now 8 |
| 250 | hbus driver | Executed READ  addr=0x1000 data=0x08 |
| 255 | hbus monitor | Collected READ  addr=0x1000 data=0x08 |
| 270 | hbus driver | Executed WRITE addr=0x1000 data=0x10 |
| 275 | **DUT** | CONFIG router_en=1 maxpktsize=16 |
| 275 | hbus monitor | Collected WRITE addr=0x1000 data=0x10 |
| 275 | reference | maxpktsize is now 16 |
| 300 | hbus driver | Executed READ  addr=0x1000 data=0x10 |
| 305 | hbus monitor | Collected READ  addr=0x1000 data=0x10 |
| 320 | hbus driver | Executed WRITE addr=0x1000 data=0x20 |
| 325 | **DUT** | CONFIG router_en=1 maxpktsize=32 |
| 325 | hbus monitor | Collected WRITE addr=0x1000 data=0x20 |
| 325 | reference | maxpktsize is now 32 |
| 350 | hbus driver | Executed READ  addr=0x1000 data=0x20 |
| 355 | hbus monitor | Collected READ  addr=0x1000 data=0x20 |
| 370 | hbus driver | Executed WRITE addr=0x1000 data=0x40 |
| 375 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 375 | hbus monitor | Collected WRITE addr=0x1000 data=0x40 |
| 375 | reference | maxpktsize is now 0 |
| 400 | hbus driver | Executed READ  addr=0x1000 data=0x40 |
| 405 | hbus monitor | Collected READ  addr=0x1000 data=0x40 |
| 420 | hbus driver | Executed WRITE addr=0x1000 data=0x80 |
| 425 | hbus monitor | Collected WRITE addr=0x1000 data=0x80 |
| 425 | reference | maxpktsize is now 0 |
| 450 | hbus driver | Executed READ  addr=0x1000 data=0x80 |
| 455 | hbus monitor | Collected READ  addr=0x1000 data=0x80 |
| 470 | hbus driver | Executed WRITE addr=0x1000 data=0xfe |
| 475 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 475 | hbus monitor | Collected WRITE addr=0x1000 data=0xfe |
| 475 | reference | maxpktsize is now 62 |
| 500 | hbus driver | Executed READ  addr=0x1000 data=0xfe |
| 505 | hbus monitor | Collected READ  addr=0x1000 data=0xfe |
| 520 | hbus driver | Executed WRITE addr=0x1000 data=0xfd |
| 525 | **DUT** | CONFIG router_en=1 maxpktsize=61 |
| 525 | hbus monitor | Collected WRITE addr=0x1000 data=0xfd |
| 525 | reference | maxpktsize is now 61 |
| 550 | hbus driver | Executed READ  addr=0x1000 data=0xfd |
| 555 | hbus monitor | Collected READ  addr=0x1000 data=0xfd |
| 570 | hbus driver | Executed WRITE addr=0x1000 data=0xfb |
| 575 | **DUT** | CONFIG router_en=1 maxpktsize=59 |
| 575 | hbus monitor | Collected WRITE addr=0x1000 data=0xfb |
| 575 | reference | maxpktsize is now 59 |
| 600 | hbus driver | Executed READ  addr=0x1000 data=0xfb |
| 605 | hbus monitor | Collected READ  addr=0x1000 data=0xfb |
| 620 | hbus driver | Executed WRITE addr=0x1000 data=0xf7 |
| 625 | **DUT** | CONFIG router_en=1 maxpktsize=55 |
| 625 | hbus monitor | Collected WRITE addr=0x1000 data=0xf7 |
| 625 | reference | maxpktsize is now 55 |
| 650 | hbus driver | Executed READ  addr=0x1000 data=0xf7 |
| 655 | hbus monitor | Collected READ  addr=0x1000 data=0xf7 |
| 670 | hbus driver | Executed WRITE addr=0x1000 data=0xef |
| 675 | **DUT** | CONFIG router_en=1 maxpktsize=47 |
| 675 | hbus monitor | Collected WRITE addr=0x1000 data=0xef |
| 675 | reference | maxpktsize is now 47 |
| 700 | hbus driver | Executed READ  addr=0x1000 data=0xef |
| 705 | hbus monitor | Collected READ  addr=0x1000 data=0xef |
| 720 | hbus driver | Executed WRITE addr=0x1000 data=0xdf |
| 725 | **DUT** | CONFIG router_en=1 maxpktsize=31 |
| 725 | hbus monitor | Collected WRITE addr=0x1000 data=0xdf |
| 725 | reference | maxpktsize is now 31 |
| 750 | hbus driver | Executed READ  addr=0x1000 data=0xdf |
| 755 | hbus monitor | Collected READ  addr=0x1000 data=0xdf |
| 770 | hbus driver | Executed WRITE addr=0x1000 data=0xbf |
| 775 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 775 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 775 | reference | maxpktsize is now 63 |
| 800 | hbus driver | Executed READ  addr=0x1000 data=0xbf |
| 805 | hbus monitor | Collected READ  addr=0x1000 data=0xbf |
| 820 | hbus driver | Executed WRITE addr=0x1000 data=0x7f |
| 825 | hbus monitor | Collected WRITE addr=0x1000 data=0x7f |
| 825 | reference | maxpktsize is now 63 |
| 850 | hbus driver | Executed READ  addr=0x1000 data=0x7f |
| 855 | hbus monitor | Collected READ  addr=0x1000 data=0x7f |
| 870 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 875 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 875 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 875 | reference | maxpktsize is now 0 |
| 900 | hbus driver | Executed READ  addr=0x1000 data=0x00 |
| 905 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
| 920 | hbus driver | Executed WRITE addr=0x1000 data=0xff |
| 925 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 925 | hbus monitor | Collected WRITE addr=0x1000 data=0xff |
| 925 | reference | maxpktsize is now 63 |
| 950 | hbus driver | Executed READ  addr=0x1000 data=0xff |
| 955 | hbus monitor | Collected READ  addr=0x1000 data=0xff |
| 970 | hbus driver | Executed WRITE addr=0x1000 data=0xaa |
| 975 | **DUT** | CONFIG router_en=1 maxpktsize=42 |
| 975 | hbus monitor | Collected WRITE addr=0x1000 data=0xaa |
| 975 | reference | maxpktsize is now 42 |
| 1000 | hbus driver | Executed READ  addr=0x1000 data=0xaa |
| 1005 | hbus monitor | Collected READ  addr=0x1000 data=0xaa |
| 1020 | hbus driver | Executed WRITE addr=0x1000 data=0x55 |
| 1025 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1025 | hbus monitor | Collected WRITE addr=0x1000 data=0x55 |
| 1025 | reference | maxpktsize is now 21 |
| 1050 | hbus driver | Executed READ  addr=0x1000 data=0x55 |
| 1050 | **test** | STAGE: RW register en_reg: walking ones, walking zeros, 0x00 0xff 0xaa 0x55 |
| 1055 | hbus monitor | Collected READ  addr=0x1000 data=0x55 |
| 1070 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 1075 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 1075 | reference | router_en is now 1 (en_reg 0x01) |
| 1100 | hbus driver | Executed READ  addr=0x1001 data=0x01 |
| 1105 | hbus monitor | Collected READ  addr=0x1001 data=0x01 |
| 1120 | hbus driver | Executed WRITE addr=0x1001 data=0x02 |
| 1125 | **DUT** | CONFIG router_en=0 maxpktsize=21 |
| 1125 | hbus monitor | Collected WRITE addr=0x1001 data=0x02 |
| 1125 | reference | router_en is now 0 (en_reg 0x02) |
| 1150 | hbus driver | Executed READ  addr=0x1001 data=0x02 |
| 1155 | hbus monitor | Collected READ  addr=0x1001 data=0x02 |
| 1170 | hbus driver | Executed WRITE addr=0x1001 data=0x04 |
| 1175 | hbus monitor | Collected WRITE addr=0x1001 data=0x04 |
| 1175 | reference | router_en is now 0 (en_reg 0x04) |
| 1200 | hbus driver | Executed READ  addr=0x1001 data=0x04 |
| 1205 | hbus monitor | Collected READ  addr=0x1001 data=0x04 |
| 1220 | hbus driver | Executed WRITE addr=0x1001 data=0x08 |
| 1225 | hbus monitor | Collected WRITE addr=0x1001 data=0x08 |
| 1225 | reference | router_en is now 0 (en_reg 0x08) |
| 1250 | hbus driver | Executed READ  addr=0x1001 data=0x08 |
| 1255 | hbus monitor | Collected READ  addr=0x1001 data=0x08 |
| 1270 | hbus driver | Executed WRITE addr=0x1001 data=0x10 |
| 1275 | hbus monitor | Collected WRITE addr=0x1001 data=0x10 |
| 1275 | reference | router_en is now 0 (en_reg 0x10) |
| 1300 | hbus driver | Executed READ  addr=0x1001 data=0x10 |
| 1305 | hbus monitor | Collected READ  addr=0x1001 data=0x10 |
| 1320 | hbus driver | Executed WRITE addr=0x1001 data=0x20 |
| 1325 | hbus monitor | Collected WRITE addr=0x1001 data=0x20 |
| 1325 | reference | router_en is now 0 (en_reg 0x20) |
| 1350 | hbus driver | Executed READ  addr=0x1001 data=0x20 |
| 1355 | hbus monitor | Collected READ  addr=0x1001 data=0x20 |
| 1370 | hbus driver | Executed WRITE addr=0x1001 data=0x40 |
| 1375 | hbus monitor | Collected WRITE addr=0x1001 data=0x40 |
| 1375 | reference | router_en is now 0 (en_reg 0x40) |
| 1400 | hbus driver | Executed READ  addr=0x1001 data=0x40 |
| 1405 | hbus monitor | Collected READ  addr=0x1001 data=0x40 |
| 1420 | hbus driver | Executed WRITE addr=0x1001 data=0x80 |
| 1425 | hbus monitor | Collected WRITE addr=0x1001 data=0x80 |
| 1425 | reference | router_en is now 0 (en_reg 0x80) |
| 1450 | hbus driver | Executed READ  addr=0x1001 data=0x80 |
| 1455 | hbus monitor | Collected READ  addr=0x1001 data=0x80 |
| 1470 | hbus driver | Executed WRITE addr=0x1001 data=0xfe |
| 1475 | hbus monitor | Collected WRITE addr=0x1001 data=0xfe |
| 1475 | reference | router_en is now 0 (en_reg 0xfe) |
| 1500 | hbus driver | Executed READ  addr=0x1001 data=0xfe |
| 1505 | hbus monitor | Collected READ  addr=0x1001 data=0xfe |
| 1520 | hbus driver | Executed WRITE addr=0x1001 data=0xfd |
| 1525 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1525 | hbus monitor | Collected WRITE addr=0x1001 data=0xfd |
| 1525 | reference | router_en is now 1 (en_reg 0xfd) |
| 1550 | hbus driver | Executed READ  addr=0x1001 data=0xfd |
| 1555 | hbus monitor | Collected READ  addr=0x1001 data=0xfd |
| 1570 | hbus driver | Executed WRITE addr=0x1001 data=0xfb |
| 1575 | hbus monitor | Collected WRITE addr=0x1001 data=0xfb |
| 1575 | reference | router_en is now 1 (en_reg 0xfb) |
| 1600 | hbus driver | Executed READ  addr=0x1001 data=0xfb |
| 1605 | hbus monitor | Collected READ  addr=0x1001 data=0xfb |
| 1620 | hbus driver | Executed WRITE addr=0x1001 data=0xf7 |
| 1625 | hbus monitor | Collected WRITE addr=0x1001 data=0xf7 |
| 1625 | reference | router_en is now 1 (en_reg 0xf7) |
| 1650 | hbus driver | Executed READ  addr=0x1001 data=0xf7 |
| 1655 | hbus monitor | Collected READ  addr=0x1001 data=0xf7 |
| 1670 | hbus driver | Executed WRITE addr=0x1001 data=0xef |
| 1675 | hbus monitor | Collected WRITE addr=0x1001 data=0xef |
| 1675 | reference | router_en is now 1 (en_reg 0xef) |
| 1700 | hbus driver | Executed READ  addr=0x1001 data=0xef |
| 1705 | hbus monitor | Collected READ  addr=0x1001 data=0xef |
| 1720 | hbus driver | Executed WRITE addr=0x1001 data=0xdf |
| 1725 | hbus monitor | Collected WRITE addr=0x1001 data=0xdf |
| 1725 | reference | router_en is now 1 (en_reg 0xdf) |
| 1750 | hbus driver | Executed READ  addr=0x1001 data=0xdf |
| 1755 | hbus monitor | Collected READ  addr=0x1001 data=0xdf |
| 1770 | hbus driver | Executed WRITE addr=0x1001 data=0xbf |
| 1775 | hbus monitor | Collected WRITE addr=0x1001 data=0xbf |
| 1775 | reference | router_en is now 1 (en_reg 0xbf) |
| 1800 | hbus driver | Executed READ  addr=0x1001 data=0xbf |
| 1805 | hbus monitor | Collected READ  addr=0x1001 data=0xbf |
| 1820 | hbus driver | Executed WRITE addr=0x1001 data=0x7f |
| 1825 | hbus monitor | Collected WRITE addr=0x1001 data=0x7f |
| 1825 | reference | router_en is now 1 (en_reg 0x7f) |
| 1850 | hbus driver | Executed READ  addr=0x1001 data=0x7f |
| 1855 | hbus monitor | Collected READ  addr=0x1001 data=0x7f |
| 1870 | hbus driver | Executed WRITE addr=0x1001 data=0x00 |
| 1875 | **DUT** | CONFIG router_en=0 maxpktsize=21 |
| 1875 | hbus monitor | Collected WRITE addr=0x1001 data=0x00 |
| 1875 | reference | router_en is now 0 (en_reg 0x00) |
| 1900 | hbus driver | Executed READ  addr=0x1001 data=0x00 |
| 1905 | hbus monitor | Collected READ  addr=0x1001 data=0x00 |
| 1920 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 1925 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 1925 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 1925 | reference | router_en is now 1 (en_reg 0xff) |
| 1950 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 1955 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 1970 | hbus driver | Executed WRITE addr=0x1001 data=0xaa |
| 1975 | **DUT** | CONFIG router_en=0 maxpktsize=21 |
| 1975 | hbus monitor | Collected WRITE addr=0x1001 data=0xaa |
| 1975 | reference | router_en is now 0 (en_reg 0xaa) |
| 2000 | hbus driver | Executed READ  addr=0x1001 data=0xaa |
| 2005 | hbus monitor | Collected READ  addr=0x1001 data=0xaa |
| 2020 | hbus driver | Executed WRITE addr=0x1001 data=0x55 |
| 2025 | **DUT** | CONFIG router_en=1 maxpktsize=21 |
| 2025 | hbus monitor | Collected WRITE addr=0x1001 data=0x55 |
| 2025 | reference | router_en is now 1 (en_reg 0x55) |
| 2050 | hbus driver | Executed READ  addr=0x1001 data=0x55 |
| 2050 | **test** | STAGE: RO register parity_err_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2050 | **test** | poke            0x00 |
| 2055 | hbus monitor | Collected READ  addr=0x1001 data=0x55 |
| 2080 | hbus driver | Executed READ  addr=0x1004 data=0x00 |
| 2080 | **test** | front-door read 0x00 |
| 2085 | hbus monitor | Collected READ  addr=0x1004 data=0x00 |
| 2100 | hbus driver | Executed WRITE addr=0x1004 data=0xff |
| 2100 | **test** | front-door write 0xff (RO: must be ignored) |
| 2100 | **test** | peek            0x00 |
| 2100 | **test** | STAGE: RO register parity_err_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2100 | **test** | poke            0xff |
| 2105 | hbus monitor | Collected WRITE addr=0x1004 data=0xff |
| 2130 | hbus driver | Executed READ  addr=0x1004 data=0xff |
| 2130 | **test** | front-door read 0xff |
| 2135 | hbus monitor | Collected READ  addr=0x1004 data=0xff |
| 2150 | hbus driver | Executed WRITE addr=0x1004 data=0x00 |
| 2150 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2150 | **test** | peek            0xff |
| 2150 | **test** | STAGE: RO register oversized_pkt_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2150 | **test** | poke            0x00 |
| 2155 | hbus monitor | Collected WRITE addr=0x1004 data=0x00 |
| 2180 | hbus driver | Executed READ  addr=0x1005 data=0x00 |
| 2180 | **test** | front-door read 0x00 |
| 2185 | hbus monitor | Collected READ  addr=0x1005 data=0x00 |
| 2200 | hbus driver | Executed WRITE addr=0x1005 data=0xff |
| 2200 | **test** | front-door write 0xff (RO: must be ignored) |
| 2200 | **test** | peek            0x00 |
| 2200 | **test** | STAGE: RO register oversized_pkt_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2200 | **test** | poke            0xff |
| 2205 | hbus monitor | Collected WRITE addr=0x1005 data=0xff |
| 2230 | hbus driver | Executed READ  addr=0x1005 data=0xff |
| 2230 | **test** | front-door read 0xff |
| 2235 | hbus monitor | Collected READ  addr=0x1005 data=0xff |
| 2250 | hbus driver | Executed WRITE addr=0x1005 data=0x00 |
| 2250 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2250 | **test** | peek            0xff |
| 2250 | **test** | STAGE: RO register addr3_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2250 | **test** | poke            0x00 |
| 2255 | hbus monitor | Collected WRITE addr=0x1005 data=0x00 |
| 2280 | hbus driver | Executed READ  addr=0x1006 data=0x00 |
| 2280 | **test** | front-door read 0x00 |
| 2285 | hbus monitor | Collected READ  addr=0x1006 data=0x00 |
| 2300 | hbus driver | Executed WRITE addr=0x1006 data=0xff |
| 2300 | **test** | front-door write 0xff (RO: must be ignored) |
| 2300 | **test** | peek            0x00 |
| 2300 | **test** | STAGE: RO register addr3_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2300 | **test** | poke            0xff |
| 2305 | hbus monitor | Collected WRITE addr=0x1006 data=0xff |
| 2330 | hbus driver | Executed READ  addr=0x1006 data=0xff |
| 2330 | **test** | front-door read 0xff |
| 2335 | hbus monitor | Collected READ  addr=0x1006 data=0xff |
| 2350 | hbus driver | Executed WRITE addr=0x1006 data=0x00 |
| 2350 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2350 | **test** | peek            0xff |
| 2350 | **test** | STAGE: RO register addr0_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2350 | **test** | poke            0x00 |
| 2355 | hbus monitor | Collected WRITE addr=0x1006 data=0x00 |
| 2380 | hbus driver | Executed READ  addr=0x1009 data=0x00 |
| 2380 | **test** | front-door read 0x00 |
| 2385 | hbus monitor | Collected READ  addr=0x1009 data=0x00 |
| 2400 | hbus driver | Executed WRITE addr=0x1009 data=0xff |
| 2400 | **test** | front-door write 0xff (RO: must be ignored) |
| 2400 | **test** | peek            0x00 |
| 2400 | **test** | STAGE: RO register addr0_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2400 | **test** | poke            0xff |
| 2405 | hbus monitor | Collected WRITE addr=0x1009 data=0xff |
| 2430 | hbus driver | Executed READ  addr=0x1009 data=0xff |
| 2430 | **test** | front-door read 0xff |
| 2435 | hbus monitor | Collected READ  addr=0x1009 data=0xff |
| 2450 | hbus driver | Executed WRITE addr=0x1009 data=0x00 |
| 2450 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2450 | **test** | peek            0xff |
| 2450 | **test** | STAGE: RO register addr1_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2450 | **test** | poke            0x00 |
| 2455 | hbus monitor | Collected WRITE addr=0x1009 data=0x00 |
| 2480 | hbus driver | Executed READ  addr=0x100a data=0x00 |
| 2480 | **test** | front-door read 0x00 |
| 2485 | hbus monitor | Collected READ  addr=0x100a data=0x00 |
| 2500 | hbus driver | Executed WRITE addr=0x100a data=0xff |
| 2500 | **test** | front-door write 0xff (RO: must be ignored) |
| 2500 | **test** | peek            0x00 |
| 2500 | **test** | STAGE: RO register addr1_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2500 | **test** | poke            0xff |
| 2505 | hbus monitor | Collected WRITE addr=0x100a data=0xff |
| 2530 | hbus driver | Executed READ  addr=0x100a data=0xff |
| 2530 | **test** | front-door read 0xff |
| 2535 | hbus monitor | Collected READ  addr=0x100a data=0xff |
| 2550 | hbus driver | Executed WRITE addr=0x100a data=0x00 |
| 2550 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2550 | **test** | peek            0xff |
| 2550 | **test** | STAGE: RO register addr2_cnt_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2550 | **test** | poke            0x00 |
| 2555 | hbus monitor | Collected WRITE addr=0x100a data=0x00 |
| 2580 | hbus driver | Executed READ  addr=0x100b data=0x00 |
| 2580 | **test** | front-door read 0x00 |
| 2585 | hbus monitor | Collected READ  addr=0x100b data=0x00 |
| 2600 | hbus driver | Executed WRITE addr=0x100b data=0xff |
| 2600 | **test** | front-door write 0xff (RO: must be ignored) |
| 2600 | **test** | peek            0x00 |
| 2600 | **test** | STAGE: RO register addr2_cnt_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2600 | **test** | poke            0xff |
| 2605 | hbus monitor | Collected WRITE addr=0x100b data=0xff |
| 2630 | hbus driver | Executed READ  addr=0x100b data=0xff |
| 2630 | **test** | front-door read 0xff |
| 2635 | hbus monitor | Collected READ  addr=0x100b data=0xff |
| 2650 | hbus driver | Executed WRITE addr=0x100b data=0x00 |
| 2650 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2650 | **test** | peek            0xff |
| 2650 | **test** | STAGE: RO register mem_size_reg: poke 0x00, front-door read, write 0xff must be ignored |
| 2650 | **test** | poke            0x00 |
| 2655 | hbus monitor | Collected WRITE addr=0x100b data=0x00 |
| 2680 | hbus driver | Executed READ  addr=0x100d data=0x00 |
| 2680 | **test** | front-door read 0x00 |
| 2685 | hbus monitor | Collected READ  addr=0x100d data=0x00 |
| 2700 | hbus driver | Executed WRITE addr=0x100d data=0xff |
| 2700 | **test** | front-door write 0xff (RO: must be ignored) |
| 2700 | **test** | peek            0x00 |
| 2700 | **test** | STAGE: RO register mem_size_reg: poke 0xff, front-door read, write 0x00 must be ignored |
| 2700 | **test** | poke            0xff |
| 2705 | hbus monitor | Collected WRITE addr=0x100d data=0xff |
| 2730 | hbus driver | Executed READ  addr=0x100d data=0xff |
| 2730 | **test** | front-door read 0xff |
| 2735 | hbus monitor | Collected READ  addr=0x100d data=0xff |
| 2750 | hbus driver | Executed WRITE addr=0x100d data=0x00 |
| 2750 | **test** | front-door write 0x00 (RO: must be ignored) |
| 2750 | **test** | peek            0xff |
| 2750 | **test** | STAGE: ctrl_reg and en_reg back to their reset values |
| 2755 | hbus monitor | Collected WRITE addr=0x100d data=0x00 |
| 2770 | hbus driver | Executed WRITE addr=0x1000 data=0x3f |
| 2775 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 2775 | hbus monitor | Collected WRITE addr=0x1000 data=0x3f |
| 2775 | reference | maxpktsize is now 63 |
| 2790 | hbus driver | Executed WRITE addr=0x1001 data=0x01 |
| 2795 | hbus monitor | Collected WRITE addr=0x1001 data=0x01 |
| 2795 | reference | router_en is now 1 (en_reg 0x01) |
| 2990 | ch0 monitor | Channel 0 report: 0 packets collected |
| 2990 | ch1 monitor | Channel 1 report: 0 packets collected |
| 2990 | ch2 monitor | Channel 2 report: 0 packets collected |
| 2990 | hbus monitor | HBUS report: 56 writes, 54 reads |
| 2990 | coverage | HBUS address coverage: 110 accesses sampled, coverage 37.7% |
| 2990 | coverage | HBUS register bits coverage: 42 writes to ctrl_reg/en_reg, coverage 100.0% |
| 2990 | coverage | HBUS counter value coverage: 12 counter reads sampled, coverage 74.1% |
| 2990 | coverage | HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0% |
| 2990 | reference | --- Reference model report --- · forwarded to scoreboard : 0 · dropped (router disabled) : 0 · dropped (oversized) : 0 · dropped (address 3) : 0 · counters parity/oversized/addr0..3 : 0 / 0 / 0 0 0 0 |
| 2990 | scoreboard | --- Scoreboard report --- · packets received : 0 · packets matched : 0 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 2990 | yapp driver | YAPP driver report: 0 packets sent |
| 2990 | coverage | YAPP gap coverage: 0 gaps sampled, coverage 0.0% |
| 2990 | yapp monitor | YAPP monitor report: 0 packets collected, 0 with bad parity |
| 2990 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 0 longer |
| 2990 | coverage | YAPP packet coverage: 0 packets sampled, coverage 0.0% |
