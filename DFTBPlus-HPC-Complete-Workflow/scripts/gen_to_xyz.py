#!/usr/bin/env python3
import argparse
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("gen_file")
p.add_argument("xyz_file")
args = p.parse_args()

lines = [x.strip() for x in Path(args.gen_file).read_text().splitlines() if x.strip()]
natoms = int(lines[0].split()[0])
labels = lines[1].split()

atoms = []
for line in lines[2:2+natoms]:
    parts = line.split()
    element = labels[int(parts[1]) - 1]
    atoms.append((element, float(parts[2]), float(parts[3]), float(parts[4])))

with Path(args.xyz_file).open("w") as f:
    f.write(f"{natoms}\n")
    f.write("Generated from DFTB+ GEN geometry\n")
    for element, x, y, z in atoms:
        f.write(f"{element} {x:.8f} {y:.8f} {z:.8f}\n")

print(f"Created {args.xyz_file} with {natoms} atoms")
