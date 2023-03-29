0 rem bug #1848
75 rem test 2
80 fori=1to69step3
85 open1,4:open2,4,0:open3,4,7
90 print#1,"{RVSON} {RVSOFF} a";i
95 print#2,"{RVSON} {RVSOFF} b";i+1
100 print#3,"{RVSON} {RVSOFF} C";i+2
105 close1:close2:close3
110 nexti
115 print"test 2 done"
999 poke55295,0:rem success

