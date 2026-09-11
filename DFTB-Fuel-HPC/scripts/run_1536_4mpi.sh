#!/usr/bin/env bash
set -euo pipefail
export OMP_NUM_THREADS=1
ulimit -s unlimited
WORKDIR="/home/ubuntu/dftb-fuel-hpc/inputs/benzene_1536"
DFTB="/home/ubuntu/dftbplus-install/bin/dftb+"

ssh compute01 "cd '$WORKDIR' && rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd eigenvec.bin"

time /home/ubuntu/opt/openmpi/bin/mpirun \
  -np 4 \
  --host compute01:4 \
  --map-by core \
  --bind-to core \
  --wdir "$WORKDIR" \
  -x OMP_NUM_THREADS=1 \
  "$DFTB" \
  2>&1 | tee "$HOME/dftb-fuel-hpc/benchmarks/benzene_1536_4mpi.log"
