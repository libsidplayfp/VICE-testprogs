 
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

Results on hardware:

    NordicReplay    (x64sc r30521)
40
00
42
02
44  disabled        disabled
04  disabled        disabled
46  disabled        disabled
06  disabled        disabled
