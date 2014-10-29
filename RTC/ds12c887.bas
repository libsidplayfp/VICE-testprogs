

  100 rem
  101 rem this is example of using
  102 rem ds12c887 from basic
  103 rem
  104 dim a$(7)
  105 for a=1to7:read a$(a):next a
  109 :
  110 base=54528:rem base address of chip (d500)
  120 rem base=54784:rem base address of chip (d600)
  130 print "{clr}"
  200 print "{home}"
  230 rem get time from rtc
  231 poke base,6:dw=peek(base+1)
  235 poke base,4:h=peek(base+1)
  240 poke base,2:mi=peek(base+1)
  245 poke base,0:s=peek(base+1)
  246 poke base,7:d=peek(base+1)
  247 poke base,8:m=peek(base+1)
  248 poke base,9:y=peek(base+1)
  250 v=h:gosub 1100:print v;"{left} :";
  255 v=mi:gosub 1100:print v;"{left} :";
  260 v=s:gosub 1100:print v;"{left}  ";
  261 v=m:gosub 1100:print v;"{left} /";
  262 v=d:gosub 1100:print v;"{left} /";
  263 v=y:gosub 1100:print v;"{left}  ";
  264 print a$(dw);"        "
  265 rem setup cia1 tod clock
  266 :
  270 pm=0:v=h:gosub 1100:ifv<13then 280
  275 v=v-12:gosub 1000:h=v
  280 poke 56329,s
  285 poke 56328,0
  290 :
  291 rem that's all folks
  295 :
  999 goto 200
 1000 rem convert v to bcd, return in v
 1010 v=int(v/10)*16+(v-10*int(v/10))
 1020 return
 1100 rem convert v from bcd, return in v
 1110 v=int(v/16)*10+(v-16*int(v/16))
 1120 return
 1130 data sunday,monday,tuesday,wednesday,thursday,friday,saturday

