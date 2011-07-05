1000 un=peek(186):de=0:gosub9010
1002 if de then print "disk error.":end
1005 print "got: ";
1010 print asc(a$+chr$(0));asc(b$+chr$(0))
1005 print "expected: 18 1"
1999 end
9000 rem directory checker
9010 open15,un,15:open2,un,2,"$":rem buffer is always #2
9020 if st then de=1:goto9070:rem error
9030 close2: open2,un,2,"#": rem open buffer #2, which contains dir
9040 print#15,"b-p";2;0:get#2,a$
9050 print#15,"b-p";2;1:get#2,b$
9060 if st then de=1:goto9070:rem error
9070 close2:close15:return
