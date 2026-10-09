#!/usr/bin/env bash
# setup_sim.sh -- install the free simulation flow of scripts/sim.py:
#   * Verilator (the version below; built from source unless already installed)
#   * UVM's DPI code in its Verilator flavour (uvm_hdl_verilator.c), next to Verilator
#   * the Accellera UVM source (scripts/get_uvm.sh) and PyYAML
#
#   bash scripts/setup_sim.sh                        # Verilator into /usr/local (sudo if needed)
#   PREFIX=$HOME/.local bash scripts/setup_sim.sh
#   SKIP_UVM=1 bash scripts/setup_sim.sh             # image builds: no repo checkout yet
#
# Works on Ubuntu / Debian, WSL2, GitHub Codespaces (.devcontainer) and CI. A
# build from source takes 10-25 minutes depending on the number of cores; on the
# official image verilator/verilator:<version> only the extras are added.
set -euo pipefail

VERILATOR_VERSION="${VERILATOR_VERSION:-v5.052}"
PREFIX="${PREFIX:-/usr/local}"
HERE="$(cd "$(dirname "$0")" && pwd)"
JOBS="$(nproc 2>/dev/null || echo 2)"
REPO=https://github.com/verilator/verilator

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null; then SUDO="sudo"; fi

echo "==> system packages"
if command -v apt-get >/dev/null; then
  $SUDO apt-get update -qq
  # build tools for Verilator; lz4 for FST waves; z3 solves the constraints of randomize()
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y -qq --no-install-recommends \
    ca-certificates git make autoconf g++ flex bison help2man perl python3 python3-yaml ccache \
    libfl2 libfl-dev zlib1g-dev liblz4-dev z3 >/dev/null
else
  echo "    no apt-get: install git make autoconf g++ flex bison perl python3 PyYAML zlib lz4 z3 yourself"
fi

VL="$(command -v verilator || true)"
if [ -n "$VL" ] && "$VL" --version | grep -q "^Verilator ${VERILATOR_VERSION#v} "; then
  echo "==> $("$VL" --version) already installed ($VL)"
else
  echo "==> building Verilator ${VERILATOR_VERSION} into $PREFIX ($JOBS jobs)"
  SRC="$(mktemp -d)"
  git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$VERILATOR_VERSION" "$REPO" "$SRC/verilator"
  (cd "$SRC/verilator" && autoconf && ./configure --prefix="$PREFIX" >/dev/null \
     && make -j"$JOBS" >/dev/null && $SUDO make install >/dev/null)
  rm -rf "$SRC"
  VL="$PREFIX/bin/verilator"
fi

VROOT="$("$VL" --getenv VERILATOR_ROOT)"
DPI="$VROOT/uvm-dpi/v2020_3_1/dpi"
if [ -f "$DPI/uvm_dpi.cc" ]; then
  echo "==> UVM DPI for Verilator already in $DPI"
else
  echo "==> UVM DPI for Verilator -> $DPI"
  SRC="$(mktemp -d)"
  git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$VERILATOR_VERSION" --filter=blob:none --sparse "$REPO" "$SRC/verilator"
  (cd "$SRC/verilator" && git sparse-checkout set test_regress/t/uvm/v2020_3_1)
  $SUDO mkdir -p "$VROOT/uvm-dpi"
  $SUDO cp -r "$SRC/verilator/test_regress/t/uvm/v2020_3_1" "$VROOT/uvm-dpi/"
  rm -rf "$SRC"
fi

if [ "${SKIP_UVM:-0}" != "1" ]; then
  echo "==> Accellera UVM source (scripts/uvm_src)"
  bash "$HERE/get_uvm.sh"
fi

"$VL" --version
case ":$PATH:" in *":$(dirname "$VL"):"*) ;; *) echo "add $(dirname "$VL") to your PATH";; esac
echo "done -- try:  cd yapp_project/tb && make sim TEST=reg_function_test"
