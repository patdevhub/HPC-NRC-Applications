# Slater-Koster parameter files

DFTB+ requires parameter files describing element-pair interactions. This repository does not redistribute them.

## Water validation

MIO H/O files were used:

```text
H-H.skf
H-O.skf
O-H.skf
O-O.skf
```

## Benzene / hydrocarbon benchmarks

The successful C/H benchmarks used one consistent `3ob-3-1` family:

```text
C-C.skf
C-H.skf
H-C.skf
H-H.skf
```

In the original lab these were available under a DFTB+ Recipes parameter tree similar to:

```text
~/dftb-tests/water/recipes/slakos/download/3ob/3ob-3-1/
```

Copy the four required files into the workload's `slakos/` folder, or point the DFTB+ HSD `Prefix` to their actual location.

Do not mix parameter families unless the parameter documentation explicitly states compatibility.
