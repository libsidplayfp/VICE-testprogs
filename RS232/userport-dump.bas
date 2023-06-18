
0 poke384,173:poke385,1:poke386,221:poke387,133:poke388,2:poke389,96
;10 open2,2,0,chr$(6)+chr$(0): rem 300 8n1 3 wire
;10 open2,2,0,chr$(6)+chr$(1): rem 300 8n1 with hw handshake
10 open2,2,0,chr$(8)+chr$(1): rem 1200 baud 8N1 with hw handshake
20 get#2,i$:s1=st:sys384:n=peek(2)and152: if (m<>n)or(s1<>s2)or(len(i$)<>0) then gosub 200
50 get a$:ifa$<>""then print#2,a$;:printa$;
100 goto20 

200 m = n:s2=s1
25 print "dsr"; (n and 128) / 128 ;
25 print "dcd"; (n and 16) / 16 ;
25 print "ri"; (n and 8) / 8 ;
30 print (s1 and 128) / 128 ;"{left}";
30 print (s1 and 64) / 64 ;
;30 print (s1 and 32) / 32 ;
30 print ".";
30 print (s1 and 16) / 16 ;"{left}";
30 print (s1 and 8) / 8 ;"{left}";
30 print (s1 and 4) / 4 ;"{left}";
30 print (s1 and 2) / 2 ;"{left}";
30 print (s1 and 1) / 1;
40 print " ";i$;" "
230 return
