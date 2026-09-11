# DFTB+ Multi-Node Fuel-Molecule HPC Lab

This folder is designed to be dropped directly into the existing `HPC-NRC-Applications` repository.

It documents a reproducible VMware mini-HPC experiment using DFTB+ with OpenMPI, OpenMP, ScaLAPACK and OpenBLAS. The scientific workload is a carbon/hydrogen benzene-cluster model used to study parallel scaling and demonstrate molecular visualization.

> **Tested DFTB+ binary:** development commit `2d6c93ac`, base release `25.1`  
> **MPI:** OpenMPI `4.1.4`  
> **Compute layout:** `compute01` + `compute02`, 4 CPU cores each  
> **Benchmark mode:** `OMP_NUM_THREADS=1`

## 1. What this project demonstrates

- source compilation of MPI/OpenMP-enabled DFTB+
- verification of MPI and linked scientific libraries
- Slater-Koster parameter handling
- DFTB+ HSD and GEN inputs
- single-node and multi-node MPI execution
- 1 / 2 / 4 / 8-rank scaling
- BLACS/ScaLAPACK process-grid evidence
- scientific-result consistency across rank counts
- molecular structure visualization in Avogadro
- comparison with the way DFTB+ jobs are normally launched on production HPC systems

## 2. Cluster architecture

```text
                     headnode
                 job/control node
                       |
           10.100.0.0/24 network
                       |
          +------------+------------+
          |                         |
      compute01                  compute02
      10.100.0.11                10.100.0.12
      4 CPU cores                4 CPU cores
          |                         |
       ranks 0-3                 ranks 4-7
          +------------+------------+
                       |
                 DFTB+ MPI job
```

The headnode itself was used to launch jobs. The benchmarked compute capacity was 8 CPU cores across the two compute nodes.

## 3. Repository layout

```text
DFTB-Fuel-HPC/
├── README.md
├── .gitignore
├── build/
│   ├── build_dftbplus_mpi.sh
│   └── verify_install.sh
├── inputs/
│   ├── benzene_96/
│   ├── benzene_768/
│   └── benzene_1536/
├── scripts/
│   ├── generate_benzene_cluster.py
│   ├── check_8rank_placement.sh
│   ├── run_768_1mpi.sh
│   ├── run_768_2mpi.sh
│   ├── run_768_4mpi.sh
│   ├── run_768_8mpi.sh
│   ├── run_1536_4mpi.sh
│   ├── run_1536_8mpi_timeout.sh
│   └── gen_to_xyz.py
├── parameters/
│   └── README.md
├── benchmarks/
│   ├── README.md
│   └── results.csv
├── visualization/
│   ├── README.md
│   └── benzene_768_structure.xyz
├── evidence/
│   └── README.md
├── docs/
│   ├── DFTBPLUS_EXPLAINED.md
│   ├── REAL_HPC_WORKFLOW.md
│   └── TROUBLESHOOTING.md
└── slurm/
    └── benzene_768_8ranks.sbatch
```

## 4. Build DFTB+ from source

DFTB+ distributed-memory execution requires a working MPI implementation and ScaLAPACK. The tested environment also used OpenBLAS.

The exact successful CMake configuration in this lab was:

```bash
cd ~/dftbplus

FC=mpifort CC=mpicc cmake \
  -DWITH_MPI=YES \
  -DWITH_OMP=YES \
  -DSCALAPACK_LIBRARY=/lib/x86_64-linux-gnu/libscalapack-openmpi.so \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$HOME/dftbplus-install \
  -B _build .

cmake --build _build -- -j2
cmake --install _build
```

A reusable version is in `build/build_dftbplus_mpi.sh`.

After installation:

```bash
export PATH=$HOME/dftbplus-install/bin:$HOME/opt/openmpi/bin:$PATH
```

Verify:

```bash
which mpicc
which mpifort
which mpirun
which dftb+
mpirun --version
ldd "$(which dftb+)" | grep -E "mpi|scalapack|openblas"
```

## 5. Verify the cluster before DFTB+

From the headnode:

```bash
ping -c 3 compute01
ping -c 3 compute02

ssh compute01 hostname
ssh compute02 hostname

mpirun -np 2 --host compute01,compute02 hostname
```

To prove placement across all 8 CPU slots:

```bash
mpirun \
  -np 8 \
  --host compute01:4,compute02:4 \
  --map-by ppr:4:node \
  --bind-to core \
  hostname
```

Expected: four `compute01` lines and four `compute02` lines.

## 6. DFTB+ input requirements

The main input **must** be called:

```text
dftb_in.hsd
```

This project includes the geometry using:

```text
Geometry = GenFormat {
  <<< "benzene_768.gen"
}
```

The geometry file is in DFTB+ GEN format.

For C/H systems, the tested `3ob-3-1` calculation uses:

```text
MaxAngularMomentum {
  C = "p"
  H = "s"
}
```

and the corresponding Slater-Koster files:

```text
C-C.skf
C-H.skf
H-C.skf
H-H.skf
```

Read `parameters/README.md` before adding the `.skf` files.

## 7. Tested molecular workloads

Three sizes were used:

- 96 atoms = 8 benzene molecules
- 768 atoms = 64 benzene molecules
- 1536 atoms = 128 benzene molecules

The larger cases were generated using `scripts/generate_benzene_cluster.py`.

Example:

```bash
python3 scripts/generate_benzene_cluster.py \
  --nx 4 --ny 4 --nz 4 \
  --output inputs/benzene_768/benzene_768.gen
```

## 8. Run the 768-atom benchmark

The scientific input is identical for every rank-count test. Before each timing, `charges.bin` is removed so the next run does not silently reuse previous restart charges.

### 1 rank

```bash
bash scripts/run_768_1mpi.sh
```

### 2 ranks

```bash
bash scripts/run_768_2mpi.sh
```

### 4 ranks

```bash
bash scripts/run_768_4mpi.sh
```

### 8 ranks / 2 nodes

The same input directory must exist at the same absolute path on both compute nodes.

```bash
bash scripts/run_768_8mpi.sh
```

A successful full-cluster run reported:

```text
MPI processes:               8
OpenMP threads:              1
BLACS orbital grid size:     2 x 4
BLACS atom grid size:        2 x 4
```

## 9. Measured results

| Atoms | MPI ranks | Nodes | DFTB+ wall time | Total energy | Outcome |
|---:|---:|---:|---:|---:|---|
| 768 | 1 | 1 | 52.77 s | -799.0006378657 H | completed |
| 768 | 2 | 1 | 20.13 s | -799.0006378657 H | completed |
| 768 | 4 | 1 | **15.30 s** | -799.0006378657 H | completed |
| 768 | 8 | 2 | 169.61 s | -799.0006378657 H | completed |
| 1536 | 4 | 1 | 120.63 s | -1597.9993748856 H | completed |
| 1536 | 8 | 2 | >300 s | — | timed out |

The 768-atom calculation produced the same total energy at every completed rank count. That is an important correctness check.

The 4-rank single-node case was the fastest tested configuration for 768 atoms. The 8-rank/two-node case was slower because inter-node communication overhead in the VMware lab dominated the useful computation.

## 10. Visualization

The main structural visualization is:

`visualization/benzene_768_structure.xyz`

Open it in Avogadro or VMD.

The gray spheres in a conventional element-colored molecular rendering represent carbon atoms; the white spheres represent hydrogen atoms. Each benzene unit is a six-carbon aromatic ring with one hydrogen attached to each carbon. This project uses many such molecules as a controlled C/H workload rather than claiming that the cluster is a literal sample of commercial fuel.

For electronic-density/orbital visualization, rerun with:

```text
Options {
  WriteDetailedXML = Yes
}

Analysis {
  WriteEigenvectors = Yes
}
```

Then Waveplot needs:

- `detailed.xml`
- `eigenvec.bin`
- a matching wavefunction-basis HSD file

and can generate `.cube` volumetric data for visualization.

See `visualization/README.md`.

## 11. How this relates to fuel / petrochemical computing

Benzene is an aromatic hydrocarbon and is useful here as a controlled carbon/hydrogen model. Molecular electronic-structure methods can be used in broader research to study geometry, energy, charge distribution, orbitals, reaction tendencies and interactions of hydrocarbon molecules and materials.

This benchmark does **not** claim to predict refinery throughput, engine efficiency or commercial fuel quality directly. Its purpose is to demonstrate a reproducible HPC molecular-simulation workflow and investigate how DFTB+ scales on the available cluster.

## 12. Real HPC vs this VMware lab

The core DFTB+/MPI idea is real HPC practice, but production systems usually add:

- a batch scheduler such as Slurm
- shared high-performance storage
- environment modules
- site-optimized MPI
- low-latency/high-bandwidth interconnects
- formal resource requests and queueing

A Slurm example is included under `slurm/`.

## 13. Reproduction checklist

A teammate should be able to follow this sequence:

1. install/compile MPI-enabled DFTB+
2. verify MPI, ScaLAPACK and BLAS linkage
3. make the same project path visible on each compute node
4. add the matching 3ob-3-1 SK files
5. confirm SSH/MPI node communication
6. run the 768-atom 1/2/4/8-rank tests
7. compare the final total energy for correctness
8. record wall-clock time
9. open the supplied XYZ visualization in Avogadro/VMD
10. attach terminal evidence under `evidence/`

## 14. References

- DFTB+ documentation: https://dftbplus.org/documentation.html
- DFTB+ Recipes: https://dftbplus-recipes.readthedocs.io/
- DFTB+ parallel introduction: https://dftbplus-recipes.readthedocs.io/en/latest/parallel/introduction.html
- DFTB+ parallel compilation: https://dftbplus-recipes.readthedocs.io/en/latest/parallel/compiling.html
- DFTB+ first calculation / input files: https://dftbplus-recipes.readthedocs.io/en/stable/basics/firstcalc.html
- Waveplot: https://dftbplus-recipes.readthedocs.io/en/latest/basics/waveplot.html
- DFTB+ source: https://github.com/dftbplus/dftbplus

When scientific results are published, cite DFTB+ and the parameterisation references requested by the chosen Slater-Koster set.
