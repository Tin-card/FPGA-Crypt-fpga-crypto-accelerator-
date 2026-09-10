# AES-128 Hardware Architecture

## 1. Overview

The AES-128 accelerator implements the encryption operation of the Advanced Encryption Standard using synthesizable SystemVerilog.

AES-128 operates on:

- 128-bit plaintext blocks
- 128-bit encryption keys
- 10 encryption rounds

The hardware implementation uses an iterative architecture in which the AES round operations are reused across multiple clock cycles.

This approach avoids instantiating a separate complete round datapath for every AES round, reducing hardware duplication while introducing sequential processing latency.

---

Here is the tightened and streamlined version. Every technical detail, ASCII diagram, file reference, equation, and trade-off has been preserved—only redundant prose and excessive vertical spacing have been condensed.

---

## 2. Top-Level Architecture

The design is organized into the following modules:

```text
                     +----------------------+
                     |     aes128_top       |
                     |   Top-Level Wrapper  |
                     +----------+-----------+
                                |
                                v
                     +----------------------+
                     |     aes128_core      |
                     |   Control + State    |
                     +----+------------+----+
                          |            |
              +-----------+            +-----------+
              |                                    |
              v                                    v
      +---------------+                    +---------------+
      | aes_key_expand|                    |   aes_round   |
      |   Key Schedule|                    | Round Transform|
      +-------+-------+                    +-------+-------+
              |                                    |
              +----------------+------------------+
                               |
                               v
                        +-------------+
                        |  aes_sbox   |
                        | Lookup Table |
                        +-------------+

```

---

## 3. RTL Modules

* **`aes128_top.sv`**: Top-level interface mapping external controls to the internal AES core.
* **`aes128_core.sv`**: Core control and datapath logic managing input loading, initial AddRoundKey, round processing, key generation, final-round execution, and completion signaling.
* **`aes_round.sv`**: Implements standard round operations (`SubBytes` $\rightarrow$ `ShiftRows` $\rightarrow$ `MixColumns` $\rightarrow$ `AddRoundKey`) and the final round (omits `MixColumns`).
* **`aes_key_expand.sv`**: Derives round keys from the original 128-bit key.
* **`aes_sbox.sv`**: Lookup table supporting `SubBytes` and key expansion.

---

## 4. AES Encryption Flow

AES-128 consists of an initial AddRoundKey followed by ten sequential rounds:

```text
Plaintext -> [AddRoundKey] -> [Round 1] -> ... -> [Round 9] -> [Final Round (No MixColumns)] -> Ciphertext

```

The iterative hardware architecture executes these rounds sequentially via core control.

---

## 5. AES Round Datapath

### SubBytes

Independent byte substitution across the 128-bit state using 16 parallel S-box operations:


$$\text{128-bit State} \longrightarrow \text{16} \times \text{8-bit S-box} \longrightarrow \text{128-bit State}$$

### ShiftRows

Cyclic row-shifting to provide inter-column diffusion before MixColumns.

### MixColumns

Column transformations using Galois Field $\text{GF}(2^8)$ multiplication:


$$\begin{bmatrix} b_0' \\ b_1' \\ b_2' \\ b_3' \end{bmatrix} = \begin{bmatrix} 02 & 03 & 01 & 01 \\ 01 & 02 & 03 & 01 \\ 01 & 01 & 02 & 03 \\ 03 & 01 & 01 & 02 \end{bmatrix} \begin{bmatrix} b_0 \\ b_1 \\ b_2 \\ b_3 \end{bmatrix}$$

### AddRoundKey

State bits XORed with the active 128-bit round key ($\text{State} \oplus \text{RoundKey}$).

---

## 6. Key Expansion

Derives eleven 128-bit round keys from the primary key using `RotWord`, `SubWord`, round constants, and XOR operations. S-box resources are shared with the round schedule.

---

## 7. Iterative Architecture

To minimize area on FPGAs, the design reuses a single round unit across cycles:

$$\text{AES Round Unit} \longrightarrow \text{State Register} \longrightarrow \text{Next AES Round}$$

* **Trade-off:** Lower gate count vs. multi-cycle block latency (exact latency/$\text{F}_{\text{max}}$ depends on target device synthesis).

---

## 8. Verification Architecture

A SystemVerilog testbench validates the hardware against a Python reference implementation:

$$\text{Python Reference} \longrightarrow \text{Verification File} \longrightarrow \text{SystemVerilog TB} \longrightarrow \text{RTL Execution} \longrightarrow \text{Result Comparison}$$

* Includes **103 test cases** (fixed vectors and deterministic pseudo-random cases via fixed seed).

---

## 9. Synthesis Flow

Synthesized via Yosys using `synthesis/synth.ys`, generating tech-independent reports in `synthesis/reports/synthesis.txt`:

$$\text{SystemVerilog RTL} \longrightarrow \text{Yosys Optimizations} \longrightarrow \text{Generic Netlist / Reports}$$

* *Note:* Results reflect logical gate complexity, not device-specific FPGA utilization (LUTs/FFs).

---

## 10. Design Trade-offs

### Advantages

* Reuses round logic to eliminate 10x hardware unrolling.
* Highly compact structure tailored for resource-constrained FPGAs.
* Straightforward, maintainable control logic.

### Disadvantages

* Requires multi-cycle execution per 128-bit block.
* Critical path bound to single-round logic and S-box lookup timing.
