    0 clr:poke59468,12
    1 rem hi-res basic code copyright (c) 1980 glen fisher
    2 rem hi-res machine code copyright(c) 1980 dave dixon
    3 rem 5976 highbury st.
    4 rem vancouver b.c. canada v6n 1z1
    5 :
    6 rem cursor #18, march, 1980
    7 rem box 550, goleta, ca. 93017
    8 rem lines 61000-65000 (c) 1980 cursor magazine
    9 :
   10 rem as of whenever
   90 pg$="hi-res":nm$="18":gosub62000
  100 dimrw(40),cl(9):mr=40:mc=10
  200 ml=3828:i=ml
  210 forn=0to39
  220 ifpeek(i)<>162theni=i+1:goto220
  230 rw(n)=i+1:i=i+50:nextn
  240 fori=0to9:cl(i)=2*i
  250 ifi>2thencl(i)=5*i
  260 nexti
  300 ifqv=2thenml=ml+27
  400 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{rght}{rght}h position [+step] length char
  410 print"{down}{rght}{rght}v position [+step] length char
  420 print"{down}{rght}{rght}p position char
  430 print"{down}{rght}{rght}f char
  440 print"{down}{rght}{rght}s position char
  450 print"{down}{rght}{rght}q
  460 print"{down}{rght}{rght}{rght}{rght}{rght}{rght}{rght}don't type the brackets.
  470 print"{down}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}char may be [rvs]char
  500 sysml
 1000 print"{home}{down}{down}{down}{down}{down}                                       {up}":print">";
 1010 gosub60000
 1020 fori=0to4:a$(i)="":nexti
 1030 fori=0to4
 1040 ifin$<>""thenifasc(in$)=32thenin$=mid$(in$,2):goto1040
 1050 ifin$=""then1200
 1060 forj=1tolen(in$)
 1070 ifmid$(in$,j,1)=" "then1090
 1080 nextj:a$(i)=in$:goto1200
 1090 a$(i)=left$(in$,j-1):in$=mid$(in$,j)
 1100 nexti
 1200 c$="hvsfpq?":a$=left$(a$(0),1):a=1
 1210 fori=1tolen(c$)
 1220 ifmid$(c$,i,1)=a$then1240
 1230 nexti:goto1000
 1240 onigoto2100,2200,2300,2400,2500,2600,2700
 2100 gosub8000:gosub8100:gosub8200:gosub9000
 2105 ifl<1ors<1then1000
 2110 fori=1tol
 2120 ifr>=mrthen1000
 2130 ifc>=mcthenc=c-mc:r=r+1:goto2120
 2140 pokerw(r)+cl(c),ch:c=c+s
 2150 nexti
 2160 goto1000
 2200 gosub8000:gosub8100:gosub8200:gosub9000
 2205 ifl<1ors<1then1000
 2210 fori=1tol
 2220 ifc>=mcthen1000
 2230 ifr>=mrthenr=r-mr:c=c+1:goto2220
 2240 pokerw(r)+cl(c),ch:r=r+s
 2250 nexti
 2260 goto1000
 2300 gosub8000:gosub9000
 2310 fori=0to7:j=r+i
 2320 ifj>=mrthen1000
 2330 pokerw(j)+cl(0),ch
 2340 forc=1to8:pokerw(j)+cl(c),32
 2350 ifc=i+1thenpokerw(j)+cl(c),ch
 2360 nextc
 2370 nexti
 2380 goto1000
 2400 gosub9000
 2410 forr=0tomr-1
 2420 forc=0tomc-1
 2430 pokerw(r)+cl(c),ch
 2440 nextc:nextr
 2450 goto1000
 2500 gosub8000
 2510 gosub9000
 2515 ifp<0then1000
 2520 pokerw(r)+cl(c),ch
 2530 goto1000
 2600 sysml
 2610 print"{clr}":end
 8000 p=val(a$(a)):a=a+1:gosub9100
 8005 ifr<0orr>=mrorc<0orc>=mcthenp=-1
 8010 return
 8100 ifleft$(a$(a),1)<>"+"thens=1:return
 8110 s=val(a$(a)):a=a+1
 8130 return
 8200 l=val(a$(a)):a=a+1:return
 8210 t=int(l/10):l=l-10*t:ifl>8thenl=8
 8220 l=9*t+l:return
 9000 a$=a$(a)+" ":t=asc(a$):ift=18thent=asc(mid$(a$,2))
 9010 ch=t and63:ift>127thench=ch+64
 9020 ifasc(a$)=18thench=ch+128
 9030 return
 9100 r=int(p/10):c=p-10*r:return
 60000 in$=" ":zt=ti:zc=2:zd$=chr$(20)
 60010 getz$:ifz$<>""then60070
 60020 ifzt<=tithenprintmid$(" {CBM-+}",zc,1);"{left}";:zc=3-zc:zt=ti+15
 60030 goto60010
 60070 z=asc(z$):zl=len(in$):if(zand127)<32thenprint" {left}";:goto60110
 60090 ifzl>254then60010
 60100 in$=in$+z$:printchr$(z);zd$;chr$(z);"{rvof}";
 60110 ifz=13thenin$=mid$(in$,2):printcr$;:return
 60120 ifz=20andzl>1thenin$=left$(in$,zl-1):print"{left}";:goto60010
 60130 ifz=141thenz$=chr$(-20*(zl>1)):forz=2tozl:printz$;:nextz:goto60000
 60140 ifz=18thenprint"{rvon}";:z=z+64:goto60090
 60150 goto60010
 60300 print"{clr}":clr:gosub60400:goto100
 60400 qv=2:cr$=chr$(13)
 60410 ifpeek(50000)=0thenqv=1
 60430 return
 60500 fori=1to10:print"{SHIFT-*}{SHIFT-*}{SHIFT-*}{SHIFT-*}";:nexti:return
 62000 print"{clr}{down}{down}";tab(9);"cursor #";nm$;"  ";pg$
 62010 print"{down} copyright (c)1980  by  dave dixon
 62020 printtab(21);"and glen fisher"
 62025 gosub60500
 62030 print"{down}high resolution pet graphics
 62050 print"{down}{down}{down}press {rvon}return{rvof} to begin."
 62060 gett$:ift$=""then62060
 62070 goto60300

