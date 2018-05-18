  100 rem printer test for vic and 64
  110 nl$=chr$(10):cr$=chr$(13)
  120 bs$=chr$(8):so$=chr$(14):si$=chr$(15)
  130 po$=chr$(16):esc$=chr$(27):sub$=chr$(26)
  140 cd$=chr$(17):cu$=chr$(145)
  150 rvs$=chr$(18):off$=chr$(146)
  160 :
  170 open4,4:print#4:print#4
  180 print#4,so$"             printer test"
  190 :
  200 print#4:print#4
  210 print#4,so$"1. check graphic (cursor up) mode"si$
  220 gosub840:close4
  230 :
  240 open4,4,7 :print#4
  250 print#4,so$"2. check business(cursor down) mode"si$
  260 gosub840:close4
  270 :
  280 open4,4:print#4:print#4,so$"3. chr$(10) test"si$:print#4
  290 fori=48to52:print#4,po$"25"chr$(i);nl$:next
  300 :
  310 print#4:print#4,so$"4. chr$(13) test"si$:print#4
  320 fori=53to57:print#4,po$"25"chr$(i);cr$:next
  330 :
  340 print#4:print#4,so$"5. chr$(8) test"si$:print#4
  350 forj=1to2
  360 a$="":fori=128to255:a$=a$+chr$(i):next
  370 print#4,bs$a$:print#4,si$:nextj
  380 forj=1to2
  390 b$="":fori=255to128step-1:b$=b$+chr$(i):next
  400 print#4,bs$b$:print#4,si$:nextj
  410 :
  420 print#4:print#4,so$"6. chr$(14) & chr$(15) test"si$:print#4
  430 forj=2to4step2
  440 a$="":fori=j*16toj*16+31:a$=a$+chr$(i):next
  450 print#4,so$a$cr$si$a$:next
  460 :
  470 print#4:print#4,so$"7. chr$(16) test"si$:print#4
  480 for j=0to7:print#4,po$chr$(48+j)chr$(0)"commodore":next
  490 :
  500 print#4:print#4,so$"8. chr$(26) test"si$:print#4
  510 for j=0to3:print#4,bs$sub$chr$(10+10*j^2)chr$(255):next
  520 :
  530 print#4:print#4,so$"9. chr$(27) test"si$:print#4
  540 sp$="          "
  550 for i=0to360step10
  560 i$=right$(sp$+str$(i),4)
  570 yo=220+120*sin(i*~/180)
  580 yh=int(yo/256):yl=yo-yh*256
  590 print#4,i$esc$po$chr$(yh)chr$(yl)"*"
  600 next:close4
  610 :
  620 open4,4
  630 print#4:print#4,so$"10. chr$(17) test"si$:print#4
  640 forj=10to13
  650 a$="":fori=j*16toj*16+15:a$=a$+chr$(i):next
  660 print#4,a$"   "cd$a$
  670 next
  680 :
  690 print#4:print#4,so$"11. chr$(145) test"si$:print#4:close4
  700 open4,4,7:forj=10to13
  710 a$="":fori=j*16toj*16+15:a$=a$+chr$(i):next
  720 print#4,a$"   "cu$a$
  730 next:close4
  740 :
  750 open4,4
  760 print#4:print#4,so$"12. chr$(18) & chr$(146) test "si$:print#4
  770 a$=" commodore "
  780 fori=0to3:print#4,rvs$a$off$"  "a$"  "rvs$a$off$"  "a$"  "rvs$a$
  790 next
  800 :
  810 print#4:print#4:cmd4,so$"program list"si$:list
  820 end
  830 :
  840 print#4
  850 fori=32to47
  860 forj=1to8:print#4,chr$(i);:next:print#4,"  ";
  870 forj=1to8:print#4,chr$(i+16);:next:print#4,"  ";
  880 forj=1to8:print#4,chr$(i+32);:next:print#4,"  ";
  890 forj=1to8:print#4,chr$(i+48);:next:print#4,"  ";
  900 forj=1to8:print#4,chr$(i+128);:next:print#4,"  ";
  910 forj=1to8:print#4,chr$(i+144);:next:print#4,"  ";
  920 forj=1to8:print#4,chr$(i+160);:next:print#4,"  ";
  930 forj=1to8:print#4,chr$(i+176);:next:print#4,"  ";
  940 next
  950 print#4:return
