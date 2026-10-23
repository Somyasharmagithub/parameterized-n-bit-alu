# Design and Simulation of a Parameterized N-Bit ALU Using Carry Look-Ahead Adder

## About the Project

This project focuses on designing and simulating adders and an Arithmetic Logic Unit (ALU) using Verilog/SystemVerilog. I started with an 8-bit Ripple Carry Adder and gradually moved to wider adders, Carry Look-Ahead Adders (CLA), a 32-bit ALU, and finally a parameterized N-bit ALU.

The main goal was to understand how carry propagation works in different adder architectures and how a CLA can be used to build an ALU that supports both arithmetic and logical operations.

All designs were simulated using EDA Playground.

## Project Progression

- 8-bit Ripple Carry Adder
- 16-bit Ripple Carry Adder
- 32-bit Ripple Carry Adder
- 8-bit Carry Look-Ahead Adder
- 16-bit Carry Look-Ahead Adder
- 32-bit Carry Look-Ahead Adder using 8-bit CLA blocks
- 32-bit ALU using CLA
- Parameterized N-bit ALU using CLA

## ALU Operations

The ALU uses a 3-bit select input (`sel`) to choose between eight operations.

| `sel` | Operation | Description |
|---|---|---|
| `000` | ADD | Adds A and B |
| `001` | SUB | Subtracts B from A |
| `010` | AND | Bitwise AND |
| `011` | OR | Bitwise OR |
| `100` | XOR | Bitwise XOR |
| `101` | NOT | Bitwise complement of A |
| `110` | INC | Increments A by 1 |
| `111` | DEC | Decrements A by 1 |

## Design Approach

The Ripple Carry Adder passes the carry from one bit to the next. It is simple to implement, but the carry may need to propagate through the entire adder.

The Carry Look-Ahead Adder uses generate and propagate signals to calculate carries more efficiently. In the 32-bit CLA design, four 8-bit CLA blocks are connected together.

The final design uses a parameterized CLA and ALU, allowing the data width to be changed through a parameter instead of rewriting the design for every width.

## Output Flags

The ALU produces three flags along with the result:

- **Z — Zero flag:** Set when the result is zero.
- **C — Carry/Borrow flag:** Indicates carry-out for addition and borrow for subtraction.
- **V — Overflow flag:** Indicates signed arithmetic overflow.

The meaning of the carry flag depends on the operation being performed.

## Simulation and Testing

Each design has a corresponding testbench. The testbenches are used to apply input values and check the outputs of the designs.

The simulations cover arithmetic operations, logical operations, and selected boundary cases such as overflow, zero results, and carry or borrow conditions.

The project was developed and simulated using EDA Playground with SystemVerilog.

## Tools Used

- Verilog/SystemVerilog
- EDA Playground
- Icarus Verilog
- GitHub

## Repository Structure

The repository contains the design and testbench files for the different stages of development, from the basic Ripple Carry Adder to the final parameterized ALU.

## What I Learned

- Implementing adders at different bit widths
- Understanding Ripple Carry and Carry Look-Ahead architectures
- Using generate blocks and module instantiation
- Designing an ALU with arithmetic and logical operations
- Writing testbenches and checking simulation outputs
- Using parameters to make hardware designs reusable

---

*This project was developed as a learning exercise in digital design, arithmetic circuits, and Verilog/SystemVerilog simulation.*
