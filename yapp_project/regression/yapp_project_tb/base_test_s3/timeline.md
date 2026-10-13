# base_test seed 3

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 0s · wall 0.1 s · log [`base_test_s3.log`](base_test_s3.log)

Waves: `base_test_s3.fst` (GTKWave, Surfer or the VS Code wave viewer).
[Open the waves in Surfer](https://app.surfer-project.org/?load_url=https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Fregression%2Fyapp_project_tb%2Fbase_test_s3%2Fbase_test_s3.fst&startup_commands=run_command_file_from_url%20https%3A%2F%2Fraw.githubusercontent.com%2Ftamirgabgab%2FQcom-Mentoring%2Fmain%2Fyapp_project%2Ftb%2Fyapp_router.sucl) (web app, the signals already in groups: `yapp_project/tb/yapp_router.sucl`).

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 0.
- Router: **0** forwarded, **0** dropped.
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 0 write(s), 0 read(s).

## Timeline

16 events.

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | ch0 monitor | Channel 0 report: 0 packets collected |
| 0 | ch1 monitor | Channel 1 report: 0 packets collected |
| 0 | ch2 monitor | Channel 2 report: 0 packets collected |
| 0 | hbus monitor | HBUS report: 0 writes, 0 reads |
| 0 | coverage | HBUS address coverage: 0 accesses sampled, coverage 0.0% |
| 0 | coverage | HBUS register bits coverage: 0 writes to ctrl_reg/en_reg, coverage 0.0% |
| 0 | coverage | HBUS counter value coverage: 0 counter reads sampled, coverage 0.0% |
| 0 | coverage | HBUS yapp_mem data coverage: 0 accesses sampled, coverage 0.0% |
| 0 | reference | --- Reference model report --- · forwarded to scoreboard : 0 · dropped (router disabled) : 0 · dropped (oversized) : 0 · dropped (address 3) : 0 · counters parity/oversized/addr0..3 : 0 / 0 / 0 0 0 0 |
| 0 | scoreboard | --- Scoreboard report --- · packets received : 0 · packets matched : 0 · packets mismatched: 0 · packets unexpected: 0 · packets to addr 3 : 0 · left in queue 0/1/2: 0 / 0 / 0 |
| 0 | yapp driver | YAPP driver report: 0 packets sent |
| 0 | coverage | YAPP gap coverage: 0 gaps sampled, coverage 0.0% |
| 0 | yapp monitor | YAPP monitor report: 0 packets collected, 0 with bad parity |
| 0 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 0 longer |
| 0 | coverage | YAPP packet coverage: 0 packets sampled, coverage 0.0% |
