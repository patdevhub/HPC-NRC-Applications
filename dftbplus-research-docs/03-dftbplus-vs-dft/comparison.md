# 3. DFTB+ vs Full DFT — A Detailed Comparison

## 3.1 Overview

Both **DFT** (Density Functional Theory) and **DFTB+** (Density Functional Tight Binding Plus) aim to solve the electronic structure of atomic systems. However, they sit at different points on the **accuracy vs. speed** spectrum.

```
Accuracy ←――――――――――――――――――――――――――――――――→ Speed

CCSD(T)  ▸  MP2  ▸  DFT  ▸  DFTB+  ▸  Force Fields
(Most accurate)                          (Fastest)
```

---

## 3.2 Side-by-Side Comparison

| Feature                    | DFT (Ab Initio)                       | DFTB+ (Semi-Empirical)                   |
|---------------------------|----------------------------------------|------------------------------------------|
| **Methodology**            | Full Kohn-Sham equations               | Tight-binding approximation of KS-DFT    |
| **Basis Set**              | Large (plane-wave or Gaussian)         | Minimal (valence orbitals only)           |
| **Integrals**              | Computed on-the-fly                    | Pre-computed (Slater-Koster tables)       |
| **Parameters Required**    | Exchange-correlation functional only   | Slater-Koster files for each element pair |
| **Speed**                  | Baseline                               | 100–1000× faster                         |
| **System Size**            | ~100–500 atoms (practical)             | ~500–10,000 atoms (practical)             |
| **Accuracy**               | High (considered reference)            | Good (within ~0.1–0.3 eV of DFT)         |
| **Bond Breaking**          | ✅ Yes                                  | ✅ Yes                                    |
| **Electronic Structure**   | ✅ Full                                 | ✅ Approximate                            |
| **Charge Transfer**        | ✅ Self-consistent                      | ✅ Self-consistent (SCC-DFTB)             |
| **Excited States**         | ✅ TD-DFT                               | ✅ TD-DFTB                                |
| **Periodic Systems**       | ✅ Yes                                  | ✅ Yes                                    |
| **Van der Waals**          | ✅ With corrections (D3, D4, vdW-DF)    | ✅ With corrections (D3, D4, TS)          |
| **Common Software**        | VASP, Quantum ESPRESSO, Gaussian, ORCA | DFTB+                                    |

---

## 3.3 When to Use DFT

Choose **DFT** when:

1. You need **high accuracy** for energetics (e.g., reaction barriers, formation energies).
2. The system is **small enough** (< 500 atoms) to be tractable.
3. **No Slater-Koster parameters** exist for your elements.
4. You are performing a **benchmark** or validation study.
5. You need to calculate properties that DFTB+ does not support well (e.g., accurate NMR shieldings).

---

## 3.4 When to Use DFTB+

Choose **DFTB+** when:

1. Your system is **too large** for standard DFT (> 500 atoms).
2. You need **long molecular dynamics** trajectories (picoseconds to nanoseconds).
3. You are doing **high-throughput screening** across many structures.
4. You need **quantum mechanical accuracy** but cannot afford DFT computational cost.
5. You are studying **reactive processes** in large systems (e.g., catalysis on nanoparticles).
6. Your **HPC resources are limited** (e.g., small cluster with low RAM — like our setup).

---

## 3.5 Accuracy Benchmarks

Typical errors of SCC-DFTB compared to full DFT:

| Property                    | Typical DFTB Error vs DFT     |
|----------------------------|-------------------------------|
| Bond lengths               | ±0.02–0.05 Å                  |
| Bond angles                | ±1–3°                         |
| Atomisation energies       | ±5–15 kcal/mol                |
| Reaction barriers          | ±2–5 kcal/mol                 |
| Band gaps                  | ±0.3–0.5 eV                   |
| Lattice constants          | ±1–3%                         |

> **Note:** These errors depend heavily on the quality of the Slater-Koster parameter set used. Well-parameterised systems (e.g., organic molecules with the `3ob` set) can achieve errors close to the lower end of these ranges.

---

## 3.6 Resource Requirements Comparison

For a system of 1,000 atoms:

| Resource       | DFT (Typical)           | DFTB+ (Typical)        |
|---------------|-------------------------|------------------------|
| CPU Cores     | 64–256                  | 4–16                   |
| RAM           | 32–128 GB               | 1–4 GB                 |
| Single Point  | Hours                   | Seconds–Minutes        |
| MD (1 ps)     | Days–Weeks              | Hours                  |


---

## 3.7 Complementary Usage

In modern research, DFTB+ and DFT are often used **together**:

1. **Screen with DFTB+** → identify promising candidates quickly.
2. **Refine with DFT** → perform high-accuracy calculations on the best candidates.
3. **Validate DFTB+** → compare a few DFTB+ results against DFT to ensure your parameters are reliable.

This "funnel" approach maximises both speed and accuracy.

---

**Previous Section:** [← 02 — Theoretical Background](../02-theoretical-background/dftb-theory.md)  
**Next Section:** [04 — Features and Capabilities →](../04-features-and-capabilities/features.md)
