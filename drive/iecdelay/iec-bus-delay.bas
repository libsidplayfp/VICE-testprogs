 1000 al=10000:rem amount of loops
 1010 print"{clr}{dish}{swlc}

 1460 print"{down}{down} C64 has
 1470 print"    1.023MHz (NTSC)
 1480 print"    0.985MHz (PAL)
 1490 print"{down}  (n/p) ?
 1500 geta$:fq=1.02273::ifa$="n"then1520
 1510 fq=0.98525:ifa$<>"p"then1500
 1520 dv=100/7/fq:rem divider
 
 1530 input"{down}{down} 1541/1571-devicenumber";dn
 
 1540 open5,dn,15
 1550 print#5,"u0>m0":rem 1571->1541-mode (1mhz)
 1560 rem--------------------------------
 1570 print"{down}{down} Please wait
 1580 dimfr$(1):fr$(0)="falling":fr$(1)="rising
 1590 dimr(1,1,11):rem result
 1600 dimrd(11):rem realtivedelay
 1610 dimra(1,1):rem relativedelay average
 1620 i=0
 1630 reada:ifa>-1thenpoke49152+i,a:i=i+1:goto1630
 1640 i=0
 1650 reada:ifa=-1then1670
 1660 poke49408+i,a:print#5,"m-w"chr$(i)chr$(5)chr$(1)chr$(a):i=i+1:goto1650
 1670 forfl=0to1:rem---------------floppy
 1680 forc6=0to1:rem------------------c64
 1690 print"{down}{down} Floppy: "fr$(fl)" edge
 1700 print" C64:    "fr$(c6)" edge
 1710 fori=49166to49177:pokei,234:next:rem nop
 1720 iffl=0thena=240:rem beq  1541-falling-edge
 1730 iffl=1thena=208:rem bne  1541-rising-edge
 1740 poke49183,a:rem beq/bne
 1750 iffl=0thena=0:rem ora #$00  1541-falling-edge
 1760 iffl=1thena=2:rem ora #$02  1541-rising-edge
 1770 poke49408+7,a:print#5,"m-w"chr$(7)chr$(5)chr$(1)chr$(a):rem ora #$00/02
 1780 ifc6=0thena=240:rem beq  c64-falling-edge
 1790 ifc6=1thena=208:rem bne  c64-rising-edge
 1800 poke49408+20,a:print#5,"m-w"chr$(20)chr$(5)chr$(1)chr$(a):rem beq/bne
 1810 print#5,"m-e"chr$(0)chr$(5)
 1820 ifc6=1thenpoke56576,23:rem c64-clock-out = active
 1830 fordl=2to11:rem---delay (in cycles)
 1840 poke53265,peek(53265)and239
 1850 td=dl:rem temporary delay-memory
 1860 i=14:if(dland1)=0then1910:rem b.i.even
 1870 poke49152+14,36 :rem bit $ff (3cycles)
 1880 poke49152+15,255:rem bit $ff
 1890 td=td-3
 1900 i=16
 1910 iftd=0then1950
 1920 forj=1totd/2
 1930 poke49152+i,234:i=i+1:rem nop (2cycles)
 1940 next
 1950 poke49152+0+i,173:rem lda $dd00
 1960 poke49152+1+i,0  :rem lda $dd00
 1970 poke49152+2+i,221:rem lda $dd00
 1980 if(dland1)=1then2020:rem b.i.odd
 1990 poke49152+3+i,36 :rem bit $ff (3cycles)
 2000 poke49152+4+i,255:rem bit $ff
 2010 goto2040
 2020 poke49152+3+i,234:i=i+1:rem nop (2cycles)
 2030 poke49152+4+i,234:i=i+1:rem nop (2cycles)
 2040 a=al:rem amount of loops
 2050 b=65536-al
 2060 c=int(b/256)
 2070 d=b-256*c
 2080 poke251,d:poke252,c
 2090 bc=peek(53280)
 2100 poke780,215:rem falling c64-edge
 2110 ifc6=1thenpoke780,199:rem rising c64-edge
 2120 sys49152
 2130 poke53280,bc
 2140 poke53265,peek(53265)or16
 2150 r=peek(253)+peek(254)*256
 2160 r(fl,c6,dl)=r
 2190 print" delay cycles:";dl;"pos.responses:";int(r*100/al+0.5)"{left}%
 2210 nextdl

 2220 poke53265,peek(53265)or16
 2230 print"{down}{down} Floppy: "fr$(fl)" edge
 2240 print" C64:    "fr$(c6)" edge
 2250 print"{down}                    relative  relative
 2260 print" Delay              delay     delay
 2270 print" in C64  positive   in C64    in micro-
 2280 print" cycles  responses  cycles    seconds
 2290 c=0:rem counter good result
 2300 fori=2to11
 2310 r=r(fl,c6,i)
 2320 r1=int(r/al*100+0.5)
 2330 print"  "i,r1"{left}%",
 2340 if(r1=0)or(r1=100)then2400
 2350 rd(i)=i-(100*r/al/dv):rem relativedelay
 2360 printint(rd(i)*100+0.5)/100,
 2370 printint(rd(i)/fq*100+0.5)/100;
 2380 a(c)=rd(i)
 2390 c=c+1
 2400 print
 2410 next
 2420 ifc=0then2520
 2430 rd=0
 2440 fori=0toc-1
 2450 rd=rd+a(i)
 2460 next
 2470 rd=rd/c
 2480 ra(fl,c6)=rd
 2490 print"{down} Average relativedelay:
 2500 print" "int(rd*100+0.5)/100"C64-cycles
 2510 print" "int(rd/fq*100+0.5)/100"microseconds
 2520 poke56576,31:poke56576,15:poke56576,7
 2530 input"{down}{down}{up} <Return>";a$
 
 2540 nextc6
 2550 nextfl:rem-------------------------
 2560 print#5,"ui

 2570 print"{clr}results (1/2)
 2571 print"{down}                      Floppy edge
 2580 print,,fr$(0),fr$(1)
 2590 print" C64 "fr$(0)" edge",int(ra(0,0)*100+0.5)/100,int(ra(1,0)*100+0.5)/100
 2600 print" C64 "fr$(1)" edge",int(ra(0,1)*100+0.5)/100,int(ra(1,1)*100+0.5)/100
 2610 print"                     in C64-cycles
 2620 print"{down}{down}                      Floppy edge
 2630 print,,fr$(0),fr$(1)
 2640 print" C64 "fr$(0)" edge",int(ra(0,0)/fq*100+0.5)/100"{left}us",
 2650 printint(ra(1,0)/fq*100+0.5)/100"{left}us"
 2660 print" C64 "fr$(1)" edge",int(ra(0,1)/fq*100+0.5)/100"{left}us",
 2670 printint(ra(1,1)/fq*100+0.5)/100"{left}us
 2680 print"                     in microseconds
 2690 print"{down} Falling edge = IEC-bus 5V -> 0V
 2700 print" Rising edge  = IEC-bus 0V -> 5V
 2710 print"{down} Edge = what the C64/floppy makes
 2720 print"        (not what it reacts to)
 2730 input"{down}{down}{down}{down}{up} <Return>";a$
 
 2540 print"{clr}results (2/2)
 2741 print"{down}    C64=fal  C64=ris{rght} C64=fal  C64=ris
 2750 print"     41=fal   41=fal   41=ris   41=ris
 2760 print" a   2.86us   2.83us   2.89us   2.86us
 2770 print" b   2.97us   2.94us   3.01us   2.98us
 2780 print" c   2.75us   2.72us   2.77us   2.74us
 2790 print" d   2.99us   2.85us   2.97us   2.83us
 2800 print" e   3.00us   2.94us   3.01us   2.94us
 2840 print" x  "int(ra(0,0)/fq*100+0.5)/100"{left}us{left}{left}",
 2850 print"{rght}{rght}{rght}"int(ra(0,1)/fq*100+0.5)/100"{left}us{left}",
 2860 print"  "int(ra(1,0)/fq*100+0.5)/100"{left}us",
 2870 print" "int(ra(1,1)/fq*100+0.5)/100"{left}us
 2880 print"{down} a= 1541-2        1. of 1 device
 2890 print" b= 1541old       1. of 1 device
 2900 print" c= 1571ext       1. of 1 device
 2910 print" d= 1541-2        1. of 5 devices
 2920 print" e= 1541-2        5. of 5 devices
 2960 print" x= tested device
 2970 input"{down}{down}{up} <Return>";a$
 
 3120 goto2570
 3130 end:rem----------------------------
 3140 data120,162,0,134,253,134,254,170,73,16,168,142,0,221,234,234,234,234,234
 3150 data234,234,234,234,234,234,234,140,0,221,41,128,240,9,36,0,234,234,234
 3160 data234,76,53,192,230,253,240,5,36,0,76,53,192,230,254,238,32,208,230,251
 3170 data240,6,234,234,234,76,11,192,230,252,208,197,96,-1
 3180 data120,173,0,24,41,245,9,0,170,73,2,168,142,0,24,169,4,44,0,24,240,251
 3190 data140,0,24,173,0,28,73,8,141,0,28,173,0,24,16,230,96,-1

