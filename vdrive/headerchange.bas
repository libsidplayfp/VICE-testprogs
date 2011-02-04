   10 print "{clr}{down} change diskette header-name"
   20 print "{down} disk unit nr (8-15) ?{$a0}8 {left}{left}{left}{left}";
   30 input u: if u<8 or u>15 then print "{up}{up}{up}": goto 20
   40 print "{down} disk drive nr (0/1) ?{$a0}0{left}{left}{left}";
   50 input d: if d<0 or d>1 then print "{up}{up}{up}": goto 40
   60 print "{down}{down} put target disk in unit";u;" drive";d
   70 print " then press any key to continue"
   80 get x$: if x$=""then 80
   90 a=1: v=16: q$=chr$(34): p$=chr$(160)
  100 t=18: s=0: i$="i"+right$(str$(d),1)
  110 open 1,u,15,i$: gosub 350
  120 gosub 310: f$=h$: get#2,x$,x$,a$,b$
  130 print "{clr}{down}{down} current header-name ";q$;f$;q$
  140 print " diskette id is:  ";a$;b$
  150 print "{down} new name (max 16 characters) or 'quit'"
  160 input " ? quit{left}{left}{left}{left}{left}{left}";n$: l=len(n$): if l>v then 130
  170 if n$="quit" then print "{clr}";: goto 370
  180 print "{down} ok to write new header-name (y/n) ? y{left}{left}{left}";
  190 input x$: if x$<>"y" then 130
  200 if l=v then 220
  210 for x=l+a to v: n$=n$+p$: next
  220 print#1,"b-p:";2;144: print#2,n$;
  230 print#1,"u2:";2;d;t;s: gosub 350
  240 print#1,i$: gosub 350: close 2
  250 print "{down} old header-name ";q$;f$;q$
  260 gosub 310: close 2: close 1
  270 print "{down} new header-name ";q$;h$;q$
  280 print "{down} change another diskette (y/n) ? y{left}{left}{left}";
  290 input x$: if x$="y" then 60
  300 print "{clr}";: end
  310 open 2,u,2,"#": gosub 350: h$=""
  320 print#1,"u1:";2;d;t;s: gosub 350
  330 print#1,"b-p:";2;144: for x=a to v
  340 get#2,t$: h$=h$+t$: next: return
  350 input#1,e,m$,j,k:if e=0 then return
  360 print "{down} error: ";e;m$;j;k
  370 close 2: close 1: end
