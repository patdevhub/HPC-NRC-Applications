#!/usr/bin/env python3
import math
import argparse
from pathlib import Path

parser = argparse.ArgumentParser(description="Generate a non-periodic grid of benzene molecules in DFTB+ GEN format.")
parser.add_argument("--nx", type=int, required=True)
parser.add_argument("--ny", type=int, required=True)
parser.add_argument("--nz", type=int, required=True)
parser.add_argument("--spacing", type=float, default=6.0)
parser.add_argument("--output", required=True)
args = parser.parse_args()

carbon_radius = 1.397
hydrogen_radius = 2.487

centers = [
    (ix * args.spacing, iy * args.spacing, iz * args.spacing)
    for ix in range(args.nx)
    for iy in range(args.ny)
    for iz in range(args.nz)
]

atoms = []
for cx, cy, cz in centers:
    for i in range(6):
        a = math.radians(i * 60)
        atoms.append((1, cx + carbon_radius * math.cos(a), cy + carbon_radius * math.sin(a), cz))
    for i in range(6):
        a = math.radians(i * 60)
        atoms.append((2, cx + hydrogen_radius * math.cos(a), cy + hydrogen_radius * math.sin(a), cz))

out = Path(args.output)
out.parent.mkdir(parents=True, exist_ok=True)

with out.open("w") as f:
    f.write(f"{len(atoms)} C\n")
    f.write("C H\n")
    for i, (species, x, y, z) in enumerate(atoms, 1):
        f.write(f"{i} {species} {x:.8f} {y:.8f} {z:.8f}\n")

print(f"Molecules: {len(centers)}")
print(f"Atoms: {len(atoms)}")
print(f"Created: {out}")
