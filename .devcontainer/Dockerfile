# Development container for GitHub Codespaces / VS Code Dev Containers:
# the official Verilator image plus what scripts/sim.py needs (lz4 for FST waves,
# z3 for randomize(), UVM's DPI code for Verilator, PyYAML).
FROM verilator/verilator:v5.052

# the image starts verilator itself; a dev container needs a plain shell
ENTRYPOINT []

COPY scripts/setup_sim.sh /tmp/setup_sim.sh
RUN SKIP_UVM=1 bash /tmp/setup_sim.sh \
    && rm /tmp/setup_sim.sh \
    && rm -rf /var/lib/apt/lists/*
