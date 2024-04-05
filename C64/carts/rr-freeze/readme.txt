rr-freeze R06
-------------


DESCRIPTION
-----------

$9e80 and $9f80 of each bank in cartridge RAM is pre-filled with tags
to indicate which bank it is.  This is done for all eight possible bank bit
combinations in reverse.  This ensures that any aliases are overwritten with
the lowest possible bank number.

$9e80 and $9f80 of each bank in cartridge ROM is prepared with tags inside
the image.

$9e80, $9f80, $be80, $de80, $df80 and $fe80 in C64 RAM is prepared with tags
to be able to verify if $01 switching is possible.

Scanning is done in two steps.
1. area scan
   This scans the areas $9Exx,$BExx,$DExx,$DFxx and $FExx to see what
   bank/ram/rom is present there and if it's read only or writable
   Area scan is always performed without touching $DE00.

2. bank scan
   This performs an area scan for each of the eight possible bank bit
   combinations, once with RAM=1 and once with RAM=0.
   Bank scan is "destructive" as it has to write $DE00 to sweep the bank
   bits.   The base configuration (i.e bits 1 and 0) are set to 00.

Output format:
  <NAME>  9E:A BE:- DE:- DF:A FE:-    <- detected config (area scan)
    9E:01230123  BE:--------  DE:--------      / bank scan with
    DF:00000000  FE:ABCDEFGH               <---\ RAM-bit=1
    9E:ABCDEFGH  BE:--------  DE:--------    / bank scan with
    DF:ABCDEFGH  FE:ABCDEFGH               <-\ RAM-bit=0  (ROM)

  Letter meaning:
    0-7   -> RAM banks 0-7, inverted means read only.
    A-H   -> ROM banks 0-7, if non-inverted, it is writable (!)
    -     -> no cart detected
    ?     -> mapping mismatch (e.g $de not mapped to $9e and similar)
  Colors:
    light blue -> normal
    light red -> write through to C64 RAM happens
    white     -> no $01 switching possible

What it doesn't check but perhaps ought to:
- what happens with the mapping after KILL in the "random" state.
- what happens with the mapping _during_ when the ack bit is set =1.
- it doesn't detect open bus vs. C64 RAM when no cart is detected.
- fall through to C64 memory is not tested in the "frozen" state
  (tricky because no normal $de00 or $01 switching)
- can we check the "bus contention" condition?
- it doesn't allow you to select which GAME/EXROM bits to set during ack.
- it doesn't check what happens if bank switching is done using the banking
  bits in $de01 instead of $de00.

Requests:
- a version for regular AR.


TEST SEQUENCE
-------------

Select one of the following bit patterns that is written to $de01, then press
RETURN to do it, then FREEZE and observe the result.

01000000  40    REU-Comp=1, NoFreeze=0, AllowBank=0
00000000  00    REU-Comp=0, NoFreeze=0, AllowBank=0
01000010  42    REU-Comp=1, NoFreeze=0, AllowBank=1
00000010  02    REU-Comp=0, NoFreeze=0, AllowBank=1
01000100  44    REU-Comp=1, NoFreeze=1, AllowBank=0
00000100  04    REU-Comp=0, NoFreeze=1, AllowBank=0
01000110  46    REU-Comp=1, NoFreeze=1, AllowBank=1
00000110  06    REU-Comp=0, NoFreeze=1, AllowBank=1

Steps:
1. Dump initial state, "RST"
2. setup $de01
3. Dump state, "CNFD"
4. Set $de00 to ROM bank #5 and then kill cart
5. Wait for user pressing <freeze>
5. Dump state, "FRZ"
6. Ack freeze
7. Dump state, "ACKD"




+---------------------+
| HOW TO RUN THE TEST |
+---------------------+

What to do for each cartridge:
---
1. flash .bin or .crt to the cart.
2. power cycle (reset is probably ok as well)
3. select $DE01 value. ($40, $00, $42 and $02 are the interesting ones)
4. press enter to start test
5. press freeze when requested.
6. choose save and save as dump_rr_40.prg (dev 8 is hardcoded)

Repeat from (2) for $DE01 = $00, $42 and $02 -> dump_rr_00.prg, dump_rr_42.prg,
dump_rr_02.prg
---



+-------+
| DUMPS |
+-------+

Retro Replay #1  (Impetigo)
---------------------------
dumps/dump_rr_00_impetigo.prg
dumps/dump_rr_02_impetigo.prg
dumps/dump_rr_40_impetigo.prg
dumps/dump_rr_42_impetigo.prg

---
Message sent by: Impetigo on 2016-02-25 17:39:47+01
Details:

Tests are done on C64C (short board 250469).

Retro Replay cart (rr-freeze.bin is flashed on the lower bank) as only device on
the Expansion Port.

SD2IEC on the serial port (with a .d81 image mounted). Test outputs are saved on
this image.

$DE01 values 00, 02, 40, 42 were OK.
The other values didn't work. After starting the test freeze button didn't
affect anything.

Let me know if you need more tests.

...and...

You're welcome. Glad my dumps shed more light on the case :)

Yes, the cart I have is 'a genuine Individual Computers Retro Replay'. With the
red PCB. I think this one was the last batch of the RR cartridges. I don't have
a 1541U nor an EF.

Good luck.
Cheers
---


Retro Replay #2  (Count Zero)
---------------------------
dumps/dump_rr_00_sample_cz.prg
dumps/dump_rr_02_sample_cz.prg
dumps/dump_rr_40_sample_cz.prg
dumps/dump_rr_42_sample_cz.prg

---
Message sent by: Count Zero on 2016-03-02 20:36:48+01

RR - is a test run on a RR labeled "sample" - one of the first 10 ever I assume
- all chips on a socket, etc.
---


Nordic Replay #1  (Groepaz)
---------------------------
dumps/dump_nr_00_gpz.prg
dumps/dump_nr_02_gpz.prg
dumps/dump_nr_40_gpz.prg
dumps/dump_nr_42_gpz.prg


Nordic Replay #2  (Count Zero)
------------------------------
dumps/dump_nr_00_cz.prg
dumps/dump_nr_02_cz.prg
dumps/dump_nr_40_cz.prg
dumps/dump_nr_42_cz.prg

These dumps are identical to Groepaz' Nordic Replay with the exception
that the freeze button bit is set in dump_nr_40_gpz, perhaps due to holding
the button longer.

---
Message sent by: Count Zero on 2016-03-02 20:36:48+01

NR - is the new nordic replay from Jens - RR with the nordic power mode added.
----


1541 Ultimate-I #1  (Count Zero)
--------------------------------
dumps/dump_rr_00_1541u1-26d_cz.prg
dumps/dump_rr_02_1541u1-26d_cz.prg
dumps/dump_rr_40_1541u1-26d_cz.prg
dumps/dump_rr_42_1541u1-26d_cz.prg

There where four additional dumps provided with the NoFreeze bit set
(04, 06, 44 and 46).  These dumps are identical to the ones without
the NoFreeze bit set which indicates that the NoFreeze bit is simply
ignored.

---
Message sent by: Count Zero on 2016-02-29 19:36:29+01

on a c64c (short board), svn checkout from today on 1541U with softloaded 2.6d
Firmware - somehow cannot load a crt or the bin from sd card with 1.72b
firmware. will run the romtests when I find back the update utility :)

Nordic Replay, EF3 and several RRs to come soon.
---


EasyFlash 3 #1  (Count Zero)
----------------------------
dumps/dump_rr_00_ef3_cz.prg
dumps/dump_rr_02_ef3_cz.prg
dumps/dump_rr_40_ef3_cz.prg
dumps/dump_rr_42_ef3_cz.prg

There where four additional dumps provided with the NoFreeze bit set
(04, 06, 44 and 46).  These dumps are identical to the ones without
the NoFreeze bit set which indicates that the NoFreeze bit is simply
ignored.

---
Message sent by: Count Zero on 2016-03-02 20:36:48+01

EF - easyflash3 - curious observation: on $44 and $46 after "Save again? N" and
"OK" a reset took the c64 into plain basic mode with 30k bytes free - needed
another reset or power cycle to restart the RR rom.
---


Emulator #1  (VICE x64 r30643)
------------------------------
dumps/dump_rr_00_x64-r30643.prg
dumps/dump_rr_02_x64-r30643.prg
dumps/dump_rr_40_x64-r30643.prg
dumps/dump_rr_42_x64-r30643.prg



Emulator #2  (HOXS64 v1.0.8.7)
------------------------------
dumps/dump_rr_40_hoxs64-v1087.prg








OLD version
-----------

Select one of the following bit patterns that is written to $de01, then press
RETURN to do it, then FREEZE and observe the result.

01000000  40    REU-Comp=1, NoFreeze=0, AllowBank=0
00000000  00    REU-Comp=0, NoFreeze=0, AllowBank=0
01000010  42    REU-Comp=1, NoFreeze=0, AllowBank=1
00000010  02    REU-Comp=0, NoFreeze=0, AllowBank=1
01000100  44    REU-Comp=1, NoFreeze=1, AllowBank=0
00000100  04    REU-Comp=0, NoFreeze=1, AllowBank=0
01000110  46    REU-Comp=1, NoFreeze=1, AllowBank=1
00000110  06    REU-Comp=0, NoFreeze=1, AllowBank=1

- first prepare cartridge RAM with pattern:
  de10..deff gets 10 11 12 13..
  df00..dfff gets 10 11 12 13..
- prompt user to freeze
- read dexx/dfxx back and save
- write back value eor $ff
- read dexx/dfxx back and save
- leave freeze mode, read back ram and save

after pressing FREEZE the test will show 12 rows of hexdump:

- de10.. read in freeze mode
    Cartridge RAM if 10,11,12,13... pattern
- dee0.. read in freeze mode
    Cartridge RAM if e0,e1,e2,e3... pattern
- de10.. second read in freeze mode
    if 10,11,12,13... pattern, RAM could not be written to
    if ef,ee,ed,ec... pattern, RAM could be written to
- dee0.. second read in freeze mode
- 9e10.. read in normal mode
    if 10,11,12,13... pattern, Cartridge RAM could not be written to in freeze mode
- 9ee0.. read in normal mode
    if e0,e1,e2,e3... pattern, Cartridge RAM could not be written to in freeze mode

- df10.. read in freeze mode
    Cartridge RAM if 20,21,22,23... pattern
- dfe0.. read in freeze mode
    Cartridge RAM if f0,f1,f2,f3... pattern
- df10.. second read in freeze mode
    if 20,21,22,23... pattern, RAM could not be written to
    if df,de,dd,dc... pattern, RAM could be written to
- dfe0.. second read in freeze mode
- 9f10.. read in freeze mode
    if 20,21,22,23... pattern, Cartridge RAM could not be written to in freeze mode
- 9fe0.. read in freeze mode
    if f0,f1,f2,f3... pattern, Cartridge RAM could not be written to in freeze mode


Results on hardware:

    NordicReplay                (x64sc r30521)
                 IO1 IO2                     IO1 IO2

40  40 40 44 44  I/O I/O        40 40 40 40  RAM I/O
00  00 00 00 00  I/O I/O        00 00 00 00  I/O RAM
42  42 42 42 42  I/O I/O        42 42 42 42  RAM I/O
02  02 02 02 02  I/O I/O        02 02 02 02  I/O RAM

44  disabled                    disabled
04  disabled                    disabled
46  disabled                    disabled
06  disabled                    disabled
