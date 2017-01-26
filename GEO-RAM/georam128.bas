   10 printchr$(147)
   20 print"geo-ram present:";
   30 sys7424
   40 ifpeek(144)=0thenprint"no":end
   50 print"yes"
   60 print"geo-ram size:";
   70 sys7680
   80 printpeek(144)*64;"kb"
