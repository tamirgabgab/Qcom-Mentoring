# Lab 10 — A simple functional coverage model *(optional)*

[Open on the project map →](../project-map.md#view=classes&node=cls:yapp_tx_monitor){ .pm-link }


**Directory:** `labs/lab10_cov` · **Changed:** `yapp_project/uvc/yapp/yapp_tx_monitor.sv` (covergroup),
`yapp_project/uvc/yapp/yapp_tx_seqs.sv` (`yapp_coverage_seq`), `tb/router_test_lib.sv`, `run.f` (`-coverage U`)

## Objective

Learn where coverage lives in a UVM environment (the monitor), write a
covergroup for three requirements, find the holes and close them with better
stimulus.

## Requirements

| Req | Statement |
|---|---|
| REQ1 | all packet lengths were sent: bins for min, small, medium, large, max |
| REQ2 | every address received a packet — **including the illegal address 3** |
| REQ3 | every length bin was sent to every legal address **with a parity error** |

## Solution

### 1. The covergroup in `yapp_tx_monitor`

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

function new(string name, uvm_component parent);
  super.new(name, parent);
  item_collected_port = new("item_collected_port", this);
  yapp_pkt_cg = new();              // a class covergroup is created with new()
endfunction
...
yapp_pkt_cg.sample(pkt.length, pkt.addr, pkt.parity_type);   // in collect_packets()
```

### 2. Stimulus that closes the model — `yapp_coverage_seq`

Every length bucket × every address (0..3) × good/bad parity = 40 packets.
The packet's `c_addr_legal` constraint is switched off to reach address 3.

```systemverilog
task yapp_coverage_seq::body();
  int lengths[5] = '{1, 5, 20, 50, 63};   // one value inside each bin
  for (int a = 0; a < 4; a++)
    foreach (lengths[i])
      for (int bad = 0; bad < 2; bad++) begin
        req = yapp_packet::type_id::create("req");
        req.c_addr_legal.constraint_mode(0);        // before randomize(): allow addr 3
        if (!req.randomize() with { req.addr == a; req.length == lengths[i];
                                    req.parity_type == (bad ? BAD_PARITY : GOOD_PARITY); })
          `uvm_error(get_type_name(), "Randomization failed")
        start_item(req);
        finish_item(req);
      end
endtask : body
```

The constraint is switched off on the object *before* `randomize()`, which is
why the sequence randomizes first and only then does `start_item` /
`finish_item`.

### 3. `coverage_test`

Full-size packets (no override), `yapp_coverage_seq` on the YAPP sequencer,
channels and clock as usual. `maxpktsize` keeps its reset value 63, so only
the address-3 packets are dropped (the reference model expects that).

### 4. `run.f`

```
-coverage U        // collect functional coverage
-covoverwrite
```

## Run

```bash
make run TEST=router_simple_mcseq_test   # see the holes
make run TEST=coverage_test              # close them
make gui TEST=coverage_test              # Windows -> Tools -> Coverage
imc -load cov_work/scope/coverage_test   # or IMC standalone
```

In IMC: *Verification Hierarchy → uvm_pkg → … yapp_tx_monitor* → right-click →
*Cover Group Analysis* → *Items* of `yapp_pkt_cg`.

**Expected:** with `router_simple_mcseq_test` (short packets) `LARGE`, `MAX`
and `illegal_addr` are empty and most of the cross is uncovered; the monitor's
report line shows the percentage. With `coverage_test` all 5 length bins, all
4 address bins, both parity values and all 15 cross bins are hit: 100%.

## Checkpoint questions

??? question "Why is the covergroup in the monitor and not in the sequence or the driver?"
    The monitor records what *actually* went across the interface — including
    traffic from other sources, dropped or corrupted items — and it exists in
    passive agents too. Sequences only know what they *intended* to send.

??? question "Why `bins illegal_addr = {3}` and not `illegal_bins`?"
    `illegal_bins` turns every hit into an error. REQ2 asks whether address 3
    was *exercised*, so it must be a counted bin.

??? question "What do the `ignore_bins` in the cross achieve?"
    They remove combinations that are not part of REQ3 (good parity, illegal
    address) from the denominator, so 100% means exactly "every size to every
    legal address with a parity error".

??? question "Why `option.per_instance = 1`?"
    Coverage is reported per monitor instance rather than merged for the type.
    With one YAPP monitor it makes no difference, but a UVC with several
    instances (the channel monitor) would want it.

## What changed since the previous lab

```bash
diff labs/lab06_vif/sv/yapp_tx_monitor.sv yapp_project/uvc/yapp/yapp_tx_monitor.sv   # covergroup + analysis port
diff -r labs/lab09_sbc/tb labs/lab10_cov/tb
```
