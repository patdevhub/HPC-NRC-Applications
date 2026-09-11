#!/usr/bin/env bash
set -u
export PATH="$HOME/dftbplus-install/bin:$HOME/opt/openmpi/bin:$PATH"

echo '=== Commands ==='
which dftb+ || true
which mpicc || true
which mpifort || true
which mpirun || true

echo
echo '=== MPI version ==='
mpirun --version 2>/dev/null | head -3 || true

echo
echo '=== DFTB+ linked libraries ==='
if command -v dftb+ >/dev/null 2>&1; then
  ldd "$(command -v dftb+)" | grep -Ei 'mpi|scalapack|openblas|blas|lapack' || true
else
  echo 'DFTB+ not on PATH'
fi
