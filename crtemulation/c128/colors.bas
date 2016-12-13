    0 fast:print"{clr}";:graphic 5:print"{clr}";:color 0, 1: color 1, 1:color 2, 1: color 3, 1: color 4, 1: color 6, 1
    1 x=8:y=4:gosub100
    2 x=2:y=10:gosub100
    3 x=9:y= 7:gosub100
    4 x=5:y=13:gosub100
    5 x=11:y= 3:gosub100
    6 x=6:y=14:gosub100
    8 print "{rvof} ":print" "
   10 x=1:y=1:gosub100
   11 x=15:y=15:gosub100
   12 x=12:y=12:gosub100
   99 color 5,1+1:goto99
  100 color 5,1+x:print"{rvon}";:fori=0to39:print" ";:next
  101 color 5,1+y:fori=0to39:print" ";:next
  102 color 5,1+x:fori=0to39:print" ";:next
  103 color 5,1+y:fori=0to39:print" ";:next
  199 return

