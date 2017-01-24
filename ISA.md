# Instruction Set Architecture

## Registers
There are 4 general purpose 8 bit registers available: __W, X, Y and Z__, and
two system registers: __S__ - status register and __P__ - program counter.

## Stack
Stack in CPU8 grows towards lower addresses. Register Z acts as Stack Pointer
if you use appropriate instructions.

## Code

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
CPU8 instruction  is 8 bit long plus, if required by instruction optional
immediate or address extension byte.

### Format
CPU8 assembly language uses 2-operand format, *SRC* defined first, *DST* second:
```
INSTRUCTION SRC DST
```

### ARITH

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
  - 1: SRC is an immediate value defined by bits [F:8]

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

#### Examples
```assembly
0x00      INC W        # Increment W by 1
0x04      ADD W        # Double value in register W and store it back to W
0x84      ADD Y        # Add W to Y and store back to Y
0x6801    SUB 0x01 X   # Subtract 1 from W
```

### MOV
#### Encoding
```
----------------------------------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
----------------------------------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
----------------------------------------------------
```
##### FORM
Form defines move direction and data location:
 - 00: __RR__ - Register to Register move, both *SRC* and *DST* encode register
 - 01: __RM__ - Memory to Register move, *SRC* encodes AM, *DST* encodes a
   register
 - 10: __MR__ - Register to Memory move, *SRC* encodes a source register, *DST*
   encodes AM
 - 11: __RI__ - Immediate to Register move, *SRC* is all zeros, *DST* encodes a
   destination register

##### Address Modes
There are 4 address modes:
 - [TODO] 00: Address in register
 - 01: Absolute address in immediate byte extension
 - [TODO] 10: SP relative address in immediate byte extension

#### Examples
```assembly
0x3DFF    MOV 0xFF Z  # Move 0xFF to register Z
0x4508    MOV [08] W  # Move value at address [08] to register W
0x19FF    MOV W [FF]  # Move value from register W to address [FF]
0x21      MOV W Y     # Move value in register W to register Y
```

### PUSH
Push instruction decrements SP and stores a value into an available slot.

#### Encoding
```
----------------------------------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
----------------------------------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
----------------------------------------------------
```

#### FORM
 - 10: __R__ - Push register to stack, *SRC* encodes a register to store, *DST*
   is all ones.
 - 11: __I__ - Push immediate value to stack, *SRC* is __01__ and *DST* is all
   ones.

#### Examples
```assembly
0x7DAF    PUSH 0xAF # Push value 0xAF to stack
0x39      PUSH W    # Push value in register W to stack
```

### POP
Pop reads a value from stack and increments SP.

#### Encoding
```
----------------------------------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
----------------------------------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
----------------------------------------------------
```

#### FORM
 - 01: __R__ - Pop value from stack and store it into a register, *SRC* is all
   ones, *DST* encodes a register to store the poped value.
 - 11: __X__ - Pop value from stack and store it nowhere, *SRC* is __10__, *DST*
   is all ones.

#### Examples
```assembly
0xF5    POP Z  # Pop value from stack and store it into register Z
0xBD    POP    # Pop value from stack and drop it.
```

### Control

### System
