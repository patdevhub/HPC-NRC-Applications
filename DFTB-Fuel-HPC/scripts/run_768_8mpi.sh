#!/usr/bin/env bash
set -euo pipefail
export OMP_NUM_THREADS=1
ulimit -s unlimited
WORKDIR="/home/ubuntu/dftb-fuel-hpc/inputs/benzene_768"
DFTB="/home/ubuntu/dftbplus-install/bin/dftb+"

for host in compute01 compute02; do
  ssh "$host" "cd '$WORKDIR' && rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd eigenvec.bin"
done

time /home/ubuntu/opt/openmpi/bin/mpirun \
  -np 8 \
  --host compute01:4,compute02:4 \
  --map-by ppr:4:node \
  --bind-to core \
  --wdir "$WORKDIR" \
  -x OMP_NUM_THREADS=1 \
  "$DFTB" \
  2>&1 | tee "$HOME/dftb-fuel-hpc/benchmarks/benzene_768_8mpi.log"
