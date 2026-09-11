#!/bin/bash
#SBATCH --job-name=dftb-benzene768
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --output=benzene_768_%j.out

# Module names vary by HPC site. Replace these with the site-provided modules.
# module load dftbplus
# module load openmpi

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
ulimit -s unlimited

# Run this script from the directory containing dftb_in.hsd, the .gen file,
# and the slakos/ directory.
srun dftb+
