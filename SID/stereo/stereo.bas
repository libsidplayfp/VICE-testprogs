0 s1=54272:s2=56832
1 for l=s1 to s1+24:poke l,0:next
2 for l=s2 to s2+24:poke l,0:next
3 poke s1+24,15:poke s2+24,15
4 poke s1+5,64
5 poke s1+1,162:poke s1,37
6 poke s1+4,17:for t=1 to 200:next
7 poke s1+4,16:for t=1 to 500:next
8 poke s2+5,64
9 poke s2+1,130:poke s2,37
10 poke s2+4,17:for t=1 to 200:next
11 poke s2+4,16:for t=1 to 500:next
12 goto 4

