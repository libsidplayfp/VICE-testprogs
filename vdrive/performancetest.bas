 1000 rem ============================
 1010 rem     performance test  2.2
 1020 rem for vic20, c64, plus4 or c16
 1030 rem and single floppy disk drive
 1040 rem rev 11/84 test systems dept.
 1050 rem ============================
 1060 open 15,8,15
 1070 print "{clr}{down}FFFFFFFFFFFFFFFFFFFFFF"
 1080 print "   performance test"
 1090 print "DDDDDDDDDDDDDDDDDDDDDD{down}"
 1100 print "     insert blank"
 1110 print "  diskette in drive"
 1120 print "  then press {rvon}return{rvof}"
 1130 get a$ : if a$<>chr$(13) then 1130
 1140 print#15, "m-r" chr$(255) chr$(255)   : rem which drive is it?
 1150 : get#15, type$
 1160 : type=asc(type$+chr$(0))
 1170 : max=80 : if type=241 then max=25 : rem  for 1551 fast disk
 1180 rem -------------
 1190 rem  new command
 1200 rem -------------
 1210 ti$="000000"
 1220 print "{down}   disk new command"
 1230 print "wait about"+str$(max)+" seconds"
 1240 print#15, "n0:test disk,00"
 1250 gosub 1970
 1260 if ti<max*60 then 1310
 1270 : print "{down}  system is not"
 1280 : print " responding correctly"
 1290 : print "    to commands"
 1300 : gosub 2000
 1310 print "   {rvon}  drive passed  "
 1320 print "   {rvon}mechanical tests{down}"
 1330 rem -----------------
 1340 rem  seq. write test
 1350 rem -----------------
 1360 print "   open write file"
 1370 : open 2,8,2, "0:test file,s,w"
 1380 : gosub 1970
 1390 print "     writing data"
 1400 : for i=1000 to 2000 : print# 2, i : next
 1410 : gosub 1970
 1420 print "   close write file"
 1430 : close 2
 1440 : gosub 1970
 1450 rem ----------------
 1460 rem  seq. read test
 1470 rem ----------------
 1480 print "    open read file"
 1490 : open 2,8,2, "0:test file,s,r"
 1500 : gosub 1970
 1510 print "     reading data"
 1520 : for i=1000 to 2000
 1530 :  input# 2, j
 1540 :  if j<>i then print "     {rvon}read error:{rvof}" : gosub 1970
 1550 : next
 1560 : gosub 1970
 1570 print "    close read file"
 1580 : close 2
 1590 : gosub 1970
 1600 rem --------------
 1610 rem  scratch file
 1620 rem --------------
 1630 print "     scratch file"
 1640 : print#15, "s0:test file"
 1650 : gosub 1970
 1660 rem ----------------
 1670 rem  t&s addressing
 1680 rem ----------------
 1690 open 8,8,8,"#"  : rem open buffer
 1700 nn%=( 1+rnd(ti)*254+nn% ) and 255
 1710 print#15, "b-p";8;nn%
 1720 nn$="" : for i=1 to 255 : nn$=nn$+chr$(i) : next
 1730 print# 8, nn$; : rem write to buff.
 1740 print "    write track 35"
 1750 : print#15, "u2:";8;0;35;0
 1760 : gosub 1970
 1770 print "    write track 1"
 1780 : print#15, "u2:";8;0;1;0
 1790 : gosub 1970
 1800 print "    read track 35"
 1810 : print#15, "u1:";8;0;35;0
 1820 : gosub 1970
 1830 print "     read track 1"
 1840 : print#15,"u1:";8;0;1;0
 1850 : gosub 1970
 1860 close 8
 1870 :
 1880 print"{down}  {rvon} unit has passed "
 1890 print"  {rvon}performance test!"
 1900 print"{down} remove diskette from"
 1910 print" drive before turning"
 1920 print"      off power."
 1930 end
 1940 : ================
 1950 : check for errors
 1960 : ================
 1970 input#15,en,em$,et,es
 1980 print tab(11-len(em$)/2);em$;"{down}"
 1990 if en<2 then 2090
 2000 : print "{down}{rvon}  unit is failing "
 2010 : print "{rvon} performance test!"
 2020 : print "error: ";et;em$;et;es
 2030 : tm$=ti$
 2040 : print "{down} continue (y/n)?";
 2050 : get a$ : if a$<>"y" and a$<>"n" then 2050
 2060 : print a$ "{down}"
 2070 : if a$="n" then goto 1900
 2080 : ti$=tm$
 2090 return
