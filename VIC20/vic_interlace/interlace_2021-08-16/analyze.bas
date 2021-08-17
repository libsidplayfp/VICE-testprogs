10 f$="nolace"
11 remf$="lace top"
12 remf$="lace bot"
13 n$=chr$(0):dn=peek(186)
14 open2,dn,2,"9004 "+f$+",p,r":open3,dn,3,"9003 "+f$+",p,r":open4,dn,4,f$+".txt,s,w"
15 get#2,a$,a$
16 get#3,b$,b$
17 ov=-1:cn=0
18 forp=-1to0
19 get#2,a$:p1=st=0
20 get#3,b$:p2=st=0
21 li=2*asc(a$+n$)-((asc(b$+n$)and128)<>0)
22 ifli<>ovthengosub28:ov=li:cn=1:goto24
23 cn=cn+1
24 p=p1andp2:next
25 gosub28
26 close4:close3:close2
27 end
28 ifcn=0thenreturn
29 li$=right$("000"+mid$(str$(ov),2),3)
30 cn$=right$("000"+mid$(str$(cn),2),3)
31 print#4,"line "+li$+" / cycles "+cn$
32 return
