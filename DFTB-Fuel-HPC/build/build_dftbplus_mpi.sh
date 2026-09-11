#!/usr/bin/env bash
set -euo pipefail

# Tested environment from the VMware mini-HPC lab.
# DFTB+ source directory:
SOURCE_DIR="${SOURCE_DIR:-$HOME/dftbplus}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/dftbplus-install}"

# Custom OpenMPI installation used in the tested environment.
export PATH="$HOME/opt/openmpi/bin:$PATH"

cd "$SOURCE_DIR"

FC=mpifort CC=mpicc cmake \
  -DWITH_MPI=YES \
  -DWITH_OMP=YES \
  -DSCALAPACK_LIBRARY=/lib/x86_64-linux-gnu/libscalapack-openmpi.so \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
  -B _build .

cmake --build _build -- -j2
cmake --install _build

echo "DFTB+ installation complete."
echo "Executable: $INSTALL_DIR/bin/dftb+"
