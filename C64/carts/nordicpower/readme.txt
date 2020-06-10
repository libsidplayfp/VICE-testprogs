artest.crt  (for Action Replay)
nptest.crt  (for Nordic Power)
rrtest.crt, rr2test.crt  (for Retro Replay)
nrtest.crt, nr2test.crt  (for Nordic Replay)
----------

This test checks the general mapping features of the special "Nordic Power" mode 
which is present in Atomic Power and Nordic Power cartridges ($de00=$22). For
the test to work it is assumed other mapping modes ($20 and $00 in particular)
work correctly.

top half on screen shows what was read back in mode $00:

- first block on screen shows what is mapped at $8000 (ROML)
- second block shows what is mapped at $A000 (ROMH)
- third and forth block are IO1 and IO2

bottom half shows the same for "Nordic Power" mode

- first block should show cartridge ROM, 
- the second cartridge RAM (in ultimax mode, writes do not go to the C64 RAM!). 
- additionally IO2 is from the cartridge RAM.

--------------------------------------------------------------------------------  

arramwrite.crt  (for Action Replay)  DON'T USE ON REAL HARDWARE!
npramwrite.crt  (for Nordic Power)
rrramwrite.crt rr2ramwrite.crt  (for Retro Replay)
nrramwrite.crt nr2ramwrite.crt  (for Nordic Replay)

arramwrite.prg  (for Action Replay)  DON'T USE ON REAL HARDWARE!
npramwrite.prg  (for Nordic Power)
rrramwrite.prg rr2ramwrite.prg  (for Retro Replay)
nrramwrite.prg nr2ramwrite.prg  (for Nordic Replay)

safearramwrite.prg (for Action Replay) This is safe to use on real hardware!
------------------

This tests if writes to ROML and ROMH area behave as expected in mode 22:

- writes to ROML ($8000) should go to C64 RAM
- writes to ROMH ($A000) should NOT go to C64 RAM (but cartridge RAM)

red border indicates failure, green border indicates success

--------------------------------------------------------------------------------
This is how mode 0x22 actually behaves on various tested hardware:


                    read                            write
Action Replay:

    8000            C64RAM + Cart RAM (*)           C64RAM + Cart RAM
    A000            - (BASIC ROM)                   -
    DE00            n/a (writes Cart Register)      Cart Register
    DF00            Cart RAM                        Cart RAM

Nordic Power:

    8000            Cart ROM                        - (C64RAM)
    A000            Cart RAM                        Cart RAM
    DE00            n/a (writes Cart Register)      Cart Register
    DF00            Cart RAM                        Cart RAM

Retro Replay:

    8000            - (C64RAM)                      - (C64RAM)
    A000            - (BASIC ROM)                   - (C64RAM)
    DE00            Cart RAM + Cart Register        Cart RAM + Cart Register
    DF00            - (open I/O)                    - (open I/O)

Retro Replay (with REU compatible mapping):
    
    8000            - (C64RAM)                      - (C64RAM)
    A000            - (BASIC ROM)                   - (C64RAM)
    DE00            Cart Register                   Cart Register
    DF00            Cart RAM                        Cart RAM            
    
MMC Replay:

    8000            Cart ROM                        - (Cart RAM maybe)
    A000            Cart RAM                        C64RAM + Cart RAM
    DE00            Cart Register                   Cart Register           
    DF00            Cart ROM                        - (Cart RAM maybe)

Nordic Replay (same as Nordic Power, except reads from IO1):

    8000            Cart ROM                        - (C64RAM)
    A000            Cart RAM                        Cart RAM
    DE00            Cart Register                   Cart Register
    DF00            Cart RAM                        Cart RAM

Nordic Replay (with REU compatible mapping):

    8000            Cart ROM                        - (C64RAM)
    A000            Cart RAM                        Cart RAM
    DE00            Cart RAM + Cart Register        Cart RAM + Cart Register
    DF00            - (open I/O)                    - (open I/O)

Easyflash (CPLD Core v1.1.1)   

    8000            Cart ROM                        - (C64RAM)
    A000            Cart RAM                        C64RAM + Cart RAM
    DE00            - (open I/O)                    Cart Register
    DF00            Cart RAM                        Cart RAM

(*) This causes bus contention and should not be used, as it potentially
    damages the hardware. The data read will likely be broken, unless the
    cartridge RAM and C64 RAM contain the exact same data.
    
-------------------------------------------------------------------------------
A000-write bug (write goes to C64 RAM) confirmed (20200520):

- VICE 3.4
- Easyflash 3 (CPLD Core Version 1.1.1)
- MMC Replay
- Turbo Chameleon (Firmware Beta-9i, 20190419)

A000 writing confirmed working correctly:

- real Nordic Power
- VICE r37870
- Nordic Replay
