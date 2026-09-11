# Phase 1 — Toolchain and dependency checks

Before compiling DFTB+, the environment had to provide compilers, CMake, MPI and numerical libraries. The objective of this phase was to answer:

> **Do we have the software stack required to build a distributed-memory DFTB+ executable?**

## 1. Check basic build tools

```bash
gcc --version
gfortran --version
cmake --version
git --version
```

Why they matter:

- `gcc` — C compiler.
- `gfortran` — Fortran compiler; DFTB+ contains substantial Fortran code.
- `cmake` — configures the DFTB+ build.
- `git` — obtains and versions the source tree.

## 2. Check MPI before compiling DFTB+

The lab used a custom OpenMPI installation under:

```text
/home/ubuntu/opt/openmpi
```

Actual checks used:

```bash
export PATH=$HOME/opt/openmpi/bin:$PATH

which mpicc
which mpifort
which mpirun
mpirun --version
```

Expected lab paths:

```text
/home/ubuntu/opt/openmpi/bin/mpicc
/home/ubuntu/opt/openmpi/bin/mpifort
/home/ubuntu/opt/openmpi/bin/mpirun
```

`mpicc` and `mpifort` are compiler wrappers that supply the MPI include/library settings needed when compiling MPI-aware software. `mpirun` launches MPI processes.

## 3. Check numerical libraries

The tested environment used:

```text
OpenBLAS:  /home/ubuntu/opt/openblas/lib/libopenblas.so.0
ScaLAPACK: /lib/x86_64-linux-gnu/libscalapack-openmpi.so
```

Actual checks / useful searches:

```bash
ls -l $HOME/opt/openblas/lib/libopenblas.so.0
ls -l /lib/x86_64-linux-gnu/libscalapack-openmpi.so

ldconfig -p | grep -i openblas
ldconfig -p | grep -i scalapack
```

If a path is unknown:

```bash
find /usr /lib /opt "$HOME" -name 'libopenblas*.so*' 2>/dev/null | head
find /usr /lib /opt "$HOME" -name 'libscalapack*.so*' 2>/dev/null | head
```

### What each numerical library contributes

```text
BLAS / OpenBLAS
    → optimized basic vector/matrix operations

LAPACK
    → dense linear algebra algorithms

ScaLAPACK
    → distributed dense linear algebra across MPI processes

BLACS
    → process-grid communication support used by ScaLAPACK
```

## 4. Reproduction option on a clean Ubuntu VM

The exact historical commands used to create the custom `$HOME/opt/openmpi` and `$HOME/opt/openblas` installations were not retained. A clean Ubuntu reproduction can instead use distro packages:

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  gfortran \
  cmake \
  git \
  pkg-config \
  openmpi-bin \
  libopenmpi-dev \
  libopenblas-dev \
  libscalapack-openmpi-dev
```

This is a **reproduction path**, not a claim that those exact APT commands originally created the custom lab toolchain.

## 5. Disk-space troubleshooting used in the VM

The VM had limited storage, so these checks were used:

```bash
df -h

du -sh ~/dftbplus
du -sh ~/dftbplus/_build
du -sh ~/OpenBLAS
du -sh ~/openmpi-4.1.4
du -sh ~/Lmod
du -sh ~/.conda
du -sh ~/ascot-env
```

Cleanup commands recorded during the work:

```bash
sudo apt clean
sudo apt autoremove
rm -rf ~/.cache/*
```

Do not delete the DFTB+ `_build` directory unless you intentionally want to rebuild from scratch.
