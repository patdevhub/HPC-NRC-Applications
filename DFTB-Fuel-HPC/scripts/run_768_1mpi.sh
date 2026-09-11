#!/usr/bin/env bash
set -euo pipefail
WORKDIR="/home/ubuntu/dftb-fuel-hpc/inputs/benzene_768"
DFTB="/home/ubuntu/dftbplus-install/bin/dftb+"

ssh compute01 "cd '$WORKDIR' && rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd eigenvec.bin"
ssh compute01 "cd '$WORKDIR' && export OMP_NUM_THREADS=1 && ulimit -s unlimited && /usr/bin/time -v '$DFTB'"
