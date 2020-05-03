
In this directory we collect some info about the RAM init pattern of a VIC20.

WANTED: we still need more dumps from individual machines, as well as examples
of programs that rely on non initialized RAM in one way or another. This will
allow us to work out the most ideal pattern for VICE.

to make a dump you can use:

poke43,0:poke44,0:poke45,255:poke46,255:poke55,255:poke56,255:save"mem",8,1

--------------------------------------------------------------------------------

first a brief memory map to help reading the dumps:

3k (unexpanded):

0000-03ff    RAM
1000-1dff    RAM (BASIC)
1e00-1fff    RAM (screen)
9400-95ff    Color RAM

+3k:

0400-0FFF    3K expansion RAM area

When additional memory is added to block 1 (and 2 and 3):

1000-11ff    RAM (screen)
1200-?       RAM (BASIC)
2000-3fff    8K expansion RAM/ROM block 1
4000-5fff    8K expansion RAM/ROM block 2
6000-7fff    8K expansion RAM/ROM block 3

--------------------------------------------------------------------------------
Dumps from real machines
--------------------------------------------------------------------------------


darwinNE.bin
------------

PAL VIC_20 CR version Ser. No. WGC 182127

RAM: JAPAN 3G3 / HM6116P-4

1800 | FF 26 00 FF  04 FF 04 FE  20 FF 00 FF  00 FF 02 BB
1810 | 00 FF 00 FF  00 FF 1C ED  02 FC 00 FF  00 FF 80 57
1820 | 10 7F 00 FF  00 FF 84 AF  02 F6 00 FF  00 FF 80 FB
1830 | 09 6B 00 FF  00 FF 56 EF  08 FE 00 FF  00 FF 14 FC
1840 | 03 D7 00 FF  00 FF 06 D9  00 DE 00 FF  00 F7 08 DB
1850 | 02 FF 00 FF  00 FF 25 D6  1C B7 00 FF  00 FF 62 F7
1860 | 02 6C 40 FF  00 FF 60 97  02 DF 00 FF  00 FF 32 BA
1870 | 0A BF 00 FF  00 FF 94 FB  08 7F 00 FF  00 FF 0B 5F


ops.bin
-------

RAM: TMM2016AP-12 / JAPAN 3 GA4

1800 | FF 00 FF 00  FF 00 FF 00  00 FF 00 FF  00 FF 00 EF
1810 | FF 00 FF 00  FF 00 FF 00  00 FF 00 FF  00 FF 00 DF
1820 | FF 00 FF 00  FF 00 FF 00  80 FF 00 FF  40 FF 00 FF
1830 | FF 00 FF 00  FF 00 FF 00  00 FF 00 FF  00 FF 00 EF
1840 | FF 00 FF 00  FF 00 FF 00  00 FF 00 FF  02 FF 00 FF
1850 | FF 00 FF 00  FF 00 FF 00  00 FF 00 FF  00 FF 00 FF
1860 | FF 00 FF 00  FF 00 FF 00  00 BF 00 BF  90 FF 00 FF
1870 | FF 00 FF 00  FF 00 FF 00  00 CF 00 FF  00 FF 00 FF


srowe-324002-02RevD.bin
-----------------------

ASSY: 324002-02 Rev D

 internal 3K expansion

0400 | 00 00 00 F2  9F FB 7F E4  00 FD DF 00  00 FF 7F 00
0410 | 00 F0 0E 00  00 F0 0F 00  00 FB FF 00  00 F9 3F 00
0420 | 00 F0 05 00  00 D0 0F 00  00 FD 9F 00  00 FB 7F 00
0430 | 00 F0 0F 00  00 D0 0A 00  00 F1 7B 00  00 FA 7F 00
0440 | 00 B0 0F 10  00 D0 0F 00  02 FF FB 00  00 FF BF 08
0450 | 00 E0 4C 00  00 B8 0E 00  00 FF 7F 00  00 F3 1A 00
0460 | 00 F0 06 00  00 F0 07 00  00 FC EF 00  00 F5 77 00
0470 | 00 C0 0F 00  00 E0 0A 00  00 FF 7F 00  00 F9 EF 04

1800 | 03 54 00 2A  00 DC D5 E4  88 C4 05 AE  10 1C 50 D7
1810 | 02 4C 40 91  C8 D5 6D 7E  01 ED 0C 8C  08 D8 0D 58
1820 | 08 CC 06 EC  00 50 9A 6E  0C 90 00 84  20 18 E5 37
1830 | 80 C6 00 7C  1A CC 6D C8  00 CD 00 8C  05 F5 05 DD
1840 | 00 EC 27 03  04 F5 02 BC  02 7F 11 E9  00 DE 8B E9
1850 | 00 EC 04 A9  80 FD 84 EC  22 C7 24 F1  20 DE E5 F3
1860 | 04 F5 30 F5  24 1A A7 E7  04 7D 25 F5  00 6A 30 FF
1870 | 04 EC 04 F5  08 75 A5 74  00 FE 00 FE  00 AC 0F EF
 

vicist-250403.bin
-----------------

cr version UKB 126095

1800 | 60 D7 00 FF  00 FF 80 2D  B0 2E 00 FF  00 FF 00 2D
1810 | 80 3D 00 FF  00 BF 10 EF  10 BE 00 FF  00 7F 9A 3F
1820 | 00 2B 00 FF  00 FF 00 7B  90 2C 00 FF  00 3B 10 7F
1830 | 94 6E 00 FF  00 FF 94 B8  81 2D 00 FF  00 FF 90 2F
1840 | 12 6D 00 FF  00 FF 80 BA  1A 3B 00 FF  00 7F 90 3F
1850 | 10 2F 00 FF  00 FF 98 7E  94 3B 00 7F  00 FF 90 7B
1860 | 94 2F 00 FF  00 FF 91 3B  98 39 00 7F  00 FF 92 AB
1870 | 80 FF 00 FF  00 FF 83 3D  17 2D 00 BF  00 FF 02 3B


vicist-324003.bin
-----------------

pet keyboard WGB 1606

1800 | B5 74 7C 58  AB 13 11 9F  B0 AD 37 A3  B1 73 FA 5B
1810 | D8 CC 8C 84  ED F6 CF 40  CC E9 8E C0  CC 84 A2 98
1820 | 84 D5 DC EC  FC 88 CD 65  8C CC CC CE  C5 8E DC 4C
1830 | A2 6D 13 2F  38 F5 1A 63  0F 56 13 DA  25 BA 72 A3
1840 | 3B 66 7E 20  71 FB 6F 5B  E3 82 33 72  B7 52 2C 63
1850 | CD C6 C8 C6  C9 D9 D4 7B  C2 D6 C5 C4  08 9D 86 4B
1860 | CD D8 98 45  CC 40 CD 8C  0C 80 E8 FD  0E 4E 84 15
1870 | B1 AB B8 16  33 28 3B 03  31 1F 77 B7  B8 3C 07 D2

--------------------------------------------------------------------------------
Problematic programs that rely on non initialized memory:
--------------------------------------------------------------------------------

Jelly Monsters (v1 and v2) (8K cartridge)

uses non initialized $1046, a fixed/patched version does this to fix it:

.C:bff8  A9 FF       LDA #$FF
.C:bffa  8D 46 10    STA $1046
.C:bffd  4C 1F A0    JMP $A01F


AE. The problem surfaces in a shifted display, see 
https://www.lemon64.com/forum/viewtopic.php?t=73903

uses non initialized $0288, writing $ff to it before starting the cart makes it
work right.

