 
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
