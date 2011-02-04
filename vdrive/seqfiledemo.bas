    1 rem ***************
    2 rem *   example
    3 rem * read & write
    4 rem * a sequential
    5 rem * data file
    6 rem ***************
   10 print"{clr}{down}{down}{rght}{rght}{rght}initialize disk"
   20 dima$(25)
   30 dimb(25)
   40 open15,8,15,"i0"
   60 gosub 1000
   70 cr$=chr$(13)
   80 print
   90 print" {down}write seq test file"
   95 print
  100 rem *************
  101 rem *
  102 rem *  write seq
  103 rem *  test file
  104 rem *
  105 rem *************
  110 open2,8,2,"@0:seq test file ,s,w"
  115 gosub 1000
  117 print"enter a word, comma, number"
  118 print"enter word 'end' to stop"
  120 input"a$,b";a$,b
  130 ifa$="end"then 160
  140 print#2,a$","str$(b)cr$;
  145 gosub 1000
  150 goto 120
  160 close 2
  200 rem *************
  201 rem *
  202 rem *  read seq
  203 rem *  test file
  204 rem *
  205 rem *************
  206 print
  207 print"  read seq test file"
  208 print
  210 open2,8,2,"0:seq test file ,s,r"
  215 gosub 1000
  220 input#2,a$(i),b(i)
  224 rs=st
  225 gosub 1000
  230 printa$(i),b(i)
  240 ifr s=64 then 300
  250 if rs<>0 then 400
  260 i=i+1
  270 goto 220
  300 close 2
  310 end
  400 print"bad{rght}disk{rght}status{rght}is{rght}"rs
  410 close 2
  420 end
 1000 rem ************
 1001 rem *
 1002 rem *  read
 1003 rem * the error
 1004 rem *  channel
 1005 rem *
 1006 rem ************
 1010 input#15,en,em$,et,es
 1020 if en=0 then return
 1030 print"{rght}{rght}{rght}{rght}error on disk"
 1040 printen;em$;et;es
 1050 close 2
 1060 end
