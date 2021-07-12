   10 poke55,0:poke56,24:clr:a=peek(60900):dn=peek(186)
   11 ifa=12thensys57809"pal engine",dn,1:poke780,0:sys65493
   12 ifa=5thensys57809"ntsc engine",dn,1:poke780,0:sys65493
   13 ad=6656:fort=0to193:pokead+t,8:pokead+256+t,8:pokead+512+t,8:pokead+768+t,8:next
   14 fors=0to15:v=16*s+8:b=ad+8*s+52:fort=0to7
   15 pokeb+t,v:pokeb+256+t,v:pokeb+512+t,v:pokeb+768+t,v:next:next
   16 sys6144:print"{clr}{wht}*** {red}c{yel}o{grn}l{cyn}o{blu}u{pur}r{wht} test v1 ***"
   17 print"{home}{down}{down}bwrcpgby{down}{left}{left}{left}{left}{left}{left}{left}{left}lheyurle{down}{left}{left}{left}{left}{left}{left}{left}{left}ktdnrnul"
   18 print"{home}{down}{down}{down}{down}{down}{down}";:fort=0to15:reada$:printtab(11)a$:next
   19 print"{home}{down}{down}{down}{down}{down}{down}";:fort=0to15:print"{blk}{SHIFT--}{wht}{SHIFT--}{red}{SHIFT--}{cyn}{SHIFT--}{pur}{SHIFT--}{grn}{SHIFT--}{blu}{SHIFT--}{yel}{SHIFT--}":next:gosub23
   20 print"{home}{down}{down}{down}{down}{down}{down}";:fort=0to15:print"{blk}{CBM-+}{wht}{CBM-+}{red}{CBM-+}{cyn}{CBM-+}{pur}{CBM-+}{grn}{CBM-+}{blu}{CBM-+}{yel}{CBM-+}":next:gosub23
   21 print"{home}{down}{down}{down}{down}{down}{down}";:fort=0to15:print"{rvon}{blk}{CBM-K}{wht}{CBM-K}{red}{CBM-K}{cyn}{CBM-K}{pur}{CBM-K}{grn}{CBM-K}{blu}{CBM-K}{yel}{CBM-K}":next:gosub23
;   22 sys64850:sys65017:sys58648:end
   22 poke646,1:restore: goto 17
   23 geta$:on-(a$="")goto23:return
   24 data "{wht}black","{blk}white","{wht}red","{blk}cyan","{wht}purple","{blk}green","{wht}blue","{blk}yellow"
   25 data "{wht}orange","{blk}l. orange","{blk}l. red","{blk}l. cyan"
   26 data "{blk}l. purple","{blk}l. green","{blk}l. blue","{blk}l. yellow"
   27 :
   28 rem ** colour test v1 written 2011-05-12 by michael kircher

