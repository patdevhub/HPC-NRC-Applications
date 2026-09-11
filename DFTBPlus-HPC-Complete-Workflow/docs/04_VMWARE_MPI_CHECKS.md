# Phase 4 — Verify MPI inside the VMware mini-cluster

After DFTB+ worked locally, the next question was:

> **Can the VMware nodes communicate and launch one MPI job across both compute nodes?**

## Cluster network

```text
headnode   10.100.0.10
compute01  10.100.0.11
compute02  10.100.0.12
```

Each compute node exposed 4 CPU cores, giving 8 available compute slots in total.

## 1. Test basic IP connectivity

From the headnode:

```bash
ping -c 3 compute01
ping -c 3 compute02
```

If hostnames do not resolve, test the IPs directly and verify `/etc/hosts` or DNS configuration.

## 2. Test SSH

```bash
ssh compute01 hostname
ssh compute02 hostname
```

Recorded successful responses:

```text
compute01
compute02
```

Passwordless SSH is highly useful for manual `mpirun` launches because MPI may need to start processes remotely.

## 3. Test MPI independently of DFTB+

This step isolates MPI from the scientific application:

```bash
mpirun -np 2 --host compute01,compute02 hostname
```

Recorded successful output included both node names.

## 4. Verify all 8 slots and placement

```bash
mpirun \
  -np 8 \
  --host compute01:4,compute02:4 \
  --map-by ppr:4:node \
  --bind-to core \
  hostname
```

Meaning:

- `-np 8` — launch 8 MPI processes.
- `compute01:4,compute02:4` — expose four process slots on each node.
- `ppr:4:node` — place four MPI processes per node.
- `--bind-to core` — bind each MPI process to a CPU core.

This command should show four `compute01` and four `compute02` lines.

## 5. Verify DFTB+ exists remotely

```bash
ssh compute01 /home/ubuntu/dftbplus-install/bin/dftb+
ssh compute02 /home/ubuntu/dftbplus-install/bin/dftb+
```

A direct launch may complain about a missing `dftb_in.hsd` if no working directory is supplied; that still proves the executable is present and starts. A proper job launch supplies the workload directory.
