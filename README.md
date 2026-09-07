# DFTB+ Research Documentation Repository

> **A comprehensive research and reference guide for understanding, compiling, and running DFTB+ on HPC clusters.**

---

## 📋 About This Repository

This repository serves as a **structured research document** that provides all necessary background knowledge about DFTB+ (Density Functional Tight Binding Plus). It is designed so that anyone — from a new student to an experienced researcher — can understand what DFTB+ is, how it works, and what is required to build and run it, **before** touching a single line of compilation code.

## 🖥️ Target Environment

| Component     | Specification                  |
|---------------|-------------------------------|
| Head Node     | 4 cores, 2 GB RAM             |
| Compute Node 1| 4 cores, 2 GB RAM             |
| Compute Node 2| 4 cores, 2 GB RAM             |
| Total Cores   | 12 (across 3 nodes)           |
| Total RAM     | 6 GB (across 3 nodes)         |
| OS            | Linux (HPC Cluster)           |

## 📖 Repository Structure

```
dftbplus-research-docs/
│
├── README.md                          # This file — overview and navigation
├── LICENSE                            # License information
│
├── 01-introduction/
│   └── what-is-dftbplus.md            # What is DFTB+ and why it matters
│
├── 02-theoretical-background/
│   └── dftb-theory.md                 # The science behind the DFTB method
│
├── 03-dftbplus-vs-dft/
│   └── comparison.md                  # DFTB+ vs full DFT — when to use which
│
├── 04-features-and-capabilities/
│   └── features.md                    # Complete feature list of DFTB+
│
├── 05-software-prerequisites/
│   └── prerequisites.md               # All software dependencies (1–25 list)
│
├── 06-parameter-files/
│   └── slater-koster-files.md         # Understanding Slater-Koster parameter files
│
├── 07-input-output-formats/
│   └── input-output.md                # Input/output file formats explained
│
├── 08-visualization-tools/
│   └── visualization.md               # Tools for visualising DFTB+ results
│
├── 09-hpc-considerations/
│   └── hpc-guide.md                   # Running DFTB+ on HPC/cluster environments
│
├── 10-references/
│   └── references.md                  # Academic citations and further reading
│
└── diagrams/
    └── dftb-workflow.md               # Workflow diagrams (Mermaid)
```

## 🚀 How to Use This Repository

1. **Start** with [01-introduction/what-is-dftbplus.md](01-introduction/what-is-dftbplus.md) for a high-level overview.
2. **Understand the theory** in [02-theoretical-background/dftb-theory.md](02-theoretical-background/dftb-theory.md).
3. **Review prerequisites** in [05-software-prerequisites/prerequisites.md](05-software-prerequisites/prerequisites.md) — this is the most critical section before compilation.
4. **Check HPC considerations** in [09-hpc-considerations/hpc-guide.md](09-hpc-considerations/hpc-guide.md) for cluster-specific advice.
5. Once comfortable, proceed to the **companion repository** for compilation and installation steps.

## 📌 Companion Repository

> The **compilation and installation** guide lives in a separate repository:  
> [`dftbplus-install-guide/`](../dftbplus-install-guide/) — Step-by-step build instructions for your cluster.

## 📝 Author

This documentation was prepared as part of a structured research and deployment project for running DFTB+ on a local HPC cluster.

## 📅 Last Updated

September 2026
# 1. What is DFTB+?

## 1.1 Overview

**DFTB+** (Density Functional Tight Binding Plus) is a versatile, open-source software package for performing fast and efficient **atomistic quantum mechanical simulations**. It is the leading implementation of the Density Functional Tight Binding (DFTB) method — an approximate, yet highly efficient variant of the widely-used Density Functional Theory (DFT).

DFTB+ bridges the critical gap between:
- **Ab initio (first-principles) methods** — which are accurate but computationally very expensive.
- **Classical force-field methods** — which are fast but lack the ability to describe electronic structure, bond breaking, and charge transfer.

By using a tight-binding approximation with pre-computed parameters, DFTB+ achieves calculation speeds that are **1 to 3 orders of magnitude faster** than standard DFT, while still maintaining a quantum mechanical description of the electronic structure.

---

## 1.2 Who Develops DFTB+?

DFTB+ is developed and maintained by a **global community of researchers** led by an international team of scientists. The project is hosted on GitHub at [github.com/dftbplus/dftbplus](https://github.com/dftbplus/dftbplus) and is released under the **LGPL v3** open-source licence.

Key institutions involved in DFTB+ development include:
- University of Bremen (Germany)
- University of Strathclyde (UK)
- Los Alamos National Laboratory (USA)
- Various other academic and research institutions worldwide

---

## 1.3 Why Does DFTB+ Exist?

### The Problem

In computational chemistry and materials science, researchers need to simulate how atoms interact at the quantum level. The standard method for this is **Density Functional Theory (DFT)**. However, DFT has a significant limitation:

| System Size     | DFT Feasibility           | Time Required     |
|-----------------|---------------------------|-------------------|
| 10–100 atoms    | ✅ Feasible               | Minutes to hours  |
| 100–1,000 atoms | ⚠️ Expensive              | Hours to days     |
| 1,000+ atoms    | ❌ Often impractical       | Days to weeks+    |

### The Solution

DFTB+ solves this by using **pre-computed parameters** (Slater-Koster files) and a **minimal basis set** to dramatically reduce the computational cost while keeping the essential quantum mechanical physics. This allows researchers to:

- Simulate systems with **thousands of atoms**
- Run **molecular dynamics** over longer timescales
- Perform **high-throughput screening** of materials
- Study **reactive processes** (bond breaking/forming) that classical force fields cannot handle

---

## 1.4 Key Capabilities of DFTB+

DFTB+ is not just a simple tight-binding code — it includes many advanced features:

| Capability                          | Description                                                                 |
|------------------------------------|-----------------------------------------------------------------------------|
| **Geometry Optimization**           | Find the lowest-energy atomic structure for molecules and solids            |
| **Molecular Dynamics (MD)**         | Simulate atomic motion over time (NVE, NVT, NPT ensembles)                |
| **Electronic Structure**            | Calculate band structures, densities of states, orbital energies            |
| **Excited States (TD-DFTB)**        | Time-dependent DFTB for optical spectra and excited-state dynamics         |
| **Electron Transport (NEGF)**       | Non-equilibrium Green's function for quantum transport in nanoscale devices|
| **Periodic Systems**                | Full support for bulk solids, surfaces, and interfaces                      |
| **Dispersion Corrections**          | Van der Waals / London dispersion force corrections (D3, D4, TS)           |
| **Spin Polarisation**               | Collinear and non-collinear spin for magnetic systems                      |
| **QM/MM Coupling**                  | Hybrid quantum mechanics / molecular mechanics simulations                 |
| **Socket Interface**                | Acts as a calculation server for integration with external MD drivers      |

---

## 1.5 How DFTB+ Can Be Used

DFTB+ offers flexible usage modes:

1. **Standalone Application** — Run from the command line with an input file (`dftb_in.hsd`).
2. **Library Integration** — Embed DFTB+ as a library within other codes (Fortran, C, Python APIs).
3. **Calculation Server** — Use via socket communication (e.g., with i-PI for path-integral MD).
4. **Python Wrapper (ASE)** — Control DFTB+ through the Atomic Simulation Environment (ASE).

---

## 1.6 Application Domains

DFTB+ is widely used across multiple scientific domains:

- **Materials Science** — Studying semiconductors, metals, oxides, and nanomaterials
- **Biochemistry** — Simulating large biomolecules (proteins, DNA, enzymes)
- **Nanotechnology** — Modelling carbon nanotubes, graphene, quantum dots
- **Catalysis** — Understanding reaction mechanisms on surfaces
- **Polymer Science** — Investigating polymer properties and degradation
- **Energy Storage** — Battery materials, fuel cell membranes, photovoltaics

---

## 1.7 Summary

| Attribute              | Detail                                                    |
|------------------------|----------------------------------------------------------|
| **Full Name**          | Density Functional Tight Binding Plus                     |
| **Type**               | Quantum mechanical simulation software                    |
| **Method**             | Approximate DFT (tight-binding formalism)                 |
| **Speed**              | 100–1000× faster than standard DFT                        |
| **Accuracy**           | Semi-empirical (depends on parameter quality)             |
| **License**            | Open Source (LGPL v3)                                     |
| **Language**           | Fortran 2018 (with C, C++, and Python interfaces)         |
| **Source Code**        | [github.com/dftbplus/dftbplus](https://github.com/dftbplus/dftbplus) |
| **Official Website**   | [dftbplus.org](https://dftbplus.org)                      |
| **Primary Citation**   | Hourahine et al., *J. Chem. Phys.* 152, 124101 (2020)    |

---

**Next Section:** [02 — Theoretical Background →](../02-theoretical-background/dftb-theory.md)
