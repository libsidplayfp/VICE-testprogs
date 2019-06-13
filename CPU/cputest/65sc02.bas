   10 x=0
   20 ready:ify=-1then100
   30 poke513+x,y:x=x+1:goto20
  100 sys513:ifpeek(512)=1thenprint"cpu is a 65sc02":end
  110 print"cpu is a 65c02"
 1000 data120,165,247,72,162,0,134,247,247,247,228,247,208,4,162,1,208,2,162,0
 1010 data104,133,247,142,0,2,88,96,-1

