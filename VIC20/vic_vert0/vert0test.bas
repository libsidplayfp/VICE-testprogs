   10 poke56,28:clr:poke648,28:sys58648:rem screen ram @ $1c00
   20 poke36865,0:rem vertical pos=0
   30 a=160:gosub998
   40 a=32:gosub998
   50 a=102:gosub998
   60 poke36865,peek(60901)
   70 end
  998 fori=0to22:poke7168+506+i,a:poke37888+506+i,0:next:rem poke extra line
  999 poke198,0:wait198,1:return

