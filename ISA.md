# Instruction Set Architecture

## Format
CPU8 assembly language uses 2-operand format, *SRC* defined first, *DST* second:
```
INSTRUCTION SRC DST
```

## Flags
There are 4 basic status flags:
 - __N - Negative__, set if the most significant bit of the result is set;
   otherwise clear.
 - __Z - Zero__, set if the result equals zero; otherwise clear.
 - __V - Overflow__, set if an arithmetic overflow occurs implying that the
   result cannot be represented in the operand size; otherwise clear.
 - __C - Carry__, set if a carry out of the most significant bit of the operand
   occurs for an addition, or if a borrow occurs in a subtraction; otherwise
   clear.

## Instructions

### Integer Arithmetic
```assembly
INC W        # Increment W by 1
ADD W        # Double value in register W and store it back to W
ADD Y        # Add W to Y and store back to Y
SUB 0x01 W   # Subtract 1 from W
```

#### Encoding
```
----------------------------------------------------
 7  6 | 5 | 4  3  2 | 1  0 | F  E  D  C  B  A  9  8
----------------------------------------------------
 DST  | I |   OPC   | 0  0 |    IMMEDIATE IF ANY
----------------------------------------------------
```
- OPC defines ALU operation, possible values are:
  - 000: INC
  - 001: ADD
  - 010: SUB
  - 011: NOT
  - 100: OR
  - 101: AND
  - 110: LSR
  - 111: LSL

- I defines SRC operand:
  - 0: SRC is register W
  - 1: SRC is an immediate value defined by bits F:8

- DST defines destination register: W, X, Y or Z

#### Flags
| OPC | N | Z | V | C |
|-----|---|---|---|---|
| INC | * | * | * | * |
| ADD | * | * | * | * |
| SUB | * | * | * | * |
| NOT | * | * | 0 | 0 |
| OR  | * | * | 0 | 0 |
| AND | * | * | 0 | 0 |
| LSR | * | * | 0 | * |
| LSL | * | * | 0 | * |

- `*`: Flag defined by operation
- `0`: Flag cleared

### Data

### Control

### System
