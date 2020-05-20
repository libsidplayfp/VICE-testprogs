nptest.crt
rrtest.crt
----------

This test checks/demonstrates the special "Nordic Power" mode which is present
in Atomic Power and Nordic Power cartridges ($de00=$22).

first page on screen shows what is mapped at $8000 (ROML)
second page shows what is mapped at $A000 (ROMH)
third and forth page are IO1 and IO2

when "Nordic Power" mode is active (space pressed) the first page should show 
cartridge ROM, the second cartridge RAM (in ultimax mode, writes do not go to
the C64 RAM!). additionally IO2 is from the cartridge RAM.

npramwrite.crt:
nrramwrite.crt:
ramwrite.prg:
---------------

This tests if writes to ROML and ROMH area behave as expected in mode 22:

- writes to ROML ($8000) should go to C64 RAM
- writes to ROMH ($A000) should NOT go to C64 RAM (but cartridge RAM)

red border indicates failure, green border indicates success

-------------------------------------------------------------------------------
A000-write bug (write goes to C64 RAM) confirmed (20200520):

- VICE 3.4
- Easyflash 3 (CPLD Core Version 1.1.1)
- MMC Replay
- Turbo Chameleon (Firmware Beta-9i, 20190419)

A000 writing confirmed working correctly:

- VICE r37870
- Nordic Replay
