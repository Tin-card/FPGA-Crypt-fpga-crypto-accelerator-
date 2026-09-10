# FPGA Crypto Accelerator

A synthesizable SystemVerilog implementation of an AES-128 encryption accelerator, with automated verification, simulation, and RTL synthesis.

## Overview

This project implements AES-128 encryption as a hardware accelerator using SystemVerilog.

The design includes the AES encryption datapath, key expansion logic, control logic, and a self-checking verification environment. A Python reference implementation is used to generate expected ciphertexts, while Verilator is used to simulate and verify the RTL.

The project also includes a Yosys synthesis flow for examining the synthesized hardware structure and generating synthesis reports.

The main goal is to develop a complete hardware-design workflow from RTL implementation and verification through synthesis and analysis.

## Architecture

The accelerator is organized around an iterative AES-128 core.

```text
                         +-------------------+
                         |    aes128_top     |
                         |  Top-level Module |
                         +---------+---------+
                                   |
                                   v
                         +-------------------+
                         |    aes128_core    |
                         | Control + Datapath|
                         +----+---------+----+
                              |         |
                +-------------+         +-------------+
                |                                       |
                v                                       v
       +-------------------+                   +-------------------+
       |  aes_key_expand   |                   |     aes_round     |
       |    Key Schedule   |                   |  Round Transform  |
       +---------+---------+                   +---------+---------+
                 |                                       |
                 v                                       v
          +-------------+                         +-------------+
          |  aes_sbox   |                         |  aes_sbox   |
          +-------------+                         +-------------+
```

### AES Operations

The encryption datapath implements the standard AES-128 transformations:

- AddRoundKey
- SubBytes
- ShiftRows
- MixColumns
- Final round without MixColumns

The AES-128 key schedule generates the round keys required by the ten encryption rounds.

## Repository Structure

```text
FPGA-Crypt-fpga-crypto-accelerator/
│
├── rtl/
│   └── aes128/
│       ├── aes_sbox.sv
│       ├── aes_round.sv
│       ├── aes_key_expand.sv
│       ├── aes128_core.sv
│       └── aes128_top.sv
│
├── tb/
│   ├── aes128_tb.sv
│   └── aes_vectors.txt
│
├── scripts/
│   ├── aes_reference.py
│   └── generate_vectors.py
│
├── tests/
│   └── test_aes_reference.py
│
├── synthesis/
│   ├── aes128_synth.v
│   ├── synth.ys
│   └── reports/
│       └── synthesis.txt
│
├── Makefile
├── requirements.txt
└── README.md
```

### Directory Description

| Directory | Description |
|---|---|
| `rtl/` | Synthesizable SystemVerilog implementation |
| `tb/` | SystemVerilog testbench and verification vectors |
| `scripts/` | Python reference model and vector generation |
| `tests/` | Python tests for the reference implementation |
| `synthesis/` | Yosys synthesis script, synthesized RTL, and reports |

## Verification

Verification uses a Python reference implementation together with a self-checking SystemVerilog testbench.

The vector generator produces:

- Standard AES-128 test vectors
- Fixed edge-case vectors
- Deterministic random test vectors

The random vectors are generated using a fixed seed so that the same verification set can be reproduced across runs.

The generated vector file contains 103 test cases, with each case containing:

```text
test_name
key
plaintext
expected_ciphertext
```

The SystemVerilog testbench reads these vectors, applies them to the AES accelerator, and compares the hardware output against the expected ciphertext.

### Verification Flow

```text
Python AES Reference
        |
        v
Verification Vector Generation
        |
        v
tb/aes_vectors.txt
        |
        v
SystemVerilog Testbench
        |
        v
Verilator Simulation
        |
        v
Pass / Fail Results
```

## Synthesis

The project uses Yosys for RTL synthesis.

The synthesis script:

```text
synthesis/synth.ys
```

reads the AES RTL, performs RTL and technology-independent optimization, reports the resulting design statistics, and writes a synthesized Verilog representation.

Run synthesis with:

```bash
make synth
```

The generated files are placed under:

```text
synthesis/
├── aes128_synth.v
└── reports/
    └── synthesis.txt
```

The synthesis report contains technology-independent Yosys statistics. These values should not be interpreted as FPGA LUT, timing, or maximum-frequency results for a specific FPGA device.

FPGA-specific resource utilization and timing require synthesis and implementation for a particular FPGA architecture and device.

## Requirements

The following tools are required:

- Python 3
- Verilator
- Yosys
- Git

Python dependencies are listed in:

```text
requirements.txt
```

Install them with:

```bash
python -m pip install -r requirements.txt
```

## Build and Run

The project provides a Makefile to simplify the common development tasks.

### Generate verification vectors

```bash
make vectors
```

### Run RTL simulation

```bash
make rtl-test
```

This generates the verification vectors, compiles the SystemVerilog design and testbench with Verilator, and runs the simulation.

### Run complete verification

```bash
make test
```

This runs the Python tests followed by the RTL simulation.

### Run synthesis

```bash
make synth
```

### Clean generated files

```bash
make clean
```

### Show available commands

```bash
make help
```

## Synthesis Statistics

The current generic Yosys synthesis reports the following hierarchy-level cell counts:

| Module | Cells |
|---|---:|
| `aes128_core` | 1059 |
| `aes_key_expand` | 138 |
| `aes_round` | 800 |
| `aes_sbox` | 2 |
| **Total hierarchy** | **2037** |

The synthesized design contains generic logic elements including multiplexers, XOR gates, AND/OR/NOT gates, and sequential elements.

These figures are useful for comparing RTL changes, but they are not equivalent to the resource utilization reported by a vendor FPGA implementation tool.

## Design Notes

### AES State Representation

The AES state is represented as a 128-bit vector and processed using the standard AES byte ordering required by the algorithm.

### Iterative Processing

The core processes the AES rounds sequentially under control logic rather than instantiating ten completely independent round datapaths.

This reduces duplicated combinational hardware at the cost of requiring multiple clock cycles for a single encryption operation.

### S-Box

The AES S-box is implemented as a synthesizable lookup structure. Its final mapping to FPGA resources depends on the target device and synthesis tool.

## Future Work

Possible extensions include:

- FPGA-specific synthesis and implementation
- Resource utilization analysis
- Static timing analysis
- Latency and throughput benchmarking
- FPGA board deployment
- Interface integration such as AXI or memory-mapped control
- Hardware/software co-design
- Additional cryptographic accelerators such as SHA-256

## References

- NIST, *FIPS 197: Advanced Encryption Standard (AES)*
- Joan Daemen and Vincent Rijmen, *The Design of Rijndael*
- Verilator documentation
- Yosys documentation

## License

This project is intended for educational and research purposes. 
This project is licensed under the MIT License. See the LICENSE file for the full license text.
