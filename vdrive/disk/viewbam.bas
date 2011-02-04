  100 rem ===============================
  110 rem    view bam for vic & 64 disk
  120 rem for vic, c64, plus4 and c16
  130 rem single floppy disk drives.
  140 rem  rev. 9/84 test systems dept.
  150 rem ===============================
  160 open 15,8,15, "i0"
  170 y$="{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
  180 x$="{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}"
  190 def fns(z) = 2^(s-int(s/8)*8) and (sb(int(s/8)))
  200 open 2,8,2,"#"
  210 print# 15,"u1:2,0,18,0"
  220 rem -----------------
  230 rem  show misc. info
  240 rem -----------------
  250 print "{clr}{down}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}
  260 print "       view bam
  270 print "{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}{down}
  280 print "this program displays
  290 print "   the disk bam
  300 print
  310 print "  a '*' marks used
  320 print "sectors; a '.' marks
  330 print "  unused sectors.{down}{down}
  340 print "disk name         id
  350 print# 15, "b-p:2,144"
  360 for i=1 to 20 : get# 2, a$ : n$=n$+a$ : next
  370 print "{rvon}"+n$+" {rvof}"
  380 fort=1to600:next
  390 print "{down}{down}press space bar for
  400 print "    next screen.     "
  410 get i$ : if i$="" goto 410
  420 print# 15,"b-p:2,1"
  430 get# 2, a$, a$, a$
  440 :
  450 rem ------------------
  460 rem  vic-20 or
  470 rem ------------------
  480 if peek(61654)<>145 then 820
  490 :
  500 rem ------------------
  510 rem      vic-20
  520 rem  show tracks 1-17
  530 rem ------------------
  540 print "{clr}"+y$+" 0{down} 12345678901234567"+"{home}{rvon}tr 1-17 *=used .=not"
  550 for i=20 to 1 step-1 : print i : next
  560 for t=1 to 17 :  x=t+4 : gosub 100  0: next
  570 get i$
  580 print "{home}{rvon} press space bar    "
  590 fort=1to300:next
  600 print "{home}{rvon}tr 1-17 *=used .=not"
  610 fort=1to300:next
  620 if i$=""then570
  630 rem -------------------
  640 rem  show tracks 18-35
  650 rem -------------------
  660 print "{clr}"+y$+" 0{down} 890123456789012345"+"{home}{rvon}tr 18-35 *=used .=not"
  670 for i=20 to 0 step -1 : print i : next
  680 for t=18 to 35 :  x=t-13 : gosub 100 0: next
  690 i$=""
  700 get i$
  710 print "{home}{rvon} press space bar     "
  720 fort=1to300:next
  730 print "{home}{rvon}tr18-35 *=used .=not"
  740 fort=1to300:next
  750 if i$=""then700
  760 goto920
  770 :
  780 rem -------------------
  790 rem  without vic-20
  800 rem  track 1-35
  810 rem -------------------
  820 print "{clr}"+y$+"{down}   12345678901234567890123456789012345"
  830 print "{home}{rvon}      track  1-35   *=used   .=not     "
  840 for i=20 to 0 step -1 : print i : next
  850 for t=1 to 35 :  x=t+4 : gosub 100  0: next
  860 print y$+"{down}{down}"+"{rvon}    press space bar for next screen    "
  870 get i$ : if i$="" goto 860
  880 :
  890 rem -------------------
  900 rem  blocks free
  910 rem -------------------
  920 print "{clr}{down}blocks free:"; ts-17
  930 input "{down}{down}another diskette  n{left}{left}{left}"; a$
  940 if a$="y" then clr : run
  950 close 2 : close 15
  960 end
  970 : -------------
  980 :  subroutines
  990 : -------------
 1000 get# 2, sc$, a$, b$, c$
 1010 ts=ts+asc(sc$+chr$(0))
 1020 sb(0)=asc(a$+chr$(0))
 1030 sb(1)=asc(b$+chr$(0))
 1040 sb(2)=asc(c$+chr$(0))
 1050 print y$+left$(x$,x-1)+"{left}";
 1060 if t>24 and s=18 then print " "; : goto 1160
 1070 o1$="*":o2$=".":ift=18theno1$="{rvon}*{rvof}":o2$="{rvon}.{rvof}"
 1080 for s=0 to 20
 1090 : if t<18 then 1140
 1100 : if t>30 and s=17 then print " "; : goto 1160
 1110 : if t>24 and s=18 then print " "; : goto 1160
 1120 : if t>17 and s=19 then print " "; : goto 1160
 1130 : if t>17 and s=20 then print " "; : goto 1160
 1140 : if fns(s)=0 then print o1$; : goto 1160
 1150 : print o2$;
 1160 : print "{up}{left}";
 1170 next
 1180 return
