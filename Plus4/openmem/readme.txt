related to https://sourceforge.net/p/vice-emu/bugs/1896/

When setting TED to display a bitmap from an address in the $0000-$7FFF range,
but bit 2 of register $FF12 is set to 1 (fetch bitmap and char data from ROM),
a Plus4 displays the last value left in the data bus.


ted_openspace.prg:

Displays a couple of bitmaps in different memory configurations:

Use the C= key to toggle between a bitmap at $2000, below the ROM range, and
another at $A000

The CTRL key toggles the mapping of ROM for CPU and TED attribute/video matrix
in the $8000-$FFFF range

RUN/STOP toggles bit 2 of $FF12

r45284: xplus4 displays the data present in RAM instead of the last value left in the data bus.


plus4_left_emu_right.jpg:

Shows the difference between a real Plus4 on the left and xplus4 on the right.
The 3rd and 4th row show the incorrect behaviour of xplus4, the actual pattern
being displayed depends on the code being executed.

