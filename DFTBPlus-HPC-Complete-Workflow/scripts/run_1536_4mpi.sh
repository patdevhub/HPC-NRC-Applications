#!/usr/bin/env bash
set -euo pipefail
WORK=/home/ubuntu/dftb-fuel-hpc/inputs/benzene_1536
MPI=/home/ubuntu/opt/openmpi/bin/mpirun
DFTB=/home/ubuntu/dftbplus-install/bin/dftb+
ssh compute01 "cd '$WORK' && rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd"
export OMP_NUM_THREADS=1
"$MPI" -np 4 --host compute01:4 --map-by ppr:4:node --bind-to core --wdir "$WORK" -x OMP_NUM_THREADS "$DFTB"
