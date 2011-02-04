   10 print "{clr}{down} revive scratched disk files"
   20 print "{down}{down} disk unit nr (8-15) ?{$a0}8 {left}{left}{left}{left}";
   30 input u: if u<8 or u>15 then print "{up}{up}{up}": goto 20
   40 print "{down} disk drive nr (0/1) ?{$a0}0{left}{left}{left}";: g=0
   50 input d: if d<0 or d>1 then print "{up}{up}{up}": goto 40
   60 print "{down}{down} put target disk in unit";u;"drive";d
   70 print " then press any key to continue"
   80 get x$: if x$=""then 80
   90 print "{clr}{down} enter scratched file-name (or end)"
  100 print " use * at name-end for wild-card search"
  110 input " ? end{left}{left}{left}{left}{left}";n$: if n$="end" then 520
  120 v=16: q=32: f=256: t=18: s=1: w=0
  130 z$=chr$(0): d$=right$(str$(d),1)
  140 n$=left$(n$,v): l=len(n$)
  150 if right$(n$,1)<>"*" then 170
  160 l=l-1: n$=left$(n$,l): w=1:goto 190
  170 if l=v then 190
  180 for x=l+1 to v: n$=n$+chr$(160): next: l=v
  190 open 1,u,15,"i"+d$: gosub 500
  200 open 2,u,2,"#": gosub 500
  210 print#1,"u1:";2;d;t;s: gosub 500
  220 print#1,"b-p:";2;0: get#2,a$,b$
  230 tr=asc(a$+z$): sc=asc(b$+z$): h=2
  240 print#1,"b-p:";2;h: get#2,t$
  250 c=asc(t$+z$): if c>0 then 290
  260 get#2,a$,b$: f$="": for x=1 to v
  270 get#2,t$: f$=f$+t$: next: if f$="" then 310
  280 if l=0 or n$=left$(f$,l) then 350
  290 h=h+q: if h<f then 240
  300 if tr>0 then t=tr: s=sc: goto 210
  310 if w then print "{down} end of directory": goto 470
  320 print "{down} file-name:  ";n$
  330 print " not found in directory"
  340 for x=1 to 2000: next: goto 490
  350 a=asc(a$+z$): b=asc(b$+z$)
  360 print "{down} found file:  ";f$
  370 print " at track";a;" sector";b
  380 print "{down} want to revive this file (y/n) ? y{left}{left}{left}";
  390 input x$: if x$="y" then 410
  400 if w then 290
  410 print "{down} 1=seq  2=prg  3=usr  4=rel"
  420 print " enter file-type (1-4) ? 1{left}{left}{left}";
  430 input p: if p<1 or p>4 then print "{up}{up}": goto 400
  440 print#1,"b-p:";2;h: print#2,chr$(p+128);
  450 print#1,"u2:";2;d;t;s:gosub 500:g=1
  460 print "{down} un-scratched file:  ";f$: if w then 290
  470 print "{down} revive more files (y/n) ? y{left}{left}{left}";
  480 input x$: if x$<>"y" then 520
  490 close 2: close 1: goto 90
  500 input#1,e,m$,j,k:if e=0 then return
  510 print "{down} error: ";e;m$;j;k
  520 close 2: close 1: if g=0 then end
  530 print "{clr}{down} re-building valid bam"
  540 print " on disk-unit";u;" drive";d
  550 open 1,u,15,"v"+d$: close 1: end
