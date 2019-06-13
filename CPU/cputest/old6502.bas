   10 x=0
   20 ready:ify=-1then100
   30 poke513+x,y:x=x+1:goto20
  100 sys513:ifpeek(512)=1thenprint"the cpu is an old6502":end
  110 load"65sc02andup",8
 1000 data169,8,24,106,201,4,240,4,169,1,208,2,169,0,141,0,2,96,-1

