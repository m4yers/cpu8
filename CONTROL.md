# Control Bus
This section describes control bus pins that are used to drive the cpu. It is
presented as 0/1 switch describing action on 0 signal and then action on 1
signal.

## Memory
Memory occupies bits [3:0]:
 - bit 0: Memory on/off
 - bit 1: Write/read to/from memory
 - bit 2: Program counter auto-increment off/on
 - bit 3: Update pc from the data bus off/on
 - bit 4: Fetch current data byte into F register

## ALU
These drive Arithmetic Logic Unit execution, and occupy bits [13:4]:
 - bit 5: R register write/read from/to D-Bus
 - bit 6: ALU off/on
 - bits [12:7]: ALU A/B data path codes. These define what goes into ALU and
   each takes 3 bits. Possible values are:
   - Values 0-3 select register W,X,Y or Z. These are available to ALU outside
     the main Data Bus.
   - Value 4 selects Data Bus
 - bits [15:13]: ALU instruction code. Possible values are:
   - 0: INC
   - 1: ADD
   - 2: SUB
   - 3: NOT
   - 4: OR
   - 5: AND
   - 6: LSR
   - 7: LSL

## Registers
Registers pins allow to update registers from the Data Bus or to write registers
to DB. These occupy pins [17:14]:
 - bit 16: Read/Write from/to the Data Bus
 - bit 17: Clock the selected registers off/on
 - bits [19:18] select current register:
   - 0: W
   - 1: X
   - 2: Y
   - 3: Z

## System
The system registers represent pins vital to cpu execution:
 - 20: RESET
 - 21: CLOCK
 - 22: HCF
 - 23: GROUND
 - 24: POWER
