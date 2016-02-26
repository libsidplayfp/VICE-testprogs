
    0 rem $2d-45
    1 rem $2f-47
    2 rem $31-49
    3 rem $ae-174

    5 poke 53280,5

   10 a=peek(45):b=peek(46):c=peek(174):d=peek(175)
   20 print a,b,c,d
   30 print a+(256*b)
   40 print c+(256*d)

 100 if a <> 40 or b <> 9 then poke 53280,10
 101 if c <> 40 or d <> 9 then poke 53280,10

 990 if (peek(53280) and 15) = 5 then poke 55295,0:goto 999
 991 poke 55295,255
 999 goto 999
