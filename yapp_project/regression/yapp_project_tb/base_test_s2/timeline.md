# base_test  seed 2

**Result:** PASSED (0 UVM_ERROR, 0 UVM_WARNING, 0 UVM_FATAL) · bench `yapp_project_tb` · sim time 0s · log `base_test_s2.log`

Waves: `base_test_s2.fst` (GTKWave, Surfer or the VS Code wave viewer); signal trace: `signals.csv`.

## Summary

- YAPP driver sent **0** packet(s) (0 with bad parity); the input monitor saw 0.
- Router: **0** forwarded, **0** dropped.
- Packets out: ch0 **0**, ch1 **0**, ch2 **0**.
- Scoreboard: 0 matched, 0 mismatched, 0 unexpected.
- Back-pressure: in_suspend asserted **0** time(s).
- Error pulses: 0.
- HBUS: 0 write(s), 0 read(s).

## Timeline

10 events (the same list is in `timeline.csv`).

| time (ns) | who | event |
|---|---|---|
| 0 | yapp monitor | YAPP monitor running |
| 0 | ch0 monitor | Channel 0 report: 0 packets collected |
| 0 | ch1 monitor | Channel 1 report: 0 packets collected |
| 0 | ch2 monitor | Channel 2 report: 0 packets collected |
| 0 | hbus monitor | HBUS report: 0 writes, 0 reads |
| 0 | reference |  |
| 0 | scoreboard |  |
| 0 | yapp driver | YAPP driver report: 0 packets sent |
| 0 | yapp monitor | YAPP monitor report: 0 packets collected, coverage 0.0% |
| 0 | yapp monitor | YAPP gaps: 0 back to back, 0 of 1 cycle, 0 of 2, 0 longer (gap coverage 0.0%) |
