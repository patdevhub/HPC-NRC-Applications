# DFTB+ Workflow Diagrams

## Overall DFTB+ Simulation Workflow

```mermaid
flowchart TD
    A["1. Define System"] --> B["2. Prepare Geometry File\n(geo.gen)"]
    B --> C["3. Select Slater-Koster\nParameter Set"]
    C --> D["4. Create Input File\n(dftb_in.hsd)"]
    D --> E["5. Run DFTB+"]
    E --> F{"Check Convergence"}
    F -->|Not Converged| G["Adjust Parameters\n(SCC tolerance, max iterations)"]
    G --> D
    F -->|Converged| H["6. Analyse Output\n(detailed.out, results.tag)"]
    H --> I["7. Visualise Results\n(VMD, OVITO, matplotlib)"]
    I --> J["8. Publication / Report"]
```

## Build Process Workflow

```mermaid
flowchart TD
    A["Install Prerequisites\n(GCC, CMake, OpenBLAS, OpenMPI)"] --> B["Clone DFTB+ Source\n(git clone + submodules)"]
    B --> C["Configure with CMake\n(-DWITH_MPI=YES)"]
    C --> D{"Configuration OK?"}
    D -->|Error| E["Fix Missing Dependencies\nor CMake Flags"]
    E --> C
    D -->|Success| F["Build with Make\n(make -j2)"]
    F --> G{"Build OK?"}
    G -->|Error| H["Check Compiler Errors\n/ Memory Issues"]
    H --> F
    G -->|Success| I["Install\n(make install)"]
    I --> J["Run Tests\n(ctest)"]
    J --> K{"Tests Pass?"}
    K -->|Fail| L["Debug Failing Tests"]
    L --> C
    K -->|Pass| M["DFTB+ Ready!"]
```

## Parallelisation Decision Tree

```mermaid
flowchart TD
    A["System Size?"] --> B{"< 200 atoms"}
    A --> C{"> 200 atoms"}
    
    B --> D["Single Node\nSerial or OpenMP"]
    D --> E["Run on Head Node\nor Single Compute Node"]
    
    C --> F{"< 1000 atoms"}
    C --> G{"> 1000 atoms"}
    
    F --> H["2-4 MPI Processes\nAcross 1-2 Nodes"]
    
    G --> I["4-8 MPI Processes\nAcross 2 Nodes"]
    I --> J["Monitor Memory!\nMax ~1500 atoms\non our cluster"]
```

## DFTB Method Hierarchy

```mermaid
flowchart LR
    A["Quantum Chemistry Methods"] --> B["Ab Initio\n(First Principles)"]
    A --> C["Semi-Empirical"]
    A --> D["Classical\n(Force Fields)"]
    
    B --> B1["CCSD(T)\nMost Accurate"]
    B --> B2["MP2"]
    B --> B3["DFT\n(VASP, QE, Gaussian)"]
    
    C --> C1["DFTB+\n(This Software)"]
    C --> C2["PM7, AM1\n(Older Methods)"]
    
    D --> D1["AMBER, CHARMM\nLAMMPS"]

    style C1 fill:#4CAF50,color:#fff
```

## Data Flow in a Typical DFTB+ Calculation

```mermaid
flowchart LR
    subgraph Inputs
        A["geo.gen\n(Geometry)"]
        B["dftb_in.hsd\n(Settings)"]
        C["*.skf files\n(Parameters)"]
    end
    
    subgraph DFTB+ Engine
        D["Parse Input"]
        E["Build Hamiltonian"]
        F["Self-Consistent\nCharge Loop"]
        G["Calculate Properties"]
    end
    
    subgraph Outputs
        H["detailed.out\n(Results)"]
        I["geo_end.xyz\n(Final Structure)"]
        J["band.out\n(Band Structure)"]
        K["charges.bin\n(Restart Data)"]
    end
    
    A --> D
    B --> D
    C --> E
    D --> E
    E --> F
    F --> G
    G --> H
    G --> I
    G --> J
    G --> K
```
