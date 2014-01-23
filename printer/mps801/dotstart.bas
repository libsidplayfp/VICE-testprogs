10 data 8,27,16,0,100
20 data 156, 162,193,193,182,162,15
30 for i=1to12
40 read a
50 r$=r$+chr$(a)
60 next i
70 open5, 4
80 print#5,r$" commodore"
90 close5
