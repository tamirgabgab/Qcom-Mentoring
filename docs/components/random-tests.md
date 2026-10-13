# Random tests

The directed tests of the test plan each check one rule with values chosen by
hand. The random tests check all the rules at once, in combinations nobody
chose: the **seed decides the shape of the test** (how many packets, how many
bursts, which configuration, how each receiver behaves), not only the values
inside it. Nothing in them is checked by hand: the reference model, the
scoreboard and the error-pulse checker know the expected result of anything
the seed produces.

| Test | What it pushes |
|---|---|
| `random_test` | The balanced mix: 10..100 packets in 2..6 bursts, any configuration, any receiver profile |
| `random_config_test` | The configuration space: 4..8 short bursts, `maxpktsize` 0 / 1 / 62 / 63 most of the time, the router off now and then, mixed counter-enable masks, lengths at the boundaries, more packets to address 3 |
| `random_backpressure_test` | Back-pressure: slow and stalling receivers on a random mix of channels, long packets (40..63 bytes) sent mostly back to back |
| `random_parity_test` | Bad parity everywhere: 30..60 % bad packets, on forwarded, dropped (address 3, oversized) and ignored (router off) packets, and storms of 1..3-byte bad packets back to back |

The regression runs each of them with 8 seeds (`scripts/regress.yaml`), the
directed tests with 4.

## The scenario

`router_random_mcseq` (`yapp_project/tb/mcseqs/`) runs on the virtual
sequencer, which drives the HBUS and the YAPP input:

```text
draw: 10..100 packets, 2..6 bursts (every burst gets at least one packet)
for every burst:
    ctrl_reg = random (maxpktsize 0, 1, 62, 63 with extreme_pct, else 2..61; bits [7:6] random)
    en_reg   = random (router_en = 0 with router_off_pct; counter enables all / none / a random mask)
    a few random HBUS reads: counters, mem_size_reg, yapp_pkt_mem bytes, unmapped addresses,
                             a yapp_mem write and its read back
    the burst: yapp_random_burst_seq (or a "storm" with storm_pct)
final reads: every register, then yapp_pkt_mem[0..mem_size]
```

The configuration only changes between bursts, when every packet already sent
has been accepted by the router. The DUT decides at the header, the reference
model when the monitor publishes the packet (after its parity byte); with no
change in the middle of a packet they always agree. A change in the middle of a
packet is undefined in the specification (DROP-05, excluded).

Each burst prints a `[TEST] STAGE:` line with its configuration and how many
packets it sends, and another with what it sent:

```text
[TEST] STAGE: random scenario: 22 packets in 6 bursts
[TEST] STAGE: burst 2/6: ctrl=0x12 (maxpktsize 18) en=0xfe (router OFF, counter enables 1111111), 3 packet(s)
[TEST] STAGE: burst 2/6 sent: addr0..3 0/0/3/0, bad parity 0, gap 0 1, length 40..63
[TEST] STAGE: done: 22 packets (7 forwarded, 15 dropped), 0 storm burst(s), 7 scoreboard matches, 78 HBUS reads checked, 2 error pulses for 2 bad packets
```

### The knobs

`yapp_random_burst_seq` (YAPP UVC) draws, per packet:

| Knob | Default | Meaning |
|---|---|---|
| `addr3_pct` | 5 | packets to the illegal address 3 (the rest to 0..2) |
| `bad_pct` | 15 | packets with bad parity (one bit flipped) |
| `short_pct` | 0 | 1..3-byte packets |
| `long_pct` | 0 | 40..63-byte packets, longer than a channel FIFO |
| `boundary_pct` | 40 | one of 1, maxpktsize-1, maxpktsize, maxpktsize+1, 63 |
| *(the rest)* | | any length 1..63 |
| `gap0_pct` / `gap_short_pct` | 25 / 35 | gap before the packet: 0 (back to back), 1..3, else 4..20 |

Every choice comes from `rnd::` and is pinned with `==` in `randomize() with
{...}` (the packet's own `c_addr_legal`, `c_parity_dist` and `c_delay` are
switched off for that), so the payload stays random and nothing mixes `dist`
with `==` (see the Verilator notes in [Verilator](../appendix/verilator.md)).

`channel_rx_random_seq` (Channel UVC) gives every receiver a profile; a test
sets one sequence object per channel as that channel's `default_sequence`:

| Profile | Delay before reading a packet |
|---|---|
| `RX_FAST` | 0 |
| `RX_NORMAL` | 0..10 |
| `RX_SLOW` | 20..40 |
| `RX_STALLY` | usually 0..10, `stall_pct` (15 %) of the packets 50..150: the channel stops taking packets for a while |

The wait is always on the header, before a packet: a receiver never suspends in
the middle of one.

A new random test extends `random_test` and overrides two hooks:
`configure_scenario()` sets the knobs of `router_random_mcseq` (the burst knobs
above, `min_packets`, `max_bursts`, `extreme_pct`, `router_off_pct`,
`storm_pct`, ...) and `pick_profile()` chooses the receivers.

## The checking

| Who | Checks | Where |
|---|---|---|
| Scoreboard | every forwarded packet comes out of its channel unchanged and in order; **nothing is left** in the queues at the end (`check_phase`) | `router_scoreboard` |
| Reference model | its model of `ctrl_reg`, `en_reg`, the six counters (each with its own enable bit, wrapping at 255), `mem_size_reg`, `yapp_pkt_mem` (the header and the payload of the last packet received while enabled, dropped ones too; a shorter packet leaves the old tail) and `yapp_mem`; **every HBUS read** is compared with it | `router_reference`, `check_reads = 1` |
| Error-pulse checker | one `error` pulse per bad-parity packet received while the router is on, 1..10 cycles after its parity byte, overlapping packets included | `error_pulse_checker` |

The model follows the rules and the *Decisions* of the
[specification](../dut/spec.md#decisions-where-the-specification-is-silent).
The memories are not reset, so a byte the model has not seen written is not
checked (the report counts those reads). The directed register tests poke the
counters through the backdoor, which the model cannot see, so `check_reads` is
off unless a test sets it:

```systemverilog
uvm_config_db #(bit)::set(this, "tb.router_module.reference", "check_reads", 1'b1);
```

A wrong counter shows up as

```text
UVM_ERROR ... [REF_READ] HBUS read 0x100b returned 0x03, the model expects 0x04
```

### What the random tests found

The first `random_parity_test` storms found a real bug: a second bad packet
that ended before the first `error` pulse re-armed the single timer of
`yapp_error_timer`, and the first pulse was lost (one pulse for two packets,
against "`error` pulses 1..10 cycles after a packet with bad parity"). The timer
now keeps a schedule and gives every bad packet its own pulse
([RTL walkthrough](../dut/rtl.md#yapp_error_timer-the-error-pulse)). Putting the
old timer back makes `random_parity_test` fail with `no error pulse within 10
cycles of the bad packet`.

### Coverage

The reference model publishes a `router_decision` per packet received while
enabled; `router_coverage` (its own file, a subscriber of `decision_out`)
samples `router_cfg_cg` and prints what the test reached. Nothing fails on it,
it shows whether a seed hit the corners (`random_config_test`, one seed; only
packets received with the router on are counted):

```text
Coverage of the router configuration: 78.3%
  maxpktsize 0 / 1 / 2..61 / 62 / 63       : 0 / 12 / 6 / 0 / 7 packets
  length < max / = max / max+1 / > max+1   : 5 / 9 / 0 / 11
  forwarded good / bad                     : 11 / 0
  dropped address 3 good / bad             : 4 / 1
  dropped oversized good / bad             : 8 / 1
  counter enables none / mixed / all       : 13 / 12 / 0
```

The coverage of all the seeds together, with the bins no seed hit, is in
[Coverage results](../coverage-results.md).

## Running one seed again

```bash
make sim TEST=random_parity_test SEED=5 WAVES=1          # from yapp_project/tb
make regress ONLY=yapp_project WAVES=1 && make sim-report ONLY=yapp_project
```

The same seed gives the same scenario. The committed report
(`yapp_project/regression/index.md`) links every run to its waves in Surfer.
