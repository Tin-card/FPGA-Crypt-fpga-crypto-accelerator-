# FPGA Crypto Accelerator

Synthesizable **SystemVerilog implementation of an AES-128 hardware accelerator**, with simulation, automated verification, and RTL synthesis analysis.

## Architecture

The accelerator implements the AES-128 encryption datapath and key expansion as synchronous RTL.

```text
             Plaintext + Key
                    │
                    ▼
             ┌─────────────┐
             │ Key Expansion│
             └──────┬──────┘
                    │
                    ▼
             ┌─────────────┐
             │ AES Datapath │
             │             │
             │ SubBytes    │
             │ ShiftRows   │
             │ MixColumns  │
             │ AddRoundKey │
             └──────┬──────┘
                    │
                    ▼
              Ciphertext
```

The design is organized around a **cryptographic datapath, key expansion logic, state registers, and control logic**.

## Implementation

* AES-128 encryption
* AES key expansion
* SubBytes
* ShiftRows
* MixColumns
* AddRoundKey
* Control logic
* Synthesizable SystemVerilog RTL

## Verification

The RTL is verified using a self-checking testbench and standard AES test vectors.

Simulation and verification use:

* **Verilator**
* **Python**
* **pytest**

## Synthesis & Analysis

The RTL is synthesized with **Yosys** to evaluate the hardware implementation.

The analysis covers:

* Logic utilization
* Sequential elements
* Critical-path timing
* Encryption latency
* Maximum operating frequency
* Throughput

## Toolchain

| Tool          | Purpose                   |
| ------------- | ------------------------- |
| SystemVerilog | RTL implementation        |
| Verilator     | RTL simulation            |
| pytest        | Automated verification    |
| Yosys         | RTL synthesis             |
| Python        | Test and analysis scripts |
| Git           | Version control           |

## Repository

```text
FPGA-Crypt/
├── rtl/          # SystemVerilog RTL
├── tb/           # Testbench and test vectors
├── scripts/      # Simulation and synthesis scripts
├── sim/          # Simulation files
├── results/      # Synthesis and performance results
└── docs/         # Design documentation
```

## Results

| Metric            |     Result |
| ----------------- | ---------: |
| Technology / FPGA |        TBD |
| Maximum Frequency |        TBD |
| Latency           | TBD cycles |
| Throughput        |        TBD |
| LUTs / Cells      |        TBD |
| Flip-Flops        |        TBD |
| Memory            |        TBD |

## Scope

Current scope is **AES-128 encryption in synthesizable RTL**, followed by functional verification and hardware implementation analysis.

Future work may include additional cryptographic primitives, architectural optimization, and FPGA hardware benchmarking.
