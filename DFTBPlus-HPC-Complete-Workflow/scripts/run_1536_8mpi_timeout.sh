#!/usr/bin/env bash
set -euo pipefail
WORK=/home/ubuntu/dftb-fuel-hpc/inputs/benzene_1536
MPI=/home/ubuntu/opt/openmpi/bin/mpirun
DFTB=/home/ubuntu/dftbplus-install/bin/dftb+
for n in compute01 compute02; do
  ssh "$n" "cd '$WORK' && rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd"
done
export OMP_NUM_THREADS=1
ulimit -s unlimited
timeout 300s "$MPI" -np 8 --host compute01:4,compute02:4 --map-by ppr:4:node --bind-to core --wdir "$WORK" -x OMP_NUM_THREADS "$DFTB"
