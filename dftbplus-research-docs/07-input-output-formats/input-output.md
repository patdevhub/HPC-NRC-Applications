# 7. Input and Output File Formats

## 7.1 Input Files

DFTB+ uses a small number of input files to define a calculation.

---

### 7.1.1 `dftb_in.hsd` — The Main Input File

This is the **primary input file** that controls every aspect of the calculation. It uses the **HSD (Human-readable Structured Data)** format.

**Key characteristics:**
- Tree-structured with curly braces `{}`
- Case-insensitive for keywords (but case-sensitive for filenames)
- Block order is arbitrary
- Comments start with `#`

**Structure overview:**
```hsd
# 1. This block defines the 3D atomic structure (geometry) of the molecule using the DFTB+ native GenFormat.
Geometry = GenFormat {
  <<< "geo.gen"
}

# 2. The driver tells the software what to do with the geometry.
Driver = GeometryOptimization {
  Optimizer = Rational {}  //Uses the Rational Function Optimization (RFO) algorithm to relax the atomic coordinates.
  MaxSteps = 100 // The simulation will stop and fail if it cannot find the optimal structure within 100 steps
  Convergence { 
    GradElem = 1E-4
  }  //The stopping criteria
}

# 3.This block defines the quantum mechanical method used to calculate the energy and forces of the molecule.
Hamiltonian = DFTB {  
  SCC = Yes //Enables Self-Consistent Charge calculations. This allows electronic charge to transfer dynamically between the atoms
  SCCTolerance = 1E-5
  MaxSCCIterations = 100
  SlaterKosterFiles = Type2FileNames { 
    Prefix = "./slako/3ob-3-1/"
    Separator = "-"
    Suffix = ".skf"
  } //specifies the file paths to the pre-calculated interaction parameters (Slater-Koster files) for every atom-pair combination (O-O, O-H, H-O, H-H)
  MaxAngularMomentum {
    C = "p"
    H = "s"
    O = "p"
  } //Defines the valence electron orbitals to include for each element.
}
Options {}  //This is used for miscellaneous global control settings (like temperature, printing options, or parallel execution parameters)

# 4. Define what to analyse/output
Analysis {
  CalculateForces = Yes
} //Instructs the program to explicitly calculate and output the mechanical forces acting on each atom at the end of the calculation.

# 5. Parser version for compatibility
ParserOptions {
  ParserVersion = 12
} //Tells the DFTB+ software which syntax version rulebook to use when reading this input file format.
```

---

### 7.1.2 Main HSD Blocks

| Block | Purpose | Example Values |
|-------|---------|----------------|
| `Geometry` | Atomic positions and cell | `GenFormat`, `xyzFormat`, `VaspFormat` |
| `Driver` | Simulation type | `GeometryOptimization`, `VelocityVerlet` (MD), `{}` (single point) |
| `Hamiltonian` | Physics method | `DFTB`, `xTB` |
| `Analysis` | Post-processing | Forces, Mulliken charges, band structure |
| `Options` | Runtime settings | Timing verbosity, write modes |
| `ParserOptions` | Input compatibility | Parser version number |
| `ExcitedState` | Excited state method | `Casida`, `TD-DFTB` |
| `Transport` | Electron transport | NEGF settings |

---

### 7.1.3 `geo.gen` — Geometry File (Gen Format)

The **Gen format** is DFTB+'s native geometry format:

**Cluster (molecule) example:**
```
3 C
O H
1 1  0.00000  0.00000  0.11926
2 2  0.00000  0.76324 -0.47703
3 2  0.00000 -0.76324 -0.47703
```

- Line 1: Number of atoms, `C` = Cluster (non-periodic) or `S` = Supercell (periodic)
- Line 2: Element types
- Following lines: Atom index, element type index, x, y, z coordinates

**Periodic (supercell) example:**
```
2 S
Si
1 1  0.00000  0.00000  0.00000
2 1  0.25000  0.25000  0.25000
0.00000  0.00000  0.00000
5.43100  0.00000  0.00000
0.00000  5.43100  0.00000
0.00000  0.00000  5.43100
```

- After atom coordinates: origin, then 3 lattice vectors

---

## 7.2 Output Files

DFTB+ produces several output files:

### 7.2.1 Primary Output Files

| File | Contents | Format |
|------|----------|--------|
| `dftb_pin.hsd` | Processed input with all defaults filled in | HSD |
| `detailed.out` | Main calculation results (energies, charges, forces) | Text |
| `results.tag` | Machine-readable results | Tag format |
| `charges.bin` | Converged charges (for restart) | Binary |
| `geo_end.gen` | Final geometry after optimisation | Gen |
| `geo_end.xyz` | Final geometry in XYZ format | XYZ |

### 7.2.2 Molecular Dynamics Output Files

| File | Contents | Format |
|------|----------|--------|
| `geo_end.{gen,xyz}` | MD trajectory (all frames) | Gen/XYZ |
| `md.out` | MD log (energy, temperature, pressure per step) | Text |
| `velocities.out` | Atomic velocities per frame | Text |

### 7.2.3 Electronic Structure Output Files

| File | Contents | Format |
|------|----------|--------|
| `band.out` | Band structure data | Text (plottable) |
| `dos_total.dat` | Total density of states | Text |
| `eigenvec.out` | Eigenvectors | Text |
| `EXC.DAT` | Excitation energies and oscillator strengths (TD-DFTB) | Text |

---

## 7.3 The XYZ File Format

The **XYZ format** is the most universal format for molecular visualisation. DFTB+ can output trajectories in XYZ:

```
3
Water molecule - step 1
O   0.000000   0.000000   0.119262
H   0.000000   0.763239  -0.477047
H   0.000000  -0.763239  -0.477047
3
Water molecule - step 2
O   0.000100   0.000050   0.119300
H   0.000200   0.763300  -0.477000
H  -0.000100  -0.763200  -0.477100
```

- Line 1: Number of atoms
- Line 2: Comment line (often contains energy or step number)
- Following lines: Element symbol, x, y, z coordinates
- Pattern repeats for each frame

---

## 7.4 Key Input File Tips

1. **Always keep `dftb_pin.hsd`** — it contains the full parsed input with all defaults, essential for reproducibility.
2. **Use `ParserVersion`** — ensures your input file works with future DFTB+ versions.
3. **Start simple** — begin with a single-point calculation before geometry optimisation or MD.
4. **Check units** — DFTB+ uses **atomic units** (Bohr, Hartree) internally, but many keywords accept Ångströms and eV with explicit unit specification.

---

**Previous Section:** [← 06 — Parameter Files](../06-parameter-files/slater-koster-files.md)  
**Next Section:** [08 — Visualisation Tools →](../08-visualization-tools/visualization.md)
