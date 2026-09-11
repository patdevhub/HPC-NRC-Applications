# Phase 6 — MPI benchmark execution and findings

## Benchmark rule

Before timing a run, generated restart/output files were removed, especially `charges.bin`, so that one benchmark did not silently benefit from a previous calculation's restart charge state.

Inside the workload directory:

```bash
rm -f band.out charges.bin detailed.out detailed.xml dftb_pin.hsd
```

Do **not** delete the whole input directory.

## 1 rank

```bash
export OMP_NUM_THREADS=1
/home/ubuntu/opt/openmpi/bin/mpirun \
  -np 1 \
  --host compute01:4 \
  --wdir /home/ubuntu/dftb-fuel-hpc/inputs/benzene_768 \
  -x OMP_NUM_THREADS=1 \
  /home/ubuntu/dftbplus-install/bin/dftb+
```

Recorded DFTB+ wall time:

```text
52.77 s
```

## 2 ranks

Recorded wall time:

```text
20.13 s
```

Observed speedup versus 1 rank:

```text
52.77 / 20.13 ≈ 2.62×
```

Because this was a single benchmark run, the apparent superlinear result should be described as an **observed** result that can be influenced by cache, memory and timing effects; it is not proof of ideal scaling.

## 4 ranks

Recorded wall time:

```text
15.30 s
```

DFTB+ reported:

```text
MPI processes:               4
OpenMP threads:              1
BLACS orbital grid size:     2 x 2
BLACS atom grid size:        2 x 2
```

This was the fastest configuration tested for the 768-atom workload.

## 8 ranks across compute01 and compute02

Actual launch pattern:

```bash
export OMP_NUM_THREADS=1
ulimit -s unlimited

/home/ubuntu/opt/openmpi/bin/mpirun \
  -np 8 \
  --host compute01:4,compute02:4 \
  --map-by ppr:4:node \
  --bind-to core \
  --wdir /home/ubuntu/dftb-fuel-hpc/inputs/benzene_768 \
  -x OMP_NUM_THREADS=1 \
  /home/ubuntu/dftbplus-install/bin/dftb+
```

Recorded result:

```text
DFTB+ wall = 169.61 s

MPI processes:               8
OpenMP threads:              1
BLACS orbital grid size:     2 x 4
BLACS atom grid size:        2 x 4
```

## Scientific consistency

All completed 768-atom runs returned:

```text
Total Energy = -799.0006378657 H
             = -21741.9136 eV
```

Therefore the rank-count experiments changed execution performance, not the final reported total energy.

## 1536-atom stress test

4 ranks on compute01:

```text
Total Energy = -1597.9993748856 H
             = -43483.7754 eV
DFTB+ wall   = 120.63 s
```

8 ranks across both nodes were run with a 300-second timeout. The job progressed through SCC iterations but did not complete before termination.

## Main HPC conclusion

```text
1 rank  → 52.77 s
2 ranks → 20.13 s
4 ranks → 15.30 s   ← fastest
8 ranks → 169.61 s  ← inter-node overhead dominates
```

The experiment demonstrates why HPC benchmarking must measure actual execution rather than assuming that using every available core is automatically optimal.
