    1 rem check disk -- ver 1.4
    2 dn=8:rem floppy device number
    5 dimt(100):dims(100):rem bad track, sector array
    9 print"{clr}{down}{down}{down}FFFFFFFFFFFFFFFFFFFFF"
   10 print" check disk program"
   12 print"DDDDDDDDDDDDDDDDDDDDD"
   20 d$="0"
   30 open15,dn,15
   35 print#15,"v"d$
   45 n%=rnd(ti)*255
   50 a$="":fori=1to255:a$=a$+chr$(255and(i+n%)):next
   60 gosub900
   70 open2,dn,2,"#"
   80 print:print#2,a$;
   85 t=1:s=0
   90 print#15,"b-a:"d$;t;s
  100 input#15,en,em$,et,es
  110 ifen=0then130
  115 ifet=0then200:rem end
  120 print#15,"b-a:"d$;et;es:t=et:s=es
  130 print#15,"u2:2,"d$;t;s
  134 nb=nb+1:print" checked  blocks"nb
  135 print" track    {left}{left}{left}{left}"t;" sector    {left}{left}{left}{left}"s"{up}{up}"
  140 input#15,en,em$,es,et
  150 if en=0then85
  160 t(j)=t:s(j)=s:j=j+1
  165 print"{down}{down}bad block:{left}{left}",t;s""
  170 goto85
  200 print#15,"i"d$
  210 gosub900
  212 close2
  215 ifj=0thenprint"{down}{down}{down}{rght}{rght}{rght}no bad blocks!":end
  217 open2,dn,2,"#"
  218 print"{down}{down}bad blocks","track","sector"
  220 fori=0toj-1
  230 print#15,"b-a:";d$,t(i);s(i)
  240 print,,t(i),s(i)
  250 next
  260 print"{down}"j"bad blocks have been allocated"
  270 close2:end
  900 input#15,en,em$,et,es
  910 if en=0 then return
  920 print"{down}{down}error #"en,em$;et;es""
  930 print#15,"i"d$
