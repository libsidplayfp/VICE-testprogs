10 open6,4
20 for i = 1 to 6: reada: a$=a$+chr$(a): next
30 for j = 1 to 4: readb: b$=b$+chr$(b):next
40 for k = 1 to 6: readc: c$=chr$(c)
50 d$=str$(1977+k)
60 print#6,chr$(15)d$a$c$b$c$
70 next
80 cmd6: list
90 data 8,27,16,0,53,26
100 data 255,59, 15,32
110 data 34,57,75,88,123,186
