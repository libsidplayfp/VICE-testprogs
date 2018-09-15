10 s=54272
20 poke s+14,255
30 poke s+15,255
40 poke s+18,12*16
50 a=1
60 poke s+18,12*16+8
70 r=peek(s+16+11)
80 printa,r
90 a=a+1
100 if r<255 goto 70 
