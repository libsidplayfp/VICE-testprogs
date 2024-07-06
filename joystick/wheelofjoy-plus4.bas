

;myjoy9 ==1001==
   10 dim x(8),y(8),f(8)
   20 for i=0 to 7
   30 x(i)=i*2+12
   40 y(i)=12
   50 f(i)=0
   60 next i
   70 scnclr
   80 for i=0 to 7
   90 char 1,x(i),y(i),right$(str$(i+1),1)
  100 next i
  110 restore
  120 for i=0 to 7
  130 read n
  140 poke 64784,n
  150 p=peek(64784)
  160 x2=x(i)
  170 y2=y(i)
  180 if not p and 1 then y2=y(i)-1
  190 if not p and 2 then y2=y(i)+1
  200 if not p and 4 then x2=x(i)-1
  210 if not p and 8 then x2=x(i)+1
  220 if not p and 16 then f(i)=1:else f(i)=0
  230 if x2<0 then x2=0
  240 if y2<0 then y2=0
  250 if x2=x(i) and y2=y(i) then 270
  260 char 1,x(i),y(i)," "
  270 x(i)=x2
  280 y(i)=y2
  290 if f(i)=1 then  print"{red}":else print"{blk}"
  300 char 1,x(i),y(i),right$(str$(i+1),1)
  310 next i
  320 goto 110
  330 data 31,63,95,127,159,191,223,255

