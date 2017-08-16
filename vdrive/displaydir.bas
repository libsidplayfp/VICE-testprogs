4900 print "dumping directory:"
4901 gosub 5000
4902 end

5000 rem taken from a 1541 manual
5001 rem reads a directory and prints a crappy listing
5002 rem to be used in directory testing

5010 open 1,9,0, "$0"
5020 get #1, a$, b$: rem skip load address

5030 get #1, a$, b$: rem skip pointer to next basic line
5040 get #1, a$, b$: rem get load address (block count)

5050 c = 0
5060 if a$ <> "" then c = asc(a$)
5070 if b$ <> "" then c = c + asc(b$) * 256
5080 print "{rvon}"mid$(str$(c),2);tab(3);"{rvof}";
5090 get #1, b$: if st <> 0 then 5300

5100 if b$ <> chr$(34) then 5090
5110 get #1, b$: if b$ <> chr$(34) then print b$; : goto 5110
5120 get #1, b$: if b$ = chr$(32) then 5120
5130 print tab(18); : c$ = ""
5140 c$ = c$ + b$: get #1, b$: if b$ <> "" then 5140
5150 print "{rvon}"left$(c$,3)
5160 rem
5170 if st = 0 then 5030

5300 print " blocks free."
5310 close 1
5320 return


