# Packet — the sequence item

A sequence item is the **unit of stimulus**: one object that describes one
transaction. For YAPP that is one packet; for HBUS one read or write; for the
channel one "receive a packet with this response delay".

## What a sequence item must have

| Element | `yapp_packet` | Why |
|---|---|---|
| base class `uvm_sequence_item` | ✔ | sequencers and drivers are parameterized with it |
| `` `uvm_object_utils_begin/end `` with field macros | `addr`, `length`, `payload`, `parity`, `parity_type`, `packet_delay` | factory registration + `print/copy/compare/pack` |
| constructor `new(string name = "...")` | ✔ | objects have a name, no parent |
| `rand` fields + constraints | legal address, length/payload size, parity distribution, delay | random stimulus with the rules of the protocol |
| derived values | `parity` via `set_parity()` in `post_randomize()` | computed from the random fields |
| **control knobs** | `parity_type`, `packet_delay` | not on the wire; steer the driver / the error injection |

## The reference implementation

```systemverilog
--8<-- "yapp/sv/yapp_packet.sv"
```

## Design notes

* **Named constraints** (`c_addr_legal`, ...) can be switched off:
  `req.c_addr_legal.constraint_mode(0)` is how `yapp_88_packets_seq` sends to
  the illegal address 3.
* `parity` is **not** `rand`: it is a function of the other fields. It is
  recomputed in `post_randomize()`, and `set_parity()` is public so a sequence
  that edits the payload afterwards (`yapp_incr_payload_seq`) can call it.
* `packet_delay` has `UVM_NOCOMPARE`: two packets with the same contents are
  equal even if they were sent with different gaps.
* `short_yapp_packet` adds a constraint, nothing else. The factory override in
  the tests turns every packet into a short one.

## Try it (Lab 1)

```systemverilog
pkt.print();                          // table of all fields
$cast(clone_pkt, pkt.clone());        // new object with the same contents
copy_pkt.copy(pkt);                   // into an existing object
pkt.compare(clone_pkt);               // 1 if equal (reports the first difference)
pkt.print(uvm_default_tree_printer);  // same data, other layout
```

## Common mistakes

* Forgetting `payload.size() == length` in the constraint → random array size.
* Making `parity` `rand` → the parity is wrong *unless* you add a constraint,
  and then you cannot inject errors.
* Declaring `parity_type_e` inside the class → sequences cannot name
  `GOOD_PARITY` / `BAD_PARITY` (`` `uvm_do_with `` constraints reference them).
* Using `new()` instead of `type_id::create()` in sequences → the factory
  override of Lab 4 never applies.
