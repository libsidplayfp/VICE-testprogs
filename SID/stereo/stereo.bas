0 s1=54272:s2=56832
1 print "first sid at $d400"
2 print "second sid at $de00"
10 for l=s1 to s1+24:poke l,0:next
12 for l=s2 to s2+24:poke l,0:next
13 poke s1+24,15:poke s2+24,15
14 poke s1+5,64
15 poke s1+1,162:poke s1,37:print"1st (higher pitch)"
16 poke s1+4,17:for t=1 to 200:next
17 poke s1+4,16:for t=1 to 500:next
18 poke s2+5,64
19 poke s2+1,130:poke s2,37:print"2nd (lower pitch)"
20 poke s2+4,17:for t=1 to 200:next
21 poke s2+4,16:for t=1 to 500:next
22 goto 10

