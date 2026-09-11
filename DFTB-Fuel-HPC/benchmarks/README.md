# Benchmark Results

All timings below came from the VMware mini-HPC lab described in the main README.

| Problem | Atoms | MPI ranks | Nodes | DFTB+ wall time | Outcome |
|---|---:|---:|---:|---:|---|
| benzene_768 | 768 | 1 | 1 | 52.77 s | completed |
| benzene_768 | 768 | 2 | 1 | 20.13 s | completed |
| benzene_768 | 768 | 4 | 1 | 15.30 s | completed |
| benzene_768 | 768 | 8 | 2 | 169.61 s | completed |
| benzene_1536 | 1536 | 4 | 1 | 120.63 s | completed |
| benzene_1536 | 1536 | 8 | 2 | >300 s | timed out |

For the 768-atom case, the total energy remained `-799.0006378657 H` for all rank counts.

Approximate 768-atom speedups relative to the 1-rank DFTB+ wall time:

- 2 ranks: 2.62x
- 4 ranks: 3.45x
- 8 ranks: 0.31x

Interpretation: this particular VMware/network configuration scaled well within one node up to 4 MPI ranks, while the two-node 8-rank case was dominated by inter-node communication overhead.
