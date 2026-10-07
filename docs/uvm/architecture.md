# Project architecture

[Open on the project map →](../project-map.md#view=hierarchy&scene=h:root){ .pm-link }


This is what the testbench looks like once every lab is done
(`labs/lab11c_rm_sim`). Each lab page has the sub-diagram for its own stage.

## Component tree

```mermaid
flowchart TB
    subgraph tb_top["tb_top (module): publishes the virtual interfaces, calls run_test()"]
        subgraph test["uvm_test_top : base_test / simple_test / router_simple_mcseq_test / reg_*_test"]
            subgraph tb["tb : router_tb (uvm_env)"]
                direction LR
                subgraph yapp["yapp : yapp_env"]
                    subgraph yagent["agent : yapp_tx_agent"]
                        yseqr["sequencer"]
                        ydrv["driver"]
                        ymon["monitor<br/>+ covergroup"]
                    end
                end
                subgraph chan["chan0 / chan1 / chan2 : channel_env"]
                    subgraph cagent["rx_agent"]
                        cseqr["sequencer"]
                        cdrv["driver"]
                        cmon["monitor"]
                    end
                end
                subgraph hbus["hbus : hbus_env"]
                    subgraph hagent["masters[0]"]
                        hseqr["sequencer"]
                        hdrv["driver"]
                    end
                    hmon["monitor"]
                end
                subgraph clk["clk_rst : clock_and_reset_env"]
                    subgraph kagent["agent"]
                        kseqr["sequencer"]
                        kdrv["driver"]
                    end
                end
                mcseqr["mcseqr : router_mcsequencer<br/>hbus_seqr → , yapp_seqr →"]
                subgraph rm["router_module : router_module_env"]
                    ref["reference"]
                    sb["scoreboard"]
                end
                yrm[("yapp_rm : yapp_router_regs_t<br/>reg2hbus : hbus_reg_adapter")]
            end
        end
    end
    subgraph hw_top["hw_top (module)"]
        clkif["clk_rst_if"]
        clkgen["clkgen"]
        in0["in0 : yapp_if"]
        hb0["hbus0 : hbus_if"]
        ch0["ch0/ch1/ch2 : channel_if"]
        dut["dut : yapp_router"]
        clkif --> clkgen --> dut
        in0 <--> dut
        hb0 <--> dut
        dut <--> ch0
    end
    ydrv -. vif .-> in0
    ymon -. vif .-> in0
    cdrv -. vif .-> ch0
    cmon -. vif .-> ch0
    hdrv -. vif .-> hb0
    hmon -. vif .-> hb0
    kdrv -. vif .-> clkif
    mcseqr -.-> hseqr
    mcseqr -.-> yseqr
    yrm -. "front door via reg2hbus" .-> hseqr
    yrm -. "backdoor: hw_top.dut.u_regs.*" .-> dut
```

### Instance paths

These are the names you use in `uvm_config_*::set` calls and hierarchical
references. They come straight from `uvm_top.print_topology()`.

| Path | Type | Used for |
|---|---|---|
| `tb.yapp.agent.sequencer` | `yapp_tx_sequencer` | YAPP default sequence; `mcseqr.yapp_seqr` |
| `tb.yapp.agent.monitor` | `yapp_tx_monitor` | `item_collected_port`, coverage, `num_bad_parity` |
| `tb.chan*.rx_agent.sequencer` | `channel_rx_sequencer` | `channel_rx_resp_seq` (one wildcard for all three) |
| `tb.hbus.masters[0].sequencer` | `hbus_master_sequencer` | `mcseqr.hbus_seqr`; register map sequencer |
| `tb.hbus.monitor` | `hbus_monitor` | `item_collected_port` → reference model |
| `tb.clk_rst.agent.sequencer` | `clock_and_reset_sequencer` | `clk10_rst5_seq` |
| `tb.mcseqr` | `router_mcsequencer` | `router_simple_mcseq` |
| `tb.router_module` | `router_module_env` | exports `yapp_export`, `hbus_export`, `chan0..2_export` |
| `tb.yapp_rm.router_yapp_regs` | `yapp_regs_c` | register handles in the Lab 11 tests |

## TLM connections

```mermaid
flowchart LR
    ymon["yapp monitor<br/>item_collected_port"]
    hmon["hbus monitor<br/>item_collected_port"]
    c0["chan0 monitor"]
    c1["chan1 monitor"]
    c2["chan2 monitor"]
    subgraph env["router_module_env"]
        ye(("yapp_export"))
        he(("hbus_export"))
        c0e(("chan0_export"))
        c1e(("chan1_export"))
        c2e(("chan2_export"))
        subgraph ref["reference"]
            ryi["yapp_in (imp)"]
            rhi["hbus_in (imp)"]
            rvo["yapp_valid_out (port)"]
        end
        subgraph sb["scoreboard"]
            syi["yapp_in (imp)"]
            s0["chan0_in (imp)"]
            s1["chan1_in (imp)"]
            s2["chan2_in (imp)"]
        end
        ye --> ryi
        he --> rhi
        rvo -->|"only packets the router will route"| syi
        c0e --> s0
        c1e --> s1
        c2e --> s2
    end
    ymon --> ye
    hmon --> he
    c0 --> c0e
    c1 --> c1e
    c2 --> c2e
```

* **ports** (`uvm_analysis_port`) are owned by producers (monitors). `write()`
  on a port calls `write()` on every connected imp — synchronously, in the
  producer's thread.
* **imps** (`uvm_analysis_imp_<suffix>`) are owned by consumers and bound to a
  `write_<suffix>()` method.
* **exports** forward: they let an env expose an imp that lives deeper inside.

## Data flow of one test: `router_simple_mcseq_test`

```mermaid
sequenceDiagram
    participant T as test
    participant MC as mcseqr<br/>router_simple_mcseq
    participant H as hbus seqr/driver
    participant Y as yapp seqr/driver
    participant D as DUT
    participant C as channel drivers
    participant R as reference
    participant S as scoreboard
    T->>MC: default_sequence (run_phase)
    T->>C: channel_rx_resp_seq (forever)
    Note over MC: raise objection
    MC->>H: hbus_small_packet_seq (ctrl=20, en=1)
    H->>D: HBUS writes
    D-->>R: (via hbus monitor) maxpktsize=20
    MC->>H: hbus_read_max_pkt_seq
    H->>D: HBUS read → 20
    MC->>Y: yapp_012_seq ×2
    Y->>D: 6 short packets
    D-->>R: (via yapp monitor) packet
    R-->>S: forward if len ≤ 20, addr ≠ 3, enabled
    D->>C: bytes on channel addr
    C-->>S: (via channel monitor) packet → compare
    MC->>H: hbus_large_packet_seq (ctrl=63)
    MC->>Y: yapp_rnd_seq (count == 6)
    Note over MC: drop objection → drain time 200 ns → end of run_phase
    S->>S: report_phase: 12 matched, 0 mismatched
```

## Files of the final environment

The final environment is `yapp_project/` (`rtl/`, `uvc/`, `tb/`); the lab column says
where each file first appears. Every class has its own file, with `extern` prototypes
in the class and the method bodies after `endclass`; sequences spell out
`start_item` / `randomize` / `finish_item` instead of `uvm_do*`, and data items
implement their `do_*` methods instead of using `uvm_field_*` macros
(see [Component guides](../components/index.md)).

| File | Class / module | Lab |
|---|---|---|
| `yapp_project/uvc/yapp/yapp_packet.sv` | `yapp_packet`, `short_yapp_packet`, `parity_type_e` | 1, 4 |
| `yapp_project/uvc/yapp/yapp_tx_driver.sv` | `yapp_tx_driver` | 3, 6 |
| `yapp_project/uvc/yapp/yapp_tx_sequencer.sv` | `yapp_tx_sequencer` | 3 |
| `yapp_project/uvc/yapp/yapp_tx_monitor.sv` | `yapp_tx_monitor` (+ analysis port, covergroup) | 3, 6, 9A, 10 |
| `yapp_project/uvc/yapp/yapp_tx_agent.sv`, `yapp_env.sv` | `yapp_tx_agent`, `yapp_env` | 3, 4 |
| `yapp_project/uvc/yapp/yapp_tx_seqs.sv` | the sequence library | 3, 5, 7, 10 |
| `yapp_project/uvc/yapp/yapp_if.sv` | `yapp_if` | 6 |
| `yapp_project/uvc/hbus/*`, `yapp_project/uvc/channel/*`, `yapp_project/uvc/clock_and_reset/*` | the provided UVCs | 7 |
| `yapp_project/tb/router_tb.sv` | `router_tb` | 2 → 11B |
| `yapp_project/tb/router_test_lib.sv` + `tests/` | the tests, one class per file | 2 → 11C |
| `yapp_project/tb/hw_top.sv`, `tb_top.sv` | top modules | 6, 7 |
| `yapp_project/tb/router_mcsequencer.sv`, `router_mcseqs_lib.sv` + `mcseqs/` | virtual sequencer and sequences | 8 |
| `yapp_project/uvc/router/router_scoreboard.sv`, `router_reference.sv`, `router_module_env.sv`, `router_fifo_scoreboard.sv` | router module UVC | 9A–9D |
| `yapp_project/tb/yapp_router_reg_pkg.sv` + `reg/` | register model | 11A |
| `yapp_project/rtl/yapp_router.sv`, `yapp_input_fsm.sv`, `yapp_output_channel.sv`, `yapp_fifo.sv`, `yapp_hbus_regs.sv`, `yapp_error_timer.sv` (`yapp_router.f`) | the DUT, one module per file | — |
