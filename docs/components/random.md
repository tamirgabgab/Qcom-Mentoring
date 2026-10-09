# Random values — `rnd::`

Two kinds of randomness live in a UVM testbench:

* **Fields of an object** — a packet's `addr`, a sequence's `count`. They are
  `rand` members with constraints, drawn by `req.randomize() with { ... }`. That
  stays as it is: the constraints belong to the class, and a factory override
  can change them.
* **A loose value** — which parity bit to flip, how many bytes to fill, which
  element of a queue to pick. These come from the common library
  `common/rand_util_pkg.sv`, never from a bare `$urandom` / `$urandom_range`.

The library is one package with static functions, imported by every UVC
package and by `tb_top`, so a component, a sequence or a test just calls it:

```systemverilog
int unsigned bad_bit;
bad_bit = rnd::get_index(8, {get_full_name(), ".bad_parity_bit"});   // 0..7
parity[bad_bit] = ~parity[bad_bit];

payload = rnd::get_bytes(length, {get_full_name(), ".payload"});     // bit [7:0] []
```

## The functions

| Call | Returns |
|---|---|
| `rnd::get_bit(name)` | `bit`: 0 or 1 |
| `rnd::get_int(min, max, name)` | `int` in `[min:max]`, both ends included (negative values allowed) |
| `rnd::get_uint(min, max, name)` | `int unsigned` in `[min:max]` |
| `rnd::get_byte(name)` | `bit [7:0]`: 0..255 |
| `rnd::get_bits(width, name)` | `bit [63:0]` with `width` (1..64) random low bits, the rest 0 |
| `rnd::get_index(size, name)` | `int unsigned` in `0 .. size-1`, an index into a collection |
| `rnd::get_bytes(size, name)` | `rnd_bytes_t` (`bit [7:0] []`): `size` random bytes |
| `rnd::get_byte_queue(size, name)` | `rnd_byte_q_t` (`bit [7:0] [$]`): `size` random bytes |
| `rnd_array #(N)::get_bytes(name)` | `bit [7:0] [N]`: a fixed-size array |

```systemverilog
bit [7:0] key[8];
bit [7:0] hdr[$];
key = rnd_array #(8)::get_bytes("key_test.key");
hdr = rnd::get_byte_queue(4, "key_test.header");
```

The fixed-size array has its own parameterized class because a dynamic array
cannot be assigned to a fixed-size one in every simulator (Verilator refuses it).

## The name argument

The last argument is optional, but give it: many components draw a single
bit or a small index, and when a draw fails the name tells which one.
`{get_full_name(), ".field"}` gives the instance path for free. A failure stops
the simulation with a `UVM_FATAL`:

```text
UVM_FATAL rand_util_pkg.sv(98) @ 0: reporter [RND] uvm_test_top.env.delay: get_int(5, 3): min is greater than max
```

Without a name the message says `<unnamed>`.

## How it works

Every function draws with `std::randomize()`, so the values follow the
simulation seed (`+SVSEED` on Xcelium, `SEED=` with `make sim`) exactly like
`$urandom` does. Arrays are sized first (`new[size]`) and randomized afterwards:
a size constraint inside `std::randomize() with { q.size() == n; }` is not
honoured by every simulator (Verilator 5.052 returns an empty queue).

On Verilator every `std::randomize()` call goes through the constraint solver
(z3), which costs a few tenths of a millisecond. A call per packet is free; a loop
of a million draws is not, and there `$urandom_range` inside the library would
be the place to optimise.

## Common mistakes

* **Drawing twice for one decision.**
  `parity[rnd::get_index(8)] = ~parity[rnd::get_index(8)];` picks two different
  bits, exactly like the old `$urandom_range` bug. Draw once into a variable.
* **Replacing an object's `randomize()`.** A packet's `length` must keep its
  constraint (`c_length`) and stay overridable (`short_yapp_packet`); it is not a
  loose value.
* **`min > max`.** `rnd::get_int(hi, lo)` is a fatal error, not an empty range.
