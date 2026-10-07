# YAPP UVC

The interface UVC of the router's input port: `yapp_packet` (the sequence item), the
`yapp_tx_driver` / `yapp_tx_monitor` / `yapp_tx_sequencer` agent, `yapp_env`, the `yapp_if`
interface and the sequences under `seqs/`.

## The packet

![YAPP packet structure](../../../docs/assets/packet_structure.svg)

| Byte | Bits | Content |
|---|---|---|
| 0 (header) | `[7:2]` | `length` -- number of payload bytes, 1 .. 63 |
|  | `[1:0]` | `addr` -- output channel 0, 1 or 2; 3 is illegal |
| 1 .. length | `[7:0]` | `payload[0]` .. `payload[length-1]` |
| length + 1 | `[7:0]` | `parity` -- even bitwise parity: the XOR of the header and every payload byte |

`yapp_packet.sv` holds exactly these fields, plus two knobs that never reach the wire:
`parity_type` (GOOD_PARITY / BAD_PARITY -- what `set_parity()` writes) and `packet_delay`.
Build, decode and check packets interactively on the
[packet page of the course site](https://tamirgabgab.github.io/Qcom-Mentoring/components/packet/#try-it-build-or-check-a-packet).
