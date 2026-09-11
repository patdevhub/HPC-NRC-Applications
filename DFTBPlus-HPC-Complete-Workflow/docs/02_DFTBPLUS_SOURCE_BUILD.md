# Phase 2 — Compile and install DFTB+

The purpose of this phase was to create a DFTB+ binary that could use MPI across the mini-cluster.

## 1. Source directory

The DFTB+ source tree used in the lab was:

```text
/home/ubuntu/dftbplus
```

A fresh clone can be obtained with:

```bash
cd ~
git clone --recursive https://github.com/dftbplus/dftbplus.git
cd ~/dftbplus
git submodule update --init --recursive
```

Record the source revision:

```bash
git rev-parse --short HEAD
git describe --tags --always
```

The tested executable reported development commit `2d6c93ac`, based on DFTB+ 25.1.

## 2. Put the tested MPI wrappers first in PATH

```bash
export PATH=$HOME/opt/openmpi/bin:$PATH
```

Check:

```bash
which mpicc
which mpifort
which mpirun
```

## 3. Actual successful CMake configuration

```bash
cd ~/dftbplus

FC=mpifort CC=mpicc cmake \
  -DWITH_MPI=YES \
  -DWITH_OMP=YES \
  -DSCALAPACK_LIBRARY=/lib/x86_64-linux-gnu/libscalapack-openmpi.so \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$HOME/dftbplus-install \
  -B _build .
```

### What it means

- `FC=mpifort` — use the MPI-aware Fortran compiler wrapper.
- `CC=mpicc` — use the MPI-aware C compiler wrapper.
- `WITH_MPI=YES` — compile distributed-memory MPI support.
- `WITH_OMP=YES` — compile OpenMP support too.
- `SCALAPACK_LIBRARY=...` — explicitly provide the OpenMPI-compatible ScaLAPACK library.
- `Release` — enable optimized compilation.
- `CMAKE_INSTALL_PREFIX` — install under the Ubuntu user's home directory.
- `-B _build` — create a separate build tree.

## 4. Compile

```bash
cmake --build _build -- -j2
```

The `-j2` option allowed two build jobs to run concurrently.

## 5. Install

```bash
cmake --install _build
```

Successful installed binary:

```text
/home/ubuntu/dftbplus-install/bin/dftb+
```

## 6. Put DFTB+ on PATH

Recorded lab setting:

```bash
export PATH=$HOME/dftbplus-install/bin:$PATH
```

To make it persistent, place that export in `~/.bashrc`, then:

```bash
source ~/.bashrc
```

Verify:

```bash
which dftb+
```

Expected:

```text
/home/ubuntu/dftbplus-install/bin/dftb+
```

## 7. Verify the executable's linked libraries

Actual check:

```bash
ldd $(which dftb+) | grep -E "mpi|scalapack|openblas"
```

This was used to confirm that the installed executable resolved MPI, ScaLAPACK and OpenBLAS-related libraries.

A broader check is:

```bash
ldd "$(which dftb+)" | grep -Ei 'mpi|scalapack|openblas|blas|lapack'
```

## 8. Note about `dftb+ --version`

The development build used in the lab did not behave like every conventional CLI program when passed `--version`; it could attempt to begin a calculation and complain when `dftb_in.hsd` was missing. Therefore the build was verified with executable paths, linked libraries, successful calculations and MPI runtime output rather than relying only on a version flag.
