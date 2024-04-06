
ultimax-rr.bin
ultimax-ef.bin

This test shows the memory mapping the CPU cycle.

It shows 16 lines, with each line mapped to a different vram:

..-zp-..........    page 00
................    page 10
................    page 20
................    page 30
................    page 40
................    page 50
................    page 60
................    page 70
................    page 80
................    page 90
................    page a0
................    page b0
................    page c0
................    page d0
....CBM80-E000-.    page e0
-F000-..........    page f0


-------------------------------------------------------------------------------


8k-vic-rr.bin
16k-vic-rr.bin
ultimax-vic-rr.bin

8k-vic-ef.bin
16k-vic-ef.bin
ultimax-vic-ef.bin

These tests show the memory mapping in the VICII cycle, ie what the VIC "sees".

Keys:

    arrow left:     ultimax
             1:     8k GAME
             2:     16k GAME

Note: the 3 programs are the same program, which only starts with a different
      default config (for automatic testing)

-------------------------------------------------------------------------------
Results
-------------------------------------------------------------------------------

Easyflash
---------

        ultimax-ef (CPU)                  ultimax-vic-ef (VIC)

                                          ultimax     8k          16k
0000    RAM@0000                          RAM@0000    RAM@0000    RAM@0000
1000    n/a                               RAM@1000    chargen     chargen
2000    n/a                               RAM@2000    RAM@2000    RAM@2000
3000    n/a                               cart ROM    RAM@3000    RAM@3000
4000    n/a                               RAM@4000    RAM@4000    RAM@4000
5000    n/a                               RAM@5000    RAM@5000    RAM@5000
6000    n/a                               RAM@6000    RAM@6000    RAM@6000
7000    n/a                               cart ROM    RAM@7000    RAM@7000
8000    cart ROM                          RAM@8000    RAM@8000    RAM@8000
9000    cart ROM                          RAM@9000    chargen     chargen
A000    n/a                               RAM@A000    RAM@a000    RAM@a000
B000    n/a                               cart ROM    RAM@b000    RAM@b000
C000    n/a                               RAM@C000    RAM@c000    RAM@c000
D000    I/O                               RAM@D000    RAM@d000    RAM@d000
E000    cart ROM                          RAM@E000    RAM@e000    RAM@e000
F000    cart ROM                          cart ROM    RAM@f000    RAM@f000


Retro Replay
------------

        ultimax-rr (CPU)                  ultimax-vic-rr (VIC)
        (normal)        (Freeze Mode)     (no difference between freeze/normal)
                                          ultimax     8k          16k
0000    RAM@0000        RAM@0000          RAM@0000    RAM@0000    RAM@0000
1000    n/a             n/a               chargen     chargen     chargen
2000    n/a             n/a               RAM@2000    RAM@2000    RAM@2000
3000    n/a             n/a               RAM@3000    RAM@3000    RAM@3000
4000    n/a             n/a               RAM@4000    RAM@4000    RAM@4000
5000    n/a             n/a               RAM@5000    RAM@5000    RAM@5000
6000    n/a             n/a               RAM@6000    RAM@6000    RAM@6000
7000    n/a             n/a               RAM@7000    RAM@7000    RAM@7000
8000    cart ROM bank0  n/a               RAM@8000    RAM@8000    RAM@8000
9000    cart ROM bank0  n/a               chargen     chargen     chargen
A000    n/a             n/a               RAM@A000    RAM@a000    RAM@a000
B000    n/a             n/a               RAM@B000    RAM@b000    RAM@b000
C000    n/a             n/a               RAM@C000    RAM@c000    RAM@c000
D000    I/O             I/O               RAM@D000    RAM@d000    RAM@d000
E000    cart ROM bank0  cart ROM bank0    RAM@E000    RAM@e000    RAM@e000
F000    cart ROM bank0  cart ROM bank0    RAM@F000    RAM@f000    RAM@f000

There appears to be a different variant (this comes from a strange RR with the
CPLD in a socket, could be a WIP thing):

        ultimax-rr (CPU)                  ultimax-vic-rr (VIC)
        (normal)        (Freeze Mode)     (no difference between freeze/normal)
                                          ultimax     8k          16k
0000    RAM@0000        RAM@0000          RAM@0000    RAM@0000    RAM@0000
1000    n/a             n/a               RAM@1000    RAM@1000    chargen
2000    n/a             n/a               RAM@2000    RAM@2000    RAM@2000
3000    n/a             n/a               n/a         n/a         RAM@3000
4000    n/a             n/a               RAM@4000    RAM@4000    RAM@4000
5000    n/a             n/a               RAM@5000    RAM@5000    RAM@5000
6000    n/a             n/a               RAM@6000    RAM@6000    RAM@6000
7000    n/a             n/a               n/a         n/a         RAM@7000
8000    cart ROM bank0  n/a               RAM@8000    RAM@8000    RAM@8000
9000    cart ROM bank0  n/a               RAM@9000    RAM@9000    chargen
A000    n/a             n/a               RAM@A000    RAM@A000    RAM@a000
B000    n/a             n/a               n/a         n/a         RAM@b000
C000    n/a             n/a               RAM@C000    RAM@C000    RAM@c000
D000    I/O             I/O               RAM@D000    RAM@D000    RAM@d000
E000    cart ROM bank0  cart ROM bank0    RAM@E000    RAM@E000    RAM@e000
F000    cart ROM bank0  cart ROM bank0    n/a         n/a         RAM@f000


Note: this needs to be tested against more real RRs


Nordic Replay 
-------------

        ultimax-rr (CPU)                  ultimax-vic-rr (VIC)
        (normal)        (Freeze Mode)     (no difference between freeze/normal)
                                          ultimax     8k          16k
0000    RAM@0000        RAM@0000          RAM@0000    RAM@0000    RAM@0000
1000    n/a             n/a               RAM@1000    RAM@1000    chargen
2000    n/a             n/a               RAM@2000    RAM@2000    RAM@2000
3000    n/a             n/a               n/a         n/a         RAM@3000
4000    n/a             n/a               RAM@4000    RAM@4000    RAM@4000
5000    n/a             n/a               RAM@5000    RAM@5000    RAM@5000
6000    n/a             n/a               RAM@6000    RAM@6000    RAM@6000
7000    n/a             n/a               n/a         n/a         RAM@7000
8000    cart ROM bank0  n/a               RAM@8000    RAM@8000    RAM@8000
9000    cart ROM bank0  n/a               RAM@9000    RAM@9000    chargen
A000    n/a             n/a               RAM@A000    RAM@A000    RAM@a000
B000    n/a             n/a               n/a         n/a         RAM@b000
C000    n/a             n/a               RAM@C000    RAM@C000    RAM@c000
D000    I/O             I/O               RAM@D000    RAM@D000    RAM@d000
E000    cart ROM bank0  cart ROM bank0    RAM@E000    RAM@E000    RAM@e000
F000    cart ROM bank0  cart ROM bank0    n/a         n/a         RAM@f000


Note: this needs to be tested against more real NRs


MMC Replay (Retro Replay Mapper)
--------------------------------

        ultimax-rr (CPU)                  ultimax-vic-rr (VIC)
        (normal)        (Freeze Mode)     (no difference between freeze/normal)
                                          ultimax     8k          16k
0000    RAM@0000        RAM@0000          RAM@0000
1000    n/a             n/a               chargen
2000    n/a             n/a               RAM@2000
3000    n/a             n/a               RAM@3000
4000    n/a             n/a               RAM@4000
5000    n/a             n/a               RAM@5000
6000    n/a             n/a               RAM@6000
7000    n/a             n/a               RAM@7000
8000    cart ROM bank0  n/a               RAM@8000
9000    cart ROM bank0  n/a               chargen
A000    n/a             n/a               RAM@A000
B000    n/a             n/a               RAM@B000
C000    n/a             n/a               RAM@C000
D000    I/O             I/O               RAM@D000
E000    cart ROM bank0  cart ROM bank0    RAM@E000
F000    cart ROM bank0  cart ROM bank0    RAM@F000

