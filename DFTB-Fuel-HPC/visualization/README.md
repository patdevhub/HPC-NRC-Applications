# Visualization

## Structural visualization

The simplest visualization uses the molecular geometry itself.

Convert a DFTB+ GEN file to XYZ:

```bash
python3 scripts/gen_to_xyz.py   inputs/benzene_768/benzene_768.gen   visualization/benzene_768_structure.xyz
```

Open the XYZ file with:

- Avogadro
- VMD
- other molecular viewers that support XYZ

For a clear presentation, use Ball-and-Stick or Licorice rendering and frame the entire molecular cluster.

## Electronic-density / orbital visualization with Waveplot

For volumetric electronic visualization, the DFTB+ calculation must write:

- `detailed.xml`
- `eigenvec.bin`

Enable these:

```text
Options {
  WriteDetailedXML = Yes
}

Analysis {
  WriteEigenvectors = Yes
}
```

Then run `waveplot` with a `waveplot_in.hsd` that references:

- `DetailedXML = "detailed.xml"`
- `EigenvecBin = "eigenvec.bin"`
- a wavefunction-basis HSD file matching the chosen Slater-Koster parameter set

Waveplot can produce `.cube` volumetric files. These can be opened as charge-density/orbital isosurfaces in suitable visualization tools.

### Important

The performance benchmark input intentionally omitted eigenvector output for the larger cases to reduce extra disk I/O. If electronic visualization is needed, use `inputs/benzene_768/dftb_in_visualization.hsd` as the starting input and make sure the matching wavefunction basis is available.

## Avogadro vs VMD

**Avogadro**
- beginner-friendly molecular structure viewer
- good for XYZ/GEN-derived structures
- convenient for screenshots, rotation and basic molecular presentation

**VMD**
- stronger for trajectories and larger molecular systems
- useful for molecular-dynamics playback
- supports many volumetric and trajectory workflows
