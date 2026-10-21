# Glossary

The words of the course, in the sense they have in this project, each with the page that shows
the thing itself. UVM names are the class or macro names; the YAPP names are the ones in the code.

## UVM

| Term | Meaning here | See |
|---|---|---|
| **agent** | One protocol's driver, sequencer and monitor in one component (`yapp_tx_agent`, `channel_rx_agent`, `hbus_master_agent`); `is_active` decides whether the driver and sequencer exist. | [Agent and env](components/agent-env.md) |
| **analysis port / imp / export** | A one-to-many TLM connection: a monitor `write()`s to its `uvm_analysis_port`; every subscriber's `uvm_analysis_imp` receives it; an `uvm_analysis_export` passes it through an env boundary. | [TLM connections](uvm/tlm.md), [Lab 9A](labs/lab09a.md), [Lab 9C](labs/lab09c.md) |
| **analysis FIFO** | `uvm_tlm_analysis_fifo`: an analysis imp with a queue behind it, so a consumer can `get()` in its own time (the Lab 9D scoreboard). | [Lab 9D](labs/lab09d.md) |
| **backdoor** | Reading or writing a register through its HDL path (`hw_top.dut.u_regs.ctrl_reg`), without the bus; `peek()` / `poke()`. | [Register model](components/register-model.md) |
| **config_db** | `uvm_config_db#(T)::set/get` (and the course's `uvm_config_int`): a name-addressed database the test fills before `build_phase` and components read in theirs (`is_active`, `channel_id`, the virtual interfaces). | [Factory and configuration](uvm/factory-config.md) |
| **coverage collector** | A `uvm_subscriber` holding a covergroup and sampling it in `write()` (`yapp_pkt_coverage`, `router_coverage`, the HBUS collectors). | [Functional coverage](components/coverage.md) |
| **drain time** | How long the run phase stays alive after the last objection drops (`set_drain_time`), so the last packet reaches the output before the end. | [Phases and objections](uvm/phases.md) |
| **driver** | Takes items from its sequencer (`get_next_item` / `item_done`) and drives the pins through the virtual interface. | [Driver](components/driver.md) |
| **env** | The container that builds agents and connects them; `router_tb` is the testbench env, each UVC has its own (`yapp_env`, `hbus_env`). | [Agent and env](components/agent-env.md) |
| **factory** | `type_id::create()` instead of `new()`, so a test can swap a class for a subclass with `set_type_override_by_type` without touching the code that creates it. | [Factory and configuration](uvm/factory-config.md), [Lab 4](labs/lab04.md) |
| **front door** | A register access through the bus (the HBUS UVC and its adapter), as opposed to the backdoor. | [Register model](components/register-model.md) |
| **monitor** | Watches the interface, rebuilds the transaction and publishes it on an analysis port; never drives. | [Monitor](components/monitor.md) |
| **objection** | `phase.raise_objection` / `drop_objection`: what keeps the run phase alive; a sequence raises one in `pre_body` and drops it in `post_body`. | [Phases and objections](uvm/phases.md) |
| **phase** | The steps UVM runs every component through in order: `build`, `connect`, `end_of_elaboration`, `run` (the only one that takes time), `extract`, `check`, `report`. | [Phases and objections](uvm/phases.md) |
| **predictor** | The part of the register model that keeps the mirror up to date (`auto_predict` here: the value is predicted from the access the model itself made). | [Lab 11B](labs/lab11b.md) |
| **reference model** | A transaction-level copy of the DUT's rules (`router_reference`): given what went in, it says what must come out. | [Reference model](components/reference-model.md) |
| **register model (RAL)** | `uvm_reg_block` / `uvm_reg` / `uvm_reg_field` classes mirroring the DUT's registers (`yapp_router_regs_t`), with `write` / `read` / `mirror` and the built-in sequences. | [Register model](components/register-model.md) |
| **scoreboard** | Compares what the monitors saw on the outputs with what the reference model expected; counts matches and mismatches. | [Scoreboard](components/scoreboard.md) |
| **sequence** | A `uvm_sequence` whose `body()` creates items and sends them through `start_item` / `finish_item`; sequences nest (`seq.start(sequencer, this)`). | [Sequencer and sequences](components/sequences.md) |
| **sequence item** | The transaction a sequence produces and a driver consumes (`yapp_packet`, `hbus_transaction`); randomized with constraints. | [Packet](components/packet.md) |
| **sequencer** | Arbitrates between the sequences running on it and hands their items to the driver. | [Sequencer and sequences](components/sequences.md) |
| **subscriber** | `uvm_subscriber #(T)`: a component with a built-in analysis imp and a `write()` to override (the coverage collectors). | [Functional coverage](components/coverage.md) |
| **test** | A `uvm_test` subclass picked by `+UVM_TESTNAME`; builds the testbench and decides what runs (`base_test` and everything that extends it). | [Lab 2](labs/lab02.md), [Test plan](test-plan.md) |
| **UVC** | UVM Verification Component: a reusable package with the agent(s), env, interface, sequences and transaction of one protocol (`yapp`, `hbus`, `channel`, `clock_and_reset`, and the router *module* UVC). | [Project architecture](uvm/architecture.md) |
| **virtual interface** | A class-side handle to an interface instance (`virtual yapp_if m_vif`), set by `tb_top` into the config_db and fetched by the driver and monitor. | [Lab 6](labs/lab06.md) |
| **virtual sequencer** | A sequencer with no driver that holds handles to the real sequencers (`router_mcsequencer`), so one *multichannel* sequence can drive several UVCs. | [Virtual sequencer](components/virtual-sequencer.md) |

## The project

| Term | Meaning here | See |
|---|---|---|
| **back-pressure** | A channel receiver raising `suspend` so the router's output FIFO stops sending; the input side stalls when the FIFO is full. | [DUT specification](dut/spec.md) |
| **channel** | One of the three output ports (`ch0`, `ch1`, `ch2`); the packet's address selects it. | [DUT specification](dut/spec.md) |
| **drop** | A packet the router does not forward: address 3, bad parity, longer than `maxpktsize`, or `router_en` off; the reference model predicts every drop. | [Test plan](test-plan.md) |
| **gap** | The idle cycles between two packets on the input (`packet_delay`); 0 means back to back. | [Lab 10](labs/lab10.md) |
| **HBUS** | The host bus: the port through which the registers and memories are written and read (`haddr`, `hdata`, `hen`, `hwr_rd`). | [Register map](dut/register-map.md) |
| **`hdata_w`** | The tri-state wire of `hbus_if` that is connected to the DUT, driven by the master only during writes (`hdata` and `hdata_oe` are the master's side). | [Lab 7](labs/lab07.md) |
| **`maxpktsize`** | `ctrl_reg[5:0]`: the longest payload the router forwards. | [Register map](dut/register-map.md) |
| **mutant / bug hunt** | A deliberate bug in the RTL behind a `` `define `` (`BUG_*`) that the regression must catch; one page lists every bug and the tests that find it. | [Bug hunt](bug-hunt.md) |
| **packet** | Header (`addr[1:0]`, `length[5:0]`), `length` payload bytes, a parity byte that XORs everything before it. | [Packet](components/packet.md) |
| **parity** | The XOR of the header and the payload; `PARITY_TYPE_BAD` packets carry a wrong one on purpose. | [Packet](components/packet.md) |
| **`rnd::`** | The project's random-value library (`common/rand_util_pkg.sv`): every random number outside a `randomize()` goes through it. | [Random values](components/random.md) |
| **`router_en`** | `en_reg[0]`: the router forwards nothing while it is 0. | [Register map](dut/register-map.md) |
| **seed** | The number that makes a random run reproducible (`SEED=`, `+SVSEED=`); the regression runs every test with several. | [Regression results](regression/index.md) |
| **`start/`** | The directory a student works in: the lab with its method bodies emptied, `TASKS.md` next to it. | [Getting started](getting-started.md#working-on-a-lab-start-and-make-check) |
| **test plan** | The list of DUT features, each with its stimulus, checker, coverage and the tests that cover it. | [Test plan](test-plan.md) |
