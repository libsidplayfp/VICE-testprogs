0 print "{clr}via2 - set timers to 0"
1 print "9218  t2l   ";:poke 37156+4,0:gosub 100:print "ok"
2 print "9219  t2h   ";:poke 37156+5,0:gosub 100:print "ok"
5 print "9214  t1l   ";:poke 37156+0,0:gosub 100:print "ok"
3 print "9216  t1ll  ";:poke 37156+2,0:gosub 100:print "ok"
6 print "9215  t1h   ";:poke 37156+1,0:gosub 100:print "ok"
4 print "9217  t1lhh ";:poke 37156+3,0:gosub 100:print "ok"
10 print "all ok.":end
100 for i = 0 to 1000:next:return:rem wait a bit
