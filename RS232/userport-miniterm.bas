; the following is a "mini terminal" that can be used to test a RS232 connection
;10 open2,2,0,chr$(6)+chr$(0): rem 300 8n1 3 wire
;10 open2,2,0,chr$(6)+chr$(1): rem 300 8n1 with hw handshake
10 open2,2,0,chr$(8)+chr$(1): rem 1200 baud 8N1 with hw handshake
20 get#2,i$:if i$<>"" then printi$;
30 get a$:if a$<>"" then printa$;:print#2,a$;
50 goto20 
