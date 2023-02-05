copied from https://sourceforge.net/p/vice-emu/bugs/1825/

Testprogram will (after bunc of setting up):
- copy 1 page using P0 and P1 from 1F000 to 10200 with Common turned Off
- verify the contents of 10200 is 0,1,2,-ff
- copy 1 page using P0 and P1 from 1F000 to 10200 with Common Hi 8k
- verify the contents of 10200

Uses Z80 (p0 and p1 can be relocated freely)

Upon OK black border and 0 to io $d7ff

NOK = grey border and #$ff to op $d7ff

0F000-0f0ff = zeros

1f000-1f0ff = 0,1,2,3-FF

Error = the attempt to copy from 1f000 to 10200 while Common Hi8k on D506 returns
contents of 0F000-0F0ff instead of 1F000-1F0ff.

Read '1f000' (using p0/p1 reloc) should work regardless of the Common Hi setting.
(as opposed to Common Low which trumps the p0 p1 reloc)

------------------------------------------------------------------------------

tstz80bk.prg:

basic loader starts Z80 and tests the above.

Black border means success, grey border means failure.
