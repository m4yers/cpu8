# Control Bus
This section describes control bus pins that are used to drive the cpu. It is
presented as 0/1 switch describing action on 0 signal and then action on 1
signal.

## Memory
Memory occupies bits [6:0]:
 - bit 0: Memory on/off
 - bit 1: Write/read to/from memory
 - bit 2: Program counter auto-increment off/on
 - bit 3: Update pc from the data bus off/on
 - bit 4: Fetch current data byte into F register off/on
 - bit 5: Fetch current dsta byte into A register off/on
 - bit 6: Switch between Counter and A register to drive the Memory

## ALU
These drive Arithmetic Logic Unit execution, and occupy bits [21:7]:
 - bits [9:7]: Select ALU output target. Possible values are:
   - 0: register R
   - 1: DATA Bus
   - 2: register P
   - 3: registers Z and A
   - 4: register W
   - 5: register X
   - 6: register Y
   - 7: register Z
 - bit 10: Disallow/Allow S register update
 - bit 11: Disallow/Allow R register read
 - bit 12: ALU off/on
 - bits [18:13]: ALU A/B data path codes. These define what goes into ALU and
   each takes 3 bits. Possible values are:
   - Values 0-3 select register W,X,Y or Z. These are available to ALU outside
     the main Data Bus.
   - Value 4 selects Data Bus
 - bits [21:19]: ALU instruction code. Possible values are:
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
to DB. These occupy pins [25:22]:
 - bit 22: Read/Write from/to the Data Bus
 - bit 23: Clock the selected registers off/on
 - bits [25:24] select current register:
   - 0: W
   - 1: X
   - 2: Y
   - 3: Z

## System
The system represent pins vital to cpu execution:
 - bit 26: Reset
 - bit 27: Clock
 - bit 28: Halt
 - bits [36:29]: Data Bus
 - bits [44:37]: Fetch Bus
 - bit 45: Ground
 - bit 46: Power
 - bit 47: Busy Toggle
 - bit 48: Busy
