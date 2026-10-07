# xrun options used in the course

| Option | Purpose | First used |
|---|---|---|
| `-uvmhome CDNS-1.1d` / `CDNS-1.2` | which bundled UVM library to compile with | every `run.f` |
| `-f run.f` | read options and files from a command file | every lab |
| `-incdir <dir>` | search path for `` `include `` | Lab 1 |
| `-timescale 1ns/1ns` | default timescale for files without one | Lab 6 |
| `+UVM_TESTNAME=<test>` | select the test without recompiling | Lab 2 |
| `+UVM_VERBOSITY=UVM_LOW \| UVM_MEDIUM \| UVM_HIGH \| UVM_FULL` | filter `` `uvm_info `` | Lab 2 |
| `+SVSEED=random` / `+SVSEED=<n>` | random seed (printed in the log) / reproduce a run | Lab 3 |
| `-gui` | SimVision | Lab 5 |
| `-access +rwc` (`-access rwc`) | read/write/connectivity access to signals: waveforms, backdoor | Lab 5, 11 |
| `-debug_opts verisium_interactive` | Verisium Debug (separate license) | Lab 5 |
| `-coverage U` | collect functional (covergroup) coverage | Lab 10 |
| `-covoverwrite` | overwrite the previous coverage database | Lab 10 |
| `-define INJECT_ERROR` | define a macro at compile time (the memory-test error) | Lab 11B |

## The Makefiles

Every `labs/<lab>/tb/Makefile` includes `common/lab.mk`:

```make
--8<-- "common/lab.mk"
```

The root `Makefile` adds `lint`, `docs`, `serve`, `clean` and
`run LAB=<lab> TEST=<test>`.

## Other simulators

The code is standard SystemVerilog + UVM 1.1d/1.2 and does not use
Cadence-specific constructs. To run elsewhere replace `-uvmhome` with the
simulator's UVM option (`-ntb_opts uvm-1.2` for VCS, `-uvmversion 1.2` /
`+incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv` for Questa), keep
`-timescale`, and translate `-incdir` to `+incdir+`. Transaction recording and
the GUI steps are tool specific.
