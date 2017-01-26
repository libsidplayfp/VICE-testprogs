    5 ad=peek(44)*256
   10 printchr$(147)
   20 print"geo-ram present:";
   30 sysad+256
   40 ifpeek(144)=0thenprint"no":end
   50 print"yes"
   60 print"geo-ram size:";
   70 sysad+512
   80 printpeek(144)*64;"kb"
