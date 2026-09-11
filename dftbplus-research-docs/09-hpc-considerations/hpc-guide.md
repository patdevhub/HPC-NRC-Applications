# 9. HPC Considerations — Running DFTB+ on a Cluster

## 9.1 Our Cluster Environment

| Component       | Specification                  |
|----------------|-------------------------------|
| **Head Node**   | 4 cores, 2 GB RAM             |
| **Compute Node 1** | 4 cores, 2 GB RAM         |
| **Compute Node 2** | 4 cores, 2 GB RAM         |
| **Total Cores** | 12 (across 3 nodes)           |
| **Total RAM**   | 6 GB (across 3 nodes)         |
| **Interconnect**| Standard Ethernet (assumed)   |

This is a **small, resource-constrained cluster**. The strategies below are specifically tailored for this environment.

---

## 9.2 Compilation Strategy for Low-Memory Clusters

### 9.2.1 Recommended Compiler Stack

| Component | Recommendation | Why |
|-----------|---------------|-----|
| Fortran   | GCC (gfortran ≥ 13) | Stable, free, predictable memory usage |
| C/C++     | GCC (gcc/g++ ≥ 13) | Match the Fortran compiler version |
| MPI       | OpenMPI | Better for small/heterogeneous clusters than Intel MPI |
| Math Lib  | OpenBLAS | Combined BLAS+LAPACK, low memory overhead |

> ⚠️ **Avoid Intel MKL on low-memory systems.** MKL can exhibit unexpected memory growth. OpenBLAS is more predictable.

### 9.2.2 Optimisation Flags

```bash
# Recommended: Standard optimisation (safe)
export FFLAGS="-O2"
export CFLAGS="-O2"

# Avoid:
# -O3 with aggressive flags can increase binary size and memory usage
# -march=native may cause issues if nodes have different CPUs
```

### 9.2.3 Build Configuration

```bash
# Minimal MPI build for our cluster
FC=mpifort CC=mpicc cmake \
  -DWITH_MPI=YES \
  -DCMAKE_INSTALL_PREFIX=$HOME/opt/dftbplus \
  -DCMAKE_BUILD_TYPE=Release \
  ..

# Build with limited parallelism (to avoid running out of RAM during compilation)
make -j2
```

> **Important:** Use `-j2` instead of `-j4` or higher. With only 2 GB RAM on the head node, parallel compilation can exhaust memory.

---

## 9.3 Parallelisation Strategy

### 9.3.1 Pure MPI vs Hybrid MPI+OpenMP

For our cluster, **pure MPI** is recommended:

| Approach | Pros | Cons | Recommended? |
|----------|------|------|:---:|
| Pure MPI | Simple, predictable memory | Communication overhead | ✅ Yes |
| Pure OpenMP | No network overhead | Limited to single node | ⚠️ Only for small jobs |
| Hybrid MPI+OpenMP | Can be optimal | Complex, overhead on small clusters | ❌ Not for our setup |

### 9.3.2 Practical MPI Configuration

For a job running across both compute nodes:

```bash
# Use 4 MPI processes per node, 2 nodes = 8 total
mpirun -np 8 --hostfile hostfile dftb+
```

**hostfile:**
```
compute-node-1 slots=4
compute-node-2 slots=4
```

However, for our 2 GB nodes, using all 4 cores may cause memory issues. Start with **2 MPI processes per node**:

```bash
# Conservative: 2 processes per node, 2 nodes = 4 total
mpirun -np 4 --hostfile hostfile --map-by node dftb+
```

This gives ~1 GB RAM per MPI process.

---

## 9.4 Job Submission

### 9.4.1 SLURM Job Script

If your cluster uses SLURM:

```bash
#!/bin/bash
#SBATCH --job-name=dftbplus
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --mem=1800M
#SBATCH --time=02:00:00
#SBATCH --output=dftb_%j.out
#SBATCH --error=dftb_%j.err

# Load modules (adjust to your cluster)
module load gcc/13.2
module load openmpi/4.1
module load openblas/0.3

# Set stack size to unlimited
ulimit -s unlimited

# Set OpenMP threads (1 for pure MPI)
export OMP_NUM_THREADS=1

# Run DFTB+
mpirun dftb+
```

### 9.4.2 PBS/Torque Job Script

If your cluster uses PBS:

```bash
#!/bin/bash
#PBS -N dftbplus
#PBS -l nodes=2:ppn=2
#PBS -l mem=3600mb
#PBS -l walltime=02:00:00
#PBS -o dftb.out
#PBS -e dftb.err

cd $PBS_O_WORKDIR

# Load modules
module load gcc/13.2
module load openmpi/4.1
module load openblas/0.3

ulimit -s unlimited
export OMP_NUM_THREADS=1

mpirun -np 4 dftb+
```

---

## 9.5 Memory Management

### 9.5.1 Estimating Memory Requirements

DFTB+ memory usage depends primarily on:
- **Number of atoms** ($N$)
- **Basis size** ($M$) — typically $M \approx 4N$ for organic systems
- **Matrix storage**: Hamiltonian and overlap matrices are $M \times M$

**Rough estimate:**
$$\text{RAM per MPI process} \approx \frac{8 \times M^2 \times k}{N_{\text{procs}}} \text{ bytes}$$

where $k \approx 5\text{–}10$ accounts for multiple matrices and workspace.

### 9.5.2 Practical Memory Limits

For our cluster (2 GB per node, 2 processes per node = ~1 GB per process):

| System Size | Estimated RAM/proc | Feasible? |
|------------|-------------------|-----------|
| 100 atoms  | ~50 MB            | ✅ Yes    |
| 500 atoms  | ~200 MB           | ✅ Yes    |
| 1,000 atoms| ~500 MB           | ✅ Yes    |
| 2,000 atoms| ~1.5 GB           | ⚠️ Tight  |
| 5,000 atoms| ~5 GB             | ❌ No     |

> **Recommendation:** Stay below **1,000–1,500 atoms** for comfortable operation on our cluster.

### 9.5.3 Memory-Saving Tips

1. **Use fewer MPI processes** — each process duplicates some data.
2. **Set `ulimit -s unlimited`** — prevents stack overflow crashes.
3. **Monitor with `htop` or `free -m`** — check memory during a short test run.
4. **Use DFTB+ timing** — add `Options { TimingVerbosity = 2 }` to identify memory bottlenecks.

---

## 9.6 Performance Benchmarking

Before running production calculations, benchmark your setup:

```bash
# Create a small test case
# Run with 1, 2, 4, and 8 MPI processes
# Record wall time and memory usage

for NP in 1 2 4 8; do
  echo "Testing with $NP processes..."
  /usr/bin/time -v mpirun -np $NP dftb+ 2> timing_np${NP}.log
done
```

Look for the "sweet spot" where:
- Wall time decreases meaningfully
- Memory stays within limits
- Speedup is reasonable (aim for > 70% efficiency)

---

## 9.7 File I/O Considerations

- **Local scratch disk**: If available, run calculations from local disk rather than NFS — I/O is much faster.
- **Output management**: DFTB+ can produce large trajectory files. Monitor disk space.
- **Shared filesystem**: Ensure all nodes can access the same working directory (via NFS or similar).

---

## 9.8 Troubleshooting Common Cluster Issues

| Problem | Possible Cause | Solution |
|---------|---------------|----------|
| `Segmentation fault` | Stack size limit | `ulimit -s unlimited` |
| `Out of memory` | Too many MPI procs | Reduce `-np`, use fewer procs per node |
| `MPI connection refused` | Firewall / SSH keys | Ensure passwordless SSH between nodes |
| `Cannot find libopenblas` | Library path | Set `LD_LIBRARY_PATH` or use `module load` |
| `Slow performance` | NFS bottleneck | Copy files to local scratch |
| `Memory keeps growing` | MKL memory allocator | Switch to OpenBLAS |
| `Compilation out of memory` | Too many parallel compile jobs | Use `make -j1` or `make -j2` |

---

**Previous Section:** [← 08 — Visualisation Tools](../08-visualization-tools/visualization.md)  
**Next Section:** [10 — References →](../10-references/references.md)
