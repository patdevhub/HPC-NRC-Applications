# Slater-Koster parameters

DFTB+ does not contain all chemical interaction parameters in the executable. Calculations require compatible Slater-Koster (`.skf`) files.

This project used the `3ob-3-1` parameter family for carbon/hydrogen systems.

Required files:

- `C-C.skf`
- `C-H.skf`
- `H-C.skf`
- `H-H.skf`

## Important rules

1. Keep all element-pair files from the same parameter family.
2. Do not mix `3ob`, `mio`, `ob2`, or other parameter sets unless the parameter documentation explicitly says that the combination is valid.
3. Cite the parameterisation publications requested by the parameter-set authors when publishing scientific results.
4. This repository intentionally does not redistribute the `.skf` files. Download them from the official DFTB parameter sources or use the DFTB+ Recipes input archive.

For this tested lab, the files existed under:

`~/dftb-tests/water/recipes/slakos/download/3ob/3ob-3-1/`

and were copied into each workload's `slakos/` directory.
