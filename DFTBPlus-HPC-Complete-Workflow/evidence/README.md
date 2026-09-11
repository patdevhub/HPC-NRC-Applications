# Evidence folder

Place screenshots/log excerpts here so the repository demonstrates the work instead of only describing it.

Recommended evidence:

1. CMake successful configuration summary
2. `cmake --build` completion
3. `cmake --install` completion
4. `which dftb+`
5. `ldd $(which dftb+) | grep -E "mpi|scalapack|openblas"`
6. `mpirun -np 2 --host compute01,compute02 hostname`
7. 8-rank hostname placement output
8. 4-rank DFTB+ output showing MPI/BLACS grid
9. 8-rank DFTB+ output showing MPI/BLACS grid
10. benchmark runtimes / energies
11. 1536-atom timeout evidence
12. Avogadro screenshot of the 768-atom structure
