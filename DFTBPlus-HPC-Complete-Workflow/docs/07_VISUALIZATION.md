# Phase 7 — Visualization

Two different visualization workflows were used/considered.

## A. Molecular structure visualization

The 768-atom DFTB+ GEN geometry was converted to XYZ:

```bash
python3 scripts/gen_to_xyz.py \
  inputs/benzene_768/benzene_768.gen \
  visualization/benzene_768_structure.xyz
```

Open:

```text
visualization/benzene_768_structure.xyz
```

in Avogadro or VMD.

### What the colors mean

In standard element coloring:

- gray/dark gray spheres = carbon atoms
- white spheres = hydrogen atoms
- sticks/cylinders = bonds or perceived bonding connections

Each benzene molecule contains a six-carbon aromatic ring with one hydrogen attached to each carbon. The full 768-atom object contains 64 repeated benzene molecules placed in a regular benchmark arrangement.

## B. Electronic density / orbital visualization

Structure visualization does not require eigenvectors. Electronic-density or orbital visualization does.

DFTB+ input should include:

```text
Options {
  WriteDetailedXML = Yes
}

Analysis {
  WriteEigenvectors = Yes
}
```

Important outputs:

```text
detailed.xml
eigenvec.bin
```

Waveplot then combines those outputs with a **matching wavefunction basis** to create `.cube` volumetric files.

```text
DFTB+
  ↓
detailed.xml + eigenvec.bin
  ↓
Waveplot
  ↓
*.cube
  ↓
Avogadro / VMD
```

For the earlier MIO water validation, the basis file was `wfc.mio-1-1.hsd`. Do not blindly use the MIO wavefunction basis for a calculation performed with a different Slater-Koster parameter family; use a basis compatible with the chosen parameterisation.

## Visualization programs

**Avogadro** — beginner-friendly molecular structure and volumetric visualization.

**VMD** — powerful for large systems, trajectories, molecular dynamics and volumetric analysis.

**Waveplot** — DFTB+ utility used to generate volumetric data such as charge-density cube files.
