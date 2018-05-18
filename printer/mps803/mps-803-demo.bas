100 rem chr$(8)...bit image graphic printing
110 open 4,4   :rem print in graphic mode
120 bs$=chr$(8):de$=chr$(15)
130 :
140 a$=""
150 for i=1 to 16
160 read a: a$=a$+chr$(a)
170 next i
180 :
190 for j=1 to 5
200 print#4,bs$,a$;de$
210 next j
220 :
230 for k=1 to 8:print#4:next k
240 close4
250 end
260 :
270 data 152,152,254,254,146,146,255,255
280 data 146,146,254,254,152,152,128,128
