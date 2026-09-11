# 8. Visualisation Tools for DFTB+ Results

## 8.1 Overview

DFTB+ outputs results in standard formats (XYZ, Gen, text data files) that are compatible with many scientific visualisation tools. This section covers the recommended tools for visualising structures, trajectories, and data.

---

## 8.2 Molecular Structure and Trajectory Visualisation

### 8.2.1 VMD (Visual Molecular Dynamics)

| Property   | Detail |
|-----------|--------|
| **Type**   | Desktop application |
| **Best For** | MD trajectories, large systems |
| **Formats** | XYZ, PDB, DCD, and 60+ formats |
| **Platform** | Linux, macOS, Windows |
| **License** | Free for academic/non-commercial use |
| **Website** | [ks.uiuc.edu/Research/vmd](https://www.ks.uiuc.edu/Research/vmd/) |

**Key Features:**
- Render molecular structures in multiple styles (CPK, bonds, ribbons, surfaces)
- Animate MD trajectories
- Compute RDFs, RMSDs, and other analyses
- Scripting via Tcl and Python

**Loading DFTB+ output:**
```tcl
# In VMD Tk Console
mol new geo_end.xyz type xyz waitfor all

# For periodic systems, set the unit cell
pbc set {a b c alpha beta gamma} -all
pbc box
```

---

### 8.2.2 OVITO (Open Visualisation Tool)

| Property   | Detail |
|-----------|--------|
| **Type**   | Desktop application |
| **Best For** | Materials science, crystal structures, defect analysis |
| **Formats** | XYZ, LAMMPS dump, VASP POSCAR, and many more |
| **Platform** | Linux, macOS, Windows |
| **License** | Free (Basic), Pro (paid for advanced features) |
| **Website** | [ovito.org](https://www.ovito.org) |

**Key Features:**
- Common Neighbour Analysis (CNA) for crystal structure identification
- Dislocation Extraction Algorithm (DXA)
- Voronoi analysis, coordination analysis
- Publication-quality rendering
- Python scripting interface

**Loading DFTB+ output:**
1. Open OVITO
2. File → Load File → select `geo_end.xyz`
3. Apply analysis modifiers as needed

---

### 8.2.3 Jmol

| Property   | Detail |
|-----------|--------|
| **Type**   | Java application (also web-embeddable) |
| **Best For** | Quick visualisation, web presentations |
| **Formats** | XYZ, CIF, PDB, MOL, and many more |
| **Platform** | Any platform with Java |
| **License** | Open source (LGPL) |
| **Website** | [jmol.sourceforge.net](http://jmol.sourceforge.net/) |

---

### 8.2.4 VESTA

| Property   | Detail |
|-----------|--------|
| **Type**   | Desktop application |
| **Best For** | Crystal structures, electron density visualisation |
| **Formats** | CIF, VASP, XSF, cube files |
| **Platform** | Linux, macOS, Windows |
| **License** | Free for academic use |
| **Website** | [jp-minerals.org/vesta](https://jp-minerals.org/vesta/) |

---

## 8.3 Data Plotting Tools

### 8.3.1 gnuplot

| Property   | Detail |
|-----------|--------|
| **Type**   | Command-line plotting tool |
| **Best For** | Quick plotting of band structures, DOS, energy profiles |
| **Platform** | Linux, macOS, Windows |
| **License** | Open source |

**Example — Plotting band structure:**
```gnuplot
set xlabel "k-point path"
set ylabel "Energy (eV)"
set title "Band Structure"
plot "band.out" using 1:2 with lines title "Band 1", \
     "band.out" using 1:3 with lines title "Band 2"
```

**Example — Plotting DOS:**
```gnuplot
set xlabel "Energy (eV)"
set ylabel "DOS (states/eV)"
plot "dos_total.dat" using 1:2 with lines title "Total DOS"
```

---

### 8.3.2 matplotlib (Python)

| Property   | Detail |
|-----------|--------|
| **Type**   | Python library |
| **Best For** | Custom, publication-quality figures |
| **Install** | `pip install matplotlib numpy` |

**Example — Plotting band structure:**
```python
import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("band.out")
k_points = data[:, 0]

fig, ax = plt.subplots(figsize=(8, 6))
for i in range(1, data.shape[1]):
    ax.plot(k_points, data[:, i], 'b-', linewidth=0.8)

ax.set_xlabel("k-point path")
ax.set_ylabel("Energy (eV)")
ax.set_title("Electronic Band Structure (DFTB+)")
ax.axhline(y=0, color='k', linestyle='--', linewidth=0.5)
plt.tight_layout()
plt.savefig("band_structure.png", dpi=300)
plt.show()
```

---

## 8.4 Python-Based Workflow Tools

### 8.4.1 ASE (Atomic Simulation Environment)

ASE can both **drive** DFTB+ and **visualise** results:

```python
from ase.io import read
from ase.visualize import view

# Read DFTB+ output
atoms = read("geo_end.xyz")

# Visualise
view(atoms)

# Read a trajectory
traj = read("geo_end.xyz", index=":")
view(traj)  # Animate
```

### 8.4.2 NGLView (Jupyter Notebook Visualisation)

For interactive visualisation in Jupyter notebooks:

```python
import nglview
from ase.io import read

atoms = read("geo_end.xyz")
view = nglview.show_ase(atoms)
view
```

---

## 8.5 Recommended Visualisation Workflow for Our Cluster

Given our cluster environment (limited resources, no GUI on compute nodes):

```
1. Run DFTB+ on cluster → produces geo_end.xyz, band.out, etc.
2. Transfer output files to local workstation (scp / rsync)
3. Visualise:
   ├── Structures/Trajectories → VMD or OVITO
   ├── Band Structures/DOS    → matplotlib or gnuplot
   └── Quick inspection       → ASE view or Jmol
```

---

## 8.6 Tool Selection Guide

| Task | Recommended Tool | Alternative |
|------|-----------------|-------------|
| View a single structure | OVITO | VMD, Jmol |
| Animate MD trajectory | VMD | OVITO |
| Crystal structure analysis | OVITO | VESTA |
| Plot band structure | matplotlib | gnuplot |
| Plot DOS | matplotlib | gnuplot |
| Electron density map | VESTA | VMD |
| Quick inspection (CLI) | ASE | — |
| Jupyter notebook | NGLView | — |
| Publication figures | matplotlib + OVITO | — |

---

**Previous Section:** [← 07 — Input/Output Formats](../07-input-output-formats/input-output.md)  
**Next Section:** [09 — HPC Considerations →](../09-hpc-considerations/hpc-guide.md)
