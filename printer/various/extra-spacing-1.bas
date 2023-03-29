0 rem bug #1848
30 rem test 1
35 open1,4:open2,4,0:open3,4,7
40 fori=1to69step3
45 print#1,"{RVSON} {RVSOFF} a";i
50 print#2,"{RVSON} {RVSOFF} b";i+1
55 print#3,"{RVSON} {RVSOFF} C";i+2
60 nexti
65 close1:close2:close3
70 print"test 1 done"
999 poke55295,0:rem success

