  100 rem ==============================
  110 rem  drive address change program
  120 rem for use with vic20, c64, plus4
  130 rem or c16 with any cbm disk drive
  140 rem mod. 9/84 test systems dept.
  150 rem ==============================
  160 printchr$(8)chr$(142)
  170 print "{clr}{home}{down}{down}{down}{down}drive address change program
  180 print "{down}turn off all drives now
  190 print "except the one to be changed.
  200 print "{down}old device address  8{left}{left}{left}";
  210 input od : if od<8 or od>15 goto 200
  220 print "{down}new device address  9{left}{left}{left}";
  230 input nd : if nd<8 or nd>15 goto 220
  240 rem --------------
  250 rem drive type is?
  260 rem --------------
  270 open 1,od,15
  280 print# 1, "m-r" chr$(255) chr$(255) : get# 1, c$ : c=asc(c$+chr$(0))
  290 if st then 590
  300 if c=213 then mt=12  : rem 4040 v2.1
  310 if c=226 then mt=50  : rem 2040 v1.2
  320 if c=241 then mt=1551: rem 1551
  330 if c=242 then mt=12  : rem 8050 v2.5
  340 if c=254 then mt=119 : rem 2031 v2.6
  350 if c<>198 then 420
  360 : print# 1, "m-r" chr$(234) chr$(16) : get# 1, zb$ : zb=asc(zb$+chr$(0))
  370 : if zb=0 then mt=12 : rem 4040 v2.7
  380 : if zb<>1 and st then 590
  390 : print# 1, "m-r" chr$(172) chr$(16) : get# 1, zc$ : zc=asc(zc$+chr$(0))
  400 : if zc=1 then mt=12 : rem 8050 v2.7
  410 : if zc=2 then mt=12 : rem 8250 v2.7
  420 close 1
  430 rem --------------
  440 rem change address
  450 rem --------------
  460 if mt=1551 then 500  : rem special!
  470 : open 1,od,15
  480 : print# 1, "m-w" chr$(mt) chr$(0) chr$(2) chr$(nd+32) chr$(nd+64)
  490 : goto 520
  500 if not (nd=8 or nd=9) then print "1551 address not 8 or 9!" : goto 220
  510 : open 1,od,15, "%"+right$(str$(nd),1 )
  520 close 1
  530 print "{down}the selected drive has been changed..."
  540 print "now turn on the other drive(s)"
  550 end
  560 : -------
  570 : error !
  580 : -------
  590 print "device error:"; st
  600 end
