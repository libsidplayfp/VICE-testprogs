   10 rem vdrive-rel.c bug demonstration
   20 rem by helfried peyrl 070609
   30 rem ------------------------------
   99 :
  100 rem create relative file
  110 l = 240: nr = 10
  120 open1,8,15
  130 open2,8,2,"0:test,l,"+chr$(l)
  140 r = r: gosub 1000
  150 print#2,chr$(255);
  160 gosub 1000
  170 close 2: gosub 1200
  180 :
  200 rem write records
  210 open2,8,2,"0:test,l,"+chr$(l)
  220 for r = 1 to nr
  230 : t$ = "": print "record " r ":"
  240 : for i = 0 to 38
  250 :  t$=t$+chr$(r+64)
  260 : next i: print t$
  270 : gosub 1000
  280 : print#2,t$: gosub 1000
  290 : gosub 1000
  300 next r
  310 close 2: gosub 1200
  320 :
  400 rem read records
  410 open2,8,2,"0:test,l,"+chr$(l)
  420 for r = 1 to nr
  430 : gosub 1000
  440 : input#2,a$: gosub 1200
  450 : gosub 1000
  460 : print"record " r ":"
  470 : print a$
  480 next r
  490 :
  980 close 2: gosub 1200: close 1
  998 end
  999 :
 1000 rem position to record r
 1010 rh = int(r/256)
 1020 rl = r-rh*256
 1030 print#1,"p"+chr$(96+2)+chr$(rl)+chr$(rh)+chr$(1)
 1040 gosub 1200:return
 1190 :
 1200 rem check status
 1210 input#1,en,em$,et,es
 1220 if en>1 and en<>50 then print en;em$;et;es:stop
 1230 return
