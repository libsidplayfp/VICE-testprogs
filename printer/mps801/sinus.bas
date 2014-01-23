100 open4,4:cmd4
110 so$=chr$(14): si$=chr$(15)
115 po$=chr$(16): esc$=chr$(27)
120 cn=23:am=16:of=4
130 a$="-":for i=0tocn+am:a$=a$+"-":next
140 sp$="        "
150 printso$"            sin curve"
160 printsi$
170 printleft$(sp$, of-1)+"x";
180 printspc(cn-am-of-1)"-1";
190 printspc(am-1)"0";
200 printspc(am-1)"1"
210 printa$
220 for i =0 to 360 step 10
230 i$=right$(sp$+str$(i), of)
240 yo=cn*6+am*6*sin(i*3.14/180)
250 yh=int(yo/256): yl=yo-yh*256
270 print i$esc$po$chr$(yh)chr$(yl)"*"
280 next
290 print#4: close4
 
