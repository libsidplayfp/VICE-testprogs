
related to https://sourceforge.net/p/vice-emu/bugs/1665/

This program checks if the implementation of Final Expansion 3 RAM/ROM mode
matches real hardware. From experimentation this mode behaves as follows:

- writes always go to RAM. If the low order bit in $9c02 for a block is clear
  the write goes to bank 1 otherwise to bank 2
- reads come from RAM bank 1 if the low order bit is clear otherwise from flash
  bank 0

fetest.prg:

- writes '1' to the start of BLK5 in RAM bank 1
- writes '2' to the start of BLK5 in RAM bank 2
- In RAM/ROM mode with the low order bit of bank 5 clear writes to $a001
- In RAM/ROM mode with the low order bit of bank 5 set writes to $a000
- In RAM/ROM mode with the low order bit of bank 5 set reads $a000
- In RAM/ROM mode with the low order bit of bank 5 clear reads $a000
- Displays the start of BLK5 in RAM bank 2
- then checks the results

Press F8 in the FE3 Menu, then run the program
