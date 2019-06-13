   10 x=0
   20 ready:ify=-1then100
   30 poke513+x,y:x=x+1:goto20
  100 sys513:ifpeek(512)=1thenload"65816",8
  110 load"65ce02",8
 1000 data24,226,1,144,4,169,1,208,2,169,0,141,0,2,96,-1

