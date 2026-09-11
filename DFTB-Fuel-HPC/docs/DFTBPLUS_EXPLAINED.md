# DFTB+ explained

## What DFTB+ is

DFTB+ is atomistic quantum-mechanical simulation software implementing Density Functional Tight Binding (DFTB) and related methods. It is designed to make quantum-mechanical calculations substantially cheaper than full DFT for many systems while retaining an electronic-structure description.

## Core input model

DFTB+ reads a main file named `dftb_in.hsd` from the working directory.

Typical pieces are:

- `Geometry`: atomic coordinates, either embedded or included from a `.gen` file.
- `Hamiltonian = DFTB`: selects the DFTB Hamiltonian and SCC options.
- `SlaterKosterFiles`: tells DFTB+ where to find element-pair parameter tables.
- `MaxAngularMomentum`: declares the highest orbital angular momentum represented for each element.
- `Driver`: optional; controls geometry optimisation, molecular dynamics, etc.
- `Options`: output and global settings.
- `Analysis`: optional analysis output such as eigenvectors.

## What SCC means

`Scc = Yes` enables self-consistent charge DFTB. DFTB+ iterates electronic charges until the SCC error satisfies the requested tolerance or the maximum SCC-cycle limit is reached.

## Important files

### Inputs

`dftb_in.hsd`
: Main DFTB+ instruction file. The name is fixed.

`*.gen`
: A DFTB+ geometry file. The first line gives atom count and geometry type; the second line lists element symbols; subsequent lines contain atom index, species index and coordinates.

`*.skf`
: Slater-Koster parameter tables for each required ordered element pair, e.g. `C-C`, `C-H`, `H-C`, `H-H`.

### Outputs

`dftb_pin.hsd`
: Fully processed input including defaults and parser conversion. Keep this file for reproducibility.

`detailed.out`
: Detailed numerical results from the final SCC/geometry step.

`detailed.xml`
: Machine-readable detailed data. Waveplot uses it when producing volumetric orbital/charge data.

`band.out`
: Eigenvalues/occupations where applicable.

`charges.bin`
: Binary charge restart file. Remove it before timing runs if you want every benchmark to begin from the same initial-charge state.

`eigenvec.bin`
: Binary eigenvectors, produced when `WriteEigenvectors = Yes`. Needed by Waveplot for orbital/charge-density visualization.

`*.xyz` / `*.gen`
: Geometry outputs when geometry optimisation or trajectory writing is requested.

`*.cube`
: Volumetric grid data produced by Waveplot. Open these in a visualization package capable of isosurfaces/volumetric data.

## Why the 12-atom benzene case failed with multiple MPI ranks

DFTB+'s distributed linear algebra uses BLACS/ScaLAPACK process grids. A very small system can be too small to partition across many ranks. In this lab, the 12-atom benzene case reported an insufficient-size/process-grid error. Increasing the problem size solved that issue.

## MPI, OpenMP and BLACS

- MPI distributes work between processes and, on a cluster, between nodes.
- OpenMP creates shared-memory threads inside a process.
- BLACS/ScaLAPACK distribute dense linear-algebra operations over an MPI process grid.
- In the tested 8-rank run, DFTB+ reported an orbital BLACS grid of `2 x 4`, confirming distributed matrix work.

The benchmark deliberately used `OMP_NUM_THREADS=1`, so 8 MPI ranks mapped to 8 CPU execution slots without additional OpenMP oversubscription.
