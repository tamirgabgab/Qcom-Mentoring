# Lab 9C — Using TLM export connectors *(optional)*

[Open on the project map →](../project-map.md#view=hierarchy&scene=h:tb.router_module){ .pm-link }


**Directory:** `labs/lab09_sbc` · **Changed:** `sv/router_module_env.sv`, `tb/router_tb.sv`

## Objective

Expose all connection points of the module UVC at the env level with
**exports**, so the testbench never reaches into the env.

## Concepts

* An `uvm_analysis_export` is a **pass-through**: it has no `write()` of its own; in
  `connect_phase` the env connects it to the imp inside (`yapp_export.connect(reference.yapp_in)`).
* The testbench then connects monitors to the env's exports and never names a child of the
  env: the env can be reorganised without touching `router_tb`.

## Why

An interface UVC always has its analysis ports in the monitor — you know where
to look. In a module UVC the imps can be anywhere inside. Exports put them at
the top.

```mermaid
flowchart LR
    Y["yapp monitor"] --> YE(("m_yapp_export"))
    H["hbus monitor"] --> HE(("m_hbus_export"))
    C0["chan0 monitor"] --> C0E(("m_chan0_export"))
    C1["chan1 monitor"] --> C1E(("m_chan1_export"))
    C2["chan2 monitor"] --> C2E(("m_chan2_export"))
    subgraph ENV["router_module_env"]
        YE --> R["m_reference.m_yapp_in"]
        HE --> RH["m_reference.m_hbus_in"]
        R2["m_reference.m_yapp_valid_out"] --> S["m_scoreboard.m_yapp_in"]
        C0E --> S0["m_scoreboard.m_chan0_in"]
        C1E --> S1["m_scoreboard.m_chan1_in"]
        C2E --> S2["m_scoreboard.m_chan2_in"]
    end
```

## Solution

### 1. `sv/router_module_env.sv`

```systemverilog
--8<-- "labs/lab09_sbc/sv/router_module_env.sv"
```

### 2. `router_tb.connect_phase`

```systemverilog
m_yapp.m_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_yapp_export);
m_hbus.m_monitor.m_item_collected_port.connect(m_router_module.m_hbus_export);
m_chan0.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan0_export);
m_chan1.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan1_export);
m_chan2.m_rx_agent.m_monitor.m_item_collected_port.connect(m_router_module.m_chan2_export);
```

## Run

```bash
make run TEST=router_simple_mcseq_test
make run TEST=scoreboard_drop_test
```

**Expected:** identical results to Lab 9B — this lab changes the wiring, not
the behaviour.

## See it run

The lines that matter from the real log of every test of this lab (Verilator, seed 1, from the last `make regress`; the paths and the packet tables are left out). Your own log must show the same lines -- `make check LAB=lab09_sbc START=1` looks for them.

--8<-- "docs/assets/generated/see_it_run/lab09c.md"

## Try this

Small changes to make in `start/` once the lab works, each with a question; the answer unfolds.

??? question "Connect only `chan0`'s analysis port to the module UVC's export and leave `chan1` / `chan2` unconnected. Does it compile, and what do the counts look like?"
    It compiles and runs: an export with nothing connected to it is legal. Packets for addresses 1 and 2 are predicted but never seen by the scoreboard, so they stay in the expected queue -- the report shows fewer matches than packets sent, and a check that the queues are empty at the end would fail.

## Checkpoint questions

??? question "What does an export add that a port or an imp does not?"
    Nothing functionally — it is a pass-through. It adds *encapsulation*: the
    env's internal structure (where the imps live) can change without touching
    the testbench.

??? question "Why does the internal `yapp_valid_out → scoreboard.yapp_in` link stay inside?"
    It connects two components of the module UVC to each other; the outside
    world has no business with it.

??? question "Exports are constructed in `new()` — why not in `build_phase`?"
    Both work; TLM objects are not components, so they can be created in the
    constructor, and doing so guarantees they exist before anybody connects
    to them in a `connect_phase`.

## What changed since the previous lab

```bash
diff labs/lab09_sbb/sv/router_module_env.sv labs/lab09_sbc/sv/router_module_env.sv
diff labs/lab09_sbb/tb/router_tb.sv labs/lab09_sbc/tb/router_tb.sv
```
