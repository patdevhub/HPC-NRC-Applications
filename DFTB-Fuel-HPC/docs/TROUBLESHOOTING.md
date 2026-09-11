# Troubleshooting notes from the lab

## `which dftb+` returned nothing on compute nodes

Cause: DFTB+ existed but its install directory was not in the non-interactive shell PATH.

Test the absolute path:

`/home/ubuntu/dftbplus-install/bin/dftb+`

Add to the shell environment as appropriate:

`export PATH=$HOME/dftbplus-install/bin:$HOME/opt/openmpi/bin:$PATH`

## `Error in opening file 'benzene.gen'`

Cause: `dftb_in.hsd` referenced an external geometry file that had not been saved in the working directory.

Fix: create/restore the `.gen` file and verify with `ls` before running DFTB+.

## `Insufficient atoms for this number of MPI processors`

Cause: the molecular problem was too small for the requested DFTB+/BLACS process grid.

Observed with a 12-atom benzene molecule using multiple MPI ranks.

Fix: increase the scientific problem size rather than forcing more MPI ranks onto a tiny system.

## Multi-node run much slower than single-node run

Observed:

- 768 atoms, 4 ranks on one node: 15.30 s
- 768 atoms, 8 ranks over two nodes: 169.61 s
- 1536 atoms, 8 ranks over two nodes: did not finish within a 300 s limit

Likely explanation in this lab: virtual inter-node communication overhead dominates the useful compute work.

## Benchmark consistency

Remove `charges.bin` before each timed run so a later run does not start from restart charges left by a previous run.
