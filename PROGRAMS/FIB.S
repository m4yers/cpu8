#------------------------------------------------------------------------------
# FIBONACCI
# 
# Computes fibonacci number, and put the result in register W
#------------------------------------------------------------------------------
INIT:
      MOV  0x00 X      # PARAMETER A
      MOV  0x01 W      # PARAMETER B
      MOV  0x0D Y      # PARAMETER C 13th Fibonacci number
FIB:
      MOV X Z
      ADD W Z
      MOV W X
      MOV Z W
      SUB 0x01 Y
      BNE FIB
FIN:
      MOV X W          # MOVE RESULT TO W
      HCF
