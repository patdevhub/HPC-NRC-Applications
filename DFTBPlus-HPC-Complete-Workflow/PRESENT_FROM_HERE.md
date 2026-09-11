# Presentation walkthrough

Start here when presenting the repository.

## Opening

> “This repository documents the complete path from compiling DFTB+ on our Ubuntu VMware environment to running it across two compute nodes using MPI, measuring parallel scaling and visualizing a 768-atom hydrocarbon system.”

## Presentation sequence

### 1 — Architecture
Show the top of `README.md` and the node diagram. Explain that compute01 and compute02 each had 4 CPU cores, for 8 available MPI slots.

### 2 — Prerequisites
Open `docs/01_TOOLCHAIN_AND_DEPENDENCIES.md`. Explain why compilers, MPI, OpenBLAS and ScaLAPACK were checked before DFTB+.

### 3 — Compilation
Open `docs/02_DFTBPLUS_SOURCE_BUILD.md`. Highlight the successful CMake command. Explain `FC=mpifort`, `CC=mpicc`, `WITH_MPI=YES`, `WITH_OMP=YES`, and the explicit ScaLAPACK path.

### 4 — Verification
Show a screenshot of `which dftb+` and the `ldd` library check. Explain that the presence of a binary alone does not prove the intended MPI/numerical-library build.

### 5 — Small validation
Open `docs/03_H2O_VALIDATION.md`. Explain why H2O was used first: correctness before scale. Show the converged energy and the Waveplot → cube → Avogadro chain.

### 6 — VMware MPI
Open `docs/04_VMWARE_MPI_CHECKS.md`. Show the `mpirun ... hostname` evidence proving that a single MPI launch reached both compute nodes.

### 7 — Scale the science problem
Open `docs/05_HYDROCARBON_WORKLOADS.md`. Explain the progression 12 → 96 → 768 → 1536 atoms. Mention that the 12-atom MPI attempt was rejected because the problem was too small for the requested processor grid.

### 8 — Findings
Open `docs/06_MPI_BENCHMARKS.md` and `benchmarks/results.csv`. Emphasize 52.77 → 20.13 → 15.30 s as ranks increased within one node, followed by 169.61 s at 8 ranks across two VMs.

### 9 — Visualization
Open `visualization/benzene_768_structure.xyz` in Avogadro. Explain gray = carbon, white = hydrogen, 64 benzene molecules = 768 atoms total.

### 10 — Real HPC link
Finish with `docs/08_REAL_HPC_MAPPING.md`. Explain that a production system normally uses Slurm instead of manually naming nodes in `mpirun`, but MPI ranks, compute nodes, scientific libraries and DFTB+ are the same fundamental concepts.

## Closing statement

> “The experiment demonstrated that DFTB+ successfully ran in distributed MPI mode across our VMware cluster, but also showed that maximum core count was not the optimum configuration. For the 768-atom workload, four MPI ranks on one compute node were fastest, while crossing the virtual network at eight ranks introduced enough communication overhead to reduce performance.”
