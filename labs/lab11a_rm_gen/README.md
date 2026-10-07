# Lab 11A — Register model generation

In the Cadence training the register model is generated from the IP-XACT file
with `reg_verifier`:

```
reg_verifier -domain uvmreg -top yapp_router_regs.xml -dut yapp_router_regs \
             -out_file yapp_router_regs -quicktest -cov -pkg yapp_router_reg_pkg
```

That tool is not part of this repository, so the equivalent model is written by
hand in `yapp_router_reg_pkg.sv` (same class names the manual refers to:
`yapp_router_regs_t`, `yapp_regs_c`, `ctrl_reg_c` with field `plen`, ...).

Run the quick test with `make run_test` (or `xrun -f run.f`) and read the model
and map printouts to answer the lab questions.
