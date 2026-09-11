# Phase 3 — H2O correctness validation

Before benchmarking a large hydrocarbon workload, a tiny water calculation was used as an end-to-end correctness test.

## 1. Create the test directory

```bash
mkdir -p ~/dftb-tests/water
cd ~/dftb-tests/water
```

## 2. Obtain DFTB+ recipe/parameter material

Recorded command:

```bash
wget https://dftbplus-recipes.readthedocs.io/en/latest/_downloads/5919f4094cd60c5c70c13b47928442f5/recipes.tar.bz2
tar -xjf recipes.tar.bz2
```

The H/O water test used MIO Slater-Koster interactions:

```text
H-H.skf
H-O.skf
O-H.skf
O-O.skf
```

The Waveplot basis used later was:

```text
recipes/slakos/wfc/wfc.mio-1-1.hsd
```

Recorded copy command:

```bash
cp ~/dftb-tests/water/recipes/slakos/wfc/wfc.mio-1-1.hsd ~/dftb-tests/water/
```

## 3. Working water input

Create `dftb_in.hsd`:

```text
Geometry = GenFormat {
  3 C
  O H
  1 1  0.0000000000  0.0000000000  0.0000000000
  2 2  0.7586020000  0.0000000000  0.5042840000
  3 2 -0.7586020000  0.0000000000  0.5042840000
}

Driver = GeometryOptimization {
  Optimizer = Rational {}
  MaxSteps = 100
  Convergence {
    GradElem = 1E-4
  }
}

Hamiltonian = DFTB {
  Scc = Yes
  SlaterKosterFiles = Type2FileNames {
    Prefix = "./slakos/"
    Separator = "-"
    Suffix = ".skf"
  }
  MaxAngularMomentum {
    O = "p"
    H = "s"
  }
}

Options {
  WriteDetailedXML = Yes
}

Analysis {
  CalculateForces = Yes
  WriteEigenvectors = Yes
}

ParserOptions {
  ParserVersion = 12
}
```

## 4. Run the calculation

```bash
export OMP_NUM_THREADS=1
cd ~/dftb-tests/water
dftb+
```

Recorded successful result:

```text
Geometry converged
Total Energy = -4.0779379273 H
             ≈ -110.9663 eV
```

This was the baseline proof that the compiled executable could perform a scientific calculation successfully.

## 5. Important generated files

```text
band.out       electronic/band-related output
charges.bin    binary charge/restart information
detailed.out   human-readable detailed results
detailed.xml   structured detailed data
dftb_pin.hsd   interpreted/pinned DFTB+ input
eigenvec.bin   eigenvector data used for Waveplot
geo_end.gen    final optimized geometry in GEN format
geo_end.xyz    final optimized geometry in XYZ format
```

## 6. Waveplot

Create `waveplot_in.hsd`:

```text
Options {
  TotalChargeDensity = Yes
  PlottedLevels = 4
  PlottedSpins = { 1 }
  PlottedRegion = OptimalCuboid {}
  NrOfPoints = { 50 50 50 }
  NrOfCachedGrids = -1
  Verbose = Yes
}

DetailedXML = "detailed.xml"
EigenvecBin = "eigenvec.bin"
GroundState = Yes

Basis {
  Resolution = 0.01
  <<+ "wfc.mio-1-1.hsd"
}
```

Run:

```bash
waveplot
```

Recorded successful output:

```text
File 'wp-abs2.cube' written
Total charge: 7.998256
Grid: 50 x 50 x 50
```

## 7. Transfer to Windows and visualize

Recorded PowerShell command:

```powershell
scp ubuntu@192.168.26.128:/home/ubuntu/dftb-tests/water/wp-abs2.cube "$HOME\Downloads\"
```

The cube was opened successfully in Avogadro. This completed the first end-to-end DFTB+ validation pipeline.
