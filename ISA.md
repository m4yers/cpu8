# Instruction Set Architecture
* [Registers](#registers)
* [Stack](#stack)
* [Code](#code)
* [Flags](#flags)
* [Instructions](#instructions)
  * [Language](#language)
  * [ARITH](#arith)
  * [MOV](#mov)
  * [PUSH](#push)
  * [POP](#pop)
  * [BRA](#bra)
  * [Bcc](#bcc)
  * [CMP](#cmp)
  * [JMP](#jmp)
  * [JSR](#jsr)
  * [RSR](#rsr)
  * [HCF](#hcf)
  * [ABF](#abf)

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


### Language
CPU8 assembly language uses 2-operand format, *SRC* defined first, *DST* second:
```
INSTRUCTION SRC DST
```


### ARITH

#### Instruction Format
```
------+---+---------+------+------------------------
 7  6 | 5 | 4  3  2 | 1  0 | F  E  D  C  B  A  9  8
------+---+---------+------+------------------------
 DST  | I |   OPC   | 0  0 |    IMMEDIATE IF ANY
------+---+---------+------+------------------------
```
- OPC defines ALU operation, possible values are:
  - __000__: INC
  - __001__: ADD
  - __010__: SUB
  - __011__: NOT
  - __100__: OR
  - __101__: AND
  - __110__: LSR
  - __111__: LSL

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
0x00      INC W        ; Increment W by 1
0x04      ADD W        ; Double value in register W and store it back to W
0x84      ADD Y        ; Add W to Y and store back to Y
0x6801    SUB 0x01 X   ; Subtract 1 from W
```


### MOV
#### Instruction Format
```
------+------+------+------+------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
------+------+------+------+------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
------+------+------+------+------------------------
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
0x3DFF    MOV 0xFF Z  ; Move 0xFF to register Z
0x4508    MOV [08] W  ; Move value at address [08] to register W
0x19FF    MOV W [FF]  ; Move value from register W to address [FF]
0x21      MOV W Y     ; Move value in register W to register Y
```


### PUSH
Push instruction decrements SP and stores a value into an available slot.

#### Instruction Format
```
------+------+------+------+------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
------+------+------+------+------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
------+------+------+------+------------------------
```

##### FORM
 - 10: __R__ - Push register to stack, *SRC* encodes a register to store, *DST*
   is all ones.
 - 11: __I__ - Push immediate value to stack, *SRC* is __01__ and *DST* is all
   ones.

#### Examples
```assembly
0x7DAF    PUSH 0xAF ; Push value 0xAF to stack
0x39      PUSH W    ; Push value in register W to stack
```


### POP
Pop reads a value from stack and increments SP.

#### Instruction Format
```
------+------+------+------+------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
------+------+------+------+------------------------
  SRC | DST  | FORM | 0  1 |    IMMEDIATE IF ANY
------+------+------+------+------------------------
```

##### FORM
 - 01: __R__ - Pop value from stack and store it into a register, *SRC* is all
   ones, *DST* encodes a register to store the poped value.
 - 11: __X__ - Pop value from stack and store it nowhere, *SRC* is __10__, *DST*
   is all ones.

#### Examples
```assembly
0xF5    POP Z  ; Pop value from stack and store it into register Z
0xBD    POP    ; Pop value from stack and drop it.
```


### BRA
Unconditional PC-relative branch, PC points to the second byte(extension).

#### Instruction Format
```
------------------------+------------------------
 7  6  5  4  3  2  1  0 | F  E  D  C  B  A  9  8
------------------------+------------------------
 0  0  0  0  0  0  1  0 |         OFFSET
------------------------+------------------------
```

#### Examples
```assembly
0x0201    BRA 0x06  ; Branch to the next instruction
0x02F6    BRA 0xF6  ; Branch back 10 bytes
```


### Bcc
Conditional PC-relative branch, PC points to the second byte(extension). CC part
of the instruction mnemonic is replaced with an appropriate condition code suffix.
These instructions go in pair with CMP instruction.

#### Instruction Format
```
------------+------------+------------------------
 7  6  5  4 | 3  2  1  0 | F  E  D  C  B  A  9  8
------------+------------+------------------------
  CONDITION | 0  0  1  0 |         OFFSET
------------+------------+------------------------
```

##### CONDITION
There are 14 condition codes that decide whether the branch to occur:
| Signed    |  CC      | Mnemonic | Condition            | Test                                   |
|-----------|----------|----------|----------------------|----------------------------------------|
| unsigned  | __0010__ | HI       |  High                | !C and !Z                              |
| unsigned  | __0011__ | LS       |  Low or Same         |  C or Z                                |
| unsigned  | __0100__ | CC(HI)   |  Carry Clear         | !C                                     |
| unsigned  | __0101__ | CS(LO)   |  Carry Set           |  C                                     |
|           | __0110__ | NE       |  Not Equal           | !Z                                     |
|           | __0111__ | EQ       |  Equal               |  Z                                     |
|           | __1000__ | VC       |  Overflow Clear      | !V                                     |
|           | __1001__ | VS       |  Overflow Set        |  V                                     |
|           | __1010__ | PL       |  Plus                | !N                                     |
|           | __1011__ | MI       |  Minus               |  N                                     |
| signed    | __1100__ | GE       |  Greater or Equal    | (N and V) or (!N and !V)               |
| signed    | __1101__ | LT       |  Less Than           | (N and !V) or (!N and V)               |
| signed    | __1110__ | GT       |  Greater Than        | (N and V and !Z) or (!N and !V and !Z) |
| signed    | __1111__ | LE       |  Less or Equal       | (N and !V) or (!N and V) or Z          |

#### Examples
```assembly
0x3210    BLS 0x10  ; Branch back 16 bytes if C or Z flags is set
0x6204    BNE 0x04  ; Branch forward 4 bytes if previous operation clear Z flag
```


### CMP
Compare instruction does the same job as subtraction arithmetic operation, by
subtracting *SRC* from *DST* but does not store the result into *DST*. It just
sets the condition flags. This instruction usually goes in pair with Bcc.

#### Instruction Format
```
------+------+------+------+------------------------
 7  6 | 5  4 | 3  2 | 1  0 | F  E  D  C  B  A  9  8
------+------+------+------+------------------------
  SRC | DST  | FORM | 1  1 |    IMMEDIATE IF ANY
------+------+------+------+------------------------
```

##### FORM
 - __00__: RR - both *DST* and *SRC* are register, no extension byte
 - __01__: AM - enables extension byte, *DST* is still a register, *SRC*
   specifies meaning of the extension byte:
   - __00__: __UNDEFINED__
   - __01__: __UNDEFINED__
   - __10__: __UNDEFINED__
   - __11__: Extension byte defines immediate value.

#### Examples
```assembly
0xD700    CMP  0x00 X  ; Subtract 0x00 from X and set the condition flags
0x13      CMP  W X     ; Subtract W from X and set the condition flags
```


### JMP
Unconditional jump to an absolute address.

#### Instruction Format
```
------------------------+------------------------
 7  6  5  4  3  2  1  0 | F  E  D  C  B  A  9  8
------------------------+------------------------
 0  0  0  0  1  0  1  0 |        ADDRESS
------------------------+------------------------
```

#### Examples
```assembly
0x0A10    JMP 0x10  ; Jump to address 0x10
```


### JSR
Jump to subroutine pushes address of the next instruction to stack and jumps to
provided absolute address. This instruction assumes the PC defined as register Z.

#### Instruction Format
```
------------------------+------------------------
 7  6  5  4  3  2  1  0 | F  E  D  C  B  A  9  8
------------------------+------------------------
 0  0  0  0  1  1  1  0 |        ADDRESS
------------------------+------------------------
```

#### Examples
```assembly
0x0E10    JSR 0x10  ; Push next address and jump to 0x10.
```


### RSR
Return from subroutine pops a return address from the stack and jumps there.

#### Instruction Format
```
------------------------
 7  6  5  4  3  2  1  0 
------------------------
 0  0  0  1  1  1  1  0 
------------------------
```

#### Examples
```assembly
0x1E    RSR   ; Return from subroutine
```

### HCF
Halt instruction, halts the machine

#### Instruction Format
```
------------------------
 7  6  5  4  3  2  1  0 
------------------------
 1  1  0  0  1  1  1  1 
------------------------
```

#### Examples
```assembly
0xCF    HCF   ; Halt and Catch Fire
```

### ABF
Address bus failure, envoked by the "memory controller" whenever system tries
to access non-existing address.

#### Instruction Format
```
------------------------
 7  6  5  4  3  2  1  0 
------------------------
 1  0  1  0  1  1  1  1 
------------------------
```
