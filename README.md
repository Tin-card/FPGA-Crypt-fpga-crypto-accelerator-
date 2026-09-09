# FPGA Crypto Accelerator

A synthesizable SystemVerilog implementation of hardware cryptographic acceleration, starting with an AES-128 encryption core.

## Objectives

- Design an AES-128 encryption core in synthesizable SystemVerilog
- Develop a self-checking verification environment
- Verify the RTL against standard AES test vectors
- Simulate the design using Verilator
- Synthesize the RTL using Yosys
- Analyze area, timing, latency, and throughput
- Document the hardware architecture and verification methodology

## Architecture

The initial implementation will contain:

- AES-128 encryption datapath
- AES key expansion
- SubBytes
- ShiftRows
- MixColumns
- AddRoundKey
- Control logic
- Testbench and verification infrastructure

## Toolchain

- SystemVerilog
- Verilator
- Yosys
- Python
- pytest
- Git
- GitHub

## Project Structure

```text
rtl/       SystemVerilog RTL
tb/        Testbenches and test vectors
scripts/   Simulation and synthesis scripts
sim/       Generated simulation files
results/   Synthesis and performance results
docs/      Design documentation# FPGA-Crypt-fpga-crypto-accelerator-
Synthesizable SystemVerilog implementation of AES-128 hardware acceleration with simulation, verification, and synthesis analysis.
