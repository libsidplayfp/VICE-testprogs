    5 poke55,0:poke56,24:clr:a=peek(60900):dn=peek(186)
    6 dim c$(16)
   11 ifa=12thensys57809"luma pal",dn,1:poke780,0:sys65493
   12 ifa=5thensys57809"luma ntsc",dn,1:poke780,0:sys65493
   14 v = 6144+2
   16 print"{clr}{wht}*** luma test v1 ***"
   17 fort=1to16:readc$(t):next
   18 print"{home}{down}":fort=1to6:readc:printc,c$(c+1):pokev+t,c*16or8:next
   19 print"{blk}";:fort=7to16:readc:printc,c$(c+1):pokev+t,c*16or8:next
   20 sys6144

   25 data "black","white","red","cyan","purple","green","blue","yellow"
   26 data "orange","l. orange","l. red","l. cyan"
   27 data "l. purple","l. green","l. blue","l. yellow"
   30 data 0,6,2,4,8,5,14,10,3,9,12,7,13,11,15,1

   100 goto 100

; 0 - black
; 1 - white
; 2 - red
; 3 - cyan
; 4 - purple
; 5 - green
; 6 - blue
; 7 - yellow
; 8 - orange
; 9 - light orange
; 10 - light red
; 11 - light cyan
; 12 - light purple
; 13 - light green
; 14 - light blue
; 15 - light yellow
