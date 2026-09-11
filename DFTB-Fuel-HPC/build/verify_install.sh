#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/dftbplus-install/bin:$HOME/opt/openmpi/bin:$PATH"

echo "=== Tool locations ==="
which mpicc
which mpifort
which mpirun
which dftb+

echo
echo "=== MPI version ==="
mpirun --version | head -3

echo
echo "=== DFTB+ linked parallel libraries ==="
ldd "$(which dftb+)" | grep -E "mpi|scalapack|openblas" || true
