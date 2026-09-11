# Evidence checklist

Add screenshots or terminal captures here before final submission.

Recommended evidence:

1. `mpirun -np 8 --host compute01:4,compute02:4 ... hostname`
   - show four `compute01` and four `compute02` entries.

2. 96-atom DFTB+ 8-rank run
   - show `MPI processes: 8`
   - show `OpenMP threads: 1`
   - show BLACS grid.

3. 768-atom 1-rank run
   - show total energy and wall time.

4. 768-atom 2-rank run
   - show total energy and wall time.

5. 768-atom 4-rank run
   - show total energy and wall time.

6. 768-atom 8-rank / two-node run
   - show `MPI processes: 8`, BLACS grid, same total energy and wall time.

7. 1536-atom 4-rank run
   - show successful result and wall time.

8. 1536-atom 8-rank run
   - show that the 300 s timeout terminated the test.

9. Avogadro structure visualization
   - include the 768-atom benzene-cluster screenshot.

Do not edit benchmark screenshots to change numbers; crop only for readability.
