# Phase 5 — From validation molecule to hydrocarbon HPC workload

The water system proved correctness but was far too small to be a meaningful distributed-memory benchmark. The next workload was benzene, C6H6, an aromatic hydrocarbon consisting of six carbon atoms arranged in a ring and six hydrogen atoms.

## 1. 12-atom benzene test

The first benzene calculation itself was scientifically successful. A local SCC geometry optimization converged and produced:

```text
Total Energy = -12.5125046356 H
             ≈ -340.4826 eV
```

However, trying to use multiple MPI processes on such a tiny system generated the DFTB+ message:

```text
Insufficient atoms for this number of MPI processors
Processor grid (1 x 2) too big (> 1 x 1)
```

This was an important diagnostic result: MPI communication was not necessarily broken; the scientific problem was simply too small for that processor decomposition.

## 2. 96 atoms

The problem size was increased to:

```text
8 benzene molecules × 12 atoms = 96 atoms
```

A single-point SCC calculation completed with:

```text
Total Energy = -99.9501196556 H
             ≈ -2719.7811 eV
```

An 8-rank, two-node run also completed. It was much slower than the local calculation, which indicated that communication overhead was significant for this size.

## 3. 768 atoms — main benchmark

The main workload used:

```text
64 benzene molecules × 12 atoms = 768 atoms
4 × 4 × 4 molecular placement grid
6 Å spacing
```

Input files:

```text
inputs/benzene_768/benzene_768.gen
inputs/benzene_768/dftb_in.hsd
```

The geometry can be regenerated with:

```bash
python3 scripts/generate_benzene_cluster.py \
  --nx 4 --ny 4 --nz 4 \
  --output inputs/benzene_768/benzene_768.gen
```

## 4. 1536 atoms — stress test

The stress workload used:

```text
128 benzene molecules × 12 atoms = 1536 atoms
4 × 4 × 8 molecular placement grid
```

This system completed on 4 MPI ranks but the two-node 8-rank run exceeded the five-minute test limit.

## 5. Slater-Koster set

For the C/H benchmark, one consistent `3ob-3-1` parameter family was used:

```text
C-C.skf
C-H.skf
H-C.skf
H-H.skf
```

Do not mix `.skf` files from unrelated parameter families in one calculation.
