# 2. Theoretical Background — The DFTB Method

## 2.1 Starting Point: Density Functional Theory (DFT)

To understand DFTB+, you first need to understand the method it approximates: **Density Functional Theory (DFT)**.

DFT is a quantum mechanical method for calculating the electronic structure of atoms, molecules, and solids. It is based on two fundamental theorems by **Hohenberg and Kohn (1964)**:

1. The ground-state properties of a many-electron system are uniquely determined by its **electron density** $\rho(\mathbf{r})$.
2. There exists an **energy functional** $E[\rho]$ that is minimised by the true ground-state density.

In practice, DFT solves the **Kohn-Sham equations** — a set of single-particle equations that reproduce the exact ground-state density:

$$\left[-\frac{\hbar^2}{2m}\nabla^2 + V_{\text{eff}}(\mathbf{r})\right] \psi_i(\mathbf{r}) = \varepsilon_i \psi_i(\mathbf{r})$$

where $V_{\text{eff}}$ is an effective potential that includes:
- External potential (e.g., nuclear attraction)
- Hartree (classical electron-electron repulsion)
- Exchange-correlation potential

**Problem:** Solving these equations for large systems requires enormous computational resources.

---

## 2.2 The Tight-Binding Approximation

The **tight-binding (TB)** method is one of the oldest approaches in solid-state physics (dating back to **Bloch, 1928**). It assumes:

1. Electrons are **tightly bound** to their atoms.
2. The electronic wavefunctions can be expressed as **linear combinations of atomic orbitals (LCAO)**.
3. Only interactions between **nearby atoms** are significant.

This reduces the problem from solving continuous differential equations to solving a finite-dimensional **eigenvalue problem** — a matrix equation that is much cheaper computationally.

---

## 2.3 From DFT to DFTB: The Derivation

The DFTB method is derived by performing a **Taylor series expansion** of the Kohn-Sham total energy around a **reference density** $\rho_0$:

$$E[\rho_0 + \delta\rho] = E^{(0)}[\rho_0] + E^{(1)}[\rho_0, \delta\rho] + E^{(2)}[\rho_0, (\delta\rho)^2] + \cdots$$

Each order of this expansion defines a different level of DFTB:

### 2.3.1 Non-Self-Consistent (Non-SCC) DFTB — Zeroth + First Order

- Uses a **reference density** constructed as a superposition of neutral atomic densities.
- The energy is calculated **without** iterating to self-consistency.
- Fast but limited to systems with **little charge transfer** between atoms.

### 2.3.2 Self-Consistent Charge DFTB (SCC-DFTB) — Second Order

- Introduces a self-consistent treatment of **Mulliken charges**.
- Charge fluctuations $\delta\rho$ are treated through a **gamma function** that describes the interaction between atomic charge monopoles.
- This is the most widely used variant.
- Significantly improves accuracy for:
  - Polar molecules
  - Ionic systems
  - Systems with charge transfer

### 2.3.3 Third-Order DFTB (DFTB3)

- Extends the expansion to third order.
- Introduces **charge-dependent Hubbard parameters**.
- Improves description of:
  - Hydrogen bonding
  - Proton transfer reactions
  - Electrolyte solutions
  - Highly charged systems

---

## 2.4 Key Approximations in DFTB

DFTB achieves its speed through several systematic approximations:

| Approximation                        | What It Means                                                     |
|--------------------------------------|------------------------------------------------------------------|
| **Minimal Basis Set**                | Only valence orbitals are used (e.g., `s` for H, `s,p` for C)    |
| **Two-Centre Approximation**         | Matrix elements depend only on pairs of atoms, not triplets       |
| **Pre-Computed Integrals**           | Hamiltonian and overlap integrals are tabulated in SK files        |
| **Pairwise Repulsive Potential**     | Short-range repulsion is approximated by a fitted pairwise potential|
| **Monopole Approximation (SCC)**     | Charge fluctuations are treated at the atomic monopole level       |

---

## 2.5 The Slater-Koster Parameterisation

The central innovation that makes DFTB practical is the **Slater-Koster (SK) table**:

1. For each pair of elements (e.g., C-C, C-H, O-H), the Hamiltonian matrix elements $H_{\mu\nu}(R)$ and overlap matrix elements $S_{\mu\nu}(R)$ are **pre-computed as a function of interatomic distance** $R$.
2. These are stored in `.skf` (Slater-Koster file) format.
3. During a DFTB+ calculation, the code simply **looks up** these values from the tables instead of computing them from scratch.

This is why DFTB+ needs **parameter files** — and why the quality of results depends heavily on the quality of these parameters.

---

## 2.6 The Total Energy Expression

The total energy in SCC-DFTB is expressed as:

$$E_{\text{tot}} = \sum_i^{\text{occ}} n_i \langle \psi_i | \hat{H}^0 | \psi_i \rangle + \frac{1}{2} \sum_{A,B} \gamma_{AB} \Delta q_A \Delta q_B + E_{\text{rep}}$$

Where:
- **First term**: Band structure energy (from the tight-binding Hamiltonian)
- **Second term**: Self-consistent charge correction (Coulomb interaction of charge fluctuations)
- **Third term**: Short-range repulsive energy (fitted to higher-level calculations)

---

## 2.7 Computational Scaling

| Method         | Scaling        | Practical System Size         |
|----------------|----------------|-------------------------------|
| CCSD(T)        | $O(N^7)$       | ~10–30 atoms                  |
| MP2            | $O(N^5)$       | ~50–100 atoms                 |
| DFT            | $O(N^3)$       | ~100–500 atoms                |
| **DFTB+**      | $O(N^3)$ but with tiny prefactor | **~500–10,000 atoms** |
| Force Fields   | $O(N)$ to $O(N^2)$ | ~100,000+ atoms          |

DFTB+ has the same formal scaling as DFT ($O(N^3)$ for matrix diagonalisation), but because it uses a **minimal basis set** and **pre-computed integrals**, the actual computation per step is **100–1000× smaller**.

---

## 2.8 Strengths of the DFTB Approach

✅ Quantum mechanical description of electronic structure  
✅ Can describe bond breaking and formation  
✅ Captures charge transfer between atoms  
✅ Fast enough for molecular dynamics on large systems  
✅ Parameters available for most common elements  

## 2.9 Limitations of the DFTB Approach

⚠️ Accuracy depends on the quality of parameter sets  
⚠️ Parameters may not exist for all element combinations  
⚠️ Less accurate than full DFT for subtle electronic effects  
⚠️ Not suitable for systems requiring highly accurate energetics  
⚠️ Results must be validated against higher-level methods  

---

**Previous Section:** [← 01 — Introduction](../01-introduction/what-is-dftbplus.md)  
**Next Section:** [03 — DFTB+ vs DFT Comparison →](../03-dftbplus-vs-dft/comparison.md)
