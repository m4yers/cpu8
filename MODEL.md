# Excution Model
To run a program load a ROM image into the ROM instance at the right side of the
cpu core.
Code starts at 0x00, stack starts at 0xFF and grows towards smaller addresses.
Several instruction require SP register assigned to register Z. If you gonna use
those instruction a small INIT code at the beginning of ROM is required to set
SP to 0xFF.
