#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/opt/openmpi/bin:$PATH"
cd "$HOME/dftbplus"

FC=mpifort CC=mpicc cmake \
  -DWITH_MPI=YES \
  -DWITH_OMP=YES \
  -DSCALAPACK_LIBRARY=/lib/x86_64-linux-gnu/libscalapack-openmpi.so \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$HOME/dftbplus-install" \
  -B _build .

cmake --build _build -- -j2
cmake --install _build
