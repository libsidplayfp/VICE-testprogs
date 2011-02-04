

100 a = 119: gosub 1000: print "dev: (40) ";b

200 for a = 65529 to 65535
250 gosub 1000: print "rom: ";b
300 next

400 print "(5 1 255 160 234 103 254)"

999 end

1000 hi = int (a/256): lo = a - (hi * 256)
1010 open 1,8,15
1020 print#1,"m-r"chr$(lo)chr$(hi)chr$(1)
1030 get#1,a$
1040 b = asc(a$+chr$(0))
1050 close 1:return
