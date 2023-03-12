100 open4,4,7
110 print#4,"              ascii code table"
112 print#4,"                businessmode"
120 print#4
130 a$= "0123456789abcdef"
140 print#4,"  {SHIFT--} ";
150 for i=1 to 16:print#4,mid$(a$, i, 1)" "; :next
160 print#4
170 print#4,"{SHIFT-*}{SHIFT-*}{SHIFT-+}";
180 for i = 1 to 16: print#4, "{SHIFT-*}{SHIFT-*}"; : next
190 print#4
200 for i=1 to 16
210 print#4, mid$(a$, i, 1 ) " {SHIFT--} ";
220 for j=i-1 to 255 step 16
230 if j<32 then gosub330: goto260
240 if j> 127 and j<160 then gosub330: goto260
250 print#4,chr$(j)" ";
260 next j
270 print#4
280 next i
290 print#4 :print#4
300 close4
310 end
320 :
330 print#4,"  ";
340 return
 
