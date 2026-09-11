# 6. Slater-Koster Parameter Files

## 6.1 What Are Slater-Koster Files?

Slater-Koster (SK) files are **pre-computed data tables** that DFTB+ requires to run calculations. Because DFTB is a semi-empirical method, it does not compute electronic integrals from scratch (as full DFT does). Instead, it reads these integrals from SK files.

Each SK file contains:
- **Hamiltonian matrix elements** $H_{\mu\nu}(R)$ — how atomic orbitals interact as a function of distance
- **Overlap matrix elements** $S_{\mu\nu}(R)$ — orbital overlap as a function of distance
- **Repulsive potential** $V_{\text{rep}}(R)$ — short-range repulsion between atom pairs
- **Atomic data** — orbital energies, Hubbard parameters, spin constants

---

## 6.2 File Naming Convention

SK files follow a strict naming pattern:

```
Element1-Element2.skf
```

**Examples:**
| File Name      | Describes Interaction Between |
|---------------|-------------------------------|
| `C-C.skf`     | Carbon–Carbon                 |
| `C-H.skf`     | Carbon–Hydrogen               |
| `H-C.skf`     | Hydrogen–Carbon (reverse)     |
| `O-O.skf`     | Oxygen–Oxygen                 |
| `Si-Si.skf`   | Silicon–Silicon               |

> **Important:** For each pair of elements A-B, you need **both** `A-B.skf` and `B-A.skf`. These are not identical because the orbital structure of A and B may differ.

---

## 6.3 Available Parameter Sets

Parameter sets are downloadable from the official repository at **[dftb.org/parameters/download](https://dftb.org/parameters/download)**.

### Major Parameter Sets

| Set Name | Elements | Best For | Notes |
|----------|----------|----------|-------|
| **3ob** (3rd Order Organic/Biological) | H, C, N, O, S, P, Zn, ... | Organic molecules, biomolecules | Most widely used; excellent for organic chemistry |
| **mio** (Molecular, Inorganic, Organic) | H, C, N, O, S, P | Organic/bio-organic molecules | Classic set, predecessor to 3ob |
| **pbc** (Periodic Boundary Conditions) | Si, F, O, N, H, C, Fe, ... | Bulk solids, surfaces | Optimised for periodic systems |
| **matsci** (Materials Science) | Various subsets | Specific materials (TiO₂, ZnO, etc.) | Collection of specialised sets |
| **PTBP** (Periodic Table Baseline) | H–Rn (~90 elements) | Broad coverage for solids | Newest, widest coverage |
| **hyb** | Similar to mio | Hybrid functional calculations | For use with range-separated hybrids |

---

## 6.4 How to Set Up SK Files

### Step 1: Download the Parameter Set
```bash
# Download 3ob parameters (example)
wget https://dftb.org/fileadmin/DFTB/public/slako/3ob/3ob-3-1.tar.xz
tar -xf 3ob-3-1.tar.xz
```

### Step 2: Reference in Your Input File
In `dftb_in.hsd`, point to the SK files:

```hsd
Hamiltonian = DFTB {
  SCC = Yes
  SlaterKosterFiles = Type2FileNames {
    Prefix = "/path/to/3ob-3-1/"
    Separator = "-"
    Suffix = ".skf"
  }
  MaxAngularMomentum {
    C = "p"
    H = "s"
    O = "p"
    N = "p"
  }
}
```

Or specify individually:
```hsd
SlaterKosterFiles = {
  C-C = "/path/to/3ob-3-1/C-C.skf"
  C-H = "/path/to/3ob-3-1/C-H.skf"
  H-C = "/path/to/3ob-3-1/H-C.skf"
  H-H = "/path/to/3ob-3-1/H-H.skf"
}
```

---

## 6.5 Critical Rules for Using SK Files

> ⚠️ **Do NOT mix parameter sets.** All SK files in a single calculation must come from the **same** parameter set. Mixing files from `3ob` and `mio`, for example, will produce unphysical results.

> ⚠️ **Check element coverage.** Before starting a calculation, verify that your chosen parameter set has SK files for **all** element pairs in your system.

> ⚠️ **Check for repulsive potentials.** Some SK files do not include repulsive potentials. Without them, you cannot perform geometry optimisation or MD — only single-point energy calculations.

> ⚠️ **Set MaxAngularMomentum correctly.** Each element requires its maximum angular momentum quantum number to be specified. This information is provided in the documentation of each parameter set.

---

## 6.6 MaxAngularMomentum Reference

Common values for frequently used elements:

| Element | Symbol | MaxAngularMomentum |
|---------|--------|-------------------|
| Hydrogen | H     | "s"               |
| Carbon   | C     | "p"               |
| Nitrogen | N     | "p"               |
| Oxygen   | O     | "p"               |
| Sulphur  | S     | "d"               |
| Phosphorus| P    | "d"               |
| Silicon  | Si    | "d"               |
| Iron     | Fe    | "d"               |
| Zinc     | Zn    | "d"               |
| Titanium | Ti    | "d"               |

---

## 6.7 Generating Custom Parameters

If no pre-built parameters exist for your system, you can generate your own using:

- **skprogs** ([github.com/dftbplus/skprogs](https://github.com/dftbplus/skprogs)) — the official SK parameter generation tool
- Fitting against reference DFT calculations (e.g., from VASP, Quantum ESPRESSO)

This is an advanced task that requires expertise in electronic structure theory.

---

**Previous Section:** [← 05 — Software Prerequisites](../05-software-prerequisites/prerequisites.md)  
**Next Section:** [07 — Input/Output Formats →](../07-input-output-formats/input-output.md)
