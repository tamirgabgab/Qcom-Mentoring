# Session 4 — Interfaces and the DUT

**Labs:** [Lab 6](../labs/lab06.md)

## Goal

Packets flowing through the real router: `yapp_if`, the virtual interface in driver and monitor, `hw_top` with the DUT and `tb_top` publishing the interface, the drain time, and the first waves.

## Before the session

* Warm build of `labs/lab06_vif/tb` **with waves** (`make sim TEST=yapp_012_test WAVES=1`) and a wave viewer that opens `.fst` (VaporView in Codespaces, Surfer, GTKWave).
* Map: [Hierarchy → hw_top](../project-map.md#view=hierarchy&scene=h:hw_top) for the DUT pins, and the [DUT specification](../dut/spec.md) for the input port protocol (`in_data_vld`, `in_suspend`).
* [Logs, timelines and waves](../appendix/sim-report.md) for how the wave pictures are read.

## Plan

1. Concept (40 min): an `interface` as the bundle of wires, the virtual interface handle in a class, `uvm_config_db#(virtual yapp_if)` from `tb_top`, clocking: drive on the falling edge, sample on the rising edge; what `hw_top` and `tb_top` each hold; the drain time.
2. Lab 6 (80 min) in `start/`: the interface, the driver's `send_to_dut`, the monitor's `collect_packet`, `hw_top`, `tb_top`. `make check LAB=lab06_vif START=1` looks for the monitor's `Packet collected` lines.
3. Waves (30 min): the first packet on `in0` -- header, payload, parity, `in_data_vld`, and where `hw_top.dut.u_tracer.in_phase` labels them.
4. Review (30 min): the driver and monitor on the map with their interface arrows, the `YAPP driver report` / `monitor report` counts, the checkpoint questions.

## Show live

* `yapp_012_test` with waves: three packets on the input, each on its own channel on the output; `data_vld_0/1/2`.
* Drain time 0 in `base_test`: the last packet is sent and never collected -- one count differs between the driver's and the monitor's report.
* `set_config_test` with the DUT: the agent is passive, nothing drives, the DUT stays idle, `0 packets collected`.

## Where students get stuck

* The driver drives on the rising edge too: races with the DUT, bytes lost or doubled. Falling edge in the driver, rising edge in the DUT and the monitor.
* The monitor samples `in_data` when `in_data_vld` is low: the header read as a payload byte.
* `tb_top` publishes the interface under one name and the driver asks for another: the `uvm_fatal` `virtual interface must be set` at the start of the run.
* `hw_top` and `tb_top` both compiled as top modules: that is intended (two tops), students look for the mistake.

## Ask

* Why is the interface compiled (listed in `run.f`) and not included in the package?
* What breaks if the monitor is given the driver's `vif` by assignment inside the agent instead of through the config_db? (Nothing today; the monitor can no longer be built passive without the driver.)
* Where does the DUT's `in_suspend` come from, and what must the driver do when it sees it?

## For next time

Read [Lab 7](../labs/lab07.md)'s table of the provided UVCs: next time three UVCs join at once and the `hdata_w` wire is the trap of the day.
