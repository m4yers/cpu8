# TIMINGS

Single byte instruction that do not touch memory execute in 1 cycle(well, arith
technically does it in 2, but can be redone in 1). Instructions that read memory
execute in 2 cycles. Instructions that do memory write execute in 2-4 cycles
depending on complexity of actions.
