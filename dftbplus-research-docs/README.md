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
