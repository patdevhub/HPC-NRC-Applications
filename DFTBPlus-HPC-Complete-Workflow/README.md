# DFTB+ HPC Complete Workflow

## Installation → Validation → VMware MPI → Multi-node Benchmark → Visualization

This repository reconstructs the **actual workflow used in the VMware mini-HPC DFTB+ experiment**. It is intentionally chronological so that a team member can understand not only *what* was run, but *why each stage existed*.

The project began by verifying the compiler/MPI/numerical-library environment, then compiling DFTB+ from source with MPI/OpenMP/ScaLAPACK support, validating the installation on a small H2O system, testing MPI communication between VMware compute nodes, scaling to hydrocarbon workloads, benchmarking 1/2/4/8 MPI ranks, and finally visualizing the 768-atom structure in Avogadro.

> **Important:** commands labelled **Actual lab command** are preserved from the successful VMware workflow. Where the exact historical installation command for a prerequisite was not retained, this repository clearly labels a **reproduction option** instead of pretending it was the original command.

---

## Tested environment

```text
headnode     10.100.0.10   administration / MPI launch
compute01    10.100.0.11   4 CPU cores
compute02    10.100.0.12   4 CPU cores

DFTB+ source:     /home/ubuntu/dftbplus
DFTB+ install:    /home/ubuntu/dftbplus-install
DFTB+ executable: /home/ubuntu/dftbplus-install/bin/dftb+
OpenMPI:          /home/ubuntu/opt/openmpi
OpenBLAS:         /home/ubuntu/opt/openblas
ScaLAPACK:        /lib/x86_64-linux-gnu/libscalapack-openmpi.so
OpenMPI version:  4.1.4
DFTB+ build:      development commit 2d6c93ac, based on 25.1
```

---

## Follow the repository in this order

| Phase | Folder / document | Purpose |
|---|---|---|
| 1 | `docs/01_TOOLCHAIN_AND_DEPENDENCIES.md` | Check compilers, MPI, BLAS and ScaLAPACK before DFTB+. |
| 2 | `docs/02_DFTBPLUS_SOURCE_BUILD.md` | Configure, compile, install and verify DFTB+. |
| 3 | `docs/03_H2O_VALIDATION.md` | Prove the scientific executable works on a small known calculation. |
| 4 | `docs/04_VMWARE_MPI_CHECKS.md` | Verify networking, SSH and MPI between compute nodes. |
| 5 | `docs/05_HYDROCARBON_WORKLOADS.md` | Move from 12 atoms to 96, 768 and 1536 atoms. |
| 6 | `docs/06_MPI_BENCHMARKS.md` | Execute and interpret 1/2/4/8-rank results. |
| 7 | `docs/07_VISUALIZATION.md` | Convert GEN → XYZ and use Avogadro/VMD/Waveplot. |
| 8 | `docs/08_REAL_HPC_MAPPING.md` | Map the VMware workflow to a production Slurm cluster. |
| 9 | `PRESENT_FROM_HERE.md` | Presentation walkthrough and evidence checklist. |

---

## End-to-end workflow

```text
Ubuntu VMware environment
        ↓
Check gcc / gfortran / cmake / git
        ↓
Check mpicc / mpifort / mpirun
        ↓
Check OpenBLAS / ScaLAPACK
        ↓
Configure DFTB+ with CMake
        ↓
Compile + install DFTB+
        ↓
Verify linked MPI / numerical libraries
        ↓
H2O correctness test
        ↓
Slater-Koster parameters
        ↓
Waveplot + cube visualization
        ↓
Check compute01 / compute02 communication
        ↓
MPI hostname placement test
        ↓
Benzene 12 atoms → too small for requested MPI grid
        ↓
96-atom cluster → successful distributed run
        ↓
768-atom cluster → 1/2/4/8 MPI benchmark
        ↓
1536-atom stress test
        ↓
GEN → XYZ
        ↓
Avogadro structure visualization
```

---

## Main benchmark result

All completed 768-atom runs converged to the same total energy:

```text
-799.0006378657 H
-21741.9136 eV
```

| Atoms | MPI ranks | Placement | DFTB+ wall time | Outcome |
|---:|---:|---|---:|---|
| 768 | 1 | compute01 | 52.77 s | completed |
| 768 | 2 | compute01 | 20.13 s | completed |
| 768 | 4 | compute01 | **15.30 s** | completed |
| 768 | 8 | 4 + 4 across compute01/02 | 169.61 s | completed |
| 1536 | 4 | compute01 | 120.63 s | completed |
| 1536 | 8 | two nodes | >300 s | timed out |

### Finding

For the tested VMware environment, 4 MPI ranks on one compute node were fastest. Moving to 8 ranks across two VMs increased communication overhead enough to make the calculation slower. This demonstrates an important HPC principle: **more allocated cores do not automatically mean better performance**.

---

## Quick start for a teammate

```bash
# 1. Inspect prerequisites
bash scripts/00_check_toolchain.sh

# 2. Build DFTB+ using the tested configuration
bash scripts/01_build_dftbplus.sh

# 3. Verify the installed binary and libraries
bash scripts/02_verify_dftbplus.sh

# 4. Verify MPI across the VMware nodes
bash scripts/03_check_vmware_mpi.sh

# 5. Add the required Slater-Koster files to each workload's slakos directory
#    See parameters/README.md

# 6. Run the benchmark scripts
bash scripts/run_768_1mpi.sh
bash scripts/run_768_2mpi.sh
bash scripts/run_768_4mpi.sh
bash scripts/run_768_8mpi.sh
```

---

## Repository rule for parameter files

The project does **not** redistribute Slater-Koster parameter data. Read `parameters/README.md` and obtain the appropriate parameter family from its official distribution. Keep one consistent parameter family in a calculation.
