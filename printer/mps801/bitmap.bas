10 data 156,162,193,193,182,162
20 for i = 1 to 6
30 read a
40 a$=a$+chr$(a)
50 next i
60 open3,4
70 for i=1to4
80 print#3,chr$(8)a$;
90 print#3,chr$(15)" commodore"
100 next i
110 close3
 
