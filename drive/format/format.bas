5 print "{clr}formatting disk..."
10 open 1,8,15,"n:test,01":close 1
20 open 1,8,15: input#1, a,b$,c,d: close 1
30 print a;",";b$;",";c;",";d
40 if a <> 0 then 100
41 print "saving program..."
42 save "format",8,1
43 open 1,8,15: input#1, a,b$,c,d: close 1
44 print a;",";b$;",";c;",";d
45 if a <> 0 then 100
50 print "passed"
60 poke 53280,13:poke 55295,0
99 end
100 print "failed"
110 poke 53280,10:poke 55295,255
