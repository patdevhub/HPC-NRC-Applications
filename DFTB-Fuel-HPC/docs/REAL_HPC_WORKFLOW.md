# How this maps to a real HPC environment

The core idea used in this VMware lab is the same as a real distributed-memory HPC workflow: compile or install an MPI-enabled DFTB+, make the same input and parameter files visible to compute nodes, request multiple MPI ranks, and execute the job across allocated CPU resources.

The production workflow is usually more structured:

1. Users log into a **login/head node**.
2. Software is loaded with an environment-module system (`module load ...`) or a managed Conda/Spack environment.
3. Input data lives on a **shared parallel filesystem** visible from compute nodes.
4. Users submit jobs to a **scheduler** such as Slurm instead of manually selecting nodes.
5. The scheduler reserves nodes/cores/memory for the job.
6. The job launcher (`srun`, or an MPI launcher integrated with the site configuration) starts DFTB+ on the allocated resources.
7. Output is written to the shared filesystem and analysed after the job completes.

In the VMware lab, direct `mpirun --host compute01:4,compute02:4 ...` was used because the purpose was to learn and demonstrate the MPI mechanics explicitly.

## Why two nodes were slower here

Real HPC systems normally use low-latency, high-bandwidth interconnects (for example InfiniBand/HDR-class fabrics) and tuned MPI stacks. This lab used virtual machines and a virtual Ethernet network. DFTB+ performs communication during distributed linear algebra, so a small/medium problem can spend more time communicating than computing.

This is why the 768-atom benchmark improved from 1 to 4 ranks on one node, but became dramatically slower when split across two VMs with 8 ranks.

That result is not evidence that MPI or DFTB+ failed. It is a scaling result showing that parallel efficiency depends on problem size, process placement and interconnect quality.
