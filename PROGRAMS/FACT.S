#------------------------------------------------------------------------------
# COMPUTE FACTORIAL
# 
# Parameter is passed in register W, the maximum value is 5 because 6! will
# overflow a 8 bit register. The translated machine code is in the FACT.HEX file.
# Expect result 0x78 in register W.
#------------------------------------------------------------------------------
INIT:
      MOV  0xFF Z      # INIT STACK
      MOV  0x05 W      # PARAMETER
      JSR  FACT        # COMPUTE
      HCF              # HALT
FACT:
      CMP  0x00 W      # CHECK IF WE HAVE 0
      BNE  COMP        # IF NOT PROCEED TO COMPUTE
      MOV  0x01 W      # OTHERWISE PUT 1 TO RESULT REGISTER
      RSR              # AND RETURN
COMP:
      SUB  0x01 W      # SUBTRACT ONE FROM PARAMETER
      PUSH W           # SAVE COUNTER UNTO STACK
      JSR  FACT        # RECURSIVELY CALL FACT
      MOV  W Y         # MOVE RESULT OF THE RECURSIVE CALL
      POP  X           # RESTORE COUNTER FROM STACK
CHECK:
      CMP  0x00 X      # CHECK IF WE NEED TO MULTIPLY
      BNE  MULT        # IF SO PROCEED
      MOV  Y W         # PUT RESULT INTO RESULT REG
      RSR              # OTHERWISE WE ARE DONE
MULT:
      ADDW Y           # ADD A PART
      SUB  0x01 X      # DECREMENT COUNTER
      BRA  CHECK       # CHECK AGAIN
