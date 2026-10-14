# random_config_test seed 5

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 38us · wall 18.9 s · log [`random_config_test_s5.log`](random_config_test_s5.log)

Waves: `random_config_test_s5.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Frandom_config_test_s5%2Frandom_config_test_s5.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **73** packet(s) (4 with bad parity); the input monitor saw 73.
- Router: **35** forwarded, **38** dropped (34 oversized, 4 illegal address 3).
- Packets out: ch0 **6**, ch1 **9**, ch2 **20**.
- Scoreboard: 35 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 4.
- HBUS: 19 write(s), 96 read(s).

## Stages

| time (ns) | stage |
|---|---|
| 0 | receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | random scenario: 73 packets in 4 bursts |
| 340 | burst 1/4: ctrl=0x00 (maxpktsize 0) en=0xd9 (router on, counter enables 1101100), 19 packet(s) |
| 6770 | burst 1/4 sent: addr0..3 4/5/5/5, bad parity 0, gap 0 6, length 1..63 |
| 7070 | burst 2/4: ctrl=0xf6 (maxpktsize 54) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 17670 | burst 2/4 sent: addr0..3 2/3/11/2, bad parity 0, gap 0 1, length 1..63 |
| 17900 | burst 3/4: ctrl=0xbf (maxpktsize 63) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 26280 | burst 3/4 sent: addr0..3 4/4/9/1, bad parity 2, gap 0 6, length 1..63 |
| 26560 | burst 4/4: ctrl=0x3e (maxpktsize 62) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 35810 | burst 4/4 sent: addr0..3 4/4/8/2, bad parity 2, gap 0 7, length 1..63 |
| 35810 | final reads: every register and the stored packet, checked against the reference model |
| 38085 | done: 73 packets (35 forwarded, 38 dropped), 0 storm burst(s), 35 scoreboard matches, 95 HBUS reads checked, 4 error pulses for 4 bad packets |

## Pictures

**reset and the first cycles**

![reset and the first cycles](wave_reset.svg)

**first packet into the router**

![first packet into the router](wave_first_packet_in.svg)

**first packet out on channel 2**

![first packet out on channel 2](wave_first_packet_out.svg)

**first error pulse after a bad-parity packet**

![first error pulse after a bad-parity packet](wave_first_error_pulse.svg)

**first HBUS write**

![first HBUS write](wave_first_hbus_write.svg)

**first HBUS read**

![first HBUS read](wave_first_hbus_read.svg)

## Timeline

963 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | **test** | STAGE: receivers: ch0 CHANNEL_RX_PROFILE_FAST, ch1 CHANNEL_RX_PROFILE_NORMAL, ch2 CHANNEL_RX_PROFILE_FAST |
| 0 | **test** | STAGE: random scenario: 73 packets in 4 bursts |
| 0 | clk/rst driver | Starting clock (period 10) and holding reset for 5 cycles |
| 0 | **DUT** | RESET asserted |
| 50 | **DUT** | RESET released: router_en=1 maxpktsize=63 |
| 70 | hbus driver | Executed WRITE addr=0x1000 data=0x00 |
| 75 | **DUT** | CONFIG router_en=1 maxpktsize=0 |
| 75 | hbus monitor | Collected WRITE addr=0x1000 data=0x00 |
| 75 | reference | maxpktsize is now 0 |
| 90 | hbus driver | Executed WRITE addr=0x1001 data=0xd9 |
| 95 | hbus monitor | Collected WRITE addr=0x1001 data=0xd9 |
| 95 | reference | router_en is now 1 (en_reg 0xd9) |
| 120 | hbus driver | Executed READ  addr=0x1000 data=0x00 |
| 125 | hbus monitor | Collected READ  addr=0x1000 data=0x00 |
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
| 340 | **test** | STAGE: burst 1/4: ctrl=0x00 (maxpktsize 0) en=0xd9 (router on, counter enables 1101100), 19 packet(s) |
| 340 | yapp driver | TX pkt #1: addr=3 len=63 parity=good delay=1 |
| 345 | hbus monitor | Collected READ  addr=0x100f data=0x00 |
| 365 | **DUT** | IN  pkt #1 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 1005 | **DUT** | IN  pkt #1 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1005 | yapp monitor | RX pkt #1 on the input: addr=3 len=63 parity=good gap=31 |
| 1005 | reference | Packet dropped: illegal address 3 (len=63) |
| 1005 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1010 | yapp driver | TX pkt #1 accepted by the DUT |
| 1010 | yapp driver | TX pkt #2: addr=3 len=63 parity=good delay=12 |
| 1135 | **DUT** | IN  pkt #2 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 1775 | **DUT** | IN  pkt #2 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 1775 | yapp monitor | RX pkt #2 on the input: addr=3 len=63 parity=good gap=12 |
| 1775 | reference | Packet dropped: illegal address 3 (len=63) |
| 1775 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 1780 | yapp driver | TX pkt #2 accepted by the DUT |
| 1780 | yapp driver | TX pkt #3: addr=0 len=1 parity=good delay=8 |
| 1865 | **DUT** | IN  pkt #3 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 1885 | **DUT** | IN  pkt #3 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 1885 | yapp monitor | RX pkt #3 on the input: addr=0 len=1 parity=good gap=8 |
| 1885 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 1885 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 1890 | yapp driver | TX pkt #3 accepted by the DUT |
| 1890 | yapp driver | TX pkt #4: addr=2 len=62 parity=good delay=18 |
| 2075 | **DUT** | IN  pkt #4 header: addr=2 len=62 -> DROP (oversized: len 62 > maxpktsize 0) |
| 2705 | **DUT** | IN  pkt #4 complete: addr=2 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 2705 | yapp monitor | RX pkt #4 on the input: addr=2 len=62 parity=good gap=18 |
| 2705 | reference | Packet dropped: length 62 > maxpktsize 0 (addr=2) |
| 2705 | **DUT** | ROUTER DROPS PACKET addr=2 length=62 (length > maxpktsize) |
| 2710 | yapp driver | TX pkt #4 accepted by the DUT |
| 2710 | yapp driver | TX pkt #5: addr=0 len=1 parity=good delay=13 |
| 2845 | **DUT** | IN  pkt #5 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 2865 | **DUT** | IN  pkt #5 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 2865 | yapp monitor | RX pkt #5 on the input: addr=0 len=1 parity=good gap=13 |
| 2865 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 2865 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 2870 | yapp driver | TX pkt #5 accepted by the DUT |
| 2870 | yapp driver | TX pkt #6: addr=1 len=63 parity=good delay=0 |
| 2875 | **DUT** | IN  pkt #6 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 3515 | **DUT** | IN  pkt #6 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 3515 | yapp monitor | RX pkt #6 on the input: addr=1 len=63 parity=good gap=0 |
| 3515 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 3515 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 3520 | yapp driver | TX pkt #6 accepted by the DUT |
| 3520 | yapp driver | TX pkt #7: addr=1 len=1 parity=good delay=2 |
| 3545 | **DUT** | IN  pkt #7 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 3565 | **DUT** | IN  pkt #7 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 3565 | yapp monitor | RX pkt #7 on the input: addr=1 len=1 parity=good gap=2 |
| 3565 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 3565 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 3570 | yapp driver | TX pkt #7 accepted by the DUT |
| 3570 | yapp driver | TX pkt #8: addr=2 len=2 parity=good delay=0 |
| 3575 | **DUT** | IN  pkt #8 header: addr=2 len=2 -> DROP (oversized: len 2 > maxpktsize 0) |
| 3605 | **DUT** | IN  pkt #8 complete: addr=2 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 3605 | yapp monitor | RX pkt #8 on the input: addr=2 len=2 parity=good gap=0 |
| 3605 | reference | Packet dropped: length 2 > maxpktsize 0 (addr=2) |
| 3605 | **DUT** | ROUTER DROPS PACKET addr=2 length=2 (length > maxpktsize) |
| 3610 | yapp driver | TX pkt #8 accepted by the DUT |
| 3610 | yapp driver | TX pkt #9: addr=1 len=63 parity=good delay=0 |
| 3615 | **DUT** | IN  pkt #9 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 4255 | **DUT** | IN  pkt #9 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 4255 | yapp monitor | RX pkt #9 on the input: addr=1 len=63 parity=good gap=0 |
| 4255 | reference | Packet dropped: length 63 > maxpktsize 0 (addr=1) |
| 4255 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 4260 | yapp driver | TX pkt #9 accepted by the DUT |
| 4260 | yapp driver | TX pkt #10: addr=3 len=8 parity=good delay=0 |
| 4265 | **DUT** | IN  pkt #10 header: addr=3 len=8 -> DROP (oversized: len 8 > maxpktsize 0) |
| 4355 | **DUT** | IN  pkt #10 complete: addr=3 len=8 parity=ok dropped, 10 bytes in 10 cycles (held 0) |
| 4355 | yapp monitor | RX pkt #10 on the input: addr=3 len=8 parity=good gap=0 |
| 4355 | reference | Packet dropped: illegal address 3 (len=8) |
| 4355 | **DUT** | ROUTER DROPS PACKET addr=3 length=8 (    illegal address) |
| 4360 | yapp driver | TX pkt #10 accepted by the DUT |
| 4360 | yapp driver | TX pkt #11: addr=3 len=63 parity=good delay=2 |
| 4385 | **DUT** | IN  pkt #11 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 5025 | **DUT** | IN  pkt #11 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 5025 | yapp monitor | RX pkt #11 on the input: addr=3 len=63 parity=good gap=2 |
| 5025 | reference | Packet dropped: illegal address 3 (len=63) |
| 5025 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 5030 | yapp driver | TX pkt #11 accepted by the DUT |
| 5030 | yapp driver | TX pkt #12: addr=2 len=1 parity=good delay=20 |
| 5235 | **DUT** | IN  pkt #12 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 5255 | **DUT** | IN  pkt #12 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 5255 | yapp monitor | RX pkt #12 on the input: addr=2 len=1 parity=good gap=20 |
| 5255 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 5255 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 5260 | yapp driver | TX pkt #12 accepted by the DUT |
| 5260 | yapp driver | TX pkt #13: addr=2 len=1 parity=good delay=7 |
| 5335 | **DUT** | IN  pkt #13 header: addr=2 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 5355 | **DUT** | IN  pkt #13 complete: addr=2 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 5355 | yapp monitor | RX pkt #13 on the input: addr=2 len=1 parity=good gap=7 |
| 5355 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=2) |
| 5355 | **DUT** | ROUTER DROPS PACKET addr=2 length=1 (length > maxpktsize) |
| 5360 | yapp driver | TX pkt #13 accepted by the DUT |
| 5360 | yapp driver | TX pkt #14: addr=0 len=1 parity=good delay=3 |
| 5395 | **DUT** | IN  pkt #14 header: addr=0 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 5415 | **DUT** | IN  pkt #14 complete: addr=0 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 5415 | yapp monitor | RX pkt #14 on the input: addr=0 len=1 parity=good gap=3 |
| 5415 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=0) |
| 5415 | **DUT** | ROUTER DROPS PACKET addr=0 length=1 (length > maxpktsize) |
| 5420 | yapp driver | TX pkt #14 accepted by the DUT |
| 5420 | yapp driver | TX pkt #15: addr=2 len=37 parity=good delay=0 |
| 5425 | **DUT** | IN  pkt #15 header: addr=2 len=37 -> DROP (oversized: len 37 > maxpktsize 0) |
| 5805 | **DUT** | IN  pkt #15 complete: addr=2 len=37 parity=ok dropped, 39 bytes in 39 cycles (held 0) |
| 5805 | yapp monitor | RX pkt #15 on the input: addr=2 len=37 parity=good gap=0 |
| 5805 | reference | Packet dropped: length 37 > maxpktsize 0 (addr=2) |
| 5805 | **DUT** | ROUTER DROPS PACKET addr=2 length=37 (length > maxpktsize) |
| 5810 | yapp driver | TX pkt #15 accepted by the DUT |
| 5810 | yapp driver | TX pkt #16: addr=3 len=63 parity=good delay=19 |
| 6005 | **DUT** | IN  pkt #16 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 0) |
| 6645 | **DUT** | IN  pkt #16 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 6645 | yapp monitor | RX pkt #16 on the input: addr=3 len=63 parity=good gap=19 |
| 6645 | reference | Packet dropped: illegal address 3 (len=63) |
| 6645 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 6650 | yapp driver | TX pkt #16 accepted by the DUT |
| 6650 | yapp driver | TX pkt #17: addr=0 len=2 parity=good delay=0 |
| 6655 | **DUT** | IN  pkt #17 header: addr=0 len=2 -> DROP (oversized: len 2 > maxpktsize 0) |
| 6685 | **DUT** | IN  pkt #17 complete: addr=0 len=2 parity=ok dropped, 4 bytes in 4 cycles (held 0) |
| 6685 | yapp monitor | RX pkt #17 on the input: addr=0 len=2 parity=good gap=0 |
| 6685 | reference | Packet dropped: length 2 > maxpktsize 0 (addr=0) |
| 6685 | **DUT** | ROUTER DROPS PACKET addr=0 length=2 (length > maxpktsize) |
| 6690 | yapp driver | TX pkt #17 accepted by the DUT |
| 6690 | yapp driver | TX pkt #18: addr=1 len=1 parity=good delay=1 |
| 6705 | **DUT** | IN  pkt #18 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 6725 | **DUT** | IN  pkt #18 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 6725 | yapp monitor | RX pkt #18 on the input: addr=1 len=1 parity=good gap=1 |
| 6725 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 6725 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 6730 | yapp driver | TX pkt #18 accepted by the DUT |
| 6730 | yapp driver | TX pkt #19: addr=1 len=1 parity=good delay=1 |
| 6745 | **DUT** | IN  pkt #19 header: addr=1 len=1 -> DROP (oversized: len 1 > maxpktsize 0) |
| 6765 | **DUT** | IN  pkt #19 complete: addr=1 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 6765 | yapp monitor | RX pkt #19 on the input: addr=1 len=1 parity=good gap=1 |
| 6765 | reference | Packet dropped: length 1 > maxpktsize 0 (addr=1) |
| 6765 | **DUT** | ROUTER DROPS PACKET addr=1 length=1 (length > maxpktsize) |
| 6770 | yapp driver | TX pkt #19 accepted by the DUT |
| 6770 | **test** | STAGE: burst 1/4 sent: addr0..3 4/5/5/5, bad parity 0, gap 0 6, length 1..63 |
| 6790 | hbus driver | Executed WRITE addr=0x1000 data=0xf6 |
| 6795 | **DUT** | CONFIG router_en=1 maxpktsize=54 |
| 6795 | hbus monitor | Collected WRITE addr=0x1000 data=0xf6 |
| 6795 | reference | maxpktsize is now 54 |
| 6810 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 6815 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 6815 | reference | router_en is now 1 (en_reg 0xff) |
| 6830 | hbus driver | Executed WRITE addr=0x119e data=0x89 |
| 6835 | hbus monitor | Collected WRITE addr=0x119e data=0x89 |
| 6860 | hbus driver | Executed READ  addr=0x119e data=0x89 |
| 6865 | hbus monitor | Collected READ  addr=0x119e data=0x89 |
| 6890 | hbus driver | Executed READ  addr=0x100d data=0x01 |
| 6895 | hbus monitor | Collected READ  addr=0x100d data=0x01 |
| 6910 | hbus driver | Executed WRITE addr=0x117b data=0xec |
| 6915 | hbus monitor | Collected WRITE addr=0x117b data=0xec |
| 6940 | hbus driver | Executed READ  addr=0x117b data=0xec |
| 6945 | hbus monitor | Collected READ  addr=0x117b data=0xec |
| 6970 | hbus driver | Executed READ  addr=0x1025 data=0xb5 |
| 6975 | hbus monitor | Collected READ  addr=0x1025 data=0xb5 |
| 6990 | hbus driver | Executed WRITE addr=0x11d0 data=0xcf |
| 6995 | hbus monitor | Collected WRITE addr=0x11d0 data=0xcf |
| 7020 | hbus driver | Executed READ  addr=0x11d0 data=0xcf |
| 7025 | hbus monitor | Collected READ  addr=0x11d0 data=0xcf |
| 7040 | hbus driver | Executed WRITE addr=0x11c1 data=0x6e |
| 7045 | hbus monitor | Collected WRITE addr=0x11c1 data=0x6e |
| 7070 | hbus driver | Executed READ  addr=0x11c1 data=0x6e |
| 7070 | **test** | STAGE: burst 2/4: ctrl=0xf6 (maxpktsize 54) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 7070 | yapp driver | TX pkt #20: addr=2 len=53 parity=good delay=1 |
| 7075 | hbus monitor | Collected READ  addr=0x11c1 data=0x6e |
| 7095 | **DUT** | IN  pkt #20 header: addr=2 len=53 -> channel 2 |
| 7105 | **DUT** | OUT ch2 pkt #1 start: addr=2 len=53 (receiver waited 0 cycle(s)) |
| 7635 | **DUT** | IN  pkt #20 complete: addr=2 len=53 parity=ok forwarded, 55 bytes in 55 cycles (held 0) |
| 7635 | yapp monitor | RX pkt #20 on the input: addr=2 len=53 parity=good gap=32 |
| 7635 | reference | Packet forwarded: addr=2 len=53 -> channel 2 |
| 7640 | ch2 driver | ch2: packet consumed (response delay 0) |
| 7640 | yapp driver | TX pkt #20 accepted by the DUT |
| 7640 | yapp driver | TX pkt #21: addr=2 len=63 parity=good delay=20 |
| 7655 | **DUT** | OUT ch2 pkt #1 done: 55 bytes in 56 cycles |
| 7655 | ch2 monitor | ch2 RX pkt #1: addr=2 len=53 parity=good |
| 7655 | scoreboard | ch2 pkt matched: addr=2 len=53 (1 matched so far) |
| 7845 | **DUT** | IN  pkt #21 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 54) |
| 8040 | ch2 driver | ch2: packet consumed (response delay 0) |
| 8485 | **DUT** | IN  pkt #21 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 8485 | yapp monitor | RX pkt #21 on the input: addr=2 len=63 parity=good gap=20 |
| 8485 | reference | Packet dropped: length 63 > maxpktsize 54 (addr=2) |
| 8485 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 8490 | yapp driver | TX pkt #21 accepted by the DUT |
| 8490 | yapp driver | TX pkt #22: addr=0 len=54 parity=good delay=2 |
| 8515 | **DUT** | IN  pkt #22 header: addr=0 len=54 -> channel 0 |
| 8525 | **DUT** | OUT ch0 pkt #1 start: addr=0 len=54 (receiver waited 0 cycle(s)) |
| 9065 | **DUT** | IN  pkt #22 complete: addr=0 len=54 parity=ok forwarded, 56 bytes in 56 cycles (held 0) |
| 9065 | yapp monitor | RX pkt #22 on the input: addr=0 len=54 parity=good gap=2 |
| 9065 | reference | Packet forwarded: addr=0 len=54 -> channel 0 |
| 9070 | ch0 driver | ch0: packet consumed (response delay 0) |
| 9070 | yapp driver | TX pkt #22 accepted by the DUT |
| 9070 | yapp driver | TX pkt #23: addr=2 len=1 parity=good delay=0 |
| 9075 | **DUT** | IN  pkt #23 header: addr=2 len=1 -> channel 2 |
| 9085 | **DUT** | OUT ch0 pkt #1 done: 56 bytes in 57 cycles |
| 9085 | **DUT** | OUT ch2 pkt #2 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 9085 | ch0 monitor | ch0 RX pkt #1: addr=0 len=54 parity=good |
| 9085 | scoreboard | ch0 pkt matched: addr=0 len=54 (2 matched so far) |
| 9095 | **DUT** | IN  pkt #23 complete: addr=2 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 9095 | yapp monitor | RX pkt #23 on the input: addr=2 len=1 parity=good gap=0 |
| 9095 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 9100 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9100 | yapp driver | TX pkt #23 accepted by the DUT |
| 9100 | yapp driver | TX pkt #24: addr=2 len=35 parity=good delay=2 |
| 9115 | **DUT** | OUT ch2 pkt #2 done: 3 bytes in 4 cycles |
| 9115 | ch2 monitor | ch2 RX pkt #2: addr=2 len=1 parity=good |
| 9115 | scoreboard | ch2 pkt matched: addr=2 len=1 (3 matched so far) |
| 9125 | **DUT** | IN  pkt #24 header: addr=2 len=35 -> channel 2 |
| 9135 | **DUT** | OUT ch2 pkt #3 start: addr=2 len=35 (receiver waited 0 cycle(s)) |
| 9290 | ch2 driver | ch2: packet consumed (response delay 0) |
| 9485 | **DUT** | IN  pkt #24 complete: addr=2 len=35 parity=ok forwarded, 37 bytes in 37 cycles (held 0) |
| 9485 | yapp monitor | RX pkt #24 on the input: addr=2 len=35 parity=good gap=2 |
| 9485 | reference | Packet forwarded: addr=2 len=35 -> channel 2 |
| 9490 | yapp driver | TX pkt #24 accepted by the DUT |
| 9490 | yapp driver | TX pkt #25: addr=2 len=63 parity=good delay=3 |
| 9505 | **DUT** | OUT ch2 pkt #3 done: 37 bytes in 38 cycles |
| 9505 | ch2 monitor | ch2 RX pkt #3: addr=2 len=35 parity=good |
| 9505 | scoreboard | ch2 pkt matched: addr=2 len=35 (4 matched so far) |
| 9525 | **DUT** | IN  pkt #25 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 54) |
| 9710 | ch0 driver | ch0: packet consumed (response delay 0) |
| 9900 | ch2 driver | ch2: packet consumed (response delay 0) |
| 10165 | **DUT** | IN  pkt #25 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 10165 | yapp monitor | RX pkt #25 on the input: addr=2 len=63 parity=good gap=3 |
| 10165 | reference | Packet dropped: length 63 > maxpktsize 54 (addr=2) |
| 10165 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 10170 | yapp driver | TX pkt #25 accepted by the DUT |
| 10170 | yapp driver | TX pkt #26: addr=0 len=63 parity=good delay=20 |
| 10375 | **DUT** | IN  pkt #26 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 54) |
| 11015 | **DUT** | IN  pkt #26 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11015 | yapp monitor | RX pkt #26 on the input: addr=0 len=63 parity=good gap=20 |
| 11015 | reference | Packet dropped: length 63 > maxpktsize 54 (addr=0) |
| 11015 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 11020 | yapp driver | TX pkt #26 accepted by the DUT |
| 11020 | yapp driver | TX pkt #27: addr=3 len=63 parity=good delay=6 |
| 11085 | **DUT** | IN  pkt #27 header: addr=3 len=63 -> DROP (oversized: len 63 > maxpktsize 54) |
| 11725 | **DUT** | IN  pkt #27 complete: addr=3 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 11725 | yapp monitor | RX pkt #27 on the input: addr=3 len=63 parity=good gap=6 |
| 11725 | reference | Packet dropped: illegal address 3 (len=63) |
| 11725 | **DUT** | ROUTER DROPS PACKET addr=3 length=63 (    illegal address) |
| 11730 | yapp driver | TX pkt #27 accepted by the DUT |
| 11730 | yapp driver | TX pkt #28: addr=2 len=55 parity=good delay=14 |
| 11875 | **DUT** | IN  pkt #28 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 54) |
| 12435 | **DUT** | IN  pkt #28 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 12435 | yapp monitor | RX pkt #28 on the input: addr=2 len=55 parity=good gap=14 |
| 12435 | reference | Packet dropped: length 55 > maxpktsize 54 (addr=2) |
| 12435 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 12440 | yapp driver | TX pkt #28 accepted by the DUT |
| 12440 | yapp driver | TX pkt #29: addr=1 len=37 parity=good delay=1 |
| 12455 | **DUT** | IN  pkt #29 header: addr=1 len=37 -> channel 1 |
| 12565 | **DUT** | OUT ch1 pkt #1 start: addr=1 len=37 (receiver waited 10 cycle(s)) |
| 12835 | **DUT** | IN  pkt #29 complete: addr=1 len=37 parity=ok forwarded, 39 bytes in 39 cycles (held 0) |
| 12835 | yapp monitor | RX pkt #29 on the input: addr=1 len=37 parity=good gap=1 |
| 12835 | reference | Packet forwarded: addr=1 len=37 -> channel 1 |
| 12840 | yapp driver | TX pkt #29 accepted by the DUT |
| 12840 | yapp driver | TX pkt #30: addr=2 len=3 parity=good delay=16 |
| 12940 | ch1 driver | ch1: packet consumed (response delay 10) |
| 13005 | **DUT** | IN  pkt #30 header: addr=2 len=3 -> channel 2 |
| 13015 | **DUT** | OUT ch2 pkt #4 start: addr=2 len=3 (receiver waited 0 cycle(s)) |
| 13045 | **DUT** | IN  pkt #30 complete: addr=2 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 13045 | **DUT** | OUT ch1 pkt #1 done: 39 bytes in 49 cycles |
| 13045 | ch1 monitor | ch1 RX pkt #1: addr=1 len=37 parity=good |
| 13045 | scoreboard | ch1 pkt matched: addr=1 len=37 (5 matched so far) |
| 13045 | yapp monitor | RX pkt #30 on the input: addr=2 len=3 parity=good gap=16 |
| 13045 | reference | Packet forwarded: addr=2 len=3 -> channel 2 |
| 13050 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13050 | yapp driver | TX pkt #30 accepted by the DUT |
| 13050 | yapp driver | TX pkt #31: addr=2 len=55 parity=good delay=4 |
| 13065 | **DUT** | OUT ch2 pkt #4 done: 5 bytes in 6 cycles |
| 13065 | ch2 monitor | ch2 RX pkt #4: addr=2 len=3 parity=good |
| 13065 | scoreboard | ch2 pkt matched: addr=2 len=3 (6 matched so far) |
| 13095 | **DUT** | IN  pkt #31 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 54) |
| 13200 | ch1 driver | ch1: packet consumed (response delay 9) |
| 13655 | **DUT** | IN  pkt #31 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 13655 | yapp monitor | RX pkt #31 on the input: addr=2 len=55 parity=good gap=4 |
| 13655 | reference | Packet dropped: length 55 > maxpktsize 54 (addr=2) |
| 13655 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 13660 | ch2 driver | ch2: packet consumed (response delay 0) |
| 13660 | yapp driver | TX pkt #31 accepted by the DUT |
| 13660 | yapp driver | TX pkt #32: addr=2 len=53 parity=good delay=1 |
| 13675 | **DUT** | IN  pkt #32 header: addr=2 len=53 -> channel 2 |
| 13685 | **DUT** | OUT ch2 pkt #5 start: addr=2 len=53 (receiver waited 0 cycle(s)) |
| 14215 | **DUT** | IN  pkt #32 complete: addr=2 len=53 parity=ok forwarded, 55 bytes in 55 cycles (held 0) |
| 14215 | yapp monitor | RX pkt #32 on the input: addr=2 len=53 parity=good gap=1 |
| 14215 | reference | Packet forwarded: addr=2 len=53 -> channel 2 |
| 14220 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14220 | yapp driver | TX pkt #32 accepted by the DUT |
| 14220 | yapp driver | TX pkt #33: addr=1 len=63 parity=good delay=11 |
| 14235 | **DUT** | OUT ch2 pkt #5 done: 55 bytes in 56 cycles |
| 14235 | ch2 monitor | ch2 RX pkt #5: addr=2 len=53 parity=good |
| 14235 | scoreboard | ch2 pkt matched: addr=2 len=53 (7 matched so far) |
| 14335 | **DUT** | IN  pkt #33 header: addr=1 len=63 -> DROP (oversized: len 63 > maxpktsize 54) |
| 14430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 14975 | **DUT** | IN  pkt #33 complete: addr=1 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 14975 | yapp monitor | RX pkt #33 on the input: addr=1 len=63 parity=good gap=11 |
| 14975 | reference | Packet dropped: length 63 > maxpktsize 54 (addr=1) |
| 14975 | **DUT** | ROUTER DROPS PACKET addr=1 length=63 (length > maxpktsize) |
| 14980 | yapp driver | TX pkt #33 accepted by the DUT |
| 14980 | yapp driver | TX pkt #34: addr=1 len=55 parity=good delay=5 |
| 15035 | **DUT** | IN  pkt #34 header: addr=1 len=55 -> DROP (oversized: len 55 > maxpktsize 54) |
| 15595 | **DUT** | IN  pkt #34 complete: addr=1 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 15595 | yapp monitor | RX pkt #34 on the input: addr=1 len=55 parity=good gap=5 |
| 15595 | reference | Packet dropped: length 55 > maxpktsize 54 (addr=1) |
| 15595 | **DUT** | ROUTER DROPS PACKET addr=1 length=55 (length > maxpktsize) |
| 15600 | yapp driver | TX pkt #34 accepted by the DUT |
| 15600 | yapp driver | TX pkt #35: addr=3 len=53 parity=good delay=20 |
| 15805 | **DUT** | IN  pkt #35 header: addr=3 len=53 -> DROP (illegal address 3) |
| 16345 | **DUT** | IN  pkt #35 complete: addr=3 len=53 parity=ok dropped, 55 bytes in 55 cycles (held 0) |
| 16345 | yapp monitor | RX pkt #35 on the input: addr=3 len=53 parity=good gap=20 |
| 16345 | reference | Packet dropped: illegal address 3 (len=53) |
| 16345 | **DUT** | ROUTER DROPS PACKET addr=3 length=53 (    illegal address) |
| 16350 | yapp driver | TX pkt #35 accepted by the DUT |
| 16350 | yapp driver | TX pkt #36: addr=2 len=56 parity=good delay=16 |
| 16515 | **DUT** | IN  pkt #36 header: addr=2 len=56 -> DROP (oversized: len 56 > maxpktsize 54) |
| 17085 | **DUT** | IN  pkt #36 complete: addr=2 len=56 parity=ok dropped, 58 bytes in 58 cycles (held 0) |
| 17085 | yapp monitor | RX pkt #36 on the input: addr=2 len=56 parity=good gap=16 |
| 17085 | reference | Packet dropped: length 56 > maxpktsize 54 (addr=2) |
| 17085 | **DUT** | ROUTER DROPS PACKET addr=2 length=56 (length > maxpktsize) |
| 17090 | yapp driver | TX pkt #36 accepted by the DUT |
| 17090 | yapp driver | TX pkt #37: addr=2 len=55 parity=good delay=1 |
| 17105 | **DUT** | IN  pkt #37 header: addr=2 len=55 -> DROP (oversized: len 55 > maxpktsize 54) |
| 17665 | **DUT** | IN  pkt #37 complete: addr=2 len=55 parity=ok dropped, 57 bytes in 57 cycles (held 0) |
| 17665 | yapp monitor | RX pkt #37 on the input: addr=2 len=55 parity=good gap=1 |
| 17665 | reference | Packet dropped: length 55 > maxpktsize 54 (addr=2) |
| 17665 | **DUT** | ROUTER DROPS PACKET addr=2 length=55 (length > maxpktsize) |
| 17670 | yapp driver | TX pkt #37 accepted by the DUT |
| 17670 | **test** | STAGE: burst 2/4 sent: addr0..3 2/3/11/2, bad parity 0, gap 0 1, length 1..63 |
| 17690 | hbus driver | Executed WRITE addr=0x1000 data=0xbf |
| 17695 | **DUT** | CONFIG router_en=1 maxpktsize=63 |
| 17695 | hbus monitor | Collected WRITE addr=0x1000 data=0xbf |
| 17695 | reference | maxpktsize is now 63 |
| 17710 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 17715 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 17715 | reference | router_en is now 1 (en_reg 0xff) |
| 17730 | hbus driver | Executed WRITE addr=0x11fd data=0xef |
| 17735 | hbus monitor | Collected WRITE addr=0x11fd data=0xef |
| 17760 | hbus driver | Executed READ  addr=0x11fd data=0xef |
| 17765 | hbus monitor | Collected READ  addr=0x11fd data=0xef |
| 17790 | hbus driver | Executed READ  addr=0x10d0 data=0x00 |
| 17795 | hbus monitor | Collected READ  addr=0x10d0 data=0x00 |
| 17820 | hbus driver | Executed READ  addr=0x100d data=0x37 |
| 17825 | hbus monitor | Collected READ  addr=0x100d data=0x37 |
| 17850 | hbus driver | Executed READ  addr=0x1005 data=0x0a |
| 17855 | hbus monitor | Collected READ  addr=0x1005 data=0x0a |
| 17870 | hbus driver | Executed WRITE addr=0x1177 data=0x1d |
| 17875 | hbus monitor | Collected WRITE addr=0x1177 data=0x1d |
| 17900 | hbus driver | Executed READ  addr=0x1177 data=0x1d |
| 17900 | **test** | STAGE: burst 3/4: ctrl=0xbf (maxpktsize 63) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 17900 | yapp driver | TX pkt #38: addr=1 len=14 parity=good delay=15 |
| 17905 | hbus monitor | Collected READ  addr=0x1177 data=0x1d |
| 18065 | **DUT** | IN  pkt #38 header: addr=1 len=14 -> channel 1 |
| 18125 | **DUT** | OUT ch1 pkt #2 start: addr=1 len=14 (receiver waited 5 cycle(s)) |
| 18215 | **DUT** | IN  pkt #38 complete: addr=1 len=14 parity=ok forwarded, 16 bytes in 16 cycles (held 0) |
| 18215 | yapp monitor | RX pkt #38 on the input: addr=1 len=14 parity=good gap=39 |
| 18215 | reference | Packet forwarded: addr=1 len=14 -> channel 1 |
| 18220 | yapp driver | TX pkt #38 accepted by the DUT |
| 18220 | yapp driver | TX pkt #39: addr=2 len=63 parity=good delay=3 |
| 18255 | **DUT** | IN  pkt #39 header: addr=2 len=63 -> channel 2 |
| 18265 | **DUT** | OUT ch2 pkt #6 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 18270 | ch1 driver | ch1: packet consumed (response delay 5) |
| 18385 | **DUT** | OUT ch1 pkt #2 done: 16 bytes in 27 cycles |
| 18385 | ch1 monitor | ch1 RX pkt #2: addr=1 len=14 parity=good |
| 18385 | scoreboard | ch1 pkt matched: addr=1 len=14 (8 matched so far) |
| 18630 | ch1 driver | ch1: packet consumed (response delay 10) |
| 18895 | **DUT** | IN  pkt #39 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 18895 | yapp monitor | RX pkt #39 on the input: addr=2 len=63 parity=good gap=3 |
| 18895 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 18900 | ch2 driver | ch2: packet consumed (response delay 0) |
| 18900 | yapp driver | TX pkt #39 accepted by the DUT |
| 18900 | yapp driver | TX pkt #40: addr=2 len=49 parity=good delay=3 |
| 18915 | **DUT** | OUT ch2 pkt #6 done: 65 bytes in 66 cycles |
| 18915 | ch2 monitor | ch2 RX pkt #6: addr=2 len=63 parity=good |
| 18915 | scoreboard | ch2 pkt matched: addr=2 len=63 (9 matched so far) |
| 18935 | **DUT** | IN  pkt #40 header: addr=2 len=49 -> channel 2 |
| 18945 | **DUT** | OUT ch2 pkt #7 start: addr=2 len=49 (receiver waited 0 cycle(s)) |
| 19430 | ch2 driver | ch2: packet consumed (response delay 0) |
| 19435 | **DUT** | IN  pkt #40 complete: addr=2 len=49 parity=ok forwarded, 51 bytes in 51 cycles (held 0) |
| 19435 | yapp monitor | RX pkt #40 on the input: addr=2 len=49 parity=good gap=3 |
| 19435 | reference | Packet forwarded: addr=2 len=49 -> channel 2 |
| 19440 | yapp driver | TX pkt #40 accepted by the DUT |
| 19440 | yapp driver | TX pkt #41: addr=2 len=63 parity=good delay=0 |
| 19445 | **DUT** | IN  pkt #41 header: addr=2 len=63 -> channel 2 |
| 19455 | **DUT** | OUT ch2 pkt #7 done: 51 bytes in 52 cycles |
| 19455 | ch2 monitor | ch2 RX pkt #7: addr=2 len=49 parity=good |
| 19455 | scoreboard | ch2 pkt matched: addr=2 len=49 (10 matched so far) |
| 19465 | **DUT** | OUT ch2 pkt #8 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 19960 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20085 | **DUT** | IN  pkt #41 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 20085 | yapp monitor | RX pkt #41 on the input: addr=2 len=63 parity=good gap=0 |
| 20085 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 20090 | yapp driver | TX pkt #41 accepted by the DUT |
| 20090 | yapp driver | TX pkt #42: addr=1 len=1 parity=good delay=0 |
| 20095 | **DUT** | IN  pkt #42 header: addr=1 len=1 -> channel 1 |
| 20115 | **DUT** | IN  pkt #42 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 20115 | **DUT** | OUT ch2 pkt #8 done: 65 bytes in 66 cycles |
| 20115 | ch2 monitor | ch2 RX pkt #8: addr=2 len=63 parity=good |
| 20115 | scoreboard | ch2 pkt matched: addr=2 len=63 (11 matched so far) |
| 20115 | yapp monitor | RX pkt #42 on the input: addr=1 len=1 parity=good gap=0 |
| 20115 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 20120 | yapp driver | TX pkt #42 accepted by the DUT |
| 20120 | yapp driver | TX pkt #43: addr=0 len=8 parity=good delay=0 |
| 20125 | **DUT** | IN  pkt #43 header: addr=0 len=8 -> channel 0 |
| 20135 | **DUT** | OUT ch0 pkt #2 start: addr=0 len=8 (receiver waited 0 cycle(s)) |
| 20145 | **DUT** | OUT ch1 pkt #3 start: addr=1 len=1 (receiver waited 4 cycle(s)) |
| 20160 | ch1 driver | ch1: packet consumed (response delay 4) |
| 20175 | **DUT** | OUT ch1 pkt #3 done: 3 bytes in 4 cycles |
| 20175 | ch1 monitor | ch1 RX pkt #3: addr=1 len=1 parity=good |
| 20175 | scoreboard | ch1 pkt matched: addr=1 len=1 (12 matched so far) |
| 20180 | ch2 driver | ch2: packet consumed (response delay 0) |
| 20215 | **DUT** | IN  pkt #43 complete: addr=0 len=8 parity=ok forwarded, 10 bytes in 10 cycles (held 0) |
| 20215 | yapp monitor | RX pkt #43 on the input: addr=0 len=8 parity=good gap=0 |
| 20215 | reference | Packet forwarded: addr=0 len=8 -> channel 0 |
| 20220 | ch0 driver | ch0: packet consumed (response delay 0) |
| 20220 | yapp driver | TX pkt #43 accepted by the DUT |
| 20220 | yapp driver | TX pkt #44: addr=1 len=30 parity=good delay=15 |
| 20235 | **DUT** | OUT ch0 pkt #2 done: 10 bytes in 11 cycles |
| 20235 | ch0 monitor | ch0 RX pkt #2: addr=0 len=8 parity=good |
| 20235 | scoreboard | ch0 pkt matched: addr=0 len=8 (13 matched so far) |
| 20375 | **DUT** | IN  pkt #44 header: addr=1 len=30 -> channel 1 |
| 20385 | **DUT** | OUT ch1 pkt #4 start: addr=1 len=30 (receiver waited 0 cycle(s)) |
| 20590 | ch1 driver | ch1: packet consumed (response delay 0) |
| 20685 | **DUT** | IN  pkt #44 complete: addr=1 len=30 parity=ok forwarded, 32 bytes in 32 cycles (held 0) |
| 20685 | yapp monitor | RX pkt #44 on the input: addr=1 len=30 parity=good gap=15 |
| 20685 | reference | Packet forwarded: addr=1 len=30 -> channel 1 |
| 20690 | yapp driver | TX pkt #44 accepted by the DUT |
| 20690 | yapp driver | TX pkt #45: addr=2 len=63 parity=good delay=3 |
| 20725 | **DUT** | IN  pkt #45 header: addr=2 len=63 -> channel 2 |
| 20735 | **DUT** | OUT ch2 pkt #9 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 20805 | **DUT** | OUT ch1 pkt #4 done: 32 bytes in 43 cycles |
| 20805 | ch1 monitor | ch1 RX pkt #4: addr=1 len=30 parity=good |
| 20805 | scoreboard | ch1 pkt matched: addr=1 len=30 (14 matched so far) |
| 20820 | ch0 driver | ch0: packet consumed (response delay 0) |
| 21220 | ch1 driver | ch1: packet consumed (response delay 10) |
| 21365 | **DUT** | IN  pkt #45 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 21365 | yapp monitor | RX pkt #45 on the input: addr=2 len=63 parity=good gap=3 |
| 21365 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 21370 | ch2 driver | ch2: packet consumed (response delay 0) |
| 21370 | yapp driver | TX pkt #45 accepted by the DUT |
| 21370 | yapp driver | TX pkt #46: addr=2 len=1 parity=bad delay=16 |
| 21385 | **DUT** | OUT ch2 pkt #9 done: 65 bytes in 66 cycles |
| 21385 | ch2 monitor | ch2 RX pkt #9: addr=2 len=63 parity=good |
| 21385 | scoreboard | ch2 pkt matched: addr=2 len=63 (15 matched so far) |
| 21535 | **DUT** | IN  pkt #46 header: addr=2 len=1 -> channel 2 |
| 21545 | **DUT** | OUT ch2 pkt #10 start: addr=2 len=1 (receiver waited 0 cycle(s)) |
| 21555 | **DUT** | IN  pkt #46 complete: addr=2 len=1 parity=BAD forwarded, 3 bytes in 3 cycles (held 0) |
| 21555 | yapp monitor | RX pkt #46 on the input: addr=2 len=1 parity=bad gap=16 |
| 21555 | reference | Packet forwarded: addr=2 len=1 -> channel 2 |
| 21560 | yapp driver | TX pkt #46 accepted by the DUT |
| 21560 | yapp driver | TX pkt #47: addr=0 len=63 parity=good delay=1 |
| 21565 | **DUT** | OUT ch2 pkt #10 done: 3 bytes in 3 cycles |
| 21565 | ch2 monitor | ch2 RX pkt #10: addr=2 len=1 parity=bad |
| 21565 | scoreboard | ch2 pkt matched: addr=2 len=1 (16 matched so far) |
| 21575 | **DUT** | IN  pkt #47 header: addr=0 len=63 -> channel 0 |
| 21585 | **DUT** | OUT ch0 pkt #3 start: addr=0 len=63 (receiver waited 0 cycle(s)) |
| 21630 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 21630 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 21830 | ch2 driver | ch2: packet consumed (response delay 0) |
| 22215 | **DUT** | IN  pkt #47 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 22215 | yapp monitor | RX pkt #47 on the input: addr=0 len=63 parity=good gap=1 |
| 22215 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 22220 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22220 | yapp driver | TX pkt #47 accepted by the DUT |
| 22220 | yapp driver | TX pkt #48: addr=0 len=63 parity=good delay=15 |
| 22235 | **DUT** | OUT ch0 pkt #3 done: 65 bytes in 66 cycles |
| 22235 | ch0 monitor | ch0 RX pkt #3: addr=0 len=63 parity=good |
| 22235 | scoreboard | ch0 pkt matched: addr=0 len=63 (17 matched so far) |
| 22375 | **DUT** | IN  pkt #48 header: addr=0 len=63 -> channel 0 |
| 22385 | **DUT** | OUT ch0 pkt #4 start: addr=0 len=63 (receiver waited 0 cycle(s)) |
| 22520 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22670 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22750 | ch0 driver | ch0: packet consumed (response delay 0) |
| 22810 | ch0 driver | ch0: packet consumed (response delay 0) |
| 23015 | **DUT** | IN  pkt #48 complete: addr=0 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 23015 | yapp monitor | RX pkt #48 on the input: addr=0 len=63 parity=good gap=15 |
| 23015 | reference | Packet forwarded: addr=0 len=63 -> channel 0 |
| 23020 | yapp driver | TX pkt #48 accepted by the DUT |
| 23020 | yapp driver | TX pkt #49: addr=1 len=63 parity=good delay=1 |
| 23035 | **DUT** | IN  pkt #49 header: addr=1 len=63 -> channel 1 |
| 23040 | ch0 driver | ch0: packet consumed (response delay 0) |
| 23055 | **DUT** | OUT ch1 pkt #5 start: addr=1 len=63 (receiver waited 1 cycle(s)) |
| 23075 | **DUT** | OUT ch0 pkt #4 done: 65 bytes in 70 cycles |
| 23075 | ch0 monitor | ch0 RX pkt #4: addr=0 len=63 parity=good |
| 23075 | scoreboard | ch0 pkt matched: addr=0 len=63 (18 matched so far) |
| 23150 | ch0 driver | ch0: packet consumed (response delay 0) |
| 23675 | **DUT** | IN  pkt #49 complete: addr=1 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 23675 | yapp monitor | RX pkt #49 on the input: addr=1 len=63 parity=good gap=1 |
| 23675 | reference | Packet forwarded: addr=1 len=63 -> channel 1 |
| 23680 | yapp driver | TX pkt #49 accepted by the DUT |
| 23680 | yapp driver | TX pkt #50: addr=2 len=17 parity=good delay=0 |
| 23685 | **DUT** | IN  pkt #50 header: addr=2 len=17 -> channel 2 |
| 23690 | ch1 driver | ch1: packet consumed (response delay 1) |
| 23695 | **DUT** | OUT ch2 pkt #11 start: addr=2 len=17 (receiver waited 0 cycle(s)) |
| 23805 | **DUT** | OUT ch1 pkt #5 done: 65 bytes in 76 cycles |
| 23805 | ch1 monitor | ch1 RX pkt #5: addr=1 len=63 parity=good |
| 23805 | scoreboard | ch1 pkt matched: addr=1 len=63 (19 matched so far) |
| 23865 | **DUT** | IN  pkt #50 complete: addr=2 len=17 parity=ok forwarded, 19 bytes in 19 cycles (held 0) |
| 23865 | yapp monitor | RX pkt #50 on the input: addr=2 len=17 parity=good gap=0 |
| 23865 | reference | Packet forwarded: addr=2 len=17 -> channel 2 |
| 23870 | ch2 driver | ch2: packet consumed (response delay 0) |
| 23870 | yapp driver | TX pkt #50 accepted by the DUT |
| 23870 | yapp driver | TX pkt #51: addr=2 len=63 parity=good delay=19 |
| 23885 | **DUT** | OUT ch2 pkt #11 done: 19 bytes in 20 cycles |
| 23885 | ch2 monitor | ch2 RX pkt #11: addr=2 len=17 parity=good |
| 23885 | scoreboard | ch2 pkt matched: addr=2 len=17 (20 matched so far) |
| 23910 | ch1 driver | ch1: packet consumed (response delay 10) |
| 24000 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24065 | **DUT** | IN  pkt #51 header: addr=2 len=63 -> channel 2 |
| 24075 | **DUT** | OUT ch2 pkt #12 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 24705 | **DUT** | IN  pkt #51 complete: addr=2 len=63 parity=ok forwarded, 65 bytes in 65 cycles (held 0) |
| 24705 | yapp monitor | RX pkt #51 on the input: addr=2 len=63 parity=good gap=19 |
| 24705 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 24710 | ch2 driver | ch2: packet consumed (response delay 0) |
| 24710 | yapp driver | TX pkt #51 accepted by the DUT |
| 24710 | yapp driver | TX pkt #52: addr=2 len=63 parity=bad delay=0 |
| 24715 | **DUT** | IN  pkt #52 header: addr=2 len=63 -> channel 2 |
| 24725 | **DUT** | OUT ch2 pkt #12 done: 65 bytes in 66 cycles |
| 24725 | ch2 monitor | ch2 RX pkt #12: addr=2 len=63 parity=good |
| 24725 | scoreboard | ch2 pkt matched: addr=2 len=63 (21 matched so far) |
| 24735 | **DUT** | OUT ch2 pkt #13 start: addr=2 len=63 (receiver waited 0 cycle(s)) |
| 24850 | ch2 driver | ch2: packet consumed (response delay 0) |
| 25355 | **DUT** | IN  pkt #52 complete: addr=2 len=63 parity=BAD forwarded, 65 bytes in 65 cycles (held 0) |
| 25355 | yapp monitor | RX pkt #52 on the input: addr=2 len=63 parity=bad gap=0 |
| 25355 | reference | Packet forwarded: addr=2 len=63 -> channel 2 |
| 25360 | yapp driver | TX pkt #52 accepted by the DUT |
| 25360 | yapp driver | TX pkt #53: addr=0 len=62 parity=good delay=0 |
| 25365 | **DUT** | IN  pkt #53 header: addr=0 len=62 -> channel 0 |
| 25375 | **DUT** | OUT ch0 pkt #5 start: addr=0 len=62 (receiver waited 0 cycle(s)) |
| 25385 | **DUT** | OUT ch2 pkt #13 done: 65 bytes in 66 cycles |
| 25385 | ch2 monitor | ch2 RX pkt #13: addr=2 len=63 parity=bad |
| 25385 | scoreboard | ch2 pkt matched: addr=2 len=63 (22 matched so far) |
| 25390 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 25390 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 25490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 25995 | **DUT** | IN  pkt #53 complete: addr=0 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 25995 | yapp monitor | RX pkt #53 on the input: addr=0 len=62 parity=good gap=0 |
| 25995 | reference | Packet forwarded: addr=0 len=62 -> channel 0 |
| 26000 | ch0 driver | ch0: packet consumed (response delay 0) |
| 26000 | yapp driver | TX pkt #53 accepted by the DUT |
| 26000 | yapp driver | TX pkt #54: addr=2 len=7 parity=good delay=3 |
| 26015 | **DUT** | OUT ch0 pkt #5 done: 64 bytes in 65 cycles |
| 26015 | ch0 monitor | ch0 RX pkt #5: addr=0 len=62 parity=good |
| 26015 | scoreboard | ch0 pkt matched: addr=0 len=62 (23 matched so far) |
| 26035 | **DUT** | IN  pkt #54 header: addr=2 len=7 -> channel 2 |
| 26045 | **DUT** | OUT ch2 pkt #14 start: addr=2 len=7 (receiver waited 0 cycle(s)) |
| 26115 | **DUT** | IN  pkt #54 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 26115 | yapp monitor | RX pkt #54 on the input: addr=2 len=7 parity=good gap=3 |
| 26115 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 26120 | ch2 driver | ch2: packet consumed (response delay 0) |
| 26120 | yapp driver | TX pkt #54 accepted by the DUT |
| 26120 | yapp driver | TX pkt #55: addr=3 len=1 parity=good delay=13 |
| 26135 | **DUT** | OUT ch2 pkt #14 done: 9 bytes in 10 cycles |
| 26135 | ch2 monitor | ch2 RX pkt #14: addr=2 len=7 parity=good |
| 26135 | scoreboard | ch2 pkt matched: addr=2 len=7 (24 matched so far) |
| 26255 | **DUT** | IN  pkt #55 header: addr=3 len=1 -> DROP (illegal address 3) |
| 26275 | **DUT** | IN  pkt #55 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 26275 | yapp monitor | RX pkt #55 on the input: addr=3 len=1 parity=good gap=13 |
| 26275 | reference | Packet dropped: illegal address 3 (len=1) |
| 26275 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 26280 | yapp driver | TX pkt #55 accepted by the DUT |
| 26280 | **test** | STAGE: burst 3/4 sent: addr0..3 4/4/9/1, bad parity 2, gap 0 6, length 1..63 |
| 26300 | hbus driver | Executed WRITE addr=0x1000 data=0x3e |
| 26305 | **DUT** | CONFIG router_en=1 maxpktsize=62 |
| 26305 | hbus monitor | Collected WRITE addr=0x1000 data=0x3e |
| 26305 | reference | maxpktsize is now 62 |
| 26310 | ch0 driver | ch0: packet consumed (response delay 0) |
| 26320 | hbus driver | Executed WRITE addr=0x1001 data=0xff |
| 26325 | hbus monitor | Collected WRITE addr=0x1001 data=0xff |
| 26325 | reference | router_en is now 1 (en_reg 0xff) |
| 26350 | hbus driver | Executed READ  addr=0x1036 data=0x23 |
| 26355 | hbus monitor | Collected READ  addr=0x1036 data=0x23 |
| 26380 | hbus driver | Executed READ  addr=0x107d data=0x00 |
| 26385 | hbus monitor | Collected READ  addr=0x107d data=0x00 |
| 26400 | hbus driver | Executed WRITE addr=0x119b data=0x6d |
| 26405 | hbus monitor | Collected WRITE addr=0x119b data=0x6d |
| 26430 | hbus driver | Executed READ  addr=0x119b data=0x6d |
| 26435 | hbus monitor | Collected READ  addr=0x119b data=0x6d |
| 26460 | hbus driver | Executed READ  addr=0x10fd data=0x00 |
| 26465 | hbus monitor | Collected READ  addr=0x10fd data=0x00 |
| 26480 | hbus driver | Executed WRITE addr=0x1109 data=0x23 |
| 26485 | hbus monitor | Collected WRITE addr=0x1109 data=0x23 |
| 26510 | hbus driver | Executed READ  addr=0x1109 data=0x23 |
| 26515 | hbus monitor | Collected READ  addr=0x1109 data=0x23 |
| 26530 | hbus driver | Executed WRITE addr=0x1183 data=0xaf |
| 26535 | hbus monitor | Collected WRITE addr=0x1183 data=0xaf |
| 26560 | hbus driver | Executed READ  addr=0x1183 data=0xaf |
| 26560 | **test** | STAGE: burst 4/4: ctrl=0x3e (maxpktsize 62) en=0xff (router on, counter enables 1111111), 18 packet(s) |
| 26560 | yapp driver | TX pkt #56: addr=2 len=7 parity=good delay=3 |
| 26565 | hbus monitor | Collected READ  addr=0x1183 data=0xaf |
| 26605 | **DUT** | IN  pkt #56 header: addr=2 len=7 -> channel 2 |
| 26615 | **DUT** | OUT ch2 pkt #15 start: addr=2 len=7 (receiver waited 0 cycle(s)) |
| 26685 | **DUT** | IN  pkt #56 complete: addr=2 len=7 parity=ok forwarded, 9 bytes in 9 cycles (held 0) |
| 26685 | yapp monitor | RX pkt #56 on the input: addr=2 len=7 parity=good gap=32 |
| 26685 | reference | Packet forwarded: addr=2 len=7 -> channel 2 |
| 26690 | yapp driver | TX pkt #56 accepted by the DUT |
| 26690 | yapp driver | TX pkt #57: addr=2 len=63 parity=good delay=0 |
| 26695 | **DUT** | IN  pkt #57 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 26695 | **DUT** | OUT ch2 pkt #15 done: 9 bytes in 9 cycles |
| 26695 | ch2 monitor | ch2 RX pkt #15: addr=2 len=7 parity=good |
| 26695 | scoreboard | ch2 pkt matched: addr=2 len=7 (25 matched so far) |
| 26760 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27335 | **DUT** | IN  pkt #57 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 27335 | yapp monitor | RX pkt #57 on the input: addr=2 len=63 parity=good gap=0 |
| 27335 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 27335 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 27340 | yapp driver | TX pkt #57 accepted by the DUT |
| 27340 | yapp driver | TX pkt #58: addr=2 len=51 parity=good delay=0 |
| 27345 | **DUT** | IN  pkt #58 header: addr=2 len=51 -> channel 2 |
| 27355 | **DUT** | OUT ch2 pkt #16 start: addr=2 len=51 (receiver waited 0 cycle(s)) |
| 27865 | **DUT** | IN  pkt #58 complete: addr=2 len=51 parity=ok forwarded, 53 bytes in 53 cycles (held 0) |
| 27865 | yapp monitor | RX pkt #58 on the input: addr=2 len=51 parity=good gap=0 |
| 27865 | reference | Packet forwarded: addr=2 len=51 -> channel 2 |
| 27870 | ch2 driver | ch2: packet consumed (response delay 0) |
| 27870 | yapp driver | TX pkt #58 accepted by the DUT |
| 27870 | yapp driver | TX pkt #59: addr=1 len=3 parity=good delay=17 |
| 27885 | **DUT** | OUT ch2 pkt #16 done: 53 bytes in 54 cycles |
| 27885 | ch2 monitor | ch2 RX pkt #16: addr=2 len=51 parity=good |
| 27885 | scoreboard | ch2 pkt matched: addr=2 len=51 (26 matched so far) |
| 28045 | **DUT** | IN  pkt #59 header: addr=1 len=3 -> channel 1 |
| 28085 | **DUT** | IN  pkt #59 complete: addr=1 len=3 parity=ok forwarded, 5 bytes in 5 cycles (held 0) |
| 28085 | yapp monitor | RX pkt #59 on the input: addr=1 len=3 parity=good gap=17 |
| 28085 | reference | Packet forwarded: addr=1 len=3 -> channel 1 |
| 28090 | yapp driver | TX pkt #59 accepted by the DUT |
| 28090 | yapp driver | TX pkt #60: addr=3 len=1 parity=good delay=3 |
| 28105 | **DUT** | OUT ch1 pkt #6 start: addr=1 len=3 (receiver waited 5 cycle(s)) |
| 28125 | **DUT** | IN  pkt #60 header: addr=3 len=1 -> DROP (illegal address 3) |
| 28140 | ch1 driver | ch1: packet consumed (response delay 5) |
| 28145 | **DUT** | IN  pkt #60 complete: addr=3 len=1 parity=ok dropped, 3 bytes in 3 cycles (held 0) |
| 28145 | yapp monitor | RX pkt #60 on the input: addr=3 len=1 parity=good gap=3 |
| 28145 | reference | Packet dropped: illegal address 3 (len=1) |
| 28145 | **DUT** | ROUTER DROPS PACKET addr=3 length=1 (    illegal address) |
| 28150 | yapp driver | TX pkt #60 accepted by the DUT |
| 28150 | yapp driver | TX pkt #61: addr=1 len=52 parity=good delay=0 |
| 28155 | **DUT** | IN  pkt #61 header: addr=1 len=52 -> channel 1 |
| 28165 | **DUT** | OUT ch1 pkt #6 done: 5 bytes in 7 cycles |
| 28165 | ch1 monitor | ch1 RX pkt #6: addr=1 len=3 parity=good |
| 28165 | scoreboard | ch1 pkt matched: addr=1 len=3 (27 matched so far) |
| 28175 | **DUT** | OUT ch1 pkt #7 start: addr=1 len=52 (receiver waited 0 cycle(s)) |
| 28410 | ch1 driver | ch1: packet consumed (response delay 1) |
| 28420 | ch2 driver | ch2: packet consumed (response delay 0) |
| 28685 | **DUT** | IN  pkt #61 complete: addr=1 len=52 parity=ok forwarded, 54 bytes in 54 cycles (held 0) |
| 28685 | yapp monitor | RX pkt #61 on the input: addr=1 len=52 parity=good gap=0 |
| 28685 | reference | Packet forwarded: addr=1 len=52 -> channel 1 |
| 28690 | yapp driver | TX pkt #61 accepted by the DUT |
| 28690 | yapp driver | TX pkt #62: addr=2 len=62 parity=good delay=1 |
| 28705 | **DUT** | IN  pkt #62 header: addr=2 len=62 -> channel 2 |
| 28715 | **DUT** | OUT ch2 pkt #17 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 28775 | **DUT** | OUT ch1 pkt #7 done: 54 bytes in 61 cycles |
| 28775 | ch1 monitor | ch1 RX pkt #7: addr=1 len=52 parity=good |
| 28775 | scoreboard | ch1 pkt matched: addr=1 len=52 (28 matched so far) |
| 29030 | ch1 driver | ch1: packet consumed (response delay 6) |
| 29335 | **DUT** | IN  pkt #62 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 29335 | yapp monitor | RX pkt #62 on the input: addr=2 len=62 parity=good gap=1 |
| 29335 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 29340 | ch2 driver | ch2: packet consumed (response delay 0) |
| 29340 | yapp driver | TX pkt #62 accepted by the DUT |
| 29340 | yapp driver | TX pkt #63: addr=3 len=62 parity=good delay=0 |
| 29345 | **DUT** | IN  pkt #63 header: addr=3 len=62 -> DROP (illegal address 3) |
| 29355 | **DUT** | OUT ch2 pkt #17 done: 64 bytes in 65 cycles |
| 29355 | ch2 monitor | ch2 RX pkt #17: addr=2 len=62 parity=good |
| 29355 | scoreboard | ch2 pkt matched: addr=2 len=62 (29 matched so far) |
| 29940 | ch2 driver | ch2: packet consumed (response delay 0) |
| 29975 | **DUT** | IN  pkt #63 complete: addr=3 len=62 parity=ok dropped, 64 bytes in 64 cycles (held 0) |
| 29975 | yapp monitor | RX pkt #63 on the input: addr=3 len=62 parity=good gap=0 |
| 29975 | reference | Packet dropped: illegal address 3 (len=62) |
| 29975 | **DUT** | ROUTER DROPS PACKET addr=3 length=62 (    illegal address) |
| 29980 | yapp driver | TX pkt #63 accepted by the DUT |
| 29980 | yapp driver | TX pkt #64: addr=2 len=53 parity=good delay=20 |
| 30185 | **DUT** | IN  pkt #64 header: addr=2 len=53 -> channel 2 |
| 30195 | **DUT** | OUT ch2 pkt #18 start: addr=2 len=53 (receiver waited 0 cycle(s)) |
| 30725 | **DUT** | IN  pkt #64 complete: addr=2 len=53 parity=ok forwarded, 55 bytes in 55 cycles (held 0) |
| 30725 | yapp monitor | RX pkt #64 on the input: addr=2 len=53 parity=good gap=20 |
| 30725 | reference | Packet forwarded: addr=2 len=53 -> channel 2 |
| 30730 | ch2 driver | ch2: packet consumed (response delay 0) |
| 30730 | yapp driver | TX pkt #64 accepted by the DUT |
| 30730 | yapp driver | TX pkt #65: addr=1 len=32 parity=good delay=0 |
| 30735 | **DUT** | IN  pkt #65 header: addr=1 len=32 -> channel 1 |
| 30745 | **DUT** | OUT ch2 pkt #18 done: 55 bytes in 56 cycles |
| 30745 | ch2 monitor | ch2 RX pkt #18: addr=2 len=53 parity=good |
| 30745 | scoreboard | ch2 pkt matched: addr=2 len=53 (30 matched so far) |
| 30825 | **DUT** | OUT ch1 pkt #8 start: addr=1 len=32 (receiver waited 8 cycle(s)) |
| 31065 | **DUT** | IN  pkt #65 complete: addr=1 len=32 parity=ok forwarded, 34 bytes in 34 cycles (held 0) |
| 31065 | yapp monitor | RX pkt #65 on the input: addr=1 len=32 parity=good gap=0 |
| 31065 | reference | Packet forwarded: addr=1 len=32 -> channel 1 |
| 31070 | yapp driver | TX pkt #65 accepted by the DUT |
| 31070 | yapp driver | TX pkt #66: addr=0 len=63 parity=bad delay=20 |
| 31080 | ch2 driver | ch2: packet consumed (response delay 0) |
| 31150 | ch1 driver | ch1: packet consumed (response delay 8) |
| 31265 | **DUT** | OUT ch1 pkt #8 done: 34 bytes in 45 cycles |
| 31265 | ch1 monitor | ch1 RX pkt #8: addr=1 len=32 parity=good |
| 31265 | scoreboard | ch1 pkt matched: addr=1 len=32 (31 matched so far) |
| 31275 | **DUT** | IN  pkt #66 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 31890 | ch1 driver | ch1: packet consumed (response delay 10) |
| 31915 | **DUT** | IN  pkt #66 complete: addr=0 len=63 parity=BAD dropped, 65 bytes in 65 cycles (held 0) |
| 31915 | yapp monitor | RX pkt #66 on the input: addr=0 len=63 parity=bad gap=20 |
| 31915 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 31915 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 31920 | yapp driver | TX pkt #66 accepted by the DUT |
| 31920 | yapp driver | TX pkt #67: addr=0 len=63 parity=good delay=0 |
| 31925 | **DUT** | IN  pkt #67 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 31950 | **DUT** | ERROR pulse, 3 cycle(s) after the bad-parity packet |
| 31950 | error checker | error pulse 3 cycles after the bad packet (0 still owed) |
| 32565 | **DUT** | IN  pkt #67 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 32565 | yapp monitor | RX pkt #67 on the input: addr=0 len=63 parity=good gap=0 |
| 32565 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 32565 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 32570 | yapp driver | TX pkt #67 accepted by the DUT |
| 32570 | yapp driver | TX pkt #68: addr=2 len=63 parity=good delay=20 |
| 32775 | **DUT** | IN  pkt #68 header: addr=2 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 33415 | **DUT** | IN  pkt #68 complete: addr=2 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 33415 | yapp monitor | RX pkt #68 on the input: addr=2 len=63 parity=good gap=20 |
| 33415 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=2) |
| 33415 | **DUT** | ROUTER DROPS PACKET addr=2 length=63 (length > maxpktsize) |
| 33420 | yapp driver | TX pkt #68 accepted by the DUT |
| 33420 | yapp driver | TX pkt #69: addr=1 len=1 parity=good delay=2 |
| 33445 | **DUT** | IN  pkt #69 header: addr=1 len=1 -> channel 1 |
| 33465 | **DUT** | IN  pkt #69 complete: addr=1 len=1 parity=ok forwarded, 3 bytes in 3 cycles (held 0) |
| 33465 | yapp monitor | RX pkt #69 on the input: addr=1 len=1 parity=good gap=2 |
| 33465 | reference | Packet forwarded: addr=1 len=1 -> channel 1 |
| 33470 | yapp driver | TX pkt #69 accepted by the DUT |
| 33470 | yapp driver | TX pkt #70: addr=2 len=38 parity=bad delay=17 |
| 33545 | **DUT** | OUT ch1 pkt #9 start: addr=1 len=1 (receiver waited 9 cycle(s)) |
| 33560 | ch1 driver | ch1: packet consumed (response delay 9) |
| 33645 | **DUT** | IN  pkt #70 header: addr=2 len=38 -> channel 2 |
| 33655 | **DUT** | OUT ch2 pkt #19 start: addr=2 len=38 (receiver waited 0 cycle(s)) |
| 33665 | **DUT** | OUT ch1 pkt #9 done: 3 bytes in 13 cycles |
| 33665 | ch1 monitor | ch1 RX pkt #9: addr=1 len=1 parity=good |
| 33665 | scoreboard | ch1 pkt matched: addr=1 len=1 (32 matched so far) |
| 33920 | ch1 driver | ch1: packet consumed (response delay 9) |
| 34035 | **DUT** | IN  pkt #70 complete: addr=2 len=38 parity=BAD forwarded, 40 bytes in 40 cycles (held 0) |
| 34035 | yapp monitor | RX pkt #70 on the input: addr=2 len=38 parity=bad gap=17 |
| 34035 | reference | Packet forwarded: addr=2 len=38 -> channel 2 |
| 34040 | ch2 driver | ch2: packet consumed (response delay 0) |
| 34040 | yapp driver | TX pkt #70 accepted by the DUT |
| 34040 | yapp driver | TX pkt #71: addr=0 len=16 parity=good delay=10 |
| 34055 | **DUT** | OUT ch2 pkt #19 done: 40 bytes in 41 cycles |
| 34055 | ch2 monitor | ch2 RX pkt #19: addr=2 len=38 parity=bad |
| 34055 | scoreboard | ch2 pkt matched: addr=2 len=38 (33 matched so far) |
| 34110 | **DUT** | ERROR pulse, 7 cycle(s) after the bad-parity packet |
| 34110 | error checker | error pulse 7 cycles after the bad packet (0 still owed) |
| 34145 | **DUT** | IN  pkt #71 header: addr=0 len=16 -> channel 0 |
| 34155 | **DUT** | OUT ch0 pkt #6 start: addr=0 len=16 (receiver waited 0 cycle(s)) |
| 34315 | **DUT** | IN  pkt #71 complete: addr=0 len=16 parity=ok forwarded, 18 bytes in 18 cycles (held 0) |
| 34315 | yapp monitor | RX pkt #71 on the input: addr=0 len=16 parity=good gap=10 |
| 34315 | reference | Packet forwarded: addr=0 len=16 -> channel 0 |
| 34320 | ch0 driver | ch0: packet consumed (response delay 0) |
| 34320 | yapp driver | TX pkt #71 accepted by the DUT |
| 34320 | yapp driver | TX pkt #72: addr=0 len=63 parity=good delay=0 |
| 34325 | **DUT** | IN  pkt #72 header: addr=0 len=63 -> DROP (oversized: len 63 > maxpktsize 62) |
| 34335 | **DUT** | OUT ch0 pkt #6 done: 18 bytes in 19 cycles |
| 34335 | ch0 monitor | ch0 RX pkt #6: addr=0 len=16 parity=good |
| 34335 | scoreboard | ch0 pkt matched: addr=0 len=16 (34 matched so far) |
| 34490 | ch2 driver | ch2: packet consumed (response delay 0) |
| 34710 | ch0 driver | ch0: packet consumed (response delay 0) |
| 34965 | **DUT** | IN  pkt #72 complete: addr=0 len=63 parity=ok dropped, 65 bytes in 65 cycles (held 0) |
| 34965 | yapp monitor | RX pkt #72 on the input: addr=0 len=63 parity=good gap=0 |
| 34965 | reference | Packet dropped: length 63 > maxpktsize 62 (addr=0) |
| 34965 | **DUT** | ROUTER DROPS PACKET addr=0 length=63 (length > maxpktsize) |
| 34970 | yapp driver | TX pkt #72 accepted by the DUT |
| 34970 | yapp driver | TX pkt #73: addr=2 len=62 parity=good delay=20 |
| 35175 | **DUT** | IN  pkt #73 header: addr=2 len=62 -> channel 2 |
| 35185 | **DUT** | OUT ch2 pkt #20 start: addr=2 len=62 (receiver waited 0 cycle(s)) |
| 35805 | **DUT** | IN  pkt #73 complete: addr=2 len=62 parity=ok forwarded, 64 bytes in 64 cycles (held 0) |
| 35805 | yapp monitor | RX pkt #73 on the input: addr=2 len=62 parity=good gap=20 |
| 35805 | reference | Packet forwarded: addr=2 len=62 -> channel 2 |
| 35810 | ch2 driver | ch2: packet consumed (response delay 0) |
| 35810 | yapp driver | TX pkt #73 accepted by the DUT |
| 35810 | **test** | STAGE: burst 4/4 sent: addr0..3 4/4/8/2, bad parity 2, gap 0 7, length 1..63 |
| 35810 | **test** | STAGE: final reads: every register and the stored packet, checked against the reference model |
| 35825 | **DUT** | OUT ch2 pkt #20 done: 64 bytes in 65 cycles |
| 35825 | ch2 monitor | ch2 RX pkt #20: addr=2 len=62 parity=good |
| 35825 | scoreboard | ch2 pkt matched: addr=2 len=62 (35 matched so far) |
| 35840 | hbus driver | Executed READ  addr=0x1000 data=0x3e |
| 35845 | hbus monitor | Collected READ  addr=0x1000 data=0x3e |
| 35870 | hbus driver | Executed READ  addr=0x1001 data=0xff |
| 35875 | hbus monitor | Collected READ  addr=0x1001 data=0xff |
| 35900 | hbus driver | Executed READ  addr=0x1004 data=0x04 |
| 35905 | hbus monitor | Collected READ  addr=0x1004 data=0x04 |
| 35930 | hbus driver | Executed READ  addr=0x1005 data=0x0f |
| 35935 | hbus monitor | Collected READ  addr=0x1005 data=0x0f |
| 35960 | hbus driver | Executed READ  addr=0x1006 data=0x0a |
| 35965 | hbus monitor | Collected READ  addr=0x1006 data=0x0a |
| 35990 | hbus driver | Executed READ  addr=0x1009 data=0x0e |
| 35995 | hbus monitor | Collected READ  addr=0x1009 data=0x0e |
| 36020 | hbus driver | Executed READ  addr=0x100a data=0x0b |
| 36025 | hbus monitor | Collected READ  addr=0x100a data=0x0b |
| 36050 | hbus driver | Executed READ  addr=0x100b data=0x21 |
| 36055 | hbus monitor | Collected READ  addr=0x100b data=0x21 |
| 36080 | hbus driver | Executed READ  addr=0x100d data=0x3e |
| 36085 | hbus monitor | Collected READ  addr=0x100d data=0x3e |
| 36110 | hbus driver | Executed READ  addr=0x1010 data=0xfa |
| 36115 | hbus monitor | Collected READ  addr=0x1010 data=0xfa |
| 36140 | hbus driver | Executed READ  addr=0x1011 data=0xbd |
| 36145 | hbus monitor | Collected READ  addr=0x1011 data=0xbd |
| 36170 | hbus driver | Executed READ  addr=0x1012 data=0xea |
| 36175 | hbus monitor | Collected READ  addr=0x1012 data=0xea |
| 36200 | hbus driver | Executed READ  addr=0x1013 data=0x0a |
| 36205 | hbus monitor | Collected READ  addr=0x1013 data=0x0a |
| 36230 | hbus driver | Executed READ  addr=0x1014 data=0x27 |
| 36235 | hbus monitor | Collected READ  addr=0x1014 data=0x27 |
| 36260 | hbus driver | Executed READ  addr=0x1015 data=0x5c |
| 36265 | hbus monitor | Collected READ  addr=0x1015 data=0x5c |
| 36290 | hbus driver | Executed READ  addr=0x1016 data=0x25 |
| 36295 | hbus monitor | Collected READ  addr=0x1016 data=0x25 |
| 36310 | ch2 driver | ch2: packet consumed (response delay 0) |
| 36320 | hbus driver | Executed READ  addr=0x1017 data=0x3a |
| 36325 | hbus monitor | Collected READ  addr=0x1017 data=0x3a |
| 36350 | hbus driver | Executed READ  addr=0x1018 data=0x32 |
| 36355 | hbus monitor | Collected READ  addr=0x1018 data=0x32 |
| 36380 | hbus driver | Executed READ  addr=0x1019 data=0x49 |
| 36385 | hbus monitor | Collected READ  addr=0x1019 data=0x49 |
| 36410 | hbus driver | Executed READ  addr=0x101a data=0x46 |
| 36415 | hbus monitor | Collected READ  addr=0x101a data=0x46 |
| 36440 | hbus driver | Executed READ  addr=0x101b data=0x2a |
| 36445 | hbus monitor | Collected READ  addr=0x101b data=0x2a |
| 36470 | hbus driver | Executed READ  addr=0x101c data=0xf3 |
| 36475 | hbus monitor | Collected READ  addr=0x101c data=0xf3 |
| 36500 | hbus driver | Executed READ  addr=0x101d data=0x6c |
| 36505 | hbus monitor | Collected READ  addr=0x101d data=0x6c |
| 36530 | hbus driver | Executed READ  addr=0x101e data=0xad |
| 36535 | hbus monitor | Collected READ  addr=0x101e data=0xad |
| 36560 | hbus driver | Executed READ  addr=0x101f data=0x02 |
| 36565 | hbus monitor | Collected READ  addr=0x101f data=0x02 |
| 36590 | hbus driver | Executed READ  addr=0x1020 data=0x44 |
| 36595 | hbus monitor | Collected READ  addr=0x1020 data=0x44 |
| 36620 | hbus driver | Executed READ  addr=0x1021 data=0x10 |
| 36625 | hbus monitor | Collected READ  addr=0x1021 data=0x10 |
| 36650 | hbus driver | Executed READ  addr=0x1022 data=0xcb |
| 36655 | hbus monitor | Collected READ  addr=0x1022 data=0xcb |
| 36680 | hbus driver | Executed READ  addr=0x1023 data=0x36 |
| 36685 | hbus monitor | Collected READ  addr=0x1023 data=0x36 |
| 36710 | hbus driver | Executed READ  addr=0x1024 data=0x2e |
| 36715 | hbus monitor | Collected READ  addr=0x1024 data=0x2e |
| 36740 | hbus driver | Executed READ  addr=0x1025 data=0x48 |
| 36745 | hbus monitor | Collected READ  addr=0x1025 data=0x48 |
| 36770 | hbus driver | Executed READ  addr=0x1026 data=0x91 |
| 36775 | hbus monitor | Collected READ  addr=0x1026 data=0x91 |
| 36800 | hbus driver | Executed READ  addr=0x1027 data=0x42 |
| 36805 | hbus monitor | Collected READ  addr=0x1027 data=0x42 |
| 36830 | hbus driver | Executed READ  addr=0x1028 data=0xac |
| 36835 | hbus monitor | Collected READ  addr=0x1028 data=0xac |
| 36860 | hbus driver | Executed READ  addr=0x1029 data=0x98 |
| 36865 | hbus monitor | Collected READ  addr=0x1029 data=0x98 |
| 36890 | hbus driver | Executed READ  addr=0x102a data=0x38 |
| 36895 | hbus monitor | Collected READ  addr=0x102a data=0x38 |
| 36920 | hbus driver | Executed READ  addr=0x102b data=0x6e |
| 36925 | hbus monitor | Collected READ  addr=0x102b data=0x6e |
| 36950 | hbus driver | Executed READ  addr=0x102c data=0x6b |
| 36955 | hbus monitor | Collected READ  addr=0x102c data=0x6b |
| 36980 | hbus driver | Executed READ  addr=0x102d data=0xa7 |
| 36985 | hbus monitor | Collected READ  addr=0x102d data=0xa7 |
| 37010 | hbus driver | Executed READ  addr=0x102e data=0x12 |
| 37015 | hbus monitor | Collected READ  addr=0x102e data=0x12 |
| 37040 | hbus driver | Executed READ  addr=0x102f data=0xea |
| 37045 | hbus monitor | Collected READ  addr=0x102f data=0xea |
| 37070 | hbus driver | Executed READ  addr=0x1030 data=0x15 |
| 37075 | hbus monitor | Collected READ  addr=0x1030 data=0x15 |
| 37100 | hbus driver | Executed READ  addr=0x1031 data=0xc5 |
| 37105 | hbus monitor | Collected READ  addr=0x1031 data=0xc5 |
| 37130 | hbus driver | Executed READ  addr=0x1032 data=0xa4 |
| 37135 | hbus monitor | Collected READ  addr=0x1032 data=0xa4 |
| 37160 | hbus driver | Executed READ  addr=0x1033 data=0x0d |
| 37165 | hbus monitor | Collected READ  addr=0x1033 data=0x0d |
| 37190 | hbus driver | Executed READ  addr=0x1034 data=0x05 |
| 37195 | hbus monitor | Collected READ  addr=0x1034 data=0x05 |
| 37220 | hbus driver | Executed READ  addr=0x1035 data=0xb1 |
| 37225 | hbus monitor | Collected READ  addr=0x1035 data=0xb1 |
| 37250 | hbus driver | Executed READ  addr=0x1036 data=0x34 |
| 37255 | hbus monitor | Collected READ  addr=0x1036 data=0x34 |
| 37280 | hbus driver | Executed READ  addr=0x1037 data=0xce |
| 37285 | hbus monitor | Collected READ  addr=0x1037 data=0xce |
| 37310 | hbus driver | Executed READ  addr=0x1038 data=0xad |
| 37315 | hbus monitor | Collected READ  addr=0x1038 data=0xad |
| 37340 | hbus driver | Executed READ  addr=0x1039 data=0x2b |
| 37345 | hbus monitor | Collected READ  addr=0x1039 data=0x2b |
| 37370 | hbus driver | Executed READ  addr=0x103a data=0x9f |
| 37375 | hbus monitor | Collected READ  addr=0x103a data=0x9f |
| 37400 | hbus driver | Executed READ  addr=0x103b data=0x37 |
| 37405 | hbus monitor | Collected READ  addr=0x103b data=0x37 |
| 37430 | hbus driver | Executed READ  addr=0x103c data=0x9d |
| 37435 | hbus monitor | Collected READ  addr=0x103c data=0x9d |
| 37460 | hbus driver | Executed READ  addr=0x103d data=0x3b |
| 37465 | hbus monitor | Collected READ  addr=0x103d data=0x3b |
| 37490 | hbus driver | Executed READ  addr=0x103e data=0x61 |
| 37495 | hbus monitor | Collected READ  addr=0x103e data=0x61 |
| 37520 | hbus driver | Executed READ  addr=0x103f data=0xe9 |
| 37525 | hbus monitor | Collected READ  addr=0x103f data=0xe9 |
| 37550 | hbus driver | Executed READ  addr=0x1040 data=0x69 |
| 37555 | hbus monitor | Collected READ  addr=0x1040 data=0x69 |
| 37580 | hbus driver | Executed READ  addr=0x1041 data=0x95 |
| 37585 | hbus monitor | Collected READ  addr=0x1041 data=0x95 |
| 37610 | hbus driver | Executed READ  addr=0x1042 data=0x31 |
| 37615 | hbus monitor | Collected READ  addr=0x1042 data=0x31 |
| 37640 | hbus driver | Executed READ  addr=0x1043 data=0xdf |
| 37645 | hbus monitor | Collected READ  addr=0x1043 data=0xdf |
| 37670 | hbus driver | Executed READ  addr=0x1044 data=0x8b |
| 37675 | hbus monitor | Collected READ  addr=0x1044 data=0x8b |
| 37700 | hbus driver | Executed READ  addr=0x1045 data=0xcb |
| 37705 | hbus monitor | Collected READ  addr=0x1045 data=0xcb |
| 37730 | hbus driver | Executed READ  addr=0x1046 data=0x03 |
| 37735 | hbus monitor | Collected READ  addr=0x1046 data=0x03 |
| 37760 | hbus driver | Executed READ  addr=0x1047 data=0x9e |
| 37765 | hbus monitor | Collected READ  addr=0x1047 data=0x9e |
| 37790 | hbus driver | Executed READ  addr=0x1048 data=0xd9 |
| 37795 | hbus monitor | Collected READ  addr=0x1048 data=0xd9 |
| 37820 | hbus driver | Executed READ  addr=0x1049 data=0x40 |
| 37825 | hbus monitor | Collected READ  addr=0x1049 data=0x40 |
| 37850 | hbus driver | Executed READ  addr=0x104a data=0xc8 |
| 37855 | hbus monitor | Collected READ  addr=0x104a data=0xc8 |
| 37880 | hbus driver | Executed READ  addr=0x104b data=0x63 |
| 37885 | hbus monitor | Collected READ  addr=0x104b data=0x63 |
| 37910 | hbus driver | Executed READ  addr=0x104c data=0x89 |
| 37915 | hbus monitor | Collected READ  addr=0x104c data=0x89 |
| 37940 | hbus driver | Executed READ  addr=0x104d data=0x85 |
| 37945 | hbus monitor | Collected READ  addr=0x104d data=0x85 |
| 37970 | hbus driver | Executed READ  addr=0x104e data=0xab |
| 37975 | hbus monitor | Collected READ  addr=0x104e data=0xab |
| 38085 | **test** | STAGE: done: 73 packets (35 forwarded, 38 dropped), 0 storm burst(s), 35 scoreboard matches, 95 HBUS reads checked, 4 error pulses for 4 bad packets |
| 38285 | error checker | error pulse report: 4 bad packets, 4 pulses, 0 outside 1..10 cycles, at most 1 owed at once |
| 38285 | ch0 monitor | Channel 0 report: 6 packets collected |
| 38285 | ch1 monitor | Channel 1 report: 9 packets collected |
| 38285 | ch2 monitor | Channel 2 report: 20 packets collected |
| 38285 | hbus monitor | HBUS report: 19 writes, 96 reads |
| 38285 | coverage | Coverage of the router configuration: 87.0% · maxpktsize 0 / 1 / 2..61 / 62 / 63 : 19 / 0 / 18 / 18 / 18 packets · length < max / = max / max+1 / > max+1 : 27 / 12 / 17 / 17 · forwarded good / bad : 32 / 3 · dropped address 3 good / bad : 10 / 0 · dropped oversized good / bad : 27 / 1 · counter enables none / mixed / all : 0 / 19 / 54 |
| 38285 | coverage | HBUS address coverage: 115 accesses sampled, coverage 42.9% |
| 38285 | coverage | HBUS register bits coverage: 8 writes to ctrl_reg/en_reg, coverage 88.6% |
| 38285 | coverage | HBUS counter value coverage: 8 counter reads sampled, coverage 55.6% |
| 38285 | coverage | HBUS yapp_mem data coverage: 22 accesses sampled, coverage 29.4% |
| 38285 | reference | --- Reference model report --- · forwarded to scoreboard : 35 · dropped (router disabled) : 0 · dropped (oversized) : 28 · dropped (address 3) : 10 · counters parity/oversized/addr0..3 : 4 / 15 / 14 11 33 10 |
| 38285 | reference | HBUS reads checked against the model: 95 (0 mismatches, 1 of memory bytes never written) |
| 38285 | scoreboard | --- Scoreboard report --- · packets received : 35 · packets matched : 35 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 38285 | yapp driver | YAPP driver report: 73 packets sent |
| 38285 | coverage | YAPP gap coverage: 72 gaps sampled, coverage 100.0% |
| 38285 | yapp monitor | YAPP monitor report: 73 packets collected, 4 with bad parity |
| 38285 | yapp monitor | YAPP gaps: 20 back to back, 8 of 1 cycle, 5 of 2, 39 longer |
| 38285 | coverage | YAPP packet coverage: 73 packets sampled, coverage 63.3% |
