10 data 8,27,16,0,36
20 data 156,162,193,193,182,162
30 for i=1to5:reada:a$=a$+chr$(a):next i
40 for j= 1 to 6
45 readb: b$=b$+chr$(b)+chr$(b)
50 next j
60 open 11,4
70 print#11, a$b$chr$(14)" commobore"
80 print#11, chr$(15)
90 cmd11 :list
