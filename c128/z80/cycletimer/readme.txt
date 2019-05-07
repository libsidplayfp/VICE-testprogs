https://www.reddit.com/r/c128/comments/9pn4sh/vice_x128exe_v_z64k_c128_emulation_cycleexactness/

I was testing cycle times (with CIA timer) against Z80 instructions and noticed 
anomalies with VICE's cycle timings. I decided to frame 'cycle-exactness' of 
VICE against Z64K. I conjured up the following program for testing purposes, and 
the results (as seen in screenshot link) speak for themselves. This program will 
be discussed / commented in a future post.


10 fori=11776to11955:reada$:pokei,dec(a$):nexti
20 printchr$(147):poke11774,0:poke11775,0:poke53280,0:poke53281,0:pp=dec("2e13")
30 aa=2048:aa$="ldir":l$="70":pokepp,dec(l$):gosub100: rem use gosub framework for future expansion.
40 end:rem if ldir cycle timing does not end up roughly 10.5 cycles per byte, then something is wrong.
100 sys11776:print:print"** z80 ";:printaa$;:print" instruction consumes **"
110 hi$=right$(hex$(peek(11775)),2):lo$=right$(hex$(peek(11774)),2)
120 printdec(hi$+lo$)/aa;:print"cycles per byte (at 1 mhz)"
130 poke11774,0:poke11775,0:return
1000 rem 8502 code block - byte that needs to change in future expansion is 2e13 (low byte)
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
1140 data 79,01,0e,dc,3e,08,ed,79,01,05,d5,3e,b1,ed,79,fb
1150 data 00,cf,00,00


Adam Morton of Australia reports runtime 10.5063477 CYCLES PER BYTE from 
his physical C-128 (PAL ~50 Hz).

21-oct-2018 Z64K emu changelog : "Fixed Z80 OUT (C),reg8 timing" : emu now 
reports - 10.5058594 cycles per byte (at 1 mhz)

https://i.redd.it/8o6c8pzm17t11.png
