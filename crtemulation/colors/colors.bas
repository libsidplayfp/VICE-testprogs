    0 print"{clr}";: x=2:y=10:gosub100
    1 x=9:y= 8:gosub100
    2 x=0:y= 7:gosub100
    3 x=5:y=13:gosub100
    4 x=0:y= 3:gosub100
    5 x=6:y=14:gosub100
    6 x=4:y= 0:gosub100
    9 print
   10 x=1:y=1:gosub100
   11 x=15:y=15:gosub100
   12 x=12:y=12:gosub100
   13 x=11:y=11:gosub100
   99 poke646,1:poke53280,0:poke53281,0:goto99
  100 poke646,x:fori=0to19:print"{rvon} ";:next
  101 poke646,y:fori=0to19:print"{rvon} ";:next
  102 poke646,x:fori=0to19:print"{rvon} ";:next
  103 poke646,y:fori=0to19:print"{rvon} ";:next
  199 return

