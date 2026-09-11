#!/usr/bin/env bash
set -u

echo '=== Build tools ==='
for x in gcc gfortran cmake git; do
  if command -v "$x" >/dev/null 2>&1; then echo "[OK] $x -> $(command -v $x)"; else echo "[MISSING] $x"; fi
done

echo
echo '=== MPI ==='
export PATH="$HOME/opt/openmpi/bin:$PATH"
for x in mpicc mpifort mpirun; do
  if command -v "$x" >/dev/null 2>&1; then echo "[OK] $x -> $(command -v $x)"; else echo "[MISSING] $x"; fi
done
mpirun --version 2>/dev/null | head -2 || true

echo
echo '=== Numerical libraries ==='
[ -e "$HOME/opt/openblas/lib/libopenblas.so.0" ] && echo '[OK] custom OpenBLAS' || echo '[INFO] custom OpenBLAS path not found'
[ -e /lib/x86_64-linux-gnu/libscalapack-openmpi.so ] && echo '[OK] ScaLAPACK OpenMPI' || echo '[INFO] expected ScaLAPACK path not found'
