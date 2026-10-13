# Functional coverage

The covergroups of every run, merged (`scripts/coverage_report.py`). How to read it: docs/components/coverage.md.

## Functional coverage: yapp_project_tb

Merged over **100 runs**: 222 of 222 bins hit. A percentage is covered bins / bins of the covergroup, as `get_inst_coverage()` gives it in the log of one run.

Annotated sources (genhtml): [../../docs/coverage/yapp_project_tb/index.html](../../docs/coverage/yapp_project_tb/index.html)

| Covergroup | Where | Bins hit | Coverage |
|---|---|---|---|
| `router_cfg_cg` | [router_coverage.sv](../../yapp_project/uvc/router/router_coverage.sv) | 23 / 23 | **100.0%** |
| `hbus_addr_cg` | [router_hbus_addr_coverage.sv](../../yapp_project/uvc/router/router_hbus_addr_coverage.sv) | 77 / 77 | **100.0%** |
| `hbus_bits_cg` | [router_hbus_bits_coverage.sv](../../yapp_project/uvc/router/router_hbus_bits_coverage.sv) | 44 / 44 | **100.0%** |
| `hbus_counter_cg` | [router_hbus_counter_coverage.sv](../../yapp_project/uvc/router/router_hbus_counter_coverage.sv) | 27 / 27 | **100.0%** |
| `hbus_data_cg` | [router_hbus_data_coverage.sv](../../yapp_project/uvc/router/router_hbus_data_coverage.sv) | 17 / 17 | **100.0%** |
| `yapp_gap_cg` | [yapp_gap_coverage.sv](../../yapp_project/uvc/yapp/yapp_gap_coverage.sv) | 4 / 4 | **100.0%** |
| `yapp_pkt_cg` | [yapp_pkt_coverage.sv](../../yapp_project/uvc/yapp/yapp_pkt_coverage.sv) | 30 / 30 | **100.0%** |

### Holes

None: every bin was hit at least once.

### `router_cfg_cg`: 100.0% (23 / 23 bins)

Source: [yapp_project/uvc/router/router_coverage.sv](../../yapp_project/uvc/router/router_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `max_cp` (5/5) | zero | 107 | 10 | random_config_test, random_parity_test, random_test |
|  | one | 4175 | 13 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +1 |
|  | mid | 1211 | 40 | random_backpressure_test, random_parity_test, random_test, random_config_test +2 |
|  | max62 | 154 | 11 | random_test, random_config_test, random_parity_test, random_backpressure_test |
|  | max63 | 1432 | 47 | counter_wrap_test, back_to_back_test, random_parity_test, random_config_test +8 |
| `len_cp` (4/4) | below | 1966 | 72 | counter_wrap_test, random_parity_test, random_test, random_config_test +10 |
|  | equal | 151 | 32 | random_config_test, router_filter_test, random_test, random_parity_test +1 |
|  | plus_one | 4238 | 32 | hbus_sweep_test, random_config_test, router_filter_test, random_test +2 |
|  | above | 724 | 40 | random_backpressure_test, random_config_test, random_test, random_parity_test +2 |
| `reason_cp` (3/3) | forwarded | 2021 | 72 | counter_wrap_test, random_parity_test, random_test, random_config_test +10 |
|  | addr3 | 1195 | 31 | hbus_sweep_test, random_parity_test, random_config_test, router_filter_test +2 |
|  | oversized | 3863 | 44 | hbus_sweep_test, random_backpressure_test, random_config_test, random_test +3 |
| `parity_cp` (2/2) | good | 2674 | 68 | counter_wrap_test, random_config_test, random_backpressure_test, random_test +9 |
|  | bad | 4405 | 44 | hbus_sweep_test, random_parity_test, parity_error_test, random_config_test +5 |
| `cnt_en_cp` (3/3) | none | 416 | 43 | back_to_back_test, random_config_test, random_test, router_filter_test +8 |
|  | mixed | 5057 | 38 | hbus_sweep_test, random_parity_test, random_test, random_backpressure_test +2 |
|  | all | 1606 | 39 | counter_wrap_test, random_config_test, random_backpressure_test, random_parity_test +5 |
| cross `reason_x_parity` (6/6) | addr3_x_bad | 1053 | 16 | hbus_sweep_test, random_parity_test, random_config_test, random_backpressure_test |
|  | addr3_x_good | 142 | 26 | random_config_test, random_parity_test, router_filter_test, random_test +1 |
|  | forwarded_x_bad | 189 | 34 | random_parity_test, parity_error_test, random_config_test, random_test +4 |
|  | forwarded_x_good | 1832 | 68 | counter_wrap_test, random_test, random_parity_test, random_config_test +9 |
|  | oversized_x_bad | 3163 | 31 | hbus_sweep_test, random_parity_test, random_config_test, random_test +1 |
|  | oversized_x_good | 700 | 40 | random_backpressure_test, random_config_test, random_test, random_parity_test +2 |

### `hbus_addr_cg`: 100.0% (77 / 77 bins)

Source: [yapp_project/uvc/router/router_hbus_addr_coverage.sv](../../yapp_project/uvc/router/router_hbus_addr_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `addr_cp` (25/25) | ctrl | 1135 | 64 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +8 |
|  | en | 1164 | 72 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +10 |
|  | parity_cnt | 710 | 76 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +11 |
|  | oversized_cnt | 702 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +9 |
|  | addr3_cnt | 710 | 68 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_config_test +9 |
|  | addr0_cnt | 728 | 72 | hbus_sweep_test, reg_bit_walk_test, random_config_test, counter_wrap_test +10 |
|  | addr1_cnt | 707 | 68 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_config_test +9 |
|  | addr2_cnt | 714 | 68 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_backpressure_test +9 |
|  | mem_size | 758 | 56 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +6 |
|  | reg_hole[0] | 580 | 15 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_backpressure_test +2 |
|  | reg_hole[1] | 580 | 15 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[2] | 578 | 13 | hbus_sweep_test, hbus_protocol_test, random_backpressure_test, random_config_test +2 |
|  | reg_hole[3] | 579 | 14 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[4] | 583 | 18 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_backpressure_test +2 |
|  | reg_hole[5] | 576 | 15 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[6] | 586 | 20 | hbus_sweep_test, random_config_test, hbus_protocol_test, random_backpressure_test +1 |
|  | pkt_mem_first | 58 | 40 | pkt_mem_test, random_config_test, random_test, hbus_sweep_test +2 |
|  | pkt_mem_mid | 1946 | 40 | hbus_sweep_test, random_backpressure_test, random_config_test, random_test +2 |
|  | pkt_mem_last | 17 | 13 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test |
|  | gap_first | 16 | 8 | hbus_protocol_test, hbus_sweep_test |
|  | gap_mid | 123 | 31 | hbus_sweep_test, random_config_test, random_backpressure_test, random_test +1 |
|  | gap_last | 9 | 5 | hbus_sweep_test, random_backpressure_test |
|  | yapp_mem_first | 54 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | yapp_mem_mid | 14220 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | yapp_mem_last | 48 | 8 | hbus_sweep_test, uvm_mem_walk_test |
| `rw_cp` (2/2) | read | 18792 | 88 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +14 |
|  | write | 9089 | 84 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, reg_bit_walk_test +13 |
| cross `addr_x_rw` (50/50) | addr0_cnt_x_read | 696 | 72 | hbus_sweep_test, random_config_test, counter_wrap_test, random_test +10 |
|  | addr0_cnt_x_write | 32 | 16 | hbus_sweep_test, reg_bit_walk_test, reg_access_test, reg_introspection_test |
|  | addr1_cnt_x_read | 679 | 68 | hbus_sweep_test, random_backpressure_test, random_config_test, random_parity_test +9 |
|  | addr1_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | addr2_cnt_x_read | 686 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_test +9 |
|  | addr2_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | addr3_cnt_x_read | 682 | 68 | hbus_sweep_test, random_backpressure_test, random_config_test, random_parity_test +9 |
|  | addr3_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | ctrl_x_read | 760 | 56 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +6 |
|  | ctrl_x_write | 375 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | en_x_read | 761 | 56 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +6 |
|  | en_x_write | 403 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +9 |
|  | gap_first_x_read | 8 | 8 | hbus_protocol_test, hbus_sweep_test |
|  | gap_first_x_write | 8 | 8 | hbus_protocol_test, hbus_sweep_test |
|  | gap_last_x_read | 5 | 5 | hbus_sweep_test, random_backpressure_test |
|  | gap_last_x_write | 4 | 4 | hbus_sweep_test |
|  | gap_mid_x_read | 99 | 31 | random_config_test, hbus_sweep_test, random_backpressure_test, random_test +1 |
|  | gap_mid_x_write | 24 | 4 | hbus_sweep_test |
|  | mem_size_x_read | 730 | 56 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +6 |
|  | mem_size_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | oversized_cnt_x_read | 674 | 68 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +9 |
|  | oversized_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | parity_cnt_x_read | 678 | 76 | hbus_sweep_test, random_config_test, random_backpressure_test, random_test +11 |
|  | parity_cnt_x_write | 32 | 16 | hbus_sweep_test, reg_bit_walk_test, hbus_protocol_test, reg_introspection_test |
|  | pkt_mem_first_x_read | 50 | 40 | pkt_mem_test, random_config_test, random_test, random_backpressure_test +2 |
|  | pkt_mem_first_x_write | 8 | 8 | hbus_sweep_test, pkt_mem_test |
|  | pkt_mem_last_x_read | 13 | 13 | random_config_test, hbus_sweep_test, random_backpressure_test, random_parity_test |
|  | pkt_mem_last_x_write | 4 | 4 | hbus_sweep_test |
|  | pkt_mem_mid_x_read | 1698 | 40 | random_backpressure_test, random_config_test, random_test, random_parity_test +2 |
|  | pkt_mem_mid_x_write | 248 | 4 | hbus_sweep_test |
|  | reg_hole[0]_x_read | 560 | 15 | hbus_sweep_test, random_config_test, hbus_protocol_test, random_backpressure_test +2 |
|  | reg_hole[0]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[1]_x_read | 560 | 15 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[1]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[2]_x_read | 558 | 13 | hbus_sweep_test, hbus_protocol_test, random_backpressure_test, random_config_test +2 |
|  | reg_hole[2]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[3]_x_read | 559 | 14 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[3]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[4]_x_read | 563 | 18 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_backpressure_test +2 |
|  | reg_hole[4]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[5]_x_read | 556 | 15 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[5]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[6]_x_read | 566 | 20 | hbus_sweep_test, random_config_test, random_backpressure_test, hbus_protocol_test +1 |
|  | reg_hole[6]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | yapp_mem_first_x_read | 25 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | yapp_mem_first_x_write | 29 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | yapp_mem_last_x_read | 24 | 8 | hbus_sweep_test, uvm_mem_walk_test |
|  | yapp_mem_last_x_write | 24 | 8 | hbus_sweep_test, uvm_mem_walk_test |
|  | yapp_mem_mid_x_read | 6602 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | yapp_mem_mid_x_write | 7618 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |

### `hbus_bits_cg`: 100.0% (44 / 44 bins)

Source: [yapp_project/uvc/router/router_hbus_bits_coverage.sv](../../yapp_project/uvc/router/router_hbus_bits_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `reg_cp` (2/2) | ctrl_reg | 3000 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | en_reg | 3224 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +9 |
| `bit_cp` (8/8) | b[0] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[1] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[2] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[3] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[4] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[5] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[6] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
|  | b[7] | 778 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
| `val_cp` (2/2) | zero | 2981 | 76 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +11 |
|  | one | 3243 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +12 |
| cross `reg_x_bit_x_val` (32/32) | ctrl_reg_x_b[0]_x_one | 202 | 59 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | ctrl_reg_x_b[0]_x_zero | 173 | 46 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +4 |
|  | ctrl_reg_x_b[1]_x_one | 196 | 49 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | ctrl_reg_x_b[1]_x_zero | 179 | 49 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +5 |
|  | ctrl_reg_x_b[2]_x_one | 198 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +7 |
|  | ctrl_reg_x_b[2]_x_zero | 177 | 47 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +4 |
|  | ctrl_reg_x_b[3]_x_one | 188 | 51 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | ctrl_reg_x_b[3]_x_zero | 187 | 52 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +5 |
|  | ctrl_reg_x_b[4]_x_one | 190 | 51 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | ctrl_reg_x_b[4]_x_zero | 185 | 56 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | ctrl_reg_x_b[5]_x_one | 195 | 59 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | ctrl_reg_x_b[5]_x_zero | 180 | 48 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +4 |
|  | ctrl_reg_x_b[6]_x_one | 161 | 38 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +2 |
|  | ctrl_reg_x_b[6]_x_zero | 214 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | ctrl_reg_x_b[7]_x_one | 162 | 37 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +2 |
|  | ctrl_reg_x_b[7]_x_zero | 213 | 58 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | en_reg_x_b[0]_x_one | 297 | 68 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_backpressure_test +9 |
|  | en_reg_x_b[0]_x_zero | 106 | 26 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +2 |
|  | en_reg_x_b[1]_x_one | 216 | 61 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_backpressure_test +8 |
|  | en_reg_x_b[1]_x_zero | 187 | 54 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | en_reg_x_b[2]_x_one | 207 | 61 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +8 |
|  | en_reg_x_b[2]_x_zero | 196 | 50 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +6 |
|  | en_reg_x_b[3]_x_one | 196 | 58 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | en_reg_x_b[3]_x_zero | 207 | 58 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_config_test +7 |
|  | en_reg_x_b[4]_x_one | 211 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | en_reg_x_b[4]_x_zero | 192 | 54 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | en_reg_x_b[5]_x_one | 211 | 64 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +8 |
|  | en_reg_x_b[5]_x_zero | 192 | 51 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +6 |
|  | en_reg_x_b[6]_x_one | 206 | 58 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_backpressure_test +7 |
|  | en_reg_x_b[6]_x_zero | 197 | 58 | hbus_sweep_test, reg_bit_walk_test, random_test, random_config_test +7 |
|  | en_reg_x_b[7]_x_one | 207 | 58 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | en_reg_x_b[7]_x_zero | 196 | 55 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +7 |

### `hbus_counter_cg`: 100.0% (27 / 27 bins)

Source: [yapp_project/uvc/router/router_hbus_counter_coverage.sv](../../yapp_project/uvc/router/router_hbus_counter_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `counter_cp` (6/6) | parity_err | 678 | 76 | hbus_sweep_test, random_config_test, random_backpressure_test, random_test +11 |
|  | oversized | 674 | 68 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +9 |
|  | addr0 | 696 | 72 | hbus_sweep_test, random_config_test, counter_wrap_test, random_test +10 |
|  | addr1 | 679 | 68 | hbus_sweep_test, random_backpressure_test, random_config_test, random_parity_test +9 |
|  | addr2 | 686 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_test +9 |
|  | addr3 | 682 | 68 | hbus_sweep_test, random_backpressure_test, random_config_test, random_parity_test +9 |
| `value_cp` (3/3) | zero | 3568 | 63 | hbus_sweep_test, router_disable_test, random_test, reg_function_check_test +9 |
|  | mid | 355 | 68 | random_config_test, random_backpressure_test, random_parity_test, random_test +9 |
|  | max | 172 | 12 | hbus_sweep_test, reg_bit_walk_test, counter_wrap_test |
| cross `counter_x_value` (18/18) | addr0_x_max | 40 | 12 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test |
|  | addr0_x_mid | 75 | 63 | random_config_test, random_parity_test, random_backpressure_test, random_test +8 |
|  | addr0_x_zero | 581 | 35 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test, reg_function_check_test +7 |
|  | addr1_x_max | 28 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr1_x_mid | 65 | 54 | random_backpressure_test, random_config_test, random_parity_test, random_test +6 |
|  | addr1_x_zero | 586 | 33 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test, reg_function_check_test +6 |
|  | addr2_x_max | 20 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr2_x_mid | 69 | 53 | random_config_test, random_backpressure_test, random_parity_test, router_filter_test +6 |
|  | addr2_x_zero | 597 | 37 | hbus_sweep_test, counter_wrap_test, random_test, reg_bit_walk_test +6 |
|  | addr3_x_max | 12 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr3_x_mid | 38 | 30 | random_config_test, random_parity_test, router_filter_test, hbus_sweep_test +3 |
|  | addr3_x_zero | 632 | 47 | hbus_sweep_test, random_backpressure_test, reg_function_check_test, reg_function_test +7 |
|  | oversized_x_max | 36 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | oversized_x_mid | 55 | 40 | random_config_test, random_backpressure_test, random_parity_test, random_test +3 |
|  | oversized_x_zero | 583 | 36 | hbus_sweep_test, random_parity_test, counter_wrap_test, random_test +7 |
|  | parity_err_x_max | 36 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | parity_err_x_mid | 53 | 42 | random_config_test, parity_error_test, random_parity_test, random_test +5 |
|  | parity_err_x_zero | 589 | 42 | hbus_sweep_test, random_backpressure_test, random_test, counter_wrap_test +9 |

### `hbus_data_cg`: 100.0% (17 / 17 bins)

Source: [yapp_project/uvc/router/router_hbus_data_coverage.sv](../../yapp_project/uvc/router/router_hbus_data_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `rw_cp` (2/2) | read | 6651 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | write | 7671 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
| `pattern_cp` (5/5) | zeros | 2064 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | ones | 2060 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | x55 | 2062 | 8 | hbus_sweep_test, uvm_mem_walk_test |
|  | xaa | 2068 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | other | 6068 | 40 | uvm_mem_walk_test, hbus_sweep_test, random_config_test, random_backpressure_test +2 |
| cross `rw_x_pattern` (10/10) | read_x_ones | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | read_x_other | 2530 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | read_x_x55 | 1029 | 8 | hbus_sweep_test, uvm_mem_walk_test |
|  | read_x_xaa | 1032 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | read_x_zeros | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | write_x_ones | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | write_x_other | 3538 | 40 | uvm_mem_walk_test, hbus_sweep_test, random_config_test, random_backpressure_test +2 |
|  | write_x_x55 | 1033 | 8 | hbus_sweep_test, uvm_mem_walk_test |
|  | write_x_xaa | 1036 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | write_x_zeros | 1034 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |

### `yapp_gap_cg`: 100.0% (4 / 4 bins)

Source: [yapp_project/uvc/yapp/yapp_gap_coverage.sv](../../yapp_project/uvc/yapp/yapp_gap_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `gap_cp` (4/4) | back_to_back | 767 | 36 | random_parity_test, random_backpressure_test, random_config_test, random_test +1 |
|  | one | 603 | 57 | hbus_sweep_test, random_test, random_config_test, counter_wrap_test +8 |
|  | two | 292 | 46 | hbus_sweep_test, random_config_test, counter_wrap_test, random_parity_test +8 |
|  | longer | 5606 | 72 | hbus_sweep_test, counter_wrap_test, random_test, random_config_test +10 |

### `yapp_pkt_cg`: 100.0% (30 / 30 bins)

Source: [yapp_project/uvc/yapp/yapp_pkt_coverage.sv](../../yapp_project/uvc/yapp/yapp_pkt_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `length_cp` (5/5) | MIN | 1316 | 40 | counter_wrap_test, random_parity_test, random_config_test, random_test +6 |
|  | SMALL | 4506 | 56 | hbus_sweep_test, random_parity_test, back_to_back_test, random_test +8 |
|  | MEDIUM | 568 | 60 | random_test, random_config_test, random_backpressure_test, random_parity_test +7 |
|  | LARGE | 597 | 52 | random_backpressure_test, random_test, random_config_test, random_parity_test +5 |
|  | MAX | 353 | 35 | random_config_test, random_test, random_parity_test, router_filter_test +1 |
| `addr_cp` (4/4) | legal[0] | 2563 | 67 | counter_wrap_test, hbus_sweep_test, random_config_test, random_test +9 |
|  | legal[1] | 1549 | 68 | hbus_sweep_test, random_test, random_parity_test, random_backpressure_test +9 |
|  | legal[2] | 2005 | 68 | hbus_sweep_test, random_test, random_config_test, random_parity_test +9 |
|  | illegal_addr | 1223 | 33 | hbus_sweep_test, random_config_test, random_parity_test, router_filter_test +2 |
| `parity_cp` (2/2) | good | 2899 | 68 | counter_wrap_test, random_test, random_config_test, random_backpressure_test +9 |
|  | bad | 4441 | 45 | hbus_sweep_test, random_parity_test, random_config_test, parity_error_test +5 |
| `legal_addr_cp` (3/3) | legal[0] | 2563 | 67 | counter_wrap_test, hbus_sweep_test, random_config_test, random_test +9 |
|  | legal[1] | 1549 | 68 | hbus_sweep_test, random_test, random_parity_test, random_backpressure_test +9 |
|  | legal[2] | 2005 | 68 | hbus_sweep_test, random_test, random_config_test, random_parity_test +9 |
| `bad_parity_cp` (1/1) | bad | 4441 | 45 | hbus_sweep_test, random_parity_test, random_config_test, parity_error_test +5 |
| cross `len_x_addr_x_parity` (15/15) | LARGE_x_legal[0]_x_bad | 24 | 15 | parity_error_test, random_parity_test, random_config_test, random_backpressure_test +1 |
|  | LARGE_x_legal[1]_x_bad | 23 | 18 | parity_error_test, random_parity_test, random_backpressure_test, random_config_test +3 |
|  | LARGE_x_legal[2]_x_bad | 41 | 24 | random_parity_test, random_test, parity_error_test, random_backpressure_test +1 |
|  | MAX_x_legal[0]_x_bad | 5 | 5 | random_config_test, random_parity_test, random_test |
|  | MAX_x_legal[1]_x_bad | 12 | 9 | random_config_test, random_parity_test, random_backpressure_test, random_test |
|  | MAX_x_legal[2]_x_bad | 16 | 12 | random_config_test, random_parity_test, random_test, random_backpressure_test |
|  | MEDIUM_x_legal[0]_x_bad | 21 | 14 | random_test, parity_error_test, random_config_test, random_parity_test +3 |
|  | MEDIUM_x_legal[1]_x_bad | 23 | 16 | parity_error_test, random_parity_test, random_config_test, random_test +1 |
|  | MEDIUM_x_legal[2]_x_bad | 45 | 28 | random_parity_test, parity_error_test, random_test, random_config_test +4 |
|  | MIN_x_legal[0]_x_bad | 11 | 7 | random_parity_test, random_config_test, random_test |
|  | MIN_x_legal[1]_x_bad | 14 | 9 | random_parity_test, random_test, parity_error_test |
|  | MIN_x_legal[2]_x_bad | 35 | 15 | random_parity_test, random_config_test, random_test |
|  | SMALL_x_legal[0]_x_bad | 1033 | 12 | hbus_sweep_test, random_parity_test, random_test, parity_error_test |
|  | SMALL_x_legal[1]_x_bad | 1033 | 11 | hbus_sweep_test, random_parity_test, random_config_test, random_test |
|  | SMALL_x_legal[2]_x_bad | 1046 | 17 | hbus_sweep_test, random_parity_test, random_backpressure_test, random_config_test +2 |

### What each test adds

Bins hit over all the seeds of a test, and the bins no other test hits (a test with none adds nothing to the coverage; it may still check something no other test checks).

| Test | Runs | Bins hit | Only this test |
|---|---|---|---|
| back_to_back_test | 4 | 19 / 222 | - |
| backpressure_test | 4 | 15 / 222 | - |
| base_test | 4 | 0 / 222 | - |
| counter_wrap_test | 4 | 64 / 222 | - |
| hbus_protocol_test | 4 | 57 / 222 | - |
| hbus_sweep_test | 4 | 197 / 222 | `hbus_addr_cg.addr_x_rw.gap_last_x_write`, `hbus_addr_cg.addr_x_rw.gap_mid_x_write`, `hbus_addr_cg.addr_x_rw.pkt_mem_last_x_write`, `hbus_addr_cg.addr_x_rw.pkt_mem_mid_x_write` |
| parity_error_test | 4 | 60 / 222 | - |
| pkt_mem_test | 4 | 52 / 222 | - |
| random_backpressure_test | 8 | 159 / 222 | - |
| random_config_test | 8 | 179 / 222 | - |
| random_parity_test | 8 | 173 / 222 | - |
| random_test | 8 | 169 / 222 | - |
| reg_access_test | 4 | 30 / 222 | - |
| reg_bit_walk_test | 4 | 93 / 222 | - |
| reg_function_check_test | 4 | 90 / 222 | - |
| reg_function_test | 4 | 90 / 222 | - |
| reg_introspection_test | 4 | 70 / 222 | - |
| router_disable_test | 4 | 80 / 222 | - |
| router_filter_test | 4 | 99 / 222 | - |
| uvm_mem_walk_test | 4 | 28 / 222 | - |
| uvm_reset_test | 4 | 32 / 222 | - |
