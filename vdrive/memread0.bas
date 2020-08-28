99 rem check that memread with zero length sends 256 bytes
100 poke646,1:print chr$(147)
900 a = 65024 : rem table of error messages
1000 hi = int (a/256): lo = a - (hi * 256)

1010 open 1,8,15
1020 print#1,"m-r"chr$(lo)chr$(hi)chr$(0)

1025 for i = 0 to 256
1030 get#1,a$
1040 b = asc(a$+chr$(0))
1043 if st<>0 then poke 55296+i,10
1044 poke 1024+i,b
1045 rem print st;i; b
1046 next

2025 for i = 0 to 256
2030 get#1,a$
2040 b = asc(a$+chr$(0))
2043 if st<>0 then poke 55296+(7*40)+i,10
2044 poke 1024+(7*40)+i,b
2045 rem print st;i; b
2046 next
2090 close 1

3010 open 1,8,15
3020 print#1,"m-r"chr$(lo)chr$(hi)

3025 for i = 0 to 256
3030 get#1,a$
3040 b = asc(a$+chr$(0))
3043 if st<>0 then poke 55296+(14*40)+i,10
3044 poke 1024+(14*40)+i,b
3045 rem print st;i; b
3046 next
3090 close 1

