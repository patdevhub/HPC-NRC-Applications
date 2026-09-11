# 4. Features and Capabilities of DFTB+

## 4.1 Complete Feature List

DFTB+ is far more than a simple tight-binding code. Below is a comprehensive catalogue of its features and capabilities.

---

### 4.1.1 Core Computational Methods

| # | Feature | Description |
|---|---------|-------------|
| 1 | **Non-SCC DFTB** | Non-self-consistent DFTB (fastest, for weakly polar systems) |
| 2 | **SCC-DFTB (DFTB2)** | Self-consistent charge DFTB — the standard workhorse method |
| 3 | **DFTB3 (Third-Order)** | Third-order DFTB with improved charge-transfer description |
| 4 | **xTB (Extended Tight-Binding)** | GFN1-xTB and GFN2-xTB methods via TBLite integration |
| 5 | **Hybrid Functionals** | Approximate implementations of range-separated hybrid functionals |

---

### 4.1.2 Geometry and Structure

| # | Feature | Description |
|---|---------|-------------|
| 6 | **Geometry Optimisation** | Rational function, conjugate gradient, L-BFGS, FIRE optimisers |
| 7 | **Lattice Optimisation** | Optimise unit cell parameters for periodic systems |
| 8 | **Constrained Optimisation** | Fix atoms, distances, angles, or dihedrals during optimisation |
| 9 | **Transition State Search** | Nudged elastic band (NEB) for finding transition states |

---

### 4.1.3 Molecular Dynamics

| # | Feature | Description |
|---|---------|-------------|
| 10 | **NVE Ensemble** | Microcanonical MD (constant energy) |
| 11 | **NVT Ensemble** | Canonical MD with Nosé-Hoover, Andersen, or Berendsen thermostats |
| 12 | **NPT Ensemble** | Isothermal-isobaric MD for pressure-controlled simulations |
| 13 | **Metadynamics** | Enhanced sampling via PLUMED2 integration |
| 14 | **XL-BOMD** | Extended Lagrangian Born-Oppenheimer MD for improved energy conservation |

---

### 4.1.4 Electronic Properties

| # | Feature | Description |
|---|---------|-------------|
| 15 | **Band Structure** | Electronic band structure for periodic systems |
| 16 | **Density of States (DOS)** | Total and projected DOS |
| 17 | **Mulliken Charges** | Atomic charge analysis |
| 18 | **Orbital Energies** | Kohn-Sham-like eigenvalues |
| 19 | **Electron/Hole Effective Masses** | From band curvature analysis |

---

### 4.1.5 Excited States and Spectroscopy

| # | Feature | Description |
|---|---------|-------------|
| 20 | **TD-DFTB** | Time-dependent DFTB for optical absorption spectra |
| 21 | **Casida Formalism** | Linear response excited states |
| 22 | **Non-Adiabatic Dynamics** | Ehrenfest dynamics for photo-excited systems |

---

### 4.1.6 Transport Properties

| # | Feature | Description |
|---|---------|-------------|
| 23 | **NEGF (Landauer)** | Non-equilibrium Green's function electron transport |
| 24 | **Transmission Spectra** | Quantum conductance through molecular junctions |
| 25 | **Contact Modelling** | Self-energies for semi-infinite leads |

---

### 4.1.7 Dispersion and Corrections

| # | Feature | Description |
|---|---------|-------------|
| 26 | **DFT-D3** | Grimme's D3 dispersion correction |
| 27 | **DFT-D4** | Grimme's D4 dispersion correction (charge-aware) |
| 28 | **TS Dispersion** | Tkatchenko-Scheffler van der Waals correction |
| 29 | **MBD (Many-Body Dispersion)** | Many-body dispersion for extended systems |
| 30 | **Hydrogen Bond Correction** | Empirical H-bond damping for improved H-bond energetics |

---

### 4.1.8 Spin and Magnetism

| # | Feature | Description |
|---|---------|-------------|
| 31 | **Collinear Spin** | Spin-polarised calculations |
| 32 | **Non-Collinear Spin** | Full vector spin for spin-orbit coupling |
| 33 | **Spin-Orbit Coupling** | Relativistic spin-orbit effects |
| 34 | **Spin Constants** | Per-element on-site spin coupling parameters |

---

### 4.1.9 Parallelism and Performance

| # | Feature | Description |
|---|---------|-------------|
| 35 | **OpenMP** | Shared-memory parallelism (within a node) |
| 36 | **MPI** | Distributed-memory parallelism (across nodes) |
| 37 | **GPU Acceleration** | Via MAGMA (single node) or ELPA (multi-node) |
| 38 | **ELSI Solvers** | Alternative eigensolvers for large-scale calculations |

---

### 4.1.10 Integration and Interoperability

| # | Feature | Description |
|---|---------|-------------|
| 39 | **Fortran API** | Native library interface |
| 40 | **C API** | C-compatible library interface |
| 41 | **Python API** | Python bindings for scripting |
| 42 | **i-PI Socket** | Interface for external MD drivers |
| 43 | **ASE Calculator** | Integration with Atomic Simulation Environment |
| 44 | **LAMMPS Interface** | Use DFTB+ as a pair-style in LAMMPS |
| 45 | **PLUMED2 Interface** | Enhanced sampling and collective variables |

---

## 4.2 Feature Availability Matrix

Not all features are available in all build configurations:

| Feature Group     | Serial Build | OpenMP Build | MPI Build |
|-------------------|:----------:|:----------:|:-------:|
| Core DFTB         | ✅         | ✅         | ✅      |
| Geometry Opt      | ✅         | ✅         | ✅      |
| MD                | ✅         | ✅         | ✅      |
| TD-DFTB           | ✅ (ARPACK)| ✅ (ARPACK)| ✅ (PARPACK)|
| NEGF Transport    | ✅         | ✅         | ✅      |
| ELSI Solvers      | ❌         | ❌         | ✅      |
| GPU (MAGMA)       | ❌         | ✅         | ❌      |
| GPU (ELPA)        | ❌         | ❌         | ✅      |

---

**Previous Section:** [← 03 — DFTB+ vs DFT](../03-dftbplus-vs-dft/comparison.md)  
**Next Section:** [05 — Software Prerequisites →](../05-software-prerequisites/prerequisites.md)
