#!/usr/bin/env bash
set -euo pipefail

/home/ubuntu/opt/openmpi/bin/mpirun \
  -np 8 \
  --host compute01:4,compute02:4 \
  --map-by ppr:4:node \
  --bind-to core \
  hostname
