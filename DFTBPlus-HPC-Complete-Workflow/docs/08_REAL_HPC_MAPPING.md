# Phase 8 — How this maps to a production HPC system

The VMware experiment uses the same fundamental concepts as production distributed-memory HPC:

```text
control/login node
      ↓
resource allocation
      ↓
MPI ranks
      ↓
multiple compute nodes
      ↓
DFTB+ + ScaLAPACK / BLACS
```

The biggest operational difference is scheduling. In the VMware lab, nodes were named manually in `mpirun`. On a production cluster, a scheduler such as Slurm normally allocates the nodes first.

Example:

```bash
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun dftb+
```

Production systems also typically provide:

- high-speed interconnects
- shared parallel storage
- environment modules
- centrally managed MPI/compiler stacks
- batch queues
- monitoring/accounting

Therefore, the poor two-node scaling observed in the VMware environment should not be generalized to all HPC clusters. The experiment specifically demonstrates how workload size and inter-node communication cost affected **this tested virtual cluster**.
