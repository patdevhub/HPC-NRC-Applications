#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/opt/openmpi/bin:$PATH"

echo '=== Ping ==='
ping -c 2 compute01
ping -c 2 compute02

echo '=== SSH hostnames ==='
ssh compute01 hostname
ssh compute02 hostname

echo '=== 2-rank cross-node MPI ==='
mpirun -np 2 --host compute01,compute02 hostname

echo '=== 8-rank placement ==='
mpirun -np 8 --host compute01:4,compute02:4 --map-by ppr:4:node --bind-to core hostname
