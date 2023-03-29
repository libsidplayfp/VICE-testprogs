0 rem bug #1848
5 forn=0to2
10 open1,4
20 open2,4,0
30 open3,4,7
40 fora=1to10
50 print#1,"test 1,4 no.";a
60 print#2,"test 2,4,0 no.";a
70 print#3,"test 3,4,7 no.";a
80 nexta
90 print#1,"last test 1,4 ";
100 print#2,"last test 2,4,0 ";
110 print#3,"last test 3,4,7"
130 close1:close2:close3
140 next
999 poke55295,0:rem success

