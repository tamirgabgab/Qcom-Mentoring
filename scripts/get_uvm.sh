#!/usr/bin/env bash
# Fetch a UVM library source tree for LINTING ONLY (not needed for xrun, which
# ships its own UVM). The Accellera 1800.2-2020 implementation is used with
# UVM_ENABLE_DEPRECATED_API so that UVM 1.1d / 1.2 style code (starting_phase,
# uvm_top, ...) elaborates.
set -euo pipefail
DEST="$(dirname "$0")/uvm_src"
if [ -d "$DEST/src" ]; then
  echo "UVM source already present in $DEST"
  exit 0
fi
echo "Cloning Accellera UVM into $DEST ..."
git clone --quiet --depth 1 https://github.com/accellera-official/uvm-core "$DEST"
echo "Done: $(grep -o 'Accellera:[^"]*' "$DEST/src/base/uvm_version.svh")"
