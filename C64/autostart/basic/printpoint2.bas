
    0 rem $2d-45
    1 rem $2f-47
    2 rem $31-49
    3 rem $ae-174

    5 poke 53280,5

   10 print peek(45)+(256*peek(46)):if peek(45)+(256*peek(46)) <> 2452 then poke 53280,10
   20 print peek(47)+(256*peek(48)):if peek(47)+(256*peek(48)) <> 2452 then poke 53280,10
   30 print peek(49)+(256*peek(50)):if peek(49)+(256*peek(50)) <> 2452 then poke 53280,10
   40 print peek(174)+(256*peek(175)):if peek(174)+(256*peek(175)) <> 2452 then poke 53280,10

 990 if (peek(53280) and 15) = 5 then poke 55295,0:goto 999
 991 poke 55295,255
 999 goto 999
