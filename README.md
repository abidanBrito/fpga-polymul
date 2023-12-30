# Cryptography on Hardware Platforms - Polynomial Multiplier

### Summary

We implemented a polynomial multiplier (R_p = Z_p/<x^256 + 1> with p = 18434813901432784897) for the Xilinx Pynq-z2 FPGA board, following a hardware/software codesign. We used multiple optimization techniques to increase speed and reduce the area of our design. In cases where these goals contradicted each other, we prioritized speed over area.

### Design Choices and Strategy

Since we were aiming for maximum speed, we chose to implement the n-point NTT, as it requires the least amount of multiplications.

### Optimizations Techniques

#### Task 1: Modular Multiplication

As we aimed for maximum speed, we decided that using Xilinx multiplier IP is a good choice. Those modules have a configurable amount of pipelining stages, spreading the computations evenly across stages for maximum performance. Our design has the following components:

- 1x 64-bit multiplier (6 pipelining stages).
- 2x 64-bit constant multipliers for mu (3 pipelining stages).
  **NOTE**: we shifted one of the values to fit into the 64-bit constraint.
- 1x 64-bit constant multiplier for q (3 pipelining stages).
- Final reduction by subtracting q (1 pipelining stage).

#### Task 2: Polynomial Multiplication

We based our considerations around the decision to use only one pipelined modular multiplier. This allows one pair of 64-bit values to be processed each cycle. Given that the framework provides memory read and write of only one 64-bit value per cycle, this is an obvious bottleneck that we wanted to mitigate, allowing a 2x speedup. To do so, we split up the BRAM into two slices, each containing all even and odd addresses respectively. We modified the algorithm to always perform the load operations of two consecutive butterfly operations in paralell. Extra pipelining stages are needed to reorder values before and after the butterfly operations. We later discovered that our timing optimizations are very similar to Sinha Roy et al. 2014 [1], with the difference that we do not perform in-memory reordering. This has the drawback that a special case is needed in the last iteration of the algorithm (or first, in case of inverse-NTT), where no reordering is performed, requiring slightly more area than [1].

Another optimization was that we did not instantiate a private BRAM, instead reusing the one in the CryptoCore in order to save area. This required modifying the instruction setup, where we split up the polynomial multiplication into three separate instructions: NTT, point-wise multiplication, and inverse-NTT. To perform polynomial multiplication of `opA` and `opB`, writing the result to `res`, a sequence of instructions needs to be executed:

- NTT `opA`, `opA`, `opA`
- NTT `opB`, `opB`, `opB`
- point-wise multiply `opA`, `opB`, `res`
- inverse-NTT `res`, `res`, `res`
- point-wise multiply `res`, `n_inv`, `res` (Here `n_inv` is a "polynomial" containing the inverse of n 256 times. This should have been integrated into inverse-NTT, but we had issues with that)

The input and output operands of NTT/inverse-NTT are required to be identical, as they perform operations in-place. This split-instruction setup has the benefit that in order to perform multiple polynomial multiplications with the same polynomial, NTT only needs to be performed once.

We did not implement back-to-back execution, meaning that we need to drain our pipeline after each of those instructions.

### Implementation Results

Resources used:

- LUTs:  4,825
- FFs:   5,096
- DSPs:  16
- BRAMs: 3
- Area metric (#Area = 1\*LUT + 1\*FF + 100\*DSP + 1000\*BRAM): 14,521

Speed (average over 1000 random tests):

- Data transfer ARM -> FPGA: 9010 (for data) + 211 (for instructions) CPU clock cycles 
- Computation: 3746.7 FPGA cycles (= 18733.5 CPU clock cycles)
- Data transfer FPGA -> ARM: 2284 CPU clock cycles

### References
[1]: S. Sinha Roy, F. Vercauteren, N. Mentens, D. Donglong Chen, I. Verbauwhede: Compact Ring-LWE
Cryptoprocessor. CHES 2014.

<!--
```py
LUT =  4825
FF =   5096
DSP =  16
BRAM = 3
print(1*LUT + 1*FF + 100*DSP + 1000*BRAM)
```
-->
