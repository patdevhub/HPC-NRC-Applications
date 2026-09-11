#!/bin/bash
#SBATCH --job-name=dftb768
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun dftb+
