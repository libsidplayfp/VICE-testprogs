    0 rem z80 cycletimer script by xmikex - 27 october 2018, v0.1 - robust enough for one test, post bootup.
    1 rem credits to adam of onslaught for measurement/testing on real pal c-128
    2 rem additional credits go to graham of oxyron, who provided insights on z80 timing approach
   10 fast:fori=11776to11956:reada$:pokei,dec(a$):nexti:slow:printchr$(147):poke53280,0:poke53281,0
   20 print"z80 cycletimer ldir test v0.1 by xmikex":print:print" consider using this basic script as a"
   30 print" basis for testing z80 cycle-exactness":print" between c128 emulators and real c128s":print
   40 print"this script uses cia timer-a at one mhz":print"to time a 2048-byte copy using z80 ldir":print
   45 print" this is not a comprehensive test, and":print" is meant for single-use at c128bootup":print
   50 print"on real pal c128 this has been timed at":print"10.50634770 one-mhz cia cycles per byte":print
   70 print"if your emulator  or pal c128  deviates":print"wildly from  standard measurement, then"
   80 print"something is very *wrong* with your emu":print"or your beloved  physical commodore 128":print
   90 print" ";chr$(18);"press any key to begin z80 cycle test";:print:getkeyz$
  100 rem basic script begins in earnest
  110 print:poke11774,0:poke11775,0:pp=dec("2e13")
  120 aa=2048:aa$="ldir":l$="70":pokepp,dec(l$):gosub140:rem gosub framework for future expansion
  130 end
  140 sys11776:print"  ** z80 ";:printaa$;:print" instruction consumes **"
  150 hi$=right$(hex$(peek(11775)),2):lo$=right$(hex$(peek(11774)),2)
  160 printdec(hi$+lo$)/aa;:print"cycles per byte (at 1 mhz)"
  170 poke11774,0:poke11775,0:return
 1000 rem 8502 code block - byte that needs to change are 2e13 (low) for future expansion
 1010 data a9,00,8d,1a,d0,a9,7f,8d,0d,dc,78,a9,3e,8d,00,ff
 1020 data a2,03,bd,70,2e,9d,ee,ff,ca,10,f7,ee,20,d0,a9,0b
 1030 data 8d,11,d0,ad,11,d0,30,fb,ad,11,d0,10,fb,a9,00,8d
 1040 data 0e,dc,a9,ff,8d,04,dc,8d,05,dc,a9,18,8d,0e,dc,a9
 1050 data b0,8d,05,d5,ea,38,ad,04,dc,49,ff,e9,39,8d,fe,2d
 1060 data ad,05,dc,49,ff,e9,00,8d,ff,2d,a9,1b,8d,11,d0,ee
 1070 data 20,d0,58,a9,00,8d,0d,dc,a9,f1,8d,1a,d0,18,60,ff
 1100 rem z80 code block 1 - starts at 2e70
 1110 data 21,74,2e,e9,f3,3e,3e,32,00,ff,01,0e,dc,3e,19,ed
 1120 data 79,01,30,d0,3e,00,ed,79,21,00,20,11,00,48,01,00
 1130 data 08,ed,b0,01,30,d0,3e,00,ed,79,01,21,d0,3e,c2,ed
 1140 data 79,01,0e,dc,3e,08,ed,79,fb,01,05,d5,3e,b1,ed,79
 1150 data 00,cf,00,00,00
