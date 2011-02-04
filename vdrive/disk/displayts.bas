  100 rem******************************
  110 rem* display any track $ sector *
  120 rem*    to screen or printer    *
  130 rem*                            *
  140 rem* c64, expanded vic-20 or    *
  150 rem* plus/4 or c16 equipped     *
  160 rem* with a 1541 or 1551 disk   *
  170 rem* drive.                     *
  180 rem* rev. 10/24/84              *
  190 rem******************************
  200 print"{clr}{down}{down}{rvon}                      "
  210 print"display block contents"
  220 print"{rvon}                      "
  230 rem******************************
  240 rem* set program constant       *
  250 rem******************************
  260 sp$=" ":nl$=chr$(0):hx$="0123456789abcdef"
  270 fs$="":fori=64 to 95:fs$=fs$+"{rvon}"+chr$(i)+"{rvof}":next i
  280 ss$="  ":for i=192 to 223:ss$=ss$+"{rvon}"+chr$(i)+"{rvof}":next i
  290 rem ** vic or c64 ?
  300 ifpeek(58630)<>40then320 :rem vic
  310 l1=63:l2=32:l3=80:l4=3:l5=4:goto330
  320 l1=31:l2=16:l3=40:l4=7:l5=8
  330 dim a$(15),nb(2)
  340 d$="0"
  350 print"{down}{down}        {rvon}s{rvof}creen{down}{left}{left}{left}{left}{left}{left}{left}{left}or {down}{left}{rvon}p{rvof}rinter"
  360 getjj$:if jj$="" then360
  370 if jj$="s"thenprint"        {down}{rvon}screen{rvof}"
  380 if jj$="p"thenprint"        {down}{rvon}printer{rvof}"
  390 open15,8,15,"i"+d$:gosub 1000
  400 open4,4
  410 open 2,8,2,"#":gosub 1000
  420 rem******************************
  430 rem* load track and sector      *
  440 rem* into disk buffer           *
  450 rem******************************
  460 input"{down}{rght}{rght}track, sector";t,s
  470 if t=0 or t>35 then print#15,"i"d$:close2:close4:close15:print"end":end
  480 if jj$="s" then print"{down}{rght}{rght}track"t" sector"s"{down}"
  490 if jj$="p" then print#4:print#4,"track"t" sector"s:print#4
  500 print#15,"u1:2,"d$;t;s:gosub1000
  510 rem******************************
  520 rem* read byte 0 of disk buffer *
  530 rem******************************
  540 print#15,"b-p:2,1"
  550 print#15,"m-r"chr$(0)chr$(7)
  560 get#15,a$(0):ifa$(0)=""thena$(0)=nl$
  570 if jj$="s"then580
  580 if jj$="p"then740
  590 rem******************************
  600 rem* read & crt display         *
  610 rem* rest of the disk buffer    *
  620 rem******************************
  630 k=1:nb(1)=asc(a$(0))
  640 for j=0 to l1:if j=l2 then gosub 1060:if z$="n"then j=l3:goto 730
  650 for i=k to l4
  660 get#2,a$(i):if a$(i)="" then a$(i)=nl$
  670 if k=1 and i<2 then nb(2)=asc(a$(i))
  680 next i:k=0
  690 a$="":b$=":":n=j*l5:gosub 1140:a$=a$+":"
  700 for i=0 to l4:n=asc(a$(i)):gosub 1140
  710 c$=a$(i):gosub 1200:b$=b$+c$
  720 next i:if jj$="s" then printa$b$
  730 next j:goto890
  740 rem******************************
  750 rem* read & printer display     *
  760 rem******************************
  770 k=1:nb(1)=asc(a$(0))
  780 for j=0 to 15
  790 for i=k to 15
  800 get#2,a$(i):if a$(i)="" then a$(i)=nl$
  810 if k=1 and i<2 then nb(2)=asc(a$(i))
  820 next i:k=0
  830 a$="":b$=":":n=j*16:gosub 1140:a$=a$+":"
  840 for i=0 to 15:n=asc(a$(i)):gosub 1140:if z$="n"then j=40:goto 890
  850 c$=a$(i):gosub 1200:b$=b$+c$
  860 next i
  870 if jj$="p" then print#4,a$b$
  880 next j:goto890
  890 rem******************************
  900 rem* next track and sector      *
  910 rem******************************
  920 print"{down}next track and sector"nb(1)nb(2) "{down}"
  930 print"do you want next track and sector"
  940 get z$:if z$="" then940
  950 if z$="y" then t=nb(1):s=nb(2):goto470
  960 if z$="n" then 460
  970 goto 940
  980 rem******************************
  990 rem* subroutines                *
 1000 rem******************************
 1010 rem* error routine              *
 1020 rem******************************
 1030 input#15,en,em$,et,es:if en=0 then return
 1040 print"{rvon}disk error{rvof}"en,em$,et,es
 1050 end
 1060 rem******************************
 1070 rem* screen continue mssg       *
 1080 rem******************************
 1090 print"{down}{rght}{rght}{rght}{rght}continue(y/n)"
 1100 getz$:if z$="" then 1100
 1110 if z$="n" then return
 1120 if z$<>"y" then 1100
 1130 print"{clr}track" t " sector"s "{clr}":return
 1140 rem******************************
 1150 rem* disk byte to hex print     *
 1160 rem******************************
 1170 a1=int(n/16):a$=a$+mid$(hx$,a1+1,1)
 1180 a2=int(n-16*a1):a$=a$+mid$(hx$,a2+1,1)
 1190 a$=a$+sp$:return
 1200 rem******************************
 1210 rem* disk byte to asc display   *
 1220 rem* character                  *
 1230 rem******************************
 1240 if asc(c$)<32 then c$=" ":return
 1250 if asc(c$)<128 or asc(c$)>159 then return
 1260 c$=mid$(ss$,3*(asc(c$)-127),3):return
