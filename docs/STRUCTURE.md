# Project Structure

## Repository Layout

```text
FPGA-Crypt/
│
├── rtl/
│   ├── aes_core.sv
│   ├── aes_round.sv
│   ├── key_expand.sv
│   └── ...
│
├── tb/
│   ├── aes_tb.sv
│   └── vectors/
│
├── scripts/
│   ├── sim/
│   └── synth/
│
├── sim/
│   └── ...
│
├── results/
│   ├── synthesis/
│   └── timing/
│
├── docs/
│   ├── STRUCTURE.md
│   └── ...
│
├── Makefile
└── README.md
```

## Directory Description

| Directory  | Purpose                                 |
| ---------- | --------------------------------------- |
| `rtl/`     | Synthesizable SystemVerilog design      |
| `tb/`      | Testbenches and verification vectors    |
| `scripts/` | Simulation and synthesis automation     |
| `sim/`     | Generated simulation artifacts          |
| `results/` | Synthesis, timing and performance data  |
| `docs/`    | Design and implementation documentation |

## RTL Organization

The RTL is divided into functional blocks rather than a single monolithic AES module.

```text
AES Core
│
├── Control
│   └── Operation sequencing
│
├── Datapath
│   ├── SubBytes
│   ├── ShiftRows
│   ├── MixColumns
│   └── AddRoundKey
│
├── Key Expansion
│   └── Round-key generation
│
└── Registers
    └── State and control storage
```

The exact module hierarchy should follow the current RTL implementation. This document describes the intended repository organization, while the RTL remains the source of truth.
