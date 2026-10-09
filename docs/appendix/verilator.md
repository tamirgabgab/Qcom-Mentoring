# Simulating with Verilator

The course targets Cadence Xcelium (`make run`). When no Xcelium licence is at
hand, every lab and the complete project also run on
[Verilator](https://verilator.org), a free, open-source simulator, from the
**same `run.f` files**. Verilator 5.052 runs UVM 2020-3.x; the few places where
it differs from Xcelium are handled in the code (see [below](#what-differs-from-xcelium)).

| | Xcelium | Verilator |
|---|---|---|
| Compile + run one test | `make run TEST=<test>` | `make sim TEST=<test>` |
| Waves | `make gui` (SimVision) | `make sim TEST=<test> WAVES=1`, then `make waves TEST=<test>` |
| Every lab and test | -- | `make regress` at the root |
| Licence | Cadence | none (LGPL) |

## Getting a machine with Verilator

=== "GitHub Codespaces (nothing to install)"

    On the repository page: **Code → Codespaces → Create codespace on main**.
    The first start builds the container from `.devcontainer/` (a few minutes);
    VS Code opens in the browser with Verilator, the UVM source, a SystemVerilog
    syntax extension and the **VaporView** waveform viewer installed.

    The container asks for a 4-core machine (`hostRequirements` in
    `.devcontainer/devcontainer.json`), which halves the free monthly hours but
    also halves the compile time. Stop the codespace when you are done.

=== "Linux / WSL2"

    ```bash
    bash scripts/setup_sim.sh        # or: make setup-sim
    ```

    The script installs the build tools with `apt-get`, builds Verilator 5.052
    into `/usr/local` (10-25 minutes, once), copies UVM's DPI code for Verilator
    next to it and fetches the Accellera UVM source. `PREFIX=$HOME/.local` installs
    without `sudo`. On Windows, install WSL2 with Ubuntu first
    (`wsl --install -d Ubuntu` in PowerShell) and run the script inside it.

=== "Docker"

    `.devcontainer/Dockerfile` builds on the official `verilator/verilator:v5.052`
    image; VS Code's *Dev Containers: Reopen in Container* uses it locally.

## Running

```bash
cd yapp_project/tb
make compile                                   # once; about 2.5 minutes with UVM
make sim TEST=reg_function_test                # PASS / FAIL at the end
make sim TEST=backpressure_test WAVES=1 SEED=7 # record waves, another seed
make waves TEST=backpressure_test              # open the waves
```

`make sim` compiles first when a source changed; choosing another test does not
recompile (the test is picked at run time with `+UVM_TESTNAME`). Everything goes
to `build/sim/<directory>/`: `compile.log`, `logs/<test>_s<seed>.log`,
`waves/<test>.fst`. The plusargs of `run.f` (`+UVM_VERBOSITY=...`) are passed
on; more can be added with `SIM_OPTS="+UVM_VERBOSITY=UVM_HIGH"`.

A run **passes** when it ends normally with no `UVM_ERROR` and no `UVM_FATAL`.

**Waves.** `WAVES=1` records the whole design into an FST file. In Codespaces,
open the file from the Explorer (VaporView opens `.fst`); on a desktop
`make waves` starts `surfer` or `gtkwave` when one is installed.

From the root: `make sim LAB=lab07_integ TEST=simple_test`,
`make sim-project TEST=reg_function_test WAVES=1`.

## The regression

`make regress` compiles every simulation directory listed in
`scripts/regress.yaml` once and runs each of its tests (`SEEDS=3` for more
seeds, `ONLY=lab09` for some directories). The table goes to
`build/sim/regress.md`.

The **sim** workflow of GitHub Actions (`.github/workflows/sim.yml`) runs the
same regression on every push, one job per directory, in the official Verilator
container; the table appears on the run's summary page and the logs of a failure
are kept as an artifact.

## What differs from Xcelium

Verilator compiles the design to C++. It is a two-state simulator (no `x`/`z`)
and its constraint solver and coverage are younger than Xcelium's. These are the
points that touch this code, and how the code deals with them; every change also
runs unchanged on Xcelium.

| Topic | Verilator 5.052 | In the code |
|---|---|---|
| `payload.size() == length` under `randomize() with {...}` | the array is not resized: packets would go out without payload | `yapp_packet::post_randomize()` sizes `payload` to `length` when the solver did not |
| `dist` together with an equality in `with {...}` | randomly unsatisfiable (the `dist` bucket is chosen first) | sequences that choose the parity themselves switch `c_parity_dist` off |
| `'z` on a wire (two-state) | `hdata_w !== 8'bz` is always true | `hbus_protocol_test`, under `` `ifdef VERILATOR ``: no driver enabled |
| Enum coverpoint without bins | binned by value range, not one bin per value | `parity_cp` lists its two bins |
| `ignore_bins ... binsof() intersect` in a cross | ignored (warning `COVERIGN`) | `yapp_pkt_cg`, under `` `ifdef VERILATOR ``: the cross is built from coverpoints that hold only the wanted bins (same 15 bins) |
| `--public-flat-rw` on the whole design | does not compile with UVM | `common/verilator/public.vlt` opens only the register block (RAL backdoor) |
| A comment that starts with the word `verilator` | read as a Verilator directive | avoid it |

Not used by this code, but known to be incomplete in Verilator: clocking blocks
through virtual interfaces, `disable fork`, `process::kill()`.

**What still needs Xcelium:** four-state behaviour (`x` propagation, the real
`'z` on HBUS), coverage numbers that match IMC, and the Cadence-specific steps
(SimVision, IMC, `reg_verifier`). See [Known-unverified items](unverified.md).
