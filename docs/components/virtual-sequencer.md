# Virtual (multichannel) sequencer

A system-level test needs to say "program the router over the HBUS, **then**
send YAPP traffic, **then** reprogram it". No single agent can express that
ordering. A **virtual sequencer** is a sequencer that drives no interface: it
only holds handles to the real sequencers, and a **virtual sequence** running
on it starts sub-sequences on those handles.

```mermaid
flowchart LR
    T["router_simple_mcseq_test"] -->|"default_sequence"| MC["router_mcsequencer<br/>hbus_seqr, yapp_seqr"]
    MS["router_simple_mcseq<br/>p_sequencer"] -.->|runs on| MC
    MS -->|"`uvm_do_on(hbus_small_seq, p_sequencer.hbus_seqr)"| H["hbus sequencer → driver → DUT registers"]
    MS -->|"`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)"| Y["yapp sequencer → driver → DUT input"]
```

## The sequencer

```systemverilog
--8<-- "labs/lab08_mcseq/tb/router_mcsequencer.sv"
```

The handles are assigned in `router_tb.connect_phase` with **hierarchical
references** (no config strings, no wildcards):

```systemverilog
mcseqr.hbus_seqr = hbus.masters[0].sequencer;
mcseqr.yapp_seqr = yapp.agent.sequencer;
```

## The sequence

```systemverilog
--8<-- "labs/lab08_mcseq/tb/router_mcseqs_lib.sv"
```

* `` `uvm_declare_p_sequencer(router_mcsequencer) `` adds a typed
  `p_sequencer` handle (and a cast check when the sequence starts).
* `` `uvm_do_on(seq, seqr) `` / `` `uvm_do_on_with `` are `` `uvm_do `` with an
  explicit target sequencer.
* The objection is raised on the **virtual** sequence's starting phase; the
  sub-sequences see `null` and skip theirs.
* The channels are not controlled from here: they run `channel_rx_resp_seq`
  forever from the test. The Clock & Reset UVC is left out for simplicity.

## The test

```systemverilog
function void configure_sequences();
  set_clock_and_channel_sequences();
  uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                          "default_sequence", router_simple_mcseq::get_type());
  // NO default sequence on the YAPP or HBUS sequencers: the mcseq owns them
endfunction
```

## Reading the log

The multichannel sequence is easy to follow in the log: HBUS `WRITE
addr=0x1000 data=0x14`, `WRITE addr=0x1001 data=0x01`, `READ addr=0x1000
data=0x14`, six YAPP packets to channels 0/1/2 with their channel monitor
counterparts, `WRITE addr=0x1000 data=0x3f`, a read-back, six random packets.
If the interfaces overlap confusingly, insert `#100ns;` between the steps of
`body()`.
