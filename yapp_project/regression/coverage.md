# Functional coverage

The covergroups of every run, merged (`scripts/coverage_report.py`). How to read it: [../../docs/components/coverage.md](../../docs/components/coverage.md).

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
| `max_cp` (5/5) | zero | 148 | 10 | random_test, random_config_test, random_parity_test |
|  | one | 4167 | 12 | hbus_sweep_test, random_parity_test, random_test, random_backpressure_test +1 |
|  | mid | 1125 | 39 | random_backpressure_test, random_parity_test, random_test, random_config_test +2 |
|  | max62 | 209 | 16 | random_config_test, random_parity_test, random_test, random_backpressure_test |
|  | max63 | 1422 | 45 | counter_wrap_test, back_to_back_test, random_parity_test, parity_error_test +8 |
| `len_cp` (4/4) | below | 1983 | 71 | counter_wrap_test, random_parity_test, random_test, random_config_test +10 |
|  | equal | 152 | 33 | random_parity_test, random_config_test, router_filter_test, random_test +1 |
|  | plus_one | 4253 | 33 | hbus_sweep_test, random_config_test, random_test, router_filter_test +2 |
|  | above | 683 | 40 | random_backpressure_test, random_test, random_config_test, random_parity_test +2 |
| `reason_cp` (3/3) | forwarded | 2061 | 71 | counter_wrap_test, random_parity_test, random_test, random_config_test +10 |
|  | addr3 | 1171 | 33 | hbus_sweep_test, random_parity_test, random_config_test, router_filter_test +2 |
|  | oversized | 3839 | 44 | hbus_sweep_test, random_backpressure_test, random_test, random_config_test +3 |
| `parity_cp` (2/2) | good | 2660 | 68 | counter_wrap_test, random_backpressure_test, random_parity_test, random_test +9 |
|  | bad | 4411 | 44 | hbus_sweep_test, random_parity_test, parity_error_test, random_config_test +5 |
| `cnt_en_cp` (3/3) | none | 348 | 44 | back_to_back_test, router_filter_test, random_parity_test, random_config_test +8 |
|  | mixed | 5135 | 38 | hbus_sweep_test, random_parity_test, random_test, random_backpressure_test +2 |
|  | all | 1588 | 41 | counter_wrap_test, random_config_test, random_backpressure_test, random_parity_test +5 |
| cross `reason_x_parity` (6/6) | addr3_x_bad | 1052 | 15 | hbus_sweep_test, random_parity_test, random_backpressure_test, random_config_test +1 |
|  | addr3_x_good | 119 | 28 | random_parity_test, random_config_test, router_filter_test, random_test +1 |
|  | forwarded_x_bad | 201 | 35 | random_parity_test, parity_error_test, random_test, random_backpressure_test +4 |
|  | forwarded_x_good | 1860 | 67 | counter_wrap_test, random_parity_test, random_config_test, random_test +9 |
|  | oversized_x_bad | 3158 | 30 | hbus_sweep_test, random_parity_test, random_config_test, random_test +1 |
|  | oversized_x_good | 681 | 40 | random_backpressure_test, random_test, random_config_test, random_parity_test +2 |

### `hbus_addr_cg`: 100.0% (77 / 77 bins)

Source: [yapp_project/uvc/router/router_hbus_addr_coverage.sv](../../yapp_project/uvc/router/router_hbus_addr_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `addr_cp` (25/25) | ctrl | 1128 | 64 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +8 |
|  | en | 1159 | 72 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +10 |
|  | parity_cnt | 711 | 76 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_backpressure_test +11 |
|  | m_oversized_cnt | 703 | 68 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_parity_test +9 |
|  | addr3_cnt | 720 | 68 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_test +9 |
|  | addr0_cnt | 726 | 72 | hbus_sweep_test, random_config_test, reg_bit_walk_test, counter_wrap_test +10 |
|  | addr1_cnt | 708 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +9 |
|  | addr2_cnt | 714 | 68 | hbus_sweep_test, random_config_test, reg_bit_walk_test, random_backpressure_test +9 |
|  | m_mem_size | 752 | 56 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +6 |
|  | reg_hole[0] | 581 | 16 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_parity_test +2 |
|  | reg_hole[1] | 575 | 11 | hbus_sweep_test, hbus_protocol_test, random_parity_test, random_config_test |
|  | reg_hole[2] | 579 | 14 | hbus_sweep_test, hbus_protocol_test, random_backpressure_test, random_config_test +2 |
|  | reg_hole[3] | 581 | 16 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[4] | 582 | 16 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_backpressure_test +2 |
|  | reg_hole[5] | 574 | 14 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_parity_test +1 |
|  | reg_hole[6] | 589 | 22 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_parity_test +2 |
|  | pkt_mem_first | 57 | 40 | pkt_mem_test, random_parity_test, hbus_sweep_test, random_backpressure_test +2 |
|  | pkt_mem_mid | 1840 | 40 | hbus_sweep_test, random_backpressure_test, random_config_test, random_test +2 |
|  | pkt_mem_last | 16 | 12 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +1 |
|  | gap_first | 17 | 9 | hbus_protocol_test, hbus_sweep_test, random_test |
|  | gap_mid | 112 | 33 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +1 |
|  | gap_last | 9 | 5 | hbus_sweep_test, random_backpressure_test |
|  | yapp_mem_first | 64 | 13 | hbus_sweep_test, uvm_mem_walk_test, random_test, random_parity_test +1 |
|  | yapp_mem_mid | 14174 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | yapp_mem_last | 54 | 11 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_parity_test +1 |
| `rw_cp` (2/2) | read | 18661 | 88 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +14 |
|  | write | 9064 | 84 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, reg_bit_walk_test +13 |
| cross `addr_x_rw` (50/50) | addr0_cnt_x_read | 694 | 72 | hbus_sweep_test, random_config_test, counter_wrap_test, random_backpressure_test +10 |
|  | addr0_cnt_x_write | 32 | 16 | hbus_sweep_test, reg_bit_walk_test, reg_access_test, reg_introspection_test |
|  | addr1_cnt_x_read | 680 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +9 |
|  | addr1_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | addr2_cnt_x_read | 686 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +9 |
|  | addr2_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | addr3_cnt_x_read | 692 | 68 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +9 |
|  | addr3_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | ctrl_x_read | 758 | 56 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_backpressure_test +6 |
|  | ctrl_x_write | 370 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | en_x_read | 761 | 56 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +6 |
|  | en_x_write | 398 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +9 |
|  | gap_first_x_read | 9 | 9 | hbus_protocol_test, hbus_sweep_test, random_test |
|  | gap_first_x_write | 8 | 8 | hbus_protocol_test, hbus_sweep_test |
|  | gap_last_x_read | 5 | 5 | hbus_sweep_test, random_backpressure_test |
|  | gap_last_x_write | 4 | 4 | hbus_sweep_test |
|  | gap_mid_x_read | 88 | 33 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +1 |
|  | gap_mid_x_write | 24 | 4 | hbus_sweep_test |
|  | m_mem_size_x_read | 724 | 56 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +6 |
|  | m_mem_size_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | m_oversized_cnt_x_read | 675 | 68 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +9 |
|  | m_oversized_cnt_x_write | 28 | 12 | hbus_sweep_test, reg_bit_walk_test, reg_introspection_test |
|  | parity_cnt_x_read | 679 | 76 | hbus_sweep_test, random_parity_test, random_backpressure_test, random_config_test +11 |
|  | parity_cnt_x_write | 32 | 16 | hbus_sweep_test, reg_bit_walk_test, hbus_protocol_test, reg_introspection_test |
|  | pkt_mem_first_x_read | 49 | 40 | pkt_mem_test, random_parity_test, random_backpressure_test, random_config_test +2 |
|  | pkt_mem_first_x_write | 8 | 8 | hbus_sweep_test, pkt_mem_test |
|  | pkt_mem_last_x_read | 12 | 12 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +1 |
|  | pkt_mem_last_x_write | 4 | 4 | hbus_sweep_test |
|  | pkt_mem_mid_x_read | 1592 | 40 | random_backpressure_test, random_config_test, random_test, hbus_sweep_test +2 |
|  | pkt_mem_mid_x_write | 248 | 4 | hbus_sweep_test |
|  | reg_hole[0]_x_read | 561 | 16 | hbus_sweep_test, random_config_test, hbus_protocol_test, random_parity_test +2 |
|  | reg_hole[0]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[1]_x_read | 555 | 11 | hbus_sweep_test, hbus_protocol_test, random_parity_test, random_config_test |
|  | reg_hole[1]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[2]_x_read | 559 | 14 | hbus_sweep_test, hbus_protocol_test, random_backpressure_test, random_config_test +2 |
|  | reg_hole[2]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[3]_x_read | 561 | 16 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_test +1 |
|  | reg_hole[3]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[4]_x_read | 562 | 16 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_backpressure_test +2 |
|  | reg_hole[4]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[5]_x_read | 554 | 14 | hbus_sweep_test, hbus_protocol_test, random_config_test, random_parity_test +1 |
|  | reg_hole[5]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | reg_hole[6]_x_read | 569 | 22 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +2 |
|  | reg_hole[6]_x_write | 20 | 8 | hbus_sweep_test, hbus_protocol_test |
|  | yapp_mem_first_x_read | 30 | 13 | hbus_sweep_test, uvm_mem_walk_test, random_test, random_parity_test +1 |
|  | yapp_mem_first_x_write | 34 | 13 | hbus_sweep_test, uvm_mem_walk_test, random_test, random_parity_test +1 |
|  | yapp_mem_last_x_read | 27 | 11 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_parity_test +1 |
|  | yapp_mem_last_x_write | 27 | 11 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_parity_test +1 |
|  | yapp_mem_mid_x_read | 6579 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | yapp_mem_mid_x_write | 7595 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |

### `hbus_bits_cg`: 100.0% (44 / 44 bins)

Source: [yapp_project/uvc/router/router_hbus_bits_coverage.sv](../../yapp_project/uvc/router/router_hbus_bits_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `reg_cp` (2/2) | m_ctrl_reg | 2960 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg | 3184 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +9 |
| `bit_cp` (8/8) | b[0] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[1] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[2] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[3] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[4] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[5] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[6] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
|  | b[7] | 768 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
| `val_cp` (2/2) | zero | 2906 | 76 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +11 |
|  | one | 3238 | 80 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +12 |
| cross `reg_x_bit_x_val` (32/32) | m_ctrl_reg_x_b[0]_x_one | 191 | 58 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_config_test +7 |
|  | m_ctrl_reg_x_b[0]_x_zero | 179 | 45 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +4 |
|  | m_ctrl_reg_x_b[1]_x_one | 202 | 50 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | m_ctrl_reg_x_b[1]_x_zero | 168 | 52 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_backpressure_test +5 |
|  | m_ctrl_reg_x_b[2]_x_one | 204 | 58 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_ctrl_reg_x_b[2]_x_zero | 166 | 45 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +4 |
|  | m_ctrl_reg_x_b[3]_x_one | 201 | 51 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | m_ctrl_reg_x_b[3]_x_zero | 169 | 50 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_config_test +5 |
|  | m_ctrl_reg_x_b[4]_x_one | 189 | 51 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +5 |
|  | m_ctrl_reg_x_b[4]_x_zero | 181 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | m_ctrl_reg_x_b[5]_x_one | 201 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_ctrl_reg_x_b[5]_x_zero | 169 | 48 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +4 |
|  | m_ctrl_reg_x_b[6]_x_one | 152 | 38 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_backpressure_test +2 |
|  | m_ctrl_reg_x_b[6]_x_zero | 218 | 59 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | m_ctrl_reg_x_b[7]_x_one | 158 | 36 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_config_test +2 |
|  | m_ctrl_reg_x_b[7]_x_zero | 212 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | m_en_reg_x_b[0]_x_one | 296 | 68 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +9 |
|  | m_en_reg_x_b[0]_x_zero | 102 | 27 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_test +2 |
|  | m_en_reg_x_b[1]_x_one | 214 | 63 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +8 |
|  | m_en_reg_x_b[1]_x_zero | 184 | 57 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[2]_x_one | 198 | 62 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +8 |
|  | m_en_reg_x_b[2]_x_zero | 200 | 51 | hbus_sweep_test, reg_bit_walk_test, random_parity_test, random_config_test +6 |
|  | m_en_reg_x_b[3]_x_one | 202 | 59 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[3]_x_zero | 196 | 57 | hbus_sweep_test, reg_bit_walk_test, random_backpressure_test, random_parity_test +7 |
|  | m_en_reg_x_b[4]_x_one | 207 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[4]_x_zero | 191 | 54 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[5]_x_one | 207 | 63 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +8 |
|  | m_en_reg_x_b[5]_x_zero | 191 | 50 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +6 |
|  | m_en_reg_x_b[6]_x_one | 211 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[6]_x_zero | 187 | 55 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_backpressure_test +7 |
|  | m_en_reg_x_b[7]_x_one | 205 | 60 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |
|  | m_en_reg_x_b[7]_x_zero | 193 | 56 | hbus_sweep_test, reg_bit_walk_test, random_config_test, random_parity_test +7 |

### `hbus_counter_cg`: 100.0% (27 / 27 bins)

Source: [yapp_project/uvc/router/router_hbus_counter_coverage.sv](../../yapp_project/uvc/router/router_hbus_counter_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `counter_cp` (6/6) | parity_err | 679 | 76 | hbus_sweep_test, random_parity_test, random_backpressure_test, random_config_test +11 |
|  | oversized | 675 | 68 | hbus_sweep_test, random_config_test, random_parity_test, random_backpressure_test +9 |
|  | addr0 | 694 | 72 | hbus_sweep_test, random_config_test, counter_wrap_test, random_backpressure_test +10 |
|  | addr1 | 680 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +9 |
|  | addr2 | 686 | 68 | hbus_sweep_test, random_config_test, random_backpressure_test, random_parity_test +9 |
|  | addr3 | 692 | 68 | hbus_sweep_test, random_config_test, random_test, random_backpressure_test +9 |
| `value_cp` (3/3) | zero | 3575 | 68 | hbus_sweep_test, router_disable_test, reg_function_check_test, reg_function_test +9 |
|  | mid | 359 | 68 | random_config_test, random_parity_test, random_backpressure_test, random_test +9 |
|  | max | 172 | 12 | hbus_sweep_test, reg_bit_walk_test, counter_wrap_test |
| cross `counter_x_value` (18/18) | addr0_x_max | 40 | 12 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test |
|  | addr0_x_mid | 75 | 62 | random_config_test, random_backpressure_test, random_parity_test, random_test +8 |
|  | addr0_x_zero | 579 | 34 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test, reg_function_check_test +7 |
|  | addr1_x_max | 28 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr1_x_mid | 67 | 55 | random_config_test, random_backpressure_test, random_parity_test, router_filter_test +6 |
|  | addr1_x_zero | 585 | 31 | hbus_sweep_test, counter_wrap_test, reg_bit_walk_test, reg_function_check_test +6 |
|  | addr2_x_max | 20 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr2_x_mid | 69 | 55 | random_backpressure_test, random_config_test, random_parity_test, random_test +6 |
|  | addr2_x_zero | 597 | 36 | hbus_sweep_test, random_config_test, counter_wrap_test, reg_bit_walk_test +7 |
|  | addr3_x_max | 12 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | addr3_x_mid | 42 | 29 | random_config_test, random_parity_test, router_filter_test, hbus_sweep_test +3 |
|  | addr3_x_zero | 638 | 50 | hbus_sweep_test, random_backpressure_test, random_test, reg_function_check_test +7 |
|  | oversized_x_max | 36 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | oversized_x_mid | 54 | 40 | random_config_test, random_backpressure_test, router_filter_test, random_parity_test +3 |
|  | oversized_x_zero | 585 | 38 | hbus_sweep_test, random_parity_test, counter_wrap_test, reg_bit_walk_test +7 |
|  | parity_err_x_max | 36 | 8 | hbus_sweep_test, reg_bit_walk_test |
|  | parity_err_x_mid | 52 | 43 | random_parity_test, parity_error_test, random_config_test, random_test +5 |
|  | parity_err_x_zero | 591 | 41 | hbus_sweep_test, random_backpressure_test, counter_wrap_test, hbus_protocol_test +9 |

### `hbus_data_cg`: 100.0% (17 / 17 bins)

Source: [yapp_project/uvc/router/router_hbus_data_coverage.sv](../../yapp_project/uvc/router/router_hbus_data_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `rw_cp` (2/2) | read | 6636 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | write | 7656 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
| `pattern_cp` (5/5) | zeros | 2064 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | ones | 2060 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | x55 | 2066 | 10 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_test |
|  | xaa | 2068 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | other | 6034 | 40 | uvm_mem_walk_test, hbus_sweep_test, random_config_test, random_backpressure_test +2 |
| cross `rw_x_pattern` (10/10) | read_x_ones | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | read_x_other | 2513 | 40 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_backpressure_test +2 |
|  | read_x_x55 | 1031 | 10 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_test |
|  | read_x_xaa | 1032 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | read_x_zeros | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | write_x_ones | 1030 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |
|  | write_x_other | 3521 | 40 | uvm_mem_walk_test, hbus_sweep_test, random_config_test, random_backpressure_test +2 |
|  | write_x_x55 | 1035 | 10 | hbus_sweep_test, uvm_mem_walk_test, random_config_test, random_test |
|  | write_x_xaa | 1036 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_config_test |
|  | write_x_zeros | 1034 | 9 | hbus_sweep_test, uvm_mem_walk_test, random_parity_test |

### `yapp_gap_cg`: 100.0% (4 / 4 bins)

Source: [yapp_project/uvc/yapp/yapp_gap_coverage.sv](../../yapp_project/uvc/yapp/yapp_gap_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `gap_cp` (4/4) | back_to_back | 774 | 36 | random_parity_test, random_backpressure_test, random_test, random_config_test +1 |
|  | one | 606 | 56 | hbus_sweep_test, random_test, counter_wrap_test, random_config_test +8 |
|  | two | 299 | 46 | hbus_sweep_test, random_config_test, random_test, counter_wrap_test +8 |
|  | longer | 5549 | 72 | hbus_sweep_test, counter_wrap_test, random_config_test, random_test +10 |

### `yapp_pkt_cg`: 100.0% (30 / 30 bins)

Source: [yapp_project/uvc/yapp/yapp_pkt_coverage.sv](../../yapp_project/uvc/yapp/yapp_pkt_coverage.sv)

| Coverpoint / cross | Bin | Hits | Runs | Tests that hit it (most hits first) |
|---|---|---|---|---|
| `length_cp` (5/5) | MIN | 1305 | 40 | counter_wrap_test, random_parity_test, random_config_test, random_test +6 |
|  | SMALL | 4518 | 57 | hbus_sweep_test, random_parity_test, back_to_back_test, router_filter_test +8 |
|  | MEDIUM | 571 | 60 | random_test, random_config_test, random_parity_test, random_backpressure_test +7 |
|  | LARGE | 565 | 52 | random_backpressure_test, random_test, random_config_test, random_parity_test +5 |
|  | MAX | 341 | 35 | random_config_test, random_test, random_parity_test, router_filter_test +1 |
| `addr_cp` (4/4) | legal[0] | 2547 | 67 | counter_wrap_test, hbus_sweep_test, random_parity_test, random_config_test +9 |
|  | legal[1] | 1581 | 68 | hbus_sweep_test, random_parity_test, random_config_test, random_test +9 |
|  | legal[2] | 1976 | 68 | hbus_sweep_test, random_parity_test, random_test, random_backpressure_test +9 |
|  | illegal_addr | 1196 | 33 | hbus_sweep_test, random_parity_test, random_config_test, router_filter_test +2 |
| `parity_cp` (2/2) | good | 2849 | 68 | counter_wrap_test, random_test, random_parity_test, random_config_test +9 |
|  | bad | 4451 | 45 | hbus_sweep_test, random_parity_test, random_config_test, random_test +5 |
| `legal_addr_cp` (3/3) | legal[0] | 2547 | 67 | counter_wrap_test, hbus_sweep_test, random_parity_test, random_config_test +9 |
|  | legal[1] | 1581 | 68 | hbus_sweep_test, random_parity_test, random_config_test, random_test +9 |
|  | legal[2] | 1976 | 68 | hbus_sweep_test, random_parity_test, random_test, random_backpressure_test +9 |
| `bad_parity_cp` (1/1) | bad | 4451 | 45 | hbus_sweep_test, random_parity_test, random_config_test, random_test +5 |
| cross `len_x_addr_x_parity` (15/15) | LARGE_x_legal[0]_x_bad | 22 | 15 | parity_error_test, random_parity_test, random_test, random_backpressure_test +1 |
|  | LARGE_x_legal[1]_x_bad | 17 | 13 | parity_error_test, random_backpressure_test, random_test, reg_function_check_test +3 |
|  | LARGE_x_legal[2]_x_bad | 38 | 23 | random_parity_test, parity_error_test, random_backpressure_test, random_config_test +1 |
|  | MAX_x_legal[0]_x_bad | 12 | 8 | random_config_test, random_parity_test, random_test |
|  | MAX_x_legal[1]_x_bad | 14 | 10 | random_parity_test, random_config_test, random_test, random_backpressure_test |
|  | MAX_x_legal[2]_x_bad | 25 | 17 | random_config_test, random_parity_test, random_test, random_backpressure_test |
|  | MEDIUM_x_legal[0]_x_bad | 21 | 15 | random_config_test, random_parity_test, parity_error_test, reg_function_test +3 |
|  | MEDIUM_x_legal[1]_x_bad | 29 | 17 | random_parity_test, parity_error_test, random_config_test, random_test +1 |
|  | MEDIUM_x_legal[2]_x_bad | 43 | 28 | parity_error_test, random_test, random_parity_test, random_config_test +4 |
|  | MIN_x_legal[0]_x_bad | 12 | 9 | random_parity_test, random_config_test, random_test |
|  | MIN_x_legal[1]_x_bad | 23 | 10 | random_parity_test, random_config_test, random_test, parity_error_test |
|  | MIN_x_legal[2]_x_bad | 29 | 10 | random_parity_test, random_config_test, random_test |
|  | SMALL_x_legal[0]_x_bad | 1038 | 14 | hbus_sweep_test, random_parity_test, parity_error_test, random_config_test +1 |
|  | SMALL_x_legal[1]_x_bad | 1034 | 10 | hbus_sweep_test, random_parity_test, random_test |
|  | SMALL_x_legal[2]_x_bad | 1037 | 15 | hbus_sweep_test, random_parity_test, random_backpressure_test, parity_error_test +1 |

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
| random_config_test | 8 | 182 / 222 | - |
| random_parity_test | 8 | 184 / 222 | - |
| random_test | 8 | 182 / 222 | - |
| reg_access_test | 4 | 30 / 222 | - |
| reg_bit_walk_test | 4 | 93 / 222 | - |
| reg_function_check_test | 4 | 90 / 222 | - |
| reg_function_test | 4 | 90 / 222 | - |
| reg_introspection_test | 4 | 70 / 222 | - |
| router_disable_test | 4 | 80 / 222 | - |
| router_filter_test | 4 | 99 / 222 | - |
| uvm_mem_walk_test | 4 | 28 / 222 | - |
| uvm_reset_test | 4 | 32 / 222 | - |
