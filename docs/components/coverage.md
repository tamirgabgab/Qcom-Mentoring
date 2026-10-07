# Functional coverage

Functional coverage answers "**did we exercise what we meant to?**" — not
whether the DUT was right (that is the scoreboard's job). It lives in the
**monitor** because the monitor sees what *actually* happened on the bus,
whatever the sequences intended.

## The requirements (Lab 10)

| Req | Statement | Coverpoint / cross |
|---|---|---|
| REQ1 | every packet length, bucketed | `length_cp`: `MIN=1`, `SMALL=[2:10]`, `MEDIUM=[11:40]`, `LARGE=[41:62]`, `MAX=63` |
| REQ2 | every address, including the illegal one | `addr_cp`: `legal[] = {[0:2]}`, `illegal_addr = {3}` |
| REQ3 | every length bucket to every legal address **with** a parity error | `len_x_addr_x_parity` cross, ignoring `GOOD_PARITY` and `illegal_addr` |

## The covergroup

```systemverilog
covergroup yapp_pkt_cg with function sample(bit [5:0] length,
                                            bit [1:0] addr,
                                            parity_type_e parity_type);
  option.per_instance = 1;
  length_cp : coverpoint length {
    bins MIN    = {1};
    bins SMALL  = {[2:10]};
    bins MEDIUM = {[11:40]};
    bins LARGE  = {[41:62]};
    bins MAX    = {63};
  }
  addr_cp : coverpoint addr {
    bins legal[]      = {[0:2]};
    bins illegal_addr = {3};
  }
  parity_cp : coverpoint parity_type;
  len_x_addr_x_parity : cross length_cp, addr_cp, parity_cp {
    ignore_bins good_parity  = binsof(parity_cp) intersect {GOOD_PARITY};
    ignore_bins illegal_addr = binsof(addr_cp.illegal_addr);
  }
endgroup
```

* Inside a class a covergroup is **created** in the constructor —
  `yapp_pkt_cg = new();` — no separate variable.
* `with function sample(...)` lets the monitor pass the values explicitly;
  the alternative is coverpoints on class members sampled with `sample()`.
* `illegal_addr` is a normal bin, not `illegal_bins`: REQ2 wants to *count*
  packets to address 3, not flag them as errors.
* The cross is **restricted** with `ignore_bins` so that only the combinations
  REQ3 cares about count towards 100%: 5 lengths × 3 addresses × BAD_PARITY =
  15 bins.

## Sampling

`yapp_pkt_cg.sample(pkt.length, pkt.addr, pkt.parity_type)` is called in
`collect_packets()` right after a packet was collected — see the
[monitor](monitor.md).

## Closing the holes

| Test | Covers | Misses |
|---|---|---|
| `router_simple_mcseq_test` (short packets) | MIN, SMALL, some MEDIUM; addresses 0–2 | LARGE, MAX, address 3, most of the cross |
| `test_uvc_integration` (88 packets, lengths 1–22) | all addresses incl. 3 | LARGE, MAX |
| `coverage_test` → `yapp_coverage_seq` | **everything**: each length bucket × each address × good/bad parity (40 packets) | — |

`yapp_coverage_seq` is the "modify your stimulus to achieve coverage" step of
the lab. Run it with several seeds (`+SVSEED=random`) and merge the results in
IMC to see 100% on the three requirements.

## Running with coverage

```bash
cd labs/lab10_cov/tb
make run TEST=coverage_test          # run.f already has -coverage U -covoverwrite
imc -load cov_work/scope/coverage_test
```

In IMC (or SimVision → Windows → Tools → Coverage): *Verification Hierarchy →
uvm_pkg → …yapp_tx_monitor*, right-click → *Cover Group Analysis*, open the
*Items* of `yapp_pkt_cg`.
