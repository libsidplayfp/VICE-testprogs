    1 slow:wvdc=52684:rvdc=52698:syswvdc,127,0:syswvdc,38,4:syswvdc,14,26:syswvdc,8,11
    2 graphic0:print"{clr}":dc=22:dr=2:graphic5
    5 print"{clr}{blk}aim at the * and hit button or enter key to calibrate"
    6 print"(space to skip & load defaults)        {down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}*"
   10 ifpeek(54298)<10thenprint"lightgun trigger type (potay)":goto20
   11 if(peek(56321)and1)=0thenprint"lightpen button type (joya0/up)":goto20
   12 ifa$=chr$(13)then20:rem return
   15 geta$:ifa$<>" "then10
   16 goto200:rem skip calibration
   20 sysrvdc,,16:rregy:sysrvdc,,17:rregx:dc=x-39:dr=y-12
  200 print"{home}move lightpen/gun around screen. cursor should follow aim point  "
  205 print"                               "
  210 print"cursor will be clipped to border area{down}"
  220 print"offsets column (x) =";dc;", row (y) =";dr
  250 goto8012
 8010 rem if(peek(54784)and64)=0then8010:rem wait for lp status bit
 8012 sysrvdc,,16:rregy:sysrvdc,,17:rregx:c=x-dc:r=y-dr
 8021 syswvdc,32,10:print"{home}{down}{down}{down}{down}{down}{down}vdc values - col (x) = ";str$(x);", row (y) = ";str$(y);"  "
 8022 print"{down}vic-ii values (x) = ";str$(peek(53267));", (y) = ";str$(peek(53268));"  ";
 8023 graphic0:print"{home}vdc col (x) = ";str$(x);", row (y) = ";str$(y);"  "
 8024 print"vic-ii (x) = ";str$(peek(53267));", (y) = ";str$(peek(53268));"  ":graphic5
 8025 ifc<0thenc=0
 8026 ifc>79thenc=79
 8027 ifr<0orr>33thenr=0
 8029 ifr>24thenr=24
 8030 ca=r*80+c:syswvdc,int(ca/256),14:syswvdc,(caand255),15
 8040 syswvdc,0,10:goto8010

